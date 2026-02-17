package com.android.internal.telephony.data;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.MatchAllNetworkSpecifier;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.NetworkSpecifier;
import android.net.TelephonyNetworkSpecifier;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.telephony.CarrierConfigManager;
import android.telephony.PhoneCapability;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.TelephonyRegistryManager;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.ImsRegistrationAttributes;
import android.telephony.ims.RegistrationManager;
import android.util.ArrayMap;
import com.android.ims.ImsException;
import com.android.ims.ImsManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.ISetOpportunisticDataCallback;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.NetworkFactory;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConfigurationManager;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.RadioConfig;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.data.CellularNetworkValidator;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.data.DataSettingsManager;
import com.android.internal.telephony.dataconnection.ApnConfigTypeRepository;
import com.android.internal.telephony.dataconnection.DcRequest;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.nano.TelephonyProto;
import com.android.telephony.Rlog;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;

public class PhoneSwitcher extends Handler {
    @VisibleForTesting
    public static int DEFAULT_DATA_OVERRIDE_TIMEOUT_MS = 5000;
    private static final int DEFAULT_EMERGENCY_PHONE_ID = 0;
    private static final int DEFAULT_NETWORK_CHANGE_TIMEOUT_MS = 5000;
    private static final int DEFAULT_VALIDATION_EXPIRATION_TIME = 2000;
    @VisibleForTesting
    public static int ECBM_DEFAULT_DATA_SWITCH_BASE_TIME_MS = 5000;
    private static final String EVALUATION_REASON_RADIO_ON = "EVENT_RADIO_ON";
    @VisibleForTesting
    public static final int EVENT_DATA_ENABLED_CHANGED = 114;
    private static final int EVENT_EMERGENCY_TOGGLE = 105;
    @VisibleForTesting
    public static final int EVENT_IMS_RADIO_TECH_CHANGED = 120;
    private static final int EVENT_MODEM_COMMAND_DONE = 112;
    protected static final int EVENT_MODEM_COMMAND_RETRY = 113;
    @VisibleForTesting
    public static final int EVENT_MULTI_SIM_CONFIG_CHANGED = 117;
    private static final int EVENT_NETWORK_AVAILABLE = 118;
    private static final int EVENT_NETWORK_VALIDATION_DONE = 110;
    private static final int EVENT_OPPT_DATA_SUB_CHANGED = 107;
    private static final int EVENT_OVERRIDE_DDS_FOR_EMERGENCY = 115;
    @VisibleForTesting
    public static final int EVENT_PRECISE_CALL_STATE_CHANGED = 109;
    private static final int EVENT_PRIMARY_DATA_SUB_CHANGED = 101;
    private static final int EVENT_PROCESS_SIM_STATE_CHANGE = 119;
    private static final int EVENT_RADIO_CAPABILITY_CHANGED = 106;
    private static final int EVENT_RADIO_ON = 108;
    private static final int EVENT_RELEASE_NETWORK = 104;
    private static final int EVENT_REMOVE_DDS_EMERGENCY_OVERRIDE = 116;
    private static final int EVENT_REMOVE_DEFAULT_NETWORK_CHANGE_CALLBACK = 111;
    private static final int EVENT_REQUEST_NETWORK = 103;
    protected static final int EVENT_SUBSCRIPTION_CHANGED = 102;
    protected static final int HAL_COMMAND_ALLOW_DATA = 1;
    protected static final int HAL_COMMAND_PREFERRED_DATA = 2;
    protected static final int HAL_COMMAND_UNKNOWN = 0;
    private static final String LOG_TAG = "PhoneSwitcher";
    private static final int MAX_LOCAL_LOG_LINES = 256;
    protected static final int MODEM_COMMAND_RETRY_PERIOD_MS = 5000;
    protected static final boolean REQUESTS_CHANGED = true;
    protected static final boolean REQUESTS_UNCHANGED = false;
    protected static final boolean VDBG = false;
    protected static PhoneSwitcher sPhoneSwitcher;
    protected int mActiveModemCount;
    protected final RegistrantList mActivePhoneRegistrants;
    private ConnectivityManager mConnectivityManager;
    protected final Context mContext;
    protected List<Set<CommandException.Error>> mCurrentDdsSwitchFailure;
    private final Map<Integer, DataSettingsManager.DataSettingsManagerCallback> mDataSettingsManagerCallbacks = new ArrayMap();
    private final BroadcastReceiver mDefaultDataChangedReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            PhoneSwitcher.this.obtainMessage(101).sendToTarget();
        }
    };
    private final DefaultNetworkCallback mDefaultNetworkCallback = new DefaultNetworkCallback();
    protected EmergencyOverrideRequest mEmergencyOverride;
    protected int mHalCommandToUse = 0;
    private Boolean mHasRegisteredDefaultNetworkChangeCallback = Boolean.FALSE;
    @VisibleForTesting
    public ImsRegTechProvider mImsRegTechProvider = new PhoneSwitcher$$ExternalSyntheticLambda0();
    /* access modifiers changed from: private */
    public int mImsRegistrationTech = -1;
    private boolean mIsRegisteredForImsRadioTechChange;
    private final LocalLog mLocalLog;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mMaxDataAttachModemCount;
    private final DataNetworkController.NetworkRequestList mNetworkRequestList = new DataNetworkController.NetworkRequestList();
    private int mOpptDataSubId = Integer.MAX_VALUE;
    private boolean mPendingSwitchNeedValidation;
    private int mPendingSwitchSubId = -1;
    protected int mPhoneIdInVoiceCall = -1;
    protected PhoneState[] mPhoneStates;
    protected int[] mPhoneSubscriptions;
    @VisibleForTesting
    protected int mPreferredDataPhoneId = -1;
    protected SubscriptionController.WatchedInt mPreferredDataSubId = new SubscriptionController.WatchedInt(-1) {
        public void set(int i) {
            super.set(i);
            SubscriptionController.invalidateActiveDataSubIdCaches();
        }
    };
    protected int mPrimaryDataSubId = -1;
    protected final List<DcRequest> mPrioritizedDcRequests = new ArrayList();
    protected RadioConfig mRadioConfig;
    private RegistrationManager.RegistrationCallback mRegistrationCallback = new RegistrationManager.RegistrationCallback() {
        public void onRegistered(ImsRegistrationAttributes imsRegistrationAttributes) {
            int registrationTechnology = imsRegistrationAttributes.getRegistrationTechnology();
            if (registrationTechnology != PhoneSwitcher.this.mImsRegistrationTech) {
                PhoneSwitcher.this.mImsRegistrationTech = registrationTechnology;
                PhoneSwitcher phoneSwitcher = PhoneSwitcher.this;
                phoneSwitcher.sendMessage(phoneSwitcher.obtainMessage(120));
            }
        }

        public void onUnregistered(ImsReasonInfo imsReasonInfo) {
            if (PhoneSwitcher.this.mImsRegistrationTech != -1) {
                PhoneSwitcher.this.mImsRegistrationTech = -1;
                PhoneSwitcher phoneSwitcher = PhoneSwitcher.this;
                phoneSwitcher.sendMessage(phoneSwitcher.obtainMessage(120));
            }
        }
    };
    private ISetOpportunisticDataCallback mSetOpptSubCallback;
    private BroadcastReceiver mSimStateIntentReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals("android.telephony.action.SIM_APPLICATION_STATE_CHANGED")) {
                int intExtra = intent.getIntExtra("android.telephony.extra.SIM_STATE", 0);
                int intExtra2 = intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1);
                PhoneSwitcher phoneSwitcher = PhoneSwitcher.this;
                phoneSwitcher.log("mSimStateIntentReceiver: slotIndex = " + intExtra2 + " state = " + intExtra);
                PhoneSwitcher.this.obtainMessage(119, intExtra2, intExtra).sendToTarget();
            }
        }
    };
    protected final SubscriptionController mSubscriptionController;
    private final SubscriptionManager.OnSubscriptionsChangedListener mSubscriptionsChangedListener = new SubscriptionManager.OnSubscriptionsChangedListener() {
        public void onSubscriptionsChanged() {
            PhoneSwitcher.this.obtainMessage(102).sendToTarget();
        }
    };
    @VisibleForTesting
    public final CellularNetworkValidator.ValidationCallback mValidationCallback = new CellularNetworkValidator.ValidationCallback() {
        public void onValidationDone(boolean z, int i) {
            Message.obtain(PhoneSwitcher.this, 110, i, z ? 1 : 0).sendToTarget();
        }

        public void onNetworkAvailable(Network network, int i) {
            Message.obtain(PhoneSwitcher.this, 118, i, 0, network).sendToTarget();
        }
    };
    @VisibleForTesting
    protected final CellularNetworkValidator mValidator;

    public interface ImsRegTechProvider {
        int get(Context context, int i);
    }

    /* access modifiers changed from: protected */
    public void suggestDefaultActivePhone(List<Integer> list) {
    }

    public static final class EmergencyOverrideRequest {
        int mGnssOverrideTimeMs = -1;
        CompletableFuture<Boolean> mOverrideCompleteFuture;
        boolean mPendingOriginatingCall = true;
        public int mPhoneId = -1;
        boolean mRequiresEcmFinish = false;

        /* access modifiers changed from: package-private */
        public boolean isCallbackAvailable() {
            return this.mOverrideCompleteFuture != null;
        }

        public void sendOverrideCompleteCallbackResultAndClear(boolean z) {
            if (isCallbackAvailable()) {
                this.mOverrideCompleteFuture.complete(Boolean.valueOf(z));
                this.mOverrideCompleteFuture = null;
            }
        }

        public String toString() {
            return String.format("EmergencyOverrideRequest: [phoneId= %d, overrideMs= %d, hasCallback= %b, ecmFinishStatus= %b]", new Object[]{Integer.valueOf(this.mPhoneId), Integer.valueOf(this.mGnssOverrideTimeMs), Boolean.valueOf(isCallbackAvailable()), Boolean.valueOf(this.mRequiresEcmFinish)});
        }
    }

    private class DefaultNetworkCallback extends ConnectivityManager.NetworkCallback {
        public int mExpectedSubId;
        public int mSwitchReason;

        private DefaultNetworkCallback() {
            this.mExpectedSubId = -1;
            this.mSwitchReason = 0;
        }

        public void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
            if (networkCapabilities.hasTransport(0) && SubscriptionManager.isValidSubscriptionId(this.mExpectedSubId) && this.mExpectedSubId == PhoneSwitcher.this.getSubIdFromNetworkSpecifier(networkCapabilities.getNetworkSpecifier())) {
                PhoneSwitcher.this.logDataSwitchEvent(this.mExpectedSubId, 2, this.mSwitchReason);
                PhoneSwitcher.this.removeDefaultNetworkChangeCallback();
            }
        }
    }

    public static PhoneSwitcher getInstance() {
        return sPhoneSwitcher;
    }

    public static PhoneSwitcher make(int i, Context context, Looper looper) {
        if (sPhoneSwitcher == null) {
            sPhoneSwitcher = new PhoneSwitcher(i, context, looper);
            SubscriptionController.invalidateActiveDataSubIdCaches();
        }
        return sPhoneSwitcher;
    }

    /* access modifiers changed from: protected */
    public boolean isImsOnOriginalNetwork(Phone phone) {
        boolean z = false;
        if (phone == null) {
            return false;
        }
        int phoneId = phone.getPhoneId();
        if (!SubscriptionManager.isValidPhoneId(phoneId)) {
            return false;
        }
        int i = this.mImsRegTechProvider.get(this.mContext, phoneId);
        if (!(i == 1 || i == 2)) {
            z = true;
        }
        if (!z) {
            log("IMS call on IWLAN or cross SIM. Call will be ignored for DDS switch");
        }
        return z;
    }

    /* access modifiers changed from: protected */
    public boolean isPhoneInVoiceCallChanged() {
        int i = this.mPhoneIdInVoiceCall;
        this.mPhoneIdInVoiceCall = -1;
        Phone[] phones = PhoneFactory.getPhones();
        int length = phones.length;
        int i2 = 0;
        while (true) {
            if (i2 >= length) {
                break;
            }
            Phone phone = phones[i2];
            if (isPhoneInVoiceCall(phone) || (isPhoneInVoiceCall(phone.getImsPhone()) && isImsOnOriginalNetwork(phone))) {
                this.mPhoneIdInVoiceCall = phone.getPhoneId();
            } else {
                i2++;
            }
        }
        if (this.mPhoneIdInVoiceCall == i) {
            return false;
        }
        log("isPhoneInVoiceCallChanged from phoneId " + i + " to phoneId " + this.mPhoneIdInVoiceCall);
        return true;
    }

    private void registerForImsRadioTechChange(Context context, int i) {
        try {
            ImsManager.getInstance(context, i).addRegistrationCallback(this.mRegistrationCallback, new PhoneSwitcher$$ExternalSyntheticLambda3(this));
            this.mIsRegisteredForImsRadioTechChange = true;
        } catch (ImsException unused) {
            this.mIsRegisteredForImsRadioTechChange = false;
        }
    }

    private void registerForImsRadioTechChange() {
        if (!this.mIsRegisteredForImsRadioTechChange) {
            for (int i = 0; i < this.mActiveModemCount; i++) {
                registerForImsRadioTechChange(this.mContext, i);
            }
        }
    }

    /* access modifiers changed from: private */
    public void evaluateIfDataSwitchIsNeeded(String str) {
        if (onEvaluate(false, str)) {
            logDataSwitchEvent(this.mPreferredDataSubId.get(), 1, 2);
            registerDefaultNetworkChangeCallback(this.mPreferredDataSubId.get(), 2);
        }
    }

    @VisibleForTesting
    public PhoneSwitcher(int i, Context context, Looper looper) {
        super(looper);
        int i2;
        this.mContext = context;
        int activeModemCount = getTm().getActiveModemCount();
        this.mActiveModemCount = activeModemCount;
        this.mPhoneSubscriptions = new int[activeModemCount];
        this.mPhoneStates = new PhoneState[activeModemCount];
        this.mMaxDataAttachModemCount = i;
        this.mLocalLog = new LocalLog(256);
        this.mSubscriptionController = SubscriptionController.getInstance();
        this.mRadioConfig = RadioConfig.getInstance();
        this.mValidator = CellularNetworkValidator.getInstance();
        this.mCurrentDdsSwitchFailure = new ArrayList();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.SIM_APPLICATION_STATE_CHANGED");
        context.registerReceiver(this.mSimStateIntentReceiver, intentFilter);
        this.mActivePhoneRegistrants = new RegistrantList();
        int i3 = 0;
        while (true) {
            i2 = this.mActiveModemCount;
            if (i3 >= i2) {
                break;
            }
            this.mPhoneStates[i3] = new PhoneState();
            Phone phone = PhoneFactory.getPhone(i3);
            if (phone != null) {
                phone.registerForEmergencyCallToggle(this, 105, (Object) null);
                phone.registerForPreciseCallStateChanged(this, 109, (Object) null);
                if (phone.getImsPhone() != null) {
                    phone.getImsPhone().registerForPreciseCallStateChanged(this, 109, (Object) null);
                }
                if (phone.isUsingNewDataStack()) {
                    this.mDataSettingsManagerCallbacks.computeIfAbsent(Integer.valueOf(phone.getPhoneId()), new PhoneSwitcher$$ExternalSyntheticLambda1(this));
                    phone.getDataSettingsManager().registerCallback(this.mDataSettingsManagerCallbacks.get(Integer.valueOf(phone.getPhoneId())));
                } else {
                    phone.getDataEnabledSettings().registerForDataEnabledChanged(this, 114, (Object) null);
                }
                registerForImsRadioTechChange(context, i3);
            }
            this.mCurrentDdsSwitchFailure.add(new HashSet());
            i3++;
        }
        if (i2 > 0) {
            PhoneFactory.getPhone(0).mCi.registerForOn(this, 108, (Object) null);
        }
        SubscriptionManager.OnSubscriptionsChangedListener onSubscriptionsChangedListener = this.mSubscriptionsChangedListener;
        ((TelephonyRegistryManager) context.getSystemService("telephony_registry")).addOnSubscriptionsChangedListener(onSubscriptionsChangedListener, onSubscriptionsChangedListener.getHandlerExecutor());
        this.mConnectivityManager = (ConnectivityManager) context.getSystemService("connectivity");
        this.mContext.registerReceiver(this.mDefaultDataChangedReceiver, new IntentFilter("android.intent.action.ACTION_DEFAULT_DATA_SUBSCRIPTION_CHANGED"));
        PhoneConfigurationManager.registerForMultiSimConfigChange(this, 117, (Object) null);
        new PhoneSwitcherNetworkRequestListener(looper, context, new NetworkCapabilities.Builder().addTransportType(0).addCapability(0).addCapability(1).addCapability(2).addCapability(3).addCapability(4).addCapability(5).addCapability(7).addCapability(8).addCapability(33).addCapability(9).addCapability(29).addCapability(10).addCapability(13).addCapability(12).addCapability(23).addCapability(34).addCapability(35).addEnterpriseId(1).addEnterpriseId(2).addEnterpriseId(3).addEnterpriseId(4).addEnterpriseId(5).setNetworkSpecifier(new MatchAllNetworkSpecifier()).build(), this).registerIgnoringScore();
        updateHalCommandToUse();
        log("PhoneSwitcher started");
    }

    /* access modifiers changed from: private */
    public /* synthetic */ DataSettingsManager.DataSettingsManagerCallback lambda$new$1(Integer num) {
        return new DataSettingsManager.DataSettingsManagerCallback(new PhoneSwitcher$$ExternalSyntheticLambda3(this)) {
            public void onDataEnabledChanged(boolean z, int i, String str) {
                PhoneSwitcher.this.evaluateIfDataSwitchIsNeeded("EVENT_DATA_ENABLED_CHANGED");
            }
        };
    }

    private boolean isSimApplicationReady(int i) {
        if (!SubscriptionManager.isValidSlotIndex(i)) {
            return false;
        }
        SubscriptionInfo activeSubscriptionInfoForSimSlotIndex = SubscriptionController.getInstance().getActiveSubscriptionInfoForSimSlotIndex(i, this.mContext.getOpPackageName(), (String) null);
        boolean z = activeSubscriptionInfoForSimSlotIndex != null && activeSubscriptionInfoForSimSlotIndex.areUiccApplicationsEnabled();
        if (PhoneFactory.getPhone(i).getIccCard().isEmptyProfile() || !z) {
            return false;
        }
        log("isSimApplicationReady: SIM is ready for slotIndex: " + i);
        return true;
    }

    public void handleMessage(Message message) {
        boolean z = false;
        switch (message.what) {
            case 101:
                if (onEvaluate(false, "primary data subId changed")) {
                    logDataSwitchEvent(this.mPreferredDataSubId.get(), 1, 1);
                    registerDefaultNetworkChangeCallback(this.mPreferredDataSubId.get(), 1);
                    return;
                }
                return;
            case 102:
                onEvaluate(false, "subChanged");
                return;
            case 103:
                onRequestNetwork((NetworkRequest) message.obj);
                return;
            case 104:
                onReleaseNetwork((NetworkRequest) message.obj);
                return;
            case 105:
                boolean isInEmergencyCallbackMode = isInEmergencyCallbackMode();
                if (this.mEmergencyOverride != null) {
                    log("Emergency override - ecbm status = " + isInEmergencyCallbackMode);
                    if (isInEmergencyCallbackMode) {
                        removeMessages(116);
                        this.mEmergencyOverride.mRequiresEcmFinish = true;
                    } else if (this.mEmergencyOverride.mRequiresEcmFinish) {
                        sendMessageDelayed(obtainMessage(116), (long) this.mEmergencyOverride.mGnssOverrideTimeMs);
                    }
                }
                onEvaluate(true, "emergencyToggle");
                return;
            case 106:
                sendRilCommands(message.arg1);
                return;
            case 107:
                int i = message.arg1;
                if (message.arg2 == 1) {
                    z = true;
                }
                setOpportunisticDataSubscription(i, z, (ISetOpportunisticDataCallback) message.obj);
                return;
            case 108:
                updateHalCommandToUse();
                onEvaluate(false, EVALUATION_REASON_RADIO_ON);
                return;
            case 109:
                registerForImsRadioTechChange();
                if (isPhoneInVoiceCallChanged()) {
                    if (!isAnyVoiceCallActiveOnDevice()) {
                        for (int i2 = 0; i2 < this.mActiveModemCount; i2++) {
                            if (this.mCurrentDdsSwitchFailure.get(i2).contains(CommandException.Error.OP_NOT_ALLOWED_DURING_VOICE_CALL) && isPhoneIdValidForRetry(i2)) {
                                sendRilCommands(i2);
                            }
                        }
                    }
                    EmergencyOverrideRequest emergencyOverrideRequest = this.mEmergencyOverride;
                    if (emergencyOverrideRequest != null && emergencyOverrideRequest.mPendingOriginatingCall) {
                        removeMessages(116);
                        if (this.mPhoneIdInVoiceCall == -1) {
                            sendMessageDelayed(obtainMessage(116), (long) (this.mEmergencyOverride.mGnssOverrideTimeMs + ECBM_DEFAULT_DATA_SWITCH_BASE_TIME_MS));
                            this.mEmergencyOverride.mPendingOriginatingCall = false;
                        }
                    }
                    evaluateIfDataSwitchIsNeeded("EVENT_PRECISE_CALL_STATE_CHANGED");
                    return;
                }
                return;
            case 110:
                int i3 = message.arg1;
                if (message.arg2 == 1) {
                    z = true;
                }
                onValidationDone(i3, z);
                return;
            case 111:
                removeDefaultNetworkChangeCallback();
                return;
            case 112:
                onDdsSwitchResponse((AsyncResult) message.obj);
                return;
            case 113:
                int intValue = ((Integer) message.obj).intValue();
                if (isPhoneIdValidForRetry(intValue)) {
                    log("EVENT_MODEM_COMMAND_RETRY: resend modem command on phone " + intValue);
                    sendRilCommands(intValue);
                    return;
                }
                log("EVENT_MODEM_COMMAND_RETRY: skip retry as DDS sub changed");
                this.mCurrentDdsSwitchFailure.get(intValue).clear();
                return;
            case 114:
                evaluateIfDataSwitchIsNeeded("EVENT_DATA_ENABLED_CHANGED");
                return;
            case 115:
                EmergencyOverrideRequest emergencyOverrideRequest2 = (EmergencyOverrideRequest) message.obj;
                EmergencyOverrideRequest emergencyOverrideRequest3 = this.mEmergencyOverride;
                if (emergencyOverrideRequest3 == null) {
                    this.mEmergencyOverride = emergencyOverrideRequest2;
                } else if (emergencyOverrideRequest3.mPhoneId != emergencyOverrideRequest2.mPhoneId) {
                    log("emergency override requested for phone id " + emergencyOverrideRequest2.mPhoneId + " when there is already an override in place for phone id " + this.mEmergencyOverride.mPhoneId + ". Ignoring.");
                    if (emergencyOverrideRequest2.isCallbackAvailable()) {
                        emergencyOverrideRequest2.mOverrideCompleteFuture.complete(Boolean.FALSE);
                        return;
                    }
                    return;
                } else {
                    if (emergencyOverrideRequest3.isCallbackAvailable()) {
                        this.mEmergencyOverride.mOverrideCompleteFuture.complete(Boolean.FALSE);
                    }
                    this.mEmergencyOverride = emergencyOverrideRequest2;
                }
                log("new emergency override - " + this.mEmergencyOverride);
                removeMessages(116);
                sendMessageDelayed(obtainMessage(116), (long) DEFAULT_DATA_OVERRIDE_TIMEOUT_MS);
                if (!onEvaluate(false, "emer_override_dds")) {
                    this.mEmergencyOverride.sendOverrideCompleteCallbackResultAndClear(true);
                    return;
                }
                return;
            case 116:
                log("Emergency override removed - " + this.mEmergencyOverride);
                this.mEmergencyOverride = null;
                onEvaluate(false, "emer_rm_override_dds");
                return;
            case 117:
                onMultiSimConfigChanged(((Integer) ((AsyncResult) message.obj).result).intValue());
                return;
            case 118:
                onNetworkAvailable(message.arg1, (Network) message.obj);
                return;
            case 119:
                int i4 = message.arg1;
                int i5 = message.arg2;
                if (!SubscriptionManager.isValidSlotIndex(i4)) {
                    log("EVENT_PROCESS_SIM_STATE_CHANGE: skip processing due to invalid slotId: " + i4);
                    return;
                } else if (this.mCurrentDdsSwitchFailure.get(i4).contains(CommandException.Error.INVALID_SIM_STATE) && 10 == i5 && isSimApplicationReady(i4)) {
                    sendRilCommands(i4);
                    return;
                } else {
                    return;
                }
            case 120:
                registerForImsRadioTechChange();
                if (isPhoneInVoiceCallChanged()) {
                    evaluateIfDataSwitchIsNeeded("EVENT_IMS_RADIO_TECH_CHANGED");
                    return;
                }
                return;
            default:
                return;
        }
    }

    private synchronized void onMultiSimConfigChanged(int i) {
        int i2 = this.mActiveModemCount;
        if (i2 != i) {
            this.mActiveModemCount = i;
            this.mPhoneSubscriptions = Arrays.copyOf(this.mPhoneSubscriptions, i);
            this.mPhoneStates = (PhoneState[]) Arrays.copyOf(this.mPhoneStates, this.mActiveModemCount);
            for (int i3 = i2 - 1; i3 >= this.mActiveModemCount; i3--) {
                this.mCurrentDdsSwitchFailure.remove(i3);
            }
            while (i2 < this.mActiveModemCount) {
                this.mPhoneStates[i2] = new PhoneState();
                Phone phone = PhoneFactory.getPhone(i2);
                if (phone != null) {
                    phone.registerForEmergencyCallToggle(this, 105, (Object) null);
                    phone.registerForPreciseCallStateChanged(this, 109, (Object) null);
                    if (phone.getImsPhone() != null) {
                        phone.getImsPhone().registerForPreciseCallStateChanged(this, 109, (Object) null);
                    }
                    if (phone.isUsingNewDataStack()) {
                        this.mDataSettingsManagerCallbacks.computeIfAbsent(Integer.valueOf(phone.getPhoneId()), new PhoneSwitcher$$ExternalSyntheticLambda2(this));
                        phone.getDataSettingsManager().registerCallback(this.mDataSettingsManagerCallbacks.get(Integer.valueOf(phone.getPhoneId())));
                    } else {
                        phone.getDataEnabledSettings().registerForDataEnabledChanged(this, 114, (Object) null);
                    }
                    this.mCurrentDdsSwitchFailure.add(new HashSet());
                    registerForImsRadioTechChange(this.mContext, i2);
                }
                i2++;
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ DataSettingsManager.DataSettingsManagerCallback lambda$onMultiSimConfigChanged$2(Integer num) {
        return new DataSettingsManager.DataSettingsManagerCallback(new PhoneSwitcher$$ExternalSyntheticLambda3(this)) {
            public void onDataEnabledChanged(boolean z, int i, String str) {
                PhoneSwitcher.this.evaluateIfDataSwitchIsNeeded("EVENT_DATA_ENABLED_CHANGED");
            }
        };
    }

    private boolean isInEmergencyCallbackMode() {
        for (Phone phone : PhoneFactory.getPhones()) {
            if (phone != null) {
                if (phone.isInEcm()) {
                    return true;
                }
                Phone imsPhone = phone.getImsPhone();
                if (imsPhone != null && imsPhone.isInEcm()) {
                    return true;
                }
            }
        }
        return false;
    }

    private static class PhoneSwitcherNetworkRequestListener extends NetworkFactory {
        private final PhoneSwitcher mPhoneSwitcher;

        public PhoneSwitcherNetworkRequestListener(Looper looper, Context context, NetworkCapabilities networkCapabilities, PhoneSwitcher phoneSwitcher) {
            super(looper, context, "PhoneSwitcherNetworkRequstListener", networkCapabilities);
            this.mPhoneSwitcher = phoneSwitcher;
        }

        /* access modifiers changed from: protected */
        public void needNetworkFor(NetworkRequest networkRequest) {
            Message obtainMessage = this.mPhoneSwitcher.obtainMessage(103);
            obtainMessage.obj = networkRequest;
            obtainMessage.sendToTarget();
        }

        /* access modifiers changed from: protected */
        public void releaseNetworkFor(NetworkRequest networkRequest) {
            Message obtainMessage = this.mPhoneSwitcher.obtainMessage(104);
            obtainMessage.obj = networkRequest;
            obtainMessage.sendToTarget();
        }
    }

    private void onRequestNetwork(NetworkRequest networkRequest) {
        if (PhoneFactory.getDefaultPhone().isUsingNewDataStack()) {
            TelephonyNetworkRequest telephonyNetworkRequest = new TelephonyNetworkRequest(networkRequest, PhoneFactory.getDefaultPhone());
            if (!this.mNetworkRequestList.contains(telephonyNetworkRequest)) {
                this.mNetworkRequestList.add(telephonyNetworkRequest);
                onEvaluate(true, "netRequest");
                return;
            }
            return;
        }
        DcRequest create = DcRequest.create(networkRequest, createApnRepository(networkRequest));
        if (create != null && !this.mPrioritizedDcRequests.contains(create)) {
            collectRequestNetworkMetrics(networkRequest);
            this.mPrioritizedDcRequests.add(create);
            Collections.sort(this.mPrioritizedDcRequests);
            onEvaluate(true, "netRequest");
        }
    }

    private void onReleaseNetwork(NetworkRequest networkRequest) {
        if (PhoneFactory.getDefaultPhone().isUsingNewDataStack()) {
            if (this.mNetworkRequestList.remove(new TelephonyNetworkRequest(networkRequest, PhoneFactory.getDefaultPhone()))) {
                onEvaluate(true, "netReleased");
                collectReleaseNetworkMetrics(networkRequest);
                return;
            }
            return;
        }
        DcRequest create = DcRequest.create(networkRequest, createApnRepository(networkRequest));
        if (create != null && this.mPrioritizedDcRequests.remove(create)) {
            onEvaluate(true, "netReleased");
            collectReleaseNetworkMetrics(networkRequest);
        }
    }

    private ApnConfigTypeRepository createApnRepository(NetworkRequest networkRequest) {
        int subIdUsingPhoneId = this.mSubscriptionController.getSubIdUsingPhoneId(phoneIdForRequest(networkRequest));
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config");
        return new ApnConfigTypeRepository(carrierConfigManager != null ? carrierConfigManager.getConfigForSubId(subIdUsingPhoneId) : null);
    }

    /* access modifiers changed from: private */
    public void removeDefaultNetworkChangeCallback() {
        removeMessages(111);
        DefaultNetworkCallback defaultNetworkCallback = this.mDefaultNetworkCallback;
        defaultNetworkCallback.mExpectedSubId = -1;
        defaultNetworkCallback.mSwitchReason = 0;
        this.mConnectivityManager.unregisterNetworkCallback(defaultNetworkCallback);
    }

    private void registerDefaultNetworkChangeCallback(int i, int i2) {
        DefaultNetworkCallback defaultNetworkCallback = this.mDefaultNetworkCallback;
        defaultNetworkCallback.mExpectedSubId = i;
        defaultNetworkCallback.mSwitchReason = i2;
        this.mConnectivityManager.registerDefaultNetworkCallback(defaultNetworkCallback, this);
        sendMessageDelayed(obtainMessage(111), 5000);
    }

    private void collectRequestNetworkMetrics(NetworkRequest networkRequest) {
        if (this.mActiveModemCount > 1 && networkRequest.hasCapability(0)) {
            TelephonyProto.TelephonyEvent.OnDemandDataSwitch onDemandDataSwitch = new TelephonyProto.TelephonyEvent.OnDemandDataSwitch();
            onDemandDataSwitch.apn = 2;
            onDemandDataSwitch.state = 1;
            TelephonyMetrics.getInstance().writeOnDemandDataSwitch(onDemandDataSwitch);
        }
    }

    private void collectReleaseNetworkMetrics(NetworkRequest networkRequest) {
        if (this.mActiveModemCount > 1 && networkRequest.hasCapability(0)) {
            TelephonyProto.TelephonyEvent.OnDemandDataSwitch onDemandDataSwitch = new TelephonyProto.TelephonyEvent.OnDemandDataSwitch();
            onDemandDataSwitch.apn = 2;
            onDemandDataSwitch.state = 2;
            TelephonyMetrics.getInstance().writeOnDemandDataSwitch(onDemandDataSwitch);
        }
    }

    private TelephonyManager getTm() {
        return (TelephonyManager) this.mContext.getSystemService("phone");
    }

    /* access modifiers changed from: protected */
    public boolean onEvaluate(boolean z, String str) {
        StringBuilder sb = new StringBuilder(str);
        int i = 0;
        boolean z2 = this.mHalCommandToUse != 2 && z;
        int defaultDataSubId = this.mSubscriptionController.getDefaultDataSubId();
        if (defaultDataSubId != this.mPrimaryDataSubId) {
            sb.append(" mPrimaryDataSubId ");
            sb.append(this.mPrimaryDataSubId);
            sb.append("->");
            sb.append(defaultDataSubId);
            this.mPrimaryDataSubId = defaultDataSubId;
        }
        boolean z3 = false;
        for (int i2 = 0; i2 < this.mActiveModemCount; i2++) {
            int subIdUsingPhoneId = this.mSubscriptionController.getSubIdUsingPhoneId(i2);
            if (SubscriptionManager.isValidSubscriptionId(subIdUsingPhoneId)) {
                z3 = true;
            }
            if (subIdUsingPhoneId != this.mPhoneSubscriptions[i2]) {
                sb.append(" phone[");
                sb.append(i2);
                sb.append("] ");
                sb.append(this.mPhoneSubscriptions[i2]);
                sb.append("->");
                sb.append(subIdUsingPhoneId);
                this.mPhoneSubscriptions[i2] = subIdUsingPhoneId;
                z2 = true;
            }
        }
        if (!z3) {
            transitionToEmergencyPhone();
        }
        int i3 = this.mPreferredDataPhoneId;
        int i4 = this.mPreferredDataSubId.get();
        if (z3) {
            updatePreferredDataPhoneId();
        }
        if (i3 != this.mPreferredDataPhoneId) {
            sb.append(" preferred phoneId ");
            sb.append(i3);
            sb.append("->");
            sb.append(this.mPreferredDataPhoneId);
            z2 = true;
        } else if (i4 != this.mPreferredDataSubId.get()) {
            log("SIM refresh, notify dds change");
            notifyPreferredDataSubIdChanged();
        }
        if (z2 || EVALUATION_REASON_RADIO_ON.equals(str)) {
            log("evaluating due to " + sb.toString());
            if (this.mHalCommandToUse == 2) {
                while (i < this.mActiveModemCount) {
                    this.mPhoneStates[i].active = true;
                    i++;
                }
                sendRilCommands(this.mPreferredDataPhoneId);
            } else {
                ArrayList<Integer> arrayList = new ArrayList<>();
                if (this.mMaxDataAttachModemCount == this.mActiveModemCount) {
                    for (int i5 = 0; i5 < this.mMaxDataAttachModemCount; i5++) {
                        arrayList.add(Integer.valueOf(i5));
                    }
                } else {
                    int i6 = this.mPhoneIdInVoiceCall;
                    if (i6 != -1) {
                        arrayList.add(Integer.valueOf(i6));
                    }
                    if (arrayList.size() < this.mMaxDataAttachModemCount) {
                        if (PhoneFactory.getDefaultPhone().isUsingNewDataStack()) {
                            Iterator it = this.mNetworkRequestList.iterator();
                            while (it.hasNext()) {
                                int phoneIdForRequest = phoneIdForRequest((TelephonyNetworkRequest) it.next());
                                if (phoneIdForRequest != -1 && !arrayList.contains(Integer.valueOf(phoneIdForRequest))) {
                                    arrayList.add(Integer.valueOf(phoneIdForRequest));
                                    if (arrayList.size() >= this.mMaxDataAttachModemCount) {
                                        break;
                                    }
                                }
                            }
                        } else {
                            for (DcRequest dcRequest : this.mPrioritizedDcRequests) {
                                int phoneIdForRequest2 = phoneIdForRequest(dcRequest.networkRequest);
                                if (phoneIdForRequest2 != -1 && !arrayList.contains(Integer.valueOf(phoneIdForRequest2))) {
                                    arrayList.add(Integer.valueOf(phoneIdForRequest2));
                                    if (arrayList.size() >= this.mMaxDataAttachModemCount) {
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if (arrayList.size() < this.mMaxDataAttachModemCount && arrayList.contains(Integer.valueOf(this.mPreferredDataPhoneId)) && SubscriptionManager.isUsableSubIdValue(this.mPreferredDataPhoneId)) {
                        arrayList.add(Integer.valueOf(this.mPreferredDataPhoneId));
                    }
                    suggestDefaultActivePhone(arrayList);
                }
                while (i < this.mActiveModemCount) {
                    if (!arrayList.contains(Integer.valueOf(i))) {
                        deactivate(i);
                    }
                    i++;
                }
                for (Integer intValue : arrayList) {
                    activate(intValue.intValue());
                }
            }
        }
        return z2;
    }

    protected static class PhoneState {
        public volatile boolean active = false;
        public long lastRequested = 0;

        protected PhoneState() {
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void activate(int i) {
        switchPhone(i, true);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void deactivate(int i) {
        switchPhone(i, false);
    }

    private void switchPhone(int i, boolean z) {
        PhoneState phoneState = this.mPhoneStates[i];
        if (phoneState.active != z) {
            phoneState.active = z;
            StringBuilder sb = new StringBuilder();
            sb.append(z ? "activate " : "deactivate ");
            sb.append(i);
            log(sb.toString());
            phoneState.lastRequested = System.currentTimeMillis();
            sendRilCommands(i);
        }
    }

    public void onRadioCapChanged(int i) {
        if (SubscriptionManager.isValidPhoneId(i)) {
            Message obtainMessage = obtainMessage(106);
            obtainMessage.arg1 = i;
            obtainMessage.sendToTarget();
        }
    }

    public void overrideDefaultDataForEmergency(int i, int i2, CompletableFuture<Boolean> completableFuture) {
        if (SubscriptionManager.isValidPhoneId(i)) {
            Message obtainMessage = obtainMessage(115);
            EmergencyOverrideRequest emergencyOverrideRequest = new EmergencyOverrideRequest();
            emergencyOverrideRequest.mPhoneId = i;
            emergencyOverrideRequest.mGnssOverrideTimeMs = i2 * 1000;
            emergencyOverrideRequest.mOverrideCompleteFuture = completableFuture;
            obtainMessage.obj = emergencyOverrideRequest;
            obtainMessage.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public void sendRilCommands(int i) {
        if (!SubscriptionManager.isValidPhoneId(i)) {
            log("sendRilCommands: skip dds switch due to invalid phoneId=" + i);
            return;
        }
        Message obtain = Message.obtain(this, 112, Integer.valueOf(i));
        int i2 = this.mHalCommandToUse;
        if (i2 == 1 || i2 == 0) {
            if (this.mActiveModemCount > 1) {
                PhoneFactory.getPhone(i).mCi.setDataAllowed(isPhoneActive(i), obtain);
            }
        } else if (i == this.mPreferredDataPhoneId) {
            log("sendRilCommands: setPreferredDataModem - phoneId: " + i);
            this.mRadioConfig.setPreferredDataModem(this.mPreferredDataPhoneId, obtain);
        }
    }

    private void onPhoneCapabilityChangedInternal(PhoneCapability phoneCapability) {
        int numberOfModemsWithSimultaneousDataConnections = TelephonyManager.getDefault().getNumberOfModemsWithSimultaneousDataConnections();
        if (this.mMaxDataAttachModemCount != numberOfModemsWithSimultaneousDataConnections) {
            this.mMaxDataAttachModemCount = numberOfModemsWithSimultaneousDataConnections;
            log("Max active phones changed to " + this.mMaxDataAttachModemCount);
            onEvaluate(false, "phoneCfgChanged");
        }
    }

    private int phoneIdForRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        return phoneIdForRequest(telephonyNetworkRequest.getNativeNetworkRequest());
    }

    /* access modifiers changed from: protected */
    public int phoneIdForRequest(NetworkRequest networkRequest) {
        int subIdFromNetworkSpecifier = getSubIdFromNetworkSpecifier(networkRequest.getNetworkSpecifier());
        if (subIdFromNetworkSpecifier == Integer.MAX_VALUE) {
            return this.mPreferredDataPhoneId;
        }
        if (subIdFromNetworkSpecifier == -1) {
            return -1;
        }
        int i = this.mPreferredDataPhoneId;
        int i2 = (i < 0 || i >= this.mActiveModemCount) ? -1 : this.mPhoneSubscriptions[i];
        if (networkRequest.hasCapability(12) && networkRequest.hasCapability(13) && subIdFromNetworkSpecifier != i2 && subIdFromNetworkSpecifier != this.mValidator.getSubIdInValidation()) {
            return -1;
        }
        for (int i3 = 0; i3 < this.mActiveModemCount; i3++) {
            if (this.mPhoneSubscriptions[i3] == subIdFromNetworkSpecifier) {
                return i3;
            }
        }
        return -1;
    }

    /* access modifiers changed from: protected */
    public int getSubIdFromNetworkSpecifier(NetworkSpecifier networkSpecifier) {
        if (networkSpecifier == null) {
            return Integer.MAX_VALUE;
        }
        if (networkSpecifier instanceof TelephonyNetworkSpecifier) {
            return ((TelephonyNetworkSpecifier) networkSpecifier).getSubscriptionId();
        }
        return -1;
    }

    /* access modifiers changed from: protected */
    public int getSubIdForDefaultNetworkRequests() {
        if (this.mSubscriptionController.isActiveSubId(this.mOpptDataSubId)) {
            return this.mOpptDataSubId;
        }
        return this.mPrimaryDataSubId;
    }

    /* access modifiers changed from: protected */
    public void updatePreferredDataPhoneId() {
        boolean z;
        Phone findPhoneById = findPhoneById(this.mPhoneIdInVoiceCall);
        int i = 0;
        if (findPhoneById != null) {
            z = findPhoneById.isUsingNewDataStack() ? findPhoneById.getDataSettingsManager().isDataEnabled(17) : findPhoneById.getDataEnabledSettings().isDataEnabled(17);
        } else {
            z = false;
        }
        EmergencyOverrideRequest emergencyOverrideRequest = this.mEmergencyOverride;
        if (emergencyOverrideRequest != null && findPhoneById(emergencyOverrideRequest.mPhoneId) != null) {
            log("updatePreferredDataPhoneId: preferred data overridden for emergency. phoneId = " + this.mEmergencyOverride.mPhoneId);
            this.mPreferredDataPhoneId = this.mEmergencyOverride.mPhoneId;
        } else if (z) {
            this.mPreferredDataPhoneId = this.mPhoneIdInVoiceCall;
        } else {
            int subIdForDefaultNetworkRequests = getSubIdForDefaultNetworkRequests();
            int i2 = -1;
            if (SubscriptionManager.isUsableSubIdValue(subIdForDefaultNetworkRequests)) {
                while (true) {
                    if (i >= this.mActiveModemCount) {
                        break;
                    } else if (this.mPhoneSubscriptions[i] == subIdForDefaultNetworkRequests) {
                        i2 = i;
                        break;
                    } else {
                        i++;
                    }
                }
            }
            this.mPreferredDataPhoneId = i2;
        }
        this.mPreferredDataSubId.set(this.mSubscriptionController.getSubIdUsingPhoneId(this.mPreferredDataPhoneId));
    }

    /* access modifiers changed from: protected */
    public void transitionToEmergencyPhone() {
        if (this.mActiveModemCount <= 0) {
            log("No phones: unable to reset preferred phone for emergency");
            return;
        }
        if (this.mPreferredDataPhoneId != 0) {
            log("No active subscriptions: resetting preferred phone to 0 for emergency");
            this.mPreferredDataPhoneId = 0;
        }
        if (this.mPreferredDataSubId.get() != -1) {
            this.mPreferredDataSubId.set(-1);
            notifyPreferredDataSubIdChanged();
        }
    }

    /* access modifiers changed from: protected */
    public Phone findPhoneById(int i) {
        if (!SubscriptionManager.isValidPhoneId(i)) {
            return null;
        }
        return PhoneFactory.getPhone(i);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:26:0x0046, code lost:
        return r1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:32:0x004f, code lost:
        return r1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:34:0x0051, code lost:
        return false;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized boolean shouldApplyNetworkRequest(com.android.internal.telephony.data.TelephonyNetworkRequest r6, int r7) {
        /*
            r5 = this;
            monitor-enter(r5)
            boolean r0 = android.telephony.SubscriptionManager.isValidPhoneId(r7)     // Catch:{ all -> 0x0052 }
            r1 = 0
            if (r0 != 0) goto L_0x000a
            monitor-exit(r5)
            return r1
        L_0x000a:
            boolean r0 = r5.isPhoneActive(r7)     // Catch:{ all -> 0x0052 }
            if (r0 == 0) goto L_0x0050
            com.android.internal.telephony.SubscriptionController r0 = r5.mSubscriptionController     // Catch:{ all -> 0x0052 }
            int r0 = r0.getSubIdUsingPhoneId(r7)     // Catch:{ all -> 0x0052 }
            r2 = -1
            if (r0 != r2) goto L_0x0020
            boolean r0 = r5.isEmergencyNetworkRequest(r6)     // Catch:{ all -> 0x0052 }
            if (r0 != 0) goto L_0x0020
            goto L_0x0050
        L_0x0020:
            android.net.NetworkRequest r0 = r6.getNativeNetworkRequest()     // Catch:{ all -> 0x0052 }
            android.net.NetworkSpecifier r0 = r0.getNetworkSpecifier()     // Catch:{ all -> 0x0052 }
            int r0 = r5.getSubIdFromNetworkSpecifier(r0)     // Catch:{ all -> 0x0052 }
            boolean r3 = r5.isAnyVoiceCallActiveOnDevice()     // Catch:{ all -> 0x0052 }
            r4 = 1
            if (r3 == 0) goto L_0x0047
            boolean r3 = r5.isEmergencyNetworkRequest(r6)     // Catch:{ all -> 0x0052 }
            if (r3 == 0) goto L_0x0047
            r3 = 2147483647(0x7fffffff, float:NaN)
            if (r0 == r3) goto L_0x0040
            if (r0 != r2) goto L_0x0047
        L_0x0040:
            int r6 = r5.mPhoneIdInVoiceCall     // Catch:{ all -> 0x0052 }
            if (r7 != r6) goto L_0x0045
            r1 = r4
        L_0x0045:
            monitor-exit(r5)
            return r1
        L_0x0047:
            int r6 = r5.phoneIdForRequest((com.android.internal.telephony.data.TelephonyNetworkRequest) r6)     // Catch:{ all -> 0x0052 }
            if (r7 != r6) goto L_0x004e
            r1 = r4
        L_0x004e:
            monitor-exit(r5)
            return r1
        L_0x0050:
            monitor-exit(r5)
            return r1
        L_0x0052:
            r6 = move-exception
            monitor-exit(r5)
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.PhoneSwitcher.shouldApplyNetworkRequest(com.android.internal.telephony.data.TelephonyNetworkRequest, int):boolean");
    }

    /* access modifiers changed from: package-private */
    public boolean isEmergencyNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest) {
        return telephonyNetworkRequest.hasCapability(10);
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public boolean isPhoneActive(int i) {
        if (i >= this.mActiveModemCount) {
            return false;
        }
        return this.mPhoneStates[i].active;
    }

    public void registerForActivePhoneSwitch(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        this.mActivePhoneRegistrants.add(registrant);
        registrant.notifyRegistrant();
    }

    public void unregisterForActivePhoneSwitch(Handler handler) {
        this.mActivePhoneRegistrants.remove(handler);
    }

    private void setOpportunisticDataSubscription(int i, boolean z, ISetOpportunisticDataCallback iSetOpportunisticDataCallback) {
        if (this.mSubscriptionController.isActiveSubId(i) || i == Integer.MAX_VALUE) {
            removeMessages(110);
            removeMessages(118);
            int i2 = i == Integer.MAX_VALUE ? this.mPrimaryDataSubId : i;
            this.mPendingSwitchSubId = -1;
            if (this.mValidator.isValidating()) {
                this.mValidator.lambda$reportValidationResult$1();
                sendSetOpptCallbackHelper(this.mSetOpptSubCallback, 1);
                this.mSetOpptSubCallback = null;
            }
            if (i == this.mOpptDataSubId) {
                sendSetOpptCallbackHelper(iSetOpportunisticDataCallback, 0);
                return;
            }
            logDataSwitchEvent(i == Integer.MAX_VALUE ? this.mPrimaryDataSubId : i, 1, 3);
            registerDefaultNetworkChangeCallback(i == Integer.MAX_VALUE ? this.mPrimaryDataSubId : i, 3);
            if (!this.mValidator.isValidationFeatureSupported()) {
                setOpportunisticSubscriptionInternal(i);
                sendSetOpptCallbackHelper(iSetOpportunisticDataCallback, 0);
                return;
            }
            this.mPendingSwitchSubId = i2;
            this.mPendingSwitchNeedValidation = z;
            this.mSetOpptSubCallback = iSetOpportunisticDataCallback;
            this.mValidator.validate(i2, getValidationTimeout(i2, z), false, this.mValidationCallback);
            return;
        }
        log("Can't switch data to inactive subId " + i);
        sendSetOpptCallbackHelper(iSetOpportunisticDataCallback, 2);
    }

    private long getValidationTimeout(int i, boolean z) {
        CarrierConfigManager carrierConfigManager;
        PersistableBundle configForSubId;
        if (!z || (carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config")) == null || (configForSubId = carrierConfigManager.getConfigForSubId(i)) == null) {
            return LaunchConfig.ACTIVITY_CONSIDERED_RESUME;
        }
        return configForSubId.getLong("data_switch_validation_timeout_long");
    }

    private void sendSetOpptCallbackHelper(ISetOpportunisticDataCallback iSetOpportunisticDataCallback, int i) {
        if (iSetOpportunisticDataCallback != null) {
            try {
                iSetOpportunisticDataCallback.onComplete(i);
            } catch (RemoteException e) {
                log("RemoteException " + e);
            }
        }
    }

    private void setOpportunisticSubscriptionInternal(int i) {
        if (this.mOpptDataSubId != i) {
            this.mOpptDataSubId = i;
            onEvaluate(false, "oppt data subId changed");
        }
    }

    private void confirmSwitch(int i, boolean z) {
        int i2;
        StringBuilder sb = new StringBuilder();
        sb.append("confirmSwitch: subId ");
        sb.append(i);
        sb.append(z ? " confirmed." : " cancelled.");
        log(sb.toString());
        if (!this.mSubscriptionController.isActiveSubId(i)) {
            log("confirmSwitch: subId " + i + " is no longer active");
            i2 = 2;
        } else if (!z) {
            i2 = 1;
        } else {
            if (this.mSubscriptionController.isOpportunistic(i)) {
                setOpportunisticSubscriptionInternal(i);
            } else {
                setOpportunisticSubscriptionInternal(Integer.MAX_VALUE);
            }
            i2 = 0;
        }
        sendSetOpptCallbackHelper(this.mSetOpptSubCallback, i2);
        this.mSetOpptSubCallback = null;
        this.mPendingSwitchSubId = -1;
    }

    private void onNetworkAvailable(int i, Network network) {
        log("onNetworkAvailable: on subId " + i);
        int i2 = this.mPendingSwitchSubId;
        if (i2 != -1 && i2 == i && !this.mPendingSwitchNeedValidation) {
            confirmSwitch(i, true);
        }
    }

    private void onValidationDone(int i, boolean z) {
        StringBuilder sb = new StringBuilder();
        sb.append("onValidationDone: ");
        sb.append(z ? "passed" : "failed");
        sb.append(" on subId ");
        sb.append(i);
        log(sb.toString());
        int i2 = this.mPendingSwitchSubId;
        if (i2 != -1 && i2 == i) {
            confirmSwitch(i, z || !this.mPendingSwitchNeedValidation);
        }
    }

    public void trySetOpportunisticDataSubscription(int i, boolean z, ISetOpportunisticDataCallback iSetOpportunisticDataCallback) {
        StringBuilder sb = new StringBuilder();
        sb.append("Try set opportunistic data subscription to subId ");
        sb.append(i);
        sb.append(z ? " with " : " without ");
        sb.append("validation");
        log(sb.toString());
        obtainMessage(107, i, z ? 1 : 0, iSetOpportunisticDataCallback).sendToTarget();
    }

    /* access modifiers changed from: protected */
    public boolean isPhoneInVoiceCall(Phone phone) {
        if (phone == null) {
            return false;
        }
        if (!phone.getBackgroundCall().isIdle() || !phone.getForegroundCall().isIdle()) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public void updateHalCommandToUse() {
        this.mHalCommandToUse = this.mRadioConfig.isSetPreferredDataCommandSupported() ? 2 : 1;
    }

    public int getOpportunisticDataSubscriptionId() {
        return this.mOpptDataSubId;
    }

    public int getPreferredDataPhoneId() {
        return this.mPreferredDataPhoneId;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(LOG_TAG, str);
        this.mLocalLog.log(str);
    }

    private static String switchReasonToString(int i) {
        if (i == 0) {
            return "UNKNOWN";
        }
        if (i == 1) {
            return "MANUAL";
        }
        if (i == 2) {
            return "IN_CALL";
        }
        if (i == 3) {
            return "CBRS";
        }
        return "UNKNOWN(" + i + ")";
    }

    private static String switchStateToString(int i) {
        if (i == 0) {
            return "UNKNOWN";
        }
        if (i == 1) {
            return "START";
        }
        if (i == 2) {
            return "END";
        }
        return "UNKNOWN(" + i + ")";
    }

    /* access modifiers changed from: private */
    public void logDataSwitchEvent(int i, int i2, int i3) {
        log("Data switch event. subId=" + i + ", state=" + switchStateToString(i2) + ", reason=" + switchReasonToString(i3));
        TelephonyProto.TelephonyEvent.DataSwitch dataSwitch = new TelephonyProto.TelephonyEvent.DataSwitch();
        dataSwitch.state = i2;
        dataSwitch.reason = i3;
        TelephonyMetrics.getInstance().writeDataSwitch(i, dataSwitch);
    }

    /* access modifiers changed from: protected */
    public void notifyPreferredDataSubIdChanged() {
        log("notifyPreferredDataSubIdChanged to " + this.mPreferredDataSubId.get());
        ((TelephonyRegistryManager) this.mContext.getSystemService("telephony_registry")).notifyActiveDataSubIdChanged(this.mPreferredDataSubId.get());
    }

    public int getActiveDataSubId() {
        return this.mPreferredDataSubId.get();
    }

    private void onPhoneCapabilityChanged(PhoneCapability phoneCapability) {
        onPhoneCapabilityChangedInternal(phoneCapability);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        String str;
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println("PhoneSwitcher:");
        indentingPrintWriter.increaseIndent();
        Calendar instance = Calendar.getInstance();
        for (int i = 0; i < this.mActiveModemCount; i++) {
            PhoneState phoneState = this.mPhoneStates[i];
            instance.setTimeInMillis(phoneState.lastRequested);
            StringBuilder sb = new StringBuilder();
            sb.append("PhoneId(");
            sb.append(i);
            sb.append(") active=");
            sb.append(phoneState.active);
            sb.append(", lastRequest=");
            if (phoneState.lastRequested == 0) {
                str = "never";
            } else {
                str = String.format("%tm-%td %tH:%tM:%tS.%tL", new Object[]{instance, instance, instance, instance, instance, instance});
            }
            sb.append(str);
            indentingPrintWriter.println(sb.toString());
        }
        indentingPrintWriter.println("mPreferredDataPhoneId=" + this.mPreferredDataPhoneId);
        indentingPrintWriter.println("mPreferredDataSubId=" + this.mPreferredDataSubId.get());
        indentingPrintWriter.println("DefaultDataSubId=" + this.mSubscriptionController.getDefaultDataSubId());
        StringBuilder sb2 = new StringBuilder();
        sb2.append("DefaultDataPhoneId=");
        SubscriptionController subscriptionController = this.mSubscriptionController;
        sb2.append(subscriptionController.getPhoneId(subscriptionController.getDefaultDataSubId()));
        indentingPrintWriter.println(sb2.toString());
        indentingPrintWriter.println("mPrimaryDataSubId=" + this.mPrimaryDataSubId);
        indentingPrintWriter.println("mOpptDataSubId=" + this.mOpptDataSubId);
        indentingPrintWriter.println("mIsRegisteredForImsRadioTechChange=" + this.mIsRegisteredForImsRadioTechChange);
        indentingPrintWriter.println("mPendingSwitchNeedValidation=" + this.mPendingSwitchNeedValidation);
        indentingPrintWriter.println("mMaxDataAttachModemCount=" + this.mMaxDataAttachModemCount);
        indentingPrintWriter.println("mActiveModemCount=" + this.mActiveModemCount);
        indentingPrintWriter.println("mPhoneIdInVoiceCall=" + this.mPhoneIdInVoiceCall);
        indentingPrintWriter.println("mCurrentDdsSwitchFailure=" + this.mCurrentDdsSwitchFailure);
        indentingPrintWriter.println("Local logs:");
        indentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.decreaseIndent();
    }

    private boolean isAnyVoiceCallActiveOnDevice() {
        return this.mPhoneIdInVoiceCall != -1;
    }

    /* access modifiers changed from: protected */
    public void onDdsSwitchResponse(AsyncResult asyncResult) {
        boolean z = asyncResult != null && asyncResult.exception == null;
        int intValue = ((Integer) asyncResult.userObj).intValue();
        if (this.mEmergencyOverride != null) {
            log("Emergency override result sent = " + z);
            this.mEmergencyOverride.sendOverrideCompleteCallbackResultAndClear(z);
        } else if (!z) {
            log("onDdsSwitchResponse: DDS switch failed. with exception " + asyncResult.exception);
            Throwable th = asyncResult.exception;
            if (th instanceof CommandException) {
                CommandException.Error commandError = ((CommandException) th).getCommandError();
                this.mCurrentDdsSwitchFailure.get(intValue).add(commandError);
                if (commandError == CommandException.Error.OP_NOT_ALLOWED_DURING_VOICE_CALL) {
                    log("onDdsSwitchResponse: Wait for call end indication");
                    return;
                } else if (commandError == CommandException.Error.INVALID_SIM_STATE) {
                    log("onDdsSwitchResponse: Wait for SIM to get READY");
                    return;
                }
            }
            log("onDdsSwitchResponse: Scheduling DDS switch retry");
            sendMessageDelayed(Message.obtain(this, 113, Integer.valueOf(intValue)), 5000);
            return;
        }
        if (z) {
            log("onDdsSwitchResponse: DDS switch success on phoneId = " + intValue);
        }
        this.mCurrentDdsSwitchFailure.get(intValue).clear();
        this.mActivePhoneRegistrants.notifyRegistrants();
        notifyPreferredDataSubIdChanged();
    }

    private boolean isPhoneIdValidForRetry(int i) {
        SubscriptionController subscriptionController = this.mSubscriptionController;
        int phoneId = subscriptionController.getPhoneId(subscriptionController.getDefaultDataSubId());
        if (phoneId != -1 && phoneId == i) {
            return true;
        }
        if (PhoneFactory.getDefaultPhone().isUsingNewDataStack()) {
            if (this.mNetworkRequestList.isEmpty()) {
                return false;
            }
            Iterator it = this.mNetworkRequestList.iterator();
            while (it.hasNext()) {
                if (phoneIdForRequest((TelephonyNetworkRequest) it.next()) == i) {
                    return true;
                }
            }
        } else if (this.mPrioritizedDcRequests.size() == 0) {
            return false;
        } else {
            for (DcRequest next : this.mPrioritizedDcRequests) {
                if (next != null && phoneIdForRequest(next.networkRequest) == i) {
                    return true;
                }
            }
        }
        return false;
    }
}
