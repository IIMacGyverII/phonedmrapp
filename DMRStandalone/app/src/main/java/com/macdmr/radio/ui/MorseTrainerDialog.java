package com.macdmr.radio.ui;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Handler;
import android.os.Looper;
import android.text.InputType;
import android.view.Gravity;
import android.view.MotionEvent;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.macdmr.radio.ham.CwDecoder;
import com.macdmr.radio.ham.MorseTrainer;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Random;

/** Morse trainer: Koch lessons with Farnsworth spacing, copy practice with scoring, and a sending key decoded live. */
public final class MorseTrainerDialog {
    private MorseTrainerDialog() { }

    @SuppressLint("ClickableViewAccessibility")
    public static void show(Context c) {
        float d = Theme.dp(c);
        final SharedPreferences p = c.getSharedPreferences("trainer", Context.MODE_PRIVATE);
        final int[] lesson = { p.getInt("lesson", 1) }, wpm = { p.getInt("wpm", 20) }, fw = { p.getInt("fw", 10) };
        LinearLayout body = Neo.sheetBody(c, "Morse trainer");
        body.addView(Neo.sheetHint(c, "The Koch method: start with two characters at full speed and add one each time you copy a lesson with 90 %. Farnsworth spacing leaves longer gaps between characters while you learn; close it up as you improve. Sound plays on the phone, not on the air."));
        final TextView lessonT = Neo.text(c, "", Neo.TEXT, 16, Neo.ui(c)), speedT = Neo.text(c, "", Neo.TEXT, 15, Neo.ui(c));
        final Runnable[] save = new Runnable[1];
        save[0] = () -> {
            p.edit().putInt("lesson", lesson[0]).putInt("wpm", wpm[0]).putInt("fw", fw[0]).apply();
            String cs = MorseTrainer.chars(lesson[0]);
            lessonT.setText("Lesson " + lesson[0] + " of " + MorseTrainer.LESSONS + ":  " + cs.replace("", " ").trim() + "   (new: " + cs.charAt(cs.length() - 1) + ")");
            speedT.setText(String.format(Locale.US, "Characters %d WPM  ·  spacing %d WPM", wpm[0], fw[0]));
        };
        body.addView(stepper(c, lessonT, () -> { lesson[0] = Math.max(1, lesson[0] - 1); save[0].run(); }, () -> { lesson[0] = Math.min(MorseTrainer.LESSONS, lesson[0] + 1); save[0].run(); }));
        body.addView(stepper(c, speedT, () -> { wpm[0] = Math.max(5, wpm[0] - 1); fw[0] = Math.min(fw[0], wpm[0]); save[0].run(); }, () -> { wpm[0] = Math.min(35, wpm[0] + 1); save[0].run(); }));
        final TextView fwT = Neo.text(c, "Spacing", Neo.MUTED, 14, Neo.uiMedium(c));
        body.addView(stepper(c, fwT, () -> { fw[0] = Math.max(5, fw[0] - 1); save[0].run(); }, () -> { fw[0] = Math.min(wpm[0], fw[0] + 1); save[0].run(); }));
        save[0].run();

        body.addView(Neo.sheetSection(c, "Copy practice"));
        final String[] sent = { "" };
        LinearLayout r1 = new LinearLayout(c); r1.setBaselineAligned(false);
        TextView play = Neo.button(c, "Play 5 groups", "volume", Neo.GREEN), again = Neo.button(c, "Again", "update", Neo.CYAN);
        for (TextView b : new TextView[] { play, again }) { LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1f); lp.setMargins((int) (3 * d), (int) (4 * d), (int) (3 * d), 0); r1.addView(b, lp); }
        body.addView(r1);
        final EditText copy = new EditText(c); copy.setHint("Type what you heard"); copy.setTextColor(Neo.TEXT); copy.setHintTextColor(Neo.DIM); copy.setTypeface(Neo.mono(c));
        copy.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        body.addView(copy);
        final TextView result = Neo.label(c, "", 0xFFCFE8D8, 13.5f, false); result.setTypeface(Neo.mono(c)); body.addView(result);
        TextView check = Neo.button(c, "Check", "check", Neo.AMBER); body.addView(check);
        play.setOnClickListener(v -> { sent[0] = MorseTrainer.groups(lesson[0], 5, new Random()); copy.setText(""); result.setText(""); playPcm(MorseTrainer.pcm(sent[0], wpm[0], fw[0], 650)); });
        again.setOnClickListener(v -> { if (!sent[0].isEmpty()) playPcm(MorseTrainer.pcm(sent[0], wpm[0], fw[0], 650)); });
        check.setOnClickListener(v -> {
            if (sent[0].isEmpty()) return;
            double sc = MorseTrainer.score(sent[0], copy.getText().toString());
            boolean pass = sc >= 0.9;
            result.setText(String.format(Locale.US, "%.0f %%  %s\nsent:  %s\nyou:   %s", sc * 100, pass ? (lesson[0] < MorseTrainer.LESSONS ? "✔ next lesson unlocked" : "✔ all characters done") : "keep going at this lesson", sent[0], copy.getText().toString().toUpperCase(Locale.US)));
            result.setTextColor(pass ? Neo.GREEN_LIGHT : Neo.AMBER_LIGHT);
            if (pass && lesson[0] < MorseTrainer.LESSONS) { lesson[0]++; save[0].run(); }
        });

