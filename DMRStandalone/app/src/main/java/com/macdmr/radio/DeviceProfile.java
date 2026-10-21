package com.macdmr.radio;

import android.os.Build;

import java.io.File;

/**
 * Everything that differs between phones that carry this DMR module family. The protocol itself
 * (RadioEngine) is shared. Detection: build fingerprint first, then which sysfs nodes exist.
 */
public final class DeviceProfile {
    public enum Audio { TINY_SERVICE, UART_PCM }

    public final String name;
    public final String controlPort;     // MCU command UART
    public final int baud;
    public final Audio audio;
    public final String pcmPort;         // UART_PCM only
    public final int pcmBaud;
    public final String powerNode;       // pwd / power enable
    public final String pttNode;         // hardware PTT line (module side)
    public final String powerOnToken;    // read() value when powered
    public final String[] pttActions;    // framework broadcasts for the hardware PTT key: down/up pairs (even index = down, odd = up)
    public final String stockApp;        // package to disable while we own the UART
    public final String[] sepolicy;      // Magisk sepolicy.rule lines an untrusted app needs
    public final String serialLib;       // the stock app's serial JNI library on /system (configures the line); null = stty fallback
    public final boolean supported;      // false = a phone we have no profile for: discovery mode only
    public final boolean verified;       // false = written from an APK and dumps, never run on the phone: no automatic take-over, no transmit
    public String id = "unknown";      // stable profile id (the profile list matches on it)
    public int revision;                 // higher = newer; the profile list only ever replaces a built-in profile with a higher one
    public String source = "built-in";  // or "updated" (from the signed profile list)
    public boolean txBlocked;            // an advisory switched transmit off (the owner can override it)
    public String restrictedBy;          // the advisory id that restricted this copy, or null
    public boolean globalSquelch;        // the module follows its global squelch (0x30) rather than the channel's sq byte: send it with every analog channel
    public String[][] lineSetup;         // {node, value} written in this order before the power line, every bring-up (null = none)

    private DeviceProfile(String name, String controlPort, int baud, Audio audio, String pcmPort, int pcmBaud,
                          String powerNode, String pttNode, String powerOnToken, String[] pttActions,
                          String stockApp, String[] sepolicy, String serialLib, boolean supported, boolean verified) {
        this.name = name; this.controlPort = controlPort; this.baud = baud; this.audio = audio;
        this.pcmPort = pcmPort; this.pcmBaud = pcmBaud; this.powerNode = powerNode; this.pttNode = pttNode;
        this.powerOnToken = powerOnToken; this.pttActions = pttActions; this.stockApp = stockApp; this.sepolicy = sepolicy; this.serialLib = serialLib; this.supported = supported; this.verified = verified;
    }

    /** Ulefone Armor 26 Ultra (walkie-talkie model) — measured 2026-10-17. */
    public static final DeviceProfile ARMOR_26_ULTRA = new DeviceProfile(
            "Ulefone Armor 26 Ultra", "/dev/ttyS0", 57600, Audio.TINY_SERVICE, null, 0,
            "/sys/devices/platform/dmr009/pwd", "/sys/devices/platform/dmr009/ptt", "pwd :1",
            // the framework ("smartlinkkey", KEY_SAT keycode 381) sends android.intent.action.PTT.down/up for the side key;
            // com.interphone.ptt.down/up is what the stock app listens for when the key is assigned to it (measured 2026-10-18)
            new String[] { "android.intent.action.PTT.down", "android.intent.action.PTT.up", "com.interphone.ptt.down", "com.interphone.ptt.up" },
            "com.pri.prizeinterphone",
            new String[] {
                    "allow untrusted_app ttyS_device chr_file { open read write ioctl getattr lock }",
                    "typeattribute ttyS_device mlstrustedobject",
                    "allow untrusted_app sysfs_prizefactory file { open read write getattr }",
                    "typeattribute sysfs_prizefactory mlstrustedobject" },
            "/system/lib64/libinterphone_serial_port.so", true, true);

