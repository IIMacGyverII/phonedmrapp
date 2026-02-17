package androidx.core.view.animation;

import android.graphics.Path;
import android.view.animation.Interpolator;
import android.view.animation.PathInterpolator;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class PathInterpolatorCompat {
    private PathInterpolatorCompat() {
    }

    @NonNull
    public static Interpolator create(@NonNull Path path) {
        return Api21Impl.createPathInterpolator(path);
    }

    @NonNull
    public static Interpolator create(float f, float f2) {
        return Api21Impl.createPathInterpolator(f, f2);
    }

    @NonNull
    public static Interpolator create(float f, float f2, float f3, float f4) {
        return Api21Impl.createPathInterpolator(f, f2, f3, f4);
    }

    @RequiresApi(21)
    static class Api21Impl {
        private Api21Impl() {
        }

        @DoNotInline
        static PathInterpolator createPathInterpolator(Path path) {
            return new PathInterpolator(path);
        }

        @DoNotInline
        static PathInterpolator createPathInterpolator(float f, float f2) {
            return new PathInterpolator(f, f2);
        }

        @DoNotInline
        static PathInterpolator createPathInterpolator(float f, float f2, float f3, float f4) {
            return new PathInterpolator(f, f2, f3, f4);
        }
    }
}
