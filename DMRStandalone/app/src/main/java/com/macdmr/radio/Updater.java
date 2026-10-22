/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

import android.app.AlertDialog;
import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.widget.Toast;

import com.macdmr.radio.repeaters.HttpClient;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.Locale;

/**
 * In-app updates from the GitHub releases of this repo. A release counts for this app only when it carries an
 * APK asset whose name starts with "SignalDeck" (or the earlier "DMRRadio") (the module and the companion attach their own APKs to the same
 * releases). Download through DownloadManager, then hand the file to the package installer.
 */
public final class Updater {
    private static final String LATEST = "https://api.github.com/repos/IIMacGyverII/phonedmrapp/releases";
    private static final String[] ASSET_PREFIXES = { "SignalDeck", "DMRRadio" };   // the app was called DMR Radio before 2026-10-20

    public static final class Release { public String tag, version, name, notes = "", apkUrl, apkName, published = ""; public long apkSize; public boolean prerelease; }
    private Updater() { }

    /** Newest release that has a SignalDeck APK (looks through the last releases, not only "latest"). */
    public static Release fetchLatest() throws Exception { java.util.List<Release> l = fetchAll(15); return l.isEmpty() ? null : l.get(0); }

    /** Every recent release that carries a SignalDeck APK, newest first as GitHub lists them (the module's own releases are skipped). */
    public static java.util.List<Release> fetchAll(int max) throws Exception {
        java.util.List<Release> out = new java.util.ArrayList<>();
        HttpClient.Response r = HttpClient.get(LATEST + "?per_page=" + Math.min(100, max), null, 0L, "application/vnd.github+json");
        if (!r.isOk()) throw new Exception("GitHub API returned HTTP " + r.code);
        JSONArray rels = new JSONArray(r.bodyUtf8());
        for (int k = 0; k < rels.length(); k++) {
            JSONObject o = rels.getJSONObject(k);
            if (o.optBoolean("draft", false)) continue;
            JSONArray assets = o.optJSONArray("assets"); if (assets == null) continue;
            for (int i = 0; i < assets.length(); i++) {
                JSONObject a = assets.getJSONObject(i); String n = a.optString("name", "");
                String pre = null; for (String p : ASSET_PREFIXES) if (n.startsWith(p)) { pre = p; break; }
                if (pre == null || !n.endsWith(".apk")) continue;
                Release rel = new Release();
                rel.tag = o.optString("tag_name", ""); rel.name = o.optString("name", rel.tag); rel.notes = o.optString("body", "");
                rel.prerelease = o.optBoolean("prerelease", false); rel.published = o.optString("published_at", "").replaceFirst("T.*$", "");
                rel.apkUrl = a.optString("browser_download_url", null); rel.apkName = n; rel.apkSize = a.optLong("size", 0);
                // version from the asset name (SignalDeck-1.0.0-beta.2.apk) so module tags (v4.x) are never compared against ours
                String v = n.substring(pre.length()).replaceFirst("^[-_v]+", "").replaceFirst("\\.apk$", "");
                rel.version = v.isEmpty() ? rel.tag.replaceFirst("^v", "") : v;
                out.add(rel);
                break;
            }
        }
        return out;
    }

    /** Numeric-aware compare: 1.0.0 > 1.0.0-beta.2 > 1.0.0-beta.1. */
    public static int compareVersions(String a, String b) {
        String[] pa = a.split("-", 2), pb = b.split("-", 2);
        int c = compareDotted(pa[0], pb[0]);
        if (c != 0) return c;
        boolean preA = pa.length > 1, preB = pb.length > 1;
        if (preA != preB) return preA ? -1 : 1;
        if (!preA) return 0;
        return compareDotted(pa[1].replaceAll("[^0-9.]", "."), pb[1].replaceAll("[^0-9.]", "."));
    }
    private static int compareDotted(String a, String b) {
        String[] x = a.split("\\."), y = b.split("\\.");
        for (int i = 0; i < Math.max(x.length, y.length); i++) {
            int xi = i < x.length ? num(x[i]) : 0, yi = i < y.length ? num(y[i]) : 0;
            if (xi != yi) return Integer.compare(xi, yi);
        }
        return 0;
    }
    private static int num(String s) { try { return Integer.parseInt(s.replaceAll("[^0-9]", "")); } catch (Exception e) { return 0; } }

