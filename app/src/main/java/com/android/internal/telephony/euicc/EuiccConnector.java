package com.android.internal.telephony.euicc;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.pm.ActivityInfo;
import android.content.pm.ComponentInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.ServiceInfo;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.RemoteException;
import android.os.UserHandle;
import android.service.euicc.DownloadSubscriptionResult;
import android.service.euicc.GetDefaultDownloadableSubscriptionListResult;
import android.service.euicc.GetDownloadableSubscriptionMetadataResult;
import android.service.euicc.GetEuiccProfileInfoListResult;
import android.service.euicc.IDeleteSubscriptionCallback;
import android.service.euicc.IDownloadSubscriptionCallback;
import android.service.euicc.IEraseSubscriptionsCallback;
import android.service.euicc.IEuiccService;
import android.service.euicc.IEuiccServiceDumpResultCallback;
import android.service.euicc.IGetDefaultDownloadableSubscriptionListCallback;
import android.service.euicc.IGetDownloadableSubscriptionMetadataCallback;
import android.service.euicc.IGetEidCallback;
import android.service.euicc.IGetEuiccInfoCallback;
import android.service.euicc.IGetEuiccProfileInfoListCallback;
import android.service.euicc.IGetOtaStatusCallback;
import android.service.euicc.IOtaStatusChangedCallback;
import android.service.euicc.IRetainSubscriptionsForFactoryResetCallback;
import android.service.euicc.ISwitchToSubscriptionCallback;
import android.service.euicc.IUpdateSubscriptionNicknameCallback;
import android.telephony.AnomalyReporter;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.UiccCardInfo;
import android.telephony.UiccSlotInfo;
import android.telephony.euicc.DownloadableSubscription;
import android.telephony.euicc.EuiccInfo;
import android.text.TextUtils;
import android.util.ArraySet;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.IState;
import com.android.internal.telephony.PackageChangeReceiver;
import com.android.internal.telephony.State;
import com.android.internal.telephony.StateMachine;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.util.TelephonyUtils;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

