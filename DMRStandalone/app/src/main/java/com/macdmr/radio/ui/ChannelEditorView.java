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

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Channel editor with the OEM's field set (name, type, frequencies in MHz, position, power, band, relay; colour
 * code, mode, slot, contact type, call number, RX group list, encryption, interrupt; squelch and tones), grouped
 * into sections in the new look. Every field has an info button with what it does on this radio. Enum rows cycle
 * on tap; text rows edit in place.
 */
public class ChannelEditorView extends LinearLayout {
    public interface Done { void onDone(ChannelStore.Channel ch, boolean saved); }

    private final ChannelStore.Channel ch;
    private final boolean isNew;
    private final Done done;
    private final LinearLayout form;
    private EditText name, tx, rx, call, key, groups;
    private EditText lat, lon;
    private TextView txCodeV, rxCodeV;
    private LinearLayout digitalGroup, analogGroup;

    private static final String[] TONE_TYPES = { "None", "CTCSS", "DCS" };

    // ---- field help (what each setting does on this radio) ----
    private static final String H_NAME = "Shown on the intercom, in the channel list and in voice announcements.";
    private static final String H_TYPE = "Digital (DMR) channels carry voice and text as data and need a colour code, a time slot and a call target. Analog channels are classic FM. Switching shows the settings that apply.";
    private static final String H_TX = "The frequency you transmit on, in MHz. On a simplex channel it is the same as the receive frequency; on a repeater channel it is the repeater's input (for example +5 MHz on UHF GMRS, or ±0.6 MHz on 2 m). This radio covers 136–174 and 400–480 MHz.";
    private static final String H_RX = "The frequency you listen on, in MHz. On a repeater channel it is the repeater's output.";
    private static final String H_POS = "Optional position of the station or repeater this channel reaches. With it the intercom shows the place name and its distance and bearing from you. Use my position fills in the phone's last known location.";
    private static final String H_POWER = "Transmit power. High reaches further and uses more battery; Low is enough for nearby radios. Some services limit power (FRS, for example).";
    private static final String H_BAND = "Channel width: Wide (25 kHz) or Narrow (12.5 kHz). Use what the other radios or the repeater use. On VHF (below 300 MHz) this radio is always set to Wide: Narrow makes its receiver deaf there.";
    private static final String H_RELAY = "The radio's relay-disconnection setting. Normal (recommended): the radio stays connected to the repeater and transmits normally. Disconnect: the radio waits for repeater confirmation and may not transmit at all; use it only if your network asks for it.";
    private static final String H_CC = "DMR's equivalent of a squelch tone, 0 to 15. Your radio and the repeater (or the other radios on a simplex channel) must use the same colour code, or you will not hear each other.";
    private static final String H_MODE = "Direct: radio to radio (simplex). Double slot: through a DMR repeater, which carries two time slots at once. Use Double slot for repeater channels.";
    private static final String H_SLOT = "A DMR repeater carries two separate conversations, time slot 1 and 2. Use the slot your talkgroup is on (the repeater's listing says). On a simplex channel every radio must use the same slot, usually TS1.";
    private static final String H_CTYPE = "Who you call: Private (one DMR ID), Group (a talkgroup) or All (every radio). On this radio a channel set to All reports callers as ID 16777215 and does not pass received audio, so use Group for normal talkgroup traffic.";
    private static final String H_CALL = "The DMR ID (private call) or talkgroup number (group call) you transmit to. For a group call it is added to the RX group list when you save, because the radio only passes group calls whose talkgroup is in that list.";
    private static final String H_GROUPS = "Talkgroups you want to hear on this channel, separated by commas, up to 32. The radio passes a group call only if its talkgroup is in this list. Private calls to your own DMR ID always pass, and MON on the intercom passes every call the radio can decode. Talkgroup lists below inserts a saved list (the module's lists come over from the stock app) or saves this one under a name.";
    private static final String H_ENC = "The radio's own DMR privacy scrambling with an 8-character key. Only radios using the same scheme and the same key hear you; most other DMR radios cannot. Encryption is not allowed on amateur frequencies.";
    private static final String H_KEY = "Exactly 8 characters, the same on every radio in the group. Used only when Encrypt is Enabled.";
    private static final String H_INT = "DMR transmit interrupt. ON allows a call in progress to be interrupted (for example by the radio you are calling) on radios that support it; when it is refused the radio reports that the called device does not allow interruption. OFF is the stock setting.";
    private static final String H_SQ = "The radio's own squelch, used when Soft SQ is off for this channel. 0 keeps it fully open: you hear static and the radio reports a reception all the time. 1 to 9 close it; on this radio they behave as one threshold, about −90 dBm.";
    private static final String H_SOFTSQ = "Soft SQ holds the radio's squelch open and lets the app decide what you hear: the channel's CTCSS tone when it has one, otherwise a noise squelch that tells speech from static. It catches weaker stations than the radio's own squelch. The SOFT SQ key on the intercom switches it too.";
    private static final String H_SOFTSQ_LVL = "How strict Soft SQ is, from 1 (lenient: opens on weaker, noisier signals) to 9 (strict: only clean signals). Same as the slider on the intercom.";
    private static final String H_MAPS = "Open Maps shows this position (or yours) in your maps app. Find the place there and use Share \u2192 DMR Radio, or copy its coordinates or link and come back to tap Paste. Paste reads coordinates, geo: links and Google, Apple or OpenStreetMap links from the clipboard, following short share links.";
    private static final String H_TXT = "A sub-audible tone sent with your transmission: CTCSS (a low tone, 62.5 to 254.1 Hz) or DCS (a digital code). Repeaters and radios that use tone squelch only open for the right one; a repeater's listing gives its access tone.";
    private static final String H_TXC = "The CTCSS frequency or DCS code to send. Tap to pick from the list.";
    private static final String H_RXT = "Only signals carrying this tone open the squelch, so other users on the frequency stay quiet. With Soft SQ on, the app checks the CTCSS tone itself; DCS is checked by the radio.";
    private static final String H_RXC = "The CTCSS frequency or DCS code to listen for. Tap to pick from the list.";

