package com.macdmr.radio;

import android.content.Context;
import android.content.SharedPreferences;
import android.location.Location;
import android.util.Log;

import com.macdmr.radio.pkt.AFSKDecoder;
import com.macdmr.radio.pkt.AprsIsClient;
import com.macdmr.radio.pkt.AFSKGenerator;
import com.macdmr.radio.pkt.APRSPacketDecoder;
import com.macdmr.radio.pkt.Ax25;
import com.macdmr.radio.pkt.DTMFDecoder;
import com.macdmr.radio.pkt.KissTnc;
import com.macdmr.radio.pkt.PacketStore;
import com.macdmr.radio.pkt.SAMEDecoder;
import com.macdmr.radio.pkt.SSTVEncoder;
import com.macdmr.radio.pkt.SSTVMode;
import com.macdmr.radio.pkt.SSTVReceiver;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * Packet modes on the analog FM path: APRS (Bell 202 AFSK decode of everything the squelch passes, messages,
 * position beacons, auto-ack, fill-in digipeater, KISS TNC for APRSdroid/YAAC), DTMF decode + send, and NOAA
 * SAME weather alerts. Audio in is the 8 kHz mono RX stream; audio out goes through the host's one-shot
 * transmitter, which keys the radio, plays the PCM and releases.
 *
 * TX timing (measured on this radio): the TX path needs ~1.5 s to settle after key-up before AFSK decodes,
 * so every frame is led by a 1.6 s steady 1200 Hz tone and sent twice.
 */
public final class PacketEngine {
    public interface Host {
        Context context();
        boolean analogRx();                      // current channel is FM
        int rxFreqHz();
        int channelNumber(); String channelName();
        boolean txBusy();
        /** Key, play the 8 kHz mono PCM, release; {@code onDone} runs after release (on the service worker). */
        void transmitPcm(short[] pcm, String label, Runnable onDone);
        Location location();
        void event(String line);                 // a history line / toast on the intercom
        void notifyUser(String title, String text, boolean alert);
        int rssiDbm();                           // last signal reading, -999 = none
        /** Keep GPS updates coming to {@link #onLocation} (SmartBeaconing) or stop them. */
        void wantLocation(boolean on);
        /** A decoded DTMF sequence (the remote control looks for its PIN). */
        void dtmfSequence(String digits);
        /** A station identified itself (APRS source, Morse ID): for the logbook. */
        void logHeard(String call, String mode, String note);
        /** The station identified (a Morse ID went out): restarts the ten-minute ID timer. */
        void identified();
    }

    public static final int TX_LEAD_MS = 1600, TX_REPS = 2, TX_GAP_MS = 250;
    /** Packet lead-in choices (APRS settings, for testing): the measured 1.6 s by default. SSTV and DTMF keep TX_LEAD_MS. */
    public static final int[] LEAD_CHOICES = { 1600, 1000, 500, 0 };
    public static final String[] LEAD_NAMES = { "1.6 s (default)", "1.0 s", "0.5 s", "None" };
    /** Power on the frequencies the app tunes itself (APRS monitoring, ISS, SSTV 144.500): 1 high (default), 0 low. */
    public int dataTxPower() { return prefs.getInt("txPower", 1) == 0 ? 0 : 1; }
    /** What the lead-in is made of: 0 steady 1200 Hz tone, 1 HDLC flags (the standard TXDELAY), 2 silence. */
    public static final String[] LEAD_KINDS = { "Tone", "Flags (standard)", "Silence" };
    /** Flags by default: bench 2026-10-20 (252 single-copy packets over both apps) found the three kinds equal at 1.6 s, silence
     *  weakest at short leads; flags are the standard AX.25 TXDELAY. */
    public int packetLeadKind() { int k = prefs.getInt("txLeadKind", 1); return k >= 0 && k < LEAD_KINDS.length ? k : 1; }

    /**
     * The audio of one packet transmission: the settling lead-in, then each frame (with FCS) and a gap. A flags lead-in
     * is one continuous run of flags into the first frame (a long TXDELAY); tone and silence are separate samples.
     */
    private short[] packetAudio(java.util.List<byte[]> framesWithFcs, int leadMs, int kind) {
        int gap = SR * TX_GAP_MS / 1000;
        int lead = kind == 1 ? 0 : SR * leadMs / 1000;
        int leadFlags = kind == 1 ? Math.round(leadMs * 1200f / 8000f) : 0;      // 1200 bit/s, 8 bits per flag
        java.util.List<short[]> parts = new java.util.ArrayList<>(); int total = lead;
        for (int i = 0; i < framesWithFcs.size(); i++) {
            short[] a = AFSKGenerator.generateAFSKWithNRZI(framesWithFcs.get(i), 50 + (i == 0 ? leadFlags : 0));
            parts.add(a); total += a.length + gap;
        }
        short[] src = new short[total];
        if (kind == 0) for (int i = 0; i < lead; i++) src[i] = (short) (30000 * Math.sin(2.0 * Math.PI * 1200 * i / SR));
        int p = lead; for (short[] a : parts) { System.arraycopy(a, 0, src, p, a.length); p += a.length + gap; }
        return src;
    }

    /** Bench (DIAG leadtest): one status packet with a given lead-in, for comparing tone / flags / silence on the air. */
    public String diagLeadTest(int kind, int ms, int reps, String tag) {
        if (!host.analogRx()) return "needs an analog channel";
        if (!callsignSet()) return "no callsign";
        byte[] frame = Ax25.buildUiFrame("APZDMR", 0, callsign(), ssid(), new String[0], (">lead " + LEAD_KINDS[kind].split(" ")[0].toLowerCase(Locale.US) + " " + ms + " " + tag).getBytes(java.nio.charset.StandardCharsets.US_ASCII));
        java.util.List<byte[]> l = new java.util.ArrayList<>(); for (int r = 0; r < Math.max(1, reps); r++) l.add(frame);
        host.transmitPcm(packetAudio(l, ms, kind), "lead test " + kind + "/" + ms + " " + tag, null);
        return null;
    }

    public int packetLeadMs() { return Math.max(0, Math.min(3000, prefs.getInt("txLeadMs", TX_LEAD_MS))); }
    public static final int APRS_FREQ_HZ = 144_390_000;
    private static final String TAG = "PacketEngine";
    private static final int SR = 8000, WINDOW = SR * 2, OVERLAP = SR;

    private final Host host;
    private final SharedPreferences prefs;
    private final PacketStore store;
    private final ExecutorService decoder = Executors.newSingleThreadExecutor(r -> { Thread t = new Thread(r, "aprs-decode"); t.setDaemon(true); return t; });
    private final KissTnc kiss = new KissTnc();
    private final LinkedBlockingQueue<byte[]> kissTxQueue = new LinkedBlockingQueue<>(32);
    private volatile boolean monitor;                      // APRS monitoring mode (parked on 144.390 by the service)
    private final short[] window = new short[WINDOW];
    private int fill;
    private short[] overlapTail;
    private long lastWindowMs;
    private final LinkedList<Object[]> recent = new LinkedList<>();
    private final HashMap<String, Long> digiSeen = new HashMap<>(), ackSent = new HashMap<>();
    private final Random rnd = new Random();
    private DTMFDecoder dtmf;
    private SAMEDecoder same;
    private volatile long lastDtmfDigitMs;
    // ---- SSTV ----
    public interface SstvListener { void onSstv(String status, android.graphics.Bitmap live, int lines, int total, boolean complete); }
    private volatile boolean sstvRx;
    private SSTVReceiver sstv;
    private volatile SstvListener sstvListener;
    private volatile String sstvStatus = "idle";
    private volatile android.graphics.Bitmap sstvLast;
    private byte[] sstvBytes = new byte[8192];
    public static final int SSTV_FREQ_HZ = 144_500_000;

