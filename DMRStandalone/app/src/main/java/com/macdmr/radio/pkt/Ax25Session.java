package com.macdmr.radio.pkt;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * One AX.25 2.0 connected-mode link (modulo 8), for a terminal session with a packet BBS or node: SABM/UA to
 * connect, numbered I frames acknowledged by RR (or by the other side's own I frames), REJ for a gap, DISC/UA or DM
 * to end. Timers are long because every transmission on this radio starts with a 1.6 s settling tone and decoding
 * lags by a couple of seconds: T1 (no acknowledgement) 15 s, up to 6 tries; acknowledgements wait T2 2 s so that
 * several frames are answered at once. Frames go out without FCS; the link adds it.
 */
public final class Ax25Session {
    public interface Link {
        /** Transmit these frames (address, control, PID, info; no FCS) in one key-up. */
        void send(List<byte[]> frames);
        /** Text the other station sent. */
        void received(String text);
        /** "connecting", "connected", "disconnected: why". */
        void state(String state);
    }

    public enum State { DISCONNECTED, CONNECTING, CONNECTED, DISCONNECTING }

    public static final int PACLEN = 128, WINDOW = 4, N2 = 6;
    public static final long T1_MS = 15_000, T2_MS = 2_000;
    private static final int SABM = 0x2F, DISC = 0x43, UA = 0x63, DM = 0x0F, FRMR = 0x87, UI = 0x03, PF = 0x10;
    private static final int RR = 0x01, RNR = 0x05, REJ = 0x09;

    private final Link link;
    private final String myCall; private final int mySsid;
    private String peer = ""; private int peerSsid; private String[] via = new String[0];
    private State state = State.DISCONNECTED;
    private int vs, va, vr, tries;                         // send state, acknowledged state, receive state
    private final List<byte[]> queue = new ArrayList<>(); // info fields not sent yet
    private final List<byte[]> unacked = new ArrayList<>(); // sent I-frame info, oldest first (numbers va..vs-1)
    private long t1At, t2At; private boolean rejSent, acceptIncoming;

    public Ax25Session(String myCall, int mySsid, Link link) { this.myCall = myCall.toUpperCase(Locale.US); this.mySsid = mySsid; this.link = link; }

    public synchronized State state() { return state; }
    public synchronized String peer() { return peer + (peerSsid != 0 ? "-" + peerSsid : ""); }
    public synchronized void setAcceptIncoming(boolean on) { acceptIncoming = on; }
    public synchronized int pending() { return queue.size() + unacked.size(); }

    // ---- user actions ---------------------------------------------------------------------------

    public synchronized void connect(String call, String[] path, long now) {
        if (state != State.DISCONNECTED) return;
        String c = call.trim().toUpperCase(Locale.US); int d = c.indexOf('-');
        peer = d > 0 ? c.substring(0, d) : c; peerSsid = d > 0 ? Integer.parseInt(c.substring(d + 1)) & 15 : 0;
        via = path == null ? new String[0] : path;
        reset(); state = State.CONNECTING; tries = 1;
        send(u(SABM | PF, true)); t1At = now + T1_MS;
        link.state("connecting to " + peer());
    }

    public synchronized void disconnect(long now) {
        if (state == State.DISCONNECTED) return;
        if (state == State.CONNECTING) { state = State.DISCONNECTED; reset(); link.state("disconnected: cancelled"); return; }   // reset stops the retry timer
        state = State.DISCONNECTING; tries = 1; queue.clear();
        send(u(DISC | PF, true)); t1At = now + T1_MS;
        link.state("disconnecting");
    }

    /** Queue text (a line ending in CR, as BBSs expect); it is sent in PACLEN pieces. */
    public synchronized void sendText(String text, long now) {
        if (state != State.CONNECTED) return;
        byte[] b = text.replace("\n", "\r").getBytes(StandardCharsets.ISO_8859_1);
        for (int i = 0; i < b.length; i += PACLEN) { int n = Math.min(PACLEN, b.length - i); byte[] p = new byte[n]; System.arraycopy(b, i, p, 0, n); queue.add(p); }
        pump(now);
    }

    // ---- timers (call every half second or so) --------------------------------------------------

    public synchronized void tick(long now) {
        if (t2At != 0 && now >= t2At) { t2At = 0; if (state == State.CONNECTED) send(s(RR, false, false)); }
        if (state == State.DISCONNECTED) { t1At = t2At = 0; return; }
        if (t1At == 0 || now < t1At) return;
        if (++tries > N2) {
            State was = state; state = State.DISCONNECTED; reset();
            link.state("disconnected: " + (was == State.CONNECTING ? "no answer from " + peer() : "link lost (no acknowledgement after " + N2 + " tries)"));
            return;
        }
        switch (state) {
            case CONNECTING: send(u(SABM | PF, true)); break;
            case DISCONNECTING: send(u(DISC | PF, true)); break;
            case CONNECTED:
                if (unacked.isEmpty()) { t1At = 0; return; }
                List<byte[]> out = new ArrayList<>();                     // go back to the oldest unacknowledged frame, poll on the last
                for (int i = 0; i < unacked.size(); i++) out.add(iFrame((va + i) & 7, unacked.get(i), i == unacked.size() - 1));
                link.send(out); t2At = 0;
                break;
            default: return;
        }
        t1At = now + T1_MS;
    }

    // ---- received frames ------------------------------------------------------------------------

    /** A frame addressed to us (no FCS). Returns false when it is not for this session. */
    public synchronized boolean receive(byte[] f, long now) {
        if (f == null || f.length < 15) return false;
        String dst = addr(f, 0); int dSsid = (f[6] >> 1) & 15;
        if (!dst.equals(myCall) || dSsid != mySsid) return false;
        String src = addr(f, 7); int sSsid = (f[13] >> 1) & 15;
        int off = 14; List<String> digis = new ArrayList<>();
        boolean last = (f[13] & 1) != 0;
        while (!last && off + 7 <= f.length) { digis.add(addr(f, off) + (((f[off + 6] >> 1) & 15) != 0 ? "-" + ((f[off + 6] >> 1) & 15) : "")); last = (f[off + 6] & 1) != 0; off += 7; }
        if (off >= f.length) return false;
        boolean command = (f[6] & 0x80) != 0 && (f[13] & 0x80) == 0;
        int ctl = f[off] & 0xFF; boolean pf = (ctl & PF) != 0;
        boolean fromPeer = src.equals(peer) && sSsid == peerSsid;

        if ((ctl & 0x03) == 0x03) {                                         // U frame
            int type = ctl & ~PF;
            if (type == UI) return false;
            if (type == SABM) {
                if (state == State.DISCONNECTED && !acceptIncoming) { reply(src, sSsid, digis, u(DM | (pf ? PF : 0), false)); return true; }
                if (state != State.DISCONNECTED && !fromPeer) { reply(src, sSsid, digis, u(DM | (pf ? PF : 0), false)); return true; }
                peer = src; peerSsid = sSsid; via = reverse(digis);
                boolean fresh = state != State.CONNECTED; reset(); state = State.CONNECTED;
                send(u(UA | (pf ? PF : 0), false));
                link.state("connected to " + peer() + (fresh ? " (they called)" : ""));
                return true;
            }
            if (!fromPeer) return true;
            if (type == UA) {
                if (state == State.CONNECTING) { state = State.CONNECTED; t1At = 0; tries = 0; link.state("connected to " + peer()); pump(now); }
                else if (state == State.DISCONNECTING) { state = State.DISCONNECTED; reset(); link.state("disconnected"); }
                return true;
            }
            if (type == DM) { if (state != State.DISCONNECTED) { State was = state; state = State.DISCONNECTED; reset(); link.state(was == State.CONNECTING ? "disconnected: " + peer() + " is busy or refused" : "disconnected"); } return true; }
            if (type == DISC) { send(u(UA | (pf ? PF : 0), false)); if (state != State.DISCONNECTED) { state = State.DISCONNECTED; reset(); link.state("disconnected by " + peer()); } return true; }
            if (type == FRMR) { state = State.DISCONNECTED; reset(); link.state("disconnected: frame rejected (FRMR)"); return true; }
            return true;
        }
        if (!fromPeer || state != State.CONNECTED) {
            if (state == State.DISCONNECTED && command) reply(src, sSsid, digis, u(DM | (pf ? PF : 0), false));   // not connected: tell them
            return true;
        }
        int nr = (ctl >> 5) & 7;
        if ((ctl & 1) == 0) {                                               // I frame
            int ns = (ctl >> 1) & 7;
            ackUpTo(nr, now);
            if (ns == vr) {
                vr = (vr + 1) & 7; rejSent = false;
                int pid = off + 1; byte[] info = new byte[Math.max(0, f.length - pid - 1)]; System.arraycopy(f, pid + 1, info, 0, info.length);
                link.received(new String(info, StandardCharsets.ISO_8859_1).replace("\r\n", "\n").replace('\r', '\n'));
                if (pf) send(s(RR, false, true)); else if (t2At == 0) t2At = now + T2_MS;
            } else if (!rejSent) { rejSent = true; send(s(REJ, false, pf)); }
            else if (pf) send(s(RR, false, true));
            pump(now);
            return true;
        }
        int st = ctl & 0x0F;                                                 // S frame
        if (st == REJ) { ackUpTo(nr, now); resendFrom(now); }
        else ackUpTo(nr, now);
        if (command && pf) send(s(RR, false, true));                         // answer a poll
        pump(now);
        return true;
    }

    // ---- internals --------------------------------------------------------------------------------

    private void reset() { vs = va = vr = 0; tries = 0; queue.clear(); unacked.clear(); t1At = t2At = 0; rejSent = false; }

    private void ackUpTo(int nr, long now) {
        int n = (nr - va) & 7;
        if (n > unacked.size()) return;                                     // an N(R) we never sent: ignore
        for (int i = 0; i < n; i++) unacked.remove(0);
        va = nr;
        if (n > 0) { tries = 0; t1At = unacked.isEmpty() ? 0 : now + T1_MS; }
    }

    private void resendFrom(long now) {
        if (unacked.isEmpty()) return;
        List<byte[]> out = new ArrayList<>();
        for (int i = 0; i < unacked.size(); i++) out.add(iFrame((va + i) & 7, unacked.get(i), false));
        link.send(out); t1At = now + T1_MS; t2At = 0;
    }

    /** Send queued text while the window has room; the I frames carry our acknowledgement too. */
    private void pump(long now) {
        if (state != State.CONNECTED || queue.isEmpty()) return;
        List<byte[]> out = new ArrayList<>();
        while (!queue.isEmpty() && unacked.size() < WINDOW) {
            byte[] p = queue.remove(0); unacked.add(p);
            out.add(iFrame(vs, p, false)); vs = (vs + 1) & 7;
        }
        if (out.isEmpty()) return;
        link.send(out); t2At = 0;
        if (t1At == 0) t1At = now + T1_MS;
    }

    private byte[] iFrame(int ns, byte[] info, boolean poll) {
        byte[] hdr = header(peer, peerSsid, via, true);
        byte[] f = new byte[hdr.length + 2 + info.length];
        System.arraycopy(hdr, 0, f, 0, hdr.length);
        f[hdr.length] = (byte) ((vr << 5) | (poll ? PF : 0) | (ns << 1));
        f[hdr.length + 1] = (byte) 0xF0;
        System.arraycopy(info, 0, f, hdr.length + 2, info.length);
        return f;
    }
    private byte[] s(int type, boolean command, boolean pf) { return ctl(header(peer, peerSsid, via, command), (vr << 5) | (pf ? PF : 0) | type); }
    private byte[] u(int ctl, boolean command) { return ctl(header(peer, peerSsid, via, command), ctl); }
    private static byte[] ctl(byte[] hdr, int ctl) { byte[] f = new byte[hdr.length + 1]; System.arraycopy(hdr, 0, f, 0, hdr.length); f[hdr.length] = (byte) ctl; return f; }
    private void send(byte[] f) { List<byte[]> l = new ArrayList<>(); l.add(f); link.send(l); }
    private void reply(String call, int ssid, List<String> digis, byte[] fTemplate) {
        byte[] hdr = header(call, ssid, reverse(digis), false); int ctl = fTemplate[fTemplate.length - 1] & 0xFF;
        send(ctl(hdr, ctl));
    }

    private static String[] reverse(List<String> l) { String[] r = new String[l.size()]; for (int i = 0; i < r.length; i++) r[i] = l.get(l.size() - 1 - i); return r; }

    private byte[] header(String to, int toSsid, String[] path, boolean command) {
        ByteArrayOutputStream b = new ByteArrayOutputStream();
        addr(b, to, toSsid, command, false);
        addr(b, myCall, mySsid, !command, path.length == 0);
        for (int i = 0; i < path.length; i++) {
            String p = path[i]; int d = p.indexOf('-');
            addr(b, d > 0 ? p.substring(0, d) : p, d > 0 ? Integer.parseInt(p.substring(d + 1)) : 0, false, i == path.length - 1);
        }
        return b.toByteArray();
    }
    private static void addr(ByteArrayOutputStream b, String call, int ssid, boolean cBit, boolean last) {
        String c = (call.toUpperCase(Locale.US) + "      ").substring(0, 6);
        for (int i = 0; i < 6; i++) b.write((c.charAt(i) << 1) & 0xFE);
        b.write((cBit ? 0x80 : 0) | 0x60 | ((ssid & 15) << 1) | (last ? 1 : 0));
    }
    static String addr(byte[] f, int off) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 6; i++) { char ch = (char) ((f[off + i] & 0xFF) >> 1); if (ch != ' ') sb.append(ch); }
        return sb.toString();
    }

    /** True when the frame is addressed to this call and SSID (cheap check before decoding it as APRS). */
    public static boolean addressedTo(byte[] f, String call, int ssid) {
        return f != null && f.length >= 15 && addr(f, 0).equals(call.toUpperCase(Locale.US)) && ((f[6] >> 1) & 15) == ssid;
    }
}
