/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.web;

import static org.junit.Assert.*;

import org.junit.Test;

public class WebTxFeedTest {
    /** A clock that only moves when the feed sleeps. */
    static final class FakeClock implements WebTxFeed.Clock {
        long t = 1_000_000_000L, slept;
        @Override public long nanos() { return t; }
        @Override public void sleepNanos(long n) { t += n; slept += n; }
    }
    private static byte[] ramp(int samples, int from) {
        byte[] b = new byte[samples * 2];
        for (int i = 0; i < samples; i++) { short v = (short) (from + i); b[2 * i] = (byte) v; b[2 * i + 1] = (byte) (v >> 8); }
        return b;
    }
    private static short sample(byte[] b, int i) { return (short) ((b[2 * i] & 0xFF) | (b[2 * i + 1] << 8)); }

    @Test public void audioComesOutInOrderAtRealTime() {
        FakeClock c = new FakeClock(); WebTxFeed f = new WebTxFeed(c);
        for (int k = 0; k < 20; k++) f.push(ramp(160, k * 160), 0, 320);   // 20 blocks of 20 ms = 400 ms
        byte[] out = new byte[3200];
        long t0 = c.t;
        assertEquals(3200, f.read(out, 0, 3200));                          // 200 ms
        assertEquals(0, sample(out, 0)); assertEquals(1599, sample(out, 1599));
        assertEquals(200_000_000L, c.t - t0);                              // paced: 1600 samples = 200 ms
        assertEquals(3200, f.read(out, 0, 3200));
        assertEquals(1600, sample(out, 0));
        assertEquals(0, f.paddedBytes());
    }

    @Test public void gapsBecomeSilence() {
        FakeClock c = new FakeClock(); WebTxFeed f = new WebTxFeed(c);
        f.push(ramp(1600, 1), 0, 3200);                                    // exactly the pre-buffer and a bit
        byte[] out = new byte[4000];
        f.read(out, 0, 4000);                                              // 2000 samples asked, 1600 there
        assertEquals(1, sample(out, 0)); assertEquals(1600, sample(out, 1599)); assertEquals(0, sample(out, 1600)); assertEquals(0, sample(out, 1999));
        assertEquals(800, f.paddedBytes());
    }

    @Test public void delayStaysShortWhenTheBrowserRunsAhead() {
        FakeClock c = new FakeClock(); WebTxFeed f = new WebTxFeed(c);
        f.push(ramp(16000, 0), 0, 32000);                                  // 2 s at once
        assertTrue("trimmed to the maximum delay", f.droppedBytes() >= 32000 - 8000 * 2 * WebTxFeed.MAX_DELAY_MS / 1000);
        byte[] out = new byte[2];
        f.read(out, 0, 2);
        assertEquals("the newest audio is kept", 16000 - 8000 * WebTxFeed.MAX_DELAY_MS / 1000, sample(out, 0));
    }

    @Test public void oversizedPushKeepsTheEnd() {
        FakeClock c = new FakeClock(); WebTxFeed f = new WebTxFeed(c);
        f.push(ramp(40000, 0), 0, 80000);                                   // 5 s, more than the ring
        byte[] out = new byte[2]; f.read(out, 0, 2);
        assertEquals((short) (40000 - 8000 * WebTxFeed.MAX_DELAY_MS / 1000), sample(out, 0));   // the ramp wraps as a 16-bit sample
    }

    @Test public void closedFeedStartsWithoutWaitingForThePreBuffer() {
        FakeClock c = new FakeClock(); WebTxFeed f = new WebTxFeed(c);
        f.push(ramp(10, 5), 0, 20); f.close();
        byte[] out = new byte[40]; assertEquals(40, f.read(out, 0, 40));
        assertEquals(5, sample(out, 0)); assertEquals(0, sample(out, 10));
        assertTrue(f.closed());
    }
}
