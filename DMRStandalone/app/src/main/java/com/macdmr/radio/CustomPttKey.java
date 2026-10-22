/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * A push-to-talk button the owner picks by pressing it (Device → Custom PTT key), for phones or accessories whose
 * button is not the profile's official PTT key: the Armor's other side key, a wired headset's button, a Bluetooth
 * PTT button, a volume key.
 *
 * Keys are read from the kernel's input devices with root (`getevent`), so the button works with the screen off and
 * SignalDeck in the background, and every hardware key is seen, including ones Android never hands to apps. The
 * price: the key is not taken away from the phone, so whatever else it does still happens. That is why learning
 * runs the conflict checks below, and why SignalDeck puts the volume back after a volume key was used to talk.
 *
 * The key is stored as the input device's name plus the key's kernel name (`mtk-kpd` / `KEY_CD`): device paths
 * change between boots and when a Bluetooth button reconnects, names do not.
 */
public final class CustomPttKey {
    private CustomPttKey() { }

    // ---- pure parsing and checks (host-tested) ----

    /** One input device from `getevent -pl`. */
    public static final class Device {
        public final String path, name; public final Set<String> keys = new LinkedHashSet<>(); public boolean touch; public String bus = "";
        Device(String path, String name) { this.path = path; this.name = name; }
    }

    private static final Pattern ADD = Pattern.compile("^add device \\d+: (\\S+)");
    private static final Pattern NAME = Pattern.compile("^\\s*name:\\s*\"(.*)\"");
    private static final Pattern KEYNAME = Pattern.compile("\\b((?:KEY|BTN)_[A-Z0-9_]+)\\b");

    /** Devices by path from `getevent -pl` (all devices). */
    public static Map<String, Device> parseDevices(String pl) {
        Map<String, Device> out = new HashMap<>();
        Device cur = null; String path = null;
        for (String line : pl.split("\n")) {
            Matcher m = ADD.matcher(line);
            if (m.find()) { path = m.group(1); cur = null; continue; }
            m = NAME.matcher(line);
            if (m.find() && path != null) { cur = new Device(path, m.group(1)); out.put(path, cur); continue; }
            if (cur == null) continue;
            if (line.contains("ABS_MT_POSITION") || line.contains("BTN_TOUCH")) cur.touch = true;
            if (line.contains("SW  (") || line.contains("ABS (") || line.contains("REL (") || line.contains("LED (") || line.contains("MSC (")) continue;
            Matcher k = KEYNAME.matcher(line);
            while (k.find()) cur.keys.add(k.group(1));
        }
        return out;
    }

    /** Fills {@link Device#bus} from /proc/bus/input/devices (`I: Bus=0005 …` then `N: Name="…"`). */
    public static void addBus(Map<String, Device> devices, String proc) {
        String bus = null;
        for (String line : proc.split("\n")) {
            if (line.startsWith("I:")) { Matcher m = Pattern.compile("Bus=([0-9a-fA-F]{4})").matcher(line); bus = m.find() ? m.group(1).toLowerCase(Locale.US) : null; }
            else if (line.startsWith("N:") && bus != null) {
                Matcher m = Pattern.compile("Name=\"(.*)\"").matcher(line);
                if (m.find()) for (Device d : devices.values()) if (d.name.equals(m.group(1))) d.bus = bus;
            }
        }
    }

    /** One key line from `getevent -l`, with or without the device prefix and the -t timestamp. */
    public static final class Event {
        public final String path, code; public final int value;     // 1 down, 0 up, 2 repeat
        Event(String path, String code, int value) { this.path = path; this.code = code; this.value = value; }
    }
    private static final Pattern KEYLINE = Pattern.compile("^(?:\\[[^]]*]\\s*)?(?:(/dev/input/\\S+?):\\s+)?EV_KEY\\s+(\\S+)\\s+(DOWN|UP|REPEAT|[0-9a-fA-F]{8})\\s*$");
    public static Event parse(String line) {
        Matcher m = KEYLINE.matcher(line.trim());
        if (!m.find()) return null;
        String v = m.group(3);
        int value = "DOWN".equals(v) ? 1 : "UP".equals(v) ? 0 : "REPEAT".equals(v) ? 2 : (int) Long.parseLong(v, 16);
        return new Event(m.group(1), m.group(2), value);
    }

