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
public final class TinyServiceAudio {
    public interface Sink { void onPcm(byte[] stereo8k, int len); }

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

    public void setSink(Sink s) { sink = s; }

    /** Start RX: register the binder callback, open the PCM stream, play through an AudioTrack. */
    public synchronized String startRx(boolean speaker) {
        try {
            if (track == null) {
                int min = AudioTrack.getMinBufferSize(8000, AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT);
                track = new AudioTrack(new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build(),
                        new AudioFormat.Builder().setSampleRate(8000).setChannelMask(AudioFormat.CHANNEL_OUT_STEREO)
                                .setEncoding(AudioFormat.ENCODING_PCM_16BIT).build(),
                        Math.max(min * 2, 8192), AudioTrack.MODE_STREAM, AudioManager.AUDIO_SESSION_ID_GENERATE);
                track.play();
                register.invoke(svc, new ITinyRecvCallback.Stub() {
                    @Override public void onRecv(byte[] data, int len) {
                        if (playing && track != null && len > 0) track.write(data, 0, len);
                        Sink s = sink; if (s != null) s.onPcm(data, len);
                    }
                });
            }
            Object r = openRecv.invoke(svc);
            playing = true;
            return "openRecvPcm=" + r;
        } catch (Throwable t) { return "startRx failed: " + t + (t.getCause() != null ? " / " + t.getCause() : ""); }
    }

    public synchronized String stopRx() {
        playing = false;
        try { closeRecv.invoke(svc); } catch (Throwable t) { return "closeRecvPcm: " + t; }
        return "closeRecvPcm ok";
    }

    /** TX: phone mic → 8 kHz mono → duplicated to stereo → PrizeTinyService.writeFrame while keyed. */
    public synchronized String startTx() {
        try {
            Object ok = openWrite.invoke(svc);
            int fs = (Integer) frameSize.invoke(svc);
            if (!Boolean.TRUE.equals(ok) || fs <= 0) return "openWritePcm=" + ok + " frameSize=" + fs;
            int min = AudioRecord.getMinBufferSize(8000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
            rec = new AudioRecord(MediaRecorder.AudioSource.MIC, 8000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, Math.max(min, 4096));
            rec.startRecording();
            txRunning = true;
            final int frame = fs;
            txThread = new Thread(() -> {
                byte[] mono = new byte[frame / 2]; byte[] st = new byte[frame];
                while (txRunning) {
                    int n = rec.read(mono, 0, mono.length);
                    if (n <= 0) continue;
                    for (int i = 0, o = 0; i + 1 < n; i += 2) { st[o++] = mono[i]; st[o++] = mono[i + 1]; st[o++] = mono[i]; st[o++] = mono[i + 1]; }
                    try { writeFrame.invoke(svc, st, n * 2); } catch (Throwable t) { synchronized (err) { err.append(t).append('\n'); } break; }
                }
            }, "tiny-tx");
            txThread.start();
            return "TX started, frame=" + fs;
        } catch (Throwable t) { return "startTx failed: " + t; }
    }

    public synchronized String stopTx() {
        txRunning = false;
        try { if (txThread != null) txThread.join(500); } catch (InterruptedException ignored) { }
        try { if (rec != null) { rec.stop(); rec.release(); rec = null; } } catch (Throwable ignored) { }
        try { closeWrite.invoke(svc); } catch (Throwable t) { return "closeWritePcm: " + t; }
        String e; synchronized (err) { e = err.toString(); err.setLength(0); }
        return "TX stopped" + (e.isEmpty() ? "" : " errors: " + e);
    }
}
