.class public Lcom/android/internal/telephony/GsmCdmaPhone;
.super Lcom/android/internal/telephony/Phone;
.source "GsmCdmaPhone.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/GsmCdmaPhone$ImsManagerFactory;,
        Lcom/android/internal/telephony/GsmCdmaPhone$Cfu;
    }
.end annotation


# static fields
.field public static final CANCEL_ECM_TIMER:I = 0x1

.field private static final DBG:Z = true

.field private static final DEFAULT_ECM_EXIT_TIMER_VALUE:J = 0x493e0L

.field public static ENABLE_UICC_APPS_MAX_RETRIES:I = 0x3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final INVALID_SYSTEM_SELECTION_CODE:I = -0x1

.field private static final IS683A_FEATURE_CODE:Ljava/lang/String; = "*228"

.field private static final IS683A_FEATURE_CODE_NUM_DIGITS:I = 0x4

.field private static final IS683A_SYS_SEL_CODE_NUM_DIGITS:I = 0x2

.field private static final IS683A_SYS_SEL_CODE_OFFSET:I = 0x4

.field private static final IS683_CONST_1900MHZ_A_BLOCK:I = 0x2

.field private static final IS683_CONST_1900MHZ_B_BLOCK:I = 0x3

.field private static final IS683_CONST_1900MHZ_C_BLOCK:I = 0x4

.field private static final IS683_CONST_1900MHZ_D_BLOCK:I = 0x5

.field private static final IS683_CONST_1900MHZ_E_BLOCK:I = 0x6

.field private static final IS683_CONST_1900MHZ_F_BLOCK:I = 0x7

.field private static final IS683_CONST_800MHZ_A_BAND:I = 0x0

.field private static final IS683_CONST_800MHZ_B_BAND:I = 0x1

.field public static final LOG_TAG:Ljava/lang/String; = "GsmCdmaPhone"

.field protected static final PREFIX_WPS:Ljava/lang/String; = "*272"

.field protected static final PREFIX_WPS_CLIR_ACTIVATE:Ljava/lang/String; = "*31#*272"

.field protected static final PREFIX_WPS_CLIR_DEACTIVATE:Ljava/lang/String; = "#31#*272"

.field public static final PROPERTY_CDMA_HOME_OPERATOR_NUMERIC:Ljava/lang/String; = "ro.cdma.home.operator.numeric"

.field private static final REAPPLY_UICC_APPS_SETTING_RETRY_TIME_GAP_IN_MS:I = 0x1388

.field private static final REPORTING_HYSTERESIS_KBPS:I = 0x32

.field private static final REPORTING_HYSTERESIS_MILLIS:I = 0xbb8

.field public static final RESTART_ECM_TIMER:I = 0x0

.field private static final VDBG:Z = false

.field private static final VM_NUMBER:Ljava/lang/String; = "vm_number_key"

.field private static final VM_NUMBER_CDMA:Ljava/lang/String; = "vm_number_key_cdma"

.field private static final VM_SIM_IMSI:Ljava/lang/String; = "vm_sim_imsi_key"

.field private static final VOICE_PS_CALL_RADIO_TECHNOLOGY:[I

.field private static pOtaSpNumSchema:Ljava/util/regex/Pattern;


# instance fields
.field private mBroadcastEmergencyCallStateChanges:Z

.field private mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field private mCDM:Lcom/android/internal/telephony/CarrierKeyDownloadManager;

.field private mCIM:Lcom/android/internal/telephony/CarrierInfoManager;

.field public mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mCarrierOtaSpNumSchema:Ljava/lang/String;

.field private final mCarrierPrivilegesTracker:Lcom/android/internal/telephony/CarrierPrivilegesTracker;

.field protected mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

.field public mCdmaSubscriptionSource:I

.field protected mDialArgs:Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;

.field private mEcmExitRespRegistrant:Lcom/android/internal/telephony/Registrant;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field private final mEcmTimerResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field public mEmergencyNumberTracker:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

.field private mEsn:Ljava/lang/String;

.field private mExitEcmRunnable:Ljava/lang/Runnable;

.field protected mIccPhoneBookIntManager:Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

.field private mIccSmsInterfaceManager:Lcom/android/internal/telephony/IccSmsInterfaceManager;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mImei:Ljava/lang/String;

.field protected mImeiSv:Ljava/lang/String;

.field private final mImsManagerFactory:Lcom/android/internal/telephony/GsmCdmaPhone$ImsManagerFactory;

.field protected mIsTestingEmergencyCallbackMode:Z

.field private mIsimUiccRecords:Lcom/android/internal/telephony/uicc/IsimUiccRecords;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mManualNetworkSelectionPlmn:Ljava/lang/String;

.field private mMeid:Ljava/lang/String;

.field protected mPendingMMIs:Ljava/util/ArrayList;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/MmiCode;",
            ">;"
        }
    .end annotation
.end field

.field private mPrecisePhoneType:I

.field private mResetModemOnRadioTechnologyChange:Z

.field protected mRilVersion:I

.field public mSST:Lcom/android/internal/telephony/ServiceStateTracker;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mSettingsObserver:Lcom/android/internal/telephony/SettingsObserver;

.field private mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

.field protected mSsOverCdmaSupported:Z

.field protected mSsnRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private final mSubscriptionsChangedListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

.field private mTelecomVoiceServiceStateOverride:I

.field protected mUiccApplicationsEnabled:Ljava/lang/Boolean;

.field private mVmNumber:Ljava/lang/String;

.field private final mVolteSilentRedialRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mWakeLock:Landroid/os/PowerManager$WakeLock;


