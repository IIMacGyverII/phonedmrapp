package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.text.InputType;
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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * DMR text messages. Conversation list (one per peer: DMR ID or talkgroup) and a thread view with
 * bubbles and a compose box. Sending uses the module's 0x2C command; incoming texts arrive through the
 * service (status 5 → fetch 0x2D).
 */
public class MessagesView extends LinearLayout implements RadioService.Listener {
    private final FrameLayout content;
    private final LinearLayout listPage;
    private final ListView list;
    private final ConvAdapter convAdapter = new ConvAdapter();
    private final List<ChannelStore.Conversation> convs = new ArrayList<>();
    private RadioService svc;
    private TextView empty;
    private LinearLayout threadPage;
    private ListView threadList;
    private ThreadAdapter threadAdapter;
    private ChannelStore.Contact peer;
    private final List<ChannelStore.Message> msgs = new ArrayList<>();
    private final SimpleDateFormat tf = new SimpleDateFormat("HH:mm", java.util.Locale.US), df = new SimpleDateFormat("MMM d HH:mm", java.util.Locale.US);

    public MessagesView(Context c) {
        super(c);
        setOrientation(VERTICAL); setBackgroundColor(Theme.BG);
        float d = Theme.dp(c);
        content = new FrameLayout(c);
        listPage = new LinearLayout(c); listPage.setOrientation(VERTICAL);
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (20 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        bar.addView(Theme.label(c, "Messages", Theme.WHITE, 24, false), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        TextView add = Theme.label(c, "+", Theme.WHITE, 34, false); add.setPadding((int) (10 * d), 0, 0, 0); add.setClickable(true);
        add.setOnClickListener(v -> newMessage());
        bar.addView(add);
        listPage.addView(bar);
        list = new ListView(c); list.setAdapter(convAdapter); list.setDivider(null); list.setDividerHeight(0);
        list.setOnItemClickListener((p, v, pos, id) -> { ChannelStore.Conversation cv = convs.get(pos); ChannelStore.Contact ct = new ChannelStore.Contact(); ct.name = cv.name; ct.number = cv.peer; ct.type = cv.type; openThread(ct); });
        empty = Theme.label(c, "No messages yet.\n\nTap + to write to a contact or to the current channel's call target. Texts only work on DMR channels.", 0xFF6F7F8F, 15, false);
        empty.setGravity(Gravity.CENTER); empty.setPadding((int) (32 * d), (int) (80 * d), (int) (32 * d), 0);
        listPage.addView(empty);
        listPage.addView(list, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
        content.addView(listPage);
        addView(content, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
    }

    public void attach(RadioService s) { svc = s; s.addListener(this); reload(); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    public void reload() { if (svc == null) return; convs.clear(); convs.addAll(svc.store().conversations()); convAdapter.notifyDataSetChanged(); if (empty != null) empty.setVisibility(convs.isEmpty() ? VISIBLE : GONE); }

    public boolean back() { if (threadPage != null) { content.removeView(threadPage); threadPage = null; peer = null; reload(); return true; } return false; }

    private void newMessage() {
        final Context c = getContext(); float d = Theme.dp(c);
        final List<ChannelStore.Contact> cts = svc.store().contacts();
        String[] names = new String[cts.size() + 1]; names[0] = "Current channel's call target";
        for (int i = 0; i < cts.size(); i++) names[i + 1] = cts.get(i).name + "  (" + cts.get(i).number + ")";
        new android.app.AlertDialog.Builder(c).setTitle("Message to").setItems(names, (dd, w) -> {
            ChannelStore.Contact ct;
            if (w == 0) { ChannelStore.Channel ch = svc.current(); if (ch == null || ch.txContact <= 0) { android.widget.Toast.makeText(c, "Current channel has no call target", android.widget.Toast.LENGTH_LONG).show(); return; }
                ct = new ChannelStore.Contact(); ct.number = ch.txContact; ct.type = ch.contactType; ct.name = svc.store().contactName(ch.txContact, ch.contactType); }
            else ct = cts.get(w - 1);
            openThread(ct);
        }).show();
    }

    public void openThread(ChannelStore.Contact ct) {
        final Context c = getContext(); float d = Theme.dp(c);
        peer = ct;
        if (threadPage != null) content.removeView(threadPage);
        threadPage = new LinearLayout(c); threadPage.setOrientation(VERTICAL); threadPage.setBackgroundColor(Theme.BG);
        LinearLayout bar = new LinearLayout(c); bar.setBackgroundColor(Theme.TITLE_BG); bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding((int) (12 * d), (int) (4 * d), (int) (16 * d), (int) (4 * d));
        TextView back = Theme.label(c, "‹", Theme.WHITE, 34, false); back.setPadding(0, 0, (int) (14 * d), 0); back.setClickable(true); back.setOnClickListener(v -> back());
        bar.addView(back);
        bar.addView(Theme.label(c, (ct.name == null || ct.name.isEmpty() ? "" : ct.name + "  ") + (ct.type == 1 ? "TG " : ct.type == 2 ? "All " : "ID ") + ct.number, Theme.WHITE, 20, false), new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        threadPage.addView(bar);
        threadList = new ListView(c); threadAdapter = new ThreadAdapter(); threadList.setAdapter(threadAdapter); threadList.setDivider(null); threadList.setDividerHeight(0);
        threadList.setTranscriptMode(ListView.TRANSCRIPT_MODE_ALWAYS_SCROLL); threadList.setStackFromBottom(true);
        threadPage.addView(threadList, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
        LinearLayout compose = new LinearLayout(c); compose.setGravity(Gravity.CENTER_VERTICAL); compose.setPadding((int) (10 * d), (int) (6 * d), (int) (10 * d), (int) (8 * d)); compose.setBackgroundColor(Theme.TITLE_BG);
        final EditText input = new EditText(c); input.setHint("Message"); input.setTextColor(Theme.WHITE); input.setHintTextColor(0xFF8899AA); input.setTextSize(15);
        input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES | InputType.TYPE_TEXT_FLAG_MULTI_LINE); input.setMaxLines(3);
        input.setBackground(Theme.rounded(c, 0x22FFFFFF, 0, 0, 20)); input.setPadding((int) (14 * d), (int) (8 * d), (int) (14 * d), (int) (8 * d));
        TextView quick = Theme.label(c, "\u26A1", Theme.VFO[3], 18, true); quick.setGravity(Gravity.CENTER); quick.setBackground(Theme.rounded(c, Theme.VFO[0], Theme.VFO[2], 1, 20));
        quick.setPadding((int) (10 * d), (int) (8 * d), (int) (10 * d), (int) (8 * d)); quick.setClickable(true);
        LayoutParams ql = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); ql.rightMargin = (int) (8 * d);
        compose.addView(quick, ql);
        quick.setOnClickListener(v -> quickReplies(input));
        compose.addView(input, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        TextView send = Theme.label(c, "Send", Theme.PKT[3], 15, true); send.setGravity(Gravity.CENTER); send.setBackground(Theme.rounded(c, Theme.PKT[0], Theme.PKT[2], 2, 20));
        send.setPadding((int) (18 * d), (int) (10 * d), (int) (18 * d), (int) (10 * d)); send.setClickable(true);
        LayoutParams sl = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); sl.leftMargin = (int) (8 * d);
        compose.addView(send, sl);
        send.setOnClickListener(v -> {
            String t = input.getText().toString().trim();
            if (t.isEmpty() || svc == null) return;
            if (!svc.current().isDigital()) { android.widget.Toast.makeText(c, "Switch to a DMR channel to send text", android.widget.Toast.LENGTH_LONG).show(); return; }
            input.setText("");
            svc.sendSms(peer, t);
            loadThread();
        });
        threadPage.addView(compose);
        content.addView(threadPage);
        loadThread();
    }

    private void loadThread() {
        if (peer == null || svc == null) return;
        msgs.clear(); msgs.addAll(svc.store().messages(peer.number, peer.type)); threadAdapter.notifyDataSetChanged();
    }

    private final class ConvAdapter extends BaseAdapter {
        @Override public int getCount() { return convs.size(); } @Override public Object getItem(int i) { return convs.get(i); } @Override public long getItemId(int i) { return i; }
        @Override public View getView(int i, View v, ViewGroup parent) {
            Context c = getContext(); float d = Theme.dp(c);
            FrameLayout row; TextView icon, name, last, time;
            if (v == null) {
                row = new FrameLayout(c); row.setLayoutParams(new ListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, (int) (68 * d)));
                icon = Theme.label(c, "", Theme.WHITE, 16, true); icon.setGravity(Gravity.CENTER); icon.setTag("icon"); icon.setBackground(Theme.rounded(c, 0xFF1A3680, Theme.CYAN, 1, 22));
                FrameLayout.LayoutParams il = new FrameLayout.LayoutParams((int) (44 * d), (int) (44 * d), Gravity.START | Gravity.CENTER_VERTICAL); il.leftMargin = (int) (16 * d); row.addView(icon, il);
                LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setGravity(Gravity.CENTER_VERTICAL); col.setPadding((int) (74 * d), 0, (int) (90 * d), 0);
                name = Theme.label(c, "", Theme.WHITE, 17, false); name.setSingleLine(true); name.setTag("name");
                last = Theme.label(c, "", 0xFF9AA4AE, 13, false); last.setSingleLine(true); last.setEllipsize(android.text.TextUtils.TruncateAt.END); last.setTag("last");
                col.addView(name); col.addView(last); row.addView(col, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
                time = Theme.label(c, "", 0xFF6F7F8F, 12, false); time.setTag("time");
                FrameLayout.LayoutParams tl = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT, Gravity.END | Gravity.TOP); tl.rightMargin = (int) (16 * d); tl.topMargin = (int) (12 * d); row.addView(time, tl);
                View line = new View(c); line.setBackgroundColor(0xFF1C2A3A); row.addView(line, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, 1, Gravity.BOTTOM));
            } else { row = (FrameLayout) v; icon = row.findViewWithTag("icon"); name = row.findViewWithTag("name"); last = row.findViewWithTag("last"); time = row.findViewWithTag("time"); }
            ChannelStore.Conversation cv = convs.get(i);
            icon.setText(cv.type == 1 ? "TG" : cv.type == 2 ? "ALL" : "ID");
            name.setText((cv.name == null || cv.name.isEmpty() ? "" : cv.name + "  ") + cv.peer); last.setText((cv.outgoing ? "You: " : "") + cv.lastText); time.setText(df.format(new Date(cv.lastTs)));
            return row;
        }
    }

    private static final String DEFAULT_QUICK = "QSL\nCopy, I will call you back\nOn my way\nWhere are you?\nSwitch to the other channel\nAll OK here";
    private java.util.List<String> quickList() {
        java.util.List<String> out = new java.util.ArrayList<>();
        for (String s : getContext().getSharedPreferences("radio", Context.MODE_PRIVATE).getString("quickReplies", DEFAULT_QUICK).split("\n")) if (!s.trim().isEmpty()) out.add(s.trim());
        return out;
    }
    /** Canned texts: one tap fills the composer; the last entry edits the list. */
    private void quickReplies(final EditText input) {
        final java.util.List<String> q = quickList();
        String[] items = new String[q.size() + 1]; for (int i = 0; i < q.size(); i++) items[i] = q.get(i); items[q.size()] = "\u270F\uFE0F Edit quick replies\u2026";
        new android.app.AlertDialog.Builder(getContext()).setTitle("Quick replies").setItems(items, (d2, w) -> {
            if (w < q.size()) { input.setText(q.get(w)); input.setSelection(input.getText().length()); return; }
            final EditText et = new EditText(getContext()); et.setText(String.join("\n", q)); et.setMinLines(5);
            et.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES);
            new android.app.AlertDialog.Builder(getContext()).setTitle("Quick replies").setMessage("One message per line.").setView(et)
                    .setPositiveButton("Save", (d3, w3) -> getContext().getSharedPreferences("radio", Context.MODE_PRIVATE).edit().putString("quickReplies", et.getText().toString()).apply())
                    .setNegativeButton("Cancel", null).show();
        }).show();
    }

    private final class ThreadAdapter extends BaseAdapter {
        @Override public int getCount() { return msgs.size(); } @Override public Object getItem(int i) { return msgs.get(i); } @Override public long getItemId(int i) { return msgs.get(i).id; }
        @Override public View getView(int i, View v, ViewGroup parent) {
            Context c = getContext(); float d = Theme.dp(c);
            ChannelStore.Message m = msgs.get(i);
            LinearLayout row = new LinearLayout(c); row.setOrientation(VERTICAL); row.setGravity(m.outgoing ? Gravity.END : Gravity.START);
            row.setPadding((int) (12 * d), (int) (4 * d), (int) (12 * d), (int) (4 * d));
            TextView b = Theme.label(c, m.text, Theme.WHITE, 15, false); b.setMaxWidth((int) (260 * d));
            b.setBackground(Theme.rounded(c, m.outgoing ? 0xFF0D3D47 : 0xFF1A2432, m.outgoing ? 0xFF00BCD4 : 0x5500BFFF, 1, 16)); b.setPadding((int) (14 * d), (int) (9 * d), (int) (14 * d), (int) (9 * d));
            row.addView(b);
            row.addView(Theme.label(c, tf.format(new Date(m.ts)) + (m.outgoing ? (m.status == 1 ? "  ✓" : m.status == 2 ? "  ✖ failed" : "  …") : ""), 0xFF6F7F8F, 11, false));
            return row;
        }
    }

    // RadioService.Listener
    @Override public void onSms(int from, int type, String text) { if (peer != null && peer.number == from) loadThread(); else reload(); }
    @Override public void onSmsResult(boolean ok) { loadThread(); reload(); }
    @Override public void onChannel(ChannelStore.Channel ch) { } @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { } @Override public void onLog(String s) { }
    @Override public void onLink(String s) { } @Override public void onLocation(String t) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f2, boolean g, String z) { }
    @Override public void onCaption(boolean en, String live, String sentence) { }
}
