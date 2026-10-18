package com.macdmr.radio;

import android.content.Context;
import android.content.SharedPreferences;
import android.location.Location;
import android.util.Log;

import com.macdmr.radio.pkt.AFSKDecoder;
import com.macdmr.radio.pkt.AFSKGenerator;
import com.macdmr.radio.pkt.APRSPacketDecoder;
import com.macdmr.radio.pkt.Ax25;
import com.macdmr.radio.pkt.DTMFDecoder;
import com.macdmr.radio.pkt.KissTnc;
import com.macdmr.radio.pkt.PacketStore;
import com.macdmr.radio.pkt.SAMEDecoder;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * Packet modes on the analog FM path: APRS (Bell 202 AFSK decode of everything the squelch passes, messages,
 * position beacons, auto-ack, fill-in digipeater, KISS TNC for APRSdroid/YAAC), DTMF decode + send, and NOAA
 * SAME weather alerts. Audio in is the 8 kHz mono RX stream; audio out goes through the host's one-shot
 * transmitter, which keys the radio, plays the PCM and releases.
 *
 * TX timing (measured on this radio): the TX path needs ~1.5 s to settle after key-up before AFSK decodes,
 * so every frame is led by a 1.6 s steady 1200 Hz tone and sent twice.
 */
public final class PacketEngine {
    public interface Host {
        Context context();
        boolean analogRx();                      // current channel is FM
        int rxFreqHz();
        int channelNumber(); String channelName();
        boolean txBusy();
        /** Key, play the 8 kHz mono PCM, release; {@code onDone} runs after release (on the service worker). */
        void transmitPcm(short[] pcm, String label, Runnable onDone);
        Location location();
        void event(String line);                 // a history line / toast on the intercom
        void notifyUser(String title, String text, boolean alert);
    }

    public static final int TX_LEAD_MS = 1600, TX_REPS = 2, TX_GAP_MS = 250;
    public static final int APRS_FREQ_HZ = 144_390_000;
    private static final String TAG = "PacketEngine";
    private static final int SR = 8000, WINDOW = SR * 2, OVERLAP = SR;

    private final Host host;
    private final SharedPreferences prefs;
    private final PacketStore store;
    private final ExecutorService decoder = Executors.newSingleThreadExecutor(r -> { Thread t = new Thread(r, "aprs-decode"); t.setDaemon(true); return t; });
    private final KissTnc kiss = new KissTnc();
    private final LinkedBlockingQueue<byte[]> kissTxQueue = new LinkedBlockingQueue<>(32);
    private volatile boolean monitor;                      // APRS monitoring mode (parked on 144.390 by the service)
    private final short[] window = new short[WINDOW];
    private int fill;
    private short[] overlapTail;
    private long lastWindowMs;
    private final LinkedList<Object[]> recent = new LinkedList<>();
    private final HashMap<String, Long> digiSeen = new HashMap<>(), ackSent = new HashMap<>();
    private final Random rnd = new Random();
    private DTMFDecoder dtmf;
    private SAMEDecoder same;
    private volatile long lastDtmfDigitMs;
    private volatile int lastAttnLevel;

    public PacketEngine(Host h) {
        host = h;
        prefs = h.context().getSharedPreferences("packet", Context.MODE_PRIVATE);
        store = new PacketStore(h.context());
        Thread sender = new Thread(() -> {
            while (true) {
                try {
                    byte[] f = kissTxQueue.poll(500, TimeUnit.MILLISECONDS);
                    if (f == null || !kiss.isActive()) continue;
                    int guard = 0; while (host.txBusy() && guard++ < 100) Thread.sleep(100);
                    final Object lock = new Object();
                    synchronized (lock) { txRaw(f, "KISS " + f.length + " B", TX_REPS, () -> { synchronized (lock) { lock.notifyAll(); } }); lock.wait(35000); }
                    Thread.sleep(800);
                } catch (InterruptedException e) { break; } catch (Throwable t) { Log.w(TAG, "kiss tx: " + t); }
            }
        }, "kiss-tx");
        sender.setDaemon(true); sender.start();
    }

    public PacketStore store() { return store; }

    // ---- settings -------------------------------------------------------------------------------

