package com.android.internal.telephony;

import android.app.AppOpsManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import com.android.internal.annotations.VisibleForTesting;
import com.android.telephony.Rlog;

public class SmsPermissions {
    static final String LOG_TAG = "SmsPermissions";
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final AppOpsManager mAppOps;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final Context mContext;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private final Phone mPhone;

    public SmsPermissions(Phone phone, Context context, AppOpsManager appOpsManager) {
        this.mPhone = phone;
        this.mContext = context;
        this.mAppOps = appOpsManager;
    }

    public boolean checkCallingCanSendText(boolean z, String str, String str2, String str3) {
        if (!z) {
            try {
                enforceCallerIsImsAppOrCarrierApp(str3);
                return true;
            } catch (SecurityException unused) {
                this.mContext.enforceCallingPermission("android.permission.MODIFY_PHONE_STATE", str3);
            }
        }
        return checkCallingCanSendSms(str, str2, str3);
    }

    public void enforceCallerIsImsAppOrCarrierApp(String str) {
        String imsRcsPackageForIntent = CarrierSmsUtils.getImsRcsPackageForIntent(this.mContext, this.mPhone, new Intent("android.service.carrier.CarrierMessagingService"));
        if (imsRcsPackageForIntent == null || !packageNameMatchesCallingUid(imsRcsPackageForIntent)) {
            TelephonyPermissions.enforceCallingOrSelfCarrierPrivilege(this.mContext, this.mPhone.getSubId(), str);
        }
    }

    public boolean checkCallingCanSendSms(String str, String str2, String str3) {
        this.mContext.enforceCallingPermission("android.permission.SEND_SMS", str3);
        return this.mAppOps.noteOp("android:send_sms", Binder.getCallingUid(), str, str2, (String) null) == 0;
    }

    public boolean checkCallingOrSelfCanSendSms(String str, String str2, String str3) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.SEND_SMS", str3);
        return this.mAppOps.noteOp("android:send_sms", Binder.getCallingUid(), str, str2, (String) null) == 0;
    }

    public boolean checkCallingOrSelfCanGetSmscAddress(String str, String str2) {
        if (isCallerDefaultSmsPackage(str)) {
            return true;
        }
        TelephonyPermissions.enforceCallingOrSelfReadPrivilegedPhoneStatePermissionOrCarrierPrivilege(this.mContext, this.mPhone.getSubId(), str2);
        return true;
    }

    public boolean checkCallingOrSelfCanSetSmscAddress(String str, String str2) {
        if (isCallerDefaultSmsPackage(str)) {
            return true;
        }
        TelephonyPermissions.enforceCallingOrSelfModifyPermissionOrCarrierPrivilege(this.mContext, this.mPhone.getSubId(), str2);
        return true;
    }

    @VisibleForTesting
    public boolean isCallerDefaultSmsPackage(String str) {
        if (packageNameMatchesCallingUid(str)) {
            return SmsApplication.isDefaultSmsApplication(this.mContext, str);
        }
        return false;
    }

    @VisibleForTesting
    public boolean packageNameMatchesCallingUid(String str) {
        try {
            ((AppOpsManager) this.mContext.getSystemService("appops")).checkPackage(Binder.getCallingUid(), str);
            return true;
        } catch (SecurityException unused) {
            return false;
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str, Throwable th) {
        Rlog.e(LOG_TAG, str, th);
    }
}
