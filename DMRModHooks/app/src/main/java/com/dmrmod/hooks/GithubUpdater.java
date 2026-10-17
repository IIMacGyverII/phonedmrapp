package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.widget.Button;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;

import de.robv.android.xposed.XposedBridge;

/**
 * In-app updater: checks GitHub Releases for a newer DMRModHooks APK and, when the user chooses to
 * update, hands off to {@link InstallerActivity} in the module's own process. That keeps the
 * "install unknown apps" consent on the module app (com.dmrmod.hooks) — the intercom app gains no
 * privilege. No root.
 *
 * <p>Network is done through {@link HttpClient} (same wrapper the Nearby Repeaters sources use); its
 * {@link HttpClient.Response#body} is raw bytes, so the APK downloads directly.
 *
 * <p>Nothing here runs automatically: the quiet check only re-labels the button; downloading and
 * installing need an explicit tap, and Android shows its own install confirmation.
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
            // Releases since v4.1.0 also attach the companion APK (DMRTranscriptionService-*.apk):
            // the module update must pick its own asset, so prefer a name starting with "DMRModHooks"
            // and only fall back to the first .apk.
            for (int i = 0; i < assets.length(); i++) {
                JSONObject a = assets.getJSONObject(i);
                String n = a.optString("name", "").toLowerCase(java.util.Locale.US);
                if (!n.endsWith(".apk")) continue;
                boolean mine = n.startsWith("dmrmodhooks");
                if (rel.apkUrl == null || mine) {
                    rel.apkUrl = a.optString("browser_download_url", null);
                    rel.apkSize = a.optLong("size", 0);
                    if (mine) break;
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

    private static volatile boolean rebootPromptShown;

    /**
     * If the module APK on disk is newer than the running (loaded-at-boot) code, an update was
     * installed but LSPosed hasn't loaded it yet — tell the user to reboot. Shown once per process.
     *
     * <p>This runs in the intercom process (the hook). Unlike the module's own process, that process
     * is <b>not</b> killed by a self-update, so it's the reliable place for the reminder: when the
     * updater replaces the module APK, Android kills {@code com.dmrmod.hooks} (and its
     * {@link InstallerActivity}) before any success dialog there can show.
     */
    public static void checkPendingReboot(final Activity activity) {
        if (rebootPromptShown) return;
        try {
            int installed = activity.getPackageManager().getPackageInfo(PKG, 0).versionCode;
            int running = BuildConfig.VERSION_CODE;
            if (installed <= running) return;   // in sync (or running newer after a reboot)
            rebootPromptShown = true;
            final String installedName = installedVersion(activity);
            new AlertDialog.Builder(activity, DIALOG_THEME)
                .setTitle("Update ready: v" + installedName)
                .setMessage("v" + installedName + " is installed but not loaded yet. Restart the radio "
                    + "(power off, then on) so LSPosed loads it. You're still running v"
                    + BuildConfig.VERSION_NAME + " until then.")
                .setPositiveButton("OK", null)
                .show();
            XposedBridge.log(TAG + ": pending reboot: running " + running + " < installed " + installed);
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": pending-reboot check failed: " + t);
        }
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
            + "Download and install now? Android will ask you to confirm the install, and you'll need "
            + "to reboot the radio afterwards so LSPosed loads the new version.";
        new AlertDialog.Builder(activity, DIALOG_THEME)
            .setTitle("Update available: v" + rel.version)
            .setMessage(msg)
            .setNegativeButton("Later", null)
            .setPositiveButton("Download & install", new android.content.DialogInterface.OnClickListener() {
                @Override public void onClick(android.content.DialogInterface d, int w) {
                    launchInstaller(activity, rel);
                }
            })
            .show();
    }

    /**
     * Hand off to {@link InstallerActivity} in the module's own process, so the install consent
     * lands on the module app and not the intercom app. The installer does the download + install.
     */
    private static void launchInstaller(Activity activity, Release rel) {
        try {
            Intent i = new Intent();
            i.setClassName("com.dmrmod.hooks", "com.dmrmod.hooks.InstallerActivity");
            i.putExtra(InstallerActivity.EXTRA_URL, rel.apkUrl);
            i.putExtra(InstallerActivity.EXTRA_VERSION, rel.version);
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            activity.startActivity(i);
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": launch installer failed: " + t);
            Toast.makeText(activity, "Couldn't start the installer: " + t.getMessage(),
                Toast.LENGTH_LONG).show();
        }
    }
}
