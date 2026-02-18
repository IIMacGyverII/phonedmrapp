.class Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;
.super Ljava/lang/Object;
.source "RcsStats.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/RcsStats;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "LastSipDelegateStat"
.end annotation


# instance fields
.field public mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

.field public mSubId:I

.field private mSupportedTags:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field final synthetic this$0:Lcom/android/internal/telephony/metrics/RcsStats;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/metrics/RcsStats;ILjava/util/Set;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 339
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 340
    iput p2, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mSubId:I

    .line 341
    iput-object p3, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mSupportedTags:Ljava/util/Set;

    return-void
.end method

.method private getDefaultSipDelegateStat(I)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;
    .locals 2

    .line 383
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;-><init>()V

    .line 384
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->-$$Nest$sfgetRANDOM()Ljava/util/Random;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/Random;->nextInt()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->dimension:I

    .line 385
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->getCarrierId(I)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->carrierId:I

    .line 386
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->getSlotId(I)I

    move-result p0

    iput p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->slotId:I

    return-object v0
.end method


# virtual methods
.method public compare(ILjava/util/Set;)Z
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)Z"
        }
    .end annotation

    .line 371
    iget v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mSubId:I

    const/4 v1, 0x0

    if-ne p1, v0, :cond_3

    if-eqz p2, :cond_3

    invoke-interface {p2}, Ljava/util/Set;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_0

    .line 374
    :cond_0
    invoke-interface {p2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/String;

    .line 375
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mSupportedTags:Ljava/util/Set;

    invoke-interface {v0, p2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_1

    return v1

    :cond_2
    const/4 p0, 0x1

    return p0

    :cond_3
    :goto_0
    return v1
.end method

.method public conclude(J)V
    .locals 5

    .line 359
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->uptimeMillis:J

    sub-long v1, p1, v1

    const-wide/16 v3, 0x3e8

    cmp-long v3, v1, v3

    if-gez v3, :cond_0

    .line 361
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "concludeSipDelegateStat: discarding transient stats, duration= "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/RcsStats;->logd(Ljava/lang/String;)V

    goto :goto_0

    .line 364
    :cond_0
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->uptimeMillis:J

    .line 365
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-static {v0}, Lcom/android/internal/telephony/metrics/RcsStats;->-$$Nest$fgetmAtomsStorage(Lcom/android/internal/telephony/metrics/RcsStats;)Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/RcsStats;->-$$Nest$smcopyOf(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addSipDelegateStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)V

    .line 367
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iput-wide p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->uptimeMillis:J

    return-void
.end method

.method public createSipDelegateStat(I)V
    .locals 2

    .line 345
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->getDefaultSipDelegateStat(I)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    .line 346
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/RcsStats;->getWallTimeMillis()J

    move-result-wide v0

    iput-wide v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->uptimeMillis:J

    .line 347
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    const/4 p1, -0x1

    iput p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->destroyReason:I

    return-void
.end method

.method public isDestroyed()Z
    .locals 1

    .line 355
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iget p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->destroyReason:I

    const/4 v0, -0x1

    if-le p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public setSipDelegateDestroyReason(I)V
    .locals 0

    .line 351
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$LastSipDelegateStat;->mLastStat:Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iput p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->destroyReason:I

    return-void
.end method
