package com.macdmr.transcription;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import org.vosk.LibVosk;
import org.vosk.LogLevel;
import org.vosk.Model;
import org.vosk.Recognizer;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * On-device live captions (2026-10-17): a Vosk (Kaldi) recognizer behind a localhost socket.
 *
 * The DMRModHooks module (running inside the radio app) cannot host Vosk itself — its JNA layer does
 * not survive the LSPosed class-loader isolation — so it streams the received audio here instead:
 * connect to 127.0.0.1:{@value #PORT}, write raw 16 kHz 16-bit mono PCM, read JSON lines back
 * ({@code {"partial":...}} while the other station talks, {@code {"text":...}} for finished
 * utterances, {@code {"status":...}} while the model is still downloading/loading). Closing the
 * sending half of the socket ends the utterance; the final result is sent and the socket closed.
 *
 * The small English model (~41 MB) is downloaded once from alphacephei.com into this app's files
 * directory on first start. No cloud, no API key, nothing leaves the phone afterwards.
 */
public class LiveCaptionService extends Service {
    private static final String TAG = "LiveCaption";
    public static final int PORT = 8002;
    /** Default model; the module can switch with intent extra "model" (persisted in prefs). */
    public static final String DEFAULT_MODEL = "vosk-model-en-us-0.22-lgraph";
    private static final String CHANNEL_ID = "live_caption";
    private static final int NOTIFICATION_ID = 42;

    private volatile Model model;
    private volatile String modelName = DEFAULT_MODEL;
    private volatile String status = "starting";
    private volatile boolean running = false;
    private ServerSocket server;
    private Thread initThread;

    private static String modelUrl(String name) { return "https://alphacephei.com/vosk/models/" + name + ".zip"; }
    /** Serialises model loads: a switch requested while the first load is still running must not download in parallel. */
    private final Object loadLock = new Object();
    private volatile String loadedName = null;

    @Override
    public void onCreate() {
        super.onCreate();
        startForeground(NOTIFICATION_ID, buildNotification("Live captions: starting"));
        modelName = getSharedPreferences("caption", MODE_PRIVATE).getString("model", DEFAULT_MODEL);
        running = true;
        initThread = new Thread(new Runnable() { @Override public void run() { init(); } }, "caption-init");
        initThread.start();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && intent.getBooleanExtra("stop", false)) {
            stopSelf();
            return START_NOT_STICKY;
        }
        String wanted = intent != null ? intent.getStringExtra("model") : null;
        if (wanted != null && !wanted.trim().isEmpty() && !wanted.equals(modelName)) {
            // switch model: remember it, drop the current one, re-run init (download if needed)
            getSharedPreferences("caption", MODE_PRIVATE).edit().putString("model", wanted).apply();
            modelName = wanted;
            setStatus("switching to " + wanted);
            new Thread(new Runnable() { @Override public void run() { loadOnly(); } }, "caption-switch").start();
        }
        return START_STICKY;
    }

    /** Download (if needed) + load the selected model without touching the already-running server. */
    private void loadOnly() {
        synchronized (loadLock) {
            while (true) {
                String name = modelName;                       // snapshot: may change while we download
                if (model != null && name.equals(loadedName)) return;
                try {
                    File dir = new File(getFilesDir(), "models/" + name);
                    if (!new File(dir, "am/final.mdl").exists()) {
                        setStatus("downloading model");
                        downloadAndUnzip(dir, name);
                    }
                    setStatus("loading model");
                    Model m = new Model(dir.getAbsolutePath());
                    Model old = model; model = m; loadedName = name;
                    try { if (old != null) old.close(); } catch (Exception ignored) { }
                    setStatus("ready");
                } catch (Throwable t) {
                    Log.e(TAG, "model load failed", t);
                    setStatus("error: " + t.getMessage());
                    return;
                }
                if (name.equals(modelName)) return;            // a newer request arrived meanwhile: loop once more
            }
        }
    }

    @Override
    public IBinder onBind(Intent intent) { return null; }

    @Override
    public void onDestroy() {
        running = false;
        try { if (server != null) server.close(); } catch (Exception ignored) { }
        try { if (model != null) model.close(); } catch (Exception ignored) { }
        super.onDestroy();
    }

    // ------------------------------------------------------------------ model + server

    private void init() {
        try {
            LibVosk.setLogLevel(LogLevel.WARNINGS);
            loadOnly();
            serve();
        } catch (Throwable t) {
            Log.e(TAG, "init failed", t);
            setStatus("error: " + t.getMessage());
            // keep serving so the client gets the status line instead of a refused connection
            try { serve(); } catch (Throwable ignored) { }
        }
    }

    private void downloadAndUnzip(File dir, String name) throws Exception {
        File zip = new File(getCacheDir(), name + ".zip");
        HttpURLConnection c = (HttpURLConnection) new URL(modelUrl(name)).openConnection();
        c.setConnectTimeout(15000); c.setReadTimeout(60000);
        long total = c.getContentLengthLong();
        try (InputStream in = new BufferedInputStream(c.getInputStream()); FileOutputStream out = new FileOutputStream(zip)) {
            byte[] buf = new byte[65536]; long done = 0; int n; long lastPct = -1;
            while ((n = in.read(buf)) > 0) {
                out.write(buf, 0, n); done += n;
                long pct = total > 0 ? done * 100 / total : -1;
                if (pct != lastPct && pct % 5 == 0) { lastPct = pct; setStatus("downloading " + name.replace("vosk-model-", "") + " (" + (total / 1048576) + " MB) " + pct + "%"); }
            }
        }
        setStatus("unpacking model");
        File modelsRoot = dir.getParentFile();
        modelsRoot.mkdirs();
        try (ZipInputStream z = new ZipInputStream(new BufferedInputStream(new java.io.FileInputStream(zip)))) {
            ZipEntry e;
            byte[] buf = new byte[65536];
            while ((e = z.getNextEntry()) != null) {
                File f = new File(modelsRoot, e.getName());
                if (!f.getCanonicalPath().startsWith(modelsRoot.getCanonicalPath())) continue;   // zip-slip guard
                if (e.isDirectory()) { f.mkdirs(); continue; }
                f.getParentFile().mkdirs();
                try (FileOutputStream out = new FileOutputStream(f)) { int n; while ((n = z.read(buf)) > 0) out.write(buf, 0, n); }
            }
        }
        zip.delete();
    }

    private void serve() throws Exception {
        server = new ServerSocket(PORT, 2, InetAddress.getByName("127.0.0.1"));
        Log.i(TAG, "listening on 127.0.0.1:" + PORT + " (" + status + ")");
        while (running) {
            final Socket s = server.accept();
            new Thread(new Runnable() { @Override public void run() { handle(s); } }, "caption-client").start();
        }
    }

    private void handle(Socket s) {
        Recognizer rec = null;
        try {
            s.setTcpNoDelay(true);
            InputStream in = s.getInputStream();
            OutputStream out = s.getOutputStream();
            if (model == null) {
                send(out, "{\"status\":\"" + status.replace("\"", "'") + "\"}");
                s.close();
                return;
            }
            send(out, "{\"status\":\"ready\"}");
            rec = new Recognizer(model, 16000.0f);
            byte[] buf = new byte[4096];
            String lastPartial = "";
            int n;
            while ((n = in.read(buf)) > 0) {
                if (rec.acceptWaveForm(buf, n)) {
                    send(out, rec.getResult());
                    lastPartial = "";
                } else {
                    String p = rec.getPartialResult();
                    if (!p.equals(lastPartial)) { lastPartial = p; send(out, p); }
                }
            }
            send(out, rec.getFinalResult());
        } catch (Throwable t) {
            Log.w(TAG, "client: " + t.getMessage());
        } finally {
            try { if (rec != null) rec.close(); } catch (Exception ignored) { }
            try { s.close(); } catch (Exception ignored) { }
        }
    }

    private static void send(OutputStream out, String json) throws Exception {
        out.write((json.replace("\n", " ") + "\n").getBytes(StandardCharsets.UTF_8));
        out.flush();
    }

    // ------------------------------------------------------------------ notification

    private void setStatus(String st) {
        status = st;
        Log.i(TAG, st);
        try {
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            if (nm != null) nm.notify(NOTIFICATION_ID, buildNotification("Live captions: " + st));
        } catch (Exception ignored) { }
    }

    private Notification buildNotification(String text) {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && nm != null) {
            NotificationChannel ch = new NotificationChannel(CHANNEL_ID, "Live captions", NotificationManager.IMPORTANCE_LOW);
            ch.setDescription("On-device speech recognition for the radio");
            nm.createNotificationChannel(ch);
        }
        Notification.Builder b = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                ? new Notification.Builder(this, CHANNEL_ID) : new Notification.Builder(this);
        return b.setContentTitle("DMR live captions")
                .setContentText(text)
                .setSmallIcon(android.R.drawable.ic_btn_speak_now)
                .setOngoing(true)
                .build();
    }
}
