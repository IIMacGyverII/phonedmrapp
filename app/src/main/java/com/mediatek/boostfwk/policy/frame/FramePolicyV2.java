package com.mediatek.boostfwk.policy.frame;

import android.content.Context;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.view.DisplayEventReceiver;
import android.view.ThreadedRenderer;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.policy.frame.BaseFramePolicy;
import com.mediatek.boostfwk.policy.scroll.ScrollPolicy;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.Util;
import com.mediatek.powerhalmgr.PowerHalMgr;

public class FramePolicyV2 extends BaseFramePolicy implements ScrollState.RefreshRateChangedListener {
    private static final double CHECK_POINT = 0.5d;
    private static final long CHECK_TIME_OFFSET_THRESHOLD_NS = 500000;
    private static final long DEFAULT_FRAME_ID = -2147483648L;
    private static final long DEFAULT_FRAME_TIME = -1;
    private static final boolean ENBALE_FRAME_RESCUE = Config.isEnableFrameRescue();
    private static final int FRAME_STEP_BASIC = -1;
    private static final int FRAME_STEP_DEFAULT = -1;
    private static final int FRAME_STEP_DO_FRAME_ANIMATION = 3;
    private static final int FRAME_STEP_DO_FRAME_INPUT = 2;
    private static final int FRAME_STEP_DO_FRAME_TRAVERSAL = 4;
    private static final int FRAME_STEP_VSYNC_FOR_APP_TO_INPUT = 1;
    private static final int FRAME_STEP_VSYNC_FOR_SBE_TO_APP_VSYNC = 0;
    private static final Object LOCK = new Object();
    private static final int MAX_WAITING_FRAME_COUNT = 5;
    public static final int MSG_DELAY_STOP_HWUI_HINT = 9;
    public static final int MSG_FRAME_BEGIN = 1;
    public static final int MSG_FRAME_END = 2;
    public static final int MSG_NO_DRAW = 4;
    public static final int MSG_REQUEST_VSYNC = 8;
    public static final int MSG_RESCUE_HALF_VSYNC_CHECK = 3;
    public static final int MSG_RESCUE_TIME_OUT = 6;
    public static final int MSG_RESUCE_ONE_VSYNC_CHECK = 5;
    public static final int MSG_UPDATE_RESCUE_FRAME_ID = 7;
    private static final long NANOS_PER_MS = 1000000;
    private static final int NON_RENDER_THREAD_TID = -1;
    private static final double NO_DRAW_FRAME_VSYNC_RATIO = 0.1d;
    private static final int PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE = 33802752;
    private static final int PERF_RES_FPS_FPSGO_STOP_BOOST = 33571328;
    private static final int PERF_RES_UX_SBE_RESCUE_ENHANS = 50348800;
    private static final long PREFETCHER_FRAME_ID = -1;
    private static final int RESCUE_COUNT_DOWN_THRESHOLD = 1;
    private static final boolean RESCUE_TO_NEXT_FRAME = true;
    private static long mDelayStopHWUIHintTime = 0;
    private static float mFrameIntervalTime = 0.0f;
    private static int mFrameStep = -1;
    /* access modifiers changed from: private */
    public static FramePolicyV2 mInstance = null;
    private static boolean mIsAnimationStepEnd = false;
    private static boolean mIsScrolling = false;
    private static boolean mIsTraversalStepEnd = false;
    private static float mLimitVsyncTime = 0.0f;
    private final int SBE_RESUCE_MODE_END = 0;
    private final int SBE_RESUCE_MODE_START = 1;
    private final int SBE_RESUCE_MODE_TO_QUEUE_END = 2;
    private long mCurFrameId = DEFAULT_FRAME_ID;
    private int mCurFrameRescueMode = 1;
    private long mCurFrameStartTimeNanos = -1;
    private DisplayEventReceiver mDisplayEventReceiver = null;
    private int mFrameHintMask = 3;
    private boolean mHasNextFrame = false;
    private long mLastFrameEndFrameId = DEFAULT_FRAME_ID;
    private int mRenderThreadTid = -1;
    private boolean mRescueDoFrame = false;
    private boolean mRescueNextFrame = false;
    private int mRescueStrength = 50;
    private int mRescueStrengthWhenHint = -1;
    private boolean mRescueWhenWaitNextVsync = false;
    private long mRescuingFrameId = DEFAULT_FRAME_ID;
    private ScrollingFramePrefetcher mScrollingFramePrefetcher = null;
    private int mUnlockPowerHandle = 0;
    private boolean mUpdateStrength = false;
    private long mVsyncFrameId = DEFAULT_FRAME_ID;
    private long mVsyncTimeNanos = -1;
    private volatile boolean mWaitNextVsync = false;

