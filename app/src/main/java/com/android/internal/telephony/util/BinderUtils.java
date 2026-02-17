package com.android.internal.telephony.util;

import android.os.Binder;

public class BinderUtils {

    @FunctionalInterface
    public interface ThrowingRunnable<T extends Exception> {
        void run() throws Exception;
    }

    public static final <T extends Exception> void withCleanCallingIdentity(ThrowingRunnable<T> throwingRunnable) throws Exception {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            throwingRunnable.run();
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }
}
