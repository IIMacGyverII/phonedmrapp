package com.android.internal.telephony;

import android.app.BroadcastOptions;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.os.WorkSource;
import android.preference.PreferenceManager;
import android.telephony.CarrierConfigManager;
import android.telephony.CarrierRestrictionRules;
import android.telephony.CellIdentity;
import android.telephony.CellInfo;
import android.telephony.ClientRequestStats;
import android.telephony.ImsiEncryptionInfo;
import android.telephony.LinkCapacityEstimate;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.PhysicalChannelConfig;
import android.telephony.PreciseDataConnectionState;
import android.telephony.RadioAccessFamily;
import android.telephony.RadioAccessSpecifier;
import android.telephony.ServiceState;
import android.telephony.SignalStrength;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyDisplayInfo;
import android.telephony.TelephonyManager;
import android.telephony.emergency.EmergencyNumber;
import android.text.TextUtils;
import android.util.Log;
import android.util.SparseArray;
import android.util.Xml;
import androidx.core.os.EnvironmentCompat;
import com.android.ims.ImsCall;
import com.android.ims.ImsException;
import com.android.ims.ImsManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.data.AccessNetworksManager;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.data.DataSettingsManager;
import com.android.internal.telephony.data.LinkBandwidthEstimator;
import com.android.internal.telephony.dataconnection.DataConnectionReasons;
import com.android.internal.telephony.dataconnection.DataEnabledSettings;
import com.android.internal.telephony.dataconnection.DcTracker;
import com.android.internal.telephony.dataconnection.TransportManager;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.imsphone.ImsPhone;
import com.android.internal.telephony.imsphone.ImsPhoneCall;
import com.android.internal.telephony.metrics.SmsStats;
import com.android.internal.telephony.metrics.VoiceCallSessionStats;
import com.android.internal.telephony.test.SimulatedRadioControl;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccFileHandler;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.IsimRecords;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.UsimServiceTable;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.internal.util.XmlUtils;
import com.android.telephony.Rlog;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Consumer;
import java.util.stream.Collectors;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public abstract class Phone extends Handler implements PhoneInternalInterface {
    private static final String ALLOWED_NETWORK_TYPES_TEXT_CARRIER = "carrier";
    private static final String ALLOWED_NETWORK_TYPES_TEXT_ENABLE_2G = "enable_2g";
    private static final String ALLOWED_NETWORK_TYPES_TEXT_POWER = "power";
    private static final String ALLOWED_NETWORK_TYPES_TEXT_USER = "user";
    private static final int ALREADY_IN_AUTO_SELECTION = 1;
    private static final String ATTR_MCC = "mcc";
    private static final String ATTR_MNC = "mnc";
    private static final String CDMA_NON_ROAMING_LIST_OVERRIDE_PREFIX = "cdma_non_roaming_list_";
    private static final String CDMA_ROAMING_LIST_OVERRIDE_PREFIX = "cdma_roaming_list_";
    public static final String CF_ID = "cf_id_key";
    public static final String CF_STATUS = "cf_status_key";
    public static final String CLIR_KEY = "clir_sub_key";
    public static final String CS_FALLBACK = "cs_fallback";
    public static final String CS_FALLBACK_SS = "cs_fallback_ss";
    public static final String DATA_DISABLED_ON_BOOT_KEY = "disabled_on_boot_key";
    public static final String DATA_ROAMING_IS_USER_SETTING_KEY = "data_roaming_is_user_setting_key";
    private static final int DEFAULT_REPORT_INTERVAL_MS = 200;
    private static final String DNS_SERVER_CHECK_DISABLED_KEY = "dns_server_check_disabled_key";
    private static final int EMERGENCY_SMS_NO_TIME_RECORDED = -1;
    private static final int EMERGENCY_SMS_TIMER_MAX_MS = 300000;
    private static final int EVENT_ALL_DATA_DISCONNECTED = 52;
    protected static final int EVENT_BARRING_INFO_CHANGED = 58;
    protected static final int EVENT_CALL_RING = 14;
    private static final int EVENT_CALL_RING_CONTINUE = 15;
    protected static final int EVENT_CARRIER_CONFIG_CHANGED = 43;
    protected static final int EVENT_CDMA_SUBSCRIPTION_SOURCE_CHANGED = 27;
    private static final int EVENT_CHECK_FOR_NETWORK_AUTOMATIC = 38;
    private static final int EVENT_CONFIG_LCE = 37;
    protected static final int EVENT_DEVICE_PROVISIONED_CHANGE = 49;
    protected static final int EVENT_DEVICE_PROVISIONING_DATA_SETTING_CHANGE = 50;
    @VisibleForTesting
    public static final int EVENT_EMERGENCY_CALLBACK_MODE_ENTER = 25;
    protected static final int EVENT_EXIT_EMERGENCY_CALLBACK_RESPONSE = 26;
    protected static final int EVENT_GET_AVAILABLE_NETWORKS_DONE = 51;
    protected static final int EVENT_GET_BASEBAND_VERSION_DONE = 6;
    protected static final int EVENT_GET_CALL_FORWARD_DONE = 13;
    protected static final int EVENT_GET_DEVICE_IDENTITY_DONE = 21;
    protected static final int EVENT_GET_RADIO_CAPABILITY = 35;
    private static final int EVENT_GET_SIM_STATUS_DONE = 11;
    protected static final int EVENT_GET_UICC_APPS_ENABLEMENT_DONE = 55;
    protected static final int EVENT_GET_USAGE_SETTING_DONE = 63;
    @VisibleForTesting
    protected static final int EVENT_ICC_CHANGED = 30;
    protected static final int EVENT_ICC_RECORD_EVENTS = 29;
    private static final int EVENT_INITIATE_SILENT_REDIAL = 32;
    protected static final int EVENT_LAST = 64;
    protected static final int EVENT_LINK_CAPACITY_CHANGED = 59;
    private static final int EVENT_MMI_DONE = 4;
    protected static final int EVENT_MODEM_RESET = 45;
    protected static final int EVENT_NV_READY = 23;
    protected static final int EVENT_RADIO_AVAILABLE = 1;
    private static final int EVENT_RADIO_NOT_AVAILABLE = 33;
    protected static final int EVENT_RADIO_OFF_OR_NOT_AVAILABLE = 8;
    protected static final int EVENT_RADIO_ON = 5;
    protected static final int EVENT_RADIO_STATE_CHANGED = 47;
    protected static final int EVENT_REAPPLY_UICC_APPS_ENABLEMENT_DONE = 56;
    protected static final int EVENT_REGISTERED_TO_NETWORK = 19;
    protected static final int EVENT_REGISTRATION_FAILED = 57;
    protected static final int EVENT_REQUEST_VOICE_RADIO_TECH_DONE = 40;
    protected static final int EVENT_RESET_CARRIER_KEY_IMSI_ENCRYPTION = 60;
    protected static final int EVENT_RIL_CONNECTED = 41;
    protected static final int EVENT_RUIM_RECORDS_LOADED = 22;
    protected static final int EVENT_SET_CALL_FORWARD_DONE = 12;
    protected static final int EVENT_SET_CARRIER_DATA_ENABLED = 48;
    protected static final int EVENT_SET_CLIR_COMPLETE = 18;
    private static final int EVENT_SET_ENHANCED_VP = 24;
    protected static final int EVENT_SET_NETWORK_AUTOMATIC = 28;
    protected static final int EVENT_SET_NETWORK_AUTOMATIC_COMPLETE = 17;
    protected static final int EVENT_SET_NETWORK_MANUAL_COMPLETE = 16;
    protected static final int EVENT_SET_ROAMING_PREFERENCE_DONE = 44;
    protected static final int EVENT_SET_USAGE_SETTING_DONE = 64;
    protected static final int EVENT_SET_VM_NUMBER_DONE = 20;
    protected static final int EVENT_SET_VONR_ENABLED_DONE = 61;
    protected static final int EVENT_SIM_RECORDS_LOADED = 3;
    @VisibleForTesting
    protected static final int EVENT_SRVCC_STATE_CHANGED = 31;
    protected static final int EVENT_SS = 36;
    protected static final int EVENT_SSN = 2;
    protected static final int EVENT_SUBSCRIPTIONS_CHANGED = 62;
    protected static final int EVENT_UICC_APPS_ENABLEMENT_SETTING_CHANGED = 54;
    protected static final int EVENT_UICC_APPS_ENABLEMENT_STATUS_CHANGED = 53;
    private static final int EVENT_UNSOL_OEM_HOOK_RAW = 34;
    protected static final int EVENT_UPDATE_PHONE_OBJECT = 42;
    protected static final int EVENT_USSD = 7;
    protected static final int EVENT_VOICE_RADIO_TECH_CHANGED = 39;
    protected static final int EVENT_VRS_OR_RAT_CHANGED = 46;
    @Deprecated
    public static final String EXTRA_KEY_ALERT_MESSAGE = "android.telephony.ims.extra.WFC_REGISTRATION_FAILURE_MESSAGE";
    public static final String EXTRA_KEY_ALERT_SHOW = "alertShow";
    @Deprecated
    public static final String EXTRA_KEY_ALERT_TITLE = "android.telephony.ims.extra.WFC_REGISTRATION_FAILURE_TITLE";
    public static final String EXTRA_KEY_NOTIFICATION_MESSAGE = "notificationMessage";
    private static final String GSM_NON_ROAMING_LIST_OVERRIDE_PREFIX = "gsm_non_roaming_list_";
    private static final String GSM_ROAMING_LIST_OVERRIDE_PREFIX = "gsm_roaming_list_";
    private static final int INVALID_ALLOWED_NETWORK_TYPES = -1;
    private static final boolean LCE_PULL_MODE = true;
    private static final String LOG_TAG = "Phone";
    public static final String NETWORK_SELECTION_KEY = "network_selection_key";
    public static final String NETWORK_SELECTION_NAME_KEY = "network_selection_name_key";
    public static final String NETWORK_SELECTION_SHORT_KEY = "network_selection_short_key";
    private static final String PROVISIONING_URL_PATH = "/data/misc/radio/provisioning_urls.xml";
    private static final String TAG_PROVISIONING_URL = "provisioningUrl";
    private static final String TAG_PROVISIONING_URLS = "provisioningUrls";
    private static final String VM_COUNT = "vm_count_key";
    private static final String VM_ID = "vm_id_key";
    protected static final Object lockForRadioTechnologyChange = new Object();
    protected final int USSD_MAX_QUEUE;
    protected AccessNetworksManager mAccessNetworksManager;
    private final String mActionAttached;
    private final String mActionDetached;
    private final RegistrantList mAllDataDisconnectedRegistrants;
    private Map<Integer, Long> mAllowedNetworkTypesForReasons;
    private final AppSmsManager mAppSmsManager;
    private int mCallRingContinueToken;
    private int mCallRingDelay;
    protected CarrierActionAgent mCarrierActionAgent;
    protected CarrierResolver mCarrierResolver;
    protected CarrierSignalAgent mCarrierSignalAgent;
    private final RegistrantList mCellInfoRegistrants;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CommandsInterface mCi;
    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public final Context mContext;
    protected DataEnabledSettings mDataEnabledSettings;
    protected DataNetworkController mDataNetworkController;
    protected final SparseArray<DcTracker> mDcTrackers;
    protected DeviceStateMonitor mDeviceStateMonitor;
    protected final RegistrantList mDisconnectRegistrants;
    protected DisplayInfoController mDisplayInfoController;
    private boolean mDnsCheckDisabled;
    private boolean mDoesRilSendMultipleCallRing;
    protected boolean mEcmCanceledForEmergency;
    protected final RegistrantList mEmergencyCallToggledRegistrants;
    private final RegistrantList mHandoverRegistrants;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final AtomicReference<IccRecords> mIccRecords;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Phone mImsPhone;
    private final RegistrantList mIncomingRingRegistrants;
    protected boolean mIsAllowedNetworkTypesLoadedFromDb;
    protected boolean mIsCarrierNrSupported;
    protected boolean mIsPhoneInEcmState;
    private boolean mIsUsageSettingSupported;
    protected boolean mIsVideoCapable;
    private boolean mIsVoiceCapable;
    private int mLceStatus;
    protected LinkBandwidthEstimator mLinkBandwidthEstimator;
    protected final LocalLog mLocalLog;
    private Looper mLooper;
    protected final RegistrantList mMmiCompleteRegistrants;
    @UnsupportedAppUsage
    protected final RegistrantList mMmiRegistrants;
    private String mName;
    private final boolean mNewDataStackEnabled;
    private final RegistrantList mNewRingingConnectionRegistrants;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected PhoneNotifier mNotifier;
    private final RegistrantList mOtaspRegistrants;
    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int mPhoneId;
    private final RegistrantList mPhysicalChannelConfigRegistrants;
    protected Registrant mPostDialHandler;
    private final RegistrantList mPreciseCallStateRegistrants;
    private final RegistrantList mPreferredNetworkTypeRegistrants;
    private int mPreferredUsageSetting;
    private final File mProvisioningUrlFile;
    private final AtomicReference<RadioCapability> mRadioCapability;
    protected final RegistrantList mRadioOffOrNotAvailableRegistrants;
    private final RegistrantList mRedialRegistrants;
    private final RegistrantList mServiceStateRegistrants;
    protected SignalStrengthController mSignalStrengthController;
    private SimActivationTracker mSimActivationTracker;
    protected final RegistrantList mSimRecordsLoadedRegistrants;
    protected SimulatedRadioControl mSimulatedRadioControl;
    protected SmsStats mSmsStats;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public SmsStorageMonitor mSmsStorageMonitor;
    public SmsUsageMonitor mSmsUsageMonitor;
    protected final RegistrantList mSuppServiceFailedRegistrants;
    protected TelephonyComponentFactory mTelephonyComponentFactory;
    TelephonyTester mTelephonyTester;
    private volatile long mTimeLastEmergencySmsSentMs;
    protected TransportManager mTransportManager;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected AtomicReference<UiccCardApplication> mUiccApplication;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected UiccController mUiccController;
    private boolean mUnitTestMode;
    protected final RegistrantList mUnknownConnectionRegistrants;
    private int mUsageSettingFromModem;
    private final RegistrantList mVideoCapabilityChangedRegistrants;
    protected int mVmCount;
    protected VoiceCallSessionStats mVoiceCallSessionStats;

    public static class NetworkSelectMessage {
        public Message message;
        public String operatorAlphaLong;
        public String operatorAlphaShort;
        public String operatorNumeric;
    }

    public void callEndCleanupHandOverCallIfAny() {
    }

    public boolean canDisablePhysicalSubscription() {
        return false;
    }

    public void cancelUSSD(Message message) {
    }

    public void deleteCarrierInfoForImsiEncryption(int i) {
    }

    /* access modifiers changed from: protected */
    public Connection dialInternal(String str, PhoneInternalInterface.DialArgs dialArgs) throws CallStateException {
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void dispose() {
    }

    public void enableEnhancedVoicePrivacy(boolean z, Message message) {
    }

    public void enableUiccApplications(boolean z, Message message) {
    }

    @UnsupportedAppUsage
    public void exitEmergencyCallbackMode() {
    }

    public AccessNetworksManager getAccessNetworksManager() {
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CallTracker getCallTracker() {
        return null;
    }

    public int getCarrierId() {
        return -1;
    }

    public int getCarrierIdListVersion() {
        return -1;
    }

    public ImsiEncryptionInfo getCarrierInfoForImsiEncryption(int i, boolean z) {
        return null;
    }

    public String getCarrierName() {
        return null;
    }

    public CarrierPrivilegesTracker getCarrierPrivilegesTracker() {
        return null;
    }

    public int getCdmaEriIconIndex() {
        return -1;
    }

    public int getCdmaEriIconMode() {
        return -1;
    }

    public String getCdmaEriText() {
        return "GSM nw, no ERI";
    }

    public String getCdmaMin() {
        return null;
    }

    public String getCdmaPrlVersion() {
        return null;
    }

    public Uri[] getCurrentSubscriberUris() {
        return null;
    }

    public Phone getDefaultPhone() {
        return this;
    }

    public DeviceStateMonitor getDeviceStateMonitor() {
        return null;
    }

    public DisplayInfoController getDisplayInfoController() {
        return null;
    }

    public int getEmergencyNumberDbVersion() {
        return -1;
    }

    public EmergencyNumberTracker getEmergencyNumberTracker() {
        return null;
    }

    public void getEnhancedVoicePrivacy(Message message) {
    }

    public Handler getHandler() {
        return this;
    }

    public ArrayList<Connection> getHandoverConnection() {
        return null;
    }

    @UnsupportedAppUsage
    public IccCard getIccCard() {
        return null;
    }

    @UnsupportedAppUsage
    public IccSmsInterfaceManager getIccSmsInterfaceManager() {
        return null;
    }

    public InboundSmsHandler getInboundSmsHandler(boolean z) {
        return null;
    }

    public int getMNOCarrierId() {
        return -1;
    }

    public String getManualNetworkSelectionPlmn() {
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getMsisdn() {
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getNai() {
        return null;
    }

    public String getOperatorNumeric() {
        return "";
    }

    public int getOtasp() {
        return 1;
    }

    @UnsupportedAppUsage
    public abstract int getPhoneType();

    public List<PhysicalChannelConfig> getPhysicalChannelConfigList() {
        return null;
    }

    public String getPlmn() {
        return null;
    }

    public PreciseDataConnectionState getPreciseDataConnectionState(String str) {
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ServiceStateTracker getServiceStateTracker() {
        return null;
    }

    public int getSpecificCarrierId() {
        return -1;
    }

    public String getSpecificCarrierName() {
        return null;
    }

    @UnsupportedAppUsage
    public abstract PhoneConstants.State getState();

    public TransportManager getTransportManager() {
        return null;
    }

    /* access modifiers changed from: protected */
    public void handleExitEmergencyCallbackMode() {
    }

    public boolean isCdmaSubscriptionAppPresent() {
        return false;
    }

    @UnsupportedAppUsage
    public boolean isCspPlmnEnabled() {
        return false;
    }

    public boolean isDataSuspended() {
        return false;
    }

    public boolean isInEmergencyCall() {
        return false;
    }

    public boolean isInImsEcm() {
        return false;
    }

    public boolean isMinInfoReady() {
        return false;
    }

    public boolean isOtaSpNumber(String str) {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean needNotifySrvccState() {
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean needsOtaServiceProvisioning() {
        return false;
    }

    public void notifyCallForwardingIndicator() {
    }

    /* access modifiers changed from: protected */
    public void notifyImsPhoneHandoverStateChanged(Connection connection) {
    }

    public void notifySrvccState(Call.SrvccState srvccState) {
    }

    /* access modifiers changed from: protected */
    public abstract void onUpdateIccAvailability();

    public void queryCLIP(Message message) {
    }

    public void registerForCallWaiting(Handler handler, int i, Object obj) {
    }

    public void registerForCdmaOtaStatusChange(Handler handler, int i, Object obj) {
    }

    @UnsupportedAppUsage
    public void registerForEcmTimerReset(Handler handler, int i, Object obj) {
    }

    public void registerForOnHoldTone(Handler handler, int i, Object obj) {
    }

    public void registerForSilentRedial(Handler handler, int i, Object obj) {
    }

    @UnsupportedAppUsage
    public void registerForSimRecordsLoaded(Handler handler, int i, Object obj) {
    }

    public void registerForSubscriptionInfoReady(Handler handler, int i, Object obj) {
    }

    public void registerForTtyModeReceived(Handler handler, int i, Object obj) {
    }

    public void registerForVolteSilentRedial(Handler handler, int i, Object obj) {
    }

    public void resetCarrierKeysForImsiEncryption() {
    }

    public void resolveSubscriptionCarrierId(String str) {
    }

    public void sendBurstDtmf(String str, int i, int i2, Message message) {
    }

    public abstract void sendEmergencyCallStateChange(boolean z);

    public abstract void setBroadcastEmergencyCallStateChanges(boolean z);

    public void setCallWaiting(boolean z, int i, Message message) {
    }

    public void setCarrierInfoForImsiEncryption(ImsiEncryptionInfo imsiEncryptionInfo) {
    }

    public void setCarrierTestOverride(String str, String str2, String str3, String str4, String str5, String str6, String str7, String str8, String str9) {
    }

    public void setEchoSuppressionEnabled() {
    }

    public void setImsRegistrationState(boolean z) {
    }

    /* access modifiers changed from: protected */
    public void setIsInEmergencyCall() {
    }

    public void setLinkCapacityReportingCriteria(int[] iArr, int[] iArr2, int i) {
    }

    @UnsupportedAppUsage
    public void setOnEcbModeExitResponse(Handler handler, int i, Object obj) {
    }

    public boolean setOperatorBrandOverride(String str) {
        return false;
    }

    public void setVoiceServiceStateOverride(boolean z) {
    }

    public void startRingbackTone() {
    }

    public void stopRingbackTone() {
    }

    public void unregisterForCallWaiting(Handler handler) {
    }

    public void unregisterForCdmaOtaStatusChange(Handler handler) {
    }

    @UnsupportedAppUsage
    public void unregisterForEcmTimerReset(Handler handler) {
    }

    public void unregisterForOnHoldTone(Handler handler) {
    }

    public void unregisterForSilentRedial(Handler handler) {
    }

    @UnsupportedAppUsage
    public void unregisterForSimRecordsLoaded(Handler handler) {
    }

    public void unregisterForSubscriptionInfoReady(Handler handler) {
    }

    public void unregisterForTtyModeReceived(Handler handler) {
    }

    public void unregisterForVolteSilentRedial(Handler handler) {
    }

    @UnsupportedAppUsage
    public void unsetOnEcbModeExitResponse(Handler handler) {
    }

    public boolean updateCurrentCarrierInProvider() {
        return false;
    }

    public void updatePhoneObject(int i) {
    }

    public boolean useSsOverIms(Message message) {
        return false;
    }

    public static class SilentRedialParam {
        public int causeCode;
        public PhoneInternalInterface.DialArgs dialArgs;
        public String dialString;

        public SilentRedialParam(String str, int i, PhoneInternalInterface.DialArgs dialArgs2) {
            this.dialString = str;
            this.causeCode = i;
            this.dialArgs = dialArgs2;
        }
    }

    public IccRecords getIccRecords() {
        return this.mIccRecords.get();
    }

    @UnsupportedAppUsage
    public String getPhoneName() {
        return this.mName;
    }

    /* access modifiers changed from: protected */
    public void setPhoneName(String str) {
        this.mName = str;
    }

    public String getActionDetached() {
        return this.mActionDetached;
    }

    public String getActionAttached() {
        return this.mActionAttached;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getSystemProperty(String str, String str2) {
        if (getUnitTestMode()) {
            return null;
        }
        return SystemProperties.get(str, str2);
    }

    protected Phone(String str, PhoneNotifier phoneNotifier, Context context, CommandsInterface commandsInterface, boolean z) {
        this(str, phoneNotifier, context, commandsInterface, z, Integer.MAX_VALUE, TelephonyComponentFactory.getInstance());
    }

    protected Phone(String str, PhoneNotifier phoneNotifier, Context context, CommandsInterface commandsInterface, boolean z, int i, TelephonyComponentFactory telephonyComponentFactory) {
        this.USSD_MAX_QUEUE = 10;
        this.mVmCount = 0;
        this.mDcTrackers = new SparseArray<>();
        this.mIsVoiceCapable = true;
        this.mIsPhoneInEcmState = false;
        this.mEcmCanceledForEmergency = false;
        this.mTimeLastEmergencySmsSentMs = -1;
        this.mIsVideoCapable = false;
        this.mUiccController = null;
        this.mIccRecords = new AtomicReference<>();
        this.mUiccApplication = new AtomicReference<>();
        this.mImsPhone = null;
        this.mRadioCapability = new AtomicReference<>();
        this.mLceStatus = -1;
        this.mPreferredUsageSetting = -1;
        this.mUsageSettingFromModem = -1;
        this.mIsUsageSettingSupported = true;
        this.mPreciseCallStateRegistrants = new RegistrantList();
        this.mHandoverRegistrants = new RegistrantList();
        this.mNewRingingConnectionRegistrants = new RegistrantList();
        this.mIncomingRingRegistrants = new RegistrantList();
        this.mDisconnectRegistrants = new RegistrantList();
        this.mServiceStateRegistrants = new RegistrantList();
        this.mMmiCompleteRegistrants = new RegistrantList();
        this.mMmiRegistrants = new RegistrantList();
        this.mUnknownConnectionRegistrants = new RegistrantList();
        this.mSuppServiceFailedRegistrants = new RegistrantList();
        this.mRadioOffOrNotAvailableRegistrants = new RegistrantList();
        this.mSimRecordsLoadedRegistrants = new RegistrantList();
        this.mVideoCapabilityChangedRegistrants = new RegistrantList();
        this.mEmergencyCallToggledRegistrants = new RegistrantList();
        this.mAllDataDisconnectedRegistrants = new RegistrantList();
        this.mCellInfoRegistrants = new RegistrantList();
        this.mRedialRegistrants = new RegistrantList();
        this.mPhysicalChannelConfigRegistrants = new RegistrantList();
        this.mOtaspRegistrants = new RegistrantList();
        this.mPreferredNetworkTypeRegistrants = new RegistrantList();
        this.mAllowedNetworkTypesForReasons = new HashMap();
        this.mIsCarrierNrSupported = false;
        this.mIsAllowedNetworkTypesLoadedFromDb = false;
        this.mProvisioningUrlFile = new File(PROVISIONING_URL_PATH);
        this.mPhoneId = i;
        this.mName = str;
        this.mNotifier = phoneNotifier;
        this.mContext = context;
        this.mLooper = Looper.myLooper();
        this.mCi = commandsInterface;
        this.mActionDetached = getClass().getPackage().getName() + ".action_detached";
        this.mActionAttached = getClass().getPackage().getName() + ".action_attached";
        this.mAppSmsManager = telephonyComponentFactory.inject(AppSmsManager.class.getName()).makeAppSmsManager(context);
        this.mLocalLog = new LocalLog(64);
        if (TelephonyUtils.IS_DEBUGGABLE) {
            this.mTelephonyTester = new TelephonyTester(this);
        }
        setUnitTestMode(z);
        this.mDnsCheckDisabled = PreferenceManager.getDefaultSharedPreferences(context).getBoolean(DNS_SERVER_CHECK_DISABLED_KEY, false);
        this.mCi.setOnCallRing(this, 14, (Object) null);
        this.mIsVoiceCapable = ((TelephonyManager) context.getSystemService("phone")).isVoiceCapable();
        this.mDoesRilSendMultipleCallRing = TelephonyProperties.ril_sends_multiple_call_ring().orElse(Boolean.TRUE).booleanValue();
        Rlog.d(LOG_TAG, "mDoesRilSendMultipleCallRing=" + this.mDoesRilSendMultipleCallRing);
        this.mCallRingDelay = TelephonyProperties.call_ring_delay().orElse(3000).intValue();
        Rlog.d(LOG_TAG, "mCallRingDelay=" + this.mCallRingDelay);
        this.mSmsStats = new SmsStats(this);
        this.mNewDataStackEnabled = context.getResources().getBoolean(17891674) ^ true;
        if (getPhoneType() != 5) {
            this.mTelephonyComponentFactory = telephonyComponentFactory;
            this.mSmsStorageMonitor = telephonyComponentFactory.inject(SmsStorageMonitor.class.getName()).makeSmsStorageMonitor(this);
            this.mSmsUsageMonitor = this.mTelephonyComponentFactory.inject(SmsUsageMonitor.class.getName()).makeSmsUsageMonitor(context);
            UiccController instance = UiccController.getInstance();
            this.mUiccController = instance;
            instance.registerForIccChanged(this, 30, new Object());
            this.mSimActivationTracker = this.mTelephonyComponentFactory.inject(SimActivationTracker.class.getName()).makeSimActivationTracker(this);
            if (getPhoneType() != 3) {
                this.mCi.registerForSrvccStateChanged(this, 31, (Object) null);
            }
            this.mCi.startLceService(200, true, obtainMessage(37));
        }
    }

    public void createImsPhone() {
        if (getPhoneType() != 3) {
            synchronized (lockForRadioTechnologyChange) {
                if (this.mImsPhone == null) {
                    this.mImsPhone = PhoneFactory.makeImsPhone(this.mNotifier, this);
                    CallManager.getInstance().registerPhone(this.mImsPhone);
                    this.mImsPhone.registerForSilentRedial(this, 32, (Object) null);
                }
            }
        }
    }

    public boolean supportsConversionOfCdmaCallerIdMmiCodesWhileRoaming() {
        PersistableBundle configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId());
        if (configForSubId != null) {
            return configForSubId.getBoolean("convert_cdma_caller_id_mmi_codes_while_roaming_on_3gpp_bool", false);
        }
        return false;
    }

    public boolean isClirActivationAndDeactivationPrevented() {
        PersistableBundle configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId());
        if (configForSubId == null) {
            configForSubId = CarrierConfigManager.getDefaultConfig();
        }
        return configForSubId.getBoolean("prevent_clir_activation_and_deactivation_code_bool");
    }

    public void handleMessage(Message message) {
        Object obj;
        int i = message.what;
        if (i == 16 || i == 17) {
            handleSetSelectNetwork((AsyncResult) message.obj);
        } else if (i == 14) {
            Rlog.d(LOG_TAG, "Event EVENT_CALL_RING Received state=" + getState());
            if (((AsyncResult) message.obj).exception == null) {
                PhoneConstants.State state = getState();
                if (this.mDoesRilSendMultipleCallRing || !(state == PhoneConstants.State.RINGING || state == PhoneConstants.State.IDLE)) {
                    notifyIncomingRing();
                    return;
                }
                int i2 = this.mCallRingContinueToken + 1;
                this.mCallRingContinueToken = i2;
                sendIncomingCallRingNotification(i2);
            }
        } else if (i == 15) {
            Rlog.d(LOG_TAG, "Event EVENT_CALL_RING_CONTINUE Received state=" + getState());
            if (getState() == PhoneConstants.State.RINGING) {
                sendIncomingCallRingNotification(message.arg1);
            }
        } else if (i == 34) {
        } else {
            if (i != 52) {
                if (i == 37) {
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    if (asyncResult.exception != null) {
                        Rlog.d(LOG_TAG, "config LCE service failed: " + asyncResult.exception);
                        return;
                    }
                    this.mLceStatus = ((Integer) ((ArrayList) asyncResult.result).get(0)).intValue();
                } else if (i == 38) {
                    onCheckForNetworkSelectionModeAutomatic(message);
                } else if (i == 63) {
                    AsyncResult asyncResult2 = (AsyncResult) message.obj;
                    Throwable th = asyncResult2.exception;
                    if (th == null) {
                        try {
                            this.mUsageSettingFromModem = ((int[]) asyncResult2.result)[0];
                            logd("Received mUsageSettingFromModem=" + this.mUsageSettingFromModem);
                            if (this.mUsageSettingFromModem != this.mPreferredUsageSetting) {
                                this.mCi.setUsageSetting(obtainMessage(64), this.mPreferredUsageSetting);
                            }
                        } catch (ClassCastException | NullPointerException unused) {
                            Rlog.e(LOG_TAG, "Invalid response for usage setting " + asyncResult2.result);
                        }
                    } else {
                        try {
                            CommandException commandException = (CommandException) th;
                            if (commandException.getCommandError() == CommandException.Error.REQUEST_NOT_SUPPORTED) {
                                this.mIsUsageSettingSupported = false;
                            }
                            Rlog.w(LOG_TAG, "Unexpected failure to retrieve usage setting " + commandException);
                        } catch (ClassCastException unused2) {
                            Rlog.e(LOG_TAG, "Invalid Exception for usage setting " + asyncResult2.exception);
                        }
                    }
                } else if (i != 64) {
                    switch (i) {
                        case 30:
                            onUpdateIccAvailability();
                            return;
                        case 31:
                            AsyncResult asyncResult3 = (AsyncResult) message.obj;
                            if (asyncResult3.exception == null) {
                                handleSrvccStateChanged((int[]) asyncResult3.result);
                                return;
                            }
                            Rlog.e(LOG_TAG, "Srvcc exception: " + asyncResult3.exception);
                            return;
                        case 32:
                            Rlog.d(LOG_TAG, "Event EVENT_INITIATE_SILENT_REDIAL Received");
                            AsyncResult asyncResult4 = (AsyncResult) message.obj;
                            if (asyncResult4.exception == null && (obj = asyncResult4.result) != null) {
                                SilentRedialParam silentRedialParam = (SilentRedialParam) obj;
                                String str = silentRedialParam.dialString;
                                PhoneInternalInterface.DialArgs dialArgs = silentRedialParam.dialArgs;
                                if (!TextUtils.isEmpty(str)) {
                                    try {
                                        Connection dialInternal = dialInternal(str, dialArgs);
                                        Rlog.d(LOG_TAG, "Notify redial connection changed cn: " + dialInternal);
                                        Phone phone = this.mImsPhone;
                                        if (phone != null) {
                                            phone.notifyRedialConnectionChanged(dialInternal);
                                            return;
                                        }
                                        return;
                                    } catch (CallStateException e) {
                                        Rlog.e(LOG_TAG, "silent redial failed: " + e);
                                        Phone phone2 = this.mImsPhone;
                                        if (phone2 != null) {
                                            phone2.notifyRedialConnectionChanged((Connection) null);
                                            return;
                                        }
                                        return;
                                    }
                                } else {
                                    return;
                                }
                            } else {
                                return;
                            }
                        default:
                            throw new RuntimeException("unexpected event not handled");
                    }
                } else {
                    AsyncResult asyncResult5 = (AsyncResult) message.obj;
                    Throwable th2 = asyncResult5.exception;
                    if (th2 != null) {
                        try {
                            CommandException commandException2 = (CommandException) th2;
                            if (commandException2.getCommandError() == CommandException.Error.REQUEST_NOT_SUPPORTED) {
                                this.mIsUsageSettingSupported = false;
                            }
                            Rlog.w(LOG_TAG, "Unexpected failure to set usage setting " + commandException2);
                        } catch (ClassCastException unused3) {
                            Rlog.e(LOG_TAG, "Invalid Exception for usage setting " + asyncResult5.exception);
                        }
                    }
                }
            } else if (areAllDataDisconnected()) {
                this.mAllDataDisconnectedRegistrants.notifyRegistrants();
            }
        }
    }

    private void handleSrvccStateChanged(int[] iArr) {
        Call.SrvccState srvccState;
        Call.SrvccState srvccState2;
        Rlog.d(LOG_TAG, "handleSrvccStateChanged");
        Phone phone = this.mImsPhone;
        Call.SrvccState srvccState3 = Call.SrvccState.NONE;
        if (iArr != null && iArr.length != 0) {
            int i = iArr[0];
            ArrayList<Connection> arrayList = null;
            if (i == 0) {
                srvccState2 = Call.SrvccState.STARTED;
                if (phone != null) {
                    arrayList = phone.getHandoverConnection();
                    migrateFrom(phone);
                } else {
                    Rlog.d(LOG_TAG, "HANDOVER_STARTED: mImsPhone null");
                }
            } else if (i == 1) {
                srvccState2 = Call.SrvccState.COMPLETED;
                if (phone != null) {
                    phone.notifySrvccState(srvccState2);
                } else {
                    Rlog.d(LOG_TAG, "HANDOVER_COMPLETED: mImsPhone null");
                }
            } else if (i == 2 || i == 3) {
                srvccState = Call.SrvccState.FAILED;
                getCallTracker().notifySrvccState(srvccState, arrayList);
                notifySrvccStateChanged(i);
            } else {
                return;
            }
            srvccState = srvccState2;
            getCallTracker().notifySrvccState(srvccState, arrayList);
            notifySrvccStateChanged(i);
        }
    }

    @UnsupportedAppUsage
    public Context getContext() {
        return this.mContext;
    }

    public void disableDnsCheck(boolean z) {
        this.mDnsCheckDisabled = z;
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(getContext()).edit();
        edit.putBoolean(DNS_SERVER_CHECK_DISABLED_KEY, z);
        edit.apply();
    }

    public boolean isDnsCheckDisabled() {
        return this.mDnsCheckDisabled;
    }

    @UnsupportedAppUsage
    public void registerForPreciseCallStateChanged(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mPreciseCallStateRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForPreciseCallStateChanged(Handler handler) {
        this.mPreciseCallStateRegistrants.remove(handler);
    }

    /* access modifiers changed from: protected */
    public void notifyPreciseCallStateChangedP() {
        this.mPreciseCallStateRegistrants.notifyRegistrants(new AsyncResult((Object) null, this, (Throwable) null));
        this.mNotifier.notifyPreciseCallState(this);
    }

    public void registerForHandoverStateChanged(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mHandoverRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForHandoverStateChanged(Handler handler) {
        this.mHandoverRegistrants.remove(handler);
    }

    public void notifyHandoverStateChanged(Connection connection) {
        this.mHandoverRegistrants.notifyRegistrants(new AsyncResult((Object) null, connection, (Throwable) null));
    }

    public void registerForRedialConnectionChanged(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mRedialRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForRedialConnectionChanged(Handler handler) {
        this.mRedialRegistrants.remove(handler);
    }

    public void notifyRedialConnectionChanged(Connection connection) {
        this.mRedialRegistrants.notifyRegistrants(new AsyncResult((Object) null, connection, (Throwable) null));
    }

    public void notifySmsSent(String str) {
        TelephonyManager telephonyManager = (TelephonyManager) getContext().getSystemService("phone");
        if (telephonyManager != null && telephonyManager.isEmergencyNumber(str)) {
            this.mLocalLog.log("Emergency SMS detected, recording time.");
            this.mTimeLastEmergencySmsSentMs = SystemClock.elapsedRealtime();
        }
    }

    public boolean isInEmergencySmsMode() {
        PersistableBundle configForSubId;
        int i;
        long j = this.mTimeLastEmergencySmsSentMs;
        boolean z = false;
        if (j == -1 || (configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId())) == null || (i = configForSubId.getInt("emergency_sms_mode_timer_ms_int", 0)) == 0) {
            return false;
        }
        if (i > EMERGENCY_SMS_TIMER_MAX_MS) {
            i = EMERGENCY_SMS_TIMER_MAX_MS;
        }
        if (SystemClock.elapsedRealtime() <= j + ((long) i)) {
            z = true;
        }
        if (!z) {
            this.mTimeLastEmergencySmsSentMs = -1;
        } else {
            this.mLocalLog.log("isInEmergencySmsMode: queried while eSMS mode is active.");
        }
        return z;
    }

    /* access modifiers changed from: protected */
    public void migrateFrom(Phone phone) {
        migrate(this.mHandoverRegistrants, phone.mHandoverRegistrants);
        migrate(this.mPreciseCallStateRegistrants, phone.mPreciseCallStateRegistrants);
        migrate(this.mNewRingingConnectionRegistrants, phone.mNewRingingConnectionRegistrants);
        migrate(this.mIncomingRingRegistrants, phone.mIncomingRingRegistrants);
        migrate(this.mDisconnectRegistrants, phone.mDisconnectRegistrants);
        migrate(this.mServiceStateRegistrants, phone.mServiceStateRegistrants);
        migrate(this.mMmiCompleteRegistrants, phone.mMmiCompleteRegistrants);
        migrate(this.mMmiRegistrants, phone.mMmiRegistrants);
        migrate(this.mUnknownConnectionRegistrants, phone.mUnknownConnectionRegistrants);
        migrate(this.mSuppServiceFailedRegistrants, phone.mSuppServiceFailedRegistrants);
        migrate(this.mCellInfoRegistrants, phone.mCellInfoRegistrants);
        migrate(this.mRedialRegistrants, phone.mRedialRegistrants);
        if (phone.isInEmergencyCall()) {
            setIsInEmergencyCall();
        }
        setEcmCanceledForEmergency(phone.isEcmCanceledForEmergency());
    }

    /* access modifiers changed from: protected */
    public void migrate(RegistrantList registrantList, RegistrantList registrantList2) {
        boolean z;
        if (registrantList2 != null) {
            registrantList2.removeCleared();
            int size = registrantList2.size();
            for (int i = 0; i < size; i++) {
                Registrant registrant = (Registrant) registrantList2.get(i);
                Message messageForRegistrant = registrant.messageForRegistrant();
                if (messageForRegistrant == null) {
                    Rlog.d(LOG_TAG, "msg is null");
                } else if (messageForRegistrant.obj != CallManager.getInstance().getRegistrantIdentifier()) {
                    int size2 = registrantList.size();
                    int i2 = 0;
                    while (true) {
                        if (i2 >= size2) {
                            z = false;
                            break;
                        } else if (((Registrant) registrantList.get(i2)).getHandler() == registrant.getHandler()) {
                            z = true;
                            break;
                        } else {
                            i2++;
                        }
                    }
                    if (!z) {
                        registrantList.add((Registrant) registrantList2.get(i));
                    }
                }
            }
        }
    }

    @UnsupportedAppUsage
    public void registerForUnknownConnection(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mUnknownConnectionRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForUnknownConnection(Handler handler) {
        this.mUnknownConnectionRegistrants.remove(handler);
    }

    @UnsupportedAppUsage
    public void registerForNewRingingConnection(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mNewRingingConnectionRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForNewRingingConnection(Handler handler) {
        this.mNewRingingConnectionRegistrants.remove(handler);
    }

    public void registerForVideoCapabilityChanged(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mVideoCapabilityChangedRegistrants.addUnique(handler, i, obj);
        notifyForVideoCapabilityChanged(this.mIsVideoCapable);
    }

    public void unregisterForVideoCapabilityChanged(Handler handler) {
        this.mVideoCapabilityChangedRegistrants.remove(handler);
    }

    public void registerForInCallVoicePrivacyOn(Handler handler, int i, Object obj) {
        this.mCi.registerForInCallVoicePrivacyOn(handler, i, obj);
    }

    public void unregisterForInCallVoicePrivacyOn(Handler handler) {
        this.mCi.unregisterForInCallVoicePrivacyOn(handler);
    }

    public void registerForInCallVoicePrivacyOff(Handler handler, int i, Object obj) {
        this.mCi.registerForInCallVoicePrivacyOff(handler, i, obj);
    }

    public void unregisterForInCallVoicePrivacyOff(Handler handler) {
        this.mCi.unregisterForInCallVoicePrivacyOff(handler);
    }

    @UnsupportedAppUsage
    public void registerForIncomingRing(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mIncomingRingRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForIncomingRing(Handler handler) {
        this.mIncomingRingRegistrants.remove(handler);
    }

    @UnsupportedAppUsage
    public void registerForDisconnect(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mDisconnectRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForDisconnect(Handler handler) {
        this.mDisconnectRegistrants.remove(handler);
    }

    public void registerForSuppServiceFailed(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mSuppServiceFailedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSuppServiceFailed(Handler handler) {
        this.mSuppServiceFailedRegistrants.remove(handler);
    }

    @UnsupportedAppUsage
    public void registerForMmiInitiate(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mMmiRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForMmiInitiate(Handler handler) {
        this.mMmiRegistrants.remove(handler);
    }

    @UnsupportedAppUsage
    public void registerForMmiComplete(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mMmiCompleteRegistrants.addUnique(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForMmiComplete(Handler handler) {
        checkCorrectThread(handler);
        this.mMmiCompleteRegistrants.remove(handler);
    }

    @UnsupportedAppUsage
    public void setNetworkSelectionModeAutomatic(Message message) {
        Rlog.d(LOG_TAG, "setNetworkSelectionModeAutomatic, querying current mode");
        Message obtainMessage = obtainMessage(38);
        obtainMessage.obj = message;
        this.mCi.getNetworkSelectionMode(obtainMessage);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:6:0x0016, code lost:
        if (((int[]) r1)[0] == 0) goto L_0x001a;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onCheckForNetworkSelectionModeAutomatic(android.os.Message r5) {
        /*
            r4 = this;
            java.lang.Object r5 = r5.obj
            android.os.AsyncResult r5 = (android.os.AsyncResult) r5
            java.lang.Object r0 = r5.userObj
            android.os.Message r0 = (android.os.Message) r0
            java.lang.Throwable r1 = r5.exception
            r2 = 1
            if (r1 != 0) goto L_0x0019
            java.lang.Object r1 = r5.result
            if (r1 == 0) goto L_0x0019
            int[] r1 = (int[]) r1     // Catch:{ Exception -> 0x0019 }
            r3 = 0
            r1 = r1[r3]     // Catch:{ Exception -> 0x0019 }
            if (r1 != 0) goto L_0x0019
            goto L_0x001a
        L_0x0019:
            r3 = r2
        L_0x001a:
            com.android.internal.telephony.Phone$NetworkSelectMessage r1 = new com.android.internal.telephony.Phone$NetworkSelectMessage
            r1.<init>()
            r1.message = r0
            java.lang.String r0 = ""
            r1.operatorNumeric = r0
            r1.operatorAlphaLong = r0
            r1.operatorAlphaShort = r0
            if (r3 == 0) goto L_0x0037
            r5 = 17
            android.os.Message r5 = r4.obtainMessage(r5, r1)
            com.android.internal.telephony.CommandsInterface r0 = r4.mCi
            r0.setNetworkSelectionModeAutomatic(r5)
            goto L_0x0049
        L_0x0037:
            java.lang.String r0 = "Phone"
            java.lang.String r3 = "setNetworkSelectionModeAutomatic - already auto, ignoring"
            com.android.telephony.Rlog.d(r0, r3)
            android.os.Message r0 = r1.message
            if (r0 == 0) goto L_0x0044
            r0.arg1 = r2
        L_0x0044:
            r5.userObj = r1
            r4.handleSetSelectNetwork(r5)
        L_0x0049:
            r4.updateSavedNetworkOperator(r1)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.Phone.onCheckForNetworkSelectionModeAutomatic(android.os.Message):void");
    }

    public void getNetworkSelectionMode(Message message) {
        this.mCi.getNetworkSelectionMode(message);
    }

    public List<ClientRequestStats> getClientRequestStats() {
        return this.mCi.getClientRequestStats();
    }

    @UnsupportedAppUsage
    public void selectNetworkManually(OperatorInfo operatorInfo, boolean z, Message message) {
        NetworkSelectMessage networkSelectMessage = new NetworkSelectMessage();
        networkSelectMessage.message = message;
        networkSelectMessage.operatorNumeric = operatorInfo.getOperatorNumeric();
        networkSelectMessage.operatorAlphaLong = operatorInfo.getOperatorAlphaLong();
        networkSelectMessage.operatorAlphaShort = operatorInfo.getOperatorAlphaShort();
        this.mCi.setNetworkSelectionModeManual(operatorInfo.getOperatorNumeric(), operatorInfo.getRan(), obtainMessage(16, networkSelectMessage));
        if (z) {
            updateSavedNetworkOperator(networkSelectMessage);
            return;
        }
        clearSavedNetworkSelection();
        updateManualNetworkSelection(networkSelectMessage);
    }

    public void registerForEmergencyCallToggle(Handler handler, int i, Object obj) {
        this.mEmergencyCallToggledRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForEmergencyCallToggle(Handler handler) {
        this.mEmergencyCallToggledRegistrants.remove(handler);
    }

    /* access modifiers changed from: protected */
    public void updateSavedNetworkOperator(NetworkSelectMessage networkSelectMessage) {
        int subId = getSubId();
        if (SubscriptionManager.isValidSubscriptionId(subId)) {
            SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(getContext()).edit();
            edit.putString(NETWORK_SELECTION_KEY + subId, networkSelectMessage.operatorNumeric);
            edit.putString(NETWORK_SELECTION_NAME_KEY + subId, networkSelectMessage.operatorAlphaLong);
            edit.putString(NETWORK_SELECTION_SHORT_KEY + subId, networkSelectMessage.operatorAlphaShort);
            if (!edit.commit()) {
                Rlog.e(LOG_TAG, "failed to commit network selection preference");
                return;
            }
            return;
        }
        Rlog.e(LOG_TAG, "Cannot update network selection preference due to invalid subId " + subId);
    }

    /* access modifiers changed from: protected */
    public void updateManualNetworkSelection(NetworkSelectMessage networkSelectMessage) {
        Rlog.e(LOG_TAG, "updateManualNetworkSelection() should be overridden");
    }

    /* access modifiers changed from: protected */
    public void handleSetSelectNetwork(AsyncResult asyncResult) {
        Object obj = asyncResult.userObj;
        if (!(obj instanceof NetworkSelectMessage)) {
            Rlog.e(LOG_TAG, "unexpected result from user object.");
            return;
        }
        NetworkSelectMessage networkSelectMessage = (NetworkSelectMessage) obj;
        Message message = networkSelectMessage.message;
        if (message != null) {
            AsyncResult.forMessage(message, asyncResult.result, asyncResult.exception);
            networkSelectMessage.message.sendToTarget();
        }
    }

    public OperatorInfo getSavedNetworkSelection() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getContext());
        String string = defaultSharedPreferences.getString(NETWORK_SELECTION_KEY + getSubId(), "");
        String string2 = defaultSharedPreferences.getString(NETWORK_SELECTION_NAME_KEY + getSubId(), "");
        return new OperatorInfo(string2, defaultSharedPreferences.getString(NETWORK_SELECTION_SHORT_KEY + getSubId(), ""), string);
    }

    /* access modifiers changed from: protected */
    public void clearSavedNetworkSelection() {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(getContext()).edit();
        SharedPreferences.Editor remove = edit.remove(NETWORK_SELECTION_KEY + getSubId());
        SharedPreferences.Editor remove2 = remove.remove(NETWORK_SELECTION_NAME_KEY + getSubId());
        remove2.remove(NETWORK_SELECTION_SHORT_KEY + getSubId()).commit();
    }

    /* access modifiers changed from: protected */
    public void restoreSavedNetworkSelection(Message message) {
        OperatorInfo savedNetworkSelection = getSavedNetworkSelection();
        if (savedNetworkSelection == null || TextUtils.isEmpty(savedNetworkSelection.getOperatorNumeric())) {
            setNetworkSelectionModeAutomatic(message);
        } else {
            selectNetworkManually(savedNetworkSelection, true, message);
        }
    }

    public void saveClirSetting(int i) {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(getContext()).edit();
        edit.putInt(CLIR_KEY + getSubId(), i);
        Rlog.i(LOG_TAG, "saveClirSetting: clir_sub_key" + getSubId() + "=" + i);
        if (!edit.commit()) {
            Rlog.e(LOG_TAG, "Failed to commit CLIR preference");
        }
    }

    private void setUnitTestMode(boolean z) {
        this.mUnitTestMode = z;
    }

    public boolean getUnitTestMode() {
        return this.mUnitTestMode;
    }

    /* access modifiers changed from: protected */
    public void notifyDisconnectP(Connection connection) {
        this.mDisconnectRegistrants.notifyRegistrants(new AsyncResult((Object) null, connection, (Throwable) null));
    }

    @UnsupportedAppUsage
    public void registerForServiceStateChanged(Handler handler, int i, Object obj) {
        this.mServiceStateRegistrants.add(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForServiceStateChanged(Handler handler) {
        this.mServiceStateRegistrants.remove(handler);
    }

    @UnsupportedAppUsage
    public void registerForRingbackTone(Handler handler, int i, Object obj) {
        this.mCi.registerForRingbackTone(handler, i, obj);
    }

    @UnsupportedAppUsage
    public void unregisterForRingbackTone(Handler handler) {
        this.mCi.unregisterForRingbackTone(handler);
    }

    public void registerForResendIncallMute(Handler handler, int i, Object obj) {
        this.mCi.registerForResendIncallMute(handler, i, obj);
    }

    public void unregisterForResendIncallMute(Handler handler) {
        this.mCi.unregisterForResendIncallMute(handler);
    }

    public void registerForCellInfo(Handler handler, int i, Object obj) {
        this.mCellInfoRegistrants.add(handler, i, obj);
    }

    public void unregisterForCellInfo(Handler handler) {
        this.mCellInfoRegistrants.remove(handler);
    }

    /* access modifiers changed from: protected */
    public void notifyServiceStateChangedP(ServiceState serviceState) {
        this.mServiceStateRegistrants.notifyRegistrants(new AsyncResult((Object) null, new ServiceState(serviceState), (Throwable) null));
        this.mNotifier.notifyServiceState(this);
    }

    /* access modifiers changed from: protected */
    public void notifyServiceStateChangedPForSubId(ServiceState serviceState, int i) {
        this.mServiceStateRegistrants.notifyRegistrants(new AsyncResult((Object) null, serviceState, (Throwable) null));
        this.mNotifier.notifyServiceStateForSubId(this, serviceState, i);
    }

    public SimulatedRadioControl getSimulatedRadioControl() {
        return this.mSimulatedRadioControl;
    }

    private void checkCorrectThread(Handler handler) {
        if (handler.getLooper() != this.mLooper) {
            throw new RuntimeException("com.android.internal.telephony.Phone must be used from within one thread");
        }
    }

    /* access modifiers changed from: package-private */
    public Locale getLocaleFromCarrierProperties() {
        String str = SystemProperties.get("ro.carrier");
        if (!(str == null || str.length() == 0 || EnvironmentCompat.MEDIA_UNKNOWN.equals(str))) {
            CharSequence[] textArray = this.mContext.getResources().getTextArray(17235980);
            for (int i = 0; i < textArray.length; i += 3) {
                if (str.equals(textArray[i].toString())) {
                    return Locale.forLanguageTag(textArray[i + 1].toString().replace('_', '-'));
                }
            }
        }
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IccFileHandler getIccFileHandler() {
        IccFileHandler iccFileHandler;
        UiccCardApplication uiccCardApplication = this.mUiccApplication.get();
        if (uiccCardApplication == null) {
            Rlog.d(LOG_TAG, "getIccFileHandler: uiccApplication == null, return null");
            iccFileHandler = null;
        } else {
            iccFileHandler = uiccCardApplication.getIccFileHandler();
        }
        Rlog.d(LOG_TAG, "getIccFileHandler: fh=" + iccFileHandler);
        return iccFileHandler;
    }

    public boolean isRadioOffForThermalMitigation() {
        ServiceStateTracker serviceStateTracker = getServiceStateTracker();
        if (serviceStateTracker == null || !serviceStateTracker.getRadioPowerOffReasons().contains(1)) {
            return false;
        }
        return true;
    }

    public SignalStrengthController getSignalStrengthController() {
        Log.wtf(LOG_TAG, "getSignalStrengthController return null.");
        return null;
    }

    public void setVoiceActivationState(int i) {
        this.mSimActivationTracker.setVoiceActivationState(i);
    }

    public void setDataActivationState(int i) {
        this.mSimActivationTracker.setDataActivationState(i);
    }

    public int getVoiceActivationState() {
        return this.mSimActivationTracker.getVoiceActivationState();
    }

    public int getDataActivationState() {
        return this.mSimActivationTracker.getDataActivationState();
    }

    public void updateVoiceMail() {
        Rlog.e(LOG_TAG, "updateVoiceMail() should be overridden");
    }

    public IccCardApplicationStatus.AppType getCurrentUiccAppType() {
        UiccCardApplication uiccCardApplication = this.mUiccApplication.get();
        if (uiccCardApplication != null) {
            return uiccCardApplication.getType();
        }
        return IccCardApplicationStatus.AppType.APPTYPE_UNKNOWN;
    }

    @UnsupportedAppUsage
    public String getIccSerialNumber() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords != null) {
            return iccRecords.getIccId();
        }
        return null;
    }

    public String getFullIccSerialNumber() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords != null) {
            return iccRecords.getFullIccId();
        }
        return null;
    }

    public boolean getIccRecordsLoaded() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords != null) {
            return iccRecords.getRecordsLoaded();
        }
        return false;
    }

    public void setCellInfoMinInterval(int i) {
        getServiceStateTracker().setCellInfoMinInterval(i);
    }

    public List<CellInfo> getAllCellInfo() {
        return getServiceStateTracker().getAllCellInfo();
    }

    public void requestCellInfoUpdate(WorkSource workSource, Message message) {
        getServiceStateTracker().requestAllCellInfo(workSource, message);
    }

    public CellIdentity getCurrentCellIdentity() {
        return getServiceStateTracker().getCellIdentity();
    }

    public void getCellIdentity(WorkSource workSource, Message message) {
        getServiceStateTracker().requestCellIdentity(workSource, message);
    }

    public void setCellInfoListRate(int i, WorkSource workSource) {
        this.mCi.setCellInfoListRate(i, (Message) null, workSource);
    }

    public boolean getMessageWaitingIndicator() {
        return this.mVmCount != 0;
    }

    /* access modifiers changed from: protected */
    public int getCallForwardingIndicatorFromSharedPref() {
        String string;
        int subId = getSubId();
        boolean z = false;
        if (SubscriptionManager.isValidSubscriptionId(subId)) {
            SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(this.mContext);
            int i = defaultSharedPreferences.getInt(CF_STATUS + subId, -1);
            Rlog.d(LOG_TAG, "getCallForwardingIndicatorFromSharedPref: for subId " + subId + "= " + i);
            if (i == -1 && (string = defaultSharedPreferences.getString(CF_ID, (String) null)) != null) {
                if (string.equals(getSubscriberId())) {
                    i = defaultSharedPreferences.getInt(CF_STATUS, 0);
                    if (i == 1) {
                        z = true;
                    }
                    setCallForwardingIndicatorInSharedPref(z);
                    Rlog.d(LOG_TAG, "getCallForwardingIndicatorFromSharedPref: " + i);
                } else {
                    Rlog.d(LOG_TAG, "getCallForwardingIndicatorFromSharedPref: returning DISABLED as status for matching subscriberId not found");
                }
                SharedPreferences.Editor edit = defaultSharedPreferences.edit();
                edit.remove(CF_ID);
                edit.remove(CF_STATUS);
                edit.apply();
            }
            return i;
        }
        Rlog.e(LOG_TAG, "getCallForwardingIndicatorFromSharedPref: invalid subId " + subId);
        return 0;
    }

    /* access modifiers changed from: protected */
    public void setCallForwardingIndicatorInSharedPref(boolean z) {
        int subId = getSubId();
        Rlog.i(LOG_TAG, "setCallForwardingIndicatorInSharedPref: Storing status = " + (z ? 1 : 0) + " in pref " + CF_STATUS + subId);
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(this.mContext).edit();
        StringBuilder sb = new StringBuilder();
        sb.append(CF_STATUS);
        sb.append(subId);
        edit.putInt(sb.toString(), z);
        edit.apply();
    }

    public void setVoiceCallForwardingFlag(int i, boolean z, String str) {
        setCallForwardingIndicatorInSharedPref(z);
        IccRecords iccRecords = getIccRecords();
        if (iccRecords != null) {
            iccRecords.setVoiceCallForwardingFlag(i, z, str);
        }
        notifyCallForwardingIndicator();
    }

    public void setVoiceCallForwardingFlag(IccRecords iccRecords, int i, boolean z, String str) {
        setCallForwardingIndicatorInSharedPref(z);
        if (iccRecords != null) {
            iccRecords.setVoiceCallForwardingFlag(i, z, str);
        }
        notifyCallForwardingIndicator();
    }

    public boolean getCallForwardingIndicator() {
        if (getPhoneType() == 2) {
            Rlog.e(LOG_TAG, "getCallForwardingIndicator: not possible in CDMA");
            return false;
        }
        IccRecords iccRecords = getIccRecords();
        int voiceCallForwardingFlag = iccRecords != null ? iccRecords.getVoiceCallForwardingFlag() : -1;
        if (voiceCallForwardingFlag == -1) {
            voiceCallForwardingFlag = getCallForwardingIndicatorFromSharedPref();
        }
        StringBuilder sb = new StringBuilder();
        sb.append("getCallForwardingIndicator: iccForwardingFlag=");
        sb.append(iccRecords != null ? Integer.valueOf(iccRecords.getVoiceCallForwardingFlag()) : "null");
        sb.append(", sharedPrefFlag=");
        sb.append(getCallForwardingIndicatorFromSharedPref());
        Rlog.v(LOG_TAG, sb.toString());
        if (voiceCallForwardingFlag == 1) {
            return true;
        }
        return false;
    }

    public CarrierSignalAgent getCarrierSignalAgent() {
        return this.mCarrierSignalAgent;
    }

    public CarrierActionAgent getCarrierActionAgent() {
        return this.mCarrierActionAgent;
    }

    public void queryCdmaRoamingPreference(Message message) {
        this.mCi.queryCdmaRoamingPreference(message);
    }

    public void queryCdmaSubscriptionMode(Message message) {
        this.mCi.getCdmaSubscriptionSource(message);
    }

    public SignalStrength getSignalStrength() {
        SignalStrengthController signalStrengthController = getSignalStrengthController();
        if (signalStrengthController == null) {
            return new SignalStrength();
        }
        return signalStrengthController.getSignalStrength();
    }

    public boolean isConcurrentVoiceAndDataAllowed() {
        ServiceStateTracker serviceStateTracker = getServiceStateTracker();
        if (serviceStateTracker == null) {
            return false;
        }
        return serviceStateTracker.isConcurrentVoiceAndDataAllowed();
    }

    public void setCdmaRoamingPreference(int i, Message message) {
        this.mCi.setCdmaRoamingPreference(i, message);
    }

    public void setCdmaSubscriptionMode(int i, Message message) {
        this.mCi.setCdmaSubscriptionSource(i, message);
    }

    private long getEffectiveAllowedNetworkTypes() {
        long allNetworkTypesBitmask = TelephonyManager.getAllNetworkTypesBitmask();
        synchronized (this.mAllowedNetworkTypesForReasons) {
            for (Long longValue : this.mAllowedNetworkTypesForReasons.values()) {
                allNetworkTypesBitmask &= longValue.longValue();
            }
        }
        if (!this.mIsCarrierNrSupported) {
            allNetworkTypesBitmask &= -524289;
        }
        logd("SubId" + getSubId() + ",getEffectiveAllowedNetworkTypes: " + TelephonyManager.convertNetworkTypeBitmaskToString(allNetworkTypesBitmask));
        return allNetworkTypesBitmask;
    }

    public void notifyAllowedNetworkTypesChanged(int i) {
        logd("SubId" + getSubId() + ",notifyAllowedNetworkTypesChanged: reason: " + i + " value:" + TelephonyManager.convertNetworkTypeBitmaskToString(getAllowedNetworkTypes(i)));
        this.mNotifier.notifyAllowedNetworkTypesChanged(this, i, getAllowedNetworkTypes(i));
    }

    public void isNrDualConnectivityEnabled(Message message, WorkSource workSource) {
        this.mCi.isNrDualConnectivityEnabled(message, workSource);
    }

    public void setNrDualConnectivityState(int i, Message message, WorkSource workSource) {
        this.mCi.setNrDualConnectivityState(i, message, workSource);
    }

    public long getAllowedNetworkTypes(int i) {
        long longValue;
        long rafFromNetworkType = (long) RadioAccessFamily.getRafFromNetworkType(RILConstants.PREFERRED_NETWORK_MODE);
        if (TelephonyManager.isValidAllowedNetworkTypesReason(i)) {
            synchronized (this.mAllowedNetworkTypesForReasons) {
                longValue = this.mAllowedNetworkTypesForReasons.getOrDefault(Integer.valueOf(i), Long.valueOf(rafFromNetworkType)).longValue();
            }
            if (!this.mIsCarrierNrSupported && i == 2) {
                longValue = updateAllowedNetworkTypeForCarrierWithCarrierConfig();
            }
            logd("SubId" + getSubId() + ",get allowed network types " + convertAllowedNetworkTypeMapIndexToDbName(i) + ": value = " + TelephonyManager.convertNetworkTypeBitmaskToString(longValue));
            return longValue;
        }
        throw new IllegalArgumentException("AllowedNetworkTypes NumberFormat exception");
    }

    public void loadAllowedNetworksFromSubscriptionDatabase() {
        if (SubscriptionController.getInstance() != null) {
            String subscriptionProperty = SubscriptionController.getInstance().getSubscriptionProperty(getSubId(), "allowed_network_types_for_reasons");
            this.mIsAllowedNetworkTypesLoadedFromDb = SubscriptionManager.isValidSubscriptionId(getSubId());
            if (subscriptionProperty != null) {
                logd("SubId" + getSubId() + ",load allowed network types : value = " + subscriptionProperty);
                HashMap hashMap = new HashMap(this.mAllowedNetworkTypesForReasons);
                this.mAllowedNetworkTypesForReasons.clear();
                try {
                    for (String str : subscriptionProperty.trim().split(",")) {
                        String[] split = str.trim().toLowerCase().split("=");
                        if (split.length != 2) {
                            Rlog.e(LOG_TAG, "Invalid ALLOWED_NETWORK_TYPES from DB, value = " + str);
                        } else {
                            int convertAllowedNetworkTypeDbNameToMapIndex = convertAllowedNetworkTypeDbNameToMapIndex(split[0]);
                            long parseLong = Long.parseLong(split[1]);
                            if (!(convertAllowedNetworkTypeDbNameToMapIndex == -1 || parseLong == -1)) {
                                synchronized (this.mAllowedNetworkTypesForReasons) {
                                    this.mAllowedNetworkTypesForReasons.put(Integer.valueOf(convertAllowedNetworkTypeDbNameToMapIndex), Long.valueOf(parseLong));
                                }
                                if (!hashMap.containsKey(Integer.valueOf(convertAllowedNetworkTypeDbNameToMapIndex)) || ((Long) hashMap.get(Integer.valueOf(convertAllowedNetworkTypeDbNameToMapIndex))).longValue() != parseLong) {
                                    if (hashMap.containsKey(Integer.valueOf(convertAllowedNetworkTypeDbNameToMapIndex))) {
                                        hashMap.remove(Integer.valueOf(convertAllowedNetworkTypeDbNameToMapIndex));
                                    }
                                    notifyAllowedNetworkTypesChanged(convertAllowedNetworkTypeDbNameToMapIndex);
                                }
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    Rlog.e(LOG_TAG, "allowedNetworkTypes NumberFormat exception" + e);
                }
                for (Integer intValue : hashMap.keySet()) {
                    notifyAllowedNetworkTypesChanged(intValue.intValue());
                }
            }
        }
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private int convertAllowedNetworkTypeDbNameToMapIndex(java.lang.String r6) {
        /*
            r5 = this;
            r6.hashCode()
            int r5 = r6.hashCode()
            r0 = 3
            r1 = 2
            r2 = 1
            r3 = 0
            r4 = -1
            switch(r5) {
                case -631655759: goto L_0x0033;
                case 3599307: goto L_0x0027;
                case 106858757: goto L_0x001c;
                case 554360568: goto L_0x0011;
                default: goto L_0x000f;
            }
        L_0x000f:
            r5 = r4
            goto L_0x003d
        L_0x0011:
            java.lang.String r5 = "carrier"
            boolean r5 = r6.equals(r5)
            if (r5 != 0) goto L_0x001a
            goto L_0x000f
        L_0x001a:
            r5 = r0
            goto L_0x003d
        L_0x001c:
            java.lang.String r5 = "power"
            boolean r5 = r6.equals(r5)
            if (r5 != 0) goto L_0x0025
            goto L_0x000f
        L_0x0025:
            r5 = r1
            goto L_0x003d
        L_0x0027:
            java.lang.String r5 = "user"
            boolean r5 = r6.equals(r5)
            if (r5 != 0) goto L_0x0031
            goto L_0x000f
        L_0x0031:
            r5 = r2
            goto L_0x003d
        L_0x0033:
            java.lang.String r5 = "enable_2g"
            boolean r5 = r6.equals(r5)
            if (r5 != 0) goto L_0x003c
            goto L_0x000f
        L_0x003c:
            r5 = r3
        L_0x003d:
            switch(r5) {
                case 0: goto L_0x0044;
                case 1: goto L_0x0043;
                case 2: goto L_0x0042;
                case 3: goto L_0x0041;
                default: goto L_0x0040;
            }
        L_0x0040:
            return r4
        L_0x0041:
            return r1
        L_0x0042:
            return r2
        L_0x0043:
            return r3
        L_0x0044:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.Phone.convertAllowedNetworkTypeDbNameToMapIndex(java.lang.String):int");
    }

    private String convertAllowedNetworkTypeMapIndexToDbName(int i) {
        if (i == 0) {
            return ALLOWED_NETWORK_TYPES_TEXT_USER;
        }
        if (i == 1) {
            return "power";
        }
        if (i != 2) {
            return i != 3 ? Integer.toString(-1) : ALLOWED_NETWORK_TYPES_TEXT_ENABLE_2G;
        }
        return ALLOWED_NETWORK_TYPES_TEXT_CARRIER;
    }

    private long updateAllowedNetworkTypeForCarrierWithCarrierConfig() {
        long longValue;
        long rafFromNetworkType = (long) RadioAccessFamily.getRafFromNetworkType(RILConstants.PREFERRED_NETWORK_MODE);
        synchronized (this.mAllowedNetworkTypesForReasons) {
            longValue = this.mAllowedNetworkTypesForReasons.getOrDefault(2, Long.valueOf(rafFromNetworkType)).longValue();
        }
        if (this.mIsCarrierNrSupported) {
            return longValue;
        }
        long j = longValue & -524289;
        logd("Allowed network types for 'carrier' reason is changed by carrier config = " + TelephonyManager.convertNetworkTypeBitmaskToString(j));
        return j;
    }

    public void setAllowedNetworkTypes(int i, long j, Message message) {
        String str;
        int subId = getSubId();
        if (!TelephonyManager.isValidAllowedNetworkTypesReason(i)) {
            loge("setAllowedNetworkTypes: Invalid allowed network type reason: " + i);
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.INVALID_ARGUMENTS));
                message.sendToTarget();
            }
        } else if (!SubscriptionManager.isUsableSubscriptionId(subId) || !this.mIsAllowedNetworkTypesLoadedFromDb) {
            loge("setAllowedNetworkTypes: no sim or network type is not loaded. SubscriptionId: " + subId + ", isNetworkTypeLoaded" + this.mIsAllowedNetworkTypesLoadedFromDb);
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.MISSING_RESOURCE));
                message.sendToTarget();
            }
        } else {
            synchronized (this.mAllowedNetworkTypesForReasons) {
                this.mAllowedNetworkTypesForReasons.put(Integer.valueOf(i), Long.valueOf(j));
                str = (String) this.mAllowedNetworkTypesForReasons.keySet().stream().map(new Phone$$ExternalSyntheticLambda0(this)).collect(Collectors.joining(","));
            }
            SubscriptionManager.setSubscriptionProperty(subId, "allowed_network_types_for_reasons", str);
            logd("setAllowedNetworkTypes: SubId" + subId + ",setAllowedNetworkTypes " + str);
            updateAllowedNetworkTypes(message);
            notifyAllowedNetworkTypesChanged(i);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ String lambda$setAllowedNetworkTypes$0(Integer num) {
        return convertAllowedNetworkTypeMapIndexToDbName(num.intValue()) + "=" + this.mAllowedNetworkTypesForReasons.get(num);
    }

    /* access modifiers changed from: protected */
    public void updateAllowedNetworkTypes(Message message) {
        int radioAccessFamily = getRadioAccessFamily();
        if (radioAccessFamily == 0) {
            Rlog.d(LOG_TAG, "setPreferredNetworkType: Abort, unknown RAF: " + radioAccessFamily);
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.GENERIC_FAILURE));
                message.sendToTarget();
                return;
            }
            return;
        }
        long j = (long) radioAccessFamily;
        int effectiveAllowedNetworkTypes = (int) (getEffectiveAllowedNetworkTypes() & j);
        logd("setAllowedNetworkTypes: modemRafBitMask = " + radioAccessFamily + " ,modemRaf = " + TelephonyManager.convertNetworkTypeBitmaskToString(j) + " ,filteredRafBitMask = " + effectiveAllowedNetworkTypes + " ,filteredRaf = " + TelephonyManager.convertNetworkTypeBitmaskToString((long) effectiveAllowedNetworkTypes));
        this.mCi.setAllowedNetworkTypesBitmap(effectiveAllowedNetworkTypes, message);
        this.mPreferredNetworkTypeRegistrants.notifyRegistrants();
    }

    public void getAllowedNetworkTypesBitmask(Message message) {
        this.mCi.getAllowedNetworkTypesBitmap(message);
    }

    public void registerForPreferredNetworkTypeChanged(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mPreferredNetworkTypeRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForPreferredNetworkTypeChanged(Handler handler) {
        this.mPreferredNetworkTypeRegistrants.remove(handler);
    }

    public int getCachedAllowedNetworkTypesBitmask() {
        CommandsInterface commandsInterface = this.mCi;
        if (commandsInterface == null || !(commandsInterface instanceof BaseCommands)) {
            return RadioAccessFamily.getRafFromNetworkType(RILConstants.PREFERRED_NETWORK_MODE);
        }
        return ((BaseCommands) commandsInterface).mAllowedNetworkTypesBitmask;
    }

    @UnsupportedAppUsage
    public void getSmscAddress(Message message) {
        this.mCi.getSmscAddress(message);
    }

    @UnsupportedAppUsage
    public void setSmscAddress(String str, Message message) {
        this.mCi.setSmscAddress(str, message);
    }

    public void setTTYMode(int i, Message message) {
        this.mCi.setTTYMode(i, message);
    }

    public void setUiTTYMode(int i, Message message) {
        Rlog.d(LOG_TAG, "unexpected setUiTTYMode method call");
    }

    public void queryTTYMode(Message message) {
        this.mCi.queryTTYMode(message);
    }

    public void setBandMode(int i, Message message) {
        this.mCi.setBandMode(i, message);
    }

    public void queryAvailableBandMode(Message message) {
        this.mCi.queryAvailableBandMode(message);
    }

    @UnsupportedAppUsage
    @Deprecated
    public void invokeOemRilRequestRaw(byte[] bArr, Message message) {
        this.mCi.invokeOemRilRequestRaw(bArr, message);
    }

    @UnsupportedAppUsage
    @Deprecated
    public void invokeOemRilRequestStrings(String[] strArr, Message message) {
        this.mCi.invokeOemRilRequestStrings(strArr, message);
    }

    public void nvReadItem(int i, Message message, WorkSource workSource) {
        this.mCi.nvReadItem(i, message, workSource);
    }

    public void nvWriteItem(int i, String str, Message message, WorkSource workSource) {
        this.mCi.nvWriteItem(i, str, message, workSource);
    }

    public void nvWriteCdmaPrl(byte[] bArr, Message message) {
        this.mCi.nvWriteCdmaPrl(bArr, message);
    }

    public void rebootModem(Message message) {
        this.mCi.nvResetConfig(1, message);
    }

    public void resetModemConfig(Message message) {
        this.mCi.nvResetConfig(3, message);
    }

    public void eraseModemConfig(Message message) {
        this.mCi.nvResetConfig(2, message);
    }

    public boolean eraseDataInSharedPreferences() {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(getContext()).edit();
        Rlog.d(LOG_TAG, "Erase all data saved in SharedPreferences");
        edit.clear();
        return edit.commit();
    }

    public void setSystemSelectionChannels(List<RadioAccessSpecifier> list, Message message) {
        this.mCi.setSystemSelectionChannels(list, message);
    }

    public void getSystemSelectionChannels(Message message) {
        this.mCi.getSystemSelectionChannels(message);
    }

    public void notifyDataActivity() {
        this.mNotifier.notifyDataActivity(this);
    }

    private void notifyMessageWaitingIndicator() {
        if (this.mIsVoiceCapable) {
            this.mNotifier.notifyMessageWaitingChanged(this);
        }
    }

    public void notifyDataConnection(PreciseDataConnectionState preciseDataConnectionState) {
        this.mNotifier.notifyDataConnection(this, preciseDataConnectionState);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void notifyOtaspChanged(int i) {
        this.mOtaspRegistrants.notifyRegistrants(new AsyncResult((Object) null, Integer.valueOf(i), (Throwable) null));
    }

    public void notifyVoiceActivationStateChanged(int i) {
        this.mNotifier.notifyVoiceActivationStateChanged(this, i);
    }

    public void notifyDataActivationStateChanged(int i) {
        this.mNotifier.notifyDataActivationStateChanged(this, i);
    }

    public void notifyUserMobileDataStateChanged(boolean z) {
        this.mNotifier.notifyUserMobileDataStateChanged(this, z);
    }

    public void notifyDisplayInfoChanged(TelephonyDisplayInfo telephonyDisplayInfo) {
        this.mNotifier.notifyDisplayInfoChanged(this, telephonyDisplayInfo);
    }

    public void notifySignalStrength() {
        this.mNotifier.notifySignalStrength(this);
    }

    public PhoneConstants.DataState getDataConnectionState(String str) {
        return PhoneConstants.DataState.DISCONNECTED;
    }

    public void notifyCellInfo(List<CellInfo> list) {
        this.mCellInfoRegistrants.notifyRegistrants(new AsyncResult((Object) null, list, (Throwable) null));
        this.mNotifier.notifyCellInfo(this, list);
    }

    public void registerForPhysicalChannelConfig(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        Registrant registrant = new Registrant(handler, i, obj);
        this.mPhysicalChannelConfigRegistrants.add(registrant);
        List<PhysicalChannelConfig> physicalChannelConfigList = getPhysicalChannelConfigList();
        if (physicalChannelConfigList != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, physicalChannelConfigList, (Throwable) null));
        }
    }

    public void unregisterForPhysicalChannelConfig(Handler handler) {
        this.mPhysicalChannelConfigRegistrants.remove(handler);
    }

    public void notifyPhysicalChannelConfig(List<PhysicalChannelConfig> list) {
        this.mPhysicalChannelConfigRegistrants.notifyRegistrants(new AsyncResult((Object) null, list, (Throwable) null));
        this.mNotifier.notifyPhysicalChannelConfig(this, list);
    }

    public void notifySrvccStateChanged(int i) {
        this.mNotifier.notifySrvccStateChanged(this, i);
    }

    public void notifyEmergencyNumberList() {
        this.mNotifier.notifyEmergencyNumberList(this);
    }

    public void notifyOutgoingEmergencySms(EmergencyNumber emergencyNumber) {
        this.mNotifier.notifyOutgoingEmergencySms(this, emergencyNumber);
    }

    public void notifyDataEnabled(boolean z, int i) {
        this.mNotifier.notifyDataEnabled(this, z, i);
    }

    public void notifyLinkCapacityEstimateChanged(List<LinkCapacityEstimate> list) {
        this.mNotifier.notifyLinkCapacityEstimateChanged(this, list);
    }

    protected static boolean getInEcmMode() {
        return TelephonyProperties.in_ecm_mode().orElse(Boolean.FALSE).booleanValue();
    }

    public boolean isInEcm() {
        return this.mIsPhoneInEcmState;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:4:0x000d, code lost:
        r2 = r2.mImsPhone;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isInCdmaEcm() {
        /*
            r2 = this;
            int r0 = r2.getPhoneType()
            r1 = 2
            if (r0 != r1) goto L_0x0019
            boolean r0 = r2.isInEcm()
            if (r0 == 0) goto L_0x0019
            com.android.internal.telephony.Phone r2 = r2.mImsPhone
            if (r2 == 0) goto L_0x0017
            boolean r2 = r2.isInImsEcm()
            if (r2 != 0) goto L_0x0019
        L_0x0017:
            r2 = 1
            goto L_0x001a
        L_0x0019:
            r2 = 0
        L_0x001a:
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.Phone.isInCdmaEcm():boolean");
    }

    public void setIsInEcm(boolean z) {
        if (!getUnitTestMode()) {
            TelephonyProperties.in_ecm_mode(Boolean.valueOf(z));
        }
        this.mIsPhoneInEcmState = z;
    }

    public boolean isEcmCanceledForEmergency() {
        return this.mEcmCanceledForEmergency;
    }

    public void setEcmCanceledForEmergency(boolean z) {
        this.mEcmCanceledForEmergency = z;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static int getVideoState(Call call) {
        Connection earliestConnection = call.getEarliestConnection();
        if (earliestConnection != null) {
            return earliestConnection.getVideoState();
        }
        return 0;
    }

    private boolean isVideoCallOrConference(Call call) {
        if (call.isMultiparty()) {
            return true;
        }
        if (!(call instanceof ImsPhoneCall)) {
            return false;
        }
        ImsCall imsCall = ((ImsPhoneCall) call).getImsCall();
        if (imsCall == null || (!imsCall.isVideoCall() && !imsCall.wasVideoCall())) {
            return false;
        }
        return true;
    }

    public boolean isImsVideoCallOrConferencePresent() {
        Phone phone = this.mImsPhone;
        boolean z = false;
        if (phone != null && (isVideoCallOrConference(phone.getForegroundCall()) || isVideoCallOrConference(this.mImsPhone.getBackgroundCall()) || isVideoCallOrConference(this.mImsPhone.getRingingCall()))) {
            z = true;
        }
        Rlog.d(LOG_TAG, "isImsVideoCallOrConferencePresent: " + z);
        return z;
    }

    public int getVoiceMessageCount() {
        return this.mVmCount;
    }

    public void setVoiceMessageCount(int i) {
        this.mVmCount = i;
        int subId = getSubId();
        if (SubscriptionManager.isValidSubscriptionId(subId)) {
            Rlog.d(LOG_TAG, "setVoiceMessageCount: Storing Voice Mail Count = " + i + " for mVmCountKey = " + VM_COUNT + subId + " in preferences.");
            SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(this.mContext).edit();
            StringBuilder sb = new StringBuilder();
            sb.append(VM_COUNT);
            sb.append(subId);
            edit.putInt(sb.toString(), i);
            edit.apply();
        } else {
            Rlog.e(LOG_TAG, "setVoiceMessageCount in sharedPreference: invalid subId " + subId);
        }
        IccRecords iccRecords = UiccController.getInstance().getIccRecords(this.mPhoneId, 1);
        if (iccRecords != null) {
            Rlog.d(LOG_TAG, "setVoiceMessageCount: updating SIM Records");
            iccRecords.setVoiceMessageWaiting(1, i);
        } else {
            Rlog.d(LOG_TAG, "setVoiceMessageCount: SIM Records not found");
        }
        notifyMessageWaitingIndicator();
    }

    /* access modifiers changed from: protected */
    public int getStoredVoiceMessageCount() {
        int subId = getSubId();
        int i = 0;
        if (SubscriptionManager.isValidSubscriptionId(subId)) {
            SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(this.mContext);
            int i2 = defaultSharedPreferences.getInt(VM_COUNT + subId, -2);
            if (i2 != -2) {
                Rlog.d(LOG_TAG, "getStoredVoiceMessageCount: from preference for subId " + subId + "= " + i2);
                return i2;
            }
            String string = defaultSharedPreferences.getString(VM_ID, (String) null);
            if (string == null) {
                return 0;
            }
            String subscriberId = getSubscriberId();
            if (subscriberId == null || !subscriberId.equals(string)) {
                Rlog.d(LOG_TAG, "getStoredVoiceMessageCount: returning 0 as count for matching subscriberId not found");
            } else {
                i = defaultSharedPreferences.getInt(VM_COUNT, 0);
                setVoiceMessageCount(i);
                Rlog.d(LOG_TAG, "getStoredVoiceMessageCount: from preference = " + i);
            }
            SharedPreferences.Editor edit = defaultSharedPreferences.edit();
            edit.remove(VM_ID);
            edit.remove(VM_COUNT);
            edit.apply();
            return i;
        }
        Rlog.e(LOG_TAG, "getStoredVoiceMessageCount: invalid subId " + subId);
        return 0;
    }

    public void sendDialerSpecialCode(String str) {
        if (!TextUtils.isEmpty(str)) {
            BroadcastOptions makeBasic = BroadcastOptions.makeBasic();
            makeBasic.setBackgroundActivityStartsAllowed(true);
            Intent intent = new Intent("android.provider.Telephony.SECRET_CODE", Uri.parse("android_secret_code://" + str));
            intent.addFlags(268435456);
            this.mContext.sendBroadcast(intent, (String) null, makeBasic.toBundle());
            Intent intent2 = new Intent("android.telephony.action.SECRET_CODE", Uri.parse("android_secret_code://" + str));
            intent2.addFlags(268435456);
            this.mContext.sendBroadcast(intent2, (String) null, makeBasic.toBundle());
        }
    }

    @UnsupportedAppUsage
    public void setOnPostDialCharacter(Handler handler, int i, Object obj) {
        this.mPostDialHandler = new Registrant(handler, i, obj);
    }

    public Registrant getPostDialHandler() {
        return this.mPostDialHandler;
    }

    public void registerForOtaspChange(Handler handler, int i, Object obj) {
        checkCorrectThread(handler);
        this.mOtaspRegistrants.addUnique(handler, i, obj);
        new Registrant(handler, i, obj).notifyRegistrant(new AsyncResult((Object) null, Integer.valueOf(getOtasp()), (Throwable) null));
    }

    public void unregisterForOtaspChange(Handler handler) {
        this.mOtaspRegistrants.remove(handler);
    }

    public void registerForSignalInfo(Handler handler, int i, Object obj) {
        this.mCi.registerForSignalInfo(handler, i, obj);
    }

    public void unregisterForSignalInfo(Handler handler) {
        this.mCi.unregisterForSignalInfo(handler);
    }

    public void registerForDisplayInfo(Handler handler, int i, Object obj) {
        this.mCi.registerForDisplayInfo(handler, i, obj);
    }

    public void unregisterForDisplayInfo(Handler handler) {
        this.mCi.unregisterForDisplayInfo(handler);
    }

    public void registerForNumberInfo(Handler handler, int i, Object obj) {
        this.mCi.registerForNumberInfo(handler, i, obj);
    }

    public void unregisterForNumberInfo(Handler handler) {
        this.mCi.unregisterForNumberInfo(handler);
    }

    public void registerForRedirectedNumberInfo(Handler handler, int i, Object obj) {
        this.mCi.registerForRedirectedNumberInfo(handler, i, obj);
    }

    public void unregisterForRedirectedNumberInfo(Handler handler) {
        this.mCi.unregisterForRedirectedNumberInfo(handler);
    }

    public void registerForLineControlInfo(Handler handler, int i, Object obj) {
        this.mCi.registerForLineControlInfo(handler, i, obj);
    }

    public void unregisterForLineControlInfo(Handler handler) {
        this.mCi.unregisterForLineControlInfo(handler);
    }

    public void registerFoT53ClirlInfo(Handler handler, int i, Object obj) {
        this.mCi.registerFoT53ClirlInfo(handler, i, obj);
    }

    public void unregisterForT53ClirInfo(Handler handler) {
        this.mCi.unregisterForT53ClirInfo(handler);
    }

    public void registerForT53AudioControlInfo(Handler handler, int i, Object obj) {
        this.mCi.registerForT53AudioControlInfo(handler, i, obj);
    }

    public void unregisterForT53AudioControlInfo(Handler handler) {
        this.mCi.unregisterForT53AudioControlInfo(handler);
    }

    public void registerForRadioOffOrNotAvailable(Handler handler, int i, Object obj) {
        this.mRadioOffOrNotAvailableRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForRadioOffOrNotAvailable(Handler handler) {
        this.mRadioOffOrNotAvailableRegistrants.remove(handler);
    }

    private String getProvisioningUrlBaseFromFile() {
        String attributeValue;
        String attributeValue2;
        Configuration configuration = this.mContext.getResources().getConfiguration();
        try {
            FileReader fileReader = new FileReader(this.mProvisioningUrlFile);
            try {
                XmlPullParser newPullParser = Xml.newPullParser();
                newPullParser.setInput(fileReader);
                XmlUtils.beginDocument(newPullParser, TAG_PROVISIONING_URLS);
                while (true) {
                    XmlUtils.nextElement(newPullParser);
                    String name = newPullParser.getName();
                    if (name == null) {
                        fileReader.close();
                        return null;
                    } else if (name.equals(TAG_PROVISIONING_URL) && (attributeValue = newPullParser.getAttributeValue((String) null, ATTR_MCC)) != null) {
                        if (Integer.parseInt(attributeValue) == configuration.mcc && (attributeValue2 = newPullParser.getAttributeValue((String) null, ATTR_MNC)) != null && Integer.parseInt(attributeValue2) == configuration.mnc) {
                            newPullParser.next();
                            if (newPullParser.getEventType() == 4) {
                                String text = newPullParser.getText();
                                fileReader.close();
                                return text;
                            }
                        }
                    }
                }
            } catch (NumberFormatException e) {
                Rlog.e(LOG_TAG, "Exception in getProvisioningUrlBaseFromFile: " + e);
            } catch (Throwable th) {
                fileReader.close();
                throw th;
            }
        } catch (FileNotFoundException unused) {
            Rlog.e(LOG_TAG, "Carrier Provisioning Urls file not found");
            return null;
        } catch (XmlPullParserException e2) {
            Rlog.e(LOG_TAG, "Xml parser exception reading Carrier Provisioning Urls file: " + e2);
            return null;
        } catch (IOException e3) {
            Rlog.e(LOG_TAG, "I/O exception reading Carrier Provisioning Urls file: " + e3);
            return null;
        } catch (Throwable th2) {
            th.addSuppressed(th2);
        }
    }

    public String getMobileProvisioningUrl() {
        String provisioningUrlBaseFromFile = getProvisioningUrlBaseFromFile();
        if (TextUtils.isEmpty(provisioningUrlBaseFromFile)) {
            provisioningUrlBaseFromFile = this.mContext.getResources().getString(17040840);
            Rlog.d(LOG_TAG, "getMobileProvisioningUrl: url from resource =" + provisioningUrlBaseFromFile);
        } else {
            Rlog.d(LOG_TAG, "getMobileProvisioningUrl: url from File =" + provisioningUrlBaseFromFile);
        }
        if (TextUtils.isEmpty(provisioningUrlBaseFromFile)) {
            return provisioningUrlBaseFromFile;
        }
        String line1Number = getLine1Number();
        if (TextUtils.isEmpty(line1Number)) {
            line1Number = "0000000000";
        }
        return String.format(provisioningUrlBaseFromFile, new Object[]{getIccSerialNumber(), getDeviceId(), line1Number});
    }

    public boolean hasMatchedTetherApnSetting() {
        if (isUsingNewDataStack()) {
            NetworkRegistrationInfo networkRegistrationInfo = getServiceState().getNetworkRegistrationInfo(2, 1);
            if (networkRegistrationInfo != null) {
                return getDataNetworkController().getDataProfileManager().isTetheringDataProfileExisting(networkRegistrationInfo.getAccessNetworkTechnology());
            }
            return false;
        } else if (getDcTracker(1) != null) {
            return getDcTracker(1).hasMatchedTetherApnSetting();
        } else {
            return false;
        }
    }

    public boolean isDataAllowed() {
        if (isUsingNewDataStack()) {
            return getDataNetworkController().isInternetDataAllowed();
        }
        return isDataAllowed(17, (DataConnectionReasons) null);
    }

    public boolean isDataAllowed(int i, DataConnectionReasons dataConnectionReasons) {
        AccessNetworksManager accessNetworksManager = this.mAccessNetworksManager;
        if (accessNetworksManager == null) {
            return false;
        }
        int currentTransport = accessNetworksManager.getCurrentTransport(i);
        if (getDcTracker(currentTransport) != null) {
            return getDcTracker(currentTransport).isDataAllowed(dataConnectionReasons);
        }
        return false;
    }

    public void carrierActionSetMeteredApnsEnabled(boolean z) {
        this.mCarrierActionAgent.carrierActionSetMeteredApnsEnabled(z);
    }

    public void carrierActionSetRadioEnabled(boolean z) {
        this.mCarrierActionAgent.carrierActionSetRadioEnabled(z);
    }

    public void carrierActionReportDefaultNetworkStatus(boolean z) {
        this.mCarrierActionAgent.carrierActionReportDefaultNetworkStatus(z);
    }

    public void carrierActionResetAll() {
        this.mCarrierActionAgent.carrierActionReset();
    }

    public void notifyNewRingingConnectionP(Connection connection) {
        Rlog.i(LOG_TAG, String.format("notifyNewRingingConnection: phoneId=[%d], connection=[%s], registrants=[%s]", new Object[]{Integer.valueOf(getPhoneId()), connection, getNewRingingConnectionRegistrantsAsString()}));
        if (this.mIsVoiceCapable) {
            this.mNewRingingConnectionRegistrants.notifyRegistrants(new AsyncResult((Object) null, connection, (Throwable) null));
        }
    }

    private String getNewRingingConnectionRegistrantsAsString() {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < this.mNewRingingConnectionRegistrants.size(); i++) {
            arrayList.add(this.mNewRingingConnectionRegistrants.get(i).toString());
        }
        return String.join(", ", arrayList);
    }

    public void notifyUnknownConnectionP(Connection connection) {
        this.mUnknownConnectionRegistrants.notifyResult(connection);
    }

    public void notifyForVideoCapabilityChanged(boolean z) {
        this.mIsVideoCapable = z;
        this.mVideoCapabilityChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, Boolean.valueOf(z), (Throwable) null));
    }

    private void notifyIncomingRing() {
        if (this.mIsVoiceCapable) {
            this.mIncomingRingRegistrants.notifyRegistrants(new AsyncResult((Object) null, this, (Throwable) null));
        }
    }

    private void sendIncomingCallRingNotification(int i) {
        if (!this.mIsVoiceCapable || this.mDoesRilSendMultipleCallRing || i != this.mCallRingContinueToken) {
            Rlog.d(LOG_TAG, "Ignoring ring notification request, mDoesRilSendMultipleCallRing=" + this.mDoesRilSendMultipleCallRing + " token=" + i + " mCallRingContinueToken=" + this.mCallRingContinueToken + " mIsVoiceCapable=" + this.mIsVoiceCapable);
            return;
        }
        Rlog.d(LOG_TAG, "Sending notifyIncomingRing");
        notifyIncomingRing();
        sendMessageDelayed(obtainMessage(15, i, 0), (long) this.mCallRingDelay);
    }

    public void setAlwaysReportSignalStrength(boolean z) {
        DeviceStateMonitor deviceStateMonitor = this.mDeviceStateMonitor;
        if (deviceStateMonitor != null) {
            deviceStateMonitor.setAlwaysReportSignalStrength(z);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IsimRecords getIsimRecords() {
        Rlog.e(LOG_TAG, "getIsimRecords() is only supported on LTE devices");
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public PhoneConstants.DataState getDataConnectionState() {
        return getDataConnectionState("default");
    }

    public void setVoiceMessageWaiting(int i, int i2) {
        Rlog.e(LOG_TAG, "Error! This function should never be executed, inactive Phone.");
    }

    public UsimServiceTable getUsimServiceTable() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords != null) {
            return iccRecords.getUsimServiceTable();
        }
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public UiccCard getUiccCard() {
        return this.mUiccController.getUiccCard(this.mPhoneId);
    }

    public UiccPort getUiccPort() {
        return this.mUiccController.getUiccPort(this.mPhoneId);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Phone getImsPhone() {
        return this.mImsPhone;
    }

    @VisibleForTesting
    public void setImsPhone(ImsPhone imsPhone) {
        this.mImsPhone = imsPhone;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isUtEnabled() {
        Phone phone = this.mImsPhone;
        if (phone != null) {
            return phone.isUtEnabled();
        }
        return false;
    }

    @UnsupportedAppUsage
    public int getSubId() {
        if (SubscriptionController.getInstance() != null) {
            return SubscriptionController.getInstance().getSubIdUsingPhoneId(this.mPhoneId);
        }
        Rlog.e(LOG_TAG, "SubscriptionController.getInstance = null! Returning default subId");
        return Integer.MAX_VALUE;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getPhoneId() {
        return this.mPhoneId;
    }

    public boolean setRoamingOverride(List<String> list, List<String> list2, List<String> list3, List<String> list4) {
        String iccSerialNumber = getIccSerialNumber();
        if (TextUtils.isEmpty(iccSerialNumber)) {
            return false;
        }
        setRoamingOverrideHelper(list, GSM_ROAMING_LIST_OVERRIDE_PREFIX, iccSerialNumber);
        setRoamingOverrideHelper(list2, GSM_NON_ROAMING_LIST_OVERRIDE_PREFIX, iccSerialNumber);
        setRoamingOverrideHelper(list3, CDMA_ROAMING_LIST_OVERRIDE_PREFIX, iccSerialNumber);
        setRoamingOverrideHelper(list4, CDMA_NON_ROAMING_LIST_OVERRIDE_PREFIX, iccSerialNumber);
        ServiceStateTracker serviceStateTracker = getServiceStateTracker();
        if (serviceStateTracker == null) {
            return true;
        }
        serviceStateTracker.pollState();
        return true;
    }

    private void setRoamingOverrideHelper(List<String> list, String str, String str2) {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(this.mContext).edit();
        String str3 = str + str2;
        if (list == null || list.isEmpty()) {
            edit.remove(str3).commit();
        } else {
            edit.putStringSet(str3, new HashSet(list)).commit();
        }
    }

    public boolean isMccMncMarkedAsRoaming(String str) {
        return getRoamingOverrideHelper(GSM_ROAMING_LIST_OVERRIDE_PREFIX, str);
    }

    public boolean isMccMncMarkedAsNonRoaming(String str) {
        return getRoamingOverrideHelper(GSM_NON_ROAMING_LIST_OVERRIDE_PREFIX, str);
    }

    public boolean isSidMarkedAsRoaming(int i) {
        return getRoamingOverrideHelper(CDMA_ROAMING_LIST_OVERRIDE_PREFIX, Integer.toString(i));
    }

    public boolean isSidMarkedAsNonRoaming(int i) {
        return getRoamingOverrideHelper(CDMA_NON_ROAMING_LIST_OVERRIDE_PREFIX, Integer.toString(i));
    }

    public boolean isImsRegistered() {
        boolean z;
        Phone phone = this.mImsPhone;
        if (phone != null) {
            z = phone.isImsRegistered();
        } else {
            ServiceStateTracker serviceStateTracker = getServiceStateTracker();
            z = serviceStateTracker != null ? serviceStateTracker.isImsRegistered() : false;
        }
        Rlog.d(LOG_TAG, "isImsRegistered =" + z);
        return z;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isWifiCallingEnabled() {
        Phone phone = this.mImsPhone;
        boolean isWifiCallingEnabled = phone != null ? phone.isWifiCallingEnabled() : false;
        Rlog.d(LOG_TAG, "isWifiCallingEnabled =" + isWifiCallingEnabled);
        return isWifiCallingEnabled;
    }

    public boolean isImsCapabilityAvailable(int i, int i2) throws ImsException {
        Phone phone = this.mImsPhone;
        boolean isImsCapabilityAvailable = phone != null ? phone.isImsCapabilityAvailable(i, i2) : false;
        Rlog.d(LOG_TAG, "isImsCapabilityAvailable, capability=" + i + ", regTech=" + i2 + ", isAvailable=" + isImsCapabilityAvailable);
        return isImsCapabilityAvailable;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public boolean isVolteEnabled() {
        return isVoiceOverCellularImsEnabled();
    }

    public boolean isVoiceOverCellularImsEnabled() {
        Phone phone = this.mImsPhone;
        boolean isVoiceOverCellularImsEnabled = phone != null ? phone.isVoiceOverCellularImsEnabled() : false;
        Rlog.d(LOG_TAG, "isVoiceOverCellularImsEnabled=" + isVoiceOverCellularImsEnabled);
        return isVoiceOverCellularImsEnabled;
    }

    public int getImsRegistrationTech() {
        Phone phone = this.mImsPhone;
        int imsRegistrationTech = phone != null ? phone.getImsRegistrationTech() : -1;
        Rlog.d(LOG_TAG, "getImsRegistrationTechnology =" + imsRegistrationTech);
        return imsRegistrationTech;
    }

    public void getImsRegistrationTech(Consumer<Integer> consumer) {
        Phone phone = this.mImsPhone;
        if (phone != null) {
            phone.getImsRegistrationTech(consumer);
        } else {
            consumer.accept(-1);
        }
    }

    public void getImsRegistrationState(Consumer<Integer> consumer) {
        Phone phone = this.mImsPhone;
        if (phone != null) {
            phone.getImsRegistrationState(consumer);
        } else {
            consumer.accept(0);
        }
    }

    private boolean getRoamingOverrideHelper(String str, String str2) {
        String iccSerialNumber = getIccSerialNumber();
        if (TextUtils.isEmpty(iccSerialNumber) || TextUtils.isEmpty(str2)) {
            return false;
        }
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(this.mContext);
        Set<String> stringSet = defaultSharedPreferences.getStringSet(str + iccSerialNumber, (Set) null);
        if (stringSet == null) {
            return false;
        }
        return stringSet.contains(str2);
    }

    public int getRadioPowerState() {
        return this.mCi.getRadioState();
    }

    public boolean isRadioAvailable() {
        return this.mCi.getRadioState() != 2;
    }

    public boolean isRadioOn() {
        return this.mCi.getRadioState() == 1;
    }

    public void shutdownRadio() {
        getServiceStateTracker().requestShutdown();
    }

    public boolean isShuttingDown() {
        return getServiceStateTracker().isDeviceShuttingDown();
    }

    public void setRadioCapability(RadioCapability radioCapability, Message message) {
        this.mCi.setRadioCapability(radioCapability, message);
    }

    public int getRadioAccessFamily() {
        RadioCapability radioCapability = getRadioCapability();
        if (radioCapability == null) {
            return 0;
        }
        return radioCapability.getRadioAccessFamily();
    }

    public String getModemUuId() {
        RadioCapability radioCapability = getRadioCapability();
        if (radioCapability == null) {
            return "";
        }
        return radioCapability.getLogicalModemUuid();
    }

    public RadioCapability getRadioCapability() {
        return this.mRadioCapability.get();
    }

    public void radioCapabilityUpdated(RadioCapability radioCapability, boolean z) {
        this.mRadioCapability.set(radioCapability);
        if (SubscriptionManager.isValidSubscriptionId(getSubId())) {
            sendSubscriptionSettings(!this.mContext.getResources().getBoolean(17891862));
        }
        if (z) {
            this.mCi.getDeviceIdentity(obtainMessage(21));
        }
    }

    public void sendSubscriptionSettings(boolean z) {
        if (this.mIsAllowedNetworkTypesLoadedFromDb) {
            updateAllowedNetworkTypes((Message) null);
        }
        if (z) {
            restoreSavedNetworkSelection((Message) null);
        }
        updateUsageSetting();
    }

    private int getResolvedUsageSetting(int i) {
        SubscriptionInfo subscriptionInfo = SubscriptionController.getInstance().getSubscriptionInfo(i);
        if (subscriptionInfo == null || subscriptionInfo.getUsageSetting() == -1) {
            loge("Failed to get SubscriptionInfo for subId=" + i);
            return -1;
        } else if (subscriptionInfo.getUsageSetting() != 0) {
            return subscriptionInfo.getUsageSetting();
        } else {
            if (subscriptionInfo.isOpportunistic()) {
                return 2;
            }
            return this.mContext.getResources().getInteger(17694804);
        }
    }

    public boolean updateUsageSetting() {
        if (!this.mIsUsageSettingSupported) {
            return false;
        }
        int subId = getSubId();
        if (!SubscriptionManager.isValidSubscriptionId(subId)) {
            return false;
        }
        int i = this.mPreferredUsageSetting;
        int resolvedUsageSetting = getResolvedUsageSetting(subId);
        this.mPreferredUsageSetting = resolvedUsageSetting;
        if (resolvedUsageSetting == -1) {
            loge("Usage Setting is Supported but Preferred Setting Unknown!");
            return false;
        } else if (resolvedUsageSetting == i) {
            return false;
        } else {
            String str = "mPreferredUsageSetting=" + this.mPreferredUsageSetting + ", lastPreferredUsageSetting=" + i + ", mUsageSettingFromModem=" + this.mUsageSettingFromModem;
            logd(str);
            this.mLocalLog.log(str);
            int i2 = this.mUsageSettingFromModem;
            if (i2 == -1) {
                this.mCi.getUsageSetting(obtainMessage(63));
                return true;
            } else if (this.mPreferredUsageSetting == i2) {
                return true;
            } else {
                this.mCi.setUsageSetting(obtainMessage(64), this.mPreferredUsageSetting);
                return true;
            }
        }
    }

    public void registerForRadioCapabilityChanged(Handler handler, int i, Object obj) {
        this.mCi.registerForRadioCapabilityChanged(handler, i, obj);
    }

    public void unregisterForRadioCapabilityChanged(Handler handler) {
        this.mCi.unregisterForRadioCapabilityChanged(this);
    }

    public boolean isImsAvailable() {
        Phone phone = this.mImsPhone;
        if (phone == null) {
            return false;
        }
        return phone.isImsAvailable();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isVideoEnabled() {
        Phone phone = this.mImsPhone;
        if (phone != null) {
            return phone.isVideoEnabled();
        }
        return false;
    }

    public int getLceStatus() {
        return this.mLceStatus;
    }

    public void getModemActivityInfo(Message message, WorkSource workSource) {
        this.mCi.getModemActivityInfo(message, workSource);
    }

    public void startLceAfterRadioIsAvailable() {
        this.mCi.startLceService(200, true, obtainMessage(37));
    }

    public void setDataThrottling(Message message, WorkSource workSource, int i, long j) {
        this.mCi.setDataThrottling(message, workSource, i, j);
    }

    public void setAllowedCarriers(CarrierRestrictionRules carrierRestrictionRules, Message message, WorkSource workSource) {
        this.mCi.setAllowedCarriers(carrierRestrictionRules, message, workSource);
    }

    public void getAllowedCarriers(Message message, WorkSource workSource) {
        this.mCi.getAllowedCarriers(message, workSource);
    }

    public Locale getLocaleFromSimAndCarrierPrefs() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords == null || iccRecords.getSimLanguage() == null) {
            return getLocaleFromCarrierProperties();
        }
        return new Locale(iccRecords.getSimLanguage());
    }

    public boolean areAllDataDisconnected() {
        AccessNetworksManager accessNetworksManager = this.mAccessNetworksManager;
        if (accessNetworksManager == null) {
            return true;
        }
        for (int i : accessNetworksManager.getAvailableTransports()) {
            if (getDcTracker(i) != null && !getDcTracker(i).areAllDataDisconnected()) {
                return false;
            }
        }
        return true;
    }

    public void registerForAllDataDisconnected(Handler handler, int i) {
        this.mAllDataDisconnectedRegistrants.addUnique(handler, i, (Object) null);
        AccessNetworksManager accessNetworksManager = this.mAccessNetworksManager;
        if (accessNetworksManager != null) {
            for (int i2 : accessNetworksManager.getAvailableTransports()) {
                if (getDcTracker(i2) != null && !getDcTracker(i2).areAllDataDisconnected()) {
                    getDcTracker(i2).registerForAllDataDisconnected(this, 52);
                }
            }
        }
    }

    public void unregisterForAllDataDisconnected(Handler handler) {
        this.mAllDataDisconnectedRegistrants.remove(handler);
    }

    public DataEnabledSettings getDataEnabledSettings() {
        return this.mDataEnabledSettings;
    }

    /* access modifiers changed from: protected */
    public boolean isMatchGid(String str) {
        String groupIdLevel1 = getGroupIdLevel1();
        int length = str.length();
        if (TextUtils.isEmpty(groupIdLevel1) || groupIdLevel1.length() < length || !groupIdLevel1.substring(0, length).equalsIgnoreCase(str)) {
            return false;
        }
        return true;
    }

    public static void checkWfcWifiOnlyModeBeforeDial(Phone phone, int i, Context context) throws CallStateException {
        if (phone == null || !phone.isWifiCallingEnabled()) {
            ImsManager instance = ImsManager.getInstance(context, i);
            if (instance.isWfcEnabledByPlatform() && instance.isWfcEnabledByUser() && instance.getWfcMode() == 0) {
                throw new CallStateException(1, "WFC Wi-Fi Only Mode: IMS not registered");
            }
        }
    }

    public AppSmsManager getAppSmsManager() {
        return this.mAppSmsManager;
    }

    public void setSimPowerState(int i, Message message, WorkSource workSource) {
        this.mCi.setSimCardPower(i, message, workSource);
    }

    public void setVoNrEnabled(boolean z, Message message, WorkSource workSource) {
        this.mCi.setVoNrEnabled(z, message, workSource);
    }

    public void isVoNrEnabled(Message message, WorkSource workSource) {
        this.mCi.isVoNrEnabled(message, workSource);
    }

    public static boolean isEmergencyCallOnly() {
        boolean z = false;
        for (Phone phone : PhoneFactory.getPhones()) {
            if (phone != null) {
                ServiceStateTracker serviceStateTracker = phone.getServiceStateTracker();
                ServiceState serviceState = serviceStateTracker.getServiceState();
                if (serviceStateTracker.getCombinedRegState(serviceState) == 0) {
                    return false;
                }
                z |= serviceState.isEmergencyOnly();
            }
        }
        return z;
    }

    public DcTracker getDcTracker(int i) {
        return this.mDcTrackers.get(i);
    }

    public HalVersion getHalVersion() {
        CommandsInterface commandsInterface = this.mCi;
        if (commandsInterface == null || !(commandsInterface instanceof RIL)) {
            return RIL.RADIO_HAL_VERSION_UNKNOWN;
        }
        return ((RIL) commandsInterface).getHalVersion();
    }

    public VoiceCallSessionStats getVoiceCallSessionStats() {
        return this.mVoiceCallSessionStats;
    }

    @VisibleForTesting
    public void setVoiceCallSessionStats(VoiceCallSessionStats voiceCallSessionStats) {
        this.mVoiceCallSessionStats = voiceCallSessionStats;
    }

    public SmsStats getSmsStats() {
        return this.mSmsStats;
    }

    @VisibleForTesting
    public void setSmsStats(SmsStats smsStats) {
        this.mSmsStats = smsStats;
    }

    public boolean isDeviceIdle() {
        DeviceStateMonitor deviceStateMonitor = getDeviceStateMonitor();
        if (deviceStateMonitor != null) {
            return !deviceStateMonitor.shouldEnableHighPowerConsumptionIndications();
        }
        Rlog.e(LOG_TAG, "isDeviceIdle: DeviceStateMonitor is null");
        return false;
    }

    public void notifyDeviceIdleStateChanged(boolean z) {
        SignalStrengthController signalStrengthController = getSignalStrengthController();
        if (signalStrengthController == null) {
            Rlog.e(LOG_TAG, "notifyDeviceIdleStateChanged: SignalStrengthController is null");
        } else {
            signalStrengthController.onDeviceIdleStateChanged(z);
        }
    }

    public List<String> getEquivalentHomePlmns() {
        return Collections.emptyList();
    }

    public List<String> getDataServicePackages() {
        return Collections.emptyList();
    }

    public LinkBandwidthEstimator getLinkBandwidthEstimator() {
        return this.mLinkBandwidthEstimator;
    }

    public void getSlicingConfig(Message message) {
        this.mCi.getSlicingConfig(message);
    }

    public DataNetworkController getDataNetworkController() {
        return this.mDataNetworkController;
    }

    public DataSettingsManager getDataSettingsManager() {
        DataNetworkController dataNetworkController = this.mDataNetworkController;
        if (dataNetworkController == null) {
            return null;
        }
        return dataNetworkController.getDataSettingsManager();
    }

    @VisibleForTesting
    public boolean isAllowedNetworkTypesLoadedFromDb() {
        return this.mIsAllowedNetworkTypesLoadedFromDb;
    }

    public boolean isUsingNewDataStack() {
        return this.mNewDataStackEnabled;
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("Phone: subId=" + getSubId());
        printWriter.println(" mPhoneId=" + this.mPhoneId);
        printWriter.println(" mCi=" + this.mCi);
        printWriter.println(" mDnsCheckDisabled=" + this.mDnsCheckDisabled);
        printWriter.println(" mDoesRilSendMultipleCallRing=" + this.mDoesRilSendMultipleCallRing);
        printWriter.println(" mCallRingContinueToken=" + this.mCallRingContinueToken);
        printWriter.println(" mCallRingDelay=" + this.mCallRingDelay);
        printWriter.println(" mIsVoiceCapable=" + this.mIsVoiceCapable);
        printWriter.println(" mIccRecords=" + this.mIccRecords.get());
        printWriter.println(" mUiccApplication=" + this.mUiccApplication.get());
        printWriter.println(" mSmsStorageMonitor=" + this.mSmsStorageMonitor);
        printWriter.println(" mSmsUsageMonitor=" + this.mSmsUsageMonitor);
        printWriter.flush();
        printWriter.println(" mLooper=" + this.mLooper);
        printWriter.println(" mContext=" + this.mContext);
        printWriter.println(" mNotifier=" + this.mNotifier);
        printWriter.println(" mSimulatedRadioControl=" + this.mSimulatedRadioControl);
        printWriter.println(" mUnitTestMode=" + this.mUnitTestMode);
        printWriter.println(" isDnsCheckDisabled()=" + isDnsCheckDisabled());
        printWriter.println(" getUnitTestMode()=" + getUnitTestMode());
        printWriter.println(" getState()=" + getState());
        printWriter.println(" getIccSerialNumber()=" + getIccSerialNumber());
        printWriter.println(" getIccRecordsLoaded()=" + getIccRecordsLoaded());
        printWriter.println(" getMessageWaitingIndicator()=" + getMessageWaitingIndicator());
        printWriter.println(" getCallForwardingIndicator()=" + getCallForwardingIndicator());
        printWriter.println(" isInEmergencyCall()=" + isInEmergencyCall());
        printWriter.flush();
        printWriter.println(" isInEcm()=" + isInEcm());
        printWriter.println(" getPhoneName()=" + getPhoneName());
        printWriter.println(" getPhoneType()=" + getPhoneType());
        printWriter.println(" getVoiceMessageCount()=" + getVoiceMessageCount());
        printWriter.println(" needsOtaServiceProvisioning=" + needsOtaServiceProvisioning());
        printWriter.println(" isInEmergencySmsMode=" + isInEmergencySmsMode());
        printWriter.println(" isEcmCanceledForEmergency=" + isEcmCanceledForEmergency());
        printWriter.println(" isUsingNewDataStack=" + isUsingNewDataStack());
        printWriter.println(" service state=" + getServiceState());
        printWriter.flush();
        printWriter.println("++++++++++++++++++++++++++++++++");
        Phone phone = this.mImsPhone;
        if (phone != null) {
            try {
                phone.dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e) {
                e.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        AccessNetworksManager accessNetworksManager = this.mAccessNetworksManager;
        if (accessNetworksManager != null) {
            for (int i : accessNetworksManager.getAvailableTransports()) {
                if (getDcTracker(i) != null) {
                    getDcTracker(i).dump(fileDescriptor, printWriter, strArr);
                    printWriter.flush();
                    printWriter.println("++++++++++++++++++++++++++++++++");
                }
            }
        }
        DataNetworkController dataNetworkController = this.mDataNetworkController;
        if (dataNetworkController != null) {
            try {
                dataNetworkController.dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e2) {
                e2.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (getServiceStateTracker() != null) {
            try {
                getServiceStateTracker().dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e3) {
                e3.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (getEmergencyNumberTracker() != null) {
            try {
                getEmergencyNumberTracker().dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e4) {
                e4.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (getDisplayInfoController() != null) {
            try {
                getDisplayInfoController().dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e5) {
                e5.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        CarrierResolver carrierResolver = this.mCarrierResolver;
        if (carrierResolver != null) {
            try {
                carrierResolver.dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e6) {
                e6.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        CarrierActionAgent carrierActionAgent = this.mCarrierActionAgent;
        if (carrierActionAgent != null) {
            try {
                carrierActionAgent.dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e7) {
                e7.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        CarrierSignalAgent carrierSignalAgent = this.mCarrierSignalAgent;
        if (carrierSignalAgent != null) {
            try {
                carrierSignalAgent.dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e8) {
                e8.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (getCallTracker() != null) {
            try {
                getCallTracker().dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e9) {
                e9.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        SimActivationTracker simActivationTracker = this.mSimActivationTracker;
        if (simActivationTracker != null) {
            try {
                simActivationTracker.dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e10) {
                e10.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (this.mDeviceStateMonitor != null) {
            printWriter.println("DeviceStateMonitor:");
            this.mDeviceStateMonitor.dump(fileDescriptor, printWriter, strArr);
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (this.mSignalStrengthController != null) {
            printWriter.println("SignalStrengthController:");
            this.mSignalStrengthController.dump(fileDescriptor, printWriter, strArr);
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        AccessNetworksManager accessNetworksManager2 = this.mAccessNetworksManager;
        if (accessNetworksManager2 != null) {
            accessNetworksManager2.dump(fileDescriptor, printWriter, strArr);
        }
        CommandsInterface commandsInterface = this.mCi;
        if (commandsInterface != null && (commandsInterface instanceof RIL)) {
            try {
                ((RIL) commandsInterface).dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e11) {
                e11.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (getCarrierPrivilegesTracker() != null) {
            printWriter.println("CarrierPrivilegesTracker:");
            getCarrierPrivilegesTracker().dump(fileDescriptor, printWriter, strArr);
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        if (getLinkBandwidthEstimator() != null) {
            printWriter.println("LinkBandwidthEstimator:");
            getLinkBandwidthEstimator().dump(fileDescriptor, printWriter, strArr);
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
        printWriter.println("Phone Local Log: ");
        LocalLog localLog = this.mLocalLog;
        if (localLog != null) {
            try {
                localLog.dump(fileDescriptor, printWriter, strArr);
            } catch (Exception e12) {
                e12.printStackTrace();
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
        }
    }

    private void logd(String str) {
        Rlog.d(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    private void logi(String str) {
        Rlog.i(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    private void loge(String str) {
        Rlog.e(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    private static String pii(String str) {
        return Rlog.pii(LOG_TAG, str);
    }
}
