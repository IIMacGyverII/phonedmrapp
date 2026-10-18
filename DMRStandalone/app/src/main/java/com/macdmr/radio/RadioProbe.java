package com.macdmr.radio;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Root-only radio probe for phones without a verified profile: finds the serial ports, derives the SELinux
 * rules the app needs from the ports' actual labels, puts each candidate port into raw mode at the module's
 * speed, sends the version query ({@code 68 34 01 01 …}) and records whatever comes back; reads and (if asked)
 * pulses the power-looking sysfs node; sniffs a second UART for raw PCM. Everything is appended to the latest
 * device report so the profile can be written from it.
 */
public final class RadioProbe {
    public interface Progress { void step(String s); }
    private RadioProbe() { }

    /** Open the port as this app (the live rules allow it), send the version query, collect 3 s of reply bytes as hex. */
    private static String javaQuery(String port) {
        StringBuilder hex = new StringBuilder();
        try (java.io.FileInputStream in = new java.io.FileInputStream(port); java.io.FileOutputStream out = new java.io.FileOutputStream(port)) {
            final byte[] buf = new byte[512]; final int[] got = { 0 };
            Thread t = new Thread(() -> { try { int n; while (got[0] < buf.length && (n = in.read(buf, got[0], buf.length - got[0])) > 0) got[0] += n; } catch (Throwable ignored) { } });
            t.setDaemon(true); t.start();
            Thread.sleep(300);
            out.write(new byte[] { 0x68, 0x34, 0x01, 0x01, (byte) 0x95, (byte) 0xB9, 0x00, 0x01, 0x01, 0x10 }); out.flush();
            Thread.sleep(3000);
            for (int i = 0; i < got[0]; i++) hex.append(String.format(Locale.US, "%02x ", buf[i] & 0xFF));
        } catch (Throwable e) { return "(open failed: " + e.getMessage() + ")"; }
        return hex.toString().trim();
    }

    public static String run(android.content.Context ctx, Progress p, boolean pulsePower) {
        StringBuilder r = new StringBuilder();
        if (!RootSetup.haveRoot()) return "Root is not granted: the probe needs Magisk root (Superuser → allow DMR Radio).";
        p.step("Labels");
        String ls = RootSetup.run("ls -Z /dev/ttyS* /dev/ttyMT* /dev/ttyHS* 2>/dev/null");
        r.append("Serial ports and labels:\n").append(ls).append('\n');
        List<String> types = new ArrayList<>(), ports = new ArrayList<>();
        for (String line : ls.split("\n")) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("u:object_r:(\\w+):s0\\s+(/dev/\\S+)").matcher(line);
            if (m.find()) { if (!types.contains(m.group(1))) types.add(m.group(1)); ports.add(m.group(2)); }
        }
        // live rules derived from the real labels (what a Magisk module for this phone will need)
        StringBuilder rules = new StringBuilder();
        for (String t : types) rules.append("allow untrusted_app ").append(t).append(" chr_file { open read write ioctl getattr lock }\ntypeattribute ").append(t).append(" mlstrustedobject\n");
        String sysls = RootSetup.run("ls -Z /sys/devices/platform/*dmr*/* /sys/devices/platform/*intercom*/* /sys/devices/platform/*walkie*/* /sys/devices/platform/*ptt*/* 2>/dev/null");
        for (String line : sysls.split("\n")) { java.util.regex.Matcher m = java.util.regex.Pattern.compile("u:object_r:(\\w+):s0").matcher(line); if (m.find() && !m.group(1).equals("sysfs") && !rules.toString().contains(" " + m.group(1) + " file")) rules.append("allow untrusted_app ").append(m.group(1)).append(" file { open read write getattr }\ntypeattribute ").append(m.group(1)).append(" mlstrustedobject\n"); }
        r.append("Derived sepolicy.rule lines:\n").append(rules).append('\n');
        try {
            File f = new File(System.getProperty("java.io.tmpdir", "/data/local/tmp"), "probe.rule");
            try (java.io.FileOutputStream o = new java.io.FileOutputStream(f)) { o.write(rules.toString().getBytes()); }
            RootSetup.run("chmod 644 " + f.getAbsolutePath());
            r.append("Applied live: ").append(RootSetup.run("magiskpolicy --live --apply " + f.getAbsolutePath() + " 2>&1")).append('\n');
        } catch (Throwable t) { r.append("live apply failed: ").append(t).append('\n'); }

        p.step("Power nodes");
        r.append("\nSysfs nodes:\n").append(sysls).append('\n');
        String powerNode = null;
        for (String line : sysls.split("\n")) { String path = line.trim().replaceAll(".*\\s(/sys/\\S+)$", "$1"); if (path.matches(".*/(pwd|power|intercom_power_control|intercom_pwd_control|enable|en)$")) { powerNode = path; break; } }
        if (powerNode != null) {
            r.append("Power-looking node: ").append(powerNode).append(" = ").append(RootSetup.run("cat " + powerNode)).append('\n');
            if (pulsePower) r.append("  write 1 → ").append(RootSetup.run("echo 1 > " + powerNode + " 2>&1; sleep 3; cat " + powerNode)).append('\n');
        } else r.append("No power-looking node found under /sys/devices/platform/*{dmr,intercom,walkie,ptt}*\n");

