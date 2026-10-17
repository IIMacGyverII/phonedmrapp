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
    public final String[] pttActions;    // framework broadcasts for the hardware PTT key
    public final String stockApp;        // package to disable while we own the UART
    public final String[] sepolicy;      // Magisk sepolicy.rule lines an untrusted app needs

    private DeviceProfile(String name, String controlPort, int baud, Audio audio, String pcmPort, int pcmBaud,
                          String powerNode, String pttNode, String powerOnToken, String[] pttActions,
                          String stockApp, String[] sepolicy) {
        this.name = name; this.controlPort = controlPort; this.baud = baud; this.audio = audio;
        this.pcmPort = pcmPort; this.pcmBaud = pcmBaud; this.powerNode = powerNode; this.pttNode = pttNode;
        this.powerOnToken = powerOnToken; this.pttActions = pttActions; this.stockApp = stockApp; this.sepolicy = sepolicy;
    }

    /** Ulefone Armor 26 Ultra (walkie-talkie model) — measured 2026-10-17. */
    public static final DeviceProfile ARMOR_26_ULTRA = new DeviceProfile(
            "Ulefone Armor 26 Ultra", "/dev/ttyS0", 57600, Audio.TINY_SERVICE, null, 0,
            "/sys/devices/platform/dmr009/pwd", "/sys/devices/platform/dmr009/ptt", "pwd :1",
            new String[] { "com.interphone.ptt.down", "com.interphone.ptt.up" },
            "com.pri.prizeinterphone",
            new String[] {
                    "allow untrusted_app ttyS_device chr_file { open read write ioctl getattr lock }",
                    "typeattribute ttyS_device mlstrustedobject",
                    "allow untrusted_app sysfs_prizefactory file { open read write getattr }",
                    "typeattribute sysfs_prizefactory mlstrustedobject" });

    /** Blackview Xplore 1 — from its QuickChat APK (docs/multi-device-xplore1-findings.md); SELinux labels unknown. */
    public static final DeviceProfile XPLORE_1 = new DeviceProfile(
            "Blackview Xplore 1", "/dev/ttyS0", 57600, Audio.UART_PCM, "/dev/ttyS1", 230400,
            "/sys/devices/platform/intercom/intercom_pwd_control", "/sys/devices/platform/intercom/intercom_ptt_control", "1",
            new String[] { "com.android.intent.ptt.down", "com.android.intent.ptt.up" },
            "com.chamsion.quickchat",
            new String[] {
                    "allow untrusted_app ttyS_device chr_file { open read write ioctl getattr lock }",
                    "typeattribute ttyS_device mlstrustedobject" });

    public static DeviceProfile detect() {
        String m = (Build.MANUFACTURER + " " + Build.MODEL + " " + Build.DEVICE).toLowerCase();
        if (new File("/sys/devices/platform/dmr009").exists() || m.contains("armor 26")) return ARMOR_26_ULTRA;
        if (new File("/sys/devices/platform/intercom").exists() || m.contains("xplore")) return XPLORE_1;
        return ARMOR_26_ULTRA;   // best guess; the UI shows the name so the user can tell
    }

    public SysfsGpio power() { return new SysfsGpio(powerNode, powerOnToken); }
}
