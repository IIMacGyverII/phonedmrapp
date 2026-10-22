/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.InputType;
import android.view.Gravity;
import android.widget.EditText;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.Logbook;
import com.macdmr.radio.ham.NetStore;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;

/** Net control: start a net, check stations in (typed or from those just heard), flag traffic / late / out, end with a report. */
public final class NetDialog {
    private NetDialog() { }

    public static void show(Context c, RadioService svc) {
        NetStore.Net n = svc.nets().running();
        if (n == null) startSheet(c, svc); else netSheet(c, svc, n);
    }

    private static void startSheet(Context c, RadioService svc) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Net control");
        body.addView(Neo.sheetHint(c, "Run a net: start it, check stations in as they call (or tap one the radio just heard), flag traffic, late and checked-out stations, and end it with a report you can share and add to the logbook."));
        final EditText name = field(c, body, "Net name", c.getSharedPreferences("nets", Context.MODE_PRIVATE).getString("last", "Weekly net"));
        ChannelStore.Channel ch = svc.current();
        body.addView(Neo.sheetHint(c, "On " + (ch == null ? "no channel" : ch.name + String.format(Locale.US, " (%.4f MHz)", ch.rxFreq / 1e6))));
        TextView start = Neo.button(c, "Start the net", "send", Neo.GREEN); body.addView(start, lp(d, 8));
        final AlertDialog[] self = new AlertDialog[1];
        start.setOnClickListener(v -> {
            String nm = name.getText().toString().trim(); if (nm.isEmpty()) nm = "Net";
            c.getSharedPreferences("nets", Context.MODE_PRIVATE).edit().putString("last", nm).apply();
            ChannelStore.Channel cur = svc.current();
            NetStore.Net net = svc.nets().start(nm, cur == null ? "" : cur.name, cur == null ? 0 : cur.rxFreq);
            svc.history("pkt", "📋 Net started: " + nm);
            if (self[0] != null) self[0].dismiss(); netSheet(c, svc, net);
        });
        List<NetStore.Net> past = svc.nets().past(20);
        if (!past.isEmpty()) body.addView(Neo.sheetSection(c, "Past nets"));
        SimpleDateFormat f = new SimpleDateFormat("MMM d, HH:mm", Locale.US);
        for (NetStore.Net p : past) {
            int count = svc.nets().checkIns(p.id).size();
            LinearLayout r = card(c, p.name + "  ·  " + count + " check-ins", f.format(new Date(p.start)) + "  ·  " + (p.end - p.start) / 60000 + " min  ·  " + p.channel + "  ·  tap for the report");
            r.setOnClickListener(v -> reportSheet(c, svc, p));
            r.setOnLongClickListener(v -> { new AlertDialog.Builder(c).setTitle("Delete " + p.name + "?").setPositiveButton("Delete", (dd, w) -> { svc.nets().deleteNet(p.id); if (self[0] != null) self[0].dismiss(); startSheet(c, svc); }).setNegativeButton("Cancel", null).show(); return true; });
            body.addView(r, lp(d, 6));
        }
        self[0] = Neo.showSheet(c, body);
    }

    private static void netSheet(Context c, RadioService svc, NetStore.Net n) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Net: " + n.name);
        final TextView clock = Neo.text(c, "", Neo.CYAN_LIGHT, 22, Neo.display(c)); clock.setGravity(Gravity.CENTER); body.addView(clock);
        body.addView(Neo.sheetHint(c, (n.channel.isEmpty() ? "" : n.channel + "  ·  ") + "Check-ins after 15 minutes are marked late. Tap a flag to change it; long-press a station to remove it."));
        LinearLayout addRow = new LinearLayout(c); addRow.setGravity(Gravity.CENTER_VERTICAL);
        final EditText call = new EditText(c); call.setHint("Callsign"); call.setSingleLine(true); call.setTextColor(Neo.TEXT); call.setHintTextColor(Neo.DIM); call.setTypeface(Neo.mono(c));
        call.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        TextView add = Neo.button(c, "Check in", "plus", Neo.GREEN);
        addRow.addView(call, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        addRow.addView(add, new LinearLayout.LayoutParams((int) (140 * d), LinearLayout.LayoutParams.WRAP_CONTENT));
        body.addView(addRow);
        body.addView(Neo.sheetSection(c, "Heard in the last 30 minutes"));
        HorizontalScrollView hs = new HorizontalScrollView(c); hs.setHorizontalScrollBarEnabled(false);
        final LinearLayout heard = new LinearLayout(c); hs.addView(heard); body.addView(hs);
        body.addView(Neo.sheetSection(c, "Check-ins"));
        final LinearLayout list = new LinearLayout(c); list.setOrientation(LinearLayout.VERTICAL); body.addView(list);
        LinearLayout r = new LinearLayout(c); r.setBaselineAligned(false);
        TextView report = Neo.button(c, "Report", "report", Neo.CYAN), end = Neo.button(c, "End the net", "stop", Neo.RED);
        for (TextView b : new TextView[] { report, end }) { LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); l.setMargins((int) (3 * d), (int) (10 * d), (int) (3 * d), 0); r.addView(b, l); }
        body.addView(r);

        final Runnable[] fill = new Runnable[1];
        fill[0] = () -> {
            List<NetStore.CheckIn> ins = svc.nets().checkIns(n.id);
            java.util.Set<String> in = new java.util.HashSet<>(); for (NetStore.CheckIn k : ins) in.add(k.call);
            list.removeAllViews();
            SimpleDateFormat t = new SimpleDateFormat("HH:mm", Locale.US);
            int i = 1;
            for (NetStore.CheckIn k : ins) {
                LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL);
                row.setBackground(k.traffic ? Neo.tint(c, Neo.AMBER, 12, 1) : Neo.rowCard(c)); row.setPadding((int) (10 * d), (int) (6 * d), (int) (6 * d), (int) (6 * d));
                LinearLayout col = new LinearLayout(c); col.setOrientation(LinearLayout.VERTICAL);
                col.addView(Neo.text(c, (i++) + ". " + k.call + (k.name == null || k.name.isEmpty() ? "" : "  " + k.name), k.out ? Neo.MUTED : Neo.TEXT, 16, Neo.ui(c)));
                col.addView(Neo.text(c, t.format(new Date(k.ts)), Neo.MUTED, 12, Neo.uiMedium(c)));
                row.addView(col, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
                row.addView(flag(c, "Traffic", k.traffic, Neo.AMBER, () -> { k.traffic = !k.traffic; svc.nets().save(k); fill[0].run(); }));
                row.addView(flag(c, "Late", k.late, Neo.VIOLET, () -> { k.late = !k.late; svc.nets().save(k); fill[0].run(); }));
                row.addView(flag(c, "Out", k.out, Neo.RED, () -> { k.out = !k.out; svc.nets().save(k); fill[0].run(); }));
                row.setOnLongClickListener(v -> { svc.nets().remove(k); fill[0].run(); return true; });
                list.addView(row, lp(d, 6));
            }
            if (ins.isEmpty()) list.addView(Neo.sheetHint(c, "No check-ins yet."));
            heard.removeAllViews();
            LinkedHashMap<String, String> recent = new LinkedHashMap<>();
            long since = System.currentTimeMillis() - 30 * 60_000L;
            for (Logbook.Entry e : svc.logbook().list(80, false)) if (e.ts >= since && !in.contains(e.call) && !recent.containsKey(e.call)) recent.put(e.call, e.name == null ? "" : e.name);
            if (recent.isEmpty()) heard.addView(Neo.sheetHint(c, "No stations heard recently (DMR callers with a RadioID callsign, APRS, Morse IDs)."));
            for (java.util.Map.Entry<String, String> e : recent.entrySet()) {
                TextView b = Neo.button(c, e.getKey(), "plus", Neo.CYAN); b.setTextSize(13);
                LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT); l.rightMargin = (int) (6 * d);
                b.setOnClickListener(v -> { svc.nets().checkIn(n, e.getKey(), e.getValue()); fill[0].run(); });
                heard.addView(b, l);
            }
        };
        fill[0].run();
        add.setOnClickListener(v -> {
            String cs = call.getText().toString().trim().toUpperCase(Locale.US);
            if (cs.isEmpty()) return;
            String nm = ""; for (Logbook.Entry e : svc.logbook().list(300, false)) if (e.call.equals(Logbook.baseCall(cs) == null ? cs : Logbook.baseCall(cs)) && e.name != null && !e.name.isEmpty()) { nm = e.name; break; }
            NetStore.CheckIn k = svc.nets().checkIn(n, cs, nm); call.setText(""); fill[0].run();
            if (nm.isEmpty()) svc.enrichCall(cs, i -> { if (k.name == null || k.name.isEmpty()) { k.name = i.name; svc.nets().save(k); new android.os.Handler(Looper.getMainLooper()).post(fill[0]); } });   // the name from HamDB
        });
        final Handler h = new Handler(Looper.getMainLooper());
        final Runnable tick = new Runnable() { @Override public void run() { long s = (System.currentTimeMillis() - n.start) / 1000; clock.setText(String.format(Locale.US, "Net running %d:%02d", s / 60, s % 60)); h.postDelayed(this, 1000); } };
        h.post(tick);
        final AlertDialog[] self = new AlertDialog[1];
        report.setOnClickListener(v -> reportSheet(c, svc, n));
        end.setOnClickListener(v -> new AlertDialog.Builder(c).setTitle("End " + n.name + "?").setPositiveButton("End", (dd, w) -> {
            svc.nets().end(n);
            svc.history("pkt", "📋 Net ended: " + n.name + " (" + svc.nets().checkIns(n.id).size() + " check-ins)");
            if (self[0] != null) self[0].dismiss(); reportSheet(c, svc, n);
        }).setNegativeButton("Cancel", null).show());
        self[0] = Neo.showSheet(c, body);
        self[0].setOnDismissListener(x -> h.removeCallbacks(tick));
    }

    private static void reportSheet(Context c, RadioService svc, NetStore.Net n) {
        float d = Theme.dp(c);
        List<NetStore.CheckIn> ins = svc.nets().checkIns(n.id);
        final String text = NetStore.report(n, ins, svc.packet() != null && svc.packet().callsignSet() ? svc.packet().callsign() : "");
        LinearLayout body = Neo.sheetBody(c, "Net report");
        TextView t = Neo.text(c, text, 0xFFCFE8D8, 13, Neo.mono(c)); t.setTextIsSelectable(true); t.setBackground(Neo.rowCard(c)); t.setPadding((int) (10 * d), (int) (8 * d), (int) (10 * d), (int) (8 * d));
        body.addView(t);
        LinearLayout r = new LinearLayout(c); r.setBaselineAligned(false);
        TextView share = Neo.button(c, "Share", "send", Neo.CYAN), log = Neo.button(c, "Add to logbook", "report", Neo.GREEN);
        for (TextView b : new TextView[] { share, log }) { LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); l.setMargins((int) (3 * d), (int) (10 * d), (int) (3 * d), 0); r.addView(b, l); }
        body.addView(r);
        share.setOnClickListener(v -> { try { c.startActivity(android.content.Intent.createChooser(new android.content.Intent(android.content.Intent.ACTION_SEND).setType("text/plain").putExtra(android.content.Intent.EXTRA_SUBJECT, n.name).putExtra(android.content.Intent.EXTRA_TEXT, text), "Share the net report")); } catch (Throwable ignored) { } });
        log.setOnClickListener(v -> {
            int k = 0;
            for (NetStore.CheckIn ci : ins) {
                Logbook.Entry e = new Logbook.Entry(); e.ts = ci.ts; e.call = ci.call; e.name = ci.name; e.freqHz = n.freqHz; e.mode = "FM"; e.qso = true; e.notes = "Net: " + n.name + (ci.traffic ? ", traffic" : ""); e.source = "net check-in";
                svc.logbook().save(e); k++;
            }
            Toast.makeText(c, k + " check-ins added to the logbook", Toast.LENGTH_LONG).show();
        });
        Neo.showSheet(c, body);
    }

    private static TextView flag(Context c, String label, boolean on, int accent, Runnable toggle) {
        TextView t = Neo.chip(c, label, on ? accent : 0xFF55687A);
        LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT); l.leftMargin = Theme.dp(c, 4); t.setLayoutParams(l);
        t.setPadding(Theme.dp(c, 8), Theme.dp(c, 8), Theme.dp(c, 8), Theme.dp(c, 8));
        t.setClickable(true); t.setOnClickListener(v -> toggle.run());
        return t;
    }
    private static LinearLayout card(Context c, String title, String sub) {
        float d = Theme.dp(c);
        LinearLayout v = new LinearLayout(c); v.setOrientation(LinearLayout.VERTICAL); v.setBackground(Neo.rowCard(c)); v.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
        v.addView(Neo.text(c, title, Neo.TEXT, 15.5f, Neo.ui(c))); v.addView(Neo.text(c, sub, Neo.MUTED, 12.5f, Neo.uiMedium(c)));
        v.setClickable(true); return v;
    }
    private static LinearLayout.LayoutParams lp(float d, int top) { LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); l.topMargin = (int) (top * d); return l; }
    private static EditText field(Context c, LinearLayout target, String label, String value) {
        float d = Theme.dp(c);
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (4 * d));
        r.addView(Neo.label(c, label, 0xFF9AA4AE, 12, false));
        EditText e = new EditText(c); e.setText(value); e.setSingleLine(true); e.setTextColor(Neo.TEXT); e.setBackground(null); e.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_WORDS);
        r.addView(e); target.addView(r, lp(d, 6)); return e;
    }
}
