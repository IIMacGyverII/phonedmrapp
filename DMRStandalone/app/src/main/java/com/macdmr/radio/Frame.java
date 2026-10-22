/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import java.util.Locale;

/**
 * One MCU frame: {@code 68 cmd rw sr ck(2,BE) len(2,BE) body… 10}.
 * Checksum = 16-bit one's-complement sum over the whole frame with ck=0 (odd trailing byte << 8),
 * folded, then ^0xFFFF — identical in PriInterPhone (PacketEncoder) and the Blackview SDK (CRC.checkSum).
 */
public final class Frame {
    public static final byte HEAD = 0x68, TAIL = 0x10;

    public final int cmd, rw, sr;
    public final byte[] body;

    public Frame(int cmd, int rw, int sr, byte[] body) {
        this.cmd = cmd & 0xFF; this.rw = rw; this.sr = sr; this.body = body == null ? new byte[0] : body;
    }

    /** App → MCU frames always carry rw=1 (write) and sr=1 (set). */
    public static Frame request(int cmd, byte... body) { return new Frame(cmd, 1, 1, body); }

    public byte[] encode() {
        byte[] f = new byte[9 + body.length];
        f[0] = HEAD; f[1] = (byte) cmd; f[2] = (byte) rw; f[3] = (byte) sr;
        f[6] = (byte) (body.length >> 8); f[7] = (byte) body.length;
        System.arraycopy(body, 0, f, 8, body.length);
        f[f.length - 1] = TAIL;
        int ck = checksum(f, 0, f.length);
        f[4] = (byte) (ck >> 8); f[5] = (byte) ck;
        return f;
    }

    /** Checksum of a frame image whose ck bytes (4,5) are ignored/zero. */
    static int checksum(byte[] f, int off, int len) {
        long sum = 0; int i = 0;
        for (; i + 1 < len; i += 2) {
            int hi = (i == 4) ? 0 : (f[off + i] & 0xFF);
            int lo = (i + 1 == 5) ? 0 : (f[off + i + 1] & 0xFF);
            sum += (hi << 8) | lo;
        }
        if (i < len) sum += (f[off + i] & 0xFF) << 8;
        while ((sum >> 16) > 0) sum = (sum & 0xFFFF) + (sum >> 16);
        return ((int) sum) ^ 0xFFFF;
    }

    /**
     * Try to decode a frame starting at {@code off}. Returns the frame length consumed, 0 if more bytes are
     * needed, or -1 if the bytes at {@code off} are not a valid frame (caller skips one byte).
     */
    public static int tryDecode(byte[] b, int off, int avail, Frame[] out) {
        if (avail < 9) return b[off] == HEAD ? 0 : -1;
        if (b[off] != HEAD) return -1;
        int len = ((b[off + 6] & 0xFF) << 8) | (b[off + 7] & 0xFF);
        if (len > 1024) return -1;
        int total = 9 + len;
        if (avail < total) return 0;
        if (b[off + total - 1] != TAIL) return -1;
        int ck = ((b[off + 4] & 0xFF) << 8) | (b[off + 5] & 0xFF);
        if (checksum(b, off, total) != ck) return -1;
        byte[] body = new byte[len];
        System.arraycopy(b, off + 8, body, 0, len);
        out[0] = new Frame(b[off + 1] & 0xFF, b[off + 2] & 0xFF, b[off + 3] & 0xFF, body);
        return total;
    }

    public static String hex(byte[] b, int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) sb.append(String.format(Locale.US, "%02X ", b[i] & 0xFF));
        return sb.toString().trim();
    }

    @Override public String toString() {
        return String.format(Locale.US, "cmd=0x%02X rw=%d sr=%d len=%d [%s]", cmd, rw, sr, body.length, hex(body, Math.min(body.length, 24)));
    }
}
