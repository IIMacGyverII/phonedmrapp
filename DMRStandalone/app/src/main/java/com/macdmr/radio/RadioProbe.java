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

    /** Labels of ports that belong to another subsystem (the Armor's ttyS1 is the modem mux, mt6825muxd_device): never written to, never opened up. */
    private static final java.util.regex.Pattern OTHER_USE = java.util.regex.Pattern.compile("(?i)mux|modem|ccci|radio|gps|gnss|bt_|bluetooth|nfc|console|wifi|wlan|fm_");
    private static final String QUERY = "printf '\\x68\\x34\\x01\\x01\\x95\\xb9\\x00\\x01\\x01\\x10' > ";

    public static String run(android.content.Context ctx, Progress p, boolean pulsePower) {
        StringBuilder r = new StringBuilder();
        if (!RootSetup.haveRoot()) return "Root is not granted: the probe needs Magisk root (Superuser → allow SignalDeck).";
        p.step("Labels");
        String ls = RootSetup.run("ls -Z /dev/ttyS* /dev/ttyMT* /dev/ttyHS* 2>/dev/null; true");
        r.append("Serial ports and labels:\n").append(ls).append('\n');
        String holders = portHolders();
        r.append("Processes holding a serial port:\n").append(holders.isEmpty() ? "  (none)" : "  " + holders).append('\n');
        List<String> types = new ArrayList<>(), ports = new ArrayList<>();
        for (String line : ls.split("\n")) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("u:object_r:(\\w+):s0\\s+(/dev/\\S+)").matcher(line);
            if (!m.find()) continue;
            String label = m.group(1), port = m.group(2), held = heldBy(holders, port);
            // a port another process has open would lose its line settings; a modem/GNSS/BT port is not the radio module
            if (OTHER_USE.matcher(label).find()) { r.append("  skipped ").append(port).append(": its label ").append(label).append(" belongs to another subsystem\n"); continue; }
            if (held != null) { r.append("  skipped ").append(port).append(": in use by ").append(held).append(held.contains(ctx.getPackageName()) ? " (this app: Hand back first)" : " (close that app and probe again)").append('\n'); continue; }
            if (!types.contains(label)) types.add(label);
            ports.add(port);
        }
        // live rules derived from the real labels (what a Magisk module for this phone will need)
        StringBuilder rules = new StringBuilder();
        for (String t : types) rules.append("allow untrusted_app ").append(t).append(" chr_file { open read write ioctl getattr lock }\ntypeattribute ").append(t).append(" mlstrustedobject\n");
        String sysls = RootSetup.run("ls -Z /sys/devices/platform/*dmr*/* /sys/devices/platform/*intercom*/* /sys/devices/platform/*walkie*/* /sys/devices/platform/*ptt*/* 2>/dev/null; true");
        boolean plainSysfs = false;
        for (String line : sysls.split("\n")) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("u:object_r:(\\w+):s0").matcher(line);
            if (!m.find()) continue;
            if (m.group(1).equals("sysfs")) {                                      // opening all of sysfs to apps is not acceptable: the app writes these through root
                if (line.matches(".*/(pwd|ptt|pd|power|enable|en|\\w+_control)\\s*$")) plainSysfs = true;
                continue;
            }
            if (!rules.toString().contains(" " + m.group(1) + " file")) rules.append("allow untrusted_app ").append(m.group(1)).append(" file { open read write getattr }\ntypeattribute ").append(m.group(1)).append(" mlstrustedobject\n");
        }
        r.append("Derived sepolicy.rule lines:\n").append(rules.length() == 0 ? "  (none)\n" : rules);
        if (plainSysfs) r.append("  (module nodes with the plain sysfs label: no rule, the app uses root for them)\n");
        r.append('\n');
        if (rules.length() > 0) try {
            File f = new File(ctx.getCacheDir(), "probe.rule");
            try (java.io.FileOutputStream o = new java.io.FileOutputStream(f)) { o.write(rules.toString().getBytes()); }
            RootSetup.run("chmod 644 " + f.getAbsolutePath());
            r.append("Applied live (until reboot): ").append(RootSetup.run("magiskpolicy --live --apply " + f.getAbsolutePath() + " 2>&1")).append('\n');
        } catch (Throwable t) { r.append("live apply failed: ").append(t).append('\n'); }

        p.step("Power nodes");
        r.append("\nSysfs nodes:\n").append(sysls).append('\n');
        r.append(RootSetup.run("for f in /sys/devices/platform/*dmr*/* /sys/devices/platform/*intercom*/*; do [ -f \"$f\" ] && [ -r \"$f\" ] && echo \"  $f = $(head -c 80 \"$f\" 2>&1 | tr '\\n' ' ')\"; done; true")).append('\n');
        String powerNode = null;
        for (String line : sysls.split("\n")) { String path = line.trim().replaceAll(".*\\s(/sys/\\S+)$", "$1"); if (path.matches(".*/(pwd|power|intercom_power_control|intercom_pwd_control|enable|en)$")) { powerNode = path; break; } }
        if (powerNode != null) {
            r.append("Power-looking node: ").append(powerNode).append(" = ").append(RootSetup.run("cat " + powerNode)).append('\n');
            DeviceProfile prof = DeviceProfile.detect();
            if (pulsePower && prof.lineSetup != null) for (String[] l : prof.lineSetup) r.append("  first ").append(l[0]).append(" = ").append(l[1]).append(": ").append(RootSetup.run("echo " + l[1] + " > " + l[0] + " 2>&1 && echo ok")).append('\n');
            if (pulsePower && prof.supported && prof.powerNode != null) powerNode = prof.powerNode;      // the profile knows which line powers the module
            if (pulsePower && !prof.supported) r.append("  (no power pulse on a phone without a profile: which line keys the transmitter is unknown)\n");
            else if (pulsePower) r.append("  write 1 to ").append(powerNode).append(" → ").append(RootSetup.run("echo 1 > " + powerNode + " 2>&1; sleep 3; cat " + powerNode)).append('\n');
        } else r.append("No power-looking node found under /sys/devices/platform/*{dmr,intercom,walkie,ptt}*\n");

        p.step("Serial probe");
        for (String port : ports) {
            r.append("\n--- ").append(port).append(" ---\n");
            r.append("before: ").append(RootSetup.run("stty -F " + port + " -a 2>&1 | head -1")).append('\n');
            String saved = RootSetup.run("stty -F " + port + " -g 2>/dev/null").trim();     // put the line back exactly as it was
            try { probePort(r, port); }
            finally { r.append("  line settings put back: ").append(restore(port, saved)).append('\n'); }
        }

        p.step("Vendor serial library");
        probeVendorLibs(ctx, r, ports);

        p.step("PCM sniff");
        for (String port : ports) {
            String saved = RootSetup.run("stty -F " + port + " -g 2>/dev/null").trim();
            String out = RootSetup.run("stty -F " + port + " 230400 raw -echo 2>&1; timeout 2 cat " + port + " | head -c 4000 | wc -c").trim();
            restore(port, saved);
            r.append(String.format(Locale.US, "%s @230400: %s bytes in 2 s%s\n", port, out, out.matches("[1-9]\\d*") && Integer.parseInt(out) > 1000 ? "  (continuous stream — a PCM audio port?)" : ""));
        }
        r.append("\nSELinux denials during the probe:\n").append(RootSetup.run("logcat -d -b all 2>/dev/null | grep -i 'avc: denied' | tail -30")).append('\n');
        return r.toString();
    }

    private static String restore(String port, String saved) {
        if (!saved.matches("[0-9a-fA-F:]+")) return "(could not read them beforehand)";
        RootSetup.run("stty -F " + port + " " + saved);
        return RootSetup.run("stty -F " + port + " -g 2>/dev/null").trim().equals(saved) ? "yes" : "NO: " + RootSetup.run("stty -F " + port + " -a 2>&1 | head -1");
    }

    /** One line per process with a tty open: "  cmdline (pid): /dev/ttyX …". */
    private static String portHolders() {
        return RootSetup.run("for p in /proc/[0-9]*; do t=$(ls -l $p/fd 2>/dev/null | grep -o '/dev/tty[A-Za-z]*[0-9]*' | sort -u | tr '\\n' ' '); [ -n \"$t\" ] && echo \"  $(tr '\\0' ' ' < $p/cmdline 2>/dev/null | cut -c1-60) ($(basename $p)): $t\"; done; true");
    }
    private static String heldBy(String holders, String port) {
        for (String l : holders.split("\n")) if ((l + " ").contains(port + " ")) return l.trim().replaceAll(":\\s+/dev/.*$", "");
        return null;
    }

    private static void probePort(StringBuilder r, String port) {
        // first as the app itself, with the line as it is (toybox stty cannot set some MTK UARTs)
        String direct = javaQuery(port);
        r.append("  as-is (opened by the app, no stty): ").append(direct.isEmpty() ? "(nothing received)" : direct).append('\n');
        if (direct.contains("68 34") || direct.contains("bf aa")) { r.append("  ^ the DMR module answered on this port at its current line speed\n"); return; }
        for (int baud : new int[] { 57600, 115200, 9600, 230400 }) {
            String out = RootSetup.run("stty -F " + port + " " + baud + " raw -echo 2>&1; " + "(timeout 3 cat " + port + " | head -c 400 | od -An -tx1 | tr -d '\\n' | cut -c1-600) & sleep 0.3; " + QUERY + port + "; sleep 3.2; echo");
            String hex = out.replaceAll("\\s+", " ").trim();
            r.append(String.format(Locale.US, "  %6d baud (readback %s), after 0x34 query: %s\n", baud, RootSetup.run("stty -F " + port + " -a 2>&1 | head -1").replaceAll("(?s).*speed (\\d+) baud.*", "$1").trim(), hex.isEmpty() ? "(nothing received)" : hex));
            if (hex.contains("68 34") || hex.contains("bf aa")) { r.append("  ^ looks like the DMR module answered at ").append(baud).append(" baud\n"); return; }
        }
    }

    /** Serial libraries of the system and the stock app; one with a wrapper class we already have is tried on each port. */
    private static void probeVendorLibs(android.content.Context ctx, StringBuilder r, List<String> ports) {
        DeviceProfile dp = DeviceProfile.detect();
        for (java.io.File lib : DeviceReport.serialLibs(ctx, dp.stockApp.isEmpty() ? null : dp.stockApp)) {
            String syms = DeviceReport.jniSymbols(lib);
            if (syms.isEmpty()) {
                String reg = DeviceReport.registeredNatives(lib);
                if (!reg.isEmpty()) r.append("\n").append(lib.getAbsolutePath()).append(" (registers its methods at load time):\n").append(reg);
                continue;
            }
            r.append("\n").append(lib.getAbsolutePath()).append(":\n").append(syms);
            if (!syms.contains("com.pri.prizeinterphone.serial.port.SerialPort.open")) { r.append("  no wrapper class for this JNI class yet: add one named exactly as above (see SerialPort.java) and the app can open the port the vendor way\n"); continue; }
            r.append("  known wrapper class available: trying it on each port at 57600\n");
            if (!com.pri.prizeinterphone.serial.port.SerialPort.load(ctx, lib.getAbsolutePath())) continue;
            for (String port : ports) {
                String saved = RootSetup.run("stty -F " + port + " -g 2>/dev/null").trim();
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
                finally { restore(port, saved); }
            }
        }
    }
}
