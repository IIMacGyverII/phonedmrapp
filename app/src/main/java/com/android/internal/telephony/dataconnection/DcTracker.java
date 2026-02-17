package com.android.internal.telephony.dataconnection;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.ActivityNotFoundException;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.database.ContentObserver;
import android.database.Cursor;
import android.net.ConnectivityManager;
import android.net.LinkProperties;
import android.net.NetworkCapabilities;
import android.net.NetworkPolicyManager;
import android.net.NetworkRequest;
import android.net.TrafficStats;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.os.UserHandle;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.provider.Telephony;
import android.telephony.AccessNetworkConstants;
import android.telephony.CarrierConfigManager;
import android.telephony.CellLocation;
import android.telephony.DataFailCause;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.PcoData;
import android.telephony.PreciseDataConnectionState;
import android.telephony.ServiceState;
import android.telephony.SubscriptionManager;
import android.telephony.SubscriptionPlan;
import android.telephony.TelephonyFrameworkInitializer;
import android.telephony.TelephonyManager;
import android.telephony.cdma.CdmaCellLocation;
import android.telephony.data.ApnSetting;
import android.telephony.data.DataCallResponse;
import android.telephony.data.DataProfile;
import android.telephony.data.ThrottleStatus;
import android.telephony.gsm.GsmCellLocation;
import android.text.TextUtils;
import android.util.EventLog;
import android.util.Log;
import android.util.Pair;
import android.util.SparseArray;
import androidx.core.app.NotificationCompat;
import androidx.core.os.EnvironmentCompat;
import androidx.core.view.MotionEventCompat;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.AsyncChannel;
import com.android.internal.telephony.DctConstants;
import com.android.internal.telephony.EventLogTags;
import com.android.internal.telephony.GsmCdmaPhone;
import com.android.internal.telephony.ITelephony;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.SettingsObserver;
import com.android.internal.telephony.SubscriptionInfoUpdater;
import com.android.internal.telephony.data.DataConfigManager;
import com.android.internal.telephony.data.DataConfigManager$$ExternalSyntheticLambda1;
import com.android.internal.telephony.data.DataConfigManager$$ExternalSyntheticLambda6;
import com.android.internal.telephony.data.PhoneSwitcher;
import com.android.internal.telephony.dataconnection.DataConnectionReasons;
import com.android.internal.telephony.dataconnection.DataThrottler;
import com.android.internal.telephony.metrics.DataStallRecoveryStats;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.nano.TelephonyProto;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.internal.telephony.util.NotificationChannelController;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class DcTracker extends Handler {
    static final String APN_ID = "apn_id";
    public static final String DATA_COMPLETE_MSG_EXTRA_HANDOVER_FAILURE_FALLBACK = "extra_handover_failure_fallback";
    public static final String DATA_COMPLETE_MSG_EXTRA_NETWORK_REQUEST = "extra_network_request";
    public static final String DATA_COMPLETE_MSG_EXTRA_SUCCESS = "extra_success";
    public static final String DATA_COMPLETE_MSG_EXTRA_TRANSPORT_TYPE = "extra_transport_type";
    private static final DctConstants.State[] DATA_CONNECTION_STATE_PRIORITIES = {DctConstants.State.IDLE, DctConstants.State.DISCONNECTING, DctConstants.State.CONNECTING, DctConstants.State.CONNECTED};
    private static final int DATA_STALL_ALARM_AGGRESSIVE_DELAY_IN_MS_DEFAULT = 60000;
    private static final int DATA_STALL_ALARM_NON_AGGRESSIVE_DELAY_IN_MS_DEFAULT = 360000;
    protected static final boolean DATA_STALL_NOT_SUSPECTED = false;
    private static final boolean DATA_STALL_SUSPECTED = true;
    protected static final boolean DBG = true;
    private static final String DEBUG_PROV_APN_ALARM = "persist.debug.prov_apn_alarm";
    private static final String EXTRA_PROVISION_PHONE_ID = "provision.phone.id";
    private static final String INTENT_DATA_STALL_ALARM = "com.android.internal.telephony.data-stall";
    private static final String INTENT_DATA_STALL_ALARM_EXTRA_TAG = "data_stall_alarm_extra_tag";
    private static final String INTENT_DATA_STALL_ALARM_EXTRA_TRANSPORT_TYPE = "data_stall_alarm_extra_transport_type";
    private static final String INTENT_PROVISION = "com.android.internal.telephony.PROVISION";
    private static final String INTENT_PROVISIONING_APN_ALARM = "com.android.internal.telephony.provisioning_apn_alarm";
    private static final String NOTIFICATION_TAG = DcTracker.class.getSimpleName();
    private static final int NO_DATA_NOTIFICATION = 1001;
    private static final int NUMBER_SENT_PACKETS_OF_HANG = 10;
    private static final int POLL_NETSTAT_MILLIS = 1000;
    private static final int POLL_NETSTAT_SCREEN_OFF_MILLIS = 600000;
    static final Uri PREFERAPN_NO_UPDATE_URI_USING_SUBID = Uri.parse("content://telephony/carriers/preferapn_no_update/subId/");
    private static final int PROVISIONING_APN_ALARM_DELAY_IN_MS_DEFAULT = 900000;
    private static final String PROVISIONING_APN_ALARM_TAG_EXTRA = "provisioning.apn.alarm.tag";
    private static final int PROVISIONING_SPINNER_TIMEOUT_MILLIS = 120000;
    private static final boolean RADIO_TESTS = false;
    private static final int RECOVERY_ACTION_CLEANUP = 1;
    private static final int RECOVERY_ACTION_GET_DATA_CALL_LIST = 0;
    private static final int RECOVERY_ACTION_RADIO_RESTART = 3;
    private static final int RECOVERY_ACTION_REREGISTER = 2;
    public static final int RELEASE_TYPE_DETACH = 2;
    public static final int RELEASE_TYPE_HANDOVER = 3;
    public static final int RELEASE_TYPE_NORMAL = 1;
    public static final int REQUEST_TYPE_HANDOVER = 2;
    public static final int REQUEST_TYPE_NORMAL = 1;
    private static final boolean VDBG = false;
    private static final boolean VDBG_STALL = false;
    private static int sEnableFailFastRefCounter = 0;
    public AtomicBoolean isCleanupRequired;
    private DctConstants.Activity mActivity;
    private final AlarmManager mAlarmManager;
    private ArrayList<ApnSetting> mAllApnSettings;
    private RegistrantList mAllDataDisconnectedRegistrants;
    protected ConcurrentHashMap<String, ApnContext> mApnContexts;
    /* access modifiers changed from: private */
    public SparseArray<ApnContext> mApnContextsByType;
    private ApnChangeObserver mApnObserver;
    private final LocalLog mApnSettingsInitializationLog;
    private HashMap<String, Integer> mApnToDataConnectionId;
    /* access modifiers changed from: private */
    public AtomicBoolean mAttached;
    private AtomicBoolean mAutoAttachEnabled;
    protected boolean mAutoAttachOnCreationConfig;
    private ConcurrentHashMap<String, Pair<Integer, Integer>> mBandwidths;
    private boolean mCanSetPreferApn;
    private boolean mConfigReady;
    /* access modifiers changed from: private */
    public List<Integer> mCongestedNetworkTypes;
    /* access modifiers changed from: private */
    public boolean mCongestedOverride;
    /* access modifiers changed from: private */
    public final Handler mDataConnectionTracker;
    private HashMap<Integer, DataConnection> mDataConnections;
    private final DataEnabledSettings mDataEnabledSettings;
    private final LocalLog mDataRoamingLeakageLog;
    private boolean mDataServiceBound;
    /* access modifiers changed from: private */
    public final DataServiceManager mDataServiceManager;
    private PendingIntent mDataStallAlarmIntent;
    private int mDataStallAlarmTag;
    /* access modifiers changed from: private */
    public volatile boolean mDataStallNoRxEnabled;
    private TxRxSum mDataStallTxRxSum;
    private final DataThrottler mDataThrottler;
    private DcTesterFailBringUpAll mDcTesterFailBringUpAll;
    private DcController mDcc;
    private DataStallRecoveryHandler mDsRecoveryHandler;
    private ApnSetting mEmergencyApn;
    protected volatile boolean mFailFast;
    private HandlerThread mHandlerThread;
    private final Map<Integer, List<Message>> mHandoverCompletionMsgs;
    protected boolean mInVoiceCall;
    private final BroadcastReceiver mIntentReceiver;
    private boolean mIsDisposed;
    private boolean mIsProvisioning;
    private boolean mIsPsRestricted;
    /* access modifiers changed from: private */
    public boolean mIsScreenOn;
    private ArrayList<DataProfile> mLastDataProfileList;
    private final String mLogTag;
    private boolean mLteEndcUsingUserDataForRrcDetection;
    /* access modifiers changed from: private */
    public boolean mNetStatPollEnabled;
    /* access modifiers changed from: private */
    public int mNetStatPollPeriod;
    private NetworkPolicyManager mNetworkPolicyManager;
    private int mNoRecvPollCount;
    private boolean mNrNsaAllUnmetered;
    private boolean mNrNsaMmwaveUnmetered;
    private boolean mNrNsaRoamingUnmetered;
    private boolean mNrNsaSub6Unmetered;
    private boolean mNrSaAllUnmetered;
    private boolean mNrSaMmwaveUnmetered;
    private boolean mNrSaSub6Unmetered;
    protected final Phone mPhone;
    private final Runnable mPollNetStat;
    private ApnSetting mPreferredApn;
    private ArrayList<ApnContext> mPrioritySortedApnContexts;
    private BroadcastReceiver mProvisionBroadcastReceiver;
    private PendingIntent mProvisioningApnAlarmIntent;
    private int mProvisioningApnAlarmTag;
    /* access modifiers changed from: private */
    public ProgressDialog mProvisioningSpinner;
    private String mProvisioningUrl;
    private PendingIntent mReconnectIntent;
    private AsyncChannel mReplyAc;
    private int mRequestedApnType;
    private boolean mReregisterOnReconnectFailure;
    /* access modifiers changed from: private */
    public ContentResolver mResolver;
    private long mRxPkts;
    /* access modifiers changed from: private */
    public long mSentSinceLastRecv;
    private final SettingsObserver mSettingsObserver;
    @TelephonyManager.SimState
    private int mSimState;
    private DctConstants.State mState;
    private final NetworkPolicyManager.SubscriptionCallback mSubscriptionCallback;
    /* access modifiers changed from: private */
    public List<SubscriptionPlan> mSubscriptionPlans;
    private final TelephonyManager mTelephonyManager;
    private final ThrottleStatusChangedCallback mThrottleStatusCallback;
    private final int mTransportType;
    private long mTxPkts;
    private AtomicInteger mUniqueIdGenerator;
    /* access modifiers changed from: private */
    public List<Integer> mUnmeteredNetworkTypes;
    /* access modifiers changed from: private */
    public boolean mUnmeteredOverride;
    private boolean mWatchdog;
    private long mWatchdogTimeMs;

    @Retention(RetentionPolicy.SOURCE)
    public @interface RecoveryAction {
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface ReleaseNetworkType {
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface RequestNetworkType {
    }

    protected enum RetryFailures {
        ALWAYS,
        ONLY_ON_CHANGE
    }

    private void logSortedApnContexts() {
    }

    public static String releaseTypeToString(int i) {
        return i != 1 ? i != 2 ? i != 3 ? "UNKNOWN" : "HANDOVER" : "DETACH" : "NORMAL";
    }

    public static String requestTypeToString(int i) {
        return i != 1 ? i != 2 ? "UNKNOWN" : "HANDOVER" : "NORMAL";
    }

    private static boolean shouldFallbackOnFailedHandover(int i, int i2, int i3) {
        if (i2 != 2) {
            return false;
        }
        if (i == 1) {
            return true;
        }
        return i == 0 && i3 == 2251;
    }

    private class ThrottleStatusChangedCallback implements DataThrottler.Callback {
        private ThrottleStatusChangedCallback() {
        }

        public void onThrottleStatusChanged(List<ThrottleStatus> list) {
            for (ThrottleStatus next : list) {
                if (next.getThrottleType() == 1) {
                    DcTracker dcTracker = DcTracker.this;
                    dcTracker.setupDataOnConnectableApn((ApnContext) dcTracker.mApnContextsByType.get(next.getApnType()), PhoneInternalInterface.REASON_DATA_UNTHROTTLED, RetryFailures.ALWAYS);
                }
            }
        }
    }

    private void registerSettingsObserver() {
        this.mSettingsObserver.unobserve();
        String num = TelephonyManager.getDefault().getSimCount() > 1 ? Integer.toString(this.mPhone.getSubId()) : "";
        SettingsObserver settingsObserver = this.mSettingsObserver;
        settingsObserver.observe(Settings.Global.getUriFor("data_roaming" + num), 270384);
        this.mSettingsObserver.observe(Settings.Global.getUriFor("device_provisioned"), 270386);
    }

    public static class TxRxSum {
        public long rxPkts;
        public long txPkts;

        public TxRxSum() {
            reset();
        }

        public TxRxSum(long j, long j2) {
            this.txPkts = j;
            this.rxPkts = j2;
        }

        public TxRxSum(TxRxSum txRxSum) {
            this.txPkts = txRxSum.txPkts;
            this.rxPkts = txRxSum.rxPkts;
        }

        public void reset() {
            this.txPkts = -1;
            this.rxPkts = -1;
        }

        public String toString() {
            return "{txSum=" + this.txPkts + " rxSum=" + this.rxPkts + "}";
        }

        public void updateTotalTxRxSum() {
            this.txPkts = TrafficStats.getMobileTxPackets();
            this.rxPkts = TrafficStats.getMobileRxPackets();
        }
    }

    private void onDataReconnect(ApnContext apnContext, int i, int i2) {
        int subId = this.mPhone.getSubId();
        String apnType = apnContext.getApnType();
        String reason = apnContext.getReason();
        if (!SubscriptionManager.isValidSubscriptionId(i) || i != subId) {
            log("onDataReconnect: invalid subId");
            return;
        }
        ApnContext apnContext2 = this.mApnContexts.get(apnType);
        log("onDataReconnect: mState=" + this.mState + " reason=" + reason + " apnType=" + apnType + " apnContext=" + apnContext2);
        if (apnContext2 != null && apnContext2.isEnabled()) {
            apnContext2.setReason(reason);
            DctConstants.State state = apnContext2.getState();
            log("onDataReconnect: apnContext state=" + state);
            if (state == DctConstants.State.FAILED || state == DctConstants.State.IDLE) {
                log("onDataReconnect: state is FAILED|IDLE, disassociate");
                apnContext2.releaseDataConnection("");
            } else {
                log("onDataReconnect: keep associated");
            }
            sendMessage(obtainMessage(270339, i2, 0, apnContext2));
        }
    }

    /* access modifiers changed from: private */
    public void onActionIntentDataStallAlarm(Intent intent) {
        int intExtra = intent.getIntExtra("subscription", -1);
        if (SubscriptionManager.isValidSubscriptionId(intExtra) && intExtra == this.mPhone.getSubId() && intent.getIntExtra(INTENT_DATA_STALL_ALARM_EXTRA_TRANSPORT_TYPE, 0) == this.mTransportType) {
            Message obtainMessage = obtainMessage(270353, intent.getAction());
            obtainMessage.arg1 = intent.getIntExtra(INTENT_DATA_STALL_ALARM_EXTRA_TAG, 0);
            sendMessage(obtainMessage);
        }
    }

    private class ApnChangeObserver extends ContentObserver {
        public ApnChangeObserver() {
            super(DcTracker.this.mDataConnectionTracker);
        }

        public void onChange(boolean z) {
            DcTracker dcTracker = DcTracker.this;
            dcTracker.sendMessage(dcTracker.obtainMessage(270355));
        }
    }

    public DcTracker(Phone phone, int i) {
        this.isCleanupRequired = new AtomicBoolean(false);
        this.mRequestedApnType = 17;
        this.mPrioritySortedApnContexts = new ArrayList<>();
        this.mAllApnSettings = new ArrayList<>();
        this.mPreferredApn = null;
        this.mIsPsRestricted = false;
        this.mEmergencyApn = null;
        this.mIsDisposed = false;
        this.mIsProvisioning = false;
        this.mProvisioningUrl = null;
        this.mDataServiceBound = false;
        this.mProvisioningApnAlarmIntent = null;
        this.mProvisioningApnAlarmTag = (int) SystemClock.elapsedRealtime();
        this.mReplyAc = new AsyncChannel();
        this.mDataRoamingLeakageLog = new LocalLog(32);
        this.mApnSettingsInitializationLog = new LocalLog(32);
        this.mWatchdogTimeMs = 3600000;
        this.mWatchdog = false;
        this.mNrNsaAllUnmetered = false;
        this.mNrNsaMmwaveUnmetered = false;
        this.mNrNsaSub6Unmetered = false;
        this.mNrSaAllUnmetered = false;
        this.mNrSaMmwaveUnmetered = false;
        this.mNrSaSub6Unmetered = false;
        this.mNrNsaRoamingUnmetered = false;
        this.mLteEndcUsingUserDataForRrcDetection = false;
        this.mSubscriptionPlans = new ArrayList();
        this.mUnmeteredNetworkTypes = null;
        this.mCongestedNetworkTypes = null;
        this.mUnmeteredOverride = false;
        this.mCongestedOverride = false;
        this.mSimState = 0;
        AnonymousClass1 r2 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                if (action.equals("android.intent.action.SCREEN_ON")) {
                    DcTracker.this.log("screen on");
                    DcTracker.this.mIsScreenOn = true;
                    DcTracker.this.stopNetStatPoll();
                    DcTracker.this.startNetStatPoll();
                    DcTracker.this.restartDataStallAlarm();
                } else if (action.equals("android.intent.action.SCREEN_OFF")) {
                    DcTracker.this.log("screen off");
                    DcTracker.this.mIsScreenOn = false;
                    DcTracker.this.stopNetStatPoll();
                    DcTracker.this.startNetStatPoll();
                    DcTracker.this.restartDataStallAlarm();
                } else if (action.equals(DcTracker.INTENT_DATA_STALL_ALARM)) {
                    DcTracker.this.onActionIntentDataStallAlarm(intent);
                } else if (action.equals(DcTracker.INTENT_PROVISIONING_APN_ALARM)) {
                    DcTracker.this.log("Provisioning apn alarm");
                    DcTracker.this.onActionIntentProvisioningApnAlarm(intent);
                } else if (action.equals("android.telephony.action.SIM_CARD_STATE_CHANGED") || action.equals("android.telephony.action.SIM_APPLICATION_STATE_CHANGED")) {
                    if (DcTracker.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1)) {
                        int intExtra = intent.getIntExtra("android.telephony.extra.SIM_STATE", 0);
                        DcTracker dcTracker = DcTracker.this;
                        dcTracker.sendMessage(dcTracker.obtainMessage(270391, intExtra, 0));
                    }
                } else if (!action.equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                    DcTracker dcTracker2 = DcTracker.this;
                    dcTracker2.log("onReceive: Unknown action=" + action);
                } else if (DcTracker.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1) && !intent.getBooleanExtra("android.telephony.extra.REBROADCAST_ON_UNLOCK", false) && SubscriptionManager.isValidSubscriptionId(intent.getIntExtra("android.telephony.extra.SUBSCRIPTION_INDEX", -1))) {
                    DcTracker.this.sendEmptyMessage(270390);
                }
            }
        };
        this.mIntentReceiver = r2;
        this.mPollNetStat = new Runnable() {
            public void run() {
                DcTracker.this.updateDataActivity();
                if (DcTracker.this.mIsScreenOn) {
                    DcTracker dcTracker = DcTracker.this;
                    dcTracker.mNetStatPollPeriod = Settings.Global.getInt(dcTracker.mResolver, "pdp_watchdog_poll_interval_ms", 1000);
                } else {
                    DcTracker dcTracker2 = DcTracker.this;
                    dcTracker2.mNetStatPollPeriod = Settings.Global.getInt(dcTracker2.mResolver, "pdp_watchdog_long_poll_interval_ms", 600000);
                }
                if (DcTracker.this.mNetStatPollEnabled) {
                    DcTracker.this.mDataConnectionTracker.postDelayed(this, (long) DcTracker.this.mNetStatPollPeriod);
                }
            }
        };
        AnonymousClass3 r3 = new NetworkPolicyManager.SubscriptionCallback() {
            public void onSubscriptionOverride(int i, int i2, int i3, int[] iArr) {
                Phone phone = DcTracker.this.mPhone;
                if (phone != null && phone.getSubId() == i) {
                    ArrayList arrayList = new ArrayList();
                    boolean z = false;
                    for (int valueOf : iArr) {
                        arrayList.add(Integer.valueOf(valueOf));
                    }
                    DcTracker.this.log("Subscription override: overrideMask=" + i2 + ", overrideValue=" + i3 + ", networkTypes=" + arrayList);
                    if (i2 == 1) {
                        DcTracker.this.mUnmeteredNetworkTypes = arrayList;
                        DcTracker dcTracker = DcTracker.this;
                        if (i3 != 0) {
                            z = true;
                        }
                        dcTracker.mUnmeteredOverride = z;
                        DcTracker.this.reevaluateUnmeteredConnections();
                    } else if (i2 == 2) {
                        DcTracker.this.mCongestedNetworkTypes = arrayList;
                        DcTracker dcTracker2 = DcTracker.this;
                        if (i3 != 0) {
                            z = true;
                        }
                        dcTracker2.mCongestedOverride = z;
                        DcTracker.this.reevaluateCongestedConnections();
                    }
                }
            }

            public void onSubscriptionPlansChanged(int i, SubscriptionPlan[] subscriptionPlanArr) {
                Phone phone = DcTracker.this.mPhone;
                if (phone != null && phone.getSubId() == i) {
                    DcTracker.this.mSubscriptionPlans = Arrays.asList(subscriptionPlanArr);
                    DcTracker dcTracker = DcTracker.this;
                    dcTracker.log("SubscriptionPlans changed: " + DcTracker.this.mSubscriptionPlans);
                    DcTracker.this.reevaluateUnmeteredConnections();
                }
            }
        };
        this.mSubscriptionCallback = r3;
        this.mAllDataDisconnectedRegistrants = new RegistrantList();
        this.mActivity = DctConstants.Activity.NONE;
        this.mState = DctConstants.State.IDLE;
        this.mNetStatPollEnabled = false;
        this.mDataStallTxRxSum = new TxRxSum(0, 0);
        this.mDataStallAlarmTag = (int) SystemClock.elapsedRealtime();
        this.mDataStallAlarmIntent = null;
        this.mNoRecvPollCount = 0;
        this.mDataStallNoRxEnabled = true;
        this.mFailFast = false;
        this.mInVoiceCall = false;
        this.mReconnectIntent = null;
        this.mAutoAttachOnCreationConfig = false;
        this.mAutoAttachEnabled = new AtomicBoolean(false);
        this.mIsScreenOn = true;
        this.mUniqueIdGenerator = new AtomicInteger(0);
        this.mDataConnections = new HashMap<>();
        this.mApnToDataConnectionId = new HashMap<>();
        this.mApnContexts = new ConcurrentHashMap<>();
        this.mApnContextsByType = new SparseArray<>();
        this.mLastDataProfileList = new ArrayList<>();
        this.mBandwidths = new ConcurrentHashMap<>();
        this.mConfigReady = false;
        this.mReregisterOnReconnectFailure = false;
        this.mCanSetPreferApn = false;
        this.mAttached = new AtomicBoolean(false);
        this.mHandoverCompletionMsgs = new HashMap();
        this.mPhone = phone;
        log("DCT.constructor");
        this.mTelephonyManager = TelephonyManager.from(phone.getContext()).createForSubscriptionId(phone.getSubId());
        StringBuilder sb = new StringBuilder();
        sb.append("-");
        sb.append(i == 1 ? "C" : "I");
        String str = sb.toString() + "-" + phone.getPhoneId();
        this.mLogTag = "DCT" + str;
        this.mTransportType = i;
        DataServiceManager dataServiceManager = new DataServiceManager(phone, i, str);
        this.mDataServiceManager = dataServiceManager;
        DataThrottler dataThrottler = new DataThrottler(phone, i);
        this.mDataThrottler = dataThrottler;
        this.mResolver = phone.getContext().getContentResolver();
        this.mAlarmManager = (AlarmManager) phone.getContext().getSystemService(NotificationCompat.CATEGORY_ALARM);
        this.mDsRecoveryHandler = new DataStallRecoveryHandler();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.SCREEN_ON");
        intentFilter.addAction("android.intent.action.SCREEN_OFF");
        intentFilter.addAction(INTENT_DATA_STALL_ALARM);
        intentFilter.addAction(INTENT_PROVISIONING_APN_ALARM);
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction("android.telephony.action.SIM_CARD_STATE_CHANGED");
        intentFilter.addAction("android.telephony.action.SIM_APPLICATION_STATE_CHANGED");
        DataEnabledSettings dataEnabledSettings = phone.getDataEnabledSettings();
        this.mDataEnabledSettings = dataEnabledSettings;
        dataEnabledSettings.registerForDataEnabledChanged(this, 270382, (Object) null);
        dataEnabledSettings.registerForDataEnabledOverrideChanged(this, 270387);
        phone.getContext().registerReceiver(r2, intentFilter, (String) null, phone);
        this.mAutoAttachEnabled.set(PreferenceManager.getDefaultSharedPreferences(phone.getContext()).getBoolean(Phone.DATA_DISABLED_ON_BOOT_KEY, false));
        NetworkPolicyManager networkPolicyManager = (NetworkPolicyManager) phone.getContext().getSystemService("netpolicy");
        this.mNetworkPolicyManager = networkPolicyManager;
        networkPolicyManager.registerSubscriptionCallback(r3);
        HandlerThread handlerThread = new HandlerThread("DcHandlerThread");
        this.mHandlerThread = handlerThread;
        handlerThread.start();
        Handler handler = new Handler(this.mHandlerThread.getLooper());
        this.mDcc = DcController.makeDcc(phone, this, dataServiceManager, handler.getLooper(), str);
        this.mDcTesterFailBringUpAll = new DcTesterFailBringUpAll(phone, handler);
        this.mDataConnectionTracker = this;
        registerForAllEvents();
        this.mApnObserver = new ApnChangeObserver();
        phone.getContext().getContentResolver().registerContentObserver(Telephony.Carriers.CONTENT_URI, true, this.mApnObserver);
        initApnContexts();
        addDefaultApnSettingsAsNeeded();
        this.mSettingsObserver = new SettingsObserver(phone.getContext(), this);
        registerSettingsObserver();
        ThrottleStatusChangedCallback throttleStatusChangedCallback = new ThrottleStatusChangedCallback();
        this.mThrottleStatusCallback = throttleStatusChangedCallback;
        dataThrottler.registerForThrottleStatusChanges(throttleStatusChangedCallback);
    }

    @VisibleForTesting
    public DcTracker() {
        this.isCleanupRequired = new AtomicBoolean(false);
        this.mRequestedApnType = 17;
        this.mPrioritySortedApnContexts = new ArrayList<>();
        this.mAllApnSettings = new ArrayList<>();
        this.mPreferredApn = null;
        this.mIsPsRestricted = false;
        this.mEmergencyApn = null;
        this.mIsDisposed = false;
        this.mIsProvisioning = false;
        this.mProvisioningUrl = null;
        this.mDataServiceBound = false;
        this.mProvisioningApnAlarmIntent = null;
        this.mProvisioningApnAlarmTag = (int) SystemClock.elapsedRealtime();
        this.mReplyAc = new AsyncChannel();
        this.mDataRoamingLeakageLog = new LocalLog(32);
        this.mApnSettingsInitializationLog = new LocalLog(32);
        this.mWatchdogTimeMs = 3600000;
        this.mWatchdog = false;
        this.mNrNsaAllUnmetered = false;
        this.mNrNsaMmwaveUnmetered = false;
        this.mNrNsaSub6Unmetered = false;
        this.mNrSaAllUnmetered = false;
        this.mNrSaMmwaveUnmetered = false;
        this.mNrSaSub6Unmetered = false;
        this.mNrNsaRoamingUnmetered = false;
        this.mLteEndcUsingUserDataForRrcDetection = false;
        this.mSubscriptionPlans = new ArrayList();
        this.mUnmeteredNetworkTypes = null;
        this.mCongestedNetworkTypes = null;
        this.mUnmeteredOverride = false;
        this.mCongestedOverride = false;
        this.mSimState = 0;
        this.mIntentReceiver = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                if (action.equals("android.intent.action.SCREEN_ON")) {
                    DcTracker.this.log("screen on");
                    DcTracker.this.mIsScreenOn = true;
                    DcTracker.this.stopNetStatPoll();
                    DcTracker.this.startNetStatPoll();
                    DcTracker.this.restartDataStallAlarm();
                } else if (action.equals("android.intent.action.SCREEN_OFF")) {
                    DcTracker.this.log("screen off");
                    DcTracker.this.mIsScreenOn = false;
                    DcTracker.this.stopNetStatPoll();
                    DcTracker.this.startNetStatPoll();
                    DcTracker.this.restartDataStallAlarm();
                } else if (action.equals(DcTracker.INTENT_DATA_STALL_ALARM)) {
                    DcTracker.this.onActionIntentDataStallAlarm(intent);
                } else if (action.equals(DcTracker.INTENT_PROVISIONING_APN_ALARM)) {
                    DcTracker.this.log("Provisioning apn alarm");
                    DcTracker.this.onActionIntentProvisioningApnAlarm(intent);
                } else if (action.equals("android.telephony.action.SIM_CARD_STATE_CHANGED") || action.equals("android.telephony.action.SIM_APPLICATION_STATE_CHANGED")) {
                    if (DcTracker.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1)) {
                        int intExtra = intent.getIntExtra("android.telephony.extra.SIM_STATE", 0);
                        DcTracker dcTracker = DcTracker.this;
                        dcTracker.sendMessage(dcTracker.obtainMessage(270391, intExtra, 0));
                    }
                } else if (!action.equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                    DcTracker dcTracker2 = DcTracker.this;
                    dcTracker2.log("onReceive: Unknown action=" + action);
                } else if (DcTracker.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1) && !intent.getBooleanExtra("android.telephony.extra.REBROADCAST_ON_UNLOCK", false) && SubscriptionManager.isValidSubscriptionId(intent.getIntExtra("android.telephony.extra.SUBSCRIPTION_INDEX", -1))) {
                    DcTracker.this.sendEmptyMessage(270390);
                }
            }
        };
        this.mPollNetStat = new Runnable() {
            public void run() {
                DcTracker.this.updateDataActivity();
                if (DcTracker.this.mIsScreenOn) {
                    DcTracker dcTracker = DcTracker.this;
                    dcTracker.mNetStatPollPeriod = Settings.Global.getInt(dcTracker.mResolver, "pdp_watchdog_poll_interval_ms", 1000);
                } else {
                    DcTracker dcTracker2 = DcTracker.this;
                    dcTracker2.mNetStatPollPeriod = Settings.Global.getInt(dcTracker2.mResolver, "pdp_watchdog_long_poll_interval_ms", 600000);
                }
                if (DcTracker.this.mNetStatPollEnabled) {
                    DcTracker.this.mDataConnectionTracker.postDelayed(this, (long) DcTracker.this.mNetStatPollPeriod);
                }
            }
        };
        this.mSubscriptionCallback = new NetworkPolicyManager.SubscriptionCallback() {
            public void onSubscriptionOverride(int i, int i2, int i3, int[] iArr) {
                Phone phone = DcTracker.this.mPhone;
                if (phone != null && phone.getSubId() == i) {
                    ArrayList arrayList = new ArrayList();
                    boolean z = false;
                    for (int valueOf : iArr) {
                        arrayList.add(Integer.valueOf(valueOf));
                    }
                    DcTracker.this.log("Subscription override: overrideMask=" + i2 + ", overrideValue=" + i3 + ", networkTypes=" + arrayList);
                    if (i2 == 1) {
                        DcTracker.this.mUnmeteredNetworkTypes = arrayList;
                        DcTracker dcTracker = DcTracker.this;
                        if (i3 != 0) {
                            z = true;
                        }
                        dcTracker.mUnmeteredOverride = z;
                        DcTracker.this.reevaluateUnmeteredConnections();
                    } else if (i2 == 2) {
                        DcTracker.this.mCongestedNetworkTypes = arrayList;
                        DcTracker dcTracker2 = DcTracker.this;
                        if (i3 != 0) {
                            z = true;
                        }
                        dcTracker2.mCongestedOverride = z;
                        DcTracker.this.reevaluateCongestedConnections();
                    }
                }
            }

            public void onSubscriptionPlansChanged(int i, SubscriptionPlan[] subscriptionPlanArr) {
                Phone phone = DcTracker.this.mPhone;
                if (phone != null && phone.getSubId() == i) {
                    DcTracker.this.mSubscriptionPlans = Arrays.asList(subscriptionPlanArr);
                    DcTracker dcTracker = DcTracker.this;
                    dcTracker.log("SubscriptionPlans changed: " + DcTracker.this.mSubscriptionPlans);
                    DcTracker.this.reevaluateUnmeteredConnections();
                }
            }
        };
        this.mAllDataDisconnectedRegistrants = new RegistrantList();
        this.mActivity = DctConstants.Activity.NONE;
        this.mState = DctConstants.State.IDLE;
        this.mNetStatPollEnabled = false;
        this.mDataStallTxRxSum = new TxRxSum(0, 0);
        this.mDataStallAlarmTag = (int) SystemClock.elapsedRealtime();
        this.mDataStallAlarmIntent = null;
        this.mNoRecvPollCount = 0;
        this.mDataStallNoRxEnabled = true;
        this.mFailFast = false;
        this.mInVoiceCall = false;
        this.mReconnectIntent = null;
        this.mAutoAttachOnCreationConfig = false;
        this.mAutoAttachEnabled = new AtomicBoolean(false);
        this.mIsScreenOn = true;
        this.mUniqueIdGenerator = new AtomicInteger(0);
        this.mDataConnections = new HashMap<>();
        this.mApnToDataConnectionId = new HashMap<>();
        this.mApnContexts = new ConcurrentHashMap<>();
        this.mApnContextsByType = new SparseArray<>();
        this.mLastDataProfileList = new ArrayList<>();
        this.mBandwidths = new ConcurrentHashMap<>();
        this.mConfigReady = false;
        this.mReregisterOnReconnectFailure = false;
        this.mCanSetPreferApn = false;
        this.mAttached = new AtomicBoolean(false);
        this.mHandoverCompletionMsgs = new HashMap();
        this.mLogTag = "DCT";
        this.mTelephonyManager = null;
        this.mAlarmManager = null;
        this.mPhone = null;
        this.mDataConnectionTracker = null;
        this.mSettingsObserver = new SettingsObserver((Context) null, this);
        this.mDataEnabledSettings = null;
        this.mTransportType = 0;
        this.mDataServiceManager = null;
        this.mDataThrottler = null;
        this.mThrottleStatusCallback = null;
    }

    public void registerServiceStateTrackerEvents() {
        this.mPhone.getServiceStateTracker().registerForDataConnectionAttached(this.mTransportType, this, 270352, (Object) null);
        this.mPhone.getServiceStateTracker().registerForDataConnectionDetached(this.mTransportType, this, 270345, (Object) null);
        this.mPhone.getServiceStateTracker().registerForDataRoamingOn(this, 270347, (Object) null);
        this.mPhone.getServiceStateTracker().registerForDataRoamingOff(this, 270348, (Object) null, true);
        this.mPhone.getServiceStateTracker().registerForPsRestrictedEnabled(this, 270358, (Object) null);
        this.mPhone.getServiceStateTracker().registerForPsRestrictedDisabled(this, 270359, (Object) null);
        this.mPhone.getServiceStateTracker().registerForDataRegStateOrRatChanged(this.mTransportType, this, 270377, (Object) null);
    }

    public void unregisterServiceStateTrackerEvents() {
        this.mPhone.getServiceStateTracker().unregisterForDataConnectionAttached(this.mTransportType, this);
        this.mPhone.getServiceStateTracker().unregisterForDataConnectionDetached(this.mTransportType, this);
        this.mPhone.getServiceStateTracker().unregisterForDataRoamingOn(this);
        this.mPhone.getServiceStateTracker().unregisterForDataRoamingOff(this);
        this.mPhone.getServiceStateTracker().unregisterForPsRestrictedEnabled(this);
        this.mPhone.getServiceStateTracker().unregisterForPsRestrictedDisabled(this);
        this.mPhone.getServiceStateTracker().unregisterForDataRegStateOrRatChanged(this.mTransportType, this);
        this.mPhone.getServiceStateTracker().unregisterForAirplaneModeChanged(this);
    }

    private void registerForAllEvents() {
        if (this.mTransportType == 1) {
            this.mPhone.mCi.registerForAvailable(this, 270337, (Object) null);
            this.mPhone.mCi.registerForOffOrNotAvailable(this, 270342, (Object) null);
            this.mPhone.mCi.registerForPcoData(this, 270381, (Object) null);
        }
        this.mPhone.getCallTracker().registerForVoiceCallEnded(this, 270344, (Object) null);
        this.mPhone.getCallTracker().registerForVoiceCallStarted(this, 270343, (Object) null);
        this.mPhone.getDisplayInfoController().registerForTelephonyDisplayInfoChanged(this, 270388, (Object) null);
        registerServiceStateTrackerEvents();
        this.mDataServiceManager.registerForServiceBindingChanged(this, 270385, (Object) null);
        this.mDataServiceManager.registerForApnUnthrottled(this, 270392);
    }

    public void dispose() {
        log("DCT.dispose");
        if (this.mProvisionBroadcastReceiver != null) {
            this.mPhone.getContext().unregisterReceiver(this.mProvisionBroadcastReceiver);
            this.mProvisionBroadcastReceiver = null;
        }
        ProgressDialog progressDialog = this.mProvisioningSpinner;
        if (progressDialog != null) {
            progressDialog.dismiss();
            this.mProvisioningSpinner = null;
        }
        cleanUpAllConnectionsInternal(true, (String) null);
        this.mIsDisposed = true;
        this.mPhone.getContext().unregisterReceiver(this.mIntentReceiver);
        this.mSettingsObserver.unobserve();
        this.mNetworkPolicyManager.unregisterSubscriptionCallback(this.mSubscriptionCallback);
        this.mDcTesterFailBringUpAll.dispose();
        this.mPhone.getContext().getContentResolver().unregisterContentObserver(this.mApnObserver);
        this.mApnContexts.clear();
        this.mApnContextsByType.clear();
        this.mPrioritySortedApnContexts.clear();
        unregisterForAllEvents();
        destroyDataConnections();
    }

    @VisibleForTesting
    public void stopHandlerThread() {
        this.mHandlerThread.quit();
    }

    private void unregisterForAllEvents() {
        if (this.mTransportType == 1) {
            this.mPhone.mCi.unregisterForAvailable(this);
            this.mPhone.mCi.unregisterForOffOrNotAvailable(this);
            this.mPhone.mCi.unregisterForPcoData(this);
        }
        this.mPhone.getCallTracker().unregisterForVoiceCallEnded(this);
        this.mPhone.getCallTracker().unregisterForVoiceCallStarted(this);
        this.mPhone.getDisplayInfoController().unregisterForTelephonyDisplayInfoChanged(this);
        unregisterServiceStateTrackerEvents();
        this.mDataServiceManager.unregisterForServiceBindingChanged(this);
        this.mDataEnabledSettings.unregisterForDataEnabledChanged(this);
        this.mDataEnabledSettings.unregisterForDataEnabledOverrideChanged(this);
        this.mDataServiceManager.unregisterForApnUnthrottled(this);
    }

    private void reevaluateDataConnections() {
        for (DataConnection reevaluateRestrictedState : this.mDataConnections.values()) {
            reevaluateRestrictedState.reevaluateRestrictedState();
        }
    }

    public long getSubId() {
        return (long) this.mPhone.getSubId();
    }

    public DctConstants.Activity getActivity() {
        return this.mActivity;
    }

    private void setActivity(DctConstants.Activity activity) {
        log("setActivity = " + activity);
        this.mActivity = activity;
        this.mPhone.notifyDataActivity();
    }

    public void requestNetwork(NetworkRequest networkRequest, int i, Message message) {
        if (i == 2 || message == null) {
            ApnContext apnContext = this.mApnContextsByType.get(ApnContext.getApnTypeFromNetworkRequest(networkRequest));
            if (apnContext != null) {
                apnContext.requestNetwork(networkRequest, i, message);
                return;
            }
            return;
        }
        throw new RuntimeException("request network with normal type request type but passing handover complete message.");
    }

    public void releaseNetwork(NetworkRequest networkRequest, int i) {
        ApnContext apnContext = this.mApnContextsByType.get(ApnContext.getApnTypeFromNetworkRequest(networkRequest));
        if (apnContext != null) {
            apnContext.releaseNetwork(networkRequest, i);
        }
    }

    /* access modifiers changed from: private */
    public void setRadio(boolean z) {
        try {
            ITelephony.Stub.asInterface(TelephonyFrameworkInitializer.getTelephonyServiceManager().getTelephonyServiceRegisterer().get()).setRadio(z);
        } catch (Exception unused) {
        }
    }

    private class ProvisionNotificationBroadcastReceiver extends BroadcastReceiver {
        private final String mNetworkOperator;
        private final String mProvisionUrl;

        public ProvisionNotificationBroadcastReceiver(String str, String str2) {
            this.mNetworkOperator = str2;
            this.mProvisionUrl = str;
        }

        private void setEnableFailFastMobileData(int i) {
            DcTracker dcTracker = DcTracker.this;
            dcTracker.sendMessage(dcTracker.obtainMessage(270372, i, 0));
        }

        private void enableMobileProvisioning() {
            Message obtainMessage = DcTracker.this.obtainMessage(270373);
            Bundle bundle = new Bundle(1);
            bundle.putString("provisioningUrl", this.mProvisionUrl);
            obtainMessage.setData(bundle);
            DcTracker.this.sendMessage(obtainMessage);
        }

        public void onReceive(Context context, Intent intent) {
            if (DcTracker.this.mPhone.getPhoneId() == intent.getIntExtra(DcTracker.EXTRA_PROVISION_PHONE_ID, -1)) {
                DcTracker.this.log("onReceive : ProvisionNotificationBroadcastReceiver");
                DcTracker.this.mProvisioningSpinner = new ProgressDialog(context);
                DcTracker.this.mProvisioningSpinner.setTitle(this.mNetworkOperator);
                DcTracker.this.mProvisioningSpinner.setMessage(context.getText(17040689));
                DcTracker.this.mProvisioningSpinner.setIndeterminate(true);
                DcTracker.this.mProvisioningSpinner.setCancelable(true);
                DcTracker.this.mProvisioningSpinner.getWindow().setType(TelephonyProto.TelephonyEvent.RilSetupDataCallResponse.RilDataCallFailCause.PDP_FAIL_MIP_FA_VJ_HEADER_COMPRESSION_UNAVAILABLE);
                DcTracker.this.mProvisioningSpinner.show();
                DcTracker dcTracker = DcTracker.this;
                dcTracker.sendMessageDelayed(dcTracker.obtainMessage(270378, dcTracker.mProvisioningSpinner), 120000);
                DcTracker.this.setRadio(true);
                setEnableFailFastMobileData(1);
                enableMobileProvisioning();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        if (this.mPhone != null) {
            log("finalize");
        }
    }

    private void initApnContexts() {
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        initApnContexts(carrierConfigManager != null ? carrierConfigManager.getConfigForSubId(this.mPhone.getSubId()) : null);
    }

    private void initApnContexts(PersistableBundle persistableBundle) {
        if (!this.mTelephonyManager.isDataCapable()) {
            log("initApnContexts: isDataCapable == false.  No Apn Contexts loaded");
            return;
        }
        log("initApnContexts: E");
        for (ApnConfigType next : new ApnConfigTypeRepository(persistableBundle).getTypes()) {
            ApnContext apnContext = new ApnContext(this.mPhone, next.getType(), this.mLogTag, this, next.getPriority());
            int apnTypesBitmaskFromString = ApnSetting.getApnTypesBitmaskFromString(apnContext.getApnType());
            this.mPrioritySortedApnContexts.add(apnContext);
            this.mApnContexts.put(apnContext.getApnType(), apnContext);
            this.mApnContextsByType.put(apnTypesBitmaskFromString, apnContext);
            this.mPhone.notifyDataConnection(new PreciseDataConnectionState.Builder().setTransportType(this.mTransportType).setState(0).setApnSetting(new ApnSetting.Builder().setApnTypeBitmask(apnTypesBitmaskFromString).buildWithoutCheck()).setNetworkType(getDataRat()).build());
            log("initApnContexts: apnContext=" + ApnSetting.getApnTypeString(next.getType()));
        }
        this.mPrioritySortedApnContexts.sort(new DcTracker$$ExternalSyntheticLambda7());
        logSortedApnContexts();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$initApnContexts$0(ApnContext apnContext, ApnContext apnContext2) {
        return apnContext2.getPriority() - apnContext.getPriority();
    }

    private void sortApnContextByPriority() {
        if (!this.mTelephonyManager.isDataCapable()) {
            log("sortApnContextByPriority: isDataCapable == false.  No Apn Contexts loaded");
            return;
        }
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        PersistableBundle configForSubId = carrierConfigManager != null ? carrierConfigManager.getConfigForSubId(this.mPhone.getSubId()) : null;
        log("sortApnContextByPriority: E");
        for (ApnConfigType next : new ApnConfigTypeRepository(configForSubId).getTypes()) {
            if (this.mApnContextsByType.contains(next.getType())) {
                this.mApnContextsByType.get(next.getType()).setPriority(next.getPriority());
            }
        }
        ArrayList<ApnContext> arrayList = new ArrayList<>(this.mPrioritySortedApnContexts);
        arrayList.sort(new DcTracker$$ExternalSyntheticLambda4());
        this.mPrioritySortedApnContexts = arrayList;
        logSortedApnContexts();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$sortApnContextByPriority$1(ApnContext apnContext, ApnContext apnContext2) {
        return apnContext2.getPriority() - apnContext.getPriority();
    }

    public LinkProperties getLinkProperties(String str) {
        DataConnection dataConnection;
        ApnContext apnContext = this.mApnContexts.get(str);
        if (apnContext == null || (dataConnection = apnContext.getDataConnection()) == null) {
            log("return new LinkProperties");
            return new LinkProperties();
        }
        log("return link properties for " + str);
        return dataConnection.getLinkProperties();
    }

    public NetworkCapabilities getNetworkCapabilities(String str) {
        DataConnection dataConnection;
        ApnContext apnContext = this.mApnContexts.get(str);
        if (apnContext == null || (dataConnection = apnContext.getDataConnection()) == null) {
            log("return new NetworkCapabilities");
            return new NetworkCapabilities();
        }
        log("get active pdp is not null, return NetworkCapabilities for " + str);
        return dataConnection.getNetworkCapabilities();
    }

    public String[] getActiveApnTypes() {
        log("get all active apn types");
        ArrayList arrayList = new ArrayList();
        for (ApnContext next : this.mApnContexts.values()) {
            if (this.mAttached.get() && next.isReady()) {
                arrayList.add(next.getApnType());
            }
        }
        return (String[]) arrayList.toArray(new String[0]);
    }

    public String[] getConnectedApnTypes() {
        return (String[]) this.mApnContexts.values().stream().filter(new DcTracker$$ExternalSyntheticLambda1()).map(new DcTracker$$ExternalSyntheticLambda2()).toArray(new DcTracker$$ExternalSyntheticLambda3());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getConnectedApnTypes$2(ApnContext apnContext) {
        return apnContext.getState() == DctConstants.State.CONNECTED;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String[] lambda$getConnectedApnTypes$3(int i) {
        return new String[i];
    }

    @VisibleForTesting
    public Collection<ApnContext> getApnContexts() {
        return this.mPrioritySortedApnContexts;
    }

    public ApnSetting getActiveApnSetting(String str) {
        ApnContext apnContext = this.mApnContexts.get(str);
        if (apnContext != null) {
            return apnContext.getApnSetting();
        }
        return null;
    }

    public String getActiveApnString(String str) {
        ApnSetting activeApnSetting = getActiveApnSetting(str);
        if (activeApnSetting != null) {
            return activeApnSetting.getApnName();
        }
        return null;
    }

    public DctConstants.State getState(String str) {
        DctConstants.State state = DctConstants.State.IDLE;
        int apnTypesBitmaskFromString = ApnSetting.getApnTypesBitmaskFromString(str);
        for (DataConnection next : this.mDataConnections.values()) {
            ApnSetting apnSetting = next.getApnSetting();
            if (apnSetting != null && apnSetting.canHandleType(apnTypesBitmaskFromString)) {
                if (next.isActive()) {
                    state = getBetterConnectionState(state, DctConstants.State.CONNECTED);
                } else if (next.isActivating()) {
                    state = getBetterConnectionState(state, DctConstants.State.CONNECTING);
                } else if (next.isInactive()) {
                    state = getBetterConnectionState(state, DctConstants.State.IDLE);
                } else if (next.isDisconnecting()) {
                    state = getBetterConnectionState(state, DctConstants.State.DISCONNECTING);
                }
            }
        }
        return state;
    }

    private static DctConstants.State getBetterConnectionState(DctConstants.State state, DctConstants.State state2) {
        DctConstants.State[] stateArr = DATA_CONNECTION_STATE_PRIORITIES;
        return ArrayUtils.indexOf(stateArr, state) >= ArrayUtils.indexOf(stateArr, state2) ? state : state2;
    }

    private boolean isProvisioningApn(String str) {
        ApnContext apnContext = this.mApnContexts.get(str);
        if (apnContext != null) {
            return apnContext.isProvisioningApn();
        }
        return false;
    }

    private void onDataConnectionDetached() {
        log("onDataConnectionDetached: stop polling and notify detached");
        stopNetStatPoll();
        stopDataStallAlarm();
        this.mAttached.set(false);
    }

    private void onDataConnectionAttached() {
        log("onDataConnectionAttached");
        this.mAttached.set(true);
        if (isAnyDataConnected()) {
            log("onDataConnectionAttached: start polling notify attached");
            startNetStatPoll();
            startDataStallAlarm(false);
        }
        if (this.mAutoAttachOnCreationConfig) {
            this.mAutoAttachEnabled.set(true);
        }
        setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_DATA_ATTACHED, RetryFailures.ALWAYS);
    }

    public boolean isDataAllowed(DataConnectionReasons dataConnectionReasons) {
        return isDataAllowed((ApnContext) null, 1, dataConnectionReasons);
    }

    public boolean isDataAllowed(ApnContext apnContext, int i, DataConnectionReasons dataConnectionReasons) {
        boolean z;
        ApnContext apnContext2 = apnContext;
        int i2 = i;
        DataConnectionReasons dataConnectionReasons2 = dataConnectionReasons;
        DataConnectionReasons dataConnectionReasons3 = new DataConnectionReasons();
        int apnTypeBitmask = apnContext2 != null ? apnContext.getApnTypeBitmask() : 0;
        boolean isInternalDataEnabled = this.mDataEnabledSettings.isInternalDataEnabled();
        boolean z2 = this.mAttached.get();
        boolean desiredPowerState = this.mPhone.getServiceStateTracker().getDesiredPowerState();
        boolean powerStateFromCarrier = this.mPhone.getServiceStateTracker().getPowerStateFromCarrier();
        int dataRat = getDataRat();
        if (dataRat == 18) {
            desiredPowerState = true;
            powerStateFromCarrier = true;
        }
        boolean isValidSubscriptionId = SubscriptionManager.isValidSubscriptionId(SubscriptionManager.getDefaultDataSubscriptionId());
        boolean z3 = apnContext2 == null || ApnSettingUtils.isMeteredApnType(apnTypeBitmask, this.mPhone);
        PhoneConstants.State state = PhoneConstants.State.IDLE;
        if (this.mPhone.getCallTracker() != null) {
            state = this.mPhone.getCallTracker().getState();
        }
        PhoneConstants.State state2 = state;
        if (apnContext2 == null || apnTypeBitmask != 512 || !apnContext.isConnectable()) {
            if (apnContext2 != null && !apnContext.isConnectable()) {
                DctConstants.State state3 = apnContext.getState();
                if (state3 == DctConstants.State.CONNECTED) {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DATA_ALREADY_CONNECTED);
                } else if (state3 == DctConstants.State.DISCONNECTING) {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DATA_IS_DISCONNECTING);
                } else if (state3 == DctConstants.State.CONNECTING) {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DATA_IS_CONNECTING);
                } else {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.APN_NOT_CONNECTABLE);
                }
            }
            if (((apnContext2 != null && apnTypeBitmask == 17) || apnTypeBitmask == 16384 || apnTypeBitmask == 256) && this.mPhone.getAccessNetworksManager().isInLegacyMode() && dataRat == 18) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.ON_IWLAN);
            }
            if (!(apnContext2 == null || apnTypeBitmask != 16384 || dataRat == 20)) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.NOT_ON_NR);
            }
            if (shouldRestrictDataForEcbm() || this.mPhone.isInEmergencyCall()) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.IN_ECBM);
            }
            if (!z2 && !shouldAutoAttach() && i2 != 2) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.NOT_ATTACHED);
            }
            if (this.mPhone.getSubId() == -1) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.SIM_NOT_READY);
            }
            if (state2 != PhoneConstants.State.IDLE && !this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed()) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.INVALID_PHONE_STATE);
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.CONCURRENT_VOICE_DATA_NOT_ALLOWED);
            }
            if (!isInternalDataEnabled) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.INTERNAL_DATA_DISABLED);
            }
            if (!isValidSubscriptionId) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DEFAULT_DATA_UNSELECTED);
            }
            if (this.mPhone.getServiceState().getDataRoaming() && !getDataRoamingEnabled()) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.ROAMING_DISABLED);
            }
            if (this.mIsPsRestricted) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.PS_RESTRICTED);
            }
            if (!desiredPowerState) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.UNDESIRED_POWER_STATE);
            }
            if (!powerStateFromCarrier) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.RADIO_DISABLED_BY_CARRIER);
            }
            if (!this.mDataServiceBound) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DATA_SERVICE_NOT_READY);
            }
            if (apnContext2 != null) {
                if (this.mPhone.getAccessNetworksManager().getPreferredTransport(apnContext.getApnTypeBitmask()) == -1) {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DISABLED_BY_QNS);
                } else if (this.mTransportType != this.mPhone.getAccessNetworksManager().getPreferredTransport(apnContext.getApnTypeBitmask())) {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.ON_OTHER_TRANSPORT);
                }
                if (!(this.mTransportType == this.mPhone.getAccessNetworksManager().getCurrentTransport(apnContext.getApnTypeBitmask()) || i2 == 2)) {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.ON_OTHER_TRANSPORT);
                }
                if (this.mDataThrottler.getRetryTime(apnContext.getApnTypeBitmask()) > SystemClock.elapsedRealtime()) {
                    dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DATA_THROTTLED);
                }
            }
            if (apnContext2 == null) {
                z = this.mDataEnabledSettings.isDataEnabled();
            } else {
                z = this.mDataEnabledSettings.isDataEnabled(apnTypeBitmask);
            }
            if (!z) {
                dataConnectionReasons3.add(DataConnectionReasons.DataDisallowedReasonType.DATA_DISABLED);
            }
            if (!dataConnectionReasons3.containsHardDisallowedReasons()) {
                if (!dataConnectionReasons3.allowed()) {
                    int i3 = this.mTransportType;
                    if (i3 == 2) {
                        dataConnectionReasons3.add(DataConnectionReasons.DataAllowedReasonType.UNMETERED_APN);
                    } else if (i3 == 1 && !z3 && apnTypeBitmask != 17 && apnTypeBitmask != 16384) {
                        dataConnectionReasons3.add(DataConnectionReasons.DataAllowedReasonType.UNMETERED_APN);
                    }
                    if (apnContext2 != null && apnContext2.hasRestrictedRequests(true) && !apnContext.getApnType().equals("enterprise") && !dataConnectionReasons3.allowed()) {
                        dataConnectionReasons3.add(DataConnectionReasons.DataAllowedReasonType.RESTRICTED_REQUEST);
                    }
                } else {
                    dataConnectionReasons3.add(DataConnectionReasons.DataAllowedReasonType.NORMAL);
                }
                if (dataConnectionReasons2 != null) {
                    dataConnectionReasons2.copyFrom(dataConnectionReasons3);
                }
                return dataConnectionReasons3.allowed();
            } else if (dataConnectionReasons2 == null) {
                return false;
            } else {
                dataConnectionReasons2.copyFrom(dataConnectionReasons3);
                return false;
            }
        } else {
            if (dataConnectionReasons2 != null) {
                dataConnectionReasons2.add(DataConnectionReasons.DataAllowedReasonType.EMERGENCY_APN);
            }
            return true;
        }
    }

    /* access modifiers changed from: protected */
    public void setupDataOnAllConnectableApns(String str, RetryFailures retryFailures) {
        StringBuilder sb = new StringBuilder(120);
        Iterator<ApnContext> it = this.mPrioritySortedApnContexts.iterator();
        while (it.hasNext()) {
            ApnContext next = it.next();
            sb.append(next.getApnType());
            sb.append(":[state=");
            sb.append(next.getState());
            sb.append(",enabled=");
            sb.append(next.isEnabled());
            sb.append("] ");
        }
        log("setupDataOnAllConnectableApns: " + str + " " + sb);
        Iterator<ApnContext> it2 = this.mPrioritySortedApnContexts.iterator();
        while (it2.hasNext()) {
            setupDataOnConnectableApn(it2.next(), str, retryFailures);
        }
    }

    /* access modifiers changed from: protected */
    public void setupDataOnConnectableApn(ApnContext apnContext, String str, RetryFailures retryFailures) {
        if (apnContext.getState() == DctConstants.State.FAILED || apnContext.getState() == DctConstants.State.RETRYING) {
            if (retryFailures == RetryFailures.ALWAYS) {
                apnContext.releaseDataConnection(str);
            } else if (!apnContext.isConcurrentVoiceAndDataAllowed() && this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed()) {
                apnContext.releaseDataConnection(str);
            }
        }
        if (apnContext.isConnectable()) {
            log("isConnectable() call trySetupData");
            apnContext.setReason(str);
            trySetupData(apnContext, 1, (Message) null);
        }
    }

    private boolean shouldRestrictDataForEcbm() {
        boolean isInEcm = this.mPhone.isInEcm();
        boolean z = this.mPhone.getImsPhone() != null && this.mPhone.getImsPhone().isInImsEcm();
        log("shouldRestrictDataForEcbm: isInEcm=" + isInEcm + " isInImsEcm=" + z);
        if (!isInEcm || z) {
            return false;
        }
        return true;
    }

    private boolean isHandoverPending(int i) {
        List list = this.mHandoverCompletionMsgs.get(Integer.valueOf(i));
        return list != null && list.size() > 0;
    }

    private void trySetupData(ApnContext apnContext, int i, Message message) {
        if (message != null) {
            addHandoverCompleteMsg(message, apnContext.getApnTypeBitmask());
        }
        if (this.mPhone.getSimulatedRadioControl() != null) {
            log("trySetupData: X We're on the simulator; assuming connected retValue=true");
            return;
        }
        DataConnectionReasons dataConnectionReasons = new DataConnectionReasons();
        boolean isDataAllowed = isDataAllowed(apnContext, i, dataConnectionReasons);
        String str = "trySetupData for APN type " + apnContext.getApnType() + ", reason: " + apnContext.getReason() + ", requestType=" + requestTypeToString(i) + ". " + dataConnectionReasons.toString();
        if (dataConnectionReasons.contains(DataConnectionReasons.DataDisallowedReasonType.DISABLED_BY_QNS) || dataConnectionReasons.contains(DataConnectionReasons.DataDisallowedReasonType.ON_OTHER_TRANSPORT)) {
            str = (str + ", current transport=" + AccessNetworkConstants.transportTypeToString(this.mPhone.getAccessNetworksManager().getCurrentTransport(apnContext.getApnTypeBitmask()))) + ", preferred transport=" + AccessNetworkConstants.transportTypeToString(this.mPhone.getAccessNetworksManager().getPreferredTransport(apnContext.getApnTypeBitmask()));
        }
        log(str);
        ApnContext.requestLog(apnContext, str);
        if (!isDataAllowed) {
            StringBuilder sb = new StringBuilder();
            sb.append("trySetupData failed. apnContext = [type=" + apnContext.getApnType() + ", mState=" + apnContext.getState() + ", apnEnabled=" + apnContext.isEnabled() + ", mDependencyMet=" + apnContext.isDependencyMet() + "] ");
            if (!this.mDataEnabledSettings.isDataEnabled()) {
                sb.append("isDataEnabled() = false. " + this.mDataEnabledSettings);
            }
            if (!dataConnectionReasons.contains(DataConnectionReasons.DataDisallowedReasonType.DATA_IS_DISCONNECTING) || !isHandoverPending(apnContext.getApnTypeBitmask())) {
                if (apnContext.getState() == DctConstants.State.RETRYING) {
                    apnContext.setState(DctConstants.State.FAILED);
                    sb.append(" Stop retrying.");
                }
                log(sb.toString());
                ApnContext.requestLog(apnContext, sb.toString());
                if (i == 2) {
                    sendHandoverCompleteMessages(apnContext.getApnTypeBitmask(), false, dataConnectionReasons.contains(DataConnectionReasons.DataDisallowedReasonType.ON_OTHER_TRANSPORT));
                    return;
                }
                return;
            }
            log("Data is disconnecting. Will retry handover later.");
            return;
        }
        if (apnContext.getState() == DctConstants.State.FAILED) {
            log("trySetupData: make a FAILED ApnContext IDLE so its reusable");
            ApnContext.requestLog(apnContext, "trySetupData: make a FAILED ApnContext IDLE so its reusable");
            apnContext.setState(DctConstants.State.IDLE);
        }
        int dataRat = getDataRat();
        if (dataRat == 0 && this.mPhone.getServiceState().getState() == 0) {
            dataRat = getVoiceRat();
        }
        log("service state=" + this.mPhone.getServiceState());
        apnContext.setConcurrentVoiceAndDataAllowed(this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed());
        if (apnContext.getState() == DctConstants.State.IDLE) {
            ArrayList<ApnSetting> buildWaitingApns = buildWaitingApns(apnContext.getApnType(), dataRat);
            if (buildWaitingApns.isEmpty()) {
                log("trySetupData: X No APN found retValue=false");
                ApnContext.requestLog(apnContext, "trySetupData: X No APN found retValue=false");
                if (i == 2) {
                    sendHandoverCompleteMessages(apnContext.getApnTypeBitmask(), false, false);
                    return;
                }
                return;
            }
            apnContext.setWaitingApns(buildWaitingApns);
            log("trySetupData: Create from mAllApnSettings : " + apnListToString(this.mAllApnSettings));
        }
        if (!setupData(apnContext, dataRat, i) && i == 2) {
            sendHandoverCompleteMessages(apnContext.getApnTypeBitmask(), false, false);
        }
    }

    public void cleanUpAllConnections(String str) {
        log("cleanUpAllConnections");
        Message obtainMessage = obtainMessage(270365);
        obtainMessage.obj = str;
        sendMessage(obtainMessage);
    }

    private boolean cleanUpAllConnectionsInternal(boolean z, String str) {
        log("cleanUpAllConnectionsInternal: detach=" + z + " reason=" + str);
        boolean z2 = false;
        boolean z3 = !TextUtils.isEmpty(str) && (str.equals(PhoneInternalInterface.REASON_DATA_SPECIFIC_DISABLED) || str.equals(PhoneInternalInterface.REASON_ROAMING_ON) || str.equals(PhoneInternalInterface.REASON_CARRIER_ACTION_DISABLE_METERED_APN));
        for (ApnContext next : this.mApnContexts.values()) {
            if (!str.equals(PhoneInternalInterface.REASON_SINGLE_PDN_ARBITRATION) || !next.getApnType().equals("ims")) {
                if (shouldCleanUpConnection(next, z3, str.equals(PhoneInternalInterface.REASON_SINGLE_PDN_ARBITRATION))) {
                    if (!next.isDisconnected()) {
                        z2 = true;
                    }
                    next.setReason(str);
                    cleanUpConnectionInternal(z, 2, next);
                } else {
                    log("cleanUpAllConnectionsInternal: APN type " + next.getApnType() + " shouldn't be cleaned up.");
                }
            }
        }
        stopNetStatPoll();
        stopDataStallAlarm();
        this.mRequestedApnType = 17;
        if (areAllDataDisconnected()) {
            notifyAllDataDisconnected();
        }
        return z2;
    }

    /* access modifiers changed from: package-private */
    public boolean shouldCleanUpConnection(ApnContext apnContext, boolean z, boolean z2) {
        if (apnContext == null) {
            return false;
        }
        ApnSetting apnSetting = apnContext.getApnSetting();
        if ((apnSetting != null && z2) || !z) {
            return true;
        }
        if (apnSetting == null || !ApnSettingUtils.isMetered(apnSetting, this.mPhone)) {
            return false;
        }
        boolean dataRoaming = this.mPhone.getServiceState().getDataRoaming();
        boolean z3 = !getDataRoamingEnabled();
        if ((!this.mDataEnabledSettings.isDataEnabled(apnSetting.getApnTypeBitmask())) || (dataRoaming && z3)) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: package-private */
    public void cleanUpConnection(ApnContext apnContext) {
        log("cleanUpConnection: apnContext=" + apnContext);
        Message obtainMessage = obtainMessage(270360);
        obtainMessage.arg2 = 0;
        obtainMessage.obj = apnContext;
        sendMessage(obtainMessage);
    }

    private void cleanUpConnectionInternal(boolean z, int i, ApnContext apnContext) {
        boolean z2;
        if (apnContext == null) {
            log("cleanUpConnectionInternal: apn context is null");
            return;
        }
        DataConnection dataConnection = apnContext.getDataConnection();
        ApnContext.requestLog(apnContext, "cleanUpConnectionInternal: detach=" + z + " reason=" + apnContext.getReason());
        if (z) {
            String str = "";
            if (apnContext.isDisconnected()) {
                apnContext.releaseDataConnection(str);
            } else if (dataConnection == null) {
                apnContext.setState(DctConstants.State.IDLE);
                ApnContext.requestLog(apnContext, "cleanUpConnectionInternal: connected, bug no dc");
            } else if (apnContext.getState() != DctConstants.State.DISCONNECTING) {
                if (!"dun".equals(apnContext.getApnType()) || !ServiceState.isCdma(getDataRat())) {
                    z2 = false;
                } else {
                    log("cleanUpConnectionInternal: disconnectAll DUN connection");
                    z2 = true;
                }
                int connectionGeneration = apnContext.getConnectionGeneration();
                StringBuilder sb = new StringBuilder();
                sb.append("cleanUpConnectionInternal: tearing down");
                if (z2) {
                    str = " all";
                }
                sb.append(str);
                sb.append(" using gen#");
                sb.append(connectionGeneration);
                String sb2 = sb.toString();
                log(sb2 + "apnContext=" + apnContext);
                ApnContext.requestLog(apnContext, sb2);
                Message obtainMessage = obtainMessage(270351, new Pair(apnContext, Integer.valueOf(connectionGeneration)));
                if (z2 || i == 3) {
                    dataConnection.tearDownAll(apnContext.getReason(), i, obtainMessage);
                } else {
                    dataConnection.tearDown(apnContext, apnContext.getReason(), obtainMessage);
                }
                apnContext.setState(DctConstants.State.DISCONNECTING);
            }
        } else {
            if (dataConnection != null) {
                dataConnection.reset();
            }
            apnContext.setState(DctConstants.State.IDLE);
            apnContext.setDataConnection((DataConnection) null);
        }
        sendHandoverCompleteMessages(apnContext.getApnTypeBitmask(), false, false);
        if (dataConnection != null) {
            cancelReconnect(apnContext);
        }
        log(("cleanUpConnectionInternal: X detach=" + z + " reason=" + apnContext.getReason()) + " apnContext=" + apnContext + " dc=" + apnContext.getDataConnection());
    }

    private Cursor getPreferredApnCursor(int i) {
        if (i != -1) {
            return this.mPhone.getContext().getContentResolver().query(Uri.withAppendedPath(PREFERAPN_NO_UPDATE_URI_USING_SUBID, String.valueOf(i)), (String[]) null, (String) null, (String[]) null, "name ASC");
        }
        return null;
    }

    private ApnSetting getPreferredApnFromDB() {
        Cursor preferredApnCursor = getPreferredApnCursor(this.mPhone.getSubId());
        ApnSetting apnSetting = null;
        if (preferredApnCursor != null) {
            if (preferredApnCursor.getCount() > 0) {
                preferredApnCursor.moveToFirst();
                apnSetting = ApnSetting.makeApnSetting(preferredApnCursor);
            }
            preferredApnCursor.close();
        }
        return apnSetting;
    }

    private void setDefaultPreferredApnIfNeeded() {
        String string = getCarrierConfig().getString("default_preferred_apn_name_string");
        if (!TextUtils.isEmpty(string) && getPreferredApnFromDB() == null) {
            ContentResolver contentResolver = this.mPhone.getContext().getContentResolver();
            Cursor query = contentResolver.query(Uri.withAppendedPath(Telephony.Carriers.SIM_APN_URI, "filtered/subId/" + this.mPhone.getSubId()), (String[]) null, "apn = \"" + string + "\" AND " + "edited" + " = " + 0, (String[]) null, "_id");
            ApnSetting apnSetting = null;
            if (query != null) {
                if (query.getCount() > 0 && query.moveToFirst()) {
                    apnSetting = ApnSetting.makeApnSetting(query);
                }
                query.close();
            }
            if (apnSetting != null && apnSetting.canHandleType(this.mRequestedApnType)) {
                log("setDefaultPreferredApnIfNeeded: For APN type " + ApnSetting.getApnTypeString(this.mRequestedApnType) + " found default apnSetting " + apnSetting);
                setPreferredApn(apnSetting.getId(), true);
            }
        }
    }

    @VisibleForTesting
    public boolean isPreferredApnUserEdited() {
        Cursor preferredApnCursor = getPreferredApnCursor(this.mPhone.getSubId());
        boolean z = false;
        if (preferredApnCursor != null) {
            if (preferredApnCursor.getCount() > 0 && preferredApnCursor.moveToFirst() && preferredApnCursor.getInt(preferredApnCursor.getColumnIndexOrThrow("edited")) == 1) {
                z = true;
            }
            preferredApnCursor.close();
        }
        return z;
    }

    @VisibleForTesting
    public ArrayList<ApnSetting> fetchDunApns() {
        if (this.mPhone.getServiceState().getRoaming() && !isPreferredApnUserEdited() && getCarrierConfig().getBoolean("disable_dun_apn_while_roaming_with_preset_apn_bool")) {
            return new ArrayList<>(0);
        }
        int dataRat = getDataRat();
        ArrayList arrayList = new ArrayList();
        ArrayList<ApnSetting> arrayList2 = new ArrayList<>();
        if (arrayList.isEmpty() && !ArrayUtils.isEmpty(this.mAllApnSettings)) {
            Iterator<ApnSetting> it = this.mAllApnSettings.iterator();
            while (it.hasNext()) {
                ApnSetting next = it.next();
                if (next.canHandleType(8)) {
                    arrayList.add(next);
                }
            }
        }
        int preferredApnSetId = getPreferredApnSetId();
        ApnSetting preferredApnFromDB = getPreferredApnFromDB();
        Iterator it2 = arrayList.iterator();
        while (it2.hasNext()) {
            ApnSetting apnSetting = (ApnSetting) it2.next();
            if (apnSetting.canSupportNetworkType(ServiceState.rilRadioTechnologyToNetworkType(dataRat)) && preferredApnSetId == apnSetting.getApnSetId()) {
                if (preferredApnFromDB == null || !preferredApnFromDB.equals(apnSetting)) {
                    arrayList2.add(apnSetting);
                } else {
                    arrayList2.add(0, apnSetting);
                }
            }
        }
        return arrayList2;
    }

    private int getPreferredApnSetId() {
        ContentResolver contentResolver = this.mPhone.getContext().getContentResolver();
        Uri uri = Telephony.Carriers.CONTENT_URI;
        Cursor query = contentResolver.query(Uri.withAppendedPath(uri, "preferapnset/subId/" + this.mPhone.getSubId()), new String[]{"apn_set_id"}, (String) null, (String[]) null, (String) null);
        int i = 0;
        if (query == null) {
            loge("getPreferredApnSetId: cursor is null");
            return 0;
        }
        if (query.getCount() < 1) {
            loge("getPreferredApnSetId: no APNs found");
        } else {
            query.moveToFirst();
            i = query.getInt(0);
        }
        if (!query.isClosed()) {
            query.close();
        }
        return i;
    }

    public boolean hasMatchedTetherApnSetting() {
        ArrayList<ApnSetting> fetchDunApns = fetchDunApns();
        log("hasMatchedTetherApnSetting: APNs=" + fetchDunApns);
        return fetchDunApns.size() > 0;
    }

    public DataConnection getDataConnectionByContextId(int i) {
        return this.mDcc.getActiveDcByCid(i);
    }

    public DataConnection getDataConnectionByApnType(String str) {
        ApnContext apnContext = this.mApnContexts.get(str);
        if (apnContext != null) {
            return apnContext.getDataConnection();
        }
        return null;
    }

    @VisibleForTesting
    public boolean isPermanentFailure(int i) {
        return DataFailCause.isPermanentFailure(this.mPhone.getContext(), i, this.mPhone.getSubId()) && (!this.mAttached.get() || i != -3);
    }

    private DataConnection findFreeDataConnection() {
        for (DataConnection next : this.mDataConnections.values()) {
            boolean z = false;
            Iterator<ApnContext> it = this.mApnContexts.values().iterator();
            while (true) {
                if (it.hasNext()) {
                    if (it.next().getDataConnection() == next) {
                        z = true;
                        continue;
                        break;
                    }
                } else {
                    break;
                }
            }
            if (!z) {
                log("findFreeDataConnection: found free DataConnection=" + next);
                return next;
            }
        }
        log("findFreeDataConnection: NO free DataConnection");
        return null;
    }

    /* JADX WARNING: Removed duplicated region for block: B:24:0x008e  */
    /* JADX WARNING: Removed duplicated region for block: B:45:0x00dd  */
    /* JADX WARNING: Removed duplicated region for block: B:48:0x0149  */
    /* JADX WARNING: Removed duplicated region for block: B:49:0x0169  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean setupData(com.android.internal.telephony.dataconnection.ApnContext r15, int r16, int r17) {
        /*
            r14 = this;
            r0 = r14
            r2 = r15
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r3 = "setupData: apnContext="
            r1.append(r3)
            r1.append(r15)
            java.lang.String r3 = ", requestType="
            r1.append(r3)
            java.lang.String r3 = requestTypeToString(r17)
            r1.append(r3)
            java.lang.String r1 = r1.toString()
            r14.log(r1)
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r3 = "setupData. requestType="
            r1.append(r3)
            java.lang.String r3 = requestTypeToString(r17)
            r1.append(r3)
            java.lang.String r1 = r1.toString()
            com.android.internal.telephony.dataconnection.ApnContext.requestLog(r15, r1)
            android.telephony.data.ApnSetting r1 = r15.getNextApnSetting()
            r3 = 0
            if (r1 != 0) goto L_0x004a
            java.lang.String r1 = "setupData: return for no apn found!"
            r14.log(r1)
            return r3
        L_0x004a:
            r4 = -1
            boolean r5 = r1.isPersistent()
            if (r5 == 0) goto L_0x005f
            int r4 = r1.getProfileId()
            if (r4 != 0) goto L_0x005f
            java.lang.String r4 = r15.getApnType()
            int r4 = r14.getApnProfileID(r4)
        L_0x005f:
            int r5 = r15.getApnTypeBitmask()
            r6 = 8
            if (r5 != r6) goto L_0x0071
            int r5 = r14.getDataRat()
            boolean r5 = android.telephony.ServiceState.isGsm(r5)
            if (r5 == 0) goto L_0x0087
        L_0x0071:
            int r5 = r15.getApnTypeBitmask()
            r6 = 16384(0x4000, float:2.2959E-41)
            if (r5 == r6) goto L_0x0087
            com.android.internal.telephony.dataconnection.DataConnection r5 = r14.checkForCompatibleDataConnection(r15, r1)
            if (r5 == 0) goto L_0x0088
            android.telephony.data.ApnSetting r6 = r5.getApnSetting()
            if (r6 == 0) goto L_0x0088
            r10 = r6
            goto L_0x0089
        L_0x0087:
            r5 = 0
        L_0x0088:
            r10 = r1
        L_0x0089:
            r11 = 1
            r6 = r16
            if (r5 != 0) goto L_0x00dd
            boolean r1 = r14.isOnlySingleDcAllowed(r6)
            if (r1 == 0) goto L_0x00ca
            boolean r1 = r14.isHigherPriorityApnContextActive(r15)
            if (r1 == 0) goto L_0x00a1
            java.lang.String r1 = "setupData: Higher priority ApnContext active.  Ignoring call"
            r14.log(r1)
            return r3
        L_0x00a1:
            java.lang.String r1 = r15.getApnType()
            java.lang.String r5 = "ims"
            boolean r1 = r1.equals(r5)
            if (r1 != 0) goto L_0x00c4
            com.android.internal.telephony.DctConstants$State r1 = r15.getState()
            com.android.internal.telephony.DctConstants$State r5 = com.android.internal.telephony.DctConstants.State.RETRYING
            if (r1 == r5) goto L_0x00c4
            java.lang.String r1 = "SinglePdnArbitration"
            boolean r1 = r14.cleanUpAllConnectionsInternal(r11, r1)
            if (r1 == 0) goto L_0x00c4
            java.lang.String r1 = "setupData: Some calls are disconnecting first. Wait and retry"
            r14.log(r1)
            return r3
        L_0x00c4:
            java.lang.String r1 = "setupData: Single pdp. Continue setting up data call."
            r14.log(r1)
        L_0x00ca:
            com.android.internal.telephony.dataconnection.DataConnection r1 = r14.findFreeDataConnection()
            if (r1 != 0) goto L_0x00d4
            com.android.internal.telephony.dataconnection.DataConnection r1 = r14.createDataConnection()
        L_0x00d4:
            if (r1 != 0) goto L_0x00de
            java.lang.String r1 = "setupData: No free DataConnection and couldn't create one, WEIRD"
            r14.log(r1)
            return r3
        L_0x00dd:
            r1 = r5
        L_0x00de:
            int r7 = r15.incAndGetConnectionGeneration()
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r5 = "setupData: dc="
            r3.append(r5)
            r3.append(r1)
            java.lang.String r5 = " apnSetting="
            r3.append(r5)
            r3.append(r10)
            java.lang.String r5 = " gen#="
            r3.append(r5)
            r3.append(r7)
            java.lang.String r3 = r3.toString()
            r14.log(r3)
            r15.setDataConnection(r1)
            r15.setApnSetting(r10)
            com.android.internal.telephony.DctConstants$State r3 = com.android.internal.telephony.DctConstants.State.CONNECTING
            r15.setState(r3)
            android.os.Message r5 = r14.obtainMessage()
            r3 = 270336(0x42000, float:3.78821E-40)
            r5.what = r3
            android.util.Pair r3 = new android.util.Pair
            java.lang.Integer r8 = java.lang.Integer.valueOf(r7)
            r3.<init>(r15, r8)
            r5.obj = r3
            android.telephony.data.ApnSetting r12 = r14.getPreferredApn()
            boolean r13 = r10.equals(r12)
            com.android.internal.telephony.Phone r3 = r0.mPhone
            int r8 = r3.getSubId()
            r2 = r15
            r3 = r4
            r4 = r16
            r6 = r7
            r7 = r17
            r9 = r13
            r1.bringUp(r2, r3, r4, r5, r6, r7, r8, r9)
            java.lang.String r1 = "}"
            java.lang.String r2 = ", apnSetting={"
            java.lang.String r3 = "setupData: initing! isPreferredApn="
            if (r13 == 0) goto L_0x0169
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            r4.append(r3)
            r4.append(r13)
            r4.append(r2)
            java.lang.String r2 = r10.toString()
            r4.append(r2)
            r4.append(r1)
            java.lang.String r1 = r4.toString()
            r14.log(r1)
            goto L_0x0196
        L_0x0169:
            if (r12 != 0) goto L_0x016e
            java.lang.String r4 = "null"
            goto L_0x0172
        L_0x016e:
            java.lang.String r4 = r12.toString()
        L_0x0172:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            r5.append(r3)
            r5.append(r13)
            r5.append(r2)
            r5.append(r10)
            java.lang.String r2 = "}, preferredApn={"
            r5.append(r2)
            r5.append(r4)
            r5.append(r1)
            java.lang.String r1 = r5.toString()
            r14.log(r1)
        L_0x0196:
            return r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcTracker.setupData(com.android.internal.telephony.dataconnection.ApnContext, int, int):boolean");
    }

    private List<Integer> getAllowedInitialAttachApnTypes() {
        String[] stringArray;
        PersistableBundle carrierConfig = getCarrierConfig();
        if (carrierConfig == null || (stringArray = carrierConfig.getStringArray("allowed_initial_attach_apn_types_string_array")) == null) {
            return Collections.emptyList();
        }
        return (List) Arrays.stream(stringArray).map(new DataConfigManager$$ExternalSyntheticLambda1()).collect(Collectors.toList());
    }

    /* access modifiers changed from: protected */
    public void setInitialAttachApn() {
        int preferredApnSetId = getPreferredApnSetId();
        ArrayList arrayList = new ArrayList();
        ApnSetting apnSetting = this.mPreferredApn;
        if (apnSetting != null) {
            arrayList.add(apnSetting);
        }
        arrayList.addAll(this.mAllApnSettings);
        List<Integer> allowedInitialAttachApnTypes = getAllowedInitialAttachApnTypes();
        ApnSetting apnSetting2 = null;
        for (Integer intValue : allowedInitialAttachApnTypes) {
            apnSetting2 = (ApnSetting) arrayList.stream().filter(new DcTracker$$ExternalSyntheticLambda5(intValue.intValue())).filter(new DcTracker$$ExternalSyntheticLambda6(preferredApnSetId)).findFirst().orElse((Object) null);
            if (apnSetting2 != null) {
                break;
            }
        }
        log("setInitialAttachApn: Allowed APN types=" + ((String) allowedInitialAttachApnTypes.stream().map(new DataConfigManager$$ExternalSyntheticLambda6()).collect(Collectors.joining(","))));
        if (apnSetting2 == null) {
            log("setInitialAttachApn: X There in no available apn.");
            return;
        }
        log("setInitialAttachApn: X selected APN=" + apnSetting2);
        this.mDataServiceManager.setInitialAttachApn(new DataProfile.Builder().setApnSetting(apnSetting2).setPreferred(apnSetting2.equals(getPreferredApn())).build(), this.mPhone.getServiceState().getDataRoamingFromRegistration(), (Message) null);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$setInitialAttachApn$5(int i, ApnSetting apnSetting) {
        return apnSetting.getApnSetId() == i || apnSetting.getApnSetId() == -1;
    }

    private void onApnChanged() {
        Phone phone = this.mPhone;
        if (phone instanceof GsmCdmaPhone) {
            ((GsmCdmaPhone) phone).updateCurrentCarrierInProvider();
        }
        log("onApnChanged: createAllApnList and cleanUpAllConnections");
        this.mDataThrottler.reset();
        setDefaultPreferredApnIfNeeded();
        createAllApnList();
        setDataProfilesAsNeeded();
        setInitialAttachApn();
        cleanUpConnectionsOnUpdatedApns(isAnyDataConnected(), PhoneInternalInterface.REASON_APN_CHANGED);
        if (this.mPhone.getSubId() == SubscriptionManager.getDefaultDataSubscriptionId()) {
            setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_APN_CHANGED, RetryFailures.ALWAYS);
        }
    }

    private boolean isHigherPriorityApnContextActive(ApnContext apnContext) {
        if (apnContext.getApnType().equals("ims")) {
            return false;
        }
        Iterator<ApnContext> it = this.mPrioritySortedApnContexts.iterator();
        while (it.hasNext()) {
            ApnContext next = it.next();
            if (!next.getApnType().equals("ims")) {
                if (apnContext.getApnType().equalsIgnoreCase(next.getApnType())) {
                    return false;
                }
                if (next.isEnabled() && next.getState() != DctConstants.State.FAILED) {
                    return true;
                }
            }
        }
        return false;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0014, code lost:
        r0 = r0.getConfigForSubId(r5.mPhone.getSubId());
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean isOnlySingleDcAllowed(int r6) {
        /*
            r5 = this;
            int r6 = android.telephony.ServiceState.rilRadioTechnologyToNetworkType(r6)
            com.android.internal.telephony.Phone r0 = r5.mPhone
            android.content.Context r0 = r0.getContext()
            java.lang.String r1 = "carrier_config"
            java.lang.Object r0 = r0.getSystemService(r1)
            android.telephony.CarrierConfigManager r0 = (android.telephony.CarrierConfigManager) r0
            if (r0 == 0) goto L_0x0027
            com.android.internal.telephony.Phone r1 = r5.mPhone
            int r1 = r1.getSubId()
            android.os.PersistableBundle r0 = r0.getConfigForSubId(r1)
            if (r0 == 0) goto L_0x0027
            java.lang.String r1 = "only_single_dc_allowed_int_array"
            int[] r0 = r0.getIntArray(r1)
            goto L_0x0028
        L_0x0027:
            r0 = 0
        L_0x0028:
            boolean r1 = com.android.internal.telephony.util.TelephonyUtils.IS_DEBUGGABLE
            r2 = 1
            r3 = 0
            if (r1 == 0) goto L_0x0038
            java.lang.String r1 = "persist.telephony.test.singleDc"
            boolean r1 = android.os.SystemProperties.getBoolean(r1, r3)
            if (r1 == 0) goto L_0x0038
            r1 = r2
            goto L_0x0039
        L_0x0038:
            r1 = r3
        L_0x0039:
            if (r0 == 0) goto L_0x0048
        L_0x003b:
            int r4 = r0.length
            if (r3 >= r4) goto L_0x0048
            if (r1 != 0) goto L_0x0048
            r4 = r0[r3]
            if (r6 != r4) goto L_0x0045
            r1 = r2
        L_0x0045:
            int r3 = r3 + 1
            goto L_0x003b
        L_0x0048:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r2 = "isOnlySingleDcAllowed("
            r0.append(r2)
            java.lang.String r6 = android.telephony.TelephonyManager.getNetworkTypeName(r6)
            r0.append(r6)
            java.lang.String r6 = "): "
            r0.append(r6)
            r0.append(r1)
            java.lang.String r6 = r0.toString()
            r5.log(r6)
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcTracker.isOnlySingleDcAllowed(int):boolean");
    }

    /* access modifiers changed from: package-private */
    public void sendRestartRadio() {
        log("sendRestartRadio:");
        sendMessage(obtainMessage(270362));
    }

    /* access modifiers changed from: private */
    public void restartRadio() {
        log("restartRadio: ************TURN OFF RADIO**************");
        cleanUpAllConnectionsInternal(true, PhoneInternalInterface.REASON_RADIO_TURNED_OFF);
        this.mPhone.getServiceStateTracker().powerOffRadioSafely();
    }

    private boolean retryAfterDisconnected(ApnContext apnContext) {
        return !PhoneInternalInterface.REASON_RADIO_TURNED_OFF.equals(apnContext.getReason()) && (!isOnlySingleDcAllowed(getDataRat()) || !isHigherPriorityApnContextActive(apnContext));
    }

    /* access modifiers changed from: protected */
    public void startReconnect(long j, ApnContext apnContext, int i) {
        apnContext.setState(DctConstants.State.RETRYING);
        Message obtainMessage = obtainMessage(270383, this.mPhone.getSubId(), i, apnContext);
        cancelReconnect(apnContext);
        sendMessageDelayed(obtainMessage, j);
        log("startReconnect: delay=" + j + ", apn=" + apnContext + ", reason=" + apnContext.getReason() + ", subId=" + this.mPhone.getSubId() + ", request type=" + requestTypeToString(i));
    }

    /* access modifiers changed from: protected */
    public void cancelReconnect(ApnContext apnContext) {
        if (apnContext != null) {
            log("cancelReconnect: apn=" + apnContext);
            removeMessages(270383, apnContext);
        }
    }

    private void readConfiguration() {
        log("readConfiguration");
        if (this.mTransportType == 1) {
            this.mAutoAttachOnCreationConfig = this.mPhone.getContext().getResources().getBoolean(17891380);
        }
        this.mAutoAttachEnabled.set(false);
        setDefaultPreferredApnIfNeeded();
        read5GConfiguration();
        registerSettingsObserver();
        SubscriptionPlan[] subscriptionPlans = this.mNetworkPolicyManager.getSubscriptionPlans(this.mPhone.getSubId(), this.mPhone.getContext().getOpPackageName());
        this.mSubscriptionPlans = subscriptionPlans == null ? Collections.emptyList() : Arrays.asList(subscriptionPlans);
        log("SubscriptionPlans initialized: " + this.mSubscriptionPlans);
        reevaluateUnmeteredConnections();
        this.mConfigReady = true;
    }

    private boolean isCarrierConfigApplied() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            return false;
        }
        return CarrierConfigManager.isConfigForIdentifiedCarrier(configForSubId);
    }

    private void onCarrierConfigChanged() {
        log("onCarrierConfigChanged");
        if (!isCarrierConfigApplied()) {
            log("onCarrierConfigChanged: Carrier config is not ready yet.");
            return;
        }
        readConfiguration();
        if (this.mSimState == 10) {
            setDefaultDataRoamingEnabled();
            createAllApnList();
            setDataProfilesAsNeeded();
            setInitialAttachApn();
            sortApnContextByPriority();
            cleanUpConnectionsOnUpdatedApns(true, PhoneInternalInterface.REASON_CARRIER_CHANGE);
            setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_CARRIER_CHANGE, RetryFailures.ALWAYS);
            return;
        }
        log("onCarrierConfigChanged: SIM is not loaded yet.");
    }

    private void onSimAbsent() {
        log("onSimAbsent");
        this.mConfigReady = false;
        cleanUpAllConnectionsInternal(true, PhoneInternalInterface.REASON_SIM_NOT_READY);
        this.mAllApnSettings.clear();
        this.mAutoAttachOnCreationConfig = false;
        this.mAutoAttachEnabled.set(false);
        createAllApnList();
        setDataProfilesAsNeeded();
    }

    private void onSimStateUpdated(@TelephonyManager.SimState int i) {
        this.mSimState = i;
        log("onSimStateUpdated: state=" + SubscriptionInfoUpdater.simStateString(this.mSimState));
        int i2 = this.mSimState;
        if (i2 == 1) {
            onSimAbsent();
        } else if (i2 == 10) {
            this.mDataThrottler.reset();
            if (this.mConfigReady) {
                createAllApnList();
                setDataProfilesAsNeeded();
                setInitialAttachApn();
                setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_SIM_LOADED, RetryFailures.ALWAYS);
                return;
            }
            log("onSimStateUpdated: config not ready yet.");
        }
    }

    private void onApnUnthrottled(String str) {
        if (str != null) {
            ApnSetting apnSetting = (ApnSetting) this.mAllApnSettings.stream().filter(new DcTracker$$ExternalSyntheticLambda0(str)).findFirst().orElse((Object) null);
            if (apnSetting != null) {
                this.mDataThrottler.setRetryTime(apnSetting.getApnTypeBitmask(), -1, 1);
                return;
            }
            loge("EVENT_APN_UNTHROTTLED: Invalid APN passed: " + str);
            return;
        }
        loge("EVENT_APN_UNTHROTTLED: apn is null");
    }

    private void onTrafficDescriptorsUpdated() {
        Iterator<ApnContext> it = this.mPrioritySortedApnContexts.iterator();
        while (it.hasNext()) {
            ApnContext next = it.next();
            if (next.getApnTypeBitmask() == 16384 && next.getApnSetting().getPermanentFailed()) {
                setupDataOnConnectableApn(next, PhoneInternalInterface.REASON_TRAFFIC_DESCRIPTORS_UPDATED, RetryFailures.ALWAYS);
            }
        }
    }

    private DataConnection checkForCompatibleDataConnection(ApnContext apnContext, ApnSetting apnSetting) {
        int apnTypeBitmask = apnContext.getApnTypeBitmask();
        DataConnection dataConnection = null;
        ArrayList<ApnSetting> fetchDunApns = 8 == apnTypeBitmask ? fetchDunApns() : null;
        log("checkForCompatibleDataConnection: apnContext=" + apnContext);
        for (DataConnection next : this.mDataConnections.values()) {
            if (next != null) {
                ApnSetting apnSetting2 = next.getApnSetting();
                log("apnSetting: " + apnSetting2);
                if (fetchDunApns != null && fetchDunApns.size() > 0) {
                    Iterator<ApnSetting> it = fetchDunApns.iterator();
                    while (it.hasNext()) {
                        if (areCompatible(it.next(), apnSetting2)) {
                            if (next.isActive()) {
                                log("checkForCompatibleDataConnection: found dun conn=" + next);
                                return next;
                            } else if (next.isActivating()) {
                                dataConnection = next;
                            }
                        }
                    }
                    continue;
                } else if (!isApnSettingCompatible(next, apnTypeBitmask)) {
                    continue;
                } else if (next.isActive()) {
                    log("checkForCompatibleDataConnection: found canHandle conn=" + next);
                    return next;
                } else if (next.isActivating() || (apnSetting2 != null && apnSetting2.equals(apnSetting))) {
                    dataConnection = next;
                }
            }
        }
        log("checkForCompatibleDataConnection: potential dc=" + dataConnection);
        return dataConnection;
    }

    private boolean isApnSettingCompatible(DataConnection dataConnection, int i) {
        ApnSetting apnSetting = dataConnection.getApnSetting();
        if (apnSetting == null) {
            return false;
        }
        for (ApnContext apnTypeBitmask : dataConnection.getApnContexts()) {
            if (apnTypeBitmask.getApnTypeBitmask() == 16384) {
                return false;
            }
        }
        return apnSetting.canHandleType(i);
    }

    private void addHandoverCompleteMsg(Message message, int i) {
        if (message != null) {
            List list = this.mHandoverCompletionMsgs.get(Integer.valueOf(i));
            if (list == null) {
                list = new ArrayList();
            }
            list.add(message);
            this.mHandoverCompletionMsgs.put(Integer.valueOf(i), list);
        }
    }

    private void sendHandoverCompleteMessages(int i, boolean z, boolean z2) {
        List<Message> list = this.mHandoverCompletionMsgs.get(Integer.valueOf(i));
        if (list != null) {
            for (Message sendHandoverCompleteMsg : list) {
                sendHandoverCompleteMsg(sendHandoverCompleteMsg, z, this.mTransportType, z2);
            }
            list.clear();
        }
    }

    private void sendHandoverCompleteMsg(Message message, boolean z, int i, boolean z2) {
        if (message != null) {
            Bundle data = message.getData();
            data.putBoolean(DATA_COMPLETE_MSG_EXTRA_SUCCESS, z);
            data.putInt(DATA_COMPLETE_MSG_EXTRA_TRANSPORT_TYPE, i);
            data.putBoolean(DATA_COMPLETE_MSG_EXTRA_HANDOVER_FAILURE_FALLBACK, z2);
            message.sendToTarget();
        }
    }

    public static int calculateNewRetryRequestType(int i, int i2, int i3) {
        boolean shouldFallbackOnFailedHandover = shouldFallbackOnFailedHandover(i, i2, i3);
        if (i2 != 2) {
            return i2;
        }
        return (!shouldFallbackOnFailedHandover && i != 3) ? 2 : 1;
    }

    public void enableApn(int i, int i2, Message message) {
        sendMessage(obtainMessage(270349, i, i2, message));
    }

    private void onEnableApn(int i, int i2, Message message) {
        ApnContext apnContext = this.mApnContextsByType.get(i);
        if (apnContext == null) {
            loge("onEnableApn(" + i + "): NO ApnContext");
            if (message != null) {
                sendHandoverCompleteMsg(message, false, this.mTransportType, false);
                return;
            }
            return;
        }
        String str = "onEnableApn: apnType=" + ApnSetting.getApnTypeString(i) + ", request type=" + requestTypeToString(i2);
        log(str);
        ApnContext.requestLog(apnContext, str);
        if (!apnContext.isDependencyMet()) {
            apnContext.setReason(PhoneInternalInterface.REASON_DATA_DEPENDENCY_UNMET);
            apnContext.setEnabled(true);
            log("onEnableApn: dependency is not met.");
            ApnContext.requestLog(apnContext, "onEnableApn: dependency is not met.");
            if (message != null) {
                sendHandoverCompleteMsg(message, false, this.mTransportType, false);
                return;
            }
            return;
        }
        if (apnContext.isReady()) {
            int i3 = AnonymousClass4.$SwitchMap$com$android$internal$telephony$DctConstants$State[apnContext.getState().ordinal()];
            if (i3 != 1) {
                if (i3 != 2) {
                    if (i3 == 3 || i3 == 4 || i3 == 5) {
                        apnContext.setReason(PhoneInternalInterface.REASON_DATA_ENABLED);
                    }
                } else if (message != null) {
                    sendHandoverCompleteMsg(message, true, this.mTransportType, false);
                    log("onEnableApn: already in CONNECTED state. Consider as handover succeeded");
                    return;
                } else {
                    log("onEnableApn: APN in CONNECTED state. Exit now.");
                    return;
                }
            } else if (message != null) {
                log("onEnableApn: already in CONNECTING state. Handover request will be responded after connected.");
                addHandoverCompleteMsg(message, i);
                return;
            } else {
                log("onEnableApn: in CONNECTING state. Exit now.");
                return;
            }
        } else {
            if (apnContext.isEnabled()) {
                apnContext.setReason(PhoneInternalInterface.REASON_DATA_DEPENDENCY_MET);
            } else {
                apnContext.setReason(PhoneInternalInterface.REASON_DATA_ENABLED);
            }
            if (apnContext.getState() == DctConstants.State.FAILED) {
                apnContext.setState(DctConstants.State.IDLE);
            }
        }
        apnContext.setEnabled(true);
        apnContext.resetErrorCodeRetries();
        if (this.mConfigReady || apnContext.getApnTypeBitmask() == 512) {
            trySetupData(apnContext, i2, message);
        } else {
            log("onEnableApn: config not ready yet.");
        }
    }

    /* renamed from: com.android.internal.telephony.dataconnection.DcTracker$4  reason: invalid class name */
    static /* synthetic */ class AnonymousClass4 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$DctConstants$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(12:0|1|2|3|4|5|6|7|8|9|10|12) */
        /* JADX WARNING: Code restructure failed: missing block: B:13:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.DctConstants$State[] r0 = com.android.internal.telephony.DctConstants.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$DctConstants$State = r0
                com.android.internal.telephony.DctConstants$State r1 = com.android.internal.telephony.DctConstants.State.CONNECTING     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DctConstants$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.DctConstants$State r1 = com.android.internal.telephony.DctConstants.State.CONNECTED     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DctConstants$State     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.DctConstants$State r1 = com.android.internal.telephony.DctConstants.State.IDLE     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DctConstants$State     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.DctConstants$State r1 = com.android.internal.telephony.DctConstants.State.FAILED     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DctConstants$State     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.DctConstants$State r1 = com.android.internal.telephony.DctConstants.State.RETRYING     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcTracker.AnonymousClass4.<clinit>():void");
        }
    }

    public void disableApn(int i, int i2) {
        sendMessage(obtainMessage(270350, i, i2));
    }

    private void onDisableApn(int i, int i2) {
        boolean z;
        ApnContext apnContext = this.mApnContextsByType.get(i);
        if (apnContext == null) {
            loge("disableApn(" + i + "): NO ApnContext");
            return;
        }
        String str = "onDisableApn: apnType=" + ApnSetting.getApnTypeString(i) + ", release type=" + releaseTypeToString(i2);
        log(str);
        ApnContext.requestLog(apnContext, str);
        if (apnContext.isReady()) {
            z = i2 == 2 || i2 == 3;
            if (apnContext.isDependencyMet()) {
                apnContext.setReason(PhoneInternalInterface.REASON_DATA_DISABLED_INTERNAL);
                if ("dun".equals(apnContext.getApnType()) || apnContext.getState() != DctConstants.State.CONNECTED) {
                    String str2 = "Clean up the connection. Apn type = " + apnContext.getApnType() + ", state = " + apnContext.getState();
                    log(str2);
                    ApnContext.requestLog(apnContext, str2);
                    z = true;
                }
            } else {
                apnContext.setReason(PhoneInternalInterface.REASON_DATA_DEPENDENCY_UNMET);
            }
        } else {
            z = false;
        }
        apnContext.setEnabled(false);
        if (z) {
            cleanUpConnectionInternal(true, i2, apnContext);
        }
        if (isOnlySingleDcAllowed(getDataRat()) && !isHigherPriorityApnContextActive(apnContext)) {
            log("disableApn:isOnlySingleDcAllowed true & higher priority APN disabled");
            setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_SINGLE_PDN_ARBITRATION, RetryFailures.ALWAYS);
        }
    }

    public void setDataRoamingEnabledByUser(boolean z) {
        this.mDataEnabledSettings.setDataRoamingEnabled(z);
        setDataRoamingFromUserAction(true);
        log("setDataRoamingEnabledByUser: set phoneSubId=" + this.mPhone.getSubId() + " isRoaming=" + z);
    }

    public boolean getDataRoamingEnabled() {
        return this.mDataEnabledSettings.getDataRoamingEnabled();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:6:0x002a, code lost:
        if (isDataRoamingFromUserAction() == false) goto L_0x002e;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void setDefaultDataRoamingEnabled() {
        /*
            r3 = this;
            android.telephony.TelephonyManager r0 = r3.mTelephonyManager
            int r0 = r0.getSimCount()
            r1 = 1
            if (r0 == r1) goto L_0x0026
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r2 = "data_roaming"
            r0.append(r2)
            com.android.internal.telephony.Phone r2 = r3.mPhone
            int r2 = r2.getSubId()
            r0.append(r2)
            java.lang.String r0 = r0.toString()
            android.content.ContentResolver r2 = r3.mResolver     // Catch:{ SettingNotFoundException -> 0x002e }
            android.provider.Settings.Global.getInt(r2, r0)     // Catch:{ SettingNotFoundException -> 0x002e }
            goto L_0x002d
        L_0x0026:
            boolean r0 = r3.isDataRoamingFromUserAction()
            if (r0 != 0) goto L_0x002d
            goto L_0x002e
        L_0x002d:
            r1 = 0
        L_0x002e:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r2 = "setDefaultDataRoamingEnabled: useCarrierSpecificDefault "
            r0.append(r2)
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            r3.log(r0)
            if (r1 == 0) goto L_0x004f
            com.android.internal.telephony.dataconnection.DataEnabledSettings r0 = r3.mDataEnabledSettings
            boolean r0 = r0.getDefaultDataRoamingEnabled()
            com.android.internal.telephony.dataconnection.DataEnabledSettings r3 = r3.mDataEnabledSettings
            r3.setDataRoamingEnabled(r0)
        L_0x004f:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcTracker.setDefaultDataRoamingEnabled():void");
    }

    private boolean isDataRoamingFromUserAction() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(this.mPhone.getContext());
        if (!defaultSharedPreferences.contains(Phone.DATA_ROAMING_IS_USER_SETTING_KEY)) {
            defaultSharedPreferences.edit().putBoolean(Phone.DATA_ROAMING_IS_USER_SETTING_KEY, false).commit();
        }
        return defaultSharedPreferences.getBoolean(Phone.DATA_ROAMING_IS_USER_SETTING_KEY, true);
    }

    private void setDataRoamingFromUserAction(boolean z) {
        PreferenceManager.getDefaultSharedPreferences(this.mPhone.getContext()).edit().putBoolean(Phone.DATA_ROAMING_IS_USER_SETTING_KEY, z).commit();
    }

    private void onDataRoamingOff() {
        log("onDataRoamingOff");
        reevaluateDataConnections();
        if (!getDataRoamingEnabled()) {
            setDataProfilesAsNeeded();
            setInitialAttachApn();
            setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_ROAMING_OFF, RetryFailures.ALWAYS);
        }
    }

    private void onDataRoamingOnOrSettingsChanged(int i) {
        log("onDataRoamingOnOrSettingsChanged");
        boolean z = i == 270384;
        if (!this.mPhone.getServiceState().getDataRoaming()) {
            log("device is not roaming. ignored the request.");
            return;
        }
        checkDataRoamingStatus(z);
        if (getDataRoamingEnabled()) {
            if (z) {
                reevaluateDataConnections();
            }
            log("onDataRoamingOnOrSettingsChanged: setup data on roaming");
            setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_ROAMING_ON, RetryFailures.ALWAYS);
            return;
        }
        log("onDataRoamingOnOrSettingsChanged: Tear down data connection on roaming.");
        cleanUpAllConnectionsInternal(true, PhoneInternalInterface.REASON_ROAMING_ON);
    }

    private void checkDataRoamingStatus(boolean z) {
        if (!z && !getDataRoamingEnabled() && this.mPhone.getServiceState().getDataRoaming()) {
            for (ApnContext next : this.mApnContexts.values()) {
                if (next.getState() == DctConstants.State.CONNECTED) {
                    LocalLog localLog = this.mDataRoamingLeakageLog;
                    StringBuilder sb = new StringBuilder();
                    sb.append("PossibleRoamingLeakage  connection params: ");
                    sb.append(next.getDataConnection() != null ? next.getDataConnection().getConnectionParams() : "");
                    localLog.log(sb.toString());
                }
            }
        }
    }

    private void onRadioAvailable() {
        log("onRadioAvailable");
        if (!areAllDataDisconnected()) {
            cleanUpConnectionInternal(true, 2, (ApnContext) null);
        }
    }

    private void onRadioOffOrNotAvailable() {
        this.mReregisterOnReconnectFailure = false;
        this.mAutoAttachEnabled.set(false);
        if (this.mPhone.getSimulatedRadioControl() != null) {
            log("We're on the simulator; assuming radio off is meaningless");
            return;
        }
        log("onRadioOffOrNotAvailable: is off and clean up all connections");
        cleanUpAllConnectionsInternal(false, PhoneInternalInterface.REASON_RADIO_TURNED_OFF);
    }

    private void completeConnection(ApnContext apnContext, int i) {
        log("completeConnection: successful, notify the world apnContext=" + apnContext);
        if (this.mIsProvisioning && !TextUtils.isEmpty(this.mProvisioningUrl)) {
            log("completeConnection: MOBILE_PROVISIONING_ACTION url=" + this.mProvisioningUrl);
            Intent makeMainSelectorActivity = Intent.makeMainSelectorActivity("android.intent.action.MAIN", "android.intent.category.APP_BROWSER");
            makeMainSelectorActivity.setData(Uri.parse(this.mProvisioningUrl));
            makeMainSelectorActivity.setFlags(272629760);
            try {
                this.mPhone.getContext().startActivity(makeMainSelectorActivity);
            } catch (ActivityNotFoundException e) {
                loge("completeConnection: startActivityAsUser failed" + e);
            }
        }
        this.mIsProvisioning = false;
        this.mProvisioningUrl = null;
        ProgressDialog progressDialog = this.mProvisioningSpinner;
        if (progressDialog != null) {
            sendMessage(obtainMessage(270378, progressDialog));
        }
        startNetStatPoll();
        startDataStallAlarm(false);
        PersistableBundle carrierConfig = getCarrierConfig();
        if (apnContext.getApnTypeBitmask() == 17 && carrierConfig.getBoolean("display_no_data_notification_on_permanent_failure_bool")) {
            ((NotificationManager) this.mPhone.getContext().getSystemService("notification")).cancel(Integer.toString(this.mPhone.getSubId()), 1001);
        }
    }

    /* access modifiers changed from: protected */
    public void onDataSetupComplete(ApnContext apnContext, boolean z, int i, int i2, int i3) {
        String str;
        int i4;
        boolean shouldFallbackOnFailedHandover = shouldFallbackOnFailedHandover(i3, i2, i);
        if (z && i3 != -1 && i3 != 0) {
            String str2 = this.mLogTag;
            Log.wtf(str2, "bad failure mode: " + DataCallResponse.failureModeToString(i3));
        } else if (!(i3 == 2 || i == 65545)) {
            sendHandoverCompleteMessages(apnContext.getApnTypeBitmask(), z, shouldFallbackOnFailedHandover);
        }
        if (!z) {
            ApnSetting apnSetting = apnContext.getApnSetting();
            log("onDataSetupComplete: error apn=" + apnSetting.getApnName() + ", cause=" + DataFailCause.toString(i) + ", requestType=" + requestTypeToString(i2));
            if (DataFailCause.isEventLoggable(i)) {
                EventLog.writeEvent(EventLogTags.PDP_SETUP_FAIL, new Object[]{Integer.valueOf(i), Integer.valueOf(getCellLocationId()), Integer.valueOf(this.mTelephonyManager.getNetworkType())});
            }
            ApnSetting apnSetting2 = apnContext.getApnSetting();
            Intent intent = new Intent("android.telephony.action.CARRIER_SIGNAL_REQUEST_NETWORK_FAILED");
            intent.putExtra("android.telephony.extra.DATA_FAIL_CAUSE", i);
            intent.putExtra("android.telephony.extra.APN_TYPE", ApnSetting.getApnTypesBitmaskFromString(apnContext.getApnType()));
            this.mPhone.getCarrierSignalAgent().notifyCarrierSignalReceivers(intent);
            if (DataFailCause.isRadioRestartFailure(this.mPhone.getContext(), i, this.mPhone.getSubId()) || apnContext.restartOnError(i)) {
                log("Modem restarted.");
                sendRestartRadio();
            }
            if (isPermanentFailure(i)) {
                log("cause=" + DataFailCause.toString(i) + ", mark apn as permanent failed. apn = " + apnSetting2);
                apnContext.markApnPermanentFailed(apnSetting2);
                PersistableBundle carrierConfig = getCarrierConfig();
                if (apnContext.getApnTypeBitmask() == 17 && carrierConfig.getBoolean("display_no_data_notification_on_permanent_failure_bool")) {
                    CharSequence text = this.mPhone.getContext().getText(17039561);
                    CharSequence text2 = this.mPhone.getContext().getText(17039564);
                    ((NotificationManager) this.mPhone.getContext().getSystemService("notification")).notify(Integer.toString(this.mPhone.getSubId()), 1001, new Notification.Builder(this.mPhone.getContext(), NotificationChannelController.CHANNEL_ID_MOBILE_DATA_STATUS).setWhen(System.currentTimeMillis()).setAutoCancel(true).setSmallIcon(17301642).setTicker(text).setColor(this.mPhone.getContext().getResources().getColor(17170460)).setContentTitle(text).setStyle(new Notification.BigTextStyle().bigText(text2)).setContentText(text2).build());
                }
            }
            onDataSetupCompleteError(apnContext, calculateNewRetryRequestType(i3, i2, i), shouldFallbackOnFailedHandover);
        } else if (apnContext.getDataConnection() == null) {
            log("onDataSetupComplete: no connection to DC, handle as error");
            onDataSetupCompleteError(apnContext, i2, false);
        } else {
            ApnSetting apnSetting3 = apnContext.getApnSetting();
            StringBuilder sb = new StringBuilder();
            sb.append("onDataSetupComplete: success apn=");
            if (apnSetting3 == null) {
                str = EnvironmentCompat.MEDIA_UNKNOWN;
            } else {
                str = apnSetting3.getApnName();
            }
            sb.append(str);
            log(sb.toString());
            if (TextUtils.equals(apnContext.getApnType(), "default") && this.mCanSetPreferApn && this.mPreferredApn == null) {
                log("onDataSetupComplete: PREFERRED APN is null");
                this.mPreferredApn = apnSetting3;
                if (apnSetting3 != null) {
                    setPreferredApn(apnSetting3.getId());
                }
            }
            apnContext.setState(DctConstants.State.CONNECTED);
            checkDataRoamingStatus(false);
            boolean isProvisioningApn = apnContext.isProvisioningApn();
            ConnectivityManager connectivityManager = (ConnectivityManager) this.mPhone.getContext().getSystemService("connectivity");
            if (this.mProvisionBroadcastReceiver != null) {
                this.mPhone.getContext().unregisterReceiver(this.mProvisionBroadcastReceiver);
                this.mProvisionBroadcastReceiver = null;
            }
            if (!isProvisioningApn || this.mIsProvisioning) {
                if (this.mIsProvisioning) {
                    hideProvisioningNotification();
                }
                completeConnection(apnContext, i2);
            } else {
                log("onDataSetupComplete: successful, BUT send connected to prov apn as mIsProvisioning:" + this.mIsProvisioning + " == false && (isProvisioningApn:" + isProvisioningApn + " == true");
                this.mProvisionBroadcastReceiver = new ProvisionNotificationBroadcastReceiver(this.mPhone.getMobileProvisioningUrl(), this.mTelephonyManager.getNetworkOperatorName());
                this.mPhone.getContext().registerReceiver(this.mProvisionBroadcastReceiver, new IntentFilter(INTENT_PROVISION));
                showProvisioningNotification();
                setRadio(false);
            }
            log("onDataSetupComplete: SETUP complete type=" + apnContext.getApnType());
            if (TelephonyUtils.IS_DEBUGGABLE && (i4 = SystemProperties.getInt("persist.radio.test.pco", -1)) != -1) {
                log("PCO testing: read pco value from persist.radio.test.pco " + i4);
                byte[] bArr = {(byte) i4};
                Intent intent2 = new Intent("android.telephony.action.CARRIER_SIGNAL_PCO_VALUE");
                intent2.putExtra("android.telephony.extra.APN_TYPE", 17);
                intent2.putExtra("android.telephony.extra.APN_PROTOCOL", 2);
                intent2.putExtra("android.telephony.extra.PCO_ID", MotionEventCompat.ACTION_POINTER_INDEX_MASK);
                intent2.putExtra("android.telephony.extra.PCO_VALUE", bArr);
                this.mPhone.getCarrierSignalAgent().notifyCarrierSignalReceivers(intent2);
            }
        }
    }

    /* access modifiers changed from: protected */
    public void onDataSetupCompleteError(ApnContext apnContext, int i, boolean z) {
        long delayForNextApn = apnContext.getDelayForNextApn(this.mFailFast);
        if (delayForNextApn < 0 || delayForNextApn == Long.MAX_VALUE || z) {
            apnContext.setState(DctConstants.State.FAILED);
            apnContext.setDataConnection((DataConnection) null);
            log("onDataSetupCompleteError: Stop retrying APNs. delay=" + delayForNextApn + ", requestType=" + requestTypeToString(i));
            sendHandoverCompleteMessages(apnContext.getApnTypeBitmask(), false, z);
            return;
        }
        log("onDataSetupCompleteError: APN type=" + apnContext.getApnType() + ". Request type=" + requestTypeToString(i) + ", Retry in " + delayForNextApn + "ms.");
        startReconnect(delayForNextApn, apnContext, i);
    }

    private void onNetworkStatusChanged(int i, int i2, String str) {
        if (!TextUtils.isEmpty(str)) {
            Intent intent = new Intent("android.telephony.action.CARRIER_SIGNAL_REDIRECTED");
            intent.putExtra("android.telephony.extra.REDIRECTION_URL", str);
            this.mPhone.getCarrierSignalAgent().notifyCarrierSignalReceivers(intent);
            log("Notify carrier signal receivers with redirectUrl: " + str);
            return;
        }
        boolean z = i == 1;
        DataConnection dataConnectionByContextId = getDataConnectionByContextId(i2);
        if (!this.mDsRecoveryHandler.isRecoveryOnBadNetworkEnabled()) {
            log("Skip data stall recovery on network status change with in threshold");
        } else if (this.mTransportType != 1) {
            log("Skip data stall recovery on non WWAN");
        } else if (dataConnectionByContextId != null && dataConnectionByContextId.isValidationRequired()) {
            this.mDsRecoveryHandler.processNetworkStatusChanged(z);
        }
    }

    private void onDisconnectDone(ApnContext apnContext) {
        log("onDisconnectDone: EVENT_DISCONNECT_DONE apnContext=" + apnContext);
        apnContext.setState(DctConstants.State.IDLE);
        if (!areAllDataDisconnected() || !this.mPhone.getServiceStateTracker().processPendingRadioPowerOffAfterDataOff()) {
            if (!this.mAttached.get() || !apnContext.isReady() || !retryAfterDisconnected(apnContext)) {
                boolean z = this.mPhone.getContext().getResources().getBoolean(17891736);
                if (apnContext.isProvisioningApn() && z) {
                    log("onDisconnectDone: restartRadio after provisioning");
                    restartRadio();
                }
                apnContext.setApnSetting((ApnSetting) null);
                apnContext.setDataConnection((DataConnection) null);
                if (isOnlySingleDcAllowed(getDataRat())) {
                    log("onDisconnectDone: isOnlySigneDcAllowed true so setup single apn");
                    setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_SINGLE_PDN_ARBITRATION, RetryFailures.ALWAYS);
                } else {
                    log("onDisconnectDone: not retrying");
                }
            } else {
                log("onDisconnectDone: attached, ready and retry after disconnect");
                if (isHandoverPending(apnContext.getApnTypeBitmask())) {
                    log("Handover request pending. Retry handover immediately.");
                    startReconnect(0, apnContext, 2);
                } else {
                    long retryAfterDisconnectDelay = apnContext.getRetryAfterDisconnectDelay();
                    if (retryAfterDisconnectDelay > 0) {
                        startReconnect(retryAfterDisconnectDelay, apnContext, 1);
                    }
                }
            }
            if (areAllDataDisconnected()) {
                apnContext.setConcurrentVoiceAndDataAllowed(this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed());
                notifyAllDataDisconnected();
                return;
            }
            return;
        }
        log("onDisconnectDone: radio will be turned off, no retries");
        apnContext.setApnSetting((ApnSetting) null);
        apnContext.setDataConnection((DataConnection) null);
        notifyAllDataDisconnected();
    }

    private void onVoiceCallStarted() {
        log("onVoiceCallStarted");
        this.mInVoiceCall = true;
        if (isAnyDataConnected() && !this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed()) {
            log("onVoiceCallStarted stop polling");
            stopNetStatPoll();
            stopDataStallAlarm();
        }
    }

    /* access modifiers changed from: protected */
    public void onVoiceCallEnded() {
        log("onVoiceCallEnded");
        this.mInVoiceCall = false;
        if (isAnyDataConnected()) {
            if (!this.mPhone.getServiceStateTracker().isConcurrentVoiceAndDataAllowed()) {
                startNetStatPoll();
                startDataStallAlarm(false);
            } else {
                resetPollStats();
            }
        }
        setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_VOICE_CALL_ENDED, RetryFailures.ALWAYS);
    }

    @VisibleForTesting
    public boolean isAnyDataConnected() {
        for (DataConnection isActive : this.mDataConnections.values()) {
            if (isActive.isActive()) {
                return true;
            }
        }
        return false;
    }

    public boolean areAllDataDisconnected() {
        for (DataConnection next : this.mDataConnections.values()) {
            if (!next.isInactive()) {
                log("areAllDataDisconnected false due to DC: " + next.getName());
                return false;
            }
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public void setDataProfilesAsNeeded() {
        log("setDataProfilesAsNeeded");
        ArrayList arrayList = new ArrayList();
        int preferredApnSetId = getPreferredApnSetId();
        Iterator<ApnSetting> it = this.mAllApnSettings.iterator();
        while (it.hasNext()) {
            ApnSetting next = it.next();
            if (next.getApnSetId() == -1 || preferredApnSetId == next.getApnSetId()) {
                DataProfile build = new DataProfile.Builder().setApnSetting(next).setPreferred(next.equals(getPreferredApn())).build();
                if (!arrayList.contains(build)) {
                    arrayList.add(build);
                }
            }
        }
        if (arrayList.isEmpty()) {
            return;
        }
        if (arrayList.size() != this.mLastDataProfileList.size() || !this.mLastDataProfileList.containsAll(arrayList)) {
            this.mDataServiceManager.setDataProfile(arrayList, this.mPhone.getServiceState().getDataRoamingFromRegistration(), (Message) null);
        }
    }

    /* access modifiers changed from: protected */
    public void createAllApnList() {
        this.mAllApnSettings.clear();
        String operatorNumeric = this.mPhone.getOperatorNumeric();
        ContentResolver contentResolver = this.mPhone.getContext().getContentResolver();
        Uri uri = Telephony.Carriers.SIM_APN_URI;
        Cursor query = contentResolver.query(Uri.withAppendedPath(uri, "filtered/subId/" + this.mPhone.getSubId()), (String[]) null, (String) null, (String[]) null, "_id");
        if (query != null) {
            while (query.moveToNext()) {
                ApnSetting makeApnSetting = ApnSetting.makeApnSetting(query);
                if (makeApnSetting != null) {
                    this.mAllApnSettings.add(makeApnSetting);
                }
            }
            query.close();
        } else {
            log("createAllApnList: cursor is null");
            LocalLog localLog = this.mApnSettingsInitializationLog;
            localLog.log("cursor is null for carrier, operator: " + operatorNumeric);
        }
        dedupeApnSettings();
        if (this.mAllApnSettings.isEmpty()) {
            log("createAllApnList: No APN found for carrier, operator: " + operatorNumeric);
            LocalLog localLog2 = this.mApnSettingsInitializationLog;
            localLog2.log("no APN found for carrier, operator: " + operatorNumeric);
            this.mPreferredApn = null;
        } else {
            this.mPreferredApn = getPreferredApn();
            log("createAllApnList: mPreferredApn=" + this.mPreferredApn);
        }
        addDefaultApnSettingsAsNeeded();
        log("createAllApnList: X mAllApnSettings=" + this.mAllApnSettings);
    }

    private void dedupeApnSettings() {
        new ArrayList();
        int i = 0;
        while (i < this.mAllApnSettings.size() - 1) {
            ApnSetting apnSetting = this.mAllApnSettings.get(i);
            int i2 = i + 1;
            int i3 = i2;
            while (i3 < this.mAllApnSettings.size()) {
                ApnSetting apnSetting2 = this.mAllApnSettings.get(i3);
                if (apnSetting.similar(apnSetting2)) {
                    apnSetting = mergeApns(apnSetting, apnSetting2);
                    this.mAllApnSettings.set(i, apnSetting);
                    this.mAllApnSettings.remove(i3);
                } else {
                    i3++;
                }
            }
            i = i2;
        }
    }

    private ApnSetting mergeApns(ApnSetting apnSetting, ApnSetting apnSetting2) {
        int i;
        int id = apnSetting.getId();
        if ((apnSetting2.getApnTypeBitmask() & 17) == 17) {
            id = apnSetting2.getId();
        }
        int apnTypeBitmask = apnSetting2.getApnTypeBitmask() | apnSetting.getApnTypeBitmask();
        Uri mmsc = apnSetting.getMmsc() == null ? apnSetting2.getMmsc() : apnSetting.getMmsc();
        String mmsProxyAddressAsString = TextUtils.isEmpty(apnSetting.getMmsProxyAddressAsString()) ? apnSetting2.getMmsProxyAddressAsString() : apnSetting.getMmsProxyAddressAsString();
        int mmsProxyPort = apnSetting.getMmsProxyPort() == -1 ? apnSetting2.getMmsProxyPort() : apnSetting.getMmsProxyPort();
        String proxyAddressAsString = TextUtils.isEmpty(apnSetting.getProxyAddressAsString()) ? apnSetting2.getProxyAddressAsString() : apnSetting.getProxyAddressAsString();
        int proxyPort = apnSetting.getProxyPort() == -1 ? apnSetting2.getProxyPort() : apnSetting.getProxyPort();
        if (apnSetting2.getProtocol() == 2) {
            i = apnSetting2.getProtocol();
        } else {
            i = apnSetting.getProtocol();
        }
        boolean z = false;
        ApnSetting.Builder profileId = new ApnSetting.Builder().setId(id).setOperatorNumeric(apnSetting.getOperatorNumeric()).setEntryName(apnSetting.getEntryName()).setApnName(apnSetting.getApnName()).setProxyAddress(proxyAddressAsString).setProxyPort(proxyPort).setMmsc(mmsc).setMmsProxyAddress(mmsProxyAddressAsString).setMmsProxyPort(mmsProxyPort).setUser(apnSetting.getUser()).setPassword(apnSetting.getPassword()).setAuthType(apnSetting.getAuthType()).setApnTypeBitmask(apnTypeBitmask).setProtocol(i).setRoamingProtocol(apnSetting2.getRoamingProtocol() == 2 ? apnSetting2.getRoamingProtocol() : apnSetting.getRoamingProtocol()).setCarrierEnabled(apnSetting.isEnabled()).setNetworkTypeBitmask((apnSetting.getNetworkTypeBitmask() == 0 || apnSetting2.getNetworkTypeBitmask() == 0) ? 0 : apnSetting.getNetworkTypeBitmask() | apnSetting2.getNetworkTypeBitmask()).setProfileId(apnSetting.getProfileId());
        if (apnSetting.isPersistent() || apnSetting2.isPersistent()) {
            z = true;
        }
        return profileId.setModemCognitive(z).setMaxConns(apnSetting.getMaxConns()).setWaitTime(apnSetting.getWaitTime()).setMaxConnsTime(apnSetting.getMaxConnsTime()).setMtuV4(apnSetting.getMtuV4()).setMtuV6(apnSetting.getMtuV6()).setMvnoType(apnSetting.getMvnoType()).setMvnoMatchData(apnSetting.getMvnoMatchData()).setApnSetId(apnSetting.getApnSetId()).setCarrierId(apnSetting.getCarrierId()).setSkip464Xlat(apnSetting.getSkip464Xlat()).build();
    }

    private DataConnection createDataConnection() {
        log("createDataConnection E");
        int andIncrement = this.mUniqueIdGenerator.getAndIncrement();
        DataConnection makeDataConnection = DataConnection.makeDataConnection(this.mPhone, andIncrement, this, this.mDataServiceManager, this.mDcTesterFailBringUpAll, this.mDcc);
        this.mDataConnections.put(Integer.valueOf(andIncrement), makeDataConnection);
        log("createDataConnection() X id=" + andIncrement + " dc=" + makeDataConnection);
        return makeDataConnection;
    }

    private void destroyDataConnections() {
        if (this.mDataConnections != null) {
            log("destroyDataConnections: clear mDataConnectionList");
            this.mDataConnections.clear();
            return;
        }
        log("destroyDataConnections: mDataConnecitonList is empty, ignore");
    }

    private ArrayList<ApnSetting> buildWaitingApns(String str, int i) {
        ApnSetting apnSetting;
        log("buildWaitingApns: E requestedApnType=" + str);
        ArrayList<ApnSetting> arrayList = new ArrayList<>();
        int apnTypesBitmaskFromString = ApnSetting.getApnTypesBitmaskFromString(str);
        if (apnTypesBitmaskFromString == 16384) {
            apnTypesBitmaskFromString = 17;
        }
        if (apnTypesBitmaskFromString == 8) {
            ArrayList<ApnSetting> fetchDunApns = fetchDunApns();
            if (fetchDunApns.size() > 0) {
                Iterator<ApnSetting> it = fetchDunApns.iterator();
                while (it.hasNext()) {
                    arrayList.add(it.next());
                    log("buildWaitingApns: X added APN_TYPE_DUN apnList=" + arrayList);
                }
                return arrayList;
            }
        }
        String operatorNumeric = this.mPhone.getOperatorNumeric();
        boolean z = true;
        try {
            z = true ^ this.mPhone.getContext().getResources().getBoolean(17891610);
        } catch (Resources.NotFoundException unused) {
            log("buildWaitingApns: usePreferred NotFoundException set to true");
        }
        if (z) {
            this.mPreferredApn = getPreferredApn();
        }
        log("buildWaitingApns: usePreferred=" + z + " canSetPreferApn=" + this.mCanSetPreferApn + " mPreferredApn=" + this.mPreferredApn + " operator=" + operatorNumeric + " radioTech=" + i);
        if (z && this.mCanSetPreferApn && (apnSetting = this.mPreferredApn) != null && apnSetting.canHandleType(apnTypesBitmaskFromString)) {
            log("buildWaitingApns: Preferred APN:" + operatorNumeric + ":" + this.mPreferredApn.getOperatorNumeric() + ":" + this.mPreferredApn);
            if ((TextUtils.equals(this.mPreferredApn.getOperatorNumeric(), operatorNumeric) || this.mPreferredApn.getCarrierId() == this.mPhone.getCarrierId()) && this.mPreferredApn.canSupportNetworkType(ServiceState.rilRadioTechnologyToNetworkType(i))) {
                if (ApnSetting.getApnTypesBitmaskFromString(str) == 16384) {
                    arrayList.add(ApnSetting.makeApnSetting(this.mPreferredApn));
                } else {
                    arrayList.add(this.mPreferredApn);
                }
                log("buildWaitingApns: X added preferred apnList=" + arrayList);
                return arrayList;
            }
            log("buildWaitingApns: no preferred APN");
            setPreferredApn(-1);
            this.mPreferredApn = null;
        }
        log("buildWaitingApns: mAllApnSettings=" + this.mAllApnSettings);
        int preferredApnSetId = getPreferredApnSetId();
        Iterator<ApnSetting> it2 = this.mAllApnSettings.iterator();
        while (it2.hasNext()) {
            ApnSetting next = it2.next();
            if (next.canHandleType(apnTypesBitmaskFromString)) {
                if (!next.canSupportNetworkType(ServiceState.rilRadioTechnologyToNetworkType(i))) {
                    log("buildWaitingApns: networkTypeBitmask:" + next.getNetworkTypeBitmask() + " does not include radioTech:" + ServiceState.rilRadioTechnologyToString(i));
                } else if (next.getApnSetId() != -1 && preferredApnSetId != next.getApnSetId()) {
                    log("buildWaitingApns: APN set id " + next.getApnSetId() + " does not match the preferred set id " + preferredApnSetId);
                } else if (ApnSetting.getApnTypesBitmaskFromString(str) == 16384) {
                    arrayList.add(ApnSetting.makeApnSetting(next));
                } else {
                    arrayList.add(next);
                }
            }
        }
        log("buildWaitingApns: " + arrayList.size() + " APNs in the list: " + arrayList);
        return arrayList;
    }

    private String apnListToString(ArrayList<ApnSetting> arrayList) {
        StringBuilder sb = new StringBuilder();
        int size = arrayList.size();
        for (int i = 0; i < size; i++) {
            sb.append('[');
            sb.append(arrayList.get(i).toString());
            sb.append(']');
        }
        return sb.toString();
    }

    private void setPreferredApn(int i) {
        setPreferredApn(i, false);
    }

    private void setPreferredApn(int i, boolean z) {
        if (z || this.mCanSetPreferApn) {
            Uri withAppendedPath = Uri.withAppendedPath(PREFERAPN_NO_UPDATE_URI_USING_SUBID, Long.toString((long) this.mPhone.getSubId()));
            log("setPreferredApn: delete");
            ContentResolver contentResolver = this.mPhone.getContext().getContentResolver();
            contentResolver.delete(withAppendedPath, (String) null, (String[]) null);
            if (i >= 0) {
                log("setPreferredApn: insert");
                ContentValues contentValues = new ContentValues();
                contentValues.put(APN_ID, Integer.valueOf(i));
                contentResolver.insert(withAppendedPath, contentValues);
                return;
            }
            return;
        }
        log("setPreferredApn: X !canSEtPreferApn");
    }

    /* access modifiers changed from: package-private */
    public ApnSetting getPreferredApn() {
        ArrayList<ApnSetting> arrayList = this.mAllApnSettings;
        if (arrayList == null || arrayList.isEmpty()) {
            log("getPreferredApn: mAllApnSettings is empty");
            return null;
        }
        Cursor query = this.mPhone.getContext().getContentResolver().query(Uri.withAppendedPath(PREFERAPN_NO_UPDATE_URI_USING_SUBID, Long.toString((long) this.mPhone.getSubId())), new String[]{"_id", XmlTagConst.TAG_CHANNEL_NAME, "apn"}, (String) null, (String[]) null, "name ASC");
        if (query != null) {
            this.mCanSetPreferApn = true;
        } else {
            this.mCanSetPreferApn = false;
        }
        if (this.mCanSetPreferApn && query.getCount() > 0) {
            query.moveToFirst();
            int i = query.getInt(query.getColumnIndexOrThrow("_id"));
            Iterator<ApnSetting> it = this.mAllApnSettings.iterator();
            while (it.hasNext()) {
                ApnSetting next = it.next();
                if (next.getId() == i && next.canHandleType(this.mRequestedApnType)) {
                    log("getPreferredApn: For APN type " + ApnSetting.getApnTypeString(this.mRequestedApnType) + " found apnSetting " + next);
                    query.close();
                    return next;
                }
            }
        }
        if (query != null) {
            query.close();
        }
        log("getPreferredApn: X not found");
        return null;
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v49, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v2, resolved type: java.lang.String} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleMessage(android.os.Message r13) {
        /*
            r12 = this;
            int r0 = r13.what
            r1 = 17
            r2 = 2
            r3 = 0
            r4 = 1
            r5 = 0
            switch(r0) {
                case 270336: goto L_0x041a;
                case 270337: goto L_0x0416;
                case 270338: goto L_0x000b;
                case 270339: goto L_0x040c;
                case 270340: goto L_0x000b;
                case 270341: goto L_0x000b;
                case 270342: goto L_0x0408;
                case 270343: goto L_0x0404;
                case 270344: goto L_0x0400;
                case 270345: goto L_0x03fc;
                case 270346: goto L_0x000b;
                case 270347: goto L_0x03f8;
                case 270348: goto L_0x03f4;
                case 270349: goto L_0x03e7;
                case 270350: goto L_0x03de;
                case 270351: goto L_0x03a4;
                case 270352: goto L_0x039f;
                case 270353: goto L_0x0398;
                case 270354: goto L_0x0391;
                case 270355: goto L_0x038c;
                case 270356: goto L_0x000b;
                case 270357: goto L_0x000b;
                case 270358: goto L_0x036c;
                case 270359: goto L_0x0314;
                case 270360: goto L_0x0306;
                case 270361: goto L_0x000b;
                case 270362: goto L_0x0301;
                case 270363: goto L_0x000b;
                case 270364: goto L_0x000b;
                case 270365: goto L_0x02ee;
                case 270366: goto L_0x000b;
                case 270367: goto L_0x000b;
                case 270368: goto L_0x000b;
                case 270369: goto L_0x000b;
                case 270370: goto L_0x000b;
                case 270371: goto L_0x02c6;
                case 270372: goto L_0x0220;
                case 270373: goto L_0x01c8;
                case 270374: goto L_0x017f;
                case 270375: goto L_0x0126;
                case 270376: goto L_0x010e;
                case 270377: goto L_0x00fa;
                case 270378: goto L_0x00ed;
                case 270379: goto L_0x000b;
                case 270380: goto L_0x00e0;
                case 270381: goto L_0x00d7;
                case 270382: goto L_0x00b6;
                case 270383: goto L_0x0085;
                case 270384: goto L_0x03f8;
                case 270385: goto L_0x0074;
                case 270386: goto L_0x0055;
                case 270387: goto L_0x0050;
                case 270388: goto L_0x0048;
                case 270389: goto L_0x0041;
                case 270390: goto L_0x003c;
                case 270391: goto L_0x0035;
                case 270392: goto L_0x0028;
                case 270393: goto L_0x0023;
                default: goto L_0x000b;
            }
        L_0x000b:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder
            r12.<init>()
            java.lang.String r0 = "Unhandled event="
            r12.append(r0)
            r12.append(r13)
            java.lang.String r12 = r12.toString()
            java.lang.String r13 = "DcTracker"
            com.android.telephony.Rlog.e(r13, r12)
            goto L_0x0456
        L_0x0023:
            r12.onTrafficDescriptorsUpdated()
            goto L_0x0456
        L_0x0028:
            java.lang.Object r13 = r13.obj
            android.os.AsyncResult r13 = (android.os.AsyncResult) r13
            java.lang.Object r13 = r13.result
            java.lang.String r13 = (java.lang.String) r13
            r12.onApnUnthrottled(r13)
            goto L_0x0456
        L_0x0035:
            int r13 = r13.arg1
            r12.onSimStateUpdated(r13)
            goto L_0x0456
        L_0x003c:
            r12.onCarrierConfigChanged()
            goto L_0x0456
        L_0x0041:
            r12.mWatchdog = r5
            r12.reevaluateUnmeteredConnections()
            goto L_0x0456
        L_0x0048:
            r12.reevaluateCongestedConnections()
            r12.reevaluateUnmeteredConnections()
            goto L_0x0456
        L_0x0050:
            r12.onDataEnabledOverrideRulesChanged()
            goto L_0x0456
        L_0x0055:
            com.android.internal.telephony.Phone r12 = r12.mPhone
            android.content.Context r12 = r12.getContext()
            android.content.SharedPreferences r12 = android.preference.PreferenceManager.getDefaultSharedPreferences(r12)
            java.lang.String r13 = "data_roaming_is_user_setting_key"
            boolean r0 = r12.contains(r13)
            if (r0 != 0) goto L_0x0456
            android.content.SharedPreferences$Editor r12 = r12.edit()
            android.content.SharedPreferences$Editor r12 = r12.putBoolean(r13, r5)
            r12.commit()
            goto L_0x0456
        L_0x0074:
            java.lang.Object r13 = r13.obj
            android.os.AsyncResult r13 = (android.os.AsyncResult) r13
            java.lang.Object r13 = r13.result
            java.lang.Boolean r13 = (java.lang.Boolean) r13
            boolean r13 = r13.booleanValue()
            r12.onDataServiceBindingChanged(r13)
            goto L_0x0456
        L_0x0085:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_DATA_RECONNECT: subId="
            r0.append(r1)
            int r1 = r13.arg1
            r0.append(r1)
            java.lang.String r1 = ", type="
            r0.append(r1)
            int r1 = r13.arg2
            java.lang.String r1 = requestTypeToString(r1)
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            r12.log(r0)
            java.lang.Object r0 = r13.obj
            com.android.internal.telephony.dataconnection.ApnContext r0 = (com.android.internal.telephony.dataconnection.ApnContext) r0
            int r1 = r13.arg1
            int r13 = r13.arg2
            r12.onDataReconnect(r0, r1, r13)
            goto L_0x0456
        L_0x00b6:
            java.lang.Object r13 = r13.obj
            android.os.AsyncResult r13 = (android.os.AsyncResult) r13
            java.lang.Object r13 = r13.result
            boolean r0 = r13 instanceof android.util.Pair
            if (r0 == 0) goto L_0x0456
            android.util.Pair r13 = (android.util.Pair) r13
            java.lang.Object r0 = r13.first
            java.lang.Boolean r0 = (java.lang.Boolean) r0
            boolean r0 = r0.booleanValue()
            java.lang.Object r13 = r13.second
            java.lang.Integer r13 = (java.lang.Integer) r13
            int r13 = r13.intValue()
            r12.onDataEnabledChanged(r0, r13)
            goto L_0x0456
        L_0x00d7:
            java.lang.Object r13 = r13.obj
            android.os.AsyncResult r13 = (android.os.AsyncResult) r13
            r12.handlePcoData(r13)
            goto L_0x0456
        L_0x00e0:
            int r0 = r13.arg1
            int r1 = r13.arg2
            java.lang.Object r13 = r13.obj
            java.lang.String r13 = (java.lang.String) r13
            r12.onNetworkStatusChanged(r0, r1, r13)
            goto L_0x0456
        L_0x00ed:
            android.app.ProgressDialog r0 = r12.mProvisioningSpinner
            java.lang.Object r13 = r13.obj
            if (r0 != r13) goto L_0x0456
            r0.dismiss()
            r12.mProvisioningSpinner = r3
            goto L_0x0456
        L_0x00fa:
            int r13 = r12.getDataRat()
            if (r13 != 0) goto L_0x0102
            goto L_0x0456
        L_0x0102:
            java.lang.String r13 = "nwTypeChanged"
            r12.cleanUpConnectionsOnUpdatedApns(r5, r13)
            com.android.internal.telephony.dataconnection.DcTracker$RetryFailures r0 = com.android.internal.telephony.dataconnection.DcTracker.RetryFailures.ONLY_ON_CHANGE
            r12.setupDataOnAllConnectableApns(r13, r0)
            goto L_0x0456
        L_0x010e:
            int r0 = r13.arg1
            if (r0 != r4) goto L_0x011b
            java.lang.Object r13 = r13.obj
            com.android.internal.telephony.DctConstants$Activity r13 = (com.android.internal.telephony.DctConstants.Activity) r13
            r12.handleStartNetStatPoll(r13)
            goto L_0x0456
        L_0x011b:
            if (r0 != 0) goto L_0x0456
            java.lang.Object r13 = r13.obj
            com.android.internal.telephony.DctConstants$Activity r13 = (com.android.internal.telephony.DctConstants.Activity) r13
            r12.handleStopNetStatPoll(r13)
            goto L_0x0456
        L_0x0126:
            java.lang.String r0 = "EVENT_PROVISIONING_APN_ALARM"
            r12.log(r0)
            android.util.SparseArray<com.android.internal.telephony.dataconnection.ApnContext> r0 = r12.mApnContextsByType
            java.lang.Object r0 = r0.get(r1)
            com.android.internal.telephony.dataconnection.ApnContext r0 = (com.android.internal.telephony.dataconnection.ApnContext) r0
            boolean r1 = r0.isProvisioningApn()
            if (r1 == 0) goto L_0x0178
            boolean r1 = r0.isConnectedOrConnecting()
            if (r1 == 0) goto L_0x0178
            int r1 = r12.mProvisioningApnAlarmTag
            int r6 = r13.arg1
            if (r1 != r6) goto L_0x0156
            java.lang.String r13 = "EVENT_PROVISIONING_APN_ALARM: Disconnecting"
            r12.log(r13)
            r12.mIsProvisioning = r5
            r12.mProvisioningUrl = r3
            r12.stopProvisioningApnAlarm()
            r12.cleanUpConnectionInternal(r4, r2, r0)
            goto L_0x0456
        L_0x0156:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_PROVISIONING_APN_ALARM: ignore stale tag, mProvisioningApnAlarmTag:"
            r0.append(r1)
            int r1 = r12.mProvisioningApnAlarmTag
            r0.append(r1)
            java.lang.String r1 = " != arg1:"
            r0.append(r1)
            int r13 = r13.arg1
            r0.append(r13)
            java.lang.String r13 = r0.toString()
            r12.log(r13)
            goto L_0x0456
        L_0x0178:
            java.lang.String r13 = "EVENT_PROVISIONING_APN_ALARM: Not connected ignore"
            r12.log(r13)
            goto L_0x0456
        L_0x017f:
            java.lang.String r0 = "CMD_IS_PROVISIONING_APN"
            r12.log(r0)
            android.os.Bundle r0 = r13.getData()     // Catch:{ ClassCastException -> 0x01a5 }
            if (r0 == 0) goto L_0x0193
            java.lang.String r1 = "apnType"
            java.lang.Object r0 = r0.get(r1)     // Catch:{ ClassCastException -> 0x01a5 }
            r3 = r0
            java.lang.String r3 = (java.lang.String) r3     // Catch:{ ClassCastException -> 0x01a5 }
        L_0x0193:
            boolean r0 = android.text.TextUtils.isEmpty(r3)     // Catch:{ ClassCastException -> 0x01a5 }
            if (r0 == 0) goto L_0x019f
            java.lang.String r0 = "CMD_IS_PROVISIONING_APN: apnType is empty"
            r12.loge(r0)     // Catch:{ ClassCastException -> 0x01a5 }
            goto L_0x01aa
        L_0x019f:
            boolean r0 = r12.isProvisioningApn(r3)     // Catch:{ ClassCastException -> 0x01a5 }
            r5 = r0
            goto L_0x01aa
        L_0x01a5:
            java.lang.String r0 = "CMD_IS_PROVISIONING_APN: NO provisioning url ignoring"
            r12.loge(r0)
        L_0x01aa:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "CMD_IS_PROVISIONING_APN: ret="
            r0.append(r1)
            r0.append(r5)
            java.lang.String r0 = r0.toString()
            r12.log(r0)
            com.android.internal.telephony.AsyncChannel r12 = r12.mReplyAc
            r0 = 270374(0x42026, float:3.78875E-40)
            r12.replyToMessage((android.os.Message) r13, (int) r0, (int) r5)
            goto L_0x0456
        L_0x01c8:
            android.os.Bundle r13 = r13.getData()
            if (r13 == 0) goto L_0x01f0
            java.lang.String r0 = "provisioningUrl"
            java.lang.Object r13 = r13.get(r0)     // Catch:{ ClassCastException -> 0x01d9 }
            java.lang.String r13 = (java.lang.String) r13     // Catch:{ ClassCastException -> 0x01d9 }
            r12.mProvisioningUrl = r13     // Catch:{ ClassCastException -> 0x01d9 }
            goto L_0x01f0
        L_0x01d9:
            r13 = move-exception
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "CMD_ENABLE_MOBILE_PROVISIONING: provisioning url not a string"
            r0.append(r1)
            r0.append(r13)
            java.lang.String r13 = r0.toString()
            r12.loge(r13)
            r12.mProvisioningUrl = r3
        L_0x01f0:
            java.lang.String r13 = r12.mProvisioningUrl
            boolean r13 = android.text.TextUtils.isEmpty(r13)
            if (r13 == 0) goto L_0x0203
            java.lang.String r13 = "CMD_ENABLE_MOBILE_PROVISIONING: provisioning url is empty, ignoring"
            r12.loge(r13)
            r12.mIsProvisioning = r5
            r12.mProvisioningUrl = r3
            goto L_0x0456
        L_0x0203:
            java.lang.StringBuilder r13 = new java.lang.StringBuilder
            r13.<init>()
            java.lang.String r0 = "CMD_ENABLE_MOBILE_PROVISIONING: provisioningUrl="
            r13.append(r0)
            java.lang.String r0 = r12.mProvisioningUrl
            r13.append(r0)
            java.lang.String r13 = r13.toString()
            r12.loge(r13)
            r12.mIsProvisioning = r4
            r12.startProvisioningApnAlarm()
            goto L_0x0456
        L_0x0220:
            int r0 = sEnableFailFastRefCounter
            int r13 = r13.arg1
            if (r13 != r4) goto L_0x0228
            r13 = r4
            goto L_0x0229
        L_0x0228:
            r13 = -1
        L_0x0229:
            int r0 = r0 + r13
            sEnableFailFastRefCounter = r0
            java.lang.StringBuilder r13 = new java.lang.StringBuilder
            r13.<init>()
            java.lang.String r0 = "CMD_SET_ENABLE_FAIL_FAST_MOBILE_DATA:  sEnableFailFastRefCounter="
            r13.append(r0)
            int r0 = sEnableFailFastRefCounter
            r13.append(r0)
            java.lang.String r13 = r13.toString()
            r12.log(r13)
            int r13 = sEnableFailFastRefCounter
            if (r13 >= 0) goto L_0x0263
            java.lang.StringBuilder r13 = new java.lang.StringBuilder
            r13.<init>()
            java.lang.String r0 = "CMD_SET_ENABLE_FAIL_FAST_MOBILE_DATA: sEnableFailFastRefCounter:"
            r13.append(r0)
            int r0 = sEnableFailFastRefCounter
            r13.append(r0)
            java.lang.String r0 = " < 0"
            r13.append(r0)
            java.lang.String r13 = r13.toString()
            r12.loge(r13)
            sEnableFailFastRefCounter = r5
        L_0x0263:
            int r13 = sEnableFailFastRefCounter
            if (r13 <= 0) goto L_0x0269
            r13 = r4
            goto L_0x026a
        L_0x0269:
            r13 = r5
        L_0x026a:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "CMD_SET_ENABLE_FAIL_FAST_MOBILE_DATA: enabled="
            r0.append(r1)
            r0.append(r13)
            java.lang.String r1 = " sEnableFailFastRefCounter="
            r0.append(r1)
            int r1 = sEnableFailFastRefCounter
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            r12.log(r0)
            boolean r0 = r12.mFailFast
            if (r0 == r13) goto L_0x0456
            r12.mFailFast = r13
            r13 = r13 ^ r4
            r12.mDataStallNoRxEnabled = r13
            com.android.internal.telephony.dataconnection.DcTracker$DataStallRecoveryHandler r13 = r12.mDsRecoveryHandler
            boolean r13 = r13.isNoRxDataStallDetectionEnabled()
            if (r13 == 0) goto L_0x02bc
            boolean r13 = r12.isAnyDataConnected()
            if (r13 == 0) goto L_0x02bc
            boolean r13 = r12.mInVoiceCall
            if (r13 == 0) goto L_0x02af
            com.android.internal.telephony.Phone r13 = r12.mPhone
            com.android.internal.telephony.ServiceStateTracker r13 = r13.getServiceStateTracker()
            boolean r13 = r13.isConcurrentVoiceAndDataAllowed()
            if (r13 == 0) goto L_0x02bc
        L_0x02af:
            java.lang.String r13 = "CMD_SET_ENABLE_FAIL_FAST_MOBILE_DATA: start data stall"
            r12.log(r13)
            r12.stopDataStallAlarm()
            r12.startDataStallAlarm(r5)
            goto L_0x0456
        L_0x02bc:
            java.lang.String r13 = "CMD_SET_ENABLE_FAIL_FAST_MOBILE_DATA: stop data stall"
            r12.log(r13)
            r12.stopDataStallAlarm()
            goto L_0x0456
        L_0x02c6:
            java.lang.Object r0 = r13.obj
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0
            java.lang.Object r0 = r0.userObj
            android.util.Pair r0 = (android.util.Pair) r0
            java.lang.Object r1 = r0.first
            com.android.internal.telephony.dataconnection.ApnContext r1 = (com.android.internal.telephony.dataconnection.ApnContext) r1
            java.lang.Object r0 = r0.second
            java.lang.Integer r0 = (java.lang.Integer) r0
            int r0 = r0.intValue()
            int r13 = r13.arg2
            int r2 = r1.getConnectionGeneration()
            if (r2 != r0) goto L_0x02e7
            r12.onDataSetupCompleteError(r1, r13, r5)
            goto L_0x0456
        L_0x02e7:
            java.lang.String r13 = "EVENT_DATA_SETUP_COMPLETE_ERROR: Dropped the event because generation did not match."
            r12.loge(r13)
            goto L_0x0456
        L_0x02ee:
            java.lang.Object r0 = r13.obj
            if (r0 == 0) goto L_0x02f8
            boolean r0 = r0 instanceof java.lang.String
            if (r0 != 0) goto L_0x02f8
            r13.obj = r3
        L_0x02f8:
            java.lang.Object r13 = r13.obj
            java.lang.String r13 = (java.lang.String) r13
            r12.cleanUpAllConnectionsInternal(r4, r13)
            goto L_0x0456
        L_0x0301:
            r12.restartRadio()
            goto L_0x0456
        L_0x0306:
            java.lang.String r0 = "EVENT_CLEAN_UP_CONNECTION"
            r12.log(r0)
            java.lang.Object r13 = r13.obj
            com.android.internal.telephony.dataconnection.ApnContext r13 = (com.android.internal.telephony.dataconnection.ApnContext) r13
            r12.cleanUpConnectionInternal(r4, r2, r13)
            goto L_0x0456
        L_0x0314:
            java.lang.StringBuilder r13 = new java.lang.StringBuilder
            r13.<init>()
            java.lang.String r0 = "EVENT_PS_RESTRICT_DISABLED "
            r13.append(r0)
            boolean r0 = r12.mIsPsRestricted
            r13.append(r0)
            java.lang.String r13 = r13.toString()
            r12.log(r13)
            r12.mIsPsRestricted = r5
            boolean r13 = r12.isAnyDataConnected()
            if (r13 == 0) goto L_0x033a
            r12.startNetStatPoll()
            r12.startDataStallAlarm(r5)
            goto L_0x0456
        L_0x033a:
            com.android.internal.telephony.DctConstants$State r13 = r12.mState
            com.android.internal.telephony.DctConstants$State r0 = com.android.internal.telephony.DctConstants.State.FAILED
            java.lang.String r2 = "psRestrictEnabled"
            if (r13 != r0) goto L_0x0347
            r12.cleanUpAllConnectionsInternal(r5, r2)
            r12.mReregisterOnReconnectFailure = r5
        L_0x0347:
            android.util.SparseArray<com.android.internal.telephony.dataconnection.ApnContext> r13 = r12.mApnContextsByType
            java.lang.Object r13 = r13.get(r1)
            com.android.internal.telephony.dataconnection.ApnContext r13 = (com.android.internal.telephony.dataconnection.ApnContext) r13
            if (r13 == 0) goto L_0x0359
            r13.setReason(r2)
            r12.trySetupData(r13, r4, r3)
            goto L_0x0456
        L_0x0359:
            java.lang.String r13 = "**** Default ApnContext not found ****"
            r12.loge(r13)
            boolean r12 = com.android.internal.telephony.util.TelephonyUtils.IS_DEBUGGABLE
            if (r12 != 0) goto L_0x0364
            goto L_0x0456
        L_0x0364:
            java.lang.RuntimeException r12 = new java.lang.RuntimeException
            java.lang.String r13 = "Default ApnContext not found"
            r12.<init>(r13)
            throw r12
        L_0x036c:
            java.lang.StringBuilder r13 = new java.lang.StringBuilder
            r13.<init>()
            java.lang.String r0 = "EVENT_PS_RESTRICT_ENABLED "
            r13.append(r0)
            boolean r0 = r12.mIsPsRestricted
            r13.append(r0)
            java.lang.String r13 = r13.toString()
            r12.log(r13)
            r12.stopNetStatPoll()
            r12.stopDataStallAlarm()
            r12.mIsPsRestricted = r4
            goto L_0x0456
        L_0x038c:
            r12.onApnChanged()
            goto L_0x0456
        L_0x0391:
            com.android.internal.telephony.dataconnection.DcTracker$DataStallRecoveryHandler r12 = r12.mDsRecoveryHandler
            r12.doRecovery()
            goto L_0x0456
        L_0x0398:
            int r13 = r13.arg1
            r12.onDataStallAlarm(r13)
            goto L_0x0456
        L_0x039f:
            r12.onDataConnectionAttached()
            goto L_0x0456
        L_0x03a4:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_DISCONNECT_DONE msg="
            r0.append(r1)
            r0.append(r13)
            java.lang.String r0 = r0.toString()
            r12.log(r0)
            java.lang.Object r13 = r13.obj
            android.os.AsyncResult r13 = (android.os.AsyncResult) r13
            java.lang.Object r13 = r13.userObj
            android.util.Pair r13 = (android.util.Pair) r13
            java.lang.Object r0 = r13.first
            com.android.internal.telephony.dataconnection.ApnContext r0 = (com.android.internal.telephony.dataconnection.ApnContext) r0
            java.lang.Object r13 = r13.second
            java.lang.Integer r13 = (java.lang.Integer) r13
            int r13 = r13.intValue()
            int r1 = r0.getConnectionGeneration()
            if (r1 != r13) goto L_0x03d7
            r12.onDisconnectDone(r0)
            goto L_0x0456
        L_0x03d7:
            java.lang.String r13 = "EVENT_DISCONNECT_DONE: Dropped the event because generation did not match."
            r12.loge(r13)
            goto L_0x0456
        L_0x03de:
            int r0 = r13.arg1
            int r13 = r13.arg2
            r12.onDisableApn(r0, r13)
            goto L_0x0456
        L_0x03e7:
            int r0 = r13.arg1
            int r1 = r13.arg2
            java.lang.Object r13 = r13.obj
            android.os.Message r13 = (android.os.Message) r13
            r12.onEnableApn(r0, r1, r13)
            goto L_0x0456
        L_0x03f4:
            r12.onDataRoamingOff()
            goto L_0x0456
        L_0x03f8:
            r12.onDataRoamingOnOrSettingsChanged(r0)
            goto L_0x0456
        L_0x03fc:
            r12.onDataConnectionDetached()
            goto L_0x0456
        L_0x0400:
            r12.onVoiceCallEnded()
            goto L_0x0456
        L_0x0404:
            r12.onVoiceCallStarted()
            goto L_0x0456
        L_0x0408:
            r12.onRadioOffOrNotAvailable()
            goto L_0x0456
        L_0x040c:
            java.lang.Object r0 = r13.obj
            com.android.internal.telephony.dataconnection.ApnContext r0 = (com.android.internal.telephony.dataconnection.ApnContext) r0
            int r13 = r13.arg1
            r12.trySetupData(r0, r13, r3)
            goto L_0x0456
        L_0x0416:
            r12.onRadioAvailable()
            goto L_0x0456
        L_0x041a:
            java.lang.Object r0 = r13.obj
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0
            java.lang.Object r1 = r0.userObj
            android.util.Pair r1 = (android.util.Pair) r1
            java.lang.Object r2 = r1.first
            r7 = r2
            com.android.internal.telephony.dataconnection.ApnContext r7 = (com.android.internal.telephony.dataconnection.ApnContext) r7
            java.lang.Object r1 = r1.second
            java.lang.Integer r1 = (java.lang.Integer) r1
            int r1 = r1.intValue()
            int r10 = r13.arg1
            int r11 = r13.arg2
            int r13 = r7.getConnectionGeneration()
            if (r13 != r1) goto L_0x0451
            r13 = 65536(0x10000, float:9.18355E-41)
            java.lang.Throwable r1 = r0.exception
            if (r1 == 0) goto L_0x044a
            java.lang.Object r13 = r0.result
            java.lang.Integer r13 = (java.lang.Integer) r13
            int r13 = r13.intValue()
            r9 = r13
            r8 = r5
            goto L_0x044c
        L_0x044a:
            r9 = r13
            r8 = r4
        L_0x044c:
            r6 = r12
            r6.onDataSetupComplete(r7, r8, r9, r10, r11)
            goto L_0x0456
        L_0x0451:
            java.lang.String r13 = "EVENT_DATA_SETUP_COMPLETE: Dropped the event because generation did not match."
            r12.loge(r13)
        L_0x0456:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DcTracker.handleMessage(android.os.Message):void");
    }

    private int getApnProfileID(String str) {
        if (TextUtils.equals(str, "ims")) {
            return 2;
        }
        if (TextUtils.equals(str, "fota")) {
            return 3;
        }
        if (TextUtils.equals(str, "cbs")) {
            return 4;
        }
        if (!TextUtils.equals(str, "ia") && TextUtils.equals(str, "dun")) {
            return 1;
        }
        return 0;
    }

    private int getCellLocationId() {
        CellLocation asCellLocation = this.mPhone.getCurrentCellIdentity().asCellLocation();
        if (asCellLocation != null) {
            if (asCellLocation instanceof GsmCellLocation) {
                return ((GsmCellLocation) asCellLocation).getCid();
            }
            if (asCellLocation instanceof CdmaCellLocation) {
                return ((CdmaCellLocation) asCellLocation).getBaseStationId();
            }
        }
        return -1;
    }

    private void updateLinkBandwidths(String[] strArr, boolean z) {
        Pair pair;
        int i;
        int i2;
        ConcurrentHashMap<String, Pair<Integer, Integer>> concurrentHashMap = new ConcurrentHashMap<>();
        for (String split : strArr) {
            String[] split2 = split.split(":");
            if (split2.length == 2) {
                String[] split3 = split2[1].split(",");
                int i3 = 14;
                if (split3.length == 2) {
                    try {
                        i2 = Integer.parseInt(split3[0]);
                        try {
                            i3 = Integer.parseInt(split3[1]);
                        } catch (NumberFormatException unused) {
                        }
                    } catch (NumberFormatException unused2) {
                        i2 = 14;
                    }
                    i = i3;
                    i3 = i2;
                } else {
                    i = 14;
                }
                concurrentHashMap.put(split2[0], new Pair(Integer.valueOf(i3), Integer.valueOf(i)));
            }
        }
        if (z && (pair = concurrentHashMap.get(DataConfigManager.DATA_CONFIG_NETWORK_TYPE_LTE)) != null) {
            if (concurrentHashMap.containsKey(DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA)) {
                concurrentHashMap.put(DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA, new Pair((Integer) concurrentHashMap.get(DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA).first, (Integer) pair.second));
            }
            if (concurrentHashMap.containsKey(DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE)) {
                concurrentHashMap.put(DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE, new Pair((Integer) concurrentHashMap.get(DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE).first, (Integer) pair.second));
            }
        }
        this.mBandwidths = concurrentHashMap;
        for (DataConnection sendMessage : this.mDataConnections.values()) {
            sendMessage.sendMessage(262174);
        }
    }

    public Pair<Integer, Integer> getLinkBandwidthsFromCarrierConfig(String str) {
        return this.mBandwidths.get(str);
    }

    @VisibleForTesting
    public boolean shouldAutoAttach() {
        if (this.mAutoAttachEnabled.get()) {
            return true;
        }
        PhoneSwitcher instance = PhoneSwitcher.getInstance();
        ServiceState serviceState = this.mPhone.getServiceState();
        if (instance == null || serviceState == null || serviceState.getState() != 0 || serviceState.getVoiceNetworkType() == 13 || serviceState.getVoiceNetworkType() == 20) {
            return false;
        }
        if (this.mPhone.getPhoneId() == instance.getPreferredDataPhoneId() && this.mPhone.getState() == PhoneConstants.State.IDLE) {
            return false;
        }
        return true;
    }

    private void notifyAllDataDisconnected() {
        sEnableFailFastRefCounter = 0;
        this.mFailFast = false;
        log("notify all data disconnected");
        this.mAllDataDisconnectedRegistrants.notifyRegistrants();
    }

    public void registerForAllDataDisconnected(Handler handler, int i) {
        this.mAllDataDisconnectedRegistrants.addUnique(handler, i, (Object) null);
        if (areAllDataDisconnected()) {
            notifyAllDataDisconnected();
        }
    }

    public void unregisterForAllDataDisconnected(Handler handler) {
        this.mAllDataDisconnectedRegistrants.remove(handler);
    }

    private void onDataEnabledChanged(boolean z, int i) {
        log("onDataEnabledChanged: enable=" + z + ", enabledChangedReason=" + i);
        if (z) {
            reevaluateDataConnections();
            setupDataOnAllConnectableApns(PhoneInternalInterface.REASON_DATA_ENABLED, RetryFailures.ALWAYS);
            return;
        }
        cleanUpAllConnectionsInternal(true, i != 1 ? i != 4 ? PhoneInternalInterface.REASON_DATA_SPECIFIC_DISABLED : PhoneInternalInterface.REASON_CARRIER_ACTION_DISABLE_METERED_APN : PhoneInternalInterface.REASON_DATA_DISABLED_INTERNAL);
    }

    /* access modifiers changed from: private */
    public void reevaluateCongestedConnections() {
        log("reevaluateCongestedConnections");
        boolean z = this.mCongestedOverride && (this.mCongestedNetworkTypes.contains(Integer.valueOf(this.mPhone.getDisplayInfoController().getTelephonyDisplayInfo().getNetworkType())) || this.mCongestedNetworkTypes.containsAll((Collection) Arrays.stream(TelephonyManager.getAllNetworkTypes()).boxed().collect(Collectors.toSet())));
        for (DataConnection onCongestednessChanged : this.mDataConnections.values()) {
            onCongestednessChanged.onCongestednessChanged(z);
        }
    }

    /* access modifiers changed from: private */
    public void reevaluateUnmeteredConnections() {
        log("reevaluateUnmeteredConnections");
        int networkType = this.mPhone.getDisplayInfoController().getTelephonyDisplayInfo().getNetworkType();
        if (!isNrUnmetered() || (this.mPhone.getServiceState().getRoaming() && !this.mNrNsaRoamingUnmetered)) {
            stopWatchdogAlarm();
            setDataConnectionUnmetered(isNetworkTypeUnmetered(networkType));
            return;
        }
        setDataConnectionUnmetered(true);
        if (!this.mWatchdog) {
            startWatchdogAlarm();
        }
    }

    private void setDataConnectionUnmetered(boolean z) {
        if (!z || isTempNotMeteredSupportedByCarrier()) {
            for (DataConnection onMeterednessChanged : this.mDataConnections.values()) {
                onMeterednessChanged.onMeterednessChanged(z);
            }
        }
    }

    private boolean isNetworkTypeUnmetered(int i) {
        List<Integer> list = this.mUnmeteredNetworkTypes;
        if (list == null || !this.mUnmeteredOverride) {
            boolean isNetworkTypeUnmeteredViaSubscriptionPlan = isNetworkTypeUnmeteredViaSubscriptionPlan(i);
            log("isNetworkTypeUnmeteredViaSubscriptionPlan: networkType=" + i + ", isUnmetered=" + isNetworkTypeUnmeteredViaSubscriptionPlan);
            return isNetworkTypeUnmeteredViaSubscriptionPlan;
        }
        boolean z = list.contains(Integer.valueOf(i)) || this.mUnmeteredNetworkTypes.containsAll((Collection) Arrays.stream(TelephonyManager.getAllNetworkTypes()).boxed().collect(Collectors.toSet()));
        log("isNetworkTypeUnmetered: networkType=" + i + ", isUnmetered=" + z);
        return z;
    }

    private boolean isNetworkTypeUnmeteredViaSubscriptionPlan(int i) {
        if (this.mSubscriptionPlans.isEmpty()) {
            return false;
        }
        Set set = (Set) Arrays.stream(TelephonyManager.getAllNetworkTypes()).boxed().collect(Collectors.toSet());
        boolean z = true;
        for (SubscriptionPlan next : this.mSubscriptionPlans) {
            if (((Set) Arrays.stream(next.getNetworkTypes()).boxed().collect(Collectors.toSet())).containsAll(set)) {
                if (!isPlanUnmetered(next)) {
                    z = false;
                }
            } else if (i != 0) {
                for (int i2 : next.getNetworkTypes()) {
                    if (i2 == i) {
                        return isPlanUnmetered(next);
                    }
                }
                continue;
            } else {
                continue;
            }
        }
        return z;
    }

    private boolean isPlanUnmetered(SubscriptionPlan subscriptionPlan) {
        return subscriptionPlan.getDataLimitBytes() == Long.MAX_VALUE;
    }

    private boolean isNrUnmetered() {
        int networkType = this.mPhone.getDisplayInfoController().getTelephonyDisplayInfo().getNetworkType();
        int overrideNetworkType = this.mPhone.getDisplayInfoController().getTelephonyDisplayInfo().getOverrideNetworkType();
        if (isNetworkTypeUnmetered(20)) {
            if (this.mNrNsaMmwaveUnmetered) {
                if (overrideNetworkType != 5) {
                    return false;
                }
                log("NR unmetered for mmwave only");
                return true;
            } else if (this.mNrNsaSub6Unmetered) {
                if (overrideNetworkType != 3) {
                    return false;
                }
                log("NR unmetered for sub6 only");
                return true;
            } else if (overrideNetworkType != 5 && overrideNetworkType != 3 && networkType != 20) {
                return false;
            } else {
                log("NR unmetered for all frequencies");
                return true;
            }
        } else if (this.mNrNsaAllUnmetered) {
            if (this.mNrNsaMmwaveUnmetered) {
                if (overrideNetworkType != 5) {
                    return false;
                }
                log("NR NSA unmetered for mmwave only via carrier configs");
                return true;
            } else if (this.mNrNsaSub6Unmetered) {
                if (overrideNetworkType != 3) {
                    return false;
                }
                log("NR NSA unmetered for sub6 only via carrier configs");
                return true;
            } else if (overrideNetworkType != 5 && overrideNetworkType != 3) {
                return false;
            } else {
                log("NR NSA unmetered for all frequencies via carrier configs");
                return true;
            }
        } else if (!this.mNrSaAllUnmetered || networkType != 20) {
            return false;
        } else {
            log("NR SA unmetered for all frequencies via carrier configs");
            return true;
        }
    }

    private boolean isTempNotMeteredSupportedByCarrier() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService(CarrierConfigManager.class);
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            return false;
        }
        return configForSubId.getBoolean("network_temp_not_metered_supported_bool");
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("DcTracker:");
        printWriter.println(" RADIO_TESTS=false");
        printWriter.println(" mDataEnabledSettings=" + this.mDataEnabledSettings);
        printWriter.println(" isDataAllowed=" + isDataAllowed((DataConnectionReasons) null));
        printWriter.flush();
        printWriter.println(" mRequestedApnType=" + this.mRequestedApnType);
        printWriter.println(" mPhone=" + this.mPhone.getPhoneName());
        printWriter.println(" mConfigReady=" + this.mConfigReady);
        printWriter.println(" mSimState=" + SubscriptionInfoUpdater.simStateString(this.mSimState));
        printWriter.println(" mActivity=" + this.mActivity);
        printWriter.println(" mState=" + this.mState);
        printWriter.println(" mTxPkts=" + this.mTxPkts);
        printWriter.println(" mRxPkts=" + this.mRxPkts);
        printWriter.println(" mNetStatPollPeriod=" + this.mNetStatPollPeriod);
        printWriter.println(" mNetStatPollEnabled=" + this.mNetStatPollEnabled);
        printWriter.println(" mDataStallTxRxSum=" + this.mDataStallTxRxSum);
        printWriter.println(" mDataStallAlarmTag=" + this.mDataStallAlarmTag);
        printWriter.println(" mDataStallNoRxEnabled=" + this.mDataStallNoRxEnabled);
        printWriter.println(" mEmergencyApn=" + this.mEmergencyApn);
        printWriter.println(" mSentSinceLastRecv=" + this.mSentSinceLastRecv);
        printWriter.println(" mNoRecvPollCount=" + this.mNoRecvPollCount);
        printWriter.println(" mResolver=" + this.mResolver);
        printWriter.println(" mReconnectIntent=" + this.mReconnectIntent);
        printWriter.println(" mAutoAttachEnabled=" + this.mAutoAttachEnabled.get());
        printWriter.println(" mIsScreenOn=" + this.mIsScreenOn);
        printWriter.println(" mUniqueIdGenerator=" + this.mUniqueIdGenerator);
        printWriter.println(" mDataServiceBound=" + this.mDataServiceBound);
        printWriter.println(" mDataRoamingLeakageLog= ");
        this.mDataRoamingLeakageLog.dump(fileDescriptor, printWriter, strArr);
        printWriter.println(" mApnSettingsInitializationLog= ");
        this.mApnSettingsInitializationLog.dump(fileDescriptor, printWriter, strArr);
        printWriter.flush();
        printWriter.println(" ***************************************");
        DcController dcController = this.mDcc;
        if (dcController == null) {
            printWriter.println(" mDcc=null");
        } else if (this.mDataServiceBound) {
            dcController.dump(fileDescriptor, printWriter, strArr);
        } else {
            printWriter.println(" Can't dump mDcc because data service is not bound.");
        }
        printWriter.println(" ***************************************");
        HashMap<Integer, DataConnection> hashMap = this.mDataConnections;
        if (hashMap != null) {
            Set<Map.Entry<Integer, DataConnection>> entrySet = hashMap.entrySet();
            printWriter.println(" mDataConnections: count=" + entrySet.size());
            for (Map.Entry next : entrySet) {
                printWriter.printf(" *** mDataConnection[%d] \n", new Object[]{next.getKey()});
                ((DataConnection) next.getValue()).dump(fileDescriptor, printWriter, strArr);
            }
        } else {
            printWriter.println("mDataConnections=null");
        }
        printWriter.println(" ***************************************");
        printWriter.flush();
        HashMap<String, Integer> hashMap2 = this.mApnToDataConnectionId;
        if (hashMap2 != null) {
            Set<Map.Entry<String, Integer>> entrySet2 = hashMap2.entrySet();
            printWriter.println(" mApnToDataConnectonId size=" + entrySet2.size());
            for (Map.Entry next2 : entrySet2) {
                printWriter.printf(" mApnToDataConnectonId[%s]=%d\n", new Object[]{next2.getKey(), next2.getValue()});
            }
        } else {
            printWriter.println("mApnToDataConnectionId=null");
        }
        printWriter.println(" ***************************************");
        printWriter.flush();
        ConcurrentHashMap<String, ApnContext> concurrentHashMap = this.mApnContexts;
        if (concurrentHashMap != null) {
            Set<Map.Entry<String, ApnContext>> entrySet3 = concurrentHashMap.entrySet();
            printWriter.println(" mApnContexts size=" + entrySet3.size());
            for (Map.Entry<String, ApnContext> value : entrySet3) {
                ((ApnContext) value.getValue()).dump(fileDescriptor, printWriter, strArr);
            }
            ApnContext.dumpLocalLog(fileDescriptor, printWriter, strArr);
            printWriter.println(" ***************************************");
        } else {
            printWriter.println(" mApnContexts=null");
        }
        printWriter.flush();
        printWriter.println(" mAllApnSettings size=" + this.mAllApnSettings.size());
        for (int i = 0; i < this.mAllApnSettings.size(); i++) {
            printWriter.printf(" mAllApnSettings[%d]: %s\n", new Object[]{Integer.valueOf(i), this.mAllApnSettings.get(i)});
        }
        printWriter.flush();
        printWriter.println(" mPreferredApn=" + this.mPreferredApn);
        printWriter.println(" mIsPsRestricted=" + this.mIsPsRestricted);
        printWriter.println(" mIsDisposed=" + this.mIsDisposed);
        printWriter.println(" mIntentReceiver=" + this.mIntentReceiver);
        printWriter.println(" mReregisterOnReconnectFailure=" + this.mReregisterOnReconnectFailure);
        printWriter.println(" canSetPreferApn=" + this.mCanSetPreferApn);
        printWriter.println(" mApnObserver=" + this.mApnObserver);
        printWriter.println(" isAnyDataConnected=" + isAnyDataConnected());
        printWriter.println(" mAttached=" + this.mAttached.get());
        this.mDataEnabledSettings.dump(fileDescriptor, printWriter, strArr);
        printWriter.flush();
    }

    public String[] getPcscfAddress(String str) {
        ApnContext apnContext;
        log("getPcscfAddress()");
        if (str == null) {
            log("apnType is null, return null");
            return null;
        }
        if (TextUtils.equals(str, "emergency")) {
            apnContext = this.mApnContextsByType.get(512);
        } else if (TextUtils.equals(str, "ims")) {
            apnContext = this.mApnContextsByType.get(64);
        } else {
            log("apnType is invalid, return null");
            return null;
        }
        if (apnContext == null) {
            log("apnContext is null, return null");
            return null;
        }
        DataConnection dataConnection = apnContext.getDataConnection();
        if (dataConnection == null) {
            return null;
        }
        String[] pcscfAddresses = dataConnection.getPcscfAddresses();
        if (pcscfAddresses != null) {
            for (int i = 0; i < pcscfAddresses.length; i++) {
                log("Pcscf[" + i + "]: " + pcscfAddresses[i]);
            }
        }
        return pcscfAddresses;
    }

    private ApnSetting buildDefaultApnSetting(String str, String str2, int i) {
        return new ApnSetting.Builder().setEntryName(str).setProtocol(2).setRoamingProtocol(2).setApnName(str2).setApnTypeBitmask(i).setCarrierEnabled(true).setApnSetId(-1).build();
    }

    private void addDefaultApnSettingsAsNeeded() {
        Iterator<ApnSetting> it = this.mAllApnSettings.iterator();
        boolean z = false;
        boolean z2 = false;
        while (it.hasNext()) {
            ApnSetting next = it.next();
            if (next.canHandleType(512)) {
                z = true;
            }
            if (next.canHandleType(64)) {
                z2 = true;
            }
            if (z && z2) {
                log("Both emergency and ims apn setting are already present");
                return;
            }
        }
        if (!z) {
            this.mAllApnSettings.add(buildDefaultApnSetting("DEFAULT EIMS", "sos", 512));
            log("default emergency apn is created");
        }
        if (!z2 && this.mSimState == 10) {
            this.mAllApnSettings.add(buildDefaultApnSetting("DEFAULT IMS", "ims", 64));
            log("default ims apn is created");
        }
    }

    private void cleanUpConnectionsOnUpdatedApns(boolean z, String str) {
        boolean z2;
        log("cleanUpConnectionsOnUpdatedApns: detach=" + z);
        if (this.mAllApnSettings.isEmpty()) {
            cleanUpAllConnectionsInternal(z, PhoneInternalInterface.REASON_APN_CHANGED);
        } else if (getDataRat() != 0) {
            for (ApnContext next : this.mApnContexts.values()) {
                if (!next.isDisconnected()) {
                    ArrayList<ApnSetting> buildWaitingApns = buildWaitingApns(next.getApnType(), getDataRat());
                    if (next.getWaitingApns().size() != buildWaitingApns.size() || !next.getWaitingApns().containsAll(buildWaitingApns)) {
                        next.setWaitingApns(buildWaitingApns);
                    }
                    Iterator<ApnSetting> it = buildWaitingApns.iterator();
                    while (true) {
                        if (it.hasNext()) {
                            if (areCompatible(it.next(), next.getApnSetting())) {
                                z2 = false;
                                break;
                            }
                        } else {
                            z2 = true;
                            break;
                        }
                    }
                    if (z2) {
                        log("cleanUpConnectionsOnUpdatedApns: APN type " + next.getApnType() + " clean up is required. The new waiting APN list " + buildWaitingApns + " does not cover " + next.getApnSetting());
                        next.setReason(str);
                        cleanUpConnectionInternal(true, 2, next);
                    }
                }
            }
        } else {
            return;
        }
        if (!isAnyDataConnected()) {
            stopNetStatPoll();
            stopDataStallAlarm();
        }
        this.mRequestedApnType = 17;
        if (areAllDataDisconnected()) {
            notifyAllDataDisconnected();
        }
    }

    /* access modifiers changed from: protected */
    public void resetPollStats() {
        this.mTxPkts = -1;
        this.mRxPkts = -1;
        this.mNetStatPollPeriod = 1000;
    }

    /* access modifiers changed from: protected */
    public void startNetStatPoll() {
        if (isAnyDataConnected() && !this.mNetStatPollEnabled) {
            log("startNetStatPoll");
            resetPollStats();
            this.mNetStatPollEnabled = true;
            this.mPollNetStat.run();
        }
        Phone phone = this.mPhone;
        if (phone != null) {
            phone.notifyDataActivity();
        }
    }

    /* access modifiers changed from: protected */
    public void stopNetStatPoll() {
        this.mNetStatPollEnabled = false;
        removeCallbacks(this.mPollNetStat);
        log("stopNetStatPoll");
        Phone phone = this.mPhone;
        if (phone != null) {
            phone.notifyDataActivity();
        }
    }

    public void sendStartNetStatPoll(DctConstants.Activity activity) {
        Message obtainMessage = obtainMessage(270376);
        obtainMessage.arg1 = 1;
        obtainMessage.obj = activity;
        sendMessage(obtainMessage);
    }

    private void handleStartNetStatPoll(DctConstants.Activity activity) {
        startNetStatPoll();
        startDataStallAlarm(false);
        setActivity(activity);
    }

    public void sendStopNetStatPoll(DctConstants.Activity activity) {
        Message obtainMessage = obtainMessage(270376);
        obtainMessage.arg1 = 0;
        obtainMessage.obj = activity;
        sendMessage(obtainMessage);
    }

    private void handleStopNetStatPoll(DctConstants.Activity activity) {
        stopNetStatPoll();
        stopDataStallAlarm();
        setActivity(activity);
    }

    private void onDataEnabledOverrideRulesChanged() {
        log("onDataEnabledOverrideRulesChanged");
        Iterator<ApnContext> it = this.mPrioritySortedApnContexts.iterator();
        while (it.hasNext()) {
            ApnContext next = it.next();
            if (isDataAllowed(next, 1, (DataConnectionReasons) null)) {
                if (next.getDataConnection() != null) {
                    next.getDataConnection().reevaluateRestrictedState();
                }
                setupDataOnConnectableApn(next, PhoneInternalInterface.REASON_DATA_ENABLED_OVERRIDE, RetryFailures.ALWAYS);
            } else if (shouldCleanUpConnection(next, true, false)) {
                next.setReason(PhoneInternalInterface.REASON_DATA_ENABLED_OVERRIDE);
                cleanUpConnectionInternal(true, 2, next);
            }
        }
    }

    /* access modifiers changed from: private */
    public void updateDataActivity() {
        DctConstants.Activity activity;
        TxRxSum txRxSum = new TxRxSum(this.mTxPkts, this.mRxPkts);
        TxRxSum txRxSum2 = new TxRxSum();
        txRxSum2.updateTotalTxRxSum();
        long j = txRxSum2.txPkts;
        this.mTxPkts = j;
        long j2 = txRxSum2.rxPkts;
        this.mRxPkts = j2;
        if (this.mNetStatPollEnabled) {
            long j3 = txRxSum.txPkts;
            if (j3 > 0 || txRxSum.rxPkts > 0) {
                long j4 = j2 - txRxSum.rxPkts;
                int i = ((j - j3) > 0 ? 1 : ((j - j3) == 0 ? 0 : -1));
                if (i > 0 && j4 > 0) {
                    activity = DctConstants.Activity.DATAINANDOUT;
                } else if (i > 0 && j4 == 0) {
                    activity = DctConstants.Activity.DATAOUT;
                } else if (i != 0 || j4 <= 0) {
                    activity = this.mActivity;
                    if (activity != DctConstants.Activity.DORMANT) {
                        activity = DctConstants.Activity.NONE;
                    }
                } else {
                    activity = DctConstants.Activity.DATAIN;
                }
                if (this.mActivity != activity && this.mIsScreenOn) {
                    this.mActivity = activity;
                    this.mPhone.notifyDataActivity();
                }
            }
        }
    }

    private void handlePcoData(AsyncResult asyncResult) {
        if (asyncResult.exception != null) {
            loge("PCO_DATA exception: " + asyncResult.exception);
            return;
        }
        PcoData pcoData = (PcoData) asyncResult.result;
        ArrayList arrayList = new ArrayList();
        DataConnection activeDcByCid = this.mDcc.getActiveDcByCid(pcoData.cid);
        if (activeDcByCid != null) {
            arrayList.add(activeDcByCid);
        }
        if (arrayList.size() == 0) {
            loge("PCO_DATA for unknown cid: " + pcoData.cid + ", inferring");
            Iterator<DataConnection> it = this.mDataConnections.values().iterator();
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                DataConnection next = it.next();
                int cid = next.getCid();
                if (cid == pcoData.cid) {
                    arrayList.clear();
                    arrayList.add(next);
                    break;
                } else if (cid == -1) {
                    Iterator<ApnContext> it2 = next.getApnContexts().iterator();
                    while (true) {
                        if (it2.hasNext()) {
                            if (it2.next().getState() == DctConstants.State.CONNECTING) {
                                arrayList.add(next);
                                break;
                            }
                        } else {
                            break;
                        }
                    }
                }
            }
        }
        if (arrayList.size() == 0) {
            loge("PCO_DATA - couldn't infer cid");
            return;
        }
        Iterator it3 = arrayList.iterator();
        while (it3.hasNext()) {
            List<ApnContext> apnContexts = ((DataConnection) it3.next()).getApnContexts();
            if (apnContexts.size() != 0) {
                for (ApnContext apnType : apnContexts) {
                    String apnType2 = apnType.getApnType();
                    Intent intent = new Intent("android.telephony.action.CARRIER_SIGNAL_PCO_VALUE");
                    intent.putExtra("android.telephony.extra.APN_TYPE", ApnSetting.getApnTypesBitmaskFromString(apnType2));
                    intent.putExtra("android.telephony.extra.APN_PROTOCOL", ApnSetting.getProtocolIntFromString(pcoData.bearerProto));
                    intent.putExtra("android.telephony.extra.PCO_ID", pcoData.pcoId);
                    intent.putExtra("android.telephony.extra.PCO_VALUE", pcoData.contents);
                    this.mPhone.getCarrierSignalAgent().notifyCarrierSignalReceivers(intent);
                }
            } else {
                return;
            }
        }
    }

    private class DataStallRecoveryHandler {
        private static final int DEFAULT_MIN_DURATION_BETWEEN_RECOVERY_STEPS_IN_MS = 180000;
        private long mDataStallStartMs;
        private boolean mIsValidNetwork;
        private int mLastAction;
        private boolean mLastActionReported;
        private long mTimeLastRecoveryStartMs;
        private boolean mWasDataStall;

        public DataStallRecoveryHandler() {
            reset();
        }

        public void reset() {
            this.mTimeLastRecoveryStartMs = 0;
            putRecoveryAction(0);
        }

        private void setNetworkValidationState(boolean z) {
            if (z && !this.mWasDataStall) {
                return;
            }
            if (!this.mWasDataStall) {
                this.mWasDataStall = true;
                this.mDataStallStartMs = SystemClock.elapsedRealtime();
                DcTracker dcTracker = DcTracker.this;
                dcTracker.log("data stall: start time = " + this.mDataStallStartMs);
                return;
            }
            if (!this.mLastActionReported) {
                int elapsedRealtime = (int) (SystemClock.elapsedRealtime() - this.mDataStallStartMs);
                DcTracker dcTracker2 = DcTracker.this;
                dcTracker2.log("data stall: lastaction = " + this.mLastAction + ", isRecovered = " + z + ", mTimeDuration = " + elapsedRealtime);
                DataStallRecoveryStats.onDataStallEvent(this.mLastAction, DcTracker.this.mPhone, z, elapsedRealtime);
                this.mLastActionReported = true;
            }
            if (z) {
                this.mLastActionReported = false;
                this.mWasDataStall = false;
            }
        }

        public boolean isAggressiveRecovery() {
            int recoveryAction = getRecoveryAction();
            return recoveryAction == 1 || recoveryAction == 2 || recoveryAction == 3;
        }

        private long getMinDurationBetweenRecovery() {
            return Settings.Global.getLong(DcTracker.this.mResolver, "min_duration_between_recovery_steps", 180000);
        }

        private long getElapsedTimeSinceRecoveryMs() {
            return SystemClock.elapsedRealtime() - this.mTimeLastRecoveryStartMs;
        }

        /* access modifiers changed from: private */
        public int getRecoveryAction() {
            return Settings.System.getInt(DcTracker.this.mResolver, "radio.data.stall.recovery.action", 0);
        }

        private void putRecoveryAction(int i) {
            Settings.System.putInt(DcTracker.this.mResolver, "radio.data.stall.recovery.action", i);
        }

        private void broadcastDataStallDetected(int i) {
            Intent intent = new Intent("android.intent.action.DATA_STALL_DETECTED");
            SubscriptionManager.putPhoneIdAndSubIdExtra(intent, DcTracker.this.mPhone.getPhoneId());
            intent.putExtra("recoveryAction", i);
            DcTracker.this.mPhone.getContext().sendBroadcast(intent, "android.permission.READ_PRIVILEGED_PHONE_STATE");
        }

        private boolean isRecoveryAlreadyStarted() {
            return getRecoveryAction() != 0;
        }

        private boolean checkRecovery() {
            if (getElapsedTimeSinceRecoveryMs() < getMinDurationBetweenRecovery()) {
                return false;
            }
            if ((DcTracker.this.mPhone.getState() == PhoneConstants.State.IDLE || getRecoveryAction() <= 1) && DcTracker.this.mAttached.get() && DcTracker.this.isDataAllowed((DataConnectionReasons) null)) {
                return true;
            }
            return false;
        }

        private void triggerRecovery() {
            this.mTimeLastRecoveryStartMs = SystemClock.elapsedRealtime();
            DcTracker dcTracker = DcTracker.this;
            dcTracker.sendMessage(dcTracker.obtainMessage(270354));
        }

        public void doRecovery() {
            if (DcTracker.this.isAnyDataConnected()) {
                int recoveryAction = getRecoveryAction();
                TelephonyMetrics.getInstance().writeSignalStrengthEvent(DcTracker.this.mPhone.getPhoneId(), DcTracker.this.mPhone.getSignalStrength().getLevel());
                TelephonyMetrics.getInstance().writeDataStallEvent(DcTracker.this.mPhone.getPhoneId(), recoveryAction);
                this.mLastAction = recoveryAction;
                this.mLastActionReported = false;
                broadcastDataStallDetected(recoveryAction);
                if (recoveryAction == 0) {
                    EventLog.writeEvent(EventLogTags.DATA_STALL_RECOVERY_GET_DATA_CALL_LIST, DcTracker.this.mSentSinceLastRecv);
                    DcTracker.this.log("doRecovery() get data call list");
                    DcTracker.this.mDataServiceManager.requestDataCallList(DcTracker.this.obtainMessage());
                    putRecoveryAction(1);
                } else if (recoveryAction == 1) {
                    EventLog.writeEvent(EventLogTags.DATA_STALL_RECOVERY_CLEANUP, DcTracker.this.mSentSinceLastRecv);
                    DcTracker.this.log("doRecovery() cleanup all connections");
                    DcTracker dcTracker = DcTracker.this;
                    dcTracker.cleanUpConnection(dcTracker.mApnContexts.get(ApnSetting.getApnTypeString(17)));
                    DcTracker dcTracker2 = DcTracker.this;
                    dcTracker2.cleanUpConnection(dcTracker2.mApnContexts.get(ApnSetting.getApnTypeString(16384)));
                    putRecoveryAction(2);
                } else if (recoveryAction == 2) {
                    EventLog.writeEvent(EventLogTags.DATA_STALL_RECOVERY_REREGISTER, DcTracker.this.mSentSinceLastRecv);
                    DcTracker.this.log("doRecovery() re-register");
                    DcTracker.this.mPhone.getServiceStateTracker().reRegisterNetwork((Message) null);
                    putRecoveryAction(3);
                } else if (recoveryAction == 3) {
                    EventLog.writeEvent(EventLogTags.DATA_STALL_RECOVERY_RADIO_RESTART, DcTracker.this.mSentSinceLastRecv);
                    DcTracker.this.log("restarting radio");
                    DcTracker.this.restartRadio();
                    reset();
                } else {
                    throw new RuntimeException("doRecovery: Invalid recoveryAction=" + recoveryAction);
                }
                DcTracker.this.mSentSinceLastRecv = 0;
            }
        }

        public void processNetworkStatusChanged(boolean z) {
            setNetworkValidationState(z);
            if (z) {
                this.mIsValidNetwork = true;
                reset();
            } else if (this.mIsValidNetwork || isRecoveryAlreadyStarted()) {
                this.mIsValidNetwork = false;
                if (checkRecovery()) {
                    DcTracker.this.log("trigger data stall recovery");
                    triggerRecovery();
                }
            }
        }

        public boolean isRecoveryOnBadNetworkEnabled() {
            return Settings.Global.getInt(DcTracker.this.mResolver, "data_stall_recovery_on_bad_network", 1) == 1;
        }

        public boolean isNoRxDataStallDetectionEnabled() {
            return DcTracker.this.mDataStallNoRxEnabled && !isRecoveryOnBadNetworkEnabled();
        }
    }

    private void updateDataStallInfo() {
        TxRxSum txRxSum = new TxRxSum(this.mDataStallTxRxSum);
        this.mDataStallTxRxSum.updateTotalTxRxSum();
        TxRxSum txRxSum2 = this.mDataStallTxRxSum;
        long j = txRxSum2.txPkts - txRxSum.txPkts;
        long j2 = txRxSum2.rxPkts - txRxSum.rxPkts;
        int i = (j > 0 ? 1 : (j == 0 ? 0 : -1));
        if (i > 0 && j2 > 0) {
            this.mSentSinceLastRecv = 0;
            this.mDsRecoveryHandler.reset();
        } else if (i > 0 && j2 == 0) {
            if (isPhoneStateIdle()) {
                this.mSentSinceLastRecv += j;
            } else {
                this.mSentSinceLastRecv = 0;
            }
            log("updateDataStallInfo: OUT sent=" + j + " mSentSinceLastRecv=" + this.mSentSinceLastRecv);
        } else if (i == 0 && j2 > 0) {
            this.mSentSinceLastRecv = 0;
            this.mDsRecoveryHandler.reset();
        }
    }

    private boolean isPhoneStateIdle() {
        int i = 0;
        while (i < this.mTelephonyManager.getPhoneCount()) {
            Phone phone = PhoneFactory.getPhone(i);
            if (phone == null || phone.getState() == PhoneConstants.State.IDLE) {
                i++;
            } else {
                log("isPhoneStateIdle false: Voice call active on phone " + i);
                return false;
            }
        }
        return true;
    }

    private void onDataStallAlarm(int i) {
        if (this.mDataStallAlarmTag != i) {
            log("onDataStallAlarm: ignore, tag=" + i + " expecting " + this.mDataStallAlarmTag);
            return;
        }
        log("Data stall alarm");
        updateDataStallInfo();
        boolean z = false;
        if (this.mSentSinceLastRecv >= ((long) Settings.Global.getInt(this.mResolver, "pdp_watchdog_trigger_packet_count", 10))) {
            log("onDataStallAlarm: tag=" + i + " do recovery action=" + this.mDsRecoveryHandler.getRecoveryAction());
            z = true;
            sendMessage(obtainMessage(270354));
        }
        startDataStallAlarm(z);
    }

    /* access modifiers changed from: protected */
    public void startDataStallAlarm(boolean z) {
        int i;
        if (this.mDsRecoveryHandler.isNoRxDataStallDetectionEnabled() && isAnyDataConnected()) {
            if (this.mIsScreenOn || z || this.mDsRecoveryHandler.isAggressiveRecovery()) {
                i = Settings.Global.getInt(this.mResolver, "data_stall_alarm_aggressive_delay_in_ms", 60000);
            } else {
                i = Settings.Global.getInt(this.mResolver, "data_stall_alarm_non_aggressive_delay_in_ms", DATA_STALL_ALARM_NON_AGGRESSIVE_DELAY_IN_MS_DEFAULT);
            }
            this.mDataStallAlarmTag++;
            Intent intent = new Intent(INTENT_DATA_STALL_ALARM);
            intent.putExtra(INTENT_DATA_STALL_ALARM_EXTRA_TAG, this.mDataStallAlarmTag);
            intent.putExtra(INTENT_DATA_STALL_ALARM_EXTRA_TRANSPORT_TYPE, this.mTransportType);
            SubscriptionManager.putPhoneIdAndSubIdExtra(intent, this.mPhone.getPhoneId());
            this.mDataStallAlarmIntent = PendingIntent.getBroadcast(this.mPhone.getContext(), 0, intent, 201326592);
            this.mAlarmManager.set(3, SystemClock.elapsedRealtime() + ((long) i), this.mDataStallAlarmIntent);
        }
    }

    private void stopDataStallAlarm() {
        this.mDataStallAlarmTag++;
        PendingIntent pendingIntent = this.mDataStallAlarmIntent;
        if (pendingIntent != null) {
            this.mAlarmManager.cancel(pendingIntent);
            this.mDataStallAlarmIntent = null;
        }
    }

    /* access modifiers changed from: private */
    public void restartDataStallAlarm() {
        if (isAnyDataConnected()) {
            if (this.mDsRecoveryHandler.isAggressiveRecovery()) {
                log("restartDataStallAlarm: action is pending. not resetting the alarm.");
                return;
            }
            stopDataStallAlarm();
            startDataStallAlarm(false);
        }
    }

    /* access modifiers changed from: private */
    public void onActionIntentProvisioningApnAlarm(Intent intent) {
        log("onActionIntentProvisioningApnAlarm: action=" + intent.getAction());
        Message obtainMessage = obtainMessage(270375, intent.getAction());
        obtainMessage.arg1 = intent.getIntExtra(PROVISIONING_APN_ALARM_TAG_EXTRA, 0);
        sendMessage(obtainMessage);
    }

    private void startProvisioningApnAlarm() {
        int i = Settings.Global.getInt(this.mResolver, "provisioning_apn_alarm_delay_in_ms", PROVISIONING_APN_ALARM_DELAY_IN_MS_DEFAULT);
        if (TelephonyUtils.IS_DEBUGGABLE) {
            try {
                i = Integer.parseInt(System.getProperty(DEBUG_PROV_APN_ALARM, Integer.toString(i)));
            } catch (NumberFormatException e) {
                loge("startProvisioningApnAlarm: e=" + e);
            }
        }
        this.mProvisioningApnAlarmTag++;
        log("startProvisioningApnAlarm: tag=" + this.mProvisioningApnAlarmTag + " delay=" + (i / 1000) + "s");
        Intent intent = new Intent(INTENT_PROVISIONING_APN_ALARM);
        intent.putExtra(PROVISIONING_APN_ALARM_TAG_EXTRA, this.mProvisioningApnAlarmTag);
        this.mProvisioningApnAlarmIntent = PendingIntent.getBroadcast(this.mPhone.getContext(), 0, intent, 201326592);
        this.mAlarmManager.set(2, SystemClock.elapsedRealtime() + ((long) i), this.mProvisioningApnAlarmIntent);
    }

    private void stopProvisioningApnAlarm() {
        log("stopProvisioningApnAlarm: current tag=" + this.mProvisioningApnAlarmTag + " mProvsioningApnAlarmIntent=" + this.mProvisioningApnAlarmIntent);
        this.mProvisioningApnAlarmTag = this.mProvisioningApnAlarmTag + 1;
        PendingIntent pendingIntent = this.mProvisioningApnAlarmIntent;
        if (pendingIntent != null) {
            this.mAlarmManager.cancel(pendingIntent);
            this.mProvisioningApnAlarmIntent = null;
        }
    }

    private void startWatchdogAlarm() {
        sendMessageDelayed(obtainMessage(270389), this.mWatchdogTimeMs);
        this.mWatchdog = true;
    }

    private void stopWatchdogAlarm() {
        removeMessages(270389);
        this.mWatchdog = false;
    }

    private void onDataServiceBindingChanged(boolean z) {
        if (z) {
            this.mDataThrottler.reset();
        } else if (this.mTransportType == 2 && !this.mPhone.getContext().getResources().getBoolean(17891847)) {
            cleanUpAllConnectionsInternal(false, PhoneInternalInterface.REASON_IWLAN_DATA_SERVICE_DIED);
        }
        this.mDataServiceBound = z;
    }

    /* access modifiers changed from: protected */
    public int getDataRat() {
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceState().getNetworkRegistrationInfo(2, this.mTransportType);
        if (networkRegistrationInfo != null) {
            return ServiceState.networkTypeToRilRadioTechnology(networkRegistrationInfo.getAccessNetworkTechnology());
        }
        return 0;
    }

    private int getVoiceRat() {
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceState().getNetworkRegistrationInfo(1, this.mTransportType);
        if (networkRegistrationInfo != null) {
            return ServiceState.networkTypeToRilRadioTechnology(networkRegistrationInfo.getAccessNetworkTechnology());
        }
        return 0;
    }

    private void read5GConfiguration() {
        boolean z;
        PersistableBundle configForSubId;
        log("read5GConfiguration");
        String[] stringArray = CarrierConfigManager.getDefaultConfig().getStringArray("bandwidth_string_array");
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            z = false;
        } else {
            if (configForSubId.getStringArray("bandwidth_string_array") != null) {
                stringArray = configForSubId.getStringArray("bandwidth_string_array");
            }
            z = configForSubId.getBoolean("bandwidth_nr_nsa_use_lte_value_for_uplink_bool");
            this.mWatchdogTimeMs = configForSubId.getLong("5g_watchdog_time_ms_long");
            this.mNrNsaAllUnmetered = configForSubId.getBoolean("unmetered_nr_nsa_bool");
            this.mNrNsaMmwaveUnmetered = configForSubId.getBoolean("unmetered_nr_nsa_mmwave_bool");
            this.mNrNsaSub6Unmetered = configForSubId.getBoolean("unmetered_nr_nsa_sub6_bool");
            this.mNrSaAllUnmetered = configForSubId.getBoolean("unmetered_nr_sa_bool");
            this.mNrSaMmwaveUnmetered = configForSubId.getBoolean("unmetered_nr_sa_mmwave_bool");
            this.mNrSaSub6Unmetered = configForSubId.getBoolean("unmetered_nr_sa_sub6_bool");
            this.mNrNsaRoamingUnmetered = configForSubId.getBoolean("unmetered_nr_nsa_when_roaming_bool");
            this.mLteEndcUsingUserDataForRrcDetection = configForSubId.getBoolean("lte_endc_using_user_data_for_rrc_detection_bool");
        }
        updateLinkBandwidths(stringArray, z);
    }

    public boolean getLteEndcUsingUserDataForIdleDetection() {
        return this.mLteEndcUsingUserDataForRrcDetection;
    }

    public void registerForPhysicalLinkStatusChanged(Handler handler, int i) {
        this.mDcc.registerForPhysicalLinkStatusChanged(handler, i);
    }

    public void unregisterForPhysicalLinkStatusChanged(Handler handler) {
        this.mDcc.unregisterForPhysicalLinkStatusChanged(handler);
    }

    private boolean areCompatible(ApnSetting apnSetting, ApnSetting apnSetting2) {
        return apnSetting.equals(apnSetting2, this.mPhone.getServiceState().getDataRoamingFromRegistration());
    }

    private PersistableBundle getCarrierConfig() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            return CarrierConfigManager.getDefaultConfig();
        }
        return configForSubId;
    }

    public DataServiceManager getDataServiceManager() {
        return this.mDataServiceManager;
    }

    public DataThrottler getDataThrottler() {
        return this.mDataThrottler;
    }

    private void showProvisioningNotification() {
        Intent intent = new Intent(INTENT_PROVISION);
        intent.putExtra(EXTRA_PROVISION_PHONE_ID, this.mPhone.getPhoneId());
        PendingIntent broadcast = PendingIntent.getBroadcast(this.mPhone.getContext(), 0, intent, 67108864);
        String string = this.mPhone.getContext().getResources().getString(17040856, new Object[]{0});
        try {
            getNotificationManager().notify(NOTIFICATION_TAG, this.mPhone.getPhoneId(), new Notification.Builder(this.mPhone.getContext()).setWhen(System.currentTimeMillis()).setSmallIcon(17303695).setChannelId(NotificationChannelController.CHANNEL_ID_MOBILE_DATA_STATUS).setAutoCancel(true).setTicker(string).setColor(this.mPhone.getContext().getColor(17170460)).setContentTitle(string).setContentText(this.mTelephonyManager.getNetworkOperator(this.mPhone.getSubId())).setContentIntent(broadcast).setLocalOnly(true).setOnlyAlertOnce(true).build());
        } catch (NullPointerException e) {
            Log.e(this.mLogTag, "showProvisioningNotification: error showing notification", e);
        }
    }

    private void hideProvisioningNotification() {
        try {
            getNotificationManager().cancel(NOTIFICATION_TAG, this.mPhone.getPhoneId());
        } catch (NullPointerException e) {
            Log.e(this.mLogTag, "hideProvisioningNotification: error hiding notification", e);
        }
    }

    private NotificationManager getNotificationManager() {
        return (NotificationManager) this.mPhone.getContext().createContextAsUser(UserHandle.ALL, 0).getSystemService("notification");
    }
}
