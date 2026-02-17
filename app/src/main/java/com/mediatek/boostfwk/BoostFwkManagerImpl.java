package com.mediatek.boostfwk;

import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.utils.Config;

public final class BoostFwkManagerImpl extends BoostFwkManager {
    private static BoostModuleDispatcher sBoostDispatcher = BoostModuleDispatcher.getInstance();
    private static BoostFwkManagerImpl sInstance;
    private static Object sLock = new Object();

    public static BoostFwkManagerImpl getInstance() {
        if (sInstance == null) {
            synchronized (sLock) {
                if (sInstance == null) {
                    sInstance = new BoostFwkManagerImpl();
                }
            }
        }
        return sInstance;
    }

    public void perfHint(BasicScenario basicScenario) {
        if (!Config.disableSBE()) {
            sBoostDispatcher.scenarioActionDispatcher(basicScenario);
        }
    }

    public void perfHint(BasicScenario... basicScenarioArr) {
        if (!Config.disableSBE()) {
            for (BasicScenario basicScenario : basicScenarioArr) {
                if (basicScenario != null) {
                    sBoostDispatcher.scenarioActionDispatcher(basicScenario);
                }
            }
        }
    }
}
