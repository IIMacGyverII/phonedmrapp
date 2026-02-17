package com.android.internal.telephony.data;

import android.content.ContentResolver;
import android.content.Context;
import android.content.SharedPreferences;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemProperties;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyRegistryManager;
import android.util.ArrayMap;
import android.util.ArraySet;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.GlobalSettingsHelper;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConfigurationManager;
import com.android.internal.telephony.SettingsObserver;
import com.android.internal.telephony.SubscriptionController;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Executor;
import java.util.stream.Collectors;

public class DataSettingsManager extends Handler {
    private static final int EVENT_CALL_STATE_CHANGED = 2;
    private static final int EVENT_DATA_CONFIG_UPDATED = 1;
    private static final int EVENT_INITIALIZE = 11;
    public static final int EVENT_MULTI_SIM_CONFIG_CHANGED = 1;
    private static final int EVENT_PROVISIONED_CHANGED = 9;
    private static final int EVENT_PROVISIONING_DATA_ENABLED_CHANGED = 10;
    private static final int EVENT_SET_ALLOW_DATA_DURING_VOICE_CALL = 8;
    private static final int EVENT_SET_ALWAYS_ALLOW_MMS_DATA = 7;
    private static final int EVENT_SET_DATA_ENABLED_FOR_REASON = 5;
    private static final int EVENT_SET_DATA_ROAMING_ENABLED = 6;
    private static final int EVENT_SUBSCRIPTIONS_CHANGED = 4;
    private final DataConfigManager mDataConfigManager;
    private DataEnabledOverride mDataEnabledOverride;
    private final Map<Integer, Boolean> mDataEnabledSettings;
    private final Set<DataSettingsManagerCallback> mDataSettingsManagerCallbacks = new ArraySet();
    public Handler mHandler;
    private boolean mInitialized;
    private boolean mIsDataEnabled;
    private final LocalLog mLocalLog = new LocalLog(128);
    private final String mLogTag;
    /* access modifiers changed from: private */
    public final Phone mPhone;
    private final ContentResolver mResolver;
    private final SettingsObserver mSettingsObserver;
    /* access modifiers changed from: private */
    public int mSubId;

    private static String dataEnabledChangedReasonToString(int i) {
        return i != 0 ? i != 1 ? i != 2 ? i != 3 ? i != 4 ? "UNKNOWN" : "OVERRIDE" : "THERMAL" : "CARRIER" : "POLICY" : "USER";
    }

    public static class DataSettingsManagerCallback extends DataCallback {
        public void onDataEnabledChanged(boolean z, int i, String str) {
        }

        public void onDataEnabledOverrideChanged(boolean z, int i) {
        }

        public void onDataRoamingEnabledChanged(boolean z) {
        }

        public DataSettingsManagerCallback(Executor executor) {
            super(executor);
        }
    }

    public DataSettingsManager(Phone phone, DataNetworkController dataNetworkController, Looper looper, DataSettingsManagerCallback dataSettingsManagerCallback) {
        super(looper);
        ArrayMap arrayMap = new ArrayMap();
        this.mDataEnabledSettings = arrayMap;
        this.mInitialized = false;
        this.mHandler = new Handler() {
            public void handleMessage(Message message) {
                DataSettingsManager dataSettingsManager = DataSettingsManager.this;
                dataSettingsManager.log("mHandler: " + message.what);
                if (message.what == 1) {
                    DataSettingsManager.this.updateDataEnabledAndNotify(0);
                }
            }
        };
        this.mPhone = phone;
        this.mLogTag = "DSMGR-" + phone.getPhoneId();
        log("DataSettingsManager created.");
        this.mSubId = phone.getSubId();
        this.mResolver = phone.getContext().getContentResolver();
        registerCallback(dataSettingsManagerCallback);
        this.mDataConfigManager = dataNetworkController.getDataConfigManager();
        this.mDataEnabledOverride = getDataEnabledOverride();
        this.mSettingsObserver = new SettingsObserver(phone.getContext(), this);
        Boolean bool = Boolean.TRUE;
        arrayMap.put(1, bool);
        arrayMap.put(2, bool);
        arrayMap.put(3, bool);
        PhoneConfigurationManager.registerForMultiSimConfigChange(this.mHandler, 1, (Object) null);
        sendEmptyMessage(11);
    }

