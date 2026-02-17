package com.mediatek.boostfwk.identify.scroll;

import android.content.Context;
import android.os.Process;
import android.os.Trace;
import android.view.GestureDetector;
import android.view.MotionEvent;
import com.mediatek.boostfwk.identify.BaseIdentify;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.info.ScrollState;
import com.mediatek.boostfwk.policy.frame.ScrollingFramePrefetcher;
import com.mediatek.boostfwk.policy.scroll.ScrollPolicy;
import com.mediatek.boostfwk.policy.touch.TouchPolicy;
import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.scenario.scroll.ScrollScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.TasksUtil;
import com.mediatek.boostfwk.utils.Util;
import java.util.ArrayList;
import java.util.List;

public class ScrollIdentify extends BaseIdentify {
    private static final float DISPLAY_RATE_60 = 60.0f;
    protected static final float MOVE_DISTANCE = 50.0f;
    public static final int NO_CHECKED_STATUS = -1;
    private static final Object SCROLL_LOCK = new Object();
    private static final String TAG = "ScrollIdentify";
    private static Object lock = new Object();
    /* access modifiers changed from: private */
    public static int mIsSpecialPageDesign = -1;
    private static final boolean sAUTO_SWITCH_FPSGO = true;
    private static ScrollIdentify sInstance;
    private final int APP_TYPE_GAME = 1;
    private final int APP_TYPE_MAP = 3;
    private final int APP_TYPE_NORMAL = 6;
    private final int APP_TYPE_READER = 2;
    private final int APP_TYPE_STRICT_MODE = 5;
    private final int APP_TYPE_SYSTEM = 4;
    protected final int FLING_DISTANCE_HORIZONTAL_DP = 48;
    protected final float FLING_DISTANCE_VERTICAL_DP = 70.0f;
    protected final int FLING_SPEED_HORIZONTAL_DP = 400;
    protected final int FLING_SPEED_VERTICAL_DP = 350;
    private ActivityInfo.ActivityChangeListener activityChangeListener = null;
    /* access modifiers changed from: private */
    public ActivityInfo mActivityInfo = null;
    private int mApplicationType = -1;
    private MotionEvent mCurrentMotionEvent = null;
    private String mDispatcherPkgName = null;
    private long mFrameIntervalMs = 0;
    private GestureDetector mGestureDetector;
    /* access modifiers changed from: private */
    public boolean mHaveMoveEvent = false;
    private String mInputPkgName = "";
    private boolean mIsInput = false;
    private boolean mIsInputLockAcquired = false;
    private boolean mIsScrollLockAcquired = false;
    private boolean mIsScrolling = false;
    private boolean mIsSystemApp = false;
    private boolean mIsUserTouched = false;
    private boolean mLastScrollerEnd = false;
    private long mLimitVsyncTime = 0;
    private float mRefreshRate = 0.0f;
    private List<TouchEventListener> mTouchEventListeners = new ArrayList();
    private TouchPolicy mTouchPolicy = null;
    /* access modifiers changed from: private */
    public float minTouchDistanceHorizontal = -1.0f;
    /* access modifiers changed from: private */
    public float minTouchDistanceVertical = -1.0f;
    /* access modifiers changed from: private */
    public float minVelocityHorizontal = -1.0f;
    /* access modifiers changed from: private */
    public float minVelocityVertical = -1.0f;
    private Object scrollerLock = null;

    public interface TouchEventListener {
        void onTouchEvent(MotionEvent motionEvent);
    }

    public static ScrollIdentify getInstance() {
        if (sInstance == null) {
            synchronized (lock) {
                if (sInstance == null) {
                    sInstance = new ScrollIdentify();
                }
            }
        }
        return sInstance;
    }

    private ScrollIdentify() {
    }

