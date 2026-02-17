package com.android.internal.telephony.dataconnection;

import android.content.ContentResolver;
import android.content.Context;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.Handler;
import android.os.SystemProperties;
import android.provider.Settings;
import android.telephony.CarrierConfigManager;
import android.telephony.PhoneStateListener;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.Pair;
import com.android.internal.telephony.GlobalSettingsHelper;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.MultiSimSettingController;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.data.DataEnabledOverride;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class DataEnabledSettings {
    private static final String LOG_TAG = "DataEnabledSettings";
    public static final int REASON_DATA_ENABLED_BY_CARRIER = 4;
    public static final int REASON_INTERNAL_DATA_ENABLED = 1;
    public static final int REASON_OVERRIDE_CONDITION_CHANGED = 8;
    public static final int REASON_OVERRIDE_RULE_CHANGED = 7;
    public static final int REASON_POLICY_DATA_ENABLED = 3;
    public static final int REASON_PROVISIONED_CHANGED = 5;
    public static final int REASON_PROVISIONING_DATA_ENABLED_CHANGED = 6;
    public static final int REASON_REGISTERED = 0;
    public static final int REASON_THERMAL_DATA_ENABLED = 9;
    public static final int REASON_USER_DATA_ENABLED = 2;
    private boolean mCarrierDataEnabled = true;
    /* access modifiers changed from: private */
    public DataEnabledOverride mDataEnabledOverride;
    private boolean mInternalDataEnabled = true;
    private boolean mIsDataEnabled = false;
    private final SubscriptionManager.OnSubscriptionsChangedListener mOnSubscriptionsChangeListener;
    private final RegistrantList mOverallDataEnabledChangedRegistrants = new RegistrantList();
    private final RegistrantList mOverallDataEnabledOverrideChangedRegistrants = new RegistrantList();
    /* access modifiers changed from: private */
    public final Phone mPhone;
    private final PhoneStateListener mPhoneStateListener;
    private boolean mPolicyDataEnabled = true;
    private ContentResolver mResolver = null;
    private final LocalLog mSettingChangeLocalLog = new LocalLog(32);
    /* access modifiers changed from: private */
    public int mSubId = -1;
    private TelephonyManager mTelephonyManager;
    private boolean mThermalDataEnabled = true;

    @Retention(RetentionPolicy.SOURCE)
    public @interface DataEnabledChangedReason {
    }

    /* access modifiers changed from: private */
    public void updatePhoneStateListener() {
        this.mTelephonyManager.listen(this.mPhoneStateListener, 0);
        if (SubscriptionManager.isUsableSubscriptionId(this.mSubId)) {
            this.mTelephonyManager = this.mTelephonyManager.createForSubscriptionId(this.mSubId);
        }
        this.mTelephonyManager.listen(this.mPhoneStateListener, 32);
    }

    public String toString() {
        return "[mInternalDataEnabled=" + this.mInternalDataEnabled + ", isUserDataEnabled=" + isUserDataEnabled() + ", isProvisioningDataEnabled=" + isProvisioningDataEnabled() + ", mPolicyDataEnabled=" + this.mPolicyDataEnabled + ", mCarrierDataEnabled=" + this.mCarrierDataEnabled + ", mIsDataEnabled=" + this.mIsDataEnabled + ", mThermalDataEnabled=" + this.mThermalDataEnabled + ", " + this.mDataEnabledOverride + "]";
    }

    public DataEnabledSettings(Phone phone) {
        AnonymousClass1 r0 = new SubscriptionManager.OnSubscriptionsChangedListener() {
            public void onSubscriptionsChanged() {
                synchronized (this) {
                    if (DataEnabledSettings.this.mSubId != DataEnabledSettings.this.mPhone.getSubId()) {
                        DataEnabledSettings dataEnabledSettings = DataEnabledSettings.this;
                        dataEnabledSettings.log("onSubscriptionsChanged subId: " + DataEnabledSettings.this.mSubId + " to: " + DataEnabledSettings.this.mPhone.getSubId());
                        DataEnabledSettings dataEnabledSettings2 = DataEnabledSettings.this;
                        dataEnabledSettings2.mSubId = dataEnabledSettings2.mPhone.getSubId();
                        DataEnabledSettings dataEnabledSettings3 = DataEnabledSettings.this;
                        dataEnabledSettings3.mDataEnabledOverride = dataEnabledSettings3.getDataEnabledOverride();
                        DataEnabledSettings.this.updatePhoneStateListener();
                        DataEnabledSettings.this.updateDataEnabledAndNotify(2);
                        DataEnabledSettings.this.mPhone.notifyUserMobileDataStateChanged(DataEnabledSettings.this.isUserDataEnabled());
                    }
                }
            }
        };
        this.mOnSubscriptionsChangeListener = r0;
        this.mPhoneStateListener = new PhoneStateListener() {
            public void onCallStateChanged(int i, String str) {
                DataEnabledSettings.this.updateDataEnabledAndNotify(8);
            }
        };
        this.mPhone = phone;
        this.mResolver = phone.getContext().getContentResolver();
        ((SubscriptionManager) phone.getContext().getSystemService("telephony_subscription_service")).addOnSubscriptionsChangedListener(r0);
        this.mTelephonyManager = (TelephonyManager) phone.getContext().getSystemService("phone");
        this.mDataEnabledOverride = getDataEnabledOverride();
        updateDataEnabled();
    }

    /* access modifiers changed from: private */
    public DataEnabledOverride getDataEnabledOverride() {
        return new DataEnabledOverride(SubscriptionController.getInstance().getDataEnabledOverrideRules(this.mPhone.getSubId()));
    }

    public synchronized void setInternalDataEnabled(boolean z) {
        if (this.mInternalDataEnabled != z) {
            localLog("InternalDataEnabled", z);
            this.mInternalDataEnabled = z;
            updateDataEnabledAndNotify(1);
        }
    }

    public synchronized boolean isInternalDataEnabled() {
        return this.mInternalDataEnabled;
    }

    private synchronized void setUserDataEnabled(boolean z) {
        setUserDataEnabled(z, true);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:18:0x004e, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void setUserDataEnabled(boolean r5, boolean r6) {
        /*
            r4 = this;
            monitor-enter(r4)
            com.android.internal.telephony.Phone r0 = r4.mPhone     // Catch:{ all -> 0x004f }
            int r0 = r0.getSubId()     // Catch:{ all -> 0x004f }
            com.android.internal.telephony.Phone r1 = r4.mPhone     // Catch:{ all -> 0x004f }
            android.content.Context r1 = r1.getContext()     // Catch:{ all -> 0x004f }
            boolean r0 = isStandAloneOpportunistic(r0, r1)     // Catch:{ all -> 0x004f }
            if (r0 == 0) goto L_0x0017
            if (r5 != 0) goto L_0x0017
            monitor-exit(r4)
            return
        L_0x0017:
            com.android.internal.telephony.Phone r0 = r4.mPhone     // Catch:{ all -> 0x004f }
            android.content.Context r0 = r0.getContext()     // Catch:{ all -> 0x004f }
            java.lang.String r1 = "mobile_data"
            com.android.internal.telephony.Phone r2 = r4.mPhone     // Catch:{ all -> 0x004f }
            int r2 = r2.getSubId()     // Catch:{ all -> 0x004f }
            if (r5 == 0) goto L_0x0029
            r3 = 1
            goto L_0x002a
        L_0x0029:
            r3 = 0
        L_0x002a:
            boolean r0 = com.android.internal.telephony.GlobalSettingsHelper.setInt(r0, r1, r2, r3)     // Catch:{ all -> 0x004f }
            if (r0 == 0) goto L_0x004d
            java.lang.String r0 = "UserDataEnabled"
            r4.localLog(r0, r5)     // Catch:{ all -> 0x004f }
            com.android.internal.telephony.Phone r0 = r4.mPhone     // Catch:{ all -> 0x004f }
            r0.notifyUserMobileDataStateChanged(r5)     // Catch:{ all -> 0x004f }
            r0 = 2
            r4.updateDataEnabledAndNotify(r0)     // Catch:{ all -> 0x004f }
            if (r6 == 0) goto L_0x004d
            com.android.internal.telephony.MultiSimSettingController r6 = com.android.internal.telephony.MultiSimSettingController.getInstance()     // Catch:{ all -> 0x004f }
            com.android.internal.telephony.Phone r0 = r4.mPhone     // Catch:{ all -> 0x004f }
            int r0 = r0.getSubId()     // Catch:{ all -> 0x004f }
            r6.notifyUserDataEnabled(r0, r5)     // Catch:{ all -> 0x004f }
        L_0x004d:
            monitor-exit(r4)
            return
        L_0x004f:
            r5 = move-exception
            monitor-exit(r4)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataEnabledSettings.setUserDataEnabled(boolean, boolean):void");
    }

    public synchronized void setDataEnabled(int i, boolean z) {
        if (i == 0) {
            setUserDataEnabled(z);
        } else if (i == 1) {
            setPolicyDataEnabled(z);
        } else if (i == 2) {
            setCarrierDataEnabled(z);
        } else if (i != 3) {
            log("Invalid data enable reason " + i);
        } else {
            setThermalDataEnabled(z);
        }
    }

    public synchronized boolean isUserDataEnabled() {
        if (isStandAloneOpportunistic(this.mPhone.getSubId(), this.mPhone.getContext())) {
            return true;
        }
        return GlobalSettingsHelper.getBoolean(this.mPhone.getContext(), "mobile_data", this.mPhone.getSubId(), TelephonyProperties.mobile_data().orElse(Boolean.TRUE).booleanValue());
    }

    public synchronized boolean setAlwaysAllowMmsData(boolean z) {
        boolean dataEnabledOverrideRules;
        localLog("setAlwaysAllowMmsData", z);
        this.mDataEnabledOverride.setAlwaysAllowMms(z);
        dataEnabledOverrideRules = SubscriptionController.getInstance().setDataEnabledOverrideRules(this.mPhone.getSubId(), this.mDataEnabledOverride.getRules());
        if (dataEnabledOverrideRules) {
            updateDataEnabledAndNotify(7);
            notifyDataEnabledOverrideChanged();
        }
        return dataEnabledOverrideRules;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:13:0x0032, code lost:
        return r3;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized boolean setAllowDataDuringVoiceCall(boolean r3) {
        /*
            r2 = this;
            monitor-enter(r2)
            java.lang.String r0 = "setAllowDataDuringVoiceCall"
            r2.localLog(r0, r3)     // Catch:{ all -> 0x0033 }
            boolean r0 = r2.isDataAllowedInVoiceCall()     // Catch:{ all -> 0x0033 }
            if (r3 != r0) goto L_0x000f
            r3 = 1
            monitor-exit(r2)
            return r3
        L_0x000f:
            com.android.internal.telephony.data.DataEnabledOverride r0 = r2.mDataEnabledOverride     // Catch:{ all -> 0x0033 }
            r0.setDataAllowedInVoiceCall(r3)     // Catch:{ all -> 0x0033 }
            com.android.internal.telephony.SubscriptionController r3 = com.android.internal.telephony.SubscriptionController.getInstance()     // Catch:{ all -> 0x0033 }
            com.android.internal.telephony.Phone r0 = r2.mPhone     // Catch:{ all -> 0x0033 }
            int r0 = r0.getSubId()     // Catch:{ all -> 0x0033 }
            com.android.internal.telephony.data.DataEnabledOverride r1 = r2.mDataEnabledOverride     // Catch:{ all -> 0x0033 }
            java.lang.String r1 = r1.getRules()     // Catch:{ all -> 0x0033 }
            boolean r3 = r3.setDataEnabledOverrideRules(r0, r1)     // Catch:{ all -> 0x0033 }
            if (r3 == 0) goto L_0x0031
            r0 = 7
            r2.updateDataEnabledAndNotify(r0)     // Catch:{ all -> 0x0033 }
            r2.notifyDataEnabledOverrideChanged()     // Catch:{ all -> 0x0033 }
        L_0x0031:
            monitor-exit(r2)
            return r3
        L_0x0033:
            r3 = move-exception
            monitor-exit(r2)
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataEnabledSettings.setAllowDataDuringVoiceCall(boolean):boolean");
    }

    public synchronized boolean isDataAllowedInVoiceCall() {
        return this.mDataEnabledOverride.isDataAllowedInVoiceCall();
    }

    public synchronized boolean isMmsAlwaysAllowed() {
        return this.mDataEnabledOverride.isMmsAlwaysAllowed();
    }

    private synchronized void setPolicyDataEnabled(boolean z) {
        if (this.mPolicyDataEnabled != z) {
            localLog("PolicyDataEnabled", z);
            this.mPolicyDataEnabled = z;
            updateDataEnabledAndNotify(3);
        }
    }

    public synchronized boolean isPolicyDataEnabled() {
        return this.mPolicyDataEnabled;
    }

    private synchronized void setCarrierDataEnabled(boolean z) {
        if (this.mCarrierDataEnabled != z) {
            localLog("CarrierDataEnabled", z);
            this.mCarrierDataEnabled = z;
            updateDataEnabledAndNotify(4);
        }
    }

    public synchronized boolean isCarrierDataEnabled() {
        return this.mCarrierDataEnabled;
    }

    private synchronized void setThermalDataEnabled(boolean z) {
        if (this.mThermalDataEnabled != z) {
            localLog("ThermalDataEnabled", z);
            this.mThermalDataEnabled = z;
            updateDataEnabledAndNotify(9);
        }
    }

    public synchronized boolean isThermalDataEnabled() {
        return this.mThermalDataEnabled;
    }

    public synchronized void updateProvisionedChanged() {
        updateDataEnabledAndNotify(5);
    }

    public synchronized void updateProvisioningDataEnabled() {
        updateDataEnabledAndNotify(6);
    }

    public synchronized boolean isDataEnabled() {
        return this.mIsDataEnabled;
    }

    public synchronized boolean isDataEnabledForReason(int i) {
        if (i == 0) {
            return isUserDataEnabled();
        } else if (i == 1) {
            return isPolicyDataEnabled();
        } else if (i == 2) {
            return isCarrierDataEnabled();
        } else if (i != 3) {
            return false;
        } else {
            return isThermalDataEnabled();
        }
    }

    /* access modifiers changed from: private */
    public synchronized void updateDataEnabledAndNotify(int i) {
        boolean z = this.mIsDataEnabled;
        updateDataEnabled();
        if (z != this.mIsDataEnabled) {
            notifyDataEnabledChanged(!z, i);
        }
    }

    private synchronized void updateDataEnabled() {
        if (isProvisioning()) {
            this.mIsDataEnabled = isProvisioningDataEnabled();
        } else {
            this.mIsDataEnabled = this.mInternalDataEnabled && (isUserDataEnabled() || this.mDataEnabledOverride.shouldOverrideDataEnabledSettings(this.mPhone, 255)) && this.mPolicyDataEnabled && this.mCarrierDataEnabled && this.mThermalDataEnabled;
        }
    }

    public boolean isProvisioning() {
        return Settings.Global.getInt(this.mResolver, "device_provisioned", 0) == 0;
    }

    public boolean isProvisioningDataEnabled() {
        String str = SystemProperties.get("ro.com.android.prov_mobiledata", "false");
        int i = Settings.Global.getInt(this.mResolver, "device_provisioning_mobile_data", "true".equalsIgnoreCase(str) ? 1 : 0);
        boolean z = i != 0;
        log("getDataEnabled during provisioning retVal=" + z + " - (" + str + ", " + i + ")");
        return z;
    }

    public synchronized void setDataRoamingEnabled(boolean z) {
        if (GlobalSettingsHelper.setBoolean(this.mPhone.getContext(), "data_roaming", this.mPhone.getSubId(), z)) {
            localLog("setDataRoamingEnabled", z);
            MultiSimSettingController.getInstance().notifyRoamingDataEnabled(this.mPhone.getSubId(), z);
        }
    }

    public synchronized boolean getDataRoamingEnabled() {
        return GlobalSettingsHelper.getBoolean(this.mPhone.getContext(), "data_roaming", this.mPhone.getSubId(), getDefaultDataRoamingEnabled());
    }

    public synchronized boolean getDefaultDataRoamingEnabled() {
        return ((CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config")).getConfigForSubId(this.mPhone.getSubId()).getBoolean("carrier_default_data_roaming_enabled_bool") | "true".equalsIgnoreCase(SystemProperties.get("ro.com.android.dataroaming", "false"));
    }

    private void notifyDataEnabledChanged(boolean z, int i) {
        this.mOverallDataEnabledChangedRegistrants.notifyResult(new Pair(Boolean.valueOf(z), Integer.valueOf(i)));
        this.mPhone.notifyDataEnabled(z, i);
    }

    public void registerForDataEnabledChanged(Handler handler, int i, Object obj) {
        this.mOverallDataEnabledChangedRegistrants.addUnique(handler, i, obj);
        notifyDataEnabledChanged(isDataEnabled(), 0);
    }

    public void unregisterForDataEnabledChanged(Handler handler) {
        this.mOverallDataEnabledChangedRegistrants.remove(handler);
    }

    private void notifyDataEnabledOverrideChanged() {
        this.mOverallDataEnabledOverrideChangedRegistrants.notifyRegistrants();
    }

    public void registerForDataEnabledOverrideChanged(Handler handler, int i) {
        this.mOverallDataEnabledOverrideChangedRegistrants.addUnique(handler, i, (Object) null);
        notifyDataEnabledOverrideChanged();
    }

    public void unregisterForDataEnabledOverrideChanged(Handler handler) {
        this.mOverallDataEnabledOverrideChangedRegistrants.remove(handler);
    }

    private static boolean isStandAloneOpportunistic(int i, Context context) {
        SubscriptionInfo activeSubscriptionInfo = SubscriptionController.getInstance().getActiveSubscriptionInfo(i, context.getOpPackageName(), context.getAttributionTag());
        return activeSubscriptionInfo != null && activeSubscriptionInfo.isOpportunistic() && activeSubscriptionInfo.getGroupUuid() == null;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:21:0x0031, code lost:
        return r3.mInternalDataEnabled && r3.mPolicyDataEnabled && r3.mCarrierDataEnabled && r3.mThermalDataEnabled && (isUserDataEnabled() || r3.mDataEnabledOverride.shouldOverrideDataEnabledSettings(r3.mPhone, r4));
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized boolean isDataEnabled(int r4) {
        /*
            r3 = this;
            monitor-enter(r3)
            boolean r0 = r3.isProvisioning()     // Catch:{ all -> 0x0032 }
            if (r0 == 0) goto L_0x000d
            boolean r4 = r3.isProvisioningDataEnabled()     // Catch:{ all -> 0x0032 }
            monitor-exit(r3)
            return r4
        L_0x000d:
            boolean r0 = r3.isUserDataEnabled()     // Catch:{ all -> 0x0032 }
            com.android.internal.telephony.data.DataEnabledOverride r1 = r3.mDataEnabledOverride     // Catch:{ all -> 0x0032 }
            com.android.internal.telephony.Phone r2 = r3.mPhone     // Catch:{ all -> 0x0032 }
            boolean r4 = r1.shouldOverrideDataEnabledSettings(r2, r4)     // Catch:{ all -> 0x0032 }
            boolean r1 = r3.mInternalDataEnabled     // Catch:{ all -> 0x0032 }
            if (r1 == 0) goto L_0x002f
            boolean r1 = r3.mPolicyDataEnabled     // Catch:{ all -> 0x0032 }
            if (r1 == 0) goto L_0x002f
            boolean r1 = r3.mCarrierDataEnabled     // Catch:{ all -> 0x0032 }
            if (r1 == 0) goto L_0x002f
            boolean r1 = r3.mThermalDataEnabled     // Catch:{ all -> 0x0032 }
            if (r1 == 0) goto L_0x002f
            if (r0 != 0) goto L_0x002d
            if (r4 == 0) goto L_0x002f
        L_0x002d:
            r4 = 1
            goto L_0x0030
        L_0x002f:
            r4 = 0
        L_0x0030:
            monitor-exit(r3)
            return r4
        L_0x0032:
            r4 = move-exception
            monitor-exit(r3)
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.dataconnection.DataEnabledSettings.isDataEnabled(int):boolean");
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(LOG_TAG, "[" + this.mPhone.getPhoneId() + "]" + str);
    }

    private void localLog(String str, boolean z) {
        LocalLog localLog = this.mSettingChangeLocalLog;
        localLog.log(str + " change to " + z);
    }

    /* access modifiers changed from: protected */
    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println(" DataEnabledSettings=");
        this.mSettingChangeLocalLog.dump(fileDescriptor, printWriter, strArr);
    }
}