    public void handleMessage(Message message) {
        boolean z = false;
        switch (message.what) {
            case 1:
                if (this.mDataConfigManager.isConfigCarrierSpecific()) {
                    setDefaultDataRoamingEnabled();
                    return;
                }
                return;
            case 2:
                updateDataEnabledAndNotify(4);
                return;
            case 4:
                this.mSubId = ((Integer) message.obj).intValue();
                this.mDataEnabledOverride = getDataEnabledOverride();
                updateDataEnabledAndNotify(0);
                this.mPhone.notifyUserMobileDataStateChanged(isUserDataEnabled());
                return;
            case 5:
                String str = (String) message.obj;
                if (message.arg2 == 1) {
                    z = true;
                }
                int i = message.arg1;
                if (i == 0) {
                    setUserDataEnabled(z, str);
                    return;
                } else if (i == 1) {
                    setPolicyDataEnabled(z, str);
                    return;
                } else if (i == 2) {
                    setCarrierDataEnabled(z, str);
                    return;
                } else if (i != 3) {
                    log("Cannot set data enabled for reason: " + dataEnabledChangedReasonToString(message.arg1));
                    return;
                } else {
                    setThermalDataEnabled(z, str);
                    return;
                }
            case 6:
                setDataRoamingEnabledInternal(((Boolean) message.obj).booleanValue());
                setDataRoamingFromUserAction();
                return;
            case 7:
                boolean booleanValue = ((Boolean) message.obj).booleanValue();
                if (booleanValue != isMmsAlwaysAllowed()) {
                    logl("AlwaysAllowMmsData changed to " + booleanValue);
                    this.mDataEnabledOverride.setAlwaysAllowMms(booleanValue);
                    if (SubscriptionController.getInstance().setDataEnabledOverrideRules(this.mSubId, this.mDataEnabledOverride.getRules())) {
                        updateDataEnabledAndNotify(4);
                        notifyDataEnabledOverrideChanged(booleanValue, 2);
                        return;
                    }
                    return;
                }
                return;
            case 8:
                boolean booleanValue2 = ((Boolean) message.obj).booleanValue();
                if (booleanValue2 != isDataAllowedInVoiceCall()) {
                    logl("AllowDataDuringVoiceCall changed to " + booleanValue2);
                    this.mDataEnabledOverride.setDataAllowedInVoiceCall(booleanValue2);
                    if (SubscriptionController.getInstance().setDataEnabledOverrideRules(this.mSubId, this.mDataEnabledOverride.getRules())) {
                        updateDataEnabledAndNotify(4);
                        notifyDataEnabledOverrideChanged(booleanValue2, 1);
                        return;
                    }
                    return;
                }
                return;
            case 9:
            case 10:
                updateDataEnabledAndNotify(-1);
                return;
            case 11:
                onInitialize();
                return;
            default:
                loge("Unknown msg.what: " + message.what);
                return;
        }
    }

    private void onInitialize() {
        this.mDataConfigManager.registerForConfigUpdate(this, 1);
        this.mSettingsObserver.observe(Settings.Global.getUriFor("device_provisioned"), 9);
        this.mSettingsObserver.observe(Settings.Global.getUriFor("device_provisioning_mobile_data"), 10);
        this.mPhone.getCallTracker().registerForVoiceCallStarted(this, 2, (Object) null);
        this.mPhone.getCallTracker().registerForVoiceCallEnded(this, 2, (Object) null);
        if (this.mPhone.getImsPhone() != null) {
            this.mPhone.getImsPhone().getCallTracker().registerForVoiceCallStarted(this, 2, (Object) null);
            this.mPhone.getImsPhone().getCallTracker().registerForVoiceCallEnded(this, 2, (Object) null);
        }
        ((TelephonyRegistryManager) this.mPhone.getContext().getSystemService(TelephonyRegistryManager.class)).addOnSubscriptionsChangedListener(new SubscriptionManager.OnSubscriptionsChangedListener() {
            public void onSubscriptionsChanged() {
                if (DataSettingsManager.this.mSubId != DataSettingsManager.this.mPhone.getSubId()) {
                    DataSettingsManager dataSettingsManager = DataSettingsManager.this;
                    dataSettingsManager.log("onSubscriptionsChanged: " + DataSettingsManager.this.mSubId + " to " + DataSettingsManager.this.mPhone.getSubId());
                    DataSettingsManager dataSettingsManager2 = DataSettingsManager.this;
                    dataSettingsManager2.obtainMessage(4, Integer.valueOf(dataSettingsManager2.mPhone.getSubId())).sendToTarget();
                }
            }
        }, new DataSettingsManager$$ExternalSyntheticLambda5(this));
        updateDataEnabledAndNotify(-1);
    }

