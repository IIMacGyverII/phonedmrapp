.class public Lcom/android/internal/telephony/GbaManager;
.super Ljava/lang/Object;
.source "GbaManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;,
        Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;,
        Lcom/android/internal/telephony/GbaManager$GbaManagerHandler;
    }
.end annotation


# static fields
.field private static final DBG:Z

.field private static final EVENT_BIND_FAIL:I = 0x3

.field private static final EVENT_BIND_SERVICE:I = 0x1

.field private static final EVENT_BIND_SUCCESS:I = 0x4

.field private static final EVENT_CONFIG_CHANGED:I = 0x5

.field private static final EVENT_REQUESTS_RECEIVED:I = 0x6

.field private static final EVENT_UNBIND_SERVICE:I = 0x2

.field public static final MAX_RETRY:I = 0x5
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final REQUEST_TIMEOUT_MS:I = 0x1388
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final RETRY_TIME_MS:I = 0xbb8
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final sGbaManagers:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/GbaManager;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private final mCallbacks:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/telephony/IBootstrapAuthenticationCallback;",
            ">;"
        }
    .end annotation
.end field

.field private final mContext:Landroid/content/Context;

.field private mDeathRecipient:Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;

.field private mHandler:Landroid/os/Handler;

.field private mIGbaService:Landroid/telephony/gba/IGbaService;

.field private final mLogTag:Ljava/lang/String;

.field private final mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

.field private mReleaseTime:I

.field private final mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentLinkedQueue<",
            "Landroid/telephony/gba/GbaAuthRequest;",
            ">;"
        }
    .end annotation
.end field

.field private mRetryTimes:I

.field private final mServiceCallback:Landroid/telephony/IBootstrapAuthenticationCallback;

.field private mServiceConnection:Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;

.field private mServicePackageName:Ljava/lang/String;

.field private mServicePackageNameOverride:Ljava/lang/String;

.field private final mSubId:I

.field private mTargetBindingPackageName:Ljava/lang/String;


