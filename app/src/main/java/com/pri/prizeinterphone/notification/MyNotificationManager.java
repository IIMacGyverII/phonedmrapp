package com.pri.prizeinterphone.notification;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import androidx.core.app.NotificationCompat;
import com.pri.prizeinterphone.InterPhoneHomeActivity;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.R;

public class MyNotificationManager {
    public static final int NOTIFICATION_CHANNEL_DMR_FG_ID = 1;
    private static final String NOTIFICATION_CHANNEL_DMR_ID = "notification_channel_dmr_id";
    private static final String NOTIFICATION_CHANNEL_DMR_NAME = "notification_channel_dmr_name";
    private NotificationChannel mChannel;
    private Context mContext;
    private NotificationManager mNotificationManager;
    private PendingIntent mStartHomeIntent;
    private PendingIntent mStartUpdateFirmwareIntent;

    private MyNotificationManager(Context context) {
        this.mStartUpdateFirmwareIntent = null;
        this.mStartHomeIntent = null;
        this.mContext = context;
    }

    public static MyNotificationManager getInstance() {
        return MyNotificationManagerHolder.INSTANCE;
    }

    private static class MyNotificationManagerHolder {
        /* access modifiers changed from: private */
        public static final MyNotificationManager INSTANCE = new MyNotificationManager(PrizeInterPhoneApp.getContext());

        private MyNotificationManagerHolder() {
        }
    }

    public void init() {
        initNotificationManager();
        initPendingIntent();
        initChannel();
    }

    private void initNotificationManager() {
        if (this.mNotificationManager == null) {
            this.mNotificationManager = (NotificationManager) this.mContext.getSystemService("notification");
        }
    }

    private void initPendingIntent() {
        if (this.mStartUpdateFirmwareIntent == null) {
            this.mStartUpdateFirmwareIntent = PendingIntent.getActivity(PrizeInterPhoneApp.getContext(), 0, new Intent("prize.intent.action.update.dmr.firmware"), 67108864);
        }
        if (this.mStartHomeIntent == null) {
            Intent intent = new Intent("android.intent.action.MAIN");
            intent.addCategory("android.intent.category.LAUNCHER");
            intent.addFlags(268435456);
            intent.setClassName(this.mContext.getPackageName(), InterPhoneHomeActivity.class.getName());
            this.mStartHomeIntent = PendingIntent.getActivity(this.mContext, 0, intent, 67108864);
        }
    }

    private void initChannel() {
        if (this.mChannel == null) {
            this.mChannel = new NotificationChannel(NOTIFICATION_CHANNEL_DMR_ID, NOTIFICATION_CHANNEL_DMR_NAME, 2);
        }
        this.mChannel.enableLights(true);
        this.mChannel.setShowBadge(true);
        this.mChannel.setLockscreenVisibility(1);
        this.mNotificationManager.createNotificationChannel(this.mChannel);
    }

    public NotificationCompat.Builder getCommonNotificationBuilder(String str) {
        NotificationCompat.Builder channelId = new NotificationCompat.Builder(this.mContext).setChannelId(NOTIFICATION_CHANNEL_DMR_ID);
        channelId.setContentText(str).setWhen(System.currentTimeMillis()).setSmallIcon((int) R.drawable.interphone_ic_title_icon).build();
        return channelId;
    }

    public Notification getStartHomeLauncherNotification(String str) {
        return getCommonNotificationBuilder(str).setContentIntent(this.mStartHomeIntent).build();
    }

    @SuppressLint({"StringFormatInvalid"})
    public void notifyUpdate2Notification(int i, int i2) {
        NotificationCompat.Builder builder;
        if (i == 32) {
            builder = getCommonNotificationBuilder(this.mContext.getString(R.string.interphone_update_firmware_content3)).setContentIntent(this.mStartHomeIntent).setOngoing(false);
        } else if (i == 64) {
            builder = getCommonNotificationBuilder(this.mContext.getString(R.string.interphone_update_firmware_content4)).setContentIntent(this.mStartUpdateFirmwareIntent).setOngoing(false);
        } else {
            builder = getCommonNotificationBuilder(this.mContext.getString(R.string.interphone_update_firmware_content5, new Object[]{Integer.valueOf(i2)})).setContentIntent(this.mStartUpdateFirmwareIntent).setProgress(100, i2, false).setOngoing(true);
        }
        this.mNotificationManager.notify(1, builder.build());
    }
}