    /**
     * Blackview Xplore 1 — from its QuickChat APK and an owner's dumps (docs/multi-device-xplore1-findings.md): ttyS0/ttyS1
     * are ttyS_device, the intercom_* nodes plain sysfs (mode 0777, so SELinux is the only gate; SysfsGpio writes them
     * through root rather than opening all of sysfs to apps). Not run on the phone yet: unverified.
     */
    public static final DeviceProfile XPLORE_1 = new DeviceProfile(
            "Blackview Xplore 1", "/dev/ttyS0", 57600, Audio.UART_PCM, "/dev/ttyS1", 230400,
            "/sys/devices/platform/intercom/intercom_pwd_control", "/sys/devices/platform/intercom/intercom_ptt_control", "1",
            new String[] { "com.android.intent.ptt.down", "com.android.intent.ptt.up" },
            "com.chamsion.quickchat",
            new String[] {
                    "allow untrusted_app ttyS_device chr_file { open read write ioctl getattr lock }",
                    "typeattribute ttyS_device mlstrustedobject" },
            null, true, false);
    static {
        // QuickChat's power-up (j0.a.run): power_control, pwd_control and ptt_control all 1; its power-off writes all 0, and
        // ptt_control 0 is its transmit state (setPttLaunch). So the PTT line goes to receive first, before the module is
        // powered, or a module left by QuickChat's power-off would come up with its PTT line asserted.
        ARMOR_26_ULTRA.id = "ulefone-armor26ultra"; ARMOR_26_ULTRA.revision = 1;
        XPLORE_1.id = "blackview-xplore1"; XPLORE_1.revision = 1;
        XPLORE_1.globalSquelch = true;        // QuickChat sends 0x30 after each channel; the beta.3/5 trials showed the channel's sq 0 alone did not open it
        XPLORE_1.lineSetup = new String[][] {
                { "/sys/devices/platform/intercom/intercom_ptt_control", "1" },
                { "/sys/devices/platform/intercom/intercom_power_control", "1" } };
    }

    /** Any other phone: nothing is touched until a device report has been made and a profile written. */
    public static final DeviceProfile UNKNOWN = new DeviceProfile(
            Build.MANUFACTURER + " " + Build.MODEL + " (not supported yet)", "/dev/ttyS0", 57600, Audio.TINY_SERVICE, null, 0,
            null, null, "1", null, "", new String[0], null, false, false);

    /** The profile in use: a built-in one, or a newer one from the signed profile list, with any advisories applied. */
    public static DeviceProfile detect() { return ProfileRegistry.active(); }

    /** The profile built into this release for this phone (no profile list, no advisories). */
    public static DeviceProfile detectBuiltIn() {
        String m = (Build.MANUFACTURER + " " + Build.MODEL + " " + Build.DEVICE).toLowerCase();
        if (new File("/sys/devices/platform/dmr009").exists() || m.contains("armor 26")) return ARMOR_26_ULTRA;
        if (new File("/sys/devices/platform/intercom").exists() || m.contains("xplore")) return XPLORE_1;
        return UNKNOWN;
    }

    public SysfsGpio power() { return new SysfsGpio(powerNode, powerOnToken); }

    /** The same profile with other support flags (an advisory's restricted copy). */
    DeviceProfile copy(boolean supported, boolean verified) {
        DeviceProfile p = new DeviceProfile(name, controlPort, baud, audio, pcmPort, pcmBaud, powerNode, pttNode, powerOnToken, pttActions, stockApp, sepolicy, serialLib, supported, verified);
        p.id = id; p.revision = revision; p.source = source; p.txBlocked = txBlocked; p.restrictedBy = restrictedBy; p.globalSquelch = globalSquelch; p.lineSetup = lineSetup;
        return p;
    }

    /** A profile from the signed profile list (same fields as the constants above). */
    static DeviceProfile fromJson(org.json.JSONObject o) throws org.json.JSONException {
        DeviceProfile p = new DeviceProfile(o.getString("name"), o.getString("controlPort"), o.getInt("baud"), Audio.valueOf(o.getString("audio")),
                o.optString("pcmPort", null), o.optInt("pcmBaud", 0), o.optString("powerNode", null), o.optString("pttNode", null), o.optString("powerOnToken", "1"),
                strings(o.optJSONArray("pttActions")), o.optString("stockApp", ""), strings(o.optJSONArray("sepolicy")), o.optString("serialLib", null),
                o.optBoolean("supported", true), o.optBoolean("verified", false));
        p.id = o.getString("id"); p.revision = o.getInt("revision"); p.globalSquelch = o.optBoolean("globalSquelch", false);
        org.json.JSONArray ls = o.optJSONArray("lineSetup");
        if (ls != null) { p.lineSetup = new String[ls.length()][]; for (int i = 0; i < ls.length(); i++) p.lineSetup[i] = strings(ls.getJSONArray(i)); }
        return p;
    }
    private static String[] strings(org.json.JSONArray a) {
        if (a == null) return new String[0];
        String[] s = new String[a.length()]; for (int i = 0; i < s.length; i++) s[i] = a.optString(i);
        return s;
    }
}
