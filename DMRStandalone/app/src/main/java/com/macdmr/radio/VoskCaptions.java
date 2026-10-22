package com.macdmr.radio;

import android.content.Context;
import android.util.Log;

import org.json.JSONObject;
import org.vosk.LibVosk;
import org.vosk.LogLevel;
import org.vosk.Model;
import org.vosk.Recognizer;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * On-device live captions with Vosk, built into the app. The language model is not shipped in the APK: it is
 * downloaded once from alphacephei.com into this app's private files directory ({@code files/models/<name>}),
 * which survives app updates (only an uninstall removes it) and is reused on every start. One utterance = one
 * {@link Recognizer}: 16 kHz mono PCM in, partial text as it forms, a finished sentence on each pause, the final
 * text when the reception ends.
 */
public final class VoskCaptions {
    public interface Listener {
        void status(String s);
        void partial(String text);
        void sentence(String text);
        void finished(String fullText);
    }

    private static final String TAG = "VoskCaptions";
    public static final long PAUSE_MS = 2500;
    public static final String[] MODELS = { "vosk-model-small-en-us-0.15", "vosk-model-en-us-0.22-lgraph", "vosk-model-en-us-0.22", "vosk-model-en-us-0.42-gigaspeech" };
    public static final String[] MODEL_LABELS = { "Small — 40 MB, fastest", "Better — 125 MB, good balance", "Best — 1.8 GB, full-size English", "Max — 2.3 GB, GigaSpeech, most accurate" };
    public static final String DEFAULT_MODEL = MODELS[1];

    private final Context ctx;
    private final Listener listener;
    private volatile LinkedBlockingQueue<byte[]> queue;
    private volatile boolean active;
    private final StringBuilder finalText = new StringBuilder();
    private final Object loadLock = new Object();
    private volatile Model model; private volatile String loadedName, wantedName, status = "idle";
    private volatile boolean loading;

    public VoskCaptions(Context c, Listener l) { ctx = c.getApplicationContext(); listener = l; wantedName = DEFAULT_MODEL; try { LibVosk.setLogLevel(LogLevel.WARNINGS); } catch (Throwable ignored) { } }

    public static File modelDir(Context c, String name) { return new File(new File(c.getFilesDir(), "models"), name); }
    public static boolean modelPresent(Context c, String name) { return new File(modelDir(c, name), "am/final.mdl").exists(); }
    public String status() { return status; }
    /** The model in memory now (null before the first load). */
    public String loadedName() { return loadedName; }
    public boolean isLoading() { return loading; }
    /** Remove a downloaded model (not the one loaded or being loaded). */
    public static boolean deleteModel(Context c, String name) { File d = modelDir(c, name); if (!d.exists()) return true; deleteTree(d); return !d.exists(); }
    private static void deleteTree(File f) { File[] k = f.listFiles(); if (k != null) for (File x : k) deleteTree(x); f.delete(); }
    public static long modelBytes(Context c, String name) { return treeBytes(modelDir(c, name)); }
    private static long treeBytes(File f) { if (f.isFile()) return f.length(); long n = 0; File[] k = f.listFiles(); if (k != null) for (File x : k) n += treeBytes(x); return n; }
    public boolean isActive() { return active; }

    /** Choose the model (downloaded on first use, kept across updates); loads in the background. */
    public void setModel(String name) {
        if (name != null && !name.isEmpty()) wantedName = name;
        ensureLoaded();
    }

    private void ensureLoaded() {
        if (model != null && wantedName.equals(loadedName)) return;
        if (loading) return;
        loading = true;
        new Thread(() -> {
            synchronized (loadLock) {
                try {
                    while (true) {
                        String name = wantedName;
                        if (model != null && name.equals(loadedName)) break;
                        File dir = modelDir(ctx, name);
                        if (!new File(dir, "am/final.mdl").exists()) downloadAndUnzip(dir, name);
                        setStatus("loading model");
                        Model m = new Model(dir.getAbsolutePath());
                        Model old = model; model = m; loadedName = name;
                        try { if (old != null) old.close(); } catch (Throwable ignored) { }
                        setStatus("ready");
                        if (name.equals(wantedName)) break;
                    }
                } catch (Throwable t) { Log.e(TAG, "model load failed", t); setStatus("model error: " + t.getMessage()); }
                finally { loading = false; }
            }
        }, "caption-model").start();
    }

    private void setStatus(String s) { status = s; Log.i(TAG, s); try { listener.status(s); } catch (Throwable ignored) { } }

