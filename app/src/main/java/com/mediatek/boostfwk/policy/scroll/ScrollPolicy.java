package com.mediatek.boostfwk.policy.scroll;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.os.Process;
import android.view.Window;
import com.mediatek.boostfwk.identify.ime.IMEIdentify;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.TasksUtil;
import com.mediatek.powerhalmgr.PowerHalMgr;
import com.mediatek.powerhalmgr.PowerHalMgrFactory;
import com.mediatek.powerhalwrapper.PowerHalWrapper;
import com.mediatek.util.MtkPatterns;
import java.util.ArrayList;

public class ScrollPolicy {
    private static final boolean ENABLE_SCROLL_COMMON_POLICY;
    private static final int FPSGO_CONTROL = 1;
    private static final int FPSGO_GCC_DISABLE = 16;
    private static final int FPSGO_MAX_TARGET_FPS = 2;
    private static final int FPSGO_QUOTA_DISABLE = 32;
    private static final int FPSGO_RESCUE_ENABLE = 4;
    private static final int FPSGO_RL_ENABLE = 8;
    private static int MTKPOWER_HINT_UX_MOVE_SCROLLING = 45;
    private static int MTKPOWER_HINT_UX_SCROLLING = 43;
    private static int MTKPOWER_HINT_UX_SCROLLING_COMMON = 49;
    private static int NON_RENDER_THREAD_TID = -1;
    private static final int PERF_RES_FPS_FBT_RESCUE_ENABLE_PID = 33555968;
    private static final int PERF_RES_FPS_FPSGO_CTL = 33555200;
    private static final int PERF_RES_FPS_FPSGO_NOCTL = 33555456;
    private static final int PERF_RES_FPS_FPSGO_UBOOST = 33851136;
    private static final int PERF_RES_FPS_FSTB_TARGET_FPS_PID = 33554944;
    private static final int PERF_RES_POWERHAL_TOUCH_BOOST_ENABLE = 54560000;
    private static int RENDER_TID_NON_CHECK = Integer.MIN_VALUE;
    private static final String TAG = "ScrollPolicy";
    /* access modifiers changed from: private */
    public static boolean isCorrectFPS = false;
    private static Object lock = new Object();
    private static int mBoostHandle = 0;
    private static long mCheckCommonPolicyTime = 50;
    private static long mCheckFPSTime = 100;
    private static long mDelayReleaseFpsTime = ((long) Config.getFpsgoReleaseTime());
    /* access modifiers changed from: private */
    public static int mFlingPolicyExeCount = 0;
    private static int mFlutterRenderTid = Integer.MIN_VALUE;
    /* access modifiers changed from: private */
    public static int mPolicyExeCount = 0;
    private static PowerHalMgr mPowerHalService = PowerHalMgrFactory.getInstance().makePowerHalMgr();
    private static int mPowerHandle = 0;
    private static int mReleaseFPSDuration = Config.getVerticalScrollDuration();
    private static int mRenderThreadTid = Integer.MIN_VALUE;
    private static int mSpecialAppDesign = -1;
    private static int mWebviewRenderPid = Integer.MIN_VALUE;
    public static final int sFINGER_MOVE = 0;
    public static final int sFINGER_UP = 1;
    public static final int sFLING_HORIZONTAL = 3;
    public static final int sFLING_VERTICAL = 2;
    private static ScrollPolicy sInstance = null;
    private static final String sTHREAD_NAME = "ScrollPolicy";
    public static boolean useFPSGo = false;
    private final int WEBVIEW_FLUTTER_FPSGO_CTRL_MASK = 55;
    private boolean fpsgoUnderCtrlWhenFling = false;
    private ActivityInfo mActivityInfo;
    private boolean mCommonPolicyEnabled = false;
    private int mCurrentScrollStep = -1;
    /* access modifiers changed from: private */
    public boolean mDisableScrollPolicy = false;
    private IMEIdentify.IMEStateListener mIMEStateListener = new IMEIdentify.IMEStateListener() {
        public void onInit(Window window) {
        }

        public void onVisibilityChange(boolean z) {
            ScrollPolicy.this.mDisableScrollPolicy = z;
            if (z && ScrollState.isScrolling()) {
                ScrollState.setScrolling(false, "ime show");
                if (ScrollPolicy.useFPSGo) {
                    ScrollPolicy.useFPSGo = false;
                }
                if (ScrollPolicy.mPolicyExeCount > 0) {
                    ScrollPolicy.this.mWorkerHandler.sendEmptyMessage(6);
                }
                if (ScrollPolicy.mFlingPolicyExeCount > 0) {
                    ScrollPolicy.this.mWorkerHandler.sendEmptyMessage(9);
                }
            }
        }
    };
    private boolean mIsRealAOSPPage = false;
    private long mLastScrollTimeMS = -1;
    private ArrayList<Integer> mPerfLockRscList = new ArrayList<>(10);
    private PowerHalWrapper mPowerHalWrap = null;
    /* access modifiers changed from: private */
    public WorkerHandler mWorkerHandler = null;
    private HandlerThread mWorkerThread = null;
    /* access modifiers changed from: private */
    public int scrollingFingStep = -1;
    private boolean uboostEnable = false;
    /* access modifiers changed from: private */
    public boolean waitingForReleaseFpsgo = false;
    /* access modifiers changed from: private */
    public int waitingForReleaseFpsgoStep = -1;

