package com.android.internal.telephony;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.os.UserHandle;
import android.telephony.AccessNetworkConstants;
import android.telephony.CarrierConfigManager;
import android.telephony.INetworkService;
import android.telephony.INetworkServiceCallback;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.SubscriptionManager;
import android.text.TextUtils;
import com.android.telephony.Rlog;
import java.util.Hashtable;
import java.util.Map;

public class NetworkRegistrationManager extends Handler {
    private static final int EVENT_BIND_NETWORK_SERVICE = 1;
    private final BroadcastReceiver mBroadcastReceiver;
    /* access modifiers changed from: private */
    public final Map<NetworkRegStateCallback, Message> mCallbackTable;
    private final CarrierConfigManager mCarrierConfigManager;
    /* access modifiers changed from: private */
    public RegManagerDeathRecipient mDeathRecipient;
    /* access modifiers changed from: private */
    public INetworkService mINetworkService;
    /* access modifiers changed from: private */
    public final Phone mPhone;
    /* access modifiers changed from: private */
    public final RegistrantList mRegStateChangeRegistrants = new RegistrantList();
    private NetworkServiceConnection mServiceConnection;
    private final String mTag;
    /* access modifiers changed from: private */
    public String mTargetBindingPackageName;
    /* access modifiers changed from: private */
    public final int mTransportType;

