package com.android.internal.telephony.data;

import android.content.Intent;
import android.net.IpPrefix;
import android.net.LinkAddress;
import android.net.LinkProperties;
import android.net.NetworkAgentConfig;
import android.net.NetworkCapabilities;
import android.net.NetworkProvider;
import android.net.NetworkScore;
import android.net.ProxyInfo;
import android.net.RouteInfo;
import android.net.TelephonyNetworkSpecifier;
import android.net.Uri;
import android.net.vcn.VcnManager;
import android.net.vcn.VcnNetworkPolicyResult;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.telephony.AccessNetworkConstants;
import android.telephony.AnomalyReporter;
import android.telephony.DataFailCause;
import android.telephony.DataSpecificRegistrationInfo;
import android.telephony.LinkCapacityEstimate;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.PcoData;
import android.telephony.PreciseDataConnectionState;
import android.telephony.ServiceState;
import android.telephony.SubscriptionPlan;
import android.telephony.TelephonyDisplayInfo;
import android.telephony.TelephonyManager;
import android.telephony.data.ApnSetting;
import android.telephony.data.DataCallResponse;
import android.telephony.data.DataProfile;
import android.telephony.data.DataServiceCallback;
import android.telephony.data.NetworkSliceInfo;
import android.telephony.data.QosBearerSession;
import android.telephony.data.TrafficDescriptor;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.SparseArray;
import android.util.SparseIntArray;
import androidx.core.view.InputDeviceCompat;
import androidx.emoji2.text.ConcurrencyHelpers$$ExternalSyntheticLambda1;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.IState;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.RIL;
import com.android.internal.telephony.State;
import com.android.internal.telephony.StateMachine;
import com.android.internal.telephony.data.DataEvaluation;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.data.DataRetryManager;
import com.android.internal.telephony.data.LinkBandwidthEstimator;
import com.android.internal.telephony.data.TelephonyNetworkAgent;
import com.android.internal.telephony.metrics.DataCallSessionStats;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.util.LinkPropertiesUtils;
import com.android.internal.telephony.util.NetUtils;
import com.android.internal.telephony.util.NetworkCapabilitiesUtils;
import com.android.internal.util.ArrayUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DataNetwork extends StateMachine {
    public static final int BANDWIDTH_SOURCE_BANDWIDTH_ESTIMATOR = 3;
    public static final int BANDWIDTH_SOURCE_CARRIER_CONFIG = 2;
    public static final int BANDWIDTH_SOURCE_MODEM = 1;
    public static final int BANDWIDTH_SOURCE_UNKNOWN = 0;
    private static final int DEFAULT_INTERNET_NETWORK_SCORE = 50;
    private static final int EVENT_ALLOCATE_PDU_SESSION_ID_RESPONSE = 5;
    private static final int EVENT_ATTACH_NETWORK_REQUEST = 2;
    private static final int EVENT_BANDWIDTH_ESTIMATE_FROM_MODEM_CHANGED = 11;
    private static final int EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED = 18;
    private static final int EVENT_CSS_INDICATOR_CHANGED = 24;
    private static final int EVENT_DATA_CONFIG_UPDATED = 1;
    private static final int EVENT_DATA_STATE_CHANGED = 8;
    protected static final int EVENT_DEACTIVATE_DATA_NETWORK_RESPONSE = 19;
    protected static final int EVENT_DETACH_ALL_NETWORK_REQUESTS = 10;
    protected static final int EVENT_DETACH_NETWORK_REQUEST = 3;
    private static final int EVENT_DISPLAY_INFO_CHANGED = 13;
    private static final int EVENT_HANDOVER_RESPONSE = 15;
    private static final int EVENT_PCO_DATA_RECEIVED = 17;
    private static final int EVENT_SERVICE_STATE_CHANGED = 9;
    protected static final int EVENT_SETUP_DATA_NETWORK_RESPONSE = 6;
    private static final int EVENT_START_HANDOVER = 14;
    private static final int EVENT_STUCK_IN_TRANSIENT_STATE = 20;
    private static final int EVENT_SUBSCRIPTION_PLAN_OVERRIDE = 16;
    protected static final int EVENT_TEAR_DOWN_NETWORK = 7;
    private static final int EVENT_VOICE_CALL_ENDED = 23;
    private static final int EVENT_VOICE_CALL_STARTED = 22;
    private static final int EVENT_WAITING_FOR_TEARING_DOWN_CONDITION_MET = 21;
    private static final int INVALID_CID = -1;
    private static final List<Integer> MUTABLE_CAPABILITIES = List.of(new Integer[]{14, 16, 17, 18, 19, 20, 21, 24, 25, 28, 32, 11, 33});
    private static final int OTHER_NETWORK_SCORE = 45;
    public static final int TEAR_DOWN_REASON_AIRPLANE_MODE_ON = 3;
    public static final int TEAR_DOWN_REASON_CDMA_EMERGENCY_CALLBACK_MODE = 22;
    public static final int TEAR_DOWN_REASON_CONCURRENT_VOICE_DATA_NOT_ALLOWED = 8;
    public static final int TEAR_DOWN_REASON_CONNECTIVITY_SERVICE_UNWANTED = 1;
    public static final int TEAR_DOWN_REASON_DATA_CONFIG_NOT_READY = 19;
    public static final int TEAR_DOWN_REASON_DATA_DISABLED = 4;
    public static final int TEAR_DOWN_REASON_DATA_PROFILE_INVALID = 25;
    public static final int TEAR_DOWN_REASON_DATA_PROFILE_NOT_PREFERRED = 26;
    public static final int TEAR_DOWN_REASON_DATA_SERVICE_NOT_READY = 10;
    public static final int TEAR_DOWN_REASON_DATA_STALL = 12;
    public static final int TEAR_DOWN_REASON_DATA_THROTTLED = 24;
    public static final int TEAR_DOWN_REASON_DEFAULT_DATA_UNSELECTED = 17;
    public static final int TEAR_DOWN_REASON_HANDOVER_FAILED = 13;
    public static final int TEAR_DOWN_REASON_HANDOVER_NOT_ALLOWED = 14;
    public static final int TEAR_DOWN_REASON_ILLEGAL_STATE = 28;
    public static final int TEAR_DOWN_REASON_NOT_ALLOWED_BY_POLICY = 27;
    public static final int TEAR_DOWN_REASON_NOT_IN_SERVICE = 18;
    public static final int TEAR_DOWN_REASON_NO_LIVE_REQUEST = 5;
    public static final int TEAR_DOWN_REASON_NO_SUITABLE_DATA_PROFILE = 21;
    public static final int TEAR_DOWN_REASON_ONLY_ALLOWED_SINGLE_NETWORK = 29;
    public static final int TEAR_DOWN_REASON_PENDING_TEAR_DOWN_ALL = 20;
    public static final int TEAR_DOWN_REASON_POWER_OFF_BY_CARRIER = 11;
    public static final int TEAR_DOWN_REASON_PREFERRED_DATA_SWITCHED = 30;
    public static final int TEAR_DOWN_REASON_RAT_NOT_ALLOWED = 6;
    public static final int TEAR_DOWN_REASON_RETRY_SCHEDULED = 23;
    public static final int TEAR_DOWN_REASON_ROAMING_DISABLED = 7;
    public static final int TEAR_DOWN_REASON_SIM_REMOVAL = 2;
    public static final int TEAR_DOWN_REASON_VCN_REQUESTED = 15;
    public static final int TEAR_DOWN_REASON_VOPS_NOT_SUPPORTED = 16;
    private static final boolean VDBG = false;
    /* access modifiers changed from: private */
    public final AccessNetworksManager mAccessNetworksManager;
    /* access modifiers changed from: private */
    public int[] mAdministratorUids;
    protected final DataNetworkController.NetworkRequestList mAttachedNetworkRequestList;
    /* access modifiers changed from: private */
    public int mCarrierServicePackageUid;
    protected final SparseIntArray mCid;
    private boolean mCongested;
    protected ConnectedState mConnectedState = new ConnectedState();
    protected ConnectingState mConnectingState = new ConnectingState();
    private DataEvaluation.DataAllowedReason mDataAllowedReason;
    private DataCallResponse mDataCallResponse;
    protected final DataCallSessionStats mDataCallSessionStats;
    protected final DataConfigManager mDataConfigManager;
    protected final DataNetworkCallback mDataNetworkCallback;
    protected final DataNetworkController mDataNetworkController;
    /* access modifiers changed from: private */
    public final DataNetworkController.DataNetworkControllerCallback mDataNetworkControllerCallback;
    protected DataProfile mDataProfile;
    protected final SparseArray<DataServiceManager> mDataServiceManagers;
    protected DefaultState mDefaultState = new DefaultState();
    /* access modifiers changed from: private */
    public DisconnectedState mDisconnectedState = new DisconnectedState();
    protected DisconnectingState mDisconnectingState = new DisconnectingState();
    /* access modifiers changed from: private */
    public boolean mEverConnected = false;
    protected int mFailCause;
    private DataProfile mHandoverDataProfile;
    private HandoverState mHandoverState = new HandoverState();
    /* access modifiers changed from: private */
    public int mInitialNetworkAgentId;
    protected boolean mInvokedDataDeactivation = false;
    /* access modifiers changed from: private */
    public KeepaliveTracker mKeepaliveTracker;
    private LinkBandwidthEstimator.LinkBandwidthEstimatorCallback mLinkBandwidthEstimatorCallback;
    /* access modifiers changed from: private */
    public LinkProperties mLinkProperties;
    private int mLinkStatus;
    private final LocalLog mLocalLog = new LocalLog(128);
    protected String mLogTag;
    protected TelephonyNetworkAgent mNetworkAgent;
    private NetworkBandwidth mNetworkBandwidth;
    protected NetworkCapabilities mNetworkCapabilities;
    private int mNetworkScore;
    private NetworkSliceInfo mNetworkSliceInfo;
    private final Map<Integer, PcoData> mPcoData;
    /* access modifiers changed from: private */
    public int mPduSessionId;
    protected final Phone mPhone;
    /* access modifiers changed from: private */
    public final List<QosBearerSession> mQosBearerSessions;
    /* access modifiers changed from: private */
    public QosCallbackTracker mQosCallbackTracker;
    /* access modifiers changed from: private */
    public long mRetryDelayMillis;
    /* access modifiers changed from: private */
    public final CommandsInterface mRil;
    private final int mSubId;
    protected boolean mSuspended;
    private String mTcpBufferSizes;
    private TelephonyDisplayInfo mTelephonyDisplayInfo;
    private boolean mTempNotMetered;
    private boolean mTempNotMeteredSupported;
    private final List<TrafficDescriptor> mTrafficDescriptors;
    protected int mTransport;
    protected final VcnManager mVcnManager;
    /* access modifiers changed from: private */
    public VcnManager.VcnNetworkPolicyChangeListener mVcnPolicyChangeListener;

    public @interface BandwidthEstimationSource {
    }

    public @interface TearDownReason {
    }

    /* access modifiers changed from: protected */
    public void logv(String str) {
    }

    /* access modifiers changed from: protected */
    public int mtkGetCustomizedMtu(ApnSetting apnSetting, int i) {
        return 0;
    }

    /* access modifiers changed from: protected */
    public boolean mtkHandleSetupResponse(int i, DataCallResponse dataCallResponse) {
        return false;
    }

    /* access modifiers changed from: protected */
    public void mtkReplaceStates() {
    }

    /* access modifiers changed from: protected */
    public boolean mtkSkipDataStallAlarm(String str) {
        return false;
    }

    /* access modifiers changed from: protected */
    public void mtkUpdateNetworkCapabilities(NetworkCapabilities.Builder builder) {
    }

    public static class NetworkBandwidth {
        public final int downlinkBandwidthKbps;
        public final int uplinkBandwidthKbps;

        public NetworkBandwidth(int i, int i2) {
            this.downlinkBandwidthKbps = i;
            this.uplinkBandwidthKbps = i2;
        }

        public String toString() {
            return String.format("NetworkBandwidth=[downlink=%d, uplink=%d]", new Object[]{Integer.valueOf(this.downlinkBandwidthKbps), Integer.valueOf(this.uplinkBandwidthKbps)});
        }
    }

    public static abstract class DataNetworkCallback extends DataCallback {
        public abstract void onAttachFailed(DataNetwork dataNetwork, DataNetworkController.NetworkRequestList networkRequestList);

        public abstract void onConnected(DataNetwork dataNetwork);

        public abstract void onDisconnected(DataNetwork dataNetwork, int i);

        public abstract void onHandoverFailed(DataNetwork dataNetwork, int i, long j, int i2);

        public abstract void onHandoverSucceeded(DataNetwork dataNetwork);

        public abstract void onLinkStatusChanged(DataNetwork dataNetwork, int i);

        public abstract void onNetworkCapabilitiesChanged(DataNetwork dataNetwork);

        public abstract void onPcoDataChanged(DataNetwork dataNetwork);

        public abstract void onSetupDataFailed(DataNetwork dataNetwork, DataNetworkController.NetworkRequestList networkRequestList, int i, long j);

        public abstract void onSuspendedStateChanged(DataNetwork dataNetwork, boolean z);

        public abstract void onTrackNetworkUnwanted(DataNetwork dataNetwork);

        public abstract void onValidationStatusChanged(DataNetwork dataNetwork, int i, Uri uri);

        public DataNetworkCallback(Executor executor) {
            super(executor);
        }
    }

    public DataNetwork(Phone phone, Looper looper, SparseArray<DataServiceManager> sparseArray, DataProfile dataProfile, DataNetworkController.NetworkRequestList networkRequestList, int i, DataEvaluation.DataAllowedReason dataAllowedReason, DataNetworkCallback dataNetworkCallback) {
        super("DataNetwork", looper);
        SparseIntArray sparseIntArray = new SparseIntArray(2);
        this.mCid = sparseIntArray;
        this.mPduSessionId = 0;
        ArrayList arrayList = new ArrayList();
        this.mTrafficDescriptors = arrayList;
        this.mLinkStatus = -1;
        this.mNetworkBandwidth = new NetworkBandwidth(14, 14);
        this.mTempNotMeteredSupported = false;
        this.mTempNotMetered = false;
        this.mCongested = false;
        DataNetworkController.NetworkRequestList networkRequestList2 = new DataNetworkController.NetworkRequestList();
        this.mAttachedNetworkRequestList = networkRequestList2;
        this.mDataCallResponse = null;
        this.mFailCause = 0;
        this.mRetryDelayMillis = -1;
        this.mSuspended = false;
        this.mPcoData = new ArrayMap();
        this.mQosBearerSessions = new ArrayList();
        this.mAdministratorUids = new int[0];
        this.mCarrierServicePackageUid = -1;
        mtkReplaceStates();
        initializeStateMachine();
        this.mPhone = phone;
        this.mSubId = phone.getSubId();
        this.mRil = phone.mCi;
        this.mLinkProperties = new LinkProperties();
        this.mDataServiceManagers = sparseArray;
        this.mAccessNetworksManager = phone.getAccessNetworksManager();
        this.mVcnManager = (VcnManager) phone.getContext().getSystemService(VcnManager.class);
        DataNetworkController dataNetworkController = phone.getDataNetworkController();
        this.mDataNetworkController = dataNetworkController;
        Handler handler = getHandler();
        Objects.requireNonNull(handler);
        AnonymousClass1 r10 = new DataNetworkController.DataNetworkControllerCallback(new ConcurrencyHelpers$$ExternalSyntheticLambda1(handler)) {
            public void onSubscriptionPlanOverride() {
                DataNetwork.this.sendMessage(16);
            }
        };
        this.mDataNetworkControllerCallback = r10;
        dataNetworkController.registerDataNetworkControllerCallback(r10);
        DataConfigManager dataConfigManager = dataNetworkController.getDataConfigManager();
        this.mDataConfigManager = dataConfigManager;
        this.mDataCallSessionStats = new DataCallSessionStats(phone);
        this.mDataNetworkCallback = dataNetworkCallback;
        this.mDataProfile = dataProfile;
        if (dataProfile.getTrafficDescriptor() != null) {
            arrayList.add(dataProfile.getTrafficDescriptor());
        }
        this.mTransport = i;
        this.mDataAllowedReason = dataAllowedReason;
        dataProfile.setLastSetupTimestamp(SystemClock.elapsedRealtime());
        networkRequestList2.addAll(networkRequestList);
        sparseIntArray.put(1, -1);
        sparseIntArray.put(2, -1);
        this.mTcpBufferSizes = dataConfigManager.getDefaultTcpConfigString();
        this.mTelephonyDisplayInfo = phone.getDisplayInfoController().getTelephonyDisplayInfo();
        Iterator it = networkRequestList.iterator();
        while (it.hasNext()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
            telephonyNetworkRequest.setAttachedNetwork(this);
            telephonyNetworkRequest.setState(1);
        }
        updateNetworkCapabilities();
    }

    private void initializeStateMachine() {
        addState(this.mDefaultState);
        addState(this.mConnectingState, this.mDefaultState);
        addState(this.mConnectedState, this.mDefaultState);
        addState(this.mHandoverState, this.mDefaultState);
        addState(this.mDisconnectingState, this.mDefaultState);
        addState(this.mDisconnectedState, this.mDefaultState);
        setInitialState(this.mConnectingState);
        start();
    }

    private boolean shouldSkip464Xlat() {
        if (this.mDataProfile.getApnSetting() != null) {
            int skip464Xlat = this.mDataProfile.getApnSetting().getSkip464Xlat();
            if (skip464Xlat == 0) {
                return false;
            }
            if (skip464Xlat == 1) {
                return true;
            }
        }
        NetworkCapabilities networkCapabilities = getNetworkCapabilities();
        if (!networkCapabilities.hasCapability(4) || networkCapabilities.hasCapability(12)) {
            return false;
        }
        return true;
    }

    /* access modifiers changed from: private */
    public TelephonyNetworkAgent createNetworkAgent() {
        NetworkProvider networkProvider;
        NetworkAgentConfig.Builder builder = new NetworkAgentConfig.Builder();
        builder.setLegacyType(0);
        builder.setLegacyTypeName("MOBILE");
        int dataNetworkType = getDataNetworkType();
        builder.setLegacySubType(dataNetworkType);
        builder.setLegacySubTypeName(TelephonyManager.getNetworkTypeName(dataNetworkType));
        if (this.mDataProfile.getApnSetting() != null) {
            builder.setLegacyExtraInfo(this.mDataProfile.getApnSetting().getApnName());
        }
        if (this.mPhone.getCarrierSignalAgent().hasRegisteredReceivers("android.telephony.action.CARRIER_SIGNAL_REDIRECTED")) {
            builder.setProvisioningNotificationEnabled(false);
        }
        String subscriberId = this.mPhone.getSubscriberId();
        if (!TextUtils.isEmpty(subscriberId)) {
            builder.setSubscriberId(subscriberId);
        }
        if (shouldSkip464Xlat()) {
            builder.setNat64DetectionEnabled(false);
        }
        TelephonyNetworkFactory networkFactory = PhoneFactory.getNetworkFactory(this.mPhone.getPhoneId());
        if (networkFactory == null) {
            networkProvider = null;
        } else {
            networkProvider = networkFactory.getProvider();
        }
        NetworkProvider networkProvider2 = networkProvider;
        this.mNetworkScore = getNetworkScore();
        Phone phone = this.mPhone;
        Looper looper = getHandler().getLooper();
        NetworkScore build = new NetworkScore.Builder().setLegacyInt(this.mNetworkScore).build();
        NetworkAgentConfig build2 = builder.build();
        Handler handler = getHandler();
        Objects.requireNonNull(handler);
        return new TelephonyNetworkAgent(phone, looper, this, build, build2, networkProvider2, new TelephonyNetworkAgent.TelephonyNetworkAgentCallback(new ConcurrencyHelpers$$ExternalSyntheticLambda1(handler)) {
            public void onValidationStatus(int i, Uri uri) {
                if (DataNetwork.this.mDataProfile.getApnSetting() != null) {
                    DataNetwork dataNetwork = DataNetwork.this;
                    if (dataNetwork.mtkSkipDataStallAlarm(dataNetwork.mDataProfile.getApnSetting().getApnName())) {
                        DataNetwork.this.log("configured skip data stall.");
                        return;
                    }
                }
                DataNetwork.this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$2$$ExternalSyntheticLambda0(this, i, uri));
            }

            /* access modifiers changed from: private */
            public /* synthetic */ void lambda$onValidationStatus$0(int i, Uri uri) {
                DataNetwork dataNetwork = DataNetwork.this;
                dataNetwork.mDataNetworkCallback.onValidationStatusChanged(dataNetwork, i, uri);
            }
        });
    }

    protected class DefaultState extends State {
        protected DefaultState() {
        }

        public void enter() {
            DataNetwork.this.logv("Registering all events.");
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.mDataConfigManager.registerForConfigUpdate(dataNetwork.getHandler(), 1);
            DataNetwork.this.mPhone.getDisplayInfoController().registerForTelephonyDisplayInfoChanged(DataNetwork.this.getHandler(), 13, (Object) null);
            DataNetwork.this.mPhone.getServiceStateTracker().registerForServiceStateChanged(DataNetwork.this.getHandler(), 9);
            for (int i : DataNetwork.this.mAccessNetworksManager.getAvailableTransports()) {
                DataNetwork.this.mDataServiceManagers.get(i).registerForDataCallListChanged(DataNetwork.this.getHandler(), 8);
            }
            DataNetwork.this.mPhone.getCarrierPrivilegesTracker().registerCarrierPrivilegesListener(DataNetwork.this.getHandler(), 18, (Object) null);
            DataNetwork.this.mPhone.getServiceStateTracker().registerForCssIndicatorChanged(DataNetwork.this.getHandler(), 24, (Object) null);
            DataNetwork.this.mPhone.getCallTracker().registerForVoiceCallStarted(DataNetwork.this.getHandler(), 22, (Object) null);
            DataNetwork.this.mPhone.getCallTracker().registerForVoiceCallEnded(DataNetwork.this.getHandler(), 23, (Object) null);
            if (DataNetwork.this.mPhone.getImsPhone() != null) {
                DataNetwork.this.mPhone.getImsPhone().getCallTracker().registerForVoiceCallStarted(DataNetwork.this.getHandler(), 22, (Object) null);
                DataNetwork.this.mPhone.getImsPhone().getCallTracker().registerForVoiceCallEnded(DataNetwork.this.getHandler(), 23, (Object) null);
            }
        }

        public void exit() {
            DataNetwork.this.logv("Unregistering all events.");
            if (DataNetwork.this.mPhone.getImsPhone() != null) {
                DataNetwork.this.mPhone.getImsPhone().getCallTracker().unregisterForVoiceCallStarted(DataNetwork.this.getHandler());
                DataNetwork.this.mPhone.getImsPhone().getCallTracker().unregisterForVoiceCallEnded(DataNetwork.this.getHandler());
            }
            DataNetwork.this.mPhone.getCallTracker().unregisterForVoiceCallStarted(DataNetwork.this.getHandler());
            DataNetwork.this.mPhone.getCallTracker().unregisterForVoiceCallEnded(DataNetwork.this.getHandler());
            DataNetwork.this.mPhone.getServiceStateTracker().unregisterForCssIndicatorChanged(DataNetwork.this.getHandler());
            DataNetwork.this.mPhone.getCarrierPrivilegesTracker().unregisterCarrierPrivilegesListener(DataNetwork.this.getHandler());
            for (int i : DataNetwork.this.mAccessNetworksManager.getAvailableTransports()) {
                DataNetwork.this.mDataServiceManagers.get(i).unregisterForDataCallListChanged(DataNetwork.this.getHandler());
            }
            DataNetwork.this.mPhone.getServiceStateTracker().unregisterForServiceStateChanged(DataNetwork.this.getHandler());
            DataNetwork.this.mPhone.getDisplayInfoController().unregisterForTelephonyDisplayInfoChanged(DataNetwork.this.getHandler());
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.mDataConfigManager.unregisterForConfigUpdate(dataNetwork.getHandler());
        }

        public boolean processMessage(Message message) {
            switch (message.what) {
                case 1:
                    DataNetwork.this.onDataConfigUpdated();
                    return true;
                case 2:
                    DataNetwork.this.onAttachNetworkRequests((DataNetworkController.NetworkRequestList) message.obj);
                    DataNetwork.this.updateNetworkScore();
                    return true;
                case 3:
                    DataNetwork.this.onDetachNetworkRequest((TelephonyNetworkRequest) message.obj);
                    DataNetwork.this.updateNetworkScore();
                    return true;
                case 7:
                case 11:
                case 13:
                case 17:
                case 20:
                case 21:
                case 22:
                case 23:
                case 24:
                    DataNetwork dataNetwork = DataNetwork.this;
                    dataNetwork.log("Ignored " + DataNetwork.eventToString(message.what));
                    return true;
                case 8:
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    DataNetwork.this.onDataStateChanged(((Integer) asyncResult.userObj).intValue(), (List) asyncResult.result);
                    return true;
                case 9:
                    DataNetwork dataNetwork2 = DataNetwork.this;
                    dataNetwork2.mDataCallSessionStats.onDrsOrRatChanged(dataNetwork2.getDataNetworkType());
                    DataNetwork.this.updateSuspendState();
                    DataNetwork.this.updateNetworkCapabilities();
                    return true;
                case 10:
                    Iterator it = DataNetwork.this.mAttachedNetworkRequestList.iterator();
                    while (it.hasNext()) {
                        TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
                        telephonyNetworkRequest.setState(0);
                        telephonyNetworkRequest.setAttachedNetwork((DataNetwork) null);
                    }
                    DataNetwork.this.log("All network requests detached.");
                    DataNetwork.this.mAttachedNetworkRequestList.clear();
                    return true;
                case 14:
                    DataNetwork dataNetwork3 = DataNetwork.this;
                    dataNetwork3.log("Ignore the handover to " + AccessNetworkConstants.transportTypeToString(message.arg1) + " request.");
                    return true;
                case 18:
                    int[] iArr = (int[]) ((AsyncResult) message.obj).result;
                    DataNetwork.this.mAdministratorUids = Arrays.copyOf(iArr, iArr.length);
                    DataNetwork.this.updateNetworkCapabilities();
                    return true;
                default:
                    DataNetwork dataNetwork4 = DataNetwork.this;
                    dataNetwork4.loge("Unhandled event " + DataNetwork.eventToString(message.what));
                    return true;
            }
        }
    }

    protected class ConnectingState extends State {
        protected ConnectingState() {
        }

        public void enter() {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.sendMessageDelayed(20, (long) dataNetwork.mDataConfigManager.getAnomalyNetworkConnectingTimeoutMs());
            DataNetwork dataNetwork2 = DataNetwork.this;
            dataNetwork2.mNetworkAgent = dataNetwork2.createNetworkAgent();
            DataNetwork dataNetwork3 = DataNetwork.this;
            dataNetwork3.mInitialNetworkAgentId = dataNetwork3.mNetworkAgent.getId();
            DataNetwork dataNetwork4 = DataNetwork.this;
            StringBuilder sb = new StringBuilder();
            sb.append("DN-");
            sb.append(DataNetwork.this.mInitialNetworkAgentId);
            sb.append("-");
            sb.append(DataNetwork.this.mTransport == 1 ? "C" : "I");
            dataNetwork4.mLogTag = sb.toString();
            DataNetwork dataNetwork5 = DataNetwork.this;
            dataNetwork5.mCarrierServicePackageUid = dataNetwork5.mPhone.getCarrierPrivilegesTracker().getCarrierServicePackageUid();
            DataNetwork.this.notifyPreciseDataConnectionState();
            DataNetwork dataNetwork6 = DataNetwork.this;
            if (dataNetwork6.mTransport == 2) {
                dataNetwork6.allocatePduSessionId();
            } else {
                dataNetwork6.setupData();
            }
        }

        public void exit() {
            DataNetwork.this.removeMessages(20);
        }

        public boolean processMessage(Message message) {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.logv("event=" + DataNetwork.eventToString(message.what));
            int i = message.what;
            if (i == 5) {
                AsyncResult asyncResult = (AsyncResult) message.obj;
                if (asyncResult.exception == null) {
                    DataNetwork.this.mPduSessionId = ((Integer) asyncResult.result).intValue();
                    DataNetwork dataNetwork2 = DataNetwork.this;
                    dataNetwork2.log("Set PDU session id to " + DataNetwork.this.mPduSessionId);
                } else {
                    DataNetwork dataNetwork3 = DataNetwork.this;
                    dataNetwork3.loge("Failed to allocate PDU session id. e=" + asyncResult.exception);
                }
                DataNetwork.this.setupData();
                return true;
            } else if (i != 6) {
                if (!(i == 7 || i == 14 || i == 17)) {
                    if (i == 20) {
                        DataNetwork dataNetwork4 = DataNetwork.this;
                        dataNetwork4.reportAnomaly("Data network stuck in connecting state for " + TimeUnit.MILLISECONDS.toSeconds((long) DataNetwork.this.mDataConfigManager.getAnomalyNetworkConnectingTimeoutMs()) + " seconds.", "58c56403-7ea7-4e56-a0c7-e467114d09b8");
                        DataNetwork.this.mRetryDelayMillis = -1;
                        DataNetwork dataNetwork5 = DataNetwork.this;
                        dataNetwork5.mFailCause = 65547;
                        dataNetwork5.transitionTo(dataNetwork5.mDisconnectedState);
                        return true;
                    } else if (i != 21) {
                        return false;
                    }
                }
                DataNetwork dataNetwork6 = DataNetwork.this;
                dataNetwork6.log("Defer message " + DataNetwork.eventToString(message.what));
                DataNetwork.this.deferMessage(message);
                return true;
            } else {
                DataNetwork.this.onSetupResponse(message.arg1, message.getData().getParcelable("data_call_response"));
                return true;
            }
        }
    }

    protected class ConnectedState extends State {
        protected ConnectedState() {
        }

        public void enter() {
            if (!DataNetwork.this.mEverConnected) {
                DataNetwork.this.log("network connected.");
                DataNetwork.this.mEverConnected = true;
                DataNetwork.this.mNetworkAgent.markConnected();
                DataNetwork.this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$ConnectedState$$ExternalSyntheticLambda0(this));
                DataNetwork dataNetwork = DataNetwork.this;
                DataNetwork dataNetwork2 = DataNetwork.this;
                dataNetwork.mQosCallbackTracker = new QosCallbackTracker(dataNetwork2.mNetworkAgent, dataNetwork2.mPhone);
                DataNetwork.this.mQosCallbackTracker.updateSessions(DataNetwork.this.mQosBearerSessions);
                DataNetwork dataNetwork3 = DataNetwork.this;
                DataNetwork dataNetwork4 = DataNetwork.this;
                Phone phone = dataNetwork4.mPhone;
                Looper looper = dataNetwork4.getHandler().getLooper();
                DataNetwork dataNetwork5 = DataNetwork.this;
                dataNetwork3.mKeepaliveTracker = new KeepaliveTracker(phone, looper, dataNetwork5, dataNetwork5.mNetworkAgent);
                DataNetwork dataNetwork6 = DataNetwork.this;
                if (dataNetwork6.mTransport == 1) {
                    dataNetwork6.registerForWwanEvents();
                }
                DataNetwork dataNetwork7 = DataNetwork.this;
                if (dataNetwork7.mVcnManager != null) {
                    dataNetwork7.mVcnPolicyChangeListener = new DataNetwork$ConnectedState$$ExternalSyntheticLambda1(this);
                    DataNetwork dataNetwork8 = DataNetwork.this;
                    VcnManager vcnManager = dataNetwork8.mVcnManager;
                    Handler handler = dataNetwork8.getHandler();
                    Objects.requireNonNull(handler);
                    vcnManager.addVcnNetworkPolicyChangeListener(new ConcurrencyHelpers$$ExternalSyntheticLambda1(handler), DataNetwork.this.mVcnPolicyChangeListener);
                }
            }
            DataNetwork.this.notifyPreciseDataConnectionState();
            DataNetwork.this.updateSuspendState();
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$enter$0() {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.mDataNetworkCallback.onConnected(dataNetwork);
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$enter$1() {
            DataNetwork.this.log("VCN policy changed.");
            DataNetwork dataNetwork = DataNetwork.this;
            if (dataNetwork.mVcnManager.applyVcnNetworkPolicy(dataNetwork.mNetworkCapabilities, dataNetwork.mLinkProperties).isTeardownRequested()) {
                DataNetwork.this.lambda$tearDownWhenConditionMet$7(15);
            } else {
                DataNetwork.this.updateNetworkCapabilities();
            }
        }

        public boolean processMessage(Message message) {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.logv("event=" + DataNetwork.eventToString(message.what));
            switch (message.what) {
                case 7:
                    DataNetwork dataNetwork2 = DataNetwork.this;
                    if (!dataNetwork2.mInvokedDataDeactivation) {
                        int i = message.arg1;
                        if (i != 1 && dataNetwork2.shouldDelayImsTearDown()) {
                            DataNetwork dataNetwork3 = DataNetwork.this;
                            dataNetwork3.logl("Delay IMS tear down until call ends. reason=" + DataNetwork.tearDownReasonToString(i));
                            break;
                        } else {
                            DataNetwork.this.removeMessages(7);
                            DataNetwork.this.removeDeferredMessages(7);
                            DataNetwork dataNetwork4 = DataNetwork.this;
                            dataNetwork4.transitionTo(dataNetwork4.mDisconnectingState);
                            DataNetwork.this.onTearDown(i);
                            break;
                        }
                    } else {
                        dataNetwork2.log("Ignore tear down request because network is being torn down.");
                        break;
                    }
                    break;
                case 11:
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    if (asyncResult.exception == null) {
                        DataNetwork.this.onBandwidthUpdatedFromModem((List) asyncResult.result);
                        break;
                    } else {
                        DataNetwork dataNetwork5 = DataNetwork.this;
                        dataNetwork5.log("EVENT_BANDWIDTH_ESTIMATE_FROM_MODEM_CHANGED: error ignoring, e=" + asyncResult.exception);
                        break;
                    }
                case 13:
                    DataNetwork.this.onDisplayInfoChanged();
                    break;
                case 14:
                    DataNetwork.this.onStartHandover(message.arg1, (DataRetryManager.DataHandoverRetryEntry) message.obj);
                    break;
                case 16:
                    DataNetwork.this.updateMeteredAndCongested();
                    break;
                case 17:
                    DataNetwork.this.onPcoDataReceived((PcoData) ((AsyncResult) message.obj).result);
                    break;
                case 19:
                    DataNetwork.this.onDeactivateResponse(message.arg1);
                    break;
                case 21:
                    DataNetwork dataNetwork6 = DataNetwork.this;
                    dataNetwork6.transitionTo(dataNetwork6.mDisconnectingState);
                    DataNetwork.this.sendMessageDelayed(7, message.arg1, (long) message.arg2);
                    break;
                case 22:
                case 23:
                case 24:
                    DataNetwork.this.updateSuspendState();
                    DataNetwork.this.updateNetworkCapabilities();
                    break;
                default:
                    return false;
            }
            return true;
        }
    }

    protected class HandoverState extends State {
        protected HandoverState() {
        }

        public void enter() {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.sendMessageDelayed(20, (long) dataNetwork.mDataConfigManager.getNetworkHandoverTimeoutMs());
            DataNetwork.this.notifyPreciseDataConnectionState();
        }

        public void exit() {
            DataNetwork.this.removeMessages(20);
        }

        public boolean processMessage(Message message) {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.logv("event=" + DataNetwork.eventToString(message.what));
            int i = message.what;
            if (i != 7) {
                if (i != 8) {
                    if (i != 13) {
                        if (i == 15) {
                            DataNetwork.this.onHandoverResponse(message.arg1, message.getData().getParcelable("data_call_response"), (DataRetryManager.DataHandoverRetryEntry) message.obj);
                            return true;
                        } else if (i != 17) {
                            switch (i) {
                                case 20:
                                    DataNetwork dataNetwork2 = DataNetwork.this;
                                    dataNetwork2.reportAnomaly("Data service did not respond the handover request within " + TimeUnit.MILLISECONDS.toSeconds((long) DataNetwork.this.mDataConfigManager.getNetworkHandoverTimeoutMs()) + " seconds.", "1afe68cb-8b41-4964-a737-4f34372429ea");
                                    DataNetwork dataNetwork3 = DataNetwork.this;
                                    dataNetwork3.mFailCause = 65535;
                                    dataNetwork3.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$HandoverState$$ExternalSyntheticLambda1(this, -1, 3));
                                    DataNetwork dataNetwork4 = DataNetwork.this;
                                    dataNetwork4.transitionTo(dataNetwork4.mConnectedState);
                                    return true;
                                case 21:
                                case 22:
                                case 23:
                                case 24:
                                    break;
                                default:
                                    return false;
                            }
                        } else {
                            DataNetwork.this.onPcoDataReceived((PcoData) ((AsyncResult) message.obj).result);
                            return true;
                        }
                    }
                } else if (!shouldDeferDataStateChangedEvent(message)) {
                    return true;
                } else {
                    DataNetwork dataNetwork5 = DataNetwork.this;
                    dataNetwork5.log("Defer message " + DataNetwork.eventToString(message.what));
                    DataNetwork.this.deferMessage(message);
                    return true;
                }
            }
            DataNetwork dataNetwork6 = DataNetwork.this;
            dataNetwork6.log("Defer message " + DataNetwork.eventToString(message.what));
            DataNetwork.this.deferMessage(message);
            return true;
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$processMessage$0(long j, int i) {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.mDataNetworkCallback.onHandoverFailed(dataNetwork, dataNetwork.mFailCause, j, i);
        }

        private boolean shouldDeferDataStateChangedEvent(Message message) {
            AsyncResult asyncResult = (AsyncResult) message.obj;
            int intValue = ((Integer) asyncResult.userObj).intValue();
            List list = (List) asyncResult.result;
            DataNetwork dataNetwork = DataNetwork.this;
            if (intValue != dataNetwork.mTransport) {
                dataNetwork.log("Dropped unrelated " + AccessNetworkConstants.transportTypeToString(intValue) + " data call list changed event. " + list);
                return false;
            }
            boolean anyMatch = list.stream().anyMatch(new DataNetwork$HandoverState$$ExternalSyntheticLambda0(this));
            if (anyMatch) {
                DataNetwork dataNetwork2 = DataNetwork.this;
                dataNetwork2.log("Deferred the related data call list changed event." + list);
            } else {
                DataNetwork dataNetwork3 = DataNetwork.this;
                dataNetwork3.log("Dropped unrelated data call list changed event. " + list);
            }
            return anyMatch;
        }

        /* access modifiers changed from: private */
        public /* synthetic */ boolean lambda$shouldDeferDataStateChangedEvent$1(DataCallResponse dataCallResponse) {
            DataNetwork dataNetwork = DataNetwork.this;
            return dataNetwork.mCid.get(dataNetwork.mTransport) == dataCallResponse.getId();
        }
    }

    protected class DisconnectingState extends State {
        protected DisconnectingState() {
        }

        public void enter() {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.sendMessageDelayed(20, (long) dataNetwork.mDataConfigManager.getAnomalyNetworkDisconnectingTimeoutMs());
            DataNetwork.this.notifyPreciseDataConnectionState();
        }

        public void exit() {
            DataNetwork.this.removeMessages(20);
        }

        public boolean processMessage(Message message) {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.logv("event=" + DataNetwork.eventToString(message.what));
            int i = message.what;
            if (i == 7) {
                DataNetwork dataNetwork2 = DataNetwork.this;
                if (dataNetwork2.mInvokedDataDeactivation) {
                    dataNetwork2.log("Ignore tear down request because network is being torn down.");
                    return true;
                }
                dataNetwork2.removeMessages(7);
                DataNetwork.this.removeDeferredMessages(7);
                DataNetwork.this.onTearDown(message.arg1);
                return true;
            } else if (i == 13) {
                DataNetwork.this.onDisplayInfoChanged();
                return true;
            } else if (i == 19) {
                DataNetwork.this.onDeactivateResponse(message.arg1);
                return true;
            } else if (i != 20) {
                switch (i) {
                    case 22:
                    case 23:
                    case 24:
                        DataNetwork.this.updateSuspendState();
                        DataNetwork.this.updateNetworkCapabilities();
                        return true;
                    default:
                        return false;
                }
            } else {
                DataNetwork dataNetwork3 = DataNetwork.this;
                dataNetwork3.reportAnomaly("RIL did not send data call list changed event after deactivate data call request within " + TimeUnit.MILLISECONDS.toSeconds((long) DataNetwork.this.mDataConfigManager.getAnomalyNetworkDisconnectingTimeoutMs()) + " seconds.", "d0e4fa1c-c57b-4ba5-b4b6-8955487012cc");
                DataNetwork dataNetwork4 = DataNetwork.this;
                dataNetwork4.mFailCause = InputDeviceCompat.SOURCE_TRACKBALL;
                dataNetwork4.transitionTo(dataNetwork4.mDisconnectedState);
                return true;
            }
        }
    }

    protected class DisconnectedState extends State {
        protected DisconnectedState() {
        }

        public void enter() {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.logl("Data network disconnected. mEverConnected=" + DataNetwork.this.mEverConnected);
            DataNetworkController.NetworkRequestList networkRequestList = new DataNetworkController.NetworkRequestList(DataNetwork.this.mAttachedNetworkRequestList);
            DataNetwork.this.sendMessage(10);
            DataNetwork.this.quit();
            if (DataNetwork.this.mEverConnected) {
                DataNetwork.this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$DisconnectedState$$ExternalSyntheticLambda0(this));
                DataNetwork dataNetwork2 = DataNetwork.this;
                if (dataNetwork2.mTransport == 1) {
                    dataNetwork2.unregisterForWwanEvents();
                }
            } else {
                DataNetwork.this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$DisconnectedState$$ExternalSyntheticLambda1(this, networkRequestList));
            }
            DataNetwork.this.notifyPreciseDataConnectionState();
            DataNetwork.this.mNetworkAgent.unregister();
            DataNetwork dataNetwork3 = DataNetwork.this;
            dataNetwork3.mDataNetworkController.unregisterDataNetworkControllerCallback(dataNetwork3.mDataNetworkControllerCallback);
            DataNetwork dataNetwork4 = DataNetwork.this;
            dataNetwork4.mDataCallSessionStats.onDataCallDisconnected(dataNetwork4.mFailCause);
            DataNetwork dataNetwork5 = DataNetwork.this;
            if (dataNetwork5.mTransport == 2 && dataNetwork5.mPduSessionId != 0) {
                DataNetwork.this.mRil.releasePduSessionId((Message) null, DataNetwork.this.mPduSessionId);
            }
            DataNetwork dataNetwork6 = DataNetwork.this;
            if (dataNetwork6.mVcnManager != null && dataNetwork6.mVcnPolicyChangeListener != null) {
                DataNetwork dataNetwork7 = DataNetwork.this;
                dataNetwork7.mVcnManager.removeVcnNetworkPolicyChangeListener(dataNetwork7.mVcnPolicyChangeListener);
            }
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$enter$0() {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.mDataNetworkCallback.onDisconnected(dataNetwork, dataNetwork.mFailCause);
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$enter$1(DataNetworkController.NetworkRequestList networkRequestList) {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.mDataNetworkCallback.onSetupDataFailed(dataNetwork, networkRequestList, dataNetwork.mFailCause, dataNetwork.mRetryDelayMillis);
        }

        public boolean processMessage(Message message) {
            DataNetwork dataNetwork = DataNetwork.this;
            dataNetwork.logv("event=" + DataNetwork.eventToString(message.what));
            return false;
        }
    }

    /* access modifiers changed from: private */
    public void registerForWwanEvents() {
        registerForBandwidthUpdate();
        this.mKeepaliveTracker.registerForKeepaliveStatus();
        this.mRil.registerForPcoData(getHandler(), 17, (Object) null);
    }

    /* access modifiers changed from: private */
    public void unregisterForWwanEvents() {
        unregisterForBandwidthUpdate();
        this.mKeepaliveTracker.unregisterForKeepaliveStatus();
        this.mRil.unregisterForPcoData(getHandler());
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
        loge(sb.toString());
    }

    public boolean attachNetworkRequests(DataNetworkController.NetworkRequestList networkRequestList) {
        if (getCurrentState() == null || isDisconnected()) {
            return false;
        }
        sendMessage(obtainMessage(2, (Object) networkRequestList));
        return true;
    }

    public void onAttachNetworkRequests(DataNetworkController.NetworkRequestList networkRequestList) {
        DataNetworkController.NetworkRequestList networkRequestList2 = new DataNetworkController.NetworkRequestList();
        Iterator it = networkRequestList.iterator();
        while (it.hasNext()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
            if (!this.mDataNetworkController.isNetworkRequestExisting(telephonyNetworkRequest)) {
                networkRequestList2.add(telephonyNetworkRequest);
                log("Attached failed. Network request was already removed. " + telephonyNetworkRequest);
            } else if (!telephonyNetworkRequest.canBeSatisfiedBy(getNetworkCapabilities())) {
                networkRequestList2.add(telephonyNetworkRequest);
                log("Attached failed. Cannot satisfy the network request " + telephonyNetworkRequest);
            } else {
                this.mAttachedNetworkRequestList.add(telephonyNetworkRequest);
                telephonyNetworkRequest.setAttachedNetwork(this);
                telephonyNetworkRequest.setState(1);
                log("Successfully attached network request " + telephonyNetworkRequest);
            }
        }
        if (networkRequestList2.size() > 0) {
            this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$$ExternalSyntheticLambda16(this, networkRequestList2));
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onAttachNetworkRequests$0(DataNetworkController.NetworkRequestList networkRequestList) {
        this.mDataNetworkCallback.onAttachFailed(this, networkRequestList);
    }

    /* access modifiers changed from: protected */
    public void onDetachNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        this.mAttachedNetworkRequestList.remove(telephonyNetworkRequest);
        telephonyNetworkRequest.setState(0);
        telephonyNetworkRequest.setAttachedNetwork((DataNetwork) null);
        if (this.mAttachedNetworkRequestList.isEmpty()) {
            log("All network requests are detached.");
            lambda$tearDownWhenConditionMet$7(30);
        }
    }

    public void detachNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        if (getCurrentState() != null && !isDisconnected()) {
            sendMessage(obtainMessage(3, (Object) telephonyNetworkRequest));
        }
    }

    private void registerForBandwidthUpdate() {
        int bandwidthEstimateSource = this.mDataConfigManager.getBandwidthEstimateSource();
        if (bandwidthEstimateSource == 1) {
            this.mPhone.mCi.registerForLceInfo(getHandler(), 11, (Object) null);
        } else if (bandwidthEstimateSource != 3) {
            loge("Invalid bandwidth source configuration: " + bandwidthEstimateSource);
        } else if (this.mLinkBandwidthEstimatorCallback == null) {
            Handler handler = getHandler();
            Objects.requireNonNull(handler);
            this.mLinkBandwidthEstimatorCallback = new LinkBandwidthEstimator.LinkBandwidthEstimatorCallback(new ConcurrencyHelpers$$ExternalSyntheticLambda1(handler)) {
                public void onBandwidthChanged(int i, int i2) {
                    if (DataNetwork.this.isConnected()) {
                        DataNetwork.this.onBandwidthUpdated(i, i2);
                    }
                }
            };
            this.mPhone.getLinkBandwidthEstimator().registerCallback(this.mLinkBandwidthEstimatorCallback);
        }
    }

    private void unregisterForBandwidthUpdate() {
        int bandwidthEstimateSource = this.mDataConfigManager.getBandwidthEstimateSource();
        if (bandwidthEstimateSource == 1) {
            this.mPhone.mCi.unregisterForLceInfo(getHandler());
        } else if (bandwidthEstimateSource != 3) {
            loge("Invalid bandwidth source configuration: " + bandwidthEstimateSource);
        } else if (this.mLinkBandwidthEstimatorCallback != null) {
            this.mPhone.getLinkBandwidthEstimator().unregisterCallback(this.mLinkBandwidthEstimatorCallback);
            this.mLinkBandwidthEstimatorCallback = null;
        }
    }

    private void removeUnsatisfiedNetworkRequests() {
        Iterator it = this.mAttachedNetworkRequestList.iterator();
        while (it.hasNext()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
            if (!telephonyNetworkRequest.canBeSatisfiedBy(this.mNetworkCapabilities)) {
                log("removeUnsatisfiedNetworkRequests: " + telephonyNetworkRequest + " can't be satisfied anymore. Will be detached.");
                detachNetworkRequest(telephonyNetworkRequest);
            }
        }
    }

    private boolean isLinkPropertiesCompatible(LinkProperties linkProperties, LinkProperties linkProperties2) {
        if (!Objects.equals(linkProperties, linkProperties2) && !LinkPropertiesUtils.isIdenticalAddresses(linkProperties, linkProperties2)) {
            LinkPropertiesUtils.CompareOrUpdateResult compareOrUpdateResult = new LinkPropertiesUtils.CompareOrUpdateResult(linkProperties.getLinkAddresses(), linkProperties2.getLinkAddresses(), new DataNetwork$$ExternalSyntheticLambda4());
            log("isLinkPropertiesCompatible: old=" + linkProperties + " new=" + linkProperties2 + " result=" + compareOrUpdateResult);
            for (T t : compareOrUpdateResult.added) {
                Iterator<T> it = compareOrUpdateResult.removed.iterator();
                while (true) {
                    if (it.hasNext()) {
                        if (NetUtils.addressTypeMatches(((LinkAddress) it.next()).getAddress(), t.getAddress())) {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }

    private static boolean areImmutableCapabilitiesChanged(NetworkCapabilities networkCapabilities, NetworkCapabilities networkCapabilities2) {
        if (networkCapabilities == null || ArrayUtils.isEmpty(networkCapabilities.getCapabilities())) {
            return false;
        }
        List list = (List) Arrays.stream(networkCapabilities.getCapabilities()).boxed().collect(Collectors.toList());
        List<Integer> list2 = MUTABLE_CAPABILITIES;
        list.removeAll(list2);
        List list3 = (List) Arrays.stream(networkCapabilities2.getCapabilities()).boxed().collect(Collectors.toList());
        list3.removeAll(list2);
        if (list.size() != list3.size() || !list.containsAll(list3)) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public void updateNetworkCapabilities() {
        NetworkRegistrationInfo networkRegistrationInfo;
        NetworkCapabilities.Builder addTransportType = new NetworkCapabilities.Builder().addTransportType(0);
        boolean dataRoaming = this.mPhone.getServiceState().getDataRoaming();
        addTransportType.setNetworkSpecifier(new TelephonyNetworkSpecifier.Builder().setSubscriptionId(this.mSubId).build());
        addTransportType.setSubscriptionIds(Collections.singleton(Integer.valueOf(this.mSubId)));
        ApnSetting apnSetting = this.mDataProfile.getApnSetting();
        if (apnSetting != null) {
            apnSetting.getApnTypes().stream().map(new DataConfigManager$$ExternalSyntheticLambda14()).filter(new DataNetwork$$ExternalSyntheticLambda10()).forEach(new DataNetwork$$ExternalSyntheticLambda11(addTransportType));
            if (apnSetting.getApnTypes().contains(16384)) {
                addTransportType.addCapability(12);
            }
        }
        NetworkCapabilities networkCapabilities = this.mNetworkCapabilities;
        if (networkCapabilities != null && networkCapabilities.hasCapability(33)) {
            addTransportType.addCapability(33);
        } else if (this.mDataProfile.canSatisfy(4)) {
            addTransportType.addCapability(33);
            if (this.mTransport == 1 && (networkRegistrationInfo = getNetworkRegistrationInfo()) != null) {
                DataSpecificRegistrationInfo dataSpecificInfo = networkRegistrationInfo.getDataSpecificInfo();
                if (!(dataSpecificInfo == null || dataSpecificInfo.getVopsSupportInfo() == null || dataSpecificInfo.getVopsSupportInfo().isVopsSupported())) {
                    addTransportType.removeCapability(33);
                }
                log("updateNetworkCapabilities: dsri=" + dataSpecificInfo);
            }
        }
        for (TrafficDescriptor next : this.mTrafficDescriptors) {
            try {
                if (next.getOsAppId() != null) {
                    TrafficDescriptor.OsAppId osAppId = new TrafficDescriptor.OsAppId(next.getOsAppId());
                    if (!osAppId.getOsId().equals(TrafficDescriptor.OsAppId.ANDROID_OS_ID)) {
                        loge("Received non-Android OS id " + osAppId.getOsId());
                    } else {
                        int networkCapabilityFromString = DataUtils.getNetworkCapabilityFromString(osAppId.getAppId());
                        if (networkCapabilityFromString != 5) {
                            if (networkCapabilityFromString == 29) {
                                addTransportType.addCapability(networkCapabilityFromString);
                                addTransportType.addCapability(12);
                                addTransportType.addEnterpriseId(osAppId.getDifferentiator());
                            } else if (!(networkCapabilityFromString == 34 || networkCapabilityFromString == 35)) {
                                loge("Invalid app id " + osAppId.getAppId());
                            }
                        }
                        addTransportType.addCapability(networkCapabilityFromString);
                    }
                }
            } catch (Exception e) {
                loge("Exception: " + e + ". Failed to create osAppId from " + new BigInteger(1, next.getOsAppId()).toString(16));
            }
        }
        if (!this.mCongested) {
            addTransportType.addCapability(20);
        }
        if (this.mTempNotMeteredSupported && this.mTempNotMetered) {
            addTransportType.addCapability(25);
        }
        addTransportType.addCapability(28);
        VcnNetworkPolicyResult vcnPolicy = getVcnPolicy(addTransportType.build());
        if (vcnPolicy != null && !vcnPolicy.getNetworkCapabilities().hasCapability(28)) {
            addTransportType.removeCapability(28);
        }
        if (!dataRoaming) {
            addTransportType.addCapability(18);
        }
        if (!this.mSuspended) {
            addTransportType.addCapability(21);
        }
        int i = this.mCarrierServicePackageUid;
        if (i != -1 && ArrayUtils.contains(this.mAdministratorUids, i)) {
            addTransportType.setOwnerUid(this.mCarrierServicePackageUid);
            addTransportType.setAllowedUids(Collections.singleton(Integer.valueOf(this.mCarrierServicePackageUid)));
        }
        addTransportType.setAdministratorUids(this.mAdministratorUids);
        Set<Integer> set = (Set) this.mDataConfigManager.getMeteredNetworkCapabilities(dataRoaming).stream().filter(new DataNetwork$$ExternalSyntheticLambda12(this)).collect(Collectors.toSet());
        Stream stream = set.stream();
        Set set2 = (Set) Arrays.stream(addTransportType.build().getCapabilities()).boxed().collect(Collectors.toSet());
        Objects.requireNonNull(set2);
        if (stream.noneMatch(new DataNetwork$$ExternalSyntheticLambda13(set2))) {
            addTransportType.addCapability(11);
        }
        addTransportType.addCapability(13);
        if (!this.mDataNetworkController.getDataSettingsManager().isDataEnabled() || (this.mPhone.getServiceState().getDataRoaming() && !this.mDataNetworkController.getDataSettingsManager().isDataRoamingEnabled())) {
            DataEvaluation.DataAllowedReason dataAllowedReason = this.mDataAllowedReason;
            if (dataAllowedReason == DataEvaluation.DataAllowedReason.RESTRICTED_REQUEST) {
                addTransportType.removeCapability(13);
            } else if (dataAllowedReason == DataEvaluation.DataAllowedReason.UNMETERED_USAGE || dataAllowedReason == DataEvaluation.DataAllowedReason.MMS_REQUEST || dataAllowedReason == DataEvaluation.DataAllowedReason.EMERGENCY_SUPL) {
                for (Integer intValue : set) {
                    int intValue2 = intValue.intValue();
                    if (!((intValue2 == 0 && this.mDataAllowedReason == DataEvaluation.DataAllowedReason.MMS_REQUEST) || (intValue2 == 1 && this.mDataAllowedReason == DataEvaluation.DataAllowedReason.EMERGENCY_SUPL))) {
                        addTransportType.removeCapability(intValue2);
                    }
                }
            }
        }
        if (NetworkCapabilitiesUtils.inferRestrictedCapability(addTransportType.build()) || (vcnPolicy != null && !vcnPolicy.getNetworkCapabilities().hasCapability(13))) {
            addTransportType.removeCapability(13);
        }
        addTransportType.setLinkDownstreamBandwidthKbps(this.mNetworkBandwidth.downlinkBandwidthKbps);
        addTransportType.setLinkUpstreamBandwidthKbps(this.mNetworkBandwidth.uplinkBandwidthKbps);
        mtkUpdateNetworkCapabilities(addTransportType);
        NetworkCapabilities build = addTransportType.build();
        NetworkCapabilities networkCapabilities2 = this.mNetworkCapabilities;
        if (networkCapabilities2 == null || this.mNetworkAgent == null) {
            this.mNetworkCapabilities = build;
            logl("Initial capabilities " + this.mNetworkCapabilities);
        } else if (!build.equals(networkCapabilities2)) {
            if (!this.mEverConnected || !areImmutableCapabilitiesChanged(this.mNetworkCapabilities, build) || (!isConnected() && !isHandoverInProgress())) {
                this.mNetworkCapabilities = build;
                log("Capabilities changed to " + this.mNetworkCapabilities);
                this.mNetworkAgent.sendNetworkCapabilities(this.mNetworkCapabilities);
            } else {
                logl("updateNetworkCapabilities: Immutable capabilities changed. Re-create the network agent. Attempted to change from " + this.mNetworkCapabilities + " to " + build);
                this.mNetworkAgent.abandon();
                this.mNetworkCapabilities = build;
                TelephonyNetworkAgent createNetworkAgent = createNetworkAgent();
                this.mNetworkAgent = createNetworkAgent;
                createNetworkAgent.markConnected();
            }
            removeUnsatisfiedNetworkRequests();
            this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$$ExternalSyntheticLambda14(this));
        } else {
            log("updateNetworkCapabilities: Capabilities not changed.");
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$updateNetworkCapabilities$2(Integer num) {
        return num.intValue() >= 0;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$updateNetworkCapabilities$3(Integer num) {
        return this.mAccessNetworksManager.getPreferredTransportByNetworkCapability(num.intValue()) == 1;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateNetworkCapabilities$4() {
        this.mDataNetworkCallback.onNetworkCapabilitiesChanged(this);
    }

    public NetworkCapabilities getNetworkCapabilities() {
        return this.mNetworkCapabilities;
    }

    public LinkProperties getLinkProperties() {
        return this.mLinkProperties;
    }

    public DataProfile getDataProfile() {
        return this.mDataProfile;
    }

    /* access modifiers changed from: protected */
    public void updateSuspendState() {
        NetworkRegistrationInfo networkRegistrationInfo;
        if (!isConnecting() && !isDisconnected() && (networkRegistrationInfo = getNetworkRegistrationInfo()) != null) {
            boolean z = false;
            if (!this.mNetworkCapabilities.hasCapability(10) && (!(networkRegistrationInfo.getRegistrationState() == 1 || networkRegistrationInfo.getRegistrationState() == 5) || (!this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed() && this.mTransport == 1 && this.mPhone.getCallTracker().getState() != PhoneConstants.State.IDLE))) {
                z = true;
            }
            if (this.mSuspended != z) {
                this.mSuspended = z;
                StringBuilder sb = new StringBuilder();
                sb.append("Network becomes ");
                sb.append(this.mSuspended ? "suspended" : "unsuspended");
                logl(sb.toString());
                updateNetworkCapabilities();
                if (!this.mSuspended) {
                    this.mNetworkAgent.markConnected();
                }
                notifyPreciseDataConnectionState();
                this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$$ExternalSyntheticLambda17(this));
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateSuspendState$5() {
        this.mDataNetworkCallback.onSuspendedStateChanged(this, this.mSuspended);
    }

    /* access modifiers changed from: private */
    public void allocatePduSessionId() {
        this.mRil.allocatePduSessionId(obtainMessage(5));
    }

    /* access modifiers changed from: protected */
    public void setupData() {
        int dataNetworkType = getDataNetworkType();
        boolean dataRoamingFromRegistration = this.mPhone.getServiceState().getDataRoamingFromRegistration();
        boolean z = this.mPhone.getDataRoamingEnabled() || (dataRoamingFromRegistration && !this.mPhone.getServiceState().getDataRoaming());
        TrafficDescriptor trafficDescriptor = this.mDataProfile.getTrafficDescriptor();
        boolean z2 = trafficDescriptor == null || !TextUtils.isEmpty(trafficDescriptor.getDataNetworkName());
        int networkTypeToAccessNetworkType = DataUtils.networkTypeToAccessNetworkType(dataNetworkType);
        boolean z3 = z2;
        boolean z4 = z;
        this.mDataServiceManagers.get(this.mTransport).setupDataCall(networkTypeToAccessNetworkType, this.mDataProfile, dataRoamingFromRegistration, z, 1, (LinkProperties) null, this.mPduSessionId, (NetworkSliceInfo) null, trafficDescriptor, z3, obtainMessage(6));
        this.mDataCallSessionStats.onSetupDataCall(this.mDataProfile.getApnSetting() != null ? this.mDataProfile.getApnSetting().getApnTypeBitmask() : 0);
        logl("setupData: accessNetwork=" + AccessNetworkConstants.AccessNetworkType.toString(networkTypeToAccessNetworkType) + ", " + this.mDataProfile + ", isModemRoaming=" + dataRoamingFromRegistration + ", allowRoaming=" + z4 + ", PDU session id=" + this.mPduSessionId + ", matchAllRuleAllowed=" + z3);
        TelephonyMetrics.getInstance().writeSetupDataCall(this.mPhone.getPhoneId(), ServiceState.networkTypeToRilRadioTechnology(dataNetworkType), this.mDataProfile.getProfileId(), this.mDataProfile.getApn(), this.mDataProfile.getProtocolType());
    }

    /* access modifiers changed from: protected */
    public int getFailCauseFromDataCallResponse(int i, DataCallResponse dataCallResponse) {
        if (i != 0) {
            if (i == 1) {
                return 65546;
            }
            if (i == 2) {
                return 65538;
            }
            if (i != 3) {
                if (i == 4) {
                    return 65537;
                }
                if (i != 5) {
                    return 0;
                }
            }
            return 65545;
        } else if (dataCallResponse != null) {
            return DataFailCause.getFailCause(dataCallResponse.getCause());
        }
        return 0;
    }

    /* access modifiers changed from: protected */
    public void updateDataNetwork(DataCallResponse dataCallResponse) {
        this.mCid.put(this.mTransport, dataCallResponse.getId());
        LinkProperties linkProperties = new LinkProperties();
        linkProperties.setInterfaceName(dataCallResponse.getInterfaceName());
        if (this.mPduSessionId != dataCallResponse.getPduSessionId()) {
            this.mPduSessionId = dataCallResponse.getPduSessionId();
            log("PDU session id updated to " + this.mPduSessionId);
        }
        if (this.mLinkStatus != dataCallResponse.getLinkStatus()) {
            this.mLinkStatus = dataCallResponse.getLinkStatus();
            log("Link status updated to " + DataUtils.linkStatusToString(this.mLinkStatus));
            this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$$ExternalSyntheticLambda9(this));
        }
        if (dataCallResponse.getAddresses().size() > 0) {
            for (LinkAddress linkAddress : dataCallResponse.getAddresses()) {
                if (!linkAddress.getAddress().isAnyLocalAddress()) {
                    logv("addr/pl=" + linkAddress.getAddress() + "/" + linkAddress.getPrefixLength());
                    linkProperties.addLinkAddress(linkAddress);
                }
            }
        } else {
            loge("no address for ifname=" + dataCallResponse.getInterfaceName());
        }
        if (dataCallResponse.getDnsAddresses().size() > 0) {
            for (InetAddress inetAddress : dataCallResponse.getDnsAddresses()) {
                if (!inetAddress.isAnyLocalAddress()) {
                    linkProperties.addDnsServer(inetAddress);
                }
            }
        } else {
            loge("Empty dns response");
        }
        if (dataCallResponse.getPcscfAddresses().size() > 0) {
            for (InetAddress addPcscfServer : dataCallResponse.getPcscfAddresses()) {
                linkProperties.addPcscfServer(addPcscfServer);
            }
        }
        int mtuV4 = dataCallResponse.getMtuV4() > 0 ? dataCallResponse.getMtuV4() : dataCallResponse.getMtu();
        if (mtuV4 <= 0) {
            int mtkGetCustomizedMtu = mtkGetCustomizedMtu(this.mDataProfile.getApnSetting(), 0);
            if (mtkGetCustomizedMtu > 0) {
                mtuV4 = mtkGetCustomizedMtu;
            } else {
                if (this.mDataProfile.getApnSetting() != null) {
                    mtuV4 = this.mDataProfile.getApnSetting().getMtuV4();
                }
                if (mtuV4 <= 0) {
                    mtuV4 = this.mDataConfigManager.getDefaultMtu();
                }
            }
        }
        int mtuV6 = dataCallResponse.getMtuV6() > 0 ? dataCallResponse.getMtuV6() : dataCallResponse.getMtu();
        if (mtuV6 <= 0) {
            int mtkGetCustomizedMtu2 = mtkGetCustomizedMtu(this.mDataProfile.getApnSetting(), 1);
            if (mtkGetCustomizedMtu2 > 0) {
                mtuV6 = mtkGetCustomizedMtu2;
            } else {
                if (this.mDataProfile.getApnSetting() != null) {
                    mtuV6 = this.mDataProfile.getApnSetting().getMtuV6();
                }
                if (mtuV6 <= 0) {
                    mtuV6 = this.mDataConfigManager.getDefaultMtu();
                }
            }
        }
        for (InetAddress inetAddress2 : dataCallResponse.getGatewayAddresses()) {
            linkProperties.addRoute(new RouteInfo((IpPrefix) null, inetAddress2, (String) null, 1, inetAddress2 instanceof Inet6Address ? mtuV6 : mtuV4));
        }
        linkProperties.setMtu(Math.max(mtuV4, mtuV6));
        if (this.mDataProfile.getApnSetting() != null && !TextUtils.isEmpty(this.mDataProfile.getApnSetting().getProxyAddressAsString())) {
            int proxyPort = this.mDataProfile.getApnSetting().getProxyPort();
            if (proxyPort == -1) {
                proxyPort = 8080;
            }
            linkProperties.setHttpProxy(ProxyInfo.buildDirectProxy(this.mDataProfile.getApnSetting().getProxyAddressAsString(), proxyPort));
        }
        linkProperties.setTcpBufferSizes(this.mTcpBufferSizes);
        this.mNetworkSliceInfo = dataCallResponse.getSliceInfo();
        this.mTrafficDescriptors.clear();
        this.mTrafficDescriptors.addAll(dataCallResponse.getTrafficDescriptors());
        this.mQosBearerSessions.clear();
        this.mQosBearerSessions.addAll(dataCallResponse.getQosBearerSessions());
        QosCallbackTracker qosCallbackTracker = this.mQosCallbackTracker;
        if (qosCallbackTracker != null) {
            qosCallbackTracker.updateSessions(this.mQosBearerSessions);
        }
        if (!linkProperties.equals(this.mLinkProperties)) {
            if ((isConnected() || isHandoverInProgress()) && !isLinkPropertiesCompatible(linkProperties, this.mLinkProperties)) {
                logl("updateDataNetwork: Incompatible link properties detected. Re-create the network agent. Changed from " + this.mLinkProperties + " to " + linkProperties);
                this.mLinkProperties = linkProperties;
                this.mNetworkAgent.abandon();
                this.mLinkProperties = linkProperties;
                TelephonyNetworkAgent createNetworkAgent = createNetworkAgent();
                this.mNetworkAgent = createNetworkAgent;
                createNetworkAgent.markConnected();
            } else {
                this.mLinkProperties = linkProperties;
                log("sendLinkProperties " + this.mLinkProperties);
                this.mNetworkAgent.sendLinkProperties(this.mLinkProperties);
            }
        }
        updateNetworkCapabilities();
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateDataNetwork$6() {
        this.mDataNetworkCallback.onLinkStatusChanged(this, this.mLinkStatus);
    }

    /* access modifiers changed from: protected */
    public void onSetupResponse(int i, DataCallResponse dataCallResponse) {
        logl("onSetupResponse: resultCode=" + DataServiceCallback.resultCodeToString(i) + ", response=" + dataCallResponse);
        this.mFailCause = getFailCauseFromDataCallResponse(i, dataCallResponse);
        validateDataCallResponse(dataCallResponse);
        if (!mtkHandleSetupResponse(this.mFailCause, dataCallResponse)) {
            long j = -1;
            if (this.mFailCause != 0) {
                if (dataCallResponse != null) {
                    j = dataCallResponse.getRetryDurationMillis();
                }
                this.mRetryDelayMillis = j;
                transitionTo(this.mDisconnectedState);
            } else if (this.mDataNetworkController.isNetworkInterfaceExisting(dataCallResponse.getInterfaceName())) {
                logl("Interface " + dataCallResponse.getInterfaceName() + " already existing. Silently tear down now.");
                if (dataCallResponse.getTrafficDescriptors().isEmpty()) {
                    reportAnomaly("Duplicate network interface " + dataCallResponse.getInterfaceName() + " detected.", "62f66e7e-8d71-45de-a57b-dc5c78223fd5");
                }
                this.mRetryDelayMillis = -1;
                this.mFailCause = 65547;
                transitionTo(this.mDisconnectedState);
                return;
            } else {
                updateDataNetwork(dataCallResponse);
                if (this.mAttachedNetworkRequestList.size() == 0) {
                    log("Tear down the network since there is no live network request.");
                    onTearDown(5);
                    return;
                }
                VcnManager vcnManager = this.mVcnManager;
                if (vcnManager == null || !vcnManager.applyVcnNetworkPolicy(this.mNetworkCapabilities, this.mLinkProperties).isTeardownRequested()) {
                    transitionTo(this.mConnectedState);
                } else {
                    log("VCN service requested to tear down the network.");
                    onTearDown(15);
                    return;
                }
            }
            int i2 = 0;
            int i3 = -1;
            if (this.mDataProfile.getApnSetting() != null) {
                i2 = this.mDataProfile.getApnSetting().getApnTypeBitmask();
                i3 = this.mDataProfile.getApnSetting().getProtocol();
            }
            DataCallResponse dataCallResponse2 = dataCallResponse;
            this.mDataCallSessionStats.onSetupDataCallResponse(dataCallResponse2, getDataNetworkType(), i2, i3, this.mFailCause);
        }
    }

    private void validateDataCallResponse(DataCallResponse dataCallResponse) {
        if (dataCallResponse != null && dataCallResponse.getLinkStatus() != 0) {
            int cause = dataCallResponse.getCause();
            if (cause == 0) {
                if (TextUtils.isEmpty(dataCallResponse.getInterfaceName()) || dataCallResponse.getAddresses().isEmpty() || dataCallResponse.getLinkStatus() < -1 || dataCallResponse.getLinkStatus() > 2 || dataCallResponse.getProtocolType() < -1 || dataCallResponse.getProtocolType() > 5 || dataCallResponse.getHandoverFailureMode() < -1 || dataCallResponse.getHandoverFailureMode() > 3) {
                    loge("Invalid DataCallResponse:" + dataCallResponse);
                    reportAnomaly("Invalid DataCallResponse detected", "1f273e9d-b09c-46eb-ad1c-421d01f61164");
                }
            } else if (!DataFailCause.isFailCauseExisting(cause)) {
                loge("Invalid DataFailCause in " + dataCallResponse);
                reportAnomaly("Invalid DataFailCause: (0x" + Integer.toHexString(cause) + ")", "6b264f28-9f58-4cbd-9e0e-d7624ba30879");
            }
        }
    }

    /* access modifiers changed from: protected */
    public void onDeactivateResponse(int i) {
        logl("onDeactivateResponse: resultCode=" + DataServiceCallback.resultCodeToString(i));
        if (i == 4) {
            log("Remove network since deactivate request returned an error.");
            this.mFailCause = 65537;
            transitionTo(this.mDisconnectedState);
        } else if (this.mPhone.getHalVersion().less(RIL.RADIO_HAL_VERSION_2_0)) {
            log("Remove network on deactivate data response on old HAL " + this.mPhone.getHalVersion());
            this.mFailCause = InputDeviceCompat.SOURCE_TRACKBALL;
            transitionTo(this.mDisconnectedState);
        }
    }

    /* renamed from: tearDown */
    public void lambda$tearDownWhenConditionMet$7(@TearDownReason int i) {
        if (getCurrentState() != null && !isDisconnected()) {
            sendMessage(obtainMessage(7, i));
        }
    }

    /* access modifiers changed from: protected */
    public void onTearDown(@TearDownReason int i) {
        logl("onTearDown: reason=" + tearDownReasonToString(i));
        if (i == 1 && isConnected() && (this.mNetworkCapabilities.hasCapability(4) || this.mNetworkCapabilities.hasCapability(12))) {
            this.mDataNetworkCallback.onTrackNetworkUnwanted(this);
        }
        this.mDataServiceManagers.get(this.mTransport).deactivateDataCall(this.mCid.get(this.mTransport), i == 3 ? 2 : 1, obtainMessage(19));
        this.mDataCallSessionStats.setDeactivateDataCallReason(1);
        this.mInvokedDataDeactivation = true;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0008, code lost:
        r0 = r2.mNetworkCapabilities;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean shouldDelayImsTearDown() {
        /*
            r2 = this;
            com.android.internal.telephony.data.DataConfigManager r0 = r2.mDataConfigManager
            boolean r0 = r0.isImsDelayTearDownEnabled()
            if (r0 == 0) goto L_0x0030
            android.net.NetworkCapabilities r0 = r2.mNetworkCapabilities
            if (r0 == 0) goto L_0x0030
            r1 = 33
            boolean r0 = r0.hasCapability(r1)
            if (r0 == 0) goto L_0x0030
            com.android.internal.telephony.Phone r0 = r2.mPhone
            com.android.internal.telephony.Phone r0 = r0.getImsPhone()
            if (r0 == 0) goto L_0x0030
            com.android.internal.telephony.Phone r2 = r2.mPhone
            com.android.internal.telephony.Phone r2 = r2.getImsPhone()
            com.android.internal.telephony.CallTracker r2 = r2.getCallTracker()
            com.android.internal.telephony.PhoneConstants$State r2 = r2.getState()
            com.android.internal.telephony.PhoneConstants$State r0 = com.android.internal.telephony.PhoneConstants.State.IDLE
            if (r2 == r0) goto L_0x0030
            r2 = 1
            goto L_0x0031
        L_0x0030:
            r2 = 0
        L_0x0031:
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.DataNetwork.shouldDelayImsTearDown():boolean");
    }

    public Runnable tearDownWhenConditionMet(@TearDownReason int i, long j) {
        if (getCurrentState() == null || isDisconnected() || isDisconnecting()) {
            loge("tearDownWhenConditionMet: Not in the right state. State=" + getCurrentState());
            return null;
        }
        logl("tearDownWhenConditionMet: reason=" + tearDownReasonToString(i) + ", timeout=" + j + "ms.");
        sendMessage(21, i, (int) j);
        return new DataNetwork$$ExternalSyntheticLambda5(this, i);
    }

    /* access modifiers changed from: private */
    public void onDataStateChanged(int i, List<DataCallResponse> list) {
        logv("onDataStateChanged: " + list);
        int i2 = this.mTransport;
        if (i == i2 && this.mCid.get(i2) != -1 && !isDisconnected()) {
            DataCallResponse dataCallResponse = (DataCallResponse) list.stream().filter(new DataNetwork$$ExternalSyntheticLambda15(this)).findFirst().orElse((Object) null);
            int i3 = 65547;
            if (dataCallResponse == null) {
                this.mDataServiceManagers.get(this.mTransport).deactivateDataCall(this.mCid.get(this.mTransport), 1, (Message) null);
                log("onDataStateChanged: PDN disconnected reported by " + AccessNetworkConstants.transportTypeToString(this.mTransport) + " data service.");
                if (this.mEverConnected) {
                    i3 = InputDeviceCompat.SOURCE_TRACKBALL;
                }
                this.mFailCause = i3;
                this.mRetryDelayMillis = -1;
                transitionTo(this.mDisconnectedState);
            } else if (!dataCallResponse.equals(this.mDataCallResponse)) {
                log("onDataStateChanged: " + dataCallResponse);
                validateDataCallResponse(dataCallResponse);
                this.mDataCallResponse = dataCallResponse;
                if (dataCallResponse.getLinkStatus() != 0) {
                    updateDataNetwork(dataCallResponse);
                    return;
                }
                log("onDataStateChanged: PDN inactive reported by " + AccessNetworkConstants.transportTypeToString(this.mTransport) + " data service.");
                if (this.mEverConnected) {
                    i3 = dataCallResponse.getCause();
                }
                this.mFailCause = i3;
                this.mRetryDelayMillis = -1;
                transitionTo(this.mDisconnectedState);
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$onDataStateChanged$8(DataCallResponse dataCallResponse) {
        return this.mCid.get(this.mTransport) == dataCallResponse.getId();
    }

    /* access modifiers changed from: private */
    public void onDataConfigUpdated() {
        log("onDataConfigUpdated");
        updateBandwidthFromDataConfig();
        updateTcpBufferSizes();
        updateMeteredAndCongested();
    }

    /* access modifiers changed from: private */
    public void onBandwidthUpdatedFromModem(List<LinkCapacityEstimate> list) {
        Objects.requireNonNull(list);
        if (!list.isEmpty()) {
            Iterator<LinkCapacityEstimate> it = list.iterator();
            int i = 0;
            int i2 = 0;
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                LinkCapacityEstimate next = it.next();
                if (next.getType() == 2) {
                    i = next.getUplinkCapacityKbps();
                    i2 = next.getDownlinkCapacityKbps();
                    break;
                } else if (next.getType() == 0 || next.getType() == 1) {
                    i += next.getUplinkCapacityKbps();
                    i2 += next.getDownlinkCapacityKbps();
                } else {
                    loge("Invalid LinkCapacityEstimate type " + next.getType());
                }
            }
            onBandwidthUpdated(i, i2);
        }
    }

    /* access modifiers changed from: private */
    public void onBandwidthUpdated(int i, int i2) {
        log("onBandwidthUpdated: downlinkBandwidthKbps=" + i2 + ", uplinkBandwidthKbps=" + i);
        NetworkBandwidth bandwidthForNetworkType = this.mDataConfigManager.getBandwidthForNetworkType(this.mTelephonyDisplayInfo);
        if (i2 == -1 && bandwidthForNetworkType != null) {
            i2 = bandwidthForNetworkType.downlinkBandwidthKbps;
        }
        if (i == -1 && bandwidthForNetworkType != null) {
            i = bandwidthForNetworkType.uplinkBandwidthKbps;
        }
        this.mNetworkBandwidth = new NetworkBandwidth(i2, Math.min(i, i2));
        updateNetworkCapabilities();
    }

    /* access modifiers changed from: private */
    public void onDisplayInfoChanged() {
        this.mTelephonyDisplayInfo = this.mPhone.getDisplayInfoController().getTelephonyDisplayInfo();
        updateBandwidthFromDataConfig();
        updateTcpBufferSizes();
        updateMeteredAndCongested();
    }

    private void updateBandwidthFromDataConfig() {
        if (this.mDataConfigManager.getBandwidthEstimateSource() == 2) {
            log("updateBandwidthFromDataConfig");
            this.mNetworkBandwidth = this.mDataConfigManager.getBandwidthForNetworkType(this.mTelephonyDisplayInfo);
            updateNetworkCapabilities();
        }
    }

    private void updateTcpBufferSizes() {
        log("updateTcpBufferSizes");
        this.mTcpBufferSizes = this.mDataConfigManager.getTcpConfigString(this.mTelephonyDisplayInfo);
        LinkProperties linkProperties = new LinkProperties(this.mLinkProperties);
        linkProperties.setTcpBufferSizes(this.mTcpBufferSizes);
        if (!linkProperties.equals(this.mLinkProperties)) {
            this.mLinkProperties = linkProperties;
            log("sendLinkProperties " + this.mLinkProperties);
            this.mNetworkAgent.sendLinkProperties(this.mLinkProperties);
        }
    }

    /* access modifiers changed from: private */
    public void updateMeteredAndCongested() {
        boolean z;
        int networkType = this.mTelephonyDisplayInfo.getNetworkType();
        int overrideNetworkType = this.mTelephonyDisplayInfo.getOverrideNetworkType();
        boolean z2 = true;
        if (overrideNetworkType == 1 || overrideNetworkType == 2) {
            networkType = 19;
        } else if (overrideNetworkType == 3 || overrideNetworkType == 5) {
            networkType = 20;
        }
        log("updateMeteredAndCongested: networkType=" + TelephonyManager.getNetworkTypeName(networkType));
        boolean isTempNotMeteredSupportedByCarrier = this.mDataConfigManager.isTempNotMeteredSupportedByCarrier();
        boolean z3 = this.mTempNotMeteredSupported;
        boolean z4 = false;
        if (isTempNotMeteredSupportedByCarrier != z3) {
            this.mTempNotMeteredSupported = !z3;
            log("updateMeteredAndCongested: mTempNotMeteredSupported changed to " + this.mTempNotMeteredSupported);
            z = true;
        } else {
            z = false;
        }
        if (this.mDataNetworkController.getUnmeteredOverrideNetworkTypes().contains(Integer.valueOf(networkType)) || isNetworkTypeUnmetered(networkType)) {
            z4 = true;
        }
        boolean z5 = this.mTempNotMetered;
        if (z4 != z5) {
            this.mTempNotMetered = !z5;
            log("updateMeteredAndCongested: mTempNotMetered changed to " + this.mTempNotMetered);
            z = true;
        }
        boolean contains = this.mDataNetworkController.getCongestedOverrideNetworkTypes().contains(Integer.valueOf(networkType));
        boolean z6 = this.mCongested;
        if (contains != z6) {
            this.mCongested = !z6;
            log("updateMeteredAndCongested: mCongested changed to " + this.mCongested);
        } else {
            z2 = z;
        }
        if (z2) {
            updateNetworkCapabilities();
        }
    }

    private boolean isNetworkTypeUnmetered(int i) {
        List<SubscriptionPlan> subscriptionPlans = this.mDataNetworkController.getSubscriptionPlans();
        if (subscriptionPlans.isEmpty()) {
            return false;
        }
        Set set = (Set) Arrays.stream(TelephonyManager.getAllNetworkTypes()).boxed().collect(Collectors.toSet());
        boolean z = true;
        for (SubscriptionPlan next : subscriptionPlans) {
            if (((Set) Arrays.stream(next.getNetworkTypes()).boxed().collect(Collectors.toSet())).containsAll(set)) {
                if (next.getDataLimitBytes() != Long.MAX_VALUE) {
                    z = false;
                }
            } else if (i != 0) {
                int[] networkTypes = next.getNetworkTypes();
                int length = networkTypes.length;
                int i2 = 0;
                while (i2 < length) {
                    if (networkTypes[i2] != i) {
                        i2++;
                    } else if (next.getDataLimitBytes() == Long.MAX_VALUE) {
                        return true;
                    } else {
                        return false;
                    }
                }
                continue;
            } else {
                continue;
            }
        }
        return z;
    }

    public int getId() {
        return this.mCid.get(this.mTransport);
    }

    /* access modifiers changed from: private */
    public int getDataNetworkType() {
        return getDataNetworkType(this.mTransport);
    }

    /* access modifiers changed from: protected */
    public int getDataNetworkType(int i) {
        if (i == 2) {
            return 18;
        }
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceState().getNetworkRegistrationInfo(2, i);
        if (networkRegistrationInfo != null) {
            return networkRegistrationInfo.getAccessNetworkTechnology();
        }
        return 0;
    }

    public int getLinkStatus() {
        return this.mLinkStatus;
    }

    /* access modifiers changed from: private */
    public void updateNetworkScore() {
        int networkScore = getNetworkScore();
        if (networkScore != this.mNetworkScore) {
            logl("Updating score from " + this.mNetworkScore + " to " + networkScore);
            this.mNetworkScore = networkScore;
            this.mNetworkAgent.sendNetworkScore(networkScore);
        }
    }

    private int getNetworkScore() {
        Iterator it = this.mAttachedNetworkRequestList.iterator();
        int i = 45;
        while (it.hasNext()) {
            TelephonyNetworkRequest telephonyNetworkRequest = (TelephonyNetworkRequest) it.next();
            if (telephonyNetworkRequest.hasCapability(12) && telephonyNetworkRequest.getNetworkSpecifier() == null) {
                i = 50;
            }
        }
        return i;
    }

    private NetworkRegistrationInfo getNetworkRegistrationInfo() {
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceStateTracker().getServiceState().getNetworkRegistrationInfo(2, this.mTransport);
        if (networkRegistrationInfo != null) {
            return networkRegistrationInfo;
        }
        loge("Can't get network registration info for " + AccessNetworkConstants.transportTypeToString(this.mTransport));
        return null;
    }

    public int getApnTypeNetworkCapability() {
        if (!this.mAttachedNetworkRequestList.isEmpty()) {
            return ((TelephonyNetworkRequest) this.mAttachedNetworkRequestList.get(0)).getApnTypeNetworkCapability();
        }
        Stream<Integer> filter = Arrays.stream(getNetworkCapabilities().getCapabilities()).boxed().filter(new DataNetwork$$ExternalSyntheticLambda7());
        DataConfigManager dataConfigManager = this.mDataConfigManager;
        Objects.requireNonNull(dataConfigManager);
        return filter.max(Comparator.comparingInt(new DataNetwork$$ExternalSyntheticLambda8(dataConfigManager))).orElse(-1).intValue();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getApnTypeNetworkCapability$9(Integer num) {
        return DataUtils.networkCapabilityToApnType(num.intValue()) != 0;
    }

    public int getPriority() {
        if (!this.mAttachedNetworkRequestList.isEmpty()) {
            return ((TelephonyNetworkRequest) this.mAttachedNetworkRequestList.get(0)).getPriority();
        }
        Stream<Integer> boxed = Arrays.stream(getNetworkCapabilities().getCapabilities()).boxed();
        DataConfigManager dataConfigManager = this.mDataConfigManager;
        Objects.requireNonNull(dataConfigManager);
        return ((Integer) boxed.map(new DataNetwork$$ExternalSyntheticLambda2(dataConfigManager)).max(new DataNetwork$$ExternalSyntheticLambda3()).orElse(0)).intValue();
    }

    public DataNetworkController.NetworkRequestList getAttachedNetworkRequestList() {
        return this.mAttachedNetworkRequestList;
    }

    public boolean isConnecting() {
        return getCurrentState() == this.mConnectingState;
    }

    public boolean isConnected() {
        return getCurrentState() == this.mConnectedState;
    }

    public boolean isDisconnecting() {
        return getCurrentState() == this.mDisconnectingState;
    }

    public boolean isDisconnected() {
        return getCurrentState() == this.mDisconnectedState;
    }

    public boolean isHandoverInProgress() {
        return getCurrentState() == this.mHandoverState;
    }

    public boolean isSuspended() {
        return getState() == 3;
    }

    public int getTransport() {
        return this.mTransport;
    }

    private int getState() {
        if (getCurrentState() == null || isDisconnected()) {
            return 0;
        }
        if (isConnecting()) {
            return 1;
        }
        if (isConnected()) {
            return this.mSuspended ? 3 : 2;
        }
        if (isDisconnecting()) {
            return 4;
        }
        return isHandoverInProgress() ? 5 : -1;
    }

    public boolean isInternetSupported() {
        return this.mNetworkCapabilities.hasCapability(12) && this.mNetworkCapabilities.hasCapability(13) && this.mNetworkCapabilities.hasCapability(14) && this.mNetworkCapabilities.hasCapability(28) && this.mNetworkCapabilities.hasCapability(15);
    }

    public boolean isEmergencySupl() {
        return this.mDataAllowedReason == DataEvaluation.DataAllowedReason.EMERGENCY_SUPL;
    }

    private PreciseDataConnectionState getPreciseDataConnectionState() {
        return new PreciseDataConnectionState.Builder().setTransportType(this.mTransport).setId(this.mCid.get(this.mTransport)).setState(getState()).setApnSetting(this.mDataProfile.getApnSetting()).setLinkProperties(this.mLinkProperties).setNetworkType(getDataNetworkType()).setFailCause(this.mFailCause).build();
    }

    /* access modifiers changed from: protected */
    public void notifyPreciseDataConnectionState() {
        PreciseDataConnectionState preciseDataConnectionState = getPreciseDataConnectionState();
        logv("notifyPreciseDataConnectionState=" + preciseDataConnectionState);
        this.mPhone.notifyDataConnection(preciseDataConnectionState);
    }

    public boolean startHandover(int i, DataRetryManager.DataHandoverRetryEntry dataHandoverRetryEntry) {
        if (getCurrentState() == null || isDisconnected() || isDisconnecting()) {
            if (dataHandoverRetryEntry != null) {
                dataHandoverRetryEntry.setState(4);
            }
            return false;
        }
        sendMessage(obtainMessage(14, i, 0, dataHandoverRetryEntry));
        return true;
    }

    /* access modifiers changed from: private */
    public void onStartHandover(int i, DataRetryManager.DataHandoverRetryEntry dataHandoverRetryEntry) {
        DataProfile dataProfileForNetworkRequest;
        if (this.mTransport == i) {
            log("onStartHandover: The network is already on " + AccessNetworkConstants.transportTypeToString(this.mTransport) + ", handover is not needed.");
            if (dataHandoverRetryEntry != null) {
                dataHandoverRetryEntry.setState(4);
                return;
            }
            return;
        }
        boolean dataRoamingFromRegistration = this.mPhone.getServiceState().getDataRoamingFromRegistration();
        boolean z = this.mPhone.getDataRoamingEnabled() || (dataRoamingFromRegistration && !this.mPhone.getServiceState().getDataRoaming());
        this.mHandoverDataProfile = this.mDataProfile;
        int dataNetworkType = getDataNetworkType(i);
        if (!(dataNetworkType == 0 || this.mAttachedNetworkRequestList.isEmpty() || (dataProfileForNetworkRequest = this.mDataNetworkController.getDataProfileManager().getDataProfileForNetworkRequest((TelephonyNetworkRequest) this.mAttachedNetworkRequestList.get(0), dataNetworkType)) == null || dataProfileForNetworkRequest.getApnSetting() == null || this.mDataProfile.getApnSetting() == null || !TextUtils.equals(dataProfileForNetworkRequest.getApnSetting().getApnName(), this.mDataProfile.getApnSetting().getApnName()) || dataProfileForNetworkRequest.equals(this.mDataProfile))) {
            this.mHandoverDataProfile = dataProfileForNetworkRequest;
            log("Used different data profile for handover. " + this.mDataProfile);
        }
        logl("Start handover from " + AccessNetworkConstants.transportTypeToString(this.mTransport) + " to " + AccessNetworkConstants.transportTypeToString(i));
        int networkTypeToAccessNetworkType = DataUtils.networkTypeToAccessNetworkType(getDataNetworkType(i));
        DataProfile dataProfile = this.mHandoverDataProfile;
        this.mDataServiceManagers.get(i).setupDataCall(networkTypeToAccessNetworkType, dataProfile, dataRoamingFromRegistration, z, 3, this.mLinkProperties, this.mPduSessionId, this.mNetworkSliceInfo, dataProfile.getTrafficDescriptor(), true, obtainMessage(15, (Object) dataHandoverRetryEntry));
        transitionTo(this.mHandoverState);
    }

    /* access modifiers changed from: private */
    public void onHandoverResponse(int i, DataCallResponse dataCallResponse, DataRetryManager.DataHandoverRetryEntry dataHandoverRetryEntry) {
        logl("onHandoverResponse: resultCode=" + DataServiceCallback.resultCodeToString(i) + ", response=" + dataCallResponse);
        this.mFailCause = getFailCauseFromDataCallResponse(i, dataCallResponse);
        validateDataCallResponse(dataCallResponse);
        if (this.mFailCause == 0) {
            this.mDataServiceManagers.get(this.mTransport).deactivateDataCall(this.mCid.get(this.mTransport), 3, (Message) null);
            this.mTransport = DataUtils.getTargetTransport(this.mTransport);
            StringBuilder sb = new StringBuilder();
            sb.append("DN-");
            sb.append(this.mInitialNetworkAgentId);
            sb.append("-");
            sb.append(this.mTransport == 1 ? "C" : "I");
            this.mLogTag = sb.toString();
            this.mDataProfile = this.mHandoverDataProfile;
            updateDataNetwork(dataCallResponse);
            if (this.mTransport != 1) {
                this.mPcoData.clear();
                unregisterForWwanEvents();
            } else {
                registerForWwanEvents();
            }
            if (dataHandoverRetryEntry != null) {
                dataHandoverRetryEntry.setState(3);
            }
            this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$$ExternalSyntheticLambda0(this));
        } else {
            long retryDurationMillis = dataCallResponse != null ? dataCallResponse.getRetryDurationMillis() : -1;
            int handoverFailureMode = dataCallResponse != null ? dataCallResponse.getHandoverFailureMode() : 0;
            if (dataHandoverRetryEntry != null) {
                dataHandoverRetryEntry.setState(2);
            }
            this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$$ExternalSyntheticLambda1(this, retryDurationMillis, handoverFailureMode));
            this.mDataCallSessionStats.onHandoverFailure(this.mFailCause);
        }
        transitionTo(this.mConnectedState);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onHandoverResponse$10() {
        this.mDataNetworkCallback.onHandoverSucceeded(this);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onHandoverResponse$11(long j, int i) {
        this.mDataNetworkCallback.onHandoverFailed(this, this.mFailCause, j, i);
    }

    /* access modifiers changed from: private */
    public void onPcoDataReceived(PcoData pcoData) {
        if (pcoData.cid == getId() && !Objects.equals(this.mPcoData.put(Integer.valueOf(pcoData.pcoId), pcoData), pcoData)) {
            log("onPcoDataReceived: " + pcoData);
            this.mDataNetworkCallback.invokeFromExecutor(new DataNetwork$$ExternalSyntheticLambda6(this));
            if (this.mDataProfile.getApnSetting() != null) {
                for (Integer intValue : this.mDataProfile.getApnSetting().getApnTypes()) {
                    int intValue2 = intValue.intValue();
                    Intent intent = new Intent("android.telephony.action.CARRIER_SIGNAL_PCO_VALUE");
                    intent.putExtra("android.telephony.extra.APN_TYPE", intValue2);
                    intent.putExtra("android.telephony.extra.APN_PROTOCOL", ApnSetting.getProtocolIntFromString(pcoData.bearerProto));
                    intent.putExtra("android.telephony.extra.PCO_ID", pcoData.pcoId);
                    intent.putExtra("android.telephony.extra.PCO_VALUE", pcoData.contents);
                    this.mPhone.getCarrierSignalAgent().notifyCarrierSignalReceivers(intent);
                }
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$onPcoDataReceived$12() {
        this.mDataNetworkCallback.onPcoDataChanged(this);
    }

    public Map<Integer, PcoData> getPcoData() {
        return this.mPcoData;
    }

    private VcnNetworkPolicyResult getVcnPolicy(NetworkCapabilities networkCapabilities) {
        VcnManager vcnManager = this.mVcnManager;
        if (vcnManager == null) {
            return null;
        }
        return vcnManager.applyVcnNetworkPolicy(networkCapabilities, getLinkProperties());
    }

    public static String tearDownReasonToString(@TearDownReason int i) {
        switch (i) {
            case 1:
                return "CONNECTIVITY_SERVICE_UNWANTED";
            case 2:
                return "SIM_REMOVAL";
            case 3:
                return "AIRPLANE_MODE_ON";
            case 4:
                return "DATA_DISABLED";
            case 5:
                return "TEAR_DOWN_REASON_NO_LIVE_REQUEST";
            case 6:
                return "TEAR_DOWN_REASON_RAT_NOT_ALLOWED";
            case 7:
                return "TEAR_DOWN_REASON_ROAMING_DISABLED";
            case 8:
                return "TEAR_DOWN_REASON_CONCURRENT_VOICE_DATA_NOT_ALLOWED";
            case 10:
                return "TEAR_DOWN_REASON_DATA_SERVICE_NOT_READY";
            case 11:
                return "TEAR_DOWN_REASON_POWER_OFF_BY_CARRIER";
            case 12:
                return "TEAR_DOWN_REASON_DATA_STALL";
            case 13:
                return "TEAR_DOWN_REASON_HANDOVER_FAILED";
            case 14:
                return "TEAR_DOWN_REASON_HANDOVER_NOT_ALLOWED";
            case 15:
                return "TEAR_DOWN_REASON_VCN_REQUESTED";
            case 16:
                return "TEAR_DOWN_REASON_VOPS_NOT_SUPPORTED";
            case 17:
                return "TEAR_DOWN_REASON_DEFAULT_DATA_UNSELECTED";
            case 18:
                return "TEAR_DOWN_REASON_NOT_IN_SERVICE";
            case 19:
                return "TEAR_DOWN_REASON_DATA_CONFIG_NOT_READY";
            case 20:
                return "TEAR_DOWN_REASON_PENDING_TEAR_DOWN_ALL";
            case 21:
                return "TEAR_DOWN_REASON_NO_SUITABLE_DATA_PROFILE";
            case 22:
                return "TEAR_DOWN_REASON_CDMA_EMERGENCY_CALLBACK_MODE";
            case 23:
                return "TEAR_DOWN_REASON_RETRY_SCHEDULED";
            case 24:
                return "TEAR_DOWN_REASON_DATA_THROTTLED";
            case 25:
                return "TEAR_DOWN_REASON_DATA_PROFILE_INVALID";
            case 26:
                return "TEAR_DOWN_REASON_DATA_PROFILE_NOT_PREFERRED";
            case 27:
                return "TEAR_DOWN_REASON_NOT_ALLOWED_BY_POLICY";
            case 28:
                return "TEAR_DOWN_REASON_ILLEGAL_STATE";
            case 29:
                return "TEAR_DOWN_REASON_ONLY_ALLOWED_SINGLE_NETWORK";
            case 30:
                return "TEAR_DOWN_REASON_PREFERRED_DATA_SWITCHED";
            default:
                return "UNKNOWN(" + i + ")";
        }
    }

    protected static String eventToString(int i) {
        switch (i) {
            case 1:
                return "EVENT_DATA_CONFIG_UPDATED";
            case 2:
                return "EVENT_ATTACH_NETWORK_REQUEST";
            case 3:
                return "EVENT_DETACH_NETWORK_REQUEST";
            case 5:
                return "EVENT_ALLOCATE_PDU_SESSION_ID_RESPONSE";
            case 6:
                return "EVENT_SETUP_DATA_NETWORK_RESPONSE";
            case 7:
                return "EVENT_TEAR_DOWN_NETWORK";
            case 8:
                return "EVENT_DATA_STATE_CHANGED";
            case 9:
                return "EVENT_DATA_NETWORK_TYPE_REG_STATE_CHANGED";
            case 10:
                return "EVENT_DETACH_ALL_NETWORK_REQUESTS";
            case 11:
                return "EVENT_BANDWIDTH_ESTIMATE_FROM_MODEM_CHANGED";
            case 13:
                return "EVENT_DISPLAY_INFO_CHANGED";
            case 14:
                return "EVENT_START_HANDOVER";
            case 15:
                return "EVENT_HANDOVER_RESPONSE";
            case 16:
                return "EVENT_SUBSCRIPTION_PLAN_OVERRIDE";
            case 17:
                return "EVENT_PCO_DATA_RECEIVED";
            case 18:
                return "EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED";
            case 19:
                return "EVENT_DEACTIVATE_DATA_NETWORK_RESPONSE";
            case 20:
                return "EVENT_STUCK_IN_TRANSIENT_STATE";
            case 21:
                return "EVENT_WAITING_FOR_TEARING_DOWN_CONDITION_MET";
            case 22:
                return "EVENT_VOICE_CALL_STARTED";
            case 23:
                return "EVENT_VOICE_CALL_ENDED";
            case 24:
                return "EVENT_CSS_INDICATOR_CHANGED";
            default:
                return "Unknown(" + i + ")";
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("[DataNetwork: ");
        sb.append(this.mLogTag);
        sb.append(", ");
        String str = null;
        sb.append(this.mDataProfile.getApnSetting() != null ? this.mDataProfile.getApnSetting().getApnName() : null);
        sb.append(", state=");
        if (getCurrentState() != null) {
            str = getCurrentState().getName();
        }
        sb.append(str);
        sb.append("]");
        return sb.toString();
    }

    public String name() {
        return this.mLogTag;
    }

    /* access modifiers changed from: private */
    public void reportAnomaly(String str, String str2) {
        logl(str);
        AnomalyReporter.reportAnomaly(UUID.fromString(str2), str, this.mPhone.getCarrierId());
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        String str2;
        String str3 = this.mLogTag;
        StringBuilder sb = new StringBuilder();
        if (getCurrentState() != null) {
            str2 = getCurrentState().getName() + ": ";
        } else {
            str2 = "";
        }
        sb.append(str2);
        sb.append(str);
        Rlog.d(str3, sb.toString());
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        String str2;
        String str3 = this.mLogTag;
        StringBuilder sb = new StringBuilder();
        if (getCurrentState() != null) {
            str2 = getCurrentState().getName() + ": ";
        } else {
            str2 = "";
        }
        sb.append(str2);
        sb.append(str);
        Rlog.e(str3, sb.toString());
    }

    /* access modifiers changed from: protected */
    public void logl(String str) {
        String str2;
        log(str);
        LocalLog localLog = this.mLocalLog;
        StringBuilder sb = new StringBuilder();
        if (getCurrentState() != null) {
            str2 = getCurrentState().getName() + ": ";
        } else {
            str2 = "";
        }
        sb.append(str2);
        sb.append(str);
        localLog.log(sb.toString());
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        super.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.println("Tag: " + name());
        androidUtilIndentingPrintWriter.increaseIndent();
        androidUtilIndentingPrintWriter.println("mSubId=" + this.mSubId);
        androidUtilIndentingPrintWriter.println("mTransport=" + AccessNetworkConstants.transportTypeToString(this.mTransport));
        androidUtilIndentingPrintWriter.println("WWAN cid=" + this.mCid.get(1));
        androidUtilIndentingPrintWriter.println("WLAN cid=" + this.mCid.get(2));
        androidUtilIndentingPrintWriter.println("mNetworkScore=" + this.mNetworkScore);
        androidUtilIndentingPrintWriter.println("mDataAllowedReason=" + this.mDataAllowedReason);
        androidUtilIndentingPrintWriter.println("mPduSessionId=" + this.mPduSessionId);
        androidUtilIndentingPrintWriter.println("mDataProfile=" + this.mDataProfile);
        androidUtilIndentingPrintWriter.println("mNetworkCapabilities=" + this.mNetworkCapabilities);
        androidUtilIndentingPrintWriter.println("mLinkProperties=" + this.mLinkProperties);
        androidUtilIndentingPrintWriter.println("mNetworkSliceInfo=" + this.mNetworkSliceInfo);
        androidUtilIndentingPrintWriter.println("mNetworkBandwidth=" + this.mNetworkBandwidth);
        androidUtilIndentingPrintWriter.println("mTcpBufferSizes=" + this.mTcpBufferSizes);
        androidUtilIndentingPrintWriter.println("mTelephonyDisplayInfo=" + this.mTelephonyDisplayInfo);
        androidUtilIndentingPrintWriter.println("mTempNotMeteredSupported=" + this.mTempNotMeteredSupported);
        androidUtilIndentingPrintWriter.println("mTempNotMetered=" + this.mTempNotMetered);
        androidUtilIndentingPrintWriter.println("mCongested=" + this.mCongested);
        androidUtilIndentingPrintWriter.println("mSuspended=" + this.mSuspended);
        androidUtilIndentingPrintWriter.println("mDataCallResponse=" + this.mDataCallResponse);
        androidUtilIndentingPrintWriter.println("mFailCause=" + DataFailCause.toString(this.mFailCause));
        androidUtilIndentingPrintWriter.println("mAdministratorUids=" + Arrays.toString(this.mAdministratorUids));
        androidUtilIndentingPrintWriter.println("mCarrierServicePackageUid=" + this.mCarrierServicePackageUid);
        androidUtilIndentingPrintWriter.println("mEverConnected=" + this.mEverConnected);
        androidUtilIndentingPrintWriter.println("mInvokedDataDeactivation=" + this.mInvokedDataDeactivation);
        androidUtilIndentingPrintWriter.println("Attached network requests:");
        androidUtilIndentingPrintWriter.increaseIndent();
        Iterator it = this.mAttachedNetworkRequestList.iterator();
        while (it.hasNext()) {
            androidUtilIndentingPrintWriter.println((TelephonyNetworkRequest) it.next());
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("mQosBearerSessions=" + this.mQosBearerSessions);
        this.mNetworkAgent.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("---------------");
    }
}
