/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.coverage;

import android.os.Environment;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

/**
 * Writes the measurements to {@code Download/DMR/Coverage/<time>/}: {@code coverage_rx.csv},
 * {@code coverage_tx.csv} (every reading, for a spreadsheet or GIS) and {@code coverage.kml} (Google Earth:
 * one folder per repeater with coloured squares for what you heard and green/red points for your key-ups).
 */
public final class CoverageExport {
    private CoverageExport() { }

    public static File root() { return new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "DMR/Coverage"); }

    /** Returns the folder written. */
    public static File export(CoverageStore st) throws Exception {
        File dir = new File(root(), new SimpleDateFormat("yyyy-MM-dd_HHmmss", Locale.US).format(new Date()));
        if (!dir.mkdirs() && !dir.isDirectory()) throw new Exception("cannot create " + dir);
        SimpleDateFormat iso = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US); iso.setTimeZone(TimeZone.getTimeZone("UTC"));
        List<CoverageStore.Repeater> reps = st.repeaters();
        Map<String, String> names = new HashMap<>(); for (CoverageStore.Repeater r : reps) names.put(r.key, r.name);

        try (Writer w = writer(new File(dir, "coverage_rx.csv"))) {
            w.write("time_utc,repeater,repeater_key,lat,lon,accuracy_m,dbm,s_units\n");
            for (CoverageStore.Rx r : st.rx(null))
                w.write(iso.format(new Date(r.ts)) + "," + csv(names.get(r.key)) + "," + csv(r.key) + "," + fmt(r.lat) + "," + fmt(r.lon) + "," + Math.round(r.acc) + "," + r.dbm + "," + CoverageMath.sUnits(r.dbm) + "\n");
        }
        try (Writer w = writer(new File(dir, "coverage_tx.csv"))) {
            w.write("time_utc,repeater,repeater_key,lat,lon,accuracy_m,power,tx_ms,result,reply_dbm,floor_dbm\n");
            for (CoverageStore.Tx t : st.tx(null))
                w.write(iso.format(new Date(t.ts)) + "," + csv(names.get(t.key)) + "," + csv(t.key) + "," + fmt(t.lat) + "," + fmt(t.lon) + "," + Math.round(t.acc) + ","
                        + (t.power == 1 ? "high" : "low") + "," + t.txMs + "," + (t.result == CoverageMath.KEYED ? "keyed" : t.result == CoverageMath.NO_REPLY ? "no_reply" : "unknown") + ","
                        + (t.replyDbm == -999 ? "" : String.valueOf(t.replyDbm)) + "," + (t.floorDbm == -999 ? "" : String.valueOf(t.floorDbm)) + "\n");
        }
        try (Writer w = writer(new File(dir, "coverage.kml"))) {
            w.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\"><Document><name>Radio coverage</name>\n");
            w.write("<Style id=\"keyed\"><IconStyle><color>ff7aea2b</color><scale>0.7</scale></IconStyle></Style>\n");
            w.write("<Style id=\"noreply\"><IconStyle><color>ff6854ff</color><scale>0.7</scale></IconStyle></Style>\n");
            for (CoverageStore.Repeater r : reps) {
                w.write("<Folder><name>" + xml(r.name) + String.format(Locale.US, " %.4f MHz", r.rxHz / 1e6) + "</name>\n");
                w.write("<Placemark><name>" + xml(r.name) + "</name><Point><coordinates>" + fmt(r.lon) + "," + fmt(r.lat) + "</coordinates></Point></Placemark>\n");
                w.write("<Folder><name>Heard (repeater to phone)</name>\n");
                for (CoverageStore.Cell c : st.rxCells(r.key)) {
                    int col = CoverageMath.signalColor(c.value);
                    String abgr = String.format("99%02x%02x%02x", col & 0xFF, (col >> 8) & 0xFF, (col >> 16) & 0xFF);
                    w.write("<Placemark><name>" + c.value + " dBm (" + CoverageMath.sUnits(c.value) + "), " + c.count + " readings</name><Style><LineStyle><width>0</width></LineStyle><PolyStyle><color>" + abgr
                            + "</color></PolyStyle></Style><Polygon><outerBoundaryIs><LinearRing><coordinates>"
                            + fmt(c.w) + "," + fmt(c.s) + " " + fmt(c.e) + "," + fmt(c.s) + " " + fmt(c.e) + "," + fmt(c.n) + " " + fmt(c.w) + "," + fmt(c.n) + " " + fmt(c.w) + "," + fmt(c.s)
                            + "</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>\n");
                }
                w.write("</Folder><Folder><name>Key-ups (phone to repeater)</name>\n");
                for (CoverageStore.Tx t : st.tx(r.key)) {
                    if (t.result == CoverageMath.UNKNOWN) continue;
                    boolean ok = t.result == CoverageMath.KEYED;
                    w.write("<Placemark><name>" + (ok ? "Keyed" : "No reply") + "</name><description>" + iso.format(new Date(t.ts)) + (t.power == 1 ? ", high power" : ", low power")
                            + "</description><styleUrl>#" + (ok ? "keyed" : "noreply") + "</styleUrl><Point><coordinates>" + fmt(t.lon) + "," + fmt(t.lat) + "</coordinates></Point></Placemark>\n");
                }
                w.write("</Folder></Folder>\n");
            }
            w.write("</Document></kml>\n");
        }
        return dir;
    }

    private static Writer writer(File f) throws Exception { return new OutputStreamWriter(new FileOutputStream(f), StandardCharsets.UTF_8); }
    private static String fmt(double v) { return String.format(Locale.US, "%.6f", v); }
    private static String csv(String s) { if (s == null) return ""; return s.contains(",") || s.contains("\"") ? "\"" + s.replace("\"", "\"\"") + "\"" : s; }
    private static String xml(String s) { return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"); }
}
