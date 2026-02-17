package com.mediatek.boostfwk.policy.frame;

import android.os.Message;
import android.os.Trace;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.policy.frame.BaseFramePolicy;
import com.mediatek.boostfwk.policy.scroll.ScrollPolicy;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.powerhalmgr.PowerHalMgr;

public class FramePolicy extends BaseFramePolicy {
    private static final double CHECK_POINT = 0.5d;
    private static final int FRAME_STEP_BASIC = -1000;
    public static final int MSG_FRAME_BEGIN = 1;
    public static final int MSG_FRAME_END = 2;
    public static final int MSG_NO_DRAW = 4;
    public static final int MSG_STEP_CHECK = 3;
    public static final int MSG_TRAVERSAL_RESUCE_CHECK = 5;
    private static final int NON_FRAME_STEP = -1000;
    private static final int NON_RENDER_THREAD_TID = -1;
    private static final double NO_DRAW_FRAME_VSYNC_RATIO = 0.1d;
    private static final int PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE = 33802752;
    private static final int PERF_RES_FPS_FPSGO_STOP_BOOST = 33571328;
    private static final int RECEIVE_VSYNC_TO_INPUT = -999;
    private static final long RECUME_FRAME_ID = -10000;
    private static boolean isAnimationStepEnd = false;
    private static boolean isNoDraw = true;
    private static boolean isTranversalDraw = false;
    private static boolean isTraversalStepEnd = false;
    private static boolean mAnimAcquiredLock = false;
    private static float mFrameIntervalTime = 0.0f;
    private static int mFrameStep = -1000;
    private static boolean mIsDoframeCheck = false;
    private static float mLimitVsyncTime = 0.0f;
    private static boolean mTranversalAcquiredLock = false;
    private static FramePolicy sInstance = null;
    private static Object sLock = new Object();
    private static final String sTHREAD_NAME = "FramePolicy";
    private final int SBE_RESUCE_MODE_END = 0;
    private final int SBE_RESUCE_MODE_START = 1;
    private final int SBE_RESUCE_MODE_TO_QUEUE_END = 2;
    private int curFrameRescueMode = 2;
    private long frameStartTime = -1;
    private long mFrameId = -1;
    private int mRenderThreadTid = -1;
    private boolean underRescue = false;

    /* access modifiers changed from: protected */
    public void handleMessageInternal(Message message) {
        int i = message.what;
        if (i == 1) {
            doFrameHintInternel(true, ((Long) message.obj).longValue());
        } else if (i == 2) {
            doFrameHintInternel(false, ((Long) message.obj).longValue());
        } else if (i == 3) {
            doFrameStepHintInternel(mFrameStep);
        } else if (i == 4) {
            frameDraw(false);
        } else if (i == 5) {
            traversalRescueChecker();
        }
    }

    public static FramePolicy getInstance() {
        if (sInstance == null) {
            synchronized (sLock) {
                if (sInstance == null) {
                    sInstance = new FramePolicy();
                }
            }
        }
        return sInstance;
    }

    public boolean initLimitTime(float f) {
        if (f > 0.0f && f != mFrameIntervalTime) {
            mFrameIntervalTime = f;
            mLimitVsyncTime = (float) ((((double) f) * 0.5d) - 0.5d);
        }
        return BaseFramePolicy.mListenFrameHint && mFrameIntervalTime != 0.0f;
    }

    public void doFrameHint(boolean z, long j) {
        if (this.mCoreServiceReady) {
            if (Config.isBoostFwkLogEnable()) {
                LogUtil.mLogd(sTHREAD_NAME, "vsync is begin = " + z);
            }
            mIsDoframeCheck = z;
            if (z) {
                setFrameStep(RECEIVE_VSYNC_TO_INPUT);
                BaseFramePolicy.WorkerHandler workerHandler = this.mWorkerHandler;
                workerHandler.sendMessage(workerHandler.obtainMessage(1, Long.valueOf(j)));
                return;
            }
            if (!isNoDraw && isTranversalDraw) {
                BaseFramePolicy.WorkerHandler workerHandler2 = this.mWorkerHandler;
                workerHandler2.sendMessageDelayed(workerHandler2.obtainMessage(4, (Object) null), (long) drawFrameDelayTime());
            }
            BaseFramePolicy.WorkerHandler workerHandler3 = this.mWorkerHandler;
            workerHandler3.sendMessage(workerHandler3.obtainMessage(2, Long.valueOf(j)));
            if (BaseFramePolicy.mDisableFrameRescue) {
                BaseFramePolicy.mListenFrameHint = false;
            }
        }
    }

    public void doFrameStepHint(boolean z, int i) {
        if (this.mCoreServiceReady) {
            if (z) {
                setFrameStep(i);
                if (i == 3) {
                    mTranversalAcquiredLock = true;
                    BaseFramePolicy.WorkerHandler workerHandler = this.mWorkerHandler;
                    workerHandler.sendMessage(workerHandler.obtainMessage(3, (Object) null));
                    return;
                }
                return;
            }
            if (i == 1) {
                isAnimationStepEnd = true;
            }
            if (i == 3) {
                isTraversalStepEnd = true;
            }
        }
    }

    private void setFrameStep(int i) {
        if (i > mFrameStep) {
            mFrameStep = i;
        }
    }

