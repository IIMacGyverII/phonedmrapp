package com.mediatek.view.impl;

import android.icu.text.SimpleDateFormat;
import android.os.SystemProperties;
import android.util.Log;
import android.view.InputEvent;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.ViewRootImpl;
import com.mediatek.view.ViewDebugManager;
import java.util.Date;
import java.util.HashMap;

public class ViewDebugManagerImpl extends ViewDebugManager {
    private static final String DATE_FORMAT_STRING = "yyyyMMdd_hhmmss";
    private static final int DBG_APP_DRAWING_MODE = SystemProperties.getInt("mtk_ro.mtk_dbg_app_drawing_mode", 0);
    private static final int DBG_APP_DRAWING_MODE_FORCE_HWLAYER = 4;
    private static final int DBG_APP_DRAWING_MODE_FORCE_HWUI = 1;
    private static final int DBG_APP_DRAWING_MODE_FORCE_SW = 2;
    private static final int DBG_APP_DRAWING_MODE_FORCE_SWLAYER = 8;
    private static final int DBG_APP_DRAWING_MODE_NOT_SET = 0;
    static final boolean DBG_APP_FAST_LAUNCH_ENHANCE;
    static final boolean DBG_APP_LAUNCH_ENHANCE = true;
    private static final boolean DBG_TRANSP = SystemProperties.getBoolean("mtk_d.view.transparentRegion", false);
    private static final int DEBUG_CHOREOGRAPHER_FRAMES_FLAG = 536870912;
    private static final int DEBUG_CHOREOGRAPHER_JANK_FLAG = 268435456;
    private static final int DEBUG_CONFIGURATION_FLAG = 256;
    private static final int DEBUG_DEFAULT_FLAG = 512;
    private static final int DEBUG_DIALOG_FLAG = 8;
    private static final int DEBUG_DRAW_FLAG = 2;
    private static final int DEBUG_ENABLE_ALL_FLAG = 1;
    private static final int DEBUG_FOCUS_FLAG = 16777216;
    private static final int DEBUG_FPS_FLAG = 1024;
    private static final int DEBUG_HWUI_FLAG = 2048;
    private static final int DEBUG_IME_ANR_FLAG = 32768;
    private static final int DEBUG_IMF_FLAG = 128;
    private static final int DEBUG_INPUT_FLAG = 4096;
    private static final int DEBUG_INPUT_RESIZE_FLAG = 16;
    private static final int DEBUG_INPUT_STAGES_FLAG = 4194304;
    private static final int DEBUG_INVALIDATE_FLAG = 262144;
    private static final int DEBUG_KEEP_SCREEN_ON_FLAG = 8388608;
    private static final int DEBUG_KEY_FLAG = 8192;
    private static final int DEBUG_LAYOUT_FLAG = 4;
    private static final int DEBUG_LIFECYCLE_FLAG = 65536;
    private static final int DEBUG_MET_TRACE_FLAG = 1073741824;
    private static final int DEBUG_MOTION_FLAG = 16384;
    private static final int DEBUG_ORIENTATION_FLAG = 32;
    private static final int DEBUG_REQUESTLAYOUT_FLAG = 131072;
    private static final int DEBUG_SCHEDULETRAVERSALS_FLAG = 524288;
    private static final int DEBUG_SYSTRACE_DRAW_FLAG = 33554432;
    private static final int DEBUG_SYSTRACE_LAYOUT_FLAG = 134217728;
    private static final int DEBUG_SYSTRACE_MEASURE_FLAG = 67108864;
    private static final int DEBUG_TOUCHMODE_FLAG = 1048576;
    private static final int DEBUG_TOUCH_FLAG = 2097152;
    private static final int DEBUG_TRACKBALL_FLAG = 64;
    private static final String DUMP_IMAGE_FORMAT = ".png";
    private static final String DUMP_IMAGE_PTAH = "/data/dump/";
    public static final int INPUT_TIMEOUT = 6000;
    private static final int LOG_DISABLED = 0;
    private static final int LOG_ENABLED = 1;
    private static final String LOG_PROPERTY_NAME = "mtk_d.viewroot.enable";
    private static final boolean USE_RENDER_THREAD = false;
    private static final String VIEWROOT_LOG_TAG = "ViewRoot";
    private static final String VIEW_LOG_TAG = "View";
    private static long sIdent = 0;
    private KeyEvent mCurrentKeyEvent;
    private MotionEvent mCurrentMotion;
    private long mIdent;
    private HashMap<Object, Long> mInputStageRecored = new HashMap<>();
    private long mKeyEventStartTime;
    private String mKeyEventStatus = "0: Finish handle input event";
    private long mMotionEventStartTime;
    private String mMotionEventStatus = "0: Finish handle input event";
    private KeyEvent mPreviousKeyEvent;
    private long mPreviousKeyEventFinishTime;
    private MotionEvent mPreviousMotion;
    private long mPreviousMotionEventFinishTime;

