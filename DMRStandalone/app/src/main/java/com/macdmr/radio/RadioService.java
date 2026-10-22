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

    // ---- simplex repeater (parrot): repeats each reception on the channel it was enabled on ----
    private final com.macdmr.radio.ham.Parrot parrot = new com.macdmr.radio.ham.Parrot(new com.macdmr.radio.ham.Parrot.Host() {
        @Override public boolean transmit(short[] pcm, String label, Runnable done) {
            ChannelStore.Channel ch = current;
            if (!isReady() || ch == null || ch.isDigital() || txInhibited() || pttDown || scanner.isScanning()) return false;
            transmitPcm(pcm, label, done); return true;
        }
        @Override public String idCallsign() { ChannelStore.Channel ch = current; return ch != null && amateurBand(ch.txFreq) && packet != null && packet.callsignSet() ? packet.callsign() : null; }
        @Override public void event(String line) { history("pkt", line); }
    });
    private volatile int parrotChannel = -1;
    private volatile long txStartedAt;

    // ---- voice keyer and the ten-minute identification timer ----
    private final com.macdmr.radio.ham.VoiceKeyer keyer = new com.macdmr.radio.ham.VoiceKeyer(this);
    public com.macdmr.radio.ham.VoiceKeyer keyer() { return keyer; }
    /** Transmit a recorded keyer message (with the Morse ID after it when set and on an amateur channel). Error or null. */
    public String sendKeyer(int slot) {
        short[] p = keyer.pcm(slot);
        if (p == null || p.length == 0) return "Nothing recorded in " + keyer.name(slot);
        ChannelStore.Channel c = current;
        if (c == null || c.isDigital()) return "The voice keyer needs an analog FM channel";
        if (txInhibited()) return "This channel is receive-only";
        boolean id = keyer.addId(slot) && amateurBand(c.txFreq) && packet != null && packet.callsignSet();
        short[] m = id ? com.macdmr.radio.coverage.Morse.pcm(packet.callsign(), 20, 800) : new short[0];
        int lead = 12000, gap = id ? 2400 : 0;                                   // 1.5 s: the radio passes audio only ~1.5 s after keying
        int voiceN = Math.min(p.length, 8000 * 28 - lead - gap - m.length);
        short[] out = new short[lead + voiceN + gap + m.length];
        System.arraycopy(p, 0, out, lead, voiceN); System.arraycopy(m, 0, out, lead + voiceN + gap, m.length);
        final String nm = keyer.name(slot); final boolean sentId = id;
        transmitPcm(out, "voice keyer: " + nm, () -> { history("pkt", "\uD83C\uDF99 Voice keyer sent: " + nm + (sentId ? " + Morse ID" : "")); if (sentId) markIdentified(); });
        return null;
    }
    public static final long ID_EVERY_MS = 10 * 60_000L;
    private volatile long idClockFrom, lastIdReminder;                       // first transmission since the last identification
    public void markIdentified() { idClockFrom = 0; }
    /** Milliseconds until the next identification is due (negative: overdue), or Long.MAX_VALUE when the timer is not running. */
    public long idDueInMs() { long f = idClockFrom; return f == 0 ? Long.MAX_VALUE : f + ID_EVERY_MS - System.currentTimeMillis(); }
    private void idTimerOnKey() {
        ChannelStore.Channel c = current;
        if (c == null || !amateurBand(c.txFreq) || packet == null || !packet.callsignSet()) return;
        long now = System.currentTimeMillis();
        if (idClockFrom == 0) { idClockFrom = now; return; }
        if (now - idClockFrom >= ID_EVERY_MS && !packet.cwIdEnabled() && now - lastIdReminder > 120_000) {
            lastIdReminder = now;
            try { android.os.Vibrator v = (android.os.Vibrator) getSystemService(VIBRATOR_SERVICE); if (v != null) v.vibrate(android.os.VibrationEffect.createWaveform(new long[] { 0, 120, 80, 120 }, -1)); } catch (Throwable ignored) { }
            ui.post(() -> android.widget.Toast.makeText(this, "Give your callsign: it has been 10 minutes since you identified", android.widget.Toast.LENGTH_LONG).show());
            history("pkt", "\u23F0 Time to identify: 10 minutes since your last ID");
        }
    }

    // ---- callsign lookup (HamDB) ----
    private com.macdmr.radio.ham.CallLookup lookup;
    public com.macdmr.radio.ham.CallLookup callLookup() { if (lookup == null) lookup = new com.macdmr.radio.ham.CallLookup(this); return lookup; }
    public boolean lookupOnline() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("lookupOnline", true); }
    public void setLookupOnline(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("lookupOnline", on).apply(); }
    private final java.util.concurrent.ExecutorService lookups = java.util.concurrent.Executors.newSingleThreadExecutor(r -> { Thread t = new Thread(r, "call-lookup"); t.setDaemon(true); return t; });
    /** Look a callsign up in the background and fill in the logbook (and {@code then}, with the result, on the worker). */
    public void enrichCall(final String call, final java.util.function.Consumer<com.macdmr.radio.ham.CallLookup.Info> then) {
        if (!lookupOnline() || com.macdmr.radio.ham.Logbook.baseCall(call) == null) return;
        lookups.execute(() -> {
            com.macdmr.radio.ham.CallLookup.Info i = callLookup().lookup(call);
            if (i == null || !i.found) return;
            try { logbook().enrich(call, i.name, i.grid, i.place()); } catch (Throwable t) { log("lookup: " + t); }
            if (then != null) then.accept(i);
        });
    }

    // ---- satellite tracking: Doppler-corrected VFO during a pass ----
    private com.macdmr.radio.ham.Satellites sats;
    public com.macdmr.radio.ham.Satellites satellites() { if (sats == null) sats = new com.macdmr.radio.ham.Satellites(this); return sats; }
    public static final class SatState { public String name = ""; public com.macdmr.radio.ham.SatTrack.Look look; public long rxHz, txHz, aos, los, nominalHz; public double maxEl; public boolean waiting, listenOnly; public int mode; }
    private volatile Thread satThread; private volatile SatState satState;
    public SatState satState() { return satState; }
    /** The tracked pass's mode (Satellites.APRS / SSTV), or -1 when nothing is tracked. */
    public int satMode() { SatState s = satState; return s == null ? -1 : s.mode; }
    public void stopSatTrack() { Thread t = satThread; satThread = null; if (t != null) t.interrupt(); }
    /** Stop tracking and following passes (the Stop buttons). */
    public void endSatTracking() { issRepeatMode = -1; stopSatTrack(); }
    /** Bench (DIAG vfo): listen on a frequency through the VFO, wide, low power. */
    void diagVfo(int hz) { ChannelStore.Channel a = new ChannelStore.Channel(); a.type = 1; a.rxFreq = a.txFreq = hz; a.band = 1; a.power = 1; a.name = "Bench"; applyVfo(a, false); }
    void diagVfoOff() { if (vfo != null && "Bench".equals(vfo.name)) exitVfo(); }
    /** Track a pass: at AOS minus a minute the VFO takes the satellite's channel, corrected for Doppler every 2 s, until LOS. */
    public String trackSat(final com.macdmr.radio.ham.Satellites.Sat sat, final com.macdmr.radio.ham.Sgp4 el, final com.macdmr.radio.ham.SatTrack.Pass pass) {
        final android.location.Location me = lastKnownLocation();
        if (me == null) return "No position fix: turn on location";
        stopSatTrack();
        final SatState st = new SatState(); st.name = sat.name; st.aos = pass.aos; st.los = pass.los; st.maxEl = pass.maxEl; st.waiting = true;
        st.mode = sat.mode; st.listenOnly = sat.listenOnly(); st.nominalHz = sat.downHz; satState = st; updateModeWake();
        if (sat.mode != com.macdmr.radio.ham.Satellites.VOICE) modeSince = System.currentTimeMillis();
        final Thread t = new Thread(() -> {
            boolean tuned = false, started = false, natural = false;
            try {
                while (satThread == Thread.currentThread() && System.currentTimeMillis() < pass.aos - 60_000) Thread.sleep(1000);
                history("pkt", "\uD83D\uDEF0 Tracking " + sat.name + ": tuning for the pass");
                ChannelStore.Channel v = new ChannelStore.Channel(); v.type = 1; v.band = 1; v.power = 1; v.name = sat.name; dataModeSquelch(v);   // satellites arrive far below the radio's squelch
                int tone = sat.toneHz > 0 ? com.macdmr.radio.ChannelPresets.ctcssIndex(sat.toneHz) : -1;
                if (tone >= 0) { v.txType = 1; v.txSubCode = tone; }
                long lastRx = 0;
                while (satThread == Thread.currentThread() && System.currentTimeMillis() < pass.los + 30_000) {
                    long now = System.currentTimeMillis();
                    com.macdmr.radio.ham.SatTrack.Look l = com.macdmr.radio.ham.SatTrack.look(el, now, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0);
                    long rx = com.macdmr.radio.ham.SatTrack.downlink(sat.downHz, l.rangeRateKmS), tx = com.macdmr.radio.ham.SatTrack.uplink(sat.upHz, l.rangeRateKmS);
                    st.look = l; st.rxHz = rx; st.txHz = tx; st.waiting = false;
                    // 2 kHz is well inside an FM channel; fewer retunes, fewer gaps. While an SSTV picture is coming in, up to
                    // 5 kHz is tolerated so the retune gap does not tear the picture.
                    boolean picture = sat.mode == com.macdmr.radio.ham.Satellites.SSTV && packet != null && packet.sstvStatus() != null && packet.sstvStatus().startsWith("receiving");
                    if (!pttDown && (!tuned || Math.abs(rx - lastRx) >= (picture ? 5000 : 2000))) {
                        v.rxFreq = (int) (Math.round(rx / 500.0) * 500); v.txFreq = sat.listenOnly() ? v.rxFreq : (int) (Math.round(tx / 500.0) * 500);
                        applyVfo(v, false); lastRx = rx; tuned = true; lastSatRetune = System.currentTimeMillis();
                    }
                    if (tuned && !started && packet != null) {         // the pass's job: decode APRS or SSTV on the moving frequency
                        started = true;
                        if (sat.mode == com.macdmr.radio.ham.Satellites.APRS) { aprsMonitorHz = (int) sat.downHz; packet.setMonitoring(true); pushModes(); }
                        else if (sat.mode == com.macdmr.radio.ham.Satellites.SSTV) { packet.setSstvForceContinuous(true); packet.setSstvRx(true); pushModes(); }   // ISS events are Robot 36: no VIS needed, partial pictures kept
                    }
                    Thread.sleep(2000);
                }
                natural = satThread == Thread.currentThread();      // the pass ended (not stopped)
            } catch (InterruptedException ignored) {
            } catch (Throwable x) { log("sat track: " + x); }
            finally {
                if (started && packet != null) {
                    if (sat.mode == com.macdmr.radio.ham.Satellites.APRS) packet.setMonitoring(false);
                    else if (sat.mode == com.macdmr.radio.ham.Satellites.SSTV) { packet.setSstvRx(false); packet.setSstvForceContinuous(false); }
                }
                if (tuned && vfo != null && sat.name.equals(vfo.name)) exitVfo();
                if (satState == st) satState = null;
                if (natural && sat.catalog == com.macdmr.radio.ham.Satellites.ISS_CATALOG && issRepeatMode == sat.mode)   // following every pass: the next one
                    ui.postDelayed(() -> { if (issRepeatMode == sat.mode && satState == null) { String e = startIssMode(sat.mode); if (e != null) { history("pkt", "\uD83D\uDEF0 " + e); issRepeatMode = -1; } } }, 5000);
                pushModes();
                history("pkt", "\uD83D\uDEF0 " + sat.name + " pass over");
            }
        }, "sat-track");
        satThread = t; t.setDaemon(true); t.start();
        return null;
    }

    // ---- nets (net control) ----
    private com.macdmr.radio.ham.NetStore nets;
    public com.macdmr.radio.ham.NetStore nets() { if (nets == null) nets = new com.macdmr.radio.ham.NetStore(this); return nets; }
    private NetWatch netWatch;
    /** Nets near you (NetLogger + what the radio heard) and their reminders. */
    public NetWatch netWatch() { if (netWatch == null) netWatch = new NetWatch(this); return netWatch; }

    // ---- logbook ----
    private com.macdmr.radio.ham.Logbook logbook;
    public com.macdmr.radio.ham.Logbook logbook() { if (logbook == null) logbook = new com.macdmr.radio.ham.Logbook(this); return logbook; }
    public boolean logHeard() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("logHeard", true); }
    public void setLogHeard(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("logHeard", on).apply(); }
    void logHeardStation(String call, String mode, String note) {
        if (!logHeard()) return;
        ChannelStore.Channel c = current;
        try { logbook().heard(call, c != null ? c.rxFreq : 0, mode, null, note); enrichCall(call, null); } catch (Throwable t) { log("logbook: " + t); }
    }

    // ---- fox hunt: the hunter's marks, the fox beacon and the off-frequency trick ----
    private final com.macdmr.radio.ham.FoxHunt fox = new com.macdmr.radio.ham.FoxHunt();
    public com.macdmr.radio.ham.FoxHunt fox() { return fox; }
    private volatile Thread foxThread; private volatile int foxChannel = -1;
    public boolean foxTxOn() { return foxThread != null; }
    /** Start or stop the fox beacon (5 s of beeps every minute on the current channel). Returns a message. */
    public String setFoxTx(boolean on) {
        Thread t = foxThread; foxThread = null; if (t != null) t.interrupt();
        if (!on) { if (t != null) history("pkt", "\uD83E\uDD8A Fox beacon off"); pushModes(); return "Fox beacon off"; }
        ChannelStore.Channel ch = current;
        if (ch == null || ch.isDigital()) return "The fox beacon needs an analog FM channel";
        if (txInhibited()) return "This channel is receive-only";
        foxChannel = ch.number;
        final Thread nt = new Thread(() -> {
            while (foxThread == Thread.currentThread()) {
                ChannelStore.Channel c = current;
                if (c == null || c.number != foxChannel) { foxThread = null; history("pkt", "\uD83E\uDD8A Fox beacon stopped: the channel changed"); pushModes(); break; }
                if (isReady() && !pttDown && !scanner.isScanning() && !txInhibited()) {
                    String id = amateurBand(c.txFreq) && packet != null && packet.callsignSet() ? packet.callsign() : null;
                    transmitPcm(com.macdmr.radio.ham.FoxHunt.beacon(5, id), "fox beacon", null);
                }
                try { Thread.sleep(60_000); } catch (InterruptedException e) { break; }
            }
        }, "fox-beacon");
        foxThread = nt; nt.setDaemon(true); nt.start();
        history("pkt", "\uD83E\uDD8A Fox beacon on " + ch.name + " (every minute)");
        pushModes();
        return "Fox beacon on " + ch.name + ": 5 s of beeps every minute";
    }
    private ChannelStore.Channel foxHome;
    /** Listen {@code hz} above the channel (0 = back on it): close to the fox, an off-frequency signal is weaker and easier to judge. Error or null. */
    public String foxOffset(int hz) {
        if (hz == 0) { if (foxHome != null) { foxHome = null; exitVfo(); } return null; }
        ChannelStore.Channel base = foxHome != null ? foxHome : current;
        if (base == null || base.isDigital()) return "Needs an analog channel";
        if (foxHome == null) foxHome = base;
        ChannelStore.Channel v = vfoCopy(base); v.rxFreq = base.rxFreq + hz; v.txFreq = base.txFreq; v.name = base.name + " +" + (hz / 1000) + " kHz";
        applyVfo(v, false);
        return null;
    }
    public com.macdmr.radio.ham.Parrot parrot() { return parrot; }
    /** Turn the parrot on for the current channel (or off). Returns what happened, for a toast. */
    public String setParrot(boolean on) {
        if (!on) { if (parrot.enabled()) history("pkt", "\uD83E\uDD9C Parrot off (" + parrot.played() + " repeated)"); parrot.setEnabled(false); parrotChannel = -1; pushModes(); return "Parrot off"; }
        ChannelStore.Channel ch = current;
        if (ch == null || ch.isDigital()) return "The parrot needs an analog FM channel";
        if (txInhibited()) return "This channel is receive-only";
        if (!softSq.isEnabled() && hardwareSq(ch) == 0) return "Turn the channel's squelch up (or Soft SQ on) first: with squelch 0 the parrot would repeat static";
        parrotChannel = ch.number; modeSince = System.currentTimeMillis(); parrot.setEnabled(true);
        history("pkt", "\uD83E\uDD9C Parrot on: repeating what is heard on " + ch.name);
        pushModes();
        return "Parrot on " + ch.name + ": transmissions are repeated a second after they end";
    }
    /** 2 m, 1.25 m and 70 cm amateur bands (US). */
    public static boolean amateurBand(int hz) { return (hz >= 144_000_000 && hz <= 148_000_000) || (hz >= 222_000_000 && hz <= 225_000_000) || (hz >= 420_000_000 && hz <= 450_000_000); }
    public PacketEngine packet() { return packet; }
    private final DiagReceiver diag = new DiagReceiver();
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
    private volatile long modeSince;
    /** When the mode that has the radio (APRS monitor, KISS, SSTV, parrot) started; 0 if none. */
    public long modeSince() { return packetActive() ? modeSince : 0; }
    public void markModeStart() { modeSince = System.currentTimeMillis(); }
    // Keep the CPU awake while a mode runs or a satellite pass is awaited: the beacon / telemetry timer, the pass
    // wait and the decoders are plain threads and timers, which stop in deep sleep (screen off in the car). Until
    // 2026-10-20 the phone only stayed awake by accident, through the audio mixer's wake lock while RX audio played.
    private android.os.PowerManager.WakeLock modeWake;
    void updateModeWake() {
        boolean want = packetActive() || satState != null;
        try {
            if (modeWake == null) { android.os.PowerManager pm = (android.os.PowerManager) getSystemService(POWER_SERVICE); modeWake = pm.newWakeLock(android.os.PowerManager.PARTIAL_WAKE_LOCK, "signaldeck:mode"); modeWake.setReferenceCounted(false); }
            if (want && !modeWake.isHeld()) { modeWake.acquire(); log("wake lock on (a mode is running)"); exemptFromDoze(); }
            else if (!want && modeWake.isHeld()) { modeWake.release(); log("wake lock off"); }
        } catch (Throwable t) { log("wake lock: " + t); }
    }
    /** Doze ignores the wake locks of apps that are not exempt (phone unplugged, still and dark, e.g. on the nightstand
     *  for a 4 a.m. ISS pass): put the app on the battery-optimisation allowlist with root, once. */
    private volatile boolean dozeChecked;
    private void exemptFromDoze() {
        if (dozeChecked) return; dozeChecked = true;
        worker.execute(() -> {
            try {
                android.os.PowerManager pm = (android.os.PowerManager) getSystemService(POWER_SERVICE);
                if (pm.isIgnoringBatteryOptimizations(getPackageName())) return;
                RootSetup.run("dumpsys deviceidle whitelist +" + getPackageName());
                log(pm.isIgnoringBatteryOptimizations(getPackageName()) ? "battery optimisation: exempt (Doze no longer pauses modes)" : "battery optimisation: could not exempt the app");
            } catch (Throwable t) { log("doze exemption: " + t); }
        });
    }
    public boolean packetActive() { return parrot.enabled() || foxTxOn() || (packet != null && (packet.monitoring() || packet.kiss().isActive() || packet.sstvRx())); }

    /** SSTV receive: on the SSTV calling frequency (through the VFO) or on the current channel. */
    public String sstvMonitor(boolean on, boolean park) {
        if (packet == null) return "not ready";
        if (on) {
            if (park) {
                ChannelStore.Channel a = new ChannelStore.Channel();
                a.type = 1; a.rxFreq = a.txFreq = PacketEngine.SSTV_FREQ_HZ; a.band = 1; a.power = 1; a.name = "SSTV 144.500"; dataModeSquelch(a);
                applyVfo(a, false);
            }
            if (!packet.sstvRx()) modeSince = System.currentTimeMillis();
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
        @Override public int rssiDbm() { return rssi; }
        @Override public void wantLocation(boolean on) { ui.post(() -> aprsLocation(on)); }
        @Override public void logHeard(String call, String mode, String note) { RadioService.this.logHeardStation(call, mode, note); }
        @Override public void identified() { markIdentified(); }
        @Override public void dtmfSequence(String digits) { if (packet != null) remote.handle(digits, packet.remotePin(), packet.remoteOn(), System.currentTimeMillis()); }
    };

    // ---- DTMF remote control: PIN + command digit, answered on the channel ----
    private final com.macdmr.radio.ham.VoiceReply voice = new com.macdmr.radio.ham.VoiceReply(this);
    private final com.macdmr.radio.ham.DtmfRemote remote = new com.macdmr.radio.ham.DtmfRemote(new com.macdmr.radio.ham.DtmfRemote.Actions() {
        @Override public void speakPosition() {
            android.location.Location l = lastKnownLocation();
            if (l == null) { voiceTx("No position fix."); return; }
            String place = "";
            try { java.util.List<android.location.Address> a = new android.location.Geocoder(RadioService.this, Locale.US).getFromLocation(l.getLatitude(), l.getLongitude(), 1); if (a != null && !a.isEmpty() && a.get(0).getLocality() != null) place = "Near " + a.get(0).getLocality() + (a.get(0).getAdminArea() != null ? ", " + a.get(0).getAdminArea() : "") + ". "; } catch (Throwable ignored) { }
            voiceTx("Position. " + place + String.format(Locale.US, "%.3f %s, %.3f %s.", Math.abs(l.getLatitude()), l.getLatitude() >= 0 ? "north" : "south", Math.abs(l.getLongitude()), l.getLongitude() >= 0 ? "east" : "west"));
        }
        @Override public void speakStatus() {
            android.content.Intent b = registerReceiver(null, new android.content.IntentFilter(android.content.Intent.ACTION_BATTERY_CHANGED));
            int level = b == null ? -1 : b.getIntExtra(android.os.BatteryManager.EXTRA_LEVEL, 0) * 100 / Math.max(1, b.getIntExtra(android.os.BatteryManager.EXTRA_SCALE, 100));
            ChannelStore.Channel c = current;
            voiceTx("Status. " + (level >= 0 ? "Battery " + level + " percent. " : "") + (c != null ? "Channel " + c.name + ". " : "") + (rssi != -999 ? "Signal minus " + Math.abs(rssi) + " dBm." : ""));
        }
        @Override public void beacon() { if (packet != null) { String e = packet.sendBeacon(); if (e != null) history("pkt", "\u26D4 Remote beacon not sent: " + e); } }
        @Override public void parrot(boolean on) { ui.post(() -> history("pkt", "\uD83D\uDCDF " + setParrot(on))); }
        @Override public void morseId() { if (packet != null) { String e = packet.sendCwId(); if (e != null) history("pkt", "\u26D4 " + e); } }
        @Override public void event(String line) { history("pkt", line); }
    });
    /** Speak {@code text} on the channel 1.5 s after the caller unkeys; on amateur channels the Morse ID follows. */
    private void voiceTx(String text) {
        voice.say(text, pcm -> {
            try { Thread.sleep(1500); } catch (InterruptedException ignored) { }
            ChannelStore.Channel c = current;
            short[] id = c != null && amateurBand(c.txFreq) && packet != null && packet.callsignSet() ? com.macdmr.radio.coverage.Morse.pcm(packet.callsign(), 20, 800) : new short[0];
            int lead = 12000, max = 8000 * 28;                     // 1.5 s: the radio passes audio only ~1.5 s after keying
            int voiceN = Math.min(pcm.length, max - lead - id.length);
            short[] out = new short[lead + voiceN + id.length];
            System.arraycopy(pcm, 0, out, lead, voiceN); System.arraycopy(id, 0, out, lead + voiceN, id.length);
            transmitPcm(out, "remote reply", () -> history("pkt", "\uD83D\uDDE3 Remote reply sent: " + text));
        });
    }
    private android.location.LocationListener aprsGps;
    private void aprsLocation(boolean on) {
        android.location.LocationManager lm = (android.location.LocationManager) getSystemService(LOCATION_SERVICE);
        if (lm == null) return;
        if (on && aprsGps == null) {
            aprsGps = l -> { if (packet != null) packet.onLocation(l); };
            try { lm.requestLocationUpdates(android.location.LocationManager.GPS_PROVIDER, 5000, 10, aprsGps, android.os.Looper.getMainLooper()); log("SmartBeaconing: GPS on"); } catch (Throwable t) { log("SmartBeaconing GPS: " + t); aprsGps = null; }
        } else if (!on && aprsGps != null) { try { lm.removeUpdates(aprsGps); } catch (Throwable ignored) { } aprsGps = null; }
    }

    private volatile long lastSatRetune;
    /** Wait after a retune before keying: the MCU's channel change completes about 3 s later and would cut the transmission. */
    static final long RETUNE_SETTLE_MS = 4000;
    /** Beacon through the space station's digipeater (path ARISS) on the ISS APRS frequency, corrected for Doppler.
     *  Only while the ISS is above the horizon: during a tracked ISS APRS pass it uses that tuning, otherwise it tunes
     *  for the moment, beacons and comes back. */
    public String issBeacon() {
        if (packet == null) return "not ready";
        if (!packet.callsignSet()) return "Set your callsign first (PKT \u2192 Settings)";
        final android.location.Location me = lastKnownLocation();
        if (me == null) return "No position fix yet";
        SatState st = satState;
        if (st != null && st.mode == com.macdmr.radio.ham.Satellites.APRS && !st.waiting && st.look != null) {
            if (st.look.el < 0) return "The ISS is below the horizon";
            new Thread(() -> {
                try { long wait = RETUNE_SETTLE_MS - (System.currentTimeMillis() - lastSatRetune); if (wait > 0) Thread.sleep(wait); } catch (InterruptedException ignored) { }
                String e = packet.sendBeaconVia(new String[] { "ARISS" });
                if (e != null) history("pkt", "\u26D4 ISS beacon not sent: " + e);
            }, "iss-beacon").start();
            return "Beaconing via the ISS (ARISS)";
        }
        com.macdmr.radio.ham.Sgp4 el = satellites().elements().get(com.macdmr.radio.ham.Satellites.ISS_CATALOG);
        if (el == null) return "No ISS orbit yet: open Satellite passes once to download it";
        long now = System.currentTimeMillis();
        com.macdmr.radio.ham.SatTrack.Look l = com.macdmr.radio.ham.SatTrack.look(el, now, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0);
        if (l.el < 5) {
            String next = nextIssPassText(el, me);
            return "The ISS is not in view" + (next != null ? ": next pass " + next : "");
        }
        long hz = com.macdmr.radio.ham.Satellites.issHz(this, "issAprs", com.macdmr.radio.ham.Satellites.ISS_APRS_HZ);
        ChannelStore.Channel a = new ChannelStore.Channel(); a.type = 1; a.band = 1; a.power = 1; a.name = "ISS APRS"; dataModeSquelch(a);
        // the beacon goes out about 5 s from now: aim for the Doppler then
        com.macdmr.radio.ham.SatTrack.Look l5 = com.macdmr.radio.ham.SatTrack.look(el, now + 5000, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0);
        a.rxFreq = (int) (Math.round(com.macdmr.radio.ham.SatTrack.downlink(hz, l5.rangeRateKmS) / 500.0) * 500);
        a.txFreq = (int) (Math.round(com.macdmr.radio.ham.SatTrack.uplink(hz, l5.rangeRateKmS) / 500.0) * 500);
        applyVfo(a, false);
        final int rxHz = a.rxFreq;
        new Thread(() -> {
            try { Thread.sleep(RETUNE_SETTLE_MS); } catch (InterruptedException ignored) { }       // the retune settles before keying
            String e = packet.sendBeaconVia(new String[] { "ARISS" });
            if (e != null) history("pkt", "\u26D4 ISS beacon not sent: " + e);
            try { Thread.sleep(12000); } catch (InterruptedException ignored) { }
            if (vfo != null && vfo.rxFreq == rxHz && satState == null) exitVfo();
        }, "iss-beacon").start();
        return String.format(Locale.US, "ISS at %.0f\u00B0: beaconing on %.4f MHz (Doppler-corrected) via ARISS", l.el, a.txFreq / 1e6);
    }

    /** The next ISS pass above 10\u00B0 as "Tue 15:42 (highest 48\u00B0)", or null. */
    public String nextIssPassText(com.macdmr.radio.ham.Sgp4 el, android.location.Location me) {
        java.util.List<com.macdmr.radio.ham.SatTrack.Pass> ps = com.macdmr.radio.ham.SatTrack.passes(el, System.currentTimeMillis(), 24, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0, 10);
        for (com.macdmr.radio.ham.SatTrack.Pass p : ps) if (p.aos > System.currentTimeMillis())
            return new java.text.SimpleDateFormat("EEE HH:mm", Locale.US).format(new java.util.Date(p.aos)) + String.format(Locale.US, " (highest %.0f\u00B0)", p.maxEl);
        return null;
    }

    /** ISS APRS or ISS SSTV: track the pass that is up now, or the next one above 10\u00B0 in the next day; the pass page
     *  shows the countdown and the decoding. Returns an error, or null when tracking starts. */
    public String startIssMode(int mode) {
        android.location.Location me = lastKnownLocation();
        if (me == null) return "No position fix: turn on location";
        com.macdmr.radio.ham.Sgp4 el = satellites().elements().get(com.macdmr.radio.ham.Satellites.ISS_CATALOG);
        if (el == null) return "No ISS orbit yet: open Satellite passes once to download it";
        com.macdmr.radio.ham.Satellites.Sat sat = com.macdmr.radio.ham.Satellites.byKey(this, mode == com.macdmr.radio.ham.Satellites.SSTV ? "iss-sstv" : "iss-aprs");
        long now = System.currentTimeMillis();
        for (com.macdmr.radio.ham.SatTrack.Pass p : com.macdmr.radio.ham.SatTrack.passes(el, now - 15 * 60_000L, 24, me.getLatitude(), me.getLongitude(), me.hasAltitude() ? me.getAltitude() : 0, 10))
            if (p.los > now + 60_000) return trackSat(sat, el, p);
        return "No ISS pass above 10\u00B0 in the next 24 hours";
    }
    /** Keep tracking the ISS pass after pass (for an SSTV event or a day of APRS): restarted at each LOS. */
    private volatile int issRepeatMode = -1;
    public void setIssRepeat(int mode) { issRepeatMode = mode; }
    public int issRepeat() { return issRepeatMode; }

    /** Hands-free one-shot transmission: key, play the PCM through the TX path, release, resume RX. */
    public void transmitPcm(final short[] pcm, final String label, final Runnable onDone) {
        worker.execute(() -> {
            try {
                if (!isReady()) { log("TX " + label + " skipped: radio not ready"); return; }
                if (txInhibited()) { log("TX " + label + " blocked: receive-only channel"); history("warn", "\u26D4 TX blocked on a receive-only channel"); return; }
                if (pttDown) { log("TX " + label + " skipped: PTT busy"); return; }
                int ms = pcm.length / 8;
                if (ms > 28500) { log("TX " + label + " refused: " + ms + " ms exceeds the 30 s transmit limit"); history("warn", "\u26D4 Too long for this radio's 30 s transmit limit (" + label + ")"); return; }
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
    public String aprsMonitor(boolean on) { return aprsMonitorAt(on, PacketEngine.APRS_FREQ_HZ, "APRS 144.390"); }
    private volatile int aprsMonitorHz = PacketEngine.APRS_FREQ_HZ;
    public int aprsMonitorHz() { return aprsMonitorHz; }
    /** APRS monitoring on another frequency (the ISS digipeater on 145.825). */
    public String aprsMonitorAt(boolean on, int hz, String name) {
        if (packet == null) return "not ready";
        if (on) {
            aprsMonitorHz = hz;
            ChannelStore.Channel a = new ChannelStore.Channel();
            a.type = 1; a.rxFreq = a.txFreq = hz; a.band = 1; a.power = 1; a.name = name; dataModeSquelch(a);
            if (!packet.monitoring()) modeSince = System.currentTimeMillis();
            packet.setMonitoring(true);
            applyVfo(a, false);
            pushModes();
            return "APRS monitoring on " + String.format(Locale.US, "%.3f", hz / 1e6) + " MHz";
        }
        packet.setMonitoring(false);
        if (vfo != null && vfo.rxFreq == aprsMonitorHz) exitVfo();
        pushModes();
        return "APRS monitoring off";
    }

    @Override public void onCreate() {
        super.onCreate();
        startForegroundTyped(false);
        running = this;
        watchCar();
        watchUsbDuringTx();
        ProfileRegistry.init(this);
        profile = DeviceProfile.detect();
        ProfileRegistry.maybeFetch();                               // a newer revision or an advisory, at most every 12 h
        store = new ChannelStore(this);
        zoneId = getSharedPreferences("radio", MODE_PRIVATE).getLong("zone", 0);
        if (coverage().enabled()) { coverage.resume(); startForegroundTyped(true); }
        engine = new RadioEngine(profile, this);
        packet = new PacketEngine(packetHost);
        packet.applySettings();
        com.macdmr.radio.car.RadioCallService.register(this);
        // developer bench tools: adb only (the sender must hold DUMP, which the shell has and apps cannot get)
        try {
            android.content.IntentFilter df = new android.content.IntentFilter(DiagReceiver.ACTION);
            if (Build.VERSION.SDK_INT >= 33) registerReceiver(diag, df, "android.permission.DUMP", null, RECEIVER_EXPORTED); else registerReceiver(diag, df, "android.permission.DUMP", null);
        } catch (Throwable t) { log("diag receiver: " + t); }
        radioId = new RadioIdStore(this);
        if (!getSharedPreferences("radio", MODE_PRIVATE).getBoolean("smsStatusMigrated", false)) {     // texts marked failed before 2026-10-17 were only unacknowledged
            try { store.getWritableDatabase().execSQL("UPDATE messages SET status=3 WHERE status=2 AND outgoing=1"); } catch (Throwable ignored) { }
            getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("smsStatusMigrated", true).apply();
        }
        registerHardwarePtt();
        customKey = new CustomPttKey.Listener(this, down -> { if (pttLearning) return; if (down) { if (isReady()) ptt(true); } else ptt(false); }, this::log);
        if (profile.supported) customKey.start();
        netWatch().start();
        web = new com.macdmr.radio.web.WebHost(this);
        if (web.enabled()) { String e = web.start(); if (e != null) log("web: " + e); }
    }

    /** SignalDeck Web: the built-in web server (Device → SignalDeck Web). */
    private com.macdmr.radio.web.WebHost web;
    public com.macdmr.radio.web.WebHost web() { return web; }

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
                if (!getSharedPreferences("radio", MODE_PRIVATE).getBoolean("hwPtt", true) || pttLearning) return;
                for (int k = 0; k < profile.pttActions.length; k++) if (a.equals(profile.pttActions[k])) { if (k % 2 == 0) { if (isReady()) ptt(true); } else ptt(false); return; }
            }
        };
        android.content.IntentFilter f = new android.content.IntentFilter();
        for (String a : profile.pttActions) f.addAction(a);
        try { if (Build.VERSION.SDK_INT >= 33) registerReceiver(pttKey, f, RECEIVER_EXPORTED); else registerReceiver(pttKey, f); } catch (Throwable t) { log("ptt key: " + t); }
    }
    // ---- a PTT key the owner taught it (CustomPttKey): any hardware or Bluetooth button, read with root ----
    private CustomPttKey.Listener customKey;
    private volatile boolean pttLearning;
    /** While a key is being learned no key transmits (the owner is pressing buttons on purpose). */
    public void setPttLearning(boolean on) { pttLearning = on; if (on && pttDown) ptt(false); }
    /** After the learned key or its switch changed. */
    public void customPttChanged() { if (customKey == null) return; if (profile.supported && CustomPttKey.enabled(this)) customKey.start(); else customKey.stop(); }
    /** The activity swallows the learned key's events while the listener does the keying (no volume change in the app). */
    public boolean customPttConsumes(int keyCode) {
        if (keyCode == 0 || customKey == null || !customKey.isRunning()) return false;
        CustomPttKey.Key k = CustomPttKey.saved(this); return k != null && k.androidKey == keyCode;
    }
    public boolean hwPtt() { return getSharedPreferences("radio", MODE_PRIVATE).getBoolean("hwPtt", true); }
    public void setHwPtt(boolean on) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("hwPtt", on).apply(); if (!on && pttDown) ptt(false); }

    @Override public void onDestroy() {
        running = null; RadioWidget.refresh(this, null);
        try { if (web != null) web.stop(); } catch (Throwable ignored) { }
        try { if (coverage != null) coverage.stop(); } catch (Throwable ignored) { }
        stopBluetoothMic();
        try { if (pttKey != null) unregisterReceiver(pttKey); } catch (Throwable ignored) { }
        try { if (customKey != null) customKey.stop(); } catch (Throwable ignored) { }
        try { if (netWatch != null) netWatch.stop(); } catch (Throwable ignored) { }
        try { unregisterReceiver(diag); } catch (Throwable ignored) { }
        try { if (powerOff != null) unregisterReceiver(powerOff); } catch (Throwable ignored) { }
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
            boolean pausedStock = false;
            try {
                setLink("root");
                boolean root = RootSetup.haveRoot();
                if (!root) {
                    boolean stockRunning = !RootSetup.run("pidof " + profile.stockApp + " || true").trim().replaceAll("[^0-9]", "").isEmpty();
                    if (stockRunning || !new java.io.File(profile.controlPort).canRead()) {
                        setLink("no root");
                        log("Root was not granted. Open the Magisk app → Superuser → allow \"SignalDeck\", then tap Bring radio up. (Without root the stock app keeps the radio and the UART stays locked.)");
                        return;
                    }
                    log("No root granted, but the UART is reachable and the stock app is not running — continuing");
                } else {
                    log("sepolicy: " + RootSetup.applySepolicy(getFilesDir(), profile));
                    if (!com.pri.prizeinterphone.serial.port.SerialPort.load(this, profile.serialLib)) log("tty (stty fallback): " + RootSetup.ensureTty(profile));
                    if (RootSetup.stockAppEnabled(profile)) { log("stock app paused (its icon disappears while this app owns the radio; Device → Release brings it back): " + RootSetup.stockApp(profile, false)); pausedStock = true; Thread.sleep(1500); }
                }
                final boolean quickChat = "com.chamsion.quickchat".equals(profile.stockApp);      // Xplore 1: a Room database, no module side tables
                if (quickChat && store.count() == 0) {
                    StringBuilder err = new StringBuilder();
                    int n = store.importFromQuickChat(this, profile.stockApp, err);
                    log(n >= 0 ? "imported " + n + " channels from QuickChat" + (err.length() > 0 ? " (" + err + ")" : "") : "QuickChat import failed: " + err);
                    if (n >= 0) getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("tgListsImported", true).apply();
                }
                if (!quickChat && !getSharedPreferences("radio", MODE_PRIVATE).contains("dmrId")) {     // seed our DMR ID from the stock app's setting
                    String xml = RootSetup.run("cat /data/data/" + profile.stockApp + "/shared_prefs/com.pri.prizeinterphone.data.person.xml");
                    java.util.regex.Matcher m = java.util.regex.Pattern.compile("name=\"pref_person_device_id\" value=\"([0-9]+)\"").matcher(xml);
                    if (m.find()) { setLocalIdQuiet(Integer.parseInt(m.group(1))); log("DMR ID from the stock app: " + m.group(1)); }
                }
                if (!quickChat && store.count() == 0) {
                    StringBuilder err = new StringBuilder();
                    int n = store.importFromStock(this, profile.stockApp, "default_uhf", err);
                    log(n >= 0 ? "imported " + n + " channels from the stock app" : "stock import failed: " + err);
                    if (n >= 0) getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("tgListsImported", true).apply();
                }
                if (!getSharedPreferences("radio", MODE_PRIVATE).getBoolean("garbledPktPurged", false)) {   // noise frames logged before the AX.25 plausibility check
                    int k = store.purgeGarbledPacketHistory(); log("removed " + k + " garbled packet lines from the history");
                    getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("garbledPktPurged", true).apply();
                }
                if (!quickChat && !getSharedPreferences("radio", MODE_PRIVATE).getBoolean("tgListsImported", false)) {   // installs imported before TG lists were read
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
            } catch (Throwable t) {
                log("bring-up failed: " + t);
                if (pausedStock) {                            // never leave the phone with no working radio app
                    try { engine.close(); } catch (Throwable ignored) { }
                    log("stock app on again: " + RootSetup.stockApp(profile, true));
                }
                setLink("error: " + t.getMessage());
            }
        }, "radio-bringup").start();
    }

    public void shutDown(final boolean restoreStock) {
        new Thread(() -> {
            if (restoreStock) log("stock app on: " + RootSetup.stockApp(profile, true));
            try { if (audio != null) { audio.stopRx(); audio.releaseForStockApp(); } } catch (Throwable ignored) { }
            engine.close();
            setLink("stopped");
        }, "radio-shutdown").start();
    }

    private void startRxAudio() {
        try {
            if (audio == null) {
                audio = profile.audio == DeviceProfile.Audio.UART_PCM ? new UartPcmAudio(profile.pcmPort, profile.pcmBaud) : new TinyServiceAudio();
                audio.setSink((b, len) -> { if (!injecting) onRxPcm(b, len); });   // a bench injection replaces the live audio while it plays
                audio.setGate(() -> squelchOpen && !muted);
            }
            log(audio.startRx(true)); rxAudioOn = true;
        } catch (Throwable t) { log("audio: " + t); }
    }

    /** Every received 8 kHz stereo (L == R) block: take the left channel, run the squelch, record, meter. */
    private final byte[] mono = new byte[4096];
    private void onRxPcm(byte[] b, int len) {
        rxPcmBytes += len;
        int n = 0;
        for (int i = 0; i + 3 < len && n + 1 < mono.length; i += 4) { mono[n++] = b[i]; mono[n++] = b[i + 1]; }
        boolean open = injecting || current == null || current.isDigital() ? true : softSq.process(mono, n);
        if (BuildConfig.DEBUG && softSq.isEnabled() && System.currentTimeMillis() - lastSqDiag > 2000) { lastSqDiag = System.currentTimeMillis(); log("soft sq: " + softSq.describe() + " gate=" + open); }
        if (open != squelchOpen && softSq.isEnabled()) log("soft squelch " + (open ? "open" : "closed") + (current != null && current.rxType == 1 ? " (CTCSS " + com.macdmr.radio.dsp.ToneTable.ctcssLabel(current.rxSubCode) + ")" : ""));
        if (open != squelchOpen && softSq.isEnabled()) { softGateHistory(open); squelchOpen = open; pushModes(); }   // pages see the gate (activity box, Soft SQ number colour)
        squelchOpen = open;
        if (web != null && open && !muted && !pttDown) web.rxAudio(mono, n);      // SignalDeck Web listeners hear what the speaker plays
        ClipRecorder clip = this.clip;                                            // listen check: what arrived, before the speaker
        if (clip != null && (!clipOnlyHeard || rxActive()) && !clip.write(mono, n)) this.clip = null;
        int peak = 0;
        if (open) for (int i = 0; i + 1 < n; i += 2) { int v = Math.abs((short) ((mono[i] & 0xFF) | (mono[i + 1] << 8))); if (v > peak) peak = v; }
        if (captionsOn && open) {
            if ("google".equals(captionEngine())) googleFeed(mono, n, peak);
            else if (captions != null && captions.isActive()) captions.feed8kMono(mono, n);
            else if (peak > 400 && System.currentTimeMillis() - captionLastEnd > 1500 && captions != null) { Log.i(TAG, "captions: starting utterance (peak " + peak + ")"); captions.start(); }
        }
        if (packet != null) packet.feed(mono, n, open, packet.monitoring() || packet.sstvRx());   // APRS / SSTV decode below any squelch (noise fails the CRC / VIS); Morse and DTMF wait for a signal
        if (parrot.enabled()) {
            ChannelStore.Channel pc = current;
            if (pc == null || pc.number != parrotChannel) { ui.post(() -> { if (parrot.enabled()) { setParrot(false); history("pkt", "\uD83E\uDD9C Parrot stopped: the channel changed"); } }); }
            else parrot.feed(mono, n, open && hearing(), System.currentTimeMillis());
        }
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
        updateModeWake();
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
    public void setZone(long id) {
        zoneId = id; getSharedPreferences("radio", MODE_PRIVATE).edit().putLong("zone", id).apply(); pushModes();
        // tune the channel last used in this zone (or stay, when the current channel is in it; else its first channel)
        if (pttDown || scanner.isScanning() || vfo != null) return;              // not while talking, scanning (it carries on in the new zone) or on the VFO
        java.util.List<ChannelStore.Channel> in = zoneChannels(); if (in.isEmpty()) return;
        int last = getSharedPreferences("radio", MODE_PRIVATE).getInt("zoneLast_" + id, -1);
        ChannelStore.Channel cur = current; int target = -1; boolean curIn = false;
        for (ChannelStore.Channel c : in) { if (c.number == last) target = last; if (cur != null && c.number == cur.number) curIn = true; }
        if (target < 0) { if (curIn) return; target = in.get(0).number; }
        if (cur == null || cur.number != target) selectChannel(target);
    }
    /** Remember the channel as the last one used in the current zone (not for channels the scanner steps through). */
    private void rememberZoneChannel(int number) {
        if (scanner.isScanning()) return;
        for (ChannelStore.Channel c : zoneChannels()) if (c.number == number) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("zoneLast_" + zoneId, number).apply(); return; }
    }
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
    /** Something is being heard right now (the Soft SQ gate when it is on, else the module's own receive state). */
    public boolean rxActive() { return softSq.isEnabled() ? squelchOpen : receiving; }
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
        rememberZoneChannel(number);
    }

    /** Squelch byte for the module: with Soft SQ on the radio's squelch is held open (0) and the app decides; otherwise the channel's own level. */
    private int hardwareSq(ChannelStore.Channel ch) { return softSqFor(ch) ? 0 : ch.sq; }
    /** APRS, SSTV and satellite channels: the radio's squelch wide open (its single threshold sits near -90 dBm, far
     *  above a satellite or a distant digipeater), so the decoders get every signal; Soft SQ keeps the speaker quiet
     *  until something is really there. */
    /** First-run trial: listen on an analog frequency with the radio's squelch open (noise keeps the audio path busy); receive only. */
    public void listenTest(int hz, String name) {
        ChannelStore.Channel a = new ChannelStore.Channel();
        a.type = 1; a.rxFreq = a.txFreq = hz; a.band = 1; a.power = 1; a.name = name;
        a.sq = 0; a.softSq = true; a.softSqLevel = 5;                 // the radio passes everything; Soft SQ keeps the speaker quiet
        applyVfo(a, false);
    }

    private void dataModeSquelch(ChannelStore.Channel c) {
        c.sq = 0; c.softSq = true; c.softSqLevel = 5;
        c.power = packet != null ? packet.dataTxPower() : 1;      // APRS settings: high (default) or low on these frequencies
    }

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
            synchronized (tunes) { tunes.addLast(new Object[] { ch, false }); }   // answered like any channel write
            engine.setAnalog(ch.rxFreq, ch.txFreq, band, ch.power, hardwareSq(ch), ch.rxType, ch.rxSubCode, ch.txType, ch.txSubCode, 8, 2);
            if (profile.globalSquelch) engine.setSquelch(hardwareSq(ch));
        } catch (IOException e) { log("squelch rewrite: " + e); }
    }

    /** Program the radio with a channel; {@code fromStore} = a real channel (remembered as active), else the VFO. */
    private synchronized boolean applyChannelNow(ChannelStore.Channel ch, boolean fromStore) {
        if (!ChannelStore.inBand(ch.rxFreq) || !ChannelStore.inBand(ch.txFreq)) {         // the module refuses these and stays where it is: never show them as tuned
            ChannelStore.Channel on = current;
            history("warn", "⚠ " + ch.name + " (" + ch.freqText(ch.rxFreq) + (ch.txFreq != ch.rxFreq ? " / " + ch.freqText(ch.txFreq) : "") + " MHz) is outside what this radio can tune (136–174 and 400–480 MHz)"
                    + (on != null ? "; still on " + on.name + ", " + on.freqText(on.rxFreq) + " MHz" : ""));
            if (!fromStore && vfo == ch) vfo = on != null && on.number == 0 ? on : null;
            return false;
        }
        try {
            synchronized (tunes) { if (tunes.size() > 8) tunes.clear(); tunes.addLast(new Object[] { ch, fromStore }); }
            if (ch.isDigital()) {
                int id = !fromStore && ch.mode > 0 ? ch.mode : localId();          // VFO may transmit under another DMR ID
                engine.setDigital(ch.rxFreq, ch.txFreq, id, ch.groups, ch.txContact, ch.contactType, ch.power, ch.cc, ch.inSlot, ch.outSlot, 8, 4);
                engine.setInterrupt(ch.interrupt == 1);
            } else {
                int band = ch.rxFreq < 300_000_000 ? 1 : ch.band;      // VHF must be band=1 (band=0 deafens the RX)
                engine.setAnalog(ch.rxFreq, ch.txFreq, band, ch.power, hardwareSq(ch), ch.rxType, ch.rxSubCode, ch.txType, ch.txSubCode, 8, 2);
                if (profile.globalSquelch) engine.setSquelch(hardwareSq(ch));   // this module's squelch follows 0x30 (as QuickChat sends it)
            }
            finishRecording();
            ChannelStore.Channel was = current;
            boolean moved = was == null || was.number != ch.number || was.rxFreq != ch.rxFreq || was.isDigital() != ch.isDigital();
            if (moved && monitorOn) {                                  // the module leaves monitor mode on a channel change: so does the button
                monitorOn = false;
                try { engine.setMonitor(false); } catch (IOException e) { log("monitor: " + e); }
                log("MON off: the channel changed");
            }
            current = ch; if (fromStore) store.setActive(ch.number);
            softSq.configure(softSqFor(ch), ch.softSqLevel, ch.rxType, ch.rxSubCode);
            softSq.onRetune();
            squelchOpen = !softSq.isEnabled();                     // with Soft SQ on, stay muted until the detector opens (no burst of static after a retune)
            ui.post(() -> { for (Listener l : listeners) l.onChannel(ch); });
            if (fromStore && voiceOn() && !scanner.isScanning()) sayChannel(channelWords(ch));   // while scanning only a stop is announced (see the scanner status)
            pushModes();
            describeLocation(ch);
            updateNotification();
            return true;
        } catch (IOException e) { log("select: " + e); return false; }
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
            if (applyChannelNow(v, false)) log("VFO " + v.freqText(v.rxFreq) + "/" + v.freqText(v.txFreq) + (v.isDigital() ? " DMR cc" + v.cc + " TG " + v.txContact : " FM"));
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
        if (v.rxFreq > 174_000_000 && v.rxFreq < 400_000_000) { v.rxFreq = delta > 0 ? 400_000_000 : 174_000_000; v.txFreq = v.rxFreq; }   // jump the gap the radio cannot tune
        if (!ChannelStore.inBand(v.rxFreq) || !ChannelStore.inBand(v.txFreq)) return;                                                     // at an end, or a repeater offset would leave the band
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
        if (!profile.verified || ProfileRegistry.transmitBlocked()) return true;   // an untested profile never transmits; an advisory can switch it off (the Xplore 1 keys through a GPIO line)
        ChannelStore.Channel ch = current;
        if (ch == null) return true;
        SatState ss = satState;
        if (ss != null && ss.listenOnly && vfo != null && ss.name.equals(vfo.name)) return true;     // a satellite downlink (ISS SSTV)
        return ChannelStore.receiveOnly(ch.txFreq);      // NOAA weather and marine channels are receive-only
    }

    /** The browser's microphone for the next key-down (SignalDeck Web talk); read once by {@link #ptt}. */
    private volatile AudioBackend.TxFeed webFeedNext;
    /** Key or unkey with a browser's microphone as the audio (SignalDeck Web). */
    public void pttFromWeb(boolean down, AudioBackend.TxFeed feed) { if (down) webFeedNext = feed; ptt(down); }

    public void ptt(final boolean down) {
        worker.execute(() -> {
            try {
                if (down) {
                    final boolean fromWheel = wheelPtt, fromCall = callPtt; wheelPtt = false; callPtt = false;      // read once, whatever happens next
                    final AudioBackend.TxFeed webFeed = webFeedNext; webFeedNext = null;
                    if (!isReady()) { log("PTT ignored: radio not ready"); return; }
                    if (!profile.verified) { log("PTT blocked: untested profile"); history("warn", "⛔ Transmit is off on this phone until its profile has been tested"); return; }
                    if (txInhibited()) { log("PTT blocked: receive-only channel"); history("warn", "⛔ TX blocked on a receive-only channel"); return; }
                    if (pttDown) return;
                    pttDown = true; refreshControls();
                    txChannel = current; txInCar = inCar; txCharging = charging(); txDropNoted = false; txStartedAt = System.currentTimeMillis();
                    idTimerOnKey();
                    if (audio != null) audio.stopRx();              // never play the RX stream while the mic is live (feedback)
                    boolean carMic = webFeed == null && (fromCall || (inCar && carMic() && !fromWheel && startBluetoothMic()));   // a talk call: Telecom has opened the car's link   // not for the wheel's Next: the hands-free link turns the wheel into call controls and the stop press never arrives   // in the car: its microphone, through the hands-free link
                    if (audio != null) audio.setTxSource(carMic ? android.media.MediaRecorder.AudioSource.VOICE_COMMUNICATION : android.media.MediaRecorder.AudioSource.MIC);
                    if (audio != null) audio.setTxFeed(webFeed);                     // SignalDeck Web: the browser's microphone instead of the phone's
                    int vi = voxStop();
                    if ((fromWheel || fromCall) && vi > 0 && vi < VOX_MS.length && audio != null) {          // stop when the talking stops
                        final com.macdmr.radio.ham.VoxStop v = new com.macdmr.radio.ham.VoxStop(VOX_MS[vi], System.currentTimeMillis()); vox = v;
                        audio.setTxLevel(pk -> { if (vox == v && v.level(pk, System.currentTimeMillis())) { vox = null; log("stopped: quiet for " + VOX_NAMES[vi]); ptt(false); } });
                    } else if (audio != null) { vox = null; audio.setTxLevel(null); }
                    if (carMic) log("TX with the car microphone"); else if (fromWheel && inCar && carMic()) log("TX from the wheel: phone microphone (keeps the wheel's buttons working)");
                    engine.ptt(true);
                    if (audio != null) log(audio.startTx());
                    ui.removeCallbacks(txWatchdog); ui.postDelayed(txWatchdog, 28000);
                } else {
                    if (!pttDown) return;
                    pttDown = false; refreshControls();
                    wheel.stopped(); vox = null; if (audio != null) audio.setTxLevel(null);
                    if (com.macdmr.radio.car.RadioCallService.active()) ui.post(com.macdmr.radio.car.RadioCallService::end);   // the talk call ends with the transmission
                    txEndedAt = System.currentTimeMillis();
                    ui.removeCallbacks(txWatchdog);
                    try {
                        if (audio != null) audio.stopTx();
                        stopBluetoothMic();
                        short[] roger = rogerPcm(rogerStyle());
                        if (roger != null && audio != null) audio.playPcm(roger);    // still keyed: the tone goes out before the carrier drops
                        ChannelStore.Channel tc = current;
                        short[] id = tc != null && !tc.isDigital() && amateurBand(tc.txFreq) && packet != null && System.currentTimeMillis() - txStartedAt < 25_000 ? packet.cwIdIfDue(System.currentTimeMillis()) : null;
                        if (id != null && audio != null) { log("Morse ID after the transmission"); audio.playPcm(id); history("pkt", "\uD83D\uDD24 Morse ID " + packet.callsign()); }   // the station identification every ten minutes
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

    public void history(String kind, String text) {
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

    /** First-run check: bytes the receive audio path has delivered, and a raw copy of the next few seconds (UART PCM phones). */
    private volatile long rxPcmBytes;
    private volatile ClipRecorder clip; private volatile boolean clipOnlyHeard;
    /** Record the received audio into a WAV clip (null stops); {@code onlyHeard}: only while something is being heard. */
    public void recordClip(ClipRecorder c, boolean onlyHeard) { ClipRecorder old = clip; clipOnlyHeard = onlyHeard; clip = c; if (old != null && old != c) old.finish(); }

    public String audioStats() { AudioBackend a = audio; return a instanceof UartPcmAudio ? ((UartPcmAudio) a).frameStats() : ""; }
    public byte[] rxAudioHead() { AudioBackend a = audio; return a instanceof UartPcmAudio ? ((UartPcmAudio) a).head() : null; }
    public long rxAudioBytes() { AudioBackend a = audio; return a instanceof UartPcmAudio ? ((UartPcmAudio) a).rxBytes() : rxPcmBytes; }
    public String captureRxAudio(java.io.File f, int ms) {
        AudioBackend a = audio;
        if (a instanceof UartPcmAudio) return ((UartPcmAudio) a).capture(f, ms);
        long before = rxPcmBytes;
        try { Thread.sleep(ms); } catch (InterruptedException ignored) { }
        return (rxPcmBytes - before) + " bytes in " + ms + " ms from the vendor audio service (not saved)";
    }

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
        if (logHeard()) { RadioIdStore.Record rr = radioId != null ? radioId.lookup(caller) : null; ChannelStore.Channel lc = current; if (rr != null && rr.callsign != null && !rr.callsign.isEmpty()) try { logbook().heard(rr.callsign, lc != null ? lc.rxFreq : 0, "DMR", rr.first, t + ", DMR ID " + caller); enrichCall(rr.callsign, null); } catch (Throwable x) { log("logbook: " + x); } }
        ui.post(() -> { for (Listener l : listeners) l.onCaller((who.isEmpty() ? "ID " + caller : who + "  " + caller) + "  " + t); });
        if (voiceOn() && !who.isEmpty()) say(who.split(" ")[0]);
    }
    @Override public void ack(int cmd, boolean ok) {
        if (!ok) log(String.format(Locale.US, "MCU rejected 0x%02X", cmd));
        if (cmd != RadioEngine.CMD_SET_ANALOG && cmd != RadioEngine.CMD_SET_DIGITAL) return;
        Object[] t; synchronized (tunes) { t = tunes.pollFirst(); }
        if (t == null) return;
        final ChannelStore.Channel ch = (ChannelStore.Channel) t[0];
        if (ok) { if (ch.isDigital() == (cmd == RadioEngine.CMD_SET_DIGITAL)) confirmed = ch; return; }
        // The radio refused the channel and kept its previous settings: show the truth, not the channel that was asked for.
        final ChannelStore.Channel was = confirmed;
        worker.execute(() -> {
            if (current != ch) return;                                      // something else was tuned since
            String why = ch.isDigital() && ch.txContact <= 0 ? " (a DMR channel needs a call number)" : "";
            history("warn", "⚠ The radio refused " + ch.name + " (" + ch.freqText(ch.rxFreq) + " MHz)" + why
                    + (was != null && was != ch ? "; it is still on " + was.name + ", " + was.freqText(was.rxFreq) + " MHz" : ""));
            if (was == null || was == ch) return;
            current = was;
            vfo = was.number == 0 ? was : null;
            if (was.number > 0) store.setActive(was.number);
            ui.post(() -> { for (Listener l : listeners) l.onChannel(was); });
            pushModes(); updateNotification();
        });
    }
    /** Channel writes waiting for the module's answer (oldest first) and the last one it accepted. */
    private final java.util.ArrayDeque<Object[]> tunes = new java.util.ArrayDeque<>();
    private volatile ChannelStore.Channel confirmed;
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
        b.setContentTitle(ch != null ? "Ch " + ch.number + " · " + ch.name : "SignalDeck").setContentText(text)
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
    // ---- the wheel's Next as a talk key (hold, or double-press) ----
    public static final String[] NEXT_TALK_NAMES = { "Off", "Hold", "Double-press" };
    public int nextTalkMode() {
        android.content.SharedPreferences p = getSharedPreferences("radio", MODE_PRIVATE);
        return p.contains("nextTalk") ? p.getInt("nextTalk", 0) : !p.contains("holdNextTalk") ? com.macdmr.radio.ham.WheelNext.DOUBLE      // default: double-press (only presses, works with every car)
                : p.getBoolean("holdNextTalk", false) ? com.macdmr.radio.ham.WheelNext.HOLD : 0;   // the first version was a hold on/off switch
    }
    public void setNextTalkMode(int m) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("nextTalk", m).apply(); wheel.setMode(m); }
    public boolean holdNextTalk() { return nextTalkMode() != 0; }
    private volatile long lastWheelKeyAt; private int wheelKeysLogged;
    /** The transmission in progress was started by the wheel's Next (it then uses the phone microphone). */
    private volatile boolean wheelPtt;
    /** The transmission rides a talk "call" (car microphone through Telecom; the car's hang-up stops it). */
    private volatile boolean callPtt, talkCallPending;

    // wheel microphone: 0 phone, 1 car through a talk call; stop on silence: 0 off, else the quiet gap in ms
    public static final String[] WHEEL_MIC_NAMES = { "Phone", "Car (as a call)" };
    public static final int[] VOX_MS = { 0, 1500, 2500, 4000 };
    public static final String[] VOX_NAMES = { "Off", "1.5 s", "2.5 s", "4 s" };
    public int wheelMic() { return getSharedPreferences("radio", MODE_PRIVATE).getInt("wheelMic", 1); }
    public void setWheelMic(int m) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("wheelMic", m).apply(); }
    public int voxStop() { return getSharedPreferences("radio", MODE_PRIVATE).getInt("voxStop", 1); }   // default 1.5 s
    public void setVoxStop(int i) { getSharedPreferences("radio", MODE_PRIVATE).edit().putInt("voxStop", i).apply(); }
    private final Runnable talkCallTimeout = () -> { if (talkCallPending) { talkCallPending = false; log("talk call: no car audio route in 4 s, using the phone microphone"); history("car", "\u26A0\uFE0F The car did not open its microphone for the talk call: this transmission uses the phone microphone"); com.macdmr.radio.car.RadioCallService.end(); wheelPtt = true; ptt(true); } };
    /** A steering-wheel start: with the car microphone as a call when set, else the phone microphone. */
    private void wheelTalkStart() {
        if (carMic() && wheelMic() == 1) {
            String e = com.macdmr.radio.car.RadioCallService.start(this);
            if (e == null) { talkCallPending = true; ui.removeCallbacks(talkCallTimeout); ui.postDelayed(talkCallTimeout, 4000); log("talk call placed"); return; }
            log("talk call: " + e + "; phone microphone");
        }
        wheelPtt = true; ptt(true);
    }
    /** Telecom opened the car's audio route for the talk call: key the radio with the car's microphone. */
    public void talkCallReady(boolean bluetooth) {
        if (!talkCallPending) return;
        talkCallPending = false; ui.removeCallbacks(talkCallTimeout);
        log("talk call active, route " + (bluetooth ? "car (Bluetooth)" : "not Bluetooth"));
        if (bluetooth) callPtt = true; else wheelPtt = true;
        ptt(true);
    }
    public void talkCallFailed() { if (talkCallPending) { ui.removeCallbacks(talkCallTimeout); talkCallTimeout.run(); } }
    /** Hang-up or End in the car: stop transmitting. */
    public void talkCallHungUp() { talkCallPending = false; history("car", "\uD83D\uDCDE Hung up in the car: transmission stopped"); if (pttDown) ptt(false); }
    private volatile com.macdmr.radio.ham.VoxStop vox;
    private final com.macdmr.radio.ham.WheelNext wheel = new com.macdmr.radio.ham.WheelNext(new com.macdmr.radio.ham.WheelNext.Out() {
        @Override public void talk(boolean on) {
            if (on) { if (inCar && !pttDown) wheelTalkStart(); }
            else { if (talkCallPending) { talkCallPending = false; com.macdmr.radio.car.RadioCallService.end(); } if (pttDown) ptt(false); }
        }
        @Override public void step() { stepChannel(1); }
        @Override public void schedule(Runnable r, long ms) { ui.postDelayed(r, ms); }
        @Override public void cancel(Runnable r) { ui.removeCallbacks(r); }
        @Override public void note(String what) { wheelLog("-> " + what); }
    });
    private boolean wheelModeSet;
    /** A KEYCODE_MEDIA_NEXT event from the car, for the talk-key modes. */
    public void wheelNext(android.view.KeyEvent ev) {
        if (!wheelModeSet) { wheelModeSet = true; wheel.setMode(nextTalkMode()); }
        long now = android.os.SystemClock.uptimeMillis();
        if (ev.getAction() == android.view.KeyEvent.ACTION_DOWN) wheel.down(ev.getRepeatCount(), now); else if (ev.getAction() == android.view.KeyEvent.ACTION_UP) wheel.up(now);
    }
    /** Every wheel event and decision, with milliseconds, in files/wheel.log (last 400 lines): how this car behaves. */
    private synchronized void wheelLog(String line) {
        try {
            java.io.File f = new java.io.File(getFilesDir(), "wheel.log");
            String stamp = new java.text.SimpleDateFormat("MM-dd HH:mm:ss.SSS", Locale.US).format(new java.util.Date());
            try (java.io.FileWriter w = new java.io.FileWriter(f, true)) { w.write(stamp + "  " + line + "\n"); }
            if (f.length() > 40_000) {
                java.util.List<String> l = java.nio.file.Files.readAllLines(f.toPath());
                java.nio.file.Files.write(f.toPath(), l.subList(Math.max(0, l.size() - 400), l.size()));
            }
        } catch (Throwable ignored) { }
    }
    /** The first few raw wheel events of each drive go to the history, so what this car sends can be seen afterwards. */
    public void wheelKeySeen(android.view.KeyEvent ev) {
        lastWheelKeyAt = System.currentTimeMillis();
        String k = android.view.KeyEvent.keyCodeToString(ev.getKeyCode()).replace("KEYCODE_", "") + (ev.getAction() == android.view.KeyEvent.ACTION_DOWN ? " down" : " up") + " repeat " + ev.getRepeatCount() + " (event time " + ev.getEventTime() + ", now " + android.os.SystemClock.uptimeMillis() + ")";
        log("wheel key " + k); wheelLog(k);
        if (holdNextTalk() && wheelKeysLogged < 6) {
            wheelKeysLogged++;
            carEvent("\uD83C\uDF9B Wheel: " + android.view.KeyEvent.keyCodeToString(ev.getKeyCode()).replace("KEYCODE_", "") + (ev.getAction() == android.view.KeyEvent.ACTION_DOWN ? " pressed" + (ev.getRepeatCount() > 0 ? " (repeat " + ev.getRepeatCount() + ")" : "") : " released"));
        }
    }
    /** Android Auto sent Next as a command (no button events): holding cannot be told from tapping in this car. */
    public void wheelSkipCommand() {
        if (holdNextTalk() && inCar && System.currentTimeMillis() - lastWheelKeyAt > 2000)
            carEvent("\u26A0\uFE0F Android Auto sends the wheel's Next as a command, not a button press: hold Next to talk cannot work in this car");
    }

    /** Steering-wheel play/pause (a media button) while in the car with the setting on: start or stop talking. */
    public boolean wheelButton() {
        if (!inCar || !wheelTalk()) return false;
        if (pttHeld() || talkCallPending) { if (talkCallPending) { talkCallPending = false; com.macdmr.radio.car.RadioCallService.end(); } ptt(false); } else wheelTalkStart();
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

    // ---- the transmission knocking out the USB cable ---------------------------------------------------
    // Measured 2026-10-19 in the owner's car: on one 2 m channel (TX 144.770 MHz, high power) every transmission reset
    // the phone's USB port about 1.5 s after key-up (USB port change, charging stopped), so a wired Android Auto dropped
    // until the carrier ended; 146.370 MHz on the same band did not. The cable picks up the RF (the antenna is at the
    // far end of the phone), and only some frequencies couple. Software cannot stop it; the user is told what helps.
    private volatile ChannelStore.Channel txChannel; private volatile boolean txInCar, txCharging, txDropNoted; private volatile long txEndedAt;
    private android.content.BroadcastReceiver powerOff;
    private boolean txJustNow() { return pttDown || System.currentTimeMillis() - txEndedAt < 3000; }
    private boolean charging() {
        try { android.content.Intent b = registerReceiver(null, new android.content.IntentFilter(android.content.Intent.ACTION_BATTERY_CHANGED)); return b != null && b.getIntExtra(android.os.BatteryManager.EXTRA_PLUGGED, 0) != 0; }
        catch (Throwable t) { return false; }
    }
    private void watchUsbDuringTx() {
        powerOff = new android.content.BroadcastReceiver() {
            @Override public void onReceive(android.content.Context c, android.content.Intent i) { if (txCharging && txJustNow()) usbDropDuringTx(false); }
        };
        try { registerReceiver(powerOff, new android.content.IntentFilter(android.content.Intent.ACTION_POWER_DISCONNECTED)); } catch (Throwable t) { log("usb watch: " + t); }
    }
    /** Android Auto dropped (car) or charging stopped (power) during or right after a transmission: once per transmission. */
    private void usbDropDuringTx(boolean car) {
        if (txDropNoted) return;
        ChannelStore.Channel ch = txChannel;
        if (ch == null || (car && !txInCar)) return;
        txDropNoted = true;
        String freq = String.format(java.util.Locale.US, "%.3f MHz", ch.txFreq / 1e6);
        String what = car || txInCar ? "Android Auto dropped" : "The USB cable dropped (charging stopped)";
        carEvent("⚠️ " + what + " while transmitting on " + ch.name + " (" + freq + "): the transmission is disturbing the USB cable");
        com.macdmr.radio.car.AutoTrust.notifyUsbDrop(this, ch.name, freq, car || txInCar);
    }

    // ---- Android Auto connected but never loaded the radio ----------------------------------------------
    // Measured 2026-10-19: on every working connection Android Auto binds the media service within ~7 s of connecting
    // (12 of 12). Once, with Unknown sources on, it never did: the radio was missing from the car's app list and its card
    // opened the phone app, until the cable was unplugged and plugged in again. Nothing in the app can make Android Auto
    // load it, so the user is told how to recover.
    private volatile long carMediaBoundAt;
    public void carMediaBound() { carMediaBoundAt = System.currentTimeMillis(); try { androidx.core.app.NotificationManagerCompat.from(this).cancel("notloaded", 10); } catch (Throwable ignored) { } }
    private final Runnable carBindCheck = () -> {
        if (!inCar || System.currentTimeMillis() - carMediaBoundAt < 60_000) return;
        com.macdmr.radio.car.AutoTrust.State st = com.macdmr.radio.car.AutoTrust.last();
        if (st == com.macdmr.radio.car.AutoTrust.State.OFF || st == com.macdmr.radio.car.AutoTrust.State.LOCKED) return;   // that alert already explains it
        carEvent("⚠️ Android Auto did not load SignalDeck on this connection: unplug the cable and plug it in again");
        com.macdmr.radio.car.AutoTrust.notifyNotLoaded(this);
    };

    private void watchCar() {
        try {
            new androidx.car.app.connection.CarConnection(this).getType().observeForever(t -> {
                boolean car = t != null && t == androidx.car.app.connection.CarConnection.CONNECTION_TYPE_PROJECTION;
                if (car == inCar) return;
                inCar = car; log(car ? "Android Auto connected" : "Android Auto disconnected"); if (car) wheelKeysLogged = 0;
                if (!car && txJustNow()) usbDropDuringTx(true);
                carEvent(car ? "🚗 Android Auto connected (" + (carControlsScreen() ? "Radio controls screen" : "media app") + ")" : "🚗 Android Auto disconnected");
                carCoverage(car);
                ui.removeCallbacks(carBindCheck); if (car) ui.postDelayed(carBindCheck, 30_000);
                if (car) new Thread(() -> {   // a sideloaded app stays off the car's app list unless Unknown sources is on
                    com.macdmr.radio.car.AutoTrust.State st = com.macdmr.radio.car.AutoTrust.check(this);
                    if (st == com.macdmr.radio.car.AutoTrust.State.OFF || st == com.macdmr.radio.car.AutoTrust.State.LOCKED) {
                        ui.post(() -> carEvent("⚠️ Android Auto is hiding SignalDeck: Unknown sources is off (Device page shows how to fix it)"));
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
    public boolean hearing() { return injecting || (softSq != null && softSq.isEnabled() ? squelchOpen : receiving && rxCounts); }

    // ---- bench: play a WAV into the receive path as if the radio heard it (DiagReceiver, adb only) ----
    private volatile boolean injecting;
    public void injectWav(final java.io.File f) {
        new Thread(() -> {
            try {
                byte[] all = java.nio.file.Files.readAllBytes(f.toPath());
                java.nio.ByteBuffer bb = java.nio.ByteBuffer.wrap(all).order(java.nio.ByteOrder.LITTLE_ENDIAN);
                int ch = 1, rate = 8000, pos = 12, dataAt = -1, dataLen = 0;
                while (pos + 8 <= all.length) {
                    String id = new String(all, pos, 4, java.nio.charset.StandardCharsets.US_ASCII); int len = bb.getInt(pos + 4);
                    if (id.equals("fmt ")) { ch = bb.getShort(pos + 10); rate = bb.getInt(pos + 12); }
                    if (id.equals("data")) { dataAt = pos + 8; dataLen = Math.min(len, all.length - dataAt); break; }
                    pos += 8 + len + (len & 1);
                }
                if (dataAt < 0) { log("inject: no data chunk in " + f); return; }
                int frames = dataLen / (2 * ch);
                int outN = (int) ((long) frames * 8000 / rate);
                log("inject " + f.getName() + ": " + rate + " Hz, " + ch + " ch, " + (outN / 8) + " ms");
                injecting = true;
                byte[] blk = new byte[2048];   // 512 stereo samples = 64 ms
                long t0 = System.currentTimeMillis(); int k = 0;
                for (int o = 0; o < outN; ) {
                    int m = 0;
                    for (; m < 512 && o < outN; m++, o++) {
                        int src = (int) ((long) o * rate / 8000); short v = bb.getShort(dataAt + src * 2 * ch);
                        blk[m * 4] = blk[m * 4 + 2] = (byte) v; blk[m * 4 + 1] = blk[m * 4 + 3] = (byte) (v >> 8);
                    }
                    onRxPcm(blk, m * 4);
                    k += m; long due = t0 + k / 8; long now = System.currentTimeMillis(); if (due > now) Thread.sleep(due - now);
                }
            } catch (Throwable t) { log("inject: " + t); }
            finally { injecting = false; byte[] quiet = new byte[2048]; for (int r = 0; r < 4; r++) onRxPcm(quiet, quiet.length); log("inject done"); }
        }, "diag-inject").start();
    }
}