    public NetworkRegistrationManager(int i, Phone phone) {
        AnonymousClass1 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.telephony.action.CARRIER_CONFIG_CHANGED".equals(intent.getAction()) && NetworkRegistrationManager.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", 0)) {
                    NetworkRegistrationManager.this.logd("Carrier config changed. Try to bind network service.");
                    NetworkRegistrationManager.this.sendEmptyMessage(1);
                }
            }
        };
        this.mBroadcastReceiver = r0;
        this.mCallbackTable = new Hashtable();
        this.mTransportType = i;
        this.mPhone = phone;
        StringBuilder sb = new StringBuilder();
        sb.append("-");
        sb.append(i == 1 ? "C" : "I");
        sb.append("-");
        sb.append(phone.getPhoneId());
        String sb2 = sb.toString();
        this.mTag = "NRM" + sb2;
        this.mCarrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService("carrier_config");
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
        if (message.what != 1) {
            loge("Unhandled event " + message.what);
            return;
        }
        rebindService();
    }

    public boolean isServiceConnected() {
        INetworkService iNetworkService = this.mINetworkService;
        return iNetworkService != null && iNetworkService.asBinder().isBinderAlive();
    }

    public void unregisterForNetworkRegistrationInfoChanged(Handler handler) {
        this.mRegStateChangeRegistrants.remove(handler);
    }

    public void registerForNetworkRegistrationInfoChanged(Handler handler, int i, Object obj) {
        logd("registerForNetworkRegistrationInfoChanged");
        this.mRegStateChangeRegistrants.addUnique(handler, i, obj);
    }

    public void requestNetworkRegistrationInfo(int i, Message message) {
        if (message != null) {
            if (!isServiceConnected()) {
                StringBuilder sb = new StringBuilder();
                sb.append("service not connected. Domain = ");
                sb.append(i == 1 ? "CS" : "PS");
                loge(sb.toString());
                message.obj = new AsyncResult(message.obj, (Object) null, new IllegalStateException("Service not connected."));
                message.sendToTarget();
                return;
            }
            NetworkRegStateCallback networkRegStateCallback = new NetworkRegStateCallback();
            try {
                this.mCallbackTable.put(networkRegStateCallback, message);
                this.mINetworkService.requestNetworkRegistrationInfo(this.mPhone.getPhoneId(), i, networkRegStateCallback);
            } catch (RemoteException e) {
                loge("requestNetworkRegistrationInfo RemoteException " + e);
                this.mCallbackTable.remove(networkRegStateCallback);
                message.obj = new AsyncResult(message.obj, (Object) null, e);
                message.sendToTarget();
            }
        }
    }

    private class RegManagerDeathRecipient implements IBinder.DeathRecipient {
        private final ComponentName mComponentName;

        RegManagerDeathRecipient(ComponentName componentName) {
            this.mComponentName = componentName;
        }

        public void binderDied() {
            NetworkRegistrationManager networkRegistrationManager = NetworkRegistrationManager.this;
            networkRegistrationManager.logd("Network service " + this.mComponentName + " for transport type " + AccessNetworkConstants.transportTypeToString(NetworkRegistrationManager.this.mTransportType) + " died.");
        }
    }

    private class NetworkServiceConnection implements ServiceConnection {
        private NetworkServiceConnection() {
        }

        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            NetworkRegistrationManager networkRegistrationManager = NetworkRegistrationManager.this;
            networkRegistrationManager.logd("service " + componentName + " for transport " + AccessNetworkConstants.transportTypeToString(NetworkRegistrationManager.this.mTransportType) + " is now connected.");
            NetworkRegistrationManager.this.mINetworkService = INetworkService.Stub.asInterface(iBinder);
            NetworkRegistrationManager networkRegistrationManager2 = NetworkRegistrationManager.this;
            networkRegistrationManager2.mDeathRecipient = new RegManagerDeathRecipient(componentName);
            try {
                iBinder.linkToDeath(NetworkRegistrationManager.this.mDeathRecipient, 0);
                NetworkRegistrationManager.this.mINetworkService.createNetworkServiceProvider(NetworkRegistrationManager.this.mPhone.getPhoneId());
                NetworkRegistrationManager.this.mINetworkService.registerForNetworkRegistrationInfoChanged(NetworkRegistrationManager.this.mPhone.getPhoneId(), new NetworkRegStateCallback());
            } catch (RemoteException e) {
                NetworkRegistrationManager networkRegistrationManager3 = NetworkRegistrationManager.this;
                networkRegistrationManager3.logd("RemoteException " + e);
            }
        }

        public void onServiceDisconnected(ComponentName componentName) {
            NetworkRegistrationManager networkRegistrationManager = NetworkRegistrationManager.this;
            networkRegistrationManager.logd("service " + componentName + " for transport " + AccessNetworkConstants.transportTypeToString(NetworkRegistrationManager.this.mTransportType) + " is now disconnected.");
            NetworkRegistrationManager.this.mTargetBindingPackageName = null;
        }
    }

    private class NetworkRegStateCallback extends INetworkServiceCallback.Stub {
        private NetworkRegStateCallback() {
        }

        public void onRequestNetworkRegistrationInfoComplete(int i, NetworkRegistrationInfo networkRegistrationInfo) {
            NetworkRegistrationManager networkRegistrationManager = NetworkRegistrationManager.this;
            networkRegistrationManager.logd("onRequestNetworkRegistrationInfoComplete result: " + i + ", info: " + networkRegistrationInfo);
            Message message = (Message) NetworkRegistrationManager.this.mCallbackTable.remove(this);
            if (message != null) {
                message.arg1 = i;
                message.obj = new AsyncResult(message.obj, new NetworkRegistrationInfo(networkRegistrationInfo), (Throwable) null);
                message.sendToTarget();
                return;
            }
            NetworkRegistrationManager.this.loge("onCompleteMessage is null");
        }

        public void onNetworkStateChanged() {
            NetworkRegistrationManager.this.logd("onNetworkStateChanged");
            NetworkRegistrationManager.this.mRegStateChangeRegistrants.notifyRegistrants();
        }
    }

    private void unbindService() {
        INetworkService iNetworkService = this.mINetworkService;
        if (iNetworkService != null && iNetworkService.asBinder().isBinderAlive()) {
            logd("unbinding service");
            try {
                this.mINetworkService.removeNetworkServiceProvider(this.mPhone.getPhoneId());
            } catch (RemoteException e) {
                loge("Cannot remove data service provider. " + e);
            }
        }
        if (this.mServiceConnection != null) {
            this.mPhone.getContext().unbindService(this.mServiceConnection);
        }
        this.mINetworkService = null;
        this.mServiceConnection = null;
        this.mTargetBindingPackageName = null;
    }

    private void bindService(String str) {
        Intent intent;
        Phone phone = this.mPhone;
        if (phone == null || !SubscriptionManager.isValidPhoneId(phone.getPhoneId())) {
            loge("can't bindService with invalid phone or phoneId.");
        } else if (TextUtils.isEmpty(str)) {
            loge("Can't find the binding package");
        } else {
            String className = getClassName();
            if (TextUtils.isEmpty(className)) {
                intent = new Intent("android.telephony.NetworkService");
                intent.setPackage(str);
            } else {
                intent = new Intent("android.telephony.NetworkService").setComponent(new ComponentName(str, className));
            }
            try {
                logd("Trying to bind " + getPackageName() + " for transport " + AccessNetworkConstants.transportTypeToString(this.mTransportType));
                this.mServiceConnection = new NetworkServiceConnection();
                if (!this.mPhone.getContext().bindService(intent, this.mServiceConnection, 1)) {
                    loge("Cannot bind to the data service.");
                } else {
                    this.mTargetBindingPackageName = str;
                }
            } catch (SecurityException e) {
                loge("bindService failed " + e);
            }
        }
    }

    private void rebindService() {
        String packageName = getPackageName();
        if (!SubscriptionManager.isValidPhoneId(this.mPhone.getPhoneId()) || !TextUtils.equals(packageName, this.mTargetBindingPackageName)) {
            unbindService();
            bindService(packageName);
            return;
        }
        logd("Service " + packageName + " already bound or being bound.");
    }

    private String getPackageName() {
        String str;
        int i;
        int i2 = this.mTransportType;
        if (i2 == 1) {
            i = 17040080;
            str = "carrier_network_service_wwan_package_override_string";
        } else if (i2 == 2) {
            i = 17040075;
            str = "carrier_network_service_wlan_package_override_string";
        } else {
            throw new IllegalStateException("Transport type not WWAN or WLAN. type=" + this.mTransportType);
        }
        String string = this.mPhone.getContext().getResources().getString(i);
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        return (configForSubId == null || TextUtils.isEmpty(configForSubId.getString(str))) ? string : configForSubId.getString(str, string);
    }

    private String getClassName() {
        String str;
        int i;
        int i2 = this.mTransportType;
        if (i2 == 1) {
            i = 17040079;
            str = "carrier_network_service_wwan_class_override_string";
        } else if (i2 == 2) {
            i = 17040074;
            str = "carrier_network_service_wlan_class_override_string";
        } else {
            throw new IllegalStateException("Transport type not WWAN or WLAN. type=" + this.mTransportType);
        }
        String string = this.mPhone.getContext().getResources().getString(i);
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        return (configForSubId == null || TextUtils.isEmpty(configForSubId.getString(str))) ? string : configForSubId.getString(str, string);
    }

    /* access modifiers changed from: private */
    public void logd(String str) {
        Rlog.d(this.mTag, str);
    }

    /* access modifiers changed from: private */
    public void loge(String str) {
        Rlog.e(this.mTag, str);
    }
}
