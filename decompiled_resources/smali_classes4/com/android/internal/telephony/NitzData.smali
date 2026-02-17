.class public final Lcom/android/internal/telephony/NitzData;
.super Ljava/lang/Object;
.source "NitzData.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
    visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PACKAGE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
.end annotation


# static fields
.field private static final LOG_TAG:Ljava/lang/String; = "SST"

.field private static final MAX_NITZ_YEAR:I = 0x7f5

.field private static final MS_PER_HOUR:I = 0x36ee80

.field private static final MS_PER_QUARTER_HOUR:I = 0xdbba0

.field private static final NITZ_SPLIT_PATTERN:Ljava/util/regex/Pattern;


# instance fields
.field private final mCurrentTimeMillis:J

.field private final mDstOffset:Ljava/lang/Integer;

.field private final mEmulatorHostTimeZone:Ljava/util/TimeZone;

.field private final mOriginalString:Ljava/lang/String;

.field private final mZoneOffset:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "[/:,+-]"

    .line 45
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/NitzData;->NITZ_SPLIT_PATTERN:Ljava/util/regex/Pattern;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;ILjava/lang/Integer;JLjava/util/TimeZone;)V
    .locals 0

    .line 59
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    if-eqz p1, :cond_0

    .line 63
    iput-object p1, p0, Lcom/android/internal/telephony/NitzData;->mOriginalString:Ljava/lang/String;

    .line 64
    iput p2, p0, Lcom/android/internal/telephony/NitzData;->mZoneOffset:I

    .line 65
    iput-object p3, p0, Lcom/android/internal/telephony/NitzData;->mDstOffset:Ljava/lang/Integer;

    .line 66
    iput-wide p4, p0, Lcom/android/internal/telephony/NitzData;->mCurrentTimeMillis:J

    .line 67
    iput-object p6, p0, Lcom/android/internal/telephony/NitzData;->mEmulatorHostTimeZone:Ljava/util/TimeZone;

    return-void

    .line 61
    :cond_0
    new-instance p0, Ljava/lang/NullPointerException;

    const-string p1, "originalString==null"

    invoke-direct {p0, p1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static createForTests(ILjava/lang/Integer;JLjava/util/TimeZone;)Lcom/android/internal/telephony/NitzData;
    .locals 8

    .line 134
    new-instance v7, Lcom/android/internal/telephony/NitzData;

    const-string v1, "Test data"

    move-object v0, v7

    move v2, p0

    move-object v3, p1

    move-wide v4, p2

    move-object v6, p4

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/NitzData;-><init>(Ljava/lang/String;ILjava/lang/Integer;JLjava/util/TimeZone;)V

    return-object v7
.end method

.method public static parse(Ljava/lang/String;)Lcom/android/internal/telephony/NitzData;
    .locals 13

    const-string v0, "SST"

    const/4 v1, 0x0

    .line 78
    :try_start_0
    sget-object v2, Lcom/android/internal/telephony/NitzData;->NITZ_SPLIT_PATTERN:Ljava/util/regex/Pattern;

    invoke-virtual {v2, p0}, Ljava/util/regex/Pattern;->split(Ljava/lang/CharSequence;)[Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    .line 80
    aget-object v4, v2, v3

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    add-int/lit16 v5, v4, 0x7d0

    const/16 v4, 0x7f5

    if-le v5, v4, :cond_0

    .line 83
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "NITZ year: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " exceeds limit, skip NITZ time update"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1

    :cond_0
    const/4 v4, 0x1

    .line 88
    aget-object v6, v2, v4

    invoke-static {v6}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v6

    const/4 v7, 0x2

    .line 89
    aget-object v7, v2, v7

    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7

    const/4 v8, 0x3

    .line 90
    aget-object v8, v2, v8

    invoke-static {v8}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v8

    const/4 v9, 0x4

    .line 91
    aget-object v9, v2, v9

    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v9

    const/4 v10, 0x5

    .line 92
    aget-object v10, v2, v10

    invoke-static {v10}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v10

    .line 96
    invoke-static/range {v5 .. v10}, Ljava/time/LocalDateTime;->of(IIIIII)Ljava/time/LocalDateTime;

    move-result-object v5

    sget-object v6, Ljava/time/ZoneOffset;->UTC:Ljava/time/ZoneOffset;

    .line 97
    invoke-virtual {v5, v6}, Ljava/time/LocalDateTime;->toInstant(Ljava/time/ZoneOffset;)Ljava/time/Instant;

    move-result-object v5

    .line 98
    invoke-virtual {v5}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide v10

    const/16 v5, 0x2d

    .line 101
    invoke-virtual {p0, v5}, Ljava/lang/String;->indexOf(I)I

    move-result v5

    const/4 v6, -0x1

    if-ne v5, v6, :cond_1

    move v3, v4

    :cond_1
    const/4 v5, 0x6

    .line 102
    aget-object v5, v2, v5

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    if-eqz v3, :cond_2

    goto :goto_0

    :cond_2
    move v4, v6

    :goto_0
    mul-int/2addr v4, v5

    const v3, 0xdbba0

    mul-int v8, v4, v3

    .line 109
    array-length v3, v2

    const/16 v4, 0x8

    if-lt v3, v4, :cond_3

    const/4 v3, 0x7

    aget-object v3, v2, v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    goto :goto_1

    :cond_3
    move-object v3, v1

    :goto_1
    if-eqz v3, :cond_4

    .line 112
    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    const v5, 0x36ee80

    mul-int/2addr v3, v5

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    move-object v9, v3

    goto :goto_2

    :cond_4
    move-object v9, v1

    .line 120
    :goto_2
    array-length v3, v2

    const/16 v5, 0x9

    if-lt v3, v5, :cond_5

    .line 121
    aget-object v2, v2, v4

    const/16 v3, 0x21

    const/16 v4, 0x2f

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v2

    .line 122
    invoke-static {v2}, Ljava/util/TimeZone;->getTimeZone(Ljava/lang/String;)Ljava/util/TimeZone;

    move-result-object v2

    move-object v12, v2

    goto :goto_3

    :cond_5
    move-object v12, v1

    .line 124
    :goto_3
    new-instance v2, Lcom/android/internal/telephony/NitzData;

    move-object v6, v2

    move-object v7, p0

    invoke-direct/range {v6 .. v12}, Lcom/android/internal/telephony/NitzData;-><init>(Ljava/lang/String;ILjava/lang/Integer;JLjava/util/TimeZone;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v2

    :catch_0
    move-exception v2

    .line 126
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "NITZ: Parsing NITZ time "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " ex="

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 5

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 v0, 0x0

    if-eqz p1, :cond_6

    .line 208
    const-class v1, Lcom/android/internal/telephony/NitzData;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    if-eq v1, v2, :cond_1

    goto :goto_0

    .line 212
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/NitzData;

    .line 214
    iget v1, p0, Lcom/android/internal/telephony/NitzData;->mZoneOffset:I

    iget v2, p1, Lcom/android/internal/telephony/NitzData;->mZoneOffset:I

    if-eq v1, v2, :cond_2

    return v0

    .line 217
    :cond_2
    iget-wide v1, p0, Lcom/android/internal/telephony/NitzData;->mCurrentTimeMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/NitzData;->mCurrentTimeMillis:J

    cmp-long v1, v1, v3

    if-eqz v1, :cond_3

    return v0

    .line 220
    :cond_3
    iget-object v1, p0, Lcom/android/internal/telephony/NitzData;->mOriginalString:Ljava/lang/String;

    iget-object v2, p1, Lcom/android/internal/telephony/NitzData;->mOriginalString:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    return v0

    .line 223
    :cond_4
    iget-object v1, p0, Lcom/android/internal/telephony/NitzData;->mDstOffset:Ljava/lang/Integer;

    iget-object v2, p1, Lcom/android/internal/telephony/NitzData;->mDstOffset:Ljava/lang/Integer;

    invoke-static {v1, v2}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_5

    return v0

    .line 226
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/NitzData;->mEmulatorHostTimeZone:Ljava/util/TimeZone;

    iget-object p1, p1, Lcom/android/internal/telephony/NitzData;->mEmulatorHostTimeZone:Ljava/util/TimeZone;

    invoke-static {p0, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    return p0

    :cond_6
    :goto_0
    return v0
.end method

.method public getCurrentTimeInMillis()J
    .locals 2

    .line 143
    iget-wide v0, p0, Lcom/android/internal/telephony/NitzData;->mCurrentTimeMillis:J

    return-wide v0
.end method

.method public getDstAdjustmentMillis()Ljava/lang/Integer;
    .locals 0

    .line 182
    iget-object p0, p0, Lcom/android/internal/telephony/NitzData;->mDstOffset:Ljava/lang/Integer;

    return-object p0
.end method

.method public getEmulatorHostTimeZone()Ljava/util/TimeZone;
    .locals 0

    .line 200
    iget-object p0, p0, Lcom/android/internal/telephony/NitzData;->mEmulatorHostTimeZone:Ljava/util/TimeZone;

    return-object p0
.end method

.method public getLocalOffsetMillis()I
    .locals 0

    .line 155
    iget p0, p0, Lcom/android/internal/telephony/NitzData;->mZoneOffset:I

    return p0
.end method

.method public hashCode()I
    .locals 5

    .line 231
    iget-object v0, p0, Lcom/android/internal/telephony/NitzData;->mOriginalString:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v0

    mul-int/lit8 v0, v0, 0x1f

    .line 232
    iget v1, p0, Lcom/android/internal/telephony/NitzData;->mZoneOffset:I

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 233
    iget-object v1, p0, Lcom/android/internal/telephony/NitzData;->mDstOffset:Ljava/lang/Integer;

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Ljava/lang/Integer;->hashCode()I

    move-result v1

    goto :goto_0

    :cond_0
    move v1, v2

    :goto_0
    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 234
    iget-wide v3, p0, Lcom/android/internal/telephony/NitzData;->mCurrentTimeMillis:J

    invoke-static {v3, v4}, Ljava/lang/Long;->hashCode(J)I

    move-result v1

    add-int/2addr v0, v1

    mul-int/lit8 v0, v0, 0x1f

    .line 235
    iget-object p0, p0, Lcom/android/internal/telephony/NitzData;->mEmulatorHostTimeZone:Ljava/util/TimeZone;

    if-eqz p0, :cond_1

    invoke-virtual {p0}, Ljava/lang/Object;->hashCode()I

    move-result v2

    :cond_1
    add-int/2addr v0, v2

    return v0
.end method

.method public isDst()Z
    .locals 0

    .line 190
    iget-object p0, p0, Lcom/android/internal/telephony/NitzData;->mDstOffset:Ljava/lang/Integer;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 242
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "NitzData{mOriginalString="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NitzData;->mOriginalString:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mZoneOffset="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/NitzData;->mZoneOffset:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", mDstOffset="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NitzData;->mDstOffset:Ljava/lang/Integer;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", mCurrentTimeMillis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/NitzData;->mCurrentTimeMillis:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, ", mEmulatorHostTimeZone="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/NitzData;->mEmulatorHostTimeZone:Ljava/util/TimeZone;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