        p.step("Serial probe");
        for (String port : ports) {
            r.append("\n--- ").append(port).append(" ---\n");
            r.append("before: ").append(RootSetup.run("stty -F " + port + " -a 2>&1 | head -1")).append('\n');
            // first as the app itself, with the line as the stock app left it (toybox stty cannot set some MTK UARTs)
            String direct = javaQuery(port);
            r.append("  as-is (opened by the app, no stty): ").append(direct.isEmpty() ? "(nothing received)" : direct).append('\n');
            if (direct.contains("68 34") || direct.contains("bf aa")) { r.append("  ^ the DMR module answered on this port at its current line speed\n"); continue; }
            for (int baud : new int[] { 57600, 115200, 9600, 230400 }) {
                String out = RootSetup.run("stty -F " + port + " " + baud + " raw -echo 2>&1; " + "(timeout 3 cat " + port + " | head -c 400 | od -An -tx1 | tr -d '\\n' | cut -c1-600) & sleep 0.3; printf '\\x68\\x34\\x01\\x01\\x95\\xb9\\x00\\x01\\x01\\x10' > " + port + "; sleep 3.2; echo");
                String hex = out.replaceAll("\\s+", " ").trim();
                r.append(String.format(Locale.US, "  %6d baud (readback %s), after 0x34 query: %s\n", baud, RootSetup.run("stty -F " + port + " -a 2>&1 | head -1").replaceAll("(?s).*speed (\\d+) baud.*", "$1").trim(), hex.isEmpty() ? "(nothing received)" : hex));
                if (hex.contains("68 34") || hex.contains("bf aa")) { r.append("  ^ looks like the DMR module answered at ").append(baud).append(" baud\n"); break; }
            }
        }

        // a vendor serial opener we already have a wrapper class for: use it, it sets the line the right way
        p.step("Vendor serial library");
        for (java.io.File lib : DeviceReport.serialLibs(ctx, null)) {
            String syms = DeviceReport.jniSymbols(lib);
            if (syms.isEmpty()) continue;
            r.append("\n").append(lib.getAbsolutePath()).append(":\n").append(syms);
            if (syms.contains("com.pri.prizeinterphone.serial.port.SerialPort.open")) {
                r.append("  known wrapper class available: trying it on each port at 57600\n");
                if (com.pri.prizeinterphone.serial.port.SerialPort.load(ctx, lib.getAbsolutePath())) for (String port : ports) {
                    try {
                        com.pri.prizeinterphone.serial.port.SerialPort sp = com.pri.prizeinterphone.serial.port.SerialPort.openPort(port, 57600);
                        if (sp == null) { r.append("  ").append(port).append(": native open failed\n"); continue; }
                        java.io.FileInputStream in = new java.io.FileInputStream(sp.fd()); java.io.FileOutputStream out = new java.io.FileOutputStream(sp.fd());
                        final byte[] buf = new byte[512]; final int[] got = { 0 };
                        Thread t = new Thread(() -> { try { int n; while (got[0] < buf.length && (n = in.read(buf, got[0], buf.length - got[0])) > 0) got[0] += n; } catch (Throwable ignored) { } }); t.setDaemon(true); t.start();
                        Thread.sleep(300); out.write(new byte[] { 0x68, 0x34, 0x01, 0x01, (byte) 0x95, (byte) 0xB9, 0x00, 0x01, 0x01, 0x10 }); out.flush(); Thread.sleep(3000);
                        StringBuilder hex = new StringBuilder(); for (int i = 0; i < got[0]; i++) hex.append(String.format(Locale.US, "%02x ", buf[i] & 0xFF));
                        r.append("  ").append(port).append(" via vendor library @57600: ").append(hex.length() == 0 ? "(nothing received)" : hex.toString().trim()).append(hex.toString().contains("68 34") ? "  <- module answered" : "").append('\n');
                        try { in.close(); out.close(); } catch (Throwable ignored) { } sp.release();
                    } catch (Throwable t) { r.append("  ").append(port).append(": ").append(t).append('\n'); }
                }
            } else r.append("  no wrapper class for this JNI class yet: add one named exactly as above (see SerialPort.java) and the app can open the port the vendor way\n");
        }

        p.step("PCM sniff");
        for (String port : ports) {
            String out = RootSetup.run("stty -F " + port + " 230400 raw -echo 2>&1; timeout 2 cat " + port + " | head -c 4000 | wc -c");
            r.append(String.format(Locale.US, "%s @230400: %s bytes in 2 s%s\n", port, out.trim(), out.trim().matches("[1-9]\\d*") && Integer.parseInt(out.trim()) > 1000 ? "  (continuous stream — a PCM audio port?)" : ""));
        }
        r.append("\nSELinux denials during the probe:\n").append(RootSetup.run("logcat -d -b all 2>/dev/null | grep -i 'avc: denied' | tail -30")).append('\n');
        return r.toString();
    }
}
