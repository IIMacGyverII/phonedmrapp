.class public Lcom/android/internal/telephony/ims/ImsResolver;
.super Ljava/lang/Object;
.source "ImsResolver.java"

# interfaces
.implements Lcom/android/internal/telephony/ims/ImsServiceController$ImsServiceControllerCallbacks;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;,
        Lcom/android/internal/telephony/ims/ImsResolver$ImsDynamicQueryManagerFactory;,
        Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;,
        Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;,
        Lcom/android/internal/telephony/ims/ImsResolver$SubscriptionManagerProxy;,
        Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;,
        Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;
    }
.end annotation


# static fields
.field private static final DELAY_DYNAMIC_QUERY_MS:I = 0x1388

.field private static final GET_IMS_SERVICE_TIMEOUT_MS:I = 0x1388

.field private static final HANDLER_ADD_PACKAGE:I = 0x0

.field private static final HANDLER_BOOT_COMPLETE:I = 0x6

.field private static final HANDLER_CLEAR_CARRIER_IMS_SERVICE_CONFIG:I = 0x8

.field private static final HANDLER_CONFIG_CHANGED:I = 0x2

.field private static final HANDLER_DYNAMIC_FEATURE_CHANGE:I = 0x4

.field private static final HANDLER_INIT_IMS_SERVICE:I = 0x3e8

.field private static final HANDLER_MSIM_CONFIGURATION_CHANGE:I = 0x7

.field private static final HANDLER_OVERRIDE_IMS_SERVICE_CONFIG:I = 0x5

.field private static final HANDLER_REMOVE_PACKAGE:I = 0x1

.field private static final HANDLER_START_DYNAMIC_FEATURE_QUERY:I = 0x3

.field public static final METADATA_EMERGENCY_MMTEL_FEATURE:Ljava/lang/String; = "android.telephony.ims.EMERGENCY_MMTEL_FEATURE"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final METADATA_MMTEL_FEATURE:Ljava/lang/String; = "android.telephony.ims.MMTEL_FEATURE"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final METADATA_OVERRIDE_PERM_CHECK:Ljava/lang/String; = "override_bind_check"

.field public static final METADATA_RCS_FEATURE:Ljava/lang/String; = "android.telephony.ims.RCS_FEATURE"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final MTK_IMS_PACKAGE_NAME:Ljava/lang/String; = "com.mediatek.ims"

.field private static final TAG:Ljava/lang/String; = "ImsResolver"

.field private static sInstance:Lcom/android/internal/telephony/ims/ImsResolver;


# instance fields
.field private final mActiveControllers:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/content/ComponentName;",
            "Lcom/android/internal/telephony/ims/ImsServiceController;",
            ">;"
        }
    .end annotation
.end field

.field private final mAppChangedReceiver:Landroid/content/BroadcastReceiver;

.field private final mBootCompleted:Landroid/content/BroadcastReceiver;

.field private mBootCompletedHandlerRan:Z

.field private final mBoundImsServicesByFeature:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/ims/ImsServiceController;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mBoundServicesLock:Ljava/lang/Object;

.field private final mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

.field private mCarrierConfigReceived:Z

.field private final mCarrierServices:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mConfigChangedReceiver:Landroid/content/BroadcastReceiver;

.field private final mContext:Landroid/content/Context;

.field private final mDeviceServices:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private final mDynamicQueryListener:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;

.field private mDynamicQueryManagerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsDynamicQueryManagerFactory;

.field private final mEventLog:Lcom/android/internal/telephony/LocalLog;

.field private mFeatureQueryManager:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;

.field private final mHandler:Landroid/os/Handler;

.field private mImsServiceControllerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

.field private final mImsServiceControllerFactoryCompat:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

.field private final mInstalledServicesCache:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/content/ComponentName;",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ">;"
        }
    .end annotation
.end field

.field private mNumSlots:I

.field private final mOverrideServices:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/util/SparseArray<",
            "Ljava/lang/String;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mReceiverContext:Landroid/content/Context;

.field private final mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

.field private final mRunnableExecutor:Landroid/os/HandlerExecutor;

.field private final mSimStateChangedReceiver:Landroid/content/BroadcastReceiver;

.field private final mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

.field private mSubscriptionManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$SubscriptionManagerProxy;

.field private mTelephonyManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;


