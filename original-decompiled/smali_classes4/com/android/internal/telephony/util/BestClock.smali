.class public final Lcom/android/internal/telephony/util/BestClock;
.super Ljava/time/Clock;
.source "BestClock.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "BestClock"


# instance fields
.field private final mClocks:[Ljava/time/Clock;

.field private final mZone:Ljava/time/ZoneId;


# direct methods
.method public varargs constructor <init>(Ljava/time/ZoneId;[Ljava/time/Clock;)V
    .locals 0

    .line 45
    invoke-direct {p0}, Ljava/time/Clock;-><init>()V

    .line 46
    iput-object p1, p0, Lcom/android/internal/telephony/util/BestClock;->mZone:Ljava/time/ZoneId;

    .line 47
    iput-object p2, p0, Lcom/android/internal/telephony/util/BestClock;->mClocks:[Ljava/time/Clock;

    return-void
.end method


# virtual methods
.method public getZone()Ljava/time/ZoneId;
    .locals 0

    .line 66
    iget-object p0, p0, Lcom/android/internal/telephony/util/BestClock;->mZone:Ljava/time/ZoneId;

    return-object p0
.end method

.method public instant()Ljava/time/Instant;
    .locals 2

    .line 76
    invoke-virtual {p0}, Lcom/android/internal/telephony/util/BestClock;->millis()J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/time/Instant;->ofEpochMilli(J)Ljava/time/Instant;

    move-result-object p0

    return-object p0
.end method

.method public millis()J
    .locals 5

    .line 52
    iget-object v0, p0, Lcom/android/internal/telephony/util/BestClock;->mClocks:[Ljava/time/Clock;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-object v3, v0, v2

    .line 54
    :try_start_0
    invoke-virtual {v3}, Ljava/time/Clock;->millis()J

    move-result-wide v0
    :try_end_0
    .catch Ljava/time/DateTimeException; {:try_start_0 .. :try_end_0} :catch_0

    return-wide v0

    :catch_0
    move-exception v3

    .line 57
    invoke-virtual {v3}, Ljava/time/DateTimeException;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "BestClock"

    invoke-static {v4, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 60
    :cond_0
    new-instance v0, Ljava/time/DateTimeException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "No clocks in "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/util/BestClock;->mClocks:[Ljava/time/Clock;

    .line 61
    invoke-static {p0}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " were able to provide time"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/time/DateTimeException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public withZone(Ljava/time/ZoneId;)Ljava/time/Clock;
    .locals 1

    .line 71
    new-instance v0, Lcom/android/internal/telephony/util/BestClock;

    iget-object p0, p0, Lcom/android/internal/telephony/util/BestClock;->mClocks:[Ljava/time/Clock;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/util/BestClock;-><init>(Ljava/time/ZoneId;[Ljava/time/Clock;)V

    return-object v0
.end method
