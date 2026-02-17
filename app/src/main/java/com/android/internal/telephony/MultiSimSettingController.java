package com.android.internal.telephony;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.ParcelUuid;
import android.provider.Settings;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.euicc.EuiccManager;
import android.text.TextUtils;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.data.DataSettingsManager;
import com.android.internal.telephony.util.ArrayUtils;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.stream.Collectors;

public class MultiSimSettingController extends Handler {
    private static final boolean DBG = true;
    protected static final int EVENT_ALL_SUBSCRIPTIONS_LOADED = 3;
    protected static final int EVENT_CARRIER_CONFIG_CHANGED = 7;
    protected static final int EVENT_DEFAULT_DATA_SUBSCRIPTION_CHANGED = 6;
    protected static final int EVENT_MULTI_SIM_CONFIG_CHANGED = 8;
    @VisibleForTesting
    public static final int EVENT_RADIO_STATE_CHANGED = 9;
    protected static final int EVENT_ROAMING_DATA_ENABLED = 2;
    protected static final int EVENT_SUBSCRIPTION_GROUP_CHANGED = 5;
    protected static final int EVENT_SUBSCRIPTION_INFO_CHANGED = 4;
    protected static final int EVENT_USER_DATA_ENABLED = 1;
    private static final String LOG_TAG = "MultiSimSettingController";
    protected static final int PRIMARY_SUB_ADDED = 1;
    protected static final int PRIMARY_SUB_INITIALIZED = 6;
    protected static final int PRIMARY_SUB_MARKED_OPPT = 5;
    protected static final int PRIMARY_SUB_NO_CHANGE = 0;
    protected static final int PRIMARY_SUB_REMOVED = 2;
    protected static final int PRIMARY_SUB_REMOVED_IN_GROUP = 7;
    protected static final int PRIMARY_SUB_SWAPPED = 3;
    protected static final int PRIMARY_SUB_SWAPPED_IN_GROUP = 4;
    protected static final String SETTING_USER_PREF_DATA_SUB = "user_preferred_data_sub";
    protected static MultiSimSettingController sInstance;
    private int mCallbacksCount;
    protected int[] mCarrierConfigLoadedSubIds;
    protected final Context mContext;
    protected boolean mInitialHandling = true;
    private final BroadcastReceiver mIntentReceiver;
    protected final boolean mIsAskEverytimeSupportedForSms;
    protected List<Integer> mPrimarySubList = new ArrayList();
    protected final SubscriptionController mSubController;
    private boolean mSubInfoInitialized = false;

    @Retention(RetentionPolicy.SOURCE)
    private @interface PrimarySubChangeType {
    }

    protected interface UpdateDefaultAction {
        void update(int i);
    }

    private boolean isUserVisibleChange(int i) {
        return i == 1 || i == 2 || i == 3;
    }

    private static class DataSettingsControllerCallback extends DataSettingsManager.DataSettingsManagerCallback {
        private final Phone mPhone;

        DataSettingsControllerCallback(Phone phone, Executor executor) {
            super(executor);
            this.mPhone = phone;
        }

        public void onDataEnabledChanged(boolean z, int i, String str) {
            if (SubscriptionManager.isValidSubscriptionId(this.mPhone.getSubId()) && i == 0 && !MultiSimSettingController.getInstance().mContext.getOpPackageName().equals(str)) {
                MultiSimSettingController.getInstance().notifyUserDataEnabled(this.mPhone.getSubId(), z);
            }
        }

        public void onDataRoamingEnabledChanged(boolean z) {
            if (SubscriptionManager.isValidSubscriptionId(this.mPhone.getSubId())) {
                MultiSimSettingController.getInstance().notifyRoamingDataEnabled(this.mPhone.getSubId(), z);
            }
        }
    }

    public static MultiSimSettingController getInstance() {
        MultiSimSettingController multiSimSettingController;
        synchronized (MultiSimSettingController.class) {
            if (sInstance == null) {
                Log.wtf(LOG_TAG, "getInstance null");
            }
            multiSimSettingController = sInstance;
        }
        return multiSimSettingController;
    }

