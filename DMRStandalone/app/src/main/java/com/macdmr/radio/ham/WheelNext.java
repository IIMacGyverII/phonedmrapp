package com.macdmr.radio.ham;

/**
 * The steering wheel's Next button as a talk key, without trusting the release: some cars (the owner's, measured
 * 2026-10-20) send the press and a repeat reliably but the release late or not at all.
 * <ul>
 * <li>HOLD: hold Next (half a second, or the car's repeat) to talk; the release stops, and if it never comes, pressing
 *     Next again stops. A short press (press and release) still steps the channel.</li>
 * <li>DOUBLE: press Next twice within {@link #DOUBLE_MS} to talk, press once to stop; uses presses only. A single press
 *     steps the channel after that window.</li>
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
    public static final long HOLD_MS = 500, DOUBLE_MS = 500;

    private final Out out;
    private int mode;
    private boolean talking, swallowUp, stepPending, pressed;
    private long downAt;

    private final Runnable holdCheck, stepLater;

    public WheelNext(Out o) {
        out = o;
        holdCheck = () -> { synchronized (this) { if (pressed && !talking) start("held"); } };
        stepLater = () -> { synchronized (this) { if (stepPending) { stepPending = false; out.note("single press: next channel"); out.step(); } } };
    }
    public synchronized void setMode(int m) { mode = m; reset(); }
    public synchronized boolean talking() { return talking; }
    /** The transmission ended by other means (the 30 s limit, the screen): forget it. */
    public synchronized void stopped() { if (talking) { talking = false; out.note("stopped elsewhere"); } }

    private void reset() { talking = false; swallowUp = false; stepPending = false; pressed = false; out.cancel(holdCheck); out.cancel(stepLater); }
    private void start(String why) { talking = true; out.note("talk (" + why + ")"); out.talk(true); }
    private void stop(String why) { talking = false; out.note("stop (" + why + ")"); out.talk(false); }

    public synchronized void down(int repeat, long now) {
        if (mode == OFF) return;
        if (repeat == 0) {
            if (talking) { stop("pressed again"); swallowUp = true; pressed = false; out.cancel(holdCheck); return; }
            if (mode == HOLD) { downAt = now; pressed = true; swallowUp = false; out.cancel(holdCheck); out.schedule(holdCheck, HOLD_MS); return; }
            if (stepPending) { stepPending = false; out.cancel(stepLater); start("double press"); return; }   // DOUBLE
            stepPending = true; out.schedule(stepLater, DOUBLE_MS);
            return;
        }
        if (mode == HOLD && !talking && pressed && now - downAt >= HOLD_MS - 100) { out.cancel(holdCheck); start("held, repeat " + repeat); }
    }

    public synchronized void up(long now) {
        if (mode != HOLD) return;                                    // DOUBLE uses presses only
        if (swallowUp) { swallowUp = false; return; }
        out.cancel(holdCheck);
        if (talking) { pressed = false; stop("released"); return; }
        if (pressed) { pressed = false; out.note("short press: next channel"); out.step(); }
        // an up without its press (late, from an earlier hold): nothing
    }
}
