import java.io.*;
import java.nio.*;
import java.util.*;
import java.awt.image.*;
import javax.imageio.*;
import javax.sound.sampled.*;

/**
 * Standalone SSTV Decoder with auto mode detection.
 * Mirrors Android SSTVAutoDetector + SSTVImageDecoderIQ logic for test/debug.
 *
 * Usage:
 *   java SSTVStandaloneDecoder <file.wav> [file2.wav ...]
 *   java SSTVStandaloneDecoder --generate-test
 */
public class SSTVStandaloneDecoder {

    // =========================================================================
    // Mode database (mirrors SSTVMode.java)
    // =========================================================================
    static final int MODE_ROBOT_36   = 0x08;
    static final int MODE_ROBOT_72   = 0x0C;
    static final int MODE_MARTIN_M1  = 0x2C;
    static final int MODE_MARTIN_M2  = 0x28;
    static final int MODE_SCOTTIE_S1 = 0x3C;
    static final int MODE_SCOTTIE_S2 = 0x38;
    static final int MODE_SCOTTIE_DX = 0x4C;
    static final int MODE_PD_120     = 0x5F;
    static final int MODE_PD_180     = 0x60;
    static final int MODE_ROBOT_8_BW  = 0x02;
    static final int MODE_ROBOT_12_BW = 0x03;
    static final int MODE_ROBOT_24_C  = 0x04;  // Robot 24 Color (Y+Ry+By, FIVE_MS)

    static final int FAMILY_FIVE_MS   = 5;
    static final int FAMILY_NINE_MS   = 9;
    static final int FAMILY_TWENTY_MS = 20;

    static class Mode {
        final int    visCode;
        final String name;
        final int    width, height;
        final boolean isRGB;
        final double lineDurationMs;
        final double fullLineDurationMs;
        final int    syncFamily;

        Mode(int vis, String name, int w, int h, boolean rgb,
             double line, double full, int fam) {
            visCode = vis; this.name = name; width = w; height = h; isRGB = rgb;
            lineDurationMs = line; fullLineDurationMs = full; syncFamily = fam;
        }

        int fullLineSamples(int sr) {
            return (int) Math.round(fullLineDurationMs * sr / 1000.0);
        }
    }

    static final Mode[] MODES = {
        new Mode(MODE_ROBOT_36,   "Robot 36",   320, 240, false,  88.0,    150.0,   FAMILY_NINE_MS),
        new Mode(MODE_ROBOT_72,   "Robot 72",   320, 240, false, 138.0,    300.0,   FAMILY_NINE_MS),
        new Mode(MODE_MARTIN_M1,  "Martin M1",  320, 256, true,  146.432,  446.446, FAMILY_FIVE_MS),
        new Mode(MODE_MARTIN_M2,  "Martin M2",  320, 256, true,   73.216,  226.798, FAMILY_FIVE_MS),
        new Mode(MODE_SCOTTIE_S1, "Scottie S1", 320, 256, true,  138.240,  428.220, FAMILY_NINE_MS),
        new Mode(MODE_SCOTTIE_S2, "Scottie S2", 320, 256, true,   88.064,  277.692, FAMILY_NINE_MS),
        new Mode(MODE_SCOTTIE_DX, "Scottie DX", 320, 256, true,  345.600, 1050.300, FAMILY_NINE_MS),
        new Mode(MODE_PD_120,     "PD 120",     640, 496, true,  121.9,    369.78,  FAMILY_TWENTY_MS),
        new Mode(MODE_PD_180,     "PD 180",     640, 496, true,  183.04,   573.2,   FAMILY_TWENTY_MS),
        new Mode(MODE_ROBOT_8_BW,  "Robot 8 BW",  160, 120, false,  56.0,   66.0,  FAMILY_FIVE_MS),
        new Mode(MODE_ROBOT_12_BW, "Robot 12 BW", 160, 120, false,  90.0,  100.0,  FAMILY_FIVE_MS),
        new Mode(MODE_ROBOT_24_C,  "Robot 24 Color", 320, 240, true,  88.0, 198.0,  FAMILY_FIVE_MS),
    };

    // =========================================================================
    // Main
    // =========================================================================
    public static void main(String[] args) throws Exception {
        System.out.println("=== SSTV Standalone Decoder (Auto-Detect) ===");
        if (args.length == 0 || args[0].equals("--help")) {
            System.out.println("Usage: java SSTVStandaloneDecoder <file.wav> [file2.wav ...]");
            System.out.println("       java SSTVStandaloneDecoder --generate-test");
            System.out.println("       java SSTVStandaloneDecoder --vis-test <file.wav>");
            return;
        }
        if (args[0].equals("--generate-test")) {
            testWithGeneratedSignal();
        } else if (args[0].equals("--vis-test")) {
            if (args.length < 2) { System.out.println("  ERROR: --vis-test requires a WAV filename"); return; }
            for (int i = 1; i < args.length; i++) runVISTest(args[i]);
        } else {
            for (String f : args) decodeFile(f);
        }
    }

    // =========================================================================
    // File I/O
    // =========================================================================
    static void decodeFile(String filename) {
        System.out.println("\n==============================");
        System.out.println("File: " + new File(filename).getName());
        System.out.println("==============================");
        try {
            File file = new File(filename);
            if (!file.exists()) { System.out.println("  ERROR: File not found"); return; }

            AudioInputStream raw = AudioSystem.getAudioInputStream(file);
            AudioFormat fmt = raw.getFormat();
            System.out.printf("  Format: %.0f Hz, %d ch, %d-bit%n",
                fmt.getSampleRate(), fmt.getChannels(), fmt.getSampleSizeInBits());

            AudioFormat target = new AudioFormat(
                AudioFormat.Encoding.PCM_SIGNED,
                fmt.getSampleRate(), 16, 1, 2, fmt.getSampleRate(), false);
            AudioInputStream converted = AudioSystem.getAudioInputStream(target, raw);
            byte[] bytes = converted.readAllBytes();
            short[] samples = bytesToShorts(bytes);
            int sr = (int) fmt.getSampleRate();
            converted.close();

            System.out.printf("  Loaded: %,d samples @ %d Hz (%.1f sec)%n",
                samples.length, sr, samples.length / (double) sr);

            String outPath = outputPathFor(filename);
            decodeSignal(samples, sr, outPath);
        } catch (Exception e) {
            System.out.println("  ERROR: " + e.getMessage());
        }
    }

