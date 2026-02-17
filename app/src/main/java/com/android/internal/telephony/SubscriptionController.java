package com.android.internal.telephony;

import android.app.AppOpsManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.ContentObserver;
import android.database.Cursor;
import android.net.Uri;
import android.os.Binder;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.os.ParcelUuid;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.os.TelephonyServiceManager;
import android.os.UserHandle;
import android.provider.Settings;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;
import android.telephony.AnomalyReporter;
import android.telephony.CarrierConfigManager;
import android.telephony.RadioAccessFamily;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyFrameworkInitializer;
import android.telephony.TelephonyManager;
import android.telephony.TelephonyRegistryManager;
import android.telephony.UiccPortInfo;
import android.telephony.UiccSlotInfo;
import android.telephony.UiccSlotMapping;
import android.telephony.euicc.EuiccManager;
import android.text.TextUtils;
import android.util.EventLog;
import android.util.Log;
import com.android.ims.ImsManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.ISub;
import com.android.internal.telephony.IccCardConstants;
import com.android.internal.telephony.data.PhoneSwitcher;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccProfile;
import com.android.internal.telephony.uicc.UiccSlot;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.internal.telephony.util.NetworkStackConstants;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;

public class SubscriptionController extends ISub.Stub {
    protected static final boolean DBG = true;
    private static final boolean DBG_CACHE = false;
    private static final int DEPRECATED_SETTING = -1;
    protected static final Set<String> GROUP_SHARING_PROPERTIES = new HashSet(Arrays.asList(new String[]{"volte_vt_enabled", "vt_ims_enabled", "wfc_ims_enabled", "wfc_ims_mode", "wfc_ims_roaming_mode", "wfc_ims_roaming_enabled", "data_roaming", "display_name", "data_enabled_override_rules", "uicc_applications_enabled", "ims_rcs_uce_enabled", "cross_sim_calling_enabled", "nr_advanced_calling_enabled"}));
    private static final ParcelUuid INVALID_GROUP_UUID = ParcelUuid.fromString("00000000-0000-0000-0000-000000000000");
    private static final String LOG_TAG = "SubscriptionController";
    private static final int NO_ENTRY_FOR_SLOT_INDEX = -1;
    private static final Comparator<SubscriptionInfo> SUBSCRIPTION_INFO_COMPARATOR = new SubscriptionController$$ExternalSyntheticLambda10();
    private static final int SUB_ID_FOUND = 1;
    private static final int SUB_ID_NOT_IN_SLOT = -2;
    protected static final boolean VDBG = Rlog.isLoggable(LOG_TAG, 2);
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static int mDefaultPhoneId = Integer.MAX_VALUE;
    private static boolean sCachingEnabled = true;
    protected static WatchedInt sDefaultFallbackSubId = new WatchedInt(-1) {
        public void set(int i) {
            super.set(i);
            SubscriptionController.invalidateDefaultSubIdCaches();
            SubscriptionController.invalidateSlotIndexCaches();
        }
    };
    protected static SubscriptionController sInstance = null;
    protected static WatchedSlotIndexToSubIds sSlotIndexToSubIds = new WatchedSlotIndexToSubIds();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private int[] colorArr;
    private AppOpsManager mAppOps;
    protected final List<SubscriptionInfo> mCacheActiveSubInfoList = new ArrayList();
    private List<SubscriptionInfo> mCacheOpportunisticSubInfoList = new ArrayList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Context mContext;
    private long mLastISubServiceRegTime;
    protected final LocalLog mLocalLog = new LocalLog(128);
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final Object mLock = new Object();
    protected AtomicBoolean mOpptSubInfoListChangedDirtyBit = new AtomicBoolean();
    protected Object mSubInfoListLock = new Object();
    protected TelephonyManager mTelephonyManager;
    private RegistrantList mUiccAppsEnableChangeRegList = new RegistrantList();
    protected UiccController mUiccController;

