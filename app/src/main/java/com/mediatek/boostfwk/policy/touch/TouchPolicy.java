package com.mediatek.boostfwk.policy.touch;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.os.Process;
import android.view.MotionEvent;
import com.mediatek.boostfwk.identify.scroll.ScrollIdentify;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.Util;
import com.mediatek.powerhalmgr.PowerHalMgr;
import com.mediatek.powerhalmgr.PowerHalMgrFactory;
import java.util.HashMap;
import java.util.Map;

public class TouchPolicy implements ScrollIdentify.TouchEventListener, ScrollState.ScrollStateListener, ActivityInfo.ActivityChangeListener {
    private static final boolean ENABLE_TOUCH_POLICY_FOR_ALL = false;
    private static final Object LOCK = new Object();
    public static final Map<String, Long> LONG_TIME_PAGES = new HashMap<String, Long>() {
        {
            put("NebulaActivity", 999999L);
        }
    };
    private static final int PERF_RES_SCHED_SBB_ACTIVE_RATIO = 21251584;
    private static final int PERF_RES_SCHED_SBB_GROUP_SET = 21250560;
    private static final int PERF_RES_SCHED_SBB_GROUP_UNSET = 21250816;
    private static final int PERF_RES_SCHED_UCLAMP_MIN_TA = 21005056;
    private static final String TAG = "TouchPolicy";
    private static final String THREAD_NAME = "TouchPolicy";
    private static TouchPolicy mInstance = null;
    private static final int sDEFAULT_ACTIVE_RATIO = 70;
    private static final int sDEFAULT_UCLAMP_TA = 25;
    private ActivityInfo mActivityInfo = null;
    private String mActivityStr = "";
    private boolean mIsLongTimePages = false;
    private boolean mIsSBBTrigger = false;
    private long mLastTouchDownTime = -1;
    private long mLastTriggerTime = -1;
    private int mPid = Integer.MIN_VALUE;
    private PowerHalMgr mPowerHalService = PowerHalMgrFactory.getInstance().makePowerHalMgr();
    private int mPowerHandle = 0;
    private int mReleaseDuration = -1;
    private final long mResetBufferTimeMS = 100;
    private WorkerHandler mWorkerHandler = null;
    private HandlerThread mWorkerThread = null;

    public static TouchPolicy getInstance() {
        if (mInstance == null) {
            synchronized (LOCK) {
                if (mInstance == null) {
                    mInstance = new TouchPolicy();
                }
            }
        }
        return mInstance;
    }

    private TouchPolicy() {
        initThread();
        ScrollIdentify.getInstance().registerTouchEventListener(this);
        ScrollState.registerScrollStateListener(this);
    }