    static {
        boolean z = false;
        if (1 == SystemProperties.getInt("mtk_ro.mtk_perf_fast_start_win", 0)) {
            z = true;
        }
        DBG_APP_FAST_LAUNCH_ENHANCE = z;
    }

    public boolean debugForceHWDraw(boolean z) {
        int i = DBG_APP_DRAWING_MODE;
        if ((i & 1) == 1) {
            return true;
        }
        if ((i & 2) == 2) {
            return false;
        }
        return z;
    }

    public int debugForceHWLayer(int i) {
        int i2 = DBG_APP_DRAWING_MODE;
        if ((i2 & 4) == 4) {
            return 2;
        }
        if ((i2 & 8) == 8) {
            return 1;
        }
        return i;
    }

    public void debugKeyDispatch(View view, KeyEvent keyEvent) {
        if (keyEvent.getAction() == 0) {
            Log.i(VIEW_LOG_TAG, "Key down dispatch to " + view + ", event = " + keyEvent);
        } else if (keyEvent.getAction() == 1) {
            Log.i(VIEW_LOG_TAG, "Key up dispatch to " + view + ", event = " + keyEvent);
        }
    }

    public void debugEventHandled(View view, InputEvent inputEvent, String str) {
        Log.i(VIEW_LOG_TAG, "Event handle in " + view + ", event = " + inputEvent + ", handler = " + str);
    }

    public void debugTouchDispatched(View view, MotionEvent motionEvent) {
        if (motionEvent.getAction() == 0) {
            Log.i(VIEW_LOG_TAG, "Touch down dispatch to " + view + ", event x = " + motionEvent.getX() + ",y = " + motionEvent.getY());
        } else if (motionEvent.getAction() == 1) {
            Log.i(VIEW_LOG_TAG, "Touch up dispatch to " + view + ", event x = " + motionEvent.getX() + ",y = " + motionEvent.getY());
        } else {
            Log.d(VIEW_LOG_TAG, "(View)dispatchTouchEvent: event action = " + MotionEvent.actionToString(motionEvent.getAction()) + ",x = " + motionEvent.getX() + ",y = " + motionEvent.getY() + ",this = " + view);
        }
    }

    public void warningParentToNull(View view) {
        if (ViewDebugManager.DEBUG_MOTION) {
            Log.d(VIEW_LOG_TAG, "assignParent to null: this = " + view + ", callstack = ", new Throwable());
        }
        Log.d(VIEW_LOG_TAG, "[Warning] assignParent to null: this = " + view);
    }

    public void debugOnDrawDone(View view, long j) {
        long currentTimeMillis = System.currentTimeMillis() - j;
        if (currentTimeMillis > ((long) ViewDebugManager.DBG_TIMEOUT_VALUE)) {
            Log.d(VIEW_LOG_TAG, "[ANR Warning]onDraw time too long, this =" + view + "time =" + currentTimeMillis + " ms");
        }
        if (ViewDebugManager.DEBUG_DRAW) {
            Log.d(VIEW_LOG_TAG, "onDraw done, this =" + view + "time =" + currentTimeMillis + " ms");
        }
    }

