package com.google.android.material.color;

import android.app.Activity;
import android.app.Application;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.StyleRes;
import com.google.android.material.color.DynamicColors;

public class DynamicColorsOptions {
    /* access modifiers changed from: private */
    public static final DynamicColors.Precondition ALWAYS_ALLOW = new DynamicColors.Precondition() {
        public boolean shouldApplyDynamicColors(@NonNull Activity activity, int i) {
            return true;
        }
    };
    /* access modifiers changed from: private */
    public static final DynamicColors.OnAppliedCallback NO_OP_CALLBACK = new DynamicColors.OnAppliedCallback() {
        public void onApplied(@NonNull Activity activity) {
        }
    };
    @Nullable
    private final Activity activity;
    @Nullable
    private final Application application;
    @NonNull
    private final DynamicColors.OnAppliedCallback onAppliedCallback;
    @NonNull
    private final DynamicColors.Precondition precondition;
    @StyleRes
    private final int themeOverlay;

    private DynamicColorsOptions(Builder builder) {
        this.application = builder.application;
        this.activity = builder.activity;
        this.themeOverlay = builder.themeOverlay;
        this.precondition = builder.precondition;
        this.onAppliedCallback = builder.onAppliedCallback;
    }

    @Nullable
    public Application getApplication() {
        return this.application;
    }

    @Nullable
    public Activity getActivity() {
        return this.activity;
    }

    @StyleRes
    public int getThemeOverlay() {
        return this.themeOverlay;
    }

    @NonNull
    public DynamicColors.Precondition getPrecondition() {
        return this.precondition;
    }

    @NonNull
    public DynamicColors.OnAppliedCallback getOnAppliedCallback() {
        return this.onAppliedCallback;
    }

    public static class Builder {
        /* access modifiers changed from: private */
        @Nullable
        public final Activity activity;
        /* access modifiers changed from: private */
        @Nullable
        public final Application application;
        /* access modifiers changed from: private */
        @NonNull
        public DynamicColors.OnAppliedCallback onAppliedCallback = DynamicColorsOptions.NO_OP_CALLBACK;
        /* access modifiers changed from: private */
        @NonNull
        public DynamicColors.Precondition precondition = DynamicColorsOptions.ALWAYS_ALLOW;
        /* access modifiers changed from: private */
        @StyleRes
        public int themeOverlay;

        public Builder(@NonNull Application application2) {
            this.application = application2;
            this.activity = null;
        }

        public Builder(@NonNull Activity activity2) {
            this.activity = activity2;
            this.application = null;
        }

        @NonNull
        public Builder setThemeOverlay(@StyleRes int i) {
            this.themeOverlay = i;
            return this;
        }

        @NonNull
        public Builder setPrecondition(@NonNull DynamicColors.Precondition precondition2) {
            this.precondition = precondition2;
            return this;
        }

        @NonNull
        public Builder setOnAppliedCallback(@NonNull DynamicColors.OnAppliedCallback onAppliedCallback2) {
            this.onAppliedCallback = onAppliedCallback2;
            return this;
        }

        @NonNull
        public DynamicColorsOptions build() {
            return new DynamicColorsOptions(this);
        }
    }
}
