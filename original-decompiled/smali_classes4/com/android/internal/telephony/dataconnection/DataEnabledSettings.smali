.class public Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;
.super Ljava/lang/Object;
.source "DataEnabledSettings.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$DataEnabledChangedReason;
    }
.end annotation


# static fields
.field private static final LOG_TAG:Ljava/lang/String; = "DataEnabledSettings"

.field public static final REASON_DATA_ENABLED_BY_CARRIER:I = 0x4

.field public static final REASON_INTERNAL_DATA_ENABLED:I = 0x1

.field public static final REASON_OVERRIDE_CONDITION_CHANGED:I = 0x8

.field public static final REASON_OVERRIDE_RULE_CHANGED:I = 0x7

.field public static final REASON_POLICY_DATA_ENABLED:I = 0x3

.field public static final REASON_PROVISIONED_CHANGED:I = 0x5

.field public static final REASON_PROVISIONING_DATA_ENABLED_CHANGED:I = 0x6

.field public static final REASON_REGISTERED:I = 0x0

.field public static final REASON_THERMAL_DATA_ENABLED:I = 0x9

.field public static final REASON_USER_DATA_ENABLED:I = 0x2


# instance fields
.field private mCarrierDataEnabled:Z

.field private mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

.field private mInternalDataEnabled:Z

.field private mIsDataEnabled:Z

.field private final mOnSubscriptionsChangeListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

.field private final mOverallDataEnabledChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private final mOverallDataEnabledOverrideChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mPhoneStateListener:Landroid/telephony/PhoneStateListener;

.field private mPolicyDataEnabled:Z

.field private mResolver:Landroid/content/ContentResolver;

.field private final mSettingChangeLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private mSubId:I

.field private mTelephonyManager:Landroid/telephony/TelephonyManager;

.field private mThermalDataEnabled:Z


