package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;

/** Last heard: who and which channel had activity, newest first, with names from contacts and the RadioID list. Tap to switch. */
public final class LastHeardDialog {
    private static final class Row { int channel, dmrId, count; long ts; String kind, text; }

    public static void show(Context c, RadioService svc) {
        float d = Theme.dp(c);
        LinearLayout body = Neo.sheetBody(c, "Last heard");
        TextView hint = Neo.label(c, "Newest first across every channel: who called, text and APRS traffic, what was recorded. Tap a line to switch to that channel.", 0xFF8A98A6, 12, false);
        hint.setPadding(0, (int) (4 * d), 0, (int) (8 * d)); body.addView(hint);
        LinearLayout tools = new LinearLayout(c); tools.setGravity(Gravity.CENTER);
        tools.setBaselineAligned(false);
        for (String[] t : new String[][] { { "Recordings", "rec" }, { "Captions", "txt" } }) {
            TextView b = Neo.button(c, t[0], t[1], t[1].equals("rec") ? Neo.RED : Neo.VIOLET); b.setTextSize(14);
            final boolean rec = t[1].equals("rec");
            b.setOnClickListener(v -> { if (rec) MediaDialogs.recordings(c, svc); else MediaDialogs.captions(c, svc); });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); lp.setMargins((int) (3 * d), (int) (6 * d), (int) (3 * d), (int) (10 * d)); tools.addView(b, lp);
        }
        body.addView(tools);

        LinkedHashMap<String, Row> rows = new LinkedHashMap<>();
        for (Object[] h : svc.store().lastHeard(400)) {
            Row r = new Row(); r.ts = (Long) h[0]; r.channel = (Integer) h[1]; r.kind = (String) h[2]; r.text = (String) h[3]; r.dmrId = (Integer) h[4];
            String key = r.channel + ":" + (r.kind.equals("dmr") || r.kind.equals("sms") ? r.dmrId : r.kind);
            Row e = rows.get(key);
            if (e == null) { r.count = 1; rows.put(key, r); } else e.count++;
        }
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US);
        if (rows.isEmpty()) body.addView(Neo.label(c, "Nothing heard yet.", 0xFFBFC8D0, 14, false));
        List<Row> list = new ArrayList<>(rows.values());
        for (Row r : list) {
            ChannelStore.Channel ch = svc.store().byNumber(r.channel);
            String chName = ch != null ? ch.name : (r.channel == 0 ? "VFO" : "channel " + r.channel);
            String who = r.dmrId > 0 ? svc.callerName(r.dmrId) : "";
            String title = (r.dmrId > 0 ? (who.isEmpty() ? "ID " + r.dmrId : who + "  ·  " + r.dmrId) : r.text.length() > 48 ? r.text.substring(0, 48) + "…" : r.text);
            LinearLayout rowv = new LinearLayout(c); rowv.setOrientation(LinearLayout.VERTICAL);
            rowv.setBackground(Neo.rowCard(c)); rowv.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d);
            rowv.addView(Neo.label(c, title, r.dmrId > 0 ? Theme.AMBER : Theme.CYAN, 15, true));
            rowv.addView(Neo.label(c, f.format(new Date(r.ts)) + "  ·  " + chName + (r.count > 1 ? "  ·  " + r.count + "×" : "") + (r.dmrId > 0 && !r.text.isEmpty() ? "\n" + r.text : ""), 0xFFBFC8D0, 12, false));
            final int chNum = r.channel;
            rowv.setClickable(true);
            body.addView(rowv, lp);
            AlertDialog[] holder = new AlertDialog[1];
            rowv.setOnClickListener(v -> { if (chNum > 0) { svc.selectChannel(chNum); if (holder[0] != null) holder[0].dismiss(); } });
            rowv.setTag(holder);
        }
        AlertDialog a = Neo.showSheet(c, body);
        for (int i = 0; i < body.getChildCount(); i++) { Object t = body.getChildAt(i).getTag(); if (t instanceof AlertDialog[]) ((AlertDialog[]) t)[0] = a; }

    }
}