    public String callsign() { return prefs.getString("callsign", "").trim().toUpperCase(Locale.US); }
    public int ssid() { return prefs.getInt("ssid", 7); }
    public String myCall() { return callsign() + (ssid() != 0 ? "-" + ssid() : ""); }
    public boolean callsignSet() { String c = callsign(); return !c.isEmpty() && !"N0CALL".equals(c); }
    public char symTable() { return prefs.getString("symTable", "/").charAt(0); }
    public char symCode() { return prefs.getString("symCode", "[").charAt(0); }
    public String comment() { return prefs.getString("comment", "DMR Radio"); }
    public String[] path() { String p = prefs.getString("path", "WIDE1-1,WIDE2-1").trim(); return p.isEmpty() ? new String[0] : p.split("\\s*,\\s*"); }
    public int passiveMode() { return prefs.getInt("passive", 2); }       // 0 off, 1 flagged channels, 2 every analog channel
    public boolean autoAck() { return prefs.getBoolean("autoAck", true); }
    public boolean digipeat() { return prefs.getBoolean("digipeat", false); }
    public int kissPort() { return prefs.getInt("kissPort", 8001); }
    public boolean dtmfEnabled() { return prefs.getBoolean("dtmf", true); }
    public boolean wxEnabled() { return prefs.getBoolean("wx", true); }
    public SharedPreferences prefs() { return prefs; }
    public boolean flagged(int channel) { return prefs.getStringSet("flagged", java.util.Collections.<String>emptySet()).contains(String.valueOf(channel)); }
    public void setFlagged(int channel, boolean on) {
        java.util.Set<String> s = new java.util.HashSet<>(prefs.getStringSet("flagged", java.util.Collections.<String>emptySet()));
        if (on) s.add(String.valueOf(channel)); else s.remove(String.valueOf(channel));
        prefs.edit().putStringSet("flagged", s).apply();
    }

    public boolean monitoring() { return monitor; }
    public void setMonitoring(boolean on) { monitor = on; if (!on) { fill = 0; overlapTail = null; } }
    public KissTnc kiss() { return kiss; }

    public String kissStart() {
        if (kiss.isActive()) return "KISS TNC already running on 127.0.0.1:" + kiss.port();
        String err = kiss.start(kissPort(), f -> { if (!kissTxQueue.offer(f)) Log.w(TAG, "kiss queue full"); });
        return err != null ? err : null;
    }
    public void kissStop() { kiss.stop(); kissTxQueue.clear(); }

    private boolean passiveWanted() {
        int m = passiveMode();
        if (m <= 0) return false;
        return m == 2 || flagged(host.channelNumber());
    }

    // ---- RX ---------------------------------------------------------------------------------------

    /** Every 8 kHz mono block the radio delivers; {@code open} = the (soft) squelch passes it. */
    public void feed(byte[] mono, int n, boolean open) {
        if (!host.analogRx()) { fill = 0; return; }
        if (!open) return;
        try {
            if (dtmfEnabled()) {
                if (dtmf == null) dtmf = new DTMFDecoder(SR, false, dtmfListener);
                dtmf.processAudio(mono, n);
            }
            int f = host.rxFreqHz();
            if (wxEnabled() && f >= 162_400_000 && f <= 162_550_000) {
                if (same == null) same = new SAMEDecoder(SR, false, sameListener);
                same.processAudio(mono, n);
            }
            if (monitor || kiss.isActive() || passiveWanted()) {
                for (int i = 0; i + 1 < n && fill < WINDOW; i += 2) window[fill++] = (short) ((mono[i] & 0xFF) | (mono[i + 1] << 8));
                if (fill >= WINDOW) {
                    long now = System.currentTimeMillis();
                    if (now - lastWindowMs > 5000) overlapTail = null;
                    lastWindowMs = now;
                    short[] tail = overlapTail; int tl = tail == null ? 0 : tail.length;
                    final short[] samples = new short[tl + WINDOW];
                    if (tl > 0) System.arraycopy(tail, 0, samples, 0, tl);
                    System.arraycopy(window, 0, samples, tl, WINDOW);
                    overlapTail = Arrays.copyOfRange(window, WINDOW - OVERLAP, WINDOW);
                    fill = 0;
                    decoder.execute(() -> decodeWindow(samples));
                }
            }
        } catch (Throwable t) { Log.w(TAG, "feed: " + t); }
    }

