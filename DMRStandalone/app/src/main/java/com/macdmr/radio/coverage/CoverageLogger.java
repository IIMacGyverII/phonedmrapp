package com.macdmr.radio.coverage;

import android.content.Context;
import android.content.SharedPreferences;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;

import com.macdmr.radio.ChannelStore;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Coverage logging, while it is switched on:
 * <ul>
 * <li><b>Repeater to phone.</b> On a channel that has a location, every reading of the signal while the repeater
 * is actually heard (digital: the radio reports a call with the channel's colour code; analog: the channel's
 * CTCSS tone is decoded, when it has one) is stored with a good GPS fix. At most one reading per 5 s unless you
 * moved 25 m.</li>
 * <li><b>Phone to repeater.</b> After each transmission of at least 0.6 s on a repeater channel (transmit and
 * receive frequencies differ) the signal is read five times in the next 1.8 s. If it rises
 * {@link CoverageMath#KEYUP_MARGIN_DB} above the channel's quiet floor, the repeater answered (its tail or hang
 * time): you keyed it from here. Otherwise it is stored as no reply.</li>
 * </ul>
 * The radio's signal reading works with the squelch closed, so the floor and the tail are measured the same way.
 */
public final class CoverageLogger {
    public interface Host {
        ChannelStore.Channel current();
        boolean ready();
        boolean hearing();
        boolean busyTx();
        boolean toneMatches(ChannelStore.Channel ch);
        void pollRssi();
        void event(String line);
    }

    private final Context ctx; private final Host host; private final CoverageStore store; private final SharedPreferences prefs;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private volatile boolean on;
    private volatile Location fix;
    private LocationListener listener;

    /** Quiet-channel readings per channel number, so a scan that keeps hopping still builds each channel's noise floor. */
    private final java.util.Map<Integer, List<Integer>> quiet = new java.util.HashMap<>();
    private long txStartAt;
    private volatile boolean probing; private final List<Integer> probe = new ArrayList<>();
    private long lastRxAt; private Location lastRxLoc; private String lastRxKey;
    private final Set<String> noted = new HashSet<>();
    private volatile int sessionRx, sessionTx;

    public CoverageLogger(Context c, Host h) {
        ctx = c.getApplicationContext(); host = h; store = new CoverageStore(ctx);
        prefs = ctx.getSharedPreferences("coverage", Context.MODE_PRIVATE);
    }

    public CoverageStore store() { return store; }
    public boolean enabled() { return prefs.getBoolean("log", false); }
    public boolean running() { return on; }
    public int sessionRx() { return sessionRx; }
    public int sessionTx() { return sessionTx; }
    public Location fix() { return fix; }

    public void setEnabled(boolean e) { prefs.edit().putBoolean("log", e).apply(); if (e) start(); else stop(); }

    /** Start if switched on (service start). */
    public void resume() { if (enabled()) start(); }

