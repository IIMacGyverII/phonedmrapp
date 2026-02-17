package com.mediatek.boostfwk.policy.frame;

import android.content.Context;
import android.view.Choreographer;
import android.view.ThreadedRenderer;
import com.android.internal.telephony.TimeUtils;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.scenario.frame.FrameScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import java.lang.ref.WeakReference;

public class ScrollingFramePrefetcher {
    private static final double ANIM_THRESHOLD = 1.0d;
    private static final int BUFFER_COUNT = 2;
    private static final float DISPLAY_RATE_90 = 90.0f;
    private static final int ERROR_CODE = -22;
    public static final long ESTIMATION_FRAME_ID = -1;
    public static final int ESTIMATION_FRAME_LIMIT = 5;
    public static final boolean FEATURE_ENABLE = Config.isEnableFramePrefetcher();
    private static final double FRAME_THRESHOLD = 1.4d;
    private static final int MAX_BUFFER_SIZE = 5;
    private static final int NO_CHANGED = -1;
    public static final boolean PRE_ANIM_ENABLE = Config.isEnablePreAnimation();
    private static final String TAG = "ScrollingFramePrefetcher";
    private static final Object lock = new Object();
    public static boolean mFeatureLocked = false;
    private static ScrollingFramePrefetcher sInstance = null;
    private final int DROP_FRAME;
    private final int FIRST_FRAME;
    private final int RESET_FRAME;
    private ActivityInfo.ActivityChangeListener mActivityChangeListener;
    /* access modifiers changed from: private */
    public ActivityInfo mActivityInfo;
    private boolean mAppRequestVsync;
    private WeakReference<Choreographer> mChoreographer;
    private int mDefaultBufferSize;
    private int mEstimationFrameCount;
    private long mFirstFlingFrameTimeNano;
    private long mFrameEndTimeNano;
    private long mFrameIntervalNanos;
    private boolean mIsAnimDrop;
    private boolean mIsEstimationFrame;
    private boolean mIsFling;
    private boolean mIsPreAnim;
    private boolean mIsPreAnimationRunning;
    private long mLastAnimFrameTimeNano;
    private int mLastBufferSize;
    private long mLastFrameTimeNano;
    private long mLastOrigFrameTimeNano;
    private boolean mNeedScheduleNextFrame;
    private long mPreAnimEndTimeNano;
    private ScrollState.RefreshRateChangedListener mRefreshRateChangedListener;
    private ScrollState.ScrollStateListener mScrollStateListener;

    public static ScrollingFramePrefetcher getInstance() {
        if (sInstance == null) {
            synchronized (lock) {
                if (sInstance == null) {
                    sInstance = new ScrollingFramePrefetcher();
                }
            }
        }
        return sInstance;
    }

    private ScrollingFramePrefetcher() {
        this.mChoreographer = null;
        this.mFirstFlingFrameTimeNano = -1;
        this.mLastFrameTimeNano = -1;
        this.mLastOrigFrameTimeNano = -1;
        this.mLastAnimFrameTimeNano = -1;
        this.mFrameEndTimeNano = -1;
        this.mPreAnimEndTimeNano = -1;
        this.mIsEstimationFrame = false;
        this.mIsFling = false;
        this.mIsPreAnim = false;
        this.mIsAnimDrop = false;
        this.mAppRequestVsync = false;
        this.mIsPreAnimationRunning = false;
        this.mNeedScheduleNextFrame = false;
        this.mEstimationFrameCount = 0;
        this.mFrameIntervalNanos = -1;
        this.FIRST_FRAME = 0;
        this.DROP_FRAME = 1;
        this.RESET_FRAME = 2;
        this.mDefaultBufferSize = -1;
        this.mLastBufferSize = -1;
        this.mActivityInfo = null;
        this.mRefreshRateChangedListener = null;
        this.mScrollStateListener = null;
        this.mActivityChangeListener = null;
        this.mActivityInfo = ActivityInfo.getInstance();
        this.mRefreshRateChangedListener = new ScrollState.RefreshRateChangedListener() {
            public void onDisplayRefreshRateChanged(int i, float f, float f2) {
                ScrollingFramePrefetcher.this.onRefreshRateChanged(f, f2);
            }
        };
        this.mActivityChangeListener = new ActivityInfo.ActivityChangeListener() {
            public void onChange(Context context) {
                ScrollingFramePrefetcher.this.resetStatusWhenScroll();
            }
        };
        AnonymousClass3 r0 = new ScrollState.ScrollStateListener() {
            public void onScroll(boolean z) {
                if (Config.mIncreaseBuffer) {
                    ScrollingFramePrefetcher.getInstance().setBufferSize(ScrollingFramePrefetcher.this.mActivityInfo.getThreadedRenderer(), z);
                }
            }
        };
        this.mScrollStateListener = r0;
        ScrollState.registerScrollStateListener(r0);
        this.mActivityInfo.registerActivityListener(this.mActivityChangeListener);
        ScrollState.registerRefreshRateChangedListener(this.mRefreshRateChangedListener);
    }

