/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

/**
 * The Xplore 1's receive audio on its second UART is framed (from QuickChat's PcmPlayer, q0.e0.onDataReceived and
 * t0.g.c): 167-byte packets {@code BB 00 h h h h <160 bytes of 8 kHz mono 16-bit LE PCM> 44}, i.e. 10 ms each.
 * Control-style frames ({@code 68 … 10}) can appear on the same port and are skipped. This finds the packets in an
 * arbitrary byte stream (any read size, resyncs after garbage) and hands out the 160-byte payloads.
 */
public final class PcmFramer {
    public static final int FRAME = 167, HEADER = 6, PAYLOAD = 160;
    public interface Out { void pcm(byte[] b, int off, int len); }

    private final byte[] buf = new byte[FRAME * 4];
    private int fill;
    public long frames, skipped;

    public void feed(byte[] b, int n, Out out) {
        for (int i = 0; i < n; i++) {
            if (fill == buf.length) { System.arraycopy(buf, 1, buf, 0, fill - 1); fill--; skipped++; }
            buf[fill++] = b[i];
            while (fill >= 2 && !(buf[0] == (byte) 0xBB && buf[1] == 0x00)) { System.arraycopy(buf, 1, buf, 0, --fill); skipped++; }
            if (fill == 1 && buf[0] != (byte) 0xBB) { fill = 0; skipped++; }
            if (fill >= FRAME) {
                if (buf[FRAME - 1] == 0x44) { out.pcm(buf, HEADER, PAYLOAD); frames++; System.arraycopy(buf, FRAME, buf, 0, fill - FRAME); fill -= FRAME; }
                else { System.arraycopy(buf, 1, buf, 0, --fill); skipped++; }            // false start: look for the next BB 00
            }
        }
    }
}
