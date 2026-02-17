.class public final Lcom/android/internal/telephony/util/IpRange;
.super Ljava/lang/Object;
.source "IpRange.java"


# static fields
.field private static final SIGNUM_POSITIVE:I = 0x1


# instance fields
.field private final mEndAddr:[B

.field private final mStartAddr:[B


# direct methods
.method public constructor <init>(Landroid/net/IpPrefix;)V
    .locals 5
    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
        visibility = .enum Lcom/android/net/module/annotation/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/net/module/annotation/VisibleForTesting$Visibility;
    .end annotation

    .line 69
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, "prefix must not be null"

    .line 70
    invoke-static {p1, v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    .line 73
    invoke-virtual {p1}, Landroid/net/IpPrefix;->getRawAddress()[B

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    .line 76
    invoke-virtual {p1}, Landroid/net/IpPrefix;->getRawAddress()[B

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    .line 77
    invoke-virtual {p1}, Landroid/net/IpPrefix;->getPrefixLength()I

    move-result p1

    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    array-length v1, v0

    mul-int/lit8 v1, v1, 0x8

    if-ge p1, v1, :cond_0

    .line 78
    div-int/lit8 v1, p1, 0x8

    aget-byte v2, v0, v1

    const/16 v3, 0x80

    rem-int/lit8 v4, p1, 0x8

    shr-int/2addr v3, v4

    int-to-byte v3, v3

    or-int/2addr v2, v3

    int-to-byte v2, v2

    aput-byte v2, v0, v1

    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method public constructor <init>(Ljava/net/InetAddress;Ljava/net/InetAddress;)V
    .locals 2

    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string/jumbo v0, "startAddr must not be null"

    .line 52
    invoke-static {p1, v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    const-string v0, "endAddr must not be null"

    .line 53
    invoke-static {p2, v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    .line 55
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 58
    invoke-virtual {p1}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object v0

    .line 59
    invoke-virtual {p2}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object v1

    .line 58
    invoke-virtual {v0, v1}, Ljava/math/BigInteger;->compareTo(Ljava/math/BigInteger;)I

    move-result v0

    if-gez v0, :cond_0

    .line 64
    invoke-virtual {p1}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    .line 65
    invoke-virtual {p2}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    return-void

    .line 60
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Invalid range; start address must be before end address"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 56
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Invalid range: Address family mismatch"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static addrToBigInteger([B)Ljava/math/BigInteger;
    .locals 2

    .line 221
    new-instance v0, Ljava/math/BigInteger;

    const/4 v1, 0x1

    invoke-direct {v0, v1, p0}, Ljava/math/BigInteger;-><init>(I[B)V

    return-object v0
.end method

.method private static getAsInetAddress([B)Ljava/net/InetAddress;
    .locals 1

    .line 84
    :try_start_0
    invoke-static {p0}, Ljava/net/InetAddress;->getByAddress([B)Ljava/net/InetAddress;

    move-result-object p0
    :try_end_0
    .catch Ljava/net/UnknownHostException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 88
    :catch_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Address is invalid"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static getSubsetPrefixes(Landroid/net/IpPrefix;)Ljava/util/List;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/net/IpPrefix;",
            ")",
            "Ljava/util/List<",
            "Landroid/net/IpPrefix;",
            ">;"
        }
    .end annotation

    .line 163
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 165
    invoke-virtual {p0}, Landroid/net/IpPrefix;->getPrefixLength()I

    move-result v1

    .line 166
    new-instance v2, Landroid/net/IpPrefix;

    invoke-virtual {p0}, Landroid/net/IpPrefix;->getAddress()Ljava/net/InetAddress;

    move-result-object v3

    add-int/lit8 v4, v1, 0x1

    invoke-direct {v2, v3, v4}, Landroid/net/IpPrefix;-><init>(Ljava/net/InetAddress;I)V

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 168
    invoke-virtual {p0}, Landroid/net/IpPrefix;->getRawAddress()[B

    move-result-object p0

    .line 169
    div-int/lit8 v2, v1, 0x8

    aget-byte v3, p0, v2

    rem-int/lit8 v1, v1, 0x8

    const/16 v5, 0x80

    shr-int v1, v5, v1

    xor-int/2addr v1, v3

    int-to-byte v1, v1

    aput-byte v1, p0, v2

    .line 171
    new-instance v1, Landroid/net/IpPrefix;

    invoke-static {p0}, Lcom/android/internal/telephony/util/IpRange;->getAsInetAddress([B)Ljava/net/InetAddress;

    move-result-object p0

    invoke-direct {v1, p0, v4}, Landroid/net/IpPrefix;-><init>(Ljava/net/InetAddress;I)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object v0
.end method


# virtual methods
.method public asIpPrefixes()Ljava/util/List;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/net/IpPrefix;",
            ">;"
        }
    .end annotation

    .line 120
    iget-object v0, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    array-length v0, v0

    const/4 v1, 0x0

    const/16 v2, 0x10

    if-ne v0, v2, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    move v0, v1

    .line 121
    :goto_0
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 122
    new-instance v4, Ljava/util/LinkedList;

    invoke-direct {v4}, Ljava/util/LinkedList;-><init>()V

    .line 126
    new-instance v5, Landroid/net/IpPrefix;

    if-eqz v0, :cond_1

    new-array v0, v2, [B

    invoke-static {v0}, Lcom/android/internal/telephony/util/IpRange;->getAsInetAddress([B)Ljava/net/InetAddress;

    move-result-object v0

    goto :goto_1

    :cond_1
    const/4 v0, 0x4

    new-array v0, v0, [B

    .line 127
    invoke-static {v0}, Lcom/android/internal/telephony/util/IpRange;->getAsInetAddress([B)Ljava/net/InetAddress;

    move-result-object v0

    :goto_1
    invoke-direct {v5, v0, v1}, Landroid/net/IpPrefix;-><init>(Ljava/net/InetAddress;I)V

    .line 126
    invoke-interface {v4, v5}, Ljava/util/Queue;->add(Ljava/lang/Object;)Z

    .line 130
    :cond_2
    :goto_2
    invoke-interface {v4}, Ljava/util/Queue;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_4

    .line 131
    invoke-interface {v4}, Ljava/util/Queue;->poll()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/IpPrefix;

    .line 132
    new-instance v1, Lcom/android/internal/telephony/util/IpRange;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/util/IpRange;-><init>(Landroid/net/IpPrefix;)V

    .line 136
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/util/IpRange;->containsRange(Lcom/android/internal/telephony/util/IpRange;)Z

    move-result v2

    if-eqz v2, :cond_3

    .line 137
    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_2

    .line 143
    :cond_3
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/util/IpRange;->overlapsRange(Lcom/android/internal/telephony/util/IpRange;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 144
    invoke-static {v0}, Lcom/android/internal/telephony/util/IpRange;->getSubsetPrefixes(Landroid/net/IpPrefix;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v4, v0}, Ljava/util/Queue;->addAll(Ljava/util/Collection;)Z

    goto :goto_2

    :cond_4
    return-object v3
.end method

.method public containsRange(Lcom/android/internal/telephony/util/IpRange;)Z
    .locals 2
    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
        visibility = .enum Lcom/android/net/module/annotation/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/net/module/annotation/VisibleForTesting$Visibility;
    .end annotation

    .line 185
    iget-object v0, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    invoke-static {v0}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object v0

    iget-object v1, p1, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    invoke-static {v1}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/math/BigInteger;->compareTo(Ljava/math/BigInteger;)I

    move-result v0

    if-gtz v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    .line 186
    invoke-static {p0}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object p0

    iget-object p1, p1, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    invoke-static {p1}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/math/BigInteger;->compareTo(Ljava/math/BigInteger;)I

    move-result p0

    if-ltz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 3

    .line 208
    instance-of v0, p1, Lcom/android/internal/telephony/util/IpRange;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 212
    :cond_0
    check-cast p1, Lcom/android/internal/telephony/util/IpRange;

    .line 213
    iget-object v0, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    iget-object v2, p1, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    invoke-static {v0, v2}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object p0, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    iget-object p1, p1, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    .line 214
    invoke-static {p0, p1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p0

    if-eqz p0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method public getEndAddr()Ljava/net/InetAddress;
    .locals 0
    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
        visibility = .enum Lcom/android/net/module/annotation/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/net/module/annotation/VisibleForTesting$Visibility;
    .end annotation

    .line 99
    iget-object p0, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    invoke-static {p0}, Lcom/android/internal/telephony/util/IpRange;->getAsInetAddress([B)Ljava/net/InetAddress;

    move-result-object p0

    return-object p0
.end method

.method public getStartAddr()Ljava/net/InetAddress;
    .locals 0
    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
        visibility = .enum Lcom/android/net/module/annotation/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/net/module/annotation/VisibleForTesting$Visibility;
    .end annotation

    .line 94
    iget-object p0, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    invoke-static {p0}, Lcom/android/internal/telephony/util/IpRange;->getAsInetAddress([B)Ljava/net/InetAddress;

    move-result-object p0

    return-object p0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 203
    iget-object v1, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object p0, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    const/4 v1, 0x1

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public overlapsRange(Lcom/android/internal/telephony/util/IpRange;)Z
    .locals 2
    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
        visibility = .enum Lcom/android/net/module/annotation/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/net/module/annotation/VisibleForTesting$Visibility;
    .end annotation

    .line 197
    iget-object v0, p0, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    invoke-static {v0}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object v0

    iget-object v1, p1, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    invoke-static {v1}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/math/BigInteger;->compareTo(Ljava/math/BigInteger;)I

    move-result v0

    if-gtz v0, :cond_0

    iget-object p1, p1, Lcom/android/internal/telephony/util/IpRange;->mStartAddr:[B

    .line 198
    invoke-static {p1}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object p1

    iget-object p0, p0, Lcom/android/internal/telephony/util/IpRange;->mEndAddr:[B

    invoke-static {p0}, Lcom/android/internal/telephony/util/IpRange;->addrToBigInteger([B)Ljava/math/BigInteger;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/math/BigInteger;->compareTo(Ljava/math/BigInteger;)I

    move-result p0

    if-gtz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
