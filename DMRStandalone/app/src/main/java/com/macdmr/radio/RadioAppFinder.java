package com.macdmr.radio;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * Which installed app is the phone's own walkie-talkie app? Matching package names alone fails both ways (on the Xplore 1
 * "com.chamsion.systemupdater" matched before QuickChat; a "com.vendor.pocradio" would match nothing), so every system app
 * that is not Google's or a plain framework part is scored on evidence: it holds a serial port right now, it ships a serial
 * library, its code names /dev/tty or radio-module sysfs paths, it listens for PTT key broadcasts, it has a launcher icon,
 * its name sounds like it. Updaters, providers, overlays and the like are left out.
 */
public final class RadioAppFinder {
    public static final class App {
        public String pkg, label; public int score; public boolean launcher; public final List<String> why = new ArrayList<>();
        @Override public String toString() { return label + " (" + pkg + ")"; }
    }
    private RadioAppFinder() { }

    private static final Pattern NAME = Pattern.compile("(?i)intercom|interphone|walkie|talkie|dmr|ptt|poc|quickchat|radio|talkback");
    private static final Pattern NOT_IT = Pattern.compile("(?i).*(updat|\\.ota|provider|overlay|theme|wallpaper|launcher|inputmethod|keyboard|printspooler|\\.cts|test|backup|"
            + "telephony|\\.phone$|\\.stk|ims|\\.radio\\.service|fmradio|wifi|bluetooth|\\.nfc|camera|gallery|music|\\.sms|mms|contacts|dialer|settings|systemui|setupwizard).*");
    private static final Pattern FRAMEWORK = Pattern.compile("^(android|com\\.google\\..*|com\\.android\\..*|com\\.qualcomm\\..*|vendor\\.qti\\..*|com\\.mediatek\\..*)$");
    private static final byte[][] DEX_MARKERS = { "/dev/ttyS".getBytes(), "/dev/ttyMT".getBytes(), "/dev/ttyHS".getBytes(), "/sys/devices/platform/".getBytes() };

    private static volatile List<App> cache; private static volatile long cachedAt;

    /** Ranked best first (score ≥ 4 only). Runs su and reads APKs: call off the main thread; cached for 10 minutes. */
    public static List<App> rank(Context c) {
        List<App> cached = cache;
        if (cached != null && System.currentTimeMillis() - cachedAt < 600_000) return cached;
        PackageManager pm = c.getPackageManager();
        boolean root = RootSetup.haveRoot();
        Set<String> holders = new HashSet<>();
        if (root) for (String l : RootSetup.run("for p in /proc/[0-9]*; do ls -l $p/fd 2>/dev/null | grep -q '/dev/tty[SMH]' && cat $p/cmdline 2>/dev/null | tr '\\0' '\\n' | head -1; done; true").split("\n")) holders.add(l.trim());
        Set<String> pttListeners = new HashSet<>();
        for (String a : DeviceReport.pttActions()) try { for (ResolveInfo ri : pm.queryBroadcastReceivers(new Intent(a), 0)) pttListeners.add(ri.activityInfo.packageName); } catch (Throwable ignored) { }
        Set<String> launchable = new HashSet<>();
        try { for (ResolveInfo ri : pm.queryIntentActivities(new Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER), 0)) launchable.add(ri.activityInfo.packageName); } catch (Throwable ignored) { }

        List<App> out = new ArrayList<>();
        for (ApplicationInfo ai : pm.getInstalledApplications(0)) {
            String pkg = ai.packageName;
            if (pkg.equals(c.getPackageName()) || (ai.flags & ApplicationInfo.FLAG_SYSTEM) == 0) continue;
            boolean named = NAME.matcher(pkg).find();
            if (NOT_IT.matcher(pkg).matches() && !pkg.matches("(?i).*(intercom|interphone|walkie|talkie|dmr|quickchat).*")) continue;
            if (FRAMEWORK.matcher(pkg).matches() && !named) continue;
            App a = new App(); a.pkg = pkg;
            try { a.label = String.valueOf(pm.getApplicationLabel(ai)); } catch (Throwable t) { a.label = pkg; }
            if (holders.contains(pkg)) { a.score += 6; a.why.add("has a serial port open now"); }
            if (pttListeners.contains(pkg)) { a.score += 3; a.why.add("listens for the PTT key"); }
            if (named) { a.score += 3; a.why.add("its name sounds like a radio app"); }
            if (launchable.contains(pkg)) { a.launcher = true; a.score += 1; a.why.add("has a launcher icon"); }
            scanApk(ai.sourceDir, a);
            if (a.score >= 4) out.add(a);
        }
        Collections.sort(out, (x, y) -> y.score != x.score ? Integer.compare(y.score, x.score) : Boolean.compare(y.launcher, x.launcher));
        cache = out; cachedAt = System.currentTimeMillis();
        return out;
    }

    /** Native serial libraries and serial/radio paths in the code (dex files up to 24 MB each). */
    private static void scanApk(String apk, App a) {
        if (apk == null) return;
        try (ZipFile z = new ZipFile(new File(apk))) {
            boolean lib = false, tty = false, sys = false;
            Enumeration<? extends ZipEntry> en = z.entries();
            while (en.hasMoreElements()) {
                ZipEntry e = en.nextElement(); String n = e.getName();
                if (n.startsWith("lib/") && n.toLowerCase(Locale.US).matches(".*(serial|uart|intercom|interphone|dmr|walkie).*\\.so")) lib = true;
                if (n.matches("classes\\d*\\.dex") && e.getSize() < 24_000_000 && !(tty && sys)) {
                    byte[] b; try (InputStream in = z.getInputStream(e)) { b = readAll(in); }
                    for (int k = 0; k < DEX_MARKERS.length; k++) if (indexOf(b, DEX_MARKERS[k]) >= 0) { if (k < 3) tty = true; else sys = true; }
                }
            }
            if (lib) { a.score += 4; a.why.add("ships a serial-port library"); }
            if (tty) { a.score += 4; a.why.add("its code opens /dev/tty… ports"); }
            if (sys) { a.score += 1; a.why.add("its code uses /sys/devices/platform lines"); }
        } catch (Throwable ignored) { }
    }

    private static byte[] readAll(InputStream in) throws java.io.IOException {
        java.io.ByteArrayOutputStream o = new java.io.ByteArrayOutputStream(); byte[] t = new byte[65536]; int k;
        while ((k = in.read(t)) > 0) o.write(t, 0, k);
        return o.toByteArray();
    }
    static int indexOf(byte[] h, byte[] n) {
        outer: for (int i = 0; i + n.length <= h.length; i++) { if (h[i] != n[0]) continue; for (int j = 1; j < n.length; j++) if (h[i + j] != n[j]) continue outer; return i; }
        return -1;
    }

    public static String describe(List<App> apps) {
        if (apps.isEmpty()) return "  (no app scored high enough: no system app holds a serial port, ships a serial library, opens /dev/tty… or listens for the PTT key)\n";
        StringBuilder s = new StringBuilder();
        for (App a : apps) s.append(String.format(Locale.US, "  %2d  %s (%s): %s\n", a.score, a.label, a.pkg, String.join(", ", a.why)));
        return s.toString();
    }
}
