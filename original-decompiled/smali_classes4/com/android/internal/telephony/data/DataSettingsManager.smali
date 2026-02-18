.class public Lcom/android/internal/telephony/data/DataSettingsManager;
.super Landroid/os/Handler;
.source "DataSettingsManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
    }
.end annotation


# static fields
.field private static final EVENT_CALL_STATE_CHANGED:I = 0x2

.field private static final EVENT_DATA_CONFIG_UPDATED:I = 0x1

.field private static final EVENT_INITIALIZE:I = 0xb

.field public static final EVENT_MULTI_SIM_CONFIG_CHANGED:I = 0x1

.field private static final EVENT_PROVISIONED_CHANGED:I = 0x9

.field private static final EVENT_PROVISIONING_DATA_ENABLED_CHANGED:I = 0xa

.field private static final EVENT_SET_ALLOW_DATA_DURING_VOICE_CALL:I = 0x8

.field private static final EVENT_SET_ALWAYS_ALLOW_MMS_DATA:I = 0x7

.field private static final EVENT_SET_DATA_ENABLED_FOR_REASON:I = 0x5

.field private static final EVENT_SET_DATA_ROAMING_ENABLED:I = 0x6

.field private static final EVENT_SUBSCRIPTIONS_CHANGED:I = 0x4


# instance fields
.field private final mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

.field private mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

.field private final mDataEnabledSettings:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field private final mDataSettingsManagerCallbacks:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;",
            ">;"
        }
    .end annotation
.end field

.field public mHandler:Landroid/os/Handler;

.field private mInitialized:Z

.field private mIsDataEnabled:Z

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mLogTag:Ljava/lang/String;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mResolver:Landroid/content/ContentResolver;

.field private final mSettingsObserver:Lcom/android/internal/telephony/SettingsObserver;

.field private mSubId:I


# direct methods
.method public static synthetic $r8$lambda$-Qt-brMc5U8qz4T12yH3dNsGX8Y(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZI)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->lambda$notifyDataEnabledOverrideChanged$4(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZI)V

    return-void
.end method

