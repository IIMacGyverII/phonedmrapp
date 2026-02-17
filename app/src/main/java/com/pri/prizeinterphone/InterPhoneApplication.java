package com.pri.prizeinterphone;

import android.app.Application;
import android.content.Context;

public class InterPhoneApplication extends Application {
    private static Context context;
    private static InterPhoneApplication instance;

    public static InterPhoneApplication getInstance() {
        return instance;
    }

    public void onCreate() {
        super.onCreate();
        instance = this;
        context = getApplicationContext();
    }

    public static Context getContext() {
        return context;
    }
}