    public synchronized void start() {
        if (on) return;
        on = true;
        try {
            LocationManager lm = (LocationManager) ctx.getSystemService(Context.LOCATION_SERVICE);
            listener = l -> {                                       // GPS wins: a network fix only fills in when GPS has been quiet for 10 s
                Location cur = fix;
                if (cur != null && !LocationManager.GPS_PROVIDER.equals(l.getProvider()) && LocationManager.GPS_PROVIDER.equals(cur.getProvider())
                        && (l.getElapsedRealtimeNanos() - cur.getElapsedRealtimeNanos()) < 10_000_000_000L) return;
                fix = l;
            };
            lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 2000, 0, listener, Looper.getMainLooper());
            try { lm.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 5000, 0, listener, Looper.getMainLooper()); } catch (Throwable ignored) { }
            Location last = lm.getLastKnownLocation(LocationManager.GPS_PROVIDER); if (last != null) fix = last;
        } catch (SecurityException se) { host.event("📶 Coverage logging needs location permission"); }
        catch (Throwable ignored) { }
        ui.removeCallbacks(poll); ui.post(poll);
    }

    public synchronized void stop() {
        on = false; ui.removeCallbacks(poll);
        try { if (listener != null) ((LocationManager) ctx.getSystemService(Context.LOCATION_SERVICE)).removeUpdates(listener); } catch (Throwable ignored) { }
        listener = null;
    }

    private final Runnable poll = new Runnable() {
        @Override public void run() {
            if (!on) return;
            if (host.ready() && !host.busyTx() && !probing) host.pollRssi();
            ui.postDelayed(this, 2000);
        }
    };

    static boolean target(ChannelStore.Channel ch) { return ch != null && (ch.lat != 0 || ch.lon != 0); }
    static boolean repeaterChannel(ChannelStore.Channel ch) { return target(ch) && ch.txFreq != ch.rxFreq && ch.txFreq > 0; }

    private Location usableFix() {
        Location f = fix; if (f == null) return null;
        long age = (SystemClock.elapsedRealtimeNanos() - f.getElapsedRealtimeNanos()) / 1_000_000;
        return CoverageMath.fixUsable(f.hasAccuracy() ? f.getAccuracy() : 0, age) ? f : null;
    }

    private String key(ChannelStore.Channel ch) {
        String k = CoverageMath.repeaterKey(ch.rxFreq, ch.lat, ch.lon);
        if (noted.add(k)) store.noteRepeater(k, ch.name, ch.rxFreq, ch.txFreq, ch.lat, ch.lon);
        return k;
    }

    /** Every signal reading from the radio (dBm). */
    public void onRssi(int dbm) {
        if (!on || dbm == -999) return;
        if (probing) { synchronized (probe) { probe.add(dbm); } return; }
        if (host.busyTx()) return;
        ChannelStore.Channel ch = host.current(); if (ch == null) return;
        boolean continuous = target(ch) && CoverageMath.continuousStation(ch.rxFreq);
        if (!host.hearing() && !continuous) {
            synchronized (quiet) { List<Integer> q = quiet.get(ch.number); if (q == null) { q = new ArrayList<>(); quiet.put(ch.number, q); } q.add(dbm); while (q.size() > 15) q.remove(0); }
            return;
        }
        if (!target(ch) || (!continuous && !host.toneMatches(ch))) return;
        Location f = usableFix(); if (f == null) return;
        String k = key(ch); long now = System.currentTimeMillis();
        if (k.equals(lastRxKey) && now - lastRxAt < 5000 && lastRxLoc != null && lastRxLoc.distanceTo(f) < 25) return;
        lastRxKey = k; lastRxAt = now; lastRxLoc = f;
        store.addRx(k, f.getLatitude(), f.getLongitude(), f.getAccuracy(), dbm, now);
        sessionRx++;
    }

    public void onTxStart() { txStartAt = SystemClock.elapsedRealtime(); }

    /** The radio stopped transmitting: read the signal a few times to see whether the repeater answered. */
    public void onTxEnd() {
        if (!on || txStartAt == 0) return;
        long txMs = SystemClock.elapsedRealtime() - txStartAt; txStartAt = 0;
        final ChannelStore.Channel ch = host.current();
        if (!repeaterChannel(ch) || txMs < CoverageMath.MIN_TX_MS) return;
        final Location f = usableFix(); if (f == null) return;
        final int floor; synchronized (quiet) { floor = CoverageMath.floor(quiet.get(ch.number)); }
        synchronized (probe) { probe.clear(); }
        probing = true;
        for (long ms : CoverageMath.PROBE_MS) ui.postDelayed(host::pollRssi, ms);
        final long len = txMs;
        ui.postDelayed(() -> {
            List<Integer> got; synchronized (probe) { got = new ArrayList<>(probe); }
            probing = false;
            int res = CoverageMath.judgeKeyup(got, floor);
            int best = -999; for (int v : got) best = Math.max(best, v);
            String k = key(ch);
            store.addTx(k, f.getLatitude(), f.getLongitude(), f.getAccuracy(), ch.power, len, res, best, floor, System.currentTimeMillis());
            sessionTx++;
            if (res == CoverageMath.KEYED) host.event("📶 Keyed " + ch.name + " from here (tail " + best + " dBm, " + CoverageMath.sUnits(best) + ")");
            else if (res == CoverageMath.NO_REPLY) host.event("📶 No reply from " + ch.name + " after your transmission");
        }, CoverageMath.PROBE_MS[CoverageMath.PROBE_MS.length - 1] + 300);
    }
}
