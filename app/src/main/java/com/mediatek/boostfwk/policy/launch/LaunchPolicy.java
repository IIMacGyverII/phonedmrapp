package com.mediatek.boostfwk.policy.launch;

import android.os.Trace;
import com.mediatek.powerhalmgr.PowerHalMgr;
import com.mediatek.powerhalmgr.PowerHalMgrFactory;

public class LaunchPolicy {
    private static int MTKPOWER_HINT_PROCESS_CREATE = 21;
    private static int PERF_RES_POWER_END_HINT_HOLD_TIME = 54592256;
    private static final String TAG = "SBE-LaunchPolicy";
    private static int mPowerHandle = 0;
    private static int mReleaseLaunchDuration = 3000;
    private PowerHalMgr mPowerHalService = PowerHalMgrFactory.getInstance().makePowerHalMgr();

    public void boostEnd(String str) {
        Trace.traceBegin(64, "SBE boost end");
        perfLockAcquire(new int[]{PERF_RES_POWER_END_HINT_HOLD_TIME, MTKPOWER_HINT_PROCESS_CREATE});
        Trace.traceEnd(64);
    }

    private void perfLockAcquire(int[] iArr) {
        PowerHalMgr powerHalMgr = this.mPowerHalService;
        if (powerHalMgr != null) {
            int perfLockAcquire = powerHalMgr.perfLockAcquire(mPowerHandle, mReleaseLaunchDuration, iArr);
            mPowerHandle = perfLockAcquire;
            this.mPowerHalService.perfLockRelease(perfLockAcquire);
        }
    }
}
