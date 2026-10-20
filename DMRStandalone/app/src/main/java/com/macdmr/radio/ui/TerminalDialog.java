package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.PacketEngine;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.pkt.Ax25Session;

/** Packet terminal: connect to a BBS or node (AX.25 connected mode) on the current channel and type. */
public final class TerminalDialog {
    private TerminalDialog() { }

    public static void show(Context c, RadioService svc) {
        final PacketEngine pe = svc.packet(); if (pe == null) return;
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Packet terminal");
        final TextView state = Neo.label(c, "", Theme.CYAN, 14, true); body.addView(state);
        body.addView(Neo.sheetHint(c, "Tune the BBS or node's channel, then connect. Each exchange takes a few seconds: every transmission starts with a 1.6-second tone and lost frames are sent again. Type a line and Send; most BBSs answer with a prompt, and B or BYE ends the session."));
        final EditText call = field(c, body, "Connect to (callsign-SSID)", c.getSharedPreferences("packet", Context.MODE_PRIVATE).getString("termCall", ""), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        final EditText via = field(c, body, "Via digipeaters (optional, e.g. RELAY)", c.getSharedPreferences("packet", Context.MODE_PRIVATE).getString("termVia", ""), InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        LinearLayout r1 = new LinearLayout(c); r1.setBaselineAligned(false);
        final TextView conn = Neo.button(c, "Connect", "send", Neo.GREEN), acc = Neo.button(c, pe.acceptConnections() ? "Incoming: accept" : "Incoming: refuse", "contacts", Neo.VIOLET);
        for (TextView b : new TextView[] { conn, acc }) { b.setTextSize(14); LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (6 * d), (int) (3 * d), (int) (6 * d)); r1.addView(b, lp); }
        body.addView(r1);
        final TextView screen = Neo.text(c, "", 0xFFCFE8D8, 13, Neo.mono(c));
        screen.setBackground(Neo.rowCard(c)); screen.setPadding((int) (10 * d), (int) (8 * d), (int) (10 * d), (int) (8 * d)); screen.setMinHeight((int) (220 * d)); screen.setTextIsSelectable(true);
        body.addView(screen, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
        LinearLayout r2 = new LinearLayout(c); r2.setBaselineAligned(false);
        final EditText input = new EditText(c); input.setSingleLine(true); input.setHint("Type a line"); input.setTextColor(Neo.TEXT); input.setHintTextColor(Neo.DIM); input.setTypeface(Neo.mono(c)); input.setImeOptions(EditorInfo.IME_ACTION_SEND);
        input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        TextView send = Neo.button(c, "Send", null, Neo.CYAN);
        r2.addView(input, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        r2.addView(send, new LinearLayout.LayoutParams((int) (100 * d), LinearLayout.LayoutParams.MATCH_PARENT));
        body.addView(r2);

        final Runnable refresh = () -> {
            Ax25Session t = pe.terminal();
            boolean up = t != null && t.state() != Ax25Session.State.DISCONNECTED;
            conn.setText(up ? "Disconnect" : "Connect");
            state.setText(pe.terminalState() + (t != null && t.pending() > 0 ? "  ·  " + t.pending() + " waiting to be acknowledged" : ""));
        };
        pe.setTerminalListener((text, st) -> { String s = text.length() > 6000 ? text.substring(text.length() - 6000) : text; screen.setText(s.isEmpty() ? "Nothing yet." : s); refresh.run(); });
        refresh.run();
        conn.setOnClickListener(v -> {
            Ax25Session t = pe.terminal();
            if (t != null && t.state() != Ax25Session.State.DISCONNECTED) { pe.terminalDisconnect(); refresh.run(); return; }
            String e = pe.terminalConnect(call.getText().toString(), via.getText().toString());
            if (e != null) { Toast.makeText(c, e, Toast.LENGTH_LONG).show(); return; }
            c.getSharedPreferences("packet", Context.MODE_PRIVATE).edit().putString("termCall", call.getText().toString().trim().toUpperCase(java.util.Locale.US)).putString("termVia", via.getText().toString().trim().toUpperCase(java.util.Locale.US)).apply();
            refresh.run();
        });
        acc.setOnClickListener(v -> { pe.setAcceptConnections(!pe.acceptConnections()); acc.setText(pe.acceptConnections() ? "Incoming: accept" : "Incoming: refuse"); });
        Runnable doSend = () -> {
            String line = input.getText().toString();
            String e = pe.terminalSend(line);
            if (e != null) { Toast.makeText(c, e, Toast.LENGTH_SHORT).show(); return; }
            input.setText(""); refresh.run();
        };
        send.setOnClickListener(v -> doSend.run());
        input.setOnEditorActionListener((v, id, ev) -> { doSend.run(); return true; });
        AlertDialog a = Neo.showSheet(c, body);
        a.setOnDismissListener(x -> pe.setTerminalListener(null));
    }

    private static EditText field(Context c, LinearLayout target, String label, String value, int type) {
        float d = Theme.dp(c);
        LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (6 * d), (int) (12 * d), (int) (4 * d));
        r.addView(Neo.label(c, label, 0xFF9AA4AE, 12, false));
        EditText e = new EditText(c); e.setText(value); e.setInputType(type); e.setTextSize(16); e.setTextColor(Neo.TEXT); e.setSingleLine(true); e.setBackground(null);
        r.addView(e);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.topMargin = (int) (6 * d);
        target.addView(r, lp);
        return e;
    }
}