    static String outputPathFor(String inputPath) {
        File f = new File(inputPath);
        String base = f.getName();
        int dot = base.lastIndexOf('.');
        if (dot > 0) base = base.substring(0, dot);
        return new File(f.getParent(), base + "_decoded.png").getAbsolutePath();
    }

    // =========================================================================
    // Core decode pipeline
    // =========================================================================
    static void decodeSignal(short[] samples, int sampleRate, String outPath) throws Exception {
        IQDemodulator demod = new IQDemodulator(sampleRate);
        int chunkSize = 1024;
        float[] tmp = new float[chunkSize];
        float[] demodulated = new float[samples.length];

        List<Integer> syncPos = new ArrayList<>();
        List<IQDemodulator.SyncPulseWidth> syncWid = new ArrayList<>();

        System.out.print("  Demodulating ");
        for (int off = 0; off < samples.length; off += chunkSize) {
            int len = Math.min(chunkSize, samples.length - off);
            short[] chunk = Arrays.copyOfRange(samples, off, off + len);
            boolean got = demod.process(chunk, tmp);
            System.arraycopy(tmp, 0, demodulated, off, len);
            if (got) {
                syncPos.add(off + demod.syncPulseOffset);
                syncWid.add(demod.syncPulseWidth);
            }
            if (off % (sampleRate * 10) < chunkSize) System.out.print(".");
        }
        System.out.println(" done. Syncs: " + syncPos.size());
        if (syncPos.size() == 0) {
            System.out.println("  NO SYNCS DETECTED");
            return;
        }

        System.out.println("  Sync spacing (first 10):");
        for (int i = 1; i < Math.min(11, syncPos.size()); i++) {
            double ms = (syncPos.get(i) - syncPos.get(i - 1)) * 1000.0 / sampleRate;
            System.out.printf("    %2d->%2d: %7.1f ms  [%s]%n", i-1, i, ms, syncWid.get(i));
        }

        Mode mode = autoDetectMode(syncPos, syncWid, sampleRate);
        if (mode == null) {
            System.out.println("  Auto-detect failed — no mode matched. Noise or insufficient data.");
            return;
        } else {
            System.out.printf("  DETECTED: %s (%dx%d, syncFamily=%dms, %.0f ms/line)%n",
                mode.name, mode.width, mode.height, mode.syncFamily, mode.fullLineDurationMs);
        }

        BufferedImage img = decodeImage(demodulated, syncPos, syncWid, mode, sampleRate);
        if (img == null) { System.out.println("  Image decode failed"); return; }

        ImageIO.write(img, "png", new File(outPath));
        System.out.println("  SAVED: " + outPath);
    }

    // =========================================================================
    // Auto mode detection (mirrors Android SSTVReceiver.tryAutoDetectMode /
    // runDetectorOnFamily / findBestModeAcrossAll — vote-counting + 15% gate)
    // =========================================================================
    static double matchToleranceFor(double lineDurationMs) {
        return Math.max(12.0, lineDurationMs * 0.015);
    }

    static Mode autoDetectMode(List<Integer> pos,
                                List<IQDemodulator.SyncPulseWidth> wid, int sr) {
        // Split by family
        int[] nineMs   = new int[pos.size()]; int nineCnt   = 0;
        int[] fiveMs   = new int[pos.size()]; int fiveCnt   = 0;
        int[] twentyMs = new int[pos.size()]; int twentyCnt = 0;
        for (int i = 0; i < wid.size(); i++) {
            int p = pos.get(i);
            switch (wid.get(i)) {
                case FIVE_MS:   fiveMs[fiveCnt++]     = p; break;
                case NINE_MS:   nineMs[nineCnt++]     = p; break;
                case TWENTY_MS: twentyMs[twentyCnt++] = p; break;
            }
        }
        System.out.printf("  Syncs: 9ms=%d  5ms=%d  20ms=%d%n", nineCnt, fiveCnt, twentyCnt);

        Mode r;
        r = runDetectorOnFamily(nineMs, nineCnt, FAMILY_NINE_MS, sr);
        if (r != null) { System.out.println("  9ms family match: " + r.name); return r; }
        r = runDetectorOnFamily(fiveMs, fiveCnt, FAMILY_FIVE_MS, sr);
        if (r != null) { System.out.println("  5ms family match: " + r.name); return r; }
        if (nineCnt == 0 || (twentyCnt >= 4 && twentyCnt > nineCnt)) {
            r = runDetectorOnFamily(twentyMs, twentyCnt, FAMILY_TWENTY_MS, sr);
            if (r != null) { System.out.println("  20ms family match: " + r.name); return r; }
        }
        // Combined-widths fallback (handles mis-classified pulses)
        int allCnt = nineCnt + fiveCnt + twentyCnt;
        if (allCnt >= 2) {
            int[] all = new int[allCnt];
            System.arraycopy(nineMs,   0, all, 0,                         nineCnt);
            System.arraycopy(fiveMs,   0, all, nineCnt,                   fiveCnt);
            System.arraycopy(twentyMs, 0, all, nineCnt + fiveCnt,         twentyCnt);
            Arrays.sort(all, 0, allCnt);
            r = findBestModeAcrossAll(all, allCnt, sr);
            if (r != null) { System.out.println("  Combined-widths match: " + r.name); return r; }
        }
        return null;
    }

