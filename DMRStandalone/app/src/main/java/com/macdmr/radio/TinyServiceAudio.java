package com.macdmr.radio;

import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.AudioTrack;
import android.media.MediaRecorder;
import android.os.ITinyRecvCallback;

import java.lang.reflect.Method;

/**
 * Voice audio on the Ulefone: the vendor framework class android.os.PrizeTinyService (binder "tinyservice",
 * tinyalsa device 8 / card 0 behind it). RX frames arrive as 8 kHz 16-bit stereo (L == R), 2048 bytes;
 * TX takes the same format. No caller check in the service (measured 2026-10-17).
 */
public final class TinyServiceAudio implements AudioBackend {
    private volatile Gate gate;
    @Override public void setGate(Gate g) { gate = g; }

    private final Object svc;
    private final Method openRecv, closeRecv, openWrite, closeWrite, frameSize, writeFrame, register;
    private AudioTrack track;
    private volatile boolean playing;
    private final StringBuilder err = new StringBuilder();
    private Sink sink;
    private AudioRecord rec;
    private Thread txThread;
    private volatile boolean txRunning;

    public TinyServiceAudio() throws Exception {
        Class<?> c = Class.forName("android.os.PrizeTinyService");
        svc = c.getConstructor().newInstance();
        openRecv = c.getMethod("openRecvPcm"); closeRecv = c.getMethod("closeRecvPcm");
        openWrite = c.getMethod("openWritePcm"); closeWrite = c.getMethod("closeWritePcm");
        frameSize = c.getMethod("getFrameSize"); writeFrame = c.getMethod("writeFrame", byte[].class, int.class);
        register = c.getMethod("registerRecvCallback", Class.forName("android.os.ITinyRecvCallback"));
    }

    @Override public void setSink(Sink s) { sink = s; }

    /** Start RX: register the binder callback, open the PCM stream, play through an AudioTrack. */
    @Override public synchronized String startRx(boolean speaker) {
        try {
            if (track == null || reregister) {
                if (track != null) { reregister = false; register.invoke(svc, callback); }   // after Hand back: the stock app replaced our callback
            }
            if (track == null) {
                int min = AudioTrack.getMinBufferSize(8000, AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT);
                track = new AudioTrack(new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build(),
                        new AudioFormat.Builder().setSampleRate(8000).setChannelMask(AudioFormat.CHANNEL_OUT_STEREO)
                                .setEncoding(AudioFormat.ENCODING_PCM_16BIT).build(),
                        Math.max(min * 2, 8192), AudioTrack.MODE_STREAM, AudioManager.AUDIO_SESSION_ID_GENERATE);
                track.play();
                callback = new ITinyRecvCallback.Stub() {
                    @Override public void onRecv(byte[] data, int len) {
                        Sink s = sink; if (s != null) s.onPcm(data, len);            // squelch decision first
                        Gate g = gate;
                        if (playing && track != null && len > 0) {
                            if (g == null || g.open()) track.write(data, 0, len);
                            else { byte[] z = new byte[len]; track.write(z, 0, len); }  // keep the stream timing, play silence
                        }
                    }
                };
                register.invoke(svc, callback);
            }
            Object r = openRecv.invoke(svc);
            playing = true;
            return "openRecvPcm=" + r;
        } catch (Throwable t) { return "startRx failed: " + t + (t.getCause() != null ? " / " + t.getCause() : ""); }
    }

    private ITinyRecvCallback.Stub callback;
    private volatile boolean reregister;
    @Override public void releaseForStockApp() { reregister = true; }

    @Override public synchronized String stopRx() {
        playing = false;
        try { closeRecv.invoke(svc); } catch (Throwable t) { return "closeRecvPcm: " + t; }
        return "closeRecvPcm ok";
    }

    /** TX: phone mic → 8 kHz mono → duplicated to stereo → PrizeTinyService.writeFrame while keyed. */
    private volatile int txSource = MediaRecorder.AudioSource.MIC;
    @Override public void setTxSource(int source) { txSource = source; }
    private volatile TxFeed txFeed;
    @Override public void setTxFeed(TxFeed f) { txFeed = f; }
    private volatile Level txLevel;
    @Override public void setTxLevel(Level l) { txLevel = l; }

