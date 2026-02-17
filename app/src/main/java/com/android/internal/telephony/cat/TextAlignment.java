package com.android.internal.telephony.cat;

public enum TextAlignment {
    LEFT(0),
    CENTER(1),
    RIGHT(2),
    DEFAULT(3);
    
    private int mValue;

    private TextAlignment(int i) {
        this.mValue = i;
    }

    public static TextAlignment fromInt(int i) {
        for (TextAlignment textAlignment : values()) {
            if (textAlignment.mValue == i) {
                return textAlignment;
            }
        }
        return null;
    }
}