    public boolean dispatchScenario(BasicScenario basicScenario) {
        if (Config.isBoostFwkScrollIdentify() && basicScenario != null) {
            ScrollScenario scrollScenario = (ScrollScenario) basicScenario;
            int scenarioAction = scrollScenario.getScenarioAction();
            int boostStatus = scrollScenario.getBoostStatus();
            MotionEvent scenarioInputEvent = scrollScenario.getScenarioInputEvent();
            Object scenarioObj = scrollScenario.getScenarioObj();
            Context scenarioContext = scrollScenario.getScenarioContext() != null ? scrollScenario.getScenarioContext() : null;
            if (scenarioContext == null) {
                return false;
            }
            if (this.mActivityInfo == null) {
                this.mActivityInfo = ActivityInfo.getInstance();
            }
            String packageName = this.mActivityInfo.getPackageName();
            if (packageName == null) {
                packageName = scenarioContext.getPackageName();
            }
            if (packageName == null) {
                return false;
            }
            String str = this.mDispatcherPkgName;
            if (str == null || !str.equals(packageName)) {
                this.mApplicationType = -1;
            }
            if (this.mApplicationType == -1) {
                checkAppType(packageName);
            }
            int i = this.mApplicationType;
            if (i == 1 || i == 4 || i == 5) {
                this.mDispatcherPkgName = packageName;
            } else {
                if (this.mGestureDetector == null) {
                    try {
                        this.mGestureDetector = new GestureDetector(scenarioContext, new ScrollGestureListener());
                    } catch (Exception unused) {
                        if (Config.isBoostFwkLogEnable()) {
                            LogUtil.mLoge(TAG, "layout not inflate, cannot create GestureDetector,try to next time.");
                        }
                        this.mGestureDetector = null;
                        return false;
                    }
                }
                updateRefreshRate();
                this.mDispatcherPkgName = packageName;
                if (Config.isBoostFwkLogEnable()) {
                    LogUtil.mLogd(TAG, packageName + ", Scroll action dispatcher to = " + scenarioAction + " status = " + boostStatus + ", viewContext = " + scenarioContext);
                }
                scrollScenario.setSFPEnable(ScrollingFramePrefetcher.PRE_ANIM_ENABLE);
                if (scenarioAction != 0) {
                    if (scenarioAction == 1) {
                        inputDrawCheck(boostStatus, packageName);
                    } else if (scenarioAction == 2) {
                        inertialScrollCheck(boostStatus, packageName, scenarioObj);
                    } else if (scenarioAction != 3) {
                        LogUtil.mLogw(TAG, "Not found dispatcher scroll action.");
                    } else if (this.mHaveMoveEvent) {
                        if (Config.isBoostFwkLogEnable()) {
                            LogUtil.mLogd(TAG, "using scroller when HORIZONTAL scroll");
                        }
                        inertialScrollCheck(-2, packageName, scenarioObj);
                    }
                } else if (scenarioInputEvent != null) {
                    inputEventCheck(boostStatus, scenarioInputEvent);
                }
                return true;
            }
        }
        return false;
    }

    private void updateRefreshRate() {
        float refreshRate = ScrollState.getRefreshRate();
        if (refreshRate != this.mRefreshRate) {
            this.mRefreshRate = refreshRate;
            this.mFrameIntervalMs = (long) (1000.0f / refreshRate);
        }
    }

    public boolean disableForSpecialRate() {
        boolean z = Config.isBoostFwkScrollIdentifyOn60hz() && this.mRefreshRate == DISPLAY_RATE_60;
        if (Config.isBoostFwkLogEnable() && z) {
            LogUtil.mLogd(TAG, "filter specila rate when scrolling: " + this.mRefreshRate);
        }
        return z;
    }

    class ScrollGestureListener extends GestureDetector.SimpleOnGestureListener {
        ScrollGestureListener() {
        }

        public boolean onDown(MotionEvent motionEvent) {
            ScrollingFramePrefetcher.getInstance().disableAndLockSFP(true);
            return true;
        }

        public boolean onScroll(MotionEvent motionEvent, MotionEvent motionEvent2, float f, float f2) {
            if (motionEvent == null || motionEvent2 == null) {
                return false;
            }
            float abs = Math.abs(motionEvent.getX() - motionEvent2.getX());
            float abs2 = Math.abs(motionEvent.getY() - motionEvent2.getY());
            if (abs > 50.0f || abs2 > 50.0f) {
                ScrollIdentify.this.checkSpecialPageType();
                if (Config.isBoostFwkLogEnable()) {
                    LogUtil.mLogd(ScrollIdentify.TAG, "mIsSpecialPageDesign = " + ScrollIdentify.mIsSpecialPageDesign);
                }
                if (ScrollIdentify.this.mActivityInfo.isPage(64)) {
                    return false;
                }
                if (Config.isBoostFwkLogEnable()) {
                    StringBuilder sb = new StringBuilder();
                    sb.append("onScroll - ");
                    sb.append(abs > abs2 ? "horizontal" : "vertical");
                    LogUtil.mLogd(ScrollIdentify.TAG, sb.toString());
                }
                ScrollIdentify.this.mHaveMoveEvent = true;
                ScrollIdentify.this.sbeHint(0, "Boost when move");
            }
            return true;
        }

        public boolean onFling(MotionEvent motionEvent, MotionEvent motionEvent2, float f, float f2) {
            if (motionEvent == null || motionEvent2 == null || ScrollIdentify.this.mActivityInfo.isPage(64)) {
                return false;
            }
            float abs = Math.abs(motionEvent2.getX() - motionEvent.getX());
            float abs2 = Math.abs(motionEvent2.getY() - motionEvent.getY());
            if (Config.isBoostFwkLogEnable()) {
                LogUtil.mLogd(ScrollIdentify.TAG, "onFling --> distanceX: " + abs + ", Math.abs(velocityX):" + Math.abs(f) + ", distanceY: " + abs2 + ", Math.abs(velocityY): " + Math.abs(f2));
            }
            LogUtil.mLogi(ScrollIdentify.TAG, "on fling");
            ScrollIdentify.this.initMinValuesIfNeeded();
            if (abs > ScrollIdentify.this.minTouchDistanceHorizontal && Math.abs(f) > ScrollIdentify.this.minVelocityHorizontal && abs * 0.5f > abs2) {
                ScrollIdentify.this.sbeHint(3, "onFling Boost when FLING_HORIZONTAL");
                return true;
            } else if (abs2 <= ScrollIdentify.this.minTouchDistanceVertical || Math.abs(f2) <= ScrollIdentify.this.minVelocityVertical) {
                return true;
            } else {
                ScrollIdentify.this.sbeHint(2, "onFling Boost when FLING_VERTICAL");
                return true;
            }
        }
    }

    /* access modifiers changed from: private */
    public void initMinValuesIfNeeded() {
        if (this.minVelocityHorizontal == -1.0f || this.minTouchDistanceHorizontal == -1.0f || this.minTouchDistanceVertical == -1.0f || this.minVelocityVertical == -1.0f) {
            float density = this.mActivityInfo.getDensity();
            int i = (density > 0.0f ? 1 : (density == 0.0f ? 0 : -1));
            this.minVelocityHorizontal = i > 0 ? 400.0f * density : 1200.0f;
            this.minTouchDistanceHorizontal = i > 0 ? 48.0f * density : 150.0f;
            this.minVelocityVertical = i > 0 ? 350.0f * density : 1000.0f;
            this.minTouchDistanceVertical = i > 0 ? 70.0f * density : 200.0f;
            if (Config.isBoostFwkLogEnable()) {
                LogUtil.mLogd(TAG, "onFling density=" + density + " minTouchDistanceVertical=" + this.minTouchDistanceVertical + " minVelocityVertical=" + this.minVelocityVertical + " minVelocityHorizontal=" + this.minVelocityHorizontal + "minTouchDistanceHorizontal=" + this.minTouchDistanceHorizontal);
            }
        }
    }

    private void inputEventCheck(int i, MotionEvent motionEvent) {
        int actionMasked;
        if (boostBeginEndCheck(i)) {
            this.mCurrentMotionEvent = motionEvent.copy();
            if (motionEvent.getActionMasked() == 0) {
                this.mIsUserTouched = true;
                return;
            }
            return;
        }
        int actionMasked2 = motionEvent.getActionMasked();
        MotionEvent motionEvent2 = this.mCurrentMotionEvent;
        if (!(motionEvent2 == null || actionMasked2 == (actionMasked = motionEvent2.getActionMasked()) || actionMasked2 != 3)) {
            motionEvent = this.mCurrentMotionEvent;
            actionMasked2 = actionMasked;
        }
        if (actionMasked2 == 0) {
            this.mLastScrollerEnd = false;
            if (this.mIsScrollLockAcquired && this.scrollerLock != null) {
                this.scrollerLock = null;
                this.mIsScrollLockAcquired = false;
            }
            this.mIsUserTouched = true;
        } else if (actionMasked2 == 1 || actionMasked2 == 3) {
            if (Config.isBoostFwkLogEnable()) {
                LogUtil.mLogd(TAG, "touch up/cancel ");
            }
            if (this.mHaveMoveEvent) {
                this.mHaveMoveEvent = false;
                sbeHint(1, "Boost when up/cancel " + actionMasked2);
            }
            this.mIsInputLockAcquired = false;
            ScrollingFramePrefetcher.getInstance().disableAndLockSFP(false);
        }
        GestureDetector gestureDetector = this.mGestureDetector;
        if (gestureDetector != null) {
            gestureDetector.onTouchEvent(motionEvent);
        }
        if (this.mTouchPolicy == null) {
            this.mTouchPolicy = TouchPolicy.getInstance();
        }
        for (TouchEventListener onTouchEvent : this.mTouchEventListeners) {
            onTouchEvent.onTouchEvent(motionEvent);
        }
        if (actionMasked2 == 1 || actionMasked2 == 3) {
            this.mCurrentMotionEvent = null;
        }
    }

    private void inputDrawCheck(int i, String str) {
        if (this.mLastScrollerEnd || (this.mHaveMoveEvent && !this.mIsInputLockAcquired)) {
            this.mLimitVsyncTime = this.mFrameIntervalMs >> 1;
            this.mIsInput = boostBeginEndCheck(i);
            this.mInputPkgName = str;
            if (Config.isBoostFwkLogEnable()) {
                LogUtil.mLogd(TAG, "Vendor::inputDrawCheck begin, pkgName = " + str + ", refresh rate = " + this.mRefreshRate + ", mFrameIntervalMs = " + this.mFrameIntervalMs);
            }
            this.mIsInputLockAcquired = true;
            this.mIsUserTouched = true;
        }
    }

    public void inertialScrollCheck(int i, String str, Object obj) {
        if (!this.mIsUserTouched || this.mActivityInfo.isPage(128)) {
            if (Config.isBoostFwkLogEnable()) {
                LogUtil.mLogd(TAG, "inertialScrollCheck mIsUserTouched=" + this.mIsUserTouched + " mIsSpecialPageDesign=" + mIsSpecialPageDesign);
            }
        } else if (i == -2) {
            ScrollPolicy.getInstance().switchToFPSGo(true);
            this.mIsScrollLockAcquired = false;
        } else {
            if (Config.isBoostFwkLogEnable()) {
                LogUtil.mLogd(TAG, "inertialScrollCheck action=" + i + " pkgName=" + str + " obj=" + obj + " " + this.scrollerLock);
            }
            boolean boostBeginEndCheck = boostBeginEndCheck(i);
            if (checkScroller(boostBeginEndCheck, obj)) {
                boolean z = this.mIsScrollLockAcquired;
                if (!z && boostBeginEndCheck) {
                    inertialScrollHint(true, str);
                    this.mIsScrollLockAcquired = true;
                } else if (z && !boostBeginEndCheck) {
                    inertialScrollHint(false, str);
                    this.mIsScrollLockAcquired = false;
                }
            }
        }
    }

    private void inertialScrollHint(boolean z, String str) {
        if (this.mIsInput || !this.mInputPkgName.equals("") || this.mInputPkgName.equals(str) || mIsSpecialPageDesign != 1) {
            ScrollPolicy.getInstance().switchToFPSGo(z);
            if (LogUtil.DEBUG) {
                StringBuilder sb = new StringBuilder();
                sb.append("update state to ");
                sb.append(z ? "fling" : "finish");
                LogUtil.mLogd(TAG, sb.toString());
            }
            ScrollState.setFling(z);
            ScrollingFramePrefetcher.getInstance().setFling(z);
            ScrollPolicy.getInstance().releaseTargetFPS(z);
            resetInputFlag(!z);
            return;
        }
        resetInputFlag(true);
    }

