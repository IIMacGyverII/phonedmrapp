package com.google.android.material.slider;

import androidx.annotation.NonNull;
import java.util.Locale;

public final class BasicLabelFormatter implements LabelFormatter {
    private static final int BILLION = 1000000000;
    private static final int MILLION = 1000000;
    private static final int THOUSAND = 1000;
    private static final long TRILLION = 1000000000000L;

    @NonNull
    public String getFormattedValue(float f) {
        if (f >= 1.0E12f) {
            return String.format(Locale.US, "%.1fT", new Object[]{Float.valueOf(f / 1.0E12f)});
        } else if (f >= 1.0E9f) {
            return String.format(Locale.US, "%.1fB", new Object[]{Float.valueOf(f / 1.0E9f)});
        } else if (f >= 1000000.0f) {
            return String.format(Locale.US, "%.1fM", new Object[]{Float.valueOf(f / 1000000.0f)});
        } else if (f >= 1000.0f) {
            return String.format(Locale.US, "%.1fK", new Object[]{Float.valueOf(f / 1000.0f)});
        } else {
            return String.format(Locale.US, "%.0f", new Object[]{Float.valueOf(f)});
        }
    }
}
