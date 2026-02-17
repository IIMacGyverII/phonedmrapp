.class Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;
.super Ljava/lang/Object;
.source "RcsStats.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/RcsStats;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "SipMessageArray"
.end annotation


# instance fields
.field private mCallId:Ljava/lang/String;

.field private mDirection:I

.field private mMethod:Ljava/lang/String;

.field final synthetic this$0:Lcom/android/internal/telephony/metrics/RcsStats;


# direct methods
.method static bridge synthetic -$$Nest$fgetmCallId(Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->mCallId:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDirection(Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->mDirection:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmMethod(Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->mMethod:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$maddSipMessageStat(Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;ILjava/lang/String;III)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->addSipMessageStat(ILjava/lang/String;III)V

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/metrics/RcsStats;Ljava/lang/String;ILjava/lang/String;)V
    .locals 0

    .line 727
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 728
    iput-object p2, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->mMethod:Ljava/lang/String;

    .line 729
    iput-object p4, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->mCallId:Ljava/lang/String;

    .line 730
    iput p3, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->mDirection:I

    return-void
.end method

.method private declared-synchronized addSipMessageStat(ILjava/lang/String;III)V
    .locals 2

    monitor-enter p0

    .line 736
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->getCarrierId(I)I

    move-result v0

    .line 737
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/metrics/RcsStats;->isValidCarrierId(I)Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v1, :cond_0

    .line 738
    monitor-exit p0

    return-void

    .line 740
    :cond_0
    :try_start_1
    new-instance v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;-><init>()V

    .line 741
    iput v0, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->carrierId:I

    .line 742
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->getSlotId(I)I

    move-result p1

    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->slotId:I

    .line 743
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/RcsStats;->convertMessageTypeToValue(Ljava/lang/String;)I

    move-result p1

    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageMethod:I

    .line 744
    iput p3, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageResponse:I

    .line 745
    iput p4, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageDirection:I

    .line 746
    iput p5, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->messageError:I

    const/4 p1, 0x1

    .line 747
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->count:I

    .line 748
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipMessageArray;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/RcsStats;->-$$Nest$fgetmAtomsStorage(Lcom/android/internal/telephony/metrics/RcsStats;)Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object p1

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addSipMessageResponse(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 749
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
