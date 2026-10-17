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

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Channel editor with the OEM's field set (name, type, frequencies in MHz, band, power, colour code,
 * mode, slot, contact type, call number, encryption, relay, interrupt, group list, squelch, tone
 * types/codes) in the intercom's styling. Enum rows cycle on tap; text rows edit in place.
 */
public class ChannelEditorView extends LinearLayout {
    public interface Done { void onDone(ChannelStore.Channel ch, boolean saved); }

    private final ChannelStore.Channel ch;
    private final boolean isNew;
    private final Done done;
    private final LinearLayout form;
    private final List<Runnable> binders = new ArrayList<>();
    private EditText name, tx, rx, call, key, groups;
    private TextView typeV, bandV, powerV, ccV, modeV, slotV, ctypeV, encV, relayV, intV, sqV, txTypeV, txCodeV, rxTypeV, rxCodeV;
    private LinearLayout digitalGroup, analogGroup;

    private static final String[] TONE_TYPES = { "None", "CTCSS", "DCS" };
    private static final double[] CTCSS = { 67.0, 69.3, 71.9, 74.4, 77.0, 79.7, 82.5, 85.4, 88.5, 91.5, 94.8, 97.4, 100.0, 103.5, 107.2, 110.9, 114.8, 118.8, 123.0, 127.3, 131.8, 136.5, 141.3, 146.2, 151.4, 156.7, 159.8, 162.2, 165.5, 167.9, 171.3, 173.8, 177.3, 179.9, 183.5, 186.2, 189.9, 192.8, 196.6, 199.5, 203.5, 206.5, 210.7, 218.1, 225.7, 229.1, 233.6, 241.8, 250.3, 254.1 };

    public ChannelEditorView(Context c, ChannelStore.Channel channel, boolean isNew, Done done) {
        super(c);
        this.ch = channel; this.isNew = isNew; this.done = done;
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        float d = Theme.dp(c);

        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (12 * d), (int) (4 * d), (int) (12 * d), (int) (4 * d));
        TextView back = Theme.label(c, "‹", Theme.WHITE, 34, false); back.setPadding(0, 0, (int) (14 * d), 0); back.setClickable(true);
        back.setOnClickListener(v -> done.onDone(ch, false));
        bar.addView(back);
        bar.addView(Theme.label(c, isNew ? "New channel" : "Edit channel " + ch.number, Theme.WHITE, 22, false), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        TextView save = Theme.label(c, "SAVE", Theme.CYAN, 15, true); save.setBackground(Theme.pill(c)); save.setPadding((int) (14 * d), (int) (8 * d), (int) (14 * d), (int) (8 * d)); save.setClickable(true);
        save.setOnClickListener(v -> { if (apply()) done.onDone(ch, true); });
        bar.addView(save);
        addView(bar);

        ScrollView sv = new ScrollView(c);
        form = new LinearLayout(c); form.setOrientation(VERTICAL); form.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (24 * d));
        sv.addView(form);
        addView(sv, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
        build();
    }

