package com.android.internal.telephony;

import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.content.pm.ResolveInfo;
import android.content.pm.ServiceInfo;
import android.content.pm.Signature;
import android.content.pm.UserInfo;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.UserHandle;
import android.os.UserManager;
import android.telephony.CarrierConfigManager;
import android.telephony.TelephonyManager;
import android.telephony.TelephonyRegistryManager;
import android.telephony.UiccAccessRule;
import android.util.ArrayMap;
import android.util.ArraySet;
import android.util.IntArray;
import android.util.Pair;
import com.android.internal.annotations.GuardedBy;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.UiccProfile;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.StringJoiner;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.function.Function;

public class CarrierPrivilegesTracker extends Handler {
    private static final int ACTION_CARRIER_CONFIG_CERTS_UPDATED = 3;
    private static final int ACTION_CLEAR_UICC_RULES = 9;
    private static final int ACTION_INITIALIZE_TRACKER = 7;
    private static final int ACTION_PACKAGE_ADDED_REPLACED_OR_CHANGED = 5;
    private static final int ACTION_PACKAGE_REMOVED_OR_DISABLED_BY_USER = 6;
    private static final int ACTION_REGISTER_LISTENER = 1;
    private static final int ACTION_SET_TEST_OVERRIDE_RULE = 8;
    private static final int ACTION_SIM_STATE_UPDATED = 4;
    private static final int ACTION_UICC_ACCESS_RULES_LOADED = 10;
    private static final int ACTION_UNREGISTER_LISTENER = 2;
    private static final long CLEAR_UICC_RULES_DELAY_MILLIS = TimeUnit.SECONDS.toMillis(0);
    private static final long CLEAR_UICC_RULE_NOT_SCHEDULED = -1;
    private static final int INSTALLED_PACKAGES_QUERY_FLAGS = 671121408;
    private static final String SHA_1 = "SHA-1";
    private static final String SHA_256 = "SHA-256";
    /* access modifiers changed from: private */
    public static final String TAG = CarrierPrivilegesTracker.class.getSimpleName();
    private static final boolean VDBG = false;
    private final Map<String, Set<Integer>> mCachedUids = new ArrayMap();
    private final CarrierConfigManager mCarrierConfigManager;
    private final List<UiccAccessRule> mCarrierConfigRules = new ArrayList();
    private long mClearUiccRulesUptimeMillis = -1;
    private final Context mContext;
    private final Map<String, Set<String>> mInstalledPackageCerts = new ArrayMap();
    private final BroadcastReceiver mIntentReceiver;
    private final LocalLog mLocalLog = new LocalLog(64);
    /* access modifiers changed from: private */
    public final PackageManager mPackageManager;
    private final Phone mPhone;
    @GuardedBy(anyOf = {"mPrivilegedPackageInfoLock.readLock()", "mPrivilegedPackageInfoLock.writeLock()"})
    private PrivilegedPackageInfo mPrivilegedPackageInfo = new PrivilegedPackageInfo();
    private final ReadWriteLock mPrivilegedPackageInfoLock = new ReentrantReadWriteLock();
    private final RegistrantList mRegistrantList = new RegistrantList();
    @GuardedBy(anyOf = {"mPrivilegedPackageInfoLock.readLock()", "mPrivilegedPackageInfoLock.writeLock()"})
    private boolean mSimIsReadyButNotLoaded = false;
    private final TelephonyManager mTelephonyManager;
    private final TelephonyRegistryManager mTelephonyRegistryManager;
    private List<UiccAccessRule> mTestOverrideRules = null;
    private final List<UiccAccessRule> mUiccRules = new ArrayList();
    private final UserManager mUserManager;

    private static final class PrivilegedPackageInfo {
        final Pair<String, Integer> mCarrierService;
        final Set<String> mPackageNames;
        final Set<Integer> mUids;

        PrivilegedPackageInfo() {
            this.mPackageNames = Collections.emptySet();
            this.mUids = Collections.emptySet();
            this.mCarrierService = new Pair<>((Object) null, -1);
        }

        PrivilegedPackageInfo(Set<String> set, Set<Integer> set2, Pair<String, Integer> pair) {
            this.mPackageNames = set;
            this.mUids = set2;
            this.mCarrierService = pair;
        }

