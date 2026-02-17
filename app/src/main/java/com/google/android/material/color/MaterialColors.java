package com.google.android.material.color;

import android.content.Context;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.View;
import androidx.annotation.AttrRes;
import androidx.annotation.ColorInt;
import androidx.annotation.FloatRange;
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.core.graphics.ColorUtils;
import com.google.android.material.R;
import com.google.android.material.resources.MaterialAttributes;

public class MaterialColors {
    public static final float ALPHA_DISABLED = 0.38f;
    public static final float ALPHA_DISABLED_LOW = 0.12f;
    public static final float ALPHA_FULL = 1.0f;
    public static final float ALPHA_LOW = 0.32f;
    public static final float ALPHA_MEDIUM = 0.54f;
    private static final int TONE_ACCENT_CONTAINER_DARK = 20;
    private static final int TONE_ACCENT_CONTAINER_LIGHT = 90;
    private static final int TONE_ACCENT_DARK = 70;
    private static final int TONE_ACCENT_LIGHT = 40;
    private static final int TONE_ON_ACCENT_CONTAINER_DARK = 80;
    private static final int TONE_ON_ACCENT_CONTAINER_LIGHT = 10;
    private static final int TONE_ON_ACCENT_DARK = 10;
    private static final int TONE_ON_ACCENT_LIGHT = 100;

    private MaterialColors() {
    }

    @ColorInt
    public static int getColor(@NonNull View view, @AttrRes int i) {
        return MaterialAttributes.resolveOrThrow(view, i);
    }

    @ColorInt
    public static int getColor(Context context, @AttrRes int i, String str) {
        return MaterialAttributes.resolveOrThrow(context, i, str);
    }

    @ColorInt
    public static int getColor(@NonNull View view, @AttrRes int i, @ColorInt int i2) {
        return getColor(view.getContext(), i, i2);
    }

    @ColorInt
    public static int getColor(@NonNull Context context, @AttrRes int i, @ColorInt int i2) {
        TypedValue resolve = MaterialAttributes.resolve(context, i);
        return resolve != null ? resolve.data : i2;
    }

    @ColorInt
    public static int layer(@NonNull View view, @AttrRes int i, @AttrRes int i2) {
        return layer(view, i, i2, 1.0f);
    }

    @ColorInt
    public static int layer(@NonNull View view, @AttrRes int i, @AttrRes int i2, @FloatRange(from = 0.0d, to = 1.0d) float f) {
        return layer(getColor(view, i), getColor(view, i2), f);
    }

    @ColorInt
    public static int layer(@ColorInt int i, @ColorInt int i2, @FloatRange(from = 0.0d, to = 1.0d) float f) {
        return layer(i, ColorUtils.setAlphaComponent(i2, Math.round(((float) Color.alpha(i2)) * f)));
    }

    @ColorInt
    public static int layer(@ColorInt int i, @ColorInt int i2) {
        return ColorUtils.compositeColors(i2, i);
    }

    @ColorInt
    public static int compositeARGBWithAlpha(@ColorInt int i, @IntRange(from = 0, to = 255) int i2) {
        return ColorUtils.setAlphaComponent(i, (Color.alpha(i) * i2) / 255);
    }

    public static boolean isColorLight(@ColorInt int i) {
        return i != 0 && ColorUtils.calculateLuminance(i) > 0.5d;
    }

    @ColorInt
    public static int harmonizeWithPrimary(@NonNull Context context, @ColorInt int i) {
        return harmonize(i, getColor(context, R.attr.colorPrimary, MaterialColors.class.getCanonicalName()));
    }

    @ColorInt
    public static int harmonize(@ColorInt int i, @ColorInt int i2) {
        return Blend.harmonize(i, i2);
    }

    @NonNull
    public static ColorRoles getColorRoles(@NonNull Context context, @ColorInt int i) {
        return getColorRoles(i, MaterialAttributes.resolveBoolean(context, R.attr.isLightTheme, true));
    }

    @NonNull
    public static ColorRoles getColorRoles(@ColorInt int i, boolean z) {
        if (z) {
            return new ColorRoles(getColorRole(i, 40), getColorRole(i, 100), getColorRole(i, 90), getColorRole(i, 10));
        }
        return new ColorRoles(getColorRole(i, 70), getColorRole(i, 10), getColorRole(i, 20), getColorRole(i, 80));
    }

    @ColorInt
    private static int getColorRole(@ColorInt int i, @IntRange(from = 0, to = 100) int i2) {
        Hct fromInt = Hct.fromInt(i);
        fromInt.setTone((float) i2);
        return fromInt.toInt();
    }
}