    public void doScrollingFramePrefetcher(FrameScenario frameScenario) {
        estimationFrameTime(frameScenario.getOrigFrameTime(), frameScenario.getFrameData(), frameScenario);
    }

    private boolean disableSFP() {
        return !FEATURE_ENABLE || !this.mIsFling || ScrollState.getRefreshRate() < DISPLAY_RATE_90 || mFeatureLocked;
    }

    private void estimationFrameTime(long j, Choreographer.FrameData frameData, FrameScenario frameScenario) {
        long frameTimeNanos = frameData.getFrameTimeNanos();
        Choreographer choreographer = frameScenario.getChoreographer();
        if (disableSFP() || choreographer == null) {
            this.mIsPreAnim = false;
            frameScenario.setFrameTimeResult(frameTimeNanos);
            if (LogUtil.DEBUG) {
                LogUtil.trace("ScrollingFramePrefetcher#disableSFP-because, feature:" + FEATURE_ENABLE + "isFling= " + this.mIsFling + "featureLocked= " + mFeatureLocked + "refreshRate: " + ScrollState.getRefreshRate());
                return;
            }
            return;
        }
        this.mChoreographer = new WeakReference<>(choreographer);
        updateFrameIntervalNanos();
        frameScenario.setFrameTimeResult(estimationFrameTimeInternel(j, frameData));
    }

    private long estimationFrameTimeInternel(long j, Choreographer.FrameData frameData) {
        long j2;
        long frameTimeNanos = frameData.getFrameTimeNanos();
        if (this.mFirstFlingFrameTimeNano == -1) {
            updateDynaFrameStatus(0, frameTimeNanos);
            j2 = frameTimeNanos;
        } else {
            if (LogUtil.DEBUG) {
                LogUtil.trace("ScrollingFramePrefetcher#estimationFrameTimeInternel-before, orig frame time = " + j + ", last orig frame time = " + this.mLastOrigFrameTimeNano + ", last frame time = " + this.mLastFrameTimeNano);
            }
            if (isPreAnimation()) {
                this.mLastFrameTimeNano = this.mLastAnimFrameTimeNano;
            } else {
                this.mLastFrameTimeNano = correctionFrameTime(frameTimeNanos, this.mLastFrameTimeNano);
            }
            j2 = this.mLastFrameTimeNano;
        }
        this.mLastOrigFrameTimeNano = j;
        if (LogUtil.DEBUG) {
            LogUtil.trace("ScrollingFramePrefetcher#estimationFrameTimeInternel, orig frame time = " + (j / TimeUtils.NANOS_PER_MS) + ", frame time = " + (frameTimeNanos / TimeUtils.NANOS_PER_MS) + ", last frame time = " + (this.mLastFrameTimeNano / TimeUtils.NANOS_PER_MS) + ", last anim frame time = " + (this.mLastAnimFrameTimeNano / TimeUtils.NANOS_PER_MS) + ", result = " + (j2 / TimeUtils.NANOS_PER_MS));
        }
        return j2;
    }

    private long predictPreAnimTime(long j, long j2) {
        long j3 = j + j2;
        if (LogUtil.DEBUG) {
            LogUtil.trace("ScrollingFramePrefetcher#predictPreAnimTime, orig frame Time = " + (j / TimeUtils.NANOS_PER_MS) + ", frameIntervalNanos = " + (j2 / TimeUtils.NANOS_PER_MS) + ", next frame time = " + (j3 / TimeUtils.NANOS_PER_MS));
        }
        return j3;
    }

