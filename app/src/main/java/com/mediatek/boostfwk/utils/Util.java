package com.mediatek.boostfwk.utils;

import android.app.AppGlobals;
import android.content.pm.ApplicationInfo;
import android.hardware.display.DisplayManagerGlobal;
import android.os.Looper;
import android.os.RemoteException;
import android.os.UserHandle;
import android.view.WindowManager;
import java.io.File;

public final class Util {
    private static final String TAG = "SBE-Util";
    private static final String[] sGameLibs = {"libGame.so", "libhegame.so"};

    public static boolean isGameApp(String str) {
        try {
            ApplicationInfo applicationInfo = AppGlobals.getPackageManager().getApplicationInfo(str, 0, UserHandle.getCallingUserId());
            if (applicationInfo == null || (applicationInfo.flags & 33554432) == 33554432) {
                return true;
            }
            for (String file : sGameLibs) {
                if (new File(applicationInfo.nativeLibraryDir, file).exists()) {
                    return true;
                }
            }
            return false;
        } catch (RemoteException e) {
            LogUtil.mLoge(TAG, "isGameApp exception :" + e);
        }
    }

    public static boolean isSystemApp(String str) {
        try {
            ApplicationInfo applicationInfo = AppGlobals.getPackageManager().getApplicationInfo(str, 0, UserHandle.getCallingUserId());
            if (applicationInfo == null) {
                return false;
            }
            int i = applicationInfo.flags;
            if ((i & 1) == 0 && (i & 128) == 0) {
                return false;
            }
            return true;
        } catch (RemoteException e) {
            LogUtil.mLoge(TAG, "isSystemApp exception :" + e);
        }
    }

    public static boolean IsFullScreen(WindowManager.LayoutParams layoutParams) {
        return layoutParams != null && (layoutParams.flags & 1024) == 1024;
    }

    public static float getRefreshRate() {
        return DisplayManagerGlobal.getInstance().getDisplayInfo(0).getMode().getRefreshRate();
    }

    public static boolean isMainThread() {
        return Looper.getMainLooper().getThread() == Thread.currentThread();
    }
}
