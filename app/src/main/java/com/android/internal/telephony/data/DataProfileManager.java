package com.android.internal.telephony.data;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.database.ContentObserver;
import android.database.Cursor;
import android.net.NetworkRequest;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemProperties;
import android.provider.Telephony;
import android.telephony.SubscriptionManager;
import android.telephony.data.ApnSetting;
import android.telephony.data.DataProfile;
import android.telephony.data.TrafficDescriptor;
import android.text.TextUtils;
import android.util.ArraySet;
import com.android.internal.telephony.AndroidUtilIndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.data.DataNetworkController;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.Executor;
import java.util.stream.Collectors;

public class DataProfileManager extends Handler {
    private static final int EVENT_APN_DATABASE_CHANGED = 2;
    protected static final int EVENT_DATA_CONFIG_UPDATED = 1;
    protected static final int EVENT_SIM_REFRESH = 3;
    private static final boolean VDBG = true;
    protected final List<DataProfile> mAllDataProfiles = new ArrayList();
    protected final DataConfigManager mDataConfigManager;
    protected final DataNetworkController mDataNetworkController;
    protected final Set<DataProfileManagerCallback> mDataProfileManagerCallbacks;
    protected DataProfile mInitialAttachDataProfile = null;
    private final LocalLog mLocalLog = new LocalLog(128);
    protected final String mLogTag;
    protected final Phone mPhone;
    protected DataProfile mPreferredDataProfile = null;
    protected int mPreferredDataProfileSetId = 0;
    private final DataServiceManager mWwanDataServiceManager;

    public static abstract class DataProfileManagerCallback extends DataCallback {
        public abstract void onDataProfilesChanged();

        public DataProfileManagerCallback(Executor executor) {
            super(executor);
        }
    }

    public DataProfileManager(Phone phone, DataNetworkController dataNetworkController, DataServiceManager dataServiceManager, Looper looper, DataProfileManagerCallback dataProfileManagerCallback) {
        super(looper);
        ArraySet arraySet = new ArraySet();
        this.mDataProfileManagerCallbacks = arraySet;
        this.mPhone = phone;
        this.mLogTag = "DPM-" + phone.getPhoneId();
        this.mDataNetworkController = dataNetworkController;
        this.mWwanDataServiceManager = dataServiceManager;
        this.mDataConfigManager = dataNetworkController.getDataConfigManager();
        arraySet.add(dataProfileManagerCallback);
        registerAllEvents();
    }

