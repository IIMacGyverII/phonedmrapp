/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
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

    /** The owner's drive of 2026-10-20 12:24-12:26 (files/wheel.log), event by event: d = down (repeat), u = up, s = stopped elsewhere. */
    static final String DRIVE =
        "33477 d0, 33887 d1, 50276 s, 61425 d1, 61548 u, 61617 d0, 61753 u, 64667 d0, 64788 u, 64912 d0, 65006 u, 69008 d0, 69166 u, "
      + "71307 d0, 71425 u, 71479 d0, 71780 u, 73197 d0, 73330 u, 73393 d0, 73704 u, 74692 d0, 75095 d1, 76023 u, 76537 d0, 76911 d1, "
      + "78627 d1, 78767 u, 78887 d0, 79289 d1, 81765 d1, 97090 s, 102725 d2, 102861 u, 102981 d0, 103183 u, 107333 d0, 107435 u, "
      + "107629 d0, 108000 d1, 126532 s";

    @Test public void replaysTheOwnersDrive() {
        Sim s = new Sim(); WheelNext w = new WheelNext(s); w.setMode(WheelNext.HOLD);
        for (String e : DRIVE.split(", ")) {
            String[] f = e.trim().split(" "); long t = Long.parseLong(f[0]); s.advance(t - s.now);
            if (f[1].startsWith("d")) w.down(Integer.parseInt(f[1].substring(1)), s.now); else if (f[1].equals("u")) w.up(s.now); else w.stopped();
        }
        // every hold talks; each one is ended by the car's next event (release, late repeat or new press) where it sent one;
        // stray repeats after a lost release never key up; short presses step
        assertEquals("[TALK, STEP, STEP, STEP, STEP, STEP, STEP, STEP, STEP, TALK, STOP, TALK, STOP, TALK, STOP, STEP, STEP, TALK]", s.log.toString());
    }

    @Test public void doublePressOnTheOwnersQuickPairs() {   // the pairs 0.17-0.25 s apart in that drive
        Sim s = new Sim(); WheelNext w = new WheelNext(s); w.setMode(WheelNext.DOUBLE);
        for (String e : "64667 d0, 64788 u, 64912 d0, 65006 u, 71307 d0, 71425 u, 71479 d0, 71780 u".split(", ")) {
            String[] f = e.split(" "); s.advance(Long.parseLong(f[0]) - s.now);
            if (f[1].startsWith("d")) w.down(0, s.now); else w.up(s.now);
        }
        assertEquals("first pair talks, second pair: first press stops, second starts a pending single press", "[TALK, STOP]", s.log.toString());
        s.advance(1000);
        assertEquals("[TALK, STOP, STEP]", s.log.toString());
    }
}
