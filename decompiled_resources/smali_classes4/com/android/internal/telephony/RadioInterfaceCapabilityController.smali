.class public Lcom/android/internal/telephony/RadioInterfaceCapabilityController;
.super Landroid/os/Handler;
.source "RadioInterfaceCapabilityController.java"


# static fields
.field private static final EVENT_GET_HAL_DEVICE_CAPABILITIES_DONE:I = 0x64

.field private static final LOG_TAG:Ljava/lang/String;

.field private static sInstance:Lcom/android/internal/telephony/RadioInterfaceCapabilityController;


# instance fields
.field private final mCommandsInterface:Lcom/android/internal/telephony/CommandsInterface;

.field private final mLockRadioInterfaceCapabilities:Ljava/lang/Object;

.field private final mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

.field private mRadioInterfaceCapabilities:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 38
    const-class v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    .line 39
    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->LOG_TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/RadioConfig;Lcom/android/internal/telephony/CommandsInterface;Landroid/os/Looper;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 81
    invoke-direct {p0, p3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 45
    new-instance p3, Ljava/lang/Object;

    invoke-direct {p3}, Ljava/lang/Object;-><init>()V

    iput-object p3, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mLockRadioInterfaceCapabilities:Ljava/lang/Object;

    .line 82
    iput-object p1, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    .line 83
    iput-object p2, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mCommandsInterface:Lcom/android/internal/telephony/CommandsInterface;

    .line 84
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->register()V

    return-void
.end method

.method public static getInstance()Lcom/android/internal/telephony/RadioInterfaceCapabilityController;
    .locals 2

    .line 71
    sget-object v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->sInstance:Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    if-nez v0, :cond_0

    .line 72
    sget-object v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->LOG_TAG:Ljava/lang/String;

    const-string v1, "getInstance null"

    invoke-static {v0, v1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 75
    :cond_0
    sget-object v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->sInstance:Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    return-object v0
.end method

.method public static init(Lcom/android/internal/telephony/RadioConfig;Lcom/android/internal/telephony/CommandsInterface;)Lcom/android/internal/telephony/RadioInterfaceCapabilityController;
    .locals 3

    .line 54
    const-class v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    monitor-enter v0

    .line 55
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->sInstance:Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    if-nez v1, :cond_0

    .line 56
    new-instance v1, Landroid/os/HandlerThread;

    const-string v2, "RHC"

    invoke-direct {v1, v2}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 57
    invoke-virtual {v1}, Landroid/os/HandlerThread;->start()V

    .line 58
    new-instance v2, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    .line 59
    invoke-virtual {v1}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v2, p0, p1, v1}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;-><init>(Lcom/android/internal/telephony/RadioConfig;Lcom/android/internal/telephony/CommandsInterface;Landroid/os/Looper;)V

    sput-object v2, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->sInstance:Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    goto :goto_0

    .line 61
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->LOG_TAG:Ljava/lang/String;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "init() called multiple times!  sInstance = "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->sInstance:Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 63
    :goto_0
    sget-object p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->sInstance:Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 64
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private static log(Ljava/lang/String;)V
    .locals 1

    .line 168
    sget-object v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->LOG_TAG:Ljava/lang/String;

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static loge(Ljava/lang/String;)V
    .locals 1

    .line 172
    sget-object v0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->LOG_TAG:Ljava/lang/String;

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private register()V
    .locals 3

    .line 142
    iget-object v0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mCommandsInterface:Lcom/android/internal/telephony/CommandsInterface;

    if-nez v0, :cond_0

    .line 143
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    invoke-static {v0}, Ljava/util/Collections;->unmodifiableSet(Ljava/util/Set;)Ljava/util/Set;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    return-void

    :cond_0
    const/4 v1, 0x1

    const/4 v2, 0x0

    .line 147
    invoke-interface {v0, p0, v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->registerForAvailable(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method private setupCapabilities(Landroid/os/AsyncResult;)V
    .locals 3

    .line 117
    iget-object v0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    if-nez v0, :cond_3

    .line 118
    iget-object v0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mLockRadioInterfaceCapabilities:Ljava/lang/Object;

    monitor-enter v0

    .line 119
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    if-nez v1, :cond_2

    .line 120
    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v1, :cond_0

    .line 121
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "setupRadioInterfaceCapabilities: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->loge(Ljava/lang/String;)V

    .line 123
    :cond_0
    iget-object v1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-nez v1, :cond_1

    const-string/jumbo p0, "setupRadioInterfaceCapabilities: ar.result is null"

    .line 124
    invoke-static {p0}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->loge(Ljava/lang/String;)V

    .line 125
    monitor-exit v0

    return-void

    :cond_1
    const-string/jumbo v1, "setupRadioInterfaceCapabilities: mRadioInterfaceCapabilities now setup"

    .line 127
    invoke-static {v1}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->log(Ljava/lang/String;)V

    .line 129
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/util/Set;

    .line 130
    invoke-static {p1}, Ljava/util/Collections;->unmodifiableSet(Ljava/util/Set;)Ljava/util/Set;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    if-eqz p1, :cond_2

    .line 132
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->unregister()V

    .line 135
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mLockRadioInterfaceCapabilities:Ljava/lang/Object;

    invoke-virtual {p0}, Ljava/lang/Object;->notify()V

    .line 136
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    :cond_3
    :goto_0
    return-void
.end method

.method private unregister()V
    .locals 1

    .line 151
    iget-object v0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mCommandsInterface:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForAvailable(Landroid/os/Handler;)V

    return-void
.end method


# virtual methods
.method public getCapabilities()Ljava/util/Set;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 92
    iget-object v0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    if-nez v0, :cond_2

    .line 94
    iget-object v0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mLockRadioInterfaceCapabilities:Ljava/lang/Object;

    monitor-enter v0

    .line 95
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    if-nez v1, :cond_1

    .line 96
    iget-object v1, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    const/16 v2, 0x64

    .line 97
    invoke-virtual {p0, v2}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v2

    .line 96
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/RadioConfig;->getHalDeviceCapabilities(Landroid/os/Message;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 99
    :try_start_1
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v2

    if-eq v1, v2, :cond_0

    .line 100
    iget-object v1, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mLockRadioInterfaceCapabilities:Ljava/lang/Object;

    const-wide/16 v2, 0x7d0

    invoke-virtual {v1, v2, v3}, Ljava/lang/Object;->wait(J)V
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 105
    :catch_0
    :cond_0
    :try_start_2
    iget-object v1, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    if-nez v1, :cond_1

    const-string p0, "getRadioInterfaceCapabilities: Radio Capabilities not loaded in time"

    .line 106
    invoke-static {p0}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->loge(Ljava/lang/String;)V

    .line 108
    new-instance p0, Landroid/util/ArraySet;

    invoke-direct {p0}, Landroid/util/ArraySet;-><init>()V

    monitor-exit v0

    return-object p0

    .line 111
    :cond_1
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0

    .line 113
    :cond_2
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->mRadioInterfaceCapabilities:Ljava/util/Set;

    return-object p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 156
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v1, 0x5

    if-eq v0, v1, :cond_1

    const/16 v1, 0x64

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 162
    :cond_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->setupCapabilities(Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 159
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->getCapabilities()Ljava/util/Set;

    :goto_0
    return-void
.end method
