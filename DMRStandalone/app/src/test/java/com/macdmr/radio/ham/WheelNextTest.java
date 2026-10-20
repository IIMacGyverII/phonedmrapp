package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

/** Simulated clock: scheduled runnables fire when {@link Sim#advance} passes their time. */
public class WheelNextTest {
    static final class Sim implements WheelNext.Out {
        long now; final List<Object[]> timers = new ArrayList<>(); final List<String> log = new ArrayList<>();
        @Override public void talk(boolean on) { log.add(on ? "TALK" : "STOP"); }
        @Override public void step() { log.add("STEP"); }
        @Override public void schedule(Runnable r, long ms) { timers.add(new Object[] { r, now + ms }); }
        @Override public void cancel(Runnable r) { timers.removeIf(t -> t[0] == r); }
        @Override public void note(String what) { }
        void advance(long ms) {
            long end = now + ms;
            while (true) {
                Object[] next = null; for (Object[] t : timers) if ((Long) t[1] <= end && (next == null || (Long) t[1] < (Long) next[1])) next = t;
                if (next == null) break;
                timers.remove(next); now = (Long) next[1]; ((Runnable) next[0]).run();
            }
            now = end;
        }
    }

    @Test public void holdTalksAndReleaseStops() {
        Sim s = new Sim(); WheelNext w = new WheelNext(s); w.setMode(WheelNext.HOLD);
        w.down(0, s.now); s.advance(700); w.down(1, s.now); s.advance(3000); w.up(s.now);
        assertEquals("[TALK, STOP]", s.log.toString());
    }

    @Test public void shortPressSteps() {
        Sim s = new Sim(); WheelNext w = new WheelNext(s); w.setMode(WheelNext.HOLD);
        w.down(0, s.now); s.advance(150); w.up(s.now); s.advance(1000);
        assertEquals("[STEP]", s.log.toString());
    }

    @Test public void missingReleaseIsFixedByPressingAgain() {   // the owner's car: the release came 37 s late
        Sim s = new Sim(); WheelNext w = new WheelNext(s); w.setMode(WheelNext.HOLD);
        w.down(0, s.now); s.advance(1000); w.down(1, s.now);          // held: talking
        s.advance(8000); w.down(0, s.now);                            // no release yet: press again
        s.advance(300); w.up(s.now);                                   // that press's release (swallowed)
        s.advance(28000); w.up(s.now);                                 // the late release of the hold: ignored
        assertEquals("[TALK, STOP]", s.log.toString());
        w.down(0, s.now); s.advance(150); w.up(s.now);                 // and the button still works normally after
        assertEquals("[TALK, STOP, STEP]", s.log.toString());
    }

    @Test public void doublePressTogglesWithoutReleases() {
        Sim s = new Sim(); WheelNext w = new WheelNext(s); w.setMode(WheelNext.DOUBLE);
        w.down(0, s.now); s.advance(250); w.down(0, s.now);           // double press: talk
        s.advance(5000); w.down(0, s.now);                             // single press: stop
        s.advance(2000); w.down(0, s.now); s.advance(1000);            // a lone press: next channel after the window
        assertEquals("[TALK, STOP, STEP]", s.log.toString());
        w.up(s.now);                                                   // releases are ignored in this mode
        assertEquals(3, s.log.size());
    }

    @Test public void offDoesNothing() {
        Sim s = new Sim(); WheelNext w = new WheelNext(s); w.setMode(WheelNext.OFF);
        w.down(0, s.now); s.advance(2000); w.up(s.now);
        assertTrue(s.log.isEmpty());
    }
}
