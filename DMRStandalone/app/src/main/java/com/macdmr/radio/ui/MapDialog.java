package com.macdmr.radio.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.pkt.PacketStore;
import com.macdmr.radio.repeaters.GeoUtil;
import com.macdmr.radio.repeaters.RepeaterModels.Repeater;
import com.macdmr.radio.repeaters.RepeaterService;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Map: APRS stations heard (with their last position), nearby repeaters (within the Nearby repeaters range) and
 * channels that have a location, around your own position. Filter pills switch each kind on and off; tapping a
 * marker opens a card with what is known and an action (use the channel, repeater details, open in Maps).
 */
public final class MapDialog {
    private final Context c; private final RadioService svc; private final float d;
    private final MapView map; private Dialog dlg;
    private final LinearLayout card; private final TextView cardTitle, cardSub, cardBody; private final LinearLayout cardActions;
    private final TextView status;
    private final TextView[] pills = new TextView[5];
    private int layer = MapView.LAYER_NONE; private String focusKey; private String focusName;
    private double focusLat, focusLon, focusHz;
    private com.macdmr.radio.coverage.Prediction.Result pred; private volatile int predRun; private String predStatus = "";
    private android.content.SharedPreferences cprefs() { return c.getSharedPreferences("coverage", Context.MODE_PRIVATE); }
    private boolean predictOn() { return cprefs().getBoolean("predict", true); }
    /** The repeater antenna height chosen for the focused repeater; 0 = Auto (fitted from the measurements, 30 m without enough of them). */
    private int antennaM() { return focusKey == null ? 0 : cprefs().getInt("ant_" + focusKey, 0); }
    /** Prediction range in miles; 0 = Auto (as far as the transmitter can reach, up to 50 miles). */
    private int rangeMi() { return cprefs().getInt("predRangeMi", 0); }
    /** Transmitter power for the focused repeater (W); 0 = not known (50 W assumed, the measurements correct the level). */
    private int powerW() { return focusKey == null ? 0 : cprefs().getInt("pwr_" + focusKey, 0); }
    private void focus(String key, String name, double lat, double lon, double hz) { focusKey = key; focusName = name; focusLat = lat; focusLon = lon; focusHz = hz; pred = null; }
    private LinearLayout legend;
    private final int[] counts = new int[4];
    private final List<MapView.Marker> all = new ArrayList<>();
    private Location me;
    private final Handler ui = new Handler(Looper.getMainLooper());

    public static void show(Context c, RadioService svc) { if (svc != null) new MapDialog(c, svc).open(); }

    private MapDialog(Context c, RadioService svc) {
        this.c = c; this.svc = svc; d = Theme.dp(c);
        map = new MapView(c);
        card = new LinearLayout(c); cardTitle = Neo.label(c, "", Neo.TEXT, 18, true); cardSub = Neo.label(c, "", Neo.CYAN, 14, true);
        cardBody = Neo.label(c, "", Neo.TEXT_SOFT, 14, false); cardActions = new LinearLayout(c);
        status = Neo.label(c, "Loading…", Neo.MUTED, 12.5f, false);
    }

    private void open() {
        LinearLayout root = new LinearLayout(c); root.setOrientation(LinearLayout.VERTICAL); root.setBackgroundColor(Neo.GROUND);

        LinearLayout head = new LinearLayout(c); head.setGravity(Gravity.CENTER_VERTICAL); head.setPadding((int) (16 * d), (int) (12 * d), (int) (10 * d), (int) (8 * d));
        head.addView(Neo.iconTile(c, "map", Neo.CYAN, 40), new LinearLayout.LayoutParams((int) (40 * d), (int) (40 * d)));
        LinearLayout tcol = new LinearLayout(c); tcol.setOrientation(LinearLayout.VERTICAL); tcol.setPadding((int) (12 * d), 0, 0, 0);
        tcol.addView(Neo.label(c, "Map", Neo.TEXT, 20, true)); tcol.addView(status);
        head.addView(tcol, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        ImageView close = Neo.iconButton(c, "close", Neo.CYAN, "Close map");
        head.addView(close);
        root.addView(head);

        LinearLayout pillRow = new LinearLayout(c); pillRow.setPadding((int) (12 * d), 0, (int) (12 * d), (int) (8 * d));
        String[] names = { "Coverage", "Stations", "Repeaters", "Channels", "Help" };
        int[] accents = { Neo.VIOLET, Neo.GREEN, Neo.CYAN, Neo.AMBER, Neo.MUTED };
        for (int i = 0; i < 5; i++) {
            final int idx = i;
            TextView p = Neo.label(c, names[i], accents[i], 14, true); p.setGravity(Gravity.CENTER);
            p.setPadding((int) (14 * d), (int) (8 * d), (int) (14 * d), (int) (8 * d));
            Neo.pillStyle(p, i >= 1 && i <= 3, accents[i]);
            LinearLayout.LayoutParams pl = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT); pl.rightMargin = (int) (8 * d);
            pillRow.addView(p, pl); pills[i] = p;
            p.setOnClickListener(v -> {
                if (idx == 4) { help(); return; }
                if (idx == 0) { coverageSheet(); return; }
                boolean on;
                if (idx == 2) { on = !map.isVisible(MapView.REPEATER_FM); map.setVisible(MapView.REPEATER_FM, on); map.setVisible(MapView.REPEATER_DMR, on); }
                else { int kind = idx == 1 ? MapView.STATION : MapView.CHANNEL; on = !map.isVisible(kind); map.setVisible(kind, on); }
                Neo.pillStyle(p, on, accents[idx]);
            });
        }
        HorizontalScrollView hs = new HorizontalScrollView(c); hs.setHorizontalScrollBarEnabled(false); hs.addView(pillRow);
        root.addView(hs);

        FrameLayout frame = new FrameLayout(c);
        frame.addView(map, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        LinearLayout tools = new LinearLayout(c); tools.setOrientation(LinearLayout.VERTICAL);
        ImageView plus = floating("plus", "Zoom in"), minus = floating("minus", "Zoom out"), locate = floating("locate", "My position"), fit = floating("expand", "Show everything");
        for (ImageView b : new ImageView[] { plus, minus, locate, fit }) { LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams((int) (46 * d), (int) (46 * d)); bl.bottomMargin = (int) (8 * d); tools.addView(b, bl); }
        FrameLayout.LayoutParams tl = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, Gravity.END | Gravity.TOP);
        tl.setMargins(0, (int) (12 * d), (int) (12 * d), 0);
        frame.addView(tools, tl);
        legend = new LinearLayout(c); legend.setOrientation(LinearLayout.VERTICAL); legend.setVisibility(View.GONE);
        legend.setBackground(Neo.sheet(c, Neo.alpha(Neo.VIOLET, 0x55), 14)); legend.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (10 * d));
        legend.setOnClickListener(v -> coverageSheet());
        FrameLayout.LayoutParams gl = new FrameLayout.LayoutParams((int) (230 * d), ViewGroup.LayoutParams.WRAP_CONTENT, Gravity.START | Gravity.TOP);
        gl.setMargins((int) (12 * d), (int) (12 * d), 0, 0);
        frame.addView(legend, gl);

