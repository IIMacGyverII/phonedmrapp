package com.mediatek.powerhalmgr;

import android.content.Context;
import android.os.IBinder;
import android.os.IRemoteCallback;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.util.Log;
import com.mediatek.powerhalmgr.IPowerHalMgr;

public class PowerHalMgrImpl extends PowerHalMgr {
    private static final String TAG = "PowerHalMgrImpl";
    private static Object lock = new Object();
    private static PowerHalMgrImpl sInstance;
    private int inited = 0;
    private Context mContext;
    private long mPreviousTime = 0;
    private IPowerHalMgr sService = null;
    private int setTid = 0;

    public static native int nativeGetPid();

    public static native int nativeGetTid();

    private void init() {
        IBinder checkService;
        if (this.inited == 0 && (checkService = ServiceManager.checkService("power_hal_mgr_service")) != null) {
            IPowerHalMgr asInterface = IPowerHalMgr.Stub.asInterface(checkService);
            this.sService = asInterface;
            if (asInterface != null) {
                this.inited = 1;
            } else {
                loge("ERR: getService() sService is still null..");
            }
        }
    }

    public static PowerHalMgrImpl getInstance() {
        PowerHalMgrImpl powerHalMgrImpl;
        synchronized (lock) {
            if (sInstance == null) {
                sInstance = new PowerHalMgrImpl();
            }
            powerHalMgrImpl = sInstance;
        }
        return powerHalMgrImpl;
    }

