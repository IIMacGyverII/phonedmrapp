package com.mediatek.boostfwk.policy.frame;

import android.content.Context;
import android.view.ThreadedRenderer;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.scenario.frame.FrameScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.powerhalwrapper.PowerHalWrapper;

public class FrameDecision implements ScrollState.ScrollStateListener, ActivityInfo.ActivityChangeListener {
    private static final Object LOCK = new Object();
    private static final String TAG = "FrameDecision";
    private static FrameDecision mInstance;
    private final int FRAME_BEGIN = 0;
    private final int FRAME_END = 1;
    private final int FRAME_MUTIL_BUFFER = -2;
    private final int FRAME_UNUSUAL = -1;
    private final int PAGE_TYPE_FLUTTER = 1;
    private final int PAGE_TYPE_HWUI = 0;
    private final int PAGE_TYPE_WEBVIEW = 2;
    private boolean mEnbaleFrameTracking = false;
    private boolean mForceCtrl = false;
    private int mFrameDrawnCount = 0;
    private int mFrameRequestTraversalCount = 0;
    private long mLastFrameBeginFrameId = -1;
    private int mLastHWUIDoFrameStep = -1;
    private PowerHalWrapper mPowerHalWrap = null;
    private int mRenderThreadTid = Integer.MIN_VALUE;
    private boolean mStartListenFrameHint = false;

    public static FrameDecision getInstance() {
        if (mInstance == null) {
            synchronized (LOCK) {
                if (mInstance == null) {
                    mInstance = new FrameDecision();
                }
            }
        }
        return mInstance;
    }

    private FrameDecision() {
        if (Config.getBoostFwkVersion() > 2) {
            ScrollState.registerScrollStateListener(this);
            ActivityInfo.getInstance().registerActivityListener(this);
            ActivityInfo.updateSBEMask(8, LogUtil.DEBUG);
        }
    }

    public void onDoFrame(boolean z, long j) {
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd(TAG, "begin=" + z + " mEnableDecision=" + this.mEnbaleFrameTracking + " mStartListenFrameHint=" + this.mStartListenFrameHint);
        }
        if (this.mEnbaleFrameTracking && this.mStartListenFrameHint) {
            if (z) {
                onDoFrameBegin(j);
            } else {
                onDoFrameEnd(j);
            }
        }
    }

    private void onDoFrameBegin(long j) {
        this.mLastFrameBeginFrameId = j;
        notifyFPSGoFrame(j, 0, 0);
    }

    private void onDoFrameEnd(long j) {
        int i;
        if (this.mLastHWUIDoFrameStep < 3 || (i = this.mFrameDrawnCount) == 0) {
            notifyFPSGoFrame(j, -1, 0);
        } else {
            int i2 = this.mFrameRequestTraversalCount;
            if (i < i2 && i2 > 1) {
                notifyFPSGoFrame(j, 1, 0);
            }
        }
        this.mFrameDrawnCount = 0;
        this.mLastHWUIDoFrameStep = -1;
        this.mLastFrameBeginFrameId = -1;
        ActivityInfo.updateSBEMask(4, false);
        ActivityInfo.clearTraversalCount();
    }

    public void perfromDraw() {
        if (this.mEnbaleFrameTracking && this.mStartListenFrameHint) {
            this.mFrameDrawnCount++;
        }
    }

    public void onDoFrameStep(boolean z, int i, FrameScenario frameScenario) {
        if (this.mEnbaleFrameTracking && this.mStartListenFrameHint) {
            if (!z) {
                this.mLastHWUIDoFrameStep = i;
                if (LogUtil.DEBUG) {
                    LogUtil.traceAndMLogd(TAG, "mLastHWUIDoFrameStep=" + this.mLastHWUIDoFrameStep);
                }
            } else if (i == 3) {
                this.mFrameRequestTraversalCount = frameScenario.getTraversalCallbackCount();
                if (LogUtil.DEBUG) {
                    LogUtil.traceBegin("updateSBEMask SBE_MASK_SKIP_FRAME_END_HINT" + this.mFrameRequestTraversalCount);
                }
                int i2 = this.mFrameRequestTraversalCount;
                if (i2 > 1) {
                    updateSBEMask(true, ((i2 - 1) << 16) | 4);
                }
                LogUtil.traceEnd();
            }
        }
    }

    private void notifyFPSGoFrame(long j, int i, int i2) {
        if (this.mPowerHalWrap == null) {
            this.mPowerHalWrap = PowerHalWrapper.getInstance();
        }
        int renderThreadTid = getRenderThreadTid();
        if (renderThreadTid != Integer.MIN_VALUE) {
            if (j < 0 && LogUtil.DEBUG) {
                LogUtil.traceAndMLogd(TAG, "mRenderThread " + renderThreadTid + "hint for prefetch frame");
            }
            if (LogUtil.DEBUG) {
                LogUtil.traceBeginAndMLogd(TAG, "hint for frame [" + i2 + "] frameId=" + j + " status=" + i + " renderThreadTid=" + renderThreadTid);
            }
            this.mPowerHalWrap.mtkNotifyFrame(renderThreadTid, i, j);
            LogUtil.traceEnd();
        } else if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd(TAG, "invalid renderThreadTid");
        }
    }

    private int getRenderThreadTid() {
        if (this.mRenderThreadTid == Integer.MIN_VALUE) {
            this.mRenderThreadTid = ActivityInfo.getInstance().getRenderThreadTid();
        }
        return this.mRenderThreadTid;
    }

    public void onScroll(boolean z) {
        if (!this.mForceCtrl && Config.isFrameDecisionForScrolling()) {
            this.mEnbaleFrameTracking = z;
            if (!Config.isEnableFrameRescue()) {
                updateSBEMask(this.mEnbaleFrameTracking, 2);
            }
        }
    }

    public void onChange(Context context) {
        this.mStartListenFrameHint = true;
        if (Config.isFrameDecisionForAll()) {
            this.mEnbaleFrameTracking = true;
        } else if (Config.isDisableFrameDecision()) {
            this.mEnbaleFrameTracking = false;
        }
        updateSBEMask(this.mEnbaleFrameTracking, 2);
        this.mRenderThreadTid = Integer.MIN_VALUE;
    }

    public void setStartFrameTracking(boolean z) {
        this.mForceCtrl = z;
        this.mEnbaleFrameTracking = z;
        updateSBEMask(z, 2);
    }

    public void setStartListenFrameHint(boolean z) {
        this.mStartListenFrameHint = z;
    }

    public boolean isEnableFrameTracking() {
        return this.mEnbaleFrameTracking;
    }

    private void updateSBEMask(boolean z, int i) {
        if (ActivityInfo.getInstance().getThreadedRenderer() != null) {
            ThreadedRenderer.needFrameCompleteHint(ActivityInfo.updateSBEMask(i, z));
        }
    }
}
