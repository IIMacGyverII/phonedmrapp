/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import org.junit.Test;

/** Writes bench WAVs for the injection tool when the BENCH_OUT environment variable names a folder (otherwise does nothing). */
public class WriteBenchWavs {
    @Test public void write() throws Exception {
        String dir = System.getenv("BENCH_OUT"); if (dir == null) return;
        wav(dir + "/psk31_test.wav", Psk31.encode("PSK31 BENCH TEST de DMR Radio 73", 1234));
        wav(dir + "/rtty_test.wav", Rtty.encode("RTTY BENCH TEST 599 73", 2125, 1000));
    }
    static void wav(String path, short[] pcm) throws Exception {
        java.nio.ByteBuffer b = java.nio.ByteBuffer.allocate(44 + pcm.length * 2).order(java.nio.ByteOrder.LITTLE_ENDIAN);
        b.put("RIFF".getBytes()).putInt(36 + pcm.length * 2).put("WAVEfmt ".getBytes()).putInt(16).putShort((short) 1).putShort((short) 1).putInt(8000).putInt(16000).putShort((short) 2).putShort((short) 16).put("data".getBytes()).putInt(pcm.length * 2);
        for (short s : pcm) b.putShort(s);
        java.nio.file.Files.write(java.nio.file.Paths.get(path), b.array());
    }
}
