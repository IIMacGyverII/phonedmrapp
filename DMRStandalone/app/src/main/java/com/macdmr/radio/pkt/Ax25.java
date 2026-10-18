package com.macdmr.radio.pkt;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

/** AX.25 UI frames for APRS: address encoding, FCS, KISS framing, and the APRS info-field builders. */
public final class Ax25 {
    private Ax25() { }

    /** CRC-16-CCITT (X.25) over {@code len} bytes, as AX.25 wants it (LSB first on the wire). */
    public static int fcs(byte[] b, int len) {
        int fcs = 0xFFFF;
        for (int k = 0; k < len; k++) {
            fcs ^= (b[k] & 0xFF);
            for (int i = 0; i < 8; i++) fcs = ((fcs & 1) != 0) ? ((fcs >>> 1) ^ 0x8408) : (fcs >>> 1);
        }
        return fcs ^ 0xFFFF;
    }

    public static byte[] appendFcs(byte[] noFcs) {
        int f = fcs(noFcs, noFcs.length);
        byte[] out = new byte[noFcs.length + 2];
        System.arraycopy(noFcs, 0, out, 0, noFcs.length);
        out[noFcs.length] = (byte) (f & 0xFF); out[noFcs.length + 1] = (byte) ((f >> 8) & 0xFF);
        return out;
    }

    private static void writeAddr(ByteArrayOutputStream f, String call, int ssid, boolean last) {
        String c = (call == null ? "" : call.trim().toUpperCase(Locale.US));
        if (c.length() > 6) c = c.substring(0, 6);
        c = (c + "      ").substring(0, 6);
        for (int i = 0; i < 6; i++) f.write((c.charAt(i) << 1) & 0xFF);
        f.write(0x60 | ((ssid & 0x0F) << 1) | (last ? 0x01 : 0x00));
    }

    /**
     * A complete AX.25 UI frame (dest, src, optional path, control 0x03, PID 0xF0, info, FCS). No HDLC flags:
     * the AFSK generator adds those. Path entries are "CALL" or "CALL-SSID" (e.g. "WIDE1-1").
     */
    public static byte[] buildUiFrame(String destCall, int destSsid, String srcCall, int srcSsid, String[] path, byte[] info) {
        ByteArrayOutputStream f = new ByteArrayOutputStream();
        boolean srcIsLast = path == null || path.length == 0;
        writeAddr(f, destCall, destSsid, false);
        writeAddr(f, srcCall, srcSsid, srcIsLast);
        if (path != null) {
            for (int p = 0; p < path.length; p++) {
                String entry = path[p].trim(); String call = entry; int ssid = 0;
                int dash = entry.indexOf('-');
                if (dash > 0) { call = entry.substring(0, dash); try { ssid = Integer.parseInt(entry.substring(dash + 1).trim()); } catch (NumberFormatException ignored) { } }
                writeAddr(f, call, ssid, p == path.length - 1);
            }
        }
        f.write(0x03); f.write(0xF0);
        f.write(info, 0, info.length);
        return appendFcs(f.toByteArray());
    }

    /** "CALL-SSID" (no "-0") from an address field. */
    public static String addr(byte[] f, int off) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 6; i++) { char c = (char) ((f[off + i] & 0xFF) >> 1); if (c != ' ') sb.append(c); }
        int ssid = (f[off + 6] >> 1) & 0x0F;
        if (ssid != 0) sb.append('-').append(ssid);
        return sb.toString();
    }

    /** "SRC>DST,PATH*:info" (TNC2 monitor format) for display and logs; FCS must already be stripped. */
    public static String tnc2(byte[] f) {
        try {
            if (f == null || f.length < 16) return "";
            StringBuilder sb = new StringBuilder(addr(f, 7)).append('>').append(addr(f, 0));
            int off = 14; boolean last = (f[13] & 0x01) != 0;
            while (!last && off + 7 <= f.length) {
                sb.append(',').append(addr(f, off)); if ((f[off + 6] & 0x80) != 0) sb.append('*');
                last = (f[off + 6] & 0x01) != 0; off += 7;
            }
            if (off + 2 <= f.length) sb.append(':').append(new String(f, off + 2, f.length - off - 2, StandardCharsets.ISO_8859_1));
            return sb.toString();
        } catch (Throwable t) { return ""; }
    }

    /** APRS message: {@code :ADDRESSEE:text{id} (addressee padded to 9). */
    public static String messageInfo(String addressee, String text, int id) {
        String a = addressee == null ? "" : addressee.trim().toUpperCase(Locale.US);
        if (a.length() > 9) a = a.substring(0, 9);
        StringBuilder sb = new StringBuilder(":").append(a);
        for (int i = a.length(); i < 9; i++) sb.append(' ');
        sb.append(':').append(text == null ? "" : text);
        if (id > 0) sb.append('{').append(id);
        return sb.toString();
    }

    /** Uncompressed, messaging-capable position report without timestamp: {@code =DDMM.hhN/DDDMM.hhW>comment}. */
    public static String positionInfo(double lat, double lon, char symTable, char symCode, String comment) {
        char ns = lat >= 0 ? 'N' : 'S'; double aLat = Math.abs(lat); int latDeg = (int) aLat; double latMin = (aLat - latDeg) * 60.0;
        char ew = lon >= 0 ? 'E' : 'W'; double aLon = Math.abs(lon); int lonDeg = (int) aLon; double lonMin = (aLon - lonDeg) * 60.0;
        if (latMin >= 59.995) { latMin = 0; latDeg++; }
        if (lonMin >= 59.995) { lonMin = 0; lonDeg++; }
        return String.format(Locale.US, "=%02d%05.2f%c%c%03d%05.2f%c%c%s", latDeg, latMin, ns, symTable, lonDeg, lonMin, ew, symCode, comment == null ? "" : comment);
    }

    /** KISS port-0 data frame: FEND 0x00 escaped-bytes FEND. */
    public static byte[] kissEncode(byte[] ax25) {
        ByteArrayOutputStream k = new ByteArrayOutputStream(ax25.length + 4);
        k.write(0xC0); k.write(0x00);
        for (byte b : ax25) {
            int v = b & 0xFF;
            if (v == 0xC0) { k.write(0xDB); k.write(0xDC); } else if (v == 0xDB) { k.write(0xDB); k.write(0xDD); } else k.write(v);
        }
        k.write(0xC0);
        return k.toByteArray();
    }
}
