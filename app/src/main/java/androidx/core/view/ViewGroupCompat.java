package androidx.core.view;

import android.view.View;
import android.view.ViewGroup;
import android.view.accessibility.AccessibilityEvent;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class ViewGroupCompat {
    public static final int LAYOUT_MODE_CLIP_BOUNDS = 0;
    public static final int LAYOUT_MODE_OPTICAL_BOUNDS = 1;

    private ViewGroupCompat() {
    }

    @Deprecated
    public static boolean onRequestSendAccessibilityEvent(ViewGroup viewGroup, View view, AccessibilityEvent accessibilityEvent) {
        return viewGroup.onRequestSendAccessibilityEvent(view, accessibilityEvent);
    }

    @Deprecated
    public static void setMotionEventSplittingEnabled(ViewGroup viewGroup, boolean z) {
        viewGroup.setMotionEventSplittingEnabled(z);
    }

    public static int getLayoutMode(@NonNull ViewGroup viewGroup) {
        return Api18Impl.getLayoutMode(viewGroup);
    }

    public static void setLayoutMode(@NonNull ViewGroup viewGroup, int i) {
        Api18Impl.setLayoutMode(viewGroup, i);
    }

    public static void setTransitionGroup(@NonNull ViewGroup viewGroup, boolean z) {
        Api21Impl.setTransitionGroup(viewGroup, z);
    }

    public static boolean isTransitionGroup(@NonNull ViewGroup viewGroup) {
        return Api21Impl.isTransitionGroup(viewGroup);
    }

    public static int getNestedScrollAxes(@NonNull ViewGroup viewGroup) {
        return Api21Impl.getNestedScrollAxes(viewGroup);
    }

    @RequiresApi(18)
    static class Api18Impl {
        private Api18Impl() {
        }

        @DoNotInline
        static int getLayoutMode(ViewGroup viewGroup) {
            return viewGroup.getLayoutMode();
        }

        @DoNotInline
        static void setLayoutMode(ViewGroup viewGroup, int i) {
            viewGroup.setLayoutMode(i);
        }
    }

    @RequiresApi(21)
    static class Api21Impl {
        private Api21Impl() {
        }

        @DoNotInline
        static void setTransitionGroup(ViewGroup viewGroup, boolean z) {
            viewGroup.setTransitionGroup(z);
        }

        @DoNotInline
        static boolean isTransitionGroup(ViewGroup viewGroup) {
            return viewGroup.isTransitionGroup();
        }

        @DoNotInline
        static int getNestedScrollAxes(ViewGroup viewGroup) {
            return viewGroup.getNestedScrollAxes();
        }
    }
}
