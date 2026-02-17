package com.android.internal.telephony.uicc;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.SystemClock;
import android.provider.Settings;
import android.service.notification.StatusBarNotification;
import android.text.TextUtils;
import androidx.core.app.NotificationCompat;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.util.NotificationChannelController;
import java.util.Arrays;
import java.util.List;

@VisibleForTesting
public class InstallCarrierAppUtils {
    private static final int ACTIVATE_CELL_SERVICE_NOTIFICATION_ID = 12;
    private static CarrierAppInstallReceiver sCarrierAppInstallReceiver;

    static void showNotification(Context context, String str) {
        String str2;
        Resources system = Resources.getSystem();
        String string = system.getString(17040503);
        String appNameFromPackageName = getAppNameFromPackageName(context, str);
        boolean z = true;
        if (TextUtils.isEmpty(appNameFromPackageName)) {
            str2 = system.getString(17040501);
        } else {
            str2 = system.getString(17040502, new Object[]{appNameFromPackageName});
        }
        String string2 = system.getString(17040500);
        if (Settings.Global.getInt(context.getContentResolver(), "install_carrier_app_notification_persistent", 1) != 1) {
            z = false;
        }
        getNotificationManager(context).notify(str, 12, new Notification.Builder(context, NotificationChannelController.CHANNEL_ID_SIM).setContentTitle(string).setContentText(str2).setSmallIcon(17302866).addAction(new Notification.Action.Builder((Icon) null, string2, PendingIntent.getActivity(context, 0, getPlayStoreIntent(str), 201326592)).build()).setOngoing(z).setVisibility(-1).build());
    }

    static void hideAllNotifications(Context context) {
        NotificationManager notificationManager = getNotificationManager(context);
        StatusBarNotification[] activeNotifications = notificationManager.getActiveNotifications();
        if (activeNotifications != null) {
            for (StatusBarNotification statusBarNotification : activeNotifications) {
                if (statusBarNotification.getId() == 12) {
                    notificationManager.cancel(statusBarNotification.getTag(), statusBarNotification.getId());
                }
            }
        }
    }

    static void hideNotification(Context context, String str) {
        getNotificationManager(context).cancel(str, 12);
    }

    static Intent getPlayStoreIntent(String str) {
        Intent intent = new Intent("android.intent.action.VIEW");
        intent.setData(Uri.parse("market://details?id=" + str));
        intent.addFlags(268435456);
        return intent;
    }

    static void showNotificationIfNotInstalledDelayed(Context context, String str, long j) {
        ((AlarmManager) context.getSystemService(NotificationCompat.CATEGORY_ALARM)).set(3, SystemClock.elapsedRealtime() + j, PendingIntent.getBroadcast(context, 0, ShowInstallAppNotificationReceiver.get(context, str), 67108864));
    }

    static void registerPackageInstallReceiver(Context context) {
        if (sCarrierAppInstallReceiver == null) {
            sCarrierAppInstallReceiver = new CarrierAppInstallReceiver();
            Context applicationContext = context.getApplicationContext();
            IntentFilter intentFilter = new IntentFilter("android.intent.action.PACKAGE_ADDED");
            intentFilter.addDataScheme("package");
            applicationContext.registerReceiver(sCarrierAppInstallReceiver, intentFilter);
        }
    }

    static void unregisterPackageInstallReceiver(Context context) {
        if (sCarrierAppInstallReceiver != null) {
            context.getApplicationContext().unregisterReceiver(sCarrierAppInstallReceiver);
            sCarrierAppInstallReceiver = null;
        }
    }

    static boolean isPackageInstallNotificationActive(Context context) {
        for (StatusBarNotification id : getNotificationManager(context).getActiveNotifications()) {
            if (id.getId() == 12) {
                return true;
            }
        }
        return false;
    }

    static String getAppNameFromPackageName(Context context, String str) {
        return getAppNameFromPackageName(str, Settings.Global.getString(context.getContentResolver(), "carrier_app_names"));
    }

    @VisibleForTesting
    public static String getAppNameFromPackageName(String str, String str2) {
        String lowerCase = str.toLowerCase();
        if (TextUtils.isEmpty(str2)) {
            return null;
        }
        List<String> asList = Arrays.asList(str2.split("\\s*;\\s*"));
        if (asList.isEmpty()) {
            return null;
        }
        for (String split : asList) {
            String[] split2 = split.split("\\s*:\\s*");
            if (split2.length == 2 && split2[0].equals(lowerCase)) {
                return split2[1];
            }
        }
        return null;
    }

    private static NotificationManager getNotificationManager(Context context) {
        return (NotificationManager) context.getSystemService("notification");
    }
}
