package com.dmrmod.hooks;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Looper;
import java.io.ByteArrayOutputStream;
import java.util.Arrays;

import de.robv.android.xposed.XposedBridge;
import com.example.dmrmodhooks.sstv.SSTVIQDemodulator;

/**
 * SSTV Receiver - Main audio processor for SSTV decoding
 * 
 * Processes incoming audio from PCM hook, detects VIS codes, and decodes images.
 * Similar architecture to APRSReceiver but handles longer audio buffers (30-180 sec).
 */
public class SSTVReceiver {
    private static final String TAG = "DMRModHooks-SSTV-Receiver";
    
    private static SSTVReceiver instance;
    private Context context;
    
    // Audio buffering
    private DirectBAOS audioBuffer;
    // Pre-allocated work buffers for the background detection thread.
    private short[] visWorkShorts;
    private short[] autoWorkShorts;
    // Buffer lock: protects audioBuffer from concurrent access between write thread
    // and the background detection thread.
    private final Object bufferLock = new Object();
    // Cap at ~1 MB (~32 seconds at 16kHz mono 16-bit).
    private static final int MAX_BUFFER_SIZE = 1024 * 1024;
    private int sampleRate = 16000;
    
    // VIS detection state
    private SSTVVISDetector visDetector;
    private int detectedMode = SSTVMode.MODE_UNKNOWN;
    // volatile so the AudioTrack write thread sees Phase-1 results from the bg thread
    private volatile boolean visDetected = false;
    private int imageStartSample = 0;
    private volatile long lastAudioTime = 0;
    
    // Decoding state
    private SSTVMode.Mode currentMode = null;
    private int decodedLines = 0;
    private Bitmap decodedImage = null;
    
    // Callback interface for image complete
    public interface ImageDecodeCallback {
        void onImageDecoded(Bitmap image, SSTVMode.Mode mode);
    }
    private ImageDecodeCallback imageCallback = null;

    /** Fired when a VIS code has been confirmed and image decoding begins. */
    public interface VISDetectedCallback {
        void onVISDetected(SSTVMode.Mode mode);
    }
    private VISDetectedCallback visDetectedCallback = null;

    /** Fired for each decoded scan line during streaming decode. */
    public interface LineDecodeCallback {
        void onLineDecode(int linesDecoded, int totalLines, Bitmap snapshot);
    }
    private LineDecodeCallback lineDecodeCallback = null;

    /** Fired when a mid-stream SSTV mode change is detected. */
    public interface ModeChangeCallback {
        void onModeChanged(SSTVMode.Mode oldMode, SSTVMode.Mode newMode, int linesDecodedInOldMode);
    }
    private ModeChangeCallback modeChangeCallback = null;

    // Streaming decode state
    private SSTVImageDecoderIQ streamDecoder = null;
    // volatile: set by bg detection thread, read by AudioTrack write thread
    private volatile boolean streamDecoderInitialized = false;
    // Wall-clock time when Phase 2 streaming was first initialised.
    // Used to abort false detections that never produce a real scan line.
    private long streamingStartTime = 0;

    // Mid-stream mode-change detection: track last few skipped sync spacings
    private static final int MAX_SKIPPED_SPACINGS = 8;
    private final int[] recentSkippedSpacings = new int[MAX_SKIPPED_SPACINGS];
    private int skippedSpacingCount = 0;
    private int consecutiveSkips = 0;

    // End-of-transmission detection
    // Set to System.currentTimeMillis() each time a scan line is successfully decoded.
    // 0 means no lines decoded yet (use silence fallback instead).
    private long lastValidSyncTime = 0;

    // Statistics
    private long startTime = 0;
    private int totalAudioBytes = 0;

    // Background detection thread (Phase 1: VIS + auto-detect).
    // Runs independently of the AudioTrack write thread so heavy Goertzel/IQ work
    // never blocks audio delivery.
    private Thread bgDetectionThread = null;
    private volatile boolean bgStop = false;

    // Auto-detection state
    private boolean autoDetectAttempted = false;
    private int retryCount = 0;
    // Time of last auto-detect attempt (ms); used for repeating schedule after warmup
    private long lastAutoDetectAttemptTime = 0;
    // VIS detection throttle: wall-clock ms of last attempt (avoid firing every 64ms chunk).
    // Using time rather than buffer-size so buffer trims don't accidentally block detection.
    private long lastVISAttemptTimeMs = 0;

    // Timeout checker (runs every 500ms to detect transmission end)
    private Handler timeoutHandler = new Handler(Looper.getMainLooper());
    private Runnable timeoutChecker = new Runnable() {
        @Override
        public void run() {
            if (visDetected && currentMode != null) {
                long now = System.currentTimeMillis();

                // ── False-detection abort ──────────────────────────────────────────────
                // If streaming has started but zero scan lines appeared in
                // 3.5 × fullLineDurationMs, the "signal" is almost certainly noise.
                // Real SSTV produces at least one valid line within the first line period.
                if (streamDecoderInitialized && decodedLines == 0 && streamingStartTime > 0) {
                    long streamingMs = now - streamingStartTime;
                    long abortThresholdMs = (long) (currentMode.fullLineDurationMs * 3.5);
                    if (streamingMs > abortThresholdMs) {
                        XposedBridge.log(TAG + ": ⚠ No lines in "
                                + streamingMs + "ms (threshold "
                                + abortThresholdMs + "ms) — aborting false detection");
                        stopTimeoutChecker();
                        reset();
                        return;
                    }
                }

                // ── Fast path: sync-loss detection ────────────────────────────────────
                // Once at least one line has been decoded, expect the next valid sync
                // within 3 × fullLinePeriod.  This detects end-of-transmission within
                // ~3 line-periods regardless of whether the radio passes background
                // noise (which would keep lastAudioTime fresh and defeat silence check).
                if (lastValidSyncTime > 0) {
                    long msSinceLastSync = now - lastValidSyncTime;
                    // 3 missed line periods = conservatively safe margin
                    long thresholdMs = (long) (currentMode.fullLineDurationMs * 3);
                    if (msSinceLastSync > thresholdMs) {
                        XposedBridge.log(TAG + ": ⏱ Sync-loss timeout: " + msSinceLastSync
                                + "ms since last valid sync (threshold " + thresholdMs + "ms, "
                                + currentMode.name + " " + (int) currentMode.fullLineDurationMs + "ms/line)");
                        stopTimeoutChecker();
                        handleTransmissionComplete();
                        return;
                    }
                }

                // ── Fallback: audio silence detection ─────────────────────────────────
                // Covers: (a) no lines decoded yet (bad SNR / partial VIS), and
                // (b) modes where the squelch closes between transmissions.
                // Reduced from 10 s → 3 s since the sync-loss path handles normal cases.
                long silenceMs = now - lastAudioTime;
                if (silenceMs > 3000) {
                    XposedBridge.log(TAG + ": ⏱ Silence timeout – 3 s of no audio.");
                    stopTimeoutChecker();
                    handleTransmissionComplete();
                    return;
                }

                // Re-schedule at 500ms for fast sync-loss response
                timeoutHandler.postDelayed(this, 500);
            }
        }
    };
    
