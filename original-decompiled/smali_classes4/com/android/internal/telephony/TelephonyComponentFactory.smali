.class public Lcom/android/internal/telephony/TelephonyComponentFactory;
.super Ljava/lang/Object;
.source "TelephonyComponentFactory.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;
    }
.end annotation


# static fields
.field public static final LOG_TAG:Ljava/lang/String; = "TelephonyComponentFactory"

.field private static final TAG:Ljava/lang/String; = "TelephonyComponentFactory"

.field private static final USE_NEW_NITZ_STATE_MACHINE:Z = true

.field private static sInstance:Lcom/android/internal/telephony/TelephonyComponentFactory;


# instance fields
.field private mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

.field private final mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;


# direct methods
.method public static synthetic $r8$lambda$4UcmNQRMxhdBpx1SY35W7BfhG3A(Landroid/content/Context;ILjava/lang/String;Lcom/android/ims/FeatureConnector$Listener;Ljava/util/concurrent/Executor;)Lcom/android/ims/FeatureConnector;
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/ims/ImsManager;->getConnector(Landroid/content/Context;ILjava/lang/String;Lcom/android/ims/FeatureConnector$Listener;Ljava/util/concurrent/Executor;)Lcom/android/ims/FeatureConnector;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$XUvWtqLPw4OPY2TZLMlBQCjmnY8(Landroid/content/Context;ILjava/lang/String;Lcom/android/ims/FeatureConnector$Listener;Ljava/util/concurrent/Executor;)Lcom/android/ims/FeatureConnector;
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/ims/ImsManager;->getConnector(Landroid/content/Context;ILjava/lang/String;Lcom/android/ims/FeatureConnector$Listener;Ljava/util/concurrent/Executor;)Lcom/android/ims/FeatureConnector;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$sfgetTAG()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcom/android/internal/telephony/TelephonyComponentFactory;->TAG:Ljava/lang/String;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 112
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 118
    new-instance v0, Lcom/android/internal/telephony/TelephonyFacade;

    invoke-direct {v0}, Lcom/android/internal/telephony/TelephonyFacade;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    return-void
.end method

.method public static getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;
    .locals 1

    .line 275
    sget-object v0, Lcom/android/internal/telephony/TelephonyComponentFactory;->sInstance:Lcom/android/internal/telephony/TelephonyComponentFactory;

    if-nez v0, :cond_0

    .line 276
    new-instance v0, Lcom/android/internal/telephony/TelephonyComponentFactory;

    invoke-direct {v0}, Lcom/android/internal/telephony/TelephonyComponentFactory;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/TelephonyComponentFactory;->sInstance:Lcom/android/internal/telephony/TelephonyComponentFactory;

    .line 278
    :cond_0
    sget-object v0, Lcom/android/internal/telephony/TelephonyComponentFactory;->sInstance:Lcom/android/internal/telephony/TelephonyComponentFactory;

    return-object v0
.end method


# virtual methods
.method public getCdmaSubscriptionSourceManagerInstance(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Landroid/os/Handler;ILjava/lang/Object;)Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;
    .locals 0

    .line 552
    invoke-static {p1, p2, p3, p4, p5}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getInstance(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Landroid/os/Handler;ILjava/lang/Object;)Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    move-result-object p0

    return-object p0
.end method

.method public initCarrierExpress()V
    .locals 0

    return-void
.end method

.method public initGwsdService(Landroid/content/Context;)V
    .locals 0

    return-void
.end method

.method public initMultiSimSettingController(Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)Lcom/android/internal/telephony/MultiSimSettingController;
    .locals 0

    .line 595
    invoke-static {p1, p2}, Lcom/android/internal/telephony/MultiSimSettingController;->init(Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)Lcom/android/internal/telephony/MultiSimSettingController;

    move-result-object p0

    return-object p0
.end method

