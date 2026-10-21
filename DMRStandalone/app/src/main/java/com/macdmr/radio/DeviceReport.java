package com.macdmr.radio;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Environment;
import android.view.KeyEvent;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.function.Consumer;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * Everything we need to write a device profile for a phone we have never seen, gathered on the phone itself:
 * build facts, serial ports, the sysfs nodes a radio module would use, the stock walkie-talkie app (its APK is
 * copied into the report), vendor libraries, framework jars, init scripts, running services — and, with root,
 * the SELinux labels, process contexts and the stock app's receivers (which reveal the PTT key broadcasts).
 * Output: {@code Download/DMR/DeviceReport/<model>_<time>/report.txt} plus the copied APKs, and one zip of it
 * all to share straight into a GitHub issue.
 */
public final class DeviceReport {
    public interface Progress { void step(String s); }
    private static final Pattern RADIO = Pattern.compile("(?i)intercom|interphone|walkie|dmr|ptt|quickchat|chamsion|prize|talkie|radio|sy88|uart|serial|tiny");
    private static final Pattern NODES = Pattern.compile("(?i)dmr|intercom|walkie|ptt|uart|radio|sy88|interphone|gpio");

    private DeviceReport() { }

    public static File reportRoot() { return new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "DMR/DeviceReport"); }

    /** Volatile hook the activity feeds hardware key events into while a PTT capture runs. */
    public static volatile Consumer<KeyEvent> keyCapture;
    /** Packages the last report took for the stock walkie-talkie app (the first-run check watches the first one). */
    public static volatile List<String> lastCandidates = new ArrayList<>();

    public static File generate(Context c, Progress p) throws Exception {
        String tag = (Build.MANUFACTURER + "_" + Build.MODEL).replaceAll("[^A-Za-z0-9._-]+", "_");
        File dir = new File(reportRoot(), tag + "_" + new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(new Date()));
        if (!dir.mkdirs() && !dir.isDirectory()) throw new Exception("cannot create " + dir);
        StringBuilder r = new StringBuilder();
        boolean root = suPresent() && RootSetup.haveRoot();

        p.step("Phone");
        h(r, "SignalDeck device report " + BuildConfig.VERSION_NAME + "  " + new Date());
        kv(r, "manufacturer", Build.MANUFACTURER); kv(r, "brand", Build.BRAND); kv(r, "model", Build.MODEL); kv(r, "device", Build.DEVICE); kv(r, "product", Build.PRODUCT);
        kv(r, "board", Build.BOARD); kv(r, "hardware", Build.HARDWARE); kv(r, "fingerprint", Build.FINGERPRINT); kv(r, "display", Build.DISPLAY);
        kv(r, "android", Build.VERSION.RELEASE + " (SDK " + Build.VERSION.SDK_INT + ", security patch " + Build.VERSION.SECURITY_PATCH + ")");
        kv(r, "abis", String.join(",", Build.SUPPORTED_ABIS)); kv(r, "kernel", System.getProperty("os.version"));
        kv(r, "selinux", cat("/sys/fs/selinux/enforce").trim().equals("1") ? "enforcing" : cat("/sys/fs/selinux/enforce").trim().equals("0") ? "permissive" : "unknown");
        kv(r, "su present", String.valueOf(suPresent())); kv(r, "root granted to this app", String.valueOf(root));
        kv(r, "magisk", root ? RootSetup.run("magisk -v 2>/dev/null; magisk -V 2>/dev/null").replace('\n', ' ') : "n/a");
        for (String prop : new String[] { "ro.product.model", "ro.board.platform", "ro.hardware", "ro.build.version.sdk", "ro.vendor.build.fingerprint", "persist.sys.usb.config", "ro.boot.verifiedbootstate" }) kv(r, prop, getprop(prop));
        DeviceProfile dp = DeviceProfile.detect();
        kv(r, "profile detected", dp.supported ? dp.name + (dp.verified ? "" : " (untested on hardware)") : "none (this is an unsupported phone)");

        p.step("Serial ports");
        h(r, "Serial ports (File API)");
        File[] dev = new File("/dev").listFiles();
        if (dev != null) for (File f : dev) if (f.getName().matches("tty(S|MT|HS|USB|GS|ACM)\\d*")) r.append(String.format(Locale.US, "  %-14s read=%s write=%s\n", f.getName(), f.canRead(), f.canWrite()));
        r.append(cat("/proc/tty/drivers"));
        if (root) { h(r, "Serial ports (root: labels, drivers)"); r.append(RootSetup.run("ls -lZ /dev/ttyS* /dev/ttyMT* /dev/ttyHS* /dev/ttyUSB* /dev/ttyGS* 2>/dev/null; echo; cat /proc/tty/drivers; echo; for t in /dev/ttyS*; do echo \"$t: $(stty -F $t -a 2>&1 | head -1)\"; done")).append('\n'); }

        p.step("Radio module nodes");
        h(r, "Platform devices that look like a radio module (/sys/devices/platform)");
        File[] plat = new File("/sys/devices/platform").listFiles();
        if (plat != null) for (File d : plat) if (NODES.matcher(d.getName()).find()) {
            r.append("  ").append(d.getName()).append('\n');
            File[] fs = d.listFiles();
            if (fs != null) for (File f : fs) if (f.isFile()) r.append(String.format(Locale.US, "      %-24s r=%s w=%s  %s\n", f.getName(), f.canRead(), f.canWrite(), f.canRead() ? cat(f.getAbsolutePath()).trim().replace('\n', ' ').substring(0, Math.min(80, cat(f.getAbsolutePath()).trim().length())) : ""));
        }
        if (root) r.append(RootSetup.run("for d in /sys/devices/platform/*dmr* /sys/devices/platform/*intercom* /sys/devices/platform/*walkie* /sys/devices/platform/*ptt* /sys/devices/platform/*sy88*; do [ -d \"$d\" ] && echo \"--- $d\" && ls -lZ \"$d\" && for f in \"$d\"/*; do [ -f \"$f\" ] && printf '%s = ' \"$f\" && (head -c 80 \"$f\" 2>&1; echo); done; done 2>/dev/null")).append('\n');
        if (root) {                                       // how the kernel describes the module's wiring: pin names, compatible string
            h(r, "Device tree of the radio module (root)");
            String dt = RootSetup.run("for d in /sys/devices/platform/*dmr*/of_node /sys/devices/platform/*intercom*/of_node /sys/devices/platform/*walkie*/of_node; do [ -d \"$d\" ] || continue; echo \"--- $d\"; for f in \"$d\"/*; do [ -f \"$f\" ] && echo \"$(basename \"$f\") $(od -An -tx1 -N160 \"$f\" | tr -s ' \\n' ' ')\"; done; done; true");
            for (String l : dt.split("\n")) {
                if (l.startsWith("---") || l.trim().isEmpty()) { r.append(l).append('\n'); continue; }
                String[] kv = l.trim().split(" ", 2);
                r.append("  ").append(kv[0]).append(" = ").append(kv.length > 1 ? dtValue(kv[1]) : "").append('\n');
            }
        }
        h(r, "GPIO / misc nodes"); r.append(root ? RootSetup.run("ls -lZ /dev/ | grep -iE 'dmr|intercom|walkie|ptt|gpio|misc' ; ls /sys/class/gpio 2>/dev/null | head -40") : ls("/sys/class/gpio", null)).append('\n');

        p.step("Walkie-talkie apps");
        h(r, "Installed apps that look like the stock walkie-talkie app");
        PackageManager pm = c.getPackageManager();
        List<String> candidates = new ArrayList<>(); lastCandidates = candidates;
        for (PackageInfo pi : pm.getInstalledPackages(PackageManager.GET_PERMISSIONS | PackageManager.GET_RECEIVERS | PackageManager.GET_SERVICES)) {
            if (pi.packageName.equals(c.getPackageName()) || !RADIO.matcher(pi.packageName).find()) continue;
            if (pi.packageName.matches("(?i).*(android\\.|google\\.|qualcomm|mediatek|mtk).*") && !pi.packageName.matches("(?i).*(intercom|interphone|walkie|dmr|ptt|quickchat).*")) continue;
            ApplicationInfo ai = pi.applicationInfo; boolean sys = (ai.flags & ApplicationInfo.FLAG_SYSTEM) != 0;
            r.append(String.format(Locale.US, "  %s  v%s  uid=%d  system=%s  shared=%s\n      apk=%s\n      nativeLibs=%s\n", pi.packageName, pi.versionName, ai.uid, sys, pi.sharedUserId, ai.sourceDir, ai.nativeLibraryDir));
            r.append("      libs: ").append(ls(ai.nativeLibraryDir, null)).append('\n');
            File[] libs = ai.nativeLibraryDir == null ? null : new File(ai.nativeLibraryDir).listFiles();
            if (libs == null && root && ai.nativeLibraryDir != null) libs = rootCopyLibs(c, ai.nativeLibraryDir, r);   // a system app's lib folder the app may not list
            if (libs != null) for (File lf : libs) if (lf.getName().endsWith(".so")) { File real = lf; try { real = lf.getCanonicalFile(); } catch (Throwable ignored) { } String syms = jniSymbols(real); if (syms.isEmpty()) syms = registeredNatives(real); if (!syms.isEmpty()) r.append("      ").append(lf.getName()).append(" -> ").append(real.getAbsolutePath()).append('\n').append(syms); }
            if (pi.requestedPermissions != null) { StringBuilder pp = new StringBuilder(); for (String q : pi.requestedPermissions) if (!q.startsWith("android.permission.") || q.matches(".*(SERIAL|SYSTEM_ALERT|RECORD_AUDIO|MODIFY_AUDIO|WRITE_SECURE|DEVICE_POWER|INJECT|BROADCAST).*")) pp.append(q).append(' '); r.append("      permissions: ").append(pp).append('\n'); }
            if (pi.receivers != null) { r.append("      receivers: "); for (android.content.pm.ActivityInfo x : pi.receivers) r.append(x.name).append(' '); r.append('\n'); }
            if (pi.services != null) { r.append("      services: "); for (android.content.pm.ServiceInfo x : pi.services) r.append(x.name).append(' '); r.append('\n'); }
            if (pi.packageName.matches("(?i).*(intercom|interphone|walkie|dmr|ptt|quickchat|chamsion|prize|talkie).*")) candidates.add(pi.packageName);
        }
        p.step("Ranking the walkie-talkie app candidates");
        List<RadioAppFinder.App> ranked = RadioAppFinder.rank(c);
        h(r, "Walkie-talkie app candidates, ranked (score: evidence)"); r.append(RadioAppFinder.describe(ranked));
        if (!ranked.isEmpty()) {                          // the evidence wins over package names; name matches stay only when nothing scored
            candidates.clear();
            for (RadioAppFinder.App x : ranked) if (candidates.size() < 3 && x.score >= 5) candidates.add(x.pkg);
            if (candidates.isEmpty()) candidates.add(ranked.get(0).pkg);
        }
        r.append("  examined below: ").append(String.join(", ", candidates)).append('\n');
        for (String pkg : candidates) {
            try {
                ApplicationInfo ai = pm.getApplicationInfo(pkg, 0);
                List<String> apks = new ArrayList<>(); apks.add(ai.sourceDir); if (ai.splitSourceDirs != null) for (String s : ai.splitSourceDirs) apks.add(s);
                for (String a : apks) { File src = new File(a); File dst = new File(dir, pkg + "_" + src.getName()); p.step("Copying " + pkg); if (copy(src, dst)) r.append("  copied ").append(dst.getName()).append(" (").append(dst.length() / 1024).append(" kB)\n"); else if (root) { RootSetup.run("cp " + a + " " + dst.getAbsolutePath() + " && chmod 644 " + dst.getAbsolutePath()); r.append("  copied with root ").append(dst.getName()).append('\n'); } }
            } catch (Throwable t) { r.append("  could not copy ").append(pkg).append(": ").append(t).append('\n'); }
            if (root) { h(r, "dumpsys package " + pkg + " (root)"); r.append(redact(RootSetup.run("dumpsys package " + pkg + " | grep -v '^ *$' | grep -iE 'Receiver|Service|Activity|action|filter|flags|codePath|resourcePath|nativeLibraryPath|primaryCpuAbi|versionName|sharedUser|uid=|perm' | head -300"))).append('\n'); }
            if (root) { h(r, "Databases of " + pkg + " (structure only: tables, columns, row counts; root)"); r.append(dbStructure(c, pkg)).append('\n'); }
            try { p.step("Reading " + pkg + "'s code"); h(r, "Clues in " + pkg + "'s code (paths, audio parameters, serial speeds, PTT log texts)"); r.append(apkClues(new File(pm.getApplicationInfo(pkg, 0).sourceDir))).append('\n'); }
            catch (Throwable t) { r.append("  ").append(t).append('\n'); }
        }

        p.step("System files");
        h(r, "Framework / vendor files of interest");
        for (String d : new String[] { "/system/framework", "/system_ext/framework", "/vendor/framework", "/system/lib64", "/system/lib", "/vendor/lib64", "/vendor/lib", "/system/etc/init", "/vendor/etc/init", "/system/etc/permissions", "/vendor/etc/permissions", "/system/priv-app", "/system/app", "/vendor/app", "/product/app", "/product/priv-app", "/system_ext/priv-app" })
            r.append(String.format(Locale.US, "  %-26s %s\n", d, ls(d, RADIO)));
        h(r, "Serial-looking system libraries and their JNI classes");
        for (File lf : serialLibs(c, null)) { String syms = jniSymbols(lf); if (syms.isEmpty()) syms = registeredNatives(lf); r.append("  ").append(lf.getAbsolutePath()).append(" (").append(lf.length() / 1024).append(" kB)\n").append(syms); }
        h(r, "Binder services"); r.append(exec("service list")).append('\n');
        h(r, "Audio clues (does radio audio go through Android's audio system?)");
        r.append(exec("getprop | grep -iE 'pdt|intercom|interphone|dmr|walkie|ptt|pcm' | grep -v -E 'known_codenames|macdmr' | head -40")).append('\n');
        if (root) r.append(RootSetup.run("grep -il -E 'pdt|intercom|interphone|dmr|walkie' /vendor/etc/*.xml /vendor/etc/audio/* /odm/etc/*.xml /system/etc/audio* 2>/dev/null | head; "
                + "for f in $(grep -il -E 'pdt|intercom|interphone|dmr|walkie' /vendor/etc/*.xml /vendor/etc/audio/* /odm/etc/*.xml 2>/dev/null | head -5); do echo \"--- $f\"; grep -i -E 'pdt|intercom|interphone|dmr|walkie' \"$f\" | head -20; done; "
                + "dumpsys media.audio_flinger 2>/dev/null | grep -i -E 'pdt|intercom|interphone|dmr|walkie' | grep -v macdmr | head -20; true")).append('\n');
        h(r, "Audio devices"); r.append(cat("/proc/asound/cards")).append(ls("/dev/snd", null)).append('\n');

        if (root) {
            p.step("Root extras");
            h(r, "Processes with a radio-looking name (root)"); r.append(RootSetup.run("ps -AZ | grep -iE 'intercom|interphone|walkie|dmr|ptt|quickchat|tiny|serial|uart' | grep -v grep")).append('\n');
            h(r, "Who holds the serial ports (root)"); r.append(RootSetup.run("for p in /proc/[0-9]*; do ls -l $p/fd 2>/dev/null | grep -q '/dev/tty' && echo \"$(cat $p/comm) ($(basename $p)): $(ls -l $p/fd 2>/dev/null | grep -o '/dev/tty[A-Za-z0-9]*' | sort -u | tr '\\n' ' ')\"; done")).append('\n');
            h(r, "Recent logcat lines mentioning the radio (root, redacted)"); r.append(redact(RootSetup.run("logcat -d -t 3000 2>/dev/null | grep -iE 'ptt|intercom|interphone|walkie|dmr|serial|tty|tiny' | tail -120"))).append('\n');
            h(r, "SELinux denials seen so far (root)"); r.append(RootSetup.run("logcat -d -b all 2>/dev/null | grep -i 'avc: denied' | tail -40; dmesg 2>/dev/null | grep -i 'avc: denied' | tail -40")).append('\n');
        } else {
            h(r, "Root"); r.append("  not available — with Magisk root the report also lists SELinux labels, which process holds the serial ports, and the stock app's receivers (the PTT key broadcasts).\n");
        }

        File txt = new File(dir, "report.txt");
        try (OutputStream o = new FileOutputStream(txt)) { o.write(r.toString().getBytes("UTF-8")); }
        p.step("Zipping");
        File zip = new File(new File(c.getCacheDir(), "share"), dir.getName() + ".zip"); zip.getParentFile().mkdirs();
        try (ZipOutputStream z = new ZipOutputStream(new FileOutputStream(zip))) {
            File[] fs = dir.listFiles();
            if (fs != null) for (File f : fs) { z.putNextEntry(new ZipEntry(f.getName())); try (InputStream in = new FileInputStream(f)) { byte[] b = new byte[65536]; int n; while ((n = in.read(b)) > 0) z.write(b, 0, n); } z.closeEntry(); }
        }
        return zip;
    }

    /** The newest report folder, or null. */
    /** The most recently created report folder (by the time in its name: appending to a report changes its mtime). */
    public static File newestDir() {
        File[] fs = reportRoot().listFiles(); if (fs == null) return null;
        File newest = null; for (File f : fs) if (f.isDirectory() && (newest == null || createdAt(f) > createdAt(newest))) newest = f;
        return newest;
    }

    /** When a report folder was made, from its name (…_yyyyMMdd_HHmmss); its mtime if the name has none. */
    public static long createdAt(File dir) {
        java.util.regex.Matcher m = Pattern.compile("_(\\d{8}_\\d{6})$").matcher(dir.getName());
        if (m.find()) try { return new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).parse(m.group(1)).getTime(); } catch (Throwable ignored) { }
        return dir.lastModified();
    }

    /** The report folder a follow-up step (listen check) should add to: the newest one if it was made today, else a new report. */
    public static File currentOrNew(Context c) {
        File d = newestDir();
        if (d != null && System.currentTimeMillis() - createdAt(d) < 12 * 3600_000L) return d;
        try { generate(c, s -> { }); } catch (Throwable ignored) { }
        return newestDir();
    }

    /**
     * Strings from the stock app's code and native libraries that tell how it drives the radio: every /sys and /dev path,
     * audio-system parameters ("pdt_play=off"), serial speeds, and log texts about PTT, receive, transmit, power and PCM
     * (QuickChat's "setPttLaunch" / "setPttReceive" told us that ptt_control 0 keys its transmitter). Only short ASCII
     * strings from the code, never resources or user data.
     */
    public static String apkClues(File apk) {
        java.util.TreeSet<String> paths = new java.util.TreeSet<>(), params = new java.util.TreeSet<>(), bauds = new java.util.TreeSet<>(), logs = new java.util.TreeSet<>();
        Pattern pPath = Pattern.compile("/(sys|dev|proc)/[A-Za-z0-9_./-]{2,80}"), pParam = Pattern.compile("\\b[a-z][a-z0-9_]{2,30}=(on|off|1|0|true|false)\\b"),
                pBaud = Pattern.compile("\\bB(9600|19200|38400|57600|115200|230400|460800|921600)\\b"),
                pLog = Pattern.compile("[ -~]{0,50}(?i:ptt|pcm|serial ?port|intercom|interphone|walkie|dmr)[ -~]{0,50}"),
                pFramework = Pattern.compile("(?i).*(activity|intent|content|receiver|launcher|shortcut|broadcast|permission|fragment|view|layout|leanback|androidx|java|kotlin).*");
        try (java.util.zip.ZipFile z = new java.util.zip.ZipFile(apk)) {
            java.util.Enumeration<? extends ZipEntry> en = z.entries();
            while (en.hasMoreElements()) {
                ZipEntry e = en.nextElement(); String n = e.getName();
                boolean dex = n.matches("classes\\d*\\.dex"), so = n.startsWith("lib/arm64") && n.endsWith(".so");
                if ((!dex && !so) || e.getSize() > 40_000_000) continue;
                byte[] b; try (InputStream in = z.getInputStream(e)) { java.io.ByteArrayOutputStream bo = new java.io.ByteArrayOutputStream(); byte[] t = new byte[65536]; int k; while ((k = in.read(t)) > 0) bo.write(t, 0, k); b = bo.toByteArray(); }
                // split into printable runs, as `strings` would
                StringBuilder run = new StringBuilder();
                for (int i = 0; i <= b.length; i++) {
                    int ch = i < b.length ? b[i] & 0xFF : 0;
                    if (ch >= 0x20 && ch < 0x7F) { if (run.length() < 200) run.append((char) ch); continue; }
                    if (run.length() >= 4) {
                        String s = run.toString();
                        if (dex && s.charAt(0) == s.length() - 1) s = s.substring(1);        // the dex string's length byte happened to be printable
                        java.util.regex.Matcher m = pPath.matcher(s); while (m.find()) paths.add(m.group());
                        m = pParam.matcher(s); while (m.find()) params.add(m.group());
                        m = pBaud.matcher(s); while (m.find()) bauds.add(m.group());
                        if (dex && s.length() <= 100 && logs.size() < 120 && !s.contains("/") && (s.contains(" ") || s.contains(":") || s.contains(","))
                                && pLog.matcher(s).matches() && !pFramework.matcher(s).matches()) logs.add(s.trim());           // log-like texts, not framework names
                    }
                    run.setLength(0);
                }
            }
        } catch (Throwable t) { return "  could not read " + apk + ": " + t + "\n"; }
        StringBuilder out = new StringBuilder();
        out.append("  paths: ").append(paths.isEmpty() ? "-" : String.join("  ", paths)).append('\n');
        out.append("  audio/system parameters: ").append(params.isEmpty() ? "-" : String.join("  ", params)).append('\n');
        out.append("  serial speeds: ").append(bauds.isEmpty() ? "-" : String.join(" ", bauds)).append('\n');
        out.append("  log texts about the radio:\n"); for (String s : logs) out.append("    ").append(mask(s)).append('\n');
        return out.toString();
    }

    /** A device-tree property from its hex dump: NUL-separated text ("coosea,dmr009") as text, anything else (GPIO specifiers, phandles) as 32-bit cells. */
    static String dtValue(String hex) {
        String[] hb = hex.trim().split("\\s+"); byte[] b = new byte[hb.length]; int n = 0;
        for (String h : hb) if (h.matches("[0-9a-fA-F]{2}")) b[n++] = (byte) Integer.parseInt(h, 16);
        boolean text = n > 0 && b[n - 1] == 0 && (b[0] & 0xFF) >= 0x20;
        for (int i = 0; i < n && text; i++) { int ch = b[i] & 0xFF; if (ch != 0 && (ch < 0x20 || ch > 0x7E)) text = false; }
        if (text) return "\"" + new String(b, 0, n - 1, java.nio.charset.StandardCharsets.ISO_8859_1).replace('\u0000', '|') + "\"";
        StringBuilder s = new StringBuilder("<");
        for (int i = 0; i + 3 < n; i += 4) s.append(i == 0 ? "" : " ").append(String.format(Locale.US, "0x%02x%02x%02x%02x", b[i], b[i + 1], b[i + 2], b[i + 3]));
        if (n % 4 != 0) for (int i = n - n % 4; i < n; i++) s.append(String.format(Locale.US, " %02x", b[i]));
        return s.append(">").toString();
    }

    /** Copy a library folder with root into the cache (to scan its JNI names); lists what it holds. */
    private static File[] rootCopyLibs(Context c, String dir, StringBuilder r) {
        File dst = new File(c.getCacheDir(), "libscan"); dst.mkdirs();
        String ls = RootSetup.run("ls " + dir + " 2>&1");
        r.append("      libs (root): ").append(ls.replace('\n', ' ')).append('\n');
        RootSetup.run("cp " + dir + "/*.so " + dst.getAbsolutePath() + "/ 2>/dev/null; chmod 644 " + dst.getAbsolutePath() + "/*; true");
        return dst.listFiles();
    }

    /** Tables, columns and row counts (never the rows) of the stock app's databases: what a channel importer needs. */
    private static String dbStructure(Context c, String pkg) {
        StringBuilder out = new StringBuilder();
        File dst = new File(c.getCacheDir(), "dbscan"); dst.mkdirs();
        String names = RootSetup.run("ls /data/data/" + pkg + "/databases/ 2>&1");
        out.append("  files: ").append(names.replace('\n', ' ')).append('\n');
        for (String n : names.split("\\s+")) {
            if (n.isEmpty() || n.endsWith("-wal") || n.endsWith("-shm") || n.endsWith("-journal") || n.contains("(")) continue;
            File f = new File(dst, n);
            String src = "/data/data/" + pkg + "/databases/" + n;
            RootSetup.run("cp " + src + " " + f + "; (cp " + src + "-wal " + f + "-wal; cp " + src + "-shm " + f + "-shm) 2>/dev/null; chmod 666 " + f + "*; chown $(stat -c %u:%g " + c.getCacheDir() + ") " + f + "*; true");
            try (android.database.sqlite.SQLiteDatabase db = android.database.sqlite.SQLiteDatabase.openDatabase(f.getAbsolutePath(), null, android.database.sqlite.SQLiteDatabase.OPEN_READWRITE)) {
                out.append("  ").append(n).append(":\n");
                try (android.database.Cursor t = db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'", null)) {
                    while (t.moveToNext()) {
                        String tn = t.getString(0); StringBuilder cols = new StringBuilder();
                        try (android.database.Cursor ci = db.rawQuery("PRAGMA table_info(\"" + tn + "\")", null)) { while (ci.moveToNext()) cols.append(ci.getString(1)).append(' '); }
                        long rows = 0; try (android.database.Cursor k = db.rawQuery("SELECT count(*) FROM \"" + tn + "\"", null)) { if (k.moveToFirst()) rows = k.getLong(0); }
                        out.append("    ").append(tn).append(" (").append(rows).append(" rows): ").append(cols.toString().trim()).append('\n');
                    }
                }
            } catch (Throwable e) { out.append("  ").append(n).append(": ").append(e.getMessage()).append('\n'); }
            for (File x : new File[] { f, new File(f + "-wal"), new File(f + "-shm") }) x.delete();
        }
        return out.toString();
    }

    /** Append a section to the newest report folder (PTT capture, radio probe). */
    public static File append(String title, String body) {
        File newest = newestDir();
        if (newest == null) return null;
        try (OutputStream o = new FileOutputStream(new File(newest, "report.txt"), true)) { o.write(("\n\n==== " + title + " ====\n" + body + "\n").getBytes("UTF-8")); } catch (Throwable ignored) { }
        return newest;
    }

    /** Re-zip the newest report folder (after appends) and return the zip. */
    public static File zipNewest(Context c) throws Exception { return zipNewest(c, true); }
    public static File zipNewest(Context c, boolean withApks) throws Exception {
        File newest = newestDir();
        if (newest == null) throw new Exception("no report yet");
        File zip = new File(new File(c.getCacheDir(), "share"), newest.getName() + (withApks ? "" : "_noapk") + ".zip"); zip.getParentFile().mkdirs();
        try (ZipOutputStream z = new ZipOutputStream(new FileOutputStream(zip))) {
            File[] in = newest.listFiles();
            if (in != null) for (File f : in) { if (!withApks && f.getName().endsWith(".apk")) continue; z.putNextEntry(new ZipEntry(f.getName())); try (InputStream i = new FileInputStream(f)) { byte[] b = new byte[65536]; int n; while ((n = i.read(b)) > 0) z.write(b, 0, n); } z.closeEntry(); }
        }
        return zip;
    }

    /** Open a new GitHub issue in the browser with the phone facts filled in; the zip is attached by hand (drag it into the issue). */
    public static void openIssue(Context c) {
        StringBuilder body = new StringBuilder("## Device support request\n\n");
        body.append("- Phone: ").append(Build.MANUFACTURER).append(' ').append(Build.MODEL).append(" (").append(Build.DEVICE).append(", ").append(Build.BOARD).append(")\n");
        body.append("- Android: ").append(Build.VERSION.RELEASE).append(" / SDK ").append(Build.VERSION.SDK_INT).append("\n- Build: ").append(Build.DISPLAY).append("\n- Platform: ").append(getprop("ro.board.platform")).append("\n");
        body.append("- Rooted (Magisk): ").append(suPresent() ? "yes" : "no").append("\n- SignalDeck app: ").append(BuildConfig.VERSION_NAME).append("\n\n");
        File newest = newestDir();
        if (newest != null) {
            body.append("Device report folder: `Download/DMR/DeviceReport/").append(newest.getName()).append("`\n**Please drag the report zip (Device → Share last report, or the folder zipped) into this issue.**\n\n");
            String rep = cat(new File(newest, "report.txt").getAbsolutePath());
            int a = rep.indexOf("==== Platform devices"), b = rep.indexOf("==== GPIO");
            if (a > 0 && b > a) body.append("Radio-module nodes found:\n```\n").append(rep, a, Math.min(b, a + 1500)).append("```\n");
            int s1 = rep.indexOf("==== Installed apps"), s2 = rep.indexOf("==== dumpsys", s1); if (s2 < 0) s2 = rep.indexOf("==== Framework", s1);
            if (s1 > 0 && s2 > s1) body.append("Walkie-talkie app(s):\n```\n").append(rep, s1, Math.min(s2, s1 + 1500)).append("```\n");
        } else body.append("(No device report generated yet — Device → Generate device report, then attach its zip.)\n");
        body.append("\nWhat the stock walkie-talkie app can do (DMR? FM? text? GPS?), and anything odd you noticed:\n\n");
        String title = "Device support: " + Build.MANUFACTURER + " " + Build.MODEL;
        String url = "https://github.com/IIMacGyverII/phonedmrapp/issues/new?title=" + android.net.Uri.encode(title) + "&labels=" + android.net.Uri.encode("device-support") + "&body=" + android.net.Uri.encode(body.length() > 6000 ? body.substring(0, 6000) + "\n…(trimmed; everything is in the zip)" : body.toString());
        try { c.startActivity(new Intent(Intent.ACTION_VIEW, android.net.Uri.parse(url)).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)); } catch (Throwable t) { android.widget.Toast.makeText(c, "No browser available", android.widget.Toast.LENGTH_LONG).show(); }
    }

    public static void share(Context c, File zip) {
        android.net.Uri u = androidx.core.content.FileProvider.getUriForFile(c, c.getPackageName() + ".files", zip);
        Intent i = new Intent(Intent.ACTION_SEND).setType("application/zip").putExtra(Intent.EXTRA_STREAM, u).putExtra(Intent.EXTRA_SUBJECT, "SignalDeck device report: " + Build.MANUFACTURER + " " + Build.MODEL)
                .putExtra(Intent.EXTRA_TEXT, "Device report for a DMR phone, generated by the SignalDeck app. Attach it to a GitHub issue at https://github.com/IIMacGyverII/phonedmrapp/issues").addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        c.startActivity(Intent.createChooser(i, "Share the device report").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
    }

    /**
     * PTT key capture: for {@code seconds}, record every hardware key the activity sees, every input event (root,
     * getevent), and every broadcast/log line that mentions ptt/intercom. The user presses the side button meanwhile.
     */
    static String[] pttActions() { return PTT_ACTIONS; }
    private static final String[] PTT_ACTIONS = { "com.interphone.ptt.down", "com.interphone.ptt.up", "com.android.intent.ptt.down", "com.android.intent.ptt.up", "android.intent.action.PTT.down", "android.intent.action.PTT.up", "android.intent.action.PTT", "com.runbo.ptt.key.down", "com.runbo.ptt.key.up", "com.android.action.ptt.down", "com.android.action.ptt.up", "android.intent.action.ptt.down", "android.intent.action.ptt.up", "com.sonim.intent.action.PTT_KEY_DOWN", "com.sonim.intent.action.PTT_KEY_UP", "com.kyocera.android.intent.action.PTT_BUTTON", "android.intent.action.PTT_BUTTON_DOWN", "android.intent.action.PTT_BUTTON_UP", "com.zello.ptt.down", "com.zello.ptt.up" };

    public static String captureKeys(Context c, int seconds) {
        final StringBuilder keys = new StringBuilder();
        final android.content.BroadcastReceiver br = new android.content.BroadcastReceiver() { @Override public void onReceive(Context ctx, Intent i) { keys.append("  broadcast ").append(i.getAction()).append(i.getExtras() != null ? " extras=" + i.getExtras() : "").append('\n'); } };
        android.content.IntentFilter f = new android.content.IntentFilter(); for (String a : PTT_ACTIONS) f.addAction(a);
        try { if (Build.VERSION.SDK_INT >= 33) c.registerReceiver(br, f, Context.RECEIVER_EXPORTED); else c.registerReceiver(br, f); } catch (Throwable ignored) { }
        keyCapture = e -> keys.append(String.format(Locale.US, "  key %s code=%d scan=%d device=%d flags=0x%x\n", e.getAction() == KeyEvent.ACTION_DOWN ? "DOWN" : "UP  ", e.getKeyCode(), e.getScanCode(), e.getDeviceId(), e.getFlags()));
        boolean root = suPresent() && RootSetup.haveRoot();
        String events = "", logs = "";
        try {
            if (root) {
                RootSetup.run("logcat -c");
                events = RootSetup.run("timeout " + seconds + " getevent -lt 2>&1 | grep -v 'SYN_REPORT' | head -200");
                logs = redact(RootSetup.run("logcat -d 2>/dev/null | grep -iE 'ptt|intercom|interphone|walkie|KeyEvent|keycode' | head -80"));
            } else Thread.sleep(seconds * 1000L);
        } catch (Throwable ignored) { }
        keyCapture = null;
        try { c.unregisterReceiver(br); } catch (Throwable ignored) { }
        return "Activity key events and known PTT broadcasts:\n" + (keys.length() == 0 ? "  (none reached the app)\n" : keys) + "\nInput events (root getevent):\n" + (events.isEmpty() ? "  (n/a)\n" : events + "\n") + "\nLog lines during the capture (root):\n" + (logs.isEmpty() ? "  (n/a)\n" : logs + "\n");
    }

    /** JNI entry points of a native library, by scanning for "Java_" symbol names: tells us the Java class the vendor's serial opener binds to. */
    public static String jniSymbols(File lib) {
        StringBuilder out = new StringBuilder();
        try (InputStream in = new FileInputStream(lib)) {
            byte[] b = new byte[(int) Math.min(lib.length(), 4_000_000)]; int n = 0, k; while (n < b.length && (k = in.read(b, n, b.length - n)) > 0) n += k;
            String s = new String(b, 0, n, "ISO-8859-1");
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("Java_([A-Za-z0-9_]+)").matcher(s);
            java.util.LinkedHashSet<String> seen = new java.util.LinkedHashSet<>();
            while (m.find()) {
                String sym = m.group(1); if (!seen.add(sym)) continue;
                int cut = sym.lastIndexOf('_'); if (cut <= 0) continue;
                String cls = sym.substring(0, cut).replace("_1", "\u0001").replace('_', '.').replace("\u0001", "_"), method = sym.substring(cut + 1).replaceFirst("__.*$", "");
                out.append("      JNI ").append(cls).append('.').append(method).append("()\n");
            }
        } catch (Throwable ignored) { }
        return out.toString();
    }

    /**
     * For a library without exported Java_ symbols (it calls RegisterNatives from JNI_OnLoad, like the Xplore 1's
     * libwonder_serialport.so): the Java class paths, method signatures and method-like names it carries as strings,
     * which is what a wrapper class needs.
     */
    public static String registeredNatives(File lib) {
        StringBuilder out = new StringBuilder();
        try (InputStream in = new FileInputStream(lib)) {
            byte[] b = new byte[(int) Math.min(lib.length(), 4_000_000)]; int n = 0, k; while (n < b.length && (k = in.read(b, n, b.length - n)) > 0) n += k;
            String s = new String(b, 0, n, "ISO-8859-1");
            if (!s.contains("JNI_OnLoad")) return "";
            java.util.LinkedHashSet<String> cls = new java.util.LinkedHashSet<>(), sig = new java.util.LinkedHashSet<>(), names = new java.util.LinkedHashSet<>();
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("[a-z][a-z0-9_]*(?:/[A-Za-z0-9_$]+){2,}").matcher(s);
            while (m.find()) if (!m.group().matches("(java|android|dalvik|system|vendor|apex|data|proc|dev|sys)/.*")) cls.add(m.group().replace('/', '.'));
            m = java.util.regex.Pattern.compile("\\([A-Za-z0-9/;\\[$]*\\)[A-Za-z0-9/;\\[$]+").matcher(s);
            while (m.find()) sig.add(m.group());
            m = java.util.regex.Pattern.compile("\u0000([a-z][A-Za-z0-9_]{2,30})(?=\u0000)").matcher(s);
            while (m.find()) if (m.group(1).matches("(?i).*(open|close|read|write|setup|serial|baud).*")) names.add(m.group(1));
            if (cls.isEmpty() && sig.isEmpty()) return "";
            out.append("      registered at load time; classes: ").append(String.join(" ", cls)).append('\n');
            out.append("      signatures: ").append(String.join(" ", sig)).append('\n');
            out.append("      method-like names: ").append(String.join(" ", names)).append('\n');
        } catch (Throwable ignored) { }
        return out.toString();
    }

    /** Serial-looking native libraries: the stock app's own plus anything in the system library folders. */
    public static List<File> serialLibs(Context c, String stockPkg) {
        List<File> out = new ArrayList<>();
        try { if (stockPkg != null && !stockPkg.isEmpty()) { String d = c.getPackageManager().getApplicationInfo(stockPkg, 0).nativeLibraryDir; File[] fs = d == null ? null : new File(d).listFiles(); if (fs != null) for (File f : fs) if (f.getName().endsWith(".so")) out.add(f); } } catch (Throwable ignored) { }
        for (String d : new String[] { "/system/lib64", "/vendor/lib64", "/system/lib", "/vendor/lib" }) { File[] fs = new File(d).listFiles(); if (fs != null) for (File f : fs) if (f.getName().matches("(?i).*(serial|uart|intercom|interphone|walkie|dmr).*\\.so")) out.add(f); }
        return out;
    }

    /** Log excerpts go into a report that may be posted publicly: drop message content, mask long numbers (DMR IDs, phone numbers), mask e-mails. */
    static String redact(String log) {
        if (log == null) return "";
        StringBuilder out = new StringBuilder();
        for (String line : log.split("\n")) {
            if (line.matches("(?i).*(msgContent|SmsMessage|content=|callNumber|passcode|password|token|api_key|apikey).*")) continue;
            out.append(mask(line)).append('\n');
        }
        return out.toString();
    }

    /** Long numbers (DMR IDs, phone numbers), e-mail addresses and amateur callsigns. */
    static String mask(String line) {
        return line.replaceAll("\\b\\d{6,}\\b", "######").replaceAll("[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", "***@***")
                .replaceAll("(?<![\\w.])[A-Z]{1,2}[0-9][A-Z]{1,3}(-[0-9]{1,2})?(?![\\w.])", "CALL");   // not inside a dotted firmware name (DMR003.UV4T.V022)
    }

    /** Frames whose bytes carry IDs, keys or message text: digital channel (own ID), encryption, caller info, texts. */
    private static final Pattern PRIVATE_FRAME = Pattern.compile("(?i).*cmd=0x(22|29|2b|2c|2d)\\b.*");

    /**
     * SignalDeck's own log for a report that may be posted publicly: what the radio and the app did (bring-up steps,
     * port and power lines, module answers, errors) stays; anything about people, places or content goes: packet,
     * position, message, caption and caller lines are dropped, coordinates (4+ decimals) and the rest masked.
     */
    public static String redactAppLog(List<String> lines) {
        StringBuilder out = new StringBuilder();
        for (String l : lines) {
            if (l.matches("(?i).*(aprs|packet|pkt|position|beacon|igate|digipeat|sms|text|message|caption|heard|caller|contact|location|gps|coverage|lat[ :=]|lon[ :=]|pin|passcode|password|token|key=|radioid|talker|from the web).*")) continue;
            if (PRIVATE_FRAME.matcher(l).matches()) l = l.replaceAll("\\[[^\\]]*\\]", "[…]").replaceAll("<[^>]*>", "<…>");
            out.append(mask(l).replaceAll("-?\\b\\d{1,3}\\.\\d{4,}\\b", "#.####")).append('\n');
        }
        return out.length() == 0 ? "(empty)\n" : out.toString();
    }

    // ---- helpers ----
    private static void h(StringBuilder r, String s) { r.append("\n==== ").append(s).append(" ====\n"); }
    private static void kv(StringBuilder r, String k, String v) { r.append(String.format(Locale.US, "  %-28s %s\n", k, v == null ? "" : v.trim())); }
    private static boolean suPresent() { for (String p : new String[] { "/system/bin/su", "/system/xbin/su", "/sbin/su", "/data/adb/magisk", "/debug_ramdisk/su" }) if (new File(p).exists()) return true; return false; }
    public static String cat(String path) { try (BufferedReader b = new BufferedReader(new InputStreamReader(new FileInputStream(path)))) { StringBuilder s = new StringBuilder(); String l; int n = 0; while ((l = b.readLine()) != null && n++ < 200) s.append(l).append('\n'); return s.toString(); } catch (Throwable t) { return ""; } }
    static String ls(String dir, Pattern filter) { File[] fs = dir == null ? null : new File(dir).listFiles(); if (fs == null) return "(not readable)"; StringBuilder s = new StringBuilder(); for (File f : fs) if (filter == null || filter.matcher(f.getName()).find()) s.append(f.getName()).append(' '); return s.length() == 0 ? "-" : s.toString(); }
    static String getprop(String k) { return exec("getprop " + k).trim(); }
    static String exec(String cmd) { try { Process p = new ProcessBuilder("sh", "-c", cmd).redirectErrorStream(true).start(); BufferedReader b = new BufferedReader(new InputStreamReader(p.getInputStream())); StringBuilder s = new StringBuilder(); String l; int n = 0; while ((l = b.readLine()) != null && n++ < 400) s.append(l).append('\n'); p.waitFor(); return s.toString(); } catch (Throwable t) { return "(" + t.getMessage() + ")"; } }
    public static boolean copyFile(File src, File dst) { return copy(src, dst); }
    private static boolean copy(File src, File dst) { try (InputStream i = new FileInputStream(src); OutputStream o = new FileOutputStream(dst)) { byte[] b = new byte[65536]; int n; while ((n = i.read(b)) > 0) o.write(b, 0, n); return true; } catch (Throwable t) { return false; } }
}
