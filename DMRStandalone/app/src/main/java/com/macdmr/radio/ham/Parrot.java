package com.macdmr.radio.ham;

/**
 * Simplex repeater ("parrot"): records each transmission heard on the channel and, a second after it ends, sends it
 * back on the same channel. A station hears how it sounds, and two stations out of each other's range can relay
 * through the phone. Recordings are capped at {@link #MAX_MS}, so with the 1.5 s lead the playback stays under the radio's 30 s limit. With a
 * callsign set, the station identification (Morse) is added to a playback at most every ten minutes.
 *
 * Fed with every 8 kHz mono receive block; {@code heard} is the squelch (a real reception, not noise).
 */
public final class Parrot {
    public interface Host {
        /** Transmit 8 kHz mono PCM; {@code done} runs after release. False when the radio cannot transmit now. */
        boolean transmit(short[] pcm, String label, Runnable done);
        String idCallsign();            // null or empty: no identification
        void event(String line);
    }

    public static final int MAX_MS = 26_000, MIN_MS = 700, HANG_MS = 700, REPLY_DELAY_MS = 1000;
    public static final long ID_EVERY_MS = 10 * 60_000L;
    private static final int SR = 8000;

    private final Host host;
    private final short[] buf = new short[SR * MAX_MS / 1000];
    private volatile boolean enabled, playing;
    private boolean recording, truncated;
    private int len;
    private long lastHeardMs, lastIdMs;
    private int played;

    public Parrot(Host h) { host = h; }

    public boolean enabled() { return enabled; }
    public boolean busy() { return recording || playing; }
    public int played() { return played; }
    public synchronized void setEnabled(boolean on) { enabled = on; recording = false; len = 0; if (on) played = 0; }

    /** One receive block; {@code now} in ms (a parameter so tests can run faster than real time). */
    public synchronized void feed(byte[] mono, int n, boolean heard, long now) {
        if (!enabled || playing) return;
        if (heard) {
            if (!recording) { recording = true; len = 0; truncated = false; }
            for (int i = 0; i + 1 < n; i += 2) { if (len < buf.length) buf[len++] = (short) ((mono[i] & 0xFF) | (mono[i + 1] << 8)); else truncated = true; }
            lastHeardMs = now;
        } else if (recording && now - lastHeardMs >= HANG_MS) {
            recording = false;
            finish(now);
        }
    }

    private void finish(long now) {
        int ms = len / 8;
        if (ms < MIN_MS) return;                       // a kerchunk: nothing to repeat
        String call = host.idCallsign();
        boolean id = call != null && !call.isEmpty() && (lastIdMs == 0 || now - lastIdMs >= ID_EVERY_MS);
        short[] voice = normalize(buf, len);
        short[] morse = id ? com.macdmr.radio.coverage.Morse.pcm(call, 20, 800) : new short[0];
        int lead = SR * 3 / 2, gap = id ? SR * 3 / 10 : 0;          // the radio passes audio only ~1.5 s after keying (measured 2026-10-20)
        int total = lead + voice.length + gap + morse.length;
        if (total > SR * 28) { morse = new short[0]; gap = 0; id = false; total = lead + voice.length; }   // the radio's limit wins over an ID this time
        short[] out = new short[total];
        System.arraycopy(voice, 0, out, lead, voice.length);
        System.arraycopy(morse, 0, out, lead + voice.length + gap, morse.length);
        final boolean sentId = id; final boolean cut = truncated; final int secs = Math.round(ms / 1000f);
        playing = true;
        new Thread(() -> {
            try { Thread.sleep(REPLY_DELAY_MS); } catch (InterruptedException ignored) { }
            boolean ok = host.transmit(out, "parrot " + secs + " s", () -> { synchronized (Parrot.this) { playing = false; played++; } });
            if (!ok) { synchronized (Parrot.this) { playing = false; } host.event("🦜 Parrot could not transmit the " + secs + " s recording"); return; }
            if (sentId) lastIdMs = System.currentTimeMillis();
            host.event("🦜 Parrot repeated " + secs + " s" + (cut ? " (cut at 26 s, the radio's limit)" : "") + (sentId ? " + ID" : ""));
        }, "parrot").start();
    }

    /** Bring the recording to a steady level (peak about 22000, gain 0.5 to 4). */
    static short[] normalize(short[] src, int n) {
        int peak = 1; for (int i = 0; i < n; i++) peak = Math.max(peak, Math.abs(src[i]));
        double g = Math.max(0.5, Math.min(4.0, 22000.0 / peak));
        short[] out = new short[n];
        for (int i = 0; i < n; i++) out[i] = (short) Math.max(-32768, Math.min(32767, Math.round(src[i] * g)));
        return out;
    }
}
