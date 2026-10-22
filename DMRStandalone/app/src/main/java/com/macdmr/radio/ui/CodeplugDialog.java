/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.Codeplug;
import com.macdmr.radio.RadioService;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/**
 * Share channels (pick them, name the set, send it with Android's share sheet: any messaging, social, mail or cloud
 * app) and import shared channels (from a share, a file or the clipboard) after a preview.
 */
public final class CodeplugDialog {
    private CodeplugDialog() { }

    /** Channels → Share: what to do. */
    public static void menu(final Context c, final RadioService svc, final Runnable reload) {
        new AlertDialog.Builder(c).setTitle("Share channels").setItems(new String[] { "Share channels…", "Import from the clipboard", "Import a file (SignalDeck or CHIRP)" }, (dd, w) -> {
            if (w == 0) share(c, svc);
            else if (w == 1) {
                ClipboardManager cm = (ClipboardManager) c.getSystemService(Context.CLIPBOARD_SERVICE);
                CharSequence t = cm != null && cm.getPrimaryClip() != null && cm.getPrimaryClip().getItemCount() > 0 ? cm.getPrimaryClip().getItemAt(0).coerceToText(c) : null;
                Codeplug p = Codeplug.read(t == null ? null : t.toString(), null);
                if (p == null) Toast.makeText(c, "The clipboard has no shared channels. Copy the whole message (with its SDCP1 code) or a CHIRP CSV first.", Toast.LENGTH_LONG).show();
                else preview(c, svc, p, reload);
            } else if (c instanceof com.macdmr.radio.MainActivity) ((com.macdmr.radio.MainActivity) c).pickDocument(uri -> openFile(c, svc, uri, reload));
        }).show();
    }

    public static void openFile(Context c, RadioService svc, Uri uri, Runnable reload) {
        String text = read(c, uri), name = displayName(c, uri);
        Codeplug p = Codeplug.read(text, name);
        if (p == null) { Toast.makeText(c, "No SignalDeck channels or CHIRP CSV in " + (name == null ? "that file" : name), Toast.LENGTH_LONG).show(); return; }
        preview(c, svc, p, reload);
    }
    /** At most 2 MB of text from a content or file URI; null if unreadable. */
    public static String read(Context c, Uri uri) {
        if (uri == null) return null;
        try (java.io.InputStream in = c.getContentResolver().openInputStream(uri)) {
            if (in == null) return null;
            java.io.ByteArrayOutputStream o = new java.io.ByteArrayOutputStream(); byte[] b = new byte[16384]; int n;
            while ((n = in.read(b)) > 0) { o.write(b, 0, n); if (o.size() > 2_000_000) break; }
            return o.toString("UTF-8");
        } catch (Throwable t) { return null; }
    }
    public static String displayName(Context c, Uri uri) {
        try (android.database.Cursor cur = c.getContentResolver().query(uri, new String[] { android.provider.OpenableColumns.DISPLAY_NAME }, null, null, null)) {
            if (cur != null && cur.moveToFirst()) return cur.getString(0);
        } catch (Throwable ignored) { }
        String p = uri.getLastPathSegment(); return p == null ? null : p.replaceFirst(".*/", "");
    }

    // ---- share ----