    /** Vote-counting detector for one sync family — mirrors Android runDetectorOnFamily. */
    static Mode runDetectorOnFamily(int[] positions, int count, int family, int sr) {
        if (count < 2) return null;
        double[] sp = new double[count - 1];
        int nSp = 0;
        for (int i = 1; i < count; i++) {
            double ms = (positions[i] - positions[i - 1]) * 1000.0 / sr;
            if (ms > 30) sp[nSp++] = ms;
        }
        if (nSp < 4) return null;
        Mode best = null; int bestV = 0;
        for (Mode m : MODES) {
            if (m.syncFamily != family) continue;
            double tol = matchToleranceFor(m.fullLineDurationMs);
            int votes = 0;
            for (int i = 0; i < nSp; i++)
                if (Math.abs(sp[i] - m.fullLineDurationMs) < tol) votes++;
            if (votes >= 4 && (float) votes / nSp >= 0.15f && votes > bestV) {
                bestV = votes; best = m;
            }
        }
        if (best != null)
            System.out.printf("  Vote-count: %s votes=%d/%d (%.0f%%)%n",
                best.name, bestV, nSp, bestV * 100.0 / nSp);
        return best;
    }

    /** Combined-widths fallback — mirrors Android findBestModeAcrossAll. */
    static Mode findBestModeAcrossAll(int[] positions, int count, int sr) {
        if (count < 2) return null;
        double[] sp = new double[count - 1];
        int nSp = 0;
        for (int i = 1; i < count; i++) {
            double ms = (positions[i] - positions[i - 1]) * 1000.0 / sr;
            if (ms > 30) sp[nSp++] = ms;
        }
        if (nSp < 4) return null;
        Mode best = null; int bestV = 0;
        for (Mode m : MODES) {
            double tol = matchToleranceFor(m.fullLineDurationMs);
            int votes = 0;
            for (int i = 0; i < nSp; i++)
                if (Math.abs(sp[i] - m.fullLineDurationMs) < tol) votes++;
            if (votes >= 4 && (float) votes / nSp >= 0.15f && votes > bestV) {
                bestV = votes; best = m;
            }
        }
        if (best != null)
            System.out.printf("  Combined vote-count: %s votes=%d/%d (%.0f%%)%n",
                best.name, bestV, nSp, bestV * 100.0 / nSp);
        return best;
    }

    static int familyFor(IQDemodulator.SyncPulseWidth w) {
        switch (w) {
            case FIVE_MS:   return FAMILY_FIVE_MS;
            case TWENTY_MS: return FAMILY_TWENTY_MS;
            default:        return FAMILY_NINE_MS;
        }
    }

    // =========================================================================
    // Image decode dispatcher
    // =========================================================================
    static BufferedImage decodeImage(float[] demod, List<Integer> pos,
                                      List<IQDemodulator.SyncPulseWidth> wid,
                                      Mode mode, int sr) {
        IQDemodulator.SyncPulseWidth expW = expectedWidthFor(mode);
        int expLine = mode.fullLineSamples(sr);
        int minLine = (int)(expLine * 0.60);
        int maxLine = (int)(expLine * 1.40);
        List<Integer> accepted = new ArrayList<>();
        for (int i = 0; i < wid.size(); i++) { if (wid.get(i) == expW) accepted.add(pos.get(i)); }
        System.out.printf("  Accepted syncs (family=%dms): %d%n", mode.syncFamily, accepted.size());
        BufferedImage img = new BufferedImage(mode.width, mode.height, BufferedImage.TYPE_INT_RGB);
        if (mode.visCode == MODE_SCOTTIE_S1 || mode.visCode == MODE_SCOTTIE_S2 || mode.visCode == MODE_SCOTTIE_DX)
            return decodeScottie(img, demod, accepted, mode, sr, minLine, maxLine);
        if (mode.visCode == MODE_MARTIN_M1 || mode.visCode == MODE_MARTIN_M2)
            return decodeMartin(img, demod, accepted, mode, sr, minLine, maxLine);
        if (mode.visCode == MODE_ROBOT_36)
            return decodeRobot36(img, demod, accepted, mode, sr, minLine, maxLine);
        if (mode.visCode == MODE_ROBOT_72)
            return decodeRobot72(img, demod, accepted, mode, sr, minLine, maxLine, 1);
        if (mode.visCode == MODE_ROBOT_24_C)
            return decodeRobot72(img, demod, accepted, mode, sr, minLine, maxLine, 2);
        if (mode.visCode == MODE_ROBOT_8_BW || mode.visCode == MODE_ROBOT_12_BW)
            return decodeRobotBW(img, demod, accepted, mode, sr, minLine, maxLine);
        if (mode.visCode == MODE_ROBOT_24_C)
            return decodeRobot36(img, demod, accepted, mode, sr, minLine, maxLine);
        System.out.println("  WARN: No decoder for: " + mode.name);
        return img;
    }

    static IQDemodulator.SyncPulseWidth expectedWidthFor(Mode m) {
        switch (m.syncFamily) {
            case FAMILY_FIVE_MS:   return IQDemodulator.SyncPulseWidth.FIVE_MS;
            case FAMILY_TWENTY_MS: return IQDemodulator.SyncPulseWidth.TWENTY_MS;
            default:               return IQDemodulator.SyncPulseWidth.NINE_MS;
        }
    }

    // =========================================================================
    // Scottie S1/S2: [sync end] + SEP(1.5ms) + G + SEP + B + SEP + R
    // G-slot->R, B-slot->G, R-slot->B  (empirically verified mapping)
    // =========================================================================
    static BufferedImage decodeScottie(BufferedImage img, float[] demod, List<Integer> accepted,
                                        Mode mode, int sr, int minLine, int maxLine) {
        int w = mode.width;
        int sepSmp = (int) Math.round(1.5 * sr / 1000.0);
        int chSmp  = (int) Math.round(mode.lineDurationMs * sr / 1000.0);
        int lines  = 0;
        for (int i = 0; i + 1 < accepted.size() && lines < mode.height; i++) {
            int sp = accepted.get(i), sp2 = accepted.get(i+1);
            if (sp2 - sp < minLine || sp2 - sp > maxLine) continue;
            int gStart = sp + sepSmp;
            int bStart = gStart + chSmp + sepSmp;
            int rStart = bStart + chSmp + sepSmp;
            if (rStart + chSmp > demod.length) break;
            for (int x = 0; x < w; x++) {
                img.setRGB(x, lines, rgb(
                    freqToLevel(demod[gStart + (x * chSmp) / w]),
                    freqToLevel(demod[bStart + (x * chSmp) / w]),
                    freqToLevel(demod[rStart + (x * chSmp) / w])));
            }
            lines++;
        }
        System.out.printf("  Lines decoded: %d / %d%n", lines, mode.height);
        return img;
    }

