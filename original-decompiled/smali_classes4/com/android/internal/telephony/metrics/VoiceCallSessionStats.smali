.class public Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;
.super Ljava/lang/Object;
.source "VoiceCallSessionStats.java"


# static fields
.field private static final CALL_DURATION_FIVE_MINUTES:I = 0x493e0

.field private static final CALL_DURATION_MAP:Landroid/util/SparseIntArray;

.field private static final CALL_DURATION_ONE_HOUR:I = 0x36ee80

.field private static final CALL_DURATION_ONE_MINUTE:I = 0xea60

.field private static final CALL_DURATION_TEN_MINUTES:I = 0x927c0

.field private static final CALL_DURATION_THIRTY_MINUTES:I = 0x1b7740

.field private static final CALL_SETUP_DURATION_EXTREMELY_FAST:I = 0x190

.field private static final CALL_SETUP_DURATION_FAST:I = 0x5dc

.field private static final CALL_SETUP_DURATION_MAP:Landroid/util/SparseIntArray;

.field private static final CALL_SETUP_DURATION_NORMAL:I = 0x9c4

.field private static final CALL_SETUP_DURATION_SLOW:I = 0xfa0

.field private static final CALL_SETUP_DURATION_ULTRA_FAST:I = 0x2bc

.field private static final CALL_SETUP_DURATION_ULTRA_SLOW:I = 0x2710

.field private static final CALL_SETUP_DURATION_UNKNOWN:I = 0x0

.field private static final CALL_SETUP_DURATION_VERY_FAST:I = 0x3e8

.field private static final CALL_SETUP_DURATION_VERY_SLOW:I = 0x1770

.field private static final CODEC_QUALITY_COUNT:I = 0x5

.field private static final CS_CODEC_MAP:Landroid/util/SparseIntArray;

.field private static final IMS_CODEC_MAP:Landroid/util/SparseIntArray;

.field private static final MAIN_CODEC_QUALITY_THRESHOLD:I = 0x46

.field private static final TAG:Ljava/lang/String; = "VoiceCallSessionStats"


# instance fields
.field private final mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

.field private final mCallProtos:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;",
            ">;"
        }
    .end annotation
.end field

.field private final mCodecUsage:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/util/LongSparseArray<",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mPhoneId:I

.field private final mRatUsage:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

.field private final mUiccController:Lcom/android/internal/telephony/uicc/UiccController;


# direct methods
.method public static synthetic $r8$lambda$PR4s0xU97skEthjdr2br7KZ7rAs(Lcom/android/internal/telephony/Connection;)I
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result p0

    return p0
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 123
    invoke-static {}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->buildGsmCdmaCodecMap()Landroid/util/SparseIntArray;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->CS_CODEC_MAP:Landroid/util/SparseIntArray;

    .line 126
    invoke-static {}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->buildImsCodecMap()Landroid/util/SparseIntArray;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->IMS_CODEC_MAP:Landroid/util/SparseIntArray;

    .line 129
    invoke-static {}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->buildCallSetupDurationMap()Landroid/util/SparseIntArray;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->CALL_SETUP_DURATION_MAP:Landroid/util/SparseIntArray;

    .line 132
    invoke-static {}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->buildCallDurationMap()Landroid/util/SparseIntArray;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->CALL_DURATION_MAP:Landroid/util/SparseIntArray;

    return-void
.end method

.method public constructor <init>(ILcom/android/internal/telephony/Phone;)V
    .locals 1

    .line 163
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 138
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    .line 146
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    .line 154
    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mRatUsage:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    .line 160
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getMetricsCollector()Lcom/android/internal/telephony/metrics/MetricsCollector;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getAtomsStorage()Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    .line 161
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    .line 164
    iput p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhoneId:I

    .line 165
    iput-object p2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    return-void
.end method

