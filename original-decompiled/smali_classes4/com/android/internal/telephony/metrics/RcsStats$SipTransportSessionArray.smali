.class Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;
.super Ljava/lang/Object;
.source "RcsStats.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/RcsStats;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "SipTransportSessionArray"
.end annotation


# instance fields
.field private mCallId:Ljava/lang/String;

.field private mDirection:I

.field private mMethod:Ljava/lang/String;

.field private mSipResponse:I

.field final synthetic this$0:Lcom/android/internal/telephony/metrics/RcsStats;


# direct methods
.method static bridge synthetic -$$Nest$fgetmCallId(Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mCallId:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDirection(Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mDirection:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmMethod(Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mMethod:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmSipResponse(Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mSipResponse:I

    return-void
.end method

.method static bridge synthetic -$$Nest$maddSipTransportSessionStat(Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;ILjava/lang/String;IIZ)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->addSipTransportSessionStat(ILjava/lang/String;IIZ)V

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/metrics/RcsStats;Ljava/lang/String;ILjava/lang/String;)V
    .locals 0

    .line 758
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 759
    iput-object p2, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mMethod:Ljava/lang/String;

    .line 760
    iput-object p4, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mCallId:Ljava/lang/String;

    .line 761
    iput p3, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mDirection:I

    const/4 p1, 0x0

    .line 762
    iput p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->mSipResponse:I

    return-void
.end method

.method private declared-synchronized addSipTransportSessionStat(ILjava/lang/String;IIZ)V
    .locals 2

    monitor-enter p0

    .line 768
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->getCarrierId(I)I

    move-result v0

    .line 769
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/metrics/RcsStats;->isValidCarrierId(I)Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v1, :cond_0

    .line 770
    monitor-exit p0

    return-void

    .line 772
    :cond_0
    :try_start_1
    new-instance v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;-><init>()V

    .line 773
    iput v0, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->carrierId:I

    .line 774
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->getSlotId(I)I

    move-result p1

    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->slotId:I

    .line 775
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/RcsStats;->convertMessageTypeToValue(Ljava/lang/String;)I

    move-result p1

    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionMethod:I

    .line 776
    iput p3, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipMessageDirection:I

    .line 777
    iput p4, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipResponse:I

    const/4 p1, 0x1

    .line 778
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionCount:I

    .line 779
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->endedGracefullyCount:I

    .line 780
    iput-boolean p5, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->isEndedGracefully:Z

    .line 781
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/RcsStats;->-$$Nest$fgetmAtomsStorage(Lcom/android/internal/telephony/metrics/RcsStats;)Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object p1

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addCompleteSipTransportSession(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 782
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
