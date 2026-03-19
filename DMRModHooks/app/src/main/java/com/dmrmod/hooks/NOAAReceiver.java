package com.dmrmod.hooks;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import de.robv.android.xposed.XposedBridge;

/**
 * NOAA APT (Automatic Picture Transmission) receiver.
 *
 * Processes incoming PCM audio from the radio, AM-demodulates the 2400 Hz
 * subcarrier, resamples to the APT working rate (4160 Hz), detects line sync,
 * and assembles a Bitmap incrementally — one scan line at a time.
 *
 * Usage
 * -----
 *   NOAAReceiver rx = NOAAReceiver.getInstance(context);
 *   rx.reset();
 *   rx.setLineDecodeCallback(...)
 *   rx.setImageCompleteCallback(...)
 *   // ... in PCM hook:
 *   rx.processAudio(audioBytes, length);
 *
 * Architecture
 * ------------
 *   Input  →  AM demod (I/Q mix + IIR LPF)  →  resample to 4160 Hz
 *          →  calibration (first 8 lines, find sync offset)
 *          →  line extract (2080 APT samples per line)
 *          →  pixel extract (909 px Channel A, 909 px Channel B)
 *          →  Bitmap update  →  callback / auto-save
 *
 * NOAA satellite frequencies (VHF):
 *   NOAA-15  137.620   MHz
 *   NOAA-18  137.9125  MHz
 *   NOAA-19  137.100   MHz  (most active as of 2025)
 *
 * APT line structure (2080 samples @ 4160 Hz, 2 lines/second):
 *   Sync A   (39)  — 1040 Hz burst
 *   Space A  (47)  — black reference
 *   Image A (909)  — Channel A pixels
 *   Telem A  (45)  — calibration wedges
 *   Sync B   (39)  — 832 Hz burst
 *   Space B  (47)  — black reference
 *   Image B (909)  — Channel B pixels
 *   Telem B  (45)  — calibration wedges
 */
public class NOAAReceiver {

    private static final String TAG = "DMRModHooks-NOAA";

    // -----------------------------------------------------------------------
    // APT constants
    // -----------------------------------------------------------------------
    private static final int    APT_RATE         = 4160;
    private static final int    SAMPLES_PER_LINE = 2080;
    private static final double SUBCARRIER_HZ    = 2400.0;

    // Pixel offsets within a 2080-sample line (identical to Python decoder)
    private static final int IMAGE_A_START  = 86;    // SYNC_A(39) + SPACE_A(47)
    private static final int IMAGE_A_LENGTH = 909;
    private static final int IMAGE_B_START  = 1126;  // 86+909+45+39+47
    private static final int IMAGE_B_LENGTH = 909;

    /** Combined width of both channels side-by-side */
    private static final int IMAGE_TOTAL_WIDTH = IMAGE_A_LENGTH + IMAGE_B_LENGTH; // 1818

    /** Maximum lines to decode before the image is considered complete (~15 min pass) */
    private static final int MAX_IMAGE_LINES = 1800;

    /** Number of lines to collect for sync calibration before decoding begins. */
    private static final int SYNC_CALIB_LINES = 8;

    /**
     * Per-line sync re-lock search half-window (APT samples).
     * After each decoded line, the decoder searches ±SYNC_MARGIN around the
     * expected sync position to correct accumulated rate drift.  30 samples
     * at 4160 Hz = 7.2 ms — more than enough for any realistic clock error.
     */
    private static final int SYNC_MARGIN = 30;

    // -----------------------------------------------------------------------
    // Color mode constants
    // -----------------------------------------------------------------------
    public static final int COLOR_GRAY    = 0;  // Grayscale (default)
    public static final int COLOR_THERMAL = 1;  // Ch A gray + Ch B thermal palette
    public static final int COLOR_MSA     = 2;  // Multi-Spectral Analysis (Ch A+B combined)

