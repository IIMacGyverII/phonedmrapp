package com.macdmr.radio;

import android.Manifest;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.ui.DiagnosticsView;
import com.macdmr.radio.ui.IntercomView;
import com.macdmr.radio.ui.Theme;

/** App shell: bottom navigation (Intercom · Channels · Contacts · Messages · Settings) over one content frame. */
public class MainActivity extends AppCompatActivity {
    private FrameLayout content;
    private IntercomView intercom;
    private DiagnosticsView diagnostics;
    private com.macdmr.radio.ui.ChannelsView channels;
    private com.macdmr.radio.ui.ContactsView contacts;
    private com.macdmr.radio.ui.DeviceView device;
    private View overlay;
    private com.macdmr.radio.ui.MessagesView messages;
    private View editor;
    private RadioService svc;
    private final TextView[] tabs = new TextView[5];
    private final android.widget.ImageView[] tabIcon = new android.widget.ImageView[5];
    private final View[] tabCell = new View[5];
    private final View[] tabInd = new View[5];
    private final String[] tabIcons = { "intercom", "channels", "contacts", "messages", "device" };
    private final String[] tabNames = { "Intercom", "Channels", "Contacts", "Messages", "Device" };
    private int tab = 0;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private final Runnable rssiTick = new Runnable() { @Override public void run() { if (svc != null && svc.isReady() && tab == 0) svc.pollRssi(); ui.postDelayed(this, 2000); } };

    private final ServiceConnection conn = new ServiceConnection() {
        @Override public void onServiceConnected(ComponentName n, IBinder b) {
            svc = ((RadioService.LocalBinder) b).get();
            intercom.attach(svc); diagnostics.attach(svc); channels.attach(svc); contacts.attach(svc); messages.attach(svc); device.attach(svc);
            if (!svc.isReady() && svc.profile().verified) svc.bringUp();          // an untested profile waits for Device → Take over
            ui.post(rssiTick); ui.removeCallbacks(modeTick); ui.post(modeTick);
            applyPendingLocation();
            ui.postDelayed(MainActivity.this::announceCoverage, 3000);
            if (!svc.profile().verified && !getSharedPreferences("radio", MODE_PRIVATE).getBoolean("unsupportedShown", false)) { getSharedPreferences("radio", MODE_PRIVATE).edit().putBoolean("unsupportedShown", true).apply(); show(4); device.offerChecks(true); }
        }
        @Override public void onServiceDisconnected(ComponentName n) { svc = null; }
    };

