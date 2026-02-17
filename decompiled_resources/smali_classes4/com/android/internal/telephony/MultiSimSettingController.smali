.class public Lcom/android/internal/telephony/MultiSimSettingController;
.super Landroid/os/Handler;
.source "MultiSimSettingController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;,
        Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;,
        Lcom/android/internal/telephony/MultiSimSettingController$DataSettingsControllerCallback;,
        Lcom/android/internal/telephony/MultiSimSettingController$PrimarySubChangeType;
    }
.end annotation


# static fields
.field private static final DBG:Z = true

.field protected static final EVENT_ALL_SUBSCRIPTIONS_LOADED:I = 0x3

.field protected static final EVENT_CARRIER_CONFIG_CHANGED:I = 0x7

.field protected static final EVENT_DEFAULT_DATA_SUBSCRIPTION_CHANGED:I = 0x6

.field protected static final EVENT_MULTI_SIM_CONFIG_CHANGED:I = 0x8

.field public static final EVENT_RADIO_STATE_CHANGED:I = 0x9
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field protected static final EVENT_ROAMING_DATA_ENABLED:I = 0x2

.field protected static final EVENT_SUBSCRIPTION_GROUP_CHANGED:I = 0x5

.field protected static final EVENT_SUBSCRIPTION_INFO_CHANGED:I = 0x4

.field protected static final EVENT_USER_DATA_ENABLED:I = 0x1

.field private static final LOG_TAG:Ljava/lang/String; = "MultiSimSettingController"

.field protected static final PRIMARY_SUB_ADDED:I = 0x1

.field protected static final PRIMARY_SUB_INITIALIZED:I = 0x6

.field protected static final PRIMARY_SUB_MARKED_OPPT:I = 0x5

.field protected static final PRIMARY_SUB_NO_CHANGE:I = 0x0

.field protected static final PRIMARY_SUB_REMOVED:I = 0x2

.field protected static final PRIMARY_SUB_REMOVED_IN_GROUP:I = 0x7

.field protected static final PRIMARY_SUB_SWAPPED:I = 0x3

.field protected static final PRIMARY_SUB_SWAPPED_IN_GROUP:I = 0x4

.field protected static final SETTING_USER_PREF_DATA_SUB:Ljava/lang/String; = "user_preferred_data_sub"

.field protected static sInstance:Lcom/android/internal/telephony/MultiSimSettingController;


# instance fields
.field private mCallbacksCount:I

