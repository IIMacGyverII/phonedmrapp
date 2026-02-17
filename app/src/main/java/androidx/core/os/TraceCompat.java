package androidx.core.os;

import android.os.Trace;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import java.lang.reflect.Method;

@Deprecated
public final class TraceCompat {
    private static final String TAG = "TraceCompat";
    private static Method sAsyncTraceBeginMethod;
    private static Method sAsyncTraceEndMethod;
    private static Method sIsTagEnabledMethod;
    private static Method sTraceCounterMethod;
    private static long sTraceTagApp;

    public static boolean isEnabled() {
        return Api29Impl.isEnabled();
    }

    public static void beginSection(@NonNull String str) {
        Api18Impl.beginSection(str);
    }

    public static void endSection() {
        Api18Impl.endSection();
    }

    public static void beginAsyncSection(@NonNull String str, int i) {
        Api29Impl.beginAsyncSection(str, i);
    }

    public static void endAsyncSection(@NonNull String str, int i) {
        Api29Impl.endAsyncSection(str, i);
    }

    public static void setCounter(@NonNull String str, int i) {
        Api29Impl.setCounter(str, (long) i);
    }

    private TraceCompat() {
    }

    @RequiresApi(29)
    static class Api29Impl {
        private Api29Impl() {
        }

        @DoNotInline
        static boolean isEnabled() {
            return Trace.isEnabled();
        }

        @DoNotInline
        static void endAsyncSection(String str, int i) {
            Trace.endAsyncSection(str, i);
        }

        @DoNotInline
        static void beginAsyncSection(String str, int i) {
            Trace.beginAsyncSection(str, i);
        }

        @DoNotInline
        static void setCounter(String str, long j) {
            Trace.setCounter(str, j);
        }
    }

    @RequiresApi(18)
    static class Api18Impl {
        private Api18Impl() {
        }

        @DoNotInline
        static void beginSection(String str) {
            Trace.beginSection(str);
        }

        @DoNotInline
        static void endSection() {
            Trace.endSection();
        }
    }
}
