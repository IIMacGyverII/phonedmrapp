.class public abstract Lcom/android/internal/telephony/InboundSmsHandler;
.super Lcom/android/internal/telephony/StateMachine;
.source "InboundSmsHandler.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;,
        Lcom/android/internal/telephony/InboundSmsHandler$CbTestBroadcastReceiver;,
        Lcom/android/internal/telephony/InboundSmsHandler$NewMessageNotificationActionReceiver;,
        Lcom/android/internal/telephony/InboundSmsHandler$CarrierServicesSmsFilterCallback;,
        Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;,
        Lcom/android/internal/telephony/InboundSmsHandler$WaitingState;,
        Lcom/android/internal/telephony/InboundSmsHandler$DeliveringState;,
        Lcom/android/internal/telephony/InboundSmsHandler$IdleState;,
        Lcom/android/internal/telephony/InboundSmsHandler$StartupState;,
        Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;,
        Lcom/android/internal/telephony/InboundSmsHandler$SmsSource;
    }
.end annotation


# static fields
.field private static ACTION_OPEN_SMS_APP:Ljava/lang/String; = null

.field public static final ADDRESS_COLUMN:I = 0x6

.field public static final COUNT_COLUMN:I = 0x5

.field public static final DATE_COLUMN:I = 0x3

.field protected static final DBG:Z = true

.field public static final DELETED_FLAG_COLUMN:I = 0xa

.field public static final DESTINATION_PORT_COLUMN:I = 0x2

.field public static final DISPLAY_ADDRESS_COLUMN:I = 0x9

.field public static final EVENT_BROADCAST_COMPLETE:I = 0x3

.field public static final EVENT_BROADCAST_SMS:I = 0x2

.field public static final EVENT_INJECT_SMS:I = 0x7

.field public static final EVENT_NEW_SMS:I = 0x1

.field public static final EVENT_RECEIVER_TIMEOUT:I = 0x9

.field private static final EVENT_RELEASE_WAKELOCK:I = 0x5

.field protected static final EVENT_RETURN_TO_IDLE:I = 0x4

.field public static final EVENT_START_ACCEPTING_SMS:I = 0x6

.field public static final EVENT_UPDATE_TRACKER:I = 0x8

.field public static final ID_COLUMN:I = 0x7

.field public static final MESSAGE_BODY_COLUMN:I = 0x8

.field public static final NOTIFICATION_ID_NEW_MESSAGE:I = 0x1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final NOTIFICATION_TAG:Ljava/lang/String; = "InboundSmsHandler"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final PDU_COLUMN:I = 0x0