    static {
        boolean z = true;
        if (Config.getBoostFwkVersion() <= 1 || !Config.isEnableScrollCommonPolicy()) {
            z = false;
        }
        ENABLE_SCROLL_COMMON_POLICY = z;
    }

    public static ScrollPolicy getInstance() {
        if (sInstance == null) {
            synchronized (lock) {
                if (sInstance == null) {
                    sInstance = new ScrollPolicy();
                }
            }
        }
        return sInstance;
    }

    public ScrollPolicy() {
        initThread();
        IMEIdentify.getInstance().registerIMEStateListener(this.mIMEStateListener);
        this.mActivityInfo = ActivityInfo.getInstance();
    }

    private void initThread() {
        HandlerThread handlerThread = this.mWorkerThread;
        if (handlerThread == null || !handlerThread.isAlive() || this.mWorkerHandler == null) {
            HandlerThread handlerThread2 = new HandlerThread("ScrollPolicy");
            this.mWorkerThread = handlerThread2;
            handlerThread2.start();
            Looper looper = this.mWorkerThread.getLooper();
            if (looper == null) {
                LogUtil.mLogd("ScrollPolicy", "Thread looper is null");
            } else {
                this.mWorkerHandler = new WorkerHandler(looper);
            }
        } else if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogi("ScrollPolicy", "re-init");
        }
    }

    private class WorkerHandler extends Handler {
        public static final int MSG_RELEASE_BEGIN = 1;
        public static final int MSG_RELEASE_END = 2;
        public static final int MSG_RELEASE_FPS_CHECK = 3;
        public static final int MSG_RELEASE_FPS_TIMEOUT = 4;
        public static final int MSG_SBE_DELAY_RELEASE_FPSGO = 11;
        public static final int MSG_SBE_DELAY_RELEASE_TARGET_FPS = 14;
        public static final int MSG_SBE_DISABLE_FPSGO_COUNT_DOWN = 12;
        public static final int MSG_SBE_FLING_POLICY_BEGIN = 8;
        public static final int MSG_SBE_FLING_POLICY_END = 9;
        public static final int MSG_SBE_FLING_POLICY_FLAG_END = 10;
        public static final int MSG_SBE_POLICY_BEGIN = 5;
        public static final int MSG_SBE_POLICY_END = 6;
        public static final int MSG_SBE_POLICY_FLAG_END = 7;
        public static final int MSG_SBE_SCROLL_COMMON_POLICY_COUNT_DOWN = 13;

        WorkerHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            switch (message.what) {
                case 1:
                    ScrollPolicy.this.releaseTargetFPSInternel(true);
                    return;
                case 2:
                    ScrollPolicy.this.releaseTargetFPSInternel(false);
                    return;
                case 3:
                    ScrollPolicy.isCorrectFPS = true;
                    return;
                case 4:
                    ScrollPolicy.this.releaseTargetFPSInternel(false);
                    return;
                case 5:
                    ScrollPolicy.this.mtkScrollingPolicy(true);
                    return;
                case 6:
                    ScrollPolicy.this.mtkScrollingPolicy(false);
                    return;
                case 7:
                    if (ScrollPolicy.mPolicyExeCount > 0) {
                        ScrollPolicy.mPolicyExeCount = 0;
                        ScrollPolicy.this.enableFPSGo(false, 0);
                        return;
                    }
                    return;
                case 8:
                    ScrollPolicy.this.mtkScrollingFlingPolicy(true);
                    return;
                case 9:
                    ScrollPolicy.this.mtkScrollingFlingPolicy(false);
                    return;
                case 10:
                    if (ScrollPolicy.mFlingPolicyExeCount > 0) {
                        ScrollPolicy.mFlingPolicyExeCount = 0;
                        ScrollPolicy scrollPolicy = ScrollPolicy.this;
                        scrollPolicy.enableFPSGo(false, scrollPolicy.scrollingFingStep);
                        return;
                    }
                    return;
                case 11:
                    ScrollPolicy.this.waitingForReleaseFpsgo = false;
                    ScrollPolicy scrollPolicy2 = ScrollPolicy.this;
                    scrollPolicy2.enableFPSGo(false, scrollPolicy2.waitingForReleaseFpsgoStep);
                    ScrollPolicy.this.waitingForReleaseFpsgoStep = -1;
                    return;
                case 12:
                    ScrollPolicy.useFPSGo = false;
                    ScrollPolicy scrollPolicy3 = ScrollPolicy.this;
                    scrollPolicy3.enableFPSGo(false, scrollPolicy3.scrollingFingStep);
                    return;
                case 13:
                    ScrollPolicy.this.scrollCommonPolicyCheck();
                    return;
                case 14:
                    ScrollPolicy.this.delayReleaseTargetFPSInternal();
                    return;
                default:
                    return;
            }
        }
    }

    public void scrollHint(int i, int i2) {
        if (this.mDisableScrollPolicy) {
            LogUtil.traceAndLog("ScrollPolicy", "scroll policy has been disable");
            return;
        }
        if (LogUtil.DEBUG) {
            LogUtil.traceBeginAndLog("ScrollPolicy", "scrollHint step=" + i + " pageType" + i2 + " mCurrentScrollStep" + this.mCurrentScrollStep);
        }
        this.mCurrentScrollStep = i;
        if (i == 0) {
            if (useFPSGo) {
                useFPSGo = false;
            }
            if (mSpecialAppDesign == -1) {
                mSpecialAppDesign = i2;
            }
            if (mPolicyExeCount == 0) {
                WorkerHandler workerHandler = this.mWorkerHandler;
                workerHandler.sendMessage(workerHandler.obtainMessage(5, (Object) null));
            }
        } else if (i == 1) {
            this.mWorkerHandler.removeMessages(5, (Object) null);
            WorkerHandler workerHandler2 = this.mWorkerHandler;
            workerHandler2.sendMessage(workerHandler2.obtainMessage(6, (Object) null));
        } else if (i == 2 || i == 3) {
            this.scrollingFingStep = i;
            if (mFlingPolicyExeCount == 0) {
                WorkerHandler workerHandler3 = this.mWorkerHandler;
                workerHandler3.sendMessage(workerHandler3.obtainMessage(8, (Object) null));
            }
        }
        LogUtil.traceEnd();
    }

    public void switchToFPSGo(boolean z) {
        if (this.mDisableScrollPolicy) {
            LogUtil.traceAndLog("ScrollPolicy", "switchToFPSGo scroll policy has been disable");
            return;
        }
        useFPSGo = z;
        if (LogUtil.DEBUG) {
            StringBuilder sb = new StringBuilder();
            sb.append("switchToFPSGo ");
            sb.append(z ? MtkPatterns.KEY_URLDATA_START : "stop");
            LogUtil.traceBeginAndLog("ScrollPolicy", sb.toString());
        }
        if (!this.mIsRealAOSPPage && this.mActivityInfo.isAOSPPageDesign()) {
            this.mIsRealAOSPPage = true;
        }
        if (z) {
            disableMTKScrollingPolicy(false);
        }
        LogUtil.traceEnd();
    }

    public void disableMTKScrollingPolicy(boolean z) {
        if (!z || mPolicyExeCount != 0) {
            WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessage(workerHandler.obtainMessage(9, (Object) null));
        }
    }

    /* access modifiers changed from: private */
    public void mtkScrollingPolicy(boolean z) {
        if (mPowerHalService == null) {
            LogUtil.mLogw("ScrollPolicy", "mPowerHalService is null");
            return;
        }
        if (LogUtil.DEBUG) {
            StringBuilder sb = new StringBuilder();
            sb.append("mtkScrollingPolicy ");
            sb.append(z ? MtkPatterns.KEY_URLDATA_START : "stop");
            LogUtil.traceBeginAndLog("ScrollPolicy", sb.toString());
        }
        if (!z) {
            mPolicyExeCount = 0;
            this.mWorkerHandler.removeMessages(7, (Object) null);
            powerHintUxScrollPolicy(MTKPOWER_HINT_UX_MOVE_SCROLLING, 0);
            if (!useFPSGo) {
                delayControlFpsgo(0, true);
            }
        } else if (mPolicyExeCount == 0) {
            if (this.mActivityInfo.isPage(32)) {
                mPolicyExeCount++;
                ScrollState.setScrolling(false, "PAGE_TYPE_SPECIAL_DESIGN_WEB_ON_60");
                disableTouchBoost();
                LogUtil.traceEnd();
                return;
            }
            if (mFlingPolicyExeCount != 0) {
                this.mWorkerHandler.removeMessages(10, (Object) null);
                powerHintUxScrollPolicy(MTKPOWER_HINT_UX_SCROLLING, 0);
                mFlingPolicyExeCount = 0;
            }
            if (this.mActivityInfo.isSpecialPageDesign()) {
                powerHintUxScrollPolicy(MTKPOWER_HINT_UX_MOVE_SCROLLING, Config.getVerticalScrollDuration());
            }
            enableFPSGo(true, 0);
            mPolicyExeCount++;
            disableTouchBoost();
            WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessageDelayed(workerHandler.obtainMessage(7, (Object) null), ((long) Config.getVerticalScrollDuration()) - mCheckFPSTime);
        }
        LogUtil.traceEnd();
    }

    /* access modifiers changed from: private */
    public void mtkScrollingFlingPolicy(boolean z) {
        if (mPowerHalService == null) {
            LogUtil.mLogw("ScrollPolicy", "mPowerHalService is null");
            return;
        }
        if (LogUtil.DEBUG) {
            StringBuilder sb = new StringBuilder();
            sb.append("mtkScrollingFlingPolicy ");
            sb.append(z ? MtkPatterns.KEY_URLDATA_START : "stop");
            LogUtil.traceBeginAndLog("ScrollPolicy", sb.toString());
        }
        if (!z) {
            mFlingPolicyExeCount = 0;
            this.mWorkerHandler.removeMessages(10, (Object) null);
            powerHintUxScrollPolicy(MTKPOWER_HINT_UX_SCROLLING, 0);
            if (useFPSGo) {
                enableFPSGo(true, this.scrollingFingStep);
            } else {
                delayControlFpsgo(this.scrollingFingStep, true);
            }
        } else if (mFlingPolicyExeCount == 0 && !useFPSGo) {
            this.mIsRealAOSPPage = false;
            int horizontalScrollDuration = this.scrollingFingStep == 3 ? Config.getHorizontalScrollDuration() : Config.getVerticalScrollDuration();
            powerHintUxScrollPolicy(MTKPOWER_HINT_UX_SCROLLING, horizontalScrollDuration);
            enableFPSGo(true, this.scrollingFingStep);
            mFlingPolicyExeCount++;
            this.mWorkerHandler.removeMessages(10, (Object) null);
            WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessageDelayed(workerHandler.obtainMessage(10, (Object) null), ((long) horizontalScrollDuration) - mCheckFPSTime);
        }
        LogUtil.traceEnd();
    }

    /* access modifiers changed from: private */
    public void enableFPSGo(boolean z, int i) {
        if (LogUtil.DEBUG) {
            StringBuilder sb = new StringBuilder();
            sb.append("enableFPSGo ");
            sb.append(z ? MtkPatterns.KEY_URLDATA_START : "stop");
            LogUtil.traceBeginAndLog("ScrollPolicy", sb.toString());
        }
        this.mWorkerHandler.removeMessages(12);
        if (z) {
            releaseFPSGOControl(true, i);
            if (useFPSGo) {
                WorkerHandler workerHandler = this.mWorkerHandler;
                workerHandler.sendMessageDelayed(workerHandler.obtainMessage(12, (Object) null), ((long) Config.getVerticalScrollDuration()) - mCheckFPSTime);
            }
        } else {
            releaseFPSGOControl(false, i);
        }
        LogUtil.traceEnd();
    }

    private void delayControlFpsgo(int i, boolean z) {
        if (!z) {
            this.mWorkerHandler.removeMessages(11, (Object) null);
            this.waitingForReleaseFpsgoStep = -1;
        } else if (!this.waitingForReleaseFpsgo) {
            WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessageDelayed(workerHandler.obtainMessage(11, (Object) null), mDelayReleaseFpsTime);
            this.waitingForReleaseFpsgoStep = i;
        }
        this.waitingForReleaseFpsgo = z;
    }

    private void releaseFPSGOControl(boolean z, int i) {
        releaseFPSGOControl(z, i, (int[]) null);
    }

    private void releaseFPSGOControl(boolean z, int i, int[] iArr) {
        String str;
        int renderThreadTid = getRenderThreadTid();
        boolean isDisableFrameDecision = Config.isDisableFrameDecision();
        Integer valueOf = Integer.valueOf(PERF_RES_FPS_FPSGO_NOCTL);
        Integer valueOf2 = Integer.valueOf(PERF_RES_FPS_FPSGO_CTL);
        if (z) {
            delayControlFpsgo(2, false);
            if (isDisableFrameDecision) {
                this.mPerfLockRscList.add(valueOf2);
                this.mPerfLockRscList.add(Integer.valueOf(renderThreadTid));
            }
            if (i == 2 || i == 3) {
                if (!this.fpsgoUnderCtrlWhenFling && Config.getBoostFwkVersion() <= 2) {
                    this.mPerfLockRscList.add(valueOf);
                    this.mPerfLockRscList.add(Integer.valueOf(-renderThreadTid));
                } else if (isDisableFrameDecision) {
                    this.mPerfLockRscList.set(0, 0);
                    this.mPerfLockRscList.set(1, 0);
                }
                this.fpsgoUnderCtrlWhenFling = true;
                uBoostAcquire();
            }
            this.mLastScrollTimeMS = System.currentTimeMillis();
            if (!this.mCommonPolicyEnabled) {
                enableScrollingCommonCMD(true);
            }
            str = "start " + i;
        } else {
            if (isDisableFrameDecision) {
                this.mPerfLockRscList.add(valueOf2);
                this.mPerfLockRscList.add(Integer.valueOf(-renderThreadTid));
            }
            if (i == 2 || i == 3) {
                if (Config.getBoostFwkVersion() <= 2) {
                    this.mPerfLockRscList.add(valueOf);
                    this.mPerfLockRscList.add(Integer.valueOf(renderThreadTid));
                }
                this.fpsgoUnderCtrlWhenFling = false;
                uBoostRelease();
            }
            enableScrollingCommonCMD(false);
            mSpecialAppDesign = -1;
            str = "end " + i;
        }
        fpsgoCtrlPagesIfNeed(z);
        if (iArr != null) {
            for (int valueOf3 : iArr) {
                this.mPerfLockRscList.add(Integer.valueOf(valueOf3));
            }
        }
        int size = this.mPerfLockRscList.size();
        int[] iArr2 = new int[size];
        boolean z2 = false;
        for (int i2 = 0; i2 < size; i2++) {
            int intValue = this.mPerfLockRscList.get(i2).intValue();
            iArr2[i2] = intValue;
            if (intValue != 0) {
                z2 = true;
            }
        }
        if (Config.getBoostFwkVersion() <= 2) {
            controlFpsgoInternal(iArr2, str);
        } else if (z2) {
            controlFpsgoInternal(iArr2, str);
        }
        ScrollState.setScrolling(z, str);
        this.mPerfLockRscList.clear();
    }

    private void fpsgoCtrlPagesIfNeed(boolean z) {
        if (!Config.enableScrollFloor) {
            if (this.mPowerHalWrap == null) {
                this.mPowerHalWrap = PowerHalWrapper.getInstance();
            }
            if (this.mActivityInfo.isPage(4)) {
                if (LogUtil.DEBUG) {
                    LogUtil.traceBeginAndLog("ScrollPolicy", " PAGE_TYPE_WEBVIEW for renderCrGpuMain Chrome_InProcGp" + mWebviewRenderPid + " " + z);
                }
                if (getWebViewRenderPid() > 0) {
                    this.mPowerHalWrap.mtkSetSbePolicy(TasksUtil.BLINK_WEBVIEW_RENDER_NAME, mWebviewRenderPid, 55, z);
                }
                this.mPowerHalWrap.mtkSetSbePolicy(TasksUtil.WEB_RENDER_NAME, Process.myPid(), 55, z);
                LogUtil.traceEnd();
            }
            if (this.mActivityInfo.isPage(8)) {
                if (LogUtil.DEBUG) {
                    LogUtil.traceBeginAndLog("ScrollPolicy", " PAGE_TYPE_FLUTTER " + Process.myPid() + " " + z);
                }
                int i = 0;
                while (true) {
                    String[] strArr = TasksUtil.FLUTTER_RENDER_TASK;
                    if (i < strArr.length) {
                        this.mPowerHalWrap.mtkSetSbePolicy(strArr[i], Process.myPid(), 55, z ? 1 : 0);
                        i++;
                    } else {
                        LogUtil.traceEnd();
                        return;
                    }
                }
            }
        }
    }

    private void controlFpsgoInternal(int[] iArr, String str) {
        if (LogUtil.DEBUG) {
            LogUtil.traceBeginAndLog("ScrollPolicy", str + " control Fpsgo " + commands2String(iArr));
        }
        if (this.mActivityInfo.isSpecialPageDesign() || (this.mActivityInfo.isAOSPPageDesign() && Config.isDisableFrameDecision())) {
            perfLockAcquire(iArr);
        }
        LogUtil.traceEnd();
    }

    private String commands2String(int[] iArr) {
        String str = "";
        if (!(iArr == null || iArr.length == 0 || !LogUtil.DEBUG)) {
            int length = iArr.length;
            for (int i = 0; i < length; i++) {
                switch (iArr[i]) {
                    case PERF_RES_FPS_FSTB_TARGET_FPS_PID /*33554944*/:
                        str = str + " PERF_RES_FPS_FSTB_TARGET_FPS_PID ";
                        break;
                    case PERF_RES_FPS_FPSGO_CTL /*33555200*/:
                        str = str + " PERF_RES_FPS_FPSGO_CTL ";
                        break;
                    case PERF_RES_FPS_FPSGO_NOCTL /*33555456*/:
                        str = str + " PERF_RES_FPS_FPSGO_NOCTL ";
                        break;
                    case PERF_RES_FPS_FBT_RESCUE_ENABLE_PID /*33555968*/:
                        str = str + " PERF_RES_FPS_FBT_RESCUE_ENABLE_PID ";
                        break;
                    default:
                        str = str + String.valueOf(iArr[i]) + " ";
                        break;
                }
            }
        }
        return str;
    }

    public void releaseTargetFPS(boolean z) {
        if (this.mDisableScrollPolicy) {
            LogUtil.traceAndLog("ScrollPolicy", "releaseTargetFPS scroll policy has been disable");
        } else if (getRenderThreadTid() == NON_RENDER_THREAD_TID) {
            LogUtil.mLogw("ScrollPolicy", "cannot found render thread");
        } else if (z) {
            isCorrectFPS = false;
            WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessage(workerHandler.obtainMessage(1, (Object) null));
            this.mWorkerHandler.removeMessages(4, (Object) null);
            WorkerHandler workerHandler2 = this.mWorkerHandler;
            workerHandler2.sendMessageDelayed(workerHandler2.obtainMessage(3, (Object) null), mCheckFPSTime);
        } else if (isCorrectFPS) {
            WorkerHandler workerHandler3 = this.mWorkerHandler;
            workerHandler3.sendMessage(workerHandler3.obtainMessage(2, (Object) null));
        } else {
            WorkerHandler workerHandler4 = this.mWorkerHandler;
            workerHandler4.sendMessageDelayed(workerHandler4.obtainMessage(4, (Object) null), (long) Config.getVerticalScrollDuration());
        }
    }

    /* access modifiers changed from: private */
    public void delayReleaseTargetFPSInternal() {
        if (LogUtil.DEBUG) {
            LogUtil.traceBeginAndMLogd("ScrollPolicy", "delay release Target FPS");
        }
        int renderThreadTid = getRenderThreadTid();
        int[] iArr = new int[2];
        if (Config.isDisableFrameDecision()) {
            iArr[0] = PERF_RES_FPS_FSTB_TARGET_FPS_PID;
            iArr[1] = -renderThreadTid;
        } else {
            iArr[1] = 0;
            iArr[0] = 0;
        }
        releaseFPSGOControl(false, 2, iArr);
        LogUtil.traceEnd();
    }

    /* access modifiers changed from: private */
    public void releaseTargetFPSInternel(boolean z) {
        int renderThreadTid = getRenderThreadTid();
        int[] iArr = new int[2];
        if (Config.isDisableFrameDecision()) {
            iArr[0] = PERF_RES_FPS_FSTB_TARGET_FPS_PID;
            if (!z) {
                renderThreadTid = -renderThreadTid;
            }
            iArr[1] = renderThreadTid;
        } else {
            iArr[1] = 0;
            iArr[0] = 0;
        }
        if (LogUtil.DEBUG) {
            StringBuilder sb = new StringBuilder();
            sb.append("release Target FPS");
            sb.append(z ? MtkPatterns.KEY_URLDATA_START : "stop");
            LogUtil.traceBeginAndLog("ScrollPolicy", sb.toString());
        }
        this.mWorkerHandler.removeMessages(14);
        if (!Config.dealyReleaseFPSGO || z || this.mCurrentScrollStep != 0) {
            releaseFPSGOControl(z, 2, iArr);
        } else {
            this.mWorkerHandler.sendEmptyMessageDelayed(14, mDelayReleaseFpsTime);
            enableScrollingCommonCMD(false);
        }
        LogUtil.traceEnd();
    }

    /* access modifiers changed from: private */
    public void scrollCommonPolicyCheck() {
        if (this.mLastScrollTimeMS > 0 && ((long) Config.getVerticalScrollDuration()) > System.currentTimeMillis() - this.mLastScrollTimeMS) {
            enableScrollingCommonCMD(true);
        } else if (this.mCommonPolicyEnabled) {
            enableScrollingCommonCMD(false);
        }
    }

    private int getRenderThreadTid() {
        if (mRenderThreadTid == RENDER_TID_NON_CHECK) {
            mRenderThreadTid = this.mActivityInfo.getRenderThreadTid();
        }
        return mRenderThreadTid;
    }

    private int getWebViewRenderPid() {
        if (mWebviewRenderPid == RENDER_TID_NON_CHECK) {
            int webViewRenderPid = this.mActivityInfo.getWebViewRenderPid();
            if (webViewRenderPid <= 0) {
                webViewRenderPid = NON_RENDER_THREAD_TID;
            }
            mWebviewRenderPid = webViewRenderPid;
        }
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd("ScrollPolicy", "getWebViewRenderTid webviewPid= " + mWebviewRenderPid);
        }
        return mWebviewRenderPid;
    }

    private int getFlutterRenderTid() {
        if (mFlutterRenderTid == RENDER_TID_NON_CHECK) {
            int flutterRenderTid = this.mActivityInfo.getFlutterRenderTid();
            if (flutterRenderTid <= 0) {
                flutterRenderTid = NON_RENDER_THREAD_TID;
            }
            mFlutterRenderTid = flutterRenderTid;
        }
        if (LogUtil.DEBUG) {
            LogUtil.mLogd("ScrollPolicy", "mFlutterRenderTid= " + mFlutterRenderTid);
        }
        return mFlutterRenderTid;
    }

    private void perfLockAcquire(int[] iArr) {
        PowerHalMgr powerHalMgr = mPowerHalService;
        if (powerHalMgr != null) {
            int perfLockAcquire = powerHalMgr.perfLockAcquire(mPowerHandle, Config.getVerticalScrollDuration(), iArr);
            mPowerHandle = perfLockAcquire;
            mPowerHalService.perfLockRelease(perfLockAcquire);
        }
    }

    private void powerHintUxScrollPolicy(int i, int i2) {
        if (Config.enableScrollFloor) {
            mPowerHalService.mtkPowerHint(i, i2);
        }
    }

    private void uBoostAcquire() {
        PowerHalMgr powerHalMgr;
        if (Config.getBoostFwkVersion() == 1 && (powerHalMgr = mPowerHalService) != null && !this.uboostEnable) {
            this.uboostEnable = true;
            mBoostHandle = powerHalMgr.perfLockAcquire(mBoostHandle, Config.getVerticalScrollDuration(), new int[]{PERF_RES_FPS_FPSGO_UBOOST, 1});
        }
    }

    private void uBoostRelease() {
        PowerHalMgr powerHalMgr;
        if (Config.getBoostFwkVersion() == 1 && (powerHalMgr = mPowerHalService) != null && this.uboostEnable) {
            this.uboostEnable = false;
            powerHalMgr.perfLockRelease(mBoostHandle);
        }
    }

    private void disableTouchBoost() {
        perfLockAcquire(new int[]{PERF_RES_POWERHAL_TOUCH_BOOST_ENABLE, 0});
    }

    private void enableScrollingCommonCMD(boolean z) {
        if (ENABLE_SCROLL_COMMON_POLICY) {
            this.mCommonPolicyEnabled = z;
            this.mWorkerHandler.removeMessages(13);
            if (z) {
                LogUtil.traceAndMLogd("ScrollPolicy", "Enable MTKPOWER_HINT_UX_SCROLLING_COMMON");
                mPowerHalService.mtkPowerHint(MTKPOWER_HINT_UX_SCROLLING_COMMON, Config.getVerticalScrollDuration());
                if (this.mActivityInfo.isSpecialPageDesign() || !this.mIsRealAOSPPage || Config.checkCommonPolicyForALL) {
                    this.mWorkerHandler.sendEmptyMessageDelayed(13, ((long) Config.getVerticalScrollDuration()) + mCheckCommonPolicyTime);
                    return;
                }
                return;
            }
            LogUtil.traceAndMLogd("ScrollPolicy", "Disable MTKPOWER_HINT_UX_SCROLLING_COMMON");
            mPowerHalService.mtkPowerHint(MTKPOWER_HINT_UX_SCROLLING_COMMON, 0);
        }
    }
}