    /**
     * Thermal IR false-color LUT (256 ARGB entries).
     * Maps pixel brightness (0=coldest/dark, 255=warmest/bright) to color.
     * Meteorological convention: cold cloud tops  →  white/blue,
     *                            warm surface     →  orange/red.
     */
    private static final int[] THERMAL_LUT = new int[256];
    static {
        // Color stops: { pixelValue, R, G, B }
        int[][] stops = {
            {  0, 255, 255, 255},  // white       — coldest / highest cloud tops
            { 40, 200, 230, 255},  // pale blue   — cold clouds
            { 80, 100, 160, 255},  // blue        — mid-cold
            {110,   0, 200, 200},  // cyan        — upper troposphere
            {140,   0, 200, 100},  // green       — mid atmosphere / cold land
            {170, 180, 255,   0},  // yellow-green — warm land
            {200, 255, 180,   0},  // orange      — warmer land
            {225, 255,  80,   0},  // red-orange  — warm surface
            {255, 120,   0,   0},  // dark red    — warmest (sea surface)
        };
        for (int s = 0; s < stops.length - 1; s++) {
            int x0 = stops[s][0],  r0 = stops[s][1],  g0 = stops[s][2],  b0 = stops[s][3];
            int x1 = stops[s+1][0],r1 = stops[s+1][1],g1 = stops[s+1][2],b1 = stops[s+1][3];
            for (int x = x0; x <= x1; x++) {
                float t = (x1 > x0) ? (float)(x - x0) / (x1 - x0) : 0f;
                int r = Math.round(r0 + t * (r1 - r0));
                int g = Math.round(g0 + t * (g1 - g0));
                int b = Math.round(b0 + t * (b1 - b0));
                THERMAL_LUT[x] = 0xFF000000 | (r << 16) | (g << 8) | b;
            }
        }
    }

    // -----------------------------------------------------------------------
    // Instance / singleton
    // -----------------------------------------------------------------------
    private static NOAAReceiver instance;
    private Context context;

    public static synchronized NOAAReceiver getInstance(Context ctx) {
        if (instance == null) {
            instance = new NOAAReceiver(ctx.getApplicationContext());
        }
        return instance;
    }

    private NOAAReceiver(Context ctx) {
        this.context = ctx;
    }

    // -----------------------------------------------------------------------
    // Callbacks
    // -----------------------------------------------------------------------

    /**
     * Fires every 30 decoded lines (≈ once per 15 seconds) with a partial Bitmap.
     */
    public interface LineDecodeCallback {
        void onLineDecoded(int lineNumber, Bitmap snapshot);
    }

    /**
     * Fires when the image is saved to disk (auto-save every 300 lines / ~2.5 min).
     */
    public interface ImageSavedCallback {
        void onImageSaved(String filePath, int totalLines);
    }

    private LineDecodeCallback  lineCallback;
    private ImageSavedCallback  saveCallback;
    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    public void setLineDecodeCallback(LineDecodeCallback cb)  { lineCallback = cb; }
    public void setImageSavedCallback(ImageSavedCallback cb)  { saveCallback  = cb; }

    // -----------------------------------------------------------------------
    // AM demodulation state  (I/Q method)
    // -----------------------------------------------------------------------

    /** Input PCM sample rate (set at first processAudio call or by setInputRate). */
    private int    inputRate   = 16000;
    private double ncoPhase    = 0.0;
    private double iLpf        = 0.0;   // I low-pass filter, stage 1
    private double qLpf        = 0.0;   // Q low-pass filter, stage 1
    private double iLpf2       = 0.0;   // I low-pass filter, stage 2
    private double qLpf2       = 0.0;   // Q low-pass filter, stage 2

    /**
     * Two-pole IIR low-pass: two cascaded first-order stages with the same alpha.
     * fc ≈ 1000 Hz at 16000 Hz gives 12 dB/oct rolloff — suppresses the 4800 Hz
     * double-frequency artifact (~25 dB rejection vs ~12 dB for single-pole).
     * alpha = 1 - exp(-2π × fc / fs)
     * At fc=1000, fs=16000: alpha ≈ 0.33
     * Recomputed when inputRate changes.
     */
    private double lpfAlpha = 1.0 - Math.exp(-2.0 * Math.PI * 1000.0 / 16000.0);  // ≈ 0.33

    /** NCO phase increment per input sample: 2π × SUBCARRIER / inputRate */
    private double ncoIncrement = 2.0 * Math.PI * SUBCARRIER_HZ / 16000.0;

    /** Resampler accumulator and step.  step = APT_RATE / inputRate. */
    private double resampleAccum = 0.0;
    private double resampleStep  = (double) APT_RATE / 16000.0;  // 0.26 for 16000 Hz

    /** Counts input samples processed during calibration phase (for logging). */
    private long calibInputSamples = 0;

    // -----------------------------------------------------------------------
    // Calibration and sync detection
    // -----------------------------------------------------------------------

