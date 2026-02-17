.class public Lcom/android/internal/telephony/BitwiseInputStream;
.super Ljava/lang/Object;
.source "BitwiseInputStream.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/BitwiseInputStream$AccessException;
    }
.end annotation


# instance fields
.field private mBuf:[B

.field private mEnd:I

.field private mPos:I


# direct methods
.method public constructor <init>([B)V
    .locals 0

    .line 55
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 56
    iput-object p1, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mBuf:[B

    .line 57
    array-length p1, p1

    shl-int/lit8 p1, p1, 0x3

    iput p1, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mEnd:I

    const/4 p1, 0x0

    .line 58
    iput p1, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    return-void
.end method


# virtual methods
.method public available()I
    .locals 1

    .line 66
    iget v0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mEnd:I

    iget p0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    sub-int/2addr v0, p0

    return v0
.end method

.method public read(I)I
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/BitwiseInputStream$AccessException;
        }
    .end annotation

    .line 80
    iget v0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    ushr-int/lit8 v1, v0, 0x3

    and-int/lit8 v2, v0, 0x7

    rsub-int/lit8 v2, v2, 0x10

    sub-int/2addr v2, p1

    if-ltz p1, :cond_1

    const/16 v3, 0x8

    if-gt p1, v3, :cond_1

    add-int v4, v0, p1

    .line 82
    iget v5, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mEnd:I

    if-gt v4, v5, :cond_1

    .line 86
    iget-object v4, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mBuf:[B

    aget-byte v5, v4, v1

    and-int/lit16 v5, v5, 0xff

    shl-int/2addr v5, v3

    if-ge v2, v3, :cond_0

    add-int/lit8 v1, v1, 0x1

    .line 87
    aget-byte v1, v4, v1

    and-int/lit16 v1, v1, 0xff

    or-int/2addr v5, v1

    :cond_0
    ushr-int v1, v5, v2

    const/4 v2, -0x1

    rsub-int/lit8 v3, p1, 0x20

    ushr-int/2addr v2, v3

    and-int/2addr v1, v2

    add-int/2addr v0, p1

    .line 90
    iput v0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    return v1

    .line 83
    :cond_1
    new-instance v0, Lcom/android/internal/telephony/BitwiseInputStream$AccessException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "illegal read (pos "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", end "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mEnd:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ", bits "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/BitwiseInputStream$AccessException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public readByteArray(I)[B
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/BitwiseInputStream$AccessException;
        }
    .end annotation

    ushr-int/lit8 v0, p1, 0x3

    and-int/lit8 v1, p1, 0x7

    const/4 v2, 0x0

    if-lez v1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    move v1, v2

    :goto_0
    add-int/2addr v0, v1

    .line 103
    new-array v1, v0, [B

    :goto_1
    if-ge v2, v0, :cond_1

    shl-int/lit8 v3, v2, 0x3

    sub-int v3, p1, v3

    const/16 v4, 0x8

    .line 105
    invoke-static {v4, v3}, Ljava/lang/Math;->min(II)I

    move-result v3

    .line 106
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v5

    sub-int/2addr v4, v3

    shl-int v3, v5, v4

    int-to-byte v3, v3

    aput-byte v3, v1, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    :cond_1
    return-object v1
.end method

.method public skip(I)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/BitwiseInputStream$AccessException;
        }
    .end annotation

    .line 118
    iget v0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    add-int v1, v0, p1

    iget v2, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mEnd:I

    if-gt v1, v2, :cond_0

    add-int/2addr v0, p1

    .line 122
    iput v0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    return-void

    .line 119
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/BitwiseInputStream$AccessException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "illegal skip (pos "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mPos:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", end "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/BitwiseInputStream;->mEnd:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ", bits "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/BitwiseInputStream$AccessException;-><init>(Ljava/lang/String;)V

    throw v0
.end method
