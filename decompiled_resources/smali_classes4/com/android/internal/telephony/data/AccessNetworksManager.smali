.class public Lcom/android/internal/telephony/data/AccessNetworksManager;
.super Landroid/os/Handler;
.source "AccessNetworksManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;,
        Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceCallback;,
        Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback;,
        Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;,
        Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerDeathRecipient;,
        Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;,
        Lcom/android/internal/telephony/data/AccessNetworksManager$IwlanOperationMode;
    }
.end annotation


# static fields
.field private static final DBG:Z = false

.field public static final IWLAN_OPERATION_MODE_AP_ASSISTED:Ljava/lang/String; = "AP-assisted"

.field public static final IWLAN_OPERATION_MODE_DEFAULT:Ljava/lang/String; = "default"

.field public static final IWLAN_OPERATION_MODE_LEGACY:Ljava/lang/String; = "legacy"

.field public static final SUPPORTED_APN_TYPES:[I

.field public static final SYSTEM_PROPERTIES_IWLAN_OPERATION_MODE:Ljava/lang/String; = "ro.telephony.iwlan_operation_mode"


# instance fields
.field private final mAccessNetworksManagerCallbacks:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;",
            ">;"
        }
    .end annotation
.end field

.field private final mAnomalyUUID:Ljava/util/UUID;

.field private final mAvailableNetworks:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "[I>;"
        }
    .end annotation
.end field

.field private final mAvailableTransports:[I

.field private final mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

.field private final mConfigChangedReceiver:Landroid/content/BroadcastReceiver;

.field private final mCurrentTransports:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mDataThrottlers:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/dataconnection/DataThrottler;",
            ">;"
        }
    .end annotation
.end field

.field private mDeathRecipient:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerDeathRecipient;

.field private mIQualifiedNetworksService:Landroid/telephony/data/IQualifiedNetworksService;

.field private mLastBoundPackageName:Ljava/lang/String;

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mLogTag:Ljava/lang/String;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mPreferredTransports:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mQualifiedNetworksChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mServiceConnection:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

.field private mTargetBindingPackageName:Ljava/lang/String;


