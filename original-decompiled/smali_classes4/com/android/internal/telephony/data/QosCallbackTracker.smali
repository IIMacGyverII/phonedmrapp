.class public Lcom/android/internal/telephony/data/QosCallbackTracker;
.super Landroid/os/Handler;
.source "QosCallbackTracker.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;
    }
.end annotation


# static fields
.field private static final DEDICATED_BEARER_EVENT_STATE_ADDED:I = 0x1

.field private static final DEDICATED_BEARER_EVENT_STATE_DELETED:I = 0x3

.field private static final DEDICATED_BEARER_EVENT_STATE_MODIFIED:I = 0x2

.field private static final DEDICATED_BEARER_EVENT_STATE_NONE:I


# instance fields
.field private final mCallbacksToFilter:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;",
            ">;"
        }
    .end annotation
.end field

.field private final mLogTag:Ljava/lang/String;

.field private final mNetworkAgent:Lcom/android/internal/telephony/data/NotifyQosSessionInterface;

.field private final mPhoneId:I

.field private final mQosBearerSessions:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Landroid/telephony/data/QosBearerSession;",
            ">;"
        }
    .end annotation
.end field

.field private final mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;


# direct methods
.method public static synthetic $r8$lambda$EzewSNFbqJolOJEcdY3ta-bJa6g(Lcom/android/internal/telephony/data/QosCallbackTracker;ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->lambda$addFilter$0(ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    return-void
.end method

.method public static synthetic $r8$lambda$jo9FVFHpYilRt-ddWjnTKVVGF8U(Lcom/android/internal/telephony/data/QosCallbackTracker;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->lambda$updateSessions$2(Ljava/util/List;)V

    return-void
.end method

.method public static synthetic $r8$lambda$kn9QGwtIbi4fpPPJSWLaYHvUV4A(Lcom/android/internal/telephony/data/QosCallbackTracker;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->lambda$removeFilter$1(I)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/data/NotifyQosSessionInterface;Lcom/android/internal/telephony/Phone;)V
    .locals 2

    .line 98
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 99
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mQosBearerSessions:Ljava/util/Map;

    .line 100
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mCallbacksToFilter:Ljava/util/Map;

    .line 101
    iput-object p1, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mNetworkAgent:Lcom/android/internal/telephony/data/NotifyQosSessionInterface;

    .line 102
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mPhoneId:I

    .line 103
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    .line 104
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "QOSCT-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object v1, p1

    check-cast v1, Landroid/net/NetworkAgent;

    invoke-virtual {v1}, Landroid/net/NetworkAgent;->getNetwork()Landroid/net/Network;

    move-result-object v1

    invoke-virtual {v1}, Landroid/net/Network;->getNetId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mLogTag:Ljava/lang/String;

    .line 106
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p2

    if-eqz p2, :cond_0

    .line 109
    check-cast p1, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    new-instance p2, Lcom/android/internal/telephony/data/QosCallbackTracker$1;

    new-instance v0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/QosCallbackTracker;)V

    invoke-direct {p2, p0, v0}, Lcom/android/internal/telephony/data/QosCallbackTracker$1;-><init>(Lcom/android/internal/telephony/data/QosCallbackTracker;Ljava/util/concurrent/Executor;)V

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->registerCallback(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    :cond_0
    return-void
.end method

.method private doFiltersMatch(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z
    .locals 0

    .line 278
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getMatchingQosBearerFilter(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Landroid/telephony/data/QosBearerFilter;

    move-result-object p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private doesLocalConnectionInfoExist(Landroid/telephony/data/QosBearerSession;)Z
    .locals 1

    .line 447
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQosBearerFilterList()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/data/QosBearerFilter;

    .line 448
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalAddresses()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    .line 449
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 450
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter$PortRange;->isValid()Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private doesRemoteConnectionInfoExist(Landroid/telephony/data/QosBearerSession;)Z
    .locals 1

    .line 458
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQosBearerFilterList()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/data/QosBearerFilter;

    .line 459
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemoteAddresses()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    .line 460
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 461
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter$PortRange;->isValid()Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private getFilterByPrecedence(Landroid/telephony/data/QosBearerFilter;Landroid/telephony/data/QosBearerFilter;)Landroid/telephony/data/QosBearerFilter;
    .locals 1

    if-eqz p1, :cond_0

    .line 323
    invoke-virtual {p2}, Landroid/telephony/data/QosBearerFilter;->getPrecedence()I

    move-result p0

    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getPrecedence()I

    move-result v0

    if-ge p0, v0, :cond_1

    :cond_0
    move-object p1, p2

    :cond_1
    return-object p1
.end method

.method private getMatchingQosBearerFilter(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Landroid/telephony/data/QosBearerFilter;
    .locals 3

    .line 331
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQosBearerFilterList()Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 v0, 0x0

    :cond_0
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/QosBearerFilter;

    .line 332
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getLocalAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    .line 333
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getRemoteAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    .line 334
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    if-eqz v2, :cond_1

    .line 335
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/QosBearerFilter$PortRange;->isValid()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 336
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    if-eqz v2, :cond_1

    .line 337
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/QosBearerFilter$PortRange;->isValid()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 338
    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->matchesByRemoteAndLocalAddress(Landroid/telephony/data/QosBearerFilter;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 339
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getFilterByPrecedence(Landroid/telephony/data/QosBearerFilter;Landroid/telephony/data/QosBearerFilter;)Landroid/telephony/data/QosBearerFilter;

    move-result-object v0

    goto :goto_0

    .line 341
    :cond_1
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getRemoteAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_2

    .line 342
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    if-eqz v2, :cond_2

    .line 343
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/QosBearerFilter$PortRange;->isValid()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 344
    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->matchesByRemoteAddress(Landroid/telephony/data/QosBearerFilter;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 345
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getFilterByPrecedence(Landroid/telephony/data/QosBearerFilter;Landroid/telephony/data/QosBearerFilter;)Landroid/telephony/data/QosBearerFilter;

    move-result-object v0

    goto :goto_0

    .line 347
    :cond_2
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getLocalAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    .line 348
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    if-eqz v2, :cond_0

    .line 349
    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/QosBearerFilter$PortRange;->isValid()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 350
    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->matchesByLocalAddress(Landroid/telephony/data/QosBearerFilter;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 351
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getFilterByPrecedence(Landroid/telephony/data/QosBearerFilter;Landroid/telephony/data/QosBearerFilter;)Landroid/telephony/data/QosBearerFilter;

    move-result-object v0

    goto/16 :goto_0

    :cond_3
    return-object v0
.end method

.method private getQCIFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I
    .locals 0

    .line 427
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object p0

    instance-of p0, p0, Landroid/telephony/data/EpsQos;

    if-eqz p0, :cond_0

    .line 428
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object p0

    check-cast p0, Landroid/telephony/data/EpsQos;

    invoke-virtual {p0}, Landroid/telephony/data/EpsQos;->getQci()I

    move-result p0

    return p0

    .line 429
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object p0

    instance-of p0, p0, Landroid/telephony/data/NrQos;

    if-eqz p0, :cond_1

    .line 430
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object p0

    check-cast p0, Landroid/telephony/data/NrQos;

    invoke-virtual {p0}, Landroid/telephony/data/NrQos;->get5Qi()I

    move-result p0

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private getRatInfoFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I
    .locals 0

    .line 437
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object p0

    instance-of p0, p0, Landroid/telephony/data/EpsQos;

    if-eqz p0, :cond_0

    const/16 p0, 0xd

    return p0

    .line 439
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object p0

    instance-of p0, p0, Landroid/telephony/data/NrQos;

    if-eqz p0, :cond_1

    const/16 p0, 0x14

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private synthetic lambda$addFilter$0(ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V
    .locals 3

    .line 150
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "addFilter: callbackId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/QosCallbackTracker;->log(Ljava/lang/String;)V

    .line 152
    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mCallbacksToFilter:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 155
    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mQosBearerSessions:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/QosBearerSession;

    .line 156
    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->doFiltersMatch(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 157
    invoke-direct {p0, p1, v1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->sendSessionAvailable(ILandroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    .line 159
    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->notifyMetricDedicatedBearerListenerAdded(ILandroid/telephony/data/QosBearerSession;)V

    goto :goto_0

    :cond_1
    return-void
.end method

.method private synthetic lambda$removeFilter$1(I)V
    .locals 2

    .line 172
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "removeFilter: callbackId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/QosCallbackTracker;->log(Ljava/lang/String;)V

    .line 173
    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mCallbacksToFilter:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 174
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->notifyMetricDedicatedBearerListenerRemoved(I)V

    return-void
.end method

.method private synthetic lambda$updateSessions$2(Ljava/util/List;)V
    .locals 16

    move-object/from16 v0, p0

    .line 185
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateSessions: sessions size="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface/range {p1 .. p1}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->log(Ljava/lang/String;)V

    .line 189
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 190
    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    .line 191
    new-instance v3, Ljava/util/HashSet;

    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    .line 192
    invoke-interface/range {p1 .. p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    const/4 v6, 0x0

    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    const/4 v8, 0x1

    if-eqz v7, :cond_6

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/telephony/data/QosBearerSession;

    .line 193
    invoke-virtual {v7}, Landroid/telephony/data/QosBearerSession;->getQosBearerSessionId()I

    move-result v9

    .line 194
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    invoke-interface {v2, v10, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 196
    iget-object v10, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mQosBearerSessions:Ljava/util/Map;

    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v11

    invoke-interface {v10, v11}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Landroid/telephony/data/QosBearerSession;

    .line 197
    iget-object v11, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mCallbacksToFilter:Ljava/util/Map;

    invoke-interface {v11}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v11

    invoke-interface {v11}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v11

    :cond_0
    :goto_1
    invoke-interface {v11}, Ljava/util/Iterator;->hasNext()Z

    move-result v12

    if-eqz v12, :cond_4

    invoke-interface {v11}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Ljava/lang/Integer;

    invoke-virtual {v12}, Ljava/lang/Integer;->intValue()I

    move-result v12

    .line 198
    iget-object v13, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mCallbacksToFilter:Ljava/util/Map;

    invoke-static {v12}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v14

    invoke-interface {v13, v14}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;

    .line 200
    invoke-direct {v0, v7, v13}, Lcom/android/internal/telephony/data/QosCallbackTracker;->doFiltersMatch(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z

    move-result v14

    if-eqz v10, :cond_1

    .line 202
    invoke-direct {v0, v10, v13}, Lcom/android/internal/telephony/data/QosCallbackTracker;->doFiltersMatch(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z

    move-result v15

    if-eqz v15, :cond_1

    move v15, v8

    goto :goto_2

    :cond_1
    const/4 v15, 0x0

    :goto_2
    if-nez v15, :cond_2

    if-eqz v14, :cond_2

    .line 206
    invoke-direct {v0, v12, v7, v13}, Lcom/android/internal/telephony/data/QosCallbackTracker;->sendSessionAvailable(ILandroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    move v6, v8

    :cond_2
    if-eqz v15, :cond_3

    if-eqz v14, :cond_3

    .line 214
    invoke-virtual {v7}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object v15

    invoke-virtual {v10}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object v5

    invoke-virtual {v15, v5}, Landroid/telephony/data/Qos;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_3

    .line 215
    invoke-direct {v0, v12, v7, v13}, Lcom/android/internal/telephony/data/QosCallbackTracker;->sendSessionAvailable(ILandroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    const/4 v5, 0x2

    move v6, v5

    .line 221
    :cond_3
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_0

    if-eqz v14, :cond_0

    .line 223
    invoke-direct {v0, v7, v6, v8}, Lcom/android/internal/telephony/data/QosCallbackTracker;->notifyMetricDedicatedBearerEvent(Landroid/telephony/data/QosBearerSession;IZ)V

    .line 224
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 229
    :cond_4
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_5

    const/4 v5, 0x0

    .line 232
    invoke-direct {v0, v7, v8, v5}, Lcom/android/internal/telephony/data/QosCallbackTracker;->notifyMetricDedicatedBearerEvent(Landroid/telephony/data/QosBearerSession;IZ)V

    .line 233
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    move v6, v8

    .line 235
    :cond_5
    invoke-interface {v1, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto/16 :goto_0

    .line 238
    :cond_6
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 239
    invoke-virtual {v3}, Ljava/util/HashSet;->clear()V

    .line 242
    iget-object v5, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mQosBearerSessions:Ljava/util/Map;

    invoke-interface {v5}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :goto_3
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_a

    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/telephony/data/QosBearerSession;

    .line 243
    invoke-virtual {v6}, Landroid/telephony/data/QosBearerSession;->getQosBearerSessionId()I

    move-result v7

    .line 244
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    invoke-interface {v2, v9}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_9

    .line 245
    iget-object v9, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mCallbacksToFilter:Ljava/util/Map;

    invoke-interface {v9}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v9

    invoke-interface {v9}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :cond_7
    :goto_4
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v10

    const/4 v11, 0x3

    if-eqz v10, :cond_8

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/lang/Integer;

    invoke-virtual {v10}, Ljava/lang/Integer;->intValue()I

    move-result v10

    .line 246
    iget-object v12, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mCallbacksToFilter:Ljava/util/Map;

    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v13

    invoke-interface {v12, v13}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;

    .line 249
    invoke-direct {v0, v6, v12}, Lcom/android/internal/telephony/data/QosCallbackTracker;->doFiltersMatch(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z

    move-result v12

    if-eqz v12, :cond_7

    .line 251
    invoke-direct {v0, v10, v6}, Lcom/android/internal/telephony/data/QosCallbackTracker;->sendSessionLost(ILandroid/telephony/data/QosBearerSession;)V

    .line 252
    invoke-direct {v0, v6, v11, v8}, Lcom/android/internal/telephony/data/QosCallbackTracker;->notifyMetricDedicatedBearerEvent(Landroid/telephony/data/QosBearerSession;IZ)V

    .line 253
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    invoke-virtual {v3, v10}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    goto :goto_4

    .line 256
    :cond_8
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    invoke-interface {v4, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 257
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    invoke-virtual {v3, v9}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_9

    const/4 v9, 0x0

    .line 258
    invoke-direct {v0, v6, v11, v9}, Lcom/android/internal/telephony/data/QosCallbackTracker;->notifyMetricDedicatedBearerEvent(Landroid/telephony/data/QosBearerSession;IZ)V

    .line 259
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-virtual {v3, v6}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    goto :goto_3

    :cond_9
    const/4 v9, 0x0

    goto :goto_3

    .line 265
    :cond_a
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_5
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_b

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/data/QosBearerSession;

    .line 266
    iget-object v3, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mQosBearerSessions:Ljava/util/Map;

    invoke-virtual {v2}, Landroid/telephony/data/QosBearerSession;->getQosBearerSessionId()I

    move-result v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-interface {v3, v5, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_5

    .line 270
    :cond_b
    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_6
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_c

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 271
    iget-object v3, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mQosBearerSessions:Ljava/util/Map;

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v3, v2}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_6

    :cond_c
    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 485
    iget-object p0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private matchesByLocalAddress(Landroid/telephony/data/QosBearerFilter;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z
    .locals 2

    .line 283
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 284
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalAddresses()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/net/LinkAddress;

    .line 285
    invoke-virtual {p0}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object p0

    .line 286
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/QosBearerFilter$PortRange;->getStart()I

    move-result v0

    .line 287
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter$PortRange;->getEnd()I

    move-result p1

    .line 285
    invoke-interface {p2, p0, v0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;->matchesLocalAddress(Ljava/net/InetAddress;II)Z

    move-result p0

    return p0

    :cond_1
    return v0
.end method

.method private matchesByRemoteAddress(Landroid/telephony/data/QosBearerFilter;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z
    .locals 2

    .line 294
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 295
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemoteAddresses()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/net/LinkAddress;

    .line 296
    invoke-virtual {p0}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object p0

    .line 297
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/QosBearerFilter$PortRange;->getStart()I

    move-result v0

    .line 298
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter$PortRange;->getEnd()I

    move-result p1

    .line 296
    invoke-interface {p2, p0, v0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;->matchesRemoteAddress(Ljava/net/InetAddress;II)Z

    move-result p0

    return p0

    :cond_1
    return v0
.end method

.method private matchesByRemoteAndLocalAddress(Landroid/telephony/data/QosBearerFilter;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Z
    .locals 4

    .line 305
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p0

    const/4 v0, 0x0

    if-eqz p0, :cond_2

    .line 306
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p0

    if-nez p0, :cond_0

    goto :goto_0

    .line 307
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemoteAddresses()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_1
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/net/LinkAddress;

    .line 308
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/net/LinkAddress;

    .line 309
    invoke-virtual {v1}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v1

    .line 310
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/QosBearerFilter$PortRange;->getStart()I

    move-result v2

    .line 311
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/data/QosBearerFilter$PortRange;->getEnd()I

    move-result v3

    .line 309
    invoke-interface {p2, v1, v2, v3}, Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;->matchesRemoteAddress(Ljava/net/InetAddress;II)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 312
    invoke-virtual {p0}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object p0

    .line 313
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/QosBearerFilter$PortRange;->getStart()I

    move-result v1

    .line 314
    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter;->getLocalPortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/QosBearerFilter$PortRange;->getEnd()I

    move-result p1

    .line 312
    invoke-interface {p2, p0, v1, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;->matchesLocalAddress(Ljava/net/InetAddress;II)Z

    move-result p0

    if-eqz p0, :cond_2

    const/4 v0, 0x1

    :cond_2
    :goto_0
    return v0
.end method

.method private notifyMetricDedicatedBearerEvent(Landroid/telephony/data/QosBearerSession;IZ)V
    .locals 8

    .line 470
    iget v1, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mPhoneId:I

    .line 471
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getRatInfoFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I

    move-result v2

    .line 472
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getQCIFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I

    move-result v3

    .line 473
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->doesLocalConnectionInfoExist(Landroid/telephony/data/QosBearerSession;)Z

    move-result v5

    .line 474
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->doesRemoteConnectionInfoExist(Landroid/telephony/data/QosBearerSession;)Z

    move-result v6

    .line 476
    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    move v4, p2

    move v7, p3

    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/metrics/RcsStats;->onImsDedicatedBearerEvent(IIIIZZZ)V

    return-void
.end method

.method private notifyMetricDedicatedBearerListenerAdded(ILandroid/telephony/data/QosBearerSession;)V
    .locals 2

    .line 409
    iget v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mPhoneId:I

    .line 410
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getRatInfoFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I

    move-result v1

    .line 411
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getQCIFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I

    move-result p2

    .line 413
    iget-object p0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {p0, p1, v0, v1, p2}, Lcom/android/internal/telephony/metrics/RcsStats;->onImsDedicatedBearerListenerAdded(IIII)V

    return-void
.end method

.method private notifyMetricDedicatedBearerListenerBearerUpdateSession(ILandroid/telephony/data/QosBearerSession;)V
    .locals 6

    .line 418
    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    iget v2, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mPhoneId:I

    .line 419
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getRatInfoFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I

    move-result v3

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getQCIFromSessionInfo(Landroid/telephony/data/QosBearerSession;)I

    move-result v4

    const/4 v5, 0x1

    move v1, p1

    .line 418
    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/metrics/RcsStats;->onImsDedicatedBearerListenerUpdateSession(IIIIZ)V

    return-void
.end method

.method private notifyMetricDedicatedBearerListenerRemoved(I)V
    .locals 0

    .line 423
    iget-object p0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->onImsDedicatedBearerListenerRemoved(I)V

    return-void
.end method

.method private sendSessionAvailable(ILandroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V
    .locals 19

    move-object/from16 v0, p0

    move/from16 v1, p1

    move-object/from16 v2, p2

    move-object/from16 v3, p3

    .line 360
    invoke-direct {v0, v2, v3}, Lcom/android/internal/telephony/data/QosCallbackTracker;->getMatchingQosBearerFilter(Landroid/telephony/data/QosBearerSession;Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)Landroid/telephony/data/QosBearerFilter;

    move-result-object v3

    .line 361
    new-instance v15, Ljava/util/ArrayList;

    invoke-direct {v15}, Ljava/util/ArrayList;-><init>()V

    .line 362
    invoke-virtual {v3}, Landroid/telephony/data/QosBearerFilter;->getRemoteAddresses()Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v4

    if-lez v4, :cond_0

    .line 363
    invoke-virtual {v3}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v4

    if-eqz v4, :cond_0

    .line 364
    new-instance v4, Ljava/net/InetSocketAddress;

    .line 365
    invoke-virtual {v3}, Landroid/telephony/data/QosBearerFilter;->getRemoteAddresses()Ljava/util/List;

    move-result-object v5

    const/4 v6, 0x0

    invoke-interface {v5, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/net/LinkAddress;

    invoke-virtual {v5}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v5

    .line 366
    invoke-virtual {v3}, Landroid/telephony/data/QosBearerFilter;->getRemotePortRange()Landroid/telephony/data/QosBearerFilter$PortRange;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/data/QosBearerFilter$PortRange;->getStart()I

    move-result v3

    invoke-direct {v4, v5, v3}, Ljava/net/InetSocketAddress;-><init>(Ljava/net/InetAddress;I)V

    .line 364
    invoke-interface {v15, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 369
    :cond_0
    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object v3

    instance-of v3, v3, Landroid/telephony/data/EpsQos;

    if-eqz v3, :cond_1

    .line 370
    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object v3

    check-cast v3, Landroid/telephony/data/EpsQos;

    .line 371
    new-instance v14, Landroid/telephony/data/EpsBearerQosSessionAttributes;

    .line 372
    invoke-virtual {v3}, Landroid/telephony/data/EpsQos;->getQci()I

    move-result v5

    .line 373
    invoke-virtual {v3}, Landroid/telephony/data/EpsQos;->getUplinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/Qos$QosBandwidth;->getMaxBitrateKbps()I

    move-result v4

    int-to-long v6, v4

    .line 374
    invoke-virtual {v3}, Landroid/telephony/data/EpsQos;->getDownlinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/Qos$QosBandwidth;->getMaxBitrateKbps()I

    move-result v4

    int-to-long v8, v4

    .line 375
    invoke-virtual {v3}, Landroid/telephony/data/EpsQos;->getDownlinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/Qos$QosBandwidth;->getGuaranteedBitrateKbps()I

    move-result v4

    int-to-long v10, v4

    .line 376
    invoke-virtual {v3}, Landroid/telephony/data/EpsQos;->getUplinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/data/Qos$QosBandwidth;->getGuaranteedBitrateKbps()I

    move-result v3

    int-to-long v12, v3

    move-object v4, v14

    move-object v3, v14

    move-object v14, v15

    invoke-direct/range {v4 .. v14}, Landroid/telephony/data/EpsBearerQosSessionAttributes;-><init>(IJJJJLjava/util/List;)V

    .line 378
    iget-object v4, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mNetworkAgent:Lcom/android/internal/telephony/data/NotifyQosSessionInterface;

    .line 379
    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/QosBearerSession;->getQosBearerSessionId()I

    move-result v5

    .line 378
    invoke-interface {v4, v1, v5, v3}, Lcom/android/internal/telephony/data/NotifyQosSessionInterface;->notifyQosSessionAvailable(IILandroid/net/QosSessionAttributes;)V

    goto :goto_0

    .line 381
    :cond_1
    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object v3

    check-cast v3, Landroid/telephony/data/NrQos;

    .line 382
    new-instance v13, Landroid/telephony/data/NrQosSessionAttributes;

    .line 383
    invoke-virtual {v3}, Landroid/telephony/data/NrQos;->get5Qi()I

    move-result v5

    invoke-virtual {v3}, Landroid/telephony/data/NrQos;->getQfi()I

    move-result v6

    .line 384
    invoke-virtual {v3}, Landroid/telephony/data/NrQos;->getUplinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/Qos$QosBandwidth;->getMaxBitrateKbps()I

    move-result v4

    int-to-long v7, v4

    .line 385
    invoke-virtual {v3}, Landroid/telephony/data/NrQos;->getDownlinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/Qos$QosBandwidth;->getMaxBitrateKbps()I

    move-result v4

    int-to-long v9, v4

    .line 386
    invoke-virtual {v3}, Landroid/telephony/data/NrQos;->getDownlinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/Qos$QosBandwidth;->getGuaranteedBitrateKbps()I

    move-result v4

    int-to-long v11, v4

    .line 387
    invoke-virtual {v3}, Landroid/telephony/data/NrQos;->getUplinkBandwidth()Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/Qos$QosBandwidth;->getGuaranteedBitrateKbps()I

    move-result v4

    move-object/from16 p3, v15

    int-to-long v14, v4

    .line 388
    invoke-virtual {v3}, Landroid/telephony/data/NrQos;->getAveragingWindow()I

    move-result v3

    int-to-long v3, v3

    move-wide/from16 v16, v3

    move-object v4, v13

    move-object v3, v13

    move-wide v13, v14

    move-object/from16 v18, p3

    move-wide/from16 v15, v16

    move-object/from16 v17, v18

    invoke-direct/range {v4 .. v17}, Landroid/telephony/data/NrQosSessionAttributes;-><init>(IIJJJJJLjava/util/List;)V

    .line 389
    iget-object v4, v0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mNetworkAgent:Lcom/android/internal/telephony/data/NotifyQosSessionInterface;

    .line 390
    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/QosBearerSession;->getQosBearerSessionId()I

    move-result v5

    .line 389
    invoke-interface {v4, v1, v5, v3}, Lcom/android/internal/telephony/data/NotifyQosSessionInterface;->notifyQosSessionAvailable(IILandroid/net/QosSessionAttributes;)V

    .line 394
    :goto_0
    invoke-direct/range {p0 .. p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;->notifyMetricDedicatedBearerListenerBearerUpdateSession(ILandroid/telephony/data/QosBearerSession;)V

    .line 396
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "sendSessionAvailable, callbackId="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->log(Ljava/lang/String;)V

    return-void
.end method

.method private sendSessionLost(ILandroid/telephony/data/QosBearerSession;)V
    .locals 2

    .line 400
    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker;->mNetworkAgent:Lcom/android/internal/telephony/data/NotifyQosSessionInterface;

    invoke-virtual {p2}, Landroid/telephony/data/QosBearerSession;->getQosBearerSessionId()I

    move-result v1

    .line 401
    invoke-virtual {p2}, Landroid/telephony/data/QosBearerSession;->getQos()Landroid/telephony/data/Qos;

    move-result-object p2

    instance-of p2, p2, Landroid/telephony/data/EpsQos;

    if-eqz p2, :cond_0

    const/4 p2, 0x1

    goto :goto_0

    :cond_0
    const/4 p2, 0x2

    .line 400
    :goto_0
    invoke-interface {v0, p1, v1, p2}, Lcom/android/internal/telephony/data/NotifyQosSessionInterface;->notifyQosSessionLost(III)V

    .line 403
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "sendSessionLost, callbackId="

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->log(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public addFilter(ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V
    .locals 1

    .line 149
    new-instance v0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, p1, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/QosCallbackTracker;ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    invoke-virtual {p0, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public removeFilter(I)V
    .locals 1

    .line 171
    new-instance v0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda2;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/QosCallbackTracker;I)V

    invoke-virtual {p0, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public updateSessions(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/QosBearerSession;",
            ">;)V"
        }
    .end annotation

    .line 184
    new-instance v0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/QosCallbackTracker;Ljava/util/List;)V

    invoke-virtual {p0, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
