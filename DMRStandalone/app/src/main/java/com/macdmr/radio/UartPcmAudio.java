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
 * Raw PCM over a second UART (Blackview Xplore 1 family: {@code /dev/ttyS1} at 230400 baud, 8 kHz mono 16-bit
 * little-endian, no framing seen in the stock app's code). RX bytes are played through an AudioTrack and handed to
 * the sink as stereo-duplicated frames, so the rest of the app is identical to the Ulefone path.
 *
 * <p><b>Not yet exercised on hardware</b> (no Xplore 1 here). What must be confirmed on a real unit: that the
 * stream is headerless, the byte order, whether the MCU wants a fixed packet size and pacing (the stock app
 * queues 20 ms packets), and that the port is already in raw mode at 230400 (the profile's stty fallback runs
 * if its serial library is unknown).
 */
public final class UartPcmAudio implements AudioBackend {
    private static final int SR = 8000, PACKET = 320;           // 20 ms of 8 kHz mono 16-bit
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
                byte[] mono = new byte[PACKET * 2], st = new byte[PACKET * 4], silence = new byte[PACKET * 2];
                while (rxRunning) {
                    int n;
                    try { n = in.read(mono); } catch (Throwable t) { break; }
                    if (n <= 0) continue;
                    if (txRunning) continue;                                   // half duplex: ignore echo while keyed
                    for (int i = 0, o = 0; i + 1 < n; i += 2) { st[o++] = mono[i]; st[o++] = mono[i + 1]; st[o++] = mono[i]; st[o++] = mono[i + 1]; }
                    Sink s = sink; if (s != null) s.onPcm(st, (n / 2) * 4);
                    Gate g = gate;
                    if (track != null) { if (g == null || g.open()) track.write(mono, 0, n); else track.write(silence, 0, n); }
                }
            }, "uart-pcm-rx");
            rxThread.setDaemon(true); rxThread.start();
            return "UART PCM RX on " + path + " @ " + baud;
        } catch (Throwable t) { return "startRx failed: " + t; }
    }

    @Override public synchronized String stopRx() {
        rxRunning = false;
        try { if (track != null) track.pause(); } catch (Throwable ignored) { }
        return "UART PCM RX stopped";
    }

    private volatile int txSource = MediaRecorder.AudioSource.MIC;
    @Override public void setTxSource(int source) { txSource = source; }
    private volatile Level txLevel;
    @Override public void setTxLevel(Level l) { txLevel = l; }

    @Override public synchronized String startTx() {
        try {
            open();
            int min = AudioRecord.getMinBufferSize(SR, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
            rec = new AudioRecord(txSource, SR, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, Math.max(min, 4096));
            rec.startRecording();
            txRunning = true;
            txThread = new Thread(() -> {
                byte[] buf = new byte[PACKET * 2];
                while (txRunning) {
                    int n = rec.read(buf, 0, buf.length);
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