    @Override protected void onCreate(Bundle b) {
        super.onCreate(b);
        ProfileRegistry.init(this);                                 // before any page asks which phone this is
        LinearLayout root = new LinearLayout(this); root.setOrientation(LinearLayout.VERTICAL);
        getWindow().setBackgroundDrawable(com.macdmr.radio.ui.Neo.page(this));   // the one full-screen background layer; tab pages draw none of their own (overdraw cost ~40 ms of GPU per frame)
        content = new FrameLayout(this);
        root.addView(content, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f));
        LinearLayout nav = new LinearLayout(this); nav.setBackgroundColor(com.macdmr.radio.ui.Neo.BAR);
        View navLine = new View(this); navLine.setBackgroundColor(com.macdmr.radio.ui.Neo.alpha(com.macdmr.radio.ui.Neo.CYAN, 0x29));
        root.addView(navLine, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, Math.max(1, Theme.dp(this, 1))));
        for (int i = 0; i < 5; i++) {
            final int idx = i;
            LinearLayout tab = new LinearLayout(this); tab.setOrientation(LinearLayout.VERTICAL); tab.setGravity(Gravity.CENTER);
            tab.setPadding(0, Theme.dp(this, 8), 0, Theme.dp(this, 6)); tab.setContentDescription(tabNames[i]);
            android.widget.ImageView e = new android.widget.ImageView(this);
            TextView t = com.macdmr.radio.ui.Neo.text(this, tabNames[i].toUpperCase(java.util.Locale.US), 0xFF71879D, 11.5f, com.macdmr.radio.ui.Neo.ui(this)); t.setGravity(Gravity.CENTER); t.setLetterSpacing(0.08f); t.setSingleLine(true);
            LinearLayout.LayoutParams el = new LinearLayout.LayoutParams(Theme.dp(this, 24), Theme.dp(this, 24)); el.bottomMargin = Theme.dp(this, 4);
            tab.addView(e, el); tab.addView(t);
            View ind = new View(this); LinearLayout.LayoutParams il = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, Theme.dp(this, 3)); il.setMargins(Theme.dp(this, 14), Theme.dp(this, 6), Theme.dp(this, 14), 0);
            tab.addView(ind, il);
            tab.setOnClickListener(v -> show(idx));
            tabs[i] = t; tabIcon[i] = e; tabInd[i] = ind; tabCell[i] = tab;
            nav.addView(tab, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        }
        modeBar = buildModeBar();
        root.addView(modeBar, 1);                                  // under the page, over the tab bar: a running mode, tap to open its page
        root.addView(nav);
        setContentView(root);
        if (b == null) {                                          // only when the screen is created fresh (first start, or after it was closed); returning to the open app never replays it
            String ver; try { ver = "v" + getPackageManager().getPackageInfo(getPackageName(), 0).versionName; } catch (Throwable t) { ver = ""; }
            final com.macdmr.radio.ui.SplashView[] sp = new com.macdmr.radio.ui.SplashView[1];
            sp[0] = new com.macdmr.radio.ui.SplashView(this, ver, () -> { if (sp[0].getParent() != null) ((android.view.ViewGroup) sp[0].getParent()).removeView(sp[0]); });
            addContentView(sp[0], new android.view.ViewGroup.LayoutParams(android.view.ViewGroup.LayoutParams.MATCH_PARENT, android.view.ViewGroup.LayoutParams.MATCH_PARENT));
        }
        getWindow().setStatusBarColor(0xFF0A1420); getWindow().setNavigationBarColor(com.macdmr.radio.ui.Neo.BAR);

        intercom = new IntercomView(this);
        diagnostics = new DiagnosticsView(this);
        device = new com.macdmr.radio.ui.DeviceView(this);
        device.setHost(new com.macdmr.radio.ui.DeviceView.Host() {
            @Override public void openHelp() { showOverlay(new com.macdmr.radio.ui.HelpView(MainActivity.this, MainActivity.this::closeOverlay)); }
            @Override public void openDiagnostics() { showOverlay(diagnostics); }
            @Override public void intercomStyleChanged() { rebuildIntercom(); }
            @Override public void animatedPanelChanged(boolean on) { intercom.setAnimatedPanel(on); }
        });
        contacts = new com.macdmr.radio.ui.ContactsView(this);
        messages = new com.macdmr.radio.ui.MessagesView(this);
        contacts.setHost(ct -> { show(3); messages.openThread(ct); });
        channels = new com.macdmr.radio.ui.ChannelsView(this);
        channels.setHost((ch, isNew) -> {
            final ChannelStore.Channel target = isNew ? new ChannelStore.Channel() : ch;
            if (isNew && svc != null && svc.current() != null) { target.type = svc.current().type; target.rxFreq = svc.current().rxFreq; target.txFreq = svc.current().txFreq; }
            editor = new com.macdmr.radio.ui.ChannelEditorView(this, target, isNew, (c2, saved) -> {
                if (saved && svc != null) svc.saveChannel(c2, isNew);
                content.removeView(editor); editor = null; channels.reload();
            });
            content.addView(editor, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        });
        show(0);
        takeSharedLocation(getIntent());

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED)
            ActivityCompat.requestPermissions(this, android.os.Build.VERSION.SDK_INT >= 33 ? new String[] { Manifest.permission.RECORD_AUDIO, Manifest.permission.POST_NOTIFICATIONS, Manifest.permission.ACCESS_FINE_LOCATION, "android.permission.READ_MEDIA_AUDIO" } : new String[] { Manifest.permission.RECORD_AUDIO, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.READ_EXTERNAL_STORAGE }, 1);
        Intent si = new Intent(this, RadioService.class);
        startForegroundService(si);
        bindService(si, conn, Context.BIND_AUTO_CREATE);
    }

    /** The bound radio service (null until connected). */
    public RadioService service() { return svc; }

    /** One-time card for the coverage maps feature (shown once, on the intercom, when the radio is up). */
    private void announceCoverage() {
        android.content.SharedPreferences p = getSharedPreferences("coverage", MODE_PRIVATE);
        if (svc == null || isFinishing() || p.getBoolean("announced", false) || p.getBoolean("introShown", false)) return;
        p.edit().putBoolean("announced", true).apply();
        android.content.Context c = this; float d = com.macdmr.radio.ui.Theme.dp(c);
        android.widget.LinearLayout box = com.macdmr.radio.ui.Neo.sheetBody(c, "Coverage maps");
        box.addView(com.macdmr.radio.ui.Neo.label(c, "NEW FEATURE", com.macdmr.radio.ui.Neo.VIOLET, 12, true));
        box.addView(com.macdmr.radio.ui.Neo.sheetHint(c, "See where each of your repeaters reaches you, and where you can key it up. Turn on coverage logging and the app measures as you drive or walk, then draws it on the map. Export to Google Earth any time."));
        android.widget.TextView open = com.macdmr.radio.ui.Neo.button(c, "Open the map", "map", com.macdmr.radio.ui.Neo.VIOLET);
        android.widget.TextView later = com.macdmr.radio.ui.Neo.button(c, "Later", "close", com.macdmr.radio.ui.Neo.CYAN);
        android.widget.LinearLayout row = new android.widget.LinearLayout(c); row.setBaselineAligned(false);
        android.widget.LinearLayout.LayoutParams l1 = new android.widget.LinearLayout.LayoutParams(0, android.view.ViewGroup.LayoutParams.WRAP_CONTENT, 1.4f); l1.setMargins(0, (int) (14 * d), (int) (4 * d), 0);
        android.widget.LinearLayout.LayoutParams l2 = new android.widget.LinearLayout.LayoutParams(0, android.view.ViewGroup.LayoutParams.WRAP_CONTENT, 1f); l2.setMargins((int) (4 * d), (int) (14 * d), 0, 0);
        row.addView(open, l1); row.addView(later, l2); box.addView(row);
        final android.app.Dialog dlg = com.macdmr.radio.ui.Neo.showSheet(c, box);
        open.setOnClickListener(v -> { if (dlg != null) dlg.dismiss(); com.macdmr.radio.ui.MapDialog.show(c, svc); });
        later.setOnClickListener(v -> { if (dlg != null) dlg.dismiss(); });
    }

    public static final String EXTRA_LAT = "com.macdmr.radio.lat", EXTRA_LON = "com.macdmr.radio.lon";
    private double[] pendingLocation;

    @Override protected void onNewIntent(Intent i) { super.onNewIntent(i); setIntent(i); takeSharedLocation(i); }

    /** A place shared from a maps app (ShareLocationActivity): into the open channel editor, or onto a channel you pick. */
    private void takeSharedLocation(Intent i) {
        if (i == null || !i.hasExtra(EXTRA_LAT)) return;
        pendingLocation = new double[] { i.getDoubleExtra(EXTRA_LAT, 0), i.getDoubleExtra(EXTRA_LON, 0) };
        i.removeExtra(EXTRA_LAT); i.removeExtra(EXTRA_LON);
        applyPendingLocation();
    }
    private void applyPendingLocation() {
        if (pendingLocation == null) return;
        final double[] p = pendingLocation;
        if (editor instanceof com.macdmr.radio.ui.ChannelEditorView) { pendingLocation = null; ((com.macdmr.radio.ui.ChannelEditorView) editor).setLocation(p[0], p[1]); return; }
        if (svc == null) return;   // applied once the service is connected
        pendingLocation = null;
        final java.util.List<ChannelStore.Channel> all = svc.store().all();
        String[] names = new String[all.size()]; for (int k = 0; k < names.length; k++) names[k] = all.get(k).number + "  " + all.get(k).name;
        new android.app.AlertDialog.Builder(this).setTitle(String.format(java.util.Locale.US, "Set %.5f, %.5f as the location of", p[0], p[1]))
                .setItems(names, (d, w) -> { ChannelStore.Channel ch = all.get(w); ch.lat = p[0]; ch.lon = p[1]; svc.saveChannel(ch, false); android.widget.Toast.makeText(this, ch.name + ": location set", android.widget.Toast.LENGTH_LONG).show(); })
                .setNegativeButton("Cancel", null).show();
    }

    private void show(int idx) {
        tab = idx;
        content.removeAllViews(); overlay = null; editor = null;      // a tab tap leaves any page on top of the old tab
        View v;
        switch (idx) {
            case 0: v = intercom; break;
            case 1: v = channels; channels.reload(); break;
            case 2: v = contacts; contacts.reload(); break;
            case 3: v = messages; messages.reload(); break;
            case 4: v = device; break;
            default: v = placeholder(tabNames[idx]);
        }
        content.addView(v, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        for (int i = 0; i < 5; i++) {
            boolean a = i == idx;
            int col = a ? com.macdmr.radio.ui.Neo.CYAN : 0xFF71879D;
            tabs[i].setTextColor(col);
            if (!(tabIcon[i].getDrawable() instanceof com.macdmr.radio.ui.Neo.IconDrawable)) tabIcon[i].setImageDrawable(new com.macdmr.radio.ui.Neo.IconDrawable(tabIcons[i], col));
            else ((com.macdmr.radio.ui.Neo.IconDrawable) tabIcon[i].getDrawable()).setColor(col);
            tabInd[i].setBackground(a ? com.macdmr.radio.ui.Theme.rounded(this, com.macdmr.radio.ui.Neo.CYAN, 0, 0, 2) : null);
            tabCell[i].setBackground(a ? new android.graphics.drawable.GradientDrawable(android.graphics.drawable.GradientDrawable.Orientation.BOTTOM_TOP, new int[] { 0x1C19D3FF, 0x0019D3FF }) : null);
        }
    }

    /** The intercom look was switched (Device setting, or the intercom's own menu): build the other page and re-attach it. */
    public void rebuildIntercom() {
        if (svc != null) intercom.detach();
        intercom = new IntercomView(this);
        if (svc != null) intercom.attach(svc);
        if (tab == 0) show(0);
        if (svc != null) svc.pollRssi();
    }

    private View placeholder(String name) {
        TextView t = Theme.label(this, name + "\n\ncoming next", 0xFF8A7FB0, 18, false); t.setGravity(Gravity.CENTER); return t;
    }

    // ---- modes that take the radio over (APRS monitor, KISS, SSTV, parrot): their own full-screen page ----
    private LinearLayout modeBar; private TextView modeBarText;
    private boolean modeScreenOffered;
    private final Runnable modeTick = new Runnable() { @Override public void run() { updateModeBar(); ui.postDelayed(this, 1000); } };
    private com.macdmr.radio.ui.ModeScreen modeScreenFor() {
        RadioService s = svc; if (s == null || s.packet() == null) return null;
        Runnable close = this::closeOverlay;
        if (s.packet().sstvRx() || s.satMode() == com.macdmr.radio.ham.Satellites.SSTV) return new com.macdmr.radio.ui.SstvScreen(this, s, close);
        if (s.satMode() == com.macdmr.radio.ham.Satellites.APRS) return new com.macdmr.radio.ui.AprsScreen(this, s, close);
        if (s.packet().monitoring() || s.packet().kiss().isActive()) return new com.macdmr.radio.ui.AprsScreen(this, s, close);
        if (s.parrot().enabled()) return new com.macdmr.radio.ui.ParrotScreen(this, s, close);
        return null;
    }
    /** Show the running mode's page; false when no mode has one. */
    public boolean openModeScreen() {
        com.macdmr.radio.ui.ModeScreen m = modeScreenFor();
        if (m == null) return false;
        if (tab != 0) show(0);
        showOverlay(m); updateModeBar();
        return true;
    }
    private String modeLabel() {
        RadioService s = svc; if (s == null || s.packet() == null) return null;
        com.macdmr.radio.PacketEngine pe = s.packet();
        RadioService.SatState ss = s.satState();
        if (ss != null && ss.mode != com.macdmr.radio.ham.Satellites.VOICE) {
            String when = ss.waiting ? "next pass " + new java.text.SimpleDateFormat("HH:mm", java.util.Locale.US).format(new java.util.Date(ss.aos)) : "pass in progress";
            return (ss.mode == com.macdmr.radio.ham.Satellites.SSTV ? "\uD83D\uDCFA  ISS SSTV" : "\uD83D\uDCE1  ISS APRS") + "  \u00B7  " + when;
        }
        if (pe.sstvRx()) return "\uD83D\uDCFA  SSTV receive";
        if (pe.monitoring()) return "\uD83D\uDCE1  APRS monitoring  \u00B7  " + String.format(java.util.Locale.US, "%.3f", s.aprsMonitorHz() / 1e6);
        if (pe.kiss().isActive()) return "📡  KISS TNC";
        if (s.parrot().enabled()) return "🦜  Parrot";
        return null;
    }
    private LinearLayout buildModeBar() {
        LinearLayout b = new LinearLayout(this); b.setGravity(Gravity.CENTER_VERTICAL); b.setVisibility(View.GONE);
        b.setBackgroundColor(com.macdmr.radio.ui.Neo.alpha(com.macdmr.radio.ui.Neo.GREEN, 0x26));
        b.setPadding(Theme.dp(this, 16), Theme.dp(this, 9), Theme.dp(this, 12), Theme.dp(this, 9));
        modeBarText = com.macdmr.radio.ui.Neo.text(this, "", com.macdmr.radio.ui.Neo.GREEN_LIGHT, 15, com.macdmr.radio.ui.Neo.uiSemi(this)); modeBarText.setSingleLine(true);
        b.addView(modeBarText, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        TextView open = com.macdmr.radio.ui.Neo.text(this, "OPEN  ›", com.macdmr.radio.ui.Neo.GREEN, 14, com.macdmr.radio.ui.Neo.ui(this)); open.setLetterSpacing(0.1f);
        b.addView(open);
        b.setOnClickListener(v -> openModeScreen());
        b.setContentDescription("Open the running mode's page");
        return b;
    }
    private void updateModeBar() {
        if (modeBar == null) return;
        String l = modeLabel();
        boolean show = l != null && !(overlay instanceof com.macdmr.radio.ui.ModeScreen) && editor == null;
        int vis = show ? View.VISIBLE : View.GONE; if (modeBar.getVisibility() != vis) modeBar.setVisibility(vis);
        if (show && !l.contentEquals(modeBarText.getText())) modeBarText.setText(l);
        if (l != null && !modeScreenOffered) { modeScreenOffered = true; if (overlay == null && editor == null && tab == 0) openModeScreen(); }   // opening the app while a mode runs: its page first
        if (l == null) modeScreenOffered = true;
    }

    private void showOverlay(View v) { closeOverlay(); overlay = v; content.addView(v, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)); }
    private void closeOverlay() { if (overlay != null) { content.removeView(overlay); overlay = null; } updateModeBar(); }

    // ---- image picker for views (SSTV send) ----
    private java.util.function.Consumer<android.net.Uri> imagePick;
    public void pickImage(java.util.function.Consumer<android.net.Uri> cb) {
        imagePick = cb;
        Intent i = new Intent(Intent.ACTION_OPEN_DOCUMENT).addCategory(Intent.CATEGORY_OPENABLE).setType("image/*");
        try { startActivityForResult(i, 77); } catch (Throwable t) { android.widget.Toast.makeText(this, "No picture app available", android.widget.Toast.LENGTH_LONG).show(); }
    }
    private java.util.function.Consumer<android.net.Uri> folderPick;
    /** Storage Access Framework folder picker (backups made by another app or install are invisible to the File API). */
    public void pickFolder(java.util.function.Consumer<android.net.Uri> cb) {
        folderPick = cb;
        Intent i = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
        try { startActivityForResult(i, 78); } catch (Throwable t) { android.widget.Toast.makeText(this, "No file picker available", android.widget.Toast.LENGTH_LONG).show(); }
    }
    @Override protected void onActivityResult(int req, int res, Intent data) {
        super.onActivityResult(req, res, data);
        if (req == 78 && folderPick != null) { java.util.function.Consumer<android.net.Uri> cb = folderPick; folderPick = null; if (res == RESULT_OK && data != null && data.getData() != null) cb.accept(data.getData()); return; }
        if (req == 77 && imagePick != null) { java.util.function.Consumer<android.net.Uri> cb = imagePick; imagePick = null; if (res == RESULT_OK && data != null && data.getData() != null) cb.accept(data.getData()); }
    }

    /** Volume-up as PTT (Device tab option) while the Intercom page is showing. */
    private boolean volPttDown;
    @Override public boolean dispatchKeyEvent(android.view.KeyEvent e) {
        java.util.function.Consumer<android.view.KeyEvent> cap = DeviceReport.keyCapture; if (cap != null) { cap.accept(e); return true; }
        if (e.getKeyCode() == android.view.KeyEvent.KEYCODE_VOLUME_UP && tab == 0 && svc != null && getSharedPreferences("radio", MODE_PRIVATE).getBoolean("volPtt", false)) {
            if (e.getAction() == android.view.KeyEvent.ACTION_DOWN) { if (e.getRepeatCount() == 0 && !volPttDown) { volPttDown = true; svc.ptt(true); } return true; }
            if (e.getAction() == android.view.KeyEvent.ACTION_UP) { if (volPttDown) { volPttDown = false; svc.ptt(false); } return true; }
        }
        return super.dispatchKeyEvent(e);
    }

    @Override public void onBackPressed() {
        if (overlay instanceof com.macdmr.radio.ui.HelpView && ((com.macdmr.radio.ui.HelpView) overlay).back()) return;
        if (overlay != null) { closeOverlay(); return; }
        if (editor != null) { content.removeView(editor); editor = null; return; }
        if (tab == 3 && messages.back()) return;
        if (tab != 0) { show(0); return; }
        super.onBackPressed();
    }

    @Override protected void onDestroy() {
        super.onDestroy();
        ui.removeCallbacks(rssiTick); ui.removeCallbacks(modeTick);
        if (svc != null) { intercom.detach(); diagnostics.detach(); }
        try { unbindService(conn); } catch (Throwable ignored) { }
    }
}