        card.setOrientation(LinearLayout.VERTICAL); card.setBackground(Neo.sheet(c, Neo.alpha(Neo.CYAN, 0x66), 18));
        card.setPadding((int) (16 * d), (int) (14 * d), (int) (16 * d), (int) (12 * d));
        card.addView(cardTitle); card.addView(cardSub); cardBody.setPadding(0, (int) (6 * d), 0, (int) (4 * d)); card.addView(cardBody);
        cardActions.setBaselineAligned(false); card.addView(cardActions);
        card.setVisibility(View.GONE);
        card.setOnClickListener(v -> { });
        FrameLayout.LayoutParams cl = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM);
        cl.setMargins((int) (12 * d), 0, (int) (12 * d), (int) (30 * d));
        frame.addView(card, cl);
        root.addView(frame, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));

        dlg = new Dialog(c, android.R.style.Theme_Black_NoTitleBar);
        dlg.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dlg.setContentView(root);
        Window w = dlg.getWindow();
        if (w != null) { w.setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(Neo.GROUND)); w.setStatusBarColor(Neo.GROUND); w.setNavigationBarColor(Neo.BAR); }
        dlg.setOnDismissListener(x -> { stopFollowing(); svc.coverage().setOnData(null); ui.removeCallbacks(liveRefresh); map.shutdown(); });
        dlg.show();

        close.setOnClickListener(v -> dlg.dismiss());
        plus.setOnClickListener(v -> map.zoomBy(1));
        minus.setOnClickListener(v -> map.zoomBy(-1));
        locate.setOnClickListener(v -> { if (me != null) map.center(me.getLatitude(), me.getLongitude(), Math.max(map.zoom(), 11)); else Toast.makeText(c, "No position fix yet: turn on location", Toast.LENGTH_SHORT).show(); });
        fit.setOnClickListener(v -> fitVisible());
        map.setOnSelect(this::showCard);
        map.setOnCell(this::showCellCard);

        me = svc.lastKnownLocation();
        if (me != null) { map.center(me.getLatitude(), me.getLongitude(), 10); map.setMe(me.getLatitude(), me.getLongitude(), me.hasAccuracy() ? me.getAccuracy() : 0); }
        startFollowing();
        svc.coverage().setOnData(() -> { ui.removeCallbacks(liveRefresh); ui.postDelayed(liveRefresh, 1500); });
        load();
        android.content.SharedPreferences cp = c.getSharedPreferences("coverage", Context.MODE_PRIVATE);
        if (!cp.getBoolean("introShown", false)) { cp.edit().putBoolean("introShown", true).apply(); ui.postDelayed(this::coverageIntro, 600); }
        else if (svc.coverage().store().rxCount() + svc.coverage().store().txCount() > 0) setLayer(MapView.LAYER_RX);
    }

    // ---- your position, live while the map is open ----
    private android.location.LocationListener follow;
    private void startFollowing() {
        try {
            android.location.LocationManager lm = (android.location.LocationManager) c.getSystemService(Context.LOCATION_SERVICE);
            follow = l -> {
                Location cur = me;   // a network fix only replaces a GPS one when GPS has been quiet for 10 s
                if (cur != null && !android.location.LocationManager.GPS_PROVIDER.equals(l.getProvider()) && android.location.LocationManager.GPS_PROVIDER.equals(cur.getProvider())
                        && l.getElapsedRealtimeNanos() - cur.getElapsedRealtimeNanos() < 10_000_000_000L) return;
                me = l; map.setMe(l.getLatitude(), l.getLongitude(), l.hasAccuracy() ? l.getAccuracy() : 0);
            };
            lm.requestLocationUpdates(android.location.LocationManager.GPS_PROVIDER, 1000, 0, follow, Looper.getMainLooper());
            try { lm.requestLocationUpdates(android.location.LocationManager.NETWORK_PROVIDER, 3000, 0, follow, Looper.getMainLooper()); } catch (Throwable ignored) { }
        } catch (Throwable ignored) { }   // no permission: the dot stays where the last fix put it
    }
    private void stopFollowing() {
        try { if (follow != null) ((android.location.LocationManager) c.getSystemService(Context.LOCATION_SERVICE)).removeUpdates(follow); } catch (Throwable ignored) { }
        follow = null;
    }

    private ImageView floating(String icon, String desc) {
        ImageView b = Neo.iconButton(c, icon, Neo.CYAN, desc);
        b.setBackground(Neo.sheet(c, Neo.alpha(Neo.CYAN, 0x55), 23));
        int p = (int) (11 * d); b.setPadding(p, p, p, p);
        return b;
    }

    private void fitVisible() {
        List<MapView.Marker> v = new ArrayList<>();
        for (MapView.Marker m : all) if (map.isVisible(m.kind)) v.add(m);
        if (v.isEmpty()) { Toast.makeText(c, "Nothing to show yet", Toast.LENGTH_SHORT).show(); return; }
        map.fit(v);
    }

    /** Stations and channels at once; repeaters from the Nearby repeaters cache (or the network) in the background. */
    private void load() {
        new Thread(() -> {
            final List<MapView.Marker> ms = new ArrayList<>();
            int st = 0, ch = 0, rp = 0;
            try {
                if (svc.packet() != null) for (PacketStore.Station s : svc.packet().store().stations(500)) {
                    if (s.lat == 0 && s.lon == 0) continue;
                    ms.add(new MapView.Marker(s.lat, s.lon, MapView.STATION, s.call, s)); st++;
                }
            } catch (Throwable ignored) { }
            try {
                for (ChannelStore.Channel x : svc.store().all()) {
                    if (x.lat == 0 && x.lon == 0) continue;
                    ms.add(new MapView.Marker(x.lat, x.lon, MapView.CHANNEL, x.name, x)); ch++;
                }
            } catch (Throwable ignored) { }
            final int fst = st, fch = ch;
            ui.post(() -> { publish(ms, fst, fch, -1); if (me == null) fitVisible(); });
            if (me == null) return;
            try {
                double mi = c.getSharedPreferences("repeaters", Context.MODE_PRIVATE).getInt("radiusMi", 30);
                List<Repeater> reps = new RepeaterService(c, svc.store()).nearby(me.getLatitude(), me.getLongitude(), mi * 1.609344, false, new StringBuilder());
                for (Repeater r : reps) {
                    if (!r.hasCoords) continue;
                    ms.add(new MapView.Marker(r.lat, r.lon, r.dmr ? MapView.REPEATER_DMR : MapView.REPEATER_FM, (r.callsign == null ? "?" : r.callsign) + " " + String.format(Locale.US, "%.3f", r.rxHz / 1e6), r)); rp++;
                }
            } catch (Throwable ignored) { }
            final int frp = rp;
            ui.post(() -> publish(ms, fst, fch, frp));
        }, "map-load").start();
    }

    private void publish(List<MapView.Marker> ms, int st, int ch, int rp) {
        all.clear(); all.addAll(ms); map.setMarkers(new ArrayList<>(ms));
        counts[0] = st; counts[1] = rp; counts[2] = ch;
        pills[1].setText("Stations " + st); pills[2].setText(rp < 0 ? "Repeaters …" : "Repeaters " + rp); pills[3].setText("Channels " + ch);
        status.setText(me == null ? "No position fix: showing what has a location" : rp < 0 ? "Finding repeaters near you…" : "Around you · pinch to zoom, tap a marker");
    }

    private String dist(double lat, double lon) {
        if (me == null) return "";
        double m = GeoUtil.haversineMeters(me.getLatitude(), me.getLongitude(), lat, lon), mi = m * 0.000621371;
        double brg = GeoUtil.bearingDegrees(me.getLatitude(), me.getLongitude(), lat, lon);
        String[] dirs = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" };
        return (mi < 10 ? String.format(Locale.US, "%.1f mi", mi) : String.format(Locale.US, "%.0f mi", mi)) + " " + dirs[(int) Math.round(brg / 45) % 8];
    }

    private static String ago(long ts) {
        long s = Math.max(0, (System.currentTimeMillis() - ts) / 1000);
        if (s < 90) return s + " s ago"; if (s < 5400) return (s / 60) + " min ago"; if (s < 172800) return (s / 3600) + " h ago"; return (s / 86400) + " days ago";
    }

    private void showCard(final MapView.Marker m) {
        if (m == null) { card.setVisibility(View.GONE); return; }
        cardActions.removeAllViews();
        final String geo = String.format(Locale.US, "geo:%.6f,%.6f?q=%.6f,%.6f", m.lat, m.lon, m.lat, m.lon);
        if (m.data instanceof PacketStore.Station) {
            PacketStore.Station s = (PacketStore.Station) m.data;
            cardTitle.setText(s.call); cardTitle.setTextColor(Neo.GREEN);
            cardSub.setText("APRS station · " + dist(s.lat, s.lon)); cardSub.setTextColor(Neo.GREEN);
            StringBuilder b = new StringBuilder("Heard " + ago(s.lastTs) + (s.count > 1 ? ", " + s.count + " times" : ""));
            if (s.via != null && !s.via.isEmpty()) b.append(" via ").append(s.via);
            if (s.speedKmh >= 0) b.append(String.format(Locale.US, "\nMoving %.0f mph", s.speedKmh * 0.621371)).append(s.courseDeg >= 0 ? " toward " + s.courseDeg + "°" : "");
            if (s.alt != 0) b.append(String.format(Locale.US, "\nAltitude %d ft", Math.round(s.alt * 3.28084)));
            if (s.comment != null && !s.comment.trim().isEmpty()) b.append("\n").append(s.comment.trim());
            cardBody.setText(b);
        } else if (m.data instanceof Repeater) {
            final Repeater r = (Repeater) m.data;
            int col = r.dmr ? Neo.VIOLET : Neo.CYAN;
            cardTitle.setText(r.callsign == null ? "Repeater" : r.callsign); cardTitle.setTextColor(col);
            cardSub.setText((r.dmr ? "DMR" + (r.cc >= 0 ? " CC" + r.cc : "") : "FM" + (hasTone(r.toneUp) ? " " + r.toneUp : "")) + " repeater · " + dist(r.lat, r.lon)); cardSub.setTextColor(col);
            cardBody.setText(String.format(Locale.US, "Output %.4f MHz, input %.4f MHz", r.rxHz / 1e6, r.txHz / 1e6) + (r.city != null ? "\n" + r.city + (r.region != null ? ", " + r.region : "") : "") + (r.approx ? "\nPosition is approximate" : ""));
            action("Details", "repeaters", col, v -> RepeatersDialog.showDetails(c, svc, r, me != null ? me.getLatitude() : r.lat, me != null ? me.getLongitude() : r.lon));
            action("Coverage", "signal", Neo.VIOLET, v -> { focus(com.macdmr.radio.coverage.CoverageMath.repeaterKey((int) r.rxHz, r.lat, r.lon), r.callsign == null ? "Repeater" : r.callsign, r.lat, r.lon, r.rxHz); setLayer(layer == MapView.LAYER_NONE ? MapView.LAYER_RX : layer); card.setVisibility(View.GONE); });
        } else if (m.data instanceof ChannelStore.Channel) {
            final ChannelStore.Channel x = (ChannelStore.Channel) m.data;
            cardTitle.setText(x.name); cardTitle.setTextColor(Neo.AMBER);
            cardSub.setText("Channel " + x.number + " · " + (x.isDigital() ? "DMR" : "Analog") + " · " + dist(x.lat, x.lon)); cardSub.setTextColor(Neo.AMBER);
            cardBody.setText(String.format(Locale.US, "RX %.4f MHz, TX %.4f MHz", x.rxFreq / 1e6, x.txFreq / 1e6));
            action("Use channel", "channels", Neo.AMBER, v -> { svc.selectChannel(x.number); Toast.makeText(c, "Channel " + x.number + ": " + x.name, Toast.LENGTH_SHORT).show(); });
            action("Coverage", "signal", Neo.VIOLET, v -> { focus(com.macdmr.radio.coverage.CoverageMath.repeaterKey(x.rxFreq, x.lat, x.lon), x.name, x.lat, x.lon, x.rxFreq); setLayer(layer == MapView.LAYER_NONE ? MapView.LAYER_RX : layer); card.setVisibility(View.GONE); });
        }
        if (!(m.data instanceof ChannelStore.Channel) && !(m.data instanceof Repeater)) action("Open in Maps", "map", Neo.CYAN, v -> { try { c.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(geo))); } catch (Throwable t) { Toast.makeText(c, "No maps app", Toast.LENGTH_SHORT).show(); } });
        card.setVisibility(View.VISIBLE);
    }

    private static boolean hasTone(String t) {
        if (t == null || t.trim().isEmpty()) return false;
        try { return Double.parseDouble(t.trim()) > 0; } catch (NumberFormatException e) { return true; }   // DCS codes such as D023N
    }

    private void action(String label, String icon, int accent, View.OnClickListener l) {
        TextView b = Neo.button(c, label, icon, accent); b.setTextSize(14);
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f);
        bl.setMargins(cardActions.getChildCount() == 0 ? 0 : (int) (4 * d), (int) (8 * d), cardActions.getChildCount() == 0 ? (int) (4 * d) : 0, 0);
        b.setOnClickListener(l); cardActions.addView(b, bl);
    }

    // ---- coverage ---------------------------------------------------------------------------------------

    private void setLayer(int l) {
        if (l != layer) card.setVisibility(View.GONE);
        layer = l;
        Neo.pillStyle(pills[0], l != MapView.LAYER_NONE, Neo.VIOLET);
        if (l == MapView.LAYER_NONE) { map.setCells(null, l); map.setPredicted(null); legend.setVisibility(View.GONE); return; }
        final String key = focusKey;
        updatePrediction();
        new Thread(() -> {
            com.macdmr.radio.coverage.CoverageStore st = svc.coverage().store();
            final List<com.macdmr.radio.coverage.CoverageStore.Cell> cells = l == MapView.LAYER_RX ? st.rxCells(key) : st.txCells(key);
            ui.post(() -> { if (layer == l) { map.setCells(cells, l); measuredSquares = cells.size(); showLegend(cells.size()); } });
        }, "coverage-cells").start();
    }

    private int measuredSquares;
    private long predAt;

    /** New readings while the map is open: redraw the measured squares now; re-calibrate the prediction at most every 2 minutes. */
    private final Runnable liveRefresh = this::refreshLive;
    private void refreshLive() {
        if (layer == MapView.LAYER_NONE) return;
        final int l = layer; final String key = focusKey;
        new Thread(() -> {
            com.macdmr.radio.coverage.CoverageStore st = svc.coverage().store();
            final List<com.macdmr.radio.coverage.CoverageStore.Cell> cells = l == MapView.LAYER_RX ? st.rxCells(key) : st.txCells(key);
            ui.post(() -> {
                if (layer != l || (key == null ? focusKey != null : !key.equals(focusKey))) return;
                map.setCells(cells, l); measuredSquares = cells.size(); showLegend(cells.size());
                if (pred != null && System.currentTimeMillis() - predAt > 120_000) { pred = null; updatePrediction(); }
            });
        }, "coverage-live").start();
    }

    /** Run (or reuse) the terrain prediction for the focused repeater and show it under the measured squares. */
    private void updatePrediction() {
        if (!predictOn() || focusKey == null || layer == MapView.LAYER_NONE) { map.setPredicted(null); predStatus = ""; return; }
        if (pred != null) { map.setPredicted(layer == MapView.LAYER_RX ? pred.rx : pred.tx); predStatus = pred.summary(layer == MapView.LAYER_RX); return; }
        final int run = ++predRun;
        final String key = focusKey; final double lat = focusLat, lon = focusLon, hz = focusHz, ant = antennaM(), erp = powerW(), rad = rangeMi() * 1609.344;
        final android.location.Location here = svc.lastKnownLocation();
        final double meLat = here != null ? here.getLatitude() : Double.NaN, meLon = here != null ? here.getLongitude() : Double.NaN;
        predStatus = "Terrain prediction: starting\u2026";
        new Thread(() -> {
            com.macdmr.radio.coverage.Prediction.Result r; String err = null;
            try {
                r = com.macdmr.radio.coverage.Prediction.run(c, svc.coverage().store(), key, lat, lon, hz, ant, erp, rad, meLat, meLon, text -> {
                    if (run != predRun) return false;
                    ui.post(() -> { if (run == predRun) { predStatus = "Terrain prediction: " + text; showLegend(measuredSquares); } });
                    return true;
                });
            } catch (Throwable t) { r = null; err = t.getMessage(); }
            final com.macdmr.radio.coverage.Prediction.Result fr = r; final String fe = err;
            ui.post(() -> {
                if (run != predRun) return;
                if (fr == null) { predStatus = fe == null ? "" : "Terrain prediction failed: " + fe; showLegend(measuredSquares); return; }
                pred = fr; predAt = System.currentTimeMillis(); map.setPredicted(layer == MapView.LAYER_RX ? fr.rx : fr.tx);
                predStatus = "Faint squares: terrain prediction. " + fr.summary(layer == MapView.LAYER_RX);
                showLegend(measuredSquares);
            });
        }, "coverage-predict").start();
    }

    private void showLegend(int squares) {
        legend.removeAllViews();
        String who = focusKey == null ? "All repeaters" : focusName;
        legend.addView(Neo.label(c, (layer == MapView.LAYER_RX ? "Heard \u00b7 " : "Key-ups \u00b7 ") + who, Neo.TEXT, 13.5f, true));
        if (layer == MapView.LAYER_RX) {
            View bar = new View(c) {
                final android.graphics.Paint p = new android.graphics.Paint();
                @Override protected void onDraw(android.graphics.Canvas cv) {
                    int n = 40; float w = getWidth() / (float) n;
                    for (int i = 0; i < n; i++) {
                        int dbm = com.macdmr.radio.coverage.CoverageMath.SCALE_LOW + (com.macdmr.radio.coverage.CoverageMath.SCALE_HIGH - com.macdmr.radio.coverage.CoverageMath.SCALE_LOW) * i / (n - 1);
                        p.setColor(com.macdmr.radio.coverage.CoverageMath.signalColor(dbm)); cv.drawRect(i * w, 0, (i + 1) * w + 1, getHeight(), p);
                    }
                }
            };
            LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, (int) (8 * d)); bl.topMargin = (int) (6 * d);
            legend.addView(bar, bl);
            LinearLayout ends = new LinearLayout(c);
            TextView lo = Neo.label(c, com.macdmr.radio.coverage.CoverageMath.sUnits(com.macdmr.radio.coverage.CoverageMath.SCALE_LOW) + " weak", Neo.MUTED, 11.5f, false),
                    hi = Neo.label(c, com.macdmr.radio.coverage.CoverageMath.sUnits(com.macdmr.radio.coverage.CoverageMath.SCALE_HIGH) + " strong", Neo.MUTED, 11.5f, false); hi.setGravity(Gravity.END);
            ends.addView(lo, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f)); ends.addView(hi, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
            legend.addView(ends);
        } else {
            LinearLayout keys = new LinearLayout(c); keys.setPadding(0, (int) (4 * d), 0, 0);
            keys.addView(Neo.label(c, "\u25A0 Keyed", Neo.GREEN, 13, true));
            TextView no = Neo.label(c, "\u25A0 No reply", Neo.RED, 13, true); no.setPadding((int) (14 * d), 0, 0, 0); keys.addView(no);
            legend.addView(keys);
        }
        legend.addView(Neo.label(c, squares == 0 ? (pred != null ? "Nothing measured yet for this repeater" : "Nothing measured yet: tap to start logging") : squares + " measured squares of 150 m \u00b7 tap a square", Neo.MUTED, 11.5f, false));
        if (!predStatus.isEmpty()) { TextView ps = Neo.label(c, predStatus, Neo.VIOLET_LIGHT, 11.5f, false); ps.setPadding(0, (int) (3 * d), 0, 0); legend.addView(ps); }
        legend.setVisibility(View.VISIBLE);
    }

    private void showCellCard(com.macdmr.radio.coverage.CoverageStore.Cell cell) {
        cardActions.removeAllViews();
        if (cell.predicted) {
            String where = dist((cell.s + cell.n) / 2, (cell.w + cell.e) / 2);
            if (layer == MapView.LAYER_RX) {
                cardTitle.setText("About " + cell.value + " dBm \u00b7 " + com.macdmr.radio.coverage.CoverageMath.sUnits(cell.value)); cardTitle.setTextColor(com.macdmr.radio.coverage.CoverageMath.signalColor(cell.value));
                cardSub.setText("Predicted \u00b7 " + focusName + " \u00b7 " + where);
                cardBody.setText("Not measured here: calculated from the terrain between this square and the repeater (antenna " + (pred != null ? Math.round(pred.antennaUsed) : 30) + " m above ground" + (pred != null && pred.antennaFitted ? ", fitted to your measurements" : "") + "). " + (pred != null ? pred.summary(true) + "." : "") + " Trees and buildings are not in the terrain data, so expect less in forest and town.");
            } else {
                cardTitle.setText("Should key up (" + cell.value + " dB to spare)"); cardTitle.setTextColor(Neo.GREEN);
                cardSub.setText("Predicted \u00b7 " + focusName + " \u00b7 " + where);
                cardBody.setText("Calculated from the terrain and a typical handheld on high power. " + (pred != null ? pred.summary(false) + "." : "") + " The more key-ups you log, the better this gets.");
            }
            cardSub.setTextColor(Neo.VIOLET);
            card.setVisibility(View.VISIBLE);
            return;
        }
        if (layer == MapView.LAYER_RX) {
            cardTitle.setText(cell.value + " dBm \u00b7 " + com.macdmr.radio.coverage.CoverageMath.sUnits(cell.value)); cardTitle.setTextColor(com.macdmr.radio.coverage.CoverageMath.signalColor(cell.value));
            cardSub.setText("Heard " + (focusKey == null ? "(best repeater here)" : focusName) + " \u00b7 " + dist((cell.s + cell.n) / 2, (cell.w + cell.e) / 2)); cardSub.setTextColor(Neo.VIOLET);
            cardBody.setText("Typical reading of " + cell.count + (cell.count == 1 ? " measurement" : " measurements") + " in this 150 m square. This is the repeater's signal reaching the phone; whether the phone reaches the repeater is the Key-ups layer.");
        } else {
            boolean ok = cell.keyed > 0;
            cardTitle.setText(ok ? "Keyed " + cell.keyed + " of " + cell.count : "No reply " + cell.failed + (cell.failed == 1 ? " time" : " times")); cardTitle.setTextColor(ok ? Neo.GREEN : Neo.RED);
            cardSub.setText((focusKey == null ? "Any repeater" : focusName) + " \u00b7 " + dist((cell.s + cell.n) / 2, (cell.w + cell.e) / 2)); cardSub.setTextColor(Neo.VIOLET);
            cardBody.setText(ok ? "Your transmissions from this square opened the repeater: its tail came back right after you let go." : "The repeater did not answer your transmissions from here, although it answers you elsewhere. Try high power or a better spot.");
        }
        card.setVisibility(View.VISIBLE);
    }

    private void coverageIntro() {
        LinearLayout box = Neo.sheetBody(c, "Coverage maps");
        box.addView(Neo.label(c, "NEW", Neo.VIOLET, 12, true));
        box.addView(Neo.sheetHint(c, "Find out where your repeaters really work. With logging on, the app remembers how strong each repeater is wherever you hear it, and whether it answers when you transmit. Drive or walk around normally; the map fills in."));
        box.addView(Neo.sheetHint(c, "Two layers: Heard shows the repeater's signal reaching you, in colour from weak blue to strong red. Key-ups shows where your own transmissions opened the repeater (green) or got no reply (red), which is usually the shorter range."));
        box.addView(Neo.sheetHint(c, "It works on channels that have a location, which channels added from Nearby repeaters already have. Nothing is sent anywhere: it is all kept on the phone and can be exported."));
        TextView go = Neo.button(c, "Turn on coverage logging", "signal", Neo.VIOLET);
        LinearLayout.LayoutParams gl = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT); gl.topMargin = (int) (12 * d);
        box.addView(go, gl);
        final Dialog sh = Neo.showSheet(c, box);
        go.setOnClickListener(v -> { svc.setCoverageLogging(true); if (sh != null) sh.dismiss(); setLayer(MapView.LAYER_RX); Toast.makeText(c, "Coverage logging is on", Toast.LENGTH_SHORT).show(); });
    }

    private void coverageSheet() {
        final com.macdmr.radio.coverage.CoverageLogger lg = svc.coverage();
        final com.macdmr.radio.coverage.CoverageStore st = lg.store();
        LinearLayout box = Neo.sheetBody(c, "Coverage maps");
        box.addView(Neo.sheetHint(c, "Heard: the repeater's signal at each place you heard it. Key-ups: places where your transmission opened the repeater (green) or got no reply (red)."));

        Neo.NeonSwitch sw = new Neo.NeonSwitch(c); sw.setChecked(lg.enabled());
        final int rxN = st.rxCount(), txN = st.txCount();
        LinearLayout row = Neo.switchRow(c, "signal", Neo.VIOLET, "Log coverage", rxN + " readings, " + txN + " transmissions stored", sw);
        row.setBackground(Neo.rowCard(c));
        LinearLayout.LayoutParams rl = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT); rl.topMargin = (int) (10 * d);
        box.addView(row, rl);
        sw.setOnChange(on -> { svc.setCoverageLogging(on); Toast.makeText(c, on ? "Coverage logging is on" : "Coverage logging is off", Toast.LENGTH_SHORT).show(); });
        TextView test = Neo.button(c, "Key-up test here", "signal", Neo.VIOLET); test.setTextSize(14);
        LinearLayout.LayoutParams tl2 = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT); tl2.topMargin = (int) (8 * d);
        box.addView(test, tl2);
        box.addView(Neo.sheetHint(c, "On an FM repeater channel: sends your callsign in Morse (about 3 seconds, a legal identification) and records whether the repeater answered from this spot. Use it sparingly."));
        test.setOnClickListener(v -> {
            ChannelStore.Channel cur = svc.current();
            new android.app.AlertDialog.Builder(c).setTitle("Transmit a key-up test?")
                    .setMessage("Sends your callsign in Morse on " + (cur == null ? "this channel" : cur.name) + " and listens for the repeater's tail. Only test a repeater you are allowed to use.")
                    .setPositiveButton("Transmit", (dd, w) -> { String e = svc.keyupTest(); Toast.makeText(c, e == null ? "Sending your ID\u2026 the result appears in the history" : e, Toast.LENGTH_LONG).show(); })
                    .setNegativeButton("Cancel", null).show();
        });

        box.addView(Neo.sheetSection(c, "Show on the map"));
        LinearLayout lay = new LinearLayout(c);
        String[] ln = { "Off", "Heard", "Key-ups" }; final TextView[] lp = new TextView[3];
        for (int i = 0; i < 3; i++) {
            final int li = i;
            TextView t = Neo.label(c, ln[i], Neo.VIOLET, 14, true); t.setGravity(Gravity.CENTER); t.setPadding(0, (int) (9 * d), 0, (int) (9 * d));
            Neo.pillStyle(t, layer == i, Neo.VIOLET); lp[i] = t;
            LinearLayout.LayoutParams pl = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f); pl.setMargins(i == 0 ? 0 : (int) (4 * d), 0, i == 2 ? 0 : (int) (4 * d), 0);
            lay.addView(t, pl);
            t.setOnClickListener(v -> { setLayer(li); for (int k = 0; k < 3; k++) Neo.pillStyle(lp[k], k == li, Neo.VIOLET); });
        }
        box.addView(lay);

        box.addView(Neo.sheetSection(c, "Repeater"));
        final List<com.macdmr.radio.coverage.CoverageStore.Repeater> reps = st.repeaters();
        final List<TextView> rows = new ArrayList<>();
        TextView allRow = repRow("All repeaters", "The best repeater in each square", focusKey == null);
        box.addView(allRow); rows.add(allRow);
        allRow.setOnClickListener(v -> { focus(null, null, 0, 0, 0); for (TextView r : rows) Neo.pillStyle(r, r == v, Neo.VIOLET); if (layer == MapView.LAYER_NONE) setLayer(MapView.LAYER_RX); else setLayer(layer); });
        boolean listed = focusKey == null; for (com.macdmr.radio.coverage.CoverageStore.Repeater r : reps) if (r.key.equals(focusKey)) listed = true;
        if (!listed) {                                       // focused from the map, nothing measured yet: still show it as the selection
            com.macdmr.radio.coverage.CoverageStore.Repeater f = new com.macdmr.radio.coverage.CoverageStore.Repeater();
            f.key = focusKey; f.name = focusName; f.rxHz = (int) focusHz; f.lat = focusLat; f.lon = focusLon; reps.add(0, f);
        }
        for (final com.macdmr.radio.coverage.CoverageStore.Repeater r : reps) {
            TextView t = repRow(r.name + String.format(Locale.US, "  %.4f", r.rxHz / 1e6), r.rxCount + " readings \u00b7 " + r.txCount + " transmissions" + (r.txCount > 0 ? " (" + r.keyed + " keyed)" : ""), r.key.equals(focusKey));
            box.addView(t); rows.add(t);
            t.setOnClickListener(v -> {
                focus(r.key, r.name, r.lat, r.lon, r.rxHz); for (TextView x : rows) Neo.pillStyle(x, x == v, Neo.VIOLET);
                setLayer(layer == MapView.LAYER_NONE ? MapView.LAYER_RX : layer);
                map.center(r.lat, r.lon, Math.min(map.zoom(), 11));
            });
        }
        box.addView(Neo.sheetSection(c, "Terrain prediction"));
        if (focusKey == null) box.addView(Neo.sheetHint(c, "Pick one repeater above (or tap a repeater or channel on the map \u2192 Coverage) to predict its range from the terrain, even before you have measured anything."));
        else {
            Neo.NeonSwitch ps = new Neo.NeonSwitch(c); ps.setChecked(predictOn());
            LinearLayout prow = Neo.switchRow(c, "map", Neo.VIOLET, "Show prediction", "Faint squares under the measured ones, for " + focusName, ps);
            prow.setBackground(Neo.rowCard(c)); box.addView(prow);
            ps.setOnChange(on -> { cprefs().edit().putBoolean("predict", on).apply(); updatePrediction(); showLegend(measuredSquares); });
            box.addView(Neo.sheetHint(c, "Repeater antenna height above ground"));
            box.addView(choiceRow(new int[] { 0, 15, 30, 60, 100 }, new String[] { "Auto", "15 m", "30 m", "60 m", "100 m" }, antennaM(), " m", "Antenna height above ground (m)", 3, 600,
                    v -> { cprefs().edit().putInt("ant_" + focusKey, v).apply(); pred = null; updatePrediction(); }));
            box.addView(Neo.sheetHint(c, "Auto fits the height to your Heard measurements once they cover a range of distances (it shapes how far the signal carries over the hills); until then it uses 30 m. If you know it (the tower registry lists tower heights), Set it."));
            box.addView(Neo.sheetHint(c, "Transmitter power (effective radiated). Unknown: 50 W is assumed and your Heard readings correct the level. NOAA Weather Radio stations list theirs (most are 1000 W)."));
            box.addView(choiceRow(new int[] { 0, 25, 100, 300, 1000 }, new String[] { "Unknown", "25 W", "100 W", "300 W", "1000 W" }, powerW(), " W", "Transmitter power (W)", 1, 100000,
                    v -> { cprefs().edit().putInt("pwr_" + focusKey, v).apply(); pred = null; updatePrediction(); }));
            box.addView(Neo.sheetHint(c, "Range: Auto reaches as far as this transmitter's power and antenna height can carry over flat ground (hills only shorten it), up to 50 miles; a fixed range is a minimum. It always reaches your position and everything you have measured."));
            box.addView(choiceRow(new int[] { 0, 10, 20, 30, 50 }, new String[] { "Auto", "10 mi", "20 mi", "30 mi", "50 mi" }, rangeMi(), null, null, 0, 0, v -> { cprefs().edit().putInt("predRangeMi", v).apply(); pred = null; updatePrediction(); }));
            box.addView(Neo.sheetHint(c, "Terrain heights come from the open Terrain Tiles (about 55 m detail) and are kept on the phone. The first prediction for an area downloads them."));
        }
        int located = 0; for (ChannelStore.Channel x : svc.store().all()) if (x.lat != 0 || x.lon != 0) located++;
        box.addView(Neo.sheetHint(c, (reps.isEmpty() ? "Nothing measured yet. " : "") + "Logging works on channels with a location: " + located + " of your channels have one (channel editor \u2192 Location; channels added from Nearby repeaters get it automatically). Key-ups are judged only on repeater channels, where transmit and receive differ."));

        LinearLayout btns = new LinearLayout(c); btns.setBaselineAligned(false);
        TextView exp = Neo.button(c, "Export", "backup", Neo.GREEN), clr = Neo.button(c, "Clear", "close", Neo.RED);
        exp.setTextSize(14); clr.setTextSize(14);
        LinearLayout.LayoutParams b1 = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f); b1.setMargins(0, (int) (14 * d), (int) (4 * d), 0);
        LinearLayout.LayoutParams b2 = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f); b2.setMargins((int) (4 * d), (int) (14 * d), 0, 0);
        btns.addView(exp, b1); btns.addView(clr, b2);
        box.addView(btns);
        final Dialog sh = Neo.showSheet(c, box);
        exp.setOnClickListener(v -> new Thread(() -> {
            String msg;
            try { java.io.File dir = com.macdmr.radio.coverage.CoverageExport.export(st); msg = "Saved to Download/DMR/Coverage/" + dir.getName() + ": two CSV files and coverage.kml for Google Earth"; }
            catch (Throwable t) { msg = "Export failed: " + t.getMessage(); }
            final String m2 = msg; ui.post(() -> Toast.makeText(c, m2, Toast.LENGTH_LONG).show());
        }, "coverage-export").start());
        clr.setOnClickListener(v -> new android.app.AlertDialog.Builder(c).setTitle(focusKey == null ? "Clear all coverage data?" : "Clear coverage for " + focusName + "?")
                .setMessage("The stored readings and key-ups are deleted from the phone. Export first to keep a copy.")
                .setPositiveButton("Clear", (dd, w) -> { st.clear(focusKey); if (sh != null) sh.dismiss(); focus(null, null, 0, 0, 0); setLayer(layer); })
                .setNegativeButton("Cancel", null).show());
    }

    private interface IntPick { void pick(int v); }
    /**
     * A row of choice pills. With {@code unit} set, a last "Set" pill takes any whole number from {@code min} to
     * {@code max} (it shows the value when the current one is not among the pills).
     */
    private LinearLayout choiceRow(int[] values, String[] labels, int current, String unit, String askTitle, int min, int max, IntPick pick) {
        LinearLayout row = new LinearLayout(c); row.setPadding(0, (int) (4 * d), 0, (int) (4 * d));
        final List<TextView> all = new ArrayList<>();
        boolean listed = false; for (int v : values) if (v == current) listed = true;
        for (int i = 0; i < values.length; i++) {
            final int v = values[i];
            TextView t = Neo.label(c, labels[i], Neo.VIOLET, 14, true); t.setGravity(Gravity.CENTER); t.setPadding(0, (int) (8 * d), 0, (int) (8 * d));
            Neo.pillStyle(t, v == current, Neo.VIOLET); all.add(t);
            LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f); l.setMargins(i == 0 ? 0 : (int) (3 * d), 0, i == values.length - 1 ? 0 : (int) (3 * d), 0);
            row.addView(t, l);
            t.setOnClickListener(x -> { for (TextView o : all) Neo.pillStyle(o, o == x, Neo.VIOLET); pick.pick(v); });
        }
        if (unit != null) {
            final TextView set = Neo.label(c, listed ? "Set" : current + unit, Neo.VIOLET, 14, true); set.setGravity(Gravity.CENTER); set.setPadding(0, (int) (8 * d), 0, (int) (8 * d));
            Neo.pillStyle(set, !listed, Neo.VIOLET); all.add(set);
            LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1.15f); l.setMargins((int) (3 * d), 0, 0, 0);
            row.addView(set, l);
            set.setOnClickListener(x -> {
                final android.widget.EditText in = new android.widget.EditText(c); in.setInputType(android.text.InputType.TYPE_CLASS_NUMBER); in.setHint(min + " to " + max);
                new android.app.AlertDialog.Builder(c).setTitle(askTitle).setView(in).setPositiveButton("Set", (dd, w) -> {
                    int v; try { v = Integer.parseInt(in.getText().toString().trim()); } catch (NumberFormatException e) { return; }
                    if (v < min || v > max) { Toast.makeText(c, "Between " + min + " and " + max, Toast.LENGTH_SHORT).show(); return; }
                    for (TextView o : all) Neo.pillStyle(o, o == set, Neo.VIOLET); set.setText(v + unit); pick.pick(v);
                }).setNegativeButton("Cancel", null).show();
            });
        }
        return row;
    }

    private TextView repRow(String title, String sub, boolean on) {
        TextView t = Neo.label(c, title + "\n" + sub, Neo.TEXT, 14.5f, true);
        t.setPadding((int) (14 * d), (int) (10 * d), (int) (14 * d), (int) (10 * d));
        Neo.pillStyle(t, on, Neo.VIOLET);
        LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT); l.bottomMargin = (int) (6 * d);
        t.setLayoutParams(l);
        return t;
    }

    private void help() {
        LinearLayout box = Neo.sheetBody(c, "Map");
        box.addView(Neo.sheetHint(c, "Green dots are APRS stations the radio (or APRS-IS) has heard, at their last reported position. Cyan diamonds are FM repeaters and violet diamonds DMR repeaters within your Nearby repeaters range. Amber pins are your channels that have a location (set one in the channel editor). The blue dot is you."));
        box.addView(Neo.sheetHint(c, "Drag to move, pinch or double-tap to zoom, tap a marker for details. The pills hide or show each kind; the buttons on the right zoom, return to your position and fit everything on screen."));
        box.addView(Neo.sheetHint(c, "Coverage: the violet pill shows where you have heard each repeater (Heard) and where your transmissions opened it (Key-ups). Turn on logging there; Help \u2192 Coverage maps explains it all."));
        box.addView(Neo.sheetHint(c, "Map tiles come from OpenStreetMap and are kept on the phone for 30 days, so places you have looked at still show without a connection."));
        Neo.showSheet(c, box);
    }
}
