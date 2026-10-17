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
 *   Input (8 kHz, L==R)  →  AM demod (I/Q mix + FIR LPF + envelope notches)  →  resample to 4160 Hz
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
    // AM demodulation state  (I/Q mix + FIR low-pass + envelope-domain notches)
    // -----------------------------------------------------------------------

    /** Real input PCM sample rate. The OEM RX stream is 8 kHz stereo with L == R (measured
     *  2026-10-14), so one sample per 4-byte frame at 8000 Hz. */
    private int     inputRate        = 8000;
    /** Bytes per input sample: 4 when the buffer is the stereo-duplicated OEM stream, 2 for mono. */
    private int     bytesPerSample   = 4;
    private double  ncoPhase         = 0.0;
    private double  ncoIncrement     = 2.0 * Math.PI * SUBCARRIER_HZ / 8000.0;

    /** Windowed-sinc FIR low-pass on I and Q (fc 2 kHz = APT Nyquist, Hamming, 41 taps). At 8 kHz the
     *  2x-subcarrier mixing product lands at 3.2 kHz, well inside the stop band (about -50 dB); the old
     *  2-pole 1 kHz IIR left ~5 % of it, which the sample-and-hold decimation then aliased into a
     *  fixed vertical stripe pattern. */
    private static final int FIR_TAPS = 41;
    private double[] firTaps = designLowPass(8000);
    private final double[] iHist = new double[FIR_TAPS];
    private final double[] qHist = new double[FIR_TAPS];
    private int histPos = 0;

    /** Envelope-domain notches at 800 and 1600 Hz. With a real satellite's +/-17 kHz deviation the
     *  radio's narrow-FM discriminator distorts: the 2nd/3rd harmonics of the 2400 Hz subcarrier
     *  (4800/7200 Hz) alias through the 8 kHz audio path to 3200/800 Hz (measured -26/-15 dB,
     *  2026-10-17, HackRF bench) and beat with the carrier at 800/1600 Hz in the envelope. Notching
     *  those two lines removed most of the striping (bench correlation 0.885 -> 0.937); at +/-5 kHz
     *  the audio is clean and the notches cost nothing visible. */
    private final Biquad notch800  = new Biquad();
    private final Biquad notch1600 = new Biquad();

    /** Linear-interpolation resampler state (input-sample index of the next APT word). */
    private double prevEnv = 0.0;
    private double nextOut = 0.0;
    private long   inIndex = 0;

    /** Counts input samples processed during calibration phase (for logging). */
    private long calibInputSamples = 0;

    private static double[] designLowPass(int rate) {
        double[] h = new double[FIR_TAPS];
        double fc = 2000.0 / rate, sum = 0;
        for (int k = 0; k < FIR_TAPS; k++) {
            double m = k - (FIR_TAPS - 1) / 2.0;
            double sinc = (m == 0) ? 2 * fc : Math.sin(2 * Math.PI * fc * m) / (Math.PI * m);
            double w = 0.54 - 0.46 * Math.cos(2 * Math.PI * k / (FIR_TAPS - 1));
            h[k] = sinc * w; sum += h[k];
        }
        for (int k = 0; k < FIR_TAPS; k++) h[k] /= sum;
        return h;
    }

    /** Direct-form biquad notch. */
    private static final class Biquad {
        private double b0 = 1, b1 = 0, b2 = 0, a1 = 0, a2 = 0, x1, x2, y1, y2;
        void notch(double rate, double f0, double q) {
            double w0 = 2 * Math.PI * f0 / rate, alpha = Math.sin(w0) / (2 * q), a0 = 1 + alpha;
            b0 = 1 / a0; b1 = -2 * Math.cos(w0) / a0; b2 = 1 / a0;
            a1 = -2 * Math.cos(w0) / a0; a2 = (1 - alpha) / a0;
            x1 = x2 = y1 = y2 = 0;
        }
        double process(double x) {
            double y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
            x2 = x1; x1 = x; y2 = y1; y1 = y; return y;
        }
    }

    /** Matched-filter template for sync A: 39 words, 4 low, 7 x (2 high, 2 low) = 1040 Hz, 7 low;
     *  zero-mean so a DC offset in the envelope does not bias the correlation. Sync B (832 Hz,
     *  3-high/2-low) correlates ~4x weaker, which is what disambiguates A from B. */
    private static final float[] SYNC_A_TPL = new float[39];
    static {
        for (int k = 0; k < 39; k++) SYNC_A_TPL[k] = -1f;
        for (int c = 0; c < 7; c++) { SYNC_A_TPL[4 + c * 4] = 1f; SYNC_A_TPL[5 + c * 4] = 1f; }
        float mean = 0; for (float v : SYNC_A_TPL) mean += v; mean /= 39;
        for (int k = 0; k < 39; k++) SYNC_A_TPL[k] -= mean;
    }

    /** Running 1st/99th-percentile normalisation (EMA across lines). Per-line stretching made every
     *  line's contrast independent (flicker, broken wedges); this tracks slowly instead. */
    private float   normLo = 0, normHi = 1;
    private boolean normInit = false;

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

    // Room for one line + the per-line search window, plus a second line so that a lost lock
    // (audio gap, e.g. the ~1.2 s a Doppler retune costs) can be re-acquired with a full-line search.
    private final float[] lineBuffer    = new float[2 * SAMPLES_PER_LINE + 2 * SYNC_MARGIN];
    /** EMA of the per-line best sync score; a line scoring far below it means the lock is lost. */
    private double syncScoreAvg = 0;
    private int    weakLines    = 0;
    private boolean resyncMode  = false;
    private int    resyncCount  = 0;
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
    private static final int WAV_CAPTURE_MAX_BYTES = 90 * 8000 * 2;  // 90 s @ 8 kHz 16-bit mono (one sample per L/R pair)
    private FileOutputStream wavCapStream = null;
    private String           wavCapPath   = null;
    private int              wavBytesWritten = 0;

    // -----------------------------------------------------------------------
    // Public API
    // -----------------------------------------------------------------------

    /** Call once before starting monitoring.  Resets all state. */
    public synchronized void reset() {
        ncoPhase      = 0.0;
        java.util.Arrays.fill(iHist, 0.0);
        java.util.Arrays.fill(qHist, 0.0);
        histPos       = 0;
        notch800.notch(inputRate, 800, 8);
        notch1600.notch(inputRate, 1600, 8);
        prevEnv       = 0.0;
        nextOut       = 0.0;
        inIndex       = 0;
        normInit      = false;

        calibBuf      = new float[SYNC_CALIB_LINES * SAMPLES_PER_LINE];
        calibPos      = 0;
        syncCalibrated = false;
        syncOffset    = 0;
        calibInputSamples  = 0;

        lineBufferPos    = 0;
        lineExpectedSync = SYNC_MARGIN;
        syncScoreAvg     = 0;
        weakLines        = 0;
        resyncMode       = false;
        resyncCount      = 0;

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

    /** Set the real input PCM sample rate and frame layout (default 8000 Hz, stereo-duplicated). */
    public void setInputFormat(int rate, boolean stereoDuplicated) {
        inputRate      = rate;
        bytesPerSample = stereoDuplicated ? 4 : 2;
        ncoIncrement   = 2.0 * Math.PI * SUBCARRIER_HZ / rate;
        firTaps        = designLowPass(rate);
        notch800.notch(rate, 800, 8);
        notch1600.notch(rate, 1600, 8);
        XposedBridge.log(TAG + ": input " + rate + " Hz, " + bytesPerSample + " bytes/sample");
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
        return "Decoding — " + decodedLines + " lines" + (resyncCount > 0 ? " (re-synced " + resyncCount + "×)" : "");
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
            try {
                // keep one 16-bit sample per input frame (the stream is L == R) -> true 8 kHz mono
                int frames = length / bytesPerSample;
                int toWrite = Math.min(frames * 2, WAV_CAPTURE_MAX_BYTES - wavBytesWritten);
                byte[] mono = new byte[toWrite];
                for (int f = 0, o = 0; o + 1 < toWrite; f += bytesPerSample, o += 2) { mono[o] = data[f]; mono[o + 1] = data[f + 1]; }
                wavCapStream.write(mono, 0, toWrite);
                wavBytesWritten += toWrite;
                if (wavBytesWritten >= WAV_CAPTURE_MAX_BYTES) {
                    stopWavCapture();  // Seal the file once we have enough
                }
            } catch (Exception e) {
                XposedBridge.log(TAG + ": WAV write error: " + e.getMessage());
            }
        }

        final double twoPi = 2.0 * Math.PI;
        final double outStep = (double) inputRate / APT_RATE;
        for (int i = 0; i + 1 < length; i += bytesPerSample) {
            if (!syncCalibrated) calibInputSamples++;

            short raw = (short) (((data[i + 1] & 0xFF) << 8) | (data[i] & 0xFF));
            double sIn = raw * (1.0 / 32768.0);

            // -- I/Q mix with the 2400 Hz NCO --------------------------------
            double c = Math.cos(ncoPhase), sn = Math.sin(ncoPhase);
            ncoPhase += ncoIncrement;
            if (ncoPhase >= twoPi) ncoPhase -= twoPi;
            iHist[histPos] = sIn * c;
            qHist[histPos] = -sIn * sn;

            // -- FIR low-pass (circular history, newest at histPos) -----------
            double iAcc = 0, qAcc = 0; int idx = histPos;
            for (int k = 0; k < FIR_TAPS; k++) {
                iAcc += firTaps[k] * iHist[idx];
                qAcc += firTaps[k] * qHist[idx];
                idx = (idx == 0) ? FIR_TAPS - 1 : idx - 1;
            }
            histPos = (histPos + 1 == FIR_TAPS) ? 0 : histPos + 1;

            // -- Envelope, then notch the discriminator-harmonic beats --------
            double env = Math.sqrt(iAcc * iAcc + qAcc * qAcc);
            env = notch1600.process(notch800.process(env));

            // -- Resample to 4160 Hz (linear interpolation) ------------------
            while (nextOut <= inIndex) {
                double frac = nextOut - (inIndex - 1);
                if (frac < 0) frac = 0; else if (frac > 1) frac = 1;
                pushAptSample((float) (prevEnv * (1 - frac) + env * frac));
                nextOut += outStep;
            }
            prevEnv = env;
            inIndex++;
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
                    + "  inputRate=" + inputRate);

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
     *   3. Carry over the SYNC_MARGIN samples before the next expected sync
     *      so that the search window is symmetric for the following line.
     */
    private void pushToLineBuffer(float v) {
        if (lineBufferPos >= lineBuffer.length) { lineBufferPos = 0; resyncMode = true; }
        lineBuffer[lineBufferPos++] = v;

        // Trigger once we have: expected-sync + full line + margin samples (two lines in re-sync mode)
        int needed = resyncMode ? 2 * SAMPLES_PER_LINE + 39
                                : lineExpectedSync + SAMPLES_PER_LINE + SYNC_MARGIN;
        if (lineBufferPos < needed) return;

        int foundSync;
        if (resyncMode) {
            // ── Lock lost: search a whole line span for the strongest sync A ──
            foundSync = findSyncInRange(lineBuffer, 0, SAMPLES_PER_LINE - 1);
            double sc = syncScore(lineBuffer, foundSync);
            resyncMode = false; weakLines = 0; syncScoreAvg = sc; resyncCount++;
            XposedBridge.log(TAG + ": re-synced at +" + foundSync + " words (score "
                + String.format("%.2f", sc) + ", #" + resyncCount + ")");
        } else {
            // ── Find actual sync A within ±SYNC_MARGIN of expected position ──
            int searchStart = Math.max(0, lineExpectedSync - SYNC_MARGIN);
            int searchEnd   = Math.min(lineBufferPos - SAMPLES_PER_LINE - 1,
                                       lineExpectedSync + SYNC_MARGIN);
            foundSync = findSyncInRange(lineBuffer, searchStart, searchEnd);
            double sc = syncScore(lineBuffer, foundSync);
            if (syncScoreAvg <= 0) syncScoreAvg = sc;
            if (sc < 0.35 * syncScoreAvg) {
                // two consecutive weak matches → the sync moved outside the window
                if (++weakLines >= 2) {
                    resyncMode = true; weakLines = 0;
                    return;   // keep accumulating; the full search runs once 2 lines are buffered
                }
            } else {
                weakLines = 0;
                syncScoreAvg = 0.9 * syncScoreAvg + 0.1 * sc;
            }
        }

        // No rate correction: the +/-SYNC_MARGIN search re-locks every line (timing is drift-free).

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
        lineBufferPos    = Math.max(0, Math.min(remaining, lineBuffer.length));
        lineExpectedSync = SYNC_MARGIN;  // next sync expected in the middle of the buffer
    }

    /** Matched-filter correlation of the sync A template at buf[pos..pos+38]. */
    private static double syncScore(float[] buf, int pos) {
        double acc = 0;
        for (int k = 0; k < 39; k++) acc += SYNC_A_TPL[k] * buf[pos + k];
        return acc;
    }

    /** Position in [searchStart..searchEnd] with the best sync A match. */
    private static int findSyncInRange(float[] buf, int searchStart, int searchEnd) {
        double best = -Double.MAX_VALUE;
        int    bestPos = (searchStart + searchEnd) / 2;
        for (int pos = searchStart; pos <= searchEnd; pos++) {
            if (pos + 39 > buf.length) break;
            double sc = syncScore(buf, pos);
            if (sc > best) { best = sc; bestPos = pos; }
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
        // 1% of 1818 ~ index 18;  99% ~ index 1799 -- tracked with an EMA across lines
        if (!normInit) { normLo = normBuf[18]; normHi = normBuf[1799]; normInit = true; }
        else { normLo = 0.9f * normLo + 0.1f * normBuf[18]; normHi = 0.9f * normHi + 0.1f * normBuf[1799]; }
        float lineMin = normLo;
        float range   = normHi - normLo;
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
     * Determine the sync A column from SYNC_CALIB_LINES x SAMPLES_PER_LINE APT words: fold the
     * matched-filter correlation modulo one line and take the best column. Unlike the old
     * high-frequency-energy metric this distinguishes sync A (1040 Hz) from sync B (832 Hz), so the
     * two image channels no longer come out swapped.
     */
    private static int computeSyncOffset(float[] calibBuf) {
        int nLines = calibBuf.length / SAMPLES_PER_LINE;
        double[] profile = new double[SAMPLES_PER_LINE];
        for (int line = 0; line < nLines; line++) {
            int base = line * SAMPLES_PER_LINE;
            for (int col = 0; col < SAMPLES_PER_LINE; col++) {
                if (base + col + 39 > calibBuf.length) break;
                profile[col] += syncScore(calibBuf, base + col);
            }
        }
        int best = 0;
        for (int col = 1; col < SAMPLES_PER_LINE; col++) if (profile[col] > profile[best]) best = col;
        return best;
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
