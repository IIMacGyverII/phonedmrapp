package com.macdmr.radio.coverage;

import android.content.Context;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Runs a terrain prediction for one repeater and turns it into map squares for both layers, calibrated with
 * whatever was measured for that repeater. Results are cached per repeater, antenna height, range and amount of
 * data, so switching layers is instant.
 */
public final class Prediction {
    public static final class Result {
        public List<CoverageStore.Cell> rx = new ArrayList<>(), tx = new ArrayList<>();
        public double rxOffset, txLimit; public int rxN, txN, txKeyed; public boolean txFromRx;
        public String summary(boolean rxLayer) {
            if (rxLayer) return rxN == 0 ? "Uncalibrated: assumes a 50 W repeater; Heard readings will correct it"
                    : String.format(Locale.US, "Calibrated with %d measured squares (%+.0f dB)", rxN, rxOffset);
            if (txFromRx) return String.format(Locale.US, "Estimated from %d Heard squares (%+.0f dB); your key-ups will refine it", rxN, rxOffset);
            return txN == 0 ? "Uncalibrated: assumes a 4 W handheld; your key-ups will correct it"
                    : String.format(Locale.US, "Calibrated with %d key-ups (%d keyed): reach limit %.0f dB", txN, txKeyed, txLimit);
        }
    }

    public interface Progress { boolean update(String text); }   // false = cancel

    private static String cacheKey; private static Result cached;

    /** Null when cancelled. Throws with a readable message when terrain cannot be loaded. */
    public static synchronized Result run(Context c, CoverageStore st, String key, double lat, double lon, double hz, double antennaAgl, double radiusM, Progress pr) throws Exception {
        List<CoverageStore.Cell> measured = st.rxCells(key);
        List<CoverageStore.Tx> attempts = st.tx(key);
        String ck = key + "|" + antennaAgl + "|" + radiusM + "|" + measured.size() + "|" + attempts.size();
        if (ck.equals(cacheKey) && cached != null) return cached;

        Predictor.Params p = new Predictor.Params(); p.lat = lat; p.lon = lon; p.hz = hz; p.antennaAgl = antennaAgl; p.radiusM = radiusM;
        p.cellM = radiusM > 40_000 ? 400 : 300;
        double dLat = (radiusM + 2000) / 111_320.0, dLon = (radiusM + 2000) / (111_320.0 * Math.cos(Math.toRadians(lat)));
        Terrain t = new Terrain(c);
        final boolean[] cancel = { false };
        String err = t.load(lat - dLat, lon - dLon, lat + dLat, lon + dLon, (done, total) -> { if (pr != null && !pr.update("Loading terrain " + done + "/" + total)) cancel[0] = true; });
        if (cancel[0]) return null;
        if (err != null) throw new Exception(err);

        Result r = new Result();
        List<double[]> m = new ArrayList<>();
        for (CoverageStore.Cell cell : measured) m.add(new double[] { (cell.s + cell.n) / 2, (cell.w + cell.e) / 2, cell.value });
        r.rxN = m.size(); r.rxOffset = Predictor.calibrateRx(t, p, m);
        List<double[]> a = new ArrayList<>();
        for (CoverageStore.Tx x : attempts) if (x.result != CoverageMath.UNKNOWN) { a.add(new double[] { x.lat, x.lon, x.result == CoverageMath.KEYED ? 1 : 0 }); r.txN++; if (x.result == CoverageMath.KEYED) r.txKeyed++; }
        // no-reply attempts only count once the repeater has answered somewhere (it may have no tail at all)
        if (r.txKeyed == 0) { a.clear(); r.txN = 0; }
        r.txLimit = Predictor.calibrateTx(t, p, a);
        if (r.txN == 0 && r.rxN > 0) { r.txLimit += r.rxOffset; r.txFromRx = true; }   // same path both ways: what the Heard readings say about extra loss applies to your signal too

        List<Predictor.Square> g = Predictor.grid(t, p, (done, total) -> pr == null || pr.update("Predicting " + (100 * done / Math.max(1, total)) + "%"));
        if (g == null) return null;
        for (Predictor.Square s : g) {
            int dbm = (int) Math.round(Predictor.DOWNLINK_BUDGET - s.loss + r.rxOffset);
            if (dbm >= CoverageMath.SCALE_LOW) { CoverageStore.Cell cell = cell(s); cell.value = dbm; r.rx.add(cell); }
            double margin = r.txLimit - s.loss;
            if (margin >= 0) { CoverageStore.Cell cell = cell(s); cell.value = (int) Math.round(margin); cell.keyed = 1; r.tx.add(cell); }
        }
        cacheKey = ck; cached = r;
        return r;
    }

    private static CoverageStore.Cell cell(Predictor.Square s) {
        CoverageStore.Cell c = new CoverageStore.Cell(); c.s = s.s; c.w = s.w; c.n = s.n; c.e = s.e; c.predicted = true; return c;
    }
}
