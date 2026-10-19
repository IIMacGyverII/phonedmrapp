package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.RadioService;
import com.macdmr.radio.repeaters.GeoUtil;
import com.macdmr.radio.repeaters.RepeaterModels.Repeater;
import com.macdmr.radio.repeaters.RepeaterModels.Talkgroup;
import com.macdmr.radio.repeaters.RepeaterPlanner.Plan;
import com.macdmr.radio.repeaters.RepeaterService;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/** Nearby repeaters: find DMR (BrandMeister, RadioID) and FM (hearham) repeaters around the phone and program them in a tap. */
public final class RepeatersDialog {
    private static final int[] RADII = { 15, 30, 60, 120 };   // miles
    private static final double KM_PER_MI = 1.609344;
    private final Context c; private final RadioService svc; private final RepeaterService rs; private final float d;
    /** Filters: mode 0 all / 1 FM / 2 DMR, band 0 all / 1 VHF / 2 UHF (remembered). */
    private int modeFilter, bandFilter; private double lastLat, lastLon;
    private final List<TextView> modeChips = new ArrayList<>(), bandChips = new ArrayList<>();
    private int radiusMi = 30; private AlertDialog dlg, sub; private LinearLayout list; private TextView status; private final List<TextView> chips = new ArrayList<>();
    private List<Repeater> current = new ArrayList<>();

    public static void show(Context c, RadioService svc) { new RepeatersDialog(c, svc).open(false); }
    /** One repeater's details sheet (from the map). */
    public static void showDetails(Context c, RadioService svc, Repeater r, double lat, double lon) { new RepeatersDialog(c, svc).details(r, lat, lon); }
    private RepeatersDialog(Context c, RadioService svc) { this.c = c; this.svc = svc; rs = new RepeaterService(c, svc.store()); d = Theme.dp(c); radiusMi = c.getSharedPreferences("repeaters", Context.MODE_PRIVATE).getInt("radiusMi", 30); }

    private void open(boolean force) {
        LinearLayout body = page("📡  Nearby repeaters");
        body.addView(hint("DMR repeaters from BrandMeister and RadioID, FM repeaters from hearham, sorted by distance from the phone; the rows below the distances filter by mode and band. Tap one to see its details and add it to your channels; installs can be undone."));
        LinearLayout row = row();
        for (int mi : RADII) { final int k = mi; chips.add(pill(row, mi + " mi", radiusMi == mi, x -> { radiusMi = k; c.getSharedPreferences("repeaters", Context.MODE_PRIVATE).edit().putInt("radiusMi", k).apply(); for (int i = 0; i < chips.size(); i++) style(chips.get(i), RADII[i] == k); load(false); })); }
        TextView refresh = pill(row, "↻", false, x -> load(true)); refresh.setTextSize(16);
        body.addView(row);
        final android.content.SharedPreferences fp = c.getSharedPreferences("repeaters", Context.MODE_PRIVATE);
        modeFilter = fp.getInt("modeFilter", 0); bandFilter = fp.getInt("bandFilter", 0);
        LinearLayout modeRow = row(); String[] modes = { "All", "FM", "DMR" };
        for (int i = 0; i < 3; i++) { final int k = i; modeChips.add(pill(modeRow, modes[i], modeFilter == i, x -> { modeFilter = k; fp.edit().putInt("modeFilter", k).apply(); for (int j = 0; j < modeChips.size(); j++) style(modeChips.get(j), j == k); render(lastLat, lastLon); })); }
        body.addView(modeRow);
        LinearLayout bandRow = row(); String[] bands = { "All", "VHF", "UHF" };
        for (int i = 0; i < 3; i++) { final int k = i; bandChips.add(pill(bandRow, bands[i], bandFilter == i, x -> { bandFilter = k; fp.edit().putInt("bandFilter", k).apply(); for (int j = 0; j < bandChips.size(); j++) style(bandChips.get(j), j == k); render(lastLat, lastLon); })); }
        body.addView(bandRow);
        status = hint("Loading…"); body.addView(status);
        if (!rs.runs().isEmpty()) { LinearLayout undoRow = row(); button(undoRow, "Undo an install…", Theme.MON, x -> undo()); body.addView(undoRow); }
        list = new LinearLayout(c); list.setOrientation(LinearLayout.VERTICAL); body.addView(list);
        dlg = dialog(body);
        load(force);
    }

