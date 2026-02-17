.class public Lcom/android/internal/telephony/SmsPermissions;
.super Ljava/lang/Object;
.source "SmsPermissions.java"


# static fields
.field static final LOG_TAG:Ljava/lang/String; = "SmsPermissions"


# instance fields
.field private final mAppOps:Landroid/app/AppOpsManager;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mContext:Landroid/content/Context;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mPhone:Lcom/android/internal/telephony/Phone;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/Phone;Landroid/content/Context;Landroid/app/AppOpsManager;)V
    .locals 0

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    iput-object p1, p0, Lcom/android/internal/telephony/SmsPermissions;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 46
    iput-object p2, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    .line 47
    iput-object p3, p0, Lcom/android/internal/telephony/SmsPermissions;->mAppOps:Landroid/app/AppOpsManager;

    return-void
.end method


# virtual methods
.method public checkCallingCanSendSms(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 8

    .line 104
    iget-object v0, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    const-string v1, "android.permission.SEND_SMS"

    invoke-virtual {v0, v1, p3}, Landroid/content/Context;->enforceCallingPermission(Ljava/lang/String;Ljava/lang/String;)V

    .line 105
    iget-object v2, p0, Lcom/android/internal/telephony/SmsPermissions;->mAppOps:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v4

    const-string v3, "android:send_sms"

    const/4 v7, 0x0

    move-object v5, p1

    move-object v6, p2

    invoke-virtual/range {v2 .. v7}, Landroid/app/AppOpsManager;->noteOp(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public checkCallingCanSendText(ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 1

    if-nez p1, :cond_0

    .line 67
    :try_start_0
    invoke-virtual {p0, p4}, Lcom/android/internal/telephony/SmsPermissions;->enforceCallerIsImsAppOrCarrierApp(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p0, 0x1

    return p0

    .line 71
    :catch_0
    iget-object p1, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    const-string v0, "android.permission.MODIFY_PHONE_STATE"

    invoke-virtual {p1, v0, p4}, Landroid/content/Context;->enforceCallingPermission(Ljava/lang/String;Ljava/lang/String;)V

    .line 75
    :cond_0
    invoke-virtual {p0, p2, p3, p4}, Lcom/android/internal/telephony/SmsPermissions;->checkCallingCanSendSms(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public checkCallingOrSelfCanGetSmscAddress(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 135
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SmsPermissions;->isCallerDefaultSmsPackage(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 136
    iget-object p1, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    iget-object p0, p0, Lcom/android/internal/telephony/SmsPermissions;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 138
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    .line 137
    invoke-static {p1, p0, p2}, Lcom/android/internal/telephony/TelephonyPermissions;->enforceCallingOrSelfReadPrivilegedPhoneStatePermissionOrCarrierPrivilege(Landroid/content/Context;ILjava/lang/String;)V

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method public checkCallingOrSelfCanSendSms(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 8

    .line 118
    iget-object v0, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    const-string v1, "android.permission.SEND_SMS"

    invoke-virtual {v0, v1, p3}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    .line 119
    iget-object v2, p0, Lcom/android/internal/telephony/SmsPermissions;->mAppOps:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v4

    const-string v3, "android:send_sms"

    const/4 v7, 0x0

    move-object v5, p1

    move-object v6, p2

    invoke-virtual/range {v2 .. v7}, Landroid/app/AppOpsManager;->noteOp(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public checkCallingOrSelfCanSetSmscAddress(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 154
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SmsPermissions;->isCallerDefaultSmsPackage(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 156
    iget-object p1, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    iget-object p0, p0, Lcom/android/internal/telephony/SmsPermissions;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 157
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    .line 156
    invoke-static {p1, p0, p2}, Lcom/android/internal/telephony/TelephonyPermissions;->enforceCallingOrSelfModifyPermissionOrCarrierPrivilege(Landroid/content/Context;ILjava/lang/String;)V

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method public enforceCallerIsImsAppOrCarrierApp(Ljava/lang/String;)V
    .locals 4

    .line 86
    iget-object v0, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lcom/android/internal/telephony/SmsPermissions;->mPhone:Lcom/android/internal/telephony/Phone;

    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.service.carrier.CarrierMessagingService"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-static {v0, v1, v2}, Lcom/android/internal/telephony/CarrierSmsUtils;->getImsRcsPackageForIntent(Landroid/content/Context;Lcom/android/internal/telephony/Phone;Landroid/content/Intent;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 88
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/SmsPermissions;->packageNameMatchesCallingUid(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 91
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    iget-object p0, p0, Lcom/android/internal/telephony/SmsPermissions;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 92
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    .line 91
    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/TelephonyPermissions;->enforceCallingOrSelfCarrierPrivilege(Landroid/content/Context;ILjava/lang/String;)V

    return-void
.end method

.method public isCallerDefaultSmsPackage(Ljava/lang/String;)Z
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 165
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SmsPermissions;->packageNameMatchesCallingUid(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 166
    iget-object p0, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/SmsApplication;->isDefaultSmsApplication(Landroid/content/Context;Ljava/lang/String;)Z

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method protected log(Ljava/lang/String;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const-string p0, "SmsPermissions"

    .line 190
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 0

    const-string p0, "SmsPermissions"

    .line 194
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 0

    const-string p0, "SmsPermissions"

    .line 198
    invoke-static {p0, p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method public packageNameMatchesCallingUid(Ljava/lang/String;)Z
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 179
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/SmsPermissions;->mContext:Landroid/content/Context;

    const-string v0, "appops"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/AppOpsManager;

    .line 180
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v0

    invoke-virtual {p0, v0, p1}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p0, 0x1

    return p0

    :catch_0
    const/4 p0, 0x0

    return p0
.end method
