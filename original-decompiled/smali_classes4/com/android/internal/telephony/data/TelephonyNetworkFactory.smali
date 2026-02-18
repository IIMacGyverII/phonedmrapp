.class public Lcom/android/internal/telephony/data/TelephonyNetworkFactory;
.super Lcom/android/internal/telephony/NetworkFactory;
.source "TelephonyNetworkFactory.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;
    }
.end annotation


# static fields
.field protected static final ACTION_NO_OP:I = 0x0

.field protected static final ACTION_RELEASE:I = 0x2

.field protected static final ACTION_REQUEST:I = 0x1

.field protected static final DBG:Z = true

.field public static final EVENT_ACTIVE_PHONE_SWITCH:I = 0x1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final EVENT_DATA_HANDOVER_COMPLETED:I = 0x6

.field private static final EVENT_DATA_HANDOVER_NEEDED:I = 0x5

.field private static final EVENT_NETWORK_RELEASE:I = 0x4

.field private static final EVENT_NETWORK_REQUEST:I = 0x3

.field public static final EVENT_SUBSCRIPTION_CHANGED:I = 0x2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final REQUEST_LOG_SIZE:I = 0x100

.field private static final TELEPHONY_NETWORK_SCORE:I = 0x32


# instance fields
.field public final LOG_TAG:Ljava/lang/String;

.field private mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

.field public final mInternalHandler:Landroid/os/Handler;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mNetworkRequests:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/android/internal/telephony/data/TelephonyNetworkRequest;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mPendingHandovers:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/os/Message;",
            "Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;",
            ">;"
        }
    .end annotation
.end field

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

.field private final mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

.field private mSubscriptionId:I

.field private final mSubscriptionsChangedListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;


