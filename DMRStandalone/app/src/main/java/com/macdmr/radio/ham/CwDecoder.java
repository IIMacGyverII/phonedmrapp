package com.macdmr.radio.ham;

/**
 * Morse code (MCW: a keyed audio tone, as repeaters send their identification) from the 8 kHz receive audio.
 *
 * 1. Every 128 ms the strongest tone between 400 and 1100 Hz is looked for (Goertzel bins 20 Hz apart over the
 *    last 256 ms). A tone counts when it stands well above the other bins and stays within 40 Hz on consecutive
 *    looks; voice, static and the two tones of DTMF do not.
 * 2. Every 5 ms the level at that tone gives an envelope; a threshold halfway between the noise floor and the
 *    tone level (with hysteresis) turns it into key-down and key-up times.
 * 3. Marks shorter than two units are dits, longer ones dahs; gaps of 2 to 5 units end a letter and longer ones a
 *    word. The unit adapts to the sender's speed (5 to 40 words per minute).
 * 4. When the tone has been gone for a while the text is handed to the listener, if it looks like Morse rather
 *    than chance (at least three characters, mostly known codes).
 */
public final class CwDecoder {
    public interface Listener { void onText(String text, double toneHz, int wpm); }

    private static final int SR = 8000, STEP = 40, LOOK = 1024, LOOK_EVERY = 1024;    // 5 ms envelope, 128 ms between looks
    private static final double LO = 400, HI = 1100, BIN = 20;

    private final Listener listener;
    private final short[] ring = new short[4096]; private int ringPos;     // 512 ms: replayed when the tone is recognised
    private int sinceLook, stepFill;
    private final short[] step = new short[STEP];
    private double tone, candidate; private int stableLooks;
    private double sigLevel = 0, floor = 0; private boolean keyDown;
    private int markSteps, spaceSteps;
    private double unitSteps = 0;                     // estimated dit length in 5 ms steps (0 = unknown)
    private int unknown;
    private long idleSteps;

    private final boolean strict;
    public CwDecoder(Listener l) { this(l, true); }
    /** {@code strict} false: report any text (the trainer's sending practice), not only what looks like an identification. */
    public CwDecoder(Listener l, boolean strict) { listener = l; this.strict = strict; }

    /** 8 kHz mono 16-bit little-endian. */
    public void process(byte[] mono, int n) {
        for (int i = 0; i + 1 < n; i += 2) sample((short) ((mono[i] & 0xFF) | (mono[i + 1] << 8)));
    }

    public void process(short[] pcm) { for (short s : pcm) sample(s); }

    /** The squelch closed or the channel changed: finish what was heard. */
    public void flush() { if (keyDown && markSteps >= 2) durations.add(markSteps); emit(); keyDown = false; markSteps = spaceSteps = 0; tone = 0; stableLooks = 0; }

    private void sample(short s) {
        ring[ringPos] = s; ringPos = (ringPos + 1) & (ring.length - 1);
        if (++sinceLook >= LOOK_EVERY) { sinceLook = 0; look(); }
        step[stepFill++] = s;
        if (stepFill == STEP) { stepFill = 0; envelope(); }
    }

    private double goertzel(short[] x, int off, int len, double hz, boolean fromRing) {
        double w = 2 * Math.PI * hz / SR, coeff = 2 * Math.cos(w), s1 = 0, s2 = 0;
        for (int i = 0; i < len; i++) {
            double v = fromRing ? x[(off + i) & (x.length - 1)] : x[off + i];
            double s0 = v + coeff * s1 - s2; s2 = s1; s1 = s0;
        }
        return Math.sqrt(Math.max(0, s1 * s1 + s2 * s2 - coeff * s1 * s2)) / len;
    }

