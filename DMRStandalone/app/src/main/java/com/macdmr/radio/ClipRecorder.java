package com.macdmr.radio;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.Locale;

/**
 * A short WAV clip of what SignalDeck receives (8 kHz mono 16-bit, after the stereo→mono step, before the speaker), for a
 * device report's listen check, with the numbers that tell how it sounds without listening: level, clipping, and
 * dropouts (runs of exact digital silence, which noise or speech never produce: lost or zero-filled packets).
 */
public final class ClipRecorder {
    private final RandomAccessFile f; private final File file;
    private final long maxBytes; private long bytes;
    private long sumSq, samples, clipped; private int peak, zeroRun, dropouts, longestZero;
    private volatile boolean done;

    public ClipRecorder(File file, int maxMs) throws IOException {
        this.file = file; this.maxBytes = 16L * maxMs;                    // 8000 samples/s × 2 bytes
        f = new RandomAccessFile(file, "rw"); f.setLength(0); f.write(new byte[44]);
    }

    /** Mono little-endian bytes; returns false once full. Called from the receive thread. */
    public synchronized boolean write(byte[] b, int n) {
        if (done) return false;
        int k = (int) Math.min(n & ~1, maxBytes - bytes);
        if (k <= 0) { finish(); return false; }
        try { f.write(b, 0, k); } catch (IOException e) { finish(); return false; }
        bytes += k;
        for (int i = 0; i + 1 < k; i += 2) {
            int v = (short) ((b[i] & 0xFF) | (b[i + 1] << 8));
            sumSq += (long) v * v; samples++;
            int a = Math.abs(v); if (a > peak) peak = a; if (a >= 32000) clipped++;
            if (v == 0) { if (++zeroRun == 80) dropouts++; if (zeroRun > longestZero) longestZero = zeroRun; } else zeroRun = 0;   // ≥ 10 ms of exact zeros
        }
        if (bytes >= maxBytes) { finish(); return false; }
        return true;
    }

    public synchronized boolean isDone() { return done; }

    /** Close the file and write the WAV header sizes. */
    public synchronized void finish() {
        if (done) return; done = true;
        try {
            f.seek(0);
            java.nio.ByteBuffer h = java.nio.ByteBuffer.allocate(44).order(java.nio.ByteOrder.LITTLE_ENDIAN);
            h.put("RIFF".getBytes()).putInt((int) (36 + bytes)).put("WAVE".getBytes()).put("fmt ".getBytes()).putInt(16)
                    .putShort((short) 1).putShort((short) 1).putInt(8000).putInt(16000).putShort((short) 2).putShort((short) 16)
                    .put("data".getBytes()).putInt((int) bytes);
            f.write(h.array()); f.close();
        } catch (IOException ignored) { }
    }

    public synchronized String stats() {
        double rms = samples == 0 ? 0 : Math.sqrt((double) sumSq / samples);
        return String.format(Locale.US, "%s: %.1f s, level RMS %d (%.0f dBFS), peak %d, clipped %.2f %%, dropouts (≥10 ms of digital silence) %d, longest %d ms",
                file.getName(), samples / 8000.0, Math.round(rms), rms > 0 ? 20 * Math.log10(rms / 32768.0) : -99, peak,
                samples == 0 ? 0 : 100.0 * clipped / samples, dropouts, longestZero / 8);
    }
}
