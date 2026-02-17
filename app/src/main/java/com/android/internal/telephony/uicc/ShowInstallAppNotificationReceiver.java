package com.android.internal.telephony.uicc;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class ShowInstallAppNotificationReceiver extends BroadcastReceiver {
    private static final String EXTRA_PACKAGE_NAME = "package_name";

    public static Intent get(Context context, String str) {
        Intent intent = new Intent(context, ShowInstallAppNotificationReceiver.class);
        intent.putExtra(EXTRA_PACKAGE_NAME, str);
        return intent;
    }

    public void onReceive(Context context, Intent intent) {
        String stringExtra = intent.getStringExtra(EXTRA_PACKAGE_NAME);
        if (!UiccProfile.isPackageBundled(context, stringExtra)) {
            InstallCarrierAppUtils.showNotification(context, stringExtra);
            InstallCarrierAppUtils.registerPackageInstallReceiver(context);
        }
    }
}
