.class public final Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;
.super Ljava/lang/Object;
.source "NetworkCapabilitiesUtils.java"


# static fields
.field private static final DISPLAY_TRANSPORT_PRIORITIES:[I

.field private static final FORCE_RESTRICTED_CAPABILITIES:J

.field public static final RESTRICTED_CAPABILITIES:J
    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
    .end annotation
.end field

.field public static final UNRESTRICTED_CAPABILITIES:J
    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const/4 v0, 0x7

    new-array v0, v0, [I

    .line 61
    fill-array-data v0, :array_0

    sput-object v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->DISPLAY_TRANSPORT_PRIORITIES:[I

    const/16 v0, 0xe

    new-array v0, v0, [I

    .line 88
    fill-array-data v0, :array_1

    invoke-static {v0}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->packBitList([I)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->RESTRICTED_CAPABILITIES:J

    const/4 v0, 0x3

    new-array v0, v0, [I

    .line 108
    fill-array-data v0, :array_2

    invoke-static {v0}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->packBitList([I)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->FORCE_RESTRICTED_CAPABILITIES:J

    const/4 v0, 0x4

    new-array v0, v0, [I

    .line 118
    fill-array-data v0, :array_3

    invoke-static {v0}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->packBitList([I)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->UNRESTRICTED_CAPABILITIES:J

    return-void

    :array_0
    .array-data 4
        0x4
        0x0
        0x5
        0x2
        0x1
        0x3
        0x8
    .end array-data

    :array_1
    .array-data 4
        0x1f
        0x5
        0x2
        0xa
        0x1d
        0x3
        0x7
        0x4
        0x17
        0x8
        0x1b
        0x1e
        0x9
        0x21
    .end array-data

    :array_2
    .array-data 4
        0x1d
        0x16
        0x1a
    .end array-data

    :array_3
    .array-data 4
        0xc
        0x0
        0x1
        0x6
    .end array-data
.end method

.method public constructor <init>()V
    .locals 0

    .line 56
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getDisplayTransport([I)I
    .locals 6

    .line 134
    sget-object v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->DISPLAY_TRANSPORT_PRIORITIES:[I

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_1

    aget v4, v0, v3

    .line 135
    invoke-static {p0, v4}, Lcom/android/internal/telephony/util/CollectionUtils;->contains([II)Z

    move-result v5

    if-eqz v5, :cond_0

    return v4

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 140
    :cond_1
    array-length v0, p0

    const/4 v1, 0x1

    if-lt v0, v1, :cond_2

    .line 146
    aget p0, p0, v2

    return p0

    .line 144
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "No transport in the provided array"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static inferRestrictedCapability(Landroid/net/NetworkCapabilities;)Z
    .locals 6

    .line 161
    sget-wide v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->FORCE_RESTRICTED_CAPABILITIES:J

    invoke-static {v0, v1}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->unpackBits(J)[I

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    const/4 v4, 0x1

    if-ge v3, v1, :cond_1

    aget v5, v0, v3

    .line 162
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v5

    if-eqz v5, :cond_0

    return v4

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 169
    :cond_1
    sget-wide v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->UNRESTRICTED_CAPABILITIES:J

    invoke-static {v0, v1}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->unpackBits(J)[I

    move-result-object v0

    array-length v1, v0

    move v3, v2

    :goto_1
    if-ge v3, v1, :cond_3

    aget v5, v0, v3

    .line 170
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v5

    if-eqz v5, :cond_2

    return v2

    :cond_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 176
    :cond_3
    sget-wide v0, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->RESTRICTED_CAPABILITIES:J

    invoke-static {v0, v1}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->unpackBits(J)[I

    move-result-object v0

    array-length v1, v0

    move v3, v2

    :goto_2
    if-ge v3, v1, :cond_5

    aget v5, v0, v3

    .line 177
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v5

    if-eqz v5, :cond_4

    return v4

    :cond_4
    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    :cond_5
    return v2
.end method

.method public static varargs packBitList([I)J
    .locals 2

    .line 210
    invoke-static {p0}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->packBits([I)J

    move-result-wide v0

    return-wide v0
.end method

.method public static packBits([I)J
    .locals 7

    .line 224
    array-length v0, p0

    const-wide/16 v1, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v0, :cond_0

    aget v4, p0, v3

    const-wide/16 v5, 0x1

    shl-long v4, v5, v4

    or-long/2addr v1, v4

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_0
    return-wide v1
.end method

.method public static unpackBits(J)[I
    .locals 7

    .line 188
    invoke-static {p0, p1}, Ljava/lang/Long;->bitCount(J)I

    move-result v0

    .line 189
    new-array v0, v0, [I

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    const-wide/16 v3, 0x0

    cmp-long v3, p0, v3

    if-eqz v3, :cond_1

    const-wide/16 v3, 0x1

    and-long v5, p0, v3

    cmp-long v3, v5, v3

    if-nez v3, :cond_0

    add-int/lit8 v3, v1, 0x1

    .line 193
    aput v2, v0, v1

    move v1, v3

    :cond_0
    const/4 v3, 0x1

    ushr-long/2addr p0, v3

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return-object v0
.end method