    private void downloadAndUnzip(File dir, String name) throws Exception {
        File zip = new File(ctx.getCacheDir(), name + ".zip");
        HttpURLConnection c = (HttpURLConnection) new URL("https://alphacephei.com/vosk/models/" + name + ".zip").openConnection();
        c.setConnectTimeout(15000); c.setReadTimeout(60000);
        if (c.getResponseCode() != 200) throw new Exception("HTTP " + c.getResponseCode() + " downloading the model");
        long total = c.getContentLengthLong();
        try (InputStream in = new BufferedInputStream(c.getInputStream()); FileOutputStream out = new FileOutputStream(zip)) {
            byte[] buf = new byte[65536]; long done = 0; int n; long lastPct = -1;
            while ((n = in.read(buf)) > 0) {
                out.write(buf, 0, n); done += n;
                long pct = total > 0 ? done * 100 / total : -1;
                if (pct != lastPct && pct % 5 == 0) { lastPct = pct; setStatus("downloading " + name.replace("vosk-model-", "") + " (" + (total / 1048576) + " MB) " + pct + "%"); }
            }
        } finally { c.disconnect(); }
        setStatus("unpacking model");
        File root = dir.getParentFile(); root.mkdirs();
        try (ZipInputStream z = new ZipInputStream(new BufferedInputStream(new FileInputStream(zip)))) {
            ZipEntry e; byte[] buf = new byte[65536];
            while ((e = z.getNextEntry()) != null) {
                File f = new File(root, e.getName());
                if (!f.getCanonicalPath().startsWith(root.getCanonicalPath())) continue;   // zip-slip guard
                if (e.isDirectory()) { f.mkdirs(); continue; }
                f.getParentFile().mkdirs();
                try (FileOutputStream out = new FileOutputStream(f)) { int n; while ((n = z.read(buf)) > 0) out.write(buf, 0, n); }
            }
        }
        zip.delete();
        if (!new File(dir, "am/final.mdl").exists()) throw new Exception("the model archive did not contain " + name);
    }

    /** Begin an utterance: audio from {@link #feed8kMono} is recognised until {@link #stop} or a pause. */
    public synchronized void start() {
        if (active) return;
        active = true;
        synchronized (finalText) { finalText.setLength(0); }
        final LinkedBlockingQueue<byte[]> q = new LinkedBlockingQueue<>();
        queue = q;
        new Thread(() -> {
            Recognizer rec = null;
            try {
                if (model == null || !wantedName.equals(loadedName)) { ensureLoaded(); if (model == null) { listener.status(status.startsWith("downloading") || status.startsWith("unpacking") || status.startsWith("loading") ? status : "preparing the speech model…"); return; } }
                rec = new Recognizer(model, 16000.0f);
                String lastPartial = ""; long fed = 0, t0 = System.currentTimeMillis(); int chunks = 0;
                while (true) {
                    byte[] b = q.poll(PAUSE_MS, TimeUnit.MILLISECONDS);
                    if (b == null || b.length == 0) { Log.i(TAG, "utterance end: " + (b == null ? "pause" : "stop") + ", " + chunks + " chunks, " + fed + " bytes in " + (System.currentTimeMillis() - t0) + " ms, queue " + q.size()); break; }
                    fed += b.length; chunks++;
                    if (rec.acceptWaveForm(b, b.length)) { String r = rec.getResult(); emitText(r); lastPartial = ""; }
                    else { String p = text(rec.getPartialResult(), "partial"); if (!p.equals(lastPartial)) { lastPartial = p; if (!p.isEmpty()) listener.partial(p); } }
                }
                emitText(rec.getFinalResult());
            } catch (Throwable t) { Log.w(TAG, "utterance: " + t); }
            finally {
                try { if (rec != null) rec.close(); } catch (Throwable ignored) { }
                queue = null; active = false;
                String t; synchronized (finalText) { t = finalText.toString().trim(); }
                listener.finished(t);
            }
        }, "caption-utterance").start();
    }

    private void emitText(String json) {
        String t = text(json, "text");
        if (t.isEmpty()) return;
        synchronized (finalText) { if (finalText.length() > 0) finalText.append(' '); finalText.append(t); }
        listener.sentence(t);
    }
    private static String text(String json, String key) { try { return new JSONObject(json).optString(key, "").trim(); } catch (Throwable e) { return ""; } }

    /** 8 kHz mono 16-bit → 16 kHz mono (linear interpolation) into the recogniser. */
    public void feed8kMono(byte[] mono, int len) {
        LinkedBlockingQueue<byte[]> q = queue;
        if (q == null) return;
        if (q.size() > 400) { Log.w(TAG, "queue full, dropping audio"); return; }
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

    /** End the utterance; the final text is delivered on the utterance thread. */
    public void stop() { LinkedBlockingQueue<byte[]> q = queue; if (q != null) q.offer(new byte[0]); }
}
