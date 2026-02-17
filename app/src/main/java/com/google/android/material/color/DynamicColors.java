package com.google.android.material.color;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Build;
import android.os.Bundle;
import android.view.ContextThemeWrapper;
import androidx.annotation.ChecksSdkIntAtLeast;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.StyleRes;
import com.google.android.material.R;
import com.google.android.material.color.DynamicColorsOptions;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class DynamicColors {
    private static final DeviceSupportCondition DEFAULT_DEVICE_SUPPORT_CONDITION;
    private static final Map<String, DeviceSupportCondition> DYNAMIC_COLOR_SUPPORTED_BRANDS;
    private static final Map<String, DeviceSupportCondition> DYNAMIC_COLOR_SUPPORTED_MANUFACTURERS;
    private static final int[] DYNAMIC_COLOR_THEME_OVERLAY_ATTRIBUTE = {R.attr.dynamicColorThemeOverlay};
    @SuppressLint({"PrivateApi"})
    private static final DeviceSupportCondition SAMSUNG_DEVICE_SUPPORT_CONDITION;
    private static final int USE_DEFAULT_THEME_OVERLAY = 0;

    private interface DeviceSupportCondition {
        boolean isSupported();
    }

    public interface OnAppliedCallback {
        void onApplied(@NonNull Activity activity);
    }

    public interface Precondition {
        boolean shouldApplyDynamicColors(@NonNull Activity activity, @StyleRes int i);
    }

    static {
        AnonymousClass1 r0 = new DeviceSupportCondition() {
            public boolean isSupported() {
                return true;
            }
        };
        DEFAULT_DEVICE_SUPPORT_CONDITION = r0;
        AnonymousClass2 r1 = new DeviceSupportCondition() {
            private Long version;

            public boolean isSupported() {
                if (this.version == null) {
                    try {
                        Method declaredMethod = Build.class.getDeclaredMethod("getLong", new Class[]{String.class});
                        declaredMethod.setAccessible(true);
                        this.version = Long.valueOf(((Long) declaredMethod.invoke((Object) null, new Object[]{"ro.build.version.oneui"})).longValue());
                    } catch (Exception unused) {
                        this.version = -1L;
                    }
                }
                if (this.version.longValue() >= 40100) {
                    return true;
                }
                return false;
            }
        };
        SAMSUNG_DEVICE_SUPPORT_CONDITION = r1;
        HashMap hashMap = new HashMap();
        hashMap.put("oppo", r0);
        hashMap.put("realme", r0);
        hashMap.put("oneplus", r0);
        hashMap.put("vivo", r0);
        hashMap.put("xiaomi", r0);
        hashMap.put("motorola", r0);
        hashMap.put("itel", r0);
        hashMap.put("tecno mobile limited", r0);
        hashMap.put("infinix mobility limited", r0);
        hashMap.put("hmd global", r0);
        hashMap.put("sharp", r0);
        hashMap.put("sony", r0);
        hashMap.put("tcl", r0);
        hashMap.put("lenovo", r0);
        hashMap.put("lge", r0);
        hashMap.put("google", r0);
        hashMap.put("robolectric", r0);
        hashMap.put("samsung", r1);
        DYNAMIC_COLOR_SUPPORTED_MANUFACTURERS = Collections.unmodifiableMap(hashMap);
        HashMap hashMap2 = new HashMap();
        hashMap2.put("asus", r0);
        hashMap2.put("jio", r0);
        DYNAMIC_COLOR_SUPPORTED_BRANDS = Collections.unmodifiableMap(hashMap2);
    }

    private DynamicColors() {
    }

    public static void applyToActivitiesIfAvailable(@NonNull Application application) {
        applyIfAvailable(new DynamicColorsOptions.Builder(application).build());
    }

    public static void applyToActivitiesIfAvailable(@NonNull Application application, @StyleRes int i) {
        applyIfAvailable(new DynamicColorsOptions.Builder(application).setThemeOverlay(i).build());
    }

    public static void applyToActivitiesIfAvailable(@NonNull Application application, @NonNull Precondition precondition) {
        applyIfAvailable(new DynamicColorsOptions.Builder(application).setPrecondition(precondition).build());
    }

    public static void applyToActivitiesIfAvailable(@NonNull Application application, @StyleRes int i, @NonNull Precondition precondition) {
        applyIfAvailable(new DynamicColorsOptions.Builder(application).setThemeOverlay(i).setPrecondition(precondition).build());
    }

    public static void applyIfAvailable(@NonNull Activity activity) {
        applyIfAvailable(new DynamicColorsOptions.Builder(activity).build());
    }

    public static void applyIfAvailable(@NonNull Activity activity, @StyleRes int i) {
        applyIfAvailable(new DynamicColorsOptions.Builder(activity).setThemeOverlay(i).build());
    }

    public static void applyIfAvailable(@NonNull Activity activity, @NonNull Precondition precondition) {
        applyIfAvailable(new DynamicColorsOptions.Builder(activity).setPrecondition(precondition).build());
    }

    public static void applyIfAvailable(@NonNull DynamicColorsOptions dynamicColorsOptions) {
        Application application = dynamicColorsOptions.getApplication();
        Activity activity = dynamicColorsOptions.getActivity();
        if (application != null) {
            application.registerActivityLifecycleCallbacks(new DynamicColorsActivityLifecycleCallbacks(dynamicColorsOptions));
        } else if (activity != null) {
            applyIfAvailable(activity, dynamicColorsOptions.getThemeOverlay(), dynamicColorsOptions.getPrecondition(), dynamicColorsOptions.getOnAppliedCallback());
        } else {
            throw new IllegalArgumentException("Either Application or Activity is required.");
        }
    }

    /* access modifiers changed from: private */
    public static void applyIfAvailable(@NonNull Activity activity, @StyleRes int i, @NonNull Precondition precondition, @NonNull OnAppliedCallback onAppliedCallback) {
        if (isDynamicColorAvailable()) {
            if (i == 0) {
                i = getDefaultThemeOverlay(activity);
            }
            if (i != 0 && precondition.shouldApplyDynamicColors(activity, i)) {
                ThemeUtils.applyThemeOverlay(activity, i);
                onAppliedCallback.onApplied(activity);
            }
        }
    }

    @NonNull
    public static Context wrapContextIfAvailable(@NonNull Context context) {
        return wrapContextIfAvailable(context, 0);
    }

    @NonNull
    public static Context wrapContextIfAvailable(@NonNull Context context, @StyleRes int i) {
        if (!isDynamicColorAvailable()) {
            return context;
        }
        if (i == 0) {
            i = getDefaultThemeOverlay(context);
        }
        return i == 0 ? context : new ContextThemeWrapper(context, i);
    }

    @SuppressLint({"DefaultLocale"})
    @ChecksSdkIntAtLeast(api = 31)
    public static boolean isDynamicColorAvailable() {
        DeviceSupportCondition deviceSupportCondition = DYNAMIC_COLOR_SUPPORTED_MANUFACTURERS.get(Build.MANUFACTURER.toLowerCase());
        if (deviceSupportCondition == null) {
            deviceSupportCondition = DYNAMIC_COLOR_SUPPORTED_BRANDS.get(Build.BRAND.toLowerCase());
        }
        return deviceSupportCondition != null && deviceSupportCondition.isSupported();
    }

    private static int getDefaultThemeOverlay(@NonNull Context context) {
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(DYNAMIC_COLOR_THEME_OVERLAY_ATTRIBUTE);
        int resourceId = obtainStyledAttributes.getResourceId(0, 0);
        obtainStyledAttributes.recycle();
        return resourceId;
    }

    private static class DynamicColorsActivityLifecycleCallbacks implements Application.ActivityLifecycleCallbacks {
        private final DynamicColorsOptions dynamicColorsOptions;

        public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle bundle) {
        }

        public void onActivityDestroyed(@NonNull Activity activity) {
        }

        public void onActivityPaused(@NonNull Activity activity) {
        }

        public void onActivityResumed(@NonNull Activity activity) {
        }

        public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle bundle) {
        }

        public void onActivityStarted(@NonNull Activity activity) {
        }

        public void onActivityStopped(@NonNull Activity activity) {
        }

        DynamicColorsActivityLifecycleCallbacks(@NonNull DynamicColorsOptions dynamicColorsOptions2) {
            this.dynamicColorsOptions = dynamicColorsOptions2;
        }

        public void onActivityPreCreated(@NonNull Activity activity, @Nullable Bundle bundle) {
            DynamicColors.applyIfAvailable(activity, this.dynamicColorsOptions.getThemeOverlay(), this.dynamicColorsOptions.getPrecondition(), this.dynamicColorsOptions.getOnAppliedCallback());
        }
    }
}
