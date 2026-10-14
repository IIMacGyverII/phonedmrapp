package com.dmrmod.hooks;

import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;

import java.util.HashSet;
import java.util.List;
import java.util.Set;


import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * Channel scanner (backlog: new feature, 2026-10-14).
 *
 * The OEM app has no scan function. This drives the OEM's own channel-change path
 * ({@code InterPhoneTalkBackFragment.updateChannelId(boolean)}) so the database active
 * flag, the channel-number display and the MCU image stay consistent with a manual
 * +/- press. Each step costs ~0.6 s of MCU reprogramming plus {@link #DWELL_MS} of
 * listening; activity is the MCU's own squelch decision (RECEIVE_START pushes, read via
 * {@link Env#isReceiving()}), so Soft SQ must be off while scanning.
 *
 * Zone-aware: when a zone is selected only its channels are visited. Long-pressing the
 * scan button while the scanner is holding on a channel skips that channel for the rest
 * of the session (nuisance delete).
 *
 * Everything runs on the main looper except {@link #stop(String)}, which may be called
 * from the UART dispatcher thread (PTT / app relaunch).
 */
public final class ChannelScanner {
    private static final String TAG = "DMRModHooks";

    /**
     * Listening window after the MCU acknowledged the new channel. The ack comes back within
     * ~100 ms of the write but the RF path needs up to ~1 s before the squelch can open
     * (2026-10-14 device run: a 0.7 s window stepped straight past a full-scale NOAA carrier).
     */
    static final long DWELL_MS = 1500;
    /** A channel whose SET_*_INFO write fails this many times in a row is skipped for the session. */
    static final int MAX_STEP_FAILURES = 2;
    /** How long to stay on a channel after its activity ends before scanning resumes. */
    static final long HANG_MS = 2500;
    /** Give up waiting for the SET_*_INFO ack after this long and move on. */
    static final long STEP_TIMEOUT_MS = 3000;
    static final long TICK_MS = 150;

    public interface Env {
        /** Mirror of MainHook.isReceiving (RECEIVE_START .. RECEIVE_STOP). */
        boolean isReceiving();
        /** Selected zone's channel {@code _id}s, or null/empty for all channels. */
        java.util.Collection<Integer> zoneChannelIds();
        /** UI callback, always on the main thread. */
        void onStatus(boolean scanning, String label);
        /** Short user-facing notice (toast), always on the main thread. */
        void onNotice(String text);
    }

    private static volatile boolean scanning = false;
    /** True only for the synchronous duration of a scanner-initiated updateChannelId() call. */
    static volatile boolean stepping = false;

    private static Object fragment;
    private static ClassLoader classLoader;
    private static Env env;

    private static final Handler handler = new Handler(Looper.getMainLooper());
    private static int pendingTarget = -1;
    /** Index the radio was on when the pending step was issued, and the index we preset for the OEM. */
    private static int stepFrom = -1;
    private static int stepPreset = -1;
    private static long stepSentAt = 0;
    private static long landedAt = 0;
    private static long lastActivityAt = 0;
    private static boolean holding = false;
    private static int holdIndex = -1;
    /** uptimeMillis of the last RECEIVE_START push (set from MainHook's status hook). */
    private static volatile long lastReceiveStartAt = 0;
    private static final Set<Integer> skippedIds = new HashSet<>();
    /** Consecutive un-acknowledged steps per channel index (the OEM retries once, then NAKs). */
    private static final java.util.Map<Integer, Integer> stepFailures = new java.util.HashMap<>();

    private ChannelScanner() { }

    public static boolean isScanning() {
        return scanning;
    }

    public static boolean isHolding() {
        return scanning && holding;
    }

    public static int skippedCount() {
        return skippedIds.size();
    }

    /** Called from the ModuleStatusMessageHandler hook on every RECEIVE_START (any thread). */
    public static void onReceiveStart() {
        lastReceiveStartAt = SystemClock.uptimeMillis();
    }

    /** @return null when started, otherwise the reason it could not start (already toast-ready). */
    public static synchronized String start(Object talkBackFragment, ClassLoader loader, Env e) {
        if (scanning) {
            return "Already scanning";
        }
        if (talkBackFragment == null || loader == null || e == null) {
            return "Intercom not ready";
        }
        try {
            List<?> channels = (List<?>) XposedHelpers.getObjectField(talkBackFragment, "channels");
            if (channels == null || channels.size() < 2) {
                return "Need at least two channels to scan";
            }
            int idx = XposedHelpers.getIntField(talkBackFragment, "mCurrentChannelIndex");
            fragment = talkBackFragment;
            classLoader = loader;
            env = e;
            pendingTarget = -1;
            holding = false;
            holdIndex = -1;
            lastActivityAt = 0;
            stepFailures.clear();
            landedAt = SystemClock.uptimeMillis();   // give the current channel one dwell first
            if (e.isReceiving()) {
                lastReceiveStartAt = landedAt;       // already busy: hold here first
            }
            scanning = true;
            int candidates = countCandidates(channels, idx);
            XposedBridge.log(TAG + ": Scan started from index " + idx + " (" + candidates
                + " other channel(s) in scope, " + skippedIds.size() + " skipped)");
            if (candidates == 0) {
                scanning = false;
                return "No other channels in this zone to scan";
            }
            postStatus(true, "⏹ SCAN");
            handler.removeCallbacks(tick);
            handler.postDelayed(tick, TICK_MS);
            return null;
        } catch (Throwable t) {
            scanning = false;
            XposedBridge.log(TAG + ": Scan start failed: " + t.getMessage());
            return "Scan failed to start";
        }
    }

    /** Stops scanning and stays on whatever channel the radio is on. Safe from any thread. */
    public static synchronized void stop(String why) {
        if (!scanning) {
            return;
        }
        scanning = false;
        holding = false;
        pendingTarget = -1;
        handler.removeCallbacks(tick);
        XposedBridge.log(TAG + ": Scan stopped (" + why + ")");
        postStatus(false, "🔍 SCAN");
    }

    /** Pitfall 14: statics survive an Activity re-create. */
    public static void reset() {
        stop("app relaunch");
        skippedIds.clear();
        fragment = null;
        env = null;
    }

    /**
     * Nuisance delete: while holding on an active channel, drop it from this scan session
     * and resume immediately.
     * @return a short toast text describing what happened
     */
    public static synchronized String skipCurrent() {
        if (!scanning) {
            return "Not scanning";
        }
        if (!holding) {
            return "Long-press while the scanner is stopped on a channel to skip it";
        }
        try {
            List<?> channels = (List<?>) XposedHelpers.getObjectField(fragment, "channels");
            int idx = XposedHelpers.getIntField(fragment, "mCurrentChannelIndex");
            Object ch = channels.get(idx);
            int id = XposedHelpers.getIntField(ch, "_id");
            skippedIds.add(id);
            holding = false;
            lastActivityAt = 0;
            landedAt = 0;
            XposedBridge.log(TAG + ": Scan skipping channel " + displayNumber(ch) + " (_id " + id + ") for this session");
            if (countCandidates(channels, idx) == 0) {
                stop("every other channel is skipped");
                return "Skipped - nothing left to scan";
            }
            handler.removeCallbacks(tick);
            handler.post(tick);
            return "Skipping Ch " + displayNumber(ch) + " for this scan";
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Scan skip failed: " + t.getMessage());
            return "Skip failed";
        }
    }

    private static final Runnable tick = new Runnable() {
        @Override
        public void run() {
            if (!scanning) {
                return;
            }
            try {
                long now = SystemClock.uptimeMillis();
                int idx = XposedHelpers.getIntField(fragment, "mCurrentChannelIndex");
                List<?> channels = (List<?>) XposedHelpers.getObjectField(fragment, "channels");

                if (pendingTarget >= 0) {
                    if (idx == pendingTarget) {
                        stepFailures.remove(pendingTarget);
                        // The OEM ack handler cleared active on channels[preset]; when the preset was not
                        // the channel we actually came from (wrap-around or a skipped channel in between),
                        // clear the real previous channel too, or the DB keeps two active=1 rows.
                        if (stepFrom >= 0 && stepFrom != stepPreset && stepFrom != idx) {
                            clearActive(channels, stepFrom);
                        }
                        pendingTarget = -1;
                        stepFrom = -1;
                        stepPreset = -1;
                        landedAt = now;
                        postStatus(true, "⏹ " + displayNumber(channels.get(idx)));
                    } else if (now - stepSentAt > STEP_TIMEOUT_MS) {
                        int failed = pendingTarget;
                        Integer strikes = stepFailures.get(failed);
                        int n = (strikes == null ? 0 : strikes) + 1;
                        stepFailures.put(failed, n);
                        XposedBridge.log(TAG + ": Scan step to index " + failed + " not acknowledged in "
                            + STEP_TIMEOUT_MS + " ms (now at " + idx + "), strike " + n);
                        // The OEM only moves mCurrentChannelIndex on a successful ack, so after a NAK the
                        // fragment is still sitting on our preset while the radio never left stepFrom.
                        if (stepFrom >= 0 && idx == stepPreset && idx != stepFrom) {
                            XposedHelpers.setIntField(fragment, "mCurrentChannelIndex", stepFrom);
                            idx = stepFrom;
                        }
                        if (n >= MAX_STEP_FAILURES) {
                            Object bad = channels.get(failed);
                            int badId = XposedHelpers.getIntField(bad, "_id");
                            skippedIds.add(badId);
                            String badName = String.valueOf(XposedHelpers.getObjectField(bad, "name"));
                            XposedBridge.log(TAG + ": Scan: the radio rejected Ch " + displayNumber(bad) + " '" + badName
                                + "' " + n + " times (SET_*_INFO error) - skipping it for this session");
                            postNotice("Radio rejected Ch " + displayNumber(bad) + " (" + badName + ") - skipped");
                        }
                        pendingTarget = -1;
                        stepFrom = -1;
                        stepPreset = -1;
                        landedAt = now - DWELL_MS;   // no point listening on a channel we never reached
                    } else {
                        handler.postDelayed(this, TICK_MS);
                        return;
                    }
                }

                // Activity counts only when (a) the channel is not one the user skipped - the radio is
                // still receiving on it until we leave - and (b) its RECEIVE_START arrived after this
                // channel landed, so a stale flag from the previous channel cannot stop the scan.
                boolean active = env.isReceiving()
                    && !skippedIds.contains(XposedHelpers.getIntField(channels.get(idx), "_id"))
                    && (holding || lastReceiveStartAt >= landedAt);
                if (active) {
                    lastActivityAt = now;
                    if (!holding) {
                        holding = true;
                        holdIndex = idx;
                        XposedBridge.log(TAG + ": Scan: activity on Ch " + displayNumber(channels.get(idx))
                            + " - holding (" + (now - landedAt) + " ms after the channel landed)");
                        postStatus(true, "⏸ Ch " + displayNumber(channels.get(idx)));
                    }
                    handler.postDelayed(this, TICK_MS);
                    return;
                }

                if (holding) {
                    if (now - lastActivityAt < HANG_MS) {
                        handler.postDelayed(this, TICK_MS);
                        return;
                    }
                    holding = false;
                    XposedBridge.log(TAG + ": Scan: Ch " + displayNumber(channels.get(idx)) + " quiet for " + HANG_MS + " ms - resuming");
                }

                if (now - landedAt < DWELL_MS) {
                    handler.postDelayed(this, TICK_MS);
                    return;
                }

                int next = nextIndex(channels, idx);
                if (next < 0 || next == idx) {
                    stop("no other channels in scope");
                    return;
                }
                if (step(channels, idx, next)) {
                    pendingTarget = next;
                    stepSentAt = now;
                }
                handler.postDelayed(this, TICK_MS);
            } catch (Throwable t) {
                XposedBridge.log(TAG + ": Scan tick error: " + t.getMessage());
                XposedBridge.log(t);
                stop("error");
            }
        }
    };

    /** @return true when the OEM channel change was issued; false when the MCU was busy (retry next tick). */
    private static boolean step(List<?> channels, int from, int to) {
        try {
            Class<?> smClass = XposedHelpers.findClass("com.pri.prizeinterphone.state.CmdStateMachine", classLoader);
            Object sm = XposedHelpers.callStaticMethod(smClass, "getInstance");
            Object current = XposedHelpers.callMethod(sm, "getCurrentState");
            Object setChannel = XposedHelpers.callMethod(sm, "getSetChannelState");
            if (current != null && current == setChannel) {
                return false;   // a channel write is in flight; updateChannelId() would ignore us anyway
            }

            // updateChannelId(true) lands on mCurrentChannelIndex + 1, (false) on - 1; neither wraps.
            // The active flag of the channel we leave is fixed up only after the landing is confirmed
            // (see tick): clearing it first would leave the codeplug with no active channel if the
            // radio rejects the write, and the OEM app then restarts on channel 1.
            boolean up = to > 0;
            int preset = up ? to - 1 : 1;
            stepFrom = from;
            stepPreset = preset;
            XposedHelpers.setIntField(fragment, "mCurrentChannelIndex", preset);
            stepping = true;
            try {
                XposedHelpers.callMethod(fragment, "updateChannelId", up);
            } finally {
                stepping = false;
            }
            XposedBridge.log(TAG + ": Scan: " + displayNumber(channels.get(from)) + " -> Ch "
                + displayNumber(channels.get(to)) + " (index " + to + ")");
            return true;
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Scan step failed: " + t.getMessage());
            return false;
        }
    }

    private static void clearActive(List<?> channels, int index) {
        try {
            Object ch = channels.get(index);
            XposedHelpers.callMethod(ch, "setActive", 0);
            Class<?> dmClass = XposedHelpers.findClass("com.pri.prizeinterphone.manager.DmrManager", classLoader);
            Object dm = XposedHelpers.callStaticMethod(dmClass, "getInstance");
            Object helper = XposedHelpers.callMethod(dm, "getCurrentDbHelper");
            XposedHelpers.callMethod(helper, "updateChannel", ch);
            XposedBridge.log(TAG + ": Scan: cleared stale active flag on index " + index);
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Scan: could not clear active flag on index " + index + ": " + t.getMessage());
        }
    }

    private static int nextIndex(List<?> channels, int from) {
        int n = channels.size();
        for (int k = 1; k < n; k++) {
            int i = (from + k) % n;
            if (inScope(channels.get(i))) {
                return i;
            }
        }
        return -1;
    }

    private static int countCandidates(List<?> channels, int from) {
        int count = 0;
        for (int i = 0; i < channels.size(); i++) {
            if (i != from && inScope(channels.get(i))) {
                count++;
            }
        }
        return count;
    }

    private static boolean inScope(Object channel) {
        try {
            int id = XposedHelpers.getIntField(channel, "_id");
            if (skippedIds.contains(id)) {
                return false;
            }
            java.util.Collection<Integer> zone = env != null ? env.zoneChannelIds() : null;
            return zone == null || zone.isEmpty() || zone.contains(id);
        } catch (Throwable t) {
            return false;
        }
    }

    /** Channel number as the intercom shows it (two digits; backlog S12). */
    static String displayNumber(Object channel) {
        try {
            int n = XposedHelpers.getIntField(channel, "number");
            return String.valueOf(n >= 100 ? n % 100 : n);
        } catch (Throwable t) {
            return "?";
        }
    }

    private static void postNotice(final String text) {
        final Env e = env;
        if (e == null) {
            return;
        }
        handler.post(new Runnable() {
            @Override
            public void run() {
                try { e.onNotice(text); } catch (Throwable ignored) { }
            }
        });
    }

    private static void postStatus(final boolean on, final String label) {
        final Env e = env;
        if (e == null) {
            return;
        }
        if (Looper.myLooper() == Looper.getMainLooper()) {
            try { e.onStatus(on, label); } catch (Throwable ignored) { }
        } else {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    try { e.onStatus(on, label); } catch (Throwable ignored) { }
                }
            });
        }
    }
}
