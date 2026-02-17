package com.android.internal.telephony;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.RemoteException;
import android.telephony.IBootstrapAuthenticationCallback;
import android.telephony.SubscriptionManager;
import android.telephony.gba.GbaAuthRequest;
import android.telephony.gba.IGbaService;
import android.text.TextUtils;
import android.util.SparseArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.metrics.RcsStats;
import com.android.telephony.Rlog;
import java.util.concurrent.ConcurrentLinkedQueue;

public class GbaManager {
    private static final boolean DBG = Build.IS_DEBUGGABLE;
    private static final int EVENT_BIND_FAIL = 3;
    private static final int EVENT_BIND_SERVICE = 1;
    private static final int EVENT_BIND_SUCCESS = 4;
    private static final int EVENT_CONFIG_CHANGED = 5;
    private static final int EVENT_REQUESTS_RECEIVED = 6;
    private static final int EVENT_UNBIND_SERVICE = 2;
    @VisibleForTesting
    public static final int MAX_RETRY = 5;
    @VisibleForTesting
    public static final int REQUEST_TIMEOUT_MS = 5000;
    @VisibleForTesting
    public static final int RETRY_TIME_MS = 3000;
    private static final SparseArray<GbaManager> sGbaManagers = new SparseArray<>();
    /* access modifiers changed from: private */
    public final SparseArray<IBootstrapAuthenticationCallback> mCallbacks = new SparseArray<>();
    private final Context mContext;
    /* access modifiers changed from: private */
    public GbaDeathRecipient mDeathRecipient;
    /* access modifiers changed from: private */
    public Handler mHandler;
    /* access modifiers changed from: private */
    public IGbaService mIGbaService;
    private final String mLogTag;
    /* access modifiers changed from: private */
    public final RcsStats mRcsStats;
    private int mReleaseTime;
    /* access modifiers changed from: private */
    public final ConcurrentLinkedQueue<GbaAuthRequest> mRequestQueue = new ConcurrentLinkedQueue<>();
    /* access modifiers changed from: private */
    public int mRetryTimes = 0;
    private final IBootstrapAuthenticationCallback mServiceCallback = new IBootstrapAuthenticationCallback.Stub() {
        public void onKeysAvailable(int i, byte[] bArr, String str) {
            IBootstrapAuthenticationCallback iBootstrapAuthenticationCallback;
            GbaManager gbaManager = GbaManager.this;
            gbaManager.logv("onKeysAvailable: " + Integer.toHexString(i) + ", id: " + str);
            synchronized (GbaManager.this.mCallbacks) {
                iBootstrapAuthenticationCallback = (IBootstrapAuthenticationCallback) GbaManager.this.mCallbacks.get(i);
            }
            if (iBootstrapAuthenticationCallback != null) {
                try {
                    iBootstrapAuthenticationCallback.onKeysAvailable(i, bArr, str);
                    GbaManager.this.mRcsStats.onGbaSuccessEvent(GbaManager.this.mSubId);
                } catch (RemoteException e) {
                    GbaManager gbaManager2 = GbaManager.this;
                    gbaManager2.logd("RemoteException " + e);
                }
                synchronized (GbaManager.this.mCallbacks) {
                    GbaManager.this.mCallbacks.remove(i);
                    if (GbaManager.this.mCallbacks.size() == 0) {
                        GbaManager.this.releaseServiceAsNeeded(0);
                    }
                }
            }
        }

        public void onAuthenticationFailure(int i, int i2) {
            IBootstrapAuthenticationCallback iBootstrapAuthenticationCallback;
            GbaManager gbaManager = GbaManager.this;
            gbaManager.logd("onAuthenticationFailure: " + Integer.toHexString(i) + " for: " + i2);
            synchronized (GbaManager.this.mCallbacks) {
                iBootstrapAuthenticationCallback = (IBootstrapAuthenticationCallback) GbaManager.this.mCallbacks.get(i);
            }
            if (iBootstrapAuthenticationCallback != null) {
                try {
                    iBootstrapAuthenticationCallback.onAuthenticationFailure(i, i2);
                    GbaManager.this.mRcsStats.onGbaFailureEvent(GbaManager.this.mSubId, i2);
                } catch (RemoteException e) {
                    GbaManager gbaManager2 = GbaManager.this;
                    gbaManager2.logd("RemoteException " + e);
                }
                synchronized (GbaManager.this.mCallbacks) {
                    GbaManager.this.mCallbacks.remove(i);
                    if (GbaManager.this.mCallbacks.size() == 0) {
                        GbaManager.this.releaseServiceAsNeeded(0);
                    }
                }
            }
        }
    };
    private GbaServiceConnection mServiceConnection;
    private String mServicePackageName;
    private String mServicePackageNameOverride;
    /* access modifiers changed from: private */
    public final int mSubId;
    /* access modifiers changed from: private */
    public String mTargetBindingPackageName;