    public static MultiSimSettingController init(Context context, SubscriptionController subscriptionController) {
        MultiSimSettingController multiSimSettingController;
        synchronized (MultiSimSettingController.class) {
            if (sInstance == null) {
                sInstance = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeMultiSimSettingController(context, subscriptionController);
            } else {
                Log.wtf(LOG_TAG, "init() called multiple times!  sInstance = " + sInstance);
            }
            multiSimSettingController = sInstance;
        }
        return multiSimSettingController;
    }

    @VisibleForTesting
    public MultiSimSettingController(Context context, SubscriptionController subscriptionController) {
        AnonymousClass1 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.telephony.action.CARRIER_CONFIG_CHANGED".equals(intent.getAction())) {
                    MultiSimSettingController.this.notifyCarrierConfigChanged(intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1), intent.getIntExtra("android.telephony.extra.SUBSCRIPTION_INDEX", -1));
                }
            }
        };
        this.mIntentReceiver = r0;
        this.mContext = context;
        this.mSubController = subscriptionController;
        int[] iArr = new int[((TelephonyManager) context.getSystemService("phone")).getSupportedModemCount()];
        this.mCarrierConfigLoadedSubIds = iArr;
        Arrays.fill(iArr, -1);
        PhoneConfigurationManager.registerForMultiSimConfigChange(this, 8, (Object) null);
        this.mIsAskEverytimeSupportedForSms = context.getResources().getBoolean(17891764);
        context.registerReceiver(r0, new IntentFilter("android.telephony.action.CARRIER_CONFIG_CHANGED"));
    }

    public void notifyUserDataEnabled(int i, boolean z) {
        if (SubscriptionManager.isValidSubscriptionId(i)) {
            obtainMessage(1, i, z ? 1 : 0).sendToTarget();
        }
    }

    public void notifyRoamingDataEnabled(int i, boolean z) {
        if (SubscriptionManager.isValidSubscriptionId(i)) {
            obtainMessage(2, i, z ? 1 : 0).sendToTarget();
        }
    }

    public void notifyAllSubscriptionLoaded() {
        obtainMessage(3).sendToTarget();
    }

    public void notifySubscriptionInfoChanged() {
        log("notifySubscriptionInfoChanged");
        obtainMessage(4).sendToTarget();
    }

    public void notifySubscriptionGroupChanged(ParcelUuid parcelUuid) {
        obtainMessage(5, parcelUuid).sendToTarget();
    }

    public void notifyDefaultDataSubChanged() {
        obtainMessage(6).sendToTarget();
    }

    public void handleMessage(Message message) {
        boolean z = true;
        switch (message.what) {
            case 1:
                int i = message.arg1;
                if (message.arg2 == 0) {
                    z = false;
                }
                onUserDataEnabled(i, z);
                return;
            case 2:
                int i2 = message.arg1;
                if (message.arg2 == 0) {
                    z = false;
                }
                onRoamingDataEnabled(i2, z);
                return;
            case 3:
                onAllSubscriptionsLoaded();
                return;
            case 4:
                onSubscriptionsChanged();
                return;
            case 5:
                onSubscriptionGroupChanged((ParcelUuid) message.obj);
                return;
            case 6:
                onDefaultDataSettingChanged();
                return;
            case 7:
                onCarrierConfigChanged(message.arg1, message.arg2);
                return;
            case 8:
                onMultiSimConfigChanged(((Integer) ((AsyncResult) message.obj).result).intValue());
                return;
            case 9:
                for (Phone phone : PhoneFactory.getPhones()) {
                    if (phone.mCi.getRadioState() == 2) {
                        log("Radio unavailable. Clearing sub info initialized flag.");
                        this.mSubInfoInitialized = false;
                        return;
                    }
                }
                return;
            default:
                return;
        }
    }

    /* access modifiers changed from: protected */
    public void onUserDataEnabled(int i, boolean z) {
        log("onUserDataEnabled");
        setUserDataEnabledForGroup(i, z);
        if (this.mSubController.getDefaultDataSubId() != i && !this.mSubController.isOpportunistic(i) && z && this.mSubController.isActiveSubId(i)) {
            Settings.Global.putInt(this.mContext.getContentResolver(), SETTING_USER_PREF_DATA_SUB, i);
            this.mSubController.setDefaultDataSubId(i);
        }
    }

    private void onRoamingDataEnabled(int i, boolean z) {
        log("onRoamingDataEnabled");
        setRoamingDataEnabledForGroup(i, z);
        this.mSubController.setDataRoaming(z ? 1 : 0, i);
    }

    private void onAllSubscriptionsLoaded() {
        log("onAllSubscriptionsLoaded: mSubInfoInitialized=" + this.mSubInfoInitialized);
        if (!this.mSubInfoInitialized) {
            this.mSubInfoInitialized = true;
            for (Phone phone : PhoneFactory.getPhones()) {
                phone.mCi.registerForRadioStateChanged(this, 9, (Object) null);
            }
            reEvaluateAll();
        }
        registerDataSettingsControllerCallbackAsNeeded();
    }

    private void onSubscriptionsChanged() {
        log("onSubscriptionsChanged");
        reEvaluateAll();
    }

    public void onPhoneRemoved() {
        log("onPhoneRemoved");
        if (Looper.myLooper() == getLooper()) {
            reEvaluateAll();
            return;
        }
        throw new RuntimeException("This method must be called from the same looper as MultiSimSettingController.");
    }

    @VisibleForTesting
    public void notifyCarrierConfigChanged(int i, int i2) {
        obtainMessage(7, i, i2).sendToTarget();
    }

    private void onCarrierConfigChanged(int i, int i2) {
        CarrierConfigManager carrierConfigManager;
        log("onCarrierConfigChanged phoneId " + i + " subId " + i2);
        if (!SubscriptionManager.isValidPhoneId(i)) {
            loge("Carrier config change with invalid phoneId " + i);
            return;
        }
        if (i2 == -1) {
            int[] subId = this.mSubController.getSubId(i);
            if (!(ArrayUtils.isEmpty(subId) || (carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config")) == null || carrierConfigManager.getConfigForSubId(subId[0]) == null)) {
                loge("onCarrierConfigChanged with invalid subId while subd " + subId[0] + " is active and its config is loaded");
                i2 = subId[0];
            }
        }
        this.mCarrierConfigLoadedSubIds[i] = i2;
        reEvaluateAll();
    }

    @VisibleForTesting
    public boolean isCarrierConfigLoadedForAllSub() {
        int[] activeSubIdList = this.mSubController.getActiveSubIdList(false);
        int length = activeSubIdList.length;
        int i = 0;
        while (true) {
            boolean z = true;
            if (i >= length) {
                return true;
            }
            int i2 = activeSubIdList[i];
            int[] iArr = this.mCarrierConfigLoadedSubIds;
            int length2 = iArr.length;
            int i3 = 0;
            while (true) {
                if (i3 >= length2) {
                    z = false;
                    break;
                } else if (iArr[i3] == i2) {
                    break;
                } else {
                    i3++;
                }
            }
            if (!z) {
                log("Carrier config subId " + i2 + " is not loaded.");
                return false;
            }
            i++;
        }
    }

    /* access modifiers changed from: protected */
    public void onMultiSimConfigChanged(int i) {
        while (true) {
            int[] iArr = this.mCarrierConfigLoadedSubIds;
            if (i >= iArr.length) {
                break;
            }
            iArr[i] = -1;
            i++;
        }
        for (Phone phone : PhoneFactory.getPhones()) {
            phone.mCi.registerForRadioStateChanged(this, 9, (Object) null);
        }
        registerDataSettingsControllerCallbackAsNeeded();
    }

    /* access modifiers changed from: protected */
    public boolean isReadyToReevaluate() {
        boolean isCarrierConfigLoadedForAllSub = isCarrierConfigLoadedForAllSub();
        log("isReadyToReevaluate: subInfoInitialized=" + this.mSubInfoInitialized + ", carrierConfigsLoaded=" + isCarrierConfigLoadedForAllSub);
        return this.mSubInfoInitialized && isCarrierConfigLoadedForAllSub;
    }

    private void reEvaluateAll() {
        if (isReadyToReevaluate()) {
            updateDefaults();
            disableDataForNonDefaultNonOpportunisticSubscriptions();
            deactivateGroupedOpportunisticSubscriptionIfNeeded();
        }
    }

    private void onDefaultDataSettingChanged() {
        log("onDefaultDataSettingChanged");
        disableDataForNonDefaultNonOpportunisticSubscriptions();
    }

    private void onSubscriptionGroupChanged(ParcelUuid parcelUuid) {
        boolean z;
        log("onSubscriptionGroupChanged");
        List<SubscriptionInfo> subscriptionsInGroup = this.mSubController.getSubscriptionsInGroup(parcelUuid, this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
        if (subscriptionsInGroup != null && !subscriptionsInGroup.isEmpty()) {
            boolean z2 = false;
            int subscriptionId = subscriptionsInGroup.get(0).getSubscriptionId();
            Iterator<SubscriptionInfo> it = subscriptionsInGroup.iterator();
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                int subscriptionId2 = it.next().getSubscriptionId();
                if (this.mSubController.isActiveSubId(subscriptionId2) && !this.mSubController.isOpportunistic(subscriptionId2)) {
                    subscriptionId = subscriptionId2;
                    break;
                }
            }
            log("refSubId is " + subscriptionId);
            try {
                z = GlobalSettingsHelper.getBoolean(this.mContext, "mobile_data", subscriptionId);
                try {
                    onUserDataEnabled(subscriptionId, z);
                } catch (Settings.SettingNotFoundException unused) {
                }
            } catch (Settings.SettingNotFoundException unused2) {
                z = false;
                onUserDataEnabled(subscriptionId, GlobalSettingsHelper.getBoolean(this.mContext, "mobile_data", -1, z));
                z2 = GlobalSettingsHelper.getBoolean(this.mContext, "data_roaming", subscriptionId);
                onRoamingDataEnabled(subscriptionId, z2);
                this.mSubController.syncGroupedSetting(subscriptionId);
            }
            try {
                z2 = GlobalSettingsHelper.getBoolean(this.mContext, "data_roaming", subscriptionId);
                onRoamingDataEnabled(subscriptionId, z2);
            } catch (Settings.SettingNotFoundException unused3) {
                onRoamingDataEnabled(subscriptionId, GlobalSettingsHelper.getBoolean(this.mContext, "data_roaming", -1, z2));
            }
            this.mSubController.syncGroupedSetting(subscriptionId);
        }
    }

    /* access modifiers changed from: protected */
    public void updateDefaults() {
        log("updateDefaults");
        if (isReadyToReevaluate()) {
            List<SubscriptionInfo> activeSubscriptionInfoList = this.mSubController.getActiveSubscriptionInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
            if (ArrayUtils.isEmpty(activeSubscriptionInfoList)) {
                this.mPrimarySubList.clear();
                log("[updateDefaultValues] No active sub. Setting default to INVALID sub.");
                this.mSubController.setDefaultDataSubId(-1);
                this.mSubController.setDefaultVoiceSubId(-1);
                this.mSubController.setDefaultSmsSubId(-1);
                return;
            }
            int updatePrimarySubListAndGetChangeType = updatePrimarySubListAndGetChangeType(activeSubscriptionInfoList);
            log("[updateDefaultValues] change: " + updatePrimarySubListAndGetChangeType);
            if (updatePrimarySubListAndGetChangeType != 0) {
                if (this.mPrimarySubList.size() != 1 || (updatePrimarySubListAndGetChangeType == 2 && ((TelephonyManager) this.mContext.getSystemService("phone")).getActiveModemCount() != 1)) {
                    log("[updateDefaultValues] records: " + this.mPrimarySubList);
                    log("[updateDefaultValues] Update default data subscription");
                    boolean updateDefaultValue = updateDefaultValue(this.mPrimarySubList, this.mSubController.getDefaultDataSubId(), new MultiSimSettingController$$ExternalSyntheticLambda0(this));
                    log("[updateDefaultValues] Update default voice subscription");
                    boolean updateDefaultValue2 = updateDefaultValue(this.mPrimarySubList, this.mSubController.getDefaultVoiceSubId(), new MultiSimSettingController$$ExternalSyntheticLambda1(this));
                    log("[updateDefaultValues] Update default sms subscription");
                    boolean updateDefaultValue3 = updateDefaultValue(this.mPrimarySubList, this.mSubController.getDefaultSmsSubId(), new MultiSimSettingController$$ExternalSyntheticLambda2(this), this.mIsAskEverytimeSupportedForSms);
                    if (!this.mContext.getResources().getBoolean(17891831)) {
                        sendSubChangeNotificationIfNeeded(updatePrimarySubListAndGetChangeType, updateDefaultValue, updateDefaultValue2, updateDefaultValue3);
                    } else {
                        updateUserPreferences(this.mPrimarySubList, updateDefaultValue, updateDefaultValue2, updateDefaultValue3);
                    }
                } else {
                    int intValue = this.mPrimarySubList.get(0).intValue();
                    log("[updateDefaultValues] to only primary sub " + intValue);
                    this.mSubController.setDefaultDataSubId(intValue);
                    this.mSubController.setDefaultVoiceSubId(intValue);
                    this.mSubController.setDefaultSmsSubId(intValue);
                    sendDefaultSubConfirmedNotification(intValue);
                }
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateDefaults$0(int i) {
        this.mSubController.setDefaultDataSubId(i);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateDefaults$1(int i) {
        this.mSubController.setDefaultVoiceSubId(i);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateDefaults$2(int i) {
        this.mSubController.setDefaultSmsSubId(i);
    }

    /* access modifiers changed from: protected */
    public int updatePrimarySubListAndGetChangeType(List<SubscriptionInfo> list) {
        boolean z;
        List<Integer> list2 = this.mPrimarySubList;
        List<Integer> list3 = (List) list.stream().filter(new MultiSimSettingController$$ExternalSyntheticLambda4()).map(new MultiSimSettingController$$ExternalSyntheticLambda5()).collect(Collectors.toList());
        this.mPrimarySubList = list3;
        if (this.mInitialHandling) {
            this.mInitialHandling = false;
            return 6;
        } else if (list3.equals(list2)) {
            return 0;
        } else {
            if (this.mPrimarySubList.size() > list2.size()) {
                return 1;
            }
            if (this.mPrimarySubList.size() == list2.size()) {
                for (Integer intValue : this.mPrimarySubList) {
                    int intValue2 = intValue.intValue();
                    Iterator<Integer> it = list2.iterator();
                    while (true) {
                        if (it.hasNext()) {
                            if (areSubscriptionsInSameGroup(intValue2, it.next().intValue())) {
                                z = true;
                                continue;
                                break;
                            }
                        } else {
                            z = false;
                            continue;
                            break;
                        }
                    }
                    if (!z) {
                        return 3;
                    }
                }
                return 4;
            }
            for (Integer intValue3 : list2) {
                int intValue4 = intValue3.intValue();
                if (!this.mPrimarySubList.contains(Integer.valueOf(intValue4))) {
                    if (!this.mSubController.isActiveSubId(intValue4)) {
                        for (Integer intValue5 : this.mPrimarySubList) {
                            if (areSubscriptionsInSameGroup(intValue5.intValue(), intValue4)) {
                                return 7;
                            }
                        }
                        return 2;
                    } else if (!this.mSubController.isOpportunistic(intValue4)) {
                        loge("[updatePrimarySubListAndGetChangeType]: missing active primary subId " + intValue4);
                    }
                }
            }
            return 5;
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$updatePrimarySubListAndGetChangeType$3(SubscriptionInfo subscriptionInfo) {
        return !subscriptionInfo.isOpportunistic();
    }

    /* access modifiers changed from: protected */
    public void sendDefaultSubConfirmedNotification(int i) {
        Intent intent = new Intent();
        intent.setAction("android.telephony.action.PRIMARY_SUBSCRIPTION_LIST_CHANGED");
        intent.setClassName("com.android.settings", "com.android.settings.sim.SimSelectNotification");
        intent.putExtra("android.telephony.extra.DEFAULT_SUBSCRIPTION_SELECT_TYPE", 5);
        intent.putExtra("android.telephony.extra.SUBSCRIPTION_ID", i);
        this.mContext.sendBroadcast(intent);
    }

    /* access modifiers changed from: protected */
    public void sendSubChangeNotificationIfNeeded(int i, boolean z, boolean z2, boolean z3) {
        int simSelectDialogType = getSimSelectDialogType(i, z, z2, z3);
        SimCombinationWarningParams simCombinationWarningParams = getSimCombinationWarningParams(i);
        if (simSelectDialogType != 0 || simCombinationWarningParams.mWarningType != 0) {
            log("[sendSubChangeNotificationIfNeeded] showing dialog type " + simSelectDialogType);
            log("[sendSubChangeNotificationIfNeeded] showing sim warning " + simCombinationWarningParams.mWarningType);
            Intent intent = new Intent();
            intent.setAction("android.telephony.action.PRIMARY_SUBSCRIPTION_LIST_CHANGED");
            intent.setClassName("com.android.settings", "com.android.settings.sim.SimSelectNotification");
            intent.addFlags(268435456);
            intent.putExtra("android.telephony.extra.DEFAULT_SUBSCRIPTION_SELECT_TYPE", simSelectDialogType);
            if (simSelectDialogType == 4) {
                intent.putExtra("android.telephony.extra.SUBSCRIPTION_ID", this.mPrimarySubList.get(0));
            }
            intent.putExtra("android.telephony.extra.SIM_COMBINATION_WARNING_TYPE", simCombinationWarningParams.mWarningType);
            if (simCombinationWarningParams.mWarningType == 1) {
                intent.putExtra("android.telephony.extra.SIM_COMBINATION_NAMES", simCombinationWarningParams.mSimNames);
            }
            this.mContext.sendBroadcast(intent);
        }
    }

    private int getSimSelectDialogType(int i, boolean z, boolean z2, boolean z3) {
        if (this.mPrimarySubList.size() == 1 && i == 2 && (!z || !z3 || !z2)) {
            return 4;
        }
        if (this.mPrimarySubList.size() <= 1) {
            return 0;
        }
        if (isUserVisibleChange(i) || (i == 6 && !z && Settings.Global.getInt(this.mContext.getContentResolver(), "device_provisioned", 0) != 0)) {
            return 1;
        }
        return 0;
    }

    public class SimCombinationWarningParams {
        String mSimNames;
        int mWarningType = 0;

        public SimCombinationWarningParams() {
        }
    }

    /* access modifiers changed from: protected */
    public SimCombinationWarningParams getSimCombinationWarningParams(int i) {
        SimCombinationWarningParams simCombinationWarningParams = new SimCombinationWarningParams();
        if (this.mPrimarySubList.size() <= 1 || !isUserVisibleChange(i)) {
            return simCombinationWarningParams;
        }
        ArrayList arrayList = new ArrayList();
        int i2 = 0;
        for (Integer intValue : this.mPrimarySubList) {
            int intValue2 = intValue.intValue();
            Phone phone = PhoneFactory.getPhone(SubscriptionManager.getPhoneId(intValue2));
            if (phone != null && phone.isCdmaSubscriptionAppPresent()) {
                i2++;
                String charSequence = this.mSubController.getActiveSubscriptionInfo(intValue2, this.mContext.getOpPackageName(), this.mContext.getAttributionTag()).getDisplayName().toString();
                if (TextUtils.isEmpty(charSequence)) {
                    charSequence = phone.getCarrierName();
                }
                arrayList.add(charSequence);
            }
        }
        if (i2 > 1) {
            simCombinationWarningParams.mWarningType = 1;
            simCombinationWarningParams.mSimNames = String.join(" & ", arrayList);
        }
        return simCombinationWarningParams;
    }

    /* access modifiers changed from: protected */
    public void disableDataForNonDefaultNonOpportunisticSubscriptions() {
        if (isReadyToReevaluate()) {
            int defaultDataSubId = this.mSubController.getDefaultDataSubId();
            for (Phone phone : PhoneFactory.getPhones()) {
                if (phone.getSubId() != defaultDataSubId && SubscriptionManager.isValidSubscriptionId(phone.getSubId()) && !this.mSubController.isOpportunistic(phone.getSubId()) && phone.isUserDataEnabled() && !areSubscriptionsInSameGroup(defaultDataSubId, phone.getSubId())) {
                    log("setting data to false on " + phone.getSubId());
                    if (phone.isUsingNewDataStack()) {
                        phone.getDataSettingsManager().setDataEnabled(0, false, this.mContext.getOpPackageName());
                    } else {
                        phone.getDataEnabledSettings().setDataEnabled(0, false);
                    }
                }
            }
        }
    }

    private boolean areSubscriptionsInSameGroup(int i, int i2) {
        if (!SubscriptionManager.isUsableSubscriptionId(i) || !SubscriptionManager.isUsableSubscriptionId(i2)) {
            return false;
        }
        if (i == i2) {
            return true;
        }
        ParcelUuid groupUuid = this.mSubController.getGroupUuid(i);
        ParcelUuid groupUuid2 = this.mSubController.getGroupUuid(i2);
        if (groupUuid == null || !groupUuid.equals(groupUuid2)) {
            return false;
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public void setUserDataEnabledForGroup(int i, boolean z) {
        log("setUserDataEnabledForGroup subId " + i + " enable " + z);
        SubscriptionController subscriptionController = this.mSubController;
        List<SubscriptionInfo> subscriptionsInGroup = subscriptionController.getSubscriptionsInGroup(subscriptionController.getGroupUuid(i), this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
        if (subscriptionsInGroup != null) {
            for (SubscriptionInfo subscriptionId : subscriptionsInGroup) {
                int subscriptionId2 = subscriptionId.getSubscriptionId();
                if (this.mSubController.isActiveSubId(subscriptionId2)) {
                    Phone phone = PhoneFactory.getPhone(this.mSubController.getPhoneId(subscriptionId2));
                    if (phone != null) {
                        if (phone.isUsingNewDataStack()) {
                            phone.getDataSettingsManager().setDataEnabled(0, z, this.mContext.getOpPackageName());
                        } else {
                            phone.getDataEnabledSettings().setUserDataEnabled(z, false);
                        }
                    }
                } else {
                    GlobalSettingsHelper.setBoolean(this.mContext, "mobile_data", subscriptionId2, z);
                }
            }
        }
    }

    private void setRoamingDataEnabledForGroup(int i, boolean z) {
        List<SubscriptionInfo> subscriptionsInGroup = SubscriptionController.getInstance().getSubscriptionsInGroup(this.mSubController.getGroupUuid(i), this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
        if (subscriptionsInGroup != null) {
            for (SubscriptionInfo subscriptionId : subscriptionsInGroup) {
                GlobalSettingsHelper.setBoolean(this.mContext, "data_roaming", subscriptionId.getSubscriptionId(), z);
            }
        }
    }

    /* access modifiers changed from: protected */
    public boolean updateDefaultValue(List<Integer> list, int i, UpdateDefaultAction updateDefaultAction) {
        return updateDefaultValue(list, i, updateDefaultAction, true);
    }

    /* access modifiers changed from: protected */
    public boolean updateDefaultValue(List<Integer> list, int i, UpdateDefaultAction updateDefaultAction, boolean z) {
        int i2 = -1;
        if (list.size() > 0) {
            Iterator<Integer> it = list.iterator();
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                int intValue = it.next().intValue();
                log("[updateDefaultValue] Record.id: " + intValue);
                if (areSubscriptionsInSameGroup(intValue, i) || (!z && i == -1)) {
                    log("[updateDefaultValue] updates to subId=" + intValue);
                    i2 = intValue;
                }
            }
        }
        if (i != i2) {
            log("[updateDefaultValue: subId] from " + i + " to " + i2);
            updateDefaultAction.update(i2);
        }
        return SubscriptionManager.isValidSubscriptionId(i2);
    }

    private void deactivateGroupedOpportunisticSubscriptionIfNeeded() {
        if (SubscriptionInfoUpdater.isSubInfoInitialized()) {
            List<SubscriptionInfo> opportunisticSubscriptions = this.mSubController.getOpportunisticSubscriptions(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
            if (!ArrayUtils.isEmpty(opportunisticSubscriptions)) {
                for (SubscriptionInfo next : opportunisticSubscriptions) {
                    if (next.isGroupDisabled() && this.mSubController.isActiveSubId(next.getSubscriptionId())) {
                        log("[deactivateGroupedOpptSubIfNeeded] Deactivating grouped opportunistic subscription " + next.getSubscriptionId());
                        deactivateSubscription(next);
                    }
                }
            }
        }
    }

    private void deactivateSubscription(SubscriptionInfo subscriptionInfo) {
        if (subscriptionInfo.isEmbedded()) {
            log("[deactivateSubscription] eSIM profile " + subscriptionInfo.getSubscriptionId());
            ((EuiccManager) this.mContext.getSystemService("euicc")).switchToSubscription(-1, subscriptionInfo.getPortIndex(), PendingIntent.getService(this.mContext, 0, new Intent(), 67108864));
        }
    }

    /* access modifiers changed from: protected */
    public void updateUserPreferences(List<Integer> list, boolean z, boolean z2, boolean z3) {
        if (!list.isEmpty() && this.mSubController.getActiveSubInfoCountMax() != 1) {
            if (!isRadioAvailableOnAllSubs()) {
                log("Radio is in Invalid state, Ignore Updating User Preference!!!");
                return;
            }
            int defaultDataSubId = this.mSubController.getDefaultDataSubId();
            log("updateUserPreferences:  dds = " + defaultDataSubId + " voice = " + this.mSubController.getDefaultVoiceSubId() + " sms = " + this.mSubController.getDefaultSmsSubId());
            int intValue = list.get(0).intValue();
            if (list.size() == 1 && !z3) {
                this.mSubController.setDefaultSmsSubId(intValue);
            }
            if (list.size() == 1 && !z2) {
                this.mSubController.setDefaultVoiceSubId(intValue);
            }
            int userPrefDataSubIdFromDB = getUserPrefDataSubIdFromDB();
            log("User pref subId = " + userPrefDataSubIdFromDB + " current dds " + defaultDataSubId + " next active subId " + intValue);
            if (list.contains(Integer.valueOf(userPrefDataSubIdFromDB)) && SubscriptionManager.isValidSubscriptionId(userPrefDataSubIdFromDB) && defaultDataSubId != userPrefDataSubIdFromDB) {
                this.mSubController.setDefaultDataSubId(userPrefDataSubIdFromDB);
            } else if (!z) {
                this.mSubController.setDefaultDataSubId(intValue);
            }
            log("updateUserPreferences: after dds = " + this.mSubController.getDefaultDataSubId() + " voice = " + this.mSubController.getDefaultVoiceSubId() + " sms = " + this.mSubController.getDefaultSmsSubId());
        }
    }

    private int getUserPrefDataSubIdFromDB() {
        return Settings.Global.getInt(this.mContext.getContentResolver(), SETTING_USER_PREF_DATA_SUB, -1);
    }

    private boolean isRadioAvailableOnAllSubs() {
        for (Phone phone : PhoneFactory.getPhones()) {
            CommandsInterface commandsInterface = phone.mCi;
            if ((commandsInterface != null && commandsInterface.getRadioState() == 2) || phone.isShuttingDown()) {
                return false;
            }
        }
        return true;
    }

    private void registerDataSettingsControllerCallbackAsNeeded() {
        Phone[] phones = PhoneFactory.getPhones();
        for (int i = this.mCallbacksCount; i < phones.length; i++) {
            if (phones[i].isUsingNewDataStack()) {
                phones[i].getDataSettingsManager().registerCallback(new DataSettingsControllerCallback(phones[i], new MultiSimSettingController$$ExternalSyntheticLambda3(this)));
            }
        }
        this.mCallbacksCount = phones.length;
    }

    private void log(String str) {
        Log.d(LOG_TAG, str);
    }

    private void loge(String str) {
        Log.e(LOG_TAG, str);
    }
}
