package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.database.SQLException;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.PowerManager;
import android.os.ResultReceiver;
import android.os.SystemProperties;
import android.os.UserHandle;
import android.os.WorkSource;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.provider.Telephony;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;
import android.telephony.BarringInfo;
import android.telephony.CarrierConfigManager;
import android.telephony.CellIdentity;
import android.telephony.ImsiEncryptionInfo;
import android.telephony.LinkCapacityEstimate;
import android.telephony.NetworkScanRequest;
import android.telephony.PhoneNumberUtils;
import android.telephony.RadioAccessFamily;
import android.telephony.ServiceState;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.UiccAccessRule;
import android.telephony.UssdResponse;
import android.telephony.data.ApnSetting;
import android.text.TextUtils;
import android.util.Log;
import android.util.Pair;
import com.android.ims.ImsManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.IccCardConstants;
import com.android.internal.telephony.MmiCode;
import com.android.internal.telephony.OperatorInfo;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.cdma.CdmaMmiCode;
import com.android.internal.telephony.cdma.CdmaSubscriptionSourceManager;
import com.android.internal.telephony.data.AccessNetworksManager;
import com.android.internal.telephony.dataconnection.DcTracker;
import com.android.internal.telephony.dataconnection.TransportManager;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.gsm.GsmMmiCode;
import com.android.internal.telephony.gsm.SuppServiceNotification;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.test.SimulatedRadioControl;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccException;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.IccVmNotSupportedException;
import com.android.internal.telephony.uicc.IsimRecords;
import com.android.internal.telephony.uicc.IsimUiccRecords;
import com.android.internal.telephony.uicc.SIMRecords;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.UiccProfile;
import com.android.internal.telephony.uicc.UiccSlot;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.ListIterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GsmCdmaPhone extends Phone {
    public static final int CANCEL_ECM_TIMER = 1;
    private static final boolean DBG = true;
    private static final long DEFAULT_ECM_EXIT_TIMER_VALUE = 300000;
    @VisibleForTesting
    public static int ENABLE_UICC_APPS_MAX_RETRIES = 3;
    private static final int INVALID_SYSTEM_SELECTION_CODE = -1;
    private static final String IS683A_FEATURE_CODE = "*228";
    private static final int IS683A_FEATURE_CODE_NUM_DIGITS = 4;
    private static final int IS683A_SYS_SEL_CODE_NUM_DIGITS = 2;
    private static final int IS683A_SYS_SEL_CODE_OFFSET = 4;
    private static final int IS683_CONST_1900MHZ_A_BLOCK = 2;
    private static final int IS683_CONST_1900MHZ_B_BLOCK = 3;
    private static final int IS683_CONST_1900MHZ_C_BLOCK = 4;
    private static final int IS683_CONST_1900MHZ_D_BLOCK = 5;
    private static final int IS683_CONST_1900MHZ_E_BLOCK = 6;
    private static final int IS683_CONST_1900MHZ_F_BLOCK = 7;
    private static final int IS683_CONST_800MHZ_A_BAND = 0;
    private static final int IS683_CONST_800MHZ_B_BAND = 1;
    public static final String LOG_TAG = "GsmCdmaPhone";
    protected static final String PREFIX_WPS = "*272";
    protected static final String PREFIX_WPS_CLIR_ACTIVATE = "*31#*272";
    protected static final String PREFIX_WPS_CLIR_DEACTIVATE = "#31#*272";
    public static final String PROPERTY_CDMA_HOME_OPERATOR_NUMERIC = "ro.cdma.home.operator.numeric";
    private static final int REAPPLY_UICC_APPS_SETTING_RETRY_TIME_GAP_IN_MS = 5000;
    private static final int REPORTING_HYSTERESIS_KBPS = 50;
    private static final int REPORTING_HYSTERESIS_MILLIS = 3000;
    public static final int RESTART_ECM_TIMER = 0;
    private static final boolean VDBG = false;
    private static final String VM_NUMBER = "vm_number_key";
    private static final String VM_NUMBER_CDMA = "vm_number_key_cdma";
    private static final String VM_SIM_IMSI = "vm_sim_imsi_key";
    private static final int[] VOICE_PS_CALL_RADIO_TECHNOLOGY = {14, 19, 18, 20};
    private static Pattern pOtaSpNumSchema = Pattern.compile("[,\\s]+");
    private boolean mBroadcastEmergencyCallStateChanges;
    private BroadcastReceiver mBroadcastReceiver;
    private CarrierKeyDownloadManager mCDM;
    private CarrierInfoManager mCIM;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public GsmCdmaCallTracker mCT;
    private String mCarrierOtaSpNumSchema;
    private final CarrierPrivilegesTracker mCarrierPrivilegesTracker;
    protected CdmaSubscriptionSourceManager mCdmaSSM;
    public int mCdmaSubscriptionSource;
    protected PhoneInternalInterface.DialArgs mDialArgs;
    @UnsupportedAppUsage
    private Registrant mEcmExitRespRegistrant;
    private final RegistrantList mEcmTimerResetRegistrants;
    public EmergencyNumberTracker mEmergencyNumberTracker;
    private String mEsn;
    private Runnable mExitEcmRunnable;
    protected IccPhoneBookInterfaceManager mIccPhoneBookIntManager;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private IccSmsInterfaceManager mIccSmsInterfaceManager;
    private String mImei;
    protected String mImeiSv;
    private final ImsManagerFactory mImsManagerFactory;
    protected boolean mIsTestingEmergencyCallbackMode;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private IsimUiccRecords mIsimUiccRecords;
    private String mManualNetworkSelectionPlmn;
    private String mMeid;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected ArrayList<MmiCode> mPendingMMIs;
    private int mPrecisePhoneType;
    private boolean mResetModemOnRadioTechnologyChange;
    protected int mRilVersion;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ServiceStateTracker mSST;
    private final SettingsObserver mSettingsObserver;
    private SIMRecords mSimRecords;
    protected boolean mSsOverCdmaSupported;
    protected RegistrantList mSsnRegistrants;
    private final SubscriptionManager.OnSubscriptionsChangedListener mSubscriptionsChangedListener;
    private int mTelecomVoiceServiceStateOverride;
    protected Boolean mUiccApplicationsEnabled;
    private String mVmNumber;
    private final RegistrantList mVolteSilentRedialRegistrants;
    protected PowerManager.WakeLock mWakeLock;

    @VisibleForTesting
    public interface ImsManagerFactory {
        ImsManager create(Context context, int i);
    }

    private static int telecomModeToPhoneMode(int i) {
        return (i == 1 || i == 2 || i == 3) ? 1 : 0;
    }

    /* access modifiers changed from: protected */
    public boolean correctPhoneTypeForCdma(boolean z, int i) {
        return false;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isCfEnable(int i) {
        return i == 1 || i == 3;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isValidCommandInterfaceCFAction(int i) {
        return i == 0 || i == 1 || i == 3 || i == 4;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isValidCommandInterfaceCFReason(int i) {
        return i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5;
    }

    /* access modifiers changed from: protected */
    public boolean needResetPhbIntMgr() {
        return true;
    }

    /* access modifiers changed from: protected */
    public void onCheckEmergencyCall(boolean z) {
    }

    /* access modifiers changed from: protected */
    public boolean onCheckIfForceHandleInCallMmiByCS() {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean onCheckIfIgnoreServiceState() {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean onCheckIfIgnoreWifiOnlyModeCheck() {
        return false;
    }

    /* access modifiers changed from: protected */
    public void onPendingMmiAdded(String str, GsmMmiCode gsmMmiCode) {
    }

    /* access modifiers changed from: protected */
    public boolean onSetUseImsForCall(boolean z) {
        return z;
    }

    /* access modifiers changed from: protected */
    public boolean onSetUseImsForUt(boolean z) {
        return z;
    }

    private static class Cfu {
        final Message mOnComplete;
        final String mSetCfNumber;

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        Cfu(String str, Message message) {
            this.mSetCfNumber = str;
            this.mOnComplete = message;
        }
    }

    public GsmCdmaPhone(Context context, CommandsInterface commandsInterface, PhoneNotifier phoneNotifier, int i, int i2, TelephonyComponentFactory telephonyComponentFactory) {
        this(context, commandsInterface, phoneNotifier, false, i, i2, telephonyComponentFactory);
    }

    public GsmCdmaPhone(Context context, CommandsInterface commandsInterface, PhoneNotifier phoneNotifier, boolean z, int i, int i2, TelephonyComponentFactory telephonyComponentFactory) {
        this(context, commandsInterface, phoneNotifier, z, i, i2, telephonyComponentFactory, new GsmCdmaPhone$$ExternalSyntheticLambda1());
    }

    /* JADX WARNING: Illegal instructions before constructor call */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public GsmCdmaPhone(android.content.Context r13, com.android.internal.telephony.CommandsInterface r14, com.android.internal.telephony.PhoneNotifier r15, boolean r16, int r17, int r18, com.android.internal.telephony.TelephonyComponentFactory r19, com.android.internal.telephony.GsmCdmaPhone.ImsManagerFactory r20) {
        /*
            r12 = this;
            r8 = r12
            r9 = r13
            r10 = r18
            r11 = 1
            if (r10 != r11) goto L_0x000a
            java.lang.String r0 = "GSM"
            goto L_0x000c
        L_0x000a:
            java.lang.String r0 = "CDMA"
        L_0x000c:
            r1 = r0
            r0 = r12
            r2 = r15
            r3 = r13
            r4 = r14
            r5 = r16
            r6 = r17
            r7 = r19
            r0.<init>(r1, r2, r3, r4, r5, r6, r7)
            com.android.internal.telephony.RegistrantList r0 = new com.android.internal.telephony.RegistrantList
            r0.<init>()
            r8.mSsnRegistrants = r0
            r0 = -1
            r8.mCdmaSubscriptionSource = r0
            r0 = 0
            r8.mUiccApplicationsEnabled = r0
            r1 = 0
            r8.mIsTestingEmergencyCallbackMode = r1
            com.android.internal.telephony.GsmCdmaPhone$1 r2 = new com.android.internal.telephony.GsmCdmaPhone$1
            r2.<init>()
            r8.mExitEcmRunnable = r2
            java.util.ArrayList r2 = new java.util.ArrayList
            r2.<init>()
            r8.mPendingMMIs = r2
            com.android.internal.telephony.RegistrantList r2 = new com.android.internal.telephony.RegistrantList
            r2.<init>()
            r8.mEcmTimerResetRegistrants = r2
            com.android.internal.telephony.RegistrantList r2 = new com.android.internal.telephony.RegistrantList
            r2.<init>()
            r8.mVolteSilentRedialRegistrants = r2
            r8.mDialArgs = r0
            r8.mResetModemOnRadioTechnologyChange = r1
            r8.mSsOverCdmaSupported = r1
            r8.mBroadcastEmergencyCallStateChanges = r1
            r8.mTelecomVoiceServiceStateOverride = r11
            com.android.internal.telephony.GsmCdmaPhone$3 r2 = new com.android.internal.telephony.GsmCdmaPhone$3
            r2.<init>()
            r8.mBroadcastReceiver = r2
            r8.mPrecisePhoneType = r10
            com.android.internal.telephony.metrics.VoiceCallSessionStats r2 = new com.android.internal.telephony.metrics.VoiceCallSessionStats
            int r3 = r8.mPhoneId
            r2.<init>(r3, r12)
            r8.mVoiceCallSessionStats = r2
            r2 = r20
            r8.mImsManagerFactory = r2
            r2 = r14
            r12.initOnce(r14)
            r12.initRatSpecific(r10)
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.CarrierActionAgent> r3 = com.android.internal.telephony.CarrierActionAgent.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.CarrierActionAgent r2 = r2.makeCarrierActionAgent(r12)
            r8.mCarrierActionAgent = r2
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.CarrierSignalAgent> r3 = com.android.internal.telephony.CarrierSignalAgent.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.CarrierSignalAgent r2 = r2.makeCarrierSignalAgent(r12)
            r8.mCarrierSignalAgent = r2
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.data.AccessNetworksManager> r3 = com.android.internal.telephony.data.AccessNetworksManager.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            android.os.Looper r3 = r12.getLooper()
            com.android.internal.telephony.data.AccessNetworksManager r2 = r2.makeAccessNetworksManager(r12, r3)
            r8.mAccessNetworksManager = r2
            boolean r2 = r12.isUsingNewDataStack()
            if (r2 != 0) goto L_0x00bf
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.dataconnection.TransportManager> r3 = com.android.internal.telephony.dataconnection.TransportManager.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.dataconnection.TransportManager r2 = r2.makeTransportManager(r12)
            r8.mTransportManager = r2
        L_0x00bf:
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.SignalStrengthController> r3 = com.android.internal.telephony.SignalStrengthController.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.SignalStrengthController r2 = r2.makeSignalStrengthController(r12)
            r8.mSignalStrengthController = r2
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.ServiceStateTracker> r3 = com.android.internal.telephony.ServiceStateTracker.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.CommandsInterface r3 = r8.mCi
            com.android.internal.telephony.ServiceStateTracker r2 = r2.makeServiceStateTracker(r12, r3)
            r8.mSST = r2
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.emergency.EmergencyNumberTracker> r3 = com.android.internal.telephony.emergency.EmergencyNumberTracker.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.CommandsInterface r3 = r8.mCi
            com.android.internal.telephony.emergency.EmergencyNumberTracker r2 = r2.makeEmergencyNumberTracker(r12, r3)
            r8.mEmergencyNumberTracker = r2
            boolean r2 = r12.isUsingNewDataStack()
            if (r2 != 0) goto L_0x0111
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.dataconnection.DataEnabledSettings> r3 = com.android.internal.telephony.dataconnection.DataEnabledSettings.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.dataconnection.DataEnabledSettings r2 = r2.makeDataEnabledSettings(r12)
            r8.mDataEnabledSettings = r2
        L_0x0111:
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.DeviceStateMonitor> r3 = com.android.internal.telephony.DeviceStateMonitor.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.DeviceStateMonitor r2 = r2.makeDeviceStateMonitor(r12)
            r8.mDeviceStateMonitor = r2
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.DisplayInfoController> r3 = com.android.internal.telephony.DisplayInfoController.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.DisplayInfoController r2 = r2.makeDisplayInfoController(r12)
            r8.mDisplayInfoController = r2
            boolean r2 = r12.isUsingNewDataStack()
            if (r2 == 0) goto L_0x0152
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.data.DataNetworkController> r3 = com.android.internal.telephony.data.DataNetworkController.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            android.os.Looper r3 = r12.getLooper()
            com.android.internal.telephony.data.DataNetworkController r2 = r2.makeDataNetworkController(r12, r3)
            r8.mDataNetworkController = r2
            goto L_0x017f
        L_0x0152:
            com.android.internal.telephony.data.AccessNetworksManager r2 = r8.mAccessNetworksManager
            int[] r2 = r2.getAvailableTransports()
            int r3 = r2.length
            r4 = r1
        L_0x015a:
            if (r4 >= r3) goto L_0x017f
            r5 = r2[r4]
            com.android.internal.telephony.TelephonyComponentFactory r6 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.dataconnection.DcTracker> r7 = com.android.internal.telephony.dataconnection.DcTracker.class
            java.lang.String r7 = r7.getName()
            com.android.internal.telephony.TelephonyComponentFactory r6 = r6.inject(r7)
            com.android.internal.telephony.dataconnection.DcTracker r6 = r6.makeDcTracker(r12, r5)
            android.util.SparseArray<com.android.internal.telephony.dataconnection.DcTracker> r7 = r8.mDcTrackers
            r7.put(r5, r6)
            com.android.internal.telephony.data.AccessNetworksManager r5 = r8.mAccessNetworksManager
            com.android.internal.telephony.dataconnection.DataThrottler r6 = r6.getDataThrottler()
            r5.registerDataThrottler(r6)
            int r4 = r4 + 1
            goto L_0x015a
        L_0x017f:
            com.android.internal.telephony.TelephonyComponentFactory r2 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.CarrierResolver> r3 = com.android.internal.telephony.CarrierResolver.class
            java.lang.String r3 = r3.getName()
            com.android.internal.telephony.TelephonyComponentFactory r2 = r2.inject(r3)
            com.android.internal.telephony.CarrierResolver r2 = r2.makeCarrierResolver(r12)
            r8.mCarrierResolver = r2
            com.android.internal.telephony.CarrierPrivilegesTracker r2 = new com.android.internal.telephony.CarrierPrivilegesTracker
            android.os.Looper r3 = android.os.Looper.myLooper()
            r2.<init>(r3, r12, r13)
            r8.mCarrierPrivilegesTracker = r2
            com.android.internal.telephony.CarrierActionAgent r2 = r12.getCarrierActionAgent()
            r3 = 0
            r4 = 48
            r5 = 0
            r6 = 0
            r14 = r2
            r15 = r3
            r16 = r12
            r17 = r4
            r18 = r5
            r19 = r6
            r14.registerForCarrierAction(r15, r16, r17, r18, r19)
            com.android.internal.telephony.ServiceStateTracker r2 = r8.mSST
            r3 = 19
            r2.registerForNetworkAttached(r12, r3, r0)
            com.android.internal.telephony.ServiceStateTracker r2 = r8.mSST
            r3 = 46
            r2.registerForVoiceRegStateOrRatChanged(r12, r3, r0)
            com.android.internal.telephony.SettingsObserver r2 = new com.android.internal.telephony.SettingsObserver
            r2.<init>(r13, r12)
            r8.mSettingsObserver = r2
            java.lang.String r3 = "device_provisioned"
            android.net.Uri r3 = android.provider.Settings.Global.getUriFor(r3)
            r4 = 49
            r2.observe(r3, r4)
            java.lang.String r3 = "device_provisioning_mobile_data"
            android.net.Uri r3 = android.provider.Settings.Global.getUriFor(r3)
            r4 = 50
            r2.observe(r3, r4)
            com.android.internal.telephony.SubscriptionController r2 = com.android.internal.telephony.SubscriptionController.getInstance()
            r3 = 54
            r2.registerForUiccAppsEnabled(r12, r3, r0, r1)
            com.android.internal.telephony.TelephonyComponentFactory r0 = r8.mTelephonyComponentFactory
            java.lang.Class<com.android.internal.telephony.data.LinkBandwidthEstimator> r1 = com.android.internal.telephony.data.LinkBandwidthEstimator.class
            java.lang.String r1 = r1.getName()
            com.android.internal.telephony.TelephonyComponentFactory r0 = r0.inject(r1)
            com.android.internal.telephony.data.LinkBandwidthEstimator r0 = r0.makeLinkBandwidthEstimator(r12)
            r8.mLinkBandwidthEstimator = r0
            r12.loadTtyMode()
            com.android.internal.telephony.CallManager r0 = com.android.internal.telephony.CallManager.getInstance()
            r0.registerPhone(r12)
            com.android.internal.telephony.GsmCdmaPhone$2 r0 = new com.android.internal.telephony.GsmCdmaPhone$2
            r0.<init>()
            r8.mSubscriptionsChangedListener = r0
            java.lang.Class<android.telephony.SubscriptionManager> r1 = android.telephony.SubscriptionManager.class
            java.lang.Object r1 = r13.getSystemService(r1)
            android.telephony.SubscriptionManager r1 = (android.telephony.SubscriptionManager) r1
            android.os.HandlerExecutor r2 = new android.os.HandlerExecutor
            r2.<init>(r12)
            r1.addOnSubscriptionsChangedListener(r2, r0)
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "GsmCdmaPhone: constructor: sub = "
            r0.append(r1)
            int r1 = r8.mPhoneId
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            r12.logd(r0)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.<init>(android.content.Context, com.android.internal.telephony.CommandsInterface, com.android.internal.telephony.PhoneNotifier, boolean, int, int, com.android.internal.telephony.TelephonyComponentFactory, com.android.internal.telephony.GsmCdmaPhone$ImsManagerFactory):void");
    }

    /* access modifiers changed from: protected */
    public void initOnce(CommandsInterface commandsInterface) {
        if (commandsInterface instanceof SimulatedRadioControl) {
            this.mSimulatedRadioControl = (SimulatedRadioControl) commandsInterface;
        }
        this.mCT = this.mTelephonyComponentFactory.inject(GsmCdmaCallTracker.class.getName()).makeGsmCdmaCallTracker(this);
        this.mIccPhoneBookIntManager = this.mTelephonyComponentFactory.inject(IccPhoneBookInterfaceManager.class.getName()).makeIccPhoneBookInterfaceManager(this);
        this.mWakeLock = ((PowerManager) this.mContext.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, LOG_TAG);
        this.mIccSmsInterfaceManager = this.mTelephonyComponentFactory.inject(IccSmsInterfaceManager.class.getName()).makeIccSmsInterfaceManager(this);
        this.mCi.registerForAvailable(this, 1, (Object) null);
        this.mCi.registerForOffOrNotAvailable(this, 8, (Object) null);
        this.mCi.registerForOn(this, 5, (Object) null);
        this.mCi.registerForRadioStateChanged(this, 47, (Object) null);
        this.mCi.registerUiccApplicationEnablementChanged(this, 53, (Object) null);
        this.mCi.setOnSuppServiceNotification(this, 2, (Object) null);
        this.mCi.setOnRegistrationFailed(this, 57, (Object) null);
        this.mCi.registerForBarringInfoChanged(this, 58, (Object) null);
        this.mCi.setOnUSSD(this, 7, (Object) null);
        this.mCi.setOnSs(this, 36, (Object) null);
        this.mCdmaSSM = this.mTelephonyComponentFactory.inject(CdmaSubscriptionSourceManager.class.getName()).getCdmaSubscriptionSourceManagerInstance(this.mContext, this.mCi, this, 27, (Object) null);
        this.mCi.setEmergencyCallbackMode(this, 25, (Object) null);
        this.mCi.registerForExitEmergencyCallbackMode(this, 26, (Object) null);
        this.mCi.registerForModemReset(this, 45, (Object) null);
        this.mCarrierOtaSpNumSchema = TelephonyManager.from(this.mContext).getOtaSpNumberSchemaForPhone(getPhoneId(), "");
        this.mResetModemOnRadioTechnologyChange = TelephonyProperties.reset_on_radio_tech_change().orElse(Boolean.FALSE).booleanValue();
        this.mCi.registerForRilConnected(this, 41, (Object) null);
        this.mCi.registerForVoiceRadioTechChanged(this, 39, (Object) null);
        this.mCi.registerForLceInfo(this, 59, (Object) null);
        this.mCi.registerForCarrierInfoForImsiEncryption(this, 60, (Object) null);
        IntentFilter intentFilter = new IntentFilter("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction("android.telecom.action.CURRENT_TTY_MODE_CHANGED");
        intentFilter.addAction("android.telecom.action.TTY_PREFERRED_MODE_CHANGED");
        this.mContext.registerReceiver(this.mBroadcastReceiver, intentFilter, "android.permission.MODIFY_PHONE_STATE", (Handler) null, 2);
        this.mCDM = new CarrierKeyDownloadManager(this);
        this.mCIM = new CarrierInfoManager();
    }

    /* access modifiers changed from: protected */
    public void initRatSpecific(int i) {
        String str;
        this.mPendingMMIs.clear();
        if (needResetPhbIntMgr()) {
            this.mIccPhoneBookIntManager.updateIccRecords((IccRecords) null);
        }
        this.mPrecisePhoneType = i;
        logd("Precise phone type " + this.mPrecisePhoneType);
        TelephonyManager from = TelephonyManager.from(this.mContext);
        UiccProfile uiccProfile = getUiccProfile();
        if (isPhoneTypeGsm()) {
            this.mCi.setPhoneType(1);
            from.setPhoneType(getPhoneId(), 1);
            if (uiccProfile != null) {
                uiccProfile.setVoiceRadioTech(3);
                return;
            }
            return;
        }
        this.mCdmaSubscriptionSource = this.mCdmaSSM.getCdmaSubscriptionSource();
        boolean inEcmMode = Phone.getInEcmMode();
        this.mIsPhoneInEcmState = inEcmMode;
        if (inEcmMode) {
            this.mCi.exitEmergencyCallbackMode((Message) null);
        }
        this.mCi.setPhoneType(2);
        from.setPhoneType(getPhoneId(), 2);
        if (uiccProfile != null) {
            uiccProfile.setVoiceRadioTech(6);
        }
        String str2 = SystemProperties.get("ro.cdma.home.operator.alpha");
        String str3 = SystemProperties.get(PROPERTY_CDMA_HOME_OPERATOR_NUMERIC);
        logd("init: operatorAlpha='" + str2 + "' operatorNumeric='" + str3 + "'");
        if (!TextUtils.isEmpty(str2)) {
            logd("init: set 'gsm.sim.operator.alpha' to operator='" + str2 + "'");
            from.setSimOperatorNameForPhone(this.mPhoneId, str2);
        }
        if (!TextUtils.isEmpty(str3)) {
            logd("init: set 'gsm.sim.operator.numeric' to operator='" + str3 + "'");
            StringBuilder sb = new StringBuilder();
            sb.append("update icc_operator_numeric=");
            sb.append(str3);
            logd(sb.toString());
            from.setSimOperatorNumericForPhone(this.mPhoneId, str3);
            SubscriptionController.getInstance().setMccMnc(str3, getSubId());
            try {
                str = MccTable.countryCodeForMcc(str3.substring(0, 3));
            } catch (StringIndexOutOfBoundsException e) {
                Rlog.e(LOG_TAG, "init: countryCodeForMcc error", e);
                str = "";
            }
            logd("init: set 'gsm.sim.operator.iso-country' to iso=" + str);
            from.setSimCountryIsoForPhone(this.mPhoneId, str);
            SubscriptionController.getInstance().setCountryIso(str, getSubId());
            logd("update mccmnc=" + str3);
            MccTable.updateMccMncConfiguration(this.mContext, str3);
        }
        updateCurrentCarrierInProvider(str3);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isPhoneTypeGsm() {
        return this.mPrecisePhoneType == 1;
    }

    public boolean isPhoneTypeCdma() {
        return this.mPrecisePhoneType == 2;
    }

    public boolean isPhoneTypeCdmaLte() {
        return this.mPrecisePhoneType == 6;
    }

    /* access modifiers changed from: protected */
    public void switchPhoneType(int i) {
        removeCallbacks(this.mExitEcmRunnable);
        initRatSpecific(i);
        this.mSST.updatePhoneType();
        setPhoneName(i == 1 ? "GSM" : "CDMA");
        onUpdateIccAvailability();
        unregisterForIccRecordEvents();
        registerForIccRecordEvents();
        this.mCT.updatePhoneType();
        int radioState = this.mCi.getRadioState();
        if (radioState != 2) {
            handleRadioAvailable();
            if (radioState == 1) {
                handleRadioOn();
            }
        }
        if (radioState != 1) {
            handleRadioOffOrNotAvailable();
        }
    }

    private void updateLinkCapacityEstimate(List<LinkCapacityEstimate> list) {
        logd("updateLinkCapacityEstimate: lce list=" + list);
        if (list != null) {
            notifyLinkCapacityEstimateChanged(list);
        }
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        logd("GsmCdmaPhone finalized");
        PowerManager.WakeLock wakeLock = this.mWakeLock;
        if (wakeLock != null && wakeLock.isHeld()) {
            Rlog.e(LOG_TAG, "UNEXPECTED; mWakeLock is held when finalizing.");
            this.mWakeLock.release();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ServiceState getServiceState() {
        ServiceStateTracker serviceStateTracker = this.mSST;
        ServiceState serviceState = serviceStateTracker != null ? serviceStateTracker.getServiceState() : new ServiceState();
        Phone phone = this.mImsPhone;
        return mergeVoiceServiceStates(serviceState, phone != null ? phone.getServiceState() : new ServiceState(), this.mTelecomVoiceServiceStateOverride);
    }

    public void setVoiceServiceStateOverride(boolean z) {
        ServiceStateTracker serviceStateTracker;
        boolean z2 = true;
        boolean z3 = !z;
        if (z3 == this.mTelecomVoiceServiceStateOverride) {
            z2 = false;
        }
        this.mTelecomVoiceServiceStateOverride = z3 ? 1 : 0;
        if (z2 && (serviceStateTracker = this.mSST) != null) {
            serviceStateTracker.onTelecomVoiceServiceStateOverrideChanged();
        }
    }

    public void getCellIdentity(WorkSource workSource, Message message) {
        this.mSST.requestCellIdentity(workSource, message);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public PhoneConstants.State getState() {
        PhoneConstants.State state;
        Phone phone = this.mImsPhone;
        if (phone == null || (state = phone.getState()) == PhoneConstants.State.IDLE) {
            return this.mCT.mState;
        }
        return state;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getPhoneType() {
        return this.mPrecisePhoneType == 1 ? 1 : 2;
    }

    public ServiceStateTracker getServiceStateTracker() {
        return this.mSST;
    }

    public EmergencyNumberTracker getEmergencyNumberTracker() {
        return this.mEmergencyNumberTracker;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CallTracker getCallTracker() {
        return this.mCT;
    }

    public TransportManager getTransportManager() {
        return this.mTransportManager;
    }

    public AccessNetworksManager getAccessNetworksManager() {
        return this.mAccessNetworksManager;
    }

    public DeviceStateMonitor getDeviceStateMonitor() {
        return this.mDeviceStateMonitor;
    }

    public DisplayInfoController getDisplayInfoController() {
        return this.mDisplayInfoController;
    }

    public SignalStrengthController getSignalStrengthController() {
        return this.mSignalStrengthController;
    }

    public void updateVoiceMail() {
        if (isPhoneTypeGsm()) {
            int i = 0;
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                i = iccRecords.getVoiceMessageCount();
            }
            if (i == -2) {
                i = getStoredVoiceMessageCount();
            }
            logd("updateVoiceMail countVoiceMessages = " + i + " subId " + getSubId());
            setVoiceMessageCount(i);
            return;
        }
        setVoiceMessageCount(getStoredVoiceMessageCount());
    }

    public List<? extends MmiCode> getPendingMmiCodes() {
        return this.mPendingMMIs;
    }

    public boolean isDataSuspended() {
        return this.mCT.mState != PhoneConstants.State.IDLE && !this.mSST.isConcurrentVoiceAndDataAllowed();
    }

    public PhoneConstants.DataState getDataConnectionState(String str) {
        PhoneConstants.DataState dataState = PhoneConstants.DataState.DISCONNECTED;
        ServiceStateTracker serviceStateTracker = this.mSST;
        if (serviceStateTracker != null) {
            if (serviceStateTracker.getCurrentDataConnectionState() == 0 || (!isPhoneTypeCdma() && !isPhoneTypeCdmaLte() && (!isPhoneTypeGsm() || str.equals("emergency")))) {
                int currentTransport = this.mAccessNetworksManager.getCurrentTransport(ApnSetting.getApnTypesBitmaskFromString(str));
                if (getDcTracker(currentTransport) != null) {
                    int i = AnonymousClass4.$SwitchMap$com$android$internal$telephony$DctConstants$State[getDcTracker(currentTransport).getState(str).ordinal()];
                    dataState = (i == 1 || i == 2) ? isDataSuspended() ? PhoneConstants.DataState.SUSPENDED : PhoneConstants.DataState.CONNECTED : i != 3 ? PhoneConstants.DataState.DISCONNECTED : PhoneConstants.DataState.CONNECTING;
                }
            } else {
                dataState = PhoneConstants.DataState.DISCONNECTED;
            }
        }
        logd("getDataConnectionState apnType=" + str + " ret=" + dataState);
        return dataState;
    }

    public int getDataActivityState() {
        if (isUsingNewDataStack()) {
            return getDataNetworkController().getDataActivity();
        }
        if (this.mSST.getCurrentDataConnectionState() == 0 && getDcTracker(1) != null) {
            int i = AnonymousClass4.$SwitchMap$com$android$internal$telephony$DctConstants$Activity[getDcTracker(1).getActivity().ordinal()];
            if (i == 1) {
                return 1;
            }
            if (i == 2) {
                return 2;
            }
            if (i == 3) {
                return 3;
            }
            if (i == 4) {
                return 4;
            }
        }
        return 0;
    }

    /* renamed from: com.android.internal.telephony.GsmCdmaPhone$4  reason: invalid class name */
    static /* synthetic */ class AnonymousClass4 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$DctConstants$Activity;
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$DctConstants$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(16:0|(2:1|2)|3|(2:5|6)|7|9|10|(2:11|12)|13|15|16|17|18|19|20|22) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:17:0x0044 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x004e */
        static {
            /*
                com.android.internal.telephony.DctConstants$Activity[] r0 = com.android.internal.telephony.DctConstants.Activity.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$DctConstants$Activity = r0
                r1 = 1
                com.android.internal.telephony.DctConstants$Activity r2 = com.android.internal.telephony.DctConstants.Activity.DATAIN     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$com$android$internal$telephony$DctConstants$Activity     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.DctConstants$Activity r3 = com.android.internal.telephony.DctConstants.Activity.DATAOUT     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$com$android$internal$telephony$DctConstants$Activity     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.DctConstants$Activity r4 = com.android.internal.telephony.DctConstants.Activity.DATAINANDOUT     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r3 = $SwitchMap$com$android$internal$telephony$DctConstants$Activity     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.DctConstants$Activity r4 = com.android.internal.telephony.DctConstants.Activity.DORMANT     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r5 = 4
                r3[r4] = r5     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                com.android.internal.telephony.DctConstants$State[] r3 = com.android.internal.telephony.DctConstants.State.values()
                int r3 = r3.length
                int[] r3 = new int[r3]
                $SwitchMap$com$android$internal$telephony$DctConstants$State = r3
                com.android.internal.telephony.DctConstants$State r4 = com.android.internal.telephony.DctConstants.State.CONNECTED     // Catch:{ NoSuchFieldError -> 0x0044 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0044 }
                r3[r4] = r1     // Catch:{ NoSuchFieldError -> 0x0044 }
            L_0x0044:
                int[] r1 = $SwitchMap$com$android$internal$telephony$DctConstants$State     // Catch:{ NoSuchFieldError -> 0x004e }
                com.android.internal.telephony.DctConstants$State r3 = com.android.internal.telephony.DctConstants.State.DISCONNECTING     // Catch:{ NoSuchFieldError -> 0x004e }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x004e }
                r1[r3] = r0     // Catch:{ NoSuchFieldError -> 0x004e }
            L_0x004e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DctConstants$State     // Catch:{ NoSuchFieldError -> 0x0058 }
                com.android.internal.telephony.DctConstants$State r1 = com.android.internal.telephony.DctConstants.State.CONNECTING     // Catch:{ NoSuchFieldError -> 0x0058 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0058 }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0058 }
            L_0x0058:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.AnonymousClass4.<clinit>():void");
        }
    }

    public void notifyPhoneStateChanged() {
        this.mNotifier.notifyPhoneState(this);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void notifyPreciseCallStateChanged() {
        super.notifyPreciseCallStateChangedP();
    }

    public void notifyNewRingingConnection(Connection connection) {
        super.notifyNewRingingConnectionP(connection);
    }

    public void notifyDisconnect(Connection connection) {
        this.mDisconnectRegistrants.notifyResult(connection);
        this.mNotifier.notifyDisconnectCause(this, connection.getDisconnectCause(), connection.getPreciseDisconnectCause());
    }

    public void notifyUnknownConnection(Connection connection) {
        super.notifyUnknownConnectionP(connection);
    }

    public boolean isInEmergencyCall() {
        if (isPhoneTypeGsm()) {
            return false;
        }
        return this.mCT.isInEmergencyCall();
    }

    /* access modifiers changed from: protected */
    public void setIsInEmergencyCall() {
        if (!isPhoneTypeGsm()) {
            this.mCT.setIsInEmergencyCall();
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r1 = r1.mImsPhone;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isInEmergencySmsMode() {
        /*
            r1 = this;
            boolean r0 = super.isInEmergencySmsMode()
            if (r0 != 0) goto L_0x0013
            com.android.internal.telephony.Phone r1 = r1.mImsPhone
            if (r1 == 0) goto L_0x0011
            boolean r1 = r1.isInEmergencySmsMode()
            if (r1 == 0) goto L_0x0011
            goto L_0x0013
        L_0x0011:
            r1 = 0
            goto L_0x0014
        L_0x0013:
            r1 = 1
        L_0x0014:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.isInEmergencySmsMode():boolean");
    }

    private void sendEmergencyCallbackModeChange() {
        Intent intent = new Intent("android.intent.action.EMERGENCY_CALLBACK_MODE_CHANGED");
        intent.putExtra("android.telephony.extra.PHONE_IN_ECM_STATE", isInEcm());
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, getPhoneId());
        this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
        logi("sendEmergencyCallbackModeChange");
    }

    public void sendEmergencyCallStateChange(boolean z) {
        if (!isPhoneTypeCdma()) {
            logi("sendEmergencyCallStateChange - skip for non-cdma");
        } else if (this.mBroadcastEmergencyCallStateChanges) {
            Intent intent = new Intent("android.intent.action.EMERGENCY_CALL_STATE_CHANGED");
            intent.putExtra("android.telephony.extra.PHONE_IN_EMERGENCY_CALL", z);
            SubscriptionManager.putPhoneIdAndSubIdExtra(intent, getPhoneId());
            this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
            Rlog.d(LOG_TAG, "sendEmergencyCallStateChange: callActive " + z);
        }
    }

    public void setBroadcastEmergencyCallStateChanges(boolean z) {
        this.mBroadcastEmergencyCallStateChanges = z;
    }

    public void notifySuppServiceFailed(PhoneInternalInterface.SuppService suppService) {
        this.mSuppServiceFailedRegistrants.notifyResult(suppService);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void notifyServiceStateChanged(ServiceState serviceState) {
        super.notifyServiceStateChangedP(serviceState);
    }

    /* access modifiers changed from: package-private */
    public void notifyServiceStateChangedForSubId(ServiceState serviceState, int i) {
        super.notifyServiceStateChangedPForSubId(serviceState, i);
    }

    public void notifyLocationChanged(CellIdentity cellIdentity) {
        this.mNotifier.notifyCellLocation(this, cellIdentity);
    }

    public void notifyCallForwardingIndicator() {
        this.mNotifier.notifyCallForwardingChanged(this);
    }

    public void registerForSuppServiceNotification(Handler handler, int i, Object obj) {
        this.mSsnRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSuppServiceNotification(Handler handler) {
        this.mSsnRegistrants.remove(handler);
    }

    public void registerForSimRecordsLoaded(Handler handler, int i, Object obj) {
        this.mSimRecordsLoadedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForSimRecordsLoaded(Handler handler) {
        this.mSimRecordsLoadedRegistrants.remove(handler);
    }

    public void acceptCall(int i) throws CallStateException {
        Phone phone = this.mImsPhone;
        if (phone == null || !phone.getRingingCall().isRinging()) {
            this.mCT.acceptCall();
        } else {
            phone.acceptCall(i);
        }
    }

    public void rejectCall() throws CallStateException {
        this.mCT.rejectCall();
    }

    public void switchHoldingAndActive() throws CallStateException {
        this.mCT.switchWaitingOrHoldingAndActive();
    }

    public String getIccSerialNumber() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (!isPhoneTypeGsm() && iccRecords == null) {
            iccRecords = this.mUiccController.getIccRecords(this.mPhoneId, 1);
        }
        if (iccRecords != null) {
            return iccRecords.getIccId();
        }
        return null;
    }

    public String getFullIccSerialNumber() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (!isPhoneTypeGsm() && iccRecords == null) {
            iccRecords = this.mUiccController.getIccRecords(this.mPhoneId, 1);
        }
        if (iccRecords != null) {
            return iccRecords.getFullIccId();
        }
        return null;
    }

    public boolean canConference() {
        Phone phone = this.mImsPhone;
        if (phone != null && phone.canConference()) {
            return true;
        }
        if (isPhoneTypeGsm()) {
            return this.mCT.canConference();
        }
        loge("canConference: not possible in CDMA");
        return false;
    }

    public void conference() {
        Phone phone = this.mImsPhone;
        if (phone != null && phone.canConference()) {
            logd("conference() - delegated to IMS phone");
            try {
                this.mImsPhone.conference();
            } catch (CallStateException e) {
                loge(e.toString());
            }
        } else if (isPhoneTypeGsm()) {
            this.mCT.conference();
        } else {
            loge("conference: not possible in CDMA");
        }
    }

    public void dispose() {
        super.dispose();
        SubscriptionController.getInstance().unregisterForUiccAppsEnabled(this);
    }

    public void enableEnhancedVoicePrivacy(boolean z, Message message) {
        if (isPhoneTypeGsm()) {
            loge("enableEnhancedVoicePrivacy: not expected on GSM");
        } else {
            this.mCi.setPreferredVoicePrivacy(z, message);
        }
    }

    public void getEnhancedVoicePrivacy(Message message) {
        if (isPhoneTypeGsm()) {
            loge("getEnhancedVoicePrivacy: not expected on GSM");
        } else {
            this.mCi.getPreferredVoicePrivacy(message);
        }
    }

    public void clearDisconnected() {
        this.mCT.clearDisconnected();
    }

    public boolean canTransfer() {
        if (isPhoneTypeGsm()) {
            return this.mCT.canTransfer();
        }
        loge("canTransfer: not possible in CDMA");
        return false;
    }

    public void explicitCallTransfer() {
        if (isPhoneTypeGsm()) {
            this.mCT.explicitCallTransfer();
        } else {
            loge("explicitCallTransfer: not possible in CDMA");
        }
    }

    public GsmCdmaCall getForegroundCall() {
        return this.mCT.mForegroundCall;
    }

    public GsmCdmaCall getBackgroundCall() {
        return this.mCT.mBackgroundCall;
    }

    public Call getRingingCall() {
        Phone phone = this.mImsPhone;
        if (phone != null && phone.getRingingCall().isRinging()) {
            return phone.getRingingCall();
        }
        if (this.mCT.mRingingCall.isRinging() || this.mCT.getRingingHandoverConnection() == null || this.mCT.getRingingHandoverConnection().getCall() == null || !this.mCT.getRingingHandoverConnection().getCall().isRinging()) {
            return this.mCT.mRingingCall;
        }
        return this.mCT.getRingingHandoverConnection().getCall();
    }

    public CarrierPrivilegesTracker getCarrierPrivilegesTracker() {
        return this.mCarrierPrivilegesTracker;
    }

    private static ServiceState mergeVoiceServiceStates(ServiceState serviceState, ServiceState serviceState2, int i) {
        if (serviceState.getState() == 0) {
            return serviceState;
        }
        if (i != 0) {
            i = serviceState2.getState() == 0 ? serviceState.getDataRegistrationState() : 1;
        }
        if (i != 0) {
            return serviceState;
        }
        ServiceState serviceState3 = new ServiceState(serviceState);
        serviceState3.setVoiceRegState(i);
        serviceState3.setEmergencyOnly(false);
        return serviceState3;
    }

    private boolean handleCallDeflectionIncallSupplementaryService(String str) {
        if (str.length() > 1) {
            return false;
        }
        Call.State state = getRingingCall().getState();
        Call.State state2 = Call.State.IDLE;
        if (state != state2) {
            logd("MmiCode 0: rejectCall");
            try {
                this.mCT.rejectCall();
            } catch (CallStateException e) {
                Rlog.d(LOG_TAG, "reject failed", e);
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.REJECT);
            }
        } else if (getBackgroundCall().getState() != state2) {
            logd("MmiCode 0: hangupWaitingOrBackground");
            this.mCT.hangupWaitingOrBackground();
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean handleCallWaitingIncallSupplementaryService(String str) {
        int length = str.length();
        if (length > 2) {
            return false;
        }
        GsmCdmaCall foregroundCall = getForegroundCall();
        if (length > 1) {
            try {
                int charAt = str.charAt(1) - '0';
                if (charAt >= 1 && charAt <= 19) {
                    logd("MmiCode 1: hangupConnectionByIndex " + charAt);
                    this.mCT.hangupConnectionByIndex(foregroundCall, charAt);
                }
            } catch (CallStateException e) {
                Rlog.d(LOG_TAG, "hangup failed", e);
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.HANGUP);
            }
        } else if (foregroundCall.getState() != Call.State.IDLE) {
            logd("MmiCode 1: hangup foreground");
            this.mCT.hangup(foregroundCall);
        } else {
            logd("MmiCode 1: switchWaitingOrHoldingAndActive");
            this.mCT.switchWaitingOrHoldingAndActive();
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean handleCallHoldIncallSupplementaryService(String str) {
        int length = str.length();
        if (length > 2) {
            return false;
        }
        GsmCdmaCall foregroundCall = getForegroundCall();
        if (length > 1) {
            try {
                int charAt = str.charAt(1) - '0';
                GsmCdmaConnection connectionByIndex = this.mCT.getConnectionByIndex(foregroundCall, charAt);
                if (connectionByIndex == null || charAt < 1 || charAt > 19) {
                    logd("separate: invalid call index " + charAt);
                    notifySuppServiceFailed(PhoneInternalInterface.SuppService.SEPARATE);
                } else {
                    logd("MmiCode 2: separate call " + charAt);
                    this.mCT.separate(connectionByIndex);
                }
            } catch (CallStateException e) {
                Rlog.d(LOG_TAG, "separate failed", e);
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.SEPARATE);
            }
        } else {
            try {
                if (getRingingCall().getState() != Call.State.IDLE) {
                    logd("MmiCode 2: accept ringing call");
                    this.mCT.acceptCall();
                } else {
                    logd("MmiCode 2: switchWaitingOrHoldingAndActive");
                    this.mCT.switchWaitingOrHoldingAndActive();
                }
            } catch (CallStateException e2) {
                Rlog.d(LOG_TAG, "switch failed", e2);
                notifySuppServiceFailed(PhoneInternalInterface.SuppService.SWITCH);
            }
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean handleMultipartyIncallSupplementaryService(String str) {
        if (str.length() > 1) {
            return false;
        }
        logd("MmiCode 3: merge calls");
        conference();
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean handleEctIncallSupplementaryService(String str) {
        if (str.length() != 1) {
            return false;
        }
        logd("MmiCode 4: explicit call transfer");
        explicitCallTransfer();
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean handleCcbsIncallSupplementaryService(String str) {
        if (str.length() > 1) {
            return false;
        }
        Rlog.i(LOG_TAG, "MmiCode 5: CCBS not supported!");
        notifySuppServiceFailed(PhoneInternalInterface.SuppService.UNKNOWN);
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean handleInCallMmiCommands(String str) throws CallStateException {
        if (!isPhoneTypeGsm()) {
            loge("method handleInCallMmiCommands is NOT supported in CDMA!");
            return false;
        }
        Phone phone = this.mImsPhone;
        if (!onCheckIfForceHandleInCallMmiByCS() && phone != null && phone.getServiceState().getState() == 0) {
            return phone.handleInCallMmiCommands(str);
        }
        if (!isInCall() || TextUtils.isEmpty(str)) {
            return false;
        }
        switch (str.charAt(0)) {
            case '0':
                return onHandleInCallMmi0(str);
            case '1':
                return handleCallWaitingIncallSupplementaryService(str);
            case '2':
                return handleCallHoldIncallSupplementaryService(str);
            case '3':
                return handleMultipartyIncallSupplementaryService(str);
            case '4':
                return handleEctIncallSupplementaryService(str);
            case '5':
                return handleCcbsIncallSupplementaryService(str);
            default:
                return false;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isInCall() {
        return getForegroundCall().getState().isAlive() || getBackgroundCall().getState().isAlive() || getRingingCall().getState().isAlive();
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r0 = r1.mImsPhone;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean useImsForCall(com.android.internal.telephony.PhoneInternalInterface.DialArgs r2) {
        /*
            r1 = this;
            boolean r0 = r1.isImsUseEnabled()
            if (r0 == 0) goto L_0x0036
            com.android.internal.telephony.Phone r0 = r1.mImsPhone
            if (r0 == 0) goto L_0x0036
            boolean r0 = r0.isVoiceOverCellularImsEnabled()
            if (r0 != 0) goto L_0x0028
            com.android.internal.telephony.Phone r0 = r1.mImsPhone
            boolean r0 = r0.isWifiCallingEnabled()
            if (r0 != 0) goto L_0x0028
            com.android.internal.telephony.Phone r0 = r1.mImsPhone
            boolean r0 = r0.isVideoEnabled()
            if (r0 == 0) goto L_0x0036
            int r2 = r2.videoState
            boolean r2 = android.telecom.VideoProfile.isVideo(r2)
            if (r2 == 0) goto L_0x0036
        L_0x0028:
            com.android.internal.telephony.Phone r1 = r1.mImsPhone
            android.telephony.ServiceState r1 = r1.getServiceState()
            int r1 = r1.getState()
            if (r1 != 0) goto L_0x0036
            r1 = 1
            goto L_0x0037
        L_0x0036:
            r1 = 0
        L_0x0037:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.useImsForCall(com.android.internal.telephony.PhoneInternalInterface$DialArgs):boolean");
    }

    public boolean useImsForEmergency() {
        return this.mImsPhone != null && ((CarrierConfigManager) this.mContext.getSystemService("carrier_config")).getConfigForSubId(getSubId()).getBoolean("carrier_use_ims_first_for_emergency_bool") && ImsManager.getInstance(this.mContext, this.mPhoneId).isNonTtyOrTtyOnVolteEnabled() && this.mImsPhone.isImsAvailable();
    }

    public Connection startConference(String[] strArr, PhoneInternalInterface.DialArgs dialArgs) throws CallStateException {
        Phone phone = this.mImsPhone;
        boolean useImsForCall = useImsForCall(dialArgs);
        logd("useImsForCall=" + useImsForCall);
        if (useImsForCall) {
            try {
                logd("Trying IMS PS Conference call");
                return phone.startConference(strArr, dialArgs);
            } catch (CallStateException e) {
                logd("IMS PS conference call exception " + e + "useImsForCall =" + useImsForCall + ", imsPhone =" + phone);
                CallStateException callStateException = new CallStateException(e.getError(), e.getMessage());
                callStateException.setStackTrace(e.getStackTrace());
                throw callStateException;
            }
        } else {
            throw new CallStateException(1, "cannot dial conference call in out of service");
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:129:0x0307  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public com.android.internal.telephony.Connection dial(java.lang.String r19, com.android.internal.telephony.PhoneInternalInterface.DialArgs r20, java.util.function.Consumer<com.android.internal.telephony.Phone> r21) throws com.android.internal.telephony.CallStateException {
        /*
            r18 = this;
            r1 = r18
            r0 = r19
            r2 = r21
            boolean r3 = r18.isPhoneTypeGsm()
            if (r3 != 0) goto L_0x001b
            r3 = r20
            com.android.internal.telephony.UUSInfo r4 = r3.uusInfo
            if (r4 != 0) goto L_0x0013
            goto L_0x001d
        L_0x0013:
            com.android.internal.telephony.CallStateException r0 = new com.android.internal.telephony.CallStateException
            java.lang.String r1 = "Sending UUS information NOT supported in CDMA!"
            r0.<init>(r1)
            throw r0
        L_0x001b:
            r3 = r20
        L_0x001d:
            java.lang.String r4 = r18.checkForTestEmergencyNumber(r19)
            boolean r5 = android.text.TextUtils.equals(r0, r4)
            r6 = 1
            r5 = r5 ^ r6
            if (r5 == 0) goto L_0x0046
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r8 = "dialString replaced for possible emergency number: "
            r7.append(r8)
            r7.append(r0)
            java.lang.String r0 = " -> "
            r7.append(r0)
            r7.append(r4)
            java.lang.String r0 = r7.toString()
            r1.logi(r0)
            goto L_0x0047
        L_0x0046:
            r4 = r0
        L_0x0047:
            android.content.Context r0 = r1.mContext
            java.lang.String r7 = "carrier_config"
            java.lang.Object r0 = r0.getSystemService(r7)
            android.telephony.CarrierConfigManager r0 = (android.telephony.CarrierConfigManager) r0
            android.os.PersistableBundle r0 = r1.onGetCarrierConfig(r0)
            java.lang.String r7 = "support_wps_over_ims_bool"
            boolean r7 = r0.getBoolean(r7)
            java.lang.String r8 = "use_only_dialed_sim_ecc_list_bool"
            boolean r0 = r0.getBoolean(r8)
            android.content.Context r8 = r1.mContext
            java.lang.Class<android.telephony.TelephonyManager> r9 = android.telephony.TelephonyManager.class
            java.lang.Object r8 = r8.getSystemService(r9)
            android.telephony.TelephonyManager r8 = (android.telephony.TelephonyManager) r8
            java.lang.String r9 = "dial; isEmergency="
            if (r0 == 0) goto L_0x0098
            com.android.internal.telephony.emergency.EmergencyNumberTracker r10 = r18.getEmergencyNumberTracker()
            boolean r10 = r10.isEmergencyNumber(r4, r6)
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            r11.append(r9)
            r11.append(r10)
            java.lang.String r9 = " (based on this phone only); globalIsEmergency="
            r11.append(r9)
            boolean r8 = r8.isEmergencyNumber(r4)
            r11.append(r8)
            java.lang.String r8 = r11.toString()
            r1.logi(r8)
            goto L_0x00b3
        L_0x0098:
            boolean r10 = r8.isEmergencyNumber(r4)
            java.lang.StringBuilder r8 = new java.lang.StringBuilder
            r8.<init>()
            r8.append(r9)
            r8.append(r10)
            java.lang.String r9 = " (based on all phones)"
            r8.append(r9)
            java.lang.String r8 = r8.toString()
            r1.logi(r8)
        L_0x00b3:
            r1.onCheckEmergencyCall(r10)
            if (r4 == 0) goto L_0x00d2
            java.lang.String r9 = "*272"
            boolean r9 = r4.startsWith(r9)
            if (r9 != 0) goto L_0x00d0
            java.lang.String r9 = "*31#*272"
            boolean r9 = r4.startsWith(r9)
            if (r9 != 0) goto L_0x00d0
            java.lang.String r9 = "#31#*272"
            boolean r9 = r4.startsWith(r9)
            if (r9 == 0) goto L_0x00d2
        L_0x00d0:
            r9 = r6
            goto L_0x00d3
        L_0x00d2:
            r9 = 0
        L_0x00d3:
            com.android.internal.telephony.imsphone.ImsPhone$ImsDialArgs$Builder r3 = com.android.internal.telephony.imsphone.ImsPhone.ImsDialArgs.Builder.from(r20)
            com.android.internal.telephony.PhoneInternalInterface$DialArgs$Builder r3 = r3.setIsEmergency(r10)
            com.android.internal.telephony.imsphone.ImsPhone$ImsDialArgs$Builder r3 = (com.android.internal.telephony.imsphone.ImsPhone.ImsDialArgs.Builder) r3
            com.android.internal.telephony.imsphone.ImsPhone$ImsDialArgs$Builder r3 = r3.setIsWpsCall(r9)
            com.android.internal.telephony.imsphone.ImsPhone$ImsDialArgs r3 = r3.build()
            r1.mDialArgs = r3
            com.android.internal.telephony.Phone r11 = r1.mImsPhone
            if (r10 == 0) goto L_0x00f3
            boolean r12 = r18.useImsForEmergency()
            if (r12 == 0) goto L_0x00f3
            r12 = r6
            goto L_0x00f4
        L_0x00f3:
            r12 = 0
        L_0x00f4:
            java.lang.String r13 = android.telephony.PhoneNumberUtils.stripSeparators(r4)
            java.lang.String r13 = android.telephony.PhoneNumberUtils.extractNetworkPortionAlt(r13)
            java.lang.String r14 = "*"
            boolean r14 = r13.startsWith(r14)
            java.lang.String r15 = "#"
            if (r14 != 0) goto L_0x010c
            boolean r14 = r13.startsWith(r15)
            if (r14 == 0) goto L_0x0114
        L_0x010c:
            boolean r14 = r13.endsWith(r15)
            if (r14 == 0) goto L_0x0114
            r14 = r6
            goto L_0x0115
        L_0x0114:
            r14 = 0
        L_0x0115:
            boolean r13 = com.android.internal.telephony.imsphone.ImsPhoneMmiCode.isSuppServiceCodes(r13, r1)
            if (r14 == 0) goto L_0x011f
            if (r13 != 0) goto L_0x011f
            r15 = r6
            goto L_0x0120
        L_0x011f:
            r15 = 0
        L_0x0120:
            if (r11 == 0) goto L_0x012a
            boolean r16 = r11.isUtEnabled()
            if (r16 == 0) goto L_0x012a
            r8 = r6
            goto L_0x012b
        L_0x012a:
            r8 = 0
        L_0x012b:
            boolean r16 = r1.useImsForCall(r3)
            if (r16 == 0) goto L_0x0136
            if (r9 == 0) goto L_0x0137
            if (r7 == 0) goto L_0x0136
            goto L_0x0137
        L_0x0136:
            r6 = 0
        L_0x0137:
            boolean r8 = r1.onSetUseImsForUt(r8)
            boolean r6 = r1.onSetUseImsForCall(r6)
            r17 = r5
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            r19 = r3
            java.lang.String r3 = "useImsForCall="
            r5.append(r3)
            r5.append(r6)
            java.lang.String r3 = ", useOnlyDialedSimEccList="
            r5.append(r3)
            r5.append(r0)
            java.lang.String r0 = ", isEmergency="
            r5.append(r0)
            r5.append(r10)
            java.lang.String r0 = ", useImsForEmergency="
            r5.append(r0)
            r5.append(r12)
            java.lang.String r0 = ", useImsForUt="
            r5.append(r0)
            r5.append(r8)
            java.lang.String r0 = ", isUt="
            r5.append(r0)
            r5.append(r14)
            java.lang.String r0 = ", isSuppServiceCode="
            r5.append(r0)
            r5.append(r13)
            java.lang.String r0 = ", isPotentialUssdCode="
            r5.append(r0)
            r5.append(r15)
            java.lang.String r0 = ", isWpsCall="
            r5.append(r0)
            r5.append(r9)
            java.lang.String r0 = ", allowWpsOverIms="
            r5.append(r0)
            r5.append(r7)
            java.lang.String r0 = ", imsPhone="
            r5.append(r0)
            r5.append(r11)
            java.lang.String r0 = ", imsPhone.isVoiceOverCellularImsEnabled()="
            r5.append(r0)
            java.lang.String r0 = "N/A"
            if (r11 == 0) goto L_0x01b3
            boolean r3 = r11.isVoiceOverCellularImsEnabled()
            java.lang.Boolean r3 = java.lang.Boolean.valueOf(r3)
            goto L_0x01b4
        L_0x01b3:
            r3 = r0
        L_0x01b4:
            r5.append(r3)
            java.lang.String r3 = ", imsPhone.isVowifiEnabled()="
            r5.append(r3)
            if (r11 == 0) goto L_0x01c7
            boolean r3 = r11.isWifiCallingEnabled()
            java.lang.Boolean r3 = java.lang.Boolean.valueOf(r3)
            goto L_0x01c8
        L_0x01c7:
            r3 = r0
        L_0x01c8:
            r5.append(r3)
            java.lang.String r3 = ", imsPhone.isVideoEnabled()="
            r5.append(r3)
            if (r11 == 0) goto L_0x01db
            boolean r3 = r11.isVideoEnabled()
            java.lang.Boolean r3 = java.lang.Boolean.valueOf(r3)
            goto L_0x01dc
        L_0x01db:
            r3 = r0
        L_0x01dc:
            r5.append(r3)
            java.lang.String r3 = ", imsPhone.getServiceState().getState()="
            r5.append(r3)
            if (r11 == 0) goto L_0x01f2
            android.telephony.ServiceState r0 = r11.getServiceState()
            int r0 = r0.getState()
            java.lang.Integer r0 = java.lang.Integer.valueOf(r0)
        L_0x01f2:
            r5.append(r0)
            java.lang.String r0 = r5.toString()
            r1.logi(r0)
            if (r10 != 0) goto L_0x020d
            boolean r0 = r18.onCheckIfIgnoreWifiOnlyModeCheck()
            if (r0 != 0) goto L_0x020d
            com.android.internal.telephony.Phone r0 = r1.mImsPhone
            int r3 = r1.mPhoneId
            android.content.Context r5 = r1.mContext
            com.android.internal.telephony.Phone.checkWfcWifiOnlyModeBeforeDial(r0, r3, r5)
        L_0x020d:
            if (r11 == 0) goto L_0x022b
            if (r7 != 0) goto L_0x022b
            if (r6 != 0) goto L_0x022b
            if (r9 == 0) goto L_0x022b
            com.android.internal.telephony.CallTracker r0 = r11.getCallTracker()
            boolean r0 = r0 instanceof com.android.internal.telephony.imsphone.ImsPhoneCallTracker
            if (r0 == 0) goto L_0x022b
            java.lang.String r0 = "WPS call placed over CS; disconnecting all IMS calls.."
            r1.logi(r0)
            com.android.internal.telephony.CallTracker r0 = r11.getCallTracker()
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r0 = (com.android.internal.telephony.imsphone.ImsPhoneCallTracker) r0
            r0.hangupAllConnections()
        L_0x022b:
            if (r6 == 0) goto L_0x0231
            if (r14 == 0) goto L_0x0237
            if (r15 != 0) goto L_0x0237
        L_0x0231:
            if (r14 == 0) goto L_0x0235
            if (r8 != 0) goto L_0x0237
        L_0x0235:
            if (r12 == 0) goto L_0x02b2
        L_0x0237:
            java.lang.String r0 = "Trying IMS PS call"
            r1.logd(r0)     // Catch:{ CallStateException -> 0x0248 }
            r2.accept(r11)     // Catch:{ CallStateException -> 0x0248 }
            r3 = r19
            com.android.internal.telephony.Connection r0 = r11.dial(r4, r3)     // Catch:{ CallStateException -> 0x0246 }
            return r0
        L_0x0246:
            r0 = move-exception
            goto L_0x024b
        L_0x0248:
            r0 = move-exception
            r3 = r19
        L_0x024b:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r7 = "IMS PS call exception "
            r5.append(r7)
            r5.append(r0)
            java.lang.String r7 = "useImsForCall ="
            r5.append(r7)
            r5.append(r6)
            java.lang.String r6 = ", imsPhone ="
            r5.append(r6)
            r5.append(r11)
            java.lang.String r5 = r5.toString()
            r1.logd(r5)
            java.lang.String r5 = r0.getMessage()
            java.lang.String r6 = "cs_fallback"
            boolean r5 = r6.equals(r5)
            if (r5 != 0) goto L_0x0294
            if (r10 == 0) goto L_0x027f
            goto L_0x0294
        L_0x027f:
            com.android.internal.telephony.CallStateException r1 = new com.android.internal.telephony.CallStateException
            int r2 = r0.getError()
            java.lang.String r3 = r0.getMessage()
            r1.<init>(r2, r3)
            java.lang.StackTraceElement[] r0 = r0.getStackTrace()
            r1.setStackTrace(r0)
            throw r1
        L_0x0294:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r6 = "IMS call failed with Exception: "
            r5.append(r6)
            java.lang.String r0 = r0.getMessage()
            r5.append(r0)
            java.lang.String r0 = ". Falling back to CS."
            r5.append(r0)
            java.lang.String r0 = r5.toString()
            r1.logi(r0)
            goto L_0x02b4
        L_0x02b2:
            r3 = r19
        L_0x02b4:
            com.android.internal.telephony.ServiceStateTracker r0 = r1.mSST
            if (r0 == 0) goto L_0x02dc
            android.telephony.ServiceState r0 = r0.mSS
            int r0 = r0.getState()
            r5 = 1
            if (r0 != r5) goto L_0x02dc
            com.android.internal.telephony.ServiceStateTracker r0 = r1.mSST
            android.telephony.ServiceState r0 = r0.mSS
            int r0 = r0.getDataRegistrationState()
            if (r0 == 0) goto L_0x02dc
            if (r10 != 0) goto L_0x02dc
            boolean r0 = r18.onCheckIfIgnoreServiceState()
            if (r0 == 0) goto L_0x02d4
            goto L_0x02dc
        L_0x02d4:
            com.android.internal.telephony.CallStateException r0 = new com.android.internal.telephony.CallStateException
            java.lang.String r1 = "cannot dial in current state"
            r0.<init>(r1)
            throw r0
        L_0x02dc:
            com.android.internal.telephony.ServiceStateTracker r0 = r1.mSST
            if (r0 == 0) goto L_0x0303
            android.telephony.ServiceState r0 = r0.mSS
            int r0 = r0.getState()
            r5 = 3
            if (r0 != r5) goto L_0x0303
            int r0 = r3.videoState
            boolean r0 = android.telecom.VideoProfile.isVideo(r0)
            if (r0 != 0) goto L_0x0303
            if (r10 != 0) goto L_0x0303
            if (r14 == 0) goto L_0x02f7
            if (r8 != 0) goto L_0x0303
        L_0x02f7:
            if (r15 == 0) goto L_0x02fa
            goto L_0x0303
        L_0x02fa:
            com.android.internal.telephony.CallStateException r0 = new com.android.internal.telephony.CallStateException
            r1 = 2
            java.lang.String r2 = "cannot dial voice call in airplane mode"
            r0.<init>(r1, r2)
            throw r0
        L_0x0303:
            com.android.internal.telephony.ServiceStateTracker r0 = r1.mSST
            if (r0 == 0) goto L_0x0344
            android.telephony.ServiceState r0 = r0.mSS
            int r0 = r0.getState()
            r5 = 1
            if (r0 != r5) goto L_0x0345
            com.android.internal.telephony.ServiceStateTracker r0 = r1.mSST
            android.telephony.ServiceState r0 = r0.mSS
            int r0 = r0.getDataRegistrationState()
            if (r0 != 0) goto L_0x0328
            com.android.internal.telephony.ServiceStateTracker r0 = r1.mSST
            android.telephony.ServiceState r0 = r0.mSS
            int r0 = r0.getRilDataRadioTechnology()
            boolean r0 = android.telephony.ServiceState.isPsOnlyTech(r0)
            if (r0 != 0) goto L_0x0344
        L_0x0328:
            int r0 = r3.videoState
            boolean r0 = android.telecom.VideoProfile.isVideo(r0)
            if (r0 != 0) goto L_0x0344
            if (r10 != 0) goto L_0x0344
            if (r15 != 0) goto L_0x0344
            boolean r0 = r18.onCheckIfIgnoreServiceState()
            if (r0 == 0) goto L_0x033b
            goto L_0x0344
        L_0x033b:
            com.android.internal.telephony.CallStateException r0 = new com.android.internal.telephony.CallStateException
            java.lang.String r1 = "cannot dial voice call in out of service"
            r5 = 1
            r0.<init>(r5, r1)
            throw r0
        L_0x0344:
            r5 = 1
        L_0x0345:
            java.lang.String r0 = "Trying (non-IMS) CS call"
            r1.logd(r0)
            if (r17 == 0) goto L_0x0355
            if (r10 == 0) goto L_0x0355
            r1.mIsTestingEmergencyCallbackMode = r5
            com.android.internal.telephony.CommandsInterface r0 = r1.mCi
            r0.testingEmergencyCall()
        L_0x0355:
            r2.accept(r1)
            com.android.internal.telephony.Connection r0 = r1.dialInternal(r4, r3)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.dial(java.lang.String, com.android.internal.telephony.PhoneInternalInterface$DialArgs, java.util.function.Consumer):com.android.internal.telephony.Connection");
    }

    public boolean isNotificationOfWfcCallRequired(String str) {
        PersistableBundle configForSubId = ((CarrierConfigManager) this.mContext.getSystemService("carrier_config")).getConfigForSubId(getSubId());
        if (!(configForSubId != null && configForSubId.getBoolean("notify_international_call_on_wfc_bool"))) {
            return false;
        }
        Phone phone = this.mImsPhone;
        boolean isEmergencyNumber = ((TelephonyManager) this.mContext.getSystemService(TelephonyManager.class)).isEmergencyNumber(str);
        if (!isImsUseEnabled() || phone == null || phone.isVoiceOverCellularImsEnabled() || !phone.isWifiCallingEnabled() || isEmergencyNumber || !PhoneNumberUtils.isInternationalNumber(str, getCountryIso())) {
            return false;
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public Connection dialInternal(String str, PhoneInternalInterface.DialArgs dialArgs) throws CallStateException {
        return dialInternal(str, dialArgs, (ResultReceiver) null);
    }

    /* access modifiers changed from: protected */
    public Connection dialInternal(String str, PhoneInternalInterface.DialArgs dialArgs, ResultReceiver resultReceiver) throws CallStateException {
        String stripSeparators = PhoneNumberUtils.stripSeparators(str);
        if (!isPhoneTypeGsm()) {
            return this.mCT.dial(stripSeparators, dialArgs);
        }
        if (handleInCallMmiCommands(stripSeparators)) {
            return null;
        }
        GsmMmiCode onCreateGsmMmiCode = onCreateGsmMmiCode(PhoneNumberUtils.extractNetworkPortionAlt(stripSeparators), this.mUiccApplication.get(), resultReceiver);
        logd("dialInternal: dialing w/ mmi '" + onCreateGsmMmiCode + "'...");
        if (onCreateGsmMmiCode == null) {
            return this.mCT.dialGsm(stripSeparators, dialArgs);
        }
        if (onCreateGsmMmiCode.isTemporaryModeCLIR()) {
            return this.mCT.dialGsm(onCreateGsmMmiCode.mDialingNumber, onCreateGsmMmiCode.getCLIRMode(), dialArgs.uusInfo, dialArgs.intentExtras);
        }
        this.mPendingMMIs.add(onCreateGsmMmiCode);
        onPendingMmiAdded(str, onCreateGsmMmiCode);
        this.mMmiRegistrants.notifyRegistrants(new AsyncResult((Object) null, onCreateGsmMmiCode, (Throwable) null));
        onCreateGsmMmiCode.processCode();
        return null;
    }

    public boolean handlePinMmi(String str) {
        MmiCode mmiCode;
        if (isPhoneTypeGsm()) {
            mmiCode = GsmMmiCode.newFromDialString(str, this, this.mUiccApplication.get());
        } else {
            mmiCode = CdmaMmiCode.newFromDialString(str, this, this.mUiccApplication.get());
        }
        if (mmiCode == null || !mmiCode.isPinPukCommand()) {
            loge("Mmi is null or unrecognized!");
            return false;
        }
        this.mPendingMMIs.add(mmiCode);
        this.mMmiRegistrants.notifyRegistrants(new AsyncResult((Object) null, mmiCode, (Throwable) null));
        try {
            mmiCode.processCode();
            return true;
        } catch (CallStateException unused) {
            return true;
        }
    }

    /* access modifiers changed from: protected */
    public void sendUssdResponse(String str, CharSequence charSequence, int i, ResultReceiver resultReceiver) {
        UssdResponse ussdResponse = new UssdResponse(str, charSequence);
        Bundle bundle = new Bundle();
        bundle.putParcelable("USSD_RESPONSE", ussdResponse);
        resultReceiver.send(i, bundle);
    }

    public boolean handleUssdRequest(String str, ResultReceiver resultReceiver) {
        if (!isPhoneTypeGsm() || this.mPendingMMIs.size() > 0) {
            sendUssdResponse(str, (CharSequence) null, -1, resultReceiver);
            return true;
        }
        Phone phone = this.mImsPhone;
        if (phone != null && (phone.getServiceState().getState() == 0 || phone.isUtEnabled())) {
            try {
                logd("handleUssdRequest: attempting over IMS");
                return phone.handleUssdRequest(str, resultReceiver);
            } catch (CallStateException e) {
                if (!Phone.CS_FALLBACK.equals(e.getMessage())) {
                    return false;
                }
                logd("handleUssdRequest: fallback to CS required");
            }
        }
        try {
            dialInternal(str, new PhoneInternalInterface.DialArgs.Builder().build(), resultReceiver);
            return true;
        } catch (Exception e2) {
            logd("handleUssdRequest: exception" + e2);
            return false;
        }
    }

    public void sendUssdResponse(String str) {
        if (isPhoneTypeGsm()) {
            GsmMmiCode newFromUssdUserInput = GsmMmiCode.newFromUssdUserInput(str, this, this.mUiccApplication.get());
            this.mPendingMMIs.add(newFromUssdUserInput);
            this.mMmiRegistrants.notifyRegistrants(new AsyncResult((Object) null, newFromUssdUserInput, (Throwable) null));
            newFromUssdUserInput.sendUssd(str);
            return;
        }
        loge("sendUssdResponse: not possible in CDMA");
    }

    public void sendDtmf(char c) {
        if (!PhoneNumberUtils.is12Key(c)) {
            loge("sendDtmf called with invalid character '" + c + "'");
        } else if (this.mCT.mState == PhoneConstants.State.OFFHOOK) {
            this.mCi.sendDtmf(c, (Message) null);
        }
    }

    public void startDtmf(char c) {
        if (!PhoneNumberUtils.is12Key(c)) {
            loge("startDtmf called with invalid character '" + c + "'");
            return;
        }
        this.mCi.startDtmf(c, (Message) null);
    }

    public void stopDtmf() {
        this.mCi.stopDtmf((Message) null);
    }

    public void sendBurstDtmf(String str, int i, int i2, Message message) {
        if (isPhoneTypeGsm()) {
            loge("[GsmCdmaPhone] sendBurstDtmf() is a CDMA method");
            return;
        }
        boolean z = false;
        int i3 = 0;
        while (true) {
            if (i3 >= str.length()) {
                z = true;
                break;
            } else if (!PhoneNumberUtils.is12Key(str.charAt(i3))) {
                Rlog.e(LOG_TAG, "sendDtmf called with invalid character '" + str.charAt(i3) + "'");
                break;
            } else {
                i3++;
            }
        }
        if (this.mCT.mState == PhoneConstants.State.OFFHOOK && z) {
            this.mCi.sendBurstDtmf(str, i, i2, message);
        }
    }

    public void setRadioPowerOnForTestEmergencyCall(boolean z) {
        this.mSST.clearAllRadioOffReasons();
        setRadioPower(true, false, z, false);
    }

    public void setRadioPower(boolean z, boolean z2, boolean z3, boolean z4) {
        setRadioPowerForReason(z, z2, z3, z4, 0);
    }

    public void setRadioPowerForReason(boolean z, boolean z2, boolean z3, boolean z4, int i) {
        this.mSST.setRadioPowerForReason(z, z2, z3, z4, i);
    }

    private void storeVoiceMailNumber(String str) {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(getContext()).edit();
        setVmSimImsi(getSubscriberId());
        logd("storeVoiceMailNumber: mPrecisePhoneType=" + this.mPrecisePhoneType + " vmNumber=" + Rlog.pii(LOG_TAG, str));
        if (isPhoneTypeGsm()) {
            edit.putString(VM_NUMBER + getPhoneId(), str);
            edit.apply();
            return;
        }
        edit.putString(VM_NUMBER_CDMA + getPhoneId(), str);
        edit.apply();
    }

    public String getVoiceMailNumber() {
        String str;
        PersistableBundle configForSubId;
        PersistableBundle configForSubId2;
        if (isPhoneTypeGsm() || this.mSimRecords != null) {
            IccRecords iccRecords = isPhoneTypeGsm() ? this.mIccRecords.get() : this.mSimRecords;
            str = iccRecords != null ? iccRecords.getVoiceMailNumber() : "";
            if (TextUtils.isEmpty(str)) {
                SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getContext());
                String str2 = isPhoneTypeGsm() ? VM_NUMBER : VM_NUMBER_CDMA;
                str = defaultSharedPreferences.getString(str2 + getPhoneId(), (String) null);
                logd("getVoiceMailNumber: from " + str2 + " number=" + Rlog.pii(LOG_TAG, str));
            } else {
                logd("getVoiceMailNumber: from IccRecords number=" + Rlog.pii(LOG_TAG, str));
            }
        } else {
            str = null;
        }
        if (!isPhoneTypeGsm() && TextUtils.isEmpty(str)) {
            str = PreferenceManager.getDefaultSharedPreferences(getContext()).getString(VM_NUMBER_CDMA + getPhoneId(), (String) null);
            logd("getVoiceMailNumber: from VM_NUMBER_CDMA number=" + str);
        }
        if (TextUtils.isEmpty(str) && (configForSubId2 = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId())) != null) {
            String string = configForSubId2.getString("default_vm_number_string");
            String string2 = configForSubId2.getString("default_vm_number_roaming_string");
            String string3 = configForSubId2.getString("default_vm_number_roaming_and_ims_unregistered_string");
            if (!TextUtils.isEmpty(string)) {
                str = string;
            }
            if (this.mSST.mSS.getRoaming()) {
                if (!TextUtils.isEmpty(string3) && !this.mSST.isImsRegistered()) {
                    str = string3;
                } else if (!TextUtils.isEmpty(string2)) {
                    str = string2;
                }
            }
        }
        return (!TextUtils.isEmpty(str) || (configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId())) == null || !configForSubId.getBoolean("config_telephony_use_own_number_for_voicemail_bool")) ? str : getLine1Number();
    }

    private String getVmSimImsi() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getContext());
        return defaultSharedPreferences.getString(VM_SIM_IMSI + getPhoneId(), (String) null);
    }

    private void setVmSimImsi(String str) {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(getContext()).edit();
        edit.putString(VM_SIM_IMSI + getPhoneId(), str);
        edit.apply();
    }

    public String getVoiceMailAlphaTag() {
        String str = "";
        if (isPhoneTypeGsm() || this.mSimRecords != null) {
            IccRecords iccRecords = isPhoneTypeGsm() ? this.mIccRecords.get() : this.mSimRecords;
            if (iccRecords != null) {
                str = iccRecords.getVoiceMailAlphaTag();
            }
        }
        if (str == null || str.length() == 0) {
            return this.mContext.getText(17039364).toString();
        }
        return str;
    }

    public String getDeviceId() {
        if (isPhoneTypeGsm()) {
            return this.mImei;
        }
        if (((CarrierConfigManager) this.mContext.getSystemService("carrier_config")).getConfigForSubId(getSubId()).getBoolean("force_imei_bool")) {
            return this.mImei;
        }
        String meid = getMeid();
        if (meid != null && !meid.matches("^0*$")) {
            return meid;
        }
        loge("getDeviceId(): MEID is not initialized use ESN");
        return getEsn();
    }

    public String getDeviceSvn() {
        if (isPhoneTypeGsm() || isPhoneTypeCdmaLte()) {
            return this.mImeiSv;
        }
        loge("getDeviceSvn(): return 0");
        return "0";
    }

    public IsimRecords getIsimRecords() {
        return this.mIsimUiccRecords;
    }

    public String getImei() {
        return this.mImei;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getEsn() {
        if (!isPhoneTypeGsm()) {
            return this.mEsn;
        }
        loge("[GsmCdmaPhone] getEsn() is a CDMA method");
        return "0";
    }

    public String getMeid() {
        return this.mMeid;
    }

    public String getNai() {
        IccRecords iccRecords = this.mUiccController.getIccRecords(this.mPhoneId, 2);
        if (Log.isLoggable(LOG_TAG, 2)) {
            Rlog.v(LOG_TAG, "IccRecords is " + iccRecords);
        }
        if (iccRecords != null) {
            return iccRecords.getNAI();
        }
        return null;
    }

    public String getSubscriberId() {
        if (isPhoneTypeCdma()) {
            return this.mSST.getImsi();
        }
        IccRecords iccRecords = this.mUiccController.getIccRecords(this.mPhoneId, 1);
        if (iccRecords != null) {
            return iccRecords.getIMSI();
        }
        return null;
    }

    public ImsiEncryptionInfo getCarrierInfoForImsiEncryption(int i, boolean z) {
        TelephonyManager createForSubscriptionId = ((TelephonyManager) this.mContext.getSystemService(TelephonyManager.class)).createForSubscriptionId(getSubId());
        return CarrierInfoManager.getCarrierInfoForImsiEncryption(i, this.mContext, createForSubscriptionId.getSimOperator(), createForSubscriptionId.getSimCarrierId(), z, getSubId());
    }

    public void setCarrierInfoForImsiEncryption(ImsiEncryptionInfo imsiEncryptionInfo) {
        CarrierInfoManager.setCarrierInfoForImsiEncryption(imsiEncryptionInfo, this.mContext, this.mPhoneId);
        this.mCi.setCarrierInfoForImsiEncryption(imsiEncryptionInfo, (Message) null);
    }

    public void deleteCarrierInfoForImsiEncryption(int i) {
        CarrierInfoManager.deleteCarrierInfoForImsiEncryption(this.mContext, getSubId(), i);
    }

    public int getCarrierId() {
        CarrierResolver carrierResolver = this.mCarrierResolver;
        return carrierResolver != null ? carrierResolver.getCarrierId() : super.getCarrierId();
    }

    public String getCarrierName() {
        CarrierResolver carrierResolver = this.mCarrierResolver;
        return carrierResolver != null ? carrierResolver.getCarrierName() : super.getCarrierName();
    }

    public int getMNOCarrierId() {
        CarrierResolver carrierResolver = this.mCarrierResolver;
        return carrierResolver != null ? carrierResolver.getMnoCarrierId() : super.getMNOCarrierId();
    }

    public int getSpecificCarrierId() {
        CarrierResolver carrierResolver = this.mCarrierResolver;
        return carrierResolver != null ? carrierResolver.getSpecificCarrierId() : super.getSpecificCarrierId();
    }

    public String getSpecificCarrierName() {
        CarrierResolver carrierResolver = this.mCarrierResolver;
        return carrierResolver != null ? carrierResolver.getSpecificCarrierName() : super.getSpecificCarrierName();
    }

    public void resolveSubscriptionCarrierId(String str) {
        CarrierResolver carrierResolver = this.mCarrierResolver;
        if (carrierResolver != null) {
            carrierResolver.resolveSubscriptionCarrierId(str);
        }
    }

    public int getCarrierIdListVersion() {
        CarrierResolver carrierResolver = this.mCarrierResolver;
        return carrierResolver != null ? carrierResolver.getCarrierListVersion() : super.getCarrierIdListVersion();
    }

    public int getEmergencyNumberDbVersion() {
        return getEmergencyNumberTracker().getEmergencyNumberDbVersion();
    }

    public void resetCarrierKeysForImsiEncryption() {
        this.mCIM.resetCarrierKeysForImsiEncryption(this.mContext, this.mPhoneId);
    }

    public void setCarrierTestOverride(String str, String str2, String str3, String str4, String str5, String str6, String str7, String str8, String str9) {
        List list;
        String str10 = str8;
        this.mCarrierResolver.setTestOverrideApn(str9);
        UiccProfile uiccProfileForPhone = this.mUiccController.getUiccProfileForPhone(getPhoneId());
        IccRecords iccRecords = null;
        if (uiccProfileForPhone != null) {
            if (str10 == null) {
                list = null;
            } else if (str8.isEmpty()) {
                list = Collections.emptyList();
            } else {
                list = Collections.singletonList(new UiccAccessRule(IccUtils.hexStringToBytes(str8), (String) null, 0));
            }
            uiccProfileForPhone.setTestOverrideCarrierPrivilegeRules(list);
        } else {
            this.mCarrierResolver.setTestOverrideCarrierPriviledgeRule(str10);
        }
        if (isPhoneTypeGsm()) {
            iccRecords = this.mIccRecords.get();
        } else if (isPhoneTypeCdmaLte()) {
            iccRecords = this.mSimRecords;
        } else {
            loge("setCarrierTestOverride fails in CDMA only");
        }
        IccRecords iccRecords2 = iccRecords;
        if (iccRecords2 != null) {
            iccRecords2.setCarrierTestOverride(str, str2, str3, str4, str5, str6, str7);
        }
    }

    public String getGroupIdLevel1() {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                return iccRecords.getGid1();
            }
            return null;
        } else if (isPhoneTypeCdma()) {
            loge("GID1 is not available in CDMA");
            return null;
        } else {
            SIMRecords sIMRecords = this.mSimRecords;
            return sIMRecords != null ? sIMRecords.getGid1() : "";
        }
    }

    public String getGroupIdLevel2() {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                return iccRecords.getGid2();
            }
            return null;
        } else if (isPhoneTypeCdma()) {
            loge("GID2 is not available in CDMA");
            return null;
        } else {
            SIMRecords sIMRecords = this.mSimRecords;
            return sIMRecords != null ? sIMRecords.getGid2() : "";
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getLine1Number() {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                return iccRecords.getMsisdnNumber();
            }
            return null;
        } else if (!((CarrierConfigManager) this.mContext.getSystemService("carrier_config")).getConfigForSubId(getSubId()).getBoolean("use_usim_bool")) {
            return this.mSST.getMdnNumber();
        } else {
            SIMRecords sIMRecords = this.mSimRecords;
            if (sIMRecords != null) {
                return sIMRecords.getMsisdnNumber();
            }
            return null;
        }
    }

    public String getPlmn() {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                return iccRecords.getPnnHomeName();
            }
            return null;
        } else if (isPhoneTypeCdma()) {
            loge("Plmn is not available in CDMA");
            return null;
        } else {
            SIMRecords sIMRecords = this.mSimRecords;
            if (sIMRecords != null) {
                return sIMRecords.getPnnHomeName();
            }
            return null;
        }
    }

    /* access modifiers changed from: protected */
    public void updateManualNetworkSelection(Phone.NetworkSelectMessage networkSelectMessage) {
        int subId = getSubId();
        if (SubscriptionManager.isValidSubscriptionId(subId)) {
            this.mManualNetworkSelectionPlmn = networkSelectMessage.operatorNumeric;
            return;
        }
        this.mManualNetworkSelectionPlmn = null;
        Rlog.e(LOG_TAG, "Cannot update network selection due to invalid subId " + subId);
    }

    public String getManualNetworkSelectionPlmn() {
        String str = this.mManualNetworkSelectionPlmn;
        return str == null ? "" : str;
    }

    public String getCdmaPrlVersion() {
        return this.mSST.getPrlVersion();
    }

    public String getCdmaMin() {
        return this.mSST.getCdmaMin();
    }

    public boolean isMinInfoReady() {
        return this.mSST.isMinInfoReady();
    }

    public String getMsisdn() {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                return iccRecords.getMsisdnNumber();
            }
            return null;
        } else if (isPhoneTypeCdmaLte()) {
            SIMRecords sIMRecords = this.mSimRecords;
            if (sIMRecords != null) {
                return sIMRecords.getMsisdnNumber();
            }
            return null;
        } else {
            loge("getMsisdn: not expected on CDMA");
            return null;
        }
    }

    public String getLine1AlphaTag() {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                return iccRecords.getMsisdnAlphaTag();
            }
            return null;
        }
        loge("getLine1AlphaTag: not possible in CDMA");
        return null;
    }

    public boolean setLine1Number(String str, String str2, Message message) {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords == null) {
                return false;
            }
            iccRecords.setMsisdnNumber(str, str2, message);
            return true;
        }
        loge("setLine1Number: not possible in CDMA");
        return false;
    }

    public void setVoiceMailNumber(String str, String str2, Message message) {
        SIMRecords sIMRecords;
        this.mVmNumber = str2;
        Message obtainMessage = obtainMessage(20, 0, 0, message);
        IccRecords iccRecords = this.mIccRecords.get();
        if (!isPhoneTypeGsm() && (sIMRecords = this.mSimRecords) != null) {
            iccRecords = sIMRecords;
        }
        if (iccRecords != null) {
            iccRecords.setVoiceMailNumber(str, this.mVmNumber, obtainMessage);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getSystemProperty(String str, String str2) {
        if (getUnitTestMode()) {
            return null;
        }
        return TelephonyManager.getTelephonyProperty(this.mPhoneId, str, str2);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r1 = r1.mImsPhone;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isImsUtEnabledOverCdma() {
        /*
            r1 = this;
            boolean r0 = r1.isPhoneTypeCdmaLte()
            if (r0 == 0) goto L_0x0012
            com.android.internal.telephony.Phone r1 = r1.mImsPhone
            if (r1 == 0) goto L_0x0012
            boolean r1 = r1.isUtEnabled()
            if (r1 == 0) goto L_0x0012
            r1 = 1
            goto L_0x0013
        L_0x0012:
            r1 = 0
        L_0x0013:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.isImsUtEnabledOverCdma():boolean");
    }

    /* access modifiers changed from: protected */
    public boolean isCsRetry(Message message) {
        if (message != null) {
            return message.getData().getBoolean(Phone.CS_FALLBACK_SS, false);
        }
        return false;
    }

    private void updateSsOverCdmaSupported(PersistableBundle persistableBundle) {
        if (persistableBundle != null) {
            this.mSsOverCdmaSupported = persistableBundle.getBoolean("support_ss_over_cdma_bool");
        }
    }

    public boolean useSsOverIms(Message message) {
        boolean isUtEnabled = isUtEnabled();
        Rlog.d(LOG_TAG, "useSsOverIms: isUtEnabled()= " + isUtEnabled + " isCsRetry(onComplete))= " + isCsRetry(message));
        return isUtEnabled && !isCsRetry(message);
    }

    public void getCallForwardingOption(int i, Message message) {
        getCallForwardingOption(i, 1, message);
    }

    public void getCallForwardingOption(int i, int i2, Message message) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.getCallForwardingOption(i, i2, message);
        } else if (!isPhoneTypeGsm()) {
            if (!this.mSsOverCdmaSupported) {
                AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.INVALID_STATE, "Call Forwarding over CDMA unavailable"));
            } else {
                loge("getCallForwardingOption: not possible in CDMA, just return empty result");
                AsyncResult.forMessage(message, makeEmptyCallForward(), (Throwable) null);
            }
            message.sendToTarget();
        } else if (isValidCommandInterfaceCFReason(i)) {
            logd("requesting call forwarding query.");
            if (i == 0) {
                message = obtainMessage(13, message);
            }
            this.mCi.queryCallForwardStatus(i, i2, (String) null, message);
        }
    }

    public void setCallForwardingOption(int i, int i2, String str, int i3, Message message) {
        setCallForwardingOption(i, i2, str, 1, i3, message);
    }

    public void setCallForwardingOption(int i, int i2, String str, int i3, int i4, Message message) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.setCallForwardingOption(i, i2, str, i3, i4, message);
        } else if (isPhoneTypeGsm()) {
            if (isValidCommandInterfaceCFAction(i) && isValidCommandInterfaceCFReason(i2)) {
                if (i2 == 0) {
                    message = obtainMessage(12, isCfEnable(i) ? 1 : 0, 0, new Cfu(str, message));
                }
                this.mCi.setCallForward(i, i2, i3, str, i4, message);
            }
        } else if (this.mSsOverCdmaSupported) {
            String callForwardingPrefixAndNumber = CdmaMmiCode.getCallForwardingPrefixAndNumber(i, i2, GsmCdmaConnection.formatDialString(str));
            loge("setCallForwardingOption: dial for set call forwarding prefixWithNumber= " + callForwardingPrefixAndNumber + " number= " + str);
            PhoneAccountHandle subscriptionIdToPhoneAccountHandle = subscriptionIdToPhoneAccountHandle(getSubId());
            Bundle bundle = new Bundle();
            bundle.putParcelable("android.telecom.extra.PHONE_ACCOUNT_HANDLE", subscriptionIdToPhoneAccountHandle);
            TelecomManager.from(this.mContext).placeCall(Uri.fromParts("tel", callForwardingPrefixAndNumber, (String) null), bundle);
            AsyncResult.forMessage(message, 255, (Throwable) null);
            message.sendToTarget();
        } else {
            loge("setCallForwardingOption: SS over CDMA not supported, can not complete");
            AsyncResult.forMessage(message, 255, (Throwable) null);
            message.sendToTarget();
        }
    }

    public void getCallBarring(String str, String str2, Message message, int i) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.getCallBarring(str, str2, message, i);
        } else if (isPhoneTypeGsm()) {
            this.mCi.queryFacilityLock(str, str2, i, message);
        } else {
            loge("getCallBarringOption: not possible in CDMA");
        }
    }

    public void setCallBarring(String str, boolean z, String str2, Message message, int i) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.setCallBarring(str, z, str2, message, i);
        } else if (isPhoneTypeGsm()) {
            this.mCi.setFacilityLock(str, z, str2, i, message);
        } else {
            loge("setCallBarringOption: not possible in CDMA");
        }
    }

    public void changeCallBarringPassword(String str, String str2, String str3, Message message) {
        if (isPhoneTypeGsm()) {
            this.mCi.changeBarringPassword(str, str2, str3, message);
        } else {
            loge("changeCallBarringPassword: not possible in CDMA");
        }
    }

    public void getOutgoingCallerIdDisplay(Message message) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.getOutgoingCallerIdDisplay(message);
        } else if (isPhoneTypeGsm()) {
            this.mCi.getCLIR(message);
        } else {
            loge("getOutgoingCallerIdDisplay: not possible in CDMA");
            AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.REQUEST_NOT_SUPPORTED));
            message.sendToTarget();
        }
    }

    public void setOutgoingCallerIdDisplay(int i, Message message) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.setOutgoingCallerIdDisplay(i, message);
        } else if (isPhoneTypeGsm()) {
            this.mCi.setCLIR(i, obtainMessage(18, i, 0, message));
        } else {
            loge("setOutgoingCallerIdDisplay: not possible in CDMA");
            AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.REQUEST_NOT_SUPPORTED));
            message.sendToTarget();
        }
    }

    public void queryCLIP(Message message) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.queryCLIP(message);
        } else if (isPhoneTypeGsm()) {
            this.mCi.queryCLIP(message);
        } else {
            loge("queryCLIP: not possible in CDMA");
            AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.REQUEST_NOT_SUPPORTED));
            message.sendToTarget();
        }
    }

    public void getCallWaiting(Message message) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.getCallWaiting(message);
        } else if (isPhoneTypeGsm()) {
            this.mCi.queryCallWaiting(0, message);
        } else {
            if (!this.mSsOverCdmaSupported) {
                AsyncResult.forMessage(message, (Object) null, new CommandException(CommandException.Error.INVALID_STATE, "Call Waiting over CDMA unavailable"));
            } else {
                AsyncResult.forMessage(message, new int[]{255, 0}, (Throwable) null);
            }
            message.sendToTarget();
        }
    }

    public void setCallWaiting(boolean z, Message message) {
        PersistableBundle configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId());
        int i = 1;
        if (configForSubId != null) {
            i = configForSubId.getInt("call_waiting_service_class_int", 1);
        }
        setCallWaiting(z, i, message);
    }

    public void setCallWaiting(boolean z, int i, Message message) {
        Phone phone = this.mImsPhone;
        if (useSsOverIms(message)) {
            phone.setCallWaiting(z, message);
        } else if (isPhoneTypeGsm()) {
            this.mCi.setCallWaiting(z, i, message);
        } else if (this.mSsOverCdmaSupported) {
            String callWaitingPrefix = CdmaMmiCode.getCallWaitingPrefix(z);
            Rlog.i(LOG_TAG, "setCallWaiting in CDMA : dial for set call waiting prefix= " + callWaitingPrefix);
            PhoneAccountHandle subscriptionIdToPhoneAccountHandle = subscriptionIdToPhoneAccountHandle(getSubId());
            Bundle bundle = new Bundle();
            bundle.putParcelable("android.telecom.extra.PHONE_ACCOUNT_HANDLE", subscriptionIdToPhoneAccountHandle);
            TelecomManager.from(this.mContext).placeCall(Uri.fromParts("tel", callWaitingPrefix, (String) null), bundle);
            AsyncResult.forMessage(message, 255, (Throwable) null);
            message.sendToTarget();
        } else {
            loge("setCallWaiting: SS over CDMA not supported, can not complete");
            AsyncResult.forMessage(message, 255, (Throwable) null);
            message.sendToTarget();
        }
    }

    public void getAvailableNetworks(Message message) {
        if (isPhoneTypeGsm() || isPhoneTypeCdmaLte()) {
            this.mCi.getAvailableNetworks(obtainMessage(51, message));
            return;
        }
        loge("getAvailableNetworks: not possible in CDMA");
    }

    public void startNetworkScan(NetworkScanRequest networkScanRequest, Message message) {
        this.mCi.startNetworkScan(networkScanRequest, message);
    }

    public void stopNetworkScan(Message message) {
        this.mCi.stopNetworkScan(message);
    }

    public void setTTYMode(int i, Message message) {
        super.setTTYMode(i, message);
        Phone phone = this.mImsPhone;
        if (phone != null) {
            phone.setTTYMode(i, message);
        }
    }

    public void setUiTTYMode(int i, Message message) {
        Phone phone = this.mImsPhone;
        if (phone != null) {
            phone.setUiTTYMode(i, message);
        }
    }

    public void setMute(boolean z) {
        this.mCT.setMute(z);
    }

    public boolean getMute() {
        return this.mCT.getMute();
    }

    public void updateServiceLocation(WorkSource workSource) {
        this.mSST.enableSingleLocationUpdate(workSource);
    }

    public void enableLocationUpdates() {
        this.mSST.enableLocationUpdates();
    }

    public void disableLocationUpdates() {
        this.mSST.disableLocationUpdates();
    }

    public boolean getDataRoamingEnabled() {
        if (isUsingNewDataStack()) {
            return getDataSettingsManager().isDataRoamingEnabled();
        }
        if (getDcTracker(1) != null) {
            return getDcTracker(1).getDataRoamingEnabled();
        }
        return false;
    }

    public void setDataRoamingEnabled(boolean z) {
        if (isUsingNewDataStack()) {
            getDataSettingsManager().setDataRoamingEnabled(z);
        } else if (getDcTracker(1) != null) {
            getDcTracker(1).setDataRoamingEnabledByUser(z);
        }
    }

    public void registerForCdmaOtaStatusChange(Handler handler, int i, Object obj) {
        this.mCi.registerForCdmaOtaProvision(handler, i, obj);
    }

    public void unregisterForCdmaOtaStatusChange(Handler handler) {
        this.mCi.unregisterForCdmaOtaProvision(handler);
    }

    public void registerForSubscriptionInfoReady(Handler handler, int i, Object obj) {
        this.mSST.registerForSubscriptionInfoReady(handler, i, obj);
    }

    public void unregisterForSubscriptionInfoReady(Handler handler) {
        this.mSST.unregisterForSubscriptionInfoReady(handler);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setOnEcbModeExitResponse(Handler handler, int i, Object obj) {
        this.mEcmExitRespRegistrant = new Registrant(handler, i, obj);
    }

    public void unsetOnEcbModeExitResponse(Handler handler) {
        this.mEcmExitRespRegistrant.clear();
    }

    public void registerForCallWaiting(Handler handler, int i, Object obj) {
        this.mCT.registerForCallWaiting(handler, i, obj);
    }

    public void unregisterForCallWaiting(Handler handler) {
        this.mCT.unregisterForCallWaiting(handler);
    }

    public boolean isUserDataEnabled() {
        if (isUsingNewDataStack()) {
            return getDataSettingsManager().isDataEnabledForReason(0);
        }
        if (this.mDataEnabledSettings.isProvisioning()) {
            return this.mDataEnabledSettings.isProvisioningDataEnabled();
        }
        return this.mDataEnabledSettings.isUserDataEnabled();
    }

    public void onMMIDone(MmiCode mmiCode) {
        if (this.mPendingMMIs.remove(mmiCode) || (isPhoneTypeGsm() && (mmiCode.isUssdRequest() || ((GsmMmiCode) mmiCode).isSsInfo()))) {
            ResultReceiver ussdCallbackReceiver = mmiCode.getUssdCallbackReceiver();
            if (ussdCallbackReceiver != null) {
                Rlog.i(LOG_TAG, "onMMIDone: invoking callback: " + mmiCode);
                sendUssdResponse(mmiCode.getDialString(), mmiCode.getMessage(), mmiCode.getState() == MmiCode.State.COMPLETE ? 100 : -1, ussdCallbackReceiver);
                return;
            }
            Rlog.i(LOG_TAG, "onMMIDone: notifying registrants: " + mmiCode);
            this.mMmiCompleteRegistrants.notifyRegistrants(new AsyncResult((Object) null, mmiCode, (Throwable) null));
            return;
        }
        Rlog.i(LOG_TAG, "onMMIDone: invalid response or already handled; ignoring: " + mmiCode);
    }

    public boolean supports3gppCallForwardingWhileRoaming() {
        PersistableBundle configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId());
        if (configForSubId != null) {
            return configForSubId.getBoolean("support_3gpp_call_forwarding_while_roaming_bool", true);
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public void onNetworkInitiatedUssd(MmiCode mmiCode) {
        Rlog.v(LOG_TAG, "onNetworkInitiatedUssd: mmi=" + mmiCode);
        this.mMmiCompleteRegistrants.notifyRegistrants(new AsyncResult((Object) null, mmiCode, (Throwable) null));
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v4, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r4v4, resolved type: com.android.internal.telephony.gsm.GsmMmiCode} */
    /* access modifiers changed from: protected */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onIncomingUSSD(int r8, java.lang.String r9) {
        /*
            r7 = this;
            boolean r0 = r7.isPhoneTypeGsm()
            if (r0 != 0) goto L_0x000b
            java.lang.String r0 = "onIncomingUSSD: not expected on GSM"
            r7.loge(r0)
        L_0x000b:
            r0 = 0
            r1 = 1
            if (r8 != r1) goto L_0x0011
            r2 = r1
            goto L_0x0012
        L_0x0011:
            r2 = r0
        L_0x0012:
            if (r8 == 0) goto L_0x0018
            if (r8 == r1) goto L_0x0018
            r3 = r1
            goto L_0x0019
        L_0x0018:
            r3 = r0
        L_0x0019:
            r4 = 2
            if (r8 != r4) goto L_0x001e
            r8 = r1
            goto L_0x001f
        L_0x001e:
            r8 = r0
        L_0x001f:
            r4 = 0
            java.util.ArrayList<com.android.internal.telephony.MmiCode> r5 = r7.mPendingMMIs
            int r5 = r5.size()
        L_0x0026:
            if (r0 >= r5) goto L_0x0043
            java.util.ArrayList<com.android.internal.telephony.MmiCode> r6 = r7.mPendingMMIs
            java.lang.Object r6 = r6.get(r0)
            com.android.internal.telephony.gsm.GsmMmiCode r6 = (com.android.internal.telephony.gsm.GsmMmiCode) r6
            boolean r6 = r6.isPendingUSSD()
            if (r6 == 0) goto L_0x0040
            java.util.ArrayList<com.android.internal.telephony.MmiCode> r4 = r7.mPendingMMIs
            java.lang.Object r0 = r4.get(r0)
            r4 = r0
            com.android.internal.telephony.gsm.GsmMmiCode r4 = (com.android.internal.telephony.gsm.GsmMmiCode) r4
            goto L_0x0043
        L_0x0040:
            int r0 = r0 + 1
            goto L_0x0026
        L_0x0043:
            if (r4 == 0) goto L_0x0055
            if (r8 == 0) goto L_0x004b
            r4.onUssdRelease()
            goto L_0x0080
        L_0x004b:
            if (r3 == 0) goto L_0x0051
            r4.onUssdFinishedError()
            goto L_0x0080
        L_0x0051:
            r4.onUssdFinished(r9, r2)
            goto L_0x0080
        L_0x0055:
            if (r3 != 0) goto L_0x006d
            boolean r0 = android.text.TextUtils.isEmpty(r9)
            if (r0 != 0) goto L_0x006d
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.UiccCardApplication> r8 = r7.mUiccApplication
            java.lang.Object r8 = r8.get()
            com.android.internal.telephony.uicc.UiccCardApplication r8 = (com.android.internal.telephony.uicc.UiccCardApplication) r8
            com.android.internal.telephony.gsm.GsmMmiCode r8 = com.android.internal.telephony.gsm.GsmMmiCode.newNetworkInitiatedUssd(r9, r2, r7, r8)
            r7.onNetworkInitiatedUssd(r8)
            goto L_0x0080
        L_0x006d:
            if (r3 == 0) goto L_0x0080
            if (r8 != 0) goto L_0x0080
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.UiccCardApplication> r8 = r7.mUiccApplication
            java.lang.Object r8 = r8.get()
            com.android.internal.telephony.uicc.UiccCardApplication r8 = (com.android.internal.telephony.uicc.UiccCardApplication) r8
            com.android.internal.telephony.gsm.GsmMmiCode r7 = com.android.internal.telephony.gsm.GsmMmiCode.newNetworkInitiatedUssd(r9, r1, r7, r8)
            r7.onUssdFinishedError()
        L_0x0080:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.onIncomingUSSD(int, java.lang.String):void");
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void syncClirSetting() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getContext());
        migrateClirSettingIfNeeded(defaultSharedPreferences);
        int i = defaultSharedPreferences.getInt(Phone.CLIR_KEY + getSubId(), -1);
        Rlog.i(LOG_TAG, "syncClirSetting: clir_sub_key" + getSubId() + "=" + i);
        if (i >= 0) {
            this.mCi.setCLIR(i, (Message) null);
        } else {
            this.mCi.setCLIR(0, (Message) null);
        }
    }

    private void migrateClirSettingIfNeeded(SharedPreferences sharedPreferences) {
        int i = sharedPreferences.getInt("clir_key" + getPhoneId(), -1);
        if (i >= 0) {
            Rlog.i(LOG_TAG, "Migrate CLIR setting: value=" + i + ", clir_key" + getPhoneId() + " -> " + Phone.CLIR_KEY + getSubId());
            SharedPreferences.Editor edit = sharedPreferences.edit();
            StringBuilder sb = new StringBuilder();
            sb.append(Phone.CLIR_KEY);
            sb.append(getSubId());
            edit.putInt(sb.toString(), i);
            edit.remove("clir_key" + getPhoneId()).commit();
        }
    }

    private void handleRadioAvailable() {
        this.mCi.getBasebandVersion(obtainMessage(6));
        this.mCi.getDeviceIdentity(obtainMessage(21));
        this.mCi.getRadioCapability(obtainMessage(35));
        this.mCi.areUiccApplicationsEnabled(obtainMessage(55));
        startLceAfterRadioIsAvailable();
    }

    private void handleRadioOn() {
        this.mCi.getVoiceRadioTechnology(obtainMessage(40));
        if (!isPhoneTypeGsm()) {
            this.mCdmaSubscriptionSource = this.mCdmaSSM.getCdmaSubscriptionSource();
        }
    }

    private void handleRadioOffOrNotAvailable() {
        if (isPhoneTypeGsm()) {
            for (int size = this.mPendingMMIs.size() - 1; size >= 0; size--) {
                if (((GsmMmiCode) this.mPendingMMIs.get(size)).isPendingUSSD()) {
                    ((GsmMmiCode) this.mPendingMMIs.get(size)).onUssdFinishedError();
                }
            }
        }
        this.mRadioOffOrNotAvailableRegistrants.notifyRegistrants();
    }

    private void handleRadioPowerStateChange() {
        int radioState = this.mCi.getRadioState();
        Rlog.d(LOG_TAG, "handleRadioPowerStateChange, state= " + radioState);
        this.mNotifier.notifyRadioPowerStateChanged(this, radioState);
        TelephonyMetrics.getInstance().writeRadioState(this.mPhoneId, radioState);
    }

    public void handleMessage(Message message) {
        Object obj;
        Object obj2;
        Pair pair;
        Object obj3;
        int i = message.what;
        boolean z = false;
        switch (i) {
            case 1:
                handleRadioAvailable();
                return;
            case 2:
                logd("Event EVENT_SSN Received");
                if (isPhoneTypeGsm()) {
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    SuppServiceNotification suppServiceNotification = (SuppServiceNotification) asyncResult.result;
                    this.mSsnRegistrants.notifyRegistrants(asyncResult);
                    return;
                }
                return;
            case 3:
                updateCurrentCarrierInProvider();
                String vmSimImsi = getVmSimImsi();
                String subscriberId = getSubscriberId();
                if ((!isPhoneTypeGsm() || vmSimImsi != null) && subscriberId != null && !subscriberId.equals(vmSimImsi)) {
                    storeVoiceMailNumber((String) null);
                    setVmSimImsi((String) null);
                }
                updateVoiceMail();
                this.mSimRecordsLoadedRegistrants.notifyRegistrants();
                return;
            case 5:
                logd("Event EVENT_RADIO_ON Received");
                handleRadioOn();
                return;
            case 6:
                AsyncResult asyncResult2 = (AsyncResult) message.obj;
                if (asyncResult2.exception == null) {
                    logd("Baseband version: " + asyncResult2.result);
                    String str = (String) asyncResult2.result;
                    if (str != null) {
                        int length = str.length();
                        TelephonyManager from = TelephonyManager.from(this.mContext);
                        int phoneId = getPhoneId();
                        if (length > 45) {
                            str = str.substring(length - 45, length);
                        }
                        from.setBasebandVersionForPhone(phoneId, str);
                        return;
                    }
                    return;
                }
                return;
            case 7:
                String[] strArr = (String[]) ((AsyncResult) message.obj).result;
                if (strArr.length > 1) {
                    try {
                        onIncomingUSSD(Integer.parseInt(strArr[0]), strArr[1]);
                        return;
                    } catch (NumberFormatException unused) {
                        Rlog.w(LOG_TAG, "error parsing USSD");
                        return;
                    }
                } else {
                    return;
                }
            case 8:
                logd("Event EVENT_RADIO_OFF_OR_NOT_AVAILABLE Received");
                handleRadioOffOrNotAvailable();
                return;
            case 12:
                AsyncResult asyncResult3 = (AsyncResult) message.obj;
                Cfu cfu = (Cfu) asyncResult3.userObj;
                if (asyncResult3.exception == null) {
                    if (message.arg1 == 1) {
                        z = true;
                    }
                    setVoiceCallForwardingFlag(1, z, cfu.mSetCfNumber);
                }
                Message message2 = cfu.mOnComplete;
                if (message2 != null) {
                    AsyncResult.forMessage(message2, asyncResult3.result, asyncResult3.exception);
                    cfu.mOnComplete.sendToTarget();
                    return;
                }
                return;
            case 13:
                AsyncResult asyncResult4 = (AsyncResult) message.obj;
                if (asyncResult4.exception == null) {
                    handleCfuQueryResult((CallForwardInfo[]) asyncResult4.result);
                }
                Message message3 = (Message) asyncResult4.userObj;
                if (message3 != null) {
                    AsyncResult.forMessage(message3, asyncResult4.result, asyncResult4.exception);
                    message3.sendToTarget();
                    return;
                }
                return;
            case 18:
                AsyncResult asyncResult5 = (AsyncResult) message.obj;
                if (asyncResult5.exception == null) {
                    saveClirSetting(message.arg1);
                }
                Message message4 = (Message) asyncResult5.userObj;
                if (message4 != null) {
                    AsyncResult.forMessage(message4, asyncResult5.result, asyncResult5.exception);
                    message4.sendToTarget();
                    return;
                }
                return;
            case 19:
                logd("Event EVENT_REGISTERED_TO_NETWORK Received");
                if (isPhoneTypeGsm()) {
                    syncClirSetting();
                    return;
                }
                return;
            case 20:
                AsyncResult asyncResult6 = (AsyncResult) message.obj;
                if (((isPhoneTypeGsm() || this.mSimRecords != null) && IccVmNotSupportedException.class.isInstance(asyncResult6.exception)) || (!isPhoneTypeGsm() && this.mSimRecords == null && IccException.class.isInstance(asyncResult6.exception))) {
                    storeVoiceMailNumber(this.mVmNumber);
                    asyncResult6.exception = null;
                }
                Message message5 = (Message) asyncResult6.userObj;
                if (message5 != null) {
                    AsyncResult.forMessage(message5, asyncResult6.result, asyncResult6.exception);
                    message5.sendToTarget();
                    return;
                }
                return;
            case 21:
                AsyncResult asyncResult7 = (AsyncResult) message.obj;
                if (asyncResult7.exception == null) {
                    String[] strArr2 = (String[]) asyncResult7.result;
                    this.mImei = strArr2[0];
                    this.mImeiSv = strArr2[1];
                    this.mEsn = strArr2[2];
                    String str2 = strArr2[3];
                    this.mMeid = str2;
                    if (!TextUtils.isEmpty(str2) && this.mMeid.matches("^0*$")) {
                        logd("EVENT_GET_DEVICE_IDENTITY_DONE: set mMeid to null");
                        this.mMeid = null;
                        return;
                    }
                    return;
                }
                return;
            case 22:
                logd("Event EVENT_RUIM_RECORDS_LOADED Received");
                updateCurrentCarrierInProvider();
                return;
            case 25:
                handleEnterEmergencyCallbackMode(message);
                return;
            case 26:
                handleExitEmergencyCallbackMode(message);
                return;
            case 27:
                logd("EVENT_CDMA_SUBSCRIPTION_SOURCE_CHANGED");
                this.mCdmaSubscriptionSource = this.mCdmaSSM.getCdmaSubscriptionSource();
                return;
            case 28:
                AsyncResult asyncResult8 = (AsyncResult) message.obj;
                if (this.mSST.mSS.getIsManualSelection()) {
                    setNetworkSelectionModeAutomatic((Message) asyncResult8.result);
                    logd("SET_NETWORK_SELECTION_AUTOMATIC: set to automatic");
                    return;
                }
                logd("SET_NETWORK_SELECTION_AUTOMATIC: already automatic, ignore");
                return;
            case 29:
                processIccRecordEvents(((Integer) ((AsyncResult) message.obj).result).intValue());
                return;
            case 35:
                AsyncResult asyncResult9 = (AsyncResult) message.obj;
                RadioCapability radioCapability = (RadioCapability) asyncResult9.result;
                if (asyncResult9.exception != null) {
                    Rlog.d(LOG_TAG, "get phone radio capability fail, no need to change mRadioCapability");
                } else {
                    radioCapabilityUpdated(radioCapability, false);
                }
                Rlog.d(LOG_TAG, "EVENT_GET_RADIO_CAPABILITY: phone rc: " + radioCapability);
                return;
            case 36:
                AsyncResult asyncResult10 = (AsyncResult) message.obj;
                logd("Event EVENT_SS received");
                if (isPhoneTypeGsm()) {
                    new GsmMmiCode(this, this.mUiccApplication.get()).processSsData(asyncResult10);
                    return;
                }
                return;
            case 39:
            case 40:
                String str3 = i == 39 ? "EVENT_VOICE_RADIO_TECH_CHANGED" : "EVENT_REQUEST_VOICE_RADIO_TECH_DONE";
                AsyncResult asyncResult11 = (AsyncResult) message.obj;
                if (asyncResult11.exception == null) {
                    Object obj4 = asyncResult11.result;
                    if (obj4 == null || ((int[]) obj4).length == 0) {
                        loge(str3 + ": has no tech!");
                        return;
                    }
                    int i2 = ((int[]) obj4)[0];
                    logd(str3 + ": newVoiceTech=" + i2);
                    phoneObjectUpdater(i2);
                    return;
                }
                loge(str3 + ": exception=" + asyncResult11.exception);
                return;
            case 41:
                AsyncResult asyncResult12 = (AsyncResult) message.obj;
                if (asyncResult12.exception != null || (obj = asyncResult12.result) == null) {
                    logd("Unexpected exception on EVENT_RIL_CONNECTED");
                    this.mRilVersion = -1;
                    return;
                }
                this.mRilVersion = ((Integer) obj).intValue();
                return;
            case 42:
                phoneObjectUpdater(message.arg1);
                return;
            case 43:
                if (!this.mContext.getResources().getBoolean(17891798)) {
                    this.mCi.getVoiceRadioTechnology(obtainMessage(40));
                }
                PersistableBundle configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId());
                updateBroadcastEmergencyCallStateChangesAfterCarrierConfigChanged(configForSubId);
                updateCdmaRoamingSettingsAfterCarrierConfigChanged(configForSubId);
                updateNrSettingsAfterCarrierConfigChanged(configForSubId);
                updateVoNrSettings(configForSubId);
                updateSsOverCdmaSupported(configForSubId);
                loadAllowedNetworksFromSubscriptionDatabase();
                this.mCi.getRadioCapability(obtainMessage(35));
                return;
            case 44:
                logd("cdma_roaming_mode change is done");
                return;
            case 45:
                logd("Event EVENT_MODEM_RESET Received isInEcm = " + isInEcm() + " isPhoneTypeGsm = " + isPhoneTypeGsm() + " mImsPhone = " + this.mImsPhone);
                if (!isInEcm()) {
                    return;
                }
                if (isPhoneTypeGsm()) {
                    Phone phone = this.mImsPhone;
                    if (phone != null) {
                        phone.handleExitEmergencyCallbackMode();
                        return;
                    }
                    return;
                }
                handleExitEmergencyCallbackMode(message);
                return;
            case 46:
                Pair pair2 = (Pair) ((AsyncResult) message.obj).result;
                onVoiceRegStateOrRatChanged(((Integer) pair2.first).intValue(), ((Integer) pair2.second).intValue());
                return;
            case 47:
                logd("EVENT EVENT_RADIO_STATE_CHANGED");
                handleRadioPowerStateChange();
                return;
            case 48:
                boolean booleanValue = ((Boolean) ((AsyncResult) message.obj).result).booleanValue();
                if (isUsingNewDataStack()) {
                    getDataSettingsManager().setDataEnabled(2, booleanValue, this.mContext.getOpPackageName());
                    return;
                } else {
                    this.mDataEnabledSettings.setDataEnabled(2, booleanValue);
                    return;
                }
            case 49:
                if (!isUsingNewDataStack()) {
                    this.mDataEnabledSettings.updateProvisionedChanged();
                    return;
                }
                return;
            case 50:
                if (!isUsingNewDataStack()) {
                    this.mDataEnabledSettings.updateProvisioningDataEnabled();
                    return;
                }
                return;
            case 51:
                AsyncResult asyncResult13 = (AsyncResult) message.obj;
                if (!(asyncResult13.exception != null || (obj2 = asyncResult13.result) == null || this.mSST == null)) {
                    ArrayList arrayList = new ArrayList();
                    for (OperatorInfo operatorInfo : (List) obj2) {
                        if (OperatorInfo.State.CURRENT == operatorInfo.getState()) {
                            arrayList.add(new OperatorInfo(this.mSST.filterOperatorNameByPattern(operatorInfo.getOperatorAlphaLong()), this.mSST.filterOperatorNameByPattern(operatorInfo.getOperatorAlphaShort()), operatorInfo.getOperatorNumeric(), operatorInfo.getState()));
                        } else {
                            arrayList.add(operatorInfo);
                        }
                    }
                    asyncResult13.result = arrayList;
                }
                Message message6 = (Message) asyncResult13.userObj;
                if (message6 != null) {
                    AsyncResult.forMessage(message6, asyncResult13.result, asyncResult13.exception);
                    message6.sendToTarget();
                    return;
                }
                return;
            case 53:
            case 55:
                AsyncResult asyncResult14 = (AsyncResult) message.obj;
                if (asyncResult14 != null) {
                    if (asyncResult14.exception == null) {
                        this.mUiccApplicationsEnabled = (Boolean) asyncResult14.result;
                        break;
                    } else {
                        logd("Received exception on event" + message.what + " : " + asyncResult14.exception);
                        return;
                    }
                } else {
                    return;
                }
            case 54:
                break;
            case 56:
                AsyncResult asyncResult15 = (AsyncResult) message.obj;
                if (asyncResult15 != null && asyncResult15.exception != null && (pair = (Pair) asyncResult15.userObj) != null) {
                    boolean booleanValue2 = ((Boolean) pair.first).booleanValue();
                    int intValue = ((Integer) pair.second).intValue();
                    CommandException.Error commandError = ((CommandException) asyncResult15.exception).getCommandError();
                    loge("Error received when re-applying uicc application setting to " + booleanValue2 + " on phone " + this.mPhoneId + " Error code: " + commandError + " retry count left: " + intValue);
                    if (intValue <= 0) {
                        return;
                    }
                    if (commandError == CommandException.Error.GENERIC_FAILURE || commandError == CommandException.Error.SIM_BUSY) {
                        postDelayed(new GsmCdmaPhone$$ExternalSyntheticLambda0(this, intValue), 5000);
                        return;
                    }
                    return;
                }
                return;
            case 57:
                logd("Event RegistrationFailed Received");
                RegistrationFailedEvent registrationFailedEvent = (RegistrationFailedEvent) ((AsyncResult) message.obj).result;
                this.mNotifier.notifyRegistrationFailed(this, registrationFailedEvent.cellIdentity, registrationFailedEvent.chosenPlmn, registrationFailedEvent.domain, registrationFailedEvent.causeCode, registrationFailedEvent.additionalCauseCode);
                return;
            case 58:
                logd("Event BarringInfoChanged Received");
                this.mNotifier.notifyBarringInfoChanged(this, (BarringInfo) ((AsyncResult) message.obj).result);
                return;
            case 59:
                AsyncResult asyncResult16 = (AsyncResult) message.obj;
                if (asyncResult16.exception != null || (obj3 = asyncResult16.result) == null) {
                    logd("Unexpected exception on EVENT_LINK_CAPACITY_CHANGED");
                    return;
                } else {
                    updateLinkCapacityEstimate((List) obj3);
                    return;
                }
            case 60:
                resetCarrierKeysForImsiEncryption();
                return;
            case 61:
                logd("EVENT_SET_VONR_ENABLED_DONE is done");
                return;
            case 62:
                logd("EVENT_SUBSCRIPTIONS_CHANGED");
                updateUsageSetting();
                return;
            default:
                super.handleMessage(message);
                return;
        }
        reapplyUiccAppsEnablementIfNeeded(ENABLE_UICC_APPS_MAX_RETRIES);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$handleMessage$0(int i) {
        reapplyUiccAppsEnablementIfNeeded(i - 1);
    }

    public UiccCardApplication getUiccCardApplication() {
        if (isPhoneTypeGsm()) {
            return this.mUiccController.getUiccCardApplication(this.mPhoneId, 1);
        }
        return this.mUiccController.getUiccCardApplication(this.mPhoneId, 2);
    }

    /* access modifiers changed from: protected */
    public void onUpdateIccAvailability() {
        IsimUiccRecords isimUiccRecords;
        if (this.mUiccController != null) {
            if (isPhoneTypeGsm() || isPhoneTypeCdmaLte()) {
                UiccCardApplication uiccCardApplication = this.mUiccController.getUiccCardApplication(this.mPhoneId, 3);
                if (uiccCardApplication != null) {
                    isimUiccRecords = (IsimUiccRecords) uiccCardApplication.getIccRecords();
                    logd("New ISIM application found");
                } else {
                    isimUiccRecords = null;
                }
                this.mIsimUiccRecords = isimUiccRecords;
            }
            SIMRecords sIMRecords = this.mSimRecords;
            if (sIMRecords != null) {
                sIMRecords.unregisterForRecordsLoaded(this);
            }
            if (isPhoneTypeCdmaLte() || isPhoneTypeCdma()) {
                UiccCardApplication uiccCardApplication2 = this.mUiccController.getUiccCardApplication(this.mPhoneId, 1);
                SIMRecords sIMRecords2 = uiccCardApplication2 != null ? (SIMRecords) uiccCardApplication2.getIccRecords() : null;
                this.mSimRecords = sIMRecords2;
                if (sIMRecords2 != null) {
                    sIMRecords2.registerForRecordsLoaded(this, 3, (Object) null);
                }
            } else {
                this.mSimRecords = null;
            }
            UiccCardApplication uiccCardApplication3 = getUiccCardApplication();
            if (!isPhoneTypeGsm() && uiccCardApplication3 == null) {
                logd("can't find 3GPP2 application; trying APP_FAM_3GPP");
                uiccCardApplication3 = this.mUiccController.getUiccCardApplication(this.mPhoneId, 1);
            }
            UiccCardApplication uiccCardApplication4 = this.mUiccApplication.get();
            if (uiccCardApplication4 != uiccCardApplication3) {
                if (uiccCardApplication4 != null) {
                    logd("Removing stale icc objects.");
                    if (this.mIccRecords.get() != null) {
                        unregisterForIccRecordEvents();
                        this.mIccPhoneBookIntManager.updateIccRecords((IccRecords) null);
                    }
                    this.mIccRecords.set((Object) null);
                    this.mUiccApplication.set((Object) null);
                }
                if (uiccCardApplication3 != null) {
                    logd("New Uicc application found. type = " + uiccCardApplication3.getType());
                    IccRecords iccRecords = uiccCardApplication3.getIccRecords();
                    this.mUiccApplication.set(uiccCardApplication3);
                    this.mIccRecords.set(iccRecords);
                    registerForIccRecordEvents();
                    this.mIccPhoneBookIntManager.updateIccRecords(iccRecords);
                    if (iccRecords != null) {
                        String operatorNumeric = iccRecords.getOperatorNumeric();
                        logd("New simOperatorNumeric = " + operatorNumeric);
                        if (!TextUtils.isEmpty(operatorNumeric)) {
                            TelephonyManager.from(this.mContext).setSimOperatorNumericForPhone(this.mPhoneId, operatorNumeric);
                        }
                    }
                    updateCurrentCarrierInProvider();
                }
            }
            reapplyUiccAppsEnablementIfNeeded(ENABLE_UICC_APPS_MAX_RETRIES);
        }
    }

    /* access modifiers changed from: protected */
    public void processIccRecordEvents(int i) {
        if (i == 1) {
            logi("processIccRecordEvents: EVENT_CFI");
            notifyCallForwardingIndicator();
        }
    }

    public boolean updateCurrentCarrierInProvider() {
        long defaultDataSubscriptionId = (long) SubscriptionManager.getDefaultDataSubscriptionId();
        String operatorNumeric = getOperatorNumeric();
        logd("updateCurrentCarrierInProvider: mSubId = " + getSubId() + " currentDds = " + defaultDataSubscriptionId + " operatorNumeric = " + operatorNumeric);
        if (TextUtils.isEmpty(operatorNumeric) || ((long) getSubId()) != defaultDataSubscriptionId) {
            return false;
        }
        try {
            Uri withAppendedPath = Uri.withAppendedPath(Telephony.Carriers.CONTENT_URI, "current");
            ContentValues contentValues = new ContentValues();
            contentValues.put("numeric", operatorNumeric);
            this.mContext.getContentResolver().insert(withAppendedPath, contentValues);
            return true;
        } catch (SQLException e) {
            Rlog.e(LOG_TAG, "Can't store current operator", e);
            return false;
        }
    }

    private boolean updateCurrentCarrierInProvider(String str) {
        if (isPhoneTypeCdma() || (isPhoneTypeCdmaLte() && this.mUiccController.getUiccCardApplication(this.mPhoneId, 1) == null)) {
            logd("CDMAPhone: updateCurrentCarrierInProvider called");
            if (TextUtils.isEmpty(str)) {
                return false;
            }
            try {
                Uri withAppendedPath = Uri.withAppendedPath(Telephony.Carriers.CONTENT_URI, "current");
                ContentValues contentValues = new ContentValues();
                contentValues.put("numeric", str);
                logd("updateCurrentCarrierInProvider from system: numeric=" + str);
                getContext().getContentResolver().insert(withAppendedPath, contentValues);
                logd("update mccmnc=" + str);
                MccTable.updateMccMncConfiguration(this.mContext, str);
                return true;
            } catch (SQLException e) {
                Rlog.e(LOG_TAG, "Can't store current operator", e);
                return false;
            }
        } else {
            logd("updateCurrentCarrierInProvider not updated X retVal=true");
            return true;
        }
    }

    /* access modifiers changed from: protected */
    public void handleCfuQueryResult(CallForwardInfo[] callForwardInfoArr) {
        boolean z = false;
        if (callForwardInfoArr == null || callForwardInfoArr.length == 0) {
            setVoiceCallForwardingFlag(1, false, (String) null);
            return;
        }
        for (CallForwardInfo callForwardInfo : callForwardInfoArr) {
            if ((callForwardInfo.serviceClass & 1) != 0) {
                if (callForwardInfo.status == 1) {
                    z = true;
                }
                setVoiceCallForwardingFlag(1, z, callForwardInfo.number);
                return;
            }
        }
    }

    public IccPhoneBookInterfaceManager getIccPhoneBookInterfaceManager() {
        return this.mIccPhoneBookIntManager;
    }

    public void activateCellBroadcastSms(int i, Message message) {
        loge("[GsmCdmaPhone] activateCellBroadcastSms() is obsolete; use SmsManager");
        message.sendToTarget();
    }

    public void getCellBroadcastSmsConfig(Message message) {
        loge("[GsmCdmaPhone] getCellBroadcastSmsConfig() is obsolete; use SmsManager");
        message.sendToTarget();
    }

    public void setCellBroadcastSmsConfig(int[] iArr, Message message) {
        loge("[GsmCdmaPhone] setCellBroadcastSmsConfig() is obsolete; use SmsManager");
        message.sendToTarget();
    }

    public boolean needsOtaServiceProvisioning() {
        if (!isPhoneTypeGsm() && this.mSST.getOtasp() != 3) {
            return true;
        }
        return false;
    }

    public boolean isCspPlmnEnabled() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords != null) {
            return iccRecords.isCspPlmnEnabled();
        }
        return false;
    }

    public boolean shouldForceAutoNetworkSelect() {
        RadioAccessFamily.getRafFromNetworkType(RILConstants.PREFERRED_NETWORK_MODE);
        if (!SubscriptionManager.isValidSubscriptionId(getSubId())) {
            return false;
        }
        int allowedNetworkTypes = (int) getAllowedNetworkTypes(0);
        logd("shouldForceAutoNetworkSelect in mode = " + allowedNetworkTypes);
        if (!isManualSelProhibitedInGlobalMode() || !(allowedNetworkTypes == RadioAccessFamily.getRafFromNetworkType(10) || allowedNetworkTypes == RadioAccessFamily.getRafFromNetworkType(7))) {
            logd("Should not force auto network select mode = " + allowedNetworkTypes);
            return false;
        }
        logd("Should force auto network select mode = " + allowedNetworkTypes);
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private boolean isManualSelProhibitedInGlobalMode() {
        String[] split;
        String string = getContext().getResources().getString(17041384);
        boolean z = false;
        if (!TextUtils.isEmpty(string) && (split = string.split(";")) != null && ((split.length == 1 && split[0].equalsIgnoreCase("true")) || (split.length == 2 && !TextUtils.isEmpty(split[1]) && split[0].equalsIgnoreCase("true") && isMatchGid(split[1])))) {
            z = true;
        }
        logd("isManualNetSelAllowedInGlobal in current carrier is " + z);
        return z;
    }

    /* access modifiers changed from: protected */
    public void registerForIccRecordEvents() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords != null) {
            if (isPhoneTypeGsm()) {
                iccRecords.registerForNetworkSelectionModeAutomatic(this, 28, (Object) null);
                iccRecords.registerForRecordsEvents(this, 29, (Object) null);
                iccRecords.registerForRecordsLoaded(this, 3, (Object) null);
                return;
            }
            iccRecords.registerForRecordsLoaded(this, 22, (Object) null);
            if (isPhoneTypeCdmaLte()) {
                iccRecords.registerForRecordsLoaded(this, 3, (Object) null);
            }
        }
    }

    /* access modifiers changed from: protected */
    public void unregisterForIccRecordEvents() {
        IccRecords iccRecords = this.mIccRecords.get();
        if (iccRecords != null) {
            iccRecords.unregisterForNetworkSelectionModeAutomatic(this);
            iccRecords.unregisterForRecordsEvents(this);
            iccRecords.unregisterForRecordsLoaded(this);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void exitEmergencyCallbackMode() {
        Rlog.d(LOG_TAG, "exitEmergencyCallbackMode: mImsPhone=" + this.mImsPhone + " isPhoneTypeGsm=" + isPhoneTypeGsm());
        Phone phone = this.mImsPhone;
        if (phone == null || !phone.isInImsEcm()) {
            if (this.mWakeLock.isHeld()) {
                this.mWakeLock.release();
            }
            Message message = null;
            if (this.mIsTestingEmergencyCallbackMode) {
                message = obtainMessage(26);
            }
            this.mCi.exitEmergencyCallbackMode(message);
            return;
        }
        this.mImsPhone.exitEmergencyCallbackMode();
    }

    private void handleEnterEmergencyCallbackMode(Message message) {
        Rlog.d(LOG_TAG, "handleEnterEmergencyCallbackMode, isInEcm()=" + isInEcm());
        if (!isInEcm()) {
            setIsInEcm(true);
            sendEmergencyCallbackModeChange();
            postDelayed(this.mExitEcmRunnable, TelephonyProperties.ecm_exit_timer().orElse(Long.valueOf(DEFAULT_ECM_EXIT_TIMER_VALUE)).longValue());
            this.mWakeLock.acquire();
        }
    }

    private void handleExitEmergencyCallbackMode(Message message) {
        AsyncResult asyncResult = (AsyncResult) message.obj;
        Rlog.d(LOG_TAG, "handleExitEmergencyCallbackMode,ar.exception , isInEcm=" + asyncResult.exception + isInEcm());
        removeCallbacks(this.mExitEcmRunnable);
        Registrant registrant = this.mEcmExitRespRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(asyncResult);
        }
        if (asyncResult.exception == null || this.mIsTestingEmergencyCallbackMode) {
            if (isInEcm()) {
                setIsInEcm(false);
            }
            if (this.mWakeLock.isHeld()) {
                this.mWakeLock.release();
            }
            sendEmergencyCallbackModeChange();
            if (!isUsingNewDataStack()) {
                this.mDataEnabledSettings.setInternalDataEnabled(true);
            }
            notifyEmergencyCallRegistrants(false);
        }
        this.mIsTestingEmergencyCallbackMode = false;
    }

    public void notifyEmergencyCallRegistrants(boolean z) {
        this.mEmergencyCallToggledRegistrants.notifyResult(Integer.valueOf(z ? 1 : 0));
    }

    public void handleTimerInEmergencyCallbackMode(int i) {
        if (i == 0) {
            postDelayed(this.mExitEcmRunnable, TelephonyProperties.ecm_exit_timer().orElse(Long.valueOf(DEFAULT_ECM_EXIT_TIMER_VALUE)).longValue());
            this.mEcmTimerResetRegistrants.notifyResult(Boolean.FALSE);
            setEcmCanceledForEmergency(false);
        } else if (i != 1) {
            Rlog.e(LOG_TAG, "handleTimerInEmergencyCallbackMode, unsupported action " + i);
        } else {
            removeCallbacks(this.mExitEcmRunnable);
            this.mEcmTimerResetRegistrants.notifyResult(Boolean.TRUE);
            setEcmCanceledForEmergency(true);
        }
    }

    private static boolean isIs683OtaSpDialStr(String str) {
        if (str.length() != 4) {
            switch (extractSelCodeFromOtaSpNum(str)) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                    return true;
            }
        } else if (str.equals(IS683A_FEATURE_CODE)) {
            return true;
        }
        return false;
    }

    private static int extractSelCodeFromOtaSpNum(String str) {
        int parseInt = (!str.regionMatches(0, IS683A_FEATURE_CODE, 0, 4) || str.length() < 6) ? -1 : Integer.parseInt(str.substring(4, 6));
        Rlog.d(LOG_TAG, "extractSelCodeFromOtaSpNum " + parseInt);
        return parseInt;
    }

    private static boolean checkOtaSpNumBasedOnSysSelCode(int i, String[] strArr) {
        try {
            int parseInt = Integer.parseInt(strArr[1]);
            for (int i2 = 0; i2 < parseInt; i2++) {
                int i3 = i2 * 2;
                int i4 = i3 + 2;
                if (!TextUtils.isEmpty(strArr[i4])) {
                    int i5 = i3 + 3;
                    if (!TextUtils.isEmpty(strArr[i5])) {
                        int parseInt2 = Integer.parseInt(strArr[i4]);
                        int parseInt3 = Integer.parseInt(strArr[i5]);
                        if (i >= parseInt2 && i <= parseInt3) {
                            return true;
                        }
                    } else {
                        continue;
                    }
                }
            }
            return false;
        } catch (NumberFormatException e) {
            Rlog.e(LOG_TAG, "checkOtaSpNumBasedOnSysSelCode, error", e);
            return false;
        }
    }

    private boolean isCarrierOtaSpNum(String str) {
        int extractSelCodeFromOtaSpNum = extractSelCodeFromOtaSpNum(str);
        if (extractSelCodeFromOtaSpNum == -1) {
            return false;
        }
        if (!TextUtils.isEmpty(this.mCarrierOtaSpNumSchema)) {
            Matcher matcher = pOtaSpNumSchema.matcher(this.mCarrierOtaSpNumSchema);
            Rlog.d(LOG_TAG, "isCarrierOtaSpNum,schema" + this.mCarrierOtaSpNumSchema);
            if (matcher.find()) {
                String[] split = pOtaSpNumSchema.split(this.mCarrierOtaSpNumSchema);
                if (TextUtils.isEmpty(split[0]) || !split[0].equals("SELC")) {
                    if (TextUtils.isEmpty(split[0]) || !split[0].equals("FC")) {
                        Rlog.d(LOG_TAG, "isCarrierOtaSpNum,ota schema not supported" + split[0]);
                        return false;
                    }
                    if (str.regionMatches(0, split[2], 0, Integer.parseInt(split[1]))) {
                        return true;
                    }
                    Rlog.d(LOG_TAG, "isCarrierOtaSpNum,not otasp number");
                    return false;
                } else if (extractSelCodeFromOtaSpNum != -1) {
                    return checkOtaSpNumBasedOnSysSelCode(extractSelCodeFromOtaSpNum, split);
                } else {
                    Rlog.d(LOG_TAG, "isCarrierOtaSpNum,sysSelCodeInt is invalid");
                    return false;
                }
            } else {
                Rlog.d(LOG_TAG, "isCarrierOtaSpNum,ota schema pattern not right" + this.mCarrierOtaSpNumSchema);
                return false;
            }
        } else {
            Rlog.d(LOG_TAG, "isCarrierOtaSpNum,ota schema pattern empty");
            return false;
        }
    }

    public boolean isOtaSpNumber(String str) {
        if (isPhoneTypeGsm()) {
            return super.isOtaSpNumber(str);
        }
        boolean z = false;
        String extractNetworkPortionAlt = PhoneNumberUtils.extractNetworkPortionAlt(str);
        if (extractNetworkPortionAlt != null && !(z = isIs683OtaSpDialStr(extractNetworkPortionAlt))) {
            z = isCarrierOtaSpNum(extractNetworkPortionAlt);
        }
        Rlog.d(LOG_TAG, "isOtaSpNumber " + z);
        return z;
    }

    public int getOtasp() {
        return this.mSST.getOtasp();
    }

    public int getCdmaEriIconIndex() {
        if (isPhoneTypeGsm()) {
            return super.getCdmaEriIconIndex();
        }
        return getServiceState().getCdmaEriIconIndex();
    }

    public int getCdmaEriIconMode() {
        if (isPhoneTypeGsm()) {
            return super.getCdmaEriIconMode();
        }
        return getServiceState().getCdmaEriIconMode();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getCdmaEriText() {
        if (isPhoneTypeGsm()) {
            return super.getCdmaEriText();
        }
        return this.mSST.getCdmaEriText(getServiceState().getCdmaRoamingIndicator(), getServiceState().getCdmaDefaultRoamingIndicator());
    }

    public boolean isCdmaSubscriptionAppPresent() {
        UiccCardApplication uiccCardApplication = this.mUiccController.getUiccCardApplication(this.mPhoneId, 2);
        return uiccCardApplication != null && (uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_CSIM || uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_RUIM);
    }

    /* access modifiers changed from: protected */
    public void phoneObjectUpdater(int i) {
        logd("phoneObjectUpdater: newVoiceRadioTech=" + i);
        if (ServiceState.isPsOnlyTech(i) || i == 0) {
            PersistableBundle configForSubId = ((CarrierConfigManager) getContext().getSystemService("carrier_config")).getConfigForSubId(getSubId());
            if (configForSubId != null) {
                int i2 = configForSubId.getInt("volte_replacement_rat_int");
                logd("phoneObjectUpdater: volteReplacementRat=" + i2);
                if (i2 != 0 && (ServiceState.isGsm(i2) || isCdmaSubscriptionAppPresent())) {
                    i = i2;
                }
            } else {
                loge("phoneObjectUpdater: didn't get volteReplacementRat from carrier config");
            }
        }
        boolean z = true;
        if (this.mRilVersion == 6 && getLteOnCdmaMode() == 1) {
            if (getPhoneType() == 2) {
                logd("phoneObjectUpdater: LTE ON CDMA property is set. Use CDMA Phone newVoiceRadioTech=" + i + " mActivePhone=" + getPhoneName());
                return;
            }
            logd("phoneObjectUpdater: LTE ON CDMA property is set. Switch to CDMALTEPhone newVoiceRadioTech=" + i + " mActivePhone=" + getPhoneName());
            i = 6;
        } else if (isShuttingDown()) {
            logd("Device is shutting down. No need to switch phone now.");
            return;
        } else {
            boolean isCdma = ServiceState.isCdma(i);
            boolean isGsm = ServiceState.isGsm(i);
            if (((isCdma && getPhoneType() == 2) || (isGsm && getPhoneType() == 1)) && !correctPhoneTypeForCdma(isCdma, i)) {
                logd("phoneObjectUpdater: No change ignore, newVoiceRadioTech=" + i + " mActivePhone=" + getPhoneName());
                return;
            } else if (!isCdma && !isGsm) {
                loge("phoneObjectUpdater: newVoiceRadioTech=" + i + " doesn't match either CDMA or GSM - error! No phone change");
                return;
            }
        }
        if (i == 0) {
            logd("phoneObjectUpdater: Unknown rat ignore,  newVoiceRadioTech=Unknown. mActivePhone=" + getPhoneName());
            return;
        }
        if (!this.mResetModemOnRadioTechnologyChange || this.mCi.getRadioState() != 1) {
            z = false;
        } else {
            logd("phoneObjectUpdater: Setting Radio Power to Off");
            this.mCi.setRadioPower(false, (Message) null);
        }
        switchVoiceRadioTech(i);
        if (this.mResetModemOnRadioTechnologyChange && z) {
            logd("phoneObjectUpdater: Resetting Radio");
            this.mCi.setRadioPower(z, (Message) null);
        }
        UiccProfile uiccProfile = getUiccProfile();
        if (uiccProfile != null) {
            uiccProfile.setVoiceRadioTech(i);
        }
        Intent intent = new Intent("android.intent.action.RADIO_TECHNOLOGY");
        intent.putExtra("phoneName", getPhoneName());
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, this.mPhoneId);
        this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
    }

    /* access modifiers changed from: protected */
    public void switchVoiceRadioTech(int i) {
        String phoneName = getPhoneName();
        StringBuilder sb = new StringBuilder();
        sb.append("Switching Voice Phone : ");
        sb.append(phoneName);
        sb.append(" >>> ");
        sb.append(ServiceState.isGsm(i) ? "GSM" : "CDMA");
        logd(sb.toString());
        if (ServiceState.isCdma(i)) {
            UiccCardApplication uiccCardApplication = this.mUiccController.getUiccCardApplication(this.mPhoneId, 2);
            if (uiccCardApplication == null || uiccCardApplication.getType() != IccCardApplicationStatus.AppType.APPTYPE_RUIM) {
                switchPhoneType(6);
            } else {
                switchPhoneType(2);
            }
        } else if (ServiceState.isGsm(i)) {
            switchPhoneType(1);
        } else {
            loge("deleteAndCreatePhone: newVoiceRadioTech=" + i + " is not CDMA or GSM (error) - aborting!");
        }
    }

    public void setLinkCapacityReportingCriteria(int[] iArr, int[] iArr2, int i) {
        this.mCi.setLinkCapacityReportingCriteria(3000, 50, 50, iArr, iArr2, i, (Message) null);
    }

    public IccSmsInterfaceManager getIccSmsInterfaceManager() {
        return this.mIccSmsInterfaceManager;
    }

    public void updatePhoneObject(int i) {
        logd("updatePhoneObject: radioTechnology=" + i);
        sendMessage(obtainMessage(42, i, 0, (Object) null));
    }

    public void setImsRegistrationState(boolean z) {
        this.mSST.setImsRegistrationState(z);
    }

    public boolean getIccRecordsLoaded() {
        UiccProfile uiccProfile = getUiccProfile();
        return uiccProfile != null && uiccProfile.getIccRecordsLoaded();
    }

    public IccCard getIccCard() {
        UiccProfile uiccProfile = getUiccProfile();
        if (uiccProfile != null) {
            return uiccProfile;
        }
        UiccSlot uiccSlotForPhone = this.mUiccController.getUiccSlotForPhone(this.mPhoneId);
        if (uiccSlotForPhone == null || uiccSlotForPhone.isStateUnknown()) {
            return new IccCard(IccCardConstants.State.UNKNOWN);
        }
        return new IccCard(IccCardConstants.State.ABSENT);
    }

    /* access modifiers changed from: protected */
    public UiccProfile getUiccProfile() {
        return UiccController.getInstance().getUiccProfileForPhone(this.mPhoneId);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("GsmCdmaPhone extends:");
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.println(" mPrecisePhoneType=" + this.mPrecisePhoneType);
        printWriter.println(" mCT=" + this.mCT);
        printWriter.println(" mSST=" + this.mSST);
        printWriter.println(" mPendingMMIs=" + this.mPendingMMIs);
        printWriter.println(" mIccPhoneBookIntManager=" + this.mIccPhoneBookIntManager);
        printWriter.println(" mImei=" + pii(this.mImei));
        printWriter.println(" mImeiSv=" + pii(this.mImeiSv));
        printWriter.println(" mVmNumber=" + pii(this.mVmNumber));
        printWriter.println(" mCdmaSSM=" + this.mCdmaSSM);
        printWriter.println(" mCdmaSubscriptionSource=" + this.mCdmaSubscriptionSource);
        printWriter.println(" mWakeLock=" + this.mWakeLock);
        printWriter.println(" isInEcm()=" + isInEcm());
        printWriter.println(" mEsn=" + pii(this.mEsn));
        printWriter.println(" mMeid=" + pii(this.mMeid));
        printWriter.println(" mCarrierOtaSpNumSchema=" + this.mCarrierOtaSpNumSchema);
        if (!isPhoneTypeGsm()) {
            printWriter.println(" getCdmaEriIconIndex()=" + getCdmaEriIconIndex());
            printWriter.println(" getCdmaEriIconMode()=" + getCdmaEriIconMode());
            printWriter.println(" getCdmaEriText()=" + getCdmaEriText());
            printWriter.println(" isMinInfoReady()=" + isMinInfoReady());
        }
        printWriter.println(" isCspPlmnEnabled()=" + isCspPlmnEnabled());
        printWriter.println(" mManualNetworkSelectionPlmn=" + this.mManualNetworkSelectionPlmn);
        printWriter.println(" mTelecomVoiceServiceStateOverride=" + this.mTelecomVoiceServiceStateOverride + "(" + ServiceState.rilServiceStateToString(this.mTelecomVoiceServiceStateOverride) + ")");
        printWriter.flush();
    }

    public boolean setOperatorBrandOverride(String str) {
        UiccPort uiccPort;
        UiccController uiccController = this.mUiccController;
        if (uiccController == null || (uiccPort = uiccController.getUiccPort(getPhoneId())) == null) {
            return false;
        }
        boolean operatorBrandOverride = uiccPort.setOperatorBrandOverride(str);
        if (operatorBrandOverride) {
            TelephonyManager.from(this.mContext).setSimOperatorNameForPhone(getPhoneId(), this.mSST.getServiceProviderName());
            this.mSST.pollState();
        }
        return operatorBrandOverride;
    }

    /* access modifiers changed from: protected */
    public String checkForTestEmergencyNumber(String str) {
        String str2 = SystemProperties.get("ril.test.emergencynumber");
        if (TextUtils.isEmpty(str2)) {
            return str;
        }
        String[] split = str2.split(":");
        logd("checkForTestEmergencyNumber: values.length=" + split.length);
        if (split.length != 2 || !split[0].equals(PhoneNumberUtils.stripSeparators(str))) {
            return str;
        }
        logd("checkForTestEmergencyNumber: remap " + str + " to " + split[1]);
        return split[1];
    }

    /* JADX WARNING: type inference failed for: r1v7, types: [java.lang.Boolean] */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.String getOperatorNumeric() {
        /*
            r5 = this;
            boolean r0 = r5.isPhoneTypeGsm()
            r1 = 0
            if (r0 == 0) goto L_0x0017
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r5 = r5.mIccRecords
            java.lang.Object r5 = r5.get()
            com.android.internal.telephony.uicc.IccRecords r5 = (com.android.internal.telephony.uicc.IccRecords) r5
            if (r5 == 0) goto L_0x00b7
            java.lang.String r1 = r5.getOperatorNumeric()
            goto L_0x00b7
        L_0x0017:
            int r0 = r5.mCdmaSubscriptionSource
            r2 = 1
            if (r0 != r2) goto L_0x0025
            java.lang.String r0 = "ro.cdma.home.operator.numeric"
            java.lang.String r0 = android.os.SystemProperties.get(r0)
            r2 = r0
            r0 = r1
            goto L_0x006e
        L_0x0025:
            if (r0 != 0) goto L_0x006c
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.UiccCardApplication> r0 = r5.mUiccApplication
            java.lang.Object r0 = r0.get()
            com.android.internal.telephony.uicc.UiccCardApplication r0 = (com.android.internal.telephony.uicc.UiccCardApplication) r0
            if (r0 == 0) goto L_0x0047
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r0 = r0.getType()
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r2 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppType.APPTYPE_RUIM
            if (r0 != r2) goto L_0x0047
            java.lang.String r0 = "Legacy RUIM app present"
            r5.logd(r0)
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r0 = r5.mIccRecords
            java.lang.Object r0 = r0.get()
            com.android.internal.telephony.uicc.IccRecords r0 = (com.android.internal.telephony.uicc.IccRecords) r0
            goto L_0x0049
        L_0x0047:
            com.android.internal.telephony.uicc.SIMRecords r0 = r5.mSimRecords
        L_0x0049:
            if (r0 == 0) goto L_0x0054
            com.android.internal.telephony.uicc.SIMRecords r2 = r5.mSimRecords
            if (r0 != r2) goto L_0x0054
            java.lang.String r2 = r0.getOperatorNumeric()
            goto L_0x006e
        L_0x0054:
            java.util.concurrent.atomic.AtomicReference<com.android.internal.telephony.uicc.IccRecords> r0 = r5.mIccRecords
            java.lang.Object r0 = r0.get()
            com.android.internal.telephony.uicc.IccRecords r0 = (com.android.internal.telephony.uicc.IccRecords) r0
            if (r0 == 0) goto L_0x006a
            boolean r2 = r0 instanceof com.android.internal.telephony.uicc.RuimRecords
            if (r2 == 0) goto L_0x006a
            r2 = r0
            com.android.internal.telephony.uicc.RuimRecords r2 = (com.android.internal.telephony.uicc.RuimRecords) r2
            java.lang.String r2 = r2.getRUIMOperatorNumeric()
            goto L_0x006e
        L_0x006a:
            r2 = r1
            goto L_0x006e
        L_0x006c:
            r0 = r1
            r2 = r0
        L_0x006e:
            if (r2 != 0) goto L_0x0098
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r4 = "getOperatorNumeric: Cannot retrieve operatorNumeric: mCdmaSubscriptionSource = "
            r3.append(r4)
            int r4 = r5.mCdmaSubscriptionSource
            r3.append(r4)
            java.lang.String r4 = " mIccRecords = "
            r3.append(r4)
            if (r0 == 0) goto L_0x008e
            boolean r0 = r0.getRecordsLoaded()
            java.lang.Boolean r1 = java.lang.Boolean.valueOf(r0)
        L_0x008e:
            r3.append(r1)
            java.lang.String r0 = r3.toString()
            r5.loge(r0)
        L_0x0098:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "getOperatorNumeric: mCdmaSubscriptionSource = "
            r0.append(r1)
            int r1 = r5.mCdmaSubscriptionSource
            r0.append(r1)
            java.lang.String r1 = " operatorNumeric = "
            r0.append(r1)
            r0.append(r2)
            java.lang.String r0 = r0.toString()
            r5.logd(r0)
            r1 = r2
        L_0x00b7:
            java.lang.String r5 = android.text.TextUtils.emptyIfNull(r1)
            return r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.GsmCdmaPhone.getOperatorNumeric():java.lang.String");
    }

    public String getCountryIso() {
        SubscriptionInfo activeSubscriptionInfo = SubscriptionManager.from(getContext()).getActiveSubscriptionInfo(getSubId());
        if (activeSubscriptionInfo == null || TextUtils.isEmpty(activeSubscriptionInfo.getCountryIso())) {
            return null;
        }
        return activeSubscriptionInfo.getCountryIso().toUpperCase();
    }

    public void notifyEcbmTimerReset(Boolean bool) {
        this.mEcmTimerResetRegistrants.notifyResult(bool);
    }

    public int getCsCallRadioTech() {
        ServiceStateTracker serviceStateTracker = this.mSST;
        if (serviceStateTracker != null) {
            return getCsCallRadioTech(serviceStateTracker.mSS.getState(), this.mSST.mSS.getRilVoiceRadioTechnology());
        }
        return 0;
    }

    private int getCsCallRadioTech(int i, int i2) {
        logd("getCsCallRadioTech, current vrs=" + i + ", vrat=" + i2);
        if (i != 0 || ArrayUtils.contains(VOICE_PS_CALL_RADIO_TECHNOLOGY, i2)) {
            i2 = 0;
        }
        logd("getCsCallRadioTech, result calcVrat=" + i2);
        return i2;
    }

    private void onVoiceRegStateOrRatChanged(int i, int i2) {
        logd("onVoiceRegStateOrRatChanged");
        this.mCT.dispatchCsCallRadioTech(getCsCallRadioTech(i, i2));
    }

    public void registerForEcmTimerReset(Handler handler, int i, Object obj) {
        this.mEcmTimerResetRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForEcmTimerReset(Handler handler) {
        this.mEcmTimerResetRegistrants.remove(handler);
    }

    public void registerForVolteSilentRedial(Handler handler, int i, Object obj) {
        this.mVolteSilentRedialRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForVolteSilentRedial(Handler handler) {
        this.mVolteSilentRedialRegistrants.remove(handler);
    }

    public void notifyVolteSilentRedial(String str, int i) {
        logd("notifyVolteSilentRedial: dialString=" + str + " causeCode=" + i);
        this.mVolteSilentRedialRegistrants.notifyRegistrants(new AsyncResult((Object) null, new Phone.SilentRedialParam(str, i, this.mDialArgs), (Throwable) null));
    }

    public void setVoiceMessageWaiting(int i, int i2) {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (iccRecords != null) {
                iccRecords.setVoiceMessageWaiting(i, i2);
            } else {
                logd("SIM Records not found, MWI not updated");
            }
        } else {
            setVoiceMessageCount(i2);
        }
    }

    /* access modifiers changed from: protected */
    public CallForwardInfo[] makeEmptyCallForward() {
        CallForwardInfo callForwardInfo = new CallForwardInfo();
        CallForwardInfo[] callForwardInfoArr = {callForwardInfo};
        callForwardInfo.status = 255;
        callForwardInfo.reason = 0;
        callForwardInfo.serviceClass = 1;
        callForwardInfo.toa = 129;
        callForwardInfo.number = "";
        callForwardInfo.timeSeconds = 0;
        return callForwardInfoArr;
    }

    /* access modifiers changed from: protected */
    public PhoneAccountHandle subscriptionIdToPhoneAccountHandle(int i) {
        TelecomManager from = TelecomManager.from(this.mContext);
        TelephonyManager from2 = TelephonyManager.from(this.mContext);
        ListIterator listIterator = from.getCallCapablePhoneAccounts(true).listIterator();
        while (listIterator.hasNext()) {
            PhoneAccountHandle phoneAccountHandle = (PhoneAccountHandle) listIterator.next();
            if (i == from2.getSubIdForPhoneAccount(from.getPhoneAccount(phoneAccountHandle))) {
                return phoneAccountHandle;
            }
        }
        return null;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void logd(String str) {
        Rlog.d(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    /* access modifiers changed from: protected */
    public void logi(String str) {
        Rlog.i(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loge(String str) {
        Rlog.e(LOG_TAG, "[" + this.mPhoneId + "] " + str);
    }

    protected static String pii(String str) {
        return Rlog.pii(LOG_TAG, str);
    }

    public boolean isUtEnabled() {
        Phone phone = this.mImsPhone;
        if (phone != null) {
            return phone.isUtEnabled();
        }
        logd("isUtEnabled: called for GsmCdma");
        return false;
    }

    public String getDtmfToneDelayKey() {
        return isPhoneTypeGsm() ? "gsm_dtmf_tone_delay_int" : "cdma_dtmf_tone_delay_int";
    }

    @VisibleForTesting
    public PowerManager.WakeLock getWakeLock() {
        return this.mWakeLock;
    }

    public int getLteOnCdmaMode() {
        int intValue = TelephonyProperties.lte_on_cdma_device().orElse(0).intValue();
        UiccCardApplication uiccCardApplication = this.mUiccController.getUiccCardApplication(this.mPhoneId, 2);
        if (uiccCardApplication != null && uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_RUIM && intValue == 1) {
            return 0;
        }
        return intValue;
    }

    /* access modifiers changed from: private */
    public void updateTtyMode(int i) {
        logi(String.format("updateTtyMode ttyMode=%d", new Object[]{Integer.valueOf(i)}));
        setTTYMode(telecomModeToPhoneMode(i), (Message) null);
    }

    /* access modifiers changed from: private */
    public void updateUiTtyMode(int i) {
        logi(String.format("updateUiTtyMode ttyMode=%d", new Object[]{Integer.valueOf(i)}));
        setUiTTYMode(telecomModeToPhoneMode(i), (Message) null);
    }

    private void loadTtyMode() {
        TelecomManager telecomManager = (TelecomManager) this.mContext.getSystemService(TelecomManager.class);
        updateTtyMode(telecomManager != null ? telecomManager.getCurrentTtyMode() : 0);
        updateUiTtyMode(Settings.Secure.getInt(this.mContext.getContentResolver(), "preferred_tty_mode", 0));
    }

    /* access modifiers changed from: protected */
    public void reapplyUiccAppsEnablementIfNeeded(int i) {
        boolean z;
        UiccSlot uiccSlotForPhone = this.mUiccController.getUiccSlotForPhone(this.mPhoneId);
        if (uiccSlotForPhone != null && uiccSlotForPhone.getCardState() == IccCardStatus.CardState.CARDSTATE_PRESENT && this.mUiccApplicationsEnabled != null) {
            String iccId = uiccSlotForPhone.getIccId(uiccSlotForPhone.getPortIndexFromPhoneId(this.mPhoneId));
            if (iccId == null) {
                loge("reapplyUiccAppsEnablementIfNeeded iccId is null, phoneId: " + this.mPhoneId + " portIndex: " + uiccSlotForPhone.getPortIndexFromPhoneId(this.mPhoneId));
                return;
            }
            SubscriptionInfo subInfoForIccId = SubscriptionController.getInstance().getSubInfoForIccId(IccUtils.stripTrailingFs(iccId));
            if (subInfoForIccId == null) {
                z = true;
            } else {
                z = subInfoForIccId.areUiccApplicationsEnabled();
            }
            if (z != this.mUiccApplicationsEnabled.booleanValue()) {
                this.mCi.enableUiccApplications(z, Message.obtain(this, 56, new Pair(Boolean.valueOf(z), Integer.valueOf(i))));
            }
        }
    }

    public void enableUiccApplications(boolean z, Message message) {
        UiccSlot uiccSlotForPhone = this.mUiccController.getUiccSlotForPhone(this.mPhoneId);
        if (uiccSlotForPhone != null && uiccSlotForPhone.getCardState() == IccCardStatus.CardState.CARDSTATE_PRESENT) {
            this.mCi.enableUiccApplications(z, message);
        } else if (message != null) {
            AsyncResult.forMessage(message, (Object) null, new IllegalStateException("No SIM card is present"));
            message.sendToTarget();
        }
    }

    public boolean canDisablePhysicalSubscription() {
        return this.mCi.canToggleUiccApplicationsEnablement();
    }

    public List<String> getEquivalentHomePlmns() {
        if (isPhoneTypeGsm()) {
            IccRecords iccRecords = this.mIccRecords.get();
            if (!(iccRecords == null || iccRecords.getEhplmns() == null)) {
                return Arrays.asList(iccRecords.getEhplmns());
            }
        } else if (isPhoneTypeCdma()) {
            loge("EHPLMN is not available in CDMA");
        }
        return Collections.emptyList();
    }

    public List<String> getDataServicePackages() {
        if (isUsingNewDataStack()) {
            return getDataNetworkController().getDataServicePackages();
        }
        ArrayList arrayList = new ArrayList();
        int[] iArr = {1, 2};
        for (int i = 0; i < 2; i++) {
            DcTracker dcTracker = getDcTracker(iArr[i]);
            if (dcTracker != null) {
                String dataServicePackageName = dcTracker.getDataServiceManager().getDataServicePackageName();
                if (!TextUtils.isEmpty(dataServicePackageName)) {
                    arrayList.add(dataServicePackageName);
                }
            }
        }
        return arrayList;
    }

    private void updateBroadcastEmergencyCallStateChangesAfterCarrierConfigChanged(PersistableBundle persistableBundle) {
        if (persistableBundle == null) {
            loge("didn't get broadcastEmergencyCallStateChanges from carrier config");
            return;
        }
        boolean z = persistableBundle.getBoolean("broadcast_emergency_call_state_changes_bool");
        logd("broadcastEmergencyCallStateChanges = " + z);
        setBroadcastEmergencyCallStateChanges(z);
    }

    private void updateNrSettingsAfterCarrierConfigChanged(PersistableBundle persistableBundle) {
        if (persistableBundle == null) {
            loge("didn't get the carrier_nr_availability_int from the carrier config.");
        } else {
            this.mIsCarrierNrSupported = !ArrayUtils.isEmpty(persistableBundle.getIntArray("carrier_nr_availabilities_int_array"));
        }
    }

    private void updateVoNrSettings(PersistableBundle persistableBundle) {
        if (SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
            logi("didn't updateVoNrSettings for add on case, will update by ims.");
            return;
        }
        UiccSlot uiccSlotForPhone = this.mUiccController.getUiccSlotForPhone(this.mPhoneId);
        if (uiccSlotForPhone != null && uiccSlotForPhone.getCardState() == IccCardStatus.CardState.CARDSTATE_PRESENT) {
            if (persistableBundle == null) {
                loge("didn't get the vonr_enabled_bool from the carrier config.");
                return;
            }
            boolean z = persistableBundle.getBoolean("vonr_enabled_bool");
            String subscriptionProperty = SubscriptionController.getInstance().getSubscriptionProperty(getSubId(), "nr_advanced_calling_enabled");
            int parseInt = subscriptionProperty != null ? Integer.parseInt(subscriptionProperty) : -1;
            logd("VoNR setting from telephony.db:" + parseInt + " ,vonr_enabled_bool:" + z);
            if (!z) {
                this.mCi.setVoNrEnabled(false, obtainMessage(61), (WorkSource) null);
            } else if (parseInt == 1 || parseInt == -1) {
                this.mCi.setVoNrEnabled(true, obtainMessage(61), (WorkSource) null);
            } else if (parseInt == 0) {
                this.mCi.setVoNrEnabled(false, obtainMessage(61), (WorkSource) null);
            }
        }
    }

    private void updateCdmaRoamingSettingsAfterCarrierConfigChanged(PersistableBundle persistableBundle) {
        if (persistableBundle == null) {
            loge("didn't get the cdma_roaming_mode changes from the carrier config.");
            return;
        }
        int i = persistableBundle.getInt("cdma_roaming_mode_int");
        int i2 = Settings.Global.getInt(getContext().getContentResolver(), "roaming_settings", -1);
        if (i != -1) {
            if (i == 0 || i == 1 || i == 2) {
                logd("cdma_roaming_mode is going to changed to " + i);
                setCdmaRoamingPreference(i, obtainMessage(44));
                return;
            }
            loge("Invalid cdma_roaming_mode settings: " + i);
        } else if (i2 != i) {
            logd("cdma_roaming_mode is going to changed to " + i2);
            setCdmaRoamingPreference(i2, obtainMessage(44));
        }
    }

    public boolean isImsUseEnabled() {
        ImsManager create = this.mImsManagerFactory.create(this.mContext, this.mPhoneId);
        return (create.isVolteEnabledByPlatform() && create.isEnhanced4gLteModeSettingEnabledByUser()) || (create.isWfcEnabledByPlatform() && create.isWfcEnabledByUser() && create.isNonTtyOrTtyOnVolteEnabled());
    }

    public InboundSmsHandler getInboundSmsHandler(boolean z) {
        return this.mIccSmsInterfaceManager.getInboundSmsHandler(z);
    }

    /* access modifiers changed from: protected */
    public boolean onHandleInCallMmi0(String str) {
        return handleCallDeflectionIncallSupplementaryService(str);
    }

    /* access modifiers changed from: protected */
    public PersistableBundle onGetCarrierConfig(CarrierConfigManager carrierConfigManager) {
        return carrierConfigManager.getConfigForSubId(getSubId());
    }

    /* access modifiers changed from: protected */
    public GsmMmiCode onCreateGsmMmiCode(String str, UiccCardApplication uiccCardApplication, ResultReceiver resultReceiver) {
        return GsmMmiCode.newFromDialString(str, this, this.mUiccApplication.get(), resultReceiver);
    }
}
