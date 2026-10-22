/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import static org.junit.Assert.*;

import org.junit.Test;

import java.io.File;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.file.Files;

public class ClipRecorderTest {
    private static byte[] pcm(short... s) { ByteBuffer b = ByteBuffer.allocate(s.length * 2).order(ByteOrder.LITTLE_ENDIAN); for (short v : s) b.putShort(v); return b.array(); }

    @Test public void writesAValidWavAndCountsDropoutsAndClipping() throws Exception {
        File f = File.createTempFile("clip", ".wav"); f.deleteOnExit();
        ClipRecorder c = new ClipRecorder(f, 1000);                       // 1 s = 16000 bytes max
        short[] tone = new short[800]; for (int i = 0; i < tone.length; i++) tone[i] = (short) (Math.sin(i * 2 * Math.PI * 1000 / 8000) * 8000);
        assertTrue(c.write(pcm(tone), tone.length * 2));
        assertTrue(c.write(new byte[400], 400));                           // 25 ms of digital silence = one dropout
        short[] loud = new short[100]; java.util.Arrays.fill(loud, (short) 32767);
        assertTrue(c.write(pcm(loud), 200));
        c.finish();
        byte[] w = Files.readAllBytes(f.toPath());
        ByteBuffer h = ByteBuffer.wrap(w).order(ByteOrder.LITTLE_ENDIAN);
        assertEquals("RIFF", new String(w, 0, 4)); assertEquals("WAVE", new String(w, 8, 4)); assertEquals("data", new String(w, 36, 4));
        assertEquals(8000, h.getInt(24)); assertEquals(1, h.getShort(22)); assertEquals(16, h.getShort(34));
        assertEquals(1600 + 400 + 200, h.getInt(40)); assertEquals(44 + 2200, w.length);
        String st = c.stats();
        assertTrue(st, st.contains("dropouts (≥10 ms of digital silence) 1") && st.contains("longest 25 ms") && st.contains("peak 32767"));
    }

    @Test public void stopsAtItsLength() throws Exception {
        File f = File.createTempFile("clip", ".wav"); f.deleteOnExit();
        ClipRecorder c = new ClipRecorder(f, 10);                         // 160 bytes
        assertFalse(c.write(new byte[400], 400));
        assertTrue(c.isDone()); assertEquals(44 + 160, f.length());
    }
}