public class EuiccConnector extends StateMachine implements ServiceConnection {
    private static final int BIND_TIMEOUT_MILLIS = 30000;
    private static final int CMD_COMMAND_COMPLETE = 6;
    private static final int CMD_CONNECT_TIMEOUT = 2;
    private static final int CMD_DELETE_SUBSCRIPTION = 106;
    private static final int CMD_DOWNLOAD_SUBSCRIPTION = 102;
    private static final int CMD_DUMP_EUICC_SERVICE = 114;
    private static final int CMD_ERASE_SUBSCRIPTIONS = 109;
    private static final int CMD_ERASE_SUBSCRIPTIONS_WITH_OPTIONS = 113;
    private static final int CMD_GET_DEFAULT_DOWNLOADABLE_SUBSCRIPTION_LIST = 104;
    private static final int CMD_GET_DOWNLOADABLE_SUBSCRIPTION_METADATA = 101;
    private static final int CMD_GET_EID = 100;
    private static final int CMD_GET_EUICC_INFO = 105;
    private static final int CMD_GET_EUICC_PROFILE_INFO_LIST = 103;
    private static final int CMD_GET_OTA_STATUS = 111;
    private static final int CMD_LINGER_TIMEOUT = 3;
    private static final int CMD_PACKAGE_CHANGE = 1;
    private static final int CMD_RETAIN_SUBSCRIPTIONS = 110;
    private static final int CMD_SERVICE_CONNECTED = 4;
    private static final int CMD_SERVICE_DISCONNECTED = 5;
    private static final int CMD_START_OTA_IF_NECESSARY = 112;
    private static final int CMD_SWITCH_TO_SUBSCRIPTION = 107;
    private static final int CMD_UPDATE_SUBSCRIPTION_NICKNAME = 108;
    private static final int EUICC_QUERY_FLAGS = 269484096;
    @VisibleForTesting
    static final int LINGER_TIMEOUT_MILLIS = 60000;
    private static final String TAG = "EuiccConnector";
    /* access modifiers changed from: private */
    public Set<BaseEuiccCommandCallback> mActiveCommandCallbacks = new ArraySet();
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public AvailableState mAvailableState;
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public BindingState mBindingState;
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public ConnectedState mConnectedState;
    private Context mContext;
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public DisconnectedState mDisconnectedState;
    /* access modifiers changed from: private */
    public IEuiccService mEuiccService;
    private final PackageChangeReceiver mPackageMonitor = new EuiccPackageMonitor();
    private PackageManager mPm;
    /* access modifiers changed from: private */
    public ServiceInfo mSelectedComponent;
    private SubscriptionManager mSm;
    private TelephonyManager mTm;
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public UnavailableState mUnavailableState;
    private final BroadcastReceiver mUserUnlockedReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if ("android.intent.action.USER_UNLOCKED".equals(intent.getAction())) {
                EuiccConnector.this.sendMessage(1);
            }
        }
    };

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface BaseEuiccCommandCallback {
        void onEuiccServiceUnavailable();
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface DeleteCommandCallback extends BaseEuiccCommandCallback {
        void onDeleteComplete(int i);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface DownloadCommandCallback extends BaseEuiccCommandCallback {
        void onDownloadComplete(DownloadSubscriptionResult downloadSubscriptionResult);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface DumpEuiccServiceCommandCallback extends BaseEuiccCommandCallback {
        void onDumpEuiccServiceComplete(String str);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface EraseCommandCallback extends BaseEuiccCommandCallback {
        void onEraseComplete(int i);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface GetDefaultListCommandCallback extends BaseEuiccCommandCallback {
        void onGetDefaultListComplete(int i, GetDefaultDownloadableSubscriptionListResult getDefaultDownloadableSubscriptionListResult);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface GetEidCommandCallback extends BaseEuiccCommandCallback {
        void onGetEidComplete(String str);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface GetEuiccInfoCommandCallback extends BaseEuiccCommandCallback {
        void onGetEuiccInfoComplete(EuiccInfo euiccInfo);
    }

    interface GetEuiccProfileInfoListCommandCallback extends BaseEuiccCommandCallback {
        void onListComplete(GetEuiccProfileInfoListResult getEuiccProfileInfoListResult);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface GetMetadataCommandCallback extends BaseEuiccCommandCallback {
        void onGetMetadataComplete(int i, GetDownloadableSubscriptionMetadataResult getDownloadableSubscriptionMetadataResult);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface GetOtaStatusCommandCallback extends BaseEuiccCommandCallback {
        void onGetOtaStatusComplete(int i);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface OtaStatusChangedCallback extends BaseEuiccCommandCallback {
        void onOtaStatusChanged(int i);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface RetainSubscriptionsCommandCallback extends BaseEuiccCommandCallback {
        void onRetainSubscriptionsComplete(int i);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface SwitchCommandCallback extends BaseEuiccCommandCallback {
        void onSwitchComplete(int i);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public interface UpdateNicknameCommandCallback extends BaseEuiccCommandCallback {
        void onUpdateNicknameComplete(int i);
    }

    /* access modifiers changed from: private */
    public static boolean isEuiccCommand(int i) {
        return i >= 100;
    }

    public static ActivityInfo findBestActivity(PackageManager packageManager, Intent intent) {
        ActivityInfo activityInfo = (ActivityInfo) findBestComponent(packageManager, packageManager.queryIntentActivities(intent, EUICC_QUERY_FLAGS));
        if (activityInfo == null) {
            Log.w(TAG, "No valid component found for intent: " + intent);
        }
        return activityInfo;
    }

    public static ComponentInfo findBestComponent(PackageManager packageManager) {
        ComponentInfo findBestComponent = findBestComponent(packageManager, packageManager.queryIntentServices(new Intent("android.service.euicc.EuiccService"), EUICC_QUERY_FLAGS));
        if (findBestComponent == null) {
            Log.w(TAG, "No valid EuiccService implementation found");
        }
        return findBestComponent;
    }

    static class GetMetadataRequest {
        GetMetadataCommandCallback mCallback;
        boolean mForceDeactivateSim;
        DownloadableSubscription mSubscription;

        GetMetadataRequest() {
        }
    }

    static class DownloadRequest {
        DownloadCommandCallback mCallback;
        boolean mForceDeactivateSim;
        int mPortIndex;
        Bundle mResolvedBundle;
        DownloadableSubscription mSubscription;
        boolean mSwitchAfterDownload;

        DownloadRequest() {
        }
    }

    static class GetDefaultListRequest {
        GetDefaultListCommandCallback mCallback;
        boolean mForceDeactivateSim;

        GetDefaultListRequest() {
        }
    }

    static class DeleteRequest {
        DeleteCommandCallback mCallback;
        String mIccid;

        DeleteRequest() {
        }
    }

    static class SwitchRequest {
        SwitchCommandCallback mCallback;
        boolean mForceDeactivateSim;
        String mIccid;
        boolean mUsePortIndex;

        SwitchRequest() {
        }
    }

    static class UpdateNicknameRequest {
        UpdateNicknameCommandCallback mCallback;
        String mIccid;
        String mNickname;

        UpdateNicknameRequest() {
        }
    }

    EuiccConnector(Context context) {
        super(TAG);
        init(context);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public EuiccConnector(Context context, Looper looper) {
        super(TAG, looper);
        init(context);
    }

    private void init(Context context) {
        this.mContext = context;
        this.mPm = context.getPackageManager();
        this.mTm = (TelephonyManager) context.getSystemService("phone");
        this.mSm = (SubscriptionManager) context.getSystemService("telephony_subscription_service");
        UnavailableState unavailableState = new UnavailableState();
        this.mUnavailableState = unavailableState;
        addState(unavailableState);
        AvailableState availableState = new AvailableState();
        this.mAvailableState = availableState;
        addState(availableState, this.mUnavailableState);
        BindingState bindingState = new BindingState();
        this.mBindingState = bindingState;
        addState(bindingState);
        DisconnectedState disconnectedState = new DisconnectedState();
        this.mDisconnectedState = disconnectedState;
        addState(disconnectedState);
        ConnectedState connectedState = new ConnectedState();
        this.mConnectedState = connectedState;
        addState(connectedState, this.mDisconnectedState);
        ServiceInfo findBestComponent = findBestComponent();
        this.mSelectedComponent = findBestComponent;
        setInitialState(findBestComponent != null ? this.mAvailableState : this.mUnavailableState);
        start();
        this.mPackageMonitor.register(this.mContext, (Looper) null, (UserHandle) null);
        this.mContext.registerReceiver(this.mUserUnlockedReceiver, new IntentFilter("android.intent.action.USER_UNLOCKED"));
    }

    public void onHalting() {
        this.mPackageMonitor.unregister();
        this.mContext.unregisterReceiver(this.mUserUnlockedReceiver);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void getEid(int i, GetEidCommandCallback getEidCommandCallback) {
        sendMessage(100, i, 0, getEidCommandCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void getOtaStatus(int i, GetOtaStatusCommandCallback getOtaStatusCommandCallback) {
        sendMessage(111, i, 0, getOtaStatusCommandCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void startOtaIfNecessary(int i, OtaStatusChangedCallback otaStatusChangedCallback) {
        sendMessage(112, i, 0, otaStatusChangedCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void getDownloadableSubscriptionMetadata(int i, DownloadableSubscription downloadableSubscription, boolean z, GetMetadataCommandCallback getMetadataCommandCallback) {
        GetMetadataRequest getMetadataRequest = new GetMetadataRequest();
        getMetadataRequest.mSubscription = downloadableSubscription;
        getMetadataRequest.mForceDeactivateSim = z;
        getMetadataRequest.mCallback = getMetadataCommandCallback;
        sendMessage(101, i, 0, getMetadataRequest);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void downloadSubscription(int i, int i2, DownloadableSubscription downloadableSubscription, boolean z, boolean z2, Bundle bundle, DownloadCommandCallback downloadCommandCallback) {
        DownloadRequest downloadRequest = new DownloadRequest();
        downloadRequest.mSubscription = downloadableSubscription;
        downloadRequest.mSwitchAfterDownload = z;
        downloadRequest.mForceDeactivateSim = z2;
        downloadRequest.mResolvedBundle = bundle;
        downloadRequest.mCallback = downloadCommandCallback;
        downloadRequest.mPortIndex = i2;
        sendMessage(102, i, 0, downloadRequest);
    }

    /* access modifiers changed from: package-private */
    public void getEuiccProfileInfoList(int i, GetEuiccProfileInfoListCommandCallback getEuiccProfileInfoListCommandCallback) {
        sendMessage(103, i, 0, getEuiccProfileInfoListCommandCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void getDefaultDownloadableSubscriptionList(int i, boolean z, GetDefaultListCommandCallback getDefaultListCommandCallback) {
        GetDefaultListRequest getDefaultListRequest = new GetDefaultListRequest();
        getDefaultListRequest.mForceDeactivateSim = z;
        getDefaultListRequest.mCallback = getDefaultListCommandCallback;
        sendMessage(104, i, 0, getDefaultListRequest);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void getEuiccInfo(int i, GetEuiccInfoCommandCallback getEuiccInfoCommandCallback) {
        sendMessage(105, i, 0, getEuiccInfoCommandCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void deleteSubscription(int i, String str, DeleteCommandCallback deleteCommandCallback) {
        DeleteRequest deleteRequest = new DeleteRequest();
        deleteRequest.mIccid = str;
        deleteRequest.mCallback = deleteCommandCallback;
        sendMessage(106, i, 0, deleteRequest);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void switchToSubscription(int i, int i2, String str, boolean z, SwitchCommandCallback switchCommandCallback, boolean z2) {
        SwitchRequest switchRequest = new SwitchRequest();
        switchRequest.mIccid = str;
        switchRequest.mForceDeactivateSim = z;
        switchRequest.mCallback = switchCommandCallback;
        switchRequest.mUsePortIndex = z2;
        sendMessage(107, i, i2, switchRequest);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void updateSubscriptionNickname(int i, String str, String str2, UpdateNicknameCommandCallback updateNicknameCommandCallback) {
        UpdateNicknameRequest updateNicknameRequest = new UpdateNicknameRequest();
        updateNicknameRequest.mIccid = str;
        updateNicknameRequest.mNickname = str2;
        updateNicknameRequest.mCallback = updateNicknameCommandCallback;
        sendMessage(108, i, 0, updateNicknameRequest);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void eraseSubscriptions(int i, EraseCommandCallback eraseCommandCallback) {
        sendMessage(109, i, 0, eraseCommandCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void eraseSubscriptionsWithOptions(int i, int i2, EraseCommandCallback eraseCommandCallback) {
        sendMessage(113, i, i2, eraseCommandCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void retainSubscriptions(int i, RetainSubscriptionsCommandCallback retainSubscriptionsCommandCallback) {
        sendMessage(110, i, 0, retainSubscriptionsCommandCallback);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public void dumpEuiccService(DumpEuiccServiceCommandCallback dumpEuiccServiceCommandCallback) {
        sendMessage(114, -1, 0, dumpEuiccServiceCommandCallback);
    }

    private class UnavailableState extends State {
        private UnavailableState() {
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            if (i == 1) {
                EuiccConnector euiccConnector = EuiccConnector.this;
                euiccConnector.mSelectedComponent = euiccConnector.findBestComponent();
                if (EuiccConnector.this.mSelectedComponent != null) {
                    EuiccConnector euiccConnector2 = EuiccConnector.this;
                    euiccConnector2.transitionTo(euiccConnector2.mAvailableState);
                    EuiccConnector.this.updateSubscriptionInfoListForAllAccessibleEuiccs();
                } else {
                    IState currentState = EuiccConnector.this.getCurrentState();
                    EuiccConnector euiccConnector3 = EuiccConnector.this;
                    UnavailableState unavailableState = euiccConnector3.mUnavailableState;
                    if (currentState != unavailableState) {
                        euiccConnector3.transitionTo(unavailableState);
                    }
                }
                return true;
            } else if (!EuiccConnector.isEuiccCommand(i)) {
                return false;
            } else {
                EuiccConnector.getCallback(message).onEuiccServiceUnavailable();
                return true;
            }
        }
    }

    private class AvailableState extends State {
        private AvailableState() {
        }

        public boolean processMessage(Message message) {
            if (!EuiccConnector.isEuiccCommand(message.what)) {
                return false;
            }
            EuiccConnector.this.deferMessage(message);
            EuiccConnector euiccConnector = EuiccConnector.this;
            euiccConnector.transitionTo(euiccConnector.mBindingState);
            return true;
        }
    }

    private class BindingState extends State {
        private BindingState() {
        }

        public void enter() {
            if (EuiccConnector.this.createBinding()) {
                EuiccConnector euiccConnector = EuiccConnector.this;
                euiccConnector.transitionTo(euiccConnector.mDisconnectedState);
                return;
            }
            EuiccConnector euiccConnector2 = EuiccConnector.this;
            euiccConnector2.transitionTo(euiccConnector2.mAvailableState);
        }

        public boolean processMessage(Message message) {
            EuiccConnector.this.deferMessage(message);
            return true;
        }
    }

    private class DisconnectedState extends State {
        private DisconnectedState() {
        }

        public void enter() {
            EuiccConnector.this.sendMessageDelayed(2, 30000);
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            if (i == 4) {
                EuiccConnector.this.mEuiccService = (IEuiccService) message.obj;
                EuiccConnector euiccConnector = EuiccConnector.this;
                euiccConnector.transitionTo(euiccConnector.mConnectedState);
                return true;
            }
            boolean z = false;
            if (i == 1) {
                ServiceInfo r0 = EuiccConnector.this.findBestComponent();
                String str = (String) message.obj;
                boolean z2 = r0 != null ? EuiccConnector.this.mSelectedComponent == null || new ComponentName(r0.packageName, r0.name).equals(new ComponentName(EuiccConnector.this.mSelectedComponent.packageName, EuiccConnector.this.mSelectedComponent.name)) : EuiccConnector.this.mSelectedComponent != null;
                if (r0 != null && Objects.equals(r0.packageName, str)) {
                    z = true;
                }
                if (!z2 || z) {
                    EuiccConnector.this.unbind();
                    EuiccConnector.this.mSelectedComponent = r0;
                    if (EuiccConnector.this.mSelectedComponent == null) {
                        EuiccConnector euiccConnector2 = EuiccConnector.this;
                        euiccConnector2.transitionTo(euiccConnector2.mUnavailableState);
                    } else {
                        EuiccConnector euiccConnector3 = EuiccConnector.this;
                        euiccConnector3.transitionTo(euiccConnector3.mBindingState);
                    }
                    EuiccConnector.this.updateSubscriptionInfoListForAllAccessibleEuiccs();
                }
                return true;
            } else if (i == 2) {
                EuiccConnector euiccConnector4 = EuiccConnector.this;
                euiccConnector4.transitionTo(euiccConnector4.mAvailableState);
                return true;
            } else if (!EuiccConnector.isEuiccCommand(i)) {
                return false;
            } else {
                EuiccConnector.this.deferMessage(message);
                return true;
            }
        }
    }

    private class ConnectedState extends State {
        private ConnectedState() {
        }

        public void enter() {
            EuiccConnector.this.removeMessages(2);
            EuiccConnector.this.sendMessageDelayed(3, 60000);
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            if (i == 5) {
                EuiccConnector.this.mEuiccService = null;
                EuiccConnector euiccConnector = EuiccConnector.this;
                euiccConnector.transitionTo(euiccConnector.mDisconnectedState);
                return true;
            } else if (i == 3) {
                EuiccConnector.this.unbind();
                EuiccConnector euiccConnector2 = EuiccConnector.this;
                euiccConnector2.transitionTo(euiccConnector2.mAvailableState);
                return true;
            } else if (i == 6) {
                ((Runnable) message.obj).run();
                return true;
            } else if (!EuiccConnector.isEuiccCommand(i)) {
                return false;
            } else {
                final BaseEuiccCommandCallback r1 = EuiccConnector.getCallback(message);
                EuiccConnector.this.onCommandStart(r1);
                final int i2 = message.arg1;
                int r6 = EuiccConnector.this.getSlotIdFromCardId(i2);
                try {
                    switch (message.what) {
                        case 100:
                            EuiccConnector.this.mEuiccService.getEid(r6, new IGetEidCallback.Stub() {
                                public void onSuccess(String str) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$1$$ExternalSyntheticLambda0(this, r1, str));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onSuccess$0(BaseEuiccCommandCallback baseEuiccCommandCallback, String str) {
                                    ((GetEidCommandCallback) baseEuiccCommandCallback).onGetEidComplete(str);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 101:
                            GetMetadataRequest getMetadataRequest = (GetMetadataRequest) message.obj;
                            EuiccConnector.this.mEuiccService.getDownloadableSubscriptionMetadata(r6, getMetadataRequest.mSubscription, getMetadataRequest.mForceDeactivateSim, new IGetDownloadableSubscriptionMetadataCallback.Stub() {
                                public void onComplete(GetDownloadableSubscriptionMetadataResult getDownloadableSubscriptionMetadataResult) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$2$$ExternalSyntheticLambda0(this, r1, i2, getDownloadableSubscriptionMetadataResult));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i, GetDownloadableSubscriptionMetadataResult getDownloadableSubscriptionMetadataResult) {
                                    ((GetMetadataCommandCallback) baseEuiccCommandCallback).onGetMetadataComplete(i, getDownloadableSubscriptionMetadataResult);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 102:
                            DownloadRequest downloadRequest = (DownloadRequest) message.obj;
                            EuiccConnector.this.mEuiccService.downloadSubscription(r6, downloadRequest.mPortIndex, downloadRequest.mSubscription, downloadRequest.mSwitchAfterDownload, downloadRequest.mForceDeactivateSim, downloadRequest.mResolvedBundle, new IDownloadSubscriptionCallback.Stub() {
                                public void onComplete(DownloadSubscriptionResult downloadSubscriptionResult) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$3$$ExternalSyntheticLambda0(this, r1, downloadSubscriptionResult));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, DownloadSubscriptionResult downloadSubscriptionResult) {
                                    ((DownloadCommandCallback) baseEuiccCommandCallback).onDownloadComplete(downloadSubscriptionResult);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 103:
                            EuiccConnector.this.mEuiccService.getEuiccProfileInfoList(r6, new IGetEuiccProfileInfoListCallback.Stub() {
                                public void onComplete(GetEuiccProfileInfoListResult getEuiccProfileInfoListResult) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$4$$ExternalSyntheticLambda0(this, r1, getEuiccProfileInfoListResult));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, GetEuiccProfileInfoListResult getEuiccProfileInfoListResult) {
                                    ((GetEuiccProfileInfoListCommandCallback) baseEuiccCommandCallback).onListComplete(getEuiccProfileInfoListResult);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 104:
                            EuiccConnector.this.mEuiccService.getDefaultDownloadableSubscriptionList(r6, ((GetDefaultListRequest) message.obj).mForceDeactivateSim, new IGetDefaultDownloadableSubscriptionListCallback.Stub() {
                                public void onComplete(GetDefaultDownloadableSubscriptionListResult getDefaultDownloadableSubscriptionListResult) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$5$$ExternalSyntheticLambda0(this, r1, i2, getDefaultDownloadableSubscriptionListResult));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i, GetDefaultDownloadableSubscriptionListResult getDefaultDownloadableSubscriptionListResult) {
                                    ((GetDefaultListCommandCallback) baseEuiccCommandCallback).onGetDefaultListComplete(i, getDefaultDownloadableSubscriptionListResult);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 105:
                            EuiccConnector.this.mEuiccService.getEuiccInfo(r6, new IGetEuiccInfoCallback.Stub() {
                                public void onSuccess(EuiccInfo euiccInfo) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$6$$ExternalSyntheticLambda0(this, r1, euiccInfo));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onSuccess$0(BaseEuiccCommandCallback baseEuiccCommandCallback, EuiccInfo euiccInfo) {
                                    ((GetEuiccInfoCommandCallback) baseEuiccCommandCallback).onGetEuiccInfoComplete(euiccInfo);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 106:
                            EuiccConnector.this.mEuiccService.deleteSubscription(r6, ((DeleteRequest) message.obj).mIccid, new IDeleteSubscriptionCallback.Stub() {
                                public void onComplete(int i) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$7$$ExternalSyntheticLambda0(this, r1, i));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((DeleteCommandCallback) baseEuiccCommandCallback).onDeleteComplete(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 107:
                            SwitchRequest switchRequest = (SwitchRequest) message.obj;
                            EuiccConnector.this.mEuiccService.switchToSubscription(r6, message.arg2, switchRequest.mIccid, switchRequest.mForceDeactivateSim, new ISwitchToSubscriptionCallback.Stub() {
                                public void onComplete(int i) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$8$$ExternalSyntheticLambda0(this, r1, i));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((SwitchCommandCallback) baseEuiccCommandCallback).onSwitchComplete(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            }, switchRequest.mUsePortIndex);
                            break;
                        case 108:
                            UpdateNicknameRequest updateNicknameRequest = (UpdateNicknameRequest) message.obj;
                            EuiccConnector.this.mEuiccService.updateSubscriptionNickname(r6, updateNicknameRequest.mIccid, updateNicknameRequest.mNickname, new IUpdateSubscriptionNicknameCallback.Stub() {
                                public void onComplete(int i) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$9$$ExternalSyntheticLambda0(this, r1, i));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((UpdateNicknameCommandCallback) baseEuiccCommandCallback).onUpdateNicknameComplete(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 109:
                            EuiccConnector.this.mEuiccService.eraseSubscriptions(r6, new IEraseSubscriptionsCallback.Stub() {
                                public void onComplete(int i) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$10$$ExternalSyntheticLambda0(this, r1, i));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((EraseCommandCallback) baseEuiccCommandCallback).onEraseComplete(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 110:
                            EuiccConnector.this.mEuiccService.retainSubscriptionsForFactoryReset(r6, new IRetainSubscriptionsForFactoryResetCallback.Stub() {
                                public void onComplete(int i) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$12$$ExternalSyntheticLambda0(this, r1, i));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((RetainSubscriptionsCommandCallback) baseEuiccCommandCallback).onRetainSubscriptionsComplete(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 111:
                            EuiccConnector.this.mEuiccService.getOtaStatus(r6, new IGetOtaStatusCallback.Stub() {
                                public void onSuccess(int i) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$13$$ExternalSyntheticLambda0(this, r1, i));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onSuccess$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((GetOtaStatusCommandCallback) baseEuiccCommandCallback).onGetOtaStatusComplete(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 112:
                            EuiccConnector.this.mEuiccService.startOtaIfNecessary(r6, new IOtaStatusChangedCallback.Stub() {
                                public void onOtaStatusChanged(int i) throws RemoteException {
                                    if (i == 1) {
                                        EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda0(r1, i));
                                    } else {
                                        EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1(this, r1, i));
                                    }
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onOtaStatusChanged$1(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((OtaStatusChangedCallback) baseEuiccCommandCallback).onOtaStatusChanged(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 113:
                            EuiccConnector.this.mEuiccService.eraseSubscriptionsWithOptions(r6, message.arg2, new IEraseSubscriptionsCallback.Stub() {
                                public void onComplete(int i) {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$11$$ExternalSyntheticLambda0(this, r1, i));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, int i) {
                                    ((EraseCommandCallback) baseEuiccCommandCallback).onEraseComplete(i);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        case 114:
                            EuiccConnector.this.mEuiccService.dump(new IEuiccServiceDumpResultCallback.Stub() {
                                public void onComplete(String str) throws RemoteException {
                                    EuiccConnector.this.sendMessage(6, (Object) new EuiccConnector$ConnectedState$15$$ExternalSyntheticLambda0(this, r1, str));
                                }

                                /* access modifiers changed from: private */
                                public /* synthetic */ void lambda$onComplete$0(BaseEuiccCommandCallback baseEuiccCommandCallback, String str) {
                                    ((DumpEuiccServiceCommandCallback) baseEuiccCommandCallback).onDumpEuiccServiceComplete(str);
                                    EuiccConnector.this.onCommandEnd(baseEuiccCommandCallback);
                                }
                            });
                            break;
                        default:
                            Log.wtf(EuiccConnector.TAG, "Unimplemented eUICC command: " + message.what);
                            r1.onEuiccServiceUnavailable();
                            EuiccConnector.this.onCommandEnd(r1);
                            return true;
                    }
                } catch (Exception e) {
                    Log.w(EuiccConnector.TAG, "Exception making binder call to EuiccService", e);
                    r1.onEuiccServiceUnavailable();
                    EuiccConnector.this.onCommandEnd(r1);
                }
                return true;
            }
        }

        public void exit() {
            EuiccConnector.this.removeMessages(3);
            for (BaseEuiccCommandCallback onEuiccServiceUnavailable : EuiccConnector.this.mActiveCommandCallbacks) {
                onEuiccServiceUnavailable.onEuiccServiceUnavailable();
            }
            EuiccConnector.this.mActiveCommandCallbacks.clear();
        }
    }

    /* access modifiers changed from: private */
    public static BaseEuiccCommandCallback getCallback(Message message) {
        switch (message.what) {
            case 100:
            case 103:
            case 105:
            case 109:
            case 110:
            case 111:
            case 112:
            case 113:
            case 114:
                return (BaseEuiccCommandCallback) message.obj;
            case 101:
                return ((GetMetadataRequest) message.obj).mCallback;
            case 102:
                return ((DownloadRequest) message.obj).mCallback;
            case 104:
                return ((GetDefaultListRequest) message.obj).mCallback;
            case 106:
                return ((DeleteRequest) message.obj).mCallback;
            case 107:
                return ((SwitchRequest) message.obj).mCallback;
            case 108:
                return ((UpdateNicknameRequest) message.obj).mCallback;
            default:
                throw new IllegalArgumentException("Unsupported message: " + message.what);
        }
    }

    /* access modifiers changed from: private */
    public int getSlotIdFromCardId(int i) {
        if (!(i == -1 || i == -2)) {
            UiccSlotInfo[] uiccSlotsInfo = ((TelephonyManager) this.mContext.getSystemService("phone")).getUiccSlotsInfo();
            if (uiccSlotsInfo == null || uiccSlotsInfo.length == 0) {
                Log.e(TAG, "UiccSlotInfo is null or empty");
            } else {
                String convertToCardString = UiccController.getInstance().convertToCardString(i);
                for (int i2 = 0; i2 < uiccSlotsInfo.length; i2++) {
                    if (uiccSlotsInfo[i2] == null) {
                        AnomalyReporter.reportAnomaly(UUID.fromString("4195b83d-6cee-4999-a02f-d0b9f7079b9d"), "EuiccConnector: Found UiccSlotInfo Null object.");
                    }
                    UiccSlotInfo uiccSlotInfo = uiccSlotsInfo[i2];
                    if (IccUtils.compareIgnoreTrailingFs(convertToCardString, uiccSlotInfo != null ? uiccSlotInfo.getCardId() : null)) {
                        return i2;
                    }
                }
                Log.i(TAG, "No UiccSlotInfo found for cardId: " + i);
                return -1;
            }
        }
        return -1;
    }

    /* access modifiers changed from: private */
    public void onCommandStart(BaseEuiccCommandCallback baseEuiccCommandCallback) {
        this.mActiveCommandCallbacks.add(baseEuiccCommandCallback);
        removeMessages(3);
    }

    /* access modifiers changed from: private */
    public void onCommandEnd(BaseEuiccCommandCallback baseEuiccCommandCallback) {
        if (!this.mActiveCommandCallbacks.remove(baseEuiccCommandCallback)) {
            Log.wtf(TAG, "Callback already removed from mActiveCommandCallbacks");
        }
        if (this.mActiveCommandCallbacks.isEmpty()) {
            sendMessageDelayed(3, 60000);
        }
    }

    /* access modifiers changed from: private */
    public ServiceInfo findBestComponent() {
        return (ServiceInfo) findBestComponent(this.mPm);
    }

    /* access modifiers changed from: private */
    public boolean createBinding() {
        if (this.mSelectedComponent == null) {
            Log.wtf(TAG, "Attempting to create binding but no component is selected");
            return false;
        }
        Intent intent = new Intent("android.service.euicc.EuiccService");
        ServiceInfo serviceInfo = this.mSelectedComponent;
        intent.setComponent(new ComponentName(serviceInfo.packageName, serviceInfo.name));
        return this.mContext.bindService(intent, this, 67108865);
    }

    /* access modifiers changed from: private */
    public void unbind() {
        this.mEuiccService = null;
        this.mContext.unbindService(this);
    }

    private static ComponentInfo findBestComponent(PackageManager packageManager, List<ResolveInfo> list) {
        ComponentInfo componentInfo = null;
        if (list != null) {
            int i = Integer.MIN_VALUE;
            for (ResolveInfo next : list) {
                if (isValidEuiccComponent(packageManager, next) && next.filter.getPriority() > i) {
                    int priority = next.filter.getPriority();
                    i = priority;
                    componentInfo = TelephonyUtils.getComponentInfo(next);
                }
            }
        }
        return componentInfo;
    }

    private static boolean isValidEuiccComponent(PackageManager packageManager, ResolveInfo resolveInfo) {
        String str;
        ComponentInfo componentInfo = TelephonyUtils.getComponentInfo(resolveInfo);
        String packageName = new ComponentName(componentInfo.packageName, componentInfo.name).getPackageName();
        if (packageManager.checkPermission("android.permission.WRITE_EMBEDDED_SUBSCRIPTIONS", packageName) != 0) {
            Log.wtf(TAG, "Package " + packageName + " does not declare WRITE_EMBEDDED_SUBSCRIPTIONS");
            return false;
        }
        if (componentInfo instanceof ServiceInfo) {
            str = ((ServiceInfo) componentInfo).permission;
        } else if (componentInfo instanceof ActivityInfo) {
            str = ((ActivityInfo) componentInfo).permission;
        } else {
            throw new IllegalArgumentException("Can only verify services/activities");
        }
        if (!TextUtils.equals(str, "android.permission.BIND_EUICC_SERVICE")) {
            Log.wtf(TAG, "Package " + packageName + " does not require the BIND_EUICC_SERVICE permission");
            return false;
        }
        IntentFilter intentFilter = resolveInfo.filter;
        if (intentFilter != null && intentFilter.getPriority() != 0) {
            return true;
        }
        Log.wtf(TAG, "Package " + packageName + " does not specify a priority");
        return false;
    }

    public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
        sendMessage(4, (Object) IEuiccService.Stub.asInterface(iBinder));
    }

    public void onServiceDisconnected(ComponentName componentName) {
        sendMessage(5);
    }

    private class EuiccPackageMonitor extends PackageChangeReceiver {
        private EuiccPackageMonitor() {
        }

        public void onPackageAdded(String str) {
            sendPackageChange(str, true);
        }

        public void onPackageRemoved(String str) {
            sendPackageChange(str, true);
        }

        public void onPackageUpdateFinished(String str) {
            sendPackageChange(str, true);
        }

        public void onPackageModified(String str) {
            sendPackageChange(str, false);
        }

        public void onHandleForceStop(String[] strArr, boolean z) {
            if (z) {
                for (String sendPackageChange : strArr) {
                    sendPackageChange(sendPackageChange, true);
                }
            }
        }

        private void sendPackageChange(String str, boolean z) {
            EuiccConnector euiccConnector = EuiccConnector.this;
            if (!z) {
                str = null;
            }
            euiccConnector.sendMessage(1, (Object) str);
        }
    }

    /* access modifiers changed from: protected */
    public void unhandledMessage(Message message) {
        String str;
        IState currentState = getCurrentState();
        StringBuilder sb = new StringBuilder();
        sb.append("Unhandled message ");
        sb.append(message.what);
        sb.append(" in state ");
        if (currentState == null) {
            str = "null";
        } else {
            str = currentState.getName();
        }
        sb.append(str);
        Log.wtf(TAG, sb.toString());
        UUID fromString = UUID.fromString("0db20514-5fa1-4e62-a7b7-2acf5f92c957");
        AnomalyReporter.reportAnomaly(fromString, "EuiccConnector: Found unhandledMessage " + String.valueOf(message.what));
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.println("mSelectedComponent=" + this.mSelectedComponent);
        printWriter.println("mEuiccService=" + this.mEuiccService);
        printWriter.println("mActiveCommandCount=" + this.mActiveCommandCallbacks.size());
    }

    /* access modifiers changed from: private */
    public void updateSubscriptionInfoListForAllAccessibleEuiccs() {
        if (this.mTm.getCardIdForDefaultEuicc() == -1) {
            this.mSm.requestEmbeddedSubscriptionInfoListRefresh();
            return;
        }
        for (UiccCardInfo next : this.mTm.getUiccCardsInfo()) {
            if (next.isEuicc()) {
                this.mSm.requestEmbeddedSubscriptionInfoListRefresh(next.getCardId());
            }
        }
    }
}
