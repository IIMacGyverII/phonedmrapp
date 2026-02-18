.class public Lcom/android/internal/telephony/util/DnsSdTxtRecord;
.super Ljava/lang/Object;
.source "DnsSdTxtRecord.java"

# interfaces
.implements Landroid/os/Parcelable;


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/android/internal/telephony/util/DnsSdTxtRecord;",
            ">;"
        }
    .end annotation
.end field

.field private static final mSeparator:B = 0x3dt


# instance fields
.field private mData:[B


# direct methods
.method static bridge synthetic -$$Nest$fgetmData(Lcom/android/internal/telephony/util/DnsSdTxtRecord;)[B
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 313
    new-instance v0, Lcom/android/internal/telephony/util/DnsSdTxtRecord$1;

    invoke-direct {v0}, Lcom/android/internal/telephony/util/DnsSdTxtRecord$1;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    new-array v0, v0, [B

    .line 49
    iput-object v0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/util/DnsSdTxtRecord;)V
    .locals 0

    .line 58
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    if-eqz p1, :cond_0

    .line 59
    iget-object p1, p1, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    if-eqz p1, :cond_0

    .line 60
    invoke-virtual {p1}, [B->clone()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [B

    iput-object p1, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    :cond_0
    return-void
.end method

.method public constructor <init>([B)V
    .locals 0

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 54
    invoke-virtual {p1}, [B->clone()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [B

    iput-object p1, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    return-void
.end method

.method private getKey(I)Ljava/lang/String;
    .locals 5

    const/4 v0, 0x0

    move v1, v0

    move v2, v1

    :goto_0
    if-ge v1, p1, :cond_0

    .line 197
    iget-object v3, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v4, v3

    if-ge v2, v4, :cond_0

    .line 198
    aget-byte v3, v3, v2

    add-int/lit8 v3, v3, 0x1

    add-int/2addr v2, v3

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 201
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v1, p1

    if-ge v2, v1, :cond_3

    .line 202
    aget-byte p1, p1, v2

    :goto_1
    if-ge v0, p1, :cond_2

    .line 206
    iget-object v1, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    add-int v3, v2, v0

    add-int/lit8 v3, v3, 0x1

    aget-byte v1, v1, v3

    const/16 v3, 0x3d

    if-ne v1, v3, :cond_1

    goto :goto_2

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 208
    :cond_2
    :goto_2
    new-instance p1, Ljava/lang/String;

    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    add-int/lit8 v2, v2, 0x1

    invoke-direct {p1, p0, v2, v0}, Ljava/lang/String;-><init>([BII)V

    return-object p1

    :cond_3
    const/4 p0, 0x0

    return-object p0
.end method

.method private getValue(I)[B
    .locals 7

    const/4 v0, 0x0

    move v1, v0

    move v2, v1

    :goto_0
    if-ge v1, p1, :cond_0

    .line 222
    iget-object v3, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v4, v3

    if-ge v2, v4, :cond_0

    .line 223
    aget-byte v3, v3, v2

    add-int/lit8 v3, v3, 0x1

    add-int/2addr v2, v3

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 226
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v1, p1

    if-ge v2, v1, :cond_2

    .line 227
    aget-byte p1, p1, v2

    move v1, v0

    :goto_1
    if-ge v1, p1, :cond_2

    .line 231
    iget-object v3, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    add-int v4, v2, v1

    add-int/lit8 v5, v4, 0x1

    aget-byte v5, v3, v5

    const/16 v6, 0x3d

    if-ne v5, v6, :cond_1

    sub-int/2addr p1, v1

    add-int/lit8 p1, p1, -0x1

    .line 232
    new-array p0, p1, [B

    add-int/lit8 v4, v4, 0x2

    .line 233
    invoke-static {v3, v4, p0, v0, p1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    goto :goto_2

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    :cond_2
    const/4 p0, 0x0

    :goto_2
    return-object p0
.end method

.method private getValue(Ljava/lang/String;)[B
    .locals 2

    const/4 v0, 0x0

    .line 250
    :goto_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->getKey(I)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 251
    invoke-virtual {p1, v1}, Ljava/lang/String;->compareToIgnoreCase(Ljava/lang/String;)I

    move-result v1

    if-nez v1, :cond_0

    .line 252
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->getValue(I)[B

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private getValueAsString(I)Ljava/lang/String;
    .locals 0

    .line 242
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->getValue(I)[B

    move-result-object p0

    if-eqz p0, :cond_0

    .line 243
    new-instance p1, Ljava/lang/String;

    invoke-direct {p1, p0}, Ljava/lang/String;-><init>([B)V

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    return-object p1
.end method

.method private insert([B[BI)V
    .locals 8

    .line 169
    iget-object v0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    const/4 v1, 0x0

    if-eqz p2, :cond_0

    .line 170
    array-length v2, p2

    goto :goto_0

    :cond_0
    move v2, v1

    :goto_0
    move v3, v1

    move v4, v3

    :goto_1
    const/4 v5, 0x1

    if-ge v3, p3, :cond_1

    .line 174
    iget-object v6, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v7, v6

    if-ge v4, v7, :cond_1

    .line 175
    aget-byte v6, v6, v4

    add-int/2addr v6, v5

    and-int/lit16 v5, v6, 0xff

    add-int/2addr v4, v5

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 178
    :cond_1
    array-length p3, p1

    add-int/2addr p3, v2

    if-eqz p2, :cond_2

    move v3, v5

    goto :goto_2

    :cond_2
    move v3, v1

    :goto_2
    add-int/2addr p3, v3

    .line 179
    array-length v3, v0

    add-int/2addr v3, p3

    add-int/2addr v3, v5

    .line 181
    new-array v5, v3, [B

    iput-object v5, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    .line 182
    invoke-static {v0, v1, v5, v1, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 183
    array-length v5, v0

    sub-int/2addr v5, v4

    .line 184
    iget-object v6, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    sub-int/2addr v3, v5

    invoke-static {v0, v4, v6, v3, v5}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 185
    iget-object v0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    int-to-byte p3, p3

    aput-byte p3, v0, v4

    add-int/lit8 p3, v4, 0x1

    .line 186
    array-length v3, p1

    invoke-static {p1, v1, v0, p3, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    if-eqz p2, :cond_3

    .line 188
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v0, p1

    add-int/2addr p3, v0

    const/16 v0, 0x3d

    aput-byte v0, p0, p3

    .line 189
    array-length p1, p1

    add-int/2addr v4, p1

    add-int/lit8 v4, v4, 0x2

    invoke-static {p2, v1, p0, v4, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_3
    return-void
.end method


# virtual methods
.method public contains(Ljava/lang/String;)Z
    .locals 3

    const/4 v0, 0x0

    move v1, v0

    .line 152
    :goto_0
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->getKey(I)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_1

    .line 153
    invoke-virtual {p1, v2}, Ljava/lang/String;->compareToIgnoreCase(Ljava/lang/String;)I

    move-result v2

    if-nez v2, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return v0
.end method

.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 1

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    return p0

    .line 289
    :cond_0
    instance-of v0, p1, Lcom/android/internal/telephony/util/DnsSdTxtRecord;

    if-nez v0, :cond_1

    const/4 p0, 0x0

    return p0

    .line 293
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/util/DnsSdTxtRecord;

    .line 294
    iget-object p1, p1, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    invoke-static {p1, p0}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p0

    return p0
.end method

.method public get(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 113
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->getValue(Ljava/lang/String;)[B

    move-result-object p0

    if-eqz p0, :cond_0

    .line 114
    new-instance p1, Ljava/lang/String;

    invoke-direct {p1, p0}, Ljava/lang/String;-><init>([B)V

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    return-object p1
.end method

.method public getRawData()[B
    .locals 0

    .line 165
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    invoke-virtual {p0}, [B->clone()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [B

    return-object p0
.end method

.method public hashCode()I
    .locals 0

    .line 299
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    invoke-static {p0}, Ljava/util/Arrays;->hashCode([B)I

    move-result p0

    return p0
.end method

.method public keyCount()I
    .locals 4

    const/4 v0, 0x0

    move v1, v0

    .line 143
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v3, v2

    if-ge v0, v3, :cond_0

    .line 144
    aget-byte v2, v2, v0

    add-int/lit8 v2, v2, 0x1

    and-int/lit16 v2, v2, 0xff

    add-int/2addr v0, v2

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return v1
.end method

.method public remove(Ljava/lang/String;)I
    .locals 8

    const/4 v0, 0x0

    move v1, v0

    move v2, v1

    .line 121
    :goto_0
    iget-object v3, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v4, v3

    if-ge v1, v4, :cond_2

    .line 122
    aget-byte v3, v3, v1

    .line 123
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v4

    if-gt v4, v3, :cond_1

    .line 124
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v4

    if-eq v4, v3, :cond_0

    iget-object v4, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v5

    add-int/2addr v5, v1

    add-int/lit8 v5, v5, 0x1

    aget-byte v4, v4, v5

    const/16 v5, 0x3d

    if-ne v4, v5, :cond_1

    .line 125
    :cond_0
    new-instance v4, Ljava/lang/String;

    iget-object v5, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    add-int/lit8 v6, v1, 0x1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v7

    invoke-direct {v4, v5, v6, v7}, Ljava/lang/String;-><init>([BII)V

    .line 126
    invoke-virtual {p1, v4}, Ljava/lang/String;->compareToIgnoreCase(Ljava/lang/String;)I

    move-result v4

    if-nez v4, :cond_1

    .line 127
    iget-object p1, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    .line 128
    array-length v4, p1

    sub-int/2addr v4, v3

    add-int/lit8 v4, v4, -0x1

    new-array v4, v4, [B

    iput-object v4, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    .line 129
    invoke-static {p1, v0, v4, v0, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    add-int v0, v1, v3

    add-int/lit8 v0, v0, 0x1

    .line 130
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length v4, p1

    sub-int/2addr v4, v1

    sub-int/2addr v4, v3

    add-int/lit8 v4, v4, -0x1

    invoke-static {p1, v0, p0, v1, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    return v2

    :cond_1
    add-int/lit8 v3, v3, 0x1

    and-int/lit16 v3, v3, 0xff

    add-int/2addr v1, v3

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, -0x1

    return p0
.end method

.method public set(Ljava/lang/String;Ljava/lang/String;)V
    .locals 5

    const/4 v0, 0x0

    if-eqz p2, :cond_0

    .line 75
    invoke-virtual {p2}, Ljava/lang/String;->getBytes()[B

    move-result-object p2

    .line 76
    array-length v1, p2

    goto :goto_0

    :cond_0
    const/4 p2, 0x0

    move v1, v0

    :goto_0
    :try_start_0
    const-string v2, "US-ASCII"

    .line 83
    invoke-virtual {p1, v2}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v2
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    .line 89
    :goto_1
    array-length v3, v2

    if-ge v0, v3, :cond_2

    .line 90
    aget-byte v3, v2, v0

    const/16 v4, 0x3d

    if-eq v3, v4, :cond_1

    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 91
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "= is not a valid character in key"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 95
    :cond_2
    array-length v0, v2

    add-int/2addr v0, v1

    const/16 v1, 0xff

    if-ge v0, v1, :cond_4

    .line 99
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->remove(Ljava/lang/String;)I

    move-result p1

    const/4 v0, -0x1

    if-ne p1, v0, :cond_3

    .line 101
    invoke-virtual {p0}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->keyCount()I

    move-result p1

    .line 103
    :cond_3
    invoke-direct {p0, v2, p2, p1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->insert([B[BI)V

    return-void

    .line 96
    :cond_4
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Key and Value length cannot exceed 255 bytes"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 86
    :catch_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "key should be US-ASCII"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public size()I
    .locals 0

    .line 160
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    array-length p0, p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 6

    const/4 v0, 0x0

    const/4 v1, 0x0

    .line 269
    :goto_0
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->getKey(I)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_2

    .line 270
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "{"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 271
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->getValueAsString(I)Ljava/lang/String;

    move-result-object v3

    const-string/jumbo v4, "}"

    if-eqz v3, :cond_0

    .line 273
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "="

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    .line 275
    :cond_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_1
    if-nez v0, :cond_1

    move-object v0, v2

    goto :goto_2

    .line 279
    :cond_1
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    if-eqz v0, :cond_3

    goto :goto_3

    :cond_3
    const-string v0, ""

    :goto_3
    return-object v0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 309
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->mData:[B

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeByteArray([B)V

    return-void
.end method
