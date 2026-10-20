package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import com.macdmr.radio.coverage.Morse;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class CwDecoderTest {
    private static List<String> run(short[] pcm, double noise) {
        List<String> out = new ArrayList<>();
        CwDecoder d = new CwDecoder((t, hz, wpm) -> out.add(t));
        Random r = new Random(7);
        short[] x = new short[pcm.length + 8000 * 2];          // 2 s of quiet after: the decoder ends the message
        for (int i = 0; i < x.length; i++) x[i] = (short) Math.max(-32768, Math.min(32767, (i < pcm.length ? pcm[i] : 0) + noise * r.nextGaussian()));
        d.process(x);
        return out;
    }

    @Test public void decodesARepeaterIdAtUsualSpeedsAndTones() {
        for (int wpm : new int[] { 12, 20, 28 })
            for (double hz : new double[] { 600, 800, 1000 }) {
                List<String> out = run(Morse.pcm("K0MSP R", wpm, hz), 300);
                assertEquals(wpm + " WPM " + hz + " Hz", "[K0MSP R]", out.toString());
            }
    }

    @Test public void decodesWithStrongNoise() {
        List<String> out = run(Morse.pcm("W0ABC", 20, 800), 2500);
        assertEquals("[W0ABC]", out.toString());
    }

    @Test public void startsWithADah() {
        assertEquals("[TEST DE K0ABC]", run(Morse.pcm("TEST DE K0ABC", 18, 700), 200).toString());
        assertEquals("[KD0XYZ]", run(Morse.pcm("KD0XYZ", 22, 900), 200).toString());
    }

    @Test public void reportsSpeed() {
        final int[] wpm = { 0 };
        CwDecoder d = new CwDecoder((t, hz, w) -> wpm[0] = w);
        short[] pcm = Morse.pcm("PARIS PARIS", 20, 800);
        d.process(pcm); d.process(new short[16000]);
        assertTrue("about 20 WPM, was " + wpm[0], wpm[0] >= 17 && wpm[0] <= 23);
    }

    @Test public void ignoresStrayDitsWithoutACallsign() {
        assertEquals("[]", run(Morse.pcm("EN EE E", 28, 600), 200).toString());
        assertEquals("[CQ TEST DE W1AW]", run(Morse.pcm("CQ TEST DE W1AW", 20, 700), 200).toString());
        assertEquals("plain text of 8+ characters", "[THE QUICK BROWN]", run(Morse.pcm("THE QUICK BROWN", 20, 700), 200).toString());
    }

    @Test public void ignoresNoiseVoiceAndDtmf() {
        Random r = new Random(3);
        short[] noise = new short[8000 * 5]; for (int i = 0; i < noise.length; i++) noise[i] = (short) (3000 * r.nextGaussian());
        assertEquals("noise", "[]", run(noise, 0).toString());
        short[] voice = new short[8000 * 5];                  // a gliding pitch with harmonics, like speech
        for (int i = 0; i < voice.length; i++) { double t = i / 8000.0, f = 180 + 60 * Math.sin(2 * Math.PI * 0.7 * t); double v = 0; for (int h = 1; h <= 8; h++) v += Math.sin(2 * Math.PI * f * h * t + h) / h; voice[i] = (short) (6000 * v * (0.5 + 0.5 * Math.sin(2 * Math.PI * 3 * t))); }
        assertEquals("voice", "[]", run(voice, 200).toString());
        short[] dtmf = new short[8000 * 3];                    // keys 1-5-9 repeatedly, 100 ms on / 60 ms off
        double[][] pairs = { { 697, 1209 }, { 770, 1336 }, { 852, 1477 } };
        for (int i = 0; i < dtmf.length; i++) { int k = i / 1280; if (i % 1280 < 800) { double[] p = pairs[k % 3]; dtmf[i] = (short) (8000 * (Math.sin(2 * Math.PI * p[0] * i / 8000) + Math.sin(2 * Math.PI * p[1] * i / 8000))); } }
        assertEquals("dtmf", "[]", run(dtmf, 100).toString());
    }
}