    public long debugOnMeasureStart(View view, int i, int i2, int i3, int i4) {
        if (ViewDebugManager.DEBUG_LAYOUT) {
            Log.d(VIEW_LOG_TAG, "view measure start, this = " + view + ", widthMeasureSpec = " + View.MeasureSpec.toString(i) + ", heightMeasureSpec = " + View.MeasureSpec.toString(i2) + ", mOldWidthMeasureSpec = " + View.MeasureSpec.toString(i3) + ", mOldHeightMeasureSpec = " + View.MeasureSpec.toString(i4) + getViewLayoutProperties(view));
        }
        return System.currentTimeMillis();
    }

    public void debugOnMeasureEnd(View view, long j) {
        long currentTimeMillis = System.currentTimeMillis() - j;
        if (currentTimeMillis > ((long) ViewDebugManager.DBG_TIMEOUT_VALUE)) {
            Log.d(VIEW_LOG_TAG, "[ANR Warning]onMeasure time too long, this =" + view + "time =" + currentTimeMillis + " ms");
        }
        if (ViewDebugManager.DEBUG_LAYOUT) {
            Log.d(VIEW_LOG_TAG, "view onMeasure end (measure cache), this =" + view + ", mMeasuredWidth = " + view.getMeasuredWidth() + ", mMeasuredHeight = " + view.getMeasuredHeight() + ", time =" + currentTimeMillis + " ms");
        }
    }

    public void debugOnLayoutEnd(View view, long j) {
        long currentTimeMillis = System.currentTimeMillis() - j;
        if (currentTimeMillis > ((long) ViewDebugManager.DBG_TIMEOUT_VALUE)) {
            Log.d(VIEW_LOG_TAG, "[ANR Warning]onLayout time too long, this =" + view + "time =" + currentTimeMillis + " ms");
        }
        if (ViewDebugManager.DEBUG_LAYOUT) {
            Log.d(VIEW_LOG_TAG, "view layout end, this =" + view + ", time =" + currentTimeMillis + " ms");
        }
    }

    private String getViewLayoutProperties(View view) {
        StringBuilder sb = new StringBuilder(128);
        sb.append(", Padding = {" + view.getPaddingLeft() + ", " + view.getPaddingTop() + ", " + view.getPaddingRight() + ", " + view.getPaddingBottom() + "}");
        if (view.getLayoutParams() == null) {
            sb.append(", BAD! no layout params");
        } else {
            sb.append(", " + view.getLayoutParams().debug(""));
        }
        return sb.toString();
    }

    private int getCurrentLevel(View view) {
        ViewParent parent = view.getParent();
        int i = 0;
        while (parent != null && (parent instanceof View)) {
            i++;
            parent = ((View) parent).getParent();
        }
        return i;
    }

    private String sizeToString(int i) {
        if (i == -2) {
            return "wrap-content";
        }
        return i == -1 ? "match-parent" : String.valueOf(i);
    }

    public String debug(String str, ViewGroup.MarginLayoutParams marginLayoutParams) {
        return str + "ViewGroup.MarginLayoutParams={ width=" + sizeToString(marginLayoutParams.width) + ", height=" + sizeToString(marginLayoutParams.height) + ", leftMargin=" + marginLayoutParams.leftMargin + ", rightMargin=" + marginLayoutParams.rightMargin + ", topMargin=" + marginLayoutParams.topMargin + ", bottomMargin=" + marginLayoutParams.bottomMargin + " }";
    }

