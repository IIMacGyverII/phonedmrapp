package com.mediatek.boostfwk.identify.launch;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.view.WindowManager;
import com.mediatek.boostfwk.identify.BaseIdentify;
import com.mediatek.boostfwk.info.ActivityInfo;
import com.mediatek.boostfwk.policy.launch.LaunchPolicy;
import com.mediatek.boostfwk.scenario.BasicScenario;
import com.mediatek.boostfwk.scenario.launch.LaunchScenario;
import com.mediatek.boostfwk.utils.Config;
import com.mediatek.boostfwk.utils.LogUtil;
import com.mediatek.boostfwk.utils.Util;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class LaunchIdentify extends BaseIdentify {
    public static final String HOSTTYPE_ACTIVITY = "activity";
    private static final String TAG = "SBE-LaunchIdentify";
    public static final String THREAD_NAME = "launch";
    private static Object lock = new Object();
    private static LaunchIdentify sInstance;
    private int mCount = 0;
    private boolean mIsBegin = false;
    private LaunchConfig mLaunchConfig = new LaunchConfig();
    private LaunchPolicy mLaunchPolicy = new LaunchPolicy();
    private String mPkgName;
    private List<String> mSpecialPkgNames = new ArrayList();
    private WorkerHandler mWorkerHandler = null;
    private HandlerThread mWorkerThread = null;

    public boolean isMainThreadOnly() {
        return false;
    }

    public static LaunchIdentify getInstance() {
        if (sInstance == null) {
            synchronized (lock) {
                if (sInstance == null) {
                    sInstance = new LaunchIdentify();
                }
            }
        }
        return sInstance;
    }

    private void initThread() {
        HandlerThread handlerThread = this.mWorkerThread;
        if (handlerThread == null || !handlerThread.isAlive() || this.mWorkerHandler == null) {
            HandlerThread handlerThread2 = new HandlerThread(THREAD_NAME);
            this.mWorkerThread = handlerThread2;
            handlerThread2.start();
            Looper looper = this.mWorkerThread.getLooper();
            if (looper == null) {
                LogUtil.mLogi(TAG, "Thread looper is null");
            } else {
                this.mWorkerHandler = new WorkerHandler(looper);
            }
        } else {
            LogUtil.mLogi(TAG, "re-init");
        }
    }

    public LaunchIdentify() {
        initSpecialMap();
        initThread();
    }

    public boolean dispatchScenario(BasicScenario basicScenario) {
        if (basicScenario == null) {
            LogUtil.mLogw(TAG, "No Launch scenario to dispatcher.");
            return false;
        }
        LaunchScenario launchScenario = (LaunchScenario) basicScenario;
        int scenarioAction = launchScenario.getScenarioAction();
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "Launch action dispatcher to = " + scenarioAction);
        }
        if (scenarioAction == 1) {
            launchHintCheck(launchScenario.getBoostStatus(), launchScenario.getHostingType(), launchScenario.getPackageName(), launchScenario.getAttrs(), launchScenario.getActivityName(), launchScenario.getIsComeFromIdle());
        } else if (scenarioAction != 3) {
            LogUtil.mLogw(TAG, "Not found dispatcher launch action.");
        } else {
            WeakReference activity = launchScenario.getActivity();
            if (!(activity == null || activity.get() == null)) {
                if (Config.isBoostFwkLogEnable()) {
                    LogUtil.mLogd(TAG, "ACTIVITY_SWITCH set new context -->" + activity.get());
                }
                ActivityInfo.getInstance().setContext((Context) activity.get());
                activity.clear();
            }
        }
        return true;
    }

    public void launchHintCheck(int i, String str, String str2, WindowManager.LayoutParams layoutParams, String str3, boolean z) {
        if (i == 0) {
            boostHintBegin(str, str2);
        } else if (i != 1) {
            LogUtil.mLogw(TAG, "Not found dispatcher launch action.");
        } else if (z) {
            boostHintEnd(str2, layoutParams);
        } else {
            boostHintEndForSpecial(str2, str3);
        }
    }

    public void boostHintBegin(String str, String str2) {
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "boostHintBegin for hostingType= " + str + "; pkgName= " + str2);
        }
        if (str != null && str.contains(HOSTTYPE_ACTIVITY) && !Util.isSystemApp(str2)) {
            LogUtil.mLogd(TAG, "SBE boost:" + str2 + " begin");
            this.mPkgName = str2;
            this.mIsBegin = true;
            this.mCount = 0;
        }
    }

    public void boostHintEndForSpecial(String str, String str2) {
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "boostHintResume for pkgName= " + str + ", activityName= " + str2 + ", mLaunchConfig.isInSpecialList(pkgName) = " + isInSpecialList(str));
        }
        String str3 = this.mPkgName;
        if (str3 != null && str3.equals(str) && isInSpecialList(str)) {
            this.mCount++;
            if (this.mCount == getActivityCount(str)) {
                WorkerHandler workerHandler = this.mWorkerHandler;
                workerHandler.sendMessageDelayed(workerHandler.obtainMessage(2, str), 1000);
                this.mCount = 0;
            }
        }
    }

    public void boostHintEnd(String str, WindowManager.LayoutParams layoutParams) {
        if (Config.isBoostFwkLogEnable()) {
            LogUtil.mLogd(TAG, "boostHintEnd for pkgName = " + str + ", mPkgName = " + this.mPkgName + ", isGameApp = " + Util.isGameApp(str) + ", isSpecialApp = " + isInSpecialList(str) + ", isFullScreen = " + Util.IsFullScreen(layoutParams));
        }
        String str2 = this.mPkgName;
        if (str2 != null && str2.equals(str) && !Util.isSystemApp(str) && !isInSpecialList(str) && !Util.isGameApp(str) && !Util.IsFullScreen(layoutParams)) {
            this.mWorkerHandler.removeMessages(3, str);
            WorkerHandler workerHandler = this.mWorkerHandler;
            workerHandler.sendMessageDelayed(workerHandler.obtainMessage(3, str), 1000);
        }
    }

    public class WorkerHandler extends Handler {
        public static final int MSG_ACTIVITY_IDLE = 3;
        public static final int MSG_ACTIVITY_RESUME = 2;
        public static final int MSG_PROCESS_START = 1;

        WorkerHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            int i = message.what;
            if (i == 2 || i == 3) {
                LaunchIdentify.this.boostEnd((String) message.obj);
            }
        }
    }

    public void boostEnd(String str) {
        if (this.mIsBegin) {
            LogUtil.mLogd(TAG, "SBE boost:" + str + " end");
            this.mLaunchPolicy.boostEnd(str);
            this.mIsBegin = false;
            this.mPkgName = null;
            this.mCount = 0;
        }
    }

    public void initSpecialMap() {
        for (Map.Entry<String, String> key : LaunchConfig.SPECIAL_MAP.entrySet()) {
            this.mSpecialPkgNames.add((String) key.getKey());
        }
    }

    private boolean isInSpecialList(String str) {
        List<String> list = this.mSpecialPkgNames;
        return list != null && list.contains(str);
    }

    private int getActivityCount(String str) {
        if (LaunchConfig.SPECIAL_MAP.get(str) != null) {
            return Integer.parseInt(LaunchConfig.SPECIAL_MAP.get(str));
        }
        return 1;
    }
}
