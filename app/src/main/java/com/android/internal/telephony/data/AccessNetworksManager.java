package com.android.internal.telephony.data;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.os.SystemProperties;
import android.os.UserHandle;
import android.telephony.AccessNetworkConstants;
import android.telephony.AnomalyReporter;
import android.telephony.CarrierConfigManager;
import android.telephony.data.ApnSetting;
import android.telephony.data.IQualifiedNetworksService;
import android.telephony.data.IQualifiedNetworksServiceCallback;
import android.telephony.data.ThrottleStatus;
import android.text.TextUtils;
import android.util.ArraySet;
import android.util.SparseArray;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.RIL;
import com.android.internal.telephony.RILUtils$$ExternalSyntheticLambda5;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.data.DataRetryManager;
import com.android.internal.telephony.dataconnection.DataThrottler;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executor;
import java.util.stream.Collectors;

public class AccessNetworksManager extends Handler {
    private static final boolean DBG = false;
    public static final String IWLAN_OPERATION_MODE_AP_ASSISTED = "AP-assisted";
    public static final String IWLAN_OPERATION_MODE_DEFAULT = "default";
    public static final String IWLAN_OPERATION_MODE_LEGACY = "legacy";
    public static final int[] SUPPORTED_APN_TYPES = {17, 2, 32, 64, 128, 4, 512, 2048};
    public static final String SYSTEM_PROPERTIES_IWLAN_OPERATION_MODE = "ro.telephony.iwlan_operation_mode";
    /* access modifiers changed from: private */
    public final Set<AccessNetworksManagerCallback> mAccessNetworksManagerCallbacks;
    /* access modifiers changed from: private */
    public final UUID mAnomalyUUID = UUID.fromString("c2d1a639-00e2-4561-9619-6acf37d90590");
    /* access modifiers changed from: private */
    public final SparseArray<int[]> mAvailableNetworks = new SparseArray<>();
    private final int[] mAvailableTransports;
    private final CarrierConfigManager mCarrierConfigManager;
    private final BroadcastReceiver mConfigChangedReceiver;
    private final Map<Integer, Integer> mCurrentTransports;
    /* access modifiers changed from: private */
    public final Set<DataThrottler> mDataThrottlers = new HashSet();
    /* access modifiers changed from: private */
    public AccessNetworksManagerDeathRecipient mDeathRecipient;
    /* access modifiers changed from: private */
    public IQualifiedNetworksService mIQualifiedNetworksService;
    /* access modifiers changed from: private */
    public String mLastBoundPackageName;
    private final LocalLog mLocalLog = new LocalLog(64);
    private final String mLogTag;
    /* access modifiers changed from: private */
    public final Phone mPhone;
    /* access modifiers changed from: private */
    public final Map<Integer, Integer> mPreferredTransports;
    /* access modifiers changed from: private */
    public final RegistrantList mQualifiedNetworksChangedRegistrants = new RegistrantList();
    private QualifiedNetworksServiceConnection mServiceConnection;
    /* access modifiers changed from: private */
    public String mTargetBindingPackageName;

    @Retention(RetentionPolicy.SOURCE)
    public @interface IwlanOperationMode {
    }

    private static int getTransportFromAccessNetwork(int i) {
        return i == 5 ? 2 : 1;
    }

