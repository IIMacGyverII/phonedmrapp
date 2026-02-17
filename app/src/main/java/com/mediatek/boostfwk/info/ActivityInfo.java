package com.mediatek.boostfwk.info;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.os.Process;
import android.util.SparseArray;
import android.view.ThreadedRenderer;
import android.view.Window;
import android.view.WindowManager;
import com.mediatek.boostfwk.policy.frame.FrameDecision;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.TasksUtil;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;

public final class ActivityInfo {
    private static final Object LOCK = new Object();
    public static final int NO_CHECKED_STATUS = 0;
    public static final int PAGE_TYPE_AOSP_DESIGN = 1;
    public static final int PAGE_TYPE_APPBRAND = 16;
    public static final int PAGE_TYPE_FLUTTER = 8;
    public static final int PAGE_TYPE_FULLSCREEN_GLTHREAD = 64;
    public static final int PAGE_TYPE_NO_ACTIVITY = 128;
    public static final int PAGE_TYPE_SPECIAL_DESIGN = 2;
    public static final int PAGE_TYPE_SPECIAL_DESIGN_WEB_ON_60 = 32;
    public static final int PAGE_TYPE_WEBVIEW = 4;
    public static final int SBE_MASK_DEBUG_HINT = 8;
    public static final int SBE_MASK_FRAME_HINT = 2;
    public static final int SBE_MASK_RECUE_HINT = 1;
    public static final int SBE_MASK_SKIP_FRAME_END_HINT = 4;
    private static final String TAG = "ActivityInfo";
    private static ActivityInfo instance;
    private static int mSBEMask;
    private ArrayList<ActivityChangeListener> activityChangeListeners;
    private WeakReference<Context> activityContext;
    private WindowManager.LayoutParams attrs;
    private float density;
    /* access modifiers changed from: private */
    public volatile int mActivityCount;
    ActivityStateListener mActivityStateListener;
    private int mFlutterRenderTid;
    private int mPageType;
    private int mRenderThreadTid;
    private WeakReference<ThreadedRenderer> mWeakThreadedRender;
    private SparseArray<WeakReference<ThreadedRenderer>> mWeakThreadedRenderArray;
    private int mWebviewRenderPid;
    private String packageName;

    public interface ActivityChangeListener {
        void onAllActivityPaused(Context context) {
        }

        void onChange(Context context);
    }

    private ActivityInfo() {
        this.activityContext = null;
        this.density = -1.0f;
        this.packageName = null;
        this.mRenderThreadTid = Integer.MIN_VALUE;
        this.mWebviewRenderPid = Integer.MIN_VALUE;
        this.mFlutterRenderTid = Integer.MIN_VALUE;
        this.activityChangeListeners = null;
        this.mActivityStateListener = null;
        this.mActivityCount = 0;
        this.mPageType = 0;
        this.mWeakThreadedRenderArray = null;
        this.mWeakThreadedRender = null;
        this.activityChangeListeners = new ArrayList<>(4);
    }

    public static ActivityInfo getInstance() {
        if (instance == null) {
            synchronized (LOCK) {
                if (instance == null) {
                    instance = new ActivityInfo();
                }
            }
        }
        return instance;
    }

    public Context getContext() {
        WeakReference<Context> weakReference = this.activityContext;
        if (weakReference == null) {
            return null;
        }
        return (Context) weakReference.get();
    }

    public void setContext(Context context) {
        if (context != null) {
            WeakReference<Context> weakReference = this.activityContext;
            if (weakReference == null) {
                this.activityContext = new WeakReference<>(context);
                initialBasicInfo(context);
            } else if (!context.equals(weakReference.get())) {
                this.activityContext.clear();
                this.activityContext = new WeakReference<>(context);
                initialBasicInfo(context);
            }
            notifyActivityUpdate(context);
        }
    }

    private void initialBasicInfo(Context context) {
        this.attrs = null;
        this.density = context.getResources().getDisplayMetrics().density;
        this.packageName = context.getPackageName();
        if (this.mActivityStateListener == null) {
            this.mActivityStateListener = new ActivityStateListener();
            if (context instanceof Activity) {
                ((Activity) context).getApplication().registerActivityLifecycleCallbacks(this.mActivityStateListener);
                this.mActivityCount++;
            }
            if (Config.getBoostFwkVersion() > 2) {
                FrameDecision.getInstance();
            }
        }
    }

