.class public Lcom/android/internal/telephony/RilWakelockInfo;
.super Ljava/lang/Object;
.source "RilWakelockInfo.java"


# annotations
.annotation build Landroid/annotation/TargetApi;
    value = 0x8
.end annotation


# instance fields
.field private final LOG_TAG:Ljava/lang/String;

.field private mConcurrentRequests:I

.field private mLastAggregatedTime:J

.field private mRequestTime:J

.field private mResponseTime:J

.field private mRilRequestSent:I

.field private mTokenNumber:I

.field private mWakelockTimeAttributedSoFar:J


# direct methods
.method constructor <init>(IIIJ)V
    .locals 1

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 27
    const-class v0, Lcom/android/internal/telephony/RilWakelockInfo;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->LOG_TAG:Ljava/lang/String;

    .line 49
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/RilWakelockInfo;->validateConcurrentRequests(I)I

    move-result p3

    .line 50
    iput p1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mRilRequestSent:I

    .line 51
    iput p2, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mTokenNumber:I

    .line 52
    iput p3, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mConcurrentRequests:I

    .line 53
    iput-wide p4, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mRequestTime:J

    const-wide/16 p1, 0x0

    .line 54
    iput-wide p1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mWakelockTimeAttributedSoFar:J

    .line 55
    iput-wide p4, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mLastAggregatedTime:J

    return-void
.end method

.method private validateConcurrentRequests(I)I
    .locals 1

    if-gtz p1, :cond_1

    .line 60
    sget-boolean p1, Lcom/android/internal/telephony/util/TelephonyUtils;->IS_DEBUGGABLE:Z

    if-nez p1, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    .line 61
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "concurrentRequests should always be greater than 0."

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    .line 63
    iget-object p0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->LOG_TAG:Ljava/lang/String;

    invoke-virtual {p1}, Ljava/lang/IllegalArgumentException;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 64
    throw p1

    :cond_1
    :goto_0
    return p1
.end method


# virtual methods
.method public getConcurrentRequests()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 45
    iget p0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mConcurrentRequests:I

    return p0
.end method

.method getRilRequestSent()I
    .locals 0

    .line 77
    iget p0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mRilRequestSent:I

    return p0
.end method

.method getTokenNumber()I
    .locals 0

    .line 73
    iget p0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mTokenNumber:I

    return p0
.end method

.method getWakelockTimeAttributedToClient()J
    .locals 2

    .line 97
    iget-wide v0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mWakelockTimeAttributedSoFar:J

    return-wide v0
.end method

.method setResponseTime(J)V
    .locals 0

    .line 81
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/RilWakelockInfo;->updateTime(J)V

    .line 82
    iput-wide p1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mResponseTime:J

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 102
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "WakelockInfo{rilRequestSent="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mRilRequestSent:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", tokenNumber="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mTokenNumber:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", requestTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mRequestTime:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, ", responseTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mResponseTime:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, ", mWakelockTimeAttributed="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mWakelockTimeAttributedSoFar:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method updateConcurrentRequests(IJ)V
    .locals 0

    .line 86
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/RilWakelockInfo;->validateConcurrentRequests(I)I

    move-result p1

    .line 87
    invoke-virtual {p0, p2, p3}, Lcom/android/internal/telephony/RilWakelockInfo;->updateTime(J)V

    .line 88
    iput p1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mConcurrentRequests:I

    return-void
.end method

.method declared-synchronized updateTime(J)V
    .locals 6

    monitor-enter p0

    .line 92
    :try_start_0
    iget-wide v0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mWakelockTimeAttributedSoFar:J

    iget-wide v2, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mLastAggregatedTime:J

    sub-long v2, p1, v2

    iget v4, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mConcurrentRequests:I

    int-to-long v4, v4

    div-long/2addr v2, v4

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mWakelockTimeAttributedSoFar:J

    .line 93
    iput-wide p1, p0, Lcom/android/internal/telephony/RilWakelockInfo;->mLastAggregatedTime:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 94
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