    /** The AFSK decoder works at 48 kHz: 6x linear upsample of the 8 kHz window. */
    private static short[] up6(short[] in) {
        short[] out = new short[in.length * 6];
        for (int i = 0; i < in.length; i++) {
            int a = in[i], b = i + 1 < in.length ? in[i + 1] : in[i];
            for (int k = 0; k < 6; k++) out[i * 6 + k] = (short) (a + (b - a) * k / 6);
        }
        return out;
    }

    private void decodeWindow(short[] samples) {
        try {
            List<byte[]> frames = AFSKDecoder.decode(up6(samples));
            for (byte[] frame : frames) {
                if (duplicate(frame)) continue;
                kiss.deliver(frame);
                maybeDigipeat(frame);
                APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decode(frame);
                String from = p.isValid ? p.sourceCallsign + (p.sourceSSID != 0 ? "-" + p.sourceSSID : "") : Ax25.addr(frame, 7);
                if (!p.isValid) { host.event("📡 " + Ax25.tnc2(frame)); continue; }
                long now = System.currentTimeMillis();
                if (p.hasPosition) { store.storeStation(p, now); store.log("pos", from, p.destCallsign, APRSPacketDecoder.describe(p), null, false); }
                if (p.isMessage()) messageReceived(p, from);
                else if (p.status != null) store.log("status", from, p.destCallsign, p.status, null, false);
                else if (!p.hasPosition) store.log("other", from, p.destCallsign, p.rawInfo, null, false);
                host.event("📡 " + from + ": " + APRSPacketDecoder.describe(p));
            }
        } catch (Throwable t) { Log.w(TAG, "decode: " + t); }
    }

    private synchronized boolean duplicate(byte[] frame) {
        long now = System.currentTimeMillis();
        while (!recent.isEmpty() && now - (Long) recent.getFirst()[1] > 2000) recent.removeFirst();
        for (Object[] e : recent) if (Arrays.equals((byte[]) e[0], frame)) return true;
        recent.addLast(new Object[] { frame.clone(), now });
        return false;
    }

    private boolean addressedToMe(String to) {
        if (to == null || !callsignSet()) return false;
        String t = to.trim().toUpperCase(Locale.US), c = callsign(); int s = ssid();
        return t.equals(c + "-" + s) || (s == 0 && (t.equals(c) || t.equals(c + "-0")));
    }

    private void messageReceived(APRSPacketDecoder.APRSPacket p, String from) {
        boolean mine = addressedToMe(p.messageTo);
        boolean bulletin = p.messageTo != null && (p.messageTo.startsWith("BLN") || p.messageTo.startsWith("NWS"));
        store.log(p.isAck ? "ack" : p.isRej ? "rej" : "msg", from, p.messageTo, p.messageText, p.messageId, mine);
        if (mine && !p.isAck && !p.isRej && p.messageId != null) maybeAutoAck(from, p.messageId);
        if ((mine || bulletin) && !p.isAck && !p.isRej) host.notifyUser((mine ? "APRS message from " : "APRS bulletin from ") + from, p.messageText, false);
    }

    /** APRS protocol: a message with an {id must be acked or the sender keeps retrying (monitoring mode only, not under KISS). */
    private void maybeAutoAck(final String from, final String id) {
        if (!monitor || kiss.isActive() || !autoAck() || !callsignSet()) return;
        String key = from + "{" + id; long now = System.currentTimeMillis();
        synchronized (ackSent) { Long last = ackSent.get(key); ackSent.put(key, now); if (ackSent.size() > 200) ackSent.clear(); if (last != null && now - last < 10000) return; }
        final String info = Ax25.messageInfo(from, "ack" + id, 0);
        new Thread(() -> {
            try { Thread.sleep(1500 + rnd.nextInt(1500)); } catch (InterruptedException ignored) { }
            if (!monitor || kiss.isActive()) return;
            txInfo(info, new String[] { "WIDE1-1" }, "ack " + id + " to " + from, 1, () -> store.log("ack-tx", myCall(), from, "ack" + id, id, false));
        }, "aprs-ack").start();
    }