.method public initRadioManager(Landroid/content/Context;I[Lcom/android/internal/telephony/CommandsInterface;)V
    .locals 0

    return-void
.end method

.method public initSubscriptionController(Landroid/content/Context;)Lcom/android/internal/telephony/SubscriptionController;
    .locals 0

    .line 578
    invoke-static {p1}, Lcom/android/internal/telephony/SubscriptionController;->init(Landroid/content/Context;)Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p0

    return-object p0
.end method

.method public initVoDataService(Landroid/content/Context;)V
    .locals 0

    return-void
.end method

.method public inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;
    .locals 1

    .line 316
    iget-object v0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    if-eqz v0, :cond_0

    invoke-static {v0, p1}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;->-$$Nest$misComponentInjected(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 317
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    invoke-static {p0}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;->-$$Nest$fgetmInjectedInstance(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p0

    return-object p0

    .line 319
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->sInstance:Lcom/android/internal/telephony/TelephonyComponentFactory;

    return-object p0
.end method

.method public injectTheComponentFactory(Landroid/content/res/XmlResourceParser;)V
    .locals 3

    .line 294
    iget-object v0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    if-eqz v0, :cond_0

    .line 295
    sget-object p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->TAG:Ljava/lang/String;

    const-string p1, "Already injected."

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_0
    if-eqz p1, :cond_2

    .line 300
    new-instance v0, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;-><init>(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents-IA;)V

    iput-object v0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    .line 301
    invoke-static {v0, p1}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;->-$$Nest$mparseXml(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;Lorg/xmlpull/v1/XmlPullParser;)V

    .line 302
    iget-object p1, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;->-$$Nest$mmakeInjectedInstance(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;)V

    .line 303
    iget-object p1, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;->-$$Nest$mgetValidatedPaths(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p1

    xor-int/lit8 p1, p1, 0x1

    .line 304
    sget-object v0, Lcom/android/internal/telephony/TelephonyComponentFactory;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Total components injected: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p1, :cond_1

    .line 305
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mInjectedComponents:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    invoke-static {p0}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;->-$$Nest$fgetmComponentNames(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;)Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->size()I

    move-result p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 304
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return-void
.end method

.method public makeAccessNetworksManager(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)Lcom/android/internal/telephony/data/AccessNetworksManager;
    .locals 0

    .line 546
    new-instance p0, Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V

    return-object p0
.end method

.method public makeAppSmsManager(Landroid/content/Context;)Lcom/android/internal/telephony/AppSmsManager;
    .locals 0

    .line 527
    new-instance p0, Lcom/android/internal/telephony/AppSmsManager;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/AppSmsManager;-><init>(Landroid/content/Context;)V

    return-object p0
.end method

.method public makeCallManager()Lcom/android/internal/telephony/CallManager;
    .locals 0

    .line 330
    new-instance p0, Lcom/android/internal/telephony/CallManager;

    invoke-direct {p0}, Lcom/android/internal/telephony/CallManager;-><init>()V

    return-object p0
.end method

.method public makeCarrierActionAgent(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/CarrierActionAgent;
    .locals 0

    .line 374
    new-instance p0, Lcom/android/internal/telephony/CarrierActionAgent;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierActionAgent;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeCarrierResolver(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/CarrierResolver;
    .locals 0

    .line 378
    new-instance p0, Lcom/android/internal/telephony/CarrierResolver;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierResolver;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeCarrierSignalAgent(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/CarrierSignalAgent;
    .locals 0

    .line 370
    new-instance p0, Lcom/android/internal/telephony/CarrierSignalAgent;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierSignalAgent;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeCatService(Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/UiccCardApplication;Lcom/android/internal/telephony/uicc/IccRecords;Landroid/content/Context;Lcom/android/internal/telephony/uicc/IccFileHandler;Lcom/android/internal/telephony/uicc/UiccProfile;I)Lcom/android/internal/telephony/cat/CatService;
    .locals 8

    .line 789
    new-instance p0, Lcom/android/internal/telephony/cat/CatService;

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    move v7, p7

    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/cat/CatService;-><init>(Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/UiccCardApplication;Lcom/android/internal/telephony/uicc/IccRecords;Landroid/content/Context;Lcom/android/internal/telephony/uicc/IccFileHandler;Lcom/android/internal/telephony/uicc/UiccProfile;I)V

    return-object p0
.end method

.method public makeCdmaInboundSmsHandler(Landroid/content/Context;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;)Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;
    .locals 0

    .line 501
    new-instance p0, Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;)V

    return-object p0
.end method

.method public makeCdmaSMSDispatcher(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;)Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;
    .locals 0

    .line 456
    new-instance p0, Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;)V

    return-object p0
.end method

.method public makeCdmaSubscriptionSourceManager(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Landroid/os/Handler;ILjava/lang/Object;)Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;
    .locals 0

    .line 716
    new-instance p0, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;)V

    return-object p0
.end method

.method public makeCommandParamsFactory(Lcom/android/internal/telephony/cat/RilMessageDecoder;Lcom/android/internal/telephony/uicc/IccFileHandler;Landroid/content/Context;)Lcom/android/internal/telephony/cat/CommandParamsFactory;
    .locals 0

    .line 805
    new-instance p0, Lcom/android/internal/telephony/cat/CommandParamsFactory;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/cat/CommandParamsFactory;-><init>(Lcom/android/internal/telephony/cat/RilMessageDecoder;Lcom/android/internal/telephony/uicc/IccFileHandler;Landroid/content/Context;)V

    return-object p0
.end method

.method public makeDataConfigManager(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)Lcom/android/internal/telephony/data/DataConfigManager;
    .locals 0

    .line 706
    new-instance p0, Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataConfigManager;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V

    return-object p0
.end method

.method public makeDataEnabledSettings(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;
    .locals 0

    .line 567
    new-instance p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeDataHelper(Landroid/content/Context;[Lcom/android/internal/telephony/Phone;)V
    .locals 0

    return-void
.end method

.method public makeDataNetwork(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Landroid/util/SparseArray;Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;ILcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;)Lcom/android/internal/telephony/data/DataNetwork;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Landroid/os/Looper;",
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/data/DataServiceManager;",
            ">;",
            "Landroid/telephony/data/DataProfile;",
            "Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;",
            "I",
            "Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;",
            "Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;",
            ")",
            "Lcom/android/internal/telephony/data/DataNetwork;"
        }
    .end annotation

    .line 700
    new-instance v9, Lcom/android/internal/telephony/data/DataNetwork;

    move-object v0, v9

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    move/from16 v6, p6

    move-object/from16 v7, p7

    move-object/from16 v8, p8

    invoke-direct/range {v0 .. v8}, Lcom/android/internal/telephony/data/DataNetwork;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Landroid/util/SparseArray;Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;ILcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;)V

    return-object v9
.end method

.method public makeDataNetworkController(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)Lcom/android/internal/telephony/data/DataNetworkController;
    .locals 0

    .line 654
    new-instance p0, Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V

    return-object p0
.end method

.method public makeDataProfileManager(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)Lcom/android/internal/telephony/data/DataProfileManager;
    .locals 6

    .line 672
    new-instance p0, Lcom/android/internal/telephony/data/DataProfileManager;

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataProfileManager;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V

    return-object p0
.end method

.method public makeDataSettingsManager(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)Lcom/android/internal/telephony/data/DataSettingsManager;
    .locals 0

    .line 689
    new-instance p0, Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/data/DataSettingsManager;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    return-object p0
.end method

.method public makeDcTracker(Lcom/android/internal/telephony/Phone;I)Lcom/android/internal/telephony/dataconnection/DcTracker;
    .locals 0

    .line 366
    new-instance p0, Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DcTracker;-><init>(Lcom/android/internal/telephony/Phone;I)V

    return-object p0
.end method

.method public makeDefaultPhoneNotifier(Landroid/content/Context;)Lcom/android/internal/telephony/DefaultPhoneNotifier;
    .locals 0

    .line 760
    new-instance p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/DefaultPhoneNotifier;-><init>(Landroid/content/Context;)V

    return-object p0
.end method

.method public makeDeviceStateMonitor(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/DeviceStateMonitor;
    .locals 0

    .line 531
    new-instance p0, Lcom/android/internal/telephony/DeviceStateMonitor;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/DeviceStateMonitor;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeDisplayInfoController(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/DisplayInfoController;
    .locals 0

    .line 590
    new-instance p0, Lcom/android/internal/telephony/DisplayInfoController;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/DisplayInfoController;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeEmergencyNumberTracker(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/CommandsInterface;)Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;
    .locals 0

    .line 349
    new-instance p0, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/CommandsInterface;)V

    return-object p0
.end method

.method public makeEriManager(Lcom/android/internal/telephony/Phone;I)Lcom/android/internal/telephony/cdma/EriManager;
    .locals 0

    .line 398
    new-instance p0, Lcom/android/internal/telephony/cdma/EriManager;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/cdma/EriManager;-><init>(Lcom/android/internal/telephony/Phone;I)V

    return-object p0
.end method

.method public makeGsmCdmaCallTracker(Lcom/android/internal/telephony/GsmCdmaPhone;)Lcom/android/internal/telephony/GsmCdmaCallTracker;
    .locals 0

    .line 323
    new-instance p0, Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;)V

    return-object p0
.end method

.method public makeGsmInboundSmsHandler(Landroid/content/Context;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;
    .locals 0

    .line 486
    invoke-static {p1, p2, p3}, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;->makeInboundSmsHandler(Landroid/content/Context;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    move-result-object p0

    return-object p0
.end method

.method public makeGsmSMSDispatcher(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;)Lcom/android/internal/telephony/gsm/GsmSMSDispatcher;
    .locals 0

    .line 465
    new-instance p0, Lcom/android/internal/telephony/gsm/GsmSMSDispatcher;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/gsm/GsmSMSDispatcher;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;)V

    return-object p0
.end method

.method public makeIccPhoneBookInterfaceManager(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;
    .locals 0

    .line 382
    new-instance p0, Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeIccSmsInterfaceManager(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/IccSmsInterfaceManager;
    .locals 0

    .line 386
    new-instance p0, Lcom/android/internal/telephony/IccSmsInterfaceManager;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/IccSmsInterfaceManager;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeIconLoader(Landroid/os/Looper;Lcom/android/internal/telephony/uicc/IccFileHandler;)Lcom/android/internal/telephony/cat/IconLoader;
    .locals 0

    .line 812
    new-instance p0, Lcom/android/internal/telephony/cat/IconLoader;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/cat/IconLoader;-><init>(Landroid/os/Looper;Lcom/android/internal/telephony/uicc/IccFileHandler;)V

    return-object p0
.end method

.method public makeImsExternalCallTracker(Lcom/android/internal/telephony/imsphone/ImsPhone;)Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;
    .locals 1

    .line 520
    new-instance p0, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getMainExecutor()Ljava/util/concurrent/Executor;

    move-result-object v0

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;-><init>(Lcom/android/internal/telephony/imsphone/ImsPhone;Ljava/util/concurrent/Executor;)V

    return-object p0
.end method

.method public makeImsPhone(Landroid/content/Context;Lcom/android/internal/telephony/PhoneNotifier;Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/imsphone/ImsPhone;
    .locals 0

    .line 734
    new-instance p0, Lcom/android/internal/telephony/imsphone/ImsPhone;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/imsphone/ImsPhone;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/PhoneNotifier;Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeImsPhoneCallTracker(Lcom/android/internal/telephony/imsphone/ImsPhone;)Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;
    .locals 1

    .line 515
    new-instance p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;

    new-instance v0, Lcom/android/internal/telephony/TelephonyComponentFactory$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/TelephonyComponentFactory$$ExternalSyntheticLambda0;-><init>()V

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;-><init>(Lcom/android/internal/telephony/imsphone/ImsPhone;Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$ConnectorFactory;)V

    return-object p0
.end method

.method public makeImsSmsDispatcher(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;)Lcom/android/internal/telephony/ImsSmsDispatcher;
    .locals 1

    .line 448
    new-instance p0, Lcom/android/internal/telephony/ImsSmsDispatcher;

    new-instance v0, Lcom/android/internal/telephony/TelephonyComponentFactory$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/TelephonyComponentFactory$$ExternalSyntheticLambda1;-><init>()V

    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/ImsSmsDispatcher;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;Lcom/android/internal/telephony/ImsSmsDispatcher$FeatureConnectorFactory;)V

    return-object p0
.end method

.method public makeInboundSmsTracker(Landroid/content/Context;Landroid/database/Cursor;Z)Lcom/android/internal/telephony/InboundSmsTracker;
    .locals 0

    .line 433
    new-instance p0, Lcom/android/internal/telephony/InboundSmsTracker;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/InboundSmsTracker;-><init>(Landroid/content/Context;Landroid/database/Cursor;Z)V

    return-object p0
.end method

.method public makeInboundSmsTracker(Landroid/content/Context;[BJIZLjava/lang/String;Ljava/lang/String;IIIZLjava/lang/String;ZII)Lcom/android/internal/telephony/InboundSmsTracker;
    .locals 18

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move-wide/from16 v3, p3

    move/from16 v5, p5

    move/from16 v6, p6

    move-object/from16 v7, p7

    move-object/from16 v8, p8

    move/from16 v9, p9

    move/from16 v10, p10

    move/from16 v11, p11

    move/from16 v12, p12

    move-object/from16 v13, p13

    move/from16 v14, p14

    move/from16 v15, p15

    move/from16 v16, p16

    .line 423
    new-instance v17, Lcom/android/internal/telephony/InboundSmsTracker;

    move-object/from16 v0, v17

    invoke-direct/range {v0 .. v16}, Lcom/android/internal/telephony/InboundSmsTracker;-><init>(Landroid/content/Context;[BJIZLjava/lang/String;Ljava/lang/String;IIIZLjava/lang/String;ZII)V

    return-object v17
.end method

.method public makeInboundSmsTracker(Landroid/content/Context;[BJIZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZII)Lcom/android/internal/telephony/InboundSmsTracker;
    .locals 15

    .line 412
    new-instance v14, Lcom/android/internal/telephony/InboundSmsTracker;

    move-object v0, v14

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move-wide/from16 v3, p3

    move/from16 v5, p5

    move/from16 v6, p6

    move/from16 v7, p7

    move-object/from16 v8, p8

    move-object/from16 v9, p9

    move-object/from16 v10, p10

    move/from16 v11, p11

    move/from16 v12, p12

    move/from16 v13, p13

    invoke-direct/range {v0 .. v13}, Lcom/android/internal/telephony/InboundSmsTracker;-><init>(Landroid/content/Context;[BJIZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZII)V

    return-object v14
.end method

.method public makeLinkBandwidthEstimator(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/data/LinkBandwidthEstimator;
    .locals 1

    .line 642
    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/TelephonyFacade;)V

    return-object v0
.end method

.method public makeLocaleTracker(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/NitzStateMachine;Landroid/os/Looper;)Lcom/android/internal/telephony/LocaleTracker;
    .locals 0

    .line 563
    new-instance p0, Lcom/android/internal/telephony/LocaleTracker;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/LocaleTracker;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/NitzStateMachine;Landroid/os/Looper;)V

    return-object p0
.end method

.method public makeMultiSimSettingController(Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)Lcom/android/internal/telephony/MultiSimSettingController;
    .locals 0

    .line 739
    new-instance p0, Lcom/android/internal/telephony/MultiSimSettingController;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/MultiSimSettingController;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)V

    return-object p0
.end method

.method public makeNitzStateMachine(Lcom/android/internal/telephony/GsmCdmaPhone;)Lcom/android/internal/telephony/NitzStateMachine;
    .locals 0

    .line 358
    invoke-static {p1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->createInstance(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;

    move-result-object p0

    return-object p0
.end method

.method public makePhone(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/PhoneNotifier;IILcom/android/internal/telephony/TelephonyComponentFactory;)Lcom/android/internal/telephony/Phone;
    .locals 7

    .line 573
    new-instance p0, Lcom/android/internal/telephony/GsmCdmaPhone;

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move v4, p4

    move v5, p5

    move-object v6, p6

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/GsmCdmaPhone;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/PhoneNotifier;IILcom/android/internal/telephony/TelephonyComponentFactory;)V

    return-object p0
.end method

.method public makePhoneSwitcher(ILandroid/content/Context;Landroid/os/Looper;)Lcom/android/internal/telephony/data/PhoneSwitcher;
    .locals 0

    .line 583
    invoke-static {p1, p2, p3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->make(ILandroid/content/Context;Landroid/os/Looper;)Lcom/android/internal/telephony/data/PhoneSwitcher;

    move-result-object p0

    return-object p0
.end method

.method public makeProxyController(Landroid/content/Context;)Lcom/android/internal/telephony/ProxyController;
    .locals 0

    .line 635
    new-instance p0, Lcom/android/internal/telephony/ProxyController;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ProxyController;-><init>(Landroid/content/Context;)V

    return-object p0
.end method

.method public makeRil(Landroid/content/Context;IILjava/lang/Integer;)Lcom/android/internal/telephony/RIL;
    .locals 0

    .line 610
    new-instance p0, Lcom/android/internal/telephony/RIL;

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/RIL;-><init>(Landroid/content/Context;IILjava/lang/Integer;)V

    return-object p0
.end method

.method public makeRilMessageDecoder(Landroid/os/Handler;Lcom/android/internal/telephony/uicc/IccFileHandler;Landroid/content/Context;I)Lcom/android/internal/telephony/cat/RilMessageDecoder;
    .locals 0

    .line 797
    new-instance p0, Lcom/android/internal/telephony/cat/RilMessageDecoder;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/cat/RilMessageDecoder;-><init>(Landroid/os/Handler;Lcom/android/internal/telephony/uicc/IccFileHandler;Landroid/content/Context;)V

    return-object p0
.end method

.method public makeServiceStateTracker(Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/CommandsInterface;)Lcom/android/internal/telephony/ServiceStateTracker;
    .locals 0

    .line 342
    new-instance p0, Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ServiceStateTracker;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/CommandsInterface;)V

    return-object p0
.end method

.method public makeSignalStrengthController(Lcom/android/internal/telephony/GsmCdmaPhone;)Lcom/android/internal/telephony/SignalStrengthController;
    .locals 0

    .line 617
    new-instance p0, Lcom/android/internal/telephony/SignalStrengthController;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeSimActivationTracker(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/SimActivationTracker;
    .locals 0

    .line 362
    new-instance p0, Lcom/android/internal/telephony/SimActivationTracker;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SimActivationTracker;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeSmartDataSwitchAssistant(Landroid/content/Context;[Lcom/android/internal/telephony/Phone;)V
    .locals 0

    return-void
.end method

.method public makeSmsBroadcastUndelivered(Landroid/content/Context;Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;)V
    .locals 0

    .line 474
    invoke-static {p1, p2, p3}, Lcom/android/internal/telephony/SmsBroadcastUndelivered;->initialize(Landroid/content/Context;Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;)V

    return-void
.end method

.method public makeSmsDispatchersController(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/SmsUsageMonitor;)Lcom/android/internal/telephony/SmsDispatchersController;
    .locals 0

    .line 510
    new-instance p0, Lcom/android/internal/telephony/SmsDispatchersController;

    iget-object p2, p1, Lcom/android/internal/telephony/Phone;->mSmsStorageMonitor:Lcom/android/internal/telephony/SmsStorageMonitor;

    iget-object p3, p1, Lcom/android/internal/telephony/Phone;->mSmsUsageMonitor:Lcom/android/internal/telephony/SmsUsageMonitor;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/SmsDispatchersController;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/SmsUsageMonitor;)V

    return-object p0
.end method

.method public makeSmsHeader()Lcom/android/internal/telephony/SmsHeader;
    .locals 0

    .line 440
    new-instance p0, Lcom/android/internal/telephony/SmsHeader;

    invoke-direct {p0}, Lcom/android/internal/telephony/SmsHeader;-><init>()V

    return-object p0
.end method

.method public makeSmsStorageMonitor(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/SmsStorageMonitor;
    .locals 0

    .line 334
    new-instance p0, Lcom/android/internal/telephony/SmsStorageMonitor;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SmsStorageMonitor;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeSmsUsageMonitor(Landroid/content/Context;)Lcom/android/internal/telephony/SmsUsageMonitor;
    .locals 0

    .line 338
    new-instance p0, Lcom/android/internal/telephony/SmsUsageMonitor;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SmsUsageMonitor;-><init>(Landroid/content/Context;)V

    return-object p0
.end method

.method public makeSubscriptionInfoUpdater(Landroid/os/Looper;Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)Lcom/android/internal/telephony/SubscriptionInfoUpdater;
    .locals 0

    .line 622
    new-instance p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater;

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;-><init>(Landroid/os/Looper;Landroid/content/Context;Lcom/android/internal/telephony/SubscriptionController;)V

    return-object p0
.end method

.method public makeSuppServManager(Landroid/content/Context;[Lcom/android/internal/telephony/Phone;)V
    .locals 0

    return-void
.end method

.method public makeTelephonyNetworkFactories(Landroid/os/Looper;Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/data/TelephonyNetworkFactory;
    .locals 0

    .line 747
    new-instance p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;-><init>(Landroid/os/Looper;Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeTransportManager(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/dataconnection/TransportManager;
    .locals 0

    .line 535
    new-instance p0, Lcom/android/internal/telephony/dataconnection/TransportManager;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/TransportManager;-><init>(Lcom/android/internal/telephony/Phone;)V

    return-object p0
.end method

.method public makeUiccController(Landroid/content/Context;)Lcom/android/internal/telephony/uicc/UiccController;
    .locals 0

    .line 720
    new-instance p0, Lcom/android/internal/telephony/uicc/UiccController;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccController;-><init>(Landroid/content/Context;)V

    return-object p0
.end method

.method public makeUiccProfile(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/IccCardStatus;ILcom/android/internal/telephony/uicc/UiccCard;Ljava/lang/Object;)Lcom/android/internal/telephony/uicc/UiccProfile;
    .locals 7

    .line 394
    new-instance p0, Lcom/android/internal/telephony/uicc/UiccProfile;

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move v4, p4

    move-object v5, p5

    move-object v6, p6

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/uicc/UiccProfile;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/IccCardStatus;ILcom/android/internal/telephony/uicc/UiccCard;Ljava/lang/Object;)V

    return-object p0
.end method

.method public makeUiccSlot(Landroid/content/Context;Z)Lcom/android/internal/telephony/uicc/UiccSlot;
    .locals 0

    .line 727
    new-instance p0, Lcom/android/internal/telephony/uicc/UiccSlot;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/uicc/UiccSlot;-><init>(Landroid/content/Context;Z)V

    return-object p0
.end method

.method public makeWapPushOverSms(Landroid/content/Context;)Lcom/android/internal/telephony/WapPushOverSms;
    .locals 0

    .line 478
    new-instance p0, Lcom/android/internal/telephony/WapPushOverSms;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/WapPushOverSms;-><init>(Landroid/content/Context;)V

    return-object p0
.end method

.method public makeWorldPhoneManager()V
    .locals 0

    return-void
.end method

.method public makeWspTypeDecoder([B)Lcom/android/internal/telephony/WspTypeDecoder;
    .locals 0

    .line 402
    new-instance p0, Lcom/android/internal/telephony/WspTypeDecoder;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/WspTypeDecoder;-><init>([B)V

    return-object p0
.end method
