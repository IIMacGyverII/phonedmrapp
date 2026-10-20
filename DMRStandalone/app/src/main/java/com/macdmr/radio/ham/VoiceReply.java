package com.macdmr.radio.ham;

import android.content.Context;
import android.speech.tts.TextToSpeech;
import android.speech.tts.UtteranceProgressListener;
import android.util.Log;

import java.io.File;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.file.Files;
import java.util.Locale;

/** Speech for transmitting: the text is synthesized to a file, read back and brought to the radio's 8 kHz mono. */
public final class VoiceReply {
    public interface Done { void pcm(short[] pcm8k); }

    private final Context ctx; private TextToSpeech tts; private volatile boolean ready;

    public VoiceReply(Context c) { ctx = c; }   // may be a service still being created: no getApplicationContext() here

    public void say(final String text, final Done done) {
        if (tts == null) {
            tts = new TextToSpeech(ctx.getApplicationContext(), st -> { ready = st == TextToSpeech.SUCCESS; if (ready) { tts.setLanguage(Locale.US); synth(text, done); } else Log.w("VoiceReply", "tts init " + st); });
            return;
        }
        if (ready) synth(text, done);
    }

    private void synth(String text, Done done) {
        final File f = new File(ctx.getCacheDir(), "voice_reply_" + System.nanoTime() + ".wav");
        final String id = f.getName();
        tts.setOnUtteranceProgressListener(new UtteranceProgressListener() {
            @Override public void onStart(String u) { }
            @Override public void onError(String u) { Log.w("VoiceReply", "synthesis failed"); f.delete(); }
            @Override public void onDone(String u) {
                if (!id.equals(u)) return;
                try { short[] pcm = readWav8k(Files.readAllBytes(f.toPath())); if (pcm != null) done.pcm(pcm); }
                catch (Throwable t) { Log.w("VoiceReply", "read: " + t); }
                finally { f.delete(); }
            }
        });
        tts.synthesizeToFile(text, null, f, id);
    }

    /** 16-bit PCM WAV (any rate, mono or stereo) to 8 kHz mono, low-passed below 3.6 kHz first, peak 26000. */
    static short[] readWav8k(byte[] all) {
        ByteBuffer bb = ByteBuffer.wrap(all).order(ByteOrder.LITTLE_ENDIAN);
        int ch = 1, rate = 0, pos = 12, at = -1, len = 0;
        while (pos + 8 <= all.length) {
            String cid = new String(all, pos, 4, java.nio.charset.StandardCharsets.US_ASCII); int l = bb.getInt(pos + 4);
            if (cid.equals("fmt ")) { ch = bb.getShort(pos + 10); rate = bb.getInt(pos + 12); }
            if (cid.equals("data")) { at = pos + 8; len = Math.min(l, all.length - at); break; }
            pos += 8 + l + (l & 1);
        }
        if (at < 0 || rate <= 0) return null;
        int n = len / (2 * ch);
        double[] x = new double[n]; for (int i = 0; i < n; i++) x[i] = bb.getShort(at + i * 2 * ch);
        return resample(x, rate);
    }

    static short[] resample(double[] x, int rate) {
        int outN = (int) ((long) x.length * 8000 / rate), taps = 32;
        double fc = 3600.0 / rate, step = (double) rate / 8000;
        double[] y = new double[outN]; double peak = 1;
        for (int i = 0; i < outN; i++) {
            double t = i * step; int c = (int) t; double acc = 0;
            for (int k = c - taps + 1; k <= c + taps; k++) {
                if (k < 0 || k >= x.length) continue;
                double u = t - k, sinc = u == 0 ? 2 * fc : Math.sin(2 * Math.PI * fc * u) / (Math.PI * u);
                double w = 0.5 + 0.5 * Math.cos(Math.PI * u / taps);                     // Hann window
                acc += x[k] * sinc * w;
            }
            y[i] = acc; peak = Math.max(peak, Math.abs(acc));
        }
        short[] out = new short[outN]; double g = 26000 / peak;
        for (int i = 0; i < outN; i++) out[i] = (short) Math.round(y[i] * g);
        return out;
    }
}
