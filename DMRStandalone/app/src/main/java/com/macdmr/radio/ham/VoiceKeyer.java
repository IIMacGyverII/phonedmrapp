package com.macdmr.radio.ham;

import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;

import java.io.File;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.file.Files;

/**
 * Voice keyer: three recorded messages (a CQ, a net preamble, your ID) in the app's files as 8 kHz mono PCM,
 * recorded with the phone microphone, up to {@link #MAX_MS}, ready to transmit with one tap.
 */
public final class VoiceKeyer {
    public static final int SLOTS = 3, MAX_MS = 25_000, SR = 8000;
    private final Context ctx;
    private volatile AudioRecord rec; private volatile Thread recThread; private volatile int recSlot = -1;

    public VoiceKeyer(Context c) { ctx = c; }

    private File dir() { File d = new File(ctx.getFilesDir(), "keyer"); d.mkdirs(); return d; }
    private File file(int slot) { return new File(dir(), "slot" + slot + ".pcm"); }

    public String name(int slot) { return ctx.getSharedPreferences("keyer", Context.MODE_PRIVATE).getString("name" + slot, new String[] { "CQ", "Net preamble", "My ID" }[slot]); }
    public void setName(int slot, String n) { ctx.getSharedPreferences("keyer", Context.MODE_PRIVATE).edit().putString("name" + slot, n).apply(); }
    public boolean addId(int slot) { return ctx.getSharedPreferences("keyer", Context.MODE_PRIVATE).getBoolean("id" + slot, slot == 0); }
    public void setAddId(int slot, boolean on) { ctx.getSharedPreferences("keyer", Context.MODE_PRIVATE).edit().putBoolean("id" + slot, on).apply(); }
    public boolean has(int slot) { return file(slot).length() > 0; }
    public int lengthMs(int slot) { return (int) (file(slot).length() / 2 / 8); }
    public int recordingSlot() { return recSlot; }

    /** The recorded message, or null. */
    public short[] pcm(int slot) {
        try { byte[] b = Files.readAllBytes(file(slot).toPath()); short[] s = new short[b.length / 2]; ByteBuffer.wrap(b).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(s); return s; }
        catch (Throwable t) { return null; }
    }

    /** Start recording into {@code slot} from the microphone; stops by itself at {@link #MAX_MS}. Error or null. */
    public synchronized String start(int slot, Runnable stopped) {
        if (rec != null) return "Already recording";
        int min = AudioRecord.getMinBufferSize(SR, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
        final AudioRecord r;
        try { r = new AudioRecord(MediaRecorder.AudioSource.MIC, SR, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, Math.max(min, 8192)); }
        catch (SecurityException e) { return "The microphone permission is needed"; }
        if (r.getState() != AudioRecord.STATE_INITIALIZED) { r.release(); return "The microphone is busy"; }
        rec = r; recSlot = slot;
        recThread = new Thread(() -> {
            short[] all = new short[SR * MAX_MS / 1000]; int n = 0; short[] buf = new short[1024];
            r.startRecording();
            while (rec == r && n < all.length) { int k = r.read(buf, 0, Math.min(buf.length, all.length - n)); if (k > 0) { System.arraycopy(buf, 0, all, n, k); n += k; } }
            try { r.stop(); } catch (Throwable ignored) { }
            r.release();
            int start = 0, end = n; while (start < end && Math.abs(all[start]) < 600) start++; while (end > start && Math.abs(all[end - 1]) < 600) end--;   // trim silence
            start = Math.max(0, start - SR / 10); end = Math.min(n, end + SR / 5);
            if (end - start < SR / 2) { start = 0; end = n; }                          // nothing loud: keep it all rather than a fragment
            int peak = 1; for (int i = start; i < end; i++) peak = Math.max(peak, Math.abs(all[i]));
            double g = Math.min(4, 24000.0 / peak);
            ByteBuffer bb = ByteBuffer.allocate((end - start) * 2).order(ByteOrder.LITTLE_ENDIAN);
            for (int i = start; i < end; i++) bb.putShort((short) Math.max(-32768, Math.min(32767, Math.round(all[i] * g))));
            try { Files.write(file(slot).toPath(), bb.array()); } catch (Throwable ignored) { }
            synchronized (VoiceKeyer.this) { if (rec == r) rec = null; recSlot = -1; }
            if (stopped != null) stopped.run();
        }, "keyer-record");
        recThread.start();
        return null;
    }

    public synchronized void stop() { rec = null; }
    public void delete(int slot) { file(slot).delete(); }

    /** Play on the phone's speaker (to check it before sending). */
    public void preview(int slot) {
        final short[] p = pcm(slot); if (p == null) return;
        new Thread(() -> {
            try {
                android.media.AudioTrack t = new android.media.AudioTrack(android.media.AudioManager.STREAM_MUSIC, SR, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT, p.length * 2, android.media.AudioTrack.MODE_STATIC);
                t.write(p, 0, p.length); t.play();
                Thread.sleep(p.length / 8 + 300); t.release();
            } catch (Throwable ignored) { }
        }, "keyer-preview").start();
    }
}
