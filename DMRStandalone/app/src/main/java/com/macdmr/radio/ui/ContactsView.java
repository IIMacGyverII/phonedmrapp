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

/** Contacts: DMR IDs and talkgroups. Search, add, and per-row Message / Edit / Delete. */
public class ContactsView extends LinearLayout {
    public interface Host { void openThread(ChannelStore.Contact c); }

    private static final String[] TYPES = { "Private", "Group", "All call" };
    private final ListView list;
    private final Adapter adapter = new Adapter();
    private final EditText search;
    private final List<ChannelStore.Contact> all = new ArrayList<>(), shown = new ArrayList<>();
    private RadioService svc;
    private Host host;

    public ContactsView(Context c) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        float d = Theme.dp(c);
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (20 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        bar.addView(Theme.label(c, "Contacts", Theme.WHITE, 24, false), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        TextView add = Theme.label(c, "+", Theme.WHITE, 34, false); add.setPadding((int) (10 * d), 0, 0, 0); add.setClickable(true);
        add.setOnClickListener(v -> edit(null));
        bar.addView(add);
        addView(bar);

        LinearLayout row = new LinearLayout(c); row.setPadding((int) (10 * d), (int) (6 * d), (int) (10 * d), (int) (4 * d));
        search = new EditText(c); search.setHint("🔍 name or DMR ID"); search.setSingleLine(true); search.setTextSize(14);
        search.setTextColor(Theme.WHITE); search.setHintTextColor(0xFF8899AA); search.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        search.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (6 * d)); search.setBackground(Theme.rounded(c, 0x22FFFFFF, 0, 0, 20));
        search.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int a, int b, int n) { } @Override public void onTextChanged(CharSequence s, int a, int b, int n) { }
            @Override public void afterTextChanged(Editable e) { filter(); }
        });
        row.addView(search, new LayoutParams(LayoutParams.MATCH_PARENT, (int) (40 * d)));
        addView(row);

        list = new ListView(c); list.setAdapter(adapter); list.setDivider(null); list.setDividerHeight(0);
        list.setOnItemClickListener((p, v, pos, id) -> menu(shown.get(pos)));
        addView(list, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
    }

    public void setHost(Host h) { host = h; }
    public void attach(RadioService s) { svc = s; reload(); }

    public void reload() {
        if (svc == null) return;
        all.clear(); all.addAll(svc.store().contacts()); filter();
    }

    private void filter() {
        String q = search.getText().toString().trim().toLowerCase(Locale.US);
        shown.clear();
        for (ChannelStore.Contact ct : all) if (q.isEmpty() || ct.name.toLowerCase(Locale.US).contains(q) || String.valueOf(ct.number).contains(q)) shown.add(ct);
        adapter.notifyDataSetChanged();
    }

    private void menu(final ChannelStore.Contact ct) {
        final android.app.Dialog dlg = new android.app.Dialog(getContext());
        Context c = getContext(); float d = Theme.dp(c);
        LinearLayout box = new LinearLayout(c); box.setOrientation(VERTICAL);
        box.setBackground(Theme.rounded(c, 0xFF0D1B2A, Theme.CYAN2, 1, 14)); box.setPadding((int) (18 * d), (int) (16 * d), (int) (18 * d), (int) (12 * d));
        box.addView(Theme.label(c, ct.name, Theme.WHITE, 20, true));
        box.addView(Theme.label(c, TYPES[Math.min(2, Math.max(0, ct.type))] + "  ·  ID " + ct.number, 0xFF9AA4AE, 13, false));
        LinearLayout btns = new LinearLayout(c); btns.setGravity(Gravity.CENTER);
        String[] names = { "Message", "Edit", "Delete" }; int[][] accents = { Theme.PKT, Theme.SOFTSQ, Theme.REC };
        for (int i = 0; i < 3; i++) {
            final int k = i;
            TextView b = Theme.label(c, names[i], accents[i][3], 15, true); b.setGravity(Gravity.CENTER);
            b.setBackground(Theme.rounded(c, accents[i][0], accents[i][2], 2, 20)); b.setPadding(0, (int) (10 * d), 0, (int) (10 * d)); b.setClickable(true);
            LayoutParams lp = new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f); lp.setMargins((int) (4 * d), (int) (16 * d), (int) (4 * d), 0);
            btns.addView(b, lp);
            b.setOnClickListener(v -> {
                dlg.dismiss();
                if (k == 0 && host != null) host.openThread(ct);
                else if (k == 1) edit(ct);
                else if (k == 2) new android.app.AlertDialog.Builder(c).setTitle("Delete " + ct.name + "?").setPositiveButton("Delete", (dd, w) -> { svc.store().deleteContact(ct); reload(); }).setNegativeButton("Cancel", null).show();
            });
        }
        box.addView(btns);
        dlg.setContentView(box);
        if (dlg.getWindow() != null) dlg.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0));
        dlg.show();
    }

    private void edit(final ChannelStore.Contact existing) {
        final Context c = getContext(); float d = Theme.dp(c);
        final ChannelStore.Contact ct = existing != null ? existing : new ChannelStore.Contact();
        LinearLayout box = new LinearLayout(c); box.setOrientation(VERTICAL); box.setPadding((int) (20 * d), (int) (8 * d), (int) (20 * d), 0);
        final EditText name = new EditText(c); name.setHint("Name"); name.setText(ct.name); name.setTextColor(Theme.WHITE); box.addView(name);
        final EditText num = new EditText(c); num.setHint("DMR ID or talkgroup"); num.setInputType(InputType.TYPE_CLASS_NUMBER); if (ct.number > 0) num.setText(String.valueOf(ct.number)); num.setTextColor(Theme.WHITE); box.addView(num);
        final TextView type = Theme.label(c, "Type: " + TYPES[Math.min(2, Math.max(0, ct.type))], Theme.CYAN, 15, true);
        type.setBackground(Theme.rounded(c, 0x1400E5FF, 0x8000E5FF, 1, 14)); type.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d)); type.setClickable(true);
        final int[] t = { ct.type };
        type.setOnClickListener(v -> { t[0] = (t[0] + 1) % 3; type.setText("Type: " + TYPES[t[0]]); });
        LayoutParams tl = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); tl.topMargin = (int) (10 * d); box.addView(type, tl);
        new android.app.AlertDialog.Builder(c).setTitle(existing == null ? "New contact" : "Edit contact").setView(box)
                .setPositiveButton("Save", (dd, w) -> {
                    try {
                        ct.name = name.getText().toString().trim(); ct.number = Integer.parseInt(num.getText().toString().trim()); ct.type = t[0];
                        if (ct.number < 1 || ct.number > 16776415) throw new IllegalArgumentException("ID must be 1 … 16776415");
                        if (existing == null) svc.store().insertContact(ct); else svc.store().updateContact(ct);
                        reload();
                    } catch (Exception e) { android.widget.Toast.makeText(c, "Not saved: " + e.getMessage(), android.widget.Toast.LENGTH_LONG).show(); }
                }).setNegativeButton("Cancel", null).show();
    }

    private final class Adapter extends BaseAdapter {
        @Override public int getCount() { return shown.size(); }
        @Override public Object getItem(int i) { return shown.get(i); }
        @Override public long getItemId(int i) { return shown.get(i).id; }
        @Override public View getView(int i, View v, ViewGroup parent) {
            Context c = getContext(); float d = Theme.dp(c);
            FrameLayout row; TextView icon, name, sub;
            if (v == null) {
                row = new FrameLayout(c); row.setLayoutParams(new ListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, (int) (64 * d)));
                icon = Theme.label(c, "", Theme.WHITE, 18, true); icon.setGravity(Gravity.CENTER); icon.setTag("icon");
                icon.setBackground(Theme.rounded(c, 0xFF1A3680, Theme.CYAN, 1, 22));
                FrameLayout.LayoutParams il = new FrameLayout.LayoutParams((int) (44 * d), (int) (44 * d), Gravity.START | Gravity.CENTER_VERTICAL); il.leftMargin = (int) (16 * d);
                row.addView(icon, il);
                LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setGravity(Gravity.CENTER_VERTICAL); col.setPadding((int) (74 * d), 0, (int) (16 * d), 0);
                name = Theme.label(c, "", Theme.WHITE, 18, false); name.setSingleLine(true); name.setTag("name");
                sub = Theme.label(c, "", 0xFF9AA4AE, 13, false); sub.setTag("sub");
                col.addView(name); col.addView(sub);
                row.addView(col, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
                View line = new View(c); line.setBackgroundColor(0xFF1C2A3A); row.addView(line, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, 1, Gravity.BOTTOM));
            } else { row = (FrameLayout) v; icon = row.findViewWithTag("icon"); name = row.findViewWithTag("name"); sub = row.findViewWithTag("sub"); }
            ChannelStore.Contact ct = shown.get(i);
            icon.setText(ct.type == 1 ? "TG" : ct.type == 2 ? "ALL" : (ct.name.isEmpty() ? "?" : ct.name.substring(0, 1).toUpperCase(Locale.US)));
            name.setText(ct.name); sub.setText(TYPES[Math.min(2, Math.max(0, ct.type))] + "  ·  " + ct.number);
            return row;
        }
    }
}