    // =========================================================================
    // Martin M1/M2: [sync end] + PORCH(0.572ms) + G + SEP(0.572ms) + B + SEP + R
    // =========================================================================
    static BufferedImage decodeMartin(BufferedImage img, float[] demod, List<Integer> accepted,
                                       Mode mode, int sr, int minLine, int maxLine) {
        int w = mode.width;
        int porchSmp = (int) Math.round(0.572 * sr / 1000.0);
        int sepSmp   = (int) Math.round(0.572 * sr / 1000.0);
        int chSmp    = (int) Math.round(mode.lineDurationMs * sr / 1000.0);
        int lines    = 0;
        for (int i = 0; i + 1 < accepted.size() && lines < mode.height; i++) {
            int sp = accepted.get(i), sp2 = accepted.get(i+1);
            if (sp2 - sp < minLine || sp2 - sp > maxLine) continue;
            int gStart = sp + porchSmp;
            int bStart = gStart + chSmp + sepSmp;
            int rStart = bStart + chSmp + sepSmp;
            if (rStart + chSmp > demod.length) break;
            for (int x = 0; x < w; x++) {
                img.setRGB(x, lines, rgb(
                    freqToLevel(demod[rStart + (x * chSmp) / w]),
                    freqToLevel(demod[gStart + (x * chSmp) / w]),
                    freqToLevel(demod[bStart + (x * chSmp) / w])));
            }
            lines++;
        }
        System.out.printf("  Lines decoded: %d / %d%n", lines, mode.height);
        return img;
    }

    // =========================================================================
    // Robot 36: [sync end] + PORCH(3ms) + Y(88ms) + SEP(4.5ms) + PORCH2(1.5ms) + C(44ms)
    // Even lines: C=Cb, Odd lines: C=Cr.  Pairs combined for YCbCr->RGB.
    // =========================================================================
    static BufferedImage decodeRobot36(BufferedImage img, float[] demod, List<Integer> accepted,
                                        Mode mode, int sr, int minLine, int maxLine) {
        int w = mode.width, h = mode.height;
        int porchSmp  = (int) Math.round(3.0  * sr / 1000.0);
        int ySmp      = (int) Math.round(mode.lineDurationMs * sr / 1000.0);
        int sepSmp    = (int) Math.round(4.5  * sr / 1000.0);
        int porch2Smp = (int) Math.round(1.5  * sr / 1000.0);
        int cSmp      = ySmp / 2;
        int[][] yBuf  = new int[h][w];
        int[][] cBuf  = new int[h][w];
        int lines = 0;
        for (int i = 0; i + 1 < accepted.size() && lines < h; i++) {
            int sp = accepted.get(i), sp2 = accepted.get(i+1);
            if (sp2 - sp < minLine || sp2 - sp > maxLine) continue;
            int yStart = sp + porchSmp;
            int cStart = yStart + ySmp + sepSmp + porch2Smp;
            if (cStart + cSmp > demod.length) break;
            for (int x = 0; x < w; x++) {
                yBuf[lines][x] = freqToLevel(demod[yStart + (x * ySmp) / w]);
                cBuf[lines][x] = freqToLevel(demod[cStart + (x * cSmp) / w]);
            }
            lines++;
        }
        for (int y = 0; y < lines; y++) {
            // Buffer index 0 corresponds to an odd robot line (By/Cb), so:
            // even buffer index → By = Cb, odd buffer index → Ry = Cr
            int ei = (y % 2 == 0) ? y : Math.max(0, y - 1);
            int oi  = (y % 2 == 1) ? y : Math.min(lines - 1, y + 1);
            for (int x = 0; x < w; x++) {
                int Y = yBuf[y][x], Cb = cBuf[ei][x], Cr = cBuf[oi][x];
                img.setRGB(x, y, rgb(
                    clamp((int)(Y + 1.4020 * (Cr - 128))),
                    clamp((int)(Y - 0.3441 * (Cb - 128) - 0.7141 * (Cr - 128))),
                    clamp((int)(Y + 1.7720 * (Cb - 128)))));
            }
        }
        System.out.printf("  Lines decoded: %d / %d%n", lines, h);
        return img;
    }

    // =========================================================================
    // Robot 72: [sync end] + PORCH(3ms) + Y(138ms) + SEP+PORCH + Cb(69ms) + SEP+PORCH + Cr(69ms)
    // Each line contains full Y+Cb+Cr.
    // =========================================================================
    static BufferedImage decodeRobot72(BufferedImage img, float[] demod, List<Integer> accepted,
                                        Mode mode, int sr, int minLine, int maxLine, int rowMult) {
        int w = mode.width, h = mode.height;
        int porchSmp  = (int) Math.round(3.0  * sr / 1000.0);
        int ySmp      = (int) Math.round(mode.lineDurationMs * sr / 1000.0);
        int sepSmp    = (int) Math.round(4.5  * sr / 1000.0);
        int porch2Smp = (int) Math.round(1.5  * sr / 1000.0);
        int cSmp      = ySmp / 2;
        int lines = 0;
        for (int i = 0; i + 1 < accepted.size() && lines < h; i++) {
            int sp = accepted.get(i), sp2 = accepted.get(i+1);
            if (sp2 - sp < minLine || sp2 - sp > maxLine) continue;
            int yStart  = sp + porchSmp;
            int cbStart = yStart + ySmp + sepSmp + porch2Smp;
            int crStart = cbStart + cSmp + sepSmp + porch2Smp;
            if (crStart + cSmp > demod.length) break;
            for (int x = 0; x < w; x++) {
                int Y  = freqToLevel(demod[yStart  + (x * ySmp)  / w]);
                // Robot 72 order: Y, Ry (=Cr), By (=Cb)
                int Cr = freqToLevel(demod[cbStart + (x * cSmp)  / w]);
                int Cb = freqToLevel(demod[crStart + (x * cSmp)  / w]);
                int pixel = rgb(
                    clamp((int)(Y + 1.4020 * (Cr - 128))),
                    clamp((int)(Y - 0.3441 * (Cb - 128) - 0.7141 * (Cr - 128))),
                    clamp((int)(Y + 1.7720 * (Cb - 128))));
                for (int r = 0; r < rowMult; r++) {
                    int row = lines * rowMult + r;
                    if (row < h) img.setRGB(x, row, pixel);
                }
            }
            lines++;
        }
        System.out.printf("  Lines decoded: %d / %d%n", lines, h);
        return img;
    }

