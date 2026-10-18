package com.macdmr.radio.ui;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;

/** Satellite toggle for the new intercom look: line icon over a tracked label, outlined in its accent; on = filled and glowing. */
public class NeoToggle extends NeonToggle {
    private int accent;
    private Neo.IconDrawable icon;

    public NeoToggle(Context c, String iconName, String label, int accent) {
        super(c, "", label, Theme.SOFTSQ);
        this.accent = accent;
        setText(label); setLines(1); setTextSize(12); setTypeface(Neo.ui(c)); setLetterSpacing(0.1f);
        setGravity(Gravity.CENTER);
        icon = new Neo.IconDrawable(iconName, accent); int sz = Theme.dp(c, 21); icon.setBounds(0, 0, sz, sz);
        setCompoundDrawables(null, icon, null, null); setCompoundDrawablePadding(Theme.dp(c, 3));
        setPadding(Theme.dp(c, 2), Theme.dp(c, 6), Theme.dp(c, 2), Theme.dp(c, 6));
        setOn(false);
    }

    @Override public void setOn(boolean v) {
        super.setOn(v);
        if (icon == null) return;   // called from the parent constructor before this one has run
        Context c = getContext();
        GradientDrawable g = new GradientDrawable(); g.setCornerRadius(Theme.dp(c, 16));
        g.setColor(Neo.alpha(accent, v ? 0x40 : 0x12)); g.setStroke(Theme.dp(c, v ? 2 : 1.5f), v ? accent : Neo.alpha(accent, 0xB0));
        setBackground(g);
        setTextColor(v ? 0xFFFFFFFF : accent); icon.setColor(v ? 0xFFFFFFFF : accent);
    }
}