.field protected static final PDU_DELETED_FLAG_PROJECTION:[Ljava/lang/String;

.field private static final PDU_DELETED_FLAG_PROJECTION_INDEX_MAPPING:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field protected static final PDU_SEQUENCE_PORT_PROJECTION:[Ljava/lang/String;

.field protected static final PDU_SEQUENCE_PORT_PROJECTION_INDEX_MAPPING:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field public static final REFERENCE_NUMBER_COLUMN:I = 0x4

.field public static final SELECT_BY_ID:Ljava/lang/String; = "_id=?"

.field public static final SEQUENCE_COLUMN:I = 0x1

.field public static final SOURCE_INJECTED_FROM_IMS:I = 0x1

.field public static final SOURCE_INJECTED_FROM_UNKNOWN:I = 0x2

.field public static final SOURCE_NOT_INJECTED:I = 0x0

.field public static final SUBID_COLUMN:I = 0xb

.field protected static final VDBG:Z = false

.field private static final WAKELOCK_TIMEOUT:I = 0xbb8

.field public static final sRawUri:Landroid/net/Uri;

.field public static final sRawUriPermanentDelete:Landroid/net/Uri;

.field public static sTimeoutDurationMillis:I
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field


# instance fields
.field protected final DELETE_PERMANENTLY:I

.field protected final MARK_DELETED:I

.field private mCarrierServiceLocalLog:Lcom/android/internal/telephony/LocalLog;

.field protected mCellBroadcastServiceManager:Lcom/android/internal/telephony/CellBroadcastServiceManager;

.field protected final mContext:Landroid/content/Context;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mDefaultState:Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;

.field protected mDeliveringState:Lcom/android/internal/telephony/InboundSmsHandler$DeliveringState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mIdleState:Lcom/android/internal/telephony/InboundSmsHandler$IdleState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field protected mMetrics:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

.field protected mPhone:Lcom/android/internal/telephony/Phone;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field mPowerWhitelistManager:Landroid/os/PowerWhitelistManager;

.field protected final mResolver:Landroid/content/ContentResolver;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mSmsFilters:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;",
            ">;"
        }
    .end annotation
.end field

.field private final mSmsReceiveDisabled:Z

.field protected mStartupState:Lcom/android/internal/telephony/InboundSmsHandler$StartupState;

.field public mStorageMonitor:Lcom/android/internal/telephony/SmsStorageMonitor;

.field protected mUserManager:Landroid/os/UserManager;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mWaitingState:Lcom/android/internal/telephony/InboundSmsHandler$WaitingState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mWakeLock:Landroid/os/PowerManager$WakeLock;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mWakeLockTimeout:I

.field protected final mWapPush:Lcom/android/internal/telephony/WapPushOverSms;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$N05ImwMSSGeMVf_UvqK62v1wmKE(Lcom/android/internal/telephony/InboundSmsHandler;[[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/android/internal/telephony/InboundSmsHandler;->lambda$createDefaultSmsFilters$2([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$WgmWzLCVdNf-5GdqDc4guXx8GkI(Lcom/android/internal/telephony/InboundSmsHandler;[[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/android/internal/telephony/InboundSmsHandler;->lambda$createDefaultSmsFilters$0([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$Xkpih0PZnjMQClliKuUqZcINRcE(Lcom/android/internal/telephony/InboundSmsHandler;[[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/android/internal/telephony/InboundSmsHandler;->lambda$createDefaultSmsFilters$1([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmWakeLock(Lcom/android/internal/telephony/InboundSmsHandler;)Landroid/os/PowerManager$WakeLock;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mdropFilteredSms(Lcom/android/internal/telephony/InboundSmsHandler;Lcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Z)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/InboundSmsHandler;->dropFilteredSms(Lcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleInjectSms(Lcom/android/internal/telephony/InboundSmsHandler;Landroid/os/AsyncResult;Z)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->handleInjectSms(Landroid/os/AsyncResult;Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleNewSms(Lcom/android/internal/telephony/InboundSmsHandler;Landroid/os/AsyncResult;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->handleNewSms(Landroid/os/AsyncResult;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$misSkipNotifyFlagSet(Lcom/android/internal/telephony/InboundSmsHandler;I)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->isSkipNotifyFlagSet(I)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$msetWakeLockTimeout(Lcom/android/internal/telephony/InboundSmsHandler;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->setWakeLockTimeout(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mshowNewMessageNotification(Lcom/android/internal/telephony/InboundSmsHandler;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->showNewMessageNotification()V

    return-void
.end method

.method static bridge synthetic -$$Nest$sfgetACTION_OPEN_SMS_APP()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcom/android/internal/telephony/InboundSmsHandler;->ACTION_OPEN_SMS_APP:Ljava/lang/String;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$smfilterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 0

    invoke-static/range {p0 .. p6}, Lcom/android/internal/telephony/InboundSmsHandler;->filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z

    move-result p0

    return p0
.end method

.method static constructor <clinit>()V
    .locals 5

    const-string v0, "pdu"

    const-string v1, "deleted"

    .line 122
    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_DELETED_FLAG_PROJECTION:[Ljava/lang/String;

    .line 129
    new-instance v1, Lcom/android/internal/telephony/InboundSmsHandler$1;

    invoke-direct {v1}, Lcom/android/internal/telephony/InboundSmsHandler$1;-><init>()V

    sput-object v1, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_DELETED_FLAG_PROJECTION_INDEX_MAPPING:Ljava/util/Map;

    const-string v1, "sequence"

    const-string v2, "destination_port"

    const-string v3, "display_originating_addr"

    const-string v4, "date"

    .line 138
    filled-new-array {v0, v1, v2, v3, v4}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_SEQUENCE_PORT_PROJECTION:[Ljava/lang/String;

    .line 150
    new-instance v0, Lcom/android/internal/telephony/InboundSmsHandler$2;

    invoke-direct {v0}, Lcom/android/internal/telephony/InboundSmsHandler$2;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_SEQUENCE_PORT_PROJECTION_INDEX_MAPPING:Ljava/util/Map;

    .line 236
    sget-object v0, Landroid/provider/Telephony$Sms;->CONTENT_URI:Landroid/net/Uri;

    const-string v1, "raw"

    invoke-static {v0, v1}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/InboundSmsHandler;->sRawUri:Landroid/net/Uri;

    .line 237
    sget-object v0, Landroid/provider/Telephony$Sms;->CONTENT_URI:Landroid/net/Uri;

    const-string v1, "raw/permanentDelete"

    .line 238
    invoke-static {v0, v1}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/InboundSmsHandler;->sRawUriPermanentDelete:Landroid/net/Uri;

    const-string v0, "com.android.internal.telephony.OPEN_DEFAULT_SMS_APP"

    .line 315
    sput-object v0, Lcom/android/internal/telephony/InboundSmsHandler;->ACTION_OPEN_SMS_APP:Ljava/lang/String;

    const v0, 0x927c0

    .line 1762
    sput v0, Lcom/android/internal/telephony/InboundSmsHandler;->sTimeoutDurationMillis:I

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;Landroid/content/Context;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/Phone;)V
    .locals 3

    .line 331
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine;-><init>(Ljava/lang/String;)V

    .line 265
    new-instance v0, Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDefaultState:Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;

    .line 268
    new-instance v0, Lcom/android/internal/telephony/InboundSmsHandler$StartupState;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/InboundSmsHandler$StartupState;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mStartupState:Lcom/android/internal/telephony/InboundSmsHandler$StartupState;

    .line 271
    new-instance v0, Lcom/android/internal/telephony/InboundSmsHandler$IdleState;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/InboundSmsHandler$IdleState;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mIdleState:Lcom/android/internal/telephony/InboundSmsHandler$IdleState;

    .line 275
    new-instance v0, Lcom/android/internal/telephony/InboundSmsHandler$DeliveringState;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/InboundSmsHandler$DeliveringState;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDeliveringState:Lcom/android/internal/telephony/InboundSmsHandler$DeliveringState;

    .line 279
    new-instance v0, Lcom/android/internal/telephony/InboundSmsHandler$WaitingState;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/InboundSmsHandler$WaitingState;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWaitingState:Lcom/android/internal/telephony/InboundSmsHandler$WaitingState;

    .line 299
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mMetrics:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    .line 301
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x40

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 302
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x8

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mCarrierServiceLocalLog:Lcom/android/internal/telephony/LocalLog;

    const/4 v0, 0x1

    .line 311
    iput v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->DELETE_PERMANENTLY:I

    const/4 v1, 0x2

    .line 313
    iput v1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->MARK_DELETED:I

    .line 333
    iput-object p2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    .line 334
    iput-object p3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mStorageMonitor:Lcom/android/internal/telephony/SmsStorageMonitor;

    .line 335
    iput-object p4, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 336
    invoke-virtual {p2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p3

    iput-object p3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mResolver:Landroid/content/ContentResolver;

    .line 340
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p3

    const-class v1, Lcom/android/internal/telephony/TelephonyComponentFactory;

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p3, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p3

    .line 341
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeWapPushOverSms(Landroid/content/Context;)Lcom/android/internal/telephony/WapPushOverSms;

    move-result-object p3

    iput-object p3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWapPush:Lcom/android/internal/telephony/WapPushOverSms;

    .line 344
    invoke-virtual {p2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p3

    const v1, 0x11101b5

    invoke-virtual {p3, v1}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p3

    .line 346
    invoke-static {p2}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 347
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    .line 346
    invoke-virtual {v1, v2, p3}, Landroid/telephony/TelephonyManager;->getSmsReceiveCapableForPhone(IZ)Z

    move-result p3

    xor-int/2addr p3, v0

    iput-boolean p3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mSmsReceiveDisabled:Z

    const-string p3, "power"

    .line 349
    invoke-virtual {p2, p3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Landroid/os/PowerManager;

    .line 350
    invoke-virtual {p3, v0, p1}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    .line 351
    invoke-virtual {p1}, Landroid/os/PowerManager$WakeLock;->acquire()V

    const-string/jumbo p1, "user"

    .line 352
    invoke-virtual {p2, p1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/os/UserManager;

    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mUserManager:Landroid/os/UserManager;

    const-string p1, "power_whitelist"

    .line 354
    invoke-virtual {p2, p1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/os/PowerWhitelistManager;

    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPowerWhitelistManager:Landroid/os/PowerWhitelistManager;

    .line 355
    new-instance p1, Lcom/android/internal/telephony/CellBroadcastServiceManager;

    invoke-direct {p1, p2, p4}, Lcom/android/internal/telephony/CellBroadcastServiceManager;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/Phone;)V

    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mCellBroadcastServiceManager:Lcom/android/internal/telephony/CellBroadcastServiceManager;

    .line 357
    invoke-direct {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->createDefaultSmsFilters()Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mSmsFilters:Ljava/util/List;

    .line 361
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->onCheckIfOverrideStates()Z

    move-result p1

    if-nez p1, :cond_0

    .line 363
    iget-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDefaultState:Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;)V

    .line 364
    iget-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mStartupState:Lcom/android/internal/telephony/InboundSmsHandler$StartupState;

    iget-object p2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDefaultState:Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 365
    iget-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mIdleState:Lcom/android/internal/telephony/InboundSmsHandler$IdleState;

    iget-object p2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDefaultState:Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 366
    iget-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDeliveringState:Lcom/android/internal/telephony/InboundSmsHandler$DeliveringState;

    iget-object p2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDefaultState:Lcom/android/internal/telephony/InboundSmsHandler$DefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 367
    iget-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWaitingState:Lcom/android/internal/telephony/InboundSmsHandler$WaitingState;

    iget-object p2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mDeliveringState:Lcom/android/internal/telephony/InboundSmsHandler$DeliveringState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 368
    iget-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mStartupState:Lcom/android/internal/telephony/InboundSmsHandler$StartupState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->setInitialState(Lcom/android/internal/telephony/State;)V

    :cond_0
    const-string p1, "created InboundSmsHandler"

    .line 373
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$000(Lcom/android/internal/telephony/InboundSmsHandler;Ljava/lang/String;)V
    .locals 0

    .line 115
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->logd(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$100(Lcom/android/internal/telephony/InboundSmsHandler;I)V
    .locals 0

    .line 115
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    return-void
.end method

.method static synthetic access$200(Lcom/android/internal/telephony/InboundSmsHandler;I)V
    .locals 0

    .line 115
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    return-void
.end method

.method static synthetic access$300(Lcom/android/internal/telephony/InboundSmsHandler;Ljava/lang/String;)V
    .locals 0

    .line 115
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->logd(Ljava/lang/String;)V

    return-void
.end method

.method private static buildMessageBodyFromPdus([Landroid/telephony/SmsMessage;)Ljava/lang/String;
    .locals 4

    .line 2106
    array-length v0, p0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    .line 2108
    aget-object p0, p0, v1

    invoke-virtual {p0}, Landroid/telephony/SmsMessage;->getDisplayMessageBody()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->replaceFormFeeds(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 2111
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 2112
    array-length v2, p0

    :goto_0
    if-ge v1, v2, :cond_1

    aget-object v3, p0, v1

    .line 2114
    invoke-virtual {v3}, Landroid/telephony/SmsMessage;->getDisplayMessageBody()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 2116
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->replaceFormFeeds(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static cancelNewMessageNotification(Landroid/content/Context;)V
    .locals 2

    const-string v0, "notification"

    .line 1280
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/NotificationManager;

    const-string v0, "InboundSmsHandler"

    const/4 v1, 0x1

    .line 1281
    invoke-virtual {p0, v0, v1}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    return-void
.end method

.method private checkAndHandleDuplicate(Lcom/android/internal/telephony/InboundSmsTracker;)Z
    .locals 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/database/SQLException;
        }
    .end annotation

    .line 1602
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getExactMatchDupDetectQuery()Landroid/util/Pair;

    move-result-object v0

    const/4 v1, 0x0

    .line 1607
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mResolver:Landroid/content/ContentResolver;

    sget-object v8, Lcom/android/internal/telephony/InboundSmsHandler;->sRawUri:Landroid/net/Uri;

    sget-object v9, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_DELETED_FLAG_PROJECTION:[Ljava/lang/String;

    iget-object v3, v0, Landroid/util/Pair;->first:Ljava/lang/Object;

    move-object v5, v3

    check-cast v5, Ljava/lang/String;

    iget-object v3, v0, Landroid/util/Pair;->second:Ljava/lang/Object;

    move-object v6, v3

    check-cast v6, [Ljava/lang/String;

    const/4 v7, 0x0

    move-object v3, v8

    move-object v4, v9

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    const-string v10, " rows"

    const/4 v11, 0x1

    if-eqz v2, :cond_2

    .line 1611
    :try_start_1
    invoke-interface {v2}, Landroid/database/Cursor;->moveToNext()Z

    move-result v3

    if-eqz v3, :cond_2

    .line 1612
    invoke-interface {v2}, Landroid/database/Cursor;->getCount()I

    move-result v3

    if-eq v3, v11, :cond_0

    .line 1613
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "checkAndHandleDuplicate: Exact match query returned "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1614
    invoke-interface {v2}, Landroid/database/Cursor;->getCount()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v4

    .line 1613
    invoke-virtual {p0, v3, v4, v5}, Lcom/android/internal/telephony/InboundSmsHandler;->logeWithLocalLog(Ljava/lang/String;J)V

    .line 1619
    :cond_0
    sget-object v3, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_DELETED_FLAG_PROJECTION_INDEX_MAPPING:Ljava/util/Map;

    const/16 v4, 0xa

    .line 1620
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v3, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    .line 1619
    invoke-interface {v2, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    if-ne v3, v11, :cond_1

    .line 1621
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "checkAndHandleDuplicate: Discarding duplicate message/segment: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/InboundSmsHandler;->logWithLocalLog(Ljava/lang/String;)V

    .line 1623
    invoke-direct {p0, v2, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->logDupPduMismatch(Landroid/database/Cursor;Lcom/android/internal/telephony/InboundSmsTracker;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1641
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    return v11

    .line 1629
    :cond_1
    :try_start_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v3

    if-ne v3, v11, :cond_2

    .line 1631
    iget-object v3, v0, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v3, Ljava/lang/String;

    iget-object v0, v0, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v0, [Ljava/lang/String;

    invoke-virtual {p0, v3, v0, v11}, Lcom/android/internal/telephony/InboundSmsHandler;->deleteFromRawTable(Ljava/lang/String;[Ljava/lang/String;I)V

    .line 1633
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "checkAndHandleDuplicate: Replacing duplicate message: "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/InboundSmsHandler;->logWithLocalLog(Ljava/lang/String;)V

    .line 1635
    invoke-direct {p0, v2, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->logDupPduMismatch(Landroid/database/Cursor;Lcom/android/internal/telephony/InboundSmsTracker;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p0

    move-object v1, v2

    goto/16 :goto_2

    :cond_2
    :goto_0
    if-eqz v2, :cond_3

    .line 1641
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 1648
    :cond_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v0

    if-le v0, v11, :cond_7

    .line 1649
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getInexactMatchDupDetectQuery()Landroid/util/Pair;

    move-result-object v0

    .line 1653
    :try_start_3
    iget-object v3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mResolver:Landroid/content/ContentResolver;

    iget-object v2, v0, Landroid/util/Pair;->first:Ljava/lang/Object;

    move-object v6, v2

    check-cast v6, Ljava/lang/String;

    iget-object v2, v0, Landroid/util/Pair;->second:Ljava/lang/Object;

    move-object v7, v2

    check-cast v7, [Ljava/lang/String;

    const/4 v2, 0x0

    move-object v4, v8

    move-object v5, v9

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    if-eqz v1, :cond_5

    .line 1657
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v2

    if-eqz v2, :cond_5

    .line 1658
    invoke-interface {v1}, Landroid/database/Cursor;->getCount()I

    move-result v2

    if-eq v2, v11, :cond_4

    .line 1659
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "checkAndHandleDuplicate: Inexact match query returned "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1660
    invoke-interface {v1}, Landroid/database/Cursor;->getCount()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v3

    .line 1659
    invoke-virtual {p0, v2, v3, v4}, Lcom/android/internal/telephony/InboundSmsHandler;->logeWithLocalLog(Ljava/lang/String;J)V

    .line 1663
    :cond_4
    iget-object v2, v0, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v2, Ljava/lang/String;

    iget-object v0, v0, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v0, [Ljava/lang/String;

    invoke-virtual {p0, v2, v0, v11}, Lcom/android/internal/telephony/InboundSmsHandler;->deleteFromRawTable(Ljava/lang/String;[Ljava/lang/String;I)V

    .line 1665
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "checkAndHandleDuplicate: Replacing duplicate message segment: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/InboundSmsHandler;->logWithLocalLog(Ljava/lang/String;)V

    .line 1667
    invoke-direct {p0, v1, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->logDupPduMismatch(Landroid/database/Cursor;Lcom/android/internal/telephony/InboundSmsTracker;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    :cond_5
    if-eqz v1, :cond_7

    .line 1671
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    goto :goto_1

    :catchall_1
    move-exception p0

    if-eqz v1, :cond_6

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 1673
    :cond_6
    throw p0

    :cond_7
    :goto_1
    const/4 p0, 0x0

    return p0

    :catchall_2
    move-exception p0

    :goto_2
    if-eqz v1, :cond_8

    .line 1641
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 1643
    :cond_8
    throw p0
.end method

.method private createDefaultSmsFilters()Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;",
            ">;"
        }
    .end annotation

    .line 1295
    new-instance v0, Ljava/util/ArrayList;

    const/4 v1, 0x3

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 1296
    new-instance v1, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1316
    new-instance v1, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1327
    new-instance v1, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object v0
.end method

.method private dispatchMessage(Lcom/android/internal/telephony/SmsMessageBase;I)I
    .locals 3

    if-nez p1, :cond_0

    const-string p1, "dispatchSmsMessage: message is null"

    .line 797
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;)V

    const/16 p0, 0x8

    return p0

    .line 801
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mSmsReceiveDisabled:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_1

    const-string p1, "Received short message on device which doesn\'t support receiving SMS. Ignored."

    .line 803
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    return v1

    :cond_1
    const/4 v0, 0x0

    :try_start_0
    const-string v2, "package"

    .line 811
    invoke-static {v2}, Landroid/os/ServiceManager;->getService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v2

    invoke-static {v2}, Landroid/content/pm/IPackageManager$Stub;->asInterface(Landroid/os/IBinder;)Landroid/content/pm/IPackageManager;

    move-result-object v2

    .line 812
    invoke-interface {v2}, Landroid/content/pm/IPackageManager;->isOnlyCoreApps()Z

    move-result v0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    if-eqz v0, :cond_2

    const-string p1, "Received a short message in encrypted state. Rejecting."

    .line 817
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    const/16 p0, 0x9

    return p0

    .line 821
    :cond_2
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->dispatchMessageRadioSpecific(Lcom/android/internal/telephony/SmsMessageBase;I)I

    move-result p1

    if-eq p1, v1, :cond_3

    const/4 v0, -0x1

    if-eq p1, v0, :cond_3

    .line 826
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mMetrics:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->is3gpp2()Z

    move-result v2

    invoke-virtual {v0, v1, v2, p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSmsError(IZII)V

    .line 827
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSmsStats()Lcom/android/internal/telephony/metrics/SmsStats;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->is3gpp2()Z

    move-result p0

    invoke-virtual {v0, p0, p2, p1}, Lcom/android/internal/telephony/metrics/SmsStats;->onIncomingSmsError(ZII)V

    :cond_3
    return p1
.end method

.method private dropFilteredSms(Lcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Z)V
    .locals 0

    if-eqz p3, :cond_0

    .line 1347
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDeleteWhere()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDeleteWhereArgs()[Ljava/lang/String;

    move-result-object p1

    const/4 p3, 0x1

    .line 1346
    invoke-virtual {p0, p2, p1, p3}, Lcom/android/internal/telephony/InboundSmsHandler;->deleteFromRawTable(Ljava/lang/String;[Ljava/lang/String;I)V

    const/4 p1, 0x3

    .line 1349
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    goto :goto_0

    .line 1351
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->dropSms(Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;)V

    :goto_0
    return-void
.end method

.method private dropSms(Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;)V
    .locals 2

    .line 2000
    invoke-static {p1}, Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;->-$$Nest$fgetmDeleteWhere(Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;)Ljava/lang/String;

    move-result-object v0

    invoke-static {p1}, Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;->-$$Nest$fgetmDeleteWhereArgs(Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;)[Ljava/lang/String;

    move-result-object p1

    const/4 v1, 0x2

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->deleteFromRawTable(Ljava/lang/String;[Ljava/lang/String;I)V

    const/4 p1, 0x3

    .line 2001
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    return-void
.end method

.method private static filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([[BI",
            "Lcom/android/internal/telephony/InboundSmsTracker;",
            "Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;",
            "ZZ",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;",
            ">;)Z"
        }
    .end annotation

    .line 1375
    invoke-interface/range {p6 .. p6}, Ljava/util/List;->listIterator()Ljava/util/ListIterator;

    move-result-object v0

    .line 1376
    :cond_0
    invoke-interface {v0}, Ljava/util/ListIterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 1377
    invoke-interface {v0}, Ljava/util/ListIterator;->next()Ljava/lang/Object;

    move-result-object v1

    move-object v2, v1

    check-cast v2, Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;

    .line 1379
    invoke-interface {v0}, Ljava/util/ListIterator;->nextIndex()I

    move-result v1

    invoke-interface/range {p6 .. p6}, Ljava/util/List;->size()I

    move-result v3

    move-object/from16 v10, p6

    invoke-interface {v10, v1, v3}, Ljava/util/List;->subList(II)Ljava/util/List;

    move-result-object v9

    move-object v3, p0

    move v4, p1

    move-object v5, p2

    move-object v6, p3

    move v7, p4

    move/from16 v8, p5

    .line 1378
    invoke-interface/range {v2 .. v9}, Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;->filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method private handleInjectSms(Landroid/os/AsyncResult;Z)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/4 v0, 0x0

    .line 765
    :try_start_0
    iget-object v1, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v1, Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_1

    .line 766
    :try_start_1
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/SmsMessage;

    if-nez p1, :cond_0

    const-string p1, "Null injected sms"

    .line 768
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;)V

    const/4 p0, 0x7

    goto :goto_2

    :cond_0
    if-eqz p2, :cond_1

    const/4 p2, 0x1

    goto :goto_0

    :cond_1
    const/4 p2, 0x2

    .line 773
    :goto_0
    iget-object p1, p1, Landroid/telephony/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->dispatchMessage(Lcom/android/internal/telephony/SmsMessageBase;I)I

    move-result p0
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_2

    :catch_0
    move-exception p1

    move-object v0, v1

    goto :goto_1

    :catch_1
    move-exception p1

    :goto_1
    const-string p2, "Exception dispatching message"

    .line 776
    invoke-virtual {p0, p2, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 p0, 0x6

    move-object v1, v0

    :goto_2
    if-eqz v1, :cond_2

    .line 781
    invoke-interface {v1, p0}, Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;->onSmsInjectedResult(I)V

    :cond_2
    return-void
.end method

.method private handleNewSms(Landroid/os/AsyncResult;)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 734
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_0

    .line 735
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Exception processing incoming SMS: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 741
    :try_start_0
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/SmsMessage;

    .line 742
    iget-object p1, p1, Landroid/telephony/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/InboundSmsHandler;->dispatchMessage(Lcom/android/internal/telephony/SmsMessageBase;I)I

    move-result p1
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v1, "Exception dispatching message"

    .line 744
    invoke-virtual {p0, v1, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 p1, 0x6

    :goto_0
    const/4 v1, -0x1

    if-eq p1, v1, :cond_2

    const/4 v1, 0x1

    if-ne p1, v1, :cond_1

    move v0, v1

    :cond_1
    const/4 v1, 0x0

    .line 752
    invoke-direct {p0, v0, p1, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->notifyAndAcknowledgeLastIncomingSms(ZILandroid/os/Message;)V

    :cond_2
    return-void
.end method

.method private hasUserRestriction(Ljava/lang/String;Landroid/os/UserHandle;)Z
    .locals 0

    .line 1483
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mUserManager:Landroid/os/UserManager;

    .line 1484
    invoke-virtual {p0, p1, p2}, Landroid/os/UserManager;->getUserRestrictionSources(Ljava/lang/String;Landroid/os/UserHandle;)Ljava/util/List;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 1485
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private hexToByte(Ljava/lang/String;)B
    .locals 2

    const/4 v0, 0x0

    .line 2207
    invoke-virtual {p1, v0}, Ljava/lang/String;->charAt(I)C

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/InboundSmsHandler;->toDigit(C)I

    move-result v0

    const/4 v1, 0x1

    .line 2208
    invoke-virtual {p1, v1}, Ljava/lang/String;->charAt(I)C

    move-result p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->toDigit(C)I

    move-result p0

    shl-int/lit8 p1, v0, 0x4

    add-int/2addr p1, p0

    int-to-byte p0, p1

    return p0
.end method

.method public static isCurrentFormat3gpp2()Z
    .locals 2

    .line 1757
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCurrentPhoneType()I

    move-result v0

    const/4 v1, 0x2

    if-ne v1, v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private isSkipNotifyFlagSet(I)Z
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    and-int/lit8 p0, p1, 0x2

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$createDefaultSmsFilters$0([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 16

    move-object/from16 v14, p0

    .line 1299
    new-instance v15, Lcom/android/internal/telephony/InboundSmsHandler$CarrierServicesSmsFilterCallback;

    .line 1301
    invoke-virtual/range {p3 .. p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getFormat()Ljava/lang/String;

    move-result-object v5

    .line 1303
    invoke-virtual/range {p3 .. p3}, Lcom/android/internal/telephony/InboundSmsTracker;->isClass0()Z

    move-result v8

    invoke-virtual/range {p3 .. p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getSubId()I

    move-result v9

    invoke-virtual/range {p3 .. p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v10

    move-object v0, v15

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move/from16 v3, p2

    move-object/from16 v4, p3

    move-object/from16 v6, p4

    move/from16 v7, p5

    move/from16 v12, p6

    move-object/from16 v13, p7

    invoke-direct/range {v0 .. v13}, Lcom/android/internal/telephony/InboundSmsHandler$CarrierServicesSmsFilterCallback;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;[[BILcom/android/internal/telephony/InboundSmsTracker;Ljava/lang/String;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZIJZLjava/util/List;)V

    .line 1305
    new-instance v11, Lcom/android/internal/telephony/CarrierServicesSmsFilter;

    iget-object v1, v14, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    iget-object v2, v14, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1306
    invoke-virtual/range {p3 .. p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getFormat()Ljava/lang/String;

    move-result-object v5

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1307
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "::CarrierServicesSmsFilter"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    iget-object v8, v14, Lcom/android/internal/telephony/InboundSmsHandler;->mCarrierServiceLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 1308
    invoke-virtual/range {p3 .. p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v9

    move-object v0, v11

    move-object/from16 v3, p1

    move/from16 v4, p2

    move-object v6, v15

    invoke-direct/range {v0 .. v10}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/Phone;[[BILjava/lang/String;Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierServicesSmsFilterCallbackInterface;Ljava/lang/String;Lcom/android/internal/telephony/LocalLog;J)V

    .line 1309
    invoke-virtual {v11}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;->filter()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1310
    invoke-virtual/range {p3 .. p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v0

    const-string v2, "SMS is being handled by carrier service"

    invoke-virtual {v14, v2, v0, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V

    const/4 v0, 0x1

    return v0

    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method private synthetic lambda$createDefaultSmsFilters$1([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 1

    .line 1319
    iget-object p5, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    .line 1320
    invoke-virtual {p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getFormat()Ljava/lang/String;

    move-result-object p7

    invoke-virtual {p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getSubId()I

    move-result v0

    .line 1319
    invoke-static {p5, p1, p7, p2, v0}, Lcom/android/internal/telephony/VisualVoicemailSmsFilter;->filter(Landroid/content/Context;[[BLjava/lang/String;II)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 1321
    invoke-virtual {p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide p1

    const-string p5, "Visual voicemail SMS dropped"

    invoke-virtual {p0, p5, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->logWithLocalLog(Ljava/lang/String;J)V

    .line 1322
    invoke-direct {p0, p3, p4, p6}, Lcom/android/internal/telephony/InboundSmsHandler;->dropFilteredSms(Lcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Z)V

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private synthetic lambda$createDefaultSmsFilters$2([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 0

    .line 1330
    new-instance p2, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;

    iget-object p5, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {p2, p5}, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;-><init>(Lcom/android/internal/telephony/Phone;)V

    .line 1332
    invoke-virtual {p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getFormat()Ljava/lang/String;

    move-result-object p5

    invoke-virtual {p2, p1, p5}, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->filter([[BLjava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 1334
    invoke-virtual {p3}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide p1

    const-string p5, "Missed incoming call SMS received"

    .line 1333
    invoke-virtual {p0, p5, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->logWithLocalLog(Ljava/lang/String;J)V

    .line 1335
    invoke-direct {p0, p3, p4, p6}, Lcom/android/internal/telephony/InboundSmsHandler;->dropFilteredSms(Lcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Z)V

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private logDupPduMismatch(Landroid/database/Cursor;Lcom/android/internal/telephony/InboundSmsTracker;)V
    .locals 3

    .line 1680
    sget-object v0, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_DELETED_FLAG_PROJECTION_INDEX_MAPPING:Ljava/util/Map;

    const/4 v1, 0x0

    .line 1681
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 1680
    invoke-interface {p1, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p1

    .line 1682
    invoke-virtual {p2}, Lcom/android/internal/telephony/InboundSmsTracker;->getPdu()[B

    move-result-object v0

    .line 1683
    invoke-static {p1}, Lcom/android/internal/telephony/HexDump;->hexStringToByteArray(Ljava/lang/String;)[B

    move-result-object p1

    .line 1684
    invoke-virtual {p2}, Lcom/android/internal/telephony/InboundSmsTracker;->getPdu()[B

    move-result-object v1

    invoke-static {p1, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v1

    if-nez v1, :cond_0

    .line 1685
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Warning: dup message PDU of length "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v0, v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " is different from existing PDU of length "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length p1, p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1687
    invoke-virtual {p2}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v0

    .line 1685
    invoke-virtual {p0, p1, v0, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->logeWithLocalLog(Ljava/lang/String;J)V

    :cond_0
    return-void
.end method

.method private notifyAndAcknowledgeLastIncomingSms(ZILandroid/os/Message;)V
    .locals 3

    if-nez p1, :cond_0

    .line 866
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.provider.Telephony.SMS_REJECTED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "result"

    .line 867
    invoke-virtual {v0, v1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 868
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    const-string/jumbo v2, "subId"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 869
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    const-string v2, "android.permission.RECEIVE_SMS"

    invoke-virtual {v1, v0, v2}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;Ljava/lang/String;)V

    .line 871
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/InboundSmsHandler;->acknowledgeLastIncomingSms(ZILandroid/os/Message;)V

    return-void
.end method

.method static registerNewMessageNotificationActionHandler(Landroid/content/Context;)V
    .locals 3

    .line 2226
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 2227
    sget-object v1, Lcom/android/internal/telephony/InboundSmsHandler;->ACTION_OPEN_SMS_APP:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 2228
    new-instance v1, Lcom/android/internal/telephony/InboundSmsHandler$NewMessageNotificationActionReceiver;

    const/4 v2, 0x0

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/InboundSmsHandler$NewMessageNotificationActionReceiver;-><init>(Lcom/android/internal/telephony/InboundSmsHandler$NewMessageNotificationActionReceiver-IA;)V

    const/4 v2, 0x4

    invoke-virtual {p0, v1, v0, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    return-void
.end method

.method private static replaceFormFeeds(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    if-nez p0, :cond_0

    const-string p0, ""

    goto :goto_0

    :cond_0
    const/16 v0, 0xc

    const/16 v1, 0xa

    .line 2142
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method private setWakeLockTimeout(I)V
    .locals 0

    .line 2159
    iput p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWakeLockTimeout:I

    return-void
.end method

.method private showNewMessageNotification()V
    .locals 5
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 1254
    invoke-static {}, Landroid/os/storage/StorageManager;->isFileEncryptedNativeOrEmulated()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    const-string v0, "Show new message notification."

    .line 1257
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    .line 1258
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    const/4 v1, 0x0

    new-instance v2, Landroid/content/Intent;

    sget-object v3, Lcom/android/internal/telephony/InboundSmsHandler;->ACTION_OPEN_SMS_APP:Ljava/lang/String;

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const/high16 v3, 0x44000000    # 512.0f

    invoke-static {v0, v1, v2, v3}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    .line 1263
    new-instance v1, Landroid/app/Notification$Builder;

    iget-object v2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    invoke-direct {v1, v2}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;)V

    const v2, 0x108008e

    .line 1264
    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v1

    const/4 v2, 0x1

    .line 1265
    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setAutoCancel(Z)Landroid/app/Notification$Builder;

    move-result-object v1

    .line 1266
    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setVisibility(I)Landroid/app/Notification$Builder;

    move-result-object v1

    const/4 v3, -0x1

    .line 1267
    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setDefaults(I)Landroid/app/Notification$Builder;

    move-result-object v1

    iget-object v3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    const v4, 0x10405e5

    .line 1268
    invoke-virtual {v3, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v1

    iget-object v3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    const v4, 0x10405e4

    .line 1269
    invoke-virtual {v3, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v1

    .line 1270
    invoke-virtual {v1, v0}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    move-result-object v0

    const-string/jumbo v1, "sms"

    .line 1271
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setChannelId(Ljava/lang/String;)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 1272
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    const-string v1, "notification"

    .line 1273
    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/NotificationManager;

    .line 1275
    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    const-string v1, "InboundSmsHandler"

    .line 1274
    invoke-virtual {p0, v1, v2, v0}, Landroid/app/NotificationManager;->notify(Ljava/lang/String;ILandroid/app/Notification;)V

    return-void
.end method

.method private toDigit(C)I
    .locals 0

    const/16 p0, 0x10

    .line 2213
    invoke-static {p1, p0}, Ljava/lang/Character;->digit(CI)I

    move-result p0

    const/4 p1, -0x1

    if-ne p0, p1, :cond_0

    const/4 p0, 0x0

    :cond_0
    return p0
.end method


# virtual methods
.method protected abstract acknowledgeLastIncomingSms(ZILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method protected addTrackerToRawTable(Lcom/android/internal/telephony/InboundSmsTracker;Z)I
    .locals 8

    if-eqz p2, :cond_0

    .line 1707
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->checkAndHandleDuplicate(Lcom/android/internal/telephony/InboundSmsTracker;)Z

    move-result p2
    :try_end_0
    .catch Landroid/database/SQLException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz p2, :cond_1

    const/4 p0, 0x5

    return p0

    :catch_0
    move-exception p2

    .line 1711
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "addTrackerToRawTable: Can\'t access SMS database, "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1712
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v1

    invoke-static {v1, v2}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1711
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/16 p0, 0xa

    return p0

    .line 1716
    :cond_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v0

    const-string p2, "addTrackerToRawTable: Skipped message de-duping logic"

    invoke-virtual {p0, p2, v0, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V

    .line 1719
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getAddress()Ljava/lang/String;

    move-result-object p2

    .line 1720
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getReferenceNumber()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v0

    .line 1721
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    .line 1722
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getContentValues()Landroid/content/ContentValues;

    move-result-object v2

    .line 1728
    iget-object v3, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mResolver:Landroid/content/ContentResolver;

    sget-object v4, Lcom/android/internal/telephony/InboundSmsHandler;->sRawUri:Landroid/net/Uri;

    invoke-virtual {v3, v4, v2}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    move-result-object v2

    .line 1729
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "addTrackerToRawTable: URI of new row: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v4

    invoke-virtual {p0, v3, v4, v5}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V

    .line 1732
    :try_start_1
    invoke-static {v2}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v3

    .line 1733
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v5

    const/4 v6, 0x0

    const/4 v7, 0x1

    if-ne v5, v7, :cond_2

    const-string p2, "_id=?"

    new-array v0, v7, [Ljava/lang/String;

    .line 1735
    invoke-static {v3, v4}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v0, v6

    invoke-virtual {p1, p2, v0}, Lcom/android/internal/telephony/InboundSmsTracker;->setDeleteWhere(Ljava/lang/String;[Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    const/4 v3, 0x3

    new-array v3, v3, [Ljava/lang/String;

    aput-object p2, v3, v6

    aput-object v0, v3, v7

    const/4 p2, 0x2

    aput-object v1, v3, p2

    .line 1739
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getQueryForSegments()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2, v3}, Lcom/android/internal/telephony/InboundSmsTracker;->setDeleteWhere(Ljava/lang/String;[Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :goto_0
    return v7

    :catch_1
    move-exception p2

    .line 1743
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "addTrackerToRawTable: error parsing URI for new row: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1744
    invoke-virtual {p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v1

    invoke-static {v1, v2}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1743
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/16 p0, 0xb

    return p0
.end method

.method protected addTrackerToRawTableAndSendMessage(Lcom/android/internal/telephony/InboundSmsTracker;Z)I
    .locals 1

    .line 948
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/InboundSmsHandler;->addTrackerToRawTable(Lcom/android/internal/telephony/InboundSmsTracker;Z)I

    move-result p2

    const/4 v0, 0x1

    if-eq p2, v0, :cond_1

    const/4 p0, 0x5

    if-eq p2, p0, :cond_0

    return p2

    :cond_0
    return v0

    :cond_1
    const/4 p2, 0x2

    .line 951
    invoke-virtual {p0, p2, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    return v0
.end method

.method protected decodeHexString(Ljava/lang/String;)[B
    .locals 4

    if-eqz p1, :cond_2

    .line 2196
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    rem-int/lit8 v0, v0, 0x2

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    goto :goto_1

    .line 2199
    :cond_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    div-int/lit8 v0, v0, 0x2

    new-array v0, v0, [B

    const/4 v1, 0x0

    .line 2200
    :goto_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 2201
    div-int/lit8 v2, v1, 0x2

    add-int/lit8 v3, v1, 0x2

    invoke-virtual {p1, v1, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->hexToByte(Ljava/lang/String;)B

    move-result v1

    aput-byte v1, v0, v2

    move v1, v3

    goto :goto_0

    :cond_1
    return-object v0

    :cond_2
    :goto_1
    const/4 p0, 0x0

    return-object p0
.end method

.method protected deleteFromRawTable(Ljava/lang/String;[Ljava/lang/String;I)V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/4 v0, 0x1

    if-ne p3, v0, :cond_0

    .line 1497
    sget-object p3, Lcom/android/internal/telephony/InboundSmsHandler;->sRawUriPermanentDelete:Landroid/net/Uri;

    goto :goto_0

    :cond_0
    sget-object p3, Lcom/android/internal/telephony/InboundSmsHandler;->sRawUri:Landroid/net/Uri;

    .line 1498
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mResolver:Landroid/content/ContentResolver;

    invoke-virtual {v0, p3, p1, p2}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p1

    if-nez p1, :cond_1

    const-string p1, "No rows were deleted from raw table!"

    .line 1500
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;)V

    goto :goto_1

    .line 1502
    :cond_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Deleted "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " rows from raw table."

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    :goto_1
    return-void
.end method

.method public dispatchIntent(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Landroid/os/UserHandle;I)V
    .locals 16
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v11, p1

    move-object/from16 v12, p5

    move-object/from16 v1, p6

    const/high16 v2, 0x8000000

    .line 1398
    invoke-virtual {v11, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 1399
    invoke-virtual/range {p1 .. p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v2

    const-string v3, "android.provider.Telephony.SMS_DELIVER"

    .line 1400
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    const-string v3, "android.provider.Telephony.SMS_RECEIVED"

    .line 1401
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    const-string v3, "android.provider.Telephony.WAP_PUSH_DELIVER"

    .line 1402
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    const-string v3, "android.provider.Telephony.WAP_PUSH_RECEIVED"

    .line 1403
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    :cond_0
    const/high16 v2, 0x10000000

    .line 1410
    invoke-virtual {v11, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 1412
    :cond_1
    iget-object v2, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-static {v11, v2}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    .line 1416
    invoke-static/range {p7 .. p7}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v2

    if-eqz v2, :cond_2

    move/from16 v2, p7

    .line 1417
    invoke-static {v11, v2}, Landroid/telephony/SubscriptionManager;->putSubscriptionIdExtra(Landroid/content/Intent;I)V

    .line 1420
    :cond_2
    sget-object v2, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    invoke-virtual {v1, v2}, Landroid/os/UserHandle;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/4 v13, 0x0

    if-eqz v2, :cond_c

    .line 1423
    iget-object v2, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mUserManager:Landroid/os/UserManager;

    invoke-virtual {v2, v13}, Landroid/os/UserManager;->getUserHandles(Z)Ljava/util/List;

    move-result-object v2

    .line 1424
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 1425
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_3
    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_5

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/os/UserHandle;

    .line 1426
    iget-object v5, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mUserManager:Landroid/os/UserManager;

    invoke-virtual {v5, v4}, Landroid/os/UserManager;->isUserRunning(Landroid/os/UserHandle;)Z

    move-result v5

    if-eqz v5, :cond_4

    .line 1427
    invoke-interface {v3, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 1429
    :cond_4
    sget-object v5, Landroid/os/UserHandle;->SYSTEM:Landroid/os/UserHandle;

    invoke-virtual {v4, v5}, Landroid/os/UserHandle;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 1430
    invoke-static/range {p5 .. p5}, Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;->-$$Nest$fgetmInboundSmsTracker(Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;)Lcom/android/internal/telephony/InboundSmsTracker;

    move-result-object v4

    .line 1431
    invoke-virtual {v4}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v4

    const-string v6, "dispatchIntent: SYSTEM user is not running"

    .line 1430
    invoke-virtual {v0, v6, v4, v5}, Lcom/android/internal/telephony/InboundSmsHandler;->logeWithLocalLog(Ljava/lang/String;J)V

    goto :goto_0

    .line 1435
    :cond_5
    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v2

    const/4 v4, 0x1

    if-eqz v2, :cond_7

    new-array v2, v4, [I

    .line 1436
    invoke-virtual/range {p6 .. p6}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v1

    aput v1, v2, v13

    :cond_6
    move-object v14, v2

    goto :goto_2

    .line 1438
    :cond_7
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v1

    new-array v2, v1, [I

    move v1, v13

    .line 1439
    :goto_1
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v5

    if-ge v1, v5, :cond_6

    .line 1440
    invoke-interface {v3, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/os/UserHandle;

    invoke-virtual {v5}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v5

    aput v5, v2, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 1445
    :goto_2
    array-length v1, v14

    sub-int/2addr v1, v4

    move v15, v1

    :goto_3
    if-ltz v15, :cond_d

    .line 1446
    aget v1, v14, v15

    invoke-static {v1}, Landroid/os/UserHandle;->of(I)Landroid/os/UserHandle;

    move-result-object v1

    .line 1447
    aget v2, v14, v15

    sget-object v3, Landroid/os/UserHandle;->SYSTEM:Landroid/os/UserHandle;

    invoke-virtual {v3}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v3

    if-eq v2, v3, :cond_9

    const-string v2, "no_sms"

    .line 1449
    invoke-direct {v0, v2, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->hasUserRestriction(Ljava/lang/String;Landroid/os/UserHandle;)Z

    move-result v2

    if-eqz v2, :cond_8

    goto :goto_5

    .line 1453
    :cond_8
    iget-object v2, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mUserManager:Landroid/os/UserManager;

    aget v3, v14, v15

    invoke-virtual {v2, v3}, Landroid/os/UserManager;->isManagedProfile(I)Z

    move-result v2

    if-eqz v2, :cond_9

    goto :goto_5

    .line 1459
    :cond_9
    :try_start_0
    aget v2, v14, v15

    sget-object v3, Landroid/os/UserHandle;->SYSTEM:Landroid/os/UserHandle;

    invoke-virtual {v3}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v3

    if-ne v2, v3, :cond_a

    .line 1460
    invoke-virtual {v12, v11}, Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;->setWaitingForIntent(Landroid/content/Intent;)V

    .line 1462
    :cond_a
    iget-object v2, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3, v13, v1}, Landroid/content/Context;->createPackageContextAsUser(Ljava/lang/String;ILandroid/os/UserHandle;)Landroid/content/Context;

    move-result-object v1

    const/4 v3, -0x1

    .line 1464
    aget v2, v14, v15

    sget-object v4, Landroid/os/UserHandle;->SYSTEM:Landroid/os/UserHandle;

    invoke-virtual {v4}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v4

    if-ne v2, v4, :cond_b

    move-object v6, v12

    goto :goto_4

    :cond_b
    const/4 v2, 0x0

    move-object v6, v2

    .line 1465
    :goto_4
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v7

    const/4 v8, 0x0

    const/4 v9, 0x0

    move-object/from16 v2, p1

    move-object/from16 v4, p2

    move-object/from16 v5, p3

    move-object/from16 v10, p4

    .line 1463
    invoke-virtual/range {v1 .. v10}, Landroid/content/Context;->sendOrderedBroadcast(Landroid/content/Intent;ILjava/lang/String;Ljava/lang/String;Landroid/content/BroadcastReceiver;Landroid/os/Handler;Ljava/lang/String;Landroid/os/Bundle;Landroid/os/Bundle;)V
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :goto_5
    add-int/lit8 v15, v15, -0x1

    goto :goto_3

    .line 1472
    :cond_c
    :try_start_1
    invoke-virtual {v12, v11}, Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;->setWaitingForIntent(Landroid/content/Intent;)V

    .line 1473
    iget-object v2, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3, v13, v1}, Landroid/content/Context;->createPackageContextAsUser(Ljava/lang/String;ILandroid/os/UserHandle;)Landroid/content/Context;

    move-result-object v1

    const/4 v2, -0x1

    .line 1475
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v6

    const/4 v7, 0x0

    const/4 v8, 0x0

    move-object v0, v1

    move-object/from16 v1, p1

    move-object/from16 v3, p2

    move-object/from16 v4, p3

    move-object/from16 v5, p5

    move-object/from16 v9, p4

    .line 1474
    invoke-virtual/range {v0 .. v9}, Landroid/content/Context;->sendOrderedBroadcast(Landroid/content/Intent;ILjava/lang/String;Ljava/lang/String;Landroid/content/BroadcastReceiver;Landroid/os/Handler;Ljava/lang/String;Landroid/os/Bundle;Landroid/os/Bundle;)V
    :try_end_1
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    :cond_d
    return-void
.end method

.method protected abstract dispatchMessageRadioSpecific(Lcom/android/internal/telephony/SmsMessageBase;I)I
.end method

.method protected dispatchNormalMessage(Lcom/android/internal/telephony/SmsMessageBase;I)I
    .locals 24
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    move-object/from16 v0, p0

    .line 892
    const-class v1, Lcom/android/internal/telephony/InboundSmsTracker;

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getUserDataHeader()Lcom/android/internal/telephony/SmsHeader;

    move-result-object v2

    const/4 v5, -0x1

    if-eqz v2, :cond_3

    .line 895
    iget-object v6, v2, Lcom/android/internal/telephony/SmsHeader;->concatRef:Lcom/android/internal/telephony/SmsHeader$ConcatRef;

    if-nez v6, :cond_0

    goto :goto_2

    .line 913
    :cond_0
    iget-object v2, v2, Lcom/android/internal/telephony/SmsHeader;->portAddrs:Lcom/android/internal/telephony/SmsHeader$PortAddrs;

    if-eqz v2, :cond_1

    .line 914
    iget v2, v2, Lcom/android/internal/telephony/SmsHeader$PortAddrs;->destPort:I

    move v12, v2

    goto :goto_0

    :cond_1
    move v12, v5

    .line 915
    :goto_0
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 916
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v7

    iget-object v8, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    .line 917
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getPdu()[B

    move-result-object v9

    .line 918
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getTimestampMillis()J

    move-result-wide v10

    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/InboundSmsHandler;->is3gpp2()Z

    move-result v13

    .line 919
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getOriginatingAddress()Ljava/lang/String;

    move-result-object v14

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getDisplayOriginatingAddress()Ljava/lang/String;

    move-result-object v15

    iget v1, v6, Lcom/android/internal/telephony/SmsHeader$ConcatRef;->refNumber:I

    iget v2, v6, Lcom/android/internal/telephony/SmsHeader$ConcatRef;->seqNumber:I

    iget v6, v6, Lcom/android/internal/telephony/SmsHeader$ConcatRef;->msgCount:I

    const/16 v19, 0x0

    .line 921
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getMessageBody()Ljava/lang/String;

    move-result-object v20

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getMessageClass()Lcom/android/internal/telephony/SmsConstants$MessageClass;

    move-result-object v3

    sget-object v4, Lcom/android/internal/telephony/SmsConstants$MessageClass;->CLASS_0:Lcom/android/internal/telephony/SmsConstants$MessageClass;

    if-ne v3, v4, :cond_2

    const/16 v21, 0x1

    goto :goto_1

    :cond_2
    const/16 v21, 0x0

    :goto_1
    iget-object v3, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 922
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v22

    move/from16 v16, v1

    move/from16 v17, v2

    move/from16 v18, v6

    move/from16 v23, p2

    .line 917
    invoke-virtual/range {v7 .. v23}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeInboundSmsTracker(Landroid/content/Context;[BJIZLjava/lang/String;Ljava/lang/String;IIIZLjava/lang/String;ZII)Lcom/android/internal/telephony/InboundSmsTracker;

    move-result-object v1

    goto :goto_5

    :cond_3
    :goto_2
    if-eqz v2, :cond_4

    .line 898
    iget-object v2, v2, Lcom/android/internal/telephony/SmsHeader;->portAddrs:Lcom/android/internal/telephony/SmsHeader$PortAddrs;

    if-eqz v2, :cond_4

    .line 900
    iget v2, v2, Lcom/android/internal/telephony/SmsHeader$PortAddrs;->destPort:I

    .line 901
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "destination port: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    move v11, v2

    goto :goto_3

    :cond_4
    move v11, v5

    .line 903
    :goto_3
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 904
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v6

    iget-object v7, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    .line 905
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getPdu()[B

    move-result-object v8

    .line 906
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getTimestampMillis()J

    move-result-wide v9

    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/InboundSmsHandler;->is3gpp2()Z

    move-result v12

    const/4 v13, 0x0

    .line 907
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getOriginatingAddress()Ljava/lang/String;

    move-result-object v14

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getDisplayOriginatingAddress()Ljava/lang/String;

    move-result-object v15

    .line 908
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getMessageBody()Ljava/lang/String;

    move-result-object v16

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SmsMessageBase;->getMessageClass()Lcom/android/internal/telephony/SmsConstants$MessageClass;

    move-result-object v1

    sget-object v2, Lcom/android/internal/telephony/SmsConstants$MessageClass;->CLASS_0:Lcom/android/internal/telephony/SmsConstants$MessageClass;

    if-ne v1, v2, :cond_5

    const/16 v17, 0x1

    goto :goto_4

    :cond_5
    const/16 v17, 0x0

    :goto_4
    iget-object v1, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 909
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v18

    move/from16 v19, p2

    .line 905
    invoke-virtual/range {v6 .. v19}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeInboundSmsTracker(Landroid/content/Context;[BJIZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZII)Lcom/android/internal/telephony/InboundSmsTracker;

    move-result-object v1

    .line 930
    :goto_5
    invoke-virtual {v1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDestPort()I

    move-result v2

    if-ne v2, v5, :cond_6

    const/4 v3, 0x1

    goto :goto_6

    :cond_6
    const/4 v3, 0x0

    .line 929
    :goto_6
    invoke-virtual {v0, v1, v3}, Lcom/android/internal/telephony/InboundSmsHandler;->addTrackerToRawTableAndSendMessage(Lcom/android/internal/telephony/InboundSmsTracker;Z)I

    move-result v0

    return v0
.end method

.method protected dispatchSmsDeliveryIntent([[BLjava/lang/String;ILcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZIJ)V
    .locals 8

    move-object v0, p0

    move v1, p3

    move-wide v2, p7

    .line 1552
    new-instance v4, Landroid/content/Intent;

    invoke-direct {v4}, Landroid/content/Intent;-><init>()V

    const-string v5, "pdus"

    move-object v6, p1

    .line 1553
    invoke-virtual {v4, v5, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    const-string v5, "format"

    move-object v6, p2

    .line 1554
    invoke-virtual {v4, v5, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-wide/16 v5, 0x0

    cmp-long v5, v2, v5

    if-eqz v5, :cond_0

    const-string v5, "messageId"

    .line 1556
    invoke-virtual {v4, v5, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;J)Landroid/content/Intent;

    :cond_0
    const/4 v5, -0x1

    const/4 v6, 0x0

    if-ne v1, v5, :cond_3

    const-string v1, "android.provider.Telephony.SMS_DELIVER"

    .line 1560
    invoke-virtual {v4, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 1564
    iget-object v1, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    const/4 v5, 0x1

    invoke-static {v1, v5}, Lcom/android/internal/telephony/SmsApplication;->getDefaultSmsApplication(Landroid/content/Context;Z)Landroid/content/ComponentName;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 1567
    invoke-virtual {v4, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 1568
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Delivering SMS to: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1569
    invoke-virtual {v1}, Landroid/content/ComponentName;->getClassName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1568
    invoke-virtual {p0, v1, v2, v3}, Lcom/android/internal/telephony/InboundSmsHandler;->logWithLocalLog(Ljava/lang/String;J)V

    goto :goto_0

    .line 1571
    :cond_1
    invoke-virtual {v4, v6}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 1575
    :goto_0
    iget-object v1, v0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getAppSmsManager()Lcom/android/internal/telephony/AppSmsManager;

    move-result-object v1

    .line 1576
    invoke-virtual {v1, v4}, Lcom/android/internal/telephony/AppSmsManager;->handleSmsReceivedIntent(Landroid/content/Intent;)Z

    move-result v1

    if-eqz v1, :cond_2

    move-object v5, p4

    .line 1578
    invoke-direct {p0, p4}, Lcom/android/internal/telephony/InboundSmsHandler;->dropSms(Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;)V

    return-void

    :cond_2
    move-object v5, p4

    goto :goto_1

    :cond_3
    move-object v5, p4

    const-string v2, "android.intent.action.DATA_SMS_RECEIVED"

    .line 1582
    invoke-virtual {v4, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 1583
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "sms://localhost:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 1584
    invoke-virtual {v4, v1}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    .line 1585
    invoke-virtual {v4, v6}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 1588
    :goto_1
    invoke-virtual {v4}, Landroid/content/Intent;->getComponent()Landroid/content/ComponentName;

    move-result-object v1

    move v2, p5

    invoke-virtual {p0, v1, p5}, Lcom/android/internal/telephony/InboundSmsHandler;->handleSmsWhitelisting(Landroid/content/ComponentName;Z)Landroid/os/Bundle;

    move-result-object v6

    .line 1589
    sget-object v7, Landroid/os/UserHandle;->SYSTEM:Landroid/os/UserHandle;

    const-string v2, "android.permission.RECEIVE_SMS"

    const-string v3, "android:receive_sms"

    move-object v0, p0

    move-object v1, v4

    move-object v4, v6

    move-object v5, p4

    move-object v6, v7

    move v7, p6

    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/InboundSmsHandler;->dispatchIntent(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Landroid/os/UserHandle;I)V

    return-void
.end method

.method public dispose()V
    .locals 0

    .line 380
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->quit()V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 2122
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 2123
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " extends StateMachine:"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 2124
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 2125
    invoke-super {p0, p1, v0, p3}, Lcom/android/internal/telephony/StateMachine;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 2126
    iget-object p2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mCellBroadcastServiceManager:Lcom/android/internal/telephony/CellBroadcastServiceManager;

    if-eqz p2, :cond_0

    .line 2127
    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/CellBroadcastServiceManager;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    :cond_0
    const-string p2, "mLocalLog:"

    .line 2129
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 2130
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 2131
    iget-object p2, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 2132
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "mCarrierServiceLocalLog:"

    .line 2133
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 2134
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 2135
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mCarrierServiceLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 2136
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 2137
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    return-void
.end method

.method protected filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZ)Z
    .locals 7

    .line 1368
    iget-object v6, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mSmsFilters:Ljava/util/List;

    move-object v0, p1

    move v1, p2

    move-object v2, p3

    move-object v3, p4

    move v4, p5

    move v5, p6

    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/InboundSmsHandler;->filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z

    move-result p0

    return p0
.end method

.method public getPhone()Lcom/android/internal/telephony/Phone;
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 399
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method public getWakeLock()Landroid/os/PowerManager$WakeLock;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 2147
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    return-object p0
.end method

.method public getWakeLockTimeout()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 2152
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWakeLockTimeout:I

    return p0
.end method

.method protected getWhatToString(I)Ljava/lang/String;
    .locals 1

    packed-switch p1, :pswitch_data_0

    .line 434
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "UNKNOWN EVENT "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :pswitch_0
    const-string p0, "EVENT_RECEIVER_TIMEOUT"

    goto :goto_0

    :pswitch_1
    const-string p0, "EVENT_UPDATE_TRACKER"

    goto :goto_0

    :pswitch_2
    const-string p0, "EVENT_INJECT_SMS"

    goto :goto_0

    :pswitch_3
    const-string p0, "EVENT_START_ACCEPTING_SMS"

    goto :goto_0

    :pswitch_4
    const-string p0, "EVENT_RELEASE_WAKELOCK"

    goto :goto_0

    :pswitch_5
    const-string p0, "EVENT_RETURN_TO_IDLE"

    goto :goto_0

    :pswitch_6
    const-string p0, "EVENT_BROADCAST_COMPLETE"

    goto :goto_0

    :pswitch_7
    const-string p0, "EVENT_BROADCAST_SMS"

    goto :goto_0

    :pswitch_8
    const-string p0, "EVENT_NEW_SMS"

    :goto_0
    return-object p0

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

.method protected handleSmsWhitelisting(Landroid/content/ComponentName;Z)Landroid/os/Bundle;
    .locals 9
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    if-eqz p1, :cond_0

    .line 1514
    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    const-string/jumbo v0, "sms-app"

    goto :goto_0

    .line 1517
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object p1

    const-string/jumbo v0, "sms-broadcast"

    :goto_0
    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz p2, :cond_1

    .line 1523
    invoke-static {}, Landroid/app/BroadcastOptions;->makeBasic()Landroid/app/BroadcastOptions;

    move-result-object v1

    .line 1524
    invoke-virtual {v1, v2}, Landroid/app/BroadcastOptions;->setBackgroundActivityStartsAllowed(Z)V

    .line 1525
    invoke-virtual {v1}, Landroid/app/BroadcastOptions;->toBundle()Landroid/os/Bundle;

    .line 1527
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mPowerWhitelistManager:Landroid/os/PowerWhitelistManager;

    const/16 p2, 0x13a

    invoke-virtual {p0, p1, v2, p2, v0}, Landroid/os/PowerWhitelistManager;->whitelistAppTemporarilyForEvent(Ljava/lang/String;IILjava/lang/String;)J

    move-result-wide v4

    if-nez v1, :cond_2

    .line 1529
    invoke-static {}, Landroid/app/BroadcastOptions;->makeBasic()Landroid/app/BroadcastOptions;

    move-result-object v1

    :cond_2
    const/4 v6, 0x0

    const/16 v7, 0x13a

    const-string v8, ""

    move-object v3, v1

    .line 1530
    invoke-virtual/range {v3 .. v8}, Landroid/app/BroadcastOptions;->setTemporaryAppAllowlist(JIILjava/lang/String;)V

    .line 1534
    invoke-virtual {v1}, Landroid/app/BroadcastOptions;->toBundle()Landroid/os/Bundle;

    move-result-object p0

    return-object p0
.end method

.method protected abstract is3gpp2()Z
.end method

.method protected log(Ljava/lang/String;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2058
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected log(Ljava/lang/String;J)V
    .locals 1

    .line 2067
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logWithLocalLog(Ljava/lang/String;)V
    .locals 0

    .line 2018
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;)V

    .line 2019
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logWithLocalLog(Ljava/lang/String;J)V
    .locals 1

    .line 2028
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V

    .line 2029
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2077
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;J)V
    .locals 1

    .line 2086
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;)V

    return-void
.end method

.method protected loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 0

    .line 2096
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method protected logeWithLocalLog(Ljava/lang/String;)V
    .locals 0

    .line 2037
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;)V

    .line 2038
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logeWithLocalLog(Ljava/lang/String;J)V
    .locals 1

    .line 2047
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;J)V

    .line 2048
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected onCheckIfOverrideStates()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected onCheckIfStopProcessMessagePart([[BLjava/lang/String;Lcom/android/internal/telephony/InboundSmsTracker;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected onCreateSmsMessage([BLjava/lang/String;)Landroid/telephony/SmsMessage;
    .locals 0

    const-string p0, "3gpp"

    .line 2313
    invoke-static {p1, p0}, Landroid/telephony/SmsMessage;->createFromPdu([BLjava/lang/String;)Landroid/telephony/SmsMessage;

    move-result-object p0

    return-object p0
.end method

.method protected onDispatchWapPdu([[B[BLcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Ljava/lang/String;IJ)I
    .locals 8

    .line 2330
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWapPush:Lcom/android/internal/telephony/WapPushOverSms;

    move-object v1, p2

    move-object v2, p3

    move-object v3, p0

    move-object v4, p4

    move v5, p5

    move-wide v6, p6

    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/WapPushOverSms;->dispatchWapPdu([BLcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Lcom/android/internal/telephony/InboundSmsHandler;Ljava/lang/String;IJ)I

    move-result p0

    return p0
.end method

.method protected onModifyQueryWhereArgs([Ljava/lang/String;)[Ljava/lang/String;
    .locals 0

    return-object p1
.end method

.method protected onQuitting()V
    .locals 1

    .line 388
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWapPush:Lcom/android/internal/telephony/WapPushOverSms;

    invoke-virtual {v0}, Lcom/android/internal/telephony/WapPushOverSms;->dispose()V

    .line 389
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mCellBroadcastServiceManager:Lcom/android/internal/telephony/CellBroadcastServiceManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/CellBroadcastServiceManager;->disable()V

    .line 391
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->isHeld()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 392
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->release()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method protected processMessagePart(Lcom/android/internal/telephony/InboundSmsTracker;)Z
    .locals 27
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    move-object/from16 v9, p0

    move-object/from16 v10, p1

    .line 974
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v0

    .line 977
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDestPort()I

    move-result v1

    .line 979
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getAddress()Ljava/lang/String;

    move-result-object v5

    const/4 v11, 0x0

    if-gtz v0, :cond_0

    .line 983
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "processMessagePart: returning false due to invalid message count "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 984
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v1

    .line 983
    invoke-virtual {v9, v0, v1, v2}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;J)V

    return v11

    :cond_0
    const/4 v12, -0x1

    const/4 v2, 0x0

    const/4 v13, 0x2

    const/4 v14, 0x1

    if-ne v0, v14, :cond_1

    new-array v3, v14, [[B

    .line 990
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getPdu()[B

    move-result-object v4

    aput-object v4, v3, v11

    new-array v4, v14, [J

    .line 991
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getTimestamp()J

    move-result-wide v6

    aput-wide v6, v4, v11

    .line 992
    iget-object v6, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDisplayAddress()Ljava/lang/String;

    move-result-object v7

    invoke-static {v6, v7, v2}, Lcom/android/internal/telephony/BlockChecker;->isBlocked(Landroid/content/Context;Ljava/lang/String;Landroid/os/Bundle;)Z

    move-result v6

    move v12, v1

    move-object v8, v3

    move-object/from16 v23, v4

    move v14, v6

    goto/16 :goto_3

    .line 998
    :cond_1
    :try_start_0
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getReferenceNumber()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    .line 999
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v4

    const/4 v6, 0x3

    new-array v7, v6, [Ljava/lang/String;

    aput-object v5, v7, v11

    aput-object v3, v7, v14

    aput-object v4, v7, v13

    .line 1004
    invoke-virtual {v9, v7}, Lcom/android/internal/telephony/InboundSmsHandler;->onModifyQueryWhereArgs([Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v19

    .line 1006
    iget-object v15, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mResolver:Landroid/content/ContentResolver;

    sget-object v16, Lcom/android/internal/telephony/InboundSmsHandler;->sRawUri:Landroid/net/Uri;

    sget-object v17, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_SEQUENCE_PORT_PROJECTION:[Ljava/lang/String;

    .line 1007
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getQueryForSegments()Ljava/lang/String;

    move-result-object v18

    const/16 v20, 0x0

    .line 1006
    invoke-virtual/range {v15 .. v20}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v4
    :try_end_0
    .catch Landroid/database/SQLException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 1009
    :try_start_1
    invoke-interface {v4}, Landroid/database/Cursor;->getCount()I

    move-result v7

    if-ge v7, v0, :cond_2

    .line 1016
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "processMessagePart: returning false. Only "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " of "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " segments  have arrived. refNumber: "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1018
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v1

    .line 1016
    invoke-virtual {v9, v0, v1, v2}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V
    :try_end_1
    .catch Landroid/database/SQLException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1082
    invoke-interface {v4}, Landroid/database/Cursor;->close()V

    return v11

    .line 1023
    :cond_2
    :try_start_2
    new-array v7, v0, [[B

    .line 1024
    new-array v8, v0, [J

    move v15, v11

    .line 1025
    :goto_0
    invoke-interface {v4}, Landroid/database/Cursor;->moveToNext()Z

    move-result v16

    if-eqz v16, :cond_7

    .line 1027
    sget-object v2, Lcom/android/internal/telephony/InboundSmsHandler;->PDU_SEQUENCE_PORT_PROJECTION_INDEX_MAPPING:Ljava/util/Map;

    .line 1028
    invoke-static {v14}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-interface {v2, v6}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result v6

    .line 1027
    invoke-interface {v4, v6}, Landroid/database/Cursor;->getInt(I)I

    move-result v6

    .line 1028
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getIndexOffset()I

    move-result v18

    sub-int v6, v6, v18

    if-ge v6, v0, :cond_6

    if-gez v6, :cond_3

    goto/16 :goto_1

    .line 1043
    :cond_3
    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v14

    invoke-interface {v2, v14}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/Integer;

    invoke-virtual {v14}, Ljava/lang/Integer;->intValue()I

    move-result v14

    .line 1042
    invoke-interface {v4, v14}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v14

    invoke-static {v14}, Lcom/android/internal/telephony/HexDump;->hexStringToByteArray(Ljava/lang/String;)[B

    move-result-object v14

    aput-object v14, v7, v6

    if-nez v6, :cond_4

    .line 1048
    invoke-static {v13}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v14

    invoke-interface {v2, v14}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/Integer;

    invoke-virtual {v14}, Ljava/lang/Integer;->intValue()I

    move-result v14

    .line 1047
    invoke-interface {v4, v14}, Landroid/database/Cursor;->isNull(I)Z

    move-result v14

    if-nez v14, :cond_4

    .line 1050
    invoke-static {v13}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v14

    invoke-interface {v2, v14}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/Integer;

    invoke-virtual {v14}, Ljava/lang/Integer;->intValue()I

    move-result v14

    .line 1049
    invoke-interface {v4, v14}, Landroid/database/Cursor;->getInt(I)I

    move-result v14

    .line 1052
    invoke-static {v14}, Lcom/android/internal/telephony/InboundSmsTracker;->getRealDestPort(I)I

    move-result v14

    if-eq v14, v12, :cond_4

    move v1, v14

    :cond_4
    const/4 v14, 0x3

    .line 1059
    invoke-static {v14}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v12

    invoke-interface {v2, v12}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Ljava/lang/Integer;

    invoke-virtual {v12}, Ljava/lang/Integer;->intValue()I

    move-result v12

    .line 1058
    invoke-interface {v4, v12}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v19

    aput-wide v19, v8, v6

    if-nez v15, :cond_5

    .line 1069
    iget-object v6, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mContext:Landroid/content/Context;

    const/16 v12, 0x9

    .line 1071
    invoke-static {v12}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v12

    invoke-interface {v2, v12}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 1070
    invoke-interface {v4, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    const/4 v12, 0x0

    .line 1069
    invoke-static {v6, v2, v12}, Lcom/android/internal/telephony/BlockChecker;->isBlocked(Landroid/content/Context;Ljava/lang/String;Landroid/os/Bundle;)Z

    move-result v2

    move v15, v2

    :cond_5
    move v6, v14

    const/4 v2, 0x0

    goto :goto_2

    :cond_6
    :goto_1
    const/4 v14, 0x3

    const-string v2, "processMessagePart: invalid seqNumber = %d, messageCount = %d"

    new-array v12, v13, [Ljava/lang/Object;

    .line 1036
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getIndexOffset()I

    move-result v19

    add-int v6, v6, v19

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v12, v11

    .line 1037
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    const/16 v18, 0x1

    aput-object v6, v12, v18

    .line 1034
    invoke-static {v2, v12}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    move v12, v15

    .line 1038
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v14

    .line 1034
    invoke-virtual {v9, v2, v14, v15}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;J)V

    move v15, v12

    const/4 v2, 0x0

    const/4 v6, 0x3

    :goto_2
    const/4 v12, -0x1

    const/4 v14, 0x1

    goto/16 :goto_0

    :cond_7
    move v12, v15

    .line 1074
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "processMessagePart: all "

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " segments  received. refNumber: "

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 1075
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v14

    .line 1074
    invoke-virtual {v9, v2, v14, v15}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V
    :try_end_2
    .catch Landroid/database/SQLException; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 1082
    invoke-interface {v4}, Landroid/database/Cursor;->close()V

    move-object/from16 v23, v8

    move v14, v12

    move v12, v1

    move-object v8, v7

    :goto_3
    const/16 v1, 0xb84

    if-ne v12, v1, :cond_8

    const/4 v1, 0x1

    goto :goto_4

    :cond_8
    move v1, v11

    .line 1088
    :goto_4
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getFormat()Ljava/lang/String;

    move-result-object v15

    .line 1091
    invoke-static {v8}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v2

    .line 1092
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v3

    if-eqz v3, :cond_16

    const/4 v3, 0x0

    invoke-interface {v2, v3}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_9

    goto/16 :goto_a

    .line 1101
    :cond_9
    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    if-eqz v1, :cond_c

    .line 1103
    array-length v3, v8

    move v4, v11

    :goto_5
    if-ge v4, v3, :cond_c

    aget-object v6, v8, v4

    const-string v7, "3gpp"

    if-ne v15, v7, :cond_b

    .line 1110
    invoke-virtual {v9, v6, v7}, Lcom/android/internal/telephony/InboundSmsHandler;->onCreateSmsMessage([BLjava/lang/String;)Landroid/telephony/SmsMessage;

    move-result-object v6

    if-eqz v6, :cond_a

    .line 1113
    invoke-virtual {v6}, Landroid/telephony/SmsMessage;->getUserData()[B

    move-result-object v6

    goto :goto_6

    .line 1116
    :cond_a
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v1

    const-string v3, "processMessagePart: SmsMessage.createFromPdu returned null"

    .line 1115
    invoke-virtual {v9, v3, v1, v2}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;J)V

    .line 1117
    iget-object v1, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mMetrics:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    iget-object v2, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v20

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSource()I

    move-result v21

    const/16 v24, 0x0

    .line 1119
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v25

    const-string v22, "3gpp"

    move-object/from16 v19, v1

    .line 1117
    invoke-virtual/range {v19 .. v26}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingWapPush(IILjava/lang/String;[JZJ)V

    .line 1120
    iget-object v1, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSmsStats()Lcom/android/internal/telephony/metrics/SmsStats;

    move-result-object v1

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSource()I

    move-result v2

    const/16 v4, 0x8

    .line 1121
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v5

    move v3, v0

    .line 1120
    invoke-virtual/range {v1 .. v6}, Lcom/android/internal/telephony/metrics/SmsStats;->onIncomingSmsWapPush(IIIJ)V

    return v11

    .line 1125
    :cond_b
    :goto_6
    array-length v7, v6

    invoke-virtual {v2, v6, v11, v7}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    add-int/lit8 v4, v4, 0x1

    goto :goto_5

    .line 1129
    :cond_c
    invoke-virtual {v10, v9}, Lcom/android/internal/telephony/InboundSmsTracker;->getSmsBroadcastReceiver(Lcom/android/internal/telephony/InboundSmsHandler;)Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;

    move-result-object v16

    .line 1132
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getFormat()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v9, v8, v3, v10}, Lcom/android/internal/telephony/InboundSmsHandler;->onCheckIfStopProcessMessagePart([[BLjava/lang/String;Lcom/android/internal/telephony/InboundSmsTracker;)Z

    move-result v3

    if-eqz v3, :cond_d

    return v11

    .line 1137
    :cond_d
    iget-object v3, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mUserManager:Landroid/os/UserManager;

    invoke-virtual {v3}, Landroid/os/UserManager;->isUserUnlocked()Z

    move-result v3

    if-nez v3, :cond_f

    .line 1138
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "processMessagePart: !isUserUnlocked; calling processMessagePartWithUserLocked. Port: "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1139
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v3

    .line 1138
    invoke-virtual {v9, v0, v3, v4}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V

    if-eqz v1, :cond_e

    const/4 v0, 0x1

    new-array v0, v0, [[B

    .line 1142
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    aput-object v1, v0, v11

    move-object v3, v0

    goto :goto_7

    :cond_e
    move-object v3, v8

    :goto_7
    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move v4, v12

    move-object/from16 v5, v16

    move v6, v14

    .line 1140
    invoke-virtual/range {v1 .. v6}, Lcom/android/internal/telephony/InboundSmsHandler;->processMessagePartWithUserLocked(Lcom/android/internal/telephony/InboundSmsTracker;[[BILcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Z)Z

    move-result v0

    return v0

    :cond_f
    if-eqz v1, :cond_13

    .line 1154
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v3

    .line 1155
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSubId()I

    move-result v6

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v19

    move-object/from16 v1, p0

    move-object v2, v8

    move-object/from16 v4, v16

    move-wide/from16 v7, v19

    .line 1154
    invoke-virtual/range {v1 .. v8}, Lcom/android/internal/telephony/InboundSmsHandler;->onDispatchWapPdu([[B[BLcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Ljava/lang/String;IJ)I

    move-result v7

    .line 1159
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "processMessagePart: dispatchWapPdu() returned "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1160
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v2

    .line 1159
    invoke-virtual {v9, v1, v2, v3}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V

    const/4 v1, -0x1

    if-eq v7, v1, :cond_11

    const/4 v1, 0x1

    if-ne v7, v1, :cond_10

    goto :goto_8

    :cond_10
    move/from16 v24, v11

    goto :goto_9

    :cond_11
    :goto_8
    const/16 v24, 0x1

    .line 1166
    :goto_9
    iget-object v1, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mMetrics:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    iget-object v2, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v20

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSource()I

    move-result v21

    .line 1167
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v25

    move-object/from16 v19, v1

    move-object/from16 v22, v15

    .line 1166
    invoke-virtual/range {v19 .. v26}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingWapPush(IILjava/lang/String;[JZJ)V

    .line 1168
    iget-object v1, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSmsStats()Lcom/android/internal/telephony/metrics/SmsStats;

    move-result-object v1

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSource()I

    move-result v2

    .line 1169
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v5

    move v3, v0

    move v4, v7

    .line 1168
    invoke-virtual/range {v1 .. v6}, Lcom/android/internal/telephony/metrics/SmsStats;->onIncomingSmsWapPush(IIIJ)V

    const/4 v0, -0x1

    if-ne v7, v0, :cond_12

    const/4 v0, 0x1

    return v0

    .line 1174
    :cond_12
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDeleteWhere()Ljava/lang/String;

    move-result-object v0

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDeleteWhereArgs()[Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v9, v0, v1, v13}, Lcom/android/internal/telephony/InboundSmsHandler;->deleteFromRawTable(Ljava/lang/String;[Ljava/lang/String;I)V

    .line 1177
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v0

    const-string v2, "processMessagePart: returning false as the ordered broadcast for WAP push was not sent"

    .line 1176
    invoke-virtual {v9, v2, v0, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;J)V

    return v11

    .line 1186
    :cond_13
    iget-object v1, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mMetrics:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    iget-object v2, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v20

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSource()I

    move-result v21

    .line 1187
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v25

    move-object/from16 v19, v1

    move-object/from16 v22, v15

    move/from16 v24, v14

    .line 1186
    invoke-virtual/range {v19 .. v26}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSmsSession(IILjava/lang/String;[JZJ)V

    .line 1188
    iget-object v1, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSmsStats()Lcom/android/internal/telephony/metrics/SmsStats;

    move-result-object v1

    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/InboundSmsHandler;->is3gpp2()Z

    move-result v2

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSource()I

    move-result v3

    .line 1189
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v6

    move v4, v0

    move v5, v14

    .line 1188
    invoke-virtual/range {v1 .. v7}, Lcom/android/internal/telephony/metrics/SmsStats;->onIncomingSmsSuccess(ZIIZJ)V

    const/4 v6, 0x1

    move-object/from16 v1, p0

    move-object v2, v8

    move v3, v12

    move-object/from16 v4, p1

    move-object/from16 v5, v16

    move v7, v14

    .line 1194
    invoke-virtual/range {v1 .. v7}, Lcom/android/internal/telephony/InboundSmsHandler;->filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZ)Z

    move-result v0

    if-nez v0, :cond_15

    if-eqz v14, :cond_14

    .line 1201
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDeleteWhere()Ljava/lang/String;

    move-result-object v0

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getDeleteWhereArgs()[Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v9, v0, v1, v2}, Lcom/android/internal/telephony/InboundSmsHandler;->deleteFromRawTable(Ljava/lang/String;[Ljava/lang/String;I)V

    .line 1204
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v0

    const-string v2, "processMessagePart: returning false as the phone number is blocked"

    .line 1203
    invoke-virtual {v9, v2, v0, v1}, Lcom/android/internal/telephony/InboundSmsHandler;->log(Ljava/lang/String;J)V

    return v11

    .line 1209
    :cond_14
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->isClass0()Z

    move-result v6

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSubId()I

    move-result v7

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v10

    move-object/from16 v1, p0

    move-object v2, v8

    move-object v3, v15

    move v4, v12

    move-object/from16 v5, v16

    move-wide v8, v10

    .line 1208
    invoke-virtual/range {v1 .. v9}, Lcom/android/internal/telephony/InboundSmsHandler;->dispatchSmsDeliveryIntent([[BLjava/lang/String;ILcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZIJ)V

    :cond_15
    const/4 v0, 0x1

    return v0

    .line 1093
    :cond_16
    :goto_a
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "processMessagePart: returning false due to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1094
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v1

    if-nez v1, :cond_17

    const-string v1, "pduList.size() == 0"

    goto :goto_b

    :cond_17
    const-string v1, "pduList.contains(null)"

    :goto_b
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1095
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v1

    invoke-virtual {v9, v0, v1, v2}, Lcom/android/internal/telephony/InboundSmsHandler;->logeWithLocalLog(Ljava/lang/String;J)V

    .line 1096
    iget-object v0, v9, Lcom/android/internal/telephony/InboundSmsHandler;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSmsStats()Lcom/android/internal/telephony/metrics/SmsStats;

    move-result-object v0

    .line 1097
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/InboundSmsHandler;->is3gpp2()Z

    move-result v1

    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getSource()I

    move-result v2

    const/4 v3, 0x7

    .line 1096
    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/SmsStats;->onIncomingSmsError(ZII)V

    return v11

    :catchall_0
    move-exception v0

    move-object v2, v4

    goto :goto_d

    :catch_0
    move-exception v0

    move-object v2, v4

    goto :goto_c

    :catchall_1
    move-exception v0

    move-object v3, v2

    goto :goto_d

    :catch_1
    move-exception v0

    move-object v3, v2

    .line 1077
    :goto_c
    :try_start_3
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "processMessagePart: Can\'t access multipart SMS database, "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1078
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageId()J

    move-result-wide v3

    invoke-static {v3, v4}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1077
    invoke-virtual {v9, v1, v0}, Lcom/android/internal/telephony/InboundSmsHandler;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    if-eqz v2, :cond_18

    .line 1082
    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    :cond_18
    return v11

    :catchall_2
    move-exception v0

    :goto_d
    if-eqz v2, :cond_19

    invoke-interface {v2}, Landroid/database/Cursor;->close()V

    .line 1084
    :cond_19
    throw v0
.end method

.method protected processMessagePartWithUserLocked(Lcom/android/internal/telephony/InboundSmsTracker;[[BILcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Z)Z
    .locals 9

    const/4 v0, 0x0

    const/16 v1, 0xb84

    if-ne p3, v1, :cond_0

    .line 1229
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mWapPush:Lcom/android/internal/telephony/WapPushOverSms;

    aget-object v2, p2, v0

    invoke-virtual {v1, v2, p0}, Lcom/android/internal/telephony/WapPushOverSms;->isWapPushForMms([BLcom/android/internal/telephony/InboundSmsHandler;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1230
    invoke-direct {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->showNewMessageNotification()V

    return v0

    :cond_0
    const/4 v1, -0x1

    if-ne p3, v1, :cond_2

    const/4 v7, 0x0

    move-object v2, p0

    move-object v3, p2

    move v4, p3

    move-object v5, p1

    move-object v6, p4

    move v8, p5

    .line 1235
    invoke-virtual/range {v2 .. v8}, Lcom/android/internal/telephony/InboundSmsHandler;->filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZ)Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    if-nez p5, :cond_2

    .line 1245
    invoke-direct {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->showNewMessageNotification()V

    :cond_2
    return v0
.end method

.method public setSmsFiltersForTesting(Ljava/util/List;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;",
            ">;)V"
        }
    .end annotation

    if-nez p1, :cond_0

    .line 2170
    invoke-direct {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->createDefaultSmsFilters()Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mSmsFilters:Ljava/util/List;

    goto :goto_0

    .line 2172
    :cond_0
    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler;->mSmsFilters:Ljava/util/List;

    :goto_0
    return-void
.end method