    private void doFrameHintInternel(boolean z, long j) {
        if (z) {
            this.mFrameId = j;
            if (mLimitVsyncTime != 0.0f) {
                if (Config.isBoostFwkLogEnable()) {
                    LogUtil.mLogd(sTHREAD_NAME, "scrolling!! try check animation and draw state.");
                }
                BaseFramePolicy.WorkerHandler workerHandler = this.mWorkerHandler;
                workerHandler.sendMessageDelayed(workerHandler.obtainMessage(3), (long) mLimitVsyncTime);
                BaseFramePolicy.WorkerHandler workerHandler2 = this.mWorkerHandler;
                workerHandler2.sendMessageDelayed(workerHandler2.obtainMessage(5), (long) mFrameIntervalTime);
                return;
            }
            return;
        }
        this.mWorkerHandler.removeMessages(3, (Object) null);
        this.mWorkerHandler.removeMessages(5, (Object) null);
        mAnimAcquiredLock = false;
        mTranversalAcquiredLock = false;
        isTranversalDraw = false;
        isAnimationStepEnd = false;
        mFrameStep = -1000;
        this.mFrameId = -1;
        this.underRescue = false;
        isTraversalStepEnd = false;
    }

    /* JADX WARNING: Removed duplicated region for block: B:25:0x0052  */
    /* JADX WARNING: Removed duplicated region for block: B:32:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void doFrameStepHintInternel(int r7) {
        /*
            r6 = this;
            boolean r0 = mIsDoframeCheck
            if (r0 != 0) goto L_0x0009
            r0 = -1000(0xfffffffffffffc18, float:NaN)
            if (r7 != r0) goto L_0x0009
            return
        L_0x0009:
            java.lang.String r0 = "FramePolicy"
            r1 = -999(0xfffffffffffffc19, float:NaN)
            r2 = 1
            if (r7 == r1) goto L_0x0018
            r3 = 3
            if (r7 == r3) goto L_0x004a
            if (r7 == 0) goto L_0x0018
            if (r7 == r2) goto L_0x0018
            goto L_0x0066
        L_0x0018:
            boolean r3 = isAnimationStepEnd
            if (r3 != 0) goto L_0x0033
            r3 = 33802752(0x203ca00, float:9.682331E-38)
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            java.lang.String r5 = "animation end, curStep="
            r4.append(r5)
            r4.append(r7)
            java.lang.String r4 = r4.toString()
            r6.powerHintForRender(r3, r4)
        L_0x0033:
            boolean r3 = mAnimAcquiredLock
            if (r3 != 0) goto L_0x004a
            if (r7 == r1) goto L_0x004a
            boolean r7 = com.mediatek.boostfwk.utils.Config.isBoostFwkLogEnable()
            if (r7 == 0) goto L_0x0044
            java.lang.String r7 = "input/anim hint drop, enable rescue!"
            com.mediatek.boostfwk.utils.LogUtil.mLogd(r0, r7)
        L_0x0044:
            r6.frameDraw(r2)
            mAnimAcquiredLock = r2
            goto L_0x0066
        L_0x004a:
            boolean r7 = mTranversalAcquiredLock
            if (r7 == 0) goto L_0x0066
            boolean r7 = mAnimAcquiredLock
            if (r7 != 0) goto L_0x0066
            boolean r7 = com.mediatek.boostfwk.utils.Config.isBoostFwkLogEnable()
            if (r7 == 0) goto L_0x005e
            java.lang.String r7 = "traversal step, enable rescue!"
            com.mediatek.boostfwk.utils.LogUtil.mLogd(r0, r7)
        L_0x005e:
            r6.frameDraw(r2)
            r6 = 0
            mTranversalAcquiredLock = r6
            mAnimAcquiredLock = r2
        L_0x0066:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.boostfwk.policy.frame.FramePolicy.doFrameStepHintInternel(int):void");
    }

    private void traversalRescueChecker() {
        if (!this.underRescue && mFrameStep == 3 && !isTraversalStepEnd) {
            powerHintForRender(PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE, "traversal over vsync, curStep=" + mFrameStep);
        }
    }

    private void frameDraw(boolean z) {
        if (!z || this.mFrameId != -1) {
            if (z) {
                if (isNoDraw && LogUtil.DEBUG) {
                    LogUtil.trace("Draw, notify FPSGO draw" + this.mFrameId);
                }
                this.mWorkerHandler.removeMessages(4, (Object) null);
                isNoDraw = false;
                isTranversalDraw = true;
                return;
            }
            powerHintForRender(PERF_RES_FPS_FPSGO_STOP_BOOST, "STOP: No draw");
            isNoDraw = true;
        } else if (LogUtil.DEBUG) {
            LogUtil.mLogd(sTHREAD_NAME, "frame clear when rescue. mFrameId = " + this.mFrameId);
        }
    }

    private void powerHintForRender(int i, String str) {
        int renderThreadTid = getRenderThreadTid();
        if (LogUtil.DEBUG) {
            Trace.traceBegin(8, "hint for [" + str + "] render id = " + renderThreadTid);
        }
        if (i == PERF_RES_FPS_FPSGO_STOP_BOOST) {
            perfLockAcquire(new int[]{i, renderThreadTid});
            ScrollPolicy.getInstance().disableMTKScrollingPolicy(true);
        } else if (i == PERF_RES_FPS_FBT_RESCUE_SBE_RESCUE) {
            this.underRescue = true;
            this.mPowerHalWrap.mtkNotifySbeRescue(renderThreadTid, this.curFrameRescueMode, 50, RECUME_FRAME_ID);
        } else if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(sTHREAD_NAME, "not surpport for cmd = " + i);
        }
        if (Config.isBoostFwkLogEnable()) {
            Trace.traceEnd(8);
        }
    }

    private double drawFrameDelayTime() {
        if (mFrameIntervalTime == 0.0f) {
            return -1.0d;
        }
        return ((double) mFrameIntervalTime) * ((double) ScrollState.getRefreshRate()) * NO_DRAW_FRAME_VSYNC_RATIO;
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
}
