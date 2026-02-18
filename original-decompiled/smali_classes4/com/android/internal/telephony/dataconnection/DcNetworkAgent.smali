.class public Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;
.super Landroid/net/NetworkAgent;
.source "DcNetworkAgent.java"

# interfaces
.implements Lcom/android/internal/telephony/data/NotifyQosSessionInterface;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;
    }
.end annotation


# static fields
.field private static final EVENT_UNWANTED_TIMEOUT:I = 0x1

.field private static final NETWORK_UNWANTED_ANOMALY_NUM_OCCURRENCES:I = 0xc

.field private static final NETWORK_UNWANTED_ANOMALY_WINDOW_MS:J

.field private static sInterfaceNames:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final sNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;


# instance fields
.field public final keepaliveTracker:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;

.field private mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

.field private final mHandler:Landroid/os/Handler;

.field private final mId:I

.field private final mNetCapsLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private mNetworkCapabilities:Landroid/net/NetworkCapabilities;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mQosCallbackExecutor:Ljava/util/concurrent/Executor;

.field private final mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

.field private final mTag:Ljava/lang/String;

.field private mTransportType:I


# direct methods
.method public static synthetic $r8$lambda$Vlk2QaGhvCMIdm3jNEM1VACGtMY(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;ILandroid/net/QosFilter;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->lambda$onQosCallbackRegistered$0(ILandroid/net/QosFilter;)V

    return-void
.end method

.method public static synthetic $r8$lambda$m6uSxr-dpLvazQSZ6ECF72L3BzU(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->lambda$onQosCallbackUnregistered$1(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$oB25Fbykg1OsTSYM-E30N3IhPlw(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->lambda$updateQosBearerSessions$2(Ljava/util/List;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmId(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$mlogd(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$sfgetsInterfaceNames()Ljava/util/Map;
    .locals 1

    sget-object v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sInterfaceNames:Ljava/util/Map;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 4

    .line 104
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sInterfaceNames:Ljava/util/Map;

    .line 106
    sget-object v0, Ljava/util/concurrent/TimeUnit;->MINUTES:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x5

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->NETWORK_UNWANTED_ANOMALY_WINDOW_MS:J

    .line 219
    new-instance v2, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    const/16 v3, 0xc

    invoke-direct {v2, v0, v1, v3}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    sput-object v2, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/Phone;ILandroid/net/NetworkAgentConfig;Landroid/net/NetworkProvider;I)V
    .locals 9
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 114
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v2

    .line 115
    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v4

    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object v5

    const-string v3, "DcNetworkAgent"

    move-object v0, p0

    move v6, p3

    move-object v7, p4

    move-object v8, p5

    .line 114
    invoke-direct/range {v0 .. v8}, Landroid/net/NetworkAgent;-><init>(Landroid/content/Context;Landroid/os/Looper;Ljava/lang/String;Landroid/net/NetworkCapabilities;Landroid/net/LinkProperties;ILandroid/net/NetworkAgentConfig;Landroid/net/NetworkProvider;)V

    .line 93
    new-instance p3, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;

    invoke-direct {p3, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;-><init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)V

    iput-object p3, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->keepaliveTracker:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;

    .line 97
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object p3

    iput-object p3, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackExecutor:Ljava/util/concurrent/Executor;

    .line 101
    new-instance p3, Lcom/android/internal/telephony/LocalLog;

    const/16 p4, 0x20

    invoke-direct {p3, p4}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p3, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetCapsLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 117
    invoke-virtual {p0}, Landroid/net/NetworkAgent;->register()Landroid/net/Network;

    .line 118
    invoke-virtual {p0}, Landroid/net/NetworkAgent;->getNetwork()Landroid/net/Network;

    move-result-object p3

    invoke-virtual {p3}, Landroid/net/Network;->getNetId()I

    move-result p3

    iput p3, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mId:I

    .line 119
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string p5, "DcNetworkAgent-"

    invoke-virtual {p4, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    iput-object p4, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTag:Ljava/lang/String;

    .line 120
    iput-object p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 121
    new-instance p4, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object p5

    invoke-virtual {p5}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object p5

    invoke-direct {p4, p0, p5}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;-><init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Landroid/os/Looper;)V

    iput-object p4, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mHandler:Landroid/os/Handler;

    .line 133
    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p4

    iput-object p4, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    .line 134
    iput p6, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTransportType:I

    .line 135
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 136
    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object p4

    if-eqz p4, :cond_0

    .line 137
    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object p4

    invoke-virtual {p4}, Landroid/net/LinkProperties;->getInterfaceName()Ljava/lang/String;

    move-result-object p4

    invoke-direct {p0, p3, p4}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->checkDuplicateInterface(ILjava/lang/String;)V

    .line 138
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "created for data connection "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p4

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p4, ", "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 139
    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/LinkProperties;->getInterfaceName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 138
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, "The connection does not have a valid link properties."

    .line 141
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V

    .line 143
    :goto_0
    new-instance p1, Lcom/android/internal/telephony/data/QosCallbackTracker;

    invoke-direct {p1, p0, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker;-><init>(Lcom/android/internal/telephony/data/NotifyQosSessionInterface;Lcom/android/internal/telephony/Phone;)V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

    return-void
.end method

.method private checkDuplicateInterface(ILjava/lang/String;)V
    .locals 3

    .line 160
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sInterfaceNames:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 161
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    invoke-static {p2, v2}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 162
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Duplicate interface "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " is detected. DcNetworkAgent-"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 163
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p2, " already used this interface name."

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 165
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V

    const-string p2, "02f3d3f6-4613-4415-b6cb-8d92c8a938a6"

    .line 168
    invoke-static {p2}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object p2

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 169
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p0

    .line 167
    invoke-static {p2, p1, p0}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    return-void

    .line 173
    :cond_1
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sInterfaceNames:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private getNetworkType()I
    .locals 2

    .line 147
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    .line 150
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTransportType:I

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 153
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private declared-synchronized isOwned(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z
    .locals 2

    monitor-enter p0

    .line 290
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 291
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " called on no-owner DcNetworkAgent!"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 292
    monitor-exit p0

    return v1

    :cond_0
    if-eq v0, p1, :cond_1

    .line 294
    :try_start_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ": This agent belongs to "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 295
    invoke-virtual {p2}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ", ignored the request from "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 294
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 296
    monitor-exit p0

    return v1

    :cond_1
    const/4 p1, 0x1

    .line 298
    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private synthetic lambda$onQosCallbackRegistered$0(ILandroid/net/QosFilter;)V
    .locals 2

    .line 414
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

    new-instance v1, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$2;

    invoke-direct {v1, p0, p2}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$2;-><init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Landroid/net/QosFilter;)V

    invoke-virtual {v0, p1, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->addFilter(ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    return-void
.end method

.method private synthetic lambda$onQosCallbackUnregistered$1(I)V
    .locals 0

    .line 432
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->removeFilter(I)V

    return-void
.end method

.method private synthetic lambda$updateQosBearerSessions$2(Ljava/util/List;)V
    .locals 0

    .line 436
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->updateSessions(Ljava/util/List;)V

    return-void
.end method

.method private logd(Ljava/lang/String;)V
    .locals 0

    .line 485
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 494
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private trackNetworkUnwanted()V
    .locals 2

    .line 252
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->addOccurrence()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "3f578b5c-64e9-11eb-ae93-0242ac130002"

    .line 254
    invoke-static {v0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 255
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p0

    const-string v1, "Network Unwanted called 12 times in 5 minutes."

    .line 253
    invoke-static {v0, v1, p0}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    :cond_0
    return-void
.end method


# virtual methods
.method public declared-synchronized acquireOwnership(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    monitor-enter p0

    .line 191
    :try_start_0
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 192
    iput p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTransportType:I

    .line 193
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " acquired the ownership of this agent."

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 194
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 471
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 472
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 473
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Net caps logs:"

    .line 474
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 475
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetCapsLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 476
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    return-void
.end method

.method public declared-synchronized getDataConnection()Lcom/android/internal/telephony/dataconnection/DataConnection;
    .locals 1

    monitor-enter p0

    .line 216
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method getTag()Ljava/lang/String;
    .locals 0

    .line 180
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTag:Ljava/lang/String;

    return-object p0
.end method

.method public notifyQosSessionAvailable(IILandroid/net/QosSessionAttributes;)V
    .locals 0

    .line 442
    invoke-super {p0, p1, p2, p3}, Landroid/net/NetworkAgent;->sendQosSessionAvailable(IILandroid/net/QosSessionAttributes;)V

    return-void
.end method

.method public notifyQosSessionLost(III)V
    .locals 0

    .line 448
    invoke-super {p0, p1, p2, p3}, Landroid/net/NetworkAgent;->sendQosSessionLost(III)V

    return-void
.end method

.method public declared-synchronized onBandwidthUpdateRequested()V
    .locals 3

    monitor-enter p0

    .line 261
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    if-nez v0, :cond_0

    const-string v0, "onBandwidthUpdateRequested called on no-owner DcNetworkAgent!"

    .line 262
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 263
    monitor-exit p0

    return-void

    .line 266
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLceStatus()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_1

    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTransportType:I

    if-ne v0, v1, :cond_1

    .line 268
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const v2, 0x4000e

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->pullLceData(Landroid/os/Message;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 271
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized onNetworkUnwanted()V
    .locals 5

    monitor-enter p0

    .line 225
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x1

    sget-object v2, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v3, 0x1e

    invoke-virtual {v2, v3, v4}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    .line 226
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->trackNetworkUnwanted()V

    .line 227
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    if-nez v0, :cond_0

    const-string v0, "onNetworkUnwanted found called on no-owner DcNetworkAgent!"

    .line 228
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 229
    monitor-exit p0

    return-void

    .line 232
    :cond_0
    :try_start_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onNetworkUnwanted called. Now tear down the data connection "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 233
    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 232
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V

    .line 234
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v1, "releasedByConnectivityService"

    const/4 v2, 0x2

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->tearDownAll(Ljava/lang/String;ILandroid/os/Message;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 236
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public onQosCallbackRegistered(ILandroid/net/QosFilter;)V
    .locals 2

    .line 414
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackExecutor:Ljava/util/concurrent/Executor;

    new-instance v1, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;ILandroid/net/QosFilter;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method public onQosCallbackUnregistered(I)V
    .locals 2

    .line 432
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackExecutor:Ljava/util/concurrent/Executor;

    new-instance v1, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;I)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method

.method public declared-synchronized onStartSocketKeepalive(ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V
    .locals 4

    monitor-enter p0

    .line 388
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    if-nez v0, :cond_0

    const-string p1, "onStartSocketKeepalive called on no-owner DcNetworkAgent!"

    .line 389
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 390
    monitor-exit p0

    return-void

    .line 393
    :cond_0
    :try_start_1
    instance-of v1, p3, Landroid/net/NattKeepalivePacketData;

    if-eqz v1, :cond_1

    const v1, 0x40015

    .line 395
    invoke-virtual {p2}, Ljava/time/Duration;->getSeconds()J

    move-result-wide v2

    long-to-int p2, v2

    .line 394
    invoke-virtual {v0, v1, p1, p2, p3}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 395
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    :cond_1
    const/16 p2, -0x1e

    .line 397
    invoke-virtual {p0, p1, p2}, Landroid/net/NetworkAgent;->sendSocketKeepaliveEvent(II)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 399
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onStopSocketKeepalive(I)V
    .locals 2

    monitor-enter p0

    .line 403
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    if-nez v0, :cond_0

    const-string p1, "onStopSocketKeepalive called on no-owner DcNetworkAgent!"

    .line 404
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 405
    monitor-exit p0

    return-void

    :cond_0
    const v1, 0x40016

    .line 408
    :try_start_1
    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    .line 409
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 410
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onValidationStatus(ILandroid/net/Uri;)V
    .locals 3

    monitor-enter p0

    .line 275
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    if-nez v0, :cond_0

    const-string p1, "onValidationStatus called on no-owner DcNetworkAgent!"

    .line 276
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 277
    monitor-exit p0

    return-void

    .line 280
    :cond_0
    :try_start_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "validation status: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " with redirection URL: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V

    .line 281
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTransportType:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v0

    if-eqz v0, :cond_1

    const v1, 0x4202c

    .line 283
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 284
    invoke-virtual {v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getCid()I

    move-result v2

    invoke-virtual {p2}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p2

    .line 283
    invoke-virtual {v0, v1, p1, v2, p2}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 285
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 287
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized releaseOwnership(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 2

    monitor-enter p0

    .line 200
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    if-nez v0, :cond_0

    const-string p1, "releaseOwnership called on no-owner DcNetworkAgent!"

    .line 201
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 202
    monitor-exit p0

    return-void

    :cond_0
    if-eq v0, p1, :cond_1

    .line 204
    :try_start_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "releaseOwnership: This agent belongs to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 205
    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", ignored the request from "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 204
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->loge(Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 206
    monitor-exit p0

    return-void

    .line 208
    :cond_1
    :try_start_2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Data connection "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " released the ownership."

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 209
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 210
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized sendLinkProperties(Landroid/net/LinkProperties;Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 2

    monitor-enter p0

    :try_start_0
    const-string v0, "sendLinkProperties"

    .line 354
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->isOwned(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_0

    monitor-exit p0

    return-void

    .line 356
    :cond_0
    :try_start_1
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sInterfaceNames:Ljava/util/Map;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mId:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object p2

    invoke-virtual {p2}, Landroid/net/LinkProperties;->getInterfaceName()Ljava/lang/String;

    move-result-object p2

    invoke-interface {v0, v1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 357
    invoke-virtual {p0, p1}, Landroid/net/NetworkAgent;->sendLinkProperties(Landroid/net/LinkProperties;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 358
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized sendNetworkCapabilities(Landroid/net/NetworkCapabilities;Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 2

    monitor-enter p0

    :try_start_0
    const-string v0, "sendNetworkCapabilities"

    .line 321
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->isOwned(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez p2, :cond_0

    monitor-exit p0

    return-void

    .line 323
    :cond_0
    :try_start_1
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {p1, p2}, Landroid/net/NetworkCapabilities;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_3

    .line 324
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Changed from "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, " to "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ", Data RAT="

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 326
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ", dc="

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 327
    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 328
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V

    .line 329
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetCapsLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    const/16 p2, 0xc

    .line 330
    invoke-virtual {p1, p2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p2

    if-eqz p2, :cond_2

    .line 332
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    if-eqz p2, :cond_1

    const/16 p2, 0x19

    .line 333
    invoke-virtual {p1, p2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    .line 335
    invoke-virtual {v1, p2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p2

    if-eq v0, p2, :cond_2

    .line 337
    :cond_1
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object p2

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 338
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 337
    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeNetworkCapabilitiesChangedEvent(ILandroid/net/NetworkCapabilities;)V

    .line 341
    :cond_2
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    .line 343
    :cond_3
    invoke-virtual {p0, p1}, Landroid/net/NetworkAgent;->sendNetworkCapabilities(Landroid/net/NetworkCapabilities;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 344
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized sendNetworkScore(ILcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 1

    monitor-enter p0

    :try_start_0
    const-string v0, "sendNetworkScore"

    .line 367
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->isOwned(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez p2, :cond_0

    monitor-exit p0

    return-void

    .line 368
    :cond_0
    :try_start_1
    invoke-virtual {p0, p1}, Landroid/net/NetworkAgent;->sendNetworkScore(I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 369
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 453
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DcNetworkAgent-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mDataConnection="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 456
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    move-object v1, v2

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " mTransportType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mTransportType:I

    .line 458
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 459
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mDataConnection:Lcom/android/internal/telephony/dataconnection/DataConnection;

    if-eqz v1, :cond_1

    invoke-virtual {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object v2

    :cond_1
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " mNetworkCapabilities="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public declared-synchronized unregister(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 2

    monitor-enter p0

    :try_start_0
    const-string/jumbo v0, "unregister"

    .line 377
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->isOwned(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez p1, :cond_0

    monitor-exit p0

    return-void

    .line 379
    :cond_0
    :try_start_1
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 380
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Unregister from connectivity service. "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sInterfaceNames:Ljava/util/Map;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mId:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " removed."

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->logd(Ljava/lang/String;)V

    .line 381
    sget-object p1, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sInterfaceNames:Ljava/util/Map;

    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mId:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 382
    invoke-super {p0}, Landroid/net/NetworkAgent;->unregister()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 383
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized updateLegacySubtype(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 1

    monitor-enter p0

    :try_start_0
    const-string/jumbo v0, "updateLegacySubtype"

    .line 307
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->isOwned(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez p1, :cond_0

    monitor-exit p0

    return-void

    .line 309
    :cond_0
    :try_start_1
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->getNetworkType()I

    move-result p1

    .line 310
    invoke-static {p1}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, p1, v0}, Landroid/net/NetworkAgent;->setLegacySubtype(ILjava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 311
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method updateQosBearerSessions(Ljava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/QosBearerSession;",
            ">;)V"
        }
    .end annotation

    .line 436
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->mQosCallbackExecutor:Ljava/util/concurrent/Executor;

    new-instance v1, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/util/List;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method
