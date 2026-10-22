/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.AudioTrack;
import android.media.MediaRecorder;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * PCM over a second UART (Blackview Xplore 1 family: {@code /dev/ttyS1} at 230400 baud, 8 kHz mono 16-bit little-endian).
 * Receive arrives framed (see {@link PcmFramer}); transmit is raw 160-byte blocks every 10 ms, as QuickChat sends it. RX bytes are played through an AudioTrack and handed to
 * the sink as stereo-duplicated frames, so the rest of the app is identical to the Ulefone path.
 *
 * <p><b>Receive and transmit audio not yet confirmed on hardware.</b> The first owner's trial (2026-10-21) opened the
 * port at 230400 (stty fallback) but saw no bytes: the module had no channel and its PTT line was never set to receive
 * (QuickChat writes intercom_ptt_control 1 for receive; see DeviceProfile.lineSetup). Framing above is from QuickChat's code.
 */
public final class UartPcmAudio implements AudioBackend {
    private static final int SR = 8000, PACKET = 80;            // 10 ms of 8 kHz mono 16-bit: QuickChat's 160-byte transmit block
    private final String path; private final int baud;
    private volatile Sink sink; private volatile Gate gate;
    private InputStream in; private OutputStream out;
    private com.pri.prizeinterphone.serial.port.SerialPort nativePort;
    private AudioTrack track; private AudioRecord rec;
    private volatile boolean rxRunning, txRunning;
    private Thread rxThread, txThread;

    public UartPcmAudio(String path, int baud) { this.path = path; this.baud = baud; }

    @Override public void setSink(Sink s) { sink = s; }
    @Override public void setGate(Gate g) { gate = g; }

    private synchronized void open() throws Exception {
        if (in != null) return;
        if (com.pri.prizeinterphone.serial.port.SerialPort.isLoaded()) {
            nativePort = com.pri.prizeinterphone.serial.port.SerialPort.openPort(path, baud);
            if (nativePort != null) { in = new FileInputStream(nativePort.fd()); out = new FileOutputStream(nativePort.fd()); return; }
        }
        in = new FileInputStream(path); out = new FileOutputStream(path);
    }

    @Override public synchronized String startRx(boolean speaker) {
        try {
            open();
            if (track == null) {
                int min = AudioTrack.getMinBufferSize(SR, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
                track = new AudioTrack(new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA).setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build(),
                        new AudioFormat.Builder().setSampleRate(SR).setChannelMask(AudioFormat.CHANNEL_OUT_MONO).setEncoding(AudioFormat.ENCODING_PCM_16BIT).build(),
                        Math.max(min * 2, 4096), AudioTrack.MODE_STREAM, AudioManager.AUDIO_SESSION_ID_GENERATE);
                track.play();
            }
            rxRunning = true;
            rxThread = new Thread(() -> {
                byte[] mono = new byte[1024];
                final byte[] st = new byte[PcmFramer.PAYLOAD * 2], silence = new byte[PcmFramer.PAYLOAD];
                while (rxRunning) {
                    int n;
                    try { n = in.read(mono); } catch (Throwable t) { break; }
                    if (n <= 0) continue;
                    rxBytes += n;
                    synchronized (headBuf) { int k = Math.min(n, headBuf.length - headLen); if (k > 0) { System.arraycopy(mono, 0, headBuf, headLen, k); headLen += k; } }
                    OutputStream c = capture;                                  // first-run check: the stream exactly as the port delivers it
                    if (c != null) { try { int k = (int) Math.min(n, captureLeft); c.write(mono, 0, k); captureLeft -= k; if (captureLeft <= 0) { capture = null; c.close(); } } catch (Throwable t) { capture = null; } }
                    if (txRunning) continue;                                   // half duplex: ignore echo while keyed
                    framer.feed(mono, n, (p, off, len) -> {                    // BB 00 … 44 packets, 160 bytes of PCM each
                        for (int i = 0, o = 0; i + 1 < len; i += 2) { st[o++] = p[off + i]; st[o++] = p[off + i + 1]; st[o++] = p[off + i]; st[o++] = p[off + i + 1]; }
                        Sink s = sink; if (s != null) s.onPcm(st, len * 2);
                        Gate g = gate;
                        if (track != null) { if (g == null || g.open()) track.write(p, off, len); else track.write(silence, 0, len); }
                    });
                }
            }, "uart-pcm-rx");
            rxThread.setDaemon(true); rxThread.start();
            return "UART PCM RX on " + path + " @ " + baud;
        } catch (Throwable t) { return "startRx failed: " + t; }
    }

