.class Lcom/pri/prizeinterphone/ymodem/YModemUtil;
.super Ljava/lang/Object;
.source "YModemUtil.java"


# static fields
.field private static final CPMEOF:B = 0x1at

.field private static final Data:Ljava/lang/String; = "1"

.field private static final EOT:B = 0x4t

.field private static final SOH:B = 0x1t

.field private static final STX:B = 0x2t

.field private static final crc16:Lcom/pri/prizeinterphone/ymodem/CRC16;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 25
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/CRC16;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/ymodem/CRC16;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->crc16:Lcom/pri/prizeinterphone/ymodem/CRC16;

    return-void
.end method

.method constructor <init>()V
    .locals 0

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static concat([B[B[B)[B
    .locals 6

    .line 136
    array-length v0, p0

    .line 137
    array-length v1, p1

    .line 138
    array-length v2, p2

    add-int v3, v0, v1

    add-int v4, v3, v2

    .line 139
    new-array v4, v4, [B

    const/4 v5, 0x0

    .line 140
    invoke-static {p0, v5, v4, v5, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 141
    invoke-static {p1, v5, v4, v0, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 142
    invoke-static {p2, v5, v4, v3, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    return-object v4
.end method

.method public static varargs concatByteArrays([[B)[B
    .locals 7

    .line 149
    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    move v3, v2

    :goto_0
    if-ge v2, v0, :cond_0

    aget-object v4, p0, v2

    .line 150
    array-length v4, v4

    add-int/2addr v3, v4

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 154
    :cond_0
    new-array v0, v3, [B

    .line 158
    array-length v2, p0

    move v3, v1

    move v4, v3

    :goto_1
    if-ge v3, v2, :cond_1

    aget-object v5, p0, v3

    .line 159
    array-length v6, v5

    invoke-static {v5, v1, v0, v4, v6}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 160
    array-length v5, v5

    add-int/2addr v4, v5

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_1
    return-object v0
.end method

.method private static getDataHeader(BB)[B
    .locals 4

    .line 127
    rem-int/lit16 p0, p0, 0x256

    int-to-byte p0, p0

    not-int v0, p0

    int-to-byte v0, v0

    const/4 v1, 0x1

    new-array v2, v1, [B

    const/4 v3, 0x0

    aput-byte p1, v2, v3

    new-array p1, v1, [B

    aput-byte p0, p1, v3

    new-array p0, v1, [B

    aput-byte v0, p0, v3

    .line 130
    invoke-static {v2, p1, p0}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->concat([B[B[B)[B

    move-result-object p0

    return-object p0
.end method

.method static getDataPackage([BIB)[B
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 80
    array-length v0, p0

    sget-object v1, Lcom/pri/prizeinterphone/ymodem/YModem;->mSize:Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-ne v0, v1, :cond_0

    const/4 v0, 0x2

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    :goto_0
    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getDataHeader(BB)[B

    move-result-object p2

    .line 82
    array-length v0, p0

    if-ge p1, v0, :cond_1

    .line 84
    :goto_1
    array-length v0, p0

    if-ge p1, v0, :cond_1

    const/16 v0, 0x1a

    .line 85
    aput-byte v0, p0, p1

    add-int/lit8 p1, p1, 0x1

    goto :goto_1

    .line 91
    :cond_1
    sget-object p1, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->crc16:Lcom/pri/prizeinterphone/ymodem/CRC16;

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/ymodem/CRC16;->calcCRC([B)J

    move-result-wide v0

    long-to-int p1, v0

    int-to-short p1, p1

    .line 92
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 93
    new-instance v1, Ljava/io/DataOutputStream;

    invoke-direct {v1, v0}, Ljava/io/DataOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 94
    invoke-virtual {v1, p1}, Ljava/io/DataOutputStream;->writeShort(I)V

    .line 95
    invoke-virtual {v1}, Ljava/io/DataOutputStream;->close()V

    .line 96
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1

    .line 97
    invoke-static {p2, p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->concat([B[B[B)[B

    move-result-object p0

    return-object p0
.end method

.method static getEOT()[B
    .locals 3

    const/4 v0, 0x1

    new-array v0, v0, [B

    const/4 v1, 0x0

    const/4 v2, 0x4

    aput-byte v2, v0, v1

    return-object v0
.end method

.method static getEnd()[B
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/16 v0, 0x80

    new-array v1, v0, [B

    const/4 v2, 0x0

    .line 113
    invoke-static {v1, v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getDataPackage([BIB)[B

    move-result-object v0

    return-object v0
.end method

.method static getFileNamePackage(Ljava/lang/String;ILjava/lang/String;)[B
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 48
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ""

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 49
    invoke-virtual {p1}, Ljava/lang/String;->getBytes()[B

    move-result-object p1

    .line 51
    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object p0

    const/4 v0, 0x1

    new-array v1, v0, [B

    const/4 v2, 0x0

    aput-byte v2, v1, v2

    invoke-static {p0, v1, p1}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->concat([B[B[B)[B

    move-result-object p0

    .line 56
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p1

    const/16 v1, 0x80

    if-eqz p1, :cond_0

    const/4 p1, 0x2

    new-array p1, p1, [[B

    aput-object p0, p1, v2

    new-array p0, v0, [B

    aput-byte v2, p0, v2

    aput-object p0, p1, v0

    .line 57
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->concatByteArrays([[B)[B

    move-result-object p0

    invoke-static {p0, v1}, Ljava/util/Arrays;->copyOf([BI)[B

    move-result-object p0

    goto :goto_0

    :cond_0
    new-array p1, v0, [B

    aput-byte v2, p1, v2

    .line 62
    invoke-virtual {p2}, Ljava/lang/String;->getBytes()[B

    move-result-object p2

    .line 60
    invoke-static {p0, p1, p2}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->concat([B[B[B)[B

    move-result-object p0

    invoke-static {p0, v1}, Ljava/util/Arrays;->copyOf([BI)[B

    move-result-object p0

    .line 66
    :goto_0
    invoke-static {p0, v1, v2}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getDataPackage([BIB)[B

    move-result-object p0

    return-object p0
.end method

.method static getInputStream(Landroid/content/Context;Ljava/lang/String;)Ljava/io/InputStream;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 122
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;-><init>()V

    invoke-virtual {v0, p0, p1}, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;->getStream(Landroid/content/Context;Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0

    return-object p0
.end method

.method static getYModelData()[B
    .locals 1

    const-string v0, "1"

    .line 31
    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v0

    return-object v0
.end method