# direct methods
.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSubId(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSubId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmDataEnabledOverride(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;Lcom/android/internal/telephony/data/DataEnabledOverride;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmSubId(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSubId:I

    return-void
.end method

.method static bridge synthetic -$$Nest$mgetDataEnabledOverride(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;)Lcom/android/internal/telephony/data/DataEnabledOverride;
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->getDataEnabledOverride()Lcom/android/internal/telephony/data/DataEnabledOverride;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->log(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateDataEnabledAndNotify(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdatePhoneStateListener(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updatePhoneStateListener()V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 3

    .line 193
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 102
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mInternalDataEnabled:Z

    .line 107
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPolicyDataEnabled:Z

    .line 113
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mCarrierDataEnabled:Z

    .line 118
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mThermalDataEnabled:Z

    const/4 v0, 0x0

    .line 124
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mIsDataEnabled:Z

    const/4 v0, -0x1

    .line 128
    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSubId:I

    const/4 v0, 0x0

    .line 130
    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mResolver:Landroid/content/ContentResolver;

    .line 132
    new-instance v0, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v0}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 136
    new-instance v0, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v0}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledOverrideChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 139
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x20

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSettingChangeLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 146
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$1;-><init>(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;)V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOnSubscriptionsChangeListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

    .line 173
    new-instance v1, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$2;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$2;-><init>(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;)V

    iput-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhoneStateListener:Landroid/telephony/PhoneStateListener;

    .line 194
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 195
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mResolver:Landroid/content/ContentResolver;

    .line 196
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string/jumbo v2, "telephony_subscription_service"

    .line 197
    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/SubscriptionManager;

    .line 198
    invoke-virtual {v1, v0}, Landroid/telephony/SubscriptionManager;->addOnSubscriptionsChangedListener(Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;)V

    .line 199
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    const-string v0, "phone"

    .line 200
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/TelephonyManager;

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    .line 201
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->getDataEnabledOverride()Lcom/android/internal/telephony/data/DataEnabledOverride;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    .line 202
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabled()V

    return-void
.end method

.method private getDataEnabledOverride()Lcom/android/internal/telephony/data/DataEnabledOverride;
    .locals 2

    .line 206
    new-instance v0, Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v1

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 207
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/SubscriptionController;->getDataEnabledOverrideRules(I)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataEnabledOverride;-><init>(Ljava/lang/String;)V

    return-object v0
.end method

.method private static isStandAloneOpportunistic(ILandroid/content/Context;)Z
    .locals 2

    .line 535
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    .line 536
    invoke-virtual {p1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object p1

    .line 535
    invoke-virtual {v0, p0, v1, p1}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubscriptionInfo(ILjava/lang/String;Ljava/lang/String;)Landroid/telephony/SubscriptionInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 537
    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->isOpportunistic()Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getGroupUuid()Landroid/os/ParcelUuid;

    move-result-object p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private localLog(Ljava/lang/String;Z)V
    .locals 1

    .line 559
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSettingChangeLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " change to "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 2

    .line 555
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "DataEnabledSettings"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private notifyDataEnabledChanged(ZI)V
    .locals 4

    .line 497
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v1, Landroid/util/Pair;

    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-direct {v1, v2, v3}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    .line 498
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/Phone;->notifyDataEnabled(ZI)V

    return-void
.end method

.method private notifyDataEnabledOverrideChanged()V
    .locals 0

    .line 511
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledOverrideChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    return-void
.end method

.method private declared-synchronized setCarrierDataEnabled(Z)V
    .locals 1

    monitor-enter p0

    .line 360
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mCarrierDataEnabled:Z

    if-eq v0, p1, :cond_0

    const-string v0, "CarrierDataEnabled"

    .line 361
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 362
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mCarrierDataEnabled:Z

    const/4 p1, 0x4

    .line 363
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 365
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized setPolicyDataEnabled(Z)V
    .locals 1

    monitor-enter p0

    .line 348
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPolicyDataEnabled:Z

    if-eq v0, p1, :cond_0

    const-string v0, "PolicyDataEnabled"

    .line 349
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 350
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPolicyDataEnabled:Z

    const/4 p1, 0x3

    .line 351
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 353
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized setThermalDataEnabled(Z)V
    .locals 1

    monitor-enter p0

    .line 372
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mThermalDataEnabled:Z

    if-eq v0, p1, :cond_0

    const-string v0, "ThermalDataEnabled"

    .line 373
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 374
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mThermalDataEnabled:Z

    const/16 p1, 0x9

    .line 375
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 377
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized setUserDataEnabled(Z)V
    .locals 1

    monitor-enter p0

    const/4 v0, 0x1

    .line 223
    :try_start_0
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setUserDataEnabled(ZZ)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 224
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized updateDataEnabled()V
    .locals 3

    monitor-enter p0

    .line 427
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isProvisioning()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 428
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isProvisioningDataEnabled()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mIsDataEnabled:Z

    goto :goto_1

    .line 430
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mInternalDataEnabled:Z

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isUserDataEnabled()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    const/16 v2, 0xff

    .line 431
    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/data/DataEnabledOverride;->shouldOverrideDataEnabledSettings(Lcom/android/internal/telephony/Phone;I)Z

    move-result v0

    if-eqz v0, :cond_2

    :cond_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPolicyDataEnabled:Z

    if-eqz v0, :cond_2

    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mCarrierDataEnabled:Z

    if-eqz v0, :cond_2

    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mThermalDataEnabled:Z

    if-eqz v0, :cond_2

    const/4 v0, 0x1

    goto :goto_0

    :cond_2
    const/4 v0, 0x0

    :goto_0
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mIsDataEnabled:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 434
    :goto_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method private declared-synchronized updateDataEnabledAndNotify(I)V
    .locals 2

    monitor-enter p0

    .line 417
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mIsDataEnabled:Z

    .line 419
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabled()V

    .line 421
    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mIsDataEnabled:Z

    if-eq v0, v1, :cond_1

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 422
    :goto_0
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->notifyDataEnabledChanged(ZI)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 424
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private updatePhoneStateListener()V
    .locals 3

    .line 166
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhoneStateListener:Landroid/telephony/PhoneStateListener;

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/telephony/TelephonyManager;->listen(Landroid/telephony/PhoneStateListener;I)V

    .line 167
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSubId:I

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isUsableSubscriptionId(I)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 168
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSubId:I

    invoke-virtual {v0, v1}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    .line 170
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhoneStateListener:Landroid/telephony/PhoneStateListener;

    const/16 v1, 0x20

    invoke-virtual {v0, p0, v1}, Landroid/telephony/TelephonyManager;->listen(Landroid/telephony/PhoneStateListener;I)V

    return-void
.end method


# virtual methods
.method protected dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 1

    const-string v0, " DataEnabledSettings="

    .line 563
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 564
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mSettingChangeLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    return-void
.end method

.method public declared-synchronized getDataRoamingEnabled()Z
    .locals 4

    monitor-enter p0

    .line 476
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "data_roaming"

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 477
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->getDefaultDataRoamingEnabled()Z

    move-result v3

    .line 476
    invoke-static {v0, v1, v2, v3}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized getDefaultDataRoamingEnabled()Z
    .locals 4

    monitor-enter p0

    .line 487
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 488
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    const-string/jumbo v1, "true"

    const-string v2, "ro.com.android.dataroaming"

    const-string v3, "false"

    .line 489
    invoke-static {v2, v3}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    .line 491
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v0, v2}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v2, "carrier_default_data_roaming_enabled_bool"

    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    or-int/2addr v0, v1

    .line 493
    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isCarrierDataEnabled()Z
    .locals 1

    monitor-enter p0

    .line 368
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mCarrierDataEnabled:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isDataAllowedInVoiceCall()Z
    .locals 1

    monitor-enter p0

    .line 340
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEnabledOverride;->isDataAllowedInVoiceCall()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isDataEnabled()Z
    .locals 1

    monitor-enter p0

    .line 392
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mIsDataEnabled:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isDataEnabled(I)Z
    .locals 3

    monitor-enter p0

    .line 541
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isProvisioning()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 542
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isProvisioningDataEnabled()Z

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return p1

    .line 544
    :cond_0
    :try_start_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isUserDataEnabled()Z

    move-result v0

    .line 546
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 547
    invoke-virtual {v1, v2, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->shouldOverrideDataEnabledSettings(Lcom/android/internal/telephony/Phone;I)Z

    move-result p1

    .line 549
    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mInternalDataEnabled:Z

    if-eqz v1, :cond_2

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPolicyDataEnabled:Z

    if-eqz v1, :cond_2

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mCarrierDataEnabled:Z

    if-eqz v1, :cond_2

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mThermalDataEnabled:Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v1, :cond_2

    if-nez v0, :cond_1

    if-eqz p1, :cond_2

    :cond_1
    const/4 p1, 0x1

    goto :goto_0

    :cond_2
    const/4 p1, 0x0

    :goto_0
    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized isDataEnabledForReason(I)Z
    .locals 1

    monitor-enter p0

    if-eqz p1, :cond_3

    const/4 v0, 0x1

    if-eq p1, v0, :cond_2

    const/4 v0, 0x2

    if-eq p1, v0, :cond_1

    const/4 v0, 0x3

    if-eq p1, v0, :cond_0

    const/4 p1, 0x0

    .line 412
    monitor-exit p0

    return p1

    .line 410
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isThermalDataEnabled()Z

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return p1

    .line 406
    :cond_1
    :try_start_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isCarrierDataEnabled()Z

    move-result p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit p0

    return p1

    .line 408
    :cond_2
    :try_start_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isPolicyDataEnabled()Z

    move-result p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    monitor-exit p0

    return p1

    .line 404
    :cond_3
    :try_start_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isUserDataEnabled()Z

    move-result p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized isInternalDataEnabled()Z
    .locals 1

    monitor-enter p0

    .line 218
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mInternalDataEnabled:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isMmsAlwaysAllowed()Z
    .locals 1

    monitor-enter p0

    .line 344
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEnabledOverride;->isMmsAlwaysAllowed()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isPolicyDataEnabled()Z
    .locals 1

    monitor-enter p0

    .line 356
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPolicyDataEnabled:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public isProvisioning()Z
    .locals 2

    .line 437
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mResolver:Landroid/content/ContentResolver;

    const-string v0, "device_provisioned"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    if-nez p0, :cond_0

    const/4 v1, 0x1

    :cond_0
    return v1
.end method

.method public isProvisioningDataEnabled()Z
    .locals 5

    const-string v0, "ro.com.android.prov_mobiledata"

    const-string v1, "false"

    .line 446
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "true"

    .line 448
    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    .line 450
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mResolver:Landroid/content/ContentResolver;

    const-string v3, "device_provisioning_mobile_data"

    invoke-static {v2, v3, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v1

    if-eqz v1, :cond_0

    const/4 v2, 0x1

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    .line 454
    :goto_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "getDataEnabled during provisioning retVal="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " - ("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ")"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->log(Ljava/lang/String;)V

    return v2
.end method

.method public declared-synchronized isThermalDataEnabled()Z
    .locals 1

    monitor-enter p0

    .line 380
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mThermalDataEnabled:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isUserDataEnabled()Z
    .locals 4

    monitor-enter p0

    .line 278
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isStandAloneOpportunistic(ILandroid/content/Context;)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    monitor-exit p0

    return v0

    .line 280
    :cond_0
    :try_start_1
    invoke-static {}, Landroid/internal/telephony/sysprop/TelephonyProperties;->mobile_data()Ljava/util/Optional;

    move-result-object v0

    sget-object v1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v1}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    .line 282
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "mobile_data"

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 283
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v3

    .line 282
    invoke-static {v1, v2, v3, v0}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public registerForDataEnabledChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 502
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 503
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isDataEnabled()Z

    move-result p1

    const/4 p2, 0x0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->notifyDataEnabledChanged(ZI)V

    return-void
.end method

.method public registerForDataEnabledOverrideChanged(Landroid/os/Handler;I)V
    .locals 2

    .line 521
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledOverrideChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    const/4 v1, 0x0

    invoke-virtual {v0, p1, p2, v1}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 522
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->notifyDataEnabledOverrideChanged()V

    return-void
.end method

.method public declared-synchronized setAllowDataDuringVoiceCall(Z)Z
    .locals 2

    monitor-enter p0

    :try_start_0
    const-string v0, "setAllowDataDuringVoiceCall"

    .line 318
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 319
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isDataAllowedInVoiceCall()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ne p1, v0, :cond_0

    const/4 p1, 0x1

    .line 320
    monitor-exit p0

    return p1

    .line 322
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->setDataAllowedInVoiceCall(Z)V

    .line 324
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 325
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->getRules()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->setDataEnabledOverrideRules(ILjava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 v0, 0x7

    .line 327
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V

    .line 328
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->notifyDataEnabledOverrideChanged()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 331
    :cond_1
    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setAlwaysAllowMmsData(Z)Z
    .locals 2

    monitor-enter p0

    :try_start_0
    const-string v0, "setAlwaysAllowMmsData"

    .line 294
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 295
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->setAlwaysAllowMms(Z)V

    .line 296
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 297
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->getRules()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->setDataEnabledOverrideRules(ILjava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 v0, 0x7

    .line 299
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V

    .line 300
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->notifyDataEnabledOverrideChanged()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 303
    :cond_0
    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setDataEnabled(IZ)V
    .locals 1

    monitor-enter p0

    if-eqz p1, :cond_3

    const/4 v0, 0x1

    if-eq p1, v0, :cond_2

    const/4 v0, 0x2

    if-eq p1, v0, :cond_1

    const/4 v0, 0x3

    if-eq p1, v0, :cond_0

    .line 271
    :try_start_0
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Invalid data enable reason "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 268
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setThermalDataEnabled(Z)V

    goto :goto_0

    .line 262
    :cond_1
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setCarrierDataEnabled(Z)V

    goto :goto_0

    .line 265
    :cond_2
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setPolicyDataEnabled(Z)V

    goto :goto_0

    .line 259
    :cond_3
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setUserDataEnabled(Z)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 274
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setDataRoamingEnabled(Z)V
    .locals 3

    monitor-enter p0

    .line 462
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "data_roaming"

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 463
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    .line 462
    invoke-static {v0, v1, v2, p1}, Lcom/android/internal/telephony/GlobalSettingsHelper;->setBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "setDataRoamingEnabled"

    .line 466
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 467
    invoke-static {}, Lcom/android/internal/telephony/MultiSimSettingController;->getInstance()Lcom/android/internal/telephony/MultiSimSettingController;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->notifyRoamingDataEnabled(IZ)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 470
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setInternalDataEnabled(Z)V
    .locals 1

    monitor-enter p0

    .line 211
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mInternalDataEnabled:Z

    if-eq v0, p1, :cond_0

    const-string v0, "InternalDataEnabled"

    .line 212
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 213
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mInternalDataEnabled:Z

    const/4 p1, 0x1

    .line 214
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 216
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setUserDataEnabled(ZZ)V
    .locals 4

    monitor-enter p0

    .line 235
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isStandAloneOpportunistic(ILandroid/content/Context;)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    if-nez p1, :cond_0

    monitor-exit p0

    return-void

    .line 237
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "mobile_data"

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 238
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    if-eqz p1, :cond_1

    const/4 v3, 0x1

    goto :goto_0

    :cond_1
    const/4 v3, 0x0

    .line 237
    :goto_0
    invoke-static {v0, v1, v2, v3}, Lcom/android/internal/telephony/GlobalSettingsHelper;->setInt(Landroid/content/Context;Ljava/lang/String;II)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "UserDataEnabled"

    .line 240
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->localLog(Ljava/lang/String;Z)V

    .line 241
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/Phone;->notifyUserMobileDataStateChanged(Z)V

    const/4 v0, 0x2

    .line 242
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V

    if-eqz p2, :cond_2

    .line 244
    invoke-static {}, Lcom/android/internal/telephony/MultiSimSettingController;->getInstance()Lcom/android/internal/telephony/MultiSimSettingController;

    move-result-object p2

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 245
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 244
    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->notifyUserDataEnabled(IZ)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 248
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 182
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[mInternalDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mInternalDataEnabled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", isUserDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 183
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isUserDataEnabled()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", isProvisioningDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 184
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isProvisioningDataEnabled()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mPolicyDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mPolicyDataEnabled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mCarrierDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mCarrierDataEnabled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mIsDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mIsDataEnabled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mThermalDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mThermalDataEnabled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public unregisterForDataEnabledChanged(Landroid/os/Handler;)V
    .locals 0

    .line 507
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForDataEnabledOverrideChanged(Landroid/os/Handler;)V
    .locals 0

    .line 531
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->mOverallDataEnabledOverrideChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public declared-synchronized updateProvisionedChanged()V
    .locals 1

    monitor-enter p0

    const/4 v0, 0x5

    .line 384
    :try_start_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 385
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized updateProvisioningDataEnabled()V
    .locals 1

    monitor-enter p0

    const/4 v0, 0x6

    .line 388
    :try_start_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateDataEnabledAndNotify(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 389
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method
