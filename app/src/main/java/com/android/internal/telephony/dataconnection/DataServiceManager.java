package com.android.internal.telephony.dataconnection;

import android.app.AppOpsManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.ServiceInfo;
import android.net.LinkProperties;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.os.UserHandle;
import android.permission.LegacyPermissionManager;
import android.telephony.AccessNetworkConstants;
import android.telephony.AnomalyReporter;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionManager;
import android.telephony.data.DataCallResponse;
import android.telephony.data.DataProfile;
import android.telephony.data.IDataService;
import android.telephony.data.IDataServiceCallback;
import android.telephony.data.NetworkSliceInfo;
import android.telephony.data.TrafficDescriptor;
import android.text.TextUtils;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConfigurationManager;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.data.DataServiceManager$$ExternalSyntheticLambda0;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;

public class DataServiceManager extends Handler {
    private static final long CHANGE_PERMISSION_TIMEOUT_MS = 15000;
    static final String DATA_CALL_RESPONSE = "data_call_response";
    private static final boolean DBG = true;
    private static final int EVENT_BIND_DATA_SERVICE = 1;
    private static final int EVENT_WATCHDOG_TIMEOUT = 2;
    private static final long REQUEST_UNRESPONDED_TIMEOUT = 600000;
    /* access modifiers changed from: private */
    public final UUID mAnomalyUUID = UUID.fromString("fc1956de-c080-45de-8431-a1faab687110");
    /* access modifiers changed from: private */
    public final RegistrantList mApnUnthrottledRegistrants = new RegistrantList();
    private final AppOpsManager mAppOps;
    /* access modifiers changed from: private */
    public boolean mBound;
    private final BroadcastReceiver mBroadcastReceiver;
    private final CarrierConfigManager mCarrierConfigManager;
    /* access modifiers changed from: private */
    public final RegistrantList mDataCallListChangedRegistrants = new RegistrantList();
    /* access modifiers changed from: private */
    public DataServiceManagerDeathRecipient mDeathRecipient;
    /* access modifiers changed from: private */
    public IDataService mIDataService;
    /* access modifiers changed from: private */
    public String mLastBoundPackageName;
    /* access modifiers changed from: private */
    public final Map<IBinder, Message> mMessageMap = new ConcurrentHashMap();
    private final LegacyPermissionManager mPermissionManager;
    /* access modifiers changed from: private */
    public final Phone mPhone;
    /* access modifiers changed from: private */
    public final RegistrantList mServiceBindingChangedRegistrants = new RegistrantList();
    private CellularDataServiceConnection mServiceConnection;
    private final String mTag;
    /* access modifiers changed from: private */
    public String mTargetBindingPackageName;
    /* access modifiers changed from: private */
    public final int mTransportType;

    public String getTag() {
        return this.mTag;
    }

    private class DataServiceManagerDeathRecipient implements IBinder.DeathRecipient {
        private DataServiceManagerDeathRecipient() {
        }

        public void binderDied() {
            String str = "Data service " + DataServiceManager.this.mLastBoundPackageName + " for transport type " + AccessNetworkConstants.transportTypeToString(DataServiceManager.this.mTransportType) + " died.";
            DataServiceManager.this.loge(str);
            AnomalyReporter.reportAnomaly(DataServiceManager.this.mAnomalyUUID, str, DataServiceManager.this.mPhone.getCarrierId());
        }
    }