    /* access modifiers changed from: protected */
    public void registerAllEvents() {
        this.mDataNetworkController.registerDataNetworkControllerCallback(new DataNetworkController.DataNetworkControllerCallback(new DataProfileManager$$ExternalSyntheticLambda11(this)) {
            public void onInternetDataNetworkConnected(List<DataProfile> list) {
                DataProfileManager.this.onInternetDataNetworkConnected(list);
            }
        });
        this.mDataConfigManager.registerForConfigUpdate(this, 1);
        this.mPhone.getContext().getContentResolver().registerContentObserver(Telephony.Carriers.CONTENT_URI, true, new ContentObserver(this) {
            public void onChange(boolean z) {
                super.onChange(z);
                DataProfileManager.this.sendEmptyMessage(2);
            }
        });
        this.mPhone.mCi.registerForIccRefresh(this, 3, (Object) null);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            onDataConfigUpdated();
        } else if (i == 2) {
            log("Update data profiles due to APN db updated.");
            updateDataProfiles();
        } else if (i != 3) {
            loge("Unexpected event " + message);
        } else {
            log("Update data profiles due to SIM refresh.");
            updateDataProfiles();
        }
    }

    private void onDataConfigUpdated() {
        log("Update data profiles due to config updated.");
        updateDataProfiles();
    }

    /* access modifiers changed from: protected */
    public DataProfile getEnterpriseDataProfile() {
        Cursor query = this.mPhone.getContext().getContentResolver().query(Telephony.Carriers.DPC_URI, (String[]) null, (String) null, (String[]) null, (String) null);
        if (query == null) {
            loge("Cannot access APN database through telephony provider.");
            return null;
        }
        DataProfile dataProfile = null;
        while (query.moveToNext()) {
            ApnSetting makeApnSetting = ApnSetting.makeApnSetting(query);
            if (makeApnSetting != null) {
                dataProfile = new DataProfile.Builder().setApnSetting(makeApnSetting).setTrafficDescriptor(new TrafficDescriptor(makeApnSetting.getApnName(), (byte[]) null)).setPreferred(false).build();
                if (dataProfile.canSatisfy(29)) {
                    break;
                }
            }
        }
        query.close();
        return dataProfile;
    }

    /* access modifiers changed from: protected */
    public void updateDataProfiles() {
        DataProfile enterpriseDataProfile;
        ArrayList arrayList = new ArrayList();
        boolean z = false;
        if (this.mDataConfigManager.isConfigCarrierSpecific()) {
            Cursor query = this.mPhone.getContext().getContentResolver().query(Uri.withAppendedPath(Telephony.Carriers.SIM_APN_URI, "filtered/subId/" + this.mPhone.getSubId()), (String[]) null, (String) null, (String[]) null, "_id");
            if (query == null) {
                loge("Cannot access APN database through telephony provider.");
                return;
            }
            while (query.moveToNext()) {
                ApnSetting makeApnSetting = ApnSetting.makeApnSetting(query);
                if (makeApnSetting != null) {
                    DataProfile build = new DataProfile.Builder().setApnSetting(makeApnSetting).setTrafficDescriptor(new TrafficDescriptor(makeApnSetting.getApnName(), (byte[]) null)).setPreferred(false).build();
                    arrayList.add(build);
                    log("Added " + build);
                }
            }
            query.close();
        }
        if (((DataProfile) arrayList.stream().filter(new DataProfileManager$$ExternalSyntheticLambda12()).findFirst().orElse((Object) null)) == null && (enterpriseDataProfile = getEnterpriseDataProfile()) != null) {
            arrayList.add(enterpriseDataProfile);
            log("Added enterprise profile " + enterpriseDataProfile);
        }
        if (((DataProfile) arrayList.stream().filter(new DataProfileManager$$ExternalSyntheticLambda13()).findFirst().orElse((Object) null)) == null) {
            if (isMtkImsDataSupport()) {
                arrayList.add(new DataProfile.Builder().setApnSetting(buildMTKDefaultApnSetting("DEFAULT IMS", "ims", 64)).setTrafficDescriptor(new TrafficDescriptor("ims", (byte[]) null)).build());
                log("Added default MTK IMS data profile.");
            } else {
                arrayList.add(new DataProfile.Builder().setApnSetting(buildDefaultApnSetting("DEFAULT IMS", "ims", 64)).setTrafficDescriptor(new TrafficDescriptor("ims", (byte[]) null)).build());
                log("Added default IMS data profile.");
            }
        }
        if (((DataProfile) arrayList.stream().filter(new DataProfileManager$$ExternalSyntheticLambda14()).findFirst().orElse((Object) null)) == null) {
            if (isMtkImsDataSupport()) {
                arrayList.add(new DataProfile.Builder().setApnSetting(buildMTKDefaultApnSetting("DEFAULT EIMS", "", 512)).setTrafficDescriptor(new TrafficDescriptor("", (byte[]) null)).build());
                log("Added default MTK EIMS data profile.");
            } else {
                arrayList.add(new DataProfile.Builder().setApnSetting(buildDefaultApnSetting("DEFAULT EIMS", "sos", 512)).setTrafficDescriptor(new TrafficDescriptor("sos", (byte[]) null)).build());
                log("Added default EIMS data profile.");
            }
        }
        dedupeDataProfiles(arrayList);
        log("Found " + arrayList.size() + " data profiles. profiles = " + arrayList);
        boolean z2 = true;
        if (this.mAllDataProfiles.size() != arrayList.size() || !this.mAllDataProfiles.containsAll(arrayList)) {
            log("Data profiles changed.");
            this.mAllDataProfiles.clear();
            this.mAllDataProfiles.addAll(arrayList);
            z = true;
        }
        boolean updatePreferredDataProfile = updatePreferredDataProfile() | z;
        int preferredDataProfileSetId = getPreferredDataProfileSetId();
        if (preferredDataProfileSetId != this.mPreferredDataProfileSetId) {
            logl("Changed preferred data profile set id to " + preferredDataProfileSetId);
            this.mPreferredDataProfileSetId = preferredDataProfileSetId;
        } else {
            z2 = updatePreferredDataProfile;
        }
        updateDataProfilesAtModem();
        updateInitialAttachDataProfileAtModem();
        if (z2) {
            this.mDataProfileManagerCallbacks.forEach(new DataProfileManager$$ExternalSyntheticLambda15());
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$updateDataProfiles$3(DataProfileManagerCallback dataProfileManagerCallback) {
        Objects.requireNonNull(dataProfileManagerCallback);
        dataProfileManagerCallback.invokeFromExecutor(new DataProfileManager$$ExternalSyntheticLambda18(dataProfileManagerCallback));
    }

    /* access modifiers changed from: protected */
    public int getPreferredDataProfileSetId() {
        Cursor query = this.mPhone.getContext().getContentResolver().query(Uri.withAppendedPath(Telephony.Carriers.PREFERRED_APN_SET_URI, String.valueOf(this.mPhone.getSubId())), new String[]{"apn_set_id"}, (String) null, (String[]) null, (String) null);
        int i = 0;
        if (query == null) {
            log("getPreferredDataProfileSetId: cursor is null");
            return 0;
        }
        if (query.getCount() < 1) {
            loge("getPreferredDataProfileSetId: no APNs found");
        } else {
            query.moveToFirst();
            i = query.getInt(query.getColumnIndexOrThrow("apn_set_id"));
        }
        query.close();
        return i;
    }

    /* access modifiers changed from: private */
    public void onInternetDataNetworkConnected(List<DataProfile> list) {
        DataProfile dataProfile = (DataProfile) list.stream().max(Comparator.comparingLong(new DataProfileManager$$ExternalSyntheticLambda6()).reversed()).orElse((Object) null);
        if (dataProfile == null || !isDataProfilePreferred(dataProfile)) {
            setPreferredDataProfile(dataProfile);
            updateDataProfiles();
        }
    }

    private DataProfile getPreferredDataProfileFromDb() {
        Cursor query = this.mPhone.getContext().getContentResolver().query(Uri.withAppendedPath(Telephony.Carriers.PREFERRED_APN_URI, String.valueOf(this.mPhone.getSubId())), (String[]) null, (String) null, (String[]) null, "name ASC");
        DataProfile dataProfile = null;
        if (query != null) {
            if (query.getCount() > 0) {
                query.moveToFirst();
                dataProfile = (DataProfile) this.mAllDataProfiles.stream().filter(new DataProfileManager$$ExternalSyntheticLambda0(query.getInt(query.getColumnIndexOrThrow("_id")))).findFirst().orElse((Object) null);
            }
            query.close();
        }
        log("getPreferredDataProfileFromDb: " + dataProfile);
        return dataProfile;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getPreferredDataProfileFromDb$4(int i, DataProfile dataProfile) {
        return dataProfile.getApnSetting() != null && dataProfile.getApnSetting().getId() == i;
    }

    private DataProfile getPreferredDataProfileFromConfig() {
        String defaultPreferredApn = this.mDataConfigManager.getDefaultPreferredApn();
        if (!TextUtils.isEmpty(defaultPreferredApn)) {
            return (DataProfile) this.mAllDataProfiles.stream().filter(new DataProfileManager$$ExternalSyntheticLambda1(defaultPreferredApn)).findFirst().orElse((Object) null);
        }
        return null;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getPreferredDataProfileFromConfig$5(String str, DataProfile dataProfile) {
        return dataProfile.getApnSetting() != null && str.equals(dataProfile.getApnSetting().getApnName());
    }

    private void setPreferredDataProfile(DataProfile dataProfile) {
        log("setPreferredDataProfile: " + dataProfile);
        Uri withAppendedPath = Uri.withAppendedPath(Telephony.Carriers.PREFERRED_APN_URI, Long.toString((long) this.mPhone.getSubId()));
        ContentResolver contentResolver = this.mPhone.getContext().getContentResolver();
        contentResolver.delete(withAppendedPath, (String) null, (String[]) null);
        if (dataProfile != null && dataProfile.getApnSetting() != null) {
            ContentValues contentValues = new ContentValues();
            contentValues.put("apn_id", Integer.valueOf(dataProfile.getApnSetting().getId()));
            contentResolver.insert(withAppendedPath, contentValues);
        }
    }

    /* access modifiers changed from: protected */
    public boolean updatePreferredDataProfile() {
        DataProfile dataProfile;
        if (SubscriptionManager.isValidSubscriptionId(this.mPhone.getSubId())) {
            dataProfile = getPreferredDataProfileFromDb();
            if (dataProfile == null && (dataProfile = getPreferredDataProfileFromConfig()) != null) {
                setPreferredDataProfile(dataProfile);
            }
        } else {
            dataProfile = null;
        }
        for (DataProfile next : this.mAllDataProfiles) {
            next.setPreferred(next.equals(dataProfile));
        }
        if (Objects.equals(this.mPreferredDataProfile, dataProfile)) {
            return false;
        }
        this.mPreferredDataProfile = dataProfile;
        logl("Changed preferred data profile to " + this.mPreferredDataProfile);
        return true;
    }

    /* access modifiers changed from: protected */
    public void updateInitialAttachDataProfileAtModem() {
        List list = (List) this.mAllDataProfiles.stream().sorted(Comparator.comparing(new DataProfileManager$$ExternalSyntheticLambda2(this))).collect(Collectors.toList());
        DataProfile dataProfile = null;
        for (Integer intValue : this.mDataConfigManager.getAllowedInitialAttachApnTypes()) {
            dataProfile = (DataProfile) list.stream().filter(new DataProfileManager$$ExternalSyntheticLambda3(intValue.intValue())).findFirst().orElse((Object) null);
            if (dataProfile != null) {
                break;
            }
        }
        this.mInitialAttachDataProfile = dataProfile;
        logl("Initial attach data profile updated as " + this.mInitialAttachDataProfile);
        DataProfile dataProfile2 = this.mInitialAttachDataProfile;
        if (dataProfile2 != null) {
            this.mWwanDataServiceManager.setInitialAttachApn(dataProfile2, this.mPhone.getServiceState().getDataRoamingFromRegistration(), (Message) null);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ Boolean lambda$updateInitialAttachDataProfileAtModem$6(DataProfile dataProfile) {
        return Boolean.valueOf(!dataProfile.equals(this.mPreferredDataProfile));
    }

    /* access modifiers changed from: protected */
    public void updateDataProfilesAtModem() {
        log("updateDataProfilesAtModem: set " + this.mAllDataProfiles.size() + " data profiles.");
        this.mWwanDataServiceManager.setDataProfile(this.mAllDataProfiles, this.mPhone.getServiceState().getDataRoamingFromRegistration(), (Message) null);
    }

    /* access modifiers changed from: protected */
    public ApnSetting buildDefaultApnSetting(String str, String str2, int i) {
        return new ApnSetting.Builder().setEntryName(str).setProtocol(2).setRoamingProtocol(2).setApnName(str2).setApnTypeBitmask(i).setCarrierEnabled(true).setApnSetId(-1).build();
    }

    /* access modifiers changed from: protected */
    public ApnSetting buildMTKDefaultApnSetting(String str, String str2, int i) {
        return new ApnSetting.Builder().setEntryName(str).setProtocol(2).setRoamingProtocol(2).setApnName(str2).setApnTypeBitmask(i).setCarrierEnabled(true).setApnSetId(-1).buildWithoutCheck();
    }

    public DataProfile getDataProfileForNetworkRequest(TelephonyNetworkRequest telephonyNetworkRequest, int i) {
        TrafficDescriptor.OsAppId osAppId;
        ApnSetting apnSettingForNetworkRequest = telephonyNetworkRequest.hasAttribute(1) ? getApnSettingForNetworkRequest(telephonyNetworkRequest, i) : null;
        TrafficDescriptor.Builder builder = new TrafficDescriptor.Builder();
        if (telephonyNetworkRequest.hasAttribute(2) && apnSettingForNetworkRequest != null) {
            builder.setDataNetworkName(apnSettingForNetworkRequest.getApnName());
        }
        if (telephonyNetworkRequest.hasAttribute(4) && (osAppId = telephonyNetworkRequest.getOsAppId()) != null) {
            builder.setOsAppId(osAppId.getBytes());
        }
        try {
            TrafficDescriptor build = builder.build();
            for (DataProfile next : this.mAllDataProfiles) {
                if (Objects.equals(apnSettingForNetworkRequest, next.getApnSetting()) && build.equals(next.getTrafficDescriptor())) {
                    return next;
                }
            }
            DataProfile.Builder builder2 = new DataProfile.Builder();
            if (apnSettingForNetworkRequest != null) {
                builder2.setApnSetting(apnSettingForNetworkRequest);
            }
            builder2.setTrafficDescriptor(build);
            DataProfile build2 = builder2.build();
            log("Created data profile " + build2 + " for " + telephonyNetworkRequest);
            return build2;
        } catch (IllegalArgumentException unused) {
            log("Unable to find a data profile for " + telephonyNetworkRequest);
            return null;
        }
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r10v12, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r1v8, resolved type: java.util.List} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r10v18, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r1v11, resolved type: java.util.List} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r10v21, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r1v13, resolved type: java.util.List} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private android.telephony.data.ApnSetting getApnSettingForNetworkRequest(com.android.internal.telephony.data.TelephonyNetworkRequest r10, int r11) {
        /*
            r9 = this;
            r0 = 1
            boolean r1 = r10.hasAttribute(r0)
            r2 = 0
            if (r1 != 0) goto L_0x000e
            java.lang.String r10 = "Network request does not have APN setting attribute."
            r9.loge(r10)
            return r2
        L_0x000e:
            java.util.List<android.telephony.data.DataProfile> r1 = r9.mAllDataProfiles
            java.util.stream.Stream r1 = r1.stream()
            com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda4 r3 = new com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda4
            r3.<init>(r10)
            java.util.stream.Stream r1 = r1.filter(r3)
            com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda5 r3 = new com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda5
            r3.<init>(r9)
            java.util.Comparator r3 = java.util.Comparator.comparing(r3)
            com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda6 r4 = new com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda6
            r4.<init>()
            java.util.Comparator r3 = r3.thenComparingLong(r4)
            java.util.stream.Stream r1 = r1.sorted(r3)
            java.util.stream.Collector r3 = java.util.stream.Collectors.toList()
            java.lang.Object r1 = r1.collect(r3)
            java.util.List r1 = (java.util.List) r1
            boolean r3 = r9.isMtkImsDataSupport()
            r4 = 0
            if (r3 == 0) goto L_0x0089
            int r3 = r1.size()
            if (r3 != 0) goto L_0x0089
            r3 = 10
            boolean r3 = r10.hasCapability(r3)
            if (r3 == 0) goto L_0x0089
            java.util.List<android.telephony.data.DataProfile> r10 = r9.mAllDataProfiles
            android.telephony.data.DataProfile$Builder r11 = new android.telephony.data.DataProfile$Builder
            r11.<init>()
            r0 = 512(0x200, float:7.175E-43)
            java.lang.String r1 = "DEFAULT EIMS"
            java.lang.String r3 = ""
            android.telephony.data.ApnSetting r0 = r9.buildMTKDefaultApnSetting(r1, r3, r0)
            android.telephony.data.DataProfile$Builder r11 = r11.setApnSetting(r0)
            android.telephony.data.TrafficDescriptor r0 = new android.telephony.data.TrafficDescriptor
            r0.<init>(r3, r2)
            android.telephony.data.DataProfile$Builder r11 = r11.setTrafficDescriptor(r0)
            android.telephony.data.DataProfile r11 = r11.build()
            r10.add(r11)
            java.lang.String r10 = "For ECC w/o SIM requirement,Added default EIMS data profile."
            r9.log(r10)
            java.util.List<android.telephony.data.DataProfile> r9 = r9.mAllDataProfiles
            java.lang.Object r9 = r9.get(r4)
            android.telephony.data.DataProfile r9 = (android.telephony.data.DataProfile) r9
            android.telephony.data.ApnSetting r9 = r9.getApnSetting()
            return r9
        L_0x0089:
            java.util.Iterator r3 = r1.iterator()
        L_0x008d:
            boolean r5 = r3.hasNext()
            if (r5 == 0) goto L_0x00be
            java.lang.Object r5 = r3.next()
            android.telephony.data.DataProfile r5 = (android.telephony.data.DataProfile) r5
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "Satisfied profile: "
            r6.append(r7)
            r6.append(r5)
            java.lang.String r7 = ", last setup="
            r6.append(r7)
            long r7 = r5.getLastSetupTimestamp()
            java.lang.String r5 = com.android.internal.telephony.data.DataUtils.elapsedTimeToString(r7)
            r6.append(r5)
            java.lang.String r5 = r6.toString()
            r9.logv(r5)
            goto L_0x008d
        L_0x00be:
            int r3 = r1.size()
            if (r3 != 0) goto L_0x00d9
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            java.lang.String r0 = "Can't find any data profile that can satisfy "
            r11.append(r0)
            r11.append(r10)
            java.lang.String r10 = r11.toString()
            r9.log(r10)
            return r2
        L_0x00d9:
            boolean r3 = r9.isMtkImsDataSupport()
            if (r3 == 0) goto L_0x0148
            com.android.internal.telephony.Phone r3 = r9.mPhone
            com.android.internal.telephony.data.AccessNetworksManager r3 = r3.getAccessNetworksManager()
            int r10 = r10.getApnTypeNetworkCapability()
            int r10 = r3.getPreferredTransportByNetworkCapability(r10)
            if (r10 != r0) goto L_0x0108
            java.util.stream.Stream r10 = r1.stream()
            com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda7 r0 = new com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda7
            r0.<init>(r11)
            java.util.stream.Stream r10 = r10.filter(r0)
            java.util.stream.Collector r0 = java.util.stream.Collectors.toList()
            java.lang.Object r10 = r10.collect(r0)
            r1 = r10
            java.util.List r1 = (java.util.List) r1
            goto L_0x0123
        L_0x0108:
            r0 = 2
            if (r10 != r0) goto L_0x0123
            java.util.stream.Stream r10 = r1.stream()
            com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda8 r0 = new com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda8
            r0.<init>(r11)
            java.util.stream.Stream r10 = r10.filter(r0)
            java.util.stream.Collector r0 = java.util.stream.Collectors.toList()
            java.lang.Object r10 = r10.collect(r0)
            r1 = r10
            java.util.List r1 = (java.util.List) r1
        L_0x0123:
            java.util.Iterator r10 = r1.iterator()
        L_0x0127:
            boolean r0 = r10.hasNext()
            if (r0 == 0) goto L_0x0160
            java.lang.Object r0 = r10.next()
            android.telephony.data.DataProfile r0 = (android.telephony.data.DataProfile) r0
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r5 = "The final available profile: "
            r3.append(r5)
            r3.append(r0)
            java.lang.String r0 = r3.toString()
            r9.log(r0)
            goto L_0x0127
        L_0x0148:
            java.util.stream.Stream r10 = r1.stream()
            com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda9 r0 = new com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda9
            r0.<init>(r11)
            java.util.stream.Stream r10 = r10.filter(r0)
            java.util.stream.Collector r0 = java.util.stream.Collectors.toList()
            java.lang.Object r10 = r10.collect(r0)
            r1 = r10
            java.util.List r1 = (java.util.List) r1
        L_0x0160:
            int r10 = r1.size()
            if (r10 != 0) goto L_0x017f
            java.lang.StringBuilder r10 = new java.lang.StringBuilder
            r10.<init>()
            java.lang.String r0 = "Can't find any data profile for network type "
            r10.append(r0)
            java.lang.String r11 = android.telephony.TelephonyManager.getNetworkTypeName(r11)
            r10.append(r11)
            java.lang.String r10 = r10.toString()
            r9.log(r10)
            return r2
        L_0x017f:
            java.util.stream.Stream r10 = r1.stream()
            com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda10 r11 = new com.android.internal.telephony.data.DataProfileManager$$ExternalSyntheticLambda10
            r11.<init>(r9)
            java.util.stream.Stream r10 = r10.filter(r11)
            java.util.stream.Collector r11 = java.util.stream.Collectors.toList()
            java.lang.Object r10 = r10.collect(r11)
            java.util.List r10 = (java.util.List) r10
            int r11 = r10.size()
            if (r11 != 0) goto L_0x01b3
            java.lang.StringBuilder r10 = new java.lang.StringBuilder
            r10.<init>()
            java.lang.String r11 = "Can't find any data profile has APN set id matched. mPreferredDataProfileSetId="
            r10.append(r11)
            int r11 = r9.mPreferredDataProfileSetId
            r10.append(r11)
            java.lang.String r10 = r10.toString()
            r9.log(r10)
            return r2
        L_0x01b3:
            java.lang.Object r9 = r10.get(r4)
            android.telephony.data.DataProfile r9 = (android.telephony.data.DataProfile) r9
            android.telephony.data.ApnSetting r9 = r9.getApnSetting()
            return r9
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.DataProfileManager.getApnSettingForNetworkRequest(com.android.internal.telephony.data.TelephonyNetworkRequest, int):android.telephony.data.ApnSetting");
    }

    /* access modifiers changed from: private */
    public /* synthetic */ Boolean lambda$getApnSettingForNetworkRequest$8(DataProfile dataProfile) {
        return Boolean.valueOf(!dataProfile.equals(this.mPreferredDataProfile));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getApnSettingForNetworkRequest$9(int i, DataProfile dataProfile) {
        return dataProfile.getApnSetting() != null && (dataProfile.getApnSetting().canSupportNetworkType(i) || (dataProfile.canSatisfy(10) && i == 0 && dataProfile.getApnSetting().canSupportNetworkType(13)));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getApnSettingForNetworkRequest$10(int i, DataProfile dataProfile) {
        return dataProfile.getApnSetting() != null && (dataProfile.getApnSetting().canSupportNetworkType(i) || (dataProfile.canSatisfy(10) && i == 0 && dataProfile.getApnSetting().canSupportNetworkType(18)));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$getApnSettingForNetworkRequest$11(int i, DataProfile dataProfile) {
        return dataProfile.getApnSetting() != null && dataProfile.getApnSetting().canSupportNetworkType(i);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$getApnSettingForNetworkRequest$12(DataProfile dataProfile) {
        return dataProfile.getApnSetting() != null && (dataProfile.getApnSetting().getApnSetId() == -1 || dataProfile.getApnSetting().getApnSetId() == this.mPreferredDataProfileSetId);
    }

    public boolean isDataProfilePreferred(DataProfile dataProfile) {
        return dataProfile.equals(this.mPreferredDataProfile);
    }

    public boolean isTetheringDataProfileExisting(int i) {
        if ((!this.mDataConfigManager.isTetheringProfileDisabledForRoaming() || !this.mPhone.getServiceState().getDataRoaming()) && getDataProfileForNetworkRequest(new TelephonyNetworkRequest(new NetworkRequest.Builder().addCapability(2).build(), this.mPhone), i) != null) {
            return true;
        }
        return false;
    }

    public boolean isAnyPreferredDataProfileExisting() {
        for (DataProfile isPreferred : this.mAllDataProfiles) {
            if (isPreferred.isPreferred()) {
                return true;
            }
        }
        return false;
    }

    /* access modifiers changed from: protected */
    public void dedupeDataProfiles(List<DataProfile> list) {
        int i = 0;
        while (i < list.size() - 1) {
            DataProfile dataProfile = list.get(i);
            int i2 = i + 1;
            int i3 = i2;
            while (i3 < list.size()) {
                DataProfile dataProfile2 = list.get(i3);
                DataProfile mergeDataProfiles = mergeDataProfiles(dataProfile, dataProfile2);
                if (mergeDataProfiles != null) {
                    log("Created a merged profile " + mergeDataProfiles + " from " + dataProfile + " and " + dataProfile2);
                    StringBuilder sb = new StringBuilder();
                    sb.append("Merging data profiles will not be supported anymore. Please directly configure the merged profile ");
                    sb.append(mergeDataProfiles);
                    sb.append(" in the APN config.");
                    loge(sb.toString());
                    list.set(i, mergeDataProfiles);
                    list.remove(i3);
                } else {
                    i3++;
                }
            }
            i = i2;
        }
    }

    private static DataProfile mergeDataProfiles(DataProfile dataProfile, DataProfile dataProfile2) {
        Objects.requireNonNull(dataProfile);
        Objects.requireNonNull(dataProfile2);
        if (!Objects.equals(dataProfile.getTrafficDescriptor(), dataProfile2.getTrafficDescriptor()) || dataProfile.getApnSetting() == null || dataProfile2.getApnSetting() == null || !dataProfile.getApnSetting().similar(dataProfile2.getApnSetting())) {
            return null;
        }
        ApnSetting apnSetting = dataProfile.getApnSetting();
        ApnSetting apnSetting2 = dataProfile2.getApnSetting();
        ApnSetting.Builder builder = new ApnSetting.Builder();
        builder.setId(apnSetting.getId());
        builder.setEntryName(apnSetting.getEntryName());
        if (apnSetting2.canHandleType(17) && !apnSetting.canHandleType(17)) {
            builder.setId(apnSetting2.getId());
            builder.setEntryName(apnSetting2.getEntryName());
        }
        builder.setProxyAddress(TextUtils.isEmpty(apnSetting2.getProxyAddressAsString()) ? apnSetting.getProxyAddressAsString() : apnSetting2.getProxyAddressAsString());
        builder.setProxyPort(apnSetting2.getProxyPort() == -1 ? apnSetting.getProxyPort() : apnSetting2.getProxyPort());
        builder.setMmsc(apnSetting2.getMmsc() == null ? apnSetting.getMmsc() : apnSetting2.getMmsc());
        builder.setMmsProxyAddress(TextUtils.isEmpty(apnSetting2.getMmsProxyAddressAsString()) ? apnSetting.getMmsProxyAddressAsString() : apnSetting2.getMmsProxyAddressAsString());
        builder.setMmsProxyPort(apnSetting2.getMmsProxyPort() == -1 ? apnSetting.getMmsProxyPort() : apnSetting2.getMmsProxyPort());
        builder.setUser(TextUtils.isEmpty(apnSetting2.getUser()) ? apnSetting.getUser() : apnSetting2.getUser());
        builder.setPassword(TextUtils.isEmpty(apnSetting2.getPassword()) ? apnSetting.getPassword() : apnSetting2.getPassword());
        builder.setAuthType(apnSetting2.getAuthType() == -1 ? apnSetting.getAuthType() : apnSetting2.getAuthType());
        builder.setApnTypeBitmask(apnSetting.getApnTypeBitmask() | apnSetting2.getApnTypeBitmask());
        builder.setMtuV4(apnSetting2.getMtuV4() <= 0 ? apnSetting.getMtuV4() : apnSetting2.getMtuV4());
        builder.setMtuV6(apnSetting2.getMtuV6() <= 0 ? apnSetting.getMtuV6() : apnSetting2.getMtuV6());
        builder.setApnName(apnSetting.getApnName());
        builder.setProtocol(apnSetting.getProtocol());
        builder.setRoamingProtocol(apnSetting.getRoamingProtocol());
        builder.setCarrierEnabled(apnSetting.isEnabled());
        builder.setNetworkTypeBitmask(apnSetting.getNetworkTypeBitmask());
        builder.setLingeringNetworkTypeBitmask(apnSetting.getLingeringNetworkTypeBitmask());
        builder.setProfileId(apnSetting.getProfileId());
        builder.setPersistent(apnSetting.isPersistent());
        builder.setMaxConns(apnSetting.getMaxConns());
        builder.setWaitTime(apnSetting.getWaitTime());
        builder.setMaxConnsTime(apnSetting.getMaxConnsTime());
        builder.setMvnoType(apnSetting.getMvnoType());
        builder.setMvnoMatchData(apnSetting.getMvnoMatchData());
        builder.setApnSetId(apnSetting.getApnSetId());
        builder.setCarrierId(apnSetting.getCarrierId());
        builder.setSkip464Xlat(apnSetting.getSkip464Xlat());
        builder.setAlwaysOn(apnSetting.isAlwaysOn());
        return new DataProfile.Builder().setApnSetting(builder.build()).setTrafficDescriptor(dataProfile.getTrafficDescriptor()).build();
    }

    public boolean isDataProfileCompatible(DataProfile dataProfile) {
        if (dataProfile == null) {
            return false;
        }
        if (dataProfile.getApnSetting() != null || dataProfile.getTrafficDescriptor() == null) {
            return this.mAllDataProfiles.stream().filter(new DataProfileManager$$ExternalSyntheticLambda16()).anyMatch(new DataProfileManager$$ExternalSyntheticLambda17(this, dataProfile));
        }
        return true;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$isDataProfileCompatible$13(DataProfile dataProfile) {
        return dataProfile.getApnSetting() != null;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$isDataProfileCompatible$14(DataProfile dataProfile, DataProfile dataProfile2) {
        return dataProfile2.getApnSetting().equals(dataProfile.getApnSetting(), this.mPhone.getServiceState().getDataRoamingFromRegistration());
    }

    public void registerCallback(DataProfileManagerCallback dataProfileManagerCallback) {
        this.mDataProfileManagerCallbacks.add(dataProfileManagerCallback);
    }

    public void unregisterCallback(DataProfileManagerCallback dataProfileManagerCallback) {
        this.mDataProfileManagerCallbacks.remove(dataProfileManagerCallback);
    }

    private boolean isMtkImsDataSupport() {
        return "0".equals(SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0")) || "1".equals(SystemProperties.get("ro.mtk.ims.data.feature_support"));
    }

    private void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    private void logv(String str) {
        Rlog.v(this.mLogTag, str);
    }

    /* access modifiers changed from: protected */
    public void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(DataProfileManager.class.getSimpleName() + "-" + this.mPhone.getPhoneId() + ":");
        androidUtilIndentingPrintWriter.increaseIndent();
        androidUtilIndentingPrintWriter.println("Data profiles for the current carrier:");
        androidUtilIndentingPrintWriter.increaseIndent();
        for (DataProfile next : this.mAllDataProfiles) {
            androidUtilIndentingPrintWriter.print(next);
            androidUtilIndentingPrintWriter.println(", last setup time: " + DataUtils.elapsedTimeToString(next.getLastSetupTimestamp()));
        }
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println("Preferred data profile=" + this.mPreferredDataProfile);
        androidUtilIndentingPrintWriter.println("Preferred data profile from db=" + getPreferredDataProfileFromDb());
        androidUtilIndentingPrintWriter.println("Preferred data profile from config=" + getPreferredDataProfileFromConfig());
        androidUtilIndentingPrintWriter.println("Preferred data profile set id=" + this.mPreferredDataProfileSetId);
        androidUtilIndentingPrintWriter.println("Initial attach data profile=" + this.mInitialAttachDataProfile);
        androidUtilIndentingPrintWriter.println("isTetheringDataProfileExisting=" + isTetheringDataProfileExisting(13));
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
    }
}