.method private acceptCall(Lcom/android/internal/telephony/Connection;)V
    .locals 3

    .line 393
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result p1

    .line 394
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->contains(I)Z

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    new-array v0, v1, [Ljava/lang/Object;

    .line 395
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v0, v2

    const-string v1, "acceptCall: resetting setup info, connectionId=%d"

    invoke-static {v1, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 396
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 397
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v0

    iput-wide v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    .line 398
    iput v2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    goto :goto_0

    :cond_0
    new-array p0, v1, [Ljava/lang/Object;

    .line 400
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p0, v2

    const-string p1, "acceptCall: untracked connection, connectionId=%d"

    invoke-static {p1, p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    :goto_0
    return-void
.end method

.method private addCall(Lcom/android/internal/telephony/Connection;)V
    .locals 9

    .line 411
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result v0

    .line 412
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->contains(I)Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_0

    const/4 p0, 0x2

    new-array p0, p0, [Ljava/lang/Object;

    .line 415
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, p0, v3

    aput-object p1, p0, v2

    const-string p1, "addCall: already tracked connection, connectionId=%d, connectionInfo=%s"

    .line 413
    invoke-static {p1, p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    return-void

    .line 418
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getBearer(Lcom/android/internal/telephony/Connection;)I

    move-result v1

    .line 419
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v4

    .line 420
    iget-object v5, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v5, v4}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getVoiceRat(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;)I

    move-result v5

    .line 422
    new-instance v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    invoke-direct {v6}, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;-><init>()V

    .line 424
    iput v1, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtStart:I

    .line 425
    iput v1, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    .line 426
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getDirection(Lcom/android/internal/telephony/Connection;)I

    move-result v7

    iput v7, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->direction:I

    .line 427
    iput v3, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    .line 428
    iput-boolean v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    .line 429
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getDisconnectCause()I

    move-result v2

    iput v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    .line 430
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getPreciseDisconnectCause()I

    move-result v2

    iput v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    .line 431
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getVendorDisconnectCause()Ljava/lang/String;

    move-result-object v2

    iput-object v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    .line 432
    iput v5, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtStart:I

    .line 433
    iput v3, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtConnected:I

    .line 434
    iput v5, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    const-wide/16 v7, 0x0

    .line 435
    iput-wide v7, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    .line 436
    iput-wide v7, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    .line 437
    iget v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhoneId:I

    iput v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->simSlotIndex:I

    .line 438
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->isMultiSim()Z

    move-result v2

    iput-boolean v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiSim:Z

    .line 439
    iget v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhoneId:I

    invoke-static {v2}, Lcom/android/internal/telephony/metrics/SimSlotState;->isEsim(I)Z

    move-result v2

    iput-boolean v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEsim:Z

    .line 440
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v2

    iput v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    .line 441
    iput-boolean v3, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCompleted:Z

    .line 442
    iput-wide v7, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    .line 443
    iput-wide v7, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    .line 444
    iput-boolean v3, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->rttEnabled:Z

    .line 445
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->isEmergencyCall()Z

    move-result v2

    iput-boolean v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEmergency:Z

    if-eqz v4, :cond_1

    .line 446
    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v3

    :cond_1
    iput-boolean v3, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isRoaming:Z

    .line 447
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->isMultiparty()Z

    move-result v2

    iput-boolean v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiparty:Z

    .line 450
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v2

    iput-wide v2, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    .line 453
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getAudioCodec()I

    move-result p1

    invoke-static {v1, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->audioQualityToCodec(II)I

    move-result p1

    if-eqz p1, :cond_2

    const-wide/16 v1, 0x1

    shl-long/2addr v1, p1

    .line 455
    iput-wide v1, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    .line 458
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {p1}, Landroid/util/SparseArray;->size()I

    move-result p1

    iput p1, v6, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtStart:I

    .line 459
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {p1, v0, v6}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 462
    invoke-direct {p0, v4}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->updateRatTracker(Landroid/telephony/ServiceState;)V

    return-void
.end method

.method private static audioQualityToCodec(II)I
    .locals 3

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eq p0, v0, :cond_1

    const/4 v2, 0x2

    if-eq p0, v2, :cond_0

    new-array p1, v0, [Ljava/lang/Object;

    .line 744
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, p1, v1

    const-string p0, "audioQualityToCodec: unknown bearer %d"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    return v1

    .line 742
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->IMS_CODEC_MAP:Landroid/util/SparseIntArray;

    invoke-virtual {p0, p1, v1}, Landroid/util/SparseIntArray;->get(II)I

    move-result p0

    return p0

    .line 740
    :cond_1
    sget-object p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->CS_CODEC_MAP:Landroid/util/SparseIntArray;

    invoke-virtual {p0, p1, v1}, Landroid/util/SparseIntArray;->get(II)I

    move-result p0

    return p0
.end method

.method private static buildCallDurationMap()Landroid/util/SparseIntArray;
    .locals 3

    .line 873
    new-instance v0, Landroid/util/SparseIntArray;

    invoke-direct {v0}, Landroid/util/SparseIntArray;-><init>()V

    const v1, 0xea60

    const/4 v2, 0x1

    .line 875
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const v1, 0x493e0

    const/4 v2, 0x2

    .line 878
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const v1, 0x927c0

    const/4 v2, 0x3

    .line 881
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const v1, 0x1b7740

    const/4 v2, 0x4

    .line 884
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const v1, 0x36ee80

    const/4 v2, 0x5

    .line 887
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    return-object v0
.end method

.method private static buildCallSetupDurationMap()Landroid/util/SparseIntArray;
    .locals 3

    .line 838
    new-instance v0, Landroid/util/SparseIntArray;

    invoke-direct {v0}, Landroid/util/SparseIntArray;-><init>()V

    const/4 v1, 0x0

    .line 840
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x190

    const/4 v2, 0x1

    .line 843
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x2bc

    const/4 v2, 0x2

    .line 846
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x3e8

    const/4 v2, 0x3

    .line 849
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x5dc

    const/4 v2, 0x4

    .line 852
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x9c4

    const/4 v2, 0x5

    .line 855
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0xfa0

    const/4 v2, 0x6

    .line 858
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x1770

    const/4 v2, 0x7

    .line 861
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x2710

    const/16 v2, 0x8

    .line 864
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    return-object v0
.end method

.method private static buildGsmCdmaCodecMap()Landroid/util/SparseIntArray;
    .locals 6

    .line 799
    new-instance v0, Landroid/util/SparseIntArray;

    invoke-direct {v0}, Landroid/util/SparseIntArray;-><init>()V

    const/4 v1, 0x1

    .line 800
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x2

    .line 801
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x3

    const/16 v2, 0x8

    .line 802
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x4

    const/16 v3, 0x9

    .line 803
    invoke-virtual {v0, v1, v3}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v4, 0x5

    const/16 v5, 0xa

    .line 804
    invoke-virtual {v0, v4, v5}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v5, 0x6

    .line 805
    invoke-virtual {v0, v5, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x7

    .line 806
    invoke-virtual {v0, v1, v4}, Landroid/util/SparseIntArray;->put(II)V

    .line 807
    invoke-virtual {v0, v2, v5}, Landroid/util/SparseIntArray;->put(II)V

    .line 808
    invoke-virtual {v0, v3, v1}, Landroid/util/SparseIntArray;->put(II)V

    return-object v0
.end method

.method private static buildImsCodecMap()Landroid/util/SparseIntArray;
    .locals 2

    .line 813
    new-instance v0, Landroid/util/SparseIntArray;

    invoke-direct {v0}, Landroid/util/SparseIntArray;-><init>()V

    const/4 v1, 0x1

    .line 814
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x2

    .line 815
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x3

    .line 816
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x4

    .line 817
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x5

    .line 818
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x6

    .line 819
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/4 v1, 0x7

    .line 820
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x8

    .line 821
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x9

    .line 822
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0xa

    .line 823
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0xb

    .line 824
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0xc

    .line 825
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0xd

    .line 826
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0xe

    .line 827
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0xf

    .line 828
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x10

    .line 829
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x11

    .line 830
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x12

    .line 831
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x13

    .line 832
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    const/16 v1, 0x14

    .line 833
    invoke-virtual {v0, v1, v1}, Landroid/util/SparseIntArray;->put(II)V

    return-object v0
.end method

.method private checkCallSetup(Lcom/android/internal/telephony/Connection;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V
    .locals 6

    .line 543
    iget-wide v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-eqz v0, :cond_0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getCall()Lcom/android/internal/telephony/Call;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->isSetupFinished(Lcom/android/internal/telephony/Call;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 544
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v0

    iget-wide v4, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    sub-long/2addr v0, v4

    long-to-int v0, v0

    iput v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDurationMillis:I

    .line 545
    invoke-static {v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->classifySetupDuration(I)I

    move-result v0

    iput v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    .line 546
    iput-wide v2, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    .line 550
    :cond_0
    iget-boolean v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    if-eqz v0, :cond_1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/Call$State;->ACTIVE:Lcom/android/internal/telephony/Call$State;

    if-ne v0, v1, :cond_1

    const/4 v0, 0x0

    .line 551
    iput-boolean v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    .line 553
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    .line 554
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v1, v0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getVoiceRat(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;)I

    move-result v0

    iput v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtConnected:I

    .line 557
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->resetCodecList(Lcom/android/internal/telephony/Connection;)V

    :cond_1
    return-void
.end method

.method private static classifyCallDuration(J)I
    .locals 4

    const-wide/16 v0, 0x0

    cmp-long v0, p0, v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 764
    :cond_0
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->CALL_DURATION_MAP:Landroid/util/SparseIntArray;

    invoke-virtual {v0}, Landroid/util/SparseIntArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 765
    invoke-virtual {v0, v1}, Landroid/util/SparseIntArray;->keyAt(I)I

    move-result v2

    int-to-long v2, v2

    cmp-long v2, p0, v2

    if-gez v2, :cond_1

    .line 766
    invoke-virtual {v0, v1}, Landroid/util/SparseIntArray;->valueAt(I)I

    move-result p0

    return p0

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x6

    return p0
.end method

.method private static classifySetupDuration(I)I
    .locals 3

    const/4 v0, 0x0

    .line 751
    :goto_0
    sget-object v1, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->CALL_SETUP_DURATION_MAP:Landroid/util/SparseIntArray;

    invoke-virtual {v1}, Landroid/util/SparseIntArray;->size()I

    move-result v2

    if-ge v0, v2, :cond_1

    .line 752
    invoke-virtual {v1, v0}, Landroid/util/SparseIntArray;->keyAt(I)I

    move-result v2

    if-ge p0, v2, :cond_0

    .line 753
    invoke-virtual {v1, v0}, Landroid/util/SparseIntArray;->valueAt(I)I

    move-result p0

    return p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const/16 p0, 0x9

    return p0
.end method

.method private finalizeMainCodecQuality(I)I
    .locals 9

    .line 659
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->contains(I)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 662
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/util/LongSparseArray;

    .line 663
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {v2, p1}, Landroid/util/SparseArray;->delete(I)V

    .line 666
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v2

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {v0, v2, v3, p1}, Landroid/util/LongSparseArray;->put(JLjava/lang/Object;)V

    const/4 p1, 0x5

    new-array p1, p1, [J

    move v2, v1

    move v3, v2

    .line 671
    :goto_0
    invoke-virtual {v0}, Landroid/util/LongSparseArray;->size()I

    move-result v4

    add-int/lit8 v4, v4, -0x1

    if-ge v2, v4, :cond_1

    add-int/lit8 v4, v2, 0x1

    .line 672
    invoke-virtual {v0, v4}, Landroid/util/LongSparseArray;->keyAt(I)J

    move-result-wide v5

    invoke-virtual {v0, v2}, Landroid/util/LongSparseArray;->keyAt(I)J

    move-result-wide v7

    sub-long/2addr v5, v7

    .line 673
    invoke-virtual {v0, v2}, Landroid/util/LongSparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getCodecQuality(I)I

    move-result v2

    .line 674
    aget-wide v7, p1, v2

    add-long/2addr v7, v5

    aput-wide v7, p1, v2

    int-to-long v2, v3

    add-long/2addr v2, v5

    long-to-int v3, v2

    move v2, v4

    goto :goto_0

    .line 677
    :cond_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Time per codec quality = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Ljava/util/Arrays;->toString([J)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-array v0, v1, [Ljava/lang/Object;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    const-wide/16 v4, 0x0

    mul-int/lit8 v3, v3, 0x46

    .line 683
    div-int/lit8 v3, v3, 0x64

    int-to-long v2, v3

    const/4 p0, 0x4

    :goto_1
    if-ltz p0, :cond_3

    .line 685
    aget-wide v6, p1, p0

    add-long/2addr v4, v6

    cmp-long v0, v4, v2

    if-ltz v0, :cond_2

    return p0

    :cond_2
    add-int/lit8 p0, p0, -0x1

    goto :goto_1

    :cond_3
    return v1
.end method

.method private finishCall(I)V
    .locals 3

    .line 467
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    if-nez v0, :cond_0

    const/4 p0, 0x1

    new-array p0, p0, [Ljava/lang/Object;

    const/4 v0, 0x0

    .line 469
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p0, v0

    const-string p1, "finishCall: could not find call to be removed, connectionId=%d"

    invoke-static {p1, p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    return-void

    .line 472
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->delete(I)V

    .line 473
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtEnd:I

    .line 476
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getSignalStrength(I)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->signalStrengthAtEnd:I

    .line 479
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->finalizeMainCodecQuality(I)I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mainCodecQuality:I

    const-wide/16 v1, 0x0

    .line 482
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    .line 485
    iget-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    if-nez p1, :cond_1

    const-string p1, ""

    .line 486
    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    .line 490
    :cond_1
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    if-gtz p1, :cond_2

    .line 491
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    .line 494
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addVoiceCallSession(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V

    .line 497
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->hasCalls()Z

    move-result p1

    if-nez p1, :cond_3

    .line 498
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mRatUsage:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v0

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->conclude(J)V

    .line 499
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mRatUsage:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addVoiceCallRatUsage(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;)V

    .line 500
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mRatUsage:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->clear()V

    :cond_3
    return-void
.end method

.method private finishImsCall(ILandroid/telephony/ims/ImsReasonInfo;J)V
    .locals 2

    .line 579
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const/4 v1, 0x2

    .line 580
    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    .line 581
    iget v1, p2, Landroid/telephony/ims/ImsReasonInfo;->mCode:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    .line 582
    iget v1, p2, Landroid/telephony/ims/ImsReasonInfo;->mExtraCode:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    .line 583
    iget-object p2, p2, Landroid/telephony/ims/ImsReasonInfo;->mExtraMessage:Ljava/lang/String;

    invoke-static {p2}, Lcom/android/internal/telephony/metrics/ImsStats;->filterExtraMessage(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    iput-object p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    .line 584
    invoke-static {p3, p4}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->classifyCallDuration(J)I

    move-result p2

    iput p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->callDuration:I

    .line 585
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->finishCall(I)V

    return-void
.end method

.method private static getBearer(Lcom/android/internal/telephony/Connection;)I
    .locals 3

    .line 600
    invoke-virtual {p0}, Lcom/android/internal/telephony/Connection;->getPhoneType()I

    move-result p0

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v1, 0x2

    if-eq p0, v1, :cond_1

    const/4 v2, 0x5

    if-eq p0, v2, :cond_0

    new-array v0, v0, [Ljava/lang/Object;

    .line 608
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const/4 v1, 0x0

    aput-object p0, v0, v1

    const-string p0, "getBearer: unknown phoneType=%d"

    invoke-static {p0, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    :cond_0
    return v1

    :cond_1
    return v0
.end method

.method private getCodecQuality(I)I
    .locals 0

    packed-switch p1, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/4 p0, 0x4

    return p0

    :pswitch_1
    const/4 p0, 0x3

    return p0

    :pswitch_2
    const/4 p0, 0x2

    return p0

    :pswitch_3
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_3
        :pswitch_2
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_2
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static getConnectionId(Lcom/android/internal/telephony/Connection;)I
    .locals 2

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    .line 782
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/Connection;->getCreateTime()J

    move-result-wide v0

    long-to-int p0, v0

    :goto_0
    return p0
.end method

.method private getConnectionIds()Ljava/util/Set;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 520
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    const/4 v1, 0x0

    .line 521
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2}, Landroid/util/SparseArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_0

    .line 522
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method private static getDirection(Lcom/android/internal/telephony/Connection;)I
    .locals 0

    .line 594
    invoke-virtual {p0}, Lcom/android/internal/telephony/Connection;->isIncoming()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x2

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    :goto_0
    return p0
.end method

.method private getImsConnectionIds()Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 528
    new-instance v0, Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    const/4 v1, 0x0

    .line 529
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2}, Landroid/util/SparseArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 530
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    iget v2, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    const/4 v3, 0x2

    if-ne v2, v3, :cond_0

    .line 532
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method private getServiceState()Landroid/telephony/ServiceState;
    .locals 0

    .line 589
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 590
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method private getSignalStrength(I)I
    .locals 1

    const/16 v0, 0x12

    if-ne p1, v0, :cond_0

    .line 616
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getSignalStrengthWifi()I

    move-result p0

    return p0

    .line 618
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getSignalStrengthCellular()I

    move-result p0

    return p0
.end method

.method private getSignalStrengthCellular()I
    .locals 0

    .line 641
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result p0

    return p0
.end method

.method private getSignalStrengthWifi()I
    .locals 5

    .line 624
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 625
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string/jumbo v0, "wifi"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/net/wifi/WifiManager;

    .line 626
    invoke-virtual {p0}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 629
    invoke-virtual {v0}, Landroid/net/wifi/WifiInfo;->getRssi()I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/net/wifi/WifiManager;->calculateSignalLevel(I)I

    move-result v0

    .line 630
    invoke-virtual {p0}, Landroid/net/wifi/WifiManager;->getMaxSignalLevel()I

    move-result p0

    mul-int/lit8 v2, v0, 0x4

    .line 632
    div-int/2addr v2, p0

    .line 634
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "WiFi level: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " ("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "/"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-array v0, v1, [Ljava/lang/Object;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    move v1, v2

    :cond_0
    return v1
.end method

.method private hasCalls()Z
    .locals 0

    .line 539
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {p0}, Landroid/util/SparseArray;->size()I

    move-result p0

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static isSetupFinished(Lcom/android/internal/telephony/Call;)Z
    .locals 2

    if-eqz p0, :cond_1

    .line 727
    sget-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats$1;->$SwitchMap$com$android$internal$telephony$Call$State:[I

    invoke-virtual {p0}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Enum;->ordinal()I

    move-result p0

    aget p0, v0, p0

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    const/4 v1, 0x2

    if-eq p0, v1, :cond_0

    goto :goto_0

    :cond_0
    return v0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private static varargs logd(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 1

    .line 791
    sget-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->TAG:Ljava/lang/String;

    invoke-static {p0, p1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static varargs loge(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 1

    .line 795
    sget-object v0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->TAG:Ljava/lang/String;

    invoke-static {p0, p1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private resetCodecList(Lcom/android/internal/telephony/Connection;)V
    .locals 4

    .line 646
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result p1

    .line 647
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/util/LongSparseArray;

    if-eqz v0, :cond_0

    .line 649
    invoke-virtual {v0}, Landroid/util/LongSparseArray;->size()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    invoke-virtual {v0, v1}, Landroid/util/LongSparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 650
    new-instance v1, Landroid/util/LongSparseArray;

    invoke-direct {v1}, Landroid/util/LongSparseArray;-><init>()V

    .line 651
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v2

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v1, v2, v3, v0}, Landroid/util/LongSparseArray;->append(JLjava/lang/Object;)V

    .line 652
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {p0, p1, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :cond_0
    return-void
.end method

.method private setRttStarted(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V
    .locals 5

    .line 505
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result v0

    .line 506
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez p0, :cond_0

    new-array p0, v2, [Ljava/lang/Object;

    .line 508
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p0, v1

    const-string p1, "onRttStarted: untracked connection, connectionId=%d"

    invoke-static {p1, p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    return-void

    .line 512
    :cond_0
    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtStart:I

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getBearer(Lcom/android/internal/telephony/Connection;)I

    move-result v4

    if-ne v3, v4, :cond_1

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getBearer(Lcom/android/internal/telephony/Connection;)I

    move-result p1

    if-eq v3, p1, :cond_2

    :cond_1
    new-array p1, v2, [Ljava/lang/Object;

    .line 513
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, p1, v1

    const-string v0, "onRttStarted: connection bearer mismatch but proceeding, connectionId=%d"

    invoke-static {v0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 515
    :cond_2
    iput-boolean v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->rttEnabled:Z

    return-void
.end method

.method private updateRatTracker(Landroid/telephony/ServiceState;)V
    .locals 8

    .line 562
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getVoiceRat(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;)I

    move-result v0

    const/4 v7, 0x0

    const/16 v1, 0x12

    if-ne v0, v1, :cond_0

    move p1, v7

    goto :goto_0

    .line 564
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getBand(Landroid/telephony/ServiceState;)I

    move-result p1

    .line 566
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mRatUsage:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v2

    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v4

    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionIds()Ljava/util/Set;

    move-result-object v6

    move v3, v0

    invoke-virtual/range {v1 .. v6}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->add(IIJLjava/util/Set;)V

    .line 567
    :goto_1
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-ge v7, v1, :cond_2

    .line 568
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1, v7}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 569
    iget v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    if-eq v2, v0, :cond_1

    .line 570
    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    const-wide/16 v4, 0x1

    add-long/2addr v2, v4

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    .line 571
    iput v0, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    .line 573
    :cond_1
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bandAtEnd:I

    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    :cond_2
    return-void
.end method


# virtual methods
.method protected getTimeMillis()J
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 787
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    return-wide v0
.end method

.method public declared-synchronized onAudioCodecChanged(Lcom/android/internal/telephony/Connection;I)V
    .locals 5

    monitor-enter p0

    .line 276
    :try_start_0
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result p1

    .line 277
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    if-nez v0, :cond_0

    const-string p2, "onAudioCodecChanged: untracked connection, connectionId=%d"

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    .line 279
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v1

    invoke-static {p2, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 280
    monitor-exit p0

    return-void

    .line 282
    :cond_0
    :try_start_1
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    invoke-static {v1, p2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->audioQualityToCodec(II)I

    move-result p2

    .line 283
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    const-wide/16 v3, 0x1

    shl-long/2addr v3, p2

    or-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    .line 285
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->contains(I)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 286
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/util/LongSparseArray;

    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v0

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {p1, v0, v1, p2}, Landroid/util/LongSparseArray;->append(JLjava/lang/Object;)V

    goto :goto_0

    .line 288
    :cond_1
    new-instance v0, Landroid/util/LongSparseArray;

    invoke-direct {v0}, Landroid/util/LongSparseArray;-><init>()V

    .line 289
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getTimeMillis()J

    move-result-wide v1

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {v0, v1, v2, p2}, Landroid/util/LongSparseArray;->append(JLjava/lang/Object;)V

    .line 290
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCodecUsage:Landroid/util/SparseArray;

    invoke-virtual {p2, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 292
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onCallStateChanged(Lcom/android/internal/telephony/Call;)V
    .locals 4

    monitor-enter p0

    .line 330
    :try_start_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Call;->getConnections()Ljava/util/ArrayList;

    move-result-object p1

    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/Connection;

    .line 331
    invoke-static {v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result v1

    .line 332
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    if-eqz v2, :cond_0

    .line 334
    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->checkCallSetup(Lcom/android/internal/telephony/Connection;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V

    goto :goto_0

    :cond_0
    const-string v0, "onCallStateChanged: untracked connection, connectionId=%d"

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    .line 336
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v3

    invoke-static {v0, v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 339
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onImsAcceptCall(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/Connection;",
            ">;)V"
        }
    .end annotation

    monitor-enter p0

    .line 238
    :try_start_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/Connection;

    .line 239
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->acceptCall(Lcom/android/internal/telephony/Connection;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 241
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onImsCallReceived(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V
    .locals 1

    monitor-enter p0

    .line 230
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->addCall(Lcom/android/internal/telephony/Connection;)V

    .line 231
    invoke-virtual {p1}, Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;->hasRttTextStream()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 232
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->setRttStarted(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 234
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onImsCallTerminated(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 5

    monitor-enter p0

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-nez p1, :cond_1

    .line 247
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getImsConnectionIds()Ljava/util/List;

    move-result-object p1

    .line 248
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v2

    if-ne v2, v0, :cond_0

    const-string v0, "onImsCallTerminated: ending IMS call w/ conn=null"

    new-array v2, v1, [Ljava/lang/Object;

    .line 249
    invoke-static {v0, v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 250
    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    const-wide/16 v0, 0x0

    invoke-direct {p0, p1, p2, v0, v1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->finishImsCall(ILandroid/telephony/ims/ImsReasonInfo;J)V

    goto :goto_0

    :cond_0
    const-string p2, "onImsCallTerminated: %d IMS calls w/ conn=null"

    new-array v0, v0, [Ljava/lang/Object;

    .line 252
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v1

    invoke-static {p2, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_0

    .line 255
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result v2

    .line 256
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v3, v2}, Landroid/util/SparseArray;->contains(I)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 257
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getDurationMillis()J

    move-result-wide v0

    invoke-direct {p0, v2, p2, v0, v1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->finishImsCall(ILandroid/telephony/ims/ImsReasonInfo;J)V

    goto :goto_0

    :cond_2
    const-string v3, "onImsCallTerminated: untracked connection, connectionId=%d"

    new-array v0, v0, [Ljava/lang/Object;

    .line 259
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v0, v1

    invoke-static {v3, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 261
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->addCall(Lcom/android/internal/telephony/Connection;)V

    .line 262
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getDurationMillis()J

    move-result-wide v0

    invoke-direct {p0, v2, p2, v0, v1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->finishImsCall(ILandroid/telephony/ims/ImsReasonInfo;J)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 265
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onImsDial(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V
    .locals 1

    monitor-enter p0

    .line 222
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->addCall(Lcom/android/internal/telephony/Connection;)V

    .line 223
    invoke-virtual {p1}, Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;->hasRttTextStream()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 224
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->setRttStarted(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 226
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onMultipartyChange(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;Z)V
    .locals 6

    monitor-enter p0

    .line 311
    :try_start_0
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result p1

    .line 312
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_0

    const-string p2, "onMultipartyChange: untracked connection, connectionId=%d"

    new-array v0, v2, [Ljava/lang/Object;

    .line 314
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v1

    invoke-static {p2, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 315
    monitor-exit p0

    return-void

    :cond_0
    :try_start_1
    const-string v3, "onMultipartyChange: isMultiparty=%b, connectionId=%d"

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Object;

    .line 317
    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v5

    aput-object v5, v4, v1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v4, v2

    invoke-static {v3, v4}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    if-eqz p2, :cond_1

    .line 319
    iput-boolean v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiparty:Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 321
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onRilAcceptCall(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/Connection;",
            ">;)V"
        }
    .end annotation

    monitor-enter p0

    .line 172
    :try_start_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/Connection;

    .line 173
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->acceptCall(Lcom/android/internal/telephony/Connection;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 175
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onRilCallListChanged(Ljava/util/List;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/GsmCdmaConnection;",
            ">;)V"
        }
    .end annotation

    monitor-enter p0

    .line 186
    :try_start_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/Connection;

    .line 187
    invoke-static {v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result v1

    .line 188
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->contains(I)Z

    move-result v2

    if-nez v2, :cond_2

    .line 190
    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getDisconnectCause()I

    move-result v2

    if-nez v2, :cond_1

    .line 191
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->addCall(Lcom/android/internal/telephony/Connection;)V

    .line 192
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->checkCallSetup(Lcom/android/internal/telephony/Connection;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V

    goto :goto_0

    :cond_1
    const-string v0, "onRilCallListChanged: skip adding disconnected connection, connectionId=%d"

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    .line 197
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v3

    .line 194
    invoke-static {v0, v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_0

    .line 200
    :cond_2
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 202
    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->checkCallSetup(Lcom/android/internal/telephony/Connection;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V

    .line 204
    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getDisconnectCause()I

    move-result v3

    if-eqz v3, :cond_0

    .line 205
    invoke-static {v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getBearer(Lcom/android/internal/telephony/Connection;)I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    .line 206
    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getDisconnectCause()I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    .line 207
    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getPreciseDisconnectCause()I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    .line 208
    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getVendorDisconnectCause()Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    .line 209
    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getDurationMillis()J

    move-result-wide v3

    invoke-static {v3, v4}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->classifyCallDuration(J)I

    move-result v0

    iput v0, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->callDuration:I

    .line 210
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->finishCall(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 216
    :cond_3
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onRilDial(Lcom/android/internal/telephony/Connection;)V
    .locals 0

    monitor-enter p0

    .line 179
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->addCall(Lcom/android/internal/telephony/Connection;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 180
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onRilSrvccStateChanged(I)V
    .locals 6

    monitor-enter p0

    const/4 v0, 0x0

    .line 344
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v1

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    const-string v1, "onRilSrvccStateChanged: ImsPhone is null"

    new-array v3, v2, [Ljava/lang/Object;

    .line 345
    invoke-static {v1, v3}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_0

    .line 347
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getHandoverConnection()Ljava/util/ArrayList;

    move-result-object v0

    :goto_0
    const/4 v1, 0x1

    if-nez v0, :cond_1

    .line 351
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getImsConnectionIds()Ljava/util/List;

    move-result-object v0

    const-string v3, "onRilSrvccStateChanged: ImsPhone has no handover, we have %d"

    new-array v4, v1, [Ljava/lang/Object;

    .line 352
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v2

    invoke-static {v3, v4}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_1

    .line 355
    :cond_1
    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v2, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats$$ExternalSyntheticLambda0;

    invoke-direct {v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats$$ExternalSyntheticLambda0;-><init>()V

    .line 356
    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 357
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    :goto_1
    if-eq p1, v1, :cond_4

    const/4 v1, 0x2

    const-wide/16 v2, 0x1

    if-eq p1, v1, :cond_3

    const/4 v1, 0x3

    if-eq p1, v1, :cond_2

    goto :goto_5

    .line 374
    :cond_2
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 375
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    iget-wide v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    add-long/2addr v4, v2

    iput-wide v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    goto :goto_2

    .line 369
    :cond_3
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_3
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 370
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    iget-wide v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    add-long/2addr v4, v2

    iput-wide v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    goto :goto_3

    .line 362
    :cond_4
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_4
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 363
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v2, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 364
    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCompleted:Z

    .line 365
    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_4

    .line 380
    :cond_5
    :goto_5
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onRttStarted(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V
    .locals 0

    monitor-enter p0

    .line 269
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->setRttStarted(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 270
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onServiceStateChanged(Landroid/telephony/ServiceState;)V
    .locals 1

    monitor-enter p0

    .line 384
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->hasCalls()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 385
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->updateRatTracker(Landroid/telephony/ServiceState;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 387
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onVideoStateChange(Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;I)V
    .locals 6

    monitor-enter p0

    .line 297
    :try_start_0
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->getConnectionId(Lcom/android/internal/telephony/Connection;)I

    move-result p1

    .line 298
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->mCallProtos:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_0

    const-string p2, "onVideoStateChange: untracked connection, connectionId=%d"

    new-array v0, v2, [Ljava/lang/Object;

    .line 300
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v1

    invoke-static {p2, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 301
    monitor-exit p0

    return-void

    :cond_0
    :try_start_1
    const-string v3, "onVideoStateChange: video state=%d, connectionId=%d"

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Object;

    .line 303
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v4, v2

    invoke-static {v3, v4}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    if-eqz p2, :cond_1

    .line 305
    iput-boolean v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->videoEnabled:Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 307
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