    public void onFrameEnd(boolean z, FrameScenario frameScenario) {
        if (disableSFP() || z || this.mChoreographer == null) {
            if (LogUtil.DEBUG) {
                LogUtil.trace("ScrollingFramePrefetcher#onFrameEnd, isFrameBegin = " + z + ", mIsFling = " + this.mIsFling + ", mChoreographer = " + this.mChoreographer);
            }
        } else if (ScrollState.getRefreshRate() >= DISPLAY_RATE_90) {
            long nanoTime = System.nanoTime();
            boolean isDropFrame = isDropFrame(this.mLastFrameTimeNano, nanoTime, FRAME_THRESHOLD);
            String str = (!isDropFrame || !LogUtil.DEBUG) ? "" : "drop frame because this frame too long, will insert new frame when this frame end.";
            if (!isDropFrame) {
                long j = this.mFrameEndTimeNano;
                if (j != -1 && (isDropFrame = isDropFrame(j, nanoTime, FRAME_THRESHOLD)) && LogUtil.DEBUG) {
                    str = "drop frame because time too long between last frame end with this,will insert new frame when this frame end.";
                }
            }
            if (isDropFrame && !this.mIsAnimDrop) {
                updateDynaFrameStatus(1, this.mLastFrameTimeNano);
            }
            boolean z2 = LogUtil.DEBUG;
            if (z2) {
                LogUtil.trace("ScrollingFramePrefetcher#onFrameEnd, is drop frame = " + isDropFrame + ", mIsEstimationFrame = " + this.mIsEstimationFrame + ", drop reason = " + str);
            }
            this.mFrameEndTimeNano = nanoTime;
            if (frameScenario.getFrameId() == -1) {
                this.mEstimationFrameCount++;
            } else {
                this.mEstimationFrameCount = 0;
            }
            if (this.mIsEstimationFrame) {
                this.mIsEstimationFrame = false;
                if (z2) {
                    LogUtil.trace("ScrollingFramePrefetcher#onFrameEnd, estimation frame time = " + (this.mLastFrameTimeNano / TimeUtils.NANOS_PER_MS));
                }
                if (this.mEstimationFrameCount < 5 && !this.mIsAnimDrop) {
                    this.mIsPreAnim = false;
                    this.mAppRequestVsync = false;
                    doEstimationFrameHook(this.mLastFrameTimeNano);
                    doPreAnimation(this.mLastFrameTimeNano);
                    this.mIsPreAnim = true;
                    return;
                }
            }
            if (this.mIsPreAnim && !this.mIsAnimDrop) {
                doPreAnimation(this.mLastAnimFrameTimeNano);
            }
        } else if (this.mNeedScheduleNextFrame) {
            this.mNeedScheduleNextFrame = false;
            forceScheduleNexFrame();
        }
    }

    private void doPreAnimation(long j) {
        if (!PRE_ANIM_ENABLE || this.mChoreographer == null) {
            this.mIsPreAnim = false;
            return;
        }
        long predictPreAnimTime = predictPreAnimTime(j, this.mFrameIntervalNanos);
        if (LogUtil.DEBUG) {
            LogUtil.trace("ScrollingFramePrefetcher#doPreAnimation, pre anim frame time = " + (predictPreAnimTime / TimeUtils.NANOS_PER_MS) + ", mLastAnimFrameTimeNano = " + (this.mLastAnimFrameTimeNano / TimeUtils.NANOS_PER_MS));
        }
        this.mIsPreAnimationRunning = true;
        long nanoTime = System.nanoTime();
        doPreAnimationHook(predictPreAnimTime);
        long nanoTime2 = System.nanoTime();
        this.mIsPreAnimationRunning = false;
        this.mPreAnimEndTimeNano = nanoTime2;
        this.mLastAnimFrameTimeNano = predictPreAnimTime;
        boolean isDropFrame = isDropFrame(nanoTime, nanoTime2, ANIM_THRESHOLD);
        this.mIsAnimDrop = isDropFrame;
        if (isDropFrame) {
            doEstimationFrameHook(this.mLastAnimFrameTimeNano);
            updateDynaFrameStatus(1, j);
        }
    }

