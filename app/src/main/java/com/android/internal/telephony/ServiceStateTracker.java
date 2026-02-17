package com.android.internal.telephony;

import android.app.Notification;
import android.app.NotificationManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.AsyncResult;
import android.os.BaseBundle;
import android.os.Handler;
import android.os.HandlerExecutor;
import android.os.Message;
import android.os.Parcel;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.os.UserHandle;
import android.os.WorkSource;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.provider.Telephony;
import android.telephony.CarrierConfigManager;
import android.telephony.CellIdentity;
import android.telephony.CellIdentityCdma;
import android.telephony.CellIdentityGsm;
import android.telephony.CellIdentityLte;
import android.telephony.CellIdentityNr;
import android.telephony.CellIdentityTdscdma;
import android.telephony.CellIdentityWcdma;
import android.telephony.CellInfo;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.PhysicalChannelConfig;
import android.telephony.ServiceState;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.EventLog;
import android.util.Pair;
import android.util.SparseArray;
import android.util.SparseBooleanArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager;
import com.android.internal.telephony.cdma.EriManager;
import com.android.internal.telephony.cdnr.CarrierDisplayNameData;
import com.android.internal.telephony.cdnr.CarrierDisplayNameResolver;
import com.android.internal.telephony.data.AccessNetworksManager;
import com.android.internal.telephony.dataconnection.DataConnection;
import com.android.internal.telephony.metrics.ServiceStateStats;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.RuimRecords;
import com.android.internal.telephony.uicc.SIMRecords;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.UiccProfile;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class ServiceStateTracker extends Handler {
    public static final int CARRIER_NAME_DISPLAY_BITMASK_SHOW_PLMN = 2;
    public static final int CARRIER_NAME_DISPLAY_BITMASK_SHOW_SPN = 1;
    private static final long CELL_INFO_LIST_QUERY_TIMEOUT = 2000;
    public static final int CS_DISABLED = 1004;
    public static final int CS_EMERGENCY_ENABLED = 1006;
    public static final int CS_ENABLED = 1003;
    public static final int CS_NORMAL_ENABLED = 1005;
    public static final int CS_NOTIFICATION = 999;
    public static final int CS_REJECT_CAUSE_DISABLED = 2002;
    public static final int CS_REJECT_CAUSE_ENABLED = 2001;
    public static final int CS_REJECT_CAUSE_NOTIFICATION = 111;
    static final boolean DBG = true;
    public static final int DEFAULT_GPRS_CHECK_PERIOD_MILLIS = 60000;
    public static final String DEFAULT_MNC = "00";
    protected static final int EVENT_ALL_DATA_DISCONNECTED = 49;
    protected static final int EVENT_CARRIER_CONFIG_CHANGED = 57;
    protected static final int EVENT_CDMA_PRL_VERSION_CHANGED = 40;
    protected static final int EVENT_CDMA_SUBSCRIPTION_SOURCE_CHANGED = 39;
    protected static final int EVENT_CELL_LOCATION_RESPONSE = 56;
    protected static final int EVENT_CHANGE_IMS_STATE = 45;
    protected static final int EVENT_CHECK_REPORT_GPRS = 22;
    protected static final int EVENT_GET_ALLOWED_NETWORK_TYPES = 19;
    protected static final int EVENT_GET_CELL_INFO_LIST = 43;
    protected static final int EVENT_GET_LOC_DONE = 15;
    public static final int EVENT_ICC_CHANGED = 42;
    protected static final int EVENT_IMS_CAPABILITY_CHANGED = 48;
    protected static final int EVENT_IMS_SERVICE_STATE_CHANGED = 53;
    protected static final int EVENT_IMS_STATE_CHANGED = 46;
    protected static final int EVENT_IMS_STATE_DONE = 47;
    protected static final int EVENT_LOCATION_UPDATES_ENABLED = 18;
    protected static final int EVENT_NETWORK_STATE_CHANGED = 2;
    protected static final int EVENT_NITZ_TIME = 11;
    protected static final int EVENT_NV_READY = 35;
    protected static final int EVENT_OTA_PROVISION_STATUS_CHANGE = 37;
    protected static final int EVENT_PHONE_TYPE_SWITCHED = 50;
    protected static final int EVENT_PHYSICAL_CHANNEL_CONFIG = 55;
    protected static final int EVENT_POLL_STATE_CDMA_SUBSCRIPTION = 34;
    protected static final int EVENT_POLL_STATE_CS_CELLULAR_REGISTRATION = 4;
    protected static final int EVENT_POLL_STATE_NETWORK_SELECTION_MODE = 14;
    protected static final int EVENT_POLL_STATE_OPERATOR = 7;
    protected static final int EVENT_POLL_STATE_PS_CELLULAR_REGISTRATION = 5;
    protected static final int EVENT_POLL_STATE_PS_IWLAN_REGISTRATION = 6;
    private static final int EVENT_POLL_STATE_REQUEST = 58;
    protected static final int EVENT_POWER_OFF_RADIO_IMS_DEREG_TIMEOUT = 62;
    protected static final int EVENT_RADIO_ON = 41;
    protected static final int EVENT_RADIO_POWER_FROM_CARRIER = 51;
    protected static final int EVENT_RADIO_POWER_OFF_DONE = 54;
    protected static final int EVENT_RADIO_STATE_CHANGED = 1;
    private static final int EVENT_REGISTER_DATA_NETWORK_EXISTING_CHANGED = 64;
    protected static final int EVENT_RESET_ALLOWED_NETWORK_TYPES = 21;
    protected static final int EVENT_RESET_LAST_KNOWN_CELL_IDENTITY = 63;
    protected static final int EVENT_RESTRICTED_STATE_CHANGED = 23;
    protected static final int EVENT_RUIM_READY = 26;
    protected static final int EVENT_RUIM_RECORDS_LOADED = 27;
    protected static final int EVENT_SET_ALLOWED_NETWORK_TYPES = 20;
    protected static final int EVENT_SET_RADIO_POWER_OFF = 38;
    protected static final int EVENT_SIM_READY = 17;
    protected static final int EVENT_SIM_RECORDS_LOADED = 16;
    protected static final int EVENT_TELECOM_VOICE_SERVICE_STATE_OVERRIDE_CHANGED = 65;
    protected static final int EVENT_UNSOL_CELL_INFO_LIST = 44;
    public static final String INVALID_MCC = "000";
    static final String LOG_TAG = "SST";
    private static final int MS_PER_HOUR = 3600000;
    private static final long POWER_OFF_ALL_DATA_NETWORKS_DISCONNECTED_TIMEOUT = TimeUnit.SECONDS.toMillis(10);
    protected static final String PROP_FORCE_ROAMING = "telephony.test.forceRoaming";
    public static final int PS_DISABLED = 1002;
    public static final int PS_ENABLED = 1001;
    public static final int PS_NOTIFICATION = 888;
    protected static final String REGISTRATION_DENIED_AUTH = "Authentication Failure";
    protected static final String REGISTRATION_DENIED_GEN = "General";
    private static final String SERVICE_STATE = "service_state";
    public static final String UNACTIVATED_MIN2_VALUE = "000000";
    public static final String UNACTIVATED_MIN_VALUE = "1111110111";
    private static final boolean VDBG = false;
    protected final AccessNetworksManager mAccessNetworksManager;
    private final RegistrantList mAirplaneModeChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private int mAllowedNetworkTypes;
    /* access modifiers changed from: private */
    public boolean mAnyDataExisting;
    protected final RegistrantList mAreaCodeChangedRegistrants = new RegistrantList();
    private final LocalLog mAttachLog;
    protected SparseArray<RegistrantList> mAttachedRegistrants = new SparseArray<>();
    protected final RegistrantList mBandwidthChangedRegistrants = new RegistrantList();
    protected boolean mCSEmergencyOnly;
    private CarrierServiceStateTracker mCSST;
    private RegistrantList mCdmaForSubscriptionInfoReadyRegistrants;
    protected CdmaSubscriptionSourceManager mCdmaSSM;
    protected CarrierDisplayNameResolver mCdnr;
    private final LocalLog mCdnrLogs;
    protected CellIdentity mCellIdentity;
    private int mCellInfoMinIntervalMs = 2000;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected CommandsInterface mCi;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final ContentResolver mCr;
    protected RegistrantList mCssIndicatorChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mCurDataSpn = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mCurPlmn = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mCurShowPlmn = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mCurShowSpn = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mCurSpn = null;
    private String mCurrentCarrier;
    private int mCurrentOtaspMode;
    private SparseArray<RegistrantList> mDataRegStateOrRatChangedRegistrants = new SparseArray<>();
    @UnsupportedAppUsage
    protected RegistrantList mDataRoamingOffRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mDataRoamingOnRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mDefaultRoamingIndicator;
    @UnsupportedAppUsage
    protected boolean mDesiredPowerState;
    protected SparseArray<RegistrantList> mDetachedRegistrants = new SparseArray<>();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mDeviceShuttingDown = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mEmergencyOnly;
    protected final EriManager mEriManager;
    protected String mEriText;
    protected boolean mGsmDataRoaming;
    protected boolean mGsmVoiceRoaming;
    protected HbpcdUtils mHbpcdUtils;
    private int[] mHomeNetworkId;
    private int[] mHomeSystemId;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccRecords mIccRecords = null;
    private RegistrantList mImsCapabilityChangedRegistrants = new RegistrantList();
    private boolean mImsRegistered = false;
    protected boolean mImsRegistrationOnOff = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected BroadcastReceiver mIntentReceiver;
    private boolean mIsEriTextLoaded;
    protected boolean mIsInPrl;
    protected boolean mIsMinInfoReady;
    private boolean mIsPendingCellInfoRequest = false;
    protected boolean mIsSimReady;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mIsSubscriptionFromRuim;
    protected List<CellInfo> mLastCellInfoList = null;
    protected long mLastCellInfoReqTime;
    protected int mLastKnownAreaCode;
    protected CellIdentity mLastKnownCellIdentity;
    protected String mLastKnownNetworkCountry;
    protected NitzData mLastNitzData;
    protected List<PhysicalChannelConfig> mLastPhysicalChannelConfigList = null;
    protected final LocaleTracker mLocaleTracker;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mMaxDataCalls;
    protected String mMdn;
    protected String mMin;
    @UnsupportedAppUsage
    protected RegistrantList mNetworkAttachedRegistrants = new RegistrantList();
    protected RegistrantList mNetworkDetachedRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mNewMaxDataCalls;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mNewReasonDataDenied;
    protected int mNewRejectCode;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ServiceState mNewSS;
    protected final NitzStateMachine mNitzState;
    private Notification mNotification;
    protected RegistrantList mNrFrequencyChangedRegistrants = new RegistrantList();
    protected RegistrantList mNrStateChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final SstSubscriptionsChangedListener mOnSubscriptionsChangedListener;
    private Pattern mOperatorNameStringPattern;
    /* access modifiers changed from: private */
    public final ServiceState mOutOfServiceSS;
    protected boolean mPSEmergencyOnly;
    private List<Message> mPendingCellInfoRequests = new LinkedList();
    protected boolean mPendingRadioPowerOffAfterDataOff = false;
    private int mPendingRadioPowerOffAfterDataOffTag = 0;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final GsmCdmaPhone mPhone;
    private final LocalLog mPhoneTypeLog;
    @VisibleForTesting
    public int[] mPollingContext;
    protected int mPrevSubId = -1;
    protected String mPrlVersion;
    protected RegistrantList mPsRestrictDisabledRegistrants = new RegistrantList();
    private RegistrantList mPsRestrictEnabledRegistrants = new RegistrantList();
    protected boolean mRadioDisabledByCarrier = false;
    protected final LocalLog mRadioPowerLog;
    protected final Set<Integer> mRadioPowerOffReasons = new HashSet();
    private final LocalLog mRatLog;
    protected final RatRatcheter mRatRatcheter;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mReasonDataDenied;
    protected final SparseArray<NetworkRegistrationManager> mRegStateManagers;
    protected String mRegistrationDeniedReason;
    protected int mRegistrationState;
    protected int mRejectCode;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mReportedGprsNoReg;
    public RestrictedState mRestrictedState;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mRoamingIndicator;
    private final LocalLog mRoamingLog;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ServiceState mSS;
    protected RegistrantList mServiceStateChangedRegistrants = new RegistrantList();
    private ServiceStateStats mServiceStateStats;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mSpnUpdatePending = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mStartedGprsRegCheck;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
    public int mSubId = -1;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected SubscriptionController mSubscriptionController;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private SubscriptionManager mSubscriptionManager;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected UiccCardApplication mUiccApplcation = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected UiccController mUiccController = null;
    private boolean mVoiceCapable;
    private RegistrantList mVoiceRegStateOrRatChangedRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mVoiceRoamingOffRegistrants = new RegistrantList();
    @UnsupportedAppUsage
    protected RegistrantList mVoiceRoamingOnRegistrants = new RegistrantList();
    private boolean mWantContinuousLocationUpdates;
    private boolean mWantSingleLocationUpdate;

    @Retention(RetentionPolicy.SOURCE)
    public @interface CarrierNameDisplayBitmask {
    }

    private static boolean isValidLteBandwidthKhz(int i) {
        return i == 1400 || i == 3000 || i == 5000 || i == 10000 || i == 15000 || i == 20000;
    }

    private static boolean isValidNrBandwidthKhz(int i) {
        switch (i) {
            case GbaManager.REQUEST_TIMEOUT_MS:
            case 10000:
            case 15000:
            case 20000:
            case 25000:
            case 30000:
            case 40000:
            case 50000:
            case DEFAULT_GPRS_CHECK_PERIOD_MILLIS /*60000*/:
            case 70000:
            case 80000:
            case 90000:
            case 100000:
                return true;
            default:
                return false;
        }
    }

    private int selectResourceForRejectCode(int i, boolean z) {
        if (i == 1) {
            return z ? 17040827 : 17040826;
        }
        if (i == 2) {
            return z ? 17040833 : 17040832;
        }
        if (i == 3) {
            return z ? 17040831 : 17040830;
        }
        if (i != 6) {
            return 0;
        }
        return z ? 17040829 : 17040828;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isGprsConsistent(int i, int i2) {
        return i2 != 0 || i == 0;
    }

    /* access modifiers changed from: protected */
    public void mtkHangupAllCalls() {
    }

    /* access modifiers changed from: protected */
    public void mtkHangupAllImsCall() {
    }

    /* access modifiers changed from: protected */
    public boolean mtkPowerOffNonDdsPhone() {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean regCodeIsRoaming(int i) {
        return 5 == i;
    }

    /* access modifiers changed from: protected */
    public int regCodeToServiceState(int i) {
        return (i == 1 || i == 5) ? 0 : 1;
    }

    private class SstSubscriptionsChangedListener extends SubscriptionManager.OnSubscriptionsChangedListener {
        private SstSubscriptionsChangedListener() {
        }

        public void onSubscriptionsChanged() {
            ServiceStateTracker.this.log("SubscriptionListener.onSubscriptionInfoChanged");
            int subId = ServiceStateTracker.this.mPhone.getSubId();
            ServiceStateTracker serviceStateTracker = ServiceStateTracker.this;
            int i = serviceStateTracker.mSubId;
            if (i != subId) {
                serviceStateTracker.mPrevSubId = i;
                serviceStateTracker.mSubId = subId;
                serviceStateTracker.mPhone.updateVoiceMail();
                if (SubscriptionManager.isValidSubscriptionId(ServiceStateTracker.this.mSubId)) {
                    Context context = ServiceStateTracker.this.mPhone.getContext();
                    ServiceStateTracker.this.mPhone.notifyPhoneStateChanged();
                    if (!SubscriptionManager.isValidSubscriptionId(ServiceStateTracker.this.mPrevSubId)) {
                        GsmCdmaPhone gsmCdmaPhone = ServiceStateTracker.this.mPhone;
                        gsmCdmaPhone.notifyServiceStateChanged(gsmCdmaPhone.getServiceState());
                    }
                    ServiceStateTracker.this.mPhone.sendSubscriptionSettings(!context.getResources().getBoolean(17891862));
                    ServiceStateTracker serviceStateTracker2 = ServiceStateTracker.this;
                    serviceStateTracker2.setDataNetworkTypeForPhone(serviceStateTracker2.mSS.getRilDataRadioTechnology());
                    ServiceStateTracker serviceStateTracker3 = ServiceStateTracker.this;
                    if (serviceStateTracker3.mSpnUpdatePending) {
                        SubscriptionController subscriptionController = serviceStateTracker3.mSubscriptionController;
                        int phoneId = serviceStateTracker3.mPhone.getPhoneId();
                        ServiceStateTracker serviceStateTracker4 = ServiceStateTracker.this;
                        subscriptionController.setPlmnSpn(phoneId, serviceStateTracker4.mCurShowPlmn, serviceStateTracker4.mCurPlmn, serviceStateTracker4.mCurShowSpn, serviceStateTracker4.mCurSpn);
                        ServiceStateTracker.this.mSpnUpdatePending = false;
                    }
                    SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
                    String string = defaultSharedPreferences.getString(Phone.NETWORK_SELECTION_KEY, "");
                    String string2 = defaultSharedPreferences.getString(Phone.NETWORK_SELECTION_NAME_KEY, "");
                    String string3 = defaultSharedPreferences.getString(Phone.NETWORK_SELECTION_SHORT_KEY, "");
                    if (!TextUtils.isEmpty(string) || !TextUtils.isEmpty(string2) || !TextUtils.isEmpty(string3)) {
                        SharedPreferences.Editor edit = defaultSharedPreferences.edit();
                        edit.putString(Phone.NETWORK_SELECTION_KEY + ServiceStateTracker.this.mSubId, string);
                        edit.putString(Phone.NETWORK_SELECTION_NAME_KEY + ServiceStateTracker.this.mSubId, string2);
                        edit.putString(Phone.NETWORK_SELECTION_SHORT_KEY + ServiceStateTracker.this.mSubId, string3);
                        edit.remove(Phone.NETWORK_SELECTION_KEY);
                        edit.remove(Phone.NETWORK_SELECTION_NAME_KEY);
                        edit.remove(Phone.NETWORK_SELECTION_SHORT_KEY);
                        edit.commit();
                    }
                    ServiceStateTracker.this.updateSpnDisplay();
                } else if (SubscriptionManager.isValidSubscriptionId(ServiceStateTracker.this.mPrevSubId)) {
                    ServiceStateTracker serviceStateTracker5 = ServiceStateTracker.this;
                    serviceStateTracker5.mPhone.notifyServiceStateChangedForSubId(serviceStateTracker5.mOutOfServiceSS, ServiceStateTracker.this.mPrevSubId);
                }
            }
        }
    }

    public ServiceStateTracker(GsmCdmaPhone gsmCdmaPhone, CommandsInterface commandsInterface) {
        SstSubscriptionsChangedListener sstSubscriptionsChangedListener = new SstSubscriptionsChangedListener();
        this.mOnSubscriptionsChangedListener = sstSubscriptionsChangedListener;
        this.mRoamingLog = new LocalLog(8);
        this.mAttachLog = new LocalLog(8);
        this.mPhoneTypeLog = new LocalLog(8);
        this.mRatLog = new LocalLog(16);
        this.mRadioPowerLog = new LocalLog(16);
        this.mCdnrLogs = new LocalLog(64);
        this.mMaxDataCalls = 1;
        this.mNewMaxDataCalls = 1;
        this.mReasonDataDenied = -1;
        this.mNewReasonDataDenied = -1;
        this.mGsmVoiceRoaming = false;
        this.mGsmDataRoaming = false;
        this.mEmergencyOnly = false;
        this.mCSEmergencyOnly = false;
        this.mPSEmergencyOnly = false;
        this.mIsSimReady = false;
        this.mLastKnownNetworkCountry = "";
        this.mIntentReceiver = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                if (action.equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                    if (intent.getExtras().getInt("android.telephony.extra.SLOT_INDEX") == ServiceStateTracker.this.mPhone.getPhoneId()) {
                        ServiceStateTracker.this.sendEmptyMessage(57);
                    }
                } else if (action.equals("android.intent.action.LOCALE_CHANGED")) {
                    ServiceStateTracker.this.pollState();
                } else if (action.equals("android.telephony.action.NETWORK_COUNTRY_CHANGED")) {
                    if (!ServiceStateTracker.this.mLastKnownNetworkCountry.equals(intent.getStringExtra("android.telephony.extra.LAST_KNOWN_NETWORK_COUNTRY"))) {
                        ServiceStateTracker.this.updateSpnDisplay();
                    }
                }
            }
        };
        this.mCurrentOtaspMode = 0;
        this.mRegistrationState = -1;
        this.mCdmaForSubscriptionInfoReadyRegistrants = new RegistrantList();
        this.mHomeSystemId = null;
        this.mHomeNetworkId = null;
        this.mIsMinInfoReady = false;
        this.mIsEriTextLoaded = false;
        this.mIsSubscriptionFromRuim = false;
        this.mHbpcdUtils = null;
        this.mCurrentCarrier = null;
        this.mRegStateManagers = new SparseArray<>();
        this.mLastKnownAreaCode = Integer.MAX_VALUE;
        this.mAnyDataExisting = false;
        this.mNitzState = TelephonyComponentFactory.getInstance().inject(NitzStateMachine.class.getName()).makeNitzStateMachine(gsmCdmaPhone);
        this.mPhone = gsmCdmaPhone;
        this.mCi = commandsInterface;
        this.mServiceStateStats = new ServiceStateStats(gsmCdmaPhone);
        this.mCdnr = new CarrierDisplayNameResolver(gsmCdmaPhone);
        if (UiccController.isCdmaSupported(gsmCdmaPhone.getContext())) {
            this.mEriManager = TelephonyComponentFactory.getInstance().inject(EriManager.class.getName()).makeEriManager(gsmCdmaPhone, 0);
        } else {
            this.mEriManager = null;
        }
        this.mRatRatcheter = new RatRatcheter(gsmCdmaPhone);
        this.mVoiceCapable = ((TelephonyManager) gsmCdmaPhone.getContext().getSystemService("phone")).isVoiceCapable();
        UiccController instance = UiccController.getInstance();
        this.mUiccController = instance;
        instance.registerForIccChanged(this, 42, (Object) null);
        this.mCi.registerForCellInfoList(this, 44, (Object) null);
        this.mCi.registerForPhysicalChannelConfiguration(this, 55, (Object) null);
        this.mSubscriptionController = SubscriptionController.getInstance();
        SubscriptionManager from = SubscriptionManager.from(gsmCdmaPhone.getContext());
        this.mSubscriptionManager = from;
        from.addOnSubscriptionsChangedListener(new HandlerExecutor(this), sstSubscriptionsChangedListener);
        this.mRestrictedState = new RestrictedState();
        AccessNetworksManager accessNetworksManager = gsmCdmaPhone.getAccessNetworksManager();
        this.mAccessNetworksManager = accessNetworksManager;
        ServiceState serviceState = new ServiceState();
        this.mOutOfServiceSS = serviceState;
        serviceState.setOutOfService(accessNetworksManager.isInLegacyMode(), false);
        for (int i : accessNetworksManager.getAvailableTransports()) {
            this.mRegStateManagers.append(i, new NetworkRegistrationManager(i, gsmCdmaPhone));
            this.mRegStateManagers.get(i).registerForNetworkRegistrationInfoChanged(this, 2, (Object) null);
        }
        this.mLocaleTracker = TelephonyComponentFactory.getInstance().inject(LocaleTracker.class.getName()).makeLocaleTracker(this.mPhone, this.mNitzState, getLooper());
        this.mCi.registerForImsNetworkStateChanged(this, 46, (Object) null);
        this.mCi.registerForRadioStateChanged(this, 1, (Object) null);
        this.mCi.setOnNITZTime(this, 11, (Object) null);
        ContentResolver contentResolver = gsmCdmaPhone.getContext().getContentResolver();
        this.mCr = contentResolver;
        int i2 = Settings.Global.getInt(contentResolver, "airplane_mode_on", 0);
        int i3 = Settings.Global.getInt(contentResolver, "enable_cellular_on_boot", 1);
        boolean z = i3 > 0 && i2 <= 0;
        this.mDesiredPowerState = z;
        if (!z) {
            this.mRadioPowerOffReasons.add(0);
        }
        this.mRadioPowerLog.log("init : airplane mode = " + i2 + " enableCellularOnBoot = " + i3);
        this.mPhone.getCarrierActionAgent().registerForCarrierAction(1, this, 51, (Object) null, false);
        Context context = this.mPhone.getContext();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.LOCALE_CHANGED");
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction("android.telephony.action.NETWORK_COUNTRY_CHANGED");
        context.registerReceiver(this.mIntentReceiver, intentFilter);
        this.mPhone.notifyOtaspChanged(0);
        this.mCi.setOnRestrictedStateChanged(this, 23, (Object) null);
        updatePhoneType();
        CarrierServiceStateTracker carrierServiceStateTracker = new CarrierServiceStateTracker(gsmCdmaPhone, this);
        this.mCSST = carrierServiceStateTracker;
        registerForNetworkAttached(carrierServiceStateTracker, 101, (Object) null);
        registerForNetworkDetached(this.mCSST, 102, (Object) null);
        registerForDataConnectionAttached(1, this.mCSST, 103, (Object) null);
        registerForDataConnectionDetached(1, this.mCSST, 104, (Object) null);
        registerForImsCapabilityChanged(this.mCSST, 105, (Object) null);
        if (this.mPhone.isUsingNewDataStack()) {
            sendEmptyMessage(64);
        }
    }

    @VisibleForTesting
    public void updatePhoneType() {
        NetworkRegistrationInfo networkRegistrationInfo;
        ServiceState serviceState = this.mSS;
        if (serviceState != null && serviceState.getVoiceRoaming()) {
            this.mVoiceRoamingOffRegistrants.notifyRegistrants();
        }
        ServiceState serviceState2 = this.mSS;
        if (serviceState2 != null && serviceState2.getDataRoaming()) {
            this.mDataRoamingOffRegistrants.notifyRegistrants();
        }
        ServiceState serviceState3 = this.mSS;
        if (serviceState3 != null && serviceState3.getState() == 0) {
            this.mNetworkDetachedRegistrants.notifyRegistrants();
        }
        for (int i : this.mAccessNetworksManager.getAvailableTransports()) {
            ServiceState serviceState4 = this.mSS;
            if (!(serviceState4 == null || (networkRegistrationInfo = serviceState4.getNetworkRegistrationInfo(2, i)) == null || !networkRegistrationInfo.isInService() || this.mDetachedRegistrants.get(i) == null)) {
                this.mDetachedRegistrants.get(i).notifyRegistrants();
            }
        }
        ServiceState serviceState5 = new ServiceState();
        this.mSS = serviceState5;
        serviceState5.setOutOfService(this.mAccessNetworksManager.isInLegacyMode(), false);
        ServiceState serviceState6 = new ServiceState();
        this.mNewSS = serviceState6;
        serviceState6.setOutOfService(this.mAccessNetworksManager.isInLegacyMode(), false);
        this.mLastCellInfoReqTime = 0;
        this.mLastCellInfoList = null;
        this.mStartedGprsRegCheck = false;
        this.mReportedGprsNoReg = false;
        this.mMdn = null;
        this.mMin = null;
        this.mPrlVersion = null;
        this.mIsMinInfoReady = false;
        this.mLastNitzData = null;
        this.mNitzState.handleNetworkUnavailable();
        this.mCellIdentity = null;
        this.mPhone.getSignalStrengthController().setSignalStrengthDefaultValues();
        this.mLastKnownCellIdentity = null;
        cancelPollState();
        if (this.mPhone.isPhoneTypeGsm()) {
            CdmaSubscriptionSourceManager cdmaSubscriptionSourceManager = this.mCdmaSSM;
            if (cdmaSubscriptionSourceManager != null) {
                cdmaSubscriptionSourceManager.dispose(this);
            }
            this.mCi.unregisterForCdmaPrlChanged(this);
            this.mCi.unregisterForCdmaOtaProvision(this);
            this.mPhone.unregisterForSimRecordsLoaded(this);
        } else {
            this.mPhone.registerForSimRecordsLoaded(this, 16, (Object) null);
            CdmaSubscriptionSourceManager instance = CdmaSubscriptionSourceManager.getInstance(this.mPhone.getContext(), this.mCi, this, 39, (Object) null);
            this.mCdmaSSM = instance;
            this.mIsSubscriptionFromRuim = instance.getCdmaSubscriptionSource() == 0;
            this.mCi.registerForCdmaPrlChanged(this, 40, (Object) null);
            this.mCi.registerForCdmaOtaProvision(this, 37, (Object) null);
            this.mHbpcdUtils = new HbpcdUtils(this.mPhone.getContext());
            updateOtaspState();
        }
        onUpdateIccAvailability();
        setDataNetworkTypeForPhone(0);
        this.mPhone.getSignalStrengthController().getSignalStrengthFromCi();
        sendMessage(obtainMessage(50));
        logPhoneTypeChange();
        notifyVoiceRegStateRilRadioTechnologyChanged();
        for (int notifyDataRegStateRilRadioTechnologyChanged : this.mAccessNetworksManager.getAvailableTransports()) {
            notifyDataRegStateRilRadioTechnologyChanged(notifyDataRegStateRilRadioTechnologyChanged);
        }
    }

    @VisibleForTesting
    public void requestShutdown() {
        if (!this.mDeviceShuttingDown) {
            this.mDeviceShuttingDown = true;
            this.mDesiredPowerState = false;
            setPowerStateToDesired();
        }
    }

    @VisibleForTesting
    public int getRadioPowerOffDelayTimeoutForImsRegistration() {
        return this.mPhone.getContext().getResources().getInteger(17694805);
    }

    public void dispose() {
        this.mPhone.getSignalStrengthController().dispose();
        this.mUiccController.unregisterForIccChanged(this);
        this.mCi.unregisterForCellInfoList(this);
        this.mCi.unregisterForPhysicalChannelConfiguration(this);
        this.mSubscriptionManager.removeOnSubscriptionsChangedListener(this.mOnSubscriptionsChangedListener);
        this.mCi.unregisterForImsNetworkStateChanged(this);
        this.mPhone.getCarrierActionAgent().unregisterForCarrierAction(this, 1);
        this.mPhone.getContext().unregisterReceiver(this.mIntentReceiver);
        CarrierServiceStateTracker carrierServiceStateTracker = this.mCSST;
        if (carrierServiceStateTracker != null) {
            carrierServiceStateTracker.dispose();
            this.mCSST = null;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean getDesiredPowerState() {
        return this.mDesiredPowerState;
    }

    public boolean getPowerStateFromCarrier() {
        return !this.mRadioDisabledByCarrier;
    }

    public List<PhysicalChannelConfig> getPhysicalChannelConfigList() {
        return this.mLastPhysicalChannelConfigList;
    }

    /* access modifiers changed from: protected */
    public void notifyVoiceRegStateRilRadioTechnologyChanged() {
        int rilVoiceRadioTechnology = this.mSS.getRilVoiceRadioTechnology();
        int state = this.mSS.getState();
        log("notifyVoiceRegStateRilRadioTechnologyChanged: vrs=" + state + " rat=" + rilVoiceRadioTechnology);
        this.mVoiceRegStateOrRatChangedRegistrants.notifyResult(new Pair(Integer.valueOf(state), Integer.valueOf(rilVoiceRadioTechnology)));
    }

    private Pair<Integer, Integer> getRegistrationInfo(int i) {
        NetworkRegistrationInfo networkRegistrationInfo = this.mSS.getNetworkRegistrationInfo(2, i);
        if (networkRegistrationInfo == null) {
            return null;
        }
        return new Pair<>(Integer.valueOf(regCodeToServiceState(networkRegistrationInfo.getRegistrationState())), Integer.valueOf(ServiceState.networkTypeToRilRadioTechnology(networkRegistrationInfo.getAccessNetworkTechnology())));
    }

    /* access modifiers changed from: protected */
    public void notifyDataRegStateRilRadioTechnologyChanged(int i) {
        Pair<Integer, Integer> registrationInfo;
        RegistrantList registrantList = this.mDataRegStateOrRatChangedRegistrants.get(i);
        if (registrantList != null && (registrationInfo = getRegistrationInfo(i)) != null) {
            registrantList.notifyResult(registrationInfo);
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void useDataRegStateForDataOnlyDevices() {
        if (!this.mVoiceCapable) {
            log("useDataRegStateForDataOnlyDevice: VoiceRegState=" + this.mNewSS.getState() + " DataRegState=" + this.mNewSS.getDataRegistrationState());
            ServiceState serviceState = this.mNewSS;
            serviceState.setVoiceRegState(serviceState.getDataRegistrationState());
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updatePhoneObject() {
        if (this.mPhone.getContext().getResources().getBoolean(17891798)) {
            if (!(this.mSS.getState() == 0 || this.mSS.getState() == 2)) {
                log("updatePhoneObject: Ignore update");
            } else {
                this.mPhone.updatePhoneObject(this.mSS.getRilVoiceRadioTechnology());
            }
        }
    }

    public void registerForVoiceRoamingOn(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mVoiceRoamingOnRegistrants.add(registrant);
        if (this.mSS.getVoiceRoaming()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForVoiceRoamingOn(Handler handler) {
        this.mVoiceRoamingOnRegistrants.remove(handler);
    }

    public void registerForVoiceRoamingOff(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mVoiceRoamingOffRegistrants.add(registrant);
        if (!this.mSS.getVoiceRoaming()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForVoiceRoamingOff(Handler handler) {
        this.mVoiceRoamingOffRegistrants.remove(handler);
    }

    public void registerForDataRoamingOn(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mDataRoamingOnRegistrants.add(registrant);
        if (this.mSS.getDataRoaming()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForDataRoamingOn(Handler handler) {
        this.mDataRoamingOnRegistrants.remove(handler);
    }

    public void registerForDataRoamingOff(Handler handler, int i, Object obj, boolean z) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mDataRoamingOffRegistrants.add(registrant);
        if (z && !this.mSS.getDataRoaming()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForDataRoamingOff(Handler handler) {
        this.mDataRoamingOffRegistrants.remove(handler);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void reRegisterNetwork(Message message) {
        this.mCi.getAllowedNetworkTypesBitmap(obtainMessage(19, message));
    }

    public Set<Integer> getRadioPowerOffReasons() {
        return this.mRadioPowerOffReasons;
    }

    public void clearAllRadioOffReasons() {
        this.mRadioPowerOffReasons.clear();
    }

    public final void setRadioPower(boolean z) {
        setRadioPower(z, false, false, false);
    }

    public void setRadioPower(boolean z, boolean z2, boolean z3, boolean z4) {
        setRadioPowerForReason(z, z2, z3, z4, 0);
    }

    public void setRadioPowerForReason(boolean z, boolean z2, boolean z3, boolean z4, int i) {
        log("setRadioPower power " + z + " forEmergencyCall " + z2 + " forceApply " + z4 + " reason " + i);
        if (!z) {
            this.mRadioPowerOffReasons.add(Integer.valueOf(i));
        } else if (z2) {
            clearAllRadioOffReasons();
        } else {
            this.mRadioPowerOffReasons.remove(Integer.valueOf(i));
        }
        if (z == this.mDesiredPowerState && !z4) {
            log("setRadioPower mDesiredPowerState is already " + z + " Do nothing.");
        } else if (!z || this.mRadioPowerOffReasons.isEmpty()) {
            this.mDesiredPowerState = z;
            setPowerStateToDesired(z2, z3, z4);
        } else {
            log("setRadioPowerForReason power: " + z + " forEmergencyCall= " + z2 + " isSelectedPhoneForEmergencyCall: " + z3 + " forceApply " + z4 + "reason:" + i + " will not power on the radio as it is powered off for the following reasons: " + this.mRadioPowerOffReasons + ".");
        }
    }

    public void setRadioPowerFromCarrier(boolean z) {
        boolean z2 = !z;
        if (this.mRadioDisabledByCarrier == z2) {
            log("setRadioPowerFromCarrier mRadioDisabledByCarrier is already " + z2 + " Do nothing.");
            return;
        }
        this.mRadioDisabledByCarrier = z2;
        setPowerStateToDesired();
    }

    public void enableSingleLocationUpdate(WorkSource workSource) {
        if (!this.mWantSingleLocationUpdate && !this.mWantContinuousLocationUpdates) {
            this.mWantSingleLocationUpdate = true;
            this.mCi.setLocationUpdates(true, workSource, obtainMessage(18));
        }
    }

    public void enableLocationUpdates() {
        if (!this.mWantSingleLocationUpdate && !this.mWantContinuousLocationUpdates) {
            this.mWantContinuousLocationUpdates = true;
            this.mCi.setLocationUpdates(true, (WorkSource) null, obtainMessage(18));
        }
    }

    /* access modifiers changed from: protected */
    public void disableSingleLocationUpdate() {
        this.mWantSingleLocationUpdate = false;
        if (!this.mWantContinuousLocationUpdates) {
            this.mCi.setLocationUpdates(false, (WorkSource) null, (Message) null);
        }
    }

    public void disableLocationUpdates() {
        this.mWantContinuousLocationUpdates = false;
        if (!this.mWantSingleLocationUpdate) {
            this.mCi.setLocationUpdates(false, (WorkSource) null, (Message) null);
        }
    }

    /*  JADX ERROR: IndexOutOfBoundsException in pass: RegionMakerVisitor
        java.lang.IndexOutOfBoundsException: Index: 0, Size: 0
        	at java.util.ArrayList.rangeCheck(ArrayList.java:659)
        	at java.util.ArrayList.get(ArrayList.java:435)
        	at jadx.core.dex.nodes.InsnNode.getArg(InsnNode.java:101)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:611)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.processMonitorEnter(RegionMaker.java:561)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverse(RegionMaker.java:133)
        	at jadx.core.dex.visitors.regions.RegionMaker.makeRegion(RegionMaker.java:86)
        	at jadx.core.dex.visitors.regions.RegionMaker.processSwitch(RegionMaker.java:871)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverse(RegionMaker.java:128)
        	at jadx.core.dex.visitors.regions.RegionMaker.makeRegion(RegionMaker.java:86)
        	at jadx.core.dex.visitors.regions.RegionMakerVisitor.visit(RegionMakerVisitor.java:49)
        */
    public void handleMessage(android.os.Message r15) {
        /*
            r14 = this;
            int r0 = r15.what
            r1 = 14
            r2 = 3
            r3 = 2
            r4 = 0
            r5 = 0
            r6 = 1
            switch(r0) {
                case 1: goto L_0x05f2;
                case 2: goto L_0x05ee;
                case 3: goto L_0x000c;
                case 4: goto L_0x05e6;
                case 5: goto L_0x05e6;
                case 6: goto L_0x05e6;
                case 7: goto L_0x05e6;
                case 8: goto L_0x000c;
                case 9: goto L_0x000c;
                case 10: goto L_0x000c;
                case 11: goto L_0x05be;
                case 12: goto L_0x000c;
                case 13: goto L_0x000c;
                case 14: goto L_0x058c;
                case 15: goto L_0x0569;
                case 16: goto L_0x0537;
                case 17: goto L_0x052d;
                case 18: goto L_0x0512;
                case 19: goto L_0x04e7;
                case 20: goto L_0x04d2;
                case 21: goto L_0x04b7;
                case 22: goto L_0x0479;
                case 23: goto L_0x0463;
                case 24: goto L_0x000c;
                case 25: goto L_0x000c;
                case 26: goto L_0x043f;
                case 27: goto L_0x03d2;
                case 28: goto L_0x000c;
                case 29: goto L_0x000c;
                case 30: goto L_0x000c;
                case 31: goto L_0x000c;
                case 32: goto L_0x000c;
                case 33: goto L_0x000c;
                case 34: goto L_0x0350;
                case 35: goto L_0x033f;
                case 36: goto L_0x000c;
                case 37: goto L_0x0317;
                case 38: goto L_0x02c1;
                case 39: goto L_0x02b6;
                case 40: goto L_0x02a0;
                case 41: goto L_0x000c;
                case 42: goto L_0x026c;
                case 43: goto L_0x01dc;
                case 44: goto L_0x01dc;
                case 45: goto L_0x01d2;
                case 46: goto L_0x01c5;
                case 47: goto L_0x01ab;
                case 48: goto L_0x019c;
                case 49: goto L_0x014f;
                case 50: goto L_0x05f2;
                case 51: goto L_0x0126;
                case 52: goto L_0x000c;
                case 53: goto L_0x010e;
                case 54: goto L_0x00f6;
                case 55: goto L_0x008d;
                case 56: goto L_0x006e;
                case 57: goto L_0x0069;
                case 58: goto L_0x0064;
                case 59: goto L_0x000c;
                case 60: goto L_0x000c;
                case 61: goto L_0x000c;
                case 62: goto L_0x005a;
                case 63: goto L_0x0051;
                case 64: goto L_0x003c;
                case 65: goto L_0x0024;
                default: goto L_0x000c;
            }
        L_0x000c:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "Unhandled message with number: "
            r0.append(r1)
            int r15 = r15.what
            r0.append(r15)
            java.lang.String r15 = r0.toString()
            r14.log(r15)
            goto L_0x0611
        L_0x0024:
            java.lang.String r15 = "EVENT_TELECOM_VOICE_SERVICE_STATE_OVERRIDE_CHANGED"
            r14.log(r15)
            android.telephony.ServiceState r15 = r14.mSS
            int r15 = r15.getState()
            if (r15 == 0) goto L_0x0611
            com.android.internal.telephony.GsmCdmaPhone r14 = r14.mPhone
            android.telephony.ServiceState r15 = r14.getServiceState()
            r14.notifyServiceStateChanged(r15)
            goto L_0x0611
        L_0x003c:
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            com.android.internal.telephony.data.DataNetworkController r15 = r15.getDataNetworkController()
            com.android.internal.telephony.ServiceStateTracker$2 r0 = new com.android.internal.telephony.ServiceStateTracker$2
            com.android.internal.telephony.ServiceStateTracker$$ExternalSyntheticLambda6 r1 = new com.android.internal.telephony.ServiceStateTracker$$ExternalSyntheticLambda6
            r1.<init>(r14)
            r0.<init>(r1)
            r15.registerDataNetworkControllerCallback(r0)
            goto L_0x0611
        L_0x0051:
            java.lang.String r15 = "EVENT_RESET_LAST_KNOWN_CELL_IDENTITY triggered"
            r14.log(r15)
            r14.mLastKnownCellIdentity = r4
            goto L_0x0611
        L_0x005a:
            java.lang.String r15 = "EVENT_POWER_OFF_RADIO_IMS_DEREG_TIMEOUT triggered"
            r14.log(r15)
            r14.powerOffRadioSafely()
            goto L_0x0611
        L_0x0064:
            r14.pollStateInternal(r5)
            goto L_0x0611
        L_0x0069:
            r14.onCarrierConfigChanged()
            goto L_0x0611
        L_0x006e:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            if (r15 != 0) goto L_0x007b
            java.lang.String r15 = "Invalid null response to getCellIdentity!"
            r14.loge(r15)
            goto L_0x0611
        L_0x007b:
            java.lang.Object r0 = r15.userObj
            android.os.Message r0 = (android.os.Message) r0
            android.telephony.CellIdentity r14 = r14.getCellIdentity()
            java.lang.Throwable r15 = r15.exception
            android.os.AsyncResult.forMessage(r0, r14, r15)
            r0.sendToTarget()
            goto L_0x0611
        L_0x008d:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 != 0) goto L_0x0611
            java.lang.Object r15 = r15.result
            java.util.List r15 = (java.util.List) r15
            r14.mLastPhysicalChannelConfigList = r15
            android.telephony.ServiceState r0 = r14.mSS
            boolean r0 = r14.updateNrStateFromPhysicalChannelConfigs(r15, r0)
            if (r0 == 0) goto L_0x00a9
            com.android.internal.telephony.RegistrantList r0 = r14.mNrStateChangedRegistrants
            r0.notifyRegistrants()
            r5 = r6
        L_0x00a9:
            android.telephony.ServiceState r0 = r14.mSS
            boolean r0 = r14.updateNrFrequencyRangeFromPhysicalChannelConfigs(r15, r0)
            if (r0 == 0) goto L_0x00b7
            com.android.internal.telephony.RegistrantList r0 = r14.mNrFrequencyChangedRegistrants
            r0.notifyRegistrants()
            goto L_0x00b8
        L_0x00b7:
            r6 = r5
        L_0x00b8:
            int[] r0 = getBandwidthsFromConfigs(r15)
            android.telephony.ServiceState r1 = r14.mSS
            boolean r0 = com.android.internal.telephony.RatRatcheter.updateBandwidths(r0, r1)
            r0 = r0 | r6
            com.android.internal.telephony.GsmCdmaPhone r1 = r14.mPhone
            r1.notifyPhysicalChannelConfig(r15)
            if (r0 == 0) goto L_0x0611
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            android.telephony.ServiceState r0 = r15.getServiceState()
            r15.notifyServiceStateChanged(r0)
            com.android.internal.telephony.metrics.TelephonyMetrics r15 = com.android.internal.telephony.metrics.TelephonyMetrics.getInstance()
            com.android.internal.telephony.GsmCdmaPhone r0 = r14.mPhone
            int r0 = r0.getPhoneId()
            android.telephony.ServiceState r1 = r14.mSS
            r15.writeServiceStateChanged(r0, r1)
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            com.android.internal.telephony.metrics.VoiceCallSessionStats r15 = r15.getVoiceCallSessionStats()
            android.telephony.ServiceState r0 = r14.mSS
            r15.onServiceStateChanged(r0)
            com.android.internal.telephony.metrics.ServiceStateStats r15 = r14.mServiceStateStats
            android.telephony.ServiceState r14 = r14.mSS
            r15.onServiceStateChanged(r14)
            goto L_0x0611
        L_0x00f6:
            java.lang.String r15 = "EVENT_RADIO_POWER_OFF_DONE"
            r14.log(r15)
            boolean r15 = r14.mDeviceShuttingDown
            if (r15 == 0) goto L_0x0611
            com.android.internal.telephony.CommandsInterface r15 = r14.mCi
            int r15 = r15.getRadioState()
            if (r15 == r3) goto L_0x0611
            com.android.internal.telephony.CommandsInterface r14 = r14.mCi
            r14.requestShutdown(r4)
            goto L_0x0611
        L_0x010e:
            java.lang.String r15 = "EVENT_IMS_SERVICE_STATE_CHANGED"
            r14.log(r15)
            android.telephony.ServiceState r15 = r14.mSS
            int r15 = r15.getState()
            if (r15 == 0) goto L_0x0611
            com.android.internal.telephony.GsmCdmaPhone r14 = r14.mPhone
            android.telephony.ServiceState r15 = r14.getServiceState()
            r14.notifyServiceStateChanged(r15)
            goto L_0x0611
        L_0x0126:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 != 0) goto L_0x0611
            java.lang.Object r15 = r15.result
            java.lang.Boolean r15 = (java.lang.Boolean) r15
            boolean r15 = r15.booleanValue()
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_RADIO_POWER_FROM_CARRIER: "
            r0.append(r1)
            r0.append(r15)
            java.lang.String r0 = r0.toString()
            r14.log(r0)
            r14.setRadioPowerFromCarrier(r15)
            goto L_0x0611
        L_0x014f:
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            boolean r15 = r15.isUsingNewDataStack()
            if (r15 == 0) goto L_0x0171
            java.lang.String r15 = "EVENT_ALL_DATA_DISCONNECTED"
            r14.log(r15)
            monitor-enter(r14)
            boolean r15 = r14.mPendingRadioPowerOffAfterDataOff     // Catch:{ all -> 0x016e }
            if (r15 == 0) goto L_0x016c
            java.lang.String r15 = "EVENT_ALL_DATA_DISCONNECTED, turn radio off now."
            r14.log(r15)     // Catch:{ all -> 0x016e }
            r14.cancelPendingRadioPowerOff()     // Catch:{ all -> 0x016e }
            r14.hangupAndPowerOff()     // Catch:{ all -> 0x016e }
        L_0x016c:
            monitor-exit(r14)     // Catch:{ all -> 0x016e }
            return
        L_0x016e:
            r15 = move-exception
            monitor-exit(r14)     // Catch:{ all -> 0x016e }
            throw r15
        L_0x0171:
            int r15 = android.telephony.SubscriptionManager.getDefaultDataSubscriptionId()
            com.android.internal.telephony.ProxyController r0 = com.android.internal.telephony.ProxyController.getInstance()
            r0.unregisterForAllDataDisconnected(r15, r14)
            monitor-enter(r14)
            boolean r15 = r14.mPendingRadioPowerOffAfterDataOff     // Catch:{ all -> 0x0199 }
            if (r15 == 0) goto L_0x0191
            java.lang.String r15 = "EVENT_ALL_DATA_DISCONNECTED, turn radio off now."
            r14.log(r15)     // Catch:{ all -> 0x0199 }
            r14.hangupAndPowerOff()     // Catch:{ all -> 0x0199 }
            int r15 = r14.mPendingRadioPowerOffAfterDataOffTag     // Catch:{ all -> 0x0199 }
            int r15 = r15 + r6
            r14.mPendingRadioPowerOffAfterDataOffTag = r15     // Catch:{ all -> 0x0199 }
            r14.mPendingRadioPowerOffAfterDataOff = r5     // Catch:{ all -> 0x0199 }
            goto L_0x0196
        L_0x0191:
            java.lang.String r15 = "EVENT_ALL_DATA_DISCONNECTED is stale"
            r14.log(r15)     // Catch:{ all -> 0x0199 }
        L_0x0196:
            monitor-exit(r14)     // Catch:{ all -> 0x0199 }
            goto L_0x0611
        L_0x0199:
            r15 = move-exception
            monitor-exit(r14)     // Catch:{ all -> 0x0199 }
            throw r15
        L_0x019c:
            java.lang.String r15 = "EVENT_IMS_CAPABILITY_CHANGED"
            r14.log(r15)
            r14.updateSpnDisplay()
            com.android.internal.telephony.RegistrantList r14 = r14.mImsCapabilityChangedRegistrants
            r14.notifyRegistrants()
            goto L_0x0611
        L_0x01ab:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 != 0) goto L_0x0611
            java.lang.Object r15 = r15.result
            int[] r15 = (int[]) r15
            r15 = r15[r5]
            if (r15 != r6) goto L_0x01bc
            r5 = r6
        L_0x01bc:
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            r15.setImsRegistrationState(r5)
            r14.mImsRegistered = r5
            goto L_0x0611
        L_0x01c5:
            com.android.internal.telephony.CommandsInterface r15 = r14.mCi
            r0 = 47
            android.os.Message r14 = r14.obtainMessage(r0)
            r15.getImsRegistrationState(r14)
            goto L_0x0611
        L_0x01d2:
            java.lang.String r15 = "EVENT_CHANGE_IMS_STATE:"
            r14.log(r15)
            r14.setPowerStateToDesired()
            goto L_0x0611
        L_0x01dc:
            java.lang.Object r15 = r15.obj
            if (r15 == 0) goto L_0x0219
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 == 0) goto L_0x01ff
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_GET_CELL_INFO_LIST: error ret null, e="
            r0.append(r1)
            java.lang.Throwable r1 = r15.exception
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            r14.log(r0)
            java.lang.Throwable r15 = r15.exception
            goto L_0x023c
        L_0x01ff:
            java.lang.Object r15 = r15.result
            if (r15 != 0) goto L_0x0209
            java.lang.String r15 = "Invalid CellInfo result"
            r14.loge(r15)
            goto L_0x023b
        L_0x0209:
            java.util.List r15 = (java.util.List) r15
            r14.updateOperatorNameForCellInfo(r15)
            r14.mLastCellInfoList = r15
            com.android.internal.telephony.GsmCdmaPhone r0 = r14.mPhone
            r0.notifyCellInfo(r15)
            r13 = r4
            r4 = r15
            r15 = r13
            goto L_0x023c
        L_0x0219:
            java.util.List<android.os.Message> r15 = r14.mPendingCellInfoRequests
            monitor-enter(r15)
            boolean r0 = r14.mIsPendingCellInfoRequest     // Catch:{ all -> 0x0269 }
            if (r0 != 0) goto L_0x0223
            monitor-exit(r15)     // Catch:{ all -> 0x0269 }
            goto L_0x0611
        L_0x0223:
            long r0 = android.os.SystemClock.elapsedRealtime()     // Catch:{ all -> 0x0269 }
            long r2 = r14.mLastCellInfoReqTime     // Catch:{ all -> 0x0269 }
            long r0 = r0 - r2
            r2 = 2000(0x7d0, double:9.88E-321)
            int r0 = (r0 > r2 ? 1 : (r0 == r2 ? 0 : -1))
            if (r0 >= 0) goto L_0x0233
            monitor-exit(r15)     // Catch:{ all -> 0x0269 }
            goto L_0x0611
        L_0x0233:
            java.lang.String r0 = "Timeout waiting for CellInfo; (everybody panic)!"
            r14.loge(r0)     // Catch:{ all -> 0x0269 }
            r14.mLastCellInfoList = r4     // Catch:{ all -> 0x0269 }
            monitor-exit(r15)     // Catch:{ all -> 0x0269 }
        L_0x023b:
            r15 = r4
        L_0x023c:
            java.util.List<android.os.Message> r0 = r14.mPendingCellInfoRequests
            monitor-enter(r0)
            boolean r1 = r14.mIsPendingCellInfoRequest     // Catch:{ all -> 0x0266 }
            if (r1 == 0) goto L_0x0263
            r14.mIsPendingCellInfoRequest = r5     // Catch:{ all -> 0x0266 }
            java.util.List<android.os.Message> r1 = r14.mPendingCellInfoRequests     // Catch:{ all -> 0x0266 }
            java.util.Iterator r1 = r1.iterator()     // Catch:{ all -> 0x0266 }
        L_0x024b:
            boolean r2 = r1.hasNext()     // Catch:{ all -> 0x0266 }
            if (r2 == 0) goto L_0x025e
            java.lang.Object r2 = r1.next()     // Catch:{ all -> 0x0266 }
            android.os.Message r2 = (android.os.Message) r2     // Catch:{ all -> 0x0266 }
            android.os.AsyncResult.forMessage(r2, r4, r15)     // Catch:{ all -> 0x0266 }
            r2.sendToTarget()     // Catch:{ all -> 0x0266 }
            goto L_0x024b
        L_0x025e:
            java.util.List<android.os.Message> r14 = r14.mPendingCellInfoRequests     // Catch:{ all -> 0x0266 }
            r14.clear()     // Catch:{ all -> 0x0266 }
        L_0x0263:
            monitor-exit(r0)     // Catch:{ all -> 0x0266 }
            goto L_0x0611
        L_0x0266:
            r14 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0266 }
            throw r14
        L_0x0269:
            r14 = move-exception
            monitor-exit(r15)     // Catch:{ all -> 0x0269 }
            throw r14
        L_0x026c:
            boolean r15 = r14.isSimAbsent()
            if (r15 == 0) goto L_0x028a
            java.lang.String r15 = "EVENT_ICC_CHANGED: SIM absent"
            r14.log(r15)
            r14.cancelAllNotifications()
            r14.mMdn = r4
            r14.mMin = r4
            r14.mIsMinInfoReady = r5
            com.android.internal.telephony.cdnr.CarrierDisplayNameResolver r15 = r14.mCdnr
            r15.updateEfFromRuim(r4)
            com.android.internal.telephony.cdnr.CarrierDisplayNameResolver r15 = r14.mCdnr
            r15.updateEfFromUsim(r4)
        L_0x028a:
            r14.onUpdateIccAvailability()
            com.android.internal.telephony.uicc.UiccCardApplication r15 = r14.mUiccApplcation
            if (r15 == 0) goto L_0x0299
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r15 = r15.getState()
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r0 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_READY
            if (r15 == r0) goto L_0x0611
        L_0x0299:
            r14.mIsSimReady = r5
            r14.updateSpnDisplay()
            goto L_0x0611
        L_0x02a0:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 != 0) goto L_0x0611
            java.lang.Object r15 = r15.result
            int[] r15 = (int[]) r15
            r15 = r15[r5]
            java.lang.String r15 = java.lang.Integer.toString(r15)
            r14.mPrlVersion = r15
            goto L_0x0611
        L_0x02b6:
            com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager r15 = r14.mCdmaSSM
            int r15 = r15.getCdmaSubscriptionSource()
            r14.handleCdmaSubscriptionSource(r15)
            goto L_0x0611
        L_0x02c1:
            monitor-enter(r14)
            com.android.internal.telephony.GsmCdmaPhone r0 = r14.mPhone     // Catch:{ all -> 0x0314 }
            boolean r0 = r0.isUsingNewDataStack()     // Catch:{ all -> 0x0314 }
            if (r0 == 0) goto L_0x02d7
            java.lang.String r15 = "Wait for all data networks torn down timed out. Power off now."
            r14.log(r15)     // Catch:{ all -> 0x0314 }
            r14.cancelPendingRadioPowerOff()     // Catch:{ all -> 0x0314 }
            r14.hangupAndPowerOff()     // Catch:{ all -> 0x0314 }
            monitor-exit(r14)     // Catch:{ all -> 0x0314 }
            return
        L_0x02d7:
            boolean r0 = r14.mPendingRadioPowerOffAfterDataOff     // Catch:{ all -> 0x0314 }
            if (r0 == 0) goto L_0x02f1
            int r0 = r15.arg1     // Catch:{ all -> 0x0314 }
            int r1 = r14.mPendingRadioPowerOffAfterDataOffTag     // Catch:{ all -> 0x0314 }
            if (r0 != r1) goto L_0x02f1
            java.lang.String r15 = "EVENT_SET_RADIO_OFF, turn radio off now."
            r14.log(r15)     // Catch:{ all -> 0x0314 }
            r14.hangupAndPowerOff()     // Catch:{ all -> 0x0314 }
            int r15 = r14.mPendingRadioPowerOffAfterDataOffTag     // Catch:{ all -> 0x0314 }
            int r15 = r15 + r6
            r14.mPendingRadioPowerOffAfterDataOffTag = r15     // Catch:{ all -> 0x0314 }
            r14.mPendingRadioPowerOffAfterDataOff = r5     // Catch:{ all -> 0x0314 }
            goto L_0x0311
        L_0x02f1:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x0314 }
            r0.<init>()     // Catch:{ all -> 0x0314 }
            java.lang.String r1 = "EVENT_SET_RADIO_OFF is stale arg1="
            r0.append(r1)     // Catch:{ all -> 0x0314 }
            int r15 = r15.arg1     // Catch:{ all -> 0x0314 }
            r0.append(r15)     // Catch:{ all -> 0x0314 }
            java.lang.String r15 = "!= tag="
            r0.append(r15)     // Catch:{ all -> 0x0314 }
            int r15 = r14.mPendingRadioPowerOffAfterDataOffTag     // Catch:{ all -> 0x0314 }
            r0.append(r15)     // Catch:{ all -> 0x0314 }
            java.lang.String r15 = r0.toString()     // Catch:{ all -> 0x0314 }
            r14.log(r15)     // Catch:{ all -> 0x0314 }
        L_0x0311:
            monitor-exit(r14)     // Catch:{ all -> 0x0314 }
            goto L_0x0611
        L_0x0314:
            r15 = move-exception
            monitor-exit(r14)     // Catch:{ all -> 0x0314 }
            throw r15
        L_0x0317:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 != 0) goto L_0x0611
            java.lang.Object r15 = r15.result
            int[] r15 = (int[]) r15
            r15 = r15[r5]
            r0 = 8
            if (r15 == r0) goto L_0x032d
            r0 = 10
            if (r15 != r0) goto L_0x0611
        L_0x032d:
            java.lang.String r15 = "EVENT_OTA_PROVISION_STATUS_CHANGE: Complete, Reload MDN"
            r14.log(r15)
            com.android.internal.telephony.CommandsInterface r15 = r14.mCi
            r0 = 34
            android.os.Message r14 = r14.obtainMessage(r0)
            r15.getCDMASubscription(r14)
            goto L_0x0611
        L_0x033f:
            r14.updatePhoneObject()
            com.android.internal.telephony.CommandsInterface r15 = r14.mCi
            android.os.Message r0 = r14.obtainMessage(r1)
            r15.getNetworkSelectionMode(r0)
            r14.getSubscriptionInfoAndStartPollingThreads()
            goto L_0x0611
        L_0x0350:
            com.android.internal.telephony.GsmCdmaPhone r0 = r14.mPhone
            boolean r0 = r0.isPhoneTypeGsm()
            if (r0 != 0) goto L_0x0611
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 != 0) goto L_0x0611
            java.lang.Object r15 = r15.result
            java.lang.String[] r15 = (java.lang.String[]) r15
            if (r15 == 0) goto L_0x03bb
            int r0 = r15.length
            r1 = 5
            if (r0 < r1) goto L_0x03bb
            r0 = r15[r5]
            r14.mMdn = r0
            r0 = r15[r6]
            r1 = r15[r3]
            r14.parseSidNid(r0, r1)
            r0 = r15[r2]
            r14.mMin = r0
            r0 = 4
            r15 = r15[r0]
            r14.mPrlVersion = r15
            java.lang.StringBuilder r15 = new java.lang.StringBuilder
            r15.<init>()
            java.lang.String r0 = "GET_CDMA_SUBSCRIPTION: MDN="
            r15.append(r0)
            java.lang.String r0 = r14.mMdn
            r15.append(r0)
            java.lang.String r15 = r15.toString()
            r14.log(r15)
            r14.mIsMinInfoReady = r6
            r14.updateOtaspState()
            r14.notifyCdmaSubscriptionInfoReady()
            boolean r15 = r14.mIsSubscriptionFromRuim
            if (r15 != 0) goto L_0x03b4
            com.android.internal.telephony.uicc.IccRecords r15 = r14.mIccRecords
            if (r15 == 0) goto L_0x03b4
            java.lang.String r15 = "GET_CDMA_SUBSCRIPTION set imsi in mIccRecords"
            r14.log(r15)
            com.android.internal.telephony.uicc.IccRecords r15 = r14.mIccRecords
            java.lang.String r14 = r14.getImsi()
            r15.setImsi(r14)
            goto L_0x0611
        L_0x03b4:
            java.lang.String r15 = "GET_CDMA_SUBSCRIPTION either mIccRecords is null or NV type device - not setting Imsi in mIccRecords"
            r14.log(r15)
            goto L_0x0611
        L_0x03bb:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "GET_CDMA_SUBSCRIPTION: error parsing cdmaSubscription params num="
            r0.append(r1)
            int r15 = r15.length
            r0.append(r15)
            java.lang.String r15 = r0.toString()
            r14.log(r15)
            goto L_0x0611
        L_0x03d2:
            com.android.internal.telephony.GsmCdmaPhone r0 = r14.mPhone
            boolean r0 = r0.isPhoneTypeGsm()
            if (r0 != 0) goto L_0x0611
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_RUIM_RECORDS_LOADED: what="
            r0.append(r1)
            int r15 = r15.what
            r0.append(r15)
            java.lang.String r15 = r0.toString()
            r14.log(r15)
            com.android.internal.telephony.cdnr.CarrierDisplayNameResolver r15 = r14.mCdnr
            com.android.internal.telephony.uicc.IccRecords r0 = r14.mIccRecords
            com.android.internal.telephony.uicc.RuimRecords r0 = (com.android.internal.telephony.uicc.RuimRecords) r0
            r15.updateEfFromRuim(r0)
            r14.updatePhoneObject()
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            boolean r15 = r15.isPhoneTypeCdma()
            if (r15 == 0) goto L_0x0409
            r14.updateSpnDisplay()
            goto L_0x0611
        L_0x0409:
            com.android.internal.telephony.uicc.IccRecords r15 = r14.mIccRecords
            com.android.internal.telephony.uicc.RuimRecords r15 = (com.android.internal.telephony.uicc.RuimRecords) r15
            if (r15 == 0) goto L_0x043a
            java.lang.String r0 = r15.getMdn()
            r14.mMdn = r0
            boolean r0 = r15.isProvisioned()
            if (r0 == 0) goto L_0x0434
            java.lang.String r0 = r15.getMin()
            r14.mMin = r0
            java.lang.String r0 = r15.getSid()
            java.lang.String r1 = r15.getNid()
            r14.parseSidNid(r0, r1)
            java.lang.String r15 = r15.getPrlVersion()
            r14.mPrlVersion = r15
            r14.mIsMinInfoReady = r6
        L_0x0434:
            r14.updateOtaspState()
            r14.notifyCdmaSubscriptionInfoReady()
        L_0x043a:
            r14.pollStateInternal(r5)
            goto L_0x0611
        L_0x043f:
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            int r15 = r15.getLteOnCdmaMode()
            if (r15 != r6) goto L_0x0450
            java.lang.String r15 = "Receive EVENT_RUIM_READY"
            r14.log(r15)
            r14.pollStateInternal(r5)
            goto L_0x0458
        L_0x0450:
            java.lang.String r15 = "Receive EVENT_RUIM_READY and Send Request getCDMASubscription."
            r14.log(r15)
            r14.getSubscriptionInfoAndStartPollingThreads()
        L_0x0458:
            com.android.internal.telephony.CommandsInterface r15 = r14.mCi
            android.os.Message r14 = r14.obtainMessage(r1)
            r15.getNetworkSelectionMode(r14)
            goto L_0x0611
        L_0x0463:
            com.android.internal.telephony.GsmCdmaPhone r0 = r14.mPhone
            boolean r0 = r0.isPhoneTypeGsm()
            if (r0 == 0) goto L_0x0611
            java.lang.String r0 = "EVENT_RESTRICTED_STATE_CHANGED"
            r14.log(r0)
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            r14.onRestrictedStateChanged(r15)
            goto L_0x0611
        L_0x0479:
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            boolean r15 = r15.isPhoneTypeGsm()
            if (r15 == 0) goto L_0x04b3
            android.telephony.ServiceState r15 = r14.mSS
            if (r15 == 0) goto L_0x04b3
            int r15 = r15.getDataRegistrationState()
            android.telephony.ServiceState r0 = r14.mSS
            int r0 = r0.getState()
            boolean r15 = r14.isGprsConsistent(r15, r0)
            if (r15 != 0) goto L_0x04b3
            r15 = 50107(0xc3bb, float:7.0215E-41)
            java.lang.Object[] r0 = new java.lang.Object[r3]
            android.telephony.ServiceState r1 = r14.mSS
            java.lang.String r1 = r1.getOperatorNumeric()
            r0[r5] = r1
            android.telephony.CellIdentity r1 = r14.mCellIdentity
            long r1 = getCidFromCellIdentity(r1)
            java.lang.Long r1 = java.lang.Long.valueOf(r1)
            r0[r6] = r1
            android.util.EventLog.writeEvent(r15, r0)
            r14.mReportedGprsNoReg = r6
        L_0x04b3:
            r14.mStartedGprsRegCheck = r5
            goto L_0x0611
        L_0x04b7:
            java.lang.Object r14 = r15.obj
            android.os.AsyncResult r14 = (android.os.AsyncResult) r14
            java.lang.Object r15 = r14.userObj
            if (r15 == 0) goto L_0x0611
            android.os.Message r15 = (android.os.Message) r15
            android.os.AsyncResult r15 = android.os.AsyncResult.forMessage(r15)
            java.lang.Throwable r0 = r14.exception
            r15.exception = r0
            java.lang.Object r14 = r14.userObj
            android.os.Message r14 = (android.os.Message) r14
            r14.sendToTarget()
            goto L_0x0611
        L_0x04d2:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            r0 = 21
            java.lang.Object r15 = r15.userObj
            android.os.Message r15 = r14.obtainMessage(r0, r15)
            com.android.internal.telephony.CommandsInterface r0 = r14.mCi
            int r14 = r14.mAllowedNetworkTypes
            r0.setAllowedNetworkTypesBitmap(r14, r15)
            goto L_0x0611
        L_0x04e7:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            r1 = 7
            if (r0 != 0) goto L_0x04f9
            java.lang.Object r0 = r15.result
            int[] r0 = (int[]) r0
            r0 = r0[r5]
            r14.mAllowedNetworkTypes = r0
            goto L_0x04ff
        L_0x04f9:
            int r0 = android.telephony.RadioAccessFamily.getRafFromNetworkType(r1)
            r14.mAllowedNetworkTypes = r0
        L_0x04ff:
            r0 = 20
            java.lang.Object r15 = r15.userObj
            android.os.Message r15 = r14.obtainMessage(r0, r15)
            int r0 = android.telephony.RadioAccessFamily.getRafFromNetworkType(r1)
            com.android.internal.telephony.CommandsInterface r14 = r14.mCi
            r14.setAllowedNetworkTypesBitmap(r0, r15)
            goto L_0x0611
        L_0x0512:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r15 = r15.exception
            if (r15 != 0) goto L_0x0611
            android.util.SparseArray<com.android.internal.telephony.NetworkRegistrationManager> r15 = r14.mRegStateManagers
            java.lang.Object r15 = r15.get(r6)
            com.android.internal.telephony.NetworkRegistrationManager r15 = (com.android.internal.telephony.NetworkRegistrationManager) r15
            r0 = 15
            android.os.Message r14 = r14.obtainMessage(r0, r4)
            r15.requestNetworkRegistrationInfo(r6, r14)
            goto L_0x0611
        L_0x052d:
            r15 = -1
            r14.mPrevSubId = r15
            r14.mIsSimReady = r6
            r14.pollStateInternal(r5)
            goto L_0x0611
        L_0x0537:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_SIM_RECORDS_LOADED: what="
            r0.append(r1)
            int r15 = r15.what
            r0.append(r15)
            java.lang.String r15 = r0.toString()
            r14.log(r15)
            r14.updatePhoneObject()
            r14.updateOtaspState()
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            boolean r15 = r15.isPhoneTypeGsm()
            if (r15 == 0) goto L_0x0611
            com.android.internal.telephony.cdnr.CarrierDisplayNameResolver r15 = r14.mCdnr
            com.android.internal.telephony.uicc.IccRecords r0 = r14.mIccRecords
            com.android.internal.telephony.uicc.SIMRecords r0 = (com.android.internal.telephony.uicc.SIMRecords) r0
            r15.updateEfFromUsim(r0)
            r14.updateSpnDisplay()
            goto L_0x0611
        L_0x0569:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Throwable r0 = r15.exception
            if (r0 != 0) goto L_0x0587
            java.lang.Object r15 = r15.result
            android.telephony.NetworkRegistrationInfo r15 = (android.telephony.NetworkRegistrationInfo) r15
            android.telephony.CellIdentity r15 = r15.getCellIdentity()
            r14.updateOperatorNameForCellIdentity(r15)
            r14.mCellIdentity = r15
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            android.telephony.CellIdentity r0 = r14.getCellIdentity()
            r15.notifyLocationChanged(r0)
        L_0x0587:
            r14.disableSingleLocationUpdate()
            goto L_0x0611
        L_0x058c:
            java.lang.String r0 = "EVENT_POLL_STATE_NETWORK_SELECTION_MODE"
            r14.log(r0)
            java.lang.Object r0 = r15.obj
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0
            com.android.internal.telephony.GsmCdmaPhone r1 = r14.mPhone
            boolean r1 = r1.isPhoneTypeGsm()
            if (r1 == 0) goto L_0x05a4
            int r15 = r15.what
            r14.handlePollStateResult(r15, r0)
            goto L_0x0611
        L_0x05a4:
            java.lang.Throwable r15 = r0.exception
            if (r15 != 0) goto L_0x05b8
            java.lang.Object r15 = r0.result
            if (r15 == 0) goto L_0x05b8
            int[] r15 = (int[]) r15
            r15 = r15[r5]
            if (r15 != r6) goto L_0x0611
            com.android.internal.telephony.GsmCdmaPhone r14 = r14.mPhone
            r14.setNetworkSelectionModeAutomatic(r4)
            goto L_0x0611
        L_0x05b8:
            java.lang.String r15 = "Unable to getNetworkSelectionMode"
            r14.log(r15)
            goto L_0x0611
        L_0x05be:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            java.lang.Object r15 = r15.result
            java.lang.Object[] r15 = (java.lang.Object[]) r15
            r0 = r15[r5]
            r8 = r0
            java.lang.String r8 = (java.lang.String) r8
            r0 = r15[r6]
            java.lang.Long r0 = (java.lang.Long) r0
            long r9 = r0.longValue()
            r0 = 0
            int r4 = r15.length
            if (r4 < r2) goto L_0x05e0
            r15 = r15[r3]
            java.lang.Long r15 = (java.lang.Long) r15
            long r0 = r15.longValue()
        L_0x05e0:
            r11 = r0
            r7 = r14
            r7.setTimeFromNITZString(r8, r9, r11)
            goto L_0x0611
        L_0x05e6:
            java.lang.Object r15 = r15.obj
            android.os.AsyncResult r15 = (android.os.AsyncResult) r15
            r14.handlePollStateResult(r0, r15)
            goto L_0x0611
        L_0x05ee:
            r14.pollStateInternal(r6)
            goto L_0x0611
        L_0x05f2:
            com.android.internal.telephony.GsmCdmaPhone r15 = r14.mPhone
            boolean r15 = r15.isPhoneTypeGsm()
            if (r15 != 0) goto L_0x060b
            com.android.internal.telephony.CommandsInterface r15 = r14.mCi
            int r15 = r15.getRadioState()
            if (r15 != r6) goto L_0x060b
            com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager r15 = r14.mCdmaSSM
            int r15 = r15.getCdmaSubscriptionSource()
            r14.handleCdmaSubscriptionSource(r15)
        L_0x060b:
            r14.setPowerStateToDesired()
            r14.pollStateInternal(r6)
        L_0x0611:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.handleMessage(android.os.Message):void");
    }

    private boolean isSimAbsent() {
        UiccCard uiccCard;
        UiccController uiccController = this.mUiccController;
        if (uiccController == null || (uiccCard = uiccController.getUiccCard(this.mPhone.getPhoneId())) == null || uiccCard.getCardState() == IccCardStatus.CardState.CARDSTATE_ABSENT) {
            return true;
        }
        return false;
    }

    private static int[] getBandwidthsFromConfigs(List<PhysicalChannelConfig> list) {
        return list.stream().map(new ServiceStateTracker$$ExternalSyntheticLambda0()).mapToInt(new RILUtils$$ExternalSyntheticLambda5()).toArray();
    }

    /* access modifiers changed from: protected */
    public boolean isSidsAllZeros() {
        if (this.mHomeSystemId == null) {
            return true;
        }
        int i = 0;
        while (true) {
            int[] iArr = this.mHomeSystemId;
            if (i >= iArr.length) {
                return true;
            }
            if (iArr[i] != 0) {
                return false;
            }
            i++;
        }
    }

    public ServiceState getServiceState() {
        return new ServiceState(this.mSS);
    }

    /* access modifiers changed from: protected */
    public boolean isHomeSid(int i) {
        if (this.mHomeSystemId != null) {
            int i2 = 0;
            while (true) {
                int[] iArr = this.mHomeSystemId;
                if (i2 >= iArr.length) {
                    break;
                } else if (i == iArr[i2]) {
                    return true;
                } else {
                    i2++;
                }
            }
        }
        return false;
    }

    public String getMdnNumber() {
        return this.mMdn;
    }

    public String getCdmaMin() {
        return this.mMin;
    }

    public String getPrlVersion() {
        return this.mPrlVersion;
    }

    public String getImsi() {
        String simOperatorNumericForPhone = ((TelephonyManager) this.mPhone.getContext().getSystemService("phone")).getSimOperatorNumericForPhone(this.mPhone.getPhoneId());
        if (TextUtils.isEmpty(simOperatorNumericForPhone) || getCdmaMin() == null) {
            return null;
        }
        return simOperatorNumericForPhone + getCdmaMin();
    }

    public boolean isMinInfoReady() {
        return this.mIsMinInfoReady;
    }

    public int getOtasp() {
        if (!this.mPhone.getIccRecordsLoaded()) {
            log("getOtasp: otasp uninitialized due to sim not loaded");
            return 0;
        }
        int i = 3;
        if (this.mPhone.isPhoneTypeGsm()) {
            log("getOtasp: otasp not needed for GSM");
            return 3;
        } else if (this.mIsSubscriptionFromRuim && this.mMin == null) {
            return 2;
        } else {
            String str = this.mMin;
            if (str == null || str.length() < 6) {
                log("getOtasp: bad mMin='" + this.mMin + "'");
                i = 1;
            } else if (this.mMin.equals(UNACTIVATED_MIN_VALUE) || this.mMin.substring(0, 6).equals(UNACTIVATED_MIN2_VALUE) || SystemProperties.getBoolean("test_cdma_setup", false)) {
                i = 2;
            }
            log("getOtasp: state=" + i);
            return i;
        }
    }

    /* access modifiers changed from: protected */
    public void parseSidNid(String str, String str2) {
        if (str != null) {
            String[] split = str.split(",");
            this.mHomeSystemId = new int[split.length];
            for (int i = 0; i < split.length; i++) {
                try {
                    this.mHomeSystemId[i] = Integer.parseInt(split[i]);
                } catch (NumberFormatException e) {
                    loge("error parsing system id: " + e);
                }
            }
        }
        log("CDMA_SUBSCRIPTION: SID=" + str);
        if (str2 != null) {
            String[] split2 = str2.split(",");
            this.mHomeNetworkId = new int[split2.length];
            for (int i2 = 0; i2 < split2.length; i2++) {
                try {
                    this.mHomeNetworkId[i2] = Integer.parseInt(split2[i2]);
                } catch (NumberFormatException e2) {
                    loge("CDMA_SUBSCRIPTION: error parsing network id: " + e2);
                }
            }
        }
        log("CDMA_SUBSCRIPTION: NID=" + str2);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateOtaspState() {
        int otasp = getOtasp();
        int i = this.mCurrentOtaspMode;
        this.mCurrentOtaspMode = otasp;
        if (i != otasp) {
            log("updateOtaspState: call notifyOtaspChanged old otaspMode=" + i + " new otaspMode=" + this.mCurrentOtaspMode);
            this.mPhone.notifyOtaspChanged(this.mCurrentOtaspMode);
        }
    }

    public void onAirplaneModeChanged(boolean z) {
        this.mLastNitzData = null;
        this.mNitzState.handleAirplaneModeChanged(z);
        this.mAirplaneModeChangedRegistrants.notifyResult(Boolean.valueOf(z));
    }

    /* access modifiers changed from: protected */
    public Phone getPhone() {
        return this.mPhone;
    }

    /* access modifiers changed from: protected */
    public void handlePollStateResult(int i, AsyncResult asyncResult) {
        boolean isRoamingBetweenOperators;
        if (asyncResult.userObj == this.mPollingContext) {
            Throwable th = asyncResult.exception;
            boolean z = false;
            if (th != null) {
                CommandException.Error error = null;
                if (th instanceof IllegalStateException) {
                    log("handlePollStateResult exception " + asyncResult.exception);
                }
                Throwable th2 = asyncResult.exception;
                if (th2 instanceof CommandException) {
                    error = ((CommandException) th2).getCommandError();
                }
                if (this.mCi.getRadioState() != 1) {
                    log("handlePollStateResult: Invalid response due to radio off or unavailable. Set ServiceState to out of service.");
                    pollStateInternal(false);
                    return;
                } else if (error == CommandException.Error.RADIO_NOT_AVAILABLE) {
                    loge("handlePollStateResult: RIL returned RADIO_NOT_AVAILABLE when radio is on.");
                    cancelPollState();
                    return;
                } else if (error != CommandException.Error.OP_NOT_ALLOWED_BEFORE_REG_NW) {
                    loge("handlePollStateResult: RIL returned an error where it must succeed: " + asyncResult.exception);
                }
            } else {
                try {
                    handlePollStateResultMessage(i, asyncResult);
                } catch (RuntimeException e) {
                    loge("Exception while polling service state. Probably malformed RIL response." + e);
                }
            }
            int[] iArr = this.mPollingContext;
            int i2 = iArr[0] - 1;
            iArr[0] = i2;
            if (i2 == 0) {
                this.mNewSS.setEmergencyOnly(this.mEmergencyOnly);
                combinePsRegistrationStates(this.mNewSS);
                updateOperatorNameForServiceState(this.mNewSS);
                if (this.mPhone.isPhoneTypeGsm()) {
                    updateRoamingState();
                } else {
                    boolean z2 = !isSidsAllZeros() && isHomeSid(this.mNewSS.getCdmaSystemId());
                    if (this.mIsSubscriptionFromRuim && (isRoamingBetweenOperators = isRoamingBetweenOperators(this.mNewSS.getVoiceRoaming(), this.mNewSS)) != this.mNewSS.getVoiceRoaming()) {
                        log("isRoamingBetweenOperators=" + isRoamingBetweenOperators + ". Override CDMA voice roaming to " + isRoamingBetweenOperators);
                        this.mNewSS.setVoiceRoaming(isRoamingBetweenOperators);
                    }
                    if (ServiceState.isCdma(getRilDataRadioTechnologyForWwan(this.mNewSS))) {
                        if (this.mNewSS.getState() == 0) {
                            z = true;
                        }
                        if (z) {
                            boolean voiceRoaming = this.mNewSS.getVoiceRoaming();
                            if (this.mNewSS.getDataRoaming() != voiceRoaming) {
                                log("Data roaming != Voice roaming. Override data roaming to " + voiceRoaming);
                                this.mNewSS.setDataRoaming(voiceRoaming);
                            }
                        } else {
                            boolean isRoamIndForHomeSystem = isRoamIndForHomeSystem(this.mRoamingIndicator);
                            if (this.mNewSS.getDataRoaming() == isRoamIndForHomeSystem) {
                                StringBuilder sb = new StringBuilder();
                                sb.append("isRoamIndForHomeSystem=");
                                sb.append(isRoamIndForHomeSystem);
                                sb.append(", override data roaming to ");
                                sb.append(!isRoamIndForHomeSystem);
                                log(sb.toString());
                                this.mNewSS.setDataRoaming(!isRoamIndForHomeSystem);
                            }
                        }
                    }
                    this.mNewSS.setCdmaDefaultRoamingIndicator(this.mDefaultRoamingIndicator);
                    this.mNewSS.setCdmaRoamingIndicator(this.mRoamingIndicator);
                    boolean z3 = !TextUtils.isEmpty(this.mPrlVersion);
                    if (!z3 || this.mNewSS.getRilVoiceRadioTechnology() == 0) {
                        log("Turn off roaming indicator if !isPrlLoaded or voice RAT is unknown");
                        this.mNewSS.setCdmaRoamingIndicator(1);
                    } else if (!isSidsAllZeros()) {
                        if (!z2 && !this.mIsInPrl) {
                            this.mNewSS.setCdmaRoamingIndicator(this.mDefaultRoamingIndicator);
                        } else if (!z2 || this.mIsInPrl) {
                            if (z2 || !this.mIsInPrl) {
                                int i3 = this.mRoamingIndicator;
                                if (i3 <= 2) {
                                    this.mNewSS.setCdmaRoamingIndicator(1);
                                } else {
                                    this.mNewSS.setCdmaRoamingIndicator(i3);
                                }
                            } else {
                                this.mNewSS.setCdmaRoamingIndicator(this.mRoamingIndicator);
                            }
                        } else if (ServiceState.isPsOnlyTech(this.mNewSS.getRilVoiceRadioTechnology())) {
                            log("Turn off roaming indicator as voice is LTE or NR");
                            this.mNewSS.setCdmaRoamingIndicator(1);
                        } else {
                            this.mNewSS.setCdmaRoamingIndicator(2);
                        }
                    }
                    if (this.mEriManager != null) {
                        int cdmaRoamingIndicator = this.mNewSS.getCdmaRoamingIndicator();
                        this.mNewSS.setCdmaEriIconIndex(this.mEriManager.getCdmaEriIconIndex(cdmaRoamingIndicator, this.mDefaultRoamingIndicator));
                        this.mNewSS.setCdmaEriIconMode(this.mEriManager.getCdmaEriIconMode(cdmaRoamingIndicator, this.mDefaultRoamingIndicator));
                    }
                    log("Set CDMA Roaming Indicator to: " + this.mNewSS.getCdmaRoamingIndicator() + ". voiceRoaming = " + this.mNewSS.getVoiceRoaming() + ". dataRoaming = " + this.mNewSS.getDataRoaming() + ", isPrlLoaded = " + z3 + ". namMatch = " + z2 + " , mIsInPrl = " + this.mIsInPrl + ", mRoamingIndicator = " + this.mRoamingIndicator + ", mDefaultRoamingIndicator= " + this.mDefaultRoamingIndicator);
                }
                pollStateDone();
            }
        }
    }

    /* access modifiers changed from: protected */
    public boolean isRoamingBetweenOperators(boolean z, ServiceState serviceState) {
        return z && !isSameOperatorNameFromSimAndSS(serviceState);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Removed duplicated region for block: B:13:0x002f  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean updateNrFrequencyRangeFromPhysicalChannelConfigs(java.util.List<android.telephony.PhysicalChannelConfig> r4, android.telephony.ServiceState r5) {
        /*
            r3 = this;
            r0 = 0
            if (r4 == 0) goto L_0x0028
            java.util.Iterator r4 = r4.iterator()
        L_0x0007:
            boolean r1 = r4.hasNext()
            if (r1 == 0) goto L_0x0028
            java.lang.Object r1 = r4.next()
            android.telephony.PhysicalChannelConfig r1 = (android.telephony.PhysicalChannelConfig) r1
            boolean r2 = r3.isNrPhysicalChannelConfig(r1)
            if (r2 == 0) goto L_0x0007
            boolean r2 = r3.isInternetPhysicalChannelConfig(r1)
            if (r2 == 0) goto L_0x0007
            int r3 = r1.getFrequencyRange()
            int r3 = android.telephony.ServiceState.getBetterNRFrequencyRange(r0, r3)
            goto L_0x0029
        L_0x0028:
            r3 = r0
        L_0x0029:
            int r4 = r5.getNrFrequencyRange()
            if (r3 == r4) goto L_0x0030
            r0 = 1
        L_0x0030:
            r5.setNrFrequencyRange(r3)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.updateNrFrequencyRangeFromPhysicalChannelConfigs(java.util.List, android.telephony.ServiceState):boolean");
    }

    /* access modifiers changed from: protected */
    public boolean updateNrStateFromPhysicalChannelConfigs(List<PhysicalChannelConfig> list, ServiceState serviceState) {
        boolean z;
        int i;
        boolean z2 = true;
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, 1);
        if (networkRegistrationInfo == null || list == null) {
            return false;
        }
        Iterator<PhysicalChannelConfig> it = list.iterator();
        while (true) {
            if (!it.hasNext()) {
                z = false;
                break;
            }
            PhysicalChannelConfig next = it.next();
            if (isNrPhysicalChannelConfig(next) && isInternetPhysicalChannelConfig(next) && next.getConnectionStatus() == 2) {
                z = true;
                break;
            }
        }
        int nrState = networkRegistrationInfo.getNrState();
        if (networkRegistrationInfo.getAccessNetworkTechnology() != 13 || !z) {
            networkRegistrationInfo.updateNrState();
            i = networkRegistrationInfo.getNrState();
        } else {
            i = 3;
        }
        if (i == nrState) {
            z2 = false;
        }
        networkRegistrationInfo.setNrState(i);
        serviceState.addNetworkRegistrationInfo(networkRegistrationInfo);
        return z2;
    }

    private boolean isNrPhysicalChannelConfig(PhysicalChannelConfig physicalChannelConfig) {
        return physicalChannelConfig.getNetworkType() == 20;
    }

    private boolean isInternetPhysicalChannelConfig(PhysicalChannelConfig physicalChannelConfig) {
        for (int i : physicalChannelConfig.getContextIds()) {
            if (!this.mPhone.isUsingNewDataStack()) {
                DataConnection dataConnectionByContextId = this.mPhone.getDcTracker(1).getDataConnectionByContextId(i);
                if (dataConnectionByContextId != null && dataConnectionByContextId.getNetworkCapabilities().hasCapability(12)) {
                    return true;
                }
            } else if (this.mPhone.getDataNetworkController().isInternetNetwork(i)) {
                return true;
            }
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public void combinePsRegistrationStates(ServiceState serviceState) {
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, 2);
        NetworkRegistrationInfo networkRegistrationInfo2 = serviceState.getNetworkRegistrationInfo(2, 1);
        boolean isAnyApnOnIwlan = this.mAccessNetworksManager.isAnyApnOnIwlan();
        serviceState.setIwlanPreferred(isAnyApnOnIwlan);
        if (networkRegistrationInfo != null && networkRegistrationInfo.getAccessNetworkTechnology() == 18 && networkRegistrationInfo.getRegistrationState() == 1 && isAnyApnOnIwlan) {
            serviceState.setDataRegState(0);
        } else if (networkRegistrationInfo2 != null) {
            serviceState.setDataRegState(regCodeToServiceState(networkRegistrationInfo2.getRegistrationState()));
        }
        log("combinePsRegistrationStates: " + serviceState);
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v0, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v1, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v2, resolved type: int} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v3, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v4, resolved type: boolean} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v5, resolved type: boolean} */
    /* access modifiers changed from: protected */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handlePollStateResultMessage(int r10, android.os.AsyncResult r11) {
        /*
            r9 = this;
            r0 = 4
            r1 = 3
            r2 = 2
            r3 = 0
            r4 = 1
            if (r10 == r0) goto L_0x01fd
            r0 = 0
            r5 = 5
            if (r10 == r5) goto L_0x013a
            r6 = 6
            if (r10 == r6) goto L_0x011b
            r6 = 7
            if (r10 == r6) goto L_0x0053
            r1 = 14
            if (r10 == r1) goto L_0x002b
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r0 = "handlePollStateResultMessage: Unexpected RIL response received: "
            r11.append(r0)
            r11.append(r10)
            java.lang.String r10 = r11.toString()
            r9.loge(r10)
            goto L_0x02da
        L_0x002b:
            java.lang.Object r10 = r11.result
            int[] r10 = (int[]) r10
            android.telephony.ServiceState r11 = r9.mNewSS
            r1 = r10[r3]
            if (r1 != r4) goto L_0x0037
            r1 = r4
            goto L_0x0038
        L_0x0037:
            r1 = r3
        L_0x0038:
            r11.setIsManualSelection(r1)
            r10 = r10[r3]
            if (r10 != r4) goto L_0x02da
            com.android.internal.telephony.GsmCdmaPhone r10 = r9.mPhone
            boolean r10 = r10.shouldForceAutoNetworkSelect()
            if (r10 == 0) goto L_0x02da
            com.android.internal.telephony.GsmCdmaPhone r10 = r9.mPhone
            r10.setNetworkSelectionModeAutomatic(r0)
            java.lang.String r10 = " Forcing Automatic Network Selection, manual selection is not allowed"
            r9.log(r10)
            goto L_0x02da
        L_0x0053:
            com.android.internal.telephony.GsmCdmaPhone r10 = r9.mPhone
            boolean r10 = r10.isPhoneTypeGsm()
            if (r10 == 0) goto L_0x00a7
            java.lang.Object r10 = r11.result
            java.lang.String[] r10 = (java.lang.String[]) r10
            if (r10 == 0) goto L_0x02da
            int r11 = r10.length
            if (r11 < r1) goto L_0x02da
            android.telephony.ServiceState r11 = r9.mNewSS
            r0 = r10[r3]
            r11.setOperatorAlphaLongRaw(r0)
            android.telephony.ServiceState r11 = r9.mNewSS
            r0 = r10[r4]
            r11.setOperatorAlphaShortRaw(r0)
            java.lang.String r11 = r9.getOperatorBrandOverride()
            com.android.internal.telephony.cdnr.CarrierDisplayNameResolver r0 = r9.mCdnr
            r0.updateEfForBrandOverride(r11)
            if (r11 == 0) goto L_0x009a
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "EVENT_POLL_STATE_OPERATOR: use brandOverride="
            r0.append(r1)
            r0.append(r11)
            java.lang.String r0 = r0.toString()
            r9.log(r0)
            android.telephony.ServiceState r9 = r9.mNewSS
            r10 = r10[r2]
            r9.setOperatorName(r11, r11, r10)
            goto L_0x02da
        L_0x009a:
            android.telephony.ServiceState r9 = r9.mNewSS
            r11 = r10[r3]
            r0 = r10[r4]
            r10 = r10[r2]
            r9.setOperatorName(r11, r0, r10)
            goto L_0x02da
        L_0x00a7:
            java.lang.Object r10 = r11.result
            java.lang.String[] r10 = (java.lang.String[]) r10
            if (r10 == 0) goto L_0x0114
            int r11 = r10.length
            if (r11 < r1) goto L_0x0114
            r11 = r10[r2]
            java.lang.String r0 = "00000"
            if (r11 == 0) goto L_0x00c4
            int r11 = r11.length()
            if (r11 < r5) goto L_0x00c4
            r11 = r10[r2]
            boolean r11 = r0.equals(r11)
            if (r11 == 0) goto L_0x00e2
        L_0x00c4:
            java.lang.String r11 = "ro.cdma.home.operator.numeric"
            java.lang.String r11 = android.os.SystemProperties.get(r11, r0)
            r10[r2] = r11
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r0 = "RIL_REQUEST_OPERATOR.response[2], the numeric,  is bad. Using SystemProperties 'ro.cdma.home.operator.numeric'= "
            r11.append(r0)
            r0 = r10[r2]
            r11.append(r0)
            java.lang.String r11 = r11.toString()
            r9.log(r11)
        L_0x00e2:
            boolean r11 = r9.mIsSubscriptionFromRuim
            if (r11 != 0) goto L_0x00f3
            android.telephony.ServiceState r9 = r9.mNewSS
            r11 = r10[r3]
            r0 = r10[r4]
            r10 = r10[r2]
            r9.setOperatorName(r11, r0, r10)
            goto L_0x02da
        L_0x00f3:
            java.lang.String r11 = r9.getOperatorBrandOverride()
            com.android.internal.telephony.cdnr.CarrierDisplayNameResolver r0 = r9.mCdnr
            r0.updateEfForBrandOverride(r11)
            if (r11 == 0) goto L_0x0107
            android.telephony.ServiceState r9 = r9.mNewSS
            r10 = r10[r2]
            r9.setOperatorName(r11, r11, r10)
            goto L_0x02da
        L_0x0107:
            android.telephony.ServiceState r9 = r9.mNewSS
            r11 = r10[r3]
            r0 = r10[r4]
            r10 = r10[r2]
            r9.setOperatorName(r11, r0, r10)
            goto L_0x02da
        L_0x0114:
            java.lang.String r10 = "EVENT_POLL_STATE_OPERATOR_CDMA: error parsing opNames"
            r9.log(r10)
            goto L_0x02da
        L_0x011b:
            java.lang.Object r10 = r11.result
            android.telephony.NetworkRegistrationInfo r10 = (android.telephony.NetworkRegistrationInfo) r10
            android.telephony.ServiceState r11 = r9.mNewSS
            r11.addNetworkRegistrationInfo(r10)
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r0 = "handlePollStateResultMessage: PS IWLAN. "
            r11.append(r0)
            r11.append(r10)
            java.lang.String r10 = r11.toString()
            r9.log(r10)
            goto L_0x02da
        L_0x013a:
            java.lang.Object r10 = r11.result
            android.telephony.NetworkRegistrationInfo r10 = (android.telephony.NetworkRegistrationInfo) r10
            android.telephony.ServiceState r11 = r9.mNewSS
            r11.addNetworkRegistrationInfo(r10)
            android.telephony.DataSpecificRegistrationInfo r11 = r10.getDataSpecificInfo()
            int r1 = r10.getRegistrationState()
            int r2 = r9.regCodeToServiceState(r1)
            int r5 = r10.getAccessNetworkTechnology()
            int r5 = android.telephony.ServiceState.networkTypeToRilRadioTechnology(r5)
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "handlePollStateResultMessage: PS cellular. "
            r6.append(r7)
            r6.append(r10)
            java.lang.String r6 = r6.toString()
            r9.log(r6)
            if (r2 != r4) goto L_0x016f
            r9.mLastPhysicalChannelConfigList = r0
        L_0x016f:
            boolean r0 = r10.isEmergencyEnabled()
            r9.mPSEmergencyOnly = r0
            boolean r2 = r9.mCSEmergencyOnly
            if (r2 != 0) goto L_0x017b
            if (r0 == 0) goto L_0x017c
        L_0x017b:
            r3 = r4
        L_0x017c:
            r9.mEmergencyOnly = r3
            com.android.internal.telephony.GsmCdmaPhone r0 = r9.mPhone
            boolean r0 = r0.isPhoneTypeGsm()
            if (r0 == 0) goto L_0x019c
            int r0 = r10.getRejectCause()
            r9.mNewReasonDataDenied = r0
            int r11 = r11.maxDataCalls
            r9.mNewMaxDataCalls = r11
            boolean r11 = r9.regCodeIsRoaming(r1)
            r9.mGsmDataRoaming = r11
            android.telephony.ServiceState r0 = r9.mNewSS
            r0.setDataRoamingFromRegistration(r11)
            goto L_0x01ec
        L_0x019c:
            com.android.internal.telephony.GsmCdmaPhone r11 = r9.mPhone
            boolean r11 = r11.isPhoneTypeCdma()
            if (r11 == 0) goto L_0x01b3
            boolean r11 = r9.regCodeIsRoaming(r1)
            android.telephony.ServiceState r0 = r9.mNewSS
            r0.setDataRoaming(r11)
            android.telephony.ServiceState r0 = r9.mNewSS
            r0.setDataRoamingFromRegistration(r11)
            goto L_0x01ec
        L_0x01b3:
            android.telephony.ServiceState r11 = r9.mSS
            int r11 = getRilDataRadioTechnologyForWwan(r11)
            if (r11 != 0) goto L_0x01bd
            if (r5 != 0) goto L_0x01d5
        L_0x01bd:
            boolean r0 = android.telephony.ServiceState.isCdma(r11)
            if (r0 == 0) goto L_0x01c9
            boolean r0 = android.telephony.ServiceState.isPsOnlyTech(r5)
            if (r0 != 0) goto L_0x01d5
        L_0x01c9:
            boolean r11 = android.telephony.ServiceState.isPsOnlyTech(r11)
            if (r11 == 0) goto L_0x01de
            boolean r11 = android.telephony.ServiceState.isCdma(r5)
            if (r11 == 0) goto L_0x01de
        L_0x01d5:
            com.android.internal.telephony.GsmCdmaPhone r11 = r9.mPhone
            com.android.internal.telephony.SignalStrengthController r11 = r11.getSignalStrengthController()
            r11.getSignalStrengthFromCi()
        L_0x01de:
            boolean r11 = r9.regCodeIsRoaming(r1)
            android.telephony.ServiceState r0 = r9.mNewSS
            r0.setDataRoaming(r11)
            android.telephony.ServiceState r0 = r9.mNewSS
            r0.setDataRoamingFromRegistration(r11)
        L_0x01ec:
            com.android.internal.telephony.GsmCdmaPhone r11 = r9.mPhone
            com.android.internal.telephony.SignalStrengthController r11 = r11.getSignalStrengthController()
            android.telephony.ServiceState r9 = r9.mNewSS
            android.telephony.CellIdentity r10 = r10.getCellIdentity()
            r11.updateServiceStateArfcnRsrpBoost(r9, r10)
            goto L_0x02da
        L_0x01fd:
            java.lang.Object r10 = r11.result
            android.telephony.NetworkRegistrationInfo r10 = (android.telephony.NetworkRegistrationInfo) r10
            android.telephony.VoiceSpecificRegistrationInfo r11 = r10.getVoiceSpecificInfo()
            int r0 = r10.getRegistrationState()
            boolean r5 = r11.cssSupported
            int r6 = r10.getAccessNetworkTechnology()
            android.telephony.ServiceState.networkTypeToRilRadioTechnology(r6)
            android.telephony.ServiceState r6 = r9.mNewSS
            int r7 = r9.regCodeToServiceState(r0)
            r6.setVoiceRegState(r7)
            android.telephony.ServiceState r6 = r9.mNewSS
            r6.setCssIndicator(r5)
            android.telephony.ServiceState r5 = r9.mNewSS
            r5.addNetworkRegistrationInfo(r10)
            android.telephony.ServiceState r5 = r9.mNewSS
            android.telephony.CellIdentity r6 = r10.getCellIdentity()
            r9.setPhyCellInfoFromCellIdentity(r5, r6)
            int r5 = r10.getRejectCause()
            boolean r6 = r10.isEmergencyEnabled()
            r9.mCSEmergencyOnly = r6
            if (r6 != 0) goto L_0x0241
            boolean r6 = r9.mPSEmergencyOnly
            if (r6 == 0) goto L_0x023f
            goto L_0x0241
        L_0x023f:
            r6 = r3
            goto L_0x0242
        L_0x0241:
            r6 = r4
        L_0x0242:
            r9.mEmergencyOnly = r6
            com.android.internal.telephony.GsmCdmaPhone r6 = r9.mPhone
            boolean r6 = r6.isPhoneTypeGsm()
            if (r6 == 0) goto L_0x0256
            boolean r11 = r9.regCodeIsRoaming(r0)
            r9.mGsmVoiceRoaming = r11
            r9.mNewRejectCode = r5
            goto L_0x02c6
        L_0x0256:
            int r6 = r11.roamingIndicator
            int r7 = r11.systemIsInPrl
            int r11 = r11.defaultRoamingIndicator
            r9.mRegistrationState = r0
            boolean r0 = r9.regCodeIsRoaming(r0)
            if (r0 == 0) goto L_0x026c
            boolean r0 = r9.isRoamIndForHomeSystem(r6)
            if (r0 != 0) goto L_0x026c
            r0 = r4
            goto L_0x026d
        L_0x026c:
            r0 = r3
        L_0x026d:
            android.telephony.ServiceState r8 = r9.mNewSS
            r8.setVoiceRoaming(r0)
            r9.mRoamingIndicator = r6
            if (r7 != 0) goto L_0x0278
            r0 = r3
            goto L_0x0279
        L_0x0278:
            r0 = r4
        L_0x0279:
            r9.mIsInPrl = r0
            r9.mDefaultRoamingIndicator = r11
            android.telephony.CellIdentity r11 = r10.getCellIdentity()
            if (r11 == 0) goto L_0x0294
            int r0 = r11.getType()
            if (r0 != r2) goto L_0x0294
            android.telephony.CellIdentityCdma r11 = (android.telephony.CellIdentityCdma) r11
            int r3 = r11.getSystemId()
            int r11 = r11.getNetworkId()
            goto L_0x0295
        L_0x0294:
            r11 = r3
        L_0x0295:
            android.telephony.ServiceState r0 = r9.mNewSS
            r0.setCdmaSystemAndNetworkId(r3, r11)
            if (r5 != 0) goto L_0x02a1
            java.lang.String r11 = "General"
            r9.mRegistrationDeniedReason = r11
            goto L_0x02ac
        L_0x02a1:
            if (r5 != r4) goto L_0x02a8
            java.lang.String r11 = "Authentication Failure"
            r9.mRegistrationDeniedReason = r11
            goto L_0x02ac
        L_0x02a8:
            java.lang.String r11 = ""
            r9.mRegistrationDeniedReason = r11
        L_0x02ac:
            int r11 = r9.mRegistrationState
            if (r11 != r1) goto L_0x02c6
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r0 = "Registration denied, "
            r11.append(r0)
            java.lang.String r0 = r9.mRegistrationDeniedReason
            r11.append(r0)
            java.lang.String r11 = r11.toString()
            r9.log(r11)
        L_0x02c6:
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r0 = "handlePollStateResultMessage: CS cellular. "
            r11.append(r0)
            r11.append(r10)
            java.lang.String r10 = r11.toString()
            r9.log(r10)
        L_0x02da:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.handlePollStateResultMessage(int, android.os.AsyncResult):void");
    }

    /* JADX WARNING: Removed duplicated region for block: B:21:0x0048  */
    /* JADX WARNING: Removed duplicated region for block: B:22:0x004e  */
    /* JADX WARNING: Removed duplicated region for block: B:25:0x0056  */
    /* JADX WARNING: Removed duplicated region for block: B:27:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    protected static long getCidFromCellIdentity(android.telephony.CellIdentity r6) {
        /*
            r0 = -1
            if (r6 != 0) goto L_0x0005
            return r0
        L_0x0005:
            int r2 = r6.getType()
            r3 = 1
            r4 = 6
            if (r2 == r3) goto L_0x003a
            r3 = 3
            if (r2 == r3) goto L_0x0032
            r3 = 4
            if (r2 == r3) goto L_0x002a
            r3 = 5
            if (r2 == r3) goto L_0x0022
            if (r2 == r4) goto L_0x001a
            r2 = r0
            goto L_0x0042
        L_0x001a:
            r2 = r6
            android.telephony.CellIdentityNr r2 = (android.telephony.CellIdentityNr) r2
            long r2 = r2.getNci()
            goto L_0x0042
        L_0x0022:
            r2 = r6
            android.telephony.CellIdentityTdscdma r2 = (android.telephony.CellIdentityTdscdma) r2
            int r2 = r2.getCid()
            goto L_0x0041
        L_0x002a:
            r2 = r6
            android.telephony.CellIdentityWcdma r2 = (android.telephony.CellIdentityWcdma) r2
            int r2 = r2.getCid()
            goto L_0x0041
        L_0x0032:
            r2 = r6
            android.telephony.CellIdentityLte r2 = (android.telephony.CellIdentityLte) r2
            int r2 = r2.getCi()
            goto L_0x0041
        L_0x003a:
            r2 = r6
            android.telephony.CellIdentityGsm r2 = (android.telephony.CellIdentityGsm) r2
            int r2 = r2.getCid()
        L_0x0041:
            long r2 = (long) r2
        L_0x0042:
            int r6 = r6.getType()
            if (r6 != r4) goto L_0x004e
            r4 = 9223372036854775807(0x7fffffffffffffff, double:NaN)
            goto L_0x0051
        L_0x004e:
            r4 = 2147483647(0x7fffffff, double:1.060997895E-314)
        L_0x0051:
            int r6 = (r2 > r4 ? 1 : (r2 == r4 ? 0 : -1))
            if (r6 != 0) goto L_0x0056
            goto L_0x0057
        L_0x0056:
            r0 = r2
        L_0x0057:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.getCidFromCellIdentity(android.telephony.CellIdentity):long");
    }

    protected static int getAreaCodeFromCellIdentity(CellIdentity cellIdentity) {
        if (cellIdentity == null) {
            return Integer.MAX_VALUE;
        }
        int type = cellIdentity.getType();
        if (type == 1) {
            return ((CellIdentityGsm) cellIdentity).getLac();
        }
        if (type == 3) {
            return ((CellIdentityLte) cellIdentity).getTac();
        }
        if (type == 4) {
            return ((CellIdentityWcdma) cellIdentity).getLac();
        }
        if (type == 5) {
            return ((CellIdentityTdscdma) cellIdentity).getLac();
        }
        if (type != 6) {
            return Integer.MAX_VALUE;
        }
        return ((CellIdentityNr) cellIdentity).getTac();
    }

    /* access modifiers changed from: protected */
    public void setPhyCellInfoFromCellIdentity(ServiceState serviceState, CellIdentity cellIdentity) {
        if (cellIdentity == null) {
            log("Could not set ServiceState channel number. CellIdentity null");
            return;
        }
        serviceState.setChannelNumber(cellIdentity.getChannelNumber());
        PhysicalChannelConfig primaryPhysicalChannelConfigForCell = getPrimaryPhysicalChannelConfigForCell(this.mLastPhysicalChannelConfigList, cellIdentity);
        int[] iArr = null;
        if (cellIdentity instanceof CellIdentityLte) {
            CellIdentityLte cellIdentityLte = (CellIdentityLte) cellIdentity;
            if (primaryPhysicalChannelConfigForCell != null) {
                int[] bandwidthsFromConfigs = getBandwidthsFromConfigs(this.mLastPhysicalChannelConfigList);
                int length = bandwidthsFromConfigs.length;
                int i = 0;
                while (true) {
                    if (i >= length) {
                        iArr = bandwidthsFromConfigs;
                        break;
                    }
                    int i2 = bandwidthsFromConfigs[i];
                    if (!isValidLteBandwidthKhz(i2)) {
                        loge("Invalid LTE Bandwidth in RegistrationState, " + i2);
                        break;
                    }
                    i++;
                }
            }
            if (iArr == null || iArr.length == 1) {
                int bandwidth = cellIdentityLte.getBandwidth();
                if (isValidLteBandwidthKhz(bandwidth)) {
                    iArr = new int[]{bandwidth};
                } else if (bandwidth != Integer.MAX_VALUE) {
                    loge("Invalid LTE Bandwidth in RegistrationState, " + bandwidth);
                }
            }
        } else if ((cellIdentity instanceof CellIdentityNr) && primaryPhysicalChannelConfigForCell != null) {
            int[] bandwidthsFromConfigs2 = getBandwidthsFromConfigs(this.mLastPhysicalChannelConfigList);
            int length2 = bandwidthsFromConfigs2.length;
            int i3 = 0;
            while (true) {
                if (i3 >= length2) {
                    iArr = bandwidthsFromConfigs2;
                    break;
                }
                int i4 = bandwidthsFromConfigs2[i3];
                if (!isValidNrBandwidthKhz(i4)) {
                    loge("Invalid NR Bandwidth in RegistrationState, " + i4);
                    break;
                }
                i3++;
            }
        }
        if (!(iArr != null || primaryPhysicalChannelConfigForCell == null || primaryPhysicalChannelConfigForCell.getCellBandwidthDownlinkKhz() == 0)) {
            iArr = new int[]{primaryPhysicalChannelConfigForCell.getCellBandwidthDownlinkKhz()};
        }
        if (iArr != null) {
            serviceState.setCellBandwidths(iArr);
        }
    }

    private static PhysicalChannelConfig getPrimaryPhysicalChannelConfigForCell(List<PhysicalChannelConfig> list, CellIdentity cellIdentity) {
        boolean z;
        int i;
        int i2;
        if (!ArrayUtils.isEmpty(list) && (((z = cellIdentity instanceof CellIdentityLte)) || (cellIdentity instanceof CellIdentityNr))) {
            if (z) {
                i2 = 13;
                i = ((CellIdentityLte) cellIdentity).getPci();
            } else {
                i2 = 20;
                i = ((CellIdentityNr) cellIdentity).getPci();
            }
            for (PhysicalChannelConfig next : list) {
                if (next.getConnectionStatus() == 1 && next.getNetworkType() == i2 && next.getPhysicalCellId() == i) {
                    return next;
                }
            }
        }
        return null;
    }

    /* access modifiers changed from: protected */
    public boolean isRoamIndForHomeSystem(int i) {
        int[] intArray = getCarrierConfig().getIntArray("cdma_enhanced_roaming_indicator_for_home_network_int_array");
        log("isRoamIndForHomeSystem: homeRoamIndicators=" + Arrays.toString(intArray));
        if (intArray != null) {
            for (int i2 : intArray) {
                if (i2 == i) {
                    return true;
                }
            }
            log("isRoamIndForHomeSystem: No match found against list for roamInd=" + i);
            return false;
        }
        log("isRoamIndForHomeSystem: No list found");
        return false;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateRoamingState() {
        PersistableBundle carrierConfig = getCarrierConfig();
        boolean z = true;
        if (this.mPhone.isPhoneTypeGsm()) {
            boolean z2 = this.mGsmVoiceRoaming || this.mGsmDataRoaming;
            if (z2 && !isOperatorConsideredRoaming(this.mNewSS) && (isSameNamedOperators(this.mNewSS) || isOperatorConsideredNonRoaming(this.mNewSS))) {
                log("updateRoamingState: resource override set non roaming.isSameNamedOperators=" + isSameNamedOperators(this.mNewSS) + ",isOperatorConsideredNonRoaming=" + isOperatorConsideredNonRoaming(this.mNewSS));
                z2 = false;
            }
            if (alwaysOnHomeNetwork(carrierConfig)) {
                log("updateRoamingState: carrier config override always on home network");
            } else if (isNonRoamingInGsmNetwork(carrierConfig, this.mNewSS.getOperatorNumeric())) {
                log("updateRoamingState: carrier config override set non roaming:" + this.mNewSS.getOperatorNumeric());
            } else {
                if (isRoamingInGsmNetwork(carrierConfig, this.mNewSS.getOperatorNumeric())) {
                    log("updateRoamingState: carrier config override set roaming:" + this.mNewSS.getOperatorNumeric());
                } else {
                    z = z2;
                }
                this.mNewSS.setRoaming(z);
                return;
            }
            z = false;
            this.mNewSS.setRoaming(z);
            return;
        }
        String num = Integer.toString(this.mNewSS.getCdmaSystemId());
        if (alwaysOnHomeNetwork(carrierConfig)) {
            log("updateRoamingState: carrier config override always on home network");
            setRoamingOff();
        } else if (isNonRoamingInGsmNetwork(carrierConfig, this.mNewSS.getOperatorNumeric()) || isNonRoamingInCdmaNetwork(carrierConfig, num)) {
            log("updateRoamingState: carrier config override set non-roaming:" + this.mNewSS.getOperatorNumeric() + ", " + num);
            setRoamingOff();
        } else if (isRoamingInGsmNetwork(carrierConfig, this.mNewSS.getOperatorNumeric()) || isRoamingInCdmaNetwork(carrierConfig, num)) {
            log("updateRoamingState: carrier config override set roaming:" + this.mNewSS.getOperatorNumeric() + ", " + num);
            setRoamingOn();
        }
        if (TelephonyUtils.IS_DEBUGGABLE && SystemProperties.getBoolean(PROP_FORCE_ROAMING, false)) {
            this.mNewSS.setRoaming(true);
        }
    }

    /* access modifiers changed from: protected */
    public void setRoamingOn() {
        this.mNewSS.setRoaming(true);
        this.mNewSS.setCdmaEriIconIndex(0);
        this.mNewSS.setCdmaEriIconMode(0);
    }

    /* access modifiers changed from: protected */
    public void setRoamingOff() {
        this.mNewSS.setRoaming(false);
        this.mNewSS.setCdmaEriIconIndex(1);
    }

    /* access modifiers changed from: protected */
    public void updateOperatorNameFromCarrierConfig() {
        if (!this.mPhone.isPhoneTypeGsm() && !this.mSS.getRoaming()) {
            if (!((this.mUiccController.getUiccPort(getPhoneId()) == null || this.mUiccController.getUiccPort(getPhoneId()).getOperatorBrandOverride() == null) ? false : true)) {
                PersistableBundle carrierConfig = getCarrierConfig();
                if (carrierConfig.getBoolean("cdma_home_registered_plmn_name_override_bool")) {
                    String string = carrierConfig.getString("cdma_home_registered_plmn_name_string");
                    log("updateOperatorNameFromCarrierConfig: changing from " + this.mSS.getOperatorAlpha() + " to " + string);
                    ServiceState serviceState = this.mSS;
                    serviceState.setOperatorName(string, string, serviceState.getOperatorNumeric());
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void notifySpnDisplayUpdate(CarrierDisplayNameData carrierDisplayNameData) {
        int subId = this.mPhone.getSubId();
        if (this.mSubId != subId || carrierDisplayNameData.shouldShowPlmn() != this.mCurShowPlmn || carrierDisplayNameData.shouldShowSpn() != this.mCurShowSpn || !TextUtils.equals(carrierDisplayNameData.getSpn(), this.mCurSpn) || !TextUtils.equals(carrierDisplayNameData.getDataSpn(), this.mCurDataSpn) || !TextUtils.equals(carrierDisplayNameData.getPlmn(), this.mCurPlmn)) {
            String format = String.format("updateSpnDisplay: changed sending intent, rule=%d, showPlmn='%b', plmn='%s', showSpn='%b', spn='%s', dataSpn='%s', subId='%d'", new Object[]{Integer.valueOf(getCarrierNameDisplayBitmask(this.mSS)), Boolean.valueOf(carrierDisplayNameData.shouldShowPlmn()), carrierDisplayNameData.getPlmn(), Boolean.valueOf(carrierDisplayNameData.shouldShowSpn()), carrierDisplayNameData.getSpn(), carrierDisplayNameData.getDataSpn(), Integer.valueOf(subId)});
            this.mCdnrLogs.log(format);
            log("updateSpnDisplay: " + format);
            Intent intent = new Intent("android.telephony.action.SERVICE_PROVIDERS_UPDATED");
            intent.putExtra("android.telephony.extra.SHOW_SPN", carrierDisplayNameData.shouldShowSpn());
            intent.putExtra("android.telephony.extra.SPN", carrierDisplayNameData.getSpn());
            intent.putExtra("android.telephony.extra.DATA_SPN", carrierDisplayNameData.getDataSpn());
            intent.putExtra("android.telephony.extra.SHOW_PLMN", carrierDisplayNameData.shouldShowPlmn());
            intent.putExtra("android.telephony.extra.PLMN", carrierDisplayNameData.getPlmn());
            SubscriptionManager.putPhoneIdAndSubIdExtra(intent, this.mPhone.getPhoneId());
            this.mPhone.getContext().sendStickyBroadcastAsUser(intent, UserHandle.ALL);
            if (!this.mSubscriptionController.setPlmnSpn(this.mPhone.getPhoneId(), carrierDisplayNameData.shouldShowPlmn(), carrierDisplayNameData.getPlmn(), carrierDisplayNameData.shouldShowSpn(), carrierDisplayNameData.getSpn())) {
                this.mSpnUpdatePending = true;
            }
        }
        this.mSubId = subId;
        this.mCurShowSpn = carrierDisplayNameData.shouldShowSpn();
        this.mCurShowPlmn = carrierDisplayNameData.shouldShowPlmn();
        this.mCurSpn = carrierDisplayNameData.getSpn();
        this.mCurDataSpn = carrierDisplayNameData.getDataSpn();
        this.mCurPlmn = carrierDisplayNameData.getPlmn();
    }

    private void updateSpnDisplayCdnr() {
        log("updateSpnDisplayCdnr+");
        notifySpnDisplayUpdate(this.mCdnr.getCarrierDisplayNameData());
        log("updateSpnDisplayCdnr-");
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
    public void updateSpnDisplay() {
        if (getCarrierConfig().getBoolean("enable_carrier_display_name_resolver_bool")) {
            updateSpnDisplayCdnr();
        } else {
            updateSpnDisplayLegacy();
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:108:0x029f, code lost:
        if (android.text.TextUtils.equals(r10, r0) == false) goto L_0x02a3;
     */
    /* JADX WARNING: Removed duplicated region for block: B:68:0x01cf  */
    /* JADX WARNING: Removed duplicated region for block: B:69:0x01d1  */
    /* JADX WARNING: Removed duplicated region for block: B:72:0x01f0  */
    /* JADX WARNING: Removed duplicated region for block: B:84:0x0230  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void updateSpnDisplayLegacy() {
        /*
            r13 = this;
            java.lang.String r0 = "updateSpnDisplayLegacy+"
            r13.log(r0)
            android.telephony.ServiceState r0 = r13.mSS
            int r0 = r13.getCombinedRegState(r0)
            com.android.internal.telephony.GsmCdmaPhone r1 = r13.mPhone
            com.android.internal.telephony.Phone r1 = r1.getImsPhone()
            java.lang.String r2 = "wfc_spn_use_root_locale"
            r3 = 0
            r4 = 0
            if (r1 == 0) goto L_0x00a8
            com.android.internal.telephony.GsmCdmaPhone r1 = r13.mPhone
            com.android.internal.telephony.Phone r1 = r1.getImsPhone()
            boolean r1 = r1.isWifiCallingEnabled()
            if (r1 == 0) goto L_0x00a8
            if (r0 != 0) goto L_0x00a8
            android.telephony.ServiceState r1 = r13.mSS
            int r1 = r1.getDataNetworkType()
            r5 = 18
            if (r1 != r5) goto L_0x00a8
            android.os.PersistableBundle r1 = r13.getCarrierConfig()
            java.lang.String r5 = "wfc_spn_format_idx_int"
            int r5 = r1.getInt(r5)
            java.lang.String r6 = "wfc_data_spn_format_idx_int"
            int r6 = r1.getInt(r6)
            java.lang.String r7 = "wfc_flight_mode_spn_format_idx_int"
            int r7 = r1.getInt(r7)
            boolean r1 = r1.getBoolean(r2)
            com.android.internal.telephony.GsmCdmaPhone r8 = r13.mPhone
            android.content.Context r8 = r8.getContext()
            com.android.internal.telephony.GsmCdmaPhone r9 = r13.mPhone
            int r9 = r9.getSubId()
            android.content.res.Resources r1 = android.telephony.SubscriptionManager.getResourcesForSubId(r8, r9, r1)
            r8 = 17236216(0x10700f8, float:2.479628E-38)
            java.lang.String[] r1 = r1.getStringArray(r8)
            if (r5 < 0) goto L_0x006a
            int r8 = r1.length
            if (r5 < r8) goto L_0x0080
        L_0x006a:
            java.lang.StringBuilder r8 = new java.lang.StringBuilder
            r8.<init>()
            java.lang.String r9 = "updateSpnDisplay: KEY_WFC_SPN_FORMAT_IDX_INT out of bounds: "
            r8.append(r9)
            r8.append(r5)
            java.lang.String r5 = r8.toString()
            r13.loge(r5)
            r5 = r4
        L_0x0080:
            if (r6 < 0) goto L_0x0085
            int r8 = r1.length
            if (r6 < r8) goto L_0x009b
        L_0x0085:
            java.lang.StringBuilder r8 = new java.lang.StringBuilder
            r8.<init>()
            java.lang.String r9 = "updateSpnDisplay: KEY_WFC_DATA_SPN_FORMAT_IDX_INT out of bounds: "
            r8.append(r9)
            r8.append(r6)
            java.lang.String r6 = r8.toString()
            r13.loge(r6)
            r6 = r4
        L_0x009b:
            if (r7 < 0) goto L_0x00a0
            int r8 = r1.length
            if (r7 < r8) goto L_0x00a1
        L_0x00a0:
            r7 = r5
        L_0x00a1:
            r5 = r1[r5]
            r6 = r1[r6]
            r1 = r1[r7]
            goto L_0x00ab
        L_0x00a8:
            r1 = r3
            r5 = r1
            r6 = r5
        L_0x00ab:
            com.android.internal.telephony.GsmCdmaPhone r7 = r13.mPhone
            com.android.internal.telephony.Phone r7 = r7.getImsPhone()
            r8 = 2
            if (r7 == 0) goto L_0x010b
            com.android.internal.telephony.GsmCdmaPhone r7 = r13.mPhone
            com.android.internal.telephony.Phone r7 = r7.getImsPhone()
            if (r7 == 0) goto L_0x010b
            com.android.internal.telephony.GsmCdmaPhone r7 = r13.mPhone
            com.android.internal.telephony.Phone r7 = r7.getImsPhone()
            int r7 = r7.getImsRegistrationTech()
            if (r7 != r8) goto L_0x010b
            android.os.PersistableBundle r7 = r13.getCarrierConfig()
            java.lang.String r9 = "cross_sim_spn_format_int"
            int r9 = r7.getInt(r9)
            boolean r2 = r7.getBoolean(r2)
            com.android.internal.telephony.GsmCdmaPhone r7 = r13.mPhone
            android.content.Context r7 = r7.getContext()
            com.android.internal.telephony.GsmCdmaPhone r10 = r13.mPhone
            int r10 = r10.getSubId()
            android.content.res.Resources r2 = android.telephony.SubscriptionManager.getResourcesForSubId(r7, r10, r2)
            r7 = 17236166(0x10700c6, float:2.479614E-38)
            java.lang.String[] r2 = r2.getStringArray(r7)
            if (r9 < 0) goto L_0x00f2
            int r7 = r2.length
            if (r9 < r7) goto L_0x0108
        L_0x00f2:
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r10 = "updateSpnDisplay: KEY_CROSS_SIM_SPN_FORMAT_INT out of bounds: "
            r7.append(r10)
            r7.append(r9)
            java.lang.String r7 = r7.toString()
            r13.loge(r7)
            r9 = r4
        L_0x0108:
            r2 = r2[r9]
            goto L_0x010c
        L_0x010b:
            r2 = r3
        L_0x010c:
            com.android.internal.telephony.GsmCdmaPhone r7 = r13.mPhone
            boolean r7 = r7.isPhoneTypeGsm()
            java.lang.String r9 = "'"
            r10 = 17040617(0x10404e9, float:2.4248094E-38)
            r11 = 1
            if (r7 == 0) goto L_0x02a7
            android.telephony.ServiceState r7 = r13.mSS
            int r7 = r13.getCarrierNameDisplayBitmask(r7)
            if (r0 == r11) goto L_0x0174
            if (r0 != r8) goto L_0x0125
            goto L_0x0174
        L_0x0125:
            if (r0 != 0) goto L_0x0153
            android.telephony.ServiceState r0 = r13.mSS
            java.lang.String r0 = r0.getOperatorAlpha()
            boolean r9 = android.text.TextUtils.isEmpty(r0)
            if (r9 != 0) goto L_0x0139
            r9 = r7 & 2
            if (r9 != r8) goto L_0x0139
            r8 = r11
            goto L_0x013a
        L_0x0139:
            r8 = r4
        L_0x013a:
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r10 = "updateSpnDisplay: rawPlmn = "
            r9.append(r10)
            r9.append(r0)
            java.lang.String r9 = r9.toString()
            r13.log(r9)
            r9 = r8
            r8 = r4
            goto L_0x01c0
        L_0x0153:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r8 = "updateSpnDisplay: radio is off w/ showPlmn="
            r0.append(r8)
            r0.append(r11)
            java.lang.String r8 = " plmn="
            r0.append(r8)
            r0.append(r3)
            java.lang.String r0 = r0.toString()
            r13.log(r0)
            r0 = r3
            r8 = r4
        L_0x0172:
            r9 = r11
            goto L_0x01c0
        L_0x0174:
            boolean r0 = r13.shouldForceDisplayNoService()
            if (r0 == 0) goto L_0x0180
            boolean r0 = r13.mIsSimReady
            if (r0 != 0) goto L_0x0180
            r0 = r11
            goto L_0x0181
        L_0x0180:
            r0 = r4
        L_0x0181:
            if (r0 != 0) goto L_0x019a
            boolean r0 = com.android.internal.telephony.Phone.isEmergencyCallOnly()
            if (r0 == 0) goto L_0x019a
            android.content.res.Resources r0 = android.content.res.Resources.getSystem()
            r8 = 17040208(0x1040350, float:2.4246948E-38)
            java.lang.CharSequence r0 = r0.getText(r8)
            java.lang.String r0 = r0.toString()
            r8 = r4
            goto L_0x01a7
        L_0x019a:
            android.content.res.Resources r0 = android.content.res.Resources.getSystem()
            java.lang.CharSequence r0 = r0.getText(r10)
            java.lang.String r0 = r0.toString()
            r8 = r11
        L_0x01a7:
            java.lang.StringBuilder r10 = new java.lang.StringBuilder
            r10.<init>()
            java.lang.String r12 = "updateSpnDisplay: radio is on but out of service, set plmn='"
            r10.append(r12)
            r10.append(r0)
            r10.append(r9)
            java.lang.String r9 = r10.toString()
            r13.log(r9)
            goto L_0x0172
        L_0x01c0:
            java.lang.String r10 = r13.getServiceProviderName()
            if (r8 != 0) goto L_0x01d1
            boolean r8 = android.text.TextUtils.isEmpty(r10)
            if (r8 != 0) goto L_0x01d1
            r7 = r7 & r11
            if (r7 != r11) goto L_0x01d1
            r7 = r11
            goto L_0x01d2
        L_0x01d1:
            r7 = r4
        L_0x01d2:
            java.lang.StringBuilder r8 = new java.lang.StringBuilder
            r8.<init>()
            java.lang.String r12 = "updateSpnDisplay: rawSpn = "
            r8.append(r12)
            r8.append(r10)
            java.lang.String r8 = r8.toString()
            r13.log(r8)
            boolean r8 = android.text.TextUtils.isEmpty(r2)
            java.lang.String r12 = "wfc_carrier_name_override_by_pnn_bool"
            if (r8 != 0) goto L_0x0230
            boolean r1 = android.text.TextUtils.isEmpty(r10)
            if (r1 != 0) goto L_0x0208
            java.lang.String r1 = r10.trim()
            java.lang.Object[] r3 = new java.lang.Object[r11]
            r3[r4] = r1
            java.lang.String r1 = java.lang.String.format(r2, r3)
            r3 = r1
            r10 = r3
        L_0x0204:
            r9 = r4
            r4 = r11
            goto L_0x033b
        L_0x0208:
            boolean r1 = android.text.TextUtils.isEmpty(r0)
            if (r1 != 0) goto L_0x02a3
            java.lang.String r0 = r0.trim()
            android.os.PersistableBundle r1 = r13.getCarrierConfig()
            com.android.internal.telephony.uicc.IccRecords r3 = r13.mIccRecords
            if (r3 == 0) goto L_0x0226
            boolean r1 = r1.getBoolean(r12)
            if (r1 == 0) goto L_0x0226
            com.android.internal.telephony.uicc.IccRecords r0 = r13.mIccRecords
            java.lang.String r0 = r0.getPnnHomeName()
        L_0x0226:
            java.lang.Object[] r1 = new java.lang.Object[r11]
            r1[r4] = r0
            java.lang.String r0 = java.lang.String.format(r2, r1)
            goto L_0x02a3
        L_0x0230:
            boolean r2 = android.text.TextUtils.isEmpty(r10)
            r8 = 3
            if (r2 != 0) goto L_0x0264
            boolean r2 = android.text.TextUtils.isEmpty(r5)
            if (r2 != 0) goto L_0x0264
            boolean r2 = android.text.TextUtils.isEmpty(r6)
            if (r2 != 0) goto L_0x0264
            android.telephony.ServiceState r2 = r13.mSS
            int r2 = r2.getState()
            if (r2 != r8) goto L_0x024c
            goto L_0x024d
        L_0x024c:
            r1 = r5
        L_0x024d:
            java.lang.String r2 = r10.trim()
            java.lang.Object[] r3 = new java.lang.Object[r11]
            r3[r4] = r2
            java.lang.String r1 = java.lang.String.format(r1, r3)
            java.lang.Object[] r3 = new java.lang.Object[r11]
            r3[r4] = r2
            java.lang.String r2 = java.lang.String.format(r6, r3)
            r3 = r1
            r10 = r2
            goto L_0x0204
        L_0x0264:
            boolean r1 = android.text.TextUtils.isEmpty(r0)
            if (r1 != 0) goto L_0x0291
            boolean r1 = android.text.TextUtils.isEmpty(r5)
            if (r1 != 0) goto L_0x0291
            java.lang.String r0 = r0.trim()
            android.os.PersistableBundle r1 = r13.getCarrierConfig()
            com.android.internal.telephony.uicc.IccRecords r2 = r13.mIccRecords
            if (r2 == 0) goto L_0x0288
            boolean r1 = r1.getBoolean(r12)
            if (r1 == 0) goto L_0x0288
            com.android.internal.telephony.uicc.IccRecords r0 = r13.mIccRecords
            java.lang.String r0 = r0.getPnnHomeName()
        L_0x0288:
            java.lang.Object[] r1 = new java.lang.Object[r11]
            r1[r4] = r0
            java.lang.String r0 = java.lang.String.format(r5, r1)
            goto L_0x02a3
        L_0x0291:
            android.telephony.ServiceState r1 = r13.mSS
            int r1 = r1.getState()
            if (r1 == r8) goto L_0x033b
            if (r9 == 0) goto L_0x02a3
            boolean r1 = android.text.TextUtils.equals(r10, r0)
            if (r1 == 0) goto L_0x02a3
            goto L_0x033b
        L_0x02a3:
            r4 = r7
            r3 = r10
            goto L_0x033b
        L_0x02a7:
            java.lang.String r1 = r13.getOperatorNameFromEri()
            if (r1 == 0) goto L_0x02b2
            android.telephony.ServiceState r2 = r13.mSS
            r2.setOperatorAlphaLong(r1)
        L_0x02b2:
            r13.updateOperatorNameFromCarrierConfig()
            android.telephony.ServiceState r1 = r13.mSS
            java.lang.String r1 = r1.getOperatorAlpha()
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r6 = "updateSpnDisplay: cdma rawPlmn = "
            r2.append(r6)
            r2.append(r1)
            java.lang.String r2 = r2.toString()
            r13.log(r2)
            if (r1 == 0) goto L_0x02d4
            r2 = r11
            goto L_0x02d5
        L_0x02d4:
            r2 = r4
        L_0x02d5:
            boolean r6 = android.text.TextUtils.isEmpty(r1)
            if (r6 != 0) goto L_0x02ee
            boolean r6 = android.text.TextUtils.isEmpty(r5)
            if (r6 != 0) goto L_0x02ee
            java.lang.String r1 = r1.trim()
            java.lang.Object[] r6 = new java.lang.Object[r11]
            r6[r4] = r1
            java.lang.String r1 = java.lang.String.format(r5, r6)
            goto L_0x0311
        L_0x02ee:
            com.android.internal.telephony.CommandsInterface r5 = r13.mCi
            int r5 = r5.getRadioState()
            if (r5 != 0) goto L_0x0311
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r6 = "updateSpnDisplay: overwriting plmn from "
            r5.append(r6)
            r5.append(r1)
            java.lang.String r1 = " to null as radio state is off"
            r5.append(r1)
            java.lang.String r1 = r5.toString()
            r13.log(r1)
            r1 = r3
        L_0x0311:
            if (r0 != r11) goto L_0x0338
            android.content.res.Resources r0 = android.content.res.Resources.getSystem()
            java.lang.CharSequence r0 = r0.getText(r10)
            java.lang.String r0 = r0.toString()
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r5 = "updateSpnDisplay: radio is on but out of svc, set plmn='"
            r1.append(r5)
            r1.append(r0)
            r1.append(r9)
            java.lang.String r1 = r1.toString()
            r13.log(r1)
            goto L_0x0339
        L_0x0338:
            r0 = r1
        L_0x0339:
            r9 = r2
            r10 = r3
        L_0x033b:
            com.android.internal.telephony.cdnr.CarrierDisplayNameData$Builder r1 = new com.android.internal.telephony.cdnr.CarrierDisplayNameData$Builder
            r1.<init>()
            com.android.internal.telephony.cdnr.CarrierDisplayNameData$Builder r1 = r1.setSpn(r3)
            com.android.internal.telephony.cdnr.CarrierDisplayNameData$Builder r1 = r1.setDataSpn(r10)
            com.android.internal.telephony.cdnr.CarrierDisplayNameData$Builder r1 = r1.setShowSpn(r4)
            com.android.internal.telephony.cdnr.CarrierDisplayNameData$Builder r0 = r1.setPlmn(r0)
            com.android.internal.telephony.cdnr.CarrierDisplayNameData$Builder r0 = r0.setShowPlmn(r9)
            com.android.internal.telephony.cdnr.CarrierDisplayNameData r0 = r0.build()
            r13.notifySpnDisplayUpdate(r0)
            java.lang.String r0 = "updateSpnDisplayLegacy-"
            r13.log(r0)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.updateSpnDisplayLegacy():void");
    }

    public boolean shouldForceDisplayNoService() {
        String[] stringArray = this.mPhone.getContext().getResources().getStringArray(17236058);
        if (ArrayUtils.isEmpty(stringArray)) {
            return false;
        }
        this.mLastKnownNetworkCountry = this.mLocaleTracker.getLastKnownCountryIso();
        for (String equalsIgnoreCase : stringArray) {
            if (equalsIgnoreCase.equalsIgnoreCase(this.mLastKnownNetworkCountry)) {
                return true;
            }
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public void setPowerStateToDesired() {
        setPowerStateToDesired(false, false, false);
    }

    /* access modifiers changed from: protected */
    public void setPowerStateToDesired(boolean z, boolean z2, boolean z3) {
        String str = "setPowerStateToDesired: mDeviceShuttingDown=" + this.mDeviceShuttingDown + ", mDesiredPowerState=" + this.mDesiredPowerState + ", getRadioState=" + this.mCi.getRadioState() + ", mRadioDisabledByCarrier=" + this.mRadioDisabledByCarrier + ", IMS reg state=" + this.mImsRegistrationOnOff + ", pending radio off=" + hasMessages(62);
        log(str);
        this.mRadioPowerLog.log(str);
        boolean z4 = this.mDesiredPowerState;
        if (!z4 || !this.mDeviceShuttingDown) {
            if (z4 && !this.mRadioDisabledByCarrier && (z3 || this.mCi.getRadioState() == 0)) {
                this.mCi.setRadioPower(true, z, z2, (Message) null);
            } else if ((!this.mDesiredPowerState || this.mRadioDisabledByCarrier) && this.mCi.getRadioState() == 1) {
                if (this.mPhone.isUsingNewDataStack() || !this.mImsRegistrationOnOff || getRadioPowerOffDelayTimeoutForImsRegistration() <= 0) {
                    log("setPowerStateToDesired: powerOffRadioSafely()");
                    powerOffRadioSafely();
                    return;
                }
                log("setPowerStateToDesired: delaying power off until IMS dereg.");
                startDelayRadioOffWaitingForImsDeregTimeout();
                return;
            } else if (this.mDeviceShuttingDown && this.mCi.getRadioState() != 2) {
                this.mCi.requestShutdown((Message) null);
            }
            cancelDelayRadioOffWaitingForImsDeregTimeout();
            cancelPendingRadioPowerOff();
            return;
        }
        log("setPowerStateToDesired powering on of radio failed because the device is powering off");
    }

    /* access modifiers changed from: protected */
    public synchronized void cancelPendingRadioPowerOff() {
        if (this.mPhone.isUsingNewDataStack() && this.mPendingRadioPowerOffAfterDataOff) {
            log("cancelPendingRadioPowerOff: cancelling.");
            this.mPendingRadioPowerOffAfterDataOff = false;
            removeMessages(38);
        }
    }

    /* access modifiers changed from: protected */
    public void cancelDelayRadioOffWaitingForImsDeregTimeout() {
        if (hasMessages(62)) {
            log("cancelDelayRadioOffWaitingForImsDeregTimeout: cancelling.");
            removeMessages(62);
        }
    }

    /* access modifiers changed from: protected */
    public void startDelayRadioOffWaitingForImsDeregTimeout() {
        if (hasMessages(62)) {
            log("startDelayRadioOffWaitingForImsDeregTimeout: timer exists, ignoring");
            return;
        }
        log("startDelayRadioOffWaitingForImsDeregTimeout: starting timer");
        sendEmptyMessageDelayed(62, (long) getRadioPowerOffDelayTimeoutForImsRegistration());
    }

    /* access modifiers changed from: protected */
    public void onUpdateIccAvailability() {
        UiccCardApplication uiccCardApplication;
        if (this.mUiccController != null && this.mUiccApplcation != (uiccCardApplication = getUiccCardApplication())) {
            IccRecords iccRecords = this.mIccRecords;
            if (iccRecords instanceof SIMRecords) {
                this.mCdnr.updateEfFromUsim((SIMRecords) null);
            } else if (iccRecords instanceof RuimRecords) {
                this.mCdnr.updateEfFromRuim((RuimRecords) null);
            }
            if (this.mUiccApplcation != null) {
                log("Removing stale icc objects.");
                this.mUiccApplcation.unregisterForReady(this);
                IccRecords iccRecords2 = this.mIccRecords;
                if (iccRecords2 != null) {
                    iccRecords2.unregisterForRecordsLoaded(this);
                }
                this.mIccRecords = null;
                this.mUiccApplcation = null;
            }
            if (uiccCardApplication != null) {
                log("New card found");
                this.mUiccApplcation = uiccCardApplication;
                this.mIccRecords = uiccCardApplication.getIccRecords();
                if (this.mPhone.isPhoneTypeGsm()) {
                    this.mUiccApplcation.registerForReady(this, 17, (Object) null);
                    IccRecords iccRecords3 = this.mIccRecords;
                    if (iccRecords3 != null) {
                        iccRecords3.registerForRecordsLoaded(this, 16, (Object) null);
                    }
                } else if (this.mIsSubscriptionFromRuim) {
                    this.mUiccApplcation.registerForReady(this, 26, (Object) null);
                    IccRecords iccRecords4 = this.mIccRecords;
                    if (iccRecords4 != null) {
                        iccRecords4.registerForRecordsLoaded(this, 27, (Object) null);
                    }
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void logRoamingChange() {
        this.mRoamingLog.log(this.mSS.toString());
    }

    /* access modifiers changed from: protected */
    public void logAttachChange() {
        this.mAttachLog.log(this.mSS.toString());
    }

    /* access modifiers changed from: protected */
    public void logPhoneTypeChange() {
        this.mPhoneTypeLog.log(Integer.toString(this.mPhone.getPhoneType()));
    }

    /* access modifiers changed from: protected */
    public void logRatChange() {
        this.mRatLog.log(this.mSS.toString());
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

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getCurrentDataConnectionState() {
        return this.mSS.getDataRegistrationState();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isConcurrentVoiceAndDataAllowed() {
        if (this.mSS.getCssIndicator() == 1) {
            return true;
        }
        if (!this.mPhone.isPhoneTypeGsm()) {
            return false;
        }
        int rilDataRadioTechnology = this.mSS.getRilDataRadioTechnology();
        if (rilDataRadioTechnology == 0 && this.mSS.getDataRegistrationState() != 0) {
            rilDataRadioTechnology = this.mSS.getRilVoiceRadioTechnology();
        }
        if (rilDataRadioTechnology == 0 || ServiceState.rilRadioTechnologyToAccessNetworkType(rilDataRadioTechnology) == 1) {
            return false;
        }
        return true;
    }

    public void onImsServiceStateChanged() {
        sendMessage(obtainMessage(53));
    }

    public void setImsRegistrationState(boolean z) {
        log("setImsRegistrationState: {registered=" + z + " mImsRegistrationOnOff=" + this.mImsRegistrationOnOff + "}");
        if (this.mImsRegistrationOnOff && !z) {
            if (getRadioPowerOffDelayTimeoutForImsRegistration() > 0) {
                sendMessage(obtainMessage(45));
            } else {
                log("setImsRegistrationState: EVENT_CHANGE_IMS_STATE not sent because power off delay for IMS deregistration is not enabled.");
            }
        }
        this.mImsRegistrationOnOff = z;
    }

    public void onImsCapabilityChanged() {
        sendMessage(obtainMessage(48));
    }

    public boolean isRadioOn() {
        return this.mCi.getRadioState() == 1;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void pollState() {
        sendEmptyMessage(58);
    }

    /* access modifiers changed from: protected */
    public void pollStateInternal(boolean z) {
        this.mPollingContext = new int[1];
        log("pollState: modemTriggered=" + z + ", radioState=" + this.mCi.getRadioState());
        int radioState = this.mCi.getRadioState();
        if (radioState == 0) {
            NetworkRegistrationInfo networkRegistrationInfo = this.mNewSS.getNetworkRegistrationInfo(2, 2);
            this.mNewSS.setOutOfService(this.mAccessNetworksManager.isInLegacyMode(), true);
            if (networkRegistrationInfo != null) {
                this.mNewSS.addNetworkRegistrationInfo(networkRegistrationInfo);
            }
            this.mPhone.getSignalStrengthController().setSignalStrengthDefaultValues();
            this.mLastNitzData = null;
            this.mNitzState.handleNetworkUnavailable();
            if (this.mDeviceShuttingDown || (!z && 18 != this.mSS.getRilDataRadioTechnology())) {
                pollStateDone();
                return;
            }
        } else if (radioState == 2) {
            NetworkRegistrationInfo networkRegistrationInfo2 = this.mNewSS.getNetworkRegistrationInfo(2, 2);
            this.mNewSS.setOutOfService(this.mAccessNetworksManager.isInLegacyMode(), false);
            if (networkRegistrationInfo2 != null) {
                this.mNewSS.addNetworkRegistrationInfo(networkRegistrationInfo2);
            }
            this.mPhone.getSignalStrengthController().setSignalStrengthDefaultValues();
            this.mLastNitzData = null;
            this.mNitzState.handleNetworkUnavailable();
            pollStateDone();
            return;
        }
        int[] iArr = this.mPollingContext;
        iArr[0] = iArr[0] + 1;
        this.mCi.getOperator(obtainMessage(7, iArr));
        int[] iArr2 = this.mPollingContext;
        iArr2[0] = iArr2[0] + 1;
        this.mRegStateManagers.get(1).requestNetworkRegistrationInfo(2, obtainMessage(5, this.mPollingContext));
        int[] iArr3 = this.mPollingContext;
        iArr3[0] = iArr3[0] + 1;
        this.mRegStateManagers.get(1).requestNetworkRegistrationInfo(1, obtainMessage(4, this.mPollingContext));
        if (this.mRegStateManagers.get(2) != null) {
            int[] iArr4 = this.mPollingContext;
            iArr4[0] = iArr4[0] + 1;
            this.mRegStateManagers.get(2).requestNetworkRegistrationInfo(2, obtainMessage(6, this.mPollingContext));
        }
        if (this.mPhone.isPhoneTypeGsm()) {
            int[] iArr5 = this.mPollingContext;
            iArr5[0] = iArr5[0] + 1;
            this.mCi.getNetworkSelectionMode(obtainMessage(14, iArr5));
        }
    }

    @VisibleForTesting
    public static List<CellIdentity> getPrioritizedCellIdentities(ServiceState serviceState) {
        List networkRegistrationInfoList = serviceState.getNetworkRegistrationInfoList();
        if (networkRegistrationInfoList.isEmpty()) {
            return Collections.emptyList();
        }
        return (List) networkRegistrationInfoList.stream().filter(new ServiceStateTracker$$ExternalSyntheticLambda1()).filter(new ServiceStateTracker$$ExternalSyntheticLambda2()).sorted(Comparator.comparing(new ServiceStateTracker$$ExternalSyntheticLambda3()).thenComparing(new ServiceStateTracker$$ExternalSyntheticLambda4()).reversed()).map(new ServiceStateTracker$$ExternalSyntheticLambda5()).distinct().collect(Collectors.toList());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getPrioritizedCellIdentities$0(NetworkRegistrationInfo networkRegistrationInfo) {
        return networkRegistrationInfo.getCellIdentity() != null;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getPrioritizedCellIdentities$1(NetworkRegistrationInfo networkRegistrationInfo) {
        return networkRegistrationInfo.getTransportType() == 1;
    }

    /* access modifiers changed from: protected */
    public void pollStateDone() {
        CellIdentity cellIdentity;
        List<CellIdentity> list;
        CellIdentity cellIdentity2;
        boolean z;
        boolean z2;
        boolean z3;
        boolean z4;
        boolean z5;
        boolean z6;
        boolean z7;
        boolean z8;
        boolean z9;
        boolean z10;
        boolean z11;
        boolean z12;
        SparseBooleanArray sparseBooleanArray;
        boolean z13;
        boolean z14;
        int i;
        SparseBooleanArray sparseBooleanArray2;
        SparseBooleanArray sparseBooleanArray3;
        boolean z15;
        boolean z16;
        boolean z17;
        SparseBooleanArray sparseBooleanArray4;
        boolean z18;
        int i2;
        int i3;
        boolean z19;
        boolean z20;
        boolean z21;
        boolean z22;
        TelephonyTester telephonyTester;
        if (!this.mPhone.isPhoneTypeGsm()) {
            updateRoamingState();
        }
        if (TelephonyUtils.IS_DEBUGGABLE && SystemProperties.getBoolean(PROP_FORCE_ROAMING, false)) {
            this.mNewSS.setRoaming(true);
        }
        useDataRegStateForDataOnlyDevices();
        processIwlanRegistrationInfo();
        if (TelephonyUtils.IS_DEBUGGABLE && (telephonyTester = this.mPhone.mTelephonyTester) != null) {
            telephonyTester.overrideServiceState(this.mNewSS);
        }
        int i4 = 2;
        NetworkRegistrationInfo networkRegistrationInfo = this.mNewSS.getNetworkRegistrationInfo(2, 1);
        updateNrFrequencyRangeFromPhysicalChannelConfigs(this.mLastPhysicalChannelConfigList, this.mNewSS);
        updateNrStateFromPhysicalChannelConfigs(this.mLastPhysicalChannelConfigList, this.mNewSS);
        setPhyCellInfoFromCellIdentity(this.mNewSS, networkRegistrationInfo.getCellIdentity());
        log("Poll ServiceState done:  oldSS=[" + this.mSS + "] newSS=[" + this.mNewSS + "] oldMaxDataCalls=" + this.mMaxDataCalls + " mNewMaxDataCalls=" + this.mNewMaxDataCalls + " oldReasonDataDenied=" + this.mReasonDataDenied + " mNewReasonDataDenied=" + this.mNewReasonDataDenied);
        boolean z23 = this.mSS.getState() != 0 && this.mNewSS.getState() == 0;
        boolean z24 = this.mSS.getState() == 0 && this.mNewSS.getState() != 0;
        boolean z25 = this.mSS.getState() != 3 && this.mNewSS.getState() == 3;
        boolean z26 = this.mSS.getState() == 3 && this.mNewSS.getState() != 3;
        SparseBooleanArray sparseBooleanArray5 = new SparseBooleanArray(this.mAccessNetworksManager.getAvailableTransports().length);
        SparseBooleanArray sparseBooleanArray6 = new SparseBooleanArray(this.mAccessNetworksManager.getAvailableTransports().length);
        SparseBooleanArray sparseBooleanArray7 = new SparseBooleanArray(this.mAccessNetworksManager.getAvailableTransports().length);
        SparseBooleanArray sparseBooleanArray8 = new SparseBooleanArray(this.mAccessNetworksManager.getAvailableTransports().length);
        boolean z27 = !TextUtils.equals(this.mSS.getOperatorAlphaLongRaw(), this.mNewSS.getOperatorAlphaLongRaw()) || !TextUtils.equals(this.mSS.getOperatorAlphaShortRaw(), this.mNewSS.getOperatorAlphaShortRaw());
        int[] availableTransports = this.mAccessNetworksManager.getAvailableTransports();
        int length = availableTransports.length;
        int i5 = 0;
        boolean z28 = false;
        boolean z29 = false;
        while (i5 < length) {
            int i6 = availableTransports[i5];
            NetworkRegistrationInfo networkRegistrationInfo2 = this.mSS.getNetworkRegistrationInfo(i4, i6);
            int[] iArr = availableTransports;
            NetworkRegistrationInfo networkRegistrationInfo3 = this.mNewSS.getNetworkRegistrationInfo(i4, i6);
            sparseBooleanArray5.put(i6, (networkRegistrationInfo2 == null || !networkRegistrationInfo2.isInService() || z25) && networkRegistrationInfo3 != null && networkRegistrationInfo3.isInService());
            sparseBooleanArray6.put(i6, networkRegistrationInfo2 != null && networkRegistrationInfo2.isInService() && (networkRegistrationInfo3 == null || !networkRegistrationInfo3.isInService()));
            int accessNetworkTechnology = networkRegistrationInfo2 != null ? networkRegistrationInfo2.getAccessNetworkTechnology() : 0;
            if (networkRegistrationInfo3 != null) {
                i2 = length;
                i3 = networkRegistrationInfo3.getAccessNetworkTechnology();
            } else {
                i2 = length;
                i3 = 0;
            }
            if (networkRegistrationInfo2 != null) {
                z19 = z26;
                z20 = networkRegistrationInfo2.isUsingCarrierAggregation();
            } else {
                z19 = z26;
                z20 = false;
            }
            if (networkRegistrationInfo3 != null) {
                z21 = z25;
                z22 = networkRegistrationInfo3.isUsingCarrierAggregation();
            } else {
                z21 = z25;
                z22 = false;
            }
            sparseBooleanArray7.put(i6, (accessNetworkTechnology == i3 && z20 == z22 && !z27) ? false : true);
            if (accessNetworkTechnology != i3) {
                z28 = true;
            }
            int registrationState = networkRegistrationInfo2 != null ? networkRegistrationInfo2.getRegistrationState() : 4;
            int registrationState2 = networkRegistrationInfo3 != null ? networkRegistrationInfo3.getRegistrationState() : 4;
            sparseBooleanArray8.put(i6, registrationState != registrationState2);
            if (registrationState != registrationState2) {
                z29 = true;
            }
            i5++;
            availableTransports = iArr;
            length = i2;
            z26 = z19;
            z25 = z21;
            i4 = 2;
        }
        boolean z30 = z25;
        boolean z31 = z26;
        boolean z32 = !z28 && this.mSS.getRilDataRadioTechnology() != this.mNewSS.getRilDataRadioTechnology();
        boolean z33 = this.mSS.getState() != this.mNewSS.getState();
        boolean z34 = this.mSS.getNrFrequencyRange() != this.mNewSS.getNrFrequencyRange();
        boolean z35 = this.mSS.getNrState() != this.mNewSS.getNrState();
        List<CellIdentity> prioritizedCellIdentities = getPrioritizedCellIdentities(this.mNewSS);
        if (prioritizedCellIdentities.isEmpty()) {
            cellIdentity = null;
        } else {
            cellIdentity = prioritizedCellIdentities.get(0);
        }
        CellIdentity cellIdentity3 = this.mCellIdentity;
        boolean z36 = cellIdentity3 != null ? !cellIdentity3.isSameCell(cellIdentity) : cellIdentity != null;
        boolean z37 = false;
        for (NetworkRegistrationInfo isRegistered : this.mNewSS.getNetworkRegistrationInfoListForTransportType(1)) {
            z37 |= isRegistered.isRegistered();
        }
        if (!z37 || z36) {
            list = prioritizedCellIdentities;
        } else {
            list = prioritizedCellIdentities;
            this.mRatRatcheter.ratchet(this.mSS, this.mNewSS);
        }
        boolean z38 = this.mSS.getRilVoiceRadioTechnology() != this.mNewSS.getRilVoiceRadioTechnology();
        boolean z39 = !this.mNewSS.equals(this.mSS);
        if (this.mSS.getVoiceRoaming() || !this.mNewSS.getVoiceRoaming()) {
            cellIdentity2 = cellIdentity;
            z = false;
        } else {
            cellIdentity2 = cellIdentity;
            z = true;
        }
        if (!this.mSS.getVoiceRoaming() || this.mNewSS.getVoiceRoaming()) {
            z2 = z33;
            z3 = false;
        } else {
            z2 = z33;
            z3 = true;
        }
        if (this.mSS.getDataRoaming() || !this.mNewSS.getDataRoaming()) {
            z4 = z35;
            z5 = false;
        } else {
            z4 = z35;
            z5 = true;
        }
        if (!this.mSS.getDataRoaming() || this.mNewSS.getDataRoaming()) {
            z6 = z34;
            z7 = false;
        } else {
            z6 = z34;
            z7 = true;
        }
        boolean z40 = z36;
        boolean z41 = this.mRejectCode != this.mNewRejectCode;
        boolean z42 = this.mSS.getCssIndicator() != this.mNewSS.getCssIndicator();
        boolean z43 = this.mSS.getCellBandwidths() != this.mNewSS.getCellBandwidths();
        if (this.mPhone.isPhoneTypeCdmaLte()) {
            int rilDataRadioTechnologyForWwan = getRilDataRadioTechnologyForWwan(this.mSS);
            z9 = z43;
            int rilDataRadioTechnologyForWwan2 = getRilDataRadioTechnologyForWwan(this.mNewSS);
            z8 = z7;
            z10 = this.mNewSS.getDataRegistrationState() == 0 && ((ServiceState.isPsOnlyTech(rilDataRadioTechnologyForWwan) && rilDataRadioTechnologyForWwan2 == 13) || (rilDataRadioTechnologyForWwan == 13 && ServiceState.isPsOnlyTech(rilDataRadioTechnologyForWwan2)));
            z12 = (ServiceState.isPsOnlyTech(rilDataRadioTechnologyForWwan2) || rilDataRadioTechnologyForWwan2 == 13) && !ServiceState.isPsOnlyTech(rilDataRadioTechnologyForWwan) && rilDataRadioTechnologyForWwan != 13;
            z11 = rilDataRadioTechnologyForWwan2 >= 4 && rilDataRadioTechnologyForWwan2 <= 8;
        } else {
            z9 = z43;
            z8 = z7;
            z12 = false;
            z11 = false;
            z10 = false;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("pollStateDone: hasRegistered = ");
        sb.append(z23);
        sb.append(" hasDeregistered = ");
        sb.append(z24);
        sb.append(" hasDataAttached = ");
        sb.append(sparseBooleanArray5);
        sb.append(" hasDataDetached = ");
        sb.append(sparseBooleanArray6);
        sb.append(" hasDataRegStateChanged = ");
        sb.append(sparseBooleanArray8);
        sb.append(" hasRilVoiceRadioTechnologyChanged = ");
        sb.append(z38);
        sb.append(" hasRilDataRadioTechnologyChanged = ");
        sb.append(sparseBooleanArray7);
        sb.append(" hasDataTransportPreferenceChanged = ");
        sb.append(z32);
        sb.append(" hasChanged = ");
        sb.append(z39);
        sb.append(" hasVoiceRoamingOn = ");
        sb.append(z);
        sb.append(" hasVoiceRoamingOff = ");
        sb.append(z3);
        sb.append(" hasDataRoamingOn =");
        sb.append(z5);
        sb.append(" hasDataRoamingOff = ");
        sb.append(z8);
        sb.append(" hasLocationChanged = ");
        sb.append(z40);
        sb.append(" has4gHandoff = ");
        sb.append(z10);
        sb.append(" hasMultiApnSupport = ");
        sb.append(z12);
        sb.append(" hasLostMultiApnSupport = ");
        sb.append(z11);
        sb.append(" hasCssIndicatorChanged = ");
        boolean z44 = z42;
        sb.append(z44);
        sb.append(" hasNrFrequencyRangeChanged = ");
        sb.append(z6);
        sb.append(" hasNrStateChanged = ");
        sb.append(z4);
        sb.append(" hasBandwidthChanged = ");
        boolean z45 = z9;
        sb.append(z45);
        boolean z46 = z5;
        sb.append(" hasAirplaneModeOnlChanged = ");
        sb.append(z30);
        String sb2 = sb.toString();
        log(sb2);
        if (z2 || z29) {
            z14 = z3;
            z13 = z;
            sparseBooleanArray = sparseBooleanArray6;
            i = 3;
            EventLog.writeEvent(this.mPhone.isPhoneTypeGsm() ? EventLogTags.GSM_SERVICE_STATE_CHANGE : EventLogTags.CDMA_SERVICE_STATE_CHANGE, new Object[]{Integer.valueOf(this.mSS.getState()), Integer.valueOf(this.mSS.getDataRegistrationState()), Integer.valueOf(this.mNewSS.getState()), Integer.valueOf(this.mNewSS.getDataRegistrationState())});
        } else {
            z14 = z3;
            sparseBooleanArray = sparseBooleanArray6;
            z13 = z;
            i = 3;
        }
        if (this.mPhone.isPhoneTypeGsm()) {
            sparseBooleanArray2 = sparseBooleanArray5;
            if (z38) {
                long cidFromCellIdentity = getCidFromCellIdentity(cellIdentity2);
                Object[] objArr = new Object[i];
                objArr[0] = Long.valueOf(cidFromCellIdentity);
                objArr[1] = Integer.valueOf(this.mSS.getRilVoiceRadioTechnology());
                objArr[2] = Integer.valueOf(this.mNewSS.getRilVoiceRadioTechnology());
                EventLog.writeEvent(EventLogTags.GSM_RAT_SWITCHED_NEW, objArr);
                log("RAT switched " + ServiceState.rilRadioTechnologyToString(this.mSS.getRilVoiceRadioTechnology()) + " -> " + ServiceState.rilRadioTechnologyToString(this.mNewSS.getRilVoiceRadioTechnology()) + " at cell " + cidFromCellIdentity);
            }
            this.mReasonDataDenied = this.mNewReasonDataDenied;
            this.mMaxDataCalls = this.mNewMaxDataCalls;
            this.mRejectCode = this.mNewRejectCode;
        } else {
            sparseBooleanArray2 = sparseBooleanArray5;
        }
        if (!Objects.equals(this.mSS, this.mNewSS)) {
            this.mServiceStateChangedRegistrants.notifyRegistrants();
        }
        ServiceState serviceState = new ServiceState(this.mPhone.getServiceState());
        this.mSS = new ServiceState(this.mNewSS);
        this.mNewSS.setOutOfService(this.mAccessNetworksManager.isInLegacyMode(), false);
        CellIdentity cellIdentity4 = cellIdentity2;
        this.mCellIdentity = cellIdentity4;
        if (this.mSS.getState() == 0 && cellIdentity4 != null) {
            this.mLastKnownCellIdentity = this.mCellIdentity;
            removeMessages(63);
        }
        if (!z24 || hasMessages(63)) {
            z15 = z32;
            sparseBooleanArray3 = sparseBooleanArray2;
        } else {
            z15 = z32;
            sparseBooleanArray3 = sparseBooleanArray2;
            sendEmptyMessageDelayed(63, TimeUnit.DAYS.toMillis(1));
        }
        int areaCodeFromCellIdentity = getAreaCodeFromCellIdentity(this.mCellIdentity);
        if (!(areaCodeFromCellIdentity == this.mLastKnownAreaCode || areaCodeFromCellIdentity == Integer.MAX_VALUE)) {
            this.mLastKnownAreaCode = areaCodeFromCellIdentity;
            this.mAreaCodeChangedRegistrants.notifyRegistrants();
        }
        if (z38) {
            updatePhoneObject();
        }
        TelephonyManager telephonyManager = (TelephonyManager) this.mPhone.getContext().getSystemService("phone");
        if (z28) {
            telephonyManager.setDataNetworkTypeForPhone(this.mPhone.getPhoneId(), this.mSS.getRilDataRadioTechnology());
            TelephonyStatsLog.write(76, ServiceState.rilRadioTechnologyToNetworkType(this.mSS.getRilDataRadioTechnology()), this.mPhone.getPhoneId());
        }
        if (z23) {
            this.mNetworkAttachedRegistrants.notifyRegistrants();
            this.mNitzState.handleNetworkAvailable();
        }
        if (z24) {
            this.mNetworkDetachedRegistrants.notifyRegistrants();
            this.mNitzState.handleNetworkUnavailable();
        }
        if (z44) {
            this.mCssIndicatorChangedRegistrants.notifyRegistrants();
        }
        if (z45) {
            this.mBandwidthChangedRegistrants.notifyRegistrants();
        }
        if (z41) {
            setNotification(2001);
        }
        String cdmaEriText = this.mPhone.getCdmaEriText();
        boolean z47 = !TextUtils.equals(this.mEriText, cdmaEriText);
        this.mEriText = cdmaEriText;
        if (z39 || (!this.mPhone.isPhoneTypeGsm() && z47)) {
            updateSpnDisplay();
        }
        if (z39) {
            telephonyManager.setNetworkOperatorNameForPhone(this.mPhone.getPhoneId(), this.mSS.getOperatorAlpha());
            String operatorNumeric = this.mSS.getOperatorNumeric();
            if (!this.mPhone.isPhoneTypeGsm() && isInvalidOperatorNumeric(operatorNumeric)) {
                operatorNumeric = fixUnknownMcc(operatorNumeric, this.mSS.getCdmaSystemId());
            }
            telephonyManager.setNetworkOperatorNumericForPhone(this.mPhone.getPhoneId(), operatorNumeric);
            if (isInvalidOperatorNumeric(operatorNumeric) || this.mSS.getDataNetworkType() == 18) {
                Iterator<CellIdentity> it = list.iterator();
                while (true) {
                    if (!it.hasNext()) {
                        break;
                    }
                    CellIdentity next = it.next();
                    if (!TextUtils.isEmpty(next.getPlmn())) {
                        operatorNumeric = next.getPlmn();
                        break;
                    }
                }
            }
            if (isInvalidOperatorNumeric(operatorNumeric)) {
                log("localeOperator " + operatorNumeric + " is invalid");
                this.mLocaleTracker.updateOperatorNumeric("");
            } else {
                if (!this.mPhone.isPhoneTypeGsm()) {
                    setOperatorIdd(operatorNumeric);
                }
                this.mLocaleTracker.updateOperatorNumeric(operatorNumeric);
            }
            int phoneId = this.mPhone.getPhoneId();
            if (this.mPhone.isPhoneTypeGsm()) {
                z18 = this.mSS.getVoiceRoaming();
            } else {
                z18 = this.mSS.getVoiceRoaming() || this.mSS.getDataRoaming();
            }
            telephonyManager.setNetworkRoamingForPhone(phoneId, z18);
            setRoamingType(this.mSS);
            log("Broadcasting ServiceState : " + this.mSS);
            if (!serviceState.equals(this.mPhone.getServiceState())) {
                GsmCdmaPhone gsmCdmaPhone = this.mPhone;
                gsmCdmaPhone.notifyServiceStateChanged(gsmCdmaPhone.getServiceState());
            }
            this.mPhone.getContext().getContentResolver().insert(Telephony.ServiceStateTable.getUriForSubscriptionId(this.mPhone.getSubId()), getContentValuesForServiceState(this.mSS));
            TelephonyMetrics.getInstance().writeServiceStateChanged(this.mPhone.getPhoneId(), this.mSS);
            this.mPhone.getVoiceCallSessionStats().onServiceStateChanged(this.mSS);
            this.mServiceStateStats.onServiceStateChanged(this.mSS);
        }
        boolean z48 = z23 || z24;
        if (z10) {
            this.mAttachedRegistrants.get(1).notifyRegistrants();
            z16 = true;
        } else {
            z16 = z48;
        }
        if (z38) {
            this.mPhone.getSignalStrengthController().notifySignalStrength();
            z17 = true;
        } else {
            z17 = false;
        }
        int[] availableTransports2 = this.mAccessNetworksManager.getAvailableTransports();
        int length2 = availableTransports2.length;
        boolean z49 = z17;
        int i7 = 0;
        while (i7 < length2) {
            int i8 = availableTransports2[i7];
            if (sparseBooleanArray7.get(i8)) {
                this.mPhone.getSignalStrengthController().notifySignalStrength();
                z49 = true;
            }
            if (sparseBooleanArray8.get(i8) || sparseBooleanArray7.get(i8) || z15) {
                setDataNetworkTypeForPhone(this.mSS.getRilDataRadioTechnology());
                notifyDataRegStateRilRadioTechnologyChanged(i8);
            }
            SparseBooleanArray sparseBooleanArray9 = sparseBooleanArray3;
            if (sparseBooleanArray9.get(i8)) {
                if (this.mAttachedRegistrants.get(i8) != null) {
                    this.mAttachedRegistrants.get(i8).notifyRegistrants();
                }
                sparseBooleanArray4 = sparseBooleanArray;
                z16 = true;
            } else {
                sparseBooleanArray4 = sparseBooleanArray;
            }
            if (sparseBooleanArray4.get(i8)) {
                if (this.mDetachedRegistrants.get(i8) != null) {
                    this.mDetachedRegistrants.get(i8).notifyRegistrants();
                }
                z16 = true;
            }
            i7++;
            sparseBooleanArray3 = sparseBooleanArray9;
            sparseBooleanArray = sparseBooleanArray4;
        }
        if (z31) {
            this.mPhone.getSignalStrengthController().getSignalStrengthFromCi();
        }
        if (z16) {
            logAttachChange();
        }
        if (z49) {
            logRatChange();
        }
        if (z2 || z38) {
            notifyVoiceRegStateRilRadioTechnologyChanged();
        }
        if (z13 || z14 || z46 || z8) {
            logRoamingChange();
        }
        if (z13) {
            this.mVoiceRoamingOnRegistrants.notifyRegistrants();
        }
        if (z14) {
            this.mVoiceRoamingOffRegistrants.notifyRegistrants();
        }
        if (z46) {
            this.mDataRoamingOnRegistrants.notifyRegistrants();
        }
        if (z8) {
            this.mDataRoamingOffRegistrants.notifyRegistrants();
        }
        if (z40) {
            this.mPhone.notifyLocationChanged(getCellIdentity());
        }
        if (z4) {
            this.mNrStateChangedRegistrants.notifyRegistrants();
        }
        if (z6) {
            this.mNrFrequencyChangedRegistrants.notifyRegistrants();
        }
        if (!this.mPhone.isPhoneTypeGsm()) {
            return;
        }
        if (isGprsConsistent(this.mSS.getDataRegistrationState(), this.mSS.getState())) {
            this.mReportedGprsNoReg = false;
        } else if (!this.mStartedGprsRegCheck && !this.mReportedGprsNoReg) {
            this.mStartedGprsRegCheck = true;
            sendMessageDelayed(obtainMessage(22), (long) Settings.Global.getInt(this.mPhone.getContext().getContentResolver(), "gprs_register_check_period_ms", DEFAULT_GPRS_CHECK_PERIOD_MILLIS));
        }
    }

    /* access modifiers changed from: protected */
    public String getOperatorNameFromEri() {
        EriManager eriManager;
        String str = null;
        if (this.mPhone.isPhoneTypeCdma()) {
            if (this.mCi.getRadioState() != 1 || this.mIsSubscriptionFromRuim) {
                return null;
            }
            if (this.mSS.getState() == 0) {
                return this.mPhone.getCdmaEriText();
            }
            return this.mPhone.getContext().getText(17041473).toString();
        } else if (!this.mPhone.isPhoneTypeCdmaLte()) {
            return null;
        } else {
            if (!((this.mUiccController.getUiccPort(getPhoneId()) == null || this.mUiccController.getUiccPort(getPhoneId()).getOperatorBrandOverride() == null) ? false : true) && this.mCi.getRadioState() == 1 && (eriManager = this.mEriManager) != null && eriManager.isEriFileLoaded() && (!ServiceState.isPsOnlyTech(this.mSS.getRilVoiceRadioTechnology()) || this.mPhone.getContext().getResources().getBoolean(17891343))) {
                str = this.mSS.getOperatorAlpha();
                if (this.mSS.getState() == 0) {
                    str = this.mPhone.getCdmaEriText();
                } else if (this.mSS.getState() == 3) {
                    str = getServiceProviderName();
                    if (TextUtils.isEmpty(str)) {
                        str = SystemProperties.get("ro.cdma.home.operator.alpha");
                    }
                } else if (this.mSS.getDataRegistrationState() != 0) {
                    str = this.mPhone.getContext().getText(17041473).toString();
                }
            }
            UiccCardApplication uiccCardApplication = this.mUiccApplcation;
            if (uiccCardApplication == null || uiccCardApplication.getState() != IccCardApplicationStatus.AppState.APPSTATE_READY || this.mIccRecords == null || getCombinedRegState(this.mSS) != 0 || ServiceState.isPsOnlyTech(this.mSS.getRilVoiceRadioTechnology())) {
                return str;
            }
            return (!((RuimRecords) this.mIccRecords).getCsimSpnDisplayCondition() || this.mSS.getCdmaEriIconIndex() != 1 || !isInHomeSidNid(this.mSS.getCdmaSystemId(), this.mSS.getCdmaNetworkId()) || this.mIccRecords == null) ? str : getServiceProviderName();
        }
    }

    public String getServiceProviderName() {
        String operatorBrandOverride = getOperatorBrandOverride();
        if (!TextUtils.isEmpty(operatorBrandOverride)) {
            return operatorBrandOverride;
        }
        IccRecords iccRecords = this.mIccRecords;
        String serviceProviderName = iccRecords != null ? iccRecords.getServiceProviderName() : "";
        PersistableBundle carrierConfig = getCarrierConfig();
        if (carrierConfig.getBoolean("carrier_name_override_bool") || TextUtils.isEmpty(serviceProviderName)) {
            return carrierConfig.getString("carrier_name_string");
        }
        return serviceProviderName;
    }

    public int getCarrierNameDisplayBitmask(ServiceState serviceState) {
        boolean z;
        PersistableBundle carrierConfig = getCarrierConfig();
        if (!TextUtils.isEmpty(getOperatorBrandOverride())) {
            return 1;
        }
        if (TextUtils.isEmpty(getServiceProviderName())) {
            return 2;
        }
        boolean z2 = carrierConfig.getBoolean("spn_display_rule_use_roaming_from_service_state_bool");
        IccRecords iccRecords = this.mIccRecords;
        int carrierNameDisplayCondition = iccRecords == null ? 0 : iccRecords.getCarrierNameDisplayCondition();
        if (z2) {
            z = serviceState.getRoaming();
        } else {
            IccRecords iccRecords2 = this.mIccRecords;
            z = !ArrayUtils.contains(iccRecords2 != null ? iccRecords2.getHomePlmns() : null, serviceState.getOperatorNumeric());
        }
        if (z) {
            if ((carrierNameDisplayCondition & 2) != 2) {
                return 2;
            }
        } else if ((carrierNameDisplayCondition & 1) != 1) {
            return 1;
        }
        return 3;
    }

    /* access modifiers changed from: protected */
    public String getOperatorBrandOverride() {
        UiccProfile uiccProfile;
        UiccPort uiccPort = this.mPhone.getUiccPort();
        if (uiccPort == null || (uiccProfile = uiccPort.getUiccProfile()) == null) {
            return null;
        }
        return uiccProfile.getOperatorBrandOverride();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isInHomeSidNid(int i, int i2) {
        int i3;
        if (isSidsAllZeros() || this.mHomeSystemId.length != this.mHomeNetworkId.length || i == 0) {
            return true;
        }
        int i4 = 0;
        while (true) {
            int[] iArr = this.mHomeSystemId;
            if (i4 >= iArr.length) {
                return false;
            }
            if (!(iArr[i4] == i && ((i3 = this.mHomeNetworkId[i4]) == 0 || i3 == 65535 || i2 == 0 || i2 == 65535 || i3 == i2))) {
                i4++;
            }
        }
        return true;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setOperatorIdd(String str) {
        if (!this.mPhone.getUnitTestMode()) {
            String iddByMcc = this.mHbpcdUtils.getIddByMcc(Integer.parseInt(str.substring(0, 3)));
            if (iddByMcc == null || iddByMcc.isEmpty()) {
                TelephonyProperties.operator_idp_string("+");
            } else {
                TelephonyProperties.operator_idp_string(iddByMcc);
            }
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isInvalidOperatorNumeric(String str) {
        return str == null || str.length() < 5 || str.startsWith(INVALID_MCC);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String fixUnknownMcc(String str, int i) {
        int i2;
        if (i <= 0) {
            return str;
        }
        NitzData nitzData = this.mLastNitzData;
        boolean z = true;
        int i3 = 0;
        if (nitzData != null) {
            int localOffsetMillis = nitzData.getLocalOffsetMillis() / MS_PER_HOUR;
            Integer dstAdjustmentMillis = nitzData.getDstAdjustmentMillis();
            if (!(dstAdjustmentMillis == null || dstAdjustmentMillis.intValue() == 0)) {
                i3 = 1;
            }
            i2 = i3;
            i3 = localOffsetMillis;
        } else {
            i2 = 0;
            z = false;
        }
        int mcc = this.mHbpcdUtils.getMcc(i, i3, i2, z);
        if (mcc <= 0) {
            return str;
        }
        return mcc + DEFAULT_MNC;
    }

    private boolean isSameOperatorNameFromSimAndSS(ServiceState serviceState) {
        String simOperatorNameForPhone = ((TelephonyManager) this.mPhone.getContext().getSystemService("phone")).getSimOperatorNameForPhone(getPhoneId());
        String operatorAlphaLong = serviceState.getOperatorAlphaLong();
        String operatorAlphaShort = serviceState.getOperatorAlphaShort();
        boolean z = !TextUtils.isEmpty(simOperatorNameForPhone) && simOperatorNameForPhone.equalsIgnoreCase(operatorAlphaLong);
        boolean z2 = !TextUtils.isEmpty(simOperatorNameForPhone) && simOperatorNameForPhone.equalsIgnoreCase(operatorAlphaShort);
        if (z || z2) {
            return true;
        }
        return false;
    }

    private boolean isSameNamedOperators(ServiceState serviceState) {
        return currentMccEqualsSimMcc(serviceState) && isSameOperatorNameFromSimAndSS(serviceState);
    }

    private boolean currentMccEqualsSimMcc(ServiceState serviceState) {
        try {
            return ((TelephonyManager) this.mPhone.getContext().getSystemService("phone")).getSimOperatorNumericForPhone(getPhoneId()).substring(0, 3).equals(serviceState.getOperatorNumeric().substring(0, 3));
        } catch (Exception unused) {
            return true;
        }
    }

    /* access modifiers changed from: protected */
    public boolean isOperatorConsideredNonRoaming(ServiceState serviceState) {
        String operatorNumeric = serviceState.getOperatorNumeric();
        String[] stringArray = getCarrierConfig().getStringArray("non_roaming_operator_string_array");
        if (!ArrayUtils.isEmpty(stringArray) && operatorNumeric != null) {
            for (String str : stringArray) {
                if (!TextUtils.isEmpty(str) && operatorNumeric.startsWith(str)) {
                    return true;
                }
            }
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean isOperatorConsideredRoaming(ServiceState serviceState) {
        String operatorNumeric = serviceState.getOperatorNumeric();
        String[] stringArray = getCarrierConfig().getStringArray("roaming_operator_string_array");
        if (!ArrayUtils.isEmpty(stringArray) && operatorNumeric != null) {
            for (String str : stringArray) {
                if (!TextUtils.isEmpty(str) && operatorNumeric.startsWith(str)) {
                    return true;
                }
            }
        }
        return false;
    }

    private void onRestrictedStateChanged(AsyncResult asyncResult) {
        Object obj;
        RestrictedState restrictedState = new RestrictedState();
        log("onRestrictedStateChanged: E rs " + this.mRestrictedState);
        if (asyncResult.exception == null && (obj = asyncResult.result) != null) {
            int intValue = ((Integer) obj).intValue();
            boolean z = false;
            restrictedState.setCsEmergencyRestricted(((intValue & 1) == 0 && (intValue & 4) == 0) ? false : true);
            UiccCardApplication uiccCardApplication = this.mUiccApplcation;
            if (uiccCardApplication != null && uiccCardApplication.getState() == IccCardApplicationStatus.AppState.APPSTATE_READY) {
                restrictedState.setCsNormalRestricted(((intValue & 2) == 0 && (intValue & 4) == 0) ? false : true);
                if ((intValue & 16) != 0) {
                    z = true;
                }
                restrictedState.setPsRestricted(z);
            }
            log("onRestrictedStateChanged: new rs " + restrictedState);
            if (!this.mRestrictedState.isPsRestricted() && restrictedState.isPsRestricted()) {
                this.mPsRestrictEnabledRegistrants.notifyRegistrants();
                setNotification(1001);
            } else if (this.mRestrictedState.isPsRestricted() && !restrictedState.isPsRestricted()) {
                this.mPsRestrictDisabledRegistrants.notifyRegistrants();
                setNotification(1002);
            }
            if (this.mRestrictedState.isCsRestricted()) {
                if (!restrictedState.isAnyCsRestricted()) {
                    setNotification(1004);
                } else if (!restrictedState.isCsNormalRestricted()) {
                    setNotification(1006);
                } else if (!restrictedState.isCsEmergencyRestricted()) {
                    setNotification(1005);
                }
            } else if (!this.mRestrictedState.isCsEmergencyRestricted() || this.mRestrictedState.isCsNormalRestricted()) {
                if (this.mRestrictedState.isCsEmergencyRestricted() || !this.mRestrictedState.isCsNormalRestricted()) {
                    if (restrictedState.isCsRestricted()) {
                        setNotification(1003);
                    } else if (restrictedState.isCsEmergencyRestricted()) {
                        setNotification(1006);
                    } else if (restrictedState.isCsNormalRestricted()) {
                        setNotification(1005);
                    }
                } else if (!restrictedState.isAnyCsRestricted()) {
                    setNotification(1004);
                } else if (restrictedState.isCsRestricted()) {
                    setNotification(1003);
                } else if (restrictedState.isCsEmergencyRestricted()) {
                    setNotification(1006);
                }
            } else if (!restrictedState.isAnyCsRestricted()) {
                setNotification(1004);
            } else if (restrictedState.isCsRestricted()) {
                setNotification(1003);
            } else if (restrictedState.isCsNormalRestricted()) {
                setNotification(1005);
            }
            this.mRestrictedState = restrictedState;
        }
        log("onRestrictedStateChanged: X rs " + this.mRestrictedState);
    }

    public CellIdentity getCellIdentity() {
        CellIdentity cellIdentity = this.mCellIdentity;
        if (cellIdentity != null) {
            return cellIdentity;
        }
        CellIdentity cellIdentityFromCellInfo = getCellIdentityFromCellInfo(getAllCellInfo());
        if (cellIdentityFromCellInfo != null) {
            return cellIdentityFromCellInfo;
        }
        return this.mPhone.getPhoneType() == 2 ? new CellIdentityCdma() : new CellIdentityGsm();
    }

    public void requestCellIdentity(WorkSource workSource, Message message) {
        CellIdentity cellIdentity = this.mCellIdentity;
        if (cellIdentity != null) {
            AsyncResult.forMessage(message, cellIdentity, (Throwable) null);
            message.sendToTarget();
            return;
        }
        requestAllCellInfo(workSource, obtainMessage(56, message));
    }

    private static CellIdentity getCellIdentityFromCellInfo(List<CellInfo> list) {
        CellIdentity cellIdentity = null;
        if (list == null || list.size() <= 0) {
            return null;
        }
        Iterator<CellInfo> it = list.iterator();
        CellIdentity cellIdentity2 = null;
        while (true) {
            if (!it.hasNext()) {
                break;
            }
            CellIdentity cellIdentity3 = it.next().getCellIdentity();
            if (!(cellIdentity3 instanceof CellIdentityLte) || cellIdentity2 != null) {
                if (getCidFromCellIdentity(cellIdentity3) != -1) {
                    cellIdentity = cellIdentity3;
                    break;
                }
            } else if (getCidFromCellIdentity(cellIdentity3) != -1) {
                cellIdentity2 = cellIdentity3;
            }
        }
        return (cellIdentity != null || cellIdentity2 == null) ? cellIdentity : cellIdentity2;
    }

    /* access modifiers changed from: protected */
    public void setTimeFromNITZString(String str, long j, long j2) {
        long j3 = j;
        long elapsedRealtime = SystemClock.elapsedRealtime();
        StringBuilder sb = new StringBuilder();
        sb.append("NITZ: ");
        String str2 = str;
        sb.append(str);
        sb.append(",");
        sb.append(j3);
        sb.append(", ageMs=");
        sb.append(j2);
        sb.append(" start=");
        sb.append(elapsedRealtime);
        sb.append(" delay=");
        sb.append(elapsedRealtime - j3);
        Rlog.d(LOG_TAG, sb.toString());
        NitzData parse = NitzData.parse(str);
        this.mLastNitzData = parse;
        if (parse != null) {
            try {
                this.mNitzState.handleNitzReceived(new NitzSignal(j, parse, j2));
            } finally {
                long elapsedRealtime2 = SystemClock.elapsedRealtime();
                Rlog.d(LOG_TAG, "NITZ: end=" + elapsedRealtime2 + " dur=" + (elapsedRealtime2 - elapsedRealtime));
            }
        }
    }

    private void cancelAllNotifications() {
        log("cancelAllNotifications: mPrevSubId=" + this.mPrevSubId);
        NotificationManager notificationManager = (NotificationManager) this.mPhone.getContext().getSystemService("notification");
        if (SubscriptionManager.isValidSubscriptionId(this.mPrevSubId)) {
            notificationManager.cancel(Integer.toString(this.mPrevSubId), PS_NOTIFICATION);
            notificationManager.cancel(Integer.toString(this.mPrevSubId), CS_NOTIFICATION);
            notificationManager.cancel(Integer.toString(this.mPrevSubId), 111);
            notificationManager.cancel(CarrierServiceStateTracker.EMERGENCY_NOTIFICATION_TAG, this.mPrevSubId);
            notificationManager.cancel(CarrierServiceStateTracker.PREF_NETWORK_NOTIFICATION_TAG, this.mPrevSubId);
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:39:0x00f3, code lost:
        r4 = PS_NOTIFICATION;
     */
    @com.android.internal.annotations.VisibleForTesting
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void setNotification(int r17) {
        /*
            r16 = this;
            r0 = r16
            r1 = r17
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "setNotification: create notification "
            r2.append(r3)
            r2.append(r1)
            java.lang.String r2 = r2.toString()
            r0.log(r2)
            int r2 = r0.mSubId
            boolean r2 = android.telephony.SubscriptionManager.isValidSubscriptionId(r2)
            if (r2 != 0) goto L_0x0037
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "cannot setNotification on invalid subid mSubId="
            r1.append(r2)
            int r2 = r0.mSubId
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            r0.loge(r1)
            return
        L_0x0037:
            com.android.internal.telephony.GsmCdmaPhone r2 = r0.mPhone
            android.content.Context r2 = r2.getContext()
            com.android.internal.telephony.SubscriptionController r3 = r0.mSubscriptionController
            com.android.internal.telephony.GsmCdmaPhone r4 = r0.mPhone
            int r4 = r4.getSubId()
            java.lang.String r5 = r2.getOpPackageName()
            java.lang.String r6 = r2.getAttributionTag()
            android.telephony.SubscriptionInfo r3 = r3.getActiveSubscriptionInfo(r4, r5, r6)
            if (r3 == 0) goto L_0x0256
            boolean r4 = r3.isOpportunistic()
            if (r4 == 0) goto L_0x0061
            android.os.ParcelUuid r3 = r3.getGroupUuid()
            if (r3 == 0) goto L_0x0061
            goto L_0x0256
        L_0x0061:
            android.content.res.Resources r3 = r2.getResources()
            r4 = 17891828(0x11101f4, float:2.6633695E-38)
            boolean r3 = r3.getBoolean(r4)
            if (r3 != 0) goto L_0x0074
            java.lang.String r1 = "Ignore all the notifications"
            r0.log(r1)
            return
        L_0x0074:
            android.os.PersistableBundle r3 = r16.getCarrierConfig()
            java.lang.String r4 = "disable_voice_barring_notification_bool"
            r5 = 0
            boolean r4 = r3.getBoolean(r4, r5)
            r6 = 1005(0x3ed, float:1.408E-42)
            r7 = 1006(0x3ee, float:1.41E-42)
            if (r4 == 0) goto L_0x0093
            r4 = 1003(0x3eb, float:1.406E-42)
            if (r1 == r4) goto L_0x008d
            if (r1 == r6) goto L_0x008d
            if (r1 != r7) goto L_0x0093
        L_0x008d:
            java.lang.String r1 = "Voice/emergency call barred notification disabled"
            r0.log(r1)
            return
        L_0x0093:
            java.lang.String r4 = "carrier_auto_cancel_cs_notification"
            boolean r3 = r3.getBoolean(r4, r5)
            com.android.internal.telephony.GsmCdmaPhone r9 = r0.mPhone
            android.content.Context r9 = r9.getContext()
            java.lang.String r10 = "phone"
            java.lang.Object r9 = r9.getSystemService(r10)
            android.telephony.TelephonyManager r9 = (android.telephony.TelephonyManager) r9
            int r9 = r9.getPhoneCount()
            r10 = 1
            if (r9 <= r10) goto L_0x00b0
            r9 = r10
            goto L_0x00b1
        L_0x00b0:
            r9 = r5
        L_0x00b1:
            com.android.internal.telephony.SubscriptionController r11 = r0.mSubscriptionController
            int r12 = r0.mSubId
            int r11 = r11.getSlotIndex(r12)
            int r11 = r11 + r10
            r12 = 2002(0x7d2, float:2.805E-42)
            r14 = 2001(0x7d1, float:2.804E-42)
            java.lang.String r15 = ""
            r4 = 17039565(0x10400cd, float:2.4245146E-38)
            r8 = 17039564(0x10400cc, float:2.4245143E-38)
            if (r1 == r6) goto L_0x017b
            if (r1 == r7) goto L_0x015e
            if (r1 == r14) goto L_0x0122
            switch(r1) {
                case 1001: goto L_0x00f6;
                case 1002: goto L_0x00f2;
                case 1003: goto L_0x00d7;
                default: goto L_0x00cf;
            }
        L_0x00cf:
            r3 = r15
        L_0x00d0:
            r4 = 999(0x3e7, float:1.4E-42)
        L_0x00d2:
            r8 = 17301642(0x108008a, float:2.4979642E-38)
            goto L_0x0198
        L_0x00d7:
            r3 = 17039560(0x10400c8, float:2.4245132E-38)
            java.lang.CharSequence r15 = r2.getText(r3)
            if (r9 == 0) goto L_0x00ed
            java.lang.Object[] r3 = new java.lang.Object[r10]
            java.lang.Integer r6 = java.lang.Integer.valueOf(r11)
            r3[r5] = r6
            java.lang.String r3 = r2.getString(r4, r3)
            goto L_0x00d0
        L_0x00ed:
            java.lang.CharSequence r3 = r2.getText(r8)
            goto L_0x00d0
        L_0x00f2:
            r3 = r15
        L_0x00f3:
            r4 = 888(0x378, float:1.244E-42)
            goto L_0x00d2
        L_0x00f6:
            int r3 = android.telephony.SubscriptionManager.getDefaultDataSubscriptionId()
            long r13 = (long) r3
            com.android.internal.telephony.GsmCdmaPhone r3 = r0.mPhone
            int r3 = r3.getSubId()
            long r6 = (long) r3
            int r3 = (r13 > r6 ? 1 : (r13 == r6 ? 0 : -1))
            if (r3 == 0) goto L_0x0107
            return
        L_0x0107:
            r3 = 17039561(0x10400c9, float:2.4245134E-38)
            java.lang.CharSequence r15 = r2.getText(r3)
            if (r9 == 0) goto L_0x011d
            java.lang.Object[] r3 = new java.lang.Object[r10]
            java.lang.Integer r6 = java.lang.Integer.valueOf(r11)
            r3[r5] = r6
            java.lang.String r3 = r2.getString(r4, r3)
            goto L_0x00f3
        L_0x011d:
            java.lang.CharSequence r3 = r2.getText(r8)
            goto L_0x00f3
        L_0x0122:
            r4 = 111(0x6f, float:1.56E-43)
            int r6 = r0.mRejectCode
            int r6 = r0.selectResourceForRejectCode(r6, r9)
            if (r6 != 0) goto L_0x014d
            if (r3 == 0) goto L_0x0131
            r1 = r12
            r3 = r15
            goto L_0x00d2
        L_0x0131:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "setNotification: mRejectCode="
            r1.append(r2)
            int r2 = r0.mRejectCode
            r1.append(r2)
            java.lang.String r2 = " is not handled."
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            r0.loge(r1)
            return
        L_0x014d:
            r8 = 17303694(0x108088e, float:2.4985393E-38)
            java.lang.Object[] r3 = new java.lang.Object[r10]
            java.lang.Integer r7 = java.lang.Integer.valueOf(r11)
            r3[r5] = r7
            java.lang.String r15 = r2.getString(r6, r3)
            r3 = 0
            goto L_0x0198
        L_0x015e:
            r3 = 17039562(0x10400ca, float:2.4245137E-38)
            java.lang.CharSequence r15 = r2.getText(r3)
            if (r9 == 0) goto L_0x0175
            java.lang.Object[] r3 = new java.lang.Object[r10]
            java.lang.Integer r6 = java.lang.Integer.valueOf(r11)
            r3[r5] = r6
            java.lang.String r3 = r2.getString(r4, r3)
            goto L_0x00d0
        L_0x0175:
            java.lang.CharSequence r3 = r2.getText(r8)
            goto L_0x00d0
        L_0x017b:
            r3 = 17039563(0x10400cb, float:2.424514E-38)
            java.lang.CharSequence r15 = r2.getText(r3)
            if (r9 == 0) goto L_0x0192
            java.lang.Object[] r3 = new java.lang.Object[r10]
            java.lang.Integer r6 = java.lang.Integer.valueOf(r11)
            r3[r5] = r6
            java.lang.String r3 = r2.getString(r4, r3)
            goto L_0x00d0
        L_0x0192:
            java.lang.CharSequence r3 = r2.getText(r8)
            goto L_0x00d0
        L_0x0198:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "setNotification, create notification, notifyType: "
            r6.append(r7)
            r6.append(r1)
            java.lang.String r7 = ", title: "
            r6.append(r7)
            r6.append(r15)
            java.lang.String r7 = ", details: "
            r6.append(r7)
            r6.append(r3)
            java.lang.String r7 = ", subId: "
            r6.append(r7)
            int r7 = r0.mSubId
            r6.append(r7)
            java.lang.String r6 = r6.toString()
            r0.log(r6)
            android.app.Notification$Builder r6 = new android.app.Notification$Builder
            r6.<init>(r2)
            long r13 = java.lang.System.currentTimeMillis()
            android.app.Notification$Builder r6 = r6.setWhen(r13)
            android.app.Notification$Builder r6 = r6.setAutoCancel(r10)
            android.app.Notification$Builder r6 = r6.setSmallIcon(r8)
            android.app.Notification$Builder r6 = r6.setTicker(r15)
            android.content.res.Resources r7 = r2.getResources()
            r8 = 17170460(0x106001c, float:2.4611991E-38)
            int r7 = r7.getColor(r8)
            android.app.Notification$Builder r6 = r6.setColor(r7)
            android.app.Notification$Builder r6 = r6.setContentTitle(r15)
            android.app.Notification$BigTextStyle r7 = new android.app.Notification$BigTextStyle
            r7.<init>()
            android.app.Notification$BigTextStyle r7 = r7.bigText(r3)
            android.app.Notification$Builder r6 = r6.setStyle(r7)
            android.app.Notification$Builder r3 = r6.setContentText(r3)
            java.lang.String r6 = "alert"
            android.app.Notification$Builder r3 = r3.setChannelId(r6)
            android.app.Notification r3 = r3.build()
            r0.mNotification = r3
            java.lang.String r3 = "notification"
            java.lang.Object r2 = r2.getSystemService(r3)
            android.app.NotificationManager r2 = (android.app.NotificationManager) r2
            r3 = 1002(0x3ea, float:1.404E-42)
            if (r1 == r3) goto L_0x024c
            r3 = 1004(0x3ec, float:1.407E-42)
            if (r1 == r3) goto L_0x024c
            if (r1 != r12) goto L_0x0222
            goto L_0x024c
        L_0x0222:
            android.telephony.ServiceState r3 = r0.mSS
            boolean r3 = r3.isEmergencyOnly()
            if (r3 == 0) goto L_0x022f
            r3 = 1006(0x3ee, float:1.41E-42)
            if (r1 != r3) goto L_0x022f
            goto L_0x0233
        L_0x022f:
            r3 = 2001(0x7d1, float:2.804E-42)
            if (r1 != r3) goto L_0x0235
        L_0x0233:
            r5 = r10
            goto L_0x023e
        L_0x0235:
            android.telephony.ServiceState r1 = r0.mSS
            int r1 = r1.getState()
            if (r1 != 0) goto L_0x023e
            goto L_0x0233
        L_0x023e:
            if (r5 == 0) goto L_0x0255
            int r1 = r0.mSubId
            java.lang.String r1 = java.lang.Integer.toString(r1)
            android.app.Notification r0 = r0.mNotification
            r2.notify(r1, r4, r0)
            goto L_0x0255
        L_0x024c:
            int r0 = r0.mSubId
            java.lang.String r0 = java.lang.Integer.toString(r0)
            r2.cancel(r0, r4)
        L_0x0255:
            return
        L_0x0256:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "cannot setNotification on invisible subid mSubId="
            r1.append(r2)
            int r2 = r0.mSubId
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            r0.log(r1)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.setNotification(int):void");
    }

    /* access modifiers changed from: protected */
    public UiccCardApplication getUiccCardApplication() {
        if (this.mPhone.isPhoneTypeGsm()) {
            return this.mUiccController.getUiccCardApplication(this.mPhone.getPhoneId(), 1);
        }
        return this.mUiccController.getUiccCardApplication(this.mPhone.getPhoneId(), 2);
    }

    private void notifyCdmaSubscriptionInfoReady() {
        if (this.mCdmaForSubscriptionInfoReadyRegistrants != null) {
            log("CDMA_SUBSCRIPTION: call notifyRegistrants()");
            this.mCdmaForSubscriptionInfoReadyRegistrants.notifyRegistrants();
        }
    }

    public void registerForDataConnectionAttached(int i, Handler handler, int i2, Object obj) {
        Registrant registrant = new Registrant(handler, i2, obj);
        if (this.mAttachedRegistrants.get(i) == null) {
            this.mAttachedRegistrants.put(i, new RegistrantList());
        }
        this.mAttachedRegistrants.get(i).add(registrant);
        ServiceState serviceState = this.mSS;
        if (serviceState != null) {
            NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, i);
            if (networkRegistrationInfo == null || networkRegistrationInfo.isInService()) {
                registrant.notifyRegistrant();
            }
        }
    }

    public void unregisterForDataConnectionAttached(int i, Handler handler) {
        if (this.mAttachedRegistrants.get(i) != null) {
            this.mAttachedRegistrants.get(i).remove(handler);
        }
    }

    public void registerForDataConnectionDetached(int i, Handler handler, int i2, Object obj) {
        NetworkRegistrationInfo networkRegistrationInfo;
        Registrant registrant = new Registrant(handler, i2, obj);
        if (this.mDetachedRegistrants.get(i) == null) {
            this.mDetachedRegistrants.put(i, new RegistrantList());
        }
        this.mDetachedRegistrants.get(i).add(registrant);
        ServiceState serviceState = this.mSS;
        if (serviceState != null && (networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, i)) != null && !networkRegistrationInfo.isInService()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForDataConnectionDetached(int i, Handler handler) {
        if (this.mDetachedRegistrants.get(i) != null) {
            this.mDetachedRegistrants.get(i).remove(handler);
        }
    }

    public void registerForVoiceRegStateOrRatChanged(Handler handler, int i, Object obj) {
        this.mVoiceRegStateOrRatChangedRegistrants.add(new Registrant(handler, i, obj));
        notifyVoiceRegStateRilRadioTechnologyChanged();
    }

    public void unregisterForVoiceRegStateOrRatChanged(Handler handler) {
        this.mVoiceRegStateOrRatChangedRegistrants.remove(handler);
    }

    public void registerForDataRegStateOrRatChanged(int i, Handler handler, int i2, Object obj) {
        Registrant registrant = new Registrant(handler, i2, obj);
        if (this.mDataRegStateOrRatChangedRegistrants.get(i) == null) {
            this.mDataRegStateOrRatChangedRegistrants.put(i, new RegistrantList());
        }
        this.mDataRegStateOrRatChangedRegistrants.get(i).add(registrant);
        Pair<Integer, Integer> registrationInfo = getRegistrationInfo(i);
        if (registrationInfo != null) {
            registrant.notifyResult(registrationInfo);
        }
    }

    public void unregisterForDataRegStateOrRatChanged(int i, Handler handler) {
        if (this.mDataRegStateOrRatChangedRegistrants.get(i) != null) {
            this.mDataRegStateOrRatChangedRegistrants.get(i).remove(handler);
        }
    }

    public void registerForAirplaneModeChanged(Handler handler, int i, Object obj) {
        this.mAirplaneModeChangedRegistrants.add(handler, i, obj);
    }

    public void unregisterForAirplaneModeChanged(Handler handler) {
        this.mAirplaneModeChangedRegistrants.remove(handler);
    }

    public void registerForNetworkAttached(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mNetworkAttachedRegistrants.add(registrant);
        if (this.mSS.getState() == 0) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForNetworkAttached(Handler handler) {
        this.mNetworkAttachedRegistrants.remove(handler);
    }

    public void registerForNetworkDetached(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mNetworkDetachedRegistrants.add(registrant);
        if (this.mSS.getState() != 0) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForNetworkDetached(Handler handler) {
        this.mNetworkDetachedRegistrants.remove(handler);
    }

    public void registerForPsRestrictedEnabled(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mPsRestrictEnabledRegistrants.add(registrant);
        if (this.mRestrictedState.isPsRestricted()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForPsRestrictedEnabled(Handler handler) {
        this.mPsRestrictEnabledRegistrants.remove(handler);
    }

    public void registerForPsRestrictedDisabled(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mPsRestrictDisabledRegistrants.add(registrant);
        if (this.mRestrictedState.isPsRestricted()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForPsRestrictedDisabled(Handler handler) {
        this.mPsRestrictDisabledRegistrants.remove(handler);
    }

    public void registerForImsCapabilityChanged(Handler handler, int i, Object obj) {
        this.mImsCapabilityChangedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForImsCapabilityChanged(Handler handler) {
        this.mImsCapabilityChangedRegistrants.remove(handler);
    }

    public void registerForServiceStateChanged(Handler handler, int i) {
        this.mServiceStateChangedRegistrants.addUnique(handler, i, (Object) null);
    }

    public void unregisterForServiceStateChanged(Handler handler) {
        this.mServiceStateChangedRegistrants.remove(handler);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:52:0x0138, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void powerOffRadioSafely() {
        /*
            r10 = this;
            monitor-enter(r10)
            boolean r0 = r10.mPendingRadioPowerOffAfterDataOff     // Catch:{ all -> 0x0139 }
            if (r0 != 0) goto L_0x0137
            com.android.internal.telephony.GsmCdmaPhone r0 = r10.mPhone     // Catch:{ all -> 0x0139 }
            boolean r0 = r0.isUsingNewDataStack()     // Catch:{ all -> 0x0139 }
            r1 = 38
            r2 = 49
            r3 = 1
            if (r0 == 0) goto L_0x003a
            boolean r0 = r10.mAnyDataExisting     // Catch:{ all -> 0x0139 }
            if (r0 == 0) goto L_0x002e
            r10.mtkHangupAllCalls()     // Catch:{ all -> 0x0139 }
            java.lang.String r0 = "powerOffRadioSafely: Tear down all data networks."
            r10.log(r0)     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaPhone r0 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.data.DataNetworkController r0 = r0.getDataNetworkController()     // Catch:{ all -> 0x0139 }
            r2 = 3
            r0.tearDownAllDataNetworks(r2)     // Catch:{ all -> 0x0139 }
            long r4 = POWER_OFF_ALL_DATA_NETWORKS_DISCONNECTED_TIMEOUT     // Catch:{ all -> 0x0139 }
            r10.sendEmptyMessageDelayed(r1, r4)     // Catch:{ all -> 0x0139 }
            goto L_0x0036
        L_0x002e:
            java.lang.String r0 = "powerOffRadioSafely: No data is connected."
            r10.log(r0)     // Catch:{ all -> 0x0139 }
            r10.sendEmptyMessage(r2)     // Catch:{ all -> 0x0139 }
        L_0x0036:
            r10.mPendingRadioPowerOffAfterDataOff = r3     // Catch:{ all -> 0x0139 }
            monitor-exit(r10)     // Catch:{ all -> 0x0139 }
            return
        L_0x003a:
            int r0 = android.telephony.SubscriptionManager.getDefaultDataSubscriptionId()     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            boolean r4 = r4.areAllDataDisconnected()     // Catch:{ all -> 0x0139 }
            r5 = 0
            if (r4 == 0) goto L_0x008c
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            int r4 = r4.getSubId()     // Catch:{ all -> 0x0139 }
            if (r0 == r4) goto L_0x0061
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            int r4 = r4.getSubId()     // Catch:{ all -> 0x0139 }
            if (r0 == r4) goto L_0x008c
            com.android.internal.telephony.ProxyController r4 = com.android.internal.telephony.ProxyController.getInstance()     // Catch:{ all -> 0x0139 }
            boolean r4 = r4.areAllDataDisconnected(r0)     // Catch:{ all -> 0x0139 }
            if (r4 == 0) goto L_0x008c
        L_0x0061:
            com.android.internal.telephony.data.AccessNetworksManager r0 = r10.mAccessNetworksManager     // Catch:{ all -> 0x0139 }
            int[] r0 = r0.getAvailableTransports()     // Catch:{ all -> 0x0139 }
            int r1 = r0.length     // Catch:{ all -> 0x0139 }
        L_0x0068:
            if (r5 >= r1) goto L_0x0082
            r2 = r0[r5]     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaPhone r3 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.dataconnection.DcTracker r3 = r3.getDcTracker(r2)     // Catch:{ all -> 0x0139 }
            if (r3 == 0) goto L_0x007f
            com.android.internal.telephony.GsmCdmaPhone r3 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.dataconnection.DcTracker r2 = r3.getDcTracker(r2)     // Catch:{ all -> 0x0139 }
            java.lang.String r3 = "radioTurnedOff"
            r2.cleanUpAllConnections(r3)     // Catch:{ all -> 0x0139 }
        L_0x007f:
            int r5 = r5 + 1
            goto L_0x0068
        L_0x0082:
            java.lang.String r0 = "powerOffRadioSafely: Data disconnected, turn off radio now."
            r10.log(r0)     // Catch:{ all -> 0x0139 }
            r10.hangupAndPowerOff()     // Catch:{ all -> 0x0139 }
            goto L_0x0137
        L_0x008c:
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            boolean r4 = r4.isPhoneTypeGsm()     // Catch:{ all -> 0x0139 }
            if (r4 == 0) goto L_0x00b7
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            boolean r4 = r4.isInCall()     // Catch:{ all -> 0x0139 }
            if (r4 == 0) goto L_0x00b7
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaCallTracker r4 = r4.mCT     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaCall r4 = r4.mRingingCall     // Catch:{ all -> 0x0139 }
            r4.hangupIfAlive()     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaCallTracker r4 = r4.mCT     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaCall r4 = r4.mBackgroundCall     // Catch:{ all -> 0x0139 }
            r4.hangupIfAlive()     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaCallTracker r4 = r4.mCT     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaCall r4 = r4.mForegroundCall     // Catch:{ all -> 0x0139 }
            r4.hangupIfAlive()     // Catch:{ all -> 0x0139 }
        L_0x00b7:
            r10.mtkHangupAllImsCall()     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.data.AccessNetworksManager r4 = r10.mAccessNetworksManager     // Catch:{ all -> 0x0139 }
            int[] r4 = r4.getAvailableTransports()     // Catch:{ all -> 0x0139 }
            int r6 = r4.length     // Catch:{ all -> 0x0139 }
            r7 = r5
        L_0x00c2:
            if (r7 >= r6) goto L_0x00dc
            r8 = r4[r7]     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.GsmCdmaPhone r9 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.dataconnection.DcTracker r9 = r9.getDcTracker(r8)     // Catch:{ all -> 0x0139 }
            if (r9 == 0) goto L_0x00d9
            com.android.internal.telephony.GsmCdmaPhone r9 = r10.mPhone     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.dataconnection.DcTracker r8 = r9.getDcTracker(r8)     // Catch:{ all -> 0x0139 }
            java.lang.String r9 = "radioTurnedOff"
            r8.cleanUpAllConnections(r9)     // Catch:{ all -> 0x0139 }
        L_0x00d9:
            int r7 = r7 + 1
            goto L_0x00c2
        L_0x00dc:
            com.android.internal.telephony.GsmCdmaPhone r4 = r10.mPhone     // Catch:{ all -> 0x0139 }
            int r4 = r4.getSubId()     // Catch:{ all -> 0x0139 }
            if (r0 == r4) goto L_0x0110
            com.android.internal.telephony.ProxyController r4 = com.android.internal.telephony.ProxyController.getInstance()     // Catch:{ all -> 0x0139 }
            boolean r4 = r4.areAllDataDisconnected(r0)     // Catch:{ all -> 0x0139 }
            if (r4 != 0) goto L_0x0110
            java.lang.String r4 = "powerOffRadioSafely: Data is active on DDS (%d). Wait for all data disconnect"
            java.lang.Object[] r6 = new java.lang.Object[r3]     // Catch:{ all -> 0x0139 }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r0)     // Catch:{ all -> 0x0139 }
            r6[r5] = r7     // Catch:{ all -> 0x0139 }
            java.lang.String r4 = java.lang.String.format(r4, r6)     // Catch:{ all -> 0x0139 }
            r10.log(r4)     // Catch:{ all -> 0x0139 }
            com.android.internal.telephony.ProxyController r4 = com.android.internal.telephony.ProxyController.getInstance()     // Catch:{ all -> 0x0139 }
            r4.registerForAllDataDisconnected(r0, r10, r2)     // Catch:{ all -> 0x0139 }
            r10.mPendingRadioPowerOffAfterDataOff = r3     // Catch:{ all -> 0x0139 }
            boolean r0 = r10.mtkPowerOffNonDdsPhone()     // Catch:{ all -> 0x0139 }
            if (r0 == 0) goto L_0x0110
            monitor-exit(r10)     // Catch:{ all -> 0x0139 }
            return
        L_0x0110:
            android.os.Message r0 = android.os.Message.obtain(r10)     // Catch:{ all -> 0x0139 }
            r0.what = r1     // Catch:{ all -> 0x0139 }
            int r1 = r10.mPendingRadioPowerOffAfterDataOffTag     // Catch:{ all -> 0x0139 }
            int r1 = r1 + r3
            r10.mPendingRadioPowerOffAfterDataOffTag = r1     // Catch:{ all -> 0x0139 }
            r0.arg1 = r1     // Catch:{ all -> 0x0139 }
            r1 = 30000(0x7530, double:1.4822E-319)
            boolean r0 = r10.sendMessageDelayed(r0, r1)     // Catch:{ all -> 0x0139 }
            if (r0 == 0) goto L_0x012d
            java.lang.String r0 = "powerOffRadioSafely: Wait up to 30s for data to isconnect, then turn off radio."
            r10.log(r0)     // Catch:{ all -> 0x0139 }
            r10.mPendingRadioPowerOffAfterDataOff = r3     // Catch:{ all -> 0x0139 }
            goto L_0x0137
        L_0x012d:
            java.lang.String r0 = "powerOffRadioSafely: Cannot send delayed Msg, turn off radio right away."
            r10.log(r0)     // Catch:{ all -> 0x0139 }
            r10.hangupAndPowerOff()     // Catch:{ all -> 0x0139 }
            r10.mPendingRadioPowerOffAfterDataOff = r5     // Catch:{ all -> 0x0139 }
        L_0x0137:
            monitor-exit(r10)     // Catch:{ all -> 0x0139 }
            return
        L_0x0139:
            r0 = move-exception
            monitor-exit(r10)     // Catch:{ all -> 0x0139 }
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.powerOffRadioSafely():void");
    }

    public boolean processPendingRadioPowerOffAfterDataOff() {
        synchronized (this) {
            if (!this.mPendingRadioPowerOffAfterDataOff) {
                return false;
            }
            log("Process pending request to turn radio off.");
            hangupAndPowerOff();
            this.mPendingRadioPowerOffAfterDataOffTag++;
            this.mPendingRadioPowerOffAfterDataOff = false;
            return true;
        }
    }

    private void onCarrierConfigChanged() {
        PersistableBundle carrierConfig = getCarrierConfig();
        log("CarrierConfigChange " + carrierConfig);
        EriManager eriManager = this.mEriManager;
        if (eriManager != null) {
            eriManager.loadEriFile();
            this.mCdnr.updateEfForEri(getOperatorNameFromEri());
        }
        updateOperatorNamePattern(carrierConfig);
        this.mCdnr.updateEfFromCarrierConfig(carrierConfig);
        this.mPhone.notifyCallForwardingIndicator();
        pollStateInternal(false);
    }

    /* access modifiers changed from: protected */
    public void hangupAndPowerOff() {
        if (this.mCi.getRadioState() != 0) {
            if (!this.mPhone.isPhoneTypeGsm() || this.mPhone.isInCall()) {
                this.mPhone.mCT.mRingingCall.hangupIfAlive();
                this.mPhone.mCT.mBackgroundCall.hangupIfAlive();
                this.mPhone.mCT.mForegroundCall.hangupIfAlive();
            }
            this.mCi.setRadioPower(false, obtainMessage(54));
        }
    }

    /* access modifiers changed from: protected */
    public void cancelPollState() {
        this.mPollingContext = new int[1];
    }

    private boolean networkCountryIsoChanged(String str, String str2) {
        if (TextUtils.isEmpty(str)) {
            log("countryIsoChanged: no new country ISO code");
            return false;
        } else if (!TextUtils.isEmpty(str2)) {
            return !str.equals(str2);
        } else {
            log("countryIsoChanged: no previous country ISO code");
            return true;
        }
    }

    private boolean iccCardExists() {
        UiccCardApplication uiccCardApplication = this.mUiccApplcation;
        if (uiccCardApplication == null || uiccCardApplication.getState() == IccCardApplicationStatus.AppState.APPSTATE_UNKNOWN) {
            return false;
        }
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getSystemProperty(String str, String str2) {
        return TelephonyManager.getTelephonyProperty(this.mPhone.getPhoneId(), str, str2);
    }

    public List<CellInfo> getAllCellInfo() {
        return this.mLastCellInfoList;
    }

    public void setCellInfoMinInterval(int i) {
        this.mCellInfoMinIntervalMs = i;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:12:0x0025, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:18:0x0046, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void requestAllCellInfo(android.os.WorkSource r8, android.os.Message r9) {
        /*
            r7 = this;
            com.android.internal.telephony.CommandsInterface r0 = r7.mCi
            int r0 = r0.getRilVersion()
            r1 = 8
            if (r0 >= r1) goto L_0x0016
            android.os.AsyncResult.forMessage(r9)
            r9.sendToTarget()
            java.lang.String r8 = "SST.requestAllCellInfo(): not implemented"
            r7.log(r8)
            return
        L_0x0016:
            java.util.List<android.os.Message> r0 = r7.mPendingCellInfoRequests
            monitor-enter(r0)
            boolean r1 = r7.mIsPendingCellInfoRequest     // Catch:{ all -> 0x0069 }
            if (r1 == 0) goto L_0x0026
            if (r9 == 0) goto L_0x0024
            java.util.List<android.os.Message> r7 = r7.mPendingCellInfoRequests     // Catch:{ all -> 0x0069 }
            r7.add(r9)     // Catch:{ all -> 0x0069 }
        L_0x0024:
            monitor-exit(r0)     // Catch:{ all -> 0x0069 }
            return
        L_0x0026:
            long r1 = android.os.SystemClock.elapsedRealtime()     // Catch:{ all -> 0x0069 }
            long r3 = r7.mLastCellInfoReqTime     // Catch:{ all -> 0x0069 }
            long r3 = r1 - r3
            int r5 = r7.mCellInfoMinIntervalMs     // Catch:{ all -> 0x0069 }
            long r5 = (long) r5     // Catch:{ all -> 0x0069 }
            int r3 = (r3 > r5 ? 1 : (r3 == r5 ? 0 : -1))
            if (r3 >= 0) goto L_0x0047
            if (r9 == 0) goto L_0x0045
            java.lang.String r8 = "SST.requestAllCellInfo(): return last, back to back calls"
            r7.log(r8)     // Catch:{ all -> 0x0069 }
            java.util.List<android.telephony.CellInfo> r7 = r7.mLastCellInfoList     // Catch:{ all -> 0x0069 }
            r8 = 0
            android.os.AsyncResult.forMessage(r9, r7, r8)     // Catch:{ all -> 0x0069 }
            r9.sendToTarget()     // Catch:{ all -> 0x0069 }
        L_0x0045:
            monitor-exit(r0)     // Catch:{ all -> 0x0069 }
            return
        L_0x0047:
            if (r9 == 0) goto L_0x004e
            java.util.List<android.os.Message> r3 = r7.mPendingCellInfoRequests     // Catch:{ all -> 0x0069 }
            r3.add(r9)     // Catch:{ all -> 0x0069 }
        L_0x004e:
            r7.mLastCellInfoReqTime = r1     // Catch:{ all -> 0x0069 }
            r9 = 1
            r7.mIsPendingCellInfoRequest = r9     // Catch:{ all -> 0x0069 }
            r9 = 43
            android.os.Message r1 = r7.obtainMessage(r9)     // Catch:{ all -> 0x0069 }
            com.android.internal.telephony.CommandsInterface r2 = r7.mCi     // Catch:{ all -> 0x0069 }
            r2.getCellInfoList(r1, r8)     // Catch:{ all -> 0x0069 }
            android.os.Message r8 = r7.obtainMessage(r9)     // Catch:{ all -> 0x0069 }
            r1 = 2000(0x7d0, double:9.88E-321)
            r7.sendMessageDelayed(r8, r1)     // Catch:{ all -> 0x0069 }
            monitor-exit(r0)     // Catch:{ all -> 0x0069 }
            return
        L_0x0069:
            r7 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0069 }
            throw r7
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ServiceStateTracker.requestAllCellInfo(android.os.WorkSource, android.os.Message):void");
    }

    public void registerForSubscriptionInfoReady(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mCdmaForSubscriptionInfoReadyRegistrants.add(registrant);
        if (isMinInfoReady()) {
            registrant.notifyRegistrant();
        }
    }

    public void unregisterForSubscriptionInfoReady(Handler handler) {
        this.mCdmaForSubscriptionInfoReadyRegistrants.remove(handler);
    }

    private void saveCdmaSubscriptionSource(int i) {
        log("Storing cdma subscription source: " + i);
        Settings.Global.putInt(this.mPhone.getContext().getContentResolver(), "subscription_mode", i);
        log("Read from settings: " + Settings.Global.getInt(this.mPhone.getContext().getContentResolver(), "subscription_mode", -1));
    }

    /* access modifiers changed from: protected */
    public void getSubscriptionInfoAndStartPollingThreads() {
        this.mCi.getCDMASubscription(obtainMessage(34));
        pollStateInternal(false);
    }

    /* access modifiers changed from: protected */
    public void handleCdmaSubscriptionSource(int i) {
        log("Subscription Source : " + i);
        this.mIsSubscriptionFromRuim = i == 0;
        log("isFromRuim: " + this.mIsSubscriptionFromRuim);
        saveCdmaSubscriptionSource(i);
        if (!this.mIsSubscriptionFromRuim) {
            sendMessage(obtainMessage(35));
        }
    }

    public void onTelecomVoiceServiceStateOverrideChanged() {
        sendMessage(obtainMessage(65));
    }

    private void dumpCellInfoList(PrintWriter printWriter) {
        printWriter.print(" mLastCellInfoList={");
        List<CellInfo> list = this.mLastCellInfoList;
        if (list != null) {
            boolean z = true;
            for (CellInfo next : list) {
                if (!z) {
                    printWriter.print(",");
                }
                z = false;
                printWriter.print(next.toString());
            }
        }
        printWriter.println("}");
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("ServiceStateTracker:");
        printWriter.println(" mSubId=" + this.mSubId);
        printWriter.println(" mSS=" + this.mSS);
        printWriter.println(" mNewSS=" + this.mNewSS);
        printWriter.println(" mVoiceCapable=" + this.mVoiceCapable);
        printWriter.println(" mRestrictedState=" + this.mRestrictedState);
        StringBuilder sb = new StringBuilder();
        sb.append(" mPollingContext=");
        sb.append(this.mPollingContext);
        sb.append(" - ");
        int[] iArr = this.mPollingContext;
        sb.append(iArr != null ? Integer.valueOf(iArr[0]) : "");
        printWriter.println(sb.toString());
        printWriter.println(" mDesiredPowerState=" + this.mDesiredPowerState);
        printWriter.println(" mRestrictedState=" + this.mRestrictedState);
        printWriter.println(" mPendingRadioPowerOffAfterDataOff=" + this.mPendingRadioPowerOffAfterDataOff);
        printWriter.println(" mPendingRadioPowerOffAfterDataOffTag=" + this.mPendingRadioPowerOffAfterDataOffTag);
        printWriter.println(" mCellIdentity=" + Rlog.pii(false, this.mCellIdentity));
        printWriter.println(" mLastCellInfoReqTime=" + this.mLastCellInfoReqTime);
        dumpCellInfoList(printWriter);
        printWriter.flush();
        printWriter.println(" mAllowedNetworkTypes=" + this.mAllowedNetworkTypes);
        printWriter.println(" mAnyDataExisting=" + this.mAnyDataExisting);
        printWriter.println(" mMaxDataCalls=" + this.mMaxDataCalls);
        printWriter.println(" mNewMaxDataCalls=" + this.mNewMaxDataCalls);
        printWriter.println(" mReasonDataDenied=" + this.mReasonDataDenied);
        printWriter.println(" mNewReasonDataDenied=" + this.mNewReasonDataDenied);
        printWriter.println(" mGsmVoiceRoaming=" + this.mGsmVoiceRoaming);
        printWriter.println(" mGsmDataRoaming=" + this.mGsmDataRoaming);
        printWriter.println(" mEmergencyOnly=" + this.mEmergencyOnly);
        printWriter.println(" mCSEmergencyOnly=" + this.mCSEmergencyOnly);
        printWriter.println(" mPSEmergencyOnly=" + this.mPSEmergencyOnly);
        printWriter.flush();
        this.mNitzState.dumpState(printWriter);
        printWriter.println(" mLastNitzData=" + this.mLastNitzData);
        printWriter.flush();
        printWriter.println(" mStartedGprsRegCheck=" + this.mStartedGprsRegCheck);
        printWriter.println(" mReportedGprsNoReg=" + this.mReportedGprsNoReg);
        printWriter.println(" mNotification=" + this.mNotification);
        printWriter.println(" mCurSpn=" + this.mCurSpn);
        printWriter.println(" mCurDataSpn=" + this.mCurDataSpn);
        printWriter.println(" mCurShowSpn=" + this.mCurShowSpn);
        printWriter.println(" mCurPlmn=" + this.mCurPlmn);
        printWriter.println(" mCurShowPlmn=" + this.mCurShowPlmn);
        printWriter.flush();
        printWriter.println(" mCurrentOtaspMode=" + this.mCurrentOtaspMode);
        printWriter.println(" mRoamingIndicator=" + this.mRoamingIndicator);
        printWriter.println(" mIsInPrl=" + this.mIsInPrl);
        printWriter.println(" mDefaultRoamingIndicator=" + this.mDefaultRoamingIndicator);
        printWriter.println(" mRegistrationState=" + this.mRegistrationState);
        printWriter.println(" mMdn=" + this.mMdn);
        printWriter.println(" mHomeSystemId=" + this.mHomeSystemId);
        printWriter.println(" mHomeNetworkId=" + this.mHomeNetworkId);
        printWriter.println(" mMin=" + this.mMin);
        printWriter.println(" mPrlVersion=" + this.mPrlVersion);
        printWriter.println(" mIsMinInfoReady=" + this.mIsMinInfoReady);
        printWriter.println(" mIsEriTextLoaded=" + this.mIsEriTextLoaded);
        printWriter.println(" mIsSubscriptionFromRuim=" + this.mIsSubscriptionFromRuim);
        printWriter.println(" mCdmaSSM=" + this.mCdmaSSM);
        printWriter.println(" mRegistrationDeniedReason=" + this.mRegistrationDeniedReason);
        printWriter.println(" mCurrentCarrier=" + this.mCurrentCarrier);
        printWriter.flush();
        printWriter.println(" mImsRegistered=" + this.mImsRegistered);
        printWriter.println(" mImsRegistrationOnOff=" + this.mImsRegistrationOnOff);
        printWriter.println(" pending radio off event=" + hasMessages(62));
        printWriter.println(" mRadioDisabledByCarrier" + this.mRadioDisabledByCarrier);
        printWriter.println(" mDeviceShuttingDown=" + this.mDeviceShuttingDown);
        printWriter.println(" mSpnUpdatePending=" + this.mSpnUpdatePending);
        printWriter.println(" mCellInfoMinIntervalMs=" + this.mCellInfoMinIntervalMs);
        printWriter.println(" mEriManager=" + this.mEriManager);
        this.mLocaleTracker.dump(fileDescriptor, printWriter, strArr);
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "    ");
        this.mCdnr.dump(indentingPrintWriter);
        indentingPrintWriter.println(" Carrier Display Name update records:");
        indentingPrintWriter.increaseIndent();
        this.mCdnrLogs.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" Roaming Log:");
        indentingPrintWriter.increaseIndent();
        this.mRoamingLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" Attach Log:");
        indentingPrintWriter.increaseIndent();
        this.mAttachLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" Phone Change Log:");
        indentingPrintWriter.increaseIndent();
        this.mPhoneTypeLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" Rat Change Log:");
        indentingPrintWriter.increaseIndent();
        this.mRatLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println(" Radio power Log:");
        indentingPrintWriter.increaseIndent();
        this.mRadioPowerLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        this.mNitzState.dumpLogs(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.flush();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isImsRegistered() {
        return this.mImsRegistered;
    }

    /* access modifiers changed from: protected */
    public void checkCorrectThread() {
        if (Thread.currentThread() != getLooper().getThread()) {
            throw new RuntimeException("ServiceStateTracker must be used from within one thread");
        }
    }

    /* access modifiers changed from: protected */
    public boolean isCallerOnDifferentThread() {
        return Thread.currentThread() != getLooper().getThread();
    }

    /* access modifiers changed from: protected */
    public boolean inSameCountry(String str) {
        if (!TextUtils.isEmpty(str) && str.length() >= 5) {
            String homeOperatorNumeric = getHomeOperatorNumeric();
            if (!TextUtils.isEmpty(homeOperatorNumeric) && homeOperatorNumeric.length() >= 5) {
                String substring = str.substring(0, 3);
                String substring2 = homeOperatorNumeric.substring(0, 3);
                String countryCodeForMcc = MccTable.countryCodeForMcc(substring);
                String countryCodeForMcc2 = MccTable.countryCodeForMcc(substring2);
                LocaleTracker localeTracker = this.mLocaleTracker;
                if (localeTracker != null && !TextUtils.isEmpty(localeTracker.getCountryOverride())) {
                    log("inSameCountry:  countryOverride var set.  This should only be set for testing purposes to override the device location.");
                    return this.mLocaleTracker.getCountryOverride().equals(countryCodeForMcc2);
                } else if (!countryCodeForMcc.isEmpty() && !countryCodeForMcc2.isEmpty()) {
                    boolean equals = countryCodeForMcc2.equals(countryCodeForMcc);
                    if (equals) {
                        return equals;
                    }
                    if ((!"us".equals(countryCodeForMcc2) || !"vi".equals(countryCodeForMcc)) && (!"vi".equals(countryCodeForMcc2) || !"us".equals(countryCodeForMcc))) {
                        return equals;
                    }
                    return true;
                }
            }
        }
        return false;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setRoamingType(ServiceState serviceState) {
        boolean z = serviceState.getState() == 0;
        if (z) {
            if (!serviceState.getVoiceRoaming()) {
                serviceState.setVoiceRoamingType(0);
            } else if (!this.mPhone.isPhoneTypeGsm()) {
                int[] intArray = this.mPhone.getContext().getResources().getIntArray(17236017);
                if (intArray != null && intArray.length > 0) {
                    serviceState.setVoiceRoamingType(2);
                    int cdmaRoamingIndicator = serviceState.getCdmaRoamingIndicator();
                    int i = 0;
                    while (true) {
                        if (i >= intArray.length) {
                            break;
                        } else if (cdmaRoamingIndicator == intArray[i]) {
                            serviceState.setVoiceRoamingType(3);
                            break;
                        } else {
                            i++;
                        }
                    }
                } else if (inSameCountry(serviceState.getOperatorNumeric())) {
                    serviceState.setVoiceRoamingType(2);
                } else {
                    serviceState.setVoiceRoamingType(3);
                }
            } else if (inSameCountry(serviceState.getOperatorNumeric())) {
                serviceState.setVoiceRoamingType(2);
            } else {
                serviceState.setVoiceRoamingType(3);
            }
        }
        boolean z2 = serviceState.getDataRegistrationState() == 0;
        int rilDataRadioTechnologyForWwan = getRilDataRadioTechnologyForWwan(serviceState);
        if (!z2) {
            return;
        }
        if (!serviceState.getDataRoaming()) {
            serviceState.setDataRoamingType(0);
        } else if (this.mPhone.isPhoneTypeGsm()) {
            if (!ServiceState.isGsm(rilDataRadioTechnologyForWwan)) {
                serviceState.setDataRoamingType(1);
            } else if (z) {
                serviceState.setDataRoamingType(serviceState.getVoiceRoamingType());
            } else {
                serviceState.setDataRoamingType(1);
            }
        } else if (ServiceState.isCdma(rilDataRadioTechnologyForWwan)) {
            if (z) {
                serviceState.setDataRoamingType(serviceState.getVoiceRoamingType());
            } else {
                serviceState.setDataRoamingType(1);
            }
        } else if (inSameCountry(serviceState.getOperatorNumeric())) {
            serviceState.setDataRoamingType(2);
        } else {
            serviceState.setDataRoamingType(3);
        }
    }

    /* access modifiers changed from: protected */
    public String getHomeOperatorNumeric() {
        String simOperatorNumericForPhone = ((TelephonyManager) this.mPhone.getContext().getSystemService("phone")).getSimOperatorNumericForPhone(this.mPhone.getPhoneId());
        return (this.mPhone.isPhoneTypeGsm() || !TextUtils.isEmpty(simOperatorNumericForPhone)) ? simOperatorNumericForPhone : SystemProperties.get(GsmCdmaPhone.PROPERTY_CDMA_HOME_OPERATOR_NUMERIC, "");
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getPhoneId() {
        return this.mPhone.getPhoneId();
    }

    /* access modifiers changed from: protected */
    public void processIwlanRegistrationInfo() {
        NetworkRegistrationInfo networkRegistrationInfo;
        boolean z;
        if (this.mCi.getRadioState() == 0) {
            log("set service state as POWER_OFF");
            if (18 == this.mNewSS.getRilDataRadioTechnology()) {
                log("pollStateDone: mNewSS = " + this.mNewSS);
                log("pollStateDone: reset iwlan RAT value");
                z = true;
            } else {
                z = false;
            }
            String operatorAlphaLong = this.mNewSS.getOperatorAlphaLong();
            this.mNewSS.setOutOfService(this.mAccessNetworksManager.isInLegacyMode(), true);
            if (z) {
                this.mNewSS.setDataRegState(0);
                this.mNewSS.addNetworkRegistrationInfo(new NetworkRegistrationInfo.Builder().setTransportType(2).setDomain(2).setAccessNetworkTechnology(18).setRegistrationState(1).build());
                if (this.mAccessNetworksManager.isInLegacyMode()) {
                    this.mNewSS.addNetworkRegistrationInfo(new NetworkRegistrationInfo.Builder().setTransportType(1).setDomain(2).setAccessNetworkTechnology(18).setRegistrationState(1).build());
                }
                this.mNewSS.setOperatorAlphaLong(operatorAlphaLong);
                this.mNewSS.setIwlanPreferred(true);
                log("pollStateDone: mNewSS = " + this.mNewSS);
            }
        } else if (this.mAccessNetworksManager.isInLegacyMode() && (networkRegistrationInfo = this.mNewSS.getNetworkRegistrationInfo(2, 1)) != null && networkRegistrationInfo.getAccessNetworkTechnology() == 18) {
            this.mNewSS.addNetworkRegistrationInfo(new NetworkRegistrationInfo.Builder().setTransportType(2).setDomain(2).setRegistrationState(networkRegistrationInfo.getRegistrationState()).setAccessNetworkTechnology(18).setRejectCause(networkRegistrationInfo.getRejectCause()).setEmergencyOnly(networkRegistrationInfo.isEmergencyEnabled()).setAvailableServices(networkRegistrationInfo.getAvailableServices()).build());
        }
    }

    /* access modifiers changed from: protected */
    public final boolean alwaysOnHomeNetwork(BaseBundle baseBundle) {
        return baseBundle.getBoolean("force_home_network_bool");
    }

    private boolean isInNetwork(BaseBundle baseBundle, String str, String str2) {
        String[] stringArray = baseBundle.getStringArray(str2);
        return stringArray != null && Arrays.asList(stringArray).contains(str);
    }

    /* access modifiers changed from: protected */
    public final boolean isRoamingInGsmNetwork(BaseBundle baseBundle, String str) {
        return isInNetwork(baseBundle, str, "gsm_roaming_networks_string_array");
    }

    /* access modifiers changed from: protected */
    public final boolean isNonRoamingInGsmNetwork(BaseBundle baseBundle, String str) {
        return isInNetwork(baseBundle, str, "gsm_nonroaming_networks_string_array");
    }

    /* access modifiers changed from: protected */
    public final boolean isRoamingInCdmaNetwork(BaseBundle baseBundle, String str) {
        return isInNetwork(baseBundle, str, "cdma_roaming_networks_string_array");
    }

    /* access modifiers changed from: protected */
    public final boolean isNonRoamingInCdmaNetwork(BaseBundle baseBundle, String str) {
        return isInNetwork(baseBundle, str, "cdma_nonroaming_networks_string_array");
    }

    public boolean isDeviceShuttingDown() {
        return this.mDeviceShuttingDown;
    }

    public int getCombinedRegState(ServiceState serviceState) {
        int state = serviceState.getState();
        int dataRegistrationState = serviceState.getDataRegistrationState();
        if ((state != 1 && state != 3) || dataRegistrationState != 0) {
            return state;
        }
        if (serviceState.getDataNetworkType() != 18) {
            log("getCombinedRegState: return STATE_IN_SERVICE as Data is in service");
        } else if (this.mPhone.getImsPhone() == null || !this.mPhone.getImsPhone().isWifiCallingEnabled()) {
            return state;
        } else {
            log("getCombinedRegState: return STATE_IN_SERVICE for IWLAN as Data is in service and WFC is enabled");
        }
        return dataRegistrationState;
    }

    /* access modifiers changed from: protected */
    public PersistableBundle getCarrierConfig() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            return CarrierConfigManager.getDefaultConfig();
        }
        return configForSubId;
    }

    public LocaleTracker getLocaleTracker() {
        return this.mLocaleTracker;
    }

    /* access modifiers changed from: package-private */
    public String getCdmaEriText(int i, int i2) {
        EriManager eriManager = this.mEriManager;
        return eriManager != null ? eriManager.getCdmaEriText(i, i2) : "no ERI";
    }

    private void updateOperatorNamePattern(PersistableBundle persistableBundle) {
        String string = persistableBundle.getString("operator_name_filter_pattern_string");
        if (!TextUtils.isEmpty(string)) {
            this.mOperatorNameStringPattern = Pattern.compile(string);
            log("mOperatorNameStringPattern: " + this.mOperatorNameStringPattern.toString());
        }
    }

    /* access modifiers changed from: protected */
    public void updateOperatorNameForServiceState(ServiceState serviceState) {
        if (serviceState != null) {
            serviceState.setOperatorName(filterOperatorNameByPattern(serviceState.getOperatorAlphaLong()), filterOperatorNameByPattern(serviceState.getOperatorAlphaShort()), serviceState.getOperatorNumeric());
            List networkRegistrationInfoList = serviceState.getNetworkRegistrationInfoList();
            for (int i = 0; i < networkRegistrationInfoList.size(); i++) {
                if (networkRegistrationInfoList.get(i) != null) {
                    updateOperatorNameForCellIdentity(((NetworkRegistrationInfo) networkRegistrationInfoList.get(i)).getCellIdentity());
                    serviceState.addNetworkRegistrationInfo((NetworkRegistrationInfo) networkRegistrationInfoList.get(i));
                }
            }
        }
    }

    private void updateOperatorNameForCellIdentity(CellIdentity cellIdentity) {
        if (cellIdentity != null) {
            cellIdentity.setOperatorAlphaLong(filterOperatorNameByPattern((String) cellIdentity.getOperatorAlphaLong()));
            cellIdentity.setOperatorAlphaShort(filterOperatorNameByPattern((String) cellIdentity.getOperatorAlphaShort()));
        }
    }

    public void updateOperatorNameForCellInfo(List<CellInfo> list) {
        if (list != null && !list.isEmpty()) {
            for (CellInfo next : list) {
                if (next.isRegistered()) {
                    updateOperatorNameForCellIdentity(next.getCellIdentity());
                }
            }
        }
    }

    public String filterOperatorNameByPattern(String str) {
        if (this.mOperatorNameStringPattern == null || TextUtils.isEmpty(str)) {
            return str;
        }
        Matcher matcher = this.mOperatorNameStringPattern.matcher(str);
        if (!matcher.find()) {
            return str;
        }
        if (matcher.groupCount() > 0) {
            return matcher.group(1);
        }
        log("filterOperatorNameByPattern: pattern no group");
        return str;
    }

    protected static int getRilDataRadioTechnologyForWwan(ServiceState serviceState) {
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, 1);
        return ServiceState.networkTypeToRilRadioTechnology(networkRegistrationInfo != null ? networkRegistrationInfo.getAccessNetworkTechnology() : 0);
    }

    public void registerForNrStateChanged(Handler handler, int i, Object obj) {
        this.mNrStateChangedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForNrStateChanged(Handler handler) {
        this.mNrStateChangedRegistrants.remove(handler);
    }

    public void registerForNrFrequencyChanged(Handler handler, int i, Object obj) {
        this.mNrFrequencyChangedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForNrFrequencyChanged(Handler handler) {
        this.mNrFrequencyChangedRegistrants.remove(handler);
    }

    public void registerForCssIndicatorChanged(Handler handler, int i, Object obj) {
        this.mCssIndicatorChangedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForCssIndicatorChanged(Handler handler) {
        this.mCssIndicatorChangedRegistrants.remove(handler);
    }

    public void registerForBandwidthChanged(Handler handler, int i, Object obj) {
        this.mBandwidthChangedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForBandwidthChanged(Handler handler) {
        this.mBandwidthChangedRegistrants.remove(handler);
    }

    public Set<Integer> getNrContextIds() {
        HashSet hashSet = new HashSet();
        if (!ArrayUtils.isEmpty(this.mLastPhysicalChannelConfigList)) {
            for (PhysicalChannelConfig next : this.mLastPhysicalChannelConfigList) {
                if (isNrPhysicalChannelConfig(next)) {
                    for (int valueOf : next.getContextIds()) {
                        hashSet.add(Integer.valueOf(valueOf));
                    }
                }
            }
        }
        return hashSet;
    }

    /* access modifiers changed from: protected */
    public void setDataNetworkTypeForPhone(int i) {
        if (!this.mPhone.getUnitTestMode()) {
            ((TelephonyManager) this.mPhone.getContext().getSystemService("phone")).setDataNetworkTypeForPhone(this.mPhone.getPhoneId(), i);
        }
    }

    public ServiceStateStats getServiceStateStats() {
        return this.mServiceStateStats;
    }

    @VisibleForTesting
    public void setServiceStateStats(ServiceStateStats serviceStateStats) {
        this.mServiceStateStats = serviceStateStats;
    }

    /* access modifiers changed from: protected */
    public ContentValues getContentValuesForServiceState(ServiceState serviceState) {
        ContentValues contentValues = new ContentValues();
        Parcel obtain = Parcel.obtain();
        serviceState.writeToParcel(obtain, 0);
        contentValues.put(SERVICE_STATE, obtain.marshall());
        return contentValues;
    }

    public void registerForAreaCodeChanged(Handler handler, int i, Object obj) {
        this.mAreaCodeChangedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForAreaCodeChanged(Handler handler) {
        this.mAreaCodeChangedRegistrants.remove(handler);
    }

    public CellIdentity getLastKnownCellIdentity() {
        return this.mLastKnownCellIdentity;
    }
}