    // =========================================================================
    // Robot 8/12/24 BW: [sync end] + PORCH(4ms) + LUMA(lineDurationMs)
    // Single luminance channel → grayscale image (160×120)
    // =========================================================================
    static BufferedImage decodeRobotBW(BufferedImage img, float[] demod, List<Integer> accepted,
                                        Mode mode, int sr, int minLine, int maxLine) {
        int w = mode.width, h = mode.height;
        int porchSmp = (int) Math.round(3.0 * sr / 1000.0);
        int scanSmp  = (int) Math.round(mode.lineDurationMs * sr / 1000.0);
        int lines = 0;
        for (int i = 0; i + 1 < accepted.size() && lines < h; i++) {
            int sp = accepted.get(i), sp2 = accepted.get(i+1);
            if (sp2 - sp < minLine || sp2 - sp > maxLine) continue;
            int scanStart = sp + porchSmp;
            if (scanStart + scanSmp > demod.length) break;
            for (int x = 0; x < w; x++) {
                int Y = freqToLevel(demod[scanStart + (x * scanSmp) / w]);
                img.setRGB(x, lines, rgb(Y, Y, Y));
            }
            lines++;
        }
        System.out.printf("  Lines decoded: %d / %d%n", lines, h);
        return img;
    }

    // =========================================================================
    // VIS detection path test — mirrors Android SSTVVISDetector.findLeaderTone()
    // =========================================================================

    // VIS / leader-tone constants (mirrors SSTVVISDetector.java)
    static final float FREQ_LEADER     = 1900.0f;
    static final float GOERTZEL_THRESH = 3.5f;
    static final float PURITY_RATIO    = 2.0f;
    static final float CV_THRESHOLD    = 0.40f;
    static final int   MIN_LEADER_WINS = 8;   // 8 × 50ms = 400ms

    // FIR bandpass coeffs (1000-2500 Hz, 13-tap Hamming) — same as Android
    static final float[] BP_COEFFS = {
        -0.011f, -0.015f, 0.000f, 0.045f, 0.098f, 0.139f, 0.152f, 0.139f,
        0.098f, 0.045f, 0.000f, -0.015f, -0.011f
    };

