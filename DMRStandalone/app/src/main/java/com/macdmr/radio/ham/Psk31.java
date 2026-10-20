package com.macdmr.radio.ham;

/**
 * PSK31 (BPSK, 31.25 baud, varicode), the keyboard mode of fldigi and other sound-card programs. 8 kHz mono audio.
 *
 * Transmit: a zero is a phase reversal (with the amplitude shaped by a cosine so the signal stays narrow), a one keeps
 * the phase; characters are varicode words separated by "00". A second of reversals leads, a second of steady
 * carrier ends.
 *
 * Receive: every half second, while nothing is being decoded, the strongest narrow carrier between 300 and 2700 Hz
 * is looked for. The signal is mixed to baseband with an NCO, low-passed over a symbol, and the symbol centre is found
 * from where the envelope is largest across the last symbols. Consecutive centres are compared: the same phase is a
 * one, a reversal a zero. The NCO follows the carrier from the phase steps (squared, which removes the data).
 */
public final class Psk31 {
    private static final int SR = 8000, SPS = 256;              // samples per symbol at 31.25 baud

    /** Varicode for ASCII 0..127 (the standard table from G3PLX). */
    static final String[] VARICODE = {
        "1010101011", "1011011011", "1011101101", "1101110111", "1011101011", "1101011111", "1011101111", "1011111101",
        "1011111111", "11101111", "11101", "1101101111", "1011011101", "11111", "1101110101", "1110101011",
        "1011110111", "1011110101", "1110101101", "1110101111", "1101011011", "1101101011", "1101101101", "1101010111",
        "1101111011", "1101111101", "1110110111", "1101010101", "1101011101", "1110111011", "1011111011", "1101111111",
        "1", "111111111", "101011111", "111110101", "111011011", "1011010101", "1010111011", "101111111",
        "11111011", "11110111", "101101111", "111011111", "1110101", "110101", "1010111", "110101111",
        "10110111", "10111101", "11101101", "11111111", "101110111", "101011011", "101101011", "110101101",
        "110101011", "110110111", "11110101", "110111101", "111101101", "1010101", "111010111", "1010101111",
        "1010111101", "1111101", "11101011", "10101101", "10110101", "1110111", "11011011", "11111101",
        "101010101", "1111111", "111111101", "101111101", "11010111", "10111011", "11011101", "10101011",
        "11010101", "111011101", "10101111", "1101111", "1101101", "101010111", "110110101", "101011101",
        "101110101", "101111011", "1010101101", "111110111", "111101111", "111111011", "1010111111", "101101101",
        "1011011111", "1011", "1011111", "101111", "101101", "11", "111101", "1011011",
        "101011", "1101", "111101011", "10111111", "11011", "111011", "1111", "111",
        "111111", "110111111", "10101", "10111", "101", "110111", "1111011", "1101011",
        "11011111", "1011101", "111010101", "1010110111", "110111011", "1010110101", "1011010111", "1110110101" };

    // ---- transmit ---------------------------------------------------------------------------------

    public static short[] encode(String text, double hz) {
        StringBuilder bits = new StringBuilder();
        for (int i = 0; i < 32; i++) bits.append('0');                      // about a second of reversals for the receiver to lock
        for (char ch : text.replace("\n", "\r\n").toCharArray()) { if (ch < 128) bits.append(VARICODE[ch]).append("00"); }
        for (int i = 0; i < 32; i++) bits.append('1');                      // steady carrier to finish
        short[] out = new short[bits.length() * SPS];
        double phase = 0; int sign = 1;
        for (int k = 0; k < bits.length(); k++) {
            boolean rev = bits.charAt(k) == '0';
            for (int i = 0; i < SPS; i++) {
                double a = rev ? Math.cos(Math.PI * i / SPS) : 1;                // reversal: amplitude goes through zero mid-symbol...
                double amp = rev ? (i < SPS / 2 ? Math.abs(a) * sign : -Math.abs(a) * sign) : sign;
                phase += 2 * Math.PI * hz / SR;
                out[k * SPS + i] = (short) (14000 * amp * Math.sin(phase));
            }
            if (rev) sign = -sign;                                             // ...and comes back with the opposite sign
        }
        int edge = 200; for (int i = 0; i < edge; i++) { double g = i / (double) edge; out[i] *= g; out[out.length - 1 - i] *= g; }
        return out;
    }

    // ---- receive ----------------------------------------------------------------------------------

    public interface Listener { void onChar(char c); }

    private final Listener listener;
    private double freq = 1000, nco;
    private final double[] bi = new double[SPS], bq = new double[SPS]; private int bp;   // last symbol of mixed samples
    private double si, sq;                                                              // running sums over a symbol (boxcar)
    private final double[] env = new double[SPS]; private int pos;                       // envelope by position in the symbol
    private int centre = -1, sinceSym; private double pi0, pq0; private boolean havePrev; private double quality; private int symbols, countdown = SPS;
    private int bitsWord; private int ones; private final StringBuilder word = new StringBuilder();
    private final short[] hist = new short[4096]; private int hp, sinceTune; private boolean locked; private long quietSyms;