    public void setDataEnabled(int i, boolean z, String str) {
        obtainMessage(5, i, z ? 1 : 0, str).sendToTarget();
    }

    public boolean isDataEnabledForReason(int i) {
        if (i == 0) {
            return isUserDataEnabled();
        }
        return this.mDataEnabledSettings.get(Integer.valueOf(i)).booleanValue();
    }

    /* access modifiers changed from: private */
    public void updateDataEnabledAndNotify(int i) {
        updateDataEnabledAndNotify(i, this.mPhone.getContext().getOpPackageName());
    }

    private void updateDataEnabledAndNotify(int i, String str) {
        boolean z = this.mIsDataEnabled;
        this.mIsDataEnabled = isDataEnabled(255);
        log("mIsDataEnabled=" + this.mIsDataEnabled + ", prevDataEnabled=" + z);
        boolean z2 = this.mInitialized;
        if (!z2 || z != this.mIsDataEnabled) {
            if (!z2) {
                this.mInitialized = true;
            }
            notifyDataEnabledChanged(this.mIsDataEnabled, i, str);
        }
    }

    private boolean isProvisioningDataEnabled() {
        String str = SystemProperties.get("ro.com.android.prov_mobiledata", "false");
        int i = Settings.Global.getInt(this.mResolver, "device_provisioning_mobile_data", "true".equalsIgnoreCase(str) ? 1 : 0);
        boolean z = i != 0;
        log("getDataEnabled during provisioning retVal=" + z + " - (" + str + ", " + i + ")");
        return z;
    }

    public boolean isDataEnabled() {
        return this.mIsDataEnabled;
    }

    public boolean isDataInitialized() {
        return this.mInitialized;
    }

    public boolean isDataEnabled(int i) {
        if (Settings.Global.getInt(this.mResolver, "device_provisioned", 0) == 0) {
            return isProvisioningDataEnabled();
        }
        boolean isUserDataEnabled = isUserDataEnabled();
        boolean shouldOverrideDataEnabledSettings = this.mDataEnabledOverride.shouldOverrideDataEnabledSettings(this.mPhone, i);
        if ((isUserDataEnabled || shouldOverrideDataEnabledSettings) && this.mDataEnabledSettings.get(1).booleanValue() && this.mDataEnabledSettings.get(2).booleanValue() && this.mDataEnabledSettings.get(3).booleanValue()) {
            return true;
        }
        return false;
    }

    private static boolean isStandAloneOpportunistic(int i, Context context) {
        SubscriptionInfo activeSubscriptionInfo = SubscriptionController.getInstance().getActiveSubscriptionInfo(i, context.getOpPackageName(), context.getAttributionTag());
        return activeSubscriptionInfo != null && activeSubscriptionInfo.isOpportunistic() && activeSubscriptionInfo.getGroupUuid() == null;
    }

    private void setUserDataEnabled(boolean z, String str) {
        if (!isStandAloneOpportunistic(this.mSubId, this.mPhone.getContext()) || z) {
            boolean z2 = GlobalSettingsHelper.setInt(this.mPhone.getContext(), "mobile_data", this.mSubId, z ? 1 : 0);
            log("Set user data enabled to " + z + ", changed=" + z2 + ", callingPackage=" + str);
            if (z2) {
                logl("UserDataEnabled changed to " + z);
                this.mPhone.notifyUserMobileDataStateChanged(z);
                updateDataEnabledAndNotify(0, str);
            }
        }
    }

    private boolean isUserDataEnabled() {
        if (Settings.Global.getInt(this.mResolver, "device_provisioned", 0) == 0) {
            return isProvisioningDataEnabled();
        }
        if (isStandAloneOpportunistic(this.mSubId, this.mPhone.getContext())) {
            return true;
        }
        return GlobalSettingsHelper.getBoolean(this.mPhone.getContext(), "mobile_data", this.mSubId, TelephonyProperties.mobile_data().orElse(Boolean.TRUE).booleanValue());
    }

    private void setPolicyDataEnabled(boolean z, String str) {
        if (this.mDataEnabledSettings.get(1).booleanValue() != z) {
            logl("PolicyDataEnabled changed to " + z + ", callingPackage=" + str);
            this.mDataEnabledSettings.put(1, Boolean.valueOf(z));
            updateDataEnabledAndNotify(1, str);
        }
    }

