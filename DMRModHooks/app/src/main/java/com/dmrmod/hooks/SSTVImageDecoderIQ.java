package com.dmrmod.hooks;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.util.Log;
import com.example.dmrmodhooks.sstv.*;

/**
 * NEW SSTV Image Decoder based on robot36-2 implementation
 * Uses IQ (quadrature) baseband FM demodulation for accurate frequency tracking
 * 
 * Major improvements over previous FFT approach:
 * 1. Per-sample frequency tracking (no windowing artifacts)
 * 2. Automatic frequency offset correction
 * 3. Sync-based auto mode detection
 * 4. Exponential moving average for smooth pixels
 * 
 * Based on robot36-2 by Ahmet Inan
 */
public class SSTVImageDecoderIQ {
    private static final String TAG = "DMRModHooks-SSTV-DecoderIQ";

    private final SSTVIQDemodulator demodulator;
    private final SSTVMode.Mode mode;
    private final int sampleRate;

    // Buffers
    private float[] scanLineBuffer;
    private float[] scratchBuffer;
    private int[] pixelBuffer;

    // State
    private int currentSample;
    private int lastSyncPulseIndex;
    private float lastFrequencyOffset;

    // Robot 36 needs Y and C from adjacent lines to reconstruct YCbCr
    private int[][] robotYBuf;
    private int[][] robotCBuf;

    // ========================= STREAMING API =========================

    /** Callback fired after each decoded scan line during streaming decode. */
    public interface LineDecodeCallback {
        /**
         * Called from the audio-processing thread after each line is decoded.
         * bitmap is an immutable snapshot — safe to hand to the UI thread.
         */
        void onLineDecode(int linesDecoded, int totalLines, Bitmap bitmap);
    }

    // Streaming state (populated by initStreaming; used by processChunk)
    private Bitmap currentBitmap;
    private int streamProcessedLines;
    private int streamMaxLines;
    private SSTVIQDemodulator.SyncPulseWidth streamExpectedSyncWidth;
    private int streamMinLineSamples;
    private int streamMaxLineSamples;
    private boolean streamingInitialized = false;
    private float[] streamDemodBuffer;

    /**
     * Set when a sync fires but spacing doesn't match the current mode (ms, ≥0).
     * -1 means no skip occurred during the last processChunk() call.
     * Used by SSTVReceiver for mid-stream mode-change detection.
     */
    public int lastSkippedSpacingMs = -1;

    private LineDecodeCallback lineDecodeCallback;

    public void setLineDecodeCallback(LineDecodeCallback cb) { this.lineDecodeCallback = cb; }

    public SSTVImageDecoderIQ(SSTVMode.Mode mode, int sampleRate) {
        this.mode = mode;
        this.sampleRate = sampleRate;
        this.demodulator = new SSTVIQDemodulator(sampleRate);

        // Allocate buffers sized to this mode's actual transmission duration (+10s margin).
        // ScottieDX needs ~316 seconds; other modes are far shorter.
        int maxTransmissionSamples = (int) Math.round((mode.durationMs / 1000.0 + 10.0) * sampleRate);
        int maxScanLineSamples = (int) Math.round(7.0 * sampleRate);  // 7 seconds max scan line
        scanLineBuffer = new float[maxTransmissionSamples];  // Buffer entire transmission
        scratchBuffer = new float[maxScanLineSamples];  // Scratch for single line processing
        pixelBuffer = new int[800];  // Max width

        currentSample = 0;
        lastSyncPulseIndex = 0;
        lastFrequencyOffset = 0;

        Log.d(TAG, String.format("Decoder initialized: mode=%s, sampleRate=%d", mode.name, sampleRate));
    }

