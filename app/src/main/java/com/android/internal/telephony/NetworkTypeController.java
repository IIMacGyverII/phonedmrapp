package com.android.internal.telephony;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.PowerManager;
import android.telephony.CarrierConfigManager;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.PcoData;
import android.telephony.PhysicalChannelConfig;
import android.telephony.TelephonyDisplayInfo;
import android.telephony.TelephonyManager;
import android.telephony.data.ApnSetting;
import android.text.TextUtils;
import androidx.emoji2.text.ConcurrencyHelpers$$ExternalSyntheticLambda1;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.dataconnection.DataConnection;
import com.android.internal.telephony.dataconnection.DcTracker;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Pattern;
import java.util.stream.IntStream;

public class NetworkTypeController extends StateMachine {
    private static final String[] ALL_STATES = {STATE_CONNECTED_NR_ADVANCED, "connected", STATE_NOT_RESTRICTED_RRC_IDLE, STATE_NOT_RESTRICTED_RRC_CON, STATE_RESTRICTED, "legacy"};
    private static final boolean DBG = true;
    private static final int EVENT_BANDWIDTH_CHANGED = 15;
    private static final int EVENT_CARRIER_CONFIG_CHANGED = 7;
    protected static final int EVENT_DATA_RAT_CHANGED = 2;
    private static final int EVENT_DEVICE_IDLE_MODE_CHANGED = 17;
    private static final int EVENT_INITIALIZE = 12;
    private static final int EVENT_NR_FREQUENCY_CHANGED = 4;
    private static final int EVENT_NR_STATE_CHANGED = 3;
    private static final int EVENT_PCO_DATA_CHANGED = 14;
    private static final int EVENT_PHYSICAL_CHANNEL_CONFIG_CHANGED = 13;
    private static final int EVENT_PHYSICAL_CHANNEL_CONFIG_NOTIF_CHANGED = 6;
    private static final int EVENT_PHYSICAL_LINK_STATUS_CHANGED = 5;
    private static final int EVENT_PREFERRED_NETWORK_MODE_CHANGED = 11;
    private static final int EVENT_PRIMARY_TIMER_EXPIRED = 8;
    public static final int EVENT_QUIT = 1;
    private static final int EVENT_RADIO_OFF_OR_UNAVAILABLE = 10;
    private static final int EVENT_SECONDARY_TIMER_EXPIRED = 9;
    public static final int EVENT_UPDATE = 0;
    private static final int EVENT_UPDATE_NR_ADVANCED_STATE = 16;
    private static final String ICON_5G = "5g";
    private static final String ICON_5G_PLUS = "5g_plus";
    private static final String STATE_ANY = "any";
    private static final String STATE_CONNECTED = "connected";
    private static final String STATE_CONNECTED_NR_ADVANCED = "connected_mmwave";
    private static final String STATE_LEGACY = "legacy";
    private static final String STATE_NOT_RESTRICTED_RRC_CON = "not_restricted_rrc_con";
    private static final String STATE_NOT_RESTRICTED_RRC_IDLE = "not_restricted_rrc_idle";
    private static final String STATE_RESTRICTED = "restricted";
    private static final String TAG = "NetworkTypeController";
    private static final String[] sEvents;
    protected int[] mAdditionalNrAdvancedBandsList;
    private final DefaultState mDefaultState;
    private final DisplayInfoController mDisplayInfoController;
    private boolean mEnableNrAdvancedWhileRoaming = true;
    /* access modifiers changed from: private */
    public final IdleState mIdleState;
    private final BroadcastReceiver mIntentReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            action.hashCode();
            if (!action.equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                if (action.equals("android.os.action.DEVICE_IDLE_MODE_CHANGED")) {
                    NetworkTypeController.this.sendMessage(17);
                }
            } else if (intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1) == NetworkTypeController.this.mPhone.getPhoneId() && !intent.getBooleanExtra("android.telephony.extra.REBROADCAST_ON_UNLOCK", false)) {
                NetworkTypeController.this.sendMessage(7);
            }
        }
    };
    /* access modifiers changed from: private */
    public boolean mIsDeviceIdleMode = false;
    /* access modifiers changed from: private */
    public boolean mIsNrAdvancedAllowedByPco = false;
    private boolean mIsPhysicalChannelConfig16Supported;
    /* access modifiers changed from: private */
    public boolean mIsPhysicalChannelConfigOn;
    /* access modifiers changed from: private */
    public boolean mIsPrimaryTimerActive;
    /* access modifiers changed from: private */
    public boolean mIsSecondaryTimerActive;
    /* access modifiers changed from: private */
    public boolean mIsTimerResetEnabledForLegacyStateRRCIdle;
    private boolean mIsUsingUserDataForRrcDetection = false;
    /* access modifiers changed from: private */
    public final LegacyState mLegacyState;
    /* access modifiers changed from: private */
    public final LteConnectedState mLteConnectedState;
    private String mLteEnhancedPattern = "";
    private int mLtePlusThresholdBandwidth;
    /* access modifiers changed from: private */
    public int mNrAdvancedCapablePcoId = 0;
    private int mNrAdvancedThresholdBandwidth;
    /* access modifiers changed from: private */
    public final NrConnectedState mNrConnectedState;
    private int mOverrideNetworkType;
    private Map<String, OverrideTimerRule> mOverrideTimerRules = new HashMap();
    protected final Phone mPhone;
    /* access modifiers changed from: private */
    public int mPhysicalLinkStatus;
    /* access modifiers changed from: private */
    public String mPreviousState;
    /* access modifiers changed from: private */
    public String mPrimaryTimerState;
    /* access modifiers changed from: private */
    public String mSecondaryTimerState;

    /* access modifiers changed from: private */
    public boolean isLte(int i) {
        return i == 13 || i == 19;
    }

    /* access modifiers changed from: protected */
    public boolean mtkNeedUpdateNRStateForLegacyState() {
        return false;
    }

    static {
        String[] strArr = new String[18];
        sEvents = strArr;
        strArr[0] = "EVENT_UPDATE";
        strArr[1] = "EVENT_QUIT";
        strArr[2] = "EVENT_DATA_RAT_CHANGED";
        strArr[3] = "EVENT_NR_STATE_CHANGED";
        strArr[4] = "EVENT_NR_FREQUENCY_CHANGED";
        strArr[5] = "EVENT_PHYSICAL_LINK_STATUS_CHANGED";
        strArr[6] = "EVENT_PHYSICAL_CHANNEL_CONFIG_NOTIF_CHANGED";
        strArr[7] = "EVENT_CARRIER_CONFIG_CHANGED";
        strArr[8] = "EVENT_PRIMARY_TIMER_EXPIRED";
        strArr[9] = "EVENT_SECONDARY_TIMER_EXPIRED";
        strArr[10] = "EVENT_RADIO_OFF_OR_UNAVAILABLE";
        strArr[11] = "EVENT_PREFERRED_NETWORK_MODE_CHANGED";
        strArr[12] = "EVENT_INITIALIZE";
        strArr[13] = "EVENT_PHYSICAL_CHANNEL_CONFIG_CHANGED";
        strArr[14] = "EVENT_PCO_DATA_CHANGED";
        strArr[15] = "EVENT_BANDWIDTH_CHANGED";
        strArr[16] = "EVENT_UPDATE_NR_ADVANCED_STATE";
        strArr[17] = "EVENT_DEVICE_IDLE_MODE_CHANGED";
    }

    public NetworkTypeController(Phone phone, DisplayInfoController displayInfoController) {
        super(TAG, (Handler) displayInfoController);
        DefaultState defaultState = new DefaultState();
        this.mDefaultState = defaultState;
        LegacyState legacyState = new LegacyState();
        this.mLegacyState = legacyState;
        IdleState idleState = new IdleState();
        this.mIdleState = idleState;
        LteConnectedState lteConnectedState = new LteConnectedState();
        this.mLteConnectedState = lteConnectedState;
        NrConnectedState nrConnectedState = new NrConnectedState();
        this.mNrConnectedState = nrConnectedState;
        this.mPhone = phone;
        this.mDisplayInfoController = displayInfoController;
        this.mOverrideNetworkType = 0;
        this.mIsPhysicalChannelConfigOn = true;
        addState(defaultState);
        addState(legacyState, defaultState);
        addState(idleState, defaultState);
        addState(lteConnectedState, defaultState);
        addState(nrConnectedState, defaultState);
        setInitialState(defaultState);
        start();
        sendMessage(12);
    }

    public int getOverrideNetworkType() {
        return this.mOverrideNetworkType;
    }

    public boolean is5GHysteresisActive() {
        return this.mIsPrimaryTimerActive || this.mIsSecondaryTimerActive;
    }

    /* access modifiers changed from: protected */
    public void registerForAllEvents() {
        this.mPhone.registerForRadioOffOrNotAvailable(getHandler(), 10, (Object) null);
        this.mPhone.registerForPreferredNetworkTypeChanged(getHandler(), 11, (Object) null);
        this.mPhone.registerForPhysicalChannelConfig(getHandler(), 13, (Object) null);
        this.mPhone.getServiceStateTracker().registerForDataRegStateOrRatChanged(1, getHandler(), 2, (Object) null);
        this.mPhone.getServiceStateTracker().registerForBandwidthChanged(getHandler(), 15, (Object) null);
        this.mIsPhysicalChannelConfig16Supported = ((TelephonyManager) this.mPhone.getContext().getSystemService(TelephonyManager.class)).isRadioInterfaceCapabilitySupported("CAPABILITY_PHYSICAL_CHANNEL_CONFIG_1_6_SUPPORTED");
        this.mPhone.getServiceStateTracker().registerForNrStateChanged(getHandler(), 3, (Object) null);
        this.mPhone.getServiceStateTracker().registerForNrFrequencyChanged(getHandler(), 4, (Object) null);
        this.mPhone.getDeviceStateMonitor().registerForPhysicalChannelConfigNotifChanged(getHandler(), 6, (Object) null);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction("android.os.action.DEVICE_IDLE_MODE_CHANGED");
        this.mPhone.getContext().registerReceiver(this.mIntentReceiver, intentFilter, (String) null, this.mPhone);
        if (!this.mPhone.isUsingNewDataStack()) {
            this.mPhone.mCi.registerForPcoData(getHandler(), 14, (Object) null);
        }
    }

    /* access modifiers changed from: protected */
    public void unRegisterForAllEvents() {
        this.mPhone.unregisterForRadioOffOrNotAvailable(getHandler());
        this.mPhone.unregisterForPreferredNetworkTypeChanged(getHandler());
        this.mPhone.getServiceStateTracker().unregisterForDataRegStateOrRatChanged(1, getHandler());
        this.mPhone.getServiceStateTracker().unregisterForNrStateChanged(getHandler());
        this.mPhone.getServiceStateTracker().unregisterForNrFrequencyChanged(getHandler());
        this.mPhone.getDeviceStateMonitor().unregisterForPhysicalChannelConfigNotifChanged(getHandler());
        this.mPhone.getContext().unregisterReceiver(this.mIntentReceiver);
        if (!this.mPhone.isUsingNewDataStack()) {
            this.mPhone.mCi.unregisterForPcoData(getHandler());
        }
    }

    /* access modifiers changed from: private */
    public void parseCarrierConfigs() {
        PersistableBundle configForSubId;
        String string = CarrierConfigManager.getDefaultConfig().getString("5g_icon_configuration_string");
        String string2 = CarrierConfigManager.getDefaultConfig().getString("5g_icon_display_grace_period_string");
        String string3 = CarrierConfigManager.getDefaultConfig().getString("5g_icon_display_secondary_grace_period_string");
        this.mLteEnhancedPattern = CarrierConfigManager.getDefaultConfig().getString("show_carrier_data_icon_pattern_string");
        this.mIsTimerResetEnabledForLegacyStateRRCIdle = CarrierConfigManager.getDefaultConfig().getBoolean("nr_timers_reset_if_non_endc_and_rrc_idle_bool");
        this.mLtePlusThresholdBandwidth = CarrierConfigManager.getDefaultConfig().getInt("lte_plus_threshold_bandwidth_khz_int");
        this.mNrAdvancedThresholdBandwidth = CarrierConfigManager.getDefaultConfig().getInt("nr_advanced_threshold_bandwidth_khz_int");
        this.mEnableNrAdvancedWhileRoaming = CarrierConfigManager.getDefaultConfig().getBoolean("enable_nr_advanced_for_roaming_bool");
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (!(carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null)) {
            if (configForSubId.getString("5g_icon_configuration_string") != null) {
                string = configForSubId.getString("5g_icon_configuration_string");
            }
            if (configForSubId.getString("5g_icon_display_grace_period_string") != null) {
                string2 = configForSubId.getString("5g_icon_display_grace_period_string");
            }
            if (configForSubId.getString("5g_icon_display_secondary_grace_period_string") != null) {
                string3 = configForSubId.getString("5g_icon_display_secondary_grace_period_string");
            }
            if (configForSubId.getString("show_carrier_data_icon_pattern_string") != null) {
                this.mLteEnhancedPattern = configForSubId.getString("show_carrier_data_icon_pattern_string");
            }
            this.mIsTimerResetEnabledForLegacyStateRRCIdle = configForSubId.getBoolean("nr_timers_reset_if_non_endc_and_rrc_idle_bool");
            this.mLtePlusThresholdBandwidth = configForSubId.getInt("lte_plus_threshold_bandwidth_khz_int", this.mLtePlusThresholdBandwidth);
            this.mNrAdvancedThresholdBandwidth = configForSubId.getInt("nr_advanced_threshold_bandwidth_khz_int", this.mNrAdvancedThresholdBandwidth);
            this.mAdditionalNrAdvancedBandsList = configForSubId.getIntArray("additional_nr_advanced_bands_int_array");
            int i = configForSubId.getInt("nr_advanced_capable_pco_id_int");
            this.mNrAdvancedCapablePcoId = i;
            if (i > 0 && this.mPhone.isUsingNewDataStack()) {
                DataNetworkController dataNetworkController = this.mPhone.getDataNetworkController();
                Handler handler = getHandler();
                Objects.requireNonNull(handler);
                dataNetworkController.registerDataNetworkControllerCallback(new DataNetworkController.DataNetworkControllerCallback(new ConcurrencyHelpers$$ExternalSyntheticLambda1(handler)) {
                    public void onNrAdvancedCapableByPcoChanged(boolean z) {
                        NetworkTypeController networkTypeController = NetworkTypeController.this;
                        networkTypeController.log("mIsNrAdvancedAllowedByPco=" + z);
                        NetworkTypeController.this.mIsNrAdvancedAllowedByPco = z;
                        NetworkTypeController.this.sendMessage(16);
                    }
                });
            }
            this.mEnableNrAdvancedWhileRoaming = configForSubId.getBoolean("enable_nr_advanced_for_roaming_bool");
            boolean z = configForSubId.getBoolean("lte_endc_using_user_data_for_rrc_detection_bool");
            this.mIsUsingUserDataForRrcDetection = z;
            if (!this.mIsPhysicalChannelConfig16Supported || z) {
                if (this.mPhone.isUsingNewDataStack()) {
                    DataNetworkController dataNetworkController2 = this.mPhone.getDataNetworkController();
                    Handler handler2 = getHandler();
                    Objects.requireNonNull(handler2);
                    dataNetworkController2.registerDataNetworkControllerCallback(new DataNetworkController.DataNetworkControllerCallback(new ConcurrencyHelpers$$ExternalSyntheticLambda1(handler2)) {
                        public void onPhysicalLinkStatusChanged(int i) {
                            NetworkTypeController networkTypeController = NetworkTypeController.this;
                            networkTypeController.sendMessage(networkTypeController.obtainMessage(5, (Object) new AsyncResult((Object) null, Integer.valueOf(i), (Throwable) null)));
                        }
                    });
                } else {
                    this.mPhone.getDcTracker(1).registerForPhysicalLinkStatusChanged(getHandler(), 5);
                }
            }
        }
        createTimerRules(string, string2, string3);
    }

    private void createTimerRules(String str, String str2, String str3) {
        int i;
        HashMap hashMap = new HashMap();
        int i2 = 3;
        char c = 2;
        int i3 = 0;
        if (!TextUtils.isEmpty(str)) {
            for (String str4 : str.trim().split(",")) {
                String[] split = str4.trim().toLowerCase().split(":");
                if (split.length != 2) {
                    loge("Invalid 5G icon configuration, config = " + str4);
                } else {
                    if (split[1].equals(ICON_5G)) {
                        i = 3;
                    } else if (split[1].equals(ICON_5G_PLUS)) {
                        i = 5;
                    } else {
                        loge("Invalid 5G icon = " + split[1]);
                        i = 0;
                    }
                    String str5 = split[0];
                    hashMap.put(str5, new OverrideTimerRule(str5, i));
                }
            }
        }
        for (String str6 : ALL_STATES) {
            if (!hashMap.containsKey(str6)) {
                hashMap.put(str6, new OverrideTimerRule(str6, 0));
            }
        }
        if (!TextUtils.isEmpty(str2)) {
            String[] split2 = str2.trim().split(";");
            int length = split2.length;
            int i4 = 0;
            while (i4 < length) {
                String str7 = split2[i4];
                String[] split3 = str7.trim().toLowerCase().split(",");
                if (split3.length != i2) {
                    loge("Invalid 5G icon timer configuration, config = " + str7);
                } else {
                    try {
                        int parseInt = Integer.parseInt(split3[c]);
                        if (split3[i3].equals(STATE_ANY)) {
                            String[] strArr = ALL_STATES;
                            int length2 = strArr.length;
                            for (int i5 = i3; i5 < length2; i5++) {
                                ((OverrideTimerRule) hashMap.get(strArr[i5])).addTimer(split3[1], parseInt);
                            }
                        } else {
                            ((OverrideTimerRule) hashMap.get(split3[i3])).addTimer(split3[1], parseInt);
                        }
                    } catch (NumberFormatException unused) {
                    }
                }
                i4++;
                i2 = 3;
                c = 2;
                i3 = 0;
            }
        }
        if (!TextUtils.isEmpty(str3)) {
            for (String str8 : str3.trim().split(";")) {
                String[] split4 = str8.trim().toLowerCase().split(",");
                if (split4.length != 3) {
                    loge("Invalid 5G icon secondary timer configuration, config = " + str8);
                } else {
                    try {
                        int parseInt2 = Integer.parseInt(split4[2]);
                        if (split4[0].equals(STATE_ANY)) {
                            for (String str9 : ALL_STATES) {
                                ((OverrideTimerRule) hashMap.get(str9)).addSecondaryTimer(split4[1], parseInt2);
                            }
                        } else {
                            ((OverrideTimerRule) hashMap.get(split4[0])).addSecondaryTimer(split4[1], parseInt2);
                        }
                    } catch (NumberFormatException unused2) {
                    }
                }
            }
        }
        this.mOverrideTimerRules = hashMap;
        log("mOverrideTimerRules: " + this.mOverrideTimerRules);
    }

    /* access modifiers changed from: protected */
    public void updateOverrideNetworkType() {
        if (this.mIsPrimaryTimerActive || this.mIsSecondaryTimerActive) {
            log("Skip updating override network type since timer is active.");
            return;
        }
        this.mOverrideNetworkType = getCurrentOverrideNetworkType();
        this.mDisplayInfoController.updateTelephonyDisplayInfo();
    }

    /* access modifiers changed from: protected */
    public int getCurrentOverrideNetworkType() {
        int dataNetworkType = getDataNetworkType();
        boolean z = true;
        boolean z2 = isLte(dataNetworkType) && this.mPhone.getServiceState().getNrState() != 0;
        if (dataNetworkType != 20) {
            z = false;
        }
        if (this.mIsPhysicalChannelConfigOn && (z2 || z)) {
            int nrDisplayType = getNrDisplayType(z);
            if (nrDisplayType != 0 || z) {
                return nrDisplayType;
            }
            return getLteDisplayType();
        } else if (isLte(dataNetworkType)) {
            return getLteDisplayType();
        } else {
            return 0;
        }
    }

    private int getNrDisplayType(boolean z) {
        int i;
        if ((((long) this.mPhone.getCachedAllowedNetworkTypesBitmask()) & 524288) == 0) {
            return 0;
        }
        ArrayList<String> arrayList = new ArrayList<>();
        if (!z) {
            int nrState = this.mPhone.getServiceState().getNrState();
            if (nrState == 1) {
                arrayList.add(STATE_RESTRICTED);
            } else if (nrState == 2) {
                arrayList.add(isPhysicalLinkActive() ? STATE_NOT_RESTRICTED_RRC_CON : STATE_NOT_RESTRICTED_RRC_IDLE);
            } else if (nrState == 3) {
                if (isNrAdvanced()) {
                    arrayList.add(STATE_CONNECTED_NR_ADVANCED);
                }
                arrayList.add("connected");
            }
        } else if (isNrAdvanced()) {
            arrayList.add(STATE_CONNECTED_NR_ADVANCED);
        }
        for (String str : arrayList) {
            OverrideTimerRule overrideTimerRule = this.mOverrideTimerRules.get(str);
            if (overrideTimerRule != null && (i = overrideTimerRule.mOverrideType) != 0) {
                return i;
            }
        }
        return 0;
    }

    private int getLteDisplayType() {
        int i = ((getDataNetworkType() == 19 || isUsingLteCarrierAggregation()) && IntStream.of(this.mPhone.getServiceState().getCellBandwidths()).sum() > this.mLtePlusThresholdBandwidth) ? 1 : 0;
        if (isLteEnhancedAvailable()) {
            return 2;
        }
        return i;
    }

    private boolean isLteEnhancedAvailable() {
        if (TextUtils.isEmpty(this.mLteEnhancedPattern)) {
            return false;
        }
        Pattern compile = Pattern.compile(this.mLteEnhancedPattern);
        String[] strArr = {this.mPhone.getServiceState().getOperatorAlphaLongRaw(), this.mPhone.getServiceState().getOperatorAlphaShortRaw()};
        for (int i = 0; i < 2; i++) {
            String str = strArr[i];
            if (!TextUtils.isEmpty(str) && compile.matcher(str).find()) {
                return true;
            }
        }
        return false;
    }

    private final class DefaultState extends State {
        private DefaultState() {
        }

        public boolean processMessage(Message message) {
            NetworkTypeController networkTypeController = NetworkTypeController.this;
            networkTypeController.log("DefaultState: process " + NetworkTypeController.this.getEventName(message.what));
            switch (message.what) {
                case 0:
                case 11:
                    NetworkTypeController.this.log("Reset timers since preferred network mode changed.");
                    NetworkTypeController.this.resetAllTimers();
                    NetworkTypeController.this.transitionToCurrentState();
                    return true;
                case 1:
                    NetworkTypeController.this.log("Reset timers on state machine quitting.");
                    NetworkTypeController.this.resetAllTimers();
                    NetworkTypeController.this.unRegisterForAllEvents();
                    NetworkTypeController.this.quit();
                    return true;
                case 2:
                case 3:
                case 4:
                case 14:
                case 16:
                    return true;
                case 5:
                    NetworkTypeController.this.mPhysicalLinkStatus = ((Integer) ((AsyncResult) message.obj).result).intValue();
                    return true;
                case 6:
                    NetworkTypeController.this.mIsPhysicalChannelConfigOn = ((Boolean) ((AsyncResult) message.obj).result).booleanValue();
                    NetworkTypeController networkTypeController2 = NetworkTypeController.this;
                    networkTypeController2.log("mIsPhysicalChannelConfigOn changed to: " + NetworkTypeController.this.mIsPhysicalChannelConfigOn);
                    if (!NetworkTypeController.this.mIsPhysicalChannelConfigOn) {
                        NetworkTypeController.this.log("Reset timers since physical channel config indications are off.");
                        NetworkTypeController.this.resetAllTimers();
                    }
                    NetworkTypeController.this.transitionToCurrentState();
                    return true;
                case 7:
                    NetworkTypeController.this.parseCarrierConfigs();
                    NetworkTypeController.this.log("Reset timers since carrier configurations changed.");
                    NetworkTypeController.this.resetAllTimers();
                    NetworkTypeController.this.transitionToCurrentState();
                    return true;
                case 8:
                    NetworkTypeController networkTypeController3 = NetworkTypeController.this;
                    networkTypeController3.log("Primary timer expired for state: " + NetworkTypeController.this.mPrimaryTimerState);
                    NetworkTypeController.this.transitionWithSecondaryTimerTo((IState) message.obj);
                    return true;
                case 9:
                    NetworkTypeController networkTypeController4 = NetworkTypeController.this;
                    networkTypeController4.log("Secondary timer expired for state: " + NetworkTypeController.this.mSecondaryTimerState);
                    NetworkTypeController.this.mIsSecondaryTimerActive = false;
                    NetworkTypeController.this.mSecondaryTimerState = "";
                    NetworkTypeController.this.updateTimers();
                    NetworkTypeController.this.updateOverrideNetworkType();
                    return true;
                case 10:
                    NetworkTypeController.this.log("Reset timers since radio is off or unavailable.");
                    NetworkTypeController.this.resetAllTimers();
                    NetworkTypeController networkTypeController5 = NetworkTypeController.this;
                    networkTypeController5.transitionTo(networkTypeController5.mLegacyState);
                    return true;
                case 12:
                    NetworkTypeController.this.registerForAllEvents();
                    NetworkTypeController.this.parseCarrierConfigs();
                    return true;
                case 13:
                    if (!NetworkTypeController.this.isUsingPhysicalChannelConfigForRrcDetection()) {
                        return true;
                    }
                    NetworkTypeController networkTypeController6 = NetworkTypeController.this;
                    networkTypeController6.mPhysicalLinkStatus = networkTypeController6.getPhysicalLinkStatusFromPhysicalChannelConfig();
                    return true;
                case 15:
                    NetworkTypeController.this.updateOverrideNetworkType();
                    return true;
                case 17:
                    NetworkTypeController.this.mIsDeviceIdleMode = ((PowerManager) NetworkTypeController.this.mPhone.getContext().getSystemService(PowerManager.class)).isDeviceIdleMode();
                    NetworkTypeController networkTypeController7 = NetworkTypeController.this;
                    networkTypeController7.log("mIsDeviceIdleMode changed to: " + NetworkTypeController.this.mIsDeviceIdleMode);
                    if (NetworkTypeController.this.mIsDeviceIdleMode) {
                        NetworkTypeController.this.log("Reset timers since device is in idle mode.");
                        NetworkTypeController.this.resetAllTimers();
                    }
                    NetworkTypeController.this.transitionToCurrentState();
                    return true;
                default:
                    throw new RuntimeException("Received invalid event: " + message.what);
            }
        }
    }

    private final class LegacyState extends State {
        private boolean mIsNrRestricted;

        private LegacyState() {
            this.mIsNrRestricted = false;
        }

        public void enter() {
            NetworkTypeController.this.log("Entering LegacyState");
            NetworkTypeController.this.updateTimers();
            NetworkTypeController.this.updateOverrideNetworkType();
            if (!NetworkTypeController.this.mIsPrimaryTimerActive && !NetworkTypeController.this.mIsSecondaryTimerActive) {
                this.mIsNrRestricted = NetworkTypeController.this.isNrRestricted();
                NetworkTypeController.this.mPreviousState = getName();
            }
        }

        public boolean processMessage(Message message) {
            NetworkTypeController networkTypeController = NetworkTypeController.this;
            networkTypeController.log("LegacyState: process " + NetworkTypeController.this.getEventName(message.what));
            NetworkTypeController.this.updateTimers();
            int r0 = NetworkTypeController.this.getDataNetworkType();
            int i = message.what;
            if (i == 2) {
                if (r0 == 20 || (NetworkTypeController.this.isLte(r0) && NetworkTypeController.this.isNrConnected())) {
                    NetworkTypeController networkTypeController2 = NetworkTypeController.this;
                    networkTypeController2.transitionTo(networkTypeController2.mNrConnectedState);
                } else if (!NetworkTypeController.this.isLte(r0) || !NetworkTypeController.this.isNrNotRestricted()) {
                    if (!NetworkTypeController.this.isLte(r0)) {
                        NetworkTypeController.this.log("Reset timers since 2G and 3G don't need NR timers.");
                        NetworkTypeController.this.resetAllTimers();
                    }
                    NetworkTypeController.this.updateOverrideNetworkType();
                } else {
                    NetworkTypeController networkTypeController3 = NetworkTypeController.this;
                    networkTypeController3.transitionWithTimerTo(networkTypeController3.isPhysicalLinkActive() ? NetworkTypeController.this.mLteConnectedState : NetworkTypeController.this.mIdleState);
                }
                this.mIsNrRestricted = NetworkTypeController.this.isNrRestricted();
            } else if (i == 3) {
                if (NetworkTypeController.this.isNrConnected()) {
                    NetworkTypeController networkTypeController4 = NetworkTypeController.this;
                    networkTypeController4.transitionTo(networkTypeController4.mNrConnectedState);
                } else if (NetworkTypeController.this.isLte(r0) && NetworkTypeController.this.isNrNotRestricted()) {
                    NetworkTypeController networkTypeController5 = NetworkTypeController.this;
                    networkTypeController5.transitionWithTimerTo(networkTypeController5.isPhysicalLinkActive() ? NetworkTypeController.this.mLteConnectedState : NetworkTypeController.this.mIdleState);
                } else if (NetworkTypeController.this.isLte(r0) && (NetworkTypeController.this.isNrRestricted() || NetworkTypeController.this.mtkNeedUpdateNRStateForLegacyState())) {
                    NetworkTypeController.this.updateOverrideNetworkType();
                }
                this.mIsNrRestricted = NetworkTypeController.this.isNrRestricted();
            } else if (i != 4) {
                if (i == 5) {
                    NetworkTypeController.this.mPhysicalLinkStatus = ((Integer) ((AsyncResult) message.obj).result).intValue();
                    if (NetworkTypeController.this.mIsTimerResetEnabledForLegacyStateRRCIdle && !NetworkTypeController.this.isPhysicalLinkActive()) {
                        NetworkTypeController.this.log("Reset timers since timer reset is enabled for RRC idle.");
                        NetworkTypeController.this.resetAllTimers();
                        NetworkTypeController.this.updateOverrideNetworkType();
                    }
                } else if (i != 13) {
                    return false;
                } else {
                    if (NetworkTypeController.this.isUsingPhysicalChannelConfigForRrcDetection()) {
                        NetworkTypeController networkTypeController6 = NetworkTypeController.this;
                        networkTypeController6.mPhysicalLinkStatus = networkTypeController6.getPhysicalLinkStatusFromPhysicalChannelConfig();
                        if (NetworkTypeController.this.mIsTimerResetEnabledForLegacyStateRRCIdle && !NetworkTypeController.this.isPhysicalLinkActive()) {
                            NetworkTypeController.this.log("Reset timers since timer reset is enabled for RRC idle.");
                            NetworkTypeController.this.resetAllTimers();
                        }
                    }
                    NetworkTypeController.this.updateOverrideNetworkType();
                }
            }
            if (NetworkTypeController.this.mIsPrimaryTimerActive || NetworkTypeController.this.mIsSecondaryTimerActive) {
                return true;
            }
            NetworkTypeController.this.mPreviousState = getName();
            return true;
        }

        public String getName() {
            return this.mIsNrRestricted ? NetworkTypeController.STATE_RESTRICTED : "legacy";
        }
    }

    private final class IdleState extends State {
        public String getName() {
            return NetworkTypeController.STATE_NOT_RESTRICTED_RRC_IDLE;
        }

        private IdleState() {
        }

        public void enter() {
            NetworkTypeController.this.log("Entering IdleState");
            NetworkTypeController.this.updateTimers();
            NetworkTypeController.this.updateOverrideNetworkType();
            if (!NetworkTypeController.this.mIsPrimaryTimerActive && !NetworkTypeController.this.mIsSecondaryTimerActive) {
                NetworkTypeController.this.mPreviousState = getName();
            }
        }

        public boolean processMessage(Message message) {
            NetworkTypeController networkTypeController = NetworkTypeController.this;
            networkTypeController.log("IdleState: process " + NetworkTypeController.this.getEventName(message.what));
            NetworkTypeController.this.updateTimers();
            int i = message.what;
            if (i == 2) {
                int r5 = NetworkTypeController.this.getDataNetworkType();
                if (r5 == 20) {
                    NetworkTypeController networkTypeController2 = NetworkTypeController.this;
                    networkTypeController2.transitionTo(networkTypeController2.mNrConnectedState);
                } else if (!NetworkTypeController.this.isLte(r5) || !NetworkTypeController.this.isNrNotRestricted()) {
                    NetworkTypeController networkTypeController3 = NetworkTypeController.this;
                    networkTypeController3.transitionWithTimerTo(networkTypeController3.mLegacyState);
                }
            } else if (i != 3) {
                if (i != 4) {
                    if (i == 5) {
                        NetworkTypeController.this.mPhysicalLinkStatus = ((Integer) ((AsyncResult) message.obj).result).intValue();
                        if (!NetworkTypeController.this.isNrNotRestricted()) {
                            NetworkTypeController.this.log("NR state changed. Sending EVENT_NR_STATE_CHANGED");
                            NetworkTypeController.this.sendMessage(3);
                        } else if (NetworkTypeController.this.isPhysicalLinkActive()) {
                            NetworkTypeController networkTypeController4 = NetworkTypeController.this;
                            networkTypeController4.transitionWithTimerTo(networkTypeController4.mLteConnectedState);
                        }
                    } else if (i != 13) {
                        return false;
                    } else {
                        if (NetworkTypeController.this.isUsingPhysicalChannelConfigForRrcDetection()) {
                            NetworkTypeController networkTypeController5 = NetworkTypeController.this;
                            networkTypeController5.mPhysicalLinkStatus = networkTypeController5.getPhysicalLinkStatusFromPhysicalChannelConfig();
                            if (!NetworkTypeController.this.isNrNotRestricted()) {
                                NetworkTypeController.this.log("NR state changed. Sending EVENT_NR_STATE_CHANGED");
                                NetworkTypeController.this.sendMessage(3);
                            } else if (NetworkTypeController.this.isPhysicalLinkActive()) {
                                NetworkTypeController networkTypeController6 = NetworkTypeController.this;
                                networkTypeController6.transitionWithTimerTo(networkTypeController6.mLteConnectedState);
                            }
                        }
                        NetworkTypeController.this.updateOverrideNetworkType();
                    }
                }
            } else if (NetworkTypeController.this.isNrConnected()) {
                NetworkTypeController networkTypeController7 = NetworkTypeController.this;
                networkTypeController7.transitionTo(networkTypeController7.mNrConnectedState);
            } else if (!NetworkTypeController.this.isNrNotRestricted()) {
                NetworkTypeController networkTypeController8 = NetworkTypeController.this;
                networkTypeController8.transitionWithTimerTo(networkTypeController8.mLegacyState);
            }
            if (NetworkTypeController.this.mIsPrimaryTimerActive || NetworkTypeController.this.mIsSecondaryTimerActive) {
                return true;
            }
            NetworkTypeController.this.mPreviousState = getName();
            return true;
        }
    }

    private final class LteConnectedState extends State {
        public String getName() {
            return NetworkTypeController.STATE_NOT_RESTRICTED_RRC_CON;
        }

        private LteConnectedState() {
        }

        public void enter() {
            NetworkTypeController.this.log("Entering LteConnectedState");
            NetworkTypeController.this.updateTimers();
            NetworkTypeController.this.updateOverrideNetworkType();
            if (!NetworkTypeController.this.mIsPrimaryTimerActive && !NetworkTypeController.this.mIsSecondaryTimerActive) {
                NetworkTypeController.this.mPreviousState = getName();
            }
        }

        public boolean processMessage(Message message) {
            NetworkTypeController networkTypeController = NetworkTypeController.this;
            networkTypeController.log("LteConnectedState: process " + NetworkTypeController.this.getEventName(message.what));
            NetworkTypeController.this.updateTimers();
            int i = message.what;
            if (i == 2) {
                int r5 = NetworkTypeController.this.getDataNetworkType();
                if (r5 == 20) {
                    NetworkTypeController networkTypeController2 = NetworkTypeController.this;
                    networkTypeController2.transitionTo(networkTypeController2.mNrConnectedState);
                } else if (!NetworkTypeController.this.isLte(r5) || !NetworkTypeController.this.isNrNotRestricted()) {
                    NetworkTypeController networkTypeController3 = NetworkTypeController.this;
                    networkTypeController3.transitionWithTimerTo(networkTypeController3.mLegacyState);
                }
            } else if (i != 3) {
                if (i != 4) {
                    if (i == 5) {
                        NetworkTypeController.this.mPhysicalLinkStatus = ((Integer) ((AsyncResult) message.obj).result).intValue();
                        if (!NetworkTypeController.this.isNrNotRestricted()) {
                            NetworkTypeController.this.log("NR state changed. Sending EVENT_NR_STATE_CHANGED");
                            NetworkTypeController.this.sendMessage(3);
                        } else if (!NetworkTypeController.this.isPhysicalLinkActive()) {
                            NetworkTypeController networkTypeController4 = NetworkTypeController.this;
                            networkTypeController4.transitionWithTimerTo(networkTypeController4.mIdleState);
                        }
                    } else if (i != 13) {
                        return false;
                    } else {
                        if (NetworkTypeController.this.isUsingPhysicalChannelConfigForRrcDetection()) {
                            NetworkTypeController networkTypeController5 = NetworkTypeController.this;
                            networkTypeController5.mPhysicalLinkStatus = networkTypeController5.getPhysicalLinkStatusFromPhysicalChannelConfig();
                            if (!NetworkTypeController.this.isNrNotRestricted()) {
                                NetworkTypeController.this.log("NR state changed. Sending EVENT_NR_STATE_CHANGED");
                                NetworkTypeController.this.sendMessage(3);
                            } else if (!NetworkTypeController.this.isPhysicalLinkActive()) {
                                NetworkTypeController networkTypeController6 = NetworkTypeController.this;
                                networkTypeController6.transitionWithTimerTo(networkTypeController6.mIdleState);
                            }
                        }
                        NetworkTypeController.this.updateOverrideNetworkType();
                    }
                }
            } else if (NetworkTypeController.this.isNrConnected()) {
                NetworkTypeController networkTypeController7 = NetworkTypeController.this;
                networkTypeController7.transitionTo(networkTypeController7.mNrConnectedState);
            } else if (!NetworkTypeController.this.isNrNotRestricted()) {
                NetworkTypeController networkTypeController8 = NetworkTypeController.this;
                networkTypeController8.transitionWithTimerTo(networkTypeController8.mLegacyState);
            }
            if (NetworkTypeController.this.mIsPrimaryTimerActive || NetworkTypeController.this.mIsSecondaryTimerActive) {
                return true;
            }
            NetworkTypeController.this.mPreviousState = getName();
            return true;
        }
    }

    private final class NrConnectedState extends State {
        private boolean mIsNrAdvanced;

        private NrConnectedState() {
            this.mIsNrAdvanced = false;
        }

        public void enter() {
            NetworkTypeController networkTypeController = NetworkTypeController.this;
            networkTypeController.log("Entering NrConnectedState(" + getName() + ")");
            NetworkTypeController.this.updateTimers();
            NetworkTypeController.this.updateOverrideNetworkType();
            if (!NetworkTypeController.this.mIsPrimaryTimerActive && !NetworkTypeController.this.mIsSecondaryTimerActive) {
                this.mIsNrAdvanced = NetworkTypeController.this.isNrAdvanced();
                NetworkTypeController.this.mPreviousState = getName();
            }
        }

        public boolean processMessage(Message message) {
            NetworkTypeController networkTypeController = NetworkTypeController.this;
            networkTypeController.log("NrConnectedState(" + getName() + "): process " + NetworkTypeController.this.getEventName(message.what));
            NetworkTypeController.this.updateTimers();
            int r0 = NetworkTypeController.this.getDataNetworkType();
            int i = message.what;
            if (i != 2) {
                if (i != 3) {
                    if (i != 4) {
                        if (i != 5) {
                            switch (i) {
                                case 13:
                                    break;
                                case 14:
                                    handlePcoData((AsyncResult) message.obj);
                                    break;
                                case 15:
                                    updateNrAdvancedState();
                                    break;
                                case 16:
                                    updateNrAdvancedState();
                                    break;
                                default:
                                    return false;
                            }
                        } else {
                            NetworkTypeController.this.mPhysicalLinkStatus = ((Integer) ((AsyncResult) message.obj).result).intValue();
                            if (!NetworkTypeController.this.isNrConnected()) {
                                NetworkTypeController.this.log("NR state changed. Sending EVENT_NR_STATE_CHANGED");
                                NetworkTypeController.this.sendMessage(3);
                            }
                        }
                    }
                    if (NetworkTypeController.this.isUsingPhysicalChannelConfigForRrcDetection()) {
                        NetworkTypeController networkTypeController2 = NetworkTypeController.this;
                        networkTypeController2.mPhysicalLinkStatus = networkTypeController2.getPhysicalLinkStatusFromPhysicalChannelConfig();
                    }
                    updateNrAdvancedState();
                } else if (NetworkTypeController.this.isLte(r0) && NetworkTypeController.this.isNrNotRestricted()) {
                    NetworkTypeController networkTypeController3 = NetworkTypeController.this;
                    networkTypeController3.transitionWithTimerTo(networkTypeController3.isPhysicalLinkActive() ? NetworkTypeController.this.mLteConnectedState : NetworkTypeController.this.mIdleState);
                } else if (r0 != 20 && !NetworkTypeController.this.isNrConnected()) {
                    NetworkTypeController networkTypeController4 = NetworkTypeController.this;
                    networkTypeController4.transitionWithTimerTo(networkTypeController4.mLegacyState);
                }
            } else if (r0 == 20 || (NetworkTypeController.this.isLte(r0) && NetworkTypeController.this.isNrConnected())) {
                NetworkTypeController.this.updateOverrideNetworkType();
            } else if (!NetworkTypeController.this.isLte(r0) || !NetworkTypeController.this.isNrNotRestricted()) {
                NetworkTypeController networkTypeController5 = NetworkTypeController.this;
                networkTypeController5.transitionWithTimerTo(networkTypeController5.mLegacyState);
            } else {
                NetworkTypeController networkTypeController6 = NetworkTypeController.this;
                networkTypeController6.transitionWithTimerTo(networkTypeController6.isPhysicalLinkActive() ? NetworkTypeController.this.mLteConnectedState : NetworkTypeController.this.mIdleState);
            }
            if (NetworkTypeController.this.mIsPrimaryTimerActive || NetworkTypeController.this.mIsSecondaryTimerActive) {
                return true;
            }
            NetworkTypeController.this.mPreviousState = getName();
            return true;
        }

        public String getName() {
            return this.mIsNrAdvanced ? NetworkTypeController.STATE_CONNECTED_NR_ADVANCED : "connected";
        }

        private void updateNrAdvancedState() {
            if (!NetworkTypeController.this.isLte(NetworkTypeController.this.getDataNetworkType()) || NetworkTypeController.this.isNrConnected()) {
                if (!NetworkTypeController.this.isNrAdvanced()) {
                    NetworkTypeController.this.log("updateNrAdvancedState: CONNECTED_NR_ADVANCED -> CONNECTED");
                    NetworkTypeController networkTypeController = NetworkTypeController.this;
                    networkTypeController.transitionWithTimerTo(networkTypeController.mNrConnectedState);
                } else {
                    NetworkTypeController.this.log("updateNrAdvancedState: CONNECTED -> CONNECTED_NR_ADVANCED");
                    NetworkTypeController networkTypeController2 = NetworkTypeController.this;
                    networkTypeController2.transitionTo(networkTypeController2.mNrConnectedState);
                }
                this.mIsNrAdvanced = NetworkTypeController.this.isNrAdvanced();
                return;
            }
            NetworkTypeController.this.log("NR state changed. Sending EVENT_NR_STATE_CHANGED");
            NetworkTypeController.this.sendMessage(3);
        }

        private void handlePcoData(AsyncResult asyncResult) {
            if (asyncResult.exception != null) {
                NetworkTypeController networkTypeController = NetworkTypeController.this;
                networkTypeController.loge("PCO_DATA exception: " + asyncResult.exception);
                return;
            }
            PcoData pcoData = (PcoData) asyncResult.result;
            if (pcoData != null) {
                NetworkTypeController networkTypeController2 = NetworkTypeController.this;
                networkTypeController2.log("EVENT_PCO_DATA_CHANGED: pco data: " + pcoData);
                boolean z = true;
                DcTracker dcTracker = NetworkTypeController.this.mPhone.getDcTracker(1);
                ApnSetting apnSetting = null;
                DataConnection dataConnectionByContextId = dcTracker != null ? dcTracker.getDataConnectionByContextId(pcoData.cid) : null;
                if (dataConnectionByContextId != null) {
                    apnSetting = dataConnectionByContextId.getApnSetting();
                }
                if (apnSetting != null && apnSetting.canHandleType(17) && NetworkTypeController.this.mNrAdvancedCapablePcoId > 0 && pcoData.pcoId == NetworkTypeController.this.mNrAdvancedCapablePcoId) {
                    NetworkTypeController networkTypeController3 = NetworkTypeController.this;
                    networkTypeController3.log("EVENT_PCO_DATA_CHANGED: NR_ADVANCED is allowed by PCO. length:" + pcoData.contents.length + ",value: " + Arrays.toString(pcoData.contents));
                    NetworkTypeController networkTypeController4 = NetworkTypeController.this;
                    byte[] bArr = pcoData.contents;
                    if (bArr.length <= 0 || bArr[bArr.length - 1] != 1) {
                        z = false;
                    }
                    networkTypeController4.mIsNrAdvancedAllowedByPco = z;
                    updateNrAdvancedState();
                }
            }
        }
    }

    /* access modifiers changed from: private */
    public void transitionWithTimerTo(IState iState) {
        String name = iState.getName();
        log("Transition with primary timer from " + this.mPreviousState + " to " + name);
        OverrideTimerRule overrideTimerRule = this.mOverrideTimerRules.get(this.mPreviousState);
        if (!this.mIsDeviceIdleMode && overrideTimerRule != null && overrideTimerRule.getTimer(name) > 0) {
            int timer = overrideTimerRule.getTimer(name);
            log(timer + "s primary timer started for state: " + this.mPreviousState);
            this.mPrimaryTimerState = this.mPreviousState;
            this.mPreviousState = getCurrentState().getName();
            this.mIsPrimaryTimerActive = true;
            sendMessageDelayed(8, (Object) iState, ((long) timer) * 1000);
        }
        transitionTo(iState);
    }

    /* access modifiers changed from: private */
    public void transitionWithSecondaryTimerTo(IState iState) {
        String name = getCurrentState().getName();
        OverrideTimerRule overrideTimerRule = this.mOverrideTimerRules.get(this.mPrimaryTimerState);
        log("Transition with secondary timer from " + name + " to " + iState.getName());
        if (!this.mIsDeviceIdleMode && overrideTimerRule != null && overrideTimerRule.getSecondaryTimer(name) > 0) {
            int secondaryTimer = overrideTimerRule.getSecondaryTimer(name);
            log(secondaryTimer + "s secondary timer started for state: " + name);
            this.mSecondaryTimerState = name;
            this.mPreviousState = name;
            this.mIsSecondaryTimerActive = true;
            sendMessageDelayed(9, (Object) iState, ((long) secondaryTimer) * 1000);
        }
        this.mIsPrimaryTimerActive = false;
        transitionTo(getCurrentState());
    }

    /* access modifiers changed from: private */
    public void transitionToCurrentState() {
        IState iState;
        int dataNetworkType = getDataNetworkType();
        if (dataNetworkType == 20 || isNrConnected()) {
            iState = this.mNrConnectedState;
            this.mPreviousState = isNrAdvanced() ? STATE_CONNECTED_NR_ADVANCED : "connected";
        } else if (!isLte(dataNetworkType) || !isNrNotRestricted()) {
            iState = this.mLegacyState;
            this.mPreviousState = isNrRestricted() ? STATE_RESTRICTED : "legacy";
        } else if (isPhysicalLinkActive()) {
            iState = this.mLteConnectedState;
            this.mPreviousState = STATE_NOT_RESTRICTED_RRC_CON;
        } else {
            iState = this.mIdleState;
            this.mPreviousState = STATE_NOT_RESTRICTED_RRC_IDLE;
        }
        if (!iState.equals(getCurrentState())) {
            transitionTo(iState);
        } else {
            updateOverrideNetworkType();
        }
    }

    /* access modifiers changed from: private */
    public void updateTimers() {
        if ((((long) this.mPhone.getCachedAllowedNetworkTypesBitmask()) & 524288) == 0) {
            log("Reset timers since NR is not allowed.");
            resetAllTimers();
            return;
        }
        String name = getCurrentState().getName();
        if (this.mIsPrimaryTimerActive && getOverrideNetworkType() == getCurrentOverrideNetworkType()) {
            log("Remove primary timer since icon of primary state and current icon equal: " + this.mPrimaryTimerState);
            removeMessages(8);
            this.mIsPrimaryTimerActive = false;
            this.mPrimaryTimerState = "";
        }
        if (this.mIsSecondaryTimerActive && !this.mSecondaryTimerState.equals(name)) {
            log("Remove secondary timer since current state (" + name + ") is no longer secondary timer state (" + this.mSecondaryTimerState + ").");
            removeMessages(9);
            this.mIsSecondaryTimerActive = false;
            this.mSecondaryTimerState = "";
        }
        if (this.mIsPrimaryTimerActive || this.mIsSecondaryTimerActive) {
            if (name.equals(STATE_CONNECTED_NR_ADVANCED)) {
                log("Reset timers since state is NR_ADVANCED.");
                resetAllTimers();
            }
            int dataNetworkType = getDataNetworkType();
            if (!isLte(dataNetworkType) && dataNetworkType != 20) {
                log("Reset timers since 2G and 3G don't need NR timers.");
                resetAllTimers();
            }
        }
    }

    /* access modifiers changed from: private */
    public void resetAllTimers() {
        removeMessages(8);
        removeMessages(9);
        this.mIsPrimaryTimerActive = false;
        this.mIsSecondaryTimerActive = false;
        this.mPrimaryTimerState = "";
        this.mSecondaryTimerState = "";
    }

    private static class OverrideTimerRule {
        final int mOverrideType;
        final Map<String, Integer> mPrimaryTimers = new HashMap();
        final Map<String, Integer> mSecondaryTimers = new HashMap();
        final String mState;

        OverrideTimerRule(String str, int i) {
            this.mState = str;
            this.mOverrideType = i;
        }

        public void addTimer(String str, int i) {
            this.mPrimaryTimers.put(str, Integer.valueOf(i));
        }

        public void addSecondaryTimer(String str, int i) {
            this.mSecondaryTimers.put(str, Integer.valueOf(i));
        }

        public int getTimer(String str) {
            Integer num = this.mPrimaryTimers.get(str);
            if (num == null) {
                num = this.mPrimaryTimers.get(NetworkTypeController.STATE_ANY);
            }
            if (num == null) {
                return 0;
            }
            return num.intValue();
        }

        public int getSecondaryTimer(String str) {
            Integer num = this.mSecondaryTimers.get(str);
            if (num == null) {
                num = this.mSecondaryTimers.get(NetworkTypeController.STATE_ANY);
            }
            if (num == null) {
                return 0;
            }
            return num.intValue();
        }

        public String toString() {
            return "{mState=" + this.mState + ", mOverrideType=" + TelephonyDisplayInfo.overrideNetworkTypeToString(this.mOverrideType) + ", mPrimaryTimers=" + this.mPrimaryTimers + ", mSecondaryTimers=" + this.mSecondaryTimers + "}";
        }
    }

    /* access modifiers changed from: private */
    public boolean isNrConnected() {
        return this.mPhone.getServiceState().getNrState() == 3;
    }

    /* access modifiers changed from: private */
    public boolean isNrNotRestricted() {
        return this.mPhone.getServiceState().getNrState() == 2;
    }

    /* access modifiers changed from: private */
    public boolean isNrRestricted() {
        return this.mPhone.getServiceState().getNrState() == 1;
    }

    /* access modifiers changed from: private */
    public boolean isNrAdvanced() {
        if (this.mNrAdvancedCapablePcoId > 0 && !this.mIsNrAdvancedAllowedByPco) {
            return false;
        }
        if (this.mPhone.getServiceState().getDataRoaming() && !this.mEnableNrAdvancedWhileRoaming) {
            return false;
        }
        if (this.mNrAdvancedThresholdBandwidth > 0 && IntStream.of(this.mPhone.getServiceState().getCellBandwidths()).sum() < this.mNrAdvancedThresholdBandwidth) {
            return false;
        }
        if (isNrMmwave() || isAdditionalNrAdvancedBand()) {
            return true;
        }
        return false;
    }

    private boolean isNrMmwave() {
        return this.mPhone.getServiceState().getNrFrequencyRange() == 4;
    }

    /* access modifiers changed from: protected */
    public boolean isAdditionalNrAdvancedBand() {
        List<PhysicalChannelConfig> physicalChannelConfigList = this.mPhone.getServiceStateTracker().getPhysicalChannelConfigList();
        if (!ArrayUtils.isEmpty(this.mAdditionalNrAdvancedBandsList) && physicalChannelConfigList != null) {
            for (PhysicalChannelConfig next : physicalChannelConfigList) {
                if (next.getNetworkType() == 20 && ArrayUtils.contains(this.mAdditionalNrAdvancedBandsList, next.getBand())) {
                    return true;
                }
            }
        }
        return false;
    }

    /* access modifiers changed from: private */
    public boolean isPhysicalLinkActive() {
        return this.mPhysicalLinkStatus == 2;
    }

    /* access modifiers changed from: private */
    public int getPhysicalLinkStatusFromPhysicalChannelConfig() {
        List<PhysicalChannelConfig> physicalChannelConfigList = this.mPhone.getServiceStateTracker().getPhysicalChannelConfigList();
        return (physicalChannelConfigList == null || physicalChannelConfigList.isEmpty()) ? 1 : 2;
    }

    /* access modifiers changed from: private */
    public int getDataNetworkType() {
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceState().getNetworkRegistrationInfo(2, 1);
        if (networkRegistrationInfo == null) {
            return 0;
        }
        return networkRegistrationInfo.getAccessNetworkTechnology();
    }

    /* access modifiers changed from: private */
    public String getEventName(int i) {
        try {
            return sEvents[i];
        } catch (ArrayIndexOutOfBoundsException unused) {
            return "EVENT_NOT_DEFINED";
        }
    }

    /* access modifiers changed from: private */
    public boolean isUsingPhysicalChannelConfigForRrcDetection() {
        return this.mIsPhysicalChannelConfig16Supported && !this.mIsUsingUserDataForRrcDetection;
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Rlog.d(TAG, "[" + this.mPhone.getPhoneId() + "] " + str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(TAG, "[" + this.mPhone.getPhoneId() + "] " + str);
    }

    public String toString() {
        return "mOverrideTimerRules=" + this.mOverrideTimerRules.toString() + ", mLteEnhancedPattern=" + this.mLteEnhancedPattern + ", mIsPhysicalChannelConfigOn=" + this.mIsPhysicalChannelConfigOn + ", mIsPrimaryTimerActive=" + this.mIsPrimaryTimerActive + ", mIsSecondaryTimerActive=" + this.mIsSecondaryTimerActive + ", mPrimaryTimerState=" + this.mPrimaryTimerState + ", mSecondaryTimerState=" + this.mSecondaryTimerState + ", mPreviousState=" + this.mPreviousState + ", mIsNrAdvanced=" + isNrAdvanced();
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, " ");
        indentingPrintWriter.print("NetworkTypeController: ");
        super.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.flush();
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("mSubId=" + this.mPhone.getSubId());
        indentingPrintWriter.println("mOverrideTimerRules=" + this.mOverrideTimerRules.toString());
        indentingPrintWriter.println("mLteEnhancedPattern=" + this.mLteEnhancedPattern);
        indentingPrintWriter.println("mIsPhysicalChannelConfigOn=" + this.mIsPhysicalChannelConfigOn);
        indentingPrintWriter.println("mIsPrimaryTimerActive=" + this.mIsPrimaryTimerActive);
        indentingPrintWriter.println("mIsSecondaryTimerActive=" + this.mIsSecondaryTimerActive);
        indentingPrintWriter.println("mIsTimerRestEnabledForLegacyStateRRCIdle=" + this.mIsTimerResetEnabledForLegacyStateRRCIdle);
        indentingPrintWriter.println("mLtePlusThresholdBandwidth=" + this.mLtePlusThresholdBandwidth);
        indentingPrintWriter.println("mNrAdvancedThresholdBandwidth=" + this.mNrAdvancedThresholdBandwidth);
        indentingPrintWriter.println("mPrimaryTimerState=" + this.mPrimaryTimerState);
        indentingPrintWriter.println("mSecondaryTimerState=" + this.mSecondaryTimerState);
        indentingPrintWriter.println("mPreviousState=" + this.mPreviousState);
        indentingPrintWriter.println("mPhysicalLinkStatus=" + this.mPhysicalLinkStatus);
        indentingPrintWriter.println("mAdditionalNrAdvancedBandsList=" + Arrays.toString(this.mAdditionalNrAdvancedBandsList));
        indentingPrintWriter.println("mIsPhysicalChannelConfig16Supported=" + this.mIsPhysicalChannelConfig16Supported);
        indentingPrintWriter.println("mIsNrAdvancedAllowedByPco=" + this.mIsNrAdvancedAllowedByPco);
        indentingPrintWriter.println("mNrAdvancedCapablePcoId=" + this.mNrAdvancedCapablePcoId);
        indentingPrintWriter.println("mIsUsingUserDataForRrcDetection=" + this.mIsUsingUserDataForRrcDetection);
        indentingPrintWriter.println("mEnableNrAdvancedWhileRoaming=" + this.mEnableNrAdvancedWhileRoaming);
        indentingPrintWriter.println("mIsDeviceIdleMode=" + this.mIsDeviceIdleMode);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.flush();
    }

    /* access modifiers changed from: protected */
    public boolean isUsingLteCarrierAggregation() {
        return this.mPhone.getServiceState().isUsingCarrierAggregation();
    }
}