    /** Fill-in digipeater: repeat once when the first unused hop is WIDE1-1 (or us), replaced by MYCALL*. */
    private void maybeDigipeat(final byte[] frame) {
        try {
            if (!monitor || kiss.isActive() || !digipeat() || !callsignSet() || frame.length < 16) return;
            String my = myCall(), c = callsign(); int s = ssid();
            String dst = Ax25.addr(frame, 0), src = Ax25.addr(frame, 7);
            if (src.equals(my)) return;
            boolean last = (frame[13] & 0x01) != 0; int off = 14, hop = -1;
            while (!last && off + 7 <= frame.length) {
                String d = Ax25.addr(frame, off); boolean used = (frame[off + 6] & 0x80) != 0;
                if ((d.equals(c) || d.equals(my)) && used) return;
                if (!used && hop < 0) { if (d.equals("WIDE1-1") || d.equals(my) || (s == 0 && d.equals(c))) hop = off; else return; }
                last = (frame[off + 6] & 0x01) != 0; off += 7;
            }
            if (hop < 0 || off + 2 > frame.length) return;
            String key = src + ":" + new String(frame, off + 2, frame.length - off - 2, java.nio.charset.StandardCharsets.ISO_8859_1);
            long now = System.currentTimeMillis();
            synchronized (digiSeen) { Long t = digiSeen.get(key); if (t != null && now - t < 30000) return; digiSeen.put(key, now); if (digiSeen.size() > 500) digiSeen.clear(); }
            final byte[] out = frame.clone();
            String call = (c + "      ").substring(0, 6);
            for (int i = 0; i < 6; i++) out[hop + i] = (byte) ((call.charAt(i) << 1) & 0xFF);
            out[hop + 6] = (byte) ((frame[hop + 6] & 0x01) | 0x60 | ((s & 0x0F) << 1) | 0x80);
            final String label = "digi " + src + ">" + dst;
            new Thread(() -> {
                try { Thread.sleep(500 + rnd.nextInt(1000)); } catch (InterruptedException ignored) { }
                if (!monitor || kiss.isActive()) return;
                txRaw(out, label, 1, () -> store.log("digi", src, dst, "repeated via " + my, null, false));
            }, "aprs-digi").start();
        } catch (Throwable t) { Log.w(TAG, "digi: " + t); }
    }

    private final DTMFDecoder.Listener dtmfListener = new DTMFDecoder.Listener() {
        @Override public void onDigit(char digit) {
            lastDtmfDigitMs = System.currentTimeMillis();
            new Thread(() -> {       // the decoder only closes a sequence while audio flows; flush when the squelch shut right after the last key
                try { Thread.sleep(DTMFDecoder.SEQUENCE_GAP_MS + 300); } catch (InterruptedException ignored) { }
                if (System.currentTimeMillis() - lastDtmfDigitMs >= DTMFDecoder.SEQUENCE_GAP_MS + 250) { DTMFDecoder d = dtmf; if (d != null) d.flush(); }
            }, "dtmf-flush").start();
        }
        @Override public void onSequence(String digits, long startMs, long endMs) {
            store.dtmf(digits, host.channelNumber(), host.channelName());
            host.event("📟 DTMF " + digits);
        }
    };

    private final SAMEDecoder.Listener sameListener = new SAMEDecoder.Listener() {
        @Override public void onMessage(SAMEDecoder.Message m) {
            store.alert(m.event, m.summary(), m.raw, m.eom);
            if (!m.eom) host.notifyUser("⛈️ " + (m.eventName.isEmpty() ? m.event : m.eventName), m.summary(), true);
            host.event(m.eom ? "⛈️ Weather alert: end of message" : "⛈️ " + m.summary());
        }
        @Override public void onAttentionTone(boolean on) { if (on) host.event("⛈️ Weather alert attention tone"); }
    };

    // ---- TX ---------------------------------------------------------------------------------------

    /** AFSK-modulate a complete frame (with FCS), prefix the settling lead, repeat, and transmit. */
    private void txFrame(byte[] frame, String label, int reps, Runnable onDone) {
        short[] afsk = AFSKGenerator.generateAFSKWithNRZI(frame);
        int lead = SR * TX_LEAD_MS / 1000, gap = SR * TX_GAP_MS / 1000;
        short[] src = new short[lead + reps * (afsk.length + gap)];
        for (int i = 0; i < lead; i++) src[i] = (short) (30000 * Math.sin(2.0 * Math.PI * 1200 * i / SR));
        int p = lead;
        for (int r = 0; r < reps; r++) { System.arraycopy(afsk, 0, src, p, afsk.length); p += afsk.length + gap; }
        host.transmitPcm(src, label, onDone);
    }