    private final class GbaManagerHandler extends Handler {
        GbaManagerHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            GbaManager gbaManager = GbaManager.this;
            gbaManager.logv("handle msg:" + message.what);
            switch (message.what) {
                case 1:
                    GbaManager gbaManager2 = GbaManager.this;
                    int r0 = gbaManager2.mRetryTimes;
                    gbaManager2.mRetryTimes = r0 + 1;
                    if (r0 < 5) {
                        GbaManager.this.rebindService(false);
                        return;
                    }
                    GbaManager.this.loge("Too many retries, stop now!");
                    sendEmptyMessage(3);
                    return;
                case 2:
                    if (GbaManager.this.mRequestQueue.isEmpty()) {
                        GbaManager.this.clearCallbacksAndNotifyFailure();
                        GbaManager.this.unbindService();
                        return;
                    }
                    return;
                case 3:
                case 4:
                    GbaManager.this.mRetryTimes = 0;
                    GbaManager.this.processRequests();
                    return;
                case 5:
                    GbaManager.this.mRetryTimes = 0;
                    if (GbaManager.this.isServiceConnetable() || GbaManager.this.isServiceConnected()) {
                        GbaManager.this.rebindService(true);
                        return;
                    }
                    return;
                case 6:
                    if (GbaManager.this.isServiceConnected()) {
                        GbaManager.this.processRequests();
                        return;
                    } else if (!GbaManager.this.mHandler.hasMessages(1)) {
                        GbaManager.this.mHandler.sendEmptyMessage(1);
                        return;
                    } else {
                        return;
                    }
                default:
                    GbaManager gbaManager3 = GbaManager.this;
                    gbaManager3.loge("Unhandled event " + message.what);
                    return;
            }
        }
    }

    private final class GbaDeathRecipient implements IBinder.DeathRecipient {
        private IBinder mBinder;
        private final ComponentName mComponentName;

        GbaDeathRecipient(ComponentName componentName) {
            this.mComponentName = componentName;
        }

        public void linkToDeath(IBinder iBinder) throws RemoteException {
            if (iBinder != null) {
                this.mBinder = iBinder;
                iBinder.linkToDeath(this, 0);
            }
        }

        public synchronized void unlinkToDeath() {
            IBinder iBinder = this.mBinder;
            if (iBinder != null) {
                iBinder.unlinkToDeath(this, 0);
                this.mBinder = null;
            }
        }

        public void binderDied() {
            GbaManager gbaManager = GbaManager.this;
            gbaManager.logd("GbaService(" + this.mComponentName + ") has died.");
            unlinkToDeath();
            GbaManager.this.retryBind();
        }
    }

    private final class GbaServiceConnection implements ServiceConnection {
        private GbaServiceConnection() {
        }

        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            GbaManager gbaManager = GbaManager.this;
            gbaManager.logd("service " + componentName + " for Gba is connected.");
            GbaManager.this.mIGbaService = IGbaService.Stub.asInterface(iBinder);
            GbaManager gbaManager2 = GbaManager.this;
            gbaManager2.mDeathRecipient = new GbaDeathRecipient(componentName);
            try {
                GbaManager.this.mDeathRecipient.linkToDeath(iBinder);
            } catch (RemoteException e) {
                GbaManager.this.mDeathRecipient.binderDied();
                GbaManager gbaManager3 = GbaManager.this;
                gbaManager3.logd("RemoteException " + e);
            }
            GbaManager.this.mHandler.sendEmptyMessage(4);
        }

        public void onServiceDisconnected(ComponentName componentName) {
            GbaManager gbaManager = GbaManager.this;
            gbaManager.logd("service " + componentName + " is now disconnected.");
            GbaManager.this.mTargetBindingPackageName = null;
        }
    }

    @VisibleForTesting
    public GbaManager(Context context, int i, String str, int i2, RcsStats rcsStats) {
        this.mContext = context;
        this.mSubId = i;
        String str2 = "GbaManager[" + i + "]";
        this.mLogTag = str2;
        this.mServicePackageName = str;
        this.mReleaseTime = i2;
        HandlerThread handlerThread = new HandlerThread(str2);
        handlerThread.start();
        GbaManagerHandler gbaManagerHandler = new GbaManagerHandler(handlerThread.getLooper());
        this.mHandler = gbaManagerHandler;
        if (this.mReleaseTime < 0) {
            gbaManagerHandler.sendEmptyMessage(1);
        }
        this.mRcsStats = rcsStats;
    }

    public static GbaManager make(Context context, int i, String str, int i2) {
        GbaManager gbaManager = new GbaManager(context, i, str, i2, RcsStats.getInstance());
        SparseArray<GbaManager> sparseArray = sGbaManagers;
        synchronized (sparseArray) {
            sparseArray.put(i, gbaManager);
        }
        return gbaManager;
    }

    public static GbaManager getInstance(int i) {
        GbaManager gbaManager;
        SparseArray<GbaManager> sparseArray = sGbaManagers;
        synchronized (sparseArray) {
            gbaManager = sparseArray.get(i);
        }
        return gbaManager;
    }

    public void bootstrapAuthenticationRequest(GbaAuthRequest gbaAuthRequest) {
        logv("bootstrapAuthenticationRequest: " + gbaAuthRequest);
        if (TextUtils.isEmpty(getServicePackage())) {
            logd("do not support!");
            try {
                gbaAuthRequest.getCallback().onAuthenticationFailure(gbaAuthRequest.getToken(), 1);
            } catch (RemoteException e) {
                loge("exception to call service: " + e);
            }
        } else {
            this.mRequestQueue.offer(gbaAuthRequest);
            if (!this.mHandler.hasMessages(6)) {
                this.mHandler.sendEmptyMessage(6);
            }
        }
    }

    /* access modifiers changed from: private */
    public void processRequests() {
        if (isServiceConnected()) {
            while (!this.mRequestQueue.isEmpty()) {
                try {
                    GbaAuthRequest gbaAuthRequest = new GbaAuthRequest(this.mRequestQueue.peek());
                    synchronized (this.mCallbacks) {
                        this.mCallbacks.put(gbaAuthRequest.getToken(), gbaAuthRequest.getCallback());
                    }
                    gbaAuthRequest.setCallback(this.mServiceCallback);
                    this.mIGbaService.authenticationRequest(gbaAuthRequest);
                    this.mRequestQueue.poll();
                } catch (RemoteException e) {
                    this.mDeathRecipient.binderDied();
                    logd("RemoteException " + e);
                }
            }
        } else {
            while (!this.mRequestQueue.isEmpty()) {
                GbaAuthRequest poll = this.mRequestQueue.poll();
                try {
                    poll.getCallback().onAuthenticationFailure(poll.getToken(), 1);
                } catch (RemoteException e2) {
                    logd("RemoteException " + e2);
                }
            }
        }
        releaseServiceAsNeeded(REQUEST_TIMEOUT_MS);
    }

    /* access modifiers changed from: private */
    public void releaseServiceAsNeeded(int i) {
        int releaseTime = getReleaseTime();
        if (releaseTime >= 0) {
            if (releaseTime > i) {
                i = releaseTime;
            }
            if (this.mHandler.hasMessages(2)) {
                this.mHandler.removeMessages(2);
            }
            this.mHandler.sendEmptyMessageDelayed(2, (long) i);
        }
    }

    /* access modifiers changed from: private */
    public void clearCallbacksAndNotifyFailure() {
        synchronized (this.mCallbacks) {
            for (int i = 0; i < this.mCallbacks.size(); i++) {
                try {
                    this.mCallbacks.valueAt(i).onAuthenticationFailure(this.mCallbacks.keyAt(i), 0);
                } catch (RemoteException e) {
                    logd("RemoteException " + e);
                }
            }
            this.mCallbacks.clear();
        }
    }

    @VisibleForTesting
    public boolean isServiceConnected() {
        boolean z;
        synchronized (this) {
            IGbaService iGbaService = this.mIGbaService;
            z = iGbaService != null && iGbaService.asBinder().isBinderAlive() && TextUtils.equals(this.mServicePackageName, this.mTargetBindingPackageName);
        }
        return z;
    }

    /* access modifiers changed from: private */
    public boolean isServiceConnetable() {
        boolean z;
        synchronized (this) {
            if (this.mTargetBindingPackageName == null) {
                if (this.mReleaseTime >= 0 || TextUtils.isEmpty(this.mServicePackageName)) {
                    z = false;
                }
            }
            z = true;
        }
        return z;
    }

    /* access modifiers changed from: private */
    public void unbindService() {
        GbaDeathRecipient gbaDeathRecipient = this.mDeathRecipient;
        if (gbaDeathRecipient != null) {
            gbaDeathRecipient.unlinkToDeath();
        }
        if (this.mServiceConnection != null) {
            logv("unbind service.");
            this.mContext.unbindService(this.mServiceConnection);
        }
        this.mDeathRecipient = null;
        this.mIGbaService = null;
        this.mServiceConnection = null;
        this.mTargetBindingPackageName = null;
    }

    private void bindService() {
        if (this.mContext == null || !SubscriptionManager.isValidSubscriptionId(this.mSubId)) {
            loge("Can't bind service with invalid sub Id.");
            return;
        }
        String servicePackage = getServicePackage();
        if (TextUtils.isEmpty(servicePackage)) {
            loge("Can't find the binding package");
            return;
        }
        Intent intent = new Intent("android.telephony.gba.GbaService");
        intent.setPackage(servicePackage);
        try {
            logv("Trying to bind " + servicePackage);
            GbaServiceConnection gbaServiceConnection = new GbaServiceConnection();
            this.mServiceConnection = gbaServiceConnection;
            if (!this.mContext.bindService(intent, gbaServiceConnection, 67108865)) {
                logd("Cannot bind to the service.");
                retryBind();
                return;
            }
            this.mTargetBindingPackageName = servicePackage;
        } catch (SecurityException e) {
            loge("bindService failed " + e);
        }
    }

    /* access modifiers changed from: private */
    public void retryBind() {
        if (this.mHandler.hasMessages(1)) {
            logv("wait for pending retry.");
            return;
        }
        logv("starting retry:" + this.mRetryTimes);
        this.mHandler.sendEmptyMessageDelayed(1, 3000);
    }

    /* access modifiers changed from: private */
    public void rebindService(boolean z) {
        if (z || !isServiceConnected()) {
            unbindService();
            bindService();
            return;
        }
        logv("Service " + getServicePackage() + " already bound or being bound.");
    }

    public boolean overrideServicePackage(String str) {
        synchronized (this) {
            if (TextUtils.equals(this.mServicePackageName, str)) {
                return false;
            }
            logv("Service package name is changed from " + this.mServicePackageName + " to " + str);
            this.mServicePackageName = str;
            if (!this.mHandler.hasMessages(5)) {
                this.mHandler.sendEmptyMessage(5);
            }
            return true;
        }
    }

    public String getServicePackage() {
        String str;
        synchronized (this) {
            str = this.mServicePackageName;
        }
        return str;
    }

    public boolean overrideReleaseTime(int i) {
        synchronized (this) {
            if (this.mReleaseTime == i) {
                return false;
            }
            logv("Service release time is changed from " + this.mReleaseTime + " to " + i);
            this.mReleaseTime = i;
            if (!this.mHandler.hasMessages(5)) {
                this.mHandler.sendEmptyMessage(5);
            }
            return true;
        }
    }

    public int getReleaseTime() {
        int i;
        synchronized (this) {
            i = this.mReleaseTime;
        }
        return i;
    }

    @VisibleForTesting
    public Handler getHandler() {
        return this.mHandler;
    }

    @VisibleForTesting
    public void destroy() {
        this.mHandler.removeCallbacksAndMessages((Object) null);
        this.mHandler.getLooper().quit();
        this.mRequestQueue.clear();
        this.mCallbacks.clear();
        unbindService();
        sGbaManagers.remove(this.mSubId);
    }

    /* access modifiers changed from: private */
    public void logv(String str) {
        if (DBG) {
            Rlog.d(this.mLogTag, str);
        }
    }

    /* access modifiers changed from: private */
    public void logd(String str) {
        Rlog.d(this.mLogTag, str);
    }

    /* access modifiers changed from: private */
    public void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }
}