# direct methods
.method public static synthetic $r8$lambda$ZgLoki0QXQYufhnmFR9wk9AHRCU(Lcom/android/internal/telephony/GsmCdmaPhone;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->lambda$handleMessage$0(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$fG3Ss8TfnflXCEnTilRyAYdbb1w(Landroid/content/Context;I)Lcom/android/ims/ImsManager;
    .locals 0

    invoke-static {p0, p1}, Lcom/android/ims/ImsManager;->getInstance(Landroid/content/Context;I)Lcom/android/ims/ImsManager;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mupdateTtyMode(Lcom/android/internal/telephony/GsmCdmaPhone;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateTtyMode(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateUiTtyMode(Lcom/android/internal/telephony/GsmCdmaPhone;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateUiTtyMode(I)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    const-string v0, "[,\\s]+"

    .line 3920
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/GsmCdmaPhone;->pOtaSpNumSchema:Ljava/util/regex/Pattern;

    const/4 v0, 0x4

    new-array v0, v0, [I

    .line 4489
    fill-array-data v0, :array_0

    sput-object v0, Lcom/android/internal/telephony/GsmCdmaPhone;->VOICE_PS_CALL_RADIO_TECHNOLOGY:[I

    return-void

    nop

    :array_0
    .array-data 4
        0xe
        0x13
        0x12
        0x14
    .end array-data
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/PhoneNotifier;IILcom/android/internal/telephony/TelephonyComponentFactory;)V
    .locals 8

    const/4 v4, 0x0

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move v5, p4

    move v6, p5

    move-object v7, p6

    .line 293
    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/GsmCdmaPhone;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/PhoneNotifier;ZIILcom/android/internal/telephony/TelephonyComponentFactory;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/PhoneNotifier;ZIILcom/android/internal/telephony/TelephonyComponentFactory;)V
    .locals 9

    .line 299
    new-instance v8, Lcom/android/internal/telephony/GsmCdmaPhone$$ExternalSyntheticLambda1;

    invoke-direct {v8}, Lcom/android/internal/telephony/GsmCdmaPhone$$ExternalSyntheticLambda1;-><init>()V

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move v4, p4

    move v5, p5

    move v6, p6

    move-object/from16 v7, p7

    invoke-direct/range {v0 .. v8}, Lcom/android/internal/telephony/GsmCdmaPhone;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/PhoneNotifier;ZIILcom/android/internal/telephony/TelephonyComponentFactory;Lcom/android/internal/telephony/GsmCdmaPhone$ImsManagerFactory;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/PhoneNotifier;ZIILcom/android/internal/telephony/TelephonyComponentFactory;Lcom/android/internal/telephony/GsmCdmaPhone$ImsManagerFactory;)V
    .locals 12

    move-object v8, p0

    move-object v9, p1

    move/from16 v10, p6

    const/4 v11, 0x1

    if-ne v10, v11, :cond_0

    const-string v0, "GSM"

    goto :goto_0

    :cond_0
    const-string v0, "CDMA"

    :goto_0
    move-object v1, v0

    move-object v0, p0

    move-object v2, p3

    move-object v3, p1

    move-object v4, p2

    move/from16 v5, p4

    move/from16 v6, p5

    move-object/from16 v7, p7

    .line 309
    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/Phone;-><init>(Ljava/lang/String;Lcom/android/internal/telephony/PhoneNotifier;Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;ZILcom/android/internal/telephony/TelephonyComponentFactory;)V

    .line 160
    new-instance v0, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v0}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v0, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    const/4 v0, -0x1

    .line 174
    iput v0, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    const/4 v0, 0x0

    .line 184
    iput-object v0, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mUiccApplicationsEnabled:Ljava/lang/Boolean;

    const/4 v1, 0x0

    .line 187
    iput-boolean v1, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mIsTestingEmergencyCallbackMode:Z

    .line 193
    new-instance v2, Lcom/android/internal/telephony/GsmCdmaPhone$1;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/GsmCdmaPhone$1;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;)V

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mExitEcmRunnable:Ljava/lang/Runnable;

    .line 220
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    .line 228
    new-instance v2, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v2}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmTimerResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 230
    new-instance v2, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v2}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mVolteSilentRedialRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 231
    iput-object v0, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mDialArgs:Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;

    .line 269
    iput-boolean v1, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mResetModemOnRadioTechnologyChange:Z

    .line 271
    iput-boolean v1, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsOverCdmaSupported:Z

    .line 275
    iput-boolean v1, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mBroadcastEmergencyCallStateChanges:Z

    .line 276
    iput v11, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mTelecomVoiceServiceStateOverride:I

    .line 412
    new-instance v2, Lcom/android/internal/telephony/GsmCdmaPhone$3;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/GsmCdmaPhone$3;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;)V

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    .line 313
    iput v10, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    .line 314
    new-instance v2, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;

    iget v3, v8, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-direct {v2, v3, p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;-><init>(ILcom/android/internal/telephony/Phone;)V

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mVoiceCallSessionStats:Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;

    move-object/from16 v2, p8

    .line 315
    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mImsManagerFactory:Lcom/android/internal/telephony/GsmCdmaPhone$ImsManagerFactory;

    move-object v2, p2

    .line 316
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->initOnce(Lcom/android/internal/telephony/CommandsInterface;)V

    .line 317
    invoke-virtual {p0, v10}, Lcom/android/internal/telephony/GsmCdmaPhone;->initRatSpecific(I)V

    .line 320
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/CarrierActionAgent;

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 321
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeCarrierActionAgent(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/CarrierActionAgent;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mCarrierActionAgent:Lcom/android/internal/telephony/CarrierActionAgent;

    .line 322
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/CarrierSignalAgent;

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 323
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeCarrierSignalAgent(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/CarrierSignalAgent;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mCarrierSignalAgent:Lcom/android/internal/telephony/CarrierSignalAgent;

    .line 324
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 325
    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 326
    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-virtual {v2, p0, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeAccessNetworksManager(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 327
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v2

    if-nez v2, :cond_1

    .line 328
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/dataconnection/TransportManager;

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 329
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeTransportManager(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/dataconnection/TransportManager;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mTransportManager:Lcom/android/internal/telephony/dataconnection/TransportManager;

    .line 332
    :cond_1
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/SignalStrengthController;

    .line 333
    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    .line 332
    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 333
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeSignalStrengthController(Lcom/android/internal/telephony/GsmCdmaPhone;)Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mSignalStrengthController:Lcom/android/internal/telephony/SignalStrengthController;

    .line 334
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    iget-object v3, v8, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 335
    invoke-virtual {v2, p0, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeServiceStateTracker(Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/CommandsInterface;)Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    .line 336
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    .line 337
    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    iget-object v3, v8, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {v2, p0, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeEmergencyNumberTracker(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/CommandsInterface;)Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mEmergencyNumberTracker:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    .line 339
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v2

    if-nez v2, :cond_2

    .line 340
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    .line 341
    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDataEnabledSettings(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    .line 343
    :cond_2
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/DeviceStateMonitor;

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 344
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDeviceStateMonitor(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/DeviceStateMonitor;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mDeviceStateMonitor:Lcom/android/internal/telephony/DeviceStateMonitor;

    .line 348
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/DisplayInfoController;

    .line 349
    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    .line 348
    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 349
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDisplayInfoController(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/DisplayInfoController;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mDisplayInfoController:Lcom/android/internal/telephony/DisplayInfoController;

    .line 351
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v2

    if-eqz v2, :cond_3

    .line 352
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/data/DataNetworkController;

    .line 353
    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    .line 352
    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 354
    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-virtual {v2, p0, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDataNetworkController(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    goto :goto_2

    .line 358
    :cond_3
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v2

    array-length v3, v2

    move v4, v1

    :goto_1
    if-ge v4, v3, :cond_4

    aget v5, v2, v4

    .line 359
    iget-object v6, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v7, Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-virtual {v7}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v6

    .line 360
    invoke-virtual {v6, p0, v5}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDcTracker(Lcom/android/internal/telephony/Phone;I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v6

    .line 361
    iget-object v7, v8, Lcom/android/internal/telephony/Phone;->mDcTrackers:Landroid/util/SparseArray;

    invoke-virtual {v7, v5, v6}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 362
    iget-object v5, v8, Lcom/android/internal/telephony/Phone;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v6}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataThrottler()Lcom/android/internal/telephony/dataconnection/DataThrottler;

    move-result-object v6

    invoke-virtual {v5, v6}, Lcom/android/internal/telephony/data/AccessNetworksManager;->registerDataThrottler(Lcom/android/internal/telephony/dataconnection/DataThrottler;)V

    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 366
    :cond_4
    :goto_2
    iget-object v2, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v3, Lcom/android/internal/telephony/CarrierResolver;

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 367
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeCarrierResolver(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/CarrierResolver;

    move-result-object v2

    iput-object v2, v8, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    .line 368
    new-instance v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker;

    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v2, v3, p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;-><init>(Landroid/os/Looper;Lcom/android/internal/telephony/Phone;Landroid/content/Context;)V

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierPrivilegesTracker:Lcom/android/internal/telephony/CarrierPrivilegesTracker;

    .line 370
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCarrierActionAgent()Lcom/android/internal/telephony/CarrierActionAgent;

    move-result-object v2

    const/4 v3, 0x0

    const/16 v4, 0x30

    const/4 v5, 0x0

    const/4 v6, 0x0

    move-object p2, v2

    move p3, v3

    move-object/from16 p4, p0

    move/from16 p5, v4

    move-object/from16 p6, v5

    move/from16 p7, v6

    invoke-virtual/range {p2 .. p7}, Lcom/android/internal/telephony/CarrierActionAgent;->registerForCarrierAction(ILandroid/os/Handler;ILjava/lang/Object;Z)V

    .line 374
    iget-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    const/16 v3, 0x13

    invoke-virtual {v2, p0, v3, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNetworkAttached(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 375
    iget-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    const/16 v3, 0x2e

    invoke-virtual {v2, p0, v3, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForVoiceRegStateOrRatChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 378
    new-instance v2, Lcom/android/internal/telephony/SettingsObserver;

    invoke-direct {v2, p1, p0}, Lcom/android/internal/telephony/SettingsObserver;-><init>(Landroid/content/Context;Landroid/os/Handler;)V

    iput-object v2, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mSettingsObserver:Lcom/android/internal/telephony/SettingsObserver;

    const-string v3, "device_provisioned"

    .line 380
    invoke-static {v3}, Landroid/provider/Settings$Global;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    const/16 v4, 0x31

    .line 379
    invoke-virtual {v2, v3, v4}, Lcom/android/internal/telephony/SettingsObserver;->observe(Landroid/net/Uri;I)V

    const-string v3, "device_provisioning_mobile_data"

    .line 383
    invoke-static {v3}, Landroid/provider/Settings$Global;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    const/16 v4, 0x32

    .line 382
    invoke-virtual {v2, v3, v4}, Lcom/android/internal/telephony/SettingsObserver;->observe(Landroid/net/Uri;I)V

    .line 386
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v2

    const/16 v3, 0x36

    invoke-virtual {v2, p0, v3, v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->registerForUiccAppsEnabled(Landroid/os/Handler;ILjava/lang/Object;Z)V

    .line 389
    iget-object v0, v8, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    .line 390
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    .line 391
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeLinkBandwidthEstimator(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    iput-object v0, v8, Lcom/android/internal/telephony/Phone;->mLinkBandwidthEstimator:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    .line 393
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loadTtyMode()V

    .line 395
    invoke-static {}, Lcom/android/internal/telephony/CallManager;->getInstance()Lcom/android/internal/telephony/CallManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/CallManager;->registerPhone(Lcom/android/internal/telephony/Phone;)Z

    .line 397
    new-instance v0, Lcom/android/internal/telephony/GsmCdmaPhone$2;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/GsmCdmaPhone$2;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;)V

    iput-object v0, v8, Lcom/android/internal/telephony/GsmCdmaPhone;->mSubscriptionsChangedListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

    .line 405
    const-class v1, Landroid/telephony/SubscriptionManager;

    invoke-virtual {p1, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/SubscriptionManager;

    .line 406
    new-instance v2, Landroid/os/HandlerExecutor;

    invoke-direct {v2, p0}, Landroid/os/HandlerExecutor;-><init>(Landroid/os/Handler;)V

    invoke-virtual {v1, v2, v0}, Landroid/telephony/SubscriptionManager;->addOnSubscriptionsChangedListener(Ljava/util/concurrent/Executor;Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;)V

    .line 409
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "GsmCdmaPhone: constructor: sub = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, v8, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return-void
.end method

.method private static checkOtaSpNumBasedOnSysSelCode(I[Ljava/lang/String;)Z
    .locals 7

    const/4 v0, 0x0

    const/4 v1, 0x1

    .line 3984
    :try_start_0
    aget-object v2, p1, v1

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    move v3, v0

    :goto_0
    if-ge v3, v2, :cond_1

    mul-int/lit8 v4, v3, 0x2

    add-int/lit8 v5, v4, 0x2

    .line 3986
    aget-object v6, p1, v5

    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_0

    add-int/lit8 v4, v4, 0x3

    aget-object v6, p1, v4

    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 3987
    aget-object v5, p1, v5

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    .line 3988
    aget-object v4, p1, v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    if-lt p0, v5, :cond_0

    if-gt p0, v4, :cond_0

    move v0, v1

    goto :goto_1

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "GsmCdmaPhone"

    const-string v1, "checkOtaSpNumBasedOnSysSelCode, error"

    .line 4000
    invoke-static {p1, v1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_1
    :goto_1
    return v0
.end method

.method private static extractSelCodeFromOtaSpNum(Ljava/lang/String;)I
    .locals 4

    .line 3957
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    const-string v2, "*228"

    const/4 v3, 0x4

    .line 3960
    invoke-virtual {p0, v1, v2, v1, v3}, Ljava/lang/String;->regionMatches(ILjava/lang/String;II)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 v1, 0x6

    if-lt v0, v1, :cond_0

    .line 3967
    invoke-virtual {p0, v3, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    .line 3966
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, -0x1

    .line 3970
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "extractSelCodeFromOtaSpNum "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "GsmCdmaPhone"

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return p0
.end method

.method private getCsCallRadioTech(II)I
    .locals 2

    .line 4535
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getCsCallRadioTech, current vrs="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", vrat="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    if-nez p1, :cond_0

    .line 4537
    sget-object p1, Lcom/android/internal/telephony/GsmCdmaPhone;->VOICE_PS_CALL_RADIO_TECHNOLOGY:[I

    .line 4538
    invoke-static {p1, p2}, Lcom/android/internal/telephony/util/ArrayUtils;->contains([II)Z

    move-result p1

    if-eqz p1, :cond_1

    :cond_0
    const/4 p2, 0x0

    .line 4542
    :cond_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "getCsCallRadioTech, result calcVrat="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return p2
.end method

.method private getVmSimImsi()Ljava/lang/String;
    .locals 3

    .line 1938
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1939
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "vm_sim_imsi_key"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/4 v1, 0x0

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private handleCallDeflectionIncallSupplementaryService(Ljava/lang/String;)Z
    .locals 3

    .line 1173
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    const/4 v0, 0x1

    if-le p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1177
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p1

    sget-object v1, Lcom/android/internal/telephony/Call$State;->IDLE:Lcom/android/internal/telephony/Call$State;

    if-eq p1, v1, :cond_1

    const-string p1, "MmiCode 0: rejectCall"

    .line 1178
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1180
    :try_start_0
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->rejectCall()V
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v1, "GsmCdmaPhone"

    const-string v2, "reject failed"

    .line 1182
    invoke-static {v1, v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 1184
    sget-object p1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->REJECT:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifySuppServiceFailed(Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;)V

    goto :goto_0

    .line 1186
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getBackgroundCall()Lcom/android/internal/telephony/GsmCdmaCall;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p1

    if-eq p1, v1, :cond_2

    const-string p1, "MmiCode 0: hangupWaitingOrBackground"

    .line 1187
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1188
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->hangupWaitingOrBackground()V

    :cond_2
    :goto_0
    return v0
.end method

.method private handleEnterEmergencyCallbackMode(Landroid/os/Message;)V
    .locals 2

    .line 3816
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handleEnterEmergencyCallbackMode, isInEcm()="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3817
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "GsmCdmaPhone"

    .line 3816
    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 3820
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result p1

    if-nez p1, :cond_0

    const/4 p1, 0x1

    .line 3821
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Phone;->setIsInEcm(Z)V

    .line 3824
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->sendEmergencyCallbackModeChange()V

    .line 3828
    invoke-static {}, Landroid/internal/telephony/sysprop/TelephonyProperties;->ecm_exit_timer()Ljava/util/Optional;

    move-result-object p1

    const-wide/32 v0, 0x493e0

    .line 3829
    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    .line 3830
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mExitEcmRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 3832
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {p0}, Landroid/os/PowerManager$WakeLock;->acquire()V

    :cond_0
    return-void
.end method

.method private handleExitEmergencyCallbackMode(Landroid/os/Message;)V
    .locals 2

    .line 3838
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3840
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleExitEmergencyCallbackMode,ar.exception , isInEcm="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 3841
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "GsmCdmaPhone"

    .line 3840
    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 3844
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mExitEcmRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 3846
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmExitRespRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz v0, :cond_0

    .line 3847
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    .line 3851
    :cond_0
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    const/4 v0, 0x0

    if-eqz p1, :cond_1

    iget-boolean p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIsTestingEmergencyCallbackMode:Z

    if-eqz p1, :cond_5

    .line 3852
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 3853
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->setIsInEcm(Z)V

    .line 3857
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {p1}, Landroid/os/PowerManager$WakeLock;->isHeld()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 3858
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {p1}, Landroid/os/PowerManager$WakeLock;->release()V

    .line 3862
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->sendEmergencyCallbackModeChange()V

    .line 3864
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-nez p1, :cond_4

    .line 3865
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    const/4 v1, 0x1

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setInternalDataEnabled(Z)V

    .line 3867
    :cond_4
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyEmergencyCallRegistrants(Z)V

    .line 3869
    :cond_5
    iput-boolean v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIsTestingEmergencyCallbackMode:Z

    return-void
.end method

.method private handleRadioAvailable()V
    .locals 2

    .line 2962
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x6

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->getBasebandVersion(Landroid/os/Message;)V

    .line 2964
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x15

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->getDeviceIdentity(Landroid/os/Message;)V

    .line 2965
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x23

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioCapability(Landroid/os/Message;)V

    .line 2966
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x37

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->areUiccApplicationsEnabled(Landroid/os/Message;)V

    .line 2968
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->startLceAfterRadioIsAvailable()V

    return-void
.end method

.method private handleRadioOffOrNotAvailable()V
    .locals 2

    .line 2981
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2987
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    :goto_0
    if-ltz v0, :cond_1

    .line 2988
    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/gsm/GsmMmiCode;

    invoke-virtual {v1}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->isPendingUSSD()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2989
    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/gsm/GsmMmiCode;

    invoke-virtual {v1}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->onUssdFinishedError()V

    :cond_0
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 2993
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mRadioOffOrNotAvailableRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    return-void
.end method

.method private handleRadioOn()V
    .locals 2

    .line 2973
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x28

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->getVoiceRadioTechnology(Landroid/os/Message;)V

    .line 2975
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_0

    .line 2976
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getCdmaSubscriptionSource()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    :cond_0
    return-void
.end method

.method private handleRadioPowerStateChange()V
    .locals 3

    .line 2997
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    .line 2998
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "handleRadioPowerStateChange, state= "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "GsmCdmaPhone"

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 2999
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mNotifier:Lcom/android/internal/telephony/PhoneNotifier;

    invoke-interface {v1, p0, v0}, Lcom/android/internal/telephony/PhoneNotifier;->notifyRadioPowerStateChanged(Lcom/android/internal/telephony/Phone;I)V

    .line 3000
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v1

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v1, p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeRadioState(II)V

    return-void
.end method

.method private isCarrierOtaSpNum(Ljava/lang/String;)Z
    .locals 7

    .line 4026
    invoke-static {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->extractSelCodeFromOtaSpNum(Ljava/lang/String;)I

    move-result v0

    const/4 v1, -0x1

    const/4 v2, 0x0

    if-ne v0, v1, :cond_0

    return v2

    .line 4031
    :cond_0
    iget-object v3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierOtaSpNumSchema:Ljava/lang/String;

    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    const-string v4, "GsmCdmaPhone"

    if-nez v3, :cond_6

    .line 4032
    sget-object v3, Lcom/android/internal/telephony/GsmCdmaPhone;->pOtaSpNumSchema:Ljava/util/regex/Pattern;

    iget-object v5, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierOtaSpNumSchema:Ljava/lang/String;

    invoke-virtual {v3, v5}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v3

    .line 4034
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "isCarrierOtaSpNum,schema"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierOtaSpNumSchema:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 4037
    invoke-virtual {v3}, Ljava/util/regex/Matcher;->find()Z

    move-result v3

    if-eqz v3, :cond_5

    .line 4038
    sget-object v3, Lcom/android/internal/telephony/GsmCdmaPhone;->pOtaSpNumSchema:Ljava/util/regex/Pattern;

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierOtaSpNumSchema:Ljava/lang/String;

    invoke-virtual {v3, p0}, Ljava/util/regex/Pattern;->split(Ljava/lang/CharSequence;)[Ljava/lang/String;

    move-result-object p0

    .line 4040
    aget-object v3, p0, v2

    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_2

    aget-object v3, p0, v2

    const-string v5, "SELC"

    invoke-virtual {v3, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    if-eq v0, v1, :cond_1

    .line 4042
    invoke-static {v0, p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->checkOtaSpNumBasedOnSysSelCode(I[Ljava/lang/String;)Z

    move-result v2

    goto :goto_0

    :cond_1
    const-string p0, "isCarrierOtaSpNum,sysSelCodeInt is invalid"

    .line 4045
    invoke-static {v4, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 4048
    :cond_2
    aget-object v0, p0, v2

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_4

    aget-object v0, p0, v2

    const-string v1, "FC"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 v0, 0x1

    .line 4049
    aget-object v1, p0, v0

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    const/4 v3, 0x2

    .line 4050
    aget-object p0, p0, v3

    .line 4051
    invoke-virtual {p1, v2, p0, v2, v1}, Ljava/lang/String;->regionMatches(ILjava/lang/String;II)Z

    move-result p0

    if-eqz p0, :cond_3

    move v2, v0

    goto :goto_0

    :cond_3
    const-string p0, "isCarrierOtaSpNum,not otasp number"

    .line 4054
    invoke-static {v4, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 4058
    :cond_4
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "isCarrierOtaSpNum,ota schema not supported"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object p0, p0, v2

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v4, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 4063
    :cond_5
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "isCarrierOtaSpNum,ota schema pattern not right"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierOtaSpNumSchema:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v4, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_6
    const-string p0, "isCarrierOtaSpNum,ota schema pattern empty"

    .line 4068
    invoke-static {v4, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return v2
.end method

.method private static isIs683OtaSpDialStr(Ljava/lang/String;)Z
    .locals 3

    .line 3926
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x4

    if-ne v0, v2, :cond_0

    const-string v0, "*228"

    .line 3929
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_0

    .line 3933
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->extractSelCodeFromOtaSpNum(Ljava/lang/String;)I

    move-result p0

    packed-switch p0, :pswitch_data_0

    :cond_1
    const/4 v1, 0x0

    :goto_0
    :pswitch_0
    return v1

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method

.method private isManualSelProhibitedInGlobalMode()Z
    .locals 6
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 3737
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x10407e8

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 3740
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez v1, :cond_2

    const-string v1, ";"

    .line 3741
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 3743
    array-length v1, v0

    const-string/jumbo v4, "true"

    if-ne v1, v3, :cond_0

    aget-object v1, v0, v2

    .line 3744
    invoke-virtual {v1, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1

    :cond_0
    array-length v1, v0

    const/4 v5, 0x2

    if-ne v1, v5, :cond_2

    aget-object v1, v0, v3

    .line 3745
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    aget-object v1, v0, v2

    .line 3746
    invoke-virtual {v1, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    aget-object v0, v0, v3

    .line 3747
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->isMatchGid(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_2

    :cond_1
    move v2, v3

    .line 3751
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isManualNetSelAllowedInGlobal in current carrier is "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return v2
.end method

.method private synthetic lambda$handleMessage$0(I)V
    .locals 0

    add-int/lit8 p1, p1, -0x1

    .line 3421
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->reapplyUiccAppsEnablementIfNeeded(I)V

    return-void
.end method

.method private loadTtyMode()V
    .locals 3

    .line 4733
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-class v1, Landroid/telecom/TelecomManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telecom/TelecomManager;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 4735
    invoke-virtual {v0}, Landroid/telecom/TelecomManager;->getCurrentTtyMode()I

    move-result v0

    goto :goto_0

    :cond_0
    move v0, v1

    .line 4737
    :goto_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateTtyMode(I)V

    .line 4739
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v2, "preferred_tty_mode"

    invoke-static {v0, v2, v1}, Landroid/provider/Settings$Secure;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    .line 4741
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateUiTtyMode(I)V

    return-void
.end method

.method private static mergeVoiceServiceStates(Landroid/telephony/ServiceState;Landroid/telephony/ServiceState;I)Landroid/telephony/ServiceState;
    .locals 1

    .line 1142
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    :cond_0
    const/4 v0, 0x1

    if-nez p2, :cond_1

    goto :goto_0

    .line 1155
    :cond_1
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getState()I

    move-result p1

    if-nez p1, :cond_2

    .line 1159
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result p2

    goto :goto_0

    :cond_2
    move p2, v0

    :goto_0
    if-eqz p2, :cond_3

    return-object p0

    .line 1165
    :cond_3
    new-instance p1, Landroid/telephony/ServiceState;

    invoke-direct {p1, p0}, Landroid/telephony/ServiceState;-><init>(Landroid/telephony/ServiceState;)V

    .line 1166
    invoke-virtual {p1, p2}, Landroid/telephony/ServiceState;->setVoiceRegState(I)V

    const/4 p0, 0x0

    .line 1167
    invoke-virtual {p1, p0}, Landroid/telephony/ServiceState;->setEmergencyOnly(Z)V

    return-object p1
.end method

.method private migrateClirSettingIfNeeded(Landroid/content/SharedPreferences;)V
    .locals 5

    .line 2948
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "clir_key"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v2, -0x1

    invoke-interface {p1, v0, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    if-ltz v0, :cond_0

    .line 2951
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Migrate CLIR setting: value="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ", clir_key"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2952
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " -> "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "clir_sub_key"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v4, "GsmCdmaPhone"

    .line 2951
    invoke-static {v4, v2}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 2953
    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 2954
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-interface {p1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 2957
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {p1, p0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    :cond_0
    return-void
.end method

.method private onVoiceRegStateOrRatChanged(II)V
    .locals 1

    const-string v0, "onVoiceRegStateOrRatChanged"

    .line 4550
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4551
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCsCallRadioTech(II)I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->dispatchCsCallRadioTech(I)V

    return-void
.end method

.method protected static pii(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    const-string v0, "GsmCdmaPhone"

    .line 4657
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private sendEmergencyCallbackModeChange()V
    .locals 3

    .line 888
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.EMERGENCY_CALLBACK_MODE_CHANGED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 889
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v1

    const-string v2, "android.telephony.extra.PHONE_IN_ECM_STATE"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 890
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-static {v0, v1}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    .line 891
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    sget-object v2, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    invoke-virtual {v1, v0, v2}, Landroid/content/Context;->sendStickyBroadcastAsUser(Landroid/content/Intent;Landroid/os/UserHandle;)V

    const-string v0, "sendEmergencyCallbackModeChange"

    .line 892
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    return-void
.end method

.method private setVmSimImsi(Ljava/lang/String;)V
    .locals 3

    .line 1943
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1944
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 1945
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "vm_sim_imsi_key"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 1946
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method private storeVoiceMailNumber(Ljava/lang/String;)V
    .locals 3

    .line 1859
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1860
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 1861
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSubscriberId()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->setVmSimImsi(Ljava/lang/String;)V

    .line 1862
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "storeVoiceMailNumber: mPrecisePhoneType="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " vmNumber="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "GsmCdmaPhone"

    .line 1863
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1862
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1864
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1865
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "vm_number_key"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 1866
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    goto :goto_0

    .line 1868
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "vm_number_key_cdma"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 1869
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :goto_0
    return-void
.end method

.method private static telecomModeToPhoneMode(I)I
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    const/4 v1, 0x2

    if-eq p0, v1, :cond_0

    const/4 v1, 0x3

    if-eq p0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return v0
.end method

.method private updateBroadcastEmergencyCallStateChangesAfterCarrierConfigChanged(Landroid/os/PersistableBundle;)V
    .locals 2

    if-nez p1, :cond_0

    const-string p1, "didn\'t get broadcastEmergencyCallStateChanges from carrier config"

    .line 4857
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-void

    :cond_0
    const-string v0, "broadcast_emergency_call_state_changes_bool"

    .line 4862
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p1

    .line 4864
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "broadcastEmergencyCallStateChanges = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4865
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->setBroadcastEmergencyCallStateChanges(Z)V

    return-void
.end method

.method private updateCdmaRoamingSettingsAfterCarrierConfigChanged(Landroid/os/PersistableBundle;)V
    .locals 4

    if-nez p1, :cond_0

    const-string p1, "didn\'t get the cdma_roaming_mode changes from the carrier config."

    .line 4926
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-void

    :cond_0
    const-string v0, "cdma_roaming_mode_int"

    .line 4931
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result p1

    .line 4934
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "roaming_settings"

    const/4 v2, -0x1

    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    const/16 v1, 0x2c

    const-string v3, "cdma_roaming_mode is going to changed to "

    if-eq p1, v2, :cond_2

    if-eqz p1, :cond_1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 v0, 0x2

    if-eq p1, v0, :cond_1

    .line 4961
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Invalid cdma_roaming_mode settings: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 4944
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4947
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 4946
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/Phone;->setCdmaRoamingPreference(ILandroid/os/Message;)V

    goto :goto_0

    :cond_2
    if-eq v0, p1, :cond_3

    .line 4954
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4957
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    .line 4956
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/Phone;->setCdmaRoamingPreference(ILandroid/os/Message;)V

    :cond_3
    :goto_0
    return-void
.end method

.method private updateCurrentCarrierInProvider(Ljava/lang/String;)Z
    .locals 5

    .line 3585
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    const/4 v1, 0x1

    if-nez v0, :cond_1

    .line 3586
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v2, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v2, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const-string/jumbo p1, "updateCurrentCarrierInProvider not updated X retVal=true"

    .line 3608
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return v1

    :cond_1
    :goto_0
    const-string v0, "CDMAPhone: updateCurrentCarrierInProvider called"

    .line 3588
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3589
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 3591
    :try_start_0
    sget-object v0, Landroid/provider/Telephony$Carriers;->CONTENT_URI:Landroid/net/Uri;

    const-string v2, "current"

    invoke-static {v0, v2}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 3592
    new-instance v2, Landroid/content/ContentValues;

    invoke-direct {v2}, Landroid/content/ContentValues;-><init>()V

    const-string v3, "numeric"

    .line 3593
    invoke-virtual {v2, v3, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 3594
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "updateCurrentCarrierInProvider from system: numeric="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3595
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-virtual {v3, v0, v2}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    .line 3598
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "update mccmnc="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3599
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/MccTable;->updateMccMncConfiguration(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/database/SQLException; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    :catch_0
    move-exception p0

    const-string p1, "GsmCdmaPhone"

    const-string v0, "Can\'t store current operator"

    .line 3603
    invoke-static {p1, v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method private updateLinkCapacityEstimate(Ljava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;)V"
        }
    .end annotation

    .line 613
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateLinkCapacityEstimate: lce list="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    if-nez p1, :cond_0

    return-void

    .line 617
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Phone;->notifyLinkCapacityEstimateChanged(Ljava/util/List;)V

    return-void
.end method

.method private updateNrSettingsAfterCarrierConfigChanged(Landroid/os/PersistableBundle;)V
    .locals 1

    if-nez p1, :cond_0

    const-string p1, "didn\'t get the carrier_nr_availability_int from the carrier config."

    .line 4870
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-void

    :cond_0
    const-string v0, "carrier_nr_availabilities_int_array"

    .line 4873
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object p1

    .line 4875
    invoke-static {p1}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty([I)Z

    move-result p1

    xor-int/lit8 p1, p1, 0x1

    iput-boolean p1, p0, Lcom/android/internal/telephony/Phone;->mIsCarrierNrSupported:Z

    return-void
.end method

.method private updateSsOverCdmaSupported(Landroid/os/PersistableBundle;)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    :cond_0
    const-string/jumbo v0, "support_ss_over_cdma_bool"

    .line 2368
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p1

    iput-boolean p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsOverCdmaSupported:Z

    return-void
.end method

.method private updateTtyMode(I)V
    .locals 3

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    .line 4702
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string/jumbo v1, "updateTtyMode ttyMode=%d"

    invoke-static {v1, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    .line 4703
    invoke-static {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->telecomModeToPhoneMode(I)I

    move-result p1

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->setTTYMode(ILandroid/os/Message;)V

    return-void
.end method

.method private updateUiTtyMode(I)V
    .locals 3

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    .line 4706
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string/jumbo v1, "updateUiTtyMode ttyMode=%d"

    invoke-static {v1, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    .line 4707
    invoke-static {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->telecomModeToPhoneMode(I)I

    move-result p1

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->setUiTTYMode(ILandroid/os/Message;)V

    return-void
.end method

.method private updateVoNrSettings(Landroid/os/PersistableBundle;)V
    .locals 5

    const-string v0, "ro.vendor.mtk_telephony_add_on_policy"

    const-string v1, "0"

    .line 4880
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "didn\'t updateVoNrSettings for add on case, will update by ims."

    .line 4881
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    return-void

    .line 4886
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlotForPhone(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v0

    if-eqz v0, :cond_7

    .line 4889
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_PRESENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-eq v0, v1, :cond_1

    goto :goto_2

    :cond_1
    if-nez p1, :cond_2

    const-string p1, "didn\'t get the vonr_enabled_bool from the carrier config."

    .line 4894
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-void

    :cond_2
    const-string/jumbo v0, "vonr_enabled_bool"

    .line 4899
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p1

    .line 4901
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    .line 4902
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    const-string v2, "nr_advanced_calling_enabled"

    .line 4901
    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->getSubscriptionProperty(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v1, -0x1

    if-eqz v0, :cond_3

    .line 4907
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    goto :goto_0

    :cond_3
    move v0, v1

    .line 4910
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "VoNR setting from telephony.db:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " ,vonr_enabled_bool:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/16 v4, 0x3d

    if-nez p1, :cond_4

    .line 4916
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0, v4}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, v2, p0, v3}, Lcom/android/internal/telephony/CommandsInterface;->setVoNrEnabled(ZLandroid/os/Message;Landroid/os/WorkSource;)V

    goto :goto_2

    :cond_4
    const/4 p1, 0x1

    if-eq v0, p1, :cond_6

    if-ne v0, v1, :cond_5

    goto :goto_1

    :cond_5
    if-nez v0, :cond_7

    .line 4920
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0, v4}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, v2, p0, v3}, Lcom/android/internal/telephony/CommandsInterface;->setVoNrEnabled(ZLandroid/os/Message;Landroid/os/WorkSource;)V

    goto :goto_2

    .line 4918
    :cond_6
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0, v4}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v0, p1, p0, v3}, Lcom/android/internal/telephony/CommandsInterface;->setVoNrEnabled(ZLandroid/os/Message;Landroid/os/WorkSource;)V

    :cond_7
    :goto_2
    return-void
.end method


# virtual methods
.method public acceptCall(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 966
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_0

    .line 967
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Call;->isRinging()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 968
    invoke-interface {v0, p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->acceptCall(I)V

    goto :goto_0

    .line 970
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->acceptCall()V

    :goto_0
    return-void
.end method

.method public activateCellBroadcastSms(ILandroid/os/Message;)V
    .locals 0

    const-string p1, "[GsmCdmaPhone] activateCellBroadcastSms() is obsolete; use SmsManager"

    .line 3646
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 3647
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public canConference()Z
    .locals 1

    .line 1006
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->canConference()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    .line 1009
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1010
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->canConference()Z

    move-result p0

    return p0

    :cond_1
    const-string v0, "canConference: not possible in CDMA"

    .line 1012
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public canDisablePhysicalSubscription()Z
    .locals 0

    .line 4802
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0}, Lcom/android/internal/telephony/CommandsInterface;->canToggleUiccApplicationsEnablement()Z

    move-result p0

    return p0
.end method

.method public canTransfer()Z
    .locals 1

    .line 1069
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1070
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->canTransfer()Z

    move-result p0

    return p0

    :cond_0
    const-string v0, "canTransfer: not possible in CDMA"

    .line 1072
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public changeCallBarringPassword(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .locals 1

    .line 2534
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2535
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/CommandsInterface;->changeBarringPassword(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string p1, "changeCallBarringPassword: not possible in CDMA"

    .line 2537
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method protected checkForTestEmergencyNumber(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    const-string v0, "ril.test.emergencynumber"

    .line 4411
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 4412
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    const-string v1, ":"

    .line 4413
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 4414
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "checkForTestEmergencyNumber: values.length="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v2, v0

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4415
    array-length v1, v0

    const/4 v2, 0x2

    if-ne v1, v2, :cond_0

    const/4 v1, 0x0

    .line 4416
    aget-object v1, v0, v1

    invoke-static {p1}, Landroid/telephony/PhoneNumberUtils;->stripSeparators(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 4417
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "checkForTestEmergencyNumber: remap "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " to "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 p1, 0x1

    aget-object v2, v0, p1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4418
    aget-object p1, v0, p1

    :cond_0
    return-object p1
.end method

.method public clearDisconnected()V
    .locals 0

    .line 1064
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->clearDisconnected()V

    return-void
.end method

.method public conference()V
    .locals 1

    .line 1019
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->canConference()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "conference() - delegated to IMS phone"

    .line 1020
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1022
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->conference()V
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 1024
    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :goto_0
    return-void

    .line 1028
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1029
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->conference()V

    goto :goto_1

    :cond_1
    const-string v0, "conference: not possible in CDMA"

    .line 1032
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :goto_1
    return-void
.end method

.method protected correctPhoneTypeForCdma(ZI)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public deleteCarrierInfoForImsiEncryption(I)V
    .locals 1

    .line 2067
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/CarrierInfoManager;->deleteCarrierInfoForImsiEncryption(Landroid/content/Context;II)V

    return-void
.end method

.method public dial(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;Ljava/util/function/Consumer;)Lcom/android/internal/telephony/Connection;
    .locals 18
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;",
            "Ljava/util/function/Consumer<",
            "Lcom/android/internal/telephony/Phone;",
            ">;)",
            "Lcom/android/internal/telephony/Connection;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    move-object/from16 v1, p0

    move-object/from16 v0, p1

    move-object/from16 v2, p3

    .line 1430
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-nez v3, :cond_1

    move-object/from16 v3, p2

    iget-object v4, v3, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    if-nez v4, :cond_0

    goto :goto_0

    .line 1431
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/CallStateException;

    const-string v1, "Sending UUS information NOT supported in CDMA!"

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/CallStateException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_1
    move-object/from16 v3, p2

    .line 1433
    :goto_0
    invoke-virtual/range {p0 .. p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->checkForTestEmergencyNumber(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 1435
    invoke-static {v0, v4}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v5

    const/4 v6, 0x1

    xor-int/2addr v5, v6

    if-eqz v5, :cond_2

    .line 1437
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "dialString replaced for possible emergency number: "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " -> "

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    goto :goto_1

    :cond_2
    move-object v4, v0

    .line 1442
    :goto_1
    iget-object v0, v1, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-string v7, "carrier_config"

    .line 1443
    invoke-virtual {v0, v7}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 1448
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->onGetCarrierConfig(Landroid/telephony/CarrierConfigManager;)Landroid/os/PersistableBundle;

    move-result-object v0

    const-string/jumbo v7, "support_wps_over_ims_bool"

    .line 1450
    invoke-virtual {v0, v7}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v7

    const-string/jumbo v8, "use_only_dialed_sim_ecc_list_bool"

    .line 1452
    invoke-virtual {v0, v8}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    .line 1456
    iget-object v8, v1, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-class v9, Landroid/telephony/TelephonyManager;

    invoke-virtual {v8, v9}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/telephony/TelephonyManager;

    const-string v9, "dial; isEmergency="

    if-eqz v0, :cond_3

    .line 1465
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getEmergencyNumberTracker()Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    move-result-object v10

    invoke-virtual {v10, v4, v6}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;->isEmergencyNumber(Ljava/lang/String;Z)Z

    move-result v10

    .line 1467
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v9, " (based on this phone only); globalIsEmergency="

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1469
    invoke-virtual {v8, v4}, Landroid/telephony/TelephonyManager;->isEmergencyNumber(Ljava/lang/String;)Z

    move-result v8

    invoke-virtual {v11, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    .line 1467
    invoke-virtual {v1, v8}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    goto :goto_2

    .line 1471
    :cond_3
    invoke-virtual {v8, v4}, Landroid/telephony/TelephonyManager;->isEmergencyNumber(Ljava/lang/String;)Z

    move-result v10

    .line 1472
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v9, " (based on all phones)"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v1, v8}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    .line 1476
    :goto_2
    invoke-virtual {v1, v10}, Lcom/android/internal/telephony/GsmCdmaPhone;->onCheckEmergencyCall(Z)V

    if-eqz v4, :cond_5

    const-string v9, "*272"

    .line 1479
    invoke-virtual {v4, v9}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-nez v9, :cond_4

    const-string v9, "*31#*272"

    .line 1480
    invoke-virtual {v4, v9}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-nez v9, :cond_4

    const-string v9, "#31#*272"

    .line 1481
    invoke-virtual {v4, v9}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_5

    :cond_4
    move v9, v6

    goto :goto_3

    :cond_5
    const/4 v9, 0x0

    .line 1484
    :goto_3
    invoke-static/range {p2 .. p2}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->from(Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    move-result-object v3

    .line 1485
    invoke-virtual {v3, v10}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setIsEmergency(Z)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    .line 1486
    invoke-virtual {v3, v9}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->setIsWpsCall(Z)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    move-result-object v3

    .line 1487
    invoke-virtual {v3}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->build()Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;

    move-result-object v3

    iput-object v3, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mDialArgs:Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;

    .line 1489
    iget-object v11, v1, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v10, :cond_6

    .line 1491
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->useImsForEmergency()Z

    move-result v12

    if-eqz v12, :cond_6

    move v12, v6

    goto :goto_4

    :cond_6
    const/4 v12, 0x0

    .line 1494
    :goto_4
    invoke-static {v4}, Landroid/telephony/PhoneNumberUtils;->stripSeparators(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    .line 1493
    invoke-static {v13}, Landroid/telephony/PhoneNumberUtils;->extractNetworkPortionAlt(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    const-string v14, "*"

    .line 1495
    invoke-virtual {v13, v14}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v14

    const-string v15, "#"

    if-nez v14, :cond_7

    invoke-virtual {v13, v15}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_8

    .line 1496
    :cond_7
    invoke-virtual {v13, v15}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_8

    move v14, v6

    goto :goto_5

    :cond_8
    const/4 v14, 0x0

    .line 1497
    :goto_5
    invoke-static {v13, v1}, Lcom/android/internal/telephony/imsphone/ImsPhoneMmiCode;->isSuppServiceCodes(Ljava/lang/String;Lcom/android/internal/telephony/Phone;)Z

    move-result v13

    if-eqz v14, :cond_9

    if-nez v13, :cond_9

    move v15, v6

    goto :goto_6

    :cond_9
    const/4 v15, 0x0

    :goto_6
    if-eqz v11, :cond_a

    .line 1499
    invoke-virtual {v11}, Lcom/android/internal/telephony/Phone;->isUtEnabled()Z

    move-result v16

    if-eqz v16, :cond_a

    move v8, v6

    goto :goto_7

    :cond_a
    const/4 v8, 0x0

    .line 1500
    :goto_7
    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->useImsForCall(Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Z

    move-result v16

    if-eqz v16, :cond_b

    if-eqz v9, :cond_c

    if-eqz v7, :cond_b

    goto :goto_8

    :cond_b
    const/4 v6, 0x0

    .line 1503
    :cond_c
    :goto_8
    invoke-virtual {v1, v8}, Lcom/android/internal/telephony/GsmCdmaPhone;->onSetUseImsForUt(Z)Z

    move-result v8

    .line 1506
    invoke-virtual {v1, v6}, Lcom/android/internal/telephony/GsmCdmaPhone;->onSetUseImsForCall(Z)Z

    move-result v6

    move/from16 v17, v5

    .line 1510
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 p1, v3

    const-string/jumbo v3, "useImsForCall="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ", useOnlyDialedSimEccList="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", isEmergency="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", useImsForEmergency="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v12}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", useImsForUt="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", isUt="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", isSuppServiceCode="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v13}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", isPotentialUssdCode="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v15}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", isWpsCall="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", allowWpsOverIms="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", imsPhone="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ", imsPhone.isVoiceOverCellularImsEnabled()="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "N/A"

    if-eqz v11, :cond_d

    .line 1522
    invoke-virtual {v11}, Lcom/android/internal/telephony/Phone;->isVoiceOverCellularImsEnabled()Z

    move-result v3

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    goto :goto_9

    :cond_d
    move-object v3, v0

    :goto_9
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, ", imsPhone.isVowifiEnabled()="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v11, :cond_e

    .line 1524
    invoke-virtual {v11}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result v3

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    goto :goto_a

    :cond_e
    move-object v3, v0

    :goto_a
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, ", imsPhone.isVideoEnabled()="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v11, :cond_f

    .line 1526
    invoke-virtual {v11}, Lcom/android/internal/telephony/Phone;->isVideoEnabled()Z

    move-result v3

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    goto :goto_b

    :cond_f
    move-object v3, v0

    :goto_b
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, ", imsPhone.getServiceState().getState()="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v11, :cond_10

    .line 1528
    invoke-interface {v11}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    :cond_10
    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1510
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    if-nez v10, :cond_11

    .line 1535
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->onCheckIfIgnoreWifiOnlyModeCheck()Z

    move-result v0

    if-nez v0, :cond_11

    .line 1536
    iget-object v0, v1, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    iget v3, v1, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    iget-object v5, v1, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {v0, v3, v5}, Lcom/android/internal/telephony/Phone;->checkWfcWifiOnlyModeBeforeDial(Lcom/android/internal/telephony/Phone;ILandroid/content/Context;)V

    :cond_11
    if-eqz v11, :cond_12

    if-nez v7, :cond_12

    if-nez v6, :cond_12

    if-eqz v9, :cond_12

    .line 1541
    invoke-virtual {v11}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    instance-of v0, v0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;

    if-eqz v0, :cond_12

    const-string v0, "WPS call placed over CS; disconnecting all IMS calls.."

    .line 1542
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    .line 1543
    invoke-virtual {v11}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;

    .line 1544
    invoke-virtual {v0}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;->hangupAllConnections()V

    :cond_12
    if-eqz v6, :cond_13

    if-eqz v14, :cond_15

    if-nez v15, :cond_15

    :cond_13
    if-eqz v14, :cond_14

    if-nez v8, :cond_15

    :cond_14
    if-eqz v12, :cond_18

    :cond_15
    :try_start_0
    const-string v0, "Trying IMS PS call"

    .line 1551
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1552
    invoke-interface {v2, v11}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_1

    move-object/from16 v3, p1

    .line 1553
    :try_start_1
    invoke-interface {v11, v4, v3}, Lcom/android/internal/telephony/PhoneInternalInterface;->dial(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;

    move-result-object v0
    :try_end_1
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_1 .. :try_end_1} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    goto :goto_c

    :catch_1
    move-exception v0

    move-object/from16 v3, p1

    .line 1555
    :goto_c
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "IMS PS call exception "

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo v7, "useImsForCall ="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, ", imsPhone ="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v5}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1559
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v5

    const-string v6, "cs_fallback"

    invoke-virtual {v6, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_17

    if-eqz v10, :cond_16

    goto :goto_d

    .line 1563
    :cond_16
    new-instance v1, Lcom/android/internal/telephony/CallStateException;

    invoke-virtual {v0}, Lcom/android/internal/telephony/CallStateException;->getError()I

    move-result v2

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v1, v2, v3}, Lcom/android/internal/telephony/CallStateException;-><init>(ILjava/lang/String;)V

    .line 1564
    invoke-virtual {v0}, Ljava/lang/Exception;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/Exception;->setStackTrace([Ljava/lang/StackTraceElement;)V

    .line 1565
    throw v1

    .line 1560
    :cond_17
    :goto_d
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "IMS call failed with Exception: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ". Falling back to CS."

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    goto :goto_e

    :cond_18
    move-object/from16 v3, p1

    .line 1570
    :goto_e
    iget-object v0, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-eqz v0, :cond_1a

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    const/4 v5, 0x1

    if-ne v0, v5, :cond_1a

    iget-object v0, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 1571
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v0

    if-eqz v0, :cond_1a

    if-nez v10, :cond_1a

    .line 1574
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->onCheckIfIgnoreServiceState()Z

    move-result v0

    if-eqz v0, :cond_19

    goto :goto_f

    .line 1575
    :cond_19
    new-instance v0, Lcom/android/internal/telephony/CallStateException;

    const-string v1, "cannot dial in current state"

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/CallStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1580
    :cond_1a
    :goto_f
    iget-object v0, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-eqz v0, :cond_1d

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    const/4 v5, 0x3

    if-ne v0, v5, :cond_1d

    iget v0, v3, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->videoState:I

    .line 1581
    invoke-static {v0}, Landroid/telecom/VideoProfile;->isVideo(I)Z

    move-result v0

    if-nez v0, :cond_1d

    if-nez v10, :cond_1d

    if-eqz v14, :cond_1b

    if-nez v8, :cond_1d

    :cond_1b
    if-eqz v15, :cond_1c

    goto :goto_10

    .line 1586
    :cond_1c
    new-instance v0, Lcom/android/internal/telephony/CallStateException;

    const/4 v1, 0x2

    const-string v2, "cannot dial voice call in airplane mode"

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/CallStateException;-><init>(ILjava/lang/String;)V

    throw v0

    .line 1592
    :cond_1d
    :goto_10
    iget-object v0, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-eqz v0, :cond_20

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 1593
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    const/4 v5, 0x1

    if-ne v0, v5, :cond_21

    iget-object v0, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 1594
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v0

    if-nez v0, :cond_1e

    iget-object v0, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 1596
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v0

    .line 1595
    invoke-static {v0}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v0

    if-nez v0, :cond_20

    :cond_1e
    iget v0, v3, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->videoState:I

    .line 1597
    invoke-static {v0}, Landroid/telecom/VideoProfile;->isVideo(I)Z

    move-result v0

    if-nez v0, :cond_20

    if-nez v10, :cond_20

    if-nez v15, :cond_20

    .line 1602
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->onCheckIfIgnoreServiceState()Z

    move-result v0

    if-eqz v0, :cond_1f

    goto :goto_11

    .line 1603
    :cond_1f
    new-instance v0, Lcom/android/internal/telephony/CallStateException;

    const-string v1, "cannot dial voice call in out of service"

    const/4 v5, 0x1

    invoke-direct {v0, v5, v1}, Lcom/android/internal/telephony/CallStateException;-><init>(ILjava/lang/String;)V

    throw v0

    :cond_20
    :goto_11
    const/4 v5, 0x1

    :cond_21
    const-string v0, "Trying (non-IMS) CS call"

    .line 1609
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    if-eqz v17, :cond_22

    if-eqz v10, :cond_22

    .line 1613
    iput-boolean v5, v1, Lcom/android/internal/telephony/GsmCdmaPhone;->mIsTestingEmergencyCallbackMode:Z

    .line 1614
    iget-object v0, v1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->testingEmergencyCall()V

    .line 1617
    :cond_22
    invoke-interface {v2, v1}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    .line 1618
    invoke-virtual {v1, v4, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->dialInternal(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;

    move-result-object v0

    return-object v0
.end method

.method protected dialInternal(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    const/4 v0, 0x0

    .line 1661
    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->dialInternal(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;Landroid/os/ResultReceiver;)Lcom/android/internal/telephony/Connection;

    move-result-object p0

    return-object p0
.end method

.method protected dialInternal(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;Landroid/os/ResultReceiver;)Lcom/android/internal/telephony/Connection;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 1669
    invoke-static {p1}, Landroid/telephony/PhoneNumberUtils;->stripSeparators(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1671
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_3

    .line 1673
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleInCallMmiCommands(Ljava/lang/String;)Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    return-object v2

    .line 1678
    :cond_0
    invoke-static {v0}, Landroid/telephony/PhoneNumberUtils;->extractNetworkPortionAlt(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 1684
    iget-object v3, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    .line 1685
    invoke-virtual {v3}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    .line 1684
    invoke-virtual {p0, v1, v3, p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->onCreateGsmMmiCode(Ljava/lang/String;Lcom/android/internal/telephony/uicc/UiccCardApplication;Landroid/os/ResultReceiver;)Lcom/android/internal/telephony/gsm/GsmMmiCode;

    move-result-object p3

    .line 1687
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "dialInternal: dialing w/ mmi \'"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, "\'..."

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    if-nez p3, :cond_1

    .line 1690
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0, v0, p2}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->dialGsm(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;

    move-result-object p0

    return-object p0

    .line 1691
    :cond_1
    invoke-virtual {p3}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->isTemporaryModeCLIR()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1692
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object p1, p3, Lcom/android/internal/telephony/gsm/GsmMmiCode;->mDialingNumber:Ljava/lang/String;

    invoke-virtual {p3}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->getCLIRMode()I

    move-result p3

    iget-object v0, p2, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    iget-object p2, p2, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->intentExtras:Landroid/os/Bundle;

    invoke-virtual {p0, p1, p3, v0, p2}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->dialGsm(Ljava/lang/String;ILcom/android/internal/telephony/UUSInfo;Landroid/os/Bundle;)Lcom/android/internal/telephony/Connection;

    move-result-object p0

    return-object p0

    .line 1695
    :cond_2
    iget-object p2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1697
    invoke-virtual {p0, p1, p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->onPendingMmiAdded(Ljava/lang/String;Lcom/android/internal/telephony/gsm/GsmMmiCode;)V

    .line 1699
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mMmiRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p1, Landroid/os/AsyncResult;

    invoke-direct {p1, v2, p3, v2}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    .line 1700
    invoke-virtual {p3}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->processCode()V

    return-object v2

    .line 1704
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0, v0, p2}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->dial(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;

    move-result-object p0

    return-object p0
.end method

.method public disableLocationUpdates()V
    .locals 0

    .line 2729
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->disableLocationUpdates()V

    return-void
.end method

.method public dispose()V
    .locals 1

    .line 1040
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->dispose()V

    .line 1041
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/SubscriptionController;->unregisterForUiccAppsEnabled(Landroid/os/Handler;)V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 1

    const-string v0, "GsmCdmaPhone extends:"

    .line 4334
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4335
    invoke-super {p0, p1, p2, p3}, Lcom/android/internal/telephony/Phone;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 4336
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mPrecisePhoneType="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4337
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mCT="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4338
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mSST="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4339
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mPendingMMIs="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4340
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mIccPhoneBookIntManager="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccPhoneBookIntManager:Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4341
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mImei="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImei:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->pii(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4342
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mImeiSv="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImeiSv:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->pii(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4343
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mVmNumber="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mVmNumber:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->pii(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4344
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mCdmaSSM="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4345
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mCdmaSubscriptionSource="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4346
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mWakeLock="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4347
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " isInEcm()="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4348
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mEsn="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEsn:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->pii(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4349
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mMeid="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mMeid:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->pii(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4350
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mCarrierOtaSpNumSchema="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierOtaSpNumSchema:Ljava/lang/String;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4351
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-nez p1, :cond_0

    .line 4352
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " getCdmaEriIconIndex()="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCdmaEriIconIndex()I

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4353
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " getCdmaEriIconMode()="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCdmaEriIconMode()I

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4354
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " getCdmaEriText()="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCdmaEriText()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4355
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " isMinInfoReady()="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isMinInfoReady()Z

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4357
    :cond_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " isCspPlmnEnabled()="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isCspPlmnEnabled()Z

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4358
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mManualNetworkSelectionPlmn="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mManualNetworkSelectionPlmn:Ljava/lang/String;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4359
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mTelecomVoiceServiceStateOverride="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mTelecomVoiceServiceStateOverride:I

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, "("

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mTelecomVoiceServiceStateOverride:I

    .line 4361
    invoke-static {p0}, Landroid/telephony/ServiceState;->rilServiceStateToString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 4359
    invoke-virtual {p2, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4363
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public enableEnhancedVoicePrivacy(ZLandroid/os/Message;)V
    .locals 1

    .line 1046
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "enableEnhancedVoicePrivacy: not expected on GSM"

    .line 1047
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 1049
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2}, Lcom/android/internal/telephony/CommandsInterface;->setPreferredVoicePrivacy(ZLandroid/os/Message;)V

    :goto_0
    return-void
.end method

.method public enableLocationUpdates()V
    .locals 0

    .line 2724
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->enableLocationUpdates()V

    return-void
.end method

.method public enableUiccApplications(ZLandroid/os/Message;)V
    .locals 2

    .line 4784
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlotForPhone(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 4785
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_PRESENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 4794
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2}, Lcom/android/internal/telephony/CommandsInterface;->enableUiccApplications(ZLandroid/os/Message;)V

    return-void

    :cond_1
    :goto_0
    if-eqz p2, :cond_2

    const/4 p0, 0x0

    .line 4787
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "No SIM card is present"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    invoke-static {p2, p0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 4789
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    :cond_2
    return-void
.end method

.method public exitEmergencyCallbackMode()V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 3792
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "exitEmergencyCallbackMode: mImsPhone="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " isPhoneTypeGsm="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3793
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "GsmCdmaPhone"

    .line 3792
    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 3795
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isInImsEcm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 3796
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->exitEmergencyCallbackMode()V

    goto :goto_0

    .line 3798
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->isHeld()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 3799
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->release()V

    :cond_1
    const/4 v0, 0x0

    .line 3802
    iget-boolean v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIsTestingEmergencyCallbackMode:Z

    if-eqz v1, :cond_2

    const/16 v0, 0x1a

    .line 3807
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 3809
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, v0}, Lcom/android/internal/telephony/CommandsInterface;->exitEmergencyCallbackMode(Landroid/os/Message;)V

    :goto_0
    return-void
.end method

.method public explicitCallTransfer()V
    .locals 1

    .line 1079
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1080
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->explicitCallTransfer()V

    goto :goto_0

    :cond_0
    const-string v0, "explicitCallTransfer: not possible in CDMA"

    .line 1082
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method protected finalize()V
    .locals 2

    const-string v0, "GsmCdmaPhone finalized"

    .line 622
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 623
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->isHeld()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "GsmCdmaPhone"

    const-string v1, "UNEXPECTED; mWakeLock is held when finalizing."

    .line 624
    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 625
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {p0}, Landroid/os/PowerManager$WakeLock;->release()V

    :cond_0
    return-void
.end method

.method public getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;
    .locals 0

    .line 700
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    return-object p0
.end method

.method public getAvailableNetworks(Landroid/os/Message;)V
    .locals 1

    .line 2673
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const-string p1, "getAvailableNetworks: not possible in CDMA"

    .line 2677
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_1

    :cond_1
    :goto_0
    const/16 v0, 0x33

    .line 2674
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 2675
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->getAvailableNetworks(Landroid/os/Message;)V

    :goto_1
    return-void
.end method

.method public bridge synthetic getBackgroundCall()Lcom/android/internal/telephony/Call;
    .locals 0

    .line 141
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getBackgroundCall()Lcom/android/internal/telephony/GsmCdmaCall;

    move-result-object p0

    return-object p0
.end method

.method public getBackgroundCall()Lcom/android/internal/telephony/GsmCdmaCall;
    .locals 0

    .line 1093
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mBackgroundCall:Lcom/android/internal/telephony/GsmCdmaCall;

    return-object p0
.end method

.method public getCallBarring(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;I)V
    .locals 2

    .line 2495
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2496
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2497
    invoke-interface {v0, p1, p2, p3, p4}, Lcom/android/internal/telephony/PhoneInternalInterface;->getCallBarring(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;I)V

    return-void

    .line 2501
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2502
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2, p4, p3}, Lcom/android/internal/telephony/CommandsInterface;->queryFacilityLock(Ljava/lang/String;Ljava/lang/String;ILandroid/os/Message;)V

    goto :goto_0

    :cond_1
    const-string p1, "getCallBarringOption: not possible in CDMA"

    .line 2504
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public getCallForwardingOption(IILandroid/os/Message;)V
    .locals 2

    .line 2393
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2394
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2395
    invoke-interface {v0, p1, p2, p3}, Lcom/android/internal/telephony/PhoneInternalInterface;->getCallForwardingOption(IILandroid/os/Message;)V

    return-void

    .line 2399
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 2400
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isValidCommandInterfaceCFReason(I)Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, "requesting call forwarding query."

    .line 2401
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    if-nez p1, :cond_1

    const/16 v0, 0xd

    .line 2404
    invoke-virtual {p0, v0, p3}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p3

    .line 2408
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2, v1, p3}, Lcom/android/internal/telephony/CommandsInterface;->queryCallForwardStatus(IILjava/lang/String;Landroid/os/Message;)V

    goto :goto_1

    .line 2411
    :cond_2
    iget-boolean p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsOverCdmaSupported:Z

    if-nez p1, :cond_3

    .line 2414
    new-instance p0, Lcom/android/internal/telephony/CommandException;

    sget-object p1, Lcom/android/internal/telephony/CommandException$Error;->INVALID_STATE:Lcom/android/internal/telephony/CommandException$Error;

    const-string p2, "Call Forwarding over CDMA unavailable"

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/CommandException;-><init>(Lcom/android/internal/telephony/CommandException$Error;Ljava/lang/String;)V

    invoke-static {p3, v1, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    goto :goto_0

    :cond_3
    const-string p1, "getCallForwardingOption: not possible in CDMA, just return empty result"

    .line 2418
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 2419
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->makeEmptyCallForward()[Lcom/android/internal/telephony/CallForwardInfo;

    move-result-object p0

    invoke-static {p3, p0, v1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2421
    :goto_0
    invoke-virtual {p3}, Landroid/os/Message;->sendToTarget()V

    :cond_4
    :goto_1
    return-void
.end method

.method public getCallForwardingOption(ILandroid/os/Message;)V
    .locals 1

    const/4 v0, 0x1

    .line 2386
    invoke-virtual {p0, p1, v0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCallForwardingOption(IILandroid/os/Message;)V

    return-void
.end method

.method public getCallTracker()Lcom/android/internal/telephony/CallTracker;
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 690
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    return-object p0
.end method

.method public getCallWaiting(Landroid/os/Message;)V
    .locals 3

    .line 2601
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2602
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2603
    invoke-interface {v0, p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getCallWaiting(Landroid/os/Message;)V

    return-void

    .line 2607
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2610
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p0, v0, p1}, Lcom/android/internal/telephony/CommandsInterface;->queryCallWaiting(ILandroid/os/Message;)V

    goto :goto_1

    .line 2612
    :cond_1
    iget-boolean p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsOverCdmaSupported:Z

    const/4 v0, 0x0

    if-nez p0, :cond_2

    .line 2615
    new-instance p0, Lcom/android/internal/telephony/CommandException;

    sget-object v1, Lcom/android/internal/telephony/CommandException$Error;->INVALID_STATE:Lcom/android/internal/telephony/CommandException$Error;

    const-string v2, "Call Waiting over CDMA unavailable"

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/CommandException;-><init>(Lcom/android/internal/telephony/CommandException$Error;Ljava/lang/String;)V

    invoke-static {p1, v0, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    goto :goto_0

    :cond_2
    const/4 p0, 0x2

    new-array p0, p0, [I

    .line 2619
    fill-array-data p0, :array_0

    .line 2621
    invoke-static {p1, p0, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2623
    :goto_0
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    :goto_1
    return-void

    :array_0
    .array-data 4
        0xff
        0x0
    .end array-data
.end method

.method public getCarrierId()I
    .locals 1

    .line 2073
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    if-eqz v0, :cond_0

    .line 2074
    invoke-virtual {v0}, Lcom/android/internal/telephony/CarrierResolver;->getCarrierId()I

    move-result p0

    goto :goto_0

    :cond_0
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p0

    :goto_0
    return p0
.end method

.method public getCarrierIdListVersion()I
    .locals 1

    .line 2110
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    if-eqz v0, :cond_0

    .line 2111
    invoke-virtual {v0}, Lcom/android/internal/telephony/CarrierResolver;->getCarrierListVersion()I

    move-result p0

    goto :goto_0

    :cond_0
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getCarrierIdListVersion()I

    move-result p0

    :goto_0
    return p0
.end method

.method public getCarrierInfoForImsiEncryption(IZ)Landroid/telephony/ImsiEncryptionInfo;
    .locals 7

    .line 2051
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-class v1, Landroid/telephony/TelephonyManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    .line 2052
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object v0

    .line 2053
    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getSimOperator()Ljava/lang/String;

    move-result-object v3

    .line 2054
    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getSimCarrierId()I

    move-result v4

    .line 2055
    iget-object v2, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    .line 2056
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v6

    move v1, p1

    move v5, p2

    .line 2055
    invoke-static/range {v1 .. v6}, Lcom/android/internal/telephony/CarrierInfoManager;->getCarrierInfoForImsiEncryption(ILandroid/content/Context;Ljava/lang/String;IZI)Landroid/telephony/ImsiEncryptionInfo;

    move-result-object p0

    return-object p0
.end method

.method public getCarrierName()Ljava/lang/String;
    .locals 1

    .line 2079
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    if-eqz v0, :cond_0

    .line 2080
    invoke-virtual {v0}, Lcom/android/internal/telephony/CarrierResolver;->getCarrierName()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getCarrierName()Ljava/lang/String;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method public getCarrierPrivilegesTracker()Lcom/android/internal/telephony/CarrierPrivilegesTracker;
    .locals 0

    .line 1122
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierPrivilegesTracker:Lcom/android/internal/telephony/CarrierPrivilegesTracker;

    return-object p0
.end method

.method public getCdmaEriIconIndex()I
    .locals 1

    .line 4105
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4106
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getCdmaEriIconIndex()I

    move-result p0

    return p0

    .line 4108
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getCdmaEriIconIndex()I

    move-result p0

    return p0
.end method

.method public getCdmaEriIconMode()I
    .locals 1

    .line 4119
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4120
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getCdmaEriIconMode()I

    move-result p0

    return p0

    .line 4122
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getCdmaEriIconMode()I

    move-result p0

    return p0
.end method

.method public getCdmaEriText()Ljava/lang/String;
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 4132
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4133
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getCdmaEriText()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 4135
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getCdmaRoamingIndicator()I

    move-result v0

    .line 4136
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getCdmaDefaultRoamingIndicator()I

    move-result v1

    .line 4137
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->getCdmaEriText(II)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getCdmaMin()Ljava/lang/String;
    .locals 0

    .line 2245
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCdmaMin()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getCdmaPrlVersion()Ljava/lang/String;
    .locals 0

    .line 2240
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPrlVersion()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getCellBroadcastSmsConfig(Landroid/os/Message;)V
    .locals 1

    const-string v0, "[GsmCdmaPhone] getCellBroadcastSmsConfig() is obsolete; use SmsManager"

    .line 3657
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 3658
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public getCellIdentity(Landroid/os/WorkSource;Landroid/os/Message;)V
    .locals 0

    .line 651
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->requestCellIdentity(Landroid/os/WorkSource;Landroid/os/Message;)V

    return-void
.end method

.method public getCountryIso()Ljava/lang/String;
    .locals 1

    .line 4476
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 4477
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/telephony/SubscriptionManager;->from(Landroid/content/Context;)Landroid/telephony/SubscriptionManager;

    move-result-object p0

    .line 4478
    invoke-virtual {p0, v0}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfo(I)Landroid/telephony/SubscriptionInfo;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 4479
    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getCountryIso()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 4482
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getCountryIso()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public getCsCallRadioTech()I
    .locals 2

    .line 4507
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-eqz v0, :cond_0

    .line 4508
    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object v1, v1, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 4509
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v1

    .line 4508
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCsCallRadioTech(II)I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public getDataActivityState()I
    .locals 6

    .line 796
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 797
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataActivity()I

    move-result p0

    return p0

    .line 801
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCurrentDataConnectionState()I

    move-result v0

    const/4 v1, 0x4

    const/4 v2, 0x3

    const/4 v3, 0x2

    const/4 v4, 0x0

    const/4 v5, 0x1

    if-nez v0, :cond_4

    .line 802
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 803
    sget-object v0, Lcom/android/internal/telephony/GsmCdmaPhone$4;->$SwitchMap$com$android$internal$telephony$DctConstants$Activity:[I

    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getActivity()Lcom/android/internal/telephony/DctConstants$Activity;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/DctConstants$Activity;->ordinal()I

    move-result p0

    aget p0, v0, p0

    if-eq p0, v5, :cond_3

    if-eq p0, v3, :cond_2

    if-eq p0, v2, :cond_1

    if-eq p0, v1, :cond_5

    goto :goto_0

    :cond_1
    move v1, v2

    goto :goto_1

    :cond_2
    move v1, v3

    goto :goto_1

    :cond_3
    move v1, v5

    goto :goto_1

    :cond_4
    :goto_0
    move v1, v4

    :cond_5
    :goto_1
    return v1
.end method

.method public getDataConnectionState(Ljava/lang/String;)Lcom/android/internal/telephony/PhoneConstants$DataState;
    .locals 3

    .line 751
    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$DataState;->DISCONNECTED:Lcom/android/internal/telephony/PhoneConstants$DataState;

    .line 753
    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-nez v1, :cond_0

    goto :goto_0

    .line 758
    :cond_0
    invoke-virtual {v1}, Lcom/android/internal/telephony/ServiceStateTracker;->getCurrentDataConnectionState()I

    move-result v1

    if-eqz v1, :cond_2

    .line 759
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v1

    if-nez v1, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v1

    if-nez v1, :cond_1

    .line 760
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v1, "emergency"

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 767
    :cond_1
    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$DataState;->DISCONNECTED:Lcom/android/internal/telephony/PhoneConstants$DataState;

    goto :goto_0

    .line 769
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 770
    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypesBitmaskFromString(Ljava/lang/String;)I

    move-result v2

    .line 769
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getCurrentTransport(I)I

    move-result v1

    .line 771
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v2

    if-eqz v2, :cond_6

    .line 772
    sget-object v0, Lcom/android/internal/telephony/GsmCdmaPhone$4;->$SwitchMap$com$android$internal$telephony$DctConstants$State:[I

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v1

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getState(Ljava/lang/String;)Lcom/android/internal/telephony/DctConstants$State;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/DctConstants$State;->ordinal()I

    move-result v1

    aget v0, v0, v1

    const/4 v1, 0x1

    if-eq v0, v1, :cond_4

    const/4 v1, 0x2

    if-eq v0, v1, :cond_4

    const/4 v1, 0x3

    if-eq v0, v1, :cond_3

    .line 785
    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$DataState;->DISCONNECTED:Lcom/android/internal/telephony/PhoneConstants$DataState;

    goto :goto_0

    .line 782
    :cond_3
    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$DataState;->CONNECTING:Lcom/android/internal/telephony/PhoneConstants$DataState;

    goto :goto_0

    .line 775
    :cond_4
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isDataSuspended()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 776
    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$DataState;->SUSPENDED:Lcom/android/internal/telephony/PhoneConstants$DataState;

    goto :goto_0

    .line 778
    :cond_5
    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$DataState;->CONNECTED:Lcom/android/internal/telephony/PhoneConstants$DataState;

    .line 790
    :cond_6
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getDataConnectionState apnType="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " ret="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return-object v0
.end method

.method public getDataRoamingEnabled()Z
    .locals 2

    .line 2734
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2735
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataRoamingEnabled()Z

    move-result p0

    return p0

    :cond_0
    const/4 v0, 0x1

    .line 2737
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 2738
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataRoamingEnabled()Z

    move-result p0

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public getDataServicePackages()Ljava/util/List;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 4822
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4823
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataServicePackages()Ljava/util/List;

    move-result-object p0

    return-object p0

    .line 4825
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x2

    new-array v2, v1, [I

    .line 4826
    fill-array-data v2, :array_0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_2

    .line 4829
    aget v4, v2, v3

    .line 4830
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v4

    if-eqz v4, :cond_1

    .line 4832
    invoke-virtual {v4}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataServiceManager()Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    move-result-object v4

    invoke-virtual {v4}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->getDataServicePackageName()Ljava/lang/String;

    move-result-object v4

    .line 4833
    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_1

    .line 4834
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return-object v0

    :array_0
    .array-data 4
        0x1
        0x2
    .end array-data
.end method

.method public getDeviceId()Ljava/lang/String;
    .locals 2

    .line 1969
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1970
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImei:Ljava/lang/String;

    return-object p0

    .line 1972
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-string v1, "carrier_config"

    .line 1973
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 1974
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v1, "force_imei_bool"

    .line 1975
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1976
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImei:Ljava/lang/String;

    return-object p0

    .line 1978
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getMeid()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    const-string v1, "^0*$"

    .line 1979
    invoke-virtual {v0, v1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3

    :cond_2
    const-string v0, "getDeviceId(): MEID is not initialized use ESN"

    .line 1980
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 1981
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getEsn()Ljava/lang/String;

    move-result-object v0

    :cond_3
    return-object v0
.end method

.method public getDeviceStateMonitor()Lcom/android/internal/telephony/DeviceStateMonitor;
    .locals 0

    .line 705
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mDeviceStateMonitor:Lcom/android/internal/telephony/DeviceStateMonitor;

    return-object p0
.end method

.method public getDeviceSvn()Ljava/lang/String;
    .locals 1

    .line 1989
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const-string v0, "getDeviceSvn(): return 0"

    .line 1992
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const-string p0, "0"

    return-object p0

    .line 1990
    :cond_1
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImeiSv:Ljava/lang/String;

    return-object p0
.end method

.method public getDisplayInfoController()Lcom/android/internal/telephony/DisplayInfoController;
    .locals 0

    .line 710
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mDisplayInfoController:Lcom/android/internal/telephony/DisplayInfoController;

    return-object p0
.end method

.method public getDtmfToneDelayKey()Ljava/lang/String;
    .locals 0

    .line 4672
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p0

    if-eqz p0, :cond_0

    const-string p0, "gsm_dtmf_tone_delay_int"

    goto :goto_0

    :cond_0
    const-string p0, "cdma_dtmf_tone_delay_int"

    :goto_0
    return-object p0
.end method

.method public getEmergencyNumberDbVersion()I
    .locals 0

    .line 2116
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getEmergencyNumberTracker()Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;->getEmergencyNumberDbVersion()I

    move-result p0

    return p0
.end method

.method public getEmergencyNumberTracker()Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;
    .locals 0

    .line 684
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEmergencyNumberTracker:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    return-object p0
.end method

.method public getEnhancedVoicePrivacy(Landroid/os/Message;)V
    .locals 1

    .line 1055
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "getEnhancedVoicePrivacy: not expected on GSM"

    .line 1056
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 1058
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->getPreferredVoicePrivacy(Landroid/os/Message;)V

    :goto_0
    return-void
.end method

.method public getEquivalentHomePlmns()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 4807
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4808
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_1

    .line 4809
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getEhplmns()[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 4810
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getEhplmns()[Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    return-object p0

    .line 4812
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "EHPLMN is not available in CDMA"

    .line 4813
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 4815
    :cond_1
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getEsn()Ljava/lang/String;
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2010
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "[GsmCdmaPhone] getEsn() is a CDMA method"

    .line 2011
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const-string p0, "0"

    return-object p0

    .line 2014
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEsn:Ljava/lang/String;

    return-object p0
.end method

.method public bridge synthetic getForegroundCall()Lcom/android/internal/telephony/Call;
    .locals 0

    .line 141
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getForegroundCall()Lcom/android/internal/telephony/GsmCdmaCall;

    move-result-object p0

    return-object p0
.end method

.method public getForegroundCall()Lcom/android/internal/telephony/GsmCdmaCall;
    .locals 0

    .line 1088
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mForegroundCall:Lcom/android/internal/telephony/GsmCdmaCall;

    return-object p0
.end method

.method public getFullIccSerialNumber()Ljava/lang/String;
    .locals 2

    .line 996
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    .line 997
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-nez v1, :cond_0

    if-nez v0, :cond_0

    .line 999
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getIccRecords(II)Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object v0

    :cond_0
    if-eqz v0, :cond_1

    .line 1001
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getFullIccId()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getGroupIdLevel1()Ljava/lang/String;
    .locals 2

    .line 2160
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2161
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 2162
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getGid1()Ljava/lang/String;

    move-result-object v1

    :cond_0
    return-object v1

    .line 2163
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "GID1 is not available in CDMA"

    .line 2164
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-object v1

    .line 2167
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz p0, :cond_3

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getGid1()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_3
    const-string p0, ""

    :goto_0
    return-object p0
.end method

.method public getGroupIdLevel2()Ljava/lang/String;
    .locals 2

    .line 2173
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2174
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 2175
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getGid2()Ljava/lang/String;

    move-result-object v1

    :cond_0
    return-object v1

    .line 2176
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "GID2 is not available in CDMA"

    .line 2177
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-object v1

    .line 2180
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz p0, :cond_3

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getGid2()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_3
    const-string p0, ""

    :goto_0
    return-object p0
.end method

.method public getIccCard()Lcom/android/internal/telephony/IccCard;
    .locals 1

    .line 4314
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object v0

    if-eqz v0, :cond_0

    return-object v0

    .line 4318
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlotForPhone(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p0

    if-eqz p0, :cond_2

    .line 4319
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccSlot;->isStateUnknown()Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_0

    .line 4322
    :cond_1
    new-instance p0, Lcom/android/internal/telephony/IccCard;

    sget-object v0, Lcom/android/internal/telephony/IccCardConstants$State;->ABSENT:Lcom/android/internal/telephony/IccCardConstants$State;

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/IccCard;-><init>(Lcom/android/internal/telephony/IccCardConstants$State;)V

    return-object p0

    .line 4320
    :cond_2
    :goto_0
    new-instance p0, Lcom/android/internal/telephony/IccCard;

    sget-object v0, Lcom/android/internal/telephony/IccCardConstants$State;->UNKNOWN:Lcom/android/internal/telephony/IccCardConstants$State;

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/IccCard;-><init>(Lcom/android/internal/telephony/IccCardConstants$State;)V

    return-object p0
.end method

.method public getIccPhoneBookInterfaceManager()Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;
    .locals 0

    .line 3635
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccPhoneBookIntManager:Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    return-object p0
.end method

.method public getIccRecordsLoaded()Z
    .locals 0

    .line 4305
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 4306
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->getIccRecordsLoaded()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public getIccSerialNumber()Ljava/lang/String;
    .locals 2

    .line 986
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    .line 987
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-nez v1, :cond_0

    if-nez v0, :cond_0

    .line 989
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getIccRecords(II)Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object v0

    :cond_0
    if-eqz v0, :cond_1

    .line 991
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getIccId()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getIccSmsInterfaceManager()Lcom/android/internal/telephony/IccSmsInterfaceManager;
    .locals 0

    .line 4289
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccSmsInterfaceManager:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    return-object p0
.end method

.method public getImei()Ljava/lang/String;
    .locals 0

    .line 2004
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImei:Ljava/lang/String;

    return-object p0
.end method

.method public getInboundSmsHandler(Z)Lcom/android/internal/telephony/InboundSmsHandler;
    .locals 0

    .line 4986
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccSmsInterfaceManager:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/IccSmsInterfaceManager;->getInboundSmsHandler(Z)Lcom/android/internal/telephony/InboundSmsHandler;

    move-result-object p0

    return-object p0
.end method

.method public getIsimRecords()Lcom/android/internal/telephony/uicc/IsimRecords;
    .locals 0

    .line 1999
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIsimUiccRecords:Lcom/android/internal/telephony/uicc/IsimUiccRecords;

    return-object p0
.end method

.method public getLine1AlphaTag()Ljava/lang/String;
    .locals 2

    .line 2268
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2269
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 2270
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getMsisdnAlphaTag()Ljava/lang/String;

    move-result-object v1

    :cond_0
    return-object v1

    :cond_1
    const-string v0, "getLine1AlphaTag: not possible in CDMA"

    .line 2272
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-object v1
.end method

.method public getLine1Number()Ljava/lang/String;
    .locals 3
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2187
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2188
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 2189
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getMsisdnNumber()Ljava/lang/String;

    move-result-object v1

    :cond_0
    return-object v1

    .line 2191
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-string v2, "carrier_config"

    .line 2192
    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 2193
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v0, v2}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    const-string/jumbo v2, "use_usim_bool"

    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 2196
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz p0, :cond_2

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SIMRecords;->getMsisdnNumber()Ljava/lang/String;

    move-result-object v1

    :cond_2
    return-object v1

    .line 2198
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getMdnNumber()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getLteOnCdmaMode()I
    .locals 4

    .line 4683
    invoke-static {}, Landroid/internal/telephony/sysprop/TelephonyProperties;->lte_on_cdma_device()Ljava/util/Optional;

    move-result-object v0

    const/4 v1, 0x0

    .line 4684
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 4687
    iget-object v2, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v3, 0x2

    .line 4688
    invoke-virtual {v2, p0, v3}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 4689
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getType()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object p0

    sget-object v2, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;->APPTYPE_RUIM:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    if-ne p0, v2, :cond_0

    const/4 p0, 0x1

    if-ne v0, p0, :cond_0

    return v1

    :cond_0
    return v0
.end method

.method public getMNOCarrierId()I
    .locals 1

    .line 2085
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    if-eqz v0, :cond_0

    .line 2086
    invoke-virtual {v0}, Lcom/android/internal/telephony/CarrierResolver;->getMnoCarrierId()I

    move-result p0

    goto :goto_0

    :cond_0
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getMNOCarrierId()I

    move-result p0

    :goto_0
    return p0
.end method

.method public getManualNetworkSelectionPlmn()Ljava/lang/String;
    .locals 0

    .line 2235
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mManualNetworkSelectionPlmn:Ljava/lang/String;

    if-nez p0, :cond_0

    const-string p0, ""

    :cond_0
    return-object p0
.end method

.method public getMeid()Ljava/lang/String;
    .locals 0

    .line 2020
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mMeid:Ljava/lang/String;

    return-object p0
.end method

.method public getMsisdn()Ljava/lang/String;
    .locals 2

    .line 2255
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2256
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 2257
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getMsisdnNumber()Ljava/lang/String;

    move-result-object v1

    :cond_0
    return-object v1

    .line 2258
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 2259
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz p0, :cond_2

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SIMRecords;->getMsisdnNumber()Ljava/lang/String;

    move-result-object v1

    :cond_2
    return-object v1

    :cond_3
    const-string v0, "getMsisdn: not expected on CDMA"

    .line 2261
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-object v1
.end method

.method public getMute()Z
    .locals 0

    .line 2714
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->getMute()Z

    move-result p0

    return p0
.end method

.method public getNai()Ljava/lang/String;
    .locals 3

    .line 2025
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x2

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getIccRecords(II)Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object p0

    const-string v0, "GsmCdmaPhone"

    .line 2026
    invoke-static {v0, v1}, Landroid/util/Log;->isLoggable(Ljava/lang/String;I)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2027
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "IccRecords is "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->v(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    if-eqz p0, :cond_1

    .line 2029
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getNAI()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getOperatorNumeric()Ljava/lang/String;
    .locals 5

    .line 4429
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 4430
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_8

    .line 4432
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    goto/16 :goto_2

    .line 4436
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    const/4 v2, 0x1

    if-ne v0, v2, :cond_1

    const-string v0, "ro.cdma.home.operator.numeric"

    .line 4437
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    move-object v2, v0

    move-object v0, v1

    goto :goto_1

    :cond_1
    if-nez v0, :cond_5

    .line 4439
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    if-eqz v0, :cond_2

    .line 4441
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getType()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object v0

    sget-object v2, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;->APPTYPE_RUIM:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    if-ne v0, v2, :cond_2

    const-string v0, "Legacy RUIM app present"

    .line 4442
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4443
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    goto :goto_0

    .line 4446
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    :goto_0
    if-eqz v0, :cond_3

    .line 4448
    iget-object v2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-ne v0, v2, :cond_3

    .line 4449
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    .line 4451
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v0, :cond_4

    .line 4452
    instance-of v2, v0, Lcom/android/internal/telephony/uicc/RuimRecords;

    if-eqz v2, :cond_4

    .line 4453
    move-object v2, v0

    check-cast v2, Lcom/android/internal/telephony/uicc/RuimRecords;

    .line 4454
    invoke-virtual {v2}, Lcom/android/internal/telephony/uicc/RuimRecords;->getRUIMOperatorNumeric()Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    :cond_4
    move-object v2, v1

    goto :goto_1

    :cond_5
    move-object v0, v1

    move-object v2, v0

    :goto_1
    if-nez v2, :cond_7

    .line 4459
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "getOperatorNumeric: Cannot retrieve operatorNumeric: mCdmaSubscriptionSource = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " mIccRecords = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v0, :cond_6

    .line 4462
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getRecordsLoaded()Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    :cond_6
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 4459
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 4465
    :cond_7
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getOperatorNumeric: mCdmaSubscriptionSource = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " operatorNumeric = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    move-object v1, v2

    .line 4469
    :cond_8
    :goto_2
    invoke-static {v1}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getOtasp()I
    .locals 0

    .line 4100
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOtasp()I

    move-result p0

    return p0
.end method

.method public getOutgoingCallerIdDisplay(Landroid/os/Message;)V
    .locals 2

    .line 2543
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2544
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2545
    invoke-interface {v0, p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getOutgoingCallerIdDisplay(Landroid/os/Message;)V

    return-void

    .line 2549
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2550
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->getCLIR(Landroid/os/Message;)V

    goto :goto_0

    :cond_1
    const-string v0, "getOutgoingCallerIdDisplay: not possible in CDMA"

    .line 2552
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    .line 2553
    new-instance v0, Lcom/android/internal/telephony/CommandException;

    sget-object v1, Lcom/android/internal/telephony/CommandException$Error;->REQUEST_NOT_SUPPORTED:Lcom/android/internal/telephony/CommandException$Error;

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/CommandException;-><init>(Lcom/android/internal/telephony/CommandException$Error;)V

    invoke-static {p1, p0, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2555
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    :goto_0
    return-void
.end method

.method public getPendingMmiCodes()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "+",
            "Lcom/android/internal/telephony/MmiCode;",
            ">;"
        }
    .end annotation

    .line 741
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    return-object p0
.end method

.method public getPhoneType()I
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 670
    iget p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    return v0

    :cond_0
    const/4 p0, 0x2

    return p0
.end method

.method public getPlmn()Ljava/lang/String;
    .locals 2

    .line 2204
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2205
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 2206
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getPnnHomeName()Ljava/lang/String;

    move-result-object v1

    :cond_0
    return-object v1

    .line 2207
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "Plmn is not available in CDMA"

    .line 2208
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-object v1

    .line 2211
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz p0, :cond_3

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getPnnHomeName()Ljava/lang/String;

    move-result-object v1

    :cond_3
    return-object v1
.end method

.method public getRingingCall()Lcom/android/internal/telephony/Call;
    .locals 2

    .line 1098
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_0

    .line 1106
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Call;->isRinging()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1107
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object p0

    return-object p0

    .line 1110
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mRingingCall:Lcom/android/internal/telephony/GsmCdmaCall;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->isRinging()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    .line 1111
    invoke-virtual {v0}, Lcom/android/internal/telephony/CallTracker;->getRingingHandoverConnection()Lcom/android/internal/telephony/Connection;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    .line 1112
    invoke-virtual {v0}, Lcom/android/internal/telephony/CallTracker;->getRingingHandoverConnection()Lcom/android/internal/telephony/Connection;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getCall()Lcom/android/internal/telephony/Call;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    .line 1113
    invoke-virtual {v0}, Lcom/android/internal/telephony/CallTracker;->getRingingHandoverConnection()Lcom/android/internal/telephony/Connection;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getCall()Lcom/android/internal/telephony/Call;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->isRinging()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1114
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/CallTracker;->getRingingHandoverConnection()Lcom/android/internal/telephony/Connection;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Connection;->getCall()Lcom/android/internal/telephony/Call;

    move-result-object p0

    return-object p0

    .line 1116
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mRingingCall:Lcom/android/internal/telephony/GsmCdmaCall;

    return-object p0
.end method

.method public getServiceState()Landroid/telephony/ServiceState;
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 633
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    goto :goto_0

    :cond_0
    new-instance v0, Landroid/telephony/ServiceState;

    invoke-direct {v0}, Landroid/telephony/ServiceState;-><init>()V

    .line 634
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v1, :cond_1

    invoke-interface {v1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    goto :goto_1

    :cond_1
    new-instance v1, Landroid/telephony/ServiceState;

    invoke-direct {v1}, Landroid/telephony/ServiceState;-><init>()V

    .line 635
    :goto_1
    iget p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mTelecomVoiceServiceStateOverride:I

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->mergeVoiceServiceStates(Landroid/telephony/ServiceState;Landroid/telephony/ServiceState;I)Landroid/telephony/ServiceState;

    move-result-object p0

    return-object p0
.end method

.method public getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;
    .locals 0

    .line 679
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    return-object p0
.end method

.method public getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;
    .locals 0

    .line 715
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mSignalStrengthController:Lcom/android/internal/telephony/SignalStrengthController;

    return-object p0
.end method

.method public getSpecificCarrierId()I
    .locals 1

    .line 2091
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    if-eqz v0, :cond_0

    .line 2092
    invoke-virtual {v0}, Lcom/android/internal/telephony/CarrierResolver;->getSpecificCarrierId()I

    move-result p0

    goto :goto_0

    :cond_0
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getSpecificCarrierId()I

    move-result p0

    :goto_0
    return p0
.end method

.method public getSpecificCarrierName()Ljava/lang/String;
    .locals 1

    .line 2097
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    if-eqz v0, :cond_0

    .line 2098
    invoke-virtual {v0}, Lcom/android/internal/telephony/CarrierResolver;->getSpecificCarrierName()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->getSpecificCarrierName()Ljava/lang/String;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method public getState()Lcom/android/internal/telephony/PhoneConstants$State;
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 657
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_0

    .line 658
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object v0

    .line 659
    sget-object v1, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    if-eq v0, v1, :cond_0

    return-object v0

    .line 664
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mState:Lcom/android/internal/telephony/PhoneConstants$State;

    return-object p0
.end method

.method public getSubscriberId()Ljava/lang/String;
    .locals 2

    .line 2036
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2037
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getImsi()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    .line 2040
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getIccRecords(II)Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 2043
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getIMSI()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getSystemProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2328
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getUnitTestMode()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 2331
    :cond_0
    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-static {p0, p1, p2}, Landroid/telephony/TelephonyManager;->getTelephonyProperty(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getTransportManager()Lcom/android/internal/telephony/dataconnection/TransportManager;
    .locals 0

    .line 695
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mTransportManager:Lcom/android/internal/telephony/dataconnection/TransportManager;

    return-object p0
.end method

.method public getUiccCardApplication()Lcom/android/internal/telephony/uicc/UiccCardApplication;
    .locals 2

    .line 3444
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 3445
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    return-object p0

    .line 3447
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x2

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    return-object p0
.end method

.method protected getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;
    .locals 1

    .line 4329
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v0

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccProfileForPhone(I)Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object p0

    return-object p0
.end method

.method public getVoiceMailAlphaTag()Ljava/lang/String;
    .locals 2

    .line 1953
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const-string v1, ""

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz v0, :cond_2

    .line 1954
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    goto :goto_0

    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    :goto_0
    if-eqz v0, :cond_2

    .line 1956
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getVoiceMailAlphaTag()Ljava/lang/String;

    move-result-object v0

    move-object v1, v0

    :cond_2
    if-eqz v1, :cond_4

    .line 1959
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_3

    goto :goto_1

    :cond_3
    return-object v1

    .line 1960
    :cond_4
    :goto_1
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const v0, 0x1040004

    invoke-virtual {p0, v0}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object p0

    .line 1961
    invoke-interface {p0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getVoiceMailNumber()Ljava/lang/String;
    .locals 7

    .line 1876
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const-string/jumbo v1, "vm_number_key_cdma"

    const/4 v2, 0x0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    move-object v0, v2

    goto/16 :goto_4

    .line 1878
    :cond_1
    :goto_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    goto :goto_1

    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    :goto_1
    if-eqz v0, :cond_3

    .line 1879
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getVoiceMailNumber()Ljava/lang/String;

    move-result-object v0

    goto :goto_2

    :cond_3
    const-string v0, ""

    .line 1880
    :goto_2
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    const-string v4, "GsmCdmaPhone"

    if-eqz v3, :cond_5

    .line 1881
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1882
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-eqz v3, :cond_4

    const-string/jumbo v3, "vm_number_key"

    goto :goto_3

    :cond_4
    move-object v3, v1

    .line 1883
    :goto_3
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v0, v5, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1884
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "getVoiceMailNumber: from "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " number="

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1885
    invoke-static {v4, v0}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 1884
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto :goto_4

    .line 1887
    :cond_5
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "getVoiceMailNumber: from IccRecords number="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v4, v0}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1890
    :goto_4
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-nez v3, :cond_6

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_6

    .line 1891
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1892
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1893
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getVoiceMailNumber: from VM_NUMBER_CDMA number="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1896
    :cond_6
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const-string v2, "carrier_config"

    if-eqz v1, :cond_9

    .line 1898
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/CarrierConfigManager;

    .line 1899
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v3

    invoke-virtual {v1, v3}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v1

    if-eqz v1, :cond_9

    const-string v3, "default_vm_number_string"

    .line 1902
    invoke-virtual {v1, v3}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v4, "default_vm_number_roaming_string"

    .line 1904
    invoke-virtual {v1, v4}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "default_vm_number_roaming_and_ims_unregistered_string"

    .line 1905
    invoke-virtual {v1, v5}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 1909
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_7

    move-object v0, v3

    .line 1910
    :cond_7
    iget-object v3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getRoaming()Z

    move-result v3

    if-eqz v3, :cond_9

    .line 1911
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_8

    iget-object v3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    .line 1912
    invoke-virtual {v3}, Lcom/android/internal/telephony/ServiceStateTracker;->isImsRegistered()Z

    move-result v3

    if-nez v3, :cond_8

    move-object v0, v1

    goto :goto_5

    .line 1915
    :cond_8
    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_9

    move-object v0, v4

    .line 1923
    :cond_9
    :goto_5
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_a

    .line 1926
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/CarrierConfigManager;

    .line 1927
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v1

    if-eqz v1, :cond_a

    const-string v2, "config_telephony_use_own_number_for_voicemail_bool"

    .line 1928
    invoke-virtual {v1, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_a

    .line 1930
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getLine1Number()Ljava/lang/String;

    move-result-object v0

    :cond_a
    return-object v0
.end method

.method public getWakeLock()Landroid/os/PowerManager$WakeLock;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 4679
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    return-object p0
.end method

.method protected handleCallHoldIncallSupplementaryService(Ljava/lang/String;)Z
    .locals 5

    .line 1233
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x2

    if-le v0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1239
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getForegroundCall()Lcom/android/internal/telephony/GsmCdmaCall;

    move-result-object v1

    const-string v2, "GsmCdmaPhone"

    const/4 v3, 0x1

    if-le v0, v3, :cond_2

    .line 1243
    :try_start_0
    invoke-virtual {p1, v3}, Ljava/lang/String;->charAt(I)C

    move-result p1

    add-int/lit8 p1, p1, -0x30

    .line 1245
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->getConnectionByIndex(Lcom/android/internal/telephony/GsmCdmaCall;I)Lcom/android/internal/telephony/GsmCdmaConnection;

    move-result-object v0

    if-eqz v0, :cond_1

    if-lt p1, v3, :cond_1

    const/16 v1, 0x13

    if-gt p1, v1, :cond_1

    .line 1249
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "MmiCode 2: separate call "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1250
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->separate(Lcom/android/internal/telephony/GsmCdmaConnection;)V

    goto :goto_0

    .line 1252
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "separate: invalid call index "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1253
    sget-object p1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->SEPARATE:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifySuppServiceFailed(Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;)V
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v0, "separate failed"

    .line 1256
    invoke-static {v2, v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 1257
    sget-object p1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->SEPARATE:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifySuppServiceFailed(Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;)V

    goto :goto_0

    .line 1261
    :cond_2
    :try_start_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p1

    sget-object v0, Lcom/android/internal/telephony/Call$State;->IDLE:Lcom/android/internal/telephony/Call$State;

    if-eq p1, v0, :cond_3

    const-string p1, "MmiCode 2: accept ringing call"

    .line 1262
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1263
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->acceptCall()V

    goto :goto_0

    :cond_3
    const-string p1, "MmiCode 2: switchWaitingOrHoldingAndActive"

    .line 1265
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1266
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->switchWaitingOrHoldingAndActive()V
    :try_end_1
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_1
    move-exception p1

    const-string/jumbo v0, "switch failed"

    .line 1269
    invoke-static {v2, v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 1270
    sget-object p1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->SWITCH:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifySuppServiceFailed(Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;)V

    :goto_0
    return v3
.end method

.method protected handleCallWaitingIncallSupplementaryService(Ljava/lang/String;)Z
    .locals 4

    .line 1196
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x2

    if-le v0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1202
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getForegroundCall()Lcom/android/internal/telephony/GsmCdmaCall;

    move-result-object v1

    const/4 v2, 0x1

    if-le v0, v2, :cond_1

    .line 1206
    :try_start_0
    invoke-virtual {p1, v2}, Ljava/lang/String;->charAt(I)C

    move-result p1

    add-int/lit8 p1, p1, -0x30

    if-lt p1, v2, :cond_3

    const/16 v0, 0x13

    if-gt p1, v0, :cond_3

    .line 1210
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "MmiCode 1: hangupConnectionByIndex "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1211
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->hangupConnectionByIndex(Lcom/android/internal/telephony/GsmCdmaCall;I)V

    goto :goto_0

    .line 1214
    :cond_1
    invoke-virtual {v1}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p1

    sget-object v0, Lcom/android/internal/telephony/Call$State;->IDLE:Lcom/android/internal/telephony/Call$State;

    if-eq p1, v0, :cond_2

    const-string p1, "MmiCode 1: hangup foreground"

    .line 1215
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1217
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->hangup(Lcom/android/internal/telephony/GsmCdmaCall;)V

    goto :goto_0

    :cond_2
    const-string p1, "MmiCode 1: switchWaitingOrHoldingAndActive"

    .line 1219
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1220
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->switchWaitingOrHoldingAndActive()V
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v0, "GsmCdmaPhone"

    const-string v1, "hangup failed"

    .line 1224
    invoke-static {v0, v1, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 1226
    sget-object p1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->HANGUP:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifySuppServiceFailed(Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;)V

    :cond_3
    :goto_0
    return v2
.end method

.method protected handleCcbsIncallSupplementaryService(Ljava/lang/String;)Z
    .locals 2

    .line 1301
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    const/4 v0, 0x1

    if-le p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const-string p1, "GsmCdmaPhone"

    const-string v1, "MmiCode 5: CCBS not supported!"

    .line 1305
    invoke-static {p1, v1}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1307
    sget-object p1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->UNKNOWN:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifySuppServiceFailed(Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;)V

    return v0
.end method

.method protected handleCfuQueryResult([Lcom/android/internal/telephony/CallForwardInfo;)V
    .locals 6

    const/4 v0, 0x0

    const/4 v1, 0x1

    if-eqz p1, :cond_3

    .line 3614
    array-length v2, p1

    if-nez v2, :cond_0

    goto :goto_1

    .line 3619
    :cond_0
    array-length v2, p1

    move v3, v0

    :goto_0
    if-ge v3, v2, :cond_4

    .line 3620
    aget-object v4, p1, v3

    iget v5, v4, Lcom/android/internal/telephony/CallForwardInfo;->serviceClass:I

    and-int/2addr v5, v1

    if-eqz v5, :cond_2

    .line 3621
    iget p1, v4, Lcom/android/internal/telephony/CallForwardInfo;->status:I

    if-ne p1, v1, :cond_1

    move v0, v1

    :cond_1
    iget-object p1, v4, Lcom/android/internal/telephony/CallForwardInfo;->number:Ljava/lang/String;

    invoke-virtual {p0, v1, v0, p1}, Lcom/android/internal/telephony/Phone;->setVoiceCallForwardingFlag(IZLjava/lang/String;)V

    goto :goto_2

    :cond_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_3
    :goto_1
    const/4 p1, 0x0

    .line 3617
    invoke-virtual {p0, v1, v0, p1}, Lcom/android/internal/telephony/Phone;->setVoiceCallForwardingFlag(IZLjava/lang/String;)V

    :cond_4
    :goto_2
    return-void
.end method

.method protected handleEctIncallSupplementaryService(Ljava/lang/String;)Z
    .locals 1

    .line 1289
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const-string p1, "MmiCode 4: explicit call transfer"

    .line 1295
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1296
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->explicitCallTransfer()V

    return v0
.end method

.method public handleInCallMmiCommands(Ljava/lang/String;)Z
    .locals 3
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 1314
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string p1, "method handleInCallMmiCommands is NOT supported in CDMA!"

    .line 1315
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return v1

    .line 1319
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 1325
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->onCheckIfForceHandleInCallMmiByCS()Z

    move-result v2

    if-nez v2, :cond_1

    if-eqz v0, :cond_1

    .line 1327
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getState()I

    move-result v2

    if-nez v2, :cond_1

    .line 1329
    invoke-interface {v0, p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->handleInCallMmiCommands(Ljava/lang/String;)Z

    move-result p0

    return p0

    .line 1332
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isInCall()Z

    move-result v0

    if-nez v0, :cond_2

    return v1

    .line 1336
    :cond_2
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_3

    return v1

    .line 1341
    :cond_3
    invoke-virtual {p1, v1}, Ljava/lang/String;->charAt(I)C

    move-result v0

    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 1364
    :pswitch_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleCcbsIncallSupplementaryService(Ljava/lang/String;)Z

    move-result v1

    goto :goto_0

    .line 1361
    :pswitch_1
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleEctIncallSupplementaryService(Ljava/lang/String;)Z

    move-result v1

    goto :goto_0

    .line 1358
    :pswitch_2
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleMultipartyIncallSupplementaryService(Ljava/lang/String;)Z

    move-result v1

    goto :goto_0

    .line 1355
    :pswitch_3
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleCallHoldIncallSupplementaryService(Ljava/lang/String;)Z

    move-result v1

    goto :goto_0

    .line 1352
    :pswitch_4
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleCallWaitingIncallSupplementaryService(Ljava/lang/String;)Z

    move-result v1

    goto :goto_0

    .line 1345
    :pswitch_5
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->onHandleInCallMmi0(Ljava/lang/String;)Z

    move-result v1

    :goto_0
    return v1

    :pswitch_data_0
    .packed-switch 0x30
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 7

    .line 3008
    iget v0, p1, Landroid/os/Message;->what:I

    const-string v1, "GsmCdmaPhone"

    const/4 v2, 0x2

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x1

    packed-switch v0, :pswitch_data_0

    .line 3439
    :pswitch_0
    invoke-super {p0, p1}, Lcom/android/internal/telephony/Phone;->handleMessage(Landroid/os/Message;)V

    goto/16 :goto_5

    :pswitch_1
    const-string p1, "EVENT_SUBSCRIPTIONS_CHANGED"

    .line 3434
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3435
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->updateUsageSetting()Z

    goto/16 :goto_5

    :pswitch_2
    const-string p1, "EVENT_SET_VONR_ENABLED_DONE is done"

    .line 3431
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 3427
    :pswitch_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->resetCarrierKeysForImsiEncryption()V

    goto/16 :goto_5

    .line 3097
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3098
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_0

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz p1, :cond_0

    .line 3099
    check-cast p1, Ljava/util/List;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateLinkCapacityEstimate(Ljava/util/List;)V

    goto/16 :goto_5

    :cond_0
    const-string p1, "Unexpected exception on EVENT_LINK_CAPACITY_CHANGED"

    .line 3101
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto/16 :goto_5

    :pswitch_5
    const-string v0, "Event BarringInfoChanged Received"

    .line 3237
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3238
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3239
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/BarringInfo;

    .line 3240
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mNotifier:Lcom/android/internal/telephony/PhoneNotifier;

    invoke-interface {v0, p0, p1}, Lcom/android/internal/telephony/PhoneNotifier;->notifyBarringInfoChanged(Lcom/android/internal/telephony/Phone;Landroid/telephony/BarringInfo;)V

    goto/16 :goto_5

    :pswitch_6
    const-string v0, "Event RegistrationFailed Received"

    .line 3229
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3230
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3231
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/RegistrationFailedEvent;

    .line 3232
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mNotifier:Lcom/android/internal/telephony/PhoneNotifier;

    iget-object v2, p1, Lcom/android/internal/telephony/RegistrationFailedEvent;->cellIdentity:Landroid/telephony/CellIdentity;

    iget-object v3, p1, Lcom/android/internal/telephony/RegistrationFailedEvent;->chosenPlmn:Ljava/lang/String;

    iget v4, p1, Lcom/android/internal/telephony/RegistrationFailedEvent;->domain:I

    iget v5, p1, Lcom/android/internal/telephony/RegistrationFailedEvent;->causeCode:I

    iget v6, p1, Lcom/android/internal/telephony/RegistrationFailedEvent;->additionalCauseCode:I

    move-object v1, p0

    invoke-interface/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneNotifier;->notifyRegistrationFailed(Lcom/android/internal/telephony/Phone;Landroid/telephony/CellIdentity;Ljava/lang/String;III)V

    goto/16 :goto_5

    .line 3408
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    if-eqz p1, :cond_4

    .line 3409
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_1

    goto :goto_0

    .line 3410
    :cond_1
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Landroid/util/Pair;

    if-nez v0, :cond_2

    return-void

    .line 3412
    :cond_2
    iget-object v1, v0, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Boolean;

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    .line 3413
    iget-object v0, v0, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 3414
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    check-cast p1, Lcom/android/internal/telephony/CommandException;

    invoke-virtual {p1}, Lcom/android/internal/telephony/CommandException;->getCommandError()Lcom/android/internal/telephony/CommandException$Error;

    move-result-object p1

    .line 3415
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Error received when re-applying uicc application setting to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " on phone "

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " Error code: "

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " retry count left: "

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    if-lez v0, :cond_20

    .line 3418
    sget-object v1, Lcom/android/internal/telephony/CommandException$Error;->GENERIC_FAILURE:Lcom/android/internal/telephony/CommandException$Error;

    if-eq p1, v1, :cond_3

    sget-object v1, Lcom/android/internal/telephony/CommandException$Error;->SIM_BUSY:Lcom/android/internal/telephony/CommandException$Error;

    if-ne p1, v1, :cond_20

    .line 3421
    :cond_3
    new-instance p1, Lcom/android/internal/telephony/GsmCdmaPhone$$ExternalSyntheticLambda0;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;I)V

    const-wide/16 v0, 0x1388

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto/16 :goto_5

    :cond_4
    :goto_0
    return-void

    .line 3394
    :pswitch_8
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Landroid/os/AsyncResult;

    if-nez v0, :cond_5

    return-void

    .line 3396
    :cond_5
    iget-object v1, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v1, :cond_6

    .line 3397
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Received exception on event"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " : "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return-void

    .line 3401
    :cond_6
    iget-object p1, v0, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mUiccApplicationsEnabled:Ljava/lang/Boolean;

    .line 3404
    :pswitch_9
    sget p1, Lcom/android/internal/telephony/GsmCdmaPhone;->ENABLE_UICC_APPS_MAX_RETRIES:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->reapplyUiccAppsEnablementIfNeeded(I)V

    goto/16 :goto_5

    .line 3365
    :pswitch_a
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3366
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_9

    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz v0, :cond_9

    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-eqz v1, :cond_9

    .line 3367
    check-cast v0, Ljava/util/List;

    .line 3368
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 3369
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_8

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/OperatorInfo;

    .line 3370
    sget-object v3, Lcom/android/internal/telephony/OperatorInfo$State;->CURRENT:Lcom/android/internal/telephony/OperatorInfo$State;

    invoke-virtual {v2}, Lcom/android/internal/telephony/OperatorInfo;->getState()Lcom/android/internal/telephony/OperatorInfo$State;

    move-result-object v4

    if-ne v3, v4, :cond_7

    .line 3371
    new-instance v3, Lcom/android/internal/telephony/OperatorInfo;

    iget-object v4, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    .line 3373
    invoke-virtual {v2}, Lcom/android/internal/telephony/OperatorInfo;->getOperatorAlphaLong()Ljava/lang/String;

    move-result-object v5

    .line 3372
    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->filterOperatorNameByPattern(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iget-object v5, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    .line 3375
    invoke-virtual {v2}, Lcom/android/internal/telephony/OperatorInfo;->getOperatorAlphaShort()Ljava/lang/String;

    move-result-object v6

    .line 3374
    invoke-virtual {v5, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->filterOperatorNameByPattern(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 3376
    invoke-virtual {v2}, Lcom/android/internal/telephony/OperatorInfo;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v6

    .line 3377
    invoke-virtual {v2}, Lcom/android/internal/telephony/OperatorInfo;->getState()Lcom/android/internal/telephony/OperatorInfo$State;

    move-result-object v2

    invoke-direct {v3, v4, v5, v6, v2}, Lcom/android/internal/telephony/OperatorInfo;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/OperatorInfo$State;)V

    .line 3371
    invoke-interface {v1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 3380
    :cond_7
    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 3383
    :cond_8
    iput-object v1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    .line 3386
    :cond_9
    iget-object p0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p0, Landroid/os/Message;

    if-eqz p0, :cond_20

    .line 3388
    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-static {p0, v0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 3389
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    goto/16 :goto_5

    .line 3360
    :pswitch_b
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-nez p1, :cond_20

    .line 3361
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateProvisioningDataEnabled()V

    goto/16 :goto_5

    .line 3355
    :pswitch_c
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-nez p1, :cond_20

    .line 3356
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->updateProvisionedChanged()V

    goto/16 :goto_5

    .line 3343
    :pswitch_d
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3344
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    .line 3345
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_a

    .line 3346
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    .line 3348
    invoke-virtual {p0}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object p0

    .line 3346
    invoke-virtual {v0, v2, p1, p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDataEnabled(IZLjava/lang/String;)V

    return-void

    .line 3351
    :cond_a
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-virtual {p0, v2, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->setDataEnabled(IZ)V

    goto/16 :goto_5

    :pswitch_e
    const-string p1, "EVENT EVENT_RADIO_STATE_CHANGED"

    .line 3214
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3215
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleRadioPowerStateChange()V

    goto/16 :goto_5

    .line 3337
    :pswitch_f
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3338
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/util/Pair;

    .line 3339
    iget-object v0, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    iget-object p1, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->onVoiceRegStateOrRatChanged(II)V

    goto/16 :goto_5

    .line 3044
    :pswitch_10
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Event EVENT_MODEM_RESET Received isInEcm = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " isPhoneTypeGsm = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3045
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " mImsPhone = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 3044
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3046
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v0

    if-eqz v0, :cond_20

    .line 3047
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_b

    .line 3048
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz p0, :cond_20

    .line 3049
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->handleExitEmergencyCallbackMode()V

    goto/16 :goto_5

    .line 3052
    :cond_b
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleExitEmergencyCallbackMode(Landroid/os/Message;)V

    goto/16 :goto_5

    :pswitch_11
    const-string p1, "cdma_roaming_mode change is done"

    .line 3135
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 3112
    :pswitch_12
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    const v0, 0x11101d6

    invoke-virtual {p1, v0}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p1

    if-nez p1, :cond_c

    .line 3115
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x28

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-interface {p1, v0}, Lcom/android/internal/telephony/CommandsInterface;->getVoiceRadioTechnology(Landroid/os/Message;)V

    .line 3119
    :cond_c
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    const-string v0, "carrier_config"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/CarrierConfigManager;

    .line 3120
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p1

    .line 3122
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateBroadcastEmergencyCallStateChangesAfterCarrierConfigChanged(Landroid/os/PersistableBundle;)V

    .line 3124
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateCdmaRoamingSettingsAfterCarrierConfigChanged(Landroid/os/PersistableBundle;)V

    .line 3126
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateNrSettingsAfterCarrierConfigChanged(Landroid/os/PersistableBundle;)V

    .line 3127
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateVoNrSettings(Landroid/os/PersistableBundle;)V

    .line 3128
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateSsOverCdmaSupported(Landroid/os/PersistableBundle;)V

    .line 3129
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->loadAllowedNetworksFromSubscriptionDatabase()V

    .line 3131
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x23

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioCapability(Landroid/os/Message;)V

    goto/16 :goto_5

    .line 3106
    :pswitch_13
    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->phoneObjectUpdater(I)V

    goto/16 :goto_5

    .line 3069
    :pswitch_14
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3070
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_d

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz p1, :cond_d

    .line 3071
    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mRilVersion:I

    goto/16 :goto_5

    :cond_d
    const-string p1, "Unexpected exception on EVENT_RIL_CONNECTED"

    .line 3073
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    const/4 p1, -0x1

    .line 3074
    iput p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mRilVersion:I

    goto/16 :goto_5

    :pswitch_15
    const/16 v1, 0x27

    if-ne v0, v1, :cond_e

    const-string v0, "EVENT_VOICE_RADIO_TECH_CHANGED"

    goto :goto_2

    :cond_e
    const-string v0, "EVENT_REQUEST_VOICE_RADIO_TECH_DONE"

    .line 3082
    :goto_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3083
    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v1, :cond_10

    .line 3084
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz p1, :cond_f

    move-object v1, p1

    check-cast v1, [I

    array-length v1, v1

    if-eqz v1, :cond_f

    .line 3085
    check-cast p1, [I

    aget p1, p1, v4

    .line 3086
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ": newVoiceTech="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3087
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->phoneObjectUpdater(I)V

    goto/16 :goto_5

    .line 3089
    :cond_f
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ": has no tech!"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 3092
    :cond_10
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ": exception="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 3314
    :pswitch_16
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    const-string v0, "Event EVENT_SS received"

    .line 3315
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3316
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_20

    .line 3320
    new-instance v0, Lcom/android/internal/telephony/gsm/GsmMmiCode;

    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/gsm/GsmMmiCode;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/uicc/UiccCardApplication;)V

    .line 3321
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->processSsData(Landroid/os/AsyncResult;)V

    goto/16 :goto_5

    .line 3326
    :pswitch_17
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3327
    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/RadioCapability;

    .line 3328
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz p1, :cond_11

    const-string p0, "get phone radio capability fail, no need to change mRadioCapability"

    .line 3329
    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_3

    .line 3332
    :cond_11
    invoke-virtual {p0, v0, v4}, Lcom/android/internal/telephony/Phone;->radioCapabilityUpdated(Lcom/android/internal/telephony/RadioCapability;Z)V

    .line 3334
    :goto_3
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "EVENT_GET_RADIO_CAPABILITY: phone rc: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_5

    .line 3297
    :pswitch_18
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3298
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->processIccRecordEvents(I)V

    goto/16 :goto_5

    .line 3286
    :pswitch_19
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3287
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getIsManualSelection()Z

    move-result v0

    if-eqz v0, :cond_12

    .line 3288
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/os/Message;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Phone;->setNetworkSelectionModeAutomatic(Landroid/os/Message;)V

    const-string p1, "SET_NETWORK_SELECTION_AUTOMATIC: set to automatic"

    .line 3289
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto/16 :goto_5

    :cond_12
    const-string p1, "SET_NETWORK_SELECTION_AUTOMATIC: already automatic, ignore"

    .line 3292
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto/16 :goto_5

    :pswitch_1a
    const-string p1, "EVENT_CDMA_SUBSCRIPTION_SOURCE_CHANGED"

    .line 3139
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3140
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getCdmaSubscriptionSource()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    goto/16 :goto_5

    .line 3039
    :pswitch_1b
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleExitEmergencyCallbackMode(Landroid/os/Message;)V

    goto/16 :goto_5

    .line 3034
    :pswitch_1c
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleEnterEmergencyCallbackMode(Landroid/os/Message;)V

    goto/16 :goto_5

    :pswitch_1d
    const-string p1, "Event EVENT_RUIM_RECORDS_LOADED Received"

    .line 3059
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3060
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateCurrentCarrierInProvider()Z

    goto/16 :goto_5

    .line 3015
    :pswitch_1e
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3017
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_13

    goto/16 :goto_5

    .line 3020
    :cond_13
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [Ljava/lang/String;

    .line 3021
    aget-object v0, p1, v4

    iput-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImei:Ljava/lang/String;

    .line 3022
    aget-object v0, p1, v5

    iput-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImeiSv:Ljava/lang/String;

    .line 3023
    aget-object v0, p1, v2

    iput-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEsn:Ljava/lang/String;

    const/4 v0, 0x3

    .line 3024
    aget-object p1, p1, v0

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mMeid:Ljava/lang/String;

    .line 3026
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p1

    if-nez p1, :cond_20

    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mMeid:Ljava/lang/String;

    const-string v0, "^0*$"

    invoke-virtual {p1, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_20

    const-string p1, "EVENT_GET_DEVICE_IDENTITY_DONE: set mMeid to null"

    .line 3027
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3028
    iput-object v3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mMeid:Ljava/lang/String;

    goto/16 :goto_5

    .line 3256
    :pswitch_1f
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3257
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_14

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz v0, :cond_15

    :cond_14
    const-class v0, Lcom/android/internal/telephony/uicc/IccVmNotSupportedException;

    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 3258
    invoke-virtual {v0, v1}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_16

    .line 3259
    :cond_15
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_17

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-nez v0, :cond_17

    const-class v0, Lcom/android/internal/telephony/uicc/IccException;

    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 3260
    invoke-virtual {v0, v1}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_17

    .line 3261
    :cond_16
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mVmNumber:Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->storeVoiceMailNumber(Ljava/lang/String;)V

    .line 3262
    iput-object v3, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 3264
    :cond_17
    iget-object p0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p0, Landroid/os/Message;

    if-eqz p0, :cond_20

    .line 3266
    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-static {p0, v0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 3267
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    goto/16 :goto_5

    :pswitch_20
    const-string p1, "Event EVENT_REGISTERED_TO_NETWORK Received"

    .line 3144
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3145
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-eqz p1, :cond_20

    .line 3146
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->syncClirSetting()V

    goto/16 :goto_5

    .line 3302
    :pswitch_21
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Landroid/os/AsyncResult;

    .line 3303
    iget-object v1, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v1, :cond_18

    .line 3304
    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Phone;->saveClirSetting(I)V

    .line 3306
    :cond_18
    iget-object p0, v0, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p0, Landroid/os/Message;

    if-eqz p0, :cond_20

    .line 3308
    iget-object p1, v0, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    iget-object v0, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-static {p0, p1, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 3309
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    goto/16 :goto_5

    .line 3273
    :pswitch_22
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3274
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_19

    .line 3275
    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast v0, [Lcom/android/internal/telephony/CallForwardInfo;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleCfuQueryResult([Lcom/android/internal/telephony/CallForwardInfo;)V

    .line 3277
    :cond_19
    iget-object p0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p0, Landroid/os/Message;

    if-eqz p0, :cond_20

    .line 3279
    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-static {p0, v0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 3280
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    goto/16 :goto_5

    .line 3244
    :pswitch_23
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Landroid/os/AsyncResult;

    .line 3245
    iget-object v1, v0, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v1, Lcom/android/internal/telephony/GsmCdmaPhone$Cfu;

    .line 3246
    iget-object v2, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v2, :cond_1b

    .line 3247
    iget p1, p1, Landroid/os/Message;->arg1:I

    if-ne p1, v5, :cond_1a

    move v4, v5

    :cond_1a
    iget-object p1, v1, Lcom/android/internal/telephony/GsmCdmaPhone$Cfu;->mSetCfNumber:Ljava/lang/String;

    invoke-virtual {p0, v5, v4, p1}, Lcom/android/internal/telephony/Phone;->setVoiceCallForwardingFlag(IZLjava/lang/String;)V

    .line 3249
    :cond_1b
    iget-object p0, v1, Lcom/android/internal/telephony/GsmCdmaPhone$Cfu;->mOnComplete:Landroid/os/Message;

    if-eqz p0, :cond_20

    .line 3250
    iget-object p1, v0, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    iget-object v0, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-static {p0, p1, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 3251
    iget-object p0, v1, Lcom/android/internal/telephony/GsmCdmaPhone$Cfu;->mOnComplete:Landroid/os/Message;

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    goto/16 :goto_5

    :pswitch_24
    const-string p1, "Event EVENT_RADIO_OFF_OR_NOT_AVAILABLE Received"

    .line 3208
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3209
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleRadioOffOrNotAvailable()V

    goto/16 :goto_5

    .line 3194
    :pswitch_25
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3196
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [Ljava/lang/String;

    .line 3198
    array-length v0, p1

    if-le v0, v5, :cond_20

    .line 3200
    :try_start_0
    aget-object v0, p1, v4

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    aget-object p1, p1, v5

    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->onIncomingUSSD(ILjava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    goto/16 :goto_5

    :catch_0
    const-string p0, "error parsing USSD"

    .line 3202
    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_5

    .line 3169
    :pswitch_26
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3171
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_1c

    goto/16 :goto_5

    .line 3175
    :cond_1c
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Baseband version: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3183
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    if-eqz p1, :cond_20

    .line 3185
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    .line 3187
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {v1}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object v1

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    const/16 v2, 0x2d

    if-gt v0, v2, :cond_1d

    goto :goto_4

    :cond_1d
    add-int/lit8 v2, v0, -0x2d

    .line 3189
    invoke-virtual {p1, v2, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    .line 3187
    :goto_4
    invoke-virtual {v1, p0, p1}, Landroid/telephony/TelephonyManager;->setBasebandVersionForPhone(ILjava/lang/String;)V

    goto :goto_5

    :pswitch_27
    const-string p1, "Event EVENT_RADIO_ON Received"

    .line 3064
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3065
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleRadioOn()V

    goto :goto_5

    .line 3151
    :pswitch_28
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateCurrentCarrierInProvider()Z

    .line 3155
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getVmSimImsi()Ljava/lang/String;

    move-result-object p1

    .line 3156
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSubscriberId()Ljava/lang/String;

    move-result-object v0

    .line 3157
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_1e

    if-eqz p1, :cond_1f

    :cond_1e
    if-eqz v0, :cond_1f

    .line 3158
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_1f

    .line 3159
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->storeVoiceMailNumber(Ljava/lang/String;)V

    .line 3160
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->setVmSimImsi(Ljava/lang/String;)V

    .line 3163
    :cond_1f
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateVoiceMail()V

    .line 3165
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mSimRecordsLoadedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    goto :goto_5

    :pswitch_29
    const-string v0, "Event EVENT_SSN Received"

    .line 3220
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3221
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_20

    .line 3222
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 3223
    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/gsm/SuppServiceNotification;

    .line 3224
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    goto :goto_5

    .line 3010
    :pswitch_2a
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleRadioAvailable()V

    :cond_20
    :goto_5
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_2a
        :pswitch_29
        :pswitch_28
        :pswitch_0
        :pswitch_27
        :pswitch_26
        :pswitch_25
        :pswitch_24
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_23
        :pswitch_22
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_21
        :pswitch_20
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
        :pswitch_0
        :pswitch_0
        :pswitch_1c
        :pswitch_1b
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_17
        :pswitch_16
        :pswitch_0
        :pswitch_0
        :pswitch_15
        :pswitch_15
        :pswitch_14
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
        :pswitch_0
        :pswitch_8
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method protected handleMultipartyIncallSupplementaryService(Ljava/lang/String;)Z
    .locals 1

    .line 1278
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    const/4 v0, 0x1

    if-le p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const-string p1, "MmiCode 3: merge calls"

    .line 1282
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1283
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->conference()V

    return v0
.end method

.method public handlePinMmi(Ljava/lang/String;)Z
    .locals 2

    .line 1711
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1712
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    invoke-static {p1, p0, v0}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->newFromDialString(Ljava/lang/String;Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/uicc/UiccCardApplication;)Lcom/android/internal/telephony/gsm/GsmMmiCode;

    move-result-object p1

    goto :goto_0

    .line 1714
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    invoke-static {p1, p0, v0}, Lcom/android/internal/telephony/cdma/CdmaMmiCode;->newFromDialString(Ljava/lang/String;Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/uicc/UiccCardApplication;)Lcom/android/internal/telephony/cdma/CdmaMmiCode;

    move-result-object p1

    :goto_0
    if-eqz p1, :cond_1

    .line 1717
    invoke-interface {p1}, Lcom/android/internal/telephony/MmiCode;->isPinPukCommand()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1718
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1719
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mMmiRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    .line 1721
    :try_start_0
    invoke-interface {p1}, Lcom/android/internal/telephony/MmiCode;->processCode()V
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const/4 p0, 0x1

    return p0

    :cond_1
    const-string p1, "Mmi is null or unrecognized!"

    .line 1728
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public handleTimerInEmergencyCallbackMode(I)V
    .locals 2

    if-eqz p1, :cond_1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_0

    .line 3898
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handleTimerInEmergencyCallbackMode, unsupported action "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GsmCdmaPhone"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 3886
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mExitEcmRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 3887
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmTimerResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

    sget-object v1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    .line 3888
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->setEcmCanceledForEmergency(Z)V

    goto :goto_0

    .line 3891
    :cond_1
    invoke-static {}, Landroid/internal/telephony/sysprop/TelephonyProperties;->ecm_exit_timer()Ljava/util/Optional;

    move-result-object p1

    const-wide/32 v0, 0x493e0

    .line 3892
    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    .line 3893
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mExitEcmRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 3894
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmTimerResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    const/4 p1, 0x0

    .line 3895
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Phone;->setEcmCanceledForEmergency(Z)V

    :goto_0
    return-void
.end method

.method public handleUssdRequest(Ljava/lang/String;Landroid/os/ResultReceiver;)Z
    .locals 4

    .line 1742
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lez v0, :cond_0

    goto :goto_0

    .line 1750
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    const/4 v2, 0x0

    if-eqz v0, :cond_3

    .line 1752
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getState()I

    move-result v3

    if-eqz v3, :cond_1

    .line 1753
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUtEnabled()Z

    move-result v3

    if-eqz v3, :cond_3

    :cond_1
    :try_start_0
    const-string v3, "handleUssdRequest: attempting over IMS"

    .line 1755
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1756
    invoke-interface {v0, p1, p2}, Lcom/android/internal/telephony/PhoneInternalInterface;->handleUssdRequest(Ljava/lang/String;Landroid/os/ResultReceiver;)Z

    move-result p0
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    :catch_0
    move-exception v0

    .line 1758
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    const-string v3, "cs_fallback"

    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    return v2

    :cond_2
    const-string v0, "handleUssdRequest: fallback to CS required"

    .line 1763
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1769
    :cond_3
    :try_start_1
    new-instance v0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;-><init>()V

    invoke-virtual {v0}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->build()Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;

    move-result-object v0

    invoke-virtual {p0, p1, v0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->dialInternal(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;Landroid/os/ResultReceiver;)Lcom/android/internal/telephony/Connection;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return v1

    :catch_1
    move-exception p1

    .line 1771
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handleUssdRequest: exception"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return v2

    :cond_4
    :goto_0
    const/4 v0, 0x0

    const/4 v2, -0x1

    .line 1744
    invoke-virtual {p0, p1, v0, v2, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->sendUssdResponse(Ljava/lang/String;Ljava/lang/CharSequence;ILandroid/os/ResultReceiver;)V

    return v1
.end method

.method protected initOnce(Lcom/android/internal/telephony/CommandsInterface;)V
    .locals 8

    .line 435
    instance-of v0, p1, Lcom/android/internal/telephony/test/SimulatedRadioControl;

    if-eqz v0, :cond_0

    .line 436
    check-cast p1, Lcom/android/internal/telephony/test/SimulatedRadioControl;

    iput-object p1, p0, Lcom/android/internal/telephony/Phone;->mSimulatedRadioControl:Lcom/android/internal/telephony/test/SimulatedRadioControl;

    .line 439
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v0, Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p1

    .line 440
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeGsmCdmaCallTracker(Lcom/android/internal/telephony/GsmCdmaPhone;)Lcom/android/internal/telephony/GsmCdmaCallTracker;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    .line 441
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v0, Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    .line 442
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p1

    .line 443
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeIccPhoneBookInterfaceManager(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccPhoneBookIntManager:Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    .line 444
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-string v0, "power"

    .line 445
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/os/PowerManager;

    const/4 v0, 0x1

    const-string v1, "GsmCdmaPhone"

    .line 446
    invoke-virtual {p1, v0, v1}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    .line 447
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v1, Lcom/android/internal/telephony/IccSmsInterfaceManager;

    .line 448
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p1

    .line 449
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeIccSmsInterfaceManager(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/IccSmsInterfaceManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccSmsInterfaceManager:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    .line 451
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x0

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForAvailable(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 452
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x8

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForOffOrNotAvailable(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 453
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x5

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForOn(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 454
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x2f

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForRadioStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 455
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x35

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerUiccApplicationEnablementChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 458
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x2

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setOnSuppServiceNotification(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 459
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x39

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setOnRegistrationFailed(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 460
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x3a

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForBarringInfoChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 463
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x7

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setOnUSSD(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 464
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x24

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setOnSs(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 467
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mTelephonyComponentFactory:Lcom/android/internal/telephony/TelephonyComponentFactory;

    const-class v0, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    iget-object v4, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v6, 0x1b

    const/4 v7, 0x0

    move-object v5, p0

    .line 468
    invoke-virtual/range {v2 .. v7}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getCdmaSubscriptionSourceManagerInstance(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Landroid/os/Handler;ILjava/lang/Object;)Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    .line 470
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x19

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setEmergencyCallbackMode(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 471
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x1a

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForExitEmergencyCallbackMode(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 473
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x2d

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForModemReset(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 475
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {p1}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object p1

    .line 476
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    const-string v2, ""

    .line 475
    invoke-virtual {p1, v0, v2}, Landroid/telephony/TelephonyManager;->getOtaSpNumberSchemaForPhone(ILjava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCarrierOtaSpNumSchema:Ljava/lang/String;

    .line 478
    invoke-static {}, Landroid/internal/telephony/sysprop/TelephonyProperties;->reset_on_radio_tech_change()Ljava/util/Optional;

    move-result-object p1

    .line 479
    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {p1, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    iput-boolean p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mResetModemOnRadioTechnologyChange:Z

    .line 481
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x29

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForRilConnected(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 482
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x27

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForVoiceRadioTechChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 483
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x3b

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForLceInfo(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 484
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x3c

    invoke-interface {p1, p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForCarrierInfoForImsiEncryption(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 486
    new-instance v4, Landroid/content/IntentFilter;

    const-string p1, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-direct {v4, p1}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    const-string p1, "android.telecom.action.CURRENT_TTY_MODE_CHANGED"

    .line 488
    invoke-virtual {v4, p1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string p1, "android.telecom.action.TTY_PREFERRED_MODE_CHANGED"

    .line 489
    invoke-virtual {v4, p1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 490
    iget-object v2, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    iget-object v3, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    const/4 v6, 0x0

    const/4 v7, 0x2

    const-string v5, "android.permission.MODIFY_PHONE_STATE"

    invoke-virtual/range {v2 .. v7}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;I)Landroid/content/Intent;

    .line 493
    new-instance p1, Lcom/android/internal/telephony/CarrierKeyDownloadManager;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;-><init>(Lcom/android/internal/telephony/Phone;)V

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCDM:Lcom/android/internal/telephony/CarrierKeyDownloadManager;

    .line 494
    new-instance p1, Lcom/android/internal/telephony/CarrierInfoManager;

    invoke-direct {p1}, Lcom/android/internal/telephony/CarrierInfoManager;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCIM:Lcom/android/internal/telephony/CarrierInfoManager;

    return-void
.end method

.method protected initRatSpecific(I)V
    .locals 6

    .line 498
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 500
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->needResetPhbIntMgr()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 501
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccPhoneBookIntManager:Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;->updateIccRecords(Lcom/android/internal/telephony/uicc/IccRecords;)V

    .line 504
    :cond_0
    iput p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    .line 505
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Precise phone type "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 507
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {p1}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object p1

    .line 508
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object v0

    .line 509
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v2

    const/4 v3, 0x3

    if-eqz v2, :cond_1

    .line 510
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v2, 0x1

    invoke-interface {v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->setPhoneType(I)V

    .line 511
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {p1, p0, v2}, Landroid/telephony/TelephonyManager;->setPhoneType(II)V

    if-eqz v0, :cond_6

    .line 513
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/uicc/UiccProfile;->setVoiceRadioTech(I)V

    goto/16 :goto_1

    .line 516
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {v2}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getCdmaSubscriptionSource()I

    move-result v2

    iput v2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCdmaSubscriptionSource:I

    .line 518
    invoke-static {}, Lcom/android/internal/telephony/Phone;->getInEcmMode()Z

    move-result v2

    iput-boolean v2, p0, Lcom/android/internal/telephony/Phone;->mIsPhoneInEcmState:Z

    if-eqz v2, :cond_2

    .line 521
    iget-object v2, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v2, v1}, Lcom/android/internal/telephony/CommandsInterface;->exitEmergencyCallbackMode(Landroid/os/Message;)V

    .line 524
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v2, 0x2

    invoke-interface {v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->setPhoneType(I)V

    .line 525
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p1, v1, v2}, Landroid/telephony/TelephonyManager;->setPhoneType(II)V

    if-eqz v0, :cond_3

    const/4 v1, 0x6

    .line 527
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccProfile;->setVoiceRadioTech(I)V

    :cond_3
    const-string v0, "ro.cdma.home.operator.alpha"

    .line 530
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "ro.cdma.home.operator.numeric"

    .line 531
    invoke-static {v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 532
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "init: operatorAlpha=\'"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\' operatorNumeric=\'"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\'"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 534
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_4

    .line 535
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "init: set \'gsm.sim.operator.alpha\' to operator=\'"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 536
    iget v2, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {p1, v2, v0}, Landroid/telephony/TelephonyManager;->setSimOperatorNameForPhone(ILjava/lang/String;)V

    .line 538
    :cond_4
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_5

    .line 539
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "init: set \'gsm.sim.operator.numeric\' to operator=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 541
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "update icc_operator_numeric="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 542
    iget v0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {p1, v0, v1}, Landroid/telephony/TelephonyManager;->setSimOperatorNumericForPhone(ILjava/lang/String;)V

    .line 544
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->setMccMnc(Ljava/lang/String;I)I

    const/4 v0, 0x0

    .line 549
    :try_start_0
    invoke-virtual {v1, v0, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/MccTable;->countryCodeForMcc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/StringIndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v2, "GsmCdmaPhone"

    const-string v3, "init: countryCodeForMcc error"

    .line 551
    invoke-static {v2, v3, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const-string v0, ""

    .line 554
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "init: set \'gsm.sim.operator.iso-country\' to iso="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 555
    iget v2, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {p1, v2, v0}, Landroid/telephony/TelephonyManager;->setSimCountryIsoForPhone(ILjava/lang/String;)V

    .line 556
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p1

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {p1, v0, v2}, Lcom/android/internal/telephony/SubscriptionController;->setCountryIso(Ljava/lang/String;I)I

    .line 559
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v0, "update mccmnc="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 560
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {p1, v1}, Lcom/android/internal/telephony/MccTable;->updateMccMncConfiguration(Landroid/content/Context;Ljava/lang/String;)V

    .line 564
    :cond_5
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateCurrentCarrierInProvider(Ljava/lang/String;)Z

    :cond_6
    :goto_1
    return-void
.end method

.method public isCdmaSubscriptionAppPresent()Z
    .locals 2

    .line 4144
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x2

    .line 4145
    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 4146
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getType()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;->APPTYPE_CSIM:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    if-eq v0, v1, :cond_0

    .line 4147
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getType()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object p0

    sget-object v0, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;->APPTYPE_RUIM:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    if-ne p0, v0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method protected isCfEnable(I)Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/4 p0, 0x1

    if-eq p1, p0, :cond_1

    const/4 v0, 0x3

    if-ne p1, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :cond_1
    :goto_0
    return p0
.end method

.method protected isCsRetry(Landroid/os/Message;)Z
    .locals 1

    const/4 p0, 0x0

    if-eqz p1, :cond_0

    .line 2361
    invoke-virtual {p1}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object p1

    const-string v0, "cs_fallback_ss"

    invoke-virtual {p1, v0, p0}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    :cond_0
    return p0
.end method

.method public isCspPlmnEnabled()Z
    .locals 0

    .line 3686
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 3687
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->isCspPlmnEnabled()Z

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isDataSuspended()Z
    .locals 2

    .line 746
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mState:Lcom/android/internal/telephony/PhoneConstants$State;

    sget-object v1, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    if-eq v0, v1, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isConcurrentVoiceAndDataAllowed()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isImsUseEnabled()Z
    .locals 2

    .line 4976
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mImsManagerFactory:Lcom/android/internal/telephony/GsmCdmaPhone$ImsManagerFactory;

    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-interface {v0, v1, p0}, Lcom/android/internal/telephony/GsmCdmaPhone$ImsManagerFactory;->create(Landroid/content/Context;I)Lcom/android/ims/ImsManager;

    move-result-object p0

    .line 4977
    invoke-virtual {p0}, Lcom/android/ims/ImsManager;->isVolteEnabledByPlatform()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4978
    invoke-virtual {p0}, Lcom/android/ims/ImsManager;->isEnhanced4gLteModeSettingEnabledByUser()Z

    move-result v0

    if-nez v0, :cond_1

    .line 4979
    :cond_0
    invoke-virtual {p0}, Lcom/android/ims/ImsManager;->isWfcEnabledByPlatform()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Lcom/android/ims/ImsManager;->isWfcEnabledByUser()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 4980
    invoke-virtual {p0}, Lcom/android/ims/ImsManager;->isNonTtyOrTtyOnVolteEnabled()Z

    move-result p0

    if-eqz p0, :cond_2

    :cond_1
    const/4 p0, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method protected isImsUtEnabledOverCdma()Z
    .locals 1

    .line 2353
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz p0, :cond_0

    .line 2355
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUtEnabled()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isInCall()Z
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 1375
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getForegroundCall()Lcom/android/internal/telephony/GsmCdmaCall;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object v0

    .line 1376
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getBackgroundCall()Lcom/android/internal/telephony/GsmCdmaCall;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object v1

    .line 1377
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p0

    .line 1379
    invoke-virtual {v0}, Lcom/android/internal/telephony/Call$State;->isAlive()Z

    move-result v0

    if-nez v0, :cond_1

    .line 1380
    invoke-virtual {v1}, Lcom/android/internal/telephony/Call$State;->isAlive()Z

    move-result v0

    if-nez v0, :cond_1

    .line 1381
    invoke-virtual {p0}, Lcom/android/internal/telephony/Call$State;->isAlive()Z

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

.method public isInEmergencyCall()Z
    .locals 1

    .line 865
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 868
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->isInEmergencyCall()Z

    move-result p0

    return p0
.end method

.method public isInEmergencySmsMode()Z
    .locals 1

    .line 881
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->isInEmergencySmsMode()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz p0, :cond_0

    .line 882
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isInEmergencySmsMode()Z

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

.method public isMinInfoReady()Z
    .locals 0

    .line 2250
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isMinInfoReady()Z

    move-result p0

    return p0
.end method

.method public isNotificationOfWfcCallRequired(Ljava/lang/String;)Z
    .locals 5

    .line 1626
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-string v1, "carrier_config"

    .line 1627
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 1628
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    const-string v3, "notify_international_call_on_wfc_bool"

    .line 1634
    invoke-virtual {v0, v3}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    move v0, v1

    goto :goto_0

    :cond_0
    move v0, v2

    :goto_0
    if-nez v0, :cond_1

    return v2

    .line 1641
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 1642
    iget-object v3, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-class v4, Landroid/telephony/TelephonyManager;

    invoke-virtual {v3, v4}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/TelephonyManager;

    .line 1643
    invoke-virtual {v3, p1}, Landroid/telephony/TelephonyManager;->isEmergencyNumber(Ljava/lang/String;)Z

    move-result v3

    .line 1646
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isImsUseEnabled()Z

    move-result v4

    if-eqz v4, :cond_2

    if-eqz v0, :cond_2

    .line 1649
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isVoiceOverCellularImsEnabled()Z

    move-result v4

    if-nez v4, :cond_2

    .line 1651
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result v0

    if-eqz v0, :cond_2

    if-nez v3, :cond_2

    .line 1654
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCountryIso()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Landroid/telephony/PhoneNumberUtils;->isInternationalNumber(Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_1

    :cond_2
    move v1, v2

    :goto_1
    return v1
.end method

.method public isOtaSpNumber(Ljava/lang/String;)Z
    .locals 1

    .line 4082
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4083
    invoke-super {p0, p1}, Lcom/android/internal/telephony/Phone;->isOtaSpNumber(Ljava/lang/String;)Z

    move-result p0

    return p0

    :cond_0
    const/4 v0, 0x0

    .line 4086
    invoke-static {p1}, Landroid/telephony/PhoneNumberUtils;->extractNetworkPortionAlt(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 4088
    invoke-static {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isIs683OtaSpDialStr(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 4090
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isCarrierOtaSpNum(Ljava/lang/String;)Z

    move-result v0

    .line 4093
    :cond_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "isOtaSpNumber "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GsmCdmaPhone"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return v0
.end method

.method public isPhoneTypeCdma()Z
    .locals 1

    .line 574
    iget p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isPhoneTypeCdmaLte()Z
    .locals 1

    .line 578
    iget p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    const/4 v0, 0x6

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isPhoneTypeGsm()Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 570
    iget p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPrecisePhoneType:I

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isUserDataEnabled()Z
    .locals 1

    .line 2803
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2804
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object p0

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabledForReason(I)Z

    move-result p0

    return p0

    .line 2807
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isProvisioning()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2808
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isProvisioningDataEnabled()Z

    move-result p0

    return p0

    .line 2810
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mDataEnabledSettings:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isUserDataEnabled()Z

    move-result p0

    return p0
.end method

.method public isUtEnabled()Z
    .locals 1

    .line 4662
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_0

    .line 4664
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUtEnabled()Z

    move-result p0

    return p0

    :cond_0
    const-string v0, "isUtEnabled: called for GsmCdma"

    .line 4666
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method protected isValidCommandInterfaceCFAction(I)Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/4 p0, 0x1

    if-eqz p1, :cond_0

    if-eq p1, p0, :cond_0

    const/4 v0, 0x3

    if-eq p1, v0, :cond_0

    const/4 v0, 0x4

    if-eq p1, v0, :cond_0

    const/4 p0, 0x0

    :cond_0
    return p0
.end method

.method protected isValidCommandInterfaceCFReason(I)Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/4 p0, 0x1

    if-eqz p1, :cond_0

    if-eq p1, p0, :cond_0

    const/4 v0, 0x2

    if-eq p1, v0, :cond_0

    const/4 v0, 0x3

    if-eq p1, v0, :cond_0

    const/4 v0, 0x4

    if-eq p1, v0, :cond_0

    const/4 v0, 0x5

    if-eq p1, v0, :cond_0

    const/4 p0, 0x0

    :cond_0
    return p0
.end method

.method protected logd(Ljava/lang/String;)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 4644
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "] "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GsmCdmaPhone"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 4653
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "] "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GsmCdmaPhone"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logi(Ljava/lang/String;)V
    .locals 2

    .line 4648
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "] "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GsmCdmaPhone"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected makeEmptyCallForward()[Lcom/android/internal/telephony/CallForwardInfo;
    .locals 4

    const/4 p0, 0x1

    new-array v0, p0, [Lcom/android/internal/telephony/CallForwardInfo;

    .line 4613
    new-instance v1, Lcom/android/internal/telephony/CallForwardInfo;

    invoke-direct {v1}, Lcom/android/internal/telephony/CallForwardInfo;-><init>()V

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const/16 v3, 0xff

    .line 4614
    iput v3, v1, Lcom/android/internal/telephony/CallForwardInfo;->status:I

    .line 4615
    iput v2, v1, Lcom/android/internal/telephony/CallForwardInfo;->reason:I

    .line 4616
    iput p0, v1, Lcom/android/internal/telephony/CallForwardInfo;->serviceClass:I

    const/16 p0, 0x81

    .line 4617
    iput p0, v1, Lcom/android/internal/telephony/CallForwardInfo;->toa:I

    const-string p0, ""

    .line 4618
    iput-object p0, v1, Lcom/android/internal/telephony/CallForwardInfo;->number:Ljava/lang/String;

    .line 4619
    iput v2, v1, Lcom/android/internal/telephony/CallForwardInfo;->timeSeconds:I

    return-object v0
.end method

.method protected needResetPhbIntMgr()Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public needsOtaServiceProvisioning()Z
    .locals 2

    .line 3677
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return v1

    .line 3680
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOtasp()I

    move-result p0

    const/4 v0, 0x3

    if-eq p0, v0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method public notifyCallForwardingIndicator()V
    .locals 1

    .line 940
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mNotifier:Lcom/android/internal/telephony/PhoneNotifier;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/PhoneNotifier;->notifyCallForwardingChanged(Lcom/android/internal/telephony/Phone;)V

    return-void
.end method

.method public notifyDisconnect(Lcom/android/internal/telephony/Connection;)V
    .locals 2

    .line 853
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mDisconnectRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    .line 855
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mNotifier:Lcom/android/internal/telephony/PhoneNotifier;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getDisconnectCause()I

    move-result v1

    .line 856
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getPreciseDisconnectCause()I

    move-result p1

    .line 855
    invoke-interface {v0, p0, v1, p1}, Lcom/android/internal/telephony/PhoneNotifier;->notifyDisconnectCause(Lcom/android/internal/telephony/Phone;II)V

    return-void
.end method

.method public notifyEcbmTimerReset(Ljava/lang/Boolean;)V
    .locals 0

    .line 4486
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmTimerResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    return-void
.end method

.method public notifyEmergencyCallRegistrants(Z)V
    .locals 0

    .line 3874
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mEmergencyCallToggledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    return-void
.end method

.method public notifyLocationChanged(Landroid/telephony/CellIdentity;)V
    .locals 1

    .line 935
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mNotifier:Lcom/android/internal/telephony/PhoneNotifier;

    invoke-interface {v0, p0, p1}, Lcom/android/internal/telephony/PhoneNotifier;->notifyCellLocation(Lcom/android/internal/telephony/Phone;Landroid/telephony/CellIdentity;)V

    return-void
.end method

.method public notifyNewRingingConnection(Lcom/android/internal/telephony/Connection;)V
    .locals 0

    .line 849
    invoke-super {p0, p1}, Lcom/android/internal/telephony/Phone;->notifyNewRingingConnectionP(Lcom/android/internal/telephony/Connection;)V

    return-void
.end method

.method public notifyPhoneStateChanged()V
    .locals 1

    .line 834
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mNotifier:Lcom/android/internal/telephony/PhoneNotifier;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/PhoneNotifier;->notifyPhoneState(Lcom/android/internal/telephony/Phone;)V

    return-void
.end method

.method public notifyPreciseCallStateChanged()V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 845
    invoke-super {p0}, Lcom/android/internal/telephony/Phone;->notifyPreciseCallStateChangedP()V

    return-void
.end method

.method public notifyServiceStateChanged(Landroid/telephony/ServiceState;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 922
    invoke-super {p0, p1}, Lcom/android/internal/telephony/Phone;->notifyServiceStateChangedP(Landroid/telephony/ServiceState;)V

    return-void
.end method

.method notifyServiceStateChangedForSubId(Landroid/telephony/ServiceState;I)V
    .locals 0

    .line 926
    invoke-super {p0, p1, p2}, Lcom/android/internal/telephony/Phone;->notifyServiceStateChangedPForSubId(Landroid/telephony/ServiceState;I)V

    return-void
.end method

.method public notifySuppServiceFailed(Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;)V
    .locals 0

    .line 917
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mSuppServiceFailedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    return-void
.end method

.method public notifyUnknownConnection(Lcom/android/internal/telephony/Connection;)V
    .locals 0

    .line 860
    invoke-super {p0, p1}, Lcom/android/internal/telephony/Phone;->notifyUnknownConnectionP(Lcom/android/internal/telephony/Connection;)V

    return-void
.end method

.method public notifyVolteSilentRedial(Ljava/lang/String;I)V
    .locals 3

    .line 4582
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "notifyVolteSilentRedial: dialString="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " causeCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4583
    new-instance v0, Landroid/os/AsyncResult;

    new-instance v1, Lcom/android/internal/telephony/Phone$SilentRedialParam;

    iget-object v2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mDialArgs:Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;

    invoke-direct {v1, p1, p2, v2}, Lcom/android/internal/telephony/Phone$SilentRedialParam;-><init>(Ljava/lang/String;ILcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)V

    const/4 p1, 0x0

    invoke-direct {v0, p1, v1, p1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    .line 4585
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mVolteSilentRedialRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method protected onCheckEmergencyCall(Z)V
    .locals 0

    return-void
.end method

.method protected onCheckIfForceHandleInCallMmiByCS()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected onCheckIfIgnoreServiceState()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected onCheckIfIgnoreWifiOnlyModeCheck()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected onCreateGsmMmiCode(Ljava/lang/String;Lcom/android/internal/telephony/uicc/UiccCardApplication;Landroid/os/ResultReceiver;)Lcom/android/internal/telephony/gsm/GsmMmiCode;
    .locals 0

    .line 5071
    iget-object p2, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    .line 5072
    invoke-virtual {p2}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    .line 5071
    invoke-static {p1, p0, p2, p3}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->newFromDialString(Ljava/lang/String;Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/uicc/UiccCardApplication;Landroid/os/ResultReceiver;)Lcom/android/internal/telephony/gsm/GsmMmiCode;

    move-result-object p0

    return-object p0
.end method

.method protected onGetCarrierConfig(Landroid/telephony/CarrierConfigManager;)Landroid/os/PersistableBundle;
    .locals 0

    .line 5020
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    return-object p0
.end method

.method protected onHandleInCallMmi0(Ljava/lang/String;)Z
    .locals 0

    .line 5004
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleCallDeflectionIncallSupplementaryService(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method protected onIncomingUSSD(ILjava/lang/String;)V
    .locals 7

    .line 2864
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "onIncomingUSSD: not expected on GSM"

    .line 2865
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :cond_0
    const/4 v0, 0x0

    const/4 v1, 0x1

    if-ne p1, v1, :cond_1

    move v2, v1

    goto :goto_0

    :cond_1
    move v2, v0

    :goto_0
    if-eqz p1, :cond_2

    if-eq p1, v1, :cond_2

    move v3, v1

    goto :goto_1

    :cond_2
    move v3, v0

    :goto_1
    const/4 v4, 0x2

    if-ne p1, v4, :cond_3

    move p1, v1

    goto :goto_2

    :cond_3
    move p1, v0

    :goto_2
    const/4 v4, 0x0

    .line 2886
    iget-object v5, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v5

    :goto_3
    if-ge v0, v5, :cond_5

    .line 2887
    iget-object v6, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v6, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/android/internal/telephony/gsm/GsmMmiCode;

    invoke-virtual {v6}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->isPendingUSSD()Z

    move-result v6

    if-eqz v6, :cond_4

    .line 2888
    iget-object v4, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v4, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    move-object v4, v0

    check-cast v4, Lcom/android/internal/telephony/gsm/GsmMmiCode;

    goto :goto_4

    :cond_4
    add-int/lit8 v0, v0, 0x1

    goto :goto_3

    :cond_5
    :goto_4
    if-eqz v4, :cond_8

    if-eqz p1, :cond_6

    .line 2896
    invoke-virtual {v4}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->onUssdRelease()V

    goto :goto_5

    :cond_6
    if-eqz v3, :cond_7

    .line 2898
    invoke-virtual {v4}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->onUssdFinishedError()V

    goto :goto_5

    .line 2900
    :cond_7
    invoke-virtual {v4, p2, v2}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->onUssdFinished(Ljava/lang/String;Z)V

    goto :goto_5

    :cond_8
    if-nez v3, :cond_9

    .line 2902
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_9

    .line 2909
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    .line 2912
    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    .line 2909
    invoke-static {p2, v2, p0, p1}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->newNetworkInitiatedUssd(Ljava/lang/String;ZLcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/uicc/UiccCardApplication;)Lcom/android/internal/telephony/gsm/GsmMmiCode;

    move-result-object p1

    .line 2913
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->onNetworkInitiatedUssd(Lcom/android/internal/telephony/MmiCode;)V

    goto :goto_5

    :cond_9
    if-eqz v3, :cond_a

    if-nez p1, :cond_a

    .line 2916
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    .line 2919
    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    .line 2916
    invoke-static {p2, v1, p0, p1}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->newNetworkInitiatedUssd(Ljava/lang/String;ZLcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/uicc/UiccCardApplication;)Lcom/android/internal/telephony/gsm/GsmMmiCode;

    move-result-object p0

    .line 2920
    invoke-virtual {p0}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->onUssdFinishedError()V

    :cond_a
    :goto_5
    return-void
.end method

.method public onMMIDone(Lcom/android/internal/telephony/MmiCode;)V
    .locals 4

    .line 2825
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "GsmCdmaPhone"

    if-nez v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Lcom/android/internal/telephony/MmiCode;->isUssdRequest()Z

    move-result v0

    if-nez v0, :cond_1

    move-object v0, p1

    check-cast v0, Lcom/android/internal/telephony/gsm/GsmMmiCode;

    .line 2826
    invoke-virtual {v0}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->isSsInfo()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 2839
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onMMIDone: invalid response or already handled; ignoring: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_2

    .line 2827
    :cond_1
    :goto_0
    invoke-interface {p1}, Lcom/android/internal/telephony/MmiCode;->getUssdCallbackReceiver()Landroid/os/ResultReceiver;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 2829
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "onMMIDone: invoking callback: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 2830
    invoke-interface {p1}, Lcom/android/internal/telephony/MmiCode;->getState()Lcom/android/internal/telephony/MmiCode$State;

    move-result-object v1

    sget-object v2, Lcom/android/internal/telephony/MmiCode$State;->COMPLETE:Lcom/android/internal/telephony/MmiCode$State;

    if-ne v1, v2, :cond_2

    const/16 v1, 0x64

    goto :goto_1

    :cond_2
    const/4 v1, -0x1

    .line 2832
    :goto_1
    invoke-interface {p1}, Lcom/android/internal/telephony/MmiCode;->getDialString()Ljava/lang/String;

    move-result-object v2

    invoke-interface {p1}, Lcom/android/internal/telephony/MmiCode;->getMessage()Ljava/lang/CharSequence;

    move-result-object p1

    invoke-virtual {p0, v2, p1, v1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->sendUssdResponse(Ljava/lang/String;Ljava/lang/CharSequence;ILandroid/os/ResultReceiver;)V

    goto :goto_2

    .line 2835
    :cond_3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onMMIDone: notifying registrants: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 2836
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mMmiCompleteRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    :goto_2
    return-void
.end method

.method protected onNetworkInitiatedUssd(Lcom/android/internal/telephony/MmiCode;)V
    .locals 2

    .line 2857
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onNetworkInitiatedUssd: mmi="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "GsmCdmaPhone"

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 2858
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mMmiCompleteRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method protected onPendingMmiAdded(Ljava/lang/String;Lcom/android/internal/telephony/gsm/GsmMmiCode;)V
    .locals 0

    return-void
.end method

.method protected onSetUseImsForCall(Z)Z
    .locals 0

    return p1
.end method

.method protected onSetUseImsForUt(Z)Z
    .locals 0

    return p1
.end method

.method protected onUpdateIccAvailability()V
    .locals 5

    .line 3456
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    if-nez v0, :cond_0

    return-void

    .line 3463
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x3

    const/4 v2, 0x0

    if-nez v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 3464
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v3, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    .line 3465
    invoke-virtual {v0, v3, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 3469
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getIccRecords()Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IsimUiccRecords;

    const-string v3, "New ISIM application found"

    .line 3470
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    move-object v0, v2

    .line 3472
    :goto_0
    iput-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIsimUiccRecords:Lcom/android/internal/telephony/uicc/IsimUiccRecords;

    .line 3476
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz v0, :cond_4

    .line 3477
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/IccRecords;->unregisterForRecordsLoaded(Landroid/os/Handler;)V

    .line 3479
    :cond_4
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    const/4 v3, 0x1

    if-nez v0, :cond_6

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    if-eqz v0, :cond_5

    goto :goto_1

    .line 3491
    :cond_5
    iput-object v2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    goto :goto_3

    .line 3480
    :cond_6
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v4, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v4, v3}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    if-eqz v0, :cond_7

    .line 3484
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getIccRecords()Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/SIMRecords;

    goto :goto_2

    :cond_7
    move-object v0, v2

    .line 3486
    :goto_2
    iput-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz v0, :cond_8

    .line 3488
    invoke-virtual {v0, p0, v1, v2}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 3495
    :cond_8
    :goto_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getUiccCardApplication()Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    .line 3496
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-nez v1, :cond_9

    if-nez v0, :cond_9

    const-string v0, "can\'t find 3GPP2 application; trying APP_FAM_3GPP"

    .line 3497
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3498
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v1, v3}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    .line 3502
    :cond_9
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    if-eq v1, v0, :cond_d

    if-eqz v1, :cond_b

    const-string v1, "Removing stale icc objects."

    .line 3505
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3506
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_a

    .line 3507
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->unregisterForIccRecordEvents()V

    .line 3508
    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccPhoneBookIntManager:Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;->updateIccRecords(Lcom/android/internal/telephony/uicc/IccRecords;)V

    .line 3510
    :cond_a
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1, v2}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    .line 3511
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1, v2}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    :cond_b
    if-eqz v0, :cond_d

    .line 3515
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "New Uicc application found. type = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getType()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3517
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getIccRecords()Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object v1

    .line 3518
    iget-object v2, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v2, v0}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    .line 3519
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    .line 3520
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->registerForIccRecordEvents()V

    .line 3521
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mIccPhoneBookIntManager:Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;->updateIccRecords(Lcom/android/internal/telephony/uicc/IccRecords;)V

    if-eqz v1, :cond_c

    .line 3523
    invoke-virtual {v1}, Lcom/android/internal/telephony/uicc/IccRecords;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v0

    .line 3525
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "New simOperatorNumeric = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3527
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_c

    .line 3528
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {v1}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object v1

    iget v2, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v1, v2, v0}, Landroid/telephony/TelephonyManager;->setSimOperatorNumericForPhone(ILjava/lang/String;)V

    .line 3532
    :cond_c
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->updateCurrentCarrierInProvider()Z

    .line 3536
    :cond_d
    sget v0, Lcom/android/internal/telephony/GsmCdmaPhone;->ENABLE_UICC_APPS_MAX_RETRIES:I

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->reapplyUiccAppsEnablementIfNeeded(I)V

    return-void
.end method

.method protected phoneObjectUpdater(I)V
    .locals 7

    .line 4151
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "phoneObjectUpdater: newVoiceRadioTech="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4154
    invoke-static {p1}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v0

    if-nez v0, :cond_0

    if-nez p1, :cond_3

    .line 4157
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v2, "carrier_config"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 4158
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v0, v2}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    if-eqz v0, :cond_2

    const-string/jumbo v2, "volte_replacement_rat_int"

    .line 4161
    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v0

    .line 4162
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "phoneObjectUpdater: volteReplacementRat="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    if-eqz v0, :cond_3

    .line 4165
    invoke-static {v0}, Landroid/telephony/ServiceState;->isGsm(I)Z

    move-result v2

    if-nez v2, :cond_1

    .line 4166
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isCdmaSubscriptionAppPresent()Z

    move-result v2

    if-eqz v2, :cond_3

    :cond_1
    move p1, v0

    goto :goto_0

    :cond_2
    const-string v0, "phoneObjectUpdater: didn\'t get volteReplacementRat from carrier config"

    .line 4170
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 4174
    :cond_3
    :goto_0
    iget v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mRilVersion:I

    const/4 v2, 0x2

    const/4 v3, 0x6

    const-string v4, " mActivePhone="

    const/4 v5, 0x1

    if-ne v0, v3, :cond_5

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getLteOnCdmaMode()I

    move-result v0

    if-ne v0, v5, :cond_5

    .line 4179
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getPhoneType()I

    move-result v0

    if-ne v0, v2, :cond_4

    .line 4180
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "phoneObjectUpdater: LTE ON CDMA property is set. Use CDMA Phone newVoiceRadioTech="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 4182
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 4180
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return-void

    .line 4185
    :cond_4
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "phoneObjectUpdater: LTE ON CDMA property is set. Switch to CDMALTEPhone newVoiceRadioTech="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 4187
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 4185
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    move p1, v3

    goto :goto_1

    .line 4194
    :cond_5
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isShuttingDown()Z

    move-result v0

    if-eqz v0, :cond_6

    const-string p1, "Device is shutting down. No need to switch phone now."

    .line 4195
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return-void

    .line 4199
    :cond_6
    invoke-static {p1}, Landroid/telephony/ServiceState;->isCdma(I)Z

    move-result v0

    .line 4200
    invoke-static {p1}, Landroid/telephony/ServiceState;->isGsm(I)Z

    move-result v3

    if-eqz v0, :cond_7

    .line 4201
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getPhoneType()I

    move-result v6

    if-eq v6, v2, :cond_8

    :cond_7
    if-eqz v3, :cond_9

    .line 4202
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getPhoneType()I

    move-result v2

    if-ne v2, v5, :cond_9

    .line 4204
    :cond_8
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->correctPhoneTypeForCdma(ZI)Z

    move-result v2

    if-nez v2, :cond_9

    .line 4206
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "phoneObjectUpdater: No change ignore, newVoiceRadioTech="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 4208
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 4206
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return-void

    :cond_9
    if-nez v0, :cond_a

    if-nez v3, :cond_a

    .line 4213
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " doesn\'t match either CDMA or GSM - error! No phone change"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-void

    :cond_a
    :goto_1
    if-nez p1, :cond_b

    .line 4222
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "phoneObjectUpdater: Unknown rat ignore,  newVoiceRadioTech=Unknown. mActivePhone="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 4223
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 4222
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return-void

    .line 4228
    :cond_b
    iget-boolean v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mResetModemOnRadioTechnologyChange:Z

    const/4 v1, 0x0

    const/4 v2, 0x0

    if-eqz v0, :cond_c

    .line 4229
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    if-ne v0, v5, :cond_c

    const-string v0, "phoneObjectUpdater: Setting Radio Power to Off"

    .line 4231
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4232
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, v2, v1}, Lcom/android/internal/telephony/CommandsInterface;->setRadioPower(ZLandroid/os/Message;)V

    goto :goto_2

    :cond_c
    move v5, v2

    .line 4236
    :goto_2
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->switchVoiceRadioTech(I)V

    .line 4238
    iget-boolean v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mResetModemOnRadioTechnologyChange:Z

    if-eqz v0, :cond_d

    if-eqz v5, :cond_d

    const-string v0, "phoneObjectUpdater: Resetting Radio"

    .line 4239
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4240
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, v5, v1}, Lcom/android/internal/telephony/CommandsInterface;->setRadioPower(ZLandroid/os/Message;)V

    .line 4244
    :cond_d
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object v0

    if-eqz v0, :cond_e

    .line 4246
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/uicc/UiccProfile;->setVoiceRadioTech(I)V

    .line 4250
    :cond_e
    new-instance p1, Landroid/content/Intent;

    const-string v0, "android.intent.action.RADIO_TECHNOLOGY"

    invoke-direct {p1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 4251
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "phoneName"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 4252
    iget v0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-static {p1, v0}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    .line 4253
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    sget-object v0, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    invoke-virtual {p0, p1, v0}, Landroid/content/Context;->sendStickyBroadcastAsUser(Landroid/content/Intent;Landroid/os/UserHandle;)V

    return-void
.end method

.method protected processIccRecordEvents(I)V
    .locals 1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_0

    goto :goto_0

    :cond_0
    const-string p1, "processIccRecordEvents: EVENT_CFI"

    .line 3544
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    .line 3545
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyCallForwardingIndicator()V

    :goto_0
    return-void
.end method

.method public queryCLIP(Landroid/os/Message;)V
    .locals 2

    .line 2583
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2584
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2585
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/Phone;->queryCLIP(Landroid/os/Message;)V

    return-void

    .line 2589
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2590
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->queryCLIP(Landroid/os/Message;)V

    goto :goto_0

    :cond_1
    const-string v0, "queryCLIP: not possible in CDMA"

    .line 2592
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    .line 2593
    new-instance v0, Lcom/android/internal/telephony/CommandException;

    sget-object v1, Lcom/android/internal/telephony/CommandException$Error;->REQUEST_NOT_SUPPORTED:Lcom/android/internal/telephony/CommandException$Error;

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/CommandException;-><init>(Lcom/android/internal/telephony/CommandException$Error;)V

    invoke-static {p1, p0, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2595
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    :goto_0
    return-void
.end method

.method protected reapplyUiccAppsEnablementIfNeeded(I)V
    .locals 5

    .line 4747
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlotForPhone(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 4750
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object v1

    sget-object v2, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_PRESENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-ne v1, v2, :cond_3

    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mUiccApplicationsEnabled:Ljava/lang/Boolean;

    if-nez v1, :cond_0

    goto :goto_1

    .line 4757
    :cond_0
    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortIndexFromPhoneId(I)I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getIccId(I)Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_1

    .line 4759
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "reapplyUiccAppsEnablementIfNeeded iccId is null, phoneId: "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " portIndex: "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    .line 4760
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortIndexFromPhoneId(I)I

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 4759
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-void

    .line 4764
    :cond_1
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    .line 4765
    invoke-static {v1}, Lcom/android/internal/telephony/uicc/IccUtils;->stripTrailingFs(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 4764
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->getSubInfoForIccId(Ljava/lang/String;)Landroid/telephony/SubscriptionInfo;

    move-result-object v0

    if-nez v0, :cond_2

    const/4 v0, 0x1

    goto :goto_0

    .line 4768
    :cond_2
    invoke-virtual {v0}, Landroid/telephony/SubscriptionInfo;->areUiccApplicationsEnabled()Z

    move-result v0

    .line 4772
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mUiccApplicationsEnabled:Ljava/lang/Boolean;

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    if-eq v0, v1, :cond_3

    .line 4773
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v2, 0x38

    new-instance v3, Landroid/util/Pair;

    .line 4775
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v4

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-direct {v3, v4, p1}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 4773
    invoke-static {p0, v2, v3}, Landroid/os/Message;->obtain(Landroid/os/Handler;ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v1, v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->enableUiccApplications(ZLandroid/os/Message;)V

    :cond_3
    :goto_1
    return-void
.end method

.method public registerForCallWaiting(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 2788
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->registerForCallWaiting(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForCdmaOtaStatusChange(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 2757
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2, p3}, Lcom/android/internal/telephony/CommandsInterface;->registerForCdmaOtaProvision(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForEcmTimerReset(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 4563
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmTimerResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method protected registerForIccRecordEvents()V
    .locals 4

    .line 3758
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-nez v0, :cond_0

    return-void

    .line 3762
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    const/4 v2, 0x3

    const/4 v3, 0x0

    if-eqz v1, :cond_1

    const/16 v1, 0x1c

    .line 3763
    invoke-virtual {v0, p0, v1, v3}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForNetworkSelectionModeAutomatic(Landroid/os/Handler;ILjava/lang/Object;)V

    const/16 v1, 0x1d

    .line 3765
    invoke-virtual {v0, p0, v1, v3}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForRecordsEvents(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 3766
    invoke-virtual {v0, p0, v2, v3}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V

    goto :goto_0

    :cond_1
    const/16 v1, 0x16

    .line 3768
    invoke-virtual {v0, p0, v1, v3}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 3769
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 3771
    invoke-virtual {v0, p0, v2, v3}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V

    :cond_2
    :goto_0
    return-void
.end method

.method public registerForSimRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 956
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mSimRecordsLoadedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForSubscriptionInfoReady(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 2767
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForSubscriptionInfoReady(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForSuppServiceNotification(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 946
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForVolteSilentRedial(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 4573
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mVolteSilentRedialRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public rejectCall()V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 976
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->rejectCall()V

    return-void
.end method

.method public resetCarrierKeysForImsiEncryption()V
    .locals 2

    .line 2121
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCIM:Lcom/android/internal/telephony/CarrierInfoManager;

    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    iget p0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-virtual {v0, v1, p0}, Lcom/android/internal/telephony/CarrierInfoManager;->resetCarrierKeysForImsiEncryption(Landroid/content/Context;I)V

    return-void
.end method

.method public resolveSubscriptionCarrierId(Ljava/lang/String;)V
    .locals 0

    .line 2103
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    if-eqz p0, :cond_0

    .line 2104
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CarrierResolver;->resolveSubscriptionCarrierId(Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method public sendBurstDtmf(Ljava/lang/String;IILandroid/os/Message;)V
    .locals 4

    .line 1816
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "[GsmCdmaPhone] sendBurstDtmf() is a CDMA method"

    .line 1817
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_2

    :cond_0
    const/4 v0, 0x0

    move v1, v0

    .line 1820
    :goto_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 1821
    invoke-virtual {p1, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    invoke-static {v2}, Landroid/telephony/PhoneNumberUtils;->is12Key(C)Z

    move-result v2

    if-nez v2, :cond_1

    .line 1822
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "sendDtmf called with invalid character \'"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1823
    invoke-virtual {p1, v1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, "\'"

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "GsmCdmaPhone"

    .line 1822
    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    const/4 v0, 0x1

    .line 1828
    :goto_1
    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v1, v1, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mState:Lcom/android/internal/telephony/PhoneConstants$State;

    sget-object v2, Lcom/android/internal/telephony/PhoneConstants$State;->OFFHOOK:Lcom/android/internal/telephony/PhoneConstants$State;

    if-ne v1, v2, :cond_3

    if-eqz v0, :cond_3

    .line 1829
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/CommandsInterface;->sendBurstDtmf(Ljava/lang/String;IILandroid/os/Message;)V

    :cond_3
    :goto_2
    return-void
.end method

.method public sendDtmf(C)V
    .locals 2

    .line 1791
    invoke-static {p1}, Landroid/telephony/PhoneNumberUtils;->is12Key(C)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1792
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "sendDtmf called with invalid character \'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string p1, "\'"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 1794
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mState:Lcom/android/internal/telephony/PhoneConstants$State;

    sget-object v1, Lcom/android/internal/telephony/PhoneConstants$State;->OFFHOOK:Lcom/android/internal/telephony/PhoneConstants$State;

    if-ne v0, v1, :cond_1

    .line 1795
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p0, p1, v0}, Lcom/android/internal/telephony/CommandsInterface;->sendDtmf(CLandroid/os/Message;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public sendEmergencyCallStateChange(Z)V
    .locals 2

    .line 897
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    if-nez v0, :cond_0

    const-string p1, "sendEmergencyCallStateChange - skip for non-cdma"

    .line 899
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logi(Ljava/lang/String;)V

    return-void

    .line 902
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mBroadcastEmergencyCallStateChanges:Z

    if-eqz v0, :cond_1

    .line 903
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.EMERGENCY_CALL_STATE_CHANGED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "android.telephony.extra.PHONE_IN_EMERGENCY_CALL"

    .line 904
    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 905
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-static {v0, v1}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    .line 906
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    sget-object v1, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->sendStickyBroadcastAsUser(Landroid/content/Intent;Landroid/os/UserHandle;)V

    .line 907
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "sendEmergencyCallStateChange: callActive "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GsmCdmaPhone"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-void
.end method

.method public sendUssdResponse(Ljava/lang/String;)V
    .locals 3

    .line 1779
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1780
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccApplication:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/UiccCardApplication;

    invoke-static {p1, p0, v0}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->newFromUssdUserInput(Ljava/lang/String;Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/uicc/UiccCardApplication;)Lcom/android/internal/telephony/gsm/GsmMmiCode;

    move-result-object v0

    .line 1781
    iget-object v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mPendingMMIs:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 1782
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mMmiRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v1, Landroid/os/AsyncResult;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v0, v2}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    .line 1783
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/gsm/GsmMmiCode;->sendUssd(Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, "sendUssdResponse: not possible in CDMA"

    .line 1785
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method protected sendUssdResponse(Ljava/lang/String;Ljava/lang/CharSequence;ILandroid/os/ResultReceiver;)V
    .locals 0

    .line 1734
    new-instance p0, Landroid/telephony/UssdResponse;

    invoke-direct {p0, p1, p2}, Landroid/telephony/UssdResponse;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;)V

    .line 1735
    new-instance p1, Landroid/os/Bundle;

    invoke-direct {p1}, Landroid/os/Bundle;-><init>()V

    const-string p2, "USSD_RESPONSE"

    .line 1736
    invoke-virtual {p1, p2, p0}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 1737
    invoke-virtual {p4, p3, p1}, Landroid/os/ResultReceiver;->send(ILandroid/os/Bundle;)V

    return-void
.end method

.method public setBroadcastEmergencyCallStateChanges(Z)V
    .locals 0

    .line 913
    iput-boolean p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mBroadcastEmergencyCallStateChanges:Z

    return-void
.end method

.method public setCallBarring(Ljava/lang/String;ZLjava/lang/String;Landroid/os/Message;I)V
    .locals 7

    .line 2511
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2512
    invoke-virtual {p0, p4}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    move-object v1, p1

    move v2, p2

    move-object v3, p3

    move-object v4, p4

    move v5, p5

    .line 2513
    invoke-interface/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneInternalInterface;->setCallBarring(Ljava/lang/String;ZLjava/lang/String;Landroid/os/Message;I)V

    return-void

    .line 2517
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2518
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    move-object v2, p1

    move v3, p2

    move-object v4, p3

    move v5, p5

    move-object v6, p4

    invoke-interface/range {v1 .. v6}, Lcom/android/internal/telephony/CommandsInterface;->setFacilityLock(Ljava/lang/String;ZLjava/lang/String;ILandroid/os/Message;)V

    goto :goto_0

    :cond_1
    const-string p1, "setCallBarringOption: not possible in CDMA"

    .line 2520
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public setCallForwardingOption(IILjava/lang/String;IILandroid/os/Message;)V
    .locals 7

    .line 2442
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2443
    invoke-virtual {p0, p6}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    move v1, p1

    move v2, p2

    move-object v3, p3

    move v4, p4

    move v5, p5

    move-object v6, p6

    .line 2444
    invoke-interface/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneInternalInterface;->setCallForwardingOption(IILjava/lang/String;IILandroid/os/Message;)V

    return-void

    .line 2449
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 2450
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isValidCommandInterfaceCFAction(I)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 2451
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->isValidCommandInterfaceCFReason(I)Z

    move-result v0

    if-eqz v0, :cond_4

    if-nez p2, :cond_1

    .line 2455
    new-instance v0, Lcom/android/internal/telephony/GsmCdmaPhone$Cfu;

    invoke-direct {v0, p3, p6}, Lcom/android/internal/telephony/GsmCdmaPhone$Cfu;-><init>(Ljava/lang/String;Landroid/os/Message;)V

    const/16 p6, 0xc

    .line 2457
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isCfEnable(I)Z

    move-result v1

    const/4 v2, 0x0

    .line 2456
    invoke-virtual {p0, p6, v1, v2, v0}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p6

    :cond_1
    move-object v6, p6

    .line 2461
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    move v1, p1

    move v2, p2

    move v3, p4

    move-object v4, p3

    move v5, p5

    invoke-interface/range {v0 .. v6}, Lcom/android/internal/telephony/CommandsInterface;->setCallForward(IIILjava/lang/String;ILandroid/os/Message;)V

    goto :goto_0

    .line 2468
    :cond_2
    iget-boolean p4, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsOverCdmaSupported:Z

    const/16 p5, 0xff

    const/4 v0, 0x0

    if-eqz p4, :cond_3

    .line 2469
    invoke-static {p3}, Lcom/android/internal/telephony/GsmCdmaConnection;->formatDialString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p4

    .line 2470
    invoke-static {p1, p2, p4}, Lcom/android/internal/telephony/cdma/CdmaMmiCode;->getCallForwardingPrefixAndNumber(IILjava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 2472
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "setCallForwardingOption: dial for set call forwarding prefixWithNumber= "

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p4, " number= "

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 2475
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->subscriptionIdToPhoneAccountHandle(I)Landroid/telecom/PhoneAccountHandle;

    move-result-object p2

    .line 2476
    new-instance p3, Landroid/os/Bundle;

    invoke-direct {p3}, Landroid/os/Bundle;-><init>()V

    const-string p4, "android.telecom.extra.PHONE_ACCOUNT_HANDLE"

    .line 2477
    invoke-virtual {p3, p4, p2}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 2479
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {p0}, Landroid/telecom/TelecomManager;->from(Landroid/content/Context;)Landroid/telecom/TelecomManager;

    move-result-object p0

    const-string/jumbo p2, "tel"

    .line 2481
    invoke-static {p2, p1, v0}, Landroid/net/Uri;->fromParts(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 2480
    invoke-virtual {p0, p1, p3}, Landroid/telecom/TelecomManager;->placeCall(Landroid/net/Uri;Landroid/os/Bundle;)V

    .line 2483
    invoke-static {p5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-static {p6, p0, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2484
    invoke-virtual {p6}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    :cond_3
    const-string p1, "setCallForwardingOption: SS over CDMA not supported, can not complete"

    .line 2486
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 2487
    invoke-static {p5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-static {p6, p0, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2488
    invoke-virtual {p6}, Landroid/os/Message;->sendToTarget()V

    :cond_4
    :goto_0
    return-void
.end method

.method public setCallForwardingOption(IILjava/lang/String;ILandroid/os/Message;)V
    .locals 7

    const/4 v4, 0x1

    move-object v0, p0

    move v1, p1

    move v2, p2

    move-object v3, p3

    move v5, p4

    move-object v6, p5

    .line 2431
    invoke-virtual/range {v0 .. v6}, Lcom/android/internal/telephony/GsmCdmaPhone;->setCallForwardingOption(IILjava/lang/String;IILandroid/os/Message;)V

    return-void
.end method

.method public setCallWaiting(ZILandroid/os/Message;)V
    .locals 4

    .line 2642
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2643
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2644
    invoke-interface {v0, p1, p3}, Lcom/android/internal/telephony/PhoneInternalInterface;->setCallWaiting(ZLandroid/os/Message;)V

    return-void

    .line 2648
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2649
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2, p3}, Lcom/android/internal/telephony/CommandsInterface;->setCallWaiting(ZILandroid/os/Message;)V

    goto :goto_0

    .line 2650
    :cond_1
    iget-boolean p2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsOverCdmaSupported:Z

    const/16 v0, 0xff

    const/4 v1, 0x0

    if-eqz p2, :cond_2

    .line 2651
    invoke-static {p1}, Lcom/android/internal/telephony/cdma/CdmaMmiCode;->getCallWaitingPrefix(Z)Ljava/lang/String;

    move-result-object p1

    .line 2652
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setCallWaiting in CDMA : dial for set call waiting prefix= "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v2, "GsmCdmaPhone"

    invoke-static {v2, p2}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 2654
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->subscriptionIdToPhoneAccountHandle(I)Landroid/telecom/PhoneAccountHandle;

    move-result-object p2

    .line 2655
    new-instance v2, Landroid/os/Bundle;

    invoke-direct {v2}, Landroid/os/Bundle;-><init>()V

    const-string v3, "android.telecom.extra.PHONE_ACCOUNT_HANDLE"

    .line 2656
    invoke-virtual {v2, v3, p2}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 2658
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {p0}, Landroid/telecom/TelecomManager;->from(Landroid/content/Context;)Landroid/telecom/TelecomManager;

    move-result-object p0

    const-string/jumbo p2, "tel"

    .line 2660
    invoke-static {p2, p1, v1}, Landroid/net/Uri;->fromParts(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    .line 2659
    invoke-virtual {p0, p1, v2}, Landroid/telecom/TelecomManager;->placeCall(Landroid/net/Uri;Landroid/os/Bundle;)V

    .line 2662
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-static {p3, p0, v1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2663
    invoke-virtual {p3}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    :cond_2
    const-string p1, "setCallWaiting: SS over CDMA not supported, can not complete"

    .line 2665
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 2666
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-static {p3, p0, v1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2667
    invoke-virtual {p3}, Landroid/os/Message;->sendToTarget()V

    :goto_0
    return-void
.end method

.method public setCallWaiting(ZLandroid/os/Message;)V
    .locals 3

    .line 2631
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 2632
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    const-string v2, "call_waiting_service_class_int"

    .line 2634
    invoke-virtual {v0, v2, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 2637
    :cond_0
    invoke-virtual {p0, p1, v1, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->setCallWaiting(ZILandroid/os/Message;)V

    return-void
.end method

.method public setCarrierInfoForImsiEncryption(Landroid/telephony/ImsiEncryptionInfo;)V
    .locals 2

    .line 2061
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    invoke-static {p1, v0, v1}, Lcom/android/internal/telephony/CarrierInfoManager;->setCarrierInfoForImsiEncryption(Landroid/telephony/ImsiEncryptionInfo;Landroid/content/Context;I)V

    .line 2062
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p0, p1, v0}, Lcom/android/internal/telephony/CommandsInterface;->setCarrierInfoForImsiEncryption(Landroid/telephony/ImsiEncryptionInfo;Landroid/os/Message;)V

    return-void
.end method

.method public setCarrierTestOverride(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 12

    move-object v0, p0

    move-object/from16 v1, p8

    .line 2127
    iget-object v2, v0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    move-object/from16 v3, p9

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/CarrierResolver;->setTestOverrideApn(Ljava/lang/String;)V

    .line 2128
    iget-object v2, v0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccProfileForPhone(I)Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object v2

    const/4 v3, 0x0

    if-eqz v2, :cond_2

    if-nez v1, :cond_0

    move-object v1, v3

    goto :goto_0

    .line 2133
    :cond_0
    invoke-virtual/range {p8 .. p8}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1

    .line 2134
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v1

    goto :goto_0

    .line 2136
    :cond_1
    new-instance v4, Landroid/telephony/UiccAccessRule;

    .line 2137
    invoke-static/range {p8 .. p8}, Lcom/android/internal/telephony/uicc/IccUtils;->hexStringToBytes(Ljava/lang/String;)[B

    move-result-object v1

    const-wide/16 v5, 0x0

    invoke-direct {v4, v1, v3, v5, v6}, Landroid/telephony/UiccAccessRule;-><init>([BLjava/lang/String;J)V

    .line 2138
    invoke-static {v4}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    .line 2140
    :goto_0
    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/uicc/UiccProfile;->setTestOverrideCarrierPrivilegeRules(Ljava/util/List;)V

    goto :goto_1

    .line 2143
    :cond_2
    iget-object v2, v0, Lcom/android/internal/telephony/Phone;->mCarrierResolver:Lcom/android/internal/telephony/CarrierResolver;

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/CarrierResolver;->setTestOverrideCarrierPriviledgeRule(Ljava/lang/String;)V

    .line 2146
    :goto_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_3

    .line 2147
    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    move-object v3, v0

    check-cast v3, Lcom/android/internal/telephony/uicc/IccRecords;

    :goto_2
    move-object v4, v3

    goto :goto_3

    .line 2148
    :cond_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v1

    if-eqz v1, :cond_4

    .line 2149
    iget-object v3, v0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    goto :goto_2

    :cond_4
    const-string v1, "setCarrierTestOverride fails in CDMA only"

    .line 2151
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_2

    :goto_3
    if-eqz v4, :cond_5

    move-object v5, p1

    move-object v6, p2

    move-object v7, p3

    move-object/from16 v8, p4

    move-object/from16 v9, p5

    move-object/from16 v10, p6

    move-object/from16 v11, p7

    .line 2154
    invoke-virtual/range {v4 .. v11}, Lcom/android/internal/telephony/uicc/IccRecords;->setCarrierTestOverride(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_5
    return-void
.end method

.method public setCellBroadcastSmsConfig([ILandroid/os/Message;)V
    .locals 0

    const-string p1, "[GsmCdmaPhone] setCellBroadcastSmsConfig() is obsolete; use SmsManager"

    .line 3668
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    .line 3669
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public setDataRoamingEnabled(Z)V
    .locals 2

    .line 2745
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2746
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataSettingsManager;->setDataRoamingEnabled(Z)V

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 2749
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 2750
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object p0

    .line 2751
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->setDataRoamingEnabledByUser(Z)V

    :cond_1
    return-void
.end method

.method public setImsRegistrationState(Z)V
    .locals 0

    .line 4300
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->setImsRegistrationState(Z)V

    return-void
.end method

.method protected setIsInEmergencyCall()V
    .locals 1

    .line 874
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_0

    .line 875
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->setIsInEmergencyCall()V

    :cond_0
    return-void
.end method

.method public setLine1Number(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)Z
    .locals 2

    .line 2279
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2280
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_0

    .line 2282
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/uicc/IccRecords;->setMsisdnNumber(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V

    const/4 p0, 0x1

    return p0

    :cond_0
    return v1

    :cond_1
    const-string p1, "setLine1Number: not possible in CDMA"

    .line 2288
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return v1
.end method

.method public setLinkCapacityReportingCriteria([I[II)V
    .locals 8

    .line 4283
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0xbb8

    const/16 v2, 0x32

    const/16 v3, 0x32

    const/4 v7, 0x0

    move-object v4, p1

    move-object v5, p2

    move v6, p3

    invoke-interface/range {v0 .. v7}, Lcom/android/internal/telephony/CommandsInterface;->setLinkCapacityReportingCriteria(III[I[IILandroid/os/Message;)V

    return-void
.end method

.method public setMute(Z)V
    .locals 0

    .line 2709
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->setMute(Z)V

    return-void
.end method

.method public setOnEcbModeExitResponse(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2778
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    iput-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmExitRespRegistrant:Lcom/android/internal/telephony/Registrant;

    return-void
.end method

.method public setOperatorBrandOverride(Ljava/lang/String;)Z
    .locals 3

    .line 4368
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 4372
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccPort(I)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v0

    if-nez v0, :cond_1

    return v1

    .line 4377
    :cond_1
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->setOperatorBrandOverride(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 4381
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object v0

    .line 4382
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    iget-object v2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {v2}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceProviderName()Ljava/lang/String;

    move-result-object v2

    .line 4381
    invoke-virtual {v0, v1, v2}, Landroid/telephony/TelephonyManager;->setSimOperatorNameForPhone(ILjava/lang/String;)V

    .line 4384
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->pollState()V

    :cond_2
    return p1
.end method

.method public setOutgoingCallerIdDisplay(ILandroid/os/Message;)V
    .locals 3

    .line 2561
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 2562
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->useSsOverIms(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2563
    invoke-interface {v0, p1, p2}, Lcom/android/internal/telephony/PhoneInternalInterface;->setOutgoingCallerIdDisplay(ILandroid/os/Message;)V

    return-void

    .line 2567
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2571
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x12

    const/4 v2, 0x0

    .line 2572
    invoke-virtual {p0, v1, p1, v2, p2}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 2571
    invoke-interface {v0, p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->setCLIR(ILandroid/os/Message;)V

    goto :goto_0

    :cond_1
    const-string p1, "setOutgoingCallerIdDisplay: not possible in CDMA"

    .line 2574
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    .line 2575
    new-instance p1, Lcom/android/internal/telephony/CommandException;

    sget-object v0, Lcom/android/internal/telephony/CommandException$Error;->REQUEST_NOT_SUPPORTED:Lcom/android/internal/telephony/CommandException$Error;

    invoke-direct {p1, v0}, Lcom/android/internal/telephony/CommandException;-><init>(Lcom/android/internal/telephony/CommandException$Error;)V

    invoke-static {p2, p0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 2577
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    :goto_0
    return-void
.end method

.method public setRadioPower(ZZZZ)V
    .locals 6

    const/4 v5, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    .line 1847
    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/GsmCdmaPhone;->setRadioPowerForReason(ZZZZI)V

    return-void
.end method

.method public setRadioPowerForReason(ZZZZI)V
    .locals 6

    .line 1854
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/ServiceStateTracker;->setRadioPowerForReason(ZZZZI)V

    return-void
.end method

.method public setRadioPowerOnForTestEmergencyCall(Z)V
    .locals 2

    .line 1836
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->clearAllRadioOffReasons()V

    const/4 v0, 0x1

    const/4 v1, 0x0

    .line 1841
    invoke-virtual {p0, v0, v1, p1, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->setRadioPower(ZZZZ)V

    return-void
.end method

.method public setTTYMode(ILandroid/os/Message;)V
    .locals 0

    .line 2694
    invoke-super {p0, p1, p2}, Lcom/android/internal/telephony/Phone;->setTTYMode(ILandroid/os/Message;)V

    .line 2695
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz p0, :cond_0

    .line 2696
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/Phone;->setTTYMode(ILandroid/os/Message;)V

    :cond_0
    return-void
.end method

.method public setUiTTYMode(ILandroid/os/Message;)V
    .locals 0

    .line 2702
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz p0, :cond_0

    .line 2703
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/Phone;->setUiTTYMode(ILandroid/os/Message;)V

    :cond_0
    return-void
.end method

.method public setVoiceMailNumber(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .locals 1

    .line 2296
    iput-object p2, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mVmNumber:Ljava/lang/String;

    const/16 p2, 0x14

    const/4 v0, 0x0

    .line 2297
    invoke-virtual {p0, p2, v0, v0, p3}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p2

    .line 2299
    iget-object p3, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p3}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/uicc/IccRecords;

    .line 2301
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSimRecords:Lcom/android/internal/telephony/uicc/SIMRecords;

    if-eqz v0, :cond_0

    move-object p3, v0

    :cond_0
    if-eqz p3, :cond_1

    .line 2306
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mVmNumber:Ljava/lang/String;

    invoke-virtual {p3, p1, p0, p2}, Lcom/android/internal/telephony/uicc/IccRecords;->setVoiceMailNumber(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V

    :cond_1
    return-void
.end method

.method public setVoiceMessageWaiting(II)V
    .locals 1

    .line 4597
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 4598
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v0, :cond_0

    .line 4600
    invoke-virtual {v0, p1, p2}, Lcom/android/internal/telephony/uicc/IccRecords;->setVoiceMessageWaiting(II)V

    goto :goto_0

    :cond_0
    const-string p1, "SIM Records not found, MWI not updated"

    .line 4602
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    goto :goto_0

    .line 4605
    :cond_1
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/Phone;->setVoiceMessageCount(I)V

    :goto_0
    return-void
.end method

.method public setVoiceServiceStateOverride(Z)V
    .locals 2

    const/4 v0, 0x1

    xor-int/2addr p1, v0

    .line 642
    iget v1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mTelecomVoiceServiceStateOverride:I

    if-eq p1, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 643
    :goto_0
    iput p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mTelecomVoiceServiceStateOverride:I

    if-eqz v0, :cond_1

    .line 644
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    if-eqz p0, :cond_1

    .line 645
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->onTelecomVoiceServiceStateOverrideChanged()V

    :cond_1
    return-void
.end method

.method public shouldForceAutoNetworkSelect()Z
    .locals 4

    .line 3696
    sget v0, Lcom/android/internal/telephony/RILConstants;->PREFERRED_NETWORK_MODE:I

    invoke-static {v0}, Landroid/telephony/RadioAccessFamily;->getRafFromNetworkType(I)I

    .line 3698
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 3701
    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 3705
    :cond_0
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/Phone;->getAllowedNetworkTypes(I)J

    move-result-wide v2

    long-to-int v0, v2

    .line 3708
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "shouldForceAutoNetworkSelect in mode = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3713
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isManualSelProhibitedInGlobalMode()Z

    move-result v2

    if-eqz v2, :cond_2

    const/16 v2, 0xa

    .line 3714
    invoke-static {v2}, Landroid/telephony/RadioAccessFamily;->getRafFromNetworkType(I)I

    move-result v2

    if-eq v0, v2, :cond_1

    const/4 v2, 0x7

    .line 3716
    invoke-static {v2}, Landroid/telephony/RadioAccessFamily;->getRafFromNetworkType(I)I

    move-result v2

    if-ne v0, v2, :cond_2

    .line 3718
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Should force auto network select mode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    const/4 p0, 0x1

    return p0

    .line 3721
    :cond_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Should not force auto network select mode = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    return v1
.end method

.method public startConference([Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 1406
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 1407
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->useImsForCall(Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Z

    move-result v1

    .line 1408
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "useImsForCall="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    if-eqz v1, :cond_0

    :try_start_0
    const-string v2, "Trying IMS PS Conference call"

    .line 1411
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1412
    invoke-interface {v0, p1, p2}, Lcom/android/internal/telephony/PhoneInternalInterface;->startConference([Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;

    move-result-object p0
    :try_end_0
    .catch Lcom/android/internal/telephony/CallStateException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p1

    .line 1414
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "IMS PS conference call exception "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo v2, "useImsForCall ="

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", imsPhone ="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 1416
    new-instance p0, Lcom/android/internal/telephony/CallStateException;

    invoke-virtual {p1}, Lcom/android/internal/telephony/CallStateException;->getError()I

    move-result p2

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/CallStateException;-><init>(ILjava/lang/String;)V

    .line 1417
    invoke-virtual {p1}, Ljava/lang/Exception;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/Exception;->setStackTrace([Ljava/lang/StackTraceElement;)V

    .line 1418
    throw p0

    .line 1421
    :cond_0
    new-instance p0, Lcom/android/internal/telephony/CallStateException;

    const/4 p1, 0x1

    const-string p2, "cannot dial conference call in out of service"

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/CallStateException;-><init>(ILjava/lang/String;)V

    throw p0
.end method

.method public startDtmf(C)V
    .locals 2

    .line 1802
    invoke-static {p1}, Landroid/telephony/PhoneNumberUtils;->is12Key(C)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1803
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "startDtmf called with invalid character \'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string p1, "\'"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 1805
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p0, p1, v0}, Lcom/android/internal/telephony/CommandsInterface;->startDtmf(CLandroid/os/Message;)V

    :goto_0
    return-void
.end method

.method public startNetworkScan(Landroid/telephony/NetworkScanRequest;Landroid/os/Message;)V
    .locals 0

    .line 2683
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1, p2}, Lcom/android/internal/telephony/CommandsInterface;->startNetworkScan(Landroid/telephony/NetworkScanRequest;Landroid/os/Message;)V

    return-void
.end method

.method public stopDtmf()V
    .locals 1

    .line 1811
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p0, v0}, Lcom/android/internal/telephony/CommandsInterface;->stopDtmf(Landroid/os/Message;)V

    return-void
.end method

.method public stopNetworkScan(Landroid/os/Message;)V
    .locals 0

    .line 2688
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->stopNetworkScan(Landroid/os/Message;)V

    return-void
.end method

.method protected subscriptionIdToPhoneAccountHandle(I)Landroid/telecom/PhoneAccountHandle;
    .locals 4

    .line 4626
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/telecom/TelecomManager;->from(Landroid/content/Context;)Landroid/telecom/TelecomManager;

    move-result-object v0

    .line 4627
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-static {p0}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object p0

    const/4 v1, 0x1

    .line 4629
    invoke-virtual {v0, v1}, Landroid/telecom/TelecomManager;->getCallCapablePhoneAccounts(Z)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->listIterator()Ljava/util/ListIterator;

    move-result-object v1

    .line 4631
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 4632
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telecom/PhoneAccountHandle;

    .line 4633
    invoke-virtual {v0, v2}, Landroid/telecom/TelecomManager;->getPhoneAccount(Landroid/telecom/PhoneAccountHandle;)Landroid/telecom/PhoneAccount;

    move-result-object v3

    .line 4634
    invoke-virtual {p0, v3}, Landroid/telephony/TelephonyManager;->getSubIdForPhoneAccount(Landroid/telecom/PhoneAccount;)I

    move-result v3

    if-ne p1, v3, :cond_0

    return-object v2

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public supports3gppCallForwardingWhileRoaming()Z
    .locals 2

    .line 2845
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 2846
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    const/4 v0, 0x1

    if-eqz p0, :cond_0

    const-string/jumbo v1, "support_3gpp_call_forwarding_while_roaming_bool"

    .line 2848
    invoke-virtual {p0, v1, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0

    :cond_0
    return v0
.end method

.method public switchHoldingAndActive()V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 981
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->switchWaitingOrHoldingAndActive()V

    return-void
.end method

.method protected switchPhoneType(I)V
    .locals 2

    .line 582
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mExitEcmRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 584
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->initRatSpecific(I)V

    .line 586
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->updatePhoneType()V

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    const-string p1, "GSM"

    goto :goto_0

    :cond_0
    const-string p1, "CDMA"

    .line 587
    :goto_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Phone;->setPhoneName(Ljava/lang/String;)V

    .line 588
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->onUpdateIccAvailability()V

    .line 595
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->unregisterForIccRecordEvents()V

    .line 596
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->registerForIccRecordEvents()V

    .line 598
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->updatePhoneType()V

    .line 600
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result p1

    const/4 v1, 0x2

    if-eq p1, v1, :cond_1

    .line 602
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleRadioAvailable()V

    if-ne p1, v0, :cond_1

    .line 604
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleRadioOn()V

    :cond_1
    if-eq p1, v0, :cond_2

    .line 608
    invoke-direct {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->handleRadioOffOrNotAvailable()V

    :cond_2
    return-void
.end method

.method protected switchVoiceRadioTech(I)V
    .locals 3

    .line 4259
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneName()Ljava/lang/String;

    move-result-object v0

    .line 4261
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Switching Voice Phone : "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " >>> "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 4262
    invoke-static {p1}, Landroid/telephony/ServiceState;->isGsm(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "GSM"

    goto :goto_0

    :cond_0
    const-string v0, "CDMA"

    :goto_0
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 4261
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 4264
    invoke-static {p1}, Landroid/telephony/ServiceState;->isCdma(I)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 4265
    iget-object p1, p0, Lcom/android/internal/telephony/Phone;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget v0, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    const/4 v1, 0x2

    .line 4266
    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 4267
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getType()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object p1

    sget-object v0, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;->APPTYPE_RUIM:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    if-ne p1, v0, :cond_1

    .line 4268
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->switchPhoneType(I)V

    goto :goto_1

    :cond_1
    const/4 p1, 0x6

    .line 4270
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->switchPhoneType(I)V

    goto :goto_1

    .line 4272
    :cond_2
    invoke-static {p1}, Landroid/telephony/ServiceState;->isGsm(I)Z

    move-result v0

    if-eqz v0, :cond_3

    const/4 p1, 0x1

    .line 4273
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->switchPhoneType(I)V

    :goto_1
    return-void

    .line 4275
    :cond_3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "deleteAndCreatePhone: newVoiceRadioTech="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " is not CDMA or GSM (error) - aborting!"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->loge(Ljava/lang/String;)V

    return-void
.end method

.method protected syncClirSetting()V
    .locals 3
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2929
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 2930
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->migrateClirSettingIfNeeded(Landroid/content/SharedPreferences;)V

    .line 2932
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "clir_sub_key"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, -0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    .line 2933
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "syncClirSetting: clir_sub_key"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "GsmCdmaPhone"

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v1, 0x0

    if-ltz v0, :cond_0

    .line 2935
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setCLIR(ILandroid/os/Message;)V

    goto :goto_0

    .line 2939
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p0, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setCLIR(ILandroid/os/Message;)V

    :goto_0
    return-void
.end method

.method public unregisterForCallWaiting(Landroid/os/Handler;)V
    .locals 0

    .line 2793
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->unregisterForCallWaiting(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForCdmaOtaStatusChange(Landroid/os/Handler;)V
    .locals 0

    .line 2762
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForCdmaOtaProvision(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForEcmTimerReset(Landroid/os/Handler;)V
    .locals 0

    .line 4568
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmTimerResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method protected unregisterForIccRecordEvents()V
    .locals 1

    .line 3779
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/IccRecords;

    if-nez v0, :cond_0

    return-void

    .line 3783
    :cond_0
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/IccRecords;->unregisterForNetworkSelectionModeAutomatic(Landroid/os/Handler;)V

    .line 3784
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/IccRecords;->unregisterForRecordsEvents(Landroid/os/Handler;)V

    .line 3785
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/IccRecords;->unregisterForRecordsLoaded(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForSimRecordsLoaded(Landroid/os/Handler;)V
    .locals 0

    .line 961
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mSimRecordsLoadedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForSubscriptionInfoReady(Landroid/os/Handler;)V
    .locals 0

    .line 2772
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForSubscriptionInfoReady(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForSuppServiceNotification(Landroid/os/Handler;)V
    .locals 0

    .line 951
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSsnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForVolteSilentRedial(Landroid/os/Handler;)V
    .locals 0

    .line 4578
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mVolteSilentRedialRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unsetOnEcbModeExitResponse(Landroid/os/Handler;)V
    .locals 0

    .line 2783
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mEcmExitRespRegistrant:Lcom/android/internal/telephony/Registrant;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Registrant;->clear()V

    return-void
.end method

.method public updateCurrentCarrierInProvider()Z
    .locals 5

    .line 3557
    invoke-static {}, Landroid/telephony/SubscriptionManager;->getDefaultDataSubscriptionId()I

    move-result v0

    int-to-long v0, v0

    .line 3558
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v2

    .line 3560
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "updateCurrentCarrierInProvider: mSubId = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " currentDds = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v4, " operatorNumeric = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 3563
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v3

    int-to-long v3, v3

    cmp-long v0, v3, v0

    if-nez v0, :cond_0

    .line 3565
    :try_start_0
    sget-object v0, Landroid/provider/Telephony$Carriers;->CONTENT_URI:Landroid/net/Uri;

    const-string v1, "current"

    invoke-static {v0, v1}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 3566
    new-instance v1, Landroid/content/ContentValues;

    invoke-direct {v1}, Landroid/content/ContentValues;-><init>()V

    const-string v3, "numeric"

    .line 3567
    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 3568
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0, v0, v1}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    :try_end_0
    .catch Landroid/database/SQLException; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p0, 0x1

    return p0

    :catch_0
    move-exception p0

    const-string v0, "GsmCdmaPhone"

    const-string v1, "Can\'t store current operator"

    .line 3571
    invoke-static {v0, v1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method protected updateManualNetworkSelection(Lcom/android/internal/telephony/Phone$NetworkSelectMessage;)V
    .locals 2

    .line 2222
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 2223
    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2224
    iget-object p1, p1, Lcom/android/internal/telephony/Phone$NetworkSelectMessage;->operatorNumeric:Ljava/lang/String;

    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mManualNetworkSelectionPlmn:Ljava/lang/String;

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 2227
    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mManualNetworkSelectionPlmn:Ljava/lang/String;

    .line 2228
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "Cannot update network selection due to invalid subId "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "GsmCdmaPhone"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public updatePhoneObject(I)V
    .locals 3

    .line 4294
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updatePhoneObject: radioTechnology="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    const/16 v0, 0x2a

    const/4 v1, 0x0

    const/4 v2, 0x0

    .line 4295
    invoke-virtual {p0, v0, p1, v1, v2}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public updateServiceLocation(Landroid/os/WorkSource;)V
    .locals 0

    .line 2719
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->enableSingleLocationUpdate(Landroid/os/WorkSource;)V

    return-void
.end method

.method public updateVoiceMail()V
    .locals 3

    .line 720
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_2

    const/4 v0, 0x0

    .line 722
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mIccRecords:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v1, :cond_0

    .line 725
    invoke-virtual {v1}, Lcom/android/internal/telephony/uicc/IccRecords;->getVoiceMessageCount()I

    move-result v0

    :cond_0
    const/4 v1, -0x2

    if-ne v0, v1, :cond_1

    .line 728
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getStoredVoiceMessageCount()I

    move-result v0

    .line 730
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateVoiceMail countVoiceMessages = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " subId "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 731
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 730
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->logd(Ljava/lang/String;)V

    .line 732
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->setVoiceMessageCount(I)V

    goto :goto_0

    .line 734
    :cond_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getStoredVoiceMessageCount()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->setVoiceMessageCount(I)V

    :goto_0
    return-void
.end method

.method protected useImsForCall(Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Z
    .locals 1

    .line 1385
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isImsUseEnabled()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_1

    .line 1387
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isVoiceOverCellularImsEnabled()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 1388
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isVideoEnabled()Z

    move-result v0

    if-eqz v0, :cond_1

    iget p1, p1, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->videoState:I

    invoke-static {p1}, Landroid/telecom/VideoProfile;->isVideo(I)Z

    move-result p1

    if-eqz p1, :cond_1

    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 1389
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getState()I

    move-result p0

    if-nez p0, :cond_1

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public useImsForEmergency()Z
    .locals 2

    .line 1393
    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    const-string v1, "carrier_config"

    .line 1394
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    .line 1395
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v1, "carrier_use_ims_first_for_emergency_bool"

    .line 1396
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    .line 1397
    iget-object v1, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v1, :cond_0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/Phone;->mContext:Landroid/content/Context;

    iget v1, p0, Lcom/android/internal/telephony/Phone;->mPhoneId:I

    .line 1399
    invoke-static {v0, v1}, Lcom/android/ims/ImsManager;->getInstance(Landroid/content/Context;I)Lcom/android/ims/ImsManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/ims/ImsManager;->isNonTtyOrTtyOnVolteEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mImsPhone:Lcom/android/internal/telephony/Phone;

    .line 1400
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isImsAvailable()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public useSsOverIms(Landroid/os/Message;)Z
    .locals 3

    .line 2373
    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isUtEnabled()Z

    move-result v0

    .line 2375
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "useSsOverIms: isUtEnabled()= "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " isCsRetry(onComplete))= "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2376
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isCsRetry(Landroid/os/Message;)Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "GsmCdmaPhone"

    .line 2375
    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v0, :cond_0

    .line 2378
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isCsRetry(Landroid/os/Message;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method
