package androidx.core.os;

import android.content.Context;
import android.os.UserManager;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public class UserManagerCompat {
    private UserManagerCompat() {
    }

    public static boolean isUserUnlocked(@NonNull Context context) {
        return Api24Impl.isUserUnlocked(context);
    }

    @RequiresApi(24)
    static class Api24Impl {
        private Api24Impl() {
        }

        @DoNotInline
        static boolean isUserUnlocked(Context context) {
            return ((UserManager) context.getSystemService(UserManager.class)).isUserUnlocked();
        }
    }
}