    static void runVISTest(String filename) {
        System.out.println("\n==============================");
        System.out.println("VIS Test: " + new File(filename).getName());
        System.out.println("==============================");
        try {
            File file = new File(filename);
            if (!file.exists()) { System.out.println("  ERROR: File not found"); return; }

            AudioInputStream raw = AudioSystem.getAudioInputStream(file);
            AudioFormat fmt = raw.getFormat();
            AudioFormat target = new AudioFormat(
                AudioFormat.Encoding.PCM_SIGNED,
                fmt.getSampleRate(), 16, 1, 2, fmt.getSampleRate(), false);
            AudioInputStream converted = AudioSystem.getAudioInputStream(target, raw);
            byte[] bytes = converted.readAllBytes();
            short[] samples = bytesToShorts(bytes);
            int sr = (int) fmt.getSampleRate();
            converted.close();

            System.out.printf("  Format: %.0f Hz, %d ch, %d-bit  →  %,d samples (%.1f sec)%n",
                fmt.getSampleRate(), fmt.getChannels(), fmt.getSampleSizeInBits(),
                samples.length, samples.length / (double) sr);

            short[] filtered = bandpassFilter(samples);

            int windowSize  = (int)(sr * 0.050);   // 50ms
            int smallWindow = (int)(sr * 0.010);   // 10ms
            int step        = windowSize / 2;       // 50% overlap

            int consecutiveWindows = 0;
            boolean leaderConfirmed = false;
            float[] windowMags = new float[MIN_LEADER_WINS];

            System.out.println();
            System.out.printf("  %-8s  %-7s  %-8s  %-8s  %-8s  %-5s  %-5s  %s%n",
                "Time(ms)", "1900mag", "noiseAvg", "purity", "state", "consec", "pass", "action");
            System.out.println("  " + "-".repeat(72));

            int leaderEnd = -1;

            for (int pos = 0; pos < filtered.length - windowSize; pos += step) {
                double timeSec = pos / (double) sr;
                float mag = goertzelMag(filtered, pos, windowSize, FREQ_LEADER, sr);

                float n1 = goertzelMag(filtered, pos, windowSize, 1600.0f, sr);
                float n2 = goertzelMag(filtered, pos, windowSize, 1700.0f, sr);
                float n3 = goertzelMag(filtered, pos, windowSize, 1800.0f, sr);
                float n4 = goertzelMag(filtered, pos, windowSize, 2000.0f, sr);
                float n5 = goertzelMag(filtered, pos, windowSize, 2100.0f, sr);
                float n6 = goertzelMag(filtered, pos, windowSize, 2200.0f, sr);
                float noiseAvg = (n1 + n2 + n3 + n4 + n5 + n6) / 6.0f;
                float purity = mag / (noiseAvg + 0.001f);

                boolean threshOk  = mag > GOERTZEL_THRESH;
                boolean purityOk  = purity >= PURITY_RATIO;
                boolean bothOk    = threshOk && purityOk;

                String action = "";

                if (bothOk) {
                    if (consecutiveWindows < MIN_LEADER_WINS) {
                        windowMags[consecutiveWindows] = mag;
                    }
                    consecutiveWindows++;

                    if (consecutiveWindows >= MIN_LEADER_WINS && !leaderConfirmed) {
                        // CV check
                        float wMean = 0;
                        for (int k = 0; k < MIN_LEADER_WINS; k++) wMean += windowMags[k];
                        wMean /= MIN_LEADER_WINS;
                        float sumSq = 0;
                        for (int k = 0; k < MIN_LEADER_WINS; k++) {
                            float d = windowMags[k] - wMean;
                            sumSq += d * d;
                        }
                        float cv = (float) Math.sqrt(sumSq / MIN_LEADER_WINS) / (wMean + 0.001f);
                        if (cv > CV_THRESHOLD) {
                            action = String.format("CV=%.2f > %.2f → RESET", cv, CV_THRESHOLD);
                            consecutiveWindows = 0;
                        } else {
                            action = String.format("CV=%.2f LEADER CONFIRMED!", cv);
                            leaderConfirmed = true;
                        }
                    }
                } else if (leaderConfirmed) {
                    // Leader just ended — scan forward for precise endpoint
                    action = "Leader ended, seeking precise end...";
                    int scanEnd = Math.min(pos + windowSize * 2, filtered.length - smallWindow);
                    for (int p = pos; p < scanEnd; p += smallWindow) {
                        float m = goertzelMag(filtered, p, smallWindow, FREQ_LEADER, sr);
                        if (m < GOERTZEL_THRESH) {
                            leaderEnd = p;
                            action = "Leader end: " + p + " sample (" + String.format("%.0f", p * 1000.0 / sr) + "ms)";
                            break;
                        }
                    }
                    if (leaderEnd == -1) leaderEnd = pos;  // fallback
                    break;
                } else {
                    if (consecutiveWindows > 0) action = "reset (consec was " + consecutiveWindows + ")";
                    else if (!threshOk) action = String.format("below thresh (%.2f<%.1f)", mag, GOERTZEL_THRESH);
                    else action = String.format("purity fail (%.2f<%.1f)", purity, PURITY_RATIO);
                    consecutiveWindows = 0;
                }

                System.out.printf("  %7.0f   %7.3f  %8.3f  %7.2f   %s  %-6d  %-5s  %s%n",
                    timeSec * 1000, mag, noiseAvg, purity,
                    leaderConfirmed ? "CONFIRM" : (threshOk ? (purityOk ? "pass  " : "noPur ") : "noThr "),
                    consecutiveWindows,
                    bothOk ? "YES" : "no",
                    action);
            }

            System.out.println();
            if (leaderConfirmed || leaderEnd != -1) {
                System.out.println("  RESULT: Leader tone FOUND → false positive likely from VIS path!");
                System.out.printf("  Leader ends at sample %d (%.0f ms)%n", leaderEnd, leaderEnd * 1000.0 / sr);
            } else {
                System.out.println("  RESULT: Leader tone NOT found → VIS path correctly rejects this file.");
                System.out.printf("  Max consecutive passing windows: (check table above)%n");
            }

        } catch (Exception e) {
            System.out.println("  ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /** Goertzel magnitude, normalized by window length. Mirrors Android SSTVVISDetector. */
    static float goertzelMag(short[] samples, int start, int length, float frequency, int sr) {
        float k       = (int)(0.5f + (length * frequency) / sr);
        float w       = 2.0f * (float) Math.PI * k / length;
        float cosine  = (float) Math.cos(w);
        float coeff   = 2.0f * cosine;
        float q0 = 0, q1 = 0, q2 = 0;
        int end = Math.min(start + length, samples.length);
        for (int i = start; i < end; i++) {
            q0 = coeff * q1 - q2 + samples[i];
            q2 = q1;
            q1 = q0;
        }
        float real = q1 - q2 * cosine;
        float imag = q2 * (float) Math.sin(w);
        return (float) Math.sqrt(real * real + imag * imag) / length;
    }

    /** 13-tap Hamming FIR bandpass (1000-2500 Hz). Mirrors Android's applyBandpassFilter. */
    static short[] bandpassFilter(short[] samples) {
        short[] out = new short[samples.length];
        int len = BP_COEFFS.length;
        for (int i = 0; i < samples.length; i++) {
            float sum = 0;
            for (int j = 0; j < len; j++) {
                int idx = i - j;
                if (idx >= 0) sum += samples[idx] * BP_COEFFS[j];
            }
            out[i] = (short) Math.max(-32768, Math.min(32767, (int) sum));
        }
        return out;
    }

    // =========================================================================
    // Test signal: Scottie S2, 10 lines with gradient
    // =========================================================================

    static void testWithGeneratedSignal() throws Exception {
        System.out.println("Generating Scottie S2 test signal...");
        int sr = 16000; Mode m = MODES[5];
        int syncSmp = (int)(9.0 * sr / 1000);
        int sepSmp  = (int) Math.round(1.5 * sr / 1000.0);
        int chSmp   = (int) Math.round(m.lineDurationMs * sr / 1000.0);
        int lineLen = syncSmp + 3 * sepSmp + 3 * chSmp;
        short[] samples = new short[lineLen * 10];
        int idx = 0;
        for (int line = 0; line < 10; line++) {
            for (int i = 0; i < syncSmp; i++) samples[idx++] = (short)(25000 * Math.sin(2 * Math.PI * 1200.0 * idx / sr));
            for (int ch = 0; ch < 3; ch++) {
                for (int i = 0; i < sepSmp; i++) samples[idx++] = (short)(25000 * Math.sin(2 * Math.PI * 1500.0 * idx / sr));
                for (int i = 0; i < chSmp; i++) { double f = 1500.0 + 800.0 * i / chSmp; samples[idx++] = (short)(25000 * Math.sin(2 * Math.PI * f * idx / sr)); }
            }
        }
        decodeSignal(samples, sr, "test_generated_decoded.png");
    }

    // =========================================================================
    // Helpers
    // =========================================================================
    static int freqToLevel(float n) {
        return (int)(Math.max(0f, Math.min(1f, (n + 0.444f) / 0.888f)) * 255f);
    }
    static int clamp(int v) { return Math.max(0, Math.min(255, v)); }
    static int rgb(int r, int g, int b) { return (r << 16) | (g << 8) | b; }

    private static short[] bytesToShorts(byte[] bytes) {
        short[] s = new short[bytes.length / 2];
        ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(s);
        return s;
    }
    private static byte[] shortsToBytes(short[] shorts) {
        byte[] b = new byte[shorts.length * 2];
        ByteBuffer.wrap(b).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().put(shorts);
        return b;
    }
}
/**
 * Simplified IQ Demodulator for standalone testing
 */
class IQDemodulator {
    private static final double SYNC_PULSE_FREQ = 1200.0;
    private static final double BLACK_FREQ = 1500.0;
    private static final double WHITE_FREQ = 2300.0;
    
    private final int sampleRate;
    private final double centerFrequency;
    private final double signalBandwidth;
    private final double scanLineBandwidth;
    
    private final int syncPulse5msMaxSamples;
    private final int syncPulse9msMaxSamples;
    private final int syncPulseFilterDelay;
    
    private final Phasor basebandOscillator;
    private final ComplexConvolution basebandFilter;
    private final FrequencyModulation fmDemod;
    private final SimpleMovingAverage syncPulseFilter;
    private final Delay syncPulseValueDelay;
    private final SchmittTrigger syncTrigger;
    
    private final float syncPulseFrequencyValue;
    private final float syncPulseFrequencyTolerance;
    
    private Complex baseband = new Complex();
    private int syncPulseCounter = 0;
    private int sampleCounter = 0;  // For debugging
    
    public enum SyncPulseWidth { FIVE_MS, NINE_MS, TWENTY_MS }
    public SyncPulseWidth syncPulseWidth;
    public int syncPulseOffset;
    public float frequencyOffset;
    public int lastSyncCounter;  // For debugging
    
    public IQDemodulator(int sampleRate) {
        this.sampleRate = sampleRate;
        this.scanLineBandwidth = WHITE_FREQ - BLACK_FREQ;
        
        double lowestFrequency = 1000;
        double highestFrequency = 2800;
        this.signalBandwidth = highestFrequency - lowestFrequency;
        this.centerFrequency = (lowestFrequency + highestFrequency) / 2;
        
        // Timing thresholds
        syncPulse5msMaxSamples = (int)Math.round(0.007 * sampleRate);  // 7ms
        syncPulse9msMaxSamples = (int)Math.round(0.0145 * sampleRate);  // 14.5ms
        
        // Filters
        int syncFilterSamples = (int)Math.round(0.0025 * sampleRate) | 1;
        syncPulseFilterDelay = (syncFilterSamples - 1) / 2;
        syncPulseFilter = new SimpleMovingAverage(syncFilterSamples);
        syncPulseValueDelay = new Delay(syncFilterSamples);
        
        int basebandFilterSamples = (int)Math.round(0.002 * sampleRate) | 1;
        double cutoffFreq = 900;
        basebandFilter = new ComplexConvolution(basebandFilterSamples, cutoffFreq, sampleRate);
        
        basebandOscillator = new Phasor(-centerFrequency, sampleRate);
        fmDemod = new FrequencyModulation(signalBandwidth, sampleRate);  // Use full signal bandwidth
        
        // Sync detection
        syncPulseFrequencyValue = (float)normalizeFrequency(SYNC_PULSE_FREQ);
        syncPulseFrequencyTolerance = (float)(100 * 2 / signalBandwidth);  // Â±100 Hz tolerance
        
        // Schmitt trigger thresholds: sync is at -0.778, so trigger below -0.7 and above -0.5
        double syncLowFrequency = 1250;  // Slightly above sync (trigger when dropping below)
        double syncHighFrequency = 1400;  // Between sync and black (trigger when rising above)
        syncTrigger = new SchmittTrigger(
            (float)normalizeFrequency(syncLowFrequency),
            (float)normalizeFrequency(syncHighFrequency)
        );
        
        System.out.printf("   IQ Demod: center=%.0f Hz, signal BW=%.0f Hz, scan BW=%.0f Hz\n",
            centerFrequency, signalBandwidth, scanLineBandwidth);
        System.out.printf("   Sync: value=%.3f (%.0f Hz), tolerance=Â±%.3f\n",
            syncPulseFrequencyValue, SYNC_PULSE_FREQ, syncPulseFrequencyTolerance);
        System.out.printf("   Schmitt: low=%.3f (%.0f Hz), high=%.3f (%.0f Hz)\n",
            normalizeFrequency(syncLowFrequency), syncLowFrequency,
            normalizeFrequency(syncHighFrequency), syncHighFrequency);
    }
    
    private double normalizeFrequency(double frequency) {
        return (frequency - centerFrequency) * 2 / signalBandwidth;
    }
    
    public boolean process(short[] audioBuffer, float[] demodBuffer) {
        boolean syncPulseDetected = false;
        
        // Debug: Sample some values
        boolean firstChunk = (sampleCounter < 100);
        int debugInterval = 100;
        
        for (int i = 0; i < audioBuffer.length; i++) {
            float sample = audioBuffer[i] / 32768.0f;
            
            // IQ demodulation
            baseband.set(sample);
            baseband = basebandFilter.push(baseband.mul(basebandOscillator.rotate()));
            float frequencyValue = fmDemod.demod(baseband);
            
            // Sync detection
            float syncPulseValue = syncPulseFilter.avg(frequencyValue);
            float syncPulseDelayedValue = syncPulseValueDelay.push(syncPulseValue);
            
            demodBuffer[i] = frequencyValue;
            
            // Debug output
            if (firstChunk && sampleCounter % debugInterval == 0) {
                System.out.printf("      Sample %d: freq=%.3f, sync=%.3f, trigger=%s, counter=%d\n",
                    sampleCounter, frequencyValue, syncPulseValue, syncTrigger.state, syncPulseCounter);
            }
            sampleCounter++;
            
            if (!syncTrigger.latch(syncPulseValue)) {
                syncPulseCounter++;
            } else if (syncPulseCounter >= 20 && syncPulseCounter <= 200 &&
                       Math.abs(syncPulseDelayedValue - syncPulseFrequencyValue) <= syncPulseFrequencyTolerance) {
                // Valid sync
                if (syncPulseCounter < syncPulse5msMaxSamples) {
                    syncPulseWidth = SyncPulseWidth.FIVE_MS;
                } else if (syncPulseCounter < syncPulse9msMaxSamples) {
                    syncPulseWidth = SyncPulseWidth.NINE_MS;
                } else {
                    syncPulseWidth = SyncPulseWidth.TWENTY_MS;
                }
                syncPulseOffset = i - syncPulseFilterDelay;
                frequencyOffset = syncPulseDelayedValue - syncPulseFrequencyValue;
                lastSyncCounter = syncPulseCounter;
                syncPulseDetected = true;
                syncPulseCounter = 0;
            } else {
                syncPulseCounter = 0;
            }
        }
        
        return syncPulseDetected;
    }
}

// Helper classes (simplified versions)
class Complex {
    float real, imag;
    void set(float r) { real = r; imag = 0; }
    Complex mul(Complex other) {
        return new Complex(real * other.real - imag * other.imag,
                          real * other.imag + imag * other.real);
    }
    float arg() { return (float)Math.atan2(imag, real); }
    Complex() { real = 0; imag = 0; }
    Complex(float r, float i) { real = r; imag = i; }
}

class Phasor {
    private Complex rotation;
    private Complex position = new Complex(1, 0);
    Phasor(double frequency, int sampleRate) {
        double angle = 2 * Math.PI * frequency / sampleRate;
        rotation = new Complex((float)Math.cos(angle), (float)Math.sin(angle));
    }
    Complex rotate() {
        Complex result = new Complex(position.real, position.imag);
        position = position.mul(rotation);
        // Normalize periodically
        float mag = (float)Math.sqrt(position.real * position.real + position.imag * position.imag);
        if (Math.abs(mag - 1.0) > 0.01) {
            position.real /= mag;
            position.imag /= mag;
        }
        return result;
    }
}

class ComplexConvolution {
    private float[] taps;
    private Complex[] buffer;
    private int pos = 0;
    
    ComplexConvolution(int length, double cutoffFreq, int sampleRate) {
        taps = new float[length];
        buffer = new Complex[length];
        for (int i = 0; i < length; i++) buffer[i] = new Complex();
        
        // Kaiser window + sinc filter
        for (int i = 0; i < length; i++) {
            double window = kaiser(i, length);
            double normalized = 2.0 * cutoffFreq / sampleRate;
            int center = (length - 1) / 2;
            double x = Math.PI * normalized * (i - center);
            taps[i] = (float)(window * (x == 0 ? normalized : Math.sin(x) / (Math.PI * (i - center))));
        }
    }
    
    private double kaiser(int i, int length) {
        double alpha = 2.0;
        double x = 2.0 * i / (length - 1) - 1.0;
        return i0(alpha * Math.sqrt(1 - x * x)) / i0(alpha);
    }
    
    private double i0(double x) {
        double sum = 1, term = 1;
        for (int n = 1; n < 20; n++) {
            term *= (x / (2.0 * n)) * (x / (2.0 * n));
            sum += term;
        }
        return sum;
    }
    
    Complex push(Complex sample) {
        buffer[pos] = new Complex(sample.real, sample.imag);
        pos = (pos + 1) % buffer.length;
        
        Complex result = new Complex();
        for (int i = 0; i < buffer.length; i++) {
            int idx = (pos + i) % buffer.length;
            result.real += buffer[idx].real * taps[i];
            result.imag += buffer[idx].imag * taps[i];
        }
        return result;
    }
}

class FrequencyModulation {
    private Complex prev = new Complex(1, 0);
    private double signalBandwidth;  // Use full signal bandwidth, not just scanline
    private int sampleRate;
    
    FrequencyModulation(double signalBandwidth, int sampleRate) {
        this.signalBandwidth = signalBandwidth;
        this.sampleRate = sampleRate;
    }
    
    float demod(Complex sample) {
        // Phase difference
        Complex conjugate = new Complex(prev.real, -prev.imag);
        Complex product = sample.mul(conjugate);
        float phase = product.arg();
        prev = new Complex(sample.real, sample.imag);
        
        // Convert phase diff (radians/sample) to normalized frequency [-1, +1]
        // phase * sampleRate / (2*PI) = Hz deviation from center
        // Normalize by half bandwidth to get [-1, +1] range
        float frequency = phase * sampleRate / ((float)Math.PI * (float)signalBandwidth);
        return Math.max(-1, Math.min(1, frequency));
    }
}

class SimpleMovingAverage {
    private float[] buffer;
    private int pos = 0;
    private float sum = 0;
    
    SimpleMovingAverage(int length) {
        buffer = new float[length];
    }
    
    float avg(float sample) {
        sum -= buffer[pos];
        buffer[pos] = sample;
        sum += sample;
        pos = (pos + 1) % buffer.length;
        return sum / buffer.length;
    }
}

class Delay {
    private float[] buffer;
    private int pos = 0;
    
    Delay(int length) {
        buffer = new float[length];
    }
    
    float push(float sample) {
        float result = buffer[pos];
        buffer[pos] = sample;
        pos = (pos + 1) % buffer.length;
        return result;
    }
}

class SchmittTrigger {
    private float low, high;
    boolean state = true;  // Made public for debugging
    
    SchmittTrigger(float low, float high) {
        this.low = low;
        this.high = high;
    }
    
    boolean latch(float value) {
        if (value < low) state = false;
        else if (value > high) state = true;
        return state;
    }
}