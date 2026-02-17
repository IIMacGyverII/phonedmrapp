package com.mediatek.boostfwk.policy.refreshrate;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.RemoteException;
import android.os.SystemClock;
import android.view.MotionEvent;
import android.view.SurfaceControl;
import android.view.VelocityTracker;
import android.view.ViewRootImpl;
import android.view.Window;
import android.view.WindowManager;
import android.view.WindowManagerGlobal;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.scenario.refreshrate.EventScenario;
import com.mediatek.boostfwk.scenario.refreshrate.RefreshRateScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.Util;
import dalvik.system.PathClassLoader;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;

public class RefreshRatePolicy {
    private static final int DEFAULT_MIN_REFRESHRATE_CHANGE_VALUE = 1000;
    private static final float FLING_STOP_PROGRESS_THRESHOLED = 0.99f;
    private static final int IDLE_DELAY_TIME = 2000;
    private static final int LIST_FINISH_THRESHOLED = 150;
    private static final int LIST_STATE_FLING_FINISH = 2;
    private static final int LIST_STATE_FLING_START = 0;
    private static final int LIST_STATE_FLING_UPDATE = 1;
    private static final int LIST_STATE_SCROLLER_INIT = 3;
    private static final int MOTION_EVENT_ACTION_DEFAULT = -1;
    private static final int MOTION_EVENT_ACTION_DOWN = 0;
    private static final int MOTION_EVENT_ACTION_MOVE = 1;
    private static final int MOTION_EVENT_ACTION_UP = 2;
    private static final int MSG_ENTER_IDLE = 0;
    private static final int REFRESH_RATE_IDLE = 1000;
    private static final int REFRESH_RATE_IME = 1003;
    private static final int REFRESH_RATE_INVALID = 9999;
    private static final int REFRESH_RATE_TOUCH_SCROLL_DOWN = 1001;
    private static final int REFRESH_RATE_TOUCH_SCROLL_UP = 1000;
    private static final int SCENARIO_ACTION_DEFAULT = 0;
    private static final int SCENARIO_ACTION_HIDE = 2;
    private static final int SCENARIO_ACTION_SHOW = 1;
    private static final int SCENARIO_TYPE_DEFAULT = 0;
    private static final int SCENARIO_TYPE_IME = 1;
    private static final int SCENARIO_TYPE_VOICE = 2;
    private static final String TAG = "MSYNC3-VariableRefreshRate";
    private static final int TOUCH_SCROLL_REFRESH_CHANGE_THRESHOLED = 200;
    private static final int TOUCH_SCROLL_REFRESH_DURATION_THRESHOLED = 300;
    private static final int TOUCH_SCROLL_REFRESH_VELOCITY_THRESHOLED = 100;
    private static final int TOUCH_SCROLL_STATE_HIGH_SPEED = 0;
    private static final int TOUCH_SCROLL_STATE_INVALID_SPEED = -1;
    private static final int TOUCH_SCROLL_STATE_LOW_SPEED = 1;
    private static final int TOUCH_SCROLL_VELOCITY_SAMPLE_COUNT = 5;
    /* access modifiers changed from: private */
    public RefreshRateScenario mActiveRefreshScenario;
    /* access modifiers changed from: private */
    public boolean mActivityHasVideoView;
    /* access modifiers changed from: private */
    public PathClassLoader mClassLoader;
    private int mCurrentMaxRefreshRate;
    private int mCurrentTouchState;
    /* access modifiers changed from: private */
    public ArrayList<Float> mFlingRefreshRateChangeGap;
    /* access modifiers changed from: private */
    public ArrayList<Float> mFlingRefreshRateChangeTimeOffset;
    /* access modifiers changed from: private */
    public ArrayList<Float> mFlingRefreshRateVsyncTime;
    /* access modifiers changed from: private */
    public int mFlingSupportRefreshRateCount;
    /* access modifiers changed from: private */
    public ArrayList<Integer> mFlingSupportedRefreshRate;
    private WeakReference<Window> mImeWindow;
    /* access modifiers changed from: private */
    public boolean mIsDataInited;
    private long mLastRefreshChangeTime;
    private float mLastTouchMovePointerY;
    /* access modifiers changed from: private */
    public boolean mMSyncSupportedByProcess;
    /* access modifiers changed from: private */
    public RefreshRateInfo mRefreshRateInfo;
    /* access modifiers changed from: private */
    public IRefreshRateEx mRefreshRatePolicyExt;
    private int mSplinePositionCount;
    private float mTouchDownPointerY;
    private long mTouchDownTime;
    private long mTouchDuration;
    private int mTouchScrollSpeed;
    private ArrayList<Float> mTouchScrollVelocityList;
    private VelocityTracker mVelocityTracker;
    private WorkerHandler mWorkerHandler;

