package androidx.core.graphics;

import android.graphics.BlendMode;
import android.graphics.BlendModeColorFilter;
import android.graphics.ColorFilter;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.graphics.BlendModeUtils;

public class BlendModeColorFilterCompat {
    @Nullable
    public static ColorFilter createBlendModeColorFilterCompat(int i, @NonNull BlendModeCompat blendModeCompat) {
        Object obtainBlendModeFromCompat = BlendModeUtils.Api29Impl.obtainBlendModeFromCompat(blendModeCompat);
        if (obtainBlendModeFromCompat != null) {
            return Api29Impl.createBlendModeColorFilter(i, obtainBlendModeFromCompat);
        }
        return null;
    }

    private BlendModeColorFilterCompat() {
    }

    @RequiresApi(29)
    static class Api29Impl {
        private Api29Impl() {
        }

        @DoNotInline
        static ColorFilter createBlendModeColorFilter(int i, Object obj) {
            return new BlendModeColorFilter(i, (BlendMode) obj);
        }
    }
}
