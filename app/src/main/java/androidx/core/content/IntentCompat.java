package androidx.core.content;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public final class IntentCompat {
    @SuppressLint({"ActionValue"})
    public static final String ACTION_CREATE_REMINDER = "android.intent.action.CREATE_REMINDER";
    public static final String CATEGORY_LEANBACK_LAUNCHER = "android.intent.category.LEANBACK_LAUNCHER";
    public static final String EXTRA_HTML_TEXT = "android.intent.extra.HTML_TEXT";
    public static final String EXTRA_START_PLAYBACK = "android.intent.extra.START_PLAYBACK";
    @SuppressLint({"ActionValue"})
    public static final String EXTRA_TIME = "android.intent.extra.TIME";

    private IntentCompat() {
    }

    @NonNull
    public static Intent makeMainSelectorActivity(@NonNull String str, @NonNull String str2) {
        return Api15Impl.makeMainSelectorActivity(str, str2);
    }

    @NonNull
    public static Intent createManageUnusedAppRestrictionsIntent(@NonNull Context context, @NonNull String str) {
        if (PackageManagerCompat.areUnusedAppRestrictionsAvailable(context.getPackageManager())) {
            return new Intent("android.settings.APPLICATION_DETAILS_SETTINGS").setData(Uri.fromParts("package", str, (String) null));
        }
        throw new UnsupportedOperationException("Unused App Restriction features are not available on this device");
    }

    @RequiresApi(15)
    static class Api15Impl {
        private Api15Impl() {
        }

        @DoNotInline
        static Intent makeMainSelectorActivity(String str, String str2) {
            return Intent.makeMainSelectorActivity(str, str2);
        }
    }
}
