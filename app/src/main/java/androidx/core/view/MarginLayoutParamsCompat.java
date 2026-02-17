package androidx.core.view;

import android.view.ViewGroup;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class MarginLayoutParamsCompat {
    public static int getMarginStart(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams) {
        return Api17Impl.getMarginStart(marginLayoutParams);
    }

    public static int getMarginEnd(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams) {
        return Api17Impl.getMarginEnd(marginLayoutParams);
    }

    public static void setMarginStart(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
        Api17Impl.setMarginStart(marginLayoutParams, i);
    }

    public static void setMarginEnd(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
        Api17Impl.setMarginEnd(marginLayoutParams, i);
    }

    public static boolean isMarginRelative(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams) {
        return Api17Impl.isMarginRelative(marginLayoutParams);
    }

    public static int getLayoutDirection(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams) {
        int layoutDirection = Api17Impl.getLayoutDirection(marginLayoutParams);
        if (layoutDirection == 0 || layoutDirection == 1) {
            return layoutDirection;
        }
        return 0;
    }

    public static void setLayoutDirection(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
        Api17Impl.setLayoutDirection(marginLayoutParams, i);
    }

    public static void resolveLayoutDirection(@NonNull ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
        Api17Impl.resolveLayoutDirection(marginLayoutParams, i);
    }

    private MarginLayoutParamsCompat() {
    }

    @RequiresApi(17)
    static class Api17Impl {
        private Api17Impl() {
        }

        @DoNotInline
        static int getMarginStart(ViewGroup.MarginLayoutParams marginLayoutParams) {
            return marginLayoutParams.getMarginStart();
        }

        @DoNotInline
        static int getMarginEnd(ViewGroup.MarginLayoutParams marginLayoutParams) {
            return marginLayoutParams.getMarginEnd();
        }

        @DoNotInline
        static void setMarginStart(ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
            marginLayoutParams.setMarginStart(i);
        }

        @DoNotInline
        static void setMarginEnd(ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
            marginLayoutParams.setMarginEnd(i);
        }

        @DoNotInline
        static boolean isMarginRelative(ViewGroup.MarginLayoutParams marginLayoutParams) {
            return marginLayoutParams.isMarginRelative();
        }

        @DoNotInline
        static int getLayoutDirection(ViewGroup.MarginLayoutParams marginLayoutParams) {
            return marginLayoutParams.getLayoutDirection();
        }

        @DoNotInline
        static void setLayoutDirection(ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
            marginLayoutParams.setLayoutDirection(i);
        }

        @DoNotInline
        static void resolveLayoutDirection(ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
            marginLayoutParams.resolveLayoutDirection(i);
        }
    }
}
