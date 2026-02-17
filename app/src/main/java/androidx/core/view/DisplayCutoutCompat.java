package androidx.core.view;

import android.graphics.Rect;
import android.view.DisplayCutout;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.graphics.Insets;
import androidx.core.util.ObjectsCompat;
import java.util.List;

public final class DisplayCutoutCompat {
    private final DisplayCutout mDisplayCutout;

    public DisplayCutoutCompat(@Nullable Rect rect, @Nullable List<Rect> list) {
        this(Api28Impl.createDisplayCutout(rect, list));
    }

    public DisplayCutoutCompat(@NonNull Insets insets, @Nullable Rect rect, @Nullable Rect rect2, @Nullable Rect rect3, @Nullable Rect rect4, @NonNull Insets insets2) {
        this(constructDisplayCutout(insets, rect, rect2, rect3, rect4, insets2));
    }

    private static DisplayCutout constructDisplayCutout(@NonNull Insets insets, @Nullable Rect rect, @Nullable Rect rect2, @Nullable Rect rect3, @Nullable Rect rect4, @NonNull Insets insets2) {
        return Api30Impl.createDisplayCutout(insets.toPlatformInsets(), rect, rect2, rect3, rect4, insets2.toPlatformInsets());
    }

    private DisplayCutoutCompat(DisplayCutout displayCutout) {
        this.mDisplayCutout = displayCutout;
    }

    public int getSafeInsetTop() {
        return Api28Impl.getSafeInsetTop(this.mDisplayCutout);
    }

    public int getSafeInsetBottom() {
        return Api28Impl.getSafeInsetBottom(this.mDisplayCutout);
    }

    public int getSafeInsetLeft() {
        return Api28Impl.getSafeInsetLeft(this.mDisplayCutout);
    }

    public int getSafeInsetRight() {
        return Api28Impl.getSafeInsetRight(this.mDisplayCutout);
    }

    @NonNull
    public List<Rect> getBoundingRects() {
        return Api28Impl.getBoundingRects(this.mDisplayCutout);
    }

    @NonNull
    public Insets getWaterfallInsets() {
        return Insets.toCompatInsets(Api30Impl.getWaterfallInsets(this.mDisplayCutout));
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || DisplayCutoutCompat.class != obj.getClass()) {
            return false;
        }
        return ObjectsCompat.equals(this.mDisplayCutout, ((DisplayCutoutCompat) obj).mDisplayCutout);
    }

    public int hashCode() {
        DisplayCutout displayCutout = this.mDisplayCutout;
        if (displayCutout == null) {
            return 0;
        }
        return displayCutout.hashCode();
    }

    @NonNull
    public String toString() {
        return "DisplayCutoutCompat{" + this.mDisplayCutout + "}";
    }

    static DisplayCutoutCompat wrap(DisplayCutout displayCutout) {
        if (displayCutout == null) {
            return null;
        }
        return new DisplayCutoutCompat(displayCutout);
    }

    /* access modifiers changed from: package-private */
    @RequiresApi(28)
    public DisplayCutout unwrap() {
        return this.mDisplayCutout;
    }

    @RequiresApi(28)
    static class Api28Impl {
        private Api28Impl() {
        }

        @DoNotInline
        static DisplayCutout createDisplayCutout(Rect rect, List<Rect> list) {
            return new DisplayCutout(rect, list);
        }

        @DoNotInline
        static int getSafeInsetTop(DisplayCutout displayCutout) {
            return displayCutout.getSafeInsetTop();
        }

        @DoNotInline
        static int getSafeInsetBottom(DisplayCutout displayCutout) {
            return displayCutout.getSafeInsetBottom();
        }

        @DoNotInline
        static int getSafeInsetLeft(DisplayCutout displayCutout) {
            return displayCutout.getSafeInsetLeft();
        }

        @DoNotInline
        static int getSafeInsetRight(DisplayCutout displayCutout) {
            return displayCutout.getSafeInsetRight();
        }

        @DoNotInline
        static List<Rect> getBoundingRects(DisplayCutout displayCutout) {
            return displayCutout.getBoundingRects();
        }
    }

    @RequiresApi(30)
    static class Api30Impl {
        private Api30Impl() {
        }

        @DoNotInline
        static DisplayCutout createDisplayCutout(android.graphics.Insets insets, Rect rect, Rect rect2, Rect rect3, Rect rect4, android.graphics.Insets insets2) {
            return new DisplayCutout(insets, rect, rect2, rect3, rect4, insets2);
        }

        @DoNotInline
        static android.graphics.Insets getWaterfallInsets(DisplayCutout displayCutout) {
            return displayCutout.getWaterfallInsets();
        }
    }

    @RequiresApi(29)
    static class Api29Impl {
        private Api29Impl() {
        }

        @DoNotInline
        static DisplayCutout createDisplayCutout(android.graphics.Insets insets, Rect rect, Rect rect2, Rect rect3, Rect rect4) {
            return new DisplayCutout(insets, rect, rect2, rect3, rect4);
        }
    }
}
