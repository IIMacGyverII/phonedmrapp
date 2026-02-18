.class public Lcom/android/internal/telephony/d2d/DtmfTransport;
.super Ljava/lang/Object;
.source "DtmfTransport.java"

# interfaces
.implements Lcom/android/internal/telephony/d2d/TransportProtocol;


# static fields
.field public static final DMTF_PROBE_MESSAGE:Ljava/lang/String; = "AAD"

.field public static final DMTF_PROTOCOL_VERSION:Ljava/lang/String; = "A"

.field public static final DTMF_MESSAGE_BATERY:Ljava/lang/String; = "C"

.field public static final DTMF_MESSAGE_BATTERY_CHARGING:Ljava/lang/String; = "C"

.field public static final DTMF_MESSAGE_BATTERY_GOOD:Ljava/lang/String; = "B"

.field public static final DTMF_MESSAGE_BATTERY_LOW:Ljava/lang/String; = "A"

.field public static final DTMF_MESSAGE_CODEC:Ljava/lang/String; = "B"

.field public static final DTMF_MESSAGE_CODEC_AMR_NB:Ljava/lang/String; = "C"

.field public static final DTMF_MESSAGE_CODEC_AMR_WB:Ljava/lang/String; = "B"

.field public static final DTMF_MESSAGE_CODEC_EVS:Ljava/lang/String; = "A"

.field public static final DTMF_MESSAGE_DELIMITER:C = 'D'

.field public static final DTMF_MESSAGE_RAT:Ljava/lang/String; = "A"

.field public static final DTMF_MESSAGE_RAT_IWLAN:Ljava/lang/String; = "B"

.field public static final DTMF_MESSAGE_RAT_LTE:Ljava/lang/String; = "A"

.field public static final DTMF_MESSAGE_RAT_NR:Ljava/lang/String; = "C"

.field public static final DTMF_MESSAGE_SERVICE:Ljava/lang/String; = "AA"

.field public static final DTMF_MESSAGE_SERVICE_GOOD:Ljava/lang/String; = "A"

.field public static final DTMF_MESSAGE_SERVICE_POOR:Ljava/lang/String; = "B"

.field public static final DTMF_MESSAGE_START:C = 'A'

.field public static final DTMF_TO_MESSAGE:Lcom/android/internal/telephony/BiMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/android/internal/telephony/BiMap<",
            "Landroid/util/Pair<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Lcom/android/internal/telephony/d2d/Communicator$Message;",
            ">;"
        }
    .end annotation
.end field

.field public static final RECEIVE_STATE_IDLE:I = 0x0

.field public static final RECEIVE_STATE_MESSAGE_TYPE:I = 0x1

.field public static final RECEIVE_STATE_MESSAGE_VALUE:I = 0x2

.field public static final STATE_IDLE:I = 0x0

.field public static final STATE_NEGOTIATED:I = 0x2

.field public static final STATE_NEGOTIATING:I = 0x1

.field public static final STATE_NEGOTIATION_FAILED:I = 0x3


# instance fields
.field private mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

.field private mCharToSend:I

.field private mDigitSendLock:Ljava/lang/Object;

.field private mDigitSendScheduledFuture:Ljava/util/concurrent/ScheduledFuture;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ScheduledFuture<",
            "*>;"
        }
    .end annotation
.end field

.field private mDigitsLock:Ljava/lang/Object;

.field private final mDtmfAdapter:Lcom/android/internal/telephony/d2d/DtmfAdapter;

.field private final mDtmfDurationFuzzMillis:J

.field private mDtmfMessageTimeoutFuture:Ljava/util/concurrent/ScheduledFuture;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ScheduledFuture<",
            "*>;"
        }
    .end annotation
.end field

.field private mDtmfMessageTimeoutLock:Ljava/lang/Object;

.field private final mDurationOfDtmfMessageMillis:J

.field private final mIntervalBetweenDigitsMillis:J

.field private mMessageReceiveState:I

.field private mMessageToSend:[C

.field private mMessageTypeDigits:Ljava/lang/StringBuffer;

.field private mMessageValueDigits:Ljava/lang/StringBuffer;

.field private mNegotiationFuture:Ljava/util/concurrent/ScheduledFuture;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ScheduledFuture<",
            "*>;"
        }
    .end annotation
.end field