    /**
     * Initialize streaming decode state.  Must be called once before processChunk().
     * Resets all decoder state — call again to restart for a new mode.
     */
    public void initStreaming() {
        int width  = getWidth(mode);
        int height = getHeight(mode);

        currentBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        currentBitmap.eraseColor(Color.BLACK);

        if (mode.visCode == SSTVMode.MODE_ROBOT_36) {
            robotYBuf = new int[height][width];
            robotCBuf = new int[height][width];
        }

        int expectedLineSamples = mode.fullLineSamples(sampleRate);
        streamMinLineSamples = (int) (expectedLineSamples * 0.60);
        streamMaxLineSamples = (int) (expectedLineSamples * 1.40);
        streamMaxLines = (mode.visCode == SSTVMode.MODE_ROBOT_24_C) ? height / 2 : height;

        switch (mode.syncFamily) {
            case SSTVMode.SYNC_FAMILY_FIVE_MS:
                streamExpectedSyncWidth = SSTVIQDemodulator.SyncPulseWidth.FIVE_MS;   break;
            case SSTVMode.SYNC_FAMILY_TWENTY_MS:
                streamExpectedSyncWidth = SSTVIQDemodulator.SyncPulseWidth.TWENTY_MS; break;
            default:
                streamExpectedSyncWidth = SSTVIQDemodulator.SyncPulseWidth.NINE_MS;   break;
        }

        currentSample       = 0;
        streamProcessedLines = 0;
        lastSyncPulseIndex  = 0;
        lastFrequencyOffset = 0;
        lastSkippedSpacingMs = -1;
        streamDemodBuffer   = new float[1024];
        streamingInitialized = true;

        Log.d(TAG, "Streaming initialized: " + mode.name);
    }

    /**
     * Process one audio chunk in streaming mode.
     * <p>
     * Runs the IQ demodulator on the chunk, appends the demodulated samples to the
     * internal scan-line buffer, and decodes any complete scan lines found.  When a
     * line is decoded the {@link LineDecodeCallback} is fired with an immutable bitmap
     * snapshot that is safe to pass to the UI thread.
     *
     * @param chunk  Raw 16-bit PCM samples (the new audio data)
     * @return {@code true} if at least one scan line was decoded this call
     */
    public boolean processChunk(short[] chunk) {
        if (!streamingInitialized) {
            Log.e(TAG, "processChunk() called before initStreaming()");
            return false;
        }
        if (isComplete()) return false;

        int len = chunk.length;

        // Grow scan-line buffer if needed (unlikely but guards against very long modes)
        if (currentSample + len > scanLineBuffer.length) {
            float[] grown = new float[(currentSample + len) * 2];
            System.arraycopy(scanLineBuffer, 0, grown, 0, currentSample);
            scanLineBuffer = grown;
        }

        // Reuse or grow the per-chunk demod scratch buffer
        if (streamDemodBuffer == null || streamDemodBuffer.length < len) {
            streamDemodBuffer = new float[len];
        }

        boolean syncDetected = demodulator.process(chunk, streamDemodBuffer);

        for (int i = 0; i < len; i++) {
            scanLineBuffer[currentSample++] = streamDemodBuffer[i];
        }

        boolean decodedAny = false;
        lastSkippedSpacingMs = -1;

        if (syncDetected) {
            boolean rightWidth = (demodulator.syncPulseWidth == streamExpectedSyncWidth);
            if (rightWidth) {
                int syncPulseIndex = currentSample - len + demodulator.syncPulseOffset;

                if (lastSyncPulseIndex > 0) {
                    int spacing = syncPulseIndex - lastSyncPulseIndex;
                    if (spacing >= streamMinLineSamples && spacing <= streamMaxLineSamples) {
                        boolean decoded = decodeScanLine(currentBitmap, streamProcessedLines,
                                lastSyncPulseIndex, spacing, lastFrequencyOffset);
                        if (decoded) {
                            streamProcessedLines++;
                            decodedAny = true;

                            // Robot 36: progressive colorization — finalize each even/odd pair
                            if (mode.visCode == SSTVMode.MODE_ROBOT_36 && streamProcessedLines % 2 == 0) {
                                finalizeRobot36Pair(currentBitmap, streamProcessedLines - 2);
                            }

                            // Fire callback with an immutable copy (thread-safe for UI)
                            if (lineDecodeCallback != null) {
                                Bitmap snap = currentBitmap.copy(Bitmap.Config.ARGB_8888, false);
                                lineDecodeCallback.onLineDecode(streamProcessedLines, streamMaxLines, snap);
                            }

                            if (streamProcessedLines % 20 == 0) {
                                Log.d(TAG, String.format("Streaming: decoded %d/%d lines",
                                        streamProcessedLines, streamMaxLines));
                            }
                        }
                    } else {
                        // Sync detected but spacing is wrong → report for mode-change detection
                        lastSkippedSpacingMs = (int) (spacing * 1000L / sampleRate);
                        Log.d(TAG, String.format("Streaming skipped sync: spacing %dms (expected ~%dms)",
                                lastSkippedSpacingMs, mode.fullLineSamples(sampleRate) * 1000 / sampleRate));
                    }
                }

                lastSyncPulseIndex  = syncPulseIndex;
                lastFrequencyOffset = demodulator.frequencyOffset;
            }
        }

        return decodedAny;
    }

