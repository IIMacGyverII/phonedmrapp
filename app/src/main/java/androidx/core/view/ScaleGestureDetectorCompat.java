package androidx.core.view;

import android.view.ScaleGestureDetector;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class ScaleGestureDetectorCompat {
    private ScaleGestureDetectorCompat() {
    }

    @Deprecated
    public static void setQuickScaleEnabled(Object obj, boolean z) {
        setQuickScaleEnabled((ScaleGestureDetector) obj, z);
    }

    public static void setQuickScaleEnabled(@NonNull ScaleGestureDetector scaleGestureDetector, boolean z) {
        Api19Impl.setQuickScaleEnabled(scaleGestureDetector, z);
    }

    @Deprecated
    public static boolean isQuickScaleEnabled(Object obj) {
        return isQuickScaleEnabled((ScaleGestureDetector) obj);
    }

    public static boolean isQuickScaleEnabled(@NonNull ScaleGestureDetector scaleGestureDetector) {
        return Api19Impl.isQuickScaleEnabled(scaleGestureDetector);
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static void setQuickScaleEnabled(ScaleGestureDetector scaleGestureDetector, boolean z) {
            scaleGestureDetector.setQuickScaleEnabled(z);
        }

        @DoNotInline
        static boolean isQuickScaleEnabled(ScaleGestureDetector scaleGestureDetector) {
            return scaleGestureDetector.isQuickScaleEnabled();
        }
    }
}
