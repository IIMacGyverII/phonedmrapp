package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ChannelStore;
import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.ActivityStats;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/** Activity: which channels are busiest and when, from the history; make a scan zone of the busiest. */
public final class ActivityDialog {
    private ActivityDialog() { }
    private static final int[] DAYS = { 1, 7, 30 };

    public static void show(Context c, RadioService svc) { show(c, svc, 1); }

    private static void show(Context c, RadioService svc, int range) {
        float d = Theme.dp(c);
        ActivityStats s = ActivityStats.of(svc.store().activity(System.currentTimeMillis() - DAYS[range] * 86_400_000L));
        LinearLayout body = Neo.sheetBody(c, "Activity");
        final AlertDialog[] self = new AlertDialog[1];
        LinearLayout pills = new LinearLayout(c);
        for (int i = 0; i < DAYS.length; i++) {
            final int k = i;
            TextView p = Neo.text(c, DAYS[i] == 1 ? "Today" : "Last " + DAYS[i] + " days", Neo.TEXT, 14, Neo.ui(c)); p.setGravity(Gravity.CENTER); p.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
            Neo.pillStyle(p, i == range, Neo.CYAN);
            p.setOnClickListener(v -> { if (self[0] != null) self[0].dismiss(); show(c, svc, k); });
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f); lp.setMargins((int) (3 * d), (int) (4 * d), (int) (3 * d), (int) (4 * d));
            pills.addView(p, lp);
        }
        body.addView(pills);
        int peak = s.peakHour();
        body.addView(Neo.sheetHint(c, s.receptions + " receptions, " + Math.round(s.seconds / 60.0) + " minutes of analog audio" + (peak >= 0 ? String.format(Locale.US, "; busiest around %02d:00", peak) : "") + ". Counted from the history: analog receptions and DMR calls."));
        body.addView(Neo.sheetSection(c, "By hour of day"));
        body.addView(new Hours(c, s.byHour), new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, (int) (120 * d)));
        body.addView(Neo.sheetSection(c, "Busiest channels"));
        if (s.channels.isEmpty()) body.addView(Neo.sheetHint(c, "Nothing received in this period."));
        SimpleDateFormat f = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
        int shown = 0;
        for (ActivityStats.Channel a : s.channels) {
            if (++shown > 25) break;
            ChannelStore.Channel ch = svc.store().byNumber(a.number);
            String nm = ch != null ? ch.name : a.number == 0 ? "VFO" : "channel " + a.number;
            LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
            r.addView(Neo.text(c, a.number + "  " + nm, Neo.TEXT, 15.5f, Neo.ui(c)));
            r.addView(Neo.text(c, a.receptions + (a.receptions == 1 ? " reception" : " receptions") + (a.seconds > 0 ? ", " + (a.seconds >= 120 ? Math.round(a.seconds / 60.0) + " min" : a.seconds + " s") : "") + "  ·  last " + f.format(new Date(a.lastTs)), Neo.MUTED, 12.5f, Neo.uiMedium(c)));
            if (ch != null) { r.setClickable(true); r.setOnClickListener(v -> { svc.selectChannel(ch.number); if (self[0] != null) self[0].dismiss(); }); }
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (6 * d);
            body.addView(r, lp);
        }
        if (s.channels.size() >= 2) {
            TextView zone = Neo.button(c, "Make a scan zone of the busiest", "zone", Neo.GREEN); body.addView(zone);
            zone.setOnClickListener(v -> {
                List<Integer> nums = new ArrayList<>();
                for (ActivityStats.Channel a : s.channels) if (a.number > 0 && svc.store().byNumber(a.number) != null && nums.size() < 12) nums.add(a.number);
                ChannelStore.Zone z = null; for (ChannelStore.Zone x : svc.store().zones()) if (x.name.equals("Busiest channels")) z = x;
                if (z == null) { z = new ChannelStore.Zone(); z.name = "Busiest channels"; }
                z.numbers = new int[nums.size()]; for (int i = 0; i < nums.size(); i++) z.numbers[i] = nums.get(i);
                svc.store().saveZone(z); svc.setZone(z.id);
                Toast.makeText(c, "Zone \"Busiest channels\" with " + nums.size() + " channels is in use: SCAN searches them", Toast.LENGTH_LONG).show();
                if (self[0] != null) self[0].dismiss();
            });
        }
        self[0] = Neo.showSheet(c, body);
    }

    /** 24 bars, one per hour. */
    static final class Hours extends View {
        private final int[] h; private final Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        Hours(Context c, int[] hours) { super(c); h = hours; }
        @Override protected void onDraw(Canvas cv) {
            float d = Theme.dp(getContext()), w = getWidth(), ht = getHeight() - 18 * d, bw = w / 24f;
            int max = 1; for (int v : h) max = Math.max(max, v);
            for (int i = 0; i < 24; i++) {
                float bh = h[i] == 0 ? 2 * d : Math.max(3 * d, ht * h[i] / max);
                p.setColor(h[i] == max && h[i] > 0 ? Neo.AMBER : Neo.alpha(Neo.CYAN, h[i] == 0 ? 0x33 : 0xCC));
                cv.drawRoundRect(i * bw + bw * 0.15f, ht - bh, (i + 1) * bw - bw * 0.15f, ht, 2 * d, 2 * d, p);
            }
            p.setColor(Neo.DIM); p.setTextSize(10 * d); p.setTextAlign(Paint.Align.CENTER);
            for (int i = 0; i < 24; i += 6) cv.drawText(String.format(Locale.US, "%02d", i), i * bw + bw / 2, getHeight() - 4 * d, p);
            cv.drawText("23", 23 * bw + bw / 2, getHeight() - 4 * d, p);
        }
    }
}