    /** A plain name for the owner: "Volume up", "Headset button", "Key CD (mtk-kpd)". */
    public static String friendly(String device, String code) {
        if (code == null) return "No key";
        boolean headset = device != null && device.toUpperCase(Locale.US).contains("ACCDET");
        switch (code) {
            case "KEY_VOLUMEUP": return headset ? "Headset volume up" : "Volume up";
            case "KEY_VOLUMEDOWN": return headset ? "Headset volume down" : "Volume down";
            case "KEY_PLAYPAUSE": case "KEY_MEDIA": case "KEY_PHONE": return headset ? "Headset button" : "Play/pause button";
            case "KEY_VOICECOMMAND": return headset ? "Headset button (hold)" : "Voice command button";
            case "KEY_CAMERA": return "Camera button";
            default:
                String n = code.replaceFirst("^(KEY|BTN)_", "").replace('_', ' ');     // the kernel's name, e.g. CD, F9, 0
                if (n.isEmpty()) n = code;
                return (code.startsWith("BTN_") ? "Button " : "Key ") + n + (device == null || device.isEmpty() ? "" : " (" + device + ")");
        }
    }

    /** A finding of the conflict check: {@link #block} means the key cannot be used. */
    public static final class Finding {
        public final boolean block; public final String text;
        Finding(boolean block, String text) { this.block = block; this.text = text; }
        @Override public String toString() { return (block ? "⛔ " : "⚠ ") + text; }
    }

    /** What the learn run saw besides the key itself. */
    public static final class Seen {
        public long holdMs = -1;              // how long it reported being held; -1 = no release seen
        public boolean officialPtt;           // the profile's PTT broadcast arrived during the press
        public final List<String> opened = new ArrayList<>();   // apps that came to the front during the press
        public boolean volPtt, wheelTalk;     // SignalDeck's own key settings
    }

    static final Set<String> NAV = new java.util.HashSet<>(java.util.Arrays.asList("KEY_HOME", "KEY_BACK", "KEY_MENU", "KEY_APPSELECT", "KEY_HOMEPAGE", "KEY_SEARCH"));
    static final Set<String> MEDIA = new java.util.HashSet<>(java.util.Arrays.asList("KEY_PLAYPAUSE", "KEY_MEDIA", "KEY_PHONE", "KEY_VOICECOMMAND", "KEY_PLAYCD", "KEY_PAUSECD", "KEY_NEXTSONG", "KEY_PREVIOUSSONG", "KEY_STOPCD", "KEY_ASSISTANT"));
    static final long MIN_HOLD_MS = 250;

