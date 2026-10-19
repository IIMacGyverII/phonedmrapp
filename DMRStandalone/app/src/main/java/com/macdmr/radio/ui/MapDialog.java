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
    private final TextView[] pills = new TextView[4];
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
        String[] names = { "Stations", "Repeaters", "Channels", "Help" };
        int[] accents = { Neo.GREEN, Neo.CYAN, Neo.AMBER, Neo.VIOLET };
        for (int i = 0; i < 4; i++) {
            final int idx = i;
            TextView p = Neo.label(c, names[i], accents[i], 14, true); p.setGravity(Gravity.CENTER);
            p.setPadding((int) (14 * d), (int) (8 * d), (int) (14 * d), (int) (8 * d));
            Neo.pillStyle(p, i < 3, accents[i]);
            LinearLayout.LayoutParams pl = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT); pl.rightMargin = (int) (8 * d);
            pillRow.addView(p, pl); pills[i] = p;
            p.setOnClickListener(v -> {
                if (idx == 3) { help(); return; }
                boolean on;
                if (idx == 1) { on = !map.isVisible(MapView.REPEATER_FM); map.setVisible(MapView.REPEATER_FM, on); map.setVisible(MapView.REPEATER_DMR, on); }
                else { int kind = idx == 0 ? MapView.STATION : MapView.CHANNEL; on = !map.isVisible(kind); map.setVisible(kind, on); }
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
        dlg.setOnDismissListener(x -> map.shutdown());
        dlg.show();

        close.setOnClickListener(v -> dlg.dismiss());
        plus.setOnClickListener(v -> map.zoomBy(1));
        minus.setOnClickListener(v -> map.zoomBy(-1));
        locate.setOnClickListener(v -> { if (me != null) map.center(me.getLatitude(), me.getLongitude(), Math.max(map.zoom(), 11)); else Toast.makeText(c, "No position fix yet: turn on location", Toast.LENGTH_SHORT).show(); });
        fit.setOnClickListener(v -> fitVisible());
        map.setOnSelect(this::showCard);

        me = svc.lastKnownLocation();
        if (me != null) map.center(me.getLatitude(), me.getLongitude(), 10);
        load();
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
            if (me != null) ms.add(new MapView.Marker(me.getLatitude(), me.getLongitude(), MapView.ME, "You", null));
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
        pills[0].setText("Stations " + st); pills[1].setText(rp < 0 ? "Repeaters …" : "Repeaters " + rp); pills[2].setText("Channels " + ch);
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
            cardSub.setText((r.dmr ? "DMR" + (r.cc >= 0 ? " CC" + r.cc : "") : "FM" + (r.toneUp != null && !r.toneUp.isEmpty() ? " " + r.toneUp : "")) + " repeater · " + dist(r.lat, r.lon)); cardSub.setTextColor(col);
            cardBody.setText(String.format(Locale.US, "Output %.4f MHz, input %.4f MHz", r.rxHz / 1e6, r.txHz / 1e6) + (r.city != null ? "\n" + r.city + (r.region != null ? ", " + r.region : "") : "") + (r.approx ? "\nPosition is approximate" : ""));
            action("Details", "repeaters", col, v -> RepeatersDialog.showDetails(c, svc, r, me != null ? me.getLatitude() : r.lat, me != null ? me.getLongitude() : r.lon));
        } else if (m.data instanceof ChannelStore.Channel) {
            final ChannelStore.Channel x = (ChannelStore.Channel) m.data;
            cardTitle.setText(x.name); cardTitle.setTextColor(Neo.AMBER);
            cardSub.setText("Channel " + x.number + " · " + (x.isDigital() ? "DMR" : "Analog") + " · " + dist(x.lat, x.lon)); cardSub.setTextColor(Neo.AMBER);
            cardBody.setText(String.format(Locale.US, "RX %.4f MHz, TX %.4f MHz", x.rxFreq / 1e6, x.txFreq / 1e6));
            action("Use channel", "channels", Neo.AMBER, v -> { svc.selectChannel(x.number); Toast.makeText(c, "Channel " + x.number + ": " + x.name, Toast.LENGTH_SHORT).show(); });
        }
        action("Open in Maps", "map", Neo.CYAN, v -> { try { c.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(geo))); } catch (Throwable t) { Toast.makeText(c, "No maps app", Toast.LENGTH_SHORT).show(); } });
        card.setVisibility(View.VISIBLE);
    }

    private void action(String label, String icon, int accent, View.OnClickListener l) {
        TextView b = Neo.button(c, label, icon, accent); b.setTextSize(14);
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f);
        bl.setMargins(cardActions.getChildCount() == 0 ? 0 : (int) (4 * d), (int) (8 * d), cardActions.getChildCount() == 0 ? (int) (4 * d) : 0, 0);
        b.setOnClickListener(l); cardActions.addView(b, bl);
    }

    private void help() {
        LinearLayout box = Neo.sheetBody(c, "Map");
        box.addView(Neo.sheetHint(c, "Green dots are APRS stations the radio (or APRS-IS) has heard, at their last reported position. Cyan diamonds are FM repeaters and violet diamonds DMR repeaters within your Nearby repeaters range. Amber pins are your channels that have a location (set one in the channel editor). The blue dot is you."));
        box.addView(Neo.sheetHint(c, "Drag to move, pinch or double-tap to zoom, tap a marker for details. The pills hide or show each kind; the buttons on the right zoom, return to your position and fit everything on screen."));
        box.addView(Neo.sheetHint(c, "Map tiles come from OpenStreetMap and are kept on the phone for 30 days, so places you have looked at still show without a connection."));
        Neo.showSheet(c, box);
    }
}
