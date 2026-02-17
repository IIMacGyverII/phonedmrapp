package com.android.internal.telephony.ims;

import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.content.pm.ChangedPackages;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.IInterface;
import android.os.RemoteException;
import android.os.UserHandle;
import android.permission.LegacyPermissionManager;
import android.telephony.AnomalyReporter;
import android.telephony.ims.ImsService;
import android.telephony.ims.aidl.IImsConfig;
import android.telephony.ims.aidl.IImsRegistration;
import android.telephony.ims.aidl.IImsServiceController;
import android.telephony.ims.aidl.ISipTransport;
import android.telephony.ims.feature.ImsFeature;
import android.telephony.ims.stub.ImsFeatureConfiguration;
import android.util.Log;
import android.util.SparseIntArray;
import com.android.ims.ImsFeatureBinderRepository;
import com.android.ims.ImsFeatureContainer;
import com.android.ims.internal.IImsFeatureStatusCallback;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.ExponentialBackoff;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.data.DataServiceManager$$ExternalSyntheticLambda0;
import com.android.internal.telephony.util.TelephonyUtils;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.stream.Collectors;

public class ImsServiceController {
    private static final long CHANGE_PERMISSION_TIMEOUT_MS = 15000;
    private static final boolean ENFORCE_SINGLE_SERVICE_FOR_SIP_TRANSPORT = false;
    private static final String LOG_TAG = "ImsServiceController";
    private static final int REBIND_MAXIMUM_DELAY_MS = 60000;
    private static final int REBIND_START_DELAY_MS = 2000;
    private final UUID mAnomalyUUID;
    /* access modifiers changed from: private */
    public ExponentialBackoff mBackoff;
    /* access modifiers changed from: private */
    public ImsServiceControllerCallbacks mCallbacks;
    private ChangedPackages mChangedPackages;
    private final ComponentName mComponentName;
    protected final Context mContext;
    private ImsService.Listener mFeatureChangedListener;
    private Set<ImsFeatureStatusCallback> mFeatureStatusCallbacks;
    private final HandlerThread mHandlerThread;
    private IImsServiceController mIImsServiceController;
    /* access modifiers changed from: private */
    public Set<ImsFeatureConfiguration.FeatureSlotPair> mImsFeatures;
    private ImsServiceConnection mImsServiceConnection;
    /* access modifiers changed from: private */
    public boolean mIsBinding;
    /* access modifiers changed from: private */
    public boolean mIsBound;
    private int mLastSequenceNumber;
    /* access modifiers changed from: private */
    public final LocalLog mLocalLog;
    protected final Object mLock;
    private PackageManager mPackageManager;
    private final LegacyPermissionManager mPermissionManager;
    private RebindRetry mRebindRetry;
    /* access modifiers changed from: private */
    public ImsFeatureBinderRepository mRepo;
    private Runnable mRestartImsServiceRunnable;
    /* access modifiers changed from: private */
    public long mServiceCapabilities;
    /* access modifiers changed from: private */
    public SparseIntArray mSlotIdToSubIdMap;

    public interface ImsServiceControllerCallbacks {
        void imsServiceBindPermanentError(ComponentName componentName);

        void imsServiceFeatureCreated(int i, int i2, ImsServiceController imsServiceController);

        void imsServiceFeatureRemoved(int i, int i2, ImsServiceController imsServiceController);

        void imsServiceFeaturesChanged(ImsFeatureConfiguration imsFeatureConfiguration, ImsServiceController imsServiceController);
    }

    @VisibleForTesting
    public interface RebindRetry {
        long getMaximumDelay();

        long getStartDelay();
    }

    /* access modifiers changed from: protected */
    public String getServiceInterface() {
        return "android.telephony.ims.ImsService";
    }

    class ImsServiceConnection implements ServiceConnection {
        private boolean mIsServiceConnectionDead = false;

        ImsServiceConnection() {
        }

        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            synchronized (ImsServiceController.this.mLock) {
                ImsServiceController.this.mBackoff.stop();
                ImsServiceController.this.mIsBound = true;
                ImsServiceController.this.mIsBinding = false;
                try {
                    ImsServiceController.this.mLocalLog.log("onServiceConnected");
                    Log.d(ImsServiceController.LOG_TAG, "ImsService(" + componentName + "): onServiceConnected with binder: " + iBinder);
                    ImsServiceController.this.setServiceController(iBinder);
                    ImsServiceController.this.notifyImsServiceReady();
                    ImsServiceController.this.retrieveStaticImsServiceCapabilities();
                    for (ImsFeatureConfiguration.FeatureSlotPair featureSlotPair : ImsServiceController.this.mImsFeatures) {
                        ImsServiceController imsServiceController = ImsServiceController.this;
                        long r3 = imsServiceController.modifyCapabiltiesForSlot(imsServiceController.mImsFeatures, featureSlotPair.slotId, ImsServiceController.this.mServiceCapabilities);
                        ImsServiceController imsServiceController2 = ImsServiceController.this;
                        imsServiceController2.addImsServiceFeature(featureSlotPair, r3, imsServiceController2.mSlotIdToSubIdMap.get(featureSlotPair.slotId));
                    }
                } catch (RemoteException e) {
                    ImsServiceController.this.mIsBound = false;
                    ImsServiceController.this.mIsBinding = false;
                    cleanupConnection();
                    ImsServiceController.this.unbindService();
                    ImsServiceController.this.startDelayedRebindToService();
                    LocalLog r1 = ImsServiceController.this.mLocalLog;
                    r1.log("onConnected exception=" + e.getMessage() + ", retry in " + ImsServiceController.this.mBackoff.getCurrentDelay() + " mS");
                    StringBuilder sb = new StringBuilder();
                    sb.append("ImsService(");
                    sb.append(componentName);
                    sb.append(") RemoteException:");
                    sb.append(e.getMessage());
                    Log.e(ImsServiceController.LOG_TAG, sb.toString());
                }
            }
        }

        public void onServiceDisconnected(ComponentName componentName) {
            synchronized (ImsServiceController.this.mLock) {
                ImsServiceController.this.mIsBinding = false;
                cleanupConnection();
            }
            ImsServiceController.this.mLocalLog.log("onServiceDisconnected");
            Log.w(ImsServiceController.LOG_TAG, "ImsService(" + componentName + "): onServiceDisconnected. Waiting...");
            ImsServiceController.this.checkAndReportAnomaly(componentName);
        }

