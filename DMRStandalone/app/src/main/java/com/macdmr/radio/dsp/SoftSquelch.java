package com.macdmr.radio.dsp;

/**
 * Software squelch for analog channels, as the module does it: the radio's own squelch is left open
 * (sq=0) and the app decides what you hear. With a receive tone configured, the CTCSS detector gates the
 * audio; without one, the FM noise-squelch detector (high-band noise energy vs. level 1..9) does.
 * A hang time keeps the gate open across syllable gaps. Works on 8 kHz mono 16-bit PCM.
 */
public final class SoftSquelch {
    public static final long HANG_MS = 350;      // squelch tail: the detectors already smooth over 250-333 ms windows, a long hang only adds static after the other station unkeys
    private final CtcssDetector tone = new CtcssDetector(8000);
    private final NoiseSquelchDetector noise = new NoiseSquelchDetector(8000);
    private volatile boolean enabled;
    private volatile int level = 5;
    private volatile double toneHz = -1, adjLow = -1, adjHigh = -1;
    private boolean open;
    private long lastOpen;

    public void configure(boolean enabled, int level, int rxToneType, int rxToneCode) {
        this.enabled = enabled; this.level = Math.max(1, Math.min(9, level));
        if (rxToneType == 1) { toneHz = ToneTable.ctcssHz(rxToneCode); adjLow = ToneTable.ctcssHz(rxToneCode - 1); adjHigh = ToneTable.ctcssHz(rxToneCode + 1); }
        else toneHz = -1;
        tone.reset(); noise.reset(); open = false; lastOpen = 0;
    }

    public boolean isEnabled() { return enabled; }
    public int level() { return level; }
    public boolean isOpen() { return !enabled || open; }

    /** Feed one block of 8 kHz mono PCM; returns whether the gate is open for it. */
    public boolean process(byte[] mono, int len) {
        if (!enabled) return true;
        boolean shouldOpen;
        if (toneHz > 0) { tone.setFrequency(toneHz, adjLow, adjHigh); tone.process(mono, len); shouldOpen = tone.isPresent(); }
        else { noise.process(mono, len, level); shouldOpen = noise.isSignal(); }
        long now = System.currentTimeMillis();
        if (shouldOpen) { open = true; lastOpen = now; }
        else if (open && now - lastOpen > HANG_MS) open = false;
        return open;
    }

    public void reset() { tone.reset(); noise.reset(); open = false; lastOpen = 0; }
    /** The radio reported the carrier gone (RECEIVE_STOP): close at once instead of waiting for the detectors and the hang. */
    public void closeNow() { open = false; lastOpen = 0; tone.reset(); noise.reset(); }
}
