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
 * Channel page: header with zone and channel count (repeaters, zone and add actions), search field, filter
 * chips (All / Favourites / Analog / DMR), and card rows — channel number tile, name, frequency in MHz,
 * mode badge, the one detail that matters (colour code and slot, tone, repeater shift), a star that toggles
 * the Favourites zone, and a glowing frame plus ON AIR on the active channel. Tap a row for Use / Edit /
 * Star / Delete.
 */
public class ChannelsView extends LinearLayout implements RadioService.Listener {
    public interface Host { void openEditor(ChannelStore.Channel ch, boolean isNew); }

    private final ListView list;
    private final Adapter adapter = new Adapter();
    private final EditText search;
    private final LinearLayout header;
    private final TextView[] chips = new TextView[4];
    private final List<ChannelStore.Channel> all = new ArrayList<>(), shown = new ArrayList<>();
    private final java.util.Set<Integer> favs = new java.util.HashSet<>();
    private RadioService svc;
    private Host host;
    private int filter = 0;              // 0 all, 1 favourites, 2 analog, 3 DMR
    private int activeNumber = -1;

    public ChannelsView(Context c) {
        super(c);
        setOrientation(VERTICAL);   // background: the window's
        float d = Theme.dp(c);

        header = Neo.header(c, "Channels", "");
        ImageView nearby = Neo.iconButton(c, "repeaters", Neo.CYAN, "Nearby repeaters");
        nearby.setOnClickListener(v -> { if (svc != null) RepeatersDialog.show(c, svc); });
        ImageView zone = Neo.iconButton(c, "zone", Neo.CYAN, "Choose zone");
        zone.setOnClickListener(v -> pickZone());
        ImageView add = Neo.iconButton(c, "plus", Neo.GREEN, "Add channel");
        add.setOnClickListener(v -> { if (host != null) host.openEditor(null, true); });
        Neo.addAction(header, nearby); Neo.addAction(header, zone); Neo.addAction(header, add);
        addView(header);

        // search field with a line icon
        LinearLayout sf = new LinearLayout(c); sf.setGravity(Gravity.CENTER_VERTICAL);
        sf.setBackground(Neo.card(c, Neo.alpha(Neo.CYAN, 0x33), 12)); sf.setPadding((int) (14 * d), 0, (int) (10 * d), 0);
        ImageView si = new ImageView(c); si.setImageDrawable(new Neo.IconDrawable("search", Neo.MUTED));
        sf.addView(si, new LayoutParams((int) (18 * d), (int) (18 * d)));
        search = new EditText(c); search.setHint("Name, frequency or number"); search.setSingleLine(true);
        search.setTextSize(16); search.setTypeface(Neo.uiSemi(c)); search.setTextColor(Neo.TEXT); search.setHintTextColor(Neo.DIM);
        search.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        search.setBackground(null); search.setPadding((int) (10 * d), 0, 0, 0);
        search.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int a, int b, int n) { } @Override public void onTextChanged(CharSequence s, int a, int b, int n) { }
            @Override public void afterTextChanged(Editable e) { filter(); }
        });
        sf.addView(search, new LayoutParams(0, (int) (44 * d), 1f));
        LayoutParams sfl = new LayoutParams(LayoutParams.MATCH_PARENT, (int) (46 * d)); sfl.setMargins((int) (16 * d), (int) (10 * d), (int) (16 * d), 0);
        addView(sf, sfl);

        // filter chips
        HorizontalScrollView hs = new HorizontalScrollView(c); hs.setHorizontalScrollBarEnabled(false);
        LinearLayout cr = new LinearLayout(c); cr.setPadding((int) (16 * d), (int) (10 * d), (int) (16 * d), (int) (8 * d));
        String[] names = { "ALL", "★ FAVOURITES", "ANALOG", "DMR" };
        for (int i = 0; i < 4; i++) {
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
        list.setOnItemClickListener((p, v, pos, id) -> showRowMenu(shown.get(pos)));
        addView(list, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
    }

    private void styleChips() {
        Context c = getContext();
        for (int i = 0; i < 4; i++) {
            boolean on = i == filter;
            android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setCornerRadius(Theme.dp(c, 18));
            if (on) { g.setColor(Neo.CYAN); g.setStroke(Theme.dp(c, 1), Neo.CYAN); } else { g.setColor(Neo.PANEL_SOLID); g.setStroke(Theme.dp(c, 1), 0xFF22364A); }
            chips[i].setBackground(g); chips[i].setTextColor(on ? 0xFF04121A : 0xFF9FB4C8);
        }
    }

    public void setHost(Host h) { host = h; }
    public void attach(RadioService s) { svc = s; s.addListener(this); reload(); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    public void reload() {
        if (svc == null) return;
        all.clear(); all.addAll(svc.zoneChannels());
        favs.clear(); ChannelStore.Zone fz = favZone(); if (fz != null) for (int n : fz.numbers) favs.add(n);
        activeNumber = svc.current() != null ? svc.current().number : svc.store().activeNumber();
        Neo.headerSubtitle(header).setText(("Zone " + svc.zoneName() + " · " + all.size() + (all.size() == 1 ? " channel" : " channels")).toUpperCase(Locale.US));
        filter();
    }

    private void filter() {
        String q = search.getText().toString().trim().toLowerCase(Locale.US), qd = q.replaceAll("[^0-9]", "");
        shown.clear();
        for (ChannelStore.Channel ch : all) {
            if (filter == 1 && !favs.contains(ch.number)) continue;
            if (filter == 2 && ch.isDigital()) continue;
            if (filter == 3 && !ch.isDigital()) continue;
            if (!q.isEmpty()) {
                boolean ok = ch.name != null && ch.name.toLowerCase(Locale.US).contains(q);
                if (!ok && !qd.isEmpty()) ok = String.valueOf(ch.number).equals(qd) || String.valueOf(ch.txFreq).startsWith(qd) || String.valueOf(ch.rxFreq).startsWith(qd);
                if (!ok) continue;
            }
            shown.add(ch);
        }
        adapter.notifyDataSetChanged();
    }

    private void pickZone() {
        if (svc == null) return;
        final java.util.List<ChannelStore.Zone> zones = svc.store().zones();
        String[] names = new String[zones.size() + 1]; names[0] = "ALL channels";
        for (int i = 0; i < zones.size(); i++) names[i + 1] = zones.get(i).name + "  (" + zones.get(i).numbers.length + ")";
        new android.app.AlertDialog.Builder(getContext()).setTitle("Zone").setItems(names, (d2, w) -> { svc.setZone(w == 0 ? 0 : zones.get(w - 1).id); reload(); }).show();
    }

    static String mhz(int hz) { return String.format(Locale.US, "%.4f", hz / 1e6); }

    /** The one extra detail worth a badge: colour code + slot on DMR, else repeater shift and/or tone. */
    static String detail(ChannelStore.Channel ch) {
        if (ch.isDigital()) return "CC" + ch.cc + " · TS" + (ch.inSlot + 1);
        List<String> parts = new ArrayList<>();
        int shift = ch.txFreq - ch.rxFreq;
        if (ch.rxFreq >= 162_400_000 && ch.rxFreq <= 162_550_000) parts.add("WX · RX ONLY");
        else if (Math.abs(shift) >= 100_000) parts.add((shift > 0 ? "+" : "−") + String.format(Locale.US, "%s MHz", trim(Math.abs(shift) / 1e6)));
        if (ch.rxType == 1 && com.macdmr.radio.dsp.ToneTable.ctcssHz(ch.rxSubCode) > 0) parts.add(String.format(Locale.US, "%.1f", com.macdmr.radio.dsp.ToneTable.ctcssHz(ch.rxSubCode)));
        else if (ch.rxType == 2) parts.add(String.format(Locale.US, "D%03oN", ch.rxSubCode));
        StringBuilder sb = new StringBuilder(); for (String p : parts) { if (sb.length() > 0) sb.append(" · "); sb.append(p); }
        return sb.toString();
    }
    private static String trim(double v) { String s = String.format(Locale.US, "%.3f", v); return s.replaceAll("0+$", "").replaceAll("\\.$", ""); }

    private void showRowMenu(final ChannelStore.Channel ch) {
        final Context c = getContext();
        final android.app.Dialog dlg = new android.app.Dialog(c);
        LinearLayout box = new LinearLayout(c); box.setOrientation(VERTICAL);
        float d = Theme.dp(c);
        box.setBackground(Neo.sheet(c, Neo.alpha(Neo.CYAN, 0x88), 18)); box.setPadding((int) (18 * d), (int) (16 * d), (int) (18 * d), (int) (14 * d));
        LinearLayout top = new LinearLayout(c); top.setGravity(Gravity.CENTER_VERTICAL);
        TextView num = numberTile(c, ch.number, ch.number == activeNumber);
        top.addView(num, new LayoutParams((int) (46 * d), (int) (46 * d)));
        LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setPadding((int) (12 * d), 0, 0, 0);
        TextView t = Neo.text(c, label(ch), Neo.TEXT, 20, Neo.ui(c)); col.addView(t);
        TextView sub = Neo.text(c, mhz(ch.rxFreq) + (ch.txFreq != ch.rxFreq ? " / " + mhz(ch.txFreq) : "") + " MHz", Neo.TEXT_SOFT, 15, Neo.mono(c)); sub.setPadding(0, (int) (4 * d), 0, 0); col.addView(sub);
        top.addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        box.addView(top);
        LinearLayout badges = new LinearLayout(c); badges.setPadding(0, (int) (10 * d), 0, 0);
        badges.addView(Neo.chip(c, ch.isDigital() ? "DMR" : "FM", ch.isDigital() ? Neo.VIOLET : Neo.CYAN));
        String det = ch.isDigital() ? "CC" + ch.cc + " · TS" + (ch.inSlot + 1) + " · →" + ch.txContact : "SQ " + ch.sq + " · " + (ch.band == 1 ? "WIDE" : "NARROW") + (detail(ch).isEmpty() ? "" : " · " + detail(ch));
        TextView dc = Neo.chip(c, det, 0xFF9FB4C8); LayoutParams dl = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); dl.leftMargin = (int) (6 * d);
        badges.addView(dc, dl);
        box.addView(badges);
        LinearLayout btns = new LinearLayout(c); btns.setBaselineAligned(false);
        final boolean fav = favs.contains(ch.number);
        String[] names = { "Use", "Edit", fav ? "Unstar" : "Star", "Delete" };
        int[] accents = { Neo.GREEN, Neo.CYAN, Neo.AMBER, Neo.RED };
        for (int i = 0; i < 4; i++) {
            final int k = i;
            TextView b = Neo.button(c, names[i], null, accents[i]); b.setTextSize(14);
            LayoutParams lp = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (16 * d), (int) (3 * d), 0);
            btns.addView(b, lp);
            b.setOnClickListener(v -> {
                dlg.dismiss();
                if (k == 0 && svc != null) svc.selectChannel(ch.number);
                else if (k == 1 && host != null) host.openEditor(ch, false);
                else if (k == 2) toggleFavourite(ch, !fav);
                else if (k == 3) confirmDelete(ch);
            });
        }
        box.addView(btns);
        dlg.setContentView(box);
        if (dlg.getWindow() != null) dlg.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0));
        dlg.show();
    }

    private static String label(ChannelStore.Channel ch) { return ch.name == null || ch.name.isEmpty() ? (ch.isDigital() ? "Digital " : "Analog ") + ch.number : ch.name; }

    private static TextView numberTile(Context c, int number, boolean active) {
        TextView n = Neo.text(c, String.format(Locale.US, "%02d", number % 100), active ? Neo.CYAN : 0xFF6FA9C0, 18, Neo.display(c)); n.setGravity(Gravity.CENTER);
        android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setCornerRadius(Theme.dp(c, 12)); g.setColor(active ? 0xFF06202E : 0xFF0A1826);
        n.setBackground(g);
        return n;
    }

    public static final String FAV_ZONE = "★ Favourites";
    private ChannelStore.Zone favZone() { if (svc == null) return null; for (ChannelStore.Zone z : svc.store().zones()) if (FAV_ZONE.equals(z.name)) return z; return null; }
    /** Starred channels live in a "★ Favourites" zone, so they work with the zone picker, stepping and scanning. */
    private void toggleFavourite(ChannelStore.Channel ch, boolean on) {
        if (svc == null) return;
        ChannelStore.Zone z = favZone();
        if (z == null) { if (!on) return; z = new ChannelStore.Zone(); z.name = FAV_ZONE; z.numbers = new int[0]; }
        java.util.List<Integer> nums = new java.util.ArrayList<>(); for (int n : z.numbers) if (n != ch.number) nums.add(n);
        if (on) nums.add(ch.number);
        z.numbers = new int[nums.size()]; for (int i = 0; i < nums.size(); i++) z.numbers[i] = nums.get(i);
        svc.store().saveZone(z);
        android.widget.Toast.makeText(getContext(), on ? "Starred: " + ch.name + " is in the ★ Favourites zone" : "Removed from ★ Favourites", android.widget.Toast.LENGTH_SHORT).show();
        reload();
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
            LinearLayout row;
            if (v == null) {
                LinearLayout outer = new LinearLayout(c); outer.setPadding(0, (int) (3 * d), 0, (int) (3 * d));
                row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL); row.setTag("row");
                row.setPadding((int) (10 * d), 0, (int) (4 * d), 0); row.setMinimumHeight((int) (68 * d));
                TextView num = Neo.text(c, "", Neo.CYAN, 18, Neo.display(c)); num.setGravity(Gravity.CENTER); num.setTag("num");
                row.addView(num, new LayoutParams((int) (46 * d), (int) (46 * d)));
                LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setPadding((int) (12 * d), 0, 0, 0);
                LinearLayout l1 = new LinearLayout(c); l1.setGravity(Gravity.CENTER_VERTICAL);
                TextView name = Neo.text(c, "", Neo.TEXT, 18, Neo.ui(c)); name.setSingleLine(true); name.setEllipsize(android.text.TextUtils.TruncateAt.END); name.setTag("name");
                l1.addView(name, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
                TextView air = Neo.text(c, "ON AIR", 0xFF04121A, 10.5f, Neo.ui(c)); air.setLetterSpacing(0.14f); air.setTag("air");
                android.graphics.drawable.GradientDrawable ag = new android.graphics.drawable.GradientDrawable(); ag.setColor(Neo.CYAN); ag.setCornerRadius(5 * d);
                air.setBackground(ag); air.setPadding((int) (6 * d), (int) (2 * d), (int) (6 * d), (int) (2 * d));
                LayoutParams al = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); al.leftMargin = (int) (6 * d);
                l1.addView(air, al);
                col.addView(l1);
                LinearLayout l2 = new LinearLayout(c); l2.setGravity(Gravity.CENTER_VERTICAL); l2.setPadding(0, (int) (4 * d), 0, 0);
                TextView freq = Neo.text(c, "", Neo.TEXT_SOFT, 15, Neo.mono(c)); freq.setTag("freq"); l2.addView(freq);
                LinearLayout badges = new LinearLayout(c); badges.setTag("badges"); badges.setGravity(Gravity.CENTER_VERTICAL);
                LayoutParams bl = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); bl.leftMargin = (int) (6 * d);
                l2.addView(badges, bl);
                col.addView(l2);
                row.addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
                ImageView star = new ImageView(c); star.setTag("star"); star.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
                int sp = (int) (12 * d); star.setPadding(sp, sp, sp, sp); star.setClickable(true); star.setContentDescription("Favourite");
                row.addView(star, new LayoutParams((int) (44 * d), (int) (44 * d)));
                outer.addView(row, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
                outer.setLayoutParams(new ListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                v = outer;
            }
            row = v.findViewWithTag("row");
            final ChannelStore.Channel ch = shown.get(i);
            boolean active = ch.number == activeNumber, fav = favs.contains(ch.number);
            if (active) {
                android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(android.graphics.drawable.GradientDrawable.Orientation.LEFT_RIGHT, new int[] { 0x2919D3FF, 0x0819D3FF });
                g.setCornerRadius(14 * d); g.setStroke((int) (1.5f * d), Neo.CYAN); row.setBackground(g);
            } else {
                android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setColor(0xBF0B1622); g.setCornerRadius(14 * d); g.setStroke((int) d, 0xFF142536);
                row.setBackground(g);
            }
            TextView num = row.findViewWithTag("num");
            num.setText(String.format(Locale.US, "%02d", ch.number % 100)); num.setTextColor(active ? Neo.CYAN : 0xFF6FA9C0);
            android.graphics.drawable.GradientDrawable ng = new android.graphics.drawable.GradientDrawable(); ng.setCornerRadius(12 * d); ng.setColor(active ? 0xFF06202E : 0xFF0A1826); num.setBackground(ng);
            ((TextView) row.findViewWithTag("name")).setText(label(ch));
            row.findViewWithTag("air").setVisibility(active ? VISIBLE : GONE);
            ((TextView) row.findViewWithTag("freq")).setText(mhz(ch.rxFreq));
            LinearLayout badges = row.findViewWithTag("badges"); badges.removeAllViews();
            badges.addView(Neo.chip(c, ch.isDigital() ? "DMR" : "FM", ch.isDigital() ? Neo.VIOLET : Neo.CYAN));
            String det = detail(ch);
            if (!det.isEmpty()) { TextView dc = Neo.chip(c, det, 0xFF9FB4C8); LayoutParams dl = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); dl.leftMargin = (int) (6 * d); badges.addView(dc, dl); }
            ImageView star = row.findViewWithTag("star");
            star.setImageDrawable(new Neo.IconDrawable("star", fav ? Neo.AMBER : Neo.OFF, fav));
            star.setOnClickListener(x -> toggleFavourite(ch, !fav));
            return v;
        }
    }

    // RadioService.Listener
    @Override public void onChannel(ChannelStore.Channel ch) { activeNumber = ch.number; adapter.notifyDataSetChanged(); }
    @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { }
    @Override public void onLog(String s) { } @Override public void onLink(String s) { } @Override public void onLocation(String t) { } @Override public void onSms(int f, int ty, String te) { } @Override public void onSmsResult(boolean ok) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f, boolean g, String z) { }
    @Override public void onCaption(boolean en, String live, String sentence) { }
}