    public void setImageDecodeCallback(ImageDecodeCallback cb) { this.imageCallback = cb; }
    public void setVISDetectedCallback(VISDetectedCallback cb) { this.visDetectedCallback = cb; }
    public void setLineDecodeCallback(LineDecodeCallback cb)   { this.lineDecodeCallback = cb; }
    public void setModeChangeCallback(ModeChangeCallback cb)   { this.modeChangeCallback = cb; }

    private SSTVReceiver(Context context) {
        this.context = context.getApplicationContext();
        // Pre-allocate internal buffer so trimToRecent() never causes internal resize.
        this.audioBuffer = new DirectBAOS(MAX_BUFFER_SIZE + 65536);
        this.visDetector = new SSTVVISDetector(sampleRate);
        this.visWorkShorts  = new short[sampleRate * 2 + 512];
        this.autoWorkShorts = new short[sampleRate * 16 + 512];
        reset();
    }
    
    public static synchronized SSTVReceiver getInstance(Context context) {
        if (instance == null) {
            instance = new SSTVReceiver(context);
        }
        return instance;
    }
    
    /**
     * Reset decoder state (call when starting new monitoring session)
     */
    public void reset() {
        // Stop background detection thread before clearing shared state.
        bgStop = true;
        if (bgDetectionThread != null) {
            bgDetectionThread.interrupt();
            bgDetectionThread = null;
        }
        stopTimeoutChecker();
        synchronized (bufferLock) { audioBuffer.reset(); }
        detectedMode = SSTVMode.MODE_UNKNOWN;
        visDetected = false;
        imageStartSample = 0;
        currentMode = null;
        decodedLines = 0;
        totalAudioBytes = 0;
        autoDetectAttempted = false;
        retryCount = 0;
        lastAutoDetectAttemptTime = 0;
        lastVISAttemptTimeMs = 0;
        streamDecoder = null;
        streamDecoderInitialized = false;
        consecutiveSkips = 0;
        skippedSpacingCount = 0;
        lastValidSyncTime = 0;
        streamingStartTime = 0;
        startTime = System.currentTimeMillis();
        lastAudioTime = System.currentTimeMillis();
        // Start the background detection thread for Phase 1.
        bgStop = false;
        bgDetectionThread = new Thread(this::runDetectionLoop, "sstv-detect");
        bgDetectionThread.setDaemon(true);
        bgDetectionThread.start();
        XposedBridge.log(TAG + ": Decoder reset");
    }
    