    private boolean isDropFrame(long j, long j2, double d) {
        if (j == -1) {
            return false;
        }
        return j2 - j > ((long) (((double) this.mFrameIntervalNanos) * d));
    }

    public boolean isPreAnimation() {
        if (!PRE_ANIM_ENABLE) {
            return false;
        }
        return this.mIsPreAnim;
    }

    public void setPreAnimation(boolean z) {
        if (!PRE_ANIM_ENABLE) {
            this.mIsPreAnim = false;
        }
        this.mIsPreAnim = z;
    }

    private void updateFlingStatus(boolean z, long j) {
        if (this.mIsFling != z) {
            if (LogUtil.DEBUG) {
                LogUtil.trace("ScrollingFramePrefetcher#updateFlingStatus, mIsFling = " + this.mIsFling + ", isFling = " + z);
            }
            this.mIsFling = z;
            updateDynaFrameStatus(2, 0);
            if (!this.mIsFling) {
                this.mChoreographer = null;
            }
        }
    }

    public void setFling(boolean z) {
        updateFlingStatus(z, 0);
    }

    private void updateDynaFrameStatus(int i, long j) {
        if (i == 0) {
            firstFrameStatus(j);
        } else if (i == 1) {
            dropFrameStatus(j);
        } else if (i == 2) {
            resetStatus();
        }
    }

    private void firstFrameStatus(long j) {
        synchronized (lock) {
            this.mFirstFlingFrameTimeNano = j;
            this.mIsEstimationFrame = true;
            this.mLastFrameTimeNano = j;
            this.mLastAnimFrameTimeNano = j;
            this.mIsPreAnim = false;
            this.mIsAnimDrop = false;
            if (LogUtil.DEBUG) {
                LogUtil.trace("ScrollingFramePrefetcher#firstFrameStatus, mIsEstimationFrame = " + this.mIsEstimationFrame);
            }
        }
    }

    private void dropFrameStatus(long j) {
        synchronized (lock) {
            this.mLastFrameTimeNano = j;
            this.mLastAnimFrameTimeNano = j;
            this.mIsEstimationFrame = true;
            this.mIsPreAnim = false;
            this.mIsAnimDrop = false;
            if (LogUtil.DEBUG) {
                LogUtil.trace("ScrollingFramePrefetcher#dropFrameStatus, mFirstFlingFrameTimeNano = " + this.mFirstFlingFrameTimeNano + ", mIsEstimationFrame = " + this.mIsEstimationFrame);
            }
        }
    }

    private void resetStatus() {
        synchronized (lock) {
            this.mFirstFlingFrameTimeNano = -1;
            this.mLastFrameTimeNano = -1;
            this.mLastOrigFrameTimeNano = -1;
            this.mLastAnimFrameTimeNano = -1;
            this.mFrameEndTimeNano = -1;
            this.mPreAnimEndTimeNano = -1;
            this.mIsEstimationFrame = false;
            this.mIsPreAnim = false;
            this.mIsAnimDrop = false;
            if (LogUtil.DEBUG) {
                LogUtil.trace("ScrollingFramePrefetcher#resetStatus, mFirstFlingFrameTimeNano = " + this.mFirstFlingFrameTimeNano);
            }
        }
    }

    private void updateFrameIntervalNanos() {
        long refreshRate = (long) (1.0E9f / ScrollState.getRefreshRate());
        if (this.mFrameIntervalNanos != refreshRate) {
            this.mFrameIntervalNanos = refreshRate;
        }
    }

    private long correctionFrameTime(long j, long j2) {
        long j3 = this.mFrameIntervalNanos + j2;
        long j4 = j - j3;
        if (LogUtil.DEBUG) {
            LogUtil.trace("ScrollingFramePrefetcher#correctionFrameTime, frameTimeNano = " + j + ", lastFrameTimeNano = " + j2 + ", targetFrameTime = " + j3 + ", diff = " + j4);
        }
        return j4 > 0 ? j : j3;
    }

