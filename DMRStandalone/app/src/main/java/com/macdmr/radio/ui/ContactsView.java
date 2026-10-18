package com.macdmr.radio.ui;

import android.content.Context;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Contacts: DMR IDs and talkgroups as cards with a colour-coded avatar (cyan private, violet talkgroup, amber
 * all-call), name, type badge and ID, and a one-tap message button. Header with counts and add; search;
 * All / Private / Talkgroups chips. Tap a card for Message / Edit / Delete.
 */
public class ContactsView extends LinearLayout {
    public interface Host { void openThread(ChannelStore.Contact c); }

    private static final String[] TYPES = { "Private", "Group", "All call" };
    private final ListView list;
    private final Adapter adapter = new Adapter();
    private final EditText search;
    private final LinearLayout header;
    private final TextView[] chips = new TextView[3];
    private final List<ChannelStore.Contact> all = new ArrayList<>(), shown = new ArrayList<>();
    private int filter = 0;              // 0 all, 1 private, 2 talkgroups (group + all call)
    private RadioService svc;
    private Host host;

    public ContactsView(Context c) {
        super(c);
        setOrientation(VERTICAL);   // background: the window's
        float d = Theme.dp(c);
        header = Neo.header(c, "Contacts", "");
        ImageView add = Neo.iconButton(c, "plus", Neo.GREEN, "Add contact");
        add.setOnClickListener(v -> edit(null));
        Neo.addAction(header, add);
        addView(header);

        LinearLayout sf = new LinearLayout(c); sf.setGravity(Gravity.CENTER_VERTICAL);
        sf.setBackground(Neo.card(c, Neo.alpha(Neo.CYAN, 0x33), 12)); sf.setPadding((int) (14 * d), 0, (int) (10 * d), 0);
        ImageView si = new ImageView(c); si.setImageDrawable(new Neo.IconDrawable("search", Neo.MUTED));
        sf.addView(si, new LayoutParams((int) (18 * d), (int) (18 * d)));
        search = new EditText(c); search.setHint("Name or DMR ID"); search.setSingleLine(true); search.setTextSize(16); search.setTypeface(Neo.uiSemi(c));
        search.setTextColor(Neo.TEXT); search.setHintTextColor(Neo.DIM); search.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        search.setBackground(null); search.setPadding((int) (10 * d), 0, 0, 0);
        search.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int a, int b, int n) { } @Override public void onTextChanged(CharSequence s, int a, int b, int n) { }
            @Override public void afterTextChanged(Editable e) { filter(); }
        });
        sf.addView(search, new LayoutParams(0, (int) (44 * d), 1f));
        LayoutParams sfl = new LayoutParams(LayoutParams.MATCH_PARENT, (int) (46 * d)); sfl.setMargins((int) (16 * d), (int) (10 * d), (int) (16 * d), 0);
        addView(sf, sfl);

        HorizontalScrollView hs = new HorizontalScrollView(c); hs.setHorizontalScrollBarEnabled(false);
        LinearLayout cr = new LinearLayout(c); cr.setPadding((int) (16 * d), (int) (10 * d), (int) (16 * d), (int) (8 * d));
        String[] names = { "ALL", "PRIVATE", "TALKGROUPS" };
        for (int i = 0; i < 3; i++) {
            final int k = i;
            TextView t = Neo.text(c, names[i], Neo.TEXT, 14, Neo.ui(c)); t.setLetterSpacing(0.07f); t.setGravity(Gravity.CENTER);
            t.setPadding((int) (12 * d), 0, (int) (12 * d), 0); t.setClickable(true); t.setFocusable(true);
            t.setOnClickListener(v -> { filter = k; styleChips(); filter(); });
            LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, (int) (36 * d)); lp.rightMargin = (int) (8 * d);
            cr.addView(t, lp); chips[i] = t;
        }
        hs.addView(cr); addView(hs);
        styleChips();

        list = new ListView(c); list.setAdapter(adapter); list.setDivider(null); list.setDividerHeight(0);
        list.setSelector(new android.graphics.drawable.ColorDrawable(0)); list.setClipToPadding(false);
        list.setPadding((int) (12 * d), (int) (2 * d), (int) (12 * d), (int) (12 * d));
        list.setOnItemClickListener((p, v, pos, id) -> menu(shown.get(pos)));
        addView(list, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
    }

    private void styleChips() {
        Context c = getContext();
        for (int i = 0; i < chips.length; i++) {
            boolean on = i == filter;
            android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setCornerRadius(Theme.dp(c, 18));
            if (on) { g.setColor(Neo.CYAN); g.setStroke(Theme.dp(c, 1), Neo.CYAN); } else { g.setColor(Neo.PANEL_SOLID); g.setStroke(Theme.dp(c, 1), 0xFF22364A); }
            chips[i].setBackground(g); chips[i].setTextColor(on ? 0xFF04121A : 0xFF9FB4C8);
        }
    }

    public void setHost(Host h) { host = h; }
    public void attach(RadioService s) { svc = s; reload(); }

    public void reload() {
        if (svc == null) return;
        all.clear(); all.addAll(svc.store().contacts());
        int groups = 0; for (ChannelStore.Contact ct : all) if (ct.type != 0) groups++;
        Neo.headerSubtitle(header).setText(((all.size() - groups) + " private · " + groups + (groups == 1 ? " talkgroup" : " talkgroups")).toUpperCase(Locale.US));
        filter();
    }

    private void filter() {
        String q = search.getText().toString().trim().toLowerCase(Locale.US);
        shown.clear();
        for (ChannelStore.Contact ct : all) {
            if (filter == 1 && ct.type != 0) continue;
            if (filter == 2 && ct.type == 0) continue;
            if (q.isEmpty() || ct.name.toLowerCase(Locale.US).contains(q) || String.valueOf(ct.number).contains(q)) shown.add(ct);
        }
        adapter.notifyDataSetChanged();
    }

    /** Colour of a contact type: cyan private, violet talkgroup, amber all-call. */
    static int typeColor(int type) { return type == 1 ? Neo.VIOLET : type == 2 ? Neo.AMBER : Neo.CYAN; }

    /** Round-cornered avatar: initial for a private ID, TG for a talkgroup, ALL for all-call. */
    static TextView avatar(Context c, int type, String name, float sizeDp) {
        int col = typeColor(type);
        String label = type == 1 ? "TG" : type == 2 ? "ALL" : (name == null || name.trim().isEmpty() ? "#" : name.trim().substring(0, 1).toUpperCase(Locale.US));
        TextView t = Neo.text(c, label, col, type == 0 ? sizeDp * 0.42f : sizeDp * 0.3f, type == 0 ? Neo.display(c) : Neo.ui(c)); t.setGravity(Gravity.CENTER);
        android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setCornerRadius(Theme.dp(c, sizeDp * 0.3f));
        g.setColor(Neo.alpha(col, 0x1C)); g.setStroke(Theme.dp(c, 1), Neo.alpha(col, 0x77)); t.setBackground(g);
        return t;
    }

    private void menu(final ChannelStore.Contact ct) {
        final Context c = getContext(); float d = Theme.dp(c);
        final android.app.Dialog dlg = new android.app.Dialog(c);
        LinearLayout box = new LinearLayout(c); box.setOrientation(VERTICAL);
        box.setBackground(Neo.card(c, Neo.alpha(typeColor(ct.type), 0x77), 18)); box.setPadding((int) (18 * d), (int) (16 * d), (int) (18 * d), (int) (14 * d));
        LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
        top.addView(avatar(c, ct.type, ct.name, 48), new LayoutParams((int) (48 * d), (int) (48 * d)));
        LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setPadding((int) (12 * d), 0, 0, 0);
        col.addView(Neo.text(c, ct.name, Neo.TEXT, 20, Neo.ui(c)));
        LinearLayout l2 = new LinearLayout(c); l2.setGravity(Gravity.CENTER_VERTICAL); l2.setPadding(0, (int) (4 * d), 0, 0);
        l2.addView(Neo.chip(c, TYPES[Math.min(2, Math.max(0, ct.type))], typeColor(ct.type)));
        TextView idv = Neo.text(c, String.valueOf(ct.number), Neo.TEXT_SOFT, 15, Neo.mono(c)); idv.setPadding((int) (8 * d), 0, 0, 0); l2.addView(idv);
        col.addView(l2);
        top.addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        box.addView(top);
        LinearLayout btns = new LinearLayout(c); btns.setBaselineAligned(false);
        String[] names = { "Message", "Edit", "Delete" }; int[] accents = { Neo.GREEN, Neo.CYAN, Neo.RED };
        for (int i = 0; i < 3; i++) {
            final int k = i;
            TextView b = Neo.button(c, names[i], null, accents[i]); b.setTextSize(14);
            LayoutParams lp = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (16 * d), (int) (3 * d), 0);
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
        final EditText name = new EditText(c); name.setHint("Name"); name.setText(ct.name); name.setTextColor(Neo.TEXT); name.setTypeface(Neo.uiSemi(c)); box.addView(name);
        final EditText num = new EditText(c); num.setHint("DMR ID or talkgroup"); num.setInputType(InputType.TYPE_CLASS_NUMBER); if (ct.number > 0) num.setText(String.valueOf(ct.number)); num.setTextColor(Neo.TEXT); num.setTypeface(Neo.mono(c)); box.addView(num);
        LinearLayout types = new LinearLayout(c); types.setBaselineAligned(false);
        final int[] t = { Math.min(2, Math.max(0, ct.type)) };
        final TextView[] tb = new TextView[3];
        for (int i = 0; i < 3; i++) {
            final int k = i;
            tb[i] = Neo.button(c, TYPES[i], null, typeColor(i)); tb[i].setTextSize(14);
            LayoutParams lp = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); lp.setMargins(i == 0 ? 0 : (int) (3 * d), (int) (12 * d), i == 2 ? 0 : (int) (3 * d), 0);
            types.addView(tb[i], lp);
            tb[i].setOnClickListener(v -> { t[0] = k; for (int j = 0; j < 3; j++) tb[j].setAlpha(j == k ? 1f : 0.45f); });
        }
        for (int j = 0; j < 3; j++) tb[j].setAlpha(j == t[0] ? 1f : 0.45f);
        box.addView(types);
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
            if (v == null) {
                LinearLayout outer = new LinearLayout(c); outer.setPadding(0, (int) (3 * d), 0, (int) (3 * d));
                LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL); row.setTag("row");
                row.setPadding((int) (10 * d), 0, (int) (4 * d), 0); row.setMinimumHeight((int) (68 * d));
                android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setColor(0xBF0B1622); g.setCornerRadius(14 * d); g.setStroke((int) d, 0xFF142536);
                row.setBackground(g);
                LinearLayout av = new LinearLayout(c); av.setTag("av");
                row.addView(av, new LayoutParams((int) (46 * d), (int) (46 * d)));
                LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setPadding((int) (12 * d), 0, 0, 0);
                TextView name = Neo.text(c, "", Neo.TEXT, 18, Neo.ui(c)); name.setSingleLine(true); name.setEllipsize(android.text.TextUtils.TruncateAt.END); name.setTag("name");
                col.addView(name);
                LinearLayout l2 = new LinearLayout(c); l2.setGravity(Gravity.CENTER_VERTICAL); l2.setPadding(0, (int) (4 * d), 0, 0); l2.setTag("l2");
                col.addView(l2);
                row.addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
                ImageView msg = new ImageView(c); msg.setTag("msg"); msg.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
                int sp = (int) (12 * d); msg.setPadding(sp, sp, sp, sp); msg.setClickable(true); msg.setContentDescription("Message");
                msg.setImageDrawable(new Neo.IconDrawable("messages", Neo.GREEN));
                row.addView(msg, new LayoutParams((int) (44 * d), (int) (44 * d)));
                outer.addView(row, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
                outer.setLayoutParams(new ListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                v = outer;
            }
            final ChannelStore.Contact ct = shown.get(i);
            LinearLayout row = v.findViewWithTag("row");
            LinearLayout av = row.findViewWithTag("av"); av.removeAllViews();
            av.addView(avatar(c, ct.type, ct.name, 46), new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
            ((TextView) row.findViewWithTag("name")).setText(ct.name);
            LinearLayout l2 = row.findViewWithTag("l2"); l2.removeAllViews();
            l2.addView(Neo.chip(c, TYPES[Math.min(2, Math.max(0, ct.type))], typeColor(ct.type)));
            TextView idv = Neo.text(c, String.valueOf(ct.number), Neo.TEXT_SOFT, 15, Neo.mono(c)); idv.setPadding((int) (8 * d), 0, 0, 0); l2.addView(idv);
            row.findViewWithTag("msg").setOnClickListener(x -> { if (host != null) host.openThread(ct); });
            return v;
        }
    }
}
