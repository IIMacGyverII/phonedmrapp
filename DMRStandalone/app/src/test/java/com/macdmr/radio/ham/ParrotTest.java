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

public class ParrotTest {
    static final class FakeHost implements Parrot.Host {
        final List<short[]> sent = new ArrayList<>(); String call; final List<String> events = new ArrayList<>();
        @Override public boolean transmit(short[] pcm, String label, Runnable done) { synchronized (sent) { sent.add(pcm); sent.notifyAll(); } done.run(); return true; }
        @Override public String idCallsign() { return call; }
        @Override public void event(String line) { events.add(line); }
        short[] await() throws InterruptedException { synchronized (sent) { long end = System.currentTimeMillis() + 3000; while (sent.isEmpty() && System.currentTimeMillis() < end) sent.wait(200); return sent.isEmpty() ? null : sent.get(0); } }
    }

    private static byte[] tone(int samples, double hz, int amp, int phase0) {
        byte[] b = new byte[samples * 2];
        for (int i = 0; i < samples; i++) { short v = (short) (amp * Math.sin(2 * Math.PI * hz * (phase0 + i) / 8000)); b[2 * i] = (byte) v; b[2 * i + 1] = (byte) (v >> 8); }
        return b;
    }

    /** Feed {@code ms} of heard tone then quiet blocks until the hang time passes; time advances 64 ms per block. */
    private static long play(Parrot p, long t, int ms) {
        int blocks = ms / 64;
        for (int k = 0; k < blocks; k++) { p.feed(tone(512, 1000, 8000, k * 512), 1024, true, t); t += 64; }
        for (int k = 0; k < 20; k++) { p.feed(new byte[1024], 1024, false, t); t += 64; }
        return t;
    }

    @Test public void repeatsAReceptionWithLeadAndNormalizedLevel() throws Exception {
        FakeHost h = new FakeHost(); Parrot p = new Parrot(h); p.setEnabled(true);
        play(p, 1000, 2048);
        short[] out = h.await();
        assertNotNull("transmitted", out);
        int voice = 2048 / 64 * 512;
        assertEquals(8000 * 3 / 2 + voice, out.length);
        int peak = 0; for (short v : out) peak = Math.max(peak, Math.abs(v));
        assertTrue("normalized near 22000, was " + peak, peak > 20000 && peak <= 22100);
        for (int i = 0; i < 8000 * 3 / 2; i++) assertEquals(0, out[i]);
    }

    @Test public void ignoresKerchunks() throws Exception {
        FakeHost h = new FakeHost(); Parrot p = new Parrot(h); p.setEnabled(true);
        play(p, 1000, 320);
        assertNull(h.await());
    }

    @Test public void addsMorseIdOnlyOncePerTenMinutes() throws Exception {
        FakeHost h = new FakeHost(); h.call = "N0CALL"; Parrot p = new Parrot(h); p.setEnabled(true);
        long t = play(p, 1000, 1024);
        short[] first = h.await(); assertNotNull(first);
        int bare = 8000 * 3 / 2 + 1024 / 64 * 512;
        assertTrue("first playback carries the ID", first.length > bare + 8000);
        Thread.sleep(1300);   // the playback thread records the ID time
        synchronized (h.sent) { h.sent.clear(); }
        play(p, t + 1000, 1024);
        short[] second = h.await(); assertNotNull(second);
        assertEquals("no ID again within ten minutes", bare, second.length);
    }

    @Test public void capsAtTheRadiosLimit() throws Exception {
        FakeHost h = new FakeHost(); Parrot p = new Parrot(h); p.setEnabled(true);
        play(p, 1000, 35_000);
        short[] out = h.await(); assertNotNull(out);
        assertTrue(out.length <= 8000 * 28);
        Thread.sleep(300);
        assertTrue(h.events.get(0).contains("cut at 26 s"));
    }
}
