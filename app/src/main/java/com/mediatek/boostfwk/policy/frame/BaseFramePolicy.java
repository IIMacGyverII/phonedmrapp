package com.mediatek.boostfwk.policy.frame;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.view.ThreadedRenderer;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.powerhalmgr.PowerHalMgr;
import com.mediatek.powerhalmgr.PowerHalMgrFactory;
import com.mediatek.powerhalwrapper.PowerHalWrapper;

public class BaseFramePolicy implements ActivityInfo.ActivityChangeListener {
    static final String TAG = "FramePolicy";
    static final String THREAD_NAME = "FramePolicy";
    static boolean mDisableFrameRescue = true;
    static boolean mListenFrameHint = false;
    ActivityInfo mActivityInfo = null;
    boolean mCoreServiceReady = false;
    PowerHalMgr mPowerHalService = null;
    PowerHalWrapper mPowerHalWrap = null;
    int mPowerHandle = 0;
    ScrollState.ScrollStateListener mScrollStateListener = null;
    WorkerHandler mWorkerHandler = null;
    HandlerThread mWorkerThread = null;

    public void doFrameHint(boolean z, long j) {
    }

    public void doFrameStepHint(boolean z, int i) {
    }

    /* access modifiers changed from: protected */
    public void handleMessageInternal(Message message) {
    }

    public boolean initLimitTime(float f) {
        return false;
    }

    public void onAllActivityPaused(Context context) {
    }

    public void onRequestNextVsync() {
    }

    private class ScrollListener implements ScrollState.ScrollStateListener {
        private ScrollListener() {
        }

        public void onScroll(boolean z) {
            BaseFramePolicy.this.onScrollStateChange(z);
        }
    }

    BaseFramePolicy() {
        initThread();
        this.mScrollStateListener = new ScrollListener();
        ActivityInfo instance = ActivityInfo.getInstance();
        this.mActivityInfo = instance;
        instance.registerActivityListener(this);
    }

    private void initThread() {
        HandlerThread handlerThread = this.mWorkerThread;
        if (handlerThread == null || !handlerThread.isAlive() || this.mWorkerHandler == null) {
            HandlerThread handlerThread2 = new HandlerThread("FramePolicy");
            this.mWorkerThread = handlerThread2;
            handlerThread2.start();
            Looper looper = this.mWorkerThread.getLooper();
            if (looper == null) {
                LogUtil.mLogd("FramePolicy", "Thread looper is null");
            } else {
                this.mWorkerHandler = new WorkerHandler(looper);
            }
        } else {
            LogUtil.mLogd("FramePolicy", "re-init");
        }
    }

    public ThreadedRenderer getThreadedRenderer() {
        ActivityInfo activityInfo = this.mActivityInfo;
        if (activityInfo == null) {
            return null;
        }
        return activityInfo.getThreadedRenderer();
    }

    /* access modifiers changed from: protected */
    public void onScrollStateChange(boolean z) {
        boolean z2 = !z;
        mDisableFrameRescue = z2;
        if (!z2) {
            mListenFrameHint = true;
        }
    }

    /* access modifiers changed from: protected */
    public void initCoreServiceInternal() {
        this.mPowerHalService = PowerHalMgrFactory.getInstance().makePowerHalMgr();
        this.mPowerHalWrap = PowerHalWrapper.getInstance();
        ScrollState.registerScrollStateListener(this.mScrollStateListener);
        this.mCoreServiceReady = true;
    }

    protected class WorkerHandler extends Handler {
        public static final int MSG_INIT_CORE_SERVICE = -1000;

        WorkerHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            if (message.what == -1000) {
                BaseFramePolicy.this.initCoreServiceInternal();
            } else {
                BaseFramePolicy.this.handleMessageInternal(message);
            }
        }
    }

    public void onChange(Context context) {
        WorkerHandler workerHandler;
        if (!this.mCoreServiceReady && (workerHandler = this.mWorkerHandler) != null) {
            workerHandler.sendEmptyMessage(-1000);
        }
    }
}
