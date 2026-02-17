package androidx.core.telephony;

import android.telephony.SubscriptionManager;
import androidx.annotation.DoNotInline;
import androidx.annotation.RequiresApi;
import java.lang.reflect.Method;

@RequiresApi(22)
public class SubscriptionManagerCompat {
    private static Method sGetSlotIndexMethod;

    public static int getSlotIndex(int i) {
        if (i == -1) {
            return -1;
        }
        return Api29Impl.getSlotIndex(i);
    }

    private SubscriptionManagerCompat() {
    }

    @RequiresApi(29)
    private static class Api29Impl {
        private Api29Impl() {
        }

        @DoNotInline
        static int getSlotIndex(int i) {
            return SubscriptionManager.getSlotIndex(i);
        }
    }
}