    private float adjustCheckTime(float f, float f2) {
        float f3 = ((f * 1000000.0f) - f2) / 1000000.0f;
        if (f3 > 0.0f) {
            return f3;
        }
        return 0.0f;
    }

    private int mappingStepForDoFrame(int i) {
        if (i == 0) {
            return 2;
        }
        if (i != 1) {
            return i != 3 ? -1 : 4;
        }
        return 3;
    }

    /* access modifiers changed from: protected */
    public void handleMessageInternal(Message message) {
        switch (message.what) {
            case 2:
                onDoFrameEndInternal(this.mLastFrameEndFrameId);
                return;
            case 3:
                halfVsyncRescueCheck();
                return;
            case 5:
                oneVsyncRescueCheck();
                return;
            case 6:
                shutdownSBERescue("time out");
                return;
            case 7:
                updateRescueFrameId();
                return;
            case 8:
                requestVsyncInternal();
                return;
            case 9:
                dleayStopHwuiHint();
                return;
            default:
                return;
        }
    }

    public static FramePolicyV2 getInstance() {
        if (mInstance == null) {
            synchronized (LOCK) {
                if (mInstance == null) {
                    mInstance = new FramePolicyV2();
                }
            }
        }
        return mInstance;
    }

    private FramePolicyV2() {
        if (Config.getBoostFwkVersion() <= 2) {
            this.mFrameHintMask = 1;
        }
    }

    /* access modifiers changed from: protected */
    public void initCoreServiceInternal() {
        ActivityInfo.getInstance().getPackageName();
        this.mDisplayEventReceiver = new DisplayEventReceiverImpl(this.mWorkerHandler.getLooper(), 0);
        super.initCoreServiceInternal();
    }

    public boolean initLimitTime(float f) {
        if (f > 0.0f && f != mFrameIntervalTime) {
            mFrameIntervalTime = f;
            mLimitVsyncTime = (float) ((((double) f) * 0.5d) - 0.5d);
            mDelayStopHWUIHintTime = (long) (f * 5.0f);
            initialRescueStrengthOnce(ScrollState.getRefreshRate());
        }
        return ENBALE_FRAME_RESCUE && BaseFramePolicy.mListenFrameHint && mFrameIntervalTime != 0.0f;
    }

    public void doFrameHint(boolean z, long j) {
        if (this.mCoreServiceReady) {
            if (LogUtil.DEBUG) {
                LogUtil.mLogd("FramePolicy", "vsync is begin = " + z + " frame=" + j);
            }
            if (z) {
                onDoFrameBegin(j);
            } else {
                onDoFrameEnd();
            }
        }
    }

    private void onDoFrameBegin(long j) {
        if (LogUtil.DEBUG) {
            LogUtil.traceBegin("onDoFrameBegin=" + j);
        }
        updateBasicFrameInfo(j, SystemClock.uptimeNanos());
        setFrameStep(1);
        this.mRescuingFrameId = DEFAULT_FRAME_ID;
        this.mRescueDoFrame = false;
        if (this.mRescueWhenWaitNextVsync || (this.mRescueNextFrame && !BaseFramePolicy.mDisableFrameRescue)) {
            BaseFramePolicy.WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessageAtFrontOfQueue(workerHandler.obtainMessage(7));
        }
        LogUtil.traceEnd();
    }

    private void onDoFrameEnd() {
        if (LogUtil.DEBUG) {
            LogUtil.traceBegin("onDoFrameEnd=" + this.mCurFrameId);
        }
        mFrameStep = -1;
        this.mLastFrameEndFrameId = this.mCurFrameId;
        updateBasicFrameInfo(DEFAULT_FRAME_ID, -1);
        this.mWorkerHandler.removeMessages(3);
        this.mWorkerHandler.removeMessages(5);
        BaseFramePolicy.WorkerHandler workerHandler = this.mWorkerHandler;
        workerHandler.sendMessageAtFrontOfQueue(workerHandler.obtainMessage(2));
        this.mWaitNextVsync = false;
        if (this.mHasNextFrame && !BaseFramePolicy.mDisableFrameRescue) {
            requestVsync();
            BaseFramePolicy.mListenFrameHint = true;
        }
        this.mHasNextFrame = false;
        if (BaseFramePolicy.mDisableFrameRescue) {
            BaseFramePolicy.mListenFrameHint = false;
            this.mWorkerHandler.sendEmptyMessageDelayed(9, mDelayStopHWUIHintTime);
        }
        LogUtil.traceEnd();
    }

