package com.mediatek.boostfwk.identify;

import com.mediatek.boostfwk.scenario.BasicScenario;

public class BaseIdentify {
    private static final String TAG = "BaseIdentify";

    public boolean dispatchScenario(BasicScenario basicScenario) {
        return true;
    }

    public boolean isMainThreadOnly() {
        return true;
    }
}