.method public static synthetic $r8$lambda$K8rk6NsRR7aC3EIdtzafrVkTX7o(ZILcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->lambda$notifyDataEnabledOverrideChanged$5(ZILcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$KyBzqXKHyGi0CRQznJO9S4_lkLQ(ZLcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->lambda$setDataRoamingEnabledInternal$1(ZLcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$SU9jdN8TseNbLSuyiZ5CT8XX4ow(ZILjava/lang/String;Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 0

    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataSettingsManager;->lambda$notifyDataEnabledChanged$3(ZILjava/lang/String;Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$eBmfBxDiPFLoVoeGRtgU0UAhLz8(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;Z)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->lambda$setDataRoamingEnabledInternal$0(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;Z)V

    return-void
.end method

.method public static synthetic $r8$lambda$ot_NLQAv8xkQoMy32LOxqZkDyvI(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZILjava/lang/String;)V
    .locals 0

    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataSettingsManager;->lambda$notifyDataEnabledChanged$2(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZILjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$sde0nyoX1EqUQqcljn7khawQJv0(Ljava/util/Map$Entry;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->lambda$dump$6(Ljava/util/Map$Entry;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/DataSettingsManager;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSubId(Lcom/android/internal/telephony/data/DataSettingsManager;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$mlog(Lcom/android/internal/telephony/data/DataSettingsManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateDataEnabledAndNotify(Lcom/android/internal/telephony/data/DataSettingsManager;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(I)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 2

    .line 185
    invoke-direct {p0, p3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 87
    new-instance p3, Lcom/android/internal/telephony/LocalLog;

    const/16 v0, 0x80

    invoke-direct {p3, v0}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 95
    new-instance p3, Landroid/util/ArraySet;

    invoke-direct {p3}, Landroid/util/ArraySet;-><init>()V

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataSettingsManagerCallbacks:Ljava/util/Set;

    .line 99
    new-instance p3, Landroid/util/ArrayMap;

    invoke-direct {p3}, Landroid/util/ArrayMap;-><init>()V

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    const/4 v0, 0x0

    .line 111
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mInitialized:Z

    .line 115
    new-instance v0, Lcom/android/internal/telephony/data/DataSettingsManager$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataSettingsManager$1;-><init>(Lcom/android/internal/telephony/data/DataSettingsManager;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mHandler:Landroid/os/Handler;

    .line 186
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 187
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DSMGR-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mLogTag:Ljava/lang/String;

    const-string v0, "DataSettingsManager created."

    .line 188
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    .line 189
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    .line 190
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    .line 191
    invoke-virtual {p0, p4}, Lcom/android/internal/telephony/data/DataSettingsManager;->registerCallback(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    .line 192
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 193
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->getDataEnabledOverride()Lcom/android/internal/telephony/data/DataEnabledOverride;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    .line 194
    new-instance p2, Lcom/android/internal/telephony/SettingsObserver;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-direct {p2, p1, p0}, Lcom/android/internal/telephony/SettingsObserver;-><init>(Landroid/content/Context;Landroid/os/Handler;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSettingsObserver:Lcom/android/internal/telephony/SettingsObserver;

    const/4 p1, 0x1

    .line 195
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    sget-object p4, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-interface {p3, p2, p4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 p2, 0x2

    .line 196
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-interface {p3, p2, p4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 p2, 0x3

    .line 197
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-interface {p3, p2, p4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 198
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mHandler:Landroid/os/Handler;

    const/4 p3, 0x0

    invoke-static {p2, p1, p3}, Lcom/android/internal/telephony/PhoneConfigurationManager;->registerForMultiSimConfigChange(Landroid/os/Handler;ILjava/lang/Object;)V

    const/16 p1, 0xb

    .line 203
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method

.method private static dataEnabledChangedReasonToString(I)Ljava/lang/String;
    .locals 1

    if-eqz p0, :cond_4

    const/4 v0, 0x1

    if-eq p0, v0, :cond_3

    const/4 v0, 0x2

    if-eq p0, v0, :cond_2

    const/4 v0, 0x3

    if-eq p0, v0, :cond_1

    const/4 v0, 0x4

    if-eq p0, v0, :cond_0

    const-string p0, "UNKNOWN"

    return-object p0

    :cond_0
    const-string p0, "OVERRIDE"

    return-object p0

    :cond_1
    const-string p0, "THERMAL"

    return-object p0

    :cond_2
    const-string p0, "CARRIER"

    return-object p0

    :cond_3
    const-string p0, "POLICY"

    return-object p0

    :cond_4
    const-string p0, "USER"

    return-object p0
.end method

.method private getDataEnabledOverride()Lcom/android/internal/telephony/data/DataEnabledOverride;
    .locals 2

    .line 617
    new-instance v0, Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v1

    iget p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    .line 618
    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/SubscriptionController;->getDataEnabledOverrideRules(I)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataEnabledOverride;-><init>(Ljava/lang/String;)V

    return-object v0
.end method

.method private isDataRoamingFromUserAction()Z
    .locals 3

    .line 595
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 596
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "data_roaming_is_user_setting_key"

    .line 599
    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 600
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const/4 v2, 0x0

    invoke-interface {v1, v0, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    :cond_0
    const/4 v1, 0x1

    .line 602
    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method private isProvisioningDataEnabled()Z
    .locals 5

    const-string v0, "ro.com.android.prov_mobiledata"

    const-string v1, "false"

    .line 377
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "true"

    .line 379
    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    .line 381
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    const-string v3, "device_provisioning_mobile_data"

    invoke-static {v2, v3, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v1

    if-eqz v1, :cond_0

    const/4 v2, 0x1

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    .line 385
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

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    return v2
.end method

.method private static isStandAloneOpportunistic(ILandroid/content/Context;)Z
    .locals 2

    .line 434
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    .line 435
    invoke-virtual {p1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object p1

    .line 434
    invoke-virtual {v0, p0, v1, p1}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubscriptionInfo(ILjava/lang/String;Ljava/lang/String;)Landroid/telephony/SubscriptionInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 436
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

.method private isUserDataEnabled()Z
    .locals 3

    .line 463
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    const-string v1, "device_provisioned"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    if-nez v0, :cond_0

    .line 464
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isProvisioningDataEnabled()Z

    move-result p0

    return p0

    .line 468
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->isStandAloneOpportunistic(ILandroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 p0, 0x1

    return p0

    .line 470
    :cond_1
    invoke-static {}, Landroid/internal/telephony/sysprop/TelephonyProperties;->mobile_data()Ljava/util/Optional;

    move-result-object v0

    sget-object v1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v1}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    .line 472
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    iget p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    const-string v2, "mobile_data"

    invoke-static {v1, v2, p0, v0}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$dump$6(Ljava/util/Map$Entry;)Ljava/lang/String;
    .locals 2

    .line 777
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-interface {p0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->dataEnabledChangedReasonToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$notifyDataEnabledChanged$2(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZILjava/lang/String;)V
    .locals 0

    .line 670
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;->onDataEnabledChanged(ZILjava/lang/String;)V

    return-void
.end method

.method private static synthetic lambda$notifyDataEnabledChanged$3(ZILjava/lang/String;Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 1

    .line 669
    new-instance v0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda3;

    invoke-direct {v0, p3, p0, p1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZILjava/lang/String;)V

    invoke-virtual {p3, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$notifyDataEnabledOverrideChanged$4(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZI)V
    .locals 0

    .line 678
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;->onDataEnabledOverrideChanged(ZI)V

    return-void
.end method

.method private static synthetic lambda$notifyDataEnabledOverrideChanged$5(ZILcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 1

    .line 677
    new-instance v0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;

    invoke-direct {v0, p2, p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZI)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$setDataRoamingEnabledInternal$0(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;Z)V
    .locals 0

    .line 536
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;->onDataRoamingEnabledChanged(Z)V

    return-void
.end method

.method private static synthetic lambda$setDataRoamingEnabledInternal$1(ZLcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 1

    .line 535
    new-instance v0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda2;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;Z)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 732
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 740
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logl(Ljava/lang/String;)V
    .locals 0

    .line 748
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    .line 749
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method private notifyDataEnabledChanged(ZILjava/lang/String;)V
    .locals 2

    .line 667
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "notifyDataEnabledChanged: enabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 668
    invoke-static {p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->dataEnabledChangedReasonToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", callingPackage="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 667
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 669
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataSettingsManagerCallbacks:Ljava/util/Set;

    new-instance v1, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda0;

    invoke-direct {v1, p1, p2, p3}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda0;-><init>(ZILjava/lang/String;)V

    invoke-interface {v0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 671
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/Phone;->notifyDataEnabled(ZI)V

    return-void
.end method

.method private notifyDataEnabledOverrideChanged(ZI)V
    .locals 2

    .line 676
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "notifyDataEnabledOverrideChanged: enabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 677
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataSettingsManagerCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda1;

    invoke-direct {v0, p1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda1;-><init>(ZI)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method private onInitialize()V
    .locals 3

    .line 303
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->registerForConfigUpdate(Landroid/os/Handler;I)V

    .line 304
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSettingsObserver:Lcom/android/internal/telephony/SettingsObserver;

    const-string v1, "device_provisioned"

    invoke-static {v1}, Landroid/provider/Settings$Global;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    const/16 v2, 0x9

    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SettingsObserver;->observe(Landroid/net/Uri;I)V

    .line 306
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSettingsObserver:Lcom/android/internal/telephony/SettingsObserver;

    const-string v1, "device_provisioning_mobile_data"

    .line 307
    invoke-static {v1}, Landroid/provider/Settings$Global;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    const/16 v2, 0xa

    .line 306
    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SettingsObserver;->observe(Landroid/net/Uri;I)V

    .line 309
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    const/4 v1, 0x2

    const/4 v2, 0x0

    invoke-virtual {v0, p0, v1, v2}, Lcom/android/internal/telephony/CallTracker;->registerForVoiceCallStarted(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 310
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    invoke-virtual {v0, p0, v1, v2}, Lcom/android/internal/telephony/CallTracker;->registerForVoiceCallEnded(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 311
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 312
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    invoke-virtual {v0, p0, v1, v2}, Lcom/android/internal/telephony/CallTracker;->registerForVoiceCallStarted(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 314
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    invoke-virtual {v0, p0, v1, v2}, Lcom/android/internal/telephony/CallTracker;->registerForVoiceCallEnded(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 317
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyRegistryManager;

    new-instance v1, Lcom/android/internal/telephony/data/DataSettingsManager$2;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataSettingsManager$2;-><init>(Lcom/android/internal/telephony/data/DataSettingsManager;)V

    new-instance v2, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda5;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/data/DataSettingsManager;)V

    .line 318
    invoke-virtual {v0, v1, v2}, Landroid/telephony/TelephonyRegistryManager;->addOnSubscriptionsChangedListener(Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;Ljava/util/concurrent/Executor;)V

    const/4 v0, -0x1

    .line 328
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(I)V

    return-void
.end method

.method private setCarrierDataEnabled(ZLjava/lang/String;)V
    .locals 4

    .line 495
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    const/4 v1, 0x2

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eq v0, p1, :cond_0

    .line 496
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "CarrierDataEnabled changed to "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ", callingPackage="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 497
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    invoke-interface {v0, v2, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 498
    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(ILjava/lang/String;)V

    :cond_0
    return-void
.end method

.method private setDataRoamingEnabledInternal(Z)V
    .locals 3

    .line 531
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iget v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    const-string v2, "data_roaming"

    invoke-static {v0, v2, v1, p1}, Lcom/android/internal/telephony/GlobalSettingsHelper;->setBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 534
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DataRoamingEnabled changed to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 535
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataSettingsManagerCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda4;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda4;-><init>(Z)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :cond_0
    return-void
.end method

.method private setDataRoamingFromUserAction()V
    .locals 2

    .line 611
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 612
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "data_roaming_is_user_setting_key"

    const/4 v1, 0x1

    .line 613
    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method private setPolicyDataEnabled(ZLjava/lang/String;)V
    .locals 4

    .line 482
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    const/4 v1, 0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eq v0, p1, :cond_0

    .line 483
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "PolicyDataEnabled changed to "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ", callingPackage="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 484
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    invoke-interface {v0, v2, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 485
    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(ILjava/lang/String;)V

    :cond_0
    return-void
.end method

.method private setThermalDataEnabled(ZLjava/lang/String;)V
    .locals 4

    .line 509
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    const/4 v1, 0x3

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    if-eq v0, p1, :cond_0

    .line 510
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ThermalDataEnabled changed to "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ", callingPackage="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 511
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    invoke-interface {v0, v2, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 512
    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(ILjava/lang/String;)V

    :cond_0
    return-void
.end method

.method private setUserDataEnabled(ZLjava/lang/String;)V
    .locals 3

    .line 446
    iget v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->isStandAloneOpportunistic(ILandroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    if-nez p1, :cond_0

    return-void

    .line 447
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iget v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    const-string v2, "mobile_data"

    invoke-static {v0, v2, v1, p1}, Lcom/android/internal/telephony/GlobalSettingsHelper;->setInt(Landroid/content/Context;Ljava/lang/String;II)Z

    move-result v0

    .line 449
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Set user data enabled to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", changed="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", callingPackage="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    if-eqz v0, :cond_1

    .line 452
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UserDataEnabled changed to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 453
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/Phone;->notifyUserMobileDataStateChanged(Z)V

    const/4 p1, 0x0

    .line 454
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(ILjava/lang/String;)V

    :cond_1
    return-void
.end method

.method private updateDataEnabledAndNotify(I)V
    .locals 1

    .line 356
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(ILjava/lang/String;)V

    return-void
.end method

.method private updateDataEnabledAndNotify(ILjava/lang/String;)V
    .locals 3

    .line 361
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    const/16 v1, 0xff

    .line 362
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled(I)Z

    move-result v1

    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    .line 363
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mIsDataEnabled="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", prevDataEnabled="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    .line 364
    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mInitialized:Z

    if-eqz v1, :cond_0

    iget-boolean v2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    if-eq v0, v2, :cond_2

    :cond_0
    if-nez v1, :cond_1

    const/4 v0, 0x1

    .line 365
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mInitialized:Z

    .line 366
    :cond_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    invoke-direct {p0, v0, p1, p2}, Lcom/android/internal/telephony/data/DataSettingsManager;->notifyDataEnabledChanged(ZILjava/lang/String;)V

    :cond_2
    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 4

    .line 760
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 761
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class v1, Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "-"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 762
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 763
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsDataEnabled="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 764
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isDataEnabled(internet)="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x11

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled(I)Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 765
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isDataEnabled(mms)="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v1, 0x2

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled(I)Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 766
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isUserDataEnabled="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isUserDataEnabled()Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 767
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isDataRoamingEnabled="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataRoamingEnabled()Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 768
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isDefaultDataRoamingEnabled="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDefaultDataRoamingEnabled()Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 769
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isDataRoamingFromUserAction="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataRoamingFromUserAction()Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 770
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "device_provisioned="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    const-string v2, "device_provisioned"

    const/4 v3, 0x0

    invoke-static {v1, v2, v3}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 772
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isProvisioningDataEnabled="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isProvisioningDataEnabled()Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 773
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "data_stall_recovery_on_bad_network="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    const-string v2, "data_stall_recovery_on_bad_network"

    const/4 v3, 0x1

    invoke-static {v1, v2, v3}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 775
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataEnabledSettings="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda7;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda7;-><init>()V

    .line 776
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v1

    const-string v2, ", "

    .line 778
    invoke-static {v2}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 775
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 779
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataEnabledOverride="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 780
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 781
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 782
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 783
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 784
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 5

    .line 208
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x2

    const/4 v2, 0x0

    const/4 v3, 0x4

    const/4 v4, 0x1

    packed-switch v0, :pswitch_data_0

    .line 295
    :pswitch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown msg.what: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->loge(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 291
    :pswitch_1
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->onInitialize()V

    goto/16 :goto_0

    :pswitch_2
    const/4 p1, -0x1

    .line 287
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(I)V

    goto/16 :goto_0

    .line 271
    :pswitch_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    .line 272
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataAllowedInVoiceCall()Z

    move-result v0

    if-ne p1, v0, :cond_0

    goto/16 :goto_0

    .line 275
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "AllowDataDuringVoiceCall changed to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 276
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->setDataAllowedInVoiceCall(Z)V

    .line 277
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    iget v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    .line 278
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataEnabledOverride;->getRules()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->setDataEnabledOverrideRules(ILjava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 279
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(I)V

    .line 280
    invoke-direct {p0, p1, v4}, Lcom/android/internal/telephony/data/DataSettingsManager;->notifyDataEnabledOverrideChanged(ZI)V

    goto/16 :goto_0

    .line 256
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    .line 257
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isMmsAlwaysAllowed()Z

    move-result v0

    if-ne p1, v0, :cond_1

    goto/16 :goto_0

    .line 260
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "AlwaysAllowMmsData changed to "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->logl(Ljava/lang/String;)V

    .line 261
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->setAlwaysAllowMms(Z)V

    .line 262
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    iget v2, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    .line 263
    invoke-virtual {v4}, Lcom/android/internal/telephony/data/DataEnabledOverride;->getRules()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Lcom/android/internal/telephony/SubscriptionController;->setDataEnabledOverrideRules(ILjava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 264
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(I)V

    .line 265
    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->notifyDataEnabledOverrideChanged(ZI)V

    goto/16 :goto_0

    .line 250
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    .line 251
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDataRoamingEnabledInternal(Z)V

    .line 252
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDataRoamingFromUserAction()V

    goto/16 :goto_0

    .line 227
    :pswitch_6
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Ljava/lang/String;

    .line 228
    iget v3, p1, Landroid/os/Message;->arg2:I

    if-ne v3, v4, :cond_2

    move v2, v4

    .line 229
    :cond_2
    iget v3, p1, Landroid/os/Message;->arg1:I

    if-eqz v3, :cond_6

    if-eq v3, v4, :cond_5

    if-eq v3, v1, :cond_4

    const/4 v1, 0x3

    if-eq v3, v1, :cond_3

    .line 243
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Cannot set data enabled for reason: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 244
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->dataEnabledChangedReasonToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 243
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 240
    :cond_3
    invoke-direct {p0, v2, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setThermalDataEnabled(ZLjava/lang/String;)V

    goto :goto_0

    .line 234
    :cond_4
    invoke-direct {p0, v2, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setCarrierDataEnabled(ZLjava/lang/String;)V

    goto :goto_0

    .line 237
    :cond_5
    invoke-direct {p0, v2, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setPolicyDataEnabled(ZLjava/lang/String;)V

    goto :goto_0

    .line 231
    :cond_6
    invoke-direct {p0, v2, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setUserDataEnabled(ZLjava/lang/String;)V

    goto :goto_0

    .line 220
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    .line 221
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->getDataEnabledOverride()Lcom/android/internal/telephony/data/DataEnabledOverride;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    .line 222
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(I)V

    .line 223
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isUserDataEnabled()Z

    move-result p0

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/Phone;->notifyUserMobileDataStateChanged(Z)V

    goto :goto_0

    .line 216
    :pswitch_8
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataSettingsManager;->updateDataEnabledAndNotify(I)V

    goto :goto_0

    .line 210
    :pswitch_9
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataConfigManager;->isConfigCarrierSpecific()Z

    move-result p1

    if-eqz p1, :cond_7

    .line 211
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDefaultDataRoamingEnabled()V

    :cond_7
    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_9
        :pswitch_8
        :pswitch_0
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method public isDataAllowedInVoiceCall()Z
    .locals 0

    .line 653
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataEnabledOverride;->isDataAllowedInVoiceCall()Z

    move-result p0

    return p0
.end method

.method public isDataEnabled()Z
    .locals 0

    .line 397
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    return p0
.end method

.method public isDataEnabled(I)Z
    .locals 4

    .line 418
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    const-string v1, "device_provisioned"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    if-nez v0, :cond_0

    .line 419
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isProvisioningDataEnabled()Z

    move-result p0

    return p0

    .line 421
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isUserDataEnabled()Z

    move-result v0

    .line 423
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 424
    invoke-virtual {v1, v3, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->shouldOverrideDataEnabledSettings(Lcom/android/internal/telephony/Phone;I)Z

    move-result p1

    const/4 v1, 0x1

    if-nez v0, :cond_1

    if-eqz p1, :cond_2

    .line 426
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    .line 427
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    if-eqz p1, :cond_2

    iget-object p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    const/4 v0, 0x2

    .line 428
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    if-eqz p1, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    const/4 p1, 0x3

    .line 429
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Boolean;

    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    if-eqz p0, :cond_2

    move v2, v1

    :cond_2
    return v2
.end method

.method public isDataEnabledForReason(I)Z
    .locals 0

    if-nez p1, :cond_0

    .line 349
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isUserDataEnabled()Z

    move-result p0

    return p0

    .line 351
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Boolean;

    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    return p0
.end method

.method public isDataInitialized()Z
    .locals 0

    .line 409
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mInitialized:Z

    return p0
.end method

.method public isDataRoamingEnabled()Z
    .locals 3

    .line 546
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iget v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mSubId:I

    .line 547
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDefaultDataRoamingEnabled()Z

    move-result p0

    const-string v2, "data_roaming"

    .line 546
    invoke-static {v0, v2, v1, p0}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result p0

    return p0
.end method

.method public isDefaultDataRoamingEnabled()Z
    .locals 2

    const-string v0, "ro.com.android.dataroaming"

    const-string v1, "false"

    .line 557
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "true"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 558
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object p0

    .line 559
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isDataRoamingEnabledByDefault()Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public isMmsAlwaysAllowed()Z
    .locals 0

    .line 634
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataEnabledOverride;->isMmsAlwaysAllowed()Z

    move-result p0

    return p0
.end method

.method public isRecoveryOnBadNetworkEnabled()Z
    .locals 2

    .line 661
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    const-string v0, "data_stall_recovery_on_bad_network"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    if-ne p0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method public registerCallback(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 0

    .line 687
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataSettingsManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public setAllowDataDuringVoiceCall(Z)V
    .locals 1

    .line 645
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    const/16 v0, 0x8

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public setAlwaysAllowMmsData(Z)V
    .locals 1

    .line 626
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    const/4 v0, 0x7

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public setDataEnabled(IZLjava/lang/String;)V
    .locals 1

    const/4 v0, 0x5

    .line 339
    invoke-virtual {p0, v0, p1, p2, p3}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 340
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public setDataRoamingEnabled(Z)V
    .locals 1

    .line 522
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    const/4 v0, 0x6

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public setDefaultDataRoamingEnabled()V
    .locals 4

    .line 571
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Landroid/telephony/TelephonyManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getSimCount()I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eq v0, v1, :cond_0

    .line 572
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "data_roaming"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 574
    :try_start_0
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mResolver:Landroid/content/ContentResolver;

    invoke-static {v3, v0}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I
    :try_end_0
    .catch Landroid/provider/Settings$SettingNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 579
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataRoamingFromUserAction()Z

    move-result v0

    if-nez v0, :cond_1

    goto :goto_1

    :cond_1
    :goto_0
    move v1, v2

    .line 583
    :catch_0
    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setDefaultDataRoamingEnabled: useCarrierSpecificDefault="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->log(Ljava/lang/String;)V

    if-eqz v1, :cond_2

    .line 585
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDefaultDataRoamingEnabled()Z

    move-result v0

    .line 586
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDataRoamingEnabledInternal(Z)V

    :cond_2
    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 719
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[isUserDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isUserDataEnabled()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", isProvisioningDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 720
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isProvisioningDataEnabled()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mIsDataEnabled="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mIsDataEnabled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mDataEnabledSettings="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledSettings:Ljava/util/Map;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", mDataEnabledOverride="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataEnabledOverride:Lcom/android/internal/telephony/data/DataEnabledOverride;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public unregisterCallback(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V
    .locals 0

    .line 696
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager;->mDataSettingsManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method
