package androidx.emoji2.text;

import android.os.Handler;
import android.os.Looper;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import java.util.Objects;
import java.util.concurrent.Executor;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

class ConcurrencyHelpers {
    private static final int FONT_LOAD_TIMEOUT_SECONDS = 15;

    private ConcurrencyHelpers() {
    }

    static ThreadPoolExecutor createBackgroundPriorityExecutor(@NonNull String str) {
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(0, 1, 15, TimeUnit.SECONDS, new LinkedBlockingDeque(), new ConcurrencyHelpers$$ExternalSyntheticLambda0(str));
        threadPoolExecutor.allowCoreThreadTimeOut(true);
        return threadPoolExecutor;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Thread lambda$createBackgroundPriorityExecutor$0(String str, Runnable runnable) {
        Thread thread = new Thread(runnable, str);
        thread.setPriority(10);
        return thread;
    }

    static Handler mainHandlerAsync() {
        return Handler28Impl.createAsync(Looper.getMainLooper());
    }

    @NonNull
    @Deprecated
    static Executor convertHandlerToExecutor(@NonNull Handler handler) {
        Objects.requireNonNull(handler);
        return new ConcurrencyHelpers$$ExternalSyntheticLambda1(handler);
    }

    @RequiresApi(28)
    static class Handler28Impl {
        private Handler28Impl() {
        }

        @DoNotInline
        public static Handler createAsync(Looper looper) {
            return Handler.createAsync(looper);
        }
    }
}
