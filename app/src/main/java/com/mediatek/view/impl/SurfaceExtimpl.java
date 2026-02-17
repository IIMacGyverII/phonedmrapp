package com.mediatek.view.impl;

import android.content.pm.IPackageManager;
import android.os.Binder;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.SystemProperties;
import android.util.Log;
import com.mediatek.appresolutiontuner.ResolutionTunerAppList;
import com.mediatek.view.SurfaceExt;

public class SurfaceExtimpl extends SurfaceExt {
    private static final boolean APP_RESOLUTION_TUNING_AI_ENABLE = "1".equals(SystemProperties.get("ro.vendor.game_aisr_enable"));
    private static final int ENABLE_RESOLUTION_TUNING = SystemProperties.getInt("ro.vendor.app_resolution_tuner", 0);
    private static final boolean ENABLE_WHITE_LIST = SystemProperties.getBoolean("debug.enable.whitelist", false);
    private static final String TAG = "SurfaceExt";
    private static final String[] WHITE_LIST = {"com.tencent.qqlive"};
    private static ResolutionTunerAppList mApplist = null;
    private boolean mIsContainPackageName = false;
    private boolean mIsScaledByGameMode = false;
    private String mPackageName;
    private float mXScaleValue = 1.0f;
    private float mYScaleValue = 1.0f;

    public boolean isInWhiteList() {
        if (ENABLE_WHITE_LIST) {
            return true;
        }
        String callerProcessName = getCallerProcessName();
        String[] strArr = WHITE_LIST;
        if (!(strArr == null || callerProcessName == null)) {
            for (String equals : strArr) {
                if (equals.equals(callerProcessName)) {
                    return true;
                }
            }
        }
        return false;
    }

    public void initResolutionTunner() {
        if (ENABLE_RESOLUTION_TUNING == 1 && mApplist == null) {
            this.mPackageName = getCallerProcessName();
            ResolutionTunerAppList tunerList = getTunerList();
            mApplist = tunerList;
            this.mIsContainPackageName = tunerList.isScaledBySurfaceView(this.mPackageName);
            this.mIsScaledByGameMode = mApplist.isScaledByGameMode(this.mPackageName);
            if (mApplist.getScaleWidth(this.mPackageName) == 0.0f || mApplist.getScaleHeight(this.mPackageName) == 0.0f) {
                float scaleValue = mApplist.getScaleValue(this.mPackageName);
                this.mXScaleValue = scaleValue;
                this.mYScaleValue = scaleValue;
            } else {
                this.mXScaleValue = mApplist.getScaleWidth(this.mPackageName);
                this.mYScaleValue = mApplist.getScaleHeight(this.mPackageName);
            }
            Log.d(TAG, "initResolutionTunner, mPackageName:" + this.mPackageName + ",mContainPackageName:" + this.mIsContainPackageName + "mXScaleValue:" + this.mXScaleValue + ",mYScaleValue:" + this.mYScaleValue);
        }
    }

    public boolean isResolutionTuningPackage() {
        return this.mIsContainPackageName;
    }

    public boolean isScaledByGameMode() {
        return this.mIsScaledByGameMode;
    }

    public float getXScale() {
        return this.mXScaleValue;
    }

    public float getYScale() {
        return this.mYScaleValue;
    }

    private ResolutionTunerAppList getTunerList() {
        ResolutionTunerAppList instance = ResolutionTunerAppList.getInstance();
        instance.loadTunerAppList();
        return instance;
    }

    private String getCallerProcessName() {
        int callingUid = Binder.getCallingUid();
        IPackageManager asInterface = IPackageManager.Stub.asInterface(ServiceManager.getService("package"));
        if (asInterface == null) {
            return null;
        }
        try {
            return asInterface.getNameForUid(callingUid);
        } catch (RemoteException e) {
            Log.e(TAG, "getCallerProcessName exception :" + e);
            return null;
        }
    }
}