    private void resetInputFlag(boolean z) {
        if (z) {
            this.mIsInput = false;
            this.mInputPkgName = "";
            this.mIsUserTouched = false;
        }
        this.mLastScrollerEnd = z;
    }

    private boolean boostBeginEndCheck(int i) {
        if (i == 0) {
            return true;
        }
        if (i != 1) {
            LogUtil.mLoge(TAG, "Unknown define action inputed, exit now.");
        }
        return false;
    }

    /* access modifiers changed from: private */
    public void checkSpecialPageType() {
        int pageType = this.mActivityInfo.getPageType();
        mIsSpecialPageDesign = pageType;
        if (pageType == 2 || pageType == 32 || pageType == 64) {
            this.mIsInputLockAcquired = true;
        }
    }

    private void checkAppType(String str) {
        String str2;
        if (TasksUtil.isAPPInStrictMode(str)) {
            this.mApplicationType = 5;
            str2 = "APP_TYPE_STRICT_MODE";
        } else if (TasksUtil.isGameAPP(str)) {
            this.mApplicationType = 1;
            str2 = "APP_TYPE_GAME";
        } else if (isSystemApp(str)) {
            this.mApplicationType = 4;
            str2 = "APP_TYPE_SYSTEM";
        } else {
            this.mApplicationType = 6;
            str2 = "APP_TYPE_NORMAL";
        }
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "onScroll -- " + str2);
        }
    }

    private boolean isSystemApp(String str) {
        if (Config.getBoostFwkVersion() > 1) {
            if (Config.SYSTEM_PACKAGE_ARRAY.contains(str) || "system_server".equals(Process.myProcessName())) {
                return true;
            }
            return false;
        } else if (!str.contains("android") || !checkSystemAPP(str)) {
            return false;
        } else {
            return true;
        }
    }

    private boolean checkScroller(boolean z, Object obj) {
        if (obj == null) {
            return false;
        }
        if (!z) {
            Object obj2 = this.scrollerLock;
            if (obj2 != null && obj2 == obj) {
                this.scrollerLock = null;
                return true;
            }
        } else if (this.scrollerLock == null) {
            this.scrollerLock = obj;
            return true;
        }
        return false;
    }

    private boolean checkSystemAPP(String str) {
        String str2 = this.mDispatcherPkgName;
        if (str2 == null && str2 != str) {
            this.mIsSystemApp = Util.isSystemApp(str);
        }
        return this.mIsSystemApp;
    }

    /* access modifiers changed from: private */
    public void sbeHint(int i, String str) {
        int i2;
        if (Config.isBoostFwkLogEnable() && str != null) {
            LogUtil.mLogd(TAG, "step=" + i + " " + str);
        }
        if ((i == 2 || i == 3) && (i2 = mIsSpecialPageDesign) != 0 && i2 != 128) {
            ScrollPolicy.getInstance().scrollHint(i, mIsSpecialPageDesign);
        } else if (this.mIsInputLockAcquired) {
            ScrollPolicy.getInstance().scrollHint(i, mIsSpecialPageDesign);
        }
    }

    public boolean isScroll() {
        boolean z;
        synchronized (SCROLL_LOCK) {
            z = this.mIsScrolling;
        }
        return z;
    }

    public void setScrolling(boolean z, String str) {
        synchronized (SCROLL_LOCK) {
            this.mIsScrolling = z;
            if (Config.isBoostFwkLogEnable()) {
                Trace.traceBegin(8, str + " curScrollingState=" + String.valueOf(this.mIsScrolling));
                Trace.traceEnd(8);
            }
        }
    }

    public void registerTouchEventListener(TouchEventListener touchEventListener) {
        if (touchEventListener != null) {
            this.mTouchEventListeners.add(touchEventListener);
        }
    }
}