    public int scnReg() {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.scnReg();
            }
            return -1;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in scnReg:" + e);
            return -1;
        }
    }

    public void scnConfig(int i, int i2, int i3, int i4, int i5, int i6) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.scnConfig(i, i2, i3, i4, i5, i6);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in scnConfig:" + e);
        }
    }

    public void scnUnreg(int i) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.scnUnreg(i);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in scnUnreg:" + e);
        }
    }

    public void scnEnable(int i, int i2) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.scnEnable(i, i2);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in scnEnable:" + e);
        }
    }

    public void scnDisable(int i) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.scnDisable(i);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in scnDisable:" + e);
        }
    }

    public void scnUltraCfg(int i, int i2, int i3, int i4, int i5, int i6) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.scnUltraCfg(i, i2, i3, i4, i5, i6);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in scnConfig:" + e);
        }
    }

    public void mtkCusPowerHint(int i, int i2) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.mtkCusPowerHint(i, i2);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in mtkCusPowerHint:" + e);
        }
    }

    public void getCpuCap() {
        log("getCpuCap");
    }

    public void getGpuCap() {
        log("getGpuCap");
    }

    public void getGpuRTInfo() {
        log("getGpuRTInfo");
    }

    public void getCpuRTInfo() {
        log("getCpuRTInfo");
    }

    public void UpdateManagementPkt(int i, String str) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.UpdateManagementPkt(i, str);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in UpdateManagementPkt:" + e);
        }
    }

    public void setForegroundSports() {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.setForegroundSports();
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in setForegroundSports:" + e);
        }
    }

    public void setSysInfo(int i, String str) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.setSysInfo(i, str);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in setSysInfo:" + e);
        }
    }

    public boolean startDuplicatePacketPrediction() {
        logd("startDuplicatePacketPrediction()");
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.startDuplicatePacketPrediction();
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in startDuplicatePacketPrediction:" + e);
            return false;
        }
    }

    public boolean stopDuplicatePacketPrediction() {
        logd("stopDuplicatePacketPrediction()");
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.stopDuplicatePacketPrediction();
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in stopDuplicatePacketPrediction:" + e);
            return false;
        }
    }

    public boolean isDupPacketPredictionStarted() {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr == null) {
                return false;
            }
            boolean isDupPacketPredictionStarted = iPowerHalMgr.isDupPacketPredictionStarted();
            logd("isDupPacketPredictionStarted() enable:" + isDupPacketPredictionStarted);
            return isDupPacketPredictionStarted;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in isDupPacketPredictionStarted:" + e);
            return false;
        }
    }

    public boolean registerDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) {
        logd("registerDuplicatePacketPredictionEvent() " + iRemoteCallback.getClass().toString());
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.registerDuplicatePacketPredictionEvent(iRemoteCallback);
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in registerDuplicatePacketPredictionEvent:" + e);
            return false;
        }
    }

    public boolean unregisterDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) {
        logd("unregisterDuplicatePacketPredictionEvent() " + iRemoteCallback.getClass().toString());
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.unregisterDuplicatePacketPredictionEvent(iRemoteCallback);
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in unregisterDuplicatePacketPredictionEvent:" + e);
            return false;
        }
    }

    public boolean updateMultiDuplicatePacketLink(DupLinkInfo[] dupLinkInfoArr) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.updateMultiDuplicatePacketLink(dupLinkInfoArr);
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in updateMultiDuplicatePacketLink:" + e);
            return false;
        }
    }

    public boolean setPriorityByUid(int i, int i2) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.setPriorityByUid(i, i2);
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in setPriorityByUid:" + e);
            return false;
        }
    }

    public boolean setPriorityByLinkinfo(int i, DupLinkInfo dupLinkInfo) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.setPriorityByLinkinfo(i, dupLinkInfo);
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in setPriorityByLinkinfo:" + e);
            return false;
        }
    }

    public boolean flushPriorityRules(int i) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.flushPriorityRules(i);
            }
            return false;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in flushPriorityRules:" + e);
            return false;
        }
    }

    public boolean configBoosterInfo(BoosterInfo boosterInfo) {
        if (boosterInfo == null) {
            loge("[Booster]: info == null");
            return false;
        } else if (boosterInfo.getGroup() > BoosterInfo.BOOSTER_GROUP_MAX || boosterInfo.getGroup() <= BoosterInfo.BOOSTER_GROUP_BASE) {
            loge("[Booster]: Unsupported group " + boosterInfo.getGroup());
            return false;
        } else {
            try {
                init();
                IPowerHalMgr iPowerHalMgr = this.sService;
                if (iPowerHalMgr != null) {
                    return iPowerHalMgr.configBoosterInfo(boosterInfo);
                }
                return false;
            } catch (RemoteException e) {
                loge("[Booster]: RemoteException in configBoosterInfo: " + e);
                return false;
            }
        }
    }

    public void setPredictInfo(String str, int i) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.setPredictInfo(str, i);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in setPredictInfo:" + e);
        }
    }

    public int perfLockAcquire(int i, int i2, int[] iArr) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.perfLockAcquire(i, i2, iArr);
            }
            return i;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in perfLockAcquire:" + e);
            return i;
        }
    }

    public void perfLockRelease(int i) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.perfLockRelease(i);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in perfLockRelease:" + e);
        }
    }

    public int perfCusLockHint(int i, int i2) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.perfCusLockHint(i, i2);
            }
            return -1;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in perfCusLockHint:" + e);
            return -1;
        }
    }

    public int querySysInfo(int i, int i2) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.querySysInfo(i, i2);
            }
            return -1;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in perfLockAcquire:" + e);
            return -1;
        }
    }

    public void mtkPowerHint(int i, int i2) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                iPowerHalMgr.mtkPowerHint(i, i2);
            }
        } catch (RemoteException e) {
            loge("ERR: RemoteException in mtkPowerHint:" + e);
        }
    }

    public int setSysInfoSync(int i, String str) {
        try {
            init();
            IPowerHalMgr iPowerHalMgr = this.sService;
            if (iPowerHalMgr != null) {
                return iPowerHalMgr.setSysInfoSync(i, str);
            }
            return -1;
        } catch (RemoteException e) {
            loge("ERR: RemoteException in setPredictInfo:" + e);
            return -1;
        }
    }

    private void log(String str) {
        Log.i(TAG, str + " ");
    }

    private void logd(String str) {
        Log.d(TAG, str + " ");
    }

    private void loge(String str) {
        Log.e(TAG, "ERR: " + str + " ");
    }
}
