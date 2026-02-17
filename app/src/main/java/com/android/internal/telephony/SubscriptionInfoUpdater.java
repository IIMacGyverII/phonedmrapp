package com.android.internal.telephony;

import android.app.ActivityManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.ParcelUuid;
import android.os.PersistableBundle;
import android.os.SystemProperties;
import android.os.UserHandle;
import android.preference.PreferenceManager;
import android.service.carrier.CarrierIdentifier;
import android.service.euicc.EuiccProfileInfo;
import android.service.euicc.GetEuiccProfileInfoListResult;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.UiccAccessRule;
import android.telephony.euicc.EuiccManager;
import android.text.TextUtils;
import android.util.Pair;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.euicc.EuiccController;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.UiccSlot;
import com.android.telephony.Rlog;
import com.mediatek.boostfwk.identify.launch.LaunchIdentify;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArraySet;

public class SubscriptionInfoUpdater extends Handler {
    public static final String CURR_SUBID = "curr_subid";
    private static final boolean DBG = true;
    protected static final int EVENT_GET_NETWORK_SELECTION_MODE_DONE = 2;
    private static final int EVENT_INACTIVE_SLOT_ICC_STATE_CHANGED = 14;
    private static final int EVENT_INVALID = -1;
    private static final int EVENT_MULTI_SIM_CONFIG_CHANGED = 13;
    private static final int EVENT_REFRESH_EMBEDDED_SUBSCRIPTIONS = 12;
    private static final int EVENT_SIM_ABSENT = 4;
    private static final int EVENT_SIM_IMSI = 11;
    private static final int EVENT_SIM_IO_ERROR = 6;
    private static final int EVENT_SIM_LOADED = 3;
    private static final int EVENT_SIM_LOCKED = 5;
    private static final int EVENT_SIM_NOT_READY = 9;
    private static final int EVENT_SIM_READY = 10;
    private static final int EVENT_SIM_RESTRICTED = 8;
    private static final int EVENT_SIM_UNKNOWN = 7;
    protected static final String ICCID_STRING_FOR_NO_SIM = initIccidStringForNoSim();
    private static final String LOG_TAG = "SubscriptionInfoUpdater";
    private static final ParcelUuid REMOVE_GROUP_UUID = ParcelUuid.fromString("00000000-0000-0000-0000-000000000000");
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected static final int SUPPORTED_MODEM_COUNT;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected static Context sContext = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected static String[] sIccId;
    protected static String[] sInactiveIccIds;
    protected static boolean sIsSubInfoInitialized = false;
    private static int[] sSimApplicationState;
    private static int[] sSimCardState;
    private Handler mBackgroundHandler;
    private CarrierServiceBindHelper mCarrierServiceBindHelper;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mCurrentlyActiveUserId;
    private EuiccManager mEuiccManager;
    protected SubscriptionController mSubscriptionController = null;
    protected SubscriptionManager mSubscriptionManager = null;
    /* access modifiers changed from: private */
    public final BroadcastReceiver mUserUnlockedReceiver;
    /* access modifiers changed from: private */
    public final CopyOnWriteArraySet<Integer> retryUpdateEmbeddedSubscriptionCards = new CopyOnWriteArraySet<>();
    /* access modifiers changed from: private */
    public volatile boolean shouldRetryUpdateEmbeddedSubscriptions = false;

    protected interface UpdateEmbeddedSubsCallback {
        void run(boolean z);
    }

    public static String simStateString(@TelephonyManager.SimState int i) {
        switch (i) {
            case 0:
                return "UNKNOWN";
            case 1:
                return "ABSENT";
            case 2:
                return "PIN_REQUIRED";
            case 3:
                return "PUK_REQUIRED";
            case 4:
                return "NETWORK_LOCKED";
            case 5:
                return "READY";
            case 6:
                return "NOT_READY";
            case 7:
                return "PERM_DISABLED";
            case 8:
                return "CARD_IO_ERROR";
            case 9:
                return "CARD_RESTRICTED";
            case 10:
                return "LOADED";
            case 11:
                return "PRESENT";
            default:
                return "INVALID";
        }
    }

    static {
        int supportedModemCount = TelephonyManager.getDefault().getSupportedModemCount();
        SUPPORTED_MODEM_COUNT = supportedModemCount;
        sIccId = new String[supportedModemCount];
        sInactiveIccIds = new String[supportedModemCount];
        sSimCardState = new int[supportedModemCount];
        sSimApplicationState = new int[supportedModemCount];
    }