    private void grantPermissionsToService(String str) {
        String[] strArr = {str};
        CountDownLatch countDownLatch = new CountDownLatch(1);
        try {
            this.mPermissionManager.grantDefaultPermissionsToEnabledTelephonyDataServices(strArr, UserHandle.of(UserHandle.myUserId()), new DataServiceManager$$ExternalSyntheticLambda0(), new DataServiceManager$$ExternalSyntheticLambda0(this, countDownLatch));
            TelephonyUtils.waitUntilReady(countDownLatch, CHANGE_PERMISSION_TIMEOUT_MS);
            this.mAppOps.setMode("android:manage_ipsec_tunnels", UserHandle.myUserId(), strArr[0], 0);
            this.mAppOps.setMode("android:fine_location", UserHandle.myUserId(), strArr[0], 0);
        } catch (RuntimeException e) {
            loge("Binder to package manager died, permission grant for DataService failed.");
            throw e;
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$grantPermissionsToService$0(CountDownLatch countDownLatch, Boolean bool) {
        if (bool.booleanValue()) {
            countDownLatch.countDown();
        } else {
            loge("Failed to grant permissions to service.");
        }
    }

    private void revokePermissionsFromUnusedDataServices() {
        Set<String> allDataServicePackageNames = getAllDataServicePackageNames();
        for (int dataServicePackageName : this.mPhone.getAccessNetworksManager().getAvailableTransports()) {
            allDataServicePackageNames.remove(getDataServicePackageName(dataServicePackageName));
        }
        CountDownLatch countDownLatch = new CountDownLatch(1);
        try {
            String[] strArr = new String[allDataServicePackageNames.size()];
            allDataServicePackageNames.toArray(strArr);
            this.mPermissionManager.revokeDefaultPermissionsFromDisabledTelephonyDataServices(strArr, UserHandle.of(UserHandle.myUserId()), new DataServiceManager$$ExternalSyntheticLambda0(), new DataServiceManager$$ExternalSyntheticLambda1(this, countDownLatch));
            TelephonyUtils.waitUntilReady(countDownLatch, CHANGE_PERMISSION_TIMEOUT_MS);
            for (String next : allDataServicePackageNames) {
                this.mAppOps.setMode("android:manage_ipsec_tunnels", UserHandle.myUserId(), next, 2);
                this.mAppOps.setMode("android:fine_location", UserHandle.myUserId(), next, 2);
            }
        } catch (RuntimeException e) {
            loge("Binder to package manager died; failed to revoke DataService permissions.");
            throw e;
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$revokePermissionsFromUnusedDataServices$1(CountDownLatch countDownLatch, Boolean bool) {
        if (bool.booleanValue()) {
            countDownLatch.countDown();
        } else {
            loge("Failed to revoke permissions from data services.");
        }
    }

    private final class CellularDataServiceConnection implements ServiceConnection {
        private CellularDataServiceConnection() {
        }

        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            DataServiceManager.this.log("onServiceConnected");
            DataServiceManager.this.mIDataService = IDataService.Stub.asInterface(iBinder);
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.mDeathRecipient = new DataServiceManagerDeathRecipient();
            DataServiceManager.this.mBound = true;
            DataServiceManager dataServiceManager2 = DataServiceManager.this;
            dataServiceManager2.mLastBoundPackageName = dataServiceManager2.getDataServicePackageName();
            DataServiceManager.this.removeMessages(2);
            try {
                iBinder.linkToDeath(DataServiceManager.this.mDeathRecipient, 0);
                DataServiceManager.this.mIDataService.createDataServiceProvider(DataServiceManager.this.mPhone.getPhoneId());
                DataServiceManager.this.mIDataService.registerForDataCallListChanged(DataServiceManager.this.mPhone.getPhoneId(), new CellularDataServiceCallback("dataCallListChanged"));
                DataServiceManager.this.mIDataService.registerForUnthrottleApn(DataServiceManager.this.mPhone.getPhoneId(), new CellularDataServiceCallback("unthrottleApn"));
                DataServiceManager.this.mServiceBindingChangedRegistrants.notifyResult(Boolean.TRUE);
            } catch (RemoteException e) {
                DataServiceManager dataServiceManager3 = DataServiceManager.this;
                dataServiceManager3.loge("Remote exception. " + e);
            }
        }

        public void onServiceDisconnected(ComponentName componentName) {
            DataServiceManager.this.log("onServiceDisconnected");
            DataServiceManager.this.removeMessages(2);
            DataServiceManager.this.mIDataService = null;
            DataServiceManager.this.mBound = false;
            DataServiceManager.this.mServiceBindingChangedRegistrants.notifyResult(Boolean.FALSE);
            DataServiceManager.this.mTargetBindingPackageName = null;
        }
    }

    private final class CellularDataServiceCallback extends IDataServiceCallback.Stub {
        private final String mTag;

        CellularDataServiceCallback(String str) {
            this.mTag = str;
        }

        public String getTag() {
            return this.mTag;
        }

        public void onSetupDataCallComplete(int i, DataCallResponse dataCallResponse) {
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.log("onSetupDataCallComplete. resultCode = " + i + ", response = " + dataCallResponse);
            DataServiceManager.this.removeMessages(2, this);
            Message message = (Message) DataServiceManager.this.mMessageMap.remove(asBinder());
            if (message != null) {
                message.getData().putParcelable(DataServiceManager.DATA_CALL_RESPONSE, dataCallResponse);
                DataServiceManager.this.sendCompleteMessage(message, i);
                return;
            }
            DataServiceManager.this.loge("Unable to find the message for setup call response.");
        }

        public void onDeactivateDataCallComplete(int i) {
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.log("onDeactivateDataCallComplete. resultCode = " + i);
            DataServiceManager.this.removeMessages(2, this);
            DataServiceManager.this.sendCompleteMessage((Message) DataServiceManager.this.mMessageMap.remove(asBinder()), i);
        }

        public void onSetInitialAttachApnComplete(int i) {
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.log("onSetInitialAttachApnComplete. resultCode = " + i);
            DataServiceManager.this.sendCompleteMessage((Message) DataServiceManager.this.mMessageMap.remove(asBinder()), i);
        }

        public void onSetDataProfileComplete(int i) {
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.log("onSetDataProfileComplete. resultCode = " + i);
            DataServiceManager.this.sendCompleteMessage((Message) DataServiceManager.this.mMessageMap.remove(asBinder()), i);
        }

        public void onRequestDataCallListComplete(int i, List<DataCallResponse> list) {
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.log("onRequestDataCallListComplete. resultCode = " + i);
            DataServiceManager.this.sendCompleteMessage((Message) DataServiceManager.this.mMessageMap.remove(asBinder()), i);
        }

        public void onDataCallListChanged(List<DataCallResponse> list) {
            DataServiceManager.this.mDataCallListChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, list, (Throwable) null));
        }

        public void onHandoverStarted(int i) {
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.log("onHandoverStarted. resultCode = " + i);
            DataServiceManager.this.removeMessages(2, this);
            DataServiceManager.this.sendCompleteMessage((Message) DataServiceManager.this.mMessageMap.remove(asBinder()), i);
        }

        public void onHandoverCancelled(int i) {
            DataServiceManager dataServiceManager = DataServiceManager.this;
            dataServiceManager.log("onHandoverCancelled. resultCode = " + i);
            DataServiceManager.this.removeMessages(2, this);
            DataServiceManager.this.sendCompleteMessage((Message) DataServiceManager.this.mMessageMap.remove(asBinder()), i);
        }

        public void onApnUnthrottled(String str) {
            if (str != null) {
                DataServiceManager.this.mApnUnthrottledRegistrants.notifyRegistrants(new AsyncResult((Object) null, str, (Throwable) null));
            } else {
                DataServiceManager.this.loge("onApnUnthrottled: apn is null");
            }
        }

        public void onDataProfileUnthrottled(DataProfile dataProfile) {
            if (dataProfile != null) {
                DataServiceManager.this.mApnUnthrottledRegistrants.notifyRegistrants(new AsyncResult((Object) null, dataProfile, (Throwable) null));
            } else {
                DataServiceManager.this.loge("onDataProfileUnthrottled: dataProfile is null");
            }
        }
    }

    public DataServiceManager(Phone phone, int i, String str) {
        AnonymousClass1 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.telephony.action.CARRIER_CONFIG_CHANGED".equals(intent.getAction()) && DataServiceManager.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", 0)) {
                    DataServiceManager.this.log("Carrier config changed. Try to bind data service.");
                    DataServiceManager.this.sendEmptyMessage(1);
                }
            }
        };
        this.mBroadcastReceiver = r0;
        this.mPhone = phone;
        this.mTag = "DSM" + str;
        this.mTransportType = i;
        this.mBound = false;
        this.mCarrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService("carrier_config");
        this.mPermissionManager = (LegacyPermissionManager) phone.getContext().getSystemService("legacy_permission");
        this.mAppOps = (AppOpsManager) phone.getContext().getSystemService("appops");
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        try {
            phone.getContext().createPackageContextAsUser(phone.getContext().getPackageName(), 0, UserHandle.ALL).registerReceiver(r0, intentFilter, (String) null, (Handler) null);
        } catch (PackageManager.NameNotFoundException e) {
            loge("Package name not found: " + e.getMessage());
        }
        PhoneConfigurationManager.registerForMultiSimConfigChange(this, 1, (Object) null);
        sendEmptyMessage(1);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            rebindDataService();
        } else if (i != 2) {
            loge("Unhandled event " + message.what);
        } else {
            handleRequestUnresponded((CellularDataServiceCallback) message.obj);
        }
    }

    private void handleRequestUnresponded(CellularDataServiceCallback cellularDataServiceCallback) {
        String str = "Request " + cellularDataServiceCallback.getTag() + " unresponded on transport " + AccessNetworkConstants.transportTypeToString(this.mTransportType) + " in " + 600 + " seconds.";
        log(str);
        AnomalyReporter.reportAnomaly(UUID.fromString("f5d5cbe6-9bd6-4009-b764-42b1b649b1de"), str, this.mPhone.getCarrierId());
    }

    private void unbindDataService() {
        revokePermissionsFromUnusedDataServices();
        IDataService iDataService = this.mIDataService;
        if (iDataService != null && iDataService.asBinder().isBinderAlive()) {
            log("unbinding service");
            try {
                this.mIDataService.removeDataServiceProvider(this.mPhone.getPhoneId());
            } catch (RemoteException e) {
                loge("Cannot remove data service provider. " + e);
            }
        }
        if (this.mServiceConnection != null) {
            this.mPhone.getContext().unbindService(this.mServiceConnection);
        }
        this.mIDataService = null;
        this.mServiceConnection = null;
        this.mTargetBindingPackageName = null;
        this.mBound = false;
    }

    private void bindDataService(String str) {
        Intent intent;
        Phone phone = this.mPhone;
        if (phone == null || !SubscriptionManager.isValidPhoneId(phone.getPhoneId())) {
            loge("can't bindDataService with invalid phone or phoneId.");
        } else if (TextUtils.isEmpty(str)) {
            loge("Can't find the binding package");
        } else {
            String dataServiceClassName = getDataServiceClassName();
            if (TextUtils.isEmpty(dataServiceClassName)) {
                intent = new Intent("android.telephony.data.DataService");
                intent.setPackage(str);
            } else {
                intent = new Intent("android.telephony.data.DataService").setComponent(new ComponentName(str, dataServiceClassName));
            }
            grantPermissionsToService(str);
            try {
                this.mServiceConnection = new CellularDataServiceConnection();
                if (!this.mPhone.getContext().bindService(intent, this.mServiceConnection, 1)) {
                    loge("Cannot bind to the data service.");
                } else {
                    this.mTargetBindingPackageName = str;
                }
            } catch (Exception e) {
                loge("Cannot bind to the data service. Exception: " + e);
            }
        }
    }

    private void rebindDataService() {
        String dataServicePackageName = getDataServicePackageName();
        if (!SubscriptionManager.isValidPhoneId(this.mPhone.getPhoneId()) || !TextUtils.equals(dataServicePackageName, this.mTargetBindingPackageName)) {
            unbindDataService();
            bindDataService(dataServicePackageName);
            return;
        }
        log("Service " + dataServicePackageName + " already bound or being bound.");
    }

    private Set<String> getAllDataServicePackageNames() {
        List<ResolveInfo> queryIntentServices = this.mPhone.getContext().getPackageManager().queryIntentServices(new Intent("android.telephony.data.DataService"), 1048576);
        HashSet hashSet = new HashSet();
        for (ResolveInfo resolveInfo : queryIntentServices) {
            ServiceInfo serviceInfo = resolveInfo.serviceInfo;
            if (serviceInfo != null) {
                hashSet.add(serviceInfo.packageName);
            }
        }
        return hashSet;
    }

    public String getDataServicePackageName() {
        return getDataServicePackageName(this.mTransportType);
    }

    private String getDataServicePackageName(int i) {
        int i2;
        String str;
        if (i == 1) {
            i2 = 17040078;
            str = "carrier_data_service_wwan_package_override_string";
        } else if (i == 2) {
            i2 = 17040073;
            str = "carrier_data_service_wlan_package_override_string";
        } else {
            throw new IllegalStateException("Transport type not WWAN or WLAN. type=" + AccessNetworkConstants.transportTypeToString(this.mTransportType));
        }
        String string = this.mPhone.getContext().getResources().getString(i2);
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        return (configForSubId == null || TextUtils.isEmpty(configForSubId.getString(str))) ? string : configForSubId.getString(str, string);
    }

    private String getDataServiceClassName() {
        return getDataServiceClassName(this.mTransportType);
    }

    private String getDataServiceClassName(int i) {
        int i2;
        String str;
        if (i == 1) {
            i2 = 17040077;
            str = "carrier_data_service_wwan_class_override_string";
        } else if (i == 2) {
            i2 = 17040072;
            str = "carrier_data_service_wlan_class_override_string";
        } else {
            throw new IllegalStateException("Transport type not WWAN or WLAN. type=" + i);
        }
        String string = this.mPhone.getContext().getResources().getString(i2);
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        return (configForSubId == null || TextUtils.isEmpty(configForSubId.getString(str))) ? string : configForSubId.getString(str, string);
    }

    /* access modifiers changed from: private */
    public void sendCompleteMessage(Message message, int i) {
        if (message != null) {
            message.arg1 = i;
            message.sendToTarget();
        }
    }

    public void setupDataCall(int i, DataProfile dataProfile, boolean z, boolean z2, int i2, LinkProperties linkProperties, int i3, NetworkSliceInfo networkSliceInfo, TrafficDescriptor trafficDescriptor, boolean z3, Message message) {
        Message message2 = message;
        log("setupDataCall");
        if (!this.mBound) {
            loge("setupDataCall: Data service not bound.");
            sendCompleteMessage(message2, 4);
            return;
        }
        CellularDataServiceCallback cellularDataServiceCallback = new CellularDataServiceCallback("setupDataCall");
        if (message2 != null) {
            this.mMessageMap.put(cellularDataServiceCallback.asBinder(), message2);
        }
        try {
            sendMessageDelayed(obtainMessage(2, cellularDataServiceCallback), REQUEST_UNRESPONDED_TIMEOUT);
            this.mIDataService.setupDataCall(this.mPhone.getPhoneId(), i, dataProfile, z, z2, i2, linkProperties, i3, networkSliceInfo, trafficDescriptor, z3, cellularDataServiceCallback);
        } catch (RemoteException unused) {
            loge("setupDataCall: Cannot invoke setupDataCall on data service.");
            this.mMessageMap.remove(cellularDataServiceCallback.asBinder());
            sendCompleteMessage(message2, 4);
        }
    }

    public void deactivateDataCall(int i, int i2, Message message) {
        log("deactivateDataCall");
        if (!this.mBound) {
            loge("Data service not bound.");
            sendCompleteMessage(message, 4);
            return;
        }
        CellularDataServiceCallback cellularDataServiceCallback = new CellularDataServiceCallback("deactivateDataCall");
        if (message != null) {
            this.mMessageMap.put(cellularDataServiceCallback.asBinder(), message);
        }
        try {
            sendMessageDelayed(obtainMessage(2, cellularDataServiceCallback), REQUEST_UNRESPONDED_TIMEOUT);
            this.mIDataService.deactivateDataCall(this.mPhone.getPhoneId(), i, i2, cellularDataServiceCallback);
        } catch (RemoteException unused) {
            loge("Cannot invoke deactivateDataCall on data service.");
            this.mMessageMap.remove(cellularDataServiceCallback.asBinder());
            sendCompleteMessage(message, 4);
        }
    }

    public void startHandover(int i, Message message) {
        CellularDataServiceCallback cellularDataServiceCallback = setupCallbackHelper("startHandover", message);
        if (cellularDataServiceCallback == null) {
            loge("startHandover: callback == null");
            sendCompleteMessage(message, 4);
            return;
        }
        try {
            sendMessageDelayed(obtainMessage(2, cellularDataServiceCallback), REQUEST_UNRESPONDED_TIMEOUT);
            this.mIDataService.startHandover(this.mPhone.getPhoneId(), i, cellularDataServiceCallback);
        } catch (RemoteException unused) {
            loge("Cannot invoke startHandover on data service.");
            this.mMessageMap.remove(cellularDataServiceCallback.asBinder());
            sendCompleteMessage(message, 4);
        }
    }

    public void cancelHandover(int i, Message message) {
        CellularDataServiceCallback cellularDataServiceCallback = setupCallbackHelper("cancelHandover", message);
        if (cellularDataServiceCallback == null) {
            sendCompleteMessage(message, 4);
            return;
        }
        try {
            sendMessageDelayed(obtainMessage(2, cellularDataServiceCallback), REQUEST_UNRESPONDED_TIMEOUT);
            this.mIDataService.cancelHandover(this.mPhone.getPhoneId(), i, cellularDataServiceCallback);
        } catch (RemoteException unused) {
            loge("Cannot invoke cancelHandover on data service.");
            this.mMessageMap.remove(cellularDataServiceCallback.asBinder());
            sendCompleteMessage(message, 4);
        }
    }

    private CellularDataServiceCallback setupCallbackHelper(String str, Message message) {
        log(str);
        if (!this.mBound) {
            sendCompleteMessage(message, 4);
            return null;
        }
        CellularDataServiceCallback cellularDataServiceCallback = new CellularDataServiceCallback(str);
        if (message != null) {
            log(str + ": onCompleteMessage set");
            this.mMessageMap.put(cellularDataServiceCallback.asBinder(), message);
        } else {
            log(str + ": onCompleteMessage not set");
        }
        return cellularDataServiceCallback;
    }

    public void setInitialAttachApn(DataProfile dataProfile, boolean z, Message message) {
        log("setInitialAttachApn");
        if (!this.mBound) {
            loge("Data service not bound.");
            sendCompleteMessage(message, 4);
            return;
        }
        CellularDataServiceCallback cellularDataServiceCallback = new CellularDataServiceCallback("setInitialAttachApn");
        if (message != null) {
            this.mMessageMap.put(cellularDataServiceCallback.asBinder(), message);
        }
        try {
            this.mIDataService.setInitialAttachApn(this.mPhone.getPhoneId(), dataProfile, z, cellularDataServiceCallback);
        } catch (RemoteException unused) {
            loge("Cannot invoke setInitialAttachApn on data service.");
            this.mMessageMap.remove(cellularDataServiceCallback.asBinder());
            sendCompleteMessage(message, 4);
        }
    }

    public void setDataProfile(List<DataProfile> list, boolean z, Message message) {
        log("setDataProfile");
        if (!this.mBound) {
            loge("Data service not bound.");
            sendCompleteMessage(message, 4);
            return;
        }
        CellularDataServiceCallback cellularDataServiceCallback = new CellularDataServiceCallback("setDataProfile");
        if (message != null) {
            this.mMessageMap.put(cellularDataServiceCallback.asBinder(), message);
        }
        try {
            this.mIDataService.setDataProfile(this.mPhone.getPhoneId(), list, z, cellularDataServiceCallback);
        } catch (RemoteException unused) {
            loge("Cannot invoke setDataProfile on data service.");
            this.mMessageMap.remove(cellularDataServiceCallback.asBinder());
            sendCompleteMessage(message, 4);
        }
    }

    public void requestDataCallList(Message message) {
        log("requestDataCallList");
        if (!this.mBound) {
            loge("Data service not bound.");
            sendCompleteMessage(message, 4);
            return;
        }
        CellularDataServiceCallback cellularDataServiceCallback = new CellularDataServiceCallback("requestDataCallList");
        if (message != null) {
            this.mMessageMap.put(cellularDataServiceCallback.asBinder(), message);
        }
        try {
            this.mIDataService.requestDataCallList(this.mPhone.getPhoneId(), cellularDataServiceCallback);
        } catch (RemoteException unused) {
            loge("Cannot invoke requestDataCallList on data service.");
            this.mMessageMap.remove(cellularDataServiceCallback.asBinder());
            sendCompleteMessage(message, 4);
        }
    }

    public void registerForDataCallListChanged(Handler handler, int i) {
        if (handler != null) {
            this.mDataCallListChangedRegistrants.addUnique(handler, i, (Object) null);
        }
    }

    public void unregisterForDataCallListChanged(Handler handler) {
        if (handler != null) {
            this.mDataCallListChangedRegistrants.remove(handler);
        }
    }

    public void registerForApnUnthrottled(Handler handler, int i) {
        if (handler != null) {
            this.mApnUnthrottledRegistrants.addUnique(handler, i, (Object) null);
        }
    }

    public void unregisterForApnUnthrottled(Handler handler) {
        if (handler != null) {
            this.mApnUnthrottledRegistrants.remove(handler);
        }
    }

    public void registerForServiceBindingChanged(Handler handler, int i, Object obj) {
        if (handler != null) {
            this.mServiceBindingChangedRegistrants.addUnique(handler, i, obj);
        }
    }

    public void unregisterForServiceBindingChanged(Handler handler) {
        if (handler != null) {
            this.mServiceBindingChangedRegistrants.remove(handler);
        }
    }

    public int getTransportType() {
        return this.mTransportType;
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(this.mTag, str);
    }

    /* access modifiers changed from: private */
    public void loge(String str) {
        Rlog.e(this.mTag, str);
    }
}