    /**
     * Process incoming audio samples (called on the AudioTrack write thread).
     *
     * MUST return quickly every call (< 2 ms) — this blocks audio delivery.
     * All heavy detection (Goertzel VIS scan, IQ auto-detect) runs on bgDetectionThread.
     * Only Phase-2 per-chunk streaming decode stays here; it is ~1 ms per 1024-sample chunk.
     */
    public void processAudio(byte[] audioData, int length) {
        try {
            if (audioData == null || length <= 0) return;

            // Fast noise gate: skip true silence so the silence-fallback timeout fires.
            long rmsSum = 0;
            int sampleCount = length / 2;
            for (int i = 0; i < length - 1; i += 2) {
                short s = (short) ((audioData[i + 1] << 8) | (audioData[i] & 0xFF));
                rmsSum += (long) s * s;
            }
            if (sampleCount > 0 && Math.sqrt((double) rmsSum / sampleCount) < 80.0) return;

            lastAudioTime = System.currentTimeMillis();
            totalAudioBytes += length;

            // Append to ring buffer (synchronized — bg thread also reads this).
            synchronized (bufferLock) {
                if (audioBuffer.size() + length > MAX_BUFFER_SIZE) {
                    audioBuffer.trimToRecent(sampleRate * 18 * 2);  // keep 18s
                }
                audioBuffer.write(audioData, 0, length);
            }

            // Phase 2: once VIS is confirmed, stream-decode each arriving chunk inline.
            // feedChunkToDecoder() processes 1024 samples per call — always < 2 ms.
            if (visDetected) {
                if (!streamDecoderInitialized) {
                    // Background thread is still initialising the decoder; skip this chunk
                    // to avoid a race.  The bg thread feeds the backlog itself before setting
                    // streamDecoderInitialized = true, so we won't miss anything.
                    return;
                }
                // Subsequent calls after init: feed only this new chunk.
                int numSamples = length / 2;
                short[] newSamples = new short[numSamples];
                for (int i = 0; i < numSamples; i++) {
                    newSamples[i] = (short) ((audioData[i * 2] & 0xFF)
                            | ((audioData[i * 2 + 1] & 0xFF) << 8));
                }
                int chunkSize = 1024;
                for (int off = 0; off < newSamples.length; off += chunkSize) {
                    int len = Math.min(chunkSize, newSamples.length - off);
                    if (len <= 0) break;
                    short[] chunk = new short[len];
                    System.arraycopy(newSamples, off, chunk, 0, len);
                    feedChunkToDecoder(chunk);
                    if (streamDecoder != null && streamDecoder.isComplete()) break;
                }
                if (streamDecoder != null && streamDecoder.isComplete()) {
                    XposedBridge.log(TAG + ": Streaming decode complete — all lines decoded");
                    stopTimeoutChecker();
                    handleTransmissionComplete();
                    return;
                }
                // Periodic progress log
                int elapsedMs = (int) (System.currentTimeMillis() - startTime);
                if (currentMode != null && elapsedMs % 5000 < 200) {
                    int progress = streamDecoder != null && streamDecoder.getTotalLines() > 0
                            ? (streamDecoder.getProcessedLines() * 100) / streamDecoder.getTotalLines()
                            : 0;
                    XposedBridge.log(TAG + ": Streaming " + currentMode.name + " — "
                            + progress + "% (" + (streamDecoder != null ? streamDecoder.getProcessedLines() : 0)
                            + "/" + (streamDecoder != null ? streamDecoder.getTotalLines() : '?') + " lines)");
                }
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error in processAudio: " + e.getMessage());
        }
    }

    /**
     * Background detection thread entry point.
     * Runs Phase 1 (VIS scan + auto-detect) on a 500 ms tick until VIS is confirmed,
     * then initialises Phase 2 and exits (Phase 2 streaming continues on write thread).
     */
    private void runDetectionLoop() {
        while (!bgStop && !Thread.currentThread().isInterrupted()) {
            try {
                Thread.sleep(50);
            } catch (InterruptedException e) {
                return;
            }
            if (bgStop) return;
            if (visDetected) {
                // VIS already found; initialise Phase 2 decoder on this thread so that
                // the write thread doesn't have to do the (potentially multi-ms) backlog feed.
                if (!streamDecoderInitialized) {
                    initPhase2();
                }
                return;  // bg thread's work is done
            }
            runDetectionTick();

            if (visDetected && !streamDecoderInitialized) {
                initPhase2();
                return;
            }
        }
    }

    /**
     * Initialise the Phase-2 streaming decoder and feed the buffered audio backlog.
     * Called from the background detection thread.
     */
    private void initPhase2() {
        streamDecoder = new SSTVImageDecoderIQ(currentMode, sampleRate);
        streamDecoder.initStreaming();
        streamingStartTime = System.currentTimeMillis();
        streamDecoder.setLineDecodeCallback(new SSTVImageDecoderIQ.LineDecodeCallback() {
            @Override
            public void onLineDecode(int linesDecoded, int totalLines, Bitmap snapshot) {
                decodedLines = linesDecoded;
                if (linesDecoded == 1 && currentMode != null) {
                    notifyVISDetected(currentMode);
                }
                if (lineDecodeCallback != null) {
                    lineDecodeCallback.onLineDecode(linesDecoded, totalLines, snapshot);
                }
            }
        });

        // Take a snapshot of the buffer for backlog feed (synchronized).
        byte[] backlog;
        synchronized (bufferLock) {
            backlog = audioBuffer.toByteArray();
        }
        short[] allSamples = bytesToShorts(backlog);
        // Start 1 s before imageStartSample as a pre-roll so the decoder sees the
        // first sync pulse even if imageStartSample has minor timing error.
        int preRoll = sampleRate;  // 1000 ms
        int startIdx = Math.max(0, imageStartSample - preRoll);
        // Cap at 12s — large enough to cover delayed auto-detect scenarios
        // (this runs on the bg thread so blocking is fine).
        int maxBacklog = sampleRate * 12;
        if (allSamples.length - startIdx > maxBacklog) {
            startIdx = allSamples.length - maxBacklog;
        }
        XposedBridge.log(TAG + ": Streaming init — feeding backlog "
                + startIdx + "→" + allSamples.length + " samples (" + currentMode.name + ")");
        int chunkSize = 1024;
        for (int off = startIdx; off < allSamples.length; off += chunkSize) {
            int len = Math.min(chunkSize, allSamples.length - off);
            if (len <= 0) break;
            short[] chunk = new short[len];
            System.arraycopy(allSamples, off, chunk, 0, len);
            feedChunkToDecoder(chunk);
            if (streamDecoder != null && streamDecoder.isComplete()) break;
        }
        // Drain any audio that arrived on the write thread while we were feeding the backlog.
        // Those chunks were appended to the buffer but not decoded (write thread skips decoding
        // while !streamDecoderInitialized).  Feed the delta now before signalling the write thread
        // so no image samples fall through the gap.
        synchronized (bufferLock) {
            int currentSamples = audioBuffer.size() / 2;
            if (currentSamples > allSamples.length) {
                byte[] drainBuf = audioBuffer.toByteArray();
                short[] drainSamples = bytesToShorts(drainBuf);
                for (int off = allSamples.length; off < drainSamples.length; off += chunkSize) {
                    int len = Math.min(chunkSize, drainSamples.length - off);
                    if (len <= 0) break;
                    short[] chunk = new short[len];
                    System.arraycopy(drainSamples, off, chunk, 0, len);
                    feedChunkToDecoder(chunk);
                    if (streamDecoder != null && streamDecoder.isComplete()) break;
                }
            }
        }
        // Signal write thread: from this point it should feed new chunks inline.
        streamDecoderInitialized = true;
        // Start the timeout checker (was previously started on detection; fine to do here).
        startTimeoutChecker();
    }

    /**
     * Run one Phase-1 detection tick (VIS scan + scheduled auto-detect).
     * Called only from the background detection thread — never from the write thread.
     */
    private void runDetectionTick() {
        // All buffer reads are synchronised on bufferLock.
        // This method is called only from bgDetectionThread — never from the write thread.
        final int[] RETRY_SECS = {3, 5, 8, 12, 16};
        int bufSamples;
        synchronized (bufferLock) { bufSamples = audioBuffer.size() / 2; }
        long nowMs = System.currentTimeMillis();
        boolean needVIS = bufSamples >= sampleRate &&
                (nowMs - lastVISAttemptTimeMs) >= 250;
        boolean inWarmup = retryCount < RETRY_SECS.length;
        boolean needAutoDetect;
        if (inWarmup) {
            needAutoDetect = bufSamples >= sampleRate * RETRY_SECS[retryCount];
        } else {
            needAutoDetect = (nowMs - lastAutoDetectAttemptTime) >= 5000;
        }

        if (needVIS) {
            lastVISAttemptTimeMs = nowMs;
            int visLen;
            synchronized (bufferLock) {
                visLen = audioBuffer.readLastSamples(visWorkShorts, sampleRate * 2);
            }
            short[] visSamples = java.util.Arrays.copyOfRange(visWorkShorts, 0, visLen);
            int visWindowStart = bufSamples - visLen;
            XposedBridge.log(TAG + ": Attempting VIS detection (last " + visLen + " samples)");
            SSTVVISResult rawVis = visDetector.detectVIS(visSamples);
            SSTVVISResult visResult = (rawVis.visCode != SSTVMode.MODE_UNKNOWN)
                    ? new SSTVVISResult(rawVis.visCode, rawVis.imageStartSample + visWindowStart)
                    : rawVis;
            detectedMode = visResult.visCode;

            if (detectedMode != SSTVMode.MODE_UNKNOWN) {
                byte[] guardBuf;
                synchronized (bufferLock) { guardBuf = audioBuffer.toByteArray(); }
                short[] samples = bytesToShorts(guardBuf);
                SSTVMode.Mode visMode = SSTVMode.getModeByVIS(detectedMode);

                if (visMode != null && visMode.syncFamily == SSTVMode.SYNC_FAMILY_TWENTY_MS) {
                    // Scan whatever buffer we have (no minimum size required).
                    int scanLen = Math.min(samples.length, sampleRate * 5);
                    int nineCount = quickCountSyncInRange(samples, 0, scanLen,
                            SSTVIQDemodulator.SyncPulseWidth.NINE_MS);
                    int fiveCount = quickCountSyncInRange(samples, 0, scanLen,
                            SSTVIQDemodulator.SyncPulseWidth.FIVE_MS);
                    if (nineCount >= 1) {
                        XposedBridge.log(TAG + ": VIS gave PD mode (" + visMode.name
                                + ") but " + nineCount + " nine_ms sync(s) found — rejecting");
                        detectedMode = SSTVMode.MODE_UNKNOWN;
                    } else if (fiveCount >= 1) {
                        XposedBridge.log(TAG + ": VIS gave PD mode (" + visMode.name
                                + ") but " + fiveCount + " five_ms sync(s) found — rejecting");
                        detectedMode = SSTVMode.MODE_UNKNOWN;
                    } else {
                        XposedBridge.log(TAG + ": VIS " + visMode.name + " accepted ("
                                + (samples.length * 1000 / sampleRate) + "ms buffered)");
                    }
                }

                if (detectedMode != SSTVMode.MODE_UNKNOWN
                        && visMode != null
                        && visMode.syncFamily == SSTVMode.SYNC_FAMILY_FIVE_MS) {
                    // Scan whatever post-VIS audio is available — no minimum required.
                    // If sync spacing is inconclusive, trust the VIS code immediately
                    // rather than deferring, to avoid cutting off the top of the image.
                    int imageStartF = visResult.imageStartSample;
                    int postVisLenF = samples.length - imageStartF;
                    int scanLenF = Math.min(postVisLenF, sampleRate * 4);
                    int[] fivePosF = new int[256]; int fiveCntF = 0;
                    SSTVIQDemodulator gDemod = new SSTVIQDemodulator(sampleRate);
                    int scanEndF = imageStartF + scanLenF;
                    for (int gOff = imageStartF; gOff < scanEndF; gOff += 1024) {
                        int gLen = Math.min(1024, Math.min(scanEndF, samples.length) - gOff);
                        if (gLen <= 0) break;
                        short[] gChunk = new short[gLen];
                        System.arraycopy(samples, gOff, gChunk, 0, gLen);
                        float[] gOut = new float[gLen];
                        if (gDemod.process(gChunk, gOut)
                                && gDemod.syncPulseWidth == SSTVIQDemodulator.SyncPulseWidth.FIVE_MS
                                && fiveCntF < fivePosF.length) {
                            fivePosF[fiveCntF++] = gOff + gDemod.syncPulseOffset;
                        }
                    }
                    XposedBridge.log(TAG + ": FIVE_MS guard: " + fiveCntF
                            + " syncs in " + (scanLenF * 1000 / sampleRate) + "ms post-VIS");
                    SSTVMode.Mode syncMode5 = runDetectorOnFamily(fivePosF, fiveCntF,
                            SSTVIQDemodulator.SyncPulseWidth.FIVE_MS);
                    if (syncMode5 != null && syncMode5.visCode != detectedMode) {
                        XposedBridge.log(TAG + ": FIVE_MS VIS/sync contradiction: VIS="
                                + visMode.name + " sync=" + syncMode5.name + " → trusting sync");
                        detectedMode = syncMode5.visCode;
                    } else if (syncMode5 != null) {
                        XposedBridge.log(TAG + ": FIVE_MS VIS confirmed by sync: " + visMode.name);
                    } else {
                        // Inconclusive — trust VIS code now, don't delay image start.
                        XposedBridge.log(TAG + ": FIVE_MS sync inconclusive ("
                                + (postVisLenF * 1000 / sampleRate) + "ms) — accepting VIS: " + visMode.name);
                    }
                }

                if (detectedMode != SSTVMode.MODE_UNKNOWN
                        && visMode != null
                        && visMode.syncFamily == SSTVMode.SYNC_FAMILY_NINE_MS
                        && visMode.visCode != SSTVMode.MODE_SCOTTIE_DX) {
                    // Scan whatever post-VIS audio is available — no minimum required.
                    int imageStartN = visResult.imageStartSample;
                    int postVisLenN = samples.length - imageStartN;
                    int scanLenN = Math.min(postVisLenN, sampleRate * 4);
                    int[] ninePosN = new int[256]; int nineCntN = 0;
                    SSTVIQDemodulator gDemod2 = new SSTVIQDemodulator(sampleRate);
                    int scanEndN = imageStartN + scanLenN;
                    for (int gOff = imageStartN; gOff < scanEndN; gOff += 1024) {
                        int gLen = Math.min(1024, Math.min(scanEndN, samples.length) - gOff);
                        if (gLen <= 0) break;
                        short[] gChunk = new short[gLen];
                        System.arraycopy(samples, gOff, gChunk, 0, gLen);
                        float[] gOut = new float[gLen];
                        if (gDemod2.process(gChunk, gOut)
                                && gDemod2.syncPulseWidth == SSTVIQDemodulator.SyncPulseWidth.NINE_MS
                                && nineCntN < ninePosN.length) {
                            ninePosN[nineCntN++] = gOff + gDemod2.syncPulseOffset;
                        }
                    }
                    XposedBridge.log(TAG + ": NINE_MS guard: " + nineCntN
                            + " syncs in " + (scanLenN * 1000 / sampleRate) + "ms post-VIS");
                    SSTVMode.Mode syncModeN = runDetectorOnFamily(ninePosN, nineCntN,
                            SSTVIQDemodulator.SyncPulseWidth.NINE_MS);
                    if (syncModeN != null && syncModeN.visCode != detectedMode) {
                        XposedBridge.log(TAG + ": NINE_MS VIS/sync contradiction: VIS="
                                + visMode.name + " sync=" + syncModeN.name + " → trusting sync");
                        detectedMode = syncModeN.visCode;
                    } else if (syncModeN != null) {
                        XposedBridge.log(TAG + ": NINE_MS VIS confirmed by sync: " + visMode.name);
                    } else {
                        // Inconclusive — trust VIS code now, don't delay image start.
                        XposedBridge.log(TAG + ": NINE_MS sync inconclusive ("
                                + (postVisLenN * 1000 / sampleRate) + "ms) — accepting VIS: " + visMode.name);
                    }
                }

                if (detectedMode != SSTVMode.MODE_UNKNOWN) {
                    imageStartSample = visResult.imageStartSample;
                    visDetected = true;
                }
            }
        }

        // Fallback: sync-based auto-detection on schedule.
        if (!visDetected && needAutoDetect) {
            if (inWarmup) retryCount++;
            lastAutoDetectAttemptTime = nowMs;
            // Energy probe: check recent 256 samples for signal presence.
            short[] probeShorts = new short[256];
            int probeLen;
            synchronized (bufferLock) {
                probeLen = audioBuffer.readLastSamples(probeShorts, 256);
            }
            long energySum = 0;
            for (int i = 0; i < probeLen; i++) energySum += (long) probeShorts[i] * probeShorts[i];
            double audioRms = probeLen > 0 ? Math.sqrt((double) energySum / probeLen) : 0;
            if (audioRms < 300.0) {
                XposedBridge.log(TAG + ": Auto-detect skipped (RMS=" + (int) audioRms
                        + " < 300, likely noise/static)");
            } else {
                int autoLen;
                synchronized (bufferLock) {
                    autoLen = audioBuffer.readLastSamples(autoWorkShorts, sampleRate * 16);
                }
                short[] autoSamples = java.util.Arrays.copyOfRange(autoWorkShorts, 0, autoLen);
                SSTVMode.Mode autoMode = tryAutoDetectMode(autoSamples);
                if (autoMode != null) {
                    detectedMode = autoMode.visCode;
                    // Point imageStartSample at the start of the window we analyzed so
                    // initPhase2 feeds from there rather than from byte 0 of the buffer.
                    imageStartSample = Math.max(0, bufSamples - autoLen);
                    visDetected = true;
                    XposedBridge.log(TAG + ": ✓ Sync auto-detection succeeded (attempt "
                            + retryCount + "): " + autoMode.name);
                } else {
                    XposedBridge.log(TAG + ": Auto-detection inconclusive (attempt "
                            + retryCount + "), will retry.");
                }
            }
        }

        if (visDetected && detectedMode != SSTVMode.MODE_UNKNOWN) {
            currentMode = SSTVMode.getModeByVIS(detectedMode);
            if (currentMode != null) {
                XposedBridge.log(TAG + ": ✓ VIS DETECTED: " + currentMode.name
                               + " (VIS: 0x" + Integer.toHexString(detectedMode) + ")");
                XposedBridge.log(TAG + ": Mode info: " + currentMode.width + "x" + currentMode.height
                               + ", " + currentMode.durationMs + "ms, "
                               + (currentMode.isRGB ? "RGB" : "YUV"));
            } else {
                XposedBridge.log(TAG + ": ⚠ VIS detected but mode not supported: 0x"
                               + Integer.toHexString(detectedMode));
                visDetected = false;
            }
        }
    }





    
    /**
     * Scan buffered audio for sync pulses and attempt to identify SSTV mode.
     *
     * Uses a two-phase approach to avoid cross-family interference:
     *   Phase 1 — one demodulator pass collecting all (position, width) pairs.
     *   Phase 2 — three independent SSTVAutoDetector passes, one per sync family.
     *             NINE_MS is tried first so ScottieDX isn't beaten by spurious
     *             TWENTY_MS pulses that appear mid-line in long-period modes.
     */
    private SSTVMode.Mode tryAutoDetectMode(short[] samples) {
        XposedBridge.log(TAG + ": Attempting sync-based auto mode detection (" + samples.length + " samples)...");

        // --- Phase 1: collect all sync pulses ---
        SSTVIQDemodulator demod = new SSTVIQDemodulator(sampleRate);
        int chunkSize = 1024;
        float[] demodBuf = new float[chunkSize];
        int maxSamples = Math.min(samples.length, sampleRate * 20);

        // Store positions per family (three small arrays, max ~20 syncs per family)
        int[] nineMs   = new int[256];  int nineCnt   = 0;
        int[] fiveMs   = new int[256];  int fiveCnt   = 0;
        int[] twentyMs = new int[256];  int twentyCnt = 0;

        for (int offset = 0; offset < maxSamples; offset += chunkSize) {
            int len = Math.min(chunkSize, maxSamples - offset);
            short[] chunk = new short[len];
            System.arraycopy(samples, offset, chunk, 0, len);
            if (demod.process(chunk, demodBuf)) {
                int pos = offset + demod.syncPulseOffset;
                switch (demod.syncPulseWidth) {
                    case FIVE_MS:   if (fiveCnt   < fiveMs.length)   fiveMs[fiveCnt++]     = pos; break;
                    case NINE_MS:   if (nineCnt   < nineMs.length)   nineMs[nineCnt++]     = pos; break;
                    case TWENTY_MS: if (twentyCnt < twentyMs.length) twentyMs[twentyCnt++] = pos; break;
                }
            }
        }
        XposedBridge.log(TAG + ": Syncs collected — 9ms:" + nineCnt + " 5ms:" + fiveCnt + " 20ms:" + twentyCnt);

        // --- Phase 2: try each family independently ---
        // Order: NINE_MS first (Scottie/Robot — most common and longest period, so most
        //        vulnerable to spurious-20ms confusion).  Then FIVE_MS (Martin).
        //        TWENTY_MS (PD modes) last — and ONLY if zero NINE_MS syncs were detected.
        //
        // Key insight: ScottieDX's 1.5ms inter-channel separators at ~370ms intervals get
        // misclassified as TWENTY_MS pulses by the IQ demodulator (RF noise can push 1500Hz
        // into the <1400Hz Schmitt threshold).  Those accumulate and match PD 120 (369.78ms).
        // But ScottieDX always produces real NINE_MS syncs every 1050ms.  If ANY nine_ms
        // syncs were detected we are definitely not in PD territory — skip TWENTY_MS entirely
        // and let the next retry accumulate more NINE_MS spacings.
        SSTVMode.Mode result;
        result = runDetectorOnFamily(nineMs,   nineCnt,   SSTVIQDemodulator.SyncPulseWidth.NINE_MS);
        if (result != null) { XposedBridge.log(TAG + ": ✓ 9ms family matched: " + result.name); return result; }
        result = runDetectorOnFamily(fiveMs,   fiveCnt,   SSTVIQDemodulator.SyncPulseWidth.FIVE_MS);
        if (result != null) { XposedBridge.log(TAG + ": ✓ 5ms family matched: " + result.name); return result; }
        // Only try PD (TWENTY_MS) if no NINE_MS syncs at all — presence of any NINE_MS
        // syncs means this is a Scottie/Robot mode still accumulating spacings.
        // Allow TWENTY_MS (PD) detection when either:
        // (a) no NINE_MS syncs at all — clearly not Scottie/Robot, OR
        // (b) significantly more TWENTY_MS syncs than NINE_MS syncs — the 9ms
        //     events are background noise, not genuine Scottie/Robot syncs.
        // ScottieDX produces many NINE_MS syncs (1 per ~1050ms line) that will always
        // outnumber the few fake TWENTY_MS pulses from its separators, keeping that
        // false-positive protection intact.
        if (nineCnt == 0 || (twentyCnt >= 4 && twentyCnt > nineCnt)) {
            result = runDetectorOnFamily(twentyMs, twentyCnt, SSTVIQDemodulator.SyncPulseWidth.TWENTY_MS);
            if (result != null) { XposedBridge.log(TAG + ": ✓ 20ms family matched: " + result.name); return result; }
        } else {
            XposedBridge.log(TAG + ": Skipping TWENTY_MS (9ms:" + nineCnt + " >= 20ms:" + twentyCnt + " — likely Scottie/Robot, not PD)");
        }

        // --- Phase 3: combined-width fallback ---
        // If family-specific checks all failed (e.g. RF frequency offset shifts the 1200 Hz
        // sync into a different Schmitt bucket), merge ALL detected positions regardless of
        // classified width and check against every known mode.  A ScottieDX signal whose
        // 9ms syncs are mis-labelled TWENTY_MS will still have 1050ms spacings — which do
        // NOT match PD120 (370ms) but DO match ScottieDX under getAllModes() iteration.
        int allCnt = nineCnt + fiveCnt + twentyCnt;
        if (allCnt >= 2) {
            int[] allSyncs = new int[allCnt];
            System.arraycopy(nineMs,   0, allSyncs, 0,                   nineCnt);
            System.arraycopy(fiveMs,   0, allSyncs, nineCnt,             fiveCnt);
            System.arraycopy(twentyMs, 0, allSyncs, nineCnt + fiveCnt,   twentyCnt);
            Arrays.sort(allSyncs, 0, allCnt);  // positions must be in time order
            result = findBestModeAcrossAll(allSyncs, allCnt, nineCnt, fiveCnt, twentyCnt);
            if (result != null) {
                XposedBridge.log(TAG + ": ✓ Combined-widths matched: " + result.name);
                return result;
            }
        }

        XposedBridge.log(TAG + ": Auto-detection inconclusive (insufficient sync data)");
        return null;
    }

    /**
     * Like runDetectorOnFamily but iterates ALL known SSTV modes regardless of sync family.
     * Handles RF frequency-offset cases where pulse-width classification is unreliable:
     * e.g. a ScottieDX 9ms sync that arrives slightly widened by RF noise is labelled
     * TWENTY_MS by the IQ demodulator, but its inter-sync spacing is still 1050ms, not
     * the 370ms expected by PD120 — so it still votes for ScottieDX here.
     *
     * @param nineCnt   number of syncs classified NINE_MS
     * @param fiveCnt   number of syncs classified FIVE_MS
     * @param twentyCnt number of syncs classified TWENTY_MS
     */
    private SSTVMode.Mode findBestModeAcrossAll(int[] positions, int count,
                                                 int nineCnt, int fiveCnt, int twentyCnt) {
        if (count < 2) return null;
        double[] spacings = new double[count - 1];
        int nSpacings = 0;
        for (int i = 1; i < count; i++) {
            double ms = (positions[i] - positions[i - 1]) * 1000.0 / sampleRate;
            if (ms > 30) spacings[nSpacings++] = ms;
        }
        // Combined-widths is a last-resort fallback; require strict gates.
        if (nSpacings < 6) return null;

        // Cross-family guard: if ALL detected syncs are FIVE_MS (Martin/Robot-BW family),
        // only consider FIVE_MS-family modes.  A real NINE_MS or TWENTY_MS transmission
        // always produces at least some correctly-classified syncs of those types —
        // IQ pulse-width classification is duration-based (not frequency-based) so RF
        // offset cannot shift a 9ms pulse into the 5ms bucket.  Allowing NINE_MS modes
        // (e.g. Robot 36) to be matched from pure FIVE_MS noise syncs is physically wrong
        // and the primary source of false positives observed in live logs.
        //
        // Exception: TWENTY_MS-only syncs may be ScottieDX (NINE_MS) with mis-labelled
        // pulses (see method Javadoc), so we must still check all modes in that case.
        final boolean onlyFiveMs = (nineCnt == 0 && twentyCnt == 0 && fiveCnt > 0);

        SSTVMode.Mode bestMode  = null;
        int           bestVotes = 0;
        for (SSTVMode.Mode m : SSTVMode.getAllModes()) {
            // Restrict to FIVE_MS family when only FIVE_MS syncs were detected.
            if (onlyFiveMs && m.syncFamily != SSTVMode.SYNC_FAMILY_FIVE_MS) continue;

            double tol   = SSTVAutoDetector.matchToleranceFor(m.fullLineDurationMs);
            int    votes = 0;
            for (int i = 0; i < nSpacings; i++) {
                if (Math.abs(spacings[i] - m.fullLineDurationMs) < tol) votes++;
            }
            if (votes >= 6 && ((float) votes / nSpacings) >= 0.30f && votes > bestVotes) {
                // Same regularity gate as runDetectorOnFamily: CV < 5%
                double mean = 0;
                for (int i = 0; i < nSpacings; i++) {
                    if (Math.abs(spacings[i] - m.fullLineDurationMs) < tol) mean += spacings[i];
                }
                mean /= votes;
                double varSum = 0;
                for (int i = 0; i < nSpacings; i++) {
                    if (Math.abs(spacings[i] - m.fullLineDurationMs) < tol) {
                        double d = spacings[i] - mean;
                        varSum += d * d;
                    }
                }
                double cv = (votes > 1) ? Math.sqrt(varSum / votes) / mean : 0;
                if (cv > 0.05) continue;
                bestVotes = votes;
                bestMode  = m;
            }
        }

        if (bestMode != null) {
            XposedBridge.log(TAG + ": Combined-widths: " + bestMode.name
                    + " votes=" + bestVotes + "/" + nSpacings);
        }
        return bestMode;
    }

    /**
     * Quickly count how many NINE_MS sync pulses appear in the first maxSamples.
     * Used to sanity-check a VIS detection that claims a PD (20ms-sync) mode:
     * if even two 9ms syncs are found the signal is NOT a PD-family mode.
     */
    private int quickCountNineMs(short[] samples, int maxSamples) {
        return quickCountSyncInRange(samples, 0, maxSamples, SSTVIQDemodulator.SyncPulseWidth.NINE_MS);
    }

    /**
     * Count sync pulses of the given family starting at startOffset for up to maxLength samples.
     * Used to cross-check a VIS detection by scanning the post-VIS image data portion.
     */
    private int quickCountSyncInRange(short[] samples, int startOffset, int maxLength,
                                       SSTVIQDemodulator.SyncPulseWidth target) {
        SSTVIQDemodulator demod = new SSTVIQDemodulator(sampleRate);
        float[] buf = new float[1024];
        int cnt = 0;
        int end = Math.min(startOffset + maxLength, samples.length);
        for (int off = startOffset; off < end; off += 1024) {
            int len = Math.min(1024, end - off);
            short[] chunk = new short[len];
            System.arraycopy(samples, off, chunk, 0, len);
            if (demod.process(chunk, buf) && demod.syncPulseWidth == target) cnt++;
        }
        return cnt;
    }

    /**
     * Mode-directed clustering: for each candidate mode in the sync family, count how
     * many inter-sync spacings land within that mode's tolerance window.
     * Requires at least MIN_VOTES hits before declaring a match.
     *
     * This is far more robust than mean+stddev because:
     *  - Spurious syncs at wrong periods don't dilute the target mode's votes.
     *  - Missed syncs produce 2× or 3× spacings which simply don't hit the window.
     *  - Different modes have non-overlapping windows so false positives are rare.
     */
    private SSTVMode.Mode runDetectorOnFamily(int[] positions, int count,
                                               SSTVIQDemodulator.SyncPulseWidth width) {
        if (count < 2) return null;

        // Compute all consecutive inter-sync spacings in ms, excluding sub-30ms noise
        double[] spacings = new double[count - 1];
        int nSpacings = 0;
        for (int i = 1; i < count; i++) {
            double ms = (positions[i] - positions[i - 1]) * 1000.0 / sampleRate;
            if (ms > 30) spacings[nSpacings++] = ms;
        }
        if (nSpacings < 4) return null;

        int family;
        switch (width) {
            case FIVE_MS:   family = SSTVMode.SYNC_FAMILY_FIVE_MS;   break;
            case TWENTY_MS: family = SSTVMode.SYNC_FAMILY_TWENTY_MS; break;
            default:        family = SSTVMode.SYNC_FAMILY_NINE_MS;   break;
        }

        SSTVMode.Mode bestMode  = null;
        int           bestVotes = 0;

        for (SSTVMode.Mode m : SSTVMode.getModesByFamily(family)) {
            double tol   = SSTVAutoDetector.matchToleranceFor(m.fullLineDurationMs);
            int    votes = 0;
            double sum   = 0;
            for (int i = 0; i < nSpacings; i++) {
                if (Math.abs(spacings[i] - m.fullLineDurationMs) < tol) {
                    votes++;
                    sum += spacings[i];
                }
            }
            // Require at least 4 votes AND ≥15% fraction.
            if (votes >= 4 && ((float) votes / nSpacings) >= 0.15f && votes > bestVotes) {
                // Regularity gate: real SSTV syncs are metronomically regular.
                // Compute CV (std/mean) of the matched spacings — real SSTV < 3%,
                // noise spacings that happen to fall near the target period are
                // scattered randomly within the tolerance window, giving CV > 5%.
                double mean = sum / votes;
                double varSum = 0;
                for (int i = 0; i < nSpacings; i++) {
                    if (Math.abs(spacings[i] - m.fullLineDurationMs) < tol) {
                        double d = spacings[i] - mean;
                        varSum += d * d;
                    }
                }
                double cv = (votes > 1) ? Math.sqrt(varSum / votes) / mean : 0;
                if (cv > 0.05) continue;  // > 5% CV → irregular, skip
                bestVotes = votes;
                bestMode  = m;
            }
        }

        if (bestMode != null) {
            XposedBridge.log(TAG + ": Mode-directed: " + bestMode.name
                    + " votes=" + bestVotes + "/" + nSpacings);
        }
        return bestMode;
    }

    /**
     * Convert byte array to short array (16-bit PCM samples)
     */
    private short[] bytesToShorts(byte[] bytes) {
        short[] shorts = new short[bytes.length / 2];
        for (int i = 0; i < shorts.length; i++) {
            // Little-endian: LSB first
            shorts[i] = (short) ((bytes[i * 2] & 0xFF) | ((bytes[i * 2 + 1] & 0xFF) << 8));
        }
        return shorts;
    }

    /**
     * ByteArrayOutputStream subclass that exposes its internal buffer for zero-copy
     * operations.  Two key benefits over the base class:
     *  - trimToRecent(): discard oldest bytes with a single System.arraycopy, no allocation.
     *  - readLastSamples(): decode the last N LE-16 samples into a caller-supplied short[],
     *    no byte[] intermediary.
     */
    private static class DirectBAOS extends java.io.ByteArrayOutputStream {
        DirectBAOS(int capacity) { super(capacity); }

        /** How many valid bytes are currently buffered (alias for size() with protected access). */
        int validBytes() { return count; }

        /**
         * Discard the oldest bytes, keeping only the most recent {@code keepBytes}.
         * Zero allocation: uses System.arraycopy within the same backing array.
         */
        void trimToRecent(int keepBytes) {
            if (count <= keepBytes) return;
            int discard = count - keepBytes;
            System.arraycopy(buf, discard, buf, 0, keepBytes);
            count = keepBytes;
        }

        /**
         * Decode the last {@code nSamples} little-endian 16-bit samples from the buffer
         * into {@code dest[0..actual-1]}.  Returns the actual number of samples written
         * (may be less than nSamples if the buffer doesn't yet hold that much data).
         * No allocation — dest must be pre-allocated by the caller.
         */
        int readLastSamples(short[] dest, int nSamples) {
            int neededBytes = nSamples * 2;
            int startByte   = Math.max(0, count - neededBytes);
            int actual      = (count - startByte) / 2;
            for (int i = 0; i < actual; i++) {
                dest[i] = (short) ((buf[startByte + i * 2] & 0xFF)
                                 | ((buf[startByte + i * 2 + 1] & 0xFF) << 8));
            }
            return actual;
        }
    }

    private static byte[] intToLe(int v) {
        return new byte[]{(byte)v,(byte)(v>>8),(byte)(v>>16),(byte)(v>>24)};
    }

    private static byte[] shortToLe(short v) {
        return new byte[]{(byte)v,(byte)(v>>8)};
    }
    
    /**
     * Start periodic timeout checker (called when VIS detected)
     */
    private void startTimeoutChecker() {
        stopTimeoutChecker();  // Stop any existing checker
        timeoutHandler.postDelayed(timeoutChecker, 500);  // Check every 500ms
        XposedBridge.log(TAG + ": ⏱ Timeout checker started (sync-loss + 3s silence fallback)");
    }
    
    /**
     * Stop periodic timeout checker
     */
    private void stopTimeoutChecker() {
        timeoutHandler.removeCallbacks(timeoutChecker);
    }
    
    /**
     * Handle transmission complete (timeout or end detection)
     */
    private void handleTransmissionComplete() {
        stopTimeoutChecker();
        if (currentMode == null) {
            reset();
            return;
        }

        int elapsedMs = (int) (System.currentTimeMillis() - startTime);
        XposedBridge.log(TAG + ": Transmission complete - " + currentMode.name
                + " received in " + elapsedMs + "ms (expected: " + currentMode.durationMs + "ms)");

        try {
            // Prefer the streaming decoder result (already decoded progressively)
            if (streamDecoder != null && streamDecoder.getProcessedLines() > 0) {
                streamDecoder.finalizeStreaming();
                decodedImage = streamDecoder.getCurrentBitmap();
                XposedBridge.log(TAG + ": Using streaming result: "
                        + streamDecoder.getProcessedLines() + " lines decoded");
            } else {
                // Fallback: batch decode from accumulated audio buffer
                XposedBridge.log(TAG + ": No streaming result — falling back to batch decode");
                byte[] buffer = audioBuffer.toByteArray();
                short[] samples = bytesToShorts(buffer);
                SSTVImageDecoderIQ batchDecoder = new SSTVImageDecoderIQ(currentMode, sampleRate);
                decodedImage = batchDecoder.decode(samples, imageStartSample);
            }

            // Save raw audio as WAV for standalone decoder comparison
            try {
                byte[] buffer = audioBuffer.toByteArray();
                java.io.File wavFile = new java.io.File("/sdcard/sstv_audio.wav");
                java.io.FileOutputStream wavFos = new java.io.FileOutputStream(wavFile);
                int dataSize = buffer.length;
                wavFos.write(new byte[]{'R','I','F','F'});
                wavFos.write(intToLe(dataSize + 36));
                wavFos.write(new byte[]{'W','A','V','E','f','m','t',' '});
                wavFos.write(intToLe(16));
                wavFos.write(shortToLe((short) 1));
                wavFos.write(shortToLe((short) 1));
                wavFos.write(intToLe(sampleRate));
                wavFos.write(intToLe(sampleRate * 2));
                wavFos.write(shortToLe((short) 2));
                wavFos.write(shortToLe((short) 16));
                wavFos.write(new byte[]{'d','a','t','a'});
                wavFos.write(intToLe(dataSize));
                wavFos.write(buffer);
                wavFos.close();
                XposedBridge.log(TAG + ": Saved audio WAV → /sdcard/sstv_audio.wav");
            } catch (Exception wavEx) {
                XposedBridge.log(TAG + ": Failed to save WAV: " + wavEx.getMessage());
            }

            if (decodedImage != null) {
                XposedBridge.log(TAG + ": ✓ Image decoded: "
                        + decodedImage.getWidth() + "x" + decodedImage.getHeight());

                // Auto-save to Pictures/SSTV/ with a timestamped filename
                String savedPath = saveImageToGallery(decodedImage, currentMode);

                if (imageCallback != null) {
                    imageCallback.onImageDecoded(decodedImage, currentMode);
                }
                notifyTransmissionComplete(currentMode, decodedLines);
            } else {
                XposedBridge.log(TAG + ": ✗ Image decode failed");
            }
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Error in handleTransmissionComplete: " + e.getMessage());
            e.printStackTrace();
        }

        // Reset for next transmission
        reset();
    }
    
    /**
     * Feed one chunk to the streaming decoder, tracking skipped-sync events for
     * mid-stream mode-change detection.
     */
    private void feedChunkToDecoder(short[] chunk) {
        if (streamDecoder == null) return;
        int prevLines = streamDecoder.getProcessedLines();
        streamDecoder.processChunk(chunk);
        int newLines = streamDecoder.getProcessedLines();

        // Update sync timestamp whenever a new scan line was decoded
        if (newLines > prevLines) {
            lastValidSyncTime = System.currentTimeMillis();
            consecutiveSkips = 0;
            skippedSpacingCount = 0;
        }

        int skipped = streamDecoder.lastSkippedSpacingMs;
        if (skipped > 0) {
            consecutiveSkips++;
            if (skippedSpacingCount < recentSkippedSpacings.length) {
                recentSkippedSpacings[skippedSpacingCount++] = skipped;
            } else {
                // Ring shift: drop oldest, append newest
                System.arraycopy(recentSkippedSpacings, 1, recentSkippedSpacings, 0,
                        recentSkippedSpacings.length - 1);
                recentSkippedSpacings[recentSkippedSpacings.length - 1] = skipped;
            }
            if (consecutiveSkips >= 5 && skippedSpacingCount >= 4) {
                checkForModeChange();
            }
        }
    }

    /**
     * Analyse recent skipped-sync spacings to decide whether the transmitter has
     * switched to a different SSTV mode mid-stream.
     */
    private void checkForModeChange() {
        // Compute average spacing of recent skipped syncs
        long sum = 0;
        for (int i = 0; i < skippedSpacingCount; i++) sum += recentSkippedSpacings[i];
        double avgMs = (double) sum / skippedSpacingCount;

        SSTVMode.Mode candidate = null;
        double bestDiff = Double.MAX_VALUE;
        for (SSTVMode.Mode m : SSTVMode.getAllModes()) {
            double tol = SSTVAutoDetector.matchToleranceFor(m.fullLineDurationMs);
            double diff = Math.abs(m.fullLineDurationMs - avgMs);
            if (diff <= tol && diff < bestDiff) {
                bestDiff = diff;
                candidate = m;
            }
        }

        if (candidate != null && currentMode != null
                && candidate.visCode != currentMode.visCode) {
            XposedBridge.log(TAG + ": ⚡ Mid-stream mode change: " + currentMode.name
                    + " → " + candidate.name
                    + " (avg skip spacing " + (int) avgMs + "ms, "
                    + consecutiveSkips + " consecutive skips)");
            handleModeChange(candidate);
        }
    }

    /**
     * Switch the streaming decoder to a new mode detected mid-stream.
     * The old partial image is discarded and a fresh decoder is started.
     */
    private void handleModeChange(SSTVMode.Mode newMode) {
        SSTVMode.Mode oldMode = currentMode;
        int oldLines = streamDecoder != null ? streamDecoder.getProcessedLines() : 0;

        currentMode = newMode;
        detectedMode = newMode.visCode;
        consecutiveSkips = 0;
        skippedSpacingCount = 0;

        // Restart streaming decoder for the new mode
        streamDecoder = new SSTVImageDecoderIQ(newMode, sampleRate);
        streamDecoder.initStreaming();
        final LineDecodeCallback ldc = lineDecodeCallback;
        streamDecoder.setLineDecodeCallback(new SSTVImageDecoderIQ.LineDecodeCallback() {
            @Override
            public void onLineDecode(int linesDecoded, int totalLines, Bitmap snapshot) {
                decodedLines = linesDecoded;
                if (ldc != null) ldc.onLineDecode(linesDecoded, totalLines, snapshot);
            }
        });

        XposedBridge.log(TAG + ": Mode-change decoder restarted: " + newMode.name);

        if (modeChangeCallback != null) {
            modeChangeCallback.onModeChanged(oldMode, newMode, oldLines);
        }
    }

    /**
     * Notify UI that VIS code was detected
     */
    private void notifyVISDetected(SSTVMode.Mode mode) {
        XposedBridge.log(TAG + ": [UI] VIS Detected: " + mode.name);
        if (visDetectedCallback != null) {
            visDetectedCallback.onVISDetected(mode);
        }
    }
    
    /**
     * Notify UI that transmission is complete
     */
    private void notifyTransmissionComplete(SSTVMode.Mode mode, int lines) {
        // TODO: Show image, save to gallery
        XposedBridge.log(TAG + ": [UI] Transmission Complete: " + mode.name + " (" + lines + " lines)");
    }
    
    /**
     * Get current decoding status
     */
    public String getStatus() {
        if (!visDetected) {
            return "Waiting for VIS code...";
        } else if (currentMode != null) {
            int elapsedMs = (int) (System.currentTimeMillis() - startTime);
            int progress = (elapsedMs * 100) / currentMode.durationMs;
            return "Receiving " + currentMode.name + " (" + Math.min(progress, 100) + "%)";
        } else {
            return "Unknown mode";
        }
    }
    
    /**
     * Get detected mode
     */
    public SSTVMode.Mode getCurrentMode() {
        return currentMode;
    }
    
    /**
     * Check if VIS code has been detected
     */
    public boolean isVISDetected() {
        return visDetected;
    }
    
    /**
     * Get total audio duration received (seconds)
     */
    public float getReceivedDuration() {
        return totalAudioBytes / (float) (sampleRate * 2);
    }
    
    /**
     * Save a decoded SSTV bitmap to Pictures/SSTV/ with a timestamped filename
     * and notify the MediaStore so it appears in the gallery immediately.
     *
     * @return absolute path of the saved file, or null on failure
     */
    private String saveImageToGallery(android.graphics.Bitmap bitmap, SSTVMode.Mode mode) {
        try {
            // Build a filename: SSTV_ScottieS2_20260317_143022.png
            java.text.SimpleDateFormat sdf =
                    new java.text.SimpleDateFormat("yyyyMMdd_HHmmss", java.util.Locale.US);
            String ts   = sdf.format(new java.util.Date());
            String modeTag = mode.name.replace(" ", "");
            String fname = "SSTV_" + modeTag + "_" + ts + ".png";

            // Target directory: <external storage>/Downloads/DMR/SSTV/
            java.io.File downloadDir = android.os.Environment.getExternalStoragePublicDirectory(
                    android.os.Environment.DIRECTORY_DOWNLOADS);
            java.io.File dir = new java.io.File(new java.io.File(downloadDir, "DMR"), "SSTV");
            if (!dir.exists() && !dir.mkdirs()) {
                XposedBridge.log(TAG + ": Cannot create SSTV directory: " + dir);
                return null;
            }

            java.io.File outFile = new java.io.File(dir, fname);
            java.io.FileOutputStream fos = new java.io.FileOutputStream(outFile);
            bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, fos);
            fos.flush();
            fos.close();

            // Notify MediaStore so gallery apps pick it up without waiting for a scan
            android.content.Intent scanIntent = new android.content.Intent(
                    android.content.Intent.ACTION_MEDIA_SCANNER_SCAN_FILE,
                    android.net.Uri.fromFile(outFile));
            context.sendBroadcast(scanIntent);

            XposedBridge.log(TAG + ": ✓ Saved SSTV image → " + outFile.getAbsolutePath());
            return outFile.getAbsolutePath();
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Failed to save SSTV image: " + e.getMessage());
            return null;
        }
    }

    /** Number of scan lines decoded so far (updated by streaming decoder). */
    public int getDecodedLines() {
        return streamDecoder != null ? streamDecoder.getProcessedLines() : decodedLines;
    }

    /**
     * Get decoded image (null if not yet decoded)
     */
    public Bitmap getDecodedImage() {
        return decodedImage;
    }
    
    /**
     * Stop monitoring (called when user stops SSTV)
     */
    public void stop() {
        stopTimeoutChecker();
        XposedBridge.log(TAG + ": Receiver stopped");
    }
}
