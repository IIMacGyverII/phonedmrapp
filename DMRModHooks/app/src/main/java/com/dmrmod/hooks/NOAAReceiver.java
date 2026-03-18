package com.dmrmod.hooks;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;

import java.io.File;
import java.io.FileOutputStream;
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
    private double iLpf        = 0.0;   // I low-pass filter state
    private double qLpf        = 0.0;   // Q low-pass filter state

    /**
     * IIR low-pass alpha.  Targets fc ≈ 1000 Hz at 16000 Hz input rate.
     * alpha = 1 - exp(-2π × fc / fs)   (single-pole IIR)
     * At fc=1000, fs=8000:  alpha ≈ 0.54
     * At fc=1000, fs=16000: alpha ≈ 0.28
     * Recomputed when inputRate changes.
     */
    private double lpfAlpha = 0.28;

    /** NCO phase increment per input sample: 2π × SUBCARRIER / inputRate */
    private double ncoIncrement = 2.0 * Math.PI * SUBCARRIER_HZ / 16000.0;

    /** Resampler accumulator and step.  step = APT_RATE / inputRate. */
    private double resampleAccum = 0.0;
    private double resampleStep  = APT_RATE / 16000.0;  // 0.26 for 16000 Hz

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

    private final float[] lineBuffer    = new float[SAMPLES_PER_LINE];
    private int           lineBufferPos = 0;

    // -----------------------------------------------------------------------
    // Adaptive normalisation (running per-line min/max EMA)
    // -----------------------------------------------------------------------

    private float adaptMin = 0.0f;
    private float adaptMax = 1.0f;
    private boolean normSeeded = false;

    // -----------------------------------------------------------------------
    // Image building
    // -----------------------------------------------------------------------

    private int[]  bitmapPixels  = null;
    private int    decodedLines  = 0;
    private String lastSavedPath = null;

    // -----------------------------------------------------------------------
    // Public API
    // -----------------------------------------------------------------------

    /** Call once before starting monitoring.  Resets all state. */
    public synchronized void reset() {
        ncoPhase      = 0.0;
        iLpf          = 0.0;
        qLpf          = 0.0;
        resampleAccum = 0.0;

        calibBuf      = new float[SYNC_CALIB_LINES * SAMPLES_PER_LINE];
        calibPos      = 0;
        syncCalibrated = false;
        syncOffset    = 0;

        lineBufferPos = 0;
        adaptMin      = 0.0f;
        adaptMax      = 1.0f;
        normSeeded    = false;

        bitmapPixels  = null;
        decodedLines  = 0;
        lastSavedPath = null;

        XposedBridge.log(TAG + ": reset()");
    }

    /** Call to stop monitoring (frees Bitmap memory). */
    public synchronized void stop() {
        bitmapPixels = null;
        XposedBridge.log(TAG + ": stop()");
    }

    /** Set the input PCM sample rate (call before processAudio if not 16000 Hz). */
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
        if (calibBuf == null) reset();   // Safety: ensure init

        for (int i = 0; i < length - 1; i += 2) {
            // Convert 2 bytes → 16-bit signed (little-endian)
            short raw = (short) (((data[i + 1] & 0xFF) << 8) | (data[i] & 0xFF));
            double s  = raw * (1.0 / 32768.0);

            // ── I/Q AM demodulation ──────────────────────────────────────
            double cosV = Math.cos(ncoPhase);
            double sinV = Math.sin(ncoPhase);

            // Mix with quadrature references and low-pass filter
            iLpf = lpfAlpha * (s *  cosV) + (1.0 - lpfAlpha) * iLpf;
            qLpf = lpfAlpha * (s * -sinV) + (1.0 - lpfAlpha) * qLpf;

            // Advance NCO phase
            ncoPhase += ncoIncrement;
            if (ncoPhase >= 2.0 * Math.PI) ncoPhase -= 2.0 * Math.PI;

            // Envelope magnitude
            double envelope = Math.sqrt(iLpf * iLpf + qLpf * qLpf);

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
                // Enough data — find sync offset
                syncOffset     = computeSyncOffset(calibBuf);
                syncCalibrated = true;
                XposedBridge.log(TAG + ": Sync calibrated, offset=" + syncOffset + " samples");

                // Replay calibration samples starting from the determined offset
                for (int j = syncOffset; j < calibBuf.length; j++) {
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
     * Push sample into the 2080-sample line buffer.
     * When a complete line is available, extract pixels and update the image.
     */
    private void pushToLineBuffer(float v) {
        lineBuffer[lineBufferPos++] = v;

        if (lineBufferPos >= SAMPLES_PER_LINE) {
            processLine(lineBuffer);
            lineBufferPos = 0;
        }
    }

    /**
     * Process a complete 2080-sample APT line:
     *   - Update adaptive normalisation
     *   - Extract 909+909 pixel values
     *   - Write row into the Bitmap pixel array
     *   - Fire callbacks every 30 lines / save every 300 lines
     */
    private void processLine(float[] line) {
        if (decodedLines >= MAX_IMAGE_LINES) return;

        // ── Adaptive normalisation ────────────────────────────────────────
        // Compute line min/max from the image columns only (more stable)
        float lineMin =  Float.MAX_VALUE;
        float lineMax = -Float.MAX_VALUE;
        for (int i = IMAGE_A_START; i < IMAGE_A_START + IMAGE_A_LENGTH; i++) {
            if (line[i] < lineMin) lineMin = line[i];
            if (line[i] > lineMax) lineMax = line[i];
        }
        for (int i = IMAGE_B_START; i < IMAGE_B_START + IMAGE_B_LENGTH; i++) {
            if (line[i] < lineMin) lineMin = line[i];
            if (line[i] > lineMax) lineMax = line[i];
        }

        if (!normSeeded) {
            adaptMin   = lineMin;
            adaptMax   = lineMax;
            normSeeded = true;
        } else {
            adaptMin = 0.95f * adaptMin + 0.05f * lineMin;
            adaptMax = 0.95f * adaptMax + 0.05f * lineMax;
        }

        float range = adaptMax - adaptMin;
        if (range < 1e-6f) return;

        // ── Lazy allocate pixel array ─────────────────────────────────────
        if (bitmapPixels == null) {
            bitmapPixels = new int[MAX_IMAGE_LINES * IMAGE_TOTAL_WIDTH];
        }

        // ── Fill pixel row ────────────────────────────────────────────────
        int rowStart = decodedLines * IMAGE_TOTAL_WIDTH;

        for (int i = 0; i < IMAGE_A_LENGTH; i++) {
            float v    = (line[IMAGE_A_START + i] - adaptMin) / range;
            int   gray = Math.min(255, Math.max(0, (int) (v * 255.0f)));
            bitmapPixels[rowStart + i] =
                0xFF000000 | (gray << 16) | (gray << 8) | gray;
        }
        for (int i = 0; i < IMAGE_B_LENGTH; i++) {
            float v    = (line[IMAGE_B_START + i] - adaptMin) / range;
            int   gray = Math.min(255, Math.max(0, (int) (v * 255.0f)));
            bitmapPixels[rowStart + IMAGE_A_LENGTH + i] =
                0xFF000000 | (gray << 16) | (gray << 8) | gray;
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

            String ts   = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US)
                .format(new Date());
            File   file = new File(dir, "NOAA_" + ts + ".png");

            try (FileOutputStream fos = new FileOutputStream(file)) {
                bmp.compress(Bitmap.CompressFormat.PNG, 100, fos);
            }

            lastSavedPath = file.getAbsolutePath();
            XposedBridge.log(TAG + ": Auto-saved " + decodedLines + " lines → " + lastSavedPath);

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