    public ChannelEditorView(Context c, ChannelStore.Channel channel, boolean isNew, Done done) {
        super(c);
        this.ch = channel; this.isNew = isNew; this.done = done;
        setOrientation(VERTICAL); setBackground(Neo.page(c));   // overlay: covers the channel list
        setClickable(true);
        float d = Theme.dp(c);

        LinearLayout bar = Neo.header(c, isNew ? "New channel" : "Edit channel", isNew ? "Fill in and save" : "Channel " + ch.number);
        ImageView back = Neo.iconButton(c, "left", Neo.CYAN, "Back without saving"); back.setOnClickListener(v -> done.onDone(ch, false));
        LayoutParams bl = new LayoutParams((int) (44 * d), (int) (44 * d)); bl.rightMargin = (int) (12 * d);
        bar.addView(back, 0, bl);
        TextView save = Neo.button(c, "Save", "check", Neo.GREEN); save.setMinHeight((int) (44 * d));
        save.setOnClickListener(v -> { if (apply()) done.onDone(ch, true); });
        LayoutParams sl = new LayoutParams(LayoutParams.WRAP_CONTENT, (int) (44 * d)); sl.leftMargin = (int) (8 * d);
        ((LinearLayout) bar.findViewWithTag("actions")).addView(save, sl);
        addView(bar);

        ScrollView sv = new ScrollView(c); sv.setVerticalScrollBarEnabled(false);
        form = new LinearLayout(c); form.setOrientation(VERTICAL); form.setPadding((int) (16 * d), (int) (4 * d), (int) (16 * d), (int) (28 * d));
        sv.addView(form);
        addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
        build();
    }