    private void initThread() {
        HandlerThread handlerThread = this.mWorkerThread;
        if (handlerThread == null || !handlerThread.isAlive() || this.mWorkerHandler == null) {
            HandlerThread handlerThread2 = new HandlerThread("TouchPolicy");
            this.mWorkerThread = handlerThread2;
            handlerThread2.start();
            Looper looper = this.mWorkerThread.getLooper();
            if (looper == null) {
                LogUtil.mLogd("TouchPolicy", "Thread looper is null");
            } else {
                this.mWorkerHandler = new WorkerHandler(looper);
            }
        } else if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogi("TouchPolicy", "re-init");
        }
    }

    private class WorkerHandler extends Handler {
        public static final int MSG_ENABLE_SBB = 1;
        public static final int MSG_RESET_SBB = 2;

        WorkerHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            int i = message.what;
            boolean z = true;
            if (i == 1) {
                TouchPolicy.this.enableSBBInternal(-1);
            } else if (i == 2) {
                TouchPolicy touchPolicy = TouchPolicy.this;
                if (message.obj == null) {
                    z = false;
                }
                touchPolicy.resetSBBInternal(z);
            }
        }
    }

    public void onTouchEvent(MotionEvent motionEvent) {
        if (Config.isEnableTouchPolicy() && Config.getBoostFwkVersion() > 1 && ScrollState.getRefreshRate() > 61.0f && motionEvent.getAction() == 0 && Util.isMainThread()) {
            if (this.mActivityInfo == null) {
                ActivityInfo instance = ActivityInfo.getInstance();
                this.mActivityInfo = instance;
                instance.registerActivityListener(this);
            }
            this.mActivityInfo.getPageType();
            this.mActivityInfo.isPage(128);
            if (this.mActivityInfo.isSpecialPageDesign() && !this.mIsLongTimePages) {
                long currentTimeMillis = System.currentTimeMillis() - this.mLastTriggerTime;
                this.mLastTouchDownTime = System.currentTimeMillis();
                if (currentTimeMillis >= ((long) this.mReleaseDuration)) {
                    enableSBB();
                } else if (LogUtil.DEBUG) {
                    LogUtil.traceAndMLogd("TouchPolicy", "onTouchEvent for return" + currentTimeMillis);
                }
            }
        }
    }

    private void enableSBB() {
        if (this.mPid == Integer.MIN_VALUE) {
            this.mPid = Process.myPid();
        }
        this.mLastTriggerTime = System.currentTimeMillis();
        this.mWorkerHandler.removeMessages(1, (Object) null);
        this.mWorkerHandler.sendEmptyMessage(1);
    }

    /* access modifiers changed from: private */
    public void enableSBBInternal(int i) {
        if (this.mReleaseDuration < 0) {
            this.mReleaseDuration = (int) generateNewDuration();
        }
        if (i <= 0) {
            i = this.mReleaseDuration;
        }
        this.mIsSBBTrigger = true;
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd("TouchPolicy", "enableSBB for " + this.mActivityStr + " with duration=" + this.mReleaseDuration + " pid=" + this.mPid);
        }
        acquirePowerhal(this.mIsLongTimePages ? new int[]{PERF_RES_SCHED_SBB_GROUP_SET, this.mPid, PERF_RES_SCHED_SBB_ACTIVE_RATIO, 70, PERF_RES_SCHED_UCLAMP_MIN_TA, 25} : new int[]{PERF_RES_SCHED_SBB_GROUP_SET, this.mPid, PERF_RES_SCHED_SBB_ACTIVE_RATIO, 70}, i);
        this.mWorkerHandler.removeMessages(2, (Object) null);
        WorkerHandler workerHandler = this.mWorkerHandler;
        workerHandler.sendMessageDelayed(workerHandler.obtainMessage(2, Boolean.TRUE), (long) i);
    }

    private long generateNewDuration() {
        long touchDuration = (long) Config.getTouchDuration();
        for (String next : LONG_TIME_PAGES.keySet()) {
            if (this.mActivityStr.contains(next)) {
                long longValue = LONG_TIME_PAGES.get(next).longValue();
                this.mIsLongTimePages = true;
                return longValue;
            }
        }
        return touchDuration;
    }

    /* access modifiers changed from: private */
    public void resetSBBInternal(boolean z) {
        long j = 0;
        if (z) {
            if (!this.mIsLongTimePages) {
                if (this.mLastTouchDownTime > 0) {
                    long currentTimeMillis = System.currentTimeMillis() - this.mLastTouchDownTime;
                    if (currentTimeMillis < ((long) this.mReleaseDuration) - 100) {
                        j = currentTimeMillis;
                    }
                }
            }
            LogUtil.traceAndMLogd("TouchPolicy", "continueSBB");
            this.mLastTriggerTime = System.currentTimeMillis();
            enableSBBInternal((int) (((long) this.mReleaseDuration) - j));
            return;
        }
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd("TouchPolicy", "resetSBB for " + this.mActivityStr);
        }
        releasePowerHandle();
        this.mLastTriggerTime = 0;
        this.mIsSBBTrigger = false;
        this.mIsLongTimePages = false;
    }

    public void onScroll(boolean z) {
        if (z && !this.mIsLongTimePages) {
            if (LogUtil.DEBUG) {
                LogUtil.traceAndMLogd("TouchPolicy", "onScroll for " + this.mActivityStr + " with scrolling=" + z);
            }
            resetSBB();
        }
    }

    private void resetSBB() {
        if (this.mIsSBBTrigger) {
            this.mWorkerHandler.removeMessages(2, (Object) null);
            WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessageAtFrontOfQueue(workerHandler.obtainMessage(2));
        }
    }

    public void onChange(Context context) {
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd("TouchPolicy", "onChange for " + context + " " + this.mActivityStr);
        }
        if (context != null && !context.toString().equals(this.mActivityStr)) {
            this.mActivityStr = context.toString();
            resetSBB();
            this.mReleaseDuration = -1;
            generateNewDuration();
            if (this.mIsLongTimePages) {
                enableSBB();
            }
        }
    }

    public void onAllActivityPaused(Context context) {
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd("TouchPolicy", "onAllActivityPause for " + context + " " + this.mActivityStr);
        }
        resetSBB();
        this.mActivityStr = "";
    }

    private void acquirePowerhal(int[] iArr, int i) {
        PowerHalMgr powerHalMgr = this.mPowerHalService;
        if (powerHalMgr != null) {
            this.mPowerHandle = powerHalMgr.perfLockAcquire(this.mPowerHandle, i, iArr);
        }
    }

    private void releasePowerHandle() {
        int i;
        if (this.mPowerHalService != null && (i = this.mPid) != Integer.MIN_VALUE) {
            acquirePowerhal(new int[]{PERF_RES_SCHED_SBB_GROUP_UNSET, i}, 1);
            this.mPowerHalService.perfLockRelease(this.mPowerHandle);
        }
    }
}