    /** The automatic conflict check for a learned key. */
    public static List<Finding> check(Device dev, String code, Seen s) {
        List<Finding> f = new ArrayList<>();
        String name = dev == null ? "" : dev.name;
        if (s.officialPtt) f.add(new Finding(true, "This is the phone's own PTT key. It already transmits while Side PTT key is on, so it needs no learning."));
        if ("KEY_POWER".equals(code)) f.add(new Finding(true, "The power key turns the screen off, and holding it opens the power menu."));
        if (NAV.contains(code)) f.add(new Finding(true, "A navigation key (home, back, menu): the phone would act on it every time you talk."));
        if (dev != null && dev.touch) f.add(new Finding(true, "That came from the touch screen (a gesture), not from a button."));
        if (name.matches("(?i).*(fingerprint|fortsense|goodix|fpc|silead|chipone|uinput-).*")) f.add(new Finding(true, "That came from the fingerprint sensor, which reports swipes, not a button being held."));
        if (s.holdMs < 0) f.add(new Finding(true, "The button never reported being let go. Hold it for about two seconds, then release it."));
        else if (s.holdMs < MIN_HOLD_MS) f.add(new Finding(true, "It reported letting go after " + s.holdMs + " ms although it was held. This button doesn't report being held down, so it cannot work as push-to-talk."));
        for (String app : s.opened) f.add(new Finding(false, "Pressing it also brought " + app + " to the front. That will happen every time you talk; change that button's setting in the phone's Settings, or choose another button."));
        if ("KEY_VOLUMEUP".equals(code) || "KEY_VOLUMEDOWN".equals(code)) {
            f.add(new Finding(false, "Outside SignalDeck the phone still changes the volume while you hold it. SignalDeck puts the volume back when you let go."));
            if (s.volPtt && "KEY_VOLUMEUP".equals(code) && !name.toUpperCase(Locale.US).contains("ACCDET")) f.add(new Finding(false, "Volume-up transmits uses the same key on the Intercom page. It will be switched off, since this replaces it."));
        }
        if (MEDIA.contains(code)) {
            f.add(new Finding(false, "A media button: it still plays or pauses music, and a long hold may start the voice assistant."));
            if (s.wheelTalk) f.add(new Finding(false, "Steering-wheel play/pause talks is on. In the car that setting already uses play/pause; both together are fine but do the same thing."));
        }
        if ("KEY_CAMERA".equals(code) || "KEY_CAMERA_FOCUS".equals(code)) f.add(new Finding(false, "The camera button may open the camera."));
        if ("0005".equals(dev == null ? "" : dev.bus)) f.add(new Finding(false, "A Bluetooth button: it works while it is connected, and SignalDeck finds it again when it reconnects. Its battery and range decide whether a release gets through; the 28 s transmit limit stops a stuck transmission."));
        return f;
    }
    public static boolean blocked(List<Finding> f) { for (Finding x : f) if (x.block) return true; return false; }

    /** App packages from `wm_set_resumed_activity` / `am_set_resumed_activity` event-log lines, except ours. */
    public static List<String> openedApps(String events, String ownPkg) {
        List<String> out = new ArrayList<>();
        Matcher m = Pattern.compile("(?:wm|am)_set_resumed_activity: \\[\\d+,([^/,\\]]+)/").matcher(events);
        while (m.find()) { String p = m.group(1); if (!p.equals(ownPkg) && !out.contains(p)) out.add(p); }
        return out;
    }

    // ---- settings ----

    public static final class Key { public final String device, code; public final int androidKey; Key(String d, String c, int a) { device = d; code = c; androidKey = a; } }
    private static SharedPreferences prefs(Context c) { return c.getSharedPreferences("radio", Context.MODE_PRIVATE); }
    public static Key saved(Context c) {
        SharedPreferences p = prefs(c); String code = p.getString("pttKeyCode", null);
        return code == null ? null : new Key(p.getString("pttKeyDevice", ""), code, p.getInt("pttKeyAndroid", 0));
    }
    public static boolean enabled(Context c) { return prefs(c).getBoolean("pttKeyOn", false) && saved(c) != null; }
    public static void save(Context c, Key k) {
        SharedPreferences.Editor e = prefs(c).edit().putString("pttKeyDevice", k.device).putString("pttKeyCode", k.code).putInt("pttKeyAndroid", k.androidKey).putBoolean("pttKeyOn", true);
        if ("KEY_VOLUMEUP".equals(k.code) && !k.device.toUpperCase(Locale.US).contains("ACCDET")) e.putBoolean("volPtt", false);
        e.apply();
    }
    public static void setEnabled(Context c, boolean on) { prefs(c).edit().putBoolean("pttKeyOn", on).apply(); }

    // ---- learning ----

    /** The learn run's result: the key (null if none was pressed), its device and the checks. */
    public static final class Learned {
        public Key key; public Device device; public final Seen seen = new Seen(); public List<Finding> findings = new ArrayList<>(); public String error;
        public String label() { return key == null ? "No key" : friendly(key.device, key.code); }
    }