    public RefreshRatePolicy() {
        this.mActiveRefreshScenario = null;
        this.mRefreshRateInfo = null;
        this.mWorkerHandler = null;
        this.mIsDataInited = false;
        this.mMSyncSupportedByProcess = true;
        this.mActivityHasVideoView = false;
        this.mRefreshRatePolicyExt = null;
        this.mCurrentMaxRefreshRate = -1;
        this.mTouchScrollSpeed = 0;
        this.mLastRefreshChangeTime = 0;
        this.mCurrentTouchState = -1;
        this.mVelocityTracker = null;
        this.mTouchDownTime = 0;
        this.mTouchDuration = 0;
        this.mTouchScrollVelocityList = new ArrayList<>(5);
        this.mRefreshRateInfo = new RefreshRateInfo();
        registerActivityListener();
        this.mWorkerHandler = new WorkerHandler(Looper.getMainLooper());
    }

    public void registerActivityListener() {
        ActivityInfo.getInstance().registerActivityListener(new ActivityInfo.ActivityChangeListener() {
            public void onChange(Context context) {
                LogUtil.mLogd(RefreshRatePolicy.TAG, "Activity Changed");
                RefreshRatePolicy.this.mActiveRefreshScenario = null;
                RefreshRatePolicy.this.mActivityHasVideoView = false;
                if (RefreshRatePolicy.this.mMSyncSupportedByProcess && context != null && (context instanceof Activity)) {
                    RefreshRatePolicy.this.mRefreshRateInfo.updateCurrentActivityName(context);
                    if (!RefreshRatePolicy.this.mIsDataInited) {
                        RefreshRatePolicy.this.mRefreshRateInfo.initHardwareSupportRefreshRate(context);
                        RefreshRatePolicy.this.mRefreshRateInfo.initMSync3SupportRefreshRate();
                        RefreshRatePolicy.this.mRefreshRateInfo.initPackageInfo(context);
                        RefreshRatePolicy refreshRatePolicy = RefreshRatePolicy.this;
                        refreshRatePolicy.mFlingSupportedRefreshRate = refreshRatePolicy.mRefreshRateInfo.getFlingSupportedRefreshRate();
                        RefreshRatePolicy refreshRatePolicy2 = RefreshRatePolicy.this;
                        refreshRatePolicy2.mFlingRefreshRateChangeGap = refreshRatePolicy2.mRefreshRateInfo.getFlingRefreshRateChangeGap();
                        RefreshRatePolicy refreshRatePolicy3 = RefreshRatePolicy.this;
                        refreshRatePolicy3.mFlingRefreshRateChangeTimeOffset = refreshRatePolicy3.mRefreshRateInfo.getFlingRefreshRateChangeTimeOffset();
                        RefreshRatePolicy refreshRatePolicy4 = RefreshRatePolicy.this;
                        refreshRatePolicy4.mFlingSupportRefreshRateCount = refreshRatePolicy4.mRefreshRateInfo.getFlingSupportedRefreshRateCount();
                        RefreshRatePolicy refreshRatePolicy5 = RefreshRatePolicy.this;
                        refreshRatePolicy5.mFlingRefreshRateVsyncTime = refreshRatePolicy5.mRefreshRateInfo.getFlingRefreshRateVSyncTime();
                        try {
                            RefreshRatePolicy.this.mClassLoader = new PathClassLoader("/system/framework/msync-lib.jar", context.getClassLoader());
                            RefreshRatePolicy.this.mRefreshRatePolicyExt = (IRefreshRateEx) Class.forName("com.mediatek.msync.RefreshRatePolicyExt", false, RefreshRatePolicy.this.mClassLoader).getConstructor(new Class[0]).newInstance(new Object[0]);
                        } catch (Exception unused) {
                            LogUtil.mLoge(RefreshRatePolicy.TAG, "msync-lib.jar not exits");
                        }
                        RefreshRatePolicy.this.mIsDataInited = true;
                    }
                }
            }
        });
    }

    public void setVeriableRefreshRateSupported(boolean z) {
        this.mMSyncSupportedByProcess = z;
    }

    class WorkerHandler extends Handler {
        WorkerHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            if (message.what == 0 && RefreshRatePolicy.this.mActiveRefreshScenario != null) {
                RefreshRatePolicy refreshRatePolicy = RefreshRatePolicy.this;
                refreshRatePolicy.updateRefreshRateWhenFling(1000, refreshRatePolicy.mActiveRefreshScenario);
            }
        }
    }

    public void dispatchScenario(RefreshRateScenario refreshRateScenario) {
        int scenarioAction = refreshRateScenario.getScenarioAction();
        LogUtil.mLogd(TAG, "dispatchScenario action = " + scenarioAction + " mCurrentTouchState = " + this.mCurrentTouchState);
        StringBuilder sb = new StringBuilder();
        sb.append("Dispatch Scenario Action=");
        sb.append(scenarioAction);
        LogUtil.traceBegin(sb.toString());
        if (scenarioAction != 0) {
            if (scenarioAction != 1) {
                if (scenarioAction != 2) {
                    if (scenarioAction != 3) {
                        LogUtil.mLoge(TAG, "RefreshRatePolicy dispatchScenario error");
                    } else {
                        onListScrollerInit(refreshRateScenario);
                    }
                } else if (this.mIsDataInited) {
                    onListFlingFinished(refreshRateScenario);
                } else {
                    return;
                }
            } else if (this.mIsDataInited) {
                onListFlingUpdate(refreshRateScenario);
            } else {
                return;
            }
        } else if (this.mIsDataInited) {
            onListFlingStart(refreshRateScenario);
        } else {
            return;
        }
        LogUtil.traceEnd();
    }

    public void dispatchEvent(EventScenario eventScenario) {
        int scenarioAction = eventScenario.getScenarioAction();
        LogUtil.mLogd(TAG, "dispatchEvent action = " + scenarioAction);
        LogUtil.traceBegin("Dispatch Event Action=" + scenarioAction);
        if (scenarioAction == 0 || scenarioAction == 1) {
            onViewEventUpdate(eventScenario);
            eventScenario.setVariableRefreshRateEnabled(true);
        } else {
            LogUtil.mLoge(TAG, "RefreshRatePolicy dispatchEvent error");
        }
        LogUtil.traceEnd();
    }

    private void onListScrollerInit(RefreshRateScenario refreshRateScenario) {
        refreshRateScenario.setCurrentFlingState(3).setVariableRefreshRateEnabled(Config.isVariableRefreshRateSupported()).setSmoothFlingEnabled(Config.isMSync3SmoothFlingEnabled()).setListScrollStateListening(true);
        if (Config.isMSync3SmoothFlingEnabled()) {
            refreshRateScenario.setRealSplinePosition(this.mRefreshRateInfo.getSmoothFlingSplinePosition());
            refreshRateScenario.setRealSplineTime(this.mRefreshRateInfo.getSmoothFlingSplineTime());
            this.mSplinePositionCount = this.mRefreshRateInfo.getSmoothFlingSplinePositionCount();
        } else {
            refreshRateScenario.setRealSplinePosition(refreshRateScenario.getOriginalSplinePosition());
            refreshRateScenario.setRealSplineTime(refreshRateScenario.getOriginalSplineTime());
            this.mSplinePositionCount = refreshRateScenario.getOriginalSplinePosition().length - 1;
        }
        LogUtil.mLogd(TAG, "onListScrollerInit action = SCROLL_INIT");
    }

    private void onListFlingStart(RefreshRateScenario refreshRateScenario) {
        LogUtil.mLogi(TAG, "List fling start");
        this.mActiveRefreshScenario = refreshRateScenario;
        float currentVelocity = refreshRateScenario.getCurrentVelocity();
        Util.getRefreshRate();
        refreshRateScenario.setTouchScrollEnabled(true);
        refreshRateScenario.setCurrentFlingState(0);
        int touchScrollState = getTouchScrollState();
        if (touchScrollState == -1 || Math.abs(currentVelocity) < 1000.0f) {
            LogUtil.mLogd(TAG, "Current refresh rate not match  Current device refresh rate = " + Util.getRefreshRate() + " Max refresh rate = " + this.mRefreshRateInfo.getMaxFlingSupportedRefreshRate());
            refreshRateScenario.setRefreshRateChangeEnabledWhenFling(false);
        } else {
            refreshRateScenario.setFlingRefreshRateChangeIndex(touchScrollState).setCurrentRefreshrate(this.mFlingSupportedRefreshRate.get(touchScrollState).intValue()).setRefreshRateChangeEnabledWhenFling(true);
            this.mCurrentMaxRefreshRate = this.mRefreshRateInfo.getMaxFlingSupportedRefreshRate();
            boostToMaxRefreshRate(refreshRateScenario, this.mFlingSupportedRefreshRate.get(touchScrollState).intValue());
        }
        if (currentVelocity != 0.0f) {
            refreshRateScenario.setCurrentVelocity(adjustVelocity(currentVelocity));
            int splineFlingDuration = getSplineFlingDuration(refreshRateScenario);
            Double valueOf = Double.valueOf(getSplineFlingDistance(refreshRateScenario));
            refreshRateScenario.setSplineDuration(splineFlingDuration).setSplineFlingDistance(valueOf.doubleValue()).setSplineDistance((int) (valueOf.doubleValue() * ((double) Math.signum(currentVelocity)))).setDistanceCoef(0.0f);
        }
        LogUtil.mLogd(TAG, "onListFlingStart action = FLING_START velocity = " + currentVelocity + " mSplineDuration = " + refreshRateScenario.getSplineDuration() + " mSplineFlingDistance = " + refreshRateScenario.getSplineFlingDistance() + " mSplineDistance = " + refreshRateScenario.getSplineDistance());
    }

    private float adjustVelocity(float f) {
        long uptimeMillis = SystemClock.uptimeMillis() - this.mTouchDownTime;
        float f2 = this.mTouchDownPointerY - this.mLastTouchMovePointerY;
        float f3 = (f2 / ((float) uptimeMillis)) * 1000.0f;
        float f4 = f / f3;
        LogUtil.mLogd(TAG, "adjustVelocity  velocity = " + f + " touchScrollTime = " + uptimeMillis + " deltaY = " + f2 + " result = " + f4);
        if (uptimeMillis >= 200 || Math.abs(f2) >= 400.0f || ((double) Math.abs(f4)) <= 2.5d) {
            return f;
        }
        return Math.signum(f) * ((float) (((double) f3) * 2.5d));
    }

    private void onListFlingUpdate(RefreshRateScenario refreshRateScenario) {
        float f;
        float f2;
        RefreshRateScenario refreshRateScenario2 = refreshRateScenario;
        refreshRateScenario2.setCurrentFlingState(1);
        long currentTime = refreshRateScenario.getCurrentTime();
        int splineDuration = refreshRateScenario.getSplineDuration();
        int splineDistance = refreshRateScenario.getSplineDistance();
        float[] realSplinePosition = refreshRateScenario.getRealSplinePosition();
        int flingRefreshRateChangeIndex = refreshRateScenario.getFlingRefreshRateChangeIndex();
        int currentRefreshrate = refreshRateScenario.getCurrentRefreshrate();
        float f3 = (float) splineDuration;
        float f4 = ((float) currentTime) / f3;
        int i = this.mSplinePositionCount;
        int i2 = (int) (((float) i) * f4);
        if (i2 < i) {
            float f5 = ((float) i2) / ((float) i);
            int i3 = i2 + 1;
            float f6 = ((float) i3) / ((float) i);
            float f7 = realSplinePosition[i2];
            f = (realSplinePosition[i3] - f7) / (f6 - f5);
            f2 = f7 + ((f4 - f5) * f);
        } else {
            f2 = 1.0f;
            f = 0.0f;
        }
        float f8 = (float) splineDistance;
        double d = (double) (f2 * f8);
        refreshRateScenario2.setCurrentDistance(d).setCurrentVelocity(((f * f8) / f3) * 1000.0f).setDistanceCoef(f2);
        LogUtil.mLogd(TAG, "onListFlingUpdate  flingRefreshRateChangeIndex = " + flingRefreshRateChangeIndex + " currentRefreshRate = " + currentRefreshrate + " distanceCoef = " + f2 + " currentDistance = " + d + " index = " + i2);
        if (refreshRateScenario.getRefreshRateChangeEnabledWhenFling() && flingRefreshRateChangeIndex < this.mFlingSupportRefreshRateCount - 1) {
            if ((refreshRateScenario.hasVideo() || this.mActivityHasVideoView) && this.mFlingSupportedRefreshRate.get(flingRefreshRateChangeIndex + 1).intValue() < this.mRefreshRateInfo.getVideoFloorRefreshRate()) {
                LogUtil.mLogd(TAG, "List with video, min support refresh rate is " + this.mRefreshRateInfo.getVideoFloorRefreshRate());
                return;
            }
            IRefreshRateEx iRefreshRateEx = this.mRefreshRatePolicyExt;
            if (iRefreshRateEx != null) {
                int currentRefreshrate2 = refreshRateScenario.getCurrentRefreshrate();
                int refreshRate = (int) Util.getRefreshRate();
                int intValue = this.mFlingSupportedRefreshRate.get(flingRefreshRateChangeIndex).intValue();
                double doubleValue = this.mFlingRefreshRateVsyncTime.get(flingRefreshRateChangeIndex).doubleValue();
                double doubleValue2 = this.mFlingRefreshRateChangeTimeOffset.get(flingRefreshRateChangeIndex).doubleValue();
                int i4 = this.mSplinePositionCount;
                String str = TAG;
                double calculateGap = iRefreshRateEx.calculateGap(currentTime, currentRefreshrate2, refreshRate, intValue, doubleValue, doubleValue2, splineDuration, splineDistance, i4, realSplinePosition);
                LogUtil.mLogd(str, "onListFlingUpdate stepGap = " + calculateGap);
                int i5 = flingRefreshRateChangeIndex;
                if (i5 < this.mFlingSupportRefreshRateCount && calculateGap <= ((double) this.mFlingRefreshRateChangeGap.get(i5).floatValue()) && calculateGap != -1.0d) {
                    updateRefreshRateWhenFling(this.mFlingSupportedRefreshRate.get(i5 + 1).intValue(), refreshRateScenario);
                }
            }
        }
    }

    private void onListFlingFinished(RefreshRateScenario refreshRateScenario) {
        if (refreshRateScenario.getCurrentFlingState() != 1) {
            refreshRateScenario.setCurrentFlingState(2);
            return;
        }
        refreshRateScenario.setLastFlingFinishTime(SystemClock.uptimeMillis());
        if (refreshRateScenario.getDistanceCoef() > FLING_STOP_PROGRESS_THRESHOLED) {
            updateRefreshRateWhenFling(1000, refreshRateScenario);
            refreshRateScenario.setTouchScrollEnabled(false);
            LogUtil.mLogd(TAG, "onListFlingFinished List stop by self");
        } else if (SystemClock.uptimeMillis() - refreshRateScenario.getLastTouchDownTime() < 150) {
            refreshRateScenario.setTouchScrollEnabled(true);
            LogUtil.mLogd(TAG, "onListFlingFinished List stop by touch event");
        } else {
            this.mWorkerHandler.removeMessages(0);
            refreshRateScenario.setTouchScrollEnabled(false);
            this.mWorkerHandler.sendEmptyMessageDelayed(0, 150);
            LogUtil.mLogd(TAG, "onListFlingFinished List stop by other reason");
        }
        refreshRateScenario.setCurrentFlingState(2).setFlingRefreshRateChangeIndex(0).setRefreshRateChangeEnabledWhenFling(false).setDistanceCoef(0.0f);
    }

    private void onViewEventUpdate(EventScenario eventScenario) {
        RefreshRateScenario refreshRateScenario = this.mActiveRefreshScenario;
        if (refreshRateScenario != null && refreshRateScenario.getCurrentFlingState() == 1) {
            this.mActiveRefreshScenario.setHasVideo(true);
            eventScenario.setIsMarked(true);
            this.mActivityHasVideoView = true;
        }
    }

    private double getSplineDeceleration(RefreshRateScenario refreshRateScenario) {
        return Math.log((double) ((this.mRefreshRateInfo.getInflextion() * Math.abs(refreshRateScenario.getCurrentVelocity())) / (refreshRateScenario.getFlingFriction() * refreshRateScenario.getPhysicalCoeff())));
    }

    private double getSplineFlingDistance(RefreshRateScenario refreshRateScenario) {
        double splineDeceleration = getSplineDeceleration(refreshRateScenario);
        float f = RefreshRateInfo.DECELERATION_RATE;
        double d = 1.0d;
        double d2 = ((double) f) - 1.0d;
        float abs = Math.abs(refreshRateScenario.getCurrentVelocity()) / this.mRefreshRateInfo.getMaximumVelocity();
        int i = this.mSplinePositionCount;
        int i2 = (int) (((float) i) * abs);
        if (i2 <= i) {
            i = i2;
        }
        double d3 = (double) (((1.0f - refreshRateScenario.getRealSplinePosition()[i]) * 3.5f) + 1.65f);
        if (Config.isMSync3SmoothFlingEnabled()) {
            d = d3;
        }
        LogUtil.mLogd(TAG, "getSplineFlingDistance tuningValue = " + d + " rate = " + abs);
        return ((double) refreshRateScenario.getFlingFriction()) * d * ((double) refreshRateScenario.getPhysicalCoeff()) * Math.exp((((double) f) / d2) * splineDeceleration);
    }

    private int getSplineFlingDuration(RefreshRateScenario refreshRateScenario) {
        double splineDeceleration = getSplineDeceleration(refreshRateScenario);
        double d = 1.0d;
        double d2 = ((double) RefreshRateInfo.DECELERATION_RATE) - 1.0d;
        float abs = Math.abs(refreshRateScenario.getCurrentVelocity()) / this.mRefreshRateInfo.getMaximumVelocity();
        int i = this.mSplinePositionCount;
        int i2 = (int) (((float) i) * abs);
        if (i2 <= i) {
            i = i2;
        }
        double d3 = (double) (((1.0f - refreshRateScenario.getRealSplinePosition()[i]) * 9.0f) + 1.65f);
        if (Config.isMSync3SmoothFlingEnabled()) {
            d = d3;
        }
        LogUtil.mLogd(TAG, "getSplineFlingDuration tuningValue = " + d + " rate = " + abs);
        return (int) (d * 1000.0d * Math.exp(splineDeceleration / d2));
    }

    /* access modifiers changed from: private */
    public void updateRefreshRateWhenFling(int i, RefreshRateScenario refreshRateScenario) {
        LogUtil.mLogd(TAG, "updateRefreshRateWhenFling change oldRefreshRate = " + refreshRateScenario.getCurrentRefreshrate() + " New RefreshRate = " + i);
        if (refreshRateScenario.getCurrentRefreshrate() != i && updateRefreshInternal(refreshRateScenario, i, 0, 0)) {
            refreshRateScenario.setCurrentRefreshrate(i);
            refreshRateScenario.increaseFlingRefreshRateChangeIndex();
        }
    }

    private void boostToMaxRefreshRate(RefreshRateScenario refreshRateScenario, int i) {
        LogUtil.mLogd(TAG, "boostToMaxRefreshRate change oldRefreshRate = " + refreshRateScenario.getCurrentRefreshrate() + " New RefreshRate = " + i);
        updateRefreshInternal(refreshRateScenario, i, 0, 0);
    }

    public void onTouchEvent(MotionEvent motionEvent) {
        if (this.mVelocityTracker == null) {
            this.mVelocityTracker = VelocityTracker.obtain();
        }
        int actionMasked = motionEvent.getActionMasked();
        if (actionMasked != 0) {
            if (actionMasked != 1) {
                if (actionMasked == 2) {
                    this.mVelocityTracker.addMovement(motionEvent);
                    this.mVelocityTracker.computeCurrentVelocity(100);
                    this.mTouchDuration = SystemClock.uptimeMillis() - this.mTouchDownTime;
                    onVelocityChange(this.mVelocityTracker.getYVelocity(), this.mTouchDuration);
                    this.mCurrentTouchState = 1;
                    this.mLastTouchMovePointerY = motionEvent.getY();
                    return;
                } else if (actionMasked != 3) {
                    return;
                }
            }
            this.mVelocityTracker.addMovement(motionEvent);
            this.mVelocityTracker.computeCurrentVelocity(100);
            onScrollStateChange(1, this.mVelocityTracker.getYVelocity());
            this.mCurrentTouchState = 2;
            this.mTouchScrollSpeed = -1;
            this.mLastTouchMovePointerY = motionEvent.getY();
            return;
        }
        this.mVelocityTracker.clear();
        this.mVelocityTracker.addMovement(motionEvent);
        this.mTouchDownTime = SystemClock.uptimeMillis();
        this.mTouchDownPointerY = motionEvent.getY();
        this.mLastTouchMovePointerY = 0.0f;
        onScrollStateChange(0, this.mVelocityTracker.getYVelocity());
        this.mCurrentTouchState = 0;
        this.mTouchScrollSpeed = 0;
    }

    public void onVelocityChange(float f, long j) {
        if (this.mActiveRefreshScenario != null) {
            if (this.mTouchScrollVelocityList.size() >= 5) {
                this.mTouchScrollVelocityList.remove(0);
                this.mTouchScrollVelocityList.add(Float.valueOf(Math.abs(f)));
                if (j > 300 && j - this.mLastRefreshChangeTime > 200) {
                    float calculateAverage = calculateAverage(this.mTouchScrollVelocityList);
                    if (calculateAverage <= ((float) this.mRefreshRateInfo.getTouchScrollVelocityThreshold()) && this.mTouchScrollSpeed == 0 && this.mActiveRefreshScenario.getTouchScrollEnabled()) {
                        updateRefreshRateWhenScroll(this.mActiveRefreshScenario, this.mRefreshRateInfo.getSlowScrollRefreshRate());
                        this.mTouchScrollSpeed = 1;
                        this.mLastRefreshChangeTime = j;
                        this.mActiveRefreshScenario.setCurrentRefreshrate(this.mRefreshRateInfo.getSlowScrollRefreshRate());
                        LogUtil.mLogi(TAG, "Touch scroll speed change : High -> Low");
                    } else if (calculateAverage > ((float) this.mRefreshRateInfo.getTouchScrollVelocityThreshold())) {
                        updateRefreshRateWhenScroll(this.mActiveRefreshScenario, this.mRefreshRateInfo.getMaxFlingSupportedRefreshRate());
                        this.mTouchScrollSpeed = 0;
                        this.mActiveRefreshScenario.setCurrentRefreshrate(this.mRefreshRateInfo.getMaxFlingSupportedRefreshRate());
                        this.mLastRefreshChangeTime = j;
                        LogUtil.mLogi(TAG, "Touch scroll speed change : Low -> High");
                    }
                }
            } else {
                this.mTouchScrollVelocityList.add(Float.valueOf(Math.abs(f)));
            }
        }
    }

    private float calculateAverage(ArrayList<Float> arrayList) {
        Iterator<Float> it = arrayList.iterator();
        float f = 0.0f;
        while (it.hasNext()) {
            f += it.next().floatValue();
        }
        return f / 5.0f;
    }

    private void updateRefreshRateWhenScroll(RefreshRateScenario refreshRateScenario, int i) {
        LogUtil.mLogd(TAG, "updateRefreshRateWhenScroll oldRefreshRate = " + refreshRateScenario.getCurrentRefreshrate() + " New RefreshRate = " + i);
        if (updateRefreshInternal(refreshRateScenario, i, 0, 0)) {
            refreshRateScenario.setCurrentRefreshrate(i);
        }
    }

    public void onScrollStateChange(int i, float f) {
        if (this.mActiveRefreshScenario != null) {
            LogUtil.mLogd(TAG, "onScrollStateChange velocity = " + f + " scrollState = " + i);
            if (i == 0) {
                this.mActiveRefreshScenario.setLastTouchDownTime(SystemClock.uptimeMillis());
                if (SystemClock.uptimeMillis() - this.mActiveRefreshScenario.getLastFlingFinishTime() < 150) {
                    this.mActiveRefreshScenario.setTouchScrollEnabled(true);
                    LogUtil.mLogd(TAG, "onScrollStateChange List stop by touch event");
                } else {
                    this.mActiveRefreshScenario.setTouchScrollEnabled(false);
                    LogUtil.mLogd(TAG, "onScrollStateChange List stop by other reason");
                }
                this.mWorkerHandler.removeMessages(0);
                LogUtil.mLogd(TAG, "onScrollStateChange List touch scroll state = " + this.mActiveRefreshScenario.getTouchScrollEnabled());
                this.mLastRefreshChangeTime = 0;
                this.mTouchScrollSpeed = 0;
                updateScrollAction(this.mActiveRefreshScenario, 1001);
            } else if ((i == 1 || i == 3) && Math.abs(f) <= 100.0f) {
                updateScrollAction(this.mActiveRefreshScenario, 1000);
                this.mActiveRefreshScenario.setTouchScrollEnabled(false);
                this.mActiveRefreshScenario = null;
            }
        }
    }

    private void updateScrollAction(RefreshRateScenario refreshRateScenario, int i) {
        updateRefreshInternal(refreshRateScenario, i, 0, 0);
    }

    private boolean updateRefreshInternal(RefreshRateScenario refreshRateScenario, int i, int i2, int i3) {
        LogUtil.mLogd(TAG, "updateRefreshInternal RefreshRate = " + i);
        Context scenarioContext = refreshRateScenario.getScenarioContext();
        if (scenarioContext == null && (scenarioContext = ActivityInfo.getInstance().getContext()) == null) {
            return false;
        }
        if (scenarioContext instanceof Activity) {
            try {
                ViewRootImpl viewRootImpl = ((Activity) scenarioContext).getWindow().getDecorView().getViewRootImpl();
                if (viewRootImpl != null) {
                    SurfaceControl surfaceControl = viewRootImpl.getSurfaceControl();
                    if (surfaceControl.isValid()) {
                        LogUtil.mLogd(TAG, "Update RefreshRate = " + i + " scenarioAction = " + i2 + " scenarioType = " + i3);
                        LogUtil.traceBegin("Refreshrate Change =" + i + " action = " + i2 + " type = " + i3);
                        WindowManagerGlobal.getWindowSession().setRefreshRate(surfaceControl, (float) i, i2, i3, this.mRefreshRateInfo.getCurrentActivityName(), this.mRefreshRateInfo.getPackageName());
                        LogUtil.traceEnd();
                        return true;
                    }
                    LogUtil.mLogd(TAG, "Refreshrate change failed : SurfaceControl is invalid");
                } else {
                    LogUtil.mLogd(TAG, "Refreshrate change failed : ViewRootImpl == null ");
                }
            } catch (RemoteException e) {
                LogUtil.mLogd(TAG, "Refreshrate change failed, e = " + e.toString());
            }
        } else {
            LogUtil.mLogd(TAG, "Refreshrate change failed : ActivityContext == null");
        }
        return false;
    }

    private int getTouchScrollState() {
        int refreshRate = (int) Util.getRefreshRate();
        if (refreshRate == this.mRefreshRateInfo.getMaxFlingSupportedRefreshRate()) {
            return 0;
        }
        return refreshRate == this.mRefreshRateInfo.getSlowScrollRefreshRate() ? 1 : -1;
    }

    public void onVoiceDialogEvent(boolean z) {
        LogUtil.mLogi(TAG, "Voice Dialog Show = " + z);
        if (z) {
            updateVoiceDialogRefreshRate(1);
        } else {
            updateVoiceDialogRefreshRate(2);
        }
    }

    private void updateVoiceDialogRefreshRate(int i) {
        Window window;
        LogUtil.mLogd(TAG, "updateVoiceDialogRefreshRate action = " + i);
        LogUtil.traceBegin("Voice Action=" + i);
        Context context = ActivityInfo.getInstance().getContext();
        if (!(context == null || !(context instanceof Activity) || (window = ((Activity) context).getWindow()) == null)) {
            WindowManager.LayoutParams attributes = window.getAttributes();
            attributes.mMSyncScenarioType = 2;
            attributes.mMSyncScenarioAction = i;
            window.setAttributes(attributes);
        }
        LogUtil.traceEnd();
    }

    public void onIMEInit(Window window) {
        if (window != null) {
            WeakReference<Window> weakReference = this.mImeWindow;
            if (weakReference != null) {
                weakReference.clear();
            }
            this.mImeWindow = new WeakReference<>(window);
            LogUtil.mLogd(TAG, "ime init");
        }
    }

    private Window getIMEWindow() {
        WeakReference<Window> weakReference = this.mImeWindow;
        if (weakReference == null) {
            return null;
        }
        return (Window) weakReference.get();
    }

    public void onIMEVisibilityChange(boolean z) {
        Window iMEWindow = getIMEWindow();
        if (iMEWindow != null) {
            LogUtil.mLogi(TAG, "IME show = " + z);
            if (z) {
                updateIMERefreshRate(1, iMEWindow);
            } else {
                updateIMERefreshRate(2, iMEWindow);
            }
        }
    }

    private void updateIMERefreshRate(int i, Window window) {
        LogUtil.mLogd(TAG, "updateIMERefreshRate action = " + i);
        LogUtil.traceBegin("Refreshrate Change : IME");
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.mMSyncScenarioType = 1;
        attributes.mMSyncScenarioAction = i;
        window.setAttributes(attributes);
        LogUtil.traceEnd();
    }
}