        public String toString() {
            return "{packageNames=" + CarrierPrivilegesTracker.getObfuscatedPackages(this.mPackageNames, new CarrierPrivilegesTracker$PrivilegedPackageInfo$$ExternalSyntheticLambda0()) + ", uids=" + this.mUids + ", carrierServicePackageName=" + Rlog.pii(CarrierPrivilegesTracker.TAG, this.mCarrierService.first) + ", carrierServiceUid=" + this.mCarrierService.second + "}";
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (!(obj instanceof PrivilegedPackageInfo)) {
                return false;
            }
            PrivilegedPackageInfo privilegedPackageInfo = (PrivilegedPackageInfo) obj;
            if (!this.mPackageNames.equals(privilegedPackageInfo.mPackageNames) || !this.mUids.equals(privilegedPackageInfo.mUids) || !this.mCarrierService.equals(privilegedPackageInfo.mCarrierService)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{this.mPackageNames, this.mUids, this.mCarrierService});
        }
    }

    public CarrierPrivilegesTracker(Looper looper, Phone phone, Context context) {
        super(looper);
        AnonymousClass1 r3 = new BroadcastReceiver() {
            /* JADX WARNING: Can't fix incorrect switch cases order */
            /* Code decompiled incorrectly, please refer to instructions dump. */
            public void onReceive(android.content.Context r12, android.content.Intent r13) {
                /*
                    r11 = this;
                    java.lang.String r12 = r13.getAction()
                    if (r12 != 0) goto L_0x0007
                    return
                L_0x0007:
                    int r0 = r12.hashCode()
                    r1 = 4
                    java.lang.String r2 = "android.intent.action.PACKAGE_REMOVED"
                    java.lang.String r3 = "android.intent.action.PACKAGE_CHANGED"
                    r4 = 6
                    r5 = 5
                    r6 = 3
                    r7 = -1
                    r8 = 1
                    r9 = 0
                    switch(r0) {
                        case -1157582292: goto L_0x0059;
                        case -1138588223: goto L_0x004e;
                        case -810471698: goto L_0x0043;
                        case 172491798: goto L_0x003a;
                        case 525384130: goto L_0x0031;
                        case 657207618: goto L_0x0026;
                        case 1544582882: goto L_0x001b;
                        default: goto L_0x0019;
                    }
                L_0x0019:
                    r0 = r7
                    goto L_0x0063
                L_0x001b:
                    java.lang.String r0 = "android.intent.action.PACKAGE_ADDED"
                    boolean r0 = r12.equals(r0)
                    if (r0 != 0) goto L_0x0024
                    goto L_0x0019
                L_0x0024:
                    r0 = r4
                    goto L_0x0063
                L_0x0026:
                    java.lang.String r0 = "android.telephony.action.SIM_CARD_STATE_CHANGED"
                    boolean r0 = r12.equals(r0)
                    if (r0 != 0) goto L_0x002f
                    goto L_0x0019
                L_0x002f:
                    r0 = r5
                    goto L_0x0063
                L_0x0031:
                    boolean r0 = r12.equals(r2)
                    if (r0 != 0) goto L_0x0038
                    goto L_0x0019
                L_0x0038:
                    r0 = r1
                    goto L_0x0063
                L_0x003a:
                    boolean r0 = r12.equals(r3)
                    if (r0 != 0) goto L_0x0041
                    goto L_0x0019
                L_0x0041:
                    r0 = r6
                    goto L_0x0063
                L_0x0043:
                    java.lang.String r0 = "android.intent.action.PACKAGE_REPLACED"
                    boolean r0 = r12.equals(r0)
                    if (r0 != 0) goto L_0x004c
                    goto L_0x0019
                L_0x004c:
                    r0 = 2
                    goto L_0x0063
                L_0x004e:
                    java.lang.String r0 = "android.telephony.action.CARRIER_CONFIG_CHANGED"
                    boolean r0 = r12.equals(r0)
                    if (r0 != 0) goto L_0x0057
                    goto L_0x0019
                L_0x0057:
                    r0 = r8
                    goto L_0x0063
                L_0x0059:
                    java.lang.String r0 = "android.telephony.action.SIM_APPLICATION_STATE_CHANGED"
                    boolean r0 = r12.equals(r0)
                    if (r0 != 0) goto L_0x0062
                    goto L_0x0019
                L_0x0062:
                    r0 = r9
                L_0x0063:
                    switch(r0) {
                        case 0: goto L_0x00e4;
                        case 1: goto L_0x00ca;
                        case 2: goto L_0x0068;
                        case 3: goto L_0x0068;
                        case 4: goto L_0x0068;
                        case 5: goto L_0x00e4;
                        case 6: goto L_0x0068;
                        default: goto L_0x0066;
                    }
                L_0x0066:
                    goto L_0x0108
                L_0x0068:
                    android.net.Uri r13 = r13.getData()
                    if (r13 == 0) goto L_0x0073
                    java.lang.String r13 = r13.getSchemeSpecificPart()
                    goto L_0x0074
                L_0x0073:
                    r13 = 0
                L_0x0074:
                    boolean r0 = android.text.TextUtils.isEmpty(r13)
                    if (r0 == 0) goto L_0x0084
                    java.lang.String r11 = com.android.internal.telephony.CarrierPrivilegesTracker.TAG
                    java.lang.String r12 = "Failed to get package from Intent"
                    com.android.telephony.Rlog.e(r11, r12)
                    return
                L_0x0084:
                    boolean r0 = r12.equals(r2)
                    boolean r12 = r12.equals(r3)     // Catch:{ IllegalArgumentException -> 0x00a0 }
                    if (r12 == 0) goto L_0x009b
                    com.android.internal.telephony.CarrierPrivilegesTracker r12 = com.android.internal.telephony.CarrierPrivilegesTracker.this     // Catch:{ IllegalArgumentException -> 0x00a0 }
                    android.content.pm.PackageManager r12 = r12.mPackageManager     // Catch:{ IllegalArgumentException -> 0x00a0 }
                    int r12 = r12.getApplicationEnabledSetting(r13)     // Catch:{ IllegalArgumentException -> 0x00a0 }
                    if (r12 != r6) goto L_0x009b
                    goto L_0x009c
                L_0x009b:
                    r8 = r9
                L_0x009c:
                    r10 = r9
                    r9 = r8
                    r8 = r10
                    goto L_0x00b8
                L_0x00a0:
                    java.lang.String r12 = com.android.internal.telephony.CarrierPrivilegesTracker.TAG
                    java.lang.StringBuilder r1 = new java.lang.StringBuilder
                    r1.<init>()
                    java.lang.String r2 = "Package does not exist: "
                    r1.append(r2)
                    r1.append(r13)
                    java.lang.String r1 = r1.toString()
                    com.android.telephony.Rlog.w(r12, r1)
                L_0x00b8:
                    if (r0 != 0) goto L_0x00c0
                    if (r9 != 0) goto L_0x00c0
                    if (r8 == 0) goto L_0x00bf
                    goto L_0x00c0
                L_0x00bf:
                    r4 = r5
                L_0x00c0:
                    com.android.internal.telephony.CarrierPrivilegesTracker r11 = com.android.internal.telephony.CarrierPrivilegesTracker.this
                    android.os.Message r12 = r11.obtainMessage(r4, r13)
                    r11.sendMessage(r12)
                    goto L_0x0108
                L_0x00ca:
                    android.os.Bundle r12 = r13.getExtras()
                    java.lang.String r13 = "android.telephony.extra.SLOT_INDEX"
                    int r13 = r12.getInt(r13)
                    java.lang.String r0 = "android.telephony.extra.SUBSCRIPTION_INDEX"
                    int r12 = r12.getInt(r0, r7)
                    com.android.internal.telephony.CarrierPrivilegesTracker r11 = com.android.internal.telephony.CarrierPrivilegesTracker.this
                    android.os.Message r12 = r11.obtainMessage(r6, r12, r13)
                    r11.sendMessage(r12)
                    goto L_0x0108
                L_0x00e4:
                    android.os.Bundle r12 = r13.getExtras()
                    java.lang.String r13 = "android.telephony.extra.SIM_STATE"
                    int r13 = r12.getInt(r13, r9)
                    java.lang.String r0 = "phone"
                    int r12 = r12.getInt(r0, r7)
                    if (r13 == r8) goto L_0x00ff
                    if (r13 == r4) goto L_0x00ff
                    if (r13 == r5) goto L_0x00ff
                    r0 = 10
                    if (r13 == r0) goto L_0x00ff
                    return
                L_0x00ff:
                    com.android.internal.telephony.CarrierPrivilegesTracker r11 = com.android.internal.telephony.CarrierPrivilegesTracker.this
                    android.os.Message r12 = r11.obtainMessage(r1, r12, r13)
                    r11.sendMessage(r12)
                L_0x0108:
                    return
                */
                throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.CarrierPrivilegesTracker.AnonymousClass1.onReceive(android.content.Context, android.content.Intent):void");
            }
        };
        this.mIntentReceiver = r3;
        this.mContext = context;
        this.mPhone = phone;
        this.mPackageManager = context.getPackageManager();
        this.mUserManager = (UserManager) context.getSystemService("user");
        this.mCarrierConfigManager = (CarrierConfigManager) context.getSystemService("carrier_config");
        this.mTelephonyManager = (TelephonyManager) context.getSystemService("phone");
        this.mTelephonyRegistryManager = (TelephonyRegistryManager) context.getSystemService("telephony_registry");
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction("android.telephony.action.SIM_CARD_STATE_CHANGED");
        intentFilter.addAction("android.telephony.action.SIM_APPLICATION_STATE_CHANGED");
        context.registerReceiver(r3, intentFilter);
        IntentFilter intentFilter2 = new IntentFilter();
        intentFilter2.addAction("android.intent.action.PACKAGE_ADDED");
        intentFilter2.addAction("android.intent.action.PACKAGE_REPLACED");
        intentFilter2.addAction("android.intent.action.PACKAGE_REMOVED");
        intentFilter2.addAction("android.intent.action.PACKAGE_CHANGED");
        intentFilter2.addDataScheme("package");
        context.registerReceiver(r3, intentFilter2);
        sendMessage(obtainMessage(7));
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 1:
                handleRegisterListener((Registrant) message.obj);
                return;
            case 2:
                handleUnregisterListener((Handler) message.obj);
                return;
            case 3:
                handleCarrierConfigUpdated(message.arg1, message.arg2);
                return;
            case 4:
                handleSimStateChanged(message.arg1, message.arg2);
                return;
            case 5:
                handlePackageAddedReplacedOrChanged((String) message.obj);
                return;
            case 6:
                handlePackageRemovedOrDisabledByUser((String) message.obj);
                return;
            case 7:
                handleInitializeTracker();
                return;
            case 8:
                handleSetTestOverrideRules((String) message.obj);
                return;
            case 9:
                handleClearUiccRules();
                return;
            case 10:
                handleUiccAccessRulesLoaded();
                return;
            default:
                String str = TAG;
                Rlog.e(str, "Received unknown msg type: " + message.what);
                return;
        }
    }

    private void handleRegisterListener(Registrant registrant) {
        this.mRegistrantList.add(registrant);
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            int[] intSetToArray = intSetToArray(this.mPrivilegedPackageInfo.mUids);
            registrant.notifyResult(Arrays.copyOf(intSetToArray, intSetToArray.length));
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    private void handleUnregisterListener(Handler handler) {
        this.mRegistrantList.remove(handler);
    }

    private void handleCarrierConfigUpdated(int i, int i2) {
        if (i2 == this.mPhone.getPhoneId()) {
            List<UiccAccessRule> list = Collections.EMPTY_LIST;
            if (i != -1) {
                list = getCarrierConfigRules(i);
            }
            LocalLog localLog = this.mLocalLog;
            localLog.log("CarrierConfigUpdated: subId=" + i + " slotIndex=" + i2 + " updated CarrierConfig rules=" + list);
            maybeUpdateRulesAndNotifyRegistrants(this.mCarrierConfigRules, list);
        }
    }

    private List<UiccAccessRule> getCarrierConfigRules(int i) {
        PersistableBundle configForSubId = this.mCarrierConfigManager.getConfigForSubId(i);
        if (!CarrierConfigManager.isConfigForIdentifiedCarrier(configForSubId)) {
            return Collections.EMPTY_LIST;
        }
        String[] stringArray = configForSubId.getStringArray("carrier_certificate_string_array");
        if (stringArray == null) {
            return Collections.EMPTY_LIST;
        }
        return Arrays.asList(UiccAccessRule.decodeRulesFromCarrierConfig(stringArray));
    }

    /* JADX INFO: finally extract failed */
    private void handleSimStateChanged(int i, int i2) {
        if (i == this.mPhone.getPhoneId()) {
            List list = Collections.EMPTY_LIST;
            this.mPrivilegedPackageInfoLock.writeLock().lock();
            try {
                this.mSimIsReadyButNotLoaded = i2 == 5;
                this.mPrivilegedPackageInfoLock.writeLock().unlock();
                if (i2 == 10) {
                    this.mLocalLog.log("SIM fully loaded, handleUiccAccessRulesLoaded.");
                    handleUiccAccessRulesLoaded();
                } else if (this.mUiccRules.isEmpty() || this.mClearUiccRulesUptimeMillis != -1) {
                    this.mLocalLog.log("Ignore SIM gone event while UiccRules is empty or waiting to be emptied.");
                } else {
                    long uptimeMillis = SystemClock.uptimeMillis();
                    long j = CLEAR_UICC_RULES_DELAY_MILLIS;
                    this.mClearUiccRulesUptimeMillis = uptimeMillis + j;
                    sendMessageAtTime(obtainMessage(9), this.mClearUiccRulesUptimeMillis);
                    LocalLog localLog = this.mLocalLog;
                    localLog.log("SIM is gone, simState=" + SubscriptionInfoUpdater.simStateString(i2) + ". Delay " + TimeUnit.MILLISECONDS.toSeconds(j) + " seconds to clear UICC rules.");
                }
            } catch (Throwable th) {
                this.mPrivilegedPackageInfoLock.writeLock().unlock();
                throw th;
            }
        }
    }

    private void handleUiccAccessRulesLoaded() {
        this.mClearUiccRulesUptimeMillis = -1;
        removeMessages(9);
        List<UiccAccessRule> simRules = getSimRules();
        LocalLog localLog = this.mLocalLog;
        localLog.log("UiccAccessRules loaded: updated SIM-loaded rules=" + simRules);
        maybeUpdateRulesAndNotifyRegistrants(this.mUiccRules, simRules);
    }

    public void onUiccAccessRulesLoaded() {
        sendEmptyMessage(10);
    }

    private void handleClearUiccRules() {
        this.mClearUiccRulesUptimeMillis = -1;
        removeMessages(9);
        maybeUpdateRulesAndNotifyRegistrants(this.mUiccRules, Collections.EMPTY_LIST);
    }

    private List<UiccAccessRule> getSimRules() {
        if (!this.mTelephonyManager.hasIccCard(this.mPhone.getPhoneId())) {
            return Collections.EMPTY_LIST;
        }
        UiccPort uiccPort = this.mPhone.getUiccPort();
        if (uiccPort == null) {
            String str = TAG;
            Rlog.w(str, "Null UiccPort, but hasIccCard was present for phoneId " + this.mPhone.getPhoneId());
            return Collections.EMPTY_LIST;
        }
        UiccProfile uiccProfile = uiccPort.getUiccProfile();
        if (uiccProfile != null) {
            return uiccProfile.getCarrierPrivilegeAccessRules();
        }
        String str2 = TAG;
        Rlog.w(str2, "Null UiccProfile, but hasIccCard was true for phoneId " + this.mPhone.getPhoneId());
        return Collections.EMPTY_LIST;
    }

    private void handlePackageAddedReplacedOrChanged(String str) {
        if (str != null) {
            try {
                PackageInfo packageInfo = this.mPackageManager.getPackageInfo(str, INSTALLED_PACKAGES_QUERY_FLAGS);
                updateCertsForPackage(packageInfo);
                getUidsForPackage(packageInfo.packageName, true);
                maybeUpdatePrivilegedPackagesAndNotifyRegistrants();
            } catch (PackageManager.NameNotFoundException e) {
                String str2 = TAG;
                Rlog.e(str2, "Error getting installed package: " + str, e);
            }
        }
    }

    private void updateCertsForPackage(PackageInfo packageInfo) {
        ArraySet arraySet = new ArraySet();
        for (Signature signature : UiccAccessRule.getSignatures(packageInfo)) {
            arraySet.add(IccUtils.bytesToHexString(UiccAccessRule.getCertHash(signature, SHA_1)).toUpperCase());
            arraySet.add(IccUtils.bytesToHexString(UiccAccessRule.getCertHash(signature, SHA_256)).toUpperCase());
        }
        this.mInstalledPackageCerts.put(packageInfo.packageName, arraySet);
    }

    private void handlePackageRemovedOrDisabledByUser(String str) {
        if (str != null) {
            if (this.mInstalledPackageCerts.remove(str) == null || this.mCachedUids.remove(str) == null) {
                String str2 = TAG;
                Rlog.e(str2, "Unknown package was uninstalled or disabled by user: " + str);
                return;
            }
            maybeUpdatePrivilegedPackagesAndNotifyRegistrants();
        }
    }

    private void handleInitializeTracker() {
        this.mCarrierConfigRules.addAll(getCarrierConfigRules(this.mPhone.getSubId()));
        this.mUiccRules.addAll(getSimRules());
        refreshInstalledPackageCache();
        maybeUpdatePrivilegedPackagesAndNotifyRegistrants();
        this.mLocalLog.log("Initializing state: CarrierConfig rules=" + this.mCarrierConfigRules + " SIM-loaded rules=" + this.mUiccRules);
    }

    private static /* synthetic */ String lambda$handleInitializeTracker$0(Map.Entry entry) {
        return "pkg(" + Rlog.pii(TAG, entry.getKey()) + ")=" + entry.getValue();
    }

    private void refreshInstalledPackageCache() {
        for (PackageInfo packageInfo : this.mPackageManager.getInstalledPackagesAsUser(INSTALLED_PACKAGES_QUERY_FLAGS, UserHandle.SYSTEM.getIdentifier())) {
            updateCertsForPackage(packageInfo);
            getUidsForPackage(packageInfo.packageName, true);
        }
    }

    /* access modifiers changed from: private */
    public static <T> String getObfuscatedPackages(Collection<T> collection, Function<T, String> function) {
        StringJoiner stringJoiner = new StringJoiner(", ", "{", "}");
        for (T apply : collection) {
            stringJoiner.add(function.apply(apply));
        }
        return stringJoiner.toString();
    }

    private void maybeUpdateRulesAndNotifyRegistrants(List<UiccAccessRule> list, List<UiccAccessRule> list2) {
        if (!list.equals(list2)) {
            list.clear();
            list.addAll(list2);
            maybeUpdatePrivilegedPackagesAndNotifyRegistrants();
        }
    }

    /* JADX INFO: finally extract failed */
    private void maybeUpdatePrivilegedPackagesAndNotifyRegistrants() {
        PrivilegedPackageInfo currentPrivilegedPackagesForAllUsers = getCurrentPrivilegedPackagesForAllUsers();
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            if (!this.mPrivilegedPackageInfo.equals(currentPrivilegedPackagesForAllUsers)) {
                this.mLocalLog.log("Privileged packages info changed. New state = " + currentPrivilegedPackagesForAllUsers);
                boolean z = false;
                boolean z2 = !currentPrivilegedPackagesForAllUsers.mPackageNames.equals(this.mPrivilegedPackageInfo.mPackageNames);
                if (!currentPrivilegedPackagesForAllUsers.mUids.equals(this.mPrivilegedPackageInfo.mUids)) {
                    z = true;
                }
                boolean equals = true ^ currentPrivilegedPackagesForAllUsers.mCarrierService.equals(this.mPrivilegedPackageInfo.mCarrierService);
                this.mPrivilegedPackageInfoLock.readLock().unlock();
                this.mPrivilegedPackageInfoLock.writeLock().lock();
                try {
                    this.mPrivilegedPackageInfo = currentPrivilegedPackagesForAllUsers;
                    this.mPrivilegedPackageInfoLock.writeLock().unlock();
                    this.mPrivilegedPackageInfoLock.readLock().lock();
                    if (z) {
                        try {
                            int[] intSetToArray = intSetToArray(this.mPrivilegedPackageInfo.mUids);
                            this.mRegistrantList.notifyResult(Arrays.copyOf(intSetToArray, intSetToArray.length));
                        } catch (Throwable th) {
                            this.mPrivilegedPackageInfoLock.readLock().unlock();
                            throw th;
                        }
                    }
                    if (z2 || z) {
                        this.mTelephonyRegistryManager.notifyCarrierPrivilegesChanged(this.mPhone.getPhoneId(), Collections.unmodifiableSet(this.mPrivilegedPackageInfo.mPackageNames), Collections.unmodifiableSet(this.mPrivilegedPackageInfo.mUids));
                    }
                    if (equals) {
                        TelephonyRegistryManager telephonyRegistryManager = this.mTelephonyRegistryManager;
                        int phoneId = this.mPhone.getPhoneId();
                        Pair<String, Integer> pair = this.mPrivilegedPackageInfo.mCarrierService;
                        telephonyRegistryManager.notifyCarrierServiceChanged(phoneId, (String) pair.first, ((Integer) pair.second).intValue());
                    }
                    this.mPrivilegedPackageInfoLock.readLock().unlock();
                    ActivityManager activityManager = (ActivityManager) this.mContext.getSystemService(ActivityManager.class);
                    CarrierAppUtils.disableCarrierAppsUntilPrivileged(this.mContext.getOpPackageName(), this.mTelephonyManager, ActivityManager.getCurrentUser(), this.mContext);
                } catch (Throwable th2) {
                    this.mPrivilegedPackageInfoLock.writeLock().unlock();
                    throw th2;
                }
            }
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    private PrivilegedPackageInfo getCurrentPrivilegedPackagesForAllUsers() {
        ArraySet arraySet = new ArraySet();
        ArraySet arraySet2 = new ArraySet();
        for (Map.Entry next : this.mInstalledPackageCerts.entrySet()) {
            if (isPackagePrivileged((String) next.getKey(), (Set) next.getValue())) {
                arraySet.add((String) next.getKey());
                arraySet2.addAll(getUidsForPackage((String) next.getKey(), false));
            }
        }
        return new PrivilegedPackageInfo(arraySet, arraySet2, getCarrierService(arraySet));
    }

    private boolean isPackagePrivileged(String str, Set<String> set) {
        for (String next : set) {
            List<UiccAccessRule> list = this.mTestOverrideRules;
            if (list != null) {
                for (UiccAccessRule matches : list) {
                    if (matches.matches(next, str)) {
                        return true;
                    }
                }
                continue;
            } else {
                for (UiccAccessRule matches2 : this.mCarrierConfigRules) {
                    if (matches2.matches(next, str)) {
                        return true;
                    }
                }
                for (UiccAccessRule matches3 : this.mUiccRules) {
                    if (matches3.matches(next, str)) {
                        return true;
                    }
                }
                continue;
            }
        }
        return false;
    }

    private Set<Integer> getUidsForPackage(String str, boolean z) {
        if (z) {
            this.mCachedUids.remove(str);
        }
        if (this.mCachedUids.containsKey(str)) {
            return this.mCachedUids.get(str);
        }
        ArraySet arraySet = new ArraySet();
        for (UserInfo userHandle : this.mUserManager.getUsers()) {
            int identifier = userHandle.getUserHandle().getIdentifier();
            try {
                arraySet.add(Integer.valueOf(this.mPackageManager.getPackageUidAsUser(str, identifier)));
            } catch (PackageManager.NameNotFoundException unused) {
                String str2 = TAG;
                Rlog.e(str2, "Unable to find uid for package " + str + " and user " + identifier);
            }
        }
        this.mCachedUids.put(str, arraySet);
        return arraySet;
    }

    private int getPackageUid(String str) {
        try {
            return this.mPackageManager.getPackageUid(str, 0);
        } catch (PackageManager.NameNotFoundException unused) {
            String str2 = TAG;
            Rlog.e(str2, "Unable to find uid for package " + str);
            return -1;
        }
    }

    /* JADX INFO: finally extract failed */
    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("CarrierPrivilegesTracker - phoneId: " + this.mPhone.getPhoneId());
        printWriter.println("CarrierPrivilegesTracker - Log Begin ----");
        this.mLocalLog.dump(fileDescriptor, printWriter, strArr);
        printWriter.println("CarrierPrivilegesTracker - Log End ----");
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            printWriter.println("CarrierPrivilegesTracker - Privileged package info: " + this.mPrivilegedPackageInfo);
            printWriter.println("mSimIsReadyButNotLoaded: " + this.mSimIsReadyButNotLoaded);
            this.mPrivilegedPackageInfoLock.readLock().unlock();
            printWriter.println("CarrierPrivilegesTracker - Test-override rules: " + this.mTestOverrideRules);
            printWriter.println("CarrierPrivilegesTracker - SIM-loaded rules: " + this.mUiccRules);
            printWriter.println("CarrierPrivilegesTracker - Carrier config rules: " + this.mCarrierConfigRules);
            printWriter.println("mClearUiccRulesUptimeMillis: " + this.mClearUiccRulesUptimeMillis);
        } catch (Throwable th) {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
            throw th;
        }
    }

    private static /* synthetic */ String lambda$dump$1(Map.Entry entry) {
        return "pkg(" + Rlog.pii(TAG, entry.getKey()) + ")=" + entry.getValue();
    }

    @Deprecated
    public void registerCarrierPrivilegesListener(Handler handler, int i, Object obj) {
        sendMessage(obtainMessage(1, new Registrant(handler, i, obj)));
    }

    @Deprecated
    public void unregisterCarrierPrivilegesListener(Handler handler) {
        sendMessage(obtainMessage(2, handler));
    }

    public void setTestOverrideCarrierPrivilegeRules(String str) {
        sendMessage(obtainMessage(8, str));
    }

    private void handleSetTestOverrideRules(String str) {
        if (str == null) {
            this.mTestOverrideRules = null;
        } else if (str.isEmpty()) {
            this.mTestOverrideRules = Collections.emptyList();
        } else {
            this.mTestOverrideRules = Arrays.asList(UiccAccessRule.decodeRulesFromCarrierConfig(new String[]{str}));
            refreshInstalledPackageCache();
        }
        maybeUpdatePrivilegedPackagesAndNotifyRegistrants();
    }

    public int getCarrierPrivilegeStatusForPackage(String str) {
        int i;
        if (str == null) {
            return 0;
        }
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            if (this.mSimIsReadyButNotLoaded) {
                i = -1;
            } else if (this.mPrivilegedPackageInfo.mPackageNames.contains(str)) {
                i = 1;
            } else {
                this.mPrivilegedPackageInfoLock.readLock().unlock();
                return 0;
            }
            return i;
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    public Set<String> getPackagesWithCarrierPrivileges() {
        Set<String> set;
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            if (this.mSimIsReadyButNotLoaded) {
                set = Collections.emptySet();
            } else {
                set = Collections.unmodifiableSet(this.mPrivilegedPackageInfo.mPackageNames);
            }
            return set;
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    public int getCarrierPrivilegeStatusForUid(int i) {
        int i2;
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            if (this.mSimIsReadyButNotLoaded) {
                i2 = -1;
            } else {
                i2 = this.mPrivilegedPackageInfo.mUids.contains(Integer.valueOf(i)) ? 1 : 0;
            }
            return i2;
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    public String getCarrierServicePackageName() {
        String str;
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            if (this.mSimIsReadyButNotLoaded) {
                str = null;
            } else {
                str = (String) this.mPrivilegedPackageInfo.mCarrierService.first;
            }
            return str;
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    public int getCarrierServicePackageUid() {
        int intValue;
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            if (this.mSimIsReadyButNotLoaded) {
                intValue = -1;
            } else {
                intValue = ((Integer) this.mPrivilegedPackageInfo.mCarrierService.second).intValue();
            }
            return intValue;
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    public List<String> getCarrierPackageNamesForIntent(Intent intent) {
        this.mPrivilegedPackageInfoLock.readLock().lock();
        try {
            if (this.mSimIsReadyButNotLoaded) {
                return Collections.emptyList();
            }
            this.mPrivilegedPackageInfoLock.readLock().unlock();
            ArrayList<ResolveInfo> arrayList = new ArrayList<>();
            arrayList.addAll(this.mPackageManager.queryBroadcastReceivers(intent, 0));
            arrayList.addAll(this.mPackageManager.queryIntentActivities(intent, 0));
            arrayList.addAll(this.mPackageManager.queryIntentServices(intent, 0));
            arrayList.addAll(this.mPackageManager.queryIntentContentProviders(intent, 0));
            this.mPrivilegedPackageInfoLock.readLock().lock();
            try {
                if (this.mSimIsReadyButNotLoaded) {
                    return Collections.emptyList();
                }
                ArraySet arraySet = new ArraySet();
                for (ResolveInfo packageName : arrayList) {
                    String packageName2 = getPackageName(packageName);
                    if (packageName2 != null && 1 == getCarrierPrivilegeStatusForPackage(packageName2)) {
                        arraySet.add(packageName2);
                    }
                }
                ArrayList arrayList2 = new ArrayList(arraySet);
                this.mPrivilegedPackageInfoLock.readLock().unlock();
                return arrayList2;
            } finally {
                this.mPrivilegedPackageInfoLock.readLock().unlock();
            }
        } finally {
            this.mPrivilegedPackageInfoLock.readLock().unlock();
        }
    }

    private static String getPackageName(ResolveInfo resolveInfo) {
        ActivityInfo activityInfo = resolveInfo.activityInfo;
        if (activityInfo != null) {
            return activityInfo.packageName;
        }
        ServiceInfo serviceInfo = resolveInfo.serviceInfo;
        if (serviceInfo != null) {
            return serviceInfo.packageName;
        }
        ProviderInfo providerInfo = resolveInfo.providerInfo;
        if (providerInfo != null) {
            return providerInfo.packageName;
        }
        return null;
    }

    private Pair<String, Integer> getCarrierService(Set<String> set) {
        String str;
        Iterator<ResolveInfo> it = this.mPackageManager.queryIntentServices(new Intent("android.service.carrier.CarrierService"), 0).iterator();
        while (true) {
            if (!it.hasNext()) {
                str = null;
                break;
            }
            str = getPackageName(it.next());
            if (set.contains(str)) {
                break;
            }
        }
        if (str == null) {
            return new Pair<>((Object) null, -1);
        }
        return new Pair<>(str, Integer.valueOf(getPackageUid(str)));
    }

    private static int[] intSetToArray(Set<Integer> set) {
        IntArray intArray = new IntArray(set.size());
        set.forEach(new CarrierPrivilegesTracker$$ExternalSyntheticLambda0(intArray));
        return intArray.toArray();
    }
}
