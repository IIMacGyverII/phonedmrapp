/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

/**
 * The steering wheel's Next button as a talk key, without trusting the release. Measured in the owner's car
 * (2026-10-20, files/wheel.log): a hold arrives as press + one repeat about 0.4 s later, but at the release the car
 * sends a proper release only sometimes; other times a late repeat, a repeat and a release, or nothing at all. After a
 * lost release, the next press can arrive as a repeat (the car still thinks the key is down). Short presses always
 * arrive as press + release within 0.1–0.3 s.
 * <ul>
 * <li>HOLD: a press held half a second (or its first repeat) talks. Any later event of the key ends the transmission
 *     (a release, a late repeat, a new press). A stray repeat while idle is ignored, never a key-up. A short press
 *     steps the channel.</li>
 * <li>DOUBLE: two presses within {@link #DOUBLE_MS} talk, one press stops; a single press steps the channel after the
 *     window. A press is a key-down that is not the quick repeat of the one before.</li>
 * </ul>
 * Times come in as parameters so the logic can be tested; the host schedules the two timers.
 */
public final class WheelNext {
    public interface Out {
        void talk(boolean on);
        void step();
        void schedule(Runnable r, long ms);
        void cancel(Runnable r);
        void note(String what);
    }
    public static final int OFF = 0, HOLD = 1, DOUBLE = 2;
    public static final long HOLD_MS = 500, DOUBLE_MS = 500, REPEAT_MS = 1000;

    private final Out out;
    private int mode;
    private boolean talking, swallowUp, stepPending, pressed;
    private long downAt, lastDownAt = Long.MIN_VALUE / 2, talkAt;
    private final Runnable holdCheck, stepLater;

    public WheelNext(Out o) {
        out = o;
        holdCheck = () -> { synchronized (this) { if (pressed && !talking) start("held", downAt + HOLD_MS); } };
        stepLater = () -> { synchronized (this) { if (stepPending) { stepPending = false; out.note("single press: next channel"); out.step(); } } };
    }
    public synchronized void setMode(int m) { mode = m; reset(); }
    public synchronized boolean talking() { return talking; }
    /** The transmission ended by other means (the 30 s limit, the screen): forget it, and the key's state with it. */
    public synchronized void stopped() { if (talking) { talking = false; out.note("stopped elsewhere"); } pressed = false; swallowUp = false; out.cancel(holdCheck); }

    private void reset() { talking = false; swallowUp = false; stepPending = false; pressed = false; out.cancel(holdCheck); out.cancel(stepLater); }
    private void start(String why, long now) { talking = true; talkAt = now; pressed = false; out.note("talk (" + why + ")"); out.talk(true); }
    private void stop(String why) { talking = false; out.note("stop (" + why + ")"); out.talk(false); }

    public synchronized void down(int repeat, long now) {
        if (mode == OFF) return;
        boolean fresh = repeat == 0 || now - lastDownAt > REPEAT_MS;   // a new press, not the quick repeat of the last one
        lastDownAt = now;
        if (mode == DOUBLE) {
            if (!fresh) return;
            if (talking) { stop("pressed"); return; }
            if (stepPending) { stepPending = false; out.cancel(stepLater); start("double press", now); return; }
            stepPending = true; out.schedule(stepLater, DOUBLE_MS);
            return;
        }
        // HOLD
        if (talking) {
            if (fresh || now - talkAt > REPEAT_MS) { stop(fresh ? "pressed again" : "late repeat"); swallowUp = true; }
            return;
        }
        if (repeat == 0) { pressed = true; downAt = now; swallowUp = false; out.cancel(holdCheck); out.schedule(holdCheck, HOLD_MS); return; }
        if (fresh) { swallowUp = true; pressed = false; out.note("stray repeat ignored"); return; }   // left over from a lost release: never a key-up
        if (pressed && now - downAt >= HOLD_MS - 150) { out.cancel(holdCheck); start("held, repeat " + repeat, now); }
    }

    public synchronized void up(long now) {
        if (mode != HOLD) return;                                    // DOUBLE uses presses only
        if (swallowUp) { swallowUp = false; return; }
        out.cancel(holdCheck);
        if (talking) { stop("released"); return; }
        if (pressed) { pressed = false; out.note("short press: next channel"); out.step(); }
    }
}
