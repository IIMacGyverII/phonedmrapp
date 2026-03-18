package com.dmrmod.hooks;

import de.robv.android.xposed.XposedBridge;
import com.example.dmrmodhooks.sstv.SSTVIQDemodulator;

/**
 * SSTV Sync-Based Auto Mode Detector
 *
 * When the VIS code is missing or corrupted, uses sync pulse width + scan line
 * duration to identify the SSTV mode.  Only requires 4-5 consecutive sync pulses.
 *
 * Algorithm (mirrors robot36-2 Decoder.handleHeader() fallback):
 *  1. Classify sync pulse width → mode family (5ms=Martin, 9ms=Scottie/Robot, 20ms=PD)
 *  2. Measure mean scan-line duration from consecutive sync positions
 *  3. Verify consistency (std dev < tolerance)
 *  4. Match mean duration to closest mode in family
 */
public class SSTVAutoDetector {
    private static final String TAG = "DMRModHooks-SSTV-AutoDetect";

    /**
     * Tolerance for scan-line duration matching.
     * Scaled by line duration so long-period modes (ScottieDX 1050ms) get more headroom
     * than short ones (Robot 8 BW 66ms).  Base is 1.5% of line duration, minimum 12ms.
     */
    static double matchToleranceFor(double lineDurationMs) {
        return Math.max(12.0, lineDurationMs * 0.015);
    }

    /** Minimum number of sync pulses needed for a reliable measurement */
    public static final int MIN_SYNCS = 4;

    private final int sampleRate;

    // Ring buffer of the last MIN_SYNCS+1 sync pulse sample positions
    private final int[] syncPositions = new int[MIN_SYNCS + 1];
    private int syncCount = 0;

    // Observed sync pulse family (FIVE_MS / NINE_MS / TWENTY_MS)
    private int observedFamily = -1;

    public SSTVAutoDetector(int sampleRate) {
        this.sampleRate = sampleRate;
    }

    /** Reset state for a new transmission */
    public void reset() {
        syncCount = 0;
        observedFamily = -1;
    }

    /**
     * Feed a detected sync pulse.
     *
     * @param syncSampleIndex  Absolute sample position of this sync pulse end
     * @param syncWidth        Width classification from IQDemodulator
     * @return Detected mode if enough data, null if still collecting
     */
    public SSTVMode.Mode feedSync(int syncSampleIndex,
                                   SSTVIQDemodulator.SyncPulseWidth syncWidth) {
        int family = familyFor(syncWidth);

        // If family changes mid-sequence reset to avoid mixing different streams
        if (observedFamily != -1 && family != observedFamily) {
            XposedBridge.log(TAG + ": Sync family changed " + observedFamily + " → " + family + ", resetting");
            syncCount = 0;
        }
        observedFamily = family;

        // Shift ring buffer
        if (syncCount < syncPositions.length) {
            syncPositions[syncCount++] = syncSampleIndex;
        } else {
            System.arraycopy(syncPositions, 1, syncPositions, 0, syncPositions.length - 1);
            syncPositions[syncPositions.length - 1] = syncSampleIndex;
        }

        if (syncCount < MIN_SYNCS + 1) {
            return null;  // Need more data
        }

        // Compute scan-line spacings
        double[] spacingMs = new double[MIN_SYNCS];
        for (int i = 0; i < MIN_SYNCS; i++) {
            spacingMs[i] = (syncPositions[i + 1] - syncPositions[i]) * 1000.0 / sampleRate;
        }

        double mean = mean(spacingMs);
        double std  = stdDev(spacingMs, mean);

        XposedBridge.log(TAG + ": Auto-detect syncs=" + syncCount
                + " family=" + family + " meanLine=" + String.format("%.1f", mean)
                + "ms stdDev=" + String.format("%.1f", std) + "ms");

        if (std > matchToleranceFor(mean)) {
            XposedBridge.log(TAG + ": Scan-line spacing too noisy (std=" + std + "), waiting");
            return null;
        }

        return matchMode(family, mean);
    }

    /**
     * Try to detect mode directly from a pre-computed mean scan line duration.
     * Useful when the caller has already accumulated sync data.
     */
    public SSTVMode.Mode detectFromMean(SSTVIQDemodulator.SyncPulseWidth syncWidth,
                                         double meanScanLineMs) {
        return matchMode(familyFor(syncWidth), meanScanLineMs);
    }

    // -------------------------------------------------------------------------
    // Private helpers
    // -------------------------------------------------------------------------

    private SSTVMode.Mode matchMode(int family, double meanMs) {
        SSTVMode.Mode[] candidates = SSTVMode.getModesByFamily(family);
        SSTVMode.Mode best = null;
        double bestDist = Double.MAX_VALUE;

        for (SSTVMode.Mode m : candidates) {
            double tol  = matchToleranceFor(m.fullLineDurationMs);
            double dist = Math.abs(m.fullLineDurationMs - meanMs);
            if (dist < tol && dist < bestDist) {
                bestDist = dist;
                best = m;
            }
        }

        if (best != null) {
            XposedBridge.log(TAG + ": ✓ Auto-detected: " + best.name
                    + " (line=" + String.format("%.1f", best.fullLineDurationMs)
                    + "ms, measured=" + String.format("%.1f", meanMs)
                    + "ms, Δ=" + String.format("%.1f", bestDist) + "ms)");
        } else {
            XposedBridge.log(TAG + ": ✗ No match for family=" + family
                    + " meanLine=" + String.format("%.1f", meanMs) + "ms");
        }

        return best;
    }

    private static int familyFor(SSTVIQDemodulator.SyncPulseWidth w) {
        switch (w) {
            case FIVE_MS:    return SSTVMode.SYNC_FAMILY_FIVE_MS;
            case NINE_MS:    return SSTVMode.SYNC_FAMILY_NINE_MS;
            case TWENTY_MS:  return SSTVMode.SYNC_FAMILY_TWENTY_MS;
            default:         return SSTVMode.SYNC_FAMILY_NINE_MS;
        }
    }

    private static double mean(double[] v) {
        double s = 0;
        for (double x : v) s += x;
        return s / v.length;
    }

    private static double stdDev(double[] v, double mean) {
        double s = 0;
        for (double x : v) s += (x - mean) * (x - mean);
        return Math.sqrt(s / v.length);
    }
}
