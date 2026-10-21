package com.macdmr.radio.pkt;

import static org.junit.Assert.*;

import org.junit.Test;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/** The continuous Robot 36 receiver on the bench encoder's reference picture: whole, picked up halfway, faded, noisy. */
public class SstvContinuousTest {
    static short[] wav() throws Exception {
        try (InputStream in = SstvContinuousTest.class.getResourceAsStream("/sstv/r36_ref.wav")) {
            byte[] b = in.readAllBytes(); int data = 44; short[] s = new short[(b.length - data) / 2];
            for (int i = 0; i < s.length; i++) s[i] = (short) ((b[data + 2 * i] & 0xFF) | (b[data + 2 * i + 1] << 8));
            return s;
        }
    }
    static int[] ref() throws Exception {
        try (InputStream in = SstvContinuousTest.class.getResourceAsStream("/sstv/r36_ref.rgb")) {
            byte[] b = in.readAllBytes(); int[] p = new int[b.length / 3];
            for (int i = 0; i < p.length; i++) p[i] = ((b[3 * i] & 0xFF) << 16) | ((b[3 * i + 1] & 0xFF) << 8) | (b[3 * i + 2] & 0xFF);
            return p;
        }
    }
    static final class Pic { int[] px; int lines; boolean complete; }
    static List<Pic> run(short[] audio) {
        List<Pic> out = new ArrayList<>();
        SstvContinuous d = new SstvContinuous(8000, new SstvContinuous.Listener() {
            @Override public void onLive(int[] argb, int w, int h, boolean locked, int lines) { }
            @Override public void onPicture(int[] argb, int w, int h, int lines, boolean complete) { Pic p = new Pic(); p.px = argb.clone(); p.lines = lines; p.complete = complete; out.add(p); }
        });
        short[] chunk = new short[1024];
        for (int o = 0; o < audio.length; o += 1024) { int n = Math.min(1024, audio.length - o); System.arraycopy(audio, o, chunk, 0, n); d.process(chunk, n); }
        d.flush();
        return out;
    }
    /** PSNR over rows [r0, r1). */
    static double psnr(int[] a, int[] b, int r0, int r1) {
        double se = 0; int n = 0;
        for (int i = r0 * 320; i < r1 * 320; i++) for (int sh = 0; sh <= 16; sh += 8) { int d = ((a[i] >> sh) & 255) - ((b[i] >> sh) & 255); se += d * d; n++; }
        return 10 * Math.log10(255.0 * 255 / Math.max(1e-9, se / n));
    }
    static void dump(int[] px, String name) {
        try (java.io.FileOutputStream o = new java.io.FileOutputStream("build/sstv_" + name + ".rgb")) { for (int v : px) { o.write((v >> 16) & 255); o.write((v >> 8) & 255); o.write(v & 255); } } catch (Exception ignored) { }
    }
    static short[] withSilence(short[] a, int before, int after) { short[] o = new short[before + a.length + after]; System.arraycopy(a, 0, o, before, a.length); return o; }

    @Test public void wholePicture() throws Exception {
        List<Pic> p = run(withSilence(wav(), 8000, 24000));
        assertEquals(1, p.size());
        assertEquals("all lines", 240, p.get(0).lines);
        dump(p.get(0).px, "whole");
        double q = psnr(p.get(0).px, ref(), 0, 236);
        System.out.println("whole picture: lines " + p.get(0).lines + ", PSNR " + String.format("%.1f", q) + " dB");
        assertTrue("PSNR " + q, q > 19);   // measured 19.6 dB at exact alignment (Robot 36 colour is half resolution)
    }

    @Test public void pickedUpHalfwayLandsAtTheBottom() throws Exception {
        short[] a = wav(); int from = (int) (a.length * 0.55);
        short[] tail = new short[a.length - from]; System.arraycopy(a, from, tail, 0, tail.length);
        List<Pic> p = run(withSilence(tail, 8000, 24000));
        assertEquals(1, p.size());
        Pic pic = p.get(0);
        assertFalse(pic.complete);
        dump(pic.px, "half");
        double q = psnr(pic.px, ref(), 240 - pic.lines + 8, 236);
        System.out.println("picked up at 55 %: " + pic.lines + " lines, bottom-aligned PSNR " + String.format("%.1f", q) + " dB");
        assertTrue("about 45 % of the lines, got " + pic.lines, pic.lines > 80 && pic.lines < 115);
        assertTrue("bottom-aligned PSNR " + q, q > 18);
    }

    @Test public void fadesAreCoastedNotDropped() throws Exception {
        short[] a = wav().clone(); Random r = new Random(1);
        int sr = 8000;
        for (double at : new double[] { 0.30, 0.50, 0.70 }) {                 // three 0.6 s fades into noise (4 lines each)
            int s0 = (int) (a.length * at);
            for (int i = s0; i < s0 + (int) (0.6 * sr); i++) a[i] = (short) (r.nextGaussian() * 3000);
        }
        List<Pic> p = run(withSilence(a, 8000, 24000));
        assertEquals(1, p.size());
        double qBottom = psnr(p.get(0).px, ref(), 200, 236);
        System.out.println("three fades: lines " + p.get(0).lines + ", PSNR of the rows below the fades " + String.format("%.1f", qBottom) + " dB");
        assertTrue("geometry kept below the fades: PSNR " + qBottom, qBottom > 17);
    }

    @Test public void noisySignal() throws Exception {
        short[] a = wav().clone(); Random r = new Random(2);
        for (int i = 0; i < a.length; i++) a[i] = (short) Math.max(-32768, Math.min(32767, a[i] * 0.5 + r.nextGaussian() * 2500));
        List<Pic> p = run(withSilence(a, 8000, 24000));
        assertEquals(1, p.size());
        double q = psnr(p.get(0).px, ref(), 0, 236);
        System.out.println("noisy: lines " + p.get(0).lines + ", PSNR " + String.format("%.1f", q) + " dB");
        assertTrue("PSNR " + q, q > 16);
    }

    @Test public void silenceAndNoiseMakeNoPicture() {
        short[] a = new short[8000 * 20]; Random r = new Random(3);
        for (int i = 0; i < a.length; i++) a[i] = (short) (r.nextGaussian() * 4000);
        assertEquals(0, run(a).size());
    }
}