    private void dleayStopHwuiHint() {
        if (getThreadedRenderer() != null) {
            ThreadedRenderer.needFrameCompleteHint(ActivityInfo.updateSBEMask(this.mFrameHintMask, false));
        }
    }

    private void updateBasicFrameInfo(long j, long j2) {
        this.mCurFrameId = j;
        this.mCurFrameStartTimeNanos = j2;
    }

    public void doFrameStepHint(boolean z, int i) {
        if (this.mCoreServiceReady) {
            if (z) {
                setFrameStep(mappingStepForDoFrame(i));
            } else if (i == 1) {
                mIsAnimationStepEnd = true;
            } else if (i == 3) {
                mIsTraversalStepEnd = true;
            }
        }
    }

    private void setFrameStep(int i) {
        if (i > mFrameStep) {
            mFrameStep = i;
            if (LogUtil.DEBUG) {
                LogUtil.trace("new step=" + i + " frameId=" + this.mCurFrameId);
            }
        }
    }

    public void onRequestNextVsync() {
        if (BaseFramePolicy.mListenFrameHint && this.mCoreServiceReady) {
            if (this.mScrollingFramePrefetcher == null) {
                this.mScrollingFramePrefetcher = ScrollingFramePrefetcher.getInstance();
            }
            if (mFrameStep >= 1 || this.mScrollingFramePrefetcher.isPreAnimationRunning()) {
                this.mHasNextFrame = true;
            } else {
                requestVsync();
            }
        }
    }

    public void requestVsync() {
        if (this.mCoreServiceReady) {
            this.mWorkerHandler.removeMessages(8);
            this.mWorkerHandler.sendEmptyMessage(8);
        }
    }

    public void onScrollStateChange(boolean z) {
        super.onScrollStateChange(z);
        ThreadedRenderer threadedRenderer = mInstance.getThreadedRenderer();
        if (LogUtil.DEBUG) {
            LogUtil.mLogd("FramePolicy", "onScrollStateChange scroll=" + z + " " + threadedRenderer);
        }
        if (BaseFramePolicy.mListenFrameHint) {
            this.mWorkerHandler.removeMessages(9);
            if (threadedRenderer != null) {
                ThreadedRenderer.needFrameCompleteHint(ActivityInfo.updateSBEMask(this.mFrameHintMask, true));
            }
        }
    }

    private void onDoFrameEndInternal(long j) {
        if (LogUtil.DEBUG) {
            LogUtil.traceBegin("onDoFrameEndInternal frameId= " + j);
        }
        mIsAnimationStepEnd = false;
        if (!mIsTraversalStepEnd && (this.mRescueDoFrame || this.mRescueWhenWaitNextVsync)) {
            shutdownSBERescue("frame end-no draw");
        }
        this.mRescueWhenWaitNextVsync = false;
        mIsTraversalStepEnd = false;
        LogUtil.traceEnd();
    }

    private void requestVsyncInternal() {
        if (LogUtil.DEBUG) {
            LogUtil.traceBegin("requestVsyncInternal frameId= " + this.mCurFrameId);
        }
        DisplayEventReceiver displayEventReceiver = this.mDisplayEventReceiver;
        if (displayEventReceiver != null) {
            displayEventReceiver.scheduleVsync();
            this.mWaitNextVsync = true;
        }
        LogUtil.traceEnd();
    }

    /* access modifiers changed from: private */
    public void onVsyncInternal(long j) {
        if (this.mWaitNextVsync) {
            if (LogUtil.DEBUG) {
                LogUtil.traceBegin("onVsyncInternal frameId= " + j + " " + mFrameStep);
            }
            this.mVsyncFrameId = j;
            this.mVsyncTimeNanos = SystemClock.uptimeNanos();
            if (mFrameStep != 0) {
                setFrameStep(0);
                rescueCheck();
            }
            this.mWaitNextVsync = false;
            LogUtil.traceEnd();
        } else if (LogUtil.DEBUG) {
            LogUtil.trace("this vsync is later than doframe, the doframe is end");
        }
    }