    /**
     * Progressive Robot 36 colorization: convert one even/odd pair of rows
     * from YCbCr to RGB and write them into the bitmap.
     * Called after every second scan line so the live preview shows color.
     *
     * @param bitmap   The live bitmap being built
     * @param evenRow  Index of the even-numbered row (Cb data) in the pair
     */
    private void finalizeRobot36Pair(Bitmap bitmap, int evenRow) {
        if (robotYBuf == null) return;
        int maxRow = Math.min(evenRow + 2, streamProcessedLines);
        int width  = bitmap.getWidth();
        for (int y = evenRow; y < maxRow; y++) {
            if (y >= robotYBuf.length) break;
            int ei = (y % 2 == 0) ? y : Math.max(0, y - 1);
            int oi = (y % 2 == 1) ? y : Math.min(streamProcessedLines - 1, y + 1);
            if (oi >= robotCBuf.length) oi = robotCBuf.length - 1;
            for (int x = 0; x < width; x++) {
                int Y  = robotYBuf[y][x];
                int Cb = robotCBuf[ei][x];
                int Cr = robotCBuf[oi][x];
                int r = clamp((int) (Y + 1.4020 * (Cr - 128)));
                int g = clamp((int) (Y - 0.3441 * (Cb - 128) - 0.7141 * (Cr - 128)));
                int b = clamp((int) (Y + 1.7720 * (Cb - 128)));
                bitmap.setPixel(x, y, Color.rgb(r, g, b));
            }
        }
    }

    /**
     * Finalize the streaming bitmap.  Must be called once after processChunk() is
     * done (whether or not the image is complete) to apply any pending end-of-frame
     * processing (Robot 36 final YCbCr pass for the last odd-line remainder).
     */
    public void finalizeStreaming() {
        if (!streamingInitialized) return;
        if (mode.visCode == SSTVMode.MODE_ROBOT_36 && streamProcessedLines > 0) {
            // Re-run the full Robot 36 finalization to catch the last unpaired odd line
            finalizeRobot36Image(currentBitmap, streamProcessedLines);
        }
    }

    /** @return the live partial bitmap (not a copy — do not share across threads without copying) */
    public Bitmap getCurrentBitmap()  { return currentBitmap; }
    public int  getProcessedLines()   { return streamProcessedLines; }
    public int  getTotalLines()       { return streamingInitialized ? streamMaxLines : 0; }
    public boolean isComplete()       { return streamingInitialized && streamProcessedLines >= streamMaxLines; }

    // ========================= END STREAMING API =========================

