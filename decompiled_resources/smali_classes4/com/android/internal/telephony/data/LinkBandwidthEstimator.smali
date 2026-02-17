.class public Lcom/android/internal/telephony/data/LinkBandwidthEstimator;
.super Landroid/os/Handler;
.source "LinkBandwidthEstimator.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;,
        Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkKey;,
        Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;,
        Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;,
        Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;
    }
.end annotation


# static fields
.field private static final AVG_BW_PER_RAT:[Ljava/lang/String;

.field private static final AVG_BW_PER_RAT_MAP:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field

.field public static final BW_STATS_COUNT_THRESHOLD:I = 0x5

.field private static final BW_UPDATE_THRESHOLD_PERCENT:I = 0xf

.field private static final BYTE_DELTA_ACC_THRESHOLD_MAX_KB:I = 0x1f40

.field private static final BYTE_DELTA_THRESHOLD_KB:[[I

.field private static final BYTE_DELTA_THRESHOLD_MIN_KB:I = 0xa

.field private static final DBG:Z = false

.field private static final DEFAULT_LINK_BAND_WIDTH_KBPS:I = 0xe

.field private static final FILTER_SCALE:I = 0x80

.field private static final FILTER_UPDATE_MAX_INTERVAL_MS:I = 0x13ec

.field private static final HIGH_BANDWIDTH_THRESHOLD_KBPS:I = 0x1388

.field private static final LARGE_TIME_DECAY_RATIO:I = 0x4

.field public static final LINK_RX:I = 0x1

.field public static final LINK_TX:I = 0x0

.field private static final LOW_BW_TO_AVG_BW_RATIO_DEN:I = 0x8

.field private static final LOW_BW_TO_AVG_BW_RATIO_NUM:I = 0x3

.field private static final MAX_BW_TO_STATIC_BW_RATIO:I = 0xf

.field private static final MAX_ERROR_PERCENT:I = 0x2710

.field private static final MODEM_POLL_MIN_INTERVAL_MS:I = 0x1388

.field private static final MODEM_POLL_TIME_DELTA_MAX_MS:I = 0x2710

.field static final MSG_ACTIVE_PHONE_CHANGED:I = 0x8
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_DATA_REG_STATE_OR_RAT_CHANGED:I = 0x9
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_DEFAULT_NETWORK_CHANGED:I = 0x4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_MODEM_ACTIVITY_RETURNED:I = 0x3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_NR_FREQUENCY_CHANGED:I = 0x6
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_NR_STATE_CHANGED:I = 0x7
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_SCREEN_STATE_CHANGED:I = 0x1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_SIGNAL_STRENGTH_CHANGED:I = 0x5
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final MSG_TRAFFIC_STATS_POLL:I = 0x2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final NUM_LINK_DIRECTION:I = 0x2

.field public static final NUM_SIGNAL_LEVEL:I = 0x5

.field private static final RSSI_DELTA_THRESHOLD_DB:I = 0x6

.field private static final TAG:Ljava/lang/String;

.field private static final TIME_CONSTANT_LARGE_SEC:I = 0x6

.field private static final TIME_CONSTANT_SMALL_SEC:I = 0x6

.field private static final TRAFFIC_MODEM_POLL_BYTE_RATIO:I = 0x8

.field private static final TRAFFIC_POLL_BYTE_THRESHOLD_MAX:I = 0x4e20

.field private static final TRAFFIC_STATS_POLL_INTERVAL_MS:I = 0x3e8

.field private static final TX_OVER_RX_TIME_RATIO_THRESHOLD_DEN:I = 0x2

.field private static final TX_OVER_RX_TIME_RATIO_THRESHOLD_NUM:I = 0x3

.field private static final TX_RX_TIME_MIN_MS:I = 0xc8

.field private static final UNKNOWN_PLMN:Ljava/lang/String; = ""

.field static final UNKNOWN_TAC:I = -0x1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field


# instance fields
.field private mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mBandwidthUpdateDataRat:I

.field private mBandwidthUpdatePlmn:Ljava/lang/String;

.field private mBandwidthUpdateSignalDbm:I

.field private mBandwidthUpdateSignalLevel:I

.field private final mConnectivityManager:Landroid/net/ConnectivityManager;

.field private mDataActivity:I

.field private mDataRat:I

.field private final mDefaultNetworkCallback:Landroid/net/ConnectivityManager$NetworkCallback;

.field private final mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

.field private mFilterUpdateTimeMs:J

.field private mIsOnActiveData:Z

.field private mIsOnDefaultRoute:Z

.field private mLastDrsOrRatChangeTimeMs:J

.field private mLastMobileRxBytes:J

.field private mLastMobileTxBytes:J

.field private mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

.field private mLastModemPollTimeMs:J

.field private mLastPlmnOrRatChangeTimeMs:J

.field private mLastTrafficValid:Z

.field private final mLinkBandwidthEstimatorCallbacks:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;",
            ">;"
        }
    .end annotation
.end field

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private mNetworkCapabilities:Landroid/net/NetworkCapabilities;

.field private final mNetworkMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkKey;",
            "Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;",
            ">;"
        }
    .end annotation
.end field

.field private final mOutcomeReceiver:Landroid/os/OutcomeReceiver;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/OutcomeReceiver<",
            "Landroid/telephony/ModemActivityInfo;",
            "Landroid/telephony/TelephonyManager$ModemActivityInfoException;",
            ">;"
        }
    .end annotation
.end field

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private mPlaceholderNetwork:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

.field private mPlmn:Ljava/lang/String;

.field private mRxBytesDeltaAcc:J

.field private mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

.field private mScreenOn:Z

.field private mSignalLevel:I

.field private mSignalStrengthDbm:I

.field private mTac:I

.field private final mTelephonyCallback:Landroid/telephony/TelephonyCallback;

.field private final mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