# direct methods
.method static bridge synthetic -$$Nest$fgetmCallbacks(Lcom/android/internal/telephony/GbaManager;)Landroid/util/SparseArray;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDeathRecipient(Lcom/android/internal/telephony/GbaManager;)Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mDeathRecipient:Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandler(Lcom/android/internal/telephony/GbaManager;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRcsStats(Lcom/android/internal/telephony/GbaManager;)Lcom/android/internal/telephony/metrics/RcsStats;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRequestQueue(Lcom/android/internal/telephony/GbaManager;)Ljava/util/concurrent/ConcurrentLinkedQueue;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRetryTimes(Lcom/android/internal/telephony/GbaManager;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/GbaManager;->mRetryTimes:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmSubId(Lcom/android/internal/telephony/GbaManager;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/GbaManager;->mSubId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmDeathRecipient(Lcom/android/internal/telephony/GbaManager;Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mDeathRecipient:Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIGbaService(Lcom/android/internal/telephony/GbaManager;Landroid/telephony/gba/IGbaService;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mIGbaService:Landroid/telephony/gba/IGbaService;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmRetryTimes(Lcom/android/internal/telephony/GbaManager;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/GbaManager;->mRetryTimes:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmTargetBindingPackageName(Lcom/android/internal/telephony/GbaManager;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mTargetBindingPackageName:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$mclearCallbacksAndNotifyFailure(Lcom/android/internal/telephony/GbaManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->clearCallbacksAndNotifyFailure()V

    return-void
.end method

.method static bridge synthetic -$$Nest$misServiceConnetable(Lcom/android/internal/telephony/GbaManager;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->isServiceConnetable()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mlogd(Lcom/android/internal/telephony/GbaManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GbaManager;->logd(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mloge(Lcom/android/internal/telephony/GbaManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GbaManager;->loge(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mlogv(Lcom/android/internal/telephony/GbaManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mprocessRequests(Lcom/android/internal/telephony/GbaManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->processRequests()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mrebindService(Lcom/android/internal/telephony/GbaManager;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GbaManager;->rebindService(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreleaseServiceAsNeeded(Lcom/android/internal/telephony/GbaManager;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GbaManager;->releaseServiceAsNeeded(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mretryBind(Lcom/android/internal/telephony/GbaManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->retryBind()V

    return-void
.end method

.method static bridge synthetic -$$Nest$munbindService(Lcom/android/internal/telephony/GbaManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->unbindService()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 50
    sget-boolean v0, Landroid/os/Build;->IS_DEBUGGABLE:Z

    sput-boolean v0, Lcom/android/internal/telephony/GbaManager;->DBG:Z

    .line 87
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/GbaManager;->sGbaManagers:Landroid/util/SparseArray;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;ILjava/lang/String;ILcom/android/internal/telephony/metrics/RcsStats;)V
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 197
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 79
    iput v0, p0, Lcom/android/internal/telephony/GbaManager;->mRetryTimes:I

    .line 82
    new-instance v0, Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentLinkedQueue;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    .line 85
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    .line 262
    new-instance v0, Lcom/android/internal/telephony/GbaManager$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/GbaManager$1;-><init>(Lcom/android/internal/telephony/GbaManager;)V

    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mServiceCallback:Landroid/telephony/IBootstrapAuthenticationCallback;

    .line 198
    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mContext:Landroid/content/Context;

    .line 199
    iput p2, p0, Lcom/android/internal/telephony/GbaManager;->mSubId:I

    .line 200
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "GbaManager["

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, "]"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mLogTag:Ljava/lang/String;

    .line 202
    iput-object p3, p0, Lcom/android/internal/telephony/GbaManager;->mServicePackageName:Ljava/lang/String;

    .line 203
    iput p4, p0, Lcom/android/internal/telephony/GbaManager;->mReleaseTime:I

    .line 205
    new-instance p2, Landroid/os/HandlerThread;

    invoke-direct {p2, p1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 206
    invoke-virtual {p2}, Landroid/os/HandlerThread;->start()V

    .line 207
    new-instance p1, Lcom/android/internal/telephony/GbaManager$GbaManagerHandler;

    invoke-virtual {p2}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object p2

    invoke-direct {p1, p0, p2}, Lcom/android/internal/telephony/GbaManager$GbaManagerHandler;-><init>(Lcom/android/internal/telephony/GbaManager;Landroid/os/Looper;)V

    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    .line 209
    iget p2, p0, Lcom/android/internal/telephony/GbaManager;->mReleaseTime:I

    if-gez p2, :cond_0

    const/4 p2, 0x1

    .line 210
    invoke-virtual {p1, p2}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    .line 212
    :cond_0
    iput-object p5, p0, Lcom/android/internal/telephony/GbaManager;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    return-void
.end method

.method private bindService()V
    .locals 5

    .line 407
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mContext:Landroid/content/Context;

    if-eqz v0, :cond_3

    iget v0, p0, Lcom/android/internal/telephony/GbaManager;->mSubId:I

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_1

    .line 412
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/GbaManager;->getServicePackage()Ljava/lang/String;

    move-result-object v0

    .line 413
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v0, "Can\'t find the binding package"

    .line 414
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->loge(Ljava/lang/String;)V

    return-void

    .line 418
    :cond_1
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.telephony.gba.GbaService"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 419
    invoke-virtual {v1, v0}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 422
    :try_start_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Trying to bind "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    .line 423
    new-instance v2, Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;

    const/4 v3, 0x0

    invoke-direct {v2, p0, v3}, Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;-><init>(Lcom/android/internal/telephony/GbaManager;Lcom/android/internal/telephony/GbaManager$GbaServiceConnection-IA;)V

    iput-object v2, p0, Lcom/android/internal/telephony/GbaManager;->mServiceConnection:Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;

    .line 424
    iget-object v3, p0, Lcom/android/internal/telephony/GbaManager;->mContext:Landroid/content/Context;

    const v4, 0x4000001

    invoke-virtual {v3, v1, v2, v4}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v0, "Cannot bind to the service."

    .line 426
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logd(Ljava/lang/String;)V

    .line 427
    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->retryBind()V

    return-void

    .line 430
    :cond_2
    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mTargetBindingPackageName:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 432
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "bindService failed "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->loge(Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_3
    :goto_1
    const-string v0, "Can\'t bind service with invalid sub Id."

    .line 408
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->loge(Ljava/lang/String;)V

    return-void
.end method

.method private clearCallbacksAndNotifyFailure()V
    .locals 6

    .line 361
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    monitor-enter v0

    const/4 v1, 0x0

    move v2, v1

    .line 362
    :goto_0
    :try_start_0
    iget-object v3, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v2, v3, :cond_0

    .line 363
    iget-object v3, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v3, v2}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/IBootstrapAuthenticationCallback;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 365
    :try_start_1
    iget-object v4, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v4, v2}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v4

    invoke-interface {v3, v4, v1}, Landroid/telephony/IBootstrapAuthenticationCallback;->onAuthenticationFailure(II)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v3

    .line 368
    :try_start_2
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "RemoteException "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/GbaManager;->logd(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 371
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    invoke-virtual {p0}, Landroid/util/SparseArray;->clear()V

    .line 372
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method public static getInstance(I)Lcom/android/internal/telephony/GbaManager;
    .locals 1

    .line 233
    sget-object v0, Lcom/android/internal/telephony/GbaManager;->sGbaManagers:Landroid/util/SparseArray;

    monitor-enter v0

    .line 234
    :try_start_0
    invoke-virtual {v0, p0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/GbaManager;

    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 235
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private isServiceConnetable()Z
    .locals 1

    .line 386
    monitor-enter p0

    .line 387
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mTargetBindingPackageName:Ljava/lang/String;

    if-nez v0, :cond_1

    iget v0, p0, Lcom/android/internal/telephony/GbaManager;->mReleaseTime:I

    if-gez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mServicePackageName:Ljava/lang/String;

    .line 388
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    .line 389
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private logd(Ljava/lang/String;)V
    .locals 0

    .line 528
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 532
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logv(Ljava/lang/String;)V
    .locals 1

    .line 522
    sget-boolean v0, Lcom/android/internal/telephony/GbaManager;->DBG:Z

    if-eqz v0, :cond_0

    .line 523
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void
.end method

.method public static make(Landroid/content/Context;ILjava/lang/String;I)Lcom/android/internal/telephony/GbaManager;
    .locals 7

    .line 220
    new-instance v6, Lcom/android/internal/telephony/GbaManager;

    .line 221
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v5

    move-object v0, v6

    move-object v1, p0

    move v2, p1

    move-object v3, p2

    move v4, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/GbaManager;-><init>(Landroid/content/Context;ILjava/lang/String;ILcom/android/internal/telephony/metrics/RcsStats;)V

    .line 222
    sget-object p0, Lcom/android/internal/telephony/GbaManager;->sGbaManagers:Landroid/util/SparseArray;

    monitor-enter p0

    .line 223
    :try_start_0
    invoke-virtual {p0, p1, v6}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 224
    monitor-exit p0

    return-object v6

    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method private processRequests()V
    .locals 5

    .line 315
    invoke-virtual {p0}, Lcom/android/internal/telephony/GbaManager;->isServiceConnected()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 317
    :goto_0
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentLinkedQueue;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    .line 318
    new-instance v0, Landroid/telephony/gba/GbaAuthRequest;

    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v1}, Ljava/util/concurrent/ConcurrentLinkedQueue;->peek()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/gba/GbaAuthRequest;

    invoke-direct {v0, v1}, Landroid/telephony/gba/GbaAuthRequest;-><init>(Landroid/telephony/gba/GbaAuthRequest;)V

    .line 319
    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    monitor-enter v1
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 320
    :try_start_1
    iget-object v2, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v0}, Landroid/telephony/gba/GbaAuthRequest;->getToken()I

    move-result v3

    invoke-virtual {v0}, Landroid/telephony/gba/GbaAuthRequest;->getCallback()Landroid/telephony/IBootstrapAuthenticationCallback;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 321
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 322
    :try_start_2
    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mServiceCallback:Landroid/telephony/IBootstrapAuthenticationCallback;

    invoke-virtual {v0, v1}, Landroid/telephony/gba/GbaAuthRequest;->setCallback(Landroid/telephony/IBootstrapAuthenticationCallback;)V

    .line 323
    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mIGbaService:Landroid/telephony/gba/IGbaService;

    invoke-interface {v1, v0}, Landroid/telephony/gba/IGbaService;->authenticationRequest(Landroid/telephony/gba/GbaAuthRequest;)V

    .line 324
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentLinkedQueue;->poll()Ljava/lang/Object;
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_0

    :catchall_0
    move-exception v0

    .line 321
    :try_start_3
    monitor-exit v1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw v0
    :try_end_4
    .catch Landroid/os/RemoteException; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    move-exception v0

    .line 328
    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mDeathRecipient:Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->binderDied()V

    .line 329
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RemoteException "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logd(Ljava/lang/String;)V

    goto :goto_2

    .line 332
    :cond_0
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentLinkedQueue;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    .line 333
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentLinkedQueue;->poll()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/gba/GbaAuthRequest;

    .line 335
    :try_start_5
    invoke-virtual {v0}, Landroid/telephony/gba/GbaAuthRequest;->getCallback()Landroid/telephony/IBootstrapAuthenticationCallback;

    move-result-object v1

    invoke-virtual {v0}, Landroid/telephony/gba/GbaAuthRequest;->getToken()I

    move-result v0

    const/4 v2, 0x1

    invoke-interface {v1, v0, v2}, Landroid/telephony/IBootstrapAuthenticationCallback;->onAuthenticationFailure(II)V
    :try_end_5
    .catch Landroid/os/RemoteException; {:try_start_5 .. :try_end_5} :catch_1

    goto :goto_1

    :catch_1
    move-exception v0

    .line 338
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RemoteException "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logd(Ljava/lang/String;)V

    goto :goto_1

    :cond_1
    :goto_2
    const/16 v0, 0x1388

    .line 343
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->releaseServiceAsNeeded(I)V

    return-void
.end method

.method private rebindService(Z)V
    .locals 1

    if-nez p1, :cond_0

    .line 450
    invoke-virtual {p0}, Lcom/android/internal/telephony/GbaManager;->isServiceConnected()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 451
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Service "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GbaManager;->getServicePackage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " already bound or being bound."

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    return-void

    .line 455
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->unbindService()V

    .line 456
    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->bindService()V

    return-void
.end method

.method private releaseServiceAsNeeded(I)V
    .locals 4

    .line 347
    invoke-virtual {p0}, Lcom/android/internal/telephony/GbaManager;->getReleaseTime()I

    move-result v0

    if-gez v0, :cond_0

    return-void

    :cond_0
    if-le v0, p1, :cond_1

    move p1, v0

    .line 354
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 355
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 357
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    int-to-long v2, p1

    invoke-virtual {p0, v1, v2, v3}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    return-void
.end method

.method private retryBind()V
    .locals 4

    .line 438
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string/jumbo v0, "wait for pending retry."

    .line 439
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    return-void

    .line 443
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "starting retry:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/GbaManager;->mRetryTimes:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    .line 445
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    const-wide/16 v2, 0xbb8

    invoke-virtual {p0, v1, v2, v3}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    return-void
.end method

.method private unbindService()V
    .locals 2

    .line 393
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mDeathRecipient:Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;

    if-eqz v0, :cond_0

    .line 394
    invoke-virtual {v0}, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->unlinkToDeath()V

    .line 396
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mServiceConnection:Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;

    if-eqz v0, :cond_1

    const-string/jumbo v0, "unbind service."

    .line 397
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    .line 398
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mServiceConnection:Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    :cond_1
    const/4 v0, 0x0

    .line 400
    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mDeathRecipient:Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;

    .line 401
    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mIGbaService:Landroid/telephony/gba/IGbaService;

    .line 402
    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mServiceConnection:Lcom/android/internal/telephony/GbaManager$GbaServiceConnection;

    .line 403
    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mTargetBindingPackageName:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public bootstrapAuthenticationRequest(Landroid/telephony/gba/GbaAuthRequest;)V
    .locals 2

    .line 243
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "bootstrapAuthenticationRequest: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    .line 245
    invoke-virtual {p0}, Lcom/android/internal/telephony/GbaManager;->getServicePackage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "do not support!"

    .line 246
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logd(Ljava/lang/String;)V

    .line 248
    :try_start_0
    invoke-virtual {p1}, Landroid/telephony/gba/GbaAuthRequest;->getCallback()Landroid/telephony/IBootstrapAuthenticationCallback;

    move-result-object v0

    invoke-virtual {p1}, Landroid/telephony/gba/GbaAuthRequest;->getToken()I

    move-result p1

    const/4 v1, 0x1

    invoke-interface {v0, p1, v1}, Landroid/telephony/IBootstrapAuthenticationCallback;->onAuthenticationFailure(II)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 251
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "exception to call service: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/GbaManager;->loge(Ljava/lang/String;)V

    :goto_0
    return-void

    .line 256
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v0, p1}, Ljava/util/concurrent/ConcurrentLinkedQueue;->offer(Ljava/lang/Object;)Z

    .line 257
    iget-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x6

    invoke-virtual {p1, v0}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-nez p1, :cond_1

    .line 258
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_1
    return-void
.end method

.method public destroy()V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 513
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 514
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/Looper;->quit()V

    .line 515
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mRequestQueue:Ljava/util/concurrent/ConcurrentLinkedQueue;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentLinkedQueue;->clear()V

    .line 516
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v0}, Landroid/util/SparseArray;->clear()V

    .line 517
    invoke-direct {p0}, Lcom/android/internal/telephony/GbaManager;->unbindService()V

    .line 518
    sget-object v0, Lcom/android/internal/telephony/GbaManager;->sGbaManagers:Landroid/util/SparseArray;

    iget p0, p0, Lcom/android/internal/telephony/GbaManager;->mSubId:I

    invoke-virtual {v0, p0}, Landroid/util/SparseArray;->remove(I)V

    return-void
.end method

.method public getHandler()Landroid/os/Handler;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 507
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    return-object p0
.end method

.method public getReleaseTime()I
    .locals 1

    .line 500
    monitor-enter p0

    .line 501
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/GbaManager;->mReleaseTime:I

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    .line 502
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public getServicePackage()Ljava/lang/String;
    .locals 1

    .line 477
    monitor-enter p0

    .line 478
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mServicePackageName:Ljava/lang/String;

    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    .line 479
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public isServiceConnected()Z
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 379
    monitor-enter p0

    .line 380
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mIGbaService:Landroid/telephony/gba/IGbaService;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Landroid/telephony/gba/IGbaService;->asBinder()Landroid/os/IBinder;

    move-result-object v0

    invoke-interface {v0}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mServicePackageName:Ljava/lang/String;

    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mTargetBindingPackageName:Ljava/lang/String;

    .line 381
    invoke-static {v0, v1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

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

    .line 382
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public overrideReleaseTime(I)Z
    .locals 2

    .line 484
    monitor-enter p0

    .line 485
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/GbaManager;->mReleaseTime:I

    if-eq v0, p1, :cond_1

    .line 486
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Service release time is changed from "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/GbaManager;->mReleaseTime:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    .line 488
    iput p1, p0, Lcom/android/internal/telephony/GbaManager;->mReleaseTime:I

    .line 489
    iget-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x5

    invoke-virtual {p1, v0}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-nez p1, :cond_0

    .line 490
    iget-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_0
    const/4 p1, 0x1

    .line 492
    monitor-exit p0

    return p1

    .line 494
    :cond_1
    monitor-exit p0

    const/4 p0, 0x0

    return p0

    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public overrideServicePackage(Ljava/lang/String;)Z
    .locals 2

    .line 461
    monitor-enter p0

    .line 462
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager;->mServicePackageName:Ljava/lang/String;

    invoke-static {v0, p1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 463
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Service package name is changed from "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/GbaManager;->mServicePackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/GbaManager;->logv(Ljava/lang/String;)V

    .line 465
    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mServicePackageName:Ljava/lang/String;

    .line 466
    iget-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x5

    invoke-virtual {p1, v0}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-nez p1, :cond_0

    .line 467
    iget-object p1, p0, Lcom/android/internal/telephony/GbaManager;->mHandler:Landroid/os/Handler;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_0
    const/4 p1, 0x1

    .line 469
    monitor-exit p0

    return p1

    .line 471
    :cond_1
    monitor-exit p0

    const/4 p0, 0x0

    return p0

    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method
