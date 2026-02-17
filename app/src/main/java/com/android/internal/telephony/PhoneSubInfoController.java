package com.android.internal.telephony;

import android.app.AppOpsManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.Binder;
import android.os.RemoteException;
import android.os.TelephonyServiceManager;
import android.telephony.ImsiEncryptionInfo;
import android.telephony.PhoneNumberUtils;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyFrameworkInitializer;
import android.util.EventLog;
import com.android.internal.telephony.IPhoneSubInfo;
import com.android.internal.telephony.uicc.IsimRecords;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.telephony.Rlog;

public class PhoneSubInfoController extends IPhoneSubInfo.Stub {
    private static final boolean DBG = true;
    private static final String TAG = "PhoneSubInfoController";
    private static final boolean VDBG = false;
    private AppOpsManager mAppOps;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final Context mContext;

    private interface CallPhoneMethodHelper<T> {
        T callMethod(Phone phone);
    }

    private interface PermissionCheckHelper {
        boolean checkPermission(Context context, int i, String str, String str2, String str3);
    }

    /* JADX WARNING: type inference failed for: r2v0, types: [com.android.internal.telephony.PhoneSubInfoController, android.os.IBinder] */
    public PhoneSubInfoController(Context context) {
        TelephonyServiceManager.ServiceRegisterer phoneSubServiceRegisterer = TelephonyFrameworkInitializer.getTelephonyServiceManager().getPhoneSubServiceRegisterer();
        if (phoneSubServiceRegisterer.get() == null) {
            phoneSubServiceRegisterer.register(this);
        }
        this.mAppOps = (AppOpsManager) context.getSystemService(AppOpsManager.class);
        this.mContext = context;
    }

    @Deprecated
    public String getDeviceId(String str) {
        return getDeviceIdWithFeature(str, (String) null);
    }

    public String getDeviceIdWithFeature(String str, String str2) {
        return getDeviceIdForPhone(SubscriptionManager.getPhoneId(getDefaultSubscription()), str, str2);
    }

    public String getDeviceIdForPhone(int i, String str, String str2) {
        enforceCallingPackageUidMatched(str);
        return (String) callPhoneMethodForPhoneIdWithReadDeviceIdentifiersCheck(i, str, str2, "getDeviceId", new PhoneSubInfoController$$ExternalSyntheticLambda21());
    }

