package com.mediatek.boostfwk.identify.refreshrate;

import android.app.Activity;
import android.content.Context;
import android.view.MotionEvent;
import android.view.Window;
import com.mediatek.boostfwk.identify.BaseIdentify;
import com.mediatek.boostfwk.identify.ime.IMEIdentify;
import com.mediatek.boostfwk.identify.message.MsgIdentify;
import com.mediatek.boostfwk.identify.scroll.ScrollIdentify;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.policy.refreshrate.RefreshRatePolicy;
import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.scenario.refreshrate.EventScenario;
import com.mediatek.boostfwk.scenario.refreshrate.RefreshRateScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.TasksUtil;

public class RefreshRateIdentify extends BaseIdentify implements IMEIdentify.IMEStateListener, MsgIdentify.AudioStateListener, ScrollIdentify.TouchEventListener {
    private static final String TAG = "MSYNC3-VariableRefreshRate";
    private static Object lock = new Object();
    private static RefreshRateIdentify sInstance;
    private ActivityInfo activityInfo;
    private boolean mIsConfigInited;
    private boolean mIsSmoothFlingEnabled;
    private boolean mIsVeriableRefreshRateSupported;
    private String mPackageName;
    private RefreshRatePolicy mRefreshRatePolicy;

    public static RefreshRateIdentify getInstance() {
        if (sInstance == null) {
            synchronized (lock) {
                if (sInstance == null) {
                    sInstance = new RefreshRateIdentify();
                }
            }
        }
        return sInstance;
    }

    private RefreshRateIdentify() {
        this.activityInfo = null;
        this.mIsVeriableRefreshRateSupported = false;
        this.mIsConfigInited = false;
        this.mIsSmoothFlingEnabled = false;
        this.mPackageName = null;
        this.mIsVeriableRefreshRateSupported = Config.isVariableRefreshRateSupported();
        this.mIsSmoothFlingEnabled = Config.isMSync3SmoothFlingEnabled();
        if (this.mIsVeriableRefreshRateSupported) {
            LogUtil.mLogi(TAG, "Variable refreshrate is enabled");
            this.mRefreshRatePolicy = new RefreshRatePolicy();
            IMEIdentify.getInstance().registerIMEStateListener(this);
            MsgIdentify.getInstance().registerAudioStateListener(this);
            ScrollIdentify.getInstance().registerTouchEventListener(this);
            return;
        }
        LogUtil.mLogi(TAG, "Variable refreshrate is disabled");
    }

    private void configInit(RefreshRateScenario refreshRateScenario) {
        if (refreshRateScenario == null) {
            return;
        }
        if (refreshRateScenario.getScenarioContext() != null) {
            Context scenarioContext = refreshRateScenario.getScenarioContext();
            String packageName = ActivityInfo.getInstance().getPackageName();
            this.mPackageName = packageName;
            if (packageName == null) {
                this.mPackageName = scenarioContext.getPackageName();
            }
            String str = this.mPackageName;
            if (str == null || Config.SYSTEM_PACKAGE_ARRAY.contains(str)) {
                this.mIsVeriableRefreshRateSupported = false;
                this.mRefreshRatePolicy.setVeriableRefreshRateSupported(false);
                LogUtil.mLogi(TAG, "App is not support");
            }
            if (this.mIsVeriableRefreshRateSupported && TasksUtil.isGameAPP(this.mPackageName)) {
                this.mIsVeriableRefreshRateSupported = false;
                this.mRefreshRatePolicy.setVeriableRefreshRateSupported(false);
                LogUtil.mLogi(TAG, "Game is not support");
            }
            this.mIsConfigInited = true;
            return;
        }
        this.mIsConfigInited = false;
    }

    public boolean dispatchScenario(BasicScenario basicScenario) {
        if (!this.mIsVeriableRefreshRateSupported) {
            return false;
        }
        LogUtil.traceBegin("Dispatch refresh rate scenario");
        if (basicScenario != null) {
            if (basicScenario.getScenario() == 6) {
                RefreshRateScenario refreshRateScenario = (RefreshRateScenario) basicScenario;
                if (!this.mIsConfigInited) {
                    configInit(refreshRateScenario);
                }
                Context scenarioContext = refreshRateScenario.getScenarioContext();
                if (scenarioContext != null && (scenarioContext instanceof Activity)) {
                    this.mRefreshRatePolicy.dispatchScenario(refreshRateScenario);
                    LogUtil.traceEnd();
                    return true;
                }
            } else if (basicScenario.getScenario() == 7) {
                this.mRefreshRatePolicy.dispatchEvent((EventScenario) basicScenario);
                LogUtil.traceEnd();
                return true;
            }
        }
        LogUtil.traceEnd();
        return false;
    }

    public void onTouchEvent(MotionEvent motionEvent) {
        if (this.mIsVeriableRefreshRateSupported) {
            this.mRefreshRatePolicy.onTouchEvent(motionEvent);
        }
    }

    public void onInit(Window window) {
        if (this.mIsVeriableRefreshRateSupported) {
            this.mRefreshRatePolicy.onIMEInit(window);
        }
    }

    public void onVisibilityChange(boolean z) {
        if (this.mIsVeriableRefreshRateSupported) {
            this.mRefreshRatePolicy.onIMEVisibilityChange(z);
        }
    }

    public void onAudioMsgStatusUpdate(boolean z) {
        if (this.mIsVeriableRefreshRateSupported) {
            this.mRefreshRatePolicy.onVoiceDialogEvent(z);
        }
    }
}
