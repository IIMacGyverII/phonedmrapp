package com.mediatek.boostframework;

import android.util.Log;
import com.mediatek.powerhalwrapper.PowerHalWrapper;

public class Performance {
    private static final String TAG = "Performance";
    private static PowerHalWrapper mPowerHalWrap;
    private int mhandle = 0;

    public Performance() {
        mPowerHalWrap = PowerHalWrapper.getInstance();
    }

    public int perfchecklist(int... iArr) {
        return iArr.length % 2 == 0 ? 1 : 0;
    }

    public int perfLockAcquire(int i, int... iArr) {
        if (perfchecklist(iArr) == 0) {
            return -1;
        }
        int perfLockAcquire = mPowerHalWrap.perfLockAcquire(this.mhandle, i, iArr);
        this.mhandle = perfLockAcquire;
        return perfLockAcquire;
    }

    public int perfLockRelease() {
        mPowerHalWrap.perfLockRelease(this.mhandle);
        return 0;
    }

    public int perfLockRelease(int i) {
        mPowerHalWrap.perfLockRelease(i);
        return 0;
    }

    private static void log(String str) {
        Log.d("@M_Performance", "[Performance] " + str + " ");
    }

    private static void loge(String str) {
        Log.e("@M_Performance", "[Performance] ERR: " + str + " ");
    }
}
