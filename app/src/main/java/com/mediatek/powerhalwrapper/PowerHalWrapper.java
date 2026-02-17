package com.mediatek.powerhalwrapper;

import android.os.Binder;
import android.os.Process;
import android.os.Trace;
import android.util.Log;
import com.mediatek.boostfwk.identify.launch.LaunchIdentify;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class PowerHalWrapper {
    private static boolean AMS_BOOST_ACT_SWITCH = true;
    private static boolean AMS_BOOST_PACK_SWITCH = true;
    private static boolean AMS_BOOST_PROCESS_CREATE = true;
    private static boolean AMS_BOOST_PROCESS_CREATE_BOOST = true;
    private static final int AMS_BOOST_TIME = 10000;
    private static final boolean ENG = true;
    private static boolean EXT_PEAK_PERF_MODE = false;
    public static final int MAX_NETD_IP_FILTER_COUNT = 3;
    public static final int MTKPOWER_CMD_GET_POWER_SCN_TYPE = 105;
    public static final int MTKPOWER_CMD_GET_RILD_CAP = 40;
    private static final int MTKPOWER_HINT_ACT_SWITCH = 23;
    private static final int MTKPOWER_HINT_ALWAYS_ENABLE = 268435455;
    private static final int MTKPOWER_HINT_APP_ROTATE = 24;
    private static final int MTKPOWER_HINT_EXT_LAUNCH = 30;
    private static final int MTKPOWER_HINT_GALLERY_BOOST = 26;
    private static final int MTKPOWER_HINT_PACK_SWITCH = 22;
    private static final int MTKPOWER_HINT_PMS_INSTALL = 29;
    private static final int MTKPOWER_HINT_PROCESS_CREATE = 21;
    private static final int MTKPOWER_HINT_WFD = 28;
    private static final int MTKPOWER_HINT_WIPHY_SPEED_DL = 32;
    private static final int MTKPOWER_STATE_DEAD = 3;
    private static final int MTKPOWER_STATE_DESTORYED = 2;
    private static final int MTKPOWER_STATE_PAUSED = 0;
    private static final int MTKPOWER_STATE_RESUMED = 1;
    private static final int MTKPOWER_STATE_STOPPED = 4;
    public static final int PERF_RES_NET_MD_CRASH_PID = 41992960;
    public static final int PERF_RES_NET_WIFI_SMART_PREDICT = 41959680;
    public static final int PERF_RES_POWERHAL_SCREEN_OFF_STATE = 54525952;
    public static final int POWER_HIDL_SET_SYS_INFO = 0;
    public static final int SCN_PERF_LOCK_HINT = 3;
    public static final int SCN_USER_HINT = 2;
    public static final int SCREEN_OFF_DISABLE = 0;
    public static final int SCREEN_OFF_ENABLE = 1;
    public static final int SCREEN_OFF_WAIT_RESTORE = 2;
    public static final int SETSYS_FOREGROUND_SPORTS = 3;
    public static final int SETSYS_INTERNET_STATUS = 5;
    public static final int SETSYS_MANAGEMENT_PERIODIC = 4;
    public static final int SETSYS_MANAGEMENT_PREDICT = 1;
    public static final int SETSYS_NETD_BOOSTER_CONFIG = 18;
    public static final int SETSYS_NETD_CLEAR_FASTPATH_RULES = 17;
    public static final int SETSYS_NETD_DUPLICATE_PACKET_LINK = 8;
    public static final int SETSYS_NETD_SET_FASTPATH_BY_LINKINFO = 16;
    public static final int SETSYS_NETD_SET_FASTPATH_BY_UID = 15;
    public static final int SETSYS_NETD_STATUS = 6;
    public static final int SETSYS_PACKAGE_VERSION_NAME = 9;
    public static final int SETSYS_PREDICT_INFO = 7;
    public static final int SETSYS_SPORTS_APK = 2;
    private static final String TAG = "PowerHalWrapper";
    private static final int USER_DURATION_MAX = 30000;
    private static Object lock = new Object();
    private static String mProcessCreatePack;
    private static PowerHalWrapper sInstance;
    private Lock mLock = new ReentrantLock();
    public List<ScnList> scnlist = new ArrayList();

    public static native int nativeMtkCusPowerHint(int i, int i2);

    public static native int nativeMtkPowerHint(int i, int i2);

    public static native int nativeNotifyAppState(String str, String str2, int i, int i2, int i3);

    public static native int nativeNotifyFrame(int i, int i2, long j);

    public static native int nativeNotifySbeRescue(int i, int i2, int i3, long j);

    public static native int nativePerfCusLockHint(int i, int i2);

    public static native int nativePerfLockAcq(int i, int i2, int... iArr);

    public static native int nativePerfLockRel(int i);

    public static native int nativeQuerySysInfo(int i, int i2);

    public static native int nativeScnConfig(int i, int i2, int i3, int i4, int i5, int i6);

    public static native int nativeScnDisable(int i);

    public static native int nativeScnEnable(int i, int i2);

    public static native int nativeScnReg();

    public static native int nativeScnUltraCfg(int i, int i2, int i3, int i4, int i5, int i6);

    public static native int nativeScnUnreg(int i);

    public static native int nativeSetSbePolicy(String str, int i, int i2, int i3);

    public static native int nativeSetSysInfo(String str, int i);

    public static native int nativeSetSysInfoAsync(String str, int i);

    static {
        System.loadLibrary("powerhalwrap_jni");
    }

    public static PowerHalWrapper getInstance() {
        PowerHalWrapper powerHalWrapper;
        log("PowerHalWrapper.getInstance");
        synchronized (lock) {
            if (sInstance == null) {
                sInstance = new PowerHalWrapper();
            }
            powerHalWrapper = sInstance;
        }
        return powerHalWrapper;
    }

    private PowerHalWrapper() {
    }

    public void mtkPowerHint(int i, int i2) {
        nativeMtkPowerHint(i, i2);
    }

    public void mtkCusPowerHint(int i, int i2) {
        nativeMtkCusPowerHint(i, i2);
    }

    public void mtkNotifySbeRescue(int i, int i2, int i3, long j) {
        nativeNotifySbeRescue(i, i2, i3, j);
    }

    public void mtkNotifyFrame(int i, int i2, long j) {
        nativeNotifyFrame(i, i2, j);
    }

    public void mtkSetSbePolicy(String str, int i, int i2, int i3) {
        nativeSetSbePolicy(str, i, i2, i3);
    }

    public int perfLockAcquire(int i, int i2, int... iArr) {
        int callingPid = Binder.getCallingPid();
        int callingUid = Binder.getCallingUid();
        int nativePerfLockAcq = nativePerfLockAcq(i, i2, iArr);
        if (nativePerfLockAcq > 0 && nativePerfLockAcq != i && (i2 > USER_DURATION_MAX || i2 == 0)) {
            this.mLock.lock();
            this.scnlist.add(new ScnList(nativePerfLockAcq, callingPid, callingUid));
            this.mLock.unlock();
        }
        return nativePerfLockAcq;
    }

    public void perfLockRelease(int i) {
        this.mLock.lock();
        List<ScnList> list = this.scnlist;
        if (list != null && list.size() > 0) {
            Iterator<ScnList> it = this.scnlist.iterator();
            while (it.hasNext()) {
                if (it.next().gethandle() == i) {
                    it.remove();
                }
            }
        }
        this.mLock.unlock();
        nativePerfLockRel(i);
    }

    public int perfCusLockHint(int i, int i2) {
        return nativePerfCusLockHint(i, i2);
    }

    public int scnReg() {
        loge("scnReg not support!!!");
        return -1;
    }

    public int scnConfig(int i, int i2, int i3, int i4, int i5, int i6) {
        loge("scnConfig not support!!!");
        return 0;
    }

    public int scnUnreg(int i) {
        loge("scnUnreg not support!!!");
        return 0;
    }

    public int scnEnable(int i, int i2) {
        loge("scnEnable not support!!!");
        return 0;
    }

    public int scnDisable(int i) {
        loge("scnDisable not support!!!");
        return 0;
    }

    public int scnUltraCfg(int i, int i2, int i3, int i4, int i5, int i6) {
        loge("scnUltraCfg not support!!!");
        return 0;
    }

    public void getCpuCap() {
        log("getCpuCap");
    }

    public void getGpuCap() {
        log("mGpuCap");
    }

    public void getGpuRTInfo() {
        log("getGpuCap");
    }

    public void getCpuRTInfo() {
        log("mCpuRTInfo");
    }

    public void UpdateManagementPkt(int i, String str) {
        logd("<UpdateManagementPkt> type:" + i + ", packet:" + str);
        if (i == 1) {
            nativeSetSysInfo(str, 1);
        } else if (i == 4) {
            nativeSetSysInfo(str, 4);
        }
    }

    public int setSysInfo(int i, String str) {
        return nativeSetSysInfo(str, i);
    }

    public void setSysInfoAsync(int i, String str) {
        nativeSetSysInfoAsync(str, i);
    }

    public int querySysInfo(int i, int i2) {
        logd("<querySysInfo> cmd:" + i + " param:" + i2);
        return nativeQuerySysInfo(i, i2);
    }

    public void galleryBoostEnable(int i) {
        log("<galleryBoostEnable> do boost with " + i + "ms");
        nativeMtkPowerHint(26, i);
    }

    public void setRotationBoost(int i) {
        log("<setRotation> do boost with " + i + "ms");
        nativeMtkPowerHint(24, i);
    }

    public void setSpeedDownload(int i) {
        log("<setSpeedDownload> do boost with " + i + "ms");
        nativeMtkPowerHint(32, i);
    }

    public void setWFD(boolean z) {
        log("<setWFD> enable:" + z);
        if (z) {
            nativeMtkPowerHint(28, MTKPOWER_HINT_ALWAYS_ENABLE);
        } else {
            nativeMtkPowerHint(28, 0);
        }
    }

    public void setSportsApk(String str) {
        log("<setSportsApk> pack:" + str);
        nativeSetSysInfo(str, 2);
    }

    public void NotifyAppCrash(int i, int i2, String str) {
        int myPid = Process.myPid();
        if (myPid == i) {
            log("<NotifyAppCrash> pack:" + str + " ,pid:" + str + " == myPid:" + myPid);
            return;
        }
        nativeNotifyAppState(str, str, i, 3, i2);
        this.mLock.lock();
        List<ScnList> list = this.scnlist;
        if (list != null && list.size() > 0) {
            Iterator<ScnList> it = this.scnlist.iterator();
            while (it.hasNext()) {
                ScnList next = it.next();
                if (next.getpid() == i) {
                    nativePerfLockRel(next.gethandle());
                    log("<NotifyAppCrash> pid:" + next.getpid() + " uid:" + next.getuid() + " handle:" + next.gethandle());
                    it.remove();
                }
            }
        }
        this.mLock.unlock();
    }

    public boolean getRildCap(int i) {
        return nativeQuerySysInfo(40, i) == 1;
    }

    public void setInstallationBoost(boolean z) {
        log("<setInstallationBoost> enable:" + z);
        if (z) {
            nativeMtkPowerHint(29, 15000);
        } else {
            nativeMtkPowerHint(29, 0);
        }
    }

    public void amsBoostResume(String str, String str2) {
        log("<amsBoostResume> last:" + str + ", next:" + str2);
        Trace.asyncTraceBegin(64, "amPerfBoost", 0);
        nativeMtkPowerHint(30, 0);
        if (str == null || !str.equalsIgnoreCase(str2)) {
            AMS_BOOST_PACK_SWITCH = true;
            nativeMtkPowerHint(22, AMS_BOOST_TIME);
            return;
        }
        AMS_BOOST_ACT_SWITCH = true;
        nativeMtkPowerHint(23, AMS_BOOST_TIME);
    }

    public void amsBoostProcessCreate(String str, String str2) {
        if (str != null && str.contains(LaunchIdentify.HOSTTYPE_ACTIVITY)) {
            log("amsBoostProcessCreate package:" + str2);
            Trace.asyncTraceBegin(64, "amPerfBoost", 0);
            AMS_BOOST_PROCESS_CREATE = true;
            AMS_BOOST_PROCESS_CREATE_BOOST = true;
            mProcessCreatePack = str2;
            nativeMtkPowerHint(30, 0);
            nativeMtkPowerHint(21, AMS_BOOST_TIME);
        }
    }

    public void amsBoostStop() {
        log("amsBoostStop AMS_BOOST_PACK_SWITCH:" + AMS_BOOST_PACK_SWITCH + ", AMS_BOOST_ACT_SWITCH:" + AMS_BOOST_ACT_SWITCH + ", AMS_BOOST_PROCESS_CREATE:" + AMS_BOOST_PROCESS_CREATE);
        if (AMS_BOOST_PACK_SWITCH) {
            AMS_BOOST_PACK_SWITCH = false;
            nativeMtkPowerHint(22, 0);
        }
        if (AMS_BOOST_ACT_SWITCH) {
            AMS_BOOST_ACT_SWITCH = false;
            nativeMtkPowerHint(23, 0);
        }
        if (AMS_BOOST_PROCESS_CREATE) {
            AMS_BOOST_PROCESS_CREATE = false;
            nativeMtkPowerHint(21, 0);
        }
        Trace.asyncTraceEnd(64, "amPerfBoost", 0);
    }

    public void amsBoostNotify(int i, String str, String str2, int i2, int i3) {
        log("amsBoostNotify pid:" + i + ",activity:" + str + ", package:" + str2 + ", mProcessCreatePack" + mProcessCreatePack);
        StringBuilder sb = new StringBuilder();
        sb.append("state: ");
        sb.append(i3);
        log(sb.toString());
        nativeNotifyAppState(str2, str, i, i3, i2);
        StringBuilder sb2 = new StringBuilder();
        sb2.append("amsBoostNotify AMS_BOOST_PROCESS_CREATE_BOOST:");
        sb2.append(AMS_BOOST_PROCESS_CREATE_BOOST);
        log(sb2.toString());
        String str3 = mProcessCreatePack;
        if (str3 != null && str2 != null && AMS_BOOST_PROCESS_CREATE_BOOST && !str3.equals(str2) && i3 == 1) {
            AMS_BOOST_PROCESS_CREATE_BOOST = false;
        }
    }

    private static void log(String str) {
        Log.i(TAG, str + " ");
    }

    private static void logd(String str) {
        Log.d(TAG, str + " ");
    }

    private static void loge(String str) {
        Log.e(TAG, "ERR: " + str + " ");
    }
}