    /* access modifiers changed from: protected */
    public boolean isSubscriptionForRemoteSim(int i) {
        return i == 1;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$static$0(SubscriptionInfo subscriptionInfo, SubscriptionInfo subscriptionInfo2) {
        int simSlotIndex = subscriptionInfo.getSimSlotIndex() - subscriptionInfo2.getSimSlotIndex();
        return simSlotIndex == 0 ? subscriptionInfo.getSubscriptionId() - subscriptionInfo2.getSubscriptionId() : simSlotIndex;
    }

    protected static class WatchedSlotIndexToSubIds {
        private Map<Integer, ArrayList<Integer>> mSlotIndexToSubIds = new ConcurrentHashMap();

        WatchedSlotIndexToSubIds() {
        }

        public void clear() {
            this.mSlotIndexToSubIds.clear();
            SubscriptionController.invalidateDefaultSubIdCaches();
            SubscriptionController.invalidateSlotIndexCaches();
        }

        public Set<Map.Entry<Integer, ArrayList<Integer>>> entrySet() {
            return this.mSlotIndexToSubIds.entrySet();
        }

        public ArrayList<Integer> getCopy(int i) {
            ArrayList arrayList = this.mSlotIndexToSubIds.get(Integer.valueOf(i));
            if (arrayList == null) {
                return null;
            }
            return new ArrayList<>(arrayList);
        }

        public void put(int i, ArrayList<Integer> arrayList) {
            this.mSlotIndexToSubIds.put(Integer.valueOf(i), arrayList);
            SubscriptionController.invalidateDefaultSubIdCaches();
            SubscriptionController.invalidateSlotIndexCaches();
        }

        public void remove(int i) {
            this.mSlotIndexToSubIds.remove(Integer.valueOf(i));
            SubscriptionController.invalidateDefaultSubIdCaches();
            SubscriptionController.invalidateSlotIndexCaches();
        }

        public int size() {
            return this.mSlotIndexToSubIds.size();
        }

        @VisibleForTesting
        public Map<Integer, ArrayList<Integer>> getMap() {
            return this.mSlotIndexToSubIds;
        }

        public int removeFromSubIdList(int i, int i2) {
            ArrayList arrayList = this.mSlotIndexToSubIds.get(Integer.valueOf(i));
            if (arrayList == null) {
                return -1;
            }
            if (!arrayList.contains(Integer.valueOf(i2))) {
                return -2;
            }
            arrayList.remove(new Integer(i2));
            if (arrayList.isEmpty()) {
                this.mSlotIndexToSubIds.remove(Integer.valueOf(i));
            }
            SubscriptionController.invalidateDefaultSubIdCaches();
            SubscriptionController.invalidateSlotIndexCaches();
            return 1;
        }

        public void addToSubIdList(int i, Integer num) {
            ArrayList arrayList = this.mSlotIndexToSubIds.get(Integer.valueOf(i));
            if (arrayList == null) {
                ArrayList arrayList2 = new ArrayList();
                arrayList2.add(num);
                this.mSlotIndexToSubIds.put(Integer.valueOf(i), arrayList2);
            } else {
                arrayList.add(num);
            }
            SubscriptionController.invalidateDefaultSubIdCaches();
            SubscriptionController.invalidateSlotIndexCaches();
        }

        public void clearSubIdList(int i) {
            ArrayList arrayList = this.mSlotIndexToSubIds.get(Integer.valueOf(i));
            if (arrayList != null) {
                arrayList.clear();
                SubscriptionController.invalidateDefaultSubIdCaches();
                SubscriptionController.invalidateSlotIndexCaches();
            }
        }
    }

    public static class WatchedInt {
        private int mValue;

        public WatchedInt(int i) {
            this.mValue = i;
        }

        public int get() {
            return this.mValue;
        }

        public void set(int i) {
            this.mValue = i;
        }
    }

    public static SubscriptionController init(Context context) {
        SubscriptionController subscriptionController;
        synchronized (SubscriptionController.class) {
            if (sInstance == null) {
                sInstance = new SubscriptionController(context);
            } else {
                Log.wtf(LOG_TAG, "init() called multiple times!  sInstance = " + sInstance);
            }
            subscriptionController = sInstance;
        }
        return subscriptionController;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static SubscriptionController getInstance() {
        if (sInstance == null) {
            Log.wtf(LOG_TAG, "getInstance null");
        }
        return sInstance;
    }

    protected SubscriptionController(Context context) {
        internalInit(context);
        migrateImsSettings();
    }

    /* JADX WARNING: type inference failed for: r4v0, types: [com.android.internal.telephony.SubscriptionController, android.os.IBinder] */
    /* access modifiers changed from: protected */
    public void internalInit(Context context) {
        this.mContext = context;
        this.mTelephonyManager = TelephonyManager.from(context);
        try {
            this.mUiccController = UiccController.getInstance();
            this.mAppOps = (AppOpsManager) this.mContext.getSystemService("appops");
            TelephonyServiceManager.ServiceRegisterer subscriptionServiceRegisterer = TelephonyFrameworkInitializer.getTelephonyServiceManager().getSubscriptionServiceRegisterer();
            if (subscriptionServiceRegisterer.get() == null) {
                subscriptionServiceRegisterer.register(this);
                this.mLastISubServiceRegTime = System.currentTimeMillis();
            }
            clearSlotIndexForSubInfoRecords();
            cacheSettingValues();
            invalidateDefaultSubIdCaches();
            invalidateDefaultDataSubIdCaches();
            invalidateDefaultSmsSubIdCaches();
            invalidateActiveDataSubIdCaches();
            invalidateSlotIndexCaches();
            this.mContext.getContentResolver().registerContentObserver(SubscriptionManager.SIM_INFO_SUW_RESTORE_CONTENT_URI, false, new ContentObserver(new Handler()) {
                public void onChange(boolean z, Uri uri) {
                    if (uri.equals(SubscriptionManager.SIM_INFO_SUW_RESTORE_CONTENT_URI)) {
                        SubscriptionController.this.refreshCachedActiveSubscriptionInfoList();
                        SubscriptionController.this.notifySubscriptionInfoChanged();
                        SubscriptionManager.from(SubscriptionController.this.mContext);
                        SubscriptionController subscriptionController = SubscriptionController.this;
                        for (SubscriptionInfo next : subscriptionController.getActiveSubscriptionInfoList(subscriptionController.mContext.getOpPackageName(), SubscriptionController.this.mContext.getAttributionTag())) {
                            if (SubscriptionController.getInstance().isActiveSubId(next.getSubscriptionId())) {
                                ImsManager.getInstance(SubscriptionController.this.mContext, next.getSimSlotIndex()).updateImsServiceConfig();
                            }
                        }
                    }
                }
            });
            logdl("[SubscriptionController] init by Context");
        } catch (RuntimeException unused) {
            throw new RuntimeException("UiccController has to be initialised before SubscriptionController init");
        }
    }

    public void notifySubInfoReady() {
        sendDefaultChangedBroadcast(SubscriptionManager.getDefaultSubscriptionId());
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private boolean isSubInfoReady() {
        return SubscriptionInfoUpdater.isSubInfoInitialized();
    }

    private void clearSlotIndexForSubInfoRecords() {
        if (this.mContext == null) {
            logel("[clearSlotIndexForSubInfoRecords] TelephonyManager or mContext is null");
            return;
        }
        ContentValues contentValues = new ContentValues(1);
        contentValues.put("sim_id", -1);
        this.mContext.getContentResolver().update(SubscriptionManager.CONTENT_URI, contentValues, (String) null, (String[]) null);
    }

    private void cacheSettingValues() {
        Settings.Global.getInt(this.mContext.getContentResolver(), "multi_sim_sms", -1);
        Settings.Global.getInt(this.mContext.getContentResolver(), "multi_sim_voice_call", -1);
        Settings.Global.getInt(this.mContext.getContentResolver(), "multi_sim_data_call", -1);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void enforceModifyPhoneState(String str) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.MODIFY_PHONE_STATE", str);
    }

    private void enforceReadPrivilegedPhoneState(String str) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.READ_PRIVILEGED_PHONE_STATE", str);
    }

    private boolean hasSubscriberIdentifierAccess(int i, String str, String str2, String str3, boolean z) {
        try {
            return TelephonyPermissions.checkCallingOrSelfReadSubscriberIdentifiers(this.mContext, i, str, str2, str3, z);
        } catch (SecurityException unused) {
            return false;
        }
    }

    private boolean hasPhoneNumberAccess(int i, String str, String str2, String str3) {
        try {
            return TelephonyPermissions.checkCallingOrSelfReadPhoneNumber(this.mContext, i, str, str2, str3);
        } catch (SecurityException unused) {
            return false;
        }
    }

    private void broadcastSimInfoContentChanged() {
        this.mContext.sendBroadcast(new Intent("android.intent.action.ACTION_SUBINFO_CONTENT_CHANGE"));
        this.mContext.sendBroadcast(new Intent("android.intent.action.ACTION_SUBINFO_RECORD_UPDATED"));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void notifySubscriptionInfoChanged() {
        ArrayList arrayList;
        logd("notifySubscriptionInfoChanged:");
        ((TelephonyRegistryManager) this.mContext.getSystemService("telephony_registry")).notifySubscriptionInfoChanged();
        broadcastSimInfoContentChanged();
        MultiSimSettingController.getInstance().notifySubscriptionInfoChanged();
        TelephonyMetrics instance = TelephonyMetrics.getInstance();
        synchronized (this.mSubInfoListLock) {
            arrayList = new ArrayList(this.mCacheActiveSubInfoList);
        }
        if (this.mOpptSubInfoListChangedDirtyBit.getAndSet(false)) {
            notifyOpportunisticSubscriptionInfoChanged();
        }
        instance.updateActiveSubscriptionInfoList(arrayList);
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:29:0x027c, code lost:
        if (r0.equals(r13) == false) goto L_0x0282;
     */
    @android.compat.annotation.UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public android.telephony.SubscriptionInfo getSubInfoRecord(android.database.Cursor r38) {
        /*
            r37 = this;
            r0 = r37
            r1 = r38
            java.lang.String r2 = "_id"
            int r2 = r1.getColumnIndexOrThrow(r2)
            int r4 = r1.getInt(r2)
            java.lang.String r2 = "icc_id"
            int r2 = r1.getColumnIndexOrThrow(r2)
            java.lang.String r5 = r1.getString(r2)
            java.lang.String r2 = "sim_id"
            int r2 = r1.getColumnIndexOrThrow(r2)
            int r6 = r1.getInt(r2)
            java.lang.String r2 = "display_name"
            int r2 = r1.getColumnIndexOrThrow(r2)
            java.lang.String r7 = r1.getString(r2)
            java.lang.String r2 = "carrier_name"
            int r2 = r1.getColumnIndexOrThrow(r2)
            java.lang.String r8 = r1.getString(r2)
            java.lang.String r2 = "name_source"
            int r2 = r1.getColumnIndexOrThrow(r2)
            int r9 = r1.getInt(r2)
            java.lang.String r2 = "color"
            int r2 = r1.getColumnIndexOrThrow(r2)
            int r10 = r1.getInt(r2)
            java.lang.String r2 = "number"
            int r2 = r1.getColumnIndexOrThrow(r2)
            java.lang.String r2 = r1.getString(r2)
            java.lang.String r3 = "data_roaming"
            int r3 = r1.getColumnIndexOrThrow(r3)
            int r12 = r1.getInt(r3)
            java.lang.String r3 = "mcc_string"
            int r3 = r1.getColumnIndexOrThrow(r3)
            java.lang.String r14 = r1.getString(r3)
            java.lang.String r3 = "mnc_string"
            int r3 = r1.getColumnIndexOrThrow(r3)
            java.lang.String r15 = r1.getString(r3)
            java.lang.String r3 = "ehplmns"
            int r3 = r1.getColumnIndexOrThrow(r3)
            java.lang.String r3 = r1.getString(r3)
            java.lang.String r11 = "hplmns"
            int r11 = r1.getColumnIndexOrThrow(r11)
            java.lang.String r11 = r1.getString(r11)
            java.lang.String r13 = ","
            r16 = r8
            if (r3 != 0) goto L_0x008f
            r3 = 0
            goto L_0x0093
        L_0x008f:
            java.lang.String[] r3 = r3.split(r13)
        L_0x0093:
            if (r11 != 0) goto L_0x0097
            r11 = 0
            goto L_0x009b
        L_0x0097:
            java.lang.String[] r11 = r11.split(r13)
        L_0x009b:
            java.lang.String r13 = "card_id"
            int r13 = r1.getColumnIndexOrThrow(r13)
            java.lang.String r13 = r1.getString(r13)
            java.lang.String r8 = "iso_country_code"
            int r8 = r1.getColumnIndexOrThrow(r8)
            java.lang.String r8 = r1.getString(r8)
            r18 = r3
            com.android.internal.telephony.uicc.UiccController r3 = r0.mUiccController
            int r3 = r3.convertToPublicCardId(r13)
            r19 = r11
            java.lang.String r11 = "is_embedded"
            int r11 = r1.getColumnIndexOrThrow(r11)
            int r11 = r1.getInt(r11)
            r20 = 0
            r21 = r2
            r2 = 1
            if (r11 != r2) goto L_0x00cc
            r11 = r2
            goto L_0x00ce
        L_0x00cc:
            r11 = r20
        L_0x00ce:
            java.lang.String r2 = "carrier_id"
            int r2 = r1.getColumnIndexOrThrow(r2)
            int r2 = r1.getInt(r2)
            if (r11 == 0) goto L_0x00ed
            r23 = r3
            java.lang.String r3 = "access_rules"
            int r3 = r1.getColumnIndexOrThrow(r3)
            byte[] r3 = r1.getBlob(r3)
            android.telephony.UiccAccessRule[] r3 = android.telephony.UiccAccessRule.decodeRules(r3)
            r24 = r3
            goto L_0x00f1
        L_0x00ed:
            r23 = r3
            r24 = 0
        L_0x00f1:
            java.lang.String r3 = "access_rules_from_carrier_configs"
            int r3 = r1.getColumnIndexOrThrow(r3)
            byte[] r3 = r1.getBlob(r3)
            android.telephony.UiccAccessRule[] r3 = android.telephony.UiccAccessRule.decodeRules(r3)
            r25 = r3
            java.lang.String r3 = "is_opportunistic"
            int r3 = r1.getColumnIndexOrThrow(r3)
            int r3 = r1.getInt(r3)
            r26 = r11
            r11 = 1
            if (r3 != r11) goto L_0x0112
            r11 = 1
            goto L_0x0114
        L_0x0112:
            r11 = r20
        L_0x0114:
            java.lang.String r3 = "group_uuid"
            int r3 = r1.getColumnIndexOrThrow(r3)
            java.lang.String r3 = r1.getString(r3)
            r27 = r3
            java.lang.String r3 = "profile_class"
            int r3 = r1.getColumnIndexOrThrow(r3)
            int r3 = r1.getInt(r3)
            r28 = r3
            java.lang.String r3 = "port_index"
            int r3 = r1.getColumnIndexOrThrow(r3)
            int r3 = r1.getInt(r3)
            r29 = r11
            java.lang.String r11 = "subscription_type"
            int r11 = r1.getColumnIndexOrThrow(r11)
            int r11 = r1.getInt(r11)
            r30 = r11
            java.lang.String r11 = "group_owner"
            r31 = r3
            r3 = 0
            java.lang.String r32 = r0.getOptionalStringFromCursor(r1, r11, r3)
            java.lang.String r3 = "uicc_applications_enabled"
            int r3 = r1.getColumnIndexOrThrow(r3)
            int r3 = r1.getInt(r3)
            r11 = 1
            if (r3 != r11) goto L_0x015d
            goto L_0x015f
        L_0x015d:
            r11 = r20
        L_0x015f:
            java.lang.String r3 = "usage_setting"
            int r3 = r1.getColumnIndexOrThrow(r3)
            int r1 = r1.getInt(r3)
            boolean r3 = VDBG
            if (r3 == 0) goto L_0x0261
            java.lang.String r3 = android.telephony.SubscriptionInfo.givePrintableIccid(r5)
            r17 = r5
            java.lang.String r5 = android.telephony.SubscriptionInfo.givePrintableIccid(r13)
            r20 = r13
            java.lang.StringBuilder r13 = new java.lang.StringBuilder
            r13.<init>()
            java.lang.String r0 = "[getSubInfoRecord] id:"
            r13.append(r0)
            r13.append(r4)
            java.lang.String r0 = " iccid:"
            r13.append(r0)
            r13.append(r3)
            java.lang.String r0 = " simSlotIndex:"
            r13.append(r0)
            r13.append(r6)
            java.lang.String r0 = " carrierid:"
            r13.append(r0)
            r13.append(r2)
            java.lang.String r0 = " displayName:"
            r13.append(r0)
            r13.append(r7)
            java.lang.String r0 = " nameSource:"
            r13.append(r0)
            r13.append(r9)
            java.lang.String r0 = " iconTint:"
            r13.append(r0)
            r13.append(r10)
            java.lang.String r0 = " dataRoaming:"
            r13.append(r0)
            r13.append(r12)
            java.lang.String r0 = " mcc:"
            r13.append(r0)
            r13.append(r14)
            java.lang.String r0 = " mnc:"
            r13.append(r0)
            r13.append(r15)
            java.lang.String r0 = " countIso:"
            r13.append(r0)
            r13.append(r8)
            java.lang.String r0 = " isEmbedded:"
            r13.append(r0)
            r0 = r26
            r13.append(r0)
            java.lang.String r3 = " accessRules:"
            r13.append(r3)
            java.lang.String r3 = java.util.Arrays.toString(r24)
            r13.append(r3)
            java.lang.String r3 = " carrierConfigAccessRules: "
            r13.append(r3)
            java.lang.String r3 = java.util.Arrays.toString(r25)
            r13.append(r3)
            java.lang.String r3 = " cardId:"
            r13.append(r3)
            r13.append(r5)
            java.lang.String r3 = " portIndex:"
            r13.append(r3)
            r3 = r31
            r13.append(r3)
            java.lang.String r5 = " publicCardId:"
            r13.append(r5)
            r5 = r23
            r13.append(r5)
            java.lang.String r0 = " isOpportunistic:"
            r13.append(r0)
            r0 = r29
            r13.append(r0)
            java.lang.String r0 = " groupUUID:"
            r13.append(r0)
            r0 = r27
            r13.append(r0)
            java.lang.String r0 = " profileClass:"
            r13.append(r0)
            r0 = r28
            r13.append(r0)
            java.lang.String r0 = " subscriptionType: "
            r13.append(r0)
            r0 = r30
            r13.append(r0)
            java.lang.String r0 = " carrierConfigAccessRules:"
            r13.append(r0)
            r0 = r25
            r13.append(r0)
            java.lang.String r0 = " areUiccApplicationsEnabled: "
            r13.append(r0)
            r13.append(r11)
            java.lang.String r0 = " usageSetting: "
            r13.append(r0)
            r13.append(r1)
            java.lang.String r0 = r13.toString()
            r13 = r37
            r13.logd(r0)
            goto L_0x026a
        L_0x0261:
            r17 = r5
            r20 = r13
            r5 = r23
            r3 = r31
            r13 = r0
        L_0x026a:
            android.telephony.TelephonyManager r0 = r13.mTelephonyManager
            java.lang.String r0 = r0.getLine1Number(r4)
            boolean r13 = android.text.TextUtils.isEmpty(r0)
            if (r13 != 0) goto L_0x027f
            r13 = r21
            boolean r21 = r0.equals(r13)
            if (r21 != 0) goto L_0x0281
            goto L_0x0282
        L_0x027f:
            r13 = r21
        L_0x0281:
            r0 = r13
        L_0x0282:
            android.telephony.SubscriptionInfo r13 = new android.telephony.SubscriptionInfo
            r31 = r3
            r21 = r5
            r5 = r18
            r22 = r27
            r36 = r28
            r28 = r25
            r25 = r36
            r3 = r13
            r18 = 0
            r33 = r13
            r13 = r18
            r23 = 0
            r34 = r5
            r5 = r17
            r17 = r8
            r8 = r16
            r35 = r19
            r18 = r26
            r26 = r29
            r27 = r30
            r29 = r11
            r11 = r0
            r16 = r17
            r17 = r18
            r18 = r24
            r19 = r20
            r20 = r21
            r21 = r26
            r24 = r2
            r26 = r27
            r27 = r32
            r30 = r31
            r31 = r1
            r3.<init>(r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31)
            r0 = r33
            r3 = r34
            r8 = r35
            r0.setAssociatedPlmns(r3, r8)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.getSubInfoRecord(android.database.Cursor):android.telephony.SubscriptionInfo");
    }

    /* access modifiers changed from: protected */
    public String getOptionalStringFromCursor(Cursor cursor, String str, String str2) {
        int columnIndex = cursor.getColumnIndex(str);
        return columnIndex == -1 ? str2 : cursor.getString(columnIndex);
    }

    public SubscriptionInfo getSubInfoForIccId(String str) {
        List<SubscriptionInfo> subInfo = getSubInfo("icc_id='" + str + "'", (Object) null);
        if (subInfo == null || subInfo.size() == 0) {
            return null;
        }
        return subInfo.get(0);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public List<SubscriptionInfo> getSubInfo(String str, Object obj) {
        String[] strArr;
        if (VDBG) {
            logd("selection:" + str + ", querykey: " + obj);
        }
        ArrayList arrayList = null;
        if (obj != null) {
            strArr = new String[]{obj.toString()};
        } else {
            strArr = null;
        }
        Cursor query = this.mContext.getContentResolver().query(SubscriptionManager.CONTENT_URI, (String[]) null, str, strArr, (String) null);
        if (query != null) {
            while (query.moveToNext()) {
                try {
                    SubscriptionInfo subInfoRecord = getSubInfoRecord(query);
                    if (subInfoRecord != null) {
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                        }
                        arrayList.add(subInfoRecord);
                    }
                } catch (Throwable th) {
                    if (query != null) {
                        query.close();
                    }
                    throw th;
                }
            }
        } else {
            logd("Query fail");
        }
        if (query != null) {
            query.close();
        }
        return arrayList;
    }

    private int getUnusedColor(String str, String str2) {
        List<SubscriptionInfo> activeSubscriptionInfoList = getActiveSubscriptionInfoList(str, str2);
        this.colorArr = this.mContext.getResources().getIntArray(17236200);
        int i = 0;
        if (activeSubscriptionInfoList != null) {
            int i2 = 0;
            while (i2 < this.colorArr.length) {
                int i3 = 0;
                while (i3 < activeSubscriptionInfoList.size() && this.colorArr[i2] != activeSubscriptionInfoList.get(i3).getIconTint()) {
                    i3++;
                }
                if (i3 == activeSubscriptionInfoList.size()) {
                    return this.colorArr[i2];
                }
                i2++;
            }
            i = activeSubscriptionInfoList.size() % this.colorArr.length;
        }
        return this.colorArr[i];
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public SubscriptionInfo getActiveSubscriptionInfo(int i, String str) {
        return getActiveSubscriptionInfo(i, str, (String) null);
    }

    public SubscriptionInfo getActiveSubscriptionInfo(int i, String str, String str2) {
        if (!TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, i, str, str2, "getActiveSubscriptionInfo")) {
            return null;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            List<SubscriptionInfo> activeSubscriptionInfoList = getActiveSubscriptionInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
            if (activeSubscriptionInfoList != null) {
                for (SubscriptionInfo next : activeSubscriptionInfoList) {
                    if (next.getSubscriptionId() == i) {
                        if (VDBG) {
                            logd("[getActiveSubscriptionInfo]+ subId=" + i + " subInfo=" + next);
                        }
                        return conditionallyRemoveIdentifiers(next, str, str2, "getActiveSubscriptionInfo");
                    }
                }
            }
            logd("[getActiveSubscriptionInfo]- subId=" + i + " subList=" + activeSubscriptionInfoList + " subInfo=null");
            return null;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:18:0x0038, code lost:
        r4 = getSubInfo("_id=" + r5, (java.lang.Object) null);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:19:0x004e, code lost:
        if (r4 == null) goto L_0x005f;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:21:0x0054, code lost:
        if (r4.isEmpty() == false) goto L_0x0057;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x005e, code lost:
        return r4.get(0);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:24:0x005f, code lost:
        return null;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public android.telephony.SubscriptionInfo getSubscriptionInfo(int r5) {
        /*
            r4 = this;
            java.lang.Object r0 = r4.mSubInfoListLock
            monitor-enter(r0)
            java.util.List<android.telephony.SubscriptionInfo> r1 = r4.mCacheActiveSubInfoList     // Catch:{ all -> 0x0060 }
            java.util.Iterator r1 = r1.iterator()     // Catch:{ all -> 0x0060 }
        L_0x0009:
            boolean r2 = r1.hasNext()     // Catch:{ all -> 0x0060 }
            if (r2 == 0) goto L_0x001d
            java.lang.Object r2 = r1.next()     // Catch:{ all -> 0x0060 }
            android.telephony.SubscriptionInfo r2 = (android.telephony.SubscriptionInfo) r2     // Catch:{ all -> 0x0060 }
            int r3 = r2.getSubscriptionId()     // Catch:{ all -> 0x0060 }
            if (r3 != r5) goto L_0x0009
            monitor-exit(r0)     // Catch:{ all -> 0x0060 }
            return r2
        L_0x001d:
            java.util.List<android.telephony.SubscriptionInfo> r1 = r4.mCacheOpportunisticSubInfoList     // Catch:{ all -> 0x0060 }
            java.util.Iterator r1 = r1.iterator()     // Catch:{ all -> 0x0060 }
        L_0x0023:
            boolean r2 = r1.hasNext()     // Catch:{ all -> 0x0060 }
            if (r2 == 0) goto L_0x0037
            java.lang.Object r2 = r1.next()     // Catch:{ all -> 0x0060 }
            android.telephony.SubscriptionInfo r2 = (android.telephony.SubscriptionInfo) r2     // Catch:{ all -> 0x0060 }
            int r3 = r2.getSubscriptionId()     // Catch:{ all -> 0x0060 }
            if (r3 != r5) goto L_0x0023
            monitor-exit(r0)     // Catch:{ all -> 0x0060 }
            return r2
        L_0x0037:
            monitor-exit(r0)     // Catch:{ all -> 0x0060 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "_id="
            r0.append(r1)
            r0.append(r5)
            java.lang.String r5 = r0.toString()
            r0 = 0
            java.util.List r4 = r4.getSubInfo(r5, r0)
            if (r4 == 0) goto L_0x005f
            boolean r5 = r4.isEmpty()
            if (r5 == 0) goto L_0x0057
            goto L_0x005f
        L_0x0057:
            r5 = 0
            java.lang.Object r4 = r4.get(r5)
            android.telephony.SubscriptionInfo r4 = (android.telephony.SubscriptionInfo) r4
            return r4
        L_0x005f:
            return r0
        L_0x0060:
            r4 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0060 }
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.getSubscriptionInfo(int):android.telephony.SubscriptionInfo");
    }

    public SubscriptionInfo getActiveSubscriptionInfoForIccId(String str, String str2, String str3) {
        enforceReadPrivilegedPhoneState("getActiveSubscriptionInfoForIccId");
        return getActiveSubscriptionInfoForIccIdInternal(str);
    }

    private SubscriptionInfo getActiveSubscriptionInfoForIccIdInternal(String str) {
        if (str == null) {
            return null;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            List<SubscriptionInfo> activeSubscriptionInfoList = getActiveSubscriptionInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
            if (activeSubscriptionInfoList != null) {
                for (SubscriptionInfo next : activeSubscriptionInfoList) {
                    if (str.equals(next.getIccId())) {
                        logd("[getActiveSubInfoUsingIccId]+ iccId=" + str + " subInfo=" + next);
                        return next;
                    }
                }
            }
            logd("[getActiveSubInfoUsingIccId]+ iccId=" + str + " subList=" + activeSubscriptionInfoList + " subInfo=null");
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return null;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public SubscriptionInfo getActiveSubscriptionInfoForSimSlotIndex(int i, String str, String str2) {
        Phone phone = PhoneFactory.getPhone(i);
        if (phone == null) {
            loge("[getActiveSubscriptionInfoForSimSlotIndex] no phone, slotIndex=" + i);
            return null;
        } else if (!TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, phone.getSubId(), str, str2, "getActiveSubscriptionInfoForSimSlotIndex")) {
            return null;
        } else {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                List<SubscriptionInfo> activeSubscriptionInfoList = getActiveSubscriptionInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
                if (activeSubscriptionInfoList != null) {
                    for (SubscriptionInfo next : activeSubscriptionInfoList) {
                        if (next.getSimSlotIndex() == i) {
                            logd("[getActiveSubscriptionInfoForSimSlotIndex]+ slotIndex=" + i + " subId=" + next);
                            return conditionallyRemoveIdentifiers(next, str, str2, "getActiveSubscriptionInfoForSimSlotIndex");
                        }
                    }
                    logd("[getActiveSubscriptionInfoForSimSlotIndex]+ slotIndex=" + i + " subId=null");
                } else {
                    logd("[getActiveSubscriptionInfoForSimSlotIndex]+ subList=null");
                }
                return null;
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        }
    }

    public List<SubscriptionInfo> getAllSubInfoList(String str, String str2) {
        return getAllSubInfoList(str, str2, false);
    }

    public List<SubscriptionInfo> getAllSubInfoList(String str, String str2, boolean z) {
        boolean z2 = VDBG;
        if (z2) {
            logd("[getAllSubInfoList]+");
        }
        if (!TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, -1, str, str2, "getAllSubInfoList")) {
            return null;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            List<SubscriptionInfo> subInfo = getSubInfo((String) null, (Object) null);
            if (subInfo != null && !z) {
                if (z2) {
                    logd("[getAllSubInfoList]- " + subInfo.size() + " infos return");
                }
                return (List) subInfo.stream().map(new SubscriptionController$$ExternalSyntheticLambda0(this, str, str2)).collect(Collectors.toList());
            } else if (!z2) {
                return subInfo;
            } else {
                logd("[getAllSubInfoList]- no info return");
                return subInfo;
            }
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ SubscriptionInfo lambda$getAllSubInfoList$1(String str, String str2, SubscriptionInfo subscriptionInfo) {
        return conditionallyRemoveIdentifiers(subscriptionInfo, str, str2, "getAllSubInfoList");
    }

    private List<SubscriptionInfo> makeCacheListCopyWithLock(List<SubscriptionInfo> list) {
        ArrayList arrayList;
        synchronized (this.mSubInfoListLock) {
            arrayList = new ArrayList(list);
        }
        return arrayList;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public List<SubscriptionInfo> getActiveSubscriptionInfoList(String str) {
        return getSubscriptionInfoListFromCacheHelper(str, (String) null, makeCacheListCopyWithLock(this.mCacheActiveSubInfoList));
    }

    public List<SubscriptionInfo> getActiveSubscriptionInfoList(String str, String str2) {
        return getSubscriptionInfoListFromCacheHelper(str, str2, makeCacheListCopyWithLock(this.mCacheActiveSubInfoList));
    }

    @VisibleForTesting
    public void refreshCachedActiveSubscriptionInfoList() {
        List<SubscriptionInfo> subInfo = getSubInfo("sim_id>=0 OR subscription_type=1", (Object) null);
        synchronized (this.mSubInfoListLock) {
            if (subInfo != null) {
                if (this.mCacheActiveSubInfoList.size() != subInfo.size() || !this.mCacheActiveSubInfoList.containsAll(subInfo)) {
                    logdl("Active subscription info list changed. " + subInfo);
                }
                this.mCacheActiveSubInfoList.clear();
                subInfo.sort(SUBSCRIPTION_INFO_COMPARATOR);
                this.mCacheActiveSubInfoList.addAll(subInfo);
            } else {
                logd("activeSubscriptionInfoList is null.");
                this.mCacheActiveSubInfoList.clear();
            }
        }
        refreshCachedOpportunisticSubscriptionInfoList();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public int getActiveSubInfoCount(String str) {
        return getActiveSubInfoCount(str, (String) null);
    }

    public int getActiveSubInfoCount(String str, String str2) {
        List<SubscriptionInfo> activeSubscriptionInfoList = getActiveSubscriptionInfoList(str, str2);
        if (activeSubscriptionInfoList != null) {
            if (VDBG) {
                logd("[getActiveSubInfoCount]- count: " + activeSubscriptionInfoList.size());
            }
            return activeSubscriptionInfoList.size();
        } else if (!VDBG) {
            return 0;
        } else {
            logd("[getActiveSubInfoCount] records null");
            return 0;
        }
    }

    public int getAllSubInfoCount(String str, String str2) {
        Cursor query;
        logd("[getAllSubInfoCount]+");
        if (!TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, -1, str, str2, "getAllSubInfoCount")) {
            return 0;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            query = this.mContext.getContentResolver().query(SubscriptionManager.CONTENT_URI, (String[]) null, (String) null, (String[]) null, (String) null);
            if (query != null) {
                int count = query.getCount();
                logd("[getAllSubInfoCount]- " + count + " SUB(s) in DB");
                query.close();
                Binder.restoreCallingIdentity(clearCallingIdentity);
                return count;
            }
            if (query != null) {
                query.close();
            }
            logd("[getAllSubInfoCount]- no SUB in DB");
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return 0;
        } catch (Throwable th) {
            Binder.restoreCallingIdentity(clearCallingIdentity);
            throw th;
        }
    }

    public int getActiveSubInfoCountMax() {
        return this.mTelephonyManager.getSimCount();
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(4:22|23|24|26) */
    /* JADX WARNING: Code restructure failed: missing block: B:23:?, code lost:
        r5.mContext.enforceCallingOrSelfPermission("android.permission.READ_PHONE_STATE", (java.lang.String) null);
        android.util.EventLog.writeEvent(1397638484, new java.lang.Object[]{"185235454", java.lang.Integer.valueOf(android.os.Binder.getCallingUid())});
     */
    /* JADX WARNING: Code restructure failed: missing block: B:26:0x00bf, code lost:
        throw new java.lang.SecurityException("Need READ_PRIVILEGED_PHONE_STATE to call  getAvailableSubscriptionInfoList");
     */
    /* JADX WARNING: Failed to process nested try/catch */
    /* JADX WARNING: Missing exception handler attribute for start block: B:22:0x0099 */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.util.List<android.telephony.SubscriptionInfo> getAvailableSubscriptionInfoList(java.lang.String r6, java.lang.String r7) {
        /*
            r5 = this;
            r6 = 0
            r7 = 0
            java.lang.String r0 = "getAvailableSubscriptionInfoList"
            r5.enforceReadPrivilegedPhoneState(r0)     // Catch:{ SecurityException -> 0x0099 }
            long r0 = android.os.Binder.clearCallingIdentity()
            java.lang.String r2 = "sim_id>=0 OR subscription_type=1"
            android.content.Context r3 = r5.mContext     // Catch:{ all -> 0x0094 }
            java.lang.String r4 = "euicc"
            java.lang.Object r3 = r3.getSystemService(r4)     // Catch:{ all -> 0x0094 }
            android.telephony.euicc.EuiccManager r3 = (android.telephony.euicc.EuiccManager) r3     // Catch:{ all -> 0x0094 }
            boolean r3 = r3.isEnabled()     // Catch:{ all -> 0x0094 }
            if (r3 == 0) goto L_0x002f
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x0094 }
            r3.<init>()     // Catch:{ all -> 0x0094 }
            r3.append(r2)     // Catch:{ all -> 0x0094 }
            java.lang.String r2 = " OR is_embedded=1"
            r3.append(r2)     // Catch:{ all -> 0x0094 }
            java.lang.String r2 = r3.toString()     // Catch:{ all -> 0x0094 }
        L_0x002f:
            java.util.List r3 = r5.getIccIdsOfInsertedPhysicalSims()     // Catch:{ all -> 0x0094 }
            boolean r4 = r3.isEmpty()     // Catch:{ all -> 0x0094 }
            if (r4 != 0) goto L_0x005e
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x0094 }
            r4.<init>()     // Catch:{ all -> 0x0094 }
            r4.append(r2)     // Catch:{ all -> 0x0094 }
            java.lang.String r2 = " OR ("
            r4.append(r2)     // Catch:{ all -> 0x0094 }
            java.lang.String[] r6 = new java.lang.String[r6]     // Catch:{ all -> 0x0094 }
            java.lang.Object[] r6 = r3.toArray(r6)     // Catch:{ all -> 0x0094 }
            java.lang.String[] r6 = (java.lang.String[]) r6     // Catch:{ all -> 0x0094 }
            java.lang.String r6 = r5.getSelectionForIccIdList(r6)     // Catch:{ all -> 0x0094 }
            r4.append(r6)     // Catch:{ all -> 0x0094 }
            java.lang.String r6 = ")"
            r4.append(r6)     // Catch:{ all -> 0x0094 }
            java.lang.String r2 = r4.toString()     // Catch:{ all -> 0x0094 }
        L_0x005e:
            java.util.List r6 = r5.getSubInfo(r2, r7)     // Catch:{ all -> 0x0094 }
            if (r6 == 0) goto L_0x008b
            java.util.Comparator<android.telephony.SubscriptionInfo> r7 = SUBSCRIPTION_INFO_COMPARATOR     // Catch:{ all -> 0x0094 }
            r6.sort(r7)     // Catch:{ all -> 0x0094 }
            boolean r7 = VDBG     // Catch:{ all -> 0x0094 }
            if (r7 == 0) goto L_0x0090
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x0094 }
            r7.<init>()     // Catch:{ all -> 0x0094 }
            java.lang.String r2 = "[getAvailableSubInfoList]- "
            r7.append(r2)     // Catch:{ all -> 0x0094 }
            int r2 = r6.size()     // Catch:{ all -> 0x0094 }
            r7.append(r2)     // Catch:{ all -> 0x0094 }
            java.lang.String r2 = " infos return"
            r7.append(r2)     // Catch:{ all -> 0x0094 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x0094 }
            r5.logdl(r7)     // Catch:{ all -> 0x0094 }
            goto L_0x0090
        L_0x008b:
            java.lang.String r7 = "[getAvailableSubInfoList]- no info return"
            r5.logdl(r7)     // Catch:{ all -> 0x0094 }
        L_0x0090:
            android.os.Binder.restoreCallingIdentity(r0)
            return r6
        L_0x0094:
            r5 = move-exception
            android.os.Binder.restoreCallingIdentity(r0)
            throw r5
        L_0x0099:
            android.content.Context r5 = r5.mContext     // Catch:{ SecurityException -> 0x00b8 }
            java.lang.String r0 = "android.permission.READ_PHONE_STATE"
            r5.enforceCallingOrSelfPermission(r0, r7)     // Catch:{ SecurityException -> 0x00b8 }
            r5 = 1397638484(0x534e4554, float:8.859264E11)
            r7 = 2
            java.lang.Object[] r7 = new java.lang.Object[r7]     // Catch:{ SecurityException -> 0x00b8 }
            java.lang.String r0 = "185235454"
            r7[r6] = r0     // Catch:{ SecurityException -> 0x00b8 }
            r6 = 1
            int r0 = android.os.Binder.getCallingUid()     // Catch:{ SecurityException -> 0x00b8 }
            java.lang.Integer r0 = java.lang.Integer.valueOf(r0)     // Catch:{ SecurityException -> 0x00b8 }
            r7[r6] = r0     // Catch:{ SecurityException -> 0x00b8 }
            android.util.EventLog.writeEvent(r5, r7)     // Catch:{ SecurityException -> 0x00b8 }
        L_0x00b8:
            java.lang.SecurityException r5 = new java.lang.SecurityException
            java.lang.String r6 = "Need READ_PRIVILEGED_PHONE_STATE to call  getAvailableSubscriptionInfoList"
            r5.<init>(r6)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.getAvailableSubscriptionInfoList(java.lang.String, java.lang.String):java.util.List");
    }

    private List<String> getIccIdsOfInsertedPhysicalSims() {
        ArrayList arrayList = new ArrayList();
        UiccSlot[] uiccSlots = UiccController.getInstance().getUiccSlots();
        if (uiccSlots == null) {
            return arrayList;
        }
        for (UiccSlot uiccSlot : uiccSlots) {
            if (uiccSlot != null && uiccSlot.getCardState() != null && uiccSlot.getCardState().isCardPresent() && !uiccSlot.isEuicc()) {
                String iccId = uiccSlot.getIccId(0);
                if (!TextUtils.isEmpty(iccId)) {
                    arrayList.add(IccUtils.stripTrailingFs(iccId));
                }
            }
        }
        return arrayList;
    }

    public List<SubscriptionInfo> getAccessibleSubscriptionInfoList(String str) {
        if (!((EuiccManager) this.mContext.getSystemService("euicc")).isEnabled()) {
            logdl("[getAccessibleSubInfoList] Embedded subscriptions are disabled");
            return null;
        }
        this.mAppOps.checkPackage(Binder.getCallingUid(), str);
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            List<SubscriptionInfo> subInfo = getSubInfo("is_embedded=1", (Object) null);
            if (subInfo == null) {
                logdl("[getAccessibleSubInfoList] No info returned");
                return null;
            }
            List<SubscriptionInfo> list = (List) subInfo.stream().filter(new SubscriptionController$$ExternalSyntheticLambda11(this, str)).sorted(SUBSCRIPTION_INFO_COMPARATOR).collect(Collectors.toList());
            if (VDBG) {
                logdl("[getAccessibleSubInfoList] " + list.size() + " infos returned");
            }
            return list;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$getAccessibleSubscriptionInfoList$2(String str, SubscriptionInfo subscriptionInfo) {
        return subscriptionInfo.canManageSubscription(this.mContext, str);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public List<SubscriptionInfo> getSubscriptionInfoListForEmbeddedSubscriptionUpdate(String[] strArr, boolean z) {
        StringBuilder sb = new StringBuilder();
        sb.append("(");
        sb.append("is_embedded");
        sb.append("=1");
        if (z) {
            sb.append(" AND ");
            sb.append("is_removable");
            sb.append("=1");
        }
        sb.append(") OR ");
        sb.append("icc_id");
        sb.append(" IN (");
        for (int i = 0; i < strArr.length; i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append("'");
            sb.append(strArr[i]);
            sb.append("'");
        }
        sb.append(")");
        List<SubscriptionInfo> subInfo = getSubInfo(sb.toString(), (Object) null);
        return subInfo == null ? Collections.emptyList() : subInfo;
    }

    public void requestEmbeddedSubscriptionInfoListRefresh(int i) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.WRITE_EMBEDDED_SUBSCRIPTIONS", "requestEmbeddedSubscriptionInfoListRefresh");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            PhoneFactory.requestEmbeddedSubscriptionInfoListRefresh(i, (Runnable) null);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void requestEmbeddedSubscriptionInfoListRefresh(int i, Runnable runnable) {
        PhoneFactory.requestEmbeddedSubscriptionInfoListRefresh(i, runnable);
    }

    public void requestEmbeddedSubscriptionInfoListRefresh(Runnable runnable) {
        PhoneFactory.requestEmbeddedSubscriptionInfoListRefresh(this.mTelephonyManager.getCardIdForDefaultEuicc(), runnable);
    }

    public int addSubInfoRecord(String str, int i) {
        return addSubInfo(str, (String) null, i, 0);
    }

    /* JADX WARNING: type inference failed for: r6v3, types: [java.lang.String, java.lang.String[]] */
    /* JADX WARNING: Code restructure failed: missing block: B:100:?, code lost:
        r1.close();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:101:0x02bc, code lost:
        throw r0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:122:0x0360, code lost:
        if (r8 != null) goto L_0x0362;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:124:?, code lost:
        r8.close();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:125:0x0365, code lost:
        throw r0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:126:0x0366, code lost:
        r0 = move-exception;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:127:0x0367, code lost:
        android.os.Binder.restoreCallingIdentity(r4);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:128:0x036a, code lost:
        throw r0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:29:0x00d6, code lost:
        r0 = move-exception;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:90:0x024c, code lost:
        if (r9 == 1) goto L_0x024e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:98:0x02b8, code lost:
        r0 = move-exception;
     */
    /* JADX WARNING: Exception block dominator not found, dom blocks: [B:7:0x0046, B:24:0x00cd, B:80:0x01e7] */
    /* JADX WARNING: Removed duplicated region for block: B:103:0x02bf A[Catch:{ all -> 0x02b8, all -> 0x00d6, all -> 0x0366 }] */
    /* JADX WARNING: Removed duplicated region for block: B:106:0x02cb A[Catch:{ all -> 0x02b8, all -> 0x00d6, all -> 0x0366 }] */
    /* JADX WARNING: Removed duplicated region for block: B:107:0x02d0 A[Catch:{ all -> 0x02b8, all -> 0x00d6, all -> 0x0366 }] */
    /* JADX WARNING: Removed duplicated region for block: B:35:0x00e4  */
    /* JADX WARNING: Removed duplicated region for block: B:40:0x0107 A[Catch:{ all -> 0x02b8, all -> 0x00d6, all -> 0x0366 }] */
    /* JADX WARNING: Removed duplicated region for block: B:72:0x01b1 A[SYNTHETIC, Splitter:B:72:0x01b1] */
    /* JADX WARNING: Removed duplicated region for block: B:76:0x01c7 A[Catch:{ all -> 0x02b8, all -> 0x00d6, all -> 0x0366 }] */
    /* JADX WARNING: Removed duplicated region for block: B:77:0x01d8 A[Catch:{ all -> 0x02b8, all -> 0x00d6, all -> 0x0366 }] */
    /* JADX WARNING: Removed duplicated region for block: B:80:0x01e7 A[SYNTHETIC, Splitter:B:80:0x01e7] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int addSubInfo(java.lang.String r23, java.lang.String r24, int r25, int r26) {
        /*
            r22 = this;
            r0 = r22
            r1 = r23
            r2 = r25
            r3 = r26
            boolean r4 = r0.isSubscriptionForRemoteSim(r3)
            if (r4 != 0) goto L_0x0013
            java.lang.String r4 = android.telephony.SubscriptionInfo.givePrintableIccid(r23)
            goto L_0x0014
        L_0x0013:
            r4 = r1
        L_0x0014:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r6 = "[addSubInfoRecord]+ iccid: "
            r5.append(r6)
            r5.append(r4)
            java.lang.String r4 = ", slotIndex: "
            r5.append(r4)
            r5.append(r2)
            java.lang.String r4 = ", subscriptionType: "
            r5.append(r4)
            r5.append(r3)
            java.lang.String r4 = r5.toString()
            r0.logdl(r4)
            java.lang.String r4 = "addSubInfo"
            r0.enforceModifyPhoneState(r4)
            long r4 = android.os.Binder.clearCallingIdentity()
            r6 = -1
            if (r1 != 0) goto L_0x004d
            java.lang.String r1 = "[addSubInfo]- null iccId"
            r0.logdl(r1)     // Catch:{ all -> 0x0366 }
            android.os.Binder.restoreCallingIdentity(r4)
            return r6
        L_0x004d:
            android.content.Context r7 = r0.mContext     // Catch:{ all -> 0x0366 }
            android.content.ContentResolver r7 = r7.getContentResolver()     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = "icc_id=?"
            boolean r9 = r0.isSubscriptionForRemoteSim(r3)     // Catch:{ all -> 0x0366 }
            r14 = 2
            r15 = 0
            r13 = 1
            if (r9 == 0) goto L_0x0091
            android.content.Context r9 = r0.mContext     // Catch:{ all -> 0x0366 }
            android.content.pm.PackageManager r9 = r9.getPackageManager()     // Catch:{ all -> 0x0366 }
            java.lang.String r10 = "android.hardware.type.automotive"
            boolean r9 = r9.hasSystemFeature(r10)     // Catch:{ all -> 0x0366 }
            if (r9 != 0) goto L_0x0075
            java.lang.String r1 = "[addSubInfo] Remote SIM can only be added when FEATURE_AUTOMOTIVE is supported"
            r0.logel(r1)     // Catch:{ all -> 0x0366 }
            android.os.Binder.restoreCallingIdentity(r4)
            return r6
        L_0x0075:
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x0366 }
            r9.<init>()     // Catch:{ all -> 0x0366 }
            r9.append(r8)     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = " AND subscription_type=?"
            r9.append(r8)     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = r9.toString()     // Catch:{ all -> 0x0366 }
            java.lang.String[] r9 = new java.lang.String[r14]     // Catch:{ all -> 0x0366 }
            r9[r15] = r1     // Catch:{ all -> 0x0366 }
            java.lang.String r10 = java.lang.Integer.toString(r26)     // Catch:{ all -> 0x0366 }
            r9[r13] = r10     // Catch:{ all -> 0x0366 }
            goto L_0x00ac
        L_0x0091:
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x0366 }
            r9.<init>()     // Catch:{ all -> 0x0366 }
            r9.append(r8)     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = " OR icc_id=?"
            r9.append(r8)     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = r9.toString()     // Catch:{ all -> 0x0366 }
            java.lang.String[] r9 = new java.lang.String[r14]     // Catch:{ all -> 0x0366 }
            r9[r15] = r1     // Catch:{ all -> 0x0366 }
            java.lang.String r10 = com.android.internal.telephony.uicc.IccUtils.getDecimalSubstring(r23)     // Catch:{ all -> 0x0366 }
            r9[r13] = r10     // Catch:{ all -> 0x0366 }
        L_0x00ac:
            r11 = r8
            r12 = r9
            android.net.Uri r9 = android.telephony.SubscriptionManager.CONTENT_URI     // Catch:{ all -> 0x0366 }
            java.lang.String r16 = "_id"
            java.lang.String r17 = "sim_id"
            java.lang.String r18 = "name_source"
            java.lang.String r19 = "icc_id"
            java.lang.String r20 = "card_id"
            java.lang.String r21 = "port_index"
            java.lang.String[] r10 = new java.lang.String[]{r16, r17, r18, r19, r20, r21}     // Catch:{ all -> 0x0366 }
            r16 = 0
            r8 = r7
            r14 = r13
            r13 = r16
            android.database.Cursor r8 = r8.query(r9, r10, r11, r12, r13)     // Catch:{ all -> 0x0366 }
            if (r8 == 0) goto L_0x00d9
            boolean r9 = r8.moveToFirst()     // Catch:{ all -> 0x00d6 }
            if (r9 != 0) goto L_0x00d4
            goto L_0x00d9
        L_0x00d4:
            r13 = r15
            goto L_0x00da
        L_0x00d6:
            r0 = move-exception
            goto L_0x0360
        L_0x00d9:
            r13 = r14
        L_0x00da:
            boolean r9 = r0.isSubscriptionForRemoteSim(r3)     // Catch:{ all -> 0x00d6 }
            java.lang.String r10 = "[addSubInfoRecord] New record created: "
            java.lang.String r11 = "[addSubInfoRecord] Record already exists"
            if (r9 == 0) goto L_0x0107
            if (r13 == 0) goto L_0x0101
            r9 = r24
            android.net.Uri r2 = r0.insertEmptySubInfoRecord(r1, r9, r6, r3)     // Catch:{ all -> 0x00d6 }
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d6 }
            r9.<init>()     // Catch:{ all -> 0x00d6 }
            r9.append(r10)     // Catch:{ all -> 0x00d6 }
            r9.append(r2)     // Catch:{ all -> 0x00d6 }
            java.lang.String r2 = r9.toString()     // Catch:{ all -> 0x00d6 }
            r0.logd(r2)     // Catch:{ all -> 0x00d6 }
            r2 = r6
            r14 = r15
            goto L_0x011f
        L_0x0101:
            r0.logdl(r11)     // Catch:{ all -> 0x00d6 }
            r12 = 0
            goto L_0x01ae
        L_0x0107:
            if (r13 == 0) goto L_0x0122
            android.net.Uri r9 = r0.insertEmptySubInfoRecord(r1, r2)     // Catch:{ all -> 0x00d6 }
            java.lang.StringBuilder r11 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d6 }
            r11.<init>()     // Catch:{ all -> 0x00d6 }
            r11.append(r10)     // Catch:{ all -> 0x00d6 }
            r11.append(r9)     // Catch:{ all -> 0x00d6 }
            java.lang.String r9 = r11.toString()     // Catch:{ all -> 0x00d6 }
            r0.logdl(r9)     // Catch:{ all -> 0x00d6 }
        L_0x011f:
            r12 = 0
            goto L_0x01af
        L_0x0122:
            int r9 = r8.getInt(r15)     // Catch:{ all -> 0x00d6 }
            int r10 = r8.getInt(r14)     // Catch:{ all -> 0x00d6 }
            r13 = 2
            r8.getInt(r13)     // Catch:{ all -> 0x00d6 }
            r13 = 3
            java.lang.String r13 = r8.getString(r13)     // Catch:{ all -> 0x00d6 }
            r6 = 4
            java.lang.String r6 = r8.getString(r6)     // Catch:{ all -> 0x00d6 }
            r15 = 5
            int r15 = r8.getInt(r15)     // Catch:{ all -> 0x00d6 }
            android.content.ContentValues r14 = new android.content.ContentValues     // Catch:{ all -> 0x00d6 }
            r14.<init>()     // Catch:{ all -> 0x00d6 }
            if (r2 == r10) goto L_0x014e
            java.lang.String r10 = "sim_id"
            java.lang.Integer r12 = java.lang.Integer.valueOf(r25)     // Catch:{ all -> 0x00d6 }
            r14.put(r10, r12)     // Catch:{ all -> 0x00d6 }
        L_0x014e:
            if (r13 == 0) goto L_0x0169
            int r10 = r13.length()     // Catch:{ all -> 0x00d6 }
            int r12 = r23.length()     // Catch:{ all -> 0x00d6 }
            if (r10 >= r12) goto L_0x0169
            java.lang.String r10 = com.android.internal.telephony.uicc.IccUtils.getDecimalSubstring(r23)     // Catch:{ all -> 0x00d6 }
            boolean r10 = r13.equals(r10)     // Catch:{ all -> 0x00d6 }
            if (r10 == 0) goto L_0x0169
            java.lang.String r10 = "icc_id"
            r14.put(r10, r1)     // Catch:{ all -> 0x00d6 }
        L_0x0169:
            com.android.internal.telephony.uicc.UiccController r10 = r0.mUiccController     // Catch:{ all -> 0x00d6 }
            com.android.internal.telephony.uicc.UiccCard r10 = r10.getUiccCardForPhone(r2)     // Catch:{ all -> 0x00d6 }
            if (r10 == 0) goto L_0x017e
            java.lang.String r10 = r10.getCardId()     // Catch:{ all -> 0x00d6 }
            if (r10 == 0) goto L_0x017e
            if (r10 == r6) goto L_0x017e
            java.lang.String r6 = "card_id"
            r14.put(r6, r10)     // Catch:{ all -> 0x00d6 }
        L_0x017e:
            com.android.internal.telephony.uicc.UiccController r6 = r0.mUiccController     // Catch:{ all -> 0x00d6 }
            com.android.internal.telephony.uicc.UiccSlot r6 = r6.getUiccSlotForPhone(r2)     // Catch:{ all -> 0x00d6 }
            if (r6 == 0) goto L_0x019b
            boolean r10 = r6.isEuicc()     // Catch:{ all -> 0x00d6 }
            if (r10 != 0) goto L_0x019b
            int r6 = r6.getPortIndexFromIccId(r1)     // Catch:{ all -> 0x00d6 }
            if (r6 == r15) goto L_0x019b
            java.lang.String r10 = "port_index"
            java.lang.Integer r6 = java.lang.Integer.valueOf(r6)     // Catch:{ all -> 0x00d6 }
            r14.put(r10, r6)     // Catch:{ all -> 0x00d6 }
        L_0x019b:
            int r6 = r14.size()     // Catch:{ all -> 0x00d6 }
            if (r6 <= 0) goto L_0x01aa
            android.net.Uri r6 = android.telephony.SubscriptionManager.getUriForSubscriptionId(r9)     // Catch:{ all -> 0x00d6 }
            r12 = 0
            r7.update(r6, r14, r12, r12)     // Catch:{ all -> 0x00d6 }
            goto L_0x01ab
        L_0x01aa:
            r12 = 0
        L_0x01ab:
            r0.logdl(r11)     // Catch:{ all -> 0x00d6 }
        L_0x01ae:
            r14 = 0
        L_0x01af:
            if (r8 == 0) goto L_0x01b4
            r8.close()     // Catch:{ all -> 0x0366 }
        L_0x01b4:
            java.lang.String r6 = "sim_id=?"
            r8 = 1
            java.lang.String[] r9 = new java.lang.String[r8]     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = java.lang.String.valueOf(r2)     // Catch:{ all -> 0x0366 }
            r10 = 0
            r9[r10] = r8     // Catch:{ all -> 0x0366 }
            boolean r8 = r0.isSubscriptionForRemoteSim(r3)     // Catch:{ all -> 0x0366 }
            if (r8 == 0) goto L_0x01d8
            java.lang.String r6 = "icc_id=? AND subscription_type=?"
            r8 = 2
            java.lang.String[] r8 = new java.lang.String[r8]     // Catch:{ all -> 0x0366 }
            r8[r10] = r1     // Catch:{ all -> 0x0366 }
            java.lang.String r1 = java.lang.Integer.toString(r26)     // Catch:{ all -> 0x0366 }
            r9 = 1
            r8[r9] = r1     // Catch:{ all -> 0x0366 }
            r11 = r6
            r1 = r8
            goto L_0x01da
        L_0x01d8:
            r11 = r6
            r1 = r9
        L_0x01da:
            android.net.Uri r9 = android.telephony.SubscriptionManager.CONTENT_URI     // Catch:{ all -> 0x0366 }
            r10 = 0
            r13 = 0
            r8 = r7
            r6 = r12
            r12 = r1
            android.database.Cursor r1 = r8.query(r9, r10, r11, r12, r13)     // Catch:{ all -> 0x0366 }
            if (r1 == 0) goto L_0x02bd
            boolean r8 = r1.moveToFirst()     // Catch:{ all -> 0x02b8 }
            if (r8 == 0) goto L_0x02bd
        L_0x01ed:
            java.lang.String r8 = "_id"
            int r8 = r1.getColumnIndexOrThrow(r8)     // Catch:{ all -> 0x02b8 }
            int r8 = r1.getInt(r8)     // Catch:{ all -> 0x02b8 }
            boolean r9 = r0.addToSubIdList(r2, r8, r3)     // Catch:{ all -> 0x02b8 }
            if (r9 == 0) goto L_0x028b
            int r9 = r22.getActiveSubInfoCountMax()     // Catch:{ all -> 0x02b8 }
            int r10 = r22.getDefaultSubId()     // Catch:{ all -> 0x02b8 }
            java.lang.StringBuilder r11 = new java.lang.StringBuilder     // Catch:{ all -> 0x02b8 }
            r11.<init>()     // Catch:{ all -> 0x02b8 }
            java.lang.String r12 = "[addSubInfoRecord] sSlotIndexToSubIds.size="
            r11.append(r12)     // Catch:{ all -> 0x02b8 }
            com.android.internal.telephony.SubscriptionController$WatchedSlotIndexToSubIds r12 = sSlotIndexToSubIds     // Catch:{ all -> 0x02b8 }
            int r12 = r12.size()     // Catch:{ all -> 0x02b8 }
            r11.append(r12)     // Catch:{ all -> 0x02b8 }
            java.lang.String r12 = " slotIndex="
            r11.append(r12)     // Catch:{ all -> 0x02b8 }
            r11.append(r2)     // Catch:{ all -> 0x02b8 }
            java.lang.String r12 = " subId="
            r11.append(r12)     // Catch:{ all -> 0x02b8 }
            r11.append(r8)     // Catch:{ all -> 0x02b8 }
            java.lang.String r12 = " defaultSubId="
            r11.append(r12)     // Catch:{ all -> 0x02b8 }
            r11.append(r10)     // Catch:{ all -> 0x02b8 }
            java.lang.String r12 = " simCount="
            r11.append(r12)     // Catch:{ all -> 0x02b8 }
            r11.append(r9)     // Catch:{ all -> 0x02b8 }
            java.lang.String r11 = r11.toString()     // Catch:{ all -> 0x02b8 }
            r0.logdl(r11)     // Catch:{ all -> 0x02b8 }
            boolean r11 = r0.isSubscriptionForRemoteSim(r3)     // Catch:{ all -> 0x02b8 }
            if (r11 != 0) goto L_0x0287
            boolean r10 = android.telephony.SubscriptionManager.isValidSubscriptionId(r10)     // Catch:{ all -> 0x02b8 }
            if (r10 == 0) goto L_0x024e
            r10 = 1
            if (r9 != r10) goto L_0x0267
        L_0x024e:
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ all -> 0x02b8 }
            r10.<init>()     // Catch:{ all -> 0x02b8 }
            java.lang.String r11 = "setting default fallback subid to "
            r10.append(r11)     // Catch:{ all -> 0x02b8 }
            r10.append(r8)     // Catch:{ all -> 0x02b8 }
            java.lang.String r10 = r10.toString()     // Catch:{ all -> 0x02b8 }
            r0.logdl(r10)     // Catch:{ all -> 0x02b8 }
            r0.setDefaultFallbackSubId(r8, r3)     // Catch:{ all -> 0x02b8 }
            r10 = 1
        L_0x0267:
            if (r9 != r10) goto L_0x0290
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x02b8 }
            r9.<init>()     // Catch:{ all -> 0x02b8 }
            java.lang.String r10 = "[addSubInfoRecord] one sim set defaults to subId="
            r9.append(r10)     // Catch:{ all -> 0x02b8 }
            r9.append(r8)     // Catch:{ all -> 0x02b8 }
            java.lang.String r9 = r9.toString()     // Catch:{ all -> 0x02b8 }
            r0.logdl(r9)     // Catch:{ all -> 0x02b8 }
            r0.setDefaultDataSubId(r8)     // Catch:{ all -> 0x02b8 }
            r0.setDefaultSmsSubId(r8)     // Catch:{ all -> 0x02b8 }
            r0.setDefaultVoiceSubId(r8)     // Catch:{ all -> 0x02b8 }
            goto L_0x0290
        L_0x0287:
            r0.updateDefaultSubIdsIfNeeded(r8, r3)     // Catch:{ all -> 0x02b8 }
            goto L_0x0290
        L_0x028b:
            java.lang.String r9 = "[addSubInfoRecord] current SubId is already known, IGNORE"
            r0.logdl(r9)     // Catch:{ all -> 0x02b8 }
        L_0x0290:
            java.lang.StringBuilder r9 = new java.lang.StringBuilder     // Catch:{ all -> 0x02b8 }
            r9.<init>()     // Catch:{ all -> 0x02b8 }
            java.lang.String r10 = "[addSubInfoRecord] hashmap("
            r9.append(r10)     // Catch:{ all -> 0x02b8 }
            r9.append(r2)     // Catch:{ all -> 0x02b8 }
            java.lang.String r10 = ","
            r9.append(r10)     // Catch:{ all -> 0x02b8 }
            r9.append(r8)     // Catch:{ all -> 0x02b8 }
            java.lang.String r8 = ")"
            r9.append(r8)     // Catch:{ all -> 0x02b8 }
            java.lang.String r8 = r9.toString()     // Catch:{ all -> 0x02b8 }
            r0.logdl(r8)     // Catch:{ all -> 0x02b8 }
            boolean r8 = r1.moveToNext()     // Catch:{ all -> 0x02b8 }
            if (r8 != 0) goto L_0x01ed
            goto L_0x02bd
        L_0x02b8:
            r0 = move-exception
            r1.close()     // Catch:{ all -> 0x0366 }
            throw r0     // Catch:{ all -> 0x0366 }
        L_0x02bd:
            if (r1 == 0) goto L_0x02c2
            r1.close()     // Catch:{ all -> 0x0366 }
        L_0x02c2:
            r22.refreshCachedActiveSubscriptionInfoList()     // Catch:{ all -> 0x0366 }
            boolean r1 = r0.isSubscriptionForRemoteSim(r3)     // Catch:{ all -> 0x0366 }
            if (r1 == 0) goto L_0x02d0
            r22.notifySubscriptionInfoChanged()     // Catch:{ all -> 0x0366 }
            goto L_0x035b
        L_0x02d0:
            int r1 = r0.getSubIdUsingPhoneId(r2)     // Catch:{ all -> 0x0366 }
            boolean r3 = android.telephony.SubscriptionManager.isValidSubscriptionId(r1)     // Catch:{ all -> 0x0366 }
            if (r3 != 0) goto L_0x02f3
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x0366 }
            r2.<init>()     // Catch:{ all -> 0x0366 }
            java.lang.String r3 = "[addSubInfoRecord]- getSubId failed invalid subId = "
            r2.append(r3)     // Catch:{ all -> 0x0366 }
            r2.append(r1)     // Catch:{ all -> 0x0366 }
            java.lang.String r1 = r2.toString()     // Catch:{ all -> 0x0366 }
            r0.logdl(r1)     // Catch:{ all -> 0x0366 }
            android.os.Binder.restoreCallingIdentity(r4)
            r0 = -1
            return r0
        L_0x02f3:
            if (r14 == 0) goto L_0x0341
            android.telephony.TelephonyManager r3 = r0.mTelephonyManager     // Catch:{ all -> 0x0366 }
            java.lang.String r3 = r3.getSimOperatorName(r1)     // Catch:{ all -> 0x0366 }
            boolean r8 = android.text.TextUtils.isEmpty(r3)     // Catch:{ all -> 0x0366 }
            if (r8 != 0) goto L_0x0302
            goto L_0x0319
        L_0x0302:
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x0366 }
            r3.<init>()     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = "CARD "
            r3.append(r8)     // Catch:{ all -> 0x0366 }
            r8 = 1
            int r2 = r2 + r8
            java.lang.String r2 = java.lang.Integer.toString(r2)     // Catch:{ all -> 0x0366 }
            r3.append(r2)     // Catch:{ all -> 0x0366 }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x0366 }
        L_0x0319:
            android.content.ContentValues r2 = new android.content.ContentValues     // Catch:{ all -> 0x0366 }
            r2.<init>()     // Catch:{ all -> 0x0366 }
            java.lang.String r8 = "display_name"
            r2.put(r8, r3)     // Catch:{ all -> 0x0366 }
            android.net.Uri r1 = android.telephony.SubscriptionManager.getUriForSubscriptionId(r1)     // Catch:{ all -> 0x0366 }
            r7.update(r1, r2, r6, r6)     // Catch:{ all -> 0x0366 }
            r22.refreshCachedActiveSubscriptionInfoList()     // Catch:{ all -> 0x0366 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0366 }
            r1.<init>()     // Catch:{ all -> 0x0366 }
            java.lang.String r2 = "[addSubInfoRecord] sim name = "
            r1.append(r2)     // Catch:{ all -> 0x0366 }
            r1.append(r3)     // Catch:{ all -> 0x0366 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x0366 }
            r0.logdl(r1)     // Catch:{ all -> 0x0366 }
        L_0x0341:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0366 }
            r1.<init>()     // Catch:{ all -> 0x0366 }
            java.lang.String r2 = "[addSubInfoRecord]- info size="
            r1.append(r2)     // Catch:{ all -> 0x0366 }
            com.android.internal.telephony.SubscriptionController$WatchedSlotIndexToSubIds r2 = sSlotIndexToSubIds     // Catch:{ all -> 0x0366 }
            int r2 = r2.size()     // Catch:{ all -> 0x0366 }
            r1.append(r2)     // Catch:{ all -> 0x0366 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x0366 }
            r0.logdl(r1)     // Catch:{ all -> 0x0366 }
        L_0x035b:
            android.os.Binder.restoreCallingIdentity(r4)
            r0 = 0
            return r0
        L_0x0360:
            if (r8 == 0) goto L_0x0365
            r8.close()     // Catch:{ all -> 0x0366 }
        L_0x0365:
            throw r0     // Catch:{ all -> 0x0366 }
        L_0x0366:
            r0 = move-exception
            android.os.Binder.restoreCallingIdentity(r4)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.addSubInfo(java.lang.String, java.lang.String, int, int):int");
    }

    /* access modifiers changed from: protected */
    public void updateDefaultSubIdsIfNeeded(int i, int i2) {
        logdl("[updateDefaultSubIdsIfNeeded] newDefault=" + i + ", subscriptionType=" + i2);
        if (!isActiveSubscriptionId(getDefaultSubId())) {
            logdl("[updateDefaultSubIdsIfNeeded] set sDefaultFallbackSubId=" + i);
            setDefaultFallbackSubId(i, i2);
        }
        if (!isActiveSubscriptionId(getDefaultSmsSubId())) {
            setDefaultSmsSubId(i);
        }
        if (!isActiveSubscriptionId(getDefaultDataSubId())) {
            setDefaultDataSubId(i);
        }
        if (!isActiveSubscriptionId(getDefaultVoiceSubId())) {
            setDefaultVoiceSubId(i);
        }
    }

    private boolean isActiveSubscriptionId(int i) {
        if (!SubscriptionManager.isValidSubscriptionId(i)) {
            return false;
        }
        ArrayList<Integer> activeSubIdArrayList = getActiveSubIdArrayList();
        if (activeSubIdArrayList.isEmpty()) {
            return false;
        }
        return activeSubIdArrayList.contains(new Integer(i));
    }

    public int removeSubInfo(String str, int i) {
        int i2;
        int i3;
        enforceModifyPhoneState("removeSubInfo");
        logd("[removeSubInfo] uniqueId: " + str + ", subscriptionType: " + i);
        synchronized (this.mSubInfoListLock) {
            Iterator<SubscriptionInfo> it = this.mCacheActiveSubInfoList.iterator();
            while (true) {
                if (!it.hasNext()) {
                    i2 = -1;
                    i3 = -1;
                    break;
                }
                SubscriptionInfo next = it.next();
                if (next.getSubscriptionType() == i && next.getIccId().equalsIgnoreCase(str)) {
                    i2 = next.getSubscriptionId();
                    i3 = next.getSimSlotIndex();
                    break;
                }
            }
        }
        if (i2 == -1) {
            logd("Invalid subscription details: subscriptionType = " + i + ", uniqueId = " + str);
            return -1;
        }
        logd("removing the subid : " + i2);
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            if (this.mContext.getContentResolver().delete(SubscriptionManager.CONTENT_URI, "_id=? AND subscription_type=?", new String[]{Integer.toString(i2), Integer.toString(i)}) != 1) {
                logd("found NO subscription to remove with subscriptionType = " + i + ", uniqueId = " + str);
                return -1;
            }
            refreshCachedActiveSubscriptionInfoList();
            int removeFromSubIdList = sSlotIndexToSubIds.removeFromSubIdList(i3, i2);
            if (removeFromSubIdList == -1) {
                loge("sSlotIndexToSubIds has no entry for slotIndex = " + i3);
            } else if (removeFromSubIdList == -2) {
                loge("sSlotIndexToSubIds has no subid: " + i2 + ", in index: " + i3);
            }
            SubscriptionInfo subscriptionInfo = null;
            List<SubscriptionInfo> activeSubscriptionInfoList = getActiveSubscriptionInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
            if (!activeSubscriptionInfoList.isEmpty()) {
                subscriptionInfo = activeSubscriptionInfoList.get(0);
            }
            updateDefaultSubIdsIfNeeded(subscriptionInfo.getSubscriptionId(), subscriptionInfo.getSubscriptionType());
            notifySubscriptionInfoChanged();
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return removeFromSubIdList;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void clearSubInfoRecord(int i) {
        logdl("[clearSubInfoRecord]+ iccId: slotIndex:" + i);
        ContentResolver contentResolver = this.mContext.getContentResolver();
        ContentValues contentValues = new ContentValues(1);
        contentValues.put("sim_id", -1);
        contentResolver.update(SubscriptionManager.CONTENT_URI, contentValues, "(sim_id=" + i + ")", (String[]) null);
        refreshCachedActiveSubscriptionInfoList();
        sSlotIndexToSubIds.remove(i);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PACKAGE)
    public Uri insertEmptySubInfoRecord(String str, int i) {
        if (getSubInfoForIccId(str) == null) {
            return insertEmptySubInfoRecord(str, (String) null, i, 0);
        }
        loge("insertEmptySubInfoRecord: Found existing record by ICCID. Do not create a new empty entry.");
        return null;
    }

    /* access modifiers changed from: protected */
    public Uri insertEmptySubInfoRecord(String str, String str2, int i, int i2) {
        String cardId;
        ContentResolver contentResolver = this.mContext.getContentResolver();
        ContentValues contentValues = new ContentValues();
        contentValues.put("icc_id", str);
        contentValues.put("color", Integer.valueOf(getUnusedColor(this.mContext.getOpPackageName(), this.mContext.getAttributionTag())));
        contentValues.put("sim_id", Integer.valueOf(i));
        contentValues.put("carrier_name", "");
        contentValues.put("card_id", str);
        contentValues.put("subscription_type", Integer.valueOf(i2));
        if (!TextUtils.isEmpty(str2)) {
            contentValues.put("display_name", str2);
        }
        if (!isSubscriptionForRemoteSim(i2)) {
            UiccCard uiccCardForPhone = this.mUiccController.getUiccCardForPhone(i);
            if (!(uiccCardForPhone == null || (cardId = uiccCardForPhone.getCardId()) == null)) {
                contentValues.put("card_id", cardId);
            }
            UiccSlot uiccSlotForPhone = this.mUiccController.getUiccSlotForPhone(i);
            if (uiccSlotForPhone != null) {
                contentValues.put("port_index", Integer.valueOf(uiccSlotForPhone.getPortIndexFromIccId(str)));
            }
        }
        contentValues.put("allowed_network_types_for_reasons", "user=" + RadioAccessFamily.getRafFromNetworkType(RILConstants.PREFERRED_NETWORK_MODE));
        contentValues.put("usage_setting", -1);
        Uri insert = contentResolver.insert(SubscriptionManager.CONTENT_URI, contentValues);
        refreshCachedActiveSubscriptionInfoList();
        return insert;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean setPlmnSpn(int i, boolean z, String str, boolean z2, String str2) {
        synchronized (this.mLock) {
            int subIdUsingPhoneId = getSubIdUsingPhoneId(i);
            if (this.mContext.getPackageManager().resolveContentProvider(SubscriptionManager.CONTENT_URI.getAuthority(), 0) != null) {
                if (SubscriptionManager.isValidSubscriptionId(subIdUsingPhoneId)) {
                    if (!z) {
                        str = z2 ? str2 : "";
                    } else if (z2 && !Objects.equals(str2, str)) {
                        str = str + this.mContext.getString(17040583).toString() + str2;
                    }
                    setCarrierText(str, subIdUsingPhoneId);
                    return true;
                }
            }
            logd("[setPlmnSpn] No valid subscription to store info");
            notifySubscriptionInfoChanged();
            return false;
        }
    }

    private int setCarrierText(String str, int i) {
        logd("[setCarrierText]+ text:" + str + " subId:" + i);
        enforceModifyPhoneState("setCarrierText");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        int i2 = 0;
        try {
            SubscriptionInfo subscriptionInfo = getSubscriptionInfo(i);
            if (subscriptionInfo != null ? !TextUtils.equals(str, subscriptionInfo.getCarrierName()) : true) {
                ContentValues contentValues = new ContentValues(1);
                contentValues.put("carrier_name", str);
                i2 = this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i), contentValues, (String) null, (String[]) null);
                refreshCachedActiveSubscriptionInfoList();
                notifySubscriptionInfoChanged();
            } else {
                logd("[setCarrierText]: no value update");
            }
            return i2;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public int setIconTint(int i, int i2) {
        logd("[setIconTint]+ tint:" + i + " subId:" + i2);
        enforceModifyPhoneState("setIconTint");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            validateSubId(i2);
            ContentValues contentValues = new ContentValues(1);
            contentValues.put("color", Integer.valueOf(i));
            logd("[setIconTint]- tint:" + i + " set");
            int update = this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i2), contentValues, (String) null, (String[]) null);
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
            return update;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public static int getNameSourcePriority(int i) {
        int indexOf = Arrays.asList(new Integer[]{0, 4, 1, 3, 2}).indexOf(Integer.valueOf(i));
        if (indexOf < 0) {
            return 0;
        }
        return indexOf;
    }

    @VisibleForTesting
    public boolean isExistingNameSourceStillValid(SubscriptionInfo subscriptionInfo) {
        int nameSource;
        PersistableBundle configForSubId;
        int subscriptionId = subscriptionInfo.getSubscriptionId();
        int phoneId = getPhoneId(subscriptionInfo.getSubscriptionId());
        Phone phone = PhoneFactory.getPhone(phoneId);
        if (!(phone == null || (nameSource = subscriptionInfo.getNameSource()) == 0)) {
            if (nameSource == 1) {
                return !TextUtils.isEmpty(getServiceProviderName(phoneId));
            }
            if (nameSource != 2) {
                if (nameSource != 3) {
                    if (nameSource != 4) {
                        return false;
                    }
                    return !TextUtils.isEmpty(phone.getPlmn());
                } else if (subscriptionInfo.isEmbedded() || (configForSubId = ((CarrierConfigManager) this.mContext.getSystemService(CarrierConfigManager.class)).getConfigForSubId(subscriptionId)) == null) {
                    return true;
                } else {
                    boolean z = configForSubId.getBoolean("carrier_name_override_bool", false);
                    String string = configForSubId.getString("carrier_name_string");
                    String serviceProviderName = getServiceProviderName(phoneId);
                    if (z) {
                        return true;
                    }
                    if (!TextUtils.isEmpty(serviceProviderName) || TextUtils.isEmpty(string)) {
                        return false;
                    }
                    return true;
                }
            }
        }
        return true;
    }

    @VisibleForTesting
    public String getServiceProviderName(int i) {
        UiccProfile uiccProfileForPhone = this.mUiccController.getUiccProfileForPhone(i);
        if (uiccProfileForPhone == null) {
            return null;
        }
        return uiccProfileForPhone.getServiceProviderName();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:31:0x00d3, code lost:
        if (android.text.TextUtils.isEmpty(r12) != false) goto L_0x00e2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:33:0x00dd, code lost:
        if (r12.trim().length() != 0) goto L_0x00e0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:35:0x00e0, code lost:
        r0 = r12;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:36:0x00e2, code lost:
        r0 = r11.mTelephonyManager.getSimOperatorName(r13);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:37:0x00ec, code lost:
        if (android.text.TextUtils.isEmpty(r0) == false) goto L_0x011b;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:39:0x00ef, code lost:
        if (r14 != 2) goto L_0x0112;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:41:0x00f9, code lost:
        if (android.telephony.SubscriptionManager.isValidSlotIndex(getSlotIndex(r13)) == false) goto L_0x0112;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:42:0x00fb, code lost:
        r0 = "CARD " + (getSlotIndex(r13) + 1);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:43:0x0112, code lost:
        r0 = r11.mContext.getString(17039374);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:44:0x011b, code lost:
        r3 = new android.content.ContentValues(1);
        r3.put("display_name", r0);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:45:0x0125, code lost:
        if (r14 < 0) goto L_0x0144;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:46:0x0127, code lost:
        logd("Set nameSource=" + r14);
        r3.put("name_source", java.lang.Integer.valueOf(r14));
     */
    /* JADX WARNING: Code restructure failed: missing block: B:47:0x0144, code lost:
        logd("[setDisplayName]- mDisplayName:" + r0 + " set");
        r14 = getSubscriptionInfo(r13);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:48:0x0161, code lost:
        if (r14 == null) goto L_0x019f;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:50:0x0167, code lost:
        if (r14.isEmbedded() == false) goto L_0x019f;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:51:0x0169, code lost:
        r14 = r14.getCardId();
        logd("Updating embedded sub nickname on cardId: " + r14);
        ((android.telephony.euicc.EuiccManager) r11.mContext.getSystemService("euicc")).createForCardId(r14).updateSubscriptionNickname(r13, r12, android.app.PendingIntent.getService(r11.mContext, 0, new android.content.Intent(), 67108864));
     */
    /* JADX WARNING: Code restructure failed: missing block: B:52:0x019f, code lost:
        r12 = updateDatabase(r3, r13, true);
        refreshCachedActiveSubscriptionInfoList();
        notifySubscriptionInfoChanged();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:53:0x01a9, code lost:
        android.os.Binder.restoreCallingIdentity(r1);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:54:0x01ac, code lost:
        return r12;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int setDisplayNameUsingSrc(java.lang.String r12, int r13, int r14) {
        /*
            r11 = this;
            java.lang.String r0 = "'s priority "
            java.lang.Throwable r1 = new java.lang.Throwable
            r1.<init>()
            java.lang.String r1 = android.util.Log.getStackTraceString(r1)
            r11.logd(r1)
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "[setDisplayName]+  displayName:"
            r1.append(r2)
            r1.append(r12)
            java.lang.String r2 = " subId:"
            r1.append(r2)
            r1.append(r13)
            java.lang.String r2 = " nameSource:"
            r1.append(r2)
            r1.append(r14)
            java.lang.String r1 = r1.toString()
            r11.logd(r1)
            java.lang.String r1 = "setDisplayNameUsingSrc"
            r11.enforceModifyPhoneState(r1)
            long r1 = android.os.Binder.clearCallingIdentity()
            r11.validateSubId(r13)     // Catch:{ all -> 0x01b1 }
            r3 = 0
            java.util.List r3 = r11.getSubInfo(r3, r3)     // Catch:{ all -> 0x01b1 }
            r4 = 0
            if (r3 == 0) goto L_0x01ad
            boolean r5 = r3.isEmpty()     // Catch:{ all -> 0x01b1 }
            if (r5 == 0) goto L_0x004e
            goto L_0x01ad
        L_0x004e:
            java.util.Iterator r3 = r3.iterator()     // Catch:{ all -> 0x01b1 }
        L_0x0052:
            boolean r5 = r3.hasNext()     // Catch:{ all -> 0x01b1 }
            r6 = 1
            if (r5 == 0) goto L_0x00cf
            java.lang.Object r5 = r3.next()     // Catch:{ all -> 0x01b1 }
            android.telephony.SubscriptionInfo r5 = (android.telephony.SubscriptionInfo) r5     // Catch:{ all -> 0x01b1 }
            int r7 = r5.getNameSource()     // Catch:{ all -> 0x01b1 }
            int r8 = getNameSourcePriority(r7)     // Catch:{ all -> 0x01b1 }
            int r9 = getNameSourcePriority(r14)     // Catch:{ all -> 0x01b1 }
            if (r8 <= r9) goto L_0x006f
            r8 = r6
            goto L_0x0070
        L_0x006f:
            r8 = r4
        L_0x0070:
            int r9 = getNameSourcePriority(r7)     // Catch:{ all -> 0x01b1 }
            int r10 = getNameSourcePriority(r14)     // Catch:{ all -> 0x01b1 }
            if (r9 != r10) goto L_0x0085
            java.lang.CharSequence r9 = r5.getDisplayName()     // Catch:{ all -> 0x01b1 }
            boolean r9 = android.text.TextUtils.equals(r12, r9)     // Catch:{ all -> 0x01b1 }
            if (r9 == 0) goto L_0x0085
            goto L_0x0086
        L_0x0085:
            r6 = r4
        L_0x0086:
            int r9 = r5.getSubscriptionId()     // Catch:{ all -> 0x01b1 }
            if (r9 != r13) goto L_0x0052
            boolean r5 = r11.isExistingNameSourceStillValid(r5)     // Catch:{ all -> 0x01b1 }
            if (r5 == 0) goto L_0x0052
            if (r8 != 0) goto L_0x0096
            if (r6 == 0) goto L_0x0052
        L_0x0096:
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ all -> 0x01b1 }
            r12.<init>()     // Catch:{ all -> 0x01b1 }
            java.lang.String r13 = "Name source "
            r12.append(r13)     // Catch:{ all -> 0x01b1 }
            r12.append(r7)     // Catch:{ all -> 0x01b1 }
            r12.append(r0)     // Catch:{ all -> 0x01b1 }
            int r13 = getNameSourcePriority(r7)     // Catch:{ all -> 0x01b1 }
            r12.append(r13)     // Catch:{ all -> 0x01b1 }
            java.lang.String r13 = " is greater than name source "
            r12.append(r13)     // Catch:{ all -> 0x01b1 }
            r12.append(r14)     // Catch:{ all -> 0x01b1 }
            r12.append(r0)     // Catch:{ all -> 0x01b1 }
            int r13 = getNameSourcePriority(r14)     // Catch:{ all -> 0x01b1 }
            r12.append(r13)     // Catch:{ all -> 0x01b1 }
            java.lang.String r13 = ", return now."
            r12.append(r13)     // Catch:{ all -> 0x01b1 }
            java.lang.String r12 = r12.toString()     // Catch:{ all -> 0x01b1 }
            r11.logd(r12)     // Catch:{ all -> 0x01b1 }
            android.os.Binder.restoreCallingIdentity(r1)
            return r4
        L_0x00cf:
            boolean r0 = android.text.TextUtils.isEmpty(r12)     // Catch:{ all -> 0x01b1 }
            if (r0 != 0) goto L_0x00e2
            java.lang.String r0 = r12.trim()     // Catch:{ all -> 0x01b1 }
            int r0 = r0.length()     // Catch:{ all -> 0x01b1 }
            if (r0 != 0) goto L_0x00e0
            goto L_0x00e2
        L_0x00e0:
            r0 = r12
            goto L_0x011b
        L_0x00e2:
            android.telephony.TelephonyManager r0 = r11.mTelephonyManager     // Catch:{ all -> 0x01b1 }
            java.lang.String r0 = r0.getSimOperatorName(r13)     // Catch:{ all -> 0x01b1 }
            boolean r3 = android.text.TextUtils.isEmpty(r0)     // Catch:{ all -> 0x01b1 }
            if (r3 == 0) goto L_0x011b
            r0 = 2
            if (r14 != r0) goto L_0x0112
            int r0 = r11.getSlotIndex(r13)     // Catch:{ all -> 0x01b1 }
            boolean r0 = android.telephony.SubscriptionManager.isValidSlotIndex(r0)     // Catch:{ all -> 0x01b1 }
            if (r0 == 0) goto L_0x0112
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x01b1 }
            r0.<init>()     // Catch:{ all -> 0x01b1 }
            java.lang.String r3 = "CARD "
            r0.append(r3)     // Catch:{ all -> 0x01b1 }
            int r3 = r11.getSlotIndex(r13)     // Catch:{ all -> 0x01b1 }
            int r3 = r3 + r6
            r0.append(r3)     // Catch:{ all -> 0x01b1 }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x01b1 }
            goto L_0x011b
        L_0x0112:
            android.content.Context r0 = r11.mContext     // Catch:{ all -> 0x01b1 }
            r3 = 17039374(0x104000e, float:2.424461E-38)
            java.lang.String r0 = r0.getString(r3)     // Catch:{ all -> 0x01b1 }
        L_0x011b:
            android.content.ContentValues r3 = new android.content.ContentValues     // Catch:{ all -> 0x01b1 }
            r3.<init>(r6)     // Catch:{ all -> 0x01b1 }
            java.lang.String r5 = "display_name"
            r3.put(r5, r0)     // Catch:{ all -> 0x01b1 }
            if (r14 < 0) goto L_0x0144
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x01b1 }
            r5.<init>()     // Catch:{ all -> 0x01b1 }
            java.lang.String r7 = "Set nameSource="
            r5.append(r7)     // Catch:{ all -> 0x01b1 }
            r5.append(r14)     // Catch:{ all -> 0x01b1 }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x01b1 }
            r11.logd(r5)     // Catch:{ all -> 0x01b1 }
            java.lang.String r5 = "name_source"
            java.lang.Integer r14 = java.lang.Integer.valueOf(r14)     // Catch:{ all -> 0x01b1 }
            r3.put(r5, r14)     // Catch:{ all -> 0x01b1 }
        L_0x0144:
            java.lang.StringBuilder r14 = new java.lang.StringBuilder     // Catch:{ all -> 0x01b1 }
            r14.<init>()     // Catch:{ all -> 0x01b1 }
            java.lang.String r5 = "[setDisplayName]- mDisplayName:"
            r14.append(r5)     // Catch:{ all -> 0x01b1 }
            r14.append(r0)     // Catch:{ all -> 0x01b1 }
            java.lang.String r0 = " set"
            r14.append(r0)     // Catch:{ all -> 0x01b1 }
            java.lang.String r14 = r14.toString()     // Catch:{ all -> 0x01b1 }
            r11.logd(r14)     // Catch:{ all -> 0x01b1 }
            android.telephony.SubscriptionInfo r14 = r11.getSubscriptionInfo(r13)     // Catch:{ all -> 0x01b1 }
            if (r14 == 0) goto L_0x019f
            boolean r0 = r14.isEmbedded()     // Catch:{ all -> 0x01b1 }
            if (r0 == 0) goto L_0x019f
            int r14 = r14.getCardId()     // Catch:{ all -> 0x01b1 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x01b1 }
            r0.<init>()     // Catch:{ all -> 0x01b1 }
            java.lang.String r5 = "Updating embedded sub nickname on cardId: "
            r0.append(r5)     // Catch:{ all -> 0x01b1 }
            r0.append(r14)     // Catch:{ all -> 0x01b1 }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x01b1 }
            r11.logd(r0)     // Catch:{ all -> 0x01b1 }
            android.content.Context r0 = r11.mContext     // Catch:{ all -> 0x01b1 }
            java.lang.String r5 = "euicc"
            java.lang.Object r0 = r0.getSystemService(r5)     // Catch:{ all -> 0x01b1 }
            android.telephony.euicc.EuiccManager r0 = (android.telephony.euicc.EuiccManager) r0     // Catch:{ all -> 0x01b1 }
            android.telephony.euicc.EuiccManager r14 = r0.createForCardId(r14)     // Catch:{ all -> 0x01b1 }
            android.content.Context r0 = r11.mContext     // Catch:{ all -> 0x01b1 }
            android.content.Intent r5 = new android.content.Intent     // Catch:{ all -> 0x01b1 }
            r5.<init>()     // Catch:{ all -> 0x01b1 }
            r7 = 67108864(0x4000000, float:1.5046328E-36)
            android.app.PendingIntent r0 = android.app.PendingIntent.getService(r0, r4, r5, r7)     // Catch:{ all -> 0x01b1 }
            r14.updateSubscriptionNickname(r13, r12, r0)     // Catch:{ all -> 0x01b1 }
        L_0x019f:
            int r12 = r11.updateDatabase(r3, r13, r6)     // Catch:{ all -> 0x01b1 }
            r11.refreshCachedActiveSubscriptionInfoList()     // Catch:{ all -> 0x01b1 }
            r11.notifySubscriptionInfoChanged()     // Catch:{ all -> 0x01b1 }
            android.os.Binder.restoreCallingIdentity(r1)
            return r12
        L_0x01ad:
            android.os.Binder.restoreCallingIdentity(r1)
            return r4
        L_0x01b1:
            r11 = move-exception
            android.os.Binder.restoreCallingIdentity(r1)
            throw r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.setDisplayNameUsingSrc(java.lang.String, int, int):int");
    }

    public int setDisplayNumber(String str, int i) {
        logd("[setDisplayNumber]+ subId:" + i);
        enforceModifyPhoneState("setDisplayNumber");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            validateSubId(i);
            int i2 = 0;
            int phoneId = getPhoneId(i);
            if (str != null && phoneId >= 0) {
                if (phoneId < this.mTelephonyManager.getPhoneCount()) {
                    SubscriptionInfo subscriptionInfo = getSubscriptionInfo(i);
                    if (subscriptionInfo != null ? !TextUtils.equals(subscriptionInfo.getNumber(), str) : true) {
                        ContentValues contentValues = new ContentValues(1);
                        contentValues.put("number", str);
                        i2 = this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i), contentValues, (String) null, (String[]) null);
                        logd("[setDisplayNumber]- update result :" + i2);
                        refreshCachedActiveSubscriptionInfoList();
                        notifySubscriptionInfoChanged();
                    } else {
                        logd("[setDisplayNumber]: no value update");
                    }
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                    return i2;
                }
            }
            logd("[setDisplayNumber]- fail");
            return -1;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void setAssociatedPlmns(String[] strArr, String[] strArr2, int i) {
        String str;
        logd("[setAssociatedPlmns]+ subId:" + i);
        validateSubId(i);
        int phoneId = getPhoneId(i);
        if (phoneId < 0 || phoneId >= this.mTelephonyManager.getPhoneCount()) {
            logd("[setAssociatedPlmns]- fail");
            return;
        }
        String str2 = "";
        if (strArr == null) {
            str = str2;
        } else {
            str = (String) Arrays.stream(strArr).filter(new SubscriptionController$$ExternalSyntheticLambda8()).collect(Collectors.joining(","));
        }
        if (strArr2 != null) {
            str2 = (String) Arrays.stream(strArr2).filter(new SubscriptionController$$ExternalSyntheticLambda9()).collect(Collectors.joining(","));
        }
        SubscriptionInfo subscriptionInfo = getSubscriptionInfo(i);
        boolean z = false;
        if (subscriptionInfo != null) {
            if ((((strArr == null && subscriptionInfo.getEhplmns().isEmpty()) || String.join(",", subscriptionInfo.getEhplmns()).equals(str)) && strArr2 == null && subscriptionInfo.getHplmns().isEmpty()) || String.join(",", subscriptionInfo.getHplmns()).equals(str2)) {
                z = true;
            }
        }
        if (!z) {
            ContentValues contentValues = new ContentValues(2);
            contentValues.put("ehplmns", str);
            contentValues.put("hplmns", str2);
            logd("[setAssociatedPlmns]- update result :" + this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i), contentValues, (String) null, (String[]) null));
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
            return;
        }
        logd("[setAssociatedPlmns]+ subId:" + i + "no value update");
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$setAssociatedPlmns$3(String str) {
        return str != null && !str.isEmpty();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$setAssociatedPlmns$4(String str) {
        return str != null && !str.isEmpty();
    }

    public int setDataRoaming(int i, int i2) {
        logd("[setDataRoaming]+ roaming:" + i + " subId:" + i2);
        enforceModifyPhoneState("setDataRoaming");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            validateSubId(i2);
            if (i < 0) {
                logd("[setDataRoaming]- fail");
                return -1;
            }
            ContentValues contentValues = new ContentValues(1);
            contentValues.put("data_roaming", Integer.valueOf(i));
            logd("[setDataRoaming]- roaming:" + i + " set");
            int updateDatabase = updateDatabase(contentValues, i2, true);
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return updateDatabase;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public int setDeviceToDeviceStatusSharing(int i, int i2) {
        logd("[setDeviceToDeviceStatusSharing]- sharing:" + i + " subId:" + i2);
        enforceModifyPhoneState("setDeviceToDeviceStatusSharing");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            validateSubId(i2);
            if (i < 0) {
                logd("[setDeviceToDeviceStatusSharing]- fail");
                return -1;
            }
            ContentValues contentValues = new ContentValues(1);
            contentValues.put("d2d_sharing_status", Integer.valueOf(i));
            logd("[setDeviceToDeviceStatusSharing]- sharing:" + i + " set");
            int updateDatabase = updateDatabase(contentValues, i2, true);
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return updateDatabase;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public int setDeviceToDeviceStatusSharingContacts(String str, int i) {
        logd("[setDeviceToDeviceStatusSharingContacts]- contacts:" + str + " subId:" + i);
        enforceModifyPhoneState("setDeviceToDeviceStatusSharingContacts");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            validateSubId(i);
            ContentValues contentValues = new ContentValues(1);
            contentValues.put("d2d_sharing_contacts", str);
            logd("[setDeviceToDeviceStatusSharingContacts]- contacts:" + str + " set");
            int updateDatabase = updateDatabase(contentValues, i, true);
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
            return updateDatabase;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void syncGroupedSetting(int i) {
        logd("syncGroupedSetting");
        Cursor query = this.mContext.getContentResolver().query(SubscriptionManager.CONTENT_URI, (String[]) null, InboundSmsHandler.SELECT_BY_ID, new String[]{String.valueOf(i)}, (String) null);
        if (query != null) {
            try {
                if (query.moveToFirst()) {
                    Set<String> set = GROUP_SHARING_PROPERTIES;
                    ContentValues contentValues = new ContentValues(set.size());
                    for (String copyDataFromCursorToContentValue : set) {
                        copyDataFromCursorToContentValue(copyDataFromCursorToContentValue, query, contentValues);
                    }
                    updateDatabase(contentValues, i, true);
                    query.close();
                    return;
                }
            } catch (Throwable th) {
                th.addSuppressed(th);
            }
        }
        logd("[syncGroupedSetting] failed. Can't find refSubId " + i);
        if (query != null) {
            query.close();
            return;
        }
        return;
        throw th;
    }

    private void copyDataFromCursorToContentValue(String str, Cursor cursor, ContentValues contentValues) {
        int columnIndex = cursor.getColumnIndex(str);
        char c = 65535;
        if (columnIndex == -1) {
            logd("[copyDataFromCursorToContentValue] can't find column " + str);
            return;
        }
        str.hashCode();
        switch (str.hashCode()) {
            case -1958907444:
                if (str.equals("ims_rcs_uce_enabled")) {
                    c = 0;
                    break;
                }
                break;
            case -1950380197:
                if (str.equals("volte_vt_enabled")) {
                    c = 1;
                    break;
                }
                break;
            case -1489974588:
                if (str.equals("nr_advanced_calling_enabled")) {
                    c = 2;
                    break;
                }
                break;
            case -1339240225:
                if (str.equals("cross_sim_calling_enabled")) {
                    c = 3;
                    break;
                }
                break;
            case -1218173306:
                if (str.equals("wfc_ims_enabled")) {
                    c = 4;
                    break;
                }
                break;
            case -420099376:
                if (str.equals("vt_ims_enabled")) {
                    c = 5;
                    break;
                }
                break;
            case 180938212:
                if (str.equals("wfc_ims_roaming_mode")) {
                    c = 6;
                    break;
                }
                break;
            case 512460727:
                if (str.equals("data_enabled_override_rules")) {
                    c = 7;
                    break;
                }
                break;
            case 692824196:
                if (str.equals("data_roaming")) {
                    c = 8;
                    break;
                }
                break;
            case 1334635646:
                if (str.equals("wfc_ims_mode")) {
                    c = 9;
                    break;
                }
                break;
            case 1604840288:
                if (str.equals("wfc_ims_roaming_enabled")) {
                    c = 10;
                    break;
                }
                break;
            case 1615086568:
                if (str.equals("display_name")) {
                    c = 11;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 8:
            case 9:
            case 10:
                contentValues.put(str, Integer.valueOf(cursor.getInt(columnIndex)));
                return;
            case 7:
            case 11:
                contentValues.put(str, cursor.getString(columnIndex));
                return;
            default:
                loge("[copyDataFromCursorToContentValue] invalid propKey " + str);
                return;
        }
    }

    /* access modifiers changed from: protected */
    public int updateDatabase(ContentValues contentValues, int i, boolean z) {
        List<SubscriptionInfo> subscriptionsInGroup = getSubscriptionsInGroup(getGroupUuid(i), this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
        if (!z || subscriptionsInGroup == null || subscriptionsInGroup.size() == 0) {
            return this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i), contentValues, (String) null, (String[]) null);
        }
        int[] iArr = new int[subscriptionsInGroup.size()];
        for (int i2 = 0; i2 < subscriptionsInGroup.size(); i2++) {
            iArr[i2] = subscriptionsInGroup.get(i2).getSubscriptionId();
        }
        return this.mContext.getContentResolver().update(SubscriptionManager.CONTENT_URI, contentValues, getSelectionForSubIdList(iArr), (String[]) null);
    }

    /* JADX WARNING: Removed duplicated region for block: B:10:0x003c A[Catch:{ all -> 0x0069 }] */
    /* JADX WARNING: Removed duplicated region for block: B:11:0x0060 A[Catch:{ all -> 0x0069 }] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int setCarrierId(int r6, int r7) {
        /*
            r5 = this;
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "[setCarrierId]+ carrierId:"
            r0.append(r1)
            r0.append(r6)
            java.lang.String r1 = " subId:"
            r0.append(r1)
            r0.append(r7)
            java.lang.String r0 = r0.toString()
            r5.logd(r0)
            java.lang.String r0 = "setCarrierId"
            r5.enforceModifyPhoneState(r0)
            long r0 = android.os.Binder.clearCallingIdentity()
            r5.validateSubId(r7)     // Catch:{ all -> 0x0069 }
            android.telephony.SubscriptionInfo r2 = r5.getSubscriptionInfo(r7)     // Catch:{ all -> 0x0069 }
            r3 = 0
            r4 = 1
            if (r2 == 0) goto L_0x0039
            int r2 = r2.getCarrierId()     // Catch:{ all -> 0x0069 }
            if (r2 == r6) goto L_0x0037
            goto L_0x0039
        L_0x0037:
            r2 = r3
            goto L_0x003a
        L_0x0039:
            r2 = r4
        L_0x003a:
            if (r2 == 0) goto L_0x0060
            android.content.ContentValues r2 = new android.content.ContentValues     // Catch:{ all -> 0x0069 }
            r2.<init>(r4)     // Catch:{ all -> 0x0069 }
            java.lang.String r3 = "carrier_id"
            java.lang.Integer r6 = java.lang.Integer.valueOf(r6)     // Catch:{ all -> 0x0069 }
            r2.put(r3, r6)     // Catch:{ all -> 0x0069 }
            android.content.Context r6 = r5.mContext     // Catch:{ all -> 0x0069 }
            android.content.ContentResolver r6 = r6.getContentResolver()     // Catch:{ all -> 0x0069 }
            android.net.Uri r7 = android.telephony.SubscriptionManager.getUriForSubscriptionId(r7)     // Catch:{ all -> 0x0069 }
            r3 = 0
            int r3 = r6.update(r7, r2, r3, r3)     // Catch:{ all -> 0x0069 }
            r5.refreshCachedActiveSubscriptionInfoList()     // Catch:{ all -> 0x0069 }
            r5.notifySubscriptionInfoChanged()     // Catch:{ all -> 0x0069 }
            goto L_0x0065
        L_0x0060:
            java.lang.String r6 = "[setCarrierId]: no value update"
            r5.logd(r6)     // Catch:{ all -> 0x0069 }
        L_0x0065:
            android.os.Binder.restoreCallingIdentity(r0)
            return r3
        L_0x0069:
            r5 = move-exception
            android.os.Binder.restoreCallingIdentity(r0)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.setCarrierId(int, int):int");
    }

    /* JADX WARNING: Removed duplicated region for block: B:21:0x0054  */
    /* JADX WARNING: Removed duplicated region for block: B:22:0x00b0  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int setMccMnc(java.lang.String r8, int r9) {
        /*
            r7 = this;
            r0 = 0
            r1 = 3
            java.lang.String r2 = r8.substring(r0, r1)
            java.lang.String r1 = r8.substring(r1)
            int r3 = java.lang.Integer.parseInt(r2)     // Catch:{ NumberFormatException -> 0x0013 }
            int r8 = java.lang.Integer.parseInt(r1)     // Catch:{ NumberFormatException -> 0x0014 }
            goto L_0x0029
        L_0x0013:
            r3 = r0
        L_0x0014:
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            java.lang.String r5 = "[setMccMnc] - couldn't parse mcc/mnc: "
            r4.append(r5)
            r4.append(r8)
            java.lang.String r8 = r4.toString()
            r7.loge(r8)
            r8 = r0
        L_0x0029:
            android.telephony.SubscriptionInfo r4 = r7.getSubscriptionInfo(r9)
            r5 = 1
            if (r4 == 0) goto L_0x0052
            int r6 = r4.getMcc()
            if (r6 != r3) goto L_0x0052
            int r6 = r4.getMnc()
            if (r6 != r8) goto L_0x0052
            java.lang.String r6 = r4.getMccString()
            boolean r6 = r2.equals(r6)
            if (r6 == 0) goto L_0x0052
            java.lang.String r4 = r4.getMncString()
            boolean r4 = r1.equals(r4)
            if (r4 != 0) goto L_0x0051
            goto L_0x0052
        L_0x0051:
            r5 = r0
        L_0x0052:
            if (r5 == 0) goto L_0x00b0
            android.content.ContentValues r0 = new android.content.ContentValues
            r4 = 4
            r0.<init>(r4)
            java.lang.Integer r4 = java.lang.Integer.valueOf(r3)
            java.lang.String r5 = "mcc"
            r0.put(r5, r4)
            java.lang.Integer r4 = java.lang.Integer.valueOf(r8)
            java.lang.String r5 = "mnc"
            r0.put(r5, r4)
            java.lang.String r4 = "mcc_string"
            r0.put(r4, r2)
            java.lang.String r2 = "mnc_string"
            r0.put(r2, r1)
            android.content.Context r1 = r7.mContext
            android.content.ContentResolver r1 = r1.getContentResolver()
            android.net.Uri r2 = android.telephony.SubscriptionManager.getUriForSubscriptionId(r9)
            r4 = 0
            int r0 = r1.update(r2, r0, r4, r4)
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "[setMccMnc]+ mcc/mnc:"
            r1.append(r2)
            r1.append(r3)
            java.lang.String r2 = "/"
            r1.append(r2)
            r1.append(r8)
            java.lang.String r8 = " subId:"
            r1.append(r8)
            r1.append(r9)
            java.lang.String r8 = r1.toString()
            r7.logd(r8)
            r7.refreshCachedActiveSubscriptionInfoList()
            r7.notifySubscriptionInfoChanged()
            goto L_0x00b5
        L_0x00b0:
            java.lang.String r8 = "[setMccMnc] - no values update"
            r7.logd(r8)
        L_0x00b5:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.setMccMnc(java.lang.String, int):int");
    }

    private String scrubImsi(String str) {
        if (Build.IS_ENG) {
            return str;
        }
        if (str == null) {
            return "null";
        }
        return str.substring(0, Math.min(6, str.length())) + "...";
    }

    public int setImsi(String str, int i) {
        logd("[setImsi]+ imsi:" + scrubImsi(str) + " subId:" + i);
        if (getSubscriptionInfo(i) != null ? !TextUtils.equals(getImsiPrivileged(i), str) : true) {
            ContentValues contentValues = new ContentValues(1);
            contentValues.put("imsi", str);
            int update = this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i), contentValues, (String) null, (String[]) null);
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
            return update;
        }
        logd("[setImsi]: no value update");
        return 0;
    }

    public int setUiccApplicationsEnabled(boolean z, int i) {
        logd("[setUiccApplicationsEnabled]+ enabled:" + z + " subId:" + i);
        enforceModifyPhoneState("setUiccApplicationsEnabled");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            ContentValues contentValues = new ContentValues(1);
            contentValues.put("uicc_applications_enabled", Boolean.valueOf(z));
            int update = this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i), contentValues, (String) null, (String[]) null);
            refreshCachedActiveSubscriptionInfoList();
            notifyUiccAppsEnableChanged();
            notifySubscriptionInfoChanged();
            return update;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void registerForUiccAppsEnabled(Handler handler, int i, Object obj, boolean z) {
        this.mUiccAppsEnableChangeRegList.addUnique(handler, i, obj);
        if (z) {
            handler.obtainMessage(i, obj).sendToTarget();
        }
    }

    public void unregisterForUiccAppsEnabled(Handler handler) {
        this.mUiccAppsEnableChangeRegList.remove(handler);
    }

    private void notifyUiccAppsEnableChanged() {
        this.mUiccAppsEnableChangeRegList.notifyRegistrants();
    }

    public String getImsiPrivileged(int i) {
        Cursor query = this.mContext.getContentResolver().query(SubscriptionManager.CONTENT_URI, (String[]) null, InboundSmsHandler.SELECT_BY_ID, new String[]{String.valueOf(i)}, (String) null);
        String str = null;
        if (query != null) {
            try {
                if (query.moveToNext()) {
                    str = getOptionalStringFromCursor(query, "imsi", (String) null);
                }
            } catch (Throwable th) {
                th.addSuppressed(th);
            }
        } else {
            logd("getImsiPrivileged: failed to retrieve imsi.");
        }
        if (query != null) {
            query.close();
        }
        return str;
        throw th;
    }

    public int setCountryIso(String str, int i) {
        logd("[setCountryIso]+ iso:" + str + " subId:" + i);
        SubscriptionInfo subscriptionInfo = getSubscriptionInfo(i);
        boolean z = true;
        if (subscriptionInfo != null) {
            z = true ^ TextUtils.equals(subscriptionInfo.getCountryIso(), str);
        }
        if (z) {
            ContentValues contentValues = new ContentValues();
            contentValues.put("iso_country_code", str);
            int update = this.mContext.getContentResolver().update(SubscriptionManager.getUriForSubscriptionId(i), contentValues, (String) null, (String[]) null);
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
            return update;
        }
        logd("[setCountryIso]: no value update");
        return 0;
    }

    public int getSlotIndex(int i) {
        if (VDBG) {
            printStackTrace("[getSlotIndex] subId=" + i);
        }
        if (i == Integer.MAX_VALUE) {
            i = getDefaultSubId();
        }
        if (!SubscriptionManager.isValidSubscriptionId(i)) {
            logd("[getSlotIndex]- subId invalid");
            return -1;
        } else if (sSlotIndexToSubIds.size() == 0) {
            logd("[getSlotIndex]- size == 0, return SIM_NOT_INSERTED instead");
            return -1;
        } else {
            for (Map.Entry next : sSlotIndexToSubIds.entrySet()) {
                int intValue = ((Integer) next.getKey()).intValue();
                ArrayList arrayList = (ArrayList) next.getValue();
                if (arrayList != null && arrayList.contains(Integer.valueOf(i))) {
                    if (VDBG) {
                        logv("[getSlotIndex]- return = " + intValue);
                    }
                    return intValue;
                }
            }
            logd("[getSlotIndex]- return fail");
            return -1;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public int[] getSubId(int i) {
        boolean z = VDBG;
        if (z) {
            printStackTrace("[getSubId]+ slotIndex=" + i);
        }
        if (i == Integer.MAX_VALUE) {
            i = getSlotIndex(getDefaultSubId());
            if (z) {
                logd("[getSubId] map default slotIndex=" + i);
            }
        }
        if (!SubscriptionManager.isValidSlotIndex(i) && i != -1) {
            logd("[getSubId]- invalid slotIndex=" + i);
            return null;
        } else if (sSlotIndexToSubIds.size() == 0) {
            if (z) {
                logd("[getSubId]- sSlotIndexToSubIds.size == 0, return null slotIndex=" + i);
            }
            return null;
        } else {
            ArrayList<Integer> copy = sSlotIndexToSubIds.getCopy(i);
            if (copy == null || copy.size() <= 0) {
                logd("[getSubId]- numSubIds == 0, return null slotIndex=" + i);
                return null;
            }
            int[] iArr = new int[copy.size()];
            for (int i2 = 0; i2 < copy.size(); i2++) {
                iArr[i2] = copy.get(i2).intValue();
            }
            if (VDBG) {
                logd("[getSubId]- subIdArr=" + iArr);
            }
            return iArr;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getPhoneId(int i) {
        boolean z = VDBG;
        if (z) {
            printStackTrace("[getPhoneId] subId=" + i);
        }
        if (i == Integer.MAX_VALUE) {
            i = getDefaultSubId();
            logd("[getPhoneId] asked for default subId=" + i);
        }
        if (!SubscriptionManager.isValidSubscriptionId(i)) {
            if (!z) {
                return -1;
            }
            logdl("[getPhoneId]- invalid subId return=-1");
            return -1;
        } else if (sSlotIndexToSubIds.size() == 0) {
            int i2 = mDefaultPhoneId;
            if (z) {
                logdl("[getPhoneId]- no sims, returning default phoneId=" + i2);
            }
            return i2;
        } else {
            for (Map.Entry next : sSlotIndexToSubIds.entrySet()) {
                int intValue = ((Integer) next.getKey()).intValue();
                ArrayList arrayList = (ArrayList) next.getValue();
                if (arrayList != null && arrayList.contains(Integer.valueOf(i))) {
                    if (VDBG) {
                        logdl("[getPhoneId]- found subId=" + i + " phoneId=" + intValue);
                    }
                    return intValue;
                }
            }
            int i3 = mDefaultPhoneId;
            if (VDBG) {
                logd("[getPhoneId]- subId=" + i + " not found return default phoneId=" + i3);
            }
            return i3;
        }
    }

    public int clearSubInfo() {
        enforceModifyPhoneState("clearSubInfo");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            int size = sSlotIndexToSubIds.size();
            if (size == 0) {
                logdl("[clearSubInfo]- no simInfo size=" + size);
                return 0;
            }
            sSlotIndexToSubIds.clear();
            logdl("[clearSubInfo]- clear size=" + size);
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return size;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    private void logvl(String str) {
        logv(str);
        this.mLocalLog.log(str);
    }

    private void logv(String str) {
        Rlog.v(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void logdl(String str) {
        logd(str);
        this.mLocalLog.log(str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void logd(String str) {
        Rlog.d(LOG_TAG, str);
    }

    private void logel(String str) {
        loge(str);
        this.mLocalLog.log(str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getDefaultSubId() {
        int i;
        if (this.mTelephonyManager.isVoiceCapable()) {
            i = getDefaultVoiceSubId();
            if (VDBG) {
                logdl("[getDefaultSubId] isVoiceCapable subId=" + i);
            }
        } else {
            i = getDefaultDataSubId();
            if (VDBG) {
                logdl("[getDefaultSubId] NOT VoiceCapable subId=" + i);
            }
        }
        if (!isActiveSubId(i)) {
            i = sDefaultFallbackSubId.get();
            if (VDBG) {
                logdl("[getDefaultSubId] NOT active use fall back subId=" + i);
            }
        }
        if (VDBG) {
            logv("[getDefaultSubId]- value = " + i);
        }
        return i;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setDefaultSmsSubId(int i) {
        enforceModifyPhoneState("setDefaultSmsSubId");
        if (i != Integer.MAX_VALUE) {
            logdl("[setDefaultSmsSubId] subId=" + i);
            setGlobalSetting("multi_sim_sms", i);
            broadcastDefaultSmsSubIdChanged(i);
            return;
        }
        throw new RuntimeException("setDefaultSmsSubId called with DEFAULT_SUB_ID");
    }

    private void broadcastDefaultSmsSubIdChanged(int i) {
        logdl("[broadcastDefaultSmsSubIdChanged] subId=" + i);
        Intent intent = new Intent("android.telephony.action.DEFAULT_SMS_SUBSCRIPTION_CHANGED");
        intent.addFlags(NetworkStackConstants.NEIGHBOR_ADVERTISEMENT_FLAG_OVERRIDE);
        SubscriptionManager.putSubscriptionIdExtra(intent, i);
        this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getDefaultSmsSubId() {
        int i = Settings.Global.getInt(this.mContext.getContentResolver(), "multi_sim_sms", -1);
        if (VDBG) {
            logd("[getDefaultSmsSubId] subId=" + i);
        }
        return i;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setDefaultVoiceSubId(int i) {
        PhoneAccountHandle phoneAccountHandle;
        enforceModifyPhoneState("setDefaultVoiceSubId");
        if (i != Integer.MAX_VALUE) {
            logdl("[setDefaultVoiceSubId] subId=" + i);
            int defaultSubId = getDefaultSubId();
            setGlobalSetting("multi_sim_voice_call", i);
            broadcastDefaultVoiceSubIdChanged(i);
            if (i == -1) {
                phoneAccountHandle = null;
            } else {
                phoneAccountHandle = this.mTelephonyManager.getPhoneAccountHandleForSubscriptionId(i);
            }
            TelecomManager telecomManager = (TelecomManager) this.mContext.getSystemService(TelecomManager.class);
            PhoneAccountHandle userSelectedOutgoingPhoneAccount = telecomManager.getUserSelectedOutgoingPhoneAccount();
            logd("[setDefaultVoiceSubId] current phoneAccountHandle=" + userSelectedOutgoingPhoneAccount);
            if (!Objects.equals(userSelectedOutgoingPhoneAccount, phoneAccountHandle)) {
                telecomManager.setUserSelectedOutgoingPhoneAccount(phoneAccountHandle);
                logd("[setDefaultVoiceSubId] change to phoneAccountHandle=" + phoneAccountHandle);
            } else {
                logd("[setDefaultVoiceSubId] default phoneAccountHandle not changed.");
            }
            if (defaultSubId != getDefaultSubId()) {
                sendDefaultChangedBroadcast(getDefaultSubId());
                logd(String.format("[setDefaultVoiceSubId] change to subId=%d", new Object[]{Integer.valueOf(getDefaultSubId())}));
                return;
            }
            logd(String.format("[setDefaultVoiceSubId] default subId not changed. subId=%d", new Object[]{Integer.valueOf(defaultSubId)}));
            return;
        }
        throw new RuntimeException("setDefaultVoiceSubId called with DEFAULT_SUB_ID");
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void broadcastDefaultVoiceSubIdChanged(int i) {
        logdl("[broadcastDefaultVoiceSubIdChanged] subId=" + i);
        Intent intent = new Intent("android.intent.action.ACTION_DEFAULT_VOICE_SUBSCRIPTION_CHANGED");
        intent.addFlags(NetworkStackConstants.NEIGHBOR_ADVERTISEMENT_FLAG_OVERRIDE);
        SubscriptionManager.putSubscriptionIdExtra(intent, i);
        this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getDefaultVoiceSubId() {
        int i = Settings.Global.getInt(this.mContext.getContentResolver(), "multi_sim_voice_call", -1);
        if (VDBG) {
            logd("[getDefaultVoiceSubId] subId=" + i);
        }
        return i;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getDefaultDataSubId() {
        int i = Settings.Global.getInt(this.mContext.getContentResolver(), "multi_sim_data_call", -1);
        if (VDBG) {
            logd("[getDefaultDataSubId] subId=" + i);
        }
        return i;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setDefaultDataSubId(int i) {
        boolean z;
        int i2;
        enforceModifyPhoneState("setDefaultDataSubId");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        if (i != Integer.MAX_VALUE) {
            try {
                ProxyController instance = ProxyController.getInstance();
                int activeModemCount = TelephonyManager.from(this.mContext).getActiveModemCount();
                logdl("[setDefaultDataSubId] num phones=" + activeModemCount + ", subId=" + i);
                if (!Build.IS_USER) {
                    Thread.dumpStack();
                }
                if (instance != null && SubscriptionManager.isValidSubscriptionId(i)) {
                    RadioAccessFamily[] radioAccessFamilyArr = new RadioAccessFamily[activeModemCount];
                    int i3 = 0;
                    boolean z2 = false;
                    while (i3 < activeModemCount) {
                        int subId = PhoneFactory.getPhone(i3).getSubId();
                        if (subId == i) {
                            i2 = instance.getMaxRafSupported();
                            z = true;
                        } else {
                            z = z2;
                            i2 = instance.getMinRafSupported();
                        }
                        logdl("[setDefaultDataSubId] phoneId=" + i3 + " subId=" + subId + " RAF=" + i2);
                        radioAccessFamilyArr[i3] = new RadioAccessFamily(i3, i2);
                        i3++;
                        z2 = z;
                    }
                    if (z2) {
                        instance.setRadioCapability(radioAccessFamilyArr);
                    } else {
                        logdl("[setDefaultDataSubId] no valid subId's found - not updating.");
                    }
                }
                int defaultSubId = getDefaultSubId();
                setGlobalSetting("multi_sim_data_call", i);
                MultiSimSettingController.getInstance().notifyDefaultDataSubChanged();
                broadcastDefaultDataSubIdChanged(i);
                if (defaultSubId != getDefaultSubId()) {
                    sendDefaultChangedBroadcast(getDefaultSubId());
                }
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new RuntimeException("setDefaultDataSubId called with DEFAULT_SUB_ID");
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void broadcastDefaultDataSubIdChanged(int i) {
        logdl("[broadcastDefaultDataSubIdChanged] subId=" + i);
        Intent intent = new Intent("android.intent.action.ACTION_DEFAULT_DATA_SUBSCRIPTION_CHANGED");
        intent.addFlags(NetworkStackConstants.NEIGHBOR_ADVERTISEMENT_FLAG_OVERRIDE);
        SubscriptionManager.putSubscriptionIdExtra(intent, i);
        this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setDefaultFallbackSubId(int i, int i2) {
        if (i != Integer.MAX_VALUE) {
            logdl("[setDefaultFallbackSubId] subId=" + i + ", subscriptionType=" + i2);
            int defaultSubId = getDefaultSubId();
            if (isSubscriptionForRemoteSim(i2)) {
                sDefaultFallbackSubId.set(i);
                return;
            }
            if (SubscriptionManager.isValidSubscriptionId(i)) {
                int phoneId = getPhoneId(i);
                if (phoneId < 0 || (phoneId >= this.mTelephonyManager.getPhoneCount() && this.mTelephonyManager.getSimCount() != 1)) {
                    logdl("[setDefaultFallbackSubId] not set invalid phoneId=" + phoneId + " subId=" + i);
                } else {
                    logdl("[setDefaultFallbackSubId] set sDefaultFallbackSubId=" + i);
                    sDefaultFallbackSubId.set(i);
                    MccTable.updateMccMncConfiguration(this.mContext, this.mTelephonyManager.getSimOperatorNumericForPhone(phoneId));
                }
            }
            if (defaultSubId != getDefaultSubId()) {
                sendDefaultChangedBroadcast(getDefaultSubId());
                return;
            }
            return;
        }
        throw new RuntimeException("setDefaultSubId called with DEFAULT_SUB_ID");
    }

    public void sendDefaultChangedBroadcast(int i) {
        int phoneId = SubscriptionManager.getPhoneId(i);
        Intent intent = new Intent("android.telephony.action.DEFAULT_SUBSCRIPTION_CHANGED");
        intent.addFlags(NetworkStackConstants.NEIGHBOR_ADVERTISEMENT_FLAG_OVERRIDE);
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, phoneId, i);
        logdl("[sendDefaultChangedBroadcast] broadcast default subId changed phoneId=" + phoneId + " subId=" + i);
        this.mContext.sendStickyBroadcastAsUser(intent, UserHandle.ALL);
    }

    public boolean isOpportunistic(int i) {
        SubscriptionInfo activeSubscriptionInfo = getActiveSubscriptionInfo(i, this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
        return activeSubscriptionInfo != null && activeSubscriptionInfo.isOpportunistic();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getSubIdUsingPhoneId(int i) {
        int[] subId = getSubId(i);
        if (subId == null || subId.length == 0) {
            return -1;
        }
        return subId[0];
    }

    @VisibleForTesting
    public List<SubscriptionInfo> getSubInfoUsingSlotIndexPrivileged(int i) {
        logd("[getSubInfoUsingSlotIndexPrivileged]+ slotIndex:" + i);
        if (i == Integer.MAX_VALUE) {
            i = getSlotIndex(getDefaultSubId());
        }
        ArrayList arrayList = null;
        if (!SubscriptionManager.isValidSlotIndex(i)) {
            logd("[getSubInfoUsingSlotIndexPrivileged]- invalid slotIndex");
            return null;
        }
        Cursor query = this.mContext.getContentResolver().query(SubscriptionManager.CONTENT_URI, (String[]) null, "sim_id=?", new String[]{String.valueOf(i)}, (String) null);
        if (query != null) {
            while (query.moveToNext()) {
                try {
                    SubscriptionInfo subInfoRecord = getSubInfoRecord(query);
                    if (subInfoRecord != null) {
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                        }
                        arrayList.add(subInfoRecord);
                    }
                } catch (Throwable th) {
                    query.close();
                    throw th;
                }
            }
        }
        if (query != null) {
            query.close();
        }
        logd("[getSubInfoUsingSlotIndex]- null info return");
        return arrayList;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void validateSubId(int i) {
        logd("validateSubId subId: " + i);
        if (!SubscriptionManager.isValidSubscriptionId(i)) {
            throw new IllegalArgumentException("Invalid sub id passed as parameter");
        } else if (i == Integer.MAX_VALUE) {
            throw new IllegalArgumentException("Default sub id passed as parameter");
        }
    }

    private synchronized ArrayList<Integer> getActiveSubIdArrayList() {
        ArrayList<Integer> arrayList;
        ArrayList<Map.Entry> arrayList2 = new ArrayList<>(sSlotIndexToSubIds.entrySet());
        Collections.sort(arrayList2, new SubscriptionController$$ExternalSyntheticLambda3());
        arrayList = new ArrayList<>();
        for (Map.Entry value : arrayList2) {
            arrayList.addAll((Collection) value.getValue());
        }
        return arrayList;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:13:0x0025, code lost:
        return r2;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean isSubscriptionVisible(int r5) {
        /*
            r4 = this;
            java.lang.Object r0 = r4.mSubInfoListLock
            monitor-enter(r0)
            java.util.List<android.telephony.SubscriptionInfo> r4 = r4.mCacheOpportunisticSubInfoList     // Catch:{ all -> 0x0028 }
            java.util.Iterator r4 = r4.iterator()     // Catch:{ all -> 0x0028 }
        L_0x0009:
            boolean r1 = r4.hasNext()     // Catch:{ all -> 0x0028 }
            r2 = 1
            if (r1 == 0) goto L_0x0026
            java.lang.Object r1 = r4.next()     // Catch:{ all -> 0x0028 }
            android.telephony.SubscriptionInfo r1 = (android.telephony.SubscriptionInfo) r1     // Catch:{ all -> 0x0028 }
            int r3 = r1.getSubscriptionId()     // Catch:{ all -> 0x0028 }
            if (r3 != r5) goto L_0x0009
            android.os.ParcelUuid r4 = r1.getGroupUuid()     // Catch:{ all -> 0x0028 }
            if (r4 != 0) goto L_0x0023
            goto L_0x0024
        L_0x0023:
            r2 = 0
        L_0x0024:
            monitor-exit(r0)     // Catch:{ all -> 0x0028 }
            return r2
        L_0x0026:
            monitor-exit(r0)     // Catch:{ all -> 0x0028 }
            return r2
        L_0x0028:
            r4 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0028 }
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.isSubscriptionVisible(int):boolean");
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r8v5, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v5, resolved type: java.util.List} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int[] getActiveSubIdList(boolean r8) {
        /*
            r7 = this;
            java.lang.String r0 = "getActiveSubIdList"
            r7.enforceReadPrivilegedPhoneState(r0)
            long r0 = android.os.Binder.clearCallingIdentity()
            java.util.ArrayList r2 = r7.getActiveSubIdArrayList()     // Catch:{ all -> 0x006b }
            if (r8 == 0) goto L_0x0027
            java.util.stream.Stream r8 = r2.stream()     // Catch:{ all -> 0x006b }
            com.android.internal.telephony.SubscriptionController$$ExternalSyntheticLambda7 r2 = new com.android.internal.telephony.SubscriptionController$$ExternalSyntheticLambda7     // Catch:{ all -> 0x006b }
            r2.<init>(r7)     // Catch:{ all -> 0x006b }
            java.util.stream.Stream r8 = r8.filter(r2)     // Catch:{ all -> 0x006b }
            java.util.stream.Collector r2 = java.util.stream.Collectors.toList()     // Catch:{ all -> 0x006b }
            java.lang.Object r8 = r8.collect(r2)     // Catch:{ all -> 0x006b }
            r2 = r8
            java.util.List r2 = (java.util.List) r2     // Catch:{ all -> 0x006b }
        L_0x0027:
            int r8 = r2.size()     // Catch:{ all -> 0x006b }
            int[] r3 = new int[r8]     // Catch:{ all -> 0x006b }
            r4 = 0
            java.util.Iterator r5 = r2.iterator()     // Catch:{ all -> 0x006b }
        L_0x0032:
            boolean r6 = r5.hasNext()     // Catch:{ all -> 0x006b }
            if (r6 == 0) goto L_0x0047
            java.lang.Object r6 = r5.next()     // Catch:{ all -> 0x006b }
            java.lang.Integer r6 = (java.lang.Integer) r6     // Catch:{ all -> 0x006b }
            int r6 = r6.intValue()     // Catch:{ all -> 0x006b }
            r3[r4] = r6     // Catch:{ all -> 0x006b }
            int r4 = r4 + 1
            goto L_0x0032
        L_0x0047:
            boolean r4 = VDBG     // Catch:{ all -> 0x006b }
            if (r4 == 0) goto L_0x0067
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x006b }
            r4.<init>()     // Catch:{ all -> 0x006b }
            java.lang.String r5 = "[getActiveSubIdList] allSubs="
            r4.append(r5)     // Catch:{ all -> 0x006b }
            r4.append(r2)     // Catch:{ all -> 0x006b }
            java.lang.String r2 = " subIdArr.length="
            r4.append(r2)     // Catch:{ all -> 0x006b }
            r4.append(r8)     // Catch:{ all -> 0x006b }
            java.lang.String r8 = r4.toString()     // Catch:{ all -> 0x006b }
            r7.logdl(r8)     // Catch:{ all -> 0x006b }
        L_0x0067:
            android.os.Binder.restoreCallingIdentity(r0)
            return r3
        L_0x006b:
            r7 = move-exception
            android.os.Binder.restoreCallingIdentity(r0)
            throw r7
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.getActiveSubIdList(boolean):int[]");
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$getActiveSubIdList$6(Integer num) {
        return isSubscriptionVisible(num.intValue());
    }

    public boolean isActiveSubId(int i, String str, String str2) {
        if (TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, i, str, str2, "isActiveSubId")) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                return isActiveSubId(i);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("Requires READ_PHONE_STATE permission.");
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public boolean isActiveSubId(int i) {
        boolean z = SubscriptionManager.isValidSubscriptionId(i) && getActiveSubIdArrayList().contains(Integer.valueOf(i));
        if (VDBG) {
            logdl("[isActiveSubId]- " + z);
        }
        return z;
    }

    public int getSimStateForSlotIndex(int i) {
        String str;
        IccCardConstants.State state;
        if (i < 0) {
            state = IccCardConstants.State.UNKNOWN;
            str = "invalid slotIndex";
        } else {
            Phone phone = null;
            try {
                phone = PhoneFactory.getPhone(i);
            } catch (IllegalStateException unused) {
            }
            if (phone == null) {
                state = IccCardConstants.State.UNKNOWN;
                str = "phone == null";
            } else {
                IccCard iccCard = phone.getIccCard();
                if (iccCard == null) {
                    state = IccCardConstants.State.UNKNOWN;
                    str = "icc == null";
                } else {
                    state = iccCard.getState();
                    str = "";
                }
            }
        }
        if (VDBG) {
            logd("getSimStateForSlotIndex: " + str + " simState=" + state + " ordinal=" + state.ordinal() + " slotIndex=" + i);
        }
        return state.ordinal();
    }

    public int setSubscriptionProperty(int i, String str, String str2) {
        enforceModifyPhoneState("setSubscriptionProperty");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            validateSubId(i);
            int subscriptionPropertyIntoContentResolver = setSubscriptionPropertyIntoContentResolver(i, str, str2, this.mContext.getContentResolver());
            refreshCachedActiveSubscriptionInfoList();
            return subscriptionPropertyIntoContentResolver;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* access modifiers changed from: protected */
    public int setSubscriptionPropertyIntoContentResolver(int i, String str, String str2, ContentResolver contentResolver) {
        ContentValues contentValues = new ContentValues();
        boolean contains = GROUP_SHARING_PROPERTIES.contains(str);
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case -2000412720:
                if (str.equals("enable_alert_vibrate")) {
                    c = 0;
                    break;
                }
                break;
            case -1958907444:
                if (str.equals("ims_rcs_uce_enabled")) {
                    c = 1;
                    break;
                }
                break;
            case -1950380197:
                if (str.equals("volte_vt_enabled")) {
                    c = 2;
                    break;
                }
                break;
            case -1819373132:
                if (str.equals("is_opportunistic")) {
                    c = 3;
                    break;
                }
                break;
            case -1555340190:
                if (str.equals("enable_cmas_extreme_threat_alerts")) {
                    c = 4;
                    break;
                }
                break;
            case -1489974588:
                if (str.equals("nr_advanced_calling_enabled")) {
                    c = 5;
                    break;
                }
                break;
            case -1433878403:
                if (str.equals("enable_cmas_test_alerts")) {
                    c = 6;
                    break;
                }
                break;
            case -1395523150:
                if (str.equals("usage_setting")) {
                    c = 7;
                    break;
                }
                break;
            case -1390801311:
                if (str.equals("enable_alert_speech")) {
                    c = 8;
                    break;
                }
                break;
            case -1383812487:
                if (str.equals("phone_number_source_carrier")) {
                    c = 9;
                    break;
                }
                break;
            case -1339240225:
                if (str.equals("cross_sim_calling_enabled")) {
                    c = 10;
                    break;
                }
                break;
            case -1218173306:
                if (str.equals("wfc_ims_enabled")) {
                    c = 11;
                    break;
                }
                break;
            case -461686719:
                if (str.equals("enable_emergency_alerts")) {
                    c = 12;
                    break;
                }
                break;
            case -420099376:
                if (str.equals("vt_ims_enabled")) {
                    c = 13;
                    break;
                }
                break;
            case -349439993:
                if (str.equals("alert_sound_duration")) {
                    c = 14;
                    break;
                }
                break;
            case 180938212:
                if (str.equals("wfc_ims_roaming_mode")) {
                    c = 15;
                    break;
                }
                break;
            case 203677434:
                if (str.equals("enable_cmas_amber_alerts")) {
                    c = 16;
                    break;
                }
                break;
            case 240841894:
                if (str.equals("show_cmas_opt_out_dialog")) {
                    c = 17;
                    break;
                }
                break;
            case 407275608:
                if (str.equals("enable_cmas_severe_threat_alerts")) {
                    c = 18;
                    break;
                }
                break;
            case 410371787:
                if (str.equals("allowed_network_types_for_reasons")) {
                    c = 19;
                    break;
                }
                break;
            case 462555599:
                if (str.equals("alert_reminder_interval")) {
                    c = 20;
                    break;
                }
                break;
            case 501936055:
                if (str.equals("voims_opt_in_status")) {
                    c = 21;
                    break;
                }
                break;
            case 799757264:
                if (str.equals("phone_number_source_ims")) {
                    c = 22;
                    break;
                }
                break;
            case 1270593452:
                if (str.equals("enable_etws_test_alerts")) {
                    c = 23;
                    break;
                }
                break;
            case 1288054979:
                if (str.equals("enable_channel_50_alerts")) {
                    c = 24;
                    break;
                }
                break;
            case 1334635646:
                if (str.equals("wfc_ims_mode")) {
                    c = 25;
                    break;
                }
                break;
            case 1604840288:
                if (str.equals("wfc_ims_roaming_enabled")) {
                    c = 26;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 20:
            case 21:
            case 23:
            case 24:
            case 25:
            case 26:
                contentValues.put(str, Integer.valueOf(Integer.parseInt(str2)));
                break;
            case 9:
            case 19:
            case 22:
                contentValues.put(str, str2);
                break;
            default:
                logd("Invalid column name");
                break;
        }
        return updateDatabase(contentValues, i, contains);
    }

    public String getSubscriptionProperty(int i, String str, String str2, String str3) {
        str.hashCode();
        if (!str.equals("group_uuid")) {
            if (!TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, i, str2, str3, "getSubscriptionProperty")) {
                return null;
            }
        } else if (this.mContext.checkCallingOrSelfPermission("android.permission.READ_PRIVILEGED_PHONE_STATE") != 0) {
            EventLog.writeEvent(1397638484, new Object[]{"213457638", Integer.valueOf(Binder.getCallingUid())});
            return null;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            return getSubscriptionProperty(i, str);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* JADX WARNING: Code restructure failed: missing block: B:101:0x01a8, code lost:
        r0 = 65535;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:102:0x01a9, code lost:
        switch(r0) {
            case 0: goto L_0x01af;
            case 1: goto L_0x01af;
            case 2: goto L_0x01af;
            case 3: goto L_0x01af;
            case 4: goto L_0x01af;
            case 5: goto L_0x01af;
            case 6: goto L_0x01af;
            case 7: goto L_0x01af;
            case 8: goto L_0x01af;
            case 9: goto L_0x01af;
            case 10: goto L_0x01af;
            case 11: goto L_0x01af;
            case 12: goto L_0x01af;
            case 13: goto L_0x01af;
            case 14: goto L_0x01af;
            case 15: goto L_0x01af;
            case 16: goto L_0x01af;
            case 17: goto L_0x01af;
            case 18: goto L_0x01af;
            case 19: goto L_0x01af;
            case 20: goto L_0x01af;
            case 21: goto L_0x01af;
            case 22: goto L_0x01af;
            case 23: goto L_0x01af;
            case 24: goto L_0x01af;
            case 25: goto L_0x01af;
            case 26: goto L_0x01af;
            case 27: goto L_0x01af;
            case 28: goto L_0x01af;
            case 29: goto L_0x01af;
            case 30: goto L_0x01af;
            default: goto L_0x01ac;
        };
     */
    /* JADX WARNING: Code restructure failed: missing block: B:104:0x01af, code lost:
        r1 = r9.getString(0);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:105:0x01b5, code lost:
        logd("Invalid column name");
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.lang.String getSubscriptionProperty(int r9, java.lang.String r10) {
        /*
            r8 = this;
            android.content.Context r0 = r8.mContext
            android.content.ContentResolver r1 = r0.getContentResolver()
            android.net.Uri r2 = android.telephony.SubscriptionManager.CONTENT_URI
            r0 = 1
            java.lang.String[] r3 = new java.lang.String[r0]
            r7 = 0
            r3[r7] = r10
            java.lang.String[] r5 = new java.lang.String[r0]
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            r4.append(r9)
            java.lang.String r9 = ""
            r4.append(r9)
            java.lang.String r9 = r4.toString()
            r5[r7] = r9
            java.lang.String r4 = "_id=?"
            r6 = 0
            android.database.Cursor r9 = r1.query(r2, r3, r4, r5, r6)
            r1 = 0
            if (r9 == 0) goto L_0x01bf
            boolean r2 = r9.moveToFirst()     // Catch:{ all -> 0x01de }
            if (r2 == 0) goto L_0x01b9
            r2 = -1
            int r3 = r10.hashCode()     // Catch:{ all -> 0x01de }
            switch(r3) {
                case -2000412720: goto L_0x019e;
                case -1958907444: goto L_0x0193;
                case -1950380197: goto L_0x0187;
                case -1819373132: goto L_0x017c;
                case -1555340190: goto L_0x0172;
                case -1489974588: goto L_0x0167;
                case -1433878403: goto L_0x015c;
                case -1395523150: goto L_0x0150;
                case -1390801311: goto L_0x0146;
                case -1383812487: goto L_0x013a;
                case -1339240225: goto L_0x012e;
                case -1292749250: goto L_0x0122;
                case -1218173306: goto L_0x0115;
                case -461686719: goto L_0x010a;
                case -420099376: goto L_0x00fd;
                case -349439993: goto L_0x00f2;
                case 180938212: goto L_0x00e5;
                case 203677434: goto L_0x00da;
                case 240841894: goto L_0x00cd;
                case 407275608: goto L_0x00c3;
                case 410371787: goto L_0x00b7;
                case 462555599: goto L_0x00ac;
                case 501936055: goto L_0x009f;
                case 512460727: goto L_0x0093;
                case 799757264: goto L_0x0087;
                case 1270593452: goto L_0x007b;
                case 1282534779: goto L_0x006f;
                case 1288054979: goto L_0x0063;
                case 1322345375: goto L_0x0057;
                case 1334635646: goto L_0x004a;
                case 1604840288: goto L_0x003d;
                default: goto L_0x003b;
            }     // Catch:{ all -> 0x01de }
        L_0x003b:
            goto L_0x01a8
        L_0x003d:
            java.lang.String r0 = "wfc_ims_roaming_enabled"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 17
            goto L_0x01a9
        L_0x004a:
            java.lang.String r0 = "wfc_ims_mode"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 15
            goto L_0x01a9
        L_0x0057:
            java.lang.String r0 = "d2d_sharing_contacts"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 26
            goto L_0x01a9
        L_0x0063:
            java.lang.String r0 = "enable_channel_50_alerts"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 9
            goto L_0x01a9
        L_0x006f:
            java.lang.String r0 = "group_uuid"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 21
            goto L_0x01a9
        L_0x007b:
            java.lang.String r0 = "enable_etws_test_alerts"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 8
            goto L_0x01a9
        L_0x0087:
            java.lang.String r0 = "phone_number_source_ims"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 29
            goto L_0x01a9
        L_0x0093:
            java.lang.String r0 = "data_enabled_override_rules"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 22
            goto L_0x01a9
        L_0x009f:
            java.lang.String r0 = "voims_opt_in_status"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 25
            goto L_0x01a9
        L_0x00ac:
            java.lang.String r0 = "alert_reminder_interval"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 5
            goto L_0x01a9
        L_0x00b7:
            java.lang.String r0 = "allowed_network_types_for_reasons"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 23
            goto L_0x01a9
        L_0x00c3:
            java.lang.String r3 = "enable_cmas_severe_threat_alerts"
            boolean r10 = r10.equals(r3)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            goto L_0x01a9
        L_0x00cd:
            java.lang.String r0 = "show_cmas_opt_out_dialog"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 11
            goto L_0x01a9
        L_0x00da:
            java.lang.String r0 = "enable_cmas_amber_alerts"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 2
            goto L_0x01a9
        L_0x00e5:
            java.lang.String r0 = "wfc_ims_roaming_mode"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 16
            goto L_0x01a9
        L_0x00f2:
            java.lang.String r0 = "alert_sound_duration"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 4
            goto L_0x01a9
        L_0x00fd:
            java.lang.String r0 = "vt_ims_enabled"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 13
            goto L_0x01a9
        L_0x010a:
            java.lang.String r0 = "enable_emergency_alerts"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 3
            goto L_0x01a9
        L_0x0115:
            java.lang.String r0 = "wfc_ims_enabled"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 14
            goto L_0x01a9
        L_0x0122:
            java.lang.String r0 = "d2d_sharing_status"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 24
            goto L_0x01a9
        L_0x012e:
            java.lang.String r0 = "cross_sim_calling_enabled"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 19
            goto L_0x01a9
        L_0x013a:
            java.lang.String r0 = "phone_number_source_carrier"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 28
            goto L_0x01a9
        L_0x0146:
            java.lang.String r0 = "enable_alert_speech"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 7
            goto L_0x01a9
        L_0x0150:
            java.lang.String r0 = "usage_setting"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 30
            goto L_0x01a9
        L_0x015c:
            java.lang.String r0 = "enable_cmas_test_alerts"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 10
            goto L_0x01a9
        L_0x0167:
            java.lang.String r0 = "nr_advanced_calling_enabled"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 27
            goto L_0x01a9
        L_0x0172:
            java.lang.String r0 = "enable_cmas_extreme_threat_alerts"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = r7
            goto L_0x01a9
        L_0x017c:
            java.lang.String r0 = "is_opportunistic"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 20
            goto L_0x01a9
        L_0x0187:
            java.lang.String r0 = "volte_vt_enabled"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 12
            goto L_0x01a9
        L_0x0193:
            java.lang.String r0 = "ims_rcs_uce_enabled"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 18
            goto L_0x01a9
        L_0x019e:
            java.lang.String r0 = "enable_alert_vibrate"
            boolean r10 = r10.equals(r0)     // Catch:{ all -> 0x01de }
            if (r10 == 0) goto L_0x01a8
            r0 = 6
            goto L_0x01a9
        L_0x01a8:
            r0 = r2
        L_0x01a9:
            switch(r0) {
                case 0: goto L_0x01af;
                case 1: goto L_0x01af;
                case 2: goto L_0x01af;
                case 3: goto L_0x01af;
                case 4: goto L_0x01af;
                case 5: goto L_0x01af;
                case 6: goto L_0x01af;
                case 7: goto L_0x01af;
                case 8: goto L_0x01af;
                case 9: goto L_0x01af;
                case 10: goto L_0x01af;
                case 11: goto L_0x01af;
                case 12: goto L_0x01af;
                case 13: goto L_0x01af;
                case 14: goto L_0x01af;
                case 15: goto L_0x01af;
                case 16: goto L_0x01af;
                case 17: goto L_0x01af;
                case 18: goto L_0x01af;
                case 19: goto L_0x01af;
                case 20: goto L_0x01af;
                case 21: goto L_0x01af;
                case 22: goto L_0x01af;
                case 23: goto L_0x01af;
                case 24: goto L_0x01af;
                case 25: goto L_0x01af;
                case 26: goto L_0x01af;
                case 27: goto L_0x01af;
                case 28: goto L_0x01af;
                case 29: goto L_0x01af;
                case 30: goto L_0x01af;
                default: goto L_0x01ac;
            }     // Catch:{ all -> 0x01de }
        L_0x01ac:
            java.lang.String r10 = "Invalid column name"
            goto L_0x01b5
        L_0x01af:
            java.lang.String r10 = r9.getString(r7)     // Catch:{ all -> 0x01de }
            r1 = r10
            goto L_0x01c4
        L_0x01b5:
            r8.logd(r10)     // Catch:{ all -> 0x01de }
            goto L_0x01c4
        L_0x01b9:
            java.lang.String r10 = "Valid row not present in db"
            r8.logd(r10)     // Catch:{ all -> 0x01de }
            goto L_0x01c4
        L_0x01bf:
            java.lang.String r10 = "Query failed"
            r8.logd(r10)     // Catch:{ all -> 0x01de }
        L_0x01c4:
            if (r9 == 0) goto L_0x01c9
            r9.close()
        L_0x01c9:
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r10 = "getSubscriptionProperty Query value = "
            r9.append(r10)
            r9.append(r1)
            java.lang.String r9 = r9.toString()
            r8.logd(r9)
            return r1
        L_0x01de:
            r8 = move-exception
            if (r9 == 0) goto L_0x01e9
            r9.close()     // Catch:{ all -> 0x01e5 }
            goto L_0x01e9
        L_0x01e5:
            r9 = move-exception
            r8.addSuppressed(r9)
        L_0x01e9:
            throw r8
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.getSubscriptionProperty(int, java.lang.String):java.lang.String");
    }

    private void printStackTrace(String str) {
        RuntimeException runtimeException = new RuntimeException();
        logd("StackTrace - " + str);
        boolean z = true;
        for (StackTraceElement stackTraceElement : runtimeException.getStackTrace()) {
            if (z) {
                z = false;
            } else {
                logd(stackTraceElement.toString());
            }
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.DUMP", "Requires DUMP");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            printWriter.println("SubscriptionController:");
            printWriter.println(" mLastISubServiceRegTime=" + this.mLastISubServiceRegTime);
            printWriter.println(" defaultSubId=" + getDefaultSubId());
            printWriter.println(" defaultDataSubId=" + getDefaultDataSubId());
            printWriter.println(" defaultVoiceSubId=" + getDefaultVoiceSubId());
            printWriter.println(" defaultSmsSubId=" + getDefaultSmsSubId());
            printWriter.println(" defaultDataPhoneId=" + SubscriptionManager.from(this.mContext).getDefaultDataPhoneId());
            printWriter.println(" defaultVoicePhoneId=" + SubscriptionManager.getDefaultVoicePhoneId());
            printWriter.println(" defaultSmsPhoneId=" + SubscriptionManager.from(this.mContext).getDefaultSmsPhoneId());
            printWriter.flush();
            for (Map.Entry next : sSlotIndexToSubIds.entrySet()) {
                printWriter.println(" sSlotIndexToSubId[" + next.getKey() + "]: subIds=" + next);
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
            List<SubscriptionInfo> activeSubscriptionInfoList = getActiveSubscriptionInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
            if (activeSubscriptionInfoList != null) {
                printWriter.println(" ActiveSubInfoList:");
                for (SubscriptionInfo subscriptionInfo : activeSubscriptionInfoList) {
                    printWriter.println("  " + subscriptionInfo.toString());
                }
            } else {
                printWriter.println(" ActiveSubInfoList: is null");
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
            List<SubscriptionInfo> allSubInfoList = getAllSubInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag());
            if (allSubInfoList != null) {
                printWriter.println(" AllSubInfoList:");
                for (SubscriptionInfo subscriptionInfo2 : allSubInfoList) {
                    printWriter.println("  " + subscriptionInfo2.toString());
                }
            } else {
                printWriter.println(" AllSubInfoList: is null");
            }
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
            this.mLocalLog.dump(fileDescriptor, printWriter, strArr);
            printWriter.flush();
            printWriter.println("++++++++++++++++++++++++++++++++");
            printWriter.flush();
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void migrateImsSettings() {
        migrateImsSettingHelper("volte_vt_enabled", "volte_vt_enabled");
        migrateImsSettingHelper("vt_ims_enabled", "vt_ims_enabled");
        migrateImsSettingHelper("wfc_ims_enabled", "wfc_ims_enabled");
        migrateImsSettingHelper("wfc_ims_mode", "wfc_ims_mode");
        migrateImsSettingHelper("wfc_ims_roaming_mode", "wfc_ims_roaming_mode");
        migrateImsSettingHelper("wfc_ims_roaming_enabled", "wfc_ims_roaming_enabled");
    }

    private void migrateImsSettingHelper(String str, String str2) {
        ContentResolver contentResolver = this.mContext.getContentResolver();
        int defaultVoiceSubId = getDefaultVoiceSubId();
        if (defaultVoiceSubId != -1) {
            try {
                int i = Settings.Global.getInt(contentResolver, str);
                if (i != -1) {
                    setSubscriptionPropertyIntoContentResolver(defaultVoiceSubId, str2, Integer.toString(i), contentResolver);
                    Settings.Global.putInt(contentResolver, str, -1);
                }
            } catch (Settings.SettingNotFoundException unused) {
            }
        }
    }

    public int setOpportunistic(boolean z, int i, String str) {
        try {
            TelephonyPermissions.enforceCallingOrSelfModifyPermissionOrCarrierPrivilege(this.mContext, i, str);
        } catch (SecurityException unused) {
            enforceCarrierPrivilegeOnInactiveSub(i, str, "Caller requires permission on sub " + i);
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            int subscriptionProperty = setSubscriptionProperty(i, "is_opportunistic", String.valueOf(z ? 1 : 0));
            if (subscriptionProperty != 0) {
                notifySubscriptionInfoChanged();
            }
            return subscriptionProperty;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    private void enforceCarrierPrivilegeOnInactiveSub(int i, String str, String str2) {
        this.mAppOps.checkPackage(Binder.getCallingUid(), str);
        SubscriptionManager subscriptionManager = (SubscriptionManager) this.mContext.getSystemService("telephony_subscription_service");
        List<SubscriptionInfo> subInfo = getSubInfo("_id=" + i, (Object) null);
        try {
            if (isActiveSubId(i) || subInfo == null || subInfo.size() != 1 || !subscriptionManager.canManageSubscription(subInfo.get(0), str)) {
                throw new SecurityException(str2);
            }
        } catch (IllegalArgumentException unused) {
            throw new SecurityException(str2);
        }
    }

    public void setPreferredDataSubscriptionId(int i, boolean z, ISetOpportunisticDataCallback iSetOpportunisticDataCallback) {
        enforceModifyPhoneState("setPreferredDataSubscriptionId");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            PhoneSwitcher instance = PhoneSwitcher.getInstance();
            if (instance == null) {
                logd("Set preferred data sub: phoneSwitcher is null.");
                AnomalyReporter.reportAnomaly(UUID.fromString("a3ab0b9d-f2aa-4baf-911d-7096c0d4645a"), "Set preferred data sub: phoneSwitcher is null.");
                if (iSetOpportunisticDataCallback != null) {
                    iSetOpportunisticDataCallback.onComplete(4);
                }
                Binder.restoreCallingIdentity(clearCallingIdentity);
                return;
            }
            instance.trySetOpportunisticDataSubscription(i, z, iSetOpportunisticDataCallback);
            Binder.restoreCallingIdentity(clearCallingIdentity);
        } catch (RemoteException e) {
            logd("RemoteException " + e);
        } catch (Throwable th) {
            Binder.restoreCallingIdentity(clearCallingIdentity);
            throw th;
        }
    }

    public int getPreferredDataSubscriptionId() {
        enforceReadPrivilegedPhoneState("getPreferredDataSubscriptionId");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            PhoneSwitcher instance = PhoneSwitcher.getInstance();
            if (instance == null) {
                AnomalyReporter.reportAnomaly(UUID.fromString("a3ab0b9d-f2aa-4baf-911d-7096c0d4645a"), "Get preferred data sub: phoneSwitcher is null.");
                return Integer.MAX_VALUE;
            }
            int opportunisticDataSubscriptionId = instance.getOpportunisticDataSubscriptionId();
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return opportunisticDataSubscriptionId;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public List<SubscriptionInfo> getOpportunisticSubscriptions(String str, String str2) {
        return getSubscriptionInfoListFromCacheHelper(str, str2, makeCacheListCopyWithLock(this.mCacheOpportunisticSubInfoList));
    }

    public ParcelUuid createSubscriptionGroup(int[] iArr, String str) {
        if (iArr == null || iArr.length == 0) {
            throw new IllegalArgumentException("Invalid subIdList " + iArr);
        }
        this.mAppOps.checkPackage(Binder.getCallingUid(), str);
        if (this.mContext.checkCallingOrSelfPermission("android.permission.MODIFY_PHONE_STATE") == 0 || checkCarrierPrivilegeOnSubList(iArr, str)) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                ParcelUuid parcelUuid = new ParcelUuid(UUID.randomUUID());
                ContentValues contentValues = new ContentValues();
                contentValues.put("group_uuid", parcelUuid.toString());
                contentValues.put("group_owner", str);
                int update = this.mContext.getContentResolver().update(SubscriptionManager.CONTENT_URI, contentValues, getSelectionForSubIdList(iArr), (String[]) null);
                logdl("createSubscriptionGroup update DB result: " + update);
                refreshCachedActiveSubscriptionInfoList();
                notifySubscriptionInfoChanged();
                MultiSimSettingController.getInstance().notifySubscriptionGroupChanged(parcelUuid);
                return parcelUuid;
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("CreateSubscriptionGroup needs MODIFY_PHONE_STATE or carrier privilege permission on all specified subscriptions");
        }
    }

    private String getOwnerPackageOfSubGroup(ParcelUuid parcelUuid) {
        if (parcelUuid == null) {
            return null;
        }
        List<SubscriptionInfo> subInfo = getSubInfo("group_uuid='" + parcelUuid.toString() + "'", (Object) null);
        if (ArrayUtils.isEmpty(subInfo)) {
            return null;
        }
        return subInfo.get(0).getGroupOwner();
    }

    /* JADX INFO: finally extract failed */
    public boolean canPackageManageGroup(ParcelUuid parcelUuid, String str) {
        if (parcelUuid == null) {
            throw new IllegalArgumentException("Invalid groupUuid");
        } else if (!TextUtils.isEmpty(str)) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                List<SubscriptionInfo> subInfo = getSubInfo("group_uuid='" + parcelUuid.toString() + "'", (Object) null);
                Binder.restoreCallingIdentity(clearCallingIdentity);
                if (!ArrayUtils.isEmpty(subInfo) && !str.equals(subInfo.get(0).getGroupOwner())) {
                    return checkCarrierPrivilegeOnSubList(subInfo.stream().mapToInt(new SubscriptionController$$ExternalSyntheticLambda1()).toArray(), str);
                }
                return true;
            } catch (Throwable th) {
                Binder.restoreCallingIdentity(clearCallingIdentity);
                throw th;
            }
        } else {
            throw new IllegalArgumentException("Empty callingPackage");
        }
    }

    private int updateGroupOwner(ParcelUuid parcelUuid, String str) {
        ContentValues contentValues = new ContentValues(1);
        contentValues.put("group_owner", str);
        ContentResolver contentResolver = this.mContext.getContentResolver();
        Uri uri = SubscriptionManager.CONTENT_URI;
        return contentResolver.update(uri, contentValues, "group_uuid=\"" + parcelUuid + "\"", (String[]) null);
    }

    public void addSubscriptionsIntoGroup(int[] iArr, ParcelUuid parcelUuid, String str) {
        if (iArr == null || iArr.length == 0) {
            throw new IllegalArgumentException("Invalid subId list");
        } else if (parcelUuid == null || parcelUuid.equals(INVALID_GROUP_UUID)) {
            throw new IllegalArgumentException("Invalid groupUuid");
        } else {
            this.mAppOps.checkPackage(Binder.getCallingUid(), str);
            if (this.mContext.checkCallingOrSelfPermission("android.permission.MODIFY_PHONE_STATE") == 0 || (checkCarrierPrivilegeOnSubList(iArr, str) && canPackageManageGroup(parcelUuid, str))) {
                long clearCallingIdentity = Binder.clearCallingIdentity();
                try {
                    logdl("addSubscriptionsIntoGroup sub list " + Arrays.toString(iArr) + " into group " + parcelUuid);
                    ContentValues contentValues = new ContentValues();
                    contentValues.put("group_uuid", parcelUuid.toString());
                    int update = this.mContext.getContentResolver().update(SubscriptionManager.CONTENT_URI, contentValues, getSelectionForSubIdList(iArr), (String[]) null);
                    logdl("addSubscriptionsIntoGroup update DB result: " + update);
                    if (update > 0) {
                        updateGroupOwner(parcelUuid, str);
                        refreshCachedActiveSubscriptionInfoList();
                        notifySubscriptionInfoChanged();
                        MultiSimSettingController.getInstance().notifySubscriptionGroupChanged(parcelUuid);
                    }
                } finally {
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                }
            } else {
                throw new SecurityException("Requires MODIFY_PHONE_STATE or carrier privilege permissions on subscriptions and the group.");
            }
        }
    }

    public void removeSubscriptionsFromGroup(int[] iArr, ParcelUuid parcelUuid, String str) {
        if (iArr != null && iArr.length != 0) {
            this.mAppOps.checkPackage(Binder.getCallingUid(), str);
            if (this.mContext.checkCallingOrSelfPermission("android.permission.MODIFY_PHONE_STATE") == 0 || (checkCarrierPrivilegeOnSubList(iArr, str) && canPackageManageGroup(parcelUuid, str))) {
                long clearCallingIdentity = Binder.clearCallingIdentity();
                try {
                    for (SubscriptionInfo next : getSubInfo(getSelectionForSubIdList(iArr), (Object) null)) {
                        if (!parcelUuid.equals(next.getGroupUuid())) {
                            throw new IllegalArgumentException("Subscription " + next.getSubscriptionId() + " doesn't belong to group " + parcelUuid);
                        }
                    }
                    ContentValues contentValues = new ContentValues();
                    contentValues.put("group_uuid", (String) null);
                    contentValues.put("group_owner", (String) null);
                    int update = this.mContext.getContentResolver().update(SubscriptionManager.CONTENT_URI, contentValues, getSelectionForSubIdList(iArr), (String[]) null);
                    logdl("removeSubscriptionsFromGroup update DB result: " + update);
                    if (update > 0) {
                        updateGroupOwner(parcelUuid, str);
                        refreshCachedActiveSubscriptionInfoList();
                        notifySubscriptionInfoChanged();
                    }
                } finally {
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                }
            } else {
                throw new SecurityException("removeSubscriptionsFromGroup needs MODIFY_PHONE_STATE or carrier privilege permission on all specified subscriptions");
            }
        }
    }

    private boolean checkCarrierPrivilegeOnSubList(int[] iArr, String str) {
        HashSet hashSet = new HashSet();
        for (int i : iArr) {
            if (!isActiveSubId(i)) {
                hashSet.add(Integer.valueOf(i));
            } else if (!this.mTelephonyManager.hasCarrierPrivileges(i)) {
                return false;
            }
        }
        if (hashSet.isEmpty()) {
            return true;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            SubscriptionManager subscriptionManager = (SubscriptionManager) this.mContext.getSystemService("telephony_subscription_service");
            List<SubscriptionInfo> subInfo = getSubInfo(getSelectionForSubIdList(iArr), (Object) null);
            if (subInfo == null || subInfo.size() != iArr.length) {
                throw new IllegalArgumentException("Invalid subInfoList.");
            }
            for (SubscriptionInfo next : subInfo) {
                if (hashSet.contains(Integer.valueOf(next.getSubscriptionId()))) {
                    if (!next.isEmbedded() || !subscriptionManager.canManageSubscription(next, str)) {
                        return false;
                    }
                    hashSet.remove(Integer.valueOf(next.getSubscriptionId()));
                }
            }
            boolean isEmpty = hashSet.isEmpty();
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return isEmpty;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public static String getSelectionForSubIdList(int[] iArr) {
        StringBuilder sb = new StringBuilder();
        sb.append("_id");
        sb.append(" IN (");
        for (int i = 0; i < iArr.length - 1; i++) {
            sb.append(iArr[i] + ", ");
        }
        sb.append(iArr[iArr.length - 1]);
        sb.append(")");
        return sb.toString();
    }

    private String getSelectionForIccIdList(String[] strArr) {
        StringBuilder sb = new StringBuilder();
        sb.append("icc_id");
        sb.append(" IN (");
        for (int i = 0; i < strArr.length - 1; i++) {
            sb.append("'" + strArr[i] + "', ");
        }
        sb.append("'" + strArr[strArr.length - 1] + "'");
        sb.append(")");
        return sb.toString();
    }

    /* JADX INFO: finally extract failed */
    public List<SubscriptionInfo> getSubscriptionsInGroup(ParcelUuid parcelUuid, String str, String str2) {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            List<SubscriptionInfo> allSubInfoList = getAllSubInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag(), true);
            if (parcelUuid == null || allSubInfoList == null || allSubInfoList.isEmpty()) {
                ArrayList arrayList = new ArrayList();
                Binder.restoreCallingIdentity(clearCallingIdentity);
                return arrayList;
            }
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return (List) allSubInfoList.stream().filter(new SubscriptionController$$ExternalSyntheticLambda4(this, parcelUuid, str, str2)).map(new SubscriptionController$$ExternalSyntheticLambda5(this, str, str2)).collect(Collectors.toList());
        } catch (Throwable th) {
            Binder.restoreCallingIdentity(clearCallingIdentity);
            throw th;
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$getSubscriptionsInGroup$8(ParcelUuid parcelUuid, String str, String str2, SubscriptionInfo subscriptionInfo) {
        if (!parcelUuid.equals(subscriptionInfo.getGroupUuid())) {
            return false;
        }
        if (TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, subscriptionInfo.getSubscriptionId(), str, str2, "getSubscriptionsInGroup") || subscriptionInfo.canManageSubscription(this.mContext, str)) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ SubscriptionInfo lambda$getSubscriptionsInGroup$9(String str, String str2, SubscriptionInfo subscriptionInfo) {
        return conditionallyRemoveIdentifiers(subscriptionInfo, str, str2, "getSubscriptionsInGroup");
    }

    public boolean checkPhoneIdAndIccIdMatch(int i, String str) {
        List<SubscriptionInfo> list;
        int subIdUsingPhoneId = getSubIdUsingPhoneId(i);
        if (!SubscriptionManager.isUsableSubIdValue(subIdUsingPhoneId)) {
            return false;
        }
        ParcelUuid groupUuid = getGroupUuid(subIdUsingPhoneId);
        if (groupUuid != null) {
            list = getSubInfo("group_uuid='" + groupUuid.toString() + "'", (Object) null);
        } else {
            list = getSubInfo("_id=" + subIdUsingPhoneId, (Object) null);
        }
        if (list == null || !list.stream().anyMatch(new SubscriptionController$$ExternalSyntheticLambda6(str))) {
            return false;
        }
        return true;
    }

    public ParcelUuid getGroupUuid(int i) {
        List<SubscriptionInfo> subInfo = getSubInfo("_id=" + i, (Object) null);
        if (subInfo == null || subInfo.size() == 0) {
            return null;
        }
        return subInfo.get(0).getGroupUuid();
    }

    public boolean setSubscriptionEnabled(boolean z, int i) {
        boolean z2;
        enforceModifyPhoneState("setSubscriptionEnabled");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            StringBuilder sb = new StringBuilder();
            sb.append("setSubscriptionEnabled");
            sb.append(z ? " enable " : " disable ");
            sb.append(" subId ");
            sb.append(i);
            logd(sb.toString());
            if (SubscriptionManager.isUsableSubscriptionId(i)) {
                if (z == isActiveSubscriptionId(i)) {
                    z2 = true;
                } else {
                    SubscriptionInfo subscriptionInfo = (SubscriptionInfo) getInstance().getAllSubInfoList(this.mContext.getOpPackageName(), this.mContext.getAttributionTag()).stream().filter(new SubscriptionController$$ExternalSyntheticLambda2(i)).findFirst().get();
                    if (subscriptionInfo == null) {
                        logd("setSubscriptionEnabled subId " + i + " doesn't exist.");
                        z2 = false;
                    } else if (subscriptionInfo.isEmbedded()) {
                        boolean enableEmbeddedSubscription = enableEmbeddedSubscription(subscriptionInfo, z);
                        Binder.restoreCallingIdentity(clearCallingIdentity);
                        return enableEmbeddedSubscription;
                    } else {
                        boolean enablePhysicalSubscription = enablePhysicalSubscription(subscriptionInfo, z);
                        Binder.restoreCallingIdentity(clearCallingIdentity);
                        return enablePhysicalSubscription;
                    }
                }
                return z2;
            }
            throw new IllegalArgumentException("setSubscriptionEnabled not usable subId " + i);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$setSubscriptionEnabled$11(int i, SubscriptionInfo subscriptionInfo) {
        return subscriptionInfo.getSubscriptionId() == i;
    }

    private boolean enableEmbeddedSubscription(SubscriptionInfo subscriptionInfo, boolean z) {
        enableSubscriptionOverEuiccManager(subscriptionInfo.getSubscriptionId(), z, -1);
        return false;
    }

    private boolean enablePhysicalSubscription(SubscriptionInfo subscriptionInfo, boolean z) {
        UiccSlotInfo uiccSlotInfo;
        if (subscriptionInfo == null || !SubscriptionManager.isValidSubscriptionId(subscriptionInfo.getSubscriptionId())) {
            return false;
        }
        int subscriptionId = subscriptionInfo.getSubscriptionId();
        int i = -1;
        UiccSlotInfo[] uiccSlotsInfo = this.mTelephonyManager.getUiccSlotsInfo();
        if (uiccSlotsInfo == null) {
            return false;
        }
        int i2 = 0;
        while (true) {
            if (i2 >= uiccSlotsInfo.length) {
                uiccSlotInfo = null;
                break;
            }
            uiccSlotInfo = uiccSlotsInfo[i2];
            if (uiccSlotInfo.getCardStateInfo() == 2 && TextUtils.equals(IccUtils.stripTrailingFs(uiccSlotInfo.getCardId()), IccUtils.stripTrailingFs(subscriptionInfo.getCardString()))) {
                i = i2;
                break;
            }
            i2++;
        }
        if (uiccSlotInfo == null) {
            return false;
        }
        if (!z || ((UiccPortInfo) uiccSlotInfo.getPorts().stream().findFirst().get()).isActive()) {
            setUiccApplicationsEnabled(z, subscriptionId);
            return true;
        }
        EuiccManager euiccManager = (EuiccManager) this.mContext.getSystemService("euicc");
        if (euiccManager == null || !euiccManager.isEnabled()) {
            if (!subscriptionInfo.areUiccApplicationsEnabled()) {
                setUiccApplicationsEnabled(z, subscriptionId);
            }
            if (this.mTelephonyManager.isMultiSimSupported() == 0) {
                PhoneConfigurationManager.getInstance().switchMultiSimConfig(this.mTelephonyManager.getSupportedModemCount());
            } else {
                ArrayList arrayList = new ArrayList();
                arrayList.add(new UiccSlotMapping(0, i, 0));
                UiccController.getInstance().switchSlots(arrayList, (Message) null);
            }
        } else {
            enableSubscriptionOverEuiccManager(subscriptionId, z, i);
        }
        return true;
    }

    private void enableSubscriptionOverEuiccManager(int i, boolean z, int i2) {
        StringBuilder sb = new StringBuilder();
        sb.append("enableSubscriptionOverEuiccManager");
        sb.append(z ? " enable " : " disable ");
        sb.append("subId ");
        sb.append(i);
        sb.append(" on slotIndex ");
        sb.append(i2);
        logdl(sb.toString());
        Intent intent = new Intent("android.telephony.euicc.action.TOGGLE_SUBSCRIPTION_PRIVILEGED");
        intent.addFlags(268435456);
        intent.putExtra("android.telephony.euicc.extra.SUBSCRIPTION_ID", i);
        intent.putExtra("android.telephony.euicc.extra.ENABLE_SUBSCRIPTION", z);
        if (i2 != -1) {
            intent.putExtra("android.telephony.euicc.extra.PHYSICAL_SLOT_ID", i2);
        }
        this.mContext.startActivity(intent);
    }

    private void updateEnabledSubscriptionGlobalSetting(int i, int i2) {
        ContentResolver contentResolver = this.mContext.getContentResolver();
        Settings.Global.putInt(contentResolver, "enabled_subscription_for_slot" + i2, i);
    }

    private void updateModemStackEnabledGlobalSetting(boolean z, int i) {
        ContentResolver contentResolver = this.mContext.getContentResolver();
        Settings.Global.putInt(contentResolver, "modem_stack_enabled_for_slot" + i, z ? 1 : 0);
    }

    private int getPhysicalSlotIndexFromLogicalSlotIndex(int i) {
        UiccSlotInfo[] uiccSlotsInfo = this.mTelephonyManager.getUiccSlotsInfo();
        int i2 = -1;
        for (int i3 = 0; i3 < uiccSlotsInfo.length; i3++) {
            Iterator it = uiccSlotsInfo[i3].getPorts().iterator();
            while (true) {
                if (it.hasNext()) {
                    if (((UiccPortInfo) it.next()).getLogicalSlotIndex() == i) {
                        i2 = i3;
                        break;
                    }
                } else {
                    break;
                }
            }
        }
        return i2;
    }

    public boolean isSubscriptionEnabled(int i) {
        enforceReadPrivilegedPhoneState("isSubscriptionEnabled");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            if (SubscriptionManager.isUsableSubscriptionId(i)) {
                List<SubscriptionInfo> subInfo = getSubInfo("_id=" + i, (Object) null);
                boolean z = false;
                if (subInfo != null) {
                    if (!subInfo.isEmpty()) {
                        if (subInfo.get(0).isEmbedded()) {
                            boolean isActiveSubId = isActiveSubId(i);
                            Binder.restoreCallingIdentity(clearCallingIdentity);
                            return isActiveSubId;
                        }
                        if (isActiveSubId(i) && PhoneConfigurationManager.getInstance().getPhoneStatus(PhoneFactory.getPhone(getPhoneId(i)))) {
                            z = true;
                        }
                        Binder.restoreCallingIdentity(clearCallingIdentity);
                        return z;
                    }
                }
                return false;
            }
            throw new IllegalArgumentException("isSubscriptionEnabled not usable subId " + i);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(2:16|17) */
    /* JADX WARNING: Code restructure failed: missing block: B:17:?, code lost:
        r7 = getSubIdUsingPhoneId(r8);
     */
    /* JADX WARNING: Missing exception handler attribute for start block: B:16:0x0058 */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int getEnabledSubscriptionId(int r8) {
        /*
            r7 = this;
            java.lang.String r0 = "getEnabledSubscriptionId"
            r7.enforceReadPrivilegedPhoneState(r0)
            long r0 = android.os.Binder.clearCallingIdentity()
            boolean r2 = android.telephony.SubscriptionManager.isValidPhoneId(r8)     // Catch:{ all -> 0x0077 }
            if (r2 == 0) goto L_0x0060
            int r2 = r7.getPhysicalSlotIndexFromLogicalSlotIndex(r8)     // Catch:{ all -> 0x0077 }
            r3 = -1
            if (r2 != r3) goto L_0x001a
            android.os.Binder.restoreCallingIdentity(r0)
            return r3
        L_0x001a:
            android.content.Context r4 = r7.mContext     // Catch:{ all -> 0x0077 }
            android.content.ContentResolver r4 = r4.getContentResolver()     // Catch:{ all -> 0x0077 }
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x0077 }
            r5.<init>()     // Catch:{ all -> 0x0077 }
            java.lang.String r6 = "modem_stack_enabled_for_slot"
            r5.append(r6)     // Catch:{ all -> 0x0077 }
            r5.append(r2)     // Catch:{ all -> 0x0077 }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x0077 }
            r6 = 1
            int r4 = android.provider.Settings.Global.getInt(r4, r5, r6)     // Catch:{ all -> 0x0077 }
            if (r4 == r6) goto L_0x003c
            android.os.Binder.restoreCallingIdentity(r0)
            return r3
        L_0x003c:
            android.content.Context r3 = r7.mContext     // Catch:{ SettingNotFoundException -> 0x0058 }
            android.content.ContentResolver r3 = r3.getContentResolver()     // Catch:{ SettingNotFoundException -> 0x0058 }
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ SettingNotFoundException -> 0x0058 }
            r4.<init>()     // Catch:{ SettingNotFoundException -> 0x0058 }
            java.lang.String r5 = "enabled_subscription_for_slot"
            r4.append(r5)     // Catch:{ SettingNotFoundException -> 0x0058 }
            r4.append(r2)     // Catch:{ SettingNotFoundException -> 0x0058 }
            java.lang.String r2 = r4.toString()     // Catch:{ SettingNotFoundException -> 0x0058 }
            int r7 = android.provider.Settings.Global.getInt(r3, r2)     // Catch:{ SettingNotFoundException -> 0x0058 }
            goto L_0x005c
        L_0x0058:
            int r7 = r7.getSubIdUsingPhoneId(r8)     // Catch:{ all -> 0x0077 }
        L_0x005c:
            android.os.Binder.restoreCallingIdentity(r0)
            return r7
        L_0x0060:
            java.lang.IllegalArgumentException r7 = new java.lang.IllegalArgumentException     // Catch:{ all -> 0x0077 }
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x0077 }
            r2.<init>()     // Catch:{ all -> 0x0077 }
            java.lang.String r3 = "getEnabledSubscriptionId with invalid logicalSlotIndex "
            r2.append(r3)     // Catch:{ all -> 0x0077 }
            r2.append(r8)     // Catch:{ all -> 0x0077 }
            java.lang.String r8 = r2.toString()     // Catch:{ all -> 0x0077 }
            r7.<init>(r8)     // Catch:{ all -> 0x0077 }
            throw r7     // Catch:{ all -> 0x0077 }
        L_0x0077:
            r7 = move-exception
            android.os.Binder.restoreCallingIdentity(r0)
            throw r7
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.getEnabledSubscriptionId(int):int");
    }

    /* JADX WARNING: Removed duplicated region for block: B:19:0x0033 A[ADDED_TO_REGION] */
    /* JADX WARNING: Removed duplicated region for block: B:23:0x003e  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private java.util.List<android.telephony.SubscriptionInfo> getSubscriptionInfoListFromCacheHelper(java.lang.String r9, java.lang.String r10, java.util.List<android.telephony.SubscriptionInfo> r11) {
        /*
            r8 = this;
            r0 = 0
            android.content.Context r1 = r8.mContext     // Catch:{ SecurityException -> 0x002d }
            r2 = -1
            int r3 = android.os.Binder.getCallingPid()     // Catch:{ SecurityException -> 0x002d }
            int r4 = android.os.Binder.getCallingUid()     // Catch:{ SecurityException -> 0x002d }
            java.lang.String r7 = "getSubscriptionInfoList"
            r5 = r9
            r6 = r10
            boolean r1 = com.android.internal.telephony.TelephonyPermissions.checkReadPhoneState(r1, r2, r3, r4, r5, r6, r7)     // Catch:{ SecurityException -> 0x002d }
            if (r1 == 0) goto L_0x002b
            r3 = -1
            java.lang.String r6 = "getSubscriptionInfoList"
            r7 = 0
            r2 = r8
            r4 = r9
            r5 = r10
            boolean r2 = r2.hasSubscriberIdentifierAccess(r3, r4, r5, r6, r7)     // Catch:{ SecurityException -> 0x0029 }
            java.lang.String r3 = "getSubscriptionInfoList"
            r4 = -1
            boolean r9 = r8.hasPhoneNumberAccess(r4, r9, r10, r3)     // Catch:{ SecurityException -> 0x002f }
            goto L_0x0030
        L_0x0029:
            r2 = r0
            goto L_0x002f
        L_0x002b:
            r9 = r0
            goto L_0x0031
        L_0x002d:
            r1 = r0
            r2 = r1
        L_0x002f:
            r9 = r0
        L_0x0030:
            r0 = r2
        L_0x0031:
            if (r0 == 0) goto L_0x0036
            if (r9 == 0) goto L_0x0036
            return r11
        L_0x0036:
            int r10 = r11.size()
            int r10 = r10 + -1
        L_0x003c:
            if (r10 < 0) goto L_0x0060
            java.lang.Object r2 = r11.get(r10)
            android.telephony.SubscriptionInfo r2 = (android.telephony.SubscriptionInfo) r2
            int r3 = r2.getSubscriptionId()
            android.content.Context r4 = r8.mContext
            boolean r3 = com.android.internal.telephony.TelephonyPermissions.checkCarrierPrivilegeForSubId(r4, r3)
            if (r3 == 0) goto L_0x0051
            goto L_0x005d
        L_0x0051:
            r11.remove(r10)
            if (r1 == 0) goto L_0x005d
            android.telephony.SubscriptionInfo r2 = r8.conditionallyRemoveIdentifiers(r2, r0, r9)
            r11.add(r10, r2)
        L_0x005d:
            int r10 = r10 + -1
            goto L_0x003c
        L_0x0060:
            return r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SubscriptionController.getSubscriptionInfoListFromCacheHelper(java.lang.String, java.lang.String, java.util.List):java.util.List");
    }

    private SubscriptionInfo conditionallyRemoveIdentifiers(SubscriptionInfo subscriptionInfo, String str, String str2, String str3) {
        int subscriptionId = subscriptionInfo.getSubscriptionId();
        return conditionallyRemoveIdentifiers(subscriptionInfo, hasSubscriberIdentifierAccess(subscriptionId, str, str2, str3, true), hasPhoneNumberAccess(subscriptionId, str, str2, str3));
    }

    private SubscriptionInfo conditionallyRemoveIdentifiers(SubscriptionInfo subscriptionInfo, boolean z, boolean z2) {
        if (z && z2) {
            return subscriptionInfo;
        }
        SubscriptionInfo subscriptionInfo2 = new SubscriptionInfo(subscriptionInfo);
        if (!z) {
            subscriptionInfo2.clearIccId();
            subscriptionInfo2.clearCardString();
            subscriptionInfo2.clearGroupUuid();
        }
        if (!z2) {
            subscriptionInfo2.clearNumber();
        }
        return subscriptionInfo2;
    }

    /* access modifiers changed from: protected */
    public synchronized boolean addToSubIdList(int i, int i2, int i3) {
        ArrayList<Integer> copy = sSlotIndexToSubIds.getCopy(i);
        if (copy == null) {
            copy = new ArrayList<>();
            sSlotIndexToSubIds.put(i, copy);
        }
        if (copy.contains(Integer.valueOf(i2))) {
            logdl("slotIndex, subId combo already exists in the map. Not adding it again.");
            return false;
        }
        if (isSubscriptionForRemoteSim(i3)) {
            sSlotIndexToSubIds.addToSubIdList(i, Integer.valueOf(i2));
        } else {
            sSlotIndexToSubIds.clearSubIdList(i);
            sSlotIndexToSubIds.addToSubIdList(i, Integer.valueOf(i2));
        }
        for (Map.Entry next : sSlotIndexToSubIds.entrySet()) {
            if (!(((Integer) next.getKey()).intValue() == i || next.getValue() == null || !((ArrayList) next.getValue()).contains(Integer.valueOf(i2)))) {
                logdl("addToSubIdList - remove " + next.getKey());
                sSlotIndexToSubIds.remove(((Integer) next.getKey()).intValue());
            }
        }
        logdl("slotIndex, subId combo is added to the map.");
        return true;
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public Map<Integer, ArrayList<Integer>> getSlotIndexToSubIdsMap() {
        return sSlotIndexToSubIds.getMap();
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void resetStaticMembers() {
        sDefaultFallbackSubId.set(-1);
        mDefaultPhoneId = Integer.MAX_VALUE;
    }

    /* access modifiers changed from: protected */
    public void notifyOpportunisticSubscriptionInfoChanged() {
        logd("notifyOpptSubscriptionInfoChanged:");
        ((TelephonyRegistryManager) this.mContext.getSystemService("telephony_registry")).notifyOpportunisticSubscriptionInfoChanged();
    }

    private void refreshCachedOpportunisticSubscriptionInfoList() {
        synchronized (this.mSubInfoListLock) {
            List<SubscriptionInfo> subInfo = getSubInfo("is_opportunistic=1 AND (sim_id>=0 OR is_embedded=1)", (Object) null);
            List<SubscriptionInfo> list = this.mCacheOpportunisticSubInfoList;
            if (subInfo != null) {
                subInfo.sort(SUBSCRIPTION_INFO_COMPARATOR);
            } else {
                subInfo = new ArrayList<>();
            }
            this.mCacheOpportunisticSubInfoList = subInfo;
            for (SubscriptionInfo next : subInfo) {
                if (shouldDisableSubGroup(next.getGroupUuid())) {
                    next.setGroupDisabled(true);
                }
            }
            if (!list.equals(this.mCacheOpportunisticSubInfoList)) {
                this.mOpptSubInfoListChangedDirtyBit.set(true);
            }
        }
    }

    private boolean shouldDisableSubGroup(ParcelUuid parcelUuid) {
        if (parcelUuid == null) {
            return false;
        }
        synchronized (this.mSubInfoListLock) {
            for (SubscriptionInfo next : this.mCacheActiveSubInfoList) {
                if (!next.isOpportunistic() && parcelUuid.equals(next.getGroupUuid())) {
                    return false;
                }
            }
            return true;
        }
    }

    public boolean setDataEnabledOverrideRules(int i, String str) {
        logd("[setDataEnabledOverrideRules]+ rules:" + str + " subId:" + i);
        validateSubId(i);
        boolean z = true;
        ContentValues contentValues = new ContentValues(1);
        contentValues.put("data_enabled_override_rules", str);
        if (updateDatabase(contentValues, i, true) <= 0) {
            z = false;
        }
        if (z) {
            refreshCachedActiveSubscriptionInfoList();
            notifySubscriptionInfoChanged();
        }
        return z;
    }

    public String getDataEnabledOverrideRules(int i) {
        return TelephonyUtils.emptyIfNull(getSubscriptionProperty(i, "data_enabled_override_rules"));
    }

    public int getActiveDataSubscriptionId() {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            PhoneSwitcher instance = PhoneSwitcher.getInstance();
            if (instance != null) {
                int activeDataSubId = instance.getActiveDataSubId();
                if (SubscriptionManager.isUsableSubscriptionId(activeDataSubId)) {
                    return activeDataSubId;
                }
            }
            int defaultDataSubId = getDefaultDataSubId();
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return defaultDataSubId;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public boolean canDisablePhysicalSubscription() {
        enforceReadPrivilegedPhoneState("canToggleUiccApplicationsEnablement");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            Phone defaultPhone = PhoneFactory.getDefaultPhone();
            return defaultPhone != null && defaultPhone.canDisablePhysicalSubscription();
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public String getPhoneNumber(int i, int i2, String str, String str2) {
        TelephonyPermissions.enforceAnyPermissionGrantedOrCarrierPrivileges(this.mContext, i, Binder.getCallingUid(), "getPhoneNumber", new String[]{"android.permission.READ_PHONE_NUMBERS", "android.permission.READ_PRIVILEGED_PHONE_STATE"});
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            String phoneNumber = getPhoneNumber(i, i2);
            if (phoneNumber == null) {
                phoneNumber = "";
            }
            return phoneNumber;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public String getPhoneNumberFromFirstAvailableSource(int i, String str, String str2) {
        TelephonyPermissions.enforceAnyPermissionGrantedOrCarrierPrivileges(this.mContext, i, Binder.getCallingUid(), "getPhoneNumberFromFirstAvailableSource", new String[]{"android.permission.READ_PHONE_NUMBERS", "android.permission.READ_PRIVILEGED_PHONE_STATE"});
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            String phoneNumber = getPhoneNumber(i, 2);
            if (!TextUtils.isEmpty(phoneNumber)) {
                return phoneNumber;
            }
            String phoneNumber2 = getPhoneNumber(i, 1);
            if (!TextUtils.isEmpty(phoneNumber2)) {
                Binder.restoreCallingIdentity(clearCallingIdentity);
                return phoneNumber2;
            }
            String phoneNumber3 = getPhoneNumber(i, 3);
            if (!TextUtils.isEmpty(phoneNumber3)) {
                Binder.restoreCallingIdentity(clearCallingIdentity);
                return phoneNumber3;
            }
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return "";
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    private String getPhoneNumber(int i, int i2) {
        if (i2 == 1) {
            Phone phone = PhoneFactory.getPhone(getPhoneId(i));
            if (phone != null) {
                return phone.getLine1Number();
            }
            return null;
        } else if (i2 == 2) {
            return getSubscriptionProperty(i, "phone_number_source_carrier");
        } else {
            if (i2 == 3) {
                return getSubscriptionProperty(i, "phone_number_source_ims");
            }
            throw new IllegalArgumentException("setPhoneNumber doesn't accept source " + i2);
        }
    }

    public void setPhoneNumber(int i, int i2, String str, String str2, String str3) {
        if (i2 != 2) {
            throw new IllegalArgumentException("setPhoneNumber doesn't accept source " + i2);
        } else if (!TelephonyPermissions.checkCarrierPrivilegeForSubId(this.mContext, i)) {
            throw new SecurityException("setPhoneNumber for CARRIER needs carrier privilege");
        } else if (str != null) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                setSubscriptionProperty(i, "phone_number_source_carrier", str);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new NullPointerException("invalid number null");
        }
    }

    public int setUsageSetting(int i, int i2, String str) {
        try {
            TelephonyPermissions.enforceCallingOrSelfModifyPermissionOrCarrierPrivilege(this.mContext, i2, str);
        } catch (SecurityException unused) {
            enforceCarrierPrivilegeOnInactiveSub(i2, str, "Caller requires permission on sub " + i2);
        }
        if (i < 0 || i > 2) {
            throw new IllegalArgumentException("setUsageSetting: Invalid usage setting: " + i);
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            int subscriptionProperty = setSubscriptionProperty(i2, "usage_setting", String.valueOf(i));
            if (subscriptionProperty == 1) {
                return subscriptionProperty;
            }
            throw new IllegalArgumentException("Invalid SubscriptionId for setUsageSetting");
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* access modifiers changed from: protected */
    public void setGlobalSetting(String str, int i) {
        Settings.Global.putInt(this.mContext.getContentResolver(), str, i);
        if (str == "multi_sim_data_call") {
            invalidateDefaultDataSubIdCaches();
            invalidateActiveDataSubIdCaches();
            invalidateDefaultSubIdCaches();
            invalidateSlotIndexCaches();
        } else if (str == "multi_sim_voice_call") {
            invalidateDefaultSubIdCaches();
            invalidateSlotIndexCaches();
        } else if (str == "multi_sim_sms") {
            invalidateDefaultSmsSubIdCaches();
        }
    }

    /* access modifiers changed from: private */
    public static void invalidateDefaultSubIdCaches() {
        if (sCachingEnabled) {
            SubscriptionManager.invalidateDefaultSubIdCaches();
        }
    }

    private static void invalidateDefaultDataSubIdCaches() {
        if (sCachingEnabled) {
            SubscriptionManager.invalidateDefaultDataSubIdCaches();
        }
    }

    private static void invalidateDefaultSmsSubIdCaches() {
        if (sCachingEnabled) {
            SubscriptionManager.invalidateDefaultSmsSubIdCaches();
        }
    }

    public static void invalidateActiveDataSubIdCaches() {
        if (sCachingEnabled) {
            SubscriptionManager.invalidateActiveDataSubIdCaches();
        }
    }

    protected static void invalidateSlotIndexCaches() {
        if (sCachingEnabled) {
            SubscriptionManager.invalidateSlotIndexCaches();
        }
    }

    @VisibleForTesting
    public static void disableCaching() {
        sCachingEnabled = false;
    }

    @VisibleForTesting
    public static void enableCaching() {
        sCachingEnabled = true;
    }
}
