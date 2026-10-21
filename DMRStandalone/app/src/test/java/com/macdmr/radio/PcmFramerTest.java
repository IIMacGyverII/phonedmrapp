package com.macdmr.radio;

import static org.junit.Assert.*;

import org.junit.Test;

import java.io.ByteArrayOutputStream;

public class PcmFramerTest {
    private static byte[] frame(int seed) {
        byte[] f = new byte[PcmFramer.FRAME];
        f[0] = (byte) 0xBB; f[1] = 0x00; f[2] = 1; f[3] = 2; f[4] = 3; f[5] = 4;
        for (int i = 0; i < PcmFramer.PAYLOAD; i++) f[PcmFramer.HEADER + i] = (byte) (seed + i);
        f[PcmFramer.FRAME - 1] = 0x44;
        return f;
    }

    /** Frames split across arbitrary reads, garbage and a control frame in between, a false BB 00 start. */
    @Test public void findsPacketsInAnyStream() {
        ByteArrayOutputStream in = new ByteArrayOutputStream();
        in.write(new byte[] { 0x12, (byte) 0xBB, 0x00, 0x55 }, 0, 4);                          // false start
        byte[] a = frame(10), b = frame(50), c = frame(90);
        in.write(a, 0, a.length);
        byte[] ctl = { 0x68, 0x32, 0x00, 0x00, 0x6f, (byte) 0xdf, 0x00, 0x01, 0x1A, 0x10 };      // an RSSI-style frame on the same port
        in.write(ctl, 0, ctl.length);
        in.write(b, 0, b.length); in.write(c, 0, c.length);
        byte[] all = in.toByteArray();
        final ByteArrayOutputStream pcm = new ByteArrayOutputStream();
        PcmFramer f = new PcmFramer();
        for (int pos = 0, step = 1; pos < all.length; pos += step, step = step % 37 + 7) {       // odd read sizes
            int n = Math.min(step, all.length - pos); byte[] chunk = new byte[n]; System.arraycopy(all, pos, chunk, 0, n);
            f.feed(chunk, n, (buf, off, len) -> pcm.write(buf, off, len));
        }
        assertEquals(3, f.frames);
        byte[] got = pcm.toByteArray();
        assertEquals(3 * PcmFramer.PAYLOAD, got.length);
        for (int k = 0; k < 3; k++) for (int i = 0; i < PcmFramer.PAYLOAD; i++) assertEquals((byte) (10 + 40 * k + i), got[k * PcmFramer.PAYLOAD + i]);
    }

    @Test public void noFramesNoAudio() {
        PcmFramer f = new PcmFramer(); byte[] noise = new byte[2000];
        for (int i = 0; i < noise.length; i++) noise[i] = (byte) (i * 7);
        final int[] n = { 0 };
        f.feed(noise, noise.length, (b, o, l) -> n[0] += l);
        assertEquals(0, n[0]);
    }
}
