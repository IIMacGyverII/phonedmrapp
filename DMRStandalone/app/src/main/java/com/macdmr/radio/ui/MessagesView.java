package com.macdmr.radio.ui;

import android.content.Context;
import android.text.InputType;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
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
 * DMR text messages. Conversation cards (one per peer: DMR ID or talkgroup) with avatar, last text, time and
 * delivery mark; an illustrated empty state; a thread view with bubbles (yours right, theirs left), coloured
 * delivery status, quick replies and a send button, and a note when the current channel cannot carry text.
 * Sending uses the module's 0x2C command; incoming texts arrive through the service (status 5 → fetch 0x2D).
 */
public class MessagesView extends LinearLayout implements RadioService.Listener {
    private final FrameLayout content;
    private final LinearLayout listPage, header;
    private final ListView list;
    private final ConvAdapter convAdapter = new ConvAdapter();
    private final List<ChannelStore.Conversation> convs = new ArrayList<>();
    private RadioService svc;
    private final LinearLayout empty;
    private LinearLayout threadPage;
    private ListView threadList;
    private ThreadAdapter threadAdapter;
    private TextView analogNote;
    private ChannelStore.Contact peer;
    private final List<ChannelStore.Message> msgs = new ArrayList<>();
    private final SimpleDateFormat tf = new SimpleDateFormat("HH:mm", java.util.Locale.US), df = new SimpleDateFormat("MMM d  HH:mm", java.util.Locale.US);

    public MessagesView(Context c) {
        super(c);
        setOrientation(VERTICAL);   // background: the window's (the thread page, an overlay, keeps its own)
        float d = Theme.dp(c);
        content = new FrameLayout(c);
        listPage = new LinearLayout(c); listPage.setOrientation(VERTICAL);
        header = Neo.header(c, "Messages", "DMR text");
        ImageView add = Neo.iconButton(c, "plus", Neo.GREEN, "New message");
        add.setOnClickListener(v -> newMessage());
        Neo.addAction(header, add);
        listPage.addView(header);
        list = new ListView(c); list.setAdapter(convAdapter); list.setDivider(null); list.setDividerHeight(0);
        list.setSelector(new android.graphics.drawable.ColorDrawable(0)); list.setClipToPadding(false);
        list.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (12 * d));
        list.setOnItemClickListener((p, v, pos, id) -> { ChannelStore.Conversation cv = convs.get(pos); ChannelStore.Contact ct = new ChannelStore.Contact(); ct.name = cv.name; ct.number = cv.peer; ct.type = cv.type; openThread(ct); });

