package com.macdmr.radio.ui;

import android.content.Context;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.macdmr.radio.RadioService;
import com.macdmr.radio.ham.Maidenhead;
import com.macdmr.radio.ham.Satellites;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * On the APRS and SSTV pages while an ISS pass is tracked: when the next pass comes (countdown, highest elevation),
 * or during the pass where the station is, the Doppler-corrected frequency the radio is on, and when it sets.
 * Hidden for every other mode.
 */
final class PassCard extends LinearLayout {
    private final TextView title, detail;

    PassCard(Context c) {
        super(c);
        float d = Theme.dp(c);
        setOrientation(VERTICAL); setVisibility(GONE);
        setBackground(Neo.outline(c, Neo.VIOLET, 0x14, 12, 1)); setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
        title = Neo.text(c, "", Neo.VIOLET_LIGHT, 15, Neo.ui(c)); addView(title);
        detail = Neo.text(c, "", Neo.TEXT_SOFT, 13, Neo.uiMedium(c)); detail.setPadding(0, (int) (2 * d), 0, 0); addView(detail);
        LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); lp.bottomMargin = (int) (8 * d); setLayoutParams(lp);
    }

    void update(RadioService svc) {
        RadioService.SatState st = svc.satState();
        boolean show = st != null && st.mode != Satellites.VOICE;
        if ((getVisibility() == VISIBLE) != show) setVisibility(show ? VISIBLE : GONE);
        if (!show) return;
        long now = System.currentTimeMillis();
        String follow = svc.issRepeat() == st.mode ? "Following every pass until you stop" : "This pass only";
        String t, dt;
        if (st.waiting || st.look == null) {
            long in = Math.max(0, st.aos - now) / 1000;
            t = "🛰  Next ISS pass " + new SimpleDateFormat("EEE HH:mm", Locale.US).format(new Date(st.aos)) + "  ·  in " + (in >= 3600 ? in / 3600 + " h " + in % 3600 / 60 + " min" : in / 60 + " min " + in % 60 + " s");
            dt = String.format(Locale.US, "Highest %.0f°, about %d min. The radio tunes a minute before it rises and follows the Doppler shift. ", st.maxEl, (st.los - st.aos + 30_000) / 60_000) + follow + ".";
        } else {
            long left = Math.max(0, st.los - now) / 1000;
            boolean up = st.look.el >= 0;
            t = up ? String.format(Locale.US, "🛰  ISS up  ·  %.0f° high, %s", st.look.el, Maidenhead.compass(st.look.az)) : "🛰  ISS about to rise";
            dt = String.format(Locale.US, "Listening %.4f MHz (%+.1f kHz Doppler)  ·  %s %d:%02d  ·  %.0f km away", st.rxHz / 1e6, (st.rxHz - st.nominalHz) / 1000.0, up ? "sets in" : "pass ends in", left / 60, left % 60, st.look.rangeKm)
                    + (st.mode == Satellites.APRS && !st.listenOnly ? String.format(Locale.US, "\nTalk %.4f MHz", st.txHz / 1e6) : "") + "\n" + follow + ".";
        }
        ModeScreen.set(title, t); ModeScreen.set(detail, dt);
    }
}
