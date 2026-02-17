.class public Lcom/android/internal/telephony/data/CellularNetworkValidator;
.super Ljava/lang/Object;
.source "CellularNetworkValidator.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/CellularNetworkValidator$ConnectivityNetworkCallback;,
        Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;,
        Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;
    }
.end annotation


# static fields
.field private static final LOG_TAG:Ljava/lang/String; = "NetworkValidator"

.field public static final MAX_VALIDATION_CACHE_TTL:J
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final STATE_IDLE:I = 0x0

.field private static final STATE_VALIDATED:I = 0x2

.field private static final STATE_VALIDATING:I = 0x1

.field private static sInstance:Lcom/android/internal/telephony/data/CellularNetworkValidator; = null

.field private static sWaitForNetworkAvailableWhenCacheHit:Z = true


# instance fields
.field private mConnectivityManager:Landroid/net/ConnectivityManager;

.field private mContext:Landroid/content/Context;

.field public mHandler:Landroid/os/Handler;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public mNetworkCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ConnectivityNetworkCallback;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private mNetworkRequest:Landroid/net/NetworkRequest;

.field private mReleaseAfterValidation:Z

.field private mState:I

.field private mSubId:I

.field private mTimeoutInMs:J

.field private final mValidatedNetworkCache:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;

.field private mValidationCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;


