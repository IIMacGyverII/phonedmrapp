package com.macdmr.radio;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.util.Log;

import com.macdmr.radio.ham.NetFinder;
import com.macdmr.radio.repeaters.GeoUtil;
import com.macdmr.radio.repeaters.RepeaterModels.Repeater;
import com.macdmr.radio.repeaters.RepeaterService;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

/**
 * Nets near you: NetLogger's nets in session and last week's (matched to your channels and Nearby repeaters), plus
 * the nets the radio has heard (see {@link NetFinder}), and the optional reminders. NetLogger asks for at most one
 * GetActiveNets a minute and three GetCheckins a minute; both are cached here for that long, and the week of past
 * nets for 12 hours. Check-ins (which carry home addresses) are never stored: only callsign, name and state are read.
 */
public final class NetWatch {
    private static final String TAG = "NetWatch", API = "https://www.netlogger.org/api/";
    private final Context ctx; private final RadioService svc; private final SharedPreferences prefs;

    public NetWatch(RadioService svc) { this.svc = svc; ctx = svc.getApplicationContext(); prefs = ctx.getSharedPreferences("nets", Context.MODE_PRIVATE); }

    public boolean remind() { return prefs.getBoolean("remind", false); }
    public void setRemind(boolean on) { prefs.edit().putBoolean("remind", on).apply(); }
    public boolean liveAlerts() { return prefs.getBoolean("liveAlerts", false); }
    public void setLiveAlerts(boolean on) { prefs.edit().putBoolean("liveAlerts", on).apply(); }

    // ---- NetLogger ----

    private String activeXml; private long activeAt; private String activeError;
    public synchronized List<NetFinder.Net> active() {
        long now = System.currentTimeMillis();
        if (activeXml == null || now - activeAt >= 60_000) {
            try { activeXml = get(API + "GetActiveNets.php"); activeError = null; }
            catch (Exception e) { activeError = e.getMessage(); if (activeXml == null) return new ArrayList<>(); }
            activeAt = now;
        }
        return NetFinder.parseNets(activeXml);
    }
    public String activeError() { return activeError; }

    private List<NetFinder.Net> past() {
        File f = new File(ctx.getCacheDir(), "netlogger_past.xml");
        String xml = null;
        try {
            if (f.exists() && System.currentTimeMillis() - f.lastModified() < 12 * 3_600_000L) xml = new String(Files.readAllBytes(f.toPath()), StandardCharsets.ISO_8859_1);
            else { xml = get(API + "GetPastNets.php?Interval=7"); try (FileOutputStream o = new FileOutputStream(f)) { o.write(xml.replaceAll("<srcIP>[^<]*</srcIP>", "").getBytes(StandardCharsets.ISO_8859_1)); } }   // never keep the loggers' IP addresses
        } catch (Exception e) {
            Log.w(TAG, "past nets: " + e.getMessage());
            try { if (xml == null && f.exists()) xml = new String(Files.readAllBytes(f.toPath()), StandardCharsets.ISO_8859_1); } catch (Exception ignored) { }
        }
        return NetFinder.parseNets(xml);
    }

    private final Map<String, String> checkinXml = new HashMap<>(); private final Map<String, Long> checkinAt = new HashMap<>();
    /** The check-ins of a net in session (cached 20 s, so at most three requests a minute per net). */
    public synchronized List<NetFinder.Checkin> checkins(NetFinder.Net n, int[] pointer) throws Exception {
        String k = n.server + "|" + n.apiName; long now = System.currentTimeMillis();
        Long at = checkinAt.get(k);
        if (at == null || now - at >= 20_000) {
            checkinXml.put(k, get(API + "GetCheckins.php?ServerName=" + URLEncoder.encode(n.server, "UTF-8") + "&NetName=" + URLEncoder.encode(n.apiName, "UTF-8")));
            checkinAt.put(k, now);
        }
        String x = checkinXml.get(k);
        if (pointer != null && pointer.length > 0) pointer[0] = NetFinder.pointer(x);
        return NetFinder.parseCheckins(x);
    }

