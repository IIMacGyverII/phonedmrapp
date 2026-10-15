package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInstaller;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

import java.io.OutputStream;

import de.robv.android.xposed.XposedBridge;

/**
 * Installs a DMRModHooks update inside the <b>module's own</b> process (com.dmrmod.hooks), so the
 * "install unknown apps" consent lands on the module app, never on the intercom app. Launched by the
 * Device-tab updater (which runs in the intercom process) with the APK URL; it downloads the APK and
 * streams it through {@link PackageInstaller}'s session API, which shows Android's own install
 * confirmation. No root, no FileProvider, no temp file.
 *
 * <p>Exported, so it validates that the URL is GitHub-hosted before doing anything; the user still
 * confirms every install in the system dialog regardless.
 */
public final class InstallerActivity extends Activity {

    public static final String EXTRA_URL = "apk_url";
    public static final String EXTRA_VERSION = "version";
    private static final String ACTION_STATUS = "com.dmrmod.hooks.INSTALL_STATUS";
    private static final String TAG = "DMRModHooks";

    private String version;
    private ProgressDialog prog;

    @Override protected void onCreate(Bundle b) {
        super.onCreate(b);
        handleIntent(getIntent());
    }

    @Override protected void onNewIntent(Intent i) {
        super.onNewIntent(i);
        setIntent(i);
        handleIntent(i);
    }

    private void handleIntent(Intent i) {
        if (i == null) { finish(); return; }
        if (ACTION_STATUS.equals(i.getAction())) { handleStatus(i); return; }

        final String url = i.getStringExtra(EXTRA_URL);
        version = i.getStringExtra(EXTRA_VERSION);
        if (url == null || !allowedHost(url)) {
            Toast.makeText(this, "Update: refused an unexpected download source", Toast.LENGTH_LONG).show();
            finish();
            return;
        }
        prog = new ProgressDialog(this);
        prog.setMessage("Downloading v" + version + "…");
        prog.setCancelable(false);
        prog.show();
        new Thread(new Runnable() {
            @Override public void run() {
                String err = null;
                byte[] apk = null;
                try { apk = GithubUpdater.download(url); }
                catch (Throwable t) { err = "download failed: " + t.getMessage(); }
                final String e = err;
                final byte[] a = apk;
                runOnUiThread(new Runnable() {
                    @Override public void run() {
                        if (a == null) { dismiss(); toastFinish("Update failed: " + e); }
                        else commitSession(a);
                    }
                });
            }
        }, "update-download").start();
    }

    private static boolean allowedHost(String url) {
        try {
            String h = Uri.parse(url).getHost();
            return h != null && (h.endsWith("github.com") || h.endsWith("githubusercontent.com"));
        } catch (Exception e) { return false; }
    }

    private void commitSession(byte[] apk) {
        try {
            if (prog != null) prog.setMessage("Installing v" + version + "…");
            PackageInstaller pi = getPackageManager().getPackageInstaller();
            PackageInstaller.SessionParams params =
                new PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL);
            int sid = pi.createSession(params);
            PackageInstaller.Session session = pi.openSession(sid);
            OutputStream out = session.openWrite("base.apk", 0, apk.length);
            out.write(apk);
            session.fsync(out);
            out.close();
            int flags = PendingIntent.FLAG_UPDATE_CURRENT;
            if (Build.VERSION.SDK_INT >= 31) flags |= PendingIntent.FLAG_MUTABLE;
            Intent status = new Intent(this, InstallerActivity.class).setAction(ACTION_STATUS);
            PendingIntent pe = PendingIntent.getActivity(this, sid, status, flags);
            session.commit(pe.getIntentSender());
            session.close();
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": install session failed: " + t);
            dismiss();
            toastFinish("Install failed: " + t.getMessage());
        }
    }

    private void handleStatus(Intent i) {
        int status = i.getIntExtra(PackageInstaller.EXTRA_STATUS, PackageInstaller.STATUS_FAILURE);
        if (status == PackageInstaller.STATUS_PENDING_USER_ACTION) {
            // First install from this source (or needed consent): show Android's own confirm UI.
            Intent confirm = i.getParcelableExtra(Intent.EXTRA_INTENT);
            if (confirm != null) {
                confirm.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                try { startActivity(confirm); }
                catch (Throwable t) { dismiss(); toastFinish("Can't show the installer: " + t.getMessage()); }
            }
            return; // final status arrives after the user acts
        }
        dismiss();
        if (status == PackageInstaller.STATUS_SUCCESS) {
            new AlertDialog.Builder(this)
                .setTitle("Installed v" + version)
                .setMessage("Reboot the radio to load the update — LSPosed only loads modules on boot.")
                .setCancelable(false)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface d, int w) { finish(); }
                })
                .show();
        } else {
            String m = i.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE);
            boolean cancelled = status == PackageInstaller.STATUS_FAILURE_ABORTED;
            toastFinish("Install " + (cancelled ? "cancelled" : "failed") + (m != null ? ": " + m : ""));
        }
    }

    private void dismiss() { try { if (prog != null) prog.dismiss(); } catch (Throwable ignore) { } }

    private void toastFinish(String m) {
        Toast.makeText(this, m, Toast.LENGTH_LONG).show();
        finish();
    }
}
