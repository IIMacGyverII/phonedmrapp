package com.google.android.material.color;

import androidx.annotation.NonNull;
import androidx.annotation.StyleRes;
import com.google.android.material.R;

public final class HarmonizedColorAttributes {
    private static final int[] HARMONIZED_MATERIAL_ATTRIBUTES = {R.attr.colorError, R.attr.colorOnError, R.attr.colorErrorContainer, R.attr.colorOnErrorContainer};
    private final int[] attributes;
    @StyleRes
    private final int themeOverlay;

    @NonNull
    public static HarmonizedColorAttributes create(@NonNull int[] iArr) {
        return new HarmonizedColorAttributes(iArr, 0);
    }

    @NonNull
    public static HarmonizedColorAttributes create(@NonNull int[] iArr, @StyleRes int i) {
        return new HarmonizedColorAttributes(iArr, i);
    }

    @NonNull
    public static HarmonizedColorAttributes createMaterialDefaults() {
        return create(HARMONIZED_MATERIAL_ATTRIBUTES, R.style.ThemeOverlay_Material3_HarmonizedColors);
    }

    private HarmonizedColorAttributes(@NonNull int[] iArr, @StyleRes int i) {
        if (i == 0 || iArr.length != 0) {
            this.attributes = iArr;
            this.themeOverlay = i;
            return;
        }
        throw new IllegalArgumentException("Theme overlay should be used with the accompanying int[] attributes.");
    }

    @NonNull
    public int[] getAttributes() {
        return this.attributes;
    }

    @StyleRes
    public int getThemeOverlay() {
        return this.themeOverlay;
    }
}
