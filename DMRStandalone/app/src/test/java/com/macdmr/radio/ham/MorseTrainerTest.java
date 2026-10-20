package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class MorseTrainerTest {
    @Test public void lessonsGrowInKochOrder() {
        assertEquals("KM", MorseTrainer.chars(1)); assertEquals("KMU", MorseTrainer.chars(2));
        assertEquals(MorseTrainer.KOCH, MorseTrainer.chars(MorseTrainer.LESSONS));
        for (char c : MorseTrainer.KOCH.toCharArray()) assertNotNull("code for " + c, MorseTrainer.code(c));
        String g = MorseTrainer.groups(3, 5, new Random(1));
        assertEquals(29, g.length());
        for (char c : g.replace(" ", "").toCharArray()) assertTrue(MorseTrainer.chars(3).indexOf(c) >= 0);
    }

    @Test public void scoring() {
        assertEquals(1.0, MorseTrainer.score("KMKMK MMKKM", "kmkmkmmkkm"), 1e-9);
        assertEquals(0.9, MorseTrainer.score("KMKMK MMKKM", "KMKMK MMKK"), 1e-9);   // one missed
        assertEquals(0.0, MorseTrainer.score("KM", ""), 1e-9);
    }

    @Test public void farnsworthStretchesOnlyTheGaps() {
        short[] full = MorseTrainer.pcm("PARIS PARIS", 20, 20, 600), slow = MorseTrainer.pcm("PARIS PARIS", 20, 10, 600);
        assertTrue("spacing makes it longer", slow.length > full.length * 1.5);
        assertEquals("same key-down time", keyDown(full), keyDown(slow), 200);
        // PARIS at 20 WPM is 50 dits of 60 ms = 3 s per word: two words plus 0.6 s of lead and tail
        assertEquals(8000 * (3.0 * 2 - 7 * 0.06 + 0.6), full.length, 8000 * 0.01);
    }

    @Test public void decoderReadsTheTrainerSounds() {
        List<String> out = new ArrayList<>();
        CwDecoder d = new CwDecoder((t, hz, wpm) -> out.add(t), false);
        d.process(MorseTrainer.pcm("KMURE SNAPT", 20, 20, 700)); d.process(new short[16000]);
        assertEquals("[KMURE SNAPT]", out.toString());
    }

    private static int keyDown(short[] x) { int n = 0; for (short v : x) if (Math.abs(v) > 3000) n++; return n; }
}