    /**
     * Decode SSTV audio to image bitmap
     *
     * @param samples    Raw audio samples
     * @param startOffset Sample offset where image data begins (after VIS code)
     * @return Decoded image bitmap
     */
    public Bitmap decode(short[] samples, int startOffset) {
        Log.d(TAG, String.format("Starting decode: %d samples, offset=%d", samples.length, startOffset));

        // Ensure buffer is large enough for actual transmission length
        if (samples.length > scanLineBuffer.length) {
            Log.d(TAG, String.format("Reallocating buffer: %d → %d samples", scanLineBuffer.length, samples.length));
            scanLineBuffer = new float[samples.length];
        }

        // Create bitmap based on mode
        int width = getWidth(mode);
        int height = getHeight(mode);
        if (width <= 0 || height <= 0) {
            Log.e(TAG, "Invalid mode dimensions");
            return null;
        }

        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        bitmap.eraseColor(Color.BLACK);  // Start with black

        // Allocate Robot 36 intermediate buffers (two-pass YCbCr reconstruction)
        if (mode.visCode == SSTVMode.MODE_ROBOT_36) {
            robotYBuf = new int[height][width];
            robotCBuf = new int[height][width];
        }

        // Process audio in chunks.
        // Chunk size must be smaller than scan-line period so we don't skip syncs.
        // Scottie S2 at 16kHz: 277.5ms * 16000 = 4440 samples.  Use 1024 (64ms) to
        // guarantee at most one real sync per chunk.
        int chunkSize = 1024;
        float[] demodBuffer = new float[chunkSize];

        // Expected scan-line length derived from mode's known full-line duration (±40% tolerance)
        int expectedLineSamples = mode.fullLineSamples(sampleRate);
        int minLineSamples = (int) (expectedLineSamples * 0.60);
        int maxLineSamples = (int) (expectedLineSamples * 1.40);

        // Robot 24 Color has 120 audio lines displayed as 240 pixel rows (rowMult=2)
        int maxLines = (mode.visCode == SSTVMode.MODE_ROBOT_24_C) ? height / 2 : height;

        // Only accept sync pulses whose width matches this mode's sync family.
        // This filters out the Scottie 1.5ms separators (FIVE_MS detections) and
        // other spurious pulses, preventing junk sync positions.
        final SSTVIQDemodulator.SyncPulseWidth expectedSyncWidth;
        switch (mode.syncFamily) {
            case SSTVMode.SYNC_FAMILY_FIVE_MS:   expectedSyncWidth = SSTVIQDemodulator.SyncPulseWidth.FIVE_MS;   break;
            case SSTVMode.SYNC_FAMILY_TWENTY_MS: expectedSyncWidth = SSTVIQDemodulator.SyncPulseWidth.TWENTY_MS; break;
            default:                              expectedSyncWidth = SSTVIQDemodulator.SyncPulseWidth.NINE_MS;   break;
        }

        currentSample = 0;
        int processedLines = 0;

        for (int offset = startOffset; offset < samples.length; offset += chunkSize) {
            int len = Math.min(chunkSize, samples.length - offset);
            short[] chunk = new short[len];
            System.arraycopy(samples, offset, chunk, 0, len);

            // Demodulate chunk
            boolean syncDetected = demodulator.process(chunk, demodBuffer);

            // Accumulate demodulated samples in scan line buffer
            for (int i = 0; i < len; i++) {
                if (currentSample < scanLineBuffer.length) {
                    scanLineBuffer[currentSample++] = demodBuffer[i];
                } else {
                    Log.e(TAG, String.format("Buffer overflow! currentSample=%d >= length=%d",
                            currentSample, scanLineBuffer.length));
                    break;
                }
            }

            // Process sync pulse if detected
            if (syncDetected) {
                // Only process syncs whose width matches this mode's sync family
                boolean rightWidth = (demodulator.syncPulseWidth == expectedSyncWidth);

                if (rightWidth) {
                    int syncPulseIndex = currentSample - len + demodulator.syncPulseOffset;
                    Log.d(TAG, String.format("Sync pulse at sample %d, width=%s, offset=%.4f",
                            syncPulseIndex, demodulator.syncPulseWidth, demodulator.frequencyOffset));

                    // Decode scan line if we have a previous sync and the spacing looks right
                    if (lastSyncPulseIndex > 0) {
                        int scanLineSamples = syncPulseIndex - lastSyncPulseIndex;
                        if (scanLineSamples >= minLineSamples && scanLineSamples <= maxLineSamples) {
                            boolean decoded = decodeScanLine(bitmap, processedLines, lastSyncPulseIndex,
                                    scanLineSamples, lastFrequencyOffset);
                            if (decoded) {
                                processedLines++;
                                if (processedLines % 20 == 0) {
                                    Log.d(TAG, String.format("Decoded %d/%d lines", processedLines, height));
                                }
                            }
                        } else {
                            Log.d(TAG, String.format("Skipped line: spacing %d samples (expected %d-%d)",
                                    scanLineSamples, minLineSamples, maxLineSamples));
                        }

                        if (processedLines >= maxLines) {
                            Log.d(TAG, "All lines decoded, stopping");
                            break;
                        }
                    }

                    lastSyncPulseIndex = syncPulseIndex;
                    lastFrequencyOffset = demodulator.frequencyOffset;
                }
            }
        }

        Log.d(TAG, String.format("Decode complete: %d lines", processedLines));

        // Robot 36: two-pass YCbCr reconstruction (even lines = Cb, odd lines = Cr)
        if (mode.visCode == SSTVMode.MODE_ROBOT_36) {
            finalizeRobot36Image(bitmap, processedLines);
        }

        return bitmap;
    }

