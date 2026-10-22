/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.text.InputType;
import android.view.Gravity;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelPresets;
import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

/**
 * Zones: pick the zone the arrows and the scanner use, add a zone (a standard channel list such as FRS, GMRS or
 * NOAA weather, or your own choice of channels), and rename, refill or delete a zone.
 */
public final class ZonesDialog {
    private ZonesDialog() { }

    /** {@code changed} runs after the selection or the zones changed (may be null). */
    public static void show(Context c, RadioService svc, Runnable changed) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Zones");
        body.addView(Neo.sheetHint(c, "The zone picks which channels the arrows, the scanner and the car's channel list use. Tap one to use it; ⋮ renames, refills or deletes it."));
        final AlertDialog[] self = new AlertDialog[1];
        Runnable done = () -> { if (self[0] != null) self[0].dismiss(); if (changed != null) changed.run(); };

        body.addView(zoneRow(c, svc, null, svc.zoneId() <= 0, svc.store().count(), done, self), rowLp(d));
        for (ChannelStore.Zone z : svc.store().zones()) body.addView(zoneRow(c, svc, z, svc.zoneId() == z.id, z.numbers.length, done, self), rowLp(d));

        TextView add = Neo.button(c, "Add a zone", "plus", Neo.GREEN);
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); bl.topMargin = (int) (10 * d);
        body.addView(add, bl);
        add.setOnClickListener(v -> addSheet(c, svc, done));
        self[0] = Neo.showSheet(c, body);
    }

    private static LinearLayout.LayoutParams rowLp(float d) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d); return lp;
    }

    /** A row: name and channel count, lit when in use; {@code z} null = ALL channels. */
    private static LinearLayout zoneRow(Context c, RadioService svc, ChannelStore.Zone z, boolean inUse, int count, Runnable done, AlertDialog[] self) {
        float d = Theme.dp(c);
        LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL); row.setMinimumHeight((int) (56 * d));
        row.setBackground(inUse ? Neo.tint(c, Neo.CYAN, 12, 1.5f) : Neo.rowCard(c)); row.setPadding((int) (14 * d), (int) (6 * d), (int) (6 * d), (int) (6 * d));
        LinearLayout col = new LinearLayout(c); col.setOrientation(LinearLayout.VERTICAL);
        col.addView(Neo.text(c, z == null ? "ALL channels" : z.name, inUse ? Neo.CYAN_LIGHT : Neo.TEXT, 16, Neo.ui(c)));
        col.addView(Neo.text(c, count + (count == 1 ? " channel" : " channels") + (inUse ? "  ·  in use" : ""), Neo.MUTED, 13, Neo.uiMedium(c)));
        row.addView(col, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        if (z != null) {
            ImageView more = Neo.iconButton(c, "menu", Neo.CYAN, "Zone options for " + z.name);
            row.addView(more, new LinearLayout.LayoutParams((int) (44 * d), (int) (44 * d)));
            more.setOnClickListener(v -> zoneMenu(c, svc, z, done));
        }
        row.setClickable(true);
        row.setOnClickListener(v -> { svc.setZone(z == null ? 0 : z.id); done.run(); });
        return row;
    }

    // ---- add a zone: a standard list or your own ----------------------------------------------------------

    private static void addSheet(Context c, RadioService svc, Runnable done) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Add a zone");
        body.addView(Neo.sheetHint(c, "A standard list adds its channels and a zone holding them. Channels you already have on the same frequency are reused, not doubled. Check the licence line: listening is always fine, transmitting is not on every list."));
        final AlertDialog[] self = new AlertDialog[1];
        Runnable finished = () -> { if (self[0] != null) self[0].dismiss(); done.run(); };
        body.addView(Neo.sheetSection(c, "Standard lists"));
        Set<String> have = new HashSet<>(); for (ChannelStore.Zone z : svc.store().zones()) have.add(z.name);
        for (ChannelPresets.Preset p : ChannelPresets.all()) {
            LinearLayout r = card(c, p.zone + "  ·  " + p.channels.size() + " channels", p.region + "  ·  " + p.licence + (have.contains(p.zone) ? "\nYou have a zone called " + p.zone + ": adds the missing channels to it" : ""), p.receiveOnly() ? Neo.AMBER : Neo.CYAN);
            r.setOnClickListener(v -> presetSheet(c, svc, p, finished));
            body.addView(r, rowLp(d));
        }
        body.addView(Neo.sheetSection(c, "Your own"));
        LinearLayout own = card(c, "New zone from your channels", "Name it, then tick the channels it holds", Neo.GREEN);
        own.setOnClickListener(v -> askName(c, "New zone", "", name -> {
            for (ChannelStore.Zone z : svc.store().zones()) if (z.name.equalsIgnoreCase(name)) { Toast.makeText(c, "There is already a zone called " + z.name, Toast.LENGTH_LONG).show(); return; }
            ChannelStore.Zone z = new ChannelStore.Zone(); z.name = name; z.numbers = new int[0];
            pickChannels(c, svc, z, () -> { svc.setZone(z.id); finished.run(); });
        }));
        body.addView(own, rowLp(d));
        self[0] = Neo.showSheet(c, body);
    }

    private static LinearLayout card(Context c, String title, String sub, int accent) {
        float d = Theme.dp(c);
        LinearLayout v = new LinearLayout(c); v.setOrientation(LinearLayout.VERTICAL);
        v.setBackground(Neo.rowCard(c)); v.setPadding((int) (14 * d), (int) (9 * d), (int) (12 * d), (int) (9 * d));
        v.addView(Neo.text(c, title, Neo.light(accent), 15.5f, Neo.ui(c)));
        TextView s = Neo.text(c, sub, Neo.MUTED, 13, Neo.uiMedium(c)); s.setPadding(0, (int) (2 * d), 0, 0); v.addView(s);
        v.setClickable(true); v.setFocusable(true);
        return v;
    }

    /** One standard list: what it is, its channels, the repeater tone if it has repeaters, and Add. */
    private static void presetSheet(Context c, RadioService svc, ChannelPresets.Preset p, Runnable finished) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, p.zone);
        TextView about = Neo.label(c, p.about, 0xFFD6DEE6, 13.5f, false); about.setLineSpacing(0, 1.12f); body.addView(about);
        body.addView(Neo.sheetHint(c, p.region + "  ·  " + p.licence));
        final int[] tone = { -1 };
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); bl.topMargin = (int) (8 * d);
        if (p.hasRepeaters()) {
            body.addView(Neo.sheetSection(c, "Repeater tone"));
            body.addView(Neo.sheetHint(c, "Most GMRS repeaters need a CTCSS tone to open. Pick your local repeater's tone (the repeater owner or myGMRS.com lists it); it is used both ways on the R channels. Leave None to set it later in each channel."));
            TextView tb = Neo.button(c, "Tone: None", "softsq", Neo.VIOLET); body.addView(tb, new LinearLayout.LayoutParams(bl));
            tb.setOnClickListener(v -> {
                int n = com.macdmr.radio.dsp.ToneConverter.ctcssCount();
                String[] names = new String[n + 1]; names[0] = "None";
                for (int i = 0; i < n; i++) names[i + 1] = String.format(Locale.US, "%.1f Hz", com.macdmr.radio.dsp.ToneConverter.ctcssHz(i));
                new AlertDialog.Builder(c).setTitle("Repeater tone").setItems(names, (dd, w) -> { tone[0] = w - 1; tb.setText(w == 0 ? "Tone: None" : "Tone: " + names[w]); }).show();
            });
        }
        body.addView(Neo.sheetSection(c, p.channels.size() + " channels"));
        TextView list = Neo.label(c, ChannelPresets.preview(p), 0xFFBFC8D0, 12, false); list.setTypeface(Neo.mono(c)); body.addView(list);
        TextView add = Neo.button(c, "Add " + p.zone, "plus", Neo.GREEN); body.addView(add, new LinearLayout.LayoutParams(bl));
        final AlertDialog[] self = new AlertDialog[1];
        add.setOnClickListener(v -> {
            ChannelPresets.Result r;
            try { r = ChannelPresets.install(svc.store(), p, tone[0]); }
            catch (Throwable t) { Toast.makeText(c, "Could not add " + p.zone + ": " + t.getMessage(), Toast.LENGTH_LONG).show(); return; }
            svc.setZone(r.zoneId);
            Toast.makeText(c, r.summary, Toast.LENGTH_LONG).show();
            if (self[0] != null) self[0].dismiss();
            finished.run();
        });
        self[0] = Neo.showSheet(c, body);
    }

    // ---- one zone: use, choose channels, rename, delete --------------------------------------------------

    private static void zoneMenu(Context c, RadioService svc, ChannelStore.Zone z, Runnable done) {
        float d = Theme.dp(c);
        final boolean fav = ChannelsView.FAV_ZONE.equals(z.name);
        LinearLayout body = Neo.sheetBody(c, z.name);
        List<ChannelStore.Channel> own = channelsOnlyIn(svc, z);
        body.addView(Neo.sheetHint(c, z.numbers.length + (z.numbers.length == 1 ? " channel" : " channels") + (fav ? ". Starred channels: star or unstar them on the Channels page." : "")));
        final AlertDialog[] self = new AlertDialog[1];
        Runnable close = () -> { if (self[0] != null) self[0].dismiss(); done.run(); };
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); bl.topMargin = (int) (8 * d);
        TextView use = Neo.button(c, "Use this zone", "zone", Neo.CYAN); body.addView(use, new LinearLayout.LayoutParams(bl));
        use.setOnClickListener(v -> { svc.setZone(z.id); close.run(); });
        TextView pick = Neo.button(c, "Choose its channels", "channels", Neo.CYAN); body.addView(pick, new LinearLayout.LayoutParams(bl));
        pick.setOnClickListener(v -> pickChannels(c, svc, z, close));
        if (!fav) {
            TextView ren = Neo.button(c, "Rename", "txt", Neo.CYAN); body.addView(ren, new LinearLayout.LayoutParams(bl));
            ren.setOnClickListener(v -> askName(c, "Rename zone", z.name, name -> { z.name = name; svc.store().saveZone(z); close.run(); }));
        }
        TextView del = Neo.button(c, "Delete the zone (keep its channels)", "close", Neo.AMBER); body.addView(del, new LinearLayout.LayoutParams(bl));
        del.setOnClickListener(v -> new AlertDialog.Builder(c).setTitle("Delete zone " + z.name + "?").setMessage("The channels stay in ALL channels and in any other zone.")
                .setPositiveButton("Delete", (dd, w) -> { deleteZone(svc, z); close.run(); }).setNegativeButton("Cancel", null).show());
        if (!own.isEmpty()) {
            TextView delAll = Neo.button(c, "Delete the zone and its " + own.size() + " channel" + (own.size() == 1 ? "" : "s"), "close", Neo.RED); body.addView(delAll, new LinearLayout.LayoutParams(bl));
            body.addView(Neo.sheetHint(c, own.size() == z.numbers.length ? "Its channels are in no other zone." : (z.numbers.length - own.size()) + " of its channels are also in another zone and are kept."));
            delAll.setOnClickListener(v -> new AlertDialog.Builder(c).setTitle("Delete " + z.name + " and " + own.size() + " channels?").setMessage("This removes the channels for good (a backup keeps a copy).")
                    .setPositiveButton("Delete", (dd, w) -> {
                        deleteZone(svc, z);
                        List<Long> ids = new ArrayList<>(); for (ChannelStore.Channel ch : own) ids.add(ch.id);
                        for (long id : ids) for (ChannelStore.Channel ch : svc.store().all()) if (ch.id == id) { svc.deleteChannel(ch); break; }   // numbers shift after each delete: look each one up again
                        Toast.makeText(c, "Deleted " + z.name + " and " + ids.size() + " channels", Toast.LENGTH_LONG).show();
                        close.run();
                    }).setNegativeButton("Cancel", null).show());
        }
        self[0] = Neo.showSheet(c, body);
    }

    private static void deleteZone(RadioService svc, ChannelStore.Zone z) {
        if (svc.zoneId() == z.id) svc.setZone(0);
        svc.store().deleteZone(z.id);
    }

    /** The zone's channels that no other zone holds (Favourites aside, which only marks channels). */
    private static List<ChannelStore.Channel> channelsOnlyIn(RadioService svc, ChannelStore.Zone z) {
        Set<Integer> elsewhere = new HashSet<>();
        for (ChannelStore.Zone o : svc.store().zones()) if (o.id != z.id && !ChannelsView.FAV_ZONE.equals(o.name)) for (int n : o.numbers) elsewhere.add(n);
        Set<Integer> mine = new HashSet<>(); for (int n : z.numbers) mine.add(n);
        List<ChannelStore.Channel> out = new ArrayList<>();
        if (ChannelsView.FAV_ZONE.equals(z.name)) return out;
        for (ChannelStore.Channel ch : svc.store().all()) if (mine.contains(ch.number) && !elsewhere.contains(ch.number)) out.add(ch);
        return out;
    }

    /** Tick the channels a zone holds; saves the zone (creating it if new) and runs {@code after}. */
    private static void pickChannels(Context c, RadioService svc, ChannelStore.Zone z, Runnable after) {
        final List<ChannelStore.Channel> all = svc.store().all();
        String[] names = new String[all.size()]; boolean[] on = new boolean[all.size()];
        Set<Integer> in = new HashSet<>(); for (int n : z.numbers) in.add(n);
        for (int i = 0; i < all.size(); i++) {
            ChannelStore.Channel ch = all.get(i);
            names[i] = String.format(Locale.US, "%d  %s  %.4f", ch.number, ch.name == null || ch.name.isEmpty() ? (ch.isDigital() ? "Digital" : "Analog") : ch.name, ch.rxFreq / 1e6);
            on[i] = in.contains(ch.number);
        }
        new AlertDialog.Builder(c).setTitle(z.name).setMultiChoiceItems(names, on, (dd, w, checked) -> on[w] = checked)
                .setPositiveButton("Save", (dd, w) -> {
                    List<Integer> nums = new ArrayList<>(); for (int i = 0; i < all.size(); i++) if (on[i]) nums.add(all.get(i).number);
                    z.numbers = new int[nums.size()]; for (int i = 0; i < nums.size(); i++) z.numbers[i] = nums.get(i);
                    svc.store().saveZone(z);
                    after.run();
                }).setNegativeButton("Cancel", null).show();
    }

    private interface NameDone { void named(String name); }

    private static void askName(Context c, String title, String current, NameDone then) {
        float d = Theme.dp(c);
        final EditText name = new EditText(c); name.setHint("Zone name"); name.setText(current); name.setSingleLine(true);
        name.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_WORDS); name.setTextColor(Neo.TEXT); name.setTypeface(Neo.uiSemi(c));
        LinearLayout box = new LinearLayout(c); box.setPadding((int) (22 * d), (int) (8 * d), (int) (22 * d), 0); box.addView(name, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
        new AlertDialog.Builder(c).setTitle(title).setView(box)
                .setPositiveButton("OK", (dd, w) -> {
                    String n = name.getText().toString().trim();
                    if (n.isEmpty() || ChannelsView.FAV_ZONE.equals(n)) { Toast.makeText(c, "Give the zone a name", Toast.LENGTH_SHORT).show(); return; }
                    then.named(n);
                }).setNegativeButton("Cancel", null).show();
    }
}
