package com.macdmr.radio;

import android.app.Application;

import org.lsposed.hiddenapibypass.HiddenApiBypass;

public class RadioApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        // The vendor audio classes (android.os.PrizeTinyService / ITinyRecvCallback) are hidden API;
        // exempt everything before any class that references them is loaded.
        try { HiddenApiBypass.addHiddenApiExemptions(""); } catch (Throwable ignored) { }
    }
}
