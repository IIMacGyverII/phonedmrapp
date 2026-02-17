package androidx.transition;

import android.graphics.Matrix;
import android.graphics.Rect;
import android.util.Property;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.ViewCompat;

class ViewUtils {
    static final Property<View, Rect> CLIP_BOUNDS = new Property<View, Rect>(Rect.class, "clipBounds") {
        public Rect get(View view) {
            return ViewCompat.getClipBounds(view);
        }

        public void set(View view, Rect rect) {
            ViewCompat.setClipBounds(view, rect);
        }
    };
    private static final ViewUtilsBase IMPL = new ViewUtilsApi29();
    private static final String TAG = "ViewUtils";
    static final Property<View, Float> TRANSITION_ALPHA = new Property<View, Float>(Float.class, "translationAlpha") {
        public Float get(View view) {
            return Float.valueOf(ViewUtils.getTransitionAlpha(view));
        }

        public void set(View view, Float f) {
            ViewUtils.setTransitionAlpha(view, f.floatValue());
        }
    };

    static ViewOverlayImpl getOverlay(@NonNull View view) {
        return new ViewOverlayApi18(view);
    }

    static WindowIdImpl getWindowId(@NonNull View view) {
        return new WindowIdApi18(view);
    }

    static void setTransitionAlpha(@NonNull View view, float f) {
        IMPL.setTransitionAlpha(view, f);
    }

    static float getTransitionAlpha(@NonNull View view) {
        return IMPL.getTransitionAlpha(view);
    }

    static void saveNonTransitionAlpha(@NonNull View view) {
        IMPL.saveNonTransitionAlpha(view);
    }

    static void clearNonTransitionAlpha(@NonNull View view) {
        IMPL.clearNonTransitionAlpha(view);
    }

    static void setTransitionVisibility(@NonNull View view, int i) {
        IMPL.setTransitionVisibility(view, i);
    }

    static void transformMatrixToGlobal(@NonNull View view, @NonNull Matrix matrix) {
        IMPL.transformMatrixToGlobal(view, matrix);
    }

    static void transformMatrixToLocal(@NonNull View view, @NonNull Matrix matrix) {
        IMPL.transformMatrixToLocal(view, matrix);
    }

    static void setAnimationMatrix(@NonNull View view, @Nullable Matrix matrix) {
        IMPL.setAnimationMatrix(view, matrix);
    }

    static void setLeftTopRightBottom(@NonNull View view, int i, int i2, int i3, int i4) {
        IMPL.setLeftTopRightBottom(view, i, i2, i3, i4);
    }

    private ViewUtils() {
    }
}
