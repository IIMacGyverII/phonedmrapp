.class public Lcom/android/internal/telephony/metrics/NetworkRequestsStats;
.super Ljava/lang/Object;
.source "NetworkRequestsStats.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static addNetworkRequest(Landroid/net/NetworkRequest;I)V
    .locals 3

    .line 35
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getMetricsCollector()Lcom/android/internal/telephony/metrics/MetricsCollector;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getAtomsStorage()Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object v0

    .line 37
    new-instance v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;-><init>()V

    .line 38
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/NetworkRequestsStats;->getCarrierId(I)I

    move-result p1

    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->carrierId:I

    const/4 p1, 0x1

    .line 39
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->requestCount:I

    const/16 v2, 0x22

    .line 41
    invoke-virtual {p0, v2}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 42
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    .line 44
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addNetworkRequestsV2(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V

    :cond_0
    const/16 p1, 0x23

    .line 47
    invoke-virtual {p0, p1}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x2

    .line 48
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    .line 50
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addNetworkRequestsV2(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V

    :cond_1
    const/4 p1, 0x5

    .line 53
    invoke-virtual {p0, p1}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result p1

    if-eqz p1, :cond_2

    const/4 p1, 0x3

    .line 54
    iput p1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    .line 55
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addNetworkRequestsV2(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V

    :cond_2
    const/16 p1, 0x1d

    .line 58
    invoke-virtual {p0, p1}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result p0

    if-eqz p0, :cond_3

    const/4 p0, 0x4

    .line 59
    iput p0, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    .line 60
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addNetworkRequestsV2(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V

    :cond_3
    return-void
.end method

.method private static getCarrierId(I)I
    .locals 0

    .line 66
    invoke-static {p0}, Landroid/telephony/SubscriptionManager;->getPhoneId(I)I

    move-result p0

    .line 67
    invoke-static {p0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 68
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, -0x1

    :goto_0
    return p0
.end method
