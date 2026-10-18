package com.macdmr.radio.ui;

import android.content.Context;
import android.text.InputType;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.RootSetup;

/**
 * Device tab: a link card (who owns the radio, port and speed, take over / hand back, boot persistence),
 * radio settings as neon switches (boot ownership, side and volume PTT keys, scan-time Soft SQ, voice,
 * intercom look), the DMR ID, and tool tiles (backup, restore, stock re-import, RadioID list, device
 * report, updates, help, diagnostics).
 */
public class DeviceView extends LinearLayout implements RadioService.Listener {
    public interface Host { void openHelp(); void openDiagnostics(); void intercomStyleChanged(); }

    private final LinearLayout header, hero;
    private final TextView linkText, profileText, idText;
    private final View linkDot;
    private final ImageView heroIcon;
    private final TextView takeOver, handBack, reportNow;
    private final Neo.NeonSwitch ownAtBoot, voiceSw, hwPttSw, volPttSw, scanSqSw, styleSw;
    private final LinearLayout radioIdTile;
    private RadioService svc;
    private Host host;

    public DeviceView(Context c) {
        super(c);
        setOrientation(VERTICAL);   // background: the window's
        float d = Theme.dp(c);
        header = Neo.header(c, "Device", "");
        addView(header);

        ScrollView sv = new ScrollView(c); sv.setVerticalScrollBarEnabled(false);
        LinearLayout body = new LinearLayout(c); body.setOrientation(VERTICAL); body.setPadding((int) (16 * d), (int) (12 * d), (int) (16 * d), (int) (28 * d));
        sv.addView(body); addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));

        // ---- link hero ----
        hero = new LinearLayout(c); hero.setOrientation(VERTICAL); hero.setPadding((int) (14 * d), (int) (14 * d), (int) (14 * d), (int) (14 * d));
        LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
        heroIcon = Neo.iconTile(c, "module", Neo.GREEN, 52);
        top.addView(heroIcon, new LayoutParams((int) (52 * d), (int) (52 * d)));
        LinearLayout tc = new LinearLayout(c); tc.setOrientation(VERTICAL); tc.setPadding((int) (12 * d), 0, 0, 0);
        LinearLayout st = new LinearLayout(c); st.setGravity(Gravity.CENTER_VERTICAL);
        linkDot = new View(c); st.addView(linkDot, new LayoutParams((int) (9 * d), (int) (9 * d)));
        linkText = Neo.text(c, "", Neo.GREEN_LIGHT, 18, Neo.ui(c)); linkText.setPadding((int) (8 * d), 0, 0, 0);
        st.addView(linkText, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        tc.addView(st);
        profileText = Neo.text(c, "", 0xFF9FB4C8, 13, Neo.mono(c)); profileText.setPadding(0, (int) (5 * d), 0, 0);
        tc.addView(profileText);
        top.addView(tc, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        hero.addView(top);
        LinearLayout hb = new LinearLayout(c); hb.setBaselineAligned(false);
        takeOver = Neo.button(c, "Take over", "takeover", Neo.GREEN); handBack = Neo.button(c, "Hand back", "handback", Neo.AMBER);
        LayoutParams hl = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); hl.setMargins(0, (int) (12 * d), (int) (4 * d), 0);
        LayoutParams hr = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); hr.setMargins((int) (4 * d), (int) (12 * d), 0, 0);
        hb.addView(takeOver, hl); hb.addView(handBack, hr);
        hero.addView(hb);
        takeOver.setOnClickListener(v -> { if (svc != null) svc.bringUp(); });
        handBack.setOnClickListener(v -> { if (svc != null) svc.shutDown(true); });
        TextView boot = Neo.button(c, "Keep access after reboot", "shield", Neo.CYAN);
        LayoutParams bl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); bl.topMargin = (int) (8 * d);
        hero.addView(boot, bl);
        boot.setOnClickListener(v -> new Thread(() -> {
            final String r = svc != null ? RootSetup.installBootModule(svc.profile(), getContext().getCacheDir()) : "service not ready";
            post(() -> new android.app.AlertDialog.Builder(getContext()).setTitle("Boot persistence").setMessage(r).setPositiveButton("OK", null).show());
        }).start());
        reportNow = Neo.button(c, "Make a device report for this phone", "report", Neo.VIOLET);
        hero.addView(reportNow, new LayoutParams(bl)); reportNow.setVisibility(GONE);
        reportNow.setOnClickListener(v -> generateReport());
        TextView note = Neo.text(c, "Needs root (Magisk). While this app owns the radio the stock walkie-talkie app is paused and its icon hidden; Hand back restores it. The Magisk module keeps the SELinux rules across reboots so the radio can be owned straight from boot.", Neo.MUTED, 13, Neo.uiMedium(c));
        note.setLineSpacing(0, 1.1f); note.setPadding(0, (int) (10 * d), 0, 0);
        hero.addView(note);
        body.addView(hero, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));

        // ---- radio settings ----
        LinearLayout set = card(body, "Radio settings");
        ownAtBoot = sw(); hwPttSw = sw(); volPttSw = sw(); scanSqSw = sw(); voiceSw = sw(); styleSw = sw();
        addRow(set, Neo.switchRow(c, "power", Neo.GREEN, "Own the radio at boot", "Otherwise the stock app is restored after a reboot", ownAtBoot));
        addRow(set, Neo.switchRow(c, "ptt", Neo.AMBER, "Side PTT key", "The phone's hardware push-to-talk button transmits", hwPttSw));
        addRow(set, Neo.switchRow(c, "volume", Neo.AMBER, "Volume-up transmits", "While the Intercom page is open", volPttSw));
        addRow(set, Neo.switchRow(c, "softsq", Neo.CYAN, "Soft SQ while scanning", "Every analog channel, each at its own level", scanSqSw));
        addRow(set, Neo.switchRow(c, "voice", Neo.VIOLET, "Voice announcements", "Channel changes, caller names, keyword alerts", voiceSw));
        addRow(set, Neo.switchRow(c, "intercom", Neo.CYAN, "New intercom look", "Off: the classic intercom page", styleSw));
        ownAtBoot.setOnChange(on -> { if (svc != null) svc.setOwnAtBoot(on); });
        hwPttSw.setOnChange(on -> { if (svc != null) svc.setHwPtt(on); });
        volPttSw.setOnChange(on -> c.getSharedPreferences("radio", Context.MODE_PRIVATE).edit().putBoolean("volPtt", on).apply());
        scanSqSw.setOnChange(on -> { if (svc != null) svc.setScanSoftSq(on); });
        voiceSw.setOnChange(on -> { if (svc != null) svc.setVoiceOn(on); });
        styleSw.setOnChange(on -> { IntercomView.setNewLook(c, on); if (host != null) host.intercomStyleChanged(); });

        // ---- identity ----
        LinearLayout id = card(body, "Your DMR ID");
        LinearLayout idRow = new LinearLayout(c); idRow.setGravity(Gravity.CENTER_VERTICAL); idRow.setPadding((int) (14 * d), (int) (4 * d), (int) (14 * d), (int) (12 * d));
        idRow.addView(Neo.iconTile(c, "id", Neo.CYAN, 38), new LayoutParams((int) (38 * d), (int) (38 * d)));
        idText = Neo.text(c, "", Neo.CYAN, 22, Neo.mono(c)); idText.setPadding((int) (12 * d), 0, 0, 0);
        idRow.addView(idText, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        TextView setId = Neo.button(c, "Change", null, Neo.CYAN); setId.setMinHeight((int) (40 * d));
        idRow.addView(setId, new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
        id.addView(idRow);
        setId.setOnClickListener(v -> {
            final EditText e = new EditText(c); e.setInputType(InputType.TYPE_CLASS_NUMBER); e.setText(svc != null ? String.valueOf(svc.localId()) : "");
            new android.app.AlertDialog.Builder(c).setTitle("Your DMR ID").setMessage("The radio sends this as the caller ID on digital channels.").setView(e)
                    .setPositiveButton("Save", (dd, w) -> { try { int v2 = Integer.parseInt(e.getText().toString().trim()); if (v2 < 1 || v2 > 16776415) throw new NumberFormatException(); svc.setLocalId(v2); refresh(); } catch (Exception ex) { android.widget.Toast.makeText(c, "Enter an ID between 1 and 16776415", android.widget.Toast.LENGTH_LONG).show(); } })
                    .setNegativeButton("Cancel", null).show();
        });

        // ---- tools ----
        TextView th = Neo.caps(c, "Tools"); th.setPadding((int) (2 * d), (int) (18 * d), 0, (int) (8 * d)); body.addView(th);
        LinearLayout backup = Neo.tile(c, "backup", Neo.GREEN, "Back up", "Five CSVs, CPS-ready");
        LinearLayout restore = Neo.tile(c, "restore", Neo.AMBER, "Restore", "From a backup folder");
        LinearLayout reimport = Neo.tile(c, "import", Neo.AMBER, "Re-import", "Channels from the stock app");
        radioIdTile = Neo.tile(c, "globe", Neo.CYAN, "RadioID list", "");
        LinearLayout report = Neo.tile(c, "report", Neo.VIOLET, "Device report", "For unsupported phones");
        LinearLayout upd = Neo.tile(c, "update", Neo.CYAN, "Updates", "Check GitHub releases");
        LinearLayout help = Neo.tile(c, "help", Neo.GREEN, "Help & how-to", "Every screen explained");
        LinearLayout diag = Neo.tile(c, "diag", Neo.AMBER, "Diagnostics", "Live protocol log");
        LinearLayout[] tiles = { backup, restore, reimport, radioIdTile, report, upd, help, diag };
        for (int i = 0; i < tiles.length; i += 2) {
            LinearLayout r = new LinearLayout(c); r.setBaselineAligned(false);
            LayoutParams l1 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); l1.setMargins(0, 0, (int) (4 * d), (int) (8 * d));
            LayoutParams l2 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); l2.setMargins((int) (4 * d), 0, 0, (int) (8 * d));
            r.addView(tiles[i], l1); r.addView(tiles[i + 1], l2);
            body.addView(r);
        }
        backup.setOnClickListener(v -> doBackup());
        restore.setOnClickListener(v -> doRestore());
        reimport.setOnClickListener(v -> doReimport());
        radioIdTile.setOnClickListener(v -> doRadioId());
        report.setOnClickListener(v -> reportMenu());
        upd.setOnClickListener(v -> com.macdmr.radio.Updater.check(c));
        help.setOnClickListener(v -> { if (host != null) host.openHelp(); });
        diag.setOnClickListener(v -> { if (host != null) host.openDiagnostics(); });

        TextView foot = Neo.text(c, "Backups are the five CSV files (Contacts, TG_Lists, Channels, Zones, DTMF) the DMRModHooks module and the OpenGD77 CPS fork use, in Download/DMR/DMR_Backups.\n\nDMR Radio " + com.macdmr.radio.BuildConfig.VERSION_NAME + ", the standalone edition of DMRModHooks.", Neo.DIM, 12.5f, Neo.uiMedium(c));
        foot.setLineSpacing(0, 1.1f); foot.setPadding((int) (2 * d), (int) (8 * d), (int) (2 * d), 0);
        body.addView(foot);
    }

    private Neo.NeonSwitch sw() { return new Neo.NeonSwitch(getContext()); }

    private LinearLayout card(LinearLayout body, String title) {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout s = new LinearLayout(c); s.setOrientation(VERTICAL); s.setBackground(Neo.card(c, Neo.LINE, 18));
        s.setPadding(0, (int) (4 * d), 0, (int) (4 * d));
        TextView t = Neo.caps(c, title); t.setPadding((int) (14 * d), (int) (10 * d), (int) (14 * d), (int) (6 * d)); s.addView(t);
        LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.topMargin = (int) (12 * d);
        body.addView(s, lp);
        return s;
    }

    private void addRow(LinearLayout card, LinearLayout row) {
        View div = new View(getContext()); div.setBackgroundColor(Neo.DIVIDER);
        card.addView(div, new LayoutParams(LayoutParams.MATCH_PARENT, 1));
        card.addView(row);
    }

    // ---- actions ----
    private void doBackup() {
        final Context c = getContext(); if (svc == null) return;
        new Thread(() -> {
            try { java.io.File dir = com.macdmr.radio.Backup.export(svc.store(), svc.packet() != null ? svc.packet().dtmfSaved() : null); post(() -> android.widget.Toast.makeText(c, "Backed up to Download/DMR/DMR_Backups/" + dir.getName(), android.widget.Toast.LENGTH_LONG).show()); }
            catch (Throwable t) { post(() -> android.widget.Toast.makeText(c, "Backup failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show()); }
        }).start();
    }

    private void doRestore() {
        final Context c = getContext(); if (svc == null) return;
        final java.util.List<java.io.File> list = com.macdmr.radio.Backup.backups();
        final String[] names = new String[list.size() + 1]; for (int i = 0; i < list.size(); i++) names[i] = list.get(i).getName(); names[list.size()] = "Browse for a backup folder…";
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
    }

    private void doReimport() {
        final Context c = getContext(); if (svc == null) return;
        new Thread(() -> {
            final java.util.List<String> areas = svc.stockAreas();
            post(() -> {
                String[] names = new String[areas.size()]; for (int i = 0; i < names.length; i++) names[i] = areas.get(i).replace('_', ' ').toUpperCase(java.util.Locale.US);
                new android.app.AlertDialog.Builder(c).setTitle("Import which stock area?").setItems(names, (d1, w1) -> new android.app.AlertDialog.Builder(c).setTitle("Re-import " + names[w1] + "?").setMessage("Replaces all channels, contacts, history and messages in this app with that area's current data from the stock app.")
                        .setPositiveButton("Import", (dd, w) -> new Thread(() -> { final String r = svc.reimportFromStock(areas.get(w1)); post(() -> android.widget.Toast.makeText(c, r, android.widget.Toast.LENGTH_LONG).show()); }).start()).setNegativeButton("Cancel", null).show()).show();
            });
        }).start();
    }

    private void doRadioId() {
        final Context c = getContext(); if (svc == null) return;
        new android.app.AlertDialog.Builder(c).setTitle("RadioID list").setMessage("Names for DMR IDs heard on air, downloaded from radioid.net and stored on the phone.\n\nNow: " + svc.radioId().status())
                .setPositiveButton("Download / update", (dd, w) -> {
                    final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("RadioID list").setMessage("Connecting to radioid.net…").setCancelable(false).create(); pd.show();
                    new Thread(() -> {
                        try { int n = svc.radioId().downloadAndImport(t -> post(() -> pd.setMessage(t))); post(() -> { pd.dismiss(); refresh(); android.widget.Toast.makeText(c, String.format(java.util.Locale.US, "%,d DMR IDs loaded", n), android.widget.Toast.LENGTH_LONG).show(); }); }
                        catch (Throwable t) { post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, "Download failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); }); }
                    }).start();
                }).setNegativeButton("Close", null).show();
    }

    private void reportMenu() {
        final Context c = getContext();
        new android.app.AlertDialog.Builder(c).setTitle("Device report")
                .setItems(new String[] { "Generate device report", "Share last report", "Capture the PTT key (10 s)", "Radio probe (root)", "Open a GitHub issue with the facts filled in", "What is in it?" }, (dd, w) -> {
                    if (w == 0) generateReport();
                    else if (w == 1) shareReport();
                    else if (w == 2) captureKeys();
                    else if (w == 3) probe();
                    else if (w == 4) com.macdmr.radio.DeviceReport.openIssue(c);
                    else new android.app.AlertDialog.Builder(c).setTitle("Device report").setMessage("For a phone that has no profile yet, or to help debug one: gathers the facts a profile needs (serial ports, radio-module nodes, the stock walkie-talkie app and its APK, vendor libraries, framework jars, services; with root also SELinux labels and the PTT key broadcasts), saves it under Download/DMR/DeviceReport and offers to share the zip to a GitHub issue. Nothing on the phone is changed.").setPositiveButton("OK", null).show();
                }).show();
    }

    private void generateReport() {
        final Context c = getContext();
        final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Device report").setMessage("Starting…").setCancelable(false).create(); pd.show();
        new Thread(() -> {
            try { com.macdmr.radio.DeviceReport.generate(c, s -> post(() -> pd.setMessage(s + "…"))); post(() -> { pd.dismiss(); new android.app.AlertDialog.Builder(c).setTitle("Report ready").setMessage("Saved under Download/DMR/DeviceReport. If the phone has a side PTT key, run \"Capture the PTT key\" and, with root, the radio probe, then use Share last report, which explains what it contains.").setPositiveButton("OK", null).show(); }); }
            catch (Throwable t) { post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, "Report failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); }); }
        }).start();
    }

    private void shareReport() {
        new android.app.AlertDialog.Builder(getContext()).setTitle("Share the device report")
                .setMessage("The report holds phone model and build facts, serial-port and radio-module node names, the walkie-talkie app's package details, library and framework file names, running radio processes, and (with root) SELinux labels and short radio-related log excerpts with message text removed and long numbers masked. No accounts, contacts, messages, location or identifiers such as IMEI.\n\nThe copied stock walkie-talkie APK is the manufacturer's software: include it if you are comfortable posting it, or share without it (we can ask for it privately).")
                .setPositiveButton("Share all", (dd, w) -> shareZip(true)).setNeutralButton("Without the APK", (dd, w) -> shareZip(false)).setNegativeButton("Cancel", null).show();
    }

    private void captureKeys() {
        final Context c = getContext();
        final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Press the PTT key now").setMessage("Press and release the phone's side PTT button a few times within the next 10 seconds. Everything the phone reports for it is recorded.").setCancelable(false).create(); pd.show();
        new Thread(() -> { final String r = com.macdmr.radio.DeviceReport.captureKeys(c, 10); final java.io.File dir = com.macdmr.radio.DeviceReport.append("PTT key capture", r); post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, dir == null ? "Captured, but generate a report first so it can be saved" : "Saved to the report", android.widget.Toast.LENGTH_LONG).show(); }); }).start();
    }

    private void probe() {
        new android.app.AlertDialog.Builder(getContext()).setTitle("Radio probe").setMessage("Needs Magisk root. Reads the serial ports' SELinux labels, derives and applies the rules for this session, sends the module's version query on each port at several speeds, reads the power node and sniffs for a PCM stream. The stock walkie-talkie app should be closed. Also pulse the power node?")
                .setPositiveButton("Probe", (dd, w) -> runProbe(false)).setNeutralButton("Probe + power pulse", (dd, w) -> runProbe(true)).setNegativeButton("Cancel", null).show();
    }

    private void shareZip(final boolean withApks) {
        final Context c = getContext();
        new Thread(() -> { try { final java.io.File zip = com.macdmr.radio.DeviceReport.zipNewest(c, withApks); post(() -> com.macdmr.radio.DeviceReport.share(c, zip)); } catch (Throwable t) { post(() -> android.widget.Toast.makeText(c, "No report yet: generate one first", android.widget.Toast.LENGTH_LONG).show()); } }).start();
    }

    private void runProbe(boolean pulse) {
        final Context c = getContext();
        final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Radio probe").setMessage("Starting…").setCancelable(false).create(); pd.show();
        new Thread(() -> {
            final String r = com.macdmr.radio.RadioProbe.run(c, s -> post(() -> pd.setMessage(s + "…")), pulse);
            final java.io.File dir = com.macdmr.radio.DeviceReport.append("Radio probe", r);
            post(() -> { pd.dismiss(); new android.app.AlertDialog.Builder(c).setTitle("Radio probe").setMessage((dir == null ? "(generate a report first so this is saved)\n\n" : "") + (r.length() > 3000 ? r.substring(0, 3000) + "…" : r)).setPositiveButton("OK", null).show(); });
        }).start();
    }

    public void setHost(Host h) { host = h; }
    public void attach(RadioService s) { svc = s; s.addListener(this); refresh(); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    private void refresh() {
        if (svc == null) return;
        Context c = getContext(); float d = Theme.dp(c);
        Neo.headerSubtitle(header).setText(svc.profile().name.toUpperCase(java.util.Locale.US));
        profileText.setText(svc.profile().controlPort + " · " + svc.profile().baud + " · " + (svc.profile().audio == com.macdmr.radio.DeviceProfile.Audio.TINY_SERVICE ? "vendor audio" : "UART PCM"));
        String l = svc.link();
        boolean ready = "ready".equals(l), unsupported = "unsupported".equals(l), bad = "no root".equals(l) || unsupported;
        int accent = ready ? Neo.GREEN : bad ? Neo.AMBER : "stopped".equals(l) ? Neo.CYAN : Neo.AMBER;
        linkText.setText(ready ? "This app owns the radio" : "no root".equals(l) ? "Root not granted (Magisk → Superuser)" : "stopped".equals(l) ? "The stock app owns the radio" : unsupported ? "No profile for this phone yet" : "Starting: " + l);
        linkText.setTextColor(ready ? Neo.GREEN_LIGHT : accent == Neo.CYAN ? Neo.CYAN_LIGHT : Neo.AMBER_LIGHT);
        android.graphics.drawable.GradientDrawable dot = new android.graphics.drawable.GradientDrawable(); dot.setShape(android.graphics.drawable.GradientDrawable.OVAL); dot.setColor(accent);
        linkDot.setBackground(dot);
        hero.setBackground(Neo.tint(c, accent, 18, 1));
        heroIcon.setImageDrawable(new Neo.IconDrawable(unsupported ? "report" : "module", accent));
        android.graphics.drawable.GradientDrawable ib = new android.graphics.drawable.GradientDrawable(); ib.setColor(Neo.alpha(accent, 0x16)); ib.setCornerRadius(16 * d); ib.setStroke((int) d, Neo.alpha(accent, 0x77));
        heroIcon.setBackground(ib);
        takeOver.setVisibility(unsupported ? GONE : VISIBLE); handBack.setVisibility(unsupported ? GONE : VISIBLE); reportNow.setVisibility(unsupported ? VISIBLE : GONE);
        takeOver.setAlpha(ready ? 0.55f : 1f); handBack.setAlpha(ready ? 1f : 0.55f);
        idText.setText("ID " + svc.localId());
        ownAtBoot.setChecked(svc.ownAtBoot()); voiceSw.setChecked(svc.voiceOn()); hwPttSw.setChecked(svc.hwPtt()); scanSqSw.setChecked(svc.scanSoftSq());
        volPttSw.setChecked(c.getSharedPreferences("radio", Context.MODE_PRIVATE).getBoolean("volPtt", false));
        styleSw.setChecked(IntercomView.newLook(c));
        ((TextView) radioIdTile.findViewWithTag("sub")).setText(svc.radioId().status());
    }

    @Override public void onLink(String state) { refresh(); }
    @Override public void onChannel(ChannelStore.Channel ch) { } @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { } @Override public void onLog(String s) { }
    @Override public void onLocation(String t) { } @Override public void onSms(int f, int ty, String te) { } @Override public void onSmsResult(boolean ok) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f2, boolean g, String z) { }
    @Override public void onCaption(boolean en, String live, String sentence) { }
}
