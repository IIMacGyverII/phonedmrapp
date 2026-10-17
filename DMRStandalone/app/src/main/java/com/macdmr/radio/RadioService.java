package com.macdmr.radio;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Owns the radio while the app runs: engine (UART), audio backend, channel store, current state.
 * Activities bind and register a {@link Listener}; everything the UI shows comes through it.
 */
public class RadioService extends Service implements RadioEngine.Events {
    private static final String TAG = "RadioService";

    public interface Listener {
        void onChannel(ChannelStore.Channel ch);
        void onRx(boolean receiving);
        void onTx(boolean transmitting);
        void onRssi(int dbm);
        void onAudioLevel(int amplitude);
        void onHistory(String line);
        void onCaller(String text);
        void onLog(String s);
        void onLink(String state);          // "no root", "policy", "uart closed", "ready"…
    }

    public class LocalBinder extends Binder { public RadioService get() { return RadioService.this; } }
    private final LocalBinder binder = new LocalBinder();
    private final List<Listener> listeners = new ArrayList<>();
    private final Handler ui = new Handler(Looper.getMainLooper());

    private DeviceProfile profile;
    private RadioEngine engine;
    private TinyServiceAudio audio;
    private ChannelStore store;
    private ChannelStore.Channel current;
    private volatile boolean receiving, transmitting, rxAudioOn;
    private volatile int rssi = -999;
    private volatile long rxStart;
    private volatile int lastCaller, lastCallType, lastTarget;
    private String link = "stopped";

    @Override public void onCreate() {
        super.onCreate();
        startForeground(1, notification("Radio idle"));
        profile = DeviceProfile.detect();
        store = new ChannelStore(this);
        engine = new RadioEngine(profile, this);
    }

    @Override public IBinder onBind(Intent i) { return binder; }
    @Override public int onStartCommand(Intent i, int f, int id) { return START_STICKY; }

    @Override public void onDestroy() {
        try { if (audio != null) { audio.stopRx(); } } catch (Throwable ignored) { }
        engine.close();
        super.onDestroy();
    }

    // ---- lifecycle of the link --------------------------------------------------------------------

    /** Bring the radio up: policy (root), stock app off, UART, power, channel, RX audio. Runs on a worker. */
    public void bringUp() {
        new Thread(() -> {
            try {
                setLink("root");
                boolean root = RootSetup.haveRoot();
                if (!root) log("No root (Magisk) granted — trying the UART anyway (works if the policy rules are already live)");
                else {
                    log("sepolicy: " + RootSetup.applySepolicy(getFilesDir(), profile));
                    RootSetup.ensureTty(profile);
                    if (RootSetup.stockAppEnabled(profile)) { log("stock app off: " + RootSetup.stockApp(profile, false)); Thread.sleep(1500); }
                }
                if (store.count() == 0) {
                    StringBuilder err = new StringBuilder();
                    int n = store.importFromStock(this, profile.stockApp, "default_uhf", err);
                    log(n >= 0 ? "imported " + n + " channels from the stock app" : "stock import failed: " + err);
                }
                setLink("uart");
                engine.open();
                engine.powerOn();
                if (!engine.waitBooted(100)) { /* already booted: no banner expected */ }
                engine.queryVersion();
                selectChannel(store.activeNumber());
                startRxAudio();
                setLink("ready");
            } catch (Throwable t) { log("bring-up failed: " + t); setLink("error: " + t.getMessage()); }
        }, "radio-bringup").start();
    }

    public void shutDown(final boolean restoreStock) {
        new Thread(() -> {
            try { if (audio != null) audio.stopRx(); } catch (Throwable ignored) { }
            engine.close();
            if (restoreStock) log("stock app on: " + RootSetup.stockApp(profile, true));
            setLink("stopped");
        }, "radio-shutdown").start();
    }

    private void startRxAudio() {
        try {
            if (audio == null) {
                audio = new TinyServiceAudio();
                audio.setSink((b, len) -> {
                    int peak = 0;
                    for (int i = 0; i + 1 < len; i += 8) { int v = Math.abs((short) ((b[i] & 0xFF) | (b[i + 1] << 8))); if (v > peak) peak = v; }
                    final int p = peak; ui.post(() -> { for (Listener l : listeners) l.onAudioLevel(p); });
                });
            }
            log(audio.startRx(true)); rxAudioOn = true;
        } catch (Throwable t) { log("audio: " + t); }
    }

    // ---- channel ------------------------------------------------------------------------------------

    public ChannelStore store() { return store; }
    public ChannelStore.Channel current() { return current; }
    public DeviceProfile profile() { return profile; }
    public String link() { return link; }
    public boolean isReady() { return "ready".equals(link); }

    public void stepChannel(int delta) {
        if (current == null) return;
        int n = store.count(); if (n == 0) return;
        int next = ((current.number - 1 + delta) % n + n) % n + 1;
        selectChannel(next);
    }