    @VisibleForTesting
    public SubscriptionInfoUpdater(Looper looper, Context context, SubscriptionController subscriptionController) {
        AnonymousClass1 r1 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.intent.action.USER_UNLOCKED".equals(intent.getAction()) && SubscriptionInfoUpdater.this.shouldRetryUpdateEmbeddedSubscriptions) {
                    SubscriptionInfoUpdater.logd("Retrying refresh embedded subscriptions after user unlock.");
                    Iterator it = SubscriptionInfoUpdater.this.retryUpdateEmbeddedSubscriptionCards.iterator();
                    while (it.hasNext()) {
                        SubscriptionInfoUpdater.this.requestEmbeddedSubscriptionInfoListRefresh(((Integer) it.next()).intValue(), (Runnable) null);
                    }
                    SubscriptionInfoUpdater.this.retryUpdateEmbeddedSubscriptionCards.clear();
                    SubscriptionInfoUpdater.sContext.unregisterReceiver(SubscriptionInfoUpdater.this.mUserUnlockedReceiver);
                }
            }
        };
        this.mUserUnlockedReceiver = r1;
        logd("Constructor invoked");
        this.mBackgroundHandler = new Handler(looper);
        sContext = context;
        this.mSubscriptionController = subscriptionController;
        this.mSubscriptionManager = SubscriptionManager.from(context);
        this.mEuiccManager = (EuiccManager) sContext.getSystemService("euicc");
        this.mCarrierServiceBindHelper = new CarrierServiceBindHelper(sContext);
        sContext.registerReceiver(r1, new IntentFilter("android.intent.action.USER_UNLOCKED"));
        initializeCarrierApps();
        PhoneConfigurationManager.registerForMultiSimConfigChange(this, 13, (Object) null);
    }

    private void initializeCarrierApps() {
        this.mCurrentlyActiveUserId = 0;
        sContext.registerReceiverForAllUsers(new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.intent.action.USER_FOREGROUND".equals(intent.getAction())) {
                    UserHandle userHandle = (UserHandle) intent.getParcelableExtra("android.intent.extra.USER");
                    SubscriptionInfoUpdater.this.mCurrentlyActiveUserId = userHandle != null ? userHandle.getIdentifier() : 0;
                    CarrierAppUtils.disableCarrierAppsUntilPrivileged(SubscriptionInfoUpdater.sContext.getOpPackageName(), TelephonyManager.getDefault(), SubscriptionInfoUpdater.this.mCurrentlyActiveUserId, SubscriptionInfoUpdater.sContext);
                }
            }
        }, new IntentFilter("android.intent.action.USER_FOREGROUND"), (String) null, (Handler) null);
        ActivityManager activityManager = (ActivityManager) sContext.getSystemService(LaunchIdentify.HOSTTYPE_ACTIVITY);
        this.mCurrentlyActiveUserId = ActivityManager.getCurrentUser();
        CarrierAppUtils.disableCarrierAppsUntilPrivileged(sContext.getOpPackageName(), TelephonyManager.getDefault(), this.mCurrentlyActiveUserId, sContext);
    }

    public void updateInternalIccState(String str, String str2, int i) {
        logd("updateInternalIccState to simStatus " + str + " reason " + str2 + " phoneId " + i);
        int internalIccStateToMessage = internalIccStateToMessage(str);
        if (internalIccStateToMessage != -1) {
            sendMessage(obtainMessage(internalIccStateToMessage, i, 0, str2));
        }
    }

    public void updateInternalIccStateForInactivePort(int i, String str) {
        sendMessage(obtainMessage(14, i, 0, str));
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private int internalIccStateToMessage(java.lang.String r8) {
        /*
            r7 = this;
            r8.hashCode()
            int r7 = r8.hashCode()
            r0 = 8
            r1 = 7
            r2 = 6
            r3 = 5
            r4 = 4
            r5 = 3
            r6 = -1
            switch(r7) {
                case -2044189691: goto L_0x006e;
                case -2044123382: goto L_0x0063;
                case -1830845986: goto L_0x0058;
                case 2251386: goto L_0x004d;
                case 77848963: goto L_0x0042;
                case 433141802: goto L_0x0037;
                case 1034051831: goto L_0x002c;
                case 1599753450: goto L_0x0021;
                case 1924388665: goto L_0x0015;
                default: goto L_0x0012;
            }
        L_0x0012:
            r7 = r6
            goto L_0x0078
        L_0x0015:
            java.lang.String r7 = "ABSENT"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x001e
            goto L_0x0012
        L_0x001e:
            r7 = r0
            goto L_0x0078
        L_0x0021:
            java.lang.String r7 = "CARD_RESTRICTED"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x002a
            goto L_0x0012
        L_0x002a:
            r7 = r1
            goto L_0x0078
        L_0x002c:
            java.lang.String r7 = "NOT_READY"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x0035
            goto L_0x0012
        L_0x0035:
            r7 = r2
            goto L_0x0078
        L_0x0037:
            java.lang.String r7 = "UNKNOWN"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x0040
            goto L_0x0012
        L_0x0040:
            r7 = r3
            goto L_0x0078
        L_0x0042:
            java.lang.String r7 = "READY"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x004b
            goto L_0x0012
        L_0x004b:
            r7 = r4
            goto L_0x0078
        L_0x004d:
            java.lang.String r7 = "IMSI"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x0056
            goto L_0x0012
        L_0x0056:
            r7 = r5
            goto L_0x0078
        L_0x0058:
            java.lang.String r7 = "CARD_IO_ERROR"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x0061
            goto L_0x0012
        L_0x0061:
            r7 = 2
            goto L_0x0078
        L_0x0063:
            java.lang.String r7 = "LOCKED"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x006c
            goto L_0x0012
        L_0x006c:
            r7 = 1
            goto L_0x0078
        L_0x006e:
            java.lang.String r7 = "LOADED"
            boolean r7 = r8.equals(r7)
            if (r7 != 0) goto L_0x0077
            goto L_0x0012
        L_0x0077:
            r7 = 0
        L_0x0078:
            switch(r7) {
                case 0: goto L_0x009e;
                case 1: goto L_0x009d;
                case 2: goto L_0x009c;
                case 3: goto L_0x0099;
                case 4: goto L_0x0096;
                case 5: goto L_0x0095;
                case 6: goto L_0x0092;
                case 7: goto L_0x0091;
                case 8: goto L_0x0090;
                default: goto L_0x007b;
            }
        L_0x007b:
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r0 = "Ignoring simStatus: "
            r7.append(r0)
            r7.append(r8)
            java.lang.String r7 = r7.toString()
            logd(r7)
            return r6
        L_0x0090:
            return r4
        L_0x0091:
            return r0
        L_0x0092:
            r7 = 9
            return r7
        L_0x0095:
            return r1
        L_0x0096:
            r7 = 10
            return r7
        L_0x0099:
            r7 = 11
            return r7
        L_0x009c:
            return r2
        L_0x009d:
            return r3
        L_0x009e:
            return r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionInfoUpdater.internalIccStateToMessage(java.lang.String):int");
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isAllIccIdQueryDone() {
        for (int i = 0; i < TelephonyManager.getDefault().getActiveModemCount(); i++) {
            UiccSlot uiccSlotForPhone = UiccController.getInstance().getUiccSlotForPhone(i);
            int slotIdFromPhoneId = UiccController.getInstance().getSlotIdFromPhoneId(i);
            if (sIccId[i] == null || uiccSlotForPhone == null || !uiccSlotForPhone.isActive() || (uiccSlotForPhone.isEuicc() && UiccController.getInstance().getUiccPort(i) == null)) {
                if (sIccId[i] == null) {
                    logd("Wait for SIM " + i + " Iccid");
                } else {
                    logd(String.format("Wait for port corresponding to phone %d to be active, slotId is %d , portIndex is %d", new Object[]{Integer.valueOf(i), Integer.valueOf(slotIdFromPhoneId), Integer.valueOf(uiccSlotForPhone.getPortIndexFromPhoneId(i))}));
                }
                return false;
            }
        }
        logd("All IccIds query complete");
        return true;
    }

    public void handleMessage(Message message) {
        Object obj;
        ArrayList arrayList = new ArrayList();
        switch (message.what) {
            case 2:
                AsyncResult asyncResult = (AsyncResult) message.obj;
                Integer num = (Integer) asyncResult.userObj;
                if (asyncResult.exception != null || (obj = asyncResult.result) == null) {
                    logd("EVENT_GET_NETWORK_SELECTION_MODE_DONE: error getting network mode.");
                    return;
                } else if (((int[]) obj)[0] == 1) {
                    PhoneFactory.getPhone(num.intValue()).setNetworkSelectionModeAutomatic((Message) null);
                    return;
                } else {
                    return;
                }
            case 3:
                handleSimLoaded(message.arg1);
                return;
            case 4:
                handleSimAbsent(message.arg1);
                return;
            case 5:
                handleSimLocked(message.arg1, (String) message.obj);
                return;
            case 6:
                handleSimError(message.arg1);
                return;
            case 7:
                broadcastSimStateChanged(message.arg1, "UNKNOWN", (String) null);
                broadcastSimCardStateChanged(message.arg1, 0);
                broadcastSimApplicationStateChanged(message.arg1, 0);
                updateSubscriptionCarrierId(message.arg1, "UNKNOWN");
                updateCarrierServices(message.arg1, "UNKNOWN");
                return;
            case 8:
                broadcastSimStateChanged(message.arg1, "CARD_RESTRICTED", "CARD_RESTRICTED");
                broadcastSimCardStateChanged(message.arg1, 9);
                broadcastSimApplicationStateChanged(message.arg1, 6);
                updateSubscriptionCarrierId(message.arg1, "CARD_RESTRICTED");
                updateCarrierServices(message.arg1, "CARD_RESTRICTED");
                return;
            case 9:
                arrayList.add(Integer.valueOf(getCardIdFromPhoneId(message.arg1)));
                updateEmbeddedSubscriptions(arrayList, new SubscriptionInfoUpdater$$ExternalSyntheticLambda1(this));
                handleSimNotReady(message.arg1);
                return;
            case 10:
                handleSimReady(message.arg1);
                return;
            case 11:
                broadcastSimStateChanged(message.arg1, "IMSI", (String) null);
                return;
            case 12:
                arrayList.add(Integer.valueOf(message.arg1));
                updateEmbeddedSubscriptions(arrayList, new SubscriptionInfoUpdater$$ExternalSyntheticLambda2(this, (Runnable) message.obj));
                return;
            case 13:
                onMultiSimConfigChanged();
                return;
            case 14:
                handleInactivePortIccStateChange(message.arg1, (String) message.obj);
                return;
            default:
                logd("Unknown msg:" + message.what);
                return;
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$handleMessage$0(boolean z) {
        if (z) {
            this.mSubscriptionController.notifySubscriptionInfoChanged();
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$handleMessage$1(Runnable runnable, boolean z) {
        if (z) {
            this.mSubscriptionController.notifySubscriptionInfoChanged();
        }
        if (runnable != null) {
            runnable.run();
        }
    }

    /* access modifiers changed from: protected */
    public void onMultiSimConfigChanged() {
        for (int activeModemCount = ((TelephonyManager) sContext.getSystemService("phone")).getActiveModemCount(); activeModemCount < SUPPORTED_MODEM_COUNT; activeModemCount++) {
            sIccId[activeModemCount] = null;
            sSimCardState[activeModemCount] = 0;
            sSimApplicationState[activeModemCount] = 0;
        }
    }

    /* access modifiers changed from: protected */
    public int getCardIdFromPhoneId(int i) {
        UiccController instance = UiccController.getInstance();
        UiccCard uiccCardForPhone = instance.getUiccCardForPhone(i);
        if (uiccCardForPhone != null) {
            return instance.convertToPublicCardId(uiccCardForPhone.getCardId());
        }
        return -2;
    }

    /* access modifiers changed from: package-private */
    public void requestEmbeddedSubscriptionInfoListRefresh(int i, Runnable runnable) {
        sendMessage(obtainMessage(12, i, 0, runnable));
    }

    /* access modifiers changed from: protected */
    public void handleSimLocked(int i, String str) {
        String str2 = sIccId[i];
        if (str2 != null && str2.equals(ICCID_STRING_FOR_NO_SIM)) {
            logd("SIM" + (i + 1) + " hot plug in");
            sIccId[i] = null;
        }
        IccCard iccCard = PhoneFactory.getPhone(i).getIccCard();
        if (iccCard == null) {
            logd("handleSimLocked: IccCard null");
            return;
        }
        IccRecords iccRecords = iccCard.getIccRecords();
        if (iccRecords == null) {
            logd("handleSimLocked: IccRecords null");
        } else if (IccUtils.stripTrailingFs(iccRecords.getFullIccId()) == null) {
            logd("handleSimLocked: IccID null");
        } else {
            sIccId[i] = IccUtils.stripTrailingFs(iccRecords.getFullIccId());
            updateSubscriptionInfoByIccId(i, true);
            broadcastSimStateChanged(i, "LOCKED", str);
            broadcastSimCardStateChanged(i, 11);
            broadcastSimApplicationStateChanged(i, getSimStateFromLockedReason(str));
            updateSubscriptionCarrierId(i, "LOCKED");
            updateCarrierServices(i, "LOCKED");
        }
    }

    protected static int getSimStateFromLockedReason(String str) {
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case -1733499378:
                if (str.equals("NETWORK")) {
                    c = 0;
                    break;
                }
                break;
            case 79221:
                if (str.equals("PIN")) {
                    c = 1;
                    break;
                }
                break;
            case 79590:
                if (str.equals("PUK")) {
                    c = 2;
                    break;
                }
                break;
            case 190660331:
                if (str.equals("PERM_DISABLED")) {
                    c = 3;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                return 4;
            case 1:
                return 2;
            case 2:
                return 3;
            case 3:
                return 7;
            default:
                Rlog.e(LOG_TAG, "Unexpected SIM locked reason " + str);
                return 0;
        }
    }

    /* access modifiers changed from: protected */
    public void handleSimReady(int i) {
        String str;
        ArrayList arrayList = new ArrayList();
        logd("handleSimReady: phoneId: " + i);
        String str2 = sIccId[i];
        if (str2 != null && str2.equals(ICCID_STRING_FOR_NO_SIM)) {
            logd(" SIM" + (i + 1) + " hot plug in");
            sIccId[i] = null;
        }
        UiccPort uiccPort = UiccController.getInstance().getUiccPort(i);
        if (uiccPort == null) {
            str = null;
        } else {
            str = IccUtils.stripTrailingFs(uiccPort.getIccId());
        }
        if (!TextUtils.isEmpty(str)) {
            sIccId[i] = str;
            updateSubscriptionInfoByIccId(i, true);
        }
        arrayList.add(Integer.valueOf(getCardIdFromPhoneId(i)));
        updateEmbeddedSubscriptions(arrayList, new SubscriptionInfoUpdater$$ExternalSyntheticLambda3(this));
        broadcastSimStateChanged(i, "READY", (String) null);
        broadcastSimCardStateChanged(i, 11);
        broadcastSimApplicationStateChanged(i, 6);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$handleSimReady$2(boolean z) {
        if (z) {
            this.mSubscriptionController.notifySubscriptionInfoChanged();
        }
    }

    /* access modifiers changed from: protected */
    public void handleSimNotReady(int i) {
        String str;
        logd("handleSimNotReady: phoneId: " + i);
        IccCard iccCard = PhoneFactory.getPhone(i).getIccCard();
        boolean areUiccAppsDisabledOnCard = areUiccAppsDisabledOnCard(i);
        boolean z = false;
        if (iccCard.isEmptyProfile() || areUiccAppsDisabledOnCard) {
            if (areUiccAppsDisabledOnCard) {
                UiccPort uiccPort = UiccController.getInstance().getUiccPort(i);
                if (uiccPort == null) {
                    str = null;
                } else {
                    str = uiccPort.getIccId();
                }
                sInactiveIccIds[i] = IccUtils.stripTrailingFs(str);
            }
            sIccId[i] = ICCID_STRING_FOR_NO_SIM;
            updateSubscriptionInfoByIccId(i, false);
            z = true;
        } else {
            sIccId[i] = null;
        }
        broadcastSimStateChanged(i, "NOT_READY", (String) null);
        broadcastSimCardStateChanged(i, 11);
        broadcastSimApplicationStateChanged(i, 6);
        if (z) {
            updateCarrierServices(i, "NOT_READY");
        }
    }

    /* access modifiers changed from: protected */
    public boolean areUiccAppsDisabledOnCard(int i) {
        String str;
        SubscriptionInfo subInfoForIccId;
        if (UiccController.getInstance().getUiccSlotForPhone(i) == null) {
            return false;
        }
        UiccPort uiccPort = UiccController.getInstance().getUiccPort(i);
        if (uiccPort == null) {
            str = null;
        } else {
            str = uiccPort.getIccId();
        }
        if (str == null || (subInfoForIccId = this.mSubscriptionController.getSubInfoForIccId(IccUtils.stripTrailingFs(str))) == null || subInfoForIccId.areUiccApplicationsEnabled()) {
            return false;
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public void handleSimLoaded(int i) {
        logd("handleSimLoaded: phoneId: " + i);
        IccCard iccCard = PhoneFactory.getPhone(i).getIccCard();
        if (iccCard == null) {
            logd("handleSimLoaded: IccCard null");
            return;
        }
        IccRecords iccRecords = iccCard.getIccRecords();
        if (iccRecords == null) {
            logd("handleSimLoaded: IccRecords null");
        } else if (IccUtils.stripTrailingFs(iccRecords.getFullIccId()) == null) {
            logd("handleSimLoaded: IccID null");
        } else {
            String[] strArr = sIccId;
            if (strArr[i] == null) {
                strArr[i] = IccUtils.stripTrailingFs(iccRecords.getFullIccId());
                updateSubscriptionInfoByIccId(i, true);
            }
            List<SubscriptionInfo> subInfoUsingSlotIndexPrivileged = this.mSubscriptionController.getSubInfoUsingSlotIndexPrivileged(i);
            if (subInfoUsingSlotIndexPrivileged == null || subInfoUsingSlotIndexPrivileged.isEmpty()) {
                loge("empty subinfo for phoneId: " + i + "could not update ContentResolver");
            } else {
                for (SubscriptionInfo subscriptionId : subInfoUsingSlotIndexPrivileged) {
                    int subscriptionId2 = subscriptionId.getSubscriptionId();
                    TelephonyManager telephonyManager = (TelephonyManager) sContext.getSystemService("phone");
                    String simOperatorNumeric = telephonyManager.getSimOperatorNumeric(subscriptionId2);
                    if (!TextUtils.isEmpty(simOperatorNumeric)) {
                        if (subscriptionId2 == this.mSubscriptionController.getDefaultSubId()) {
                            MccTable.updateMccMncConfiguration(sContext, simOperatorNumeric);
                        }
                        this.mSubscriptionController.setMccMnc(simOperatorNumeric, subscriptionId2);
                    } else {
                        logd("EVENT_RECORDS_LOADED Operator name is null");
                    }
                    String simCountryIsoForPhone = TelephonyManager.getSimCountryIsoForPhone(i);
                    if (!TextUtils.isEmpty(simCountryIsoForPhone)) {
                        this.mSubscriptionController.setCountryIso(simCountryIsoForPhone, subscriptionId2);
                    } else {
                        logd("EVENT_RECORDS_LOADED sim country iso is null");
                    }
                    String line1Number = telephonyManager.getLine1Number(subscriptionId2);
                    if (line1Number != null) {
                        this.mSubscriptionController.setDisplayNumber(line1Number, subscriptionId2);
                    }
                    String subscriberId = telephonyManager.createForSubscriptionId(subscriptionId2).getSubscriberId();
                    if (subscriberId != null) {
                        this.mSubscriptionController.setImsi(subscriberId, subscriptionId2);
                    }
                    String[] ehplmns = iccRecords.getEhplmns();
                    String[] plmnsFromHplmnActRecord = iccRecords.getPlmnsFromHplmnActRecord();
                    if (!(ehplmns == null && plmnsFromHplmnActRecord == null)) {
                        this.mSubscriptionController.setAssociatedPlmns(ehplmns, plmnsFromHplmnActRecord, subscriptionId2);
                    }
                    SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(sContext);
                    if (defaultSharedPreferences.getInt(CURR_SUBID + i, -1) != subscriptionId2) {
                        PhoneFactory.getPhone(i).getNetworkSelectionMode(obtainMessage(2, new Integer(i)));
                        SharedPreferences.Editor edit = defaultSharedPreferences.edit();
                        edit.putInt(CURR_SUBID + i, subscriptionId2);
                        edit.apply();
                    }
                }
            }
            broadcastSimStateChanged(i, "LOADED", (String) null);
            broadcastSimCardStateChanged(i, 11);
            broadcastSimApplicationStateChanged(i, 10);
            updateSubscriptionCarrierId(i, "LOADED");
            restoreSimSpecificSettingsForPhone(i);
            updateCarrierServices(i, "LOADED");
        }
    }

    @VisibleForTesting
    public int calculateUsageSetting(int i, int i2) {
        try {
            sContext.getResources().getInteger(17694804);
            int[] intArray = sContext.getResources().getIntArray(17236147);
            if (intArray != null && intArray.length >= 1) {
                if (i < 0 || i > 2) {
                    logd("Updating usage setting for current subscription");
                    i = 0;
                }
                if (i2 < 0 || i2 > 2) {
                    loge("Invalid usage setting!" + i2);
                } else if (i2 == 0) {
                    return i2;
                } else {
                    for (int i3 : intArray) {
                        if (i2 == i3) {
                            return i2;
                        }
                    }
                    return i;
                }
            }
            return i;
        } catch (Resources.NotFoundException unused) {
            loge("Failed to load usage setting resources!");
            return i;
        }
    }

    /* access modifiers changed from: protected */
    public void restoreSimSpecificSettingsForPhone(int i) {
        SubscriptionManager.from(sContext).restoreSimSpecificSettingsForIccIdFromBackup(sIccId[i]);
    }

    /* access modifiers changed from: protected */
    public void updateCarrierServices(int i, String str) {
        if (!SubscriptionManager.isValidPhoneId(i)) {
            logd("Ignore updateCarrierServices request with invalid phoneId " + i);
            return;
        }
        ((CarrierConfigManager) sContext.getSystemService("carrier_config")).updateConfigForPhoneId(i, str);
        this.mCarrierServiceBindHelper.updateForPhoneId(i, str);
    }

    /* access modifiers changed from: protected */
    public void updateSubscriptionCarrierId(int i, String str) {
        if (PhoneFactory.getPhone(i) != null) {
            PhoneFactory.getPhone(i).resolveSubscriptionCarrierId(str);
        }
    }

    private void handleInactivePortIccStateChange(int i, String str) {
        if (SubscriptionManager.isValidPhoneId(i)) {
            String str2 = sIccId[i];
            if (str2 != null && !str2.equals(ICCID_STRING_FOR_NO_SIM)) {
                logd("Slot of SIM" + (i + 1) + " becomes inactive");
            }
            cleanSubscriptionInPhone(i, false);
        }
        if (!TextUtils.isEmpty(str)) {
            String stripTrailingFs = IccUtils.stripTrailingFs(str);
            if (this.mSubscriptionController.getSubInfoForIccId(stripTrailingFs) == null) {
                this.mSubscriptionController.insertEmptySubInfoRecord(stripTrailingFs, "CARD", -1, 0);
            }
        }
    }

    private void cleanSubscriptionInPhone(int i, boolean z) {
        String str;
        if (sInactiveIccIds[i] != null || (z && (str = sIccId[i]) != null && !str.equals(ICCID_STRING_FOR_NO_SIM))) {
            logd("cleanSubscriptionInPhone: " + i + ", inactive iccid " + sInactiveIccIds[i]);
            if (sInactiveIccIds[i] == null) {
                logd("cleanSubscriptionInPhone: " + i + ", isSimAbsent=" + z + ", iccid=" + sIccId[i]);
            }
            String str2 = sInactiveIccIds[i];
            if (str2 == null) {
                str2 = sIccId[i];
            }
            ContentValues contentValues = new ContentValues();
            contentValues.put("uicc_applications_enabled", Boolean.TRUE);
            if (z) {
                contentValues.put("port_index", -1);
            }
            ContentResolver contentResolver = sContext.getContentResolver();
            Uri uri = SubscriptionManager.CONTENT_URI;
            contentResolver.update(uri, contentValues, "icc_id='" + str2 + "'", (String[]) null);
            sInactiveIccIds[i] = null;
        }
        sIccId[i] = ICCID_STRING_FOR_NO_SIM;
        updateSubscriptionInfoByIccId(i, true);
    }

    /* access modifiers changed from: protected */
    public void handleSimAbsent(int i) {
        if (!SubscriptionManager.isValidPhoneId(i)) {
            logd("handleSimAbsent on invalid phoneId");
            return;
        }
        String str = sIccId[i];
        if (str != null && !str.equals(ICCID_STRING_FOR_NO_SIM)) {
            logd("SIM" + (i + 1) + " hot plug out");
        }
        cleanSubscriptionInPhone(i, true);
        broadcastSimStateChanged(i, "ABSENT", (String) null);
        broadcastSimCardStateChanged(i, 1);
        broadcastSimApplicationStateChanged(i, 0);
        updateSubscriptionCarrierId(i, "ABSENT");
        updateCarrierServices(i, "ABSENT");
    }

    /* access modifiers changed from: protected */
    public void handleSimError(int i) {
        String str = sIccId[i];
        if (str != null && !str.equals(ICCID_STRING_FOR_NO_SIM)) {
            logd("SIM" + (i + 1) + " Error ");
        }
        sIccId[i] = ICCID_STRING_FOR_NO_SIM;
        updateSubscriptionInfoByIccId(i, true);
        broadcastSimStateChanged(i, "CARD_IO_ERROR", "CARD_IO_ERROR");
        broadcastSimCardStateChanged(i, 8);
        broadcastSimApplicationStateChanged(i, 6);
        updateSubscriptionCarrierId(i, "CARD_IO_ERROR");
        updateCarrierServices(i, "CARD_IO_ERROR");
    }

    /* access modifiers changed from: protected */
    public synchronized void updateSubscriptionInfoByIccId(int i, boolean z) {
        logd("updateSubscriptionInfoByIccId:+ Start - phoneId: " + i);
        if (!SubscriptionManager.isValidPhoneId(i)) {
            loge("[updateSubscriptionInfoByIccId]- invalid phoneId=" + i);
            return;
        }
        logd("updateSubscriptionInfoByIccId: removing subscription info record: phoneId " + i);
        this.mSubscriptionController.clearSubInfoRecord(i);
        if (!ICCID_STRING_FOR_NO_SIM.equals(sIccId[i]) && sIccId[i] != null) {
            logd("updateSubscriptionInfoByIccId: adding subscription info record: iccid: " + sIccId[i] + ", phoneId:" + i);
            this.mSubscriptionManager.addSubscriptionInfoRecord(sIccId[i], i);
        }
        List<SubscriptionInfo> subInfoUsingSlotIndexPrivileged = this.mSubscriptionController.getSubInfoUsingSlotIndexPrivileged(i);
        if (subInfoUsingSlotIndexPrivileged != null) {
            boolean z2 = false;
            for (int i2 = 0; i2 < subInfoUsingSlotIndexPrivileged.size(); i2++) {
                SubscriptionInfo subscriptionInfo = subInfoUsingSlotIndexPrivileged.get(i2);
                ContentValues contentValues = new ContentValues(1);
                String line1Number = TelephonyManager.getDefault().getLine1Number(subscriptionInfo.getSubscriptionId());
                if (!TextUtils.equals(line1Number, subscriptionInfo.getNumber())) {
                    contentValues.put("number", line1Number);
                    sContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(subscriptionInfo.getSubscriptionId()), contentValues, (String) null, (String[]) null);
                    z2 = true;
                }
            }
            if (z2) {
                this.mSubscriptionController.refreshCachedActiveSubscriptionInfoList();
            }
        }
        if (isAllIccIdQueryDone()) {
            if (this.mSubscriptionManager.isActiveSubId(SubscriptionManager.getDefaultDataSubscriptionId())) {
                this.mSubscriptionManager.setDefaultDataSubId(SubscriptionManager.getDefaultDataSubscriptionId());
            } else {
                logd("bypass reset default data sub if inactive");
            }
            setSubInfoInitialized();
        }
        UiccController instance = UiccController.getInstance();
        UiccSlot[] uiccSlots = instance.getUiccSlots();
        if (uiccSlots != null && z) {
            ArrayList arrayList = new ArrayList();
            for (UiccSlot uiccSlot : uiccSlots) {
                if (!(uiccSlot == null || uiccSlot.getUiccCard() == null)) {
                    arrayList.add(Integer.valueOf(instance.convertToPublicCardId(uiccSlot.getUiccCard().getCardId())));
                }
            }
            updateEmbeddedSubscriptions(arrayList, new SubscriptionInfoUpdater$$ExternalSyntheticLambda6(this));
        }
        this.mSubscriptionController.notifySubscriptionInfoChanged();
        logd("updateSubscriptionInfoByIccId: SubscriptionInfo update complete");
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateSubscriptionInfoByIccId$3(boolean z) {
        if (z) {
            this.mSubscriptionController.notifySubscriptionInfoChanged();
        }
        logd("updateSubscriptionInfoByIccId: SubscriptionInfo update complete");
    }

    /* access modifiers changed from: protected */
    public void setSubInfoInitialized() {
        if (!sIsSubInfoInitialized) {
            logd("SubInfo Initialized");
            sIsSubInfoInitialized = true;
            this.mSubscriptionController.notifySubInfoReady();
        }
        MultiSimSettingController.getInstance().notifyAllSubscriptionLoaded();
    }

    public static boolean isSubInfoInitialized() {
        return sIsSubInfoInitialized;
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void updateEmbeddedSubscriptions(List<Integer> list, UpdateEmbeddedSubsCallback updateEmbeddedSubsCallback) {
        if (!this.mEuiccManager.isEnabled()) {
            logd("updateEmbeddedSubscriptions: eUICC not enabled");
            updateEmbeddedSubsCallback.run(false);
            return;
        }
        this.mBackgroundHandler.post(new SubscriptionInfoUpdater$$ExternalSyntheticLambda4(this, list, updateEmbeddedSubsCallback));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateEmbeddedSubscriptions$5(List list, UpdateEmbeddedSubsCallback updateEmbeddedSubsCallback) {
        ArrayList arrayList = new ArrayList();
        Iterator it = list.iterator();
        while (it.hasNext()) {
            int intValue = ((Integer) it.next()).intValue();
            GetEuiccProfileInfoListResult blockingGetEuiccProfileInfoList = EuiccController.get().blockingGetEuiccProfileInfoList(intValue);
            logd("blockingGetEuiccProfileInfoList cardId " + intValue);
            arrayList.add(Pair.create(Integer.valueOf(intValue), blockingGetEuiccProfileInfoList));
        }
        post(new SubscriptionInfoUpdater$$ExternalSyntheticLambda5(this, arrayList, updateEmbeddedSubsCallback));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateEmbeddedSubscriptions$4(List list, UpdateEmbeddedSubsCallback updateEmbeddedSubsCallback) {
        Iterator it = list.iterator();
        boolean z = false;
        while (it.hasNext()) {
            Pair pair = (Pair) it.next();
            if (updateEmbeddedSubscriptionsCache(((Integer) pair.first).intValue(), (GetEuiccProfileInfoListResult) pair.second)) {
                z = true;
            }
        }
        if (updateEmbeddedSubsCallback != null) {
            updateEmbeddedSubsCallback.run(z);
        }
    }

    private boolean updateEmbeddedSubscriptionsCache(int i, GetEuiccProfileInfoListResult getEuiccProfileInfoListResult) {
        boolean z;
        int i2;
        int i3;
        byte[] bArr;
        int i4 = i;
        logd("updateEmbeddedSubscriptionsCache");
        boolean z2 = true;
        if (getEuiccProfileInfoListResult == null) {
            logd("updateEmbeddedSubscriptionsCache: IPC to the eUICC controller failed");
            this.retryUpdateEmbeddedSubscriptionCards.add(Integer.valueOf(i));
            this.shouldRetryUpdateEmbeddedSubscriptions = true;
            return false;
        }
        List profiles = getEuiccProfileInfoListResult.getProfiles();
        if (getEuiccProfileInfoListResult.getResult() != 0 || profiles == null) {
            StringBuilder sb = new StringBuilder();
            sb.append("blockingGetEuiccProfileInfoList returns an error. Result code=");
            sb.append(getEuiccProfileInfoListResult.getResult());
            sb.append(". Null profile list=");
            sb.append(getEuiccProfileInfoListResult.getProfiles() == null);
            logd(sb.toString());
            return false;
        }
        EuiccProfileInfo[] euiccProfileInfoArr = (EuiccProfileInfo[]) profiles.toArray(new EuiccProfileInfo[profiles.size()]);
        logd("blockingGetEuiccProfileInfoList: got " + getEuiccProfileInfoListResult.getProfiles().size() + " profiles");
        boolean isRemovable = getEuiccProfileInfoListResult.getIsRemovable();
        String[] strArr = new String[euiccProfileInfoArr.length];
        for (int i5 = 0; i5 < euiccProfileInfoArr.length; i5++) {
            strArr[i5] = euiccProfileInfoArr[i5].getIccid();
        }
        logd("Get eUICC profile list of size " + euiccProfileInfoArr.length);
        List<SubscriptionInfo> subscriptionInfoListForEmbeddedSubscriptionUpdate = this.mSubscriptionController.getSubscriptionInfoListForEmbeddedSubscriptionUpdate(strArr, isRemovable);
        ContentResolver contentResolver = sContext.getContentResolver();
        int length = euiccProfileInfoArr.length;
        int i6 = 0;
        boolean z3 = false;
        while (i6 < length) {
            EuiccProfileInfo euiccProfileInfo = euiccProfileInfoArr[i6];
            int findSubscriptionInfoForIccid = findSubscriptionInfoForIccid(subscriptionInfoListForEmbeddedSubscriptionUpdate, euiccProfileInfo.getIccid());
            if (findSubscriptionInfoForIccid < 0) {
                this.mSubscriptionController.insertEmptySubInfoRecord(euiccProfileInfo.getIccid(), -1);
                i2 = -1;
                i3 = 0;
            } else {
                i3 = subscriptionInfoListForEmbeddedSubscriptionUpdate.get(findSubscriptionInfoForIccid).getNameSource();
                i2 = subscriptionInfoListForEmbeddedSubscriptionUpdate.get(findSubscriptionInfoForIccid).getCarrierId();
                subscriptionInfoListForEmbeddedSubscriptionUpdate.remove(findSubscriptionInfoForIccid);
            }
            StringBuilder sb2 = new StringBuilder();
            sb2.append("embeddedProfile ");
            sb2.append(euiccProfileInfo);
            sb2.append(" existing record ");
            sb2.append(findSubscriptionInfoForIccid < 0 ? "not found" : "found");
            logd(sb2.toString());
            ContentValues contentValues = new ContentValues();
            contentValues.put("is_embedded", 1);
            List uiccAccessRules = euiccProfileInfo.getUiccAccessRules();
            if (uiccAccessRules == null || uiccAccessRules.size() == 0) {
                bArr = null;
            } else {
                bArr = UiccAccessRule.encodeRules((UiccAccessRule[]) uiccAccessRules.toArray(new UiccAccessRule[uiccAccessRules.size()]));
            }
            contentValues.put("access_rules", bArr);
            contentValues.put("is_removable", Boolean.valueOf(isRemovable));
            if (SubscriptionController.getNameSourcePriority(i3) <= SubscriptionController.getNameSourcePriority(3)) {
                contentValues.put("display_name", euiccProfileInfo.getNickname());
                contentValues.put("name_source", 3);
            }
            contentValues.put("profile_class", Integer.valueOf(euiccProfileInfo.getProfileClass()));
            contentValues.put("port_index", Integer.valueOf(getEmbeddedProfilePortIndex(euiccProfileInfo.getIccid())));
            CarrierIdentifier carrierIdentifier = euiccProfileInfo.getCarrierIdentifier();
            if (carrierIdentifier != null) {
                if (i2 == -1) {
                    contentValues.put("carrier_id", Integer.valueOf(CarrierResolver.getCarrierIdFromIdentifier(sContext, carrierIdentifier)));
                }
                String mcc = carrierIdentifier.getMcc();
                String mnc = carrierIdentifier.getMnc();
                contentValues.put("mcc_string", mcc);
                contentValues.put("mcc", mcc);
                contentValues.put("mnc_string", mnc);
                contentValues.put("mnc", mnc);
            }
            UiccController instance = UiccController.getInstance();
            if (i4 >= 0 && instance.getCardIdForDefaultEuicc() != -1) {
                contentValues.put("card_id", instance.convertToCardString(i4));
            }
            contentResolver.update(SubscriptionManager.CONTENT_URI, contentValues, "icc_id='" + euiccProfileInfo.getIccid() + "'", (String[]) null);
            this.mSubscriptionController.refreshCachedActiveSubscriptionInfoList();
            i6++;
            z2 = true;
            z3 = true;
        }
        boolean z4 = z2;
        if (!subscriptionInfoListForEmbeddedSubscriptionUpdate.isEmpty()) {
            logd("Removing existing embedded subscriptions of size" + subscriptionInfoListForEmbeddedSubscriptionUpdate.size());
            ArrayList arrayList = new ArrayList();
            for (int i7 = 0; i7 < subscriptionInfoListForEmbeddedSubscriptionUpdate.size(); i7++) {
                SubscriptionInfo subscriptionInfo = subscriptionInfoListForEmbeddedSubscriptionUpdate.get(i7);
                if (subscriptionInfo.isEmbedded()) {
                    logd("Removing embedded subscription of IccId " + subscriptionInfo.getIccId());
                    arrayList.add("'" + subscriptionInfo.getIccId() + "'");
                }
            }
            ContentValues contentValues2 = new ContentValues();
            contentValues2.put("is_embedded", 0);
            contentResolver.update(SubscriptionManager.CONTENT_URI, contentValues2, "icc_id IN (" + TextUtils.join(",", arrayList) + ")", (String[]) null);
            this.mSubscriptionController.refreshCachedActiveSubscriptionInfoList();
            z = z4;
        } else {
            z = z3;
        }
        logd("updateEmbeddedSubscriptions done hasChanges=" + z);
        return z;
    }

    private int getEmbeddedProfilePortIndex(String str) {
        for (UiccSlot uiccSlot : UiccController.getInstance().getUiccSlots()) {
            if (uiccSlot != null && uiccSlot.isEuicc() && uiccSlot.getPortIndexFromIccId(str) != -1) {
                return uiccSlot.getPortIndexFromIccId(str);
            }
        }
        return -1;
    }

    public void updateSubscriptionByCarrierConfigAndNotifyComplete(int i, String str, PersistableBundle persistableBundle, Message message) {
        post(new SubscriptionInfoUpdater$$ExternalSyntheticLambda0(this, i, str, persistableBundle, message));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateSubscriptionByCarrierConfigAndNotifyComplete$6(int i, String str, PersistableBundle persistableBundle, Message message) {
        updateSubscriptionByCarrierConfig(i, str, persistableBundle);
        message.sendToTarget();
    }

    private String getDefaultCarrierServicePackageName() {
        return ((CarrierConfigManager) sContext.getSystemService("carrier_config")).getDefaultCarrierServicePackageName();
    }

    private boolean isCarrierServicePackage(int i, String str) {
        if (str.equals(getDefaultCarrierServicePackageName())) {
            return false;
        }
        String carrierServicePackageNameForLogicalSlot = TelephonyManager.from(sContext).getCarrierServicePackageNameForLogicalSlot(i);
        logd("Carrier service package for subscription = " + carrierServicePackageNameForLogicalSlot);
        return str.equals(carrierServicePackageNameForLogicalSlot);
    }

    /* JADX WARNING: Removed duplicated region for block: B:46:0x0154  */
    /* JADX WARNING: Removed duplicated region for block: B:47:0x0183  */
    /* JADX WARNING: Removed duplicated region for block: B:52:0x01bd  */
    /* JADX WARNING: Removed duplicated region for block: B:63:? A[RETURN, SYNTHETIC] */
    @com.android.internal.annotations.VisibleForTesting
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void updateSubscriptionByCarrierConfig(int r9, java.lang.String r10, android.os.PersistableBundle r11) {
        /*
            r8 = this;
            boolean r0 = android.telephony.SubscriptionManager.isValidPhoneId(r9)
            if (r0 == 0) goto L_0x01d5
            boolean r0 = android.text.TextUtils.isEmpty(r10)
            if (r0 != 0) goto L_0x01d5
            if (r11 != 0) goto L_0x0010
            goto L_0x01d5
        L_0x0010:
            com.android.internal.telephony.SubscriptionController r0 = r8.mSubscriptionController
            int r0 = r0.getSubIdUsingPhoneId(r9)
            boolean r1 = android.telephony.SubscriptionManager.isValidSubscriptionId(r0)
            if (r1 == 0) goto L_0x01cf
            r1 = 2147483647(0x7fffffff, float:NaN)
            if (r0 != r1) goto L_0x0023
            goto L_0x01cf
        L_0x0023:
            com.android.internal.telephony.SubscriptionController r1 = r8.mSubscriptionController
            android.telephony.SubscriptionInfo r1 = r1.getSubscriptionInfo(r0)
            if (r1 != 0) goto L_0x0031
            java.lang.String r8 = "Couldn't retrieve subscription info for current subscription"
            loge(r8)
            return
        L_0x0031:
            android.content.ContentValues r2 = new android.content.ContentValues
            r2.<init>()
            java.lang.String r3 = "carrier_certificate_string_array"
            java.lang.String[] r3 = r11.getStringArray(r3)
            android.telephony.UiccAccessRule[] r3 = android.telephony.UiccAccessRule.decodeRulesFromCarrierConfig(r3)
            byte[] r3 = android.telephony.UiccAccessRule.encodeRules(r3)
            java.lang.String r4 = "access_rules_from_carrier_configs"
            r2.put(r4, r3)
            boolean r9 = r8.isCarrierServicePackage(r9, r10)
            r3 = 0
            if (r9 != 0) goto L_0x006e
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r4 = "Cannot manage subId="
            r9.append(r4)
            r9.append(r0)
            java.lang.String r4 = ", carrierPackage="
            r9.append(r4)
            r9.append(r10)
            java.lang.String r9 = r9.toString()
            loge(r9)
            goto L_0x013a
        L_0x006e:
            r9 = 0
            java.lang.String r4 = "is_opportunistic_subscription_bool"
            boolean r9 = r11.getBoolean(r4, r9)
            boolean r4 = r1.isOpportunistic()
            if (r4 == r9) goto L_0x00a3
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            java.lang.String r5 = "Set SubId="
            r4.append(r5)
            r4.append(r0)
            java.lang.String r5 = " isOpportunistic="
            r4.append(r5)
            r4.append(r9)
            java.lang.String r4 = r4.toString()
            logd(r4)
            if (r9 == 0) goto L_0x009c
            java.lang.String r9 = "1"
            goto L_0x009e
        L_0x009c:
            java.lang.String r9 = "0"
        L_0x009e:
            java.lang.String r4 = "is_opportunistic"
            r2.put(r4, r9)
        L_0x00a3:
            java.lang.String r9 = "subscription_group_uuid_string"
            java.lang.String r4 = ""
            java.lang.String r9 = r11.getString(r9, r4)
            boolean r4 = android.text.TextUtils.isEmpty(r9)
            if (r4 != 0) goto L_0x013a
            android.os.ParcelUuid r4 = android.os.ParcelUuid.fromString(r9)     // Catch:{ IllegalArgumentException -> 0x0124 }
            android.os.ParcelUuid r5 = REMOVE_GROUP_UUID     // Catch:{ IllegalArgumentException -> 0x0125 }
            boolean r5 = r4.equals(r5)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r6 = "group_uuid"
            if (r5 == 0) goto L_0x00de
            android.os.ParcelUuid r5 = r1.getGroupUuid()     // Catch:{ IllegalArgumentException -> 0x0125 }
            if (r5 == 0) goto L_0x00de
            r2.put(r6, r3)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ IllegalArgumentException -> 0x0125 }
            r10.<init>()     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r5 = "Group Removed for"
            r10.append(r5)     // Catch:{ IllegalArgumentException -> 0x0125 }
            r10.append(r0)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r10 = r10.toString()     // Catch:{ IllegalArgumentException -> 0x0125 }
            logd(r10)     // Catch:{ IllegalArgumentException -> 0x0125 }
            goto L_0x013b
        L_0x00de:
            com.android.internal.telephony.SubscriptionController r5 = r8.mSubscriptionController     // Catch:{ IllegalArgumentException -> 0x0125 }
            boolean r5 = r5.canPackageManageGroup(r4, r10)     // Catch:{ IllegalArgumentException -> 0x0125 }
            if (r5 == 0) goto L_0x0107
            java.lang.String r5 = r4.toString()     // Catch:{ IllegalArgumentException -> 0x0125 }
            r2.put(r6, r5)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r5 = "group_owner"
            r2.put(r5, r10)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ IllegalArgumentException -> 0x0125 }
            r10.<init>()     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r5 = "Group Added for"
            r10.append(r5)     // Catch:{ IllegalArgumentException -> 0x0125 }
            r10.append(r0)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r10 = r10.toString()     // Catch:{ IllegalArgumentException -> 0x0125 }
            logd(r10)     // Catch:{ IllegalArgumentException -> 0x0125 }
            goto L_0x013b
        L_0x0107:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ IllegalArgumentException -> 0x0125 }
            r5.<init>()     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r6 = "configPackageName "
            r5.append(r6)     // Catch:{ IllegalArgumentException -> 0x0125 }
            r5.append(r10)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r10 = " doesn't own grouUuid "
            r5.append(r10)     // Catch:{ IllegalArgumentException -> 0x0125 }
            r5.append(r4)     // Catch:{ IllegalArgumentException -> 0x0125 }
            java.lang.String r10 = r5.toString()     // Catch:{ IllegalArgumentException -> 0x0125 }
            loge(r10)     // Catch:{ IllegalArgumentException -> 0x0125 }
            goto L_0x013b
        L_0x0124:
            r4 = r3
        L_0x0125:
            java.lang.StringBuilder r10 = new java.lang.StringBuilder
            r10.<init>()
            java.lang.String r5 = "Invalid Group UUID="
            r10.append(r5)
            r10.append(r9)
            java.lang.String r9 = r10.toString()
            loge(r9)
            goto L_0x013b
        L_0x013a:
            r4 = r3
        L_0x013b:
            r9 = -1
            java.lang.String r10 = "cellular_usage_setting_int"
            int r9 = r11.getInt(r10, r9)
            int r10 = r1.getUsageSetting()
            int r10 = r8.calculateUsageSetting(r10, r9)
            int r11 = r1.getUsageSetting()
            java.lang.String r5 = " newSetting="
            java.lang.String r6 = " preferredSetting="
            if (r10 == r11) goto L_0x0183
            java.lang.Integer r11 = java.lang.Integer.valueOf(r10)
            java.lang.String r7 = "usage_setting"
            r2.put(r7, r11)
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r7 = "UsageSetting changed, oldSetting="
            r11.append(r7)
            int r1 = r1.getUsageSetting()
            r11.append(r1)
            r11.append(r6)
            r11.append(r9)
            r11.append(r5)
            r11.append(r10)
            java.lang.String r9 = r11.toString()
            logd(r9)
            goto L_0x01a7
        L_0x0183:
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r7 = "UsageSetting unchanged, oldSetting="
            r11.append(r7)
            int r1 = r1.getUsageSetting()
            r11.append(r1)
            r11.append(r6)
            r11.append(r9)
            r11.append(r5)
            r11.append(r10)
            java.lang.String r9 = r11.toString()
            logd(r9)
        L_0x01a7:
            int r9 = r2.size()
            if (r9 <= 0) goto L_0x01ce
            android.content.Context r9 = sContext
            android.content.ContentResolver r9 = r9.getContentResolver()
            android.net.Uri r10 = android.telephony.SubscriptionManager.getUriForSubscriptionId(r0)
            int r9 = r9.update(r10, r2, r3, r3)
            if (r9 <= 0) goto L_0x01ce
            com.android.internal.telephony.SubscriptionController r9 = r8.mSubscriptionController
            r9.refreshCachedActiveSubscriptionInfoList()
            com.android.internal.telephony.SubscriptionController r8 = r8.mSubscriptionController
            r8.notifySubscriptionInfoChanged()
            com.android.internal.telephony.MultiSimSettingController r8 = com.android.internal.telephony.MultiSimSettingController.getInstance()
            r8.notifySubscriptionGroupChanged(r4)
        L_0x01ce:
            return
        L_0x01cf:
            java.lang.String r8 = "No subscription is active for phone being updated"
            logd(r8)
            return
        L_0x01d5:
            java.lang.StringBuilder r8 = new java.lang.StringBuilder
            r8.<init>()
            java.lang.String r0 = "In updateSubscriptionByCarrierConfig(): phoneId="
            r8.append(r0)
            r8.append(r9)
            java.lang.String r9 = " configPackageName="
            r8.append(r9)
            r8.append(r10)
            java.lang.String r9 = " config="
            r8.append(r9)
            if (r11 != 0) goto L_0x01f4
            java.lang.String r9 = "null"
            goto L_0x01fc
        L_0x01f4:
            int r9 = r11.hashCode()
            java.lang.Integer r9 = java.lang.Integer.valueOf(r9)
        L_0x01fc:
            r8.append(r9)
            java.lang.String r8 = r8.toString()
            logd(r8)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionInfoUpdater.updateSubscriptionByCarrierConfig(int, java.lang.String, android.os.PersistableBundle):void");
    }

    private static int findSubscriptionInfoForIccid(List<SubscriptionInfo> list, String str) {
        for (int i = 0; i < list.size(); i++) {
            if (TextUtils.equals(str, list.get(i).getIccId())) {
                return i;
            }
        }
        return -1;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void broadcastSimStateChanged(int i, String str, String str2) {
        Intent intent = new Intent("android.intent.action.SIM_STATE_CHANGED");
        intent.addFlags(67108864);
        intent.putExtra("phoneName", "Phone");
        intent.putExtra("ss", str);
        intent.putExtra("reason", str2);
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, i);
        logd("Broadcasting intent ACTION_SIM_STATE_CHANGED " + str + " reason " + str2 + " for phone: " + i);
        IntentBroadcaster.getInstance().broadcastStickyIntent(sContext, intent, i);
    }

    /* access modifiers changed from: protected */
    public void broadcastSimCardStateChanged(int i, int i2) {
        int[] iArr = sSimCardState;
        if (i2 != iArr[i]) {
            iArr[i] = i2;
            Intent intent = new Intent("android.telephony.action.SIM_CARD_STATE_CHANGED");
            intent.addFlags(67108864);
            intent.putExtra("android.telephony.extra.SIM_STATE", i2);
            SubscriptionManager.putPhoneIdAndSubIdExtra(intent, i);
            UiccSlot uiccSlotForPhone = UiccController.getInstance().getUiccSlotForPhone(i);
            int slotIdFromPhoneId = UiccController.getInstance().getSlotIdFromPhoneId(i);
            intent.putExtra("slot", slotIdFromPhoneId);
            if (uiccSlotForPhone != null) {
                intent.putExtra("port", uiccSlotForPhone.getPortIndexFromPhoneId(i));
            }
            logd("Broadcasting intent ACTION_SIM_CARD_STATE_CHANGED " + simStateString(i2) + " for phone: " + i + " slot: " + slotIdFromPhoneId + " port: " + uiccSlotForPhone.getPortIndexFromPhoneId(i));
            sContext.sendBroadcast(intent, "android.permission.READ_PRIVILEGED_PHONE_STATE");
            TelephonyMetrics.getInstance().updateSimState(i, i2);
        }
    }

    /* access modifiers changed from: protected */
    public void broadcastSimApplicationStateChanged(int i, int i2) {
        boolean z = true;
        boolean z2 = sSimApplicationState[i] == 0 && i2 == 6;
        IccCard iccCard = PhoneFactory.getPhone(i).getIccCard();
        if (iccCard == null || !iccCard.isEmptyProfile()) {
            z = false;
        }
        int[] iArr = sSimApplicationState;
        if (i2 == iArr[i]) {
            return;
        }
        if (!z2 || z) {
            iArr[i] = i2;
            Intent intent = new Intent("android.telephony.action.SIM_APPLICATION_STATE_CHANGED");
            intent.addFlags(67108864);
            intent.putExtra("android.telephony.extra.SIM_STATE", i2);
            SubscriptionManager.putPhoneIdAndSubIdExtra(intent, i);
            UiccSlot uiccSlotForPhone = UiccController.getInstance().getUiccSlotForPhone(i);
            int slotIdFromPhoneId = UiccController.getInstance().getSlotIdFromPhoneId(i);
            intent.putExtra("slot", slotIdFromPhoneId);
            if (uiccSlotForPhone != null) {
                intent.putExtra("port", uiccSlotForPhone.getPortIndexFromPhoneId(i));
            }
            logd("Broadcasting intent ACTION_SIM_APPLICATION_STATE_CHANGED " + simStateString(i2) + " for phone: " + i + " slot: " + slotIdFromPhoneId + "port: " + uiccSlotForPhone.getPortIndexFromPhoneId(i));
            sContext.sendBroadcast(intent, "android.permission.READ_PRIVILEGED_PHONE_STATE");
            TelephonyMetrics.getInstance().updateSimState(i, i2);
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static void logd(String str) {
        Rlog.d(LOG_TAG, str);
    }

    private static void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("SubscriptionInfoUpdater:");
        this.mCarrierServiceBindHelper.dump(fileDescriptor, printWriter, strArr);
    }

    private static String initIccidStringForNoSim() {
        if (!SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
            return "";
        }
        try {
            Method declaredMethod = Class.forName("com.mediatek.internal.telephony.MtkSubscriptionInfoUpdater").getDeclaredMethod("initIccidStringForNoSim", new Class[0]);
            declaredMethod.setAccessible(true);
            return (String) declaredMethod.invoke((Object) null, new Object[0]);
        } catch (Exception e) {
            logd("No MtkSubscriptionInfoUpdater! Used AOSP instead! e: " + e);
            return "";
        }
    }
}