    private static String get(String url) throws Exception {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        c.setConnectTimeout(12_000); c.setReadTimeout(20_000); c.setRequestProperty("User-Agent", "SignalDeck/1.0 (Android)");
        try {
            int code = c.getResponseCode();
            if (code == 429) throw new Exception("NetLogger is busy (too many requests); try again in a minute");
            if (code != 200) throw new Exception("NetLogger answered HTTP " + code);
            try (InputStream in = c.getInputStream()) { ByteArrayOutputStream b = new ByteArrayOutputStream(); byte[] buf = new byte[16384]; int r; while ((r = in.read(buf)) > 0) b.write(buf, 0, r); return b.toString("ISO-8859-1"); }
        } finally { c.disconnect(); }
    }

    // ---- your channels and nearby repeaters ----

    private List<NetFinder.Place> places; private long placesAt;
    public synchronized List<NetFinder.Place> places() {
        long now = System.currentTimeMillis();
        if (places != null && now - placesAt < 30 * 60_000L) return places;
        List<NetFinder.Place> out = new ArrayList<>();
        for (ChannelStore.Channel ch : svc.store().all()) {
            NetFinder.Place p = new NetFinder.Place();
            p.label = "ch " + ch.number + " " + ch.name; p.rxHz = ch.rxFreq; p.txHz = ch.txFreq; p.channel = ch.number; p.data = ch;
            if (ch.isDigital()) { if (ch.txContact > 0) p.talkgroups.add(ch.txContact); for (int g : ch.groups) if (g > 0) p.talkgroups.add(g); }
            out.add(p);
        }
        android.location.Location me = svc.lastKnownLocation();
        if (me != null) {
            try {
                double mi = ctx.getSharedPreferences("repeaters", Context.MODE_PRIVATE).getInt("radiusMi", 30);
                for (Repeater r : new RepeaterService(ctx, svc.store()).nearby(me.getLatitude(), me.getLongitude(), mi * 1.609344, false, new StringBuilder())) {
                    NetFinder.Place p = new NetFinder.Place();
                    p.label = (r.callsign == null ? "Repeater" : r.callsign) + " repeater"; p.rxHz = r.rxHz; p.txHz = r.txHz; p.data = r;
                    if (r.hasCoords) p.km = GeoUtil.haversineMeters(me.getLatitude(), me.getLongitude(), r.lat, r.lon) / 1000.0;
                    out.add(p);
                }
            } catch (Throwable t) { Log.w(TAG, "repeaters: " + t); }
        }
        places = out; placesAt = now;
        return out;
    }
    public synchronized void placesChanged() { places = null; schedule = null; }

    /** Your state (Geocoder, cached a day) and call district (from it, or the most common among nearby repeaters' callsigns). */
    private String myState; private int myDistrict = -1; private long whereAt;
    private synchronized void where() {
        long now = System.currentTimeMillis();
        if (now - whereAt < 6 * 3_600_000L) return;
        whereAt = now;
        android.location.Location me = svc.lastKnownLocation();
        String st = prefs.getString("myState", null);
        if (me != null && (st == null || now - prefs.getLong("myStateAt", 0) > 86_400_000L)) {
            try {
                List<android.location.Address> a = new android.location.Geocoder(ctx, Locale.US).getFromLocation(me.getLatitude(), me.getLongitude(), 1);
                String code = a == null || a.isEmpty() ? null : NetFinder.stateCode(a.get(0).getAdminArea());
                if (code != null) { st = code; prefs.edit().putString("myState", code).putLong("myStateAt", now).apply(); }
            } catch (Throwable t) { Log.w(TAG, "geocoder: " + t); }
        }
        myState = st;
        myDistrict = NetFinder.districtOf(st);
        if (myDistrict < 0) {
            int[] n = new int[10];
            for (NetFinder.Place p : places()) if (p.data instanceof Repeater) { int dd = NetFinder.callDistrict(((Repeater) p.data).callsign); if (dd >= 0) n[dd]++; }
            int best = -1; for (int i = 0; i < 10; i++) if (n[i] > 0 && (best < 0 || n[i] > n[best])) best = i;
            myDistrict = best;
        }
    }
    /**
     * 1 near, 0 can't tell, -1 probably elsewhere: your own answer for this net first, then the matched repeater (its
     * callsign is net control's or the logger's, or its city is in the net's name), then {@link NetFinder#locality}.
     */
    private int locality(NetFinder.Net n, NetFinder.Place p) {
        String k = key(n.name);
        if (prefs.getStringSet("near", new HashSet<>()).contains(k)) return 1;
        if (prefs.getStringSet("far", new HashSet<>()).contains(k)) return -1;
        if (p != null && p.data instanceof Repeater && n.freqHz > 0) {
            Repeater r = (Repeater) p.data;
            String rc = base(r.callsign), nc = base(n.netControl), lc = base(NetFinder.loggerCall(n.logger));
            if (!rc.isEmpty() && (rc.equals(nc) || rc.equals(lc))) return 1;
            if (r.city != null && r.city.trim().length() >= 4 && n.name.toLowerCase(Locale.US).contains(r.city.trim().toLowerCase(Locale.US))) return 1;
        }
        where();
        return NetFinder.locality(n, myState, myDistrict);
    }
    /** In the main lists (and reminded): near you, or on one of your own channels unless it points elsewhere. A nearby repeater's frequency alone is not enough. */
    static boolean shown(int near, int channel) { return near > 0 || (near == 0 && channel > 0); }
    private static String base(String call) { if (call == null) return ""; String c = call.trim().toUpperCase(Locale.US); int i = c.indexOf('/'); if (i > 0) c = c.substring(0, i); i = c.indexOf('-'); if (i > 0) c = c.substring(0, i); return c; }
    private static String key(String name) { return name == null ? "" : name.toLowerCase(Locale.US).replaceAll("[^a-z0-9]+", " ").trim(); }
    /** The owner's answer for a net: 1 near me, -1 not near me, 0 forget the answer. */
    public synchronized void setNear(String name, int v) {
        String k = key(name);
        Set<String> near = new HashSet<>(prefs.getStringSet("near", new HashSet<>())), far = new HashSet<>(prefs.getStringSet("far", new HashSet<>()));
        near.remove(k); far.remove(k); if (v > 0) near.add(k); else if (v < 0) far.add(k);
        prefs.edit().putStringSet("near", near).putStringSet("far", far).apply();
        schedule = null;
    }

