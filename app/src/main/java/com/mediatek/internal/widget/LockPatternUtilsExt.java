package com.mediatek.internal.widget;

public class LockPatternUtilsExt {
    private static final int ALLOWING_FR = 4;

    public static boolean isFRAllowedForUser(int i) {
        return (i & -5) == 0;
    }
}
