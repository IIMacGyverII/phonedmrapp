package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.widget.Button;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import de.robv.android.xposed.XposedBridge;

/**
 * In-app updater: checks GitHub Releases for a newer DMRModHooks APK, downloads it, and installs it
 * with root (the device runs LSPosed via Magisk, so {@code su} is available). A reboot is offered
 * afterwards because LSPosed only reloads a module on reboot.
 *
 * <p>Network is done through {@link HttpClient} (same wrapper the Nearby Repeaters sources use); its
 * {@link HttpClient.Response#body} is raw bytes, so the APK downloads directly. Install streams the
 * bytes into {@code pm install} over {@code su} — no temp file, no install permission, no tap-through.
 *
 * <p>Nothing here runs automatically without the user's say-so: the quiet check only re-labels the
 * button; downloading, installing and rebooting each need an explicit tap.
 */
public final class GithubUpdater {

    private static final String TAG = "DMRModHooks";
    private static final String PKG = "com.dmrmod.hooks";
    private static final String LATEST_URL =
        "https://api.github.com/repos/IIMacGyverII/phonedmrapp/releases/latest";
    private static final int DIALOG_THEME = android.R.style.Theme_Material_Dialog_Alert;

    private GithubUpdater() { }

    /** Parsed "latest release" with the APK asset picked out. */
    public static final class Release {
        public String tag;      // "v3.4.7"
        public String version;  // "3.4.7"
        public String name;     // release title
        public String notes;    // release body (markdown)
        public String apkUrl;   // browser_download_url of the .apk asset
        public long apkSize;
    }

    // ---- logic -------------------------------------------------------------

    public static Release fetchLatest() throws Exception {
        HttpClient.Response r = HttpClient.get(LATEST_URL, null, 0L, "application/vnd.github+json");
        if (!r.isOk()) throw new IOException("GitHub API returned HTTP " + r.code);
        JSONObject o = new JSONObject(r.bodyUtf8());
        Release rel = new Release();
        rel.tag = o.optString("tag_name", "");
        rel.version = rel.tag.startsWith("v") ? rel.tag.substring(1) : rel.tag;
        rel.name = o.optString("name", rel.tag);
        rel.notes = o.optString("body", "");
        JSONArray assets = o.optJSONArray("assets");
        if (assets != null) {
            for (int i = 0; i < assets.length(); i++) {
                JSONObject a = assets.getJSONObject(i);
                if (a.optString("name", "").toLowerCase(java.util.Locale.US).endsWith(".apk")) {
                    rel.apkUrl = a.optString("browser_download_url", null);
                    rel.apkSize = a.optLong("size", 0);
                    break;
                }
            }
        }
        return rel;
    }

    /** Numeric dotted compare: >0 if a newer than b, <0 if older, 0 if equal. */
    public static int compareVersions(String a, String b) {
        String[] pa = a.split("\\."), pb = b.split("\\.");
        int n = Math.max(pa.length, pb.length);
        for (int i = 0; i < n; i++) {
            int va = i < pa.length ? numPrefix(pa[i]) : 0;
            int vb = i < pb.length ? numPrefix(pb[i]) : 0;
            if (va != vb) return Integer.compare(va, vb);
        }
        return 0;
    }