    /** History without receive-only channels (weather, marine): a broadcast is not a net. */
    private List<NetFinder.Rx> rows(long since) {
        List<NetFinder.Rx> out = new ArrayList<>(); Map<Integer, Boolean> ro = new HashMap<>();
        for (NetFinder.Rx r : svc.store().netRows(since)) {
            Boolean b = ro.get(r.channel);
            if (b == null) { ChannelStore.Channel ch = svc.store().byNumber(r.channel); b = ch == null || ChannelStore.receiveOnly(ch.txFreq); ro.put(r.channel, b); }
            if (!b) out.add(r);
        }
        return out;
    }

    // ---- what the Nets page shows ----

    public static final class Found { public NetFinder.Net net; public NetFinder.Place place; public int near; }
    public static final class Snapshot {
        public final List<Found> yours = new ArrayList<>();          // in session on your channels / nearby repeaters
        public final List<NetFinder.Net> elsewhere = new ArrayList<>();   // in session on 2 m / 70 cm / DMR, not near you
        public final List<Found> maybe = new ArrayList<>();          // on one of your frequencies, but probably in another area
        public int total; public String error;
        public NetFinder.Session heard; public String heardLabel = "";
        public List<NetFinder.Slot> schedule = new ArrayList<>();
        public List<NetFinder.Slot> unsure = new ArrayList<>();      // on a nearby repeater's frequency, place unknown
    }

    public Snapshot snapshot() {
        Snapshot s = new Snapshot();
        List<NetFinder.Place> ps = places();
        List<NetFinder.Net> act = active(); s.error = activeError(); s.total = act.size();
        for (NetFinder.Net n : act) {
            NetFinder.Place p = NetFinder.match(n, ps);
            if (p != null) { Found f = new Found(); f.net = n; f.place = p; f.near = locality(n, p); (shown(f.near, p.channel) ? s.yours : s.maybe).add(f); }
            else if (n.freqHz > 0 || n.talkgroup > 0) s.elsewhere.add(n);
        }
        s.heard = NetFinder.live(rows(System.currentTimeMillis() - 3 * 3_600_000L), System.currentTimeMillis());
        if (s.heard != null) { ChannelStore.Channel ch = svc.store().byNumber(s.heard.channel); s.heardLabel = "ch " + s.heard.channel + (ch == null ? "" : " " + ch.name); }
        s.yours.sort((x, y) -> y.near - x.near);           // confirmed near you first
        for (NetFinder.Slot sl : schedule()) (shown(sl.near, sl.channel) ? s.schedule : s.unsure).add(sl);
        return s;
    }

