package com.macdmr.radio.ui;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.BitmapFactory;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.macdmr.radio.ham.ExamPool;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.Set;

/** Licence exam practice from the FCC question pools: practice exams, study by subelement, missed questions. */
public final class ExamDialog {
    private final Context c; private final float d; private final SharedPreferences prefs;
    private AlertDialog dlg; private LinearLayout body; private ScrollView scroll;

    private ExamDialog(Context c) { this.c = c; d = Theme.dp(c); prefs = c.getSharedPreferences("exam", Context.MODE_PRIVATE); }
    public static void show(Context c) { new ExamDialog(c).home(); }

    private ExamPool load(ExamPool.Element e) {
        try (InputStream in = c.getAssets().open(e.asset)) {
            java.io.ByteArrayOutputStream o = new java.io.ByteArrayOutputStream(); byte[] b = new byte[16384]; int n; while ((n = in.read(b)) > 0) o.write(b, 0, n);
            return ExamPool.parse(new String(o.toByteArray(), StandardCharsets.UTF_8));
        } catch (Throwable t) { Toast.makeText(c, "Could not read the question pool: " + t.getMessage(), Toast.LENGTH_LONG).show(); return null; }
    }

    /** One sheet for the whole session: each screen replaces its content. */
    private void page(String title) {
        LinearLayout b = Neo.sheetBody(c, title);
        if (dlg == null) {
            scroll = new ScrollView(c); scroll.setVerticalScrollBarEnabled(false); scroll.addView(b);
            dlg = new AlertDialog.Builder(c).setView(scroll).create(); dlg.show();
            if (dlg.getWindow() != null) dlg.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(0));
        } else { scroll.removeAllViews(); scroll.addView(b); scroll.scrollTo(0, 0); }
        body = b;
    }
    private Set<String> missed(ExamPool.Element e) { return new HashSet<>(prefs.getStringSet("missed_" + e.key, new HashSet<>())); }

    private void home() {
        page("Exam practice");
        body.addView(Neo.sheetHint(c, "Practice for the US amateur licence exams with the official question pools. A practice exam draws one question from each group, as the real exam does; you need 26 of 35 right (37 of 50 for Extra). The pools are public domain (NCVEC); machine-readable edition by Russ Olsen."));
        for (ExamPool.Element e : ExamPool.ELEMENTS) {
            int best = prefs.getInt("best_" + e.key, -1);
            LinearLayout r = card(e.name, e.questions + " questions, pass at " + e.pass + (best >= 0 ? "  ·  best " + best + "/" + e.questions : "") + "  ·  " + missed(e).size() + " missed to review");
            r.setOnClickListener(v -> element(e));
            body.addView(r);
        }
    }

    private void element(ExamPool.Element e) {
        ExamPool p = load(e); if (p == null) return;
        page(e.name.replaceFirst(" \\(.*", ""));
        body.addView(Neo.sheetHint(c, p.all.size() + " questions in the pool."));
        TextView exam = Neo.button(c, "Practice exam (" + e.questions + " questions)", "check", Neo.GREEN); body.addView(exam, lp(6));
        exam.setOnClickListener(v -> quiz(e, p.exam(new Random()), true, 0, new ArrayList<>()));
        final Set<String> miss = missed(e);
        TextView again = Neo.button(c, "Missed questions (" + miss.size() + ")", "update", Neo.AMBER); body.addView(again, lp(6));
        again.setOnClickListener(v -> {
            List<ExamPool.Question> l = new ArrayList<>(); for (ExamPool.Question q : p.all) if (miss.contains(q.id)) l.add(q);
            if (l.isEmpty()) { Toast.makeText(c, "Nothing missed yet", Toast.LENGTH_SHORT).show(); return; }
            java.util.Collections.shuffle(l); quiz(e, l, false, 0, new ArrayList<>());
        });
        body.addView(Neo.sheetSection(c, "Study a subelement"));
        for (java.util.Map.Entry<String, Integer> s : p.subelements().entrySet()) {
            LinearLayout r = card(s.getKey(), s.getValue() + " questions, with the answer shown after each");
            r.setOnClickListener(v -> quiz(e, p.subelement(s.getKey(), true, new Random()), false, 0, new ArrayList<>()));
            body.addView(r);
        }
        TextView back = Neo.button(c, "Back", null, Neo.CYAN); body.addView(back, lp(10)); back.setOnClickListener(v -> home());
    }

    /** Question {@code i} of {@code qs}; {@code exam}: no feedback until the end. {@code wrong} collects the misses. */
    private void quiz(ExamPool.Element e, List<ExamPool.Question> qs, boolean exam, int i, List<Object[]> wrong) {
        if (i >= qs.size()) { results(e, qs, exam, wrong); return; }
        ExamPool.Question q = qs.get(i);
        page((exam ? "Exam " : "Study ") + (i + 1) + " of " + qs.size());
        body.addView(Neo.label(c, q.id, Theme.CYAN, 13, true));
        TextView t = Neo.text(c, q.text, Neo.TEXT, 17, Neo.uiMedium(c)); t.setLineSpacing(0, 1.12f); t.setPadding(0, (int) (6 * d), 0, (int) (8 * d)); body.addView(t);
        if (!q.figure.isEmpty()) {
            try (InputStream in = c.getAssets().open("exam/" + q.figure)) {
                ImageView iv = new ImageView(c); iv.setImageBitmap(BitmapFactory.decodeStream(in)); iv.setAdjustViewBounds(true); iv.setBackgroundColor(0xFFFFFFFF); iv.setPadding((int) (6 * d), (int) (6 * d), (int) (6 * d), (int) (6 * d));
                body.addView(iv, lp(4));
            } catch (Throwable ignored) { }
        }
        final TextView[] bs = new TextView[q.answers.length];
        final boolean[] answered = { false };
        for (int k = 0; k < q.answers.length; k++) {
            final int pick = k;
            bs[k] = Neo.button(c, (char) ('A' + k) + ".  " + q.answers[k], null, Neo.CYAN); bs[k].setGravity(android.view.Gravity.START | android.view.Gravity.CENTER_VERTICAL); bs[k].setTextSize(15);
            body.addView(bs[k], lp(6));
            bs[k].setOnClickListener(v -> {
                if (answered[0]) return; answered[0] = true;
                boolean right = pick == q.correct;
                Set<String> miss = missed(e); if (right) miss.remove(q.id); else miss.add(q.id);
                prefs.edit().putStringSet("missed_" + e.key, miss).apply();
                if (!right) wrong.add(new Object[] { q, pick });
                if (exam) { quiz(e, qs, true, i + 1, wrong); return; }
                bs[q.correct].setBackground(Neo.outline(c, Neo.GREEN, 0x44, 12, 2)); bs[q.correct].setTextColor(Neo.GREEN_LIGHT);
                if (!right) { bs[pick].setBackground(Neo.outline(c, Neo.RED, 0x33, 12, 2)); bs[pick].setTextColor(Neo.RED); }
                TextView next = Neo.button(c, right ? "Right — next" : "The answer is " + (char) ('A' + q.correct) + " — next", null, right ? Neo.GREEN : Neo.AMBER);
                body.addView(next, lp(12)); next.setOnClickListener(x -> quiz(e, qs, false, i + 1, wrong));
            });
        }
        TextView stop = Neo.button(c, "Stop", null, Neo.MUTED); body.addView(stop, lp(16)); stop.setOnClickListener(v -> results(e, qs.subList(0, i), exam, wrong));
    }

    private void results(ExamPool.Element e, List<ExamPool.Question> qs, boolean exam, List<Object[]> wrong) {
        int right = qs.size() - wrong.size();
        page(exam ? "Exam result" : "Study result");
        boolean full = exam && qs.size() == e.questions;
        boolean pass = full && right >= e.pass;
        TextView big = Neo.text(c, right + " / " + qs.size(), full ? (pass ? Neo.GREEN_LIGHT : Neo.AMBER_LIGHT) : Neo.CYAN_LIGHT, 40, Neo.display(c)); big.setGravity(android.view.Gravity.CENTER); body.addView(big);
        body.addView(Neo.sheetHint(c, full ? (pass ? "Pass: " + e.pass + " were needed." : "Not yet: " + e.pass + " are needed. Review the misses below, then try again.") : String.format(Locale.US, "%.0f %% right. Misses are kept under Missed questions until you answer them right.", qs.isEmpty() ? 0 : 100.0 * right / qs.size())));
        if (full && right > prefs.getInt("best_" + e.key, -1)) prefs.edit().putInt("best_" + e.key, right).apply();
        if (!wrong.isEmpty()) body.addView(Neo.sheetSection(c, "Missed"));
        for (Object[] w : wrong) {
            ExamPool.Question q = (ExamPool.Question) w[0]; int pick = (Integer) w[1];
            LinearLayout r = new LinearLayout(c); r.setOrientation(LinearLayout.VERTICAL); r.setBackground(Neo.rowCard(c)); r.setPadding((int) (12 * d), (int) (8 * d), (int) (12 * d), (int) (8 * d));
            r.addView(Neo.label(c, q.id + "  " + q.text, Neo.TEXT, 13.5f, false));
            r.addView(Neo.label(c, "Answer " + (char) ('A' + q.correct) + ": " + q.answers[q.correct], Neo.GREEN_LIGHT, 13, false));
            r.addView(Neo.label(c, "You chose " + (char) ('A' + pick) + ": " + q.answers[pick], 0xFFE08A80, 12.5f, false));
            body.addView(r, lp(6));
        }
        TextView again = Neo.button(c, "Back to " + e.name.replaceFirst(" \\(.*", ""), null, Neo.CYAN); body.addView(again, lp(12)); again.setOnClickListener(v -> element(e));
    }

    private LinearLayout card(String title, String sub) {
        LinearLayout v = new LinearLayout(c); v.setOrientation(LinearLayout.VERTICAL); v.setBackground(Neo.rowCard(c)); v.setPadding((int) (14 * d), (int) (10 * d), (int) (12 * d), (int) (10 * d));
        v.addView(Neo.text(c, title, Neo.TEXT, 16, Neo.ui(c))); TextView s = Neo.text(c, sub, Neo.MUTED, 13, Neo.uiMedium(c)); s.setPadding(0, (int) (2 * d), 0, 0); v.addView(s);
        v.setClickable(true); v.setLayoutParams(lp(6)); return v;
    }
    private LinearLayout.LayoutParams lp(int top) { LinearLayout.LayoutParams l = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT); l.topMargin = (int) (top * d); return l; }
}