    private void build() {
        Context c = getContext(); float d = Theme.dp(c);
        section(form, "Channel");
        name = textInto(form, "Channel name", H_NAME, ch.name, InputType.TYPE_CLASS_TEXT);
        choiceInto(form, "Channel type", H_TYPE, new String[] { "Digital", "Analog" }, ch.type, v -> { ch.type = v; refreshGroups(); });
        tx = textInto(form, "Send frequency (MHz)", H_TX, ch.txFreq > 0 ? String.format(Locale.US, "%.5f", ch.txFreq / 1e6) : "", InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        rx = textInto(form, "Receive frequency (MHz)", H_RX, ch.rxFreq > 0 ? String.format(Locale.US, "%.5f", ch.rxFreq / 1e6) : "", InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);

        section(form, "Radio");
        choiceInto(form, "Power", H_POWER, new String[] { "Low power", "High power" }, ch.power, v -> ch.power = v);
        choiceInto(form, "Relay (repeater)", H_RELAY, new String[] { "Disconnect", "Normal" }, ch.relay == 1 ? 0 : 1, v -> ch.relay = v == 0 ? 1 : 2);

        digitalGroup = new LinearLayout(c); digitalGroup.setOrientation(VERTICAL); form.addView(digitalGroup);
        section(digitalGroup, "DMR");
        choiceInto(digitalGroup, "Color code", H_CC, names(0, 15), ch.cc, v -> ch.cc = v);
        choiceInto(digitalGroup, "Mode", H_MODE, new String[] { "Direct", "Double slot" }, ch.mode == 4 ? 1 : 0, v -> ch.mode = v == 1 ? 4 : 0);
        choiceInto(digitalGroup, "Time slot", H_SLOT, new String[] { "TS1", "TS2" }, ch.inSlot, v -> { ch.inSlot = v; ch.outSlot = v; });
        choiceInto(digitalGroup, "Contact type", H_CTYPE, new String[] { "Private", "Group", "All" }, ch.contactType, v -> ch.contactType = v);
        call = textInto(digitalGroup, "Call number (DMR ID / talkgroup)", H_CALL, ch.txContact > 0 ? String.valueOf(ch.txContact) : "", InputType.TYPE_CLASS_NUMBER);
        groups = textInto(digitalGroup, "RX group list (talkgroups, comma separated, up to 32)", H_GROUPS, join(ch.groups), InputType.TYPE_CLASS_TEXT);
        TextView lists = Neo.button(c, "Talkgroup lists\u2026", "channels", Neo.VIOLET); lists.setTextSize(14);
        LayoutParams tll = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); tll.bottomMargin = (int) (6 * Theme.dp(c));
        digitalGroup.addView(lists, tll);
        lists.setOnClickListener(v -> tgListsMenu());
        choiceInto(digitalGroup, "Encrypt", H_ENC, new String[] { "Disabled", "Enabled" }, ch.encryptSw == 1 ? 1 : 0, v -> ch.encryptSw = v == 1 ? 1 : 2);
        key = textInto(digitalGroup, "Encrypt key (8 characters)", H_KEY, ch.encryptKey == null ? "" : ch.encryptKey, InputType.TYPE_CLASS_TEXT);
        choiceInto(digitalGroup, "Interrupt transmission", H_INT, new String[] { "OFF", "ON" }, ch.interrupt == 1 ? 1 : 0, v -> ch.interrupt = v == 1 ? 1 : 2);

        analogGroup = new LinearLayout(c); analogGroup.setOrientation(VERTICAL); form.addView(analogGroup);
        section(analogGroup, "Analog");
        choiceInto(analogGroup, "Band", H_BAND, new String[] { "Narrow band", "Wide band" }, ch.band == 0 ? 0 : 1, v -> ch.band = v);
        choiceInto(analogGroup, "Soft SQ", H_SOFTSQ, new String[] { "Off", "On" }, ch.softSq ? 1 : 0, v -> ch.softSq = v == 1);
        choiceInto(analogGroup, "Soft SQ level", H_SOFTSQ_LVL, names(1, 9), Math.max(1, Math.min(9, ch.softSqLevel)) - 1, v -> ch.softSqLevel = v + 1);
        choiceInto(analogGroup, "Squelch level", H_SQ, names(0, 9), ch.sq, v -> ch.sq = v);
        choiceInto(analogGroup, "TX tone type", H_TXT, TONE_TYPES, ch.txType, v -> { ch.txType = v; ch.txSubCode = 0; txCodeV.setText(toneName(ch.txType, ch.txSubCode)); });
        txCodeV = choiceInto(analogGroup, "TX tone", H_TXC, null, 0, null);
        txCodeV.setOnClickListener(v -> pickTone(true)); ((View) txCodeV.getParent()).setOnClickListener(v -> pickTone(true));
        choiceInto(analogGroup, "RX tone type", H_RXT, TONE_TYPES, ch.rxType, v -> { ch.rxType = v; ch.rxSubCode = 0; rxCodeV.setText(toneName(ch.rxType, ch.rxSubCode)); });
        rxCodeV = choiceInto(analogGroup, "RX tone", H_RXC, null, 0, null);
        rxCodeV.setOnClickListener(v -> pickTone(false)); ((View) rxCodeV.getParent()).setOnClickListener(v -> pickTone(false));
        txCodeV.setText(toneName(ch.txType, ch.txSubCode)); rxCodeV.setText(toneName(ch.rxType, ch.rxSubCode));

        section(form, "Location");
        lat = textInto(form, "Latitude (optional)", H_POS + "\n\n" + H_MAPS, ch.lat != 0 || ch.lon != 0 ? String.format(Locale.US, "%.5f", ch.lat) : "", InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED);
        lon = textInto(form, "Longitude (optional)", H_POS, ch.lat != 0 || ch.lon != 0 ? String.format(Locale.US, "%.5f", ch.lon) : "", InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED);
        LinearLayout locRow = new LinearLayout(c); locRow.setBaselineAligned(false);
        TextView here = Neo.button(c, "My position", "radio", Neo.CYAN), maps = Neo.button(c, "Open Maps", "globe", Neo.GREEN), paste = Neo.button(c, "Paste", "import", Neo.AMBER);
        for (TextView b : new TextView[] { here, maps, paste }) { b.setTextSize(13.5f); b.setPadding((int) (6 * d), (int) (8 * d), (int) (6 * d), (int) (8 * d)); b.setCompoundDrawablePadding((int) (4 * d)); b.setSingleLine(true); }
        LayoutParams b1 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1.15f); b1.rightMargin = (int) (3 * d);
        LayoutParams b2 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1.15f); b2.leftMargin = (int) (3 * d); b2.rightMargin = (int) (3 * d);
        LayoutParams b3 = new LayoutParams(0, LayoutParams.MATCH_PARENT, 0.9f); b3.leftMargin = (int) (3 * d);
        locRow.addView(here, b1); locRow.addView(maps, b2); locRow.addView(paste, b3);
        maps.setOnClickListener(v -> openMaps());
        paste.setOnClickListener(v -> pasteLocation());
        here.setOnClickListener(v -> {
            android.location.Location me = null;
            try { android.location.LocationManager lm = (android.location.LocationManager) c.getSystemService(Context.LOCATION_SERVICE); for (String p : new String[] { "gps", "network", "passive" }) { try { android.location.Location l = lm.getLastKnownLocation(p); if (l != null && (me == null || l.getTime() > me.getTime())) me = l; } catch (SecurityException ignored) { } } } catch (Throwable ignored) { }
            if (me == null) { android.widget.Toast.makeText(c, "No position fix yet", android.widget.Toast.LENGTH_SHORT).show(); return; }
            lat.setText(String.format(Locale.US, "%.5f", me.getLatitude())); lon.setText(String.format(Locale.US, "%.5f", me.getLongitude()));
        });
        LayoutParams hl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); hl.topMargin = (int) (2 * d); form.addView(locRow, hl);
        TextView how = Neo.text(c, "Pick a place in your maps app: Open Maps, find the place, then Share \u2192 DMR Radio. Or copy its coordinates or link and tap Paste.", Neo.DIM, 13, Neo.uiMedium(c));
        how.setLineSpacing(0, 1.1f); how.setPadding((int) (4 * d), (int) (8 * d), (int) (4 * d), 0); form.addView(how);
        refreshGroups();
    }

    /** A position chosen elsewhere (shared from a maps app): fill the fields; Save keeps it. */
    public void setLocation(double la, double lo) {
        lat.setText(String.format(Locale.US, "%.5f", la)); lon.setText(String.format(Locale.US, "%.5f", lo));
        android.widget.Toast.makeText(getContext(), "Location filled in: tap Save to keep it", android.widget.Toast.LENGTH_LONG).show();
    }

    private void openMaps() {
        Context c = getContext();
        double la = 0, lo = 0;
        try { la = Double.parseDouble(lat.getText().toString().trim()); lo = Double.parseDouble(lon.getText().toString().trim()); } catch (Throwable ignored) { }
        String label = android.net.Uri.encode(ch.name == null || ch.name.isEmpty() ? "Channel" : ch.name);
        android.net.Uri u = la != 0 || lo != 0 ? android.net.Uri.parse("geo:" + la + "," + lo + "?q=" + la + "," + lo + "(" + label + ")") : android.net.Uri.parse("geo:0,0?q=");
        try { c.startActivity(new android.content.Intent(android.content.Intent.ACTION_VIEW, u)); android.widget.Toast.makeText(c, "Find the place, then Share \u2192 DMR Radio (or copy it and tap Paste)", android.widget.Toast.LENGTH_LONG).show(); }
        catch (Throwable t) { android.widget.Toast.makeText(c, "No maps app is installed", android.widget.Toast.LENGTH_LONG).show(); }
    }

    private void pasteLocation() {
        final Context c = getContext();
        android.content.ClipboardManager cm = (android.content.ClipboardManager) c.getSystemService(Context.CLIPBOARD_SERVICE);
        CharSequence clip = null;
        try { if (cm != null && cm.hasPrimaryClip() && cm.getPrimaryClip().getItemCount() > 0) clip = cm.getPrimaryClip().getItemAt(0).coerceToText(c); } catch (Throwable ignored) { }
        if (clip == null || clip.length() == 0) { android.widget.Toast.makeText(c, "The clipboard is empty: copy a place's coordinates or link in your maps app first", android.widget.Toast.LENGTH_LONG).show(); return; }
        final String text = clip.toString();
        new Thread(() -> {
            final double[] p = com.macdmr.radio.GeoLink.resolve(text);
            post(() -> { if (p == null) android.widget.Toast.makeText(c, "No coordinates found in the copied text", android.widget.Toast.LENGTH_LONG).show(); else setLocation(p[0], p[1]); });
        }).start();
    }

    private List<Integer> groupsInField() {
        List<Integer> g = new ArrayList<>();
        for (String s : groups.getText().toString().split("[,; ]+")) { s = s.trim(); if (!s.isEmpty()) try { int v = Integer.parseInt(s); if (v > 0 && !g.contains(v)) g.add(v); } catch (NumberFormatException ignored) { } }
        return g;
    }

    /** Named talkgroup lists: insert one into the RX group list, or save the current list under a name. */
    private void tgListsMenu() {
        final Context c = getContext();
        if (!(c instanceof com.macdmr.radio.MainActivity) || ((com.macdmr.radio.MainActivity) c).service() == null) return;
        final com.macdmr.radio.ChannelStore store = ((com.macdmr.radio.MainActivity) c).service().store();
        final List<com.macdmr.radio.ChannelStore.TgList> all = store.tgLists();
        String[] items = new String[all.size() + 1];
        for (int i = 0; i < all.size(); i++) items[i] = all.get(i).name + "  (" + all.get(i).tgs.length + ")";
        items[all.size()] = "Save this RX list as a new list\u2026";
        new android.app.AlertDialog.Builder(c).setTitle("Talkgroup lists").setItems(items, (d, w) -> {
            if (w < all.size()) {
                List<Integer> g = groupsInField(); int added = 0;
                for (int t : all.get(w).tgs) if (!g.contains(t) && g.size() < 32) { g.add(t); added++; }
                StringBuilder b = new StringBuilder(); for (int t : g) { if (b.length() > 0) b.append(", "); b.append(t); }
                groups.setText(b.toString());
                android.widget.Toast.makeText(c, added + " talkgroups added" + (g.size() >= 32 ? " (the radio holds 32)" : "") + ": tap Save to keep them", android.widget.Toast.LENGTH_LONG).show();
                return;
            }
            final EditText nm = new EditText(c); nm.setHint("List name");
            new android.app.AlertDialog.Builder(c).setTitle("Save talkgroup list").setView(nm).setPositiveButton("Save", (d2, w2) -> {
                List<Integer> g = groupsInField(); if (g.isEmpty() || nm.getText().toString().trim().isEmpty()) return;
                com.macdmr.radio.ChannelStore.TgList t = new com.macdmr.radio.ChannelStore.TgList(); t.name = nm.getText().toString().trim();
                t.tgs = new int[g.size()]; for (int i = 0; i < g.size(); i++) t.tgs[i] = g.get(i);
                store.saveTgList(t);
                android.widget.Toast.makeText(c, "Saved \u201C" + t.name + "\u201D", android.widget.Toast.LENGTH_SHORT).show();
            }).setNegativeButton("Cancel", null).show();
        }).show();
    }

    private void refreshGroups() {
        digitalGroup.setVisibility(ch.isDigital() ? VISIBLE : GONE);
        analogGroup.setVisibility(ch.isDigital() ? GONE : VISIBLE);
    }

    private static String[] names(int from, int to) { String[] s = new String[to - from + 1]; for (int i = from; i <= to; i++) s[i - from] = String.valueOf(i); return s; }
    private static String join(int[] a) { StringBuilder b = new StringBuilder(); for (int x : a) { if (b.length() > 0) b.append(", "); b.append(x); } return b.toString(); }
    private static String toneName(int type, int code) {
        if (type == 1) return com.macdmr.radio.dsp.ToneTable.ctcssHz(code) > 0 ? com.macdmr.radio.dsp.ToneTable.ctcssLabel(code) : "CTCSS #" + code;
        if (type == 2) return "DCS " + String.format(Locale.US, "D%03oN", code);
        return "—";
    }

    private void pickTone(final boolean txSide) {
        int type = txSide ? ch.txType : ch.rxType;
        if (type == 0) { android.widget.Toast.makeText(getContext(), "Choose CTCSS or DCS in the tone type above first", android.widget.Toast.LENGTH_SHORT).show(); return; }
        final String[] items; final int n = type == 1 ? com.macdmr.radio.dsp.ToneTable.CTCSS.length : 104;
        items = new String[n]; for (int i = 0; i < n; i++) items[i] = toneName(type, i);
        new android.app.AlertDialog.Builder(getContext()).setTitle(txSide ? "TX tone" : "RX tone").setItems(items, (d, w) -> {
            if (txSide) { ch.txSubCode = w; txCodeV.setText(items[w]); } else { ch.rxSubCode = w; rxCodeV.setText(items[w]); }
        }).show();
    }

    private interface IntSetter { void set(int v); }

    private void section(LinearLayout target, String title) {
        TextView t = Neo.caps(getContext(), title); float d = Theme.dp(getContext());
        t.setPadding((int) (2 * d), (int) (18 * d), 0, (int) (8 * d));
        target.addView(t);
    }

    /** Round "i" button that explains the field in a small card. */
    private ImageView infoButton(final String title, final String help) {
        Context c = getContext(); float d = Theme.dp(c);
        ImageView i = new ImageView(c); i.setImageDrawable(new Neo.IconDrawable("info", Neo.MUTED)); i.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        int p = (int) (11 * d); i.setPadding(p, p, p, p); i.setContentDescription("About " + title); i.setClickable(true); i.setFocusable(true);
        i.setOnClickListener(v -> showInfo(title, help));
        return i;
    }

    private void showInfo(String title, String help) {
        Context c = getContext(); float d = Theme.dp(c);
        final android.app.Dialog dlg = new android.app.Dialog(c);
        LinearLayout box = new LinearLayout(c); box.setOrientation(VERTICAL);
        box.setBackground(Neo.sheet(c, Neo.alpha(Neo.CYAN, 0x99), 18)); box.setPadding((int) (18 * d), (int) (16 * d), (int) (18 * d), (int) (14 * d));
        LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
        top.addView(Neo.iconTile(c, "info", Neo.CYAN, 36), new LayoutParams((int) (36 * d), (int) (36 * d)));
        TextView t = Neo.text(c, title.replaceAll("\\s*\\(.*\\)$", ""), Neo.TEXT, 18, Neo.ui(c)); t.setPadding((int) (12 * d), 0, 0, 0);
        top.addView(t, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        box.addView(top);
        TextView b = Neo.text(c, help, Neo.TEXT_SOFT, 15, Neo.uiMedium(c)); b.setLineSpacing(0, 1.18f); b.setPadding(0, (int) (12 * d), 0, 0);
        box.addView(b);
        TextView ok = Neo.button(c, "Got it", null, Neo.CYAN);
        LayoutParams ol = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); ol.topMargin = (int) (16 * d);
        box.addView(ok, ol);
        ok.setOnClickListener(v -> dlg.dismiss());
        dlg.setContentView(box);
        if (dlg.getWindow() != null) { dlg.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0)); dlg.getWindow().setLayout((int) (Math.min(c.getResources().getDisplayMetrics().widthPixels - 32 * d, 420 * d)), LayoutParams.WRAP_CONTENT); }
        dlg.show();
    }

    private EditText textInto(LinearLayout target, String label, String help, String value, int inputType) {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout row = rowShell(); row.setOrientation(HORIZONTAL); row.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL);
        col.addView(Neo.text(c, label, Neo.MUTED, 13, Neo.uiSemi(c)));
        EditText e = new EditText(c); e.setText(value); e.setInputType(inputType); e.setTextSize(17); e.setTextColor(Neo.TEXT); e.setSingleLine(true);
        e.setTypeface((inputType & InputType.TYPE_CLASS_NUMBER) != 0 ? Neo.mono(c) : Neo.uiSemi(c));
        e.setBackground(null); e.setPadding(0, (int) (4 * d), 0, (int) (2 * d));
        col.addView(e);
        row.addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        row.addView(infoButton(label, help), new LayoutParams((int) (40 * d), (int) (40 * d)));
        target.addView(row);
        return e;
    }

    private TextView choiceInto(LinearLayout target, String label, String help, final String[] options, int index, final IntSetter setter) {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout row = rowShell(); row.setOrientation(HORIZONTAL); row.setGravity(Gravity.CENTER_VERTICAL);
        row.addView(Neo.text(c, label, Neo.TEXT, 15.5f, Neo.uiSemi(c)), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        final TextView val = Neo.text(c, options != null && index >= 0 && index < options.length ? options[index] : "", Neo.CYAN_LIGHT, 15, Neo.ui(c));
        val.setBackground(Neo.outline(c, Neo.CYAN, 0x16, 12, 1)); val.setPadding((int) (12 * d), (int) (7 * d), (int) (12 * d), (int) (7 * d)); val.setLetterSpacing(0.03f);
        row.addView(val);
        row.addView(infoButton(label, help), new LayoutParams((int) (40 * d), (int) (40 * d)));
        if (options != null) {
            final int[] cur = { index };
            row.setClickable(true);
            View.OnClickListener cl = v -> { cur[0] = (cur[0] + 1) % options.length; val.setText(options[cur[0]]); if (setter != null) setter.set(cur[0]); };
            row.setOnClickListener(cl); val.setOnClickListener(cl);
        }
        target.addView(row);
        return val;
    }

    private LinearLayout rowShell() {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout row = new LinearLayout(c); row.setOrientation(VERTICAL);
        android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setColor(0xBF0B1622); g.setCornerRadius(12 * d); g.setStroke((int) d, 0xFF142536);
        row.setBackground(g); row.setPadding((int) (14 * d), (int) (8 * d), (int) (4 * d), (int) (8 * d)); row.setMinimumHeight((int) (56 * d));
        LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d);
        row.setLayoutParams(lp);
        return row;
    }

    /** Validate + copy the text fields into the channel. */
    private boolean apply() {
        try {
            ch.name = name.getText().toString().trim();
            ch.txFreq = (int) Math.round(Double.parseDouble(tx.getText().toString().trim()) * 1e6);
            ch.rxFreq = (int) Math.round(Double.parseDouble(rx.getText().toString().trim()) * 1e6);
            if (ch.rxFreq < 136_000_000 || ch.rxFreq > 480_000_000 || ch.txFreq < 136_000_000 || ch.txFreq > 480_000_000) throw new IllegalArgumentException("Frequencies must be 136–174 or 400–480 MHz");
            if (ch.rxFreq < 300_000_000) ch.band = 1;                                  // VHF must be wide on this radio
            String la = lat.getText().toString().trim(), lo = lon.getText().toString().trim();
            if (la.isEmpty() && lo.isEmpty()) { ch.lat = 0; ch.lon = 0; }
            else { ch.lat = Double.parseDouble(la); ch.lon = Double.parseDouble(lo); if (Math.abs(ch.lat) > 90 || Math.abs(ch.lon) > 180) throw new IllegalArgumentException("Latitude must be within ±90 and longitude within ±180"); }
            if (ch.isDigital()) {
                ch.txContact = call.getText().toString().trim().isEmpty() ? 0 : Integer.parseInt(call.getText().toString().trim());
                List<Integer> g = new ArrayList<>();
                for (String s : groups.getText().toString().split("[,; ]+")) { s = s.trim(); if (!s.isEmpty()) g.add(Integer.parseInt(s)); }
                // the radio passes a group call only if its talkgroup is in this list (measured on air 2026-10-15): include the call target
                if (ch.contactType == 1 && ch.txContact > 0 && !g.contains(ch.txContact)) g.add(0, ch.txContact);
                if (g.size() > 32) throw new IllegalArgumentException("At most 32 talkgroups in the RX list (including the call number)");
                ch.groups = new int[g.size()]; for (int i = 0; i < g.size(); i++) ch.groups[i] = g.get(i);
                String k = key.getText().toString();
                if (ch.encryptSw == 1 && k.length() != 8) throw new IllegalArgumentException("Encrypt key must be exactly 8 characters");
                ch.encryptKey = k;
            }
            return true;
        } catch (Exception e) {
            new android.app.AlertDialog.Builder(getContext()).setTitle("Check the channel").setMessage(e.getMessage() == null ? e.toString() : e.getMessage()).setPositiveButton("OK", null).show();
            return false;
        }
    }
}
