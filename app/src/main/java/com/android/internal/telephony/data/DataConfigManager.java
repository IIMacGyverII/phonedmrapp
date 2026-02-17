package com.android.internal.telephony.data;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.provider.DeviceConfig;
import android.telephony.CarrierConfigManager;
import android.telephony.ServiceState;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyDisplayInfo;
import android.text.TextUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.data.DataNetwork;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.internal.telephony.data.DataRetryManager;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class DataConfigManager extends Handler {
    private static final String BANDWIDTH_SOURCE_BANDWIDTH_ESTIMATOR_STRING_VALUE = "bandwidth_estimator";
    private static final String BANDWIDTH_SOURCE_CARRIER_CONFIG_STRING_VALUE = "carrier_config";
    private static final String BANDWIDTH_SOURCE_MODEM_STRING_VALUE = "modem";
    private static final String DATA_CONFIG_NETWORK_TYPE_1xRTT = "1xRTT";
    private static final String DATA_CONFIG_NETWORK_TYPE_CDMA = "CDMA";
    private static final String DATA_CONFIG_NETWORK_TYPE_EDGE = "EDGE";
    private static final String DATA_CONFIG_NETWORK_TYPE_EHRPD = "eHRPD";
    private static final String DATA_CONFIG_NETWORK_TYPE_EVDO_0 = "EvDo_0";
    private static final String DATA_CONFIG_NETWORK_TYPE_EVDO_A = "EvDo_A";
    private static final String DATA_CONFIG_NETWORK_TYPE_EVDO_B = "EvDo_B";
    private static final String DATA_CONFIG_NETWORK_TYPE_GPRS = "GPRS";
    private static final String DATA_CONFIG_NETWORK_TYPE_GSM = "GSM";
    private static final String DATA_CONFIG_NETWORK_TYPE_HSDPA = "HSDPA";
    private static final String DATA_CONFIG_NETWORK_TYPE_HSPA = "HSPA";
    private static final String DATA_CONFIG_NETWORK_TYPE_HSPAP = "HSPA+";
    private static final String DATA_CONFIG_NETWORK_TYPE_HSUPA = "HSUPA";
    private static final String DATA_CONFIG_NETWORK_TYPE_IDEN = "iDEN";
    private static final String DATA_CONFIG_NETWORK_TYPE_IWLAN = "IWLAN";
    public static final String DATA_CONFIG_NETWORK_TYPE_LTE = "LTE";
    private static final String DATA_CONFIG_NETWORK_TYPE_LTE_CA = "LTE_CA";
    public static final String DATA_CONFIG_NETWORK_TYPE_NR_NSA = "NR_NSA";
    public static final String DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE = "NR_NSA_MMWAVE";
    private static final String DATA_CONFIG_NETWORK_TYPE_NR_SA = "NR_SA";
    private static final String DATA_CONFIG_NETWORK_TYPE_NR_SA_MMWAVE = "NR_SA_MMWAVE";
    private static final String DATA_CONFIG_NETWORK_TYPE_TD_SCDMA = "TD_SCDMA";
    private static final String DATA_CONFIG_NETWORK_TYPE_UMTS = "UMTS";
    private static final int DEFAULT_BANDWIDTH = 14;
    private static final int DEFAULT_NETWORK_TRANSIT_STATE_TIMEOUT_MS = 300000;
    private static final int EVENT_CARRIER_CONFIG_CHANGED = 1;
    private static final int EVENT_DEVICE_CONFIG_CHANGED = 2;
    private static final String KEY_ANOMALY_IMS_RELEASE_REQUEST = "anomaly_ims_release_request";
    private static final String KEY_ANOMALY_NETWORK_CONNECTING_TIMEOUT = "anomaly_network_connecting_timeout";
    private static final String KEY_ANOMALY_NETWORK_DISCONNECTING_TIMEOUT = "anomaly_network_disconnecting_timeout";
    private static final String KEY_ANOMALY_NETWORK_HANDOVER_TIMEOUT = "anomaly_network_handover_timeout";
    private static final String KEY_ANOMALY_NETWORK_UNWANTED = "anomaly_network_unwanted";
    private static final String KEY_ANOMALY_SETUP_DATA_CALL_FAILURE = "anomaly_setup_data_call_failure";
    private final Map<String, DataNetwork.NetworkBandwidth> mBandwidthMap = new ConcurrentHashMap();
    private PersistableBundle mCarrierConfig = null;
    private final CarrierConfigManager mCarrierConfigManager;
    private final RegistrantList mConfigUpdateRegistrants;
    private final List<DataRetryManager.DataHandoverRetryRule> mDataHandoverRetryRules = new ArrayList();
    private final List<DataRetryManager.DataSetupRetryRule> mDataSetupRetryRules = new ArrayList();
    private final List<DataNetworkController.HandoverRule> mHandoverRuleList = new ArrayList();
    private EventFrequency mImsReleaseRequestAnomalyReportThreshold;
    protected final String mLogTag;
    private final Set<Integer> mMeteredApnTypes = new HashSet();
    private final Map<Integer, Integer> mNetworkCapabilityPriorityMap = new ConcurrentHashMap();
    private int mNetworkConnectingTimeout;
    private int mNetworkDisconnectingTimeout;
    private int mNetworkHandoverTimeout;
    private EventFrequency mNetworkUnwantedAnomalyReportThreshold;
    protected final Phone mPhone;
    private Resources mResources = null;
    private final Set<Integer> mRoamingMeteredApnTypes = new HashSet();
    private final Set<String> mRoamingUnmeteredNetworkTypes = new HashSet();
    private EventFrequency mSetupDataCallAnomalyReportThreshold;
    private final List<Integer> mSingleDataNetworkTypeList = new ArrayList();
    private final Map<String, String> mTcpBufferSizeMap = new ConcurrentHashMap();
    private final Set<String> mUnmeteredNetworkTypes = new HashSet();

    @Retention(RetentionPolicy.SOURCE)
    private @interface DataConfigNetworkType {
    }

    private static String networkTypeToDataConfigNetworkType(int i) {
        switch (i) {
            case 1:
                return DATA_CONFIG_NETWORK_TYPE_GPRS;
            case 2:
                return DATA_CONFIG_NETWORK_TYPE_EDGE;
            case 3:
                return DATA_CONFIG_NETWORK_TYPE_UMTS;
            case 4:
                return DATA_CONFIG_NETWORK_TYPE_CDMA;
            case 5:
                return DATA_CONFIG_NETWORK_TYPE_EVDO_0;
            case 6:
                return DATA_CONFIG_NETWORK_TYPE_EVDO_A;
            case 7:
                return DATA_CONFIG_NETWORK_TYPE_1xRTT;
            case 8:
                return DATA_CONFIG_NETWORK_TYPE_HSDPA;
            case 9:
                return DATA_CONFIG_NETWORK_TYPE_HSUPA;
            case 10:
                return DATA_CONFIG_NETWORK_TYPE_HSPA;
            case 11:
                return DATA_CONFIG_NETWORK_TYPE_IDEN;
            case 12:
                return DATA_CONFIG_NETWORK_TYPE_EVDO_B;
            case 13:
                return DATA_CONFIG_NETWORK_TYPE_LTE;
            case 14:
                return DATA_CONFIG_NETWORK_TYPE_EHRPD;
            case 15:
                return DATA_CONFIG_NETWORK_TYPE_HSPAP;
            case 16:
                return DATA_CONFIG_NETWORK_TYPE_GSM;
            case 17:
                return DATA_CONFIG_NETWORK_TYPE_TD_SCDMA;
            case 18:
                return DATA_CONFIG_NETWORK_TYPE_IWLAN;
            case 19:
                return DATA_CONFIG_NETWORK_TYPE_LTE_CA;
            case 20:
                return DATA_CONFIG_NETWORK_TYPE_NR_SA;
            default:
                return "";
        }
    }

    /* access modifiers changed from: protected */
    public void updateMtkExtendConfig(PersistableBundle persistableBundle) {
    }

    public DataConfigManager(Phone phone, Looper looper) {
        super(looper);
        RegistrantList registrantList = new RegistrantList();
        this.mConfigUpdateRegistrants = registrantList;
        this.mPhone = phone;
        this.mLogTag = "DCM-" + phone.getPhoneId();
        log("DataConfigManager created.");
        this.mCarrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService(CarrierConfigManager.class);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        phone.getContext().registerReceiver(new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals("android.telephony.action.CARRIER_CONFIG_CHANGED") && DataConfigManager.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1)) {
                    DataConfigManager.this.sendEmptyMessage(1);
                }
            }
        }, intentFilter, (String) null, phone);
        DeviceConfig.addOnPropertiesChangedListener("telephony", new DataConfigManager$$ExternalSyntheticLambda10(this), new DataConfigManager$$ExternalSyntheticLambda11(this));
        updateCarrierConfig();
        updateDeviceConfig();
        registrantList.notifyRegistrants();
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$new$0(DeviceConfig.Properties properties) {
        if (TextUtils.equals("telephony", properties.getNamespace())) {
            sendEmptyMessage(2);
        }
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            log("EVENT_CARRIER_CONFIG_CHANGED");
            updateCarrierConfig();
            this.mConfigUpdateRegistrants.notifyRegistrants();
        } else if (i != 2) {
            loge("Unexpected message " + message.what);
        } else {
            log("EVENT_DEVICE_CONFIG_CHANGED");
            updateDeviceConfig();
            this.mConfigUpdateRegistrants.notifyRegistrants();
        }
    }

    private void updateDeviceConfig() {
        DeviceConfig.Properties properties = DeviceConfig.getProperties("telephony", new String[0]);
        this.mImsReleaseRequestAnomalyReportThreshold = parseSlidingWindowCounterThreshold(properties.getString(KEY_ANOMALY_IMS_RELEASE_REQUEST, (String) null), 0, 12);
        this.mNetworkUnwantedAnomalyReportThreshold = parseSlidingWindowCounterThreshold(properties.getString(KEY_ANOMALY_NETWORK_UNWANTED, (String) null), 0, 12);
        this.mSetupDataCallAnomalyReportThreshold = parseSlidingWindowCounterThreshold(properties.getString(KEY_ANOMALY_SETUP_DATA_CALL_FAILURE, (String) null), 0, 2);
        this.mNetworkConnectingTimeout = properties.getInt(KEY_ANOMALY_NETWORK_CONNECTING_TIMEOUT, DEFAULT_NETWORK_TRANSIT_STATE_TIMEOUT_MS);
        this.mNetworkDisconnectingTimeout = properties.getInt(KEY_ANOMALY_NETWORK_DISCONNECTING_TIMEOUT, DEFAULT_NETWORK_TRANSIT_STATE_TIMEOUT_MS);
        this.mNetworkHandoverTimeout = properties.getInt(KEY_ANOMALY_NETWORK_HANDOVER_TIMEOUT, DEFAULT_NETWORK_TRANSIT_STATE_TIMEOUT_MS);
    }

    public boolean isConfigCarrierSpecific() {
        return this.mCarrierConfig.getBoolean("carrier_config_applied_bool");
    }

    private void updateCarrierConfig() {
        CarrierConfigManager carrierConfigManager = this.mCarrierConfigManager;
        if (carrierConfigManager != null) {
            this.mCarrierConfig = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
        }
        if (this.mCarrierConfig == null) {
            this.mCarrierConfig = CarrierConfigManager.getDefaultConfig();
        }
        this.mResources = SubscriptionManager.getResourcesForSubId(this.mPhone.getContext(), this.mPhone.getSubId());
        updateNetworkCapabilityPriority();
        updateDataRetryRules();
        updateMeteredApnTypes();
        updateSingleDataNetworkTypeList();
        updateUnmeteredNetworkTypes();
        updateBandwidths();
        updateTcpBuffers();
        updateHandoverRules();
        updateMtkExtendConfig(this.mCarrierConfig);
        StringBuilder sb = new StringBuilder();
        sb.append("Data config updated. Config is ");
        sb.append(isConfigCarrierSpecific() ? "" : "not ");
        sb.append("carrier specific.");
        log(sb.toString());
    }

    private void updateNetworkCapabilityPriority() {
        synchronized (this) {
            this.mNetworkCapabilityPriorityMap.clear();
            String[] stringArray = this.mCarrierConfig.getStringArray("telephony_network_capability_priorities_string_array");
            if (stringArray != null) {
                for (String trim : stringArray) {
                    String upperCase = trim.trim().toUpperCase();
                    String[] split = upperCase.split(":");
                    if (split.length != 2) {
                        loge("Invalid config \"" + upperCase + "\"");
                    } else {
                        int networkCapabilityFromString = DataUtils.getNetworkCapabilityFromString(split[0]);
                        if (networkCapabilityFromString < 0) {
                            loge("Invalid config \"" + upperCase + "\"");
                        } else {
                            this.mNetworkCapabilityPriorityMap.put(Integer.valueOf(networkCapabilityFromString), Integer.valueOf(Integer.parseInt(split[1])));
                        }
                    }
                }
            }
        }
    }

    public int getNetworkCapabilityPriority(int i) {
        if (this.mNetworkCapabilityPriorityMap.containsKey(Integer.valueOf(i))) {
            return this.mNetworkCapabilityPriorityMap.get(Integer.valueOf(i)).intValue();
        }
        return 0;
    }

    private void updateDataRetryRules() {
        synchronized (this) {
            this.mDataSetupRetryRules.clear();
            String[] stringArray = this.mCarrierConfig.getStringArray("telephony_data_setup_retry_rules_string_array");
            if (stringArray != null) {
                for (String dataSetupRetryRule : stringArray) {
                    try {
                        this.mDataSetupRetryRules.add(new DataRetryManager.DataSetupRetryRule(dataSetupRetryRule));
                    } catch (IllegalArgumentException e) {
                        loge("updateDataRetryRules: " + e.getMessage());
                    }
                }
            }
            this.mDataHandoverRetryRules.clear();
            String[] stringArray2 = this.mCarrierConfig.getStringArray("telephony_data_handover_retry_rules_string_array");
            if (stringArray2 != null) {
                for (String dataHandoverRetryRule : stringArray2) {
                    try {
                        this.mDataHandoverRetryRules.add(new DataRetryManager.DataHandoverRetryRule(dataHandoverRetryRule));
                    } catch (IllegalArgumentException e2) {
                        loge("updateDataRetryRules: " + e2.getMessage());
                    }
                }
            }
        }
    }

    public List<DataRetryManager.DataSetupRetryRule> getDataSetupRetryRules() {
        return Collections.unmodifiableList(this.mDataSetupRetryRules);
    }

    public List<DataRetryManager.DataHandoverRetryRule> getDataHandoverRetryRules() {
        return Collections.unmodifiableList(this.mDataHandoverRetryRules);
    }

    public boolean isDataRoamingEnabledByDefault() {
        return this.mCarrierConfig.getBoolean("carrier_default_data_roaming_enabled_bool");
    }

    private void updateMeteredApnTypes() {
        synchronized (this) {
            this.mMeteredApnTypes.clear();
            String[] stringArray = this.mCarrierConfig.getStringArray("carrier_metered_apn_types_strings");
            if (stringArray != null) {
                Stream map = Arrays.stream(stringArray).map(new DataConfigManager$$ExternalSyntheticLambda12());
                Set<Integer> set = this.mMeteredApnTypes;
                Objects.requireNonNull(set);
                map.forEach(new DataConfigManager$$ExternalSyntheticLambda13(set));
            }
            this.mRoamingMeteredApnTypes.clear();
            String[] stringArray2 = this.mCarrierConfig.getStringArray("carrier_metered_roaming_apn_types_strings");
            if (stringArray2 != null) {
                Stream map2 = Arrays.stream(stringArray2).map(new DataConfigManager$$ExternalSyntheticLambda12());
                Set<Integer> set2 = this.mRoamingMeteredApnTypes;
                Objects.requireNonNull(set2);
                map2.forEach(new DataConfigManager$$ExternalSyntheticLambda13(set2));
            }
        }
    }

    public Set<Integer> getMeteredNetworkCapabilities(boolean z) {
        return (Set) (z ? this.mRoamingMeteredApnTypes : this.mMeteredApnTypes).stream().map(new DataConfigManager$$ExternalSyntheticLambda14()).filter(new DataConfigManager$$ExternalSyntheticLambda15()).collect(Collectors.toUnmodifiableSet());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getMeteredNetworkCapabilities$1(Integer num) {
        return num.intValue() >= 0;
    }

    public boolean isTetheringProfileDisabledForRoaming() {
        return this.mCarrierConfig.getBoolean("disable_dun_apn_while_roaming_with_preset_apn_bool");
    }

    public boolean isMeteredCapability(int i, boolean z) {
        return getMeteredNetworkCapabilities(z).contains(Integer.valueOf(i));
    }

    public boolean isAnyMeteredCapability(int[] iArr, boolean z) {
        return Arrays.stream(iArr).boxed().anyMatch(new DataConfigManager$$ExternalSyntheticLambda2(this, z));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$isAnyMeteredCapability$2(boolean z, Integer num) {
        return isMeteredCapability(num.intValue(), z);
    }

    public boolean shouldUseDataActivityForRrcDetection() {
        return this.mCarrierConfig.getBoolean("lte_endc_using_user_data_for_rrc_detection_bool");
    }

    private void updateSingleDataNetworkTypeList() {
        synchronized (this) {
            this.mSingleDataNetworkTypeList.clear();
            int[] intArray = this.mCarrierConfig.getIntArray("only_single_dc_allowed_int_array");
            if (intArray != null) {
                IntStream stream = Arrays.stream(intArray);
                List<Integer> list = this.mSingleDataNetworkTypeList;
                Objects.requireNonNull(list);
                stream.forEach(new DataConfigManager$$ExternalSyntheticLambda0(list));
            }
        }
    }

    public List<Integer> getNetworkTypesOnlySupportSingleDataNetwork() {
        return Collections.unmodifiableList(this.mSingleDataNetworkTypeList);
    }

    public boolean isTempNotMeteredSupportedByCarrier() {
        return this.mCarrierConfig.getBoolean("network_temp_not_metered_supported_bool");
    }

    private void updateUnmeteredNetworkTypes() {
        synchronized (this) {
            this.mUnmeteredNetworkTypes.clear();
            String[] stringArray = this.mCarrierConfig.getStringArray("unmetered_network_types_string_array");
            if (stringArray != null) {
                this.mUnmeteredNetworkTypes.addAll(Arrays.asList(stringArray));
            }
            this.mRoamingUnmeteredNetworkTypes.clear();
            String[] stringArray2 = this.mCarrierConfig.getStringArray("roaming_unmetered_network_types_string_array");
            if (stringArray2 != null) {
                this.mRoamingUnmeteredNetworkTypes.addAll(Arrays.asList(stringArray2));
            }
        }
    }

    public boolean isNetworkTypeUnmetered(TelephonyDisplayInfo telephonyDisplayInfo, ServiceState serviceState) {
        String dataConfigNetworkType = getDataConfigNetworkType(telephonyDisplayInfo);
        if (serviceState.getDataRoaming()) {
            return this.mRoamingUnmeteredNetworkTypes.contains(dataConfigNetworkType);
        }
        return this.mUnmeteredNetworkTypes.contains(dataConfigNetworkType);
    }

    private void updateBandwidths() {
        synchronized (this) {
            this.mBandwidthMap.clear();
            String[] stringArray = this.mCarrierConfig.getStringArray("bandwidth_string_array");
            boolean z = this.mCarrierConfig.getBoolean("bandwidth_nr_nsa_use_lte_value_for_uplink_bool");
            if (stringArray != null) {
                for (String str : stringArray) {
                    String[] split = str.split(":");
                    if (split.length != 2) {
                        loge("Invalid bandwidth: " + str);
                    } else {
                        String[] split2 = split[1].split(",");
                        if (split2.length != 2) {
                            loge("Invalid bandwidth values: " + Arrays.toString(split2));
                        } else {
                            try {
                                int parseInt = Integer.parseInt(split2[0]);
                                int parseInt2 = Integer.parseInt(split2[1]);
                                if (z) {
                                    if (split[0].startsWith("NR")) {
                                        parseInt2 = this.mBandwidthMap.get(DATA_CONFIG_NETWORK_TYPE_LTE).uplinkBandwidthKbps;
                                    }
                                }
                                this.mBandwidthMap.put(split[0], new DataNetwork.NetworkBandwidth(parseInt, parseInt2));
                            } catch (NumberFormatException e) {
                                loge("Exception parsing bandwidth values for network type " + split[0] + ": " + e);
                            }
                        }
                    }
                }
            }
        }
    }

    public DataNetwork.NetworkBandwidth getBandwidthForNetworkType(TelephonyDisplayInfo telephonyDisplayInfo) {
        DataNetwork.NetworkBandwidth networkBandwidth = this.mBandwidthMap.get(getDataConfigNetworkType(telephonyDisplayInfo));
        if (networkBandwidth != null) {
            return networkBandwidth;
        }
        return new DataNetwork.NetworkBandwidth(14, 14);
    }

    public boolean shouldResetDataThrottlingWhenTacChanges() {
        return this.mCarrierConfig.getBoolean("unthrottle_data_retry_when_tac_changes_bool");
    }

    public String getDataServicePackageName() {
        return this.mCarrierConfig.getString("carrier_data_service_wwan_package_override_string");
    }

    public int getDefaultMtu() {
        return this.mCarrierConfig.getInt("default_mtu_int");
    }

    private void updateTcpBuffers() {
        synchronized (this) {
            this.mTcpBufferSizeMap.clear();
            String[] stringArray = this.mResources.getStringArray(17236100);
            if (stringArray != null) {
                for (String str : stringArray) {
                    String[] split = str.split(":");
                    if (split.length != 2) {
                        loge("Invalid TCP buffer sizes entry: " + str);
                    } else if (split[1].split(",").length != 6) {
                        loge("Invalid TCP buffer sizes for " + split[0] + ": " + split[1]);
                    } else {
                        this.mTcpBufferSizeMap.put(split[0], split[1]);
                    }
                }
            }
        }
    }

    public EventFrequency getAnomalySetupDataCallThreshold() {
        return this.mSetupDataCallAnomalyReportThreshold;
    }

    public EventFrequency getAnomalyNetworkUnwantedThreshold() {
        return this.mNetworkUnwantedAnomalyReportThreshold;
    }

    public EventFrequency getAnomalyImsReleaseRequestThreshold() {
        return this.mImsReleaseRequestAnomalyReportThreshold;
    }

    public int getAnomalyNetworkConnectingTimeoutMs() {
        return this.mNetworkConnectingTimeout;
    }

    public int getAnomalyNetworkDisconnectingTimeoutMs() {
        return this.mNetworkDisconnectingTimeout;
    }

    public int getNetworkHandoverTimeoutMs() {
        return this.mNetworkHandoverTimeout;
    }

    public String getTcpConfigString(TelephonyDisplayInfo telephonyDisplayInfo) {
        String str = this.mTcpBufferSizeMap.get(getDataConfigNetworkType(telephonyDisplayInfo));
        return TextUtils.isEmpty(str) ? getDefaultTcpConfigString() : str;
    }

    public String getDefaultTcpConfigString() {
        return this.mResources.getString(17040051);
    }

    public long getImsDeregistrationDelay() {
        return (long) this.mResources.getInteger(17694805);
    }

    public boolean shouldPersistIwlanDataNetworksWhenDataServiceRestarted() {
        return this.mResources.getBoolean(17891847);
    }

    public boolean isIwlanHandoverPolicyEnabled() {
        return this.mResources.getBoolean(17891659);
    }

    public boolean isImsDelayTearDownEnabled() {
        return this.mCarrierConfig.getBoolean("delay_ims_tear_down_until_call_end_bool");
    }

    @DataNetwork.BandwidthEstimationSource
    public int getBandwidthEstimateSource() {
        String string = this.mResources.getString(17039887);
        string.hashCode();
        char c = 65535;
        switch (string.hashCode()) {
            case -1217242519:
                if (string.equals(BANDWIDTH_SOURCE_CARRIER_CONFIG_STRING_VALUE)) {
                    c = 0;
                    break;
                }
                break;
            case 104069930:
                if (string.equals(BANDWIDTH_SOURCE_MODEM_STRING_VALUE)) {
                    c = 1;
                    break;
                }
                break;
            case 203019122:
                if (string.equals(BANDWIDTH_SOURCE_BANDWIDTH_ESTIMATOR_STRING_VALUE)) {
                    c = 2;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                return 2;
            case 1:
                return 1;
            case 2:
                return 3;
            default:
                loge("Invalid bandwidth estimation source config: " + string);
                return 0;
        }
    }

    public static String getDataConfigNetworkType(TelephonyDisplayInfo telephonyDisplayInfo) {
        int networkType = telephonyDisplayInfo.getNetworkType();
        int overrideNetworkType = telephonyDisplayInfo.getOverrideNetworkType();
        if (overrideNetworkType == 1 || overrideNetworkType == 2) {
            return DATA_CONFIG_NETWORK_TYPE_LTE_CA;
        }
        if (overrideNetworkType == 3) {
            return DATA_CONFIG_NETWORK_TYPE_NR_NSA;
        }
        if (overrideNetworkType != 5) {
            return networkTypeToDataConfigNetworkType(networkType);
        }
        return networkType == 20 ? DATA_CONFIG_NETWORK_TYPE_NR_SA_MMWAVE : DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE;
    }

    private void updateHandoverRules() {
        synchronized (this) {
            this.mHandoverRuleList.clear();
            String[] stringArray = this.mCarrierConfig.getStringArray("iwlan_handover_policy_string_array");
            if (stringArray != null) {
                for (String handoverRule : stringArray) {
                    try {
                        this.mHandoverRuleList.add(new DataNetworkController.HandoverRule(handoverRule));
                    } catch (IllegalArgumentException e) {
                        loge("updateHandoverRules: " + e.getMessage());
                    }
                }
            }
        }
    }

    public static class EventFrequency {
        public final int eventNumOccurrence;
        public final long timeWindow;

        public EventFrequency(long j, int i) {
            this.timeWindow = j;
            this.eventNumOccurrence = i;
        }

        public String toString() {
            return String.format("EventFrequency=[timeWindow=%d, eventNumOccurrence=%d]", new Object[]{Long.valueOf(this.timeWindow), Integer.valueOf(this.eventNumOccurrence)});
        }
    }

    @VisibleForTesting
    public EventFrequency parseSlidingWindowCounterThreshold(String str, long j, int i) {
        EventFrequency eventFrequency = new EventFrequency(j, i);
        if (TextUtils.isEmpty(str)) {
            return eventFrequency;
        }
        String[] split = str.split(",");
        if (split.length != 2) {
            loge("Invalid format: " + str + "Format should be in \"time window in ms,occurrences\". Using default instead.");
            return eventFrequency;
        }
        try {
            try {
                return new EventFrequency(Long.parseLong(split[0].trim()), Integer.parseInt(split[1].trim()));
            } catch (NumberFormatException e) {
                loge("Exception parsing SlidingWindow occurrence as integer " + split[1] + ": " + e);
                return eventFrequency;
            }
        } catch (NumberFormatException e2) {
            loge("Exception parsing SlidingWindow window span " + split[0] + ": " + e2);
            return eventFrequency;
        }
    }

    public List<DataNetworkController.HandoverRule> getHandoverRules() {
        return Collections.unmodifiableList(this.mHandoverRuleList);
    }

    public long getRetrySetupAfterDisconnectMillis() {
        return this.mCarrierConfig.getLong("carrier_data_call_apn_retry_after_disconnect_long");
    }

    public long[] getDataStallRecoveryDelayMillis() {
        return this.mCarrierConfig.getLongArray("data_stall_recovery_timers_long_array");
    }

    public boolean[] getDataStallRecoveryShouldSkipArray() {
        return this.mCarrierConfig.getBooleanArray("data_stall_recovery_should_skip_bool_array");
    }

    public String getDefaultPreferredApn() {
        return TextUtils.emptyIfNull(this.mCarrierConfig.getString("default_preferred_apn_name_string"));
    }

    public int getNrAdvancedCapablePcoId() {
        return this.mCarrierConfig.getInt("nr_advanced_capable_pco_id_int");
    }

    public List<Integer> getAllowedInitialAttachApnTypes() {
        String[] stringArray = this.mCarrierConfig.getStringArray("allowed_initial_attach_apn_types_string_array");
        if (stringArray != null) {
            return (List) Arrays.stream(stringArray).map(new DataConfigManager$$ExternalSyntheticLambda1()).collect(Collectors.toList());
        }
        return Collections.emptyList();
    }

    public boolean isEnhancedIwlanHandoverCheckEnabled() {
        return this.mResources.getBoolean(17891662);
    }

    public void registerForConfigUpdate(Handler handler, int i) {
        this.mConfigUpdateRegistrants.addUnique(handler, i, (Object) null);
    }

    public void unregisterForConfigUpdate(Handler handler) {
        this.mConfigUpdateRegistrants.remove(handler);
    }

    private void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(DataConfigManager.class.getSimpleName() + "-" + this.mPhone.getPhoneId() + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        StringBuilder sb = new StringBuilder();
        sb.append("isConfigCarrierSpecific=");
        sb.append(isConfigCarrierSpecific());
        androidUtilIndentingPrintWriter.println(sb.toString());
        androidUtilIndentingPrintWriter.println("Network capability priority:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mNetworkCapabilityPriorityMap.forEach(new DataConfigManager$$ExternalSyntheticLambda3(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println();
        androidUtilIndentingPrintWriter.println("Data setup retry rules:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mDataSetupRetryRules.forEach(new DataConfigManager$$ExternalSyntheticLambda4(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("isIwlanHandoverPolicyEnabled=" + isIwlanHandoverPolicyEnabled());
        androidUtilIndentingPrintWriter.println("Data handover retry rules:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mDataHandoverRetryRules.forEach(new DataConfigManager$$ExternalSyntheticLambda5(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("mSetupDataCallAnomalyReport=" + this.mSetupDataCallAnomalyReportThreshold);
        androidUtilIndentingPrintWriter.println("mNetworkUnwantedAnomalyReport=" + this.mNetworkUnwantedAnomalyReportThreshold);
        androidUtilIndentingPrintWriter.println("mImsReleaseRequestAnomalyReport=" + this.mImsReleaseRequestAnomalyReportThreshold);
        androidUtilIndentingPrintWriter.println("mNetworkConnectingTimeout=" + this.mNetworkConnectingTimeout);
        androidUtilIndentingPrintWriter.println("mNetworkDisconnectingTimeout=" + this.mNetworkDisconnectingTimeout);
        androidUtilIndentingPrintWriter.println("mNetworkHandoverTimeout=" + this.mNetworkHandoverTimeout);
        androidUtilIndentingPrintWriter.println("Metered APN types=" + ((String) this.mMeteredApnTypes.stream().map(new DataConfigManager$$ExternalSyntheticLambda6()).collect(Collectors.joining(","))));
        androidUtilIndentingPrintWriter.println("Roaming metered APN types=" + ((String) this.mRoamingMeteredApnTypes.stream().map(new DataConfigManager$$ExternalSyntheticLambda6()).collect(Collectors.joining(","))));
        androidUtilIndentingPrintWriter.println("Single data network types=" + ((String) this.mSingleDataNetworkTypeList.stream().map(new DataConfigManager$$ExternalSyntheticLambda7()).collect(Collectors.joining(","))));
        androidUtilIndentingPrintWriter.println("Unmetered network types=" + String.join(",", this.mUnmeteredNetworkTypes));
        androidUtilIndentingPrintWriter.println("Roaming unmetered network types=" + String.join(",", this.mRoamingUnmeteredNetworkTypes));
        androidUtilIndentingPrintWriter.println("Bandwidths:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mBandwidthMap.forEach(new DataConfigManager$$ExternalSyntheticLambda8(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("shouldUseDataActivityForRrcDetection=" + shouldUseDataActivityForRrcDetection());
        androidUtilIndentingPrintWriter.println("isTempNotMeteredSupportedByCarrier=" + isTempNotMeteredSupportedByCarrier());
        androidUtilIndentingPrintWriter.println("shouldResetDataThrottlingWhenTacChanges=" + shouldResetDataThrottlingWhenTacChanges());
        androidUtilIndentingPrintWriter.println("Data service package name=" + getDataServicePackageName());
        androidUtilIndentingPrintWriter.println("Default MTU=" + getDefaultMtu());
        androidUtilIndentingPrintWriter.println("TCP buffer sizes by RAT:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mTcpBufferSizeMap.forEach(new DataConfigManager$$ExternalSyntheticLambda9(androidUtilIndentingPrintWriter));
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Default TCP buffer sizes=" + getDefaultTcpConfigString());
        androidUtilIndentingPrintWriter.println("getImsDeregistrationDelay=" + getImsDeregistrationDelay());
        androidUtilIndentingPrintWriter.println("shouldPersistIwlanDataNetworksWhenDataServiceRestarted=" + shouldPersistIwlanDataNetworksWhenDataServiceRestarted());
        androidUtilIndentingPrintWriter.println("Bandwidth estimation source=" + this.mResources.getString(17039887));
        androidUtilIndentingPrintWriter.println("isDelayTearDownImsEnabled=" + isImsDelayTearDownEnabled());
        androidUtilIndentingPrintWriter.println("isEnhancedIwlanHandoverCheckEnabled=" + isEnhancedIwlanHandoverCheckEnabled());
        androidUtilIndentingPrintWriter.println("isTetheringProfileDisabledForRoaming=" + isTetheringProfileDisabledForRoaming());
        androidUtilIndentingPrintWriter.decreaseIndent();
    }
}
