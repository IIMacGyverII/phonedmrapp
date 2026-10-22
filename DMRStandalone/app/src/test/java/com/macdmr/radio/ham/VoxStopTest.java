/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.Random;

public class VoxStopTest {
    /** 64 ms blocks: road noise of {@code noise}, speech bursts of {@code speech} while {@code talking(t)}. */
    private static long run(VoxStop v, int noise, int speech, java.util.function.LongPredicate talking, long max) {
        Random r = new Random(1);
        for (long t = 0; t < max; t += 64) {
            int peak = (int) Math.abs(noise * (1 + 0.3 * r.nextGaussian())) + (talking.test(t) ? speech : 0);
            if (v.level(peak, t)) return t;
        }
        return -1;
    }

    @Test public void endsAfterTheHangOnceSpeechStops() {
        long end = run(new VoxStop(2000, 0), 600, 12000, t -> t > 500 && t < 4000, 30000);
        assertTrue("about 2 s after speech ends at 4 s, was " + end, end >= 5900 && end <= 6200);
    }

    @Test public void shortPausesInSpeechDoNotEndIt() {
        long end = run(new VoxStop(2000, 0), 600, 12000, t -> t < 8000 && (t % 2000) < 1300, 30000);   // 0.7 s pauses
        assertTrue("ends only after the last word, was " + end, end >= 9200);
    }

    @Test public void loudRoadNoiseIsNotSpeech() {
        long end = run(new VoxStop(2000, 0), 2500, 15000, t -> t > 300 && t < 3000, 30000);
        assertTrue("noise 2500 is the floor; ends ~2 s after speech, was " + end, end > 4000 && end < 5500);
    }

    @Test public void nobodySpeaks() {
        assertEquals(6016, run(new VoxStop(2000, 0), 400, 0, t -> false, 30000), 64);
    }
}