    /**
     * Decode one scan line
     */
    private boolean decodeScanLine(Bitmap bitmap, int lineNumber, int syncPulseIndex,
                                     int scanLineSamples, float frequencyOffset) {
        if (SSTVMode.isScottieMode(mode.visCode)) {
            return decodeScottieScanLine(bitmap, lineNumber, syncPulseIndex, scanLineSamples, frequencyOffset);
        } else if (SSTVMode.isMartinMode(mode.visCode)) {
            return decodeMartinScanLine(bitmap, lineNumber, syncPulseIndex, scanLineSamples, frequencyOffset);
        } else if (mode.visCode == SSTVMode.MODE_ROBOT_36) {
            return collectRobot36Line(lineNumber, syncPulseIndex);
        } else if (mode.visCode == SSTVMode.MODE_ROBOT_72 || mode.visCode == SSTVMode.MODE_ROBOT_24_C) {
            return decodeRobot72Line(bitmap, lineNumber, syncPulseIndex);
        } else if (SSTVMode.isRobotBWMode(mode.visCode)) {
            return decodeRobotBWLine(bitmap, lineNumber, syncPulseIndex);
        }
        return false;
    }

    /**
     * Decode Scottie scan line: SYNC (9ms) + SEP (1.5ms) + GREEN + SEP + BLUE + SEP + RED
     * Direct port of working standalone decoder logic.
     */
    private boolean decodeScottieScanLine(Bitmap bitmap, int lineNumber, int syncPulseIndex,
                                           int scanLineSamples, float frequencyOffset) {
        int width = bitmap.getWidth();

        // Timing from mode DB so ScottieDX (345.6ms) works automatically
        double separatorSeconds = 0.0015;
        double channelSeconds = mode.lineDurationMs / 1000.0;

        int sepSamples = (int) Math.round(separatorSeconds * sampleRate);
        int channelSamples = (int) Math.round(channelSeconds * sampleRate);

        // syncPulseIndex is at the END of the sync pulse.
        // Scottie format after sync end: SEP + GREEN + SEP + BLUE + SEP + RED
        int greenStart = syncPulseIndex + sepSamples;
        int blueStart  = greenStart + channelSamples + sepSamples;
        int redStart   = blueStart  + channelSamples + sepSamples;
        int endIndex   = redStart   + channelSamples;

        // Bounds check
        if (greenStart < 0 || endIndex > scanLineBuffer.length) {
            Log.w(TAG, String.format("Scottie bounds fail: greenStart=%d endIndex=%d bufLen=%d",
                    greenStart, endIndex, scanLineBuffer.length));
            return false;
        }

        // Decode each pixel directly from the demodulated buffer.
        // Channel name mapping (empirically determined from standalone decoder):
        //   Scottie "GREEN" position → RGB RED
        //   Scottie "BLUE"  position → RGB GREEN
        //   Scottie "RED"   position → RGB BLUE
        for (int x = 0; x < width; x++) {
            int greenIdx = greenStart + (x * channelSamples) / width;
            int blueIdx  = blueStart  + (x * channelSamples) / width;
            int redIdx   = redStart   + (x * channelSamples) / width;

            int r = scottieFreqToLevel(scanLineBuffer[greenIdx]);  // "GREEN" pos → RED
            int g = scottieFreqToLevel(scanLineBuffer[blueIdx]);   // "BLUE"  pos → GREEN
            int b = scottieFreqToLevel(scanLineBuffer[redIdx]);    // "RED"   pos → BLUE

            bitmap.setPixel(x, lineNumber, Color.rgb(r, g, b));
        }

        return true;
    }

