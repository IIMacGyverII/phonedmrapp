package com.android.internal.telephony.ims;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ResolveInfo;
import android.content.pm.ServiceInfo;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerExecutor;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.os.UserHandle;
import android.os.UserManager;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.ims.aidl.IImsConfig;
import android.telephony.ims.aidl.IImsRegistration;
import android.telephony.ims.feature.ImsFeature;
import android.telephony.ims.stub.ImsFeatureConfiguration;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.ArraySet;
import android.util.Log;
import android.util.SparseArray;
import android.util.SparseIntArray;
import com.android.ims.ImsFeatureBinderRepository;
import com.android.ims.ImsFeatureContainer;
import com.android.ims.internal.IImsServiceFeatureCallback;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.GbaManager;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.PhoneConfigurationManager;
import com.android.internal.telephony.SomeArgs;
import com.android.internal.telephony.ims.ImsServiceController;
import com.android.internal.telephony.ims.ImsServiceFeatureQueryManager;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class ImsResolver implements ImsServiceController.ImsServiceControllerCallbacks {
    private static final int DELAY_DYNAMIC_QUERY_MS = 5000;
    private static final int GET_IMS_SERVICE_TIMEOUT_MS = 5000;
    private static final int HANDLER_ADD_PACKAGE = 0;
    private static final int HANDLER_BOOT_COMPLETE = 6;
    private static final int HANDLER_CLEAR_CARRIER_IMS_SERVICE_CONFIG = 8;
    private static final int HANDLER_CONFIG_CHANGED = 2;
    private static final int HANDLER_DYNAMIC_FEATURE_CHANGE = 4;
    private static final int HANDLER_INIT_IMS_SERVICE = 1000;
    private static final int HANDLER_MSIM_CONFIGURATION_CHANGE = 7;
    private static final int HANDLER_OVERRIDE_IMS_SERVICE_CONFIG = 5;
    private static final int HANDLER_REMOVE_PACKAGE = 1;
    private static final int HANDLER_START_DYNAMIC_FEATURE_QUERY = 3;
    @VisibleForTesting
    public static final String METADATA_EMERGENCY_MMTEL_FEATURE = "android.telephony.ims.EMERGENCY_MMTEL_FEATURE";
    @VisibleForTesting
    public static final String METADATA_MMTEL_FEATURE = "android.telephony.ims.MMTEL_FEATURE";
    private static final String METADATA_OVERRIDE_PERM_CHECK = "override_bind_check";
    @VisibleForTesting
    public static final String METADATA_RCS_FEATURE = "android.telephony.ims.RCS_FEATURE";
    public static final String MTK_IMS_PACKAGE_NAME = "com.mediatek.ims";
    private static final String TAG = "ImsResolver";
    private static ImsResolver sInstance;
    private final Map<ComponentName, ImsServiceController> mActiveControllers;
    private final BroadcastReceiver mAppChangedReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            String schemeSpecificPart = intent.getData().getSchemeSpecificPart();
            action.hashCode();
            char c = 65535;
            switch (action.hashCode()) {
                case -810471698:
                    if (action.equals("android.intent.action.PACKAGE_REPLACED")) {
                        c = 0;
                        break;
                    }
                    break;
                case 172491798:
                    if (action.equals("android.intent.action.PACKAGE_CHANGED")) {
                        c = 1;
                        break;
                    }
                    break;
                case 525384130:
                    if (action.equals("android.intent.action.PACKAGE_REMOVED")) {
                        c = 2;
                        break;
                    }
                    break;
                case 1544582882:
                    if (action.equals("android.intent.action.PACKAGE_ADDED")) {
                        c = 3;
                        break;
                    }
                    break;
            }
            switch (c) {
                case 0:
                case 1:
                case 3:
                    ImsResolver.this.mHandler.obtainMessage(0, schemeSpecificPart).sendToTarget();
                    return;
                case 2:
                    ImsResolver.this.mHandler.obtainMessage(1, schemeSpecificPart).sendToTarget();
                    return;
                default:
                    return;
            }
        }
    };
    private final BroadcastReceiver mBootCompleted = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            Log.i(ImsResolver.TAG, "Received BOOT_COMPLETED");
            ImsResolver.this.mHandler.obtainMessage(6, (Object) null).sendToTarget();
        }
    };
    /* access modifiers changed from: private */
    public boolean mBootCompletedHandlerRan;
    private final SparseArray<SparseArray<ImsServiceController>> mBoundImsServicesByFeature;
    private final Object mBoundServicesLock = new Object();
    private final CarrierConfigManager mCarrierConfigManager;
    /* access modifiers changed from: private */
    public boolean mCarrierConfigReceived;
    private final SparseArray<Map<Integer, String>> mCarrierServices;
    private final BroadcastReceiver mConfigChangedReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            int intExtra = intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1);
            if (intExtra == -1) {
                Log.i(ImsResolver.TAG, "Received CCC for invalid slot id.");
                return;
            }
            int intExtra2 = intent.getIntExtra("android.telephony.extra.SUBSCRIPTION_INDEX", -1);
            int simState = ImsResolver.this.mTelephonyManagerProxy.getSimState(ImsResolver.this.mContext, intExtra);
            if (intExtra2 != -1 || simState == 1 || simState == 6) {
                Log.i(ImsResolver.TAG, "Received Carrier Config Changed for SlotId: " + intExtra + ", SubId: " + intExtra2 + ", sim state: " + simState);
                ImsResolver.this.mHandler.obtainMessage(2, intExtra, intExtra2).sendToTarget();
                return;
            }
            Log.i(ImsResolver.TAG, "Received CCC for slot " + intExtra + " and sim state " + simState + ", ignoring.");
        }
    };
    /* access modifiers changed from: private */
    public final Context mContext;
    private final Map<Integer, String> mDeviceServices = new ArrayMap();
    private final ImsServiceFeatureQueryManager.Listener mDynamicQueryListener;
    private ImsDynamicQueryManagerFactory mDynamicQueryManagerFactory = new ImsResolver$$ExternalSyntheticLambda6();
    /* access modifiers changed from: private */
    public final LocalLog mEventLog = new LocalLog(32);
    private ImsServiceFeatureQueryManager mFeatureQueryManager;
    /* access modifiers changed from: private */
    public final Handler mHandler;
    private ImsServiceControllerFactory mImsServiceControllerFactory = new ImsServiceControllerFactory() {
        public String getServiceInterface() {
            return "android.telephony.ims.ImsService";
        }

        public ImsServiceController create(Context context, ComponentName componentName, ImsServiceController.ImsServiceControllerCallbacks imsServiceControllerCallbacks, ImsFeatureBinderRepository imsFeatureBinderRepository) {
            return new ImsServiceController(context, componentName, imsServiceControllerCallbacks, imsFeatureBinderRepository);
        }
    };
    private final ImsServiceControllerFactory mImsServiceControllerFactoryCompat = new ImsServiceControllerFactory() {
        public String getServiceInterface() {
            return "android.telephony.ims.compat.ImsService";
        }

        public ImsServiceController create(Context context, ComponentName componentName, ImsServiceController.ImsServiceControllerCallbacks imsServiceControllerCallbacks, ImsFeatureBinderRepository imsFeatureBinderRepository) {
            return new ImsServiceControllerCompat(context, componentName, imsServiceControllerCallbacks, imsFeatureBinderRepository);
        }
    };
    private final Map<ComponentName, ImsServiceInfo> mInstalledServicesCache;
    /* access modifiers changed from: private */
    public int mNumSlots;
    private final SparseArray<SparseArray<String>> mOverrideServices;
    private final Context mReceiverContext;
    private final ImsFeatureBinderRepository mRepo;
    private final HandlerExecutor mRunnableExecutor;
    private final BroadcastReceiver mSimStateChangedReceiver;
    private final SparseIntArray mSlotIdToSubIdMap;
    private SubscriptionManagerProxy mSubscriptionManagerProxy = new SubscriptionManagerProxy() {
        public int getSubId(int i) {
            int[] subId = SubscriptionManager.getSubId(i);
            if (subId != null) {
                return subId[0];
            }
            return -1;
        }

        public int getSlotIndex(int i) {
            return SubscriptionManager.getSlotIndex(i);
        }
    };
    /* access modifiers changed from: private */
    public TelephonyManagerProxy mTelephonyManagerProxy = new TelephonyManagerProxy() {
        public int getSimState(Context context, int i) {
            TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(TelephonyManager.class);
            if (telephonyManager == null) {
                return 0;
            }
            return telephonyManager.getSimState(i);
        }
    };

    @VisibleForTesting
    public interface ImsDynamicQueryManagerFactory {
        ImsServiceFeatureQueryManager create(Context context, ImsServiceFeatureQueryManager.Listener listener);
    }

    @VisibleForTesting
    public interface ImsServiceControllerFactory {
        ImsServiceController create(Context context, ComponentName componentName, ImsServiceController.ImsServiceControllerCallbacks imsServiceControllerCallbacks, ImsFeatureBinderRepository imsFeatureBinderRepository);

        String getServiceInterface();
    }

    @VisibleForTesting
    public interface SubscriptionManagerProxy {
        int getSlotIndex(int i);

        int getSubId(int i);
    }

    @VisibleForTesting
    public interface TelephonyManagerProxy {
        int getSimState(Context context, int i);
    }

    public static void make(Context context, String str, String str2, int i, ImsFeatureBinderRepository imsFeatureBinderRepository) {
        if (sInstance == null) {
            sInstance = new ImsResolver(context, str, str2, i, imsFeatureBinderRepository, Looper.getMainLooper());
        }
    }

    public static ImsResolver getInstance() {
        return sInstance;
    }

    private static class OverrideConfig {
        public final Map<Integer, String> featureTypeToPackageMap;
        public final boolean isCarrierService;
        public final int slotId;

        OverrideConfig(int i, boolean z, Map<Integer, String> map) {
            this.slotId = i;
            this.isCarrierService = z;
            this.featureTypeToPackageMap = map;
        }
    }

    @VisibleForTesting
    public static class ImsServiceInfo {
        public ImsServiceControllerFactory controllerFactory;
        public boolean featureFromMetadata = true;
        private final HashSet<ImsFeatureConfiguration.FeatureSlotPair> mSupportedFeatures = new HashSet<>();
        public ComponentName name;

        /* access modifiers changed from: package-private */
        public void addFeatureForAllSlots(int i, int i2) {
            for (int i3 = 0; i3 < i; i3++) {
                this.mSupportedFeatures.add(new ImsFeatureConfiguration.FeatureSlotPair(i3, i2));
            }
        }

        /* access modifiers changed from: package-private */
        public void replaceFeatures(Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
            this.mSupportedFeatures.clear();
            this.mSupportedFeatures.addAll(set);
        }

        @VisibleForTesting
        public Set<ImsFeatureConfiguration.FeatureSlotPair> getSupportedFeatures() {
            return this.mSupportedFeatures;
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (obj == null || getClass() != obj.getClass()) {
                return false;
            }
            ImsServiceInfo imsServiceInfo = (ImsServiceInfo) obj;
            ComponentName componentName = this.name;
            if (componentName == null ? imsServiceInfo.name != null : !componentName.equals(imsServiceInfo.name)) {
                return false;
            }
            if (!this.mSupportedFeatures.equals(imsServiceInfo.mSupportedFeatures)) {
                return false;
            }
            ImsServiceControllerFactory imsServiceControllerFactory = this.controllerFactory;
            if (imsServiceControllerFactory != null) {
                return imsServiceControllerFactory.equals(imsServiceInfo.controllerFactory);
            }
            if (imsServiceInfo.controllerFactory == null) {
                return true;
            }
            return false;
        }

        public int hashCode() {
            ComponentName componentName = this.name;
            int i = 0;
            int hashCode = (componentName != null ? componentName.hashCode() : 0) * 31;
            ImsServiceControllerFactory imsServiceControllerFactory = this.controllerFactory;
            if (imsServiceControllerFactory != null) {
                i = imsServiceControllerFactory.hashCode();
            }
            return hashCode + i;
        }

        public String toString() {
            return "[ImsServiceInfo] name=" + this.name + ", featureFromMetadata=" + this.featureFromMetadata + "," + ImsResolver.printFeatures(this.mSupportedFeatures);
        }
    }

    private class ResolverHandler extends Handler {
        ResolverHandler(Looper looper) {
            super(looper);
        }

        public void handleMessage(Message message) {
            int i = message.what;
            if (i != 1000) {
                switch (i) {
                    case 0:
                        ImsResolver.this.maybeAddedImsService((String) message.obj);
                        return;
                    case 1:
                        boolean unused = ImsResolver.this.maybeRemovedImsService((String) message.obj);
                        return;
                    case 2:
                        int i2 = message.arg1;
                        int i3 = message.arg2;
                        if (i2 >= ImsResolver.this.mNumSlots) {
                            Log.w(ImsResolver.TAG, "HANDLER_CONFIG_CHANGED for invalid slotid=" + i2);
                            return;
                        }
                        ImsResolver.this.mCarrierConfigReceived = true;
                        ImsResolver.this.carrierConfigChanged(i2, i3);
                        return;
                    case 3:
                        ImsResolver.this.startDynamicQuery((ImsServiceInfo) message.obj);
                        return;
                    case 4:
                        SomeArgs someArgs = (SomeArgs) message.obj;
                        someArgs.recycle();
                        ImsResolver.this.dynamicQueryComplete((ComponentName) someArgs.arg1, (Set) someArgs.arg2);
                        return;
                    case 5:
                        OverrideConfig overrideConfig = (OverrideConfig) message.obj;
                        if (overrideConfig.isCarrierService) {
                            ImsResolver.this.overrideCarrierService(overrideConfig.slotId, overrideConfig.featureTypeToPackageMap);
                            return;
                        } else {
                            ImsResolver.this.overrideDeviceService(overrideConfig.featureTypeToPackageMap);
                            return;
                        }
                    case 6:
                        if (!ImsResolver.this.mBootCompletedHandlerRan) {
                            ImsResolver.this.mBootCompletedHandlerRan = true;
                            ImsResolver.this.mEventLog.log("handling BOOT_COMPLETE");
                            if (ImsResolver.this.mCarrierConfigReceived) {
                                ImsResolver.this.mEventLog.log("boot complete - reeval");
                                ImsResolver.this.maybeAddedImsService((String) null);
                                return;
                            }
                            ImsResolver.this.mEventLog.log("boot complete - update cache");
                            ImsResolver.this.updateInstalledServicesCache();
                            return;
                        }
                        return;
                    case 7:
                        ImsResolver.this.handleMsimConfigChange((Integer) ((AsyncResult) message.obj).result);
                        return;
                    case 8:
                        ImsResolver.this.clearCarrierServiceOverrides(message.arg1);
                        return;
                    default:
                        return;
                }
            } else {
                String str = (String) message.obj;
                for (int i4 = 0; i4 < ImsResolver.this.mNumSlots; i4++) {
                    int r1 = ImsResolver.this.getSubIdUsingPhoneId(i4);
                    Log.i(ImsResolver.TAG, "HANDLER_INIT_IMS_SERVICE for SlotId: " + i4 + ", newSubId: " + r1);
                    if (r1 != -1) {
                        ImsResolver.this.setSubId(i4, r1);
                    }
                }
                ImsResolver.this.maybeAddedImsService(str);
            }
        }
    }

    public ImsResolver(Context context, String str, String str2, int i, ImsFeatureBinderRepository imsFeatureBinderRepository, Looper looper) {
        this.mBootCompletedHandlerRan = false;
        this.mCarrierConfigReceived = false;
        this.mDynamicQueryListener = new ImsServiceFeatureQueryManager.Listener() {
            public void onComplete(ComponentName componentName, Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
                Log.d(ImsResolver.TAG, "onComplete called for name: " + componentName + ImsResolver.printFeatures(set));
                ImsResolver.this.handleFeaturesChanged(componentName, set);
            }

            public void onError(ComponentName componentName) {
                Log.w(ImsResolver.TAG, "onError: " + componentName + "returned with an error result");
                LocalLog r0 = ImsResolver.this.mEventLog;
                r0.log("onError - dynamic query error for " + componentName);
                ImsResolver.this.scheduleQueryForFeatures(componentName, (int) GbaManager.REQUEST_TIMEOUT_MS);
            }

            public void onPermanentError(ComponentName componentName) {
                Log.w(ImsResolver.TAG, "onPermanentError: component=" + componentName);
                LocalLog r0 = ImsResolver.this.mEventLog;
                r0.log("onPermanentError - error for " + componentName);
                ImsResolver.this.mHandler.obtainMessage(1, componentName.getPackageName()).sendToTarget();
            }
        };
        this.mInstalledServicesCache = new HashMap();
        this.mActiveControllers = new HashMap();
        this.mSimStateChangedReceiver = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                int intExtra = intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1);
                if (intExtra == -1) {
                    Log.d(ImsResolver.TAG, "mSimStateChangedReceiver, invalid slot id.");
                    return;
                }
                int r1 = ImsResolver.this.getSubIdUsingPhoneId(intExtra);
                int simState = ImsResolver.this.mTelephonyManagerProxy.getSimState(ImsResolver.this.mContext, intExtra);
                int r3 = ImsResolver.this.getSubId(intExtra);
                if (r1 == -1 || r3 == r1 || simState != 5) {
                    Log.d(ImsResolver.TAG, "mSimStateChangedReceiver for slot:" + intExtra + ", curSubId:" + r3 + " and simstate:" + simState + ", ignoring.");
                    return;
                }
                Log.d(ImsResolver.TAG, "mSimStateChangedReceiver SlotId: " + intExtra + ", SubId: " + r1 + ", sim state: " + simState);
                ImsResolver.this.mHandler.obtainMessage(2, intExtra, r1).sendToTarget();
            }
        };
        Log.i(TAG, "device MMTEL package: " + str + ", device RCS package:" + str2);
        this.mContext = context;
        this.mNumSlots = i;
        this.mRepo = imsFeatureBinderRepository;
        this.mReceiverContext = context.createContextAsUser(UserHandle.ALL, 0);
        ResolverHandler resolverHandler = new ResolverHandler(looper);
        this.mHandler = resolverHandler;
        this.mRunnableExecutor = new HandlerExecutor(resolverHandler);
        this.mCarrierServices = new SparseArray<>(this.mNumSlots);
        setDeviceConfiguration(str, 0);
        setDeviceConfiguration(str, 1);
        setDeviceConfiguration(str2, 2);
        this.mCarrierConfigManager = (CarrierConfigManager) context.getSystemService("carrier_config");
        this.mOverrideServices = new SparseArray<>(0);
        this.mBoundImsServicesByFeature = new SparseArray<>(this.mNumSlots);
        this.mSlotIdToSubIdMap = new SparseIntArray(this.mNumSlots);
        for (int i2 = 0; i2 < this.mNumSlots; i2++) {
            this.mSlotIdToSubIdMap.put(i2, -1);
        }
    }

    @VisibleForTesting
    public void setTelephonyManagerProxy(TelephonyManagerProxy telephonyManagerProxy) {
        this.mTelephonyManagerProxy = telephonyManagerProxy;
    }

    @VisibleForTesting
    public void setSubscriptionManagerProxy(SubscriptionManagerProxy subscriptionManagerProxy) {
        this.mSubscriptionManagerProxy = subscriptionManagerProxy;
    }

    @VisibleForTesting
    public void setImsServiceControllerFactory(ImsServiceControllerFactory imsServiceControllerFactory) {
        this.mImsServiceControllerFactory = imsServiceControllerFactory;
    }

    @VisibleForTesting
    public Handler getHandler() {
        return this.mHandler;
    }

    @VisibleForTesting
    public void setImsDynamicQueryManagerFactory(ImsDynamicQueryManagerFactory imsDynamicQueryManagerFactory) {
        this.mDynamicQueryManagerFactory = imsDynamicQueryManagerFactory;
    }

    public void initialize() {
        this.mEventLog.log("Initializing");
        Log.i(TAG, "Initializing cache.");
        PhoneConfigurationManager.registerForMultiSimConfigChange(this.mHandler, 7, (Object) null);
        this.mFeatureQueryManager = this.mDynamicQueryManagerFactory.create(this.mContext, this.mDynamicQueryListener);
        updateInstalledServicesCache();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.PACKAGE_CHANGED");
        intentFilter.addAction("android.intent.action.PACKAGE_REMOVED");
        intentFilter.addAction("android.intent.action.PACKAGE_ADDED");
        intentFilter.addDataScheme("package");
        this.mReceiverContext.registerReceiver(this.mAppChangedReceiver, intentFilter);
        this.mReceiverContext.registerReceiver(this.mConfigChangedReceiver, new IntentFilter("android.telephony.action.CARRIER_CONFIG_CHANGED"));
        this.mReceiverContext.registerReceiver(this.mSimStateChangedReceiver, new IntentFilter("android.intent.action.SIM_STATE_CHANGED"));
        UserManager userManager = (UserManager) this.mContext.getSystemService("user");
        if (userManager.isUserUnlocked()) {
            this.mHandler.obtainMessage(6, (Object) null).sendToTarget();
        } else {
            this.mReceiverContext.registerReceiver(this.mBootCompleted, new IntentFilter("android.intent.action.BOOT_COMPLETED"));
            if (userManager.isUserUnlocked()) {
                this.mHandler.obtainMessage(6, (Object) null).sendToTarget();
            }
        }
        bindCarrierServicesIfAvailable();
        if (MTK_IMS_PACKAGE_NAME.equals(getDeviceConfiguration(0))) {
            Log.d(TAG, "Initializing for binding ims service earlier");
            this.mHandler.obtainMessage(1000, (Object) null).sendToTarget();
        }
    }

    /* access modifiers changed from: private */
    public void updateInstalledServicesCache() {
        for (ImsServiceInfo next : getImsServiceInfo((String) null)) {
            if (!this.mInstalledServicesCache.containsKey(next.name)) {
                this.mInstalledServicesCache.put(next.name, next);
            }
        }
    }

    @VisibleForTesting
    public void destroy() {
        PhoneConfigurationManager.unregisterForMultiSimConfigChange(this.mHandler);
        this.mHandler.removeCallbacksAndMessages((Object) null);
    }

    private void bindCarrierServicesIfAvailable() {
        boolean z = false;
        for (int i = 0; i < this.mNumSlots; i++) {
            int subId = this.mSubscriptionManagerProxy.getSubId(i);
            Map<Integer, String> imsPackageOverrideConfig = getImsPackageOverrideConfig(subId);
            for (int i2 = 0; i2 < 3; i2++) {
                String orDefault = imsPackageOverrideConfig.getOrDefault(Integer.valueOf(i2), "");
                if (!TextUtils.isEmpty(orDefault)) {
                    this.mEventLog.log("bindCarrierServicesIfAvailable - carrier package found: " + orDefault + " on slot " + i);
                    this.mCarrierConfigReceived = true;
                    setSubId(i, subId);
                    setCarrierConfiguredPackageName(orDefault, i, i2);
                    ImsServiceInfo imsServiceInfoFromCache = getImsServiceInfoFromCache(orDefault);
                    if (imsServiceInfoFromCache == null || !imsServiceInfoFromCache.featureFromMetadata) {
                        scheduleQueryForFeatures(imsServiceInfoFromCache);
                    } else {
                        z = true;
                    }
                }
            }
        }
        if (z) {
            calculateFeatureConfigurationChange();
        }
    }

    public void enableIms(int i) {
        getImsServiceControllers(i).forEach(new ImsResolver$$ExternalSyntheticLambda11(this, i));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$enableIms$0(int i, ImsServiceController imsServiceController) {
        imsServiceController.enableIms(i, getSubId(i));
    }

    public void disableIms(int i) {
        getImsServiceControllers(i).forEach(new ImsResolver$$ExternalSyntheticLambda13(this, i));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$disableIms$1(int i, ImsServiceController imsServiceController) {
        imsServiceController.disableIms(i, getSubId(i));
    }

    public IImsRegistration getImsRegistration(int i, int i2) {
        ImsFeatureContainer imsFeatureContainer = (ImsFeatureContainer) this.mRepo.getIfExists(i, i2).orElse((Object) null);
        if (imsFeatureContainer != null) {
            return imsFeatureContainer.imsRegistration;
        }
        return null;
    }

    public IImsConfig getImsConfig(int i, int i2) {
        ImsFeatureContainer imsFeatureContainer = (ImsFeatureContainer) this.mRepo.getIfExists(i, i2).orElse((Object) null);
        if (imsFeatureContainer != null) {
            return imsFeatureContainer.imsConfig;
        }
        return null;
    }

    private Set<ImsServiceController> getImsServiceControllers(int i) {
        SparseArray sparseArray;
        if (i < 0 || i >= this.mNumSlots) {
            return Collections.emptySet();
        }
        synchronized (this.mBoundServicesLock) {
            sparseArray = this.mBoundImsServicesByFeature.get(i);
        }
        if (sparseArray == null) {
            Log.w(TAG, "getImsServiceControllers: couldn't find any active ImsServiceControllers");
            return Collections.emptySet();
        }
        ArraySet arraySet = new ArraySet(2);
        for (int i2 = 0; i2 < sparseArray.size(); i2++) {
            ImsServiceController imsServiceController = (ImsServiceController) sparseArray.get(sparseArray.keyAt(i2));
            if (imsServiceController != null) {
                arraySet.add(imsServiceController);
            }
        }
        return arraySet;
    }

    public void listenForFeature(int i, int i2, IImsServiceFeatureCallback iImsServiceFeatureCallback) {
        this.mRepo.registerForConnectionUpdates(i, i2, iImsServiceFeatureCallback, this.mRunnableExecutor);
    }

    public void unregisterImsFeatureCallback(IImsServiceFeatureCallback iImsServiceFeatureCallback) {
        this.mRepo.unregisterForConnectionUpdates(iImsServiceFeatureCallback);
    }

    public boolean clearCarrierImsServiceConfiguration(int i) {
        if (i < 0 || i >= this.mNumSlots) {
            Log.w(TAG, "clearCarrierImsServiceConfiguration: invalid slotId!");
            return false;
        }
        Message.obtain(this.mHandler, 8, i, 0).sendToTarget();
        return true;
    }

    public boolean overrideImsServiceConfiguration(int i, boolean z, Map<Integer, String> map) {
        if (i < 0 || i >= this.mNumSlots) {
            Log.w(TAG, "overrideImsServiceConfiguration: invalid slotId!");
            return false;
        }
        Message.obtain(this.mHandler, 5, new OverrideConfig(i, z, map)).sendToTarget();
        return true;
    }

    private String getDeviceConfiguration(int i) {
        String orDefault;
        synchronized (this.mDeviceServices) {
            orDefault = this.mDeviceServices.getOrDefault(Integer.valueOf(i), "");
        }
        return orDefault;
    }

    private void setDeviceConfiguration(String str, int i) {
        synchronized (this.mDeviceServices) {
            this.mDeviceServices.put(Integer.valueOf(i), str);
        }
    }

    private void setCarrierConfiguredPackageName(String str, int i, int i2) {
        getCarrierConfiguredPackageNames(i).put(Integer.valueOf(i2), str);
    }

    private String getCarrierConfiguredPackageName(int i, int i2) {
        return getCarrierConfiguredPackageNames(i).getOrDefault(Integer.valueOf(i2), "");
    }

    private Map<Integer, String> getCarrierConfiguredPackageNames(int i) {
        Map<Integer, String> map = this.mCarrierServices.get(i);
        if (map != null) {
            return map;
        }
        ArrayMap arrayMap = new ArrayMap();
        this.mCarrierServices.put(i, arrayMap);
        return arrayMap;
    }

    private void removeOverridePackageName(int i) {
        for (int i2 = 0; i2 < 3; i2++) {
            getOverridePackageName(i).remove(i2);
        }
    }

    private void setOverridePackageName(String str, int i, int i2) {
        getOverridePackageName(i).put(i2, str);
    }

    private String getOverridePackageName(int i, int i2) {
        return getOverridePackageName(i).get(i2);
    }

    private SparseArray<String> getOverridePackageName(int i) {
        SparseArray<String> sparseArray = this.mOverrideServices.get(i);
        if (sparseArray != null) {
            return sparseArray;
        }
        SparseArray<String> sparseArray2 = new SparseArray<>();
        this.mOverrideServices.put(i, sparseArray2);
        return sparseArray2;
    }

    private boolean doesCarrierConfigurationExist(int i, int i2) {
        String carrierConfiguredPackageName = getCarrierConfiguredPackageName(i, i2);
        if (TextUtils.isEmpty(carrierConfiguredPackageName)) {
            return false;
        }
        return doesCachedImsServiceExist(carrierConfiguredPackageName, i, i2);
    }

    private boolean doesCachedImsServiceExist(String str, int i, int i2) {
        ImsServiceInfo imsServiceInfoFromCache = getImsServiceInfoFromCache(str);
        return imsServiceInfoFromCache != null && imsServiceInfoFromCache.getSupportedFeatures().stream().anyMatch(new ImsResolver$$ExternalSyntheticLambda15(i, i2));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$doesCachedImsServiceExist$2(int i, int i2, ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.slotId == i && featureSlotPair.featureType == i2;
    }

    public String getImsServiceConfiguration(int i, boolean z, int i2) {
        if (i < 0 || i >= this.mNumSlots) {
            Log.w(TAG, "getImsServiceConfiguration: invalid slotId!");
            return "";
        }
        LinkedBlockingQueue linkedBlockingQueue = new LinkedBlockingQueue(1);
        this.mHandler.post(new ImsResolver$$ExternalSyntheticLambda4(this, linkedBlockingQueue, z, i, i2));
        try {
            return (String) linkedBlockingQueue.poll(5000, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            Log.w(TAG, "getImsServiceConfiguration: exception=" + e.getMessage());
            return null;
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$getImsServiceConfiguration$3(LinkedBlockingQueue linkedBlockingQueue, boolean z, int i, int i2) {
        String str;
        if (z) {
            str = getCarrierConfiguredPackageName(i, i2);
        } else {
            str = getDeviceConfiguration(i2);
        }
        linkedBlockingQueue.offer(str);
    }

    public boolean isImsServiceConfiguredForFeature(int i, int i2) {
        if (!TextUtils.isEmpty(getDeviceConfiguration(i2))) {
            return true;
        }
        return !TextUtils.isEmpty(getConfiguredImsServicePackageName(i, i2));
    }

    public String getConfiguredImsServicePackageName(int i, int i2) {
        int i3 = i;
        int i4 = i2;
        if (i3 < 0 || i3 >= this.mNumSlots || i4 <= -1 || i4 >= 3) {
            Log.w(TAG, "getResolvedImsServicePackageName received invalid parameters - slot: " + i3 + ", feature: " + i4);
            return null;
        }
        CompletableFuture completableFuture = new CompletableFuture();
        long currentTimeMillis = System.currentTimeMillis();
        if (this.mHandler.getLooper().isCurrentThread()) {
            completableFuture.complete(getConfiguredImsServicePackageNameInternal(i, i2));
        } else {
            this.mHandler.post(new ImsResolver$$ExternalSyntheticLambda14(this, completableFuture, i3, i4));
        }
        try {
            String str = (String) completableFuture.get();
            long currentTimeMillis2 = System.currentTimeMillis() - currentTimeMillis;
            if (currentTimeMillis2 > 50) {
                LocalLog localLog = this.mEventLog;
                localLog.log("getResolvedImsServicePackageName - [" + i3 + ", " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i2))) + "], async query complete, took " + currentTimeMillis2 + " ms with package name: " + str);
                Log.w(TAG, "getResolvedImsServicePackageName: [" + i3 + ", " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i2))) + "], async query complete, took " + currentTimeMillis2 + " ms with package name: " + str);
            }
            return str;
        } catch (Exception e) {
            LocalLog localLog2 = this.mEventLog;
            localLog2.log("getResolvedImsServicePackageName - [" + i3 + ", " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i2))) + "] -> Exception: " + e);
            Log.w(TAG, "getResolvedImsServicePackageName: [" + i3 + ", " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i2))) + "] returned Exception: " + e);
            return null;
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$getConfiguredImsServicePackageName$4(CompletableFuture completableFuture, int i, int i2) {
        try {
            completableFuture.complete(getConfiguredImsServicePackageNameInternal(i, i2));
        } catch (Exception e) {
            completableFuture.completeExceptionally(e);
        }
    }

    private String getConfiguredImsServicePackageNameInternal(int i, int i2) {
        String carrierConfiguredPackageName = getCarrierConfiguredPackageName(i, i2);
        if (!TextUtils.isEmpty(carrierConfiguredPackageName) && doesCachedImsServiceExist(carrierConfiguredPackageName, i, i2)) {
            return carrierConfiguredPackageName;
        }
        String deviceConfiguration = getDeviceConfiguration(i2);
        if (TextUtils.isEmpty(deviceConfiguration) || !doesCachedImsServiceExist(deviceConfiguration, i, i2)) {
            return null;
        }
        return deviceConfiguration;
    }

    private void putImsController(int i, int i2, ImsServiceController imsServiceController) {
        if (i < 0 || i >= this.mNumSlots || i2 <= -1 || i2 >= 3) {
            Log.w(TAG, "putImsController received invalid parameters - slot: " + i + ", feature: " + i2);
            return;
        }
        synchronized (this.mBoundServicesLock) {
            SparseArray sparseArray = this.mBoundImsServicesByFeature.get(i);
            if (sparseArray == null) {
                sparseArray = new SparseArray();
                this.mBoundImsServicesByFeature.put(i, sparseArray);
            }
            LocalLog localLog = this.mEventLog;
            localLog.log("putImsController - [" + i + ", " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i2))) + "] -> " + imsServiceController);
            Log.i(TAG, "ImsServiceController added on slot: " + i + " with feature: " + ((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(i2))) + " using package: " + imsServiceController.getComponentName());
            sparseArray.put(i2, imsServiceController);
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:17:0x008e, code lost:
        return r0;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private com.android.internal.telephony.ims.ImsServiceController removeImsController(int r7, int r8) {
        /*
            r6 = this;
            r0 = 0
            if (r7 < 0) goto L_0x0092
            r1 = -1
            if (r8 <= r1) goto L_0x0092
            r1 = 3
            if (r8 < r1) goto L_0x000b
            goto L_0x0092
        L_0x000b:
            java.lang.Object r1 = r6.mBoundServicesLock
            monitor-enter(r1)
            android.util.SparseArray<android.util.SparseArray<com.android.internal.telephony.ims.ImsServiceController>> r2 = r6.mBoundImsServicesByFeature     // Catch:{ all -> 0x008f }
            java.lang.Object r2 = r2.get(r7)     // Catch:{ all -> 0x008f }
            android.util.SparseArray r2 = (android.util.SparseArray) r2     // Catch:{ all -> 0x008f }
            if (r2 != 0) goto L_0x001a
            monitor-exit(r1)     // Catch:{ all -> 0x008f }
            return r0
        L_0x001a:
            java.lang.Object r0 = r2.get(r8, r0)     // Catch:{ all -> 0x008f }
            com.android.internal.telephony.ims.ImsServiceController r0 = (com.android.internal.telephony.ims.ImsServiceController) r0     // Catch:{ all -> 0x008f }
            if (r0 == 0) goto L_0x008d
            com.android.internal.telephony.LocalLog r6 = r6.mEventLog     // Catch:{ all -> 0x008f }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x008f }
            r3.<init>()     // Catch:{ all -> 0x008f }
            java.lang.String r4 = "removeImsController - ["
            r3.append(r4)     // Catch:{ all -> 0x008f }
            r3.append(r7)     // Catch:{ all -> 0x008f }
            java.lang.String r4 = ", "
            r3.append(r4)     // Catch:{ all -> 0x008f }
            java.util.Map r4 = android.telephony.ims.feature.ImsFeature.FEATURE_LOG_MAP     // Catch:{ all -> 0x008f }
            java.lang.Integer r5 = java.lang.Integer.valueOf(r8)     // Catch:{ all -> 0x008f }
            java.lang.Object r4 = r4.get(r5)     // Catch:{ all -> 0x008f }
            java.lang.String r4 = (java.lang.String) r4     // Catch:{ all -> 0x008f }
            r3.append(r4)     // Catch:{ all -> 0x008f }
            java.lang.String r4 = "] -> "
            r3.append(r4)     // Catch:{ all -> 0x008f }
            r3.append(r0)     // Catch:{ all -> 0x008f }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x008f }
            r6.log(r3)     // Catch:{ all -> 0x008f }
            java.lang.String r6 = "ImsResolver"
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x008f }
            r3.<init>()     // Catch:{ all -> 0x008f }
            java.lang.String r4 = "ImsServiceController removed on slot: "
            r3.append(r4)     // Catch:{ all -> 0x008f }
            r3.append(r7)     // Catch:{ all -> 0x008f }
            java.lang.String r7 = " with feature: "
            r3.append(r7)     // Catch:{ all -> 0x008f }
            java.util.Map r7 = android.telephony.ims.feature.ImsFeature.FEATURE_LOG_MAP     // Catch:{ all -> 0x008f }
            java.lang.Integer r4 = java.lang.Integer.valueOf(r8)     // Catch:{ all -> 0x008f }
            java.lang.Object r7 = r7.get(r4)     // Catch:{ all -> 0x008f }
            java.lang.String r7 = (java.lang.String) r7     // Catch:{ all -> 0x008f }
            r3.append(r7)     // Catch:{ all -> 0x008f }
            java.lang.String r7 = " using package: "
            r3.append(r7)     // Catch:{ all -> 0x008f }
            android.content.ComponentName r7 = r0.getComponentName()     // Catch:{ all -> 0x008f }
            r3.append(r7)     // Catch:{ all -> 0x008f }
            java.lang.String r7 = r3.toString()     // Catch:{ all -> 0x008f }
            android.util.Log.i(r6, r7)     // Catch:{ all -> 0x008f }
            r2.remove(r8)     // Catch:{ all -> 0x008f }
        L_0x008d:
            monitor-exit(r1)     // Catch:{ all -> 0x008f }
            return r0
        L_0x008f:
            r6 = move-exception
            monitor-exit(r1)     // Catch:{ all -> 0x008f }
            throw r6
        L_0x0092:
            java.lang.String r6 = "ImsResolver"
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "removeImsController received invalid parameters - slot: "
            r1.append(r2)
            r1.append(r7)
            java.lang.String r7 = ", feature: "
            r1.append(r7)
            r1.append(r8)
            java.lang.String r7 = r1.toString()
            android.util.Log.w(r6, r7)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ims.ImsResolver.removeImsController(int, int):com.android.internal.telephony.ims.ImsServiceController");
    }

    /* access modifiers changed from: private */
    public void maybeAddedImsService(String str) {
        Log.d(TAG, "maybeAddedImsService, packageName: " + str);
        boolean z = false;
        for (ImsServiceInfo next : getImsServiceInfo(str)) {
            ImsServiceInfo infoByComponentName = getInfoByComponentName(this.mInstalledServicesCache, next.name);
            if (infoByComponentName == null) {
                Log.i(TAG, "Adding newly added ImsService to cache: " + next.name);
                this.mEventLog.log("maybeAddedImsService - adding new ImsService: " + next);
                this.mInstalledServicesCache.put(next.name, next);
                if (!next.featureFromMetadata) {
                    scheduleQueryForFeatures(next);
                }
            } else if (next.featureFromMetadata) {
                this.mEventLog.log("maybeAddedImsService - updating features for " + next.name + ": " + printFeatures(infoByComponentName.getSupportedFeatures()) + " -> " + printFeatures(next.getSupportedFeatures()));
                StringBuilder sb = new StringBuilder();
                sb.append("Updating features in cached ImsService: ");
                sb.append(next.name);
                Log.i(TAG, sb.toString());
                Log.d(TAG, "Updating features - Old features: " + infoByComponentName + " new features: " + next);
                infoByComponentName.replaceFeatures(next.getSupportedFeatures());
            } else {
                this.mEventLog.log("maybeAddedImsService - scheduling query for " + next);
                scheduleQueryForFeatures(next);
            }
            z = true;
        }
        if (z) {
            calculateFeatureConfigurationChange();
        }
    }

    /* access modifiers changed from: private */
    public boolean maybeRemovedImsService(String str) {
        ImsServiceInfo infoByPackageName = getInfoByPackageName(this.mInstalledServicesCache, str);
        if (infoByPackageName == null) {
            return false;
        }
        this.mInstalledServicesCache.remove(infoByPackageName.name);
        LocalLog localLog = this.mEventLog;
        localLog.log("maybeRemovedImsService - removing ImsService: " + infoByPackageName);
        Log.i(TAG, "Removing ImsService: " + infoByPackageName.name);
        unbindImsService(infoByPackageName);
        calculateFeatureConfigurationChange();
        return true;
    }

    private boolean isDeviceService(ImsServiceInfo imsServiceInfo) {
        boolean containsValue;
        if (imsServiceInfo == null) {
            return false;
        }
        synchronized (this.mDeviceServices) {
            containsValue = this.mDeviceServices.containsValue(imsServiceInfo.name.getPackageName());
        }
        return containsValue;
    }

    private List<Integer> getSlotsForActiveCarrierService(ImsServiceInfo imsServiceInfo) {
        if (imsServiceInfo == null) {
            return Collections.emptyList();
        }
        ArrayList arrayList = new ArrayList(this.mNumSlots);
        for (int i = 0; i < this.mNumSlots; i++) {
            if (!TextUtils.isEmpty(getCarrierConfiguredPackageNames(i).values().stream().filter(new ImsResolver$$ExternalSyntheticLambda5(imsServiceInfo)).findAny().orElse(""))) {
                arrayList.add(Integer.valueOf(i));
            }
        }
        return arrayList;
    }

    private ImsServiceController getControllerByServiceInfo(Map<ComponentName, ImsServiceController> map, ImsServiceInfo imsServiceInfo) {
        return map.values().stream().filter(new ImsResolver$$ExternalSyntheticLambda8(imsServiceInfo)).findFirst().orElse((Object) null);
    }

    private ImsServiceInfo getInfoByPackageName(Map<ComponentName, ImsServiceInfo> map, String str) {
        return map.values().stream().filter(new ImsResolver$$ExternalSyntheticLambda7(str)).findFirst().orElse((Object) null);
    }

    private ImsServiceInfo getInfoByComponentName(Map<ComponentName, ImsServiceInfo> map, ComponentName componentName) {
        return map.get(componentName);
    }

    private void bindImsServiceWithFeatures(ImsServiceInfo imsServiceInfo, Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        if (shouldFeaturesCauseBind(set)) {
            ImsServiceController controllerByServiceInfo = getControllerByServiceInfo(this.mActiveControllers, imsServiceInfo);
            SparseIntArray clone = this.mSlotIdToSubIdMap.clone();
            if (controllerByServiceInfo != null) {
                Log.i(TAG, "ImsService connection exists for " + imsServiceInfo.name + ", updating features " + set);
                try {
                    controllerByServiceInfo.changeImsServiceFeatures(set, clone);
                } catch (RemoteException e) {
                    Log.w(TAG, "bindImsService: error=" + e.getMessage());
                }
            } else {
                controllerByServiceInfo = imsServiceInfo.controllerFactory.create(this.mContext, imsServiceInfo.name, this, this.mRepo);
                Log.i(TAG, "Binding ImsService: " + controllerByServiceInfo.getComponentName() + " with features: " + set);
                controllerByServiceInfo.bind(set, clone);
                LocalLog localLog = this.mEventLog;
                localLog.log("bindImsServiceWithFeatures - create new controller: " + controllerByServiceInfo);
            }
            this.mActiveControllers.put(imsServiceInfo.name, controllerByServiceInfo);
        }
    }

    private void unbindImsService(ImsServiceInfo imsServiceInfo) {
        ImsServiceController controllerByServiceInfo;
        if (imsServiceInfo != null && (controllerByServiceInfo = getControllerByServiceInfo(this.mActiveControllers, imsServiceInfo)) != null) {
            try {
                Log.i(TAG, "Unbinding ImsService: " + controllerByServiceInfo.getComponentName());
                LocalLog localLog = this.mEventLog;
                localLog.log("unbindImsService - unbinding and removing " + controllerByServiceInfo);
                controllerByServiceInfo.unbind();
            } catch (RemoteException e) {
                Log.e(TAG, "unbindImsService: Remote Exception: " + e.getMessage());
            }
            this.mActiveControllers.remove(imsServiceInfo.name);
        }
    }

    private HashSet<ImsFeatureConfiguration.FeatureSlotPair> calculateFeaturesToCreate(ImsServiceInfo imsServiceInfo) {
        HashSet<ImsFeatureConfiguration.FeatureSlotPair> hashSet = new HashSet<>();
        if (!getSlotsForActiveCarrierService(imsServiceInfo).isEmpty()) {
            hashSet.addAll((Collection) imsServiceInfo.getSupportedFeatures().stream().filter(new ImsResolver$$ExternalSyntheticLambda0(this, imsServiceInfo)).collect(Collectors.toList()));
            return hashSet;
        }
        if (isDeviceService(imsServiceInfo)) {
            hashSet.addAll((Collection) imsServiceInfo.getSupportedFeatures().stream().filter(new ImsResolver$$ExternalSyntheticLambda1(this, imsServiceInfo)).filter(new ImsResolver$$ExternalSyntheticLambda2(this)).collect(Collectors.toList()));
        }
        return hashSet;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$calculateFeaturesToCreate$8(ImsServiceInfo imsServiceInfo, ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return imsServiceInfo.name.getPackageName().equals(getCarrierConfiguredPackageName(featureSlotPair.slotId, featureSlotPair.featureType));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$calculateFeaturesToCreate$9(ImsServiceInfo imsServiceInfo, ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return imsServiceInfo.name.getPackageName().equals(getDeviceConfiguration(featureSlotPair.featureType));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$calculateFeaturesToCreate$10(ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return !doesCarrierConfigurationExist(featureSlotPair.slotId, featureSlotPair.featureType);
    }

    public void imsServiceFeatureCreated(int i, int i2, ImsServiceController imsServiceController) {
        putImsController(i, i2, imsServiceController);
    }

    public void imsServiceFeatureRemoved(int i, int i2, ImsServiceController imsServiceController) {
        removeImsController(i, i2);
    }

    public void imsServiceFeaturesChanged(ImsFeatureConfiguration imsFeatureConfiguration, ImsServiceController imsServiceController) {
        if (imsServiceController != null && imsFeatureConfiguration != null) {
            Log.i(TAG, "imsServiceFeaturesChanged: config=" + imsFeatureConfiguration.getServiceFeatures() + ", ComponentName=" + imsServiceController.getComponentName());
            LocalLog localLog = this.mEventLog;
            localLog.log("imsServiceFeaturesChanged - for " + imsServiceController + ", new config " + imsFeatureConfiguration.getServiceFeatures());
            handleFeaturesChanged(imsServiceController.getComponentName(), imsFeatureConfiguration.getServiceFeatures());
        }
    }

    public void imsServiceBindPermanentError(ComponentName componentName) {
        if (componentName != null) {
            Log.w(TAG, "imsServiceBindPermanentError: component=" + componentName);
            LocalLog localLog = this.mEventLog;
            localLog.log("imsServiceBindPermanentError - for " + componentName);
            this.mHandler.obtainMessage(1, componentName.getPackageName()).sendToTarget();
        }
    }

    private boolean shouldFeaturesCauseBind(Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        return set.stream().filter(new ImsResolver$$ExternalSyntheticLambda12()).count() > 0;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$shouldFeaturesCauseBind$11(ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.featureType != 0;
    }

    /* access modifiers changed from: private */
    public void overrideCarrierService(int i, Map<Integer, String> map) {
        for (Integer next : map.keySet()) {
            String str = map.get(next);
            LocalLog localLog = this.mEventLog;
            localLog.log("overriding carrier ImsService to " + str + " on slot " + i + " for feature " + ((String) ImsFeature.FEATURE_LOG_MAP.getOrDefault(next, "invalid")));
            setOverridePackageName(str, i, next.intValue());
        }
        updateBoundServices(i, Collections.emptyMap());
    }

    /* access modifiers changed from: private */
    public void clearCarrierServiceOverrides(int i) {
        Log.i(TAG, "clearing carrier ImsService overrides");
        this.mEventLog.log("clearing carrier ImsService overrides");
        removeOverridePackageName(i);
        carrierConfigChanged(i, getSubId(i));
    }

    /* access modifiers changed from: private */
    public void overrideDeviceService(Map<Integer, String> map) {
        boolean z = false;
        for (Integer next : map.keySet()) {
            String str = map.get(next);
            LocalLog localLog = this.mEventLog;
            localLog.log("overriding device ImsService to " + str + " for feature " + ((String) ImsFeature.FEATURE_LOG_MAP.getOrDefault(next, "invalid")));
            String deviceConfiguration = getDeviceConfiguration(next.intValue());
            if (!TextUtils.equals(deviceConfiguration, str)) {
                Log.i(TAG, "overrideDeviceService - device package changed (override): " + deviceConfiguration + " -> " + str);
                LocalLog localLog2 = this.mEventLog;
                localLog2.log("overrideDeviceService - device package changed (override): " + deviceConfiguration + " -> " + str);
                setDeviceConfiguration(str, next.intValue());
                ImsServiceInfo imsServiceInfoFromCache = getImsServiceInfoFromCache(str);
                if (imsServiceInfoFromCache == null || imsServiceInfoFromCache.featureFromMetadata) {
                    z = true;
                } else {
                    scheduleQueryForFeatures(imsServiceInfoFromCache);
                }
            }
        }
        if (z) {
            calculateFeatureConfigurationChange();
        }
    }

    /* access modifiers changed from: private */
    public void carrierConfigChanged(int i, int i2) {
        setSubId(i, i2);
        updateBoundDeviceServices();
        if (i <= -1) {
            for (int i3 = 0; i3 < this.mNumSlots; i3++) {
                updateBoundServices(i3, getImsPackageOverrideConfig(getSubId(i3)));
            }
        }
        updateBoundServices(i, getImsPackageOverrideConfig(i2));
    }

    private void updateBoundDeviceServices() {
        Log.d(TAG, "updateBoundDeviceServices: called");
        ArrayMap arrayMap = new ArrayMap();
        for (int i = 0; i < 3; i++) {
            String deviceConfiguration = getDeviceConfiguration(i);
            ImsServiceInfo imsServiceInfoFromCache = getImsServiceInfoFromCache(deviceConfiguration);
            if (imsServiceInfoFromCache != null && !imsServiceInfoFromCache.featureFromMetadata && !arrayMap.containsKey(deviceConfiguration)) {
                arrayMap.put(deviceConfiguration, imsServiceInfoFromCache);
                Log.d(TAG, "updateBoundDeviceServices: Schedule query for package=" + deviceConfiguration);
                scheduleQueryForFeatures((ImsServiceInfo) arrayMap.get(deviceConfiguration));
            }
        }
    }

    private void updateBoundServices(int i, Map<Integer, String> map) {
        int i2 = i;
        if (i2 > -1 && i2 < this.mNumSlots) {
            char c = 0;
            int i3 = 0;
            boolean z = false;
            boolean z2 = false;
            while (i3 < 3) {
                String overridePackageName = getOverridePackageName(i2, i3);
                String carrierConfiguredPackageName = getCarrierConfiguredPackageName(i2, i3);
                String orDefault = map.getOrDefault(Integer.valueOf(i3), "");
                if (!TextUtils.isEmpty(overridePackageName)) {
                    Object[] objArr = new Object[4];
                    if (TextUtils.isEmpty(orDefault)) {
                        orDefault = "(none)";
                    }
                    objArr[c] = orDefault;
                    objArr[1] = overridePackageName;
                    objArr[2] = ImsFeature.FEATURE_LOG_MAP.getOrDefault(Integer.valueOf(i3), "invalid");
                    objArr[3] = Integer.valueOf(i);
                    Log.i(TAG, String.format("updateBoundServices: overriding %s with %s for feature %s on slot %d", objArr));
                } else {
                    overridePackageName = orDefault;
                }
                setCarrierConfiguredPackageName(overridePackageName, i2, i3);
                ImsServiceInfo imsServiceInfoFromCache = getImsServiceInfoFromCache(overridePackageName);
                Log.i(TAG, "updateBoundServices - carrier package changed: " + carrierConfiguredPackageName + " -> " + overridePackageName + " on slot " + i2 + ", hasConfigChanged=" + z);
                this.mEventLog.log("updateBoundServices - carrier package changed: " + carrierConfiguredPackageName + " -> " + overridePackageName + " on slot " + i2 + ", hasConfigChanged=" + z);
                if (imsServiceInfoFromCache == null || imsServiceInfoFromCache.featureFromMetadata) {
                    z = true;
                } else {
                    scheduleQueryForFeatures(imsServiceInfoFromCache);
                    z2 = true;
                }
                i3++;
                c = 0;
            }
            if (z) {
                calculateFeatureConfigurationChange();
            }
            if (z && z2) {
                this.mEventLog.log("[warning] updateBoundServices - both hasConfigChange and query scheduled on slot " + i2);
            }
        }
    }

    private Map<Integer, String> getImsPackageOverrideConfig(int i) {
        boolean z;
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(i);
        if (configForSubId == null) {
            return Collections.emptyMap();
        }
        String string = configForSubId.getString("config_ims_package_override_string", (String) null);
        String string2 = configForSubId.getString("config_ims_mmtel_package_override_string", string);
        String string3 = configForSubId.getString("config_ims_rcs_package_override_string", string);
        ArrayMap arrayMap = new ArrayMap();
        if (MTK_IMS_PACKAGE_NAME.equals(getDeviceConfiguration(0))) {
            if (TextUtils.isEmpty(string2) || MTK_IMS_PACKAGE_NAME.equals(string2)) {
                z = true;
            } else {
                Log.d(TAG, "getImsPackageOverrideConfig, bind to diff ims for mmTel");
                z = false;
            }
            if (!TextUtils.isEmpty(string3) && !MTK_IMS_PACKAGE_NAME.equals(string3)) {
                Log.d(TAG, "getImsPackageOverrideConfig, bind to diff ims for rcs");
                z = false;
            }
            if (z) {
                Log.d(TAG, "getImsPackageOverrideConfig, ignore config:" + string2 + ", " + string3);
                return arrayMap;
            }
        }
        if (!TextUtils.isEmpty(string2)) {
            arrayMap.put(0, string2);
            arrayMap.put(1, string2);
        }
        if (!TextUtils.isEmpty(string3)) {
            arrayMap.put(2, string3);
        }
        return arrayMap;
    }

    private void scheduleQueryForFeatures(ImsServiceInfo imsServiceInfo, int i) {
        if (imsServiceInfo != null) {
            Message obtain = Message.obtain(this.mHandler, 3, imsServiceInfo);
            if (this.mHandler.hasMessages(3, imsServiceInfo)) {
                Log.d(TAG, "scheduleQueryForFeatures: dynamic query for " + imsServiceInfo.name + " already scheduled");
                return;
            }
            Log.d(TAG, "scheduleQueryForFeatures: starting dynamic query for " + imsServiceInfo.name + " in " + i + "ms.");
            this.mHandler.sendMessageDelayed(obtain, (long) i);
        }
    }

    /* access modifiers changed from: private */
    public void scheduleQueryForFeatures(ComponentName componentName, int i) {
        ImsServiceInfo imsServiceInfoFromCache = getImsServiceInfoFromCache(componentName.getPackageName());
        if (imsServiceInfoFromCache == null) {
            Log.w(TAG, "scheduleQueryForFeatures: Couldn't find cached info for name: " + componentName);
            return;
        }
        scheduleQueryForFeatures(imsServiceInfoFromCache, i);
    }

    private void scheduleQueryForFeatures(ImsServiceInfo imsServiceInfo) {
        scheduleQueryForFeatures(imsServiceInfo, 0);
    }

    /* access modifiers changed from: private */
    public void handleFeaturesChanged(ComponentName componentName, Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        SomeArgs obtain = SomeArgs.obtain();
        obtain.arg1 = componentName;
        obtain.arg2 = set;
        this.mHandler.obtainMessage(4, obtain).sendToTarget();
    }

    /* access modifiers changed from: private */
    public void handleMsimConfigChange(Integer num) {
        int i = this.mNumSlots;
        if (i != num.intValue()) {
            this.mNumSlots = num.intValue();
            Log.i(TAG, "handleMsimConfigChange: oldLen=" + i + ", newLen=" + num);
            this.mEventLog.log("MSIM config change: " + i + " -> " + num);
            if (num.intValue() < i) {
                for (int intValue = num.intValue(); intValue < i; intValue++) {
                    for (Integer intValue2 : getCarrierConfiguredPackageNames(intValue).keySet()) {
                        setCarrierConfiguredPackageName("", intValue, intValue2.intValue());
                    }
                    SparseArray<String> overridePackageName = getOverridePackageName(intValue);
                    for (int i2 = 0; i2 < overridePackageName.size(); i2++) {
                        setOverridePackageName("", intValue, overridePackageName.keyAt(i2));
                    }
                    removeSlotId(intValue);
                }
            }
            for (ImsServiceInfo next : getImsServiceInfo((String) null)) {
                ImsServiceInfo imsServiceInfo = this.mInstalledServicesCache.get(next.name);
                if (imsServiceInfo == null) {
                    this.mEventLog.log("handleMsimConfigChange: detected untracked service - " + next);
                    Log.w(TAG, "handleMsimConfigChange: detected untracked package, queueing to add " + next);
                    this.mHandler.obtainMessage(0, next.name.getPackageName()).sendToTarget();
                } else if (next.featureFromMetadata) {
                    imsServiceInfo.replaceFeatures(next.getSupportedFeatures());
                } else {
                    imsServiceInfo.getSupportedFeatures().removeIf(new ImsResolver$$ExternalSyntheticLambda3(num));
                }
            }
            if (num.intValue() < i) {
                calculateFeatureConfigurationChange();
            }
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$handleMsimConfigChange$12(Integer num, ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.slotId >= num.intValue();
    }

    /* access modifiers changed from: private */
    public void startDynamicQuery(ImsServiceInfo imsServiceInfo) {
        if (isDeviceService(imsServiceInfo) || !getSlotsForActiveCarrierService(imsServiceInfo).isEmpty()) {
            LocalLog localLog = this.mEventLog;
            localLog.log("startDynamicQuery - starting query for " + imsServiceInfo);
            if (!this.mFeatureQueryManager.startQuery(imsServiceInfo.name, imsServiceInfo.controllerFactory.getServiceInterface())) {
                Log.w(TAG, "startDynamicQuery: service could not connect. Retrying after delay.");
                this.mEventLog.log("startDynamicQuery - query failed. Retrying in 5000 mS");
                scheduleQueryForFeatures(imsServiceInfo, (int) GbaManager.REQUEST_TIMEOUT_MS);
                return;
            }
            Log.d(TAG, "startDynamicQuery: Service queried, waiting for response.");
            return;
        }
        Log.i(TAG, "scheduleQueryForFeatures: skipping query for ImsService that is not set as carrier/device ImsService.");
    }

    /* access modifiers changed from: private */
    public void dynamicQueryComplete(ComponentName componentName, Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        ImsServiceInfo imsServiceInfoFromCache = getImsServiceInfoFromCache(componentName.getPackageName());
        if (imsServiceInfoFromCache == null) {
            Log.w(TAG, "dynamicQueryComplete: Couldn't find cached info for name: " + componentName);
            return;
        }
        sanitizeFeatureConfig(set);
        LocalLog localLog = this.mEventLog;
        localLog.log("dynamicQueryComplete: for package " + componentName + ", features: " + printFeatures(imsServiceInfoFromCache.getSupportedFeatures()) + " -> " + printFeatures(set));
        imsServiceInfoFromCache.replaceFeatures(set);
        if (!this.mFeatureQueryManager.isQueryInProgress()) {
            if (this.mHandler.hasMessages(4)) {
                this.mEventLog.log("[warning] dynamicQueryComplete - HANDLER_DYNAMIC_FEATURE_CHANGE pending with calculateFeatureConfigurationChange()");
            }
            calculateFeatureConfigurationChange();
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$sanitizeFeatureConfig$13(ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.slotId >= this.mNumSlots;
    }

    private void sanitizeFeatureConfig(Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        set.removeIf(new ImsResolver$$ExternalSyntheticLambda9(this));
        for (ImsFeatureConfiguration.FeatureSlotPair featureSlotPair : (Set) set.stream().filter(new ImsResolver$$ExternalSyntheticLambda10()).collect(Collectors.toSet())) {
            if (!set.contains(new ImsFeatureConfiguration.FeatureSlotPair(featureSlotPair.slotId, 1))) {
                set.remove(featureSlotPair);
            }
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$sanitizeFeatureConfig$14(ImsFeatureConfiguration.FeatureSlotPair featureSlotPair) {
        return featureSlotPair.featureType == 0;
    }

    private void calculateFeatureConfigurationChange() {
        for (ImsServiceInfo next : this.mInstalledServicesCache.values()) {
            HashSet<ImsFeatureConfiguration.FeatureSlotPair> calculateFeaturesToCreate = calculateFeaturesToCreate(next);
            if (shouldFeaturesCauseBind(calculateFeaturesToCreate)) {
                bindImsServiceWithFeatures(next, calculateFeaturesToCreate);
            } else {
                unbindImsService(next);
            }
        }
    }

    /* access modifiers changed from: private */
    public static String printFeatures(Set<ImsFeatureConfiguration.FeatureSlotPair> set) {
        StringBuilder sb = new StringBuilder();
        sb.append(" features: [");
        if (set != null) {
            for (ImsFeatureConfiguration.FeatureSlotPair next : set) {
                sb.append("{");
                sb.append(next.slotId);
                sb.append(",");
                sb.append((String) ImsFeature.FEATURE_LOG_MAP.get(Integer.valueOf(next.featureType)));
                sb.append("}");
            }
            sb.append("]");
        }
        return sb.toString();
    }

    @VisibleForTesting
    public ImsServiceInfo getImsServiceInfoFromCache(String str) {
        ImsServiceInfo infoByPackageName;
        if (!TextUtils.isEmpty(str) && (infoByPackageName = getInfoByPackageName(this.mInstalledServicesCache, str)) != null) {
            return infoByPackageName;
        }
        return null;
    }

    private List<ImsServiceInfo> getImsServiceInfo(String str) {
        ArrayList arrayList = new ArrayList();
        arrayList.addAll(searchForImsServices(str, this.mImsServiceControllerFactory));
        arrayList.addAll(searchForImsServices(str, this.mImsServiceControllerFactoryCompat));
        return arrayList;
    }

    private List<ImsServiceInfo> searchForImsServices(String str, ImsServiceControllerFactory imsServiceControllerFactory) {
        ArrayList arrayList = new ArrayList();
        Intent intent = new Intent(imsServiceControllerFactory.getServiceInterface());
        intent.setPackage(str);
        for (ResolveInfo resolveInfo : this.mContext.getPackageManager().queryIntentServicesAsUser(intent, 128, UserHandle.of(UserHandle.myUserId()))) {
            ServiceInfo serviceInfo = resolveInfo.serviceInfo;
            if (serviceInfo != null) {
                ImsServiceInfo imsServiceInfo = new ImsServiceInfo();
                imsServiceInfo.name = new ComponentName(serviceInfo.packageName, serviceInfo.name);
                imsServiceInfo.controllerFactory = imsServiceControllerFactory;
                if (isDeviceService(imsServiceInfo) || this.mImsServiceControllerFactoryCompat == imsServiceControllerFactory) {
                    Bundle bundle = serviceInfo.metaData;
                    if (bundle != null) {
                        if (bundle.getBoolean(METADATA_MMTEL_FEATURE, false)) {
                            imsServiceInfo.addFeatureForAllSlots(this.mNumSlots, 1);
                            if (serviceInfo.metaData.getBoolean(METADATA_EMERGENCY_MMTEL_FEATURE, false)) {
                                imsServiceInfo.addFeatureForAllSlots(this.mNumSlots, 0);
                            }
                        }
                        if (serviceInfo.metaData.getBoolean(METADATA_RCS_FEATURE, false)) {
                            imsServiceInfo.addFeatureForAllSlots(this.mNumSlots, 2);
                        }
                    }
                    if (this.mImsServiceControllerFactoryCompat != imsServiceControllerFactory && imsServiceInfo.getSupportedFeatures().isEmpty()) {
                        imsServiceInfo.featureFromMetadata = false;
                    }
                } else {
                    imsServiceInfo.featureFromMetadata = false;
                }
                Log.i(TAG, "service name: " + imsServiceInfo.name + ", manifest query: " + imsServiceInfo.featureFromMetadata);
                if (TextUtils.equals(serviceInfo.permission, "android.permission.BIND_IMS_SERVICE") || serviceInfo.metaData.getBoolean(METADATA_OVERRIDE_PERM_CHECK, false)) {
                    arrayList.add(imsServiceInfo);
                } else {
                    Log.w(TAG, "ImsService is not protected with BIND_IMS_SERVICE permission: " + imsServiceInfo.name);
                }
            }
        }
        return arrayList;
    }

    /* access modifiers changed from: private */
    public int getSubIdUsingPhoneId(int i) {
        int[] subId = SubscriptionManager.getSubId(i);
        if (subId == null || subId.length < 1) {
            return -1;
        }
        return subId[0];
    }

    /* access modifiers changed from: private */
    public void setSubId(int i, int i2) {
        synchronized (this.mSlotIdToSubIdMap) {
            this.mSlotIdToSubIdMap.put(i, i2);
        }
    }

    /* access modifiers changed from: private */
    public int getSubId(int i) {
        int i2;
        synchronized (this.mSlotIdToSubIdMap) {
            i2 = this.mSlotIdToSubIdMap.get(i, -1);
        }
        return i2;
    }

    private void removeSlotId(int i) {
        synchronized (this.mSlotIdToSubIdMap) {
            this.mSlotIdToSubIdMap.delete(i);
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println("ImsResolver:");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("Configurations:");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("Device:");
        indentingPrintWriter.increaseIndent();
        synchronized (this.mDeviceServices) {
            for (Integer next : this.mDeviceServices.keySet()) {
                indentingPrintWriter.println(((String) ImsFeature.FEATURE_LOG_MAP.get(next)) + " -> " + this.mDeviceServices.get(next));
            }
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Carrier: ");
        indentingPrintWriter.increaseIndent();
        for (int i = 0; i < this.mNumSlots; i++) {
            for (int i2 = 0; i2 < 3; i2++) {
                indentingPrintWriter.print("slot=");
                indentingPrintWriter.print(i);
                indentingPrintWriter.print(", feature=");
                indentingPrintWriter.print((String) ImsFeature.FEATURE_LOG_MAP.getOrDefault(Integer.valueOf(i2), "?"));
                indentingPrintWriter.println(": ");
                indentingPrintWriter.increaseIndent();
                String carrierConfiguredPackageName = getCarrierConfiguredPackageName(i, i2);
                if (TextUtils.isEmpty(carrierConfiguredPackageName)) {
                    carrierConfiguredPackageName = "none";
                }
                indentingPrintWriter.println(carrierConfiguredPackageName);
                indentingPrintWriter.decreaseIndent();
            }
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Cached ImsServices:");
        indentingPrintWriter.increaseIndent();
        for (ImsServiceInfo println : this.mInstalledServicesCache.values()) {
            indentingPrintWriter.println(println);
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Active controllers:");
        indentingPrintWriter.increaseIndent();
        for (ImsServiceController next2 : this.mActiveControllers.values()) {
            indentingPrintWriter.println(next2);
            indentingPrintWriter.increaseIndent();
            next2.dump(indentingPrintWriter);
            indentingPrintWriter.decreaseIndent();
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Connection Repository Log:");
        indentingPrintWriter.increaseIndent();
        this.mRepo.dump(indentingPrintWriter);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Event Log:");
        indentingPrintWriter.increaseIndent();
        this.mEventLog.dump(indentingPrintWriter);
        indentingPrintWriter.decreaseIndent();
    }
}