    /**
     * Device → Updates: the two paths side by side. Release (stable builds) and Beta (test builds, often for one phone),
     * each with its newest build and what every build since the installed one added. Nothing is installed unless asked.
     */
    public static void show(final Context c) {
        final float d = com.macdmr.radio.ui.Theme.dp(c);
        final android.widget.LinearLayout body = com.macdmr.radio.ui.Neo.sheetBody(c, "Updates");
        final boolean onBeta = BuildConfig.VERSION_NAME.contains("-");
        body.addView(com.macdmr.radio.ui.Neo.sheetHint(c, "You have " + BuildConfig.VERSION_NAME + (onBeta ? " (a beta)" : " (a release)") + ". Two paths: Release, the finished builds, and Beta, the test builds. "
                + "Betas are often made for one phone being tested, so read what changed before updating; nothing is installed until you tap Update."));
        final android.widget.TextView status = com.macdmr.radio.ui.Neo.label(c, "Checking GitHub\u2026", com.macdmr.radio.ui.Neo.MUTED, 13, false);
        body.addView(status);
        final android.widget.LinearLayout paths = new android.widget.LinearLayout(c); paths.setOrientation(android.widget.LinearLayout.VERTICAL); body.addView(paths);
        com.macdmr.radio.ui.Neo.showSheet(c, body);
        new Thread(() -> {
            java.util.List<Release> all = null; String err = null;
            try { all = fetchAll(100); } catch (Throwable t) { err = t.getMessage(); }
            final java.util.List<Release> fa = all; final String fe = err;
            new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> {
                if (fe != null) { status.setText("Update check failed: " + fe); return; }
                status.setVisibility(android.view.View.GONE);
                addPath(c, paths, "Release", UpdatePaths.path(fa, BuildConfig.VERSION_NAME, false), false, d);
                addPath(c, paths, "Beta", UpdatePaths.path(fa, BuildConfig.VERSION_NAME, true), true, d);
            });
        }, "update-paths").start();
    }

    private static void addPath(final Context c, android.widget.LinearLayout into, String title, final UpdatePaths.Path p, boolean beta, float d) {
        into.addView(com.macdmr.radio.ui.Neo.sheetSection(c, title));
        String head;
        if (p.newest == null) head = beta ? "No beta published." : "No release yet: SignalDeck is still in beta.";
        else if (!p.newer) head = "Nothing newer: the newest " + (beta ? "beta" : "release") + " is " + p.newest.version + (Updater.compareVersions(p.newest.version, BuildConfig.VERSION_NAME) == 0 ? " (yours)." : ".");
        else head = p.newest.version + " is available" + (p.since.size() > 1 ? " (" + p.since.size() + " " + (beta ? "betas" : "releases") + " since yours)" : "") + ".";
        if (p.downgrade) head = "You are on a beta newer than the newest release (" + p.newest.version + "). You can go back to it.";
        android.widget.TextView h = com.macdmr.radio.ui.Neo.label(c, head, p.newer ? (beta ? com.macdmr.radio.ui.Neo.AMBER_LIGHT : com.macdmr.radio.ui.Neo.GREEN_LIGHT) : com.macdmr.radio.ui.Neo.TEXT_SOFT, 15, p.newer);
        into.addView(h);
        if (p.downgrade) { addDowngrade(c, into, p.newest, d); return; }
        if (!p.newer) return;
        android.widget.TextView ch = com.macdmr.radio.ui.Neo.label(c, "What changed since " + BuildConfig.VERSION_NAME + ":\n\n" + UpdatePaths.changes(p, 6000), com.macdmr.radio.ui.Neo.TEXT_SOFT, 13, false);
        ch.setPadding(0, (int) (6 * d), 0, 0); ch.setTextIsSelectable(true);
        into.addView(ch);
        android.widget.TextView go = com.macdmr.radio.ui.Neo.button(c, String.format(Locale.US, "Update to %s (%.1f MB)", p.newest.version, p.newest.apkSize / 1048576.0), "update", beta ? com.macdmr.radio.ui.Neo.AMBER : com.macdmr.radio.ui.Neo.GREEN);
        android.widget.LinearLayout.LayoutParams l = new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.WRAP_CONTENT); l.topMargin = (int) (10 * d);
        into.addView(go, l);
        final Release rel = p.newest;
        go.setOnClickListener(v -> download(c, rel));
    }

    /** Back from a beta to the newest release: its notes and a button; Android only allows an older version with root (pm install -d). */
    private static void addDowngrade(final Context c, android.widget.LinearLayout into, final Release rel, float d) {
        String n = UpdatePaths.plain(UpdatePaths.ownNotes(rel.notes));
        android.widget.TextView ch = com.macdmr.radio.ui.Neo.label(c, "Release " + rel.version + (rel.published.isEmpty() ? "" : " (" + rel.published + ")") + ":\n\n" + (n.isEmpty() ? "(no notes)" : n.length() > 4000 ? n.substring(0, 4000) + "\u2026" : n),
                com.macdmr.radio.ui.Neo.TEXT_SOFT, 13, false);
        ch.setPadding(0, (int) (6 * d), 0, 0); ch.setTextIsSelectable(true);
        into.addView(ch);
        android.widget.TextView go = com.macdmr.radio.ui.Neo.button(c, String.format(Locale.US, "Go back to release %s (%.1f MB)", rel.version, rel.apkSize / 1048576.0), "restore", com.macdmr.radio.ui.Neo.GREEN);
        android.widget.LinearLayout.LayoutParams l = new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.WRAP_CONTENT); l.topMargin = (int) (10 * d);
        into.addView(go, l);
        go.setOnClickListener(v -> new AlertDialog.Builder(c).setTitle("Go back to release " + rel.version + "?")
                .setMessage("This replaces " + BuildConfig.VERSION_NAME + " with the release " + rel.version + ". Your channels, settings, recordings and root access are kept; what was added in betas after " + rel.version + " goes away until the next release.\n\n"
                        + "Android only installs an older version with root, which SignalDeck already has. SignalDeck closes and restarts as " + rel.version + "; if the radio was in use it comes back when you open the app.")
                .setNegativeButton("Cancel", null).setPositiveButton("Go back", (dd, w) -> downgrade(c, rel)).show());
    }

    /** Download the release, then install it over the beta with root (pm install -r -d), detached so it survives this app being replaced. */
    private static void downgrade(final Context c, final Release rel) {
        try {
            final DownloadManager dm = (DownloadManager) c.getSystemService(Context.DOWNLOAD_SERVICE);
            DownloadManager.Request req = new DownloadManager.Request(Uri.parse(rel.apkUrl)).setTitle("SignalDeck " + rel.version).setMimeType("application/vnd.android.package-archive")
                    .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED).setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, rel.apkName);
            final long id = dm.enqueue(req);
            Toast.makeText(c, "Downloading " + rel.version + "\u2026 SignalDeck restarts as the release when it is installed", Toast.LENGTH_LONG).show();
            BroadcastReceiver done = new BroadcastReceiver() {
                @Override public void onReceive(Context ctx, Intent i) {
                    if (i.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1) != id) return;
                    try { ctx.unregisterReceiver(this); } catch (Throwable ignored) { }
                    String path = null;
                    try (android.database.Cursor cur = dm.query(new DownloadManager.Query().setFilterById(id))) {
                        if (cur != null && cur.moveToFirst()) { String u = cur.getString(cur.getColumnIndexOrThrow(DownloadManager.COLUMN_LOCAL_URI)); if (u != null) path = Uri.parse(u).getPath(); }
                    } catch (Throwable ignored) { }
                    if (path == null || !path.endsWith(".apk")) { Toast.makeText(ctx, "Download failed", Toast.LENGTH_LONG).show(); return; }
                    final String src = path;
                    Toast.makeText(ctx, "Installing " + rel.version + " with root\u2026", Toast.LENGTH_LONG).show();
                    new Thread(() -> {
                        String out = rootInstall(src);
                        if (!out.contains("started")) new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> Toast.makeText(ctx, "Could not install with root: " + out, Toast.LENGTH_LONG).show());
                    }, "downgrade").start();
                }
            };
            if (Build.VERSION.SDK_INT >= 33) c.registerReceiver(done, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE), Context.RECEIVER_EXPORTED);
            else c.registerReceiver(done, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
        } catch (Throwable t) { Toast.makeText(c, "Could not start the download: " + t.getMessage(), Toast.LENGTH_LONG).show(); }
    }

    /**
     * Install an APK over this app with root, older versions included (pm install -r -d keeps data and the app's uid, so
     * the Magisk grant stays). Detached: installing replaces this very app, which ends its process mid-command.
     */
    public static String rootInstall(String apkPath) {
        String tmp = "/data/local/tmp/signaldeck_release.apk";
        return RootSetup.run("cp '" + apkPath.replace("'", "") + "' " + tmp + " && chmod 644 " + tmp + " && (nohup sh -c 'pm install -r -d " + tmp + "; rm -f " + tmp + "' >/dev/null 2>&1 &) ; echo started");
    }

    public static void check(final Context c) {
        Toast.makeText(c, "Checking for updates…", Toast.LENGTH_SHORT).show();
        new Thread(() -> {
            try {
                final Release rel = fetchLatest();
                new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> {
                    if (rel == null) { Toast.makeText(c, "No SignalDeck release published yet (you have " + BuildConfig.VERSION_NAME + ")", Toast.LENGTH_LONG).show(); return; }
                    if (compareVersions(rel.version, BuildConfig.VERSION_NAME) <= 0) { Toast.makeText(c, "You are on the latest version (" + BuildConfig.VERSION_NAME + ")", Toast.LENGTH_LONG).show(); return; }
                    offer(c, rel);
                });
            } catch (final Throwable t) { new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> Toast.makeText(c, "Update check failed: " + t.getMessage(), Toast.LENGTH_LONG).show()); }
        }, "update-check").start();
    }

    private static void offer(final Context c, final Release rel) {
        String notes = rel.notes == null ? "" : rel.notes.trim(); if (notes.length() > 1500) notes = notes.substring(0, 1500) + "…";
        new AlertDialog.Builder(c).setTitle("Update available: " + rel.version)
                .setMessage("You have " + BuildConfig.VERSION_NAME + ".\n\n" + (notes.isEmpty() ? "" : "What's new:\n" + notes + "\n\n") + String.format(Locale.US, "Download %s (%.1f MB) and install? Android asks you to confirm the install; your channels and settings are kept.", rel.apkName, rel.apkSize / 1e6))
                .setNegativeButton("Later", null).setPositiveButton("Download", (d, w) -> download(c, rel)).show();
    }

    private static void download(final Context c, Release rel) {
        try {
            DownloadManager dm = (DownloadManager) c.getSystemService(Context.DOWNLOAD_SERVICE);
            DownloadManager.Request req = new DownloadManager.Request(Uri.parse(rel.apkUrl)).setTitle("SignalDeck " + rel.version).setMimeType("application/vnd.android.package-archive")
                    .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED).setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, rel.apkName);
            final long id = dm.enqueue(req);
            Toast.makeText(c, "Downloading… the installer opens when it is done", Toast.LENGTH_LONG).show();
            BroadcastReceiver done = new BroadcastReceiver() {
                @Override public void onReceive(Context ctx, Intent i) {
                    if (i.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1) != id) return;
                    try { ctx.unregisterReceiver(this); } catch (Throwable ignored) { }
                    Uri u = dm.getUriForDownloadedFile(id);
                    if (u == null) { Toast.makeText(ctx, "Download failed", Toast.LENGTH_LONG).show(); return; }
                    Intent inst = new Intent(Intent.ACTION_VIEW).setDataAndType(u, "application/vnd.android.package-archive").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    try { ctx.startActivity(inst); } catch (Throwable t) { Toast.makeText(ctx, "Open the downloaded APK from your Downloads to install it", Toast.LENGTH_LONG).show(); }
                }
            };
            if (Build.VERSION.SDK_INT >= 33) c.registerReceiver(done, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE), Context.RECEIVER_EXPORTED);
            else c.registerReceiver(done, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
        } catch (Throwable t) { Toast.makeText(c, "Could not start the download: " + t.getMessage(), Toast.LENGTH_LONG).show(); }
    }
}
