.class public final Lcom/android/internal/telephony/NitzSignal;
.super Ljava/lang/Object;
.source "NitzSignal.java"


# instance fields
.field private final mAgeMillis:J

.field private final mNitzData:Lcom/android/internal/telephony/NitzData;

.field private final mReceiptElapsedMillis:J


# direct methods
.method public constructor <init>(JLcom/android/internal/telephony/NitzData;J)V
    .locals 0

    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 46
    iput-wide p1, p0, Lcom/android/internal/telephony/NitzSignal;->mReceiptElapsedMillis:J

    .line 47
    invoke-static {p3}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    iput-object p3, p0, Lcom/android/internal/telephony/NitzSignal;->mNitzData:Lcom/android/internal/telephony/NitzData;

    const-wide/16 p1, 0x0

    cmp-long p1, p4, p1

    if-ltz p1, :cond_0

    .line 51
    iput-wide p4, p0, Lcom/android/internal/telephony/NitzSignal;->mAgeMillis:J

    return-void

    .line 49
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "ageMillis < 0"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public createTimeSignal()Landroid/os/TimestampedValue;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Landroid/os/TimestampedValue<",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation

    .line 97
    new-instance v0, Landroid/os/TimestampedValue;

    .line 98
    invoke-virtual {p0}, Lcom/android/internal/telephony/NitzSignal;->getAgeAdjustedElapsedRealtimeMillis()J

    move-result-wide v1

    .line 99
    invoke-virtual {p0}, Lcom/android/internal/telephony/NitzSignal;->getNitzData()Lcom/android/internal/telephony/NitzData;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/NitzData;->getCurrentTimeInMillis()J

    move-result-wide v3

    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    invoke-direct {v0, v1, v2, p0}, Landroid/os/TimestampedValue;-><init>(JLjava/lang/Object;)V

    return-object v0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 6

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x0

    if-eqz p1, :cond_3

    .line 107
    const-class v2, Lcom/android/internal/telephony/NitzSignal;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    if-eq v2, v3, :cond_1

    goto :goto_1

    .line 110
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/NitzSignal;

    .line 111
    iget-wide v2, p0, Lcom/android/internal/telephony/NitzSignal;->mReceiptElapsedMillis:J

    iget-wide v4, p1, Lcom/android/internal/telephony/NitzSignal;->mReceiptElapsedMillis:J

    cmp-long v2, v2, v4

    if-nez v2, :cond_2

    iget-wide v2, p0, Lcom/android/internal/telephony/NitzSignal;->mAgeMillis:J

    iget-wide v4, p1, Lcom/android/internal/telephony/NitzSignal;->mAgeMillis:J

    cmp-long v2, v2, v4

    if-nez v2, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/NitzSignal;->mNitzData:Lcom/android/internal/telephony/NitzData;

    iget-object p1, p1, Lcom/android/internal/telephony/NitzSignal;->mNitzData:Lcom/android/internal/telephony/NitzData;

    .line 113
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/NitzData;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    move v0, v1

    :goto_0
    return v0

    :cond_3
    :goto_1
    return v1
.end method

.method public getAgeAdjustedElapsedRealtimeMillis()J
    .locals 4

    .line 87
    iget-wide v0, p0, Lcom/android/internal/telephony/NitzSignal;->mReceiptElapsedMillis:J

    iget-wide v2, p0, Lcom/android/internal/telephony/NitzSignal;->mAgeMillis:J

    sub-long/2addr v0, v2

    return-wide v0
.end method

.method public getAgeMillis()J
    .locals 2

    .line 77
    iget-wide v0, p0, Lcom/android/internal/telephony/NitzSignal;->mAgeMillis:J

    return-wide v0
.end method

.method public getNitzData()Lcom/android/internal/telephony/NitzData;
    .locals 0

    .line 68
    iget-object p0, p0, Lcom/android/internal/telephony/NitzSignal;->mNitzData:Lcom/android/internal/telephony/NitzData;

    return-object p0
.end method

.method public getReceiptElapsedRealtimeMillis()J
    .locals 2

    .line 60
    iget-wide v0, p0, Lcom/android/internal/telephony/NitzSignal;->mReceiptElapsedMillis:J

    return-wide v0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 118
    iget-wide v1, p0, Lcom/android/internal/telephony/NitzSignal;->mReceiptElapsedMillis:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/NitzSignal;->mNitzData:Lcom/android/internal/telephony/NitzData;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-wide v1, p0, Lcom/android/internal/telephony/NitzSignal;->mAgeMillis:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    const/4 v1, 0x2

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 123
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "NitzSignal{mReceiptElapsedMillis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/NitzSignal;->mReceiptElapsedMillis:J

    .line 124
    invoke-static {v1, v2}, Ljava/time/Duration;->ofMillis(J)Ljava/time/Duration;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", mNitzData="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NitzSignal;->mNitzData:Lcom/android/internal/telephony/NitzData;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", mAgeMillis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/NitzSignal;->mAgeMillis:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
