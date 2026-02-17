.class Lcom/android/internal/telephony/NetworkFactoryImpl;
.super Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;
.source "NetworkFactoryImpl.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;
    }
.end annotation


# static fields
.field private static final CMD_CANCEL_REQUEST:I = 0x2

.field private static final CMD_LISTEN_TO_ALL_REQUESTS:I = 0x6

.field private static final CMD_OFFER_NETWORK:I = 0x5

.field private static final CMD_REQUEST_NETWORK:I = 0x1

.field private static final CMD_SET_FILTER:I = 0x4

.field private static final CMD_SET_SCORE:I = 0x3

.field private static final DBG:Z = true

.field private static final INVINCIBLE_SCORE:Landroid/net/NetworkScore;

.field private static final VDBG:Z = false


# instance fields
.field private final mExecutor:Ljava/util/concurrent/Executor;

.field private final mNetworkRequests:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/net/NetworkRequest;",
            "Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;",
            ">;"
        }
    .end annotation
.end field

.field private final mRequestCallback:Landroid/net/NetworkProvider$NetworkOfferCallback;

.field private mScore:Landroid/net/NetworkScore;


# direct methods
.method public static synthetic $r8$lambda$7OXkV-VT2AFBeAc_W2dn4icV17I(Lcom/android/internal/telephony/NetworkFactoryImpl;Ljava/lang/Runnable;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->lambda$new$0(Ljava/lang/Runnable;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleAddRequest(Lcom/android/internal/telephony/NetworkFactoryImpl;Landroid/net/NetworkRequest;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleAddRequest(Landroid/net/NetworkRequest;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleRemoveRequest(Lcom/android/internal/telephony/NetworkFactoryImpl;Landroid/net/NetworkRequest;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleRemoveRequest(Landroid/net/NetworkRequest;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 2

    .line 56
    new-instance v0, Landroid/net/NetworkScore$Builder;

    invoke-direct {v0}, Landroid/net/NetworkScore$Builder;-><init>()V

    const/16 v1, 0x3e8

    .line 57
    invoke-virtual {v0, v1}, Landroid/net/NetworkScore$Builder;->setLegacyInt(I)Landroid/net/NetworkScore$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/NetworkScore$Builder;->build()Landroid/net/NetworkScore;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/NetworkFactoryImpl;->INVINCIBLE_SCORE:Landroid/net/NetworkScore;

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/NetworkFactory;Landroid/os/Looper;Landroid/content/Context;Landroid/net/NetworkCapabilities;)V
    .locals 0

    if-eqz p4, :cond_0

    goto :goto_0

    .line 134
    :cond_0
    invoke-static {}, Landroid/net/NetworkCapabilities$Builder;->withoutDefaultCapabilities()Landroid/net/NetworkCapabilities$Builder;

    move-result-object p4

    invoke-virtual {p4}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object p4

    .line 132
    :goto_0
    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;-><init>(Lcom/android/internal/telephony/NetworkFactory;Landroid/os/Looper;Landroid/content/Context;Landroid/net/NetworkCapabilities;)V

    .line 109
    new-instance p1, Ljava/util/LinkedHashMap;

    invoke-direct {p1}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    .line 112
    new-instance p1, Landroid/net/NetworkScore$Builder;

    invoke-direct {p1}, Landroid/net/NetworkScore$Builder;-><init>()V

    const/4 p2, 0x0

    invoke-virtual {p1, p2}, Landroid/net/NetworkScore$Builder;->setLegacyInt(I)Landroid/net/NetworkScore$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/NetworkScore$Builder;->build()Landroid/net/NetworkScore;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mScore:Landroid/net/NetworkScore;

    .line 114
    new-instance p1, Lcom/android/internal/telephony/NetworkFactoryImpl$1;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/NetworkFactoryImpl$1;-><init>(Lcom/android/internal/telephony/NetworkFactoryImpl;)V

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mRequestCallback:Landroid/net/NetworkProvider$NetworkOfferCallback;

    .line 125
    new-instance p1, Lcom/android/internal/telephony/NetworkFactoryImpl$$ExternalSyntheticLambda0;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/NetworkFactoryImpl$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/NetworkFactoryImpl;)V

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mExecutor:Ljava/util/concurrent/Executor;

    return-void
.end method

.method private handleAddRequest(Landroid/net/NetworkRequest;)V
    .locals 3

    .line 238
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;

    if-nez v0, :cond_0

    .line 240
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mParent:Lcom/android/internal/telephony/NetworkFactory;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "got request "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/NetworkFactory;->log(Ljava/lang/String;)V

    .line 241
    new-instance v0, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;-><init>(Landroid/net/NetworkRequest;)V

    .line 242
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    iget-object v2, v0, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;->request:Landroid/net/NetworkRequest;

    invoke-interface {v1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 248
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mParent:Lcom/android/internal/telephony/NetworkFactory;

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/NetworkFactory;->acceptRequest(Landroid/net/NetworkRequest;)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 v1, 0x1

    .line 249
    iput-boolean v1, v0, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;->requested:Z

    .line 250
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mParent:Lcom/android/internal/telephony/NetworkFactory;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/NetworkFactory;->needNetworkFor(Landroid/net/NetworkRequest;)V

    :cond_1
    return-void
.end method

.method private handleOfferNetwork(Landroid/net/NetworkScore;)V
    .locals 3

    .line 183
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mProvider:Landroid/net/NetworkProvider;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mCapabilityFilter:Landroid/net/NetworkCapabilities;

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mExecutor:Ljava/util/concurrent/Executor;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mRequestCallback:Landroid/net/NetworkProvider$NetworkOfferCallback;

    invoke-virtual {v0, p1, v1, v2, p0}, Landroid/net/NetworkProvider;->registerNetworkOffer(Landroid/net/NetworkScore;Landroid/net/NetworkCapabilities;Ljava/util/concurrent/Executor;Landroid/net/NetworkProvider$NetworkOfferCallback;)V

    return-void
.end method

.method private handleRemoveRequest(Landroid/net/NetworkRequest;)V
    .locals 2

    .line 255
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;

    if-eqz v0, :cond_0

    .line 257
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {v1, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 258
    iget-boolean p1, v0, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;->requested:Z

    if-eqz p1, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mParent:Lcom/android/internal/telephony/NetworkFactory;

    iget-object p1, v0, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;->request:Landroid/net/NetworkRequest;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/NetworkFactory;->releaseNetworkFor(Landroid/net/NetworkRequest;)V

    :cond_0
    return-void
.end method

.method private handleSetFilter(Landroid/net/NetworkCapabilities;)V
    .locals 1

    .line 269
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mCapabilityFilter:Landroid/net/NetworkCapabilities;

    invoke-virtual {p1, v0}, Landroid/net/NetworkCapabilities;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 270
    :cond_0
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mCapabilityFilter:Landroid/net/NetworkCapabilities;

    .line 271
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mParent:Lcom/android/internal/telephony/NetworkFactory;

    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkFactory;->reevaluateAllRequests()V

    return-void
.end method

.method private handleSetScore(Landroid/net/NetworkScore;)V
    .locals 1

    .line 263
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mScore:Landroid/net/NetworkScore;

    invoke-virtual {v0, p1}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 264
    :cond_0
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mScore:Landroid/net/NetworkScore;

    .line 265
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mParent:Lcom/android/internal/telephony/NetworkFactory;

    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkFactory;->reevaluateAllRequests()V

    return-void
.end method

.method private synthetic lambda$new$0(Ljava/lang/Runnable;)V
    .locals 0

    .line 125
    invoke-virtual {p0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private register(Ljava/lang/String;Z)V
    .locals 3

    .line 152
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mProvider:Landroid/net/NetworkProvider;

    if-nez v0, :cond_1

    .line 155
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mParent:Lcom/android/internal/telephony/NetworkFactory;

    const-string v1, "Registering NetworkFactory"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/NetworkFactory;->log(Ljava/lang/String;)V

    .line 157
    new-instance v0, Lcom/android/internal/telephony/NetworkFactoryImpl$2;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v0, p0, v1, v2, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl$2;-><init>(Lcom/android/internal/telephony/NetworkFactoryImpl;Landroid/content/Context;Landroid/os/Looper;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mProvider:Landroid/net/NetworkProvider;

    .line 170
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mContext:Landroid/content/Context;

    const-string v0, "connectivity"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/net/ConnectivityManager;

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mProvider:Landroid/net/NetworkProvider;

    .line 171
    invoke-virtual {p1, v0}, Landroid/net/ConnectivityManager;->registerNetworkProvider(Landroid/net/NetworkProvider;)I

    if-eqz p2, :cond_0

    const/4 p1, 0x6

    .line 176
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    :cond_0
    const/4 p1, 0x5

    .line 178
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :goto_0
    return-void

    .line 153
    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "A NetworkFactory must only be registered once"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 1

    .line 311
    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkFactoryImpl;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 312
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/NetworkFactoryImpl$NetworkRequestInfo;

    .line 313
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "  "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public getRequestCount()I
    .locals 0

    .line 307
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->size()I

    move-result p0

    return p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 1

    .line 188
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 210
    :pswitch_0
    sget-object p1, Lcom/android/internal/telephony/NetworkFactoryImpl;->INVINCIBLE_SCORE:Landroid/net/NetworkScore;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleOfferNetwork(Landroid/net/NetworkScore;)V

    goto :goto_0

    .line 206
    :pswitch_1
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mScore:Landroid/net/NetworkScore;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleOfferNetwork(Landroid/net/NetworkScore;)V

    goto :goto_0

    .line 202
    :pswitch_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkCapabilities;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleSetFilter(Landroid/net/NetworkCapabilities;)V

    goto :goto_0

    .line 198
    :pswitch_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkScore;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleSetScore(Landroid/net/NetworkScore;)V

    goto :goto_0

    .line 194
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkRequest;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleRemoveRequest(Landroid/net/NetworkRequest;)V

    goto :goto_0

    .line 190
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/net/NetworkRequest;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->handleAddRequest(Landroid/net/NetworkRequest;)V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public final reevaluateAllRequests()V
    .locals 4

    .line 275
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mProvider:Landroid/net/NetworkProvider;

    if-nez v0, :cond_0

    return-void

    .line 276
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mScore:Landroid/net/NetworkScore;

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mCapabilityFilter:Landroid/net/NetworkCapabilities;

    iget-object v3, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mExecutor:Ljava/util/concurrent/Executor;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mRequestCallback:Landroid/net/NetworkProvider$NetworkOfferCallback;

    invoke-virtual {v0, v1, v2, v3, p0}, Landroid/net/NetworkProvider;->registerNetworkOffer(Landroid/net/NetworkScore;Landroid/net/NetworkCapabilities;Ljava/util/concurrent/Executor;Landroid/net/NetworkProvider$NetworkOfferCallback;)V

    return-void
.end method

.method public register(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    .line 139
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/NetworkFactoryImpl;->register(Ljava/lang/String;Z)V

    return-void
.end method

.method public registerIgnoringScore(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x1

    .line 148
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/NetworkFactoryImpl;->register(Ljava/lang/String;Z)V

    return-void
.end method

.method public setCapabilityFilter(Landroid/net/NetworkCapabilities;)V
    .locals 1

    .line 303
    new-instance v0, Landroid/net/NetworkCapabilities;

    invoke-direct {v0, p1}, Landroid/net/NetworkCapabilities;-><init>(Landroid/net/NetworkCapabilities;)V

    const/4 p1, 0x4

    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public setScoreFilter(I)V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 285
    new-instance v0, Landroid/net/NetworkScore$Builder;

    invoke-direct {v0}, Landroid/net/NetworkScore$Builder;-><init>()V

    invoke-virtual {v0, p1}, Landroid/net/NetworkScore$Builder;->setLegacyInt(I)Landroid/net/NetworkScore$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/NetworkScore$Builder;->build()Landroid/net/NetworkScore;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->setScoreFilter(Landroid/net/NetworkScore;)V

    return-void
.end method

.method public setScoreFilter(Landroid/net/NetworkScore;)V
    .locals 1

    const/4 v0, 0x3

    .line 299
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 318
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "providerId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mProvider:Landroid/net/NetworkProvider;

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Landroid/net/NetworkProvider;->getProviderId()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    goto :goto_0

    :cond_0
    const-string v1, "null"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", ScoreFilter="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mScore:Landroid/net/NetworkScore;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", Filter="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->mCapabilityFilter:Landroid/net/NetworkCapabilities;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", requests="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl;->mNetworkRequests:Ljava/util/Map;

    .line 320
    invoke-interface {p0}, Ljava/util/Map;->size()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
