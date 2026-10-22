/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
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
        public double antennaUsed, radiusUsedM, erpWatts; public boolean antennaFitted, erpKnown;
        public String summary(boolean rxLayer) {
            String ant = antennaFitted ? String.format(Locale.US, ", antenna %.0f m (fitted)", antennaUsed) : "";
            if (rxLayer) return rxN == 0 ? (erpKnown ? String.format(Locale.US, "Uncalibrated: %.0f W, antenna %.0f m; Heard readings will refine it", erpWatts, antennaUsed)
                    : "Uncalibrated: assumes a 50 W repeater; Heard readings will correct it")
                    : String.format(Locale.US, "Calibrated with %d measured squares (%+.0f dB%s)", rxN, rxOffset, ant);
            if (txFromRx) return String.format(Locale.US, "Estimated from %d Heard squares (%+.0f dB); your key-ups will refine it", rxN, rxOffset);
            return txN == 0 ? "Uncalibrated: assumes a 4 W handheld; your key-ups will correct it"
                    : String.format(Locale.US, "Calibrated with %d key-ups (%d keyed): reach limit %.0f dB", txN, txKeyed, txLimit);
        }
    }

    public interface Progress { boolean update(String text); }   // false = cancel

    private static String cacheKey; private static Result cached;

    /** Null when cancelled. Throws with a readable message when terrain cannot be loaded. */
    /** Furthest the prediction reaches out to cover measurements or your position (m). */
    public static final double MAX_RADIUS_M = 80_000;

    /**
     * {@code antennaAgl <= 0}: fit it from the Heard measurements when they cover a range of distances, else 30 m.
     * The prediction covers at least {@code radiusM}, and always reaches your position ({@code meLat/meLon}, NaN
     * when unknown) and every measurement, up to {@link #MAX_RADIUS_M}.
     */
    public static synchronized Result run(Context c, CoverageStore st, String key, double lat, double lon, double hz, double antennaAgl, double erpWatts, double radiusM,
                                          double meLat, double meLon, Progress pr) throws Exception {
        List<CoverageStore.Cell> measured = st.rxCells(key);
        List<CoverageStore.Tx> attempts = st.tx(key);
        if (radiusM <= 0) {                                       // Auto: as far as this transmitter can reach over flat ground
            Predictor.Params q = new Predictor.Params(); q.hz = hz; q.antennaAgl = antennaAgl > 0 ? antennaAgl : 30;
            if (erpWatts > 0) q.budget = Predictor.downlinkBudget(erpWatts);
            radiusM = Math.max(8000, Predictor.reachM(q, CoverageMath.SCALE_LOW, MAX_RADIUS_M));
        }
        double r = radiusM, nearMin = Double.MAX_VALUE, farMax = 0;
        for (CoverageStore.Cell cell : measured) { double d = Predictor.metres(lat, lon, (cell.s + cell.n) / 2, (cell.w + cell.e) / 2); r = Math.max(r, d * 1.15 + 2000); nearMin = Math.min(nearMin, d); farMax = Math.max(farMax, d); }
        for (CoverageStore.Tx x : attempts) r = Math.max(r, Predictor.metres(lat, lon, x.lat, x.lon) * 1.15 + 2000);
        if (!Double.isNaN(meLat)) r = Math.max(r, Predictor.metres(lat, lon, meLat, meLon) * 1.15 + 2000);
        r = Math.min(r, Math.max(radiusM, MAX_RADIUS_M));
        String ck = key + "|" + antennaAgl + "|" + erpWatts + "|" + Math.round(r / 1000) + "|" + measured.size() + "|" + attempts.size();
        if (ck.equals(cacheKey) && cached != null) return cached;

        Predictor.Params p = new Predictor.Params(); p.lat = lat; p.lon = lon; p.hz = hz; p.antennaAgl = antennaAgl > 0 ? antennaAgl : 30; p.radiusM = r;
        p.cellM = r <= 35_000 ? 300 : r <= 60_000 ? 450 : 600;
        p.sampleM = Math.max(Predictor.SAMPLE_M, p.cellM / 3);
        if (erpWatts > 0) p.budget = Predictor.downlinkBudget(erpWatts);
        radiusM = r;
        double dLat = (radiusM + 2000) / 111_320.0, dLon = (radiusM + 2000) / (111_320.0 * Math.cos(Math.toRadians(lat)));
        Terrain t = new Terrain(c);
        final boolean[] cancel = { false };
        String err = t.load(lat - dLat, lon - dLon, lat + dLat, lon + dLon, (done, total) -> { if (pr != null && !pr.update("Loading terrain " + done + "/" + total)) cancel[0] = true; });
        if (cancel[0]) return null;
        if (err != null) throw new Exception(err);

        Result res = new Result();
        List<double[]> m = new ArrayList<>();
        for (CoverageStore.Cell cell : measured) m.add(new double[] { (cell.s + cell.n) / 2, (cell.w + cell.e) / 2, cell.value });
        res.rxN = m.size();
        // the antenna height: measured at a spread of distances, the data can tell it (it shapes the coverage); otherwise the default or your choice
        if (antennaAgl <= 0 && m.size() >= 3 && farMax - nearMin >= 3000) {
            if (pr != null && !pr.update("Fitting the antenna height to " + m.size() + " measured squares")) return null;
            double[] fit = Predictor.fitAntenna(t, p, m.size() > 300 ? m.subList(0, 300) : m);
            p.antennaAgl = fit[0]; res.antennaFitted = true;
        }
        res.antennaUsed = p.antennaAgl; res.radiusUsedM = p.radiusM; res.erpKnown = erpWatts > 0; res.erpWatts = erpWatts > 0 ? erpWatts : 50;
        res.rxOffset = Predictor.calibrateRx(t, p, m);
        List<double[]> a = new ArrayList<>();
        for (CoverageStore.Tx x : attempts) if (x.result != CoverageMath.UNKNOWN) { a.add(new double[] { x.lat, x.lon, x.result == CoverageMath.KEYED ? 1 : 0 }); res.txN++; if (x.result == CoverageMath.KEYED) res.txKeyed++; }
        // no-reply attempts only count once the repeater has answered somewhere (it may have no tail at all)
        if (res.txKeyed == 0) { a.clear(); res.txN = 0; }
        res.txLimit = Predictor.calibrateTx(t, p, a);
        if (res.txN == 0 && res.rxN > 0) { res.txLimit += res.rxOffset; res.txFromRx = true; }   // same path both ways: what the Heard readings say about extra loss applies to your signal too

        List<Predictor.Square> g = Predictor.grid(t, p, (done, total) -> pr == null || pr.update("Predicting " + (100 * done / Math.max(1, total)) + "%"));
        if (g == null) return null;
        for (Predictor.Square s : g) {
            int dbm = (int) Math.round(p.budget - s.loss + res.rxOffset);
            if (dbm >= CoverageMath.SCALE_LOW) { CoverageStore.Cell cell = cell(s); cell.value = dbm; res.rx.add(cell); }
            double margin = res.txLimit - s.loss;
            if (margin >= 0) { CoverageStore.Cell cell = cell(s); cell.value = (int) Math.round(margin); cell.keyed = 1; res.tx.add(cell); }
        }
        cacheKey = ck; cached = res;
        return res;
    }

    private static CoverageStore.Cell cell(Predictor.Square s) {
        CoverageStore.Cell c = new CoverageStore.Cell(); c.s = s.s; c.w = s.w; c.n = s.n; c.e = s.e; c.predicted = true; return c;
    }
}