    public String getNaiForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(i, str, str2, "getNai", new PhoneSubInfoController$$ExternalSyntheticLambda26());
    }

    public String getImeiForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadDeviceIdentifiersCheck(i, str, str2, "getImei", new PhoneSubInfoController$$ExternalSyntheticLambda14());
    }

    public ImsiEncryptionInfo getCarrierInfoForImsiEncryption(int i, int i2, String str) {
        return (ImsiEncryptionInfo) callPhoneMethodForSubIdWithPrivilegedCheck(i, "getCarrierInfoForImsiEncryption", new PhoneSubInfoController$$ExternalSyntheticLambda24(i2));
    }

    public void setCarrierInfoForImsiEncryption(int i, String str, ImsiEncryptionInfo imsiEncryptionInfo) {
        callPhoneMethodForSubIdWithModifyCheck(i, str, "setCarrierInfoForImsiEncryption", new PhoneSubInfoController$$ExternalSyntheticLambda11(imsiEncryptionInfo));
    }

    public void resetCarrierKeysForImsiEncryption(int i, String str) {
        callPhoneMethodForSubIdWithModifyCheck(i, str, "resetCarrierKeysForImsiEncryption", new PhoneSubInfoController$$ExternalSyntheticLambda9());
    }

    public String getDeviceSvn(String str, String str2) {
        return getDeviceSvnUsingSubId(getDefaultSubscription(), str, str2);
    }

    public String getDeviceSvnUsingSubId(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadCheck(i, str, str2, "getDeviceSvn", new PhoneSubInfoController$$ExternalSyntheticLambda17());
    }

    @Deprecated
    public String getSubscriberId(String str) {
        return getSubscriberIdWithFeature(str, (String) null);
    }

    public String getSubscriberIdWithFeature(String str, String str2) {
        return getSubscriberIdForSubscriber(getDefaultSubscription(), str, str2);
    }

    public String getSubscriberIdForSubscriber(int i, String str, String str2) {
        enforceCallingPackage(str, Binder.getCallingUid(), "getSubscriberIdForSubscriber");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            if (SubscriptionController.getInstance().isActiveSubId(i, str, str2)) {
                return (String) callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(i, str, str2, "getSubscriberIdForSubscriber", new PhoneSubInfoController$$ExternalSyntheticLambda15());
            } else if (!TelephonyPermissions.checkCallingOrSelfReadSubscriberIdentifiers(this.mContext, i, str, str2, "getSubscriberIdForSubscriber")) {
                return null;
            } else {
                long clearCallingIdentity2 = Binder.clearCallingIdentity();
                try {
                    return SubscriptionController.getInstance().getImsiPrivileged(i);
                } finally {
                    Binder.restoreCallingIdentity(clearCallingIdentity2);
                }
            }
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    @Deprecated
    public String getIccSerialNumber(String str) {
        return getIccSerialNumberWithFeature(str, (String) null);
    }

    public String getIccSerialNumberWithFeature(String str, String str2) {
        return getIccSerialNumberForSubscriber(getDefaultSubscription(), str, str2);
    }

    public String getIccSerialNumberForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(i, str, str2, "getIccSerialNumber", new PhoneSubInfoController$$ExternalSyntheticLambda5());
    }

    public String getLine1Number(String str, String str2) {
        return getLine1NumberForSubscriber(getDefaultSubscription(), str, str2);
    }

    public String getLine1NumberForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadPhoneNumberCheck(i, str, str2, "getLine1Number", new PhoneSubInfoController$$ExternalSyntheticLambda1());
    }

    public String getLine1AlphaTag(String str, String str2) {
        return getLine1AlphaTagForSubscriber(getDefaultSubscription(), str, str2);
    }

    public String getLine1AlphaTagForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadCheck(i, str, str2, "getLine1AlphaTag", new PhoneSubInfoController$$ExternalSyntheticLambda6());
    }

    public String getMsisdn(String str, String str2) {
        return getMsisdnForSubscriber(getDefaultSubscription(), str, str2);
    }

    public String getMsisdnForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadPhoneNumberCheck(i, str, str2, "getMsisdn", new PhoneSubInfoController$$ExternalSyntheticLambda10());
    }

    public String getVoiceMailNumber(String str, String str2) {
        return getVoiceMailNumberForSubscriber(getDefaultSubscription(), str, str2);
    }

    public String getVoiceMailNumberForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadCheck(i, str, str2, "getVoiceMailNumber", new PhoneSubInfoController$$ExternalSyntheticLambda12(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ String lambda$getVoiceMailNumberForSubscriber$12(Phone phone) {
        return PhoneNumberUtils.extractNetworkPortion(phone.getVoiceMailNumber());
    }

    public String getVoiceMailAlphaTag(String str, String str2) {
        return getVoiceMailAlphaTagForSubscriber(getDefaultSubscription(), str, str2);
    }

    public String getVoiceMailAlphaTagForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadCheck(i, str, str2, "getVoiceMailAlphaTag", new PhoneSubInfoController$$ExternalSyntheticLambda19());
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private Phone getPhone(int i) {
        int phoneId = SubscriptionManager.getPhoneId(i);
        if (!SubscriptionManager.isValidPhoneId(phoneId)) {
            return null;
        }
        return PhoneFactory.getPhone(phoneId);
    }

    private void enforceCallingPackageUidMatched(String str) {
        try {
            this.mAppOps.checkPackage(Binder.getCallingUid(), str);
        } catch (SecurityException e) {
            EventLog.writeEvent(1397638484, new Object[]{"188677422", Integer.valueOf(Binder.getCallingUid())});
            throw e;
        }
    }

    /* access modifiers changed from: private */
    public boolean enforceIccSimChallengeResponsePermission(Context context, int i, String str, String str2, String str3) {
        if (TelephonyPermissions.checkCallingOrSelfUseIccAuthWithDeviceIdentifier(context, str, str2, str3)) {
            return true;
        }
        enforcePrivilegedPermissionOrCarrierPrivilege(i, str3);
        return true;
    }

    private void enforcePrivilegedPermissionOrCarrierPrivilege(int i, String str) {
        if (this.mContext.checkCallingOrSelfPermission("android.permission.READ_PRIVILEGED_PHONE_STATE") != 0) {
            TelephonyPermissions.enforceCallingOrSelfCarrierPrivilege(this.mContext, i, str);
        }
    }

    private void enforceModifyPermission() {
        this.mContext.enforceCallingOrSelfPermission("android.permission.MODIFY_PHONE_STATE", "Requires MODIFY_PHONE_STATE");
    }

    /* JADX WARNING: Removed duplicated region for block: B:7:0x0019 A[RETURN] */
    /* JADX WARNING: Removed duplicated region for block: B:8:0x001a  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void enforceCallingPackage(java.lang.String r3, int r4, java.lang.String r5) {
        /*
            r2 = this;
            android.content.Context r2 = r2.mContext
            android.os.UserHandle r0 = android.os.UserHandle.getUserHandleForUid(r4)
            r1 = 0
            android.content.Context r2 = r2.createContextAsUser(r0, r1)
            android.content.pm.PackageManager r2 = r2.getPackageManager()
            if (r2 == 0) goto L_0x0016
            int r2 = r2.getPackageUid(r3, r1)     // Catch:{ NameNotFoundException -> 0x0016 }
            goto L_0x0017
        L_0x0016:
            r2 = -1
        L_0x0017:
            if (r2 != r4) goto L_0x001a
            return
        L_0x001a:
            java.lang.SecurityException r2 = new java.lang.SecurityException
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            r0.append(r5)
            java.lang.String r5 = ": Package "
            r0.append(r5)
            r0.append(r3)
            java.lang.String r3 = " does not belong to "
            r0.append(r3)
            r0.append(r4)
            java.lang.String r3 = r0.toString()
            r2.<init>(r3)
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.PhoneSubInfoController.enforceCallingPackage(java.lang.String, int, java.lang.String):void");
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private int getDefaultSubscription() {
        return PhoneFactory.getDefaultSubscription();
    }

    public String getIsimImpi(int i) {
        return (String) callPhoneMethodForSubIdWithPrivilegedCheck(i, "getIsimImpi", new PhoneSubInfoController$$ExternalSyntheticLambda8());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String lambda$getIsimImpi$14(Phone phone) {
        IsimRecords isimRecords = phone.getIsimRecords();
        if (isimRecords != null) {
            return isimRecords.getIsimImpi();
        }
        return null;
    }

    public String getIsimDomain(int i) {
        return (String) callPhoneMethodForSubIdWithPrivilegedCheck(i, "getIsimDomain", new PhoneSubInfoController$$ExternalSyntheticLambda13());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String lambda$getIsimDomain$15(Phone phone) {
        IsimRecords isimRecords = phone.getIsimRecords();
        if (isimRecords != null) {
            return isimRecords.getIsimDomain();
        }
        return null;
    }

    public String[] getIsimImpu(int i) {
        return (String[]) callPhoneMethodForSubIdWithPrivilegedCheck(i, "getIsimImpu", new PhoneSubInfoController$$ExternalSyntheticLambda7());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String[] lambda$getIsimImpu$16(Phone phone) {
        IsimRecords isimRecords = phone.getIsimRecords();
        if (isimRecords != null) {
            return isimRecords.getIsimImpu();
        }
        return null;
    }

    public String getIsimIst(int i) throws RemoteException {
        return (String) callPhoneMethodForSubIdWithPrivilegedCheck(i, "getIsimIst", new PhoneSubInfoController$$ExternalSyntheticLambda4());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String lambda$getIsimIst$17(Phone phone) {
        IsimRecords isimRecords = phone.getIsimRecords();
        if (isimRecords != null) {
            return isimRecords.getIsimIst();
        }
        return null;
    }

    public String[] getIsimPcscf(int i) throws RemoteException {
        return (String[]) callPhoneMethodForSubIdWithPrivilegedCheck(i, "getIsimPcscf", new PhoneSubInfoController$$ExternalSyntheticLambda25());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String[] lambda$getIsimPcscf$18(Phone phone) {
        IsimRecords isimRecords = phone.getIsimRecords();
        if (isimRecords != null) {
            return isimRecords.getIsimPcscf();
        }
        return null;
    }

    public String getIccSimChallengeResponse(int i, int i2, int i3, String str, String str2, String str3) throws RemoteException {
        return (String) callPhoneMethodWithPermissionCheck(i, str2, str3, "getIccSimChallengeResponse", new PhoneSubInfoController$$ExternalSyntheticLambda2(this, i2, i3, str), new PhoneSubInfoController$$ExternalSyntheticLambda3(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ String lambda$getIccSimChallengeResponse$19(int i, int i2, String str, Phone phone) {
        UiccPort uiccPort = phone.getUiccPort();
        if (uiccPort == null) {
            loge("getIccSimChallengeResponse() uiccPort is null");
            return null;
        }
        UiccCardApplication applicationByType = uiccPort.getApplicationByType(i);
        if (applicationByType == null) {
            loge("getIccSimChallengeResponse() no app with specified type -- " + i);
            return null;
        }
        loge("getIccSimChallengeResponse() found app " + applicationByType.getAid() + " specified type -- " + i);
        if (i2 == 128 || i2 == 129) {
            return applicationByType.getIccRecords().getIccSimChallengeResponse(i2, str);
        }
        loge("getIccSimChallengeResponse() unsupported authType: " + i2);
        return null;
    }

    public String getGroupIdLevel1ForSubscriber(int i, String str, String str2) {
        return (String) callPhoneMethodForSubIdWithReadCheck(i, str, str2, "getGroupIdLevel1", new PhoneSubInfoController$$ExternalSyntheticLambda22());
    }

    private <T> T callPhoneMethodWithPermissionCheck(int i, String str, String str2, String str3, CallPhoneMethodHelper<T> callPhoneMethodHelper, PermissionCheckHelper permissionCheckHelper) {
        if (!permissionCheckHelper.checkPermission(this.mContext, i, str, str2, str3)) {
            return null;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            Phone phone = getPhone(i);
            if (phone != null) {
                return callPhoneMethodHelper.callMethod(phone);
            }
            loge(str3 + " phone is null for Subscription:" + i);
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return null;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    private <T> T callPhoneMethodForSubIdWithReadCheck(int i, String str, String str2, String str3, CallPhoneMethodHelper<T> callPhoneMethodHelper) {
        return callPhoneMethodWithPermissionCheck(i, str, str2, str3, callPhoneMethodHelper, new PhoneSubInfoController$$ExternalSyntheticLambda27());
    }

    private <T> T callPhoneMethodForSubIdWithReadDeviceIdentifiersCheck(int i, String str, String str2, String str3, CallPhoneMethodHelper<T> callPhoneMethodHelper) {
        return callPhoneMethodWithPermissionCheck(i, str, str2, str3, callPhoneMethodHelper, new PhoneSubInfoController$$ExternalSyntheticLambda20());
    }

    private <T> T callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(int i, String str, String str2, String str3, CallPhoneMethodHelper<T> callPhoneMethodHelper) {
        return callPhoneMethodWithPermissionCheck(i, str, str2, str3, callPhoneMethodHelper, new PhoneSubInfoController$$ExternalSyntheticLambda16());
    }

    private <T> T callPhoneMethodForSubIdWithPrivilegedCheck(int i, String str, CallPhoneMethodHelper<T> callPhoneMethodHelper) {
        return callPhoneMethodWithPermissionCheck(i, (String) null, (String) null, str, callPhoneMethodHelper, new PhoneSubInfoController$$ExternalSyntheticLambda0(this, str));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$callPhoneMethodForSubIdWithPrivilegedCheck$24(String str, Context context, int i, String str2, String str3, String str4) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.READ_PRIVILEGED_PHONE_STATE", str);
        return true;
    }

    private <T> T callPhoneMethodForSubIdWithModifyCheck(int i, String str, String str2, CallPhoneMethodHelper<T> callPhoneMethodHelper) {
        return callPhoneMethodWithPermissionCheck(i, (String) null, (String) null, str2, callPhoneMethodHelper, new PhoneSubInfoController$$ExternalSyntheticLambda18(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$callPhoneMethodForSubIdWithModifyCheck$25(Context context, int i, String str, String str2, String str3) {
        enforceModifyPermission();
        return true;
    }

    private <T> T callPhoneMethodForSubIdWithReadPhoneNumberCheck(int i, String str, String str2, String str3, CallPhoneMethodHelper<T> callPhoneMethodHelper) {
        return callPhoneMethodWithPermissionCheck(i, str, str2, str3, callPhoneMethodHelper, new PhoneSubInfoController$$ExternalSyntheticLambda23());
    }

    private <T> T callPhoneMethodForPhoneIdWithReadDeviceIdentifiersCheck(int i, String str, String str2, String str3, CallPhoneMethodHelper<T> callPhoneMethodHelper) {
        if (!SubscriptionManager.isValidPhoneId(i)) {
            i = 0;
        }
        Phone phone = PhoneFactory.getPhone(i);
        if (phone == null || !TelephonyPermissions.checkCallingOrSelfReadDeviceIdentifiers(this.mContext, phone.getSubId(), str, str2, str3)) {
            return null;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            return callPhoneMethodHelper.callMethod(phone);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    private void log(String str) {
        Rlog.d(TAG, str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void loge(String str) {
        Rlog.e(TAG, str);
    }
}
