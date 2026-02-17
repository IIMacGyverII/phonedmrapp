package com.mediatek.boostfwk;

import android.util.SparseArray;
import com.mediatek.boostfwk.identify.BaseIdentify;
import com.mediatek.boostfwk.identify.frame.FrameIdentify;
import com.mediatek.boostfwk.identify.ime.IMEIdentify;
import com.mediatek.boostfwk.identify.launch.LaunchIdentify;
import com.mediatek.boostfwk.identify.message.MsgIdentify;
import com.mediatek.boostfwk.identify.refreshrate.RefreshRateIdentify;
import com.mediatek.boostfwk.identify.scroll.ScrollIdentify;
import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.Util;

public final class BoostModuleDispatcher {
    private static final SparseArray<BaseIdentify> SCENARIO_DIENTIFY = new SparseArray<>();
    private static final String TAG = "BoostModuleDispatcher";
    private static BoostModuleDispatcher sInstance;
    private static Object sLock = new Object();

    public static BoostModuleDispatcher getInstance() {
        if (sInstance == null) {
            synchronized (sLock) {
                if (sInstance == null) {
                    sInstance = new BoostModuleDispatcher();
                }
            }
        }
        return sInstance;
    }

    public BoostModuleDispatcher() {
        rigisterScenarioCallback(1, ScrollIdentify.getInstance());
        rigisterScenarioCallback(2, FrameIdentify.getInstance());
        rigisterScenarioCallback(3, LaunchIdentify.getInstance());
        rigisterScenarioCallback(5, IMEIdentify.getInstance());
        rigisterScenarioCallback(4, MsgIdentify.getInstance());
        rigisterScenarioCallback(6, RefreshRateIdentify.getInstance());
        rigisterScenarioCallback(7, RefreshRateIdentify.getInstance());
    }

    public void scenarioActionDispatcher(BasicScenario basicScenario) {
        if (basicScenario == null) {
            LogUtil.mLogw(TAG, "No scenario to dispatcher.");
            return;
        }
        BaseIdentify baseIdentify = SCENARIO_DIENTIFY.get(basicScenario.getScenario());
        if (baseIdentify == null) {
            LogUtil.mLogw(TAG, "Not found identify scenario.");
        } else if (!baseIdentify.isMainThreadOnly() || Util.isMainThread()) {
            baseIdentify.dispatchScenario(basicScenario);
        }
    }

    public boolean rigisterScenarioCallback(int i, BaseIdentify baseIdentify) {
        if (baseIdentify == null) {
            return false;
        }
        SCENARIO_DIENTIFY.put(i, baseIdentify);
        return true;
    }
}