        // empty state: glowing icon, title, how-to, button
        empty = new LinearLayout(c); empty.setOrientation(VERTICAL); empty.setGravity(Gravity.CENTER_HORIZONTAL); empty.setPadding((int) (32 * d), (int) (70 * d), (int) (32 * d), 0);
        ImageView art = Neo.iconTile(c, "messages", Neo.CYAN, 96);
        empty.addView(art, new LayoutParams((int) (96 * d), (int) (96 * d)));
        TextView et = Neo.text(c, "No messages yet", Neo.TEXT, 20, Neo.ui(c)); et.setPadding(0, (int) (22 * d), 0, 0); empty.addView(et);
        TextView eb = Neo.text(c, "Write to a contact, a talkgroup or the current channel's call target. Texts travel on DMR channels; incoming ones appear here and in the intercom history.", Neo.MUTED, 14.5f, Neo.uiMedium(c));
        eb.setGravity(Gravity.CENTER); eb.setLineSpacing(0, 1.15f); eb.setPadding(0, (int) (8 * d), 0, (int) (22 * d)); empty.addView(eb);
        TextView start = Neo.button(c, "New message", "plus", Neo.GREEN);
        start.setOnClickListener(v -> newMessage());
        empty.addView(start, new LayoutParams((int) (220 * d), LayoutParams.WRAP_CONTENT));
        listPage.addView(empty);
        listPage.addView(list, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));
        content.addView(listPage);
        addView(content, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
    }

    public void attach(RadioService s) { svc = s; s.addListener(this); reload(); }
    public void detach() { if (svc != null) svc.removeListener(this); svc = null; }

    public void reload() {
        if (svc == null) return;
        convs.clear(); convs.addAll(svc.store().conversations()); convAdapter.notifyDataSetChanged();
        empty.setVisibility(convs.isEmpty() ? VISIBLE : GONE);
        Neo.headerSubtitle(header).setText(convs.isEmpty() ? "DMR TEXT" : (convs.size() + (convs.size() == 1 ? " conversation" : " conversations")).toUpperCase(java.util.Locale.US));
    }

    public boolean back() { if (threadPage != null) { content.removeView(threadPage); threadPage = null; peer = null; reload(); return true; } return false; }

    private void newMessage() {
        final Context c = getContext();
        if (svc == null) return;
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

    private static String peerLabel(ChannelStore.Contact ct) { return (ct.type == 1 ? "TG " : ct.type == 2 ? "ALL " : "ID ") + ct.number; }

    public void openThread(ChannelStore.Contact ct) {
        final Context c = getContext(); float d = Theme.dp(c);
        peer = ct;
        if (threadPage != null) content.removeView(threadPage);
        threadPage = new LinearLayout(c); threadPage.setOrientation(VERTICAL); threadPage.setBackground(Neo.page(c));
        String title = ct.name == null || ct.name.isEmpty() ? peerLabel(ct) : ct.name;
        LinearLayout bar = Neo.header(c, title, ct.name == null || ct.name.isEmpty() ? (ct.type == 1 ? "Talkgroup" : ct.type == 2 ? "All call" : "Private") : peerLabel(ct));
        ImageView back = Neo.iconButton(c, "left", Neo.CYAN, "Back"); back.setOnClickListener(v -> back());
        LayoutParams bl = new LayoutParams((int) (44 * d), (int) (44 * d)); bl.rightMargin = (int) (12 * d);
        bar.addView(back, 0, bl);
        LayoutParams avl = new LayoutParams((int) (38 * d), (int) (38 * d)); avl.rightMargin = (int) (10 * d);
        bar.addView(ContactsView.avatar(c, ct.type, ct.name, 38), 1, avl);
        threadPage.addView(bar);
        analogNote = Neo.text(c, "This channel is analog: switch to a DMR channel to send text.", Neo.AMBER_LIGHT, 13.5f, Neo.uiSemi(c));
        analogNote.setGravity(Gravity.CENTER); analogNote.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
        analogNote.setBackground(Neo.outline(c, Neo.AMBER, 0x18, 10, 1));
        LayoutParams anl = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); anl.setMargins((int) (16 * d), (int) (8 * d), (int) (16 * d), 0);
        threadPage.addView(analogNote, anl);
        threadList = new ListView(c); threadAdapter = new ThreadAdapter(); threadList.setAdapter(threadAdapter); threadList.setDivider(null); threadList.setDividerHeight(0);
        threadList.setSelector(new android.graphics.drawable.ColorDrawable(0));
        threadList.setTranscriptMode(ListView.TRANSCRIPT_MODE_ALWAYS_SCROLL); threadList.setStackFromBottom(true);
        threadList.setPadding(0, (int) (6 * d), 0, (int) (6 * d)); threadList.setClipToPadding(false);
        threadPage.addView(threadList, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1f));

        LinearLayout compose = new LinearLayout(c); compose.setGravity(Gravity.CENTER_VERTICAL); compose.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (10 * d));
        compose.setBackgroundColor(Neo.BAR);
        ImageView quick = Neo.iconButton(c, "bolt", Neo.AMBER, "Quick replies");
        LayoutParams ql = new LayoutParams((int) (44 * d), (int) (44 * d)); ql.rightMargin = (int) (8 * d);
        compose.addView(quick, ql);
        final EditText input = new EditText(c); input.setHint("Message"); input.setTextColor(Neo.TEXT); input.setHintTextColor(Neo.DIM); input.setTextSize(16); input.setTypeface(Neo.uiSemi(c));
        input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES | InputType.TYPE_TEXT_FLAG_MULTI_LINE); input.setMaxLines(3); input.setMinHeight((int) (44 * d));
        input.setBackground(Neo.card(c, Neo.alpha(Neo.CYAN, 0x33), 14)); input.setPadding((int) (14 * d), (int) (8 * d), (int) (14 * d), (int) (8 * d));
        quick.setOnClickListener(v -> quickReplies(input));
        compose.addView(input, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
        ImageView send = new ImageView(c); send.setImageDrawable(new Neo.IconDrawable("send", 0xFF04121A)); send.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        int sp = (int) (12 * d); send.setPadding(sp, sp, sp, sp); send.setContentDescription("Send"); send.setClickable(true); send.setFocusable(true);
        android.graphics.drawable.GradientDrawable sg = new android.graphics.drawable.GradientDrawable(); sg.setShape(android.graphics.drawable.GradientDrawable.OVAL); sg.setColor(Neo.GREEN); send.setBackground(sg);
        LayoutParams sl = new LayoutParams((int) (46 * d), (int) (46 * d)); sl.leftMargin = (int) (8 * d);
        compose.addView(send, sl);
        send.setOnClickListener(v -> {
            String t = input.getText().toString().trim();
            if (t.isEmpty() || svc == null) return;
            if (svc.current() == null || !svc.current().isDigital()) { android.widget.Toast.makeText(c, "Switch to a DMR channel to send text", android.widget.Toast.LENGTH_LONG).show(); return; }
            input.setText("");
            svc.sendSms(peer, t);
            loadThread();
        });
        threadPage.addView(compose);
        content.addView(threadPage);
        refreshAnalogNote();
        loadThread();
    }

    private void refreshAnalogNote() { if (analogNote != null) analogNote.setVisibility(svc != null && svc.current() != null && !svc.current().isDigital() ? VISIBLE : GONE); }

    private void loadThread() {
        if (peer == null || svc == null) return;
        msgs.clear(); msgs.addAll(svc.store().messages(peer.number, peer.type)); threadAdapter.notifyDataSetChanged();
    }

    /** Delivery mark for an outgoing text: colour and wording by module status. */
    private static int statusColor(int status) { return status == 1 ? Neo.GREEN : status == 2 ? Neo.RED : status == 3 ? Neo.AMBER : Neo.DIM; }
    private static String statusText(int status) { return status == 1 ? "✓✓ delivered" : status == 2 ? "✖ not sent" : status == 3 ? "✓ sent, no acknowledgement" : "sending…"; }

    private final class ConvAdapter extends BaseAdapter {
        @Override public int getCount() { return convs.size(); } @Override public Object getItem(int i) { return convs.get(i); } @Override public long getItemId(int i) { return i; }
        @Override public View getView(int i, View v, ViewGroup parent) {
            Context c = getContext(); float d = Theme.dp(c);
            if (v == null) {
                LinearLayout outer = new LinearLayout(c); outer.setPadding(0, (int) (3 * d), 0, (int) (3 * d));
                LinearLayout row = new LinearLayout(c); row.setGravity(Gravity.CENTER_VERTICAL); row.setTag("row");
                row.setPadding((int) (10 * d), (int) (10 * d), (int) (14 * d), (int) (10 * d)); row.setMinimumHeight((int) (72 * d));
                android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(); g.setColor(0xBF0B1622); g.setCornerRadius(14 * d); g.setStroke((int) d, 0xFF142536);
                row.setBackground(g);
                LinearLayout av = new LinearLayout(c); av.setTag("av"); row.addView(av, new LayoutParams((int) (46 * d), (int) (46 * d)));
                LinearLayout col = new LinearLayout(c); col.setOrientation(VERTICAL); col.setPadding((int) (12 * d), 0, 0, 0);
                LinearLayout l1 = new LinearLayout(c); l1.setGravity(Gravity.CENTER_VERTICAL);
                TextView name = Neo.text(c, "", Neo.TEXT, 17.5f, Neo.ui(c)); name.setSingleLine(true); name.setEllipsize(android.text.TextUtils.TruncateAt.END); name.setTag("name");
                l1.addView(name, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
                TextView time = Neo.text(c, "", Neo.DIM, 12.5f, Neo.mono(c)); time.setTag("time"); time.setPadding((int) (8 * d), 0, 0, 0); l1.addView(time);
                col.addView(l1);
                TextView last = Neo.text(c, "", Neo.MUTED, 14, Neo.uiMedium(c)); last.setSingleLine(true); last.setEllipsize(android.text.TextUtils.TruncateAt.END); last.setTag("last");
                last.setPadding(0, (int) (4 * d), 0, 0); col.addView(last);
                row.addView(col, new LayoutParams(0, LayoutParams.WRAP_CONTENT, 1f));
                outer.addView(row, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
                outer.setLayoutParams(new ListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                v = outer;
            }
            ChannelStore.Conversation cv = convs.get(i);
            LinearLayout row = v.findViewWithTag("row");
            LinearLayout av = row.findViewWithTag("av"); av.removeAllViews();
            av.addView(ContactsView.avatar(c, cv.type, cv.name, 46), new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
            ChannelStore.Contact tmp = new ChannelStore.Contact(); tmp.type = cv.type; tmp.number = cv.peer;
            ((TextView) row.findViewWithTag("name")).setText(cv.name == null || cv.name.isEmpty() ? peerLabel(tmp) : cv.name);
            ((TextView) row.findViewWithTag("time")).setText(df.format(new Date(cv.lastTs)));
            ((TextView) row.findViewWithTag("last")).setText((cv.outgoing ? "You: " : "") + cv.lastText);
            return v;
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
        String[] items = new String[q.size() + 1]; for (int i = 0; i < q.size(); i++) items[i] = q.get(i); items[q.size()] = "Edit quick replies…";
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
            row.setPadding((int) (14 * d), (int) (5 * d), (int) (14 * d), (int) (5 * d));
            TextView b = Neo.text(c, m.text, Neo.TEXT, 16, Neo.uiSemi(c)); b.setMaxWidth((int) (270 * d)); b.setLineSpacing(0, 1.1f);
            android.graphics.drawable.GradientDrawable g = new android.graphics.drawable.GradientDrawable(android.graphics.drawable.GradientDrawable.Orientation.TL_BR,
                    m.outgoing ? new int[] { 0xFF0F4258, 0xFF0A2C3C } : new int[] { 0xFF16222F, 0xFF101A25 });
            float r = 18 * d, tail = 5 * d;
            g.setCornerRadii(m.outgoing ? new float[] { r, r, r, r, tail, tail, r, r } : new float[] { r, r, r, r, r, r, tail, tail });
            g.setStroke((int) d, m.outgoing ? Neo.alpha(Neo.CYAN, 0x88) : 0xFF22364A);
            b.setBackground(g); b.setPadding((int) (14 * d), (int) (10 * d), (int) (14 * d), (int) (10 * d));
            row.addView(b, new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));   // hug the text so yours sit right, theirs left
            LinearLayout meta = new LinearLayout(c); meta.setPadding((int) (4 * d), (int) (3 * d), (int) (4 * d), 0);
            meta.addView(Neo.text(c, tf.format(new Date(m.ts)), Neo.DIM, 12, Neo.mono(c)));
            if (m.outgoing) { TextView st = Neo.text(c, "  " + statusText(m.status), statusColor(m.status), 12.5f, Neo.ui(c)); meta.addView(st); }
            row.addView(meta, new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
            return row;
        }
    }

    // RadioService.Listener
    @Override public void onSms(int from, int type, String text) { if (peer != null && peer.number == from) loadThread(); else reload(); }
    @Override public void onSmsResult(boolean ok) { loadThread(); reload(); }
    @Override public void onChannel(ChannelStore.Channel ch) { refreshAnalogNote(); } @Override public void onRx(boolean r) { } @Override public void onTx(boolean t) { } @Override public void onRssi(int dbm) { }
    @Override public void onAudioLevel(int a) { } @Override public void onHistory(String l) { } @Override public void onCaller(String t) { } @Override public void onLog(String s) { }
    @Override public void onLink(String s) { } @Override public void onLocation(String t) { }
    @Override public void onModes(boolean a, int b, boolean c2, boolean d2, boolean e, boolean f2, boolean g, String z) { }
    @Override public void onCaption(boolean en, String live, String sentence) { }
}