    private void setCarrierDataEnabled(boolean z, String str) {
        if (this.mDataEnabledSettings.get(2).booleanValue() != z) {
            logl("CarrierDataEnabled changed to " + z + ", callingPackage=" + str);
            this.mDataEnabledSettings.put(2, Boolean.valueOf(z));
            updateDataEnabledAndNotify(2, str);
        }
    }

    private void setThermalDataEnabled(boolean z, String str) {
        if (this.mDataEnabledSettings.get(3).booleanValue() != z) {
            logl("ThermalDataEnabled changed to " + z + ", callingPackage=" + str);
            this.mDataEnabledSettings.put(3, Boolean.valueOf(z));
            updateDataEnabledAndNotify(3, str);
        }
    }

    public void setDataRoamingEnabled(boolean z) {
        obtainMessage(6, Boolean.valueOf(z)).sendToTarget();
    }

    private void setDataRoamingEnabledInternal(boolean z) {
        if (GlobalSettingsHelper.setBoolean(this.mPhone.getContext(), "data_roaming", this.mSubId, z)) {
            logl("DataRoamingEnabled changed to " + z);
            this.mDataSettingsManagerCallbacks.forEach(new DataSettingsManager$$ExternalSyntheticLambda4(z));
        }
    }

    public boolean isDataRoamingEnabled() {
        return GlobalSettingsHelper.getBoolean(this.mPhone.getContext(), "data_roaming", this.mSubId, isDefaultDataRoamingEnabled());
    }

