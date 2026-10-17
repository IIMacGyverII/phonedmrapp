package com.macdmr.radio;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * Live captions through the companion app's on-device recognizer (Vosk in {@code com.macdmr.transcription},
 * localhost:8002): one socket per utterance, 16 kHz mono PCM in, JSON lines out
 * ({@code status} / {@code partial} / {@code text}). Closing the sending half ends the utterance and the
 * recognizer answers with the final text.
 */
public final class CaptionClient {
    public interface Listener {
        void status(String s);
        void partial(String text);
        void sentence(String text);
        void finished(String fullText);
    }

    public static final String PKG = "com.macdmr.transcription", SERVICE = PKG + ".LiveCaptionService";
    public static final int PORT = 8002;
    public static final long PAUSE_MS = 2500;
    public static final String[] MODELS = { "vosk-model-small-en-us-0.15", "vosk-model-en-us-0.22-lgraph", "vosk-model-en-us-0.22", "vosk-model-en-us-0.42-gigaspeech" };
    public static final String[] MODEL_LABELS = { "Small — 40 MB, fastest", "Better — 125 MB, good balance", "Best — 1.8 GB, full-size English", "Max — 2.3 GB, GigaSpeech, most accurate" };

    private final Context ctx;
    private final Listener listener;
    private volatile LinkedBlockingQueue<byte[]> queue;
    private volatile boolean active;
    private final StringBuilder finalText = new StringBuilder();

    public CaptionClient(Context c, Listener l) { ctx = c.getApplicationContext(); listener = l; }

    public static boolean companionInstalled(Context c) {
        try { c.getPackageManager().getPackageInfo(PKG, 0); return true; } catch (Throwable t) { return false; }
    }

    /** Ask the companion to (down)load a model; it keeps serving while switching. */
    public void setModel(String model) {
        try {
            Intent svc = new Intent(); svc.setComponent(new ComponentName(PKG, SERVICE)); if (model != null) svc.putExtra("model", model);
            if (Build.VERSION.SDK_INT >= 26) ctx.startForegroundService(svc); else ctx.startService(svc);
        } catch (Throwable t) { Log.w("CaptionClient", "start service: " + t); }
    }

    public boolean isActive() { return active; }

    public synchronized void start() {
        if (active) return;
        active = true;
        synchronized (finalText) { finalText.setLength(0); }
        final LinkedBlockingQueue<byte[]> q = new LinkedBlockingQueue<>();
        queue = q;
        new Thread(() -> {
            Socket sock = null;
            try {
                setModel(null);
                for (int i = 0; i < 16 && active; i++) {
                    try { sock = new Socket(); sock.connect(new InetSocketAddress("127.0.0.1", PORT), 500); break; } catch (Throwable t) { sock = null; Thread.sleep(250); }
                }
                if (sock == null) { Log.w("CaptionClient", "no connection to companion"); listener.status("companion service not reachable (starting?)"); return; }
                Log.i("CaptionClient", "connected; streaming");
                sock.setTcpNoDelay(true);
                final OutputStream out = sock.getOutputStream();
                final Socket fs = sock;
                Thread writer = new Thread(() -> {
                    try {
                        while (true) {
                            byte[] b = q.poll(PAUSE_MS, TimeUnit.MILLISECONDS);
                            if (b == null || b.length == 0) { fs.shutdownOutput(); break; }        // pause or end of reception
                            out.write(b); out.flush();
                        }
                    } catch (Throwable ignored) { }
                }, "caption-writer");
                writer.setDaemon(true); writer.start();
                BufferedReader in = new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
                String line;
                while ((line = in.readLine()) != null) {
                    try {
                        JSONObject o = new JSONObject(line);
                        if (o.has("status")) { String st = o.optString("status"); if (!"ready".equals(st)) listener.status(st); continue; }
                        if (o.has("partial")) { String p = o.optString("partial").trim(); if (!p.isEmpty()) listener.partial(p); }
                        else if (o.has("text")) {
                            String t = o.optString("text").trim();
                            if (!t.isEmpty()) { synchronized (finalText) { if (finalText.length() > 0) finalText.append(' '); finalText.append(t); } listener.sentence(t); }
                        }
                    } catch (Throwable ignored) { }
                }
            } catch (Throwable t) {
                Log.w("CaptionClient", "session: " + t);
            } finally {
                try { if (sock != null) sock.close(); } catch (Throwable ignored) { }
                queue = null; active = false;
                String text; synchronized (finalText) { text = finalText.toString().trim(); }
                listener.finished(text);
            }
        }, "caption").start();
    }

    /** 8 kHz mono 16-bit → 16 kHz mono (linear interpolation) into the recognizer stream. */
    public void feed8kMono(byte[] mono, int len) {
        LinkedBlockingQueue<byte[]> q = queue;
        if (q == null || q.size() > 400) return;
        int n = len / 2; if (n < 2) return;
        byte[] out = new byte[n * 4];
        int prev = (short) ((mono[1] << 8) | (mono[0] & 0xFF));
        for (int i = 0; i < n; i++) {
            int cur = (short) ((mono[2 * i + 1] << 8) | (mono[2 * i] & 0xFF));
            int mid = (prev + cur) >> 1;
            out[4 * i] = (byte) mid; out[4 * i + 1] = (byte) (mid >> 8); out[4 * i + 2] = (byte) cur; out[4 * i + 3] = (byte) (cur >> 8);
            prev = cur;
        }
        q.offer(out);
    }

    /** End the utterance; the session thread delivers the final text. */
    public void stop() { LinkedBlockingQueue<byte[]> q = queue; if (q != null) q.offer(new byte[0]); }
}