    /** APT-rate samples collected before sync is determined. */
    private float[] calibBuf;
    private int     calibPos       = 0;
    private boolean syncCalibrated = false;
    private int     syncOffset     = 0;

    // -----------------------------------------------------------------------
    // Line buffer  (APT samples ready for pixel extraction)
    // -----------------------------------------------------------------------

    // Extra room on each side of the line for the per-line sync search window.
    private final float[] lineBuffer    = new float[SAMPLES_PER_LINE + 2 * SYNC_MARGIN];
    private int           lineBufferPos = 0;
    /** Expected position of sync A within lineBuffer. Reset to SYNC_MARGIN after each
     *  decoded line so that the search window is symmetric: [0 .. 2*SYNC_MARGIN]. */
    private int           lineExpectedSync = SYNC_MARGIN;

    // Per-line pixel buffer for percentile normalisation (1818 = 909 A + 909 B)
    private final float[] normBuf = new float[IMAGE_A_LENGTH + IMAGE_B_LENGTH];

    // -----------------------------------------------------------------------
    // Color mode
    // -----------------------------------------------------------------------
    private volatile int colorMode = COLOR_GRAY;

    /** Raw 8-bit grayscale values for every decoded pixel (unsigned, stored as bytes).
     *  Kept so that switching color mode can instantly re-render all existing lines. */
    private byte[] rawGrayA = null;  // MAX_IMAGE_LINES * IMAGE_A_LENGTH
    private byte[] rawGrayB = null;  // MAX_IMAGE_LINES * IMAGE_B_LENGTH

    /** Change color mode and immediately re-render all already-decoded lines. */
    public synchronized void setColorMode(int mode) {
        colorMode = mode;
        recolorBitmapPixels();
    }
    public int getColorMode() { return colorMode; }

    /** Re-render all already-decoded lines using the current colorMode. */
    private void recolorBitmapPixels() {
        if (bitmapPixels == null || rawGrayA == null || decodedLines == 0) return;
        int mode = colorMode;
        for (int ln = 0; ln < decodedLines; ln++) {
            int rowStart = ln * IMAGE_TOTAL_WIDTH;
            int grayOff  = ln * IMAGE_A_LENGTH;
            for (int i = 0; i < IMAGE_A_LENGTH; i++) {
                int aGray = rawGrayA[grayOff + i] & 0xFF;
                int bGray = rawGrayB[grayOff + i] & 0xFF;
                int aColor, bColor;
                if (mode == COLOR_THERMAL) {
                    aColor = 0xFF000000 | (aGray << 16) | (aGray << 8) | aGray;
                    bColor = THERMAL_LUT[bGray];
                } else if (mode == COLOR_MSA) {
                    int bl = 255 - bGray;
                    aColor = 0xFF000000 | (bGray << 16) | (aGray << 8) | bl;
                    bColor = THERMAL_LUT[bGray];
                } else {
                    aColor = 0xFF000000 | (aGray << 16) | (aGray << 8) | aGray;
                    bColor = 0xFF000000 | (bGray << 16) | (bGray << 8) | bGray;
                }
                bitmapPixels[rowStart + i]                  = aColor;
                bitmapPixels[rowStart + IMAGE_A_LENGTH + i] = bColor;
            }
        }
    }

    // -----------------------------------------------------------------------
    // Image building
    // -----------------------------------------------------------------------

    private int[]  bitmapPixels  = null;
    private int    decodedLines  = 0;
    private String lastSavedPath = null;

    // -----------------------------------------------------------------------
    // WAV capture (diagnostic: save first ~90s of raw PCM for PC analysis)
    // -----------------------------------------------------------------------
    private static final int WAV_CAPTURE_MAX_BYTES = 90 * 16000 * 2; // 90s @ 16kHz 16-bit mono
    private FileOutputStream wavCapStream = null;
    private String           wavCapPath   = null;
    private int              wavBytesWritten = 0;

    // -----------------------------------------------------------------------
    // Public API
    // -----------------------------------------------------------------------

    /** Call once before starting monitoring.  Resets all state. */
    public synchronized void reset() {
        ncoPhase      = 0.0;
        iLpf          = 0.0;
        qLpf          = 0.0;
        iLpf2         = 0.0;
        qLpf2         = 0.0;
        resampleAccum = 0.0;

        calibBuf      = new float[SYNC_CALIB_LINES * SAMPLES_PER_LINE];
        calibPos      = 0;
        syncCalibrated = false;
        syncOffset    = 0;
        calibInputSamples  = 0;

        lineBufferPos    = 0;
        lineExpectedSync = SYNC_MARGIN;

        rawGrayA      = null;
        rawGrayB      = null;
        bitmapPixels  = null;
        decodedLines  = 0;
        lastSavedPath = null;

        // Start WAV capture for diagnostic purposes
        startWavCapture();

        XposedBridge.log(TAG + ": reset()");
    }