    public static void share(final Context c, final RadioService svc) {
        final float d = Theme.dp(c);
        final List<ChannelStore.Channel> all = svc.store().all();
        if (all.isEmpty()) { Toast.makeText(c, "No channels yet", Toast.LENGTH_SHORT).show(); return; }
        final Set<Integer> picked = new HashSet<>();
        LinearLayout body = Neo.sheetBody(c, "Share channels");
        body.addView(Neo.sheetHint(c, "Pick the channels and send them with any app: messages, Facebook, WhatsApp, Discord, email, Drive… The message lists every channel so anyone can program it by hand, and ends with an import code SignalDeck reads back (from the message, a post or a pasted copy). Encryption keys are never included."));
        final android.widget.EditText name = new android.widget.EditText(c);
        name.setText(c.getSharedPreferences("codeplug", Context.MODE_PRIVATE).getString("lastName", "My channels")); name.setSingleLine(true);
        name.setTextColor(Neo.TEXT); name.setTextSize(16); name.setBackground(Neo.rowCard(c)); name.setPadding((int) (12 * d), (int) (10 * d), (int) (12 * d), (int) (10 * d));
        body.addView(Neo.sheetSection(c, "Name")); body.addView(name);

        body.addView(Neo.sheetSection(c, "Channels"));
        final TextView count = Neo.label(c, "", Neo.CYAN_LIGHT, 13.5f, true); body.addView(count);
        LinearLayout quick = new LinearLayout(c);
        final List<CheckRow> rows = new ArrayList<>();
        final Runnable update = () -> { for (CheckRow r : rows) r.show(picked.contains(r.ch.number)); count.setText(picked.size() + " of " + all.size() + " picked"); };
        String[] qn = { "All", "None", "Analog", "A zone…" };
        for (int i = 0; i < qn.length; i++) {
            final int q = i;
            TextView p = Neo.label(c, qn[i], Neo.CYAN, 13.5f, true); p.setGravity(Gravity.CENTER); Neo.pillStyle(p, false, Neo.CYAN);
            p.setPadding((int) (10 * d), (int) (7 * d), (int) (10 * d), (int) (7 * d));
            p.setOnClickListener(v -> {
                if (q == 0) for (ChannelStore.Channel x : all) picked.add(x.number);
                else if (q == 1) picked.clear();
                else if (q == 2) { picked.clear(); for (ChannelStore.Channel x : all) if (!x.isDigital()) picked.add(x.number); }
                else {
                    final List<ChannelStore.Zone> zs = svc.store().zones();
                    if (zs.isEmpty()) { Toast.makeText(c, "No zones yet", Toast.LENGTH_SHORT).show(); return; }
                    String[] zn = new String[zs.size()]; for (int k = 0; k < zn.length; k++) zn[k] = zs.get(k).name + " (" + zs.get(k).numbers.length + ")";
                    new AlertDialog.Builder(c).setTitle("Pick the channels of").setItems(zn, (z1, w) -> { picked.clear(); for (int n : zs.get(w).numbers) picked.add(n); name.setText(zs.get(w).name.replaceFirst("^\\W+\\s*", "")); update.run(); }).show();
                    return;
                }
                update.run();
            });
            LinearLayout.LayoutParams pl = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); pl.setMargins((int) (2 * d), (int) (6 * d), (int) (2 * d), (int) (6 * d));
            quick.addView(p, pl);
        }
        body.addView(quick);
        for (ChannelStore.Channel ch : all) {
            CheckRow r = new CheckRow(c, ch); rows.add(r);
            r.setOnClickListener(v -> { if (!picked.remove(r.ch.number)) picked.add(r.ch.number); update.run(); });
            LinearLayout.LayoutParams rl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); rl.topMargin = (int) (4 * d);
            body.addView(r, rl);
        }
        ChannelStore.Channel cur = svc.current(); if (cur != null) picked.add(cur.number);
        update.run();

        body.addView(Neo.sheetSection(c, "Include"));
        final Neo.NeonSwitch loc = new Neo.NeonSwitch(c), file = new Neo.NeonSwitch(c), chirp = new Neo.NeonSwitch(c), netsSw = new Neo.NeonSwitch(c), notesSw = new Neo.NeonSwitch(c);
        android.content.SharedPreferences pr = c.getSharedPreferences("codeplug", Context.MODE_PRIVATE);
        loc.setChecked(pr.getBoolean("loc", false)); file.setChecked(pr.getBoolean("file", true)); chirp.setChecked(pr.getBoolean("chirp", false));
        netsSw.setChecked(pr.getBoolean("nets", true)); notesSw.setChecked(pr.getBoolean("notes", false));
        body.addView(Neo.switchRow(c, "contacts", Neo.AMBER, "Net schedules", "The nets you added to these channels (name, days, time, length)", netsSw));
        body.addView(Neo.switchRow(c, "report", Neo.VIOLET, "Channel notes", "Your notes on each channel (off unless you turn it on: notes can be personal)", notesSw));
        body.addView(Neo.switchRow(c, "map", Neo.CYAN, "Channel locations", "The repeater positions you set in the channel editor", loc));
        body.addView(Neo.switchRow(c, "backup", Neo.GREEN, "A SignalDeck file", "The same list and code as a file, for apps that send files", file));
        body.addView(Neo.switchRow(c, "radio", Neo.AMBER, "A CHIRP file for other radios", "The analog channels as a CHIRP CSV (Baofeng, Yaesu, Kenwood, …)", chirp));

        LinearLayout btns = new LinearLayout(c);
        TextView copy = Neo.button(c, "Copy text", "import", Neo.CYAN), send = Neo.button(c, "Share", "send", Neo.GREEN);
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); bl.setMargins((int) (3 * d), (int) (14 * d), (int) (3 * d), 0);
        btns.addView(copy, bl); btns.addView(send, new LinearLayout.LayoutParams(bl));
        body.addView(btns);
        final AlertDialog dlg = Neo.showSheet(c, body);

        final java.util.function.Supplier<Codeplug> build = () -> {
            Codeplug p = new Codeplug(); p.name = name.getText().toString().trim(); if (p.name.isEmpty()) p.name = "Channels";
            for (ChannelStore.Channel x : all) if (picked.contains(x.number)) { p.channels.add(x); List<com.macdmr.radio.ham.NetFinder.Manual> ns = svc.store().netsOf(x.id); if (!ns.isEmpty()) p.nets.put(x, ns); }
            pr.edit().putString("lastName", p.name).putBoolean("loc", loc.isChecked()).putBoolean("file", file.isChecked()).putBoolean("chirp", chirp.isChecked())
                    .putBoolean("nets", netsSw.isChecked()).putBoolean("notes", notesSw.isChecked()).apply();
            return p;
        };
        copy.setOnClickListener(v -> {
            Codeplug p = build.get(); if (p.channels.isEmpty()) { Toast.makeText(c, "Pick at least one channel", Toast.LENGTH_SHORT).show(); return; }
            ClipboardManager cm = (ClipboardManager) c.getSystemService(Context.CLIPBOARD_SERVICE);
            if (cm != null) cm.setPrimaryClip(ClipData.newPlainText(p.name, Codeplug.shareText(p, loc.isChecked(), notesSw.isChecked(), netsSw.isChecked())));
            Toast.makeText(c, "Copied: paste it into a post or message", Toast.LENGTH_SHORT).show();
        });
        send.setOnClickListener(v -> {
            Codeplug p = build.get(); if (p.channels.isEmpty()) { Toast.makeText(c, "Pick at least one channel", Toast.LENGTH_SHORT).show(); return; }
            try { c.startActivity(shareIntent(c, p, loc.isChecked(), notesSw.isChecked(), netsSw.isChecked(), file.isChecked(), chirp.isChecked())); dlg.dismiss(); }
            catch (Throwable t) { Toast.makeText(c, "Could not share: " + t.getMessage(), Toast.LENGTH_LONG).show(); }
        });
    }

    /** The chooser: the text always; the SignalDeck file and the CHIRP CSV when asked (CHIRP only with analog channels). */
    static Intent shareIntent(Context c, Codeplug p, boolean withLoc, boolean withNotes, boolean withNets, boolean withFile, boolean withChirp) throws Exception {
        String text = Codeplug.shareText(p, withLoc, withNotes, withNets);
        File dir = new File(c.getCacheDir(), "share"); dir.mkdirs();
        File[] old = dir.listFiles(); if (old != null) for (File f : old) if (f.getName().endsWith(".signaldeck.txt") || f.getName().endsWith(".chirp.csv")) f.delete();   // only what this sheet wrote before
        String safe = p.name.replaceAll("[^A-Za-z0-9 _.-]+", "").trim(); if (safe.isEmpty()) safe = "channels";
        ArrayList<Uri> uris = new ArrayList<>();
        if (withFile) uris.add(write(c, new File(dir, safe + ".signaldeck.txt"), text));
        boolean analog = false; for (ChannelStore.Channel x : p.channels) if (!x.isDigital()) analog = true;
        if (withChirp && analog) uris.add(write(c, new File(dir, safe + ".chirp.csv"), Codeplug.chirpCsv(p)));
        Intent i;
        if (uris.isEmpty()) i = new Intent(Intent.ACTION_SEND).setType("text/plain");
        else if (uris.size() == 1) { i = new Intent(Intent.ACTION_SEND).setType(withFile ? "text/plain" : "text/csv").putExtra(Intent.EXTRA_STREAM, uris.get(0)); }
        else { i = new Intent(Intent.ACTION_SEND_MULTIPLE).setType("text/*").putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris); }
        i.putExtra(Intent.EXTRA_TEXT, text).putExtra(Intent.EXTRA_SUBJECT, p.name + " · " + p.channels.size() + " radio channels");
        if (!uris.isEmpty()) {
            ClipData cd = ClipData.newRawUri(p.name, uris.get(0)); for (int k = 1; k < uris.size(); k++) cd.addItem(new ClipData.Item(uris.get(k)));
            i.setClipData(cd); i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        }
        return Intent.createChooser(i, "Share " + p.name);
    }
    private static Uri write(Context c, File f, String s) throws Exception {
        try (FileOutputStream o = new FileOutputStream(f)) { o.write(s.getBytes(StandardCharsets.UTF_8)); }
        return androidx.core.content.FileProvider.getUriForFile(c, c.getPackageName() + ".files", f);
    }

    // ---- import ----

    /** What arrived, with each channel to tick; duplicates of channels you have start unticked. */
    public static void preview(final Context c, final RadioService svc, final Codeplug p, final Runnable reload) {
        final float d = Theme.dp(c);
        if (svc == null) { Toast.makeText(c, "SignalDeck is still starting; try again in a moment", Toast.LENGTH_SHORT).show(); return; }
        final List<ChannelStore.Channel> mine = svc.store().all();
        final Set<Integer> picked = new HashSet<>();
        LinearLayout body = Neo.sheetBody(c, "Import channels");
        body.addView(Neo.sheetHint(c, "“" + p.name + "”: " + p.channels.size() + " channel" + (p.channels.size() == 1 ? "" : "s") + (p.format.equals("CHIRP") ? " from a CHIRP file" : " shared from SignalDeck")
                + ". Untick any you don't want; channels you already have start unticked. They are added after your channels; nothing you have is changed."));
        if (!p.skipped.isEmpty()) {
            StringBuilder s = new StringBuilder("Left out (this radio can't use them):"); for (String x : p.skipped) s.append("\n· ").append(x);
            TextView t = Neo.label(c, s.toString(), Neo.AMBER_LIGHT, 12.5f, false); t.setPadding(0, (int) (4 * d), 0, (int) (6 * d)); body.addView(t);
        }
        final TextView count = Neo.label(c, "", Neo.CYAN_LIGHT, 13.5f, true); body.addView(count);
        final List<CheckRow> rows = new ArrayList<>();
        final Runnable update = () -> { for (CheckRow r : rows) r.show(picked.contains(r.index)); count.setText(picked.size() + " of " + p.channels.size() + " ticked"); };
        for (int k = 0; k < p.channels.size(); k++) {
            ChannelStore.Channel ch = p.channels.get(k);
            boolean dup = Codeplug.duplicate(ch, mine);
            CheckRow r = new CheckRow(c, ch); r.index = k;
            int nn = p.netsOf(ch).size(); if (nn > 0 || !ch.notes.isEmpty()) r.note((nn > 0 ? nn + (nn == 1 ? " net" : " nets") : "") + (nn > 0 && !ch.notes.isEmpty() ? ", " : "") + (ch.notes.isEmpty() ? "" : "notes"));
            if (dup) r.note("you already have it"); else picked.add(k);
            rows.add(r);
            r.setOnClickListener(v -> { if (!picked.remove(r.index)) picked.add(r.index); update.run(); });
            LinearLayout.LayoutParams rl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); rl.topMargin = (int) (4 * d);
            body.addView(r, rl);
        }
        update.run();
        final Neo.NeonSwitch zone = new Neo.NeonSwitch(c); zone.setChecked(true);
        final Neo.NeonSwitch extras = new Neo.NeonSwitch(c); extras.setChecked(true);
        if (p.hasNotesOrNets()) body.addView(Neo.switchRow(c, "contacts", Neo.AMBER, "Their notes and net schedules", "Saved with the channels; the nets show in Nets near you", extras));
        body.addView(Neo.switchRow(c, "zone", Neo.CYAN, "Put them in a zone", "A new zone “" + p.name + "”, so they are easy to find, scan and remove", zone));
        TextView go = Neo.button(c, "Import", "import", Neo.GREEN);
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); bl.topMargin = (int) (14 * d);
        body.addView(go, bl);
        final AlertDialog dlg = Neo.showSheet(c, body);
        go.setOnClickListener(v -> {
            if (picked.isEmpty()) { Toast.makeText(c, "Tick at least one channel", Toast.LENGTH_SHORT).show(); return; }
            List<Integer> numbers = new ArrayList<>();
            for (int k = 0; k < p.channels.size(); k++) {
                if (!picked.contains(k)) continue;
                ChannelStore.Channel ch = p.channels.get(k); ch.id = 0; ch.number = 0; ch.active = false;
                if (!extras.isChecked()) ch.notes = "";
                svc.saveChannel(ch, true);
                numbers.add(ch.number);
                if (extras.isChecked() && ch.id > 0) for (com.macdmr.radio.ham.NetFinder.Manual m : p.netsOf(ch)) { m.id = 0; m.channelId = ch.id; m.channel = ch.number; svc.store().saveNet(m); }
            }
            String where = "";
            if (zone.isChecked()) {
                ChannelStore.Zone z = new ChannelStore.Zone(); z.name = uniqueZone(svc, p.name);
                z.numbers = new int[numbers.size()]; for (int k = 0; k < z.numbers.length; k++) z.numbers[k] = numbers.get(k);
                svc.store().saveZone(z); where = " in the zone “" + z.name + "”";
            }
            dlg.dismiss();
            svc.netWatch().placesChanged();
            Toast.makeText(c, "Added " + numbers.size() + " channel" + (numbers.size() == 1 ? "" : "s") + where, Toast.LENGTH_LONG).show();
            if (reload != null) reload.run();
        });
    }
    private static String uniqueZone(RadioService svc, String name) {
        Set<String> have = new HashSet<>(); for (ChannelStore.Zone z : svc.store().zones()) have.add(z.name.toLowerCase(Locale.US));
        String n = name; int k = 2; while (have.contains(n.toLowerCase(Locale.US))) n = name + " " + k++;
        return n;
    }

    /** A channel row with a tick. */
    private static final class CheckRow extends LinearLayout {
        final ChannelStore.Channel ch; int index; private final TextView tick, sub;
        CheckRow(Context c, ChannelStore.Channel ch) {
            super(c); this.ch = ch; float d = Theme.dp(c);
            setGravity(Gravity.CENTER_VERTICAL); setBackground(Neo.rowCard(c)); setPadding((int) (10 * d), (int) (6 * d), (int) (10 * d), (int) (6 * d));
            tick = Neo.label(c, "", Neo.GREEN, 18, true); tick.setGravity(Gravity.CENTER);
            addView(tick, new LayoutParams((int) (30 * d), (int) (30 * d)));
            LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setPadding((int) (8 * d), 0, 0, 0);
            col.addView(Neo.text(c, (ch.number > 0 ? ch.number + "  " : "") + ch.name, Neo.TEXT, 15, Neo.ui(c)));
            String t = Codeplug.tone(ch.isDigital() ? 0 : ch.txType, ch.txSubCode);
            sub = Neo.text(c, String.format(Locale.US, "%.4f MHz", ch.rxFreq / 1e6) + (ch.isDigital() ? " · DMR" + (ch.txContact > 0 ? " TG " + ch.txContact : "") : " · FM" + (t.isEmpty() ? "" : " · " + t)), Neo.MUTED, 12.5f, Neo.uiMedium(c));
            col.addView(sub);
            addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
            setClickable(true);
        }
        void note(String s) { sub.setText(sub.getText() + " · " + s); }
        void show(boolean on) { tick.setText(on ? "✓" : ""); tick.setBackground(Neo.outline(getContext(), on ? Neo.GREEN : Neo.OFF, on ? 0x33 : 0x10, 8, 1.5f)); }
    }
}
