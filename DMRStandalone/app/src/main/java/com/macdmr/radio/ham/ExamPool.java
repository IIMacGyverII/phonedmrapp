/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

/**
 * An FCC amateur exam question pool (NCVEC, public domain; machine-readable edition by Russ Olsen, Apache-2.0) and
 * practice exams drawn the way real ones are: one question from each group (T1A, T1B…).
 */
public final class ExamPool {
    public static final class Question {
        public String id, text, figure; public String[] answers; public int correct;
        public String group() { return id.substring(0, 3); }
        public String subelement() { return id.substring(0, 2); }
    }
    public static final class Element {
        public final String key, name, asset; public final int questions, pass;
        Element(String key, String name, String asset, int questions, int pass) { this.key = key; this.name = name; this.asset = asset; this.questions = questions; this.pass = pass; }
    }
    public static final Element[] ELEMENTS = {
        new Element("tech", "Technician (Element 2, 2026–2030)", "exam/technician-2026-2030.json", 35, 26),
        new Element("general", "General (Element 3, 2023–2027)", "exam/general-2023-2027.json", 35, 26),
        new Element("extra", "Amateur Extra (Element 4, 2024–2028)", "exam/extra-2024-2028.json", 50, 37),
    };

    public final List<Question> all = new ArrayList<>();
    public final Map<String, List<Question>> byGroup = new LinkedHashMap<>();

    public static ExamPool parse(String json) throws Exception {
        ExamPool p = new ExamPool();
        JSONArray a = new JSONArray(json);
        for (int i = 0; i < a.length(); i++) {
            JSONObject o = a.getJSONObject(i);
            Question q = new Question();
            q.id = o.getString("id"); q.text = o.getString("question"); q.figure = o.optString("figure", ""); q.correct = o.getInt("correct");
            JSONArray an = o.getJSONArray("answers"); q.answers = new String[an.length()]; for (int k = 0; k < an.length(); k++) q.answers[k] = an.getString(k);
            p.all.add(q);
            List<Question> g = p.byGroup.get(q.group()); if (g == null) { g = new ArrayList<>(); p.byGroup.put(q.group(), g); } g.add(q);
        }
        return p;
    }

    /** One random question from each group, in pool order (as the exam is laid out). */
    public List<Question> exam(Random r) {
        List<Question> out = new ArrayList<>();
        for (List<Question> g : byGroup.values()) out.add(g.get(r.nextInt(g.size())));
        return out;
    }

    /** The subelements (T1 … T0) with their question counts. */
    public Map<String, Integer> subelements() {
        Map<String, Integer> m = new LinkedHashMap<>();
        for (Question q : all) m.put(q.subelement(), m.containsKey(q.subelement()) ? m.get(q.subelement()) + 1 : 1);
        return m;
    }

    public List<Question> subelement(String sub, boolean shuffle, Random r) {
        List<Question> out = new ArrayList<>(); for (Question q : all) if (q.subelement().equals(sub)) out.add(q);
        if (shuffle) Collections.shuffle(out, r);
        return out;
    }
}
