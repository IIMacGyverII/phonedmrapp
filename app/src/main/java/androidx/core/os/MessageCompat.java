package androidx.core.os;

import android.annotation.SuppressLint;
import android.os.Message;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class MessageCompat {
    private static boolean sTryIsAsynchronous = true;
    private static boolean sTrySetAsynchronous = true;

    @SuppressLint({"NewApi"})
    public static void setAsynchronous(@NonNull Message message, boolean z) {
        Api22Impl.setAsynchronous(message, z);
    }

    @SuppressLint({"NewApi"})
    public static boolean isAsynchronous(@NonNull Message message) {
        return Api22Impl.isAsynchronous(message);
    }

    private MessageCompat() {
    }

    @RequiresApi(22)
    static class Api22Impl {
        private Api22Impl() {
        }

        @DoNotInline
        static boolean isAsynchronous(Message message) {
            return message.isAsynchronous();
        }

        @DoNotInline
        static void setAsynchronous(Message message, boolean z) {
            message.setAsynchronous(z);
        }
    }
}