    private void look() {
        int bins = (int) ((HI - LO) / BIN) + 1, start = (ringPos - LOOK) & (ring.length - 1);
        double[] m = new double[bins]; int best = 0;
        for (int b = 0; b < bins; b++) { m[b] = goertzel(ring, start, LOOK, LO + b * BIN, true); if (m[b] > m[best]) best = b; }
        double[] sorted = m.clone(); java.util.Arrays.sort(sorted);
        double median = sorted[bins / 2];
        // a pure tone: far above the median and not part of a pair (DTMF low + high, or voice harmonics at 2x)
        double hz = LO + best * BIN;
        double h2 = goertzel(ring, start, LOOK, hz * 2, true), hi = 0;
        for (double f : new double[] { 1209, 1336, 1477, 1633 }) hi = Math.max(hi, goertzel(ring, start, LOOK, f, true));   // DTMF high tones
        boolean pure = m[best] > 12 * Math.max(median, 1) && h2 < 0.3 * m[best] && hi < 0.3 * m[best];
        if (pure) {
            if (candidate > 0 && Math.abs(hz - candidate) <= 40) stableLooks++; else stableLooks = 1;
            candidate = hz;
            if (stableLooks >= 2 && (tone == 0 || Math.abs(tone - hz) > 40)) {
                if (tone != 0) flush();
                tone = hz;
                // start the levels from this look: noise per 5 ms step is the median bin scaled by sqrt(1024 / 40)
                floor = median * Math.sqrt((double) LOOK / STEP); sigLevel = Math.max(m[best], 2 * floor); keyDown = false; markSteps = spaceSteps = 0;
                replay();
            }
        }
    }

    /** The tone was only recognised after a few looks: run the envelope over the last 512 ms so the first letter is kept. */
    private void replay() {
        int span = ring.length - stepFill, skip = span % STEP;                   // whole steps ending where the step in progress begins
        int start = ringPos + skip;                                               // ringPos is also the oldest sample
        for (int k = 0; k + STEP <= span - skip; k += STEP) {
            short[] keep = step.clone();
            for (int i = 0; i < STEP; i++) step[i] = ring[(start + k + i) & (ring.length - 1)];
            envelope();
            System.arraycopy(keep, 0, step, 0, STEP);
        }
    }

    private void envelope() {
        if (tone == 0) { idle(); return; }
        double lvl = goertzel(step, 0, STEP, tone, false);
        // levels follow the tone (fast attack) and the gaps (slow) separately
        if (lvl > sigLevel) sigLevel += 0.5 * (lvl - sigLevel); else if (keyDown) sigLevel += 0.02 * (lvl - sigLevel);
        if (!keyDown) floor += (lvl < floor ? 0.3 : 0.02) * (lvl - floor);
        double th = floor + 0.5 * (sigLevel - floor), hyst = 0.1 * (sigLevel - floor);
        boolean on = keyDown ? lvl > th - hyst : lvl > th + hyst && sigLevel > 4 * Math.max(floor, 1);
        if (on) {
            if (!keyDown) {
                int last = durations.size() - 1;
                if (last >= 0) { if (durations.get(last) < 0) durations.set(last, durations.get(last) - spaceSteps); else durations.add(-spaceSteps); }   // after a click the gap simply goes on
                spaceSteps = 0; keyDown = true;
            }
            markSteps++; idleSteps = 0;
        } else {
            if (keyDown) { if (markSteps >= 2) durations.add(markSteps); markSteps = 0; keyDown = false; }   // under 10 ms: a click, not a dit
            spaceSteps++;
            idle();
        }
    }

    private void idle() {
        idleSteps++;
        if (idleSteps == 300) { emit(); tone = 0; stableLooks = 0; sigLevel = floor = 0; }   // 1.5 s of no keying: the message is over
    }

    /** Key-down lengths (positive) and the gaps between them (negative), in 5 ms steps, for the message so far. */
    private final java.util.ArrayList<Integer> durations = new java.util.ArrayList<>();