        public void onBindingDied(ComponentName componentName) {
            this.mIsServiceConnectionDead = true;
            synchronized (ImsServiceController.this.mLock) {
                ImsServiceController.this.mIsBinding = false;
                ImsServiceController.this.mIsBound = false;
                cleanupConnection();
                ImsServiceController.this.unbindService();
                ImsServiceController.this.startDelayedRebindToService();
            }
            Log.w(ImsServiceController.LOG_TAG, "ImsService(" + componentName + "): onBindingDied. Starting rebind...");
            LocalLog r4 = ImsServiceController.this.mLocalLog;
            r4.log("onBindingDied, retrying in " + ImsServiceController.this.mBackoff.getCurrentDelay() + " mS");
        }

        public void onNullBinding(ComponentName componentName) {
            Log.w(ImsServiceController.LOG_TAG, "ImsService(" + componentName + "): onNullBinding. Is service dead = " + this.mIsServiceConnectionDead);
            LocalLog r4 = ImsServiceController.this.mLocalLog;
            StringBuilder sb = new StringBuilder();
            sb.append("onNullBinding, is service dead = ");
            sb.append(this.mIsServiceConnectionDead);
            r4.log(sb.toString());
            if (!this.mIsServiceConnectionDead) {
                synchronized (ImsServiceController.this.mLock) {
                    ImsServiceController.this.mIsBinding = false;
                    ImsServiceController.this.mIsBound = true;
                    cleanupConnection();
                }
                if (ImsServiceController.this.mCallbacks != null) {
                    ImsServiceController.this.mCallbacks.imsServiceBindPermanentError(ImsServiceController.this.getComponentName());
                }
            }
        }