    private void build() {
        Context c = getContext();
        name = text("Channel name", ch.name, InputType.TYPE_CLASS_TEXT);
        typeV = choice("Channel type", new String[] { "Digital", "Analog" }, ch.type, v -> { ch.type = v; refreshGroups(); });
        tx = text("Send frequency (MHz)", ch.txFreq > 0 ? String.format(Locale.US, "%.5f", ch.txFreq / 1e6) : "", InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        rx = text("Receive frequency (MHz)", ch.rxFreq > 0 ? String.format(Locale.US, "%.5f", ch.rxFreq / 1e6) : "", InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        powerV = choice("Power", new String[] { "Low power", "High power" }, ch.power, v -> ch.power = v);
        bandV = choice("Band", new String[] { "Narrow band", "Wide band" }, ch.band == 0 ? 0 : 1, v -> ch.band = v);
        relayV = choice("Relay (repeater)", new String[] { "Disconnect", "Normal" }, ch.relay == 1 ? 0 : 1, v -> ch.relay = v == 0 ? 1 : 2);

        digitalGroup = new LinearLayout(c); digitalGroup.setOrientation(VERTICAL); form.addView(digitalGroup);
        LinearLayout saved = form; // route the next rows into the group
        try {
            java.lang.reflect.Field f = null; // (no reflection needed; helpers take a target)
        } catch (Throwable ignored) { }
        ccV = choiceInto(digitalGroup, "Color code", names(0, 15), ch.cc, v -> ch.cc = v);
        modeV = choiceInto(digitalGroup, "Mode", new String[] { "Direct", "Double slot" }, ch.mode == 4 ? 1 : 0, v -> ch.mode = v == 1 ? 4 : 0);
        slotV = choiceInto(digitalGroup, "Time slot", new String[] { "TS1", "TS2" }, ch.inSlot, v -> { ch.inSlot = v; ch.outSlot = v; });
        ctypeV = choiceInto(digitalGroup, "Contact type", new String[] { "Private", "Group", "All" }, ch.contactType, v -> ch.contactType = v);
        call = textInto(digitalGroup, "Call number (DMR ID / talkgroup)", ch.txContact > 0 ? String.valueOf(ch.txContact) : "", InputType.TYPE_CLASS_NUMBER);
        groups = textInto(digitalGroup, "RX group list (talkgroups, comma separated, up to 32)", join(ch.groups), InputType.TYPE_CLASS_TEXT);
        encV = choiceInto(digitalGroup, "Encrypt switch", new String[] { "Disabled", "Enabled" }, ch.encryptSw == 1 ? 1 : 0, v -> ch.encryptSw = v == 1 ? 1 : 2);
        key = textInto(digitalGroup, "Encrypt key (8 characters)", ch.encryptKey == null ? "" : ch.encryptKey, InputType.TYPE_CLASS_TEXT);
        intV = choiceInto(digitalGroup, "Interrupt transmission", new String[] { "OFF", "ON" }, ch.interrupt == 1 ? 1 : 0, v -> ch.interrupt = v == 1 ? 1 : 2);

        analogGroup = new LinearLayout(c); analogGroup.setOrientation(VERTICAL); form.addView(analogGroup);
        sqV = choiceInto(analogGroup, "Squelch level", names(0, 9), ch.sq, v -> ch.sq = v);
        txTypeV = choiceInto(analogGroup, "TX tone type", TONE_TYPES, ch.txType, v -> { ch.txType = v; ch.txSubCode = 0; txCodeV.setText(toneName(ch.txType, ch.txSubCode)); });
        txCodeV = choiceInto(analogGroup, "TX tone", null, 0, null);
        txCodeV.setOnClickListener(v -> pickTone(true));
        rxTypeV = choiceInto(analogGroup, "RX tone type", TONE_TYPES, ch.rxType, v -> { ch.rxType = v; ch.rxSubCode = 0; rxCodeV.setText(toneName(ch.rxType, ch.rxSubCode)); });
        rxCodeV = choiceInto(analogGroup, "RX tone", null, 0, null);
        rxCodeV.setOnClickListener(v -> pickTone(false));
        txCodeV.setText(toneName(ch.txType, ch.txSubCode)); rxCodeV.setText(toneName(ch.rxType, ch.rxSubCode));
        refreshGroups();
    }

    private void refreshGroups() {
        digitalGroup.setVisibility(ch.isDigital() ? VISIBLE : GONE);
        analogGroup.setVisibility(ch.isDigital() ? GONE : VISIBLE);
    }

    private static String[] names(int from, int to) { String[] s = new String[to - from + 1]; for (int i = from; i <= to; i++) s[i - from] = String.valueOf(i); return s; }
    private static String join(int[] a) { StringBuilder b = new StringBuilder(); for (int x : a) { if (b.length() > 0) b.append(", "); b.append(x); } return b.toString(); }
    private static String toneName(int type, int code) {
        if (type == 1) return code >= 0 && code < CTCSS.length ? String.format(Locale.US, "%.1f Hz", CTCSS[code]) : "CTCSS #" + code;
        if (type == 2) return "DCS " + String.format(Locale.US, "D%03oN", code);
        return "—";
    }

    private void pickTone(final boolean txSide) {
        int type = txSide ? ch.txType : ch.rxType;
        if (type == 0) return;
        final String[] items; final int n = type == 1 ? CTCSS.length : 104;
        items = new String[n]; for (int i = 0; i < n; i++) items[i] = toneName(type, i);
        new android.app.AlertDialog.Builder(getContext()).setTitle(txSide ? "TX tone" : "RX tone").setItems(items, (d, w) -> {
            if (txSide) { ch.txSubCode = w; txCodeV.setText(items[w]); } else { ch.rxSubCode = w; rxCodeV.setText(items[w]); }
        }).show();
    }

    private interface IntSetter { void set(int v); }

    private EditText text(String label, String value, int inputType) { return textInto(form, label, value, inputType); }
    private EditText textInto(LinearLayout target, String label, String value, int inputType) {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout row = rowShell();
        row.addView(Theme.label(c, label, 0xFF9AA4AE, 12, false));
        EditText e = new EditText(c); e.setText(value); e.setInputType(inputType); e.setTextSize(17); e.setTextColor(Theme.WHITE); e.setSingleLine(true);
        e.setBackground(null); e.setPadding(0, (int) (4 * d), 0, (int) (4 * d));
        row.addView(e);
        target.addView(row);
        return e;
    }

    private TextView choice(String label, String[] options, int index, IntSetter setter) { return choiceInto(form, label, options, index, setter); }
    private TextView choiceInto(LinearLayout target, String label, final String[] options, int index, final IntSetter setter) {
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout row = rowShell(); row.setOrientation(HORIZONTAL); row.setGravity(Gravity.CENTER_VERTICAL);
        row.addView(Theme.label(c, label, 0xFFBFC8D0, 15, false), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        final TextView val = Theme.label(c, options != null && index >= 0 && index < options.length ? options[index] : "", Theme.CYAN, 15, true);
        val.setBackground(Theme.rounded(c, 0x1400E5FF, 0x8000E5FF, 1, 14)); val.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (6 * d));
        row.addView(val);
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
        row.setBackground(Theme.rounded(c, 0x18000000, 0x3300BFFF, 1, 8)); row.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
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
            if (ch.isDigital()) {
                ch.txContact = call.getText().toString().trim().isEmpty() ? 0 : Integer.parseInt(call.getText().toString().trim());
                List<Integer> g = new ArrayList<>();
                for (String s : groups.getText().toString().split("[,; ]+")) { s = s.trim(); if (!s.isEmpty()) g.add(Integer.parseInt(s)); }
                if (g.size() > 32) throw new IllegalArgumentException("At most 32 talkgroups in the RX list");
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
