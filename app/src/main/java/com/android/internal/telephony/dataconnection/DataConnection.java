package com.android.internal.telephony.dataconnection;

import android.app.PendingIntent;
import android.content.pm.PackageManager;
import android.content.pm.UserInfo;
import android.net.InetAddresses;
import android.net.IpPrefix;
import android.net.LinkAddress;
import android.net.LinkProperties;
import android.net.NetworkAgentConfig;
import android.net.NetworkCapabilities;
import android.net.NetworkProvider;
import android.net.NetworkRequest;
import android.net.ProxyInfo;
import android.net.RouteInfo;
import android.net.vcn.VcnManager;
import android.net.vcn.VcnNetworkPolicyResult;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.HandlerExecutor;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.os.UserManager;
import android.telephony.AccessNetworkConstants;
import android.telephony.CarrierConfigManager;
import android.telephony.DataFailCause;
import android.telephony.LinkCapacityEstimate;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.PreciseDataConnectionState;
import android.telephony.ServiceState;
import android.telephony.TelephonyManager;
import android.telephony.data.ApnSetting;
import android.telephony.data.DataCallResponse;
import android.telephony.data.DataProfile;
import android.telephony.data.DataServiceCallback;
import android.telephony.data.NetworkSliceInfo;
import android.telephony.data.Qos;
import android.telephony.data.QosBearerSession;
import android.telephony.data.TrafficDescriptor;
import android.text.TextUtils;
import android.util.Pair;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.AsyncChannel;
import com.android.internal.telephony.CarrierPrivilegesTracker;
import com.android.internal.telephony.HalVersion;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.RIL;
import com.android.internal.telephony.State;
import com.android.internal.telephony.StateMachine;
import com.android.internal.telephony.TelephonyStatsLog;
import com.android.internal.telephony.TimeUtils;
import com.android.internal.telephony.data.DataConfigManager;
import com.android.internal.telephony.data.TelephonyNetworkFactory;
import com.android.internal.telephony.metrics.DataCallSessionStats;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.telephony.Rlog;
import com.mediatek.custom.CustomProperties;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Consumer;

public class DataConnection extends StateMachine {
    static final int BASE = 262144;
    private static final int CMD_TO_STRING_COUNT = 40;
    private static final boolean DBG = true;
    private static final int DEFAULT_INTERNET_CONNECTION_SCORE = 50;
    static final int EVENT_ALLOCATE_PDU_SESSION_ID = 262181;
    static final int EVENT_BW_REFRESH_RESPONSE = 262158;
    static final int EVENT_CANCEL_HANDOVER = 262179;
    static final int EVENT_CARRIER_CONFIG_LINK_BANDWIDTHS_CHANGED = 262174;
    static final int EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED = 262175;
    static final int EVENT_CONNECT = 262144;
    static final int EVENT_CSS_INDICATOR_CHANGED = 262176;
    static final int EVENT_DATA_CONNECTION_CONGESTEDNESS_CHANGED = 262161;
    static final int EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED = 262155;
    static final int EVENT_DATA_CONNECTION_METEREDNESS_CHANGED = 262172;
    static final int EVENT_DATA_CONNECTION_ROAM_OFF = 262157;
    static final int EVENT_DATA_CONNECTION_ROAM_ON = 262156;
    static final int EVENT_DATA_CONNECTION_VOICE_CALL_ENDED = 262160;
    static final int EVENT_DATA_CONNECTION_VOICE_CALL_STARTED = 262159;
    static final int EVENT_DATA_STATE_CHANGED = 262151;
    static final int EVENT_DEACTIVATE_DONE = 262147;
    static final int EVENT_DISCONNECT = 262148;
    static final int EVENT_DISCONNECT_ALL = 262150;
    static final int EVENT_KEEPALIVE_STARTED = 262163;
    static final int EVENT_KEEPALIVE_START_REQUEST = 262165;
    static final int EVENT_KEEPALIVE_STATUS = 262162;
    static final int EVENT_KEEPALIVE_STOPPED = 262164;
    static final int EVENT_KEEPALIVE_STOP_REQUEST = 262166;
    static final int EVENT_LINK_BANDWIDTH_ESTIMATOR_UPDATE = 262183;
    static final int EVENT_LINK_CAPACITY_CHANGED = 262167;
    static final int EVENT_LOST_CONNECTION = 262153;
    static final int EVENT_NR_FREQUENCY_CHANGED = 262173;
    static final int EVENT_NR_STATE_CHANGED = 262171;
    static final int EVENT_REEVALUATE_DATA_CONNECTION_PROPERTIES = 262170;
    static final int EVENT_REEVALUATE_RESTRICTED_STATE = 262169;
    static final int EVENT_RELEASE_PDU_SESSION_ID = 262182;
    static final int EVENT_RESET = 262168;
    static final int EVENT_SETUP_DATA_CONNECTION_DONE = 262145;
    static final int EVENT_START_HANDOVER = 262178;
    static final int EVENT_START_HANDOVER_ON_TARGET = 262180;
    static final int EVENT_TEAR_DOWN_NOW = 262152;
    static final int EVENT_UPDATE_SUSPENDED_STATE = 262177;
    private static final int HANDOVER_STATE_BEING_TRANSFERRED = 2;
    private static final int HANDOVER_STATE_COMPLETED = 3;
    private static final int HANDOVER_STATE_IDLE = 1;
    private static final String NETWORK_TYPE = "MOBILE";
    private static final String NULL_IP = "0.0.0.0";
    private static final UUID OS_ID = UUID.fromString("97a498e3-fc92-5c94-8986-0333d06e4e47");
    private static final int OTHER_CONNECTION_SCORE = 45;
    private static final String RAT_NAME_5G = "nr";
    private static final String RAT_NAME_EVDO = "evdo";
    private static final String TCP_BUFFER_SIZES_1XRTT = "16384,32768,131072,4096,16384,102400";
    private static final String TCP_BUFFER_SIZES_EDGE = "4093,26280,70800,4096,16384,70800";
    private static final String TCP_BUFFER_SIZES_EHRPD = "131072,262144,1048576,4096,16384,524288";
    private static final String TCP_BUFFER_SIZES_EVDO = "4094,87380,262144,4096,16384,262144";
    private static final String TCP_BUFFER_SIZES_GPRS = "4092,8760,48000,4096,8760,48000";
    private static final String TCP_BUFFER_SIZES_HSDPA = "61167,367002,1101005,8738,52429,262114";
    private static final String TCP_BUFFER_SIZES_HSPA = "40778,244668,734003,16777,100663,301990";
    private static final String TCP_BUFFER_SIZES_HSPAP = "122334,734003,2202010,32040,192239,576717";
    private static final String TCP_BUFFER_SIZES_LTE = "524288,1048576,2097152,262144,524288,1048576";
    private static final String TCP_BUFFER_SIZES_LTE_CA = "4096,6291456,12582912,4096,1048576,2097152";
    private static final String TCP_BUFFER_SIZES_NR = "2097152,6291456,16777216,512000,2097152,8388608";
    private static final String TCP_BUFFER_SIZES_UMTS = "58254,349525,1048576,58254,349525,1048576";
    private static final boolean VDBG = true;
    private static AtomicInteger mInstanceNumber = new AtomicInteger(0);
    private static String[] sCmdToString;
    /* access modifiers changed from: private */
    public AsyncChannel mAc;
    /* access modifiers changed from: private */
    public DcActivatingState mActivatingState = new DcActivatingState();
    /* access modifiers changed from: private */
    public DcActiveState mActiveState = new DcActiveState();
    /* access modifiers changed from: private */
    public int[] mAdministratorUids = new int[0];
    /* access modifiers changed from: private */
    public final Map<ApnContext, ConnectionParams> mApnContexts = new ConcurrentHashMap();
    /* access modifiers changed from: private */
    public volatile ApnSetting mApnSetting;
    public int mCid;
    /* access modifiers changed from: private */
    public boolean mCongestedOverride;
    /* access modifiers changed from: private */
    public ConnectionParams mConnectionParams;
    private long mCreateTime;
    /* access modifiers changed from: private */
    public DataCallSessionStats mDataCallSessionStats;
    /* access modifiers changed from: private */
    public int mDataRegState = Integer.MAX_VALUE;
    /* access modifiers changed from: private */
    public DataServiceManager mDataServiceManager;
    /* access modifiers changed from: private */
    public DcController mDcController;
    /* access modifiers changed from: private */
    public int mDcFailCause;
    /* access modifiers changed from: private */
    public DcTesterFailBringUpAll mDcTesterFailBringUpAll;
    /* access modifiers changed from: private */
    public DcTracker mDct = null;
    private Qos mDefaultQos = null;
    private DcDefaultState mDefaultState = new DcDefaultState();
    /* access modifiers changed from: private */
    public int mDisabledApnTypeBitMask = 0;
    /* access modifiers changed from: private */
    public DisconnectParams mDisconnectParams;
    /* access modifiers changed from: private */
    public DcDisconnectionErrorCreatingConnection mDisconnectingErrorCreatingConnection = new DcDisconnectionErrorCreatingConnection();
    /* access modifiers changed from: private */
    public DcDisconnectingState mDisconnectingState = new DcDisconnectingState();
    private boolean mDoAllocatePduSessionId;
    private int mDownlinkBandwidth = 14;
    /* access modifiers changed from: private */
    public boolean mEnterpriseUse = false;
    /* access modifiers changed from: private */
    public int mHandoverFailureMode;
    /* access modifiers changed from: private */
    public final LocalLog mHandoverLocalLog = new LocalLog(64);
    /* access modifiers changed from: private */
    public DcNetworkAgent mHandoverSourceNetworkAgent;
    /* access modifiers changed from: private */
    public int mHandoverState = 1;
    /* access modifiers changed from: private */
    public int mId;
    /* access modifiers changed from: private */
    public DcInactiveState mInactiveState = new DcInactiveState();
    private boolean mIsSuspended;
    /* access modifiers changed from: private */
    public int mLastFailCause;
    private long mLastFailTime;
    /* access modifiers changed from: private */
    public LinkProperties mLinkProperties = new LinkProperties();
    /* access modifiers changed from: private */
    public boolean mMmsUseOnly = false;
    /* access modifiers changed from: private */
    public DcNetworkAgent mNetworkAgent;
    private String[] mPcscfAddr;
    private int mPduSessionId;
    /* access modifiers changed from: private */
    public Phone mPhone;
    private List<QosBearerSession> mQosBearerSessions = new ArrayList();
    PendingIntent mReconnectIntent = null;
    /* access modifiers changed from: private */
    public boolean mRestrictedNetworkOverride = false;
    /* access modifiers changed from: private */
    public int mRilRat = 0;
    /* access modifiers changed from: private */
    public int mScore;
    private NetworkSliceInfo mSliceInfo;
    /* access modifiers changed from: private */
    public int mSubId;
    int mTag;
    private final String mTagSuffix;
    private List<TrafficDescriptor> mTrafficDescriptors = new ArrayList();
    /* access modifiers changed from: private */
    public final int mTransportType;
    /* access modifiers changed from: private */
    public boolean mUnmeteredOverride;
    /* access modifiers changed from: private */
    public boolean mUnmeteredUseOnly = false;
    private int mUplinkBandwidth = 14;
    /* access modifiers changed from: private */
    public Object mUserData;
    /* access modifiers changed from: private */
    public VcnManager mVcnManager;
    /* access modifiers changed from: private */
    public final VcnManager.VcnNetworkPolicyChangeListener mVcnPolicyChangeListener = new DataConnectionVcnNetworkPolicyChangeListener();

    @Retention(RetentionPolicy.SOURCE)
    public @interface HandoverState {
    }

    private String handoverStateToString(int i) {
        return i != 1 ? i != 2 ? i != 3 ? "UNKNOWN" : "COMPLETED" : "BEING_TRANSFERRED" : "IDLE";
    }

    private static boolean isResultCodeSuccess(int i) {
        return i == 0 || i == 1;
    }

    static {
        String[] strArr = new String[40];
        sCmdToString = strArr;
        strArr[0] = "EVENT_CONNECT";
        strArr[1] = "EVENT_SETUP_DATA_CONNECTION_DONE";
        strArr[3] = "EVENT_DEACTIVATE_DONE";
        strArr[4] = "EVENT_DISCONNECT";
        strArr[6] = "EVENT_DISCONNECT_ALL";
        strArr[7] = "EVENT_DATA_STATE_CHANGED";
        strArr[8] = "EVENT_TEAR_DOWN_NOW";
        strArr[9] = "EVENT_LOST_CONNECTION";
        strArr[11] = "EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED";
        strArr[12] = "EVENT_DATA_CONNECTION_ROAM_ON";
        strArr[13] = "EVENT_DATA_CONNECTION_ROAM_OFF";
        strArr[14] = "EVENT_BW_REFRESH_RESPONSE";
        strArr[15] = "EVENT_DATA_CONNECTION_VOICE_CALL_STARTED";
        strArr[16] = "EVENT_DATA_CONNECTION_VOICE_CALL_ENDED";
        strArr[17] = "EVENT_DATA_CONNECTION_CONGESTEDNESS_CHANGED";
        strArr[18] = "EVENT_KEEPALIVE_STATUS";
        strArr[19] = "EVENT_KEEPALIVE_STARTED";
        strArr[20] = "EVENT_KEEPALIVE_STOPPED";
        strArr[21] = "EVENT_KEEPALIVE_START_REQUEST";
        strArr[22] = "EVENT_KEEPALIVE_STOP_REQUEST";
        strArr[23] = "EVENT_LINK_CAPACITY_CHANGED";
        strArr[24] = "EVENT_RESET";
        strArr[25] = "EVENT_REEVALUATE_RESTRICTED_STATE";
        strArr[26] = "EVENT_REEVALUATE_DATA_CONNECTION_PROPERTIES";
        strArr[27] = "EVENT_NR_STATE_CHANGED";
        strArr[28] = "EVENT_DATA_CONNECTION_METEREDNESS_CHANGED";
        strArr[29] = "EVENT_NR_FREQUENCY_CHANGED";
        strArr[30] = "EVENT_CARRIER_CONFIG_LINK_BANDWIDTHS_CHANGED";
        strArr[31] = "EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED";
        strArr[32] = "EVENT_CSS_INDICATOR_CHANGED";
        strArr[33] = "EVENT_UPDATE_SUSPENDED_STATE";
        strArr[34] = "EVENT_START_HANDOVER";
        strArr[35] = "EVENT_CANCEL_HANDOVER";
        strArr[36] = "EVENT_START_HANDOVER_ON_TARGET";
        strArr[37] = "EVENT_ALLOCATE_PDU_SESSION_ID";
        strArr[38] = "EVENT_RELEASE_PDU_SESSION_ID";
        strArr[39] = "EVENT_LINK_BANDWIDTH_ESTIMATOR_UPDATE";
    }

    public static class ConnectionParams {
        ApnContext mApnContext;
        final int mConnectionGeneration;
        final boolean mIsPreferredApn;
        Message mOnCompletedMsg;
        int mProfileId;
        final int mRequestType;
        int mRilRat;
        final int mSubId;
        int mTag;

        ConnectionParams(ApnContext apnContext, int i, int i2, Message message, int i3, int i4, int i5, boolean z) {
            this.mApnContext = apnContext;
            this.mProfileId = i;
            this.mRilRat = i2;
            this.mOnCompletedMsg = message;
            this.mConnectionGeneration = i3;
            this.mRequestType = i4;
            this.mSubId = i5;
            this.mIsPreferredApn = z;
        }

        public String toString() {
            return "{mTag=" + this.mTag + " mApnContext=" + this.mApnContext + " mProfileId=" + this.mProfileId + " mRat=" + this.mRilRat + " mOnCompletedMsg=" + DataConnection.msgToString(this.mOnCompletedMsg) + " mRequestType=" + DcTracker.requestTypeToString(this.mRequestType) + " mSubId=" + this.mSubId + " mIsPreferredApn=" + this.mIsPreferredApn + "}";
        }
    }

    public static class DisconnectParams {
        public ApnContext mApnContext;
        Message mOnCompletedMsg;
        String mReason;
        final int mReleaseType;
        int mTag;

        DisconnectParams(ApnContext apnContext, String str, int i, Message message) {
            this.mApnContext = apnContext;
            this.mReason = str;
            this.mReleaseType = i;
            this.mOnCompletedMsg = message;
        }

