package com.macdmr.radio.ui;

import android.content.Context;
import android.text.InputType;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.RootSetup;

/**
 * Device tab: radio link (status, take over / hand back to the stock app, boot persistence), identity
 * (DMR ID), data (re-import from the stock app), help, diagnostics.
 */
public class DeviceView extends LinearLayout implements RadioService.Listener {
    public interface Host { void openHelp(); void openDiagnostics(); }

    private final TextView linkText, idText, profileText;
    private final android.widget.CheckBox ownAtBoot, voiceBox, hwPttBox, volPttBox, scanSqBox;
    private final TextView radioIdText;
    private RadioService svc;
    private Host host;

    public DeviceView(Context c) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        float d = Theme.dp(c);
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (20 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        bar.addView(Theme.label(c, "Device", Theme.WHITE, 24, false), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        addView(bar);

        ScrollView sv = new ScrollView(c);
        LinearLayout body = new LinearLayout(c); body.setOrientation(VERTICAL); body.setPadding((int) (12 * d), (int) (10 * d), (int) (12 * d), (int) (24 * d));
        sv.addView(body); addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));

        // --- radio link ---
        LinearLayout link = section(body, "📻 Radio link");
        profileText = Theme.label(c, "", 0xFF9AA4AE, 13, false); link.addView(profileText);
        linkText = Theme.label(c, "", Theme.CYAN, 15, true); link.addView(linkText);
        LinearLayout lrow = new LinearLayout(c); lrow.setGravity(Gravity.CENTER);
        TextView up = pill(c, "Take over the radio", Theme.PKT), release = pill(c, "Hand back to stock app", Theme.MON);
        LayoutParams bl = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); bl.setMargins((int) (4 * d), (int) (10 * d), (int) (4 * d), 0);
        lrow.addView(up, bl); lrow.addView(release, new LayoutParams(bl));
        link.addView(lrow);
        up.setOnClickListener(v -> { if (svc != null) svc.bringUp(); });
        release.setOnClickListener(v -> { if (svc != null) svc.shutDown(true); });
        TextView boot = pill(c, "Keep access after reboot (Magisk module)", Theme.SOFTSQ);
        LayoutParams bb = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); bb.setMargins((int) (4 * d), (int) (8 * d), (int) (4 * d), 0);
        link.addView(boot, bb);
        boot.setOnClickListener(v -> new Thread(() -> {
            final String r = svc != null ? RootSetup.installBootModule(svc.profile(), getContext().getCacheDir()) : "service not ready";
            post(() -> new android.app.AlertDialog.Builder(getContext()).setTitle("Boot persistence").setMessage(r).setPositiveButton("OK", null).show());
        }).start());
        ownAtBoot = new android.widget.CheckBox(c); ownAtBoot.setText("Own the radio at boot (otherwise the stock app is restored after a reboot)");
        ownAtBoot.setTextColor(0xFFC8D2DC); ownAtBoot.setTextSize(13); ownAtBoot.setButtonTintList(android.content.res.ColorStateList.valueOf(Theme.CYAN));
        LayoutParams ob = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); ob.setMargins((int) (4 * d), (int) (8 * d), (int) (4 * d), 0);
        link.addView(ownAtBoot, ob);
        ownAtBoot.setOnCheckedChangeListener((b, on) -> { if (svc != null) svc.setOwnAtBoot(on); });
        link.addView(Theme.label(c, "This app needs root (Magisk) to reach the radio's serial port. While it owns the radio the stock walkie-talkie app is paused and its icon is hidden; \"Hand back\" restores it. The Magisk module makes the required SELinux rules survive a reboot so the app can start on its own; with it installed, the radio can be owned straight from boot.", 0xFF8A98A6, 12, false));

        // --- device report (any phone) ---
        LinearLayout rep = section(body, "\uD83E\uDDEA Device report");
        rep.addView(Theme.label(c, "For a phone that has no profile yet, or to help debug one: gathers the facts a profile needs (serial ports, radio-module nodes, the stock walkie-talkie app and its APK, vendor libraries, framework jars, services; with root also SELinux labels and the PTT key broadcasts), saves it under Download/DMR/DeviceReport and offers to share the zip to a GitHub issue. Nothing on the phone is changed.", 0xFF8A98A6, 12, false));
        LinearLayout rrow = new LinearLayout(c); rrow.setGravity(Gravity.CENTER);
        TextView gen = pill(c, "Generate device report", Theme.PKT), share = pill(c, "Share last report", Theme.SOFTSQ);
        rrow.addView(gen, new LayoutParams(bl)); rrow.addView(share, new LayoutParams(bl)); rep.addView(rrow);
        LinearLayout rrow2 = new LinearLayout(c); rrow2.setGravity(Gravity.CENTER);
        TextView keys = pill(c, "Capture the PTT key (10 s)", Theme.VFO), probe = pill(c, "Radio probe (root)", Theme.MON);
        rrow2.addView(keys, new LayoutParams(bl)); rrow2.addView(probe, new LayoutParams(bl)); rep.addView(rrow2);
        TextView issue = pill(c, "Open a GitHub issue with the facts filled in", Theme.REC);
        rep.addView(issue, new LayoutParams(bb));
        issue.setOnClickListener(v -> com.macdmr.radio.DeviceReport.openIssue(c));
        gen.setOnClickListener(v -> {
            final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Device report").setMessage("Starting\u2026").setCancelable(false).create(); pd.show();
            new Thread(() -> {
                try { com.macdmr.radio.DeviceReport.generate(c, s -> post(() -> pd.setMessage(s + "\u2026"))); post(() -> { pd.dismiss(); new android.app.AlertDialog.Builder(c).setTitle("Report ready").setMessage("Saved under Download/DMR/DeviceReport. If the phone has a side PTT key, run \"Capture the PTT key\" and, with root, the radio probe, then use Share last report, which explains what it contains.").setPositiveButton("OK", null).show(); }); }
                catch (Throwable t) { post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, "Report failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); }); }
            }).start();
        });
        share.setOnClickListener(v -> new android.app.AlertDialog.Builder(c).setTitle("Share the device report")
                .setMessage("The report holds phone model and build facts, serial-port and radio-module node names, the walkie-talkie app's package details, library and framework file names, running radio processes, and (with root) SELinux labels and short radio-related log excerpts with message text removed and long numbers masked. No accounts, contacts, messages, location or identifiers such as IMEI.\n\nThe copied stock walkie-talkie APK is the manufacturer's software: include it if you are comfortable posting it, or share without it (we can ask for it privately).")
                .setPositiveButton("Share all", (dd, w) -> shareZip(true)).setNeutralButton("Without the APK", (dd, w) -> shareZip(false)).setNegativeButton("Cancel", null).show());
        keys.setOnClickListener(v -> {
            final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Press the PTT key now").setMessage("Press and release the phone\'s side PTT button a few times within the next 10 seconds. Everything the phone reports for it is recorded.").setCancelable(false).create(); pd.show();
            new Thread(() -> { final String r = com.macdmr.radio.DeviceReport.captureKeys(c, 10); final java.io.File dir = com.macdmr.radio.DeviceReport.append("PTT key capture", r); post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, dir == null ? "Captured, but generate a report first so it can be saved" : "Saved to the report", android.widget.Toast.LENGTH_LONG).show(); }); }).start();
        });
        probe.setOnClickListener(v -> new android.app.AlertDialog.Builder(c).setTitle("Radio probe").setMessage("Needs Magisk root. Reads the serial ports\' SELinux labels, derives and applies the rules for this session, sends the module\'s version query on each port at several speeds, reads the power node and sniffs for a PCM stream. The stock walkie-talkie app should be closed. Also pulse the power node?")
                .setPositiveButton("Probe", (dd, w) -> runProbe(false)).setNeutralButton("Probe + power pulse", (dd, w) -> runProbe(true)).setNegativeButton("Cancel", null).show());

        // --- identity ---
        LinearLayout id = section(body, "🆔 Your DMR ID");
        idText = Theme.label(c, "", Theme.CYAN, 15, true); id.addView(idText);
        TextView setId = pill(c, "Change DMR ID", Theme.SOFTSQ);
        id.addView(setId, new LayoutParams(bb));
        setId.setOnClickListener(v -> {
            final EditText e = new EditText(c); e.setInputType(InputType.TYPE_CLASS_NUMBER); e.setText(svc != null ? String.valueOf(svc.localId()) : "");
            new android.app.AlertDialog.Builder(c).setTitle("Your DMR ID").setMessage("The radio sends this as the caller ID on digital channels.").setView(e)
                    .setPositiveButton("Save", (dd, w) -> { try { int v2 = Integer.parseInt(e.getText().toString().trim()); if (v2 < 1 || v2 > 16776415) throw new NumberFormatException(); svc.setLocalId(v2); refresh(); } catch (Exception ex) { android.widget.Toast.makeText(c, "Enter an ID between 1 and 16776415", android.widget.Toast.LENGTH_LONG).show(); } })
                    .setNegativeButton("Cancel", null).show();
        });

        // --- data ---
        LinearLayout data = section(body, "💾 Channels & contacts");
        radioIdText = Theme.label(c, "", 0xFF9AA4AE, 13, false); data.addView(radioIdText);
        TextView radioIdBtn = pill(c, "Download / update the RadioID list", Theme.PKT);
        data.addView(radioIdBtn, new LayoutParams(bb));
        radioIdBtn.setOnClickListener(v -> {
            if (svc == null) return;
            final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("RadioID list").setMessage("Connecting to radioid.net\u2026").setCancelable(false).create(); pd.show();
            new Thread(() -> {
                try { int n = svc.radioId().downloadAndImport(t -> post(() -> pd.setMessage(t))); post(() -> { pd.dismiss(); refresh(); android.widget.Toast.makeText(c, String.format(java.util.Locale.US, "%,d DMR IDs loaded", n), android.widget.Toast.LENGTH_LONG).show(); }); }
                catch (Throwable t) { post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, "Download failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); }); }
            }).start();
        });
        hwPttBox = new android.widget.CheckBox(c); hwPttBox.setText("Side PTT key transmits (the phone's hardware push-to-talk button)");
        hwPttBox.setTextColor(0xFFC8D2DC); hwPttBox.setTextSize(13); hwPttBox.setButtonTintList(android.content.res.ColorStateList.valueOf(Theme.CYAN));
        data.addView(hwPttBox, new LayoutParams(bb));
        hwPttBox.setOnCheckedChangeListener((b, on) -> { if (svc != null && on != svc.hwPtt()) svc.setHwPtt(on); });
        scanSqBox = new android.widget.CheckBox(c); scanSqBox.setText("Scanning uses Soft SQ on every analog channel (each channel's own level; channels keep their own setting afterwards)");
        scanSqBox.setTextColor(0xFFC8D2DC); scanSqBox.setTextSize(13); scanSqBox.setButtonTintList(android.content.res.ColorStateList.valueOf(Theme.CYAN));
        data.addView(scanSqBox, new LayoutParams(bb));
        scanSqBox.setOnCheckedChangeListener((b, on) -> { if (svc != null && on != svc.scanSoftSq()) svc.setScanSoftSq(on); });
        voiceBox = new android.widget.CheckBox(c); voiceBox.setText("Voice announcements (channel changes, caller names, keyword alerts)");
        voiceBox.setTextColor(0xFFC8D2DC); voiceBox.setTextSize(13); voiceBox.setButtonTintList(android.content.res.ColorStateList.valueOf(Theme.CYAN));
        data.addView(voiceBox, new LayoutParams(bb));
        voiceBox.setOnCheckedChangeListener((b, on) -> { if (svc != null && on != svc.voiceOn()) svc.setVoiceOn(on); });
        LinearLayout brow = new LinearLayout(c); brow.setGravity(Gravity.CENTER);
        TextView backup = pill(c, "Back up now", Theme.PKT), restore = pill(c, "Restore a backup", Theme.MON);
        brow.addView(backup, new LayoutParams(bl)); brow.addView(restore, new LayoutParams(bl)); data.addView(brow);
        backup.setOnClickListener(v -> new Thread(() -> {
            try { java.io.File dir = com.macdmr.radio.Backup.export(svc.store(), svc.packet() != null ? svc.packet().dtmfSaved() : null); post(() -> android.widget.Toast.makeText(c, "Backed up to Download/DMR/DMR_Backups/" + dir.getName(), android.widget.Toast.LENGTH_LONG).show()); }
            catch (Throwable t) { post(() -> android.widget.Toast.makeText(c, "Backup failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show()); }
        }).start());
        restore.setOnClickListener(v -> {
            final java.util.List<java.io.File> list = com.macdmr.radio.Backup.backups();
            String[] names = new String[list.size() + 1]; for (int i = 0; i < list.size(); i++) names[i] = list.get(i).getName(); names[list.size()] = "\uD83D\uDCC2 Browse for a backup folder\u2026";
            new android.app.AlertDialog.Builder(c).setTitle("Restore which backup?").setItems(names, (dd, w) -> {
                if (w == list.size()) {
                    if (!(c instanceof com.macdmr.radio.MainActivity)) return;
                    ((com.macdmr.radio.MainActivity) c).pickFolder(uri -> new Thread(() -> {
                        try { java.io.File dir = com.macdmr.radio.Backup.copyTree(c, uri); final String r = com.macdmr.radio.Backup.restore(svc.store(), dir); if (svc.packet() != null) for (java.util.Map.Entry<String, String> e : com.macdmr.radio.Backup.readDtmf(dir).entrySet()) svc.packet().dtmfSave(e.getKey(), e.getValue()); svc.selectChannel(svc.store().activeNumber()); post(() -> android.widget.Toast.makeText(c, r, android.widget.Toast.LENGTH_LONG).show()); }
                        catch (Throwable t) { post(() -> android.widget.Toast.makeText(c, "Restore failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show()); }
                    }).start());
                    return;
                }
                new android.app.AlertDialog.Builder(c).setTitle("Restore " + names[w] + "?")
                    .setMessage("Replaces every channel, contact and zone in this app with the backup (OpenGD77 CPS exports work too). History, messages and settings are kept.")
                    .setPositiveButton("Restore", (d3, w3) -> new Thread(() -> {
                        try { final String r = com.macdmr.radio.Backup.restore(svc.store(), list.get(w)); if (svc.packet() != null) for (java.util.Map.Entry<String, String> e : com.macdmr.radio.Backup.readDtmf(list.get(w)).entrySet()) svc.packet().dtmfSave(e.getKey(), e.getValue()); svc.selectChannel(svc.store().activeNumber()); post(() -> android.widget.Toast.makeText(c, r, android.widget.Toast.LENGTH_LONG).show()); }
                        catch (Throwable t) { post(() -> android.widget.Toast.makeText(c, "Restore failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show()); }
                    }).start()).setNegativeButton("Cancel", null).show();
            }).show();
        });
        data.addView(Theme.label(c, "Backups are the same five CSV files (Contacts, TG_Lists, Channels, Zones, DTMF) the DMRModHooks module and the OpenGD77 CPS fork use, in Download/DMR/DMR_Backups, so codeplugs move between all three.", 0xFF8A98A6, 12, false));
        TextView reimport = pill(c, "Re-import from the stock app", Theme.VFO);
        data.addView(reimport, new LayoutParams(bb));
        reimport.setOnClickListener(v -> new Thread(() -> {
            final java.util.List<String> areas = svc.stockAreas();
            post(() -> {
                String[] names = new String[areas.size()]; for (int i = 0; i < names.length; i++) names[i] = areas.get(i).replace('_', ' ').toUpperCase(java.util.Locale.US);
                new android.app.AlertDialog.Builder(c).setTitle("Import which stock area?").setItems(names, (d1, w1) -> new android.app.AlertDialog.Builder(c).setTitle("Re-import " + names[w1] + "?").setMessage("Replaces all channels, contacts, history and messages in this app with that area's current data from the stock app.")
                        .setPositiveButton("Import", (dd, w) -> new Thread(() -> { final String r = svc.reimportFromStock(areas.get(w1)); post(() -> android.widget.Toast.makeText(c, r, android.widget.Toast.LENGTH_LONG).show()); }).start()).setNegativeButton("Cancel", null).show()).show();
            });
        }).start());
        volPttBox = new android.widget.CheckBox(c); volPttBox.setText("Volume-up key transmits while the Intercom page is open");
        volPttBox.setTextColor(0xFFC8D2DC); volPttBox.setTextSize(13); volPttBox.setButtonTintList(android.content.res.ColorStateList.valueOf(Theme.CYAN));
        data.addView(volPttBox, new LayoutParams(bb));
        volPttBox.setOnCheckedChangeListener((b, on) -> c.getSharedPreferences("radio", Context.MODE_PRIVATE).edit().putBoolean("volPtt", on).apply());

        // --- help / diagnostics ---
        LinearLayout more = section(body, "❓ Help & tools");
        TextView upd = pill(c, "Check for updates", Theme.VFO);
        more.addView(upd, new LayoutParams(bb));
        upd.setOnClickListener(v -> com.macdmr.radio.Updater.check(c));
        TextView help = pill(c, "Help & how-to", Theme.PKT), diag = pill(c, "Diagnostics log", Theme.MON);
        LinearLayout hrow = new LinearLayout(c); hrow.addView(help, new LayoutParams(bl)); hrow.addView(diag, new LayoutParams(bl)); more.addView(hrow);
        help.setOnClickListener(v -> { if (host != null) host.openHelp(); });
        diag.setOnClickListener(v -> { if (host != null) host.openDiagnostics(); });
        more.addView(Theme.label(c, "DMR Radio " + com.macdmr.radio.BuildConfig.VERSION_NAME + " — the standalone edition of DMRModHooks. Same radio, no LSPosed.", 0xFF8A98A6, 12, false));
    }

    private void shareZip(final boolean withApks) {
        final Context c = getContext();
        new Thread(() -> { try { final java.io.File zip = com.macdmr.radio.DeviceReport.zipNewest(c, withApks); post(() -> com.macdmr.radio.DeviceReport.share(c, zip)); } catch (Throwable t) { post(() -> android.widget.Toast.makeText(c, "No report yet: generate one first", android.widget.Toast.LENGTH_LONG).show()); } }).start();
    }

    private void runProbe(boolean pulse) {
        final Context c = getContext();
        final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Radio probe").setMessage("Starting\u2026").setCancelable(false).create(); pd.show();
        new Thread(() -> {
            final String r = com.macdmr.radio.RadioProbe.run(c, s -> post(() -> pd.setMessage(s + "\u2026")), pulse);
            final java.io.File dir = com.macdmr.radio.DeviceReport.append("Radio probe", r);
            post(() -> { pd.dismiss(); new android.app.AlertDialog.Builder(c).setTitle("Radio probe").setMessage((dir == null ? "(generate a report first so this is saved)\n\n" : "") + (r.length() > 3000 ? r.substring(0, 3000) + "\u2026" : r)).setPositiveButton("OK", null).show(); });
        }).start();
    }

    private LinearLayout section(LinearLayout parent, String title) {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout s = new LinearLayout(c); s.setOrientation(VERTICAL);
        s.setBackground(Theme.rounded(c, 0x18000000, 0x3300BFFF, 1, 10)); s.setPadding((int) (14 * d), (int) (10 * d), (int) (14 * d), (int) (12 * d));
        LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (10 * d);
        TextView t = Theme.label(c, title, Theme.CYAN2, 15, true); t.setPadding(0, 0, 0, (int) (6 * d)); s.addView(t);
        parent.addView(s, lp);
        return s;
    }

    private static TextView pill(Context c, String text, int[] accent) {
        TextView b = Theme.label(c, text, accent[3], 14, true); b.setGravity(Gravity.CENTER);
        b.setBackground(Theme.rounded(c, accent[0], accent[2], 2, 20)); int p = Theme.dp(c, 10); b.setPadding(p, p, p, p); b.setClickable(true);
        return b;
    }

    public void setHost(Host h) { host = h; }
    public void attach(RadioService s) { svc = s; s.addListener(this); refresh(); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    private void refresh() {
        if (svc == null) return;
        profileText.setText(svc.profile().name + "  ·  " + svc.profile().controlPort + "  ·  audio " + (svc.profile().audio == com.macdmr.radio.DeviceProfile.Audio.TINY_SERVICE ? "vendor service" : "UART PCM"));
        String l = svc.link();
        linkText.setText("ready".equals(l) ? "✅ This app owns the radio" : "no root".equals(l) ? "🔒 Root not granted (Magisk → Superuser)" : "stopped".equals(l) ? "⏸ Stock app owns the radio" : "unsupported".equals(l) ? "📱 No profile for this phone yet — make a device report below" : "⏳ " + l);
        idText.setText("ID " + svc.localId());
        ownAtBoot.setChecked(svc.ownAtBoot());
        voiceBox.setChecked(svc.voiceOn());
        hwPttBox.setChecked(svc.hwPtt()); scanSqBox.setChecked(svc.scanSoftSq());
        volPttBox.setChecked(getContext().getSharedPreferences("radio", Context.MODE_PRIVATE).getBoolean("volPtt", false));
        radioIdText.setText("RadioID names: " + svc.radioId().status());
    }

    @Override public void onLink(String state) { refresh(); }
    @Override public void onChannel(ChannelStore.Channel ch) { } @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { } @Override public void onLog(String s) { }
    @Override public void onLocation(String t) { } @Override public void onSms(int f, int ty, String te) { } @Override public void onSmsResult(boolean ok) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f2, boolean g, String z) { }
    @Override public void onCaption(boolean en, String live, String sentence) { }
}