    public void debugViewRemoved(View view, ViewGroup viewGroup, Thread thread) {
        if (!(viewGroup.getViewRootImpl() == null || thread == Thread.currentThread())) {
            Log.e(VIEW_LOG_TAG, "[Warning] remove view from parent not in UIThread: parent = " + viewGroup + " view == " + view);
        }
        if (ViewDebugManager.DEBUG_LIFECYCLE) {
            Log.e(VIEW_LOG_TAG, "will remove view from parent " + viewGroup + " view == " + view, new Throwable());
        }
    }

    public void debugViewGroupChildMeasure(View view, View view2, ViewGroup.MarginLayoutParams marginLayoutParams, int i, int i2) {
        int currentLevel = getCurrentLevel(view2);
        Log.d(VIEW_LOG_TAG, "[ViewGroup][measureChildWithMargins] +" + currentLevel + " , child = " + view + ", child margin (L,R,T,B) = " + marginLayoutParams.leftMargin + "," + marginLayoutParams.rightMargin + "," + marginLayoutParams.topMargin + "," + marginLayoutParams.bottomMargin + ", widthUsed = " + i + ", heightUsed = " + i2 + ", parent padding (L,R,T,B) = " + view2.getPaddingLeft() + "," + view2.getPaddingRight() + "," + view2.getPaddingTop() + "," + view2.getPaddingBottom() + ", this = " + this);
    }

    public void debugViewGroupChildMeasure(View view, View view2, ViewGroup.LayoutParams layoutParams, int i, int i2) {
        int currentLevel = getCurrentLevel(view2);
        Log.d(VIEW_LOG_TAG, "[ViewGroup][measureChildWithMargins] +" + currentLevel + " , child = " + view + ", child params (width, height) = " + layoutParams.width + "," + layoutParams.height + ", widthUsed = " + i + ", heightUsed = " + i2 + ", parent padding (L,R,T,B) = " + view2.getPaddingLeft() + "," + view2.getPaddingRight() + "," + view2.getPaddingTop() + "," + view2.getPaddingBottom() + ", this = " + this);
    }

    public void debugViewRootConstruct(String str, Object obj, Object obj2, Object obj3, Object obj4, ViewRootImpl viewRootImpl) {
        long j = sIdent;
        sIdent = 1 + j;
        viewRootImpl.mIdent = j;
        checkViewRootImplLogProperty();
        if (ViewDebugManager.LOCAL_LOGV) {
            enableLog(str, true);
        }
        if (ViewDebugManager.DEBUG_LIFECYCLE) {
            Log.v(str, "ViewRootImpl construct: context = " + obj + ", mThread = " + obj2 + ", mChoreographer = " + obj3 + ", mTraversalRunnable = " + obj4 + ", this = " + viewRootImpl);
        }
    }

    /* access modifiers changed from: package-private */
    public void enableLog(String str, boolean z) {
        Log.v(str, "enableLog: enable = " + z);
        ViewDebugManager.LOCAL_LOGV = z;
        ViewDebugManager.DEBUG_DRAW = z;
        ViewDebugManager.DEBUG_LAYOUT = z;
        ViewDebugManager.DEBUG_DIALOG = z;
        ViewDebugManager.DEBUG_INPUT_RESIZE = z;
        ViewDebugManager.DEBUG_ORIENTATION = z;
        ViewDebugManager.DEBUG_TRACKBALL = z;
        ViewDebugManager.DEBUG_IMF = z;
        ViewDebugManager.DEBUG_CONFIGURATION = z;
        ViewDebugManager.DEBUG_FPS = z;
        ViewDebugManager.DEBUG_INPUT = z;
        ViewDebugManager.DEBUG_IME_ANR = z;
        ViewDebugManager.DEBUG_LIFECYCLE = z;
        ViewDebugManager.DEBUG_REQUESTLAYOUT = z;
        ViewDebugManager.DEBUG_INVALIDATE = z;
        ViewDebugManager.DEBUG_SCHEDULETRAVERSALS = z;
    }

