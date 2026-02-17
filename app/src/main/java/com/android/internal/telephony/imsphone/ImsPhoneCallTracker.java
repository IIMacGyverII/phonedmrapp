package com.android.internal.telephony.imsphone;

import android.app.usage.NetworkStatsManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkInfo;
import android.net.NetworkRequest;
import android.net.NetworkStats;
import android.net.netstats.provider.NetworkStatsProvider;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.ParcelUuid;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.os.SystemClock;
import android.provider.Settings;
import android.telecom.Connection;
import android.telecom.TelecomManager;
import android.telecom.VideoProfile;
import android.telephony.CallQuality;
import android.telephony.CarrierConfigManager;
import android.telephony.ServiceState;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyLocalConnection;
import android.telephony.emergency.EmergencyNumber;
import android.telephony.ims.ImsCallProfile;
import android.telephony.ims.ImsCallSession;
import android.telephony.ims.ImsConferenceState;
import android.telephony.ims.ImsMmTelManager;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.ImsStreamMediaProfile;
import android.telephony.ims.ImsSuppServiceNotification;
import android.telephony.ims.ProvisioningManager;
import android.telephony.ims.RtpHeaderExtension;
import android.telephony.ims.feature.ImsFeature;
import android.telephony.ims.feature.MmTelFeature;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.ArraySet;
import android.util.Log;
import android.util.Pair;
import android.util.SparseIntArray;
import androidx.core.view.PointerIconCompat;
import com.android.ims.FeatureConnector;
import com.android.ims.ImsCall;
import com.android.ims.ImsEcbm;
import com.android.ims.ImsException;
import com.android.ims.ImsManager;
import com.android.ims.ImsUtInterface;
import com.android.ims.internal.ConferenceParticipant;
import com.android.ims.internal.IImsCallSession;
import com.android.ims.internal.IImsVideoCallProvider;
import com.android.ims.internal.ImsVideoCallProviderWrapper;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CallFailCause;
import com.android.internal.telephony.CallStateException;
import com.android.internal.telephony.CallTracker;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.IccCardConstants;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.SomeArgs;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.d2d.RtpTransport;
import com.android.internal.telephony.data.DataServiceManager$$ExternalSyntheticLambda0;
import com.android.internal.telephony.data.DataSettingsManager;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.gsm.SuppServiceNotification;
import com.android.internal.telephony.imsphone.ImsPhone;
import com.android.internal.telephony.metrics.CallQualityMetrics;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.mediatek.util.MtkPatterns;
import com.pri.prizeinterphone.InterPhoneService;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Queue;
import java.util.Set;
import java.util.concurrent.CancellationException;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.Executor;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Consumer;
import java.util.regex.Pattern;

public class ImsPhoneCallTracker extends CallTracker implements ImsPullCall {
    private static final int CONNECTOR_RETRY_DELAY_MS = 5000;
    protected static final boolean DBG = true;
    private static final int EVENT_ANSWER_WAITING_CALL = 30;
    protected static final int EVENT_CHECK_FOR_WIFI_HANDOVER = 25;
    protected static final int EVENT_DATA_ENABLED_CHANGED = 23;
    protected static final int EVENT_DIAL_PENDINGMO = 20;
    private static final int EVENT_EXIT_ECBM_BEFORE_PENDINGMO = 21;
    protected static final int EVENT_HANGUP_PENDINGMO = 18;
    protected static final int EVENT_ON_FEATURE_CAPABILITY_CHANGED = 26;
    private static final int EVENT_REDIAL_WIFI_E911_CALL = 28;
    private static final int EVENT_REDIAL_WIFI_E911_TIMEOUT = 29;
    private static final int EVENT_REDIAL_WITHOUT_RTT = 32;
    protected static final int EVENT_RESUME_NOW_FOREGROUND_CALL = 31;
    private static final int EVENT_SUPP_SERVICE_INDICATION = 27;
    private static final int EVENT_VT_DATA_USAGE_UPDATE = 22;
    private static final boolean FORCE_VERBOSE_STATE_LOGGING = false;
    protected static final int HANDOVER_TO_WIFI_TIMEOUT_MS = 60000;
    static final String LOG_TAG = "ImsPhoneCallTracker";
    private static final int MAX_CALL_QUALITY_HISTORY = 10;
    static final int MAX_CONNECTIONS = 7;
    static final int MAX_CONNECTIONS_PER_CALL = 5;
    private static final SparseIntArray PRECISE_CAUSE_MAP;
    protected static final int TIMEOUT_HANGUP_PENDINGMO = 500;
    private static final int TIMEOUT_PARTICIPANT_CONNECT_TIME_CACHE_MS = 60000;
    private static final int TIMEOUT_REDIAL_WIFI_E911_MS = 10000;
    private static final boolean VERBOSE_STATE_LOGGING = Rlog.isLoggable(VERBOSE_STATE_TAG, 2);
    static final String VERBOSE_STATE_TAG = "IPCTState";
    protected boolean mAllowAddCallDuringVideoCall;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mAllowEmergencyVideoCalls;
    protected boolean mAllowHoldingVideoCall;
    private boolean mAlwaysPlayRemoteHoldTone;
    /* access modifiers changed from: private */
    public boolean mAutoRetryFailedWifiEmergencyCall;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall mBackgroundCall;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsCall mCallExpectedToResume;
    /* access modifiers changed from: private */
    public final Map<String, CallQualityMetrics> mCallQualityMetrics;
    /* access modifiers changed from: private */
    public final ConcurrentLinkedQueue<CallQualityMetrics> mCallQualityMetricsHistory;
    /* access modifiers changed from: private */
    public Pair<Integer, PersistableBundle> mCarrierConfigForSubId;
    private boolean mCarrierConfigLoadedForSubscription;
    protected int mClirMode;
    private Config mConfig;
    private final ProvisioningManager.Callback mConfigCallback;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ArrayList<ImsPhoneConnection> mConnections;
    private final ConnectorFactory mConnectorFactory;
    /* access modifiers changed from: private */
    public Runnable mConnectorRunnable;
    /* access modifiers changed from: private */
    public Optional<Integer> mCurrentlyConnectedSubId;
    /* access modifiers changed from: private */
    public final AtomicInteger mDefaultDialerUid;
    private boolean mDesiredMute;
    private boolean mDeviceToDeviceForceEnabled;
    private boolean mDropVideoCallWhenAnsweringAudioCall;
    /* access modifiers changed from: private */
    public Executor mExecutor;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall mForegroundCall;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall mHandoverCall;
    /* access modifiers changed from: private */
    public boolean mHasAttemptedStartOfCallHandover;
    protected HoldSwapState mHoldSwitchingState;
    private boolean mIgnoreDataEnabledChangedForVideoCalls;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsCall.Listener mImsCallListener;
    private final ImsMmTelManager.CapabilityCallback mImsCapabilityCallback;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsManager mImsManager;
    protected final FeatureConnector<ImsManager> mImsManagerConnector;
    private Map<Pair<Integer, String>, Integer> mImsReasonCodeMap;
    private final ImsManager.ImsStatsCallback mImsStatsCallback;
    protected ImsCall.Listener mImsUssdListener;
    /* access modifiers changed from: private */
    public boolean mIsConferenceEventPackageEnabled;
    protected boolean mIsDataEnabled;
    private boolean mIsInEmergencyCall;
    private boolean mIsMonitoringConnectivity;
    protected boolean mIsViLteDataMetered;
    private ImsPhone.ImsDialArgs mLastDialArgs;
    private String mLastDialString;
    protected TelephonyMetrics mMetrics;
    private MmTelFeature.MmTelCapabilities mMmTelCapabilities;
    private final MmTelFeatureListener mMmTelFeatureListener;
    private ConnectivityManager.NetworkCallback mNetworkCallback;
    /* access modifiers changed from: private */
    public boolean mNotifyHandoverVideoFromLTEToWifi;
    protected boolean mNotifyHandoverVideoFromWifiToLTE;
    protected boolean mNotifyVtHandoverToWifiFail;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mOnHoldToneId;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mOnHoldToneStarted;
    protected final LocalLog mOperationLocalLog;
    protected int mPendingCallVideoState;
    protected Bundle mPendingIntentExtras;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsPhoneConnection mPendingMO;
    /* access modifiers changed from: private */
    public Pair<Boolean, Integer> mPendingSilentRedialInfo;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Message mPendingUssd;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhone mPhone;
    private final Map<String, CacheEntry> mPhoneNumAndConnTime;
    private List<PhoneStateListener> mPhoneStateListeners;
    protected final BroadcastReceiver mReceiver;
    private final LocalLog mRegLocalLog;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsPhoneCall mRingingCall;
    protected DataSettingsManager.DataSettingsManagerCallback mSettingsCallback;
    private SharedPreferenceProxy mSharedPreferenceProxy;
    protected boolean mShouldUpdateImsConfigOnDisconnect;
    protected Call.SrvccState mSrvccState;
    protected PhoneConstants.State mState;
    /* access modifiers changed from: private */
    public boolean mSupportCepOnPeer;
    private boolean mSupportD2DUsingRtp;
    private boolean mSupportDowngradeVtToAudio;
    /* access modifiers changed from: private */
    public boolean mSupportPauseVideo;
    private boolean mSupportSdpForRtpHeaderExtensions;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mSwitchingFgAndBgCalls;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Object mSyncHold;
    private boolean mTreatDowngradedVideoCallsAsVideoCalls;
    private final Queue<CacheEntry> mUnknownPeerConnTime;
    /* access modifiers changed from: private */
    public int mUssdMethod;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ImsCall mUssdSession;
    protected ImsUtInterface mUtInterface;
    private RegistrantList mVoiceCallEndedRegistrants;
    private RegistrantList mVoiceCallStartedRegistrants;
    private final HashMap<Integer, Long> mVtDataUsageMap;
    /* access modifiers changed from: private */
    public final VtDataUsageProvider mVtDataUsageProvider;
    /* access modifiers changed from: private */
    public volatile NetworkStats mVtDataUsageSnapshot;
    /* access modifiers changed from: private */
    public volatile NetworkStats mVtDataUsageUidSnapshot;
    protected int pendingCallClirMode;
    protected boolean pendingCallInEcm;

    public static class Config {
        public boolean isD2DCommunicationSupported;
    }

    @VisibleForTesting
    public interface ConnectorFactory {
        FeatureConnector<ImsManager> create(Context context, int i, String str, FeatureConnector.Listener<ImsManager> listener, Executor executor);
    }

    protected enum HoldSwapState {
        INACTIVE,
        PENDING_SINGLE_CALL_HOLD,
        PENDING_SINGLE_CALL_UNHOLD,
        SWAPPING_ACTIVE_AND_HELD,
        HOLDING_TO_ANSWER_INCOMING,
        PENDING_RESUME_FOREGROUND_AFTER_FAILURE,
        HOLDING_TO_DIAL_OUTGOING,
        PENDING_RESUME_FOREGROUND_AFTER_HOLD
    }

    public interface PhoneStateListener {
        void onPhoneStateChanged(PhoneConstants.State state, PhoneConstants.State state2);
    }

    public interface SharedPreferenceProxy {
        SharedPreferences getDefaultSharedPreferences(Context context);
    }

    /* access modifiers changed from: protected */
    public void checkIncomingCallInRttEmcGuardTime(ImsPhoneConnection imsPhoneConnection) {
    }

    /* access modifiers changed from: protected */
    public void checkforCsfb() throws CallStateException {
    }

    /* access modifiers changed from: protected */
    public int getHangupReasionInfo(int i, boolean z) {
        return z ? 504 : 501;
    }

    /* access modifiers changed from: protected */
    public void handlePollCalls(AsyncResult asyncResult) {
    }