    public Psk31(Listener l) { listener = l; }
    public double freq() { return freq; }
    public boolean locked() { return locked; }

    public void process(short[] x) { for (short v : x) sample(v); }
    public void process(byte[] mono, int n) { for (int i = 0; i + 1 < n; i += 2) sample((short) ((mono[i] & 0xFF) | (mono[i + 1] << 8))); }

    private void sample(short v) {
        hist[hp] = v; hp = (hp + 1) & (hist.length - 1);
        if (++sinceTune >= SR / 2) { sinceTune = 0; if (!locked) tune(); }
        double x = v / 32768.0;
        nco += 2 * Math.PI * freq / SR; if (nco > 2 * Math.PI) nco -= 2 * Math.PI;
        double i = x * Math.cos(nco), q = -x * Math.sin(nco);
        si += i - bi[bp]; sq += q - bq[bp]; bi[bp] = i; bq[bp] = q; bp = (bp + 1) % SPS;      // boxcar over one symbol: matched filter
        double e = si * si + sq * sq;
        env[pos] = 0.9 * env[pos] + 0.1 * e;
        pos = (pos + 1) % SPS;
        if (pos == 0) {                                                                      // once a symbol: where is the envelope largest?
            int best = 0; for (int k = 1; k < SPS; k++) if (env[k] > env[best]) best = k;
            centre = best;
        }
        if (!locked || centre < 0) return;
        if (--countdown <= 0) {                                                             // a symbol clock, nudged toward the envelope peak
            symbol(si, sq);
            int here = (pos - 1 + SPS) % SPS, err = ((centre - here) % SPS + SPS + SPS / 2) % SPS - SPS / 2;   // -128..127, wrap-safe
            countdown = SPS + Math.max(-16, Math.min(16, err / 4));
        }
    }

    private void symbol(double i, double q) {
        if (havePrev) {
            double dot = i * pi0 + q * pq0, cross = q * pi0 - i * pq0;
            boolean one = dot > 0;
            // carrier tracking: the phase step doubled has no data in it
            double ang = Math.atan2(2 * dot * cross, dot * dot - cross * cross) / 2;
            // quality: a clean PSK step is a clear 0 or 180 degrees (cos^2 near 1); noise averages 0.5
            double m2 = (i * i + q * q) * (pi0 * pi0 + pq0 * pq0), c2 = m2 > 0 ? dot * dot / m2 : 0;
            if (c2 > 0.6 && symbols > 16) freq += ang / (2 * Math.PI) * 31.25 * 0.1;   // follow only clean steps, once the symbol timing has settled
            quality += 0.1 * (c2 - quality);
            if (quality < 0.7) { quietSyms++; word.setLength(0); if (quietSyms > 60) { locked = false; quietSyms = 0; } }   // no signal: say nothing, look again
            else { quietSyms = 0; bit(one); }
        }
        pi0 = i; pq0 = q; havePrev = true; symbols++;
    }

    private void bit(boolean one) {
        if (one) { word.append('1'); ones = 0; return; }
        if (word.length() > 0 && word.charAt(word.length() - 1) == '0') {                    // "00": the word ended
            word.setLength(word.length() - 1);
            if (word.length() > 0) { char ch = decode(word.toString()); if (ch != 0 && ch != '\r') listener.onChar(ch); }
            word.setLength(0);
            return;
        }
        if (word.length() > 0) word.append('0');
        if (word.length() > 12) word.setLength(0);                                          // no varicode is that long: noise
    }

    static char decode(String code) { for (int c = 0; c < VARICODE.length; c++) if (VARICODE[c].equals(code)) return (char) c; return 0; }

    /** The strongest PSK31 signal (about 60 Hz wide): carrier and the two reversal lines together. */
    private void tune() {
        int n = 4096, start = hp;
        double best = 0, bestHz = 0, sum = 0; int cnt = 0;
        for (double f = 300; f <= 2700; f += 2) {
            // a steady carrier sits at f; reversals put two lines 15.6 Hz either side and none at f
            double a = goertzel(start, n, f) + goertzel(start, n, f - 15.625) + goertzel(start, n, f + 15.625);
            sum += a; cnt++; if (a > best) { best = a; bestHz = f; }
        }
        double mean = sum / Math.max(1, cnt);
        if (best > 8 * mean && (!locked || Math.abs(bestHz - freq) > 6)) { freq = bestHz; locked = true; quietSyms = 0; havePrev = false; quality = 0.8; symbols = 0; java.util.Arrays.fill(env, 0); }
    }
    private double goertzel(int start, int n, double hz) {
        double w = 2 * Math.PI * hz / SR, c = 2 * Math.cos(w), s1 = 0, s2 = 0;
        for (int i = 0; i < n; i++) { double s0 = hist[(start + i) & (hist.length - 1)] + c * s1 - s2; s2 = s1; s1 = s0; }
        return Math.sqrt(Math.max(0, s1 * s1 + s2 * s2 - c * s1 * s2)) / n;
    }
}