# direct methods
.method public static synthetic $r8$lambda$-bIdYEI6iD9A9jJ2sUHhfpqD6VQ(IILandroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$doesCachedImsServiceExist$2(IILandroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$1e3juk-SffAFyAwIKlOGye-9yhQ(Lcom/android/internal/telephony/ims/ImsResolver;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$calculateFeaturesToCreate$9(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$91LWwhgjNyPzAHNy-Ga83Q5DmCQ(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$getSlotsForActiveCarrierService$5(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$A9E7XdyOKBURei3Zt9AswpP_qOc(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$sanitizeFeatureConfig$13(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$AbGeNCA0-YXosd7CQtBluKCTXSg(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$calculateFeaturesToCreate$10(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$FR-n5Vi3v6zmXPCRonjGVs8Tm-I(Lcom/android/internal/telephony/ims/ImsResolver;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$calculateFeaturesToCreate$8(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$H3PGtjKf2ohdXGJ69PzGUkNXKe4(Lcom/android/internal/telephony/ims/ImsResolver;ILcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$disableIms$1(ILcom/android/internal/telephony/ims/ImsServiceController;)V

    return-void
.end method

.method public static synthetic $r8$lambda$OYlxhTSV39054kcS8i5v7WwU1cs(Ljava/lang/Integer;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$handleMsimConfigChange$12(Ljava/lang/Integer;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$U-823hr5l8gj3_s-32-jIxF2HTE(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Lcom/android/internal/telephony/ims/ImsServiceController;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$getControllerByServiceInfo$6(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Lcom/android/internal/telephony/ims/ImsServiceController;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$YUaSCBwEWx3N5GJkdupwxvfzxcU(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/LinkedBlockingQueue;ZII)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$getImsServiceConfiguration$3(Ljava/util/concurrent/LinkedBlockingQueue;ZII)V

    return-void
.end method

.method public static synthetic $r8$lambda$do6SAZhPyGivY_8ylc-oLAm3Klc(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$sanitizeFeatureConfig$14(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$iQNXuJBMYknawWNUQ_gcDgLKyW0(Ljava/lang/String;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$getInfoByPackageName$7(Ljava/lang/String;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$jCW5IFMZ6FpRlR-N7xZUzKzMY0M(Lcom/android/internal/telephony/ims/ImsResolver;ILcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$enableIms$0(ILcom/android/internal/telephony/ims/ImsServiceController;)V

    return-void
.end method

.method public static synthetic $r8$lambda$mBKmfYBNzaBNqwtmdtmrHlaApLs(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$shouldFeaturesCauseBind$11(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$xLd43Oh4UfXMY5LqEzxz20Rr348(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/CompletableFuture;II)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/ims/ImsResolver;->lambda$getConfiguredImsServicePackageName$4(Ljava/util/concurrent/CompletableFuture;II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmBootCompletedHandlerRan(Lcom/android/internal/telephony/ims/ImsResolver;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBootCompletedHandlerRan:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmCarrierConfigReceived(Lcom/android/internal/telephony/ims/ImsResolver;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierConfigReceived:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmContext(Lcom/android/internal/telephony/ims/ImsResolver;)Landroid/content/Context;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEventLog(Lcom/android/internal/telephony/ims/ImsResolver;)Lcom/android/internal/telephony/LocalLog;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandler(Lcom/android/internal/telephony/ims/ImsResolver;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmNumSlots(Lcom/android/internal/telephony/ims/ImsResolver;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmTelephonyManagerProxy(Lcom/android/internal/telephony/ims/ImsResolver;)Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mTelephonyManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmBootCompletedHandlerRan(Lcom/android/internal/telephony/ims/ImsResolver;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBootCompletedHandlerRan:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmCarrierConfigReceived(Lcom/android/internal/telephony/ims/ImsResolver;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierConfigReceived:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mcarrierConfigChanged(Lcom/android/internal/telephony/ims/ImsResolver;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->carrierConfigChanged(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mclearCarrierServiceOverrides(Lcom/android/internal/telephony/ims/ImsResolver;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->clearCarrierServiceOverrides(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mdynamicQueryComplete(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/content/ComponentName;Ljava/util/Set;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->dynamicQueryComplete(Landroid/content/ComponentName;Ljava/util/Set;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mgetSubId(Lcom/android/internal/telephony/ims/ImsResolver;I)I
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getSubId(I)I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetSubIdUsingPhoneId(Lcom/android/internal/telephony/ims/ImsResolver;I)I
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getSubIdUsingPhoneId(I)I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mhandleFeaturesChanged(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/content/ComponentName;Ljava/util/Set;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->handleFeaturesChanged(Landroid/content/ComponentName;Ljava/util/Set;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleMsimConfigChange(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/Integer;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->handleMsimConfigChange(Ljava/lang/Integer;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mmaybeAddedImsService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->maybeAddedImsService(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mmaybeRemovedImsService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/String;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->maybeRemovedImsService(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$moverrideCarrierService(Lcom/android/internal/telephony/ims/ImsResolver;ILjava/util/Map;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->overrideCarrierService(ILjava/util/Map;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$moverrideDeviceService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/Map;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->overrideDeviceService(Ljava/util/Map;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mscheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/content/ComponentName;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Landroid/content/ComponentName;I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$msetSubId(Lcom/android/internal/telephony/ims/ImsResolver;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->setSubId(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstartDynamicQuery(Lcom/android/internal/telephony/ims/ImsResolver;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->startDynamicQuery(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateInstalledServicesCache(Lcom/android/internal/telephony/ims/ImsResolver;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->updateInstalledServicesCache()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smprintFeatures(Ljava/util/Set;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->printFeatures(Ljava/util/Set;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;ILcom/android/ims/ImsFeatureBinderRepository;Landroid/os/Looper;)V
    .locals 3

    .line 609
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 248
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$1;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mAppChangedReceiver:Landroid/content/BroadcastReceiver;

    .line 272
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$2;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$2;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mConfigChangedReceiver:Landroid/content/BroadcastReceiver;

    .line 307
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$3;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$3;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBootCompleted:Landroid/content/BroadcastReceiver;

    .line 343
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$4;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$4;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mTelephonyManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;

    .line 354
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$5;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$5;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSubscriptionManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$SubscriptionManagerProxy;

    .line 388
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$6;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$6;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mImsServiceControllerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    .line 413
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$7;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$7;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mImsServiceControllerFactoryCompat:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    .line 428
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda6;

    invoke-direct {v0}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda6;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDynamicQueryManagerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsDynamicQueryManagerFactory;

    .line 441
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundServicesLock:Ljava/lang/Object;

    .line 448
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    .line 450
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x20

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    const/4 v0, 0x0

    .line 452
    iput-boolean v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBootCompletedHandlerRan:Z

    .line 453
    iput-boolean v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierConfigReceived:Z

    .line 565
    new-instance v1, Lcom/android/internal/telephony/ims/ImsResolver$8;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/ims/ImsResolver$8;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDynamicQueryListener:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;

    .line 600
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    .line 603
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mActiveControllers:Ljava/util/Map;

    .line 1853
    new-instance v1, Lcom/android/internal/telephony/ims/ImsResolver$9;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/ims/ImsResolver$9;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    iput-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSimStateChangedReceiver:Landroid/content/BroadcastReceiver;

    .line 610
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "device MMTEL package: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", device RCS package:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "ImsResolver"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 612
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mContext:Landroid/content/Context;

    .line 613
    iput p4, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    .line 614
    iput-object p5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

    .line 615
    sget-object p4, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    invoke-virtual {p1, p4, v0}, Landroid/content/Context;->createContextAsUser(Landroid/os/UserHandle;I)Landroid/content/Context;

    move-result-object p4

    iput-object p4, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mReceiverContext:Landroid/content/Context;

    .line 617
    new-instance p4, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;

    invoke-direct {p4, p0, p6}, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/os/Looper;)V

    iput-object p4, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    .line 618
    new-instance p5, Landroid/os/HandlerExecutor;

    invoke-direct {p5, p4}, Landroid/os/HandlerExecutor;-><init>(Landroid/os/Handler;)V

    iput-object p5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRunnableExecutor:Landroid/os/HandlerExecutor;

    .line 619
    new-instance p4, Landroid/util/SparseArray;

    iget p5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    invoke-direct {p4, p5}, Landroid/util/SparseArray;-><init>(I)V

    iput-object p4, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierServices:Landroid/util/SparseArray;

    .line 620
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->setDeviceConfiguration(Ljava/lang/String;I)V

    const/4 p4, 0x1

    .line 621
    invoke-direct {p0, p2, p4}, Lcom/android/internal/telephony/ims/ImsResolver;->setDeviceConfiguration(Ljava/lang/String;I)V

    const/4 p2, 0x2

    .line 622
    invoke-direct {p0, p3, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->setDeviceConfiguration(Ljava/lang/String;I)V

    const-string p2, "carrier_config"

    .line 623
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/CarrierConfigManager;

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    .line 625
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1, v0}, Landroid/util/SparseArray;-><init>(I)V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mOverrideServices:Landroid/util/SparseArray;

    .line 626
    new-instance p1, Landroid/util/SparseArray;

    iget p2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    invoke-direct {p1, p2}, Landroid/util/SparseArray;-><init>(I)V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundImsServicesByFeature:Landroid/util/SparseArray;

    .line 627
    new-instance p1, Landroid/util/SparseIntArray;

    iget p2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    invoke-direct {p1, p2}, Landroid/util/SparseIntArray;-><init>(I)V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    .line 628
    :goto_0
    iget p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-ge v0, p1, :cond_0

    .line 629
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    const/4 p2, -0x1

    invoke-virtual {p1, v0, p2}, Landroid/util/SparseIntArray;->put(II)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private bindCarrierServicesIfAvailable()V
    .locals 11

    const/4 v0, 0x0

    move v1, v0

    move v2, v1

    .line 733
    :goto_0
    iget v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-ge v1, v3, :cond_3

    .line 734
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSubscriptionManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$SubscriptionManagerProxy;

    invoke-interface {v3, v1}, Lcom/android/internal/telephony/ims/ImsResolver$SubscriptionManagerProxy;->getSubId(I)I

    move-result v3

    .line 735
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsPackageOverrideConfig(I)Ljava/util/Map;

    move-result-object v4

    move v5, v0

    :goto_1
    const/4 v6, 0x3

    if-ge v5, v6, :cond_2

    .line 737
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    const-string v7, ""

    invoke-interface {v4, v6, v7}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 738
    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v7

    const/4 v8, 0x1

    if-nez v7, :cond_1

    .line 739
    iget-object v7, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "bindCarrierServicesIfAvailable - carrier package found: "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, " on slot "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v7, v9}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 742
    iput-boolean v8, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierConfigReceived:Z

    .line 743
    invoke-direct {p0, v1, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->setSubId(II)V

    .line 744
    invoke-direct {p0, v6, v1, v5}, Lcom/android/internal/telephony/ims/ImsResolver;->setCarrierConfiguredPackageName(Ljava/lang/String;II)V

    .line 745
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object v6

    if-eqz v6, :cond_0

    .line 748
    iget-boolean v7, v6, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    if-eqz v7, :cond_0

    move v2, v8

    goto :goto_2

    .line 752
    :cond_0
    invoke-direct {p0, v6}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    :cond_1
    :goto_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    :cond_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_3
    if-eqz v2, :cond_4

    .line 757
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeatureConfigurationChange()V

    :cond_4
    return-void
.end method

.method private bindImsServiceWithFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Ljava/util/Set;)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;",
            ">;)V"
        }
    .end annotation

    .line 1243
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->shouldFeaturesCauseBind(Ljava/util/Set;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1245
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mActiveControllers:Ljava/util/Map;

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getControllerByServiceInfo(Ljava/util/Map;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Lcom/android/internal/telephony/ims/ImsServiceController;

    move-result-object v0

    .line 1246
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    invoke-virtual {v1}, Landroid/util/SparseIntArray;->clone()Landroid/util/SparseIntArray;

    move-result-object v1

    const-string v2, "ImsResolver"

    if-eqz v0, :cond_0

    .line 1248
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ImsService connection exists for "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", updating features "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1251
    :try_start_0
    invoke-virtual {v0, p2, v1}, Lcom/android/internal/telephony/ims/ImsServiceController;->changeImsServiceFeatures(Ljava/util/Set;Landroid/util/SparseIntArray;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p2

    .line 1255
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "bindImsService: error="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v2, p2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 1258
    :cond_0
    iget-object v0, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->controllerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mContext:Landroid/content/Context;

    iget-object v4, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    iget-object v5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

    invoke-interface {v0, v3, v4, p0, v5}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;->create(Landroid/content/Context;Landroid/content/ComponentName;Lcom/android/internal/telephony/ims/ImsServiceController$ImsServiceControllerCallbacks;Lcom/android/ims/ImsFeatureBinderRepository;)Lcom/android/internal/telephony/ims/ImsServiceController;

    move-result-object v0

    .line 1259
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Binding ImsService: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lcom/android/internal/telephony/ims/ImsServiceController;->getComponentName()Landroid/content/ComponentName;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " with features: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1261
    invoke-virtual {v0, p2, v1}, Lcom/android/internal/telephony/ims/ImsServiceController;->bind(Ljava/util/Set;Landroid/util/SparseIntArray;)Z

    .line 1262
    iget-object p2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "bindImsServiceWithFeatures - create new controller: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1265
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mActiveControllers:Ljava/util/Map;

    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-interface {p0, p1, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    return-void
.end method

.method private calculateFeatureConfigurationChange()V
    .locals 4

    .line 1720
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    .line 1721
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeaturesToCreate(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Ljava/util/HashSet;

    move-result-object v2

    .line 1722
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->shouldFeaturesCauseBind(Ljava/util/Set;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 1723
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->bindImsServiceWithFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Ljava/util/Set;)V

    goto :goto_0

    .line 1725
    :cond_0
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->unbindImsService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    goto :goto_0

    :cond_1
    return-void
.end method

.method private calculateFeaturesToCreate(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Ljava/util/HashSet;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ")",
            "Ljava/util/HashSet<",
            "Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;",
            ">;"
        }
    .end annotation

    .line 1294
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 1295
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getSlotsForActiveCarrierService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Ljava/util/List;

    move-result-object v1

    .line 1296
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    .line 1299
    invoke-virtual {p1}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    .line 1300
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1302
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Collection;

    .line 1299
    invoke-virtual {v0, p0}, Ljava/util/HashSet;->addAll(Ljava/util/Collection;)Z

    return-object v0

    .line 1305
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->isDeviceService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 1306
    invoke-virtual {p1}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    .line 1309
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v1, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    .line 1313
    invoke-interface {p1, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1315
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Collection;

    .line 1306
    invoke-virtual {v0, p0}, Ljava/util/HashSet;->addAll(Ljava/util/Collection;)Z

    :cond_1
    return-object v0
.end method

.method private carrierConfigChanged(II)V
    .locals 2

    .line 1431
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->setSubId(II)V

    .line 1432
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->updateBoundDeviceServices()V

    const/4 v0, -0x1

    if-gt p1, v0, :cond_0

    const/4 v0, 0x0

    .line 1435
    :goto_0
    iget v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-ge v0, v1, :cond_0

    .line 1436
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->getSubId(I)I

    move-result v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsPackageOverrideConfig(I)Ljava/util/Map;

    move-result-object v1

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->updateBoundServices(ILjava/util/Map;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1439
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsPackageOverrideConfig(I)Ljava/util/Map;

    move-result-object p2

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->updateBoundServices(ILjava/util/Map;)V

    return-void
.end method

.method private clearCarrierServiceOverrides(I)V
    .locals 2

    const-string v0, "ImsResolver"

    const-string v1, "clearing carrier ImsService overrides"

    .line 1396
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1397
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1398
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->removeOverridePackageName(I)V

    .line 1399
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getSubId(I)I

    move-result v0

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->carrierConfigChanged(II)V

    return-void
.end method

.method private doesCachedImsServiceExist(Ljava/lang/String;II)Z
    .locals 0

    .line 951
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 952
    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance p1, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda15;

    invoke-direct {p1, p2, p3}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda15;-><init>(II)V

    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private doesCarrierConfigurationExist(II)Z
    .locals 2

    .line 935
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageName(II)Ljava/lang/String;

    move-result-object v0

    .line 936
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 940
    :cond_0
    invoke-direct {p0, v0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->doesCachedImsServiceExist(Ljava/lang/String;II)Z

    move-result p0

    return p0
.end method

.method private dynamicQueryComplete(Landroid/content/ComponentName;Ljava/util/Set;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/ComponentName;",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;",
            ">;)V"
        }
    .end annotation

    .line 1673
    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1675
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "dynamicQueryComplete: Couldn\'t find cached info for name: "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ImsResolver"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1679
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->sanitizeFeatureConfig(Ljava/util/Set;)V

    .line 1680
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "dynamicQueryComplete: for package "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", features: "

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1681
    invoke-virtual {v0}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/ims/ImsResolver;->printFeatures(Ljava/util/Set;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " -> "

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Lcom/android/internal/telephony/ims/ImsResolver;->printFeatures(Ljava/util/Set;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1680
    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1683
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->replaceFeatures(Ljava/util/Set;)V

    .line 1685
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mFeatureQueryManager:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->isQueryInProgress()Z

    move-result p1

    if-nez p1, :cond_2

    .line 1686
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/4 p2, 0x4

    invoke-virtual {p1, p2}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 1687
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    const-string p2, "[warning] dynamicQueryComplete - HANDLER_DYNAMIC_FEATURE_CHANGE pending with calculateFeatureConfigurationChange()"

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1690
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeatureConfigurationChange()V

    :cond_2
    return-void
.end method

.method private getCarrierConfiguredPackageName(II)Ljava/lang/String;
    .locals 0

    .line 885
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageNames(I)Ljava/util/Map;

    move-result-object p0

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string p2, ""

    invoke-interface {p0, p1, p2}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method private getCarrierConfiguredPackageNames(I)Ljava/util/Map;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 890
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierServices:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map;

    if-nez v0, :cond_0

    .line 892
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    .line 893
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierServices:Landroid/util/SparseArray;

    invoke-virtual {p0, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :cond_0
    return-object v0
.end method

.method private getConfiguredImsServicePackageNameInternal(II)Ljava/lang/String;
    .locals 2

    .line 1073
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageName(II)Ljava/lang/String;

    move-result-object v0

    .line 1074
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 1075
    invoke-direct {p0, v0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->doesCachedImsServiceExist(Ljava/lang/String;II)Z

    move-result v1

    if-eqz v1, :cond_0

    return-object v0

    .line 1081
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object v0

    .line 1082
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 1083
    invoke-direct {p0, v0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->doesCachedImsServiceExist(Ljava/lang/String;II)Z

    move-result p0

    if-eqz p0, :cond_1

    return-object v0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private getControllerByServiceInfo(Ljava/util/Map;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Lcom/android/internal/telephony/ims/ImsServiceController;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Landroid/content/ComponentName;",
            "Lcom/android/internal/telephony/ims/ImsServiceController;",
            ">;",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ")",
            "Lcom/android/internal/telephony/ims/ImsServiceController;"
        }
    .end annotation

    .line 1223
    invoke-interface {p1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance p1, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda8;

    invoke-direct {p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda8;-><init>(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    .line 1224
    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1225
    invoke-interface {p0}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/ims/ImsServiceController;

    return-object p0
.end method

.method private getDeviceConfiguration(I)Ljava/lang/String;
    .locals 2

    .line 865
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    monitor-enter v0

    .line 866
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string v1, ""

    invoke-interface {p0, p1, v1}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 867
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private getImsPackageOverrideConfig(I)Ljava/util/Map;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 1506
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    invoke-virtual {v0, p1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p1

    if-nez p1, :cond_0

    .line 1507
    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 v0, 0x0

    const-string v1, "config_ims_package_override_string"

    .line 1508
    invoke-virtual {p1, v1, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "config_ims_mmtel_package_override_string"

    .line 1512
    invoke-virtual {p1, v1, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "config_ims_rcs_package_override_string"

    .line 1515
    invoke-virtual {p1, v2, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 1517
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    const/4 v2, 0x0

    .line 1520
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object p0

    const-string v3, "com.mediatek.ims"

    invoke-virtual {v3, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    const/4 v4, 0x1

    if-eqz p0, :cond_3

    .line 1522
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    const-string v5, "ImsResolver"

    if-nez p0, :cond_1

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    const-string p0, "getImsPackageOverrideConfig, bind to diff ims for mmTel"

    .line 1523
    invoke-static {v5, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    move p0, v2

    goto :goto_0

    :cond_1
    move p0, v4

    .line 1526
    :goto_0
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_2

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_2

    const-string p0, "getImsPackageOverrideConfig, bind to diff ims for rcs"

    .line 1527
    invoke-static {v5, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    move p0, v2

    :cond_2
    if-eqz p0, :cond_3

    .line 1531
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getImsPackageOverrideConfig, ignore config:"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v5, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0

    .line 1537
    :cond_3
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    if-nez p0, :cond_4

    .line 1538
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1539
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1541
    :cond_4
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    if-nez p0, :cond_5

    const/4 p0, 0x2

    .line 1542
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_5
    return-object v0
.end method

.method private getImsServiceControllers(I)Ljava/util/Set;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/ims/ImsServiceController;",
            ">;"
        }
    .end annotation

    if-ltz p1, :cond_4

    .line 798
    iget v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-lt p1, v0, :cond_0

    goto :goto_1

    .line 802
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundServicesLock:Ljava/lang/Object;

    monitor-enter v0

    .line 803
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundImsServicesByFeature:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/util/SparseArray;

    .line 804
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez p0, :cond_1

    const-string p0, "ImsResolver"

    const-string p1, "getImsServiceControllers: couldn\'t find any active ImsServiceControllers"

    .line 806
    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 808
    invoke-static {}, Ljava/util/Collections;->emptySet()Ljava/util/Set;

    move-result-object p0

    return-object p0

    .line 812
    :cond_1
    new-instance p1, Landroid/util/ArraySet;

    const/4 v0, 0x2

    invoke-direct {p1, v0}, Landroid/util/ArraySet;-><init>(I)V

    const/4 v0, 0x0

    .line 813
    :goto_0
    invoke-virtual {p0}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-ge v0, v1, :cond_3

    .line 814
    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v1

    .line 815
    invoke-virtual {p0, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/ims/ImsServiceController;

    if-eqz v1, :cond_2

    .line 816
    invoke-interface {p1, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    :cond_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_3
    return-object p1

    :catchall_0
    move-exception p0

    .line 804
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0

    .line 799
    :cond_4
    :goto_1
    invoke-static {}, Ljava/util/Collections;->emptySet()Ljava/util/Set;

    move-result-object p0

    return-object p0
.end method

.method private getImsServiceInfo(Ljava/lang/String;)Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ">;"
        }
    .end annotation

    .line 1766
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1768
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mImsServiceControllerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->searchForImsServices(Ljava/lang/String;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1770
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mImsServiceControllerFactoryCompat:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->searchForImsServices(Ljava/lang/String;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;)Ljava/util/List;

    move-result-object p0

    invoke-interface {v0, p0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    return-object v0
.end method

.method private getInfoByComponentName(Ljava/util/Map;Landroid/content/ComponentName;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Landroid/content/ComponentName;",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ">;",
            "Landroid/content/ComponentName;",
            ")",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;"
        }
    .end annotation

    .line 1237
    invoke-interface {p1, p2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    return-object p0
.end method

.method private getInfoByPackageName(Ljava/util/Map;Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Landroid/content/ComponentName;",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;"
        }
    .end annotation

    .line 1230
    invoke-interface {p1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance p1, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda7;

    invoke-direct {p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda7;-><init>(Ljava/lang/String;)V

    .line 1231
    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1232
    invoke-interface {p0}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    return-object p0
.end method

.method public static getInstance()Lcom/android/internal/telephony/ims/ImsResolver;
    .locals 1

    .line 161
    sget-object v0, Lcom/android/internal/telephony/ims/ImsResolver;->sInstance:Lcom/android/internal/telephony/ims/ImsResolver;

    return-object v0
.end method

.method private getOverridePackageName(I)Landroid/util/SparseArray;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Landroid/util/SparseArray<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 919
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mOverrideServices:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/util/SparseArray;

    if-nez v0, :cond_0

    .line 921
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    .line 922
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mOverrideServices:Landroid/util/SparseArray;

    invoke-virtual {p0, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :cond_0
    return-object v0
.end method

.method private getOverridePackageName(II)Ljava/lang/String;
    .locals 0

    .line 914
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getOverridePackageName(I)Landroid/util/SparseArray;

    move-result-object p0

    invoke-virtual {p0, p2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method private getSlotsForActiveCarrierService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    if-nez p1, :cond_0

    .line 1210
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p0

    return-object p0

    .line 1211
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    iget v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    const/4 v1, 0x0

    .line 1212
    :goto_0
    iget v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-ge v1, v2, :cond_2

    .line 1213
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageNames(I)Ljava/util/Map;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda5;

    invoke-direct {v3, p1}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    .line 1214
    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/stream/Stream;->findAny()Ljava/util/Optional;

    move-result-object v2

    const-string v3, ""

    invoke-virtual {v2, v3}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/CharSequence;

    .line 1213
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_1

    .line 1215
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    return-object v0
.end method

.method private getSubId(I)I
    .locals 2

    .line 1889
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    monitor-enter v0

    .line 1890
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    const/4 v1, -0x1

    invoke-virtual {p0, p1, v1}, Landroid/util/SparseIntArray;->get(II)I

    move-result p0

    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 1891
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private getSubIdUsingPhoneId(I)I
    .locals 1

    .line 1845
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->getSubId(I)[I

    move-result-object p0

    if-eqz p0, :cond_0

    .line 1847
    array-length p1, p0

    const/4 v0, 0x1

    if-lt p1, v0, :cond_0

    const/4 p1, 0x0

    .line 1848
    aget p0, p0, p1

    goto :goto_0

    :cond_0
    const/4 p0, -0x1

    :goto_0
    return p0
.end method

.method private handleFeaturesChanged(Landroid/content/ComponentName;Ljava/util/Set;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/ComponentName;",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;",
            ">;)V"
        }
    .end annotation

    .line 1583
    invoke-static {}, Lcom/android/internal/telephony/SomeArgs;->obtain()Lcom/android/internal/telephony/SomeArgs;

    move-result-object v0

    .line 1584
    iput-object p1, v0, Lcom/android/internal/telephony/SomeArgs;->arg1:Ljava/lang/Object;

    .line 1585
    iput-object p2, v0, Lcom/android/internal/telephony/SomeArgs;->arg2:Ljava/lang/Object;

    .line 1586
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/4 p1, 0x4

    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method private handleMsimConfigChange(Ljava/lang/Integer;)V
    .locals 8

    .line 1590
    iget v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    .line 1591
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-ne v0, v1, :cond_0

    return-void

    .line 1594
    :cond_0
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    .line 1595
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "handleMsimConfigChange: oldLen="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", newLen="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "ImsResolver"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1596
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "MSIM config change: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " -> "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1597
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    const/4 v3, 0x0

    if-ge v1, v0, :cond_3

    .line 1601
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    :goto_0
    if-ge v1, v0, :cond_3

    .line 1603
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageNames(I)Ljava/util/Map;

    move-result-object v4

    .line 1604
    invoke-interface {v4}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_1
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    const-string v6, ""

    if-eqz v5, :cond_1

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/Integer;

    .line 1605
    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v5

    invoke-direct {p0, v6, v1, v5}, Lcom/android/internal/telephony/ims/ImsResolver;->setCarrierConfiguredPackageName(Ljava/lang/String;II)V

    goto :goto_1

    .line 1608
    :cond_1
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->getOverridePackageName(I)Landroid/util/SparseArray;

    move-result-object v4

    move v5, v3

    .line 1609
    :goto_2
    invoke-virtual {v4}, Landroid/util/SparseArray;->size()I

    move-result v7

    if-ge v5, v7, :cond_2

    .line 1610
    invoke-virtual {v4, v5}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v7

    .line 1611
    invoke-direct {p0, v6, v1, v7}, Lcom/android/internal/telephony/ims/ImsResolver;->setOverridePackageName(Ljava/lang/String;II)V

    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    .line 1614
    :cond_2
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->removeSlotId(I)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_3
    const/4 v1, 0x0

    .line 1620
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfo(Ljava/lang/String;)Ljava/util/List;

    move-result-object v1

    .line 1621
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_3
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_6

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    .line 1622
    iget-object v5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    iget-object v6, v4, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-interface {v5, v6}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    if-eqz v5, :cond_5

    .line 1624
    iget-boolean v6, v4, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    if-eqz v6, :cond_4

    .line 1625
    invoke-virtual {v4}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v4

    invoke-virtual {v5, v4}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->replaceFeatures(Ljava/util/Set;)V

    goto :goto_3

    .line 1628
    :cond_4
    invoke-virtual {v5}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda3;

    invoke-direct {v5, p1}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda3;-><init>(Ljava/lang/Integer;)V

    .line 1629
    invoke-interface {v4, v5}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    goto :goto_3

    .line 1633
    :cond_5
    iget-object v5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "handleMsimConfigChange: detected untracked service - "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1634
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "handleMsimConfigChange: detected untracked package, queueing to add "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, v5}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1636
    iget-object v5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    iget-object v4, v4, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    .line 1637
    invoke-virtual {v4}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v4

    .line 1636
    invoke-virtual {v5, v3, v4}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v4

    .line 1637
    invoke-virtual {v4}, Landroid/os/Message;->sendToTarget()V

    goto :goto_3

    .line 1641
    :cond_6
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    if-ge p1, v0, :cond_7

    .line 1644
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeatureConfigurationChange()V

    :cond_7
    return-void
.end method

.method private isDeviceService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Z
    .locals 1

    if-nez p1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1204
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    monitor-enter v0

    .line 1205
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->containsValue(Ljava/lang/Object;)Z

    move-result p0

    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 1206
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private synthetic lambda$calculateFeaturesToCreate$10(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 1

    .line 1313
    iget v0, p1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->slotId:I

    iget p1, p1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->featureType:I

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->doesCarrierConfigurationExist(II)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private synthetic lambda$calculateFeaturesToCreate$8(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 1

    .line 1300
    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    iget v0, p2, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->slotId:I

    iget p2, p2, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->featureType:I

    .line 1301
    invoke-direct {p0, v0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageName(II)Ljava/lang/String;

    move-result-object p0

    .line 1300
    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private synthetic lambda$calculateFeaturesToCreate$9(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    .line 1309
    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    iget p2, p2, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->featureType:I

    .line 1310
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object p0

    .line 1309
    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private synthetic lambda$disableIms$1(ILcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 0

    .line 775
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getSubId(I)I

    move-result p0

    invoke-virtual {p2, p1, p0}, Lcom/android/internal/telephony/ims/ImsServiceController;->disableIms(II)V

    return-void
.end method

.method private static synthetic lambda$doesCachedImsServiceExist$2(IILandroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 1

    .line 953
    iget v0, p2, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->slotId:I

    if-ne v0, p0, :cond_0

    iget p0, p2, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->featureType:I

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$enableIms$0(ILcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 0

    .line 766
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getSubId(I)I

    move-result p0

    invoke-virtual {p2, p1, p0}, Lcom/android/internal/telephony/ims/ImsServiceController;->enableIms(II)V

    return-void
.end method

.method private synthetic lambda$getConfiguredImsServicePackageName$4(Ljava/util/concurrent/CompletableFuture;II)V
    .locals 0

    .line 1030
    :try_start_0
    invoke-direct {p0, p2, p3}, Lcom/android/internal/telephony/ims/ImsResolver;->getConfiguredImsServicePackageNameInternal(II)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/util/concurrent/CompletableFuture;->complete(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 1035
    invoke-virtual {p1, p0}, Ljava/util/concurrent/CompletableFuture;->completeExceptionally(Ljava/lang/Throwable;)Z

    :goto_0
    return-void
.end method

.method private static synthetic lambda$getControllerByServiceInfo$6(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Lcom/android/internal/telephony/ims/ImsServiceController;)Z
    .locals 0

    .line 1224
    invoke-virtual {p1}, Lcom/android/internal/telephony/ims/ImsServiceController;->getComponentName()Landroid/content/ComponentName;

    move-result-object p1

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-static {p1, p0}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private synthetic lambda$getImsServiceConfiguration$3(Ljava/util/concurrent/LinkedBlockingQueue;ZII)V
    .locals 0

    if-eqz p2, :cond_0

    .line 970
    invoke-direct {p0, p3, p4}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageName(II)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    .line 971
    :cond_0
    invoke-direct {p0, p4}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object p0

    .line 969
    :goto_0
    invoke-virtual {p1, p0}, Ljava/util/concurrent/LinkedBlockingQueue;->offer(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$getInfoByPackageName$7(Ljava/lang/String;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Z
    .locals 0

    .line 1231
    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1, p0}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$getSlotsForActiveCarrierService$5(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;Ljava/lang/String;)Z
    .locals 0

    .line 1214
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {p0}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$handleMsimConfigChange$12(Ljava/lang/Integer;Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    .line 1629
    iget p1, p1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->slotId:I

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    if-lt p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$sanitizeFeatureConfig$13(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    .line 1704
    iget p1, p1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->slotId:I

    iget p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-lt p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$sanitizeFeatureConfig$14(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    .line 1707
    iget p0, p0, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->featureType:I

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$shouldFeaturesCauseBind$11(Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z
    .locals 0

    .line 1376
    iget p0, p0, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->featureType:I

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public static make(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;ILcom/android/ims/ImsFeatureBinderRepository;)V
    .locals 8

    .line 149
    sget-object v0, Lcom/android/internal/telephony/ims/ImsResolver;->sInstance:Lcom/android/internal/telephony/ims/ImsResolver;

    if-nez v0, :cond_0

    .line 150
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v7

    .line 151
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver;

    move-object v1, v0

    move-object v2, p0

    move-object v3, p1

    move-object v4, p2

    move v5, p3

    move-object v6, p4

    invoke-direct/range {v1 .. v7}, Lcom/android/internal/telephony/ims/ImsResolver;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;ILcom/android/ims/ImsFeatureBinderRepository;Landroid/os/Looper;)V

    sput-object v0, Lcom/android/internal/telephony/ims/ImsResolver;->sInstance:Lcom/android/internal/telephony/ims/ImsResolver;

    :cond_0
    return-void
.end method

.method private maybeAddedImsService(Ljava/lang/String;)V
    .locals 7

    .line 1142
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "maybeAddedImsService, packageName: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ImsResolver"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1143
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfo(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    .line 1147
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 v0, 0x0

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    .line 1150
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    iget-object v4, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-direct {p0, v3, v4}, Lcom/android/internal/telephony/ims/ImsResolver;->getInfoByComponentName(Ljava/util/Map;Landroid/content/ComponentName;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object v3

    const/4 v4, 0x1

    if-eqz v3, :cond_1

    .line 1155
    iget-boolean v5, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    if-eqz v5, :cond_0

    .line 1156
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "maybeAddedImsService - updating features for "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, ": "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1157
    invoke-virtual {v3}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v6

    invoke-static {v6}, Lcom/android/internal/telephony/ims/ImsResolver;->printFeatures(Ljava/util/Set;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " -> "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1158
    invoke-virtual {v2}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v6

    invoke-static {v6}, Lcom/android/internal/telephony/ims/ImsResolver;->printFeatures(Ljava/util/Set;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 1156
    invoke-virtual {v0, v5}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1159
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Updating features in cached ImsService: "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1160
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Updating features - Old features: "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, " new features: "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1163
    invoke-virtual {v2}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v0

    invoke-virtual {v3, v0}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->replaceFeatures(Ljava/util/Set;)V

    goto :goto_1

    .line 1166
    :cond_0
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "maybeAddedImsService - scheduling query for "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1168
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    goto/16 :goto_0

    .line 1171
    :cond_1
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Adding newly added ImsService to cache: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1172
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "maybeAddedImsService - adding new ImsService: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1173
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    iget-object v5, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-interface {v3, v5, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1174
    iget-boolean v3, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    if-eqz v3, :cond_2

    :goto_1
    move v0, v4

    goto/16 :goto_0

    .line 1179
    :cond_2
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    goto/16 :goto_0

    :cond_3
    if-eqz v0, :cond_4

    .line 1183
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeatureConfigurationChange()V

    :cond_4
    return-void
.end method

.method private maybeRemovedImsService(Ljava/lang/String;)Z
    .locals 3

    .line 1190
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getInfoByPackageName(Ljava/util/Map;Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 1192
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    iget-object v1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 1193
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "maybeRemovedImsService - removing ImsService: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1194
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Removing ImsService: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ImsResolver"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1195
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->unbindImsService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    .line 1196
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeatureConfigurationChange()V

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private overrideCarrierService(ILjava/util/Map;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 1383
    invoke-interface {p2}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    .line 1384
    invoke-interface {p2, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 1385
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "overriding carrier ImsService to "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " on slot "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " for feature "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v5, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    const-string v6, "invalid"

    .line 1387
    invoke-interface {v5, v1, v6}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 1385
    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1388
    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-direct {p0, v2, p1, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->setOverridePackageName(Ljava/lang/String;II)V

    goto :goto_0

    .line 1390
    :cond_0
    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object p2

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->updateBoundServices(ILjava/util/Map;)V

    return-void
.end method

.method private overrideDeviceService(Ljava/util/Map;)V
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 1406
    invoke-interface {p1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    .line 1407
    invoke-interface {p1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 1408
    iget-object v4, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "overriding device ImsService to "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " for feature "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v6, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    const-string v7, "invalid"

    .line 1409
    invoke-interface {v6, v2, v7}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 1408
    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1410
    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object v4

    .line 1411
    invoke-static {v4, v3}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_0

    .line 1412
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "overrideDeviceService - device package changed (override): "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " -> "

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    const-string v8, "ImsResolver"

    invoke-static {v8, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1414
    iget-object v5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1416
    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-direct {p0, v3, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->setDeviceConfiguration(Ljava/lang/String;I)V

    .line 1417
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object v2

    if-eqz v2, :cond_2

    .line 1418
    iget-boolean v3, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    if-eqz v3, :cond_1

    goto :goto_1

    .line 1422
    :cond_1
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    goto/16 :goto_0

    :cond_2
    :goto_1
    const/4 v1, 0x1

    goto/16 :goto_0

    :cond_3
    if-eqz v1, :cond_4

    .line 1426
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeatureConfigurationChange()V

    :cond_4
    return-void
.end method

.method private static printFeatures(Ljava/util/Set;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 1731
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " features: ["

    .line 1732
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p0, :cond_1

    .line 1734
    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;

    const-string/jumbo v2, "{"

    .line 1735
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1736
    iget v2, v1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->slotId:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ","

    .line 1737
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1738
    sget-object v2, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    iget v1, v1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->featureType:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v2, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo v1, "}"

    .line 1739
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_0

    :cond_0
    const-string p0, "]"

    .line 1741
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1743
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private putImsController(IILcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 5

    if-ltz p1, :cond_2

    .line 1092
    iget v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-ge p1, v0, :cond_2

    const/4 v0, -0x1

    if-le p2, v0, :cond_2

    const/4 v0, 0x3

    if-lt p2, v0, :cond_0

    goto/16 :goto_0

    .line 1098
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundServicesLock:Ljava/lang/Object;

    monitor-enter v0

    .line 1099
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundImsServicesByFeature:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/util/SparseArray;

    if-nez v1, :cond_1

    .line 1101
    new-instance v1, Landroid/util/SparseArray;

    invoke-direct {v1}, Landroid/util/SparseArray;-><init>()V

    .line 1102
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundImsServicesByFeature:Landroid/util/SparseArray;

    invoke-virtual {v2, p1, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1104
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "putImsController - ["

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ", "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v3, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1105
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v3, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "] -> "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 1104
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    const-string p0, "ImsResolver"

    .line 1106
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ImsServiceController added on slot: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " with feature: "

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p1, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1107
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {p1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " using package: "

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1108
    invoke-virtual {p3}, Lcom/android/internal/telephony/ims/ImsServiceController;->getComponentName()Landroid/content/ComponentName;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1106
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1109
    invoke-virtual {v1, p2, p3}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1110
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    :cond_2
    :goto_0
    const-string p0, "ImsResolver"

    .line 1094
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "putImsController received invalid parameters - slot: "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", feature: "

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private removeImsController(II)Lcom/android/internal/telephony/ims/ImsServiceController;
    .locals 6

    const/4 v0, 0x0

    if-ltz p1, :cond_3

    const/4 v1, -0x1

    if-le p2, v1, :cond_3

    const/4 v1, 0x3

    if-lt p2, v1, :cond_0

    goto/16 :goto_0

    .line 1120
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundServicesLock:Ljava/lang/Object;

    monitor-enter v1

    .line 1121
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBoundImsServicesByFeature:Landroid/util/SparseArray;

    invoke-virtual {v2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/util/SparseArray;

    if-nez v2, :cond_1

    .line 1123
    monitor-exit v1

    return-object v0

    .line 1125
    :cond_1
    invoke-virtual {v2, p2, v0}, Landroid/util/SparseArray;->get(ILjava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/ims/ImsServiceController;

    if-eqz v0, :cond_2

    .line 1127
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "removeImsController - ["

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ", "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v4, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1128
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-interface {v4, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "] -> "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 1127
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    const-string p0, "ImsResolver"

    .line 1129
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ImsServiceController removed on slot: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " with feature: "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p1, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1130
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {p1, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " using package: "

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1131
    invoke-virtual {v0}, Lcom/android/internal/telephony/ims/ImsServiceController;->getComponentName()Landroid/content/ComponentName;

    move-result-object p1

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1129
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1132
    invoke-virtual {v2, p2}, Landroid/util/SparseArray;->remove(I)V

    .line 1134
    :cond_2
    monitor-exit v1

    return-object v0

    :catchall_0
    move-exception p0

    .line 1135
    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    :cond_3
    :goto_0
    const-string p0, "ImsResolver"

    .line 1116
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "removeImsController received invalid parameters - slot: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", feature: "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0
.end method

.method private removeOverridePackageName(I)V
    .locals 2

    const/4 v0, 0x0

    :goto_0
    const/4 v1, 0x3

    if-ge v0, v1, :cond_0

    .line 901
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getOverridePackageName(I)Landroid/util/SparseArray;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->remove(I)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private removeSlotId(I)V
    .locals 1

    .line 1894
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    monitor-enter v0

    .line 1895
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseIntArray;->delete(I)V

    .line 1896
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private sanitizeFeatureConfig(Ljava/util/Set;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;",
            ">;)V"
        }
    .end annotation

    .line 1704
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda9;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda9;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;)V

    invoke-interface {p1, v0}, Ljava/util/Set;->removeIf(Ljava/util/function/Predicate;)Z

    .line 1706
    invoke-interface {p1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda10;

    invoke-direct {v0}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda10;-><init>()V

    .line 1707
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1708
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Set;

    .line 1709
    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;

    .line 1710
    new-instance v1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;

    iget v2, v0, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;->slotId:I

    const/4 v3, 0x1

    invoke-direct {v1, v2, v3}, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;-><init>(II)V

    invoke-interface {p1, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 1712
    invoke-interface {p1, v0}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_1
    return-void
.end method

.method private scheduleQueryForFeatures(Landroid/content/ComponentName;I)V
    .locals 1

    .line 1566
    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1568
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "scheduleQueryForFeatures: Couldn\'t find cached info for name: "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ImsResolver"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1571
    :cond_0
    invoke-direct {p0, v0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;I)V

    return-void
.end method

.method private scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V
    .locals 1

    const/4 v0, 0x0

    .line 1575
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;I)V

    return-void
.end method

.method private scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;I)V
    .locals 4

    if-nez p1, :cond_0

    return-void

    .line 1554
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x3

    invoke-static {v0, v1, p1}, Landroid/os/Message;->obtain(Landroid/os/Handler;ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    .line 1555
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    invoke-virtual {v2, v1, p1}, Landroid/os/Handler;->hasMessages(ILjava/lang/Object;)Z

    move-result v1

    const-string v2, "ImsResolver"

    if-eqz v1, :cond_1

    .line 1556
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "scheduleQueryForFeatures: dynamic query for "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " already scheduled"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1560
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "scheduleQueryForFeatures: starting dynamic query for "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " in "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "ms."

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v2, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1562
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    int-to-long p1, p2

    invoke-virtual {p0, v0, p1, p2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method private searchForImsServices(Ljava/lang/String;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;)Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;",
            ")",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;",
            ">;"
        }
    .end annotation

    .line 1776
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1778
    new-instance v1, Landroid/content/Intent;

    invoke-interface {p2}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;->getServiceInterface()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 1779
    invoke-virtual {v1, p1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 1781
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p1

    .line 1785
    invoke-static {}, Landroid/os/UserHandle;->myUserId()I

    move-result v2

    invoke-static {v2}, Landroid/os/UserHandle;->of(I)Landroid/os/UserHandle;

    move-result-object v2

    const/16 v3, 0x80

    .line 1782
    invoke-virtual {p1, v1, v3, v2}, Landroid/content/pm/PackageManager;->queryIntentServicesAsUser(Landroid/content/Intent;ILandroid/os/UserHandle;)Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_8

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/pm/ResolveInfo;

    .line 1786
    iget-object v1, v1, Landroid/content/pm/ResolveInfo;->serviceInfo:Landroid/content/pm/ServiceInfo;

    if-eqz v1, :cond_0

    .line 1789
    new-instance v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    invoke-direct {v2}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;-><init>()V

    .line 1790
    new-instance v3, Landroid/content/ComponentName;

    iget-object v4, v1, Landroid/content/pm/ServiceInfo;->packageName:Ljava/lang/String;

    iget-object v5, v1, Landroid/content/pm/ServiceInfo;->name:Ljava/lang/String;

    invoke-direct {v3, v4, v5}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    iput-object v3, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    .line 1791
    iput-object p2, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->controllerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    .line 1798
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->isDeviceService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Z

    move-result v3

    const/4 v4, 0x0

    if-nez v3, :cond_2

    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mImsServiceControllerFactoryCompat:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    if-ne v3, p2, :cond_1

    goto :goto_1

    .line 1823
    :cond_1
    iput-boolean v4, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    goto :goto_2

    .line 1800
    :cond_2
    :goto_1
    iget-object v3, v1, Landroid/content/pm/ServiceInfo;->metaData:Landroid/os/Bundle;

    if-eqz v3, :cond_4

    const-string v5, "android.telephony.ims.MMTEL_FEATURE"

    .line 1801
    invoke-virtual {v3, v5, v4}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 1802
    iget v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    const/4 v5, 0x1

    invoke-virtual {v2, v3, v5}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->addFeatureForAllSlots(II)V

    .line 1804
    iget-object v3, v1, Landroid/content/pm/ServiceInfo;->metaData:Landroid/os/Bundle;

    const-string v5, "android.telephony.ims.EMERGENCY_MMTEL_FEATURE"

    invoke-virtual {v3, v5, v4}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 1806
    iget v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    invoke-virtual {v2, v3, v4}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->addFeatureForAllSlots(II)V

    .line 1810
    :cond_3
    iget-object v3, v1, Landroid/content/pm/ServiceInfo;->metaData:Landroid/os/Bundle;

    const-string v5, "android.telephony.ims.RCS_FEATURE"

    invoke-virtual {v3, v5, v4}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    if-eqz v3, :cond_4

    .line 1811
    iget v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    const/4 v5, 0x2

    invoke-virtual {v2, v3, v5}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->addFeatureForAllSlots(II)V

    .line 1816
    :cond_4
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mImsServiceControllerFactoryCompat:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    if-eq v3, p2, :cond_5

    .line 1817
    invoke-virtual {v2}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->getSupportedFeatures()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Set;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_5

    .line 1819
    iput-boolean v4, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    .line 1825
    :cond_5
    :goto_2
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "service name: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, ", manifest query: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v5, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "ImsResolver"

    invoke-static {v5, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1831
    iget-object v3, v1, Landroid/content/pm/ServiceInfo;->permission:Ljava/lang/String;

    const-string v6, "android.permission.BIND_IMS_SERVICE"

    invoke-static {v3, v6}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_7

    iget-object v1, v1, Landroid/content/pm/ServiceInfo;->metaData:Landroid/os/Bundle;

    const-string v3, "override_bind_check"

    .line 1832
    invoke-virtual {v1, v3, v4}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    if-eqz v1, :cond_6

    goto :goto_3

    .line 1835
    :cond_6
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ImsService is not protected with BIND_IMS_SERVICE permission: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v5, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    .line 1833
    :cond_7
    :goto_3
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto/16 :goto_0

    :cond_8
    return-object v0
.end method

.method private setCarrierConfiguredPackageName(Ljava/lang/String;II)V
    .locals 0

    .line 879
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageNames(I)Ljava/util/Map;

    move-result-object p0

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private setDeviceConfiguration(Ljava/lang/String;I)V
    .locals 1

    .line 871
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    monitor-enter v0

    .line 872
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 873
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private setOverridePackageName(Ljava/lang/String;II)V
    .locals 0

    .line 908
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getOverridePackageName(I)Landroid/util/SparseArray;

    move-result-object p0

    invoke-virtual {p0, p3, p1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    return-void
.end method

.method private setSubId(II)V
    .locals 1

    .line 1883
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    monitor-enter v0

    .line 1884
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSlotIdToSubIdMap:Landroid/util/SparseIntArray;

    invoke-virtual {p0, p1, p2}, Landroid/util/SparseIntArray;->put(II)V

    .line 1885
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private shouldFeaturesCauseBind(Ljava/util/Set;)Z
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;",
            ">;)Z"
        }
    .end annotation

    .line 1374
    invoke-interface {p1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance p1, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda12;

    invoke-direct {p1}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda12;-><init>()V

    .line 1376
    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/stream/Stream;->count()J

    move-result-wide p0

    const-wide/16 v0, 0x0

    cmp-long p0, p0, v0

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private startDynamicQuery(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V
    .locals 4

    .line 1652
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->isDeviceService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Z

    move-result v0

    const-string v1, "ImsResolver"

    if-nez v0, :cond_0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getSlotsForActiveCarrierService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "scheduleQueryForFeatures: skipping query for ImsService that is not set as carrier/device ImsService."

    .line 1653
    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1657
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "startDynamicQuery - starting query for "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1658
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mFeatureQueryManager:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;

    iget-object v2, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    iget-object v3, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->controllerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    .line 1659
    invoke-interface {v3}, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;->getServiceInterface()Ljava/lang/String;

    move-result-object v3

    .line 1658
    invoke-virtual {v0, v2, v3}, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->startQuery(Landroid/content/ComponentName;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string/jumbo v0, "startDynamicQuery: service could not connect. Retrying after delay."

    .line 1661
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1662
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    const-string/jumbo v1, "startDynamicQuery - query failed. Retrying in 5000 mS"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    const/16 v0, 0x1388

    .line 1664
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;I)V

    goto :goto_0

    :cond_1
    const-string/jumbo p0, "startDynamicQuery: Service queried, waiting for response."

    .line 1666
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method private unbindImsService(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V
    .locals 5

    const-string v0, "ImsResolver"

    if-nez p1, :cond_0

    return-void

    .line 1274
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mActiveControllers:Ljava/util/Map;

    invoke-direct {p0, v1, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getControllerByServiceInfo(Ljava/util/Map;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)Lcom/android/internal/telephony/ims/ImsServiceController;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 1278
    :try_start_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Unbinding ImsService: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Lcom/android/internal/telephony/ims/ImsServiceController;->getComponentName()Landroid/content/ComponentName;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1279
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "unbindImsService - unbinding and removing "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1280
    invoke-virtual {v1}, Lcom/android/internal/telephony/ims/ImsServiceController;->unbind()V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 1282
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "unbindImsService: Remote Exception: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1284
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mActiveControllers:Ljava/util/Map;

    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-interface {p0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    return-void
.end method

.method private updateBoundDeviceServices()V
    .locals 6

    const-string v0, "ImsResolver"

    const-string/jumbo v1, "updateBoundDeviceServices: called"

    .line 1443
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1444
    new-instance v1, Landroid/util/ArrayMap;

    invoke-direct {v1}, Landroid/util/ArrayMap;-><init>()V

    const/4 v2, 0x0

    :goto_0
    const/4 v3, 0x3

    if-ge v2, v3, :cond_1

    .line 1446
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object v3

    .line 1447
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object v4

    if-eqz v4, :cond_0

    .line 1448
    iget-boolean v5, v4, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    if-nez v5, :cond_0

    .line 1449
    invoke-virtual {v1, v3}, Landroid/util/ArrayMap;->containsKey(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_0

    .line 1450
    invoke-virtual {v1, v3, v4}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1452
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v5, "updateBoundDeviceServices: Schedule query for package="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1453
    invoke-virtual {v1, v3}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method

.method private updateBoundServices(ILjava/util/Map;)V
    .locals 16
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    move-object/from16 v0, p0

    move/from16 v1, p1

    const/4 v2, -0x1

    if-le v1, v2, :cond_7

    .line 1459
    iget v2, v0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-lt v1, v2, :cond_0

    goto/16 :goto_4

    :cond_0
    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    move v5, v4

    :goto_0
    const/4 v6, 0x3

    if-ge v3, v6, :cond_5

    .line 1465
    invoke-direct {v0, v1, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->getOverridePackageName(II)Ljava/lang/String;

    move-result-object v7

    .line 1466
    invoke-direct {v0, v1, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageName(II)Ljava/lang/String;

    move-result-object v8

    .line 1467
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    const-string v10, ""

    move-object/from16 v11, p2

    invoke-interface {v11, v9, v10}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/String;

    .line 1468
    invoke-static {v7}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v10

    const-string v12, "ImsResolver"

    const/4 v13, 0x1

    if-nez v10, :cond_2

    const/4 v10, 0x4

    new-array v10, v10, [Ljava/lang/Object;

    .line 1473
    invoke-static {v9}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v14

    if-eqz v14, :cond_1

    const-string v9, "(none)"

    :cond_1
    aput-object v9, v10, v2

    aput-object v7, v10, v13

    const/4 v9, 0x2

    sget-object v14, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1475
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v15

    const-string v2, "invalid"

    invoke-interface {v14, v15, v2}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    aput-object v2, v10, v9

    invoke-static/range {p1 .. p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v10, v6

    const-string/jumbo v2, "updateBoundServices: overriding %s with %s for feature %s on slot %d"

    .line 1471
    invoke-static {v2, v10}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v12, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    :cond_2
    move-object v7, v9

    .line 1479
    :goto_1
    invoke-direct {v0, v7, v1, v3}, Lcom/android/internal/telephony/ims/ImsResolver;->setCarrierConfiguredPackageName(Ljava/lang/String;II)V

    .line 1482
    invoke-virtual {v0, v7}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object v2

    .line 1483
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v9, "updateBoundServices - carrier package changed: "

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, " -> "

    invoke-virtual {v6, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v14, " on slot "

    invoke-virtual {v6, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v15, ", hasConfigChanged="

    invoke-virtual {v6, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v12, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1486
    iget-object v6, v0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v12, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    if-eqz v2, :cond_4

    .line 1489
    iget-boolean v6, v2, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->featureFromMetadata:Z

    if-eqz v6, :cond_3

    goto :goto_2

    .line 1493
    :cond_3
    invoke-direct {v0, v2}, Lcom/android/internal/telephony/ims/ImsResolver;->scheduleQueryForFeatures(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    move v5, v13

    goto :goto_3

    :cond_4
    :goto_2
    move v4, v13

    :goto_3
    add-int/lit8 v3, v3, 0x1

    const/4 v2, 0x0

    goto/16 :goto_0

    :cond_5
    if-eqz v4, :cond_6

    .line 1497
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/ims/ImsResolver;->calculateFeatureConfigurationChange()V

    :cond_6
    if-eqz v4, :cond_7

    if-eqz v5, :cond_7

    .line 1500
    iget-object v0, v0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[warning] updateBoundServices - both hasConfigChange and query scheduled on slot "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    :cond_7
    :goto_4
    return-void
.end method

.method private updateInstalledServicesCache()V
    .locals 4

    const/4 v0, 0x0

    .line 713
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceInfo(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    .line 714
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    iget-object v3, v1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-interface {v2, v3}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 715
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    iget-object v3, v1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;->name:Landroid/content/ComponentName;

    invoke-interface {v2, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    :cond_1
    return-void
.end method


# virtual methods
.method public clearCarrierImsServiceConfiguration(I)Z
    .locals 2

    const/4 v0, 0x0

    if-ltz p1, :cond_1

    .line 840
    iget v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-lt p1, v1, :cond_0

    goto :goto_0

    .line 845
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/16 v1, 0x8

    invoke-static {p0, v1, p1, v0}, Landroid/os/Message;->obtain(Landroid/os/Handler;III)Landroid/os/Message;

    move-result-object p0

    .line 846
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    const-string p0, "ImsResolver"

    const-string p1, "clearCarrierImsServiceConfiguration: invalid slotId!"

    .line 841
    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return v0
.end method

.method public destroy()V
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 725
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    invoke-static {v0}, Lcom/android/internal/telephony/PhoneConfigurationManager;->unregisterForMultiSimConfigChange(Landroid/os/Handler;)V

    .line 726
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    return-void
.end method

.method public disableIms(I)V
    .locals 2

    .line 774
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceControllers(I)Ljava/util/Set;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda13;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda13;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;I)V

    invoke-interface {v0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 4

    .line 1902
    new-instance p1, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p3, "  "

    invoke-direct {p1, p2, p3}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    const-string p2, "ImsResolver:"

    .line 1903
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1904
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Configurations:"

    .line 1905
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1906
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Device:"

    .line 1907
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1908
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1909
    iget-object p2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    monitor-enter p2

    .line 1910
    :try_start_0
    iget-object p3, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    invoke-interface {p3}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object p3

    invoke-interface {p3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p3

    :goto_0
    invoke-interface {p3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    .line 1911
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v2, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    invoke-interface {v2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " -> "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDeviceServices:Ljava/util/Map;

    invoke-interface {v2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_0

    .line 1913
    :cond_0
    monitor-exit p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1914
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Carrier: "

    .line 1915
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1916
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const/4 p2, 0x0

    move p3, p2

    .line 1917
    :goto_1
    iget v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-ge p3, v0, :cond_3

    move v0, p2

    :goto_2
    const/4 v1, 0x3

    if-ge v0, v1, :cond_2

    const-string/jumbo v1, "slot="

    .line 1919
    invoke-virtual {p1, v1}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 1920
    invoke-virtual {p1, p3}, Ljava/io/PrintWriter;->print(I)V

    const-string v1, ", feature="

    .line 1921
    invoke-virtual {p1, v1}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 1922
    sget-object v1, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const-string v3, "?"

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    const-string v1, ": "

    .line 1923
    invoke-virtual {p1, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1924
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1925
    invoke-direct {p0, p3, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->getCarrierConfiguredPackageName(II)Ljava/lang/String;

    move-result-object v1

    .line 1926
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    const-string v1, "none"

    :cond_1
    invoke-virtual {p1, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1927
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    :cond_2
    add-int/lit8 p3, p3, 0x1

    goto :goto_1

    .line 1930
    :cond_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1931
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Cached ImsServices:"

    .line 1932
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1933
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1934
    iget-object p2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    invoke-interface {p2}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_3
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result p3

    if-eqz p3, :cond_4

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    .line 1935
    invoke-virtual {p1, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/Object;)V

    goto :goto_3

    .line 1937
    :cond_4
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Active controllers:"

    .line 1938
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1939
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1940
    iget-object p2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mActiveControllers:Ljava/util/Map;

    invoke-interface {p2}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_4
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result p3

    if-eqz p3, :cond_5

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/ims/ImsServiceController;

    .line 1941
    invoke-virtual {p1, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/Object;)V

    .line 1942
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1943
    invoke-virtual {p3, p1}, Lcom/android/internal/telephony/ims/ImsServiceController;->dump(Ljava/io/PrintWriter;)V

    .line 1944
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    goto :goto_4

    .line 1946
    :cond_5
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Connection Repository Log:"

    .line 1947
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1948
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1949
    iget-object p2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

    invoke-virtual {p2, p1}, Lcom/android/ims/ImsFeatureBinderRepository;->dump(Ljava/io/PrintWriter;)V

    .line 1950
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Event Log:"

    .line 1951
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1952
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1953
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/PrintWriter;)V

    .line 1954
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    return-void

    :catchall_0
    move-exception p0

    .line 1913
    :try_start_1
    monitor-exit p2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public enableIms(I)V
    .locals 2

    .line 765
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getImsServiceControllers(I)Ljava/util/Set;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda11;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda11;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;I)V

    invoke-interface {v0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public getConfiguredImsServicePackageName(II)Ljava/lang/String;
    .locals 16

    move-object/from16 v1, p0

    move/from16 v2, p1

    move/from16 v3, p2

    const-string v0, " ms with package name: "

    const-string v4, "], async query complete, took "

    const-string v5, "getResolvedImsServicePackageName: ["

    const-string v6, "getResolvedImsServicePackageName - ["

    const-string v7, ", "

    const-string v9, "ImsResolver"

    if-ltz v2, :cond_3

    .line 1014
    iget v10, v1, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-ge v2, v10, :cond_3

    const/4 v10, -0x1

    if-le v3, v10, :cond_3

    const/4 v10, 0x3

    if-lt v3, v10, :cond_0

    goto/16 :goto_2

    .line 1020
    :cond_0
    new-instance v10, Ljava/util/concurrent/CompletableFuture;

    invoke-direct {v10}, Ljava/util/concurrent/CompletableFuture;-><init>()V

    .line 1021
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v11

    .line 1022
    iget-object v13, v1, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    invoke-virtual {v13}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v13

    invoke-virtual {v13}, Landroid/os/Looper;->isCurrentThread()Z

    move-result v13

    if-eqz v13, :cond_1

    .line 1025
    invoke-direct/range {p0 .. p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getConfiguredImsServicePackageNameInternal(II)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v10, v13}, Ljava/util/concurrent/CompletableFuture;->complete(Ljava/lang/Object;)Z

    goto :goto_0

    .line 1028
    :cond_1
    iget-object v13, v1, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    new-instance v14, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;

    invoke-direct {v14, v1, v10, v2, v3}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/CompletableFuture;II)V

    invoke-virtual {v13, v14}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 1040
    :goto_0
    :try_start_0
    invoke-virtual {v10}, Ljava/util/concurrent/CompletableFuture;->get()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/lang/String;

    .line 1041
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v13

    sub-long/2addr v13, v11

    const-wide/16 v11, 0x32

    cmp-long v11, v13, v11

    if-lez v11, :cond_2

    .line 1044
    iget-object v11, v1, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v12, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v15, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1045
    invoke-static/range {p2 .. p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-interface {v15, v8}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    invoke-virtual {v12, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v13, v14}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    .line 1044
    invoke-virtual {v11, v8}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1048
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v11, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1049
    invoke-static/range {p2 .. p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v12

    invoke-interface {v11, v12}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Ljava/lang/String;

    invoke-virtual {v8, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v13, v14}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1048
    invoke-static {v9, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_2
    return-object v10

    :catch_0
    move-exception v0

    .line 1055
    iget-object v1, v1, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v6, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1056
    invoke-static/range {p2 .. p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-interface {v6, v8}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "] -> Exception: "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 1055
    invoke-virtual {v1, v4}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1057
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Landroid/telephony/ims/feature/ImsFeature;->FEATURE_LOG_MAP:Ljava/util/Map;

    .line 1058
    invoke-static/range {p2 .. p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v2, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "] returned Exception: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1057
    invoke-static {v9, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    const/4 v1, 0x0

    return-object v1

    .line 1016
    :cond_3
    :goto_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getResolvedImsServicePackageName received invalid parameters - slot: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", feature: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v9, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1
.end method

.method public getHandler()Landroid/os/Handler;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 650
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    return-object p0
.end method

.method public getImsConfig(II)Landroid/telephony/ims/aidl/IImsConfig;
    .locals 0

    .line 790
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

    invoke-virtual {p0, p1, p2}, Lcom/android/ims/ImsFeatureBinderRepository;->getIfExists(II)Ljava/util/Optional;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/ims/ImsFeatureContainer;

    if-eqz p0, :cond_0

    .line 791
    iget-object p1, p0, Lcom/android/ims/ImsFeatureContainer;->imsConfig:Landroid/telephony/ims/aidl/IImsConfig;

    :cond_0
    return-object p1
.end method

.method public getImsRegistration(II)Landroid/telephony/ims/aidl/IImsRegistration;
    .locals 0

    .line 782
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

    invoke-virtual {p0, p1, p2}, Lcom/android/ims/ImsFeatureBinderRepository;->getIfExists(II)Ljava/util/Optional;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/ims/ImsFeatureContainer;

    if-eqz p0, :cond_0

    .line 783
    iget-object p1, p0, Lcom/android/ims/ImsFeatureContainer;->imsRegistration:Landroid/telephony/ims/aidl/IImsRegistration;

    :cond_0
    return-object p1
.end method

.method public getImsServiceConfiguration(IZI)Ljava/lang/String;
    .locals 10

    const-string v0, "ImsResolver"

    if-ltz p1, :cond_1

    .line 962
    iget v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-lt p1, v1, :cond_0

    goto :goto_0

    .line 967
    :cond_0
    new-instance v1, Ljava/util/concurrent/LinkedBlockingQueue;

    const/4 v2, 0x1

    invoke-direct {v1, v2}, Ljava/util/concurrent/LinkedBlockingQueue;-><init>(I)V

    .line 969
    iget-object v8, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    new-instance v9, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;

    move-object v2, v9

    move-object v3, p0

    move-object v4, v1

    move v5, p2

    move v6, p1

    move v7, p3

    invoke-direct/range {v2 .. v7}, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/LinkedBlockingQueue;ZII)V

    invoke-virtual {v8, v9}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    const-wide/16 p0, 0x1388

    .line 973
    :try_start_0
    sget-object p2, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v1, p0, p1, p2}, Ljava/util/concurrent/LinkedBlockingQueue;->poll(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 975
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "getImsServiceConfiguration: exception="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/InterruptedException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0

    :cond_1
    :goto_0
    const-string p0, "getImsServiceConfiguration: invalid slotId!"

    .line 963
    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const-string p0, ""

    return-object p0
.end method

.method public getImsServiceInfoFromCache(Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 1752
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return-object v1

    .line 1755
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mInstalledServicesCache:Ljava/util/Map;

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->getInfoByPackageName(Ljava/util/Map;Ljava/lang/String;)Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    move-result-object p0

    if-eqz p0, :cond_1

    return-object p0

    :cond_1
    return-object v1
.end method

.method public imsServiceBindPermanentError(Landroid/content/ComponentName;)V
    .locals 3

    if-nez p1, :cond_0

    return-void

    .line 1362
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "imsServiceBindPermanentError: component="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ImsResolver"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1363
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "imsServiceBindPermanentError - for "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1364
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x1

    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public imsServiceFeatureCreated(IILcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 0

    .line 1327
    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/ims/ImsResolver;->putImsController(IILcom/android/internal/telephony/ims/ImsServiceController;)V

    return-void
.end method

.method public imsServiceFeatureRemoved(IILcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 0

    .line 1337
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->removeImsController(II)Lcom/android/internal/telephony/ims/ImsServiceController;

    return-void
.end method

.method public imsServiceFeaturesChanged(Landroid/telephony/ims/stub/ImsFeatureConfiguration;Lcom/android/internal/telephony/ims/ImsServiceController;)V
    .locals 3

    if-eqz p2, :cond_1

    if-nez p1, :cond_0

    goto :goto_0

    .line 1350
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "imsServiceFeaturesChanged: config="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/telephony/ims/stub/ImsFeatureConfiguration;->getServiceFeatures()Ljava/util/Set;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", ComponentName="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1351
    invoke-virtual {p2}, Lcom/android/internal/telephony/ims/ImsServiceController;->getComponentName()Landroid/content/ComponentName;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ImsResolver"

    .line 1350
    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1352
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "imsServiceFeaturesChanged - for "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ", new config "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1353
    invoke-virtual {p1}, Landroid/telephony/ims/stub/ImsFeatureConfiguration;->getServiceFeatures()Ljava/util/Set;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1352
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1354
    invoke-virtual {p2}, Lcom/android/internal/telephony/ims/ImsServiceController;->getComponentName()Landroid/content/ComponentName;

    move-result-object p2

    invoke-virtual {p1}, Landroid/telephony/ims/stub/ImsFeatureConfiguration;->getServiceFeatures()Ljava/util/Set;

    move-result-object p1

    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->handleFeaturesChanged(Landroid/content/ComponentName;Ljava/util/Set;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public initialize()V
    .locals 8

    .line 662
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mEventLog:Lcom/android/internal/telephony/LocalLog;

    const-string v1, "Initializing"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    const-string v0, "ImsResolver"

    const-string v1, "Initializing cache."

    .line 663
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 664
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/4 v2, 0x7

    const/4 v3, 0x0

    invoke-static {v1, v2, v3}, Lcom/android/internal/telephony/PhoneConfigurationManager;->registerForMultiSimConfigChange(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 666
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDynamicQueryManagerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsDynamicQueryManagerFactory;

    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mContext:Landroid/content/Context;

    iget-object v4, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDynamicQueryListener:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;

    invoke-interface {v1, v2, v4}, Lcom/android/internal/telephony/ims/ImsResolver$ImsDynamicQueryManagerFactory;->create(Landroid/content/Context;Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;)Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mFeatureQueryManager:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;

    .line 668
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->updateInstalledServicesCache()V

    .line 670
    new-instance v1, Landroid/content/IntentFilter;

    invoke-direct {v1}, Landroid/content/IntentFilter;-><init>()V

    const-string v2, "android.intent.action.PACKAGE_CHANGED"

    .line 671
    invoke-virtual {v1, v2}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v2, "android.intent.action.PACKAGE_REMOVED"

    .line 672
    invoke-virtual {v1, v2}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v2, "android.intent.action.PACKAGE_ADDED"

    .line 673
    invoke-virtual {v1, v2}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v2, "package"

    .line 674
    invoke-virtual {v1, v2}, Landroid/content/IntentFilter;->addDataScheme(Ljava/lang/String;)V

    .line 675
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mReceiverContext:Landroid/content/Context;

    iget-object v4, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mAppChangedReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v2, v4, v1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 676
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mReceiverContext:Landroid/content/Context;

    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mConfigChangedReceiver:Landroid/content/BroadcastReceiver;

    new-instance v4, Landroid/content/IntentFilter;

    const-string v5, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-direct {v4, v5}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v2, v4}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 679
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mReceiverContext:Landroid/content/Context;

    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSimStateChangedReceiver:Landroid/content/BroadcastReceiver;

    new-instance v4, Landroid/content/IntentFilter;

    const-string v5, "android.intent.action.SIM_STATE_CHANGED"

    invoke-direct {v4, v5}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v2, v4}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 683
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mContext:Landroid/content/Context;

    const-string/jumbo v2, "user"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/UserManager;

    .line 684
    invoke-virtual {v1}, Landroid/os/UserManager;->isUserUnlocked()Z

    move-result v2

    const/4 v4, 0x6

    if-eqz v2, :cond_0

    .line 685
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    invoke-virtual {v1, v4, v3}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    .line 687
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mReceiverContext:Landroid/content/Context;

    iget-object v5, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mBootCompleted:Landroid/content/BroadcastReceiver;

    new-instance v6, Landroid/content/IntentFilter;

    const-string v7, "android.intent.action.BOOT_COMPLETED"

    invoke-direct {v6, v7}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v5, v6}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 689
    invoke-virtual {v1}, Landroid/os/UserManager;->isUserUnlocked()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 690
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    invoke-virtual {v1, v4, v3}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/Message;->sendToTarget()V

    .line 697
    :cond_1
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->bindCarrierServicesIfAvailable()V

    const/4 v1, 0x0

    .line 700
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "com.mediatek.ims"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v1, "Initializing for binding ims service earlier"

    .line 701
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 702
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/16 v0, 0x3e8

    invoke-virtual {p0, v0, v3}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    :cond_2
    return-void
.end method

.method public isImsServiceConfiguredForFeature(II)Z
    .locals 2

    .line 989
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getDeviceConfiguration(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x1

    if-nez v0, :cond_0

    return v1

    .line 996
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsResolver;->getConfiguredImsServicePackageName(II)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    xor-int/2addr p0, v1

    return p0
.end method

.method public listenForFeature(IILcom/android/ims/internal/IImsServiceFeatureCallback;)V
    .locals 1

    .line 826
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRunnableExecutor:Landroid/os/HandlerExecutor;

    invoke-virtual {v0, p1, p2, p3, p0}, Lcom/android/ims/ImsFeatureBinderRepository;->registerForConnectionUpdates(IILcom/android/ims/internal/IImsServiceFeatureCallback;Ljava/util/concurrent/Executor;)V

    return-void
.end method

.method public overrideImsServiceConfiguration(IZLjava/util/Map;)Z
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(IZ",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)Z"
        }
    .end annotation

    if-ltz p1, :cond_1

    .line 853
    iget v0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mNumSlots:I

    if-lt p1, v0, :cond_0

    goto :goto_0

    .line 858
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;-><init>(IZLjava/util/Map;)V

    .line 859
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mHandler:Landroid/os/Handler;

    const/4 p1, 0x5

    invoke-static {p0, p1, v0}, Landroid/os/Message;->obtain(Landroid/os/Handler;ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 860
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    const-string p0, "ImsResolver"

    const-string p1, "overrideImsServiceConfiguration: invalid slotId!"

    .line 854
    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0
.end method

.method public setImsDynamicQueryManagerFactory(Lcom/android/internal/telephony/ims/ImsResolver$ImsDynamicQueryManagerFactory;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 655
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mDynamicQueryManagerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsDynamicQueryManagerFactory;

    return-void
.end method

.method public setImsServiceControllerFactory(Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 645
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mImsServiceControllerFactory:Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceControllerFactory;

    return-void
.end method

.method public setSubscriptionManagerProxy(Lcom/android/internal/telephony/ims/ImsResolver$SubscriptionManagerProxy;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 640
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mSubscriptionManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$SubscriptionManagerProxy;

    return-void
.end method

.method public setTelephonyManagerProxy(Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 635
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mTelephonyManagerProxy:Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;

    return-void
.end method

.method public unregisterImsFeatureCallback(Lcom/android/ims/internal/IImsServiceFeatureCallback;)V
    .locals 0

    .line 835
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver;->mRepo:Lcom/android/ims/ImsFeatureBinderRepository;

    invoke-virtual {p0, p1}, Lcom/android/ims/ImsFeatureBinderRepository;->unregisterForConnectionUpdates(Lcom/android/ims/internal/IImsServiceFeatureCallback;)V

    return-void
.end method