        public String toString() {
            return "{mTag=" + this.mTag + " mApnContext=" + this.mApnContext + " mReason=" + this.mReason + " mReleaseType=" + DcTracker.releaseTypeToString(this.mReleaseType) + " mOnCompletedMsg=" + DataConnection.msgToString(this.mOnCompletedMsg) + "}";
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:7:0x0010  */
    /* JADX WARNING: Removed duplicated region for block: B:9:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    static java.lang.String cmdToString(int r3) {
        /*
            r0 = 262144(0x40000, float:3.67342E-40)
            int r3 = r3 - r0
            if (r3 < 0) goto L_0x000d
            java.lang.String[] r1 = sCmdToString
            int r2 = r1.length
            if (r3 >= r2) goto L_0x000d
            r1 = r1[r3]
            goto L_0x000e
        L_0x000d:
            r1 = 0
        L_0x000e:
            if (r1 != 0) goto L_0x0026
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "0x"
            r1.append(r2)
            int r3 = r3 + r0
            java.lang.String r3 = java.lang.Integer.toHexString(r3)
            r1.append(r3)
            java.lang.String r1 = r1.toString()
        L_0x0026:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.cmdToString(int):java.lang.String");
    }

    public static DataConnection makeDataConnection(Phone phone, int i, DcTracker dcTracker, DataServiceManager dataServiceManager, DcTesterFailBringUpAll dcTesterFailBringUpAll, DcController dcController) {
        String str = dataServiceManager.getTransportType() == 1 ? "C" : "I";
        DataConnection dataConnection = new DataConnection(phone, str + "-" + mInstanceNumber.incrementAndGet(), i, dcTracker, dataServiceManager, dcTesterFailBringUpAll, dcController);
        dataConnection.start();
        dataConnection.log("Made " + dataConnection.getName());
        return dataConnection;
    }

    /* access modifiers changed from: package-private */
    public void dispose() {
        log("dispose: call quiteNow()");
        quitNow();
    }

    /* access modifiers changed from: package-private */
    public LinkProperties getLinkProperties() {
        return new LinkProperties(this.mLinkProperties);
    }

    /* access modifiers changed from: package-private */
    public boolean isDisconnecting() {
        return getCurrentState() == this.mDisconnectingState || getCurrentState() == this.mDisconnectingErrorCreatingConnection;
    }

    @VisibleForTesting
    public boolean isActive() {
        return getCurrentState() == this.mActiveState;
    }

    @VisibleForTesting
    public boolean isInactive() {
        return getCurrentState() == this.mInactiveState;
    }

    /* access modifiers changed from: package-private */
    public boolean isActivating() {
        return getCurrentState() == this.mActivatingState;
    }

    /* access modifiers changed from: package-private */
    public boolean hasBeenTransferred() {
        return this.mHandoverState == 3;
    }

    /* access modifiers changed from: package-private */
    public int getCid() {
        return this.mCid;
    }

    public ApnSetting getApnSetting() {
        return this.mApnSetting;
    }

    /* access modifiers changed from: private */
    public void updateLinkPropertiesHttpProxy() {
        if (this.mApnSetting != null && !TextUtils.isEmpty(this.mApnSetting.getProxyAddressAsString())) {
            try {
                int proxyPort = this.mApnSetting.getProxyPort();
                if (proxyPort == -1) {
                    proxyPort = 8080;
                }
                this.mLinkProperties.setHttpProxy(ProxyInfo.buildDirectProxy(this.mApnSetting.getProxyAddressAsString(), proxyPort));
            } catch (NumberFormatException e) {
                loge("onDataSetupComplete: NumberFormatException making ProxyProperties (" + this.mApnSetting.getProxyPort() + "): " + e);
            }
        }
    }

    public static class UpdateLinkPropertyResult {
        public LinkProperties newLp;
        public LinkProperties oldLp;
        public SetupResult setupResult = SetupResult.SUCCESS;

        public UpdateLinkPropertyResult(LinkProperties linkProperties) {
            this.oldLp = linkProperties;
            this.newLp = linkProperties;
        }
    }

    public enum SetupResult {
        SUCCESS,
        ERROR_RADIO_NOT_AVAILABLE,
        ERROR_INVALID_ARG,
        ERROR_STALE,
        ERROR_DATA_SERVICE_SPECIFIC_ERROR,
        ERROR_DUPLICATE_CID,
        ERROR_NO_DEFAULT_CONNECTION;
        
        public int mFailCause;

        public String toString() {
            return name() + "  SetupResult.mFailCause=" + DataFailCause.toString(this.mFailCause);
        }
    }

    public boolean isIpv4Connected() {
        for (InetAddress inetAddress : this.mLinkProperties.getAddresses()) {
            if (inetAddress instanceof Inet4Address) {
                Inet4Address inet4Address = (Inet4Address) inetAddress;
                if (!inet4Address.isAnyLocalAddress() && !inet4Address.isLinkLocalAddress() && !inet4Address.isLoopbackAddress() && !inet4Address.isMulticastAddress()) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isIpv6Connected() {
        for (InetAddress inetAddress : this.mLinkProperties.getAddresses()) {
            if (inetAddress instanceof Inet6Address) {
                Inet6Address inet6Address = (Inet6Address) inetAddress;
                if (!inet6Address.isAnyLocalAddress() && !inet6Address.isLinkLocalAddress() && !inet6Address.isLoopbackAddress() && !inet6Address.isMulticastAddress()) {
                    return true;
                }
            }
        }
        return false;
    }

    public int getPduSessionId() {
        return this.mPduSessionId;
    }

    public NetworkSliceInfo getSliceInfo() {
        return this.mSliceInfo;
    }

    public List<TrafficDescriptor> getTrafficDescriptors() {
        return this.mTrafficDescriptors;
    }

    public void updateResponseFields(DataCallResponse dataCallResponse) {
        updateQosParameters(dataCallResponse);
        updateSliceInfo(dataCallResponse);
        updateTrafficDescriptors(dataCallResponse);
    }

    public void updateQosParameters(DataCallResponse dataCallResponse) {
        if (dataCallResponse == null) {
            this.mDefaultQos = null;
            this.mQosBearerSessions.clear();
            return;
        }
        this.mDefaultQos = dataCallResponse.getDefaultQos();
        this.mQosBearerSessions = dataCallResponse.getQosBearerSessions();
        if (this.mNetworkAgent != null) {
            syncQosToNetworkAgent();
        }
    }

    /* access modifiers changed from: private */
    public void syncQosToNetworkAgent() {
        DcNetworkAgent dcNetworkAgent = this.mNetworkAgent;
        List<QosBearerSession> list = this.mQosBearerSessions;
        if (list == null) {
            dcNetworkAgent.updateQosBearerSessions(new ArrayList());
        } else {
            dcNetworkAgent.updateQosBearerSessions(list);
        }
    }

    public void updateSliceInfo(DataCallResponse dataCallResponse) {
        this.mSliceInfo = dataCallResponse.getSliceInfo();
    }

    public void updateTrafficDescriptors(DataCallResponse dataCallResponse) {
        this.mTrafficDescriptors = dataCallResponse.getTrafficDescriptors();
        this.mDcController.updateTrafficDescriptorsForCid(dataCallResponse.getId(), dataCallResponse.getTrafficDescriptors());
    }

    @VisibleForTesting
    public UpdateLinkPropertyResult updateLinkProperty(DataCallResponse dataCallResponse) {
        DcNetworkAgent dcNetworkAgent;
        UpdateLinkPropertyResult updateLinkPropertyResult = new UpdateLinkPropertyResult(this.mLinkProperties);
        if (dataCallResponse == null) {
            return updateLinkPropertyResult;
        }
        LinkProperties linkProperties = new LinkProperties();
        updateLinkPropertyResult.newLp = linkProperties;
        SetupResult linkProperties2 = setLinkProperties(dataCallResponse, linkProperties);
        updateLinkPropertyResult.setupResult = linkProperties2;
        if (linkProperties2 != SetupResult.SUCCESS) {
            log("updateLinkProperty failed : " + updateLinkPropertyResult.setupResult);
            return updateLinkPropertyResult;
        }
        updateLinkPropertyResult.newLp.setHttpProxy(this.mLinkProperties.getHttpProxy());
        checkSetMtu(this.mApnSetting, updateLinkPropertyResult.newLp);
        this.mLinkProperties = updateLinkPropertyResult.newLp;
        updateTcpBufferSizes(this.mRilRat);
        if (!updateLinkPropertyResult.oldLp.equals(updateLinkPropertyResult.newLp)) {
            log("updateLinkProperty old LP=" + updateLinkPropertyResult.oldLp);
            log("updateLinkProperty new LP=" + updateLinkPropertyResult.newLp);
        }
        if (!updateLinkPropertyResult.newLp.equals(updateLinkPropertyResult.oldLp) && (dcNetworkAgent = this.mNetworkAgent) != null) {
            dcNetworkAgent.sendLinkProperties(this.mLinkProperties, this);
        }
        return updateLinkPropertyResult;
    }

    @VisibleForTesting
    public void setPduSessionId(int i) {
        if (this.mPduSessionId != i) {
            logd("Changing pdu session id from: " + this.mPduSessionId + " to: " + i + ", Handover state: " + handoverStateToString(this.mHandoverState));
            this.mPduSessionId = i;
        }
    }

    private void checkSetMtu(ApnSetting apnSetting, LinkProperties linkProperties) {
        if (linkProperties != null && apnSetting != null) {
            if (linkProperties.getMtu() != 0) {
                log("MTU set by call response to: " + linkProperties.getMtu());
            } else if (apnSetting.getMtuV4() != 0) {
                linkProperties.setMtu(apnSetting.getMtuV4());
                log("MTU set by APN to: " + apnSetting.getMtuV4());
            } else {
                int integer = this.mPhone.getContext().getResources().getInteger(17694880);
                if (integer != 0) {
                    linkProperties.setMtu(integer);
                    log("MTU set by config resource to: " + integer);
                }
            }
        }
    }

    private DataConnection(Phone phone, String str, int i, DcTracker dcTracker, DataServiceManager dataServiceManager, DcTesterFailBringUpAll dcTesterFailBringUpAll, DcController dcController) {
        super("DC-" + str, (Handler) dcController);
        this.mTagSuffix = str;
        setLogRecSize(300);
        setLogOnlyTransitions(true);
        log("DataConnection created");
        this.mPhone = phone;
        this.mDct = dcTracker;
        this.mDataServiceManager = dataServiceManager;
        this.mVcnManager = (VcnManager) phone.getContext().getSystemService(VcnManager.class);
        this.mTransportType = dataServiceManager.getTransportType();
        this.mDcTesterFailBringUpAll = dcTesterFailBringUpAll;
        this.mDcController = dcController;
        this.mId = i;
        this.mCid = -1;
        this.mDataRegState = this.mPhone.getServiceState().getDataRegistrationState();
        this.mIsSuspended = false;
        this.mDataCallSessionStats = new DataCallSessionStats(this.mPhone);
        this.mDoAllocatePduSessionId = false;
        int networkTypeToRilRadioTechnology = ServiceState.networkTypeToRilRadioTechnology(getNetworkType());
        this.mRilRat = networkTypeToRilRadioTechnology;
        updateLinkBandwidthsFromCarrierConfig(networkTypeToRilRadioTechnology);
        addState(this.mDefaultState);
        addState(this.mInactiveState, this.mDefaultState);
        addState(this.mActivatingState, this.mDefaultState);
        addState(this.mActiveState, this.mDefaultState);
        addState(this.mDisconnectingState, this.mDefaultState);
        addState(this.mDisconnectingErrorCreatingConnection, this.mDefaultState);
        setInitialState(this.mInactiveState);
    }

    /* access modifiers changed from: private */
    public int getNetworkType() {
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceState().getNetworkRegistrationInfo(2, this.mTransportType);
        if (networkRegistrationInfo != null) {
            return networkRegistrationInfo.getAccessNetworkTechnology();
        }
        return 0;
    }

    /* access modifiers changed from: private */
    public int getHandoverSourceTransport() {
        return this.mTransportType == 1 ? 2 : 1;
    }

    @VisibleForTesting
    public static byte[] getEnterpriseOsAppId() {
        byte[] bytes = NetworkCapabilities.getCapabilityCarrierName(29).getBytes();
        ByteBuffer allocate = ByteBuffer.allocate(bytes.length + 17);
        UUID uuid = OS_ID;
        allocate.putLong(uuid.getMostSignificantBits());
        allocate.putLong(uuid.getLeastSignificantBits());
        allocate.put((byte) bytes.length);
        allocate.put(bytes);
        Rlog.d("DataConnection", "getEnterpriseOsAppId: " + IccUtils.bytesToHexString(allocate.array()));
        return allocate.array();
    }

    /* access modifiers changed from: private */
    public int connect(ConnectionParams connectionParams) {
        String str;
        byte[] bArr;
        ApnContext apnContext;
        String str2;
        ConnectionParams connectionParams2 = connectionParams;
        log("connect: carrier='" + this.mApnSetting.getEntryName() + "' APN='" + this.mApnSetting.getApnName() + "' proxy='" + this.mApnSetting.getProxyAddressAsString() + "' port='" + this.mApnSetting.getProxyPort() + "'");
        ApnContext.requestLog(connectionParams2.mApnContext, "DataConnection.connect");
        TrafficDescriptor trafficDescriptor = null;
        boolean z = true;
        if (this.mDcTesterFailBringUpAll.getDcFailBringUp().mCounter > 0) {
            DataCallResponse build = new DataCallResponse.Builder().setCause(this.mDcTesterFailBringUpAll.getDcFailBringUp().mFailCause).setRetryDurationMillis(this.mDcTesterFailBringUpAll.getDcFailBringUp().mSuggestedRetryTime).setMtuV4(0).setMtuV6(0).build();
            Message obtainMessage = obtainMessage((int) EVENT_SETUP_DATA_CONNECTION_DONE, (Object) connectionParams2);
            AsyncResult.forMessage(obtainMessage, build, (Throwable) null);
            sendMessage(obtainMessage);
            log("connect: FailBringUpAll=" + this.mDcTesterFailBringUpAll.getDcFailBringUp() + " send error response=" + build);
            DcFailBringUp dcFailBringUp = this.mDcTesterFailBringUpAll.getDcFailBringUp();
            dcFailBringUp.mCounter = dcFailBringUp.mCounter - 1;
            return 0;
        }
        this.mCreateTime = -1;
        this.mLastFailTime = -1;
        this.mLastFailCause = 0;
        Message obtainMessage2 = obtainMessage((int) EVENT_SETUP_DATA_CONNECTION_DONE, (Object) connectionParams2);
        obtainMessage2.obj = connectionParams2;
        DataProfile build2 = new DataProfile.Builder().setApnSetting(this.mApnSetting).setPreferred(connectionParams2.mIsPreferredApn).build();
        boolean dataRoamingFromRegistration = this.mPhone.getServiceState().getDataRoamingFromRegistration();
        boolean z2 = !ApnSettingUtils.isMeteredApnType(connectionParams2.mApnContext.getApnTypeBitmask(), this.mPhone);
        boolean z3 = this.mPhone.getDataRoamingEnabled() || (dataRoamingFromRegistration && (!this.mPhone.getServiceState().getDataRoaming() || z2));
        if (connectionParams2.mApnContext.getApnTypeBitmask() == 16384) {
            bArr = getEnterpriseOsAppId();
            str = null;
        } else {
            str = this.mApnSetting.getApnName();
            bArr = null;
        }
        if (!(bArr == null && str == null)) {
            trafficDescriptor = new TrafficDescriptor(str, bArr);
        }
        TrafficDescriptor trafficDescriptor2 = trafficDescriptor;
        boolean z4 = trafficDescriptor2 == null || trafficDescriptor2.getOsAppId() == null;
        log("allowRoaming=" + z3 + ", mPhone.getDataRoamingEnabled()=" + this.mPhone.getDataRoamingEnabled() + ", isModemRoaming=" + dataRoamingFromRegistration + ", mPhone.getServiceState().getDataRoaming()=" + this.mPhone.getServiceState().getDataRoaming() + ", isUnmeteredApnType=" + z2 + ", trafficDescriptor=" + trafficDescriptor2 + ", matchAllRuleAllowed=" + z4);
        if (connectionParams2.mRequestType == 2) {
            DcTracker dcTracker = this.mPhone.getDcTracker(getHandoverSourceTransport());
            if (dcTracker == null || (apnContext = connectionParams2.mApnContext) == null) {
                loge("connect: Handover failed. dcTracker=" + dcTracker + ", apnContext=" + connectionParams2.mApnContext);
                return 65542;
            }
            DataConnection dataConnectionByApnType = dcTracker.getDataConnectionByApnType(apnContext.getApnType());
            if (dataConnectionByApnType == null) {
                loge("connect: Can't find data connection for handover.");
                return 65542;
            }
            DataServiceManager dataServiceManager = dataConnectionByApnType.mDataServiceManager;
            if (dataServiceManager == null) {
                str2 = "(null)";
            } else {
                str2 = dataServiceManager.getTag();
            }
            logd("connect: REQUEST_TYPE_HANDOVER - Request handover from " + dataConnectionByApnType.getName() + ", targetDsm=" + this.mDataServiceManager.getTag() + ", sourceDsm=" + str2);
            dataConnectionByApnType.startHandover(new DataConnection$$ExternalSyntheticLambda7(this, dataConnectionByApnType, connectionParams, obtainMessage2, build2, dataRoamingFromRegistration, z3));
            return 0;
        }
        if (this.mTransportType != 2) {
            z = false;
        }
        this.mDoAllocatePduSessionId = z;
        allocatePduSessionId(new DataConnection$$ExternalSyntheticLambda8(this, connectionParams, build2, dataRoamingFromRegistration, z3, 1, (LinkProperties) null, trafficDescriptor2, z4, obtainMessage2));
        return 0;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$connect$1(DataConnection dataConnection, ConnectionParams connectionParams, Message message, DataProfile dataProfile, boolean z, boolean z2, Integer num) {
        sendRunnableMessage(EVENT_START_HANDOVER_ON_TARGET, new DataConnection$$ExternalSyntheticLambda9(this, dataConnection, num, connectionParams, message, dataProfile, z, z2));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$connect$0(DataConnection dataConnection, Integer num, ConnectionParams connectionParams, Message message, DataProfile dataProfile, boolean z, boolean z2, Boolean bool) {
        requestHandover(bool.booleanValue(), dataConnection, num.intValue(), connectionParams, message, dataProfile, z, z2);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$connect$2(ConnectionParams connectionParams, DataProfile dataProfile, boolean z, boolean z2, int i, LinkProperties linkProperties, TrafficDescriptor trafficDescriptor, boolean z3, Message message, Integer num) {
        ConnectionParams connectionParams2 = connectionParams;
        setPduSessionId(num.intValue());
        this.mDataServiceManager.setupDataCall(ServiceState.rilRadioTechnologyToAccessNetworkType(connectionParams2.mRilRat), dataProfile, z, z2, i, linkProperties, num.intValue(), (NetworkSliceInfo) null, trafficDescriptor, z3, message);
        TelephonyMetrics.getInstance().writeSetupDataCall(this.mPhone.getPhoneId(), connectionParams2.mRilRat, dataProfile.getProfileId(), dataProfile.getApn(), dataProfile.getProtocolType());
    }

    private void allocatePduSessionId(Consumer<Integer> consumer) {
        if (this.mDoAllocatePduSessionId) {
            Message obtainMessage = obtainMessage(EVENT_ALLOCATE_PDU_SESSION_ID);
            obtainMessage.obj = consumer;
            this.mPhone.mCi.allocatePduSessionId(obtainMessage);
            return;
        }
        consumer.accept(0);
    }

    private void onRquestHandoverFailed(ConnectionParams connectionParams) {
        sendMessage(obtainMessage(EVENT_CANCEL_HANDOVER));
        notifyConnectCompleted(connectionParams, 65536, -1, false);
    }

    private void requestHandover(boolean z, DataConnection dataConnection, int i, ConnectionParams connectionParams, Message message, DataProfile dataProfile, boolean z2, boolean z3) {
        TrafficDescriptor trafficDescriptor;
        DataConnection dataConnection2 = dataConnection;
        ConnectionParams connectionParams2 = connectionParams;
        if (!z) {
            logd("requestHandover: Not in correct state");
            if (isResultCodeSuccess(i)) {
                if (dataConnection2 != null) {
                    logd("requestHandover: Not in correct state - Success result code");
                    dataConnection.cancelHandover();
                } else {
                    logd("requestHandover: Not in correct state - Success result code - srcdc = null");
                }
            }
            onRquestHandoverFailed(connectionParams2);
        } else if (!isResultCodeSuccess(i)) {
            logd("requestHandover: Non success result code from DataService, setupDataCall will not be called, result code = " + DataServiceCallback.resultCodeToString(i));
            onRquestHandoverFailed(connectionParams2);
        } else if (dataConnection2 == null) {
            loge("requestHandover: Cannot find source data connection.");
            onRquestHandoverFailed(connectionParams2);
        } else {
            DcNetworkAgent networkAgent = dataConnection.getNetworkAgent();
            this.mHandoverSourceNetworkAgent = networkAgent;
            if (networkAgent == null) {
                loge("requestHandover: Cannot get network agent from the source dc " + dataConnection.getName());
                onRquestHandoverFailed(connectionParams2);
                return;
            }
            LinkProperties linkProperties = dataConnection.getLinkProperties();
            if (linkProperties == null || linkProperties.getLinkAddresses().isEmpty()) {
                loge("requestHandover: Can't find link properties of handover data connection. dc=" + dataConnection2);
                onRquestHandoverFailed(connectionParams2);
                return;
            }
            this.mHandoverLocalLog.log("Handover started. Preserved the agent.");
            log("Get the handover source network agent: " + this.mHandoverSourceNetworkAgent);
            if (dataProfile.getApn() == null) {
                trafficDescriptor = null;
            } else {
                trafficDescriptor = new TrafficDescriptor(dataProfile.getApn(), (byte[]) null);
            }
            this.mDataServiceManager.setupDataCall(ServiceState.rilRadioTechnologyToAccessNetworkType(connectionParams2.mRilRat), dataProfile, z2, z3, 3, linkProperties, dataConnection.getPduSessionId(), dataConnection.getSliceInfo(), trafficDescriptor, true, message);
            TelephonyMetrics.getInstance().writeSetupDataCall(this.mPhone.getPhoneId(), connectionParams2.mRilRat, dataProfile.getProfileId(), dataProfile.getApn(), dataProfile.getProtocolType());
        }
    }

    @VisibleForTesting
    public void startHandover(Consumer<Integer> consumer) {
        logd("startHandover: " + toStringSimple());
        setHandoverState(2);
        this.mDataServiceManager.startHandover(this.mCid, obtainMessage((int) EVENT_START_HANDOVER, (Object) new DataConnection$$ExternalSyntheticLambda1(this, consumer)));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$startHandover$3(Consumer consumer, Integer num) {
        onHandoverStarted(num.intValue(), consumer);
    }

    private void onHandoverStarted(int i, Consumer<Integer> consumer) {
        logd("onHandoverStarted: " + toStringSimple());
        if (!isResultCodeSuccess(i)) {
            setHandoverState(1);
        }
        consumer.accept(Integer.valueOf(i));
    }

    /* access modifiers changed from: private */
    public void cancelHandover() {
        if (this.mHandoverState != 2) {
            logd("cancelHandover: handover state is " + handoverStateToString(this.mHandoverState) + ", expecting HANDOVER_STATE_BEING_TRANSFERRED");
        }
        this.mDataServiceManager.cancelHandover(this.mCid, obtainMessage(EVENT_CANCEL_HANDOVER));
        setHandoverState(1);
    }

    public void onCongestednessChanged(boolean z) {
        sendMessage(obtainMessage((int) EVENT_DATA_CONNECTION_CONGESTEDNESS_CHANGED, (Object) Boolean.valueOf(z)));
    }

    public void onMeterednessChanged(boolean z) {
        sendMessage(obtainMessage((int) EVENT_DATA_CONNECTION_METEREDNESS_CHANGED, (Object) Boolean.valueOf(z)));
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Code restructure failed: missing block: B:9:0x0024, code lost:
        if (r2.mReleaseType == 3) goto L_0x002b;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void tearDownData(java.lang.Object r7) {
        /*
            r6 = this;
            r0 = 3
            r1 = 1
            if (r7 == 0) goto L_0x0029
            boolean r2 = r7 instanceof com.android.internal.telephony.dataconnection.DataConnection.DisconnectParams
            if (r2 == 0) goto L_0x0029
            r2 = r7
            com.android.internal.telephony.dataconnection.DataConnection$DisconnectParams r2 = (com.android.internal.telephony.dataconnection.DataConnection.DisconnectParams) r2
            com.android.internal.telephony.dataconnection.ApnContext r3 = r2.mApnContext
            java.lang.String r4 = r2.mReason
            java.lang.String r5 = "radioTurnedOff"
            boolean r4 = android.text.TextUtils.equals(r4, r5)
            if (r4 != 0) goto L_0x0027
            java.lang.String r4 = r2.mReason
            java.lang.String r5 = "pdpReset"
            boolean r4 = android.text.TextUtils.equals(r4, r5)
            if (r4 == 0) goto L_0x0022
            goto L_0x0027
        L_0x0022:
            int r2 = r2.mReleaseType
            if (r2 != r0) goto L_0x002a
            goto L_0x002b
        L_0x0027:
            r0 = 2
            goto L_0x002b
        L_0x0029:
            r3 = 0
        L_0x002a:
            r0 = r1
        L_0x002b:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "tearDownData. mCid="
            r1.append(r2)
            int r2 = r6.mCid
            r1.append(r2)
            java.lang.String r2 = ", reason="
            r1.append(r2)
            r1.append(r0)
            java.lang.String r1 = r1.toString()
            r6.log(r1)
            com.android.internal.telephony.dataconnection.ApnContext.requestLog(r3, r1)
            com.android.internal.telephony.dataconnection.DataConnection$$ExternalSyntheticLambda0 r1 = new com.android.internal.telephony.dataconnection.DataConnection$$ExternalSyntheticLambda0
            r1.<init>(r6, r0, r7)
            r6.releasePduSessionId(r1)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.tearDownData(java.lang.Object):void");
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$tearDownData$4(int i, Object obj) {
        setPduSessionId(0);
        this.mDataServiceManager.deactivateDataCall(this.mCid, i, obtainMessage(EVENT_DEACTIVATE_DONE, this.mTag, 0, obj));
        this.mDataCallSessionStats.setDeactivateDataCallReason(i);
    }

    private void releasePduSessionId(Runnable runnable) {
        if (this.mTransportType == 2 && this.mHandoverState == 1 && getPduSessionId() != 0) {
            Message obtainMessage = obtainMessage(EVENT_RELEASE_PDU_SESSION_ID);
            obtainMessage.obj = runnable;
            this.mPhone.mCi.releasePduSessionId(obtainMessage, getPduSessionId());
            return;
        }
        runnable.run();
    }

    /* access modifiers changed from: private */
    public void notifyAllWithEvent(ApnContext apnContext, int i, String str) {
        for (ConnectionParams next : this.mApnContexts.values()) {
            ApnContext apnContext2 = next.mApnContext;
            if (apnContext2 != apnContext) {
                if (str != null) {
                    apnContext2.setReason(str);
                }
                Message obtainMessage = this.mDct.obtainMessage(i, next.mRequestType, -1, new Pair(apnContext2, Integer.valueOf(next.mConnectionGeneration)));
                AsyncResult.forMessage(obtainMessage);
                obtainMessage.sendToTarget();
            }
        }
    }

    /* access modifiers changed from: private */
    public void notifyConnectCompleted(ConnectionParams connectionParams, int i, int i2, boolean z) {
        Message message;
        ApnContext apnContext = null;
        if (!(connectionParams == null || (message = connectionParams.mOnCompletedMsg) == null)) {
            connectionParams.mOnCompletedMsg = null;
            apnContext = connectionParams.mApnContext;
            long currentTimeMillis = System.currentTimeMillis();
            message.arg1 = connectionParams.mRequestType;
            message.arg2 = i2;
            if (i == 0) {
                this.mCreateTime = currentTimeMillis;
                AsyncResult.forMessage(message);
            } else {
                this.mLastFailCause = i;
                this.mLastFailTime = currentTimeMillis;
                if (i == 0) {
                    i = 65536;
                }
                AsyncResult.forMessage(message, Integer.valueOf(i), new Throwable(DataFailCause.toString(i)));
            }
            log("notifyConnectCompleted at " + currentTimeMillis + " cause=" + DataFailCause.toString(i) + " connectionCompletedMsg=" + msgToString(message));
            message.sendToTarget();
        }
        if (z) {
            log("Send to all. " + apnContext + " " + DataFailCause.toString(i));
            notifyAllWithEvent(apnContext, 270371, DataFailCause.toString(i));
        }
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v1, resolved type: java.lang.String} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v2, resolved type: java.lang.String} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v4, resolved type: java.lang.String} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v0, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v6, resolved type: com.android.internal.telephony.dataconnection.ApnContext} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v7, resolved type: com.android.internal.telephony.dataconnection.ApnContext} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v8, resolved type: com.android.internal.telephony.dataconnection.ApnContext} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v10, resolved type: java.lang.String} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v11, resolved type: java.lang.String} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v12, resolved type: com.android.internal.telephony.dataconnection.ApnContext} */
    /* JADX WARNING: type inference failed for: r2v1, types: [java.lang.String] */
    /* access modifiers changed from: private */
    /* JADX WARNING: Multi-variable type inference failed */
    /* JADX WARNING: Unknown variable types count: 1 */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void notifyDisconnectCompleted(com.android.internal.telephony.dataconnection.DataConnection.DisconnectParams r8, boolean r9) {
        /*
            r7 = this;
            java.lang.String r0 = "NotifyDisconnectCompleted"
            r7.log(r0)
            r0 = 0
            if (r8 == 0) goto L_0x0043
            android.os.Message r1 = r8.mOnCompletedMsg
            if (r1 == 0) goto L_0x0043
            r8.mOnCompletedMsg = r0
            java.lang.Object r2 = r1.obj
            boolean r3 = r2 instanceof com.android.internal.telephony.dataconnection.ApnContext
            if (r3 == 0) goto L_0x0017
            r0 = r2
            com.android.internal.telephony.dataconnection.ApnContext r0 = (com.android.internal.telephony.dataconnection.ApnContext) r0
        L_0x0017:
            java.lang.String r2 = r8.mReason
            r3 = 2
            java.lang.Object[] r3 = new java.lang.Object[r3]
            r4 = 0
            java.lang.String r5 = r1.toString()
            r3[r4] = r5
            r4 = 1
            java.lang.Object r5 = r1.obj
            boolean r6 = r5 instanceof java.lang.String
            if (r6 == 0) goto L_0x002d
            java.lang.String r5 = (java.lang.String) r5
            goto L_0x002f
        L_0x002d:
            java.lang.String r5 = "<no-reason>"
        L_0x002f:
            r3[r4] = r5
            java.lang.String r4 = "msg=%s msg.obj=%s"
            java.lang.String r3 = java.lang.String.format(r4, r3)
            r7.log(r3)
            android.os.AsyncResult.forMessage(r1)
            r1.sendToTarget()
            r1 = r0
            r0 = r2
            goto L_0x0044
        L_0x0043:
            r1 = r0
        L_0x0044:
            if (r9 == 0) goto L_0x0054
            if (r0 != 0) goto L_0x004e
            r9 = 65536(0x10000, float:9.18355E-41)
            java.lang.String r0 = android.telephony.DataFailCause.toString(r9)
        L_0x004e:
            r9 = 270351(0x4200f, float:3.78842E-40)
            r7.notifyAllWithEvent(r1, r9, r0)
        L_0x0054:
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r0 = "NotifyDisconnectCompleted DisconnectParams="
            r9.append(r0)
            r9.append(r8)
            java.lang.String r8 = r9.toString()
            r7.log(r8)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.notifyDisconnectCompleted(com.android.internal.telephony.dataconnection.DataConnection$DisconnectParams, boolean):void");
    }

    private void sendRunnableMessage(int i, Consumer<Boolean> consumer) {
        sendMessage(i, (Object) consumer);
    }

    public int getDataConnectionId() {
        return this.mId;
    }

    /* access modifiers changed from: private */
    public synchronized void clearSettings() {
        log("clearSettings");
        this.mCreateTime = -1;
        this.mLastFailTime = -1;
        this.mLastFailCause = 0;
        this.mCid = -1;
        this.mPcscfAddr = new String[5];
        this.mLinkProperties = new LinkProperties();
        this.mApnContexts.clear();
        this.mApnSetting = null;
        this.mUnmeteredUseOnly = false;
        this.mMmsUseOnly = false;
        this.mEnterpriseUse = false;
        this.mRestrictedNetworkOverride = false;
        this.mDcFailCause = 0;
        this.mDisabledApnTypeBitMask = 0;
        this.mSubId = -1;
        this.mCongestedOverride = false;
        this.mUnmeteredOverride = false;
        this.mDownlinkBandwidth = 14;
        this.mUplinkBandwidth = 14;
        this.mIsSuspended = false;
        this.mHandoverState = 1;
        this.mHandoverFailureMode = -1;
        this.mSliceInfo = null;
        this.mDefaultQos = null;
        this.mDoAllocatePduSessionId = false;
        this.mQosBearerSessions.clear();
        this.mTrafficDescriptors.clear();
    }

    /* access modifiers changed from: private */
    public SetupResult onSetupConnectionCompleted(int i, DataCallResponse dataCallResponse, ConnectionParams connectionParams) {
        log("onSetupConnectionCompleted: resultCode=" + i + ", response=" + dataCallResponse);
        if (connectionParams.mTag != this.mTag) {
            log("onSetupConnectionCompleted stale cp.tag=" + connectionParams.mTag + ", mtag=" + this.mTag);
            return SetupResult.ERROR_STALE;
        } else if (i == 4) {
            SetupResult setupResult = SetupResult.ERROR_RADIO_NOT_AVAILABLE;
            setupResult.mFailCause = 65537;
            return setupResult;
        } else if (i == 5) {
            SetupResult setupResult2 = SetupResult.ERROR_DATA_SERVICE_SPECIFIC_ERROR;
            setupResult2.mFailCause = 65545;
            return setupResult2;
        } else if (i == 2) {
            SetupResult setupResult3 = SetupResult.ERROR_INVALID_ARG;
            setupResult3.mFailCause = 65538;
            return setupResult3;
        } else if (dataCallResponse.getCause() != 0) {
            if (dataCallResponse.getCause() == 65537) {
                SetupResult setupResult4 = SetupResult.ERROR_RADIO_NOT_AVAILABLE;
                setupResult4.mFailCause = 65537;
                return setupResult4;
            }
            SetupResult setupResult5 = SetupResult.ERROR_DATA_SERVICE_SPECIFIC_ERROR;
            setupResult5.mFailCause = DataFailCause.getFailCause(dataCallResponse.getCause());
            return setupResult5;
        } else if (connectionParams.mApnContext.getApnTypeBitmask() == 16384 && this.mDcController.getActiveDcByCid(dataCallResponse.getId()) != null) {
            if (!this.mDcController.getTrafficDescriptorsForCid(dataCallResponse.getId()).equals(dataCallResponse.getTrafficDescriptors())) {
                log("Updating traffic descriptors: " + dataCallResponse.getTrafficDescriptors());
                this.mDcController.getActiveDcByCid(dataCallResponse.getId()).updateTrafficDescriptors(dataCallResponse);
                this.mDct.obtainMessage(270393).sendToTarget();
            }
            log("DataConnection already exists for cid: " + dataCallResponse.getId());
            SetupResult setupResult6 = SetupResult.ERROR_DUPLICATE_CID;
            setupResult6.mFailCause = 65543;
            return setupResult6;
        } else if (connectionParams.mApnContext.getApnTypeBitmask() != 16384 || this.mDcController.isDefaultDataActive()) {
            log("onSetupConnectionCompleted received successful DataCallResponse");
            this.mCid = dataCallResponse.getId();
            setPduSessionId(dataCallResponse.getPduSessionId());
            updatePcscfAddr(dataCallResponse);
            updateResponseFields(dataCallResponse);
            return updateLinkProperty(dataCallResponse).setupResult;
        } else {
            log("No default data connection currently active");
            this.mCid = dataCallResponse.getId();
            SetupResult setupResult7 = SetupResult.ERROR_NO_DEFAULT_CONNECTION;
            setupResult7.mFailCause = 65544;
            return setupResult7;
        }
    }

    private boolean isDnsOk(String[] strArr) {
        if (!NULL_IP.equals(strArr[0]) || !NULL_IP.equals(strArr[1]) || this.mPhone.isDnsCheckDisabled() || isIpAddress(this.mApnSetting.getMmsProxyAddressAsString())) {
            return true;
        }
        log(String.format("isDnsOk: return false apn.types=%d APN_TYPE_MMS=%s isIpAddress(%s)=%s", new Object[]{Integer.valueOf(this.mApnSetting.getApnTypeBitmask()), CustomProperties.MODULE_MMS, this.mApnSetting.getMmsProxyAddressAsString(), Boolean.valueOf(isIpAddress(this.mApnSetting.getMmsProxyAddressAsString()))}));
        return false;
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void updateTcpBufferSizes(int r11) {
        /*
            r10 = this;
            com.android.internal.telephony.Phone r0 = r10.mPhone
            android.telephony.ServiceState r0 = r0.getServiceState()
            r1 = 14
            r2 = 19
            if (r11 != r1) goto L_0x0013
            boolean r0 = r0.isUsingCarrierAggregation()
            if (r0 == 0) goto L_0x0013
            r11 = r2
        L_0x0013:
            java.lang.String r0 = android.telephony.ServiceState.rilRadioTechnologyToString(r11)
            java.util.Locale r3 = java.util.Locale.ROOT
            java.lang.String r0 = r0.toLowerCase(r3)
            r3 = 7
            if (r11 == r3) goto L_0x0028
            r3 = 8
            if (r11 == r3) goto L_0x0028
            r3 = 12
            if (r11 != r3) goto L_0x002a
        L_0x0028:
            java.lang.String r0 = "evdo"
        L_0x002a:
            int r3 = r10.mTransportType
            java.lang.String r4 = "nr"
            r5 = 1
            if (r3 != r5) goto L_0x0052
            if (r11 == r1) goto L_0x0035
            if (r11 != r2) goto L_0x0052
        L_0x0035:
            boolean r1 = r10.isNRConnected()
            if (r1 == 0) goto L_0x0052
            com.android.internal.telephony.Phone r1 = r10.mPhone
            com.android.internal.telephony.ServiceStateTracker r1 = r1.getServiceStateTracker()
            java.util.Set r1 = r1.getNrContextIds()
            int r3 = r10.mCid
            java.lang.Integer r3 = java.lang.Integer.valueOf(r3)
            boolean r1 = r1.contains(r3)
            if (r1 == 0) goto L_0x0052
            r0 = r4
        L_0x0052:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r3 = "updateTcpBufferSizes: "
            r1.append(r3)
            r1.append(r0)
            java.lang.String r1 = r1.toString()
            r10.log(r1)
            com.android.internal.telephony.Phone r1 = r10.mPhone
            android.content.Context r1 = r1.getContext()
            android.content.res.Resources r1 = r1.getResources()
            r3 = 17236097(0x1070081, float:2.4795945E-38)
            java.lang.String[] r1 = r1.getStringArray(r3)
            r3 = 0
            r6 = r3
        L_0x007a:
            int r7 = r1.length
            r8 = 2
            if (r6 >= r7) goto L_0x0097
            r7 = r1[r6]
            java.lang.String r9 = ":"
            java.lang.String[] r7 = r7.split(r9)
            r9 = r7[r3]
            boolean r9 = r0.equals(r9)
            if (r9 == 0) goto L_0x0094
            int r9 = r7.length
            if (r9 != r8) goto L_0x0094
            r1 = r7[r5]
            goto L_0x0098
        L_0x0094:
            int r6 = r6 + 1
            goto L_0x007a
        L_0x0097:
            r1 = 0
        L_0x0098:
            java.lang.String r3 = "2097152,6291456,16777216,512000,2097152,8388608"
            if (r1 != 0) goto L_0x00dd
            if (r11 == r5) goto L_0x00db
            if (r11 == r8) goto L_0x00d8
            r5 = 3
            if (r11 == r5) goto L_0x00d5
            if (r11 == r2) goto L_0x00cb
            r2 = 20
            if (r11 == r2) goto L_0x00c9
            switch(r11) {
                case 6: goto L_0x00c6;
                case 7: goto L_0x00c3;
                case 8: goto L_0x00c3;
                case 9: goto L_0x00c0;
                case 10: goto L_0x00bd;
                case 11: goto L_0x00bd;
                case 12: goto L_0x00c3;
                case 13: goto L_0x00ba;
                case 14: goto L_0x00b0;
                case 15: goto L_0x00ad;
                default: goto L_0x00ac;
            }
        L_0x00ac:
            goto L_0x00dd
        L_0x00ad:
            java.lang.String r1 = "122334,734003,2202010,32040,192239,576717"
            goto L_0x00dd
        L_0x00b0:
            boolean r11 = r4.equals(r0)
            if (r11 == 0) goto L_0x00b7
            goto L_0x00c9
        L_0x00b7:
            java.lang.String r1 = "524288,1048576,2097152,262144,524288,1048576"
            goto L_0x00dd
        L_0x00ba:
            java.lang.String r1 = "131072,262144,1048576,4096,16384,524288"
            goto L_0x00dd
        L_0x00bd:
            java.lang.String r1 = "40778,244668,734003,16777,100663,301990"
            goto L_0x00dd
        L_0x00c0:
            java.lang.String r1 = "61167,367002,1101005,8738,52429,262114"
            goto L_0x00dd
        L_0x00c3:
            java.lang.String r1 = "4094,87380,262144,4096,16384,262144"
            goto L_0x00dd
        L_0x00c6:
            java.lang.String r1 = "16384,32768,131072,4096,16384,102400"
            goto L_0x00dd
        L_0x00c9:
            r1 = r3
            goto L_0x00dd
        L_0x00cb:
            boolean r11 = r4.equals(r0)
            if (r11 == 0) goto L_0x00d2
            goto L_0x00c9
        L_0x00d2:
            java.lang.String r1 = "4096,6291456,12582912,4096,1048576,2097152"
            goto L_0x00dd
        L_0x00d5:
            java.lang.String r1 = "58254,349525,1048576,58254,349525,1048576"
            goto L_0x00dd
        L_0x00d8:
            java.lang.String r1 = "4093,26280,70800,4096,16384,70800"
            goto L_0x00dd
        L_0x00db:
            java.lang.String r1 = "4092,8760,48000,4096,8760,48000"
        L_0x00dd:
            android.net.LinkProperties r10 = r10.mLinkProperties
            r10.setTcpBufferSizes(r1)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.updateTcpBufferSizes(int):void");
    }

    /* access modifiers changed from: private */
    public void updateLinkBandwidthsFromCarrierConfig(int i) {
        String dataConfigNetworkType = DataConfigManager.getDataConfigNetworkType(this.mPhone.getDisplayInfoController().getTelephonyDisplayInfo());
        log("updateLinkBandwidthsFromCarrierConfig: " + dataConfigNetworkType);
        Pair<Integer, Integer> linkBandwidthsFromCarrierConfig = this.mDct.getLinkBandwidthsFromCarrierConfig(dataConfigNetworkType);
        if (linkBandwidthsFromCarrierConfig == null) {
            linkBandwidthsFromCarrierConfig = new Pair<>(14, 14);
        }
        this.mDownlinkBandwidth = ((Integer) linkBandwidthsFromCarrierConfig.first).intValue();
        this.mUplinkBandwidth = ((Integer) linkBandwidthsFromCarrierConfig.second).intValue();
    }

    /* access modifiers changed from: private */
    public void updateLinkBandwidthsFromModem(List<LinkCapacityEstimate> list) {
        boolean z;
        log("updateLinkBandwidthsFromModem: lceList=" + list);
        boolean z2 = false;
        LinkCapacityEstimate linkCapacityEstimate = list.get(0);
        boolean z3 = true;
        if (this.mPhone.getHalVersion().greaterOrEqual(RIL.RADIO_HAL_VERSION_1_2) || this.mPhone.getLceStatus() == 1) {
            if (linkCapacityEstimate.getDownlinkCapacityKbps() != -1) {
                this.mDownlinkBandwidth = linkCapacityEstimate.getDownlinkCapacityKbps();
                z = true;
            } else {
                z = false;
            }
            if (linkCapacityEstimate.getUplinkCapacityKbps() != -1) {
                this.mUplinkBandwidth = linkCapacityEstimate.getUplinkCapacityKbps();
            } else {
                z3 = false;
            }
            z2 = z;
        } else {
            z3 = false;
        }
        if (!z2 || !z3) {
            fallBackToCarrierConfigValues(z2, z3);
        }
        DcNetworkAgent dcNetworkAgent = this.mNetworkAgent;
        if (dcNetworkAgent != null) {
            dcNetworkAgent.sendNetworkCapabilities(getNetworkCapabilities(), this);
        }
    }

    /* access modifiers changed from: private */
    public void updateLinkBandwidthsFromBandwidthEstimator(int i, int i2) {
        boolean z;
        log("updateLinkBandwidthsFromBandwidthEstimator, UL= " + i + " DL= " + i2);
        boolean z2 = true;
        if (i2 > 0) {
            this.mDownlinkBandwidth = i2;
            z = true;
        } else {
            z = false;
        }
        if (i > 0) {
            this.mUplinkBandwidth = i;
        } else {
            z2 = false;
        }
        if (!z || !z2) {
            fallBackToCarrierConfigValues(z, z2);
        }
        DcNetworkAgent dcNetworkAgent = this.mNetworkAgent;
        if (dcNetworkAgent != null) {
            dcNetworkAgent.sendNetworkCapabilities(getNetworkCapabilities(), this);
        }
    }

    private void fallBackToCarrierConfigValues(boolean z, boolean z2) {
        String rilRadioTechnologyToString = ServiceState.rilRadioTechnologyToString(this.mRilRat);
        if (this.mRilRat == 14 && isNRConnected()) {
            rilRadioTechnologyToString = this.mPhone.getServiceState().getNrFrequencyRange() == 4 ? DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE : DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA;
        }
        Pair<Integer, Integer> linkBandwidthsFromCarrierConfig = this.mDct.getLinkBandwidthsFromCarrierConfig(rilRadioTechnologyToString);
        if (linkBandwidthsFromCarrierConfig != null) {
            if (!z) {
                this.mDownlinkBandwidth = ((Integer) linkBandwidthsFromCarrierConfig.first).intValue();
            }
            if (!z2) {
                this.mUplinkBandwidth = ((Integer) linkBandwidthsFromCarrierConfig.second).intValue();
            }
            this.mUplinkBandwidth = Math.min(this.mUplinkBandwidth, this.mDownlinkBandwidth);
        }
    }

    /* access modifiers changed from: private */
    public boolean isBandwidthSourceKey(String str) {
        return str.equals(this.mPhone.getContext().getResources().getString(17039887));
    }

    /* access modifiers changed from: private */
    public boolean shouldRestrictNetwork() {
        boolean z;
        Iterator<ApnContext> it = this.mApnContexts.keySet().iterator();
        while (true) {
            if (it.hasNext()) {
                if (it.next().hasRestrictedRequests(true)) {
                    z = true;
                    break;
                }
            } else {
                z = false;
                break;
            }
        }
        if (!z || !ApnSettingUtils.isMetered(this.mApnSetting, this.mPhone)) {
            return false;
        }
        if (!this.mPhone.getDataEnabledSettings().isDataEnabled()) {
            return true;
        }
        return !this.mDct.getDataRoamingEnabled() && this.mPhone.getServiceState().getDataRoaming();
    }

    /* access modifiers changed from: private */
    public boolean isUnmeteredUseOnly() {
        if (this.mTransportType == 2) {
            return false;
        }
        if (this.mPhone.getDataEnabledSettings().isDataEnabled() && (!this.mPhone.getServiceState().getDataRoaming() || this.mDct.getDataRoamingEnabled())) {
            return false;
        }
        for (ApnContext apnTypeBitmask : this.mApnContexts.keySet()) {
            if (ApnSettingUtils.isMeteredApnType(apnTypeBitmask.getApnTypeBitmask(), this.mPhone)) {
                return false;
            }
        }
        return true;
    }

    /* access modifiers changed from: private */
    public boolean isMmsUseOnly() {
        DataEnabledSettings dataEnabledSettings = this.mPhone.getDataEnabledSettings();
        boolean z = !dataEnabledSettings.isDataEnabled() && dataEnabledSettings.isMmsAlwaysAllowed();
        boolean isApnContextAttached = isApnContextAttached(2, true);
        if (!z || !isApnContextAttached) {
            return false;
        }
        return true;
    }

    /* access modifiers changed from: private */
    public boolean isEnterpriseUse() {
        return this.mApnContexts.keySet().stream().anyMatch(new DataConnection$$ExternalSyntheticLambda6());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isEnterpriseUse$5(ApnContext apnContext) {
        return apnContext.getApnTypeBitmask() == 16384;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:52:0x00e4, code lost:
        if (com.android.internal.telephony.dataconnection.ApnSettingUtils.isMetered(r14.mApnSetting, r14.mPhone) == false) goto L_0x00e8;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public android.net.NetworkCapabilities getNetworkCapabilities() {
        /*
            r14 = this;
            android.net.NetworkCapabilities$Builder r0 = new android.net.NetworkCapabilities$Builder
            r0.<init>()
            r1 = 0
            android.net.NetworkCapabilities$Builder r0 = r0.addTransportType(r1)
            android.telephony.data.ApnSetting r2 = r14.mApnSetting
            r3 = 12
            r4 = 1
            r5 = 2
            if (r2 == 0) goto L_0x00e7
            boolean r2 = r14.mEnterpriseUse
            if (r2 != 0) goto L_0x00e7
            boolean r2 = r14.mMmsUseOnly
            if (r2 != 0) goto L_0x00e7
            android.telephony.data.ApnSetting r2 = r14.mApnSetting
            int r2 = r2.getApnTypeBitmask()
            int r6 = r14.mDisabledApnTypeBitMask
            int r6 = ~r6
            r2 = r2 & r6
            int[] r2 = android.telephony.data.ApnSetting.getApnTypesFromBitmask(r2)
            int r6 = r2.length
            r7 = r1
        L_0x002a:
            if (r7 >= r6) goto L_0x00dc
            r8 = r2[r7]
            boolean r9 = r14.mRestrictedNetworkOverride
            if (r9 != 0) goto L_0x005d
            boolean r9 = r14.mUnmeteredUseOnly
            if (r9 == 0) goto L_0x005d
            com.android.internal.telephony.Phone r9 = r14.mPhone
            boolean r9 = com.android.internal.telephony.dataconnection.ApnSettingUtils.isMeteredApnType(r8, r9)
            if (r9 == 0) goto L_0x005d
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r10 = "Dropped the metered "
            r9.append(r10)
            java.lang.String r8 = android.telephony.data.ApnSetting.getApnTypeString(r8)
            r9.append(r8)
            java.lang.String r8 = " type for the unmetered data call."
            r9.append(r8)
            java.lang.String r8 = r9.toString()
            r14.log(r8)
            goto L_0x00d8
        L_0x005d:
            if (r8 == r5) goto L_0x00d5
            r9 = 4
            if (r8 == r9) goto L_0x00d1
            r10 = 8
            if (r8 == r10) goto L_0x00cd
            r10 = 17
            if (r8 == r10) goto L_0x00c9
            r10 = 32
            r11 = 3
            if (r8 == r10) goto L_0x00c5
            r10 = 64
            if (r8 == r10) goto L_0x00c1
            r10 = 128(0x80, float:1.794E-43)
            r12 = 5
            if (r8 == r10) goto L_0x00bd
            r10 = 512(0x200, float:7.175E-43)
            if (r8 == r10) goto L_0x00b7
            r10 = 1024(0x400, float:1.435E-42)
            if (r8 == r10) goto L_0x00b1
            r10 = 2048(0x800, float:2.87E-42)
            if (r8 == r10) goto L_0x00ab
            r10 = 255(0xff, float:3.57E-43)
            r13 = 7
            if (r8 == r10) goto L_0x0092
            r9 = 256(0x100, float:3.59E-43)
            if (r8 == r9) goto L_0x008e
            goto L_0x00d8
        L_0x008e:
            r0.addCapability(r13)
            goto L_0x00d8
        L_0x0092:
            r0.addCapability(r3)
            r0.addCapability(r1)
            r0.addCapability(r4)
            r0.addCapability(r11)
            r0.addCapability(r9)
            r0.addCapability(r12)
            r0.addCapability(r13)
            r0.addCapability(r5)
            goto L_0x00d8
        L_0x00ab:
            r8 = 9
            r0.addCapability(r8)
            goto L_0x00d8
        L_0x00b1:
            r8 = 23
            r0.addCapability(r8)
            goto L_0x00d8
        L_0x00b7:
            r8 = 10
            r0.addCapability(r8)
            goto L_0x00d8
        L_0x00bd:
            r0.addCapability(r12)
            goto L_0x00d8
        L_0x00c1:
            r0.addCapability(r9)
            goto L_0x00d8
        L_0x00c5:
            r0.addCapability(r11)
            goto L_0x00d8
        L_0x00c9:
            r0.addCapability(r3)
            goto L_0x00d8
        L_0x00cd:
            r0.addCapability(r5)
            goto L_0x00d8
        L_0x00d1:
            r0.addCapability(r4)
            goto L_0x00d8
        L_0x00d5:
            r0.addCapability(r1)
        L_0x00d8:
            int r7 = r7 + 1
            goto L_0x002a
        L_0x00dc:
            android.telephony.data.ApnSetting r2 = r14.mApnSetting
            com.android.internal.telephony.Phone r6 = r14.mPhone
            boolean r2 = com.android.internal.telephony.dataconnection.ApnSettingUtils.isMetered(r2, r6)
            if (r2 != 0) goto L_0x00e7
            goto L_0x00e8
        L_0x00e7:
            r4 = r1
        L_0x00e8:
            r2 = 11
            if (r4 != 0) goto L_0x00f9
            boolean r4 = r14.mUnmeteredUseOnly
            if (r4 == 0) goto L_0x00f5
            boolean r4 = r14.mRestrictedNetworkOverride
            if (r4 != 0) goto L_0x00f5
            goto L_0x00f9
        L_0x00f5:
            r0.removeCapability(r2)
            goto L_0x00fc
        L_0x00f9:
            r0.addCapability(r2)
        L_0x00fc:
            boolean r4 = r14.mEnterpriseUse
            if (r4 == 0) goto L_0x0108
            r4 = 29
            r0.addCapability(r4)
            r0.addCapability(r3)
        L_0x0108:
            android.net.NetworkCapabilities r3 = r0.build()
            boolean r3 = com.android.internal.telephony.util.NetworkCapabilitiesUtils.inferRestrictedCapability(r3)
            r4 = 13
            if (r3 == 0) goto L_0x0117
            r0.removeCapability(r4)
        L_0x0117:
            boolean r3 = r14.mMmsUseOnly
            if (r3 == 0) goto L_0x0133
            com.android.internal.telephony.Phone r3 = r14.mPhone
            boolean r3 = com.android.internal.telephony.dataconnection.ApnSettingUtils.isMeteredApnType(r5, r3)
            if (r3 == 0) goto L_0x012b
            java.lang.String r3 = "Adding unmetered capability for the unmetered MMS-only data connection"
            r14.log(r3)
            r0.addCapability(r2)
        L_0x012b:
            java.lang.String r2 = "Adding MMS capability for the MMS-only data connection"
            r14.log(r2)
            r0.addCapability(r1)
        L_0x0133:
            boolean r1 = r14.mRestrictedNetworkOverride
            if (r1 == 0) goto L_0x013d
            r0.removeCapability(r4)
            r0.removeCapability(r5)
        L_0x013d:
            int r1 = r14.mDownlinkBandwidth
            r0.setLinkDownstreamBandwidthKbps(r1)
            int r1 = r14.mUplinkBandwidth
            r0.setLinkUpstreamBandwidthKbps(r1)
            android.net.TelephonyNetworkSpecifier$Builder r1 = new android.net.TelephonyNetworkSpecifier$Builder
            r1.<init>()
            int r2 = r14.mSubId
            android.net.TelephonyNetworkSpecifier$Builder r1 = r1.setSubscriptionId(r2)
            android.net.TelephonyNetworkSpecifier r1 = r1.build()
            r0.setNetworkSpecifier(r1)
            int r1 = r14.mSubId
            java.lang.Integer r1 = java.lang.Integer.valueOf(r1)
            java.util.Set r1 = java.util.Collections.singleton(r1)
            r0.setSubscriptionIds(r1)
            com.android.internal.telephony.Phone r1 = r14.mPhone
            android.telephony.ServiceState r1 = r1.getServiceState()
            boolean r1 = r1.getDataRoaming()
            if (r1 != 0) goto L_0x0177
            r1 = 18
            r0.addCapability(r1)
        L_0x0177:
            boolean r1 = r14.mCongestedOverride
            if (r1 != 0) goto L_0x0180
            r1 = 20
            r0.addCapability(r1)
        L_0x0180:
            boolean r1 = r14.mUnmeteredOverride
            if (r1 == 0) goto L_0x0189
            r1 = 25
            r0.addCapability(r1)
        L_0x0189:
            boolean r1 = r14.mIsSuspended
            if (r1 != 0) goto L_0x0192
            r1 = 21
            r0.addCapability(r1)
        L_0x0192:
            int r1 = r14.getCarrierServicePackageUid()
            r2 = -1
            if (r1 == r2) goto L_0x01af
            int[] r2 = r14.mAdministratorUids
            boolean r2 = com.android.internal.telephony.util.ArrayUtils.contains(r2, r1)
            if (r2 == 0) goto L_0x01af
            r0.setOwnerUid(r1)
            java.lang.Integer r1 = java.lang.Integer.valueOf(r1)
            java.util.Set r1 = java.util.Collections.singleton(r1)
            r0.setAllowedUids(r1)
        L_0x01af:
            int[] r1 = r14.mAdministratorUids
            r0.setAdministratorUids(r1)
            r1 = 28
            r0.addCapability(r1)
            android.net.NetworkCapabilities r2 = r0.build()
            android.net.vcn.VcnNetworkPolicyResult r14 = r14.getVcnPolicy(r2)
            android.net.NetworkCapabilities r2 = r14.getNetworkCapabilities()
            boolean r2 = r2.hasCapability(r1)
            if (r2 != 0) goto L_0x01ce
            r0.removeCapability(r1)
        L_0x01ce:
            android.net.NetworkCapabilities r14 = r14.getNetworkCapabilities()
            boolean r14 = r14.hasCapability(r4)
            if (r14 != 0) goto L_0x01db
            r0.removeCapability(r4)
        L_0x01db:
            android.net.NetworkCapabilities r14 = r0.build()
            return r14
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.getNetworkCapabilities():android.net.NetworkCapabilities");
    }

    private int getFirstUidForPackage(String str) {
        if (str == null) {
            return -1;
        }
        for (UserInfo userHandle : ((UserManager) this.mPhone.getContext().getSystemService(UserManager.class)).getUsers()) {
            int identifier = userHandle.getUserHandle().getIdentifier();
            try {
                PackageManager packageManager = this.mPhone.getContext().getPackageManager();
                if (packageManager != null) {
                    return packageManager.getPackageUidAsUser(str, identifier);
                }
            } catch (PackageManager.NameNotFoundException unused) {
                Rlog.i("DataConnection", "Unable to find uid for package " + str + " and user " + identifier);
            }
        }
        return -1;
    }

    private int getCarrierServicePackageUid() {
        return getFirstUidForPackage(((TelephonyManager) this.mPhone.getContext().getSystemService(TelephonyManager.class)).getCarrierServicePackageNameForLogicalSlot(this.mPhone.getPhoneId()));
    }

    private VcnNetworkPolicyResult getVcnPolicy(NetworkCapabilities networkCapabilities) {
        return this.mVcnManager.applyVcnNetworkPolicy(networkCapabilities, getLinkProperties());
    }

    public boolean isValidationRequired() {
        NetworkCapabilities networkCapabilities = getNetworkCapabilities();
        return networkCapabilities != null && networkCapabilities.hasCapability(12) && networkCapabilities.hasCapability(13) && networkCapabilities.hasCapability(14) && networkCapabilities.hasCapability(15);
    }

    @VisibleForTesting
    public boolean shouldSkip464Xlat() {
        int skip464Xlat = this.mApnSetting.getSkip464Xlat();
        if (skip464Xlat == 0) {
            return false;
        }
        if (skip464Xlat == 1) {
            return true;
        }
        NetworkCapabilities networkCapabilities = getNetworkCapabilities();
        if (!networkCapabilities.hasCapability(4) || networkCapabilities.hasCapability(12)) {
            return false;
        }
        return true;
    }

    @VisibleForTesting
    public static boolean isIpAddress(String str) {
        if (str == null) {
            return false;
        }
        if (str.startsWith("[") && str.endsWith("]") && str.indexOf(58) != -1) {
            str = str.substring(1, str.length() - 1);
        }
        return InetAddresses.isNumericAddress(str);
    }

    private SetupResult setLinkProperties(DataCallResponse dataCallResponse, LinkProperties linkProperties) {
        SetupResult setupResult;
        int i;
        String trim;
        String str = "net." + dataCallResponse.getInterfaceName() + ".";
        String[] strArr = {SystemProperties.get(str + "dns1"), SystemProperties.get(str + "dns2")};
        boolean isDnsOk = isDnsOk(strArr);
        linkProperties.clear();
        if (dataCallResponse.getCause() == 0) {
            try {
                linkProperties.setInterfaceName(dataCallResponse.getInterfaceName());
                if (dataCallResponse.getAddresses().size() > 0) {
                    for (LinkAddress linkAddress : dataCallResponse.getAddresses()) {
                        if (!linkAddress.getAddress().isAnyLocalAddress()) {
                            log("addr/pl=" + linkAddress.getAddress() + "/" + linkAddress.getPrefixLength());
                            linkProperties.addLinkAddress(linkAddress);
                        }
                    }
                    if (dataCallResponse.getDnsAddresses().size() > 0) {
                        for (InetAddress inetAddress : dataCallResponse.getDnsAddresses()) {
                            if (!inetAddress.isAnyLocalAddress()) {
                                linkProperties.addDnsServer(inetAddress);
                            }
                        }
                    } else if (isDnsOk) {
                        for (int i2 = 0; i2 < 2; i2++) {
                            trim = strArr[i2].trim();
                            if (!trim.isEmpty()) {
                                InetAddress parseNumericAddress = InetAddresses.parseNumericAddress(trim);
                                if (!parseNumericAddress.isAnyLocalAddress()) {
                                    linkProperties.addDnsServer(parseNumericAddress);
                                }
                            }
                        }
                    } else {
                        throw new UnknownHostException("Empty dns response and no system default dns");
                    }
                    if (dataCallResponse.getPcscfAddresses().size() > 0) {
                        for (InetAddress addPcscfServer : dataCallResponse.getPcscfAddresses()) {
                            linkProperties.addPcscfServer(addPcscfServer);
                        }
                    }
                    for (InetAddress inetAddress2 : dataCallResponse.getGatewayAddresses()) {
                        if (inetAddress2 instanceof Inet6Address) {
                            i = dataCallResponse.getMtuV6();
                        } else {
                            i = dataCallResponse.getMtuV4();
                        }
                        linkProperties.addRoute(new RouteInfo((IpPrefix) null, inetAddress2, (String) null, 1, i));
                    }
                    linkProperties.setMtu(dataCallResponse.getMtu());
                    setupResult = SetupResult.SUCCESS;
                } else {
                    throw new UnknownHostException("no address for ifname=" + dataCallResponse.getInterfaceName());
                }
            } catch (IllegalArgumentException unused) {
                throw new UnknownHostException("Non-numeric dns addr=" + trim);
            } catch (UnknownHostException e) {
                log("setLinkProperties: UnknownHostException " + e);
                setupResult = SetupResult.ERROR_INVALID_ARG;
            }
        } else {
            setupResult = SetupResult.ERROR_DATA_SERVICE_SPECIFIC_ERROR;
        }
        if (setupResult != SetupResult.SUCCESS) {
            log("setLinkProperties: error clearing LinkProperties status=" + dataCallResponse.getCause() + " result=" + setupResult);
            linkProperties.clear();
        }
        return setupResult;
    }

    /* access modifiers changed from: private */
    public boolean initConnection(ConnectionParams connectionParams) {
        ApnContext apnContext = connectionParams.mApnContext;
        if (this.mApnSetting == null) {
            this.mApnSetting = apnContext.getApnSetting();
        }
        if (this.mApnSetting == null || (!this.mApnSetting.canHandleType(apnContext.getApnTypeBitmask()) && apnContext.getApnTypeBitmask() != 16384)) {
            log("initConnection: incompatible apnSetting in ConnectionParams cp=" + connectionParams + " dc=" + this);
            return false;
        }
        int i = this.mTag + 1;
        this.mTag = i;
        this.mConnectionParams = connectionParams;
        connectionParams.mTag = i;
        this.mApnContexts.put(apnContext, connectionParams);
        log("initConnection:  RefCount=" + this.mApnContexts.size() + " mApnList=" + this.mApnContexts + " mConnectionParams=" + this.mConnectionParams);
        return true;
    }

    private class DcDefaultState extends State {
        private DcDefaultState() {
        }

        public void enter() {
            DataConnection.this.log("DcDefaultState: enter");
            DataConnection.this.mPhone.getServiceStateTracker().registerForDataRegStateOrRatChanged(DataConnection.this.mTransportType, DataConnection.this.getHandler(), DataConnection.EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED, (Object) null);
            DataConnection.this.mPhone.getServiceStateTracker().registerForDataRoamingOn(DataConnection.this.getHandler(), DataConnection.EVENT_DATA_CONNECTION_ROAM_ON, (Object) null);
            DataConnection.this.mPhone.getServiceStateTracker().registerForDataRoamingOff(DataConnection.this.getHandler(), DataConnection.EVENT_DATA_CONNECTION_ROAM_OFF, (Object) null, true);
            DataConnection.this.mPhone.getServiceStateTracker().registerForNrStateChanged(DataConnection.this.getHandler(), DataConnection.EVENT_NR_STATE_CHANGED, (Object) null);
            DataConnection.this.mPhone.getServiceStateTracker().registerForNrFrequencyChanged(DataConnection.this.getHandler(), DataConnection.EVENT_NR_FREQUENCY_CHANGED, (Object) null);
            DataConnection.this.mPhone.getServiceStateTracker().registerForCssIndicatorChanged(DataConnection.this.getHandler(), DataConnection.EVENT_CSS_INDICATOR_CHANGED, (Object) null);
            if (DataConnection.this.isBandwidthSourceKey("bandwidth_estimator")) {
                DataConnection.this.mPhone.getLinkBandwidthEstimator().registerForBandwidthChanged(DataConnection.this.getHandler(), DataConnection.EVENT_LINK_BANDWIDTH_ESTIMATOR_UPDATE, (Object) null);
            }
            DataConnection.this.mDcController.addDc(DataConnection.this);
        }

        public void exit() {
            DataConnection.this.log("DcDefaultState: exit");
            DataConnection.this.mPhone.getServiceStateTracker().unregisterForDataRegStateOrRatChanged(DataConnection.this.mTransportType, DataConnection.this.getHandler());
            DataConnection.this.mPhone.getServiceStateTracker().unregisterForDataRoamingOn(DataConnection.this.getHandler());
            DataConnection.this.mPhone.getServiceStateTracker().unregisterForDataRoamingOff(DataConnection.this.getHandler());
            DataConnection.this.mPhone.getServiceStateTracker().unregisterForNrStateChanged(DataConnection.this.getHandler());
            DataConnection.this.mPhone.getServiceStateTracker().unregisterForNrFrequencyChanged(DataConnection.this.getHandler());
            DataConnection.this.mPhone.getServiceStateTracker().unregisterForCssIndicatorChanged(DataConnection.this.getHandler());
            if (DataConnection.this.isBandwidthSourceKey("bandwidth_estimator")) {
                DataConnection.this.mPhone.getLinkBandwidthEstimator().unregisterForBandwidthChanged(DataConnection.this.getHandler());
            }
            DataConnection.this.mDcController.removeDc(DataConnection.this);
            if (DataConnection.this.mAc != null) {
                DataConnection.this.mAc.disconnected();
                DataConnection.this.mAc = null;
            }
            DataConnection.this.mApnContexts.clear();
            DataConnection dataConnection = DataConnection.this;
            dataConnection.mReconnectIntent = null;
            dataConnection.mDct = null;
            DataConnection.this.mApnSetting = null;
            DataConnection.this.mPhone = null;
            DataConnection.this.mDataServiceManager = null;
            DataConnection.this.mLinkProperties = null;
            DataConnection.this.mLastFailCause = 0;
            DataConnection.this.mUserData = null;
            DataConnection.this.mDcController = null;
            DataConnection.this.mDcTesterFailBringUpAll = null;
        }

        public boolean processMessage(Message message) {
            DataConnection dataConnection = DataConnection.this;
            dataConnection.log("DcDefault msg=" + DataConnection.this.getWhatToString(message.what) + " RefCount=" + DataConnection.this.mApnContexts.size());
            switch (message.what) {
                case 262144:
                    DataConnection.this.log("DcDefaultState: msg.what=EVENT_CONNECT, fail not expected");
                    DataConnection.this.notifyConnectCompleted((ConnectionParams) message.obj, 65536, -1, false);
                    break;
                case DataConnection.EVENT_DISCONNECT /*262148*/:
                case DataConnection.EVENT_DISCONNECT_ALL /*262150*/:
                case DataConnection.EVENT_REEVALUATE_RESTRICTED_STATE /*262169*/:
                    DataConnection dataConnection2 = DataConnection.this;
                    dataConnection2.log("DcDefaultState deferring msg.what=" + DataConnection.this.getWhatToString(message.what) + " RefCount=" + DataConnection.this.mApnContexts.size());
                    DataConnection.this.deferMessage(message);
                    break;
                case DataConnection.EVENT_TEAR_DOWN_NOW /*262152*/:
                    DataConnection.this.log("DcDefaultState EVENT_TEAR_DOWN_NOW");
                    DataConnection.this.mDataServiceManager.deactivateDataCall(DataConnection.this.mCid, 1, (Message) null);
                    DataConnection.this.mDataCallSessionStats.setDeactivateDataCallReason(1);
                    break;
                case DataConnection.EVENT_LOST_CONNECTION /*262153*/:
                    DataConnection.this.logAndAddLogRec("DcDefaultState ignore EVENT_LOST_CONNECTION tag=" + message.arg1 + ":mTag=" + DataConnection.this.mTag);
                    break;
                case DataConnection.EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED /*262155*/:
                    Pair pair = (Pair) ((AsyncResult) message.obj).result;
                    DataConnection.this.mDataRegState = ((Integer) pair.first).intValue();
                    DataConnection.this.updateTcpBufferSizes(((Integer) pair.second).intValue());
                    if (DataConnection.this.isBandwidthSourceKey("carrier_config")) {
                        DataConnection.this.updateLinkBandwidthsFromCarrierConfig(((Integer) pair.second).intValue());
                    }
                    DataConnection.this.mRilRat = ((Integer) pair.second).intValue();
                    DataConnection dataConnection3 = DataConnection.this;
                    dataConnection3.log("DcDefaultState: EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED regState=" + ServiceState.rilServiceStateToString(DataConnection.this.mDataRegState) + " RAT=" + ServiceState.rilRadioTechnologyToString(DataConnection.this.mRilRat));
                    DataConnection.this.mDataCallSessionStats.onDrsOrRatChanged(ServiceState.rilRadioTechnologyToNetworkType(DataConnection.this.mRilRat));
                    break;
                case DataConnection.EVENT_RESET /*262168*/:
                    DataConnection.this.log("DcDefaultState: msg.what=REQ_RESET");
                    DataConnection dataConnection4 = DataConnection.this;
                    dataConnection4.transitionTo(dataConnection4.mInactiveState);
                    break;
                case DataConnection.EVENT_START_HANDOVER /*262178*/:
                    DataConnection.this.log("DcDefaultState: EVENT_START_HANDOVER not expected.");
                    ((Consumer) message.obj).accept(4);
                    break;
                case DataConnection.EVENT_CANCEL_HANDOVER /*262179*/:
                    DataConnection dataConnection5 = DataConnection.this;
                    dataConnection5.log("DcDefaultState: EVENT_CANCEL_HANDOVER resultCode=" + DataServiceCallback.resultCodeToString(message.arg1));
                    break;
                case DataConnection.EVENT_START_HANDOVER_ON_TARGET /*262180*/:
                    DataConnection dataConnection6 = DataConnection.this;
                    dataConnection6.log("DcDefaultState: EVENT_START_HANDOVER not expected, but will clean up, result code: " + DataServiceCallback.resultCodeToString(message.arg1));
                    ((Consumer) message.obj).accept(Boolean.FALSE);
                    break;
                case DataConnection.EVENT_ALLOCATE_PDU_SESSION_ID /*262181*/:
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    if (asyncResult != null) {
                        Consumer consumer = (Consumer) asyncResult.userObj;
                        Throwable th = asyncResult.exception;
                        if (th == null) {
                            Object obj = asyncResult.result;
                            if (obj != null) {
                                int intValue = ((Integer) obj).intValue();
                                DataConnection dataConnection7 = DataConnection.this;
                                dataConnection7.logd("EVENT_ALLOCATE_PDU_SESSION_ID: psi=" + intValue);
                                consumer.accept(Integer.valueOf(intValue));
                                break;
                            } else {
                                DataConnection.this.loge("EVENT_ALLOCATE_PDU_SESSION_ID: result null, no id");
                                consumer.accept(0);
                                break;
                            }
                        } else {
                            DataConnection.this.loge("EVENT_ALLOCATE_PDU_SESSION_ID: exception", th);
                            consumer.accept(0);
                            break;
                        }
                    } else {
                        DataConnection.this.loge("EVENT_ALLOCATE_PDU_SESSION_ID: asyncResult is null!");
                        break;
                    }
                case DataConnection.EVENT_RELEASE_PDU_SESSION_ID /*262182*/:
                    Object obj2 = message.obj;
                    AsyncResult asyncResult2 = (AsyncResult) obj2;
                    if (asyncResult2 != null) {
                        if (obj2 == null) {
                            DataConnection.this.loge("EVENT_RELEASE_PDU_SESSION_ID: no runnable set");
                            break;
                        } else {
                            DataConnection.this.logd("EVENT_RELEASE_PDU_SESSION_ID: id released");
                            ((Runnable) asyncResult2.userObj).run();
                            break;
                        }
                    } else {
                        DataConnection.this.loge("EVENT_RELEASE_PDU_SESSION_ID: asyncResult is null!");
                        break;
                    }
                default:
                    DataConnection dataConnection8 = DataConnection.this;
                    dataConnection8.log("DcDefaultState: ignore msg.what=" + DataConnection.this.getWhatToString(message.what));
                    break;
            }
            return true;
        }
    }

    /* access modifiers changed from: private */
    public void updateSuspendState() {
        if (this.mNetworkAgent == null) {
            Rlog.d(getName(), "Setting suspend state without a NetworkAgent");
        }
        boolean z = true;
        if (getCurrentState() != this.mActiveState || ((this.mApnSetting != null && this.mApnSetting.isEmergencyApn()) || (this.mDataRegState == 0 && (this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed() || this.mPhone.getCallTracker().getState() == PhoneConstants.State.IDLE)))) {
            z = false;
        }
        if (this.mIsSuspended != z) {
            this.mIsSuspended = z;
            if (isActive()) {
                notifyDataConnectionState();
            }
        }
    }

    /* access modifiers changed from: private */
    public void notifyDataConnectionState() {
        if (!isEnterpriseUse()) {
            this.mPhone.notifyDataConnection(getPreciseDataConnectionState());
            return;
        }
        log("notifyDataConnectionState: Skipping for enterprise; state=" + getState());
    }

    /* access modifiers changed from: private */
    public int getApnTypeBitmask() {
        if (isEnterpriseUse()) {
            return 16384;
        }
        if (this.mApnSetting != null) {
            return this.mApnSetting.getApnTypeBitmask();
        }
        return 0;
    }

    /* access modifiers changed from: private */
    public boolean canHandleDefault() {
        if (isEnterpriseUse() || this.mApnSetting == null) {
            return false;
        }
        return this.mApnSetting.canHandleType(17);
    }

    private class DcInactiveState extends State {
        public void exit() {
        }

        private DcInactiveState() {
        }

        public void setEnterNotificationParams(ConnectionParams connectionParams, int i, int i2) {
            DataConnection.this.log("DcInactiveState: setEnterNotificationParams cp,cause");
            DataConnection.this.mConnectionParams = connectionParams;
            DataConnection.this.mDisconnectParams = null;
            DataConnection.this.mDcFailCause = i;
            DataConnection.this.mHandoverFailureMode = i2;
        }

        public void setEnterNotificationParams(DisconnectParams disconnectParams) {
            DataConnection.this.log("DcInactiveState: setEnterNotificationParams dp");
            DataConnection.this.mConnectionParams = null;
            DataConnection.this.mDisconnectParams = disconnectParams;
            DataConnection.this.mDcFailCause = 0;
        }

        public void setEnterNotificationParams(int i) {
            DataConnection.this.mConnectionParams = null;
            DataConnection.this.mDisconnectParams = null;
            DataConnection.this.mDcFailCause = i;
        }

        public void enter() {
            DataConnection dataConnection = DataConnection.this;
            dataConnection.mTag++;
            dataConnection.log("DcInactiveState: enter() mTag=" + DataConnection.this.mTag);
            TelephonyStatsLog.write(75, 1, DataConnection.this.mPhone.getPhoneId(), DataConnection.this.mId, (long) DataConnection.this.getApnTypeBitmask(), DataConnection.this.canHandleDefault());
            DataConnection.this.mDataCallSessionStats.onDataCallDisconnected(DataConnection.this.mDcFailCause);
            if (DataConnection.this.mHandoverState == 2) {
                DataConnection.this.setHandoverState(3);
            }
            if (DataConnection.this.mHandoverSourceNetworkAgent != null) {
                DataConnection dataConnection2 = DataConnection.this.mHandoverSourceNetworkAgent.getDataConnection();
                if (dataConnection2 != null) {
                    DataConnection.this.mHandoverLocalLog.log("Handover failed. Reset the source dc " + dataConnection2.getName() + " state to idle");
                    dataConnection2.cancelHandover();
                } else {
                    DataConnection.this.mHandoverLocalLog.log("Handover failed and dangling agent found.");
                    DcNetworkAgent r0 = DataConnection.this.mHandoverSourceNetworkAgent;
                    DataConnection dataConnection3 = DataConnection.this;
                    r0.acquireOwnership(dataConnection3, dataConnection3.mTransportType);
                    DataConnection.this.log("Cleared dangling network agent. " + DataConnection.this.mHandoverSourceNetworkAgent);
                    DataConnection.this.mHandoverSourceNetworkAgent.unregister(DataConnection.this);
                    DataConnection.this.mHandoverSourceNetworkAgent.releaseOwnership(DataConnection.this);
                }
                DataConnection.this.mHandoverSourceNetworkAgent = null;
            }
            if (DataConnection.this.mConnectionParams != null) {
                DataConnection.this.log("DcInactiveState: enter notifyConnectCompleted +ALL failCause=" + DataFailCause.toString(DataConnection.this.mDcFailCause));
                DataConnection dataConnection4 = DataConnection.this;
                dataConnection4.notifyConnectCompleted(dataConnection4.mConnectionParams, DataConnection.this.mDcFailCause, DataConnection.this.mHandoverFailureMode, true);
            }
            if (DataConnection.this.mDisconnectParams != null) {
                DataConnection.this.log("DcInactiveState: enter notifyDisconnectCompleted +ALL failCause=" + DataFailCause.toString(DataConnection.this.mDcFailCause));
                DataConnection dataConnection5 = DataConnection.this;
                dataConnection5.notifyDisconnectCompleted(dataConnection5.mDisconnectParams, true);
            }
            if (DataConnection.this.mDisconnectParams == null && DataConnection.this.mConnectionParams == null && DataConnection.this.mDcFailCause != 0) {
                DataConnection.this.log("DcInactiveState: enter notifyAllDisconnectCompleted failCause=" + DataFailCause.toString(DataConnection.this.mDcFailCause));
                DataConnection dataConnection6 = DataConnection.this;
                dataConnection6.notifyAllWithEvent((ApnContext) null, 270351, DataFailCause.toString(dataConnection6.mDcFailCause));
            }
            DataConnection.this.mDcController.removeActiveDcByCid(DataConnection.this);
            if (DataConnection.this.mApnSetting != null) {
                DataConnection.this.notifyDataConnectionState();
            }
            DataConnection.this.clearSettings();
        }

        public boolean processMessage(Message message) {
            switch (message.what) {
                case 262144:
                    DataConnection.this.log("DcInactiveState: mag.what=EVENT_CONNECT");
                    ConnectionParams connectionParams = (ConnectionParams) message.obj;
                    if (!DataConnection.this.initConnection(connectionParams)) {
                        DataConnection.this.log("DcInactiveState: msg.what=EVENT_CONNECT initConnection failed");
                        DataConnection.this.notifyConnectCompleted(connectionParams, 65538, -1, false);
                        DataConnection dataConnection = DataConnection.this;
                        dataConnection.transitionTo(dataConnection.mInactiveState);
                        return true;
                    }
                    int r0 = DataConnection.this.connect(connectionParams);
                    if (r0 != 0) {
                        DataConnection.this.log("DcInactiveState: msg.what=EVENT_CONNECT connect failed");
                        DataConnection.this.notifyConnectCompleted(connectionParams, r0, -1, false);
                        DataConnection dataConnection2 = DataConnection.this;
                        dataConnection2.transitionTo(dataConnection2.mInactiveState);
                        return true;
                    }
                    if (DataConnection.this.mSubId == -1) {
                        DataConnection.this.mSubId = connectionParams.mSubId;
                    }
                    DataConnection dataConnection3 = DataConnection.this;
                    dataConnection3.transitionTo(dataConnection3.mActivatingState);
                    return true;
                case DataConnection.EVENT_DISCONNECT /*262148*/:
                    DataConnection.this.log("DcInactiveState: msg.what=EVENT_DISCONNECT");
                    DataConnection.this.notifyDisconnectCompleted((DisconnectParams) message.obj, false);
                    return true;
                case DataConnection.EVENT_DISCONNECT_ALL /*262150*/:
                    DataConnection.this.log("DcInactiveState: msg.what=EVENT_DISCONNECT_ALL");
                    DataConnection.this.notifyDisconnectCompleted((DisconnectParams) message.obj, false);
                    return true;
                case DataConnection.EVENT_RESET /*262168*/:
                case DataConnection.EVENT_REEVALUATE_RESTRICTED_STATE /*262169*/:
                    DataConnection dataConnection4 = DataConnection.this;
                    dataConnection4.log("DcInactiveState: msg.what=" + DataConnection.this.getWhatToString(message.what) + ", ignore we're already done");
                    return true;
                default:
                    DataConnection dataConnection5 = DataConnection.this;
                    dataConnection5.log("DcInactiveState not handled msg.what=" + DataConnection.this.getWhatToString(message.what));
                    return false;
            }
        }
    }

    private class DcActivatingState extends State {
        private DcActivatingState() {
        }

        public void enter() {
            int r0 = DataConnection.this.getApnTypeBitmask();
            TelephonyStatsLog.write(75, 2, DataConnection.this.mPhone.getPhoneId(), DataConnection.this.mId, (long) r0, DataConnection.this.canHandleDefault());
            DataConnection.this.setHandoverState(1);
            DataConnection dataConnection = DataConnection.this;
            dataConnection.mRestrictedNetworkOverride = dataConnection.shouldRestrictNetwork();
            CarrierPrivilegesTracker carrierPrivilegesTracker = DataConnection.this.mPhone.getCarrierPrivilegesTracker();
            if (carrierPrivilegesTracker != null) {
                carrierPrivilegesTracker.registerCarrierPrivilegesListener(DataConnection.this.getHandler(), DataConnection.EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED, (Object) null);
            }
            DataConnection.this.notifyDataConnectionState();
            DataConnection.this.mDataCallSessionStats.onSetupDataCall(r0);
        }

        /* JADX WARNING: Code restructure failed: missing block: B:27:0x01f5, code lost:
            com.android.internal.telephony.dataconnection.DataConnection.m656$$Nest$mtearDownData(r12.this$0, r0);
            r1 = r12.this$0;
            r1.transitionTo(com.android.internal.telephony.dataconnection.DataConnection.m584$$Nest$fgetmDisconnectingErrorCreatingConnection(r1));
         */
        /* JADX WARNING: Code restructure failed: missing block: B:34:0x027e, code lost:
            com.android.internal.telephony.dataconnection.DataConnection.m576$$Nest$fgetmDataCallSessionStats(r12.this$0).onSetupDataCallResponse(r5, android.telephony.ServiceState.rilRadioTechnologyToNetworkType(r0.mRilRat), com.android.internal.telephony.dataconnection.DataConnection.m639$$Nest$mgetApnTypeBitmask(r12.this$0), com.android.internal.telephony.dataconnection.DataConnection.m573$$Nest$fgetmApnSetting(r12.this$0).getProtocol(), r13.mFailCause);
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public boolean processMessage(android.os.Message r13) {
            /*
                r12 = this;
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r2 = "DcActivatingState: msg="
                r1.append(r2)
                java.lang.String r2 = com.android.internal.telephony.dataconnection.DataConnection.msgToString(r13)
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.log(r1)
                int r0 = r13.what
                r1 = 0
                r2 = 1
                switch(r0) {
                    case 262144: goto L_0x02a0;
                    case 262145: goto L_0x007d;
                    case 262155: goto L_0x02a0;
                    case 262175: goto L_0x0069;
                    case 262179: goto L_0x005e;
                    case 262180: goto L_0x0053;
                    default: goto L_0x0021;
                }
            L_0x0021:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r2 = new java.lang.StringBuilder
                r2.<init>()
                java.lang.String r3 = "DcActivatingState not handled msg.what="
                r2.append(r3)
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r13 = r13.what
                java.lang.String r13 = r3.getWhatToString(r13)
                r2.append(r13)
                java.lang.String r13 = " RefCount="
                r2.append(r13)
                com.android.internal.telephony.dataconnection.DataConnection r12 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.util.Map r12 = r12.mApnContexts
                int r12 = r12.size()
                r2.append(r12)
                java.lang.String r12 = r2.toString()
                r0.log(r12)
                goto L_0x02a6
            L_0x0053:
                java.lang.Object r12 = r13.obj
                java.util.function.Consumer r12 = (java.util.function.Consumer) r12
                java.lang.Boolean r13 = java.lang.Boolean.TRUE
                r12.accept(r13)
                goto L_0x02a5
            L_0x005e:
                com.android.internal.telephony.dataconnection.DataConnection r12 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r13 = r12.mInactiveState
                r12.transitionTo(r13)
                goto L_0x02a5
            L_0x0069:
                java.lang.Object r13 = r13.obj
                android.os.AsyncResult r13 = (android.os.AsyncResult) r13
                java.lang.Object r13 = r13.result
                int[] r13 = (int[]) r13
                com.android.internal.telephony.dataconnection.DataConnection r12 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r0 = r13.length
                int[] r13 = java.util.Arrays.copyOf(r13, r0)
                r12.mAdministratorUids = r13
                goto L_0x02a5
            L_0x007d:
                java.lang.Object r0 = r13.obj
                com.android.internal.telephony.dataconnection.DataConnection$ConnectionParams r0 = (com.android.internal.telephony.dataconnection.DataConnection.ConnectionParams) r0
                android.os.Bundle r3 = r13.getData()
                java.lang.String r4 = "data_call_response"
                android.os.Parcelable r3 = r3.getParcelable(r4)
                r5 = r3
                android.telephony.data.DataCallResponse r5 = (android.telephony.data.DataCallResponse) r5
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r13 = r13.arg1
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r13 = r3.onSetupConnectionCompleted(r13, r5, r0)
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r3 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.ERROR_STALE
                if (r13 == r3) goto L_0x00c6
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$ConnectionParams r3 = r3.mConnectionParams
                if (r3 == r0) goto L_0x00c6
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r4 = new java.lang.StringBuilder
                r4.<init>()
                java.lang.String r6 = "DcActivatingState: WEIRD mConnectionsParams:"
                r4.append(r6)
                com.android.internal.telephony.dataconnection.DataConnection r6 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$ConnectionParams r6 = r6.mConnectionParams
                r4.append(r6)
                java.lang.String r6 = " != cp:"
                r4.append(r6)
                r4.append(r0)
                java.lang.String r4 = r4.toString()
                r3.loge(r4)
            L_0x00c6:
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r4 = new java.lang.StringBuilder
                r4.<init>()
                java.lang.String r6 = "DcActivatingState onSetupConnectionCompleted result="
                r4.append(r6)
                r4.append(r13)
                java.lang.String r6 = " dc="
                r4.append(r6)
                com.android.internal.telephony.dataconnection.DataConnection r6 = com.android.internal.telephony.dataconnection.DataConnection.this
                r4.append(r6)
                java.lang.String r4 = r4.toString()
                r3.log(r4)
                com.android.internal.telephony.dataconnection.ApnContext r3 = r0.mApnContext
                java.lang.StringBuilder r4 = new java.lang.StringBuilder
                r4.<init>()
                java.lang.String r6 = "onSetupConnectionCompleted result="
                r4.append(r6)
                r4.append(r13)
                java.lang.String r4 = r4.toString()
                com.android.internal.telephony.dataconnection.ApnContext.requestLog(r3, r4)
                int[] r3 = com.android.internal.telephony.dataconnection.DataConnection.AnonymousClass2.$SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult
                int r4 = r13.ordinal()
                r3 = r3[r4]
                r6 = -1
                r8 = 9223372036854775807(0x7fffffffffffffff, double:NaN)
                r4 = -1
                switch(r3) {
                    case 1: goto L_0x0270;
                    case 2: goto L_0x025b;
                    case 3: goto L_0x0205;
                    case 4: goto L_0x01ee;
                    case 5: goto L_0x01f5;
                    case 6: goto L_0x013d;
                    case 7: goto L_0x0117;
                    default: goto L_0x010f;
                }
            L_0x010f:
                java.lang.RuntimeException r12 = new java.lang.RuntimeException
                java.lang.String r13 = "Unknown SetupResult, should not happen"
                r12.<init>(r13)
                throw r12
            L_0x0117:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r3 = new java.lang.StringBuilder
                r3.<init>()
                java.lang.String r4 = "DcActivatingState: stale EVENT_SETUP_DATA_CONNECTION_DONE tag:"
                r3.append(r4)
                int r4 = r0.mTag
                r3.append(r4)
                java.lang.String r4 = " != mTag:"
                r3.append(r4)
                com.android.internal.telephony.dataconnection.DataConnection r4 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r4 = r4.mTag
                r3.append(r4)
                java.lang.String r3 = r3.toString()
                r1.loge(r3)
                goto L_0x027e
            L_0x013d:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                long r10 = r1.getSuggestedRetryDelay(r5)
                int r1 = (r10 > r8 ? 1 : (r10 == r8 ? 0 : -1))
                if (r1 != 0) goto L_0x0149
                r6 = r8
                goto L_0x0154
            L_0x0149:
                r8 = 0
                int r1 = (r10 > r8 ? 1 : (r10 == r8 ? 0 : -1))
                if (r1 < 0) goto L_0x0154
                long r6 = android.os.SystemClock.elapsedRealtime()
                long r6 = r6 + r10
            L_0x0154:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r1 = r1.mHandoverFailureMode
                int r3 = r0.mRequestType
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r8 = r8.mDcFailCause
                int r1 = com.android.internal.telephony.dataconnection.DcTracker.calculateNewRetryRequestType(r1, r3, r8)
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcTracker r3 = r3.mDct
                com.android.internal.telephony.dataconnection.DataThrottler r3 = r3.getDataThrottler()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r8 = r8.getApnTypeBitmask()
                r3.setRetryTime(r8, r6, r1)
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r3 = "DcActivatingState: ERROR_DATA_SERVICE_SPECIFIC_ERROR  delay="
                r1.append(r3)
                r1.append(r10)
                java.lang.String r3 = " result="
                r1.append(r3)
                r1.append(r13)
                java.lang.String r3 = " result.isRadioRestartFailure="
                r1.append(r3)
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.Phone r3 = r3.mPhone
                android.content.Context r3 = r3.getContext()
                int r6 = r13.mFailCause
                com.android.internal.telephony.dataconnection.DataConnection r7 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.Phone r7 = r7.mPhone
                int r7 = r7.getSubId()
                boolean r3 = android.telephony.DataFailCause.isRadioRestartFailure(r3, r6, r7)
                r1.append(r3)
                java.lang.String r3 = " isPermanentFailure="
                r1.append(r3)
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcTracker r3 = r3.mDct
                int r6 = r13.mFailCause
                boolean r3 = r3.isPermanentFailure(r6)
                r1.append(r3)
                java.lang.String r1 = r1.toString()
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                r3.log(r1)
                com.android.internal.telephony.dataconnection.ApnContext r3 = r0.mApnContext
                com.android.internal.telephony.dataconnection.ApnContext.requestLog(r3, r1)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r1 = r1.mInactiveState
                int r3 = r13.mFailCause
                if (r5 == 0) goto L_0x01e0
                int r4 = r5.getHandoverFailureMode()
            L_0x01e0:
                r1.setEnterNotificationParams(r0, r3, r4)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r3 = r1.mInactiveState
                r1.transitionTo(r3)
                goto L_0x027e
            L_0x01ee:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.String r3 = "DcActivatingState: NO_DEFAULT_DATA"
                r1.log(r3)
            L_0x01f5:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r1.tearDownData(r0)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcDisconnectionErrorCreatingConnection r3 = r1.mDisconnectingErrorCreatingConnection
                r1.transitionTo(r3)
                goto L_0x027e
            L_0x0205:
                com.android.internal.telephony.dataconnection.ApnContext r1 = r0.mApnContext
                if (r1 == 0) goto L_0x021d
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcTracker r1 = r1.mDct
                com.android.internal.telephony.dataconnection.DataThrottler r1 = r1.getDataThrottler()
                com.android.internal.telephony.dataconnection.ApnContext r3 = r0.mApnContext
                int r3 = r3.getApnTypeBitmask()
                r1.setRetryTime(r3, r8, r2)
                r6 = r8
            L_0x021d:
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r3 = "DcActivatingState: "
                r1.append(r3)
                int r3 = r13.mFailCause
                java.lang.String r3 = android.telephony.DataFailCause.toString(r3)
                r1.append(r3)
                java.lang.String r3 = " retry="
                r1.append(r3)
                r1.append(r6)
                java.lang.String r1 = r1.toString()
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                r3.log(r1)
                com.android.internal.telephony.dataconnection.ApnContext r3 = r0.mApnContext
                com.android.internal.telephony.dataconnection.ApnContext.requestLog(r3, r1)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r1 = r1.mInactiveState
                int r3 = r13.mFailCause
                r1.setEnterNotificationParams(r0, r3, r4)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r3 = r1.mInactiveState
                r1.transitionTo(r3)
                goto L_0x027e
            L_0x025b:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r1 = r1.mInactiveState
                int r3 = r13.mFailCause
                r1.setEnterNotificationParams(r0, r3, r4)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r3 = r1.mInactiveState
                r1.transitionTo(r3)
                goto L_0x027e
            L_0x0270:
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                r3.mDcFailCause = r1
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcActiveState r3 = r1.mActiveState
                r1.transitionTo(r3)
            L_0x027e:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.metrics.DataCallSessionStats r4 = r1.mDataCallSessionStats
                int r0 = r0.mRilRat
                int r6 = android.telephony.ServiceState.rilRadioTechnologyToNetworkType(r0)
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r7 = r0.getApnTypeBitmask()
                com.android.internal.telephony.dataconnection.DataConnection r12 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.telephony.data.ApnSetting r12 = r12.mApnSetting
                int r8 = r12.getProtocol()
                int r9 = r13.mFailCause
                r4.onSetupDataCallResponse(r5, r6, r7, r8, r9)
                goto L_0x02a5
            L_0x02a0:
                com.android.internal.telephony.dataconnection.DataConnection r12 = com.android.internal.telephony.dataconnection.DataConnection.this
                r12.deferMessage(r13)
            L_0x02a5:
                r1 = r2
            L_0x02a6:
                return r1
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.DcActivatingState.processMessage(android.os.Message):boolean");
        }
    }

    /* renamed from: com.android.internal.telephony.dataconnection.DataConnection$2  reason: invalid class name */
    static /* synthetic */ class AnonymousClass2 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult;

        /* JADX WARNING: Can't wrap try/catch for region: R(14:0|1|2|3|4|5|6|7|8|9|10|11|12|(3:13|14|16)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(16:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|16) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult[] r0 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult = r0
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r1 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.SUCCESS     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r1 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.ERROR_RADIO_NOT_AVAILABLE     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r1 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.ERROR_DUPLICATE_CID     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r1 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.ERROR_NO_DEFAULT_CONNECTION     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r1 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.ERROR_INVALID_ARG     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r1 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.ERROR_DATA_SERVICE_SPECIFIC_ERROR     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$dataconnection$DataConnection$SetupResult     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.dataconnection.DataConnection$SetupResult r1 = com.android.internal.telephony.dataconnection.DataConnection.SetupResult.ERROR_STALE     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.AnonymousClass2.<clinit>():void");
        }
    }

    private class DcActiveState extends State {
        private DcActiveState() {
        }

        public void enter() {
            NetworkProvider networkProvider;
            DataConnection.this.log("DcActiveState: enter dc=" + DataConnection.this);
            TelephonyStatsLog.write(75, 3, DataConnection.this.mPhone.getPhoneId(), DataConnection.this.mId, (long) DataConnection.this.getApnTypeBitmask(), DataConnection.this.canHandleDefault());
            DataConnection.this.notifyAllWithEvent((ApnContext) null, 270336, PhoneInternalInterface.REASON_CONNECTED);
            DataConnection.this.mPhone.getCallTracker().registerForVoiceCallStarted(DataConnection.this.getHandler(), DataConnection.EVENT_DATA_CONNECTION_VOICE_CALL_STARTED, (Object) null);
            DataConnection.this.mPhone.getCallTracker().registerForVoiceCallEnded(DataConnection.this.getHandler(), DataConnection.EVENT_DATA_CONNECTION_VOICE_CALL_ENDED, (Object) null);
            DataConnection.this.mDcController.addActiveDcByCid(DataConnection.this);
            DataConnection dataConnection = DataConnection.this;
            dataConnection.updateTcpBufferSizes(dataConnection.mRilRat);
            DataConnection dataConnection2 = DataConnection.this;
            dataConnection2.updateLinkBandwidthsFromCarrierConfig(dataConnection2.mRilRat);
            NetworkAgentConfig.Builder builder = new NetworkAgentConfig.Builder();
            builder.setLegacyType(0);
            builder.setLegacyTypeName(DataConnection.NETWORK_TYPE);
            int r3 = DataConnection.this.getNetworkType();
            builder.setLegacySubType(r3);
            builder.setLegacySubTypeName(TelephonyManager.getNetworkTypeName(r3));
            builder.setLegacyExtraInfo(DataConnection.this.mApnSetting.getApnName());
            if (DataConnection.this.mPhone.getCarrierSignalAgent().hasRegisteredReceivers("android.telephony.action.CARRIER_SIGNAL_REDIRECTED")) {
                builder.setProvisioningNotificationEnabled(false);
            }
            String subscriberId = DataConnection.this.mPhone.getSubscriberId();
            if (!TextUtils.isEmpty(subscriberId)) {
                builder.setSubscriberId(subscriberId);
            }
            if (DataConnection.this.shouldSkip464Xlat()) {
                builder.setNat64DetectionEnabled(false);
            }
            DataConnection dataConnection3 = DataConnection.this;
            dataConnection3.mUnmeteredUseOnly = dataConnection3.isUnmeteredUseOnly();
            DataConnection dataConnection4 = DataConnection.this;
            dataConnection4.mMmsUseOnly = dataConnection4.isMmsUseOnly();
            DataConnection dataConnection5 = DataConnection.this;
            dataConnection5.mEnterpriseUse = dataConnection5.isEnterpriseUse();
            DataConnection.this.log("mRestrictedNetworkOverride = " + DataConnection.this.mRestrictedNetworkOverride + ", mUnmeteredUseOnly = " + DataConnection.this.mUnmeteredUseOnly + ", mMmsUseOnly = " + DataConnection.this.mMmsUseOnly + ", mEnterpriseUse = " + DataConnection.this.mEnterpriseUse);
            DataConnection.this.mVcnManager.addVcnNetworkPolicyChangeListener(new HandlerExecutor(DataConnection.this.getHandler()), DataConnection.this.mVcnPolicyChangeListener);
            if (DataConnection.this.mConnectionParams == null || DataConnection.this.mConnectionParams.mRequestType != 2) {
                DataConnection dataConnection6 = DataConnection.this;
                dataConnection6.mScore = dataConnection6.calculateScore();
                TelephonyNetworkFactory networkFactory = PhoneFactory.getNetworkFactory(DataConnection.this.mPhone.getPhoneId());
                if (networkFactory == null) {
                    networkProvider = null;
                } else {
                    networkProvider = networkFactory.getProvider();
                }
                DataConnection dataConnection7 = DataConnection.this;
                dataConnection7.mDisabledApnTypeBitMask = dataConnection7.mDisabledApnTypeBitMask | DataConnection.this.getDisallowedApnTypes();
                DataConnection.this.updateLinkPropertiesHttpProxy();
                DataConnection dataConnection8 = DataConnection.this;
                DataConnection dataConnection9 = DataConnection.this;
                dataConnection8.mNetworkAgent = new DcNetworkAgent(dataConnection9, dataConnection9.mPhone, DataConnection.this.mScore, builder.build(), networkProvider, DataConnection.this.mTransportType);
                if (DataConnection.this.mVcnManager.applyVcnNetworkPolicy(DataConnection.this.getNetworkCapabilities(), DataConnection.this.getLinkProperties()).isTeardownRequested()) {
                    DataConnection.this.tearDownAll(PhoneInternalInterface.REASON_VCN_REQUESTED_TEARDOWN, 2, (Message) null);
                } else {
                    DataConnection.this.mNetworkAgent.markConnected();
                }
                DataConnection dataConnection10 = DataConnection.this;
                dataConnection10.sendMessage(dataConnection10.obtainMessage(DataConnection.EVENT_UPDATE_SUSPENDED_STATE));
            } else {
                DataConnection dataConnectionByApnType = DataConnection.this.mPhone.getDcTracker(DataConnection.this.getHandoverSourceTransport()).getDataConnectionByApnType(DataConnection.this.mConnectionParams.mApnContext.getApnType());
                if (dataConnectionByApnType != null) {
                    dataConnectionByApnType.setHandoverState(3);
                }
                if (DataConnection.this.mHandoverSourceNetworkAgent != null) {
                    String str = "Transfer network agent " + DataConnection.this.mHandoverSourceNetworkAgent.getTag() + " successfully.";
                    DataConnection.this.log(str);
                    DataConnection.this.mHandoverLocalLog.log(str);
                    DataConnection dataConnection11 = DataConnection.this;
                    dataConnection11.mNetworkAgent = dataConnection11.mHandoverSourceNetworkAgent;
                    DcNetworkAgent r0 = DataConnection.this.mNetworkAgent;
                    DataConnection dataConnection12 = DataConnection.this;
                    r0.acquireOwnership(dataConnection12, dataConnection12.mTransportType);
                    DataConnection.this.mNetworkAgent.updateLegacySubtype(DataConnection.this);
                    DataConnection.this.mNetworkAgent.sendNetworkCapabilities(DataConnection.this.getNetworkCapabilities(), DataConnection.this);
                    DataConnection.this.mNetworkAgent.sendLinkProperties(DataConnection.this.mLinkProperties, DataConnection.this);
                    DataConnection.this.mHandoverSourceNetworkAgent = null;
                } else {
                    DataConnection.this.loge("Failed to get network agent from original data connection");
                    DataConnection.this.mHandoverLocalLog.log("Failed to get network agent from original data connection");
                    return;
                }
            }
            DataConnection.this.syncQosToNetworkAgent();
            if (DataConnection.this.mTransportType == 1) {
                DataConnection.this.mPhone.mCi.registerForNattKeepaliveStatus(DataConnection.this.getHandler(), DataConnection.EVENT_KEEPALIVE_STATUS, (Object) null);
                DataConnection.this.mPhone.mCi.registerForLceInfo(DataConnection.this.getHandler(), DataConnection.EVENT_LINK_CAPACITY_CHANGED, (Object) null);
            }
            DataConnection.this.notifyDataConnectionState();
            TelephonyMetrics instance = TelephonyMetrics.getInstance();
            int phoneId = DataConnection.this.mPhone.getPhoneId();
            DataConnection dataConnection13 = DataConnection.this;
            instance.writeRilDataCallEvent(phoneId, dataConnection13.mCid, dataConnection13.getApnTypeBitmask(), 1);
        }

        public void exit() {
            DataConnection dataConnection = DataConnection.this;
            dataConnection.log("DcActiveState: exit dc=" + this);
            DataConnection.this.mPhone.getCallTracker().unregisterForVoiceCallStarted(DataConnection.this.getHandler());
            DataConnection.this.mPhone.getCallTracker().unregisterForVoiceCallEnded(DataConnection.this.getHandler());
            if (DataConnection.this.mTransportType == 1) {
                DataConnection.this.mPhone.mCi.unregisterForNattKeepaliveStatus(DataConnection.this.getHandler());
                DataConnection.this.mPhone.mCi.unregisterForLceInfo(DataConnection.this.getHandler());
            }
            if (DataConnection.this.mNetworkAgent != null) {
                DataConnection.this.syncQosToNetworkAgent();
                if (DataConnection.this.mHandoverState == 1) {
                    DataConnection.this.mNetworkAgent.unregister(DataConnection.this);
                }
                DataConnection.this.mNetworkAgent.releaseOwnership(DataConnection.this);
            }
            DataConnection.this.mNetworkAgent = null;
            TelephonyMetrics instance = TelephonyMetrics.getInstance();
            int phoneId = DataConnection.this.mPhone.getPhoneId();
            DataConnection dataConnection2 = DataConnection.this;
            instance.writeRilDataCallEvent(phoneId, dataConnection2.mCid, dataConnection2.getApnTypeBitmask(), 2);
            DataConnection.this.mVcnManager.removeVcnNetworkPolicyChangeListener(DataConnection.this.mVcnPolicyChangeListener);
            CarrierPrivilegesTracker carrierPrivilegesTracker = DataConnection.this.mPhone.getCarrierPrivilegesTracker();
            if (carrierPrivilegesTracker != null) {
                carrierPrivilegesTracker.unregisterCarrierPrivilegesListener(DataConnection.this.getHandler());
            }
        }

        /* JADX WARNING: Removed duplicated region for block: B:81:0x0398  */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public boolean processMessage(android.os.Message r9) {
            /*
                r8 = this;
                int r0 = r9.what
                java.lang.String r1 = " dc="
                r2 = 0
                r3 = 0
                r4 = 1
                switch(r0) {
                    case 262144: goto L_0x0651;
                    case 262148: goto L_0x0573;
                    case 262150: goto L_0x0539;
                    case 262153: goto L_0x050a;
                    case 262183: goto L_0x04c3;
                    default: goto L_0x000a;
                }
            L_0x000a:
                java.lang.String r1 = "modem"
                java.lang.String r5 = "carrier_config"
                switch(r0) {
                    case 262155: goto L_0x0406;
                    case 262156: goto L_0x03e0;
                    case 262157: goto L_0x03e0;
                    case 262158: goto L_0x03ab;
                    case 262159: goto L_0x038b;
                    case 262160: goto L_0x038b;
                    case 262161: goto L_0x034e;
                    case 262162: goto L_0x031b;
                    case 262163: goto L_0x02cd;
                    case 262164: goto L_0x0268;
                    case 262165: goto L_0x0227;
                    case 262166: goto L_0x01c8;
                    case 262167: goto L_0x0193;
                    default: goto L_0x0011;
                }
            L_0x0011:
                switch(r0) {
                    case 262169: goto L_0x0126;
                    case 262170: goto L_0x011f;
                    case 262171: goto L_0x00d9;
                    case 262172: goto L_0x009c;
                    case 262173: goto L_0x0070;
                    case 262174: goto L_0x0070;
                    case 262175: goto L_0x0043;
                    case 262176: goto L_0x038b;
                    case 262177: goto L_0x038b;
                    case 262178: goto L_0x0034;
                    default: goto L_0x0014;
                }
            L_0x0014:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r2 = "DcActiveState not handled msg.what="
                r1.append(r2)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r9 = r9.what
                java.lang.String r8 = r8.getWhatToString(r9)
                r1.append(r8)
                java.lang.String r8 = r1.toString()
                r0.log(r8)
                goto L_0x06a7
            L_0x0034:
                java.lang.Object r8 = r9.obj
                java.util.function.Consumer r8 = (java.util.function.Consumer) r8
                int r9 = r9.arg1
                java.lang.Integer r9 = java.lang.Integer.valueOf(r9)
                r8.accept(r9)
                goto L_0x06a6
            L_0x0043:
                java.lang.Object r9 = r9.obj
                android.os.AsyncResult r9 = (android.os.AsyncResult) r9
                java.lang.Object r9 = r9.result
                int[] r9 = (int[]) r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r1 = r9.length
                int[] r9 = java.util.Arrays.copyOf(r9, r1)
                r0.mAdministratorUids = r9
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r8)
                goto L_0x06a6
            L_0x0070:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r9 = r9.isBandwidthSourceKey(r5)
                if (r9 == 0) goto L_0x0081
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r0 = r9.mRilRat
                r9.updateLinkBandwidthsFromCarrierConfig(r0)
            L_0x0081:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r8)
                goto L_0x06a6
            L_0x009c:
                java.lang.Object r9 = r9.obj
                java.lang.Boolean r9 = (java.lang.Boolean) r9
                boolean r9 = r9.booleanValue()
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r0 = r0.mUnmeteredOverride
                if (r9 != r0) goto L_0x00ae
                goto L_0x06a6
            L_0x00ae:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.mUnmeteredOverride = r9
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.updateLegacySubtype(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r8)
                goto L_0x06a6
            L_0x00d9:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r0 = r9.mRilRat
                r9.updateTcpBufferSizes(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r9 = r9.isBandwidthSourceKey(r5)
                if (r9 == 0) goto L_0x00f3
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r0 = r9.mRilRat
                r9.updateLinkBandwidthsFromCarrierConfig(r0)
            L_0x00f3:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.LinkProperties r0 = r0.mLinkProperties
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendLinkProperties(r0, r1)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r8)
                goto L_0x06a6
            L_0x011f:
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r8.updateScore()
                goto L_0x06a6
            L_0x0126:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r9 = r9.mRestrictedNetworkOverride
                if (r9 == 0) goto L_0x0162
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r9 = r9.shouldRestrictNetwork()
                if (r9 != 0) goto L_0x0162
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r1 = "Data connection becomes not-restricted. dc="
                r0.append(r1)
                r0.append(r8)
                java.lang.String r0 = r0.toString()
                r9.log(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.mRestrictedNetworkOverride = r3
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r1)
            L_0x0162:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r9 = r9.mUnmeteredUseOnly
                if (r9 == 0) goto L_0x0188
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r9 = r9.isUnmeteredUseOnly()
                if (r9 != 0) goto L_0x0188
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.mUnmeteredUseOnly = r3
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r1)
            L_0x0188:
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r9 = r8.isMmsUseOnly()
                r8.mMmsUseOnly = r9
                goto L_0x06a6
            L_0x0193:
                java.lang.Object r9 = r9.obj
                android.os.AsyncResult r9 = (android.os.AsyncResult) r9
                java.lang.Throwable r0 = r9.exception
                if (r0 == 0) goto L_0x01b5
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r1 = "EVENT_LINK_CAPACITY_CHANGED e="
                r0.append(r1)
                java.lang.Throwable r9 = r9.exception
                r0.append(r9)
                java.lang.String r9 = r0.toString()
                r8.loge(r9)
                goto L_0x06a6
            L_0x01b5:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r0 = r0.isBandwidthSourceKey(r1)
                if (r0 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.Object r9 = r9.result
                java.util.List r9 = (java.util.List) r9
                r8.updateLinkBandwidthsFromModem(r9)
                goto L_0x06a6
            L_0x01c8:
                int r9 = r9.arg1
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r0 = r0.mNetworkAgent
                com.android.internal.telephony.dataconnection.DcNetworkAgent$DcKeepaliveTracker r0 = r0.keepaliveTracker
                int r0 = r0.getHandleForSlot(r9)
                if (r0 >= 0) goto L_0x01fb
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r2 = "No slot found for stopSocketKeepalive! "
                r1.append(r2)
                r1.append(r9)
                java.lang.String r1 = r1.toString()
                r0.loge(r1)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r8 = r8.mNetworkAgent
                r0 = -33
                r8.sendSocketKeepaliveEvent(r9, r0)
                goto L_0x06a6
            L_0x01fb:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r3 = new java.lang.StringBuilder
                r3.<init>()
                java.lang.String r5 = "Stopping keepalive with handle: "
                r3.append(r5)
                r3.append(r0)
                java.lang.String r3 = r3.toString()
                r1.logd(r3)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.Phone r1 = r1.mPhone
                com.android.internal.telephony.CommandsInterface r1 = r1.mCi
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r3 = 262164(0x40014, float:3.6737E-40)
                android.os.Message r8 = r8.obtainMessage(r3, r0, r9, r2)
                r1.stopNattKeepalive(r0, r8)
                goto L_0x06a6
            L_0x0227:
                java.lang.Object r0 = r9.obj
                android.net.KeepalivePacketData r0 = (android.net.KeepalivePacketData) r0
                int r1 = r9.arg1
                int r5 = r9.arg2
                int r5 = r5 * 1000
                com.android.internal.telephony.dataconnection.DataConnection r6 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r6 = r6.mTransportType
                if (r6 != r4) goto L_0x0251
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.Phone r9 = r9.mPhone
                com.android.internal.telephony.CommandsInterface r9 = r9.mCi
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r6 = r8.mCid
                r7 = 262163(0x40013, float:3.67369E-40)
                android.os.Message r8 = r8.obtainMessage(r7, r1, r3, r2)
                r9.startNattKeepalive(r6, r0, r5, r8)
                goto L_0x06a6
            L_0x0251:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r0 = r0.mNetworkAgent
                if (r0 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r8 = r8.mNetworkAgent
                int r9 = r9.arg1
                r0 = -20
                r8.sendSocketKeepaliveEvent(r9, r0)
                goto L_0x06a6
            L_0x0268:
                java.lang.Object r0 = r9.obj
                android.os.AsyncResult r0 = (android.os.AsyncResult) r0
                int r9 = r9.arg1
                java.lang.Throwable r1 = r0.exception
                if (r1 == 0) goto L_0x02a5
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r2 = new java.lang.StringBuilder
                r2.<init>()
                java.lang.String r3 = "EVENT_KEEPALIVE_STOPPED: error stopping keepalive for handle="
                r2.append(r3)
                r2.append(r9)
                java.lang.String r9 = " e="
                r2.append(r9)
                java.lang.Throwable r9 = r0.exception
                r2.append(r9)
                java.lang.String r9 = r2.toString()
                r1.loge(r9)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r8 = r8.mNetworkAgent
                com.android.internal.telephony.dataconnection.DcNetworkAgent$DcKeepaliveTracker r8 = r8.keepaliveTracker
                com.android.internal.telephony.data.KeepaliveStatus r9 = new com.android.internal.telephony.data.KeepaliveStatus
                r0 = 3
                r9.<init>((int) r0)
                r8.handleKeepaliveStatus(r9)
                goto L_0x06a6
            L_0x02a5:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r2 = "Keepalive Stop Requested for handle="
                r1.append(r2)
                r1.append(r9)
                java.lang.String r1 = r1.toString()
                r0.log(r1)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r8 = r8.mNetworkAgent
                com.android.internal.telephony.dataconnection.DcNetworkAgent$DcKeepaliveTracker r8 = r8.keepaliveTracker
                com.android.internal.telephony.data.KeepaliveStatus r0 = new com.android.internal.telephony.data.KeepaliveStatus
                r0.<init>((int) r9, (int) r4)
                r8.handleKeepaliveStatus(r0)
                goto L_0x06a6
            L_0x02cd:
                java.lang.Object r0 = r9.obj
                android.os.AsyncResult r0 = (android.os.AsyncResult) r0
                int r9 = r9.arg1
                java.lang.Throwable r1 = r0.exception
                if (r1 != 0) goto L_0x02f6
                java.lang.Object r1 = r0.result
                if (r1 != 0) goto L_0x02dc
                goto L_0x02f6
            L_0x02dc:
                com.android.internal.telephony.data.KeepaliveStatus r1 = (com.android.internal.telephony.data.KeepaliveStatus) r1
                if (r1 != 0) goto L_0x02e9
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.String r9 = "Null KeepaliveStatus received!"
                r8.loge(r9)
                goto L_0x06a6
            L_0x02e9:
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r8 = r8.mNetworkAgent
                com.android.internal.telephony.dataconnection.DcNetworkAgent$DcKeepaliveTracker r8 = r8.keepaliveTracker
                r8.handleKeepaliveStarted(r9, r1)
                goto L_0x06a6
            L_0x02f6:
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r2 = new java.lang.StringBuilder
                r2.<init>()
                java.lang.String r3 = "EVENT_KEEPALIVE_STARTED: error starting keepalive, e="
                r2.append(r3)
                java.lang.Throwable r0 = r0.exception
                r2.append(r0)
                java.lang.String r0 = r2.toString()
                r1.loge(r0)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r8 = r8.mNetworkAgent
                r0 = -31
                r8.sendSocketKeepaliveEvent(r9, r0)
                goto L_0x06a6
            L_0x031b:
                java.lang.Object r9 = r9.obj
                android.os.AsyncResult r9 = (android.os.AsyncResult) r9
                java.lang.Throwable r0 = r9.exception
                if (r0 == 0) goto L_0x033b
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r2 = "EVENT_KEEPALIVE_STATUS: error in keepalive, e="
                r1.append(r2)
                java.lang.Throwable r2 = r9.exception
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.loge(r1)
            L_0x033b:
                java.lang.Object r9 = r9.result
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.data.KeepaliveStatus r9 = (com.android.internal.telephony.data.KeepaliveStatus) r9
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r8 = r8.mNetworkAgent
                com.android.internal.telephony.dataconnection.DcNetworkAgent$DcKeepaliveTracker r8 = r8.keepaliveTracker
                r8.handleKeepaliveStatus(r9)
                goto L_0x06a6
            L_0x034e:
                java.lang.Object r9 = r9.obj
                java.lang.Boolean r9 = (java.lang.Boolean) r9
                boolean r9 = r9.booleanValue()
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r0 = r0.mCongestedOverride
                if (r9 != r0) goto L_0x0360
                goto L_0x06a6
            L_0x0360:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.mCongestedOverride = r9
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.updateLegacySubtype(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r8)
                goto L_0x06a6
            L_0x038b:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.updateSuspendState()
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r8)
                goto L_0x06a6
            L_0x03ab:
                java.lang.Object r9 = r9.obj
                android.os.AsyncResult r9 = (android.os.AsyncResult) r9
                java.lang.Throwable r0 = r9.exception
                if (r0 == 0) goto L_0x03cd
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r1 = "EVENT_BW_REFRESH_RESPONSE: error ignoring, e="
                r0.append(r1)
                java.lang.Throwable r9 = r9.exception
                r0.append(r9)
                java.lang.String r9 = r0.toString()
                r8.log(r9)
                goto L_0x06a6
            L_0x03cd:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r0 = r0.isBandwidthSourceKey(r1)
                if (r0 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.Object r9 = r9.result
                java.util.List r9 = (java.util.List) r9
                r8.updateLinkBandwidthsFromModem(r9)
                goto L_0x06a6
            L_0x03e0:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.updateLegacySubtype(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r8)
                goto L_0x06a6
            L_0x0406:
                java.lang.Object r9 = r9.obj
                android.os.AsyncResult r9 = (android.os.AsyncResult) r9
                java.lang.Object r9 = r9.result
                android.util.Pair r9 = (android.util.Pair) r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.Object r1 = r9.first
                java.lang.Integer r1 = (java.lang.Integer) r1
                int r1 = r1.intValue()
                r0.mDataRegState = r1
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.Object r1 = r9.second
                java.lang.Integer r1 = (java.lang.Integer) r1
                int r1 = r1.intValue()
                r0.updateTcpBufferSizes(r1)
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                boolean r0 = r0.isBandwidthSourceKey(r5)
                if (r0 == 0) goto L_0x043d
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.Object r1 = r9.second
                java.lang.Integer r1 = (java.lang.Integer) r1
                int r1 = r1.intValue()
                r0.updateLinkBandwidthsFromCarrierConfig(r1)
            L_0x043d:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.Object r9 = r9.second
                java.lang.Integer r9 = (java.lang.Integer) r9
                int r9 = r9.intValue()
                r0.mRilRat = r9
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r1 = "DcActiveState: EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED drs="
                r0.append(r1)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r1 = r1.mDataRegState
                r0.append(r1)
                java.lang.String r1 = " mRilRat="
                r0.append(r1)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r1 = r1.mRilRat
                r0.append(r1)
                java.lang.String r0 = r0.toString()
                r9.log(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.updateSuspendState()
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                if (r9 == 0) goto L_0x04ae
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.updateLegacySubtype(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r0 = r0.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendNetworkCapabilities(r0, r1)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r9 = r9.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.LinkProperties r0 = r0.mLinkProperties
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r9.sendLinkProperties(r0, r1)
            L_0x04ae:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.metrics.DataCallSessionStats r9 = r9.mDataCallSessionStats
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r8 = r8.mRilRat
                int r8 = android.telephony.ServiceState.rilRadioTechnologyToNetworkType(r8)
                r9.onDrsOrRatChanged(r8)
                goto L_0x06a6
            L_0x04c3:
                java.lang.Object r9 = r9.obj
                android.os.AsyncResult r9 = (android.os.AsyncResult) r9
                java.lang.Throwable r0 = r9.exception
                if (r0 == 0) goto L_0x04e5
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r1 = "EVENT_LINK_BANDWIDTH_ESTIMATOR_UPDATE e="
                r0.append(r1)
                java.lang.Throwable r9 = r9.exception
                r0.append(r9)
                java.lang.String r9 = r0.toString()
                r8.loge(r9)
                goto L_0x06a6
            L_0x04e5:
                java.lang.Object r9 = r9.result
                android.util.Pair r9 = (android.util.Pair) r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.String r1 = "bandwidth_estimator"
                boolean r0 = r0.isBandwidthSourceKey(r1)
                if (r0 == 0) goto L_0x06a6
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.Object r0 = r9.first
                java.lang.Integer r0 = (java.lang.Integer) r0
                int r0 = r0.intValue()
                java.lang.Object r9 = r9.second
                java.lang.Integer r9 = (java.lang.Integer) r9
                int r9 = r9.intValue()
                r8.updateLinkBandwidthsFromBandwidthEstimator(r0, r9)
                goto L_0x06a6
            L_0x050a:
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r1 = "DcActiveState EVENT_LOST_CONNECTION dc="
                r0.append(r1)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.append(r1)
                java.lang.String r0 = r0.toString()
                r9.log(r0)
                com.android.internal.telephony.dataconnection.DataConnection r9 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r9 = r9.mInactiveState
                r0 = 65540(0x10004, float:9.1841E-41)
                r9.setEnterNotificationParams((int) r0)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcInactiveState r9 = r8.mInactiveState
                r8.transitionTo(r9)
                goto L_0x06a6
            L_0x0539:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r3 = "DcActiveState EVENT_DISCONNECT clearing apn contexts, dc="
                r1.append(r3)
                com.android.internal.telephony.dataconnection.DataConnection r3 = com.android.internal.telephony.dataconnection.DataConnection.this
                r1.append(r3)
                java.lang.String r1 = r1.toString()
                r0.log(r1)
                java.lang.Object r9 = r9.obj
                com.android.internal.telephony.dataconnection.DataConnection$DisconnectParams r9 = (com.android.internal.telephony.dataconnection.DataConnection.DisconnectParams) r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.mDisconnectParams = r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.mConnectionParams = r2
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r1 = r0.mTag
                r9.mTag = r1
                r0.tearDownData(r9)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcDisconnectingState r9 = r8.mDisconnectingState
                r8.transitionTo(r9)
                goto L_0x06a6
            L_0x0573:
                java.lang.Object r9 = r9.obj
                com.android.internal.telephony.dataconnection.DataConnection$DisconnectParams r9 = (com.android.internal.telephony.dataconnection.DataConnection.DisconnectParams) r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r5 = new java.lang.StringBuilder
                r5.<init>()
                java.lang.String r6 = "DcActiveState: EVENT_DISCONNECT dp="
                r5.append(r6)
                r5.append(r9)
                r5.append(r1)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r5.append(r1)
                java.lang.String r1 = r5.toString()
                r0.log(r1)
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.util.Map r0 = r0.mApnContexts
                com.android.internal.telephony.dataconnection.ApnContext r1 = r9.mApnContext
                boolean r0 = r0.containsKey(r1)
                if (r0 == 0) goto L_0x0629
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r5 = "DcActiveState msg.what=EVENT_DISCONNECT RefCount="
                r1.append(r5)
                com.android.internal.telephony.dataconnection.DataConnection r5 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.util.Map r5 = r5.mApnContexts
                int r5 = r5.size()
                r1.append(r5)
                java.lang.String r1 = r1.toString()
                r0.log(r1)
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.util.Map r0 = r0.mApnContexts
                int r0 = r0.size()
                if (r0 != r4) goto L_0x05f6
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.util.Map r0 = r0.mApnContexts
                r0.clear()
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.mDisconnectParams = r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.mConnectionParams = r2
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r1 = r0.mTag
                r9.mTag = r1
                r0.tearDownData(r9)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DataConnection$DcDisconnectingState r9 = r8.mDisconnectingState
                r8.transitionTo(r9)
                goto L_0x06a6
            L_0x05f6:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.util.Map r0 = r0.mApnContexts
                com.android.internal.telephony.dataconnection.ApnContext r1 = r9.mApnContext
                r0.remove(r1)
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r1 = r0.mDisabledApnTypeBitMask
                com.android.internal.telephony.dataconnection.ApnContext r2 = r9.mApnContext
                int r2 = r2.getApnTypeBitmask()
                r1 = r1 | r2
                r0.mDisabledApnTypeBitMask = r1
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r0 = r0.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r1 = r1.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r2 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.sendNetworkCapabilities(r1, r2)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r8.notifyDisconnectCompleted(r9, r3)
                goto L_0x06a6
            L_0x0629:
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r1 = new java.lang.StringBuilder
                r1.<init>()
                java.lang.String r2 = "DcActiveState ERROR no such apnContext="
                r1.append(r2)
                com.android.internal.telephony.dataconnection.ApnContext r2 = r9.mApnContext
                r1.append(r2)
                java.lang.String r2 = " in this dc="
                r1.append(r2)
                com.android.internal.telephony.dataconnection.DataConnection r2 = com.android.internal.telephony.dataconnection.DataConnection.this
                r1.append(r2)
                java.lang.String r1 = r1.toString()
                r0.log(r1)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r8.notifyDisconnectCompleted(r9, r3)
                goto L_0x06a6
            L_0x0651:
                java.lang.Object r9 = r9.obj
                com.android.internal.telephony.dataconnection.DataConnection$ConnectionParams r9 = (com.android.internal.telephony.dataconnection.DataConnection.ConnectionParams) r9
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.util.Map r0 = r0.mApnContexts
                com.android.internal.telephony.dataconnection.ApnContext r2 = r9.mApnContext
                r0.put(r2, r9)
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                int r2 = r0.mDisabledApnTypeBitMask
                com.android.internal.telephony.dataconnection.ApnContext r5 = r9.mApnContext
                int r5 = r5.getApnTypeBitmask()
                int r5 = ~r5
                r2 = r2 & r5
                r0.mDisabledApnTypeBitMask = r2
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                com.android.internal.telephony.dataconnection.DcNetworkAgent r0 = r0.mNetworkAgent
                com.android.internal.telephony.dataconnection.DataConnection r2 = com.android.internal.telephony.dataconnection.DataConnection.this
                android.net.NetworkCapabilities r2 = r2.getNetworkCapabilities()
                com.android.internal.telephony.dataconnection.DataConnection r5 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0.sendNetworkCapabilities(r2, r5)
                com.android.internal.telephony.dataconnection.DataConnection r0 = com.android.internal.telephony.dataconnection.DataConnection.this
                java.lang.StringBuilder r2 = new java.lang.StringBuilder
                r2.<init>()
                java.lang.String r5 = "DcActiveState: EVENT_CONNECT cp="
                r2.append(r5)
                r2.append(r9)
                r2.append(r1)
                com.android.internal.telephony.dataconnection.DataConnection r1 = com.android.internal.telephony.dataconnection.DataConnection.this
                r2.append(r1)
                java.lang.String r1 = r2.toString()
                r0.log(r1)
                com.android.internal.telephony.dataconnection.DataConnection r8 = com.android.internal.telephony.dataconnection.DataConnection.this
                r0 = -1
                r8.notifyConnectCompleted(r9, r3, r0, r3)
            L_0x06a6:
                r3 = r4
            L_0x06a7:
                return r3
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataConnection.DcActiveState.processMessage(android.os.Message):boolean");
        }
    }

    private class DcDisconnectingState extends State {
        private DcDisconnectingState() {
        }

        public void enter() {
            TelephonyStatsLog.write(75, 4, DataConnection.this.mPhone.getPhoneId(), DataConnection.this.mId, (long) DataConnection.this.getApnTypeBitmask(), DataConnection.this.canHandleDefault());
            DataConnection.this.notifyDataConnectionState();
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            if (i == 262144) {
                DataConnection.this.log("DcDisconnectingState msg.what=EVENT_CONNECT. Defer. RefCount = " + DataConnection.this.mApnContexts.size());
                DataConnection.this.deferMessage(message);
                return true;
            } else if (i != DataConnection.EVENT_DEACTIVATE_DONE) {
                DataConnection.this.log("DcDisconnectingState not handled msg.what=" + DataConnection.this.getWhatToString(message.what));
                return false;
            } else {
                DisconnectParams disconnectParams = (DisconnectParams) message.obj;
                String str = "DcDisconnectingState msg.what=EVENT_DEACTIVATE_DONE RefCount=" + DataConnection.this.mApnContexts.size();
                DataConnection.this.log(str);
                ApnContext.requestLog(disconnectParams.mApnContext, str);
                DataConnection.this.updateQosParameters((DataCallResponse) null);
                int i2 = disconnectParams.mTag;
                DataConnection dataConnection = DataConnection.this;
                if (i2 == dataConnection.mTag) {
                    dataConnection.mInactiveState.setEnterNotificationParams(disconnectParams);
                    DataConnection dataConnection2 = DataConnection.this;
                    dataConnection2.transitionTo(dataConnection2.mInactiveState);
                    return true;
                }
                dataConnection.log("DcDisconnectState stale EVENT_DEACTIVATE_DONE dp.tag=" + disconnectParams.mTag + " mTag=" + DataConnection.this.mTag);
                return true;
            }
        }
    }

    private class DcDisconnectionErrorCreatingConnection extends State {
        private DcDisconnectionErrorCreatingConnection() {
        }

        public void enter() {
            TelephonyStatsLog.write(75, 5, DataConnection.this.mPhone.getPhoneId(), DataConnection.this.mId, (long) DataConnection.this.getApnTypeBitmask(), DataConnection.this.canHandleDefault());
            DataConnection.this.notifyDataConnectionState();
        }

        public boolean processMessage(Message message) {
            if (message.what != DataConnection.EVENT_DEACTIVATE_DONE) {
                DataConnection dataConnection = DataConnection.this;
                dataConnection.log("DcDisconnectionErrorCreatingConnection not handled msg.what=" + DataConnection.this.getWhatToString(message.what));
                return false;
            }
            ConnectionParams connectionParams = (ConnectionParams) message.obj;
            int i = connectionParams.mTag;
            DataConnection dataConnection2 = DataConnection.this;
            if (i == dataConnection2.mTag) {
                dataConnection2.log("DcDisconnectionErrorCreatingConnection msg.what=EVENT_DEACTIVATE_DONE");
                ApnContext.requestLog(connectionParams.mApnContext, "DcDisconnectionErrorCreatingConnection msg.what=EVENT_DEACTIVATE_DONE");
                DataConnection.this.mInactiveState.setEnterNotificationParams(connectionParams, 65538, -1);
                DataConnection dataConnection3 = DataConnection.this;
                dataConnection3.transitionTo(dataConnection3.mInactiveState);
            } else {
                dataConnection2.log("DcDisconnectionErrorCreatingConnection stale EVENT_DEACTIVATE_DONE dp.tag=" + connectionParams.mTag + ", mTag=" + DataConnection.this.mTag);
            }
            return true;
        }
    }

    public void bringUp(ApnContext apnContext, int i, int i2, Message message, int i3, int i4, int i5, boolean z) {
        StringBuilder sb = new StringBuilder();
        sb.append("bringUp: apnContext=");
        ApnContext apnContext2 = apnContext;
        sb.append(apnContext);
        sb.append(" onCompletedMsg=");
        sb.append(message);
        log(sb.toString());
        if (this.mApnSetting == null) {
            this.mApnSetting = apnContext.getApnSetting();
        }
        sendMessage(262144, (Object) new ConnectionParams(apnContext, i, i2, message, i3, i4, i5, z));
    }

    public void tearDown(ApnContext apnContext, String str, Message message) {
        log("tearDown: apnContext=" + apnContext + " reason=" + str + " onCompletedMsg=" + message);
        sendMessage((int) EVENT_DISCONNECT, (Object) new DisconnectParams(apnContext, str, 2, message));
    }

    /* access modifiers changed from: package-private */
    public void tearDownNow() {
        log("tearDownNow()");
        sendMessage(obtainMessage(EVENT_TEAR_DOWN_NOW));
    }

    public void tearDownAll(String str, int i, Message message) {
        log("tearDownAll: reason=" + str + ", releaseType=" + DcTracker.releaseTypeToString(i));
        sendMessage((int) EVENT_DISCONNECT_ALL, (Object) new DisconnectParams((ApnContext) null, str, i, message));
    }

    public void reset() {
        sendMessage((int) EVENT_RESET);
        log("reset");
    }

    /* access modifiers changed from: package-private */
    public void reevaluateRestrictedState() {
        sendMessage((int) EVENT_REEVALUATE_RESTRICTED_STATE);
        log("reevaluate restricted state");
    }

    /* access modifiers changed from: package-private */
    public void reevaluateDataConnectionProperties() {
        sendMessage((int) EVENT_REEVALUATE_DATA_CONNECTION_PROPERTIES);
        log("reevaluate data connection properties");
    }

    public ConnectionParams getConnectionParams() {
        return this.mConnectionParams;
    }

    public void updatePcscfAddr(DataCallResponse dataCallResponse) {
        this.mPcscfAddr = (String[]) dataCallResponse.getPcscfAddresses().stream().map(new DataConnection$$ExternalSyntheticLambda2()).toArray(new DataConnection$$ExternalSyntheticLambda3());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String[] lambda$updatePcscfAddr$6(int i) {
        return new String[i];
    }

    public String[] getPcscfAddresses() {
        return this.mPcscfAddr;
    }

    /* access modifiers changed from: private */
    public long getSuggestedRetryDelay(DataCallResponse dataCallResponse) {
        if (dataCallResponse == null) {
            return -1;
        }
        long retryDurationMillis = dataCallResponse.getRetryDurationMillis();
        if (retryDurationMillis < 0) {
            log("No suggested retry delay.");
            return -1;
        }
        HalVersion halVersion = this.mPhone.getHalVersion();
        HalVersion halVersion2 = RIL.RADIO_HAL_VERSION_1_6;
        if (halVersion.greaterOrEqual(halVersion2) && retryDurationMillis == Long.MAX_VALUE) {
            log("Network suggested not retrying.");
            return Long.MAX_VALUE;
        } else if (!this.mPhone.getHalVersion().less(halVersion2) || retryDurationMillis != 2147483647L) {
            return retryDurationMillis;
        } else {
            log("Network suggested not retrying.");
            return Long.MAX_VALUE;
        }
    }

    public List<ApnContext> getApnContexts() {
        return new ArrayList(this.mApnContexts.keySet());
    }

    private boolean isApnContextAttached(int i, boolean z) {
        boolean anyMatch = this.mApnContexts.keySet().stream().map(new DataConnection$$ExternalSyntheticLambda4()).anyMatch(new DataConnection$$ExternalSyntheticLambda5(i));
        if (!z) {
            return anyMatch;
        }
        boolean z2 = true;
        if (this.mApnContexts.size() != 1) {
            z2 = false;
        }
        return anyMatch & z2;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isApnContextAttached$7(int i, Integer num) {
        return num.intValue() == i;
    }

    /* access modifiers changed from: package-private */
    public DcNetworkAgent getNetworkAgent() {
        return this.mNetworkAgent;
    }

    /* access modifiers changed from: package-private */
    public void setHandoverState(int i) {
        if (this.mHandoverState != i) {
            String str = "State changed from " + handoverStateToString(this.mHandoverState) + " to " + handoverStateToString(i);
            this.mHandoverLocalLog.log(str);
            logd(str);
            this.mHandoverState = i;
        }
    }

    @VisibleForTesting
    public void setDataCallSessionStats(DataCallSessionStats dataCallSessionStats) {
        this.mDataCallSessionStats = dataCallSessionStats;
    }

    /* access modifiers changed from: protected */
    public String getWhatToString(int i) {
        return cmdToString(i);
    }

    /* access modifiers changed from: private */
    public static String msgToString(Message message) {
        if (message == null) {
            return "null";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("{what=");
        sb.append(cmdToString(message.what));
        sb.append(" when=");
        TimeUtils.formatDuration(message.getWhen() - SystemClock.uptimeMillis(), sb);
        if (message.arg1 != 0) {
            sb.append(" arg1=");
            sb.append(message.arg1);
        }
        if (message.arg2 != 0) {
            sb.append(" arg2=");
            sb.append(message.arg2);
        }
        if (message.obj != null) {
            sb.append(" obj=");
            sb.append(message.obj);
        }
        sb.append(" target=");
        sb.append(message.getTarget());
        sb.append(" replyTo=");
        sb.append(message.replyTo);
        sb.append("}");
        return sb.toString();
    }

    static void slog(String str) {
        Rlog.d("DC", str);
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Rlog.d(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void logd(String str) {
        Rlog.d(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void logv(String str) {
        Rlog.v(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void logi(String str) {
        Rlog.i(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void logw(String str) {
        Rlog.w(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str, Throwable th) {
        Rlog.e(getName(), str, th);
    }

    public synchronized String toStringSimple() {
        return getName() + ": State=" + getCurrentState().getName() + " mApnSetting=" + this.mApnSetting + " RefCount=" + this.mApnContexts.size() + " mCid=" + this.mCid + " mCreateTime=" + this.mCreateTime + " mLastastFailTime=" + this.mLastFailTime + " mLastFailCause=" + DataFailCause.toString(this.mLastFailCause) + " mTag=" + this.mTag + " mLinkProperties=" + this.mLinkProperties + " linkCapabilities=" + getNetworkCapabilities() + " mRestrictedNetworkOverride=" + this.mRestrictedNetworkOverride;
    }

    public String toString() {
        return "{" + toStringSimple() + " mApnContexts=" + this.mApnContexts + "}";
    }

    private boolean isNRConnected() {
        return this.mPhone.getServiceState().getNrState() == 3;
    }

    /* access modifiers changed from: private */
    public int getDisallowedApnTypes() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (!(carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mSubId)) == null)) {
            String str = this.mTransportType == 1 ? "carrier_wwan_disallowed_apn_types_string_array" : "carrier_wlan_disallowed_apn_types_string_array";
            if (configForSubId.getStringArray(str) != null) {
                String join = TextUtils.join(",", configForSubId.getStringArray(str));
                if (!TextUtils.isEmpty(join)) {
                    return ApnSetting.getApnTypesBitmaskFromString(join);
                }
            }
        }
        return 0;
    }

    private void dumpToLog() {
        dump((FileDescriptor) null, new PrintWriter(new StringWriter(0)) {
            public void flush() {
            }

            public void println(String str) {
                DataConnection.this.logd(str);
            }
        }, (String[]) null);
    }

    /* access modifiers changed from: private */
    public void updateScore() {
        int i = this.mScore;
        int calculateScore = calculateScore();
        this.mScore = calculateScore;
        if (i != calculateScore && this.mNetworkAgent != null) {
            log("Updating score from " + i + " to " + this.mScore);
            this.mNetworkAgent.sendNetworkScore(this.mScore, this);
        }
    }

    /* access modifiers changed from: private */
    public int calculateScore() {
        int i = 45;
        for (ApnContext networkRequests : this.mApnContexts.keySet()) {
            Iterator<NetworkRequest> it = networkRequests.getNetworkRequests().iterator();
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                NetworkRequest next = it.next();
                if (next.hasCapability(12) && next.getNetworkSpecifier() == null) {
                    i = 50;
                    break;
                }
            }
        }
        return i;
    }

    private int getState() {
        if (isInactive()) {
            return 0;
        }
        if (isActivating()) {
            return 1;
        }
        return isActive() ? this.mIsSuspended ? 3 : 2 : isDisconnecting() ? 4 : -1;
    }

    public PreciseDataConnectionState getPreciseDataConnectionState() {
        return new PreciseDataConnectionState.Builder().setTransportType(this.mTransportType).setId(this.mCid).setState(getState()).setApnSetting(this.mApnSetting).setLinkProperties(this.mLinkProperties).setNetworkType(getNetworkType()).setFailCause(this.mDcFailCause).build();
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, " ");
        indentingPrintWriter.print("DataConnection ");
        super.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.flush();
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("transport type=" + AccessNetworkConstants.transportTypeToString(this.mTransportType));
        indentingPrintWriter.println("mApnContexts.size=" + this.mApnContexts.size());
        indentingPrintWriter.println("mApnContexts=" + this.mApnContexts);
        indentingPrintWriter.println("mApnSetting=" + this.mApnSetting);
        indentingPrintWriter.println("mTag=" + this.mTag);
        indentingPrintWriter.println("mCid=" + this.mCid);
        indentingPrintWriter.println("mConnectionParams=" + this.mConnectionParams);
        indentingPrintWriter.println("mDisconnectParams=" + this.mDisconnectParams);
        indentingPrintWriter.println("mDcFailCause=" + DataFailCause.toString(this.mDcFailCause));
        indentingPrintWriter.println("mPhone=" + this.mPhone);
        indentingPrintWriter.println("mSubId=" + this.mSubId);
        indentingPrintWriter.println("mLinkProperties=" + this.mLinkProperties);
        indentingPrintWriter.flush();
        indentingPrintWriter.println("mDataRegState=" + this.mDataRegState);
        indentingPrintWriter.println("mHandoverState=" + handoverStateToString(this.mHandoverState));
        indentingPrintWriter.println("mRilRat=" + this.mRilRat);
        indentingPrintWriter.println("mNetworkCapabilities=" + getNetworkCapabilities());
        indentingPrintWriter.println("mCreateTime=" + TimeUtils.logTimeOfDay(this.mCreateTime));
        indentingPrintWriter.println("mLastFailTime=" + TimeUtils.logTimeOfDay(this.mLastFailTime));
        indentingPrintWriter.println("mLastFailCause=" + DataFailCause.toString(this.mLastFailCause));
        indentingPrintWriter.println("mUserData=" + this.mUserData);
        indentingPrintWriter.println("mRestrictedNetworkOverride=" + this.mRestrictedNetworkOverride);
        indentingPrintWriter.println("mUnmeteredUseOnly=" + this.mUnmeteredUseOnly);
        indentingPrintWriter.println("mMmsUseOnly=" + this.mMmsUseOnly);
        indentingPrintWriter.println("mEnterpriseUse=" + this.mEnterpriseUse);
        indentingPrintWriter.println("mUnmeteredOverride=" + this.mUnmeteredOverride);
        indentingPrintWriter.println("mCongestedOverride=" + this.mCongestedOverride);
        indentingPrintWriter.println("mDownlinkBandwidth" + this.mDownlinkBandwidth);
        indentingPrintWriter.println("mUplinkBandwidth=" + this.mUplinkBandwidth);
        indentingPrintWriter.println("mDefaultQos=" + this.mDefaultQos);
        indentingPrintWriter.println("mQosBearerSessions=" + this.mQosBearerSessions);
        indentingPrintWriter.println("disallowedApnTypes=" + ApnSetting.getApnTypesStringFromBitmask(getDisallowedApnTypes()));
        indentingPrintWriter.println("mInstanceNumber=" + mInstanceNumber);
        indentingPrintWriter.println("mAc=" + this.mAc);
        indentingPrintWriter.println("mScore=" + this.mScore);
        DcNetworkAgent dcNetworkAgent = this.mNetworkAgent;
        if (dcNetworkAgent != null) {
            dcNetworkAgent.dump(fileDescriptor, indentingPrintWriter, strArr);
        }
        indentingPrintWriter.println("handover local log:");
        indentingPrintWriter.increaseIndent();
        this.mHandoverLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println();
        indentingPrintWriter.flush();
    }

    private class DataConnectionVcnNetworkPolicyChangeListener implements VcnManager.VcnNetworkPolicyChangeListener {
        private DataConnectionVcnNetworkPolicyChangeListener() {
        }

        public void onPolicyChanged() {
            NetworkCapabilities networkCapabilities = DataConnection.this.getNetworkCapabilities();
            if (DataConnection.this.mVcnManager.applyVcnNetworkPolicy(networkCapabilities, DataConnection.this.getLinkProperties()).isTeardownRequested()) {
                DataConnection.this.tearDownAll(PhoneInternalInterface.REASON_VCN_REQUESTED_TEARDOWN, 2, (Message) null);
            }
            if (DataConnection.this.mNetworkAgent != null) {
                DataConnection.this.mNetworkAgent.sendNetworkCapabilities(networkCapabilities, DataConnection.this);
            }
        }
    }
}
