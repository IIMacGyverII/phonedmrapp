package com.mediatek.boostfwk.identify.ime;

import android.view.Window;
import com.mediatek.boostfwk.identify.BaseIdentify;
import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.scenario.ime.IMEScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import java.util.ArrayList;
import java.util.List;

public class IMEIdentify extends BaseIdentify {
    private static final Object LOCK = new Object();
    private static final String TAG = "IMEIdentify";
    private static IMEIdentify mInstance;
    private List<IMEStateListener> mIMEStateListeners = new ArrayList();
    private boolean mImeShow = false;

    public interface IMEStateListener {
        void onInit(Window window);

        void onVisibilityChange(boolean z);
    }

    public boolean isMainThreadOnly() {
        return false;
    }

    public static IMEIdentify getInstance() {
        if (mInstance == null) {
            synchronized (LOCK) {
                if (mInstance == null) {
                    mInstance = new IMEIdentify();
                }
            }
        }
        return mInstance;
    }

    private IMEIdentify() {
    }

    public boolean dispatchScenario(BasicScenario basicScenario) {
        if (basicScenario == null) {
            return false;
        }
        IMEScenario iMEScenario = (IMEScenario) basicScenario;
        int scenarioAction = iMEScenario.getScenarioAction();
        if (scenarioAction == 1) {
            notifyVisibilityChange(true);
        } else if (scenarioAction == 2) {
            notifyVisibilityChange(false);
        } else if (scenarioAction == 3) {
            notifyIMEInit(iMEScenario.getWindowAndClear());
        } else if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "not support scnario action");
        }
        return true;
    }

    private void notifyIMEInit(Window window) {
        if (window != null) {
            for (IMEStateListener onInit : this.mIMEStateListeners) {
                onInit.onInit(window);
            }
        }
    }

    private void notifyVisibilityChange(boolean z) {
        if (this.mImeShow != z) {
            this.mImeShow = z;
            for (IMEStateListener onVisibilityChange : this.mIMEStateListeners) {
                onVisibilityChange.onVisibilityChange(z);
            }
        }
    }

    public void registerIMEStateListener(IMEStateListener iMEStateListener) {
        if (iMEStateListener != null) {
            this.mIMEStateListeners.add(iMEStateListener);
        }
    }
}
