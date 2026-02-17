.class public Lcom/android/internal/telephony/HexDump;
.super Ljava/lang/Object;
.source "HexDump.java"


# static fields
.field private static final HEX_DIGITS:[C

.field private static final HEX_LOWER_CASE_DIGITS:[C


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const/16 v0, 0x10

    new-array v1, v0, [C

    .line 24
    fill-array-data v1, :array_0

    sput-object v1, Lcom/android/internal/telephony/HexDump;->HEX_DIGITS:[C

    new-array v0, v0, [C

    .line 25
    fill-array-data v0, :array_1

    sput-object v0, Lcom/android/internal/telephony/HexDump;->HEX_LOWER_CASE_DIGITS:[C

    return-void

    nop

    :array_0
    .array-data 2
        0x30s
        0x31s
        0x32s
        0x33s
        0x34s
        0x35s
        0x36s
        0x37s
        0x38s
        0x39s
        0x41s
        0x42s
        0x43s
        0x44s
        0x45s
        0x46s
    .end array-data

    :array_1
    .array-data 2
        0x30s
        0x31s
        0x32s
        0x33s
        0x34s
        0x35s
        0x36s
        0x37s
        0x38s
        0x39s
        0x61s
        0x62s
        0x63s
        0x64s
        0x65s
        0x66s
    .end array-data
.end method

.method public constructor <init>()V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static appendByteAsHex(Ljava/lang/StringBuilder;BZ)Ljava/lang/StringBuilder;
    .locals 1

    if-eqz p2, :cond_0

    .line 187
    sget-object p2, Lcom/android/internal/telephony/HexDump;->HEX_DIGITS:[C

    goto :goto_0

    :cond_0
    sget-object p2, Lcom/android/internal/telephony/HexDump;->HEX_LOWER_CASE_DIGITS:[C

    :goto_0
    shr-int/lit8 v0, p1, 0x4

    and-int/lit8 v0, v0, 0xf

    .line 188
    aget-char v0, p2, v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    and-int/lit8 p1, p1, 0xf

    .line 189
    aget-char p1, p2, p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    return-object p0
.end method

.method public static dumpHexString([B)Ljava/lang/String;
    .locals 2

    if-nez p0, :cond_0

    const-string p0, "(null)"

    return-object p0

    :cond_0
    const/4 v0, 0x0

    .line 29
    array-length v1, p0

    invoke-static {p0, v0, v1}, Lcom/android/internal/telephony/HexDump;->dumpHexString([BII)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static dumpHexString([BII)Ljava/lang/String;
    .locals 13

    if-nez p0, :cond_0

    const-string p0, "(null)"

    return-object p0

    .line 35
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/16 v1, 0x10

    new-array v2, v1, [B

    const-string v3, "\n0x"

    .line 40
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 41
    invoke-static {p1}, Lcom/android/internal/telephony/HexDump;->toHexString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v4, 0x0

    move v5, p1

    move v6, v4

    :goto_0
    add-int v7, p1, p2

    const/16 v8, 0x7e

    const-string v9, "."

    const/16 v10, 0x20

    const-string v11, " "

    const/4 v12, 0x1

    if-ge v5, v7, :cond_4

    if-ne v6, v1, :cond_3

    .line 47
    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v6, v4

    :goto_1
    if-ge v6, v1, :cond_2

    .line 51
    aget-byte v7, v2, v6

    if-le v7, v10, :cond_1

    if-ge v7, v8, :cond_1

    .line 53
    new-instance v7, Ljava/lang/String;

    invoke-direct {v7, v2, v6, v12}, Ljava/lang/String;-><init>([BII)V

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_2

    .line 57
    :cond_1
    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_2
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 61
    :cond_2
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 62
    invoke-static {v5}, Lcom/android/internal/telephony/HexDump;->toHexString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v6, v4

    .line 66
    :cond_3
    aget-byte v7, p0, v5

    .line 67
    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 68
    sget-object v8, Lcom/android/internal/telephony/HexDump;->HEX_DIGITS:[C

    ushr-int/lit8 v9, v7, 0x4

    and-int/lit8 v9, v9, 0xf

    aget-char v9, v8, v9

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    and-int/lit8 v9, v7, 0xf

    .line 69
    aget-char v8, v8, v9

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v8, v6, 0x1

    .line 71
    aput-byte v7, v2, v6

    add-int/lit8 v5, v5, 0x1

    move v6, v8

    goto :goto_0

    :cond_4
    if-eq v6, v1, :cond_7

    rsub-int/lit8 p0, v6, 0x10

    mul-int/lit8 p0, p0, 0x3

    add-int/2addr p0, v12

    move p1, v4

    :goto_3
    if-ge p1, p0, :cond_5

    .line 80
    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 p1, p1, 0x1

    goto :goto_3

    :cond_5
    :goto_4
    if-ge v4, v6, :cond_7

    .line 85
    aget-byte p0, v2, v4

    if-le p0, v10, :cond_6

    if-ge p0, v8, :cond_6

    .line 87
    new-instance p0, Ljava/lang/String;

    invoke-direct {p0, v2, v4, v12}, Ljava/lang/String;-><init>([BII)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_5

    .line 91
    :cond_6
    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_5
    add-int/lit8 v4, v4, 0x1

    goto :goto_4

    .line 96
    :cond_7
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static hexStringToByteArray(Ljava/lang/String;)[B
    .locals 6

    .line 175
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    .line 176
    div-int/lit8 v1, v0, 0x2

    new-array v1, v1, [B

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_0

    .line 180
    div-int/lit8 v3, v2, 0x2

    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v4

    invoke-static {v4}, Lcom/android/internal/telephony/HexDump;->toByte(C)I

    move-result v4

    shl-int/lit8 v4, v4, 0x4

    add-int/lit8 v5, v2, 0x1

    invoke-virtual {p0, v5}, Ljava/lang/String;->charAt(I)C

    move-result v5

    invoke-static {v5}, Lcom/android/internal/telephony/HexDump;->toByte(C)I

    move-result v5

    or-int/2addr v4, v5

    int-to-byte v4, v4

    aput-byte v4, v1, v3

    add-int/lit8 v2, v2, 0x2

    goto :goto_0

    :cond_0
    return-object v1
.end method

.method private static toByte(C)I
    .locals 3

    const/16 v0, 0x30

    if-lt p0, v0, :cond_0

    const/16 v1, 0x39

    if-gt p0, v1, :cond_0

    sub-int/2addr p0, v0

    return p0

    :cond_0
    const/16 v0, 0x41

    if-lt p0, v0, :cond_1

    const/16 v1, 0x46

    if-gt p0, v1, :cond_1

    :goto_0
    sub-int/2addr p0, v0

    add-int/lit8 p0, p0, 0xa

    return p0

    :cond_1
    const/16 v0, 0x61

    if-lt p0, v0, :cond_2

    const/16 v1, 0x66

    if-gt p0, v1, :cond_2

    goto :goto_0

    .line 169
    :cond_2
    new-instance v0, Ljava/lang/RuntimeException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid hex char \'"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string p0, "\'"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public static toByteArray(B)[B
    .locals 2

    const/4 v0, 0x1

    new-array v0, v0, [B

    const/4 v1, 0x0

    aput-byte p0, v0, v1

    return-object v0
.end method

.method public static toByteArray(I)[B
    .locals 3

    const/4 v0, 0x4

    new-array v0, v0, [B

    and-int/lit16 v1, p0, 0xff

    int-to-byte v1, v1

    const/4 v2, 0x3

    aput-byte v1, v0, v2

    shr-int/lit8 v1, p0, 0x8

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    const/4 v2, 0x2

    aput-byte v1, v0, v2

    shr-int/lit8 v1, p0, 0x10

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    const/4 v2, 0x1

    aput-byte v1, v0, v2

    shr-int/lit8 p0, p0, 0x18

    and-int/lit16 p0, p0, 0xff

    int-to-byte p0, p0

    const/4 v1, 0x0

    aput-byte p0, v0, v1

    return-object v0
.end method

.method public static toHexString(B)Ljava/lang/String;
    .locals 0

    .line 101
    invoke-static {p0}, Lcom/android/internal/telephony/HexDump;->toByteArray(B)[B

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/HexDump;->toHexString([B)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static toHexString(I)Ljava/lang/String;
    .locals 0

    .line 141
    invoke-static {p0}, Lcom/android/internal/telephony/HexDump;->toByteArray(I)[B

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/HexDump;->toHexString([B)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static toHexString([B)Ljava/lang/String;
    .locals 3

    .line 107
    array-length v0, p0

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-static {p0, v1, v0, v2}, Lcom/android/internal/telephony/HexDump;->toHexString([BIIZ)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static toHexString([BII)Ljava/lang/String;
    .locals 1

    const/4 v0, 0x1

    .line 119
    invoke-static {p0, p1, p2, v0}, Lcom/android/internal/telephony/HexDump;->toHexString([BIIZ)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static toHexString([BIIZ)Ljava/lang/String;
    .locals 6

    if-eqz p3, :cond_0

    .line 124
    sget-object p3, Lcom/android/internal/telephony/HexDump;->HEX_DIGITS:[C

    goto :goto_0

    :cond_0
    sget-object p3, Lcom/android/internal/telephony/HexDump;->HEX_LOWER_CASE_DIGITS:[C

    :goto_0
    mul-int/lit8 v0, p2, 0x2

    .line 125
    new-array v0, v0, [C

    const/4 v1, 0x0

    move v2, p1

    :goto_1
    add-int v3, p1, p2

    if-ge v2, v3, :cond_1

    .line 130
    aget-byte v3, p0, v2

    add-int/lit8 v4, v1, 0x1

    ushr-int/lit8 v5, v3, 0x4

    and-int/lit8 v5, v5, 0xf

    .line 131
    aget-char v5, p3, v5

    aput-char v5, v0, v1

    add-int/lit8 v1, v4, 0x1

    and-int/lit8 v3, v3, 0xf

    .line 132
    aget-char v3, p3, v3

    aput-char v3, v0, v4

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 135
    :cond_1
    new-instance p0, Ljava/lang/String;

    invoke-direct {p0, v0}, Ljava/lang/String;-><init>([C)V

    return-object p0
.end method

.method public static toHexString([BZ)Ljava/lang/String;
    .locals 2

    .line 113
    array-length v0, p0

    const/4 v1, 0x0

    invoke-static {p0, v1, v0, p1}, Lcom/android/internal/telephony/HexDump;->toHexString([BIIZ)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