# direct methods
.method public static synthetic $r8$lambda$JZTBiubag4NpScnvBor29iaaYUU(Lcom/android/internal/telephony/data/AccessNetworksManager;Lcom/android/internal/telephony/dataconnection/DataThrottler;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->lambda$registerDataThrottler$0(Lcom/android/internal/telephony/dataconnection/DataThrottler;)V

    return-void
.end method

.method public static synthetic $r8$lambda$KmLqnfX0vxiGY8gFbWZg6FNz-Hw(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->lambda$setPreferredTransports$3(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V

    return-void
.end method

.method public static synthetic $r8$lambda$nro4zkcZcqxu7Cuy27rFSs0-KPk(Lcom/android/internal/telephony/data/AccessNetworksManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->lambda$bindQualifiedNetworksService$2()V

    return-void
.end method

.method public static synthetic $r8$lambda$q8i6QBgDv2IkH1yo2lJ-hxcwsLg(Lcom/android/internal/telephony/data/AccessNetworksManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->lambda$new$1()V

    return-void
.end method

.method public static synthetic $r8$lambda$z7oDEz23l3J_ZEiQA8PurcLrADA(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->lambda$setPreferredTransports$4(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmAccessNetworksManagerCallbacks(Lcom/android/internal/telephony/data/AccessNetworksManager;)Ljava/util/Set;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAccessNetworksManagerCallbacks:Ljava/util/Set;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmAnomalyUUID(Lcom/android/internal/telephony/data/AccessNetworksManager;)Ljava/util/UUID;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAnomalyUUID:Ljava/util/UUID;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmAvailableNetworks(Lcom/android/internal/telephony/data/AccessNetworksManager;)Landroid/util/SparseArray;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableNetworks:Landroid/util/SparseArray;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDataThrottlers(Lcom/android/internal/telephony/data/AccessNetworksManager;)Ljava/util/Set;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mDataThrottlers:Ljava/util/Set;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDeathRecipient(Lcom/android/internal/telephony/data/AccessNetworksManager;)Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerDeathRecipient;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mDeathRecipient:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerDeathRecipient;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmIQualifiedNetworksService(Lcom/android/internal/telephony/data/AccessNetworksManager;)Landroid/telephony/data/IQualifiedNetworksService;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mIQualifiedNetworksService:Landroid/telephony/data/IQualifiedNetworksService;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLastBoundPackageName(Lcom/android/internal/telephony/data/AccessNetworksManager;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLastBoundPackageName:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/AccessNetworksManager;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPreferredTransports(Lcom/android/internal/telephony/data/AccessNetworksManager;)Ljava/util/Map;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPreferredTransports:Ljava/util/Map;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmQualifiedNetworksChangedRegistrants(Lcom/android/internal/telephony/data/AccessNetworksManager;)Lcom/android/internal/telephony/RegistrantList;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mQualifiedNetworksChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmDeathRecipient(Lcom/android/internal/telephony/data/AccessNetworksManager;Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerDeathRecipient;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mDeathRecipient:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerDeathRecipient;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIQualifiedNetworksService(Lcom/android/internal/telephony/data/AccessNetworksManager;Landroid/telephony/data/IQualifiedNetworksService;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mIQualifiedNetworksService:Landroid/telephony/data/IQualifiedNetworksService;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmLastBoundPackageName(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLastBoundPackageName:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmTargetBindingPackageName(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mTargetBindingPackageName:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$mbindQualifiedNetworksService(Lcom/android/internal/telephony/data/AccessNetworksManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->bindQualifiedNetworksService()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mgetQualifiedNetworksServicePackageName(Lcom/android/internal/telephony/data/AccessNetworksManager;)Ljava/lang/String;
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getQualifiedNetworksServicePackageName()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mlog(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->log(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mloge(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->loge(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mloge(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/lang/String;Ljava/lang/Exception;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->loge(Ljava/lang/String;Ljava/lang/Exception;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mlogl(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->logl(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$msetPreferredTransports(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->setPreferredTransports(Ljava/util/List;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    const/16 v0, 0x8

    new-array v0, v0, [I

    .line 119
    fill-array-data v0, :array_0

    sput-object v0, Lcom/android/internal/telephony/data/AccessNetworksManager;->SUPPORTED_APN_TYPES:[I

    return-void

    :array_0
    .array-data 4
        0x11
        0x2
        0x20
        0x40
        0x80
        0x4
        0x200
        0x800
    .end array-data
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V
    .locals 5

    .line 420
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 115
    new-instance p2, Lcom/android/internal/telephony/LocalLog;

    const/16 v0, 0x40

    invoke-direct {p2, v0}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    const-string p2, "c2d1a639-00e2-4561-9619-6acf37d90590"

    .line 116
    invoke-static {p2}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAnomalyUUID:Ljava/util/UUID;

    .line 143
    new-instance p2, Landroid/util/SparseArray;

    invoke-direct {p2}, Landroid/util/SparseArray;-><init>()V

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableNetworks:Landroid/util/SparseArray;

    .line 147
    new-instance p2, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {p2}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mQualifiedNetworksChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 149
    new-instance p2, Ljava/util/HashSet;

    invoke-direct {p2}, Ljava/util/HashSet;-><init>()V

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mDataThrottlers:Ljava/util/Set;

    .line 151
    new-instance p2, Lcom/android/internal/telephony/data/AccessNetworksManager$1;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$1;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mConfigChangedReceiver:Landroid/content/BroadcastReceiver;

    .line 171
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mCurrentTransports:Ljava/util/Map;

    .line 181
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPreferredTransports:Ljava/util/Map;

    .line 186
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAccessNetworksManagerCallbacks:Ljava/util/Set;

    .line 421
    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 422
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    .line 424
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ANM-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLogTag:Ljava/lang/String;

    .line 426
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    const-string p2, "operates in legacy mode."

    .line 427
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->log(Ljava/lang/String;)V

    const/4 p2, 0x1

    new-array v0, p2, [I

    aput p2, v0, v1

    .line 430
    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableTransports:[I

    goto :goto_1

    :cond_0
    const-string v0, "operates in AP-assisted mode."

    .line 432
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->log(Ljava/lang/String;)V

    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 433
    fill-array-data v0, :array_0

    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableTransports:[I

    .line 435
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    const-string v2, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 436
    invoke-virtual {v0, v2}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 438
    :try_start_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 439
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    sget-object v4, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    .line 438
    invoke-virtual {v2, v3, v1, v4}, Landroid/content/Context;->createPackageContextAsUser(Ljava/lang/String;ILandroid/os/UserHandle;)Landroid/content/Context;

    move-result-object v1

    const/4 v2, 0x0

    .line 440
    invoke-virtual {v1, p2, v0, v2, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p2

    const-string v0, "Package name not found: "

    .line 443
    invoke-direct {p0, v0, p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->loge(Ljava/lang/String;Ljava/lang/Exception;)V

    .line 445
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->bindQualifiedNetworksService()V

    .line 448
    :goto_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 451
    new-instance p1, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda3;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager;)V

    invoke-virtual {p0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :cond_1
    return-void

    :array_0
    .array-data 4
        0x1
        0x2
    .end array-data
.end method

.method private bindQualifiedNetworksService()V
    .locals 1

    .line 474
    new-instance v0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager;)V

    invoke-virtual {p0, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private getQualifiedNetworksList()Ljava/util/List;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;",
            ">;"
        }
    .end annotation

    .line 579
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    .line 580
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableNetworks:Landroid/util/SparseArray;

    invoke-virtual {v2}, Landroid/util/SparseArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_0

    .line 581
    new-instance v2, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;

    iget-object v3, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableNetworks:Landroid/util/SparseArray;

    invoke-virtual {v3, v1}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    iget-object v4, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableNetworks:Landroid/util/SparseArray;

    .line 582
    invoke-virtual {v4, v1}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, [I

    invoke-direct {v2, v3, v4}, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;-><init>(I[I)V

    .line 581
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method private getQualifiedNetworksServiceClassName()Ljava/lang/String;
    .locals 2

    .line 560
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x1040298

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 563
    iget-object v1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v1, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_0

    const-string v1, "carrier_qualified_networks_service_class_override_string"

    .line 567
    invoke-virtual {p0, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 569
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    move-object v0, p0

    :cond_0
    return-object v0
.end method

.method private getQualifiedNetworksServicePackageName()Ljava/lang/String;
    .locals 2

    .line 535
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x1040299

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 538
    iget-object v1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v1, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_0

    const-string v1, "carrier_qualified_networks_service_package_override_string"

    .line 542
    invoke-virtual {p0, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 544
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    move-object v0, p0

    :cond_0
    return-object v0
.end method

.method private static getTransportFromAccessNetwork(I)I
    .locals 1

    const/4 v0, 0x5

    if-ne p0, v0, :cond_0

    const/4 p0, 0x2

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    :goto_0
    return p0
.end method

.method private synthetic lambda$bindQualifiedNetworksService$2()V
    .locals 5

    .line 476
    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getQualifiedNetworksServicePackageName()Ljava/lang/String;

    move-result-object v0

    .line 477
    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getQualifiedNetworksServiceClassName()Ljava/lang/String;

    move-result-object v1

    .line 480
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_0

    const-string v0, "Can\'t find the binding package"

    .line 481
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->loge(Ljava/lang/String;)V

    return-void

    .line 485
    :cond_0
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    const-string v3, "android.telephony.data.QualifiedNetworksService"

    if-eqz v2, :cond_1

    .line 486
    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 487
    invoke-virtual {v1, v0}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    goto :goto_0

    .line 489
    :cond_1
    new-instance v2, Landroid/content/ComponentName;

    invoke-direct {v2, v0, v1}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 490
    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 491
    invoke-virtual {v1, v2}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v1

    .line 494
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mTargetBindingPackageName:Ljava/lang/String;

    invoke-static {v0, v2}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_2

    return-void

    .line 499
    :cond_2
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mIQualifiedNetworksService:Landroid/telephony/data/IQualifiedNetworksService;

    if-eqz v2, :cond_3

    .line 500
    invoke-interface {v2}, Landroid/telephony/data/IQualifiedNetworksService;->asBinder()Landroid/os/IBinder;

    move-result-object v2

    invoke-interface {v2}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result v2

    if-eqz v2, :cond_3

    .line 503
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mIQualifiedNetworksService:Landroid/telephony/data/IQualifiedNetworksService;

    iget-object v3, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 504
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    .line 503
    invoke-interface {v2, v3}, Landroid/telephony/data/IQualifiedNetworksService;->removeNetworkAvailabilityProvider(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v2

    .line 506
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Cannot remove network availability updater. "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->loge(Ljava/lang/String;)V

    .line 509
    :goto_1
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mServiceConnection:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

    invoke-virtual {v2, v3}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 513
    :cond_3
    :try_start_1
    new-instance v2, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager;)V

    iput-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mServiceConnection:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

    .line 514
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "bind to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->log(Ljava/lang/String;)V

    .line 515
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mServiceConnection:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

    const/4 v4, 0x1

    invoke-virtual {v2, v1, v3, v4}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v1

    if-nez v1, :cond_4

    const-string v0, "Cannot bind to the qualified networks service."

    .line 517
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->loge(Ljava/lang/String;)V

    return-void

    .line 520
    :cond_4
    iput-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mTargetBindingPackageName:Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_2

    :catch_1
    move-exception v0

    .line 522
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Cannot bind to the qualified networks service. Exception: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->loge(Ljava/lang/String;)V

    :goto_2
    return-void
.end method

.method private synthetic lambda$new$1()V
    .locals 3

    .line 451
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataRetryManager()Lcom/android/internal/telephony/data/DataRetryManager;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/AccessNetworksManager$2;

    new-instance v2, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager;)V

    invoke-direct {v1, p0, v2}, Lcom/android/internal/telephony/data/AccessNetworksManager$2;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager;Ljava/util/concurrent/Executor;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager;->registerCallback(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    return-void
.end method

.method private synthetic lambda$registerDataThrottler$0(Lcom/android/internal/telephony/dataconnection/DataThrottler;)V
    .locals 1

    .line 196
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mServiceConnection:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

    .line 197
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mDataThrottlers:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    if-eqz v0, :cond_0

    .line 199
    invoke-static {v0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;->-$$Nest$mregisterDataThrottler(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;Lcom/android/internal/telephony/dataconnection/DataThrottler;)V

    :cond_0
    return-void
.end method

.method private static synthetic lambda$setPreferredTransports$3(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V
    .locals 0

    .line 703
    iget p1, p1, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;->apnType:I

    .line 704
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->apnTypeToNetworkCapability(I)I

    move-result p1

    .line 703
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;->onPreferredTransportChanged(I)V

    return-void
.end method

.method private static synthetic lambda$setPreferredTransports$4(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;)V
    .locals 1

    .line 702
    new-instance v0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda0;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 797
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 801
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;Ljava/lang/Exception;)V
    .locals 0

    .line 805
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method private logl(Ljava/lang/String;)V
    .locals 0

    .line 809
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->log(Ljava/lang/String;)V

    .line 810
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method private setPreferredTransports(Ljava/util/List;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;",
            ">;)V"
        }
    .end annotation

    .line 696
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;

    .line 697
    iget-object v1, v0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;->qualifiedNetworks:[I

    array-length v2, v1

    if-lez v2, :cond_0

    const/4 v2, 0x0

    .line 698
    aget v1, v1, v2

    invoke-static {v1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getTransportFromAccessNetwork(I)I

    move-result v1

    .line 699
    iget v2, v0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;->apnType:I

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransport(I)I

    move-result v2

    if-eq v2, v1, :cond_0

    .line 700
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPreferredTransports:Ljava/util/Map;

    iget v3, v0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;->apnType:I

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 701
    iget-object v2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAccessNetworksManagerCallbacks:Ljava/util/Set;

    new-instance v3, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda2;

    invoke-direct {v3, v0}, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V

    invoke-interface {v2, v3}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 705
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "setPreferredTransports: apnType="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, v0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;->apnType:I

    .line 706
    invoke-static {v0}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", transport="

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 707
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 705
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->logl(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 8

    .line 821
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 822
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class v1, Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "-"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 823
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "current transports="

    .line 824
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 825
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 826
    sget-object p2, Lcom/android/internal/telephony/data/AccessNetworksManager;->SUPPORTED_APN_TYPES:[I

    array-length v1, p2

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    const-string v4, ": "

    if-ge v3, v1, :cond_0

    aget v5, p2, v3

    .line 827
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {v5}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 829
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getCurrentTransport(I)I

    move-result v4

    .line 828
    invoke-static {v4}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 827
    invoke-virtual {v0, v4}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 831
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "preferred transports="

    .line 832
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 833
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 834
    sget-object p2, Lcom/android/internal/telephony/data/AccessNetworksManager;->SUPPORTED_APN_TYPES:[I

    array-length v1, p2

    :goto_1
    if-ge v2, v1, :cond_1

    aget v3, p2, v2

    .line 835
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {v3}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 837
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransport(I)I

    move-result v3

    .line 836
    invoke-static {v3}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 835
    invoke-virtual {v0, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 840
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 841
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isInLegacy="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 842
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "IWLAN operation mode="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "ro.telephony.iwlan_operation_mode"

    .line 843
    invoke-static {v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 842
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs="

    .line 844
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 845
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 846
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 847
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 848
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 849
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public declared-synchronized getAvailableTransports()[I
    .locals 1

    monitor-enter p0

    .line 632
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableTransports:[I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public getCurrentTransport(I)I
    .locals 3

    .line 654
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    .line 659
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mCurrentTransports:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_1

    goto :goto_0

    .line 660
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mCurrentTransports:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result v1

    :goto_0
    return v1
.end method

.method public getCurrentTransportByNetworkCapability(I)I
    .locals 0

    .line 642
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToApnType(I)I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getCurrentTransport(I)I

    move-result p0

    return p0
.end method

.method public getPreferredTransport(I)I
    .locals 3

    .line 721
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    .line 725
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPreferredTransports:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_1

    goto :goto_0

    .line 726
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPreferredTransports:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result v1

    :goto_0
    return v1
.end method

.method public getPreferredTransportByNetworkCapability(I)I
    .locals 0

    .line 738
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToApnType(I)I

    move-result p1

    if-nez p1, :cond_0

    const/4 p0, 0x1

    return p0

    .line 743
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransport(I)I

    move-result p0

    return p0
.end method

.method public isAnyApnOnIwlan()Z
    .locals 8

    .line 752
    sget-object v0, Lcom/android/internal/telephony/data/AccessNetworksManager;->SUPPORTED_APN_TYPES:[I

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget v4, v0, v3

    .line 753
    iget-object v5, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v5

    const/4 v6, 0x2

    const/4 v7, 0x1

    if-eqz v5, :cond_0

    .line 754
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransport(I)I

    move-result v4

    if-ne v4, v6, :cond_1

    return v7

    .line 758
    :cond_0
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getCurrentTransport(I)I

    move-result v4

    if-ne v4, v6, :cond_1

    return v7

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return v2
.end method

.method public isInLegacyMode()Z
    .locals 2

    const-string v0, "ro.telephony.iwlan_operation_mode"

    .line 614
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "AP-assisted"

    .line 616
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const-string v1, "legacy"

    .line 618
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 p0, 0x1

    return p0

    .line 622
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object p0

    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p0

    return p0
.end method

.method public registerCallback(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;)V
    .locals 0

    .line 783
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAccessNetworksManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public registerDataThrottler(Lcom/android/internal/telephony/dataconnection/DataThrottler;)V
    .locals 1

    .line 195
    new-instance v0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/data/AccessNetworksManager;Lcom/android/internal/telephony/dataconnection/DataThrottler;)V

    invoke-virtual {p0, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public registerForQualifiedNetworksChanged(Landroid/os/Handler;I)V
    .locals 2

    if-eqz p1, :cond_0

    .line 596
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    const/4 v1, 0x0

    invoke-direct {v0, p1, p2, v1}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 597
    iget-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mQualifiedNetworksChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 601
    iget-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAvailableNetworks:Landroid/util/SparseArray;

    invoke-virtual {p1}, Landroid/util/SparseArray;->size()I

    move-result p1

    if-eqz p1, :cond_0

    .line 602
    invoke-direct {p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getQualifiedNetworksList()Ljava/util/List;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/Registrant;->notifyResult(Ljava/lang/Object;)V

    :cond_0
    return-void
.end method

.method public setCurrentTransport(II)V
    .locals 3

    .line 682
    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mCurrentTransports:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    if-eqz v0, :cond_0

    .line 683
    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    if-eq v0, p2, :cond_1

    .line 684
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setCurrentTransport: apnType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", transport="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 685
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 684
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->logl(Ljava/lang/String;)V

    :cond_1
    return-void
.end method

.method public setCurrentTransportByNetworkCapability(II)V
    .locals 0

    .line 671
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToApnType(I)I

    move-result p1

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->setCurrentTransport(II)V

    return-void
.end method

.method public unregisterCallback(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;)V
    .locals 0

    .line 793
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mAccessNetworksManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public unregisterForQualifiedNetworksChanged(Landroid/os/Handler;)V
    .locals 0

    if-eqz p1, :cond_0

    .line 773
    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager;->mQualifiedNetworksChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    :cond_0
    return-void
.end method