    /* access modifiers changed from: protected */
    public boolean ignoreCarrierPauseSupport() {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean ignoreClirWhenEcc() {
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean ignoreConference(ImsCall imsCall, ImsCall imsCall2) {
        return false;
    }

    public boolean ignoreSwitchCallToBackground() {
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean isCarrierPauseAllowed(ImsCall imsCall) {
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean isRoamingOnAndRoamingSettingOff() {
        return false;
    }

    /* access modifiers changed from: protected */
    public void logDebugMessagesWithDumpFormat(String str, ImsPhoneConnection imsPhoneConnection, String str2) {
    }

    /* access modifiers changed from: protected */
    public void logDebugMessagesWithOpFormat(String str, String str2, ImsPhoneConnection imsPhoneConnection, String str3) {
    }

    /* access modifiers changed from: protected */
    public void releasePendingMOIfRequired() {
    }

    /* access modifiers changed from: protected */
    public void resetRingBackTone(ImsPhoneCall imsPhoneCall) {
    }

    /* access modifiers changed from: protected */
    public void setMultiPartyState(Connection connection) {
    }

    /* access modifiers changed from: protected */
    public void setRedialAsEcc(int i) {
    }

    /* access modifiers changed from: protected */
    public void startRttEmcGuardTimer() {
    }

    /* access modifiers changed from: protected */
    public void switchWfcModeIfRequired(ImsManager imsManager, boolean z, boolean z2) {
    }

    /* access modifiers changed from: protected */
    public int updateDisconnectCause(int i, ImsPhoneConnection imsPhoneConnection) {
        return i;
    }

    static {
        SparseIntArray sparseIntArray = new SparseIntArray();
        PRECISE_CAUSE_MAP = sparseIntArray;
        sparseIntArray.append(101, CallFailCause.LOCAL_ILLEGAL_ARGUMENT);
        sparseIntArray.append(102, CallFailCause.LOCAL_ILLEGAL_STATE);
        sparseIntArray.append(103, CallFailCause.LOCAL_INTERNAL_ERROR);
        sparseIntArray.append(106, CallFailCause.LOCAL_IMS_SERVICE_DOWN);
        sparseIntArray.append(107, CallFailCause.LOCAL_NO_PENDING_CALL);
        sparseIntArray.append(108, 16);
        sparseIntArray.append(111, CallFailCause.LOCAL_POWER_OFF);
        sparseIntArray.append(112, CallFailCause.LOCAL_LOW_BATTERY);
        sparseIntArray.append(121, CallFailCause.LOCAL_NETWORK_NO_SERVICE);
        sparseIntArray.append(122, CallFailCause.LOCAL_NETWORK_NO_LTE_COVERAGE);
        sparseIntArray.append(123, CallFailCause.LOCAL_NETWORK_ROAMING);
        sparseIntArray.append(124, CallFailCause.LOCAL_NETWORK_IP_CHANGED);
        sparseIntArray.append(InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC, CallFailCause.LOCAL_SERVICE_UNAVAILABLE);
        sparseIntArray.append(132, CallFailCause.LOCAL_NOT_REGISTERED);
        sparseIntArray.append(141, CallFailCause.LOCAL_MAX_CALL_EXCEEDED);
        sparseIntArray.append(143, CallFailCause.LOCAL_CALL_DECLINE);
        sparseIntArray.append(144, CallFailCause.LOCAL_CALL_VCC_ON_PROGRESSING);
        sparseIntArray.append(145, CallFailCause.LOCAL_CALL_RESOURCE_RESERVATION_FAILED);
        sparseIntArray.append(146, CallFailCause.LOCAL_CALL_CS_RETRY_REQUIRED);
        sparseIntArray.append(147, CallFailCause.LOCAL_CALL_VOLTE_RETRY_REQUIRED);
        sparseIntArray.append(148, CallFailCause.LOCAL_CALL_TERMINATED);
        sparseIntArray.append(149, CallFailCause.LOCAL_HO_NOT_FEASIBLE);
        sparseIntArray.append(201, CallFailCause.TIMEOUT_1XX_WAITING);
        sparseIntArray.append(202, CallFailCause.TIMEOUT_NO_ANSWER);
        sparseIntArray.append(203, CallFailCause.TIMEOUT_NO_ANSWER_CALL_UPDATE);
        sparseIntArray.append(CallFailCause.FDN_BLOCKED, CallFailCause.FDN_BLOCKED);
        sparseIntArray.append(321, CallFailCause.SIP_REDIRECTED);
        sparseIntArray.append(331, CallFailCause.SIP_BAD_REQUEST);
        sparseIntArray.append(332, CallFailCause.SIP_FORBIDDEN);
        sparseIntArray.append(333, CallFailCause.SIP_NOT_FOUND);
        sparseIntArray.append(334, CallFailCause.SIP_NOT_SUPPORTED);
        sparseIntArray.append(335, CallFailCause.SIP_REQUEST_TIMEOUT);
        sparseIntArray.append(336, CallFailCause.SIP_TEMPRARILY_UNAVAILABLE);
        sparseIntArray.append(337, CallFailCause.SIP_BAD_ADDRESS);
        sparseIntArray.append(338, CallFailCause.SIP_BUSY);
        sparseIntArray.append(339, CallFailCause.SIP_REQUEST_CANCELLED);
        sparseIntArray.append(340, CallFailCause.SIP_NOT_ACCEPTABLE);
        sparseIntArray.append(341, CallFailCause.SIP_NOT_REACHABLE);
        sparseIntArray.append(342, CallFailCause.SIP_CLIENT_ERROR);
        sparseIntArray.append(343, CallFailCause.SIP_TRANSACTION_DOES_NOT_EXIST);
        sparseIntArray.append(351, CallFailCause.SIP_SERVER_INTERNAL_ERROR);
        sparseIntArray.append(352, CallFailCause.SIP_SERVICE_UNAVAILABLE);
        sparseIntArray.append(353, CallFailCause.SIP_SERVER_TIMEOUT);
        sparseIntArray.append(354, CallFailCause.SIP_SERVER_ERROR);
        sparseIntArray.append(361, CallFailCause.SIP_USER_REJECTED);
        sparseIntArray.append(362, CallFailCause.SIP_GLOBAL_ERROR);
        sparseIntArray.append(363, CallFailCause.IMS_EMERGENCY_TEMP_FAILURE);
        sparseIntArray.append(364, CallFailCause.IMS_EMERGENCY_PERM_FAILURE);
        sparseIntArray.append(401, CallFailCause.MEDIA_INIT_FAILED);
        sparseIntArray.append(402, CallFailCause.MEDIA_NO_DATA);
        sparseIntArray.append(403, CallFailCause.MEDIA_NOT_ACCEPTABLE);
        sparseIntArray.append(404, CallFailCause.MEDIA_UNSPECIFIED);
        sparseIntArray.append(501, 1500);
        sparseIntArray.append(502, CallFailCause.USER_NOANSWER);
        sparseIntArray.append(503, CallFailCause.USER_IGNORE);
        sparseIntArray.append(504, CallFailCause.USER_DECLINE);
        sparseIntArray.append(505, CallFailCause.LOW_BATTERY);
        sparseIntArray.append(506, CallFailCause.BLACKLISTED_CALL_ID);
        sparseIntArray.append(510, CallFailCause.USER_TERMINATED_BY_REMOTE);
        sparseIntArray.append(801, CallFailCause.UT_NOT_SUPPORTED);
        sparseIntArray.append(802, CallFailCause.UT_SERVICE_UNAVAILABLE);
        sparseIntArray.append(803, CallFailCause.UT_OPERATION_NOT_ALLOWED);
        sparseIntArray.append(804, CallFailCause.UT_NETWORK_ERROR);
        sparseIntArray.append(821, CallFailCause.UT_CB_PASSWORD_MISMATCH);
        sparseIntArray.append(901, CallFailCause.ECBM_NOT_SUPPORTED);
        sparseIntArray.append(902, CallFailCause.MULTIENDPOINT_NOT_SUPPORTED);
        sparseIntArray.append(1100, 2000);
        sparseIntArray.append(PointerIconCompat.TYPE_HORIZONTAL_DOUBLE_ARROW, 2100);
        sparseIntArray.append(PointerIconCompat.TYPE_VERTICAL_DOUBLE_ARROW, 2101);
        sparseIntArray.append(PointerIconCompat.TYPE_TOP_RIGHT_DIAGONAL_DOUBLE_ARROW, 2102);
        sparseIntArray.append(CallFailCause.LOCAL_ILLEGAL_STATE, CallFailCause.SUPP_SVC_FAILED);
        sparseIntArray.append(CallFailCause.LOCAL_INTERNAL_ERROR, CallFailCause.SUPP_SVC_CANCELLED);
        sparseIntArray.append(CallFailCause.LOCAL_IMS_SERVICE_DOWN, CallFailCause.SUPP_SVC_REINVITE_COLLISION);
        sparseIntArray.append(CallFailCause.SIP_REDIRECTED, CallFailCause.IWLAN_DPD_FAILURE);
        sparseIntArray.append(CallFailCause.MEDIA_INIT_FAILED, CallFailCause.EPDG_TUNNEL_ESTABLISH_FAILURE);
        sparseIntArray.append(CallFailCause.MEDIA_NO_DATA, CallFailCause.EPDG_TUNNEL_REKEY_FAILURE);
        sparseIntArray.append(CallFailCause.MEDIA_NOT_ACCEPTABLE, CallFailCause.EPDG_TUNNEL_LOST_CONNECTION);
        sparseIntArray.append(CallFailCause.MEDIA_UNSPECIFIED, CallFailCause.MAXIMUM_NUMBER_OF_CALLS_REACHED);
        sparseIntArray.append(1404, CallFailCause.REMOTE_CALL_DECLINE);
        sparseIntArray.append(1405, CallFailCause.DATA_LIMIT_REACHED);
        sparseIntArray.append(1406, CallFailCause.DATA_DISABLED);
        sparseIntArray.append(1407, CallFailCause.WIFI_LOST);
        sparseIntArray.append(1500, CallFailCause.RADIO_OFF);
        sparseIntArray.append(CallFailCause.USER_NOANSWER, 249);
        sparseIntArray.append(CallFailCause.USER_IGNORE, 250);
        sparseIntArray.append(CallFailCause.USER_DECLINE, CallFailCause.NETWORK_RESP_TIMEOUT);
        sparseIntArray.append(CallFailCause.LOW_BATTERY, CallFailCause.NETWORK_REJECT);
        sparseIntArray.append(CallFailCause.BLACKLISTED_CALL_ID, CallFailCause.RADIO_ACCESS_FAILURE);
        sparseIntArray.append(1506, CallFailCause.RADIO_LINK_FAILURE);
        sparseIntArray.append(1507, 255);
        sparseIntArray.append(1508, 256);
        sparseIntArray.append(1509, 257);
        sparseIntArray.append(CallFailCause.USER_TERMINATED_BY_REMOTE, CallFailCause.RADIO_RELEASE_NORMAL);
        sparseIntArray.append(1511, CallFailCause.RADIO_RELEASE_ABNORMAL);
        sparseIntArray.append(1512, CallFailCause.ACCESS_CLASS_BLOCKED);
        sparseIntArray.append(1513, CallFailCause.NETWORK_DETACH);
        sparseIntArray.append(1515, 1);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_1, CallFailCause.OEM_CAUSE_1);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_2, CallFailCause.OEM_CAUSE_2);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_3, CallFailCause.OEM_CAUSE_3);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_4, CallFailCause.OEM_CAUSE_4);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_5, CallFailCause.OEM_CAUSE_5);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_6, CallFailCause.OEM_CAUSE_6);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_7, CallFailCause.OEM_CAUSE_7);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_8, CallFailCause.OEM_CAUSE_8);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_9, CallFailCause.OEM_CAUSE_9);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_10, CallFailCause.OEM_CAUSE_10);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_11, CallFailCause.OEM_CAUSE_11);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_12, CallFailCause.OEM_CAUSE_12);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_13, CallFailCause.OEM_CAUSE_13);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_14, CallFailCause.OEM_CAUSE_14);
        sparseIntArray.append(CallFailCause.OEM_CAUSE_15, CallFailCause.OEM_CAUSE_15);
    }

    private class MmTelFeatureListener extends MmTelFeature.Listener {
        private MmTelFeatureListener() {
        }

        /* access modifiers changed from: private */
        /* JADX WARNING: No exception handlers in catch block: Catch:{  } */
        /* renamed from: processIncomingCall */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void lambda$onIncomingCall$0(com.android.ims.internal.IImsCallSession r8, android.os.Bundle r9) {
            /*
                r7 = this;
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r0 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this
                java.lang.String r1 = "processIncomingCall: incoming call intent"
                r0.log(r1)
                if (r9 != 0) goto L_0x000e
                android.os.Bundle r9 = new android.os.Bundle
                r9.<init>()
            L_0x000e:
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r0 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this
                com.android.ims.ImsManager r0 = r0.mImsManager
                if (r0 != 0) goto L_0x0015
                return
            L_0x0015:
                java.lang.String r0 = "android.telephony.ims.feature.extra.IS_USSD"
                r1 = 0
                boolean r0 = r9.getBoolean(r0, r1)     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r2 = "android:ussd"
                boolean r2 = r9.getBoolean(r2, r1)     // Catch:{ RemoteException | ImsException -> 0x020d }
                r0 = r0 | r2
                if (r0 == 0) goto L_0x004c
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r9 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r0 = "processIncomingCall: USSD"
                r9.log(r0)     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r9 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.LocalLog r9 = r9.mOperationLocalLog     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r0 = "processIncomingCall: USSD"
                r9.log(r0)     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r9 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.ims.ImsManager r0 = r9.mImsManager     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.ims.ImsCall$Listener r1 = r9.mImsUssdListener     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.ims.ImsCall r8 = r0.takeCall(r8, r1)     // Catch:{ RemoteException | ImsException -> 0x020d }
                r9.mUssdSession = r8     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.ims.ImsCall r8 = r8.mUssdSession     // Catch:{ RemoteException | ImsException -> 0x020d }
                if (r8 == 0) goto L_0x004b
                r9 = 2
                r8.accept(r9)     // Catch:{ RemoteException | ImsException -> 0x020d }
            L_0x004b:
                return
            L_0x004c:
                java.lang.String r0 = "android.telephony.ims.feature.extra.IS_UNKNOWN_CALL"
                boolean r0 = r9.getBoolean(r0, r1)     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r2 = "android:isUnknown"
                boolean r2 = r9.getBoolean(r2, r1)     // Catch:{ RemoteException | ImsException -> 0x020d }
                r0 = r0 | r2
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r2 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ RemoteException | ImsException -> 0x020d }
                r3.<init>()     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r4 = "processIncomingCall: isUnknown = "
                r3.append(r4)     // Catch:{ RemoteException | ImsException -> 0x020d }
                r3.append(r0)     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r4 = " fg = "
                r3.append(r4)     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r4 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCall r4 = r4.mForegroundCall     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.Call$State r4 = r4.getState()     // Catch:{ RemoteException | ImsException -> 0x020d }
                r3.append(r4)     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r4 = " bg = "
                r3.append(r4)     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r4 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCall r4 = r4.mBackgroundCall     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.Call$State r4 = r4.getState()     // Catch:{ RemoteException | ImsException -> 0x020d }
                r3.append(r4)     // Catch:{ RemoteException | ImsException -> 0x020d }
                java.lang.String r3 = r3.toString()     // Catch:{ RemoteException | ImsException -> 0x020d }
                r2.log(r3)     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r2 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.ims.ImsCall r9 = r2.takeCall(r8, r9)     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r2 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ RemoteException | ImsException -> 0x020d }
                monitor-enter(r2)     // Catch:{ RemoteException | ImsException -> 0x020d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r3 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneConnection r3 = r3.makeImsPhoneConnectionForMT(r9, r0)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r4 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCall r4 = r4.mForegroundCall     // Catch:{ all -> 0x020a }
                boolean r4 = r4.hasConnections()     // Catch:{ all -> 0x020a }
                if (r4 == 0) goto L_0x00c1
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r4 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCall r4 = r4.mForegroundCall     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneConnection r4 = r4.getFirstConnection()     // Catch:{ all -> 0x020a }
                com.android.ims.ImsCall r4 = r4.getImsCall()     // Catch:{ all -> 0x020a }
                if (r4 == 0) goto L_0x00c1
                if (r9 == 0) goto L_0x00c1
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r5 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                boolean r4 = r5.shouldDisconnectActiveCallOnAnswer(r4, r9)     // Catch:{ all -> 0x020a }
                r3.setActiveCallDisconnectedOnAnswer(r4)     // Catch:{ all -> 0x020a }
            L_0x00c1:
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r4 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                boolean r4 = r4.mAllowAddCallDuringVideoCall     // Catch:{ all -> 0x020a }
                r3.setAllowAddCallDuringVideoCall(r4)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r4 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                boolean r4 = r4.mAllowHoldingVideoCall     // Catch:{ all -> 0x020a }
                r3.setAllowHoldingVideoCall(r4)     // Catch:{ all -> 0x020a }
                if (r8 == 0) goto L_0x0140
                android.telephony.ims.ImsCallProfile r4 = r8.getCallProfile()     // Catch:{ all -> 0x020a }
                if (r4 == 0) goto L_0x0140
                android.telephony.ims.ImsCallProfile r4 = r8.getCallProfile()     // Catch:{ all -> 0x020a }
                android.os.Bundle r4 = r4.getCallExtras()     // Catch:{ all -> 0x020a }
                if (r4 == 0) goto L_0x0140
                android.telephony.ims.ImsCallProfile r4 = r8.getCallProfile()     // Catch:{ all -> 0x020a }
                android.os.Bundle r4 = r4.getCallExtras()     // Catch:{ all -> 0x020a }
                java.lang.String r5 = "android.telephony.ims.extra.CALL_DISCONNECT_CAUSE"
                boolean r4 = r4.containsKey(r5)     // Catch:{ all -> 0x020a }
                if (r4 == 0) goto L_0x0140
                android.telephony.ims.ImsCallProfile r8 = r8.getCallProfile()     // Catch:{ all -> 0x020a }
                java.lang.String r4 = "android.telephony.ims.extra.CALL_DISCONNECT_CAUSE"
                r5 = 0
                java.lang.String r8 = r8.getCallExtra(r4, r5)     // Catch:{ all -> 0x020a }
                if (r8 == 0) goto L_0x0140
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r4 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ NumberFormatException -> 0x0129 }
                android.telephony.ims.ImsReasonInfo r6 = new android.telephony.ims.ImsReasonInfo     // Catch:{ NumberFormatException -> 0x0129 }
                int r8 = java.lang.Integer.parseInt(r8)     // Catch:{ NumberFormatException -> 0x0129 }
                r6.<init>(r8, r1, r5)     // Catch:{ NumberFormatException -> 0x0129 }
                com.android.internal.telephony.Call$State r8 = r3.getState()     // Catch:{ NumberFormatException -> 0x0129 }
                int r8 = r4.getDisconnectCauseFromReasonInfo(r6, r8)     // Catch:{ NumberFormatException -> 0x0129 }
                r1 = 81
                if (r8 != r1) goto L_0x0140
                r3.setDisconnectCause(r8)     // Catch:{ NumberFormatException -> 0x0129 }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ NumberFormatException -> 0x0129 }
                java.lang.String r1 = "onIncomingCall : incoming call auto rejected"
                r8.log(r1)     // Catch:{ NumberFormatException -> 0x0129 }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ NumberFormatException -> 0x0129 }
                com.android.internal.telephony.LocalLog r8 = r8.mOperationLocalLog     // Catch:{ NumberFormatException -> 0x0129 }
                java.lang.String r1 = "processIncomingCall: auto rejected"
                r8.log(r1)     // Catch:{ NumberFormatException -> 0x0129 }
                goto L_0x0140
            L_0x0129:
                r8 = move-exception
                java.lang.String r1 = "ImsPhoneCallTracker"
                java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x020a }
                r4.<init>()     // Catch:{ all -> 0x020a }
                java.lang.String r5 = "Exception in parsing Integer Data: "
                r4.append(r5)     // Catch:{ all -> 0x020a }
                r4.append(r8)     // Catch:{ all -> 0x020a }
                java.lang.String r8 = r4.toString()     // Catch:{ all -> 0x020a }
                com.android.telephony.Rlog.e(r1, r8)     // Catch:{ all -> 0x020a }
            L_0x0140:
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.LocalLog r8 = r8.mOperationLocalLog     // Catch:{ all -> 0x020a }
                java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x020a }
                r1.<init>()     // Catch:{ all -> 0x020a }
                java.lang.String r4 = "onIncomingCall: isUnknown="
                r1.append(r4)     // Catch:{ all -> 0x020a }
                r1.append(r0)     // Catch:{ all -> 0x020a }
                java.lang.String r4 = ", connId="
                r1.append(r4)     // Catch:{ all -> 0x020a }
                int r4 = java.lang.System.identityHashCode(r3)     // Catch:{ all -> 0x020a }
                r1.append(r4)     // Catch:{ all -> 0x020a }
                java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x020a }
                r8.log(r1)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                r8.addConnection(r3)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                r8.setVideoCallProvider(r3, r9)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                r8.checkIncomingCallInRttEmcGuardTime(r3)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.metrics.TelephonyMetrics r8 = com.android.internal.telephony.metrics.TelephonyMetrics.getInstance()     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhone r1 = r1.mPhone     // Catch:{ all -> 0x020a }
                int r1 = r1.getPhoneId()     // Catch:{ all -> 0x020a }
                android.telephony.ims.ImsCallSession r4 = r9.getSession()     // Catch:{ all -> 0x020a }
                r8.writeOnImsCallReceive(r1, r4)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhone r8 = r8.mPhone     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.metrics.VoiceCallSessionStats r8 = r8.getVoiceCallSessionStats()     // Catch:{ all -> 0x020a }
                r8.onImsCallReceived(r3)     // Catch:{ all -> 0x020a }
                if (r0 == 0) goto L_0x01d3
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneConnection r8 = r8.mPendingMO     // Catch:{ all -> 0x020a }
                if (r8 == 0) goto L_0x01cb
                java.lang.String r8 = r8.getAddress()     // Catch:{ all -> 0x020a }
                java.lang.String r9 = r3.getAddress()     // Catch:{ all -> 0x020a }
                boolean r8 = java.util.Objects.equals(r8, r9)     // Catch:{ all -> 0x020a }
                if (r8 == 0) goto L_0x01cb
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.LocalLog r8 = r8.mOperationLocalLog     // Catch:{ all -> 0x020a }
                java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x020a }
                r9.<init>()     // Catch:{ all -> 0x020a }
                java.lang.String r0 = "onIncomingCall: unknown call "
                r9.append(r0)     // Catch:{ all -> 0x020a }
                r9.append(r3)     // Catch:{ all -> 0x020a }
                java.lang.String r0 = " replaces "
                r9.append(r0)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r0 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneConnection r0 = r0.mPendingMO     // Catch:{ all -> 0x020a }
                r9.append(r0)     // Catch:{ all -> 0x020a }
                java.lang.String r9 = r9.toString()     // Catch:{ all -> 0x020a }
                r8.log(r9)     // Catch:{ all -> 0x020a }
            L_0x01cb:
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhone r8 = r8.mPhone     // Catch:{ all -> 0x020a }
                r8.notifyUnknownConnection(r3)     // Catch:{ all -> 0x020a }
                goto L_0x01fc
            L_0x01d3:
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCall r8 = r8.mForegroundCall     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.Call$State r8 = r8.getState()     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.Call$State r0 = com.android.internal.telephony.Call.State.IDLE     // Catch:{ all -> 0x020a }
                if (r8 != r0) goto L_0x01e9
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCall r8 = r8.mBackgroundCall     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.Call$State r8 = r8.getState()     // Catch:{ all -> 0x020a }
                if (r8 == r0) goto L_0x01ee
            L_0x01e9:
                com.android.internal.telephony.Call$State r8 = com.android.internal.telephony.Call.State.WAITING     // Catch:{ all -> 0x020a }
                r3.update(r9, r8)     // Catch:{ all -> 0x020a }
            L_0x01ee:
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhone r8 = r8.mPhone     // Catch:{ all -> 0x020a }
                r8.notifyNewRingingConnection(r3)     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhone r8 = r8.mPhone     // Catch:{ all -> 0x020a }
                r8.notifyIncomingRing()     // Catch:{ all -> 0x020a }
            L_0x01fc:
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                r8.updatePhoneState()     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r8 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this     // Catch:{ all -> 0x020a }
                com.android.internal.telephony.imsphone.ImsPhone r8 = r8.mPhone     // Catch:{ all -> 0x020a }
                r8.notifyPreciseCallStateChanged()     // Catch:{ all -> 0x020a }
                monitor-exit(r2)     // Catch:{ all -> 0x020a }
                goto L_0x023c
            L_0x020a:
                r8 = move-exception
                monitor-exit(r2)     // Catch:{ all -> 0x020a }
                throw r8     // Catch:{ RemoteException | ImsException -> 0x020d }
            L_0x020d:
                r8 = move-exception
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r9 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r1 = "processIncomingCall: exception "
                r0.append(r1)
                r0.append(r8)
                java.lang.String r0 = r0.toString()
                r9.loge(r0)
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker r7 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.this
                com.android.internal.telephony.LocalLog r7 = r7.mOperationLocalLog
                java.lang.StringBuilder r9 = new java.lang.StringBuilder
                r9.<init>()
                java.lang.String r0 = "onIncomingCall: exception processing: "
                r9.append(r0)
                r9.append(r8)
                java.lang.String r8 = r9.toString()
                r7.log(r8)
            L_0x023c:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneCallTracker.MmTelFeatureListener.lambda$onIncomingCall$0(com.android.ims.internal.IImsCallSession, android.os.Bundle):void");
        }

        public void onIncomingCall(IImsCallSession iImsCallSession, Bundle bundle) {
            executeAndWait(new ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda1(this, iImsCallSession, bundle));
        }

        public void onVoiceMessageCountUpdate(int i) {
            TelephonyUtils.runWithCleanCallingIdentity(new ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda2(this, i), ImsPhoneCallTracker.this.mExecutor);
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$onVoiceMessageCountUpdate$1(int i) {
            ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
            ImsPhone imsPhone = imsPhoneCallTracker.mPhone;
            if (imsPhone == null || imsPhone.mDefaultPhone == null) {
                imsPhoneCallTracker.loge("onVoiceMessageCountUpdate: null phone");
                return;
            }
            imsPhoneCallTracker.log("onVoiceMessageCountChanged :: count=" + i);
            ImsPhoneCallTracker.this.mPhone.mDefaultPhone.setVoiceMessageCount(i);
        }

        private void executeAndWait(Runnable runnable) {
            try {
                CompletableFuture.runAsync(new ImsPhoneCallTracker$MmTelFeatureListener$$ExternalSyntheticLambda0(runnable), ImsPhoneCallTracker.this.mExecutor).join();
            } catch (CancellationException | CompletionException e) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.logw("Binder - exception: " + e.getMessage());
            }
        }
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public class VtDataUsageProvider extends NetworkStatsProvider {
        private NetworkStats mIfaceSnapshot = new NetworkStats(0, 0);
        private int mToken = 0;
        private NetworkStats mUidSnapshot = new NetworkStats(0, 0);

        public void onSetAlert(long j) {
        }

        public void onSetLimit(String str, long j) {
        }

        public VtDataUsageProvider() {
        }

        public void onRequestStatsUpdate(int i) {
            ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
            if (imsPhoneCallTracker.mState != PhoneConstants.State.IDLE) {
                Iterator<ImsPhoneConnection> it = imsPhoneCallTracker.mConnections.iterator();
                while (it.hasNext()) {
                    Connection.VideoProvider videoProvider = it.next().getVideoProvider();
                    if (videoProvider != null) {
                        videoProvider.onRequestConnectionDataUsage();
                    }
                }
            }
            NetworkStats subtract = ImsPhoneCallTracker.this.mVtDataUsageSnapshot.subtract(this.mIfaceSnapshot);
            NetworkStats subtract2 = ImsPhoneCallTracker.this.mVtDataUsageUidSnapshot.subtract(this.mUidSnapshot);
            ImsPhoneCallTracker.this.mVtDataUsageProvider.notifyStatsUpdated(this.mToken, subtract, subtract2);
            this.mIfaceSnapshot = this.mIfaceSnapshot.add(subtract);
            this.mUidSnapshot = this.mUidSnapshot.add(subtract2);
            this.mToken = i;
        }
    }

    private static class CacheEntry {
        /* access modifiers changed from: private */
        public long mCachedTime;
        /* access modifiers changed from: private */
        public int mCallDirection;
        /* access modifiers changed from: private */
        public long mConnectElapsedTime;
        /* access modifiers changed from: private */
        public long mConnectTime;

        CacheEntry(long j, long j2, long j3, int i) {
            this.mCachedTime = j;
            this.mConnectTime = j2;
            this.mConnectElapsedTime = j3;
            this.mCallDirection = i;
        }
    }

    public ImsPhoneCallTracker(ImsPhone imsPhone, ConnectorFactory connectorFactory) {
        this(imsPhone, connectorFactory, imsPhone.getContext().getMainExecutor());
    }

    @VisibleForTesting
    public ImsPhoneCallTracker(ImsPhone imsPhone, ConnectorFactory connectorFactory, Executor executor) {
        this.mMmTelCapabilities = new MmTelFeature.MmTelCapabilities();
        this.mCallQualityMetrics = new ConcurrentHashMap();
        this.mCallQualityMetricsHistory = new ConcurrentLinkedQueue<>();
        this.mCarrierConfigLoadedForSubscription = false;
        this.mCarrierConfigForSubId = null;
        this.mCurrentlyConnectedSubId = Optional.empty();
        this.mMmTelFeatureListener = new MmTelFeatureListener();
        AnonymousClass1 r2 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                    int intExtra = intent.getIntExtra("android.telephony.extra.SUBSCRIPTION_INDEX", -1);
                    int intExtra2 = intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1);
                    if (ImsPhoneCallTracker.this.mPhone.getPhoneId() != intExtra2) {
                        ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker.log("onReceive: Skipping indication for other phoneId: " + intExtra2);
                        return;
                    }
                    PersistableBundle r5 = ImsPhoneCallTracker.this.getCarrierConfigBundle(intExtra);
                    ImsPhoneCallTracker.this.mCarrierConfigForSubId = new Pair(Integer.valueOf(intExtra), r5);
                    if (ImsPhoneCallTracker.this.mCurrentlyConnectedSubId.isEmpty() || intExtra != ((Integer) ImsPhoneCallTracker.this.mCurrentlyConnectedSubId.get()).intValue()) {
                        ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker2.log("onReceive: caching carrier config until ImsService connects for subId: " + intExtra);
                        return;
                    }
                    ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker3.log("onReceive: Applying carrier config for subId: " + intExtra);
                    ImsPhoneCallTracker.this.updateCarrierConfiguration(intExtra, r5);
                } else if ("android.telecom.action.DEFAULT_DIALER_CHANGED".equals(intent.getAction())) {
                    ImsPhoneCallTracker.this.mDefaultDialerUid.set(ImsPhoneCallTracker.this.getPackageUid(context, intent.getStringExtra("android.telecom.extra.CHANGE_DEFAULT_DIALER_PACKAGE_NAME")));
                }
            }
        };
        this.mReceiver = r2;
        this.mIsMonitoringConnectivity = false;
        this.mIsConferenceEventPackageEnabled = true;
        this.mConfig = null;
        this.mDeviceToDeviceForceEnabled = false;
        this.mNetworkCallback = new ConnectivityManager.NetworkCallback() {
            public void onAvailable(Network network) {
                Rlog.i(ImsPhoneCallTracker.LOG_TAG, "Network available: " + network);
                ImsPhoneCallTracker.this.scheduleHandoverCheck();
            }
        };
        this.mConnections = new ArrayList<>();
        this.mVoiceCallEndedRegistrants = new RegistrantList();
        this.mVoiceCallStartedRegistrants = new RegistrantList();
        this.mRingingCall = new ImsPhoneCall(this, ImsPhoneCall.CONTEXT_RINGING);
        this.mForegroundCall = new ImsPhoneCall(this, ImsPhoneCall.CONTEXT_FOREGROUND);
        this.mBackgroundCall = new ImsPhoneCall(this, ImsPhoneCall.CONTEXT_BACKGROUND);
        this.mHandoverCall = new ImsPhoneCall(this, ImsPhoneCall.CONTEXT_HANDOVER);
        this.mVtDataUsageMap = new HashMap<>();
        this.mPhoneNumAndConnTime = new ConcurrentHashMap();
        this.mUnknownPeerConnTime = new LinkedBlockingQueue();
        this.mVtDataUsageSnapshot = null;
        this.mVtDataUsageUidSnapshot = null;
        VtDataUsageProvider vtDataUsageProvider = new VtDataUsageProvider();
        this.mVtDataUsageProvider = vtDataUsageProvider;
        AtomicInteger atomicInteger = new AtomicInteger(-1);
        this.mDefaultDialerUid = atomicInteger;
        this.mClirMode = 0;
        this.mSyncHold = new Object();
        this.mUssdSession = null;
        this.mPendingUssd = null;
        this.mDesiredMute = false;
        this.mOnHoldToneStarted = false;
        this.mOnHoldToneId = -1;
        this.mState = PhoneConstants.State.IDLE;
        this.mSrvccState = Call.SrvccState.NONE;
        this.mIsInEmergencyCall = false;
        this.mIsDataEnabled = false;
        this.pendingCallInEcm = false;
        this.mSwitchingFgAndBgCalls = false;
        this.mCallExpectedToResume = null;
        this.mAllowEmergencyVideoCalls = false;
        this.mIgnoreDataEnabledChangedForVideoCalls = false;
        this.mIsViLteDataMetered = false;
        this.mAlwaysPlayRemoteHoldTone = false;
        this.mAutoRetryFailedWifiEmergencyCall = false;
        this.mSupportCepOnPeer = true;
        this.mSupportD2DUsingRtp = false;
        this.mSupportSdpForRtpHeaderExtensions = false;
        this.mHoldSwitchingState = HoldSwapState.INACTIVE;
        this.mLastDialString = null;
        this.mLastDialArgs = null;
        this.mExecutor = new DataServiceManager$$ExternalSyntheticLambda0();
        this.mPhoneStateListeners = new ArrayList();
        this.mTreatDowngradedVideoCallsAsVideoCalls = false;
        this.mDropVideoCallWhenAnsweringAudioCall = false;
        this.mAllowAddCallDuringVideoCall = true;
        this.mAllowHoldingVideoCall = true;
        this.mNotifyVtHandoverToWifiFail = false;
        this.mSupportDowngradeVtToAudio = false;
        this.mNotifyHandoverVideoFromWifiToLTE = false;
        this.mNotifyHandoverVideoFromLTEToWifi = false;
        this.mHasAttemptedStartOfCallHandover = false;
        this.mSupportPauseVideo = false;
        this.mImsReasonCodeMap = new ArrayMap();
        this.mUssdMethod = 0;
        this.mShouldUpdateImsConfigOnDisconnect = false;
        this.mPendingSilentRedialInfo = null;
        this.mSharedPreferenceProxy = new ImsPhoneCallTracker$$ExternalSyntheticLambda1();
        this.mConnectorRunnable = new Runnable() {
            public void run() {
                ImsPhoneCallTracker.this.mImsManagerConnector.connect();
            }
        };
        this.mRegLocalLog = new LocalLog(64);
        this.mOperationLocalLog = new LocalLog(64);
        this.mImsCallListener = new ImsCall.Listener() {
            public void onCallInitiating(ImsCall imsCall) {
                ImsPhoneCallTracker.this.log("onCallInitiating");
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.mPendingMO = null;
                imsPhoneCallTracker.processCallStateChange(imsCall, Call.State.DIALING, 0, true);
                ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker2.mMetrics.writeOnImsCallInitiating(imsPhoneCallTracker2.mPhone.getPhoneId(), imsCall.getCallSession());
            }

            public void onCallProgressing(ImsCall imsCall) {
                ImsPhoneCallTracker.this.log("onCallProgressing");
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.mPendingMO = null;
                imsPhoneCallTracker.processCallStateChange(imsCall, Call.State.ALERTING, 0);
                ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker2.mMetrics.writeOnImsCallProgressing(imsPhoneCallTracker2.mPhone.getPhoneId(), imsCall.getCallSession());
            }

            public void onCallStarted(ImsCall imsCall) {
                ImsCall imsCall2;
                ImsPhoneCallTracker.this.log("onCallStarted");
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                if (imsPhoneCallTracker.mHoldSwitchingState == HoldSwapState.HOLDING_TO_ANSWER_INCOMING && (imsCall2 = imsPhoneCallTracker.mCallExpectedToResume) != null && imsCall2 == imsCall) {
                    imsPhoneCallTracker.log("onCallStarted: starting a call as a result of a switch.");
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker2.mHoldSwitchingState = HoldSwapState.INACTIVE;
                    imsPhoneCallTracker2.mCallExpectedToResume = null;
                    imsPhoneCallTracker2.logHoldSwapState("onCallStarted");
                }
                ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker3.mPendingMO = null;
                imsPhoneCallTracker3.processCallStateChange(imsCall, Call.State.ACTIVE, 0);
                if (ImsPhoneCallTracker.this.mNotifyVtHandoverToWifiFail && imsCall.isVideoCall() && !imsCall.isWifiCall()) {
                    if (ImsPhoneCallTracker.this.isWifiConnected()) {
                        ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker4.sendMessageDelayed(imsPhoneCallTracker4.obtainMessage(25, imsCall), 60000);
                        ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover = false;
                    } else {
                        ImsPhoneCallTracker.this.registerForConnectivityChanges();
                        ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover = true;
                    }
                }
                ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker5.mMetrics.writeOnImsCallStarted(imsPhoneCallTracker5.mPhone.getPhoneId(), imsCall.getCallSession());
            }

            public void onCallUpdated(ImsCall imsCall) {
                ImsPhoneConnection findConnection;
                ImsPhoneCallTracker.this.log("onCallUpdated");
                if (imsCall != null && (findConnection = ImsPhoneCallTracker.this.findConnection(imsCall)) != null) {
                    ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker.log("onCallUpdated: profile is " + imsCall.getCallProfile());
                    ImsPhoneCallTracker.this.processCallStateChange(imsCall, findConnection.getCall().mState, 0, true);
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker2.mMetrics.writeImsCallState(imsPhoneCallTracker2.mPhone.getPhoneId(), imsCall.getCallSession(), findConnection.getCall().mState);
                    ImsPhoneCallTracker.this.mPhone.getVoiceCallSessionStats().onCallStateChanged(findConnection.getCall());
                }
            }

            public void onCallStartFailed(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                ImsCall imsCall2;
                ImsPhoneCallTracker.this.log("onCallStartFailed reasonCode=" + imsReasonInfo.getCode());
                boolean z = false;
                int emergencyServiceCategories = (imsCall == null || imsCall.getCallProfile() == null) ? 0 : imsCall.getCallProfile().getEmergencyServiceCategories();
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                if (imsPhoneCallTracker.mHoldSwitchingState == HoldSwapState.HOLDING_TO_ANSWER_INCOMING && (imsCall2 = imsPhoneCallTracker.mCallExpectedToResume) != null && imsCall2 == imsCall) {
                    imsPhoneCallTracker.log("onCallStarted: starting a call as a result of a switch.");
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker2.mHoldSwitchingState = HoldSwapState.INACTIVE;
                    imsPhoneCallTracker2.mCallExpectedToResume = null;
                    imsPhoneCallTracker2.logHoldSwapState("onCallStartFailed");
                }
                if (ImsPhoneCallTracker.this.mPendingMO != null) {
                    if (imsReasonInfo.getCode() == 146 && ImsPhoneCallTracker.this.mRingingCall.getState() == Call.State.IDLE && ImsPhoneCallTracker.this.isForegroundHigherPriority()) {
                        ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker3.mForegroundCall.detach(imsPhoneCallTracker3.mPendingMO);
                        ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker4.removeConnection(imsPhoneCallTracker4.mPendingMO);
                        ImsPhoneCallTracker.this.mPendingMO.finalize();
                        ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker5.mPendingMO = null;
                        if (imsPhoneCallTracker5.mBackgroundCall.getState().isAlive()) {
                            try {
                                ImsPhoneCallTracker imsPhoneCallTracker6 = ImsPhoneCallTracker.this;
                                imsPhoneCallTracker6.hangup(imsPhoneCallTracker6.mBackgroundCall);
                                ImsPhoneCallTracker imsPhoneCallTracker7 = ImsPhoneCallTracker.this;
                                if (imsReasonInfo.getExtraCode() == 4) {
                                    z = true;
                                }
                                imsPhoneCallTracker7.mPendingSilentRedialInfo = new Pair(Boolean.valueOf(z), Integer.valueOf(emergencyServiceCategories));
                            } catch (CallStateException unused) {
                                ImsPhoneCallTracker.this.mPendingSilentRedialInfo = null;
                            }
                        } else {
                            ImsPhoneCallTracker.this.updatePhoneState();
                            ImsPhone imsPhone = ImsPhoneCallTracker.this.mPhone;
                            if (imsReasonInfo.getExtraCode() == 4) {
                                z = true;
                            }
                            imsPhone.initiateSilentRedial(z, emergencyServiceCategories);
                        }
                    } else {
                        ImsPhoneCallTracker.this.sendCallStartFailedDisconnect(imsCall, imsReasonInfo);
                        ImsPhoneCallTracker imsPhoneCallTracker8 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker8.mMetrics.writeOnImsCallStartFailed(imsPhoneCallTracker8.mPhone.getPhoneId(), imsCall.getCallSession(), imsReasonInfo);
                    }
                } else if (imsReasonInfo.getCode() == 146 && ImsPhoneCallTracker.this.mForegroundCall.getState() == Call.State.ALERTING) {
                    ImsPhoneCallTracker.this.log("onCallStartFailed: Initiated call by silent redial under ALERTING state.");
                    ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                    if (findConnection != null) {
                        ImsPhoneCallTracker.this.mForegroundCall.detach(findConnection);
                        ImsPhoneCallTracker.this.removeConnection(findConnection);
                    }
                    ImsPhoneCallTracker.this.updatePhoneState();
                    ImsPhone imsPhone2 = ImsPhoneCallTracker.this.mPhone;
                    if (imsReasonInfo.getExtraCode() == 4) {
                        z = true;
                    }
                    imsPhone2.initiateSilentRedial(z, emergencyServiceCategories);
                }
            }

            public void onCallTerminated(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                Call.State state;
                EmergencyNumber emergencyNumber;
                EmergencyNumberTracker emergencyNumberTracker;
                String str;
                ImsPhone imsPhone;
                ImsCall imsCall2 = imsCall;
                ImsReasonInfo imsReasonInfo2 = imsReasonInfo;
                ImsPhoneCallTracker.this.log("onCallTerminated reasonCode=" + imsReasonInfo.getCode());
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall2);
                if (findConnection != null) {
                    state = findConnection.getState();
                } else {
                    state = Call.State.ACTIVE;
                }
                int disconnectCauseFromReasonInfo = ImsPhoneCallTracker.this.getDisconnectCauseFromReasonInfo(imsReasonInfo2, state);
                ImsPhoneCallTracker.this.log("cause = " + disconnectCauseFromReasonInfo + " conn = " + findConnection);
                if (findConnection != null) {
                    ImsVideoCallProviderWrapper videoProvider = findConnection.getVideoProvider();
                    if (videoProvider instanceof ImsVideoCallProviderWrapper) {
                        ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = videoProvider;
                        imsVideoCallProviderWrapper.unregisterForDataUsageUpdate(ImsPhoneCallTracker.this);
                        imsVideoCallProviderWrapper.removeImsVideoProviderCallback(findConnection);
                    }
                }
                if (ImsPhoneCallTracker.this.mOnHoldToneId == System.identityHashCode(findConnection)) {
                    if (findConnection != null) {
                        ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                        if (imsPhoneCallTracker.mOnHoldToneStarted) {
                            imsPhoneCallTracker.mPhone.stopOnHoldTone(findConnection);
                        }
                    }
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker2.mOnHoldToneStarted = false;
                    imsPhoneCallTracker2.mOnHoldToneId = -1;
                }
                if (findConnection != null) {
                    if (findConnection.isPulledCall() && ((imsReasonInfo.getCode() == 1015 || imsReasonInfo.getCode() == 336 || imsReasonInfo.getCode() == 332) && (imsPhone = ImsPhoneCallTracker.this.mPhone) != null && imsPhone.getExternalCallTracker() != null)) {
                        ImsPhoneCallTracker.this.log("Call pull failed.");
                        findConnection.onCallPullFailed(ImsPhoneCallTracker.this.mPhone.getExternalCallTracker().getConnectionById(findConnection.getPulledDialogId()));
                        disconnectCauseFromReasonInfo = 0;
                    } else if (findConnection.isIncoming() && findConnection.getConnectTime() == 0 && disconnectCauseFromReasonInfo != 52) {
                        disconnectCauseFromReasonInfo = (findConnection.getDisconnectCause() == 3 || disconnectCauseFromReasonInfo == 16) ? 16 : 1;
                        ImsPhoneCallTracker.this.log("Incoming connection of 0 connect time detected - translated cause = " + disconnectCauseFromReasonInfo);
                    }
                }
                if (disconnectCauseFromReasonInfo == 2 && findConnection != null && findConnection.getImsCall().isMerged()) {
                    disconnectCauseFromReasonInfo = 45;
                }
                int updateDisconnectCause = ImsPhoneCallTracker.this.updateDisconnectCause(disconnectCauseFromReasonInfo, findConnection);
                ImsPhoneCallTracker.this.setRedialAsEcc(updateDisconnectCause);
                String callId = imsCall.getSession().getCallId();
                if (findConnection != null) {
                    emergencyNumberTracker = findConnection.getEmergencyNumberTracker();
                    emergencyNumber = findConnection.getEmergencyNumberInfo();
                } else {
                    emergencyNumberTracker = null;
                    emergencyNumber = null;
                }
                ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker3.mMetrics.writeOnImsCallTerminated(imsPhoneCallTracker3.mPhone.getPhoneId(), imsCall.getCallSession(), imsReasonInfo, (CallQualityMetrics) ImsPhoneCallTracker.this.mCallQualityMetrics.get(callId), emergencyNumber, ImsPhoneCallTracker.this.getNetworkCountryIso(), emergencyNumberTracker != null ? emergencyNumberTracker.getEmergencyNumberDbVersion() : -1);
                ImsPhoneCallTracker.this.mPhone.getVoiceCallSessionStats().onImsCallTerminated(findConnection, new ImsReasonInfo(ImsPhoneCallTracker.this.maybeRemapReasonCode(imsReasonInfo2), imsReasonInfo2.mExtraCode, imsReasonInfo2.mExtraMessage));
                CallQualityMetrics callQualityMetrics = (CallQualityMetrics) ImsPhoneCallTracker.this.mCallQualityMetrics.remove(callId);
                if (callQualityMetrics != null) {
                    ImsPhoneCallTracker.this.mCallQualityMetricsHistory.add(callQualityMetrics);
                }
                ImsPhoneCallTracker.this.pruneCallQualityMetricsHistory();
                ImsPhoneCallTracker.this.mPhone.notifyImsReason(imsReasonInfo2);
                if (findConnection != null) {
                    findConnection.setPreciseDisconnectCause(ImsPhoneCallTracker.this.getPreciseDisconnectCauseFromReasonInfo(imsReasonInfo2));
                    findConnection.setImsReasonInfo(imsReasonInfo2);
                }
                if (imsReasonInfo.getCode() == 1514 && ImsPhoneCallTracker.this.mAutoRetryFailedWifiEmergencyCall) {
                    Pair pair = new Pair(imsCall2, imsReasonInfo2);
                    ImsPhoneCallTracker.this.mPhone.getDefaultPhone().mCi.registerForOn(ImsPhoneCallTracker.this, 28, pair);
                    ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker4.sendMessageDelayed(imsPhoneCallTracker4.obtainMessage(29, pair), 10000);
                    ((ConnectivityManager) ImsPhoneCallTracker.this.mPhone.getContext().getSystemService("connectivity")).setAirplaneMode(false);
                } else if (imsReasonInfo.getCode() == 3001) {
                    Pair pair2 = new Pair(imsCall2, imsReasonInfo2);
                    ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker5.sendMessage(imsPhoneCallTracker5.obtainMessage(32, pair2));
                } else {
                    ImsPhoneCallTracker.this.processCallStateChange(imsCall2, Call.State.DISCONNECTED, updateDisconnectCause);
                    if (ImsPhoneCallTracker.this.mForegroundCall.getState() != Call.State.ACTIVE && ImsPhoneCallTracker.this.mRingingCall.getState().isRinging()) {
                        ImsPhoneCallTracker.this.disconnectPendingMo();
                    }
                    ImsPhoneCallTracker imsPhoneCallTracker6 = ImsPhoneCallTracker.this;
                    HoldSwapState holdSwapState = imsPhoneCallTracker6.mHoldSwitchingState;
                    if (holdSwapState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD) {
                        imsPhoneCallTracker6.log("onCallTerminated: Call terminated in the midst of Switching Fg and Bg calls.");
                        ImsPhoneCallTracker imsPhoneCallTracker7 = ImsPhoneCallTracker.this;
                        if (imsCall2 == imsPhoneCallTracker7.mCallExpectedToResume) {
                            imsPhoneCallTracker7.log("onCallTerminated: switching " + ImsPhoneCallTracker.this.mForegroundCall + " with " + ImsPhoneCallTracker.this.mBackgroundCall);
                            ImsPhoneCallTracker imsPhoneCallTracker8 = ImsPhoneCallTracker.this;
                            imsPhoneCallTracker8.mForegroundCall.switchWith(imsPhoneCallTracker8.mBackgroundCall);
                        }
                        ImsPhoneCallTracker imsPhoneCallTracker9 = ImsPhoneCallTracker.this;
                        StringBuilder sb = new StringBuilder();
                        sb.append("onCallTerminated: foreground call in state ");
                        sb.append(ImsPhoneCallTracker.this.mForegroundCall.getState());
                        sb.append(" and ringing call in state ");
                        ImsPhoneCall imsPhoneCall = ImsPhoneCallTracker.this.mRingingCall;
                        if (imsPhoneCall == null) {
                            str = "null";
                        } else {
                            str = imsPhoneCall.getState().toString();
                        }
                        sb.append(str);
                        imsPhoneCallTracker9.log(sb.toString());
                        ImsPhoneCallTracker.this.sendEmptyMessage(31);
                        ImsPhoneCallTracker imsPhoneCallTracker10 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker10.mHoldSwitchingState = HoldSwapState.INACTIVE;
                        imsPhoneCallTracker10.mCallExpectedToResume = null;
                        imsPhoneCallTracker10.logHoldSwapState("onCallTerminated swap active and hold case");
                    } else if (holdSwapState == HoldSwapState.PENDING_SINGLE_CALL_UNHOLD || holdSwapState == HoldSwapState.PENDING_SINGLE_CALL_HOLD) {
                        imsPhoneCallTracker6.mCallExpectedToResume = null;
                        imsPhoneCallTracker6.mHoldSwitchingState = HoldSwapState.INACTIVE;
                        imsPhoneCallTracker6.logHoldSwapState("onCallTerminated single call case");
                    } else if (holdSwapState == HoldSwapState.HOLDING_TO_ANSWER_INCOMING) {
                        if (imsCall2 == imsPhoneCallTracker6.mCallExpectedToResume) {
                            imsPhoneCallTracker6.mForegroundCall.switchWith(imsPhoneCallTracker6.mBackgroundCall);
                            ImsPhoneCallTracker imsPhoneCallTracker11 = ImsPhoneCallTracker.this;
                            imsPhoneCallTracker11.mCallExpectedToResume = null;
                            imsPhoneCallTracker11.mHoldSwitchingState = HoldSwapState.INACTIVE;
                            imsPhoneCallTracker11.logHoldSwapState("onCallTerminated hold to answer case");
                            ImsPhoneCallTracker.this.sendEmptyMessage(31);
                        }
                    } else if (holdSwapState == HoldSwapState.HOLDING_TO_DIAL_OUTGOING) {
                        ImsPhoneConnection imsPhoneConnection = imsPhoneCallTracker6.mPendingMO;
                        if (imsPhoneConnection == null || imsPhoneConnection.getDisconnectCause() != 0) {
                            ImsPhoneCallTracker imsPhoneCallTracker12 = ImsPhoneCallTracker.this;
                            imsPhoneCallTracker12.mHoldSwitchingState = HoldSwapState.INACTIVE;
                            imsPhoneCallTracker12.logHoldSwapState("onCallTerminated hold to dial but no pendingMo");
                        } else if (ImsPhoneCallTracker.this.canDailOnCallTerminated() && imsCall2 != ImsPhoneCallTracker.this.mPendingMO.getImsCall()) {
                            ImsPhoneCallTracker.this.sendEmptyMessage(20);
                            ImsPhoneCallTracker imsPhoneCallTracker13 = ImsPhoneCallTracker.this;
                            imsPhoneCallTracker13.mHoldSwitchingState = HoldSwapState.INACTIVE;
                            imsPhoneCallTracker13.logHoldSwapState("onCallTerminated hold to dial, dial pendingMo");
                        }
                    }
                    ImsPhoneCallTracker imsPhoneCallTracker14 = ImsPhoneCallTracker.this;
                    if (imsPhoneCallTracker14.mShouldUpdateImsConfigOnDisconnect) {
                        imsPhoneCallTracker14.updateImsServiceConfig();
                        ImsPhoneCallTracker.this.mShouldUpdateImsConfigOnDisconnect = false;
                    }
                    if (ImsPhoneCallTracker.this.mPendingSilentRedialInfo != null) {
                        ImsPhoneCallTracker imsPhoneCallTracker15 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker15.mPhone.initiateSilentRedial(((Boolean) imsPhoneCallTracker15.mPendingSilentRedialInfo.first).booleanValue(), ((Integer) ImsPhoneCallTracker.this.mPendingSilentRedialInfo.second).intValue());
                        ImsPhoneCallTracker.this.mPendingSilentRedialInfo = null;
                    }
                }
            }

            public void onCallHeld(ImsCall imsCall) {
                if (ImsPhoneCallTracker.this.mForegroundCall.getImsCall() == imsCall) {
                    ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker.log("onCallHeld (fg) " + imsCall);
                } else if (ImsPhoneCallTracker.this.mBackgroundCall.getImsCall() == imsCall) {
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker2.log("onCallHeld (bg) " + imsCall);
                }
                synchronized (ImsPhoneCallTracker.this.mSyncHold) {
                    Call.State state = ImsPhoneCallTracker.this.mBackgroundCall.getState();
                    ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                    Call.State state2 = Call.State.HOLDING;
                    imsPhoneCallTracker3.processCallStateChange(imsCall, state2, 0);
                    ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                    HoldSwapState holdSwapState = imsPhoneCallTracker4.mHoldSwitchingState;
                    if (holdSwapState == HoldSwapState.PENDING_RESUME_FOREGROUND_AFTER_HOLD) {
                        imsPhoneCallTracker4.sendEmptyMessage(31);
                        ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker5.mHoldSwitchingState = HoldSwapState.INACTIVE;
                        imsPhoneCallTracker5.mCallExpectedToResume = null;
                    } else if (state == Call.State.ACTIVE) {
                        if (imsPhoneCallTracker4.mForegroundCall.getState() == state2) {
                            ImsPhoneCallTracker imsPhoneCallTracker6 = ImsPhoneCallTracker.this;
                            if (imsPhoneCallTracker6.mHoldSwitchingState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD) {
                                imsPhoneCallTracker6.sendEmptyMessage(31);
                            }
                        }
                        if (ImsPhoneCallTracker.this.mRingingCall.getState() == Call.State.WAITING) {
                            ImsPhoneCallTracker imsPhoneCallTracker7 = ImsPhoneCallTracker.this;
                            if (imsPhoneCallTracker7.mHoldSwitchingState == HoldSwapState.HOLDING_TO_ANSWER_INCOMING) {
                                imsPhoneCallTracker7.sendEmptyMessage(30);
                            }
                        }
                        ImsPhoneCallTracker imsPhoneCallTracker8 = ImsPhoneCallTracker.this;
                        if (imsPhoneCallTracker8.mPendingMO == null || imsPhoneCallTracker8.mHoldSwitchingState != HoldSwapState.HOLDING_TO_DIAL_OUTGOING) {
                            imsPhoneCallTracker8.mHoldSwitchingState = HoldSwapState.INACTIVE;
                            imsPhoneCallTracker8.logHoldSwapState("onCallHeld normal case");
                        } else {
                            imsPhoneCallTracker8.dialPendingMO();
                            ImsPhoneCallTracker imsPhoneCallTracker9 = ImsPhoneCallTracker.this;
                            imsPhoneCallTracker9.mHoldSwitchingState = HoldSwapState.INACTIVE;
                            imsPhoneCallTracker9.logHoldSwapState("onCallHeld hold to dial");
                        }
                    } else if (state == Call.State.IDLE && ((holdSwapState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD || holdSwapState == HoldSwapState.HOLDING_TO_ANSWER_INCOMING) && imsPhoneCallTracker4.mForegroundCall.getState() == state2)) {
                        ImsPhoneCallTracker.this.sendEmptyMessage(31);
                        ImsPhoneCallTracker imsPhoneCallTracker10 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker10.mHoldSwitchingState = HoldSwapState.INACTIVE;
                        imsPhoneCallTracker10.mCallExpectedToResume = null;
                        imsPhoneCallTracker10.logHoldSwapState("onCallHeld premature termination of other call");
                    }
                }
                ImsPhoneCallTracker imsPhoneCallTracker11 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker11.mMetrics.writeOnImsCallHeld(imsPhoneCallTracker11.mPhone.getPhoneId(), imsCall.getCallSession());
            }

            public void onCallHoldFailed(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCallHoldFailed reasonCode=" + imsReasonInfo.getCode());
                synchronized (ImsPhoneCallTracker.this.mSyncHold) {
                    Call.State state = ImsPhoneCallTracker.this.mBackgroundCall.getState();
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    if (imsPhoneCallTracker2.mHoldSwitchingState == HoldSwapState.PENDING_RESUME_FOREGROUND_AFTER_HOLD) {
                        imsPhoneCallTracker2.mHoldSwitchingState = HoldSwapState.INACTIVE;
                    } else if (imsReasonInfo.getCode() == 148) {
                        ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                        if (imsPhoneCallTracker3.mPendingMO != null) {
                            imsPhoneCallTracker3.dialPendingMO();
                        } else {
                            if (imsPhoneCallTracker3.mRingingCall.getState() == Call.State.WAITING) {
                                ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                                if (imsPhoneCallTracker4.mHoldSwitchingState == HoldSwapState.HOLDING_TO_ANSWER_INCOMING) {
                                    imsPhoneCallTracker4.sendEmptyMessage(30);
                                }
                            }
                            if (ImsPhoneCallTracker.this.mForegroundCall.getState() == Call.State.HOLDING) {
                                ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                                if (imsPhoneCallTracker5.mHoldSwitchingState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD) {
                                    imsPhoneCallTracker5.sendEmptyMessage(31);
                                }
                            }
                        }
                        ImsPhoneCallTracker.this.mHoldSwitchingState = HoldSwapState.INACTIVE;
                    } else {
                        ImsPhoneConnection imsPhoneConnection = ImsPhoneCallTracker.this.mPendingMO;
                        if (imsPhoneConnection == null || !imsPhoneConnection.isEmergency()) {
                            if (ImsPhoneCallTracker.this.mRingingCall.getState() == Call.State.WAITING) {
                                ImsPhoneCallTracker imsPhoneCallTracker6 = ImsPhoneCallTracker.this;
                                if (imsPhoneCallTracker6.mHoldSwitchingState == HoldSwapState.HOLDING_TO_ANSWER_INCOMING) {
                                    imsPhoneCallTracker6.mHoldSwitchingState = HoldSwapState.INACTIVE;
                                    imsPhoneCallTracker6.mForegroundCall.switchWith(imsPhoneCallTracker6.mBackgroundCall);
                                    ImsPhoneCallTracker.this.logHoldSwapState("onCallHoldFailed unable to answer waiting call");
                                }
                            }
                            if (state == Call.State.ACTIVE) {
                                ImsPhoneCallTracker imsPhoneCallTracker7 = ImsPhoneCallTracker.this;
                                imsPhoneCallTracker7.mForegroundCall.switchWith(imsPhoneCallTracker7.mBackgroundCall);
                                ImsPhoneConnection imsPhoneConnection2 = ImsPhoneCallTracker.this.mPendingMO;
                                if (imsPhoneConnection2 != null) {
                                    imsPhoneConnection2.setDisconnectCause(36);
                                    ImsPhoneCallTracker.this.sendEmptyMessageDelayed(18, 500);
                                }
                                ImsPhoneCallTracker imsPhoneCallTracker8 = ImsPhoneCallTracker.this;
                                if (imsCall != imsPhoneCallTracker8.mCallExpectedToResume) {
                                    imsPhoneCallTracker8.mCallExpectedToResume = null;
                                }
                                imsPhoneCallTracker8.mHoldSwitchingState = HoldSwapState.INACTIVE;
                            }
                        } else {
                            ImsPhoneCallTracker.this.mBackgroundCall.getImsCall().terminate(0);
                            ImsPhoneCallTracker imsPhoneCallTracker9 = ImsPhoneCallTracker.this;
                            if (imsCall != imsPhoneCallTracker9.mCallExpectedToResume) {
                                imsPhoneCallTracker9.mCallExpectedToResume = null;
                            }
                        }
                    }
                    ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                    if (!(findConnection == null || findConnection.getState() == Call.State.DISCONNECTED)) {
                        findConnection.onConnectionEvent("android.telecom.event.CALL_HOLD_FAILED", (Bundle) null);
                    }
                    ImsPhoneCallTracker.this.mPhone.notifySuppServiceFailed(PhoneInternalInterface.SuppService.HOLD);
                }
                ImsPhoneCallTracker imsPhoneCallTracker10 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker10.mMetrics.writeOnImsCallHoldFailed(imsPhoneCallTracker10.mPhone.getPhoneId(), imsCall.getCallSession(), imsReasonInfo);
            }

            public void onCallResumed(ImsCall imsCall) {
                ImsPhoneCallTracker.this.log("onCallResumed");
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                HoldSwapState holdSwapState = imsPhoneCallTracker.mHoldSwitchingState;
                if (holdSwapState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD || holdSwapState == HoldSwapState.PENDING_RESUME_FOREGROUND_AFTER_FAILURE || holdSwapState == HoldSwapState.PENDING_SINGLE_CALL_UNHOLD) {
                    if (imsCall != imsPhoneCallTracker.mCallExpectedToResume) {
                        imsPhoneCallTracker.log("onCallResumed : switching " + ImsPhoneCallTracker.this.mForegroundCall + " with " + ImsPhoneCallTracker.this.mBackgroundCall);
                        ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker2.mForegroundCall.switchWith(imsPhoneCallTracker2.mBackgroundCall);
                    } else {
                        imsPhoneCallTracker.log("onCallResumed : expected call resumed.");
                    }
                    ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker3.mHoldSwitchingState = HoldSwapState.INACTIVE;
                    imsPhoneCallTracker3.mCallExpectedToResume = null;
                    imsPhoneCallTracker3.logHoldSwapState("onCallResumed");
                }
                ImsPhoneCallTracker.this.processCallStateChange(imsCall, Call.State.ACTIVE, 0);
                ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker4.mMetrics.writeOnImsCallResumed(imsPhoneCallTracker4.mPhone.getPhoneId(), imsCall.getCallSession());
            }

            public void onCallResumeFailed(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                HoldSwapState holdSwapState = imsPhoneCallTracker.mHoldSwitchingState;
                if (holdSwapState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD || holdSwapState == HoldSwapState.PENDING_RESUME_FOREGROUND_AFTER_FAILURE) {
                    if (imsCall == imsPhoneCallTracker.mCallExpectedToResume) {
                        imsPhoneCallTracker.log("onCallResumeFailed : switching " + ImsPhoneCallTracker.this.mForegroundCall + " with " + ImsPhoneCallTracker.this.mBackgroundCall);
                        ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker2.mForegroundCall.switchWith(imsPhoneCallTracker2.mBackgroundCall);
                        if (ImsPhoneCallTracker.this.mForegroundCall.getState() == Call.State.HOLDING) {
                            ImsPhoneCallTracker.this.sendEmptyMessage(31);
                        }
                    }
                    ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker3.mCallExpectedToResume = null;
                    imsPhoneCallTracker3.mHoldSwitchingState = HoldSwapState.INACTIVE;
                    imsPhoneCallTracker3.logHoldSwapState("onCallResumeFailed: multi calls");
                } else if (holdSwapState == HoldSwapState.PENDING_SINGLE_CALL_UNHOLD) {
                    if (imsCall == imsPhoneCallTracker.mCallExpectedToResume) {
                        imsPhoneCallTracker.log("onCallResumeFailed: single call unhold case");
                        ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker4.mForegroundCall.switchWith(imsPhoneCallTracker4.mBackgroundCall);
                        ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker5.mCallExpectedToResume = null;
                        imsPhoneCallTracker5.mHoldSwitchingState = HoldSwapState.INACTIVE;
                        imsPhoneCallTracker5.logHoldSwapState("onCallResumeFailed: single call");
                    } else {
                        Rlog.w(ImsPhoneCallTracker.LOG_TAG, "onCallResumeFailed: got a resume failed for a different call in the single call unhold case");
                    }
                }
                ImsPhoneCallTracker.this.mPhone.notifySuppServiceFailed(PhoneInternalInterface.SuppService.RESUME);
                ImsPhoneCallTracker imsPhoneCallTracker6 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker6.mMetrics.writeOnImsCallResumeFailed(imsPhoneCallTracker6.mPhone.getPhoneId(), imsCall.getCallSession(), imsReasonInfo);
            }

            public void onCallResumeReceived(ImsCall imsCall) {
                ImsPhoneCallTracker.this.log("onCallResumeReceived");
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                    if (imsPhoneCallTracker.mOnHoldToneStarted) {
                        imsPhoneCallTracker.mPhone.stopOnHoldTone(findConnection);
                        ImsPhoneCallTracker.this.mOnHoldToneStarted = false;
                    }
                    findConnection.onConnectionEvent("android.telecom.event.CALL_REMOTELY_UNHELD", (Bundle) null);
                }
                if (ImsPhoneCallTracker.this.mPhone.getContext().getResources().getBoolean(17891821) && ImsPhoneCallTracker.this.mSupportPauseVideo && VideoProfile.isVideo(findConnection.getVideoState())) {
                    findConnection.changeToUnPausedState();
                }
                SuppServiceNotification suppServiceNotification = new SuppServiceNotification();
                suppServiceNotification.notificationType = 1;
                suppServiceNotification.code = 3;
                ImsPhoneCallTracker.this.mPhone.notifySuppSvcNotification(suppServiceNotification);
                ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker2.mMetrics.writeOnImsCallResumeReceived(imsPhoneCallTracker2.mPhone.getPhoneId(), imsCall.getCallSession());
            }

            public void onCallHoldReceived(ImsCall imsCall) {
                ImsPhoneCallTracker.this.onCallHoldReceived(imsCall);
            }

            public void onCallSuppServiceReceived(ImsCall imsCall, ImsSuppServiceNotification imsSuppServiceNotification) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCallSuppServiceReceived: suppServiceInfo=" + imsSuppServiceNotification);
                SuppServiceNotification suppServiceNotification = new SuppServiceNotification();
                suppServiceNotification.notificationType = imsSuppServiceNotification.notificationType;
                suppServiceNotification.code = imsSuppServiceNotification.code;
                suppServiceNotification.index = imsSuppServiceNotification.index;
                suppServiceNotification.number = imsSuppServiceNotification.number;
                suppServiceNotification.history = imsSuppServiceNotification.history;
                ImsPhoneCallTracker.this.mPhone.notifySuppSvcNotification(suppServiceNotification);
            }

            public void onCallMerged(ImsCall imsCall, ImsCall imsCall2, boolean z) {
                ImsPhoneCall imsPhoneCall;
                ImsPhoneCallTracker.this.log("onCallMerged");
                ImsPhoneCall call = ImsPhoneCallTracker.this.findConnection(imsCall).getCall();
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall2);
                if (findConnection == null) {
                    imsPhoneCall = null;
                } else {
                    imsPhoneCall = findConnection.getCall();
                }
                if (z) {
                    ImsPhoneCallTracker.this.switchAfterConferenceSuccess();
                }
                call.merge(imsPhoneCall, Call.State.ACTIVE);
                ImsPhoneConnection findConnection2 = ImsPhoneCallTracker.this.findConnection(imsCall);
                try {
                    ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker.log("onCallMerged: ImsPhoneConnection=" + findConnection2);
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker2.log("onCallMerged: CurrentVideoProvider=" + findConnection2.getVideoProvider());
                    ImsPhoneCallTracker.this.setVideoCallProvider(findConnection2, imsCall);
                    ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker3.log("onCallMerged: CurrentVideoProvider=" + findConnection2.getVideoProvider());
                } catch (Exception e) {
                    ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker4.loge("onCallMerged: exception " + e);
                }
                ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker5.processCallStateChange(imsPhoneCallTracker5.mForegroundCall.getImsCall(), Call.State.ACTIVE, 0);
                if (findConnection != null) {
                    ImsPhoneCallTracker imsPhoneCallTracker6 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker6.processCallStateChange(imsPhoneCallTracker6.mBackgroundCall.getImsCall(), Call.State.HOLDING, 0);
                    findConnection.handleMergeComplete();
                }
                if (!imsCall.isMergeRequestedByConf()) {
                    ImsPhoneCallTracker.this.log("onCallMerged :: calling onMultipartyStateChanged()");
                    onMultipartyStateChanged(imsCall, true);
                } else {
                    ImsPhoneCallTracker.this.log("onCallMerged :: Merge requested by existing conference.");
                    imsCall.resetIsMergeRequestedByConf(false);
                }
                if (findConnection2 != null) {
                    findConnection2.handleMergeComplete();
                }
                ImsPhoneCallTracker.this.logState();
            }

            public void onCallMergeFailed(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCallMergeFailed reasonInfo=" + imsReasonInfo);
                ImsPhoneCallTracker.this.mPhone.notifySuppServiceFailed(PhoneInternalInterface.SuppService.CONFERENCE);
                imsCall.resetIsMergeRequestedByConf(false);
                ImsPhoneConnection firstConnection = ImsPhoneCallTracker.this.mForegroundCall.getFirstConnection();
                if (firstConnection != null) {
                    firstConnection.onConferenceMergeFailed();
                    firstConnection.handleMergeComplete();
                }
                ImsPhoneConnection firstConnection2 = ImsPhoneCallTracker.this.mBackgroundCall.getFirstConnection();
                if (firstConnection2 != null) {
                    firstConnection2.onConferenceMergeFailed();
                    firstConnection2.handleMergeComplete();
                }
            }

            private void updateConferenceParticipantsTiming(List<ConferenceParticipant> list) {
                for (ConferenceParticipant next : list) {
                    CacheEntry r1 = ImsPhoneCallTracker.this.findConnectionTimeUsePhoneNumber(next);
                    if (r1 != null) {
                        next.setConnectTime(r1.mConnectTime);
                        next.setConnectElapsedTime(r1.mConnectElapsedTime);
                        next.setCallDirection(r1.mCallDirection);
                    }
                }
            }

            public void onConferenceParticipantsStateChanged(ImsCall imsCall, List<ConferenceParticipant> list) {
                ImsPhoneCallTracker.this.log("onConferenceParticipantsStateChanged");
                if (!ImsPhoneCallTracker.this.mIsConferenceEventPackageEnabled) {
                    ImsPhoneCallTracker.this.logi("onConferenceParticipantsStateChanged - CEP handling disabled");
                } else if (ImsPhoneCallTracker.this.mSupportCepOnPeer || imsCall.isConferenceHost()) {
                    ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                    if (findConnection != null) {
                        updateConferenceParticipantsTiming(list);
                        findConnection.updateConferenceParticipants(list);
                    }
                } else {
                    ImsPhoneCallTracker.this.logi("onConferenceParticipantsStateChanged - ignore CEP on peer");
                }
            }

            public void onCallSessionTtyModeReceived(ImsCall imsCall, int i) {
                ImsPhoneCallTracker.this.mPhone.onTtyModeReceived(i);
            }

            public void onCallHandover(ImsCall imsCall, int i, int i2, ImsReasonInfo imsReasonInfo) {
                boolean z;
                if (ImsPhoneCallTracker.this.mPhone.getDefaultPhone().isUsingNewDataStack()) {
                    z = ImsPhoneCallTracker.this.mPhone.getDefaultPhone().getDataSettingsManager().isDataEnabled();
                } else {
                    z = ImsPhoneCallTracker.this.mPhone.getDefaultPhone().getDataEnabledSettings().isDataEnabled();
                }
                ImsPhoneCallTracker.this.log("onCallHandover ::  srcAccessTech=" + i + ", targetAccessTech=" + i2 + ", reasonInfo=" + imsReasonInfo + ", dataEnabled=" + ImsPhoneCallTracker.this.mIsDataEnabled + "/" + z + ", dataMetered=" + ImsPhoneCallTracker.this.mIsViLteDataMetered);
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                if (imsPhoneCallTracker.mIsDataEnabled != z) {
                    imsPhoneCallTracker.loge("onCallHandover: data enabled state doesn't match! (was=" + ImsPhoneCallTracker.this.mIsDataEnabled + ", actually=" + z);
                    ImsPhoneCallTracker.this.mIsDataEnabled = z;
                }
                boolean z2 = false;
                boolean z3 = (i == 0 || i == 18 || i2 != 18) ? false : true;
                if (!(i != 18 || i2 == 0 || i2 == 18)) {
                    z2 = true;
                }
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    if (findConnection.getDisconnectCause() == 0) {
                        if (z3) {
                            ImsPhoneCallTracker.this.removeMessages(25);
                            if (ImsPhoneCallTracker.this.mNotifyHandoverVideoFromLTEToWifi && ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover) {
                                findConnection.onConnectionEvent("android.telephony.event.EVENT_HANDOVER_VIDEO_FROM_LTE_TO_WIFI", (Bundle) null);
                            }
                            ImsPhoneCallTracker.this.unregisterForConnectivityChanges();
                        } else if (z2 && imsCall.isVideoCall()) {
                            ImsPhoneCallTracker.this.registerForConnectivityChanges();
                        }
                    }
                    if (z3 && ImsPhoneCallTracker.this.mIsViLteDataMetered) {
                        findConnection.setLocalVideoCapable(true);
                    }
                    if (z2 && imsCall.isVideoCall()) {
                        ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                        if (imsPhoneCallTracker2.mIsViLteDataMetered) {
                            findConnection.setLocalVideoCapable(imsPhoneCallTracker2.mIsDataEnabled);
                        }
                        ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                        if (imsPhoneCallTracker3.mNotifyHandoverVideoFromWifiToLTE && imsPhoneCallTracker3.mIsDataEnabled) {
                            if (findConnection.getDisconnectCause() == 0) {
                                ImsPhoneCallTracker.this.log("onCallHandover :: notifying of WIFI to LTE handover.");
                                findConnection.onConnectionEvent("android.telephony.event.EVENT_HANDOVER_VIDEO_FROM_WIFI_TO_LTE", (Bundle) null);
                            } else {
                                ImsPhoneCallTracker.this.log("onCallHandover :: skip notify of WIFI to LTE handover for disconnected call.");
                            }
                        }
                        ImsPhoneCallTracker imsPhoneCallTracker4 = ImsPhoneCallTracker.this;
                        if (!imsPhoneCallTracker4.mIsDataEnabled && imsPhoneCallTracker4.mIsViLteDataMetered) {
                            imsPhoneCallTracker4.log("onCallHandover :: data is not enabled; attempt to downgrade.");
                            ImsPhoneCallTracker.this.downgradeVideoCall(1407, findConnection);
                        }
                    }
                } else {
                    ImsPhoneCallTracker.this.loge("onCallHandover :: connection null.");
                }
                if (!ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover) {
                    ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover = true;
                }
                ImsPhoneCallTracker imsPhoneCallTracker5 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker5.mMetrics.writeOnImsCallHandoverEvent(imsPhoneCallTracker5.mPhone.getPhoneId(), 18, imsCall.getCallSession(), i, i2, imsReasonInfo);
            }

            public void onCallHandoverFailed(ImsCall imsCall, int i, int i2, ImsReasonInfo imsReasonInfo) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCallHandoverFailed :: srcAccessTech=" + i + ", targetAccessTech=" + i2 + ", reasonInfo=" + imsReasonInfo);
                ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                imsPhoneCallTracker2.mMetrics.writeOnImsCallHandoverEvent(imsPhoneCallTracker2.mPhone.getPhoneId(), 19, imsCall.getCallSession(), i, i2, imsReasonInfo);
                boolean z = i != 18 && i2 == 18;
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null && z) {
                    ImsPhoneCallTracker.this.log("onCallHandoverFailed - handover to WIFI Failed");
                    ImsPhoneCallTracker.this.removeMessages(25);
                    if (imsCall.isVideoCall() && findConnection.getDisconnectCause() == 0) {
                        ImsPhoneCallTracker.this.registerForConnectivityChanges();
                    }
                    if (ImsPhoneCallTracker.this.mNotifyVtHandoverToWifiFail) {
                        findConnection.onHandoverToWifiFailed();
                    }
                }
                if (!ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover) {
                    ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover = true;
                }
            }

            public void onRttModifyRequestReceived(ImsCall imsCall) {
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    findConnection.onRttModifyRequestReceived();
                }
            }

            public void onRttModifyResponseReceived(ImsCall imsCall, int i) {
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    findConnection.onRttModifyResponseReceived(i);
                }
            }

            public void onRttMessageReceived(ImsCall imsCall, String str) {
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    findConnection.onRttMessageReceived(str);
                }
            }

            public void onRttAudioIndicatorChanged(ImsCall imsCall, ImsStreamMediaProfile imsStreamMediaProfile) {
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    findConnection.onRttAudioIndicatorChanged(imsStreamMediaProfile);
                }
            }

            public void onCallSessionTransferred(ImsCall imsCall) {
                ImsPhoneCallTracker.this.log("onCallSessionTransferred success");
            }

            public void onCallSessionTransferFailed(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCallSessionTransferFailed reasonInfo=" + imsReasonInfo);
                ImsPhoneCallTracker.this.mPhone.notifySuppServiceFailed(PhoneInternalInterface.SuppService.TRANSFER);
            }

            public void onCallSessionDtmfReceived(ImsCall imsCall, char c) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCallSessionDtmfReceived digit=" + c);
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    findConnection.receivedDtmfDigit(c);
                }
            }

            public void onMultipartyStateChanged(ImsCall imsCall, boolean z) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                StringBuilder sb = new StringBuilder();
                sb.append("onMultipartyStateChanged to ");
                sb.append(z ? "Y" : "N");
                imsPhoneCallTracker.log(sb.toString());
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    findConnection.updateMultipartyState(z);
                    ImsPhoneCallTracker.this.mPhone.getVoiceCallSessionStats().onMultipartyChange(findConnection, z);
                }
            }

            public void onCallQualityChanged(ImsCall imsCall, CallQuality callQuality) {
                ImsPhoneCallTracker.this.mPhone.onCallQualityChanged(callQuality, imsCall.getNetworkType());
                String callId = imsCall.getSession().getCallId();
                CallQualityMetrics callQualityMetrics = (CallQualityMetrics) ImsPhoneCallTracker.this.mCallQualityMetrics.get(callId);
                if (callQualityMetrics == null) {
                    callQualityMetrics = new CallQualityMetrics(ImsPhoneCallTracker.this.mPhone);
                }
                callQualityMetrics.saveCallQuality(callQuality);
                ImsPhoneCallTracker.this.mCallQualityMetrics.put(callId, callQualityMetrics);
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    Bundle bundle = new Bundle();
                    bundle.putParcelable("android.telecom.extra.CALL_QUALITY_REPORT", callQuality);
                    findConnection.onConnectionEvent("android.telecom.event.CALL_QUALITY_REPORT", bundle);
                }
            }

            public void onCallSessionRtpHeaderExtensionsReceived(ImsCall imsCall, Set<RtpHeaderExtension> set) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCallSessionRtpHeaderExtensionsReceived numExtensions=" + set.size());
                ImsPhoneConnection findConnection = ImsPhoneCallTracker.this.findConnection(imsCall);
                if (findConnection != null) {
                    findConnection.receivedRtpHeaderExtensions(set);
                }
            }
        };
        this.mImsUssdListener = new ImsCall.Listener() {
            public void onCallStarted(ImsCall imsCall) {
                Message message;
                ImsPhoneCallTracker.this.log("mImsUssdListener onCallStarted");
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                if (imsCall == imsPhoneCallTracker.mUssdSession && (message = imsPhoneCallTracker.mPendingUssd) != null) {
                    AsyncResult.forMessage(message);
                    ImsPhoneCallTracker.this.mPendingUssd.sendToTarget();
                    ImsPhoneCallTracker.this.mPendingUssd = null;
                }
            }

            public void onCallStartFailed(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("mImsUssdListener onCallStartFailed reasonCode=" + imsReasonInfo.getCode());
                ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                if (imsPhoneCallTracker2.mUssdSession != null) {
                    imsPhoneCallTracker2.log("mUssdSession is not null");
                    if (imsReasonInfo.getCode() != 146 || ImsPhoneCallTracker.this.mUssdMethod == 3) {
                        ImsPhoneCallTracker.this.log("Failed to start sending ussd by using silent resendUssd.!!");
                    } else {
                        ImsPhoneCallTracker imsPhoneCallTracker3 = ImsPhoneCallTracker.this;
                        imsPhoneCallTracker3.mUssdSession = null;
                        imsPhoneCallTracker3.mPhone.getPendingMmiCodes().clear();
                        ImsPhoneCallTracker.this.mPhone.initiateSilentRedial();
                        ImsPhoneCallTracker.this.log("Initiated sending ussd by using silent redial.");
                        return;
                    }
                }
                onCallTerminated(imsCall, imsReasonInfo);
            }

            public void onCallTerminated(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("mImsUssdListener onCallTerminated reasonCode=" + imsReasonInfo.getCode());
                ImsPhoneCallTracker.this.removeMessages(25);
                ImsPhoneCallTracker.this.mHasAttemptedStartOfCallHandover = false;
                ImsPhoneCallTracker.this.unregisterForConnectivityChanges();
                ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                if (imsCall == imsPhoneCallTracker2.mUssdSession) {
                    imsPhoneCallTracker2.mUssdSession = null;
                    if (imsPhoneCallTracker2.mPendingUssd != null) {
                        AsyncResult.forMessage(ImsPhoneCallTracker.this.mPendingUssd, (Object) null, imsPhoneCallTracker2.getImsUssdCommandException(imsReasonInfo));
                        ImsPhoneCallTracker.this.mPendingUssd.sendToTarget();
                        ImsPhoneCallTracker.this.mPendingUssd = null;
                    }
                }
                imsCall.close();
            }

            public void onCallUssdMessageReceived(ImsCall imsCall, int i, String str) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("mImsUssdListener onCallUssdMessageReceived mode=" + i);
                int i2 = 1;
                if (i == 0) {
                    i2 = 0;
                } else if (i != 1) {
                    i2 = -1;
                }
                ImsPhoneCallTracker.this.mPhone.onIncomingUSSD(i2, str);
            }
        };
        this.mImsCapabilityCallback = new ImsMmTelManager.CapabilityCallback() {
            public void onCapabilitiesStatusChanged(MmTelFeature.MmTelCapabilities mmTelCapabilities) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("onCapabilitiesStatusChanged: " + mmTelCapabilities);
                SomeArgs obtain = SomeArgs.obtain();
                obtain.arg1 = mmTelCapabilities;
                ImsPhoneCallTracker.this.removeMessages(26);
                ImsPhoneCallTracker.this.obtainMessage(26, obtain).sendToTarget();
            }
        };
        this.mImsStatsCallback = new ImsManager.ImsStatsCallback() {
            public void onEnabledMmTelCapabilitiesChanged(int i, int i2, boolean z) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.mMetrics.writeImsSetFeatureValue(imsPhoneCallTracker.mPhone.getPhoneId(), i, i2, z ? 1 : 0);
                ImsPhoneCallTracker.this.mPhone.getImsStats().onSetFeatureResponse(i, i2, z);
            }
        };
        this.mConfigCallback = new ProvisioningManager.Callback() {
            public void onProvisioningIntChanged(int i, int i2) {
                sendConfigChangedIntent(i, Integer.toString(i2));
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                if (imsPhoneCallTracker.mImsManager == null) {
                    return;
                }
                if (i == 28 || i == 10 || i == 11) {
                    imsPhoneCallTracker.updateImsServiceConfig();
                }
            }

            public void onProvisioningStringChanged(int i, String str) {
                sendConfigChangedIntent(i, str);
            }

            private void sendConfigChangedIntent(int i, String str) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.log("sendConfigChangedIntent - [" + i + ", " + str + "]");
                Intent intent = new Intent("com.android.intent.action.IMS_CONFIG_CHANGED");
                intent.putExtra("item", i);
                intent.putExtra(MtkPatterns.KEY_URLDATA_VALUE, str);
                ImsPhone imsPhone = ImsPhoneCallTracker.this.mPhone;
                if (imsPhone != null && imsPhone.getContext() != null) {
                    ImsPhoneCallTracker.this.mPhone.getContext().sendBroadcast(intent);
                }
            }
        };
        this.mPhone = imsPhone;
        this.mConnectorFactory = connectorFactory;
        if (executor != null) {
            this.mExecutor = executor;
        }
        this.mMetrics = TelephonyMetrics.getInstance();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction("android.telecom.action.DEFAULT_DIALER_CHANGED");
        this.mPhone.getContext().registerReceiver(r2, intentFilter);
        updateCarrierConfiguration(this.mPhone.getSubId(), getCarrierConfigBundle(this.mPhone.getSubId()));
        if (this.mPhone.getDefaultPhone().isUsingNewDataStack()) {
            this.mSettingsCallback = new DataSettingsManager.DataSettingsManagerCallback(new ImsPhoneCallTracker$$ExternalSyntheticLambda0(this)) {
                public void onDataEnabledChanged(boolean z, int i, String str) {
                    int i2 = 4;
                    if (i == 0) {
                        i2 = 2;
                    } else if (i == 1) {
                        i2 = 3;
                    } else if (i != 2) {
                        i2 = i != 3 ? i != 4 ? 1 : 7 : 9;
                    }
                    ImsPhoneCallTracker.this.onDataEnabledChanged(z, i2);
                }
            };
            this.mPhone.getDefaultPhone().getDataSettingsManager().registerCallback(this.mSettingsCallback);
        } else {
            this.mPhone.getDefaultPhone().getDataEnabledSettings().registerForDataEnabledChanged(this, 23, (Object) null);
        }
        atomicInteger.set(getPackageUid(this.mPhone.getContext(), ((TelecomManager) this.mPhone.getContext().getSystemService("telecom")).getDefaultDialerPackage()));
        long elapsedRealtime = SystemClock.elapsedRealtime();
        this.mVtDataUsageSnapshot = new NetworkStats(elapsedRealtime, 1);
        this.mVtDataUsageUidSnapshot = new NetworkStats(elapsedRealtime, 1);
        ((NetworkStatsManager) this.mPhone.getContext().getSystemService("netstats")).registerNetworkStatsProvider(LOG_TAG, vtDataUsageProvider);
        this.mImsManagerConnector = connectorFactory.create(this.mPhone.getContext(), this.mPhone.getPhoneId(), LOG_TAG, new FeatureConnector.Listener<ImsManager>() {
            public void connectionReady(ImsManager imsManager, int i) throws ImsException {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.mImsManager = imsManager;
                imsPhoneCallTracker.log("connectionReady for subId = " + i);
                ImsPhoneCallTracker.this.startListeningForCalls(i);
            }

            public void connectionUnavailable(int i) {
                ImsPhoneCallTracker imsPhoneCallTracker = ImsPhoneCallTracker.this;
                imsPhoneCallTracker.logi("connectionUnavailable: " + i);
                if (i == 3) {
                    ImsPhoneCallTracker imsPhoneCallTracker2 = ImsPhoneCallTracker.this;
                    imsPhoneCallTracker2.postDelayed(imsPhoneCallTracker2.mConnectorRunnable, 5000);
                }
                ImsPhoneCallTracker.this.stopListeningForCalls();
            }
        }, executor);
        post(this.mConnectorRunnable);
    }

    @VisibleForTesting
    public void setSharedPreferenceProxy(SharedPreferenceProxy sharedPreferenceProxy) {
        this.mSharedPreferenceProxy = sharedPreferenceProxy;
    }

    /* access modifiers changed from: private */
    public int getPackageUid(Context context, String str) {
        if (str == null) {
            return -1;
        }
        try {
            return context.getPackageManager().getPackageUid(str, 0);
        } catch (PackageManager.NameNotFoundException unused) {
            loge("Cannot find package uid. pkg = " + str);
            return -1;
        }
    }

    @VisibleForTesting
    public void startListeningForCalls(int i) throws ImsException {
        log("startListeningForCalls");
        this.mOperationLocalLog.log("startListeningForCalls - Connecting to ImsService");
        ImsExternalCallTracker externalCallTracker = this.mPhone.getExternalCallTracker();
        this.mImsManager.open(this.mMmTelFeatureListener, this.mPhone.getImsEcbmStateListener(), externalCallTracker != null ? externalCallTracker.getExternalCallStateListener() : null);
        this.mImsManager.addRegistrationCallback(this.mPhone.getImsMmTelRegistrationCallback(), new ImsPhoneCallTracker$$ExternalSyntheticLambda0(this));
        this.mImsManager.addCapabilitiesCallback(this.mImsCapabilityCallback, new ImsPhoneCallTracker$$ExternalSyntheticLambda0(this));
        ImsManager.setImsStatsCallback(this.mPhone.getPhoneId(), this.mImsStatsCallback);
        this.mImsManager.getConfigInterface().addConfigCallback(this.mConfigCallback);
        if (this.mPhone.isInEcm()) {
            this.mPhone.exitEmergencyCallbackMode();
        }
        this.mImsManager.setUiTTYMode(this.mPhone.getContext(), Settings.Secure.getInt(this.mPhone.getContext().getContentResolver(), "preferred_tty_mode", 0), (Message) null);
        ImsUtInterface utInterface = getUtInterface();
        this.mUtInterface = utInterface;
        if (utInterface != null) {
            utInterface.registerForSuppServiceIndication(this, 27, (Object) null);
        }
        Pair<Integer, PersistableBundle> pair = this.mCarrierConfigForSubId;
        if (pair == null || ((Integer) pair.first).intValue() != i) {
            log("startListeningForCalls - waiting for the first carrier config indication for this subscription");
        } else {
            updateCarrierConfiguration(i, (PersistableBundle) this.mCarrierConfigForSubId.second);
        }
        sendImsServiceStateIntent("com.android.ims.IMS_SERVICE_UP");
        this.mCurrentlyConnectedSubId = Optional.of(Integer.valueOf(i));
    }

    private void maybeConfigureRtpHeaderExtensions() {
        Config config;
        if (this.mDeviceToDeviceForceEnabled || ((config = this.mConfig) != null && config.isD2DCommunicationSupported && this.mSupportD2DUsingRtp)) {
            ArraySet arraySet = new ArraySet();
            if (this.mSupportSdpForRtpHeaderExtensions) {
                arraySet.add(RtpTransport.CALL_STATE_RTP_HEADER_EXTENSION_TYPE);
                arraySet.add(RtpTransport.DEVICE_STATE_RTP_HEADER_EXTENSION_TYPE);
                logi("maybeConfigureRtpHeaderExtensions: set offered RTP header extension types");
            } else {
                logi("maybeConfigureRtpHeaderExtensions: SDP negotiation not supported; not setting offered RTP header extension types");
            }
            try {
                this.mImsManager.setOfferedRtpHeaderExtensionTypes(arraySet);
            } catch (ImsException e) {
                loge("maybeConfigureRtpHeaderExtensions: failed to set extensions; " + e);
            }
        }
    }

    public void setDeviceToDeviceForceEnabled(boolean z) {
        this.mDeviceToDeviceForceEnabled = z;
        maybeConfigureRtpHeaderExtensions();
    }

    /* access modifiers changed from: private */
    public void stopListeningForCalls() {
        log("stopListeningForCalls");
        this.mOperationLocalLog.log("stopListeningForCalls - Disconnecting from ImsService");
        ImsManager imsManager = this.mImsManager;
        if (imsManager != null) {
            imsManager.removeRegistrationListener(this.mPhone.getImsMmTelRegistrationCallback());
            this.mImsManager.removeCapabilitiesCallback(this.mImsCapabilityCallback);
            try {
                ImsManager.setImsStatsCallback(this.mPhone.getPhoneId(), (ImsManager.ImsStatsCallback) null);
                this.mImsManager.getConfigInterface().removeConfigCallback(this.mConfigCallback.getBinder());
            } catch (ImsException unused) {
                Log.w(LOG_TAG, "stopListeningForCalls: unable to remove config callback.");
            }
            this.mImsManager.close();
        }
        ImsUtInterface imsUtInterface = this.mUtInterface;
        if (imsUtInterface != null) {
            imsUtInterface.unregisterForSuppServiceIndication(this);
            this.mUtInterface = null;
        }
        this.mCurrentlyConnectedSubId = Optional.empty();
        resetImsCapabilities();
        hangupAllOrphanedConnections(14);
        sendImsServiceStateIntent("com.android.ims.IMS_SERVICE_DOWN");
    }

    @VisibleForTesting
    public void hangupAllOrphanedConnections(int i) {
        Log.w(LOG_TAG, "hangupAllOngoingConnections called for cause " + i);
        int size = getConnections().size();
        while (true) {
            size--;
            if (size <= -1) {
                break;
            }
            try {
                getConnections().get(size).hangup();
            } catch (CallStateException unused) {
                loge("Failed to disconnet call...");
            }
        }
        Iterator<ImsPhoneConnection> it = this.mConnections.iterator();
        while (it.hasNext()) {
            ImsPhoneConnection next = it.next();
            next.update(next.getImsCall(), Call.State.DISCONNECTED);
            next.onDisconnect(i);
            next.getCall().detach(next);
        }
        this.mConnections.clear();
        this.mPendingMO = null;
        updatePhoneState();
    }

    public void hangupAllConnections() {
        getConnections().stream().forEach(new ImsPhoneCallTracker$$ExternalSyntheticLambda3(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$hangupAllConnections$1(ImsPhoneConnection imsPhoneConnection) {
        logi("Disconnecting callId = " + imsPhoneConnection.getTelecomCallId());
        try {
            imsPhoneConnection.hangup();
        } catch (CallStateException unused) {
            loge("Failed to disconnet call...");
        }
    }

    private void sendImsServiceStateIntent(String str) {
        Intent intent = new Intent(str);
        intent.putExtra("android:phone_id", this.mPhone.getPhoneId());
        ImsPhone imsPhone = this.mPhone;
        if (imsPhone != null && imsPhone.getContext() != null) {
            this.mPhone.getContext().sendBroadcast(intent);
        }
    }

    public void dispose() {
        log("dispose");
        this.mRingingCall.dispose();
        this.mBackgroundCall.dispose();
        this.mForegroundCall.dispose();
        this.mHandoverCall.dispose();
        clearDisconnected();
        this.mPhone.getContext().unregisterReceiver(this.mReceiver);
        if (this.mPhone.getDefaultPhone().isUsingNewDataStack()) {
            this.mPhone.getDefaultPhone().getDataSettingsManager().unregisterCallback(this.mSettingsCallback);
        } else {
            this.mPhone.getDefaultPhone().getDataEnabledSettings().unregisterForDataEnabledChanged(this);
        }
        this.mImsManagerConnector.disconnect();
        ((NetworkStatsManager) this.mPhone.getContext().getSystemService("netstats")).unregisterNetworkStatsProvider(this.mVtDataUsageProvider);
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        log("ImsPhoneCallTracker finalized");
    }

    public void registerForVoiceCallStarted(Handler handler, int i, Object obj) {
        this.mVoiceCallStartedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForVoiceCallStarted(Handler handler) {
        this.mVoiceCallStartedRegistrants.remove(handler);
    }

    public void registerForVoiceCallEnded(Handler handler, int i, Object obj) {
        this.mVoiceCallEndedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForVoiceCallEnded(Handler handler) {
        this.mVoiceCallEndedRegistrants.remove(handler);
    }

    public int getClirMode() {
        if (this.mSharedPreferenceProxy == null || this.mPhone.getDefaultPhone() == null) {
            loge("dial; could not get default CLIR mode.");
            return 0;
        }
        SharedPreferences defaultSharedPreferences = this.mSharedPreferenceProxy.getDefaultSharedPreferences(this.mPhone.getContext());
        return defaultSharedPreferences.getInt(Phone.CLIR_KEY + this.mPhone.getSubId(), 0);
    }

    private boolean prepareForDialing(ImsPhone.ImsDialArgs imsDialArgs) throws CallStateException {
        boolean z;
        clearDisconnected();
        if (this.mImsManager != null) {
            checkForDialIssues();
            int i = imsDialArgs.videoState;
            if (canAddVideoCallDuringImsAudioCall(i)) {
                checkforCsfb();
                Call.State state = this.mForegroundCall.getState();
                Call.State state2 = Call.State.ACTIVE;
                boolean z2 = false;
                if (state != state2) {
                    z = false;
                } else if (this.mBackgroundCall.getState() == Call.State.IDLE) {
                    z = true;
                    this.mPendingCallVideoState = i;
                    this.mPendingIntentExtras = imsDialArgs.intentExtras;
                    holdActiveCallForPendingMo();
                } else {
                    throw new CallStateException(6, "Already too many ongoing calls.");
                }
                Call.State state3 = Call.State.IDLE;
                synchronized (this.mSyncHold) {
                    if (z) {
                        Call.State state4 = this.mForegroundCall.getState();
                        Call.State state5 = this.mBackgroundCall.getState();
                        if (state4 == state2) {
                            throw new CallStateException("cannot dial in current state");
                        } else if (state5 == Call.State.HOLDING) {
                        }
                    }
                    z2 = z;
                }
                return z2;
            }
            throw new CallStateException("cannot dial in current state");
        }
        throw new CallStateException("service not available");
    }

    public com.android.internal.telephony.Connection startConference(String[] strArr, ImsPhone.ImsDialArgs imsDialArgs) throws CallStateException {
        ImsPhoneConnection makeImsPhoneConnectionForConference;
        int i = imsDialArgs.clirMode;
        int i2 = imsDialArgs.videoState;
        log("dial clirMode=" + i);
        boolean prepareForDialing = prepareForDialing(imsDialArgs);
        this.mClirMode = i;
        synchronized (this.mSyncHold) {
            this.mLastDialArgs = imsDialArgs;
            makeImsPhoneConnectionForConference = makeImsPhoneConnectionForConference(strArr);
            this.mPendingMO = makeImsPhoneConnectionForConference;
            makeImsPhoneConnectionForConference.setVideoState(i2);
            if (imsDialArgs.rttTextStream != null) {
                log("startConference: setting RTT stream on mPendingMO");
                makeImsPhoneConnectionForConference.setCurrentRttTextStream(imsDialArgs.rttTextStream);
            }
        }
        addConnection(makeImsPhoneConnectionForConference);
        if (!prepareForDialing) {
            dialInternal(makeImsPhoneConnectionForConference, i, i2, imsDialArgs.intentExtras);
        }
        updatePhoneState();
        this.mPhone.notifyPreciseCallStateChanged();
        return makeImsPhoneConnectionForConference;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public com.android.internal.telephony.Connection dial(String str, int i, Bundle bundle) throws CallStateException {
        return dial(str, ((ImsPhone.ImsDialArgs.Builder) ((ImsPhone.ImsDialArgs.Builder) ((ImsPhone.ImsDialArgs.Builder) new ImsPhone.ImsDialArgs.Builder().setIntentExtras(bundle)).setVideoState(i)).setClirMode(getClirMode())).build());
    }

    public synchronized com.android.internal.telephony.Connection dial(String str, ImsPhone.ImsDialArgs imsDialArgs) throws CallStateException {
        String str2;
        ImsPhoneConnection imsPhoneConnection;
        String str3 = str;
        ImsPhone.ImsDialArgs imsDialArgs2 = imsDialArgs;
        synchronized (this) {
            boolean isPhoneInEcbMode = isPhoneInEcbMode();
            boolean z = imsDialArgs2.isEmergency;
            boolean z2 = imsDialArgs2.isWpsCall;
            if (shouldNumberBePlacedOnIms(z, str3)) {
                int i = imsDialArgs2.clirMode;
                int i2 = imsDialArgs2.videoState;
                log("dial clirMode=" + i);
                if (!z || !ignoreClirWhenEcc()) {
                    str2 = convertNumberIfNecessary(this.mPhone, str3);
                } else {
                    i = 2;
                    log("dial emergency call, set clirModIe=" + 2);
                    str2 = str3;
                }
                this.mClirMode = i;
                boolean prepareForDialing = prepareForDialing(imsDialArgs2);
                if (isPhoneInEcbMode && z) {
                    this.mPhone.handleTimerInEmergencyCallbackMode(1);
                }
                if (z && VideoProfile.isVideo(i2) && !this.mAllowEmergencyVideoCalls) {
                    loge("dial: carrier does not support video emergency calls; downgrade to audio-only");
                    i2 = 0;
                }
                this.mPendingCallVideoState = i2;
                synchronized (this.mSyncHold) {
                    this.mLastDialString = str2;
                    this.mLastDialArgs = imsDialArgs2;
                    this.mPendingMO = makeImsPhoneConnectionForMO(str2, z, z2);
                    this.mOperationLocalLog.log("dial requested. connId=" + System.identityHashCode(this.mPendingMO));
                    if (z && imsDialArgs2.intentExtras != null) {
                        Rlog.i(LOG_TAG, "dial ims emergency dialer: " + imsDialArgs2.intentExtras.getBoolean("android.telecom.extra.IS_USER_INTENT_EMERGENCY_CALL"));
                        this.mPendingMO.setHasKnownUserIntentEmergency(imsDialArgs2.intentExtras.getBoolean("android.telecom.extra.IS_USER_INTENT_EMERGENCY_CALL"));
                    }
                    imsPhoneConnection = this.mPendingMO;
                    imsPhoneConnection.setVideoState(i2);
                    if (imsDialArgs2.rttTextStream != null) {
                        log("dial: setting RTT stream on mPendingMO");
                        this.mPendingMO.setCurrentRttTextStream(imsDialArgs2.rttTextStream);
                    }
                }
                addConnection(this.mPendingMO);
                if (!prepareForDialing) {
                    if (!isPhoneInEcbMode || (isPhoneInEcbMode && z)) {
                        dialInternal(this.mPendingMO, i, i2, imsDialArgs2.retryCallFailCause, imsDialArgs2.retryCallFailNetworkType, imsDialArgs2.intentExtras);
                    } else {
                        try {
                            getEcbmInterface().exitEmergencyCallbackMode();
                            this.mPhone.setOnEcbModeExitResponse(this, 14, (Object) null);
                            this.pendingCallClirMode = i;
                            this.mPendingCallVideoState = i2;
                            this.mPendingIntentExtras = imsDialArgs2.intentExtras;
                            this.pendingCallInEcm = true;
                        } catch (ImsException e) {
                            e.printStackTrace();
                            throw new CallStateException("service not available");
                        }
                    }
                }
                if (this.mNumberConverted) {
                    this.mPendingMO.restoreDialedNumberAfterConversion(str3);
                    this.mNumberConverted = false;
                }
                updatePhoneState();
                this.mPhone.notifyPreciseCallStateChanged();
                switchWfcModeIfRequired(this.mImsManager, isVowifiEnabled(), z);
            } else {
                Rlog.i(LOG_TAG, "dial: shouldNumberBePlacedOnIms = false");
                this.mOperationLocalLog.log("dial: shouldNumberBePlacedOnIms = false");
                throw new CallStateException(Phone.CS_FALLBACK);
            }
        }
        return imsPhoneConnection;
    }

    /* access modifiers changed from: package-private */
    public boolean isImsServiceReady() {
        ImsManager imsManager = this.mImsManager;
        if (imsManager == null) {
            return false;
        }
        return imsManager.isServiceReady();
    }

    private boolean shouldNumberBePlacedOnIms(boolean z, String str) {
        try {
            ImsManager imsManager = this.mImsManager;
            if (imsManager != null) {
                int shouldProcessCall = imsManager.shouldProcessCall(z, new String[]{str});
                Rlog.i(LOG_TAG, "shouldProcessCall: number: " + Rlog.pii(LOG_TAG, str) + ", result: " + shouldProcessCall);
                if (shouldProcessCall == 0) {
                    return true;
                }
                if (shouldProcessCall != 1) {
                    Rlog.w(LOG_TAG, "shouldProcessCall returned unknown result.");
                    return false;
                }
                Rlog.i(LOG_TAG, "shouldProcessCall: place over CSFB instead.");
                return false;
            }
            Rlog.w(LOG_TAG, "ImsManager unavailable, shouldProcessCall returning false.");
            return false;
        } catch (ImsException unused) {
            Rlog.w(LOG_TAG, "ImsService unavailable, shouldProcessCall returning false.");
            return false;
        }
    }

    /* access modifiers changed from: protected */
    public void updateCarrierConfiguration(int i, PersistableBundle persistableBundle) {
        IccCardConstants.State state;
        this.mCarrierConfigLoadedForSubscription = false;
        if (persistableBundle == null) {
            loge("updateCarrierConfiguration: carrier config is null, skipping.");
            return;
        }
        updateCarrierConfigCache(persistableBundle);
        log("updateCarrierConfiguration: Updating mAllowEmergencyVideoCalls = " + this.mAllowEmergencyVideoCalls);
        maybeConfigureRtpHeaderExtensions();
        if (!SubscriptionController.getInstance().isActiveSubId(i)) {
            loge("updateCarrierConfiguration: skipping notification to ImsService, nonactive subId = " + i);
            return;
        }
        Phone defaultPhone = getPhone().getDefaultPhone();
        if (defaultPhone != null && defaultPhone.getIccCard() != null && (state = defaultPhone.getIccCard().getState()) != null && (!state.iccCardExist() || state.isPinLocked())) {
            loge("updateCarrierConfiguration: card state is not ready, skipping notification to ImsService. State= " + state);
        } else if (!CarrierConfigManager.isConfigForIdentifiedCarrier(persistableBundle)) {
            logi("updateCarrierConfiguration: Empty or default carrier config, skipping notification to ImsService.");
        } else {
            logi("updateCarrierConfiguration: Updating ImsService configs.");
            this.mCarrierConfigLoadedForSubscription = true;
            updateImsServiceConfig();
        }
    }

    @VisibleForTesting
    public void updateCarrierConfigCache(PersistableBundle persistableBundle) {
        Integer num;
        this.mAllowEmergencyVideoCalls = persistableBundle.getBoolean("allow_emergency_video_calls_bool");
        this.mTreatDowngradedVideoCallsAsVideoCalls = persistableBundle.getBoolean("treat_downgraded_video_calls_as_video_calls_bool");
        this.mDropVideoCallWhenAnsweringAudioCall = persistableBundle.getBoolean("drop_video_call_when_answering_audio_call_bool");
        this.mAllowAddCallDuringVideoCall = persistableBundle.getBoolean("allow_add_call_during_video_call");
        this.mAllowHoldingVideoCall = persistableBundle.getBoolean("allow_hold_video_call_bool");
        this.mNotifyVtHandoverToWifiFail = persistableBundle.getBoolean("notify_vt_handover_to_wifi_failure_bool");
        this.mSupportDowngradeVtToAudio = persistableBundle.getBoolean("support_downgrade_vt_to_audio_bool");
        this.mNotifyHandoverVideoFromWifiToLTE = persistableBundle.getBoolean("notify_handover_video_from_wifi_to_lte_bool");
        this.mNotifyHandoverVideoFromLTEToWifi = persistableBundle.getBoolean("notify_handover_video_from_lte_to_wifi_bool");
        this.mIgnoreDataEnabledChangedForVideoCalls = persistableBundle.getBoolean("ignore_data_enabled_changed_for_video_calls");
        this.mIsViLteDataMetered = persistableBundle.getBoolean("vilte_data_is_metered_bool");
        this.mSupportPauseVideo = persistableBundle.getBoolean("support_pause_ims_video_calls_bool");
        this.mAlwaysPlayRemoteHoldTone = persistableBundle.getBoolean("always_play_remote_hold_tone_bool");
        this.mAutoRetryFailedWifiEmergencyCall = persistableBundle.getBoolean("auto_retry_failed_wifi_emergency_call");
        this.mSupportCepOnPeer = persistableBundle.getBoolean("support_ims_conference_event_package_on_peer_bool");
        this.mSupportD2DUsingRtp = persistableBundle.getBoolean("supports_device_to_device_communication_using_rtp_bool");
        this.mSupportSdpForRtpHeaderExtensions = persistableBundle.getBoolean("supports_sdp_negotiation_of_d2d_rtp_header_extensions_bool");
        if (this.mPhone.getContext().getResources().getBoolean(17891366)) {
            this.mUssdMethod = persistableBundle.getInt("carrier_ussd_method_int");
        }
        if (!this.mImsReasonCodeMap.isEmpty()) {
            this.mImsReasonCodeMap.clear();
        }
        String[] stringArray = persistableBundle.getStringArray("ims_reasoninfo_mapping_string_array");
        if (stringArray == null || stringArray.length <= 0) {
            log("No carrier ImsReasonInfo mappings defined.");
            return;
        }
        for (String str : stringArray) {
            String[] split = str.split(Pattern.quote("|"));
            if (split.length == 3) {
                try {
                    String str2 = null;
                    if (split[0].equals("*")) {
                        num = null;
                    } else {
                        num = Integer.valueOf(Integer.parseInt(split[0]));
                    }
                    String str3 = split[1];
                    if (str3 == null) {
                        str2 = "";
                    } else if (!str3.equals("*")) {
                        str2 = str3;
                    }
                    int parseInt = Integer.parseInt(split[2]);
                    addReasonCodeRemapping(num, str2, Integer.valueOf(parseInt));
                    StringBuilder sb = new StringBuilder();
                    sb.append("Loaded ImsReasonInfo mapping : fromCode = ");
                    if (num == null) {
                        num = "any";
                    }
                    sb.append(num);
                    sb.append(" ; message = ");
                    if (str2 == null) {
                        str2 = "any";
                    }
                    sb.append(str2);
                    sb.append(" ; toCode = ");
                    sb.append(parseInt);
                    log(sb.toString());
                } catch (NumberFormatException unused) {
                    loge("Invalid ImsReasonInfo mapping found: " + str);
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void handleEcmTimer(int i) {
        this.mPhone.handleTimerInEmergencyCallbackMode(i);
    }

    /* access modifiers changed from: protected */
    public void dialInternal(ImsPhoneConnection imsPhoneConnection, int i, int i2, Bundle bundle) {
        dialInternal(imsPhoneConnection, i, i2, 0, 0, bundle);
    }

    /* access modifiers changed from: protected */
    public void dialInternal(ImsPhoneConnection imsPhoneConnection, int i, int i2, int i3, int i4, Bundle bundle) {
        ImsPhoneConnection imsPhoneConnection2 = imsPhoneConnection;
        Bundle bundle2 = bundle;
        if (imsPhoneConnection2 != null) {
            if (imsPhoneConnection.isAdhocConference() || !(imsPhoneConnection.getAddress() == null || imsPhoneConnection.getAddress().length() == 0 || imsPhoneConnection.getAddress().indexOf(78) >= 0)) {
                setMute(false);
                boolean isEmergency = imsPhoneConnection.isEmergency();
                int i5 = isEmergency ? 2 : 1;
                int callTypeFromVideoState = ImsCallProfile.getCallTypeFromVideoState(i2);
                imsPhoneConnection2.setVideoState(i2);
                try {
                    String[] strArr = {imsPhoneConnection.getAddress()};
                    ImsCallProfile createCallProfile = this.mImsManager.createCallProfile(i5, callTypeFromVideoState);
                    if (imsPhoneConnection.isAdhocConference()) {
                        createCallProfile.setCallExtraBoolean("android.telephony.ims.extra.CONFERENCE", true);
                        createCallProfile.setCallExtraBoolean("conference", true);
                    }
                    createCallProfile.setCallExtraInt("oir", i);
                    createCallProfile.setCallExtraInt("android.telephony.ims.extra.RETRY_CALL_FAIL_REASON", i3);
                    createCallProfile.setCallExtraInt("android.telephony.ims.extra.RETRY_CALL_FAIL_NETWORKTYPE", i4);
                    if (isEmergency) {
                        setEmergencyCallInfo(createCallProfile, imsPhoneConnection2);
                    }
                    if (bundle2 != null) {
                        if (bundle2.containsKey("android.telecom.extra.CALL_SUBJECT")) {
                            bundle2.putString("DisplayText", cleanseInstantLetteringMessage(bundle2.getString("android.telecom.extra.CALL_SUBJECT")));
                            createCallProfile.setCallExtra("android.telephony.ims.extra.CALL_SUBJECT", bundle2.getString("android.telecom.extra.CALL_SUBJECT"));
                        }
                        if (bundle2.containsKey("android.telecom.extra.PRIORITY")) {
                            createCallProfile.setCallExtraInt("android.telephony.ims.extra.PRIORITY", bundle2.getInt("android.telecom.extra.PRIORITY"));
                        }
                        if (bundle2.containsKey("android.telecom.extra.LOCATION")) {
                            createCallProfile.setCallExtraParcelable("android.telephony.ims.extra.LOCATION", bundle2.getParcelable("android.telecom.extra.LOCATION"));
                        }
                        if (bundle2.containsKey("android.telecom.extra.OUTGOING_PICTURE")) {
                            createCallProfile.setCallExtra("android.telephony.ims.extra.PICTURE_URL", TelephonyLocalConnection.getCallComposerServerUrlForHandle(this.mPhone.getSubId(), ((ParcelUuid) bundle2.getParcelable("android.telecom.extra.OUTGOING_PICTURE")).getUuid()));
                        }
                        if (imsPhoneConnection.hasRttTextStream()) {
                            createCallProfile.mMediaProfile.mRttMode = 1;
                        }
                        if (bundle2.containsKey("CallPull")) {
                            createCallProfile.mCallExtras.putBoolean("CallPull", bundle2.getBoolean("CallPull"));
                            int i6 = bundle2.getInt(ImsExternalCallTracker.EXTRA_IMS_EXTERNAL_CALL_ID);
                            imsPhoneConnection2.setIsPulledCall(true);
                            imsPhoneConnection2.setPulledDialogId(i6);
                        }
                        createCallProfile.mCallExtras.putBundle("android.telephony.ims.extra.OEM_EXTRAS", bundle2);
                    }
                    this.mPhone.getVoiceCallSessionStats().onImsDial(imsPhoneConnection2);
                    ImsManager imsManager = this.mImsManager;
                    if (imsPhoneConnection.isAdhocConference()) {
                        strArr = imsPhoneConnection.getParticipantsToDial();
                    }
                    ImsCall makeCall = imsManager.makeCall(createCallProfile, strArr, this.mImsCallListener);
                    imsPhoneConnection2.setImsCall(makeCall);
                    this.mMetrics.writeOnImsCallStart(this.mPhone.getPhoneId(), makeCall.getSession());
                    setVideoCallProvider(imsPhoneConnection2, makeCall);
                    imsPhoneConnection2.setAllowAddCallDuringVideoCall(this.mAllowAddCallDuringVideoCall);
                    imsPhoneConnection2.setAllowHoldingVideoCall(this.mAllowHoldingVideoCall);
                } catch (ImsException e) {
                    loge("dialInternal : " + e);
                    LocalLog localLog = this.mOperationLocalLog;
                    localLog.log("dialInternal exception: " + e);
                    imsPhoneConnection2.setDisconnectCause(36);
                    sendEmptyMessageDelayed(18, 500);
                } catch (RemoteException unused) {
                }
            } else {
                imsPhoneConnection2.setDisconnectCause(7);
                sendEmptyMessageDelayed(18, 500);
            }
        }
    }

    public void acceptCall(int i) throws CallStateException {
        log("acceptCall");
        this.mOperationLocalLog.log("accepted incoming call");
        if (!this.mForegroundCall.getState().isAlive() || !this.mBackgroundCall.getState().isAlive()) {
            boolean z = false;
            if (this.mRingingCall.getState() == Call.State.WAITING && this.mForegroundCall.getState().isAlive()) {
                setMute(false);
                ImsCall imsCall = this.mForegroundCall.getImsCall();
                ImsCall imsCall2 = this.mRingingCall.getImsCall();
                if (this.mForegroundCall.hasConnections() && this.mRingingCall.hasConnections()) {
                    z = shouldDisconnectActiveCallOnAnswer(imsCall, imsCall2);
                }
                this.mPendingCallVideoState = i;
                if (z) {
                    this.mForegroundCall.hangup();
                    this.mPhone.getVoiceCallSessionStats().onImsAcceptCall(this.mRingingCall.getConnections());
                    try {
                        imsCall2.accept(ImsCallProfile.getCallTypeFromVideoState(i));
                    } catch (ImsException unused) {
                        throw new CallStateException("cannot accept call");
                    }
                } else {
                    holdActiveCallForWaitingCall();
                }
            } else if (this.mRingingCall.getState().isRinging()) {
                log("acceptCall: incoming...");
                setMute(false);
                try {
                    ImsCall imsCall3 = this.mRingingCall.getImsCall();
                    if (imsCall3 != null) {
                        this.mPhone.getVoiceCallSessionStats().onImsAcceptCall(this.mRingingCall.getConnections());
                        imsCall3.accept(ImsCallProfile.getCallTypeFromVideoState(i));
                        this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall3.getSession(), 2);
                        return;
                    }
                    throw new CallStateException("no valid ims call");
                } catch (ImsException unused2) {
                    throw new CallStateException("cannot accept call");
                }
            } else {
                throw new CallStateException("phone not ringing");
            }
        } else {
            throw new CallStateException("cannot accept call");
        }
    }

    public void rejectCall() throws CallStateException {
        log("rejectCall");
        this.mOperationLocalLog.log("rejected incoming call");
        if (this.mRingingCall.getState().isRinging()) {
            hangup(this.mRingingCall);
            return;
        }
        throw new CallStateException("phone not ringing");
    }

    /* access modifiers changed from: protected */
    public void setEmergencyCallInfo(ImsCallProfile imsCallProfile, com.android.internal.telephony.Connection connection) {
        EmergencyNumber emergencyNumberInfo = connection.getEmergencyNumberInfo();
        if (emergencyNumberInfo != null) {
            imsCallProfile.setEmergencyCallInfo(emergencyNumberInfo, connection.hasKnownUserIntentEmergency());
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void switchAfterConferenceSuccess() {
        log("switchAfterConferenceSuccess fg =" + this.mForegroundCall.getState() + ", bg = " + this.mBackgroundCall.getState());
        if (this.mBackgroundCall.getState() == Call.State.HOLDING) {
            log("switchAfterConferenceSuccess");
            this.mForegroundCall.switchWith(this.mBackgroundCall);
        }
    }

    /* access modifiers changed from: protected */
    public void holdActiveCallForPendingMo() throws CallStateException {
        HoldSwapState holdSwapState = this.mHoldSwitchingState;
        if (holdSwapState == HoldSwapState.PENDING_SINGLE_CALL_HOLD || holdSwapState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD) {
            logi("Ignoring hold request while already holding or swapping");
            return;
        }
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        this.mHoldSwitchingState = HoldSwapState.HOLDING_TO_DIAL_OUTGOING;
        logHoldSwapState("holdActiveCallForPendingMo");
        this.mForegroundCall.switchWith(this.mBackgroundCall);
        try {
            imsCall.hold();
            this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 5);
        } catch (ImsException e) {
            this.mForegroundCall.switchWith(this.mBackgroundCall);
            this.mHoldSwitchingState = holdSwapState;
            logHoldSwapState("holdActiveCallForPendingMo - fail");
            throw new CallStateException(e.getMessage());
        }
    }

    public void holdActiveCall() throws CallStateException {
        HoldSwapState holdSwapState;
        if (this.mForegroundCall.getState() == Call.State.ACTIVE) {
            HoldSwapState holdSwapState2 = this.mHoldSwitchingState;
            HoldSwapState holdSwapState3 = HoldSwapState.PENDING_SINGLE_CALL_HOLD;
            if (holdSwapState2 == holdSwapState3 || holdSwapState2 == (holdSwapState = HoldSwapState.SWAPPING_ACTIVE_AND_HELD)) {
                logi("Ignoring hold request while already holding or swapping");
                return;
            }
            ImsCall imsCall = this.mForegroundCall.getImsCall();
            if (this.mBackgroundCall.getState().isAlive()) {
                this.mCallExpectedToResume = this.mBackgroundCall.getImsCall();
                this.mHoldSwitchingState = holdSwapState;
            } else {
                this.mHoldSwitchingState = holdSwapState3;
            }
            logHoldSwapState("holdActiveCall");
            this.mForegroundCall.switchWith(this.mBackgroundCall);
            try {
                imsCall.hold();
                this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 5);
            } catch (ImsException | NullPointerException e) {
                this.mForegroundCall.switchWith(this.mBackgroundCall);
                this.mHoldSwitchingState = holdSwapState2;
                logHoldSwapState("holdActiveCall - fail");
                throw new CallStateException(e.getMessage());
            }
        }
    }

    public void holdActiveCallForWaitingCall() throws CallStateException {
        if (!this.mBackgroundCall.getState().isAlive() && this.mRingingCall.getState() == Call.State.WAITING) {
            ImsCall imsCall = this.mForegroundCall.getImsCall();
            HoldSwapState holdSwapState = this.mHoldSwitchingState;
            this.mHoldSwitchingState = HoldSwapState.HOLDING_TO_ANSWER_INCOMING;
            ImsCall imsCall2 = this.mCallExpectedToResume;
            this.mCallExpectedToResume = this.mRingingCall.getImsCall();
            this.mForegroundCall.switchWith(this.mBackgroundCall);
            logHoldSwapState("holdActiveCallForWaitingCall");
            try {
                imsCall.hold();
                this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 5);
            } catch (ImsException e) {
                this.mForegroundCall.switchWith(this.mBackgroundCall);
                this.mHoldSwitchingState = holdSwapState;
                this.mCallExpectedToResume = imsCall2;
                logHoldSwapState("holdActiveCallForWaitingCall - fail");
                throw new CallStateException(e.getMessage());
            }
        }
    }

    public void unholdHeldCall() throws CallStateException {
        ImsCall imsCall = this.mBackgroundCall.getImsCall();
        HoldSwapState holdSwapState = this.mHoldSwitchingState;
        HoldSwapState holdSwapState2 = HoldSwapState.PENDING_SINGLE_CALL_UNHOLD;
        if (holdSwapState == holdSwapState2 || holdSwapState == HoldSwapState.SWAPPING_ACTIVE_AND_HELD) {
            logi("Ignoring unhold request while already unholding or swapping");
        } else if (imsCall != null) {
            this.mCallExpectedToResume = imsCall;
            this.mHoldSwitchingState = holdSwapState2;
            this.mForegroundCall.switchWith(this.mBackgroundCall);
            logHoldSwapState("unholdCurrentCall");
            try {
                imsCall.resume();
                this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 6);
            } catch (ImsException e) {
                this.mForegroundCall.switchWith(this.mBackgroundCall);
                this.mHoldSwitchingState = holdSwapState;
                logHoldSwapState("unholdCurrentCall - fail");
                throw new CallStateException(e.getMessage());
            }
        }
    }

    private void resumeForegroundCall() throws ImsException {
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        if (imsCall == null) {
            return;
        }
        if (!imsCall.isPendingHold()) {
            imsCall.resume();
            this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 6);
            return;
        }
        this.mHoldSwitchingState = HoldSwapState.PENDING_RESUME_FOREGROUND_AFTER_HOLD;
        logHoldSwapState("resumeForegroundCall - unhold pending; resume request again");
    }

    private void answerWaitingCall() throws ImsException {
        ImsCall imsCall = this.mRingingCall.getImsCall();
        if (imsCall != null) {
            this.mPhone.getVoiceCallSessionStats().onImsAcceptCall(this.mRingingCall.getConnections());
            imsCall.accept(ImsCallProfile.getCallTypeFromVideoState(this.mPendingCallVideoState));
            this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 2);
        }
    }

    private void maintainConnectTimeCache() {
        long elapsedRealtime = SystemClock.elapsedRealtime() - 60000;
        this.mPhoneNumAndConnTime.entrySet().removeIf(new ImsPhoneCallTracker$$ExternalSyntheticLambda2(elapsedRealtime));
        while (!this.mUnknownPeerConnTime.isEmpty() && this.mUnknownPeerConnTime.peek().mCachedTime < elapsedRealtime) {
            this.mUnknownPeerConnTime.poll();
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$maintainConnectTimeCache$2(long j, Map.Entry entry) {
        return ((CacheEntry) entry.getValue()).mCachedTime < j;
    }

    private void cacheConnectionTimeWithPhoneNumber(ImsPhoneConnection imsPhoneConnection) {
        CacheEntry cacheEntry = new CacheEntry(SystemClock.elapsedRealtime(), imsPhoneConnection.getConnectTime(), imsPhoneConnection.getConnectTimeReal(), imsPhoneConnection.isIncoming() ^ true ? 1 : 0);
        maintainConnectTimeCache();
        if (1 == imsPhoneConnection.getNumberPresentation()) {
            String formattedPhoneNumber = getFormattedPhoneNumber(imsPhoneConnection.getAddress());
            if (!this.mPhoneNumAndConnTime.containsKey(formattedPhoneNumber) || imsPhoneConnection.getConnectTime() > this.mPhoneNumAndConnTime.get(formattedPhoneNumber).mConnectTime) {
                this.mPhoneNumAndConnTime.put(formattedPhoneNumber, cacheEntry);
                return;
            }
            return;
        }
        this.mUnknownPeerConnTime.add(cacheEntry);
    }

    /* access modifiers changed from: private */
    public CacheEntry findConnectionTimeUsePhoneNumber(ConferenceParticipant conferenceParticipant) {
        maintainConnectTimeCache();
        if (1 != conferenceParticipant.getParticipantPresentation()) {
            return this.mUnknownPeerConnTime.poll();
        }
        if (conferenceParticipant.getHandle() == null || conferenceParticipant.getHandle().getSchemeSpecificPart() == null) {
            return null;
        }
        String schemeSpecificPart = ConferenceParticipant.getParticipantAddress(conferenceParticipant.getHandle(), getCountryIso()).getSchemeSpecificPart();
        if (TextUtils.isEmpty(schemeSpecificPart)) {
            return null;
        }
        return this.mPhoneNumAndConnTime.get(getFormattedPhoneNumber(schemeSpecificPart));
    }

    /* JADX WARNING: Code restructure failed: missing block: B:3:0x0007, code lost:
        r0 = android.telephony.PhoneNumberUtils.formatNumberToE164(r1, r0);
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private java.lang.String getFormattedPhoneNumber(java.lang.String r1) {
        /*
            r0 = this;
            java.lang.String r0 = r0.getCountryIso()
            if (r0 != 0) goto L_0x0007
            return r1
        L_0x0007:
            java.lang.String r0 = android.telephony.PhoneNumberUtils.formatNumberToE164(r1, r0)
            if (r0 != 0) goto L_0x000e
            goto L_0x000f
        L_0x000e:
            r1 = r0
        L_0x000f:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneCallTracker.getFormattedPhoneNumber(java.lang.String):java.lang.String");
    }

    private String getCountryIso() {
        SubscriptionInfo activeSubscriptionInfo = SubscriptionManager.from(this.mPhone.getContext()).getActiveSubscriptionInfo(this.mPhone.getSubId());
        if (activeSubscriptionInfo == null) {
            return null;
        }
        return activeSubscriptionInfo.getCountryIso();
    }

    public void conference() {
        String str;
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        if (imsCall == null) {
            log("conference no foreground ims call");
            return;
        }
        ImsCall imsCall2 = this.mBackgroundCall.getImsCall();
        if (imsCall2 == null) {
            log("conference no background ims call");
        } else if (imsCall.isCallSessionMergePending()) {
            log("conference: skip; foreground call already in process of merging.");
        } else if (imsCall2.isCallSessionMergePending()) {
            log("conference: skip; background call already in process of merging.");
        } else if (!ignoreConference(imsCall, imsCall2)) {
            long earliestConnectTime = this.mForegroundCall.getEarliestConnectTime();
            long earliestConnectTime2 = this.mBackgroundCall.getEarliestConnectTime();
            int i = (earliestConnectTime > 0 ? 1 : (earliestConnectTime == 0 ? 0 : -1));
            if (i > 0 && earliestConnectTime2 > 0) {
                earliestConnectTime = Math.min(this.mForegroundCall.getEarliestConnectTime(), this.mBackgroundCall.getEarliestConnectTime());
                log("conference - using connect time = " + earliestConnectTime);
            } else if (i > 0) {
                log("conference - bg call connect time is 0; using fg = " + earliestConnectTime);
            } else {
                log("conference - fg call connect time is 0; using bg = " + earliestConnectTime2);
                earliestConnectTime = earliestConnectTime2;
            }
            ImsPhoneConnection firstConnection = this.mForegroundCall.getFirstConnection();
            String str2 = "";
            if (firstConnection != null) {
                firstConnection.setConferenceConnectTime(earliestConnectTime);
                firstConnection.handleMergeStart();
                str = firstConnection.getTelecomCallId();
                cacheConnectionTimeWithPhoneNumber(firstConnection);
            } else {
                str = str2;
            }
            ImsPhoneConnection findConnection = findConnection(imsCall2);
            if (findConnection != null) {
                findConnection.handleMergeStart();
                str2 = findConnection.getTelecomCallId();
                cacheConnectionTimeWithPhoneNumber(findConnection);
            }
            log("conference: fgCallId=" + str + ", bgCallId=" + str2);
            LocalLog localLog = this.mOperationLocalLog;
            localLog.log("conference: fgCallId=" + str + ", bgCallId=" + str2);
            try {
                imsCall.merge(imsCall2);
            } catch (ImsException e) {
                log("conference " + e.getMessage());
                handleConferenceFailed(firstConnection, findConnection);
            }
        }
    }

    public void explicitCallTransfer() throws CallStateException {
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        ImsCall imsCall2 = this.mBackgroundCall.getImsCall();
        if (imsCall == null || imsCall2 == null || !canTransfer()) {
            throw new CallStateException("cannot transfer");
        }
        try {
            imsCall2.consultativeTransfer(imsCall);
        } catch (ImsException e) {
            throw new CallStateException(e.getMessage());
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void clearDisconnected() {
        log("clearDisconnected");
        internalClearDisconnected();
        updatePhoneState();
        this.mPhone.notifyPreciseCallStateChanged();
    }

    public boolean canConference() {
        return this.mForegroundCall.getState() == Call.State.ACTIVE && this.mBackgroundCall.getState() == Call.State.HOLDING && !this.mBackgroundCall.isFull() && !this.mForegroundCall.isFull();
    }

    private boolean canAddVideoCallDuringImsAudioCall(int i) {
        if (this.mAllowHoldingVideoCall) {
            return true;
        }
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        if (imsCall == null) {
            imsCall = this.mBackgroundCall.getImsCall();
        }
        if (!((this.mForegroundCall.getState() == Call.State.ACTIVE || this.mBackgroundCall.getState() == Call.State.HOLDING) && imsCall != null && !imsCall.isVideoCall()) || !VideoProfile.isVideo(i)) {
            return true;
        }
        return false;
    }

    public void checkForDialIssues() throws CallStateException {
        if (TelephonyProperties.disable_call().orElse(Boolean.FALSE).booleanValue()) {
            throw new CallStateException(5, "ro.telephony.disable-call has been used to disable calling.");
        } else if (this.mPendingMO != null) {
            throw new CallStateException(3, "Another outgoing call is already being dialed.");
        } else if (!this.mRingingCall.isRinging()) {
            if (this.mBackgroundCall.getState().isAlive() && this.mForegroundCall.getState().isAlive()) {
                throw new CallStateException(6, "Already an active foreground and background call.");
            }
        } else {
            throw new CallStateException(4, "Can't place a call while another is ringing.");
        }
    }

    public boolean canTransfer() {
        return this.mForegroundCall.getState() == Call.State.ACTIVE && this.mBackgroundCall.getState() == Call.State.HOLDING;
    }

    private void internalClearDisconnected() {
        this.mRingingCall.clearDisconnected();
        this.mForegroundCall.clearDisconnected();
        this.mBackgroundCall.clearDisconnected();
        this.mHandoverCall.clearDisconnected();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updatePhoneState() {
        String str;
        PhoneConstants.State state = this.mState;
        ImsPhoneConnection imsPhoneConnection = this.mPendingMO;
        boolean z = imsPhoneConnection == null || !imsPhoneConnection.getState().isAlive();
        if (this.mRingingCall.isRinging()) {
            this.mState = PhoneConstants.State.RINGING;
        } else if (!z || !this.mForegroundCall.isIdle() || !this.mBackgroundCall.isIdle()) {
            this.mState = PhoneConstants.State.OFFHOOK;
        } else {
            this.mState = PhoneConstants.State.IDLE;
        }
        PhoneConstants.State state2 = this.mState;
        PhoneConstants.State state3 = PhoneConstants.State.IDLE;
        if (state2 == state3 && state != state2) {
            this.mVoiceCallEndedRegistrants.notifyRegistrants(getCallStateChangeAsyncResult());
        } else if (state == state3 && state != state2) {
            this.mVoiceCallStartedRegistrants.notifyRegistrants(getCallStateChangeAsyncResult());
        }
        StringBuilder sb = new StringBuilder();
        sb.append("updatePhoneState pendingMo = ");
        if (this.mPendingMO == null) {
            str = "null";
        } else {
            str = this.mPendingMO.getState() + "(" + this.mPendingMO.getTelecomCallId() + "/objId:" + System.identityHashCode(this.mPendingMO) + ")";
        }
        sb.append(str);
        sb.append(", rng= ");
        sb.append(this.mRingingCall.getState());
        sb.append("(");
        sb.append(this.mRingingCall.getConnectionSummary());
        sb.append("), fg= ");
        sb.append(this.mForegroundCall.getState());
        sb.append("(");
        sb.append(this.mForegroundCall.getConnectionSummary());
        sb.append("), bg= ");
        sb.append(this.mBackgroundCall.getState());
        sb.append("(");
        sb.append(this.mBackgroundCall.getConnectionSummary());
        sb.append(")");
        log(sb.toString());
        log("updatePhoneState oldState=" + state + ", newState=" + this.mState);
        if (this.mState != state) {
            this.mPhone.notifyPhoneStateChanged();
            this.mMetrics.writePhoneState(this.mPhone.getPhoneId(), this.mState);
            notifyPhoneStateChanged(state, this.mState);
        }
    }

    private void handleRadioNotAvailable() {
        pollCallsWhenSafe();
    }

    private void dumpState() {
        log("Phone State:" + this.mState);
        log("Ringing call: " + this.mRingingCall.toString());
        ArrayList<com.android.internal.telephony.Connection> connections = this.mRingingCall.getConnections();
        int size = connections.size();
        for (int i = 0; i < size; i++) {
            log(connections.get(i).toString());
        }
        log("Foreground call: " + this.mForegroundCall.toString());
        ArrayList<com.android.internal.telephony.Connection> connections2 = this.mForegroundCall.getConnections();
        int size2 = connections2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            log(connections2.get(i2).toString());
        }
        log("Background call: " + this.mBackgroundCall.toString());
        ArrayList<com.android.internal.telephony.Connection> connections3 = this.mBackgroundCall.getConnections();
        int size3 = connections3.size();
        for (int i3 = 0; i3 < size3; i3++) {
            log(connections3.get(i3).toString());
        }
    }

    public void setTtyMode(int i) {
        ImsManager imsManager = this.mImsManager;
        if (imsManager == null) {
            Log.w(LOG_TAG, "ImsManager is null when setting TTY mode");
            return;
        }
        try {
            imsManager.setTtyMode(i);
        } catch (ImsException e) {
            loge("setTtyMode : " + e);
        }
    }

    public void setUiTTYMode(int i, Message message) {
        ImsManager imsManager = this.mImsManager;
        if (imsManager == null) {
            this.mPhone.sendErrorResponse(message, getImsManagerIsNullException());
            return;
        }
        try {
            imsManager.setUiTTYMode(this.mPhone.getContext(), i, message);
        } catch (ImsException e) {
            loge("setUITTYMode : " + e);
            this.mPhone.sendErrorResponse(message, e);
        }
    }

    public void setMute(boolean z) {
        this.mDesiredMute = z;
        this.mForegroundCall.setMute(z);
    }

    public boolean getMute() {
        return this.mDesiredMute;
    }

    public void sendDtmf(char c, Message message) {
        log("sendDtmf");
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        if (imsCall != null) {
            imsCall.sendDtmf(c, message);
        }
    }

    public void startDtmf(char c) {
        log("startDtmf");
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        if (imsCall != null) {
            imsCall.startDtmf(c);
        } else {
            loge("startDtmf : no foreground call");
        }
    }

    public void stopDtmf() {
        log("stopDtmf");
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        if (imsCall != null) {
            imsCall.stopDtmf();
        } else {
            loge("stopDtmf : no foreground call");
        }
    }

    public void hangup(ImsPhoneConnection imsPhoneConnection) throws CallStateException {
        log("hangup connection");
        if (imsPhoneConnection.getOwner() == this) {
            hangup(imsPhoneConnection.getCall());
            return;
        }
        throw new CallStateException("ImsPhoneConnection " + imsPhoneConnection + "does not belong to ImsPhoneCallTracker " + this);
    }

    public void hangup(ImsPhoneCall imsPhoneCall) throws CallStateException {
        hangup(imsPhoneCall, 1);
    }

    public void hangup(ImsPhoneCall imsPhoneCall, int i) throws CallStateException {
        String str;
        log("hangup call - reason=" + i);
        if (imsPhoneCall.getConnectionsCount() != 0) {
            ImsCall imsCall = imsPhoneCall.getImsCall();
            ImsPhoneConnection findConnection = findConnection(imsCall);
            boolean z = false;
            if (imsPhoneCall == this.mRingingCall) {
                z = true;
                str = "(ringing) hangup incoming";
            } else if (imsPhoneCall == this.mForegroundCall) {
                str = imsPhoneCall.isDialingOrAlerting() ? "(foregnd) hangup dialing or alerting..." : "(foregnd) hangup foreground";
            } else if (imsPhoneCall == this.mBackgroundCall) {
                str = "(backgnd) hangup waiting or background";
            } else if (imsPhoneCall == this.mHandoverCall) {
                str = "(handover) hangup handover (SRVCC) call";
            } else {
                LocalLog localLog = this.mOperationLocalLog;
                localLog.log("hangup: ImsPhoneCall " + System.identityHashCode(findConnection) + " does not belong to ImsPhoneCallTracker " + this);
                throw new CallStateException("ImsPhoneCall " + imsPhoneCall + "does not belong to ImsPhoneCallTracker " + this);
            }
            log(str);
            LocalLog localLog2 = this.mOperationLocalLog;
            localLog2.log("hangup: " + str + ", connId=" + System.identityHashCode(findConnection));
            imsPhoneCall.onHangupLocal();
            if (imsCall == null) {
                ImsPhoneConnection imsPhoneConnection = this.mPendingMO;
                if (imsPhoneConnection != null && imsPhoneCall == this.mForegroundCall) {
                    imsPhoneConnection.update((ImsCall) null, Call.State.DISCONNECTED);
                    this.mPendingMO.onDisconnect();
                    removeConnection(this.mPendingMO);
                    this.mPendingMO = null;
                    updatePhoneState();
                    removeMessages(20);
                }
            } else if (z) {
                if (i == 2) {
                    try {
                        imsCall.reject(365);
                    } catch (ImsException e) {
                        LocalLog localLog3 = this.mOperationLocalLog;
                        localLog3.log("hangup: ImsException=" + e);
                        throw new CallStateException(e.getMessage());
                    }
                } else {
                    imsCall.reject(getHangupReasionInfo(i, z));
                }
                this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 3);
            } else {
                imsCall.terminate(getHangupReasionInfo(i, z));
                this.mMetrics.writeOnImsCommand(this.mPhone.getPhoneId(), imsCall.getSession(), 4);
            }
            this.mPhone.notifyPreciseCallStateChanged();
            return;
        }
        throw new CallStateException("no connections");
    }

    /* access modifiers changed from: protected */
    public void callEndCleanupHandOverCallIfAny() {
        if (this.mHandoverCall.getConnections().size() > 0) {
            log("callEndCleanupHandOverCallIfAny, mHandoverCall.mConnections=" + this.mHandoverCall.getConnections());
            this.mHandoverCall.clearConnections();
            this.mConnections.clear();
            this.mState = PhoneConstants.State.IDLE;
        }
    }

    public void sendUSSD(String str, Message message) {
        log("sendUSSD");
        try {
            ImsCall imsCall = this.mUssdSession;
            if (imsCall != null) {
                this.mPendingUssd = null;
                imsCall.sendUssd(str);
                AsyncResult.forMessage(message, (Object) null, (Throwable) null);
                message.sendToTarget();
                return;
            }
            ImsManager imsManager = this.mImsManager;
            if (imsManager == null) {
                this.mPhone.sendErrorResponse(message, getImsManagerIsNullException());
                return;
            }
            ImsCallProfile createCallProfile = imsManager.createCallProfile(1, 2);
            createCallProfile.setCallExtraInt("dialstring", 2);
            this.mUssdSession = this.mImsManager.makeCall(createCallProfile, new String[]{str}, this.mImsUssdListener);
            this.mPendingUssd = message;
            log("pending ussd updated, " + this.mPendingUssd);
        } catch (ImsException e) {
            loge("sendUSSD : " + e);
            this.mPhone.sendErrorResponse(message, e);
        }
    }

    public void cancelUSSD(Message message) {
        ImsCall imsCall = this.mUssdSession;
        if (imsCall != null) {
            this.mPendingUssd = message;
            imsCall.terminate(501);
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized ImsPhoneConnection findConnection(ImsCall imsCall) {
        Iterator<ImsPhoneConnection> it = this.mConnections.iterator();
        while (it.hasNext()) {
            ImsPhoneConnection next = it.next();
            if (next.getImsCall() == imsCall) {
                return next;
            }
        }
        return null;
    }

    public synchronized void cleanupAndRemoveConnection(ImsPhoneConnection imsPhoneConnection) {
        LocalLog localLog = this.mOperationLocalLog;
        localLog.log("cleanupAndRemoveConnection: " + imsPhoneConnection);
        if (imsPhoneConnection.getCall() != null) {
            imsPhoneConnection.getCall().detach(imsPhoneConnection);
        }
        removeConnection(imsPhoneConnection);
        ImsPhoneConnection imsPhoneConnection2 = this.mPendingMO;
        if (imsPhoneConnection == imsPhoneConnection2) {
            imsPhoneConnection2.finalize();
            this.mPendingMO = null;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized void removeConnection(ImsPhoneConnection imsPhoneConnection) {
        boolean z;
        this.mConnections.remove(imsPhoneConnection);
        if (this.mIsInEmergencyCall) {
            Iterator<ImsPhoneConnection> it = this.mConnections.iterator();
            while (true) {
                z = true;
                if (!it.hasNext()) {
                    z = false;
                    break;
                }
                ImsPhoneConnection next = it.next();
                if (next != null && next.isEmergency()) {
                    break;
                }
            }
            if (!z) {
                if (this.mPhone.isEcmCanceledForEmergency()) {
                    this.mPhone.handleTimerInEmergencyCallbackMode(0);
                }
                this.mIsInEmergencyCall = false;
                this.mPhone.sendEmergencyCallStateChange(false);
                startRttEmcGuardTimer();
            }
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized void addConnection(ImsPhoneConnection imsPhoneConnection) {
        this.mConnections.add(imsPhoneConnection);
        if (imsPhoneConnection.isEmergency()) {
            this.mIsInEmergencyCall = true;
            this.mPhone.sendEmergencyCallStateChange(true);
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void processCallStateChange(ImsCall imsCall, Call.State state, int i) {
        log("processCallStateChange " + imsCall + " state=" + state + " cause=" + i);
        processCallStateChange(imsCall, state, i, false);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void processCallStateChange(ImsCall imsCall, Call.State state, int i, boolean z) {
        ImsPhoneConnection findConnection;
        log("processCallStateChange state=" + state + " cause=" + i + " ignoreState=" + z);
        if (imsCall != null && (findConnection = findConnection(imsCall)) != null) {
            findConnection.updateMediaCapabilities(imsCall);
            if (z) {
                findConnection.updateAddressDisplay(imsCall);
                findConnection.updateExtras(imsCall);
                findConnection.maybeChangeRingbackState();
                maybeSetVideoCallProvider(findConnection, imsCall);
                return;
            }
            LocalLog localLog = this.mOperationLocalLog;
            localLog.log("processCallStateChange: state=" + state + " cause=" + i + " connId=" + System.identityHashCode(findConnection));
            boolean update = findConnection.update(imsCall, state);
            if (state == Call.State.DISCONNECTED) {
                update = findConnection.onDisconnect(i) || update;
                findConnection.getCall().detach(findConnection);
                removeConnection(findConnection);
                List<ConferenceParticipant> conferenceParticipants = imsCall.getConferenceParticipants();
                if (conferenceParticipants != null) {
                    for (ConferenceParticipant handle : conferenceParticipants) {
                        String schemeSpecificPart = ConferenceParticipant.getParticipantAddress(handle.getHandle(), getCountryIso()).getSchemeSpecificPart();
                        if (!TextUtils.isEmpty(schemeSpecificPart)) {
                            this.mPhoneNumAndConnTime.remove(getFormattedPhoneNumber(schemeSpecificPart));
                        }
                    }
                }
            }
            if (update && findConnection.getCall() != this.mHandoverCall) {
                updatePhoneState();
                this.mPhone.notifyPreciseCallStateChanged();
            }
        }
    }

    private void maybeSetVideoCallProvider(ImsPhoneConnection imsPhoneConnection, ImsCall imsCall) {
        Connection.VideoProvider videoProvider = imsPhoneConnection.getVideoProvider();
        ImsCallSession callSession = imsCall.getCallSession();
        if (videoProvider == null && callSession != null && callSession.getVideoCallProvider() != null) {
            try {
                setVideoCallProvider(imsPhoneConnection, imsCall);
            } catch (RemoteException e) {
                loge("maybeSetVideoCallProvider: exception " + e);
            }
        }
    }

    @VisibleForTesting
    public void addReasonCodeRemapping(Integer num, String str, Integer num2) {
        if (str != null) {
            str = str.toLowerCase();
        }
        this.mImsReasonCodeMap.put(new Pair(num, str), num2);
    }

    @VisibleForTesting
    public int maybeRemapReasonCode(ImsReasonInfo imsReasonInfo) {
        String str;
        int code = imsReasonInfo.getCode();
        String extraMessage = imsReasonInfo.getExtraMessage();
        if (extraMessage == null) {
            str = "";
        } else {
            str = extraMessage.toLowerCase();
        }
        log("maybeRemapReasonCode : fromCode = " + imsReasonInfo.getCode() + " ; message = " + str);
        Pair pair = new Pair(Integer.valueOf(code), str);
        Pair pair2 = new Pair((Object) null, str);
        Pair pair3 = new Pair(Integer.valueOf(code), (Object) null);
        if (this.mImsReasonCodeMap.containsKey(pair)) {
            int intValue = this.mImsReasonCodeMap.get(pair).intValue();
            log("maybeRemapReasonCode : fromCode = " + imsReasonInfo.getCode() + " ; message = " + str + " ; toCode = " + intValue);
            return intValue;
        } else if (!str.isEmpty() && this.mImsReasonCodeMap.containsKey(pair2)) {
            int intValue2 = this.mImsReasonCodeMap.get(pair2).intValue();
            log("maybeRemapReasonCode : fromCode(wildcard) = " + imsReasonInfo.getCode() + " ; message = " + str + " ; toCode = " + intValue2);
            return intValue2;
        } else if (!this.mImsReasonCodeMap.containsKey(pair3)) {
            return code;
        } else {
            int intValue3 = this.mImsReasonCodeMap.get(pair3).intValue();
            log("maybeRemapReasonCode : fromCode = " + imsReasonInfo.getCode() + " ; message(wildcard) = " + str + " ; toCode = " + intValue3);
            return intValue3;
        }
    }

    @VisibleForTesting
    public int getDisconnectCauseFromReasonInfo(ImsReasonInfo imsReasonInfo, Call.State state) {
        switch (maybeRemapReasonCode(imsReasonInfo)) {
            case 0:
                if (this.mPhone.getDefaultPhone().getServiceStateTracker().mRestrictedState.isCsRestricted()) {
                    return 22;
                }
                if (this.mPhone.getDefaultPhone().getServiceStateTracker().mRestrictedState.isCsEmergencyRestricted()) {
                    return 24;
                }
                return this.mPhone.getDefaultPhone().getServiceStateTracker().mRestrictedState.isCsNormalRestricted() ? 23 : 36;
            case 106:
            case 121:
            case 122:
            case 123:
            case 124:
            case InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC /*131*/:
            case 132:
            case 144:
                return 18;
            case 108:
                return 45;
            case 111:
            case 1500:
                return 17;
            case 112:
            case 505:
                return state == Call.State.DIALING ? 62 : 61;
            case 143:
            case PointerIconCompat.TYPE_TOP_LEFT_DIAGONAL_DOUBLE_ARROW:
            case 1404:
                return 16;
            case 201:
            case 202:
            case 203:
            case 335:
                return 13;
            case 240:
                return 20;
            case CallFailCause.FDN_BLOCKED:
                return 21;
            case CallFailCause.IMEI_NOT_ACCEPTED:
                return 58;
            case CallFailCause.DIAL_MODIFIED_TO_USSD:
                return 46;
            case CallFailCause.DIAL_MODIFIED_TO_SS:
                return 47;
            case CallFailCause.DIAL_MODIFIED_TO_DIAL:
                return 48;
            case CallFailCause.RADIO_OFF:
                return 66;
            case 248:
                return 69;
            case 249:
                return 70;
            case 250:
                return 67;
            case CallFailCause.NETWORK_RESP_TIMEOUT:
                return 68;
            case 321:
            case 340:
            case 362:
                return 12;
            case 331:
            case 1602:
            case 1606:
            case 1607:
            case 1608:
            case 1611:
            case 1614:
            case 1616:
            case 1618:
                return 81;
            case 332:
                return 12;
            case 333:
                return 7;
            case 337:
            case 341:
                return 8;
            case 338:
                return 4;
            case 352:
            case 354:
                return 9;
            case 361:
            case 510:
                return 2;
            case 363:
                return 63;
            case 364:
                return 64;
            case 402:
                return 77;
            case 501:
                return 3;
            case PointerIconCompat.TYPE_HORIZONTAL_DOUBLE_ARROW:
                return 52;
            case PointerIconCompat.TYPE_TOP_RIGHT_DIAGONAL_DOUBLE_ARROW:
                return 51;
            case CallFailCause.MEDIA_UNSPECIFIED:
                return 53;
            case 1405:
                return 55;
            case 1406:
                return 54;
            case 1407:
                return 59;
            case 1512:
                return 60;
            case 1514:
                return 71;
            case 1515:
                return 25;
            case 1622:
                return 78;
            case 1623:
                return 79;
            default:
                return 36;
        }
    }

    /* access modifiers changed from: private */
    public int getPreciseDisconnectCauseFromReasonInfo(ImsReasonInfo imsReasonInfo) {
        return PRECISE_CAUSE_MAP.get(maybeRemapReasonCode(imsReasonInfo), 65535);
    }

    /* access modifiers changed from: protected */
    public boolean isPhoneInEcbMode() {
        ImsPhone imsPhone = this.mPhone;
        return imsPhone != null && imsPhone.isInEcm();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void dialPendingMO() {
        boolean isPhoneInEcbMode = isPhoneInEcbMode();
        boolean isEmergency = this.mPendingMO.isEmergency();
        if (!isPhoneInEcbMode || (isPhoneInEcbMode && isEmergency)) {
            sendEmptyMessage(20);
        } else {
            sendEmptyMessage(21);
        }
    }

    public void sendCallStartFailedDisconnect(ImsCall imsCall, ImsReasonInfo imsReasonInfo) {
        Call.State state;
        this.mPendingMO = null;
        ImsPhoneConnection findConnection = findConnection(imsCall);
        if (findConnection != null) {
            state = findConnection.getState();
        } else {
            state = Call.State.DIALING;
        }
        processCallStateChange(imsCall, Call.State.DISCONNECTED, getDisconnectCauseFromReasonInfo(imsReasonInfo, state));
        if (findConnection != null) {
            findConnection.setPreciseDisconnectCause(getPreciseDisconnectCauseFromReasonInfo(imsReasonInfo));
        }
        this.mPhone.notifyImsReason(imsReasonInfo);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsUtInterface getUtInterface() throws ImsException {
        ImsManager imsManager = this.mImsManager;
        if (imsManager != null) {
            return imsManager.createOrGetSupplementaryServiceConfiguration();
        }
        throw getImsManagerIsNullException();
    }

    /* access modifiers changed from: protected */
    public void transferHandoverConnections(ImsPhoneCall imsPhoneCall) {
        if (imsPhoneCall.getConnections() != null) {
            Iterator<com.android.internal.telephony.Connection> it = imsPhoneCall.getConnections().iterator();
            while (it.hasNext()) {
                com.android.internal.telephony.Connection next = it.next();
                next.mPreHandoverState = imsPhoneCall.mState;
                log("Connection state before handover is " + next.getStateBeforeHandover());
                setMultiPartyState(next);
            }
        }
        if (this.mHandoverCall.getConnections() == null) {
            this.mHandoverCall.mConnections = imsPhoneCall.mConnections;
        } else {
            this.mHandoverCall.mConnections.addAll(imsPhoneCall.mConnections);
        }
        this.mHandoverCall.copyConnectionFrom(imsPhoneCall);
        if (this.mHandoverCall.getConnections() != null) {
            if (imsPhoneCall.getImsCall() != null) {
                imsPhoneCall.getImsCall().close();
            }
            Iterator<com.android.internal.telephony.Connection> it2 = this.mHandoverCall.getConnections().iterator();
            while (it2.hasNext()) {
                ImsPhoneConnection imsPhoneConnection = (ImsPhoneConnection) it2.next();
                imsPhoneConnection.changeParent(this.mHandoverCall);
                imsPhoneConnection.releaseWakeLock();
            }
        }
        if (imsPhoneCall.getState().isAlive()) {
            log("Call is alive and state is " + imsPhoneCall.mState);
            this.mHandoverCall.mState = imsPhoneCall.mState;
        }
        imsPhoneCall.clearConnections();
        imsPhoneCall.mState = Call.State.IDLE;
        if (this.mPendingMO != null) {
            logi("pending MO on handover, clearing...");
            this.mPendingMO = null;
        }
        resetRingBackTone(imsPhoneCall);
    }

    public void notifySrvccState(Call.SrvccState srvccState) {
        log("notifySrvccState state=" + srvccState);
        this.mSrvccState = srvccState;
        if (srvccState == Call.SrvccState.COMPLETED) {
            this.mForegroundCall.maybeStopRingback();
            resetState();
            transferHandoverConnections(this.mForegroundCall);
            transferHandoverConnections(this.mBackgroundCall);
            transferHandoverConnections(this.mRingingCall);
            updatePhoneState();
        }
    }

    private void resetState() {
        this.mIsInEmergencyCall = false;
        this.mPhone.setEcmCanceledForEmergency(false);
        this.mHoldSwitchingState = HoldSwapState.INACTIVE;
    }

    @VisibleForTesting
    public boolean isHoldOrSwapInProgress() {
        return this.mHoldSwitchingState != HoldSwapState.INACTIVE;
    }

    public void handleMessage(Message message) {
        log("handleMessage what=" + message.what);
        switch (message.what) {
            case 14:
                if (this.pendingCallInEcm) {
                    dialInternal(this.mPendingMO, this.pendingCallClirMode, this.mPendingCallVideoState, this.mPendingIntentExtras);
                    this.mPendingIntentExtras = null;
                    this.pendingCallInEcm = false;
                }
                this.mPhone.unsetOnEcbModeExitResponse(this);
                return;
            case 18:
                ImsPhoneConnection imsPhoneConnection = this.mPendingMO;
                if (imsPhoneConnection != null) {
                    imsPhoneConnection.onDisconnect();
                    removeConnection(this.mPendingMO);
                    this.mPendingMO = null;
                }
                this.mPendingIntentExtras = null;
                updatePhoneState();
                this.mPhone.notifyPreciseCallStateChanged();
                return;
            case 20:
                ImsPhoneConnection imsPhoneConnection2 = this.mPendingMO;
                if (imsPhoneConnection2 != null && imsPhoneConnection2.getImsCall() == null) {
                    dialInternal(this.mPendingMO, this.mClirMode, this.mPendingCallVideoState, this.mPendingIntentExtras);
                    this.mPendingIntentExtras = null;
                    return;
                }
                return;
            case 21:
                if (this.mPendingMO != null) {
                    try {
                        getEcbmInterface().exitEmergencyCallbackMode();
                        this.mPhone.setOnEcbModeExitResponse(this, 14, (Object) null);
                        this.pendingCallClirMode = this.mClirMode;
                        this.pendingCallInEcm = true;
                        return;
                    } catch (ImsException e) {
                        e.printStackTrace();
                        this.mPendingMO.setDisconnectCause(36);
                        sendEmptyMessageDelayed(18, 500);
                        return;
                    }
                } else {
                    return;
                }
            case 22:
                AsyncResult asyncResult = (AsyncResult) message.obj;
                ImsCall imsCall = (ImsCall) asyncResult.userObj;
                Long valueOf = Long.valueOf(((Long) asyncResult.result).longValue());
                log("VT data usage update. usage = " + valueOf + ", imsCall = " + imsCall);
                if (valueOf.longValue() > 0) {
                    updateVtDataUsage(imsCall, valueOf.longValue());
                    return;
                }
                return;
            case 23:
                Object obj = ((AsyncResult) message.obj).result;
                if (obj instanceof Pair) {
                    Pair pair = (Pair) obj;
                    onDataEnabledChanged(((Boolean) pair.first).booleanValue(), ((Integer) pair.second).intValue());
                    return;
                }
                return;
            case 25:
                Object obj2 = message.obj;
                if (obj2 instanceof ImsCall) {
                    ImsCall imsCall2 = (ImsCall) obj2;
                    if (imsCall2 != this.mForegroundCall.getImsCall()) {
                        Rlog.i(LOG_TAG, "handoverCheck: no longer FG; check skipped.");
                        unregisterForConnectivityChanges();
                        return;
                    }
                    if (!this.mHasAttemptedStartOfCallHandover) {
                        this.mHasAttemptedStartOfCallHandover = true;
                    }
                    if (!imsCall2.isWifiCall()) {
                        ImsPhoneConnection findConnection = findConnection(imsCall2);
                        if (findConnection != null) {
                            Rlog.i(LOG_TAG, "handoverCheck: handover failed.");
                            findConnection.onHandoverToWifiFailed();
                        }
                        if (imsCall2.isVideoCall() && findConnection.getDisconnectCause() == 0) {
                            registerForConnectivityChanges();
                            return;
                        }
                        return;
                    }
                    return;
                }
                return;
            case 26:
                SomeArgs someArgs = (SomeArgs) message.obj;
                try {
                    handleFeatureCapabilityChanged((ImsFeature.Capabilities) someArgs.arg1);
                    return;
                } finally {
                    someArgs.recycle();
                }
            case 27:
                AsyncResult asyncResult2 = (AsyncResult) message.obj;
                ImsPhoneMmiCode imsPhoneMmiCode = new ImsPhoneMmiCode(this.mPhone);
                try {
                    imsPhoneMmiCode.setIsSsInfo(true);
                    imsPhoneMmiCode.processImsSsData(asyncResult2);
                    return;
                } catch (ImsException e2) {
                    Rlog.e(LOG_TAG, "Exception in parsing SS Data: " + e2);
                    return;
                }
            case 28:
                Pair pair2 = (Pair) ((AsyncResult) message.obj).userObj;
                removeMessages(29);
                this.mPhone.getDefaultPhone().mCi.unregisterForOn(this);
                ImsPhoneConnection findConnection2 = findConnection((ImsCall) pair2.first);
                if (findConnection2 == null) {
                    sendCallStartFailedDisconnect((ImsCall) pair2.first, (ImsReasonInfo) pair2.second);
                    return;
                }
                this.mForegroundCall.detach(findConnection2);
                removeConnection(findConnection2);
                try {
                    findConnection2.onOriginalConnectionReplaced(this.mPhone.getDefaultPhone().dial(this.mLastDialString, this.mLastDialArgs));
                    ImsCall imsCall3 = this.mForegroundCall.getImsCall();
                    imsCall3.getCallProfile().setCallExtraBoolean("e_call", true);
                    findConnection(imsCall3).updateExtras(imsCall3);
                    return;
                } catch (CallStateException unused) {
                    sendCallStartFailedDisconnect((ImsCall) pair2.first, (ImsReasonInfo) pair2.second);
                    return;
                }
            case 29:
                Pair pair3 = (Pair) message.obj;
                this.mPhone.getDefaultPhone().mCi.unregisterForOn(this);
                removeMessages(28);
                sendCallStartFailedDisconnect((ImsCall) pair3.first, (ImsReasonInfo) pair3.second);
                return;
            case 30:
                try {
                    answerWaitingCall();
                    return;
                } catch (ImsException e3) {
                    loge("handleMessage EVENT_ANSWER_WAITING_CALL exception=" + e3);
                    return;
                }
            case 31:
                try {
                    resumeForegroundCall();
                    return;
                } catch (ImsException e4) {
                    loge("handleMessage EVENT_RESUME_NOW_FOREGROUND_CALL exception=" + e4);
                    return;
                }
            case 32:
                Pair pair4 = (Pair) message.obj;
                removeMessages(32);
                ImsPhoneConnection findConnection3 = findConnection((ImsCall) pair4.first);
                if (findConnection3 == null) {
                    sendCallStartFailedDisconnect((ImsCall) pair4.first, (ImsReasonInfo) pair4.second);
                    return;
                }
                this.mForegroundCall.detach(findConnection3);
                removeConnection(findConnection3);
                try {
                    this.mPendingMO = null;
                    findConnection3.onOriginalConnectionReplaced(this.mPhone.getDefaultPhone().dial(this.mLastDialString, ImsPhone.ImsDialArgs.Builder.from(this.mLastDialArgs).setRttTextStream((Connection.RttTextStream) null).setRetryCallFailCause(CallFailCause.EMC_REDIAL_ON_IMS).setRetryCallFailNetworkType(ServiceState.rilRadioTechnologyToNetworkType(findConnection3.getCallRadioTech())).build()));
                    return;
                } catch (CallStateException unused2) {
                    sendCallStartFailedDisconnect((ImsCall) pair4.first, (ImsReasonInfo) pair4.second);
                    return;
                }
            default:
                return;
        }
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void updateVtDataUsage(ImsCall imsCall, long j) {
        ImsCall imsCall2 = imsCall;
        long longValue = j - (this.mVtDataUsageMap.containsKey(Integer.valueOf(imsCall2.uniqueId)) ? this.mVtDataUsageMap.get(Integer.valueOf(imsCall2.uniqueId)).longValue() : 0);
        this.mVtDataUsageMap.put(Integer.valueOf(imsCall2.uniqueId), Long.valueOf(j));
        log("updateVtDataUsage: call=" + imsCall2 + ", delta=" + longValue);
        long elapsedRealtime = SystemClock.elapsedRealtime();
        boolean dataRoaming = this.mPhone.getServiceState().getDataRoaming();
        long j2 = longValue / 2;
        NetworkStats.Entry entry = r6;
        long j3 = j2;
        NetworkStats.Entry entry2 = new NetworkStats.Entry(getVtInterface(), -1, 1, 0, 1, dataRoaming ? 1 : 0, 1, j2, 0, j2, 0, 0);
        this.mVtDataUsageSnapshot = new NetworkStats(elapsedRealtime, 1).add(this.mVtDataUsageSnapshot).addEntry(entry);
        NetworkStats add = new NetworkStats(elapsedRealtime, 1).add(this.mVtDataUsageUidSnapshot);
        if (this.mDefaultDialerUid.get() == -1) {
            this.mDefaultDialerUid.set(getPackageUid(this.mPhone.getContext(), ((TelecomManager) this.mPhone.getContext().getSystemService("telecom")).getDefaultDialerPackage()));
        }
        this.mVtDataUsageUidSnapshot = add.addEntry(new NetworkStats.Entry(getVtInterface(), this.mDefaultDialerUid.get(), 1, 0, 1, dataRoaming ? 1 : 0, 1, j3, 0, j3, 0, 0));
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public String getVtInterface() {
        return "vt_data0" + this.mPhone.getSubId();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(LOG_TAG, "[" + this.mPhone.getPhoneId() + "] " + str);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loge(String str) {
        Rlog.e(LOG_TAG, "[" + this.mPhone.getPhoneId() + "] " + str);
    }

    /* access modifiers changed from: package-private */
    public void logw(String str) {
        Rlog.w(LOG_TAG, "[" + this.mPhone.getPhoneId() + "] " + str);
    }

    /* access modifiers changed from: package-private */
    public void logi(String str) {
        Rlog.i(LOG_TAG, "[" + this.mPhone.getPhoneId() + "] " + str);
    }

    /* renamed from: com.android.internal.telephony.imsphone.ImsPhoneCallTracker$11  reason: invalid class name */
    static /* synthetic */ class AnonymousClass11 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState;

        /* JADX WARNING: Can't wrap try/catch for region: R(18:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|18) */
        /* JADX WARNING: Code restructure failed: missing block: B:19:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState[] r0 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState = r0
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.INACTIVE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.PENDING_SINGLE_CALL_HOLD     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.PENDING_SINGLE_CALL_UNHOLD     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.SWAPPING_ACTIVE_AND_HELD     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.HOLDING_TO_ANSWER_INCOMING     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.PENDING_RESUME_FOREGROUND_AFTER_FAILURE     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.HOLDING_TO_DIAL_OUTGOING     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.imsphone.ImsPhoneCallTracker$HoldSwapState r1 = com.android.internal.telephony.imsphone.ImsPhoneCallTracker.HoldSwapState.PENDING_RESUME_FOREGROUND_AFTER_HOLD     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneCallTracker.AnonymousClass11.<clinit>():void");
        }
    }

    /* access modifiers changed from: package-private */
    public void logHoldSwapState(String str) {
        String str2;
        switch (AnonymousClass11.$SwitchMap$com$android$internal$telephony$imsphone$ImsPhoneCallTracker$HoldSwapState[this.mHoldSwitchingState.ordinal()]) {
            case 1:
                str2 = "INACTIVE";
                break;
            case 2:
                str2 = "PENDING_SINGLE_CALL_HOLD";
                break;
            case 3:
                str2 = "PENDING_SINGLE_CALL_UNHOLD";
                break;
            case 4:
                str2 = "SWAPPING_ACTIVE_AND_HELD";
                break;
            case 5:
                str2 = "HOLDING_TO_ANSWER_INCOMING";
                break;
            case 6:
                str2 = "PENDING_RESUME_FOREGROUND_AFTER_FAILURE";
                break;
            case 7:
                str2 = "HOLDING_TO_DIAL_OUTGOING";
                break;
            case 8:
                str2 = "PENDING_RESUME_FOREGROUND_AFTER_HOLD";
                break;
            default:
                str2 = "???";
                break;
        }
        logi("holdSwapState set to " + str2 + " at " + str);
    }

    public void logState() {
        if (VERBOSE_STATE_LOGGING) {
            Rlog.v(LOG_TAG, "Current IMS PhoneCall State:\n" + " Foreground: " + this.mForegroundCall + "\n" + " Background: " + this.mBackgroundCall + "\n" + " Ringing: " + this.mRingingCall + "\n" + " Handover: " + this.mHandoverCall + "\n");
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println("ImsPhoneCallTracker extends:");
        indentingPrintWriter.increaseIndent();
        super.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" mVoiceCallEndedRegistrants=" + this.mVoiceCallEndedRegistrants);
        indentingPrintWriter.println(" mVoiceCallStartedRegistrants=" + this.mVoiceCallStartedRegistrants);
        indentingPrintWriter.println(" mRingingCall=" + this.mRingingCall);
        indentingPrintWriter.println(" mForegroundCall=" + this.mForegroundCall);
        indentingPrintWriter.println(" mBackgroundCall=" + this.mBackgroundCall);
        indentingPrintWriter.println(" mHandoverCall=" + this.mHandoverCall);
        indentingPrintWriter.println(" mPendingMO=" + this.mPendingMO);
        indentingPrintWriter.println(" mPhone=" + this.mPhone);
        indentingPrintWriter.println(" mDesiredMute=" + this.mDesiredMute);
        indentingPrintWriter.println(" mState=" + this.mState);
        indentingPrintWriter.println(" mMmTelCapabilities=" + this.mMmTelCapabilities);
        indentingPrintWriter.println(" mDefaultDialerUid=" + this.mDefaultDialerUid.get());
        indentingPrintWriter.println(" mVtDataUsageSnapshot=" + this.mVtDataUsageSnapshot);
        indentingPrintWriter.println(" mVtDataUsageUidSnapshot=" + this.mVtDataUsageUidSnapshot);
        indentingPrintWriter.println(" mCallQualityMetrics=" + this.mCallQualityMetrics);
        indentingPrintWriter.println(" mCallQualityMetricsHistory=" + this.mCallQualityMetricsHistory);
        indentingPrintWriter.println(" mIsConferenceEventPackageHandlingEnabled=" + this.mIsConferenceEventPackageEnabled);
        indentingPrintWriter.println(" mSupportCepOnPeer=" + this.mSupportCepOnPeer);
        if (this.mConfig != null) {
            indentingPrintWriter.print(" isDeviceToDeviceCommsSupported= " + this.mConfig.isD2DCommunicationSupported);
            indentingPrintWriter.println("(forceEnabled=" + this.mDeviceToDeviceForceEnabled + ")");
            if (this.mConfig.isD2DCommunicationSupported) {
                indentingPrintWriter.println(" mSupportD2DUsingRtp= " + this.mSupportD2DUsingRtp);
                indentingPrintWriter.println(" mSupportSdpForRtpHeaderExtensions= " + this.mSupportSdpForRtpHeaderExtensions);
            }
        }
        indentingPrintWriter.println(" Event Log:");
        indentingPrintWriter.increaseIndent();
        this.mOperationLocalLog.dump(indentingPrintWriter);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.flush();
        indentingPrintWriter.println("++++++++++++++++++++++++++++++++");
        try {
            ImsManager imsManager = this.mImsManager;
            if (imsManager != null) {
                imsManager.dump(fileDescriptor, indentingPrintWriter, strArr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        ArrayList<ImsPhoneConnection> arrayList = this.mConnections;
        if (arrayList != null && arrayList.size() > 0) {
            indentingPrintWriter.println("mConnections:");
            for (int i = 0; i < this.mConnections.size(); i++) {
                indentingPrintWriter.println("  [" + i + "]: " + this.mConnections.get(i));
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ImsEcbm getEcbmInterface() throws ImsException {
        ImsManager imsManager = this.mImsManager;
        if (imsManager != null) {
            return imsManager.getEcbmInterface();
        }
        throw getImsManagerIsNullException();
    }

    public boolean isInEmergencyCall() {
        return this.mIsInEmergencyCall;
    }

    public boolean isImsCapabilityAvailable(int i, int i2) throws ImsException {
        ImsManager imsManager = this.mImsManager;
        if (imsManager != null) {
            return imsManager.queryMmTelCapabilityStatus(i, i2);
        }
        return false;
    }

    public boolean isVoiceOverCellularImsEnabled() {
        if (isImsCapabilityInCacheAvailable(1, 0) || isImsCapabilityInCacheAvailable(1, 3)) {
            return true;
        }
        return false;
    }

    public boolean isVowifiEnabled() {
        if (isImsCapabilityInCacheAvailable(1, 1) || isImsCapabilityInCacheAvailable(1, 2)) {
            return true;
        }
        return false;
    }

    public boolean isVideoCallEnabled() {
        return this.mMmTelCapabilities.isCapable(2);
    }

    private boolean isImsCapabilityInCacheAvailable(int i, int i2) {
        return getImsRegistrationTech() == i2 && this.mMmTelCapabilities.isCapable(i);
    }

    public PhoneConstants.State getState() {
        return this.mState;
    }

    public int getImsRegistrationTech() {
        ImsManager imsManager = this.mImsManager;
        if (imsManager != null) {
            return imsManager.getRegistrationTech();
        }
        return -1;
    }

    public void getImsRegistrationTech(Consumer<Integer> consumer) {
        ImsManager imsManager = this.mImsManager;
        if (imsManager != null) {
            imsManager.getRegistrationTech(consumer);
        } else {
            consumer.accept(-1);
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setVideoCallProvider(ImsPhoneConnection imsPhoneConnection, ImsCall imsCall) throws RemoteException {
        IImsVideoCallProvider videoCallProvider = imsCall.getCallSession().getVideoCallProvider();
        if (videoCallProvider != null) {
            boolean z = this.mPhone.getContext().getResources().getBoolean(17891821);
            ImsVideoCallProviderWrapper imsVideoCallProviderWrapper = new ImsVideoCallProviderWrapper(videoCallProvider);
            if (z) {
                imsVideoCallProviderWrapper.setUseVideoPauseWorkaround(z);
            }
            imsPhoneConnection.setVideoProvider(imsVideoCallProviderWrapper);
            imsVideoCallProviderWrapper.registerForDataUsageUpdate(this, 22, imsCall);
            imsVideoCallProviderWrapper.addImsVideoProviderCallback(imsPhoneConnection);
        }
    }

    public boolean isUtEnabled() {
        return this.mMmTelCapabilities.isCapable(4);
    }

    /* access modifiers changed from: private */
    public PersistableBundle getCarrierConfigBundle(int i) {
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null) {
            loge("getCarrierConfigBundle: No carrier config service found");
            return null;
        }
        PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(i);
        if (configForSubId != null) {
            return configForSubId;
        }
        loge("getCarrierConfigBundle: carrier config is null, skipping.");
        return null;
    }

    /* access modifiers changed from: protected */
    public String cleanseInstantLetteringMessage(String str) {
        PersistableBundle carrierConfigBundle;
        if (TextUtils.isEmpty(str) || (carrierConfigBundle = getCarrierConfigBundle(this.mPhone.getSubId())) == null) {
            return str;
        }
        String string = carrierConfigBundle.getString("carrier_instant_lettering_invalid_chars_string");
        if (!TextUtils.isEmpty(string)) {
            str = str.replaceAll(string, "");
        }
        String string2 = carrierConfigBundle.getString("carrier_instant_lettering_escaped_chars_string");
        return !TextUtils.isEmpty(string2) ? escapeChars(string2, str) : str;
    }

    private String escapeChars(String str, String str2) {
        StringBuilder sb = new StringBuilder();
        for (char c : str2.toCharArray()) {
            if (str.contains(Character.toString(c))) {
                sb.append("\\");
            }
            sb.append(c);
        }
        return sb.toString();
    }

    public void pullExternalCall(String str, int i, int i2) {
        Bundle bundle = new Bundle();
        bundle.putBoolean("CallPull", true);
        bundle.putInt(ImsExternalCallTracker.EXTRA_IMS_EXTERNAL_CALL_ID, i2);
        try {
            this.mPhone.notifyUnknownConnection(dial(str, i, bundle));
        } catch (CallStateException e) {
            loge("pullExternalCall failed - " + e);
        }
    }

    /* access modifiers changed from: protected */
    public ImsException getImsManagerIsNullException() {
        return new ImsException("no ims manager", 102);
    }

    /* access modifiers changed from: protected */
    public boolean shouldDisconnectActiveCallOnAnswer(ImsCall imsCall, ImsCall imsCall2) {
        if (imsCall == null || imsCall2 == null || !this.mDropVideoCallWhenAnsweringAudioCall) {
            return false;
        }
        boolean z = imsCall.isVideoCall() || (this.mTreatDowngradedVideoCallsAsVideoCalls && imsCall.wasVideoCall());
        boolean isWifiCall = imsCall.isWifiCall();
        boolean z2 = this.mImsManager.isWfcEnabledByPlatform() && this.mImsManager.isWfcEnabledByUser();
        boolean z3 = !imsCall2.isVideoCall();
        log("shouldDisconnectActiveCallOnAnswer : isActiveCallVideo=" + z + " isActiveCallOnWifi=" + isWifiCall + " isIncomingCallAudio=" + z3 + " isVowifiEnabled=" + z2);
        if (!z || !isWifiCall || !z3 || z2) {
            return false;
        }
        return true;
    }

    public void registerPhoneStateListener(PhoneStateListener phoneStateListener) {
        this.mPhoneStateListeners.add(phoneStateListener);
    }

    public void unregisterPhoneStateListener(PhoneStateListener phoneStateListener) {
        this.mPhoneStateListeners.remove(phoneStateListener);
    }

    private void notifyPhoneStateChanged(PhoneConstants.State state, PhoneConstants.State state2) {
        for (PhoneStateListener onPhoneStateChanged : this.mPhoneStateListeners) {
            onPhoneStateChanged.onPhoneStateChanged(state, state2);
        }
    }

    /* access modifiers changed from: protected */
    public void modifyVideoCall(ImsCall imsCall, int i) {
        ImsPhoneConnection findConnection = findConnection(imsCall);
        if (findConnection != null) {
            int videoState = findConnection.getVideoState();
            if (findConnection.getVideoProvider() != null) {
                findConnection.getVideoProvider().onSendSessionModifyRequest(new VideoProfile(videoState), new VideoProfile(i));
            }
        }
    }

    public boolean isViLteDataMetered() {
        return this.mIsViLteDataMetered;
    }

    /* access modifiers changed from: protected */
    public void onDataEnabledChanged(boolean z, int i) {
        log("onDataEnabledChanged: enabled=" + z + ", reason=" + i);
        this.mIsDataEnabled = z;
        if (!this.mIsViLteDataMetered) {
            StringBuilder sb = new StringBuilder();
            sb.append("Ignore data ");
            sb.append(z ? "enabled" : "disabled");
            sb.append(" - carrier policy indicates that data is not metered for ViLTE calls.");
            log(sb.toString());
        } else if (!z || !isRoamingOnAndRoamingSettingOff()) {
            Iterator<ImsPhoneConnection> it = this.mConnections.iterator();
            while (it.hasNext()) {
                ImsPhoneConnection next = it.next();
                ImsCall imsCall = next.getImsCall();
                next.setLocalVideoCapable(z || (imsCall != null && imsCall.isWifiCall()));
            }
            int i2 = 1406;
            if (i == 3) {
                i2 = 1405;
            }
            maybeNotifyDataDisabled(z, i2);
            handleDataEnabledChange(z, i2);
            if (!this.mShouldUpdateImsConfigOnDisconnect && i != 0 && this.mCarrierConfigLoadedForSubscription) {
                updateImsServiceConfig();
            }
        } else {
            log("Ignore data on when roaming");
        }
    }

    /* access modifiers changed from: private */
    public void updateImsServiceConfig() {
        ImsManager imsManager = this.mImsManager;
        if (imsManager != null && this.mCarrierConfigLoadedForSubscription) {
            imsManager.updateImsServiceConfig();
        }
    }

    /* access modifiers changed from: protected */
    public void maybeNotifyDataDisabled(boolean z, int i) {
        if (!z) {
            Iterator<ImsPhoneConnection> it = this.mConnections.iterator();
            while (it.hasNext()) {
                ImsPhoneConnection next = it.next();
                ImsCall imsCall = next.getImsCall();
                if (imsCall != null && imsCall.isVideoCall() && !imsCall.isWifiCall() && next.hasCapabilities(3)) {
                    if (i == 1406) {
                        next.onConnectionEvent("android.telephony.event.EVENT_DOWNGRADE_DATA_DISABLED", (Bundle) null);
                    } else if (i == 1405) {
                        next.onConnectionEvent("android.telephony.event.EVENT_DOWNGRADE_DATA_LIMIT_REACHED", (Bundle) null);
                    }
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void handleDataEnabledChange(boolean z, int i) {
        if (!z) {
            Iterator<ImsPhoneConnection> it = this.mConnections.iterator();
            while (it.hasNext()) {
                ImsPhoneConnection next = it.next();
                ImsCall imsCall = next.getImsCall();
                if (imsCall != null && imsCall.isVideoCall() && !imsCall.isWifiCall()) {
                    log("handleDataEnabledChange - downgrading " + next);
                    downgradeVideoCall(i, next);
                }
            }
        } else if (this.mSupportPauseVideo) {
            Iterator<ImsPhoneConnection> it2 = this.mConnections.iterator();
            while (it2.hasNext()) {
                ImsPhoneConnection next2 = it2.next();
                log("handleDataEnabledChange - resuming " + next2);
                if (VideoProfile.isPaused(next2.getVideoState()) && next2.wasVideoPausedFromSource(2)) {
                    next2.resumeVideo(2);
                }
            }
            this.mShouldUpdateImsConfigOnDisconnect = false;
        }
    }

    /* access modifiers changed from: private */
    public void downgradeVideoCall(int i, ImsPhoneConnection imsPhoneConnection) {
        ImsCall imsCall = imsPhoneConnection.getImsCall();
        if (imsCall == null) {
            return;
        }
        if (imsPhoneConnection.hasCapabilities(3) && (!this.mSupportPauseVideo || ignoreCarrierPauseSupport())) {
            log("downgradeVideoCall :: callId=" + imsPhoneConnection.getTelecomCallId() + " Downgrade to audio");
            modifyVideoCall(imsCall, 0);
        } else if (!this.mSupportPauseVideo || i == 1407) {
            log("downgradeVideoCall :: callId=" + imsPhoneConnection.getTelecomCallId() + " Disconnect call.");
            imsCall.terminate(501, i);
        } else {
            log("downgradeVideoCall :: callId=" + imsPhoneConnection.getTelecomCallId() + " Pause audio");
            this.mShouldUpdateImsConfigOnDisconnect = true;
            imsPhoneConnection.pauseVideo(2);
        }
    }

    /* access modifiers changed from: protected */
    public void resetImsCapabilities() {
        log("Resetting Capabilities...");
        boolean isVideoCallEnabled = isVideoCallEnabled();
        this.mMmTelCapabilities = new MmTelFeature.MmTelCapabilities();
        this.mPhone.setServiceState(1);
        this.mPhone.resetImsRegistrationState();
        this.mPhone.processDisconnectReason(new ImsReasonInfo(106, 0));
        boolean isVideoCallEnabled2 = isVideoCallEnabled();
        if (isVideoCallEnabled != isVideoCallEnabled2) {
            this.mPhone.notifyForVideoCapabilityChanged(isVideoCallEnabled2);
        }
    }

    /* access modifiers changed from: protected */
    public boolean isWifiConnected() {
        NetworkInfo activeNetworkInfo;
        ConnectivityManager connectivityManager = (ConnectivityManager) this.mPhone.getContext().getSystemService("connectivity");
        if (connectivityManager == null || (activeNetworkInfo = connectivityManager.getActiveNetworkInfo()) == null || !activeNetworkInfo.isConnected() || activeNetworkInfo.getType() != 1) {
            return false;
        }
        return true;
    }

    /* access modifiers changed from: private */
    public void registerForConnectivityChanges() {
        ConnectivityManager connectivityManager;
        if (!this.mIsMonitoringConnectivity && this.mNotifyVtHandoverToWifiFail && (connectivityManager = (ConnectivityManager) this.mPhone.getContext().getSystemService("connectivity")) != null) {
            Rlog.i(LOG_TAG, "registerForConnectivityChanges");
            NetworkRequest.Builder builder = new NetworkRequest.Builder();
            builder.addTransportType(1);
            connectivityManager.registerNetworkCallback(builder.build(), this.mNetworkCallback);
            this.mIsMonitoringConnectivity = true;
        }
    }

    /* access modifiers changed from: private */
    public void unregisterForConnectivityChanges() {
        ConnectivityManager connectivityManager;
        if (this.mIsMonitoringConnectivity && this.mNotifyVtHandoverToWifiFail && (connectivityManager = (ConnectivityManager) this.mPhone.getContext().getSystemService("connectivity")) != null) {
            Rlog.i(LOG_TAG, "unregisterForConnectivityChanges");
            connectivityManager.unregisterNetworkCallback(this.mNetworkCallback);
            this.mIsMonitoringConnectivity = false;
        }
    }

    /* access modifiers changed from: private */
    public void scheduleHandoverCheck() {
        ImsCall imsCall = this.mForegroundCall.getImsCall();
        ImsPhoneConnection firstConnection = this.mForegroundCall.getFirstConnection();
        if (this.mNotifyVtHandoverToWifiFail && imsCall != null && imsCall.isVideoCall() && firstConnection != null && firstConnection.getDisconnectCause() == 0 && !hasMessages(25)) {
            Rlog.i(LOG_TAG, "scheduleHandoverCheck: schedule");
            sendMessageDelayed(obtainMessage(25, imsCall), 60000);
        }
    }

    public boolean isCarrierDowngradeOfVtCallSupported() {
        return this.mSupportDowngradeVtToAudio;
    }

    @VisibleForTesting
    public void setDataEnabled(boolean z) {
        this.mIsDataEnabled = z;
    }

    /* access modifiers changed from: private */
    public void pruneCallQualityMetricsHistory() {
        if (this.mCallQualityMetricsHistory.size() > 10) {
            this.mCallQualityMetricsHistory.poll();
        }
    }

    private void handleFeatureCapabilityChanged(ImsFeature.Capabilities capabilities) {
        boolean isVideoCallEnabled = isVideoCallEnabled();
        StringBuilder sb = new StringBuilder(120);
        sb.append("handleFeatureCapabilityChanged: ");
        sb.append(capabilities);
        this.mMmTelCapabilities = new MmTelFeature.MmTelCapabilities(capabilities);
        boolean isVideoCallEnabled2 = isVideoCallEnabled();
        boolean z = isVideoCallEnabled != isVideoCallEnabled2;
        sb.append(" isVideoEnabledStateChanged=");
        sb.append(z);
        if (z) {
            log("handleFeatureCapabilityChanged - notifyForVideoCapabilityChanged=" + isVideoCallEnabled2);
            this.mPhone.notifyForVideoCapabilityChanged(isVideoCallEnabled2);
        }
        log(sb.toString());
        String str = "handleFeatureCapabilityChanged: isVolteEnabled=" + isVoiceOverCellularImsEnabled() + ", isVideoCallEnabled=" + isVideoCallEnabled() + ", isVowifiEnabled=" + isVowifiEnabled() + ", isUtEnabled=" + isUtEnabled();
        log(str);
        this.mRegLocalLog.log(str);
        this.mPhone.onFeatureCapabilityChanged();
        int imsRegistrationTech = getImsRegistrationTech();
        this.mMetrics.writeOnImsCapabilities(this.mPhone.getPhoneId(), imsRegistrationTech, this.mMmTelCapabilities);
        this.mPhone.getImsStats().onImsCapabilitiesChanged(imsRegistrationTech, this.mMmTelCapabilities);
    }

    @VisibleForTesting
    public void onCallHoldReceived(ImsCall imsCall) {
        log("onCallHoldReceived");
        ImsPhoneConnection findConnection = findConnection(imsCall);
        if (findConnection != null) {
            if (!this.mOnHoldToneStarted && ((ImsPhoneCall.isLocalTone(imsCall) || this.mAlwaysPlayRemoteHoldTone) && findConnection.getState() == Call.State.ACTIVE)) {
                this.mPhone.startOnHoldTone(findConnection);
                this.mOnHoldToneStarted = true;
                this.mOnHoldToneId = System.identityHashCode(findConnection);
            }
            findConnection.onConnectionEvent("android.telecom.event.CALL_REMOTELY_HELD", (Bundle) null);
            if (this.mPhone.getContext().getResources().getBoolean(17891821) && this.mSupportPauseVideo && VideoProfile.isVideo(findConnection.getVideoState())) {
                findConnection.changeToPausedState();
            }
        }
        SuppServiceNotification suppServiceNotification = new SuppServiceNotification();
        suppServiceNotification.notificationType = 1;
        suppServiceNotification.code = 2;
        this.mPhone.notifySuppSvcNotification(suppServiceNotification);
        this.mMetrics.writeOnImsCallHoldReceived(this.mPhone.getPhoneId(), imsCall.getCallSession());
    }

    @VisibleForTesting
    public void setAlwaysPlayRemoteHoldTone(boolean z) {
        this.mAlwaysPlayRemoteHoldTone = z;
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Code restructure failed: missing block: B:4:0x000a, code lost:
        r0 = (r0 = r0.getServiceStateTracker()).getLocaleTracker();
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.String getNetworkCountryIso() {
        /*
            r0 = this;
            com.android.internal.telephony.imsphone.ImsPhone r0 = r0.mPhone
            if (r0 == 0) goto L_0x0015
            com.android.internal.telephony.ServiceStateTracker r0 = r0.getServiceStateTracker()
            if (r0 == 0) goto L_0x0015
            com.android.internal.telephony.LocaleTracker r0 = r0.getLocaleTracker()
            if (r0 == 0) goto L_0x0015
            java.lang.String r0 = r0.getCurrentCountry()
            goto L_0x0017
        L_0x0015:
            java.lang.String r0 = ""
        L_0x0017:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneCallTracker.getNetworkCountryIso():java.lang.String");
    }

    public ImsPhone getPhone() {
        return this.mPhone;
    }

    @VisibleForTesting
    public void setSupportCepOnPeer(boolean z) {
        this.mSupportCepOnPeer = z;
    }

    public void injectTestConferenceState(ImsConferenceState imsConferenceState) {
        List parseConferenceState = ImsCall.parseConferenceState(imsConferenceState);
        Iterator<ImsPhoneConnection> it = getConnections().iterator();
        while (it.hasNext()) {
            it.next().updateConferenceParticipants(parseConferenceState);
        }
    }

    public void setConferenceEventPackageEnabled(boolean z) {
        log("setConferenceEventPackageEnabled isEnabled=" + z);
        this.mIsConferenceEventPackageEnabled = z;
    }

    public boolean isConferenceEventPackageEnabled() {
        return this.mIsConferenceEventPackageEnabled;
    }

    @VisibleForTesting
    public ImsCall.Listener getImsCallListener() {
        return this.mImsCallListener;
    }

    @VisibleForTesting
    public ArrayList<ImsPhoneConnection> getConnections() {
        return this.mConnections;
    }

    @VisibleForTesting
    public ImsPhoneConnection getPendingMO() {
        return this.mPendingMO;
    }

    public void setConfig(Config config) {
        this.mConfig = config;
    }

    private void handleConferenceFailed(ImsPhoneConnection imsPhoneConnection, ImsPhoneConnection imsPhoneConnection2) {
        if (imsPhoneConnection != null) {
            imsPhoneConnection.handleMergeComplete();
        }
        if (imsPhoneConnection2 != null) {
            imsPhoneConnection2.handleMergeComplete();
        }
        this.mPhone.notifySuppServiceFailed(PhoneInternalInterface.SuppService.CONFERENCE);
    }

    /* access modifiers changed from: private */
    public boolean isForegroundHigherPriority() {
        if (!this.mBackgroundCall.getState().isAlive()) {
            return true;
        }
        if (this.mForegroundCall.getFirstConnection().getCallPriority() > this.mBackgroundCall.getFirstConnection().getCallPriority()) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public CommandException getImsUssdCommandException(ImsReasonInfo imsReasonInfo) {
        return new CommandException(CommandException.Error.GENERIC_FAILURE);
    }

    /* access modifiers changed from: protected */
    public ImsPhoneConnection makeImsPhoneConnectionForMO(String str, boolean z, boolean z2) {
        return new ImsPhoneConnection(this.mPhone, str, this, this.mForegroundCall, z, z2);
    }

    /* access modifiers changed from: protected */
    public ImsPhoneConnection makeImsPhoneConnectionForMT(ImsCall imsCall, boolean z) {
        ImsPhoneCall imsPhoneCall;
        ImsPhone imsPhone = this.mPhone;
        if (z) {
            imsPhoneCall = this.mForegroundCall;
        } else {
            imsPhoneCall = this.mRingingCall;
        }
        return new ImsPhoneConnection((Phone) imsPhone, imsCall, this, imsPhoneCall, z);
    }

    /* access modifiers changed from: protected */
    public ImsPhoneConnection makeImsPhoneConnectionForConference(String[] strArr) {
        return new ImsPhoneConnection((Phone) this.mPhone, strArr, this, this.mForegroundCall, false);
    }

    /* access modifiers changed from: protected */
    public ImsCall takeCall(IImsCallSession iImsCallSession, Bundle bundle) throws ImsException {
        return this.mImsManager.takeCall(iImsCallSession, this.mImsCallListener);
    }

    /* access modifiers changed from: protected */
    public boolean canDailOnCallTerminated() {
        return this.mPendingMO != null;
    }

    /* access modifiers changed from: protected */
    public AsyncResult getCallStateChangeAsyncResult() {
        return new AsyncResult((Object) null, (Object) null, (Throwable) null);
    }

    /* access modifiers changed from: protected */
    public void disconnectPendingMo() {
        this.mPendingMO = null;
    }
}