    /** The dit length from all marks: two clusters (dits, dahs about three times longer), or one when all are alike. */
    static double unitOf(java.util.List<Integer> marks) {
        int min = Integer.MAX_VALUE, max = 0; for (int m : marks) { min = Math.min(min, m); max = Math.max(max, m); }
        if (marks.isEmpty()) return 0;
        if (max < 2 * min) return max > 18 ? (min + max) / 6.0 : (min + max) / 2.0;     // all dahs if longer than 90 ms, else all dits
        double lo = min, hi = max;
        for (int it = 0; it < 10; it++) {
            double sl = 0, sh = 0; int nl = 0, nh = 0;
            for (int m : marks) { if (Math.abs(m - lo) <= Math.abs(m - hi)) { sl += m; nl++; } else { sh += m; nh++; } }
            if (nl > 0) lo = sl / nl; if (nh > 0) hi = sh / nh;
        }
        return (lo + hi / 3) / 2;
    }

    /** Turn the timings into text. */
    String decodeTimings() {
        java.util.List<Integer> marks = new java.util.ArrayList<>(); for (int d : durations) if (d > 0) marks.add(d);
        double u = unitOf(marks);
        // marks far shorter than a dit are noise: drop them (their gaps join) and judge the speed again
        java.util.ArrayList<Integer> clean = new java.util.ArrayList<>();
        for (int d : durations) {
            if (d > 0 && d < 0.4 * u) { if (!clean.isEmpty() && clean.get(clean.size() - 1) < 0) clean.set(clean.size() - 1, clean.get(clean.size() - 1) - d); continue; }
            if (d < 0 && !clean.isEmpty() && clean.get(clean.size() - 1) < 0) clean.set(clean.size() - 1, clean.get(clean.size() - 1) + d);
            else if (d < 0 && clean.isEmpty()) continue;
            else clean.add(d);
        }
        durations.clear(); durations.addAll(clean);
        marks.clear(); for (int d : durations) if (d > 0) marks.add(d);
        u = unitOf(marks); unitSteps = u;
        StringBuilder out = new StringBuilder(), sym = new StringBuilder(); unknown = 0;
        for (int d : durations) {
            if (d > 0) sym.append(d >= 2 * u ? '-' : '.');
            else if (-d >= 2 * u) { letter(sym, out); if (-d >= 5 * u) out.append(' '); }
        }
        letter(sym, out);
        String r = out.toString().trim(); while (r.contains("  ")) r = r.replace("  ", " "); return r;
    }

    private void letter(StringBuilder sym, StringBuilder out) {
        if (sym.length() == 0) return;
        char ch = decode(sym.toString());
        if (ch == 0) { unknown++; out.append('?'); } else out.append(ch);
        sym.setLength(0);
    }

    private void emit() {
        if (durations.isEmpty()) return;
        String t = decodeTimings(); durations.clear();
        int known = 0; for (char ch : t.toCharArray()) if (ch != ' ' && ch != '?') known++;
        double wpm = unitSteps > 0 ? 1200.0 / (unitSteps * 5) : 0;
        java.util.Set<Character> distinct = new java.util.HashSet<>(); for (char ch : t.toCharArray()) if (ch != ' ' && ch != '?') distinct.add(ch);
        boolean call = false; for (String w : t.split(" ")) if (Logbook.looksLikeCall(w.replace("/", ""))) call = true;
        boolean wordy = known >= 8 && distinct.size() >= 4;                     // plain text, not a few stray dits from paging tones or static
        if ((call || wordy || (!strict && known >= 1)) && unknown <= Math.max(1, known / 5) && wpm >= 4 && wpm <= 45) listener.onText(t, tone, (int) Math.round(wpm));
    }

    private static final String LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/=?.,";
    private static final String[] CODES = {
            ".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-",
            "..-", "...-", ".--", "-..-", "-.--", "--..",
            "-----", ".----", "..---", "...--", "....-", ".....", "-....", "--...", "---..", "----.", "-..-.", "-...-", "..--..", ".-.-.-", "--..--" };

    static char decode(String code) { for (int i = 0; i < CODES.length; i++) if (CODES[i].equals(code)) return LETTERS.charAt(i); return 0; }
}