.field private mNegotiationLock:Ljava/lang/Object;

.field private final mNegotiationTimeoutMillis:J

.field private final mPendingMessages:Ljava/util/concurrent/ConcurrentLinkedQueue;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentLinkedQueue<",
            "[C>;"
        }
    .end annotation
.end field

.field private mProbeDigits:Ljava/lang/StringBuffer;

.field private mProbeLock:Ljava/lang/Object;

.field private mProtocolVersion:Ljava/lang/String;

.field private mRandom:Ljava/util/Random;

.field private final mScheduledExecutorService:Ljava/util/concurrent/ScheduledExecutorService;

.field private mTransportState:I


# direct methods
.method public static synthetic $r8$lambda$-jzDkKzw99cP01kTpOmr3omj5dI(Lcom/android/internal/telephony/d2d/DtmfTransport;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->lambda$scheduleNegotiationTimeout$1()V

    return-void
.end method

.method public static synthetic $r8$lambda$Rp8FpEmkYNbZoYrQdT-neWA6I7k(Lcom/android/internal/telephony/d2d/DtmfTransport;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->lambda$scheduleDtmfMessageTimeout$2()V

    return-void
.end method

.method public static synthetic $r8$lambda$jbYwl4D3F8su-M6XClYUlaRg7x8(Lcom/android/internal/telephony/d2d/DtmfTransport;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->lambda$maybeScheduleMessageSend$0()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 9

    .line 129
    new-instance v0, Lcom/android/internal/telephony/BiMap;

    invoke-direct {v0}, Lcom/android/internal/telephony/BiMap;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/d2d/DtmfTransport;->DTMF_TO_MESSAGE:Lcom/android/internal/telephony/BiMap;

    .line 133
    new-instance v1, Landroid/util/Pair;

    const-string v2, "A"

    invoke-direct {v1, v2, v2}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v3, Lcom/android/internal/telephony/d2d/Communicator$Message;

    const/4 v4, 0x1

    invoke-direct {v3, v4, v4}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v3}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 136
    new-instance v1, Landroid/util/Pair;

    const-string v3, "B"

    invoke-direct {v1, v2, v3}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v5, Lcom/android/internal/telephony/d2d/Communicator$Message;

    const/4 v6, 0x2

    invoke-direct {v5, v4, v6}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 139
    new-instance v1, Landroid/util/Pair;

    const-string v5, "C"

    invoke-direct {v1, v2, v5}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v7, Lcom/android/internal/telephony/d2d/Communicator$Message;

    const/4 v8, 0x3

    invoke-direct {v7, v4, v8}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v7}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 143
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v3, v2}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v7, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {v7, v6, v4}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v7}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 146
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v3, v3}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v7, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {v7, v6, v6}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v7}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 149
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v3, v5}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v7, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {v7, v6, v8}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v7}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 153
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v5, v2}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v7, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {v7, v8, v4}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v7}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 156
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v5, v3}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v7, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {v7, v8, v6}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v7}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 159
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v5, v5}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v5, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {v5, v8, v8}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 163
    new-instance v1, Landroid/util/Pair;

    const-string v5, "AA"

    invoke-direct {v1, v5, v2}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v2, Lcom/android/internal/telephony/d2d/Communicator$Message;

    const/4 v7, 0x4

    invoke-direct {v2, v7, v6}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 166
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v5, v3}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    new-instance v2, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {v2, v7, v4}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/d2d/DtmfAdapter;Lcom/android/internal/telephony/d2d/Timeouts$Adapter;Ljava/util/concurrent/ScheduledExecutorService;)V
    .locals 2

    .line 221
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 196
    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    .line 198
    new-instance v1, Ljava/lang/StringBuffer;

    invoke-direct {v1}, Ljava/lang/StringBuffer;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeDigits:Ljava/lang/StringBuffer;

    .line 202
    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageReceiveState:I

    .line 203
    new-instance v1, Ljava/lang/StringBuffer;

    invoke-direct {v1}, Ljava/lang/StringBuffer;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    .line 204
    new-instance v1, Ljava/lang/StringBuffer;

    invoke-direct {v1}, Ljava/lang/StringBuffer;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageValueDigits:Ljava/lang/StringBuffer;

    .line 206
    new-instance v1, Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-direct {v1}, Ljava/util/concurrent/ConcurrentLinkedQueue;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mPendingMessages:Ljava/util/concurrent/ConcurrentLinkedQueue;

    .line 208
    new-instance v1, Ljava/lang/Object;

    invoke-direct {v1}, Ljava/lang/Object;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeLock:Ljava/lang/Object;

    .line 209
    new-instance v1, Ljava/lang/Object;

    invoke-direct {v1}, Ljava/lang/Object;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfMessageTimeoutLock:Ljava/lang/Object;

    .line 210
    new-instance v1, Ljava/lang/Object;

    invoke-direct {v1}, Ljava/lang/Object;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitSendLock:Ljava/lang/Object;

    .line 211
    new-instance v1, Ljava/lang/Object;

    invoke-direct {v1}, Ljava/lang/Object;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationLock:Ljava/lang/Object;

    .line 212
    new-instance v1, Ljava/lang/Object;

    invoke-direct {v1}, Ljava/lang/Object;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitsLock:Ljava/lang/Object;

    .line 217
    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCharToSend:I

    .line 218
    new-instance v0, Ljava/util/Random;

    invoke-direct {v0}, Ljava/util/Random;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mRandom:Ljava/util/Random;

    .line 222
    iput-object p1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfAdapter:Lcom/android/internal/telephony/d2d/DtmfAdapter;

    .line 223
    invoke-virtual {p2}, Lcom/android/internal/telephony/d2d/Timeouts$Adapter;->getDtmfMinimumIntervalMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mIntervalBetweenDigitsMillis:J

    .line 224
    invoke-virtual {p2}, Lcom/android/internal/telephony/d2d/Timeouts$Adapter;->getMaxDurationOfDtmfMessageMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDurationOfDtmfMessageMillis:J

    .line 225
    invoke-virtual {p2}, Lcom/android/internal/telephony/d2d/Timeouts$Adapter;->getDtmfDurationFuzzMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfDurationFuzzMillis:J

    .line 226
    invoke-virtual {p2}, Lcom/android/internal/telephony/d2d/Timeouts$Adapter;->getDtmfNegotiationTimeoutMillis()J

    move-result-wide p1

    iput-wide p1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationTimeoutMillis:J

    .line 227
    iput-object p3, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mScheduledExecutorService:Ljava/util/concurrent/ScheduledExecutorService;

    return-void