    public void registerDataThrottler(DataThrottler dataThrottler) {
        post(new AccessNetworksManager$$ExternalSyntheticLambda5(this, dataThrottler));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$registerDataThrottler$0(DataThrottler dataThrottler) {
        QualifiedNetworksServiceConnection qualifiedNetworksServiceConnection = this.mServiceConnection;
        this.mDataThrottlers.add(dataThrottler);
        if (qualifiedNetworksServiceConnection != null) {
            qualifiedNetworksServiceConnection.registerDataThrottler(dataThrottler);
        }
    }

    public static class QualifiedNetworks {
        public final int apnType;
        public final int[] qualifiedNetworks;

        public QualifiedNetworks(int i, int[] iArr) {
            this.apnType = i;
            this.qualifiedNetworks = Arrays.stream(iArr).boxed().filter(new AccessNetworksManager$QualifiedNetworks$$ExternalSyntheticLambda1()).mapToInt(new RILUtils$$ExternalSyntheticLambda5()).toArray();
        }

        public String toString() {
            return "[QualifiedNetworks: apnType=" + ApnSetting.getApnTypeString(this.apnType) + ", networks=" + ((String) Arrays.stream(this.qualifiedNetworks).mapToObj(new AccessNetworksManager$QualifiedNetworks$$ExternalSyntheticLambda0()).collect(Collectors.joining(","))) + "]";
        }
    }

    private class AccessNetworksManagerDeathRecipient implements IBinder.DeathRecipient {
        private AccessNetworksManagerDeathRecipient() {
        }

        public void binderDied() {
            String str = "Qualified network service " + AccessNetworksManager.this.mLastBoundPackageName + " died.";
            AccessNetworksManager.this.loge(str);
            AnomalyReporter.reportAnomaly(AccessNetworksManager.this.mAnomalyUUID, str, AccessNetworksManager.this.mPhone.getCarrierId());
        }
    }

    private final class QualifiedNetworksServiceConnection implements ServiceConnection {
        private final ThrottleStatusChangedCallback mThrottleStatusCallback;

        QualifiedNetworksServiceConnection() {
            this.mThrottleStatusCallback = new ThrottleStatusChangedCallback();
        }

        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            AccessNetworksManager.this.mIQualifiedNetworksService = IQualifiedNetworksService.Stub.asInterface(iBinder);
            AccessNetworksManager accessNetworksManager = AccessNetworksManager.this;
            accessNetworksManager.mDeathRecipient = new AccessNetworksManagerDeathRecipient();
            AccessNetworksManager accessNetworksManager2 = AccessNetworksManager.this;
            accessNetworksManager2.mLastBoundPackageName = accessNetworksManager2.getQualifiedNetworksServicePackageName();
            try {
                iBinder.linkToDeath(AccessNetworksManager.this.mDeathRecipient, 0);
                AccessNetworksManager.this.mIQualifiedNetworksService.createNetworkAvailabilityProvider(AccessNetworksManager.this.mPhone.getPhoneId(), new QualifiedNetworksServiceCallback());
                registerDataThrottlersFirstTime();
            } catch (RemoteException e) {
                AccessNetworksManager accessNetworksManager3 = AccessNetworksManager.this;
                accessNetworksManager3.loge("Remote exception. " + e);
            }
        }

        public void onServiceDisconnected(ComponentName componentName) {
            unregisterForThrottleCallbacks();
            AccessNetworksManager.this.mTargetBindingPackageName = null;
        }

        private void registerDataThrottlersFirstTime() {
            AccessNetworksManager.this.post(new AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda0(this));
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$registerDataThrottlersFirstTime$0() {
            for (DataThrottler registerForThrottleStatusChanges : AccessNetworksManager.this.mDataThrottlers) {
                registerForThrottleStatusChanges.registerForThrottleStatusChanges(this.mThrottleStatusCallback);
            }
        }

        /* access modifiers changed from: private */
        public void registerDataThrottler(DataThrottler dataThrottler) {
            AccessNetworksManager.this.post(new AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2(this, dataThrottler));
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$registerDataThrottler$1(DataThrottler dataThrottler) {
            dataThrottler.registerForThrottleStatusChanges(this.mThrottleStatusCallback);
        }

        private void unregisterForThrottleCallbacks() {
            AccessNetworksManager.this.post(new AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda1(this));
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$unregisterForThrottleCallbacks$2() {
            for (DataThrottler unregisterForThrottleStatusChanges : AccessNetworksManager.this.mDataThrottlers) {
                unregisterForThrottleStatusChanges.unregisterForThrottleStatusChanges(this.mThrottleStatusCallback);
            }
        }
    }

    private class ThrottleStatusChangedCallback implements DataThrottler.Callback {
        private ThrottleStatusChangedCallback() {
        }

        public void onThrottleStatusChanged(List<ThrottleStatus> list) {
            AccessNetworksManager.this.post(new AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda1(this, list));
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$onThrottleStatusChanged$1(List list) {
            try {
                List list2 = (List) list.stream().filter(new AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda0(this)).collect(Collectors.toList());
                if (AccessNetworksManager.this.mIQualifiedNetworksService != null) {
                    AccessNetworksManager.this.mIQualifiedNetworksService.reportThrottleStatusChanged(AccessNetworksManager.this.mPhone.getPhoneId(), list2);
                }
            } catch (Exception e) {
                AccessNetworksManager.this.loge("onThrottleStatusChanged", e);
            }
        }

        /* access modifiers changed from: private */
        public /* synthetic */ boolean lambda$onThrottleStatusChanged$0(ThrottleStatus throttleStatus) {
            return throttleStatus.getSlotIndex() == AccessNetworksManager.this.mPhone.getPhoneId();
        }
    }

    private final class QualifiedNetworksServiceCallback extends IQualifiedNetworksServiceCallback.Stub {
        private QualifiedNetworksServiceCallback() {
        }

        public void onQualifiedNetworkTypesChanged(int i, int[] iArr) {
            if (iArr == null) {
                AccessNetworksManager.this.loge("onQualifiedNetworkTypesChanged: Ignored null input.");
                return;
            }
            AccessNetworksManager.this.log("onQualifiedNetworkTypesChanged: apnTypes = [" + ApnSetting.getApnTypesStringFromBitmask(i) + "], networks = [" + ((String) Arrays.stream(iArr).mapToObj(new AccessNetworksManager$QualifiedNetworks$$ExternalSyntheticLambda0()).collect(Collectors.joining(","))) + "]");
            if (Arrays.stream(iArr).anyMatch(new AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda0())) {
                AccessNetworksManager.this.loge("Invalid access networks " + Arrays.toString(iArr));
                return;
            }
            ArrayList arrayList = new ArrayList();
            for (int i2 : AccessNetworksManager.SUPPORTED_APN_TYPES) {
                if ((i & i2) == i2) {
                    if (AccessNetworksManager.this.mAvailableNetworks.get(i2) != null && Arrays.equals((int[]) AccessNetworksManager.this.mAvailableNetworks.get(i2), iArr)) {
                        AccessNetworksManager.this.log("Available networks for " + ApnSetting.getApnTypesStringFromBitmask(i2) + " not changed.");
                    } else if (iArr.length == 0) {
                        AccessNetworksManager.this.mAvailableNetworks.remove(i2);
                        if (AccessNetworksManager.this.getPreferredTransport(i2) == 2) {
                            AccessNetworksManager.this.mPreferredTransports.put(Integer.valueOf(i2), 1);
                            AccessNetworksManager.this.mAccessNetworksManagerCallbacks.forEach(new AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda1(i2));
                        }
                    } else {
                        AccessNetworksManager.this.mAvailableNetworks.put(i2, iArr);
                        arrayList.add(new QualifiedNetworks(i2, iArr));
                    }
                }
            }
            if (!arrayList.isEmpty()) {
                AccessNetworksManager.this.setPreferredTransports(arrayList);
                AccessNetworksManager.this.mQualifiedNetworksChangedRegistrants.notifyResult(arrayList);
            }
        }

        /* access modifiers changed from: private */
        public static /* synthetic */ boolean lambda$onQualifiedNetworkTypesChanged$0(int i) {
            return !DataUtils.isValidAccessNetwork(i);
        }
    }

    public static abstract class AccessNetworksManagerCallback extends DataCallback {
        public abstract void onPreferredTransportChanged(int i);

        public AccessNetworksManagerCallback(Executor executor) {
            super(executor);
        }
    }

    public AccessNetworksManager(Phone phone, Looper looper) {
        super(looper);
        AnonymousClass1 r7 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.telephony.action.CARRIER_CONFIG_CHANGED".equals(intent.getAction()) && AccessNetworksManager.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", 0)) {
                    AccessNetworksManager.this.bindQualifiedNetworksService();
                }
            }
        };
        this.mConfigChangedReceiver = r7;
        this.mCurrentTransports = new ConcurrentHashMap();
        this.mPreferredTransports = new ConcurrentHashMap();
        this.mAccessNetworksManagerCallbacks = new ArraySet();
        this.mPhone = phone;
        this.mCarrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService("carrier_config");
        this.mLogTag = "ANM-" + phone.getPhoneId();
        if (isInLegacyMode()) {
            log("operates in legacy mode.");
            this.mAvailableTransports = new int[]{1};
        } else {
            log("operates in AP-assisted mode.");
            this.mAvailableTransports = new int[]{1, 2};
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
            try {
                phone.getContext().createPackageContextAsUser(phone.getContext().getPackageName(), 0, UserHandle.ALL).registerReceiver(r7, intentFilter, (String) null, (Handler) null);
            } catch (PackageManager.NameNotFoundException e) {
                loge("Package name not found: ", e);
            }
            bindQualifiedNetworksService();
        }
        if (phone.isUsingNewDataStack()) {
            post(new AccessNetworksManager$$ExternalSyntheticLambda3(this));
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$new$1() {
        this.mPhone.getDataNetworkController().getDataRetryManager().registerCallback(new DataRetryManager.DataRetryManagerCallback(new AccessNetworksManager$$ExternalSyntheticLambda1(this)) {
            public void onThrottleStatusChanged(List<ThrottleStatus> list) {
                try {
                    AccessNetworksManager accessNetworksManager = AccessNetworksManager.this;
                    accessNetworksManager.logl("onThrottleStatusChanged: " + list);
                    if (AccessNetworksManager.this.mIQualifiedNetworksService != null) {
                        AccessNetworksManager.this.mIQualifiedNetworksService.reportThrottleStatusChanged(AccessNetworksManager.this.mPhone.getPhoneId(), list);
                    }
                } catch (Exception e) {
                    AccessNetworksManager.this.loge("onThrottleStatusChanged: ", e);
                }
            }
        });
    }

    /* access modifiers changed from: private */
    public void bindQualifiedNetworksService() {
        post(new AccessNetworksManager$$ExternalSyntheticLambda4(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$bindQualifiedNetworksService$2() {
        Intent intent;
        String qualifiedNetworksServicePackageName = getQualifiedNetworksServicePackageName();
        String qualifiedNetworksServiceClassName = getQualifiedNetworksServiceClassName();
        if (TextUtils.isEmpty(qualifiedNetworksServicePackageName)) {
            loge("Can't find the binding package");
            return;
        }
        if (TextUtils.isEmpty(qualifiedNetworksServiceClassName)) {
            intent = new Intent("android.telephony.data.QualifiedNetworksService");
            intent.setPackage(qualifiedNetworksServicePackageName);
        } else {
            intent = new Intent("android.telephony.data.QualifiedNetworksService").setComponent(new ComponentName(qualifiedNetworksServicePackageName, qualifiedNetworksServiceClassName));
        }
        if (!TextUtils.equals(qualifiedNetworksServicePackageName, this.mTargetBindingPackageName)) {
            IQualifiedNetworksService iQualifiedNetworksService = this.mIQualifiedNetworksService;
            if (iQualifiedNetworksService != null && iQualifiedNetworksService.asBinder().isBinderAlive()) {
                try {
                    this.mIQualifiedNetworksService.removeNetworkAvailabilityProvider(this.mPhone.getPhoneId());
                } catch (RemoteException e) {
                    loge("Cannot remove network availability updater. " + e);
                }
                this.mPhone.getContext().unbindService(this.mServiceConnection);
            }
            try {
                this.mServiceConnection = new QualifiedNetworksServiceConnection();
                log("bind to " + qualifiedNetworksServicePackageName);
                if (!this.mPhone.getContext().bindService(intent, this.mServiceConnection, 1)) {
                    loge("Cannot bind to the qualified networks service.");
                } else {
                    this.mTargetBindingPackageName = qualifiedNetworksServicePackageName;
                }
            } catch (Exception e2) {
                loge("Cannot bind to the qualified networks service. Exception: " + e2);
            }
        }
    }

    /* access modifiers changed from: private */
    public String getQualifiedNetworksServicePackageName() {
        String string = this.mPhone.getContext().getResources().getString(17040025);
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        if (configForSubId == null) {
            return string;
        }
        String string2 = configForSubId.getString("carrier_qualified_networks_service_package_override_string");
        return !TextUtils.isEmpty(string2) ? string2 : string;
    }

    private String getQualifiedNetworksServiceClassName() {
        String string = this.mPhone.getContext().getResources().getString(17040024);
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        if (configForSubId == null) {
            return string;
        }
        String string2 = configForSubId.getString("carrier_qualified_networks_service_class_override_string");
        return !TextUtils.isEmpty(string2) ? string2 : string;
    }

    private List<QualifiedNetworks> getQualifiedNetworksList() {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < this.mAvailableNetworks.size(); i++) {
            arrayList.add(new QualifiedNetworks(this.mAvailableNetworks.keyAt(i), this.mAvailableNetworks.valueAt(i)));
        }
        return arrayList;
    }

    public void registerForQualifiedNetworksChanged(Handler handler, int i) {
        if (handler != null) {
            Registrant registrant = new Registrant(handler, i, (Object) null);
            this.mQualifiedNetworksChangedRegistrants.add(registrant);
            if (this.mAvailableNetworks.size() != 0) {
                registrant.notifyResult(getQualifiedNetworksList());
            }
        }
    }

    public boolean isInLegacyMode() {
        String str = SystemProperties.get(SYSTEM_PROPERTIES_IWLAN_OPERATION_MODE);
        if (str.equals(IWLAN_OPERATION_MODE_AP_ASSISTED)) {
            return false;
        }
        if (str.equals(IWLAN_OPERATION_MODE_LEGACY)) {
            return true;
        }
        return this.mPhone.getHalVersion().less(RIL.RADIO_HAL_VERSION_1_4);
    }

    public synchronized int[] getAvailableTransports() {
        return this.mAvailableTransports;
    }

    public int getCurrentTransportByNetworkCapability(int i) {
        return getCurrentTransport(DataUtils.networkCapabilityToApnType(i));
    }

    public int getCurrentTransport(int i) {
        if (!isInLegacyMode() && this.mCurrentTransports.get(Integer.valueOf(i)) != null) {
            return this.mCurrentTransports.get(Integer.valueOf(i)).intValue();
        }
        return 1;
    }

    public void setCurrentTransportByNetworkCapability(int i, int i2) {
        setCurrentTransport(DataUtils.networkCapabilityToApnType(i), i2);
    }

    public void setCurrentTransport(int i, int i2) {
        Integer put = this.mCurrentTransports.put(Integer.valueOf(i), Integer.valueOf(i2));
        if (put == null || put.intValue() != i2) {
            logl("setCurrentTransport: apnType=" + ApnSetting.getApnTypeString(i) + ", transport=" + AccessNetworkConstants.transportTypeToString(i2));
        }
    }

    /* access modifiers changed from: private */
    public void setPreferredTransports(List<QualifiedNetworks> list) {
        int transportFromAccessNetwork;
        for (QualifiedNetworks next : list) {
            int[] iArr = next.qualifiedNetworks;
            if (iArr.length > 0 && getPreferredTransport(next.apnType) != (transportFromAccessNetwork = getTransportFromAccessNetwork(iArr[0]))) {
                this.mPreferredTransports.put(Integer.valueOf(next.apnType), Integer.valueOf(transportFromAccessNetwork));
                this.mAccessNetworksManagerCallbacks.forEach(new AccessNetworksManager$$ExternalSyntheticLambda2(next));
                logl("setPreferredTransports: apnType=" + ApnSetting.getApnTypeString(next.apnType) + ", transport=" + AccessNetworkConstants.transportTypeToString(transportFromAccessNetwork));
            }
        }
    }

    public int getPreferredTransport(int i) {
        if (!isInLegacyMode() && this.mPreferredTransports.get(Integer.valueOf(i)) != null) {
            return this.mPreferredTransports.get(Integer.valueOf(i)).intValue();
        }
        return 1;
    }

    public int getPreferredTransportByNetworkCapability(int i) {
        int networkCapabilityToApnType = DataUtils.networkCapabilityToApnType(i);
        if (networkCapabilityToApnType == 0) {
            return 1;
        }
        return getPreferredTransport(networkCapabilityToApnType);
    }

    public boolean isAnyApnOnIwlan() {
        for (int i : SUPPORTED_APN_TYPES) {
            if (this.mPhone.isUsingNewDataStack()) {
                if (getPreferredTransport(i) == 2) {
                    return true;
                }
            } else if (getCurrentTransport(i) == 2) {
                return true;
            }
        }
        return false;
    }

    public void unregisterForQualifiedNetworksChanged(Handler handler) {
        if (handler != null) {
            this.mQualifiedNetworksChangedRegistrants.remove(handler);
        }
    }

    public void registerCallback(AccessNetworksManagerCallback accessNetworksManagerCallback) {
        this.mAccessNetworksManagerCallbacks.add(accessNetworksManagerCallback);
    }

    public void unregisterCallback(AccessNetworksManagerCallback accessNetworksManagerCallback) {
        this.mAccessNetworksManagerCallbacks.remove(accessNetworksManagerCallback);
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    /* access modifiers changed from: private */
    public void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    /* access modifiers changed from: private */
    public void loge(String str, Exception exc) {
        Rlog.e(this.mLogTag, str, exc);
    }

    /* access modifiers changed from: private */
    public void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(AccessNetworksManager.class.getSimpleName() + "-" + this.mPhone.getPhoneId() + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        androidUtilIndentingPrintWriter.println("current transports=");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (int i : SUPPORTED_APN_TYPES) {
            androidUtilIndentingPrintWriter.println(ApnSetting.getApnTypeString(i) + ": " + AccessNetworkConstants.transportTypeToString(getCurrentTransport(i)));
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("preferred transports=");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (int i2 : SUPPORTED_APN_TYPES) {
            androidUtilIndentingPrintWriter.println(ApnSetting.getApnTypeString(i2) + ": " + AccessNetworkConstants.transportTypeToString(getPreferredTransport(i2)));
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("isInLegacy=" + isInLegacyMode());
        androidUtilIndentingPrintWriter.println("IWLAN operation mode=" + SystemProperties.get(SYSTEM_PROPERTIES_IWLAN_OPERATION_MODE));
        androidUtilIndentingPrintWriter.println("Local logs=");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.flush();
    }
}
