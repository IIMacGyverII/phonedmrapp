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
        void onSmsResult(boolean ok);
        void onModes(boolean softSq, int softSqLevel, boolean squelchOpen, boolean monitor, boolean recording, boolean scanning, boolean holding, String zoneName);
        void onCaption(boolean enabled, String live, String sentence);   // live = current partial ("" to clear); sentence = a finished line (null if none)       // the intercom's location block ("City, State\n(↓S 25.5mi (41.0km))\n959ft (292m) 📍")
    }

    public class LocalBinder extends Binder { public RadioService get() { return RadioService.this; } }
    private final LocalBinder binder = new LocalBinder();
    private final List<Listener> listeners = new ArrayList<>();
    private final Handler ui = new Handler(Looper.getMainLooper());
    /** The running service, for the widget and notification buttons (set in onCreate, cleared in onDestroy). */
    public static volatile RadioService running;

    private DeviceProfile profile;
    private RadioEngine engine;
    private AudioBackend audio;
    private ChannelStore store;
    private ChannelStore.Channel current;
    private volatile boolean receiving, transmitting, rxAudioOn;
    private volatile int rssi = -999;
    private volatile long rxStart;
    private volatile boolean rxCounts;   // decided at RECEIVE_START: the matching STOP can arrive after a retune, when "current" is already the next channel
    private volatile int lastCaller, lastCallType, lastTarget;
    private String link = "stopped";
    private final com.macdmr.radio.dsp.SoftSquelch softSq = new com.macdmr.radio.dsp.SoftSquelch();
    private volatile boolean monitorOn, recordOn, squelchOpen;
    private WavRecorder recorder;
    private volatile boolean captionsOn;
    private volatile long captionLastEnd;
    private VoskCaptions captions;
    private long zoneId;                       // 0 = all channels
    private final Scanner scanner = new Scanner(new Scanner.Host() {
        @Override public java.util.List<ChannelStore.Channel> candidates() { return zoneChannels(); }
        @Override public void tune(ChannelStore.Channel ch) { selectChannel(ch.number); }
        @Override public boolean receiving() { return softSq.isEnabled() ? squelchOpen : receiving; }   // with Soft SQ on the module's squelch is open and it reports a reception all the time: the soft gate is the activity signal
        @Override public boolean softGated() { return softSq.isEnabled(); }
        @Override public ChannelStore.Channel priority() { int n = scanPriority(); return n > 0 ? store.byNumber(n) : null; }
        @Override public void status(boolean s, boolean h, ChannelStore.Channel on) {
            if (voiceOn()) {
                if (s && h && on != null) sayChannel("Holding " + channelWords(on));                       // the scan stopped on activity
                else if (s && !h) { ui.removeCallbacks(channelSay); pendingChannelSay = null; if (speakingChannel && tts != null) try { tts.stop(); } catch (Throwable ignored) { } }   // moving on: drop it
                else if (!s && current != null) sayChannel(channelWords(current));                          // scan off: where you are
            }
            if (!s) { final ChannelStore.Channel ch = current; if (ch != null && !ch.isDigital() && !ch.softSq && scanSoftSq()) worker.execute(() -> refreshSquelch(ch)); } pushModes(); }   // scan over: a channel that only had Soft SQ for the scan goes back to its own squelch
    });
    /** Every MCU/audio action runs here, in order — a PTT release can never overtake its press. */
    private final java.util.concurrent.ExecutorService worker = java.util.concurrent.Executors.newSingleThreadExecutor(r -> new Thread(r, "radio-worker"));
    private volatile boolean pttDown;
    private final Runnable txWatchdog = () -> { if (pttDown) { log("TX watchdog: releasing PTT after 28 s"); ptt(false); } };
    private PacketEngine packet;
    public PacketEngine packet() { return packet; }
    private RadioIdStore radioId;
    public RadioIdStore radioId() { return radioId; }

    /** Contacts first, then the RadioID register: "Name" or "W1AW Hiram"; empty when unknown. */
    public String callerName(int id) {
        if (id <= 0) return "";
        String n = store.contactName(id, 0);
        if (n != null && !n.isEmpty()) return n;
        RadioIdStore.Record r = radioId != null ? radioId.lookup(id) : null;
        return r != null ? r.display() : "";
    }

    // ---- voice announcements + keyword alerts ----
    private android.speech.tts.TextToSpeech tts; private volatile boolean ttsReady;
    public boolean voiceOn() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("voice", false); }
    public void setVoiceOn(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("voice", on).apply(); if (on) say("Voice announcements on"); }
    /** True while the speech queue holds only a channel announcement, which a newer one may cut off. */
    private volatile boolean speakingChannel;
    private String pendingChannelSay;
    private final Runnable channelSay = () -> {
        String t = pendingChannelSay; pendingChannelSay = null;
        if (t == null || !voiceOn()) return;
        try {
            if (tts == null || !ttsReady) { say(t); speakingChannel = true; return; }
            boolean cut = speakingChannel || !tts.isSpeaking();      // never cut off a caller name or a keyword alert
            log("voice: " + t + (cut ? "" : " (queued behind other speech)"));
            tts.speak(t, cut ? android.speech.tts.TextToSpeech.QUEUE_FLUSH : android.speech.tts.TextToSpeech.QUEUE_ADD, null, "channel");
            speakingChannel = true;
        } catch (Throwable e) { log("tts: " + e); }
    };
    /**
     * Channel announcement: waits 350 ms so quick channel changes announce only where you land, and replaces a
     * channel announcement that is still playing instead of queueing behind it.
     */
    public void sayChannel(final String text) {
        pendingChannelSay = text;
        ui.removeCallbacks(channelSay); ui.postDelayed(channelSay, 350);
    }

    private static String channelWords(ChannelStore.Channel ch) {
        return "Channel " + ch.number + ", " + ch.name.replaceAll("[_]+", " ").replaceAll("\\((UHF|VHF)\\)", "").trim() + (ch.isDigital() ? ", digital" : "");
    }

    public void say(final String text) {
        speakingChannel = false;
        try {
            if (tts == null) { tts = new android.speech.tts.TextToSpeech(this, st -> { ttsReady = st == android.speech.tts.TextToSpeech.SUCCESS; if (ttsReady) { tts.setLanguage(Locale.US); tts.speak(text, android.speech.tts.TextToSpeech.QUEUE_ADD, null, "say"); } }); return; }
            if (ttsReady) tts.speak(text, android.speech.tts.TextToSpeech.QUEUE_ADD, null, "say");
        } catch (Throwable t) { log("tts: " + t); }
    }
    public String keywords() { return getSharedPreferences("radio", MODE_PRIVATE).getString("keywords", ""); }
    public void setKeywords(String k) { getSharedPreferences("radio", MODE_PRIVATE).edit().putString("keywords", k == null ? "" : k.trim()).apply(); }
    private final java.util.HashMap<String, Long> keywordLastHit = new java.util.HashMap<>();
    private void checkKeywords(String sentence) {
        try {
            String raw = keywords(); if (raw.isEmpty() || sentence == null) return;
            String low = " " + sentence.toLowerCase(Locale.US).replaceAll("[^a-z0-9' ]+", " ") + " ";
            long now = System.currentTimeMillis();
            for (String w : raw.toLowerCase(Locale.US).split("[,;\n]+")) {
                w = w.trim(); if (w.isEmpty() || !low.contains(" " + w + " ")) continue;
                synchronized (keywordLastHit) { Long last = keywordLastHit.get(w); if (last != null && now - last < 15000) continue; keywordLastHit.put(w, now); }
                final String word = w, chan = current != null ? current.name : "the radio";
                try { android.os.Vibrator vib = (android.os.Vibrator) getSystemService(VIBRATOR_SERVICE); if (vib != null) vib.vibrate(android.os.VibrationEffect.createWaveform(new long[] { 0, 250, 120, 250, 120, 400 }, -1)); } catch (Throwable ignored) { }
                history("alert", "\uD83D\uDD14 Keyword \"" + word + "\" heard");
                notifyUser("Keyword \"" + word + "\" heard on " + chan, sentence, true);
                if (voiceOn()) say("Keyword " + word + " on " + chan);
                return;
            }
        } catch (Throwable t) { log("keywords: " + t); }
    }
    public boolean packetActive() { return packet != null && (packet.monitoring() || packet.kiss().isActive() || packet.sstvRx()); }

    /** SSTV receive: on the SSTV calling frequency (through the VFO) or on the current channel. */
    public String sstvMonitor(boolean on, boolean park) {
        if (packet == null) return "not ready";
        if (on) {
            if (park) {
                ChannelStore.Channel a = new ChannelStore.Channel();
                a.type = 1; a.rxFreq = a.txFreq = PacketEngine.SSTV_FREQ_HZ; a.band = 1; a.power = 1; a.name = "SSTV 144.500";
                applyVfo(a, false);
            }
            packet.setSstvRx(true); pushModes();
            return park ? "SSTV receive on 144.500 MHz" : "SSTV receive on this channel";
        }
        packet.setSstvRx(false);
        if (vfo != null && vfo.rxFreq == PacketEngine.SSTV_FREQ_HZ) exitVfo();
        pushModes();
        return "SSTV receive off";
    }

    private final PacketEngine.Host packetHost = new PacketEngine.Host() {
        @Override public android.content.Context context() { return RadioService.this; }
        @Override public boolean analogRx() { ChannelStore.Channel c = current; return c != null && !c.isDigital(); }
        @Override public int rxFreqHz() { ChannelStore.Channel c = current; return c == null ? 0 : c.rxFreq; }
        @Override public int channelNumber() { ChannelStore.Channel c = current; return c == null ? 0 : c.number; }
        @Override public String channelName() { ChannelStore.Channel c = current; return c == null ? "" : c.name; }
        @Override public boolean txBusy() { return pttDown; }
        @Override public void transmitPcm(short[] pcm, String label, Runnable onDone) { RadioService.this.transmitPcm(pcm, label, onDone); }
        @Override public android.location.Location location() { return lastKnownLocation(); }
        @Override public void event(String line) { history("pkt", line); }
        @Override public void notifyUser(String title, String text, boolean alert) { RadioService.this.notifyUser(title, text, alert); }
    };

    /** Hands-free one-shot transmission: key, play the PCM through the TX path, release, resume RX. */
    public void transmitPcm(final short[] pcm, final String label, final Runnable onDone) {
        worker.execute(() -> {
            try {
                if (!isReady()) { log("TX " + label + " skipped: radio not ready"); return; }
                if (txInhibited()) { log("TX " + label + " blocked: receive-only channel"); ui.post(() -> { for (Listener l : listeners) l.onHistory("\u26D4 TX blocked on a receive-only channel"); }); return; }
                if (pttDown) { log("TX " + label + " skipped: PTT busy"); return; }
                int ms = pcm.length / 8;
                if (ms > 28500) { log("TX " + label + " refused: " + ms + " ms exceeds the 30 s transmit limit"); ui.post(() -> { for (Listener l : listeners) l.onHistory("\u26D4 Too long for this radio's 30 s transmit limit"); }); return; }
                pttDown = true;
                if (audio != null) audio.stopRx();
                engine.ptt(true);
                log("TX " + label + " (" + ms + " ms)");
                try { Thread.sleep(200); if (audio != null) log(audio.playPcm(pcm)); }
                finally { engine.ptt(false); pttDown = false; if (rxAudioOn && audio != null) audio.startRx(true); }
                if (onDone != null) onDone.run();
            } catch (Throwable t) { log("TX " + label + ": " + t); try { engine.ptt(false); } catch (Throwable ignored) { } pttDown = false; }
        });
    }

    public android.location.Location lastKnownLocation() {
        try {
            android.location.LocationManager lm = (android.location.LocationManager) getSystemService(LOCATION_SERVICE);
            android.location.Location me = null;
            for (String p : new String[] { android.location.LocationManager.GPS_PROVIDER, android.location.LocationManager.NETWORK_PROVIDER, android.location.LocationManager.PASSIVE_PROVIDER }) {
                try { android.location.Location l = lm.getLastKnownLocation(p); if (l != null && (me == null || l.getTime() > me.getTime())) me = l; } catch (SecurityException ignored) { }
            }
            return me;
        } catch (Throwable t) { return null; }
    }

    private int notifyId = 100;
    public void notifyUser(String title, String text, boolean alert) {
        // messages and weather alerts as conversations, so Android Auto reads them aloud (and offers a reply)
        if (title != null && title.startsWith("APRS-IS message from ")) { CarMessages.aprs(this, title.substring("APRS-IS message from ".length()), text, true); return; }
        if (title != null && title.startsWith("APRS message from ")) { CarMessages.aprs(this, title.substring("APRS message from ".length()), text, false); return; }
        if (alert && title != null && title.startsWith("\u26C8")) { CarMessages.alert(this, title.replaceFirst("^\\S+\\s*", ""), text); return; }
        try {
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            if (nm == null) return;
            String ch = alert ? "alerts" : "packet";
            if (Build.VERSION.SDK_INT >= 26) nm.createNotificationChannel(new NotificationChannel(ch, alert ? "Weather alerts" : "APRS messages", alert ? NotificationManager.IMPORTANCE_HIGH : NotificationManager.IMPORTANCE_DEFAULT));
            Notification.Builder b = Build.VERSION.SDK_INT >= 26 ? new Notification.Builder(this, ch) : new Notification.Builder(this);
            b.setSmallIcon(alert ? android.R.drawable.ic_dialog_alert : android.R.drawable.ic_dialog_email).setContentTitle(title).setContentText(text)
                    .setStyle(new Notification.BigTextStyle().bigText(text)).setAutoCancel(true)
                    .setContentIntent(android.app.PendingIntent.getActivity(this, 0, new Intent(this, MainActivity.class), android.app.PendingIntent.FLAG_IMMUTABLE | android.app.PendingIntent.FLAG_UPDATE_CURRENT));
            nm.notify(notifyId++, b.build());
        } catch (Throwable t) { log("notify: " + t); }
    }

    /** APRS monitoring: park on the APRS frequency (through the VFO, so the channel comes back) and decode. */
    public String aprsMonitor(boolean on) {
        if (packet == null) return "not ready";
        if (on) {
            ChannelStore.Channel a = new ChannelStore.Channel();
            a.type = 1; a.rxFreq = a.txFreq = PacketEngine.APRS_FREQ_HZ; a.band = 1; a.power = 1; a.name = "APRS 144.390";
            packet.setMonitoring(true);
            applyVfo(a, false);
            pushModes();
            return "APRS monitoring on 144.390 MHz";
        }
        packet.setMonitoring(false);
        if (vfo != null && vfo.rxFreq == PacketEngine.APRS_FREQ_HZ) exitVfo();
        pushModes();
        return "APRS monitoring off";
    }

    @Override public void onCreate() {
        super.onCreate();
        startForegroundTyped(false);
        running = this;
        watchCar();
        profile = DeviceProfile.detect();
        store = new ChannelStore(this);
        zoneId = getSharedPreferences("radio", MODE_PRIVATE).getLong("zone", 0);
        if (coverage().enabled()) { coverage.resume(); startForegroundTyped(true); }
        engine = new RadioEngine(profile, this);
        packet = new PacketEngine(packetHost);
        radioId = new RadioIdStore(this);
        if (!getSharedPreferences("radio", MODE_PRIVATE).getBoolean("smsStatusMigrated", false)) {     // texts marked failed before 2026-10-17 were only unacknowledged
            try { store.getWritableDatabase().execSQL("UPDATE messages SET status=3 WHERE status=2 AND outgoing=1"); } catch (Throwable ignored) { }
            getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("smsStatusMigrated", true).apply();
        }
        registerHardwarePtt();
    }

    @Override public IBinder onBind(Intent i) { return binder; }
    @Override public int onStartCommand(Intent i, int f, int id) {
        if (i != null && i.getBooleanExtra("bringUp", false) && !"ready".equals(link)) bringUp();   // started by BootReceiver
        return START_STICKY;
    }

    public boolean ownAtBoot() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("ownAtBoot", false); }
    public void setOwnAtBoot(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("ownAtBoot", on).apply(); }

    // ---- the phone's hardware PTT key: the framework broadcasts the profile's down/up actions ----
    private android.content.BroadcastReceiver pttKey;
    private void registerHardwarePtt() {
        if (!profile.supported || profile.pttActions == null || profile.pttActions.length < 2) return;
        pttKey = new android.content.BroadcastReceiver() {
            @Override public void onReceive(android.content.Context c, Intent i) {
                String a = i.getAction(); if (a == null) return;
                if (!getSharedPreferences("radio", MODE_PRIVATE).getBoolean("hwPtt", true)) return;
                for (int k = 0; k < profile.pttActions.length; k++) if (a.equals(profile.pttActions[k])) { if (k % 2 == 0) { if (isReady()) ptt(true); } else ptt(false); return; }
            }
        };
        android.content.IntentFilter f = new android.content.IntentFilter();
        for (String a : profile.pttActions) f.addAction(a);
        try { if (Build.VERSION.SDK_INT >= 33) registerReceiver(pttKey, f, RECEIVER_EXPORTED); else registerReceiver(pttKey, f); } catch (Throwable t) { log("ptt key: " + t); }
    }
    public boolean hwPtt() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("hwPtt", true); }
    public void setHwPtt(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("hwPtt", on).apply(); if (!on && pttDown) ptt(false); }

    @Override public void onDestroy() {
        running = null; RadioWidget.refresh(this, null);
        try { if (coverage != null) coverage.stop(); } catch (Throwable ignored) { }
        stopBluetoothMic();
        try { if (pttKey != null) unregisterReceiver(pttKey); } catch (Throwable ignored) { }
        try { if (pttDown) { if (audio != null) audio.stopTx(); engine.ptt(false); } } catch (Throwable ignored) { }
        try { if (audio != null) { audio.stopRx(); } } catch (Throwable ignored) { }
        engine.close();
        worker.shutdownNow();
        super.onDestroy();
    }

    // ---- lifecycle of the link --------------------------------------------------------------------

    /** Bring the radio up: policy (root), stock app off, UART, power, channel, RX audio. Runs on a worker. */
    public void bringUp() {
        if (!profile.supported) { setLink("unsupported"); log("This phone has no device profile yet. Device tab → Generate device report, then share it on the project's GitHub issues."); return; }
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
                    if (!com.pri.prizeinterphone.serial.port.SerialPort.load(this, profile.serialLib)) log("tty (stty fallback): " + RootSetup.ensureTty(profile));
                    if (RootSetup.stockAppEnabled(profile)) { log("stock app paused (its icon disappears while this app owns the radio; Device → Release brings it back): " + RootSetup.stockApp(profile, false)); Thread.sleep(1500); }
                }
                if (!getSharedPreferences("radio", MODE_PRIVATE).contains("dmrId")) {     // seed our DMR ID from the stock app's setting
                    String xml = RootSetup.run("cat /data/data/" + profile.stockApp + "/shared_prefs/com.pri.prizeinterphone.data.person.xml");
                    java.util.regex.Matcher m = java.util.regex.Pattern.compile("name=\"pref_person_device_id\" value=\"([0-9]+)\"").matcher(xml);
                    if (m.find()) { setLocalIdQuiet(Integer.parseInt(m.group(1))); log("DMR ID from the stock app: " + m.group(1)); }
                }
                if (store.count() == 0) {
                    StringBuilder err = new StringBuilder();
                    int n = store.importFromStock(this, profile.stockApp, "default_uhf", err);
                    log(n >= 0 ? "imported " + n + " channels from the stock app" : "stock import failed: " + err);
                    if (n >= 0) getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("tgListsImported", true).apply();
                }
                if (!getSharedPreferences("radio", MODE_PRIVATE).getBoolean("garbledPktPurged", false)) {   // noise frames logged before the AX.25 plausibility check
                    int k = store.purgeGarbledPacketHistory(); log("removed " + k + " garbled packet lines from the history");
                    getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("garbledPktPurged", true).apply();
                }
                if (!getSharedPreferences("radio", MODE_PRIVATE).getBoolean("tgListsImported", false)) {   // installs imported before TG lists were read
                    StringBuilder err = new StringBuilder();
                    int k = store.repairModuleTgLists(this, profile.stockApp, "default_uhf", err);
                    log(k >= 0 ? "module TG lists imported; " + k + " channels got their list" : "TG list import failed: " + err);
                    if (k >= 0) getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("tgListsImported", true).apply();
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
            if (restoreStock) log("stock app on: " + RootSetup.stockApp(profile, true));
            try { if (audio != null) audio.stopRx(); } catch (Throwable ignored) { }
            engine.close();
            setLink("stopped");
        }, "radio-shutdown").start();
    }

    private void startRxAudio() {
        try {
            if (audio == null) {
                audio = profile.audio == DeviceProfile.Audio.UART_PCM ? new UartPcmAudio(profile.pcmPort, profile.pcmBaud) : new TinyServiceAudio();
                audio.setSink((b, len) -> onRxPcm(b, len));
                audio.setGate(() -> squelchOpen && !muted);
            }
            log(audio.startRx(true)); rxAudioOn = true;
        } catch (Throwable t) { log("audio: " + t); }
    }

    /** Every received 8 kHz stereo (L == R) block: take the left channel, run the squelch, record, meter. */
    private final byte[] mono = new byte[4096];
    private void onRxPcm(byte[] b, int len) {
        int n = 0;
        for (int i = 0; i + 3 < len && n + 1 < mono.length; i += 4) { mono[n++] = b[i]; mono[n++] = b[i + 1]; }
        boolean open = current == null || current.isDigital() ? true : softSq.process(mono, n);
        if (BuildConfig.DEBUG && softSq.isEnabled() && System.currentTimeMillis() - lastSqDiag > 2000) { lastSqDiag = System.currentTimeMillis(); log("soft sq: " + softSq.describe() + " gate=" + open); }
        if (open != squelchOpen && softSq.isEnabled()) log("soft squelch " + (open ? "open" : "closed") + (current != null && current.rxType == 1 ? " (CTCSS " + com.macdmr.radio.dsp.ToneTable.ctcssLabel(current.rxSubCode) + ")" : ""));
        if (open != squelchOpen && softSq.isEnabled()) { softGateHistory(open); squelchOpen = open; pushModes(); }   // pages see the gate (activity box, Soft SQ number colour)
        squelchOpen = open;
        int peak = 0;
        if (open) for (int i = 0; i + 1 < n; i += 2) { int v = Math.abs((short) ((mono[i] & 0xFF) | (mono[i + 1] << 8))); if (v > peak) peak = v; }
        if (captionsOn && open) {
            if ("google".equals(captionEngine())) googleFeed(mono, n, peak);
            else if (captions != null && captions.isActive()) captions.feed8kMono(mono, n);
            else if (peak > 400 && System.currentTimeMillis() - captionLastEnd > 1500 && captions != null) { Log.i(TAG, "captions: starting utterance (peak " + peak + ")"); captions.start(); }
        }
        if (packet != null) packet.feed(mono, n, open);
        if (open && current != null && !current.isDigital() && !(current.rxFreq >= 162_400_000 && current.rxFreq <= 162_550_000)) {
            toneBank.processMono(mono, n);
            int ti = toneBank.detectedIndex();
            if (ti >= 0 && ti != toneAnnounced) {
                toneAnnounced = ti;
                if (!(current.rxType == 1 && current.rxSubCode == ti)) {          // not already programmed on this channel
                    pendingTone = ti; pendingToneMs = System.currentTimeMillis();
                    history("tone", "\uD83C\uDFB5 CTCSS " + toneBank.detectedLabel() + " Hz heard \u2014 tap this box to use it");
                }
            }
        }
        if (recordOn && receiving && open) {
            try {
                if (recorder == null) { recorder = new WavRecorder(current != null ? current.name : null); recorder.start(lastCaller > 0 ? String.valueOf(lastCaller) : null); }
                recorder.write(mono, n);
            } catch (Throwable t) { log("record: " + t); recorder = null; }
        }
        final int p = peak;
        ui.post(() -> { for (Listener l : listeners) l.onAudioLevel(p); });
    }

    // ---- CTCSS heard on an analog channel: offer it as the channel's tone ----
    private final com.macdmr.radio.dsp.CtcssDecoderBank toneBank = new com.macdmr.radio.dsp.CtcssDecoderBank(8000);
    private volatile int toneAnnounced = -1, pendingTone = -1; private volatile long pendingToneMs;
    public String pendingToneLabel() { return pendingTone >= 0 && System.currentTimeMillis() - pendingToneMs < 180000 ? com.macdmr.radio.dsp.ToneConverter.ctcssLabelAt(pendingTone) : null; }
    public void dismissPendingTone() { pendingTone = -1; }
    /** Program the heard tone as RX and TX CTCSS on the current channel (VFO included). */
    public String applyPendingTone() {
        int t = pendingTone; if (t < 0 || current == null) return "Nothing to apply";
        ChannelStore.Channel ch = current;
        ch.rxType = 1; ch.rxSubCode = t; ch.txType = 1; ch.txSubCode = t;
        pendingTone = -1;
        if (ch.id < 0) applyVfo(ch, true); else { store.update(ch); selectChannel(ch.number); }
        return "CTCSS " + com.macdmr.radio.dsp.ToneConverter.ctcssLabelAt(t) + " Hz set on " + ch.name;
    }

    private void finishRecording() {
        WavRecorder r = recorder; recorder = null;
        if (r == null) return;
        try { java.io.File f = r.stop(); if (f != null) { history("rec", "\uD83C\uDFA7 Recorded " + f.getName()); } } catch (Throwable t) { log("record stop: " + t); }
    }

    // ---- modes ----------------------------------------------------------------------------------------

    public boolean softSqOn() { return softSq.isEnabled(); }
    public int softSqLevel() { return softSq.level(); }
    public boolean monitorOn() { return monitorOn; }
    public boolean recordOn() { return recordOn; }
    public boolean scanning() { return scanner.isScanning(); }
    /** Soft SQ decides what is heard on the current channel (the module then reports a reception all the time). */
    public boolean softSqActive() { return softSq.isEnabled(); }
    /** The radio's RECEIVE_START means a real reception: a DMR channel, or an analog one whose squelch is not held fully open (sq 0 reports "receiving" all the time). */
    public boolean rxReportsReception() { ChannelStore.Channel ch = current; return ch == null || ch.isDigital() || (!softSq.isEnabled() && hardwareSq(ch) > 0); }
    public boolean scanHolding() { return scanner.isHolding(); }

    private void pushModes() {
        refreshControls();
        final String zn = zoneName();
        ui.post(() -> { for (Listener l : listeners) l.onModes(softSq.isEnabled(), softSq.level(), squelchOpen, monitorOn, recordOn, scanner.isScanning(), scanner.isHolding(), zn); });
    }

    /** Soft SQ on/off for the current analog channel (persisted per channel): on = the module's squelch is held open and the app gates the audio; off = the module's own squelch level. */
    public void setSoftSq(boolean on) {
        ChannelStore.Channel ch = current; if (ch == null || ch.isDigital()) return;
        ch.softSq = on; store.update(ch);
        worker.execute(() -> refreshSquelch(ch));
    }

    public void setSoftSqLevel(int level) {
        ChannelStore.Channel ch = current; if (ch == null) return;
        ch.softSqLevel = level; store.update(ch);
        softSq.configure(ch.softSq, level, ch.rxType, ch.rxSubCode);
        pushModes();
    }

    public void setMonitor(final boolean on) {
        monitorOn = on;
        worker.execute(() -> { try { engine.setMonitor(on); } catch (IOException e) { log("monitor: " + e); } });
        pushModes();
    }

    public void setRecord(boolean on) { recordOn = on; if (!on) finishRecording(); pushModes(); }

    // ---- live captions ----------------------------------------------------------------------------

    public boolean captionsOn() { return captionsOn; }
    public boolean captionsAvailable() { return "google".equals(captionEngine()) ? !TranscriptionClient.isPlaceholderKey(googleKey()) : true; }
    public String captionEngine() { return getSharedPreferences("radio", MODE_PRIVATE).getString("captionEngine", "vosk"); }
    public void setCaptionEngine(String e) { getSharedPreferences("radio", MODE_PRIVATE).edit().putString("captionEngine", e).apply(); }
    public String googleKey() { return getSharedPreferences("radio", MODE_PRIVATE).getString("googleKey", ""); }
    public void setGoogleKey(String k) { getSharedPreferences("radio", MODE_PRIVATE).edit().putString("googleKey", k == null ? "" : k.trim()).apply(); }   // never logged

    // Google Cloud Speech: collect one utterance (16 kHz, upsampled from the 8 kHz stream), send it when the audio pauses or the reception ends
    private final java.io.ByteArrayOutputStream googleBuf = new java.io.ByteArrayOutputStream();
    private volatile long googleLastVoiceMs; private volatile boolean googleBusy;
    private void googleFeed(byte[] mono, int n, int peak) {
        synchronized (googleBuf) {
            if (peak > 400) googleLastVoiceMs = System.currentTimeMillis();
            if (googleBuf.size() == 0 && peak <= 400) return;
            int prev = googleBuf.size() == 0 ? 0 : (short) ((mono[0] & 0xFF) | (mono[1] << 8));
            for (int i = 0; i + 1 < n; i += 2) { int cur = (short) ((mono[i] & 0xFF) | (mono[i + 1] << 8)); int mid = (prev + cur) >> 1; googleBuf.write(mid); googleBuf.write(mid >> 8); googleBuf.write(cur); googleBuf.write(cur >> 8); prev = cur; }
            if (googleBuf.size() > 16000 * 2 * 55 || (System.currentTimeMillis() - googleLastVoiceMs > 1500 && googleBuf.size() > 16000 * 2)) googleFlush();
        }
    }
    private void googleFlush() {
        final byte[] pcm; synchronized (googleBuf) { if (googleBuf.size() < 16000) { googleBuf.reset(); return; } pcm = googleBuf.toByteArray(); googleBuf.reset(); }
        if (googleBusy) return; googleBusy = true;
        ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, "\u2601 transcribing\u2026", null); });
        new Thread(() -> {
            try {
                String text = TranscriptionClient.transcribe(pcm, 16000, googleKey());
                if (text != null && !text.trim().isEmpty()) {
                    String line = captionPrefix() + text.trim();
                    store.addHistory(current != null ? current.number : 0, "txt", "\uD83D\uDCDD " + line, -999, lastCaller);
                    checkKeywords(text);
                    ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, "", line); });
                } else ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, "", null); });
            } catch (Throwable t) { log("google stt: " + t.getClass().getSimpleName()); ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, "\u26A0 cloud transcription failed", null); }); }
            finally { googleBusy = false; }
        }, "google-stt").start();
    }
    public String captionModel() { return getSharedPreferences("radio", MODE_PRIVATE).getString("captionModel", VoskCaptions.DEFAULT_MODEL); }

    public void setCaptionModel(String m) {
        getSharedPreferences("radio", MODE_PRIVATE).edit().putString("captionModel", m).apply();
        if (captions == null) captions = newVoskCaptions();
        captions.setModel(m);
    }

    private VoskCaptions newVoskCaptions() {
        return new VoskCaptions(this, new VoskCaptions.Listener() {
            @Override public void status(String s) { ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, "\u23F3 " + s, null); }); }
            @Override public void partial(String text) { ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, text + " \u2026", null); }); }
            @Override public void sentence(String text) {
                String line = captionPrefix() + text;
                store.addHistory(current != null ? current.number : 0, "txt", "\uD83D\uDCDD " + line, -999, lastCaller);
                checkKeywords(text);
                ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, "\u2026", line); });
            }
            @Override public void finished(String full) {
                captionLastEnd = System.currentTimeMillis();
                ui.post(() -> { for (Listener l : listeners) l.onCaption(captionsOn, "", null); });
            }
        });
    }

    private String captionPrefix() {
        if (current != null && current.isDigital() && lastCaller > 0) { String n = callerName(lastCaller); return (n.isEmpty() ? "ID " + lastCaller : n) + ": "; }
        return "";
    }

    public void setCaptions(boolean on) {
        captionsOn = on;
        if (on) { if (captions == null) captions = newVoskCaptions(); captions.setModel(captionModel()); }
        else if (captions != null) captions.stop();
        ui.post(() -> { for (Listener l : listeners) l.onCaption(on, "", null); });
    }

    public String toggleScan() {
        if (scanner.isScanning()) { scanner.stop(); return "Scan stopped"; }
        if (vfo != null) return "Turn VFO off to scan channels";
        String err = scanner.start(); pushModes();      // the scanner tunes its first channel at once, which applies the scan-time Soft SQ
        return err == null ? "Scanning " + zoneName() : err;
    }
    public String skipScanChannel() { return scanner.skipCurrent(); }

    public long zoneId() { return zoneId; }
    public String zoneName() { if (zoneId <= 0) return "ALL"; ChannelStore.Zone z = store.zone(zoneId); return z == null ? "ALL" : z.name; }
    public void setZone(long id) { zoneId = id; getSharedPreferences("radio", MODE_PRIVATE).edit().putLong("zone", id).apply(); pushModes(); }
    /** Channels in the selected zone, in channel order (all channels when no zone is selected). */
    public java.util.List<ChannelStore.Channel> zoneChannels() {
        java.util.List<ChannelStore.Channel> all = store.all();
        if (zoneId <= 0) return all;
        ChannelStore.Zone z = store.zone(zoneId); if (z == null) return all;
        java.util.Set<Integer> in = new java.util.HashSet<>(); for (int n : z.numbers) in.add(n);
        java.util.List<ChannelStore.Channel> out = new java.util.ArrayList<>(); for (ChannelStore.Channel ch : all) if (in.contains(ch.number)) out.add(ch);
        return out;
    }

    // ---- channel ------------------------------------------------------------------------------------

    public ChannelStore store() { return store; }
    public ChannelStore.Channel current() { return current; }
    public DeviceProfile profile() { return profile; }
    public String link() { return link; }
    public boolean isReady() { return "ready".equals(link); }

    public void stepChannel(int delta) {
        if (current == null || pttDown) return;
        if (vfo != null) { vfoStep(delta); return; }
        if (scanner.isScanning()) scanner.stop();
        java.util.List<ChannelStore.Channel> list = zoneChannels(); if (list.isEmpty()) return;
        int pos = -1; for (int i = 0; i < list.size(); i++) if (list.get(i).number == current.number) pos = i;
        int next = ((pos + delta) % list.size() + list.size()) % list.size();
        selectChannel(list.get(next).number);
    }

    public void selectChannel(final int number) { worker.execute(() -> selectChannelNow(number)); }

    private synchronized void selectChannelNow(int number) {
        ChannelStore.Channel ch = store.byNumber(number);
        if (ch == null) { log("no channel " + number); return; }
        vfo = null;
        applyChannelNow(ch, true);
    }

    /** Squelch byte for the module: with Soft SQ on the radio's squelch is held open (0) and the app decides; otherwise the channel's own level. */
    private int hardwareSq(ChannelStore.Channel ch) { return softSqFor(ch) ? 0 : ch.sq; }

    /** Soft SQ applies to an analog channel when it is switched on for that channel, or on every analog channel while scanning (setting, default on). */
    private boolean softSqFor(ChannelStore.Channel ch) { return !ch.isDigital() && (ch.softSq || (scanner.isScanning() && scanSoftSq())); }
    /** The scan priority channel number (0 = none). */
    public int scanPriority() { return getSharedPreferences("radio", MODE_PRIVATE).getInt("scanPriority", 0); }
    public void setScanPriority(int number) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("scanPriority", number).apply(); }
    public boolean scanSoftSq() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("scanSoftSq", true); }
    public void setScanSoftSq(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("scanSoftSq", on).apply(); }

    /** Re-evaluate the squelch for the current channel (Soft SQ key, scan started/stopped): detector config, blackout and the module's squelch byte. */
    private synchronized void refreshSquelch(ChannelStore.Channel ch) {
        if (ch == null || ch.isDigital() || current != ch) return;
        boolean soft = softSqFor(ch);
        softSq.configure(soft, ch.softSqLevel, ch.rxType, ch.rxSubCode);
        if (soft) { softSq.onRetune(); squelchOpen = false; } else squelchOpen = true;
        rewriteAnalogSquelch(ch);
        pushModes();
    }

    /** Soft SQ was switched: re-send the analog channel so the module's squelch follows (single direct write, same path as a channel change). */
    private synchronized void rewriteAnalogSquelch(ChannelStore.Channel ch) {
        if (ch == null || ch.isDigital() || current != ch) return;
        try {
            int band = ch.rxFreq < 300_000_000 ? 1 : ch.band;
            engine.setAnalog(ch.rxFreq, ch.txFreq, band, ch.power, hardwareSq(ch), ch.rxType, ch.rxSubCode, ch.txType, ch.txSubCode, 8, 2);
        } catch (IOException e) { log("squelch rewrite: " + e); }
    }

    /** Program the radio with a channel; {@code fromStore} = a real channel (remembered as active), else the VFO. */
    private synchronized void applyChannelNow(ChannelStore.Channel ch, boolean fromStore) {
        try {
            if (ch.isDigital()) {
                int id = !fromStore && ch.mode > 0 ? ch.mode : localId();          // VFO may transmit under another DMR ID
                engine.setDigital(ch.rxFreq, ch.txFreq, id, ch.groups, ch.txContact, ch.contactType, ch.power, ch.cc, ch.inSlot, ch.outSlot, 8, 4);
                engine.setInterrupt(ch.interrupt == 1);
            } else {
                int band = ch.rxFreq < 300_000_000 ? 1 : ch.band;      // VHF must be band=1 (band=0 deafens the RX)
                engine.setAnalog(ch.rxFreq, ch.txFreq, band, ch.power, hardwareSq(ch), ch.rxType, ch.rxSubCode, ch.txType, ch.txSubCode, 8, 2);
            }
            finishRecording();
            current = ch; if (fromStore) store.setActive(ch.number);
            softSq.configure(softSqFor(ch), ch.softSqLevel, ch.rxType, ch.rxSubCode);
            softSq.onRetune();
            squelchOpen = !softSq.isEnabled();                     // with Soft SQ on, stay muted until the detector opens (no burst of static after a retune)
            ui.post(() -> { for (Listener l : listeners) l.onChannel(ch); });
            if (fromStore && voiceOn() && !scanner.isScanning()) sayChannel(channelWords(ch));   // while scanning only a stop is announced (see the scanner status)
            pushModes();
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

    private void setLocalIdQuiet(int id) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("dmrId", id).apply(); }

    public void setLocalId(int id) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("dmrId", id).apply(); if (current != null && current.isDigital()) selectChannel(current.number); }

    // ---- VFO ---------------------------------------------------------------------------------------

    private ChannelStore.Channel vfo;          // the channel the radio is on while VFO is active (id -1, number 0)
    private int vfoReturn = -1;                // channel number to return to

    public boolean vfoActive() { return vfo != null; }
    public int vfoStepHz() { return getSharedPreferences("radio", MODE_PRIVATE).getInt("vfoStep", 12500); }
    public void setVfoStepHz(int hz) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("vfoStep", hz).apply(); }

    /** A copy of the active VFO, else the last one tuned (prefs), else 146.520 FM simplex. */
    public ChannelStore.Channel vfoChannel() {
        if (vfo != null) return vfoCopy(vfo);
        ChannelStore.Channel v = new ChannelStore.Channel();
        v.type = 1; v.rxFreq = v.txFreq = 146_520_000; v.power = 1; v.band = 1; v.cc = 1; v.contactType = 1; v.txContact = 9; v.groups = new int[] { 9 };
        try {
            String js = getSharedPreferences("radio", MODE_PRIVATE).getString("vfo", null);
            if (js != null) {
                org.json.JSONObject o = new org.json.JSONObject(js);
                v.type = o.optInt("type", 1); v.rxFreq = o.optInt("rx", v.rxFreq); v.txFreq = o.optInt("tx", v.txFreq); v.power = o.optInt("power", 1); v.band = o.optInt("band", 1);
                v.rxType = o.optInt("rxType"); v.rxSubCode = o.optInt("rxCode"); v.txType = o.optInt("txType"); v.txSubCode = o.optInt("txCode");
                v.cc = o.optInt("cc", 1); v.inSlot = v.outSlot = o.optInt("slot"); v.contactType = o.optInt("callType", 1); v.txContact = o.optInt("call", 9); v.mode = o.optInt("idOverride");
                org.json.JSONArray g = o.optJSONArray("groups"); if (g != null) { v.groups = new int[g.length()]; for (int i = 0; i < g.length(); i++) v.groups[i] = g.optInt(i); }
            }
        } catch (Throwable ignored) { }
        return v;
    }

    public ChannelStore.Channel vfoCopy(ChannelStore.Channel s) {
        ChannelStore.Channel v = new ChannelStore.Channel();
        v.id = s.id; v.number = s.number; v.name = s.name; v.type = s.type; v.rxFreq = s.rxFreq; v.txFreq = s.txFreq; v.power = s.power; v.band = s.band; v.sq = s.sq;
        v.rxType = s.rxType; v.rxSubCode = s.rxSubCode; v.txType = s.txType; v.txSubCode = s.txSubCode; v.relay = s.relay; v.mode = s.mode;
        v.cc = s.cc; v.inSlot = s.inSlot; v.outSlot = s.outSlot; v.contactType = s.contactType; v.txContact = s.txContact; v.encryptSw = s.encryptSw; v.interrupt = s.interrupt;
        v.encryptKey = s.encryptKey; v.groups = s.groups.clone(); v.softSq = s.softSq; v.softSqLevel = s.softSqLevel;
        return v;
    }

    private void saveVfoPrefs(ChannelStore.Channel v) {
        try {
            org.json.JSONObject o = new org.json.JSONObject();
            o.put("type", v.type); o.put("rx", v.rxFreq); o.put("tx", v.txFreq); o.put("power", v.power); o.put("band", v.band);
            o.put("rxType", v.rxType); o.put("rxCode", v.rxSubCode); o.put("txType", v.txType); o.put("txCode", v.txSubCode);
            o.put("cc", v.cc); o.put("slot", v.inSlot); o.put("callType", v.contactType); o.put("call", v.txContact); o.put("idOverride", v.mode);
            org.json.JSONArray g = new org.json.JSONArray(); for (int x : v.groups) g.put(x); o.put("groups", g);
            getSharedPreferences("radio", MODE_PRIVATE).edit().putString("vfo", o.toString()).apply();
        } catch (Throwable ignored) { }
    }

    /** Tune the VFO (enters VFO mode if not in it); the previous real channel is remembered for {@link #exitVfo}. */
    public void applyVfo(final ChannelStore.Channel in) { applyVfo(in, true); }
    public void applyVfo(final ChannelStore.Channel in, boolean remember) {
        final ChannelStore.Channel v = vfoCopy(in);
        v.id = -1; v.number = 0;
        if (v.name == null || v.name.isEmpty()) v.name = "VFO " + String.format(Locale.US, "%.4f", v.rxFreq / 1e6) + (v.isDigital() ? " DMR" : " FM");
        if (remember) saveVfoPrefs(v);
        worker.execute(() -> {
            if (pttDown) return;
            if (scanner.isScanning()) scanner.stop();
            if (vfo == null && current != null) vfoReturn = current.number;
            vfo = v;
            applyChannelNow(v, false);
            log("VFO " + v.freqText(v.rxFreq) + "/" + v.freqText(v.txFreq) + (v.isDigital() ? " DMR cc" + v.cc + " TG " + v.txContact : " FM"));
        });
    }

    public void exitVfo() {
        if (packet != null && packet.monitoring()) packet.setMonitoring(false);
        if (packet != null && packet.sstvRx() && vfo != null && vfo.rxFreq == PacketEngine.SSTV_FREQ_HZ) packet.setSstvRx(false);
        worker.execute(() -> {
            if (vfo == null) return;
            vfo = null;
            int back = vfoReturn > 0 && store.byNumber(vfoReturn) != null ? vfoReturn : store.activeNumber();
            selectChannelNow(back);
        });
    }

    /** Intercom arrows while VFO is on: step both frequencies (keeps any repeater offset). */
    private void vfoStep(int delta) {
        ChannelStore.Channel v = vfoCopy(vfo);
        int hz = delta * vfoStepHz();
        v.rxFreq += hz; v.txFreq += hz;
        if (v.rxFreq < 136_000_000 || v.rxFreq > 480_000_000 || v.txFreq < 136_000_000 || v.txFreq > 480_000_000) return;
        if (v.rxFreq > 174_000_000 && v.rxFreq < 400_000_000) { v.rxFreq = delta > 0 ? 400_000_000 : 174_000_000; v.txFreq = v.rxFreq; }
        v.name = "";
        applyVfo(v);
    }

    /** Stock "areas" (one channel database each): keys like default_uhf, usa, eu … */
    public java.util.List<String> stockAreas() {
        java.util.List<String> out = new java.util.ArrayList<>();
        for (String l : RootSetup.run("ls /data/data/" + profile.stockApp + "/databases/ 2>/dev/null").split("\\s+")) { java.util.regex.Matcher m = java.util.regex.Pattern.compile("database_channel_area_(\\w+)\\.db").matcher(l); if (m.matches()) out.add(m.group(1)); }
        if (out.isEmpty()) out.add("default_uhf");
        return out;
    }
    public String reimportFromStock() { return reimportFromStock("default_uhf"); }
    public String reimportFromStock(String areaKey) {
        StringBuilder err = new StringBuilder();
        int n = store.importFromStock(this, profile.stockApp, areaKey, err);
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
                    pttDown = true; refreshControls();
                    if (audio != null) audio.stopRx();              // never play the RX stream while the mic is live (feedback)
                    boolean carMic = inCar && carMic() && startBluetoothMic();   // in the car: its microphone, through the hands-free link
                    if (audio != null) audio.setTxSource(carMic ? android.media.MediaRecorder.AudioSource.VOICE_COMMUNICATION : android.media.MediaRecorder.AudioSource.MIC);
                    if (carMic) log("TX with the car microphone");
                    engine.ptt(true);
                    if (audio != null) log(audio.startTx());
                    ui.removeCallbacks(txWatchdog); ui.postDelayed(txWatchdog, 28000);
                } else {
                    if (!pttDown) return;
                    pttDown = false; refreshControls();
                    ui.removeCallbacks(txWatchdog);
                    try {
                        if (audio != null) audio.stopTx();
                        stopBluetoothMic();
                        short[] roger = rogerPcm(rogerStyle());
                        if (roger != null && audio != null) audio.playPcm(roger);    // still keyed: the tone goes out before the carrier drops
                    } finally { engine.ptt(false); }
                    if (rxAudioOn && audio != null) audio.startRx(true);
                }
            } catch (Throwable t) { log("ptt: " + t); try { engine.ptt(false); } catch (Throwable ignored) { } pttDown = false; }
        });
    }

    // ---- Device tools ----
    public void diagVersion() { worker.execute(() -> { try { engine.queryVersion(); } catch (IOException e) { log("version: " + e); } }); }
    public void diagPowerCycle() { worker.execute(() -> { try { if (audio != null) audio.stopRx(); log("power-cycling the module"); engine.powerCycle(); if (!engine.waitBooted(12000)) log("no banner after power-cycle"); engine.queryVersion(); if (current != null) applyChannelNow(current, current.id > 0); if (rxAudioOn && audio != null) audio.startRx(true); } catch (Throwable t) { log("power-cycle: " + t); } }); }
    public void diagTestTone(int ms) { short[] pcm = new short[8000 * ms / 1000]; for (int i = 0; i < pcm.length; i++) pcm[i] = (short) (12000 * Math.sin(2 * Math.PI * 1000 * i / 8000.0)); transmitPcm(pcm, "1 kHz test tone " + ms + " ms", null); }

    /** Ask the module for the signal strength (on the radio worker: never a serial write on the main thread). */
    public void pollRssi() { worker.execute(() -> { try { if (engine.isOpen()) engine.queryRssi(); } catch (IOException ignored) { } }); }

    // ---- listeners ----------------------------------------------------------------------------------

    public void addListener(Listener l) { listeners.add(l); l.onLink(link); if (current != null) l.onChannel(current); l.onModes(softSq.isEnabled(), softSq.level(), squelchOpen, monitorOn, recordOn, scanner.isScanning(), scanner.isHolding(), zoneName()); l.onCaption(captionsOn, "", null); l.onRx(receiving); l.onTx(transmitting); if (rssi != -999) l.onRssi(rssi); }   // a page built later (intercom look switched) starts from the live receive/transmit state, not "idle"
    public void removeListener(Listener l) { listeners.remove(l); }

    private void setLink(String s) { link = s; ui.post(() -> { for (Listener l : listeners) l.onLink(s); }); updateNotification(); }

    private volatile long softOpenAt;
    private long lastSqDiag;
    /** Soft SQ gate transitions: the module reports a continuous reception while its squelch is held open, so the "Received N s" line comes from the gate instead. */
    private void softGateHistory(boolean open) {
        long now = System.currentTimeMillis();
        if (open) { softOpenAt = now; return; }
        long len = softOpenAt > 0 ? now - softOpenAt : 0; softOpenAt = 0;
        if (current != null && !current.isDigital() && len >= 700) history("rx", "📻 Received " + Math.round(len / 1000.0) + " s");
    }

    private void history(String kind, String text) {
        text = text.replaceAll("[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F\\x7F]", "\u00B7");   // no control characters on screen (they also break screen readers)
        int chNum = current != null ? current.number : 0;
        store.addHistory(chNum, kind, text, rssi, lastCaller);
        String line = new java.text.SimpleDateFormat("HH:mm:ss", Locale.US).format(new java.util.Date()) + " " + text + (rssi != -999 ? " " + rssi + " dBm" : "");
        ui.post(() -> { for (Listener l : listeners) l.onHistory(line); });
    }

    // ---- RadioEngine.Events -------------------------------------------------------------------------

    /** Last 300 log lines for the Diagnostics page. Lines reach the pages only while that page is open: posting every
     *  serial frame (ten a second while receiving) to the main thread slowed the intercom down over a session. */
    private final java.util.ArrayDeque<String> logRing = new java.util.ArrayDeque<>();
    private volatile boolean uiLog;
    private final java.text.SimpleDateFormat logTf = new java.text.SimpleDateFormat("HH:mm:ss.SSS", Locale.US);
    public void setUiLog(boolean on) { uiLog = on; }
    public java.util.List<String> recentLog() { synchronized (logRing) { return new java.util.ArrayList<>(logRing); } }

    @Override public void log(String s) {
        Log.i(TAG, s);
        synchronized (logRing) { logRing.addLast(logTf.format(new java.util.Date()) + " " + s); while (logRing.size() > 300) logRing.removeFirst(); }
        if (uiLog) ui.post(() -> { for (Listener l : listeners) l.onLog(s); });
    }

    @Override public void status(int code, String name) {
        switch (code) {
            case 1: receiving = true;
                if (current != null && current.isDigital()) {           // a DMR call: forget the last talker, ask who this is now and again a second later
                    lastCaller = 0; callLogged = false;
                    for (long ms : new long[] { 300, 1200 }) ui.postDelayed(() -> { if (receiving) worker.execute(() -> { try { engine.queryCallerInfo(); } catch (IOException ignored) { } }); }, ms);
                }
                refreshControls(); rxStart = System.currentTimeMillis(); rxCounts = rxReportsReception(); softSq.rxStarted(); ui.post(() -> { for (Listener l : listeners) l.onRx(true); }); pollRssi(); break;
            case 2: {
                receiving = false; refreshControls(); long len = rxStart > 0 ? System.currentTimeMillis() - rxStart : 0; rxStart = 0;
                if (softSq.isEnabled() && squelchOpen) { softSq.closeNow(); softGateHistory(false); squelchOpen = false; log("soft squelch closed (carrier gone)"); }
                softSq.awaitRxStart();                                   // with the module squelch held open a RECEIVE_STOP only happens while the receiver re-settles
                if (current != null && current.isDigital()) { try { engine.queryCallerInfo(); } catch (IOException ignored) { } }   // who was that (0x2B)
                if (current != null && !current.isDigital() && !softSq.isEnabled() && rxCounts && len >= 700) history("rx", "📻 Received " + Math.round(len / 1000.0) + " s");   // with Soft SQ on the soft gate writes this line
                finishRecording();
                toneBank.reset(); toneAnnounced = -1;
                if (captions != null) captions.stop();
                if (captionsOn && "google".equals(captionEngine())) googleFlush();
                ui.post(() -> { for (Listener l : listeners) l.onRx(false); });
                break;
            }
            case 3: transmitting = true; refreshControls(); if (coverage != null) coverage.onTxStart(); ui.post(() -> { for (Listener l : listeners) l.onTx(true); }); break;
            case 4: transmitting = false; refreshControls(); if (coverage != null) coverage.onTxEnd(); history("tx", "📻 Voice TX"); ui.post(() -> { for (Listener l : listeners) l.onTx(false); }); break;
            case 5: try { engine.fetchSms(); } catch (IOException ignored) { } break;             // SMS_RECEIVED -> ask for it
            case 8: smsResult(true); break;
            case 9: smsResult(false); break;
            case 7: history("busy", "⚠ Channel busy"); break;
            default: log("status " + name);
        }
    }

    @Override public void rssi(int raw, double dbm) { rssi = (int) Math.round(dbm); if (coverage != null) coverage.onRssi(rssi); if (hearing()) refreshControls(); /* the car screen's signal meter */ ui.post(() -> { for (Listener l : listeners) l.onRssi(rssi); }); }
    @Override public void version(int v, String text) { log("module " + text); }
    /** One history line, voice announcement and caller report per call (the caller is asked at the start, a second in, and at the end). */
    private volatile boolean callLogged; private volatile int loggedCaller, loggedTarget;
    @Override public void callerInfo(int type, int caller, int target) {
        if (caller <= 0) return;
        lastCaller = caller; lastCallType = type; lastTarget = target;
        refreshControls();   // the car screens show who is talking
        if (callLogged && caller == loggedCaller && target == loggedTarget) return;
        callLogged = true; loggedCaller = caller; loggedTarget = target;
        String t = (type == 1 ? "TG " + target : type == 2 ? "All call" : "Private") ;
        String who = callerName(caller);
        history("dmr", "📻 Voice RX " + t + " from " + (who.isEmpty() ? String.valueOf(caller) : who + " (" + caller + ")"));
        ui.post(() -> { for (Listener l : listeners) l.onCaller((who.isEmpty() ? "ID " + caller : who + "  " + caller) + "  " + t); });
        if (voiceOn() && !who.isEmpty()) say(who.split(" ")[0]);
    }
    @Override public void ack(int cmd, boolean ok) { if (!ok) log(String.format(Locale.US, "MCU rejected 0x%02X", cmd)); }
    @Override public void booted(String banner) { log("module booted: " + banner); }

    private volatile long pendingSmsId = -1;

    @Override public void sms(int type, int fromId, String text) {
        int t = type == 3 ? 1 : type == 2 ? 2 : 0;                         // store with our contact-type codes
        store.addMessage(fromId, t, false, text, 1);
        String nm = t == 1 ? store.contactName(fromId, 1) : callerName(fromId);
        CarMessages.dmr(this, fromId, t, nm, text);   // the phone and Android Auto (read aloud, voice reply)
        history("sms", "✉ Text from " + fromId + ": " + (text.length() > 40 ? text.substring(0, 40) + "…" : text));
        ui.post(() -> { for (Listener l : listeners) l.onSms(fromId, t, text); });
    }

    /** Status 8 = the other radio acknowledged; 9 = no acknowledgement came back (the text usually still arrived — a BTECH 6X2 shows it and never acks, 2026-10-17). */
    private void smsResult(boolean ok) {
        long id = pendingSmsId; pendingSmsId = -1;
        if (id >= 0) store.setMessageStatus(id, ok ? 1 : 3);
        if (!ok) log("text message sent, no acknowledgement");
        ui.post(() -> { for (Listener l : listeners) l.onSmsResult(ok); });
    }

    /** Send a DMR text to a contact (private / group / all) over the current digital channel. */
    public void sendSms(final ChannelStore.Contact to, final String text) {
        final long id = store.addMessage(to.number, to.type, true, text, 0);
        worker.execute(() -> {
            try {
                int msgType = to.type == 1 ? 3 : to.type == 2 ? 2 : 1;
                pendingSmsId = id;
                engine.sendSms(msgType, to.number, 0, text);     // group texts: id = the talkgroup, second int 0 exactly as the stock app sends them
            } catch (Throwable t) { store.setMessageStatus(id, 2); log("sms: " + t); ui.post(() -> { for (Listener l : listeners) l.onSmsResult(false); }); }
        });
    }

    // ---- notification -------------------------------------------------------------------------------

    private Notification notification(String text) {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= 26 && nm != null) nm.createNotificationChannel(new NotificationChannel("radio", "Radio", NotificationManager.IMPORTANCE_LOW));
        Notification.Builder b = Build.VERSION.SDK_INT >= 26 ? new Notification.Builder(this, "radio") : new Notification.Builder(this);
        ChannelStore.Channel ch = current;
        b.setContentTitle(ch != null ? "Ch " + ch.number + " · " + ch.name : "DMR Radio").setContentText(text)
                .setSmallIcon(R.drawable.ic_stat_radio).setColor(0xFF19D3FF).setOngoing(true).setOnlyAlertOnce(true).setShowWhen(false)
                .setContentIntent(RadioWidget.openApp(this));
        if (isReady()) {
            boolean scanning = scanner != null && scanner.isScanning();
            b.addAction(new Notification.Action.Builder(android.graphics.drawable.Icon.createWithResource(this, R.drawable.ic_w_left), "Ch −", RadioWidget.command(this, RadioWidget.CMD_PREV, 1)).build());
            b.addAction(new Notification.Action.Builder(android.graphics.drawable.Icon.createWithResource(this, scanning ? R.drawable.ic_w_stop : R.drawable.ic_w_scan), scanning ? "Stop scan" : "Scan", RadioWidget.command(this, RadioWidget.CMD_SCAN, 3)).build());
            b.addAction(new Notification.Action.Builder(android.graphics.drawable.Icon.createWithResource(this, R.drawable.ic_w_right), "Ch +", RadioWidget.command(this, RadioWidget.CMD_NEXT, 2)).build());
            Notification.MediaStyle ms = new Notification.MediaStyle().setShowActionsInCompactView(0, 1, 2);
            try { ms.setMediaSession((android.media.session.MediaSession.Token) com.macdmr.radio.media.RadioMedia.get(this).session().getSessionToken().getToken()); } catch (Throwable ignored) { }
            b.setStyle(ms);
        }
        return b.build();
    }

    private void updateNotification() { refreshControls(); }

    private final Runnable controlsRefresh = () -> {
        try {
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            String t = isReady() ? RadioWidget.status(this) : "Radio " + link;
            if (nm != null) nm.notify(1, notification(t));
        } catch (Throwable ignored) { }
        RadioWidget.refresh(this, this);
        updateAudioFocus();
        try {
            // in the car "playing" means the radio is the car's media source (media focus, the car's media channel); the
            // ducking focus it holds otherwise is played on the car's voice-prompt channel, so show Play there instead
            com.macdmr.radio.media.RadioMedia.get(this).update(this, inCar() ? inMediaMode() && !isMuted() : !isMuted(), carStatus(), zoneName(), isScanning());
        } catch (Throwable t) { log("media session: " + t); }
    };

    // ---- audio focus --------------------------------------------------------------------------------
    // While something is heard the app holds transient, may-duck audio focus: music and podcasts dip under the
    // radio, and Android Auto (which only sends the focus holder's media to the car) plays it through the car.
    // Released 2.5 s after reception ends, so the music does not bounce back between phrases.
    private android.media.AudioFocusRequest focusRequest; private boolean focusHeld;
    /**
     * Projecting to a car (Android Auto). Measured with the head unit emulator: any transient focus (may duck or not)
     * is streamed on the car's voice-prompt channel (16 kHz, above the radio's 8 kHz; the car dips its media under it),
     * only permanent focus on the media channel; so the request is the same in the car, and this is for the car UI.
     */
    private volatile boolean inCar;
    public boolean inCar() { return inCar; }

    // ---- in the car: coverage logging for the drive, steering-wheel Talk -----------------------------
    public boolean coverageInCar() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("covInCar", true); }
    public void setCoverageInCar(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("covInCar", on).apply(); if (inCar) carCoverage(true); }
    public boolean wheelTalk() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("wheelTalk", false); }
    public void setWheelTalk(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("wheelTalk", on).apply(); }
    private boolean coverageForDrive;   // switched on by the car connecting (not by you): switched off again when it disconnects
    private void carCoverage(boolean car) {
        try {
            com.macdmr.radio.coverage.CoverageLogger cl = coverage();
            if (car && coverageInCar() && !cl.running()) { cl.start(); coverageForDrive = true; startForegroundTyped(true); log("coverage logging on for the drive"); history("cov", "\uD83D\uDCF6 Coverage logging on while Android Auto is connected"); }
            else if (!car && coverageForDrive) { coverageForDrive = false; if (!cl.enabled()) { cl.stop(); startForegroundTyped(false); log("coverage logging off (car disconnected)"); } }
            refreshControls();
        } catch (Throwable t) { log("car coverage: " + t); }
    }
    /** Steering-wheel play/pause (a media button) while in the car with the setting on: start or stop talking. */
    public boolean wheelButton() {
        if (!inCar || !wheelTalk()) return false;
        if (pttHeld()) ptt(false); else ptt(true);
        return true;
    }
    // ---- car presence: media app (default) or the full-screen Radio controls template app ---------------
    public boolean carControlsScreen() {
        try {
            int st = getPackageManager().getComponentEnabledSetting(new android.content.ComponentName(this, com.macdmr.radio.car.RadioCarAppService.class));
            return st == android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_ENABLED;
        } catch (Throwable t) { return false; }
    }
    public void setCarControlsScreen(boolean on) {
        getPackageManager().setComponentEnabledSetting(new android.content.ComponentName(this, com.macdmr.radio.car.RadioCarAppService.class),
                on ? android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_ENABLED : android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_DEFAULT,
                android.content.pm.PackageManager.DONT_KILL_APP);
        log("car screen: " + (on ? "Radio controls" : "media app"));
    }
    /** Car milestones go into the radio history (kept across reboots), so a drive can be looked at afterwards. */
    private String lastCarEvent; private long lastCarEventAt;
    public void carEvent(String line) {
        long now = System.currentTimeMillis();
        if (line.equals(lastCarEvent) && now - lastCarEventAt < 60_000) return;   // once a minute at most per kind
        lastCarEvent = line; lastCarEventAt = now;
        log(line); history("car", line);
    }

    private void watchCar() {
        try {
            new androidx.car.app.connection.CarConnection(this).getType().observeForever(t -> {
                boolean car = t != null && t == androidx.car.app.connection.CarConnection.CONNECTION_TYPE_PROJECTION;
                if (car == inCar) return;
                inCar = car; log(car ? "Android Auto connected" : "Android Auto disconnected");
                carEvent(car ? "🚗 Android Auto connected (" + (carControlsScreen() ? "Radio controls screen" : "media app") + ")" : "🚗 Android Auto disconnected");
                carCoverage(car);
                if (car) new Thread(() -> {   // a sideloaded app stays off the car's app list unless Unknown sources is on
                    com.macdmr.radio.car.AutoTrust.State st = com.macdmr.radio.car.AutoTrust.check(this);
                    if (st == com.macdmr.radio.car.AutoTrust.State.OFF || st == com.macdmr.radio.car.AutoTrust.State.LOCKED) {
                        ui.post(() -> carEvent("⚠️ Android Auto is hiding DMR Radio: Unknown sources is off (Device page shows how to fix it)"));
                        com.macdmr.radio.car.AutoTrust.notifyHidden(this, st);
                    } else if (st == com.macdmr.radio.car.AutoTrust.State.OK) com.macdmr.radio.car.AutoTrust.clearNotice(this);
                }, "autotrust").start();
            });
        } catch (Throwable t) { log("car connection: " + t); }
    }
    private final Runnable focusRelease = () -> {
        if (!focusHeld) return;
        try { ((android.media.AudioManager) getSystemService(AUDIO_SERVICE)).abandonAudioFocusRequest(focusRequest); } catch (Throwable ignored) { }
        focusHeld = false; log("audio focus released");
    };
    /**
     * Focus taken away. For good (Android Auto connecting grabs it, another player starts): ask again in a second
     * while the radio is still heard. For a while (a phone call): Android gives it back by itself.
     */
    private void onFocusChange(int change) {
        log("audio focus change " + change);
        // 3 s: Android Auto takes the focus when it starts projecting; ask again once it has settled
        if (change == android.media.AudioManager.AUDIOFOCUS_LOSS) { focusHeld = false; ui.removeCallbacks(refocus); ui.postDelayed(refocus, 3000); }
    }
    private final Runnable refocus = this::updateAudioFocus;

    // ---- media (Android Auto, lock screen, headset buttons) --------------------------------------------
    /** Paused from the media controls: nothing is played, but reception, decoding and logging carry on. */
    private volatile boolean muted;
    /** Played from the media controls (Android Auto's media screen, play button): the radio is the media source and
     *  holds permanent focus, which the car plays on its media channel. Ends with pause or when another player takes over. */
    private volatile boolean mediaMode;
    public boolean isMuted() { return muted; }
    public boolean inMediaMode() { return mediaMode; }
    public void mediaPlay(boolean play) {
        ui.post(() -> {
            boolean wasMuted = muted;
            muted = !play; mediaMode = play;
            if (wasMuted != muted) history("media", muted ? "\uD83D\uDD07 Radio sound paused (media controls); still receiving" : "\uD83D\uDD0A Radio sound playing");
            if (focusHeld) { ui.removeCallbacks(focusRelease); focusRelease.run(); }   // re-take the right kind of focus
            updateAudioFocus(); refreshControls();
        });
    }
    private android.media.AudioFocusRequest mediaFocusRequest; private boolean mediaFocusHeld;
    private void updateMediaFocus() {
        android.media.AudioManager am = (android.media.AudioManager) getSystemService(AUDIO_SERVICE);
        if (mediaMode && !muted) {
            if (mediaFocusHeld) return;
            if (mediaFocusRequest == null) mediaFocusRequest = new android.media.AudioFocusRequest.Builder(android.media.AudioManager.AUDIOFOCUS_GAIN)
                    .setAudioAttributes(new android.media.AudioAttributes.Builder().setUsage(android.media.AudioAttributes.USAGE_MEDIA).setContentType(android.media.AudioAttributes.CONTENT_TYPE_SPEECH).build())
                    .setOnAudioFocusChangeListener(ch -> {
                        log("media focus change " + ch);
                        if (ch == android.media.AudioManager.AUDIOFOCUS_LOSS) {   // another player took over: pause, as media apps do
                            mediaFocusHeld = false; mediaPlay(false);
                            if (inCar) carEvent("🚗 Android Auto took the sound away (another source played)");
                        }
                    }, ui).build();
            mediaFocusHeld = am.requestAudioFocus(mediaFocusRequest) == android.media.AudioManager.AUDIOFOCUS_REQUEST_GRANTED;
            log("media focus " + (mediaFocusHeld ? "held" : "refused"));
        } else if (mediaFocusHeld) {
            try { am.abandonAudioFocusRequest(mediaFocusRequest); } catch (Throwable ignored) { }
            mediaFocusHeld = false; log("media focus released");
        }
    }

    private void updateAudioFocus() {
        updateMediaFocus();
        boolean want = rxAudioOn && !pttDown && !muted && !mediaMode && hearing();
        if (want) {
            ui.removeCallbacks(focusRelease);
            if (focusHeld) return;
            try {
                android.media.AudioManager am = (android.media.AudioManager) getSystemService(AUDIO_SERVICE);
                if (focusRequest == null) focusRequest = new android.media.AudioFocusRequest.Builder(android.media.AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
                        .setAudioAttributes(new android.media.AudioAttributes.Builder().setUsage(android.media.AudioAttributes.USAGE_MEDIA).setContentType(android.media.AudioAttributes.CONTENT_TYPE_SPEECH).build())
                        .setWillPauseWhenDucked(false).setOnAudioFocusChangeListener(this::onFocusChange, ui).build();
                int r = am.requestAudioFocus(focusRequest);
                focusHeld = r == android.media.AudioManager.AUDIOFOCUS_REQUEST_GRANTED;
                log("audio focus " + (focusHeld ? "held" + (inCar ? " (in the car)" : "") : "refused (" + r + ")"));
            } catch (Throwable t) { log("audio focus: " + t); }
        } else if (focusHeld) { ui.removeCallbacks(focusRelease); ui.postDelayed(focusRelease, 2500); }
    }
    /** Notification + widget, coalesced: state can flip several times in a few ms (gate, RX start, TX). */
    private void refreshControls() { ui.removeCallbacks(controlsRefresh); ui.postDelayed(controlsRefresh, 150); }

    public boolean isTransmitting() { return transmitting || pttDown; }
    public int lastRssi() { return rssi; }
    /** Who is talking on a DMR channel right now (name from the contacts or RadioID, or the ID), else "". */
    public String currentCaller() {
        if (!dmrCallNow()) return "";
        String n = callerName(lastCaller); return n.isEmpty() ? "ID " + lastCaller : n;
    }
    private boolean dmrCallNow() { return current != null && current.isDigital() && hearing() && lastCaller > 0; }
    /** The talker's DMR ID during a call, else 0. */
    public int currentCallerId() { return dmrCallNow() ? lastCaller : 0; }
    /** The talker's callsign when the name starts with one ("VE3UOD Richard ..." gives "VE3UOD"), else the name or "ID n". */
    public String currentCallsign() {
        String c = currentCaller(); if (c.isEmpty()) return "";
        String first = c.split("\\s+")[0];
        return first.matches("[A-Z0-9]{1,3}[0-9][A-Z0-9]{1,4}") ? first : c;
    }
    /** What the call goes to: "TG 11904 Ontario" (the talkgroup's contact name when known), "Private call", "All call", or "". */
    public String currentTarget() {
        if (!dmrCallNow()) return "";
        if (lastCallType == 1) { String n = store.contactName(lastTarget, 1); return "TG " + lastTarget + (n == null || n.isEmpty() || n.equals(String.valueOf(lastTarget)) ? "" : " " + n); }
        if (lastCallType == 2) return "All call";
        return "Private call";
    }
    /**
     * The zone to show with a channel: the selected zone when it holds the channel; otherwise the first other zone
     * that does (Favourites last); "" when none does.
     */
    public String zoneLabelFor(ChannelStore.Channel ch) {
        if (ch == null) return "";
        ChannelStore.Zone sel = zoneId > 0 ? store.zone(zoneId) : null;
        if (zoneId <= 0) return "ALL";
        if (sel != null) for (int n : sel.numbers) if (n == ch.number) return sel.name;
        String fav = null;
        for (ChannelStore.Zone z : store.zones()) for (int n : z.numbers) if (n == ch.number) { if (com.macdmr.radio.ui.ChannelsView.FAV_ZONE.equals(z.name)) fav = z.name; else return z.name; }
        return fav != null ? fav : "";
    }
    /** The car's subtitle: during a DMR call who is talking and to what; otherwise frequency and state. */
    public String carStatus() {
        String who = currentCaller();
        if (!who.isEmpty()) { int id = currentCallerId(); String t = currentTarget(); return who + (who.startsWith("ID ") ? "" : " \u00b7 " + id) + (t.isEmpty() ? "" : " \u00b7 " + t); }
        return isReady() ? RadioWidget.status(this).replace("Mapping coverage \u00b7 ", "") : "Radio " + link;
    }

    // ---- coverage mapping ---------------------------------------------------------------------------
    private com.macdmr.radio.coverage.CoverageLogger coverage;
    public com.macdmr.radio.coverage.CoverageLogger coverage() {
        if (coverage == null) coverage = new com.macdmr.radio.coverage.CoverageLogger(this, new com.macdmr.radio.coverage.CoverageLogger.Host() {
            @Override public ChannelStore.Channel current() { return current; }
            @Override public boolean ready() { return isReady(); }
            @Override public boolean hearing() { return RadioService.this.hearing(); }
            @Override public boolean busyTx() { return pttDown || transmitting; }
            @Override public boolean toneMatches(ChannelStore.Channel ch) {
                if (ch.isDigital() || ch.rxType != 1) return true;            // DMR: the colour code already matched; no tone or DCS: the carrier is all we have
                double want = com.macdmr.radio.dsp.ToneTable.ctcssHz(ch.rxSubCode), got = toneBank.detectedHz();
                return want > 0 && got > 0 && Math.abs(want - got) < 1.5;
            }
            @Override public void pollRssi() { RadioService.this.pollRssi(); }
            @Override public void event(String line) { history("cov", line); }
        });
        return coverage;
    }
    /** Coverage logging on/off; on also asks for location in the foreground service so it keeps working with the screen off. */
    public void setCoverageLogging(boolean on) { coverage().setEnabled(on); startForegroundTyped(on); refreshControls(); }
    // ---- car microphone (Bluetooth hands-free) -------------------------------------------------------
    public boolean carMic() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("carMic", true); }
    public void setCarMic(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("carMic", on).apply(); }
    private volatile boolean btMicOn;
    /**
     * Route the microphone to a connected Bluetooth hands-free device (the car) and wait for the link (up to 2 s),
     * so the first words are not lost. False when there is none; the phone microphone is used then.
     */
    private boolean startBluetoothMic() {
        try {
            android.media.AudioManager am = (android.media.AudioManager) getSystemService(AUDIO_SERVICE);
            am.setMode(android.media.AudioManager.MODE_IN_COMMUNICATION);
            boolean asked = false;
            if (Build.VERSION.SDK_INT >= 31) {
                for (android.media.AudioDeviceInfo d : am.getAvailableCommunicationDevices())
                    if (d.getType() == android.media.AudioDeviceInfo.TYPE_BLUETOOTH_SCO) { asked = am.setCommunicationDevice(d); break; }
            } else if (am.isBluetoothScoAvailableOffCall()) { am.startBluetoothSco(); am.setBluetoothScoOn(true); asked = true; }
            if (!asked) { am.setMode(android.media.AudioManager.MODE_NORMAL); return false; }
            btMicOn = true;
            for (int i = 0; i < 40; i++) {
                boolean up = Build.VERSION.SDK_INT >= 31
                        ? am.getCommunicationDevice() != null && am.getCommunicationDevice().getType() == android.media.AudioDeviceInfo.TYPE_BLUETOOTH_SCO
                        : am.isBluetoothScoOn();
                if (up) { Thread.sleep(150); return true; }       // the audio path needs a moment after the link reports up
                Thread.sleep(50);
            }
            log("car microphone: the hands-free link did not come up; using the phone microphone");
            stopBluetoothMic();
            return false;
        } catch (Throwable t) { log("car microphone: " + t); stopBluetoothMic(); return false; }
    }
    private void stopBluetoothMic() {
        if (!btMicOn) return;
        btMicOn = false;
        try {
            android.media.AudioManager am = (android.media.AudioManager) getSystemService(AUDIO_SERVICE);
            if (Build.VERSION.SDK_INT >= 31) am.clearCommunicationDevice(); else { am.setBluetoothScoOn(false); am.stopBluetoothSco(); }
            am.setMode(android.media.AudioManager.MODE_NORMAL);
        } catch (Throwable ignored) { }
    }

    public boolean coverageLogging() { return coverage != null && coverage.running(); }

    /**
     * Key-up test on an FM repeater channel: transmit your callsign in Morse (20 wpm, 800 Hz, about 3 s; a
     * legal identification) and let the coverage logger judge whether the repeater answered. Returns null when
     * sent, or why not.
     */
    public String keyupTest() {
        ChannelStore.Channel ch = current;
        if (!isReady() || ch == null) return "The radio is not on";
        if (!coverageLogging()) return "Turn on coverage logging first: the result is stored with your position";
        if (ch.isDigital()) return "On DMR use the Parrot instead: a private call to 9990 on BrandMeister plays your call back";
        if (ch.txFreq == ch.rxFreq || (ch.lat == 0 && ch.lon == 0)) return "Choose an FM repeater channel that has a location";
        if (txInhibited()) return "This channel is receive-only";
        if (packet == null || !packet.callsignSet()) return "Set your callsign first (PKT \u2192 APRS settings): the test sends it as your identification";
        if (pttDown) return "Already transmitting";
        String id = packet.callsign();
        transmitPcm(com.macdmr.radio.coverage.Morse.pcm(id, 20, 800), "key-up test (Morse ID)", null);
        return null;
    }

    /** The foreground service: microphone always, plus location while coverage logging is on (allowed only while the app is in front). */
    private void startForegroundTyped(boolean location) {
        Notification n = notification(isReady() ? RadioWidget.status(this) : "Radio idle");
        if (Build.VERSION.SDK_INT >= 30) {
            int t = android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE;
            if (location) {
                try { startForeground(1, n, t | android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION); return; }
                catch (Throwable e) { log("coverage: location in the background not allowed now (" + e.getClass().getSimpleName() + "); logging while the app is open"); }
            }
            try { startForeground(1, n, t); return; } catch (Throwable ignored) { }
        }
        startForeground(1, n);
    }

    // ---- roger beep ---------------------------------------------------------------------------------
    public static final String[] ROGER_NAMES = { "Off", "Beep", "Two-tone", "Morse K" };
    public int rogerStyle() { int s = getSharedPreferences("radio", MODE_PRIVATE).getInt("roger", 0); return s >= 0 && s < ROGER_NAMES.length ? s : 0; }
    public void setRogerStyle(int s) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("roger", s).apply(); }
    /** The end-of-transmission tone at 8 kHz (null = off): 40 ms lead, soft 6 ms edges, about a third of full scale. */
    public static short[] rogerPcm(int style) {
        int[][] seg;   // {hz (0 = silence), ms}
        switch (style) {
            case 1: seg = new int[][] { { 0, 40 }, { 1000, 180 } }; break;
            case 2: seg = new int[][] { { 0, 40 }, { 1200, 110 }, { 0, 30 }, { 1800, 130 } }; break;
            case 3: seg = new int[][] { { 0, 40 }, { 800, 180 }, { 0, 60 }, { 800, 60 }, { 0, 60 }, { 800, 180 } }; break;
            default: return null;
        }
        int n = 0; for (int[] s : seg) n += s[1] * 8;
        short[] out = new short[n]; int pos = 0;
        for (int[] s : seg) {
            int len = s[1] * 8, edge = 48;
            for (int i = 0; i < len; i++) {
                double env = Math.min(1.0, Math.min(i, len - 1 - i) / (double) edge);
                out[pos + i] = s[0] == 0 ? 0 : (short) (11000 * env * Math.sin(2 * Math.PI * s[0] * i / 8000.0));
            }
            pos += len;
        }
        return out;
    }
    /** Play a roger tone on the phone speaker (Device page preview). */
    public static void previewRoger(int style) {
        final short[] pcm = rogerPcm(style); if (pcm == null) return;
        new Thread(() -> {
            try {
                android.media.AudioTrack t = new android.media.AudioTrack(android.media.AudioManager.STREAM_MUSIC, 8000, android.media.AudioFormat.CHANNEL_OUT_MONO,
                        android.media.AudioFormat.ENCODING_PCM_16BIT, Math.max(pcm.length * 2, 4096), android.media.AudioTrack.MODE_STATIC);
                t.write(pcm, 0, pcm.length); t.play(); Thread.sleep(pcm.length / 8 + 150); t.release();
            } catch (Throwable ignored) { }
        }, "roger-preview").start();
    }

    // ---- emergency ----------------------------------------------------------------------------------
    /** Send an emergency on the current channel: DMR text with coordinates, or an APRS emergency position. Returns what happened. */
    public String emergency(String text, int toNumber, int toType, String toName) {
        ChannelStore.Channel ch = current;
        if (!isReady() || ch == null) return "Not sent: the radio is not on";
        if (txInhibited()) return "Not sent: this channel is receive-only";
        String m = text == null || text.trim().isEmpty() ? "Need help" : text.trim();
        if (ch.isDigital()) {
            if (toNumber <= 0) return "Not sent: choose who receives the emergency text";
            android.location.Location l = lastKnownLocation();
            String pos = l == null ? "position unknown" : String.format(Locale.US, "%.5f,%.5f", l.getLatitude(), l.getLongitude()) + (l.hasAccuracy() ? " +-" + Math.round(l.getAccuracy()) + "m" : "");
            String body = "EMERGENCY " + m + " @ " + pos;
            if (body.length() > 120) body = body.substring(0, 120);
            ChannelStore.Contact to = new ChannelStore.Contact(); to.number = toNumber; to.type = toType; to.name = toName == null ? "" : toName;
            sendSms(to, body);
            String who = to.name.isEmpty() ? String.valueOf(toNumber) : to.name;
            history("tx", "🆘 Emergency text to " + who + ": " + body);
            return "Emergency text sent to " + who + (l == null ? " (no position fix)" : "");
        }
        if (packet == null) return "Not sent: packet radio is not available";
        String e = packet.sendEmergency(m);
        if (e != null) return "Not sent: " + e;
        return "Emergency APRS " + (lastKnownLocation() != null ? "position" : "status (no position fix)") + " sent on " + ch.name;
    }
    public boolean pttHeld() { return pttDown; }
    public boolean isScanning() { return scanner != null && scanner.isScanning(); }
    public boolean isScanHolding() { return scanner != null && scanner.isHolding(); }
    /** Something is actually heard: the Soft SQ gate on Soft SQ channels, the radio's own report otherwise. */
    public boolean hearing() { return softSq != null && softSq.isEnabled() ? squelchOpen : receiving && rxCounts; }
}