.end method

.method private cancelNegotiationTimeout()V
    .locals 3

    const-string v0, "cancelNegotiationTimeout"

    const/4 v1, 0x0

    new-array v2, v1, [Ljava/lang/Object;

    .line 413
    invoke-static {p0, v0, v2}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 414
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationLock:Ljava/lang/Object;

    monitor-enter v0

    .line 415
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationFuture:Ljava/util/concurrent/ScheduledFuture;

    if-eqz v2, :cond_0

    .line 416
    invoke-interface {v2, v1}, Ljava/util/concurrent/ScheduledFuture;->cancel(Z)Z

    :cond_0
    const/4 v1, 0x0

    .line 418
    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationFuture:Ljava/util/concurrent/ScheduledFuture;

    .line 419
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private getDtmfDurationFuzzMillis()J
    .locals 4

    .line 298
    iget-wide v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfDurationFuzzMillis:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    return-wide v2

    .line 301
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mRandom:Ljava/util/Random;

    invoke-virtual {v0}, Ljava/util/Random;->nextLong()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfDurationFuzzMillis:J

    rem-long/2addr v0, v2

    return-wide v0
.end method

.method private handleDtmfMessageTimeout()V
    .locals 3

    .line 537
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->maybeCancelDtmfMessageTimeout()V

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 539
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    .line 540
    invoke-virtual {v1}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageValueDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v1}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    const-string v1, "handleDtmfMessageTimeout: timeout receiving DTMF string; got %s/%s so far"

    .line 539
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 542
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->resetIncomingMessage()V

    return-void
.end method

