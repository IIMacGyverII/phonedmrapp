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
            final String r = svc != null ? RootSetup.installBootModule(svc.profile()) : "service not ready";
            post(() -> new android.app.AlertDialog.Builder(getContext()).setTitle("Boot persistence").setMessage(r).setPositiveButton("OK", null).show());
        }).start());
        link.addView(Theme.label(c, "This app needs root (Magisk) to reach the radio's serial port. While it owns the radio the stock walkie-talkie app is paused and its icon is hidden; \"Hand back\" restores it. The Magisk module makes the required SELinux rules survive a reboot so the app can start on its own.", 0xFF8A98A6, 12, false));

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
        TextView reimport = pill(c, "Re-import from the stock app", Theme.VFO);
        data.addView(reimport, new LayoutParams(bb));
        reimport.setOnClickListener(v -> new android.app.AlertDialog.Builder(c).setTitle("Re-import?").setMessage("Replaces all channels, contacts, history and messages in this app with the stock app's current data.")
                .setPositiveButton("Import", (dd, w) -> new Thread(() -> { final String r = svc.reimportFromStock(); post(() -> android.widget.Toast.makeText(c, r, android.widget.Toast.LENGTH_LONG).show()); }).start()).setNegativeButton("Cancel", null).show());

        // --- help / diagnostics ---
        LinearLayout more = section(body, "❓ Help & tools");
        TextView help = pill(c, "Help & how-to", Theme.PKT), diag = pill(c, "Diagnostics log", Theme.MON);
        LinearLayout hrow = new LinearLayout(c); hrow.addView(help, new LayoutParams(bl)); hrow.addView(diag, new LayoutParams(bl)); more.addView(hrow);
        help.setOnClickListener(v -> { if (host != null) host.openHelp(); });
        diag.setOnClickListener(v -> { if (host != null) host.openDiagnostics(); });
        more.addView(Theme.label(c, "DMR Radio 0.1 — standalone edition of DMRModHooks. Same radio, no LSPosed.", 0xFF8A98A6, 12, false));
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
        linkText.setText("ready".equals(l) ? "✅ This app owns the radio" : "no root".equals(l) ? "🔒 Root not granted (Magisk → Superuser)" : "stopped".equals(l) ? "⏸ Stock app owns the radio" : "⏳ " + l);
        idText.setText("ID " + svc.localId());
    }

    @Override public void onLink(String state) { refresh(); }
    @Override public void onChannel(ChannelStore.Channel ch) { } @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { } @Override public void onLog(String s) { }
    @Override public void onLocation(String t) { } @Override public void onSms(int f, int ty, String te) { } @Override public void onSmsResult(boolean ok) { }
}
