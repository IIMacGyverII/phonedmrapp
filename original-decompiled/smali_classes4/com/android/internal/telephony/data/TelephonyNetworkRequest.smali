.class public Lcom/android/internal/telephony/data/TelephonyNetworkRequest;
.super Ljava/lang/Object;
.source "TelephonyNetworkRequest.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/TelephonyNetworkRequest$NetCapabilityAttribute;,
        Lcom/android/internal/telephony/data/TelephonyNetworkRequest$RequestState;
    }
.end annotation


# static fields
.field public static final CAPABILITY_ATTRIBUTE_APN_SETTING:I = 0x1

.field private static final CAPABILITY_ATTRIBUTE_MAP:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field public static final CAPABILITY_ATTRIBUTE_NONE:I = 0x0

.field public static final CAPABILITY_ATTRIBUTE_TRAFFIC_DESCRIPTOR_DNN:I = 0x2

.field public static final CAPABILITY_ATTRIBUTE_TRAFFIC_DESCRIPTOR_OS_APP_ID:I = 0x4

.field public static final REQUEST_STATE_SATISFIED:I = 0x1

.field public static final REQUEST_STATE_UNSATISFIED:I


# instance fields
.field private mAttachedDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

.field private final mCapabilitiesAttributes:I

.field private final mCreatedTimeMillis:J

.field private final mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

.field private mEvaluation:Lcom/android/internal/telephony/data/DataEvaluation;

.field private final mNativeNetworkRequest:Landroid/net/NetworkRequest;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private mPriority:I

.field private mState:I