    // ---- nets the owner added to a channel ----
    public static List<NetFinder.Manual> manual(Context c) { return NetFinder.decode(c.getSharedPreferences("nets", Context.MODE_PRIVATE).getString("manual", "")); }
    /** Add or replace (same id) a net; id 0 gets a new one. */
    public static void saveManual(Context c, NetFinder.Manual m) {
        List<NetFinder.Manual> l = manual(c);
        if (m.id == 0) m.id = System.currentTimeMillis();
        boolean replaced = false; for (int i = 0; i < l.size(); i++) if (l.get(i).id == m.id) { l.set(i, m); replaced = true; }
        if (!replaced) l.add(m);
        store(c, l);
    }
    public static void deleteManual(Context c, long id) { List<NetFinder.Manual> l = manual(c); l.removeIf(x -> x.id == id); store(c, l); }
    private static void store(Context c, List<NetFinder.Manual> l) {
        c.getSharedPreferences("nets", Context.MODE_PRIVATE).edit().putString("manual", NetFinder.encode(l)).apply();
        RadioService s = RadioService.running; if (s != null) s.netWatch().placesChanged();
    }
    public static List<NetFinder.Manual> manualOn(Context c, int channel) { List<NetFinder.Manual> out = new ArrayList<>(); for (NetFinder.Manual m : manual(c)) if (m.channel == channel) out.add(m); return out; }

    private List<NetFinder.Slot> schedule; private long scheduleAt;
    /** Learned and NetLogger slots, merged, soonest first. */
    public synchronized List<NetFinder.Slot> schedule() {
        long now = System.currentTimeMillis();
        if (schedule != null && now - scheduleAt < 30 * 60_000L) return sorted(schedule, now);
        List<NetFinder.Place> ps = places();
        TimeZone tz = TimeZone.getDefault();
        List<NetFinder.Slot> out = new ArrayList<>(), mine = NetFinder.manualSlots(manual(ctx));
        for (NetFinder.Slot sl : mine) for (NetFinder.Place p : ps) if (p.channel == sl.channel) sl.place = p;
        out.addAll(mine);
        for (NetFinder.Slot sl : NetFinder.scheduleFromPast(past(), tz)) {
            NetFinder.Net probe = new NetFinder.Net(); probe.freqHz = sl.freqHz; probe.talkgroup = sl.talkgroup; probe.name = sl.name; probe.netControl = sl.netControl; probe.logger = sl.logger;
            NetFinder.Place p = NetFinder.match(probe, ps);
            if (p == null) continue;
            sl.near = locality(probe, p); if (sl.near < 0) continue;
            boolean dup = false; for (NetFinder.Slot m : mine) if (NetFinder.sameNet(m, sl)) { m.source = "added by you · on NetLogger"; dup = true; }
            if (dup) continue;
            sl.place = p; sl.channel = p.channel; out.add(sl);
        }
        for (NetFinder.Slot sl : NetFinder.learned(NetFinder.sessions(rows(now - 8 * 7 * 86_400_000L)), tz)) {
            NetFinder.Slot same = null;
            for (NetFinder.Slot o : out) if (NetFinder.sameNet(o, sl)) same = o;
            if (same != null) { same.source = same.source + " · heard " + sl.seen + "×"; same.stations = sl.stations; same.near = 1; continue; }
            ChannelStore.Channel ch = svc.store().byNumber(sl.channel);
            for (NetFinder.Place p : ps) if (p.channel == sl.channel) sl.place = p;
            if (sl.name.isEmpty()) sl.name = (sl.dow == 0 ? "Daily activity" : "Weekly net") + " on " + (ch == null ? "ch " + sl.channel : ch.name);
            sl.source = "heard " + sl.seen + "×"; sl.near = 1;
            out.add(sl);
        }
        schedule = out; scheduleAt = now;
        return sorted(out, now);
    }
    private static List<NetFinder.Slot> sorted(List<NetFinder.Slot> l, long now) {
        List<NetFinder.Slot> s = new ArrayList<>(l); TimeZone tz = TimeZone.getDefault();
        s.sort((a, b) -> Long.compare(NetFinder.next(a, now, tz), NetFinder.next(b, now, tz)));
        return s;
    }

