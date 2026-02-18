.class public Lcom/android/internal/telephony/data/PhoneSwitcher;
.super Landroid/os/Handler;
.source "PhoneSwitcher.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;,
        Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneSwitcherNetworkRequestListener;,
        Lcom/android/internal/telephony/data/PhoneSwitcher$ImsRegTechProvider;,
        Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;,
        Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;
    }
.end annotation


# static fields
.field public static DEFAULT_DATA_OVERRIDE_TIMEOUT_MS:I = 0x1388
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final DEFAULT_EMERGENCY_PHONE_ID:I = 0x0

.field private static final DEFAULT_NETWORK_CHANGE_TIMEOUT_MS:I = 0x1388

.field private static final DEFAULT_VALIDATION_EXPIRATION_TIME:I = 0x7d0

.field public static ECBM_DEFAULT_DATA_SWITCH_BASE_TIME_MS:I = 0x1388
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final EVALUATION_REASON_RADIO_ON:Ljava/lang/String; = "EVENT_RADIO_ON"

.field public static final EVENT_DATA_ENABLED_CHANGED:I = 0x72
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final EVENT_EMERGENCY_TOGGLE:I = 0x69

.field public static final EVENT_IMS_RADIO_TECH_CHANGED:I = 0x78
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final EVENT_MODEM_COMMAND_DONE:I = 0x70

.field protected static final EVENT_MODEM_COMMAND_RETRY:I = 0x71

.field public static final EVENT_MULTI_SIM_CONFIG_CHANGED:I = 0x75
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final EVENT_NETWORK_AVAILABLE:I = 0x76

.field private static final EVENT_NETWORK_VALIDATION_DONE:I = 0x6e

.field private static final EVENT_OPPT_DATA_SUB_CHANGED:I = 0x6b

.field private static final EVENT_OVERRIDE_DDS_FOR_EMERGENCY:I = 0x73

.field public static final EVENT_PRECISE_CALL_STATE_CHANGED:I = 0x6d
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final EVENT_PRIMARY_DATA_SUB_CHANGED:I = 0x65

.field private static final EVENT_PROCESS_SIM_STATE_CHANGE:I = 0x77

.field private static final EVENT_RADIO_CAPABILITY_CHANGED:I = 0x6a

.field private static final EVENT_RADIO_ON:I = 0x6c

.field private static final EVENT_RELEASE_NETWORK:I = 0x68

.field private static final EVENT_REMOVE_DDS_EMERGENCY_OVERRIDE:I = 0x74

.field private static final EVENT_REMOVE_DEFAULT_NETWORK_CHANGE_CALLBACK:I = 0x6f

.field private static final EVENT_REQUEST_NETWORK:I = 0x67

.field protected static final EVENT_SUBSCRIPTION_CHANGED:I = 0x66

.field protected static final HAL_COMMAND_ALLOW_DATA:I = 0x1

.field protected static final HAL_COMMAND_PREFERRED_DATA:I = 0x2

.field protected static final HAL_COMMAND_UNKNOWN:I = 0x0

.field private static final LOG_TAG:Ljava/lang/String; = "PhoneSwitcher"

.field private static final MAX_LOCAL_LOG_LINES:I = 0x100

.field protected static final MODEM_COMMAND_RETRY_PERIOD_MS:I = 0x1388

.field protected static final REQUESTS_CHANGED:Z = true

.field protected static final REQUESTS_UNCHANGED:Z = false

.field protected static final VDBG:Z = false

.field protected static sPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;


# instance fields
.field protected mActiveModemCount:I

.field protected final mActivePhoneRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mConnectivityManager:Landroid/net/ConnectivityManager;

.field protected final mContext:Landroid/content/Context;

.field protected mCurrentDdsSwitchFailure:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/CommandException$Error;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mDataSettingsManagerCallbacks:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;",
            ">;"
        }
    .end annotation
.end field

.field private final mDefaultDataChangedReceiver:Landroid/content/BroadcastReceiver;

.field private final mDefaultNetworkCallback:Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;

.field protected mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

.field protected mHalCommandToUse:I

.field private mHasRegisteredDefaultNetworkChangeCallback:Ljava/lang/Boolean;

.field public mImsRegTechProvider:Lcom/android/internal/telephony/data/PhoneSwitcher$ImsRegTechProvider;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private mImsRegistrationTech:I

.field private mIsRegisteredForImsRadioTechChange:Z

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field protected mMaxDataAttachModemCount:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

.field private mOpptDataSubId:I

.field private mPendingSwitchNeedValidation:Z

.field private mPendingSwitchSubId:I

.field protected mPhoneIdInVoiceCall:I

.field protected mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

.field protected mPhoneSubscriptions:[I

.field protected mPreferredDataPhoneId:I
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field protected mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

.field protected mPrimaryDataSubId:I

.field protected final mPrioritizedDcRequests:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/dataconnection/DcRequest;",
            ">;"
        }
    .end annotation
.end field

.field protected mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

.field private mRegistrationCallback:Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

.field private mSetOpptSubCallback:Lcom/android/internal/telephony/ISetOpportunisticDataCallback;

.field private mSimStateIntentReceiver:Landroid/content/BroadcastReceiver;

.field protected final mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

.field private final mSubscriptionsChangedListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