    private void doEstimationFrameHook(long j) {
        Choreographer choreographer;
        WeakReference<Choreographer> weakReference = this.mChoreographer;
        if (weakReference != null && (choreographer = (Choreographer) weakReference.get()) != null) {
            if (choreographer.isEmptyCallback()) {
                LogUtil.trace("ScrollingFramePrefetcher#no draw at this time, skip.");
                return;
            }
            choreographer.forceFrameScheduled();
            choreographer.doEstimationFrame(j);
            if (this.mAppRequestVsync) {
                this.mAppRequestVsync = false;
                choreographer.forceFrameScheduled();
            }
        }
    }

    private void doPreAnimationHook(long j) {
        Choreographer choreographer;
        WeakReference<Choreographer> weakReference = this.mChoreographer;
        if (weakReference != null && (choreographer = (Choreographer) weakReference.get()) != null) {
            choreographer.doPreAnimation(j, this.mFrameIntervalNanos);
        }
    }

    public void disableAndLockSFP(boolean z) {
        LogUtil.traceBegin("resetAndLockSFP");
        mFeatureLocked = z;
        resetStatusWhenScroll();
        LogUtil.traceEnd();
    }

    /* access modifiers changed from: private */
    public void resetStatusWhenScroll() {
        setFling(false);
        setPreAnimation(false);
    }

    public void onRequestNextVsync() {
        this.mAppRequestVsync = true;
    }

    public boolean isPreAnimationRunning() {
        return this.mIsPreAnimationRunning;
    }

    /* access modifiers changed from: private */
    public void onRefreshRateChanged(float f, float f2) {
        if (Config.isVariableRefreshRateSupported() && this.mIsFling && PRE_ANIM_ENABLE && FEATURE_ENABLE && f >= 58.0f) {
            if (LogUtil.DEBUG) {
                LogUtil.traceAndMLogd(TAG, "#onRefreshRateChanged mark NeedScheduleNextFrame whenchange to refreshRate=" + f);
            }
            this.mNeedScheduleNextFrame = true;
        }
    }

    private void forceScheduleNexFrame() {
        Choreographer choreographer;
        WeakReference<Choreographer> weakReference = this.mChoreographer;
        if (weakReference != null && (choreographer = (Choreographer) weakReference.get()) != null) {
            if (LogUtil.DEBUG) {
                LogUtil.traceBegin("forceScheduleNexFrame");
            }
            choreographer.forceScheduleNexFrame();
            LogUtil.traceEnd();
        }
    }

    /* access modifiers changed from: private */
    public void setBufferSize(ThreadedRenderer threadedRenderer, boolean z) {
        if (!Config.mIncreaseBuffer || threadedRenderer == null) {
            LogUtil.mLogd(TAG, "render=null, set buffer size error");
        } else if (z) {
            if (this.mDefaultBufferSize == -1) {
                int bufferSize = threadedRenderer.getSurface().getBufferSize();
                if (bufferSize == ERROR_CODE) {
                    LogUtil.mLoge(TAG, "get buffer size error.");
                } else if (bufferSize < 5 && this.mDefaultBufferSize == -1) {
                    this.mDefaultBufferSize = bufferSize;
                    int i = this.mLastBufferSize;
                    if (!(i == -1 || bufferSize == i)) {
                        this.mDefaultBufferSize = i;
                        LogUtil.mLogd(TAG, "reset buffer size to last " + this.mDefaultBufferSize);
                    }
                    if (LogUtil.DEBUG) {
                        LogUtil.mLogd(TAG, "set buffer size = " + (this.mDefaultBufferSize + 2) + ", isScrolling = " + z + ", render = " + threadedRenderer);
                    }
                    threadedRenderer.getSurface().setBufferSize(this.mDefaultBufferSize + 2);
                }
            }
        } else if (this.mDefaultBufferSize != -1) {
            threadedRenderer.getSurface().setBufferSize(this.mDefaultBufferSize);
            this.mLastBufferSize = this.mDefaultBufferSize;
            if (LogUtil.DEBUG) {
                LogUtil.mLogd(TAG, "reset buffer size = " + this.mDefaultBufferSize + ", isScrolling = " + z + ", render = " + threadedRenderer);
            }
            this.mDefaultBufferSize = -1;
        }
    }
}