    private static int numPrefix(String s) {
        StringBuilder d = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c >= '0' && c <= '9') d.append(c); else break;
        }
        if (d.length() == 0) return 0;
        try { return Integer.parseInt(d.toString()); } catch (Exception e) { return 0; }
    }

    public static String installedVersion(Context ctx) {
        try { return ctx.getPackageManager().getPackageInfo(PKG, 0).versionName; }
        catch (Throwable t) { return null; }
    }

    public static boolean isNewer(Context ctx, Release latest) {
        String inst = installedVersion(ctx);
        if (inst == null || latest == null || latest.version == null || latest.version.isEmpty()) return false;
        return compareVersions(latest.version, inst) > 0;
    }

    public static byte[] download(String url) throws Exception {
        HttpClient.Response r = HttpClient.get(url);
        if (!r.isOk() || r.body == null) throw new IOException("Download returned HTTP " + r.code);
        return r.body;
    }

    /** Stream the APK into {@code pm install} over su. Returns null on success, else an error string. */
    public static String installViaRoot(byte[] apk) {
        Process p = null;
        try {
            p = Runtime.getRuntime().exec(new String[]{"su", "-c", "pm install -r -S " + apk.length + " -"});
            OutputStream os = p.getOutputStream();
            os.write(apk);
            os.flush();
            os.close();
            String out = readAll(p.getInputStream()) + readAll(p.getErrorStream());
            int code = p.waitFor();
            if (code == 0 && out.toLowerCase(java.util.Locale.US).contains("success")) return null;
            return "pm install exit " + code + (out.trim().isEmpty() ? "" : ": " + out.trim());
        } catch (Throwable t) {
            return "install error: " + t;
        } finally {
            if (p != null) try { p.destroy(); } catch (Throwable ignore) { }
        }
    }

    public static void rebootViaRoot() {
        try { Runtime.getRuntime().exec(new String[]{"su", "-c", "reboot"}); }
        catch (Throwable t) { XposedBridge.log(TAG + ": reboot via su failed: " + t); }
    }

    private static String readAll(InputStream in) {
        try {
            ByteArrayOutputStream b = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int n;
            while ((n = in.read(buf)) > 0) b.write(buf, 0, n);
            return new String(b.toByteArray(), "UTF-8");
        } catch (Exception e) { return ""; }
    }

    // ---- UI ----------------------------------------------------------------

    /**
     * Quiet background check used when the Device tab is shown: if a newer release exists, re-label
     * {@code button} to advertise it. Never pops a dialog.
     */
    public static void checkQuietly(final Activity activity, final Button button) {
        new Thread(new Runnable() {
            @Override public void run() {
                try {
                    final Release rel = fetchLatest();
                    if (!isNewer(activity, rel)) return;
                    activity.runOnUiThread(new Runnable() {
                        @Override public void run() {
                            try {
                                button.setText("⬆ Update available: v" + rel.version);
                            } catch (Throwable ignore) { }
                        }
                    });
                } catch (Throwable t) {
                    XposedBridge.log(TAG + ": quiet update check failed: " + t);
                }
            }
        }, "update-check-quiet").start();
    }

    /** User tapped "Check for updates": fetch, then either offer the update or say it's current. */
    public static void checkAndPrompt(final Activity activity) {
        Toast.makeText(activity, "Checking for updates…", Toast.LENGTH_SHORT).show();
        new Thread(new Runnable() {
            @Override public void run() {
                try {
                    final Release rel = fetchLatest();
                    activity.runOnUiThread(new Runnable() {
                        @Override public void run() {
                            if (isNewer(activity, rel)) {
                                offerUpdate(activity, rel);
                            } else {
                                Toast.makeText(activity, "You're on the latest version (v"
                                    + installedVersion(activity) + ")", Toast.LENGTH_LONG).show();
                            }
                        }
                    });
                } catch (final Throwable t) {
                    activity.runOnUiThread(new Runnable() {
                        @Override public void run() {
                            Toast.makeText(activity, "Update check failed: " + t.getMessage(),
                                Toast.LENGTH_LONG).show();
                        }
                    });
                }
            }
        }, "update-check").start();
    }

    private static void offerUpdate(final Activity activity, final Release rel) {
        if (rel.apkUrl == null) {
            Toast.makeText(activity, "v" + rel.version + " is available, but the release has no APK asset.",
                Toast.LENGTH_LONG).show();
            return;
        }
        String notes = rel.notes == null ? "" : rel.notes.trim();
        if (notes.length() > 1500) notes = notes.substring(0, 1500) + "…";
        String msg = "You have v" + installedVersion(activity) + ".\n\n"
            + (notes.isEmpty() ? "" : "What's new:\n" + notes + "\n\n")
            + "Download and install now? The radio will offer to reboot afterwards (LSPosed needs it "
            + "to load the new version).";
        new AlertDialog.Builder(activity, DIALOG_THEME)
            .setTitle("Update available: v" + rel.version)
            .setMessage(msg)
            .setNegativeButton("Later", null)
            .setPositiveButton("Download & install", new android.content.DialogInterface.OnClickListener() {
                @Override public void onClick(android.content.DialogInterface d, int w) {
                    downloadAndInstall(activity, rel);
                }
            })
            .show();
    }

    private static void downloadAndInstall(final Activity activity, final Release rel) {
        final ProgressDialog prog = new ProgressDialog(activity, DIALOG_THEME);
        prog.setMessage("Downloading v" + rel.version + "…");
        prog.setCancelable(false);
        prog.show();
        new Thread(new Runnable() {
            @Override public void run() {
                String error = null;
                try {
                    byte[] apk = download(rel.apkUrl);
                    activity.runOnUiThread(new Runnable() {
                        @Override public void run() { prog.setMessage("Installing v" + rel.version + "…"); }
                    });
                    error = installViaRoot(apk);
                } catch (Throwable t) {
                    error = "download failed: " + t.getMessage();
                }
                final String err = error;
                activity.runOnUiThread(new Runnable() {
                    @Override public void run() {
                        try { prog.dismiss(); } catch (Throwable ignore) { }
                        if (err == null) {
                            new AlertDialog.Builder(activity, DIALOG_THEME)
                                .setTitle("Installed v" + rel.version)
                                .setMessage("The update is installed but not loaded yet. Reboot now so "
                                    + "LSPosed picks it up?")
                                .setNegativeButton("Later", null)
                                .setPositiveButton("Reboot now", new android.content.DialogInterface.OnClickListener() {
                                    @Override public void onClick(android.content.DialogInterface d, int w) {
                                        Toast.makeText(activity, "Rebooting…", Toast.LENGTH_SHORT).show();
                                        rebootViaRoot();
                                    }
                                })
                                .show();
                        } else {
                            new AlertDialog.Builder(activity, DIALOG_THEME)
                                .setTitle("Update failed")
                                .setMessage(err + "\n\nIf this is a root-permission error, grant the "
                                    + "intercom app root in Magisk and try again.")
                                .setPositiveButton("Close", null)
                                .show();
                        }
                    }
                });
            }
        }, "update-install").start();
    }
}
