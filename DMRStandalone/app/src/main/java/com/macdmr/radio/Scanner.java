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
        boolean softGated();
        /** The scan priority channel, or null: looked at again after every {@link #PRIORITY_EVERY} other channels. */
        ChannelStore.Channel priority();                                 // Soft SQ decides: allow for its blackout + first detector window before stepping
        void status(boolean scanning, boolean holding, ChannelStore.Channel on);
    }

    static final long DWELL_MS = 1500, DWELL_SOFT_MS = 2000, HANG_MS = 2500, SETTLE_MS = 700, TICK_MS = 150;

    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Host host;
    private volatile boolean scanning, holding;
    private List<ChannelStore.Channel> list = new ArrayList<>();
    private int idx = -1;
    /** Visit the priority channel after this many other channels. */
    public static final int PRIORITY_EVERY = 3;
    private ChannelStore.Channel prio;        // fixed for this scan session
    private boolean onPriority;               // the radio is on the priority channel right now (a look-back, not list[idx])
    private int sincePriority;
    /** While holding on another channel, peek at the priority channel this often (a short gap in the held audio). */
    public static final long PRIORITY_PEEK_MS = 10_000;
    private long lastPeek;
    private boolean peeking;                  // on the priority channel only for a peek: go back to list[idx] if it is quiet
    private ChannelStore.Channel here() { return onPriority ? prio : (idx >= 0 && idx < list.size() ? list.get(idx) : null); }
    private long landedAt, lastActivityAt;
    private final java.util.Set<Integer> skipped = new java.util.HashSet<>();

    public Scanner(Host h) { host = h; }

    public boolean isScanning() { return scanning; }
    public boolean isHolding() { return holding; }

    public synchronized String start() {
        if (scanning) return "Already scanning";
        list = new ArrayList<>();
        for (ChannelStore.Channel ch : host.candidates()) if (!skipped.contains(ch.number) && !(ch.isDigital() && ch.txContact <= 0)) list.add(ch);
        if (list.size() < 2) return "Nothing to scan: need at least two channels in the zone";   // (counted before the priority channel is taken out)
        scanning = true; holding = false; idx = -1; landedAt = 0; lastActivityAt = 0;
        prio = host.priority(); onPriority = false; sincePriority = 0; peeking = false; lastPeek = 0;
        if (prio != null) for (int i = 0; i < list.size(); i++) if (list.get(i).number == prio.number) { list.remove(i); break; }   // visited by look-back, not twice
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
        if (onPriority) return "That is the priority channel: clear it in Channels to stop checking it";
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
            if ((idx >= 0 || onPriority) && now - landedAt > SETTLE_MS && rx) {              // activity on this channel: hold
                lastActivityAt = now;
                if (!holding) { holding = true; if (onPriority) peeking = false; host.status(true, true, here()); }
            }
            if (holding && !onPriority && prio != null && now - Math.max(lastPeek, landedAt) > PRIORITY_PEEK_MS) {   // busy channel: still look at the priority one
                lastPeek = now; peeking = true; onPriority = true; holding = false; lastActivityAt = 0;
                landedAt = now; host.tune(prio); host.status(true, false, prio);
            } else if (holding) {
                if (!rx && now - lastActivityAt > HANG_MS) { holding = false; step(); }
            } else if ((idx < 0 && !onPriority) || now - landedAt > (host.softGated() ? DWELL_SOFT_MS : DWELL_MS)) step();
            handler.postDelayed(this, TICK_MS);
        }
    };

    private void step() {
        if (list.isEmpty()) { stop(); return; }
        if (peeking) {                                      // priority quiet: back to the channel we were holding on
            peeking = false; onPriority = false;
            ChannelStore.Channel back = list.get(idx); landedAt = System.currentTimeMillis();
            host.tune(back); host.status(true, false, back);
            return;
        }
        if (prio != null && !onPriority && sincePriority >= PRIORITY_EVERY) {   // look back at the priority channel
            onPriority = true; sincePriority = 0;
            landedAt = System.currentTimeMillis();
            host.tune(prio); host.status(true, false, prio);
            return;
        }
        onPriority = false; sincePriority++;
        idx = (idx + 1) % list.size();
        ChannelStore.Channel ch = list.get(idx);
        landedAt = System.currentTimeMillis();
        host.tune(ch);
        host.status(true, false, ch);
    }
}