    private void rescueCheck() {
        if (LogUtil.DEBUG) {
            LogUtil.traceBegin("rescueCheck frameId= " + this.mVsyncFrameId + " vsyncTime=" + this.mVsyncTimeNanos + " frameStartTime=" + this.mCurFrameStartTimeNanos);
        }
        long j = this.mVsyncTimeNanos;
        long j2 = this.mCurFrameStartTimeNanos;
        float f = mLimitVsyncTime;
        float f2 = mFrameIntervalTime;
        if (j2 > 0) {
            long j3 = j - j2;
            if (j3 > CHECK_TIME_OFFSET_THRESHOLD_NS) {
                float f3 = (float) j3;
                f = adjustCheckTime(f, f3);
                f2 = adjustCheckTime(f2, f3);
            }
        }
        if (this.mWaitNextVsync) {
            BaseFramePolicy.WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessageDelayed(workerHandler.obtainMessage(3), (long) f);
            BaseFramePolicy.WorkerHandler workerHandler2 = this.mWorkerHandler;
            workerHandler2.sendMessageDelayed(workerHandler2.obtainMessage(5), (long) f2);
        }
        this.mWorkerHandler.removeMessages(6);
        LogUtil.traceEnd();
    }

    private void halfVsyncRescueCheck() {
        if (LogUtil.DEBUG) {
            LogUtil.traceBeginAndLog("FramePolicy", "halfVsyncRescueCheck=" + mFrameStep + " frame=" + this.mCurFrameId);
        }
        int i = mFrameStep;
        if (i == 0) {
            this.mRescueWhenWaitNextVsync = true;
            this.mRescueStrengthWhenHint = this.mRescueStrength + 10;
            doSBERescue("waiting vsync");
            this.mRescueStrengthWhenHint = -1;
        } else if ((i == 1 || i == 2 || i == 3) && !mIsAnimationStepEnd) {
            this.mRescueDoFrame = true;
            doSBERescue("animation end");
        }
        LogUtil.traceEnd();
    }

    private void oneVsyncRescueCheck() {
        int i;
        boolean z = this.mRescueDoFrame;
        if (!z && mFrameStep == 4 && !mIsTraversalStepEnd) {
            this.mRescueDoFrame = true;
            doSBERescue("traversal over vsync");
            this.mRescueNextFrame = true;
        } else if (z && (i = mFrameStep) <= 4 && i > -1) {
            this.mRescueNextFrame = true;
        }
        LogUtil.mLogd("FramePolicy", "oneVsyncRescueCheck mFrameStep=" + mFrameStep + " mRescueNextFrame=" + this.mRescueNextFrame + " mRescueDoFrame=" + this.mRescueDoFrame + " frameId=" + this.mCurFrameId);
    }

    private void updateRescueFrameId() {
        if (this.mRescueWhenWaitNextVsync) {
            this.mRescueWhenWaitNextVsync = false;
            doSBERescue("update frame id");
            this.mRescueDoFrame = true;
        } else if (this.mRescueNextFrame) {
            this.mRescueNextFrame = false;
            doSBERescue("update frame id");
            this.mRescueDoFrame = true;
        }
    }

    private void frameDraw(boolean z) {
        if (z) {
            this.mWorkerHandler.removeMessages(4, (Object) null);
            this.mWorkerHandler.sendEmptyMessageDelayed(4, (long) drawFrameDelayTime());
            return;
        }
        powerHintForRender(PERF_RES_FPS_FPSGO_STOP_BOOST, "STOP: No draw");
    }

    private void doSBERescue(String str) {
        long j = this.mCurFrameId;
        if (j != DEFAULT_FRAME_ID || mFrameStep == 0) {
            this.mRescuingFrameId = j;
            if (this.mUpdateStrength) {
                this.mUpdateStrength = false;
                powerHintForRender(PERF_RES_UX_SBE_RESCUE_ENHANS, "change to " + this.mRescueStrength);
            }
            this.mCurFrameRescueMode = 1;
            powerHintForRender(PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE, str + " curStep=" + mFrameStep + " mode=" + this.mCurFrameRescueMode);
            this.mWorkerHandler.sendEmptyMessageDelayed(6, (long) drawFrameDelayTime());
            return;
        }
        LogUtil.traceAndLog("FramePolicy", "do not rescue beacause frameID=DEFAULT_FRAME_ID");
    }

    private void shutdownSBERescue(String str) {
        this.mCurFrameRescueMode = 0;
        powerHintForRender(PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE, "shutdown " + str + " curStep=" + mFrameStep + " mode=" + this.mCurFrameRescueMode);
        clearRescueInfo();
    }

    private void clearRescueInfo() {
        this.mRescuingFrameId = DEFAULT_FRAME_ID;
        this.mRescueWhenWaitNextVsync = false;
        this.mRescueDoFrame = false;
        this.mRescueNextFrame = false;
        this.mWorkerHandler.removeMessages(6);
    }