        body.addView(Neo.sheetSection(c, "Sending practice"));
        body.addView(Neo.sheetHint(c, "Hold the key for dahs, tap for dits; after a pause of a second and a half the decoder shows what you sent and your speed."));
        final TextView key = Neo.button(c, "KEY", null, Neo.CYAN); key.setTextSize(22); key.setMinHeight((int) (110 * d));
        body.addView(key);
        final TextView sentOut = Neo.label(c, "", Neo.CYAN, 16, true); sentOut.setTypeface(Neo.mono(c)); body.addView(sentOut);
        final Handler h = new Handler(Looper.getMainLooper());
        final List<long[]> presses = new ArrayList<>();
        final long[] downAt = { 0 };
        final android.media.ToneGenerator[] tg = { null };
        final Runnable decode = () -> {
            if (presses.isEmpty()) return;
            long t0 = presses.get(0)[0], end = presses.get(presses.size() - 1)[1];
            short[] pcm = new short[(int) ((end - t0 + 2000) * 8)];
            for (long[] pr : presses) { int a = (int) ((pr[0] - t0 + 300) * 8), b = Math.min(pcm.length, (int) ((pr[1] - t0 + 300) * 8)); for (int i = a; i < b; i++) pcm[i] = (short) (12000 * Math.sin(2 * Math.PI * 700 * (i - a) / 8000.0)); }
            final String[] got = { "" }; final int[] speed = { 0 };
            CwDecoder dec = new CwDecoder((text, hz, w) -> { got[0] = text; speed[0] = w; }, false);
            dec.process(pcm); dec.process(new short[16000]);
            sentOut.setText(got[0].isEmpty() ? "(not readable yet: keep dits short and dahs three times as long)" : got[0] + String.format(Locale.US, "   ≈ %d WPM", speed[0]));
            presses.clear();
        };
        key.setOnTouchListener((v, e) -> {
            if (e.getAction() == MotionEvent.ACTION_DOWN) {
                h.removeCallbacks(decode); downAt[0] = System.currentTimeMillis();
                try { if (tg[0] == null) tg[0] = new android.media.ToneGenerator(AudioManager.STREAM_MUSIC, 70); tg[0].startTone(android.media.ToneGenerator.TONE_SUP_DIAL); } catch (Throwable ignored) { }
                v.setPressed(true); return true;
            }
            if (e.getAction() == MotionEvent.ACTION_UP || e.getAction() == MotionEvent.ACTION_CANCEL) {
                if (tg[0] != null) tg[0].stopTone();
                presses.add(new long[] { downAt[0], System.currentTimeMillis() });
                h.postDelayed(decode, 1500); v.setPressed(false); return true;
            }
            return false;
        });
        AlertDialog a = Neo.showSheet(c, body);
        a.setOnDismissListener(x -> { h.removeCallbacks(decode); if (tg[0] != null) tg[0].release(); });
    }

    private static LinearLayout stepper(Context c, TextView label, Runnable minus, Runnable plus) {
        float d = Theme.dp(c);
        LinearLayout r = new LinearLayout(c); r.setGravity(Gravity.CENTER_VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (4 * d), (int) (4 * d), (int) (4 * d));
        r.addView(label, new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f));
        TextView m = Neo.button(c, "−", null, Neo.CYAN), pl = Neo.button(c, "+", null, Neo.CYAN);
        m.setOnClickListener(v -> minus.run()); pl.setOnClickListener(v -> plus.run());
        r.addView(m, new LinearLayout.LayoutParams((int) (56 * d), (int) (48 * d))); r.addView(pl, new LinearLayout.LayoutParams((int) (56 * d), (int) (48 * d)));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); lp.topMargin = (int) (6 * d); r.setLayoutParams(lp);
        return r;
    }

    private static void playPcm(final short[] pcm) {
        new Thread(() -> {
            try {
                AudioTrack t = new AudioTrack(AudioManager.STREAM_MUSIC, 8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT, pcm.length * 2, AudioTrack.MODE_STATIC);
                t.write(pcm, 0, pcm.length); t.play(); Thread.sleep(pcm.length / 8 + 300); t.release();
            } catch (Throwable ignored) { }
        }, "trainer-play").start();
    }
}