    private void notifyActivityUpdate(Context context) {
        this.mPageType = 0;
        Config.resetFeatureOption();
        Iterator<ActivityChangeListener> it = this.activityChangeListeners.iterator();
        while (it.hasNext()) {
            it.next().onChange(context);
        }
    }

    /* access modifiers changed from: private */
    public void notifyAllActivityPause(Context context) {
        Iterator<ActivityChangeListener> it = this.activityChangeListeners.iterator();
        while (it.hasNext()) {
            it.next().onAllActivityPaused(context);
        }
    }

    public WindowManager.LayoutParams getWindowLayoutAttr() {
        WindowManager.LayoutParams layoutParams = this.attrs;
        if (layoutParams != null) {
            return layoutParams;
        }
        WeakReference<Context> weakReference = this.activityContext;
        if (weakReference == null) {
            return null;
        }
        Context context = (Context) weakReference.get();
        Window window = (context == null || !(context instanceof Activity)) ? null : ((Activity) context).getWindow();
        if (window == null) {
            return null;
        }
        WindowManager.LayoutParams attributes = window.getAttributes();
        this.attrs = attributes;
        return attributes;
    }

    public float getDensity() {
        return this.density;
    }

    public String getPackageName() {
        return this.packageName;
    }

    public void setRenderThreadTid(int i) {
        this.mRenderThreadTid = i;
    }

    public int getRenderThreadTid() {
        if (this.mRenderThreadTid == Integer.MIN_VALUE) {
            this.mRenderThreadTid = TasksUtil.findRenderTheadTid(Process.myPid());
        }
        return this.mRenderThreadTid;
    }

    public void registerActivityListener(ActivityChangeListener activityChangeListener) {
        if (activityChangeListener != null) {
            this.activityChangeListeners.add(activityChangeListener);
        }
    }

    public class ActivityStateListener implements Application.ActivityLifecycleCallbacks {
        public void onActivityCreated(Activity activity, Bundle bundle) {
        }

        public void onActivityDestroyed(Activity activity) {
        }

        public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
        }

        public void onActivityStarted(Activity activity) {
        }

        public void onActivityStopped(Activity activity) {
        }

        public ActivityStateListener() {
        }

        public void onActivityResumed(Activity activity) {
            ActivityInfo activityInfo = ActivityInfo.this;
            activityInfo.mActivityCount = activityInfo.mActivityCount + 1;
        }

