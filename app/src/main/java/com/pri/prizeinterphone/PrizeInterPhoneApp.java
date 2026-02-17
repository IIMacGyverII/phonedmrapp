package com.pri.prizeinterphone;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import androidx.lifecycle.ProcessLifecycleOwner;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.notification.MyNotificationManager;

public class PrizeInterPhoneApp extends Application {
    private static AppObserver mAppObserver;
    private static Context mContext;

    public void onCreate() {
        super.onCreate();
        Context applicationContext = getApplicationContext();
        mContext = applicationContext;
        mAppObserver = new AppObserver(applicationContext);
        ProcessLifecycleOwner.get().getLifecycle().addObserver(mAppObserver);
        DmrManager.getInstance().init();
        MyNotificationManager.getInstance().init();
        startInterPhoneService();
    }

    public static Context getContext() {
        return mContext;
    }

    private void startInterPhoneService() {
        startService(new Intent(mContext, InterPhoneService.class));
    }

    public static boolean isAppFg() {
        return mAppObserver.isAppFg();
    }
}