.field public final mValidationCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field protected final mValidator:Lcom/android/internal/telephony/data/CellularNetworkValidator;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$CevX72NUGvpYzRLh7530jKKPhlo(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->lambda$onMultiSimConfigChanged$2(Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$Pb9nv3HGJckbfXl2lo6Eb__yX1M(Landroid/content/Context;I)I
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->lambda$new$0(Landroid/content/Context;I)I

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$arhEJjJkHI5z9Shae-2IsmJNS14(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->lambda$new$1(Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmImsRegistrationTech(Lcom/android/internal/telephony/data/PhoneSwitcher;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mImsRegistrationTech:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmImsRegistrationTech(Lcom/android/internal/telephony/data/PhoneSwitcher;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mImsRegistrationTech:I

    return-void
.end method

.method static bridge synthetic -$$Nest$mevaluateIfDataSwitchIsNeeded(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->evaluateIfDataSwitchIsNeeded(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mlogDataSwitchEvent(Lcom/android/internal/telephony/data/PhoneSwitcher;III)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->logDataSwitchEvent(III)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mremoveDefaultNetworkChangeCallback(Lcom/android/internal/telephony/data/PhoneSwitcher;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->removeDefaultNetworkChangeCallback()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>(ILandroid/content/Context;Landroid/os/Looper;)V
    .locals 6
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 483
    invoke-direct {p0, p3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 189
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    .line 190
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    const/4 v0, -0x1

    .line 200
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchSubId:I

    .line 202
    new-instance v1, Lcom/android/internal/telephony/data/PhoneSwitcher$1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$1;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    iput-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidationCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;

    .line 231
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    const v1, 0x7fffffff

    .line 235
    iput v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    .line 239
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    .line 241
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    .line 251
    new-instance v1, Lcom/android/internal/telephony/data/PhoneSwitcher$2;

    invoke-direct {v1, p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher$2;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;I)V

    iput-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    const/4 v1, 0x0

    .line 315
    iput v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mHalCommandToUse:I

    .line 324
    sget-object v2, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    iput-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mHasRegisteredDefaultNetworkChangeCallback:Ljava/lang/Boolean;

    .line 327
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mImsRegistrationTech:I

    .line 332
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDataSettingsManagerCallbacks:Ljava/util/Map;

    .line 354
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$3;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mRegistrationCallback:Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

    .line 374
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;

    const/4 v2, 0x0

    invoke-direct {v0, p0, v2}, Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback-IA;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDefaultNetworkCallback:Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;

    .line 385
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda0;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mImsRegTechProvider:Lcom/android/internal/telephony/data/PhoneSwitcher$ImsRegTechProvider;

    .line 590
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$5;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$5;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDefaultDataChangedReceiver:Landroid/content/BroadcastReceiver;

    .line 598
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$6;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$6;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSimStateIntentReceiver:Landroid/content/BroadcastReceiver;

    .line 632
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$7;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$7;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionsChangedListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

    .line 484
    iput-object p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    .line 485
    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getTm()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getActiveModemCount()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    .line 486
    new-array v3, v0, [I

    iput-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    .line 487
    new-array v0, v0, [Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    .line 488
    iput p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    .line 489
    new-instance p1, Lcom/android/internal/telephony/LocalLog;

    const/16 v0, 0x100

    invoke-direct {p1, v0}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 491
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    .line 492
    invoke-static {}, Lcom/android/internal/telephony/RadioConfig;->getInstance()Lcom/android/internal/telephony/RadioConfig;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    .line 493
    invoke-static {}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->getInstance()Lcom/android/internal/telephony/data/CellularNetworkValidator;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidator:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    .line 495
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    .line 496
    new-instance p1, Landroid/content/IntentFilter;

    invoke-direct {p1}, Landroid/content/IntentFilter;-><init>()V

    const-string v0, "android.telephony.action.SIM_APPLICATION_STATE_CHANGED"

    .line 497
    invoke-virtual {p1, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 498
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSimStateIntentReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p2, v0, p1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 500
    new-instance p1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {p1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActivePhoneRegistrants:Lcom/android/internal/telephony/RegistrantList;

    move p1, v1

    .line 501
    :goto_0
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge p1, v0, :cond_3

    .line 502
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    new-instance v3, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    invoke-direct {v3}, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;-><init>()V

    aput-object v3, v0, p1

    .line 503
    invoke-static {p1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    if-eqz v0, :cond_2

    const/16 v3, 0x69

    .line 505
    invoke-virtual {v0, p0, v3, v2}, Lcom/android/internal/telephony/Phone;->registerForEmergencyCallToggle(Landroid/os/Handler;ILjava/lang/Object;)V

    const/16 v3, 0x6d

    .line 508
    invoke-virtual {v0, p0, v3, v2}, Lcom/android/internal/telephony/Phone;->registerForPreciseCallStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 510
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v4

    if-eqz v4, :cond_0

    .line 511
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v4

    invoke-virtual {v4, p0, v3, v2}, Lcom/android/internal/telephony/Phone;->registerForPreciseCallStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 514
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 515
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDataSettingsManagerCallbacks:Ljava/util/Map;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda1;

    invoke-direct {v5, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    invoke-interface {v3, v4, v5}, Ljava/util/Map;->computeIfAbsent(Ljava/lang/Object;Ljava/util/function/Function;)Ljava/lang/Object;

    .line 523
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v3

    iget-object v4, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDataSettingsManagerCallbacks:Ljava/util/Map;

    .line 524
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {v4, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

    .line 523
    invoke-virtual {v3, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->registerCallback(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    goto :goto_1

    .line 526
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v0

    const/16 v3, 0x72

    invoke-virtual {v0, p0, v3, v2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->registerForDataEnabledChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 530
    :goto_1
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerForImsRadioTechChange(Landroid/content/Context;I)V

    .line 532
    :cond_2
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 533
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    :cond_3
    if-lez v0, :cond_4

    .line 537
    invoke-static {v1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x6c

    invoke-interface {p1, p0, v0, v2}, Lcom/android/internal/telephony/CommandsInterface;->registerForOn(Landroid/os/Handler;ILjava/lang/Object;)V

    :cond_4
    const-string/jumbo p1, "telephony_registry"

    .line 541
    invoke-virtual {p2, p1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/TelephonyRegistryManager;

    .line 542
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionsChangedListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

    .line 543
    invoke-virtual {v0}, Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;->getHandlerExecutor()Lcom/android/internal/telephony/util/HandlerExecutor;

    move-result-object v3

    .line 542
    invoke-virtual {p1, v0, v3}, Landroid/telephony/TelephonyRegistryManager;->addOnSubscriptionsChangedListener(Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;Ljava/util/concurrent/Executor;)V

    const-string p1, "connectivity"

    .line 546
    invoke-virtual {p2, p1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/net/ConnectivityManager;

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mConnectivityManager:Landroid/net/ConnectivityManager;

    .line 548
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDefaultDataChangedReceiver:Landroid/content/BroadcastReceiver;

    new-instance v3, Landroid/content/IntentFilter;

    const-string v4, "android.intent.action.ACTION_DEFAULT_DATA_SUBSCRIPTION_CHANGED"

    invoke-direct {v3, v4}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v0, v3}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    const/16 p1, 0x75

    .line 551
    invoke-static {p0, p1, v2}, Lcom/android/internal/telephony/PhoneConfigurationManager;->registerForMultiSimConfigChange(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 554
    new-instance p1, Landroid/net/NetworkCapabilities$Builder;

    invoke-direct {p1}, Landroid/net/NetworkCapabilities$Builder;-><init>()V

    .line 555
    invoke-virtual {p1, v1}, Landroid/net/NetworkCapabilities$Builder;->addTransportType(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    .line 556
    invoke-virtual {p1, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/4 v0, 0x1

    .line 557
    invoke-virtual {p1, v0}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/4 v1, 0x2

    .line 558
    invoke-virtual {p1, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/4 v2, 0x3

    .line 559
    invoke-virtual {p1, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/4 v3, 0x4

    .line 560
    invoke-virtual {p1, v3}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/4 v4, 0x5

    .line 561
    invoke-virtual {p1, v4}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/4 v5, 0x7

    .line 562
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0x8

    .line 563
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0x21

    .line 564
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0x9

    .line 565
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0x1d

    .line 566
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0xa

    .line 567
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0xd

    .line 568
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0xc

    .line 569
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0x17

    .line 570
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0x22

    .line 571
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    const/16 v5, 0x23

    .line 572
    invoke-virtual {p1, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    .line 573
    invoke-virtual {p1, v0}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    .line 574
    invoke-virtual {p1, v1}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    .line 575
    invoke-virtual {p1, v2}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    .line 576
    invoke-virtual {p1, v3}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    .line 577
    invoke-virtual {p1, v4}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    new-instance v0, Landroid/net/MatchAllNetworkSpecifier;

    invoke-direct {v0}, Landroid/net/MatchAllNetworkSpecifier;-><init>()V

    .line 578
    invoke-virtual {p1, v0}, Landroid/net/NetworkCapabilities$Builder;->setNetworkSpecifier(Landroid/net/NetworkSpecifier;)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p1

    .line 580
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneSwitcherNetworkRequestListener;

    .line 581
    invoke-virtual {p1}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object p1

    invoke-direct {v0, p3, p2, p1, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneSwitcherNetworkRequestListener;-><init>(Landroid/os/Looper;Landroid/content/Context;Landroid/net/NetworkCapabilities;Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    .line 583
    invoke-virtual {v0}, Lcom/android/internal/telephony/NetworkFactory;->registerIgnoringScore()V

    .line 585
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->updateHalCommandToUse()V

    const-string p1, "PhoneSwitcher started"

    .line 587
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    return-void
.end method

.method private collectReleaseNetworkMetrics(Landroid/net/NetworkRequest;)V
    .locals 1

    .line 1038
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    const/4 v0, 0x1

    if-le p0, v0, :cond_0

    const/4 p0, 0x0

    invoke-virtual {p1, p0}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 1040
    new-instance p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;

    invoke-direct {p0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;-><init>()V

    const/4 p1, 0x2

    .line 1041
    iput p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;->apn:I

    .line 1042
    iput p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;->state:I

    .line 1043
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeOnDemandDataSwitch(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;)V

    :cond_0
    return-void
.end method

.method private collectRequestNetworkMetrics(Landroid/net/NetworkRequest;)V
    .locals 1

    .line 1026
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    const/4 v0, 0x1

    if-le p0, v0, :cond_0

    const/4 p0, 0x0

    invoke-virtual {p1, p0}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 1028
    new-instance p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;

    invoke-direct {p0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;-><init>()V

    const/4 p1, 0x2

    .line 1029
    iput p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;->apn:I

    .line 1030
    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;->state:I

    .line 1031
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeOnDemandDataSwitch(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;)V

    :cond_0
    return-void
.end method

.method private confirmSwitch(IZ)V
    .locals 3

    .line 1586
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "confirmSwitch: subId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    if-eqz p2, :cond_0

    const-string v2, " confirmed."

    goto :goto_0

    :cond_0
    const-string v2, " cancelled."

    :goto_0
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1588
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1589
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " is no longer active"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/4 p1, 0x2

    goto :goto_2

    :cond_1
    if-nez p2, :cond_2

    const/4 p1, 0x1

    goto :goto_2

    .line 1594
    :cond_2
    iget-object p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {p2, p1}, Lcom/android/internal/telephony/SubscriptionController;->isOpportunistic(I)Z

    move-result p2

    if-eqz p2, :cond_3

    .line 1595
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->setOpportunisticSubscriptionInternal(I)V

    goto :goto_1

    :cond_3
    const p1, 0x7fffffff

    .line 1598
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->setOpportunisticSubscriptionInternal(I)V

    :goto_1
    const/4 p1, 0x0

    .line 1604
    :goto_2
    iget-object p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSetOpptSubCallback:Lcom/android/internal/telephony/ISetOpportunisticDataCallback;

    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendSetOpptCallbackHelper(Lcom/android/internal/telephony/ISetOpportunisticDataCallback;I)V

    const/4 p1, 0x0

    .line 1605
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSetOpptSubCallback:Lcom/android/internal/telephony/ISetOpportunisticDataCallback;

    const/4 p1, -0x1

    .line 1606
    iput p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchSubId:I

    return-void
.end method

.method private createApnRepository(Landroid/net/NetworkRequest;)Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;
    .locals 1

    .line 992
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->phoneIdForRequest(Landroid/net/NetworkRequest;)I

    move-result p1

    .line 993
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/SubscriptionController;->getSubIdUsingPhoneId(I)I

    move-result p1

    .line 994
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    const-string v0, "carrier_config"

    .line 995
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/CarrierConfigManager;

    if-eqz p0, :cond_0

    .line 999
    invoke-virtual {p0, p1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 1003
    :goto_0
    new-instance p1, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;-><init>(Landroid/os/PersistableBundle;)V

    return-object p1
.end method

.method private evaluateIfDataSwitchIsNeeded(Ljava/lang/String;)V
    .locals 2

    const/4 v0, 0x0

    .line 472
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 473
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {p1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result p1

    const/4 v0, 0x1

    const/4 v1, 0x2

    invoke-direct {p0, p1, v0, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->logDataSwitchEvent(III)V

    .line 476
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {p1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result p1

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerDefaultNetworkChangeCallback(II)V

    :cond_0
    return-void
.end method

.method public static getInstance()Lcom/android/internal/telephony/data/PhoneSwitcher;
    .locals 1

    .line 393
    sget-object v0, Lcom/android/internal/telephony/data/PhoneSwitcher;->sPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

    return-object v0
.end method

.method private getTm()Landroid/telephony/TelephonyManager;
    .locals 1

    .line 1048
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    const-string v0, "phone"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/TelephonyManager;

    return-object p0
.end method

.method private getValidationTimeout(IZ)J
    .locals 2

    const-wide/16 v0, 0x7d0

    if-nez p2, :cond_0

    return-wide v0

    .line 1555
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    const-string p2, "carrier_config"

    .line 1556
    invoke-virtual {p0, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/CarrierConfigManager;

    if-eqz p0, :cond_1

    .line 1558
    invoke-virtual {p0, p1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_1

    const-string p1, "data_switch_validation_timeout_long"

    .line 1560
    invoke-virtual {p0, p1}, Landroid/os/PersistableBundle;->getLong(Ljava/lang/String;)J

    move-result-wide v0

    :cond_1
    return-wide v0
.end method

.method private isAnyVoiceCallActiveOnDevice()Z
    .locals 1

    .line 1792
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    const/4 v0, -0x1

    if-eq p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isInEmergencyCallbackMode()Z
    .locals 6

    .line 911
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_3

    aget-object v3, p0, v2

    if-nez v3, :cond_0

    goto :goto_1

    .line 913
    :cond_0
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v4

    const/4 v5, 0x1

    if-eqz v4, :cond_1

    return v5

    .line 914
    :cond_1
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v3

    if-eqz v3, :cond_2

    .line 915
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v3

    if-eqz v3, :cond_2

    return v5

    :cond_2
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_3
    return v1
.end method

.method private isPhoneIdValidForRetry(I)Z
    .locals 4

    .line 1835
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    .line 1836
    invoke-virtual {v0}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v1

    .line 1835
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->getPhoneId(I)I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, -0x1

    if-eq v0, v2, :cond_0

    if-ne v0, p1, :cond_0

    return v1

    .line 1840
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    const/4 v2, 0x0

    if-eqz v0, :cond_3

    .line 1841
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    return v2

    .line 1842
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_6

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 1843
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->phoneIdForRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result v3

    if-ne v3, p1, :cond_2

    return v1

    .line 1849
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-nez v0, :cond_4

    return v2

    .line 1852
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_5
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_6

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/dataconnection/DcRequest;

    if-eqz v3, :cond_5

    .line 1854
    iget-object v3, v3, Lcom/android/internal/telephony/dataconnection/DcRequest;->networkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->phoneIdForRequest(Landroid/net/NetworkRequest;)I

    move-result v3

    if-ne v3, p1, :cond_5

    return v1

    :cond_6
    return v2
.end method

.method private isSimApplicationReady(I)Z
    .locals 4

    .line 614
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidSlotIndex(I)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 618
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    .line 620
    invoke-virtual {v2}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    .line 619
    invoke-virtual {v0, p1, v2, v3}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubscriptionInfoForSimSlotIndex(ILjava/lang/String;Ljava/lang/String;)Landroid/telephony/SubscriptionInfo;

    move-result-object v0

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    .line 621
    invoke-virtual {v0}, Landroid/telephony/SubscriptionInfo;->areUiccApplicationsEnabled()Z

    move-result v0

    if-eqz v0, :cond_1

    move v0, v2

    goto :goto_0

    :cond_1
    move v0, v1

    .line 623
    :goto_0
    invoke-static {p1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getIccCard()Lcom/android/internal/telephony/IccCard;

    move-result-object v3

    .line 624
    invoke-virtual {v3}, Lcom/android/internal/telephony/IccCard;->isEmptyProfile()Z

    move-result v3

    if-nez v3, :cond_2

    if-eqz v0, :cond_2

    .line 625
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isSimApplicationReady: SIM is ready for slotIndex: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    return v2

    :cond_2
    return v1
.end method

.method private static synthetic lambda$new$0(Landroid/content/Context;I)I
    .locals 0

    .line 387
    invoke-static {p0, p1}, Lcom/android/ims/ImsManager;->getInstance(Landroid/content/Context;I)Lcom/android/ims/ImsManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/ims/ImsManager;->getRegistrationTech()I

    move-result p0

    return p0
.end method

.method private synthetic lambda$new$1(Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
    .locals 1

    .line 516
    new-instance p1, Lcom/android/internal/telephony/data/PhoneSwitcher$4;

    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher$4;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/util/concurrent/Executor;)V

    return-object p1
.end method

.method private synthetic lambda$onMultiSimConfigChanged$2(Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
    .locals 1

    .line 889
    new-instance p1, Lcom/android/internal/telephony/data/PhoneSwitcher$8;

    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher$8;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/util/concurrent/Executor;)V

    return-object p1
.end method

.method private logDataSwitchEvent(III)V
    .locals 2

    .line 1728
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Data switch event. subId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->switchStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1729
    invoke-static {p3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->switchReasonToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1728
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1730
    new-instance p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$DataSwitch;

    invoke-direct {p0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$DataSwitch;-><init>()V

    .line 1731
    iput p2, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$DataSwitch;->state:I

    .line 1732
    iput p3, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$DataSwitch;->reason:I

    .line 1733
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object p2

    invoke-virtual {p2, p1, p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeDataSwitch(ILcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$DataSwitch;)V

    return-void
.end method

.method public static make(ILandroid/content/Context;Landroid/os/Looper;)Lcom/android/internal/telephony/data/PhoneSwitcher;
    .locals 1

    .line 400
    sget-object v0, Lcom/android/internal/telephony/data/PhoneSwitcher;->sPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

    if-nez v0, :cond_0

    .line 401
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-direct {v0, p0, p1, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;-><init>(ILandroid/content/Context;Landroid/os/Looper;)V

    sput-object v0, Lcom/android/internal/telephony/data/PhoneSwitcher;->sPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

    .line 402
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateActiveDataSubIdCaches()V

    .line 405
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->sPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

    return-object p0
.end method

.method private declared-synchronized onMultiSimConfigChanged(I)V
    .locals 4

    monitor-enter p0

    .line 861
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ne v0, p1, :cond_0

    monitor-exit p0

    return-void

    .line 863
    :cond_0
    :try_start_1
    iput p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    .line 865
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    invoke-static {v1, p1}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    .line 866
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    invoke-static {p1, v1}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    add-int/lit8 p1, v0, -0x1

    .line 869
    :goto_0
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-lt p1, v1, :cond_1

    .line 870
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {v1, p1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    add-int/lit8 p1, p1, -0x1

    goto :goto_0

    .line 874
    :cond_1
    :goto_1
    iget p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v0, p1, :cond_5

    .line 875
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    new-instance v1, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;-><init>()V

    aput-object v1, p1, v0

    .line 876
    invoke-static {v0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    if-nez p1, :cond_2

    goto :goto_3

    :cond_2
    const/16 v1, 0x69

    const/4 v2, 0x0

    .line 879
    invoke-virtual {p1, p0, v1, v2}, Lcom/android/internal/telephony/Phone;->registerForEmergencyCallToggle(Landroid/os/Handler;ILjava/lang/Object;)V

    const/16 v1, 0x6d

    .line 881
    invoke-virtual {p1, p0, v1, v2}, Lcom/android/internal/telephony/Phone;->registerForPreciseCallStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 882
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v3

    if-eqz v3, :cond_3

    .line 883
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v3

    invoke-virtual {v3, p0, v1, v2}, Lcom/android/internal/telephony/Phone;->registerForPreciseCallStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 887
    :cond_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v1

    if-eqz v1, :cond_4

    .line 888
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDataSettingsManagerCallbacks:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda2;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->computeIfAbsent(Ljava/lang/Object;Ljava/util/function/Function;)Ljava/lang/Object;

    .line 897
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDataSettingsManagerCallbacks:Ljava/util/Map;

    .line 898
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v2, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

    .line 897
    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->registerCallback(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    goto :goto_2

    .line 900
    :cond_4
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object p1

    const/16 v1, 0x72

    invoke-virtual {p1, p0, v1, v2}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->registerForDataEnabledChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 904
    :goto_2
    new-instance p1, Ljava/util/HashSet;

    invoke-direct {p1}, Ljava/util/HashSet;-><init>()V

    .line 905
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {v1, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 906
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerForImsRadioTechChange(Landroid/content/Context;I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 908
    :cond_5
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private onNetworkAvailable(ILandroid/net/Network;)V
    .locals 1

    .line 1610
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onNetworkAvailable: on subId "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1613
    iget p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchSubId:I

    const/4 v0, -0x1

    if-eq p2, v0, :cond_1

    if-ne p2, p1, :cond_1

    iget-boolean p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchNeedValidation:Z

    if-eqz p2, :cond_0

    goto :goto_0

    :cond_0
    const/4 p2, 0x1

    .line 1617
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->confirmSwitch(IZ)V

    :cond_1
    :goto_0
    return-void
.end method

.method private onPhoneCapabilityChanged(Landroid/telephony/PhoneCapability;)V
    .locals 0

    .line 1756
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onPhoneCapabilityChangedInternal(Landroid/telephony/PhoneCapability;)V

    return-void
.end method

.method private onPhoneCapabilityChangedInternal(Landroid/telephony/PhoneCapability;)V
    .locals 1

    .line 1290
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object p1

    .line 1291
    invoke-virtual {p1}, Landroid/telephony/TelephonyManager;->getNumberOfModemsWithSimultaneousDataConnections()I

    move-result p1

    .line 1292
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    if-eq v0, p1, :cond_0

    .line 1293
    iput p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    .line 1294
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Max active phones changed to "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/4 p1, 0x0

    const-string v0, "phoneCfgChanged"

    .line 1295
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    :cond_0
    return-void
.end method

.method private onReleaseNetwork(Landroid/net/NetworkRequest;)V
    .locals 4

    .line 971
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    const-string v1, "netReleased"

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    .line 972
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 973
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v3

    invoke-direct {v0, p1, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    .line 974
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v3, v0}, Ljava/util/LinkedList;->remove(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 975
    invoke-virtual {p0, v2, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    .line 976
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->collectReleaseNetworkMetrics(Landroid/net/NetworkRequest;)V

    :cond_0
    return-void

    .line 981
    :cond_1
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->createApnRepository(Landroid/net/NetworkRequest;)Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/dataconnection/DcRequest;->create(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;)Lcom/android/internal/telephony/dataconnection/DcRequest;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 983
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 984
    invoke-virtual {p0, v2, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    .line 985
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->collectReleaseNetworkMetrics(Landroid/net/NetworkRequest;)V

    :cond_2
    return-void
.end method

.method private onRequestNetwork(Landroid/net/NetworkRequest;)V
    .locals 4

    .line 948
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    const-string v1, "netRequest"

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    .line 949
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 950
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v3

    invoke-direct {v0, p1, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    .line 951
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p1, v0}, Ljava/util/LinkedList;->contains(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 952
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    .line 953
    invoke-virtual {p0, v2, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    :cond_0
    return-void

    .line 958
    :cond_1
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->createApnRepository(Landroid/net/NetworkRequest;)Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/dataconnection/DcRequest;->create(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;)Lcom/android/internal/telephony/dataconnection/DcRequest;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 960
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 961
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->collectRequestNetworkMetrics(Landroid/net/NetworkRequest;)V

    .line 962
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 963
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    invoke-static {p1}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 964
    invoke-virtual {p0, v2, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    :cond_2
    return-void
.end method

.method private onValidationDone(IZ)V
    .locals 2

    .line 1621
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onValidationDone: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p2, :cond_0

    const-string v1, "passed"

    goto :goto_0

    :cond_0
    const-string v1, "failed"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " on subId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1622
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchSubId:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_4

    if-eq v0, p1, :cond_1

    goto :goto_3

    :cond_1
    if-nez p2, :cond_3

    .line 1626
    iget-boolean p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchNeedValidation:Z

    if-nez p2, :cond_2

    goto :goto_1

    :cond_2
    const/4 p2, 0x0

    goto :goto_2

    :cond_3
    :goto_1
    const/4 p2, 0x1

    :goto_2
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->confirmSwitch(IZ)V

    :cond_4
    :goto_3
    return-void
.end method

.method private phoneIdForRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I
    .locals 0

    .line 1302
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->phoneIdForRequest(Landroid/net/NetworkRequest;)I

    move-result p0

    return p0
.end method

.method private registerDefaultNetworkChangeCallback(II)V
    .locals 2

    .line 1015
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDefaultNetworkCallback:Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;

    iput p1, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;->mExpectedSubId:I

    .line 1016
    iput p2, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;->mSwitchReason:I

    .line 1017
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mConnectivityManager:Landroid/net/ConnectivityManager;

    invoke-virtual {p1, v0, p0}, Landroid/net/ConnectivityManager;->registerDefaultNetworkCallback(Landroid/net/ConnectivityManager$NetworkCallback;Landroid/os/Handler;)V

    const/16 p1, 0x6f

    .line 1019
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v0, 0x1388

    .line 1018
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method private registerForImsRadioTechChange()V
    .locals 2

    .line 464
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mIsRegisteredForImsRadioTechChange:Z

    if-nez v0, :cond_0

    const/4 v0, 0x0

    .line 465
    :goto_0
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v0, v1, :cond_0

    .line 466
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerForImsRadioTechChange(Landroid/content/Context;I)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private registerForImsRadioTechChange(Landroid/content/Context;I)V
    .locals 1

    .line 454
    :try_start_0
    invoke-static {p1, p2}, Lcom/android/ims/ImsManager;->getInstance(Landroid/content/Context;I)Lcom/android/ims/ImsManager;

    move-result-object p1

    iget-object p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mRegistrationCallback:Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V

    invoke-virtual {p1, p2, v0}, Lcom/android/ims/ImsManager;->addRegistrationCallback(Landroid/telephony/ims/RegistrationManager$RegistrationCallback;Ljava/util/concurrent/Executor;)V

    const/4 p1, 0x1

    .line 456
    iput-boolean p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mIsRegisteredForImsRadioTechChange:Z
    :try_end_0
    .catch Lcom/android/ims/ImsException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 p1, 0x0

    .line 458
    iput-boolean p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mIsRegisteredForImsRadioTechChange:Z

    :goto_0
    return-void
.end method

.method private removeDefaultNetworkChangeCallback()V
    .locals 2

    const/16 v0, 0x6f

    .line 1007
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 1008
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mDefaultNetworkCallback:Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;

    const/4 v1, -0x1

    iput v1, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;->mExpectedSubId:I

    const/4 v1, 0x0

    .line 1009
    iput v1, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$DefaultNetworkCallback;->mSwitchReason:I

    .line 1011
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mConnectivityManager:Landroid/net/ConnectivityManager;

    invoke-virtual {p0, v0}, Landroid/net/ConnectivityManager;->unregisterNetworkCallback(Landroid/net/ConnectivityManager$NetworkCallback;)V

    return-void
.end method

.method private sendSetOpptCallbackHelper(Lcom/android/internal/telephony/ISetOpportunisticDataCallback;I)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    .line 1569
    :cond_0
    :try_start_0
    invoke-interface {p1, p2}, Lcom/android/internal/telephony/ISetOpportunisticDataCallback;->onComplete(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 1571
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "RemoteException "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private setOpportunisticDataSubscription(IZLcom/android/internal/telephony/ISetOpportunisticDataCallback;)V
    .locals 8

    .line 1496
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v0

    const v1, 0x7fffffff

    if-nez v0, :cond_0

    if-eq p1, v1, :cond_0

    .line 1498
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Can\'t switch data to inactive subId "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/4 p1, 0x2

    .line 1499
    invoke-direct {p0, p3, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendSetOpptCallbackHelper(Lcom/android/internal/telephony/ISetOpportunisticDataCallback;I)V

    return-void

    :cond_0
    const/16 v0, 0x6e

    .line 1505
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    const/16 v0, 0x76

    .line 1506
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    if-ne p1, v1, :cond_1

    .line 1509
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    move v3, v0

    goto :goto_0

    :cond_1
    move v3, p1

    :goto_0
    const/4 v0, -0x1

    .line 1511
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchSubId:I

    .line 1513
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidator:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->isValidating()Z

    move-result v0

    const/4 v2, 0x1

    if-eqz v0, :cond_2

    .line 1514
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidator:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->stopValidation()V

    .line 1515
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSetOpptSubCallback:Lcom/android/internal/telephony/ISetOpportunisticDataCallback;

    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendSetOpptCallbackHelper(Lcom/android/internal/telephony/ISetOpportunisticDataCallback;I)V

    const/4 v0, 0x0

    .line 1516
    iput-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSetOpptSubCallback:Lcom/android/internal/telephony/ISetOpportunisticDataCallback;

    .line 1519
    :cond_2
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    const/4 v4, 0x0

    if-ne p1, v0, :cond_3

    .line 1520
    invoke-direct {p0, p3, v4}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendSetOpptCallbackHelper(Lcom/android/internal/telephony/ISetOpportunisticDataCallback;I)V

    return-void

    :cond_3
    if-ne p1, v1, :cond_4

    .line 1524
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    goto :goto_1

    :cond_4
    move v0, p1

    :goto_1
    const/4 v5, 0x3

    invoke-direct {p0, v0, v2, v5}, Lcom/android/internal/telephony/data/PhoneSwitcher;->logDataSwitchEvent(III)V

    if-ne p1, v1, :cond_5

    .line 1528
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    goto :goto_2

    :cond_5
    move v0, p1

    .line 1527
    :goto_2
    invoke-direct {p0, v0, v5}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerDefaultNetworkChangeCallback(II)V

    .line 1533
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidator:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->isValidationFeatureSupported()Z

    move-result v0

    if-nez v0, :cond_6

    .line 1534
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->setOpportunisticSubscriptionInternal(I)V

    .line 1535
    invoke-direct {p0, p3, v4}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendSetOpptCallbackHelper(Lcom/android/internal/telephony/ISetOpportunisticDataCallback;I)V

    return-void

    .line 1544
    :cond_6
    iput v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchSubId:I

    .line 1545
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchNeedValidation:Z

    .line 1546
    iput-object p3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSetOpptSubCallback:Lcom/android/internal/telephony/ISetOpportunisticDataCallback;

    .line 1547
    invoke-direct {p0, v3, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getValidationTimeout(IZ)J

    move-result-wide v4

    .line 1548
    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidator:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    const/4 v6, 0x0

    iget-object v7, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidationCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;

    invoke-virtual/range {v2 .. v7}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->validate(IJZLcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;)V

    return-void
.end method

.method private setOpportunisticSubscriptionInternal(I)V
    .locals 1

    .line 1579
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    if-eq v0, p1, :cond_0

    .line 1580
    iput p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    const/4 p1, 0x0

    const-string v0, "oppt data subId changed"

    .line 1581
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    :cond_0
    return-void
.end method

.method private switchPhone(IZ)V
    .locals 3

    .line 1222
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    aget-object v0, v0, p1

    .line 1223
    iget-boolean v1, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->active:Z

    if-ne v1, p2, :cond_0

    return-void

    .line 1224
    :cond_0
    iput-boolean p2, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->active:Z

    .line 1225
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    if-eqz p2, :cond_1

    const-string p2, "activate "

    goto :goto_0

    :cond_1
    const-string p2, "deactivate "

    :goto_0
    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1226
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->lastRequested:J

    .line 1227
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendRilCommands(I)V

    return-void
.end method

.method private static switchReasonToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_3

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v0, 0x2

    if-eq p0, v0, :cond_1

    const/4 v0, 0x3

    if-eq p0, v0, :cond_0

    .line 1698
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "CBRS"

    return-object p0

    :cond_1
    const-string p0, "IN_CALL"

    return-object p0

    :cond_2
    const-string p0, "MANUAL"

    return-object p0

    :cond_3
    const-string p0, "UNKNOWN"

    return-object p0
.end method

.method private static switchStateToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    .line 1716
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "END"

    return-object p0

    :cond_1
    const-string p0, "START"

    return-object p0

    :cond_2
    const-string p0, "UNKNOWN"

    return-object p0
.end method


# virtual methods
.method protected activate(I)V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/4 v0, 0x1

    .line 1213
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->switchPhone(IZ)V

    return-void
.end method

.method protected deactivate(I)V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/4 v0, 0x0

    .line 1218
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->switchPhone(IZ)V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 9

    .line 1760
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    const-string p2, "PhoneSwitcher:"

    .line 1761
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1762
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1763
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object p2

    const/4 v1, 0x0

    move v2, v1

    .line 1764
    :goto_0
    iget v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v2, v3, :cond_1

    .line 1765
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    aget-object v3, v3, v2

    .line 1766
    iget-wide v4, v3, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->lastRequested:J

    invoke-virtual {p2, v4, v5}, Ljava/util/Calendar;->setTimeInMillis(J)V

    .line 1767
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "PhoneId("

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, ") active="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v5, v3, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->active:Z

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v5, ", lastRequest="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1768
    iget-wide v5, v3, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->lastRequested:J

    const-wide/16 v7, 0x0

    cmp-long v3, v5, v7

    if-nez v3, :cond_0

    const-string v3, "never"

    goto :goto_1

    :cond_0
    const/4 v3, 0x6

    new-array v3, v3, [Ljava/lang/Object;

    aput-object p2, v3, v1

    const/4 v5, 0x1

    aput-object p2, v3, v5

    const/4 v5, 0x2

    aput-object p2, v3, v5

    const/4 v5, 0x3

    aput-object p2, v3, v5

    const/4 v5, 0x4

    aput-object p2, v3, v5

    const/4 v5, 0x5

    aput-object p2, v3, v5

    const-string v5, "%tm-%td %tH:%tM:%tS.%tL"

    .line 1769
    invoke-static {v5, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    :goto_1
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 1767
    invoke-virtual {v0, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1771
    :cond_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPreferredDataPhoneId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1772
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPreferredDataSubId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {v1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1773
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DefaultDataSubId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1774
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DefaultDataPhoneId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    .line 1775
    invoke-virtual {v1}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v2

    .line 1774
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->getPhoneId(I)I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1776
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPrimaryDataSubId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1777
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mOpptDataSubId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1778
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsRegisteredForImsRadioTechChange="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mIsRegisteredForImsRadioTechChange:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1779
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPendingSwitchNeedValidation="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPendingSwitchNeedValidation:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1780
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mMaxDataAttachModemCount="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1781
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mActiveModemCount="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1782
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPhoneIdInVoiceCall="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1783
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCurrentDdsSwitchFailure="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 1784
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1785
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1786
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1787
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1788
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    return-void
.end method

.method protected findPhoneById(I)Lcom/android/internal/telephony/Phone;
    .locals 0

    .line 1424
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1427
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    return-object p0
.end method

.method public getActiveDataSubId()I
    .locals 0

    .line 1750
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result p0

    return p0
.end method

.method public getOpportunisticDataSubscriptionId()I
    .locals 0

    .line 1669
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    return p0
.end method

.method public getPreferredDataPhoneId()I
    .locals 0

    .line 1673
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    return p0
.end method

.method protected getSubIdForDefaultNetworkRequests()I
    .locals 2

    .line 1350
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1351
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mOpptDataSubId:I

    return p0

    .line 1353
    :cond_0
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    return p0
.end method

.method protected getSubIdFromNetworkSpecifier(Landroid/net/NetworkSpecifier;)I
    .locals 0

    if-nez p1, :cond_0

    const p0, 0x7fffffff

    return p0

    .line 1343
    :cond_0
    instance-of p0, p1, Landroid/net/TelephonyNetworkSpecifier;

    if-eqz p0, :cond_1

    .line 1344
    check-cast p1, Landroid/net/TelephonyNetworkSpecifier;

    invoke-virtual {p1}, Landroid/net/TelephonyNetworkSpecifier;->getSubscriptionId()I

    move-result p0

    return p0

    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 6

    .line 643
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0x74

    const/4 v2, 0x0

    const/4 v3, 0x1

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_3

    .line 704
    :pswitch_0
    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerForImsRadioTechChange()V

    .line 706
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneInVoiceCallChanged()Z

    move-result p1

    if-nez p1, :cond_0

    goto/16 :goto_3

    :cond_0
    const-string p1, "EVENT_IMS_RADIO_TECH_CHANGED"

    .line 709
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->evaluateIfDataSwitchIsNeeded(Ljava/lang/String;)V

    goto/16 :goto_3

    .line 842
    :pswitch_1
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 843
    iget p1, p1, Landroid/os/Message;->arg2:I

    .line 845
    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidSlotIndex(I)Z

    move-result v1

    if-nez v1, :cond_1

    .line 846
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_PROCESS_SIM_STATE_CHANGE: skip processing due to invalid slotId: "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    goto/16 :goto_3

    .line 848
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Set;

    sget-object v2, Lcom/android/internal/telephony/CommandException$Error;->INVALID_SIM_STATE:Lcom/android/internal/telephony/CommandException$Error;

    invoke-interface {v1, v2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_e

    const/16 v1, 0xa

    if-ne v1, p1, :cond_e

    .line 851
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isSimApplicationReady(I)Z

    move-result p1

    if-eqz p1, :cond_e

    .line 852
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendRilCommands(I)V

    goto/16 :goto_3

    .line 761
    :pswitch_2
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 762
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/Network;

    .line 763
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onNetworkAvailable(ILandroid/net/Network;)V

    goto/16 :goto_3

    .line 837
    :pswitch_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    .line 838
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onMultiSimConfigChanged(I)V

    goto/16 :goto_3

    .line 831
    :pswitch_4
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Emergency override removed - "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 832
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    const-string p1, "emer_rm_override_dds"

    .line 833
    invoke-virtual {p0, v2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    goto/16 :goto_3

    .line 787
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    .line 788
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    if-eqz v0, :cond_4

    .line 792
    iget v4, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    iget v5, p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    if-eq v4, v5, :cond_2

    .line 793
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "emergency override requested for phone id "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " when there is already an override in place for phone id "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iget v1, v1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ". Ignoring."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 796
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->isCallbackAvailable()Z

    move-result p0

    if-eqz p0, :cond_e

    .line 798
    iget-object p0, p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mOverrideCompleteFuture:Ljava/util/concurrent/CompletableFuture;

    sget-object p1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {p0, p1}, Ljava/util/concurrent/CompletableFuture;->complete(Ljava/lang/Object;)Z

    goto/16 :goto_3

    .line 802
    :cond_2
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->isCallbackAvailable()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 805
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iget-object v0, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mOverrideCompleteFuture:Ljava/util/concurrent/CompletableFuture;

    sget-object v4, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {v0, v4}, Ljava/util/concurrent/CompletableFuture;->complete(Ljava/lang/Object;)Z

    .line 808
    :cond_3
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    goto :goto_0

    .line 810
    :cond_4
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    .line 813
    :goto_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "new emergency override - "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 815
    invoke-virtual {p0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 816
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    .line 818
    sget v0, Lcom/android/internal/telephony/data/PhoneSwitcher;->DEFAULT_DATA_OVERRIDE_TIMEOUT_MS:I

    int-to-long v0, v0

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    const-string p1, "emer_override_dds"

    .line 821
    invoke-virtual {p0, v2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_e

    .line 824
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->sendOverrideCompleteCallbackResultAndClear(Z)V

    goto/16 :goto_3

    :pswitch_6
    const-string p1, "EVENT_DATA_ENABLED_CHANGED"

    .line 752
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->evaluateIfDataSwitchIsNeeded(Ljava/lang/String;)V

    goto/16 :goto_3

    .line 776
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    .line 777
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneIdValidForRetry(I)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 778
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_MODEM_COMMAND_RETRY: resend modem command on phone "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 779
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendRilCommands(I)V

    goto/16 :goto_3

    :cond_5
    const-string v0, "EVENT_MODEM_COMMAND_RETRY: skip retry as DDS sub changed"

    .line 781
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 782
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->clear()V

    goto/16 :goto_3

    .line 771
    :pswitch_8
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 772
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onDdsSwitchResponse(Landroid/os/AsyncResult;)V

    goto/16 :goto_3

    .line 767
    :pswitch_9
    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->removeDefaultNetworkChangeCallback()V

    goto/16 :goto_3

    .line 755
    :pswitch_a
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 756
    iget p1, p1, Landroid/os/Message;->arg2:I

    if-ne p1, v3, :cond_6

    move v2, v3

    .line 757
    :cond_6
    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onValidationDone(IZ)V

    goto/16 :goto_3

    .line 715
    :pswitch_b
    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerForImsRadioTechChange()V

    .line 718
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneInVoiceCallChanged()Z

    move-result p1

    if-nez p1, :cond_7

    goto/16 :goto_3

    .line 722
    :cond_7
    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isAnyVoiceCallActiveOnDevice()Z

    move-result p1

    if-nez p1, :cond_9

    move p1, v2

    .line 723
    :goto_1
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge p1, v0, :cond_9

    .line 724
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Set;

    sget-object v3, Lcom/android/internal/telephony/CommandException$Error;->OP_NOT_ALLOWED_DURING_VOICE_CALL:Lcom/android/internal/telephony/CommandException$Error;

    invoke-interface {v0, v3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_8

    .line 726
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneIdValidForRetry(I)Z

    move-result v0

    if-eqz v0, :cond_8

    .line 727
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendRilCommands(I)V

    :cond_8
    add-int/lit8 p1, p1, 0x1

    goto :goto_1

    .line 734
    :cond_9
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    if-eqz p1, :cond_a

    iget-boolean p1, p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPendingOriginatingCall:Z

    if-eqz p1, :cond_a

    .line 735
    invoke-virtual {p0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 736
    iget p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    const/4 v0, -0x1

    if-ne p1, v0, :cond_a

    .line 738
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    .line 739
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iget v0, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mGnssOverrideTimeMs:I

    sget v1, Lcom/android/internal/telephony/data/PhoneSwitcher;->ECBM_DEFAULT_DATA_SWITCH_BASE_TIME_MS:I

    add-int/2addr v0, v1

    int-to-long v0, v0

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 744
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iput-boolean v2, p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPendingOriginatingCall:Z

    :cond_a
    const-string p1, "EVENT_PRECISE_CALL_STATE_CHANGED"

    .line 747
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->evaluateIfDataSwitchIsNeeded(Ljava/lang/String;)V

    goto/16 :goto_3

    .line 697
    :pswitch_c
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->updateHalCommandToUse()V

    const-string p1, "EVENT_RADIO_ON"

    .line 698
    invoke-virtual {p0, v2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    goto/16 :goto_3

    .line 689
    :pswitch_d
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 690
    iget v1, p1, Landroid/os/Message;->arg2:I

    if-ne v1, v3, :cond_b

    move v2, v3

    .line 691
    :cond_b
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/ISetOpportunisticDataCallback;

    .line 693
    invoke-direct {p0, v0, v2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->setOpportunisticDataSubscription(IZLcom/android/internal/telephony/ISetOpportunisticDataCallback;)V

    goto/16 :goto_3

    .line 684
    :pswitch_e
    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 685
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendRilCommands(I)V

    goto :goto_3

    .line 667
    :pswitch_f
    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isInEmergencyCallbackMode()Z

    move-result p1

    .line 668
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    if-eqz v0, :cond_d

    .line 669
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Emergency override - ecbm status = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    if-eqz p1, :cond_c

    .line 672
    invoke-virtual {p0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 673
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iput-boolean v3, p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mRequiresEcmFinish:Z

    goto :goto_2

    .line 674
    :cond_c
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iget-boolean p1, p1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mRequiresEcmFinish:Z

    if-eqz p1, :cond_d

    .line 676
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    .line 677
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iget v0, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mGnssOverrideTimeMs:I

    int-to-long v0, v0

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    :cond_d
    :goto_2
    const-string p1, "emergencyToggle"

    .line 680
    invoke-virtual {p0, v3, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    goto :goto_3

    .line 663
    :pswitch_10
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkRequest;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onReleaseNetwork(Landroid/net/NetworkRequest;)V

    goto :goto_3

    .line 659
    :pswitch_11
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkRequest;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onRequestNetwork(Landroid/net/NetworkRequest;)V

    goto :goto_3

    :pswitch_12
    const-string/jumbo p1, "subChanged"

    .line 645
    invoke-virtual {p0, v2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    goto :goto_3

    :pswitch_13
    const-string p1, "primary data subId changed"

    .line 649
    invoke-virtual {p0, v2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->onEvaluate(ZLjava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_e

    .line 650
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {p1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result p1

    invoke-direct {p0, p1, v3, v3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->logDataSwitchEvent(III)V

    .line 653
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {p1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result p1

    invoke-direct {p0, p1, v3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerDefaultNetworkChangeCallback(II)V

    :cond_e
    :goto_3
    return-void

    :pswitch_data_0
    .packed-switch 0x65
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
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

.method isEmergencyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    const/16 p0, 0xa

    .line 1456
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result p0

    return p0
.end method

.method protected isImsOnOriginalNetwork(Lcom/android/internal/telephony/Phone;)Z
    .locals 3

    const/4 v0, 0x0

    if-nez p1, :cond_0

    return v0

    .line 416
    :cond_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    .line 417
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v1

    if-nez v1, :cond_1

    return v0

    .line 419
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mImsRegTechProvider:Lcom/android/internal/telephony/data/PhoneSwitcher$ImsRegTechProvider;

    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    invoke-interface {v1, v2, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher$ImsRegTechProvider;->get(Landroid/content/Context;I)I

    move-result p1

    const/4 v1, 0x1

    if-eq p1, v1, :cond_2

    const/4 v2, 0x2

    if-eq p1, v2, :cond_2

    move v0, v1

    :cond_2
    if-nez v0, :cond_3

    const-string p1, "IMS call on IWLAN or cross SIM. Call will be ignored for DDS switch"

    .line 424
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    :cond_3
    return v0
.end method

.method protected isPhoneActive(I)Z
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 1461
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-lt p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1463
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    aget-object p0, p0, p1

    iget-boolean p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->active:Z

    return p0
.end method

.method protected isPhoneInVoiceCall(Lcom/android/internal/telephony/Phone;)Z
    .locals 1

    const/4 p0, 0x0

    if-nez p1, :cond_0

    return p0

    .line 1659
    :cond_0
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getBackgroundCall()Lcom/android/internal/telephony/Call;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->isIdle()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1660
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getForegroundCall()Lcom/android/internal/telephony/Call;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Call;->isIdle()Z

    move-result p1

    if-nez p1, :cond_2

    :cond_1
    const/4 p0, 0x1

    :cond_2
    return p0
.end method

.method protected isPhoneInVoiceCallChanged()Z
    .locals 7

    .line 430
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    const/4 v1, -0x1

    .line 434
    iput v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    .line 435
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v2, :cond_2

    aget-object v5, v1, v4

    .line 436
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneInVoiceCall(Lcom/android/internal/telephony/Phone;)Z

    move-result v6

    if-nez v6, :cond_1

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v6

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneInVoiceCall(Lcom/android/internal/telephony/Phone;)Z

    move-result v6

    if-eqz v6, :cond_0

    .line 437
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isImsOnOriginalNetwork(Lcom/android/internal/telephony/Phone;)Z

    move-result v6

    if-eqz v6, :cond_0

    goto :goto_1

    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 438
    :cond_1
    :goto_1
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    .line 443
    :cond_2
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    if-eq v1, v0, :cond_3

    .line 444
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isPhoneInVoiceCallChanged from phoneId "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " to phoneId "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/4 p0, 0x1

    return p0

    :cond_3
    return v3
.end method

.method protected log(Ljava/lang/String;)V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const-string v0, "PhoneSwitcher"

    .line 1678
    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1679
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected notifyPreferredDataSubIdChanged()V
    .locals 3

    .line 1740
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mContext:Landroid/content/Context;

    const-string/jumbo v1, "telephony_registry"

    .line 1741
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyRegistryManager;

    .line 1742
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "notifyPreferredDataSubIdChanged to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {v2}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1743
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/TelephonyRegistryManager;->notifyActiveDataSubIdChanged(I)V

    return-void
.end method

.method protected onDdsSwitchResponse(Landroid/os/AsyncResult;)V
    .locals 3

    if-eqz p1, :cond_0

    .line 1798
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 1799
    :goto_0
    iget-object v1, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 1800
    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    if-eqz v2, :cond_1

    .line 1801
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Emergency override result sent = "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1802
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->sendOverrideCompleteCallbackResultAndClear(Z)V

    goto :goto_1

    :cond_1
    if-nez v0, :cond_4

    .line 1806
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onDdsSwitchResponse: DDS switch failed. with exception "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1807
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    instance-of v0, p1, Lcom/android/internal/telephony/CommandException;

    if-eqz v0, :cond_3

    .line 1808
    check-cast p1, Lcom/android/internal/telephony/CommandException;

    .line 1809
    invoke-virtual {p1}, Lcom/android/internal/telephony/CommandException;->getCommandError()Lcom/android/internal/telephony/CommandException$Error;

    move-result-object p1

    .line 1810
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 1811
    sget-object v0, Lcom/android/internal/telephony/CommandException$Error;->OP_NOT_ALLOWED_DURING_VOICE_CALL:Lcom/android/internal/telephony/CommandException$Error;

    if-ne p1, v0, :cond_2

    const-string p1, "onDdsSwitchResponse: Wait for call end indication"

    .line 1812
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    return-void

    .line 1814
    :cond_2
    sget-object v0, Lcom/android/internal/telephony/CommandException$Error;->INVALID_SIM_STATE:Lcom/android/internal/telephony/CommandException$Error;

    if-ne p1, v0, :cond_3

    const-string p1, "onDdsSwitchResponse: Wait for SIM to get READY"

    .line 1817
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    return-void

    :cond_3
    const-string p1, "onDdsSwitchResponse: Scheduling DDS switch retry"

    .line 1821
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/16 p1, 0x71

    .line 1823
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    .line 1822
    invoke-static {p0, p1, v0}, Landroid/os/Message;->obtain(Landroid/os/Handler;ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v0, 0x1388

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void

    :cond_4
    :goto_1
    if-eqz v0, :cond_5

    .line 1826
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onDdsSwitchResponse: DDS switch success on phoneId = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1827
    :cond_5
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mCurrentDdsSwitchFailure:Ljava/util/List;

    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/Set;

    invoke-interface {p1}, Ljava/util/Set;->clear()V

    .line 1829
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActivePhoneRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 1830
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->notifyPreferredDataSubIdChanged()V

    return-void
.end method

.method protected onEvaluate(ZLjava/lang/String;)Z
    .locals 9

    .line 1063
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 1066
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mHalCommandToUse:I

    const/4 v2, 0x2

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-eq v1, v2, :cond_0

    if-eqz p1, :cond_0

    move p1, v4

    goto :goto_0

    :cond_0
    move p1, v3

    .line 1069
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v1}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v1

    .line 1070
    iget v5, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    const-string v6, "->"

    if-eq v1, v5, :cond_1

    const-string v5, " mPrimaryDataSubId "

    .line 1071
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1072
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 1073
    iput v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrimaryDataSubId:I

    :cond_1
    move v1, v3

    move v5, v1

    .line 1080
    :goto_1
    iget v7, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v1, v7, :cond_4

    .line 1081
    iget-object v7, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    invoke-virtual {v7, v1}, Lcom/android/internal/telephony/SubscriptionController;->getSubIdUsingPhoneId(I)I

    move-result v7

    .line 1083
    invoke-static {v7}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v8

    if-eqz v8, :cond_2

    move v5, v4

    .line 1085
    :cond_2
    iget-object v8, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    aget v8, v8, v1

    if-eq v7, v8, :cond_3

    const-string p1, " phone["

    .line 1086
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "] "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    aget p1, p1, v1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 1087
    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 1088
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    aput v7, p1, v1

    move p1, v4

    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    :cond_4
    if-nez v5, :cond_5

    .line 1094
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->transitionToEmergencyPhone()V

    .line 1100
    :cond_5
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    .line 1103
    iget-object v7, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {v7}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result v7

    if-eqz v5, :cond_6

    .line 1110
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->updatePreferredDataPhoneId()V

    .line 1112
    :cond_6
    iget v5, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    if-eq v1, v5, :cond_7

    const-string p1, " preferred phoneId "

    .line 1113
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 1114
    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move p1, v4

    goto :goto_2

    .line 1116
    :cond_7
    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {v1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result v1

    if-eq v7, v1, :cond_8

    const-string v1, "SIM refresh, notify dds change"

    .line 1117
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1119
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->notifyPreferredDataSubIdChanged()V

    :cond_8
    :goto_2
    if-nez p1, :cond_9

    const-string v1, "EVENT_RADIO_ON"

    .line 1125
    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1a

    .line 1126
    :cond_9
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "evaluating due to "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1127
    iget p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mHalCommandToUse:I

    if-ne p2, v2, :cond_b

    .line 1131
    :goto_3
    iget p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v3, p2, :cond_a

    .line 1132
    iget-object p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneStates:[Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;

    aget-object p2, p2, v3

    iput-boolean v4, p2, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->active:Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_3

    .line 1134
    :cond_a
    iget p2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->sendRilCommands(I)V

    goto/16 :goto_a

    .line 1136
    :cond_b
    new-instance p2, Ljava/util/ArrayList;

    invoke-direct {p2}, Ljava/util/ArrayList;-><init>()V

    .line 1143
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ne v0, v1, :cond_c

    move v0, v3

    .line 1144
    :goto_4
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    if-ge v0, v1, :cond_17

    .line 1145
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {p2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    .line 1149
    :cond_c
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_d

    .line 1150
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1153
    :cond_d
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    iget v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    if-ge v0, v2, :cond_15

    .line 1154
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_11

    .line 1155
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_e
    :goto_5
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_15

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 1156
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->phoneIdForRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result v2

    if-ne v2, v1, :cond_f

    goto :goto_5

    .line 1158
    :cond_f
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {p2, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_10

    goto :goto_5

    .line 1159
    :cond_10
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {p2, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1160
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v2

    iget v4, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    if-lt v2, v4, :cond_e

    goto :goto_7

    .line 1163
    :cond_11
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPrioritizedDcRequests:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_12
    :goto_6
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_15

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/dataconnection/DcRequest;

    .line 1164
    iget-object v2, v2, Lcom/android/internal/telephony/dataconnection/DcRequest;->networkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->phoneIdForRequest(Landroid/net/NetworkRequest;)I

    move-result v2

    if-ne v2, v1, :cond_13

    goto :goto_6

    .line 1166
    :cond_13
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {p2, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_14

    goto :goto_6

    .line 1167
    :cond_14
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {p2, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1168
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v2

    iget v4, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    if-lt v2, v4, :cond_12

    .line 1173
    :cond_15
    :goto_7
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mMaxDataAttachModemCount:I

    if-ge v0, v1, :cond_16

    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    .line 1174
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_16

    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    .line 1175
    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isUsableSubIdValue(I)Z

    move-result v0

    if-eqz v0, :cond_16

    .line 1176
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1178
    :cond_16
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->suggestDefaultActivePhone(Ljava/util/List;)V

    .line 1191
    :cond_17
    :goto_8
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v3, v0, :cond_19

    .line 1192
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_18

    .line 1193
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/PhoneSwitcher;->deactivate(I)V

    :cond_18
    add-int/lit8 v3, v3, 0x1

    goto :goto_8

    .line 1198
    :cond_19
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_9
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1a

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 1199
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->activate(I)V

    goto :goto_9

    :cond_1a
    :goto_a
    return p1
.end method

.method public onRadioCapChanged(I)V
    .locals 1

    .line 1235
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/16 v0, 0x6a

    .line 1236
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    .line 1237
    iput p1, p0, Landroid/os/Message;->arg1:I

    .line 1238
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public overrideDefaultDataForEmergency(IILjava/util/concurrent/CompletableFuture;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(II",
            "Ljava/util/concurrent/CompletableFuture<",
            "Ljava/lang/Boolean;",
            ">;)V"
        }
    .end annotation

    .line 1260
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/16 v0, 0x73

    .line 1261
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    .line 1262
    new-instance v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;-><init>()V

    .line 1263
    iput p1, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    mul-int/lit16 p2, p2, 0x3e8

    .line 1264
    iput p2, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mGnssOverrideTimeMs:I

    .line 1265
    iput-object p3, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mOverrideCompleteFuture:Ljava/util/concurrent/CompletableFuture;

    .line 1266
    iput-object v0, p0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 1267
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method protected phoneIdForRequest(Landroid/net/NetworkRequest;)I
    .locals 4

    .line 1306
    invoke-virtual {p1}, Landroid/net/NetworkRequest;->getNetworkSpecifier()Landroid/net/NetworkSpecifier;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getSubIdFromNetworkSpecifier(Landroid/net/NetworkSpecifier;)I

    move-result v0

    const v1, 0x7fffffff

    if-ne v0, v1, :cond_0

    .line 1308
    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    return p0

    :cond_0
    const/4 v1, -0x1

    if-ne v0, v1, :cond_1

    return v1

    .line 1311
    :cond_1
    iget v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    if-ltz v2, :cond_2

    iget v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v2, v3, :cond_2

    .line 1313
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    aget v2, v3, v2

    goto :goto_0

    :cond_2
    move v2, v1

    :goto_0
    const/16 v3, 0xc

    .line 1321
    invoke-virtual {p1, v3}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result v3

    if-eqz v3, :cond_3

    const/16 v3, 0xd

    .line 1322
    invoke-virtual {p1, v3}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result p1

    if-eqz p1, :cond_3

    if-eq v0, v2, :cond_3

    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mValidator:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    .line 1323
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->getSubIdInValidation()I

    move-result p1

    if-eq v0, p1, :cond_3

    return v1

    :cond_3
    const/4 p1, 0x0

    .line 1330
    :goto_1
    iget v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge p1, v2, :cond_5

    .line 1331
    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    aget v2, v2, p1

    if-ne v2, v0, :cond_4

    move v1, p1

    goto :goto_2

    :cond_4
    add-int/lit8 p1, p1, 0x1

    goto :goto_1

    :cond_5
    :goto_2
    return v1
.end method

.method public registerForActivePhoneSwitch(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 1471
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1472
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActivePhoneRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 1473
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    return-void
.end method

.method protected sendRilCommands(I)V
    .locals 3

    .line 1271
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1272
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "sendRilCommands: skip dds switch due to invalid phoneId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    return-void

    :cond_0
    const/16 v0, 0x70

    .line 1276
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {p0, v0, v1}, Landroid/os/Message;->obtain(Landroid/os/Handler;ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    .line 1277
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mHalCommandToUse:I

    const/4 v2, 0x1

    if-eq v1, v2, :cond_2

    if-nez v1, :cond_1

    goto :goto_0

    .line 1282
    :cond_1
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    if-ne p1, v1, :cond_3

    .line 1284
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "sendRilCommands: setPreferredDataModem - phoneId: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1285
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    invoke-virtual {p1, p0, v0}, Lcom/android/internal/telephony/RadioConfig;->setPreferredDataModem(ILandroid/os/Message;)V

    goto :goto_1

    .line 1279
    :cond_2
    :goto_0
    iget v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-le v1, v2, :cond_3

    .line 1280
    invoke-static {p1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    iget-object v1, v1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneActive(I)Z

    move-result p0

    invoke-interface {v1, p0, v0}, Lcom/android/internal/telephony/CommandsInterface;->setDataAllowed(ZLandroid/os/Message;)V

    :cond_3
    :goto_1
    return-void
.end method

.method public declared-synchronized shouldApplyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z
    .locals 5

    monitor-enter p0

    .line 1432
    :try_start_0
    invoke-static {p2}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    monitor-exit p0

    return v1

    .line 1435
    :cond_0
    :try_start_1
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isPhoneActive(I)Z

    move-result v0

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    .line 1436
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/SubscriptionController;->getSubIdUsingPhoneId(I)I

    move-result v0

    const/4 v2, -0x1

    if-ne v0, v2, :cond_1

    .line 1437
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isEmergencyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result v0

    if-nez v0, :cond_1

    goto :goto_0

    .line 1441
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object v0

    .line 1442
    invoke-virtual {v0}, Landroid/net/NetworkRequest;->getNetworkSpecifier()Landroid/net/NetworkSpecifier;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getSubIdFromNetworkSpecifier(Landroid/net/NetworkSpecifier;)I

    move-result v0

    .line 1446
    invoke-direct {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isAnyVoiceCallActiveOnDevice()Z

    move-result v3

    const/4 v4, 0x1

    if-eqz v3, :cond_4

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->isEmergencyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result v3

    if-eqz v3, :cond_4

    const v3, 0x7fffffff

    if-eq v0, v3, :cond_2

    if-ne v0, v2, :cond_4

    .line 1448
    :cond_2
    iget p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-ne p2, p1, :cond_3

    move v1, v4

    :cond_3
    monitor-exit p0

    return v1

    .line 1451
    :cond_4
    :try_start_2
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->phoneIdForRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-ne p2, p1, :cond_5

    move v1, v4

    .line 1452
    :cond_5
    monitor-exit p0

    return v1

    .line 1438
    :cond_6
    :goto_0
    monitor-exit p0

    return v1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method protected suggestDefaultActivePhone(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    return-void
.end method

.method protected transitionToEmergencyPhone()V
    .locals 2

    .line 1407
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-gtz v0, :cond_0

    const-string v0, "No phones: unable to reset preferred phone for emergency"

    .line 1408
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    return-void

    .line 1412
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    if-eqz v0, :cond_1

    const-string v0, "No active subscriptions: resetting preferred phone to 0 for emergency"

    .line 1413
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 1414
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    .line 1417
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->get()I

    move-result v0

    const/4 v1, -0x1

    if-eq v0, v1, :cond_2

    .line 1418
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->set(I)V

    .line 1419
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->notifyPreferredDataSubIdChanged()V

    :cond_2
    return-void
.end method

.method public trySetOpportunisticDataSubscription(IZLcom/android/internal/telephony/ISetOpportunisticDataCallback;)V
    .locals 2

    .line 1647
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Try set opportunistic data subscription to subId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    if-eqz p2, :cond_0

    const-string v1, " with "

    goto :goto_0

    :cond_0
    const-string v1, " without "

    .line 1648
    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo v1, "validation"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1647
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    const/16 v0, 0x6b

    .line 1649
    invoke-virtual {p0, v0, p1, p2, p3}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 1650
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public unregisterForActivePhoneSwitch(Landroid/os/Handler;)V
    .locals 0

    .line 1477
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActivePhoneRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method protected updateHalCommandToUse()V
    .locals 1

    .line 1664
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfig;->isSetPreferredDataCommandSupported()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x2

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 1665
    :goto_0
    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mHalCommandToUse:I

    return-void
.end method

.method protected updatePreferredDataPhoneId()V
    .locals 4

    .line 1360
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->findPhoneById(I)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 1363
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v2

    const/16 v3, 0x11

    if-eqz v2, :cond_0

    .line 1364
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v0

    .line 1365
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled(I)Z

    move-result v0

    goto :goto_0

    .line 1367
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v0

    .line 1368
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isDataEnabled(I)Z

    move-result v0

    goto :goto_0

    :cond_1
    move v0, v1

    .line 1372
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    if-eqz v2, :cond_2

    iget v2, v2, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/PhoneSwitcher;->findPhoneById(I)Lcom/android/internal/telephony/Phone;

    move-result-object v2

    if-eqz v2, :cond_2

    .line 1377
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updatePreferredDataPhoneId: preferred data overridden for emergency. phoneId = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iget v1, v1, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->log(Ljava/lang/String;)V

    .line 1379
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mEmergencyOverride:Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;

    iget v0, v0, Lcom/android/internal/telephony/data/PhoneSwitcher$EmergencyOverrideRequest;->mPhoneId:I

    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    goto :goto_3

    :cond_2
    if-eqz v0, :cond_3

    .line 1385
    iget v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneIdInVoiceCall:I

    iput v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    goto :goto_3

    .line 1387
    :cond_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getSubIdForDefaultNetworkRequests()I

    move-result v0

    const/4 v2, -0x1

    .line 1390
    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isUsableSubIdValue(I)Z

    move-result v3

    if-eqz v3, :cond_5

    .line 1391
    :goto_1
    iget v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mActiveModemCount:I

    if-ge v1, v3, :cond_5

    .line 1392
    iget-object v3, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPhoneSubscriptions:[I

    aget v3, v3, v1

    if-ne v3, v0, :cond_4

    move v2, v1

    goto :goto_2

    :cond_4
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 1399
    :cond_5
    :goto_2
    iput v2, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    .line 1402
    :goto_3
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataSubId:Lcom/android/internal/telephony/SubscriptionController$WatchedInt;

    iget-object v1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    iget p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher;->mPreferredDataPhoneId:I

    .line 1403
    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/SubscriptionController;->getSubIdUsingPhoneId(I)I

    move-result p0

    .line 1402
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->set(I)V

    return-void
.end method