    /** Call to stop monitoring (frees Bitmap memory). */
    public synchronized void stop() {
        bitmapPixels = null;
        stopWavCapture();
        XposedBridge.log(TAG + ": stop()");
    }

    /** Open a new WAV file and write the 44-byte placeholder header. */
    private void startWavCapture() {
        stopWavCapture();  // close any previous capture
        try {
            File dir = new File(Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS), "DMR/NOAA");
            dir.mkdirs();
            String ts = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date());
            File f = new File(dir, "noaa_pcm_" + ts + ".wav");
            wavCapStream    = new FileOutputStream(f);
            wavCapPath      = f.getAbsolutePath();
            wavBytesWritten = 0;
            writeWavHeader(wavCapStream, 0, inputRate); // placeholder size
            XposedBridge.log(TAG + ": WAV capture started: " + wavCapPath);
        } catch (Exception e) {
            XposedBridge.log(TAG + ": WAV capture start failed: " + e.getMessage());
            wavCapStream = null;
        }
    }

    /** Finalise and close the WAV capture file, patching the header with actual size. */
    private void stopWavCapture() {
        if (wavCapStream == null) return;
        try {
            wavCapStream.close();
            // Patch RIFF chunk size and data chunk size in the header
            RandomAccessFile raf = new RandomAccessFile(wavCapPath, "rw");
            raf.seek(4);  writeInt32LE(raf, 36 + wavBytesWritten);
            raf.seek(40); writeInt32LE(raf, wavBytesWritten);
            raf.close();
            XposedBridge.log(TAG + ": WAV capture saved: " + wavCapPath
                + "  (" + wavBytesWritten + " bytes, rate=" + inputRate + " Hz)");
        } catch (Exception e) {
            XposedBridge.log(TAG + ": WAV capture stop error: " + e.getMessage());
        }
        wavCapStream = null;
        wavCapPath   = null;
        wavBytesWritten = 0;
    }

    /** Write a standard 44-byte WAV header for 16-bit mono PCM. */
    private static void writeWavHeader(FileOutputStream out, int dataBytes, int sampleRate)
            throws IOException {
        int byteRate = sampleRate * 2;
        byte[] h = new byte[44];
        // RIFF header
        h[0]='R'; h[1]='I'; h[2]='F'; h[3]='F';
        writeLE32(h,  4, 36 + dataBytes);
        h[8]='W'; h[9]='A'; h[10]='V'; h[11]='E';
        // fmt chunk
        h[12]='f'; h[13]='m'; h[14]='t'; h[15]=' ';
        writeLE32(h, 16, 16);        // chunk size
        writeLE16(h, 20, 1);         // PCM
        writeLE16(h, 22, 1);         // channels
        writeLE32(h, 24, sampleRate);
        writeLE32(h, 28, byteRate);
        writeLE16(h, 32, 2);         // block align
        writeLE16(h, 34, 16);        // bits per sample
        // data chunk
        h[36]='d'; h[37]='a'; h[38]='t'; h[39]='a';
        writeLE32(h, 40, dataBytes);
        out.write(h);
    }
    private static void writeLE32(byte[] b, int off, int v) {
        b[off]=(byte)(v); b[off+1]=(byte)(v>>8); b[off+2]=(byte)(v>>16); b[off+3]=(byte)(v>>24);
    }
    private static void writeLE16(byte[] b, int off, int v) {
        b[off]=(byte)(v); b[off+1]=(byte)(v>>8);
    }
    private static void writeInt32LE(RandomAccessFile r, int v) throws IOException {
        r.write(v & 0xFF); r.write((v>>8)&0xFF); r.write((v>>16)&0xFF); r.write((v>>24)&0xFF);
    }

    /** Set the input PCM sample rate (call before processAudio if not 12000 Hz). */
    public void setInputRate(int rate) {
        if (rate == inputRate) return;
        inputRate    = rate;
        lpfAlpha     = 1.0 - Math.exp(-2.0 * Math.PI * 1000.0 / rate);
        ncoIncrement = 2.0 * Math.PI * SUBCARRIER_HZ / rate;
        resampleStep = (double) APT_RATE / rate;
        XposedBridge.log(TAG + ": inputRate=" + rate + "  lpfAlpha=" + String.format("%.3f", lpfAlpha));
    }

    /** Number of scan lines decoded so far. */
    public int getDecodedLines() { return decodedLines; }

    /** Status string for the monitoring UI. */
    public String getStatus() {
        if (!syncCalibrated) {
            int pct = calibBuf != null
                ? (calibPos * 100) / calibBuf.length : 0;
            return "Calibrating sync... " + pct + "%";
        }
        return "Decoding — " + decodedLines + " lines";
    }

    /**
     * Return a Bitmap snapshot of the current image (may be null if no lines yet).
     * Caller must NOT recycle the returned bitmap; a fresh one is created each call.
     */
    public synchronized Bitmap getLiveBitmap() {
        if (bitmapPixels == null || decodedLines == 0) return null;
        try {
            return Bitmap.createBitmap(
                bitmapPixels, IMAGE_TOTAL_WIDTH, decodedLines, Bitmap.Config.ARGB_8888);
        } catch (Exception e) {
            XposedBridge.log(TAG + ": getLiveBitmap error: " + e.getMessage());
            return null;
        }
    }

    // -----------------------------------------------------------------------
    // Core processing: called from PCM hook on every audio buffer
    // -----------------------------------------------------------------------

    /**
     * Process a chunk of raw PCM audio (16-bit signed little-endian, mono).
     * Thread-safe: synchronised on this instance.
     */
    public synchronized void processAudio(byte[] data, int length) {
        if (data == null || length < 2) return;
        if (calibBuf == null && !syncCalibrated) reset();

        // Capture raw PCM to WAV file for diagnostic purposes (first ~90s)
        if (wavCapStream != null && wavBytesWritten < WAV_CAPTURE_MAX_BYTES) {
            int toWrite = Math.min(length, WAV_CAPTURE_MAX_BYTES - wavBytesWritten);
            try {
                wavCapStream.write(data, 0, toWrite);
                wavBytesWritten += toWrite;
                if (wavBytesWritten >= WAV_CAPTURE_MAX_BYTES) {
                    stopWavCapture();  // Seal the file once we have enough
                }
            } catch (Exception e) {
                XposedBridge.log(TAG + ": WAV write error: " + e.getMessage());
            }
        }

        for (int i = 0; i < length - 1; i += 2) {
            // Count input samples during calibration (for logging only)
            if (!syncCalibrated) calibInputSamples++;

            // Convert 2 bytes → 16-bit signed (little-endian)
            short raw = (short) (((data[i + 1] & 0xFF) << 8) | (data[i] & 0xFF));
            double s  = raw * (1.0 / 32768.0);

            // ── I/Q AM demodulation ──────────────────────────────────────
            double cosV = Math.cos(ncoPhase);
            double sinV = Math.sin(ncoPhase);

            // Mix with quadrature references and two-pole low-pass filter
            double iMixed = s *  cosV;
            double qMixed = s * -sinV;
            iLpf  = lpfAlpha * iMixed + (1.0 - lpfAlpha) * iLpf;
            qLpf  = lpfAlpha * qMixed + (1.0 - lpfAlpha) * qLpf;
            iLpf2 = lpfAlpha * iLpf  + (1.0 - lpfAlpha) * iLpf2;
            qLpf2 = lpfAlpha * qLpf  + (1.0 - lpfAlpha) * qLpf2;

            // Advance NCO phase
            ncoPhase += ncoIncrement;
            if (ncoPhase >= 2.0 * Math.PI) ncoPhase -= 2.0 * Math.PI;

            // Envelope magnitude (from second-stage output)
            double envelope = Math.sqrt(iLpf2 * iLpf2 + qLpf2 * qLpf2);

            // ── Resample to APT rate (4160 Hz) ───────────────────────────
            // Simple polyphase accumulator (sample-and-hold)
            resampleAccum += resampleStep;
            while (resampleAccum >= 1.0) {
                pushAptSample((float) envelope);
                resampleAccum -= 1.0;
            }
        }
    }

    // -----------------------------------------------------------------------
    // Internal processing pipeline
    // -----------------------------------------------------------------------

    /**
     * Accept one APT-rate sample.  Route to calibration buffer or line buffer
     * depending on whether sync has been determined.
     */
    private void pushAptSample(float v) {
        if (!syncCalibrated) {
            // ── PHASE 1: accumulate calibration data ─────────────────────
            if (calibPos >= calibBuf.length) return; // Should not happen
            calibBuf[calibPos++] = v;

            if (calibPos >= calibBuf.length) {
                // Log calibration stats; rate correction happens post-calibration
                XposedBridge.log(TAG + ": Calib complete: calibSamples=" + calibInputSamples
                    + "  defaultResampleStep=" + String.format("%.5f", resampleStep));

                // Enough data — find sync offset
                syncOffset     = computeSyncOffset(calibBuf);
                syncCalibrated = true;
                XposedBridge.log(TAG + ": Sync calibrated, offset=" + syncOffset + " samples");

                // Replay calibration samples starting SYNC_MARGIN before the determined
                // sync offset, so sync A lands at lineExpectedSync (=SYNC_MARGIN) in the
                // line buffer — giving the per-line search window symmetric room.
                int replayStart = Math.max(0, syncOffset - SYNC_MARGIN);
                for (int j = replayStart; j < calibBuf.length; j++) {
                    pushToLineBuffer(calibBuf[j]);
                }
                calibBuf = null;   // Free 64 KB calibration buffer
            }
        } else {
            // ── PHASE 2: normal decoding ──────────────────────────────────
            pushToLineBuffer(v);
        }
    }

    /**
     * Push one APT-rate sample into the line buffer.
     *
     * A line is considered complete when we have accumulated enough samples
     * to search for sync A within ±SYNC_MARGIN of the expected position and
     * still have a full SAMPLES_PER_LINE window after the found sync.
     *
     * After each line:
     *   1. Find actual sync A position within [lineExpectedSync ± SYNC_MARGIN].
     *   2. Gently correct resampleStep (soft PLL) to kill long-term drift.
     *   3. Carry over the SYNC_MARGIN samples before the next expected sync
     *      so that the search window is symmetric for the following line.
     */
    private void pushToLineBuffer(float v) {
        lineBuffer[lineBufferPos++] = v;

        // Trigger once we have: expected-sync + full line + margin samples
        int needed = lineExpectedSync + SAMPLES_PER_LINE + SYNC_MARGIN;
        if (lineBufferPos < needed) return;

        // ── Find actual sync A within ±SYNC_MARGIN of expected position ──
        int searchStart = Math.max(0, lineExpectedSync - SYNC_MARGIN);
        int searchEnd   = Math.min(lineBufferPos - SAMPLES_PER_LINE - 1,
                                   lineExpectedSync + SYNC_MARGIN);
        int foundSync   = findSyncInRange(lineBuffer, searchStart, searchEnd);

        // No rate correction: inputRate is confirmed at 16000 Hz by spectral analysis.
        // The ±SYNC_MARGIN search window above already handles per-line timing jitter
        // without needing to modify resampleStep (which would accumulate drift).

        // ── Decode the line ───────────────────────────────────────────────
        processLine(lineBuffer, foundSync);

        // ── Carry over: keep SYNC_MARGIN samples before the next sync ────
        // Next sync expected at (foundSync + SAMPLES_PER_LINE); carry from
        // SYNC_MARGIN samples before that so sym window is preserved.
        int carryStart = foundSync + SAMPLES_PER_LINE - SYNC_MARGIN;
        int remaining  = lineBufferPos - carryStart;
        if (remaining > 0 && carryStart >= 0) {
            System.arraycopy(lineBuffer, carryStart, lineBuffer, 0, remaining);
        }
        lineBufferPos    = Math.max(0, remaining);
        lineExpectedSync = SYNC_MARGIN;  // next sync expected in the middle of the buffer
    }

    /**
     * Search buf[searchStart..searchEnd] for the position with highest
     * high-frequency energy over 39 consecutive samples (the sync A metric).
     */
    private static int findSyncInRange(float[] buf, int searchStart, int searchEnd) {
        final int syncLen = 39;
        double bestEnergy = -1.0;
        int    bestPos    = (searchStart + searchEnd) / 2;  // default: centre
        for (int pos = searchStart; pos <= searchEnd; pos++) {
            if (pos + syncLen >= buf.length) break;
            double energy = 0;
            for (int k = 0; k < syncLen - 1; k++) {
                energy += Math.abs(buf[pos + k + 1] - buf[pos + k]);
            }
            if (energy > bestEnergy) {
                bestEnergy = energy;
                bestPos    = pos;
            }
        }
        return bestPos;
    }

    /**
     * Process a complete 2080-sample APT line starting at lineStart within the buffer:
     *   - Update adaptive normalisation
     *   - Extract 909+909 pixel values
     *   - Write row into the Bitmap pixel array
     *   - Fire callbacks every 30 lines / save every 300 lines
     */
    private void processLine(float[] line, int lineStart) {
        if (decodedLines >= MAX_IMAGE_LINES) return;

        // ── Per-line percentile normalisation (1st / 99th percentile) ─────
        // Matches the Python standalone decoder exactly.
        // Collect 909 A + 909 B = 1818 image pixel values, sort, and clip.
        for (int i = 0; i < IMAGE_A_LENGTH; i++) {
            normBuf[i] = line[lineStart + IMAGE_A_START + i];
        }
        for (int i = 0; i < IMAGE_B_LENGTH; i++) {
            normBuf[IMAGE_A_LENGTH + i] = line[lineStart + IMAGE_B_START + i];
        }
        java.util.Arrays.sort(normBuf);
        // 1% of 1818 ≈ index 18;  99% ≈ index 1799
        float lineMin = normBuf[18];
        float lineMax = normBuf[1799];
        float range   = lineMax - lineMin;
        if (range < 1e-6f) return;

        // ── Lazy allocate pixel arrays ────────────────────────────────────
        if (bitmapPixels == null) {
            bitmapPixels = new int[MAX_IMAGE_LINES * IMAGE_TOTAL_WIDTH];
        }
        if (rawGrayA == null) {
            rawGrayA = new byte[MAX_IMAGE_LINES * IMAGE_A_LENGTH];
            rawGrayB = new byte[MAX_IMAGE_LINES * IMAGE_B_LENGTH];
        }

        // ── Fill pixel row (single combined loop handles A+B for all color modes) ──
        int rowStart  = decodedLines * IMAGE_TOTAL_WIDTH;
        int grayOff   = decodedLines * IMAGE_A_LENGTH;
        int mode      = colorMode;

        for (int i = 0; i < IMAGE_A_LENGTH; i++) {
            int aGray = Math.min(255, Math.max(0,
                (int)((line[lineStart + IMAGE_A_START + i] - lineMin) / range * 255.0f)));
            int bGray = Math.min(255, Math.max(0,
                (int)((line[lineStart + IMAGE_B_START + i] - lineMin) / range * 255.0f)));

            rawGrayA[grayOff + i] = (byte) aGray;
            rawGrayB[grayOff + i] = (byte) bGray;

            int aColor, bColor;
            if (mode == COLOR_THERMAL) {
                aColor = 0xFF000000 | (aGray << 16) | (aGray << 8) | aGray;
                bColor = THERMAL_LUT[bGray];
            } else if (mode == COLOR_MSA) {
                int bl = 255 - bGray;
                aColor = 0xFF000000 | (bGray << 16) | (aGray << 8) | bl;
                bColor = THERMAL_LUT[bGray];
            } else {
                aColor = 0xFF000000 | (aGray << 16) | (aGray << 8) | aGray;
                bColor = 0xFF000000 | (bGray << 16) | (bGray << 8) | bGray;
            }
            bitmapPixels[rowStart + i]                  = aColor;
            bitmapPixels[rowStart + IMAGE_A_LENGTH + i] = bColor;
        }

        decodedLines++;

        // ── Fire line-decode callback every 30 lines ──────────────────────
        if (lineCallback != null && decodedLines % 30 == 0) {
            final int    lines   = decodedLines;
            final Bitmap snap    = getLiveBitmap();
            if (snap != null) {
                uiHandler.post(new Runnable() {
                    @Override public void run() {
                        try { lineCallback.onLineDecoded(lines, snap); }
                        catch (Exception e) { XposedBridge.log(TAG + ": line callback error: " + e); }
                    }
                });
            }
        }

        // ── Auto-save every 300 lines (~2.5 min) ─────────────────────────
        if (decodedLines % 300 == 0) {
            autoSaveImage();
        }
    }

    // -----------------------------------------------------------------------
    // Sync detection
    // -----------------------------------------------------------------------

    /**
     * Determine the Sync A offset from a buffer containing at least
     * SYNC_CALIB_LINES × SAMPLES_PER_LINE APT-rate samples.
     *
     * Method mirrors the Python decoder:
     *   - Compute adjacent absolute differences (high-frequency energy)
     *   - Reshape into rows of SAMPLES_PER_LINE
     *   - Sum per column → profile
     *   - Find the SYNC_A_SAMPLES-length window with maximum sum
     *   - The two peaks (Sync A and Sync B) are 1040 samples apart;
     *     pick the smaller index as Sync A.
     */
    private static int computeSyncOffset(float[] calibBuf) {
        final int syncASamples = 39;
        final int halfLine     = SAMPLES_PER_LINE / 2;   // 1040
        int n_lines = calibBuf.length / SAMPLES_PER_LINE;

        // ── Build per-column high-frequency profile ───────────────────────
        double[] profile = new double[SAMPLES_PER_LINE];
        for (int line = 0; line < n_lines; line++) {
            int base = line * SAMPLES_PER_LINE;
            for (int col = 0; col < SAMPLES_PER_LINE - 1; col++) {
                profile[col] += Math.abs(calibBuf[base + col + 1]
                                        - calibBuf[base + col]);
            }
        }

        // ── Sliding window sum (length = SYNC_A_SAMPLES) ──────────────────
        double cumsum = 0.0;
        for (int j = 0; j < syncASamples; j++) cumsum += profile[j];

        double bestSum = cumsum;
        int    bestIdx = 0;

        for (int j = syncASamples; j < SAMPLES_PER_LINE; j++) {
            cumsum += profile[j] - profile[j - syncASamples];
            if (cumsum > bestSum) {
                bestSum = cumsum;
                bestIdx = j - syncASamples + 1;
            }
        }

        // Both Sync A (at offset P) and Sync B (at P+1040) produce peaks.
        // Sync A is always the earlier one (smaller index).
        int P1 = bestIdx;
        int P2 = (P1 + SAMPLES_PER_LINE - halfLine) % SAMPLES_PER_LINE;
        return Math.min(P1, P2);
    }

    // -----------------------------------------------------------------------
    // Image save
    // -----------------------------------------------------------------------

    /** Auto-save the current partial image to Download/DMR/NOAA/. */
    private void autoSaveImage() {
        try {
            Bitmap bmp = getLiveBitmap();
            if (bmp == null) return;

            File dir = new File(
                Environment.getExternalStoragePublicDirectory(
                    Environment.DIRECTORY_DOWNLOADS),
                "DMR/NOAA");
            if (!dir.exists()) dir.mkdirs();

            String ts = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date());

            // Always save the current (possibly colored) view
            String suffix = colorMode == COLOR_THERMAL ? "_thermal"
                          : colorMode == COLOR_MSA     ? "_msa"
                          : "";
            File file = new File(dir, "NOAA_" + ts + suffix + ".png");
            try (FileOutputStream fos = new FileOutputStream(file)) {
                bmp.compress(Bitmap.CompressFormat.PNG, 100, fos);
            }
            lastSavedPath = file.getAbsolutePath();
            XposedBridge.log(TAG + ": Auto-saved " + decodedLines + " lines → " + lastSavedPath);

            // If not already grayscale, also save a _gray version
            if (colorMode != COLOR_GRAY && rawGrayA != null) {
                int savedMode = colorMode;
                colorMode = COLOR_GRAY;
                recolorBitmapPixels();
                Bitmap grayBmp = getLiveBitmap();
                colorMode = savedMode;
                recolorBitmapPixels();  // restore color

                if (grayBmp != null) {
                    File grayFile = new File(dir, "NOAA_" + ts + "_gray.png");
                    try (FileOutputStream fos = new FileOutputStream(grayFile)) {
                        grayBmp.compress(Bitmap.CompressFormat.PNG, 100, fos);
                    }
                    XposedBridge.log(TAG + ": Also saved grayscale → " + grayFile.getAbsolutePath());
                }
            }

            if (saveCallback != null) {
                final String path  = lastSavedPath;
                final int    lines = decodedLines;
                uiHandler.post(new Runnable() {
                    @Override public void run() {
                        try { saveCallback.onImageSaved(path, lines); }
                        catch (Exception e) { XposedBridge.log(TAG + ": save callback error: " + e); }
                    }
                });
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": autoSaveImage error: " + e.getMessage());
        }
    }

    /**
     * Save the final image manually (call when monitoring stops).
     * Returns the file path or null on failure.
     */
    public String saveFinalImage() {
        if (decodedLines == 0) return null;
        autoSaveImage();
        return lastSavedPath;
    }

    /** Return the path of the most recently saved image. */
    public String getLastSavedPath() { return lastSavedPath; }
}
