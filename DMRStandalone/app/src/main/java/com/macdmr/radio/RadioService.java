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
        void onLocation(String text);
        void onSms(int from, int type, String text);
        void onSmsResult(boolean ok);       // the intercom's location block ("City, State\n(↓S 25.5mi (41.0km))\n959ft (292m) 📍")
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
    /** Every MCU/audio action runs here, in order — a PTT release can never overtake its press. */
    private final java.util.concurrent.ExecutorService worker = java.util.concurrent.Executors.newSingleThreadExecutor(r -> new Thread(r, "radio-worker"));
    private volatile boolean pttDown;
    private final Runnable txWatchdog = () -> { if (pttDown) { log("TX watchdog: releasing PTT after 28 s"); ptt(false); } };

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
        try { if (pttDown) { if (audio != null) audio.stopTx(); engine.ptt(false); } } catch (Throwable ignored) { }
        try { if (audio != null) { audio.stopRx(); } } catch (Throwable ignored) { }
        engine.close();
        worker.shutdownNow();
        super.onDestroy();
    }

    // ---- lifecycle of the link --------------------------------------------------------------------

    /** Bring the radio up: policy (root), stock app off, UART, power, channel, RX audio. Runs on a worker. */
    public void bringUp() {
        new Thread(() -> {
            try {
                setLink("root");
                boolean root = RootSetup.haveRoot();
                if (!root) {
                    boolean stockRunning = !RootSetup.run("pidof " + profile.stockApp).trim().replaceAll("[^0-9]", "").isEmpty();
                    if (stockRunning || !new java.io.File(profile.controlPort).canRead()) {
                        setLink("no root");
                        log("Root was not granted. Open the Magisk app → Superuser → allow \"DMR Radio\", then tap Bring radio up. (Without root the stock app keeps the radio and the UART stays locked.)");
                        return;
                    }
                    log("No root granted, but the UART is reachable and the stock app is not running — continuing");
                } else {
                    log("sepolicy: " + RootSetup.applySepolicy(getFilesDir(), profile));
                    RootSetup.ensureTty(profile);
                    if (RootSetup.stockAppEnabled(profile)) { log("stock app paused (its icon disappears while this app owns the radio; Device → Release brings it back): " + RootSetup.stockApp(profile, false)); Thread.sleep(1500); }
                }
                if (store.count() == 0) {
                    StringBuilder err = new StringBuilder();
                    int n = store.importFromStock(this, profile.stockApp, "default_uhf", err);
                    log(n >= 0 ? "imported " + n + " channels from the stock app" : "stock import failed: " + err);
                }
                setLink("uart");
                engine.open();
                if (engine.powerOn()) {                       // the stock app pulls the module's power when it is disabled
                    setLink("booting");
                    if (!engine.waitBooted(12000)) log("no boot banner within 12 s — continuing anyway");
                    Thread.sleep(300);
                }
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
        if (current == null || pttDown) return;
        int n = store.count(); if (n == 0) return;
        int next = ((current.number - 1 + delta) % n + n) % n + 1;
        selectChannel(next);
    }

    public void selectChannel(final int number) { worker.execute(() -> selectChannelNow(number)); }

    private synchronized void selectChannelNow(int number) {
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
            describeLocation(ch);
            updateNotification();
        } catch (IOException e) { log("select: " + e); }
    }

    /** Reverse-geocode the channel's stored position and add distance/bearing from the phone, like the module. */
    private void describeLocation(final ChannelStore.Channel ch) {
        if (ch.lat == 0 && ch.lon == 0) { ui.post(() -> { for (Listener l : listeners) l.onLocation(""); }); return; }
        new Thread(() -> {
            String place = String.format(Locale.US, "%.4f, %.4f", ch.lat, ch.lon);
            try {
                java.util.List<android.location.Address> a = new android.location.Geocoder(this, Locale.US).getFromLocation(ch.lat, ch.lon, 1);
                if (a != null && !a.isEmpty()) {
                    android.location.Address ad = a.get(0);
                    String city = ad.getLocality() != null ? ad.getLocality() : ad.getSubAdminArea();
                    String state = ad.getAdminArea();
                    if (city != null && state != null) place = city + ", " + state; else if (city != null) place = city; else if (state != null) place = state;
                }
            } catch (Throwable ignored) { }
            String dist = "";
            try {
                android.location.LocationManager lm = (android.location.LocationManager) getSystemService(LOCATION_SERVICE);
                android.location.Location me = null;
                for (String p : new String[] { android.location.LocationManager.GPS_PROVIDER, android.location.LocationManager.NETWORK_PROVIDER, android.location.LocationManager.PASSIVE_PROVIDER }) {
                    try { android.location.Location l = lm.getLastKnownLocation(p); if (l != null && (me == null || l.getTime() > me.getTime())) me = l; } catch (SecurityException ignored) { }
                }
                if (me != null) {
                    float[] r = new float[2];
                    android.location.Location.distanceBetween(me.getLatitude(), me.getLongitude(), ch.lat, ch.lon, r);
                    double km = r[0] / 1000.0, mi = km * 0.621371; float b = (r[1] + 360) % 360;
                    String[] dirs = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" };
                    String arrow = b < 22.5 || b >= 337.5 ? "\u2191" : b < 67.5 ? "\u2197" : b < 112.5 ? "\u2192" : b < 157.5 ? "\u2198" : b < 202.5 ? "\u2193" : b < 247.5 ? "\u2199" : b < 292.5 ? "\u2190" : "\u2196";
                    dist = String.format(Locale.US, "\n(%s%s %.1fmi (%.1fkm))", arrow, dirs[(int) Math.round(b / 45.0) % 8], mi, km);
                }
            } catch (Throwable ignored) { }
            double el = ch.elev;
            if (el <= 0) {                                   // the module looks this up online (open-elevation) and so do we, cached
                String k = String.format(Locale.US, "elev_%.4f_%.4f", ch.lat, ch.lon);
                android.content.SharedPreferences ep = getSharedPreferences("elevation", MODE_PRIVATE);
                if (ep.contains(k)) el = ep.getFloat(k, 0);
                else {
                    try {
                        java.net.HttpURLConnection cn = (java.net.HttpURLConnection) new java.net.URL(String.format(Locale.US, "https://api.open-elevation.com/api/v1/lookup?locations=%.6f,%.6f", ch.lat, ch.lon)).openConnection();
                        cn.setConnectTimeout(5000); cn.setReadTimeout(8000);
                        if (cn.getResponseCode() == 200) {
                            java.io.BufferedReader br = new java.io.BufferedReader(new java.io.InputStreamReader(cn.getInputStream()));
                            StringBuilder sb = new StringBuilder(); String ln; while ((ln = br.readLine()) != null) sb.append(ln);
                            el = new org.json.JSONObject(sb.toString()).getJSONArray("results").getJSONObject(0).getDouble("elevation");
                            ep.edit().putFloat(k, (float) el).apply();
                        }
                    } catch (Throwable ignored) { }
                }
            }
            String elev = el > 0 ? String.format(Locale.US, "\n%dft (%.0fm) ", (int) (el * 3.28084), el) : "\n";
            final String text = place + dist + elev + "\uD83D\uDCCD";
            ui.post(() -> { for (Listener l : listeners) l.onLocation(text); });
        }, "geocode").start();
    }

    public void deleteChannel(ChannelStore.Channel ch) {
        store.delete(ch);
        if (current != null && current.id == ch.id) { current = null; int n = store.count(); if (n > 0) selectChannel(Math.min(ch.number, n)); }
    }

    /** Save an edited or new channel; if it is the active one, re-program the radio. */
    public void saveChannel(ChannelStore.Channel ch, boolean isNew) {
        if (isNew) store.insert(ch); else store.update(ch);
        if (!isNew && current != null && current.id == ch.id) selectChannel(ch.number);
    }

    public void setLocalId(int id) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("dmrId", id).apply(); if (current != null && current.isDigital()) selectChannel(current.number); }

    public String reimportFromStock() {
        StringBuilder err = new StringBuilder();
        int n = store.importFromStock(this, profile.stockApp, "default_uhf", err);
        if (n >= 0) { int keep = store.activeNumber(); selectChannel(keep); }
        return n >= 0 ? "Imported " + n + " channels" + (err.length() > 0 ? " (" + err + ")" : "") : "Import failed: " + err;
    }

    public int localId() { return getSharedPreferences("radio", MODE_PRIVATE).getInt("dmrId", 1); }

    // ---- PTT ----------------------------------------------------------------------------------------

    public boolean txInhibited() {
        ChannelStore.Channel ch = current;
        if (ch == null) return true;
        int f = ch.txFreq;
        return f >= 162_400_000 && f <= 162_550_000;      // NOAA weather channels are receive-only
    }

    public void ptt(final boolean down) {
        worker.execute(() -> {
            try {
                if (down) {
                    if (!isReady()) { log("PTT ignored: radio not ready"); return; }
                    if (txInhibited()) { log("PTT blocked: receive-only channel"); ui.post(() -> { for (Listener l : listeners) l.onHistory("⛔ TX blocked on a receive-only channel"); }); return; }
                    if (pttDown) return;
                    pttDown = true;
                    if (audio != null) audio.stopRx();              // never play the RX stream while the mic is live (feedback)
                    engine.ptt(true);
                    if (audio != null) log(audio.startTx());
                    ui.removeCallbacks(txWatchdog); ui.postDelayed(txWatchdog, 28000);
                } else {
                    if (!pttDown) return;
                    pttDown = false;
                    ui.removeCallbacks(txWatchdog);
                    try { if (audio != null) audio.stopTx(); } finally { engine.ptt(false); }
                    if (rxAudioOn && audio != null) audio.startRx(true);
                }
            } catch (Throwable t) { log("ptt: " + t); try { engine.ptt(false); } catch (Throwable ignored) { } pttDown = false; }
        });
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
            case 5: try { engine.fetchSms(); } catch (IOException ignored) { } break;             // SMS_RECEIVED -> ask for it
            case 8: smsResult(true); break;
            case 9: smsResult(false); break;
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

    private volatile long pendingSmsId = -1;

    @Override public void sms(int type, int fromId, String text) {
        int t = type == 3 ? 1 : type == 2 ? 2 : 0;                         // store with our contact-type codes
        store.addMessage(fromId, t, false, text, 1);
        history("sms", "✉ Text from " + fromId + ": " + (text.length() > 40 ? text.substring(0, 40) + "…" : text));
        ui.post(() -> { for (Listener l : listeners) l.onSms(fromId, t, text); });
    }

    private void smsResult(boolean ok) {
        long id = pendingSmsId; pendingSmsId = -1;
        if (id >= 0) store.setMessageStatus(id, ok ? 1 : 2);
        if (!ok) log("text message failed");
        ui.post(() -> { for (Listener l : listeners) l.onSmsResult(ok); });
    }

    /** Send a DMR text to a contact (private / group / all) over the current digital channel. */
    public void sendSms(final ChannelStore.Contact to, final String text) {
        final long id = store.addMessage(to.number, to.type, true, text, 0);
        worker.execute(() -> {
            try {
                int msgType = to.type == 1 ? 3 : to.type == 2 ? 2 : 1;
                pendingSmsId = id;
                engine.sendSms(msgType, to.number, to.type == 1 ? to.number : 0, text);
            } catch (Throwable t) { store.setMessageStatus(id, 2); log("sms: " + t); ui.post(() -> { for (Listener l : listeners) l.onSmsResult(false); }); }
        });
    }

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
