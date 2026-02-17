package com.android.internal.telephony.uicc;

import android.app.ActivityManager;
import android.app.usage.UsageStatsManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.database.ContentObserver;
import android.os.AsyncResult;
import android.os.Binder;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.UserManager;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.telephony.CarrierConfigManager;
import android.telephony.ServiceState;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.UiccAccessRule;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.ArraySet;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CarrierAppUtils;
import com.android.internal.telephony.CarrierPrivilegesTracker;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.IccCard;
import com.android.internal.telephony.IccCardConstants;
import com.android.internal.telephony.MccTable;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.TelephonyStatsLog;
import com.android.internal.telephony.cat.CatService;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.euicc.EuiccCard;
import com.android.internal.telephony.util.NetworkStackConstants;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class UiccProfile extends IccCard {
    protected static final boolean DBG = true;
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public static final int EVENT_APP_READY = 3;
    private static final int EVENT_CARRIER_CONFIG_CHANGED = 14;
    private static final int EVENT_CARRIER_PRIVILEGES_LOADED = 13;
    private static final int EVENT_CARRIER_PRIVILEGES_TEST_OVERRIDE_SET = 15;
    private static final int EVENT_CLOSE_LOGICAL_CHANNEL_DONE = 9;
    private static final int EVENT_EID_READY = 6;
    private static final int EVENT_ICC_LOCKED = 2;
    private static final int EVENT_ICC_RECORD_EVENTS = 7;
    private static final int EVENT_NETWORK_LOCKED = 5;
    private static final int EVENT_OPEN_LOGICAL_CHANNEL_DONE = 8;
    private static final int EVENT_RADIO_OFF_OR_UNAVAILABLE = 1;
    private static final int EVENT_RECORDS_LOADED = 4;
    private static final int EVENT_SIM_IO_DONE = 12;
    private static final int EVENT_SUPPLY_ICC_PIN_DONE = 16;
    private static final int EVENT_TRANSMIT_APDU_BASIC_CHANNEL_DONE = 11;
    private static final int EVENT_TRANSMIT_APDU_LOGICAL_CHANNEL_DONE = 10;
    protected static final String LOG_TAG = "UiccProfile";
    private static final String OPERATOR_BRAND_OVERRIDE_PREFIX = "operator_branding_";
    private static final boolean VDBG = false;
    private final BroadcastReceiver mCarrierConfigChangedReceiver;
    private UiccCarrierPrivilegeRules mCarrierPrivilegeRules;
    private CatService mCatService;
    private int mCdmaSubscriptionAppIndex;
    protected CommandsInterface mCi;
    protected Context mContext;
    @VisibleForTesting
    public int mCurrentAppType;
    protected boolean mDisposed;
    protected IccCardConstants.State mExternalState;
    private int mGsmUmtsSubscriptionAppIndex;
    @VisibleForTesting
    public final Handler mHandler;
    protected IccRecords mIccRecords;
    private int mImsSubscriptionAppIndex;
    private int mLastReportedNumOfUiccApplications;
    protected final Object mLock;
    /* access modifiers changed from: private */
    public RegistrantList mNetworkLockedRegistrants;
    private RegistrantList mOperatorBrandOverrideRegistrants;
    /* access modifiers changed from: private */
    public final int mPhoneId;
    /* access modifiers changed from: private */
    public final PinStorage mPinStorage;
    private final ContentObserver mProvisionCompleteContentObserver;
    /* access modifiers changed from: private */
    public boolean mProvisionCompleteContentObserverRegistered;
    private int mRadioTech;
    protected TelephonyManager mTelephonyManager;
    /* access modifiers changed from: private */
    public UiccCarrierPrivilegeRules mTestOverrideCarrierPrivilegeRules;
    protected UiccCardApplication mUiccApplication;
    private UiccCardApplication[] mUiccApplications = new UiccCardApplication[8];
    protected final UiccCard mUiccCard;
    private IccCardStatus.PinState mUniversalPinState;
    private final BroadcastReceiver mUserUnlockReceiver;
    /* access modifiers changed from: private */
    public boolean mUserUnlockReceiverRegistered;

    public UiccProfile(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus, int i, UiccCard uiccCard, Object obj) {
        boolean z = false;
        this.mDisposed = false;
        this.mOperatorBrandOverrideRegistrants = new RegistrantList();
        this.mNetworkLockedRegistrants = new RegistrantList();
        this.mCurrentAppType = 1;
        this.mRadioTech = 0;
        this.mUiccApplication = null;
        this.mIccRecords = null;
        this.mExternalState = IccCardConstants.State.UNKNOWN;
        this.mProvisionCompleteContentObserver = new ContentObserver(new Handler()) {
            public void onChange(boolean z) {
                synchronized (UiccProfile.this.mLock) {
                    UiccProfile.this.mContext.getContentResolver().unregisterContentObserver(this);
                    UiccProfile.this.mProvisionCompleteContentObserverRegistered = false;
                    UiccProfile.this.showCarrierAppNotificationsIfPossible();
                }
            }
        };
        this.mUserUnlockReceiver = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                synchronized (UiccProfile.this.mLock) {
                    UiccProfile.this.mContext.unregisterReceiver(this);
                    UiccProfile.this.mUserUnlockReceiverRegistered = false;
                    UiccProfile.this.showCarrierAppNotificationsIfPossible();
                }
            }
        };
        AnonymousClass3 r3 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                    Handler handler = UiccProfile.this.mHandler;
                    handler.sendMessage(handler.obtainMessage(14));
                }
            }
        };
        this.mCarrierConfigChangedReceiver = r3;
        AnonymousClass4 r4 = new Handler() {
            public void handleMessage(Message message) {
                CarrierPrivilegesTracker carrierPrivilegesTracker;
                int i;
                String r0 = UiccProfile.eventToString(message.what);
                UiccProfile uiccProfile = UiccProfile.this;
                if (!uiccProfile.mDisposed || (i = message.what) == 8 || i == 9 || i == 10 || i == 11 || i == 12) {
                    uiccProfile.logWithLocalLog("handleMessage: Received " + r0 + " for phoneId " + UiccProfile.this.mPhoneId);
                    int i2 = 2;
                    switch (message.what) {
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                        case 6:
                            break;
                        case 5:
                            UiccProfile uiccProfile2 = UiccProfile.this;
                            if (uiccProfile2.mUiccApplication == null) {
                                uiccProfile2.log("EVENT_NETWORK_LOCKED: mUiccApplication is NULL, mNetworkLockedRegistrants not notified.");
                                break;
                            } else {
                                uiccProfile2.mNetworkLockedRegistrants.notifyRegistrants(new AsyncResult((Object) null, Integer.valueOf(UiccProfile.this.mUiccApplication.getPersoSubState().ordinal()), (Throwable) null));
                                break;
                            }
                        case 7:
                            UiccProfile uiccProfile3 = UiccProfile.this;
                            if (uiccProfile3.mCurrentAppType == 1 && uiccProfile3.mIccRecords != null && ((Integer) ((AsyncResult) message.obj).result).intValue() == 2) {
                                UiccProfile uiccProfile4 = UiccProfile.this;
                                uiccProfile4.mTelephonyManager.setSimOperatorNameForPhone(uiccProfile4.mPhoneId, UiccProfile.this.mIccRecords.getServiceProviderName());
                                return;
                            }
                            return;
                        case 8:
                        case 9:
                        case 10:
                        case 11:
                        case 12:
                            AsyncResult asyncResult = (AsyncResult) message.obj;
                            if (asyncResult.exception != null) {
                                UiccProfile.this.logWithLocalLog("handleMessage: Error in SIM access with exception " + asyncResult.exception);
                            }
                            Object obj = asyncResult.userObj;
                            if (obj != null) {
                                AsyncResult.forMessage((Message) obj, asyncResult.result, asyncResult.exception);
                                ((Message) asyncResult.userObj).sendToTarget();
                                return;
                            }
                            UiccProfile.this.loge("handleMessage: ar.userObj is null in event:" + r0 + ", failed to post status back to caller");
                            return;
                        case 13:
                            Phone phone = PhoneFactory.getPhone(UiccProfile.this.mPhoneId);
                            if (!(phone == null || (carrierPrivilegesTracker = phone.getCarrierPrivilegesTracker()) == null)) {
                                carrierPrivilegesTracker.onUiccAccessRulesLoaded();
                            }
                            UiccProfile.this.onCarrierPrivilegesLoadedMessage();
                            UiccProfile.this.updateExternalState();
                            return;
                        case 14:
                            UiccProfile.this.handleCarrierNameOverride();
                            UiccProfile.this.handleSimCountryIsoOverride();
                            return;
                        case 15:
                            Object obj2 = message.obj;
                            if (obj2 == null) {
                                UiccProfile.this.mTestOverrideCarrierPrivilegeRules = null;
                            } else {
                                UiccProfile.this.mTestOverrideCarrierPrivilegeRules = new UiccCarrierPrivilegeRules((List) obj2);
                            }
                            UiccProfile.this.refresh();
                            return;
                        case 16:
                            AsyncResult asyncResult2 = (AsyncResult) message.obj;
                            if (asyncResult2.exception != null) {
                                UiccProfile.this.loge("An error occurred during internal PIN verification");
                                UiccProfile.this.mPinStorage.clearPin(UiccProfile.this.mPhoneId);
                                UiccProfile.this.updateExternalState();
                            } else {
                                UiccProfile.this.log("Internal PIN verification was successful!");
                            }
                            if (asyncResult2.exception == null) {
                                i2 = 1;
                            }
                            TelephonyStatsLog.write(336, i2, 1);
                            return;
                        default:
                            UiccProfile.this.loge("handleMessage: Unhandled message with number: " + message.what);
                            return;
                    }
                    UiccProfile.this.updateExternalState();
                    return;
                }
                uiccProfile.loge("handleMessage: Received " + r0 + " after dispose(); ignoring the message");
            }
        };
        this.mHandler = r4;
        log("Creating profile");
        this.mLock = obj;
        this.mUiccCard = uiccCard;
        this.mPhoneId = i;
        Phone phone = PhoneFactory.getPhone(i);
        if (phone != null) {
            setCurrentAppType(phone.getPhoneType() == 1 ? true : z);
        }
        if (uiccCard instanceof EuiccCard) {
            ((EuiccCard) uiccCard).registerForEidReady(r4, 6, (Object) null);
        }
        this.mPinStorage = UiccController.getInstance().getPinStorage();
        update(context, commandsInterface, iccCardStatus);
        commandsInterface.registerForOffOrNotAvailable(r4, 1, (Object) null);
        resetProperties();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        context.registerReceiver(r3, intentFilter);
    }

    public void dispose() {
        log("Disposing profile");
        UiccCard uiccCard = this.mUiccCard;
        if (uiccCard instanceof EuiccCard) {
            ((EuiccCard) uiccCard).unregisterForEidReady(this.mHandler);
        }
        synchronized (this.mLock) {
            unregisterAllAppEvents();
            unregisterCurrAppEvents();
            if (this.mProvisionCompleteContentObserverRegistered) {
                this.mContext.getContentResolver().unregisterContentObserver(this.mProvisionCompleteContentObserver);
                this.mProvisionCompleteContentObserverRegistered = false;
            }
            if (this.mUserUnlockReceiverRegistered) {
                this.mContext.unregisterReceiver(this.mUserUnlockReceiver);
                this.mUserUnlockReceiverRegistered = false;
            }
            InstallCarrierAppUtils.hideAllNotifications(this.mContext);
            InstallCarrierAppUtils.unregisterPackageInstallReceiver(this.mContext);
            this.mCi.unregisterForOffOrNotAvailable(this.mHandler);
            this.mContext.unregisterReceiver(this.mCarrierConfigChangedReceiver);
            CatService catService = this.mCatService;
            if (catService != null) {
                catService.dispose();
            }
            for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
                if (uiccCardApplication != null) {
                    uiccCardApplication.dispose();
                }
            }
            this.mCatService = null;
            this.mUiccApplications = null;
            this.mRadioTech = 0;
            this.mCarrierPrivilegeRules = null;
            this.mContext.getContentResolver().unregisterContentObserver(this.mProvisionCompleteContentObserver);
            this.mDisposed = true;
        }
    }

    public void setVoiceRadioTech(int i) {
        synchronized (this.mLock) {
            log("Setting radio tech " + ServiceState.rilRadioTechnologyToString(i));
            this.mRadioTech = i;
            setCurrentAppType(ServiceState.isGsm(i));
            updateIccAvailability(false);
        }
    }

    /* access modifiers changed from: protected */
    public void setCurrentAppType(boolean z) {
        int i = 1;
        int i2 = 2;
        if (!z) {
            i2 = 1;
            i = 2;
        }
        synchronized (this.mLock) {
            if (getApplication(i) == null) {
                if (getApplication(i2) != null) {
                    this.mCurrentAppType = i2;
                }
            }
            this.mCurrentAppType = i;
        }
    }

    /* access modifiers changed from: private */
    public void handleCarrierNameOverride() {
        Phone phone;
        SubscriptionController instance = SubscriptionController.getInstance();
        int subIdUsingPhoneId = instance.getSubIdUsingPhoneId(this.mPhoneId);
        if (subIdUsingPhoneId == -1) {
            loge("subId not valid for Phone " + this.mPhoneId);
            return;
        }
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config");
        if (carrierConfigManager == null) {
            loge("Failed to load a Carrier Config");
            return;
        }
        PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(subIdUsingPhoneId);
        int i = 0;
        boolean z = configForSubId.getBoolean("carrier_name_override_bool", false);
        String string = configForSubId.getString("carrier_name_string");
        String serviceProviderName = getServiceProviderName();
        if (z || (TextUtils.isEmpty(serviceProviderName) && !TextUtils.isEmpty(string))) {
            i = 3;
        } else if (!TextUtils.isEmpty(serviceProviderName) || (phone = PhoneFactory.getPhone(this.mPhoneId)) == null) {
            string = null;
            i = 1;
        } else {
            String plmn = phone.getPlmn();
            if (!TextUtils.isEmpty(plmn)) {
                i = 4;
                string = plmn;
            } else {
                string = phone.getCarrierName();
            }
        }
        if (isUdpateCarrierName(string)) {
            this.mTelephonyManager.setSimOperatorNameForPhone(this.mPhoneId, string);
            this.mOperatorBrandOverrideRegistrants.notifyRegistrants();
        }
        updateCarrierNameForSubscription(instance, subIdUsingPhoneId, i);
    }

    /* access modifiers changed from: private */
    public void handleSimCountryIsoOverride() {
        SubscriptionController instance = SubscriptionController.getInstance();
        int subIdUsingPhoneId = instance.getSubIdUsingPhoneId(this.mPhoneId);
        if (subIdUsingPhoneId == -1) {
            loge("subId not valid for Phone " + this.mPhoneId);
            return;
        }
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config");
        if (carrierConfigManager == null) {
            loge("Failed to load a Carrier Config");
            return;
        }
        String string = carrierConfigManager.getConfigForSubId(subIdUsingPhoneId).getString("sim_country_iso_override_string");
        if (!TextUtils.isEmpty(string) && !string.equals(TelephonyManager.getSimCountryIsoForPhone(this.mPhoneId))) {
            this.mTelephonyManager.setSimCountryIsoForPhone(this.mPhoneId, string);
            instance.setCountryIso(string, subIdUsingPhoneId);
        }
    }

    private void updateCarrierNameForSubscription(SubscriptionController subscriptionController, int i, int i2) {
        SubscriptionInfo activeSubscriptionInfo = subscriptionController.getActiveSubscriptionInfo(i, this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
        if (activeSubscriptionInfo != null) {
            CharSequence displayName = activeSubscriptionInfo.getDisplayName();
            String subscriptionDisplayName = getSubscriptionDisplayName(i, this.mContext);
            if (!TextUtils.isEmpty(subscriptionDisplayName) && !subscriptionDisplayName.equals(displayName)) {
                log("sim name[" + this.mPhoneId + "] = " + subscriptionDisplayName);
                subscriptionController.setDisplayNameUsingSrc(subscriptionDisplayName, i, i2);
            }
        }
    }

    private void updateIccAvailability(boolean z) {
        synchronized (this.mLock) {
            IccRecords iccRecords = null;
            UiccCardApplication application = getApplication(this.mCurrentAppType);
            if (application != null) {
                iccRecords = application.getIccRecords();
            }
            if (z) {
                unregisterAllAppEvents();
                registerAllAppEvents();
            }
            if (!(this.mIccRecords == iccRecords && this.mUiccApplication == application)) {
                log("Icc changed. Reregistering.");
                unregisterCurrAppEvents();
                this.mUiccApplication = application;
                this.mIccRecords = iccRecords;
                registerCurrAppEvents();
            }
            updateExternalState();
        }
    }

    /* access modifiers changed from: package-private */
    public void resetProperties() {
        if (this.mCurrentAppType == 1) {
            log("update icc_operator_numeric=");
            this.mTelephonyManager.setSimOperatorNumericForPhone(this.mPhoneId, "");
            this.mTelephonyManager.setSimCountryIsoForPhone(this.mPhoneId, "");
            this.mTelephonyManager.setSimOperatorNameForPhone(this.mPhoneId, "");
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:34:0x007c  */
    /* JADX WARNING: Removed duplicated region for block: B:48:0x00d9  */
    @com.android.internal.annotations.VisibleForTesting(visibility = com.android.internal.annotations.VisibleForTesting.Visibility.PRIVATE)
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void updateExternalState() {
        /*
            r6 = this;
            com.android.internal.telephony.uicc.UiccCard r0 = r6.mUiccCard
            com.android.internal.telephony.uicc.IccCardStatus$CardState r0 = r0.getCardState()
            com.android.internal.telephony.uicc.IccCardStatus$CardState r1 = com.android.internal.telephony.uicc.IccCardStatus.CardState.CARDSTATE_ERROR
            if (r0 != r1) goto L_0x0010
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.CARD_IO_ERROR
            r6.setExternalState(r0)
            return
        L_0x0010:
            com.android.internal.telephony.uicc.UiccCard r0 = r6.mUiccCard
            com.android.internal.telephony.uicc.IccCardStatus$CardState r0 = r0.getCardState()
            com.android.internal.telephony.uicc.IccCardStatus$CardState r1 = com.android.internal.telephony.uicc.IccCardStatus.CardState.CARDSTATE_RESTRICTED
            if (r0 != r1) goto L_0x0020
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.CARD_RESTRICTED
            r6.setExternalState(r0)
            return
        L_0x0020:
            com.android.internal.telephony.uicc.UiccCard r0 = r6.mUiccCard
            boolean r1 = r0 instanceof com.android.internal.telephony.uicc.euicc.EuiccCard
            if (r1 == 0) goto L_0x0034
            com.android.internal.telephony.uicc.euicc.EuiccCard r0 = (com.android.internal.telephony.uicc.euicc.EuiccCard) r0
            java.lang.String r0 = r0.getEid()
            if (r0 != 0) goto L_0x0034
            java.lang.String r0 = "EID is not ready yet."
            r6.log(r0)
            return
        L_0x0034:
            com.android.internal.telephony.uicc.UiccCardApplication r0 = r6.mUiccApplication
            if (r0 != 0) goto L_0x0044
            java.lang.String r0 = "updateExternalState: setting state to NOT_READY because mUiccApplication is null"
            r6.loge(r0)
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.NOT_READY
            r6.setExternalState(r0)
            return
        L_0x0044:
            r1 = 0
            r2 = 0
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r0 = r0.getState()
            com.android.internal.telephony.uicc.UiccCardApplication r3 = r6.mUiccApplication
            com.android.internal.telephony.uicc.IccCardStatus$PinState r3 = r3.getPin1State()
            com.android.internal.telephony.uicc.IccCardStatus$PinState r4 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_ENABLED_PERM_BLOCKED
            r5 = 1
            if (r3 != r4) goto L_0x0059
            com.android.internal.telephony.IccCardConstants$State r2 = com.android.internal.telephony.IccCardConstants.State.PERM_DISABLED
        L_0x0057:
            r1 = r5
            goto L_0x007a
        L_0x0059:
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r3 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_PIN
            if (r0 != r3) goto L_0x0060
            com.android.internal.telephony.IccCardConstants$State r2 = com.android.internal.telephony.IccCardConstants.State.PIN_REQUIRED
            goto L_0x0057
        L_0x0060:
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r3 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_PUK
            if (r0 != r3) goto L_0x0067
            com.android.internal.telephony.IccCardConstants$State r2 = com.android.internal.telephony.IccCardConstants.State.PUK_REQUIRED
            goto L_0x0057
        L_0x0067:
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r3 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_SUBSCRIPTION_PERSO
            if (r0 != r3) goto L_0x007a
            com.android.internal.telephony.uicc.UiccCardApplication r3 = r6.mUiccApplication
            com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r3 = r3.getPersoSubState()
            boolean r3 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.isPersoLocked(r3)
            if (r3 == 0) goto L_0x007a
            com.android.internal.telephony.IccCardConstants$State r2 = com.android.internal.telephony.IccCardConstants.State.NETWORK_LOCKED
            goto L_0x0057
        L_0x007a:
            if (r1 == 0) goto L_0x00d9
            com.android.internal.telephony.uicc.IccRecords r0 = r6.mIccRecords
            if (r0 == 0) goto L_0x00d3
            boolean r0 = r0.getLockedRecordsLoaded()
            if (r0 != 0) goto L_0x008e
            com.android.internal.telephony.uicc.IccRecords r0 = r6.mIccRecords
            boolean r0 = r0.getNetworkLockedRecordsLoaded()
            if (r0 == 0) goto L_0x00d3
        L_0x008e:
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.PIN_REQUIRED
            if (r2 != r0) goto L_0x00cf
            com.android.internal.telephony.uicc.PinStorage r0 = r6.mPinStorage
            int r1 = r6.mPhoneId
            com.android.internal.telephony.uicc.IccRecords r3 = r6.mIccRecords
            java.lang.String r3 = r3.getFullIccId()
            java.lang.String r0 = r0.getPin(r1, r3)
            boolean r1 = r0.isEmpty()
            if (r1 != 0) goto L_0x00cf
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "PIN_REQUIRED["
            r1.append(r2)
            int r2 = r6.mPhoneId
            r1.append(r2)
            java.lang.String r2 = "] - Cache present"
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            r6.log(r1)
            com.android.internal.telephony.CommandsInterface r1 = r6.mCi
            android.os.Handler r6 = r6.mHandler
            r2 = 16
            android.os.Message r6 = r6.obtainMessage(r2)
            r1.supplyIccPin(r0, r6)
            return
        L_0x00cf:
            r6.setExternalState(r2)
            goto L_0x00d8
        L_0x00d3:
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.NOT_READY
            r6.setExternalState(r0)
        L_0x00d8:
            return
        L_0x00d9:
            int[] r1 = com.android.internal.telephony.uicc.UiccProfile.AnonymousClass5.$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppState
            int r0 = r0.ordinal()
            r0 = r1[r0]
            if (r0 == r5) goto L_0x0117
            r1 = 2
            if (r0 == r1) goto L_0x0111
            r1 = 3
            if (r0 == r1) goto L_0x00ea
            goto L_0x011c
        L_0x00ea:
            r6.checkAndUpdateIfAnyAppToBeIgnored()
            boolean r0 = r6.areAllApplicationsReady()
            if (r0 == 0) goto L_0x010b
            boolean r0 = r6.areAllRecordsLoaded()
            if (r0 == 0) goto L_0x0105
            boolean r0 = r6.areCarrierPrivilegeRulesLoaded()
            if (r0 == 0) goto L_0x0105
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.LOADED
            r6.setExternalState(r0)
            goto L_0x011c
        L_0x0105:
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.READY
            r6.setExternalState(r0)
            goto L_0x011c
        L_0x010b:
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.NOT_READY
            r6.setExternalState(r0)
            goto L_0x011c
        L_0x0111:
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.NOT_READY
            r6.setExternalState(r0)
            goto L_0x011c
        L_0x0117:
            com.android.internal.telephony.IccCardConstants$State r0 = com.android.internal.telephony.IccCardConstants.State.NOT_READY
            r6.setExternalState(r0)
        L_0x011c:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.updateExternalState():void");
    }

    private void registerAllAppEvents() {
        for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
            if (uiccCardApplication != null) {
                uiccCardApplication.registerForReady(this.mHandler, 3, (Object) null);
                IccRecords iccRecords = uiccCardApplication.getIccRecords();
                if (iccRecords != null) {
                    iccRecords.registerForRecordsLoaded(this.mHandler, 4, (Object) null);
                    iccRecords.registerForRecordsEvents(this.mHandler, 7, (Object) null);
                }
            }
        }
    }

    private void unregisterAllAppEvents() {
        for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
            if (uiccCardApplication != null) {
                uiccCardApplication.unregisterForReady(this.mHandler);
                IccRecords iccRecords = uiccCardApplication.getIccRecords();
                if (iccRecords != null) {
                    iccRecords.unregisterForRecordsLoaded(this.mHandler);
                    iccRecords.unregisterForRecordsEvents(this.mHandler);
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void registerCurrAppEvents() {
        IccRecords iccRecords = this.mIccRecords;
        if (iccRecords != null) {
            iccRecords.registerForLockedRecordsLoaded(this.mHandler, 2, (Object) null);
            this.mIccRecords.registerForNetworkLockedRecordsLoaded(this.mHandler, 5, (Object) null);
        }
    }

    /* access modifiers changed from: protected */
    public void unregisterCurrAppEvents() {
        IccRecords iccRecords = this.mIccRecords;
        if (iccRecords != null) {
            iccRecords.unregisterForLockedRecordsLoaded(this.mHandler);
            this.mIccRecords.unregisterForNetworkLockedRecordsLoaded(this.mHandler);
        }
    }

    /* access modifiers changed from: protected */
    public void setExternalState(IccCardConstants.State state, boolean z) {
        IccRecords iccRecords;
        synchronized (this.mLock) {
            if (!SubscriptionManager.isValidSlotIndex(this.mPhoneId)) {
                loge("setExternalState: mPhoneId=" + this.mPhoneId + " is invalid; Return!!");
            } else if (z || state != this.mExternalState) {
                this.mExternalState = state;
                if (state == IccCardConstants.State.LOADED && (iccRecords = this.mIccRecords) != null) {
                    String operatorNumeric = iccRecords.getOperatorNumeric();
                    log("setExternalState: operator=" + operatorNumeric + " mPhoneId=" + this.mPhoneId);
                    if (!TextUtils.isEmpty(operatorNumeric)) {
                        this.mTelephonyManager.setSimOperatorNumericForPhone(this.mPhoneId, operatorNumeric);
                        String substring = operatorNumeric.substring(0, 3);
                        if (substring != null) {
                            this.mTelephonyManager.setSimCountryIsoForPhone(this.mPhoneId, MccTable.countryCodeForMcc(substring));
                        } else {
                            loge("setExternalState: state LOADED; Country code is null");
                        }
                    } else {
                        loge("setExternalState: state LOADED; Operator name is null");
                    }
                }
                log("setExternalState: set mPhoneId=" + this.mPhoneId + " mExternalState=" + this.mExternalState);
                Context context = this.mContext;
                IccCardConstants.State state2 = this.mExternalState;
                UiccController.updateInternalIccState(context, state2, getIccStateReason(state2), this.mPhoneId);
            } else {
                log("setExternalState: !override and newstate unchanged from " + state);
            }
        }
    }

    /* access modifiers changed from: protected */
    public void setExternalState(IccCardConstants.State state) {
        setExternalState(state, false);
    }

    public boolean getIccRecordsLoaded() {
        synchronized (this.mLock) {
            IccRecords iccRecords = this.mIccRecords;
            if (iccRecords == null) {
                return false;
            }
            boolean recordsLoaded = iccRecords.getRecordsLoaded();
            return recordsLoaded;
        }
    }

    /* renamed from: com.android.internal.telephony.uicc.UiccProfile$5  reason: invalid class name */
    static /* synthetic */ class AnonymousClass5 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$IccCardConstants$State;
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppState;

        /* JADX WARNING: Can't wrap try/catch for region: R(22:0|1|2|3|(2:5|6)|7|9|10|11|12|13|14|15|16|17|19|20|21|22|23|24|26) */
        /* JADX WARNING: Code restructure failed: missing block: B:27:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0033 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x005a */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0064 */
        static {
            /*
                com.android.internal.telephony.IccCardConstants$State[] r0 = com.android.internal.telephony.IccCardConstants.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$IccCardConstants$State = r0
                r1 = 1
                com.android.internal.telephony.IccCardConstants$State r2 = com.android.internal.telephony.IccCardConstants.State.PIN_REQUIRED     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.IccCardConstants$State r3 = com.android.internal.telephony.IccCardConstants.State.PUK_REQUIRED     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.IccCardConstants$State r4 = com.android.internal.telephony.IccCardConstants.State.NETWORK_LOCKED     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r3 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.IccCardConstants$State r4 = com.android.internal.telephony.IccCardConstants.State.PERM_DISABLED     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r5 = 4
                r3[r4] = r5     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r3 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.IccCardConstants$State r4 = com.android.internal.telephony.IccCardConstants.State.CARD_IO_ERROR     // Catch:{ NoSuchFieldError -> 0x003e }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r5 = 5
                r3[r4] = r5     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r3 = $SwitchMap$com$android$internal$telephony$IccCardConstants$State     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.IccCardConstants$State r4 = com.android.internal.telephony.IccCardConstants.State.CARD_RESTRICTED     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r5 = 6
                r3[r4] = r5     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState[] r3 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.values()
                int r3 = r3.length
                int[] r3 = new int[r3]
                $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppState = r3
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r4 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_UNKNOWN     // Catch:{ NoSuchFieldError -> 0x005a }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x005a }
                r3[r4] = r1     // Catch:{ NoSuchFieldError -> 0x005a }
            L_0x005a:
                int[] r1 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppState     // Catch:{ NoSuchFieldError -> 0x0064 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r3 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_DETECTED     // Catch:{ NoSuchFieldError -> 0x0064 }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x0064 }
                r1[r3] = r0     // Catch:{ NoSuchFieldError -> 0x0064 }
            L_0x0064:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppState     // Catch:{ NoSuchFieldError -> 0x006e }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_READY     // Catch:{ NoSuchFieldError -> 0x006e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006e }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006e }
            L_0x006e:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.AnonymousClass5.<clinit>():void");
        }
    }

    /* access modifiers changed from: protected */
    public String getIccStateReason(IccCardConstants.State state) {
        switch (AnonymousClass5.$SwitchMap$com$android$internal$telephony$IccCardConstants$State[state.ordinal()]) {
            case 1:
                return "PIN";
            case 2:
                return "PUK";
            case 3:
                return "NETWORK";
            case 4:
                return "PERM_DISABLED";
            case 5:
                return "CARD_IO_ERROR";
            case 6:
                return "CARD_RESTRICTED";
            default:
                return null;
        }
    }

    public IccCardConstants.State getState() {
        IccCardConstants.State state;
        synchronized (this.mLock) {
            state = this.mExternalState;
        }
        return state;
    }

    public IccRecords getIccRecords() {
        IccRecords iccRecords;
        synchronized (this.mLock) {
            iccRecords = this.mIccRecords;
        }
        return iccRecords;
    }

    public void registerForNetworkLocked(Handler handler, int i, Object obj) {
        synchronized (this.mLock) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mNetworkLockedRegistrants.add(registrant);
            if (getState() == IccCardConstants.State.NETWORK_LOCKED) {
                if (this.mUiccApplication != null) {
                    registrant.notifyRegistrant(new AsyncResult((Object) null, Integer.valueOf(this.mUiccApplication.getPersoSubState().ordinal()), (Throwable) null));
                } else {
                    log("registerForNetworkLocked: not notifying registrants, mUiccApplication == null");
                }
            }
        }
    }

    public void unregisterForNetworkLocked(Handler handler) {
        synchronized (this.mLock) {
            this.mNetworkLockedRegistrants.remove(handler);
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0020, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void supplyPin(java.lang.String r3, android.os.Message r4) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0021 }
            if (r1 == 0) goto L_0x000b
            r1.supplyPin(r3, r4)     // Catch:{ all -> 0x0021 }
            goto L_0x001f
        L_0x000b:
            if (r4 == 0) goto L_0x001f
            java.lang.String r3 = "supplyPin"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0021 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r4)     // Catch:{ all -> 0x0021 }
            r3.exception = r2     // Catch:{ all -> 0x0021 }
            r4.sendToTarget()     // Catch:{ all -> 0x0021 }
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x001f:
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x0021:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.supplyPin(java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0020, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void supplyPuk(java.lang.String r3, java.lang.String r4, android.os.Message r5) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0021 }
            if (r1 == 0) goto L_0x000b
            r1.supplyPuk(r3, r4, r5)     // Catch:{ all -> 0x0021 }
            goto L_0x001f
        L_0x000b:
            if (r5 == 0) goto L_0x001f
            java.lang.String r3 = "supplyPuk"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0021 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r5)     // Catch:{ all -> 0x0021 }
            r3.exception = r2     // Catch:{ all -> 0x0021 }
            r5.sendToTarget()     // Catch:{ all -> 0x0021 }
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x001f:
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x0021:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.supplyPuk(java.lang.String, java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0020, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void supplyPin2(java.lang.String r3, android.os.Message r4) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0021 }
            if (r1 == 0) goto L_0x000b
            r1.supplyPin2(r3, r4)     // Catch:{ all -> 0x0021 }
            goto L_0x001f
        L_0x000b:
            if (r4 == 0) goto L_0x001f
            java.lang.String r3 = "supplyPin2"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0021 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r4)     // Catch:{ all -> 0x0021 }
            r3.exception = r2     // Catch:{ all -> 0x0021 }
            r4.sendToTarget()     // Catch:{ all -> 0x0021 }
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x001f:
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x0021:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.supplyPin2(java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0020, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void supplyPuk2(java.lang.String r3, java.lang.String r4, android.os.Message r5) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0021 }
            if (r1 == 0) goto L_0x000b
            r1.supplyPuk2(r3, r4, r5)     // Catch:{ all -> 0x0021 }
            goto L_0x001f
        L_0x000b:
            if (r5 == 0) goto L_0x001f
            java.lang.String r3 = "supplyPuk2"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0021 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r5)     // Catch:{ all -> 0x0021 }
            r3.exception = r2     // Catch:{ all -> 0x0021 }
            r5.sendToTarget()     // Catch:{ all -> 0x0021 }
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x001f:
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x0021:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.supplyPuk2(java.lang.String, java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0020, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void supplyNetworkDepersonalization(java.lang.String r2, android.os.Message r3) {
        /*
            r1 = this;
            java.lang.Object r0 = r1.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r1.mUiccApplication     // Catch:{ all -> 0x0021 }
            if (r1 == 0) goto L_0x000b
            r1.supplyNetworkDepersonalization(r2, r3)     // Catch:{ all -> 0x0021 }
            goto L_0x001f
        L_0x000b:
            if (r3 == 0) goto L_0x001f
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ all -> 0x0021 }
            java.lang.String r2 = "CommandsInterface is not set."
            r1.<init>(r2)     // Catch:{ all -> 0x0021 }
            android.os.AsyncResult r2 = android.os.AsyncResult.forMessage(r3)     // Catch:{ all -> 0x0021 }
            r2.exception = r1     // Catch:{ all -> 0x0021 }
            r3.sendToTarget()     // Catch:{ all -> 0x0021 }
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x001f:
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x0021:
            r1 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            throw r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.supplyNetworkDepersonalization(java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0020, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void supplySimDepersonalization(com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState r2, java.lang.String r3, android.os.Message r4) {
        /*
            r1 = this;
            java.lang.Object r0 = r1.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r1.mUiccApplication     // Catch:{ all -> 0x0021 }
            if (r1 == 0) goto L_0x000b
            r1.supplySimDepersonalization(r2, r3, r4)     // Catch:{ all -> 0x0021 }
            goto L_0x001f
        L_0x000b:
            if (r4 == 0) goto L_0x001f
            java.lang.RuntimeException r1 = new java.lang.RuntimeException     // Catch:{ all -> 0x0021 }
            java.lang.String r2 = "CommandsInterface is not set."
            r1.<init>(r2)     // Catch:{ all -> 0x0021 }
            android.os.AsyncResult r2 = android.os.AsyncResult.forMessage(r4)     // Catch:{ all -> 0x0021 }
            r2.exception = r1     // Catch:{ all -> 0x0021 }
            r4.sendToTarget()     // Catch:{ all -> 0x0021 }
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x001f:
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            return
        L_0x0021:
            r1 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0021 }
            throw r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.supplySimDepersonalization(com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState, java.lang.String, android.os.Message):void");
    }

    public boolean getIccLockEnabled() {
        boolean z;
        synchronized (this.mLock) {
            UiccCardApplication uiccCardApplication = this.mUiccApplication;
            z = uiccCardApplication != null && uiccCardApplication.getIccLockEnabled();
        }
        return z;
    }

    public boolean getIccFdnEnabled() {
        boolean z;
        synchronized (this.mLock) {
            UiccCardApplication uiccCardApplication = this.mUiccApplication;
            z = uiccCardApplication != null && uiccCardApplication.getIccFdnEnabled();
        }
        return z;
    }

    public boolean getIccFdnAvailable() {
        boolean z;
        synchronized (this.mLock) {
            UiccCardApplication uiccCardApplication = this.mUiccApplication;
            z = uiccCardApplication != null && uiccCardApplication.getIccFdnAvailable();
        }
        return z;
    }

    public boolean getIccPin2Blocked() {
        UiccCardApplication uiccCardApplication = this.mUiccApplication;
        return uiccCardApplication != null && uiccCardApplication.getIccPin2Blocked();
    }

    public boolean getIccPuk2Blocked() {
        UiccCardApplication uiccCardApplication = this.mUiccApplication;
        return uiccCardApplication != null && uiccCardApplication.getIccPuk2Blocked();
    }

    public boolean isEmptyProfile() {
        return this.mLastReportedNumOfUiccApplications == 0;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x001f, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void setIccLockEnabled(boolean r3, java.lang.String r4, android.os.Message r5) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0020 }
            if (r1 == 0) goto L_0x000b
            r1.setIccLockEnabled(r3, r4, r5)     // Catch:{ all -> 0x0020 }
            goto L_0x001e
        L_0x000b:
            if (r5 == 0) goto L_0x001e
            java.lang.String r3 = "setIccLockEnabled"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0020 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r5)     // Catch:{ all -> 0x0020 }
            r3.exception = r2     // Catch:{ all -> 0x0020 }
            r5.sendToTarget()     // Catch:{ all -> 0x0020 }
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x001e:
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x0020:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.setIccLockEnabled(boolean, java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x001f, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void setIccFdnEnabled(boolean r3, java.lang.String r4, android.os.Message r5) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0020 }
            if (r1 == 0) goto L_0x000b
            r1.setIccFdnEnabled(r3, r4, r5)     // Catch:{ all -> 0x0020 }
            goto L_0x001e
        L_0x000b:
            if (r5 == 0) goto L_0x001e
            java.lang.String r3 = "setIccFdnEnabled"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0020 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r5)     // Catch:{ all -> 0x0020 }
            r3.exception = r2     // Catch:{ all -> 0x0020 }
            r5.sendToTarget()     // Catch:{ all -> 0x0020 }
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x001e:
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x0020:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.setIccFdnEnabled(boolean, java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x001f, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void changeIccLockPassword(java.lang.String r3, java.lang.String r4, android.os.Message r5) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0020 }
            if (r1 == 0) goto L_0x000b
            r1.changeIccLockPassword(r3, r4, r5)     // Catch:{ all -> 0x0020 }
            goto L_0x001e
        L_0x000b:
            if (r5 == 0) goto L_0x001e
            java.lang.String r3 = "changeIccLockPassword"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0020 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r5)     // Catch:{ all -> 0x0020 }
            r3.exception = r2     // Catch:{ all -> 0x0020 }
            r5.sendToTarget()     // Catch:{ all -> 0x0020 }
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x001e:
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x0020:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.changeIccLockPassword(java.lang.String, java.lang.String, android.os.Message):void");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x001f, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void changeIccFdnPassword(java.lang.String r3, java.lang.String r4, android.os.Message r5) {
        /*
            r2 = this;
            java.lang.Object r0 = r2.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.UiccCardApplication r1 = r2.mUiccApplication     // Catch:{ all -> 0x0020 }
            if (r1 == 0) goto L_0x000b
            r1.changeIccFdnPassword(r3, r4, r5)     // Catch:{ all -> 0x0020 }
            goto L_0x001e
        L_0x000b:
            if (r5 == 0) goto L_0x001e
            java.lang.String r3 = "changeIccFdnPassword"
            java.lang.Exception r2 = r2.covertException(r3)     // Catch:{ all -> 0x0020 }
            android.os.AsyncResult r3 = android.os.AsyncResult.forMessage(r5)     // Catch:{ all -> 0x0020 }
            r3.exception = r2     // Catch:{ all -> 0x0020 }
            r5.sendToTarget()     // Catch:{ all -> 0x0020 }
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x001e:
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            return
        L_0x0020:
            r2 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0020 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccProfile.changeIccFdnPassword(java.lang.String, java.lang.String, android.os.Message):void");
    }

    public String getServiceProviderName() {
        synchronized (this.mLock) {
            IccRecords iccRecords = this.mIccRecords;
            if (iccRecords == null) {
                return null;
            }
            String serviceProviderName = iccRecords.getServiceProviderName();
            return serviceProviderName;
        }
    }

    public boolean hasIccCard() {
        if (this.mUiccCard.getCardState() != IccCardStatus.CardState.CARDSTATE_ABSENT) {
            return true;
        }
        loge("hasIccCard: UiccProfile is not null but UiccCard is null or card state is ABSENT");
        return false;
    }

    public void update(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus) {
        synchronized (this.mLock) {
            this.mUniversalPinState = iccCardStatus.mUniversalPinState;
            this.mGsmUmtsSubscriptionAppIndex = iccCardStatus.mGsmUmtsSubscriptionAppIndex;
            this.mCdmaSubscriptionAppIndex = iccCardStatus.mCdmaSubscriptionAppIndex;
            this.mImsSubscriptionAppIndex = iccCardStatus.mImsSubscriptionAppIndex;
            this.mContext = context;
            this.mCi = commandsInterface;
            this.mTelephonyManager = (TelephonyManager) context.getSystemService("phone");
            log(iccCardStatus.mApplications.length + " applications");
            this.mLastReportedNumOfUiccApplications = iccCardStatus.mApplications.length;
            int i = 0;
            while (true) {
                UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
                if (i >= uiccCardApplicationArr.length) {
                    break;
                }
                UiccCardApplication uiccCardApplication = uiccCardApplicationArr[i];
                if (uiccCardApplication == null) {
                    IccCardApplicationStatus[] iccCardApplicationStatusArr = iccCardStatus.mApplications;
                    if (i < iccCardApplicationStatusArr.length) {
                        uiccCardApplicationArr[i] = makeUiccApplication(this, iccCardApplicationStatusArr[i], this.mContext, this.mCi);
                    }
                } else {
                    IccCardApplicationStatus[] iccCardApplicationStatusArr2 = iccCardStatus.mApplications;
                    if (i >= iccCardApplicationStatusArr2.length) {
                        uiccCardApplication.dispose();
                        this.mUiccApplications[i] = null;
                    } else {
                        uiccCardApplication.update(iccCardApplicationStatusArr2[i], this.mContext, this.mCi);
                    }
                }
                i++;
            }
            createAndUpdateCatServiceLocked();
            log("Before privilege rules: " + this.mCarrierPrivilegeRules + " : " + iccCardStatus.mCardState);
            UiccCarrierPrivilegeRules uiccCarrierPrivilegeRules = this.mCarrierPrivilegeRules;
            if (uiccCarrierPrivilegeRules == null && iccCardStatus.mCardState == IccCardStatus.CardState.CARDSTATE_PRESENT) {
                this.mCarrierPrivilegeRules = new UiccCarrierPrivilegeRules(this, this.mHandler.obtainMessage(13));
            } else if (!(uiccCarrierPrivilegeRules == null || iccCardStatus.mCardState == IccCardStatus.CardState.CARDSTATE_PRESENT)) {
                this.mCarrierPrivilegeRules = null;
                this.mContext.getContentResolver().unregisterContentObserver(this.mProvisionCompleteContentObserver);
            }
            sanitizeApplicationIndexesLocked();
            int i2 = this.mRadioTech;
            if (i2 != 0) {
                setCurrentAppType(ServiceState.isGsm(i2));
            }
            updateIccAvailability(true);
        }
    }

    private void createAndUpdateCatServiceLocked() {
        UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
        if (uiccCardApplicationArr.length <= 0 || uiccCardApplicationArr[0] == null) {
            CatService catService = this.mCatService;
            if (catService != null) {
                catService.dispose();
            }
            this.mCatService = null;
            return;
        }
        CatService catService2 = this.mCatService;
        if (catService2 == null) {
            this.mCatService = CatService.getInstance(this.mCi, this.mContext, this, this.mPhoneId);
        } else {
            catService2.update(this.mCi, this.mContext, this);
        }
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        log("UiccProfile finalized");
    }

    private void sanitizeApplicationIndexesLocked() {
        this.mGsmUmtsSubscriptionAppIndex = checkIndexLocked(this.mGsmUmtsSubscriptionAppIndex, IccCardApplicationStatus.AppType.APPTYPE_SIM, IccCardApplicationStatus.AppType.APPTYPE_USIM);
        this.mCdmaSubscriptionAppIndex = checkIndexLocked(this.mCdmaSubscriptionAppIndex, IccCardApplicationStatus.AppType.APPTYPE_RUIM, IccCardApplicationStatus.AppType.APPTYPE_CSIM);
        this.mImsSubscriptionAppIndex = checkIndexLocked(this.mImsSubscriptionAppIndex, IccCardApplicationStatus.AppType.APPTYPE_ISIM, (IccCardApplicationStatus.AppType) null);
    }

    private boolean isSupportedApplication(UiccCardApplication uiccCardApplication) {
        if (uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_USIM || uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_SIM) {
            return true;
        }
        if (UiccController.isCdmaSupported(this.mContext)) {
            return uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_CSIM || uiccCardApplication.getType() == IccCardApplicationStatus.AppType.APPTYPE_RUIM;
        }
        return false;
    }

    private void checkAndUpdateIfAnyAppToBeIgnored() {
        boolean[] zArr = new boolean[(IccCardApplicationStatus.AppType.APPTYPE_ISIM.ordinal() + 1)];
        for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
            if (uiccCardApplication != null && isSupportedApplication(uiccCardApplication) && uiccCardApplication.isReady()) {
                zArr[uiccCardApplication.getType().ordinal()] = true;
            }
        }
        for (UiccCardApplication uiccCardApplication2 : this.mUiccApplications) {
            if (uiccCardApplication2 != null && isSupportedApplication(uiccCardApplication2) && !uiccCardApplication2.isReady() && zArr[uiccCardApplication2.getType().ordinal()]) {
                uiccCardApplication2.setAppIgnoreState(true);
            }
        }
    }

    private boolean areAllApplicationsReady() {
        for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
            if (uiccCardApplication != null && isSupportedApplication(uiccCardApplication) && !uiccCardApplication.isReady() && !uiccCardApplication.isAppIgnored()) {
                return false;
            }
        }
        if (this.mUiccApplication != null) {
            return true;
        }
        return false;
    }

    private boolean areAllRecordsLoaded() {
        IccRecords iccRecords;
        for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
            if (uiccCardApplication != null && isSupportedApplication(uiccCardApplication) && !uiccCardApplication.isAppIgnored() && ((iccRecords = uiccCardApplication.getIccRecords()) == null || !iccRecords.isLoaded())) {
                return false;
            }
        }
        if (this.mUiccApplication != null) {
            return true;
        }
        return false;
    }

    private int checkIndexLocked(int i, IccCardApplicationStatus.AppType appType, IccCardApplicationStatus.AppType appType2) {
        UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
        if (uiccCardApplicationArr == null || i >= uiccCardApplicationArr.length) {
            loge("App index " + i + " is invalid since there are no applications");
            return -1;
        } else if (i < 0) {
            return -1;
        } else {
            if (uiccCardApplicationArr[i].getType() == appType || this.mUiccApplications[i].getType() == appType2) {
                return i;
            }
            loge("App index " + i + " is invalid since it's not " + appType + " and not " + appType2);
            return -1;
        }
    }

    public void registerForOpertorBrandOverride(Handler handler, int i, Object obj) {
        synchronized (this.mLock) {
            this.mOperatorBrandOverrideRegistrants.add(new Registrant(handler, i, obj));
        }
    }

    public void unregisterForOperatorBrandOverride(Handler handler) {
        synchronized (this.mLock) {
            this.mOperatorBrandOverrideRegistrants.remove(handler);
        }
    }

    static boolean isPackageBundled(Context context, String str) {
        try {
            context.getPackageManager().getApplicationInfo(str, NetworkStackConstants.NEIGHBOR_ADVERTISEMENT_FLAG_OVERRIDE);
            Rlog.d(LOG_TAG, str + " is installed.");
            return true;
        } catch (PackageManager.NameNotFoundException unused) {
            Rlog.d(LOG_TAG, str + " is not installed.");
            return false;
        }
    }

    private void promptInstallCarrierApp(String str) {
        Intent intent = InstallCarrierAppTrampolineActivity.get(this.mContext, str);
        intent.addFlags(268435456);
        this.mContext.startActivity(intent);
    }

    /* access modifiers changed from: private */
    public void onCarrierPrivilegesLoadedMessage() {
        ActivityManager activityManager = (ActivityManager) this.mContext.getSystemService(ActivityManager.class);
        CarrierAppUtils.disableCarrierAppsUntilPrivileged(this.mContext.getOpPackageName(), this.mTelephonyManager, ActivityManager.getCurrentUser(), this.mContext);
        UsageStatsManager usageStatsManager = (UsageStatsManager) this.mContext.getSystemService("usagestats");
        if (usageStatsManager != null) {
            usageStatsManager.onCarrierPrivilegedAppsChanged();
        }
        InstallCarrierAppUtils.hideAllNotifications(this.mContext);
        InstallCarrierAppUtils.unregisterPackageInstallReceiver(this.mContext);
        synchronized (this.mLock) {
            boolean isProvisioned = isProvisioned();
            boolean isUserUnlocked = isUserUnlocked();
            if (!isProvisioned || !isUserUnlocked) {
                if (!isProvisioned) {
                    this.mContext.getContentResolver().registerContentObserver(Settings.Global.getUriFor("device_provisioned"), false, this.mProvisionCompleteContentObserver);
                    this.mProvisionCompleteContentObserverRegistered = true;
                }
                if (!isUserUnlocked) {
                    this.mContext.registerReceiver(this.mUserUnlockReceiver, new IntentFilter("android.intent.action.USER_UNLOCKED"));
                    this.mUserUnlockReceiverRegistered = true;
                }
            } else {
                for (String promptInstallCarrierApp : getUninstalledCarrierPackages()) {
                    promptInstallCarrierApp(promptInstallCarrierApp);
                }
            }
        }
    }

    private boolean isProvisioned() {
        if (Settings.Global.getInt(this.mContext.getContentResolver(), "device_provisioned", 1) == 1) {
            return true;
        }
        return false;
    }

    private boolean isUserUnlocked() {
        return ((UserManager) this.mContext.getSystemService(UserManager.class)).isUserUnlocked();
    }

    /* access modifiers changed from: private */
    public void showCarrierAppNotificationsIfPossible() {
        if (isProvisioned() && isUserUnlocked()) {
            for (String showNotification : getUninstalledCarrierPackages()) {
                InstallCarrierAppUtils.showNotification(this.mContext, showNotification);
                InstallCarrierAppUtils.registerPackageInstallReceiver(this.mContext);
            }
        }
    }

    private Set<String> getUninstalledCarrierPackages() {
        String string = Settings.Global.getString(this.mContext.getContentResolver(), "carrier_app_whitelist");
        if (TextUtils.isEmpty(string)) {
            return Collections.emptySet();
        }
        Map<String, String> parseToCertificateToPackageMap = parseToCertificateToPackageMap(string);
        if (parseToCertificateToPackageMap.isEmpty()) {
            return Collections.emptySet();
        }
        UiccCarrierPrivilegeRules carrierPrivilegeRules = getCarrierPrivilegeRules();
        if (carrierPrivilegeRules == null) {
            return Collections.emptySet();
        }
        ArraySet arraySet = new ArraySet();
        for (UiccAccessRule certificateHexString : carrierPrivilegeRules.getAccessRules()) {
            String str = parseToCertificateToPackageMap.get(certificateHexString.getCertificateHexString().toUpperCase());
            if (!TextUtils.isEmpty(str) && !isPackageBundled(this.mContext, str)) {
                arraySet.add(str);
            }
        }
        return arraySet;
    }

    @VisibleForTesting
    public static Map<String, String> parseToCertificateToPackageMap(String str) {
        List<String> asList = Arrays.asList(str.split("\\s*;\\s*"));
        if (asList.isEmpty()) {
            return Collections.emptyMap();
        }
        ArrayMap arrayMap = new ArrayMap(asList.size());
        for (String split : asList) {
            String[] split2 = split.split("\\s*:\\s*");
            if (split2.length == 2) {
                arrayMap.put(split2[0].toUpperCase(), split2[1]);
            } else {
                Rlog.d(LOG_TAG, "Incorrect length of key-value pair in carrier app allow list map.  Length should be exactly 2");
            }
        }
        return arrayMap;
    }

    public boolean isApplicationOnIcc(IccCardApplicationStatus.AppType appType) {
        synchronized (this.mLock) {
            int i = 0;
            while (true) {
                UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
                if (i >= uiccCardApplicationArr.length) {
                    return false;
                }
                UiccCardApplication uiccCardApplication = uiccCardApplicationArr[i];
                if (uiccCardApplication != null && uiccCardApplication.getType() == appType) {
                    return true;
                }
                i++;
            }
        }
    }

    public IccCardStatus.PinState getUniversalPinState() {
        IccCardStatus.PinState pinState;
        synchronized (this.mLock) {
            pinState = this.mUniversalPinState;
        }
        return pinState;
    }

    public UiccCardApplication getApplication(int i) {
        synchronized (this.mLock) {
            int i2 = 8;
            if (i == 1) {
                i2 = this.mGsmUmtsSubscriptionAppIndex;
            } else if (i == 2) {
                i2 = this.mCdmaSubscriptionAppIndex;
            } else if (i == 3) {
                i2 = this.mImsSubscriptionAppIndex;
            }
            if (i2 >= 0) {
                UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
                if (i2 < uiccCardApplicationArr.length) {
                    UiccCardApplication uiccCardApplication = uiccCardApplicationArr[i2];
                    return uiccCardApplication;
                }
            }
            return null;
        }
    }

    public UiccCardApplication getApplicationIndex(int i) {
        synchronized (this.mLock) {
            if (i >= 0) {
                UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
                if (i < uiccCardApplicationArr.length) {
                    UiccCardApplication uiccCardApplication = uiccCardApplicationArr[i];
                    return uiccCardApplication;
                }
            }
            return null;
        }
    }

    public UiccCardApplication getApplicationByType(int i) {
        synchronized (this.mLock) {
            int i2 = 0;
            while (true) {
                UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
                if (i2 >= uiccCardApplicationArr.length) {
                    return null;
                }
                UiccCardApplication uiccCardApplication = uiccCardApplicationArr[i2];
                if (uiccCardApplication == null || uiccCardApplication.getType().ordinal() != i) {
                    i2++;
                } else {
                    UiccCardApplication uiccCardApplication2 = this.mUiccApplications[i2];
                    return uiccCardApplication2;
                }
            }
        }
    }

    @VisibleForTesting
    public boolean resetAppWithAid(String str, boolean z) {
        boolean z2;
        synchronized (this.mLock) {
            z2 = false;
            int i = 0;
            boolean z3 = false;
            boolean z4 = false;
            while (true) {
                UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
                if (i < uiccCardApplicationArr.length) {
                    if (uiccCardApplicationArr[i] != null && (TextUtils.isEmpty(str) || str.equals(this.mUiccApplications[i].getAid()))) {
                        if (!TextUtils.isEmpty(str) && this.mUiccApplications[i].getType() == IccCardApplicationStatus.AppType.APPTYPE_ISIM) {
                            z4 = true;
                        }
                        this.mUiccApplications[i].dispose();
                        this.mUiccApplications[i] = null;
                        z3 = true;
                    }
                    i++;
                } else {
                    if (z && TextUtils.isEmpty(str)) {
                        if (this.mCarrierPrivilegeRules != null) {
                            this.mCarrierPrivilegeRules = null;
                            this.mContext.getContentResolver().unregisterContentObserver(this.mProvisionCompleteContentObserver);
                            z3 = true;
                        }
                        CatService catService = this.mCatService;
                        if (catService != null) {
                            catService.dispose();
                            this.mCatService = null;
                            z3 = true;
                        }
                    }
                    if (z3 && !z4) {
                        z2 = true;
                    }
                }
            }
        }
        return z2;
    }

    public void iccOpenLogicalChannel(String str, int i, Message message) {
        logWithLocalLog("iccOpenLogicalChannel: " + str + " , " + i + " by pid:" + Binder.getCallingPid() + " uid:" + Binder.getCallingUid());
        this.mCi.iccOpenLogicalChannel(str, i, this.mHandler.obtainMessage(8, message));
    }

    public void iccCloseLogicalChannel(int i, Message message) {
        logWithLocalLog("iccCloseLogicalChannel: " + i);
        this.mCi.iccCloseLogicalChannel(i, this.mHandler.obtainMessage(9, message));
    }

    public void iccTransmitApduLogicalChannel(int i, int i2, int i3, int i4, int i5, int i6, String str, Message message) {
        this.mCi.iccTransmitApduLogicalChannel(i, i2, i3, i4, i5, i6, str, this.mHandler.obtainMessage(10, message));
    }

    public void iccTransmitApduBasicChannel(int i, int i2, int i3, int i4, int i5, String str, Message message) {
        this.mCi.iccTransmitApduBasicChannel(i, i2, i3, i4, i5, str, this.mHandler.obtainMessage(11, message));
    }

    public void iccExchangeSimIO(int i, int i2, int i3, int i4, int i5, String str, Message message) {
        this.mCi.iccIO(i2, i, str, i3, i4, i5, (String) null, (String) null, this.mHandler.obtainMessage(12, message));
    }

    public void sendEnvelopeWithStatus(String str, Message message) {
        this.mCi.sendEnvelopeWithStatus(str, message);
    }

    public int getNumApplications() {
        return this.mLastReportedNumOfUiccApplications;
    }

    public int getPhoneId() {
        return this.mPhoneId;
    }

    @VisibleForTesting
    public boolean areCarrierPrivilegeRulesLoaded() {
        UiccCarrierPrivilegeRules carrierPrivilegeRules = getCarrierPrivilegeRules();
        return carrierPrivilegeRules == null || carrierPrivilegeRules.areCarrierPriviligeRulesLoaded();
    }

    public List<String> getCertsFromCarrierPrivilegeAccessRules() {
        ArrayList arrayList = new ArrayList();
        UiccCarrierPrivilegeRules carrierPrivilegeRules = getCarrierPrivilegeRules();
        if (carrierPrivilegeRules != null) {
            for (UiccAccessRule certificateHexString : carrierPrivilegeRules.getAccessRules()) {
                arrayList.add(certificateHexString.getCertificateHexString());
            }
        }
        if (arrayList.isEmpty()) {
            return null;
        }
        return arrayList;
    }

    public List<UiccAccessRule> getCarrierPrivilegeAccessRules() {
        UiccCarrierPrivilegeRules carrierPrivilegeRules = getCarrierPrivilegeRules();
        if (carrierPrivilegeRules == null) {
            return Collections.EMPTY_LIST;
        }
        return new ArrayList(carrierPrivilegeRules.getAccessRules());
    }

    private UiccCarrierPrivilegeRules getCarrierPrivilegeRules() {
        synchronized (this.mLock) {
            UiccCarrierPrivilegeRules uiccCarrierPrivilegeRules = this.mTestOverrideCarrierPrivilegeRules;
            if (uiccCarrierPrivilegeRules != null) {
                return uiccCarrierPrivilegeRules;
            }
            UiccCarrierPrivilegeRules uiccCarrierPrivilegeRules2 = this.mCarrierPrivilegeRules;
            return uiccCarrierPrivilegeRules2;
        }
    }

    public boolean setOperatorBrandOverride(String str) {
        log("setOperatorBrandOverride: " + str);
        log("current iccId: " + SubscriptionInfo.givePrintableIccid(getIccId()));
        String iccId = getIccId();
        if (TextUtils.isEmpty(iccId)) {
            return false;
        }
        if (!SubscriptionController.getInstance().checkPhoneIdAndIccIdMatch(getPhoneId(), iccId)) {
            loge("iccId doesn't match current active subId.");
            return false;
        }
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(this.mContext).edit();
        String str2 = OPERATOR_BRAND_OVERRIDE_PREFIX + iccId;
        if (str == null) {
            edit.remove(str2).commit();
        } else {
            edit.putString(str2, str).commit();
        }
        this.mOperatorBrandOverrideRegistrants.notifyRegistrants();
        return true;
    }

    public String getOperatorBrandOverride() {
        String iccId = getIccId();
        if (TextUtils.isEmpty(iccId)) {
            return null;
        }
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(this.mContext);
        return defaultSharedPreferences.getString(OPERATOR_BRAND_OVERRIDE_PREFIX + iccId, (String) null);
    }

    public String getIccId() {
        IccRecords iccRecords;
        for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
            if (uiccCardApplication != null && (iccRecords = uiccCardApplication.getIccRecords()) != null && iccRecords.getIccId() != null) {
                return iccRecords.getIccId();
            }
        }
        return null;
    }

    /* access modifiers changed from: private */
    public static String eventToString(int i) {
        switch (i) {
            case 1:
                return "RADIO_OFF_OR_UNAVAILABLE";
            case 2:
                return "ICC_LOCKED";
            case 3:
                return "APP_READY";
            case 4:
                return "RECORDS_LOADED";
            case 5:
                return "NETWORK_LOCKED";
            case 6:
                return "EID_READY";
            case 7:
                return "ICC_RECORD_EVENTS";
            case 8:
                return "OPEN_LOGICAL_CHANNEL_DONE";
            case 9:
                return "CLOSE_LOGICAL_CHANNEL_DONE";
            case 10:
                return "TRANSMIT_APDU_LOGICAL_CHANNEL_DONE";
            case 11:
                return "TRANSMIT_APDU_BASIC_CHANNEL_DONE";
            case 12:
                return "SIM_IO_DONE";
            case 13:
                return "CARRIER_PRIVILEGES_LOADED";
            case 14:
                return "CARRIER_CONFIG_CHANGED";
            case 15:
                return "CARRIER_PRIVILEGES_TEST_OVERRIDE_SET";
            case 16:
                return "SUPPLY_ICC_PIN_DONE";
            default:
                return "UNKNOWN(" + i + ")";
        }
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    /* access modifiers changed from: private */
    public void logWithLocalLog(String str) {
        Rlog.d(LOG_TAG, str);
        UiccController.addLocalLog("UiccProfile[" + this.mPhoneId + "]: " + str);
    }

    @VisibleForTesting
    public void refresh() {
        Handler handler = this.mHandler;
        handler.sendMessage(handler.obtainMessage(13));
    }

    public void setTestOverrideCarrierPrivilegeRules(List<UiccAccessRule> list) {
        Handler handler = this.mHandler;
        handler.sendMessage(handler.obtainMessage(15, list));
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IccRecords iccRecords;
        printWriter.println("UiccProfile:");
        printWriter.println(" mCi=" + this.mCi);
        printWriter.println(" mCatService=" + this.mCatService);
        for (int i = 0; i < this.mOperatorBrandOverrideRegistrants.size(); i++) {
            printWriter.println("  mOperatorBrandOverrideRegistrants[" + i + "]=" + ((Registrant) this.mOperatorBrandOverrideRegistrants.get(i)).getHandler());
        }
        printWriter.println(" mUniversalPinState=" + this.mUniversalPinState);
        printWriter.println(" mGsmUmtsSubscriptionAppIndex=" + this.mGsmUmtsSubscriptionAppIndex);
        printWriter.println(" mCdmaSubscriptionAppIndex=" + this.mCdmaSubscriptionAppIndex);
        printWriter.println(" mImsSubscriptionAppIndex=" + this.mImsSubscriptionAppIndex);
        printWriter.println(" mUiccApplications: length=" + this.mUiccApplications.length);
        int i2 = 0;
        while (true) {
            UiccCardApplication[] uiccCardApplicationArr = this.mUiccApplications;
            if (i2 >= uiccCardApplicationArr.length) {
                break;
            }
            if (uiccCardApplicationArr[i2] == null) {
                printWriter.println("  mUiccApplications[" + i2 + "]=" + null);
            } else {
                printWriter.println("  mUiccApplications[" + i2 + "]=" + this.mUiccApplications[i2].getType() + " " + this.mUiccApplications[i2]);
            }
            i2++;
        }
        printWriter.println();
        for (UiccCardApplication uiccCardApplication : this.mUiccApplications) {
            if (uiccCardApplication != null) {
                uiccCardApplication.dump(fileDescriptor, printWriter, strArr);
                printWriter.println();
            }
        }
        for (UiccCardApplication uiccCardApplication2 : this.mUiccApplications) {
            if (!(uiccCardApplication2 == null || (iccRecords = uiccCardApplication2.getIccRecords()) == null)) {
                iccRecords.dump(fileDescriptor, printWriter, strArr);
                printWriter.println();
            }
        }
        if (this.mCarrierPrivilegeRules == null) {
            printWriter.println(" mCarrierPrivilegeRules: null");
        } else {
            printWriter.println(" mCarrierPrivilegeRules: " + this.mCarrierPrivilegeRules);
            this.mCarrierPrivilegeRules.dump(fileDescriptor, printWriter, strArr);
        }
        if (this.mTestOverrideCarrierPrivilegeRules != null) {
            printWriter.println(" mTestOverrideCarrierPrivilegeRules: " + this.mTestOverrideCarrierPrivilegeRules);
            this.mTestOverrideCarrierPrivilegeRules.dump(fileDescriptor, printWriter, strArr);
        }
        printWriter.flush();
        printWriter.println(" mNetworkLockedRegistrants: size=" + this.mNetworkLockedRegistrants.size());
        for (int i3 = 0; i3 < this.mNetworkLockedRegistrants.size(); i3++) {
            printWriter.println("  mNetworkLockedRegistrants[" + i3 + "]=" + ((Registrant) this.mNetworkLockedRegistrants.get(i3)).getHandler());
        }
        printWriter.println(" mCurrentAppType=" + this.mCurrentAppType);
        printWriter.println(" mUiccCard=" + this.mUiccCard);
        printWriter.println(" mUiccApplication=" + this.mUiccApplication);
        printWriter.println(" mIccRecords=" + this.mIccRecords);
        printWriter.println(" mExternalState=" + this.mExternalState);
        printWriter.flush();
    }

    /* access modifiers changed from: protected */
    public Exception covertException(String str) {
        return new RuntimeException("ICC card is absent.");
    }

    /* access modifiers changed from: protected */
    public UiccCardApplication makeUiccApplication(UiccProfile uiccProfile, IccCardApplicationStatus iccCardApplicationStatus, Context context, CommandsInterface commandsInterface) {
        return new UiccCardApplication(uiccProfile, iccCardApplicationStatus, context, commandsInterface);
    }

    /* access modifiers changed from: protected */
    public String getSubscriptionDisplayName(int i, Context context) {
        return this.mTelephonyManager.getSimOperatorName(i);
    }

    /* access modifiers changed from: protected */
    public boolean isUdpateCarrierName(String str) {
        return !TextUtils.isEmpty(str);
    }
}
