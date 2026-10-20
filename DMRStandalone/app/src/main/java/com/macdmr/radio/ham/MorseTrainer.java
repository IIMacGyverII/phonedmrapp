package com.macdmr.radio.ham;

import java.util.Random;

/**
 * Koch-method Morse trainer: characters are learned in the LCWO order, two at first, one more each time a lesson
 * is copied with at least 90 %. Groups are sent at full character speed with Farnsworth spacing (wider gaps), so
 * the sound of each character is learned rather than counted.
 */
public final class MorseTrainer {
    private MorseTrainer() { }

    public static final String KOCH = "KMURESNAPTLWI.JZ=FOY,VG5/Q92H38B?47C1D60X";
    public static final int LESSONS = KOCH.length() - 1;          // lesson 1 = K and M

    private static final String LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/=?.,";
    private static final String[] CODES = {
            ".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-",
            "..-", "...-", ".--", "-..-", "-.--", "--..",
            "-----", ".----", "..---", "...--", "....-", ".....", "-....", "--...", "---..", "----.", "-..-.", "-...-", "..--..", ".-.-.-", "--..--" };
    public static String code(char c) { int i = LETTERS.indexOf(Character.toUpperCase(c)); return i < 0 ? null : CODES[i]; }

    /** The characters of a lesson. */
    public static String chars(int lesson) { return KOCH.substring(0, Math.max(2, Math.min(KOCH.length(), lesson + 1))); }

    /** {@code groups} groups of five, the lesson's newest character at least twice as likely as the others. */
    public static String groups(int lesson, int groups, Random r) {
        String cs = chars(lesson); char newest = cs.charAt(cs.length() - 1);
        StringBuilder sb = new StringBuilder();
        for (int g = 0; g < groups; g++) {
            if (g > 0) sb.append(' ');
            for (int i = 0; i < 5; i++) sb.append(r.nextInt(3) == 0 ? newest : cs.charAt(r.nextInt(cs.length())));
        }
        return sb.toString();
    }

    /** Share of the sent characters copied right (edit distance on the characters, spaces ignored), 0..1. */
    public static double score(String sent, String copied) {
        String a = sent.replace(" ", "").toUpperCase(), b = copied == null ? "" : copied.replace(" ", "").toUpperCase();
        if (a.isEmpty()) return 1;
        int[] prev = new int[b.length() + 1], cur = new int[b.length() + 1];
        for (int j = 0; j <= b.length(); j++) prev[j] = j;
        for (int i = 1; i <= a.length(); i++) {
            cur[0] = i;
            for (int j = 1; j <= b.length(); j++) cur[j] = Math.min(Math.min(cur[j - 1] + 1, prev[j] + 1), prev[j - 1] + (a.charAt(i - 1) == b.charAt(j - 1) ? 0 : 1));
            int[] t = prev; prev = cur; cur = t;
        }
        return Math.max(0, 1 - prev[b.length()] / (double) a.length());
    }

    /**
     * Audio of {@code text} at 8 kHz: characters at {@code wpm}, gaps between characters and words stretched to an
     * effective {@code farnsworth} WPM (ARRL formula), tone {@code hz}, soft 5 ms edges.
     */
    public static short[] pcm(String text, int wpm, int farnsworth, double hz) {
        int sr = 8000; double dit = 1.2 / wpm;
        int f = Math.min(farnsworth, wpm);
        double ta = (60.0 * wpm - 37.2 * f) / (wpm * f);                 // total extra spacing per word, seconds
        double charGap = 3 * ta / 19, wordGap = 7 * ta / 19;
        if (f >= wpm) { charGap = 3 * dit; wordGap = 7 * dit; }
        java.util.ArrayList<double[]> seg = new java.util.ArrayList<>();  // {on 1/0, seconds}
        seg.add(new double[] { 0, 0.3 });
        boolean firstWord = true;
        for (String w : text.trim().split(" ")) {
            if (w.isEmpty()) continue;
            if (!firstWord) seg.add(new double[] { 0, wordGap }); firstWord = false;
            boolean firstChar = true;
            for (char ch : w.toCharArray()) {
                String c = code(ch); if (c == null) continue;
                if (!firstChar) seg.add(new double[] { 0, charGap }); firstChar = false;
                for (int k = 0; k < c.length(); k++) { if (k > 0) seg.add(new double[] { 0, dit }); seg.add(new double[] { 1, (c.charAt(k) == '-' ? 3 : 1) * dit }); }
            }
        }
        seg.add(new double[] { 0, 0.3 });
        int n = 0; for (double[] s : seg) n += (int) Math.round(s[1] * sr);
        short[] out = new short[n]; int p = 0, edge = 40;
        for (double[] s : seg) {
            int len = (int) Math.round(s[1] * sr);
            if (s[0] == 1) for (int i = 0; i < len; i++) { double e = Math.min(1, Math.min(i, len - 1 - i) / (double) edge); out[p + i] = (short) (12000 * e * Math.sin(2 * Math.PI * hz * i / sr)); }
            p += len;
        }
        return out;
    }
}
