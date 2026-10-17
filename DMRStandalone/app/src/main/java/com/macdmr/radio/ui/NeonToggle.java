package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.view.Gravity;
import android.widget.TextView;

/** Rounded satellite button (emoji + label) with an accent set: fill changes with the on/off state. */
public class NeonToggle extends TextView {
    private final int[] accent;
    private boolean on;
    private final String emoji, label;

    public NeonToggle(Context c, String emoji, String label, int[] accent) {
        super(c);
        this.accent = accent; this.emoji = emoji; this.label = label;
        setText(emoji + "\n" + label);
        setGravity(Gravity.CENTER); setTextSize(13); setTypeface(Typeface.DEFAULT_BOLD); setIncludeFontPadding(false); setLineSpacing(0, 0.95f);
        setTextColor(accent[3]); setLines(2);
        setPadding(Theme.dp(c, 2), 0, Theme.dp(c, 2), 0);
        setClickable(true); setFocusable(true);
        setOn(false);
    }

    public void setOn(boolean v) {
        on = v;
        setBackground(Theme.rounded(getContext(), v ? accent[0] : accent[1], v ? accent[2] : (accent[2] & 0x80FFFFFF), 2, 20));
    }

    public boolean isOn() { return on; }
    public void toggle() { setOn(!on); }
    public String labelText() { return label; }
}