.field private final mTelephonyManager:Landroid/telephony/TelephonyManager;

.field private mTxBytesDeltaAcc:J

.field private mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;


# direct methods
.method public static synthetic $r8$lambda$1hA86NzMzjeHn3pDRgTeKJeuexI(IILcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lambda$sendLinkBandwidthToDataConnection$5(IILcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$8FcSc2iIH8Ag8IiSVwTDlVABY0g(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;II)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lambda$sendLinkBandwidthToDataConnection$4(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;II)V

    return-void
.end method

.method public static synthetic $r8$lambda$mSUa_Od1PquuZqjF8L4npKwREYs(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lambda$handleTrafficStatsPollConditionChanged$0(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$ni_F9nNfyGVu1AC7_ETPrBsY8gI(ILcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lambda$handleTrafficStatsPoll$3(ILcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$ooZIl3UpkxFNK5IEXF2c4iKHIzs(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;I)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lambda$handleTrafficStatsPoll$2(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$rsvd5nNsk3qElDSl-2932gHlPjE(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lambda$handleTrafficStatsPollConditionChanged$1(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmBandwidthUpdateDataRat(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateDataRat:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmBandwidthUpdatePlmn(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdatePlmn:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmBandwidthUpdateSignalDbm(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateSignalDbm:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmDataRat(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPlmn(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSignalLevel(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalLevel:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmSignalStrengthDbm(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalStrengthDbm:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmTac(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTac:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmTelephonyFacade(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Lcom/android/internal/telephony/TelephonyFacade;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mgetNrMode(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;I)I
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getNrMode(I)I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misScreenOn(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->isScreenOn()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mlookupNetwork(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;Ljava/lang/String;Ljava/lang/String;)Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lookupNetwork(Ljava/lang/String;Ljava/lang/String;)Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$sfgetBYTE_DELTA_THRESHOLD_KB()[[I
    .locals 1

    sget-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->BYTE_DELTA_THRESHOLD_KB:[[I

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetTAG()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->TAG:Ljava/lang/String;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 22

    .line 79
    const-class v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->TAG:Ljava/lang/String;

    const/4 v0, 0x2

    new-array v0, v0, [[I

    const/4 v1, 0x5

    new-array v2, v1, [I

    .line 136
    fill-array-data v2, :array_0

    const/4 v3, 0x0

    aput-object v2, v0, v3

    new-array v1, v1, [I

    fill-array-data v1, :array_1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    sput-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->BYTE_DELTA_THRESHOLD_KB:[[I

    const-string v3, "GPRS:24,24"

    const-string v4, "EDGE:70,18"

    const-string v5, "UMTS:115,115"

    const-string v6, "CDMA:14,14"

    const-string v7, "CDMA - 1xRTT:30,30"

    const-string v8, "CDMA - EvDo rev. 0:750,48"

    const-string v9, "CDMA - EvDo rev. A:950,550"

    const-string v10, "HSDPA:4300,620"

    const-string v11, "HSUPA:4300,1800"

    const-string v12, "HSPA:4300,1800"

    const-string v13, "CDMA - EvDo rev. B:1500,550"

    const-string v14, "CDMA - eHRPD:750,48"

    const-string v15, "HSPA+:13000,3400"

    const-string v16, "TD_SCDMA:115,115"

    const-string v17, "LTE:30000,15000"

    const-string v18, "NR_NSA:47000,18000"

    const-string v19, "NR_NSA_MMWAVE:145000,60000"

    const-string v20, "NR:145000,60000"

    const-string v21, "NR_MMWAVE:145000,60000"

    .line 144
    filled-new-array/range {v3 .. v21}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->AVG_BW_PER_RAT:[Ljava/lang/String;

    .line 151
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->AVG_BW_PER_RAT_MAP:Ljava/util/Map;

    return-void

    :array_0
    .array-data 4
        0xc8
        0x12c
        0x190
        0x258
        0x3e8
    .end array-data

    :array_1
    .array-data 4
        0x190
        0x258
        0x320
        0x3e8
        0x3e8
    .end array-data
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/TelephonyFacade;)V
    .locals 9

    .line 297
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 166
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x200

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    const/4 v0, 0x0

    .line 167
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mScreenOn:Z

    .line 168
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnDefaultRoute:Z

    .line 169
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnActiveData:Z

    const/4 v1, 0x1

    .line 171
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastTrafficValid:Z

    const/4 v2, 0x0

    .line 177
    iput-object v2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

    .line 178
    new-instance v3, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;

    invoke-direct {v3, p0, v2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyCallback:Landroid/telephony/TelephonyCallback;

    .line 181
    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    const-string v4, ""

    .line 183
    iput-object v4, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    const/4 v5, -0x1

    .line 188
    iput v5, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateSignalDbm:I

    .line 189
    iput v5, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateSignalLevel:I

    .line 190
    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateDataRat:I

    .line 191
    iput-object v4, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdatePlmn:Ljava/lang/String;

    .line 192
    new-instance v5, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-direct {v5, p0, v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;I)V

    iput-object v5, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    .line 193
    new-instance v5, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-direct {v5, p0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;I)V

    iput-object v5, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    .line 194
    new-instance v5, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v5}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v5, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 198
    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataActivity:I

    .line 201
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLinkBandwidthEstimatorCallbacks:Ljava/util/Set;

    .line 253
    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$1;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    .line 269
    new-instance v5, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$2;

    invoke-direct {v5, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$2;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)V

    iput-object v5, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mOutcomeReceiver:Landroid/os/OutcomeReceiver;

    .line 284
    new-instance v5, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$3;

    invoke-direct {v5, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$3;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)V

    iput-object v5, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDefaultNetworkCallback:Landroid/net/ConnectivityManager$NetworkCallback;

    .line 1151
    new-instance v6, Landroid/util/ArrayMap;

    invoke-direct {v6}, Landroid/util/ArrayMap;-><init>()V

    iput-object v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkMap:Ljava/util/Map;

    .line 298
    iput-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 299
    iput-object p2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    .line 300
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    const-class v6, Landroid/telephony/TelephonyManager;

    .line 301
    invoke-virtual {p2, v6}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/TelephonyManager;

    .line 302
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v6

    invoke-virtual {p2, v6}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    .line 303
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v6

    const-class v7, Landroid/net/ConnectivityManager;

    invoke-virtual {v6, v7}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/net/ConnectivityManager;

    iput-object v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mConnectivityManager:Landroid/net/ConnectivityManager;

    .line 304
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v7

    const-string v8, "display"

    invoke-virtual {v7, v8}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/hardware/display/DisplayManager;

    .line 306
    invoke-virtual {v7, v0, v2}, Landroid/hardware/display/DisplayManager;->registerDisplayListener(Landroid/hardware/display/DisplayManager$DisplayListener;Landroid/os/Handler;)V

    .line 307
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->isScreenOn()Z

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleScreenStateChanged(Z)V

    .line 308
    invoke-virtual {v6, v5, p0}, Landroid/net/ConnectivityManager;->registerDefaultNetworkCallback(Landroid/net/ConnectivityManager$NetworkCallback;Landroid/os/Handler;)V

    .line 309
    new-instance v0, Landroid/os/HandlerExecutor;

    invoke-direct {v0, p0}, Landroid/os/HandlerExecutor;-><init>(Landroid/os/Handler;)V

    invoke-virtual {p2, v0, v3}, Landroid/telephony/TelephonyManager;->registerTelephonyCallback(Ljava/util/concurrent/Executor;Landroid/telephony/TelephonyCallback;)V

    .line 311
    new-instance p2, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    invoke-direct {p2, p0, v4}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;Ljava/lang/String;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlaceholderNetwork:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    .line 312
    invoke-static {}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->initAvgBwPerRatTable()V

    .line 313
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->registerNrStateFrequencyChange()V

    .line 314
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p1

    const/16 p2, 0x9

    invoke-virtual {p1, v1, p0, p2, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForDataRegStateOrRatChanged(ILandroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method private getDataNri()Landroid/telephony/NetworkRegistrationInfo;
    .locals 2

    .line 1060
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    const/4 v0, 0x2

    const/4 v1, 0x1

    invoke-virtual {p0, v0, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    return-object p0
.end method

.method public static getDataRatName(II)Ljava/lang/String;
    .locals 2

    const/16 v0, 0xd

    if-ne p0, v0, :cond_2

    const/4 v0, 0x2

    if-eq p1, v0, :cond_0

    const/4 v1, 0x3

    if-ne p1, v1, :cond_2

    :cond_0
    if-ne p1, v0, :cond_1

    const-string p0, "NR_NSA"

    goto :goto_0

    :cond_1
    const-string p0, "NR_NSA_MMWAVE"

    :goto_0
    return-object p0

    :cond_2
    const/16 v0, 0x14

    if-ne p0, v0, :cond_4

    const/4 v0, 0x4

    if-ne p1, v0, :cond_3

    .line 1009
    invoke-static {p0}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    :cond_3
    const-string p0, "NR_MMWAVE"

    :goto_1
    return-object p0

    .line 1011
    :cond_4
    invoke-static {p0}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private getModemTxTimeMs(Landroid/telephony/ModemActivityInfo;)J
    .locals 4

    const-wide/16 v0, 0x0

    const/4 p0, 0x0

    .line 641
    :goto_0
    invoke-static {}, Landroid/telephony/ModemActivityInfo;->getNumTxPowerLevels()I

    move-result v2

    if-ge p0, v2, :cond_0

    .line 642
    invoke-virtual {p1, p0}, Landroid/telephony/ModemActivityInfo;->getTransmitDurationMillisAtPowerLevel(I)J

    move-result-wide v2

    add-long/2addr v0, v2

    add-int/lit8 p0, p0, 0x1

    goto :goto_0

    :cond_0
    return-wide v0
.end method

.method private getNrMode(I)I
    .locals 2

    const/4 v0, 0x4

    const/16 v1, 0xd

    if-ne p1, v1, :cond_1

    .line 987
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->isNrNsaConnected()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 989
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 988
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result p0

    if-ne p0, v0, :cond_0

    const/4 p0, 0x3

    goto :goto_0

    :cond_0
    const/4 p0, 0x2

    :goto_0
    return p0

    :cond_1
    const/16 v1, 0x14

    if-ne p1, v1, :cond_3

    .line 993
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 992
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result p0

    if-ne p0, v0, :cond_2

    const/4 v0, 0x5

    :cond_2
    return v0

    :cond_3
    const/4 p0, 0x1

    return p0
.end method

.method private getTac(Landroid/telephony/CellIdentity;)I
    .locals 0

    .line 1106
    instance-of p0, p1, Landroid/telephony/CellIdentityLte;

    if-eqz p0, :cond_0

    .line 1107
    check-cast p1, Landroid/telephony/CellIdentityLte;

    invoke-virtual {p1}, Landroid/telephony/CellIdentityLte;->getTac()I

    move-result p0

    return p0

    .line 1109
    :cond_0
    instance-of p0, p1, Landroid/telephony/CellIdentityNr;

    if-eqz p0, :cond_1

    .line 1110
    check-cast p1, Landroid/telephony/CellIdentityNr;

    invoke-virtual {p1}, Landroid/telephony/CellIdentityNr;->getTac()I

    move-result p0

    return p0

    .line 1112
    :cond_1
    instance-of p0, p1, Landroid/telephony/CellIdentityWcdma;

    if-eqz p0, :cond_2

    .line 1113
    check-cast p1, Landroid/telephony/CellIdentityWcdma;

    invoke-virtual {p1}, Landroid/telephony/CellIdentityWcdma;->getLac()I

    move-result p0

    return p0

    .line 1115
    :cond_2
    instance-of p0, p1, Landroid/telephony/CellIdentityTdscdma;

    if-eqz p0, :cond_3

    .line 1116
    check-cast p1, Landroid/telephony/CellIdentityTdscdma;

    invoke-virtual {p1}, Landroid/telephony/CellIdentityTdscdma;->getLac()I

    move-result p0

    return p0

    .line 1118
    :cond_3
    instance-of p0, p1, Landroid/telephony/CellIdentityGsm;

    if-eqz p0, :cond_4

    .line 1119
    check-cast p1, Landroid/telephony/CellIdentityGsm;

    invoke-virtual {p1}, Landroid/telephony/CellIdentityGsm;->getLac()I

    move-result p0

    return p0

    :cond_4
    const/4 p0, 0x0

    return p0
.end method

.method private handleActivePhoneChanged(I)V
    .locals 2

    .line 448
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    if-ne p1, v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 449
    :goto_0
    iget-boolean v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnActiveData:Z

    if-ne v1, v0, :cond_1

    return-void

    .line 452
    :cond_1
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnActiveData:Z

    .line 453
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsOnActiveData "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnActiveData:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " activeDataSubId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->logd(Ljava/lang/String;)V

    .line 454
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleTrafficStatsPollConditionChanged()V

    return-void
.end method

.method private handleDefaultNetworkChanged(Landroid/net/NetworkCapabilities;)V
    .locals 1

    .line 433
    iput-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/4 v0, 0x0

    if-nez p1, :cond_0

    goto :goto_0

    .line 438
    :cond_0
    invoke-virtual {p1, v0}, Landroid/net/NetworkCapabilities;->hasTransport(I)Z

    move-result v0

    .line 440
    :goto_0
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnDefaultRoute:Z

    if-ne p1, v0, :cond_1

    return-void

    .line 443
    :cond_1
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnDefaultRoute:Z

    .line 444
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleTrafficStatsPollConditionChanged()V

    return-void
.end method

.method private handleDrsOrRatChanged(Landroid/os/AsyncResult;)V
    .locals 2

    .line 458
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/util/Pair;

    .line 459
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DrsOrRatChanged dataRegState "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " rilRat "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->logd(Ljava/lang/String;)V

    .line 460
    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-virtual {p1}, Lcom/android/internal/telephony/TelephonyFacade;->getElapsedSinceBootMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastDrsOrRatChangeTimeMs:J

    return-void
.end method

.method private handleModemActivityReturned(Landroid/telephony/ModemActivityInfo;)V
    .locals 0

    .line 567
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateBandwidthTxRxSamples(Landroid/telephony/ModemActivityInfo;)V

    .line 568
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateTxRxBandwidthFilterSendToDataConnection()V

    .line 569
    iput-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

    .line 571
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->resetByteDeltaAcc()V

    return-void
.end method

.method private handleScreenStateChanged(Z)V
    .locals 1

    .line 425
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mScreenOn:Z

    if-ne v0, p1, :cond_0

    return-void

    .line 428
    :cond_0
    iput-boolean p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mScreenOn:Z

    .line 429
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleTrafficStatsPollConditionChanged()V

    return-void
.end method

.method private handleSignalStrengthChanged(Landroid/telephony/SignalStrength;)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    .line 953
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/SignalStrength;->getDbm()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalStrengthDbm:I

    .line 954
    invoke-virtual {p1}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalLevel:I

    .line 955
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateByteCountThr()V

    .line 956
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateDataRatCellIdentityBandwidth()Z

    move-result p1

    if-eqz p1, :cond_1

    return-void

    .line 960
    :cond_1
    iget p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateSignalDbm:I

    iget v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalStrengthDbm:I

    sub-int/2addr p1, v0

    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result p1

    const/4 v0, 0x6

    if-le p1, v0, :cond_2

    .line 961
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateTxRxBandwidthFilterSendToDataConnection()V

    :cond_2
    return-void
.end method

.method private handleTrafficStatsPoll()V
    .locals 16

    move-object/from16 v0, p0

    .line 480
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->invalidateTxRxSamples()V

    .line 481
    iget-object v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-virtual {v1}, Lcom/android/internal/telephony/TelephonyFacade;->getMobileTxBytes()J

    move-result-wide v1

    .line 482
    iget-object v3, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-virtual {v3}, Lcom/android/internal/telephony/TelephonyFacade;->getMobileRxBytes()J

    move-result-wide v3

    .line 483
    iget-wide v5, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastMobileTxBytes:J

    sub-long v5, v1, v5

    .line 484
    iget-wide v7, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastMobileRxBytes:J

    sub-long v7, v3, v7

    const-wide/16 v9, 0x0

    cmp-long v11, v5, v9

    const/4 v12, 0x2

    if-lez v11, :cond_0

    cmp-long v15, v7, v9

    if-lez v15, :cond_0

    const/4 v15, 0x3

    goto :goto_0

    :cond_0
    cmp-long v15, v7, v9

    if-lez v15, :cond_1

    const/4 v15, 0x1

    goto :goto_0

    :cond_1
    if-lez v11, :cond_2

    move v15, v12

    goto :goto_0

    :cond_2
    const/4 v15, 0x0

    .line 497
    :goto_0
    iget v13, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataActivity:I

    if-eq v13, v15, :cond_3

    .line 498
    iput v15, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataActivity:I

    .line 499
    iget-object v13, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLinkBandwidthEstimatorCallbacks:Ljava/util/Set;

    new-instance v14, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda0;

    invoke-direct {v14, v15}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda0;-><init>(I)V

    invoke-interface {v13, v14}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :cond_3
    const-wide/16 v13, 0x3e8

    .line 504
    invoke-virtual {v0, v12, v13, v14}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    .line 506
    iput-wide v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastMobileTxBytes:J

    .line 507
    iput-wide v3, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastMobileRxBytes:J

    if-ltz v11, :cond_4

    cmp-long v1, v7, v9

    if-ltz v1, :cond_4

    const/4 v1, 0x1

    goto :goto_1

    :cond_4
    const/4 v1, 0x0

    .line 511
    :goto_1
    iget-boolean v2, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastTrafficValid:Z

    if-eqz v2, :cond_a

    if-nez v1, :cond_5

    goto/16 :goto_4

    .line 517
    :cond_5
    iget-wide v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxBytesDeltaAcc:J

    add-long/2addr v1, v5

    iput-wide v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxBytesDeltaAcc:J

    .line 518
    iget-wide v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxBytesDeltaAcc:J

    add-long/2addr v1, v7

    iput-wide v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxBytesDeltaAcc:J

    .line 522
    iget-object v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v1, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mByteDeltaAccThr:I

    div-int/lit8 v1, v1, 0x8

    const/16 v2, 0x4e20

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    int-to-long v3, v1

    .line 524
    iget-object v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v1, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mByteDeltaAccThr:I

    div-int/lit8 v1, v1, 0x8

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    int-to-long v1, v1

    cmp-long v3, v5, v3

    if-gez v3, :cond_6

    cmp-long v1, v7, v1

    if-gez v1, :cond_6

    .line 526
    iget-wide v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxBytesDeltaAcc:J

    iget-object v3, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v3, v3, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mByteDeltaAccThr:I

    int-to-long v3, v3

    cmp-long v1, v1, v3

    if-gez v1, :cond_6

    iget-wide v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxBytesDeltaAcc:J

    iget-object v3, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v3, v3, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mByteDeltaAccThr:I

    int-to-long v3, v3

    cmp-long v1, v1, v3

    if-gez v1, :cond_6

    const/4 v13, 0x0

    goto :goto_2

    :cond_6
    const/4 v13, 0x1

    .line 532
    :goto_2
    iget-object v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-virtual {v1}, Lcom/android/internal/telephony/TelephonyFacade;->getElapsedSinceBootMillis()J

    move-result-wide v1

    .line 533
    iget-wide v3, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemPollTimeMs:J

    sub-long v3, v1, v3

    const-wide/16 v9, 0x1388

    cmp-long v3, v3, v9

    if-gez v3, :cond_7

    const/4 v14, 0x0

    goto :goto_3

    :cond_7
    move v14, v13

    :goto_3
    if-eqz v14, :cond_8

    .line 539
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "txByteDelta "

    .line 540
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " rxByteDelta "

    .line 541
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " txByteDeltaAcc "

    .line 542
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxBytesDeltaAcc:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " rxByteDeltaAcc "

    .line 543
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxBytesDeltaAcc:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, " trigger modem activity request"

    .line 544
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 540
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->logd(Ljava/lang/String;)V

    .line 545
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateDataRatCellIdentityBandwidth()Z

    .line 547
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->makeRequestModemActivity()V

    return-void

    .line 551
    :cond_8
    iget-wide v3, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mFilterUpdateTimeMs:J

    sub-long/2addr v1, v3

    const-wide/16 v3, 0x13ec

    cmp-long v1, v1, v3

    if-ltz v1, :cond_9

    .line 554
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateDataRatCellIdentityBandwidth()Z

    move-result v1

    if-nez v1, :cond_9

    .line 555
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateTxRxBandwidthFilterSendToDataConnection()V

    :cond_9
    return-void

    .line 512
    :cond_a
    :goto_4
    iput-boolean v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastTrafficValid:Z

    .line 513
    sget-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->TAG:Ljava/lang/String;

    const-string v1, " run into invalid traffic count"

    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private handleTrafficStatsPollConditionChanged()V
    .locals 1

    const/4 v0, 0x2

    .line 464
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 465
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mScreenOn:Z

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnDefaultRoute:Z

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mIsOnActiveData:Z

    if-eqz v0, :cond_0

    .line 466
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateDataRatCellIdentityBandwidth()Z

    .line 467
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleTrafficStatsPoll()V

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 472
    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataActivity:I

    .line 473
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLinkBandwidthEstimatorCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :goto_0
    return-void
.end method

.method private hasRecentDataRegStatePlmnOrRatChange()Z
    .locals 6

    .line 632
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 635
    :cond_0
    iget-wide v2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastDrsOrRatChangeTimeMs:J

    invoke-virtual {v0}, Landroid/telephony/ModemActivityInfo;->getTimestampMillis()J

    move-result-wide v4

    cmp-long v0, v2, v4

    if-gtz v0, :cond_1

    iget-wide v2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastPlmnOrRatChangeTimeMs:J

    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

    .line 636
    invoke-virtual {p0}, Landroid/telephony/ModemActivityInfo;->getTimestampMillis()J

    move-result-wide v4

    cmp-long p0, v2, v4

    if-lez p0, :cond_2

    :cond_1
    const/4 v1, 0x1

    :cond_2
    return v1
.end method

.method private static initAvgBwPerRatTable()V
    .locals 10

    .line 235
    sget-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->AVG_BW_PER_RAT:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    const-string v5, ":"

    .line 238
    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v4

    .line 239
    array-length v5, v4

    const/4 v6, 0x2

    if-ne v5, v6, :cond_1

    const/4 v5, 0x1

    .line 240
    aget-object v7, v4, v5

    const-string v8, ","

    invoke-virtual {v7, v8}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v7

    .line 241
    array-length v8, v7

    const/16 v9, 0xe

    if-ne v8, v6, :cond_0

    .line 243
    :try_start_0
    aget-object v6, v7, v2

    invoke-static {v6}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v6
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    .line 244
    :try_start_1
    aget-object v5, v7, v5

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v9
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_0
    move v6, v9

    :catch_1
    :goto_1
    move v5, v9

    move v9, v6

    goto :goto_2

    :cond_0
    move v5, v9

    .line 248
    :goto_2
    sget-object v6, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->AVG_BW_PER_RAT_MAP:Ljava/util/Map;

    aget-object v4, v4, v2

    new-instance v7, Landroid/util/Pair;

    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-direct {v7, v8, v5}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    invoke-interface {v6, v4, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return-void
.end method

.method private invalidateTxRxSamples()V
    .locals 2

    .line 580
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mBwSampleValid:Z

    .line 581
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iput-boolean v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mBwSampleValid:Z

    return-void
.end method

.method private isNrNsaConnected()Z
    .locals 1

    .line 1018
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrState()I

    move-result p0

    const/4 v0, 0x3

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isScreenOn()Z
    .locals 5

    .line 406
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "display"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/hardware/display/DisplayManager;

    .line 408
    invoke-virtual {p0}, Landroid/hardware/display/DisplayManager;->getDisplays()[Landroid/view/Display;

    move-result-object p0

    const/4 v0, 0x0

    if-eqz p0, :cond_1

    .line 411
    array-length v1, p0

    move v2, v0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, p0, v2

    .line 414
    invoke-virtual {v3}, Landroid/view/Display;->getState()I

    move-result v3

    const/4 v4, 0x2

    if-ne v3, v4, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return v0
.end method

.method private isValidNetwork()Z
    .locals 2

    .line 674
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$handleTrafficStatsPoll$2(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;I)V
    .locals 0

    .line 500
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;->onDataActivityChanged(I)V

    return-void
.end method

.method private static synthetic lambda$handleTrafficStatsPoll$3(ILcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 1

    .line 499
    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda1;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;I)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$handleTrafficStatsPollConditionChanged$0(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 474
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;->onDataActivityChanged(I)V

    return-void
.end method

.method private static synthetic lambda$handleTrafficStatsPollConditionChanged$1(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 1

    .line 473
    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$sendLinkBandwidthToDataConnection$4(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;II)V
    .locals 0

    .line 945
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;->onBandwidthChanged(II)V

    return-void
.end method

.method private static synthetic lambda$sendLinkBandwidthToDataConnection$5(IILcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 1

    .line 944
    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda4;

    invoke-direct {v0, p2, p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;II)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private lookupNetwork(Ljava/lang/String;Ljava/lang/String;)Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;
    .locals 1

    const/4 v0, -0x1

    .line 1194
    invoke-virtual {p0, p1, v0, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->lookupNetwork(Ljava/lang/String;ILjava/lang/String;)Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    move-result-object p0

    return-object p0
.end method

.method private makeRequestModemActivity()V
    .locals 2

    .line 561
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-virtual {v0}, Lcom/android/internal/telephony/TelephonyFacade;->getElapsedSinceBootMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemPollTimeMs:J

    .line 563
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    new-instance v1, Lcom/android/internal/telephony/data/DataServiceManager$$ExternalSyntheticLambda0;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataServiceManager$$ExternalSyntheticLambda0;-><init>()V

    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mOutcomeReceiver:Landroid/os/OutcomeReceiver;

    invoke-virtual {v0, v1, p0}, Landroid/telephony/TelephonyManager;->requestModemActivityInfo(Ljava/util/concurrent/Executor;Landroid/os/OutcomeReceiver;)V

    return-void
.end method

.method private registerNrStateFrequencyChange()V
    .locals 3

    .line 966
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    const/4 v1, 0x7

    const/4 v2, 0x0

    invoke-virtual {v0, p0, v1, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNrStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 968
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    const/4 v1, 0x6

    invoke-virtual {v0, p0, v1, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNrFrequencyChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method private resetBandwidthFilter()V
    .locals 1

    .line 935
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-static {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mresetBandwidthFilter(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;)V

    .line 936
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-static {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mresetBandwidthFilter(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;)V

    return-void
.end method

.method private resetByteDeltaAcc()V
    .locals 2

    const-wide/16 v0, 0x0

    .line 575
    iput-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxBytesDeltaAcc:J

    .line 576
    iput-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxBytesDeltaAcc:J

    return-void
.end method

.method private sendLinkBandwidthToDataConnection(II)V
    .locals 4

    .line 940
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "send to DC tx "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " rx "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->logv(Ljava/lang/String;)V

    .line 941
    new-instance v0, Landroid/util/Pair;

    .line 942
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-direct {v0, v1, v2}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 943
    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v2, Landroid/os/AsyncResult;

    const/4 v3, 0x0

    invoke-direct {v2, v3, v0, v3}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    .line 944
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLinkBandwidthEstimatorCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda2;

    invoke-direct {v0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$$ExternalSyntheticLambda2;-><init>(II)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method private updateBandwidthTxRxSamples(Landroid/telephony/ModemActivityInfo;)V
    .locals 8

    .line 585
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

    if-eqz v0, :cond_4

    if-eqz p1, :cond_4

    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    if-eqz v0, :cond_4

    .line 586
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->hasRecentDataRegStatePlmnOrRatChange()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_2

    .line 590
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

    invoke-virtual {v0}, Landroid/telephony/ModemActivityInfo;->getTimestampMillis()J

    move-result-wide v0

    .line 591
    invoke-virtual {p1}, Landroid/telephony/ModemActivityInfo;->getTimestampMillis()J

    move-result-wide v2

    sub-long/2addr v2, v0

    const-wide/16 v0, 0x2710

    cmp-long v0, v2, v0

    if-gtz v0, :cond_4

    const-wide/16 v0, 0x0

    cmp-long v0, v2, v0

    if-gtz v0, :cond_1

    goto/16 :goto_2

    .line 597
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastModemActivityInfo:Landroid/telephony/ModemActivityInfo;

    invoke-virtual {v0, p1}, Landroid/telephony/ModemActivityInfo;->getDelta(Landroid/telephony/ModemActivityInfo;)Landroid/telephony/ModemActivityInfo;

    move-result-object p1

    .line 598
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getModemTxTimeMs(Landroid/telephony/ModemActivityInfo;)J

    move-result-wide v0

    .line 599
    invoke-virtual {p1}, Landroid/telephony/ModemActivityInfo;->getReceiveTimeMillis()J

    move-result-wide v2

    const-wide/16 v4, 0x2

    mul-long/2addr v4, v0

    const-wide/16 v6, 0x3

    mul-long/2addr v6, v2

    cmp-long p1, v4, v6

    if-lez p1, :cond_2

    const/4 p1, 0x1

    goto :goto_0

    :cond_2
    const/4 p1, 0x0

    :goto_0
    if-eqz p1, :cond_3

    add-long v4, v0, v2

    goto :goto_1

    :cond_3
    move-wide v4, v2

    .line 607
    :goto_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget-wide v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxBytesDeltaAcc:J

    invoke-static {p1, v6, v7, v0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mupdateBandwidthSample(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;JJ)V

    .line 608
    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget-wide v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxBytesDeltaAcc:J

    invoke-static {p1, v6, v7, v4, v5}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mupdateBandwidthSample(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;JJ)V

    .line 610
    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {p1}, Landroid/net/NetworkCapabilities;->getLinkUpstreamBandwidthKbps()I

    move-result p1

    .line 611
    iget-object v4, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {v4}, Landroid/net/NetworkCapabilities;->getLinkDownstreamBandwidthKbps()I

    move-result v4

    .line 613
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "UpdateBwSample"

    .line 614
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " dBm "

    .line 615
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalStrengthDbm:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " level "

    .line 616
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalLevel:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " rat "

    .line 617
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataRatName(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " plmn "

    .line 618
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " tac "

    .line 619
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTac:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " reportedTxKbps "

    .line 620
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " reportedRxKbps "

    .line 621
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " txMs "

    .line 622
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, " rxMs "

    .line 623
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, " txKB "

    .line 624
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxBytesDeltaAcc:J

    const-wide/16 v2, 0x400

    div-long/2addr v0, v2

    invoke-virtual {v5, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, " rxKB "

    .line 625
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxBytesDeltaAcc:J

    div-long/2addr v0, v2

    invoke-virtual {v5, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, " txKBThr "

    .line 626
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget p1, p1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mByteDeltaAccThr:I

    div-int/lit16 p1, p1, 0x400

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " rxKBThr "

    .line 627
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget p1, p1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mByteDeltaAccThr:I

    div-int/lit16 p1, p1, 0x400

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 628
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 614
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->logd(Ljava/lang/String;)V

    :cond_4
    :goto_2
    return-void
.end method

.method private updateByteCountThr()V
    .locals 1

    .line 928
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-static {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mupdateByteCountThr(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;)V

    .line 929
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-static {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mupdateByteCountThr(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;)V

    return-void
.end method

.method private updateDataRatCellIdentityBandwidth()Z
    .locals 5

    .line 1066
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCurrentCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v0

    .line 1067
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getTac(Landroid/telephony/CellIdentity;)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTac:I

    .line 1070
    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 1071
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    .line 1073
    :cond_0
    invoke-virtual {v0}, Landroid/telephony/CellIdentity;->getPlmn()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 1074
    invoke-virtual {v0}, Landroid/telephony/CellIdentity;->getPlmn()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_1
    const-string v0, ""

    .line 1079
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_3

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    goto :goto_1

    :cond_2
    move v0, v3

    goto :goto_2

    .line 1081
    :cond_3
    :goto_1
    iput-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    move v0, v2

    .line 1085
    :goto_2
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataNri()Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v1

    if-eqz v1, :cond_4

    .line 1087
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v1

    .line 1088
    iget v4, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    if-eq v1, v4, :cond_4

    .line 1090
    iput v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    .line 1091
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateStaticBwValue(I)Z

    .line 1092
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateByteCountThr()V

    move v1, v2

    goto :goto_3

    :cond_4
    move v1, v3

    :goto_3
    if-nez v0, :cond_6

    if-eqz v1, :cond_5

    goto :goto_4

    :cond_5
    move v2, v3

    :cond_6
    :goto_4
    if-eqz v2, :cond_7

    .line 1098
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->resetBandwidthFilter()V

    .line 1099
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateTxRxBandwidthFilterSendToDataConnection()V

    .line 1100
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-virtual {v0}, Lcom/android/internal/telephony/TelephonyFacade;->getElapsedSinceBootMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLastPlmnOrRatChangeTimeMs:J

    :cond_7
    return v2
.end method

.method private updateStaticBwValue(I)Z
    .locals 3

    .line 1026
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getStaticAvgBw(I)Landroid/util/Pair;

    move-result-object p1

    const/4 v0, 0x1

    if-nez p1, :cond_0

    .line 1028
    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    const/16 v1, 0xe

    iput v1, p1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mStaticBwKbps:I

    .line 1029
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iput v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mStaticBwKbps:I

    return v0

    .line 1032
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v1, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mStaticBwKbps:I

    iget-object v2, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    if-ne v1, v2, :cond_2

    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v1, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mStaticBwKbps:I

    iget-object v2, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    .line 1033
    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    if-eq v1, v2, :cond_1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return p0

    .line 1034
    :cond_2
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget-object v2, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    iput v2, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mStaticBwKbps:I

    .line 1035
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget-object p1, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mStaticBwKbps:I

    return v0
.end method

.method private updateStaticBwValueResetFilter()V
    .locals 1

    .line 1052
    iget v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateStaticBwValue(I)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1053
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateByteCountThr()V

    .line 1054
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->resetBandwidthFilter()V

    .line 1055
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateTxRxBandwidthFilterSendToDataConnection()V

    :cond_0
    return-void
.end method

.method private updateTxRxBandwidthFilterSendToDataConnection()V
    .locals 4

    .line 648
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTelephonyFacade:Lcom/android/internal/telephony/TelephonyFacade;

    invoke-virtual {v0}, Lcom/android/internal/telephony/TelephonyFacade;->getElapsedSinceBootMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mFilterUpdateTimeMs:J

    .line 649
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-static {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mupdateBandwidthFilter(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;)V

    .line 650
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-static {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->-$$Nest$mupdateBandwidthFilter(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;)V

    .line 652
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->hasLargeBwChange()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    .line 653
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->hasLargeBwChange()Z

    move-result v0

    if-nez v0, :cond_1

    iget v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateDataRat:I

    iget v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    if-ne v0, v1, :cond_1

    iget v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateSignalLevel:I

    iget v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalLevel:I

    if-ne v0, v1, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdatePlmn:Ljava/lang/String;

    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    .line 656
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    .line 657
    :goto_1
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->isValidNetwork()Z

    move-result v1

    if-eqz v1, :cond_4

    if-eqz v0, :cond_4

    .line 658
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mAvgUsedKbps:I

    const/4 v2, -0x1

    if-gez v1, :cond_2

    move v1, v2

    goto :goto_2

    :cond_2
    iget v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mFilterKbps:I

    :goto_2
    iput v1, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mLastReportedBwKbps:I

    .line 659
    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    iget v3, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mAvgUsedKbps:I

    if-gez v3, :cond_3

    goto :goto_3

    :cond_3
    iget v2, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mFilterKbps:I

    :goto_3
    iput v2, v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mLastReportedBwKbps:I

    .line 660
    iget v0, v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->mLastReportedBwKbps:I

    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->sendLinkBandwidthToDataConnection(II)V

    .line 664
    :cond_4
    iget v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalStrengthDbm:I

    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateSignalDbm:I

    .line 665
    iget v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mSignalLevel:I

    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateSignalLevel:I

    .line 666
    iget v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    iput v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdateDataRat:I

    .line 667
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthUpdatePlmn:Ljava/lang/String;

    .line 669
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->calculateError()V

    .line 670
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mRxState:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$BandwidthState;->calculateError()V

    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 1296
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, " "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 1297
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1298
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "current PLMN "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlmn:Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " TAC "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mTac:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " RAT "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataRat:I

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataRatName(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "all networks visited since device boot"

    .line 1299
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1300
    iget-object p2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkMap:Ljava/util/Map;

    invoke-interface {p2}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    .line 1301
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_0

    .line 1305
    :cond_0
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p0

    .line 1307
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    .line 1309
    :goto_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1310
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->println()V

    .line 1311
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public getDataActivity()I
    .locals 0

    .line 976
    iget p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mDataActivity:I

    return p0
.end method

.method public getDataRatName(I)Ljava/lang/String;
    .locals 0

    .line 983
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getNrMode(I)I

    move-result p0

    invoke-static {p1, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataRatName(II)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getStaticAvgBw(I)Landroid/util/Pair;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 1043
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataRatName(I)Ljava/lang/String;

    move-result-object p0

    .line 1044
    sget-object p1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->AVG_BW_PER_RAT_MAP:Ljava/util/Map;

    invoke-interface {p1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/util/Pair;

    if-nez p1, :cond_0

    .line 1046
    sget-object v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " is not found in Avg BW table"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-object p1
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 320
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    .line 348
    sget-object p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->TAG:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "invalid message "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 345
    :pswitch_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleDrsOrRatChanged(Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 342
    :pswitch_1
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleActivePhoneChanged(I)V

    goto :goto_0

    .line 339
    :pswitch_2
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->updateStaticBwValueResetFilter()V

    goto :goto_0

    .line 334
    :pswitch_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/SignalStrength;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleSignalStrengthChanged(Landroid/telephony/SignalStrength;)V

    goto :goto_0

    .line 331
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkCapabilities;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleDefaultNetworkChanged(Landroid/net/NetworkCapabilities;)V

    goto :goto_0

    .line 328
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/ModemActivityInfo;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleModemActivityReturned(Landroid/telephony/ModemActivityInfo;)V

    goto :goto_0

    .line 325
    :pswitch_6
    invoke-direct {p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleTrafficStatsPoll()V

    goto :goto_0

    .line 322
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->handleScreenStateChanged(Z)V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method logd(Ljava/lang/String;)V
    .locals 0

    .line 1143
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method logv(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public lookupNetwork(Ljava/lang/String;ILjava/lang/String;)Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    if-eqz p1, :cond_2

    const/4 v0, 0x0

    .line 1202
    invoke-static {v0}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v0

    .line 1201
    invoke-virtual {p3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 1205
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkKey;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkKey;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    .line 1206
    iget-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkMap:Ljava/util/Map;

    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    if-nez p1, :cond_1

    .line 1208
    new-instance p1, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkKey;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, p0, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;Ljava/lang/String;)V

    .line 1209
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mNetworkMap:Ljava/util/Map;

    invoke-interface {p0, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    return-object p1

    .line 1203
    :cond_2
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mPlaceholderNetwork:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;

    return-object p0
.end method

.method public registerCallback(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 0

    .line 386
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLinkBandwidthEstimatorCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public registerForBandwidthChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 365
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 366
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    return-void
.end method

.method public unregisterCallback(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V
    .locals 0

    .line 395
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mLinkBandwidthEstimatorCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public unregisterForBandwidthChanged(Landroid/os/Handler;)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 377
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method