.method private handleDtmfSend()V
    .locals 6

    .line 311
    iget v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCharToSend:I

    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageToSend:[C

    array-length v2, v1

    if-ge v0, v2, :cond_2

    .line 312
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfAdapter:Lcom/android/internal/telephony/d2d/DtmfAdapter;

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v2, :cond_0

    const-string v2, "handleDtmfSend: char=%c"

    new-array v5, v3, [Ljava/lang/Object;

    .line 313
    aget-char v0, v1, v0

    invoke-static {v0}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object v0

    aput-object v0, v5, v4

    invoke-static {p0, v2, v5}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 314
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfAdapter:Lcom/android/internal/telephony/d2d/DtmfAdapter;

    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageToSend:[C

    iget v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCharToSend:I

    aget-char v1, v1, v2

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/d2d/DtmfAdapter;->sendDtmf(C)V

    .line 316
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCharToSend:I

    add-int/2addr v0, v3

    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCharToSend:I

    .line 318
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageToSend:[C

    array-length v1, v1

    if-ne v0, v1, :cond_2

    const-string v0, "handleDtmfSend: done"

    new-array v1, v4, [Ljava/lang/Object;

    .line 319
    invoke-static {p0, v0, v1}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 320
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitSendLock:Ljava/lang/Object;

    monitor-enter v0

    const/4 v1, 0x0

    .line 321
    :try_start_0
    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageToSend:[C

    .line 322
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitSendScheduledFuture:Ljava/util/concurrent/ScheduledFuture;

    invoke-interface {v2, v4}, Ljava/util/concurrent/ScheduledFuture;->cancel(Z)Z

    .line 323
    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitSendScheduledFuture:Ljava/util/concurrent/ScheduledFuture;

    .line 327
    iget v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    const/4 v2, 0x2

    if-ne v1, v2, :cond_1

    .line 328
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->maybeScheduleMessageSend()V

    .line 330
    :cond_1
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    :cond_2
    :goto_0
    return-void
.end method

.method private handleIncomingMessage(Ljava/lang/String;Ljava/lang/String;)V
    .locals 4

    .line 585
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/d2d/DtmfTransport;->extractMessage(Ljava/lang/String;Ljava/lang/String;)Lcom/android/internal/telephony/d2d/Communicator$Message;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x2

    const/4 v3, 0x1

    if-nez v0, :cond_0

    new-array v0, v2, [Ljava/lang/Object;

    aput-object p1, v0, v1

    aput-object p2, v0, v3

    const-string p1, "handleIncomingMessage: msgDigits = %s, msgValueDigits = %s; invalid msg"

    .line 587
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-void

    :cond_0
    new-array v2, v2, [Ljava/lang/Object;

    aput-object p1, v2, v1

    aput-object p2, v2, v3

    const-string p1, "handleIncomingMessage: msgDigits = %s, msgValueDigits = %s"

    .line 591
    invoke-static {p0, p1, v2}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 593
    new-instance p1, Landroid/util/ArraySet;

    invoke-direct {p1, v3}, Landroid/util/ArraySet;-><init>(I)V

    .line 594
    invoke-interface {p1, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 595
    iget-object p0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    if-eqz p0, :cond_1

    .line 596
    invoke-interface {p0, p1}, Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;->onMessagesReceived(Ljava/util/Set;)V

    :cond_1
    return-void
.end method

.method private handleNegotiationTimeout()V
    .locals 2

    const-string v0, "handleNegotiationTimeout: no probe received, negotiation timeout."

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    .line 426
    invoke-static {p0, v0, v1}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 427
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationLock:Ljava/lang/Object;

    monitor-enter v0

    const/4 v1, 0x0

    .line 428
    :try_start_0
    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationFuture:Ljava/util/concurrent/ScheduledFuture;

    .line 429
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 430
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->negotiationFailed()V

    return-void

    :catchall_0
    move-exception p0

    .line 429
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private handleProbeMessage()V
    .locals 5

    .line 373
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeLock:Ljava/lang/Object;

    monitor-enter v0

    .line 374
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v1}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object v1

    .line 375
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v2}, Ljava/lang/StringBuffer;->length()I

    move-result v2

    const/4 v3, 0x0

    if-lez v2, :cond_0

    .line 376
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v2}, Ljava/lang/StringBuffer;->length()I

    move-result v4

    invoke-virtual {v2, v3, v4}, Ljava/lang/StringBuffer;->delete(II)Ljava/lang/StringBuffer;

    .line 378
    :cond_0
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 379
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->cancelNegotiationTimeout()V

    const/16 v0, 0x41

    .line 381
    invoke-static {v0}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    const/16 v0, 0x44

    .line 382
    invoke-static {v0}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 383
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v4, 0x2

    if-le v0, v4, :cond_1

    .line 384
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    sub-int/2addr v0, v2

    invoke-virtual {v1, v2, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProtocolVersion:Ljava/lang/String;

    const-string v0, "handleProbeMessage: got valid probe, remote version %s negotiated."

    new-array v2, v2, [Ljava/lang/Object;

    aput-object v1, v2, v3

    .line 385
    invoke-static {p0, v0, v2}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 387
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->negotiationSucceeded()V

    goto :goto_0

    :cond_1
    const-string v0, "handleProbeMessage: got invalid probe %s - negotiation failed."

    new-array v2, v2, [Ljava/lang/Object;

    aput-object v1, v2, v3

    .line 389
    invoke-static {p0, v0, v2}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 390
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->negotiationFailed()V

    .line 392
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->cancelNegotiationTimeout()V

    return-void

    :catchall_0
    move-exception p0

    .line 378
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private handleReceivedDigit(C)V
    .locals 7

    .line 461
    iget v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageReceiveState:I

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_1

    const/16 v0, 0x41

    if-ne p1, v0, :cond_0

    const-string v0, "handleReceivedDigit: digit = %c ; message timeout started."

    new-array v3, v2, [Ljava/lang/Object;

    .line 464
    invoke-static {p1}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object p1

    aput-object p1, v3, v1

    invoke-static {p0, v0, v3}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 465
    iput v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageReceiveState:I

    .line 466
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->scheduleDtmfMessageTimeout()V

    goto/16 :goto_1

    :cond_0
    const-string v0, "handleReceivedDigit: digit = %c ; unexpected start digit, ignoring."

    new-array v2, v2, [Ljava/lang/Object;

    .line 469
    invoke-static {p1}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object p1

    aput-object p1, v2, v1

    .line 468
    invoke-static {p0, v0, v2}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    goto/16 :goto_1

    :cond_1
    const/16 v3, 0x44

    const/4 v4, 0x2

    if-ne p1, v3, :cond_3

    if-ne v0, v2, :cond_2

    const-string v0, "handleReceivedDigit: digit = %c ; msg = %s ; awaiting value."

    new-array v3, v4, [Ljava/lang/Object;

    .line 473
    invoke-static {p1}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object p1

    aput-object p1, v3, v1

    iget-object p1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    .line 474
    invoke-virtual {p1}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object p1

    aput-object p1, v3, v2

    .line 473
    invoke-static {p0, v0, v3}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 475
    iput v4, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageReceiveState:I

    goto :goto_1

    :cond_2
    if-ne v0, v4, :cond_6

    .line 477
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->maybeCancelDtmfMessageTimeout()V

    .line 480
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitsLock:Ljava/lang/Object;

    monitor-enter v0

    .line 481
    :try_start_0
    iget-object v3, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v3}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object v3

    .line 482
    iget-object v5, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageValueDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v5}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object v5

    .line 483
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v0, "handleReceivedDigit: digit = %c ; msg = %s ; value = %s ; full msg"

    const/4 v6, 0x3

    new-array v6, v6, [Ljava/lang/Object;

    .line 485
    invoke-static {p1}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object p1

    aput-object p1, v6, v1

    aput-object v3, v6, v2

    aput-object v5, v6, v4

    .line 484
    invoke-static {p0, v0, v6}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 486
    invoke-direct {p0, v3, v5}, Lcom/android/internal/telephony/d2d/DtmfTransport;->handleIncomingMessage(Ljava/lang/String;Ljava/lang/String;)V

    .line 487
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->resetIncomingMessage()V

    goto :goto_1

    :catchall_0
    move-exception p0

    .line 483
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0

    .line 490
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitsLock:Ljava/lang/Object;

    monitor-enter v0

    .line 491
    :try_start_2
    iget v3, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageReceiveState:I

    if-ne v3, v2, :cond_4

    .line 492
    iget-object v3, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuffer;->append(C)Ljava/lang/StringBuffer;

    const-string v3, "handleReceivedDigit: typeDigit = %c ; msg = %s"

    new-array v4, v4, [Ljava/lang/Object;

    .line 494
    invoke-static {p1}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object p1

    aput-object p1, v4, v1

    iget-object p1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {p1}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object p1

    aput-object p1, v4, v2

    .line 493
    invoke-static {p0, v3, v4}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_0

    :cond_4
    if-ne v3, v4, :cond_5

    .line 496
    iget-object v3, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageValueDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuffer;->append(C)Ljava/lang/StringBuffer;

    const-string v3, "handleReceivedDigit: valueDigit = %c ; value = %s"

    new-array v4, v4, [Ljava/lang/Object;

    .line 498
    invoke-static {p1}, Ljava/lang/Character;->valueOf(C)Ljava/lang/Character;

    move-result-object p1

    aput-object p1, v4, v1

    iget-object p1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageValueDigits:Ljava/lang/StringBuffer;

    invoke-virtual {p1}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object p1

    aput-object p1, v4, v2

    .line 497
    invoke-static {p0, v3, v4}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 500
    :cond_5
    :goto_0
    monitor-exit v0

    :cond_6
    :goto_1
    return-void

    :catchall_1
    move-exception p0

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    throw p0
.end method

.method private synthetic lambda$maybeScheduleMessageSend$0()V
    .locals 0

    .line 285
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->handleDtmfSend()V

    return-void
.end method

.method private synthetic lambda$scheduleDtmfMessageTimeout$2()V
    .locals 0

    .line 512
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->handleDtmfMessageTimeout()V

    return-void
.end method

.method private synthetic lambda$scheduleNegotiationTimeout$1()V
    .locals 0

    .line 403
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->handleNegotiationTimeout()V

    return-void
.end method

.method private maybeCancelDtmfMessageTimeout()V
    .locals 4

    .line 523
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfMessageTimeoutLock:Ljava/lang/Object;

    monitor-enter v0

    .line 524
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfMessageTimeoutFuture:Ljava/util/concurrent/ScheduledFuture;

    if-eqz v1, :cond_0

    const-string v1, "scheduleDtmfMessageTimeout: timeout pending; cancelling"

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Object;

    .line 525
    invoke-static {p0, v1, v3}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 526
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfMessageTimeoutFuture:Ljava/util/concurrent/ScheduledFuture;

    invoke-interface {v1, v2}, Ljava/util/concurrent/ScheduledFuture;->cancel(Z)Z

    const/4 v1, 0x0

    .line 527
    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfMessageTimeoutFuture:Ljava/util/concurrent/ScheduledFuture;

    .line 529
    :cond_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private maybeScheduleMessageSend()V
    .locals 12

    .line 271
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitSendLock:Ljava/lang/Object;

    monitor-enter v0

    .line 272
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageToSend:[C

    if-nez v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitSendScheduledFuture:Ljava/util/concurrent/ScheduledFuture;

    if-nez v1, :cond_0

    .line 273
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mPendingMessages:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v1}, Ljava/util/concurrent/ConcurrentLinkedQueue;->poll()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [C

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageToSend:[C

    const/4 v2, 0x0

    .line 274
    iput v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCharToSend:I

    if-eqz v1, :cond_0

    const-string v3, "maybeScheduleMessageSend: toSend=%s"

    const/4 v4, 0x1

    new-array v4, v4, [Ljava/lang/Object;

    .line 278
    invoke-static {v1}, Ljava/lang/String;->valueOf([C)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v2

    .line 277
    invoke-static {p0, v3, v4}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 283
    iget-object v5, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mScheduledExecutorService:Ljava/util/concurrent/ScheduledExecutorService;

    new-instance v6, Lcom/android/internal/telephony/d2d/DtmfTransport$$ExternalSyntheticLambda0;

    invoke-direct {v6, p0}, Lcom/android/internal/telephony/d2d/DtmfTransport$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/d2d/DtmfTransport;)V

    iget-wide v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDurationOfDtmfMessageMillis:J

    .line 286
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->getDtmfDurationFuzzMillis()J

    move-result-wide v3

    add-long v7, v1, v3

    iget-wide v9, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mIntervalBetweenDigitsMillis:J

    sget-object v11, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    .line 283
    invoke-interface/range {v5 .. v11}, Ljava/util/concurrent/ScheduledExecutorService;->scheduleAtFixedRate(Ljava/lang/Runnable;JJLjava/util/concurrent/TimeUnit;)Ljava/util/concurrent/ScheduledFuture;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitSendScheduledFuture:Ljava/util/concurrent/ScheduledFuture;

    .line 291
    :cond_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private negotiationFailed()V
    .locals 2

    const/4 v0, 0x3

    .line 437
    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    const-string v1, "notifyNegotiationFailed"

    .line 438
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 439
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    if-eqz v0, :cond_0

    .line 440
    invoke-interface {v0, p0}, Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;->onNegotiationFailed(Lcom/android/internal/telephony/d2d/TransportProtocol;)V

    :cond_0
    return-void
.end method

.method private negotiationSucceeded()V
    .locals 2

    const/4 v0, 0x2

    .line 448
    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    const-string v1, "negotiationSucceeded"

    .line 449
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 450
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    if-eqz v0, :cond_0

    .line 451
    invoke-interface {v0, p0}, Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;->onNegotiationSuccess(Lcom/android/internal/telephony/d2d/TransportProtocol;)V

    :cond_0
    return-void
.end method

.method private resetIncomingMessage()V
    .locals 4

    const/4 v0, 0x0

    .line 604
    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageReceiveState:I

    .line 605
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDigitsLock:Ljava/lang/Object;

    monitor-enter v1

    .line 606
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v2}, Ljava/lang/StringBuffer;->length()I

    move-result v2

    if-eqz v2, :cond_0

    .line 607
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageTypeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v2}, Ljava/lang/StringBuffer;->length()I

    move-result v3

    invoke-virtual {v2, v0, v3}, Ljava/lang/StringBuffer;->delete(II)Ljava/lang/StringBuffer;

    .line 609
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageValueDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v2}, Ljava/lang/StringBuffer;->length()I

    move-result v2

    if-eqz v2, :cond_1

    .line 610
    iget-object p0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mMessageValueDigits:Ljava/lang/StringBuffer;

    invoke-virtual {p0}, Ljava/lang/StringBuffer;->length()I

    move-result v2

    invoke-virtual {p0, v0, v2}, Ljava/lang/StringBuffer;->delete(II)Ljava/lang/StringBuffer;

    .line 612
    :cond_1
    monitor-exit v1

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private scheduleDtmfMessageTimeout()V
    .locals 6

    .line 508
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfMessageTimeoutLock:Ljava/lang/Object;

    monitor-enter v0

    .line 509
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->maybeCancelDtmfMessageTimeout()V

    .line 511
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mScheduledExecutorService:Ljava/util/concurrent/ScheduledExecutorService;

    new-instance v2, Lcom/android/internal/telephony/d2d/DtmfTransport$$ExternalSyntheticLambda2;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/d2d/DtmfTransport$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/d2d/DtmfTransport;)V

    iget-wide v3, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDurationOfDtmfMessageMillis:J

    sget-object v5, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {v1, v2, v3, v4, v5}, Ljava/util/concurrent/ScheduledExecutorService;->schedule(Ljava/lang/Runnable;JLjava/util/concurrent/TimeUnit;)Ljava/util/concurrent/ScheduledFuture;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mDtmfMessageTimeoutFuture:Ljava/util/concurrent/ScheduledFuture;

    .line 515
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private scheduleNegotiationTimeout()V
    .locals 6

    .line 401
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationLock:Ljava/lang/Object;

    monitor-enter v0

    .line 402
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mScheduledExecutorService:Ljava/util/concurrent/ScheduledExecutorService;

    new-instance v2, Lcom/android/internal/telephony/d2d/DtmfTransport$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/d2d/DtmfTransport$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/d2d/DtmfTransport;)V

    iget-wide v3, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationTimeoutMillis:J

    sget-object v5, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-interface {v1, v2, v3, v4, v5}, Ljava/util/concurrent/ScheduledExecutorService;->schedule(Ljava/lang/Runnable;JLjava/util/concurrent/TimeUnit;)Ljava/util/concurrent/ScheduledFuture;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mNegotiationFuture:Ljava/util/concurrent/ScheduledFuture;

    .line 406
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method


# virtual methods
.method public extractMessage(Ljava/lang/String;Ljava/lang/String;)Lcom/android/internal/telephony/d2d/Communicator$Message;
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 576
    sget-object p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->DTMF_TO_MESSAGE:Lcom/android/internal/telephony/BiMap;

    new-instance v0, Landroid/util/Pair;

    invoke-direct {v0, p1, p2}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/d2d/Communicator$Message;

    return-object p0
.end method

.method public forceNegotiated()V
    .locals 0

    return-void
.end method

.method public forceNotNegotiated()V
    .locals 0

    return-void
.end method

.method public getMessageDigits(Lcom/android/internal/telephony/d2d/Communicator$Message;)[C
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 554
    sget-object p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->DTMF_TO_MESSAGE:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/BiMap;->getKey(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/util/Pair;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 558
    :cond_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const/16 v0, 0x41

    .line 559
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 560
    iget-object v0, p0, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v0, Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v0, 0x44

    .line 561
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 562
    iget-object p0, p0, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p0, Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 563
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 564
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->toCharArray()[C

    move-result-object p0

    return-object p0
.end method

.method public getTransportState()I
    .locals 0

    .line 339
    iget p0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    return p0
.end method

.method public onDtmfReceived(C)V
    .locals 5

    const/4 v0, 0x0

    const/16 v1, 0x41

    if-lt p1, v1, :cond_3

    const/16 v1, 0x44

    if-le p1, v1, :cond_0

    goto :goto_1

    .line 353
    :cond_0
    iget v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_1

    .line 354
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeLock:Ljava/lang/Object;

    monitor-enter v2

    .line 355
    :try_start_0
    iget-object v4, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeDigits:Ljava/lang/StringBuffer;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuffer;->append(C)Ljava/lang/StringBuffer;

    .line 356
    monitor-exit v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ne p1, v1, :cond_2

    const-string p1, "onDtmfReceived: received message %s"

    new-array v1, v3, [Ljava/lang/Object;

    .line 359
    iget-object v2, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mProbeDigits:Ljava/lang/StringBuffer;

    aput-object v2, v1, v0

    invoke-static {p0, p1, v1}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 360
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->handleProbeMessage()V

    goto :goto_0

    :catchall_0
    move-exception p0

    .line 356
    :try_start_1
    monitor-exit v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0

    .line 363
    :cond_1
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/d2d/DtmfTransport;->handleReceivedDigit(C)V

    :cond_2
    :goto_0
    return-void

    :cond_3
    :goto_1
    const-string p1, "onDtmfReceived: digit = %c ; invalid digit; not in A-D"

    new-array v0, v0, [Ljava/lang/Object;

    .line 349
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-void
.end method

.method public sendMessages(Ljava/util/Set;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/d2d/Communicator$Message;",
            ">;)V"
        }
    .end annotation

    .line 255
    invoke-interface {p1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/d2d/Communicator$Message;

    .line 256
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->getMessageDigits(Lcom/android/internal/telephony/d2d/Communicator$Message;)[C

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    .line 258
    invoke-static {v0}, Ljava/lang/String;->valueOf([C)Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v2, "sendMessages: queueing message: %s"

    invoke-static {p0, v2, v1}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 260
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mPendingMessages:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v1, v0}, Ljava/util/concurrent/ConcurrentLinkedQueue;->offer(Ljava/lang/Object;)Z

    goto :goto_0

    .line 262
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mPendingMessages:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {p1}, Ljava/util/concurrent/ConcurrentLinkedQueue;->size()I

    move-result p1

    if-lez p1, :cond_2

    .line 263
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->maybeScheduleMessageSend()V

    :cond_2
    return-void
.end method

.method public setCallback(Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;)V
    .locals 0

    .line 232
    iput-object p1, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    return-void
.end method

.method public startNegotiation()V
    .locals 2

    .line 237
    iget v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    new-array v0, v1, [Ljava/lang/Object;

    const-string/jumbo v1, "startNegotiation: can\'t start negotiation as not idle."

    .line 238
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 241
    iput v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mTransportState:I

    new-array v0, v1, [Ljava/lang/Object;

    const-string/jumbo v1, "startNegotiation: starting negotiation."

    .line 242
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 243
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/DtmfTransport;->mPendingMessages:Ljava/util/concurrent/ConcurrentLinkedQueue;

    const-string v1, "AAD"

    invoke-virtual {v1}, Ljava/lang/String;->toCharArray()[C

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/concurrent/ConcurrentLinkedQueue;->offer(Ljava/lang/Object;)Z

    .line 244
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->maybeScheduleMessageSend()V

    .line 245
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/DtmfTransport;->scheduleNegotiationTimeout()V

    return-void
.end method