    static void checkViewRootImplLogProperty() {
        int i;
        String str = SystemProperties.get(LOG_PROPERTY_NAME);
        boolean z = true;
        ViewDebugManager.DEBUG_USER = true;
        ViewDebugManager.DBG_TRANSP = DBG_TRANSP;
        if (str != null && str.length() > 0) {
            try {
                i = Integer.parseInt(str, 16);
            } catch (NumberFormatException unused) {
                Log.w(VIEWROOT_LOG_TAG, "Invalid format of propery string: " + str);
                i = 0;
            }
            Log.d(VIEWROOT_LOG_TAG, "checkViewRootImplLogProperty: propString = " + str + ",logFilter = #" + Integer.toHexString(i));
            boolean z2 = (i & 1) == 1;
            ViewDebugManager.LOCAL_LOGV = z2;
            ViewRootImpl.LOCAL_LOGV = z2;
            boolean z3 = (i & 2) == 2;
            ViewDebugManager.DEBUG_DRAW = z3;
            ViewRootImpl.DEBUG_DRAW = z3;
            boolean z4 = (i & 4) == 4;
            ViewDebugManager.DEBUG_LAYOUT = z4;
            ViewRootImpl.DEBUG_LAYOUT = z4;
            boolean z5 = (i & 8) == 8;
            ViewDebugManager.DEBUG_DIALOG = z5;
            ViewRootImpl.DEBUG_DIALOG = z5;
            boolean z6 = (i & 16) == 16;
            ViewDebugManager.DEBUG_INPUT_RESIZE = z6;
            ViewRootImpl.DEBUG_INPUT_RESIZE = z6;
            boolean z7 = (i & 32) == 32;
            ViewDebugManager.DEBUG_ORIENTATION = z7;
            ViewRootImpl.DEBUG_ORIENTATION = z7;
            boolean z8 = (i & 64) == 64;
            ViewDebugManager.DEBUG_TRACKBALL = z8;
            ViewRootImpl.DEBUG_TRACKBALL = z8;
            boolean z9 = (i & 128) == 128;
            ViewDebugManager.DEBUG_IMF = z9;
            ViewRootImpl.DEBUG_IMF = z9;
            boolean z10 = (i & 256) == 256;
            ViewDebugManager.DEBUG_CONFIGURATION = z10;
            ViewRootImpl.DEBUG_CONFIGURATION = z10;
            boolean z11 = (i & 512) == 512;
            ViewDebugManager.DBG = z11;
            ViewRootImpl.DBG = z11;
            boolean z12 = (i & 1024) == 1024;
            ViewDebugManager.DEBUG_FPS = z12;
            ViewRootImpl.DEBUG_FPS = z12;
            boolean z13 = (i & 4194304) == 4194304;
            ViewDebugManager.DEBUG_INPUT_STAGES = z13;
            ViewRootImpl.DEBUG_INPUT_STAGES = z13;
            boolean z14 = (i & 8388608) == 8388608;
            ViewDebugManager.DEBUG_KEEP_SCREEN_ON = z14;
            ViewRootImpl.DEBUG_KEEP_SCREEN_ON = z14;
            ViewDebugManager.DEBUG_HWUI = (i & 2048) == 2048;
            boolean z15 = (i & 4096) == 4096;
            ViewDebugManager.DEBUG_INPUT = z15;
            ViewDebugManager.DEBUG_KEY = z15 || (i & 8192) == 8192;
            ViewDebugManager.DEBUG_MOTION = z15 || (i & 16384) == 16384;
            ViewDebugManager.DEBUG_IME_ANR = (i & 32768) == 32768;
            ViewDebugManager.DEBUG_LIFECYCLE = (i & 65536) == 65536;
            ViewDebugManager.DEBUG_REQUESTLAYOUT = (i & 131072) == 131072;
            ViewDebugManager.DEBUG_INVALIDATE = (262144 & i) == 262144;
            ViewDebugManager.DEBUG_SCHEDULETRAVERSALS = (524288 & i) == 524288;
            ViewDebugManager.DEBUG_TOUCHMODE = (1048576 & i) == 1048576;
            ViewDebugManager.DEBUG_TOUCH = (2097152 & i) == 2097152;
            ViewDebugManager.DEBUG_FOCUS = (16777216 & i) == 16777216;
            ViewDebugManager.DEBUG_SYSTRACE_MEASURE = (DEBUG_SYSTRACE_MEASURE_FLAG & i) == DEBUG_SYSTRACE_MEASURE_FLAG;
            ViewDebugManager.DEBUG_SYSTRACE_LAYOUT = (DEBUG_SYSTRACE_LAYOUT_FLAG & i) == DEBUG_SYSTRACE_LAYOUT_FLAG;
            ViewDebugManager.DEBUG_SYSTRACE_DRAW = (DEBUG_SYSTRACE_DRAW_FLAG & i) == DEBUG_SYSTRACE_DRAW_FLAG;
            ViewDebugManager.DEBUG_CHOREOGRAPHER_JANK = (DEBUG_CHOREOGRAPHER_JANK_FLAG & i) == DEBUG_CHOREOGRAPHER_JANK_FLAG;
            ViewDebugManager.DEBUG_CHOREOGRAPHER_FRAMES = (536870912 & i) == 536870912;
            if ((1073741824 & i) != 1073741824) {
                z = false;
            }
            ViewDebugManager.DEBUG_MET_TRACE = z;
        }
    }