    private void txRaw(byte[] noFcs, String label, int reps, Runnable onDone) { txFrame(Ax25.appendFcs(noFcs), label, reps, onDone); }

    private void txInfo(String info, String[] path, String label, int reps, Runnable onDone) {
        byte[] frame = Ax25.buildUiFrame("APZDMR", 0, callsign(), ssid(), path, info.getBytes(java.nio.charset.StandardCharsets.US_ASCII));
        txFrame(frame, label, reps, onDone);
    }

    /** Send an APRS message (numbered so the other side acks it). Returns an error text or null. */
    public String sendMessage(final String to, final String text) {
        if (!callsignSet()) return "Set your callsign first (PKT → APRS settings)";
        if (to == null || to.trim().isEmpty() || text == null || text.trim().isEmpty()) return "Addressee and text are needed";
        if (text.length() > 67) return "APRS messages are at most 67 characters";
        final int id = prefs.getInt("msgId", 0) % 999 + 1; prefs.edit().putInt("msgId", id).apply();
        final String addressee = to.trim().toUpperCase(Locale.US);
        txInfo(Ax25.messageInfo(addressee, text.trim(), id), path(), "APRS message to " + addressee, TX_REPS,
                () -> { store.log("msg-tx", myCall(), addressee, text.trim(), String.valueOf(id), false); host.event("📡 Sent to " + addressee + ": " + text.trim()); });
        return null;
    }

    /** Transmit one position report from the phone's last fix. Returns an error text or null. */
    public String sendBeacon() {
        if (!callsignSet()) return "Set your callsign first (PKT → APRS settings)";
        Location l = host.location();
        if (l == null) return "No position fix yet (turn on location and open Maps once)";
        final String info = Ax25.positionInfo(l.getLatitude(), l.getLongitude(), symTable(), symCode(), comment());
        txInfo(info, path(), "position beacon", TX_REPS, () -> { store.log("beacon", myCall(), "APZDMR", info, null, false); host.event("📡 Beacon sent " + String.format(Locale.US, "%.4f, %.4f", l.getLatitude(), l.getLongitude())); });
        return null;
    }

    /** Key the radio and send a DTMF sequence (100 ms tones, 60 ms gaps) after a short silent lead. */
    public String sendDtmf(String seq) {
        if (seq == null) return "Nothing to send";
        String s = seq.toUpperCase(Locale.US).replaceAll("[^0-9A-D*#]", "");
        if (s.isEmpty()) return "Only 0-9, A-D, * and # can be sent";
        final String fs = s;
        host.transmitPcm(dtmfPcm(s, 100, 60), "DTMF " + s, () -> host.event("📟 Sent DTMF " + fs));
        return null;
    }

    static short[] dtmfPcm(String seq, int toneMs, int gapMs) {
        final double[] low = { 697, 770, 852, 941 }, high = { 1209, 1336, 1477, 1633 };
        final String[] rows = { "123A", "456B", "789C", "*0#D" };
        int toneN = SR * toneMs / 1000, gapN = SR * gapMs / 1000, lead = SR * TX_LEAD_MS / 1000;
        short[] out = new short[lead + seq.length() * (toneN + gapN) + SR * 200 / 1000];
        int pos = lead;
        for (char c : seq.toCharArray()) {
            int r = -1, col = -1;
            for (int i = 0; i < 4; i++) { int j = rows[i].indexOf(c); if (j >= 0) { r = i; col = j; } }
            if (r >= 0) {
                int edge = SR * 5 / 1000;
                for (int i = 0; i < toneN; i++) {
                    double v = 0.38 * 32767 * (Math.sin(2 * Math.PI * low[r] * i / SR) + Math.sin(2 * Math.PI * high[col] * i / SR));
                    if (i < edge) v *= 0.5 * (1 - Math.cos(Math.PI * i / edge)); else if (i >= toneN - edge) v *= 0.5 * (1 - Math.cos(Math.PI * (toneN - 1 - i) / edge));
                    out[pos + i] = (short) Math.max(-32768, Math.min(32767, v));
                }
            }
            pos += toneN + gapN;
        }
        return out;
    }
}