    private void load(final boolean force) {
        android.location.Location me = svc.lastKnownLocation();
        if (me == null) { status.setText("No position fix yet: turn on location and open a map app once, then try again."); return; }
        status.setText(force ? "Downloading repeater lists…" : "Loading…");
        final double lat = me.getLatitude(), lon = me.getLongitude();
        new Thread(() -> {
            StringBuilder st = new StringBuilder();
            final List<Repeater> found = rs.nearby(lat, lon, radiusMi * KM_PER_MI, force, st);
            final String s = st.toString();
            list.post(() -> { current = found; status.setText(s); lastLat = lat; lastLon = lon; render(lat, lon); });
        }, "repeaters-load").start();
    }

    private boolean passes(Repeater r) {
        if (modeFilter == 1 && !r.fm) return false;
        if (modeFilter == 2 && !r.dmr) return false;
        int b = GeoUtil.band(r.rxHz);
        if (bandFilter == 1 && b != GeoUtil.BAND_VHF) return false;
        if (bandFilter == 2 && b != GeoUtil.BAND_UHF) return false;
        return true;
    }

    private void render(double lat, double lon) {
        if (list == null || current == null) return;
        list.removeAllViews();
        if (current.isEmpty()) { list.addView(hint("Nothing within " + radiusMi + " miles. Try a larger radius.")); return; }
        int shown = 0; for (Repeater r : current) if (passes(r)) shown++;
        if (shown == 0) { list.addView(hint("None of the " + current.size() + " repeaters within " + radiusMi + " miles match these filters.")); return; }
        if (shown < current.size()) list.addView(hint(shown + " of " + current.size() + " shown"));
        int n = 0;
        for (final Repeater r : current) {
            if (!passes(r)) continue;
            if (n++ >= 150) break;
            LinearLayout rowv = shell();
            String kind = r.dmr && r.fm ? "DMR + FM" : r.dmr ? "DMR" + (r.cc >= 0 ? " CC" + r.cc : "") : "FM" + (hasTone(r.toneUp) ? " " + r.toneUp : "");
            rowv.addView(Neo.label(c, nz(r.callsign) + "  ·  " + kind, r.dmr ? Theme.AMBER : Theme.CYAN, 15, true));
            rowv.addView(Neo.label(c, String.format(Locale.US, "%.4f MHz %s%.1f  ·  %s %s%s", r.rxHz / 1e6, r.offsetHz() >= 0 ? "+" : "−", Math.abs(r.offsetHz()) / 1e6, GeoUtil.formatDistanceWithArrow(lat, lon, r.lat, r.lon), nz(r.city), r.approx ? " (approx.)" : ""), 0xFFBFC8D0, 12, false));
            rowv.setClickable(true); rowv.setOnClickListener(x -> details(r, lat, lon));
            list.addView(rowv);
        }
    }