    // ---- reminders (a background minute tick while either option is on) ----

    private Thread ticker; private volatile boolean running;
    public synchronized void start() {
        if (ticker != null) return;
        running = true;
        ticker = new Thread(() -> {
            long lastLive = 0;
            while (running) {
                try { Thread.sleep(60_000); } catch (InterruptedException e) { break; }
                try {
                    long now = System.currentTimeMillis();
                    if (remind()) remindDue(now);
                    if (liveAlerts() && now - lastLive >= 5 * 60_000L) { lastLive = now; alertLive(); }
                } catch (Throwable t) { Log.w(TAG, "tick: " + t); }
            }
        }, "net-watch");
        ticker.setDaemon(true); ticker.start();
    }
    public synchronized void stop() { running = false; if (ticker != null) ticker.interrupt(); ticker = null; }

    private void remindDue(long now) {
        Set<String> done = new HashSet<>(prefs.getStringSet("reminded", new HashSet<>()));
        boolean changed = false;
        for (NetFinder.Slot sl : schedule()) {
            long at = NetFinder.next(sl, now, TimeZone.getDefault());
            if (at <= now || at - now > 10 * 60_000L || !shown(sl.near, sl.channel)) continue;
            String k = sl.key() + "@" + at;
            if (!done.add(k)) continue; changed = true;
            notify("Net in " + Math.max(1, (at - now + 30_000) / 60_000) + " min: " + sl.name, NetFinder.when(sl) + " · " + (sl.place != null ? sl.place.label : "") + " · tap for the Nets page", k.hashCode());
        }
        if (changed) { if (done.size() > 200) done.clear(); prefs.edit().putStringSet("reminded", done).apply(); }
    }

    private void alertLive() {
        Set<String> done = new HashSet<>(prefs.getStringSet("alerted", new HashSet<>()));
        boolean changed = false;
        for (NetFinder.Net n : active()) {
            NetFinder.Place p = NetFinder.match(n, places());
            if (p == null || !shown(locality(n, p), p.channel)) continue;
            String k = n.server + "|" + n.apiName + "|" + n.opened;
            if (!done.add(k)) continue; changed = true;
            notify("Net on the air: " + n.name, NetFinder.where(n) + " · " + p.label + (n.netControl.isEmpty() ? "" : " · net control " + n.netControl), k.hashCode());
        }
        if (changed) { if (done.size() > 200) done.clear(); prefs.edit().putStringSet("alerted", done).apply(); }
    }

    private void notify(String title, String text, int id) {
        try {
            NotificationManager nm = (NotificationManager) ctx.getSystemService(Context.NOTIFICATION_SERVICE); if (nm == null) return;
            if (Build.VERSION.SDK_INT >= 26) nm.createNotificationChannel(new NotificationChannel("nets", "Nets", NotificationManager.IMPORTANCE_DEFAULT));
            Notification.Builder b = Build.VERSION.SDK_INT >= 26 ? new Notification.Builder(ctx, "nets") : new Notification.Builder(ctx);
            Intent open = new Intent(ctx, MainActivity.class).putExtra(MainActivity.EXTRA_NETS, true).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
            b.setSmallIcon(android.R.drawable.ic_popup_reminder).setContentTitle(title).setContentText(text).setStyle(new Notification.BigTextStyle().bigText(text)).setAutoCancel(true)
                    .setContentIntent(PendingIntent.getActivity(ctx, 7, open, PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT));
            nm.notify(5000 + (id & 0xFFF), b.build());
            svc.history("pkt", "📋 " + title);
        } catch (Throwable t) { Log.w(TAG, "notify: " + t); }
    }

    /** "in 12 min", "now", "Tue 7:30 PM". */
    public static String relative(NetFinder.Slot s, long now) {
        long at = NetFinder.next(s, now, TimeZone.getDefault());
        if (at <= now) return "on now";
        long m = (at - now) / 60_000;
        if (m < 60) return "in " + Math.max(1, m) + " min";
        if (m < 24 * 60) return "in " + (m / 60) + " h " + (m % 60) + " min";
        long days = Math.round(m / 1440.0); return days <= 1 ? "tomorrow" : "in " + days + " days";
    }
}
