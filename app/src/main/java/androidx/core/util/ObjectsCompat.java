package androidx.core.util;

import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.util.Objects;

public class ObjectsCompat {
    private ObjectsCompat() {
    }

    public static boolean equals(@Nullable Object obj, @Nullable Object obj2) {
        return Api19Impl.equals(obj, obj2);
    }

    public static int hashCode(@Nullable Object obj) {
        if (obj != null) {
            return obj.hashCode();
        }
        return 0;
    }

    public static int hash(@Nullable Object... objArr) {
        return Api19Impl.hash(objArr);
    }

    @Nullable
    public static String toString(@Nullable Object obj, @Nullable String str) {
        return obj != null ? obj.toString() : str;
    }

    @NonNull
    public static <T> T requireNonNull(@Nullable T t) {
        t.getClass();
        return t;
    }

    @NonNull
    public static <T> T requireNonNull(@Nullable T t, @NonNull String str) {
        if (t != null) {
            return t;
        }
        throw new NullPointerException(str);
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static boolean equals(Object obj, Object obj2) {
            return Objects.equals(obj, obj2);
        }

        @DoNotInline
        static int hash(Object... objArr) {
            return Objects.hash(objArr);
        }
    }
}
