package androidx.core.net;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RequiresPermission;
import androidx.annotation.RestrictTo;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public final class ConnectivityManagerCompat {
    public static final int RESTRICT_BACKGROUND_STATUS_DISABLED = 1;
    public static final int RESTRICT_BACKGROUND_STATUS_ENABLED = 3;
    public static final int RESTRICT_BACKGROUND_STATUS_WHITELISTED = 2;

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
    @Retention(RetentionPolicy.SOURCE)
    public @interface RestrictBackgroundStatus {
    }

    @RequiresPermission("android.permission.ACCESS_NETWORK_STATE")
    public static boolean isActiveNetworkMetered(@NonNull ConnectivityManager connectivityManager) {
        return Api16Impl.isActiveNetworkMetered(connectivityManager);
    }

    @RequiresPermission("android.permission.ACCESS_NETWORK_STATE")
    @SuppressLint({"ReferencesDeprecated"})
    @Nullable
    public static NetworkInfo getNetworkInfoFromBroadcast(@NonNull ConnectivityManager connectivityManager, @NonNull Intent intent) {
        NetworkInfo networkInfo = (NetworkInfo) intent.getParcelableExtra("networkInfo");
        if (networkInfo != null) {
            return connectivityManager.getNetworkInfo(networkInfo.getType());
        }
        return null;
    }

    public static int getRestrictBackgroundStatus(@NonNull ConnectivityManager connectivityManager) {
        return Api24Impl.getRestrictBackgroundStatus(connectivityManager);
    }

    private ConnectivityManagerCompat() {
    }

    @RequiresApi(16)
    static class Api16Impl {
        private Api16Impl() {
        }

        @RequiresPermission("android.permission.ACCESS_NETWORK_STATE")
        @DoNotInline
        static boolean isActiveNetworkMetered(ConnectivityManager connectivityManager) {
            return connectivityManager.isActiveNetworkMetered();
        }
    }

    @RequiresApi(24)
    static class Api24Impl {
        private Api24Impl() {
        }

        @DoNotInline
        static int getRestrictBackgroundStatus(ConnectivityManager connectivityManager) {
            return connectivityManager.getRestrictBackgroundStatus();
        }
    }
}
