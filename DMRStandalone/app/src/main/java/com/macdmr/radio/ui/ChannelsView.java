package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Channel page as the module shows it: area title with "+", the search row (name / frequency / number,
 * ALL · FM · DMR chip, ZONE pill), 60 dp rows (24 sp name, 15 sp "tx: … rx: …"), orange check on the
 * active channel. Tap a row for Use / Edit / Delete.
 */
public class ChannelsView extends LinearLayout implements RadioService.Listener {
    public interface Host { void openEditor(ChannelStore.Channel ch, boolean isNew); }

    private final ListView list;
    private final Adapter adapter = new Adapter();
    private final EditText search;
    private final TextView chip, title;
    private final List<ChannelStore.Channel> all = new ArrayList<>(), shown = new ArrayList<>();
    private RadioService svc;
    private Host host;
    private int typeFilter = 0;          // 0 all, 1 FM, 2 DMR
    private int activeNumber = -1;

    public ChannelsView(Context c) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        float d = Theme.dp(c);

        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (20 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        title = Theme.label(c, "Default UHF", Theme.WHITE, 24, false);
        bar.addView(title, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        TextView add = Theme.label(c, "+", Theme.WHITE, 34, false); add.setPadding((int) (10 * d), 0, 0, 0); add.setClickable(true);
        add.setOnClickListener(v -> { if (host != null) host.openEditor(null, true); });
        bar.addView(add);
        addView(bar);

        // search row (module U7): rounded search field, type chip, zone pill
        LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding((int) (10 * d), (int) (6 * d), (int) (8 * d), (int) (4 * d));
        search = new EditText(c); search.setHint("🔍 name, frequency or number"); search.setSingleLine(true);
        search.setTextSize(14); search.setTextColor(Theme.WHITE); search.setHintTextColor(0xFF8899AA);
        search.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        search.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (6 * d));
        search.setBackground(Theme.rounded(c, 0x22FFFFFF, 0, 0, 20));
        search.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int a, int b, int n) { } @Override public void onTextChanged(CharSequence s, int a, int b, int n) { }
            @Override public void afterTextChanged(Editable e) { filter(); }
        });
        row.addView(search, new LayoutParams(0, (int) (40 * d), 1f));
        chip = Theme.label(c, "ALL", Theme.WHITE, 12, true); chip.setGravity(Gravity.CENTER); chip.setPadding((int) (10 * d), 0, (int) (10 * d), 0);
        chip.setBackground(Theme.rounded(c, 0xFF2A3F5F, 0, 0, 20)); chip.setClickable(true);
        chip.setOnClickListener(v -> { typeFilter = (typeFilter + 1) % 3; chip.setText(new String[] { "ALL", "FM", "DMR" }[typeFilter]); chip.setBackground(Theme.rounded(c, typeFilter == 0 ? 0xFF2A3F5F : 0xFF1E8A5A, 0, 0, 20)); filter(); });
        LayoutParams cl = new LayoutParams(LayoutParams.WRAP_CONTENT, (int) (40 * d)); cl.leftMargin = (int) (6 * d);
        row.addView(chip, cl);
        TextView zone = Theme.label(c, "ZONE: ALL", Theme.WHITE, 12, true); zone.setGravity(Gravity.CENTER); zone.setBackground(Theme.rounded(c, 0xFF4169E1, 0, 0, 20));
        zone.setPadding((int) (10 * d), (int) (5 * d), (int) (10 * d), (int) (5 * d));
        LayoutParams zl = new LayoutParams((int) (100 * d), LayoutParams.WRAP_CONTENT); zl.leftMargin = (int) (6 * d);
        row.addView(zone, zl);
        addView(row);

        list = new ListView(c); list.setAdapter(adapter); list.setDivider(null); list.setDividerHeight(0);
        list.setOnItemClickListener((p, v, pos, id) -> showRowMenu(shown.get(pos)));
        addView(list, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
    }

    public void setHost(Host h) { host = h; }
    public void attach(RadioService s) { svc = s; s.addListener(this); reload(); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    public void reload() {
        if (svc == null) return;
        all.clear(); all.addAll(svc.store().all());
        activeNumber = svc.current() != null ? svc.current().number : svc.store().activeNumber();
        filter();
    }

    private void filter() {
        String q = search.getText().toString().trim().toLowerCase(Locale.US), qd = q.replaceAll("[^0-9]", "");
        shown.clear();
        for (ChannelStore.Channel ch : all) {
            if (typeFilter == 1 && ch.isDigital()) continue;
            if (typeFilter == 2 && !ch.isDigital()) continue;
            if (!q.isEmpty()) {
                boolean ok = ch.name != null && ch.name.toLowerCase(Locale.US).contains(q);
                if (!ok && !qd.isEmpty()) ok = String.valueOf(ch.number).equals(qd) || String.valueOf(ch.txFreq).startsWith(qd) || String.valueOf(ch.rxFreq).startsWith(qd);
                if (!ok) continue;
            }
            shown.add(ch);
        }
        adapter.notifyDataSetChanged();
    }

    private void showRowMenu(final ChannelStore.Channel ch) {
        final android.app.Dialog dlg = new android.app.Dialog(getContext());
        LinearLayout box = new LinearLayout(getContext()); box.setOrientation(VERTICAL);
        float d = Theme.dp(getContext());
        box.setBackground(Theme.rounded(getContext(), 0xFF0D1B2A, Theme.CYAN2, 1, 14)); box.setPadding((int) (18 * d), (int) (16 * d), (int) (18 * d), (int) (12 * d));
        TextView t = Theme.label(getContext(), "Ch " + ch.number + "  " + ch.name, Theme.WHITE, 20, true); box.addView(t);
        TextView sub = Theme.label(getContext(), (ch.isDigital() ? "DMR  CC" + ch.cc + "  TS" + (ch.inSlot + 1) + "  →" + ch.txContact : "FM  SQ" + ch.sq + "  " + (ch.band == 1 ? "wide" : "narrow")) + "   " + ch.freqText(ch.rxFreq) + " / " + ch.freqText(ch.txFreq), 0xFF9AA4AE, 13, false);
        box.addView(sub);
        LinearLayout btns = new LinearLayout(getContext()); btns.setGravity(Gravity.CENTER);
        String[] names = { "Use", "Edit", "Delete" }; int[][] accents = { Theme.PKT, Theme.SOFTSQ, Theme.REC };
        for (int i = 0; i < 3; i++) {
            final int k = i;
            TextView b = Theme.label(getContext(), names[i], accents[i][3], 15, true); b.setGravity(Gravity.CENTER);
            b.setBackground(Theme.rounded(getContext(), accents[i][0], accents[i][2], 2, 20)); b.setPadding(0, (int) (10 * d), 0, (int) (10 * d)); b.setClickable(true);
            LayoutParams lp = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); lp.setMargins((int) (4 * d), (int) (16 * d), (int) (4 * d), 0);
            btns.addView(b, lp);
            b.setOnClickListener(v -> {
                dlg.dismiss();
                if (k == 0 && svc != null) svc.selectChannel(ch.number);
                else if (k == 1 && host != null) host.openEditor(ch, false);
                else if (k == 2) confirmDelete(ch);
            });
        }
        box.addView(btns);
        dlg.setContentView(box);
        if (dlg.getWindow() != null) dlg.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0));
        dlg.show();
    }

    private void confirmDelete(final ChannelStore.Channel ch) {
        new android.app.AlertDialog.Builder(getContext()).setTitle("Delete channel " + ch.number + "?").setMessage(ch.name)
                .setPositiveButton("Delete", (dd, w) -> { if (svc != null) { svc.deleteChannel(ch); reload(); } }).setNegativeButton("Cancel", null).show();
    }

    private final class Adapter extends BaseAdapter {
        @Override public int getCount() { return shown.size(); }
        @Override public Object getItem(int i) { return shown.get(i); }
        @Override public long getItemId(int i) { return shown.get(i).id; }
        @Override public View getView(int i, View v, ViewGroup parent) {
            Context c = getContext(); float d = Theme.dp(c);
            FrameLayout row; TextView name, freqs, check;
            if (v == null) {
                row = new FrameLayout(c); row.setLayoutParams(new ListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, (int) (60 * d)));
                LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setGravity(Gravity.CENTER_VERTICAL);
                col.setPadding((int) (20 * d), 0, (int) (60 * d), 0);
                name = Theme.label(c, "", Theme.WHITE, 22, false); name.setSingleLine(true); name.setTag("name");
                freqs = Theme.label(c, "", 0xFF9AA4AE, 13, false); freqs.setTag("freqs");
                col.addView(name); col.addView(freqs);
                row.addView(col, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
                check = Theme.label(c, "✔", 0xFFFF9800, 22, true); check.setTag("check");
                FrameLayout.LayoutParams cl = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.END | Gravity.CENTER_VERTICAL); cl.rightMargin = (int) (24 * d);
                row.addView(check, cl);
                View line = new View(c); line.setBackgroundColor(0xFF1C2A3A);
                row.addView(line, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, 1, Gravity.BOTTOM));
            } else { row = (FrameLayout) v; name = row.findViewWithTag("name"); freqs = row.findViewWithTag("freqs"); check = row.findViewWithTag("check"); }
            ChannelStore.Channel ch = shown.get(i);
            name.setText(ch.name == null || ch.name.isEmpty() ? (ch.isDigital() ? "Digital " : "Analog ") + ch.number : ch.name);
            freqs.setText("tx: " + ch.txFreq + "   rx: " + ch.rxFreq);
            check.setVisibility(ch.number == activeNumber ? VISIBLE : INVISIBLE);
            return row;
        }
    }

    // RadioService.Listener
    @Override public void onChannel(ChannelStore.Channel ch) { activeNumber = ch.number; adapter.notifyDataSetChanged(); }
    @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { }
    @Override public void onLog(String s) { } @Override public void onLink(String s) { } @Override public void onLocation(String t) { } @Override public void onSms(int f, int ty, String te) { } @Override public void onSmsResult(boolean ok) { }
}