    public boolean isDefaultDataRoamingEnabled() {
        return "true".equalsIgnoreCase(SystemProperties.get("ro.com.android.dataroaming", "false")) || this.mPhone.getDataNetworkController().getDataConfigManager().isDataRoamingEnabledByDefault();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:6:0x0037, code lost:
        if (isDataRoamingFromUserAction() == false) goto L_0x003b;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void setDefaultDataRoamingEnabled() {
        /*
            r4 = this;
            com.android.internal.telephony.Phone r0 = r4.mPhone
            android.content.Context r0 = r0.getContext()
            java.lang.Class<android.telephony.TelephonyManager> r1 = android.telephony.TelephonyManager.class
            java.lang.Object r0 = r0.getSystemService(r1)
            android.telephony.TelephonyManager r0 = (android.telephony.TelephonyManager) r0
            int r0 = r0.getSimCount()
            r1 = 1
            r2 = 0
            if (r0 == r1) goto L_0x0033
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r3 = "data_roaming"
            r0.append(r3)
            com.android.internal.telephony.Phone r3 = r4.mPhone
            int r3 = r3.getSubId()
            r0.append(r3)
            java.lang.String r0 = r0.toString()
            android.content.ContentResolver r3 = r4.mResolver     // Catch:{ SettingNotFoundException -> 0x003b }
            android.provider.Settings.Global.getInt(r3, r0)     // Catch:{ SettingNotFoundException -> 0x003b }
            goto L_0x003a
        L_0x0033:
            boolean r0 = r4.isDataRoamingFromUserAction()
            if (r0 != 0) goto L_0x003a
            goto L_0x003b
        L_0x003a:
            r1 = r2
        L_0x003b:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r2 = "setDefaultDataRoamingEnabled: useCarrierSpecificDefault="
            r0.append(r2)
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            r4.log(r0)
            if (r1 == 0) goto L_0x0058
            boolean r0 = r4.isDefaultDataRoamingEnabled()
            r4.setDataRoamingEnabledInternal(r0)
        L_0x0058:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.DataSettingsManager.setDefaultDataRoamingEnabled():void");
    }

    private boolean isDataRoamingFromUserAction() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(this.mPhone.getContext());
        if (!defaultSharedPreferences.contains(Phone.DATA_ROAMING_IS_USER_SETTING_KEY)) {
            defaultSharedPreferences.edit().putBoolean(Phone.DATA_ROAMING_IS_USER_SETTING_KEY, false).commit();
        }
        return defaultSharedPreferences.getBoolean(Phone.DATA_ROAMING_IS_USER_SETTING_KEY, true);
    }

    private void setDataRoamingFromUserAction() {
        PreferenceManager.getDefaultSharedPreferences(this.mPhone.getContext()).edit().putBoolean(Phone.DATA_ROAMING_IS_USER_SETTING_KEY, true).commit();
    }

    private DataEnabledOverride getDataEnabledOverride() {
        return new DataEnabledOverride(SubscriptionController.getInstance().getDataEnabledOverrideRules(this.mSubId));
    }

    public void setAlwaysAllowMmsData(boolean z) {
        obtainMessage(7, Boolean.valueOf(z)).sendToTarget();
    }

    public boolean isMmsAlwaysAllowed() {
        return this.mDataEnabledOverride.isMmsAlwaysAllowed();
    }

    public void setAllowDataDuringVoiceCall(boolean z) {
        obtainMessage(8, Boolean.valueOf(z)).sendToTarget();
    }

    public boolean isDataAllowedInVoiceCall() {
        return this.mDataEnabledOverride.isDataAllowedInVoiceCall();
    }

    public boolean isRecoveryOnBadNetworkEnabled() {
        return Settings.Global.getInt(this.mResolver, "data_stall_recovery_on_bad_network", 1) == 1;
    }

    private void notifyDataEnabledChanged(boolean z, int i, String str) {
        logl("notifyDataEnabledChanged: enabled=" + z + ", reason=" + dataEnabledChangedReasonToString(i) + ", callingPackage=" + str);
        this.mDataSettingsManagerCallbacks.forEach(new DataSettingsManager$$ExternalSyntheticLambda0(z, i, str));
        this.mPhone.notifyDataEnabled(z, i);
    }

    private void notifyDataEnabledOverrideChanged(boolean z, int i) {
        logl("notifyDataEnabledOverrideChanged: enabled=" + z);
        this.mDataSettingsManagerCallbacks.forEach(new DataSettingsManager$$ExternalSyntheticLambda1(z, i));
    }

    public void registerCallback(DataSettingsManagerCallback dataSettingsManagerCallback) {
        this.mDataSettingsManagerCallbacks.add(dataSettingsManagerCallback);
    }

    public void unregisterCallback(DataSettingsManagerCallback dataSettingsManagerCallback) {
        this.mDataSettingsManagerCallbacks.remove(dataSettingsManagerCallback);
    }

    public String toString() {
        return "[isUserDataEnabled=" + isUserDataEnabled() + ", isProvisioningDataEnabled=" + isProvisioningDataEnabled() + ", mIsDataEnabled=" + this.mIsDataEnabled + ", mDataEnabledSettings=" + this.mDataEnabledSettings + ", mDataEnabledOverride=" + this.mDataEnabledOverride + "]";
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    private void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(DataSettingsManager.class.getSimpleName() + "-" + this.mPhone.getPhoneId() + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        StringBuilder sb = new StringBuilder();
        sb.append("mIsDataEnabled=");
        sb.append(this.mIsDataEnabled);
        androidUtilIndentingPrintWriter.println(sb.toString());
        androidUtilIndentingPrintWriter.println("isDataEnabled(internet)=" + isDataEnabled(17));
        androidUtilIndentingPrintWriter.println("isDataEnabled(mms)=" + isDataEnabled(2));
        androidUtilIndentingPrintWriter.println("isUserDataEnabled=" + isUserDataEnabled());
        androidUtilIndentingPrintWriter.println("isDataRoamingEnabled=" + isDataRoamingEnabled());
        androidUtilIndentingPrintWriter.println("isDefaultDataRoamingEnabled=" + isDefaultDataRoamingEnabled());
        androidUtilIndentingPrintWriter.println("isDataRoamingFromUserAction=" + isDataRoamingFromUserAction());
        androidUtilIndentingPrintWriter.println("device_provisioned=" + Settings.Global.getInt(this.mResolver, "device_provisioned", 0));
        androidUtilIndentingPrintWriter.println("isProvisioningDataEnabled=" + isProvisioningDataEnabled());
        androidUtilIndentingPrintWriter.println("data_stall_recovery_on_bad_network=" + Settings.Global.getInt(this.mResolver, "data_stall_recovery_on_bad_network", 1));
        androidUtilIndentingPrintWriter.println("mDataEnabledSettings=" + ((String) this.mDataEnabledSettings.entrySet().stream().map(new DataSettingsManager$$ExternalSyntheticLambda7()).collect(Collectors.joining(", "))));
        androidUtilIndentingPrintWriter.println("mDataEnabledOverride=" + this.mDataEnabledOverride);
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String lambda$dump$6(Map.Entry entry) {
        return dataEnabledChangedReasonToString(((Integer) entry.getKey()).intValue()) + "=" + entry.getValue();
    }
}