        private void cleanupConnection() {
            ImsServiceController.this.cleanupAllFeatures();
            ImsServiceController.this.setServiceController((IBinder) null);
        }
    }

    private class ImsFeatureStatusCallback {
        private final IImsFeatureStatusCallback mCallback = new IImsFeatureStatusCallback.Stub() {
            public void notifyImsFeatureStatus(int i) throws RemoteException {
                Log.i(ImsServiceController.LOG_TAG, "notifyImsFeatureStatus: slot=" + ImsFeatureStatusCallback.this.mSlotId + ", feature=" + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(ImsFeatureStatusCallback.this.mFeatureType))) + ", status=" + ((String) ImsFeature.STATE_LOG_MAP.get(Integer.valueOf(i))));
                ImsServiceController.this.mRepo.notifyFeatureStateChanged(ImsFeatureStatusCallback.this.mSlotId, ImsFeatureStatusCallback.this.mFeatureType, i);
            }
        };
        /* access modifiers changed from: private */
        public int mFeatureType;
        /* access modifiers changed from: private */
        public int mSlotId;

        ImsFeatureStatusCallback(int i, int i2) {
            this.mSlotId = i;
            this.mFeatureType = i2;
        }

        public IImsFeatureStatusCallback getCallback() {
            return this.mCallback;
        }
    }

    public ImsServiceController(Context context, ComponentName componentName, ImsServiceControllerCallbacks imsServiceControllerCallbacks, ImsFeatureBinderRepository imsFeatureBinderRepository) {
        this.mAnomalyUUID = UUID.fromString("e93b05e4-6d0a-4755-a6da-a2d2dbfb10d6");
        this.mLastSequenceNumber = 0;
        HandlerThread handlerThread = new HandlerThread("ImsServiceControllerHandler");
        this.mHandlerThread = handlerThread;
        this.mIsBound = false;
        this.mIsBinding = false;
        this.mFeatureStatusCallbacks = new HashSet();
        this.mLocalLog = new LocalLog(8);
        this.mLock = new Object();
        this.mFeatureChangedListener = new ImsService.Listener() {
            public void onUpdateSupportedImsFeatures(ImsFeatureConfiguration imsFeatureConfiguration) {
                if (ImsServiceController.this.mCallbacks != null) {
                    LocalLog r0 = ImsServiceController.this.mLocalLog;
                    r0.log("onUpdateSupportedImsFeatures to " + imsFeatureConfiguration.getServiceFeatures());
                    ImsServiceController.this.mCallbacks.imsServiceFeaturesChanged(imsFeatureConfiguration, ImsServiceController.this);
                }
            }
        };
        this.mRestartImsServiceRunnable = new Runnable() {
            public void run() {
                synchronized (ImsServiceController.this.mLock) {
                    if (!ImsServiceController.this.mIsBound) {
                        ImsServiceController imsServiceController = ImsServiceController.this;
                        imsServiceController.bind(imsServiceController.mImsFeatures, ImsServiceController.this.mSlotIdToSubIdMap);
                    }
                }
            }
        };
        this.mRebindRetry = new RebindRetry() {
            public long getMaximumDelay() {
                return 60000;
            }

            public long getStartDelay() {
                return LaunchConfig.ACTIVITY_CONSIDERED_RESUME;
            }
        };
        this.mContext = context;
        this.mComponentName = componentName;
        this.mCallbacks = imsServiceControllerCallbacks;
        handlerThread.start();
        this.mBackoff = new ExponentialBackoff(this.mRebindRetry.getStartDelay(), this.mRebindRetry.getMaximumDelay(), 2, handlerThread.getLooper(), this.mRestartImsServiceRunnable);
        this.mPermissionManager = (LegacyPermissionManager) context.getSystemService("legacy_permission");
        this.mRepo = imsFeatureBinderRepository;
        PackageManager packageManager = context.getPackageManager();
        this.mPackageManager = packageManager;
        if (packageManager != null) {
            ChangedPackages changedPackages = packageManager.getChangedPackages(this.mLastSequenceNumber);
            this.mChangedPackages = changedPackages;
            if (changedPackages != null) {
                this.mLastSequenceNumber = changedPackages.getSequenceNumber();
            }
        }
    }

    @VisibleForTesting
    public ImsServiceController(Context context, ComponentName componentName, ImsServiceControllerCallbacks imsServiceControllerCallbacks, Handler handler, RebindRetry rebindRetry, ImsFeatureBinderRepository imsFeatureBinderRepository) {
        this.mAnomalyUUID = UUID.fromString("e93b05e4-6d0a-4755-a6da-a2d2dbfb10d6");
        this.mLastSequenceNumber = 0;
        this.mHandlerThread = new HandlerThread("ImsServiceControllerHandler");
        this.mIsBound = false;
        this.mIsBinding = false;
        this.mFeatureStatusCallbacks = new HashSet();
        this.mLocalLog = new LocalLog(8);
        this.mLock = new Object();
        this.mFeatureChangedListener = new ImsService.Listener() {
            public void onUpdateSupportedImsFeatures(ImsFeatureConfiguration imsFeatureConfiguration) {
                if (ImsServiceController.this.mCallbacks != null) {
                    LocalLog r0 = ImsServiceController.this.mLocalLog;
                    r0.log("onUpdateSupportedImsFeatures to " + imsFeatureConfiguration.getServiceFeatures());
                    ImsServiceController.this.mCallbacks.imsServiceFeaturesChanged(imsFeatureConfiguration, ImsServiceController.this);
                }
            }
        };
        this.mRestartImsServiceRunnable = new Runnable() {
            public void run() {
                synchronized (ImsServiceController.this.mLock) {
                    if (!ImsServiceController.this.mIsBound) {
                        ImsServiceController imsServiceController = ImsServiceController.this;
                        imsServiceController.bind(imsServiceController.mImsFeatures, ImsServiceController.this.mSlotIdToSubIdMap);
                    }
                }
            }
        };
        this.mRebindRetry = new RebindRetry() {
            public long getMaximumDelay() {
                return 60000;
            }

            public long getStartDelay() {
                return LaunchConfig.ACTIVITY_CONSIDERED_RESUME;
            }
        };
        this.mContext = context;
        this.mComponentName = componentName;
        this.mCallbacks = imsServiceControllerCallbacks;
        this.mBackoff = new ExponentialBackoff(rebindRetry.getStartDelay(), rebindRetry.getMaximumDelay(), 2, handler, this.mRestartImsServiceRunnable);
        this.mPermissionManager = null;
        this.mRepo = imsFeatureBinderRepository;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:20:0x0101, code lost:
        return false;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean bind(java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration.FeatureSlotPair> r7, android.util.SparseIntArray r8) {
        /*
            r6 = this;
            java.lang.Object r0 = r6.mLock
            monitor-enter(r0)
            boolean r1 = r6.mIsBound     // Catch:{ all -> 0x0102 }
            r2 = 0
            if (r1 != 0) goto L_0x0100
            boolean r1 = r6.mIsBinding     // Catch:{ all -> 0x0102 }
            if (r1 != 0) goto L_0x0100
            r1 = 1
            r6.mIsBinding = r1     // Catch:{ all -> 0x0102 }
            r6.sanitizeFeatureConfig(r7)     // Catch:{ all -> 0x0102 }
            r6.mImsFeatures = r7     // Catch:{ all -> 0x0102 }
            r6.mSlotIdToSubIdMap = r8     // Catch:{ all -> 0x0102 }
            r6.grantPermissionsToService()     // Catch:{ all -> 0x0102 }
            android.content.Intent r8 = new android.content.Intent     // Catch:{ all -> 0x0102 }
            java.lang.String r1 = r6.getServiceInterface()     // Catch:{ all -> 0x0102 }
            r8.<init>(r1)     // Catch:{ all -> 0x0102 }
            android.content.ComponentName r1 = r6.mComponentName     // Catch:{ all -> 0x0102 }
            android.content.Intent r8 = r8.setComponent(r1)     // Catch:{ all -> 0x0102 }
            com.android.internal.telephony.ims.ImsServiceController$ImsServiceConnection r1 = new com.android.internal.telephony.ims.ImsServiceController$ImsServiceConnection     // Catch:{ all -> 0x0102 }
            r1.<init>()     // Catch:{ all -> 0x0102 }
            r6.mImsServiceConnection = r1     // Catch:{ all -> 0x0102 }
            r1 = 67108929(0x4000041, float:1.5046444E-36)
            com.android.internal.telephony.LocalLog r3 = r6.mLocalLog     // Catch:{ all -> 0x0102 }
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x0102 }
            r4.<init>()     // Catch:{ all -> 0x0102 }
            java.lang.String r5 = "binding "
            r4.append(r5)     // Catch:{ all -> 0x0102 }
            r4.append(r7)     // Catch:{ all -> 0x0102 }
            java.lang.String r7 = r4.toString()     // Catch:{ all -> 0x0102 }
            r3.log(r7)     // Catch:{ all -> 0x0102 }
            java.lang.String r7 = "ImsServiceController"
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x0102 }
            r3.<init>()     // Catch:{ all -> 0x0102 }
            java.lang.String r4 = "Binding ImsService:"
            r3.append(r4)     // Catch:{ all -> 0x0102 }
            android.content.ComponentName r4 = r6.mComponentName     // Catch:{ all -> 0x0102 }
            r3.append(r4)     // Catch:{ all -> 0x0102 }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x0102 }
            android.util.Log.i(r7, r3)     // Catch:{ all -> 0x0102 }
            android.content.Context r7 = r6.mContext     // Catch:{ Exception -> 0x0094 }
            com.android.internal.telephony.ims.ImsServiceController$ImsServiceConnection r3 = r6.mImsServiceConnection     // Catch:{ Exception -> 0x0094 }
            boolean r7 = r7.bindService(r8, r3, r1)     // Catch:{ Exception -> 0x0094 }
            if (r7 != 0) goto L_0x0092
            com.android.internal.telephony.LocalLog r8 = r6.mLocalLog     // Catch:{ Exception -> 0x0094 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x0094 }
            r1.<init>()     // Catch:{ Exception -> 0x0094 }
            java.lang.String r3 = "    binding failed, retrying in "
            r1.append(r3)     // Catch:{ Exception -> 0x0094 }
            com.android.internal.telephony.ExponentialBackoff r3 = r6.mBackoff     // Catch:{ Exception -> 0x0094 }
            long r3 = r3.getCurrentDelay()     // Catch:{ Exception -> 0x0094 }
            r1.append(r3)     // Catch:{ Exception -> 0x0094 }
            java.lang.String r3 = " mS"
            r1.append(r3)     // Catch:{ Exception -> 0x0094 }
            java.lang.String r1 = r1.toString()     // Catch:{ Exception -> 0x0094 }
            r8.log(r1)     // Catch:{ Exception -> 0x0094 }
            r6.mIsBinding = r2     // Catch:{ Exception -> 0x0094 }
            com.android.internal.telephony.ExponentialBackoff r8 = r6.mBackoff     // Catch:{ Exception -> 0x0094 }
            r8.notifyFailed()     // Catch:{ Exception -> 0x0094 }
        L_0x0092:
            monitor-exit(r0)     // Catch:{ all -> 0x0102 }
            return r7
        L_0x0094:
            r7 = move-exception
            com.android.internal.telephony.ExponentialBackoff r8 = r6.mBackoff     // Catch:{ all -> 0x0102 }
            r8.notifyFailed()     // Catch:{ all -> 0x0102 }
            com.android.internal.telephony.LocalLog r8 = r6.mLocalLog     // Catch:{ all -> 0x0102 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0102 }
            r1.<init>()     // Catch:{ all -> 0x0102 }
            java.lang.String r3 = "    binding exception="
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            java.lang.String r3 = r7.getMessage()     // Catch:{ all -> 0x0102 }
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            java.lang.String r3 = ", retrying in "
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            com.android.internal.telephony.ExponentialBackoff r3 = r6.mBackoff     // Catch:{ all -> 0x0102 }
            long r3 = r3.getCurrentDelay()     // Catch:{ all -> 0x0102 }
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            java.lang.String r3 = " mS"
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x0102 }
            r8.log(r1)     // Catch:{ all -> 0x0102 }
            java.lang.String r8 = "ImsServiceController"
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0102 }
            r1.<init>()     // Catch:{ all -> 0x0102 }
            java.lang.String r3 = "Error binding ("
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            android.content.ComponentName r3 = r6.mComponentName     // Catch:{ all -> 0x0102 }
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            java.lang.String r3 = ") with exception: "
            r1.append(r3)     // Catch:{ all -> 0x0102 }
            java.lang.String r7 = r7.getMessage()     // Catch:{ all -> 0x0102 }
            r1.append(r7)     // Catch:{ all -> 0x0102 }
            java.lang.String r7 = ", rebinding in "
            r1.append(r7)     // Catch:{ all -> 0x0102 }
            com.android.internal.telephony.ExponentialBackoff r6 = r6.mBackoff     // Catch:{ all -> 0x0102 }
            long r6 = r6.getCurrentDelay()     // Catch:{ all -> 0x0102 }
            r1.append(r6)     // Catch:{ all -> 0x0102 }
            java.lang.String r6 = " ms"
            r1.append(r6)     // Catch:{ all -> 0x0102 }
            java.lang.String r6 = r1.toString()     // Catch:{ all -> 0x0102 }
            android.util.Log.e(r8, r6)     // Catch:{ all -> 0x0102 }
            monitor-exit(r0)     // Catch:{ all -> 0x0102 }
            return r2
        L_0x0100:
            monitor-exit(r0)     // Catch:{ all -> 0x0102 }
            return r2
        L_0x0102:
            r6 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0102 }
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ims.ImsServiceController.bind(java.util.Set, android.util.SparseIntArray):boolean");
    }

    private void sanitizeFeatureConfig(Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        for (ImsFeatureConfiguration.FeatureSlotPair featureSlotPair : (Set) set.stream().filter(new ImsServiceController$$ExternalSyntheticLambda7()).collect(Collectors.toSet())) {
            if (!set.contains(new ImsFeatureConfiguration.FeatureSlotPair(featureSlotPair.slotId, 1))) {
                set.remove(featureSlotPair);
            }
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$sanitizeFeatureConfig$0(ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.featureType == 0;
    }

    public void unbind() throws RemoteException {
        synchronized (this.mLock) {
            this.mBackoff.stop();
            changeImsServiceFeatures(new HashSet(), this.mSlotIdToSubIdMap);
            this.mIsBound = false;
            this.mIsBinding = false;
            setServiceController((IBinder) null);
            unbindService();
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:43:0x01fe, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void changeImsServiceFeatures(java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration.FeatureSlotPair> r13, android.util.SparseIntArray r14) throws android.os.RemoteException {
        /*
            r12 = this;
            r12.sanitizeFeatureConfig(r13)
            java.lang.Object r0 = r12.mLock
            monitor-enter(r0)
            java.util.stream.Stream r1 = r13.stream()     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda4 r2 = new com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda4     // Catch:{ all -> 0x01ff }
            r2.<init>()     // Catch:{ all -> 0x01ff }
            java.util.stream.Stream r1 = r1.map(r2)     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda5 r2 = new com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda5     // Catch:{ all -> 0x01ff }
            r2.<init>()     // Catch:{ all -> 0x01ff }
            java.util.stream.Collector r2 = java.util.stream.Collectors.toCollection(r2)     // Catch:{ all -> 0x01ff }
            java.lang.Object r1 = r1.collect(r2)     // Catch:{ all -> 0x01ff }
            java.util.HashSet r1 = (java.util.HashSet) r1     // Catch:{ all -> 0x01ff }
            android.util.SparseIntArray r2 = new android.util.SparseIntArray     // Catch:{ all -> 0x01ff }
            int r3 = r1.size()     // Catch:{ all -> 0x01ff }
            r2.<init>(r3)     // Catch:{ all -> 0x01ff }
            java.util.Iterator r1 = r1.iterator()     // Catch:{ all -> 0x01ff }
        L_0x002f:
            boolean r3 = r1.hasNext()     // Catch:{ all -> 0x01ff }
            if (r3 == 0) goto L_0x00a6
            java.lang.Object r3 = r1.next()     // Catch:{ all -> 0x01ff }
            java.lang.Integer r3 = (java.lang.Integer) r3     // Catch:{ all -> 0x01ff }
            android.util.SparseIntArray r4 = r12.mSlotIdToSubIdMap     // Catch:{ all -> 0x01ff }
            int r5 = r3.intValue()     // Catch:{ all -> 0x01ff }
            r6 = -2
            int r4 = r4.get(r5, r6)     // Catch:{ all -> 0x01ff }
            int r5 = r3.intValue()     // Catch:{ all -> 0x01ff }
            int r5 = r14.get(r5)     // Catch:{ all -> 0x01ff }
            if (r4 == r5) goto L_0x002f
            int r6 = r3.intValue()     // Catch:{ all -> 0x01ff }
            r2.put(r6, r5)     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.LocalLog r6 = r12.mLocalLog     // Catch:{ all -> 0x01ff }
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r7.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r8 = "subId changed for slot: "
            r7.append(r8)     // Catch:{ all -> 0x01ff }
            r7.append(r3)     // Catch:{ all -> 0x01ff }
            java.lang.String r8 = ", "
            r7.append(r8)     // Catch:{ all -> 0x01ff }
            r7.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r8 = " -> "
            r7.append(r8)     // Catch:{ all -> 0x01ff }
            r7.append(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x01ff }
            r6.log(r7)     // Catch:{ all -> 0x01ff }
            java.lang.String r6 = "ImsServiceController"
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r7.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r8 = "subId changed for slot: "
            r7.append(r8)     // Catch:{ all -> 0x01ff }
            r7.append(r3)     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = ", "
            r7.append(r3)     // Catch:{ all -> 0x01ff }
            r7.append(r4)     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = " -> "
            r7.append(r3)     // Catch:{ all -> 0x01ff }
            r7.append(r5)     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = r7.toString()     // Catch:{ all -> 0x01ff }
            android.util.Log.i(r6, r3)     // Catch:{ all -> 0x01ff }
            goto L_0x002f
        L_0x00a6:
            r12.mSlotIdToSubIdMap = r14     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r14 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            boolean r14 = r14.equals(r13)     // Catch:{ all -> 0x01ff }
            if (r14 == 0) goto L_0x00b8
            int r14 = r2.size()     // Catch:{ all -> 0x01ff }
            if (r14 != 0) goto L_0x00b8
            monitor-exit(r0)     // Catch:{ all -> 0x01ff }
            return
        L_0x00b8:
            com.android.internal.telephony.LocalLog r14 = r12.mLocalLog     // Catch:{ all -> 0x01ff }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r1.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = "Features ("
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r3 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = "->"
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            r1.append(r13)     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = ")"
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x01ff }
            r14.log(r1)     // Catch:{ all -> 0x01ff }
            java.lang.String r14 = "ImsServiceController"
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x01ff }
            r1.<init>()     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = "Features ("
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r3 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = "->"
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            r1.append(r13)     // Catch:{ all -> 0x01ff }
            java.lang.String r3 = ") for ImsService: "
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            android.content.ComponentName r3 = r12.mComponentName     // Catch:{ all -> 0x01ff }
            r1.append(r3)     // Catch:{ all -> 0x01ff }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x01ff }
            android.util.Log.i(r14, r1)     // Catch:{ all -> 0x01ff }
            java.util.HashSet r14 = new java.util.HashSet     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r1 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            r14.<init>(r1)     // Catch:{ all -> 0x01ff }
            r12.mImsFeatures = r13     // Catch:{ all -> 0x01ff }
            boolean r13 = r12.mIsBound     // Catch:{ all -> 0x01ff }
            if (r13 == 0) goto L_0x01fd
            java.util.HashSet r13 = new java.util.HashSet     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r1 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            r13.<init>(r1)     // Catch:{ all -> 0x01ff }
            r13.removeAll(r14)     // Catch:{ all -> 0x01ff }
            java.util.Iterator r1 = r13.iterator()     // Catch:{ all -> 0x01ff }
        L_0x0122:
            boolean r3 = r1.hasNext()     // Catch:{ all -> 0x01ff }
            if (r3 == 0) goto L_0x0144
            java.lang.Object r3 = r1.next()     // Catch:{ all -> 0x01ff }
            android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair r3 = (android.telephony.ims.stub.ImsFeatureConfiguration.FeatureSlotPair) r3     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r4 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            int r5 = r3.slotId     // Catch:{ all -> 0x01ff }
            long r6 = r12.mServiceCapabilities     // Catch:{ all -> 0x01ff }
            long r4 = r12.modifyCapabiltiesForSlot(r4, r5, r6)     // Catch:{ all -> 0x01ff }
            android.util.SparseIntArray r6 = r12.mSlotIdToSubIdMap     // Catch:{ all -> 0x01ff }
            int r7 = r3.slotId     // Catch:{ all -> 0x01ff }
            int r6 = r6.get(r7)     // Catch:{ all -> 0x01ff }
            r12.addImsServiceFeature(r3, r4, r6)     // Catch:{ all -> 0x01ff }
            goto L_0x0122
        L_0x0144:
            java.util.HashSet r1 = new java.util.HashSet     // Catch:{ all -> 0x01ff }
            r1.<init>(r14)     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r14 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            r1.removeAll(r14)     // Catch:{ all -> 0x01ff }
            java.util.Iterator r14 = r1.iterator()     // Catch:{ all -> 0x01ff }
        L_0x0152:
            boolean r3 = r14.hasNext()     // Catch:{ all -> 0x01ff }
            r4 = 0
            if (r3 == 0) goto L_0x0163
            java.lang.Object r3 = r14.next()     // Catch:{ all -> 0x01ff }
            android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair r3 = (android.telephony.ims.stub.ImsFeatureConfiguration.FeatureSlotPair) r3     // Catch:{ all -> 0x01ff }
            r12.removeImsServiceFeature(r3, r4)     // Catch:{ all -> 0x01ff }
            goto L_0x0152
        L_0x0163:
            java.util.HashSet r14 = new java.util.HashSet     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r3 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            r14.<init>(r3)     // Catch:{ all -> 0x01ff }
            r14.removeAll(r1)     // Catch:{ all -> 0x01ff }
            r14.removeAll(r13)     // Catch:{ all -> 0x01ff }
            int r13 = r2.size()     // Catch:{ all -> 0x01ff }
            if (r13 <= 0) goto L_0x01d9
            int[] r13 = r2.copyKeys()     // Catch:{ all -> 0x01ff }
            int r1 = r13.length     // Catch:{ all -> 0x01ff }
        L_0x017b:
            if (r4 >= r1) goto L_0x01d9
            r3 = r13[r4]     // Catch:{ all -> 0x01ff }
            r5 = -1
            int r5 = r2.get(r3, r5)     // Catch:{ all -> 0x01ff }
            java.util.stream.Stream r6 = r14.stream()     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda6 r7 = new com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda6     // Catch:{ all -> 0x01ff }
            r7.<init>(r3)     // Catch:{ all -> 0x01ff }
            java.util.stream.Stream r3 = r6.filter(r7)     // Catch:{ all -> 0x01ff }
            com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda5 r6 = new com.android.internal.telephony.ims.ImsServiceController$$ExternalSyntheticLambda5     // Catch:{ all -> 0x01ff }
            r6.<init>()     // Catch:{ all -> 0x01ff }
            java.util.stream.Collector r6 = java.util.stream.Collectors.toCollection(r6)     // Catch:{ all -> 0x01ff }
            java.lang.Object r3 = r3.collect(r6)     // Catch:{ all -> 0x01ff }
            java.util.HashSet r3 = (java.util.HashSet) r3     // Catch:{ all -> 0x01ff }
            java.util.Iterator r6 = r3.iterator()     // Catch:{ all -> 0x01ff }
        L_0x01a4:
            boolean r7 = r6.hasNext()     // Catch:{ all -> 0x01ff }
            if (r7 == 0) goto L_0x01b5
            java.lang.Object r7 = r6.next()     // Catch:{ all -> 0x01ff }
            android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair r7 = (android.telephony.ims.stub.ImsFeatureConfiguration.FeatureSlotPair) r7     // Catch:{ all -> 0x01ff }
            r8 = 1
            r12.removeImsServiceFeature(r7, r8)     // Catch:{ all -> 0x01ff }
            goto L_0x01a4
        L_0x01b5:
            java.util.Iterator r6 = r3.iterator()     // Catch:{ all -> 0x01ff }
        L_0x01b9:
            boolean r7 = r6.hasNext()     // Catch:{ all -> 0x01ff }
            if (r7 == 0) goto L_0x01d3
            java.lang.Object r7 = r6.next()     // Catch:{ all -> 0x01ff }
            android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair r7 = (android.telephony.ims.stub.ImsFeatureConfiguration.FeatureSlotPair) r7     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r8 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            int r9 = r7.slotId     // Catch:{ all -> 0x01ff }
            long r10 = r12.mServiceCapabilities     // Catch:{ all -> 0x01ff }
            long r8 = r12.modifyCapabiltiesForSlot(r8, r9, r10)     // Catch:{ all -> 0x01ff }
            r12.addImsServiceFeature(r7, r8, r5)     // Catch:{ all -> 0x01ff }
            goto L_0x01b9
        L_0x01d3:
            r14.removeAll(r3)     // Catch:{ all -> 0x01ff }
            int r4 = r4 + 1
            goto L_0x017b
        L_0x01d9:
            java.util.Iterator r13 = r14.iterator()     // Catch:{ all -> 0x01ff }
        L_0x01dd:
            boolean r14 = r13.hasNext()     // Catch:{ all -> 0x01ff }
            if (r14 == 0) goto L_0x01fd
            java.lang.Object r14 = r13.next()     // Catch:{ all -> 0x01ff }
            android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair r14 = (android.telephony.ims.stub.ImsFeatureConfiguration.FeatureSlotPair) r14     // Catch:{ all -> 0x01ff }
            java.util.Set<android.telephony.ims.stub.ImsFeatureConfiguration$FeatureSlotPair> r1 = r12.mImsFeatures     // Catch:{ all -> 0x01ff }
            int r2 = r14.slotId     // Catch:{ all -> 0x01ff }
            long r3 = r12.mServiceCapabilities     // Catch:{ all -> 0x01ff }
            long r1 = r12.modifyCapabiltiesForSlot(r1, r2, r3)     // Catch:{ all -> 0x01ff }
            com.android.ims.ImsFeatureBinderRepository r3 = r12.mRepo     // Catch:{ all -> 0x01ff }
            int r4 = r14.slotId     // Catch:{ all -> 0x01ff }
            int r14 = r14.featureType     // Catch:{ all -> 0x01ff }
            r3.notifyFeatureCapabilitiesChanged(r4, r14, r1)     // Catch:{ all -> 0x01ff }
            goto L_0x01dd
        L_0x01fd:
            monitor-exit(r0)     // Catch:{ all -> 0x01ff }
            return
        L_0x01ff:
            r12 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x01ff }
            throw r12
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ims.ImsServiceController.changeImsServiceFeatures(java.util.Set, android.util.SparseIntArray):void");
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$changeImsServiceFeatures$2(int i, ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.slotId == i;
    }

    @VisibleForTesting
    public IImsServiceController getImsServiceController() {
        return this.mIImsServiceController;
    }

    @VisibleForTesting
    public long getRebindDelay() {
        return this.mBackoff.getCurrentDelay();
    }

    @VisibleForTesting
    public void stopBackoffTimerForTesting() {
        this.mBackoff.stop();
    }

    public ComponentName getComponentName() {
        return this.mComponentName;
    }

    public void enableIms(int i, int i2) {
        try {
            synchronized (this.mLock) {
                if (isServiceControllerAvailable()) {
                    this.mIImsServiceController.enableIms(i, i2);
                }
            }
        } catch (RemoteException e) {
            Log.w(LOG_TAG, "Couldn't enable IMS: " + e.getMessage());
        }
    }

    public void disableIms(int i, int i2) {
        try {
            synchronized (this.mLock) {
                if (isServiceControllerAvailable()) {
                    this.mIImsServiceController.disableIms(i, i2);
                }
            }
        } catch (RemoteException e) {
            Log.w(LOG_TAG, "Couldn't disable IMS: " + e.getMessage());
        }
    }

    public IImsRegistration getRegistration(int i, int i2) throws RemoteException {
        IImsRegistration registration;
        synchronized (this.mLock) {
            registration = isServiceControllerAvailable() ? this.mIImsServiceController.getRegistration(i, i2) : null;
        }
        return registration;
    }

    public IImsConfig getConfig(int i, int i2) throws RemoteException {
        IImsConfig config;
        synchronized (this.mLock) {
            config = isServiceControllerAvailable() ? this.mIImsServiceController.getConfig(i, i2) : null;
        }
        return config;
    }

    public ISipTransport getSipTransport(int i) throws RemoteException {
        ISipTransport sipTransport;
        synchronized (this.mLock) {
            sipTransport = isServiceControllerAvailable() ? this.mIImsServiceController.getSipTransport(i) : null;
        }
        return sipTransport;
    }

    /* access modifiers changed from: protected */
    public long getStaticServiceCapabilities() throws RemoteException {
        long imsServiceCapabilities;
        synchronized (this.mLock) {
            imsServiceCapabilities = isServiceControllerAvailable() ? this.mIImsServiceController.getImsServiceCapabilities() : 0;
        }
        return imsServiceCapabilities;
    }

    /* access modifiers changed from: protected */
    public void notifyImsServiceReady() throws RemoteException {
        synchronized (this.mLock) {
            if (isServiceControllerAvailable()) {
                Log.d(LOG_TAG, "notifyImsServiceReady");
                this.mIImsServiceController.setListener(this.mFeatureChangedListener);
                this.mIImsServiceController.notifyImsServiceReadyForFeatureCreation();
            }
        }
    }

    /* access modifiers changed from: private */
    public void retrieveStaticImsServiceCapabilities() throws RemoteException {
        long staticServiceCapabilities = getStaticServiceCapabilities();
        Log.i(LOG_TAG, "retrieveStaticImsServiceCapabilities: " + ImsService.getCapabilitiesString(staticServiceCapabilities));
        LocalLog localLog = this.mLocalLog;
        localLog.log("retrieveStaticImsServiceCapabilities: " + ImsService.getCapabilitiesString(staticServiceCapabilities));
        synchronized (this.mLock) {
            this.mServiceCapabilities = staticServiceCapabilities;
        }
    }

    /* access modifiers changed from: protected */
    public void setServiceController(IBinder iBinder) {
        this.mIImsServiceController = IImsServiceController.Stub.asInterface(iBinder);
    }

    /* access modifiers changed from: protected */
    public boolean isServiceControllerAvailable() {
        return this.mIImsServiceController != null;
    }

    /* access modifiers changed from: private */
    public void startDelayedRebindToService() {
        this.mBackoff.start();
    }

    /* access modifiers changed from: private */
    public void unbindService() {
        synchronized (this.mLock) {
            if (this.mImsServiceConnection != null) {
                Log.i(LOG_TAG, "Unbinding ImsService: " + this.mComponentName);
                LocalLog localLog = this.mLocalLog;
                localLog.log("unbinding: " + this.mComponentName);
                this.mContext.unbindService(this.mImsServiceConnection);
                this.mImsServiceConnection = null;
            } else {
                Log.i(LOG_TAG, "unbindService called on already unbound ImsService: " + this.mComponentName);
                LocalLog localLog2 = this.mLocalLog;
                localLog2.log("Note: unbindService called with no ServiceConnection on " + this.mComponentName);
            }
        }
    }

    /* access modifiers changed from: private */
    public long modifyCapabiltiesForSlot(Set<ImsFeatureConfiguration.FeatureSlotPair> set, int i, long j) {
        if (getFeaturesForSlot(i, set).contains(0)) {
            j |= 1;
        }
        Log.i(LOG_TAG, "skipping single service enforce check...");
        return j;
    }

    private void grantPermissionsToService() {
        LocalLog localLog = this.mLocalLog;
        localLog.log("grant permissions to " + getComponentName());
        Log.i(LOG_TAG, "Granting Runtime permissions to:" + getComponentName());
        String[] strArr = {this.mComponentName.getPackageName()};
        try {
            if (this.mPermissionManager != null) {
                CountDownLatch countDownLatch = new CountDownLatch(1);
                this.mPermissionManager.grantDefaultPermissionsToEnabledImsServices(strArr, UserHandle.of(UserHandle.myUserId()), new DataServiceManager$$ExternalSyntheticLambda0(), new ImsServiceController$$ExternalSyntheticLambda3(countDownLatch));
                TelephonyUtils.waitUntilReady(countDownLatch, CHANGE_PERMISSION_TIMEOUT_MS);
            }
        } catch (RuntimeException unused) {
            Log.w(LOG_TAG, "Unable to grant permissions, binder died.");
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$grantPermissionsToService$3(CountDownLatch countDownLatch, Boolean bool) {
        if (bool.booleanValue()) {
            countDownLatch.countDown();
        } else {
            Log.e(LOG_TAG, "Failed to grant permissions to service.");
        }
    }

    /* access modifiers changed from: private */
    public void addImsServiceFeature(ImsFeatureConfiguration.FeatureSlotPair featureSlotPair, long j, int i) throws RemoteException {
        if (!isServiceControllerAvailable() || this.mCallbacks == null) {
            Log.w(LOG_TAG, "addImsServiceFeature called with null values.");
            return;
        }
        int i2 = featureSlotPair.featureType;
        if (i2 != 0) {
            int i3 = i;
            addImsFeatureBinder(featureSlotPair.slotId, i3, featureSlotPair.featureType, createImsFeature(featureSlotPair.slotId, i3, i2, j), j);
            addImsFeatureStatusCallback(featureSlotPair.slotId, featureSlotPair.featureType);
        } else {
            Log.i(LOG_TAG, "supports emergency calling on slot " + featureSlotPair.slotId);
        }
        this.mCallbacks.imsServiceFeatureCreated(featureSlotPair.slotId, featureSlotPair.featureType, this);
    }

    private void removeImsServiceFeature(ImsFeatureConfiguration.FeatureSlotPair featureSlotPair, boolean z) {
        ImsServiceControllerCallbacks imsServiceControllerCallbacks;
        if (!isServiceControllerAvailable() || (imsServiceControllerCallbacks = this.mCallbacks) == null) {
            Log.w(LOG_TAG, "removeImsServiceFeature called with null values.");
            return;
        }
        imsServiceControllerCallbacks.imsServiceFeatureRemoved(featureSlotPair.slotId, featureSlotPair.featureType, this);
        int i = featureSlotPair.featureType;
        if (i != 0) {
            removeImsFeatureStatusCallback(featureSlotPair.slotId, i);
            removeImsFeatureBinder(featureSlotPair.slotId, featureSlotPair.featureType);
            try {
                removeImsFeature(featureSlotPair.slotId, featureSlotPair.featureType, z);
            } catch (RemoteException e) {
                Log.i(LOG_TAG, "Couldn't remove feature {" + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(featureSlotPair.featureType))) + "}, connection is down: " + e.getMessage());
            }
        } else {
            Log.i(LOG_TAG, "doesn't support emergency calling on slot " + featureSlotPair.slotId);
        }
    }

    /* access modifiers changed from: protected */
    public IInterface createImsFeature(int i, int i2, int i3, long j) throws RemoteException {
        boolean z = true;
        if (i3 != 1) {
            if (i3 != 2) {
                return null;
            }
            return this.mIImsServiceController.createRcsFeature(i, i2);
        } else if (i2 != -1) {
            return this.mIImsServiceController.createMmTelFeature(i, i2);
        } else {
            if ((1 & j) <= 0) {
                z = false;
            }
            if (z) {
                return this.mIImsServiceController.createEmergencyOnlyMmTelFeature(i);
            }
            return null;
        }
    }

    private void addImsFeatureStatusCallback(int i, int i2) throws RemoteException {
        ImsFeatureStatusCallback imsFeatureStatusCallback = new ImsFeatureStatusCallback(i, i2);
        this.mFeatureStatusCallbacks.add(imsFeatureStatusCallback);
        registerImsFeatureStatusCallback(i, i2, imsFeatureStatusCallback.getCallback());
    }

    private void removeImsFeatureStatusCallback(int i, int i2) {
        ImsFeatureStatusCallback imsFeatureStatusCallback = (ImsFeatureStatusCallback) this.mFeatureStatusCallbacks.stream().filter(new ImsServiceController$$ExternalSyntheticLambda2(i, i2)).findFirst().orElse((Object) null);
        if (imsFeatureStatusCallback != null) {
            this.mFeatureStatusCallbacks.remove(imsFeatureStatusCallback);
            unregisterImsFeatureStatusCallback(i, i2, imsFeatureStatusCallback.getCallback());
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$removeImsFeatureStatusCallback$4(int i, int i2, ImsFeatureStatusCallback imsFeatureStatusCallback) {
        return imsFeatureStatusCallback.mSlotId == i && imsFeatureStatusCallback.mFeatureType == i2;
    }

    /* access modifiers changed from: protected */
    public void registerImsFeatureStatusCallback(int i, int i2, IImsFeatureStatusCallback iImsFeatureStatusCallback) throws RemoteException {
        this.mIImsServiceController.addFeatureStatusCallback(i, i2, iImsFeatureStatusCallback);
    }

    /* access modifiers changed from: protected */
    public void unregisterImsFeatureStatusCallback(int i, int i2, IImsFeatureStatusCallback iImsFeatureStatusCallback) {
        try {
            this.mIImsServiceController.removeFeatureStatusCallback(i, i2, iImsFeatureStatusCallback);
        } catch (RemoteException unused) {
            LocalLog localLog = this.mLocalLog;
            localLog.log("unregisterImsFeatureStatusCallback - couldn't remove " + iImsFeatureStatusCallback);
        }
    }

    /* access modifiers changed from: protected */
    public void removeImsFeature(int i, int i2, boolean z) throws RemoteException {
        this.mIImsServiceController.removeImsFeature(i, i2, z);
    }

    private void addImsFeatureBinder(int i, int i2, int i3, IInterface iInterface, long j) throws RemoteException {
        if (iInterface == null) {
            Log.w(LOG_TAG, "addImsFeatureBinder: null IInterface reported for " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i3))));
            LocalLog localLog = this.mLocalLog;
            localLog.log("addImsFeatureBinder: null IInterface reported for " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i3))));
            return;
        }
        this.mRepo.addConnection(i, i2, i3, createFeatureContainer(i, i2, iInterface.asBinder(), j));
    }

    private void removeImsFeatureBinder(int i, int i2) {
        this.mRepo.removeConnection(i, i2);
    }

    private ImsFeatureContainer createFeatureContainer(int i, int i2, IBinder iBinder, long j) throws RemoteException {
        IImsConfig config = getConfig(i, i2);
        IImsRegistration registration = getRegistration(i, i2);
        if (config == null || registration == null) {
            Log.w(LOG_TAG, "createFeatureContainer: invalid state. Reporting as not available. componentName= " + getComponentName());
            this.mLocalLog.log("createFeatureContainer: invalid state. Reporting as not available.");
            return null;
        }
        return new ImsFeatureContainer(iBinder, config, registration, getSipTransport(i), j);
    }

    private List<Integer> getFeaturesForSlot(int i, Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        return (List) set.stream().filter(new ImsServiceController$$ExternalSyntheticLambda0(i)).map(new ImsServiceController$$ExternalSyntheticLambda1()).collect(Collectors.toList());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getFeaturesForSlot$5(int i, ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.slotId == i;
    }

    /* access modifiers changed from: private */
    public void cleanupAllFeatures() {
        synchronized (this.mLock) {
            for (ImsFeatureConfiguration.FeatureSlotPair removeImsServiceFeature : this.mImsFeatures) {
                removeImsServiceFeature(removeImsServiceFeature, false);
            }
        }
    }

    /* access modifiers changed from: private */
    public void checkAndReportAnomaly(ComponentName componentName) {
        PackageManager packageManager = this.mPackageManager;
        if (packageManager == null) {
            Log.w(LOG_TAG, "mPackageManager null");
            return;
        }
        ChangedPackages changedPackages = packageManager.getChangedPackages(this.mLastSequenceNumber);
        if (changedPackages != null) {
            this.mLastSequenceNumber = changedPackages.getSequenceNumber();
            if (changedPackages.getPackageNames().contains(componentName.getPackageName())) {
                Log.d(LOG_TAG, "Ignore due to updated, package: " + componentName.getPackageName());
                return;
            }
        }
        AnomalyReporter.reportAnomaly(this.mAnomalyUUID, "IMS Service Crashed");
    }

    public String toString() {
        String str;
        synchronized (this.mLock) {
            str = "[ImsServiceController: componentName=" + getComponentName() + ", features=" + this.mImsFeatures + ", isBinding=" + this.mIsBinding + ", isBound=" + this.mIsBound + ", serviceController=" + getImsServiceController() + ", rebindDelay=" + getRebindDelay() + "]";
        }
        return str;
    }

    public void dump(PrintWriter printWriter) {
        this.mLocalLog.dump(printWriter);
    }
}
