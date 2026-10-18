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
 * APK asset whose name starts with "DMRRadio" (the module and the companion attach their own APKs to the same
 * releases). Download through DownloadManager, then hand the file to the package installer.
 */
public final class Updater {
    private static final String LATEST = "https://api.github.com/repos/IIMacGyverII/phonedmrapp/releases";
    private static final String ASSET_PREFIX = "DMRRadio";

    public static final class Release { public String tag, version, name, notes, apkUrl, apkName; public long apkSize; }
    private Updater() { }

    /** Newest release that has a DMRRadio APK (looks through the last releases, not only "latest"). */
    public static Release fetchLatest() throws Exception {
        HttpClient.Response r = HttpClient.get(LATEST + "?per_page=15", null, 0L, "application/vnd.github+json");
        if (!r.isOk()) throw new Exception("GitHub API returned HTTP " + r.code);
        JSONArray rels = new JSONArray(r.bodyUtf8());
        for (int k = 0; k < rels.length(); k++) {
            JSONObject o = rels.getJSONObject(k);
            if (o.optBoolean("draft", false)) continue;
            JSONArray assets = o.optJSONArray("assets"); if (assets == null) continue;
            for (int i = 0; i < assets.length(); i++) {
                JSONObject a = assets.getJSONObject(i); String n = a.optString("name", "");
                if (!n.startsWith(ASSET_PREFIX) || !n.endsWith(".apk")) continue;
                Release rel = new Release();
                rel.tag = o.optString("tag_name", ""); rel.name = o.optString("name", rel.tag); rel.notes = o.optString("body", "");
                rel.apkUrl = a.optString("browser_download_url", null); rel.apkName = n; rel.apkSize = a.optLong("size", 0);
                // version from the asset name (DMRRadio-1.0.0-beta.2.apk) so module tags (v4.x) are never compared against ours
                String v = n.substring(ASSET_PREFIX.length()).replaceFirst("^[-_v]+", "").replaceFirst("\\.apk$", "");
                rel.version = v.isEmpty() ? rel.tag.replaceFirst("^v", "") : v;
                return rel;
            }
        }
        return null;
    }

    /** The caption companion (Vosk recognizer) ships on the same releases as DMRTranscriptionService-*.apk. */
    public static void installCompanion(final Context c) {
        Toast.makeText(c, "Looking for the companion app...", Toast.LENGTH_SHORT).show();
        new Thread(() -> {
            try {
                HttpClient.Response r = HttpClient.get(LATEST + "?per_page=15", null, 0L, "application/vnd.github+json");
                if (!r.isOk()) throw new Exception("GitHub API returned HTTP " + r.code);
                JSONArray rels = new JSONArray(r.bodyUtf8()); Release found = null;
                for (int k = 0; k < rels.length() && found == null; k++) {
                    JSONObject o = rels.getJSONObject(k); if (o.optBoolean("draft", false)) continue;
                    JSONArray assets = o.optJSONArray("assets"); if (assets == null) continue;
                    for (int i = 0; i < assets.length(); i++) {
                        JSONObject a = assets.getJSONObject(i); String n = a.optString("name", "");
                        if (n.startsWith("DMRTranscriptionService") && n.endsWith(".apk")) { found = new Release(); found.apkUrl = a.optString("browser_download_url", null); found.apkName = n; found.apkSize = a.optLong("size", 0); found.version = o.optString("tag_name", ""); break; }
                    }
                }
                final Release rel = found;
                new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> {
                    if (rel == null) { Toast.makeText(c, "No companion APK found in the releases", Toast.LENGTH_LONG).show(); return; }
                    new AlertDialog.Builder(c).setTitle("Install the caption companion?")
                            .setMessage(String.format(Locale.US, "DMR Transcription (%s, %.1f MB) runs the on-device Vosk speech recognizer that TXT live captions use. It downloads a language model on first use.", rel.apkName, rel.apkSize / 1e6))
                            .setNegativeButton("Later", null).setPositiveButton("Download", (d, w) -> download(c, rel)).show();
                });
            } catch (final Throwable t) { new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> Toast.makeText(c, "Lookup failed: " + t.getMessage(), Toast.LENGTH_LONG).show()); }
        }, "companion-lookup").start();
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

    public static void check(final Context c) {
        Toast.makeText(c, "Checking for updates…", Toast.LENGTH_SHORT).show();
        new Thread(() -> {
            try {
                final Release rel = fetchLatest();
                new android.os.Handler(android.os.Looper.getMainLooper()).post(() -> {
                    if (rel == null) { Toast.makeText(c, "No DMR Radio release published yet (you have " + BuildConfig.VERSION_NAME + ")", Toast.LENGTH_LONG).show(); return; }
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
            DownloadManager.Request req = new DownloadManager.Request(Uri.parse(rel.apkUrl)).setTitle("DMR Radio " + rel.version).setMimeType("application/vnd.android.package-archive")
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