    /**
     * Waits up to {@code seconds} for a key press on any input device, then for its release, then 1.5 s more for
     * anything the press set off. Touches on the screen are ignored (they are not buttons). The caller blocks PTT
     * meanwhile ({@link RadioService#setPttLearning}) and routes the activity's key events to {@link #activityKey}.
     */
    public static Learned learn(Context c, DeviceProfile profile, int seconds, Consumer<String> progress) {
        Learned out = new Learned();
        Map<String, Device> devices = parseDevices(RootSetup.run("getevent -pl 2>/dev/null"));
        if (devices.isEmpty()) { out.error = "Could not read the phone's input devices. Learning a key needs root (Magisk)."; return out; }
        addBus(devices, RootSetup.run("cat /proc/bus/input/devices"));
        final boolean[] official = { false };
        android.content.BroadcastReceiver r = new android.content.BroadcastReceiver() { @Override public void onReceive(Context x, Intent i) { official[0] = true; } };
        android.content.IntentFilter filter = new android.content.IntentFilter();
        if (profile != null && profile.pttActions != null) for (String a : profile.pttActions) filter.addAction(a);
        try { if (Build.VERSION.SDK_INT >= 33) c.registerReceiver(r, filter, Context.RECEIVER_EXPORTED); else c.registerReceiver(r, filter); } catch (Throwable ignored) { }
        final int[] androidKey = { 0 };
        activityKey = e -> { if (androidKey[0] == 0 && e.getAction() == android.view.KeyEvent.ACTION_DOWN) androidKey[0] = e.getKeyCode(); };
        long started = System.currentTimeMillis();
        Process p = null;
        try {
            p = root("exec timeout " + seconds + " getevent -l");          // ends by itself: nothing left running as root
            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line, path = null, code = null; long down = 0;
            progress.accept("Press and hold the button you want to talk with, for about two seconds, then let go.");
            while ((line = br.readLine()) != null) {
                Event e = parse(line); if (e == null) continue;
                Device d = e.path == null ? null : devices.get(e.path);
                if (code == null) {
                    if (e.value != 1 || (d != null && d.touch) || e.code.startsWith("BTN_TOUCH") || e.code.startsWith("BTN_TOOL")) continue;
                    path = e.path; code = e.code; down = System.currentTimeMillis();
                    out.device = d;
                    progress.accept(friendly(d == null ? "" : d.name, code) + " is held… now let go.");
                } else if (code.equals(e.code) && (path == null || path.equals(e.path)) && e.value == 0) {
                    out.seen.holdMs = System.currentTimeMillis() - down;
                    progress.accept("Got it. Checking whether that button also does something else…");
                    break;
                }
            }
            if (code == null) { out.error = "No button was pressed within " + seconds + " seconds."; return out; }
            try { Thread.sleep(1500); } catch (InterruptedException ignored) { }
            out.key = new Key(out.device == null ? "" : out.device.name, code, androidKey[0]);
            out.seen.opened.addAll(openedApps(RootSetup.run(String.format(Locale.US, "logcat -d -b events -T %d.000 | grep -E '(wm|am)_set_resumed_activity'", started / 1000)), c.getPackageName()));
        } catch (Throwable t) { out.error = "Learning failed: " + t.getMessage(); return out; }
        finally {
            activityKey = null;
            if (p != null) p.destroy();
            try { c.unregisterReceiver(r); } catch (Throwable ignored) { }
        }
        out.seen.officialPtt = official[0];
        SharedPreferences pr = prefs(c);
        out.seen.volPtt = pr.getBoolean("volPtt", false); out.seen.wheelTalk = pr.getBoolean("wheelTalk", false);
        out.findings = check(out.device, out.key.code, out.seen);
        return out;
    }
    /** While learning: MainActivity hands its key events here (and swallows them). */
    public static volatile Consumer<android.view.KeyEvent> activityKey;

    private static Process root(String cmd) throws java.io.IOException {
        return new ProcessBuilder("su", "--mount-master", "--context", "u:r:magisk:s0", "-c", cmd).redirectErrorStream(true).start();
    }

    // ---- the running listener ----

