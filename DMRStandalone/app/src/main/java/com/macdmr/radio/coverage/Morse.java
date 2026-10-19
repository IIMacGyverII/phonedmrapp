package com.macdmr.radio.coverage;

import java.util.Locale;

/** Morse code audio at 8 kHz, for a short station identification (the key-up test). */
public final class Morse {
    private Morse() { }

    private static final String LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-";
    private static final String[] CODES = {
            ".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-",
            "..-", "...-", ".--", "-..-", "-.--", "--..",
            "-----", ".----", "..---", "...--", "....-", ".....", "-....", "--...", "---..", "----.", "-..-.", "-....-" };

    /** Code for one character, or null when it has none. */
    public static String code(char ch) { int i = LETTERS.indexOf(Character.toUpperCase(ch)); return i < 0 ? null : CODES[i]; }

    /** Length in dit units of a text: dit 1, dah 3, gap inside a letter 1, between letters 3, between words 7. */
    public static int units(String text) {
        int u = 0; boolean first = true;
        for (String word : text.trim().toUpperCase(Locale.US).split("\\s+")) {
            if (word.isEmpty()) continue;
            if (!first) u += 7; first = false;
            boolean firstLetter = true;
            for (char ch : word.toCharArray()) {
                String c = code(ch); if (c == null) continue;
                if (!firstLetter) u += 3; firstLetter = false;
                for (int k = 0; k < c.length(); k++) { if (k > 0) u += 1; u += c.charAt(k) == '-' ? 3 : 1; }
            }
        }
        return u;
    }

    /** 8 kHz mono PCM of the text at {@code wpm} words per minute (dit = 1200 / wpm ms), tone {@code hz}, 300 ms lead silence. */
    public static short[] pcm(String text, int wpm, double hz) {
        int dit = 8 * (1200 / wpm), lead = 8 * 300, edge = 40;
        short[] out = new short[lead + units(text) * dit + dit];
        int pos = lead; boolean first = true;
        for (String word : text.trim().toUpperCase(Locale.US).split("\\s+")) {
            if (word.isEmpty()) continue;
            if (!first) pos += 7 * dit; first = false;
            boolean firstLetter = true;
            for (char ch : word.toCharArray()) {
                String c = code(ch); if (c == null) continue;
                if (!firstLetter) pos += 3 * dit; firstLetter = false;
                for (int k = 0; k < c.length(); k++) {
                    if (k > 0) pos += dit;
                    int len = (c.charAt(k) == '-' ? 3 : 1) * dit;
                    for (int i = 0; i < len; i++) {
                        double env = Math.min(1.0, Math.min(i, len - 1 - i) / (double) edge);
                        out[pos + i] = (short) (11000 * env * Math.sin(2 * Math.PI * hz * i / 8000.0));
                    }
                    pos += len;
                }
            }
        }
        return out;
    }
}