    public boolean sstvRx() { return sstvRx; }
    public String sstvStatus() { return sstvStatus; }
    public android.graphics.Bitmap sstvLast() { return sstvLast; }
    public void setSstvListener(SstvListener l) { sstvListener = l; }
    private void sstvPost(String st, android.graphics.Bitmap b, int lines, int total, boolean done) {
        sstvStatus = st; if (b != null) sstvLast = b;
        SstvListener l = sstvListener; if (l != null) new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> l.onSstv(st, b, lines, total, done));
    }

    // ---- continuous Robot 36 (MMSSTV-style: no VIS needed, partial pictures, coasts through fades) ----
    private com.macdmr.radio.pkt.SstvContinuous sstvCont;
    private volatile boolean sstvContinuous;
    private short[] contBuf = new short[4096];
    private long contLastLive;
    /** The SSTV decoder: false = any mode, started by the VIS header (the existing receiver); true = continuous Robot 36. */
    public boolean sstvContinuousMode() { return prefs.getBoolean("sstvContinuous", false); }
    public void setSstvContinuousMode(boolean on) { prefs.edit().putBoolean("sstvContinuous", on).apply(); if (sstvRx) setSstvRx(true); }
    /** Continuous Robot 36 for this session regardless of the setting (ISS SSTV events are Robot 36). */
    private volatile boolean sstvForceContinuous;
    public void setSstvForceContinuous(boolean on) { sstvForceContinuous = on; }
    public boolean sstvUsingContinuous() { return sstvContinuous; }

    private com.macdmr.radio.pkt.SstvContinuous.Listener contListener() {
        return new com.macdmr.radio.pkt.SstvContinuous.Listener() {
            @Override public void onLive(int[] argb, int w, int h, boolean locked, int lines) {
                long now = System.currentTimeMillis();
                if (!locked && now - contLastLive < 450) return;           // static: a few frames a second is enough
                contLastLive = now;
                android.graphics.Bitmap b = android.graphics.Bitmap.createBitmap(argb, w, h, android.graphics.Bitmap.Config.ARGB_8888);
                sstvPost(locked ? "receiving Robot 36, line " + lines + " of " + h : "listening (continuous Robot 36)", b, locked ? lines : 0, locked ? h : 0, false);
            }
            @Override public void onPicture(int[] argb, int w, int h, int lines, boolean complete) {
                android.graphics.Bitmap b = android.graphics.Bitmap.createBitmap(argb, w, h, android.graphics.Bitmap.Config.ARGB_8888);
                String name = saveSstv(b, complete);
                host.event("\uD83D\uDCFA SSTV picture received (Robot 36" + (complete ? "" : ", partial: " + lines + " of " + h + " lines") + ") \u2192 Download/DMR/SSTV");
                host.notifyUser("SSTV picture received", "Robot 36" + (complete ? "" : " (partial)"), false);
                sstvPost("picture received" + (complete ? "" : " (partial, " + lines + " lines)") + (name != null ? "" : ", could not save"), b, lines, h, true);
            }
        };
    }
    private String saveSstv(android.graphics.Bitmap b, boolean complete) {
        try {
            java.io.File dir = new java.io.File(android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DOWNLOADS), "DMR/SSTV"); dir.mkdirs();
            String name = "SSTV_Robot36_" + new java.text.SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new java.util.Date()) + (complete ? "" : "_partial") + ".png";
            try (java.io.FileOutputStream o = new java.io.FileOutputStream(new java.io.File(dir, name))) { b.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, o); }
            return name;
        } catch (Throwable t) { Log.w(TAG, "sstv save: " + t); return null; }
    }

    public void setSstvRx(boolean on) {
        sstvRx = on;
        if (!on) { com.macdmr.radio.pkt.SstvContinuous c = sstvCont; if (c != null) c.flush(); sstvCont = null; sstvContinuous = false; sstvPost("idle", null, 0, 0, false); return; }
        sstvContinuous = sstvForceContinuous || sstvContinuousMode();
        if (sstvContinuous) { sstvCont = new com.macdmr.radio.pkt.SstvContinuous(SR, contListener()); sstvPost("listening (continuous Robot 36)", null, 0, 0, false); return; }
        if (sstv == null) {
            sstv = SSTVReceiver.getInstance(host.context());
            sstv.setVISDetectedCallback(m -> { host.event("\uD83D\uDCFA SSTV " + m.name + " detected"); sstvPost("receiving " + m.name, null, 0, m.height, false); });
            sstv.setLineDecodeCallback((lines, total, snap) -> sstvPost("receiving " + lines + "/" + total, snap, lines, total, false));
            sstv.setModeChangeCallback((o, n, k) -> sstvPost("mode changed to " + n.name, null, 0, n.height, false));
            sstv.setImageDecodeCallback((img, m) -> { host.event("\uD83D\uDCFA SSTV picture received (" + m.name + ") \u2192 Download/DMR/SSTV"); host.notifyUser("SSTV picture received", m.name, false); sstvPost("picture complete (" + m.name + ")", img, m.height, m.height, true); });
        }
        sstv.reset();
        sstvPost("listening for a VIS header", null, 0, 0, false);
    }

    /** Encode and transmit a picture (Robot 24 Color / 12 BW / 8 BW fit the 30 s limit). Returns an error or null. */
    public String sendSstv(android.graphics.Bitmap bmp, int mode) {
        if (bmp == null) return "No picture";
        if (!SSTVEncoder.isSupported(mode)) return "Unsupported mode";
        if (!host.analogRx()) return "SSTV needs an analog channel";
        new Thread(() -> {
            short[] pcm = SSTVEncoder.encode(bmp, mode);
            int lead = SR * TX_LEAD_MS / 1000;
            short[] src = new short[lead + pcm.length];
            for (int i = 0; i < lead; i++) src[i] = (short) (30000 * Math.sin(2.0 * Math.PI * 1900 * i / SR));   // leader tone while the TX path settles
            System.arraycopy(pcm, 0, src, lead, pcm.length);
            host.transmitPcm(src, "SSTV " + SSTVEncoder.name(mode), () -> host.event("\uD83D\uDCFA Sent SSTV " + SSTVEncoder.name(mode)));
        }, "sstv-encode").start();
        return null;
    }
    private volatile int lastAttnLevel;

    public PacketEngine(Host h) {
        host = h;
        prefs = h.context().getSharedPreferences("packet", Context.MODE_PRIVATE);
        store = new PacketStore(h.context());
        Thread sender = new Thread(() -> {
            while (true) {
                try {
                    byte[] f = kissTxQueue.poll(500, TimeUnit.MILLISECONDS);
                    if (f == null || !kiss.isActive()) continue;
                    int guard = 0; while (host.txBusy() && guard++ < 100) Thread.sleep(100);
                    final Object lock = new Object();
                    synchronized (lock) { txRaw(f, "KISS " + f.length + " B", TX_REPS, () -> { synchronized (lock) { lock.notifyAll(); } }); lock.wait(35000); }
                    Thread.sleep(800);
                } catch (InterruptedException e) { break; } catch (Throwable t) { Log.w(TAG, "kiss tx: " + t); }
            }
        }, "kiss-tx");
        sender.setDaemon(true); sender.start();
        Thread auto = new Thread(() -> { while (true) { try { Thread.sleep(30_000); autoTick(); } catch (InterruptedException e) { break; } catch (Throwable t) { Log.w(TAG, "auto: " + t); } } }, "aprs-auto");
        auto.setDaemon(true); auto.start();
    }

    public PacketStore store() { return store; }

    // ---- automatic beacons, telemetry, weather reports, objects, bulletins, groups ---------------
    public int autoBeacon() { return prefs.getInt("autoBeacon", 0); }        // 0 off, 1 every N minutes, 2 SmartBeaconing
    public int beaconMin() { return Math.max(1, prefs.getInt("beaconMin", 15)); }
    public boolean telemetryOn() { return prefs.getBoolean("telemetry", false); }
    public boolean weatherOn() { return prefs.getBoolean("weather", false); }
    public boolean txIgate() { return prefs.getBoolean("txIgate", false); }
    public java.util.List<String> groups() {
        java.util.List<String> out = new java.util.ArrayList<>();
        for (String g : prefs.getString("groups", "").toUpperCase(Locale.US).split(",")) { g = g.trim(); if (!g.isEmpty()) out.add(g); }
        return out;
    }
    private final com.macdmr.radio.pkt.AprsExtras.SmartBeacon smart = new com.macdmr.radio.pkt.AprsExtras.SmartBeacon();
    private volatile long lastAutoBeacon, lastTelemetry, lastWeather;
    private volatile double pressureHpa;
    private android.hardware.SensorEventListener baro;

    /** On the APRS frequency (analog, 144.390) and not handing the radio to a TNC client: our own beacons may go out. */
    public boolean onAprsFrequency() { return host.analogRx() && host.rxFreqHz() == APRS_FREQ_HZ && !kiss.isActive(); }

    /** Re-read the settings that need a sensor or GPS running. */
    public void applySettings() {
        updateGps();
        boolean needBaro = telemetryOn() || weatherOn();
        android.hardware.SensorManager sm = (android.hardware.SensorManager) host.context().getSystemService(Context.SENSOR_SERVICE);
        if (sm == null) return;
        if (needBaro && baro == null) {
            android.hardware.Sensor s = sm.getDefaultSensor(android.hardware.Sensor.TYPE_PRESSURE);
            if (s == null) return;
            baro = new android.hardware.SensorEventListener() {
                @Override public void onSensorChanged(android.hardware.SensorEvent e) { pressureHpa = e.values[0]; }
                @Override public void onAccuracyChanged(android.hardware.Sensor x, int a) { }
            };
            sm.registerListener(baro, s, 5_000_000);
        } else if (!needBaro && baro != null) { sm.unregisterListener(baro); baro = null; }
    }
    /** Wait up to {@code ms} for one barometer reading (when the periodic listener is not running). */
    private void readPressureOnce(long ms) {
        android.hardware.SensorManager sm = (android.hardware.SensorManager) host.context().getSystemService(Context.SENSOR_SERVICE);
        android.hardware.Sensor s = sm == null ? null : sm.getDefaultSensor(android.hardware.Sensor.TYPE_PRESSURE);
        if (s == null) return;
        final java.util.concurrent.CountDownLatch got = new java.util.concurrent.CountDownLatch(1);
        android.hardware.SensorEventListener one = new android.hardware.SensorEventListener() {
            @Override public void onSensorChanged(android.hardware.SensorEvent e) { pressureHpa = e.values[0]; got.countDown(); }
            @Override public void onAccuracyChanged(android.hardware.Sensor x, int a) { }
        };
        sm.registerListener(one, s, android.hardware.SensorManager.SENSOR_DELAY_NORMAL, new android.os.Handler(android.os.Looper.getMainLooper()));
        try { got.await(ms, java.util.concurrent.TimeUnit.MILLISECONDS); } catch (InterruptedException ignored) { }
        sm.unregisterListener(one);
    }
    public boolean hasBarometer() { android.hardware.SensorManager sm = (android.hardware.SensorManager) host.context().getSystemService(Context.SENSOR_SERVICE); return sm != null && sm.getDefaultSensor(android.hardware.Sensor.TYPE_PRESSURE) != null; }

    /** GPS fixes while SmartBeaconing is on. */
    public void onLocation(Location l) {
        if (autoBeacon() != 2 || !callsignSet() || !onAprsFrequency() || host.txBusy()) return;
        double mph = l.hasSpeed() ? l.getSpeed() * 2.23694 : 0, hd = l.hasBearing() ? l.getBearing() : Double.NaN;
        if (smart.due(System.currentTimeMillis(), mph, hd)) { if (sendBeacon() == null) lastAutoBeacon = System.currentTimeMillis(); }
    }

    /** Every 30 s: timed beacon, telemetry and weather reports, when on the APRS frequency. */
    private void autoTick() {
        long now = System.currentTimeMillis();
        if (!callsignSet() || !onAprsFrequency() || host.txBusy()) return;
        if (autoBeacon() == 1 && now - lastAutoBeacon >= beaconMin() * 60_000L) { lastAutoBeacon = now; sendBeacon(); return; }
        if (telemetryOn() && now - lastTelemetry >= 30 * 60_000L) { lastTelemetry = now; sendTelemetry(); return; }
        if (weatherOn() && pressureHpa > 0 && now - lastWeather >= 30 * 60_000L) { lastWeather = now; sendWeather(); }
    }

    private int telSeq = -1;
    /** Battery, voltage, temperature, pressure and signal as APRS telemetry; the first report (and every tenth) carries the definitions. */
    public String sendTelemetry() {
        if (!callsignSet()) return "Set your callsign first (PKT \u2192 Settings)";
        if (!host.analogRx()) return "Packet needs an analog channel";
        if (pressureHpa <= 0 && hasBarometer()) { new Thread(() -> { readPressureOnce(3000); sendTelemetryNow(); }, "baro-once").start(); return null; }
        return sendTelemetryNow();
    }
    private String sendTelemetryNow() {
        android.content.Intent b = host.context().registerReceiver(null, new android.content.IntentFilter(android.content.Intent.ACTION_BATTERY_CHANGED));
        int level = b == null ? 0 : b.getIntExtra(android.os.BatteryManager.EXTRA_LEVEL, 0) * 100 / Math.max(1, b.getIntExtra(android.os.BatteryManager.EXTRA_SCALE, 100));
        double volts = b == null ? 0 : b.getIntExtra(android.os.BatteryManager.EXTRA_VOLTAGE, 0) / 1000.0, temp = b == null ? 0 : b.getIntExtra(android.os.BatteryManager.EXTRA_TEMPERATURE, 0) / 10.0;
        Location l = host.location();
        double hpa = pressureHpa > 0 ? com.macdmr.radio.pkt.AprsExtras.seaLevel(pressureHpa, l != null && l.hasAltitude() ? l.getAltitude() : 0) : 0;
        if (telSeq < 0) telSeq = prefs.getInt("telSeq", 0);
        telSeq = (telSeq + 1) % 1000; prefs.edit().putInt("telSeq", telSeq).apply();
        final String info = com.macdmr.radio.pkt.AprsExtras.telemetryInfo(telSeq, com.macdmr.radio.pkt.AprsExtras.telemetryValues(level, volts, temp, hpa, host.rssiDbm()));
        java.util.List<String> infos = new java.util.ArrayList<>(); infos.add(info);
        if (telSeq % 10 == 1) for (String def : new String[] { com.macdmr.radio.pkt.AprsExtras.PARM, com.macdmr.radio.pkt.AprsExtras.UNIT, com.macdmr.radio.pkt.AprsExtras.EQNS }) infos.add(Ax25.messageInfo(myCall(), def, 0));
        txInfos(infos, "telemetry #" + telSeq, () -> { store.log("beacon", myCall(), "APZDMR", info, null, false); host.event("\uD83D\uDCCA Telemetry sent: battery " + level + " %, " + String.format(Locale.US, "%.2f V, %.0f \u00B0C", volts, temp) + (hpa > 0 ? String.format(Locale.US, ", %.1f hPa", hpa) : "")); });
        return null;
    }

    /** A weather report with the phone's air pressure (converted to sea level) at your position. */
    public String sendWeather() {
        if (!callsignSet()) return "Set your callsign first (PKT \u2192 Settings)";
        if (!hasBarometer()) return "This phone has no barometer";
        Location l = host.location(); if (l == null) return "No position fix yet";
        if (!host.analogRx()) return "Packet needs an analog channel";
        if (pressureHpa <= 0) {                                              // not running: take one reading, then send
            new Thread(() -> { readPressureOnce(3000); if (pressureHpa > 0) sendWeather(); else host.event("\u26D4 Weather report not sent: no barometer reading"); }, "baro-once").start();
            return null;
        }
        double hpa = com.macdmr.radio.pkt.AprsExtras.seaLevel(pressureHpa, l.hasAltitude() ? l.getAltitude() : 0);
        final String info = com.macdmr.radio.pkt.AprsExtras.weatherInfo(l.getLatitude(), l.getLongitude(), hpa, "");
        txInfo(info, path(), "weather report", TX_REPS, () -> { store.log("beacon", myCall(), "APZDMR", info, null, false); host.event(String.format(Locale.US, "\u26C5 Weather report sent: %.1f hPa", hpa)); });
        return null;
    }

    /** Place (or with {@code live} false, remove) an APRS object at a position. Error text or null. */
    public String sendObject(String name, boolean live, double lat, double lon, String symbol, String comment) {
        if (!callsignSet()) return "Set your callsign first (PKT \u2192 Settings)";
        if (name == null || name.trim().isEmpty()) return "Give the object a name (up to 9 characters)";
        if (!host.analogRx()) return "Packet needs an analog channel";
        char t = symbol != null && symbol.length() >= 1 ? symbol.charAt(0) : '/', cd = symbol != null && symbol.length() >= 2 ? symbol.charAt(1) : '.';
        final String info = com.macdmr.radio.pkt.AprsExtras.objectInfo(name.trim().toUpperCase(Locale.US), live, lat, lon, t, cd, comment == null ? "" : comment.trim(), System.currentTimeMillis());
        final String nm = name.trim().toUpperCase(Locale.US);
        txInfo(info, path(), (live ? "object " : "remove object ") + nm, TX_REPS, () -> { store.log("object", myCall(), nm, info, null, false); host.event("\uD83D\uDCCC " + (live ? "Object placed: " : "Object removed: ") + nm); });
        return null;
    }

    /** A bulletin (BLN0 to BLN9) for everyone in range. */
    public String sendBulletin(int n, String text) {
        if (!callsignSet()) return "Set your callsign first (PKT \u2192 Settings)";
        if (text == null || text.trim().isEmpty()) return "Write the bulletin first";
        if (text.length() > 67) return "Bulletins are at most 67 characters";
        if (!host.analogRx()) return "Packet needs an analog channel";
        final String to = "BLN" + Math.max(0, Math.min(9, n)), tx = text.trim();
        txInfo(Ax25.messageInfo(to, tx, 0), path(), "bulletin " + to, TX_REPS, () -> { store.log("msg-tx", myCall(), to, tx, null, false); host.event("\uD83D\uDCE2 Bulletin " + to + " sent: " + tx); });
        return null;
    }

    /** Bulletins and NWS announcements heard, newest first. */
    public java.util.List<PacketStore.LogEntry> bulletins(int limit) {
        java.util.List<PacketStore.LogEntry> out = new java.util.ArrayList<>();
        for (PacketStore.LogEntry e : store.aprsLog(500)) if (e.to != null && (e.to.startsWith("BLN") || e.to.startsWith("NWS")) && !"msg-tx".equals(e.kind)) { out.add(e); if (out.size() >= limit) break; }
        return out;
    }

    // ---- keyboard text modes: RTTY and PSK31 ---------------------------------------------------------
    public static final String[] TEXT_MODES = { "Off", "RTTY 45", "PSK31" };
    public interface TextListener { void update(String text, String status); }
    private volatile int textMode;                                        // 0 off (not listening), 1 RTTY, 2 PSK31
    private int textTxMode = 2;
    private com.macdmr.radio.ham.Rtty rtty; private com.macdmr.radio.ham.Psk31 psk;
    private final StringBuilder textRx = new StringBuilder();
    private volatile TextListener textListener;
    public int textMode() { return textMode; }
    public void setTextMode(int m) {
        textMode = m; if (m > 0) textTxMode = m;
        if (m == 1) rtty = new com.macdmr.radio.ham.Rtty(this::textChar);
        if (m == 2) psk = new com.macdmr.radio.ham.Psk31(this::textChar);
        textPost();
    }
    public int textTxMode() { return textTxMode; }
    public void setTextTxMode(int m) { textTxMode = m; textPost(); }
    public void setTextListener(TextListener l) { textListener = l; textPost(); }
    public synchronized void textClear() { textRx.setLength(0); textPost(); }
    /** Everything received (and sent) in the text modes so far, for SignalDeck Web. */
    public synchronized String textReceived() { return textRx.toString(); }
    public String textStatus() {
        if (textMode == 1 && rtty != null) return rtty.locked() ? String.format(Locale.US, "RTTY: listening, mark %.0f Hz", rtty.markHz()) : "RTTY: looking for a signal";
        if (textMode == 2 && psk != null) return psk.locked() ? String.format(Locale.US, "PSK31: listening on %.1f Hz", psk.freq()) : "PSK31: looking for a signal";
        return "Not listening";
    }
    private synchronized void textChar(char ch) { textRx.append(ch); if (textRx.length() > 20000) textRx.delete(0, 4000); textPost(); }
    private volatile boolean textPostPending;
    private void textPost() {
        TextListener l = textListener; if (l == null || textPostPending) return;
        textPostPending = true;                                          // at most five refreshes a second
        new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(() -> { textPostPending = false; textPostNow(); }, 200);
    }
    private void textPostNow() {
        TextListener l = textListener; if (l == null) return;
        final String t; synchronized (this) { t = textRx.toString(); } final String st = textStatus();
        new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> l.update(t, st));
    }
    /** Send text in the chosen mode, on the frequency being received if one is locked; long text goes out in several transmissions. */
    public String textSend(String text) {
        if (text == null || text.trim().isEmpty()) return "Nothing to send";
        if (!host.analogRx()) return "Text modes need an analog channel";
        final int m = textTxMode == 1 ? 1 : 2;
        final double hz = m == 1 ? (rtty != null && rtty.locked() ? rtty.markHz() : 2125) : (psk != null && psk.locked() ? psk.freq() : 1000);
        final java.util.List<String> parts = new java.util.ArrayList<>();
        StringBuilder cur = new StringBuilder();
        int limit = m == 1 ? 130 : 55;                                    // characters that fit about 26 s with the lead and tail (capitals are the longest in PSK31)
        for (String w : text.trim().split(" ")) { if (cur.length() + w.length() + 1 > limit && cur.length() > 0) { parts.add(cur.toString()); cur.setLength(0); } if (cur.length() > 0) cur.append(' '); cur.append(w); }
        if (cur.length() > 0) parts.add(cur.toString());
        synchronized (this) { textRx.append("\n> ").append(text.trim()).append('\n'); } textPost();
        sendPart(parts, 0, m, hz);
        return null;
    }
    private void sendPart(java.util.List<String> parts, int i, int m, double hz) {
        if (i >= parts.size()) return;
        String p = parts.get(i) + (i == parts.size() - 1 ? " " : "");
        short[] pcm = m == 1 ? com.macdmr.radio.ham.Rtty.encode(p, hz, 1000) : com.macdmr.radio.ham.Psk31.encode(p, hz);
        if (pcm.length > SR * 28) { short[] cut = new short[SR * 28]; System.arraycopy(pcm, 0, cut, 0, cut.length); pcm = cut; }
        host.transmitPcm(pcm, (m == 1 ? "RTTY " : "PSK31 ") + (i + 1) + "/" + parts.size(), () -> {
            if (i + 1 < parts.size()) { try { Thread.sleep(2000); } catch (InterruptedException ignored) { } sendPart(parts, i + 1, m, hz); }
            else host.event((m == 1 ? "\u2328 RTTY sent: " : "\u2328 PSK31 sent: ") + String.join(" ", parts));
        });
    }

    // ---- packet terminal: an AX.25 connected-mode session with a BBS or node -----------------------
    public interface TerminalListener { void update(String transcript, String state); }
    private volatile com.macdmr.radio.pkt.Ax25Session terminal;
    private final StringBuilder transcript = new StringBuilder();
    private volatile String termState = "disconnected";
    private volatile TerminalListener termListener;
    public void setTerminalListener(TerminalListener l) { termListener = l; if (l != null) l.update(transcriptText(), termState); }
    public synchronized String transcriptText() { return transcript.toString(); }
    public String terminalState() { return termState; }
    public boolean acceptConnections() { return prefs.getBoolean("acceptConnect", false); }
    public void setAcceptConnections(boolean on) { prefs.edit().putBoolean("acceptConnect", on).apply(); com.macdmr.radio.pkt.Ax25Session t = terminal(); if (t != null) t.setAcceptIncoming(on); }
    private boolean terminalActive() { com.macdmr.radio.pkt.Ax25Session t = terminal; return t != null && (t.state() != com.macdmr.radio.pkt.Ax25Session.State.DISCONNECTED || acceptConnections()); }
    private synchronized void termAppend(String s) {
        transcript.append(s); if (transcript.length() > 20000) transcript.delete(0, transcript.length() - 16000);
        TerminalListener l = termListener; String t = transcript.toString(), st = termState;
        if (l != null) new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> l.update(t, st));
    }
    /** The session for our callsign (made on first use; null without a callsign). */
    public synchronized com.macdmr.radio.pkt.Ax25Session terminal() {
        if (!callsignSet()) return null;
        if (terminal == null) {
            terminal = new com.macdmr.radio.pkt.Ax25Session(callsign(), ssid(), new com.macdmr.radio.pkt.Ax25Session.Link() {
                @Override public void send(java.util.List<byte[]> frames) { txFramesRaw(frames, "AX.25 " + frames.size() + (frames.size() == 1 ? " frame" : " frames")); }
                @Override public void received(String text) { termAppend(text); }
                @Override public void state(String state) {
                    termState = state; termAppend("\n*** " + state + " ***\n"); host.event("\uD83D\uDCBB Packet terminal: " + state);
                    if (state.endsWith("(they called)")) host.notifyUser("Packet connection", state, false);
                }
            });
            terminal.setAcceptIncoming(acceptConnections());
            Thread t = new Thread(() -> { while (true) { try { Thread.sleep(500); com.macdmr.radio.pkt.Ax25Session s = terminal; if (s != null) s.tick(System.currentTimeMillis()); } catch (InterruptedException e) { break; } catch (Throwable x) { Log.w(TAG, "ax25: " + x); } } }, "ax25-timers");
            t.setDaemon(true); t.start();
        }
        return terminal;
    }
    public String terminalConnect(String call, String via) {
        com.macdmr.radio.pkt.Ax25Session t = terminal();
        if (t == null) return "Set your callsign first (PKT \u2192 Settings)";
        if (call == null || !call.trim().toUpperCase(Locale.US).matches("[A-Z0-9]{1,6}(-[0-9]{1,2})?")) return "Callsign like N0ABC or N0ABC-1";
        if (!host.analogRx()) return "Packet needs an analog channel: tune the BBS or node's frequency";
        java.util.List<String> path = new java.util.ArrayList<>();
        for (String v : (via == null ? "" : via).toUpperCase(Locale.US).split(",")) { v = v.trim(); if (!v.isEmpty()) path.add(v); }
        if (path.size() > 2) return "At most two digipeaters";
        termAppend("\n> connecting to " + call.trim().toUpperCase(Locale.US) + (path.isEmpty() ? "" : " via " + String.join(",", path)) + "\n");
        t.connect(call, path.toArray(new String[0]), System.currentTimeMillis());
        return null;
    }
    public void terminalDisconnect() { com.macdmr.radio.pkt.Ax25Session t = terminal; if (t != null) t.disconnect(System.currentTimeMillis()); }
    public String terminalSend(String line) {
        com.macdmr.radio.pkt.Ax25Session t = terminal;
        if (t == null || t.state() != com.macdmr.radio.pkt.Ax25Session.State.CONNECTED) return "Not connected";
        termAppend(line + "\n");
        t.sendText(line + "\r", System.currentTimeMillis());
        return null;
    }

    /** Frames of our own (no FCS yet) in one key-up: one settling lead, each frame once. */
    private void txFramesRaw(java.util.List<byte[]> frames, String label) {
        if (!host.analogRx()) { host.event("\u26D4 Not sent (" + label + "): packet needs an analog channel"); return; }
        java.util.List<byte[]> l = new java.util.ArrayList<>(); for (byte[] f : frames) l.add(Ax25.appendFcs(f));
        host.transmitPcm(packetAudio(l, packetLeadMs(), packetLeadKind()), label, null);
    }

    // ---- two-way iGate: internet messages for stations heard on the radio go out on RF -----------
    private final HashMap<String, Long> heardRf = new HashMap<>(), gatedToRf = new HashMap<>();
    private volatile int gatedToRfCount;
    public int gatedToRfCount() { return gatedToRfCount; }
    private void heard(String call) { if (call == null) return; synchronized (heardRf) { heardRf.put(call.toUpperCase(Locale.US), System.currentTimeMillis()); if (heardRf.size() > 2000) heardRf.clear(); } }
    private boolean heardRecently(String call) { synchronized (heardRf) { Long t = heardRf.get(call.toUpperCase(Locale.US).trim()); return t != null && System.currentTimeMillis() - t < 30 * 60_000L; } }
    /** Bench: pretend a station was heard on RF (DiagReceiver). */
    public void diagHeard(String call) { heard(call); }

    /** Bench (DiagReceiver only): gate to RF without an APRS-IS login and on any analog channel. */
    public volatile boolean benchIgate;

    /** Bench: send one packet of each kind on the current channel. */
    public String diagSend(String what) {
        if (what == null) return "what?";
        Location l = host.location();
        switch (what) {
            case "object": return String.valueOf(l == null ? "no fix" : sendObject("BENCH", true, l.getLatitude(), l.getLongitude(), "/E", "bench test object"));
            case "bulletin": return String.valueOf(sendBulletin(1, "Bench test bulletin"));
            case "telemetry": return String.valueOf(sendTelemetry());
            case "weather": return String.valueOf(sendWeather());
            case "cwid": return String.valueOf(sendCwId());
            case "beacon": return String.valueOf(sendBeacon());
            case "connect": return String.valueOf(terminalConnect("N0BBS-1", ""));
            case "disconnect": terminalDisconnect(); return "ok";
            default: return "unknown " + what;
        }
    }

    private void maybeGateToRf(String line, APRSPacketDecoder.APRSPacket p) {
        if (!(txIgate() || benchIgate) || !p.isMessage() || p.messageTo == null || !heardRecently(p.messageTo)) return;
        AprsIsClient c = is; if (!benchIgate && (c == null || !c.isVerified())) return;
        String from = p.sourceCallsign + (p.sourceSSID != 0 ? "-" + p.sourceSSID : "");
        if (heardRecently(from)) return;                                          // the sender is local too: it hears the addressee itself
        String key = from + ">" + p.messageTo.trim() + ":" + p.messageText + "{" + p.messageId;
        long now = System.currentTimeMillis();
        synchronized (gatedToRf) { Long t = gatedToRf.get(key); if (t != null && now - t < 30 * 60_000L) return; gatedToRf.put(key, now); if (gatedToRf.size() > 500) gatedToRf.clear(); }
        if (!onAprsFrequency() && !benchIgate) { host.event("\uD83C\uDF10 Not gated to the radio (not on 144.390): " + from + " \u2192 " + p.messageTo.trim()); return; }
        final String tp = com.macdmr.radio.pkt.AprsExtras.thirdParty(line, myCall());
        if (tp == null) return;
        final String to = p.messageTo.trim(), text = p.messageText;
        txInfo(tp, new String[] { "WIDE1-1" }, "iGate " + from + " to " + to, 1, () -> { gatedToRfCount++; store.log("igate-rf", from + " (IS)", to, text, p.messageId, false); host.event("\uD83C\uDF10\u2192\uD83D\uDCE1 Gated to the radio: " + from + " \u2192 " + to + ": " + text); });
    }

    // ---- settings -------------------------------------------------------------------------------

    /** The callsign without an SSID (one typed as "CALL-7" before the settings split it is still read right). */
    public String callsign() { String c = prefs.getString("callsign", "").trim().toUpperCase(Locale.US); int d = c.indexOf('-'); return d > 0 ? c.substring(0, d).trim() : c; }
    public int ssid() {
        String c = prefs.getString("callsign", "").trim(); int d = c.indexOf('-');
        if (d > 0) try { return Integer.parseInt(c.substring(d + 1).trim()) & 0x0F; } catch (NumberFormatException ignored) { }
        return prefs.getInt("ssid", 7);
    }
    public String myCall() { return callsign() + (ssid() != 0 ? "-" + ssid() : ""); }
    public boolean callsignSet() { String c = callsign(); return !c.isEmpty() && !"N0CALL".equals(c); }
    public char symTable() { return prefs.getString("symTable", "/").charAt(0); }
    public char symCode() { return prefs.getString("symCode", "[").charAt(0); }
    public String comment() { return prefs.getString("comment", "SignalDeck"); }
    public String[] path() { String p = prefs.getString("path", "WIDE1-1,WIDE2-1").trim(); return p.isEmpty() ? new String[0] : p.split("\\s*,\\s*"); }
    public int passiveMode() { return prefs.getInt("passive", 2); }       // 0 off, 1 flagged channels, 2 every analog channel
    public boolean autoAck() { return prefs.getBoolean("autoAck", true); }
    public boolean digipeat() { return prefs.getBoolean("digipeat", false); }
    public int kissPort() { return prefs.getInt("kissPort", 8001); }
    public boolean dtmfEnabled() { return prefs.getBoolean("dtmf", true); }
    public boolean wxEnabled() { return prefs.getBoolean("wx", true); }
    public boolean cwEnabled() { return prefs.getBoolean("cw", true); }
    public boolean remoteOn() { return prefs.getBoolean("remote", false); }
    public String remotePin() { return prefs.getString("remotePin", ""); }
    /** Send the callsign in Morse after talking on amateur channels, at most every ten minutes. */
    public boolean cwIdEnabled() { return prefs.getBoolean("cwId", false); }
    private volatile long lastCwIdMs;
    /** Morse ID audio to append now, or null when none is due (or no callsign is set). */
    public short[] cwIdIfDue(long now) {
        if (!cwIdEnabled() || !callsignSet() || (lastCwIdMs != 0 && now - lastCwIdMs < 10 * 60_000L)) return null;
        lastCwIdMs = now; host.identified();
        return com.macdmr.radio.coverage.Morse.pcm(callsign(), 20, 800);
    }
    /** Transmit the callsign in Morse now on the current channel. Error text or null. */
    public String sendCwId() {
        if (!callsignSet()) return "Set your callsign first (PKT \u2192 Settings)";
        if (!host.analogRx()) return "Morse needs an analog channel";
        lastCwIdMs = System.currentTimeMillis(); host.identified();
        short[] m = com.macdmr.radio.coverage.Morse.pcm(callsign(), 20, 800), pcm = new short[SR * 13 / 10 + m.length];   // the TX path needs ~1.5 s after key-up: silence first, or the first letters are lost
        System.arraycopy(m, 0, pcm, SR * 13 / 10, m.length);
        host.transmitPcm(pcm, "Morse ID", () -> host.event("\uD83D\uDD24 Sent Morse ID " + callsign()));
        return null;
    }
    private com.macdmr.radio.ham.CwDecoder cw;
    private boolean wasOpen;
    public SharedPreferences prefs() { return prefs; }

    /** Saved DTMF sequences: name → code (also exported as DTMF.csv in backups). */
    public java.util.LinkedHashMap<String, String> dtmfSaved() {
        java.util.LinkedHashMap<String, String> out = new java.util.LinkedHashMap<>();
        try { org.json.JSONArray a = new org.json.JSONArray(prefs.getString("dtmfSaved", "[]")); for (int i = 0; i < a.length(); i++) { org.json.JSONObject o = a.getJSONObject(i); out.put(o.getString("name"), o.getString("code")); } } catch (Throwable ignored) { }
        return out;
    }
    public void dtmfSave(String name, String code) {
        java.util.LinkedHashMap<String, String> m = dtmfSaved(); if (code == null || code.isEmpty()) m.remove(name); else m.put(name, code);
        try { org.json.JSONArray a = new org.json.JSONArray(); for (java.util.Map.Entry<String, String> e : m.entrySet()) a.put(new org.json.JSONObject().put("name", e.getKey()).put("code", e.getValue())); prefs.edit().putString("dtmfSaved", a.toString()).apply(); } catch (Throwable ignored) { }
    }
    public boolean flagged(int channel) { return prefs.getStringSet("flagged", java.util.Collections.<String>emptySet()).contains(String.valueOf(channel)); }
    public void setFlagged(int channel, boolean on) {
        java.util.Set<String> s = new java.util.HashSet<>(prefs.getStringSet("flagged", java.util.Collections.<String>emptySet()));
        if (on) s.add(String.valueOf(channel)); else s.remove(String.valueOf(channel));
        prefs.edit().putStringSet("flagged", s).apply();
    }

    // ---- APRS-IS (internet): RX-only iGate of what the radio hears, internet position beacon, messages for us ----
    private volatile AprsIsClient is;
    private volatile String isStatus = "off";
    private volatile long isLastBeacon;
    public boolean isEnabled() { return prefs.getBoolean("isEnabled", false); }
    public String isStatus() { AprsIsClient c = is; return c == null ? (isEnabled() ? isStatus : "off") : (c.isConnected() ? (c.isVerified() ? "connected" : "connected, receive-only") + " \u00B7 " + c.gatedCount + " gated" : isStatus); }
    public String isServer() { return prefs.getString("isServer", "rotate.aprs2.net"); }
    public int isPort() { return prefs.getInt("isPort", 14580); }
    public int isBeaconMin() { return prefs.getInt("isBeaconMin", 10); }

    public synchronized String isStart() {
        isStop();
        if (!callsignSet()) return "Set your callsign first";
        String pass = prefs.getString("isPasscode", "-1").trim(); if (pass.isEmpty()) pass = "-1";
        AprsIsClient c = new AprsIsClient(isServer(), isPort(), myCall(), pass, "SignalDeck 1.0", null, new AprsIsClient.Listener() {
            @Override public void onStatus(String status, boolean connected) { isStatus = status; if (connected && isBeaconMin() > 0) new Thread(() -> { try { Thread.sleep(5000); } catch (InterruptedException ignored) { } isBeacon(); }, "aprs-is-beacon").start(); }
            @Override public void onServerLine(String line) { isServerLine(line); }
        });
        is = c; c.start();
        prefs.edit().putBoolean("isEnabled", true).apply();
        Thread t = new Thread(() -> {
            while (is == c) {
                try { Thread.sleep(60000); } catch (InterruptedException e) { break; }
                int min = isBeaconMin();
                if (min > 0 && System.currentTimeMillis() - isLastBeacon >= min * 60000L) isBeacon();
            }
        }, "aprs-is-timer"); t.setDaemon(true); t.start();
        return null;
    }

    public synchronized void isStop() { AprsIsClient c = is; is = null; if (c != null) c.stop(); isStatus = "off"; prefs.edit().putBoolean("isEnabled", false).apply(); }

    /** One position report straight to the internet (no RF). */
    public void isBeacon() {
        AprsIsClient c = is; if (c == null || !c.isConnected() || !c.isVerified()) return;
        Location l = host.location(); if (l == null) return;
        String info = Ax25.positionInfo(l.getLatitude(), l.getLongitude(), symTable(), symCode(), prefs.getString("isComment", comment()));
        if (c.send(c.getLogin() + ">APDR16,TCPIP*:" + info)) { isLastBeacon = System.currentTimeMillis(); store.log("is-beacon", myCall(), "APRS-IS", info, null, false); }
    }

    private void igate(byte[] frame) {
        AprsIsClient c = is; if (c == null || !c.isConnected() || !c.isVerified()) return;
        String t = AprsIsClient.tnc2FromFrame(frame);
        if (AprsIsClient.shouldGate(t)) c.gate(t);
    }

    /** Bench: handle a line as if the APRS-IS server sent it (DiagReceiver). */
    public void diagServerLine(String line) { if (line != null) isServerLine(line); }

    /** Lines from the server: messages for our login are logged, notified and acked over the internet. */
    private void isServerLine(String line) {
        try {
            APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decodeTnc2(line);
            if (!p.isValid || !p.isMessage()) return;
            if (!addressedToMe(p.messageTo)) { maybeGateToRf(line, p); return; }
            String from = p.sourceCallsign + (p.sourceSSID != 0 ? "-" + p.sourceSSID : "");
            store.log(p.isAck ? "ack" : p.isRej ? "rej" : "msg", from + " (IS)", p.messageTo, p.messageText, p.messageId, true);
            if (p.isAck || p.isRej) return;
            host.notifyUser("APRS-IS message from " + from, p.messageText, false);
            host.event("\uD83C\uDF10 " + from + ": " + p.messageText);
            AprsIsClient c = is;
            if (p.messageId != null && c != null && c.isVerified()) c.send(c.getLogin() + ">APDR16,TCPIP*:" + Ax25.messageInfo(from, "ack" + p.messageId, 0));
        } catch (Throwable t) { Log.w(TAG, "is line: " + t); }
    }

    public boolean monitoring() { return monitor; }
    public void setMonitoring(boolean on) { monitor = on; if (!on) { fill = 0; overlapTail = null; } updateGps(); }
    /** GPS fixes while automatic beacons can go out (monitoring): a timed beacon used to send the last known
     *  position, which goes stale when no other app keeps the GPS on (only SmartBeaconing asked for fixes). */
    public void updateGps() { host.wantLocation(autoBeacon() != 0 && monitor); }
    public KissTnc kiss() { return kiss; }

    public String kissStart() {
        if (kiss.isActive()) return "KISS TNC already running on 127.0.0.1:" + kiss.port();
        String err = kiss.start(kissPort(), f -> { if (!kissTxQueue.offer(f)) Log.w(TAG, "kiss queue full"); });
        return err != null ? err : null;
    }
    public void kissStop() { kiss.stop(); kissTxQueue.clear(); }

    private boolean passiveWanted() {
        int m = passiveMode();
        if (m <= 0) return false;
        return m == 2 || flagged(host.channelNumber());
    }

    // ---- RX ---------------------------------------------------------------------------------------

    /** Every 8 kHz mono block the radio delivers; {@code open} = the (soft) squelch passes it. */
    public void feed(byte[] mono, int n, boolean open) { feed(mono, n, open, false); }
    /** {@code open}: the squelch passes a signal. {@code data}: a data mode runs (APRS monitoring, SSTV), whose
     *  decoders also get the audio below the squelch; Morse, DTMF, RTTY/PSK and SAME still wait for {@code open}
     *  (on noise they would invent text). */
    public void feed(byte[] mono, int n, boolean open, boolean data) {
        if (!host.analogRx()) { fill = 0; return; }
        if (!open && wasOpen && cw != null) cw.flush();
        wasOpen = open;
        if (!open && !data) return;
        try {
            int f = host.rxFreqHz();
            boolean weatherBand = f >= 162_400_000 && f <= 162_550_000;      // NOAA carries no DTMF or APRS: save the CPU there
            if (open && dtmfEnabled() && !weatherBand) {
                if (dtmf == null) dtmf = new DTMFDecoder(SR, false, dtmfListener);
                dtmf.processAudio(mono, n);
            }
            if (open && textMode == 1 && rtty != null) rtty.process(mono, n);
            else if (open && textMode == 2 && psk != null) psk.process(mono, n);
            if (open && cwEnabled() && !weatherBand) {
                if (cw == null) cw = new com.macdmr.radio.ham.CwDecoder((text, hz, wpm) -> {
                    String id = null;                                                      // the channel's own callsign (repeater channels are named after it)
                    for (String w : host.channelName().toUpperCase(Locale.US).replace(",", " ").split(" ")) { String b = com.macdmr.radio.ham.Logbook.baseCall(w.startsWith("\u00BB") ? w.substring(1) : w); if (b != null && text.contains(b)) id = b; }
                    host.event(id != null ? "\uD83D\uDD24 Repeater ID " + id + " in Morse (matches this channel): " + text + String.format(Locale.US, "  (%.0f Hz, %d WPM)", hz, wpm)
                                          : "\uD83D\uDD24 Morse: " + text + String.format(Locale.US, "  (%.0f Hz, %d WPM)", hz, wpm));
                    for (String w : text.split(" ")) if (com.macdmr.radio.ham.Logbook.baseCall(w) != null) host.logHeard(w, "CW", "Morse ID");
                });
                cw.process(mono, n);
            }
            if (open && wxEnabled() && f >= 162_400_000 && f <= 162_550_000) {
                if (same == null) same = new SAMEDecoder(SR, false, sameListener);
                same.processAudio(mono, n);
            }
            if (sstvRx && sstvContinuous) {
                com.macdmr.radio.pkt.SstvContinuous c = sstvCont;
                if (c != null) {
                    int k = n / 2; if (contBuf.length < k) contBuf = new short[k];
                    for (int i = 0; i < k; i++) contBuf[i] = (short) ((mono[2 * i] & 0xFF) | (mono[2 * i + 1] << 8));
                    c.process(contBuf, k);
                }
            } else if (sstvRx && sstv != null) {
                if (sstvBytes.length < n * 2) sstvBytes = new byte[n * 2];
                for (int i = 0, o = 0; i + 1 < n; i += 2) { sstvBytes[o++] = mono[i]; sstvBytes[o++] = mono[i + 1]; sstvBytes[o++] = mono[i]; sstvBytes[o++] = mono[i + 1]; }   // the receiver runs at 16 kHz (each 8 kHz sample twice, exactly the module's input)
                sstv.processAudio(sstvBytes, n * 2);
            }
            if (!sstvRx && (monitor || kiss.isActive() || terminalActive() || (passiveWanted() && !weatherBand))) {
                for (int i = 0; i + 1 < n && fill < WINDOW; i += 2) window[fill++] = (short) ((mono[i] & 0xFF) | (mono[i + 1] << 8));
                if (fill >= WINDOW) {
                    long now = System.currentTimeMillis();
                    if (now - lastWindowMs > 5000) overlapTail = null;
                    lastWindowMs = now;
                    short[] tail = overlapTail; int tl = tail == null ? 0 : tail.length;
                    final short[] samples = new short[tl + WINDOW];
                    if (tl > 0) System.arraycopy(tail, 0, samples, 0, tl);
                    System.arraycopy(window, 0, samples, tl, WINDOW);
                    overlapTail = Arrays.copyOfRange(window, WINDOW - OVERLAP, WINDOW);
                    fill = 0;
                    decoder.execute(() -> decodeWindow(samples));
                }
            }
        } catch (Throwable t) { Log.w(TAG, "feed: " + t); }
    }

    /** The AFSK decoder works at 48 kHz: 6x linear upsample of the 8 kHz window. */
    private static short[] up6(short[] in) {
        short[] out = new short[in.length * 6];
        for (int i = 0; i < in.length; i++) {
            int a = in[i], b = i + 1 < in.length ? in[i + 1] : in[i];
            for (int k = 0; k < 6; k++) out[i * 6 + k] = (short) (a + (b - a) * k / 6);
        }
        return out;
    }

    private void decodeWindow(short[] samples) {
        try {
            List<byte[]> frames = AFSKDecoder.decode(up6(samples));
            for (byte[] frame : frames) {
                com.macdmr.radio.pkt.Ax25Session ts = terminal;
                if (ts != null && com.macdmr.radio.pkt.Ax25Session.addressedTo(frame, callsign(), ssid())) {   // connected-mode traffic for our terminal
                    if (duplicate(frame)) continue;
                    if (ts.receive(frame, System.currentTimeMillis())) continue;
                }
                if (!Ax25.plausible(frame)) continue;   // noise that passed the FCS: never log, gate, digipeat or hand it to the TNC
                if (duplicate(frame)) continue;
                kiss.deliver(frame);
                maybeDigipeat(frame);
                igate(frame);
                APRSPacketDecoder.APRSPacket p = APRSPacketDecoder.decode(frame);
                String from = p.isValid ? p.sourceCallsign + (p.sourceSSID != 0 ? "-" + p.sourceSSID : "") : Ax25.addr(frame, 7);
                heard(from);
                if (!p.isValid) { host.event("📡 " + Ax25.tnc2(frame)); continue; }
                host.logHeard(from, "PKT", "APRS");
                long now = System.currentTimeMillis();
                if (p.hasPosition) { store.storeStation(p, now); store.log("pos", from, p.destCallsign, APRSPacketDecoder.describe(p), null, false); }
                if (p.isMessage()) messageReceived(p, from);
                else if (p.status != null) store.log("status", from, p.destCallsign, p.status, null, false);
                else if (!p.hasPosition) store.log("other", from, p.destCallsign, p.rawInfo, null, false);
                String desc = APRSPacketDecoder.describe(p);
                host.event("📡 " + from + ": " + (desc == null || desc.trim().isEmpty() ? (p.rawInfo == null ? "" : p.rawInfo.trim()) : desc));   // no summary for this packet type: show its text
            }
        } catch (Throwable t) { Log.w(TAG, "decode: " + t); }
    }

    private synchronized boolean duplicate(byte[] frame) {
        long now = System.currentTimeMillis();
        while (!recent.isEmpty() && now - (Long) recent.getFirst()[1] > 2000) recent.removeFirst();
        for (Object[] e : recent) if (Arrays.equals((byte[]) e[0], frame)) return true;
        recent.addLast(new Object[] { frame.clone(), now });
        return false;
    }

    private boolean addressedToMe(String to) {
        if (to == null || !callsignSet()) return false;
        String t = to.trim().toUpperCase(Locale.US), c = callsign(); int s = ssid();
        return t.equals(c + "-" + s) || (s == 0 && (t.equals(c) || t.equals(c + "-0")));
    }

    private void messageReceived(APRSPacketDecoder.APRSPacket p, String from) {
        boolean mine = addressedToMe(p.messageTo);
        boolean bulletin = p.messageTo != null && (p.messageTo.startsWith("BLN") || p.messageTo.startsWith("NWS"));
        String group = null; if (p.messageTo != null) for (String g : groups()) if (p.messageTo.trim().equalsIgnoreCase(g)) group = g;
        if (group != null && !p.isAck && !p.isRej) { store.log("msg", from, p.messageTo, p.messageText, p.messageId, true); host.notifyUser("APRS group " + group + ": " + from, p.messageText, false); return; }
        store.log(p.isAck ? "ack" : p.isRej ? "rej" : "msg", from, p.messageTo, p.messageText, p.messageId, mine);
        if (mine && !p.isAck && !p.isRej && p.messageId != null) maybeAutoAck(from, p.messageId);
        if ((mine || bulletin) && !p.isAck && !p.isRej) host.notifyUser((mine ? "APRS message from " : "APRS bulletin from ") + from, p.messageText, false);
    }

    /** APRS protocol: a message with an {id must be acked or the sender keeps retrying (monitoring mode only, not under KISS). */
    private void maybeAutoAck(final String from, final String id) {
        if (!monitor || kiss.isActive() || !autoAck() || !callsignSet()) return;
        String key = from + "{" + id; long now = System.currentTimeMillis();
        synchronized (ackSent) { Long last = ackSent.get(key); ackSent.put(key, now); if (ackSent.size() > 200) ackSent.clear(); if (last != null && now - last < 10000) return; }
        final String info = Ax25.messageInfo(from, "ack" + id, 0);
        new Thread(() -> {
            try { Thread.sleep(1500 + rnd.nextInt(1500)); } catch (InterruptedException ignored) { }
            if (!monitor || kiss.isActive()) return;
            txInfo(info, new String[] { "WIDE1-1" }, "ack " + id + " to " + from, 1, () -> store.log("ack-tx", myCall(), from, "ack" + id, id, false));
        }, "aprs-ack").start();
    }

    /** Fill-in digipeater: repeat once when the first unused hop is WIDE1-1 (or us), replaced by MYCALL*. */
    private void maybeDigipeat(final byte[] frame) {
        try {
            if (!monitor || kiss.isActive() || !digipeat() || !callsignSet() || frame.length < 16) return;
            String my = myCall(), c = callsign(); int s = ssid();
            String dst = Ax25.addr(frame, 0), src = Ax25.addr(frame, 7);
            if (src.equals(my)) return;
            boolean last = (frame[13] & 0x01) != 0; int off = 14, hop = -1;
            while (!last && off + 7 <= frame.length) {
                String d = Ax25.addr(frame, off); boolean used = (frame[off + 6] & 0x80) != 0;
                if ((d.equals(c) || d.equals(my)) && used) return;
                if (!used && hop < 0) { if (d.equals("WIDE1-1") || d.equals(my) || (s == 0 && d.equals(c))) hop = off; else return; }
                last = (frame[off + 6] & 0x01) != 0; off += 7;
            }
            if (hop < 0 || off + 2 > frame.length) return;
            String key = src + ":" + new String(frame, off + 2, frame.length - off - 2, java.nio.charset.StandardCharsets.ISO_8859_1);
            long now = System.currentTimeMillis();
            synchronized (digiSeen) { Long t = digiSeen.get(key); if (t != null && now - t < 30000) return; digiSeen.put(key, now); if (digiSeen.size() > 500) digiSeen.clear(); }
            final byte[] out = frame.clone();
            String call = (c + "      ").substring(0, 6);
            for (int i = 0; i < 6; i++) out[hop + i] = (byte) ((call.charAt(i) << 1) & 0xFF);
            out[hop + 6] = (byte) ((frame[hop + 6] & 0x01) | 0x60 | ((s & 0x0F) << 1) | 0x80);
            final String label = "digi " + src + ">" + dst;
            new Thread(() -> {
                try { Thread.sleep(500 + rnd.nextInt(1000)); } catch (InterruptedException ignored) { }
                if (!monitor || kiss.isActive()) return;
                txRaw(out, label, 1, () -> store.log("digi", src, dst, "repeated via " + my, null, false));
            }, "aprs-digi").start();
        } catch (Throwable t) { Log.w(TAG, "digi: " + t); }
    }

    private final DTMFDecoder.Listener dtmfListener = new DTMFDecoder.Listener() {
        @Override public void onDigit(char digit) {
            lastDtmfDigitMs = System.currentTimeMillis();
            new Thread(() -> {       // the decoder only closes a sequence while audio flows; flush when the squelch shut right after the last key
                try { Thread.sleep(DTMFDecoder.SEQUENCE_GAP_MS + 300); } catch (InterruptedException ignored) { }
                if (System.currentTimeMillis() - lastDtmfDigitMs >= DTMFDecoder.SEQUENCE_GAP_MS + 250) { DTMFDecoder d = dtmf; if (d != null) d.flush(); }
            }, "dtmf-flush").start();
        }
        @Override public void onSequence(String digits, long startMs, long endMs) {
            boolean remote = remoteOn() && remotePin().length() >= 4 && digits.replace("*", "").replace("#", "").startsWith(remotePin());
            String shown = remote ? "remote command" : digits;                       // the PIN is never written to the log or the history
            store.dtmf(shown, host.channelNumber(), host.channelName());
            host.event("📟 DTMF " + shown);
            host.dtmfSequence(digits);
        }
    };

    private final SAMEDecoder.Listener sameListener = new SAMEDecoder.Listener() {
        @Override public void onMessage(SAMEDecoder.Message m) {
            store.alert(m.event, m.summary(), m.raw, m.eom);
            if (!m.eom) host.notifyUser("⛈️ " + (m.eventName.isEmpty() ? m.event : m.eventName), m.summary(), true);
            host.event(m.eom ? "⛈️ Weather alert: end of message" : "⛈️ " + m.summary());
        }
        @Override public void onAttentionTone(boolean on) { if (on) host.event("⛈️ Weather alert attention tone"); }
    };

    // ---- TX ---------------------------------------------------------------------------------------

    /** AFSK-modulate a complete frame (with FCS), prefix the settling lead, repeat, and transmit. */
    private void txFrame(byte[] frame, String label, int reps, Runnable onDone) {
        if (!host.analogRx()) { host.event("⛔ Not sent (" + label + "): packet needs an analog channel, the current one is DMR"); return; }
        java.util.List<byte[]> l = new java.util.ArrayList<>(); for (int r = 0; r < Math.max(1, reps); r++) l.add(frame);
        host.transmitPcm(packetAudio(l, packetLeadMs(), packetLeadKind()), label, onDone);
    }

    private void txRaw(byte[] noFcs, String label, int reps, Runnable onDone) { txFrame(Ax25.appendFcs(noFcs), label, reps, onDone); }

    /** Several frames in one transmission (one settling lead): telemetry with its definitions. */
    private void txInfos(java.util.List<String> infos, String label, Runnable onDone) {
        if (!host.analogRx()) { host.event("⛔ Not sent (" + label + "): packet needs an analog channel, the current one is DMR"); return; }
        java.util.List<byte[]> l = new java.util.ArrayList<>();
        for (String info : infos) l.add(Ax25.buildUiFrame("APZDMR", 0, callsign(), ssid(), path(), info.getBytes(java.nio.charset.StandardCharsets.US_ASCII)));
        host.transmitPcm(packetAudio(l, packetLeadMs(), packetLeadKind()), label, onDone);
    }

    private void txInfo(String info, String[] path, String label, int reps, Runnable onDone) {
        byte[] frame = Ax25.buildUiFrame("APZDMR", 0, callsign(), ssid(), path, info.getBytes(java.nio.charset.StandardCharsets.US_ASCII));
        txFrame(frame, label, reps, onDone);
    }

    /** Send an APRS message over APRS-IS (the login must be verified); error text or null. */
    public String isSendMessage(String to, String text) {
        AprsIsClient c = is;
        if (c == null || !c.isVerified()) return "APRS-IS is not connected with a verified login";
        if (to == null || to.trim().isEmpty() || text == null || text.trim().isEmpty()) return "Addressee and text are needed";
        final int id = prefs.getInt("msgId", 0) % 999 + 1; prefs.edit().putInt("msgId", id).apply();
        String addressee = to.trim().toUpperCase(Locale.US);
        if (!c.send(c.getLogin() + ">APDR16,TCPIP*:" + Ax25.messageInfo(addressee, text.trim(), id))) return "APRS-IS send failed";
        store.log("msg-tx", c.getLogin() + " (IS)", addressee, text.trim(), String.valueOf(id), false);
        host.event("\uD83C\uDF10 Sent to " + addressee + ": " + text.trim());
        return null;
    }

    /** Send an APRS message (numbered so the other side acks it). Returns an error text or null. */
    public String sendMessage(final String to, final String text) {
        if (!callsignSet()) return "Set your callsign first (PKT → APRS settings)";
        if (to == null || to.trim().isEmpty() || text == null || text.trim().isEmpty()) return "Addressee and text are needed";
        if (text.length() > 67) return "APRS messages are at most 67 characters";
        if (!host.analogRx()) return "Packet needs an analog channel: tune the APRS channel (144.390 MHz in North America)";
        final int id = prefs.getInt("msgId", 0) % 999 + 1; prefs.edit().putInt("msgId", id).apply();
        final String addressee = to.trim().toUpperCase(Locale.US);
        txInfo(Ax25.messageInfo(addressee, text.trim(), id), path(), "APRS message to " + addressee, TX_REPS,
                () -> { store.log("msg-tx", myCall(), addressee, text.trim(), String.valueOf(id), false); host.event("📡 Sent to " + addressee + ": " + text.trim()); });
        return null;
    }

    /**
     * Emergency: a position report with the APRS emergency symbol (alternate table, '!') and "EMERGENCY <text>" as the
     * comment, or an "EMERGENCY" status report when there is no fix. Sent on the current channel. Error text or null.
     */
    public String sendEmergency(String text) {
        if (!callsignSet()) return "Set your callsign first (PKT → APRS settings)";
        String c = ("EMERGENCY " + (text == null ? "" : text.trim())).trim();
        final Location l = host.location();
        final String info;
        if (l != null) { if (c.length() > 43) c = c.substring(0, 43); info = Ax25.positionInfo(l.getLatitude(), l.getLongitude(), (char) 92, '!', c); }
        else { if (c.length() > 62) c = c.substring(0, 62); info = ">" + c; }
        txInfo(info, path(), "EMERGENCY " + (l != null ? "position" : "status"), TX_REPS, () -> { store.log("beacon", myCall(), "APZDMR", info, null, false); host.event("🆘 Emergency " + (l != null ? "position" : "status (no fix)") + " sent"); });
        return null;
    }

    /** Transmit one position report from the phone's last fix. Returns an error text or null. */
    public String sendBeacon() { return sendBeaconVia(path()); }

    /** A position report through a given path (ARISS for the space station's digipeater). */
    public String sendBeaconVia(String[] via) {
        if (!callsignSet()) return "Set your callsign first (PKT → APRS settings)";
        Location l = host.location();
        if (l == null) return "No position fix yet (turn on location and open Maps once)";
        if (!host.analogRx()) return "Packet needs an analog channel: tune the APRS channel (144.390 MHz in North America)";
        final String info = Ax25.positionInfo(l.getLatitude(), l.getLongitude(), symTable(), symCode(), comment());
        txInfo(info, via, "position beacon", TX_REPS, () -> { store.log("beacon", myCall(), "APZDMR", info, null, false); host.event("📡 Beacon sent" + (via.length > 0 ? " via " + String.join(",", via) : "")); });
        return null;
    }

    /** Key the radio and send a DTMF sequence (100 ms tones, 60 ms gaps) after a short silent lead. */
    public String sendDtmf(String seq) {
        if (seq == null) return "Nothing to send";
        String s = seq.toUpperCase(Locale.US).replaceAll("[^0-9A-D*#]", "");
        if (s.isEmpty()) return "Only 0-9, A-D, * and # can be sent";
        if (!host.analogRx()) return "DTMF needs an analog channel";
        final String fs = s;
        host.transmitPcm(dtmfPcm(s, 100, 60), "DTMF " + s, () -> host.event("📟 Sent DTMF " + fs));
        return null;
    }

    static short[] dtmfPcm(String seq, int toneMs, int gapMs) {
        final double[] low = { 697, 770, 852, 941 }, high = { 1209, 1336, 1477, 1633 };
        final String[] rows = { "123A", "456B", "789C", "*0#D" };
        int toneN = SR * toneMs / 1000, gapN = SR * gapMs / 1000, lead = SR * TX_LEAD_MS / 1000;
        short[] out = new short[lead + seq.length() * (toneN + gapN) + SR * 200 / 1000];
        int pos = lead;
        for (char c : seq.toCharArray()) {
            int r = -1, col = -1;
            for (int i = 0; i < 4; i++) { int j = rows[i].indexOf(c); if (j >= 0) { r = i; col = j; } }
            if (r >= 0) {
                int edge = SR * 5 / 1000;
                for (int i = 0; i < toneN; i++) {
                    double v = 0.38 * 32767 * (Math.sin(2 * Math.PI * low[r] * i / SR) + Math.sin(2 * Math.PI * high[col] * i / SR));
                    if (i < edge) v *= 0.5 * (1 - Math.cos(Math.PI * i / edge)); else if (i >= toneN - edge) v *= 0.5 * (1 - Math.cos(Math.PI * (toneN - 1 - i) / edge));
                    out[pos + i] = (short) Math.max(-32768, Math.min(32767, v));
                }
            }
            pos += toneN + gapN;
        }
        return out;
    }
}