    /**
     * Decode Martin M1/M2 scan line:
     * SYNC(4.862ms) + PORCH(0.572ms) + GREEN(channelMs) + SEP(0.572ms) + BLUE(channelMs) + SEP(0.572ms) + RED(channelMs)
     *
     * Martin uses natural channel order (R→R, G→G, B→B) unlike Scottie's cyclic shift.
     */
    private boolean decodeMartinScanLine(Bitmap bitmap, int lineNumber, int syncPulseIndex,
                                          int scanLineSamples, float frequencyOffset) {
        int width = bitmap.getWidth();

        double porchMs   = 0.572;
        double channelMs = mode.lineDurationMs;  // 146.432ms for M1, 73.216ms for M2
        double sepMs     = 0.572;

        int porchSamples   = (int) Math.round(porchMs   * sampleRate / 1000.0);
        int channelSamples = (int) Math.round(channelMs * sampleRate / 1000.0);
        int sepSamples     = (int) Math.round(sepMs     * sampleRate / 1000.0);

        // syncPulseIndex is at the END of the sync pulse.
        // Martin: PORCH + GREEN + SEP + BLUE + SEP + RED
        int greenStart = syncPulseIndex + porchSamples;
        int blueStart  = greenStart + channelSamples + sepSamples;
        int redStart   = blueStart  + channelSamples + sepSamples;
        int endIndex   = redStart   + channelSamples;

        if (greenStart < 0 || endIndex > scanLineBuffer.length) {
            Log.w(TAG, String.format("Martin bounds fail: greenStart=%d endIndex=%d bufLen=%d",
                    greenStart, endIndex, scanLineBuffer.length));
            return false;
        }

        for (int x = 0; x < width; x++) {
            int greenIdx = greenStart + (x * channelSamples) / width;
            int blueIdx  = blueStart  + (x * channelSamples) / width;
            int redIdx   = redStart   + (x * channelSamples) / width;

            int r = scottieFreqToLevel(scanLineBuffer[redIdx]);    // RED pos → R
            int g = scottieFreqToLevel(scanLineBuffer[greenIdx]);  // GREEN pos → G
            int b = scottieFreqToLevel(scanLineBuffer[blueIdx]);   // BLUE pos → B

            bitmap.setPixel(x, lineNumber, Color.rgb(r, g, b));
        }

        return true;
    }

    /**
     * Convert demodulated frequency value to pixel brightness [0..255].
     * Matches the standalone decoder's freqToLevel():
     *   -0.444 = 1500 Hz (black) → 0
     *   +0.444 = 2300 Hz (white) → 255
     */
    private static int scottieFreqToLevel(float normalized) {
        float level = (normalized + 0.444f) / 0.888f;
        if (level < 0f) level = 0f;
        if (level > 1f) level = 1f;
        return (int) (level * 255f);
    }

    /**
     * Robot 36: collect Y and C into buffers for this scan line.
     * Timing: PORCH(3ms) + Y(lineDurationMs=88ms) + SEP(4.5ms) + PORCH2(1.5ms) + C(44ms)
     * Two-pass reconstruction happens in finalizeRobot36Image() after all lines collected.
     */
    private boolean collectRobot36Line(int lineNumber, int syncPulseIndex) {
        if (robotYBuf == null || lineNumber >= robotYBuf.length) return false;
        int width = robotYBuf[0].length;

        int porchSmp  = (int) Math.round(3.0  * sampleRate / 1000.0);
        int ySmp      = (int) Math.round(mode.lineDurationMs * sampleRate / 1000.0);
        int sepSmp    = (int) Math.round(4.5  * sampleRate / 1000.0);
        int porch2Smp = (int) Math.round(1.5  * sampleRate / 1000.0);
        int cSmp      = ySmp / 2;

        int yStart = syncPulseIndex + porchSmp;
        int cStart = yStart + ySmp + sepSmp + porch2Smp;

        if (yStart < 0 || cStart + cSmp > scanLineBuffer.length) return false;

        for (int x = 0; x < width; x++) {
            robotYBuf[lineNumber][x] = scottieFreqToLevel(scanLineBuffer[yStart + (x * ySmp) / width]);
            robotCBuf[lineNumber][x] = scottieFreqToLevel(scanLineBuffer[cStart + (x * cSmp) / width]);
        }
        return true;
    }