        public void onActivityPaused(Activity activity) {
            ActivityInfo activityInfo = ActivityInfo.this;
            int r1 = activityInfo.mActivityCount - 1;
            activityInfo.mActivityCount = r1;
            if (r1 == 0) {
                ActivityInfo.this.notifyAllActivityPause(activity);
            }
        }
    }

    public int getPageType() {
        if (this.mPageType != 0) {
            if (LogUtil.DEBUG) {
                LogUtil.traceAndMLogd(TAG, "pageType--> " + pageType2Str());
            }
            return this.mPageType;
        }
        Context context = getContext();
        if (context == null) {
            this.mPageType = 128;
            return 128;
        }
        if (TasksUtil.fullscreenAndGl(getWindowLayoutAttr())) {
            this.mPageType = 64;
        } else {
            if (TasksUtil.isAppBrand()) {
                this.mPageType |= 18;
            }
            if (TasksUtil.isFlutterApp(context)) {
                this.mPageType |= 10;
            }
            if (TasksUtil.isWebview()) {
                if (isPage(24) || ScrollState.getRefreshRate() != ScrollState.REFRESHRATE_60) {
                    this.mPageType |= 6;
                } else {
                    this.mPageType |= 34;
                }
            }
            if (!isSpecialPageDesign()) {
                this.mPageType = 1;
            }
        }
        if (LogUtil.DEBUG) {
            LogUtil.traceAndMLogd(TAG, "finally pageType--> " + pageType2Str());
        }
        return this.mPageType;
    }

    public boolean isSpecialPageDesign() {
        return isPage(2);
    }

    public boolean isAOSPPageDesign() {
        return isPage(1);
    }

    public boolean isPage(int i) {
        return (this.mPageType & i) != 0;
    }

    public String pageType2Str() {
        if (!LogUtil.DEBUG) {
            return "";
        }
        if (this.mPageType == 0) {
            return "NO_CHECKED_STATUS";
        }
        if (isPage(1)) {
            return "PAGE_TYPE_AOSP_DESIGN";
        }
        if (isPage(64)) {
            return "PAGE_TYPE_FULLSCREEN_GLTHREAD";
        }
        String str = "PAGE_TYPE_SPECIAL_DESIGN";
        if (isPage(4)) {
            str = str + " & PAGE_TYPE_WEBVIEW";
        }
        if (isPage(8)) {
            str = str + " & PAGE_TYPE_FLUTTER";
        }
        if (isPage(32)) {
            str = str + " & PAGE_TYPE_SPECIAL_DESIGN_WEB_ON_60";
        }
        if (!isPage(16)) {
            return str;
        }
        return str + " & PAGE_TYPE_APPBRAND";
    }

    public int getWebViewRenderPid() {
        int i = this.mWebviewRenderPid;
        if (i != Integer.MIN_VALUE) {
            return i;
        }
        int findGPUProcessPid = TasksUtil.findGPUProcessPid();
        this.mWebviewRenderPid = findGPUProcessPid;
        return findGPUProcessPid;
    }

    public int getFlutterRenderTid() {
        int i = this.mFlutterRenderTid;
        if (i != Integer.MIN_VALUE) {
            return i;
        }
        int findFlutterRenderTidForPid = TasksUtil.findFlutterRenderTidForPid();
        this.mFlutterRenderTid = findFlutterRenderTidForPid;
        return findFlutterRenderTidForPid;
    }

    public void setThreadedRenderer(ThreadedRenderer threadedRenderer) {
        if (threadedRenderer != null) {
            if (this.mWeakThreadedRenderArray == null) {
                this.mWeakThreadedRenderArray = new SparseArray<>();
            }
            int hashCode = threadedRenderer.hashCode();
            if (!this.mWeakThreadedRenderArray.contains(hashCode)) {
                this.mWeakThreadedRenderArray.put(hashCode, new WeakReference(threadedRenderer));
                if (LogUtil.DEBUG) {
                    LogUtil.mLogd(TAG, "add new render = " + threadedRenderer);
                }
            }
        }
    }

    public ThreadedRenderer getThreadedRenderer() {
        ThreadedRenderer threadedRenderer;
        ThreadedRenderer threadedRenderer2;
        if (this.mWeakThreadedRenderArray == null) {
            return null;
        }
        WeakReference<ThreadedRenderer> weakReference = this.mWeakThreadedRender;
        if (weakReference != null && (threadedRenderer2 = (ThreadedRenderer) weakReference.get()) != null) {
            return threadedRenderer2;
        }
        int size = this.mWeakThreadedRenderArray.size();
        if (size == 0) {
            return null;
        }
        int i = 0;
        while (i < size) {
            WeakReference<ThreadedRenderer> weakReference2 = this.mWeakThreadedRenderArray.get(this.mWeakThreadedRenderArray.keyAt(i));
            if (weakReference2 == null || (threadedRenderer = (ThreadedRenderer) weakReference2.get()) == null) {
                i++;
            } else {
                this.mWeakThreadedRender = weakReference2;
                return threadedRenderer;
            }
        }
        this.mWeakThreadedRenderArray.clear();
        return null;
    }

    public static synchronized int updateSBEMask(int i, boolean z) {
        int i2;
        synchronized (ActivityInfo.class) {
            if (z) {
                mSBEMask = i | mSBEMask;
            } else {
                mSBEMask = (~i) & mSBEMask;
            }
            if (LogUtil.DEBUG) {
                LogUtil.mLogd(TAG, "updateSBEMask to " + mSBEMask);
            }
            i2 = mSBEMask;
        }
        return i2;
    }

    public static void clearTraversalCount() {
        mSBEMask &= 65535;
    }

    public static boolean containMask(int i) {
        return (i & mSBEMask) != 0;
    }
}