    @Override public synchronized String startTx() {
        try {
            Object ok = openWrite.invoke(svc);
            int fs = (Integer) frameSize.invoke(svc);
            if (!Boolean.TRUE.equals(ok) || fs <= 0) return "openWritePcm=" + ok + " frameSize=" + fs;
            final TxFeed feed = txFeed;
            if (feed == null) {                                                  // the microphone (a web feed paces itself)
                int min = AudioRecord.getMinBufferSize(8000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
                rec = new AudioRecord(txSource, 8000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, Math.max(min, 4096));
                rec.startRecording();
            }
            txRunning = true;
            final int frame = fs;
            txThread = new Thread(() -> {
                byte[] mono = new byte[frame / 2]; byte[] st = new byte[frame];
                while (txRunning) {
                    int n = feed != null ? feed.read(mono, 0, mono.length) : rec.read(mono, 0, mono.length);
                    if (n <= 0) continue;
                    for (int i = 0, o = 0; i + 1 < n; i += 2) { st[o++] = mono[i]; st[o++] = mono[i + 1]; st[o++] = mono[i]; st[o++] = mono[i + 1]; }
                    Level lv = txLevel; if (lv != null) { int pk = 0; for (int i = 0; i + 1 < n; i += 2) pk = Math.max(pk, Math.abs((short) ((mono[i] & 0xFF) | (mono[i + 1] << 8)))); lv.peak(pk); }
                    try { writeFrame.invoke(svc, st, n * 2); } catch (Throwable t) { synchronized (err) { err.append(t).append('\n'); } break; }
                }
            }, "tiny-tx");
            txThread.start();
            return "TX started, frame=" + fs;
        } catch (Throwable t) { return "startTx failed: " + t; }
    }

    /** Play 8 kHz mono PCM into the TX path (stereo-duplicated, paced to real time); blocks until done. */
    @Override public String playPcm(short[] mono) {
        Object ok; int fs;
        synchronized (this) {
            try { ok = openWrite.invoke(svc); fs = (Integer) frameSize.invoke(svc); } catch (Throwable t) { return "playPcm open: " + t; }
            if (!Boolean.TRUE.equals(ok) || fs <= 0) return "openWritePcm=" + ok + " frameSize=" + fs;
        }
        try {
            byte[] st = new byte[fs]; int per = fs / 4; long t0 = System.nanoTime(); long sent = 0;
            for (int pos = 0; pos < mono.length; pos += per) {
                for (int k = 0; k < per; k++) {
                    short v = pos + k < mono.length ? mono[pos + k] : 0;
                    st[4 * k] = (byte) v; st[4 * k + 1] = (byte) (v >> 8); st[4 * k + 2] = (byte) v; st[4 * k + 3] = (byte) (v >> 8);
                }
                writeFrame.invoke(svc, st, fs);
                sent += per;
                long wait = t0 + sent * 1_000_000_000L / 8000 - System.nanoTime();
                if (wait > 0) Thread.sleep(wait / 1_000_000, (int) (wait % 1_000_000));
            }
            Thread.sleep(150);                                                   // let the last frame leave the DSP
            return "played " + mono.length + " samples";
        } catch (Throwable t) { return "playPcm: " + t; }
        finally { try { closeWrite.invoke(svc); } catch (Throwable ignored) { } }
    }

    /** TX a steady tone (bench use: a HackRF sees a clean carrier with one audio line). */
    public synchronized String startTxTone(final double hz) {
        try {
            Object ok = openWrite.invoke(svc);
            int fs = (Integer) frameSize.invoke(svc);
            if (!Boolean.TRUE.equals(ok) || fs <= 0) return "openWritePcm=" + ok + " frameSize=" + fs;
            txRunning = true;
            final int frame = fs;
            txThread = new Thread(() -> {
                byte[] st = new byte[frame]; double ph = 0, step = 2 * Math.PI * hz / 8000.0; long t0 = System.nanoTime(); long sent = 0;
                while (txRunning) {
                    for (int o = 0; o + 3 < frame; o += 4) {
                        short v = (short) (Math.sin(ph) * 9000); ph += step;
                        st[o] = (byte) v; st[o + 1] = (byte) (v >> 8); st[o + 2] = (byte) v; st[o + 3] = (byte) (v >> 8);
                    }
                    try { writeFrame.invoke(svc, st, frame); } catch (Throwable t) { synchronized (err) { err.append(t).append('\n'); } break; }
                    sent += frame / 4;                                   // samples; pace to real time (8 kHz)
                    long due = t0 + sent * 1_000_000_000L / 8000;
                    long wait = due - System.nanoTime();
                    if (wait > 0) try { Thread.sleep(wait / 1_000_000, (int) (wait % 1_000_000)); } catch (InterruptedException ignored) { }
                }
            }, "tiny-tx-tone");
            txThread.start();
            return "TX tone " + hz + " Hz started, frame=" + fs;
        } catch (Throwable t) { return "startTxTone failed: " + t; }
    }

    @Override public synchronized String stopTx() {
        txRunning = false;
        try { if (txThread != null) txThread.join(500); } catch (InterruptedException ignored) { }
        try { if (rec != null) { rec.stop(); rec.release(); rec = null; } } catch (Throwable ignored) { }
        try { closeWrite.invoke(svc); } catch (Throwable t) { return "closeWritePcm: " + t; }
        String e; synchronized (err) { e = err.toString(); err.setLength(0); }
        return "TX stopped" + (e.isEmpty() ? "" : " errors: " + e);
    }
}