# direct methods
.method static bridge synthetic -$$Nest$fgetmPendingHandovers(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)Ljava/util/Map;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPendingHandovers:Ljava/util/Map;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$monActivePhoneSwitch(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->onActivePhoneSwitch()V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataHandoverNeeded(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;IILcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->onDataHandoverNeeded(IILcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataHandoverSetupCompleted(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/net/NetworkRequest;ZIZLcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->onDataHandoverSetupCompleted(Landroid/net/NetworkRequest;ZIZLcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monNeedNetworkFor(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/os/Message;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->onNeedNetworkFor(Landroid/os/Message;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monReleaseNetworkFor(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/os/Message;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->onReleaseNetworkFor(Landroid/os/Message;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monSubIdChange(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->onSubIdChange()V

    return-void
.end method

.method public constructor <init>(Landroid/os/Looper;Lcom/android/internal/telephony/Phone;)V
    .locals 6

    .line 99
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "TelephonyNetworkFactory["

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, "]"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v4, 0x0

    invoke-direct {p0, p1, v0, v1, v4}, Lcom/android/internal/telephony/NetworkFactory;-><init>(Landroid/os/Looper;Landroid/content/Context;Ljava/lang/String;Landroid/net/NetworkCapabilities;)V

    .line 80
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x100

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 84
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    .line 86
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPendingHandovers:Ljava/util/Map;

    .line 127
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$1;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionsChangedListener:Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;

    .line 101
    iput-object p2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 102
    new-instance v1, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mInternalHandler:Landroid/os/Handler;

    .line 104
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    .line 105
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object v5

    iput-object v5, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 107
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v5

    invoke-direct {p0, p1, v5}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->makeNetworkFilter(Lcom/android/internal/telephony/SubscriptionController;I)Landroid/net/NetworkCapabilities;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/NetworkFactory;->setCapabilityFilter(Landroid/net/NetworkCapabilities;)V

    const/16 p1, 0x32

    .line 108
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/NetworkFactory;->setScoreFilter(I)V

    .line 110
    invoke-static {}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getInstance()Lcom/android/internal/telephony/data/PhoneSwitcher;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

    .line 111
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    iput-object v2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->LOG_TAG:Ljava/lang/String;

    const/4 v2, 0x1

    .line 113
    invoke-virtual {p1, v1, v2, v4}, Lcom/android/internal/telephony/data/PhoneSwitcher;->registerForActivePhoneSwitch(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 115
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-nez p1, :cond_0

    .line 116
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getTransportManager()Lcom/android/internal/telephony/dataconnection/TransportManager;

    move-result-object p1

    const/4 v2, 0x5

    invoke-virtual {p1, v1, v2}, Lcom/android/internal/telephony/dataconnection/TransportManager;->registerForHandoverNeededEvent(Landroid/os/Handler;I)V

    :cond_0
    const/4 p1, -0x1

    .line 120
    iput p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionId:I

    .line 121
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->from(Landroid/content/Context;)Landroid/telephony/SubscriptionManager;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/telephony/SubscriptionManager;->addOnSubscriptionsChangedListener(Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;)V

    .line 124
    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkFactory;->register()V

    return-void
.end method

.method private static getAction(ZZ)I
    .locals 0

    if-nez p0, :cond_0

    if-eqz p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    if-eqz p0, :cond_1

    if-nez p1, :cond_1

    const/4 p0, 0x2

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private getTransportTypeFromNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I
    .locals 1

    .line 239
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    .line 241
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result p1

    if-ltz p1, :cond_0

    .line 243
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 244
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result v0

    :cond_0
    return v0

    .line 249
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object p1

    .line 248
    invoke-static {p1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeFromNetworkRequest(Landroid/net/NetworkRequest;)I

    move-result p1

    .line 250
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getCurrentTransport(I)I

    move-result p0

    return p0
.end method

.method private makeNetworkFilter(Lcom/android/internal/telephony/SubscriptionController;I)Landroid/net/NetworkCapabilities;
    .locals 0

    .line 137
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/SubscriptionController;->getSubIdUsingPhoneId(I)I

    move-result p1

    .line 138
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->makeNetworkFilter(I)Landroid/net/NetworkCapabilities;

    move-result-object p0

    return-object p0
.end method

.method private onActivePhoneSwitch()V
    .locals 8

    const-string v0, "onActivePhoneSwitch"

    .line 309
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->logl(Ljava/lang/String;)V

    .line 310
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_8

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 311
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 312
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    const/4 v3, -0x1

    const/4 v4, 0x1

    if-eq v1, v3, :cond_0

    move v1, v4

    goto :goto_1

    :cond_0
    const/4 v1, 0x0

    .line 314
    :goto_1
    iget-object v5, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

    iget-object v6, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 315
    invoke-virtual {v6}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v6

    .line 314
    invoke-virtual {v5, v2, v6}, Lcom/android/internal/telephony/data/PhoneSwitcher;->shouldApplyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z

    move-result v5

    .line 317
    invoke-static {v1, v5}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->getAction(ZZ)I

    move-result v6

    if-nez v6, :cond_1

    goto :goto_0

    .line 321
    :cond_1
    invoke-static {v1, v5}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->getAction(ZZ)I

    move-result v1

    invoke-virtual {p0, v2, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mtkIgnoreCapabilityCheck(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_0

    .line 326
    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "onActivePhoneSwitch: "

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-ne v6, v4, :cond_3

    const-string v7, "Requesting"

    goto :goto_2

    :cond_3
    const-string v7, "Releasing"

    .line 327
    :goto_2
    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " network request "

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 326
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->logl(Ljava/lang/String;)V

    .line 328
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->getTransportTypeFromNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result v1

    if-ne v6, v4, :cond_4

    .line 331
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->getTransportTypeFromNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result v6

    const/4 v7, 0x0

    .line 330
    invoke-direct {p0, v2, v4, v6, v7}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->requestNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;IILandroid/os/Message;)V

    goto :goto_3

    :cond_4
    const/4 v4, 0x2

    if-ne v6, v4, :cond_6

    .line 333
    iget-object v6, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v6}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v6

    if-eqz v6, :cond_5

    .line 334
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    goto :goto_3

    .line 337
    :cond_5
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->getTransportTypeFromNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result v6

    .line 336
    invoke-direct {p0, v2, v4, v6}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;II)V

    .line 341
    :cond_6
    :goto_3
    iget-object v4, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    if-eqz v5, :cond_7

    move v3, v1

    .line 342
    :cond_7
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    .line 341
    invoke-interface {v4, v2, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_0

    :cond_8
    return-void
.end method

.method private onDataHandoverNeeded(IILcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V
    .locals 10

    .line 425
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataHandoverNeeded: apnType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", target transport="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 427
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 425
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    .line 428
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getCurrentTransport(I)I

    move-result v0

    if-ne v0, p2, :cond_0

    .line 429
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "APN type "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " is already on "

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 430
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 429
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    return-void

    .line 435
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    :cond_1
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    const/4 v4, 0x1

    if-eqz v3, :cond_5

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/Map$Entry;

    .line 436
    invoke-interface {v3}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 437
    invoke-interface {v3}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result v6

    const/4 v7, -0x1

    if-eq v6, v7, :cond_2

    move v7, v4

    goto :goto_1

    :cond_2
    move v7, v1

    .line 440
    :goto_1
    invoke-virtual {v5}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object v8

    .line 439
    invoke-static {v8}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeFromNetworkRequest(Landroid/net/NetworkRequest;)I

    move-result v8

    if-ne v8, p1, :cond_1

    if-eqz v7, :cond_1

    if-eq v6, p2, :cond_1

    .line 443
    iget-object v7, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v7, v6}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v7

    if-eqz v7, :cond_4

    .line 446
    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v8

    .line 445
    invoke-virtual {v7, v8}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataConnectionByApnType(Ljava/lang/String;)Lcom/android/internal/telephony/dataconnection/DataConnection;

    move-result-object v7

    if-eqz v7, :cond_3

    .line 447
    invoke-virtual {v7}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isActive()Z

    move-result v8

    if-eqz v8, :cond_3

    .line 448
    iget-object v2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mInternalHandler:Landroid/os/Handler;

    const/4 v3, 0x6

    invoke-virtual {v2, v3}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v2

    .line 450
    invoke-virtual {v2}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object v3

    .line 452
    invoke-virtual {v5}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object v6

    const-string v7, "extra_network_request"

    .line 450
    invoke-virtual {v3, v7, v6}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 453
    iget-object v3, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPendingHandovers:Ljava/util/Map;

    invoke-interface {v3, v2, p3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v3, 0x2

    .line 454
    invoke-direct {p0, v5, v3, p2, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->requestNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;IILandroid/os/Message;)V

    .line 456
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Requested handover "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 458
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ". "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 456
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    move v2, v4

    goto/16 :goto_0

    .line 464
    :cond_3
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "The network request is on transport "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 465
    invoke-static {v6}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, ", but no live data connection. Just move the request to transport "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 467
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, ", dc="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 464
    invoke-virtual {p0, v7}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    .line 469
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v3, v7}, Ljava/util/Map$Entry;->setValue(Ljava/lang/Object;)Ljava/lang/Object;

    .line 470
    invoke-direct {p0, v5, v4, v6}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;II)V

    const/4 v3, 0x0

    .line 472
    invoke-direct {p0, v5, v4, p2, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->requestNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;IILandroid/os/Message;)V

    goto/16 :goto_0

    .line 476
    :cond_4
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "DcTracker on "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v6}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " is not available."

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    goto/16 :goto_0

    :cond_5
    if-nez v2, :cond_6

    const-string p1, "No handover request pending. Handover process is now completed"

    .line 483
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    .line 484
    iget-object p0, p3, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;->callback:Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;

    invoke-interface {p0, v4, v1}, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;->onCompleted(ZZ)V

    :cond_6
    return-void
.end method

.method private onDataHandoverSetupCompleted(Landroid/net/NetworkRequest;ZIZLcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V
    .locals 2

    .line 491
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataHandoverSetupCompleted: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", success="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", targetTransport="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 493
    invoke-static {p3}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", fallback="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 491
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    .line 496
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {v0, p1, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    if-nez p4, :cond_1

    .line 501
    invoke-static {p3}, Lcom/android/internal/telephony/data/DataUtils;->getSourceTransport(I)I

    move-result p1

    if-eqz p2, :cond_0

    const/4 v1, 0x3

    goto :goto_0

    :cond_0
    const/4 v1, 0x2

    .line 513
    :goto_0
    invoke-direct {p0, v0, v1, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;II)V

    .line 520
    iget-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {p1, v0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 522
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_1

    :cond_1
    if-nez p2, :cond_2

    const/4 p1, 0x1

    .line 528
    invoke-direct {p0, v0, p1, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;II)V

    .line 533
    :cond_2
    :goto_1
    iget-object p0, p5, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;->callback:Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;

    invoke-interface {p0, p2, p4}, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;->onCompleted(ZZ)V

    return-void
.end method

.method private onNeedNetworkFor(Landroid/os/Message;)V
    .locals 3

    .line 366
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkRequest;

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {v0, p1, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    .line 368
    iget-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhoneSwitcher:Lcom/android/internal/telephony/data/PhoneSwitcher;

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 369
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    .line 368
    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->shouldApplyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z

    move-result p1

    .line 371
    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    if-eqz p1, :cond_0

    .line 372
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->getTransportTypeFromNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result v2

    goto :goto_0

    :cond_0
    const/4 v2, -0x1

    .line 371
    :goto_0
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, v0, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 375
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onNeedNetworkFor "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " shouldApply "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->logl(Ljava/lang/String;)V

    const/4 v1, 0x1

    if-nez p1, :cond_1

    .line 379
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mtkIgnoreCapabilityCheck(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 382
    :cond_1
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->getTransportTypeFromNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)I

    move-result p1

    const/4 v2, 0x0

    .line 381
    invoke-direct {p0, v0, v1, p1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->requestNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;IILandroid/os/Message;)V

    :cond_2
    return-void
.end method

.method private onReleaseNetworkFor(Landroid/os/Message;)V
    .locals 4

    .line 394
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkRequest;

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {v0, p1, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    .line 396
    iget-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {p1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    const/4 v1, 0x1

    const/4 v2, -0x1

    if-eq p1, v2, :cond_0

    move p1, v1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 399
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {v2, v0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 401
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "onReleaseNetworkFor "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " applied "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->logl(Ljava/lang/String;)V

    const/4 v2, 0x2

    if-nez p1, :cond_1

    .line 405
    invoke-virtual {p0, v0, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mtkIgnoreCapabilityCheck(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 406
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 407
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    goto :goto_1

    .line 415
    :cond_2
    invoke-direct {p0, v0, v1, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;II)V

    .line 417
    invoke-direct {p0, v0, v1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;II)V

    :cond_3
    :goto_1
    return-void
.end method

.method private onSubIdChange()V
    .locals 3

    .line 349
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 350
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    .line 349
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->getSubIdUsingPhoneId(I)I

    move-result v0

    .line 351
    iget v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionId:I

    if-eq v1, v0, :cond_0

    .line 352
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onSubIdChange "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionId:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "->"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->logl(Ljava/lang/String;)V

    .line 353
    iput v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionId:I

    .line 354
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->makeNetworkFilter(I)Landroid/net/NetworkCapabilities;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/NetworkFactory;->setCapabilityFilter(Landroid/net/NetworkCapabilities;)V

    :cond_0
    return-void
.end method

.method private releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 0

    .line 280
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->removeNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    return-void
.end method

.method private releaseNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;II)V
    .locals 1

    .line 287
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 288
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->removeNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    goto :goto_0

    .line 290
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, p3}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 291
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object p0

    .line 292
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object p1

    .line 291
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->releaseNetwork(Landroid/net/NetworkRequest;I)V

    :cond_1
    :goto_0
    return-void
.end method

.method private requestNetworkInternal(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;IILandroid/os/Message;)V
    .locals 2

    .line 265
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object v0

    iget v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mSubscriptionId:I

    invoke-static {v0, v1}, Lcom/android/internal/telephony/metrics/NetworkRequestsStats;->addNetworkRequest(Landroid/net/NetworkRequest;I)V

    .line 268
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 269
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->addNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    goto :goto_0

    .line 271
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, p3}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 272
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object p0

    .line 273
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object p1

    .line 272
    invoke-virtual {p0, p1, p2, p4}, Lcom/android/internal/telephony/dataconnection/DcTracker;->requestNetwork(Landroid/net/NetworkRequest;ILandroid/os/Message;)V

    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 5

    .line 553
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 554
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "TelephonyNetworkFactory-"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 555
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Network Requests:"

    .line 556
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 557
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 558
    iget-object p2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {p2}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 559
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 560
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 561
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    .line 562
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, " applied on "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_1

    :cond_0
    const-string v1, " not applied"

    :goto_1
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 561
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_0

    .line 564
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, "Local logs:"

    .line 565
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 566
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 567
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 568
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 569
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    return-void
.end method

.method protected log(Ljava/lang/String;)V
    .locals 0

    .line 537
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->LOG_TAG:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logl(Ljava/lang/String;)V
    .locals 0

    .line 541
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->log(Ljava/lang/String;)V

    .line 542
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method public makeNetworkFilter(I)Landroid/net/NetworkCapabilities;
    .locals 6
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 150
    new-instance p0, Landroid/net/NetworkCapabilities$Builder;

    invoke-direct {p0}, Landroid/net/NetworkCapabilities$Builder;-><init>()V

    const/4 v0, 0x0

    .line 151
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities$Builder;->addTransportType(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    .line 152
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/4 v0, 0x1

    .line 153
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/4 v1, 0x2

    .line 154
    invoke-virtual {p0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/4 v2, 0x3

    .line 155
    invoke-virtual {p0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/4 v3, 0x4

    .line 156
    invoke-virtual {p0, v3}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/4 v4, 0x5

    .line 157
    invoke-virtual {p0, v4}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/4 v5, 0x7

    .line 158
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x8

    .line 159
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x21

    .line 160
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x9

    .line 161
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x1d

    .line 162
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0xa

    .line 163
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0xd

    .line 164
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x1c

    .line 165
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0xc

    .line 166
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x17

    .line 167
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x22

    .line 168
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x23

    .line 169
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x1f

    .line 171
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    const/16 v5, 0x1e

    .line 172
    invoke-virtual {p0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    .line 174
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    .line 175
    invoke-virtual {p0, v1}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    .line 176
    invoke-virtual {p0, v2}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    .line 177
    invoke-virtual {p0, v3}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    .line 178
    invoke-virtual {p0, v4}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    new-instance v0, Landroid/net/TelephonyNetworkSpecifier$Builder;

    invoke-direct {v0}, Landroid/net/TelephonyNetworkSpecifier$Builder;-><init>()V

    .line 180
    invoke-virtual {v0, p1}, Landroid/net/TelephonyNetworkSpecifier$Builder;->setSubscriptionId(I)Landroid/net/TelephonyNetworkSpecifier$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/TelephonyNetworkSpecifier$Builder;->build()Landroid/net/TelephonyNetworkSpecifier;

    move-result-object p1

    .line 179
    invoke-virtual {p0, p1}, Landroid/net/NetworkCapabilities$Builder;->setNetworkSpecifier(Landroid/net/NetworkSpecifier;)Landroid/net/NetworkCapabilities$Builder;

    move-result-object p0

    .line 181
    invoke-virtual {p0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object p0

    return-object p0
.end method

.method protected mtkIgnoreCapabilityCheck(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public needNetworkFor(Landroid/net/NetworkRequest;)V
    .locals 1

    .line 360
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mInternalHandler:Landroid/os/Handler;

    const/4 v0, 0x3

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    .line 361
    iput-object p1, p0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 362
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public releaseNetworkFor(Landroid/net/NetworkRequest;)V
    .locals 1

    .line 388
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mInternalHandler:Landroid/os/Handler;

    const/4 v0, 0x4

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    .line 389
    iput-object p1, p0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 390
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method
