package com.android.internal.telephony.uicc.euicc.async;

import android.os.Handler;

public final class AsyncResultHelper {
    public static <T> void returnResult(final T t, final AsyncResultCallback<T> asyncResultCallback, Handler handler) {
        if (handler == null) {
            asyncResultCallback.onResult(t);
        } else {
            handler.post(new Runnable() {
                public void run() {
                    AsyncResultCallback.this.onResult(t);
                }
            });
        }
    }

    public static void throwException(final Throwable th, final AsyncResultCallback<?> asyncResultCallback, Handler handler) {
        if (handler == null) {
            asyncResultCallback.onException(th);
        } else {
            handler.post(new Runnable() {
                public void run() {
                    AsyncResultCallback.this.onException(th);
                }
            });
        }
    }

    private AsyncResultHelper() {
    }
}
