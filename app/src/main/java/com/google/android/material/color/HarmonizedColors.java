package com.google.android.material.color;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.res.TypedArray;
import android.content.res.loader.ResourcesLoader;
import android.view.ContextThemeWrapper;
import androidx.annotation.ChecksSdkIntAtLeast;
import androidx.annotation.ColorInt;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;
import java.util.HashMap;
import java.util.Map;

public class HarmonizedColors {
    private static final String TAG = "HarmonizedColors";

    private static boolean isColorResource(int i) {
        return 28 <= i && i <= 31;
    }

    @ChecksSdkIntAtLeast(api = 30)
    private static boolean isHarmonizedColorAvailable() {
        return true;
    }

    private HarmonizedColors() {
    }

    @NonNull
    public static void applyIfAvailable(@NonNull HarmonizedColorsOptions harmonizedColorsOptions) {
        if (isHarmonizedColorAvailable()) {
            Context context = harmonizedColorsOptions.getContext();
            int themeOverlayResourceId = harmonizedColorsOptions.getThemeOverlayResourceId();
            if (addResourcesLoaderToContext(context, harmonizedColorsOptions) && themeOverlayResourceId != 0) {
                ThemeUtils.applyThemeOverlay(context, themeOverlayResourceId);
            }
        }
    }

    @NonNull
    public static Context wrapContextIfAvailable(@NonNull HarmonizedColorsOptions harmonizedColorsOptions) {
        ContextWrapper contextWrapper;
        Context context = harmonizedColorsOptions.getContext();
        if (!isHarmonizedColorAvailable()) {
            return context;
        }
        int themeOverlayResourceId = harmonizedColorsOptions.getThemeOverlayResourceId();
        if (themeOverlayResourceId == 0) {
            contextWrapper = new ContextWrapper(context);
        } else {
            contextWrapper = new ContextThemeWrapper(context, themeOverlayResourceId);
        }
        return addResourcesLoaderToContext(contextWrapper, harmonizedColorsOptions) ? contextWrapper : context;
    }

    @RequiresApi(api = 30)
    private static boolean addResourcesLoaderToContext(Context context, HarmonizedColorsOptions harmonizedColorsOptions) {
        ResourcesLoader create = ColorResourcesLoaderCreator.create(context, createHarmonizedColorReplacementMap(harmonizedColorsOptions));
        if (create == null) {
            return false;
        }
        context.getResources().addLoaders(new ResourcesLoader[]{create});
        return true;
    }

    @RequiresApi(api = 21)
    private static Map<Integer, Integer> createHarmonizedColorReplacementMap(HarmonizedColorsOptions harmonizedColorsOptions) {
        Context context = harmonizedColorsOptions.getContext();
        HashMap hashMap = new HashMap();
        int color = MaterialColors.getColor(context, harmonizedColorsOptions.getColorAttributeToHarmonizeWith(), TAG);
        for (int i : harmonizedColorsOptions.getColorResourcesIds()) {
            hashMap.put(Integer.valueOf(i), Integer.valueOf(MaterialColors.harmonize(ContextCompat.getColor(context, i), color)));
        }
        HarmonizedColorAttributes colorAttributes = harmonizedColorsOptions.getColorAttributes();
        if (colorAttributes != null) {
            int[] attributes = colorAttributes.getAttributes();
            if (attributes.length > 0) {
                int themeOverlay = colorAttributes.getThemeOverlay();
                TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributes);
                TypedArray obtainStyledAttributes2 = themeOverlay != 0 ? new ContextThemeWrapper(context, themeOverlay).obtainStyledAttributes(attributes) : null;
                addHarmonizedColorAttributesToReplacementMap(hashMap, obtainStyledAttributes, obtainStyledAttributes2, color);
                obtainStyledAttributes.recycle();
                if (obtainStyledAttributes2 != null) {
                    obtainStyledAttributes2.recycle();
                }
            }
        }
        return hashMap;
    }

    @RequiresApi(api = 21)
    private static void addHarmonizedColorAttributesToReplacementMap(@NonNull Map<Integer, Integer> map, @NonNull TypedArray typedArray, @Nullable TypedArray typedArray2, @ColorInt int i) {
        if (typedArray2 == null) {
            typedArray2 = typedArray;
        }
        for (int i2 = 0; i2 < typedArray.getIndexCount(); i2++) {
            int resourceId = typedArray2.getResourceId(i2, 0);
            if (resourceId != 0 && typedArray.hasValue(i2) && isColorResource(typedArray.getType(i2))) {
                map.put(Integer.valueOf(resourceId), Integer.valueOf(MaterialColors.harmonize(typedArray.getColor(i2, 0), i)));
            }
        }
    }
}