    private static boolean checkAppLaunchTimeProperty() {
        return 1 == SystemProperties.getInt("persist.applaunchtime.enable", 0);
    }

    public void dumpInputDispatchingStatus(String str) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        Date date = new Date(this.mKeyEventStartTime);
        Date date2 = new Date(this.mPreviousKeyEventFinishTime);
        long currentTimeMillis = System.currentTimeMillis() - this.mKeyEventStartTime;
        if (this.mCurrentKeyEvent == null) {
            Log.i(str, "ANR Key Analyze: No Key event currently.");
            Log.i(str, "ANR Key Analyze: Previeous Event " + this.mPreviousKeyEvent + ",finish at " + simpleDateFormat.format(date2));
        } else {
            Log.i(str, "Dispatch " + this.mCurrentKeyEvent + " status is " + this.mKeyEventStatus + ",start at " + simpleDateFormat.format(date) + ", spent " + currentTimeMillis + "ms.");
        }
        if (this.mCurrentMotion == null) {
            date2.setTime(this.mPreviousMotionEventFinishTime);
            Log.i(str, "ANR Motion Analyze: No motion event currently.");
            Log.i(str, "ANR Motion Analyze: Previeous Event " + this.mPreviousMotion + ",finish at " + simpleDateFormat.format(date2));
        } else {
            date.setTime(this.mMotionEventStartTime);
            long currentTimeMillis2 = System.currentTimeMillis() - this.mMotionEventStartTime;
            Log.i(str, "Dispatch " + this.mCurrentMotion + " status is " + this.mMotionEventStatus + ",start at " + simpleDateFormat.format(date) + ", spent " + currentTimeMillis2 + "ms.");
        }
        dumpInputStageInfo(str, simpleDateFormat);
        clearInputStageInfo();
    }

    public void debugInputStageDeliverd(Object obj, long j) {
        this.mInputStageRecored.put(obj, Long.valueOf(j));
    }

    /* access modifiers changed from: package-private */
    public void clearInputStageInfo() {
        this.mInputStageRecored.clear();
    }

    /* access modifiers changed from: package-private */
    public void dumpInputStageInfo(String str, SimpleDateFormat simpleDateFormat) {
        if (!this.mInputStageRecored.isEmpty()) {
            for (Object next : this.mInputStageRecored.keySet()) {
                long longValue = this.mInputStageRecored.get(next).longValue();
                Date date = new Date(longValue);
                if (longValue != 0) {
                    Log.v(str, "Input event delivered to " + next + " at " + simpleDateFormat.format(date));
                }
            }
        }
    }

    public void debugInputEventStart(InputEvent inputEvent) {
        if (inputEvent instanceof KeyEvent) {
            this.mCurrentKeyEvent = (KeyEvent) inputEvent;
            this.mKeyEventStartTime = System.currentTimeMillis();
            this.mKeyEventStatus = "1: Start event from input";
            return;
        }
        this.mCurrentMotion = (MotionEvent) inputEvent;
        this.mMotionEventStartTime = System.currentTimeMillis();
        this.mMotionEventStatus = "1: Start event from input";
    }

    public void debugInputEventFinished(String str, boolean z, InputEvent inputEvent, ViewRootImpl viewRootImpl) {
        String str2;
        long j;
        long currentTimeMillis = System.currentTimeMillis();
        if (inputEvent instanceof KeyEvent) {
            this.mPreviousKeyEvent = this.mCurrentKeyEvent;
            this.mPreviousKeyEventFinishTime = System.currentTimeMillis();
            this.mCurrentKeyEvent = null;
            str2 = this.mKeyEventStatus;
            this.mKeyEventStatus = "0: Finish handle input event";
            j = this.mKeyEventStartTime;
        } else {
            this.mPreviousMotion = this.mCurrentMotion;
            this.mPreviousMotionEventFinishTime = System.currentTimeMillis();
            this.mCurrentMotion = null;
            str2 = this.mMotionEventStatus;
            this.mMotionEventStatus = "0: Finish handle input event";
            j = this.mMotionEventStartTime;
        }
        long j2 = currentTimeMillis - j;
        if (j2 >= 6000) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
            Date date = new Date(currentTimeMillis - j2);
            Log.v(str, "[ANR Warning]Input routeing takes more than 6000ms since " + simpleDateFormat.format(date) + ", this = " + this);
            dumpInputStageInfo(str, simpleDateFormat);
        }
        clearInputStageInfo();
        if (!ViewDebugManager.DEBUG_ENG && !ViewDebugManager.DEBUG_INPUT && !ViewDebugManager.DEBUG_KEY && !ViewDebugManager.DEBUG_MOTION) {
            return;
        }
        if (inputEvent instanceof MotionEvent) {
            StringBuilder sb = new StringBuilder();
            sb.append("finishInputEvent: handled = ");
            sb.append(z);
            sb.append(",event action = ");
            MotionEvent motionEvent = (MotionEvent) inputEvent;
            sb.append(MotionEvent.actionToString(motionEvent.getAction()));
            sb.append(",x = ");
            sb.append(motionEvent.getX());
            sb.append(",y = ");
            sb.append(motionEvent.getY());
            sb.append(", stage = ");
            sb.append(str2);
            Log.v(str, sb.toString());
            return;
        }
        Log.v(str, "finishInputEvent: handled = " + z + ",event = " + inputEvent + ", stage = " + str2);
    }

    public void debugInputDispatchState(InputEvent inputEvent, String str) {
        if (inputEvent instanceof KeyEvent) {
            setKeyDispatchState(str);
        } else {
            setMotionDispatchState(str);
        }
    }

    /* access modifiers changed from: package-private */
    public void setKeyDispatchState(String str) {
        this.mKeyEventStatus = str;
    }

    /* access modifiers changed from: package-private */
    public void setMotionDispatchState(String str) {
        this.mMotionEventStatus = str;
    }

    public void debugTraveralDone(Object obj, Object obj2, boolean z, ViewRootImpl viewRootImpl, boolean z2, boolean z3, String str) {
        long j = (obj == null || obj2 == null || !z) ? -999 : (long) viewRootImpl.mFrame;
        Log.v(str, "ViewRoot performTraversals and draw- : frame#" + j + ", isViewVisible = " + z2 + " (cancelDraw = " + z3 + ")");
        viewRootImpl.mFrame = viewRootImpl.mFrame + 1;
    }
}