.field protected mCarrierConfigLoadedSubIds:[I

.field protected final mContext:Landroid/content/Context;

.field protected mInitialHandling:Z

.field private final mIntentReceiver:Landroid/content/BroadcastReceiver;

.field protected final mIsAskEverytimeSupportedForSms:Z

.field protected mPrimarySubList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field protected final mSubController:Lcom/android/internal/telephony/SubscriptionController;

.field private mSubInfoInitialized:Z


# direct methods
.method public static synthetic $r8$lambda$RbJpJy_HBxiXzhhX0KNe_nuy924(Lcom/android/internal/telephony/MultiSimSettingController;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->lambda$updateDefaults$0(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$VEEe7Jg9lef-ygoTqgFvFuZnG98(Lcom/android/internal/telephony/MultiSimSettingController;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->lambda$updateDefaults$2(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$ZRLPQnipRAwa4DyriX_mbKkgmoU(Lcom/android/internal/telephony/MultiSimSettingController;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->lambda$updateDefaults$1(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$ohz_22tIDTP8YX7Jey9pbQUbkbA(Landroid/telephony/SubscriptionInfo;)Ljava/lang/Integer;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->lambda$updatePrimarySubListAndGetChangeType$4(Landroid/telephony/SubscriptionInfo;)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$yUAZCZkERWeqfiD2r1eHWOsx_ok(Landroid/telephony/SubscriptionInfo;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->lambda$updatePrimarySubListAndGetChangeType$3(Landroid/telephony/SubscriptionInfo;)Z

    move-result p0

    return p0
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 238
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 126
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    const/4 v0, 0x0

    .line 137
    iput-boolean v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubInfoInitialized:Z

    const/4 v0, 0x1

    .line 143
    iput-boolean v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mInitialHandling:Z

    .line 161
    new-instance v0, Lcom/android/internal/telephony/MultiSimSettingController$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/MultiSimSettingController$1;-><init>(Lcom/android/internal/telephony/MultiSimSettingController;)V

    iput-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    .line 239
    iput-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 240
    iput-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    const-string p2, "phone"

    .line 243
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/TelephonyManager;

    .line 244
    invoke-virtual {p2}, Landroid/telephony/TelephonyManager;->getSupportedModemCount()I

    move-result p2

    .line 245
    new-array p2, p2, [I

    iput-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mCarrierConfigLoadedSubIds:[I

    const/4 v1, -0x1

    .line 246
    invoke-static {p2, v1}, Ljava/util/Arrays;->fill([II)V

    const/16 p2, 0x8

    const/4 v1, 0x0

    .line 248
    invoke-static {p0, p2, v1}, Lcom/android/internal/telephony/PhoneConfigurationManager;->registerForMultiSimConfigChange(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 251
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p2

    const v1, 0x11101b4

    .line 252
    invoke-virtual {p2, v1}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p2

    iput-boolean p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mIsAskEverytimeSupportedForSms:Z

    .line 253
    new-instance p0, Landroid/content/IntentFilter;

    const-string p2, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-direct {p0, p2}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v0, p0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    return-void
.end method

.method private areSubscriptionsInSameGroup(II)Z
    .locals 3

    .line 858
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isUsableSubscriptionId(I)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 859
    invoke-static {p2}, Landroid/telephony/SubscriptionManager;->isUsableSubscriptionId(I)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    if-ne p1, p2, :cond_1

    return v0

    .line 862
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/SubscriptionController;->getGroupUuid(I)Landroid/os/ParcelUuid;

    move-result-object p1

    .line 863
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/SubscriptionController;->getGroupUuid(I)Landroid/os/ParcelUuid;

    move-result-object p0

    if-eqz p1, :cond_2

    .line 864
    invoke-virtual {p1, p0}, Landroid/os/ParcelUuid;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    move v1, v0

    :cond_2
    :goto_0
    return v1
.end method

.method private deactivateGroupedOpportunisticSubscriptionIfNeeded()V
    .locals 4

    .line 966
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->isSubInfoInitialized()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 968
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 969
    invoke-virtual {v1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v2

    .line 968
    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->getOpportunisticSubscriptions(Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    .line 971
    invoke-static {v0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty(Ljava/util/Collection;)Z

    move-result v1

    if-eqz v1, :cond_1

    return-void

    .line 973
    :cond_1
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/SubscriptionInfo;

    .line 974
    invoke-virtual {v1}, Landroid/telephony/SubscriptionInfo;->isGroupDisabled()Z

    move-result v2

    if-eqz v2, :cond_2

    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 975
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[deactivateGroupedOpptSubIfNeeded] Deactivating grouped opportunistic subscription "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 977
    invoke-virtual {v1}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 975
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 978
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->deactivateSubscription(Landroid/telephony/SubscriptionInfo;)V

    goto :goto_0

    :cond_3
    return-void
.end method

.method private deactivateSubscription(Landroid/telephony/SubscriptionInfo;)V
    .locals 5

    .line 985
    invoke-virtual {p1}, Landroid/telephony/SubscriptionInfo;->isEmbedded()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 986
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[deactivateSubscription] eSIM profile "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 987
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    const-string v1, "euicc"

    .line 988
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/euicc/EuiccManager;

    const/4 v1, -0x1

    .line 990
    invoke-virtual {p1}, Landroid/telephony/SubscriptionInfo;->getPortIndex()I

    move-result p1

    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    const/4 v2, 0x0

    new-instance v3, Landroid/content/Intent;

    invoke-direct {v3}, Landroid/content/Intent;-><init>()V

    const/high16 v4, 0x4000000

    invoke-static {p0, v2, v3, v4}, Landroid/app/PendingIntent;->getService(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p0

    .line 989
    invoke-virtual {v0, v1, p1, p0}, Landroid/telephony/euicc/EuiccManager;->switchToSubscription(IILandroid/app/PendingIntent;)V

    :cond_0
    return-void
.end method

.method public static getInstance()Lcom/android/internal/telephony/MultiSimSettingController;
    .locals 3

    .line 209
    const-class v0, Lcom/android/internal/telephony/MultiSimSettingController;

    monitor-enter v0

    .line 210
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/MultiSimSettingController;->sInstance:Lcom/android/internal/telephony/MultiSimSettingController;

    if-nez v1, :cond_0

    const-string v1, "MultiSimSettingController"

    const-string v2, "getInstance null"

    .line 211
    invoke-static {v1, v2}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 214
    :cond_0
    sget-object v1, Lcom/android/internal/telephony/MultiSimSettingController;->sInstance:Lcom/android/internal/telephony/MultiSimSettingController;

    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception v1

    .line 215
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method private getSimSelectDialogType(IZZZ)I
    .locals 3

    .line 772
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_1

    const/4 v0, 0x2

    if-ne p1, v0, :cond_1

    if-eqz p2, :cond_0

    if-eqz p4, :cond_0

    if-nez p3, :cond_1

    :cond_0
    const/4 v1, 0x4

    goto :goto_0

    .line 775
    :cond_1
    iget-object p3, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {p3}, Ljava/util/List;->size()I

    move-result p3

    if-le p3, v2, :cond_3

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->isUserVisibleChange(I)Z

    move-result p3

    if-nez p3, :cond_2

    const/4 p3, 0x6

    if-ne p1, p3, :cond_3

    if-nez p2, :cond_3

    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 777
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const-string p1, "device_provisioned"

    invoke-static {p0, p1, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    if-eqz p0, :cond_3

    :cond_2
    move v1, v2

    :cond_3
    :goto_0
    return v1
.end method

.method private getUserPrefDataSubIdFromDB()I
    .locals 2

    .line 1049
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const-string/jumbo v0, "user_preferred_data_sub"

    const/4 v1, -0x1

    invoke-static {p0, v0, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method public static init(Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)Lcom/android/internal/telephony/MultiSimSettingController;
    .locals 3

    .line 222
    const-class v0, Lcom/android/internal/telephony/MultiSimSettingController;

    monitor-enter v0

    .line 223
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/MultiSimSettingController;->sInstance:Lcom/android/internal/telephony/MultiSimSettingController;

    if-nez v1, :cond_0

    .line 226
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v1

    const-class v2, Lcom/android/internal/telephony/TelephonyComponentFactory;

    .line 227
    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v1

    .line 228
    invoke-virtual {v1, p0, p1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeMultiSimSettingController(Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)Lcom/android/internal/telephony/MultiSimSettingController;

    move-result-object p0

    sput-object p0, Lcom/android/internal/telephony/MultiSimSettingController;->sInstance:Lcom/android/internal/telephony/MultiSimSettingController;

    goto :goto_0

    :cond_0
    const-string p0, "MultiSimSettingController"

    .line 231
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "init() called multiple times!  sInstance = "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/android/internal/telephony/MultiSimSettingController;->sInstance:Lcom/android/internal/telephony/MultiSimSettingController;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 233
    :goto_0
    sget-object p0, Lcom/android/internal/telephony/MultiSimSettingController;->sInstance:Lcom/android/internal/telephony/MultiSimSettingController;

    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 234
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private isRadioAvailableOnAllSubs()Z
    .locals 6

    .line 1054
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_3

    aget-object v3, p0, v2

    .line 1055
    iget-object v4, v3, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    if-eqz v4, :cond_0

    .line 1056
    invoke-interface {v4}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v4

    const/4 v5, 0x2

    if-eq v4, v5, :cond_1

    .line 1057
    :cond_0
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->isShuttingDown()Z

    move-result v3

    if-eqz v3, :cond_2

    :cond_1
    return v1

    :cond_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_3
    const/4 p0, 0x1

    return p0
.end method

.method private isUserVisibleChange(I)Z
    .locals 1

    const/4 p0, 0x1

    if-eq p1, p0, :cond_1

    const/4 v0, 0x2

    if-eq p1, v0, :cond_1

    const/4 v0, 0x3

    if-ne p1, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :cond_1
    :goto_0
    return p0
.end method

.method private synthetic lambda$updateDefaults$0(I)V
    .locals 0

    .line 637
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultDataSubId(I)V

    return-void
.end method

.method private synthetic lambda$updateDefaults$1(I)V
    .locals 0

    .line 643
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultVoiceSubId(I)V

    return-void
.end method

.method private synthetic lambda$updateDefaults$2(I)V
    .locals 0

    .line 649
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultSmsSubId(I)V

    return-void
.end method

.method private static synthetic lambda$updatePrimarySubListAndGetChangeType$3(Landroid/telephony/SubscriptionInfo;)Z
    .locals 0

    .line 670
    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->isOpportunistic()Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private static synthetic lambda$updatePrimarySubListAndGetChangeType$4(Landroid/telephony/SubscriptionInfo;)Ljava/lang/Integer;
    .locals 0

    .line 671
    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    const-string p0, "MultiSimSettingController"

    .line 1078
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    const-string p0, "MultiSimSettingController"

    .line 1082
    invoke-static {p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private onAllSubscriptionsLoaded()V
    .locals 6

    .line 390
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onAllSubscriptionsLoaded: mSubInfoInitialized="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubInfoInitialized:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 391
    iget-boolean v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubInfoInitialized:Z

    if-nez v0, :cond_1

    const/4 v0, 0x1

    .line 392
    iput-boolean v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubInfoInitialized:Z

    .line 393
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-object v3, v0, v2

    .line 394
    iget-object v3, v3, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v4, 0x9

    const/4 v5, 0x0

    invoke-interface {v3, p0, v4, v5}, Lcom/android/internal/telephony/CommandsInterface;->registerForRadioStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 396
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->reEvaluateAll()V

    .line 398
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->registerDataSettingsControllerCallbackAsNeeded()V

    return-void
.end method

.method private onCarrierConfigChanged(II)V
    .locals 4

    .line 436
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onCarrierConfigChanged phoneId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " subId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 437
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v0

    if-nez v0, :cond_0

    .line 438
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Carrier config change with invalid phoneId "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->loge(Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v0, -0x1

    if-ne p2, v0, :cond_1

    .line 446
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/SubscriptionController;->getSubId(I)[I

    move-result-object v0

    .line 447
    invoke-static {v0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty([I)Z

    move-result v1

    if-nez v1, :cond_1

    .line 448
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    const-string v2, "carrier_config"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/CarrierConfigManager;

    if-eqz v1, :cond_1

    const/4 v2, 0x0

    .line 450
    aget v3, v0, v2

    invoke-virtual {v1, v3}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 451
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onCarrierConfigChanged with invalid subId while subd "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v1, v0, v2

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " is active and its config is loaded"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/MultiSimSettingController;->loge(Ljava/lang/String;)V

    .line 453
    aget p2, v0, v2

    .line 458
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mCarrierConfigLoadedSubIds:[I

    aput p2, v0, p1

    .line 459
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->reEvaluateAll()V

    return-void
.end method

.method private onDefaultDataSettingChanged()V
    .locals 1

    const-string v0, "onDefaultDataSettingChanged"

    .line 521
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 522
    invoke-virtual {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->disableDataForNonDefaultNonOpportunisticSubscriptions()V

    return-void
.end method

.method private onRoamingDataEnabled(IZ)V
    .locals 1

    const-string v0, "onRoamingDataEnabled"

    .line 378
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 379
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/MultiSimSettingController;->setRoamingDataEnabledForGroup(IZ)V

    .line 382
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, p2, p1}, Lcom/android/internal/telephony/SubscriptionController;->setDataRoaming(II)I

    return-void
.end method

.method private onSubscriptionGroupChanged(Landroid/os/ParcelUuid;)V
    .locals 6

    const-string v0, "data_roaming"

    const-string v1, "mobile_data"

    const-string v2, "onSubscriptionGroupChanged"

    .line 532
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 534
    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v3, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 535
    invoke-virtual {v3}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v3

    iget-object v4, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {v4}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v4

    .line 534
    invoke-virtual {v2, p1, v3, v4}, Lcom/android/internal/telephony/SubscriptionController;->getSubscriptionsInGroup(Landroid/os/ParcelUuid;Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    if-eqz p1, :cond_3

    .line 536
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    goto :goto_2

    :cond_0
    const/4 v2, 0x0

    .line 540
    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/SubscriptionInfo;

    invoke-virtual {v3}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v3

    .line 541
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/SubscriptionInfo;

    .line 542
    invoke-virtual {v4}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v4

    .line 543
    iget-object v5, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v5, v4}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v5

    if-eqz v5, :cond_1

    iget-object v5, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v5, v4}, Lcom/android/internal/telephony/SubscriptionController;->isOpportunistic(I)Z

    move-result v5

    if-nez v5, :cond_1

    move v3, v4

    .line 548
    :cond_2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "refSubId is "

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    const/4 p1, -0x1

    .line 552
    :try_start_0
    iget-object v4, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-static {v4, v1, v3}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;I)Z

    move-result v4
    :try_end_0
    .catch Landroid/provider/Settings$SettingNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    .line 554
    :try_start_1
    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/MultiSimSettingController;->onUserDataEnabled(IZ)V
    :try_end_1
    .catch Landroid/provider/Settings$SettingNotFoundException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_0
    move v4, v2

    .line 557
    :catch_1
    iget-object v5, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-static {v5, v1, p1, v4}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result v1

    .line 559
    invoke-virtual {p0, v3, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->onUserDataEnabled(IZ)V

    .line 564
    :goto_0
    :try_start_2
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-static {v1, v0, v3}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;I)Z

    move-result v2

    .line 566
    invoke-direct {p0, v3, v2}, Lcom/android/internal/telephony/MultiSimSettingController;->onRoamingDataEnabled(IZ)V
    :try_end_2
    .catch Landroid/provider/Settings$SettingNotFoundException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    .line 569
    :catch_2
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-static {v1, v0, p1, v2}, Lcom/android/internal/telephony/GlobalSettingsHelper;->getBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    move-result p1

    .line 571
    invoke-direct {p0, v3, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->onRoamingDataEnabled(IZ)V

    .line 575
    :goto_1
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/SubscriptionController;->syncGroupedSetting(I)V

    :cond_3
    :goto_2
    return-void
.end method

.method private onSubscriptionsChanged()V
    .locals 1

    const-string v0, "onSubscriptionsChanged"

    .line 407
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 408
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->reEvaluateAll()V

    return-void
.end method

.method private reEvaluateAll()V
    .locals 1

    .line 511
    invoke-virtual {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->isReadyToReevaluate()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 512
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->updateDefaults()V

    .line 513
    invoke-virtual {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->disableDataForNonDefaultNonOpportunisticSubscriptions()V

    .line 514
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->deactivateGroupedOpportunisticSubscriptionIfNeeded()V

    return-void
.end method

.method private registerDataSettingsControllerCallbackAsNeeded()V
    .locals 6

    .line 1067
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 1068
    iget v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mCallbacksCount:I

    :goto_0
    array-length v2, v0

    if-ge v1, v2, :cond_1

    .line 1069
    aget-object v2, v0, v1

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 1070
    aget-object v2, v0, v1

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/MultiSimSettingController$DataSettingsControllerCallback;

    aget-object v4, v0, v1

    new-instance v5, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda3;

    invoke-direct {v5, p0}, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/MultiSimSettingController;)V

    invoke-direct {v3, v4, v5}, Lcom/android/internal/telephony/MultiSimSettingController$DataSettingsControllerCallback;-><init>(Lcom/android/internal/telephony/Phone;Ljava/util/concurrent/Executor;)V

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/data/DataSettingsManager;->registerCallback(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1074
    :cond_1
    array-length v0, v0

    iput v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mCallbacksCount:I

    return-void
.end method

.method private setRoamingDataEnabledForGroup(IZ)V
    .locals 3

    .line 909
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    .line 910
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 911
    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/SubscriptionController;->getGroupUuid(I)Landroid/os/ParcelUuid;

    move-result-object p1

    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 912
    invoke-virtual {v2}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v2

    .line 910
    invoke-virtual {v0, p1, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->getSubscriptionsInGroup(Landroid/os/ParcelUuid;Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    if-nez p1, :cond_0

    return-void

    .line 916
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/SubscriptionInfo;

    .line 918
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 919
    invoke-virtual {v0}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v0

    const-string v2, "data_roaming"

    .line 918
    invoke-static {v1, v2, v0, p2}, Lcom/android/internal/telephony/GlobalSettingsHelper;->setBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    goto :goto_0

    :cond_1
    return-void
.end method


# virtual methods
.method protected disableDataForNonDefaultNonOpportunisticSubscriptions()V
    .locals 8

    .line 834
    invoke-virtual {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->isReadyToReevaluate()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 836
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v0

    .line 838
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v2, :cond_3

    aget-object v5, v1, v4

    .line 839
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v6

    if-eq v6, v0, :cond_2

    .line 840
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v6

    invoke-static {v6}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v6

    if-eqz v6, :cond_2

    iget-object v6, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 841
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v7

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/SubscriptionController;->isOpportunistic(I)Z

    move-result v6

    if-nez v6, :cond_2

    .line 842
    invoke-interface {v5}, Lcom/android/internal/telephony/PhoneInternalInterface;->isUserDataEnabled()Z

    move-result v6

    if-eqz v6, :cond_2

    .line 843
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v6

    invoke-direct {p0, v0, v6}, Lcom/android/internal/telephony/MultiSimSettingController;->areSubscriptionsInSameGroup(II)Z

    move-result v6

    if-nez v6, :cond_2

    .line 844
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v7, "setting data to false on "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-direct {p0, v6}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 845
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v6

    if-eqz v6, :cond_1

    .line 846
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v5

    iget-object v6, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 848
    invoke-virtual {v6}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v6

    .line 846
    invoke-virtual {v5, v3, v3, v6}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDataEnabled(IZLjava/lang/String;)V

    goto :goto_1

    .line 850
    :cond_1
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v5

    invoke-virtual {v5, v3, v3}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setDataEnabled(IZ)V

    :cond_2
    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_3
    return-void
.end method

.method protected getSimCombinationWarningParams(I)Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;
    .locals 9

    .line 795
    new-instance v0, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;-><init>(Lcom/android/internal/telephony/MultiSimSettingController;)V

    .line 797
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    const/4 v2, 0x1

    if-gt v1, v2, :cond_0

    return-object v0

    .line 800
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->isUserVisibleChange(I)Z

    move-result p1

    if-nez p1, :cond_1

    return-object v0

    .line 802
    :cond_1
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    .line 804
    iget-object v3, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_2
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    .line 805
    invoke-static {v4}, Landroid/telephony/SubscriptionManager;->getPhoneId(I)I

    move-result v5

    invoke-static {v5}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v5

    if-eqz v5, :cond_2

    .line 807
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->isCdmaSubscriptionAppPresent()Z

    move-result v6

    if-eqz v6, :cond_2

    add-int/lit8 v1, v1, 0x1

    .line 809
    iget-object v6, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v7, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 810
    invoke-virtual {v7}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v7

    iget-object v8, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {v8}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v8

    .line 809
    invoke-virtual {v6, v4, v7, v8}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubscriptionInfo(ILjava/lang/String;Ljava/lang/String;)Landroid/telephony/SubscriptionInfo;

    move-result-object v4

    .line 811
    invoke-virtual {v4}, Landroid/telephony/SubscriptionInfo;->getDisplayName()Ljava/lang/CharSequence;

    move-result-object v4

    invoke-interface {v4}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v4

    .line 812
    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_3

    .line 814
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getCarrierName()Ljava/lang/String;

    move-result-object v4

    .line 816
    :cond_3
    invoke-interface {p1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_4
    if-le v1, v2, :cond_5

    .line 821
    iput v2, v0, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mWarningType:I

    const-string p0, " & "

    .line 822
    invoke-static {p0, p1}, Ljava/lang/String;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mSimNames:Ljava/lang/String;

    :cond_5
    return-object v0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 5

    .line 307
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    const/4 v2, 0x0

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_3

    .line 343
    :pswitch_0
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object p1

    array-length v0, p1

    move v1, v2

    :goto_0
    if-ge v1, v0, :cond_3

    aget-object v3, p1, v1

    .line 344
    iget-object v3, v3, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v3}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v3

    const/4 v4, 0x2

    if-ne v3, v4, :cond_0

    const-string p1, "Radio unavailable. Clearing sub info initialized flag."

    .line 345
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 346
    iput-boolean v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubInfoInitialized:Z

    goto :goto_3

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 339
    :pswitch_1
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    .line 340
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->onMultiSimConfigChanged(I)V

    goto :goto_3

    .line 334
    :pswitch_2
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 335
    iget p1, p1, Landroid/os/Message;->arg2:I

    .line 336
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->onCarrierConfigChanged(II)V

    goto :goto_3

    .line 331
    :pswitch_3
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->onDefaultDataSettingChanged()V

    goto :goto_3

    .line 327
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/ParcelUuid;

    .line 328
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->onSubscriptionGroupChanged(Landroid/os/ParcelUuid;)V

    goto :goto_3

    .line 324
    :pswitch_5
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->onSubscriptionsChanged()V

    goto :goto_3

    .line 321
    :pswitch_6
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->onAllSubscriptionsLoaded()V

    goto :goto_3

    .line 315
    :pswitch_7
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 316
    iget p1, p1, Landroid/os/Message;->arg2:I

    if-eqz p1, :cond_1

    goto :goto_1

    :cond_1
    move v1, v2

    .line 317
    :goto_1
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->onRoamingDataEnabled(IZ)V

    goto :goto_3

    .line 309
    :pswitch_8
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 310
    iget p1, p1, Landroid/os/Message;->arg2:I

    if-eqz p1, :cond_2

    goto :goto_2

    :cond_2
    move v1, v2

    .line 311
    :goto_2
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->onUserDataEnabled(IZ)V

    :cond_3
    :goto_3
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public isCarrierConfigLoadedForAllSub()Z
    .locals 10
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 467
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubIdList(Z)[I

    move-result-object v0

    .line 468
    array-length v2, v0

    move v3, v1

    :goto_0
    const/4 v4, 0x1

    if-ge v3, v2, :cond_3

    aget v5, v0, v3

    .line 470
    iget-object v6, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mCarrierConfigLoadedSubIds:[I

    array-length v7, v6

    move v8, v1

    :goto_1
    if-ge v8, v7, :cond_1

    aget v9, v6, v8

    if-ne v9, v5, :cond_0

    goto :goto_2

    :cond_0
    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    :cond_1
    move v4, v1

    :goto_2
    if-nez v4, :cond_2

    .line 477
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Carrier config subId "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " is not loaded."

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    return v1

    :cond_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_3
    return v4
.end method

.method protected isReadyToReevaluate()Z
    .locals 3

    .line 502
    invoke-virtual {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->isCarrierConfigLoadedForAllSub()Z

    move-result v0

    .line 504
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isReadyToReevaluate: subInfoInitialized="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubInfoInitialized:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", carrierConfigsLoaded="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 507
    iget-boolean p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubInfoInitialized:Z

    if-eqz p0, :cond_0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public notifyAllSubscriptionLoaded()V
    .locals 1

    const/4 v0, 0x3

    .line 280
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public notifyCarrierConfigChanged(II)V
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const/4 v0, 0x7

    .line 432
    invoke-virtual {p0, v0, p1, p2}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public notifyDefaultDataSubChanged()V
    .locals 1

    const/4 v0, 0x6

    .line 302
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public notifyRoamingDataEnabled(IZ)V
    .locals 1

    .line 270
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x2

    .line 271
    invoke-virtual {p0, v0, p1, p2}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    :cond_0
    return-void
.end method

.method public notifySubscriptionGroupChanged(Landroid/os/ParcelUuid;)V
    .locals 1

    const/4 v0, 0x5

    .line 295
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public notifySubscriptionInfoChanged()V
    .locals 1

    const-string v0, "notifySubscriptionInfoChanged"

    .line 287
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    const/4 v0, 0x4

    .line 288
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public notifyUserDataEnabled(IZ)V
    .locals 1

    .line 261
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    .line 262
    invoke-virtual {p0, v0, p1, p2}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    :cond_0
    return-void
.end method

.method protected onMultiSimConfigChanged(I)V
    .locals 5

    .line 488
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mCarrierConfigLoadedSubIds:[I

    array-length v1, v0

    if-ge p1, v1, :cond_0

    const/4 v1, -0x1

    .line 489
    aput v1, v0, p1

    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 491
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object p1

    array-length v0, p1

    const/4 v1, 0x0

    :goto_1
    if-ge v1, v0, :cond_1

    aget-object v2, p1, v1

    .line 492
    iget-object v2, v2, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v3, 0x9

    const/4 v4, 0x0

    invoke-interface {v2, p0, v3, v4}, Lcom/android/internal/telephony/CommandsInterface;->registerForRadioStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 494
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->registerDataSettingsControllerCallbackAsNeeded()V

    return-void
.end method

.method public onPhoneRemoved()V
    .locals 2

    const-string v0, "onPhoneRemoved"

    .line 419
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 420
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v1

    if-ne v0, v1, :cond_0

    .line 424
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->reEvaluateAll()V

    return-void

    .line 421
    :cond_0
    new-instance p0, Ljava/lang/RuntimeException;

    const-string v0, "This method must be called from the same looper as MultiSimSettingController."

    invoke-direct {p0, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method protected onUserDataEnabled(IZ)V
    .locals 1

    const-string v0, "onUserDataEnabled"

    .line 361
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 363
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/MultiSimSettingController;->setUserDataEnabledForGroup(IZ)V

    .line 366
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v0

    if-eq v0, p1, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/SubscriptionController;->isOpportunistic(I)Z

    move-result v0

    if-nez v0, :cond_0

    if-eqz p2, :cond_0

    iget-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 367
    invoke-virtual {p2, p1}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result p2

    if-eqz p2, :cond_0

    .line 368
    iget-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {p2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p2

    const-string/jumbo v0, "user_preferred_data_sub"

    invoke-static {p2, v0, p1}, Landroid/provider/Settings$Global;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    .line 370
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultDataSubId(I)V

    :cond_0
    return-void
.end method

.method protected sendDefaultSubConfirmedNotification(I)V
    .locals 3

    .line 720
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    const-string v1, "android.telephony.action.PRIMARY_SUBSCRIPTION_LIST_CHANGED"

    .line 721
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "com.android.settings"

    const-string v2, "com.android.settings.sim.SimSelectNotification"

    .line 722
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "android.telephony.extra.DEFAULT_SUBSCRIPTION_SELECT_TYPE"

    const/4 v2, 0x5

    .line 725
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v1, "android.telephony.extra.SUBSCRIPTION_ID"

    .line 727
    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 729
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    return-void
.end method

.method protected sendSubChangeNotificationIfNeeded(IZZZ)V
    .locals 1

    .line 735
    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/MultiSimSettingController;->getSimSelectDialogType(IZZZ)I

    move-result p2

    .line 737
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->getSimCombinationWarningParams(I)Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;

    move-result-object p1

    if-nez p2, :cond_0

    .line 739
    iget p3, p1, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mWarningType:I

    if-eqz p3, :cond_3

    .line 741
    :cond_0
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "[sendSubChangeNotificationIfNeeded] showing dialog type "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-direct {p0, p3}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 743
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "[sendSubChangeNotificationIfNeeded] showing sim warning "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p4, p1, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mWarningType:I

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-direct {p0, p3}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 745
    new-instance p3, Landroid/content/Intent;

    invoke-direct {p3}, Landroid/content/Intent;-><init>()V

    const-string p4, "android.telephony.action.PRIMARY_SUBSCRIPTION_LIST_CHANGED"

    .line 746
    invoke-virtual {p3, p4}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const-string p4, "com.android.settings"

    const-string v0, "com.android.settings.sim.SimSelectNotification"

    .line 747
    invoke-virtual {p3, p4, v0}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const/high16 p4, 0x10000000

    .line 749
    invoke-virtual {p3, p4}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    const-string p4, "android.telephony.extra.DEFAULT_SUBSCRIPTION_SELECT_TYPE"

    .line 751
    invoke-virtual {p3, p4, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const/4 p4, 0x4

    if-ne p2, p4, :cond_1

    .line 753
    iget-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    const/4 p4, 0x0

    invoke-interface {p2, p4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/io/Serializable;

    const-string p4, "android.telephony.extra.SUBSCRIPTION_ID"

    invoke-virtual {p3, p4, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    .line 756
    :cond_1
    iget p2, p1, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mWarningType:I

    const-string p4, "android.telephony.extra.SIM_COMBINATION_WARNING_TYPE"

    invoke-virtual {p3, p4, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 757
    iget p2, p1, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mWarningType:I

    const/4 p4, 0x1

    if-ne p2, p4, :cond_2

    .line 758
    iget-object p1, p1, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mSimNames:Ljava/lang/String;

    const-string p2, "android.telephony.extra.SIM_COMBINATION_NAMES"

    invoke-virtual {p3, p2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 760
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {p0, p3}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    :cond_3
    return-void
.end method

.method protected setUserDataEnabledForGroup(IZ)V
    .locals 3

    .line 872
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "setUserDataEnabledForGroup subId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " enable "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 873
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 874
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/SubscriptionController;->getGroupUuid(I)Landroid/os/ParcelUuid;

    move-result-object p1

    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 875
    invoke-virtual {v2}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v2

    .line 873
    invoke-virtual {v0, p1, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->getSubscriptionsInGroup(Landroid/os/ParcelUuid;Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    if-nez p1, :cond_0

    return-void

    .line 879
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_1
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/SubscriptionInfo;

    .line 880
    invoke-virtual {v0}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v0

    .line 882
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 884
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->getPhoneId(I)I

    move-result v0

    invoke-static {v0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 888
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_2

    .line 889
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 891
    invoke-virtual {v1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    .line 889
    invoke-virtual {v0, v2, p2, v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDataEnabled(IZLjava/lang/String;)V

    goto :goto_0

    .line 893
    :cond_2
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v0

    invoke-virtual {v0, p2, v2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setUserDataEnabled(ZZ)V

    goto :goto_0

    .line 898
    :cond_3
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    const-string v2, "mobile_data"

    invoke-static {v1, v2, v0, p2}, Lcom/android/internal/telephony/GlobalSettingsHelper;->setBoolean(Landroid/content/Context;Ljava/lang/String;IZ)Z

    goto :goto_0

    :cond_4
    return-void
.end method

.method protected updateDefaultValue(Ljava/util/List;ILcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;)Z
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;I",
            "Lcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;",
            ")Z"
        }
    .end annotation

    const/4 v0, 0x1

    .line 930
    invoke-virtual {p0, p1, p2, p3, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->updateDefaultValue(Ljava/util/List;ILcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;Z)Z

    move-result p0

    return p0
.end method

.method protected updateDefaultValue(Ljava/util/List;ILcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;Z)Z
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;I",
            "Lcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;",
            "Z)Z"
        }
    .end annotation

    .line 937
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, -0x1

    if-lez v0, :cond_2

    .line 938
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 939
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[updateDefaultValue] Record.id: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 945
    invoke-direct {p0, v0, p2}, Lcom/android/internal/telephony/MultiSimSettingController;->areSubscriptionsInSameGroup(II)Z

    move-result v2

    if-nez v2, :cond_1

    if-nez p4, :cond_0

    if-ne p2, v1, :cond_0

    .line 948
    :cond_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "[updateDefaultValue] updates to subId="

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    move v1, v0

    :cond_2
    if-eq p2, v1, :cond_3

    .line 955
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "[updateDefaultValue: subId] from "

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " to "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 956
    invoke-interface {p3, v1}, Lcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;->update(I)V

    .line 959
    :cond_3
    invoke-static {v1}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result p0

    return p0
.end method

.method protected updateDefaults()V
    .locals 7

    const-string/jumbo v0, "updateDefaults"

    .line 593
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 595
    invoke-virtual {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->isReadyToReevaluate()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 597
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 598
    invoke-virtual {v1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    .line 599
    invoke-virtual {v2}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v2

    .line 598
    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubscriptionInfoList(Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    .line 601
    invoke-static {v0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty(Ljava/util/Collection;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 602
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    const-string v0, "[updateDefaultValues] No active sub. Setting default to INVALID sub."

    .line 603
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 604
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultDataSubId(I)V

    .line 605
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultVoiceSubId(I)V

    .line 606
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultSmsSubId(I)V

    return-void

    .line 610
    :cond_1
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->updatePrimarySubListAndGetChangeType(Ljava/util/List;)I

    move-result v0

    .line 611
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[updateDefaultValues] change: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    if-nez v0, :cond_2

    return-void

    .line 619
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    const/4 v2, 0x1

    if-ne v1, v2, :cond_4

    const/4 v1, 0x2

    if-ne v0, v1, :cond_3

    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    const-string v3, "phone"

    .line 620
    invoke-virtual {v1, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/TelephonyManager;

    .line 621
    invoke-virtual {v1}, Landroid/telephony/TelephonyManager;->getActiveModemCount()I

    move-result v1

    if-ne v1, v2, :cond_4

    .line 622
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 623
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[updateDefaultValues] to only primary sub "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 624
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultDataSubId(I)V

    .line 625
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultVoiceSubId(I)V

    .line 626
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultSmsSubId(I)V

    .line 627
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->sendDefaultSubConfirmedNotification(I)V

    return-void

    .line 631
    :cond_4
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[updateDefaultValues] records: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    const-string v1, "[updateDefaultValues] Update default data subscription"

    .line 634
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 635
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 636
    invoke-virtual {v2}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v2

    new-instance v3, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/MultiSimSettingController;)V

    .line 635
    invoke-virtual {p0, v1, v2, v3}, Lcom/android/internal/telephony/MultiSimSettingController;->updateDefaultValue(Ljava/util/List;ILcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;)Z

    move-result v1

    const-string v2, "[updateDefaultValues] Update default voice subscription"

    .line 640
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 641
    iget-object v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    iget-object v3, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 642
    invoke-virtual {v3}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultVoiceSubId()I

    move-result v3

    new-instance v4, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda1;

    invoke-direct {v4, p0}, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/MultiSimSettingController;)V

    .line 641
    invoke-virtual {p0, v2, v3, v4}, Lcom/android/internal/telephony/MultiSimSettingController;->updateDefaultValue(Ljava/util/List;ILcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;)Z

    move-result v2

    const-string v3, "[updateDefaultValues] Update default sms subscription"

    .line 646
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 647
    iget-object v3, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    iget-object v4, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 648
    invoke-virtual {v4}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultSmsSubId()I

    move-result v4

    new-instance v5, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda2;

    invoke-direct {v5, p0}, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/MultiSimSettingController;)V

    iget-boolean v6, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mIsAskEverytimeSupportedForSms:Z

    .line 647
    invoke-virtual {p0, v3, v4, v5, v6}, Lcom/android/internal/telephony/MultiSimSettingController;->updateDefaultValue(Ljava/util/List;ILcom/android/internal/telephony/MultiSimSettingController$UpdateDefaultAction;Z)Z

    move-result v3

    .line 652
    iget-object v4, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mContext:Landroid/content/Context;

    invoke-virtual {v4}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v5, 0x11101f7

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result v4

    if-nez v4, :cond_5

    .line 659
    invoke-virtual {p0, v0, v1, v2, v3}, Lcom/android/internal/telephony/MultiSimSettingController;->sendSubChangeNotificationIfNeeded(IZZZ)V

    goto :goto_0

    .line 661
    :cond_5
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-virtual {p0, v0, v1, v2, v3}, Lcom/android/internal/telephony/MultiSimSettingController;->updateUserPreferences(Ljava/util/List;ZZZ)V

    :goto_0
    return-void
.end method

.method protected updatePrimarySubListAndGetChangeType(Ljava/util/List;)I
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/SubscriptionInfo;",
            ">;)I"
        }
    .end annotation

    .line 669
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    .line 670
    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v1, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda4;

    invoke-direct {v1}, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda4;-><init>()V

    invoke-interface {p1, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v1, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda5;

    invoke-direct {v1}, Lcom/android/internal/telephony/MultiSimSettingController$$ExternalSyntheticLambda5;-><init>()V

    .line 671
    invoke-interface {p1, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 672
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p1, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/List;

    iput-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    .line 674
    iget-boolean v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mInitialHandling:Z

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 675
    iput-boolean v2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mInitialHandling:Z

    const/4 p0, 0x6

    return p0

    .line 678
    :cond_0
    invoke-interface {p1, v0}, Ljava/util/List;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    return v2

    .line 679
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    const/4 v3, 0x1

    if-le p1, v1, :cond_2

    return v3

    .line 681
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    if-ne p1, v1, :cond_7

    .line 684
    iget-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_3
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_6

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 686
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_4
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_5

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/Integer;

    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v5

    .line 687
    invoke-direct {p0, v1, v5}, Lcom/android/internal/telephony/MultiSimSettingController;->areSubscriptionsInSameGroup(II)Z

    move-result v5

    if-eqz v5, :cond_4

    move v1, v3

    goto :goto_0

    :cond_5
    move v1, v2

    :goto_0
    if-nez v1, :cond_3

    const/4 p0, 0x3

    return p0

    :cond_6
    const/4 p0, 0x4

    return p0

    .line 699
    :cond_7
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_8
    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_d

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 700
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_9

    goto :goto_1

    .line 701
    :cond_9
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v1

    if-nez v1, :cond_c

    .line 702
    iget-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mPrimarySubList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_a
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_b

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 703
    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->areSubscriptionsInSameGroup(II)Z

    move-result v1

    if-eqz v1, :cond_a

    const/4 p0, 0x7

    return p0

    :cond_b
    const/4 p0, 0x2

    return p0

    .line 709
    :cond_c
    iget-object v1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->isOpportunistic(I)Z

    move-result v1

    if-nez v1, :cond_8

    .line 711
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[updatePrimarySubListAndGetChangeType]: missing active primary subId "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/MultiSimSettingController;->loge(Ljava/lang/String;)V

    goto :goto_1

    :cond_d
    const/4 p0, 0x5

    return p0
.end method

.method protected updateUserPreferences(Ljava/util/List;ZZZ)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;ZZZ)V"
        }
    .end annotation

    .line 1006
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_6

    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubInfoCountMax()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    goto/16 :goto_1

    .line 1008
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->isRadioAvailableOnAllSubs()Z

    move-result v0

    if-nez v0, :cond_1

    const-string p1, "Radio is in Invalid state, Ignore Updating User Preference!!!"

    .line 1009
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    return-void

    .line 1012
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v0

    .line 1014
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "updateUserPreferences:  dds = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " voice = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 1015
    invoke-virtual {v4}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultVoiceSubId()I

    move-result v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " sms = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 1016
    invoke-virtual {v5}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultSmsSubId()I

    move-result v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 1014
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    const/4 v2, 0x0

    .line 1018
    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 1020
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v5

    if-ne v5, v1, :cond_2

    if-nez p4, :cond_2

    .line 1021
    iget-object p4, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p4, v2}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultSmsSubId(I)V

    .line 1024
    :cond_2
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p4

    if-ne p4, v1, :cond_3

    if-nez p3, :cond_3

    .line 1025
    iget-object p3, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p3, v2}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultVoiceSubId(I)V

    .line 1028
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/MultiSimSettingController;->getUserPrefDataSubIdFromDB()I

    move-result p3

    .line 1030
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "User pref subId = "

    invoke-virtual {p4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " current dds "

    invoke-virtual {p4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " next active subId "

    invoke-virtual {p4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    invoke-direct {p0, p4}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    .line 1034
    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p4

    invoke-interface {p1, p4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 1035
    invoke-static {p3}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result p1

    if-eqz p1, :cond_4

    if-eq v0, p3, :cond_4

    .line 1037
    iget-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p1, p3}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultDataSubId(I)V

    goto :goto_0

    :cond_4
    if-nez p2, :cond_5

    .line 1039
    iget-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/SubscriptionController;->setDefaultDataSubId(I)V

    .line 1043
    :cond_5
    :goto_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p2, "updateUserPreferences: after dds = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p2}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 1044
    invoke-virtual {p2}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultVoiceSubId()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/MultiSimSettingController;->mSubController:Lcom/android/internal/telephony/SubscriptionController;

    .line 1045
    invoke-virtual {p2}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultSmsSubId()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1043
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MultiSimSettingController;->log(Ljava/lang/String;)V

    :cond_6
    :goto_1
    return-void
.end method
