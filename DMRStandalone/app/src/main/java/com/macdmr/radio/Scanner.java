package com.macdmr.radio;

import android.os.Handler;
import android.os.Looper;

import java.util.ArrayList;
import java.util.List;

/**
 * Channel scanner (same behaviour as the module's): step through the candidate channels, dwell
 * {@link #DWELL_MS} on each, stop while there is activity (the radio's reception report, or the soft squelch gate
 * when Soft SQ is on, since the module's squelch is then held open) and for {@link #HANG_MS} after it ends, then continue. Skips digital channels without a call target (the MCU refuses them) and
 * anything the user excluded. Runs on the main looper; channel writes go through the service worker.
 */
public final class Scanner {
    public interface Host {
        List<ChannelStore.Channel> candidates();            // in scan order
        void tune(ChannelStore.Channel ch);
        boolean receiving();                                 // activity on the current channel (module squelch, or the soft gate when Soft SQ is on)
        boolean softGated();                                 // Soft SQ decides: allow for its blackout + first detector window before stepping
        void status(boolean scanning, boolean holding, ChannelStore.Channel on);
    }

    static final long DWELL_MS = 1500, DWELL_SOFT_MS = 1800, HANG_MS = 2500, SETTLE_MS = 700, TICK_MS = 150;

    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Host host;
    private volatile boolean scanning, holding;
    private List<ChannelStore.Channel> list = new ArrayList<>();
    private int idx = -1;
    private long landedAt, lastActivityAt;
    private final java.util.Set<Integer> skipped = new java.util.HashSet<>();

    public Scanner(Host h) { host = h; }

    public boolean isScanning() { return scanning; }
    public boolean isHolding() { return holding; }

    public synchronized String start() {
        if (scanning) return "Already scanning";
        list = new ArrayList<>();
        for (ChannelStore.Channel ch : host.candidates()) if (!skipped.contains(ch.number) && !(ch.isDigital() && ch.txContact <= 0)) list.add(ch);
        if (list.size() < 2) return "Nothing to scan: need at least two channels in the zone";
        scanning = true; holding = false; idx = -1; landedAt = 0; lastActivityAt = 0;
        handler.removeCallbacks(tick); handler.post(tick);
        return null;
    }

    public synchronized void stop() {
        if (!scanning) return;
        scanning = false; holding = false;
        handler.removeCallbacks(tick);
        host.status(false, false, null);
    }

    /** Long-press while stopped on a channel: drop it from this scan session. */
    public synchronized String skipCurrent() {
        if (!scanning) return "Not scanning";
        if (!holding || idx < 0) return "Long-press while the scanner is stopped on a channel to skip it";
        ChannelStore.Channel ch = list.get(idx);
        skipped.add(ch.number); holding = false; lastActivityAt = 0;
        list.remove(idx); idx = Math.max(-1, idx - 1);
        if (list.size() < 2) { stop(); return "Skipped - nothing left to scan"; }
        handler.removeCallbacks(tick); handler.post(tick);
        return "Skipping Ch " + ch.number + " for this scan";
    }

    public void clearSkips() { skipped.clear(); }

    private final Runnable tick = new Runnable() {
        @Override public void run() {
            if (!scanning) return;
            long now = System.currentTimeMillis();
            boolean rx = host.receiving();
            if (idx >= 0 && now - landedAt > SETTLE_MS && rx) {              // activity on this channel: hold
                lastActivityAt = now;
                if (!holding) { holding = true; host.status(true, true, list.get(idx)); }
            }
            if (holding) {
                if (!rx && now - lastActivityAt > HANG_MS) { holding = false; step(); }
            } else if (idx < 0 || now - landedAt > (host.softGated() ? DWELL_SOFT_MS : DWELL_MS)) step();
            handler.postDelayed(this, TICK_MS);
        }
    };

    private void step() {
        if (list.isEmpty()) { stop(); return; }
        idx = (idx + 1) % list.size();
        ChannelStore.Channel ch = list.get(idx);
        landedAt = System.currentTimeMillis();
        host.tune(ch);
        host.status(true, false, ch);
    }
}
