.class public final Lcom/android/internal/telephony/NetworkScanRequestTracker;
.super Ljava/lang/Object;
.source "NetworkScanRequestTracker.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;,
        Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;
    }
.end annotation


# static fields
.field private static final CMD_INTERRUPT_NETWORK_SCAN:I = 0x6

.field private static final CMD_START_NETWORK_SCAN:I = 0x1

.field private static final CMD_STOP_NETWORK_SCAN:I = 0x4

.field private static final EVENT_INTERRUPT_NETWORK_SCAN_DONE:I = 0x7

.field private static final EVENT_MODEM_RESET:I = 0x8

.field private static final EVENT_RADIO_UNAVAILABLE:I = 0x9

.field private static final EVENT_RECEIVE_NETWORK_SCAN_RESULT:I = 0x3

.field private static final EVENT_START_NETWORK_SCAN_DONE:I = 0x2

.field private static final EVENT_STOP_NETWORK_SCAN_DONE:I = 0x5

.field private static final TAG:Ljava/lang/String; = "ScanRequestTracker"


# instance fields
.field private final mHandler:Landroid/os/Handler;

.field private final mNextNetworkScanRequestId:Ljava/util/concurrent/atomic/AtomicInteger;

.field private final mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;


# direct methods
.method public static synthetic $r8$lambda$FLHA4goSvT9cI-mxMKDAvJt_7RU(Ljava/util/Set;Landroid/telephony/CellInfo;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->lambda$notifyMessenger$0(Ljava/util/Set;Landroid/telephony/CellInfo;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$SP5v-gsoXQzoyen6d0mH099UaL0(Landroid/telephony/SubscriptionInfo;)Ljava/util/stream/Stream;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->getAllowableMccMncsFromSubscriptionInfo(Landroid/telephony/SubscriptionInfo;)Ljava/util/stream/Stream;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$minterruptNetworkScan(Lcom/android/internal/telephony/NetworkScanRequestTracker;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->interruptNetworkScan(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$misValidScan(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->isValidScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mlogEmptyResultOrException(Lcom/android/internal/telephony/NetworkScanRequestTracker;Landroid/os/AsyncResult;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->logEmptyResultOrException(Landroid/os/AsyncResult;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->notifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 59
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 73
    new-instance v0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;-><init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;)V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mHandler:Landroid/os/Handler;

    .line 120
    new-instance v0, Ljava/util/concurrent/atomic/AtomicInteger;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicInteger;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mNextNetworkScanRequestId:Ljava/util/concurrent/atomic/AtomicInteger;

    .line 121
    new-instance v0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;-><init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler-IA;)V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    return-void
.end method

.method private static doesCellInfoCorrespondToKnownMccMnc(Landroid/telephony/CellInfo;Ljava/util/Collection;)Z
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/telephony/CellInfo;",
            "Ljava/util/Collection<",
            "Ljava/lang/String;",
            ">;)Z"
        }
    .end annotation

    .line 186
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Landroid/telephony/CellInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/CellIdentity;->getMccString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 187
    invoke-virtual {p0}, Landroid/telephony/CellInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getMncString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 188
    invoke-interface {p1, p0}, Ljava/util/Collection;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static getAllowableMccMncsFromSubscriptionInfo(Landroid/telephony/SubscriptionInfo;)Ljava/util/stream/Stream;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/telephony/SubscriptionInfo;",
            ")",
            "Ljava/util/stream/Stream<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/util/List;

    .line 209
    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getEhplmns()Ljava/util/List;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getHplmns()Ljava/util/List;

    move-result-object v1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    invoke-static {v0}, Ljava/util/stream/Stream;->of([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda0;

    invoke-direct {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->flatMap(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 210
    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getMccString()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getMncString()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 211
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getMccString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/telephony/SubscriptionInfo;->getMncString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/util/stream/Stream;->of(Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    invoke-static {v0, p0}, Ljava/util/stream/Stream;->concat(Ljava/util/stream/Stream;Ljava/util/stream/Stream;)Ljava/util/stream/Stream;

    move-result-object v0

    :cond_0
    return-object v0
.end method

.method public static getAllowedMccMncsForLocationRestrictedScan(Landroid/content/Context;)Ljava/util/Set;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 196
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 198
    :try_start_0
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v2

    .line 199
    invoke-virtual {p0}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v3

    .line 200
    invoke-virtual {p0}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object p0

    .line 199
    invoke-virtual {v2, v3, p0}, Lcom/android/internal/telephony/SubscriptionController;->getAvailableSubscriptionInfoList(Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;

    move-result-object p0

    .line 200
    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v2, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda1;

    invoke-direct {v2}, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda1;-><init>()V

    .line 201
    invoke-interface {p0, v2}, Ljava/util/stream/Stream;->flatMap(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 202
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {p0, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Set;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 204
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-object p0

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 205
    throw p0
.end method

.method private interruptNetworkScan(I)V
    .locals 2

    .line 624
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x6

    const/4 v1, 0x0

    invoke-virtual {p0, v0, p1, v1}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method private isValidScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z
    .locals 7

    .line 132
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    const/4 v0, 0x0

    if-eqz p0, :cond_b

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getSpecifiers()[Landroid/telephony/RadioAccessSpecifier;

    move-result-object p0

    if-nez p0, :cond_0

    goto/16 :goto_1

    .line 135
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getSpecifiers()[Landroid/telephony/RadioAccessSpecifier;

    move-result-object p0

    array-length p0, p0

    const/16 v1, 0x8

    if-le p0, v1, :cond_1

    return v0

    .line 138
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getSpecifiers()[Landroid/telephony/RadioAccessSpecifier;

    move-result-object p0

    array-length v2, p0

    move v3, v0

    :goto_0
    const/4 v4, 0x1

    if-ge v3, v2, :cond_5

    aget-object v5, p0, v3

    .line 139
    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v6

    if-eq v6, v4, :cond_2

    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v4

    const/4 v6, 0x2

    if-eq v4, v6, :cond_2

    .line 140
    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v4

    const/4 v6, 0x3

    if-eq v4, v6, :cond_2

    .line 141
    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v4

    const/4 v6, 0x6

    if-eq v4, v6, :cond_2

    return v0

    .line 144
    :cond_2
    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v4

    if-eqz v4, :cond_3

    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v4

    array-length v4, v4

    if-le v4, v1, :cond_3

    return v0

    .line 147
    :cond_3
    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v4

    if-eqz v4, :cond_4

    .line 148
    invoke-virtual {v5}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v4

    array-length v4, v4

    const/16 v5, 0x20

    if-le v4, v5, :cond_4

    return v0

    :cond_4
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 153
    :cond_5
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getSearchPeriodicity()I

    move-result p0

    const/4 v1, 0x5

    if-lt p0, v1, :cond_b

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    .line 154
    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getSearchPeriodicity()I

    move-result p0

    const/16 v1, 0x12c

    if-le p0, v1, :cond_6

    goto/16 :goto_1

    .line 159
    :cond_6
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getMaxSearchTime()I

    move-result p0

    const/16 v1, 0x3c

    if-lt p0, v1, :cond_b

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    .line 160
    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getMaxSearchTime()I

    move-result p0

    const/16 v1, 0xe10

    if-le p0, v1, :cond_7

    goto :goto_1

    .line 164
    :cond_7
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getIncrementalResultsPeriodicity()I

    move-result p0

    if-lt p0, v4, :cond_b

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    .line 166
    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getIncrementalResultsPeriodicity()I

    move-result p0

    const/16 v1, 0xa

    if-le p0, v1, :cond_8

    goto :goto_1

    .line 171
    :cond_8
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getSearchPeriodicity()I

    move-result p0

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/NetworkScanRequest;->getMaxSearchTime()I

    move-result v1

    if-gt p0, v1, :cond_b

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    .line 172
    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getIncrementalResultsPeriodicity()I

    move-result p0

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object v1

    .line 173
    invoke-virtual {v1}, Landroid/telephony/NetworkScanRequest;->getMaxSearchTime()I

    move-result v1

    if-le p0, v1, :cond_9

    goto :goto_1

    .line 177
    :cond_9
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getPlmns()Ljava/util/ArrayList;

    move-result-object p0

    if-eqz p0, :cond_a

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;

    move-result-object p0

    .line 178
    invoke-virtual {p0}, Landroid/telephony/NetworkScanRequest;->getPlmns()Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

    const/16 p1, 0x14

    if-le p0, p1, :cond_a

    return v0

    :cond_a
    return v4

    :cond_b
    :goto_1
    return v0
.end method

.method private static synthetic lambda$notifyMessenger$0(Ljava/util/Set;Landroid/telephony/CellInfo;)Z
    .locals 0

    .line 231
    invoke-static {p1, p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->doesCellInfoCorrespondToKnownMccMnc(Landroid/telephony/CellInfo;Ljava/util/Collection;)Z

    move-result p0

    return p0
.end method

.method private logEmptyResultOrException(Landroid/os/AsyncResult;)V
    .locals 2

    .line 124
    iget-object p0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    const-string v0, "ScanRequestTracker"

    if-nez p0, :cond_0

    const-string p0, "NetworkScanResult: Empty result"

    .line 125
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 127
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "NetworkScanResult: Exception: "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method private notifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;",
            "II",
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;)V"
        }
    .end annotation

    .line 219
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/os/Messenger;

    move-result-object p0

    .line 220
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 221
    iput p2, v0, Landroid/os/Message;->what:I

    .line 222
    iput p3, v0, Landroid/os/Message;->arg1:I

    .line 223
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result p3

    iput p3, v0, Landroid/os/Message;->arg2:I

    if-eqz p4, :cond_1

    const/4 p3, 0x4

    if-ne p2, p3, :cond_0

    .line 227
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    .line 228
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->getAllowedMccMncsForLocationRestrictedScan(Landroid/content/Context;)Ljava/util/Set;

    move-result-object p1

    .line 230
    invoke-interface {p4}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    new-instance p3, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda2;

    invoke-direct {p3}, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda2;-><init>()V

    invoke-interface {p2, p3}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance p3, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda3;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$$ExternalSyntheticLambda3;-><init>(Ljava/util/Set;)V

    .line 231
    invoke-interface {p2, p3}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 232
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p2

    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    move-object p4, p1

    check-cast p4, Ljava/util/List;

    .line 235
    :cond_0
    invoke-interface {p4}, Ljava/util/List;->size()I

    move-result p1

    new-array p1, p1, [Landroid/telephony/CellInfo;

    invoke-interface {p4, p1}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Landroid/telephony/CellInfo;

    .line 236
    new-instance p2, Landroid/os/Bundle;

    invoke-direct {p2}, Landroid/os/Bundle;-><init>()V

    const-string p3, "scanResult"

    .line 237
    invoke-virtual {p2, p3, p1}, Landroid/os/Bundle;->putParcelableArray(Ljava/lang/String;[Landroid/os/Parcelable;)V

    .line 238
    invoke-virtual {v0, p2}, Landroid/os/Message;->setData(Landroid/os/Bundle;)V

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    .line 240
    iput-object p1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 243
    :goto_0
    :try_start_0
    invoke-virtual {p0, v0}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p0

    .line 245
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Exception in notifyMessenger: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ScanRequestTracker"

    invoke-static {p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-void
.end method


# virtual methods
.method public startNetworkScan(ZLandroid/telephony/NetworkScanRequest;Landroid/os/Messenger;Landroid/os/IBinder;Lcom/android/internal/telephony/Phone;IILjava/lang/String;)I
    .locals 14

    move-object v11, p0

    .line 638
    iget-object v0, v11, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mNextNetworkScanRequestId:Ljava/util/concurrent/atomic/AtomicInteger;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicInteger;->getAndIncrement()I

    move-result v12

    .line 639
    new-instance v13, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    move-object v0, v13

    move-object v1, p0

    move-object/from16 v2, p2

    move-object/from16 v3, p3

    move-object/from16 v4, p4

    move v5, v12

    move-object/from16 v6, p5

    move/from16 v7, p6

    move/from16 v8, p7

    move-object/from16 v9, p8

    move v10, p1

    invoke-direct/range {v0 .. v10}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;-><init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;Landroid/telephony/NetworkScanRequest;Landroid/os/Messenger;Landroid/os/IBinder;ILcom/android/internal/telephony/Phone;IILjava/lang/String;Z)V

    .line 643
    iget-object v0, v11, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, v13}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/Message;->sendToTarget()V

    return v12
.end method

.method public stopNetworkScan(II)V
    .locals 2

    .line 654
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    monitor-enter v0

    .line 655
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$fgetmLiveRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    move-result-object v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$fgetmLiveRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v1

    if-ne p1, v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$fgetmLiveRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmUid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v1

    if-eq p2, v1, :cond_1

    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$fgetmPendingRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    move-result-object v1

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$fgetmPendingRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v1

    if-ne p1, v1, :cond_2

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mScheduler:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$fgetmPendingRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmUid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v1

    if-ne p2, v1, :cond_2

    .line 662
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker;->mHandler:Landroid/os/Handler;

    const/4 p2, 0x4

    const/4 v1, 0x0

    invoke-virtual {p0, p2, p1, v1}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    .line 666
    monitor-exit v0

    return-void

    .line 664
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Scan with id: "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " does not exist!"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :catchall_0
    move-exception p0

    .line 666
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