# direct methods
.method public static synthetic $r8$lambda$Ol1GYf-Y2sai0Qm3z9cvR6XnR4k(Ljava/lang/Integer;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->lambda$canBeSatisfiedBy$0(Ljava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$iynE33RZjKcIeioxLAOauhROcHA(Ljava/lang/Integer;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->lambda$getOsAppId$2(Ljava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$m0ip_lMWZBDQ7716nhbE4aecc2U(Ljava/lang/Integer;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->lambda$getApnTypeNetworkCapability$1(Ljava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method static constructor <clinit>()V
    .locals 9

    const/16 v0, 0xf

    new-array v0, v0, [Ljava/util/Map$Entry;

    .line 101
    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/4 v2, 0x0

    .line 102
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    const/4 v4, 0x3

    .line 103
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-direct {v1, v3, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/4 v2, 0x1

    .line 104
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 105
    invoke-direct {v1, v3, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/4 v2, 0x2

    .line 106
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 107
    invoke-direct {v1, v3, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    .line 109
    invoke-direct {v1, v5, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v4

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/4 v2, 0x4

    .line 110
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 111
    invoke-direct {v1, v3, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/4 v2, 0x5

    .line 112
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v6, 0x7

    .line 113
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-direct {v1, v4, v7}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v2, 0x9

    .line 115
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    .line 116
    invoke-direct {v1, v4, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    const/4 v4, 0x6

    aput-object v1, v0, v4

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v4, 0xa

    .line 117
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    .line 118
    invoke-direct {v1, v8, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v6

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v6, 0xc

    .line 119
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    .line 120
    invoke-direct {v1, v8, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    const/16 v8, 0x8

    aput-object v1, v0, v8

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v8, 0x17

    .line 121
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    .line 122
    invoke-direct {v1, v8, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v2, 0x1d

    .line 123
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 124
    invoke-direct {v1, v2, v7}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v4

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v2, 0x1e

    .line 126
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 127
    invoke-direct {v1, v2, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    const/16 v2, 0xb

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v2, 0x1f

    .line 128
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 129
    invoke-direct {v1, v2, v5}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    aput-object v1, v0, v6

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v2, 0x22

    .line 130
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 131
    invoke-direct {v1, v2, v3}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    const/16 v2, 0xd

    aput-object v1, v0, v2

    new-instance v1, Ljava/util/AbstractMap$SimpleImmutableEntry;

    const/16 v2, 0x23

    .line 132
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 133
    invoke-direct {v1, v2, v3}, Ljava/util/AbstractMap$SimpleImmutableEntry;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    const/16 v2, 0xe

    aput-object v1, v0, v2

    .line 101
    invoke-static {v0}, Ljava/util/Map;->ofEntries([Ljava/util/Map$Entry;)Ljava/util/Map;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->CAPABILITY_ATTRIBUTE_MAP:Ljava/util/Map;

    return-void
.end method

.method public constructor <init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V
    .locals 7

    .line 190
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 191
    iput-object p2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 192
    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    .line 195
    invoke-virtual {p1}, Landroid/net/NetworkRequest;->getCapabilities()[I

    move-result-object p1

    array-length v0, p1

    const/4 v1, 0x0

    move v2, v1

    move v3, v2

    :goto_0
    if-ge v2, v0, :cond_0

    aget v4, p1, v2

    .line 196
    sget-object v5, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->CAPABILITY_ATTRIBUTE_MAP:Ljava/util/Map;

    .line 197
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    .line 196
    invoke-interface {v5, v4, v6}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    or-int/2addr v3, v4

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 199
    :cond_0
    iput v3, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mCapabilitiesAttributes:I

    .line 201
    iput v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mPriority:I

    const/4 p1, 0x0

    .line 202
    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mAttachedDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    .line 205
    iput v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mState:I

    .line 206
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mCreatedTimeMillis:J

    .line 207
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 208
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 209
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->updatePriority()V

    goto :goto_1

    .line 211
    :cond_1
    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    :goto_1
    return-void
.end method

.method private static synthetic lambda$canBeSatisfiedBy$0(Ljava/lang/Integer;)Z
    .locals 0

    .line 283
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

.method private static synthetic lambda$getApnTypeNetworkCapability$1(Ljava/lang/Integer;)Z
    .locals 0

    .line 331
    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToApnType(I)I

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$getOsAppId$2(Ljava/lang/Integer;)Z
    .locals 3

    .line 422
    sget-object v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->CAPABILITY_ATTRIBUTE_MAP:Ljava/util/Map;

    const/4 v1, 0x0

    .line 423
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 422
    invoke-interface {v0, p0, v2}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    and-int/lit8 p0, p0, 0x4

    if-eqz p0, :cond_0

    const/4 v1, 0x1

    :cond_0
    return v1
.end method

.method private static requestStateToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    .line 451
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "SATISFIED"

    return-object p0

    :cond_1
    const-string p0, "UNSATISFIED"

    return-object p0
.end method


# virtual methods
.method public canBeSatisfiedBy(Landroid/net/NetworkCapabilities;)Z
    .locals 0

    .line 240
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0, p1}, Landroid/net/NetworkRequest;->canBeSatisfiedBy(Landroid/net/NetworkCapabilities;)Z

    move-result p0

    return p0
.end method

.method public canBeSatisfiedBy(Landroid/telephony/data/DataProfile;)Z
    .locals 3

    const/4 v0, 0x4

    .line 265
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    .line 266
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getOsAppId()Landroid/telephony/data/TrafficDescriptor$OsAppId;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 269
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getOsAppId()Landroid/telephony/data/TrafficDescriptor$OsAppId;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/TrafficDescriptor$OsAppId;->getBytes()[B

    move-result-object v0

    .line 270
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object v2

    .line 269
    invoke-static {v0, v2}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0

    if-eqz v0, :cond_0

    return v1

    .line 277
    :cond_0
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v0

    if-nez v0, :cond_1

    const/4 v0, 0x2

    .line 278
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 279
    :cond_1
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 281
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object p0

    invoke-static {p0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda0;-><init>()V

    .line 282
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda1;-><init>()V

    .line 283
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 284
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    const/16 v0, 0x4000

    .line 293
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const/16 v0, 0x11

    .line 294
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 297
    :cond_2
    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda2;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda2;-><init>(Landroid/telephony/data/ApnSetting;)V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->allMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0

    :cond_3
    const/4 p0, 0x0

    return p0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 2

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    if-eqz p1, :cond_2

    .line 468
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    if-eq v0, v1, :cond_1

    goto :goto_0

    .line 469
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 471
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    iget-object p1, p1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0, p1}, Landroid/net/NetworkRequest;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0

    :cond_2
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method public getApnTypeNetworkCapability()I
    .locals 3

    const/4 v0, 0x1

    .line 329
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v0

    const/4 v1, -0x1

    if-nez v0, :cond_0

    return v1

    .line 330
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda5;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda5;-><init>()V

    .line 331
    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 332
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda8;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda8;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    invoke-static {v2}, Ljava/util/Comparator;->comparingInt(Ljava/util/function/ToIntFunction;)Ljava/util/Comparator;

    move-result-object p0

    invoke-interface {v0, p0}, Ljava/util/stream/Stream;->max(Ljava/util/Comparator;)Ljava/util/Optional;

    move-result-object p0

    .line 333
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method public getAttachedNetwork()Lcom/android/internal/telephony/data/DataNetwork;
    .locals 0

    .line 356
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mAttachedDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    return-object p0
.end method

.method public getCapabilities()[I
    .locals 0

    .line 226
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0}, Landroid/net/NetworkRequest;->getCapabilities()[I

    move-result-object p0

    return-object p0
.end method

.method public getCapabilityDifferentiator()I
    .locals 2

    const/16 v0, 0x1d

    .line 392
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 393
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0}, Landroid/net/NetworkRequest;->getEnterpriseIds()[I

    move-result-object p0

    .line 395
    array-length v0, p0

    if-lez v0, :cond_0

    aget p0, p0, v1

    return p0

    :cond_0
    return v1
.end method

.method public getNativeNetworkRequest()Landroid/net/NetworkRequest;
    .locals 0

    .line 339
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    return-object p0
.end method

.method public getNetworkSpecifier()Landroid/net/NetworkSpecifier;
    .locals 0

    .line 219
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0}, Landroid/net/NetworkRequest;->getNetworkSpecifier()Landroid/net/NetworkSpecifier;

    move-result-object p0

    return-object p0
.end method

.method public getOsAppId()Landroid/telephony/data/TrafficDescriptor$OsAppId;
    .locals 4

    const/4 v0, 0x4

    .line 416
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 421
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda4;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda4;-><init>()V

    .line 422
    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 425
    invoke-interface {v0}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object v0

    const/4 v2, -0x1

    .line 426
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    if-ne v0, v2, :cond_1

    return-object v1

    .line 430
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilityDifferentiator()I

    move-result p0

    if-lez p0, :cond_2

    .line 432
    new-instance v1, Landroid/telephony/data/TrafficDescriptor$OsAppId;

    sget-object v2, Landroid/telephony/data/TrafficDescriptor$OsAppId;->ANDROID_OS_ID:Ljava/util/UUID;

    .line 433
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v2, v0, p0}, Landroid/telephony/data/TrafficDescriptor$OsAppId;-><init>(Ljava/util/UUID;Ljava/lang/String;I)V

    return-object v1

    .line 435
    :cond_2
    new-instance p0, Landroid/telephony/data/TrafficDescriptor$OsAppId;

    sget-object v1, Landroid/telephony/data/TrafficDescriptor$OsAppId;->ANDROID_OS_ID:Ljava/util/UUID;

    .line 436
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v1, v0}, Landroid/telephony/data/TrafficDescriptor$OsAppId;-><init>(Ljava/util/UUID;Ljava/lang/String;)V

    return-object p0
.end method

.method public getPriority()I
    .locals 0

    .line 308
    iget p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mPriority:I

    return p0
.end method

.method public getState()I
    .locals 0

    .line 372
    iget p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mState:I

    return p0
.end method

.method public hasAttribute(I)Z
    .locals 0

    .line 253
    iget p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mCapabilitiesAttributes:I

    and-int/2addr p0, p1

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public hasCapability(I)Z
    .locals 0

    .line 233
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0, p1}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result p0

    return p0
.end method

.method public hashCode()I
    .locals 0

    .line 477
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0}, Landroid/net/NetworkRequest;->hashCode()I

    move-result p0

    return p0
.end method

.method public isMeteredRequest()Z
    .locals 2

    .line 405
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    if-eqz v0, :cond_0

    .line 406
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object v1

    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result p0

    .line 405
    invoke-virtual {v0, v1, p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isAnyMeteredCapability([IZ)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public setAttachedNetwork(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 348
    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mAttachedDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    return-void
.end method

.method public setEvaluation(Lcom/android/internal/telephony/data/DataEvaluation;)V
    .locals 0

    .line 381
    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mEvaluation:Lcom/android/internal/telephony/data/DataEvaluation;

    return-void
.end method

.method public setState(I)V
    .locals 0

    .line 365
    iput p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mState:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 457
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {v1}, Landroid/net/NetworkRequest;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mPriority="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mPriority:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mState:I

    .line 458
    invoke-static {v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->requestStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mAttachedDataNetwork="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 459
    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mAttachedDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    if-eqz v1, :cond_0

    .line 460
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataNetwork;->name()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", isMetered="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->isMeteredRequest()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", created time="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mCreatedTimeMillis:J

    .line 461
    invoke-static {v1, v2}, Lcom/android/internal/telephony/data/DataUtils;->elapsedTimeToString(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", evaluation result="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mEvaluation:Lcom/android/internal/telephony/data/DataEvaluation;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public updatePriority()V
    .locals 3

    .line 315
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mNativeNetworkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {v0}, Landroid/net/NetworkRequest;->getCapabilities()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 316
    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda3;

    invoke-direct {v2, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    invoke-interface {v0, v2}, Ljava/util/stream/IntStream;->map(Ljava/util/function/IntUnaryOperator;)Ljava/util/stream/IntStream;

    move-result-object v0

    .line 317
    invoke-interface {v0}, Ljava/util/stream/IntStream;->max()Ljava/util/OptionalInt;

    move-result-object v0

    const/4 v1, 0x0

    .line 318
    invoke-virtual {v0, v1}, Ljava/util/OptionalInt;->orElse(I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->mPriority:I

    return-void
.end method
