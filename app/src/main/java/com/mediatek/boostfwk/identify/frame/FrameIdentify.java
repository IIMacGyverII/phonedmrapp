package com.mediatek.boostfwk.identify.frame;

import com.mediatek.boostfwk.identify.BaseIdentify;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.policy.frame.BaseFramePolicy;
import com.mediatek.boostfwk.policy.frame.FrameDecision;
import com.mediatek.boostfwk.policy.frame.FramePolicy;
import com.mediatek.boostfwk.policy.frame.FramePolicyV2;
import com.mediatek.boostfwk.policy.frame.ScrollingFramePrefetcher;
import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.scenario.frame.FrameScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;

public class FrameIdentify extends BaseIdentify {
    private static final int BOOST_FWK_VERSION = Config.getBoostFwkVersion();
    private static final String TAG = "FrameIdentify";
    private static long mFrameIntervalMs = 0;
    private static boolean mIsDoFrameBegin = false;
    private static boolean mIsOnVsyncCheck = false;
    private static long mLimitVsyncTime;
    private static float mRefreshRate;
    private static FrameIdentify sInstance;
    private static Object slock = new Object();
    private BaseFramePolicy mFramePolicy = null;
    private ScrollingFramePrefetcher mScrollingFramePrefetcher = null;

    private boolean boostBeginEndCheck(int i) {
        return i == 0;
    }

    public static FrameIdentify getInstance() {
        if (sInstance == null) {
            synchronized (slock) {
                if (sInstance == null) {
                    sInstance = new FrameIdentify();
                }
            }
        }
        return sInstance;
    }

    private FrameIdentify() {
        this.mFramePolicy = BOOST_FWK_VERSION > 1 ? FramePolicyV2.getInstance() : FramePolicy.getInstance();
        if (this.mScrollingFramePrefetcher == null) {
            this.mScrollingFramePrefetcher = ScrollingFramePrefetcher.getInstance();
        }
    }

    public boolean dispatchScenario(BasicScenario basicScenario) {
        if (Config.disableFrameIdentify() || basicScenario == null) {
            return false;
        }
        FrameScenario frameScenario = (FrameScenario) basicScenario;
        int scenarioAction = frameScenario.getScenarioAction();
        int boostStatus = frameScenario.getBoostStatus();
        int frameStep = frameScenario.getFrameStep();
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "Frame action dispatcher to = " + scenarioAction + " status = " + boostStatus + ", frame step = " + frameStep);
        }
        switch (scenarioAction) {
            case 0:
                doFrameCheck(boostStatus, frameScenario.getFrameId(), frameScenario);
                return true;
            case 1:
                doFrameStepCheck(boostStatus, frameStep, frameScenario);
                return true;
            case 2:
                doFrameRequestNextVsync();
                return true;
            case 3:
                updateRenderInfo(frameScenario);
                return true;
            case 4:
                doScrollingFramePrefetcher(boostStatus, frameScenario);
                return true;
            case 5:
                doScrollingFramePrefetcherPreAnim(frameScenario);
                return true;
            case 6:
                notifyFramePerformDrawFinish(frameScenario);
                return true;
            default:
                LogUtil.mLogw(TAG, "Not found dispatcher frame action.");
                return true;
        }
    }

    private void notifyFramePerformDrawFinish(FrameScenario frameScenario) {
        if (BOOST_FWK_VERSION > 2) {
            FrameDecision.getInstance().perfromDraw();
        }
    }

    private void updateRenderInfo(FrameScenario frameScenario) {
        int renderThreadTid = frameScenario.getRenderThreadTid();
        if (renderThreadTid > 0) {
            ActivityInfo.getInstance().setRenderThreadTid(renderThreadTid);
            if (BOOST_FWK_VERSION > 2) {
                checkStartFrameTracking(frameScenario.getPackageName());
            }
        }
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd(TAG, "init renderThreadTid=" + renderThreadTid);
        }
        ActivityInfo.getInstance().setThreadedRenderer(frameScenario.getThreadedRendererAndClear());
    }

    private void checkStartFrameTracking(String str) {
        FrameDecision instance = FrameDecision.getInstance();
        if (str != null && str != "" && !"android".equals(str) && Config.FRAME_TRACKING_LIST.contains(str)) {
            LogUtil.mLogd(TAG, str);
            instance.setStartFrameTracking(true);
            instance.setStartListenFrameHint(true);
        }
    }

    private void doFrameCheck(int i, long j, FrameScenario frameScenario) {
        boolean doFrameInit = doFrameInit();
        FrameDecision instance = FrameDecision.getInstance();
        int i2 = BOOST_FWK_VERSION;
        boolean z = true;
        if (i2 > 1) {
            if (!doFrameInit && !instance.isEnableFrameTracking()) {
                z = false;
            }
            frameScenario.setIsListenFrameHint(z);
            frameScenario.setFling(ScrollState.getFling());
            frameScenario.setSFPEnable(ScrollingFramePrefetcher.FEATURE_ENABLE).setPreAnimEnable(ScrollingFramePrefetcher.PRE_ANIM_ENABLE);
        }
        boolean boostBeginEndCheck = boostBeginEndCheck(i);
        mIsOnVsyncCheck = boostBeginEndCheck;
        if (i2 > 2) {
            if (!boostBeginEndCheck) {
                frameScenario.resetTraversalCallbackCount();
            }
            instance.onDoFrame(mIsOnVsyncCheck, j);
        }
        if (doFrameInit) {
            this.mFramePolicy.doFrameHint(mIsOnVsyncCheck, j);
        }
    }

    private void doFrameStepCheck(int i, int i2, FrameScenario frameScenario) {
        if (isBeginFrameAction()) {
            FrameDecision.getInstance().onDoFrameStep(boostBeginEndCheck(i), i2, frameScenario);
            this.mFramePolicy.doFrameStepHint(boostBeginEndCheck(i), i2);
        }
    }

    private void doFrameRequestNextVsync() {
        this.mFramePolicy.onRequestNextVsync();
        this.mScrollingFramePrefetcher.onRequestNextVsync();
    }

    private boolean doFrameInit() {
        float refreshRate = ScrollState.getRefreshRate();
        mRefreshRate = refreshRate;
        long j = (long) (1000.0f / refreshRate);
        mFrameIntervalMs = j;
        return this.mFramePolicy.initLimitTime((float) j);
    }

    private boolean isBeginFrameAction() {
        return mIsOnVsyncCheck;
    }

    private void doScrollingFramePrefetcher(int i, FrameScenario frameScenario) {
        boolean boostBeginEndCheck = boostBeginEndCheck(i);
        if (boostBeginEndCheck) {
            mIsDoFrameBegin = true;
            if (!mIsOnVsyncCheck && frameScenario.getFrameId() == -1) {
                frameScenario.setIsListenFrameHint(doFrameInit());
                mIsOnVsyncCheck = true;
                this.mFramePolicy.doFrameHint(true, frameScenario.getFrameId());
                if (BOOST_FWK_VERSION > 2) {
                    FrameDecision.getInstance().onDoFrame(true, frameScenario.getFrameId());
                }
            }
            this.mScrollingFramePrefetcher.doScrollingFramePrefetcher(frameScenario);
        } else if (mIsDoFrameBegin) {
            mIsDoFrameBegin = false;
            this.mScrollingFramePrefetcher.onFrameEnd(boostBeginEndCheck, frameScenario);
        }
    }

    private void doScrollingFramePrefetcherPreAnim(FrameScenario frameScenario) {
        frameScenario.setPreAnim(this.mScrollingFramePrefetcher.isPreAnimation());
    }
}