    private void initialRescueStrengthOnce(float f) {
        int i = this.mRescueStrength;
        int i2 = 50;
        if (f > 65.0f && f >= 95.0f) {
            i2 = i;
        }
        if (i2 != i) {
            this.mRescueStrength = i2;
            this.mUpdateStrength = true;
        }
    }

    public void onDisplayRefreshRateChanged(int i, float f, float f2) {
        initialRescueStrengthOnce(f);
    }

    private void powerHintForRender(int i, String str) {
        int renderThreadTid = getRenderThreadTid();
        if (renderThreadTid == Integer.MIN_VALUE) {
            clearRescueInfo();
            if (LogUtil.DEBUG) {
                LogUtil.traceAndLog("FramePolicy", this.mCurFrameId + "cancel rescue: " + renderThreadTid);
                return;
            }
            return;
        }
        boolean z = LogUtil.DEBUG;
        if (z) {
            LogUtil.traceBeginAndMLogd("FramePolicy", "hint for [" + str + "] renderId=" + renderThreadTid + " frameId=" + this.mRescuingFrameId + " strength=" + this.mRescueStrengthWhenHint);
        }
        if (i == PERF_RES_FPS_FPSGO_STOP_BOOST) {
            perfLockAcquire(new int[]{i, renderThreadTid});
            ScrollPolicy.getInstance().disableMTKScrollingPolicy(true);
        } else if (i == PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE) {
            long j = this.mRescuingFrameId;
            if (j == DEFAULT_FRAME_ID || j != -1 || this.mCurFrameId == -1 || j > this.mLastFrameEndFrameId || this.mCurFrameRescueMode != 1) {
                this.mPowerHalWrap.mtkNotifySbeRescue(renderThreadTid, this.mCurFrameRescueMode, Config.getBoostFwkVersion() > 2 ? this.mRescueStrengthWhenHint : 50, j);
            } else {
                clearRescueInfo();
                if (z) {
                    LogUtil.trace("do not rescue frameEndFrameId=" + this.mLastFrameEndFrameId);
                }
            }
        } else if (i == PERF_RES_UX_SBE_RESCUE_ENHANS) {
            perfLockAcquireUnlock(new int[]{PERF_RES_UX_SBE_RESCUE_ENHANS, this.mRescueStrength});
        } else if (z) {
            LogUtil.mLogd("FramePolicy", "not surpport for cmd = " + i);
        }
        LogUtil.traceEnd();
    }

    private double drawFrameDelayTime() {
        if (mFrameIntervalTime == 0.0f) {
            return -1.0d;
        }
        return ((double) mFrameIntervalTime) * ((double) Util.getRefreshRate()) * NO_DRAW_FRAME_VSYNC_RATIO;
    }

    private int getRenderThreadTid() {
        if (this.mRenderThreadTid == -1) {
            this.mRenderThreadTid = ActivityInfo.getInstance().getRenderThreadTid();
        }
        return this.mRenderThreadTid;
    }

    private void perfLockAcquire(int[] iArr) {
        PowerHalMgr powerHalMgr = this.mPowerHalService;
        if (powerHalMgr != null) {
            int perfLockAcquire = powerHalMgr.perfLockAcquire(this.mPowerHandle, 0, iArr);
            this.mPowerHandle = perfLockAcquire;
            this.mPowerHalService.perfLockRelease(perfLockAcquire);
        }
    }

    private void perfLockAcquireUnlock(int[] iArr) {
        PowerHalMgr powerHalMgr = this.mPowerHalService;
        if (powerHalMgr != null) {
            this.mUnlockPowerHandle = powerHalMgr.perfLockAcquire(this.mUnlockPowerHandle, 0, iArr);
        }
    }

    private static class DisplayEventReceiverImpl extends DisplayEventReceiver {
        public DisplayEventReceiverImpl(Looper looper, int i) {
            super(looper, i, 0);
        }

        public void onVsync(long j, long j2, int i, DisplayEventReceiver.VsyncEventData vsyncEventData) {
            if (FramePolicyV2.mInstance != null) {
                FramePolicyV2.mInstance.onVsyncInternal(vsyncEventData.preferredFrameTimeline().vsyncId);
            }
        }
    }

    public void onAllActivityPaused(Context context) {
        PowerHalMgr powerHalMgr = this.mPowerHalService;
        if (powerHalMgr != null) {
            powerHalMgr.perfLockRelease(this.mUnlockPowerHandle);
        }
    }
}