    private final PcmFramer framer = new PcmFramer();
    private final byte[] headBuf = new byte[8192]; private int headLen;
    /** The first bytes the port ever delivered (a device report shows what the module sends, framed or not). */
    public byte[] head() { synchronized (headBuf) { return java.util.Arrays.copyOf(headBuf, headLen); } }
    public String frameStats() { return framer.frames + " audio packets, " + framer.skipped + " bytes skipped"; }
    private volatile long rxBytes, captureLeft;
    private volatile OutputStream capture;
    public long rxBytes() { return rxBytes; }
    /** Copy the next {@code ms} of received bytes, untouched, into {@code f} (for a device report). */
    public String capture(java.io.File f, int ms) {
        try {
            long before = rxBytes;
            captureLeft = (long) PcmFramer.FRAME * ms / 10 + 4096; capture = new FileOutputStream(f);
            Thread.sleep(ms + 300);
            OutputStream c = capture; if (c != null) { capture = null; c.close(); }
            long got = rxBytes - before;
            return String.format(java.util.Locale.US, "%d bytes in %d ms on %s (167-byte packets at 10 ms would be %d); %s; saved to %s", got, ms, path, (long) PcmFramer.FRAME * ms / 10, frameStats(), f.getName());
        } catch (Throwable t) { return "capture failed: " + t; }
    }

    @Override public synchronized String stopRx() {
        rxRunning = false;
        try { if (track != null) track.pause(); } catch (Throwable ignored) { }
        return "UART PCM RX stopped";
    }

    private volatile int txSource = MediaRecorder.AudioSource.MIC;
    @Override public void setTxSource(int source) { txSource = source; }
    private volatile TxFeed txFeed;
    @Override public void setTxFeed(TxFeed f) { txFeed = f; }
    private volatile Level txLevel;
    @Override public void setTxLevel(Level l) { txLevel = l; }

    @Override public synchronized String startTx() {
        try {
            open();
            final TxFeed feed = txFeed;
            if (feed == null) {                                                  // the microphone (a web feed paces itself)
                int min = AudioRecord.getMinBufferSize(SR, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
                rec = new AudioRecord(txSource, SR, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, Math.max(min, 4096));
                rec.startRecording();
            }
            txRunning = true;
            txThread = new Thread(() -> {
                byte[] buf = new byte[PACKET * 2];
                while (txRunning) {
                    int n = feed != null ? feed.read(buf, 0, buf.length) : rec.read(buf, 0, buf.length);
                    if (n <= 0) continue;
                    Level lv = txLevel; if (lv != null) { int pk = 0; for (int i = 0; i + 1 < n; i += 2) pk = Math.max(pk, Math.abs((short) ((buf[i] & 0xFF) | (buf[i + 1] << 8)))); lv.peak(pk); }
                    try { out.write(buf, 0, n); out.flush(); } catch (Throwable t) { break; }
                }
            }, "uart-pcm-tx");
            txThread.start();
            return "UART PCM TX started";
        } catch (Throwable t) { return "startTx failed: " + t; }
    }

    @Override public synchronized String stopTx() {
        txRunning = false;
        try { if (txThread != null) txThread.join(500); } catch (InterruptedException ignored) { }
        try { if (rec != null) { rec.stop(); rec.release(); rec = null; } } catch (Throwable ignored) { }
        return "UART PCM TX stopped";
    }

    @Override public String playPcm(short[] mono) {
        try {
            open();
            txRunning = true;
            byte[] pkt = new byte[PACKET * 2]; long t0 = System.nanoTime(); long sent = 0;
            for (int pos = 0; pos < mono.length; pos += PACKET) {
                for (int k = 0; k < PACKET; k++) { short v = pos + k < mono.length ? mono[pos + k] : 0; pkt[2 * k] = (byte) v; pkt[2 * k + 1] = (byte) (v >> 8); }
                out.write(pkt); out.flush();
                sent += PACKET;
                long wait = t0 + sent * 1_000_000_000L / SR - System.nanoTime();
                if (wait > 0) Thread.sleep(wait / 1_000_000, (int) (wait % 1_000_000));
            }
            Thread.sleep(100);
            return "played " + mono.length + " samples";
        } catch (Throwable t) { return "playPcm: " + t; }
        finally { txRunning = false; }
    }
}
