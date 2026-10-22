/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ui;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Looper;
import android.text.InputType;
import android.view.Gravity;
import android.view.MotionEvent;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.util.List;

/**
 * Emergency: send your position on the channel you are on. A DMR channel texts the chosen contact or talkgroup
 * ("EMERGENCY <message> @ lat,lon ±acc m"); an analog channel sends an APRS position with the emergency symbol and
 * "EMERGENCY <message>" (a status report when there is no fix). The send key must be held for two seconds.
 */
public final class EmergencyDialog {
    private EmergencyDialog() { }
    static final long HOLD_MS = 2000;

    public static void show(final Context c, final RadioService svc) {
        if (svc == null) return;
        final float d = Theme.dp(c);
        final SharedPreferences p = c.getSharedPreferences("emergency", Context.MODE_PRIVATE);
        LinearLayout box = Neo.sheetBody(c, "Emergency");
        box.addView(Neo.sheetHint(c, "Sends your position now, on the channel you are on. Only for a real emergency: on amateur bands an emergency call is answered by real people."));

        ChannelStore.Channel ch = svc.current();
        String how = ch == null ? "No channel selected." : ch.isDigital()
                ? "On " + ch.name + " (DMR): a text with your coordinates to the contact below."
                : "On " + ch.name + " (analog): an APRS position with the emergency symbol" + (svc.packet() != null && svc.packet().callsignSet() ? "." : ". Set your callsign first in PKT → APRS settings.");
        TextView where = Neo.label(c, how, ch != null && ch.isDigital() ? Neo.CYAN : Neo.AMBER, 14, true);
        where.setPadding(0, (int) (8 * d), 0, 0);
        box.addView(where);

        box.addView(Neo.sheetSection(c, "Message"));
        final EditText msg = new EditText(c);
        msg.setText(p.getString("text", "Need help")); msg.setSingleLine(true); msg.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES);
        msg.setTextSize(17); msg.setTextColor(Neo.TEXT); msg.setHintTextColor(Neo.DIM); msg.setTypeface(Neo.uiSemi(c)); msg.setHint("What is wrong");
        msg.setBackground(Neo.rowCard(c)); msg.setPadding((int) (12 * d), (int) (10 * d), (int) (12 * d), (int) (10 * d));
        box.addView(msg);

        box.addView(Neo.sheetSection(c, "DMR text goes to"));
        final TextView to = Neo.label(c, recipient(p), Neo.TEXT, 16, true);
        to.setBackground(Neo.rowCard(c)); to.setPadding((int) (12 * d), (int) (12 * d), (int) (12 * d), (int) (12 * d));
        box.addView(to);
        to.setOnClickListener(v -> {
            final List<ChannelStore.Contact> all = svc.store().contacts();
            if (all.isEmpty()) { Toast.makeText(c, "Add a contact or talkgroup first (Contacts page)", Toast.LENGTH_LONG).show(); return; }
            String[] names = new String[all.size()];
            for (int i = 0; i < all.size(); i++) { ChannelStore.Contact k = all.get(i); names[i] = (k.type == 1 ? "TG " : "") + k.name + "  ·  " + k.number; }
            new android.app.AlertDialog.Builder(c).setTitle("Emergency text to").setItems(names, (dd, w) -> {
                ChannelStore.Contact k = all.get(w);
                p.edit().putInt("to", k.number).putInt("toType", k.type).putString("toName", k.name).apply();
                to.setText(recipient(p));
            }).show();
        });

        final TextView send = Neo.button(c, "HOLD TO SEND", "alert", Neo.RED);
        send.setTextSize(18); send.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams sl = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, (int) (64 * d)); sl.topMargin = (int) (18 * d);
        box.addView(send, sl);
        final TextView result = Neo.sheetHint(c, "Hold the key for two seconds.");
        box.addView(result);

        final android.app.Dialog dlg = Neo.showSheet(c, box);
        final Handler h = new Handler(Looper.getMainLooper());
        final long[] downAt = { 0 };
        final Runnable tick = new Runnable() {
            @Override public void run() {
                if (downAt[0] == 0) return;
                long left = HOLD_MS - (System.currentTimeMillis() - downAt[0]);
                if (left > 0) { send.setText("KEEP HOLDING  " + (left / 1000 + 1)); h.postDelayed(this, 100); return; }
                downAt[0] = 0;
                p.edit().putString("text", msg.getText().toString()).apply();
                String r = svc.emergency(msg.getText().toString(), p.getInt("to", 0), p.getInt("toType", 0), p.getString("toName", ""));
                send.setText(r.startsWith("Emergency") ? "SEND AGAIN (HOLD)" : "HOLD TO SEND");
                result.setText(r); result.setTextColor(r.startsWith("Emergency") ? Neo.GREEN : Neo.AMBER);
            }
        };
        send.setOnTouchListener((v, e) -> {
            int a = e.getActionMasked();
            if (a == MotionEvent.ACTION_DOWN) { downAt[0] = System.currentTimeMillis(); h.post(tick); v.setPressed(true); return true; }
            if (a == MotionEvent.ACTION_UP || a == MotionEvent.ACTION_CANCEL) {
                v.setPressed(false);
                if (downAt[0] != 0) { downAt[0] = 0; send.setText("HOLD TO SEND"); result.setText("Not sent: hold the key for two seconds."); result.setTextColor(Neo.MUTED); }
                return true;
            }
            return true;
        });
    }

    private static String recipient(SharedPreferences p) {
        int n = p.getInt("to", 0);
        if (n <= 0) return "Choose a contact or talkgroup  ›";
        return (p.getInt("toType", 0) == 1 ? "TG " : "") + p.getString("toName", "") + "  ·  " + n + "  ›";
    }
}
