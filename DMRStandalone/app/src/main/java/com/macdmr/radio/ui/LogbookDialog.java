package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.text.InputType;
import android.view.Gravity;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.Logbook;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** The logbook: contacts and stations heard, newest first; add or edit a contact; export ADIF. */
public final class LogbookDialog {
    private LogbookDialog() { }
    private static final String[] MODES = { "FM", "DMR", "PKT", "CW" };

    public static void show(Context c, RadioService svc) { show(c, svc, false); }

    private static void show(Context c, RadioService svc, boolean qsoOnly) {
        float d = Theme.dp(c);
        Logbook lb = svc.logbook();
        LinearLayout body = Neo.sheetBody(c, "Logbook");
        android.location.Location me = svc.lastKnownLocation();
        java.util.Set<String> grids = lb.gridsWorked();
        body.addView(Neo.label(c, (me != null ? "You are in " + com.macdmr.radio.ham.Maidenhead.grid(me.getLatitude(), me.getLongitude(), 6) + "  \u00B7  " : "") + grids.size() + (grids.size() == 1 ? " grid square" : " grid squares") + " worked", Theme.CYAN, 14, true));
        body.addView(Neo.sheetHint(c, lb.count(true) + " contacts, " + (lb.count(false) - lb.count(true)) + " stations heard. Heard stations are logged by themselves (DMR callers with a RadioID callsign, APRS stations, Morse IDs); tap one to fill in the reports and mark it a contact. Export ADIF for your logging program or QSL service."));
        final AlertDialog[] self = new AlertDialog[1];
        LinearLayout r1 = new LinearLayout(c); r1.setBaselineAligned(false);
        TextView add = Neo.button(c, "Add contact", "plus", Neo.GREEN), exp = Neo.button(c, "Export ADIF", "backup", Neo.CYAN);
        for (TextView b : new TextView[] { add, exp }) { b.setTextSize(14); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (4 * d), (int) (3 * d), 0); r1.addView(b, lp); }
        body.addView(r1);
        LinearLayout r2 = new LinearLayout(c); r2.setBaselineAligned(false);
        TextView filter = Neo.button(c, qsoOnly ? "Showing: contacts" : "Showing: all", "search", Neo.CYAN), auto = Neo.button(c, svc.logHeard() ? "Log heard: on" : "Log heard: off", "signal", Neo.VIOLET),
                online = Neo.button(c, svc.lookupOnline() ? "Look up: on" : "Look up: off", "globe", Neo.VIOLET);
        online.setOnClickListener(v -> { svc.setLookupOnline(!svc.lookupOnline()); online.setText(svc.lookupOnline() ? "Look up: on" : "Look up: off"); });
        for (TextView b : new TextView[] { filter, auto, online }) { b.setTextSize(14); Neo.fit(b); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (6 * d), (int) (3 * d), (int) (6 * d)); r2.addView(b, lp); }
        body.addView(r2);

        List<Logbook.Entry> list = lb.list(300, qsoOnly);
        if (list.isEmpty()) body.addView(Neo.sheetHint(c, qsoOnly ? "No contacts logged yet." : "Nothing logged yet."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
        for (Logbook.Entry e : list) {
            LinearLayout row = new LinearLayout(c); row.setOrientation(LinearLayout.VERTICAL);
            row.setBackground(e.qso ? Neo.tint(c, Neo.GREEN, 12, 1) : Neo.rowCard(c)); row.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
            LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
            top.addView(Neo.text(c, e.call + (e.name == null || e.name.isEmpty() ? "" : "  " + e.name), e.qso ? Neo.GREEN_LIGHT : Neo.TEXT, 16, Neo.ui(c)), new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
            top.addView(Neo.chip(c, e.qso ? "QSO" : "heard", e.qso ? Neo.GREEN : 0xFF9FB4C8));
            row.addView(top);
            String rst = (e.rstSent == null || e.rstSent.isEmpty() ? "" : "  ·  sent " + e.rstSent) + (e.rstRcvd == null || e.rstRcvd.isEmpty() ? "" : " rcvd " + e.rstRcvd);
            row.addView(Neo.label(c, f.format(new Date(e.ts)) + "  ·  " + (e.freqHz > 0 ? String.format(Locale.US, "%.4f", e.freqHz / 1e6) + " MHz  ·  " : "") + e.mode + rst + (e.source == null || e.source.isEmpty() ? "" : "  ·  " + e.source), 0xFFBFC8D0, 12, false));
            String where = (e.qth == null || e.qth.isEmpty() ? "" : e.qth) + (e.grid == null || e.grid.isEmpty() ? "" : ((e.qth == null || e.qth.isEmpty()) ? "" : "  \u00B7  ") + e.grid);
            double[] at = e.grid == null ? null : com.macdmr.radio.ham.Maidenhead.centre(e.grid);
            if (at != null && me != null) { double km = com.macdmr.radio.ham.Maidenhead.km(me.getLatitude(), me.getLongitude(), at[0], at[1]); where += String.format(Locale.US, "  \u00B7  %.0f mi %s", km / 1.609344, com.macdmr.radio.ham.Maidenhead.compass(com.macdmr.radio.ham.Maidenhead.bearing(me.getLatitude(), me.getLongitude(), at[0], at[1]))); }
            if (!where.isEmpty()) row.addView(Neo.label(c, where, 0xFF9FB4C8, 12, false));
            if (e.notes != null && !e.notes.isEmpty()) row.addView(Neo.label(c, e.notes, 0xFF8A98A6, 12, false));
            row.setClickable(true);
            row.setOnClickListener(v -> edit(c, svc, e, () -> { if (self[0] != null) self[0].dismiss(); show(c, svc, qsoOnly); }));
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d);
            body.addView(row, lp);
        }
        add.setOnClickListener(v -> {
            Logbook.Entry e = new Logbook.Entry(); e.ts = System.currentTimeMillis(); e.qso = true;
            ChannelStore.Channel ch = svc.current(); if (ch != null) { e.freqHz = ch.rxFreq; e.mode = ch.isDigital() ? "DMR" : "FM"; }
            e.rstSent = e.rstRcvd = "59";
            edit(c, svc, e, () -> { if (self[0] != null) self[0].dismiss(); show(c, svc, qsoOnly); });
        });
        exp.setOnClickListener(v -> export(c, lb));
        filter.setOnClickListener(v -> { if (self[0] != null) self[0].dismiss(); show(c, svc, !qsoOnly); });
        auto.setOnClickListener(v -> { svc.setLogHeard(!svc.logHeard()); auto.setText(svc.logHeard() ? "Log heard: on" : "Log heard: off"); });
        self[0] = Neo.showSheet(c, body);
    }

    private static void edit(Context c, RadioService svc, Logbook.Entry e, Runnable after) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, e.id > 0 ? "Logbook entry" : "New contact");
        body.addView(Neo.sheetHint(c, new SimpleDateFormat("EEE MMM d yyyy, HH:mm", Locale.US).format(new Date(e.ts)) + (e.source == null || e.source.isEmpty() ? "" : "  ·  " + e.source)));
        final EditText call = field(c, body, "Callsign", e.call, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText freq = field(c, body, "Frequency (MHz)", e.freqHz > 0 ? String.format(Locale.US, "%.4f", e.freqHz / 1e6) : "", InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        final int[] mode = { 0 }; for (int i = 0; i < MODES.length; i++) if (MODES[i].equals(e.mode)) mode[0] = i;
        final TextView modeB = Neo.button(c, "Mode: " + MODES[mode[0]], "radio", Neo.CYAN); body.addView(modeB);
        modeB.setOnClickListener(v -> { mode[0] = (mode[0] + 1) % MODES.length; modeB.setText("Mode: " + MODES[mode[0]]); });
        final EditText sent = field(c, body, "Report sent (e.g. 59)", e.rstSent, InputType.TYPE_CLASS_TEXT);
        final EditText rcvd = field(c, body, "Report received", e.rstRcvd, InputType.TYPE_CLASS_TEXT);
        final EditText name = field(c, body, "Name", e.name, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_WORDS);
        final EditText qth = field(c, body, "Location", e.qth, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_WORDS);
        final EditText grid = field(c, body, "Grid square", e.grid, InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        final TextView look = Neo.button(c, "Look up the callsign", "globe", Neo.VIOLET); body.addView(look, lp(d, 6));
        look.setOnClickListener(v -> {
            final String cs = call.getText().toString().trim();
            if (com.macdmr.radio.ham.Logbook.baseCall(cs) == null) { Toast.makeText(c, "Enter a callsign first", Toast.LENGTH_SHORT).show(); return; }
            look.setText("Looking up\u2026");
            new Thread(() -> {
                com.macdmr.radio.ham.CallLookup.Info i = svc.callLookup().lookup(cs);
                new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> {
                    look.setText("Look up the callsign");
                    if (i == null || !i.found) { Toast.makeText(c, "Not found (HamDB lists US, Canadian and some other licences)", Toast.LENGTH_LONG).show(); return; }
                    if (name.getText().length() == 0) name.setText(i.name);
                    qth.setText(i.place()); grid.setText(i.grid);
                    Toast.makeText(c, i.name + (i.licClass.isEmpty() ? "" : ", class " + i.licClass), Toast.LENGTH_SHORT).show();
                });
            }, "lookup").start();
        });
        final EditText notes = field(c, body, "Notes", e.notes, InputType.TYPE_CLASS_TEXT);
        final boolean[] qso = { e.qso };
        final TextView qb = Neo.button(c, qso[0] ? "This was a contact (QSO)" : "Only heard (not a contact)", "check", Neo.GREEN); body.addView(qb, lp(d, 8));
        qb.setOnClickListener(v -> { qso[0] = !qso[0]; qb.setText(qso[0] ? "This was a contact (QSO)" : "Only heard (not a contact)"); });
        LinearLayout r = new LinearLayout(c); r.setBaselineAligned(false);
        TextView save = Neo.button(c, "Save", null, Neo.GREEN), del = Neo.button(c, "Delete", null, Neo.RED);
        for (TextView b : new TextView[] { save, del }) { LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); l.setMargins((int) (3 * d), (int) (10 * d), (int) (3 * d), 0); r.addView(b, l); }
        body.addView(r);
        final AlertDialog[] self = new AlertDialog[1];
        save.setOnClickListener(v -> {
            String cs = call.getText().toString().trim().toUpperCase(Locale.US);
            if (cs.isEmpty()) { Toast.makeText(c, "Enter the callsign", Toast.LENGTH_SHORT).show(); return; }
            e.call = cs; e.mode = MODES[mode[0]]; e.rstSent = sent.getText().toString().trim(); e.rstRcvd = rcvd.getText().toString().trim();
            e.name = name.getText().toString().trim(); e.notes = notes.getText().toString().trim(); e.qso = qso[0];
            e.qth = qth.getText().toString().trim(); e.grid = grid.getText().toString().trim();
            try { String fs = freq.getText().toString().trim(); e.freqHz = fs.isEmpty() ? 0 : Math.round(Double.parseDouble(fs) * 1e6); } catch (NumberFormatException x) { Toast.makeText(c, "Frequency in MHz, e.g. 146.520", Toast.LENGTH_SHORT).show(); return; }
            svc.logbook().save(e);
            if (self[0] != null) self[0].dismiss(); after.run();
        });
        del.setOnClickListener(v -> { if (e.id > 0) svc.logbook().delete(e.id); if (self[0] != null) self[0].dismiss(); after.run(); });
        self[0] = Neo.showSheet(c, body);
    }

    private static void export(Context c, Logbook lb) {
        try {
            String adif = Logbook.adif(lb.list(100000, false), com.macdmr.radio.BuildConfig.VERSION_NAME);
            java.io.File dir = new java.io.File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/Logbook"); dir.mkdirs();
            java.io.File out = new java.io.File(dir, "logbook_" + new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date()) + ".adi");
            try (java.io.Writer w = new java.io.OutputStreamWriter(new java.io.FileOutputStream(out), java.nio.charset.StandardCharsets.UTF_8)) { w.write(adif); }
            Toast.makeText(c, "Saved Download/DMR/Logbook/" + out.getName(), Toast.LENGTH_LONG).show();
            c.startActivity(android.content.Intent.createChooser(new android.content.Intent(android.content.Intent.ACTION_SEND).setType("text/plain").putExtra(android.content.Intent.EXTRA_SUBJECT, out.getName()).putExtra(android.content.Intent.EXTRA_TEXT, adif), "Share the logbook"));
        } catch (Throwable t) { Toast.makeText(c, "Export failed: " + t.getMessage(), Toast.LENGTH_LONG).show(); }
    }

    private static LinearLayout.LayoutParams lp(float d, int top) { LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); l.topMargin = (int) (top * d); return l; }

    private static EditText field(Context c, LinearLayout target, String label, String value, int type) {
        float d = Theme.dp(c);
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (4 * d));
        r.addView(Neo.label(c, label, 0xFF9AA4AE, 12, false));
        EditText e = new EditText(c); e.setText(value == null ? "" : value); e.setInputType(type); e.setTextSize(16); e.setTextColor(Neo.TEXT); e.setSingleLine(true); e.setBackground(null); e.setPadding(0, (int) (2 * d), 0, (int) (2 * d));
        r.addView(e);
        target.addView(r, lp(d, 6));
        return e;
    }
}
