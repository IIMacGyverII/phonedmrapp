package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.NetWatch;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.NetFinder;
import com.macdmr.radio.repeaters.RepeaterModels.Repeater;

import java.util.List;
import java.util.Locale;

/** Nets: on the air near you now (NetLogger + what the radio hears), coming up, and elsewhere; reminders. */
public final class NetsDialog {
    private final Context c; private final RadioService svc; private final float d;
    private final Handler ui = new Handler(Looper.getMainLooper());
    private LinearLayout list; private TextView status; private AlertDialog dlg; private boolean showElsewhere, showMaybe;
    private final Runnable refresh = this::load;

    public static void show(Context c, RadioService svc) { if (svc != null) new NetsDialog(c, svc).open(); }
    private NetsDialog(Context c, RadioService svc) { this.c = c; this.svc = svc; d = Theme.dp(c); }

    private void open() {
        LinearLayout body = Neo.sheetBody(c, "Nets");
        body.addView(Neo.sheetHint(c, "Nets and get-togethers on your channels and nearby repeaters: the ones in session now on NetLogger, the one the radio is hearing, and when they come back."));
        final NetWatch w = svc.netWatch();
        Neo.NeonSwitch remind = new Neo.NeonSwitch(c), live = new Neo.NeonSwitch(c);
        remind.setChecked(w.remind()); live.setChecked(w.liveAlerts());
        remind.setOnChange(w::setRemind); live.setOnChange(w::setLiveAlerts);
        body.addView(Neo.switchRow(c, "alert", Neo.AMBER, "Remind me", "10 minutes before a net in Coming up", remind));
        body.addView(Neo.switchRow(c, "intercom", Neo.GREEN, "Tell me when a net starts", "A NetLogger net opening on your channels or nearby repeaters (checked every 5 minutes)", live));
        status = Neo.label(c, "Looking for nets…", Neo.MUTED, 12.5f, false); status.setPadding(0, (int) (8 * d), 0, 0);
        body.addView(status);
        list = new LinearLayout(c); list.setOrientation(LinearLayout.VERTICAL); body.addView(list);
        LinearLayout row = new LinearLayout(c);
        TextView again = Neo.button(c, "Refresh", "update", Neo.CYAN), run = Neo.button(c, "Run a net", "contacts", Neo.VIOLET);
        LinearLayout.LayoutParams bl = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); bl.setMargins((int) (3 * d), (int) (12 * d), (int) (3 * d), 0);
        row.addView(again, bl); row.addView(run, new LinearLayout.LayoutParams(bl));
        body.addView(row);
        TextView add = Neo.button(c, "Add a net to a channel", "plus", Neo.AMBER);
        LinearLayout.LayoutParams al = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); al.setMargins((int) (3 * d), (int) (8 * d), (int) (3 * d), 0);
        body.addView(add, al);
        add.setOnClickListener(v -> { NetFinder.Manual m = new NetFinder.Manual(); com.macdmr.radio.ChannelStore.Channel cur = svc.current(); if (cur != null) m.channel = cur.number; editManual(c, svc.store().all(), m, this::load); });
        again.setOnClickListener(v -> { status.setText("Looking for nets…"); load(); });
        run.setOnClickListener(v -> { if (dlg != null) dlg.dismiss(); NetDialog.show(c, svc); });
        dlg = Neo.showSheet(c, body);
        dlg.setOnDismissListener(x -> ui.removeCallbacks(refresh));
        load();
    }

    private void load() {
        ui.removeCallbacks(refresh);
        new Thread(() -> {
            NetWatch.Snapshot s;
            try { s = svc.netWatch().snapshot(); } catch (Throwable t) { s = new NetWatch.Snapshot(); s.error = String.valueOf(t.getMessage()); }
            final NetWatch.Snapshot r = s;
            ui.post(() -> { if (dlg != null && dlg.isShowing()) { render(r); ui.postDelayed(refresh, 60_000); } });
        }, "nets-load").start();
    }

    private void render(NetWatch.Snapshot s) {
        list.removeAllViews();
        long now = System.currentTimeMillis();
        status.setText(s.error != null ? "NetLogger: " + s.error + (s.total > 0 ? " (showing the last list)" : "") : "NetLogger: " + s.total + " nets in session worldwide · updated every minute");

        list.addView(Neo.sheetSection(c, "On the air near you"));
        int shown = 0;
        if (s.heard != null) {
            NetFinder.Session h = s.heard;
            String title = (h.name.isEmpty() ? "Sounds like a net" : h.name) + " on " + s.heardLabel;
            String sub = h.receptions + " transmissions in " + h.minutes() + " min" + (h.stations > 0 ? " from " + h.stations + " stations" : "") + " · heard by the radio · tap to tune";
            LinearLayout cd = card(title, sub, Neo.GREEN); final int ch = h.channel;
            cd.setOnClickListener(v -> tuneChannel(ch));
            list.addView(cd, lp(6)); shown++;
        }
        for (NetWatch.Found f : s.yours) {
            NetFinder.Net n = f.net;
            String sub = NetFinder.where(n) + " · " + f.place.label + (f.place.km >= 0 ? String.format(Locale.US, " (%.0f mi)", f.place.km * 0.621371) : "")
                    + (n.netControl.isEmpty() ? "" : " · net control " + n.netControl) + " · " + n.followers + " following" + (n.opened > 0 ? " · started " + Math.max(0, (now - n.opened) / 60000) + " min ago" : "") + (f.near == 0 ? " · place not known (same frequency; long-press to say)" : "");
            LinearLayout cd = card(n.name, sub, Neo.CYAN);
            cd.setOnClickListener(v -> netActions(f));
            cd.setOnLongClickListener(v -> { askNear(f.net.name); return true; });
            list.addView(cd, lp(6)); shown++;
        }
        if (shown == 0) list.addView(Neo.sheetHint(c, "No net is in session on your channels or nearby repeaters right now. NetLogger only lists nets whose net control uses it; the radio spots the others while it listens (a long run of transmissions from several stations)."));

        list.addView(Neo.sheetSection(c, "Coming up"));
        if (s.schedule.isEmpty()) list.addView(Neo.sheetHint(c, "Nothing yet. Times come from NetLogger's last week on your channels and nearby repeaters, and from what the radio hears: a net on the same channel at the same time on the same weekday two weeks running (or three days in a row) becomes a schedule."));
        for (final NetFinder.Slot sl : s.schedule) {
            String sub = NetFinder.when(sl) + " · " + NetWatch.relative(sl, now) + (sl.place != null ? " · " + sl.place.label : "") + " · about " + sl.durationMin + " min"
                    + (sl.stations > 0 ? " · " + sl.stations + " stations" : "") + " · " + sl.source + (sl.near == 0 ? " · place not known" : "") + (sl.notes.isEmpty() ? "" : "\n" + sl.notes);
            LinearLayout cd = card(sl.name, sub, Neo.AMBER);
            cd.setOnClickListener(v -> tune(sl.place));
            cd.setOnLongClickListener(v -> { slotActions(sl); return true; });
            list.addView(cd, lp(6));
        }

        if (!s.maybe.isEmpty() || !s.unsure.isEmpty()) {
            list.addView(Neo.sheetSection(c, "Same frequency, maybe elsewhere"));
            TextView more = Neo.label(c, (showMaybe ? "Hide" : "Show") + " " + (s.maybe.size() + s.unsure.size()) + " nets on the frequency of one of your channels or a nearby repeater, but not known to be near you: NetLogger has no locations. Long-press one to say it is near you", Neo.CYAN_LIGHT, 13, false);
            more.setPadding(0, (int) (4 * d), 0, (int) (4 * d));
            more.setOnClickListener(v -> { showMaybe = !showMaybe; render(s); });
            list.addView(more);
            if (showMaybe) for (final NetFinder.Slot sl : s.unsure) {
                LinearLayout cd = card(sl.name, NetFinder.when(sl) + (sl.place != null ? " · same frequency as " + sl.place.label : "") + " · " + sl.source, Neo.MUTED);
                cd.setOnClickListener(v -> tune(sl.place));
                cd.setOnLongClickListener(v -> { slotActions(sl); return true; });
                list.addView(cd, lp(4));
            }
            if (showMaybe) for (NetWatch.Found f : s.maybe) {
                LinearLayout cd = card(f.net.name, NetFinder.where(f.net) + " · same frequency as " + f.place.label + (f.net.netControl.isEmpty() ? "" : " · net control " + f.net.netControl) + " · " + f.net.followers + " following", Neo.MUTED);
                cd.setOnClickListener(v -> netActions(f));
                cd.setOnLongClickListener(v -> { askNear(f.net.name); return true; });
                list.addView(cd, lp(4));
            }
        }
        if (!s.elsewhere.isEmpty()) {
            list.addView(Neo.sheetSection(c, "Elsewhere on the air"));
            TextView more = Neo.label(c, (showElsewhere ? "Hide" : "Show") + " " + s.elsewhere.size() + " more nets on 2 m, 70 cm and DMR talkgroups (not near you; a DMR talkgroup can still be reached by adding it to a DMR channel's receive list)", Neo.CYAN_LIGHT, 13, false);
            more.setPadding(0, (int) (4 * d), 0, (int) (4 * d));
            more.setOnClickListener(v -> { showElsewhere = !showElsewhere; render(s); });
            list.addView(more);
            if (showElsewhere) for (NetFinder.Net n : s.elsewhere) {
                LinearLayout cd = card(n.name, NetFinder.where(n) + (n.mode.isEmpty() ? "" : " · " + n.mode) + (n.netControl.isEmpty() ? "" : " · net control " + n.netControl) + " · " + n.followers + " following", Neo.MUTED);
                cd.setOnClickListener(v -> checkins(n));
                list.addView(cd, lp(4));
            }
        }
    }

    /** Your answer for a net matched by frequency: near me, not near me (moved to "probably elsewhere"), or forget it. */
    private void askNear(String name) {
        new AlertDialog.Builder(c).setTitle(name).setItems(new String[] { "It's near me", "Not near me (hide it)", "Don't know (let SignalDeck guess)" }, (dd, w) -> { svc.netWatch().setNear(name, w == 0 ? 1 : w == 1 ? -1 : 0); load(); }).show();
    }

    private void slotActions(NetFinder.Slot sl) {
        if (sl.manualId != 0) {
            NetFinder.Manual m = null; for (NetFinder.Manual x : NetWatch.manual(c)) if (x.id == sl.manualId) m = x;
            if (m == null) return; final NetFinder.Manual fm = m;
            new AlertDialog.Builder(c).setTitle(sl.name).setItems(new String[] { "Edit", "Delete" }, (dd, w) -> {
                if (w == 0) editManual(c, svc.store().all(), fm, this::load);
                else new AlertDialog.Builder(c).setTitle("Delete " + fm.name + "?").setPositiveButton("Delete", (d2, w2) -> { NetWatch.deleteManual(c, fm.id); load(); }).setNegativeButton("Cancel", null).show();
            }).show();
            return;
        }
        new AlertDialog.Builder(c).setTitle(sl.name).setItems(new String[] { "Add it as my net (name it, set the days)", "It's near me", "Not near me (hide it)" }, (dd, w) -> {
            if (w == 0) {
                if (sl.channel == 0) { Toast.makeText(c, "It is on a repeater that is not one of your channels: add the repeater as a channel first (tap the net)", Toast.LENGTH_LONG).show(); return; }
                NetFinder.Manual m = new NetFinder.Manual(); m.name = sl.name; m.channel = sl.channel; m.minute = sl.minute; m.durationMin = sl.durationMin;
                m.days = sl.dow == 0 ? NetFinder.ALL_DAYS : 1 << sl.dow;
                editManual(c, svc.store().all(), m, this::load);
            } else { svc.netWatch().setNear(sl.name, w == 1 ? 1 : -1); load(); }
        }).show();
    }

    private static final String[] DAY_LETTERS = { "S", "M", "T", "W", "T", "F", "S" };
    /**
     * Add or edit a net on a channel: name, channel (fixed when {@code channels} is null), weekdays, start time, length,
     * notes. Saved nets show in Coming up and get the reminders.
     */
    public static void editManual(final Context c, final List<com.macdmr.radio.ChannelStore.Channel> channels, final NetFinder.Manual src, final Runnable after) {
        final float d = Theme.dp(c);
        final NetFinder.Manual m = new NetFinder.Manual();
        m.id = src.id; m.name = src.name; m.notes = src.notes; m.channel = src.channel; m.days = src.days; m.durationMin = src.durationMin;
        m.minute = src.id == 0 && src.minute == 0 ? 19 * 60 : src.minute;          // a new net: 7:00 PM to start with
        LinearLayout body = Neo.sheetBody(c, src.id == 0 ? "Add a net" : "Edit net");
        body.addView(Neo.sheetHint(c, "A net or get-together you know about. It shows in Nets, Coming up; it can remind you 10 minutes before; tapping it tunes the channel."));
        final android.widget.EditText name = field(c, body, "Name", m.name, "e.g. Tuesday Night Net");
        body.addView(Neo.sheetSection(c, "Channel"));
        final TextView chV = Neo.label(c, "", Neo.CYAN_LIGHT, 15, true); chV.setPadding((int) (4 * d), (int) (6 * d), 0, (int) (6 * d)); body.addView(chV);
        final Runnable showCh = () -> {
            com.macdmr.radio.ChannelStore.Channel f = null;
            if (channels != null) for (com.macdmr.radio.ChannelStore.Channel x : channels) if (x.number == m.channel) f = x;
            chV.setText(m.channel == 0 ? "Choose a channel" : "Channel " + m.channel + (f == null ? "" : "  " + f.name + String.format(Locale.US, "  %.4f MHz", f.rxFreq / 1e6)) + (channels != null ? "  ·  tap to change" : ""));
        };
        showCh.run();
        if (channels != null) chV.setOnClickListener(v -> {
            String[] names = new String[channels.size()]; for (int i = 0; i < names.length; i++) names[i] = channels.get(i).number + "  " + channels.get(i).name;
            new AlertDialog.Builder(c).setTitle("Which channel?").setItems(names, (dd, w) -> { m.channel = channels.get(w).number; showCh.run(); }).show();
        });
        body.addView(Neo.sheetSection(c, "Days"));
        LinearLayout days = new LinearLayout(c);
        String[] full = new java.text.DateFormatSymbols(Locale.US).getWeekdays();
        for (int i = 0; i < 7; i++) {
            final int dow = i + 1;
            final TextView p = Neo.label(c, DAY_LETTERS[i], Neo.AMBER, 15, true); p.setGravity(android.view.Gravity.CENTER);
            p.setPadding(0, (int) (8 * d), 0, (int) (8 * d)); Neo.pillStyle(p, m.on(dow), Neo.AMBER);
            p.setContentDescription(full[dow]);
            p.setOnClickListener(v -> { m.days ^= 1 << dow; Neo.pillStyle(p, m.on(dow), Neo.AMBER); });
            LinearLayout.LayoutParams pl = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); pl.setMargins((int) (2 * d), 0, (int) (2 * d), 0);
            days.addView(p, pl);
        }
        body.addView(days);
        body.addView(Neo.sheetSection(c, "Starts"));
        final TextView time = Neo.label(c, "", Neo.CYAN_LIGHT, 18, true); time.setPadding((int) (4 * d), (int) (6 * d), 0, (int) (6 * d)); body.addView(time);
        final Runnable showT = () -> { int h = m.minute / 60, mi = m.minute % 60; time.setText(String.format(Locale.US, "%d:%02d %s  ·  tap to change", h % 12 == 0 ? 12 : h % 12, mi, h < 12 ? "AM" : "PM")); };
        showT.run();
        time.setOnClickListener(v -> new android.app.TimePickerDialog(c, (tp, h, mi) -> { m.minute = h * 60 + mi; showT.run(); }, m.minute / 60, m.minute % 60, android.text.format.DateFormat.is24HourFormat(c)).show());
        final android.widget.EditText len = field(c, body, "Length in minutes", String.valueOf(m.durationMin), "60");
        len.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
        final android.widget.EditText notes = field(c, body, "Notes (optional)", m.notes, "net control, how to check in");
        TextView save = Neo.button(c, "Save", "check", Neo.GREEN);
        LinearLayout.LayoutParams sl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); sl.topMargin = (int) (14 * d);
        body.addView(save, sl);
        final AlertDialog dlg = Neo.showSheet(c, body);
        save.setOnClickListener(v -> {
            m.name = name.getText().toString().trim(); m.notes = notes.getText().toString().trim();
            try { m.durationMin = Math.max(5, Math.min(600, Integer.parseInt(len.getText().toString().trim()))); } catch (NumberFormatException e) { m.durationMin = 60; }
            if (m.name.isEmpty()) { Toast.makeText(c, "Give the net a name", Toast.LENGTH_SHORT).show(); return; }
            if (m.channel == 0) { Toast.makeText(c, "Choose a channel", Toast.LENGTH_SHORT).show(); return; }
            if (m.days == 0) { Toast.makeText(c, "Tick at least one day", Toast.LENGTH_SHORT).show(); return; }
            NetWatch.saveManual(c, m);
            dlg.dismiss();
            Toast.makeText(c, m.name + ": " + NetFinder.when(m), Toast.LENGTH_SHORT).show();
            if (after != null) after.run();
        });
    }
    private static android.widget.EditText field(Context c, LinearLayout body, String label, String value, String hint) {
        float d = Theme.dp(c);
        body.addView(Neo.sheetSection(c, label));
        android.widget.EditText e = new android.widget.EditText(c); e.setText(value); e.setHint(hint); e.setSingleLine(true);
        e.setTextColor(Neo.TEXT); e.setHintTextColor(Neo.DIM); e.setTextSize(16); e.setBackground(Neo.rowCard(c)); e.setPadding((int) (12 * d), (int) (10 * d), (int) (12 * d), (int) (10 * d));
        body.addView(e);
        return e;
    }

    private void netActions(NetWatch.Found f) {
        String tune = f.place.channel > 0 ? "Tune to " + f.place.label : "Repeater details (add it as a channel)";
        new AlertDialog.Builder(c).setTitle(f.net.name).setItems(new String[] { tune, "Who has checked in" }, (dd, w) -> { if (w == 0) tune(f.place); else checkins(f.net); }).show();
    }

    private void tune(NetFinder.Place p) {
        if (p == null) { Toast.makeText(c, "Not on one of your channels", Toast.LENGTH_SHORT).show(); return; }
        if (p.channel > 0) { tuneChannel(p.channel); return; }
        if (p.data instanceof Repeater) {
            Repeater r = (Repeater) p.data; android.location.Location me = svc.lastKnownLocation();
            RepeatersDialog.showDetails(c, svc, r, me != null ? me.getLatitude() : r.lat, me != null ? me.getLongitude() : r.lon);
        }
    }
    private void tuneChannel(int number) {
        svc.selectChannel(number);
        Toast.makeText(c, "Tuned to channel " + number, Toast.LENGTH_SHORT).show();
    }

    private void checkins(final NetFinder.Net n) {
        LinearLayout body = Neo.sheetBody(c, n.name);
        body.addView(Neo.sheetHint(c, NetFinder.where(n) + (n.netControl.isEmpty() ? "" : " · net control " + n.netControl) + " · from NetLogger, as net control logs them (▶ = the station working now)"));
        final LinearLayout rows = new LinearLayout(c); rows.setOrientation(LinearLayout.VERTICAL); body.addView(rows);
        final TextView st = Neo.label(c, "Loading…", Neo.MUTED, 12.5f, false); rows.addView(st);
        Neo.showSheet(c, body);
        new Thread(() -> {
            String err = null; List<NetFinder.Checkin> l = null; int[] ptr = { 0 };
            try { l = svc.netWatch().checkins(n, ptr); } catch (Throwable t) { err = t.getMessage(); }
            final List<NetFinder.Checkin> fl = l; final String fe = err;
            ui.post(() -> {
                rows.removeAllViews();
                if (fe != null) { rows.addView(Neo.sheetHint(c, "Could not load: " + fe)); return; }
                if (fl == null || fl.isEmpty()) { rows.addView(Neo.sheetHint(c, "No check-ins yet.")); return; }
                rows.addView(Neo.sheetHint(c, fl.size() + " checked in"));
                for (NetFinder.Checkin k : fl) {
                    String line = (k.serial == ptr[0] ? "▶ " : "") + k.serial + ".  " + k.call + (k.name.isEmpty() ? "" : "  " + cap(k.name)) + (k.state.isEmpty() ? "" : " · " + k.state) + (k.status.trim().isEmpty() ? "" : " · " + k.status.trim());
                    TextView t = Neo.label(c, line, k.serial == ptr[0] ? Neo.GREEN_LIGHT : Neo.TEXT_SOFT, 14, k.serial == ptr[0]); t.setPadding(0, (int) (3 * d), 0, (int) (3 * d));
                    rows.addView(t);
                }
            });
        }, "nets-checkins").start();
    }
    private static String cap(String s) { return s.length() < 2 ? s : s.charAt(0) + s.substring(1).toLowerCase(Locale.US); }

    private LinearLayout card(String title, String sub, int accent) {
        LinearLayout v = new LinearLayout(c); v.setOrientation(LinearLayout.VERTICAL); v.setBackground(Neo.rowCard(c)); v.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
        TextView t = Neo.text(c, title, Neo.light(accent), 15.5f, Neo.ui(c)); v.addView(t);
        v.addView(Neo.text(c, sub, Neo.MUTED, 12.5f, Neo.uiMedium(c)));
        v.setClickable(true); return v;
    }
    private LinearLayout.LayoutParams lp(int top) { LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); l.topMargin = (int) (top * d); return l; }
}
