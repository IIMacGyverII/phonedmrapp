package com.mediatek.widget;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.util.Log;
import com.mediatek.internal.R;
import com.mediatek.widget.CustomAccountRemoteViews;
import java.util.List;

public class DefaultAccountSelectionBar {
    private static final String TAG = "DefaultAccountSelectionBar";
    private Context mContext;
    private CustomAccountRemoteViews mCustomAccountRemoteViews;
    private Notification mNotification;
    private NotificationManager mNotificationManager = ((NotificationManager) this.mContext.getSystemService("notification"));
    private String mPackageName;

    public DefaultAccountSelectionBar(Context context, String str, List<CustomAccountRemoteViews.AccountInfo> list) {
        this.mContext = context;
        this.mPackageName = str;
        configureView(list);
        Notification build = new Notification.Builder(this.mContext).setSmallIcon(R.drawable.account_select_notification).setWhen(System.currentTimeMillis()).setPriority(2).build();
        this.mNotification = build;
        build.flags = 32;
    }

    public void updateData(List<CustomAccountRemoteViews.AccountInfo> list) {
        configureView(list);
    }

    public void show() {
        this.mNotification.contentView = this.mCustomAccountRemoteViews.getNormalRemoteViews();
        this.mNotification.bigContentView = this.mCustomAccountRemoteViews.getBigRemoteViews();
        this.mNotificationManager.notify(R.id.custom_select_default_account_notification_container, this.mNotification);
        Log.d(TAG, "In package show accountBar: " + this.mPackageName);
    }

    public void hide() {
        this.mNotificationManager.cancel(R.id.custom_select_default_account_notification_container);
        Log.d(TAG, "In package hide accountBar: " + this.mPackageName);
    }

    private void configureView(List<CustomAccountRemoteViews.AccountInfo> list) {
        CustomAccountRemoteViews customAccountRemoteViews = new CustomAccountRemoteViews(this.mContext, this.mPackageName, list);
        this.mCustomAccountRemoteViews = customAccountRemoteViews;
        customAccountRemoteViews.configureView();
    }
}