# direct methods
.method public static synthetic $r8$lambda$_D1kpwY7tZi4LonBTEDuF97-Xy0(Lcom/android/internal/telephony/data/CellularNetworkValidator;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->lambda$reportValidationResult$1()V

    return-void
.end method

.method public static synthetic $r8$lambda$b9YfSJE8NGfmM1eSlHyeTJV1w9M(Lcom/android/internal/telephony/data/CellularNetworkValidator;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->lambda$validate$0(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmContext(Lcom/android/internal/telephony/data/CellularNetworkValidator;)Landroid/content/Context;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmValidatedNetworkCache(Lcom/android/internal/telephony/data/CellularNetworkValidator;)Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mValidatedNetworkCache:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mreportNetworkAvailable(Lcom/android/internal/telephony/data/CellularNetworkValidator;Landroid/net/Network;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->reportNetworkAvailable(Landroid/net/Network;I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreportValidationResult(Lcom/android/internal/telephony/data/CellularNetworkValidator;ZI)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->reportValidationResult(ZI)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smlogd(Ljava/lang/String;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->logd(Ljava/lang/String;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 77
    sget-object v0, Ljava/util/concurrent/TimeUnit;->DAYS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->MAX_VALIDATION_CACHE_TTL:J

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 246
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 79
    iput v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mState:I

    .line 88
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mHandler:Landroid/os/Handler;

    .line 92
    new-instance v0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;-><init>(Lcom/android/internal/telephony/data/CellularNetworkValidator;Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache-IA;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mValidatedNetworkCache:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;

    .line 247
    iput-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mContext:Landroid/content/Context;

    const-string v0, "connectivity"

    .line 249
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/net/ConnectivityManager;

    iput-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mConnectivityManager:Landroid/net/ConnectivityManager;

    return-void
.end method

.method private createNetworkRequest()Landroid/net/NetworkRequest;
    .locals 2

    .line 330
    new-instance v0, Landroid/net/NetworkRequest$Builder;

    invoke-direct {v0}, Landroid/net/NetworkRequest$Builder;-><init>()V

    const/16 v1, 0xc

    .line 331
    invoke-virtual {v0, v1}, Landroid/net/NetworkRequest$Builder;->addCapability(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v0

    const/4 v1, 0x0

    .line 332
    invoke-virtual {v0, v1}, Landroid/net/NetworkRequest$Builder;->addTransportType(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v0

    new-instance v1, Landroid/net/TelephonyNetworkSpecifier$Builder;

    invoke-direct {v1}, Landroid/net/TelephonyNetworkSpecifier$Builder;-><init>()V

    iget p0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I

    .line 334
    invoke-virtual {v1, p0}, Landroid/net/TelephonyNetworkSpecifier$Builder;->setSubscriptionId(I)Landroid/net/TelephonyNetworkSpecifier$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/net/TelephonyNetworkSpecifier$Builder;->build()Landroid/net/TelephonyNetworkSpecifier;

    move-result-object p0

    .line 333
    invoke-virtual {v0, p0}, Landroid/net/NetworkRequest$Builder;->setNetworkSpecifier(Landroid/net/NetworkSpecifier;)Landroid/net/NetworkRequest$Builder;

    move-result-object p0

    .line 335
    invoke-virtual {p0}, Landroid/net/NetworkRequest$Builder;->build()Landroid/net/NetworkRequest;

    move-result-object p0

    return-object p0
.end method

.method public static getInstance()Lcom/android/internal/telephony/data/CellularNetworkValidator;
    .locals 1

    .line 234
    sget-object v0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->sInstance:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    return-object v0
.end method

.method private synthetic lambda$reportValidationResult$1()V
    .locals 0

    .line 351
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->stopValidation()V

    return-void
.end method

.method private synthetic lambda$validate$0(I)V
    .locals 0

    .line 289
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->onValidationTimeout(I)V

    return-void
.end method

.method private static logd(Ljava/lang/String;)V
    .locals 1

    const-string v0, "NetworkValidator"

    .line 429
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static make(Landroid/content/Context;)Lcom/android/internal/telephony/data/CellularNetworkValidator;
    .locals 1

    .line 221
    sget-object v0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->sInstance:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    if-eqz v0, :cond_0

    const-string p0, "createCellularNetworkValidator failed. Instance already exists."

    .line 222
    invoke-static {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->logd(Ljava/lang/String;)V

    goto :goto_0

    .line 224
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/data/CellularNetworkValidator;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;-><init>(Landroid/content/Context;)V

    sput-object v0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->sInstance:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    .line 227
    :goto_0
    sget-object p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->sInstance:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    return-object p0
.end method

.method private declared-synchronized onValidationTimeout(I)V
    .locals 2

    monitor-enter p0

    .line 293
    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "timeout on subId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " validation."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->logd(Ljava/lang/String;)V

    .line 295
    iget-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mValidatedNetworkCache:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;

    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->storeLastValidationResult(IZ)V

    .line 296
    invoke-direct {p0, v1, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->reportValidationResult(ZI)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 297
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized reportNetworkAvailable(Landroid/net/Network;I)V
    .locals 1

    monitor-enter p0

    .line 364
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eq v0, p2, :cond_0

    monitor-exit p0

    return-void

    .line 365
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mValidationCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;

    invoke-interface {v0, p1, p2}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;->onNetworkAvailable(Landroid/net/Network;I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 366
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized reportValidationResult(ZI)V
    .locals 4

    monitor-enter p0

    .line 340
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eq v0, p2, :cond_0

    monitor-exit p0

    return-void

    .line 342
    :cond_0
    :try_start_1
    iget-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x0

    invoke-virtual {p2, v0}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 346
    iget p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mState:I

    const/4 v0, 0x1

    if-ne p2, v0, :cond_3

    .line 347
    iget-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mValidationCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;

    iget v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I

    invoke-interface {p2, p1, v0}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;->onValidationDone(ZI)V

    const/4 p2, 0x2

    .line 348
    iput p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mState:I

    .line 350
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mReleaseAfterValidation:Z

    if-nez v0, :cond_1

    if-eqz p1, :cond_1

    .line 351
    iget-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mHandler:Landroid/os/Handler;

    new-instance v1, Lcom/android/internal/telephony/data/CellularNetworkValidator$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/CellularNetworkValidator;)V

    const-wide/16 v2, 0x1f4

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_0

    .line 353
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->stopValidation()V

    .line 356
    :goto_0
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v0

    if-eqz p1, :cond_2

    const/4 p2, 0x3

    :cond_2
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeNetworkValidate(I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 360
    :cond_3
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method


# virtual methods
.method public declared-synchronized getSubIdInValidation()I
    .locals 1

    monitor-enter p0

    .line 319
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized isValidating()Z
    .locals 1

    monitor-enter p0

    .line 326
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mState:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public isValidationFeatureSupported()Z
    .locals 0

    .line 241
    invoke-static {}, Lcom/android/internal/telephony/PhoneConfigurationManager;->getInstance()Lcom/android/internal/telephony/PhoneConfigurationManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/PhoneConfigurationManager;->getCurrentPhoneCapability()Landroid/telephony/PhoneCapability;

    move-result-object p0

    .line 242
    invoke-virtual {p0}, Landroid/telephony/PhoneCapability;->isNetworkValidationBeforeSwitchSupported()Z

    move-result p0

    return p0
.end method

.method public declared-synchronized stopValidation()V
    .locals 2

    monitor-enter p0

    .line 303
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->isValidating()Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "No need to stop validation."

    .line 304
    invoke-static {v0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->logd(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 305
    monitor-exit p0

    return-void

    .line 307
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mNetworkCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ConnectivityNetworkCallback;

    if-eqz v0, :cond_1

    .line 308
    iget-object v1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mConnectivityManager:Landroid/net/ConnectivityManager;

    invoke-virtual {v1, v0}, Landroid/net/ConnectivityManager;->unregisterNetworkCallback(Landroid/net/ConnectivityManager$NetworkCallback;)V

    :cond_1
    const/4 v0, 0x0

    .line 310
    iput v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mState:I

    .line 311
    iget-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    const/4 v0, -0x1

    .line 312
    iput v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 313
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized validate(IJZLcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;)V
    .locals 2

    monitor-enter p0

    .line 258
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ne p1, v0, :cond_0

    monitor-exit p0

    return-void

    .line 260
    :cond_0
    :try_start_1
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(I)Z

    move-result v0

    if-nez v0, :cond_1

    .line 261
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Failed to start validation. Inactive subId "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->logd(Ljava/lang/String;)V

    const/4 p2, 0x0

    .line 262
    invoke-interface {p5, p2, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;->onValidationDone(ZI)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 263
    monitor-exit p0

    return-void

    .line 266
    :cond_1
    :try_start_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->isValidating()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 267
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->stopValidation()V

    .line 270
    :cond_2
    sget-boolean v0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->sWaitForNetworkAvailableWhenCacheHit:Z

    const/4 v1, 0x1

    if-nez v0, :cond_3

    iget-object v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mValidatedNetworkCache:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;

    .line 271
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->isRecentlyValidated(I)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 272
    invoke-interface {p5, v1, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;->onValidationDone(ZI)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 273
    monitor-exit p0

    return-void

    .line 276
    :cond_3
    :try_start_3
    iput v1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mState:I

    .line 277
    iput p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I

    .line 278
    iput-wide p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mTimeoutInMs:J

    .line 279
    iput-object p5, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mValidationCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;

    .line 280
    iput-boolean p4, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mReleaseAfterValidation:Z

    .line 281
    invoke-direct {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->createNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mNetworkRequest:Landroid/net/NetworkRequest;

    .line 283
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Start validating subId "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mSubId:I

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " mTimeoutInMs "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide p3, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mTimeoutInMs:J

    invoke-virtual {p2, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p3, " mReleaseAfterValidation "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p3, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mReleaseAfterValidation:Z

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->logd(Ljava/lang/String;)V

    .line 286
    new-instance p2, Lcom/android/internal/telephony/data/CellularNetworkValidator$ConnectivityNetworkCallback;

    invoke-direct {p2, p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ConnectivityNetworkCallback;-><init>(Lcom/android/internal/telephony/data/CellularNetworkValidator;I)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mNetworkCallback:Lcom/android/internal/telephony/data/CellularNetworkValidator$ConnectivityNetworkCallback;

    .line 288
    iget-object p3, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mConnectivityManager:Landroid/net/ConnectivityManager;

    iget-object p4, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mNetworkRequest:Landroid/net/NetworkRequest;

    iget-object p5, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mHandler:Landroid/os/Handler;

    invoke-virtual {p3, p4, p2, p5}, Landroid/net/ConnectivityManager;->requestNetwork(Landroid/net/NetworkRequest;Landroid/net/ConnectivityManager$NetworkCallback;Landroid/os/Handler;)V

    .line 289
    iget-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mHandler:Landroid/os/Handler;

    new-instance p3, Lcom/android/internal/telephony/data/CellularNetworkValidator$$ExternalSyntheticLambda0;

    invoke-direct {p3, p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/CellularNetworkValidator;I)V

    iget-wide p4, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->mTimeoutInMs:J

    invoke-virtual {p2, p3, p4, p5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 290
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
