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
    public interface Host { void openHelp(); void openDiagnostics(); void intercomStyleChanged(); void animatedPanelChanged(boolean on); }

    private final LinearLayout header, hero;
    private final TextView linkText, profileText, idText;
    private final View linkDot;
    private final ImageView heroIcon;
    private final TextView takeOver, handBack, reportNow;
    private final Neo.NeonSwitch ownAtBoot, voiceSw, hwPttSw, volPttSw, scanSqSw, styleSw, animSw, covSw, carMicSw, carCovSw, wheelSw, carScreenSw;
    private TextView nextTalkValue, wheelMicValue, voxValue;
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
        takeOver.setOnClickListener(v -> {
            if (svc == null) return;
            if (svc.profile().verified || svc.isReady()) { svc.bringUp(); return; }
            new android.app.AlertDialog.Builder(getContext()).setTitle("Untested profile")
                    .setMessage("SignalDeck has a profile for the " + svc.profile().name + ", written from its stock app and the owner's reports, but it has never run on this phone. Taking over pauses " + svc.profile().stockApp + " and opens the radio's serial ports. If it fails, the stock app is switched back on; Hand back or a reboot also gives it back.\n\nFirst run Device report → Generate device report and Radio probe (root) and share them: that is what turns this into a tested profile.")
                    .setPositiveButton("Take over", (dd, w) -> svc.bringUp()).setNegativeButton("Cancel", null).show();
        });
        handBack.setOnClickListener(v -> { if (svc != null) svc.shutDown(true); });
        TextView boot = Neo.button(c, "Keep access after reboot", "shield", Neo.CYAN);
        LayoutParams bl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); bl.topMargin = (int) (8 * d);
        hero.addView(boot, bl);
        boot.setOnClickListener(v -> new Thread(() -> {
            final String r = svc != null ? RootSetup.installBootModule(svc.profile(), getContext().getCacheDir()) : "service not ready";
            post(() -> new android.app.AlertDialog.Builder(getContext()).setTitle("Boot persistence").setMessage(r).setPositiveButton("OK", null).show());
        }).start());
        reportNow = Neo.button(c, "Run all checks for this phone", "report", Neo.VIOLET);
        hero.addView(reportNow, new LayoutParams(bl)); reportNow.setVisibility(GONE);
        reportNow.setOnClickListener(v -> offerChecks(false));
        TextView note = Neo.text(c, "Needs root (Magisk). While this app owns the radio the stock walkie-talkie app is paused and its icon hidden; Hand back restores it. The Magisk module keeps the SELinux rules across reboots so the radio can be owned straight from boot.", Neo.MUTED, 13, Neo.uiMedium(c));
        note.setLineSpacing(0, 1.1f); note.setPadding(0, (int) (10 * d), 0, 0);
        hero.addView(note);
        body.addView(hero, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));

        // ---- radio settings ----
        LinearLayout set = card(body, "Radio settings");
        ownAtBoot = sw(); hwPttSw = sw(); volPttSw = sw(); scanSqSw = sw(); voiceSw = sw(); styleSw = sw(); animSw = sw(); covSw = sw(); carMicSw = sw(); carCovSw = sw(); wheelSw = sw(); carScreenSw = sw();
        addRow(set, Neo.switchRow(c, "power", Neo.GREEN, "Own the radio at boot", "Otherwise the stock app is restored after a reboot", ownAtBoot));
        addRow(set, Neo.switchRow(c, "ptt", Neo.AMBER, "Side PTT key", "The phone's hardware push-to-talk button transmits", hwPttSw));
        addRow(set, Neo.switchRow(c, "volume", Neo.AMBER, "Volume-up transmits", "While the Intercom page is open", volPttSw));
        addRow(set, Neo.switchRow(c, "softsq", Neo.CYAN, "Soft SQ while scanning", "Every analog channel, each at its own level", scanSqSw));
        addRow(set, Neo.switchRow(c, "voice", Neo.VIOLET, "Voice announcements", "Channel changes, caller names, keyword alerts", voiceSw));
        addRow(set, rogerRow(c));
        addRow(set, Neo.switchRow(c, "intercom", Neo.CYAN, "New intercom look", "Off: the classic intercom page", styleSw));
        addRow(set, Neo.switchRow(c, "diag", Neo.CYAN, "Animated panel when quiet", "Falling lines on an idle channel (uses a little battery)", animSw));
        addRow(set, Neo.switchRow(c, "signal", Neo.VIOLET, "Coverage logging", "Records signal and key-ups with GPS for the coverage maps (Map → Coverage)", covSw));
        addRow(set, Neo.switchRow(c, "ptt", Neo.AMBER, "Car microphone in Android Auto", "Talk uses the car's microphone through its hands-free link", carMicSw));
        carMicSw.setOnChange(on -> { if (svc != null) svc.setCarMic(on); });
        autoWarn = Neo.switchRow(c, "alert", Neo.AMBER, "Android Auto is hiding this app", "Unknown sources is off, so the car does not list SignalDeck. Tap for the fix", null);
        autoWarnDiv = new View(c); autoWarnDiv.setBackgroundColor(Neo.DIVIDER);
        set.addView(autoWarnDiv, new LayoutParams(LayoutParams.MATCH_PARENT, 1)); set.addView(autoWarn);
        autoWarn.setOnClickListener(v -> autoTrustSheet());
        autoWarn.setVisibility(GONE); autoWarnDiv.setVisibility(GONE);
        checkAutoTrust();
        addRow(set, Neo.switchRow(c, "signal", Neo.VIOLET, "Log coverage in the car", "Coverage logging while Android Auto is connected", carCovSw));
        carCovSw.setOnChange(on -> { if (svc != null) svc.setCoverageInCar(on); });
        addRow(set, Neo.switchRow(c, "ptt", Neo.RED, "Steering-wheel play/pause talks", "In Android Auto: the wheel's play/pause starts and stops transmitting", wheelSw));
        wheelSw.setOnChange(on -> { if (svc != null) svc.setWheelTalk(on); });
        LinearLayout nextRow = Neo.switchRow(c, "ptt", Neo.RED, "Steering-wheel Next talks", "Hold: hold Next to talk, press again if it keeps talking. Double-press: press twice to talk, once to stop. Tap to change", null);
        nextTalkValue = Neo.chip(c, com.macdmr.radio.RadioService.NEXT_TALK_NAMES[com.macdmr.radio.ham.WheelNext.DOUBLE], Neo.RED); nextRow.addView(nextTalkValue);
        nextRow.setOnClickListener(v -> { if (svc == null) return; int m = (svc.nextTalkMode() + 1) % 3; svc.setNextTalkMode(m); nextTalkValue.setText(com.macdmr.radio.RadioService.NEXT_TALK_NAMES[m]); });
        addRow(set, nextRow);
        LinearLayout micRow = Neo.switchRow(c, "voice", Neo.RED, "Steering-wheel microphone", "Car (as a call): the car's microphone; stop with the wheel's hang-up or End. Phone: the phone's microphone; stop with the wheel. Tap to change", null);
        wheelMicValue = Neo.chip(c, com.macdmr.radio.RadioService.WHEEL_MIC_NAMES[1], Neo.RED); micRow.addView(wheelMicValue);
        micRow.setOnClickListener(v -> { if (svc == null) return; int m = (svc.wheelMic() + 1) % 2; svc.setWheelMic(m); wheelMicValue.setText(com.macdmr.radio.RadioService.WHEEL_MIC_NAMES[m]); });
        addRow(set, micRow);
        LinearLayout voxRow = Neo.switchRow(c, "mon", Neo.RED, "Stop when I stop talking", "For transmissions started from the wheel: unkey after this much quiet. Tap to change", null);
        voxValue = Neo.chip(c, com.macdmr.radio.RadioService.VOX_NAMES[1], Neo.RED); voxRow.addView(voxValue);
        voxRow.setOnClickListener(v -> { if (svc == null) return; int m = (svc.voxStop() + 1) % com.macdmr.radio.RadioService.VOX_NAMES.length; svc.setVoxStop(m); voxValue.setText(com.macdmr.radio.RadioService.VOX_NAMES[m]); });
        addRow(set, voxRow);
        addRow(set, Neo.switchRow(c, "intercom", Neo.CYAN, "Full-screen Radio controls in the car", "Off: a media app (works in every car). On: a big Talk screen instead; reconnect the car after changing", carScreenSw));
        carScreenSw.setOnChange(on -> { if (svc != null) svc.setCarControlsScreen(on); });
        covSw.setOnChange(on -> { if (svc != null) { svc.setCoverageLogging(on); android.widget.Toast.makeText(c, on ? "Coverage logging is on" : "Coverage logging is off", android.widget.Toast.LENGTH_SHORT).show(); } });
        animSw.setOnChange(on -> { if (host != null) host.animatedPanelChanged(on); });
        ownAtBoot.setOnChange(on -> { if (svc != null) svc.setOwnAtBoot(on); });
        hwPttSw.setOnChange(on -> { if (svc != null) svc.setHwPtt(on); });
        volPttSw.setOnChange(on -> c.getSharedPreferences("radio", Context.MODE_PRIVATE).edit().putBoolean("volPtt", on).apply());
        scanSqSw.setOnChange(on -> { if (svc != null) svc.setScanSoftSq(on); });
        voiceSw.setOnChange(on -> { if (svc != null) svc.setVoiceOn(on); });
        styleSw.setOnChange(on -> { IntercomView.setNewLook(c, on); if (host != null) host.intercomStyleChanged(); });

        // ---- SignalDeck Web ----
        LinearLayout web = card(body, "SignalDeck Web");
        webSw = sw(); webTxSw = sw();
        LinearLayout webRow = Neo.switchRow(c, WEB_ICON, Neo.CYAN, "Web access", "Use SignalDeck from a browser on the same Wi-Fi", webSw);
        webSub = (TextView) ((LinearLayout) webRow.getChildAt(1)).getChildAt(1);
        addRow(web, webRow);
        addRow(web, Neo.switchRow(c, "ptt", Neo.RED, "Allow transmit from the web", "Off: a browser can listen and change channels but never keys the radio", webTxSw));
        LinearLayout pinRow = Neo.switchRow(c, "shield", Neo.AMBER, "New PIN", "Makes a new PIN and logs every browser out", null);
        pinRow.setOnClickListener(v -> { if (svc != null) { svc.web().newPin(); updateWeb(); } });
        addRow(web, pinRow);
        webSw.setOnChange(on -> { if (svc == null) return; String e = svc.web().setEnabled(on); if (e != null) android.widget.Toast.makeText(c, e, android.widget.Toast.LENGTH_LONG).show(); updateWeb(); });
        webTxSw.setOnChange(on -> { if (svc != null) svc.web().setAllowTx(on); });

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
        LinearLayout widget = Neo.tile(c, "widget", Neo.VIOLET, "Home widget", "Channel, scan and Talk");
        LinearLayout sos = Neo.tile(c, "alert", Neo.RED, "Emergency", "Send your position");
        LinearLayout[] tiles = { backup, restore, reimport, radioIdTile, report, upd, help, diag, widget, sos };
        for (int i = 0; i < tiles.length; i += 2) {
            LinearLayout r = new LinearLayout(c); r.setBaselineAligned(false);
            LayoutParams l1 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); l1.setMargins(0, 0, (int) (4 * d), (int) (8 * d));
            LayoutParams l2 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); l2.setMargins((int) (4 * d), 0, 0, (int) (8 * d));
            r.addView(tiles[i], l1); r.addView(tiles[i + 1] != null ? tiles[i + 1] : new android.view.View(c), l2);
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
        widget.setOnClickListener(v -> widgetSheet());
        sos.setOnClickListener(v -> EmergencyDialog.show(c, svc));

        TextView foot = Neo.text(c, "Backups are the five CSV files (Contacts, TG_Lists, Channels, Zones, DTMF) the DMRModHooks module and the OpenGD77 CPS fork use, in Download/DMR/DMR_Backups.\n\nSignalDeck " + com.macdmr.radio.BuildConfig.VERSION_NAME + ", the standalone edition of DMRModHooks.", Neo.DIM, 12.5f, Neo.uiMedium(c));
        foot.setLineSpacing(0, 1.1f); foot.setPadding((int) (2 * d), (int) (8 * d), (int) (2 * d), 0);
        body.addView(foot);
    }

    /** Device → Home widget: the live widget as it will look, and a button that asks the launcher to add it. */
    private void widgetSheet() {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout box = Neo.sheetBody(c, "Home widget");
        box.addView(Neo.sheetHint(c, "The channel, what the radio is doing, and previous / scan / next / Talk buttons on your home screen. Talk is tap to start, tap to stop, and ends by itself after 28 seconds. The notification has the same channel and scan buttons."));
        android.widget.FrameLayout holder = new android.widget.FrameLayout(c);
        try { holder.addView(com.macdmr.radio.RadioWidget.build(c, com.macdmr.radio.RadioService.running).apply(c.getApplicationContext(), holder)); /* app context: the activity inflater swaps in AppCompat views, which RemoteViews refuses */ } catch (Throwable t) { holder.addView(Neo.sheetHint(c, "Preview unavailable: " + t.getMessage())); }
        LayoutParams hl = new LayoutParams(LayoutParams.MATCH_PARENT, (int) (150 * d)); hl.setMargins(0, (int) (10 * d), 0, (int) (12 * d));
        box.addView(holder, hl);
        TextView add = Neo.button(c, "Add to home screen", "widget", Neo.VIOLET);
        box.addView(add, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
        final android.app.Dialog dlg = Neo.showSheet(c, box);
        add.setOnClickListener(v -> {
            android.appwidget.AppWidgetManager m = android.appwidget.AppWidgetManager.getInstance(c);
            boolean asked = false;
            try { if (m.isRequestPinAppWidgetSupported()) asked = m.requestPinAppWidget(new android.content.ComponentName(c, com.macdmr.radio.RadioWidget.class), null, null); } catch (Throwable ignored) { }
            if (dlg != null) dlg.dismiss();
            if (!asked) android.widget.Toast.makeText(c, "Long-press the home screen, choose Widgets and drag out SignalDeck", android.widget.Toast.LENGTH_LONG).show();
        });
    }

    private TextView rogerValue;
    /** Roger beep: tap cycles Off / Beep / Two-tone / Morse K and plays the tone on the phone speaker. */
    private LinearLayout rogerRow(Context c) {
        LinearLayout row = new LinearLayout(c); row.setGravity(android.view.Gravity.CENTER_VERTICAL); row.setMinimumHeight(Theme.dp(c, 60));
        row.setPadding(Theme.dp(c, 14), Theme.dp(c, 8), Theme.dp(c, 14), Theme.dp(c, 8));
        LayoutParams il = new LayoutParams(Theme.dp(c, 38), Theme.dp(c, 38)); il.rightMargin = Theme.dp(c, 12);
        row.addView(Neo.iconTile(c, "volume", Neo.GREEN, 38), il);
        LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL);
        col.addView(Neo.label(c, "Roger beep", Neo.TEXT, 16, true));
        TextView sub = Neo.label(c, "A short tone when you release the talk key. Tap to change and hear it", Neo.MUTED, 13, false); sub.setPadding(0, Theme.dp(c, 2), 0, 0); col.addView(sub);
        row.addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        rogerValue = Neo.chip(c, com.macdmr.radio.RadioService.ROGER_NAMES[svc != null ? svc.rogerStyle() : 0], Neo.GREEN);
        row.addView(rogerValue);
        row.setOnClickListener(v -> {
            if (svc == null) return;
            int s = (svc.rogerStyle() + 1) % com.macdmr.radio.RadioService.ROGER_NAMES.length;
            svc.setRogerStyle(s); rogerValue.setText(com.macdmr.radio.RadioService.ROGER_NAMES[s]);
            com.macdmr.radio.RadioService.previewRoger(s);
        });
        return row;
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
                .setItems(new String[] { "Run all checks (one button)", "Generate device report", "Share last report", "Capture the PTT key (10 s)", "Radio probe (root)", "Open a GitHub issue with the facts filled in", "What is in it?" }, (dd, w) -> {
                    if (w == 0) offerChecks(false);
                    else if (w == 1) generateReport();
                    else if (w == 2) shareReport();
                    else if (w == 3) captureKeys();
                    else if (w == 4) probe();
                    else if (w == 5) com.macdmr.radio.DeviceReport.openIssue(c);
                    else new android.app.AlertDialog.Builder(c).setTitle("Device report").setMessage("For a phone that has no profile yet, or to help debug one: gathers the facts a profile needs (serial ports, radio-module nodes, the stock walkie-talkie app and its APK, vendor libraries, framework jars, services; with root also SELinux labels and the PTT key broadcasts), saves it under Download/DMR/DeviceReport and offers to share the zip to a GitHub issue. Nothing on the phone is changed.").setPositiveButton("OK", null).show();
                }).show();
    }

    /** The guided first run: one dialog, one button, one zip to send. */
    public void offerChecks(boolean firstLaunch) { checks(firstLaunch); }

    private void generateReport() {
        final Context c = getContext();
        final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Device report").setMessage("Starting…").setCancelable(false).create(); pd.show();
        new Thread(() -> {
            try { com.macdmr.radio.DeviceReport.generate(c, s -> post(() -> pd.setMessage(s + "…"))); post(() -> { pd.dismiss(); new android.app.AlertDialog.Builder(c).setTitle("Report ready").setMessage("Saved under Download/DMR/DeviceReport. If the phone has a side PTT key, run \"Capture the PTT key\" and, with root, the radio probe, then use Share last report, which explains what it contains.").setPositiveButton("OK", null).show(); }); }
            catch (Throwable t) { post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, "Report failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); }); }
        }).start();
    }

    private void checks(boolean firstLaunch) {
        final Context c = getContext(); if (svc == null) return;
        final com.macdmr.radio.DeviceProfile dp = svc.profile();
        final boolean canTrial = dp.supported && !svc.isReady();
        String msg = (firstLaunch ? (dp.supported ? "SignalDeck has a profile for this phone that has not been tested on it yet. " : "SignalDeck does not know this phone yet. ")
                + "One run of the checks tells us what we need to make it work. It takes about two minutes.\n\n" : "")
                + "What happens:\n• a device report (phone, ports, radio module, the stock walkie-talkie app; only reads)\n"
                + "• 10 s to press the side PTT key a few times\n"
                + "• with Magisk root, the radio probe (asks the module for its version on the serial ports; switches the module on if it does not answer"
                + (dp.supported ? "" : ", only on phones with a profile") + ")\n"
                + (canTrial ? "• optionally a 30-second trial: SignalDeck takes the radio (receive only, nothing is transmitted), records what the module and the audio do, then gives it back to " + dp.stockApp + "\n" : "")
                + (dp.supported && !dp.stockApp.isEmpty() ? "\n" + dp.stockApp + " is closed for the checks; open it again afterwards as usual.\n" : "")
                + "\nAt the end you get one zip to send us.";
        android.app.AlertDialog.Builder b = new android.app.AlertDialog.Builder(c).setTitle(firstLaunch ? "Help us support this phone" : "Run all checks").setMessage(msg)
                .setPositiveButton(canTrial ? "Checks + trial" : "Run checks", (dd, w) -> runChecks(canTrial))
                .setNegativeButton(firstLaunch ? "Later" : "Cancel", null);
        if (canTrial) b.setNeutralButton("Checks only", (dd, w) -> runChecks(false));
        b.show();
    }

    private void runChecks(final boolean trial) {
        final Context c = getContext(); if (svc == null) return;
        final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Checking this phone").setMessage("Starting…").setCancelable(false).create(); pd.show();
        final com.macdmr.radio.RadioService s = svc;
        new Thread(() -> {
            try {
                final java.io.File zip = com.macdmr.radio.FirstRunCheck.run(c, s, trial, t -> post(() -> pd.setMessage(t + "…")));
                final java.io.File dir = com.macdmr.radio.DeviceReport.newestDir();
                String rep = dir == null ? "" : com.macdmr.radio.DeviceReport.cat(new java.io.File(dir, "report.txt").getAbsolutePath());
                int k = rep.lastIndexOf("==== Summary ====");
                final String summary = k >= 0 ? rep.substring(k + 17).trim() : "";
                post(() -> {
                    pd.dismiss();
                    new android.app.AlertDialog.Builder(c).setTitle("Checks done")
                            .setMessage((summary.isEmpty() ? "" : summary + "\n\n") + "Everything is in one zip (" + zip.length() / 1024 + " kB). Tap Send to share it by e-mail, a messenger or a cloud drive, or open a GitHub issue and drag the zip in.\n\nThe folder is also on the phone: Download/DMR/DeviceReport/" + (dir != null ? dir.getName() : "") + " (with a computer: adb pull /sdcard/Download/DMR/DeviceReport).")
                            .setPositiveButton("Send", (dd, w) -> shareReport()).setNeutralButton("GitHub issue", (dd, w) -> com.macdmr.radio.DeviceReport.openIssue(c)).setNegativeButton("Close", null).show();
                });
            } catch (Throwable t) { post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, "Checks failed: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); }); }
        }, "first-run-check").start();
    }

    private void shareReport() {
        new android.app.AlertDialog.Builder(getContext()).setTitle("Share the device report")
                .setMessage("The report holds phone model and build facts, serial-port and radio-module node names, the walkie-talkie app's package details, library and framework file names, running radio processes, and (with root) SELinux labels and short radio-related log excerpts with message text removed and long numbers masked. After Run all checks it also holds SignalDeck's own log (packet, position, message and caller lines removed; callsigns and IDs masked) and, after the trial, a 5-second raw copy of what the radio received (rx_audio_raw.bin: whatever the channel carried). No accounts, contacts, messages, location or identifiers such as IMEI.\n\nThe copied stock walkie-talkie APK is the manufacturer's software: include it if you are comfortable posting it, or share without it (we can ask for it privately).")
                .setPositiveButton("Share all", (dd, w) -> shareZip(true)).setNeutralButton("Without the APK", (dd, w) -> shareZip(false)).setNegativeButton("Cancel", null).show();
    }

    private void captureKeys() {
        final Context c = getContext();
        final android.app.AlertDialog pd = new android.app.AlertDialog.Builder(c).setTitle("Press the PTT key now").setMessage("Press and release the phone's side PTT button a few times within the next 10 seconds. Everything the phone reports for it is recorded.").setCancelable(false).create(); pd.show();
        new Thread(() -> { final String r = com.macdmr.radio.DeviceReport.captureKeys(c, 10); final java.io.File dir = com.macdmr.radio.DeviceReport.append("PTT key capture", r); post(() -> { pd.dismiss(); android.widget.Toast.makeText(c, dir == null ? "Captured, but generate a report first so it can be saved" : "Saved to the report", android.widget.Toast.LENGTH_LONG).show(); }); }).start();
    }

    private void probe() {
        new android.app.AlertDialog.Builder(getContext()).setTitle("Radio probe").setMessage("Needs Magisk root. Reads the serial ports' SELinux labels, derives and applies the rules for this session, sends the module's version query on each port at several speeds, reads the power node and sniffs for a PCM stream. The stock walkie-talkie app should be closed. Also pulse the power node?")
                .setPositiveButton("Probe", (dd, w) -> runProbe(false)).setNeutralButton(svc != null && svc.profile().supported ? "Probe + power pulse" : null, (dd, w) -> runProbe(true)).setNegativeButton("Cancel", null).show();
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

    /** The map can switch coverage logging too: show the current state whenever this page comes back. */
    @Override protected void onVisibilityChanged(android.view.View changed, int visibility) {
        super.onVisibilityChanged(changed, visibility);
        if (visibility == VISIBLE && svc != null && covSw != null) covSw.setChecked(svc.coverage().enabled());
        if (visibility == VISIBLE && autoWarn != null) checkAutoTrust();   // also after coming back from Android Auto's settings
    }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    // ---- Android Auto trust: the warning row shows only while Android Auto would hide the app ----
    private LinearLayout autoWarn; private View autoWarnDiv;
    @Override protected void onWindowVisibilityChanged(int visibility) {
        super.onWindowVisibilityChanged(visibility);
        if (visibility == VISIBLE && autoWarn != null && isShown()) checkAutoTrust();
    }
    private void checkAutoTrust() {
        if (!com.macdmr.radio.DeviceProfile.detect().verified) return;     // reads Android Auto's files with root: no Magisk prompt before the radio is set up
        final Context app = getContext().getApplicationContext();
        new Thread(() -> {
            com.macdmr.radio.car.AutoTrust.State st = com.macdmr.radio.car.AutoTrust.check(app);
            post(() -> {
                boolean hidden = st == com.macdmr.radio.car.AutoTrust.State.OFF || st == com.macdmr.radio.car.AutoTrust.State.LOCKED;
                if (autoWarn != null) { autoWarn.setVisibility(hidden ? VISIBLE : GONE); autoWarnDiv.setVisibility(hidden ? VISIBLE : GONE); }
                if (st == com.macdmr.radio.car.AutoTrust.State.OK) com.macdmr.radio.car.AutoTrust.clearNotice(app);
            });
        }, "autotrust").start();
    }
    private void autoTrustSheet() {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout box = Neo.sheetBody(c, "Show the radio in the car");
        box.addView(Neo.sheetHint(c, "Android Auto only trusts apps installed from the Play Store. For SignalDeck it plays the sound and the steering-wheel buttons work, but the app is missing from the car's app list and tapping its card opens the app on the phone."));
        box.addView(Neo.sheetHint(c, com.macdmr.radio.car.AutoTrust.steps(com.macdmr.radio.car.AutoTrust.last())));
        TextView open = Neo.button(c, "Open Android Auto settings", "intercom", Neo.AMBER);
        TextView again = Neo.button(c, "Check again", "update", Neo.CYAN);
        LayoutParams bl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); bl.setMargins(0, (int) (10 * d), 0, 0);
        box.addView(open, bl); box.addView(again, new LayoutParams(bl));
        final android.app.Dialog dlg = Neo.showSheet(c, box);
        open.setOnClickListener(v -> { try { c.startActivity(com.macdmr.radio.car.AutoTrust.settingsIntent(c)); } catch (Throwable t) { android.widget.Toast.makeText(c, "Could not open Android Auto: " + t.getMessage(), android.widget.Toast.LENGTH_LONG).show(); } });
        again.setOnClickListener(v -> { dlg.dismiss(); checkAutoTrust(); });
    }

    private void refresh() {
        if (svc == null) return;
        Context c = getContext(); float d = Theme.dp(c);
        Neo.headerSubtitle(header).setText(svc.profile().name.toUpperCase(java.util.Locale.US));
        profileText.setText(svc.profile().controlPort + " · " + svc.profile().baud + " · " + (svc.profile().audio == com.macdmr.radio.DeviceProfile.Audio.TINY_SERVICE ? "vendor audio" : "UART PCM"));
        String l = svc.link();
        if (!svc.profile().verified && svc.profile().supported) profileText.append(" · untested");
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
        takeOver.setVisibility(unsupported ? GONE : VISIBLE); handBack.setVisibility(unsupported ? GONE : VISIBLE); reportNow.setVisibility(unsupported || !svc.profile().verified ? VISIBLE : GONE);
        takeOver.setAlpha(ready ? 0.55f : 1f); handBack.setAlpha(ready ? 1f : 0.55f);
        idText.setText("ID " + svc.localId());
        if (rogerValue != null) rogerValue.setText(com.macdmr.radio.RadioService.ROGER_NAMES[svc.rogerStyle()]);
        ownAtBoot.setChecked(svc.ownAtBoot()); voiceSw.setChecked(svc.voiceOn()); hwPttSw.setChecked(svc.hwPtt()); scanSqSw.setChecked(svc.scanSoftSq());
        volPttSw.setChecked(c.getSharedPreferences("radio", Context.MODE_PRIVATE).getBoolean("volPtt", false));
        styleSw.setChecked(IntercomView.newLook(c)); animSw.setChecked(IntercomView.animatedPanel(c)); covSw.setChecked(svc.coverage().enabled()); carMicSw.setChecked(svc.carMic()); carCovSw.setChecked(svc.coverageInCar()); wheelSw.setChecked(svc.wheelTalk()); nextTalkValue.setText(com.macdmr.radio.RadioService.NEXT_TALK_NAMES[svc.nextTalkMode()]);
        wheelMicValue.setText(com.macdmr.radio.RadioService.WHEEL_MIC_NAMES[Math.max(0, Math.min(1, svc.wheelMic()))]); voxValue.setText(com.macdmr.radio.RadioService.VOX_NAMES[Math.max(0, Math.min(3, svc.voxStop()))]); carScreenSw.setChecked(svc.carControlsScreen());
        ((TextView) radioIdTile.findViewWithTag("sub")).setText(svc.radioId().status());
        updateWeb();
    }

    private static final String WEB_ICON = "M12,3 A9,9 0 1,0 12.01,3 Z M3,12 H21 M12,3 C8.5,7 8.5,17 12,21 M12,3 C15.5,7 15.5,17 12,21";
    private Neo.NeonSwitch webSw, webTxSw; private TextView webSub;
    /** The web card: address and PIN while the server runs. */
    private void updateWeb() {
        if (svc == null || svc.web() == null || webSw == null) return;
        com.macdmr.radio.web.WebHost w = svc.web();
        webSw.setChecked(w.enabled()); webTxSw.setChecked(w.allowTx());
        if (!w.enabled()) { webSub.setText("Use SignalDeck from a browser on the same Wi-Fi"); return; }
        if (!w.running()) { webSub.setText("Not running" + (w.lastError() != null ? ": " + w.lastError() : "")); return; }
        java.util.List<String> u = w.urls();
        webSub.setText((u.isEmpty() ? "Connect to Wi-Fi to get an address" : "Open " + android.text.TextUtils.join("  or  ", u)) + "\nPIN  " + w.pin()
                + (w.tlsRunning() && !u.isEmpty() ? "\nTo talk with a computer's microphone: " + w.secureUrls().get(0) + " (accept the certificate warning once; fingerprint " + com.macdmr.radio.web.WebTls.fingerprint().substring(0, 11) + "…)" : "")
                + (w.clients() > 0 ? "\n" + w.clients() + " browser" + (w.clients() == 1 ? "" : "s") + " connected" : ""));
    }

    @Override public void onLink(String state) { refresh(); }
    @Override public void onChannel(ChannelStore.Channel ch) { } @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { } @Override public void onLog(String s) { }
    @Override public void onLocation(String t) { } @Override public void onSms(int f, int ty, String te) { } @Override public void onSmsResult(boolean ok) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f2, boolean g, String z) { }
    @Override public void onCaption(boolean en, String live, String sentence) { }
}
