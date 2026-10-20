package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class DtmfRemoteTest {
    static final class Log implements DtmfRemote.Actions {
        final List<String> done = new ArrayList<>(), events = new ArrayList<>();
        @Override public void speakPosition() { done.add("pos"); }
        @Override public void speakStatus() { done.add("status"); }
        @Override public void beacon() { done.add("beacon"); }
        @Override public void parrot(boolean on) { done.add(on ? "parrot on" : "parrot off"); }
        @Override public void morseId() { done.add("id"); }
        @Override public void event(String line) { events.add(line); }
    }

    @Test public void runsCommandsWithThePin() {
        Log l = new Log(); DtmfRemote r = new DtmfRemote(l);
        assertEquals(2, r.handle("43212", "4321", true, 0));
        assertEquals(1, r.handle("*43211#", "4321", true, 0));
        assertEquals(4, r.handle("43214", "4321", true, 0));
        assertEquals("[status, pos, parrot on]", l.done.toString());
    }

    @Test public void ignoresWhenOffOrWithoutPinOrOtherCodes() {
        Log l = new Log(); DtmfRemote r = new DtmfRemote(l);
        assertEquals(0, r.handle("43212", "4321", false, 0));
        assertEquals(0, r.handle("43212", "", true, 0));
        assertEquals("repeater codes of another length", 0, r.handle("*73", "4321", true, 0));
        assertEquals(0, r.handle("123456789", "4321", true, 0));
        assertTrue(l.done.isEmpty()); assertTrue(l.events.isEmpty());
    }

    @Test public void locksAfterThreeWrongPins() {
        Log l = new Log(); DtmfRemote r = new DtmfRemote(l);
        long t = 1000;
        r.handle("11112", "4321", true, t); r.handle("22222", "4321", true, t + 1000); r.handle("33332", "4321", true, t + 2000);
        assertTrue(r.locked(t + 3000));
        assertEquals("even the right PIN is ignored while locked", 0, r.handle("43212", "4321", true, t + 5000));
        assertEquals(2, r.handle("43212", "4321", true, t + 11 * 60_000L));
        assertTrue(l.events.get(2).contains("locked"));
    }

    @Test public void unknownCommand() {
        Log l = new Log(); DtmfRemote r = new DtmfRemote(l);
        assertEquals(0, r.handle("43219", "4321", true, 0));
        assertTrue(l.events.get(0).contains("unknown"));
    }
}