    private void details(final Repeater r, double lat, double lon) {
        LinearLayout body = page("📡  " + nz(r.callsign));
        body.addView(Neo.label(c, String.format(Locale.US, "RX %.4f MHz  ·  TX %.4f MHz", r.rxHz / 1e6, r.txHz / 1e6), Theme.CYAN, 15, true));
        body.addView(hint((r.dmr ? "DMR" + (r.cc >= 0 ? ", colour code " + r.cc : "") + (r.network != null ? ", " + r.network : "") : "FM" + (hasTone(r.toneUp) ? ", TX tone " + r.toneUp : "") + (hasTone(r.toneDown) ? ", RX tone " + r.toneDown : "")) + "\n" + nz(r.city) + (r.region != null && !r.region.isEmpty() ? ", " + r.region : "") + "  ·  " + GeoUtil.formatDistanceWithArrow(lat, lon, r.lat, r.lon) + (r.approx ? " (position approximate)" : "") + (r.status != null && !r.status.isEmpty() ? "\nStatus: " + r.status : "") + (r.lastSeen != null && !r.lastSeen.isEmpty() ? "\nLast seen: " + r.lastSeen : "")));
        final Set<Integer> talk = new LinkedHashSet<>();
        final LinearLayout tgBox = new LinearLayout(c); tgBox.setOrientation(LinearLayout.VERTICAL); body.addView(tgBox);
        if (r.dmr) {
            tgBox.addView(hint("Loading talkgroups…"));
            new Thread(() -> {
                final List<Talkgroup> tgs = rs.talkgroups(r);
                tgBox.post(() -> {
                    tgBox.removeAllViews();
                    if (tgs.isEmpty()) { tgBox.addView(hint("No talkgroup list for this repeater. A listen channel per slot is still created once a talkgroup is known; add TGs by hand in the channel editor.")); return; }
                    tgBox.addView(section("Talkgroups (tick the ones you want a talk channel for)"));
                    for (final Talkgroup tg : tgs) {
                        final boolean[] on = { "static".equalsIgnoreCase(tg.kind) };
                        if (on[0]) talk.add(tg.id);
                        final TextView t = Neo.label(c, (on[0] ? "☑ " : "☐ ") + "TS" + (tg.slot == 2 ? 2 : 1) + "  TG " + tg.id + (tg.name != null && !tg.name.isEmpty() ? "  " + tg.name : "") + (tg.kind != null ? "  (" + tg.kind + ")" : ""), on[0] ? Theme.AMBER : 0xFFBFC8D0, 13, false);
                        t.setPadding(0, dp(4), 0, dp(4)); t.setClickable(true);
                        t.setOnClickListener(x -> { on[0] = !on[0]; if (on[0]) talk.add(tg.id); else talk.remove(tg.id); t.setText((on[0] ? "☑ " : "☐ ") + t.getText().toString().substring(2)); t.setTextColor(on[0] ? Theme.AMBER : 0xFFBFC8D0); });
                        tgBox.addView(t);
                    }
                });
            }, "repeater-tgs").start();
        }
        LinearLayout row = row();
        button(row, "Add to my channels", Theme.PKT, x -> {
            Plan p = rs.plan(r, talk);
            if (p.channels.isEmpty()) { toast(p.warnings.isEmpty() ? "Nothing to program" : p.warnings.get(0)); return; }
            new AlertDialog.Builder(c).setTitle("Add " + nz(r.callsign) + "?").setMessage(RepeaterService.preview(p))
                    .setPositiveButton("Add", (dd, w) -> new Thread(() -> { final String res = rs.program(r, p); list.post(() -> { toast(res); if (sub != null) sub.dismiss(); }); }).start())
                    .setNegativeButton("Cancel", null).show();
        });
        button(row, "Map", Theme.SOFTSQ, x -> { try { c.startActivity(new android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(String.format(Locale.US, "geo:%f,%f?q=%f,%f(%s)", r.lat, r.lon, r.lat, r.lon, android.net.Uri.encode(nz(r.callsign)))))); } catch (Throwable t) { toast("No map app"); } });
        body.addView(row);
        sub = dialog(body);
    }

    private void undo() {
        final List<RepeaterService.Run> runs = rs.runs();
        String[] names = new String[runs.size()]; for (int i = 0; i < names.length; i++) names[i] = runs.get(i).callsign + "  ·  " + runs.get(i).name;
        new AlertDialog.Builder(c).setTitle("Remove which install?").setItems(names, (dd, w) -> { toast(rs.undo(runs.get(w).id)); dlg.dismiss(); }).show();
    }

    // ---- widgets ----
    private static String nz(String s) { return s == null ? "" : s; }
    private static boolean hasTone(String t) { if (t == null) return false; String x = t.trim(); return !x.isEmpty() && !x.equalsIgnoreCase("None") && !x.equals("0") && !x.equals("0.0") && !x.equals("0.00"); }
    private int dp(float x) { return Math.round(x * d); }
    private void toast(String s) { Toast.makeText(c, s, Toast.LENGTH_LONG).show(); }
    private LinearLayout page(String title) { return Neo.sheetBody(c, title); }
    private AlertDialog dialog(LinearLayout body) { return Neo.showSheet(c, body); }
    private TextView hint(String s) { return Neo.sheetHint(c, s); }
    private TextView section(String s) { return Neo.sheetSection(c, s); }
    private LinearLayout row() { LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.HORIZONTAL); r.setGravity(Gravity.CENTER_VERTICAL); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.topMargin = dp(2); lp.bottomMargin = dp(4); r.setLayoutParams(lp); return r; }
    private LinearLayout shell() { LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding(dp(12), dp(8), dp(12), dp(8)); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = dp(6); r.setLayoutParams(lp); return r; }
    private TextView pill(LinearLayout row, String text, boolean on, View.OnClickListener l) { TextView t = Neo.label(c, text, 0xFFBFC8D0, 13, true); t.setGravity(Gravity.CENTER); t.setPadding(dp(6), dp(8), dp(6), dp(8)); t.setClickable(true); t.setOnClickListener(l); style(t, on); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); lp.setMargins(dp(2), 0, dp(2), 0); row.addView(t, lp); return t; }
    private void style(TextView t, boolean on) { Neo.pillStyle(t, on, Neo.GREEN); }
    private TextView button(LinearLayout row, String text, int[] accent, View.OnClickListener l) { TextView b = Neo.button(c, text, null, Neo.accentOf(accent)); b.setTextSize(14); b.setOnClickListener(l); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins(dp(3), dp(4), dp(3), dp(2)); row.setBaselineAligned(false); row.addView(b, lp); return b; }
}
