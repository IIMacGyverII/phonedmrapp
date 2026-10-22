/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.ham;

/**
 * Ends a transmission when you stop talking: the microphone level is watched while keyed; once speech has been heard,
 * {@code hangMs} of quiet ends it. Quiet means below a threshold that follows the background (road noise) from below,
 * three times the floor and never under {@link #MIN_SPEECH}. If nobody speaks at all, it ends after {@link #NO_SPEECH_MS}.
 */
public final class VoxStop {
    public static final int MIN_SPEECH = 1500;
    public static final long NO_SPEECH_MS = 6000;
    private final long hangMs, startMs;
    private double floor = -1;
    private boolean spoke;
    private long lastLoudMs;

    public VoxStop(long hangMs, long startMs) { this.hangMs = hangMs; this.startMs = startMs; lastLoudMs = startMs; }

    /** One block's peak level (0..32767) at {@code now}; true when the transmission should end. */
    public boolean level(int peak, long now) {
        if (floor < 0) floor = peak;
        floor = peak < floor ? floor + 0.3 * (peak - floor) : floor + 0.002 * (peak - floor);    // falls fast, rises slowly
        double threshold = Math.max(MIN_SPEECH, floor * 3);
        if (peak > threshold) { spoke = true; lastLoudMs = now; }
        if (!spoke) return now - startMs >= NO_SPEECH_MS;
        return now - lastLoudMs >= hangMs;
    }
    public boolean spoke() { return spoke; }
}