    public synchronized void selectChannel(int number) {
        ChannelStore.Channel ch = store.byNumber(number);
        if (ch == null) { log("no channel " + number); return; }
        try {
            if (ch.isDigital()) {
                engine.setDigital(ch.rxFreq, ch.txFreq, localId(), ch.groups, ch.txContact, ch.contactType, ch.power, ch.cc, ch.inSlot, ch.outSlot, 8, 4);
                engine.setInterrupt(ch.interrupt == 1);
            } else {
                int band = ch.rxFreq < 300_000_000 ? 1 : ch.band;      // VHF must be band=1 (band=0 deafens the RX)
                engine.setAnalog(ch.rxFreq, ch.txFreq, band, ch.power, 0 /* soft squelch in software */, ch.rxType, ch.rxSubCode, ch.txType, ch.txSubCode, 8, 2);
            }
            current = ch; store.setActive(number);
            ui.post(() -> { for (Listener l : listeners) l.onChannel(ch); });
            updateNotification();
        } catch (IOException e) { log("select: " + e); }
    }

    public int localId() { return getSharedPreferences("radio", MODE_PRIVATE).getInt("dmrId", 1); }

    // ---- PTT ----------------------------------------------------------------------------------------

    public void ptt(boolean down) {
        new Thread(() -> {
            try {
                if (down) { engine.ptt(true); if (audio != null) log(audio.startTx()); }
                else { if (audio != null) audio.stopTx(); engine.ptt(false); }
            } catch (Throwable t) { log("ptt: " + t); }
        }, "ptt").start();
    }

    public void pollRssi() { try { if (engine.isOpen()) engine.queryRssi(); } catch (IOException ignored) { } }

    // ---- listeners ----------------------------------------------------------------------------------

    public void addListener(Listener l) { listeners.add(l); l.onLink(link); if (current != null) l.onChannel(current); }
    public void removeListener(Listener l) { listeners.remove(l); }

    private void setLink(String s) { link = s; ui.post(() -> { for (Listener l : listeners) l.onLink(s); }); updateNotification(); }

    private void history(String kind, String text) {
        int chNum = current != null ? current.number : 0;
        store.addHistory(chNum, kind, text, rssi, lastCaller);
        String line = new java.text.SimpleDateFormat("HH:mm:ss", Locale.US).format(new java.util.Date()) + " " + text + (rssi != -999 ? " " + rssi + " dBm" : "");
        ui.post(() -> { for (Listener l : listeners) l.onHistory(line); });
    }

    // ---- RadioEngine.Events -------------------------------------------------------------------------

    @Override public void log(String s) { Log.i(TAG, s); ui.post(() -> { for (Listener l : listeners) l.onLog(s); }); }

    @Override public void status(int code, String name) {
        switch (code) {
            case 1: receiving = true; rxStart = System.currentTimeMillis(); ui.post(() -> { for (Listener l : listeners) l.onRx(true); }); pollRssi(); break;
            case 2: {
                receiving = false; long len = rxStart > 0 ? System.currentTimeMillis() - rxStart : 0; rxStart = 0;
                if (current != null && current.isDigital()) { try { engine.queryCallerInfo(); } catch (IOException ignored) { } }   // who was that (0x2B)
                if (current != null && !current.isDigital() && len >= 700) history("rx", "📻 Received " + Math.round(len / 1000.0) + " s");
                ui.post(() -> { for (Listener l : listeners) l.onRx(false); });
                break;
            }
            case 3: transmitting = true; ui.post(() -> { for (Listener l : listeners) l.onTx(true); }); break;
            case 4: transmitting = false; history("tx", "📻 Voice TX"); ui.post(() -> { for (Listener l : listeners) l.onTx(false); }); break;
            case 7: history("busy", "⚠ Channel busy"); break;
            default: log("status " + name);
        }
    }

    @Override public void rssi(int raw, double dbm) { rssi = (int) Math.round(dbm); ui.post(() -> { for (Listener l : listeners) l.onRssi(rssi); }); }
    @Override public void version(int v, String text) { log("module " + text); }
    @Override public void callerInfo(int type, int caller, int target) {
        if (caller <= 0) return;
        lastCaller = caller; lastCallType = type; lastTarget = target;
        String t = (type == 1 ? "TG " + target : type == 2 ? "All call" : "Private") ;
        history("dmr", "📻 Voice RX " + t + " from " + caller);
        ui.post(() -> { for (Listener l : listeners) l.onCaller("ID " + caller + "  " + t); });
    }
    @Override public void ack(int cmd, boolean ok) { if (!ok) log(String.format(Locale.US, "MCU rejected 0x%02X", cmd)); }
    @Override public void booted(String banner) { log("module booted: " + banner); }

    // ---- notification -------------------------------------------------------------------------------

    private Notification notification(String text) {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= 26 && nm != null) nm.createNotificationChannel(new NotificationChannel("radio", "Radio", NotificationManager.IMPORTANCE_LOW));
        Notification.Builder b = Build.VERSION.SDK_INT >= 26 ? new Notification.Builder(this, "radio") : new Notification.Builder(this);
        return b.setContentTitle("DMR Radio").setContentText(text).setSmallIcon(android.R.drawable.stat_sys_speakerphone).setOngoing(true).build();
    }

    private void updateNotification() {
        try {
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            String t = current != null ? "Ch " + current.number + "  " + current.name + "  (" + link + ")" : link;
            if (nm != null) nm.notify(1, notification(t));
        } catch (Throwable ignored) { }
    }
}
