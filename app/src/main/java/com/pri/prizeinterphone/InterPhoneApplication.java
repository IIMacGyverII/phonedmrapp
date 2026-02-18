package com.pri.prizeinterphone;

import android.app.Application;
import android.content.Context;
/* loaded from: classes4.dex */
public class InterPhoneApplication extends Application {
    private static Context context;
    private static InterPhoneApplication instance;

    public static InterPhoneApplication getInstance() {
        return instance;
    }

    @Override // android.app.Application
    public void onCreate() {
        super.onCreate();
        instance = this;
        context = getApplicationContext();
    }

    public static Context getContext() {
        return context;
    }
}
