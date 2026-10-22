/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import org.junit.Test;

/** Decodes Morse in a WAV named by the BENCH_IN environment variable (bench captures); does nothing otherwise. */
public class DecodeBenchMorse {
    @Test public void decode() throws Exception {
        String in = System.getenv("BENCH_IN"); if (in == null) return;
        short[] pcm = VoiceReply.readWav8k(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(in)));
        StringBuilder out = new StringBuilder();
        CwDecoder d = new CwDecoder((t, hz, wpm) -> out.append("MORSE: ").append(t).append(String.format(" (%.0f Hz, %d WPM)%n", hz, wpm)));
        d.process(pcm); d.process(new short[16000]);
        java.nio.file.Files.write(java.nio.file.Paths.get(in + ".txt"), out.toString().getBytes());
    }
}
