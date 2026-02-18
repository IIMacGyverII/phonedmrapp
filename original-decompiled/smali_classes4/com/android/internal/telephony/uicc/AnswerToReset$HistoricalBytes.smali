.class public Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;
.super Ljava/lang/Object;
.source "AnswerToReset.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/AnswerToReset;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "HistoricalBytes"
.end annotation


# static fields
.field private static final LENGTH_MASK:I = 0xf

.field private static final TAG_MASK:I = 0xf0


# instance fields
.field private final mCategory:B

.field private final mNodes:Landroid/util/ArrayMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArrayMap<",
            "Ljava/lang/Integer;",
            "[B>;"
        }
    .end annotation
.end field

.field private final mRawData:[B


# direct methods
.method static bridge synthetic -$$Nest$smparseHistoricalBytes([BII)Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->parseHistoricalBytes([BII)Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;

    move-result-object p0

    return-object p0
.end method

.method private constructor <init>([BLandroid/util/ArrayMap;B)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B",
            "Landroid/util/ArrayMap<",
            "Ljava/lang/Integer;",
            "[B>;B)V"
        }
    .end annotation

    .line 111
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 112
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->mRawData:[B

    .line 113
    iput-object p2, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->mNodes:Landroid/util/ArrayMap;

    .line 114
    iput-byte p3, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->mCategory:B

    return-void
.end method

.method private static parseHistoricalBytes([BII)Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;
    .locals 5

    const/4 v0, 0x0

    if-lez p2, :cond_3

    add-int v1, p1, p2

    .line 93
    array-length v2, p0

    if-le v1, v2, :cond_0

    goto :goto_1

    .line 96
    :cond_0
    new-instance v2, Landroid/util/ArrayMap;

    invoke-direct {v2}, Landroid/util/ArrayMap;-><init>()V

    add-int/lit8 v3, p1, 0x1

    :goto_0
    if-ge v3, v1, :cond_1

    if-lez v3, :cond_1

    add-int/lit8 v4, v1, -0x1

    .line 101
    invoke-static {v3, v2, p0, v4}, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->parseLtvNode(ILandroid/util/ArrayMap;[BI)I

    move-result v3

    goto :goto_0

    :cond_1
    if-gez v3, :cond_2

    return-object v0

    .line 106
    :cond_2
    new-array v0, p2, [B

    const/4 v1, 0x0

    .line 107
    invoke-static {p0, p1, v0, v1, p2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 108
    new-instance p0, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;

    aget-byte p1, v0, v1

    invoke-direct {p0, v0, v2, p1}, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;-><init>([BLandroid/util/ArrayMap;B)V

    return-object p0

    :cond_3
    :goto_1
    return-object v0
.end method

.method private static parseLtvNode(ILandroid/util/ArrayMap;[BI)I
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Landroid/util/ArrayMap<",
            "Ljava/lang/Integer;",
            "[B>;[BI)I"
        }
    .end annotation

    const/4 v0, -0x1

    if-le p0, p3, :cond_0

    return v0

    .line 122
    :cond_0
    aget-byte v1, p2, p0

    and-int/lit16 v2, v1, 0xf0

    shr-int/lit8 v2, v2, 0x4

    add-int/lit8 p0, p0, 0x1

    and-int/lit8 v1, v1, 0xf

    add-int v3, p0, v1

    add-int/lit8 p3, p3, 0x1

    if-gt v3, p3, :cond_2

    if-nez v1, :cond_1

    goto :goto_0

    .line 127
    :cond_1
    new-array p3, v1, [B

    const/4 v0, 0x0

    .line 128
    invoke-static {p2, p0, p3, v0, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 129
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-virtual {p1, p0, p3}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return v3

    :cond_2
    :goto_0
    return v0
.end method


# virtual methods
.method public getCategory()B
    .locals 0

    .line 76
    iget-byte p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->mCategory:B

    return p0
.end method

.method public getRawData()[B
    .locals 0

    .line 81
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->mRawData:[B

    return-object p0
.end method

.method public getValue(I)[B
    .locals 0

    .line 87
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$HistoricalBytes;->mNodes:Landroid/util/ArrayMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [B

    return-object p0
.end method