    /**
     * Robot 36 two-pass YCbCr→RGB reconstruction.
     * Buffer index convention (even=Cb, odd=Cr):
     *   even buffer index → By = Cb
     *   odd  buffer index → Ry = Cr
     */
    private void finalizeRobot36Image(Bitmap bitmap, int lines) {
        int width = bitmap.getWidth();
        for (int y = 0; y < lines; y++) {
            int ei = (y % 2 == 0) ? y : Math.max(0, y - 1);
            int oi = (y % 2 == 1) ? y : Math.min(lines - 1, y + 1);
            for (int x = 0; x < width; x++) {
                int Y  = robotYBuf[y][x];
                int Cb = robotCBuf[ei][x];
                int Cr = robotCBuf[oi][x];
                int r = clamp((int)(Y + 1.4020 * (Cr - 128)));
                int g = clamp((int)(Y - 0.3441 * (Cb - 128) - 0.7141 * (Cr - 128)));
                int b = clamp((int)(Y + 1.7720 * (Cb - 128)));
                bitmap.setPixel(x, y, Color.rgb(r, g, b));
            }
        }
    }

    /**
     * Robot 72 / Robot 24C: decode one scan line.
     * Timing: PORCH(3ms) + Y(lineDurationMs) + SEP(4.5ms) + PORCH2(1.5ms) + Ry/Cr + SEP+PORCH2 + By/Cb
     * Robot 24C uses rowMult=2 to double pixel rows from 120→240.
     */
    private boolean decodeRobot72Line(Bitmap bitmap, int lineNumber, int syncPulseIndex) {
        int width  = bitmap.getWidth();
        int height = bitmap.getHeight();

        int porchSmp  = (int) Math.round(3.0  * sampleRate / 1000.0);
        int ySmp      = (int) Math.round(mode.lineDurationMs * sampleRate / 1000.0);
        int sepSmp    = (int) Math.round(4.5  * sampleRate / 1000.0);
        int porch2Smp = (int) Math.round(1.5  * sampleRate / 1000.0);
        int cSmp      = ySmp / 2;

        int yStart  = syncPulseIndex + porchSmp;
        int cbStart = yStart  + ySmp + sepSmp + porch2Smp;   // first chroma = Ry = Cr
        int crStart = cbStart + cSmp + sepSmp + porch2Smp;   // second chroma = By = Cb

        if (yStart < 0 || crStart + cSmp > scanLineBuffer.length) return false;

        int rowMult = (mode.visCode == SSTVMode.MODE_ROBOT_24_C) ? 2 : 1;

        for (int x = 0; x < width; x++) {
            int Y  = scottieFreqToLevel(scanLineBuffer[yStart  + (x * ySmp)  / width]);
            int Cr = scottieFreqToLevel(scanLineBuffer[cbStart + (x * cSmp)  / width]);
            int Cb = scottieFreqToLevel(scanLineBuffer[crStart + (x * cSmp)  / width]);
            int r = clamp((int)(Y + 1.4020 * (Cr - 128)));
            int g = clamp((int)(Y - 0.3441 * (Cb - 128) - 0.7141 * (Cr - 128)));
            int b = clamp((int)(Y + 1.7720 * (Cb - 128)));
            int pixel = Color.rgb(r, g, b);
            for (int row = 0; row < rowMult; row++) {
                int pixRow = lineNumber * rowMult + row;
                if (pixRow < height) bitmap.setPixel(x, pixRow, pixel);
            }
        }
        return true;
    }

    /**
     * Robot 8 / Robot 12 BW: decode one grayscale scan line.
     * Timing: PORCH(3ms) + LUMA(lineDurationMs)
     */
    private boolean decodeRobotBWLine(Bitmap bitmap, int lineNumber, int syncPulseIndex) {
        int width = bitmap.getWidth();

        int porchSmp = (int) Math.round(3.0 * sampleRate / 1000.0);
        int scanSmp  = (int) Math.round(mode.lineDurationMs * sampleRate / 1000.0);

        int scanStart = syncPulseIndex + porchSmp;
        if (scanStart < 0 || scanStart + scanSmp > scanLineBuffer.length) return false;
        if (lineNumber >= bitmap.getHeight()) return false;

        for (int x = 0; x < width; x++) {
            int Y = scottieFreqToLevel(scanLineBuffer[scanStart + (x * scanSmp) / width]);
            bitmap.setPixel(x, lineNumber, Color.rgb(Y, Y, Y));
        }
        return true;
    }

    private static int clamp(int v) { return Math.max(0, Math.min(255, v)); }

    /** Get image width for mode */
    private int getWidth(SSTVMode.Mode mode) {
        return mode.width;
    }

    /** Get image height for mode */
    private int getHeight(SSTVMode.Mode mode) {
        return mode.height;
    }
}
