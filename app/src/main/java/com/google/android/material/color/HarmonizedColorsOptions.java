package com.google.android.material.color;

import android.content.Context;
import androidx.annotation.AttrRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.StyleRes;
import com.google.android.material.R;

public class HarmonizedColorsOptions {
    @AttrRes
    private final int colorAttributeToHarmonizeWith;
    @Nullable
    private final HarmonizedColorAttributes colorAttributes;
    @NonNull
    private final int[] colorResourceIds;
    @NonNull
    private final Context context;

    @NonNull
    public static HarmonizedColorsOptions createMaterialDefaults(@NonNull Context context2) {
        return new Builder(context2).setColorAttributes(HarmonizedColorAttributes.createMaterialDefaults()).build();
    }

    private HarmonizedColorsOptions(Builder builder) {
        this.context = builder.context;
        this.colorResourceIds = builder.colorResourceIds;
        this.colorAttributes = builder.colorAttributes;
        this.colorAttributeToHarmonizeWith = builder.colorAttributeToHarmonizeWith;
    }

    @NonNull
    public Context getContext() {
        return this.context;
    }

    @NonNull
    public int[] getColorResourcesIds() {
        return this.colorResourceIds;
    }

    @Nullable
    public HarmonizedColorAttributes getColorAttributes() {
        return this.colorAttributes;
    }

    @AttrRes
    public int getColorAttributeToHarmonizeWith() {
        return this.colorAttributeToHarmonizeWith;
    }

    public static class Builder {
        /* access modifiers changed from: private */
        @AttrRes
        public int colorAttributeToHarmonizeWith = R.attr.colorPrimary;
        /* access modifiers changed from: private */
        @Nullable
        public HarmonizedColorAttributes colorAttributes;
        /* access modifiers changed from: private */
        @NonNull
        public int[] colorResourceIds = new int[0];
        /* access modifiers changed from: private */
        @NonNull
        public final Context context;

        public Builder(@NonNull Context context2) {
            this.context = context2;
        }

        @NonNull
        public Builder setColorResourcesIds(@NonNull int[] iArr) {
            this.colorResourceIds = iArr;
            return this;
        }

        @Nullable
        public Builder setColorAttributes(@Nullable HarmonizedColorAttributes harmonizedColorAttributes) {
            this.colorAttributes = harmonizedColorAttributes;
            return this;
        }

        @NonNull
        public Builder setColorAttributeToHarmonizeWith(@AttrRes int i) {
            this.colorAttributeToHarmonizeWith = i;
            return this;
        }

        @NonNull
        public HarmonizedColorsOptions build() {
            return new HarmonizedColorsOptions(this);
        }
    }

    /* access modifiers changed from: package-private */
    @StyleRes
    public int getThemeOverlayResourceId() {
        HarmonizedColorAttributes harmonizedColorAttributes = this.colorAttributes;
        if (harmonizedColorAttributes != null) {
            return harmonizedColorAttributes.getThemeOverlay();
        }
        return 0;
    }
}