    /** Reads the learned key's input device and keys/unkeys through {@code ptt}; restarts when the device comes back. */
    public static final class Listener {
        private final Context ctx; private final Consumer<Boolean> ptt; private final Consumer<String> log;
        private volatile boolean running; private volatile int gen; private volatile Process proc; private Thread thread;
        private volatile boolean held;
        private int[] savedVolumes; private int savedRinger = -1;
        public Listener(Context c, Consumer<Boolean> ptt, Consumer<String> log) { ctx = c.getApplicationContext(); this.ptt = ptt; this.log = log; }
        public boolean isRunning() { return running && proc != null; }
        public synchronized void start() {
            stop();
            final Key k = saved(ctx); if (k == null || !enabled(ctx)) return;
            running = true; final int g = ++gen;
            thread = new Thread(() -> loop(k, g), "custom-ptt-key"); thread.setDaemon(true); thread.start();
        }
        public synchronized void stop() {
            running = false; gen++;
            Process p = proc; proc = null;
            if (p != null) p.destroy();                  // its root getevent ends at the next event (closed pipe) or at the next start
            if (thread != null) thread.interrupt(); thread = null;
            release();
        }
        private void loop(Key k, int g) {
            long backoff = 5000; boolean missingLogged = false;
            while (running && gen == g) {
                String path = null;
                for (Device d : parseDevices(RootSetup.run("getevent -pl 2>/dev/null")).values()) if (d.name.equals(k.device) && d.keys.contains(k.code)) path = d.path;
                if (path == null) {
                    if (!missingLogged) { log.accept("custom PTT key: " + friendly(k.device, k.code) + " is not connected; waiting for it"); missingLogged = true; }
                    sleep(backoff); backoff = Math.min(backoff * 2, 60000); continue;
                }
                backoff = 5000; missingLogged = false;
                try {
                    RootSetup.run("pkill -f 'getevent -ql ' || true");      // a reader left from before (it outlives its su client)
                    Process p = root("exec getevent -ql " + path); proc = p;
                    log.accept("custom PTT key: listening for " + friendly(k.device, k.code));
                    BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
                    String line;
                    while (running && gen == g && (line = br.readLine()) != null) {
                        Event e = parse(line); if (e == null || !k.code.equals(e.code)) continue;
                        if (e.value == 1 && !held) { held = true; saveVolumes(k); ptt.accept(true); }
                        else if (e.value == 0 && held) release();
                    }
                } catch (Throwable t) { log.accept("custom PTT key: " + t.getMessage()); }
                release();                                   // the device went away while held: never leave the radio keyed
                if (running && gen == g) sleep(3000);
            }
        }
        private void release() {
            if (!held) return;
            held = false; ptt.accept(false);
            restoreVolumes();
        }
        private static void sleep(long ms) { try { Thread.sleep(ms); } catch (InterruptedException ignored) { } }

        private static final int[] STREAMS = { android.media.AudioManager.STREAM_MUSIC, android.media.AudioManager.STREAM_RING, android.media.AudioManager.STREAM_VOICE_CALL, android.media.AudioManager.STREAM_NOTIFICATION, android.media.AudioManager.STREAM_ALARM };
        /** A volume key still changes the volume while it is held; put it back afterwards. */
        private void saveVolumes(Key k) {
            savedVolumes = null;
            if (!"KEY_VOLUMEUP".equals(k.code) && !"KEY_VOLUMEDOWN".equals(k.code)) return;
            try {
                android.media.AudioManager am = (android.media.AudioManager) ctx.getSystemService(Context.AUDIO_SERVICE);
                int[] v = new int[STREAMS.length]; for (int i = 0; i < STREAMS.length; i++) v[i] = am.getStreamVolume(STREAMS[i]);
                savedVolumes = v; savedRinger = am.getRingerMode();
            } catch (Throwable ignored) { }
        }
        private void restoreVolumes() {
            final int[] v = savedVolumes; final int ringer = savedRinger; savedVolumes = null; if (v == null) return;
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(() -> {      // after the key's last repeat
                try {
                    android.media.AudioManager am = (android.media.AudioManager) ctx.getSystemService(Context.AUDIO_SERVICE);
                    try { if (ringer >= 0 && am.getRingerMode() != ringer) am.setRingerMode(ringer); } catch (Throwable ignored) { }   // silent needs Do Not Disturb access
                    for (int i = 0; i < STREAMS.length; i++) try { if (am.getStreamVolume(STREAMS[i]) != v[i]) am.setStreamVolume(STREAMS[i], v[i], 0); } catch (Throwable ignored) { }
                } catch (Throwable ignored) { }
            }, 300);
        }
    }
}
