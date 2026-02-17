.class public final Lcom/pri/prizeinterphone/Util/ExecutorManager;
.super Ljava/lang/Object;
.source "ExecutorManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler;
    }
.end annotation


# static fields
.field public static final DISPATCH_THREAD_NAME:Ljava/lang/String; = "serial-port-dispatch-t"

.field public static final INSTANCE:Lcom/pri/prizeinterphone/Util/ExecutorManager;

.field public static final READ_THREAD_NAME:Ljava/lang/String; = "serial-port-read-t"

.field public static final START_THREAD_NAME:Ljava/lang/String; = "serial-port-start-t"

.field public static final THREAD_NAME_PREFIX:Ljava/lang/String; = "serial-port-"

.field public static final TIMER_THREAD_NAME:Ljava/lang/String; = "serial-port-timer-t"

.field public static final WRITE_THREAD_NAME:Ljava/lang/String; = "serial-port-write-t"


# instance fields
.field private dispatchThread:Ljava/util/concurrent/ThreadPoolExecutor;

.field private timerThread:Ljava/util/concurrent/ScheduledExecutorService;

.field private writeThread:Ljava/util/concurrent/ThreadPoolExecutor;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 40
    new-instance v0, Lcom/pri/prizeinterphone/Util/ExecutorManager;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ExecutorManager;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->INSTANCE:Lcom/pri/prizeinterphone/Util/ExecutorManager;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static isMPThread()Z
    .locals 2

    .line 92
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "serial-port-"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method


# virtual methods
.method public getDispatchThread()Ljava/util/concurrent/ThreadPoolExecutor;
    .locals 10

    .line 57
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->dispatchThread:Ljava/util/concurrent/ThreadPoolExecutor;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/util/concurrent/ThreadPoolExecutor;->isShutdown()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 58
    :cond_0
    new-instance v0, Ljava/util/concurrent/ThreadPoolExecutor;

    const/4 v2, 0x2

    const/4 v3, 0x4

    const-wide/16 v4, 0x1

    sget-object v6, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    new-instance v7, Ljava/util/concurrent/LinkedBlockingQueue;

    const/16 v1, 0x64

    invoke-direct {v7, v1}, Ljava/util/concurrent/LinkedBlockingQueue;-><init>(I)V

    new-instance v8, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    const-string v1, "serial-port-dispatch-t"

    invoke-direct {v8, v1}, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;-><init>(Ljava/lang/String;)V

    new-instance v9, Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler;

    const/4 v1, 0x0

    invoke-direct {v9, v1}, Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler;-><init>(Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler-IA;)V

    move-object v1, v0

    invoke-direct/range {v1 .. v9}, Ljava/util/concurrent/ThreadPoolExecutor;-><init>(IIJLjava/util/concurrent/TimeUnit;Ljava/util/concurrent/BlockingQueue;Ljava/util/concurrent/ThreadFactory;Ljava/util/concurrent/RejectedExecutionHandler;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->dispatchThread:Ljava/util/concurrent/ThreadPoolExecutor;

    .line 64
    :cond_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->dispatchThread:Ljava/util/concurrent/ThreadPoolExecutor;

    return-object p0
.end method

.method public getTimerThread()Ljava/util/concurrent/ScheduledExecutorService;
    .locals 5

    .line 68
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->timerThread:Ljava/util/concurrent/ScheduledExecutorService;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Ljava/util/concurrent/ScheduledExecutorService;->isShutdown()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 69
    :cond_0
    new-instance v0, Ljava/util/concurrent/ScheduledThreadPoolExecutor;

    const/4 v1, 0x1

    new-instance v2, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    const-string v3, "serial-port-timer-t"

    invoke-direct {v2, v3}, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;-><init>(Ljava/lang/String;)V

    new-instance v3, Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler;

    const/4 v4, 0x0

    invoke-direct {v3, v4}, Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler;-><init>(Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler-IA;)V

    invoke-direct {v0, v1, v2, v3}, Ljava/util/concurrent/ScheduledThreadPoolExecutor;-><init>(ILjava/util/concurrent/ThreadFactory;Ljava/util/concurrent/RejectedExecutionHandler;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->timerThread:Ljava/util/concurrent/ScheduledExecutorService;

    .line 73
    :cond_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->timerThread:Ljava/util/concurrent/ScheduledExecutorService;

    return-object p0
.end method

.method public getWriteThread()Ljava/util/concurrent/ThreadPoolExecutor;
    .locals 10

    .line 46
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->writeThread:Ljava/util/concurrent/ThreadPoolExecutor;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/util/concurrent/ThreadPoolExecutor;->isShutdown()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 47
    :cond_0
    new-instance v0, Ljava/util/concurrent/ThreadPoolExecutor;

    const/4 v2, 0x1

    const/4 v3, 0x1

    const-wide/16 v4, 0x0

    sget-object v6, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    new-instance v7, Ljava/util/concurrent/LinkedBlockingQueue;

    const/16 v1, 0x64

    invoke-direct {v7, v1}, Ljava/util/concurrent/LinkedBlockingQueue;-><init>(I)V

    new-instance v8, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    const-string v1, "serial-port-write-t"

    invoke-direct {v8, v1}, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;-><init>(Ljava/lang/String;)V

    new-instance v9, Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler;

    const/4 v1, 0x0

    invoke-direct {v9, v1}, Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler;-><init>(Lcom/pri/prizeinterphone/Util/ExecutorManager$RejectedHandler-IA;)V

    move-object v1, v0

    invoke-direct/range {v1 .. v9}, Ljava/util/concurrent/ThreadPoolExecutor;-><init>(IIJLjava/util/concurrent/TimeUnit;Ljava/util/concurrent/BlockingQueue;Ljava/util/concurrent/ThreadFactory;Ljava/util/concurrent/RejectedExecutionHandler;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->writeThread:Ljava/util/concurrent/ThreadPoolExecutor;

    .line 53
    :cond_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->writeThread:Ljava/util/concurrent/ThreadPoolExecutor;

    return-object p0
.end method

.method public declared-synchronized shutdown()V
    .locals 2

    monitor-enter p0

    .line 77
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->writeThread:Ljava/util/concurrent/ThreadPoolExecutor;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 78
    invoke-virtual {v0}, Ljava/util/concurrent/ThreadPoolExecutor;->shutdownNow()Ljava/util/List;

    .line 79
    iput-object v1, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->writeThread:Ljava/util/concurrent/ThreadPoolExecutor;

    .line 81
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->dispatchThread:Ljava/util/concurrent/ThreadPoolExecutor;

    if-eqz v0, :cond_1

    .line 82
    invoke-virtual {v0}, Ljava/util/concurrent/ThreadPoolExecutor;->shutdownNow()Ljava/util/List;

    .line 83
    iput-object v1, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->dispatchThread:Ljava/util/concurrent/ThreadPoolExecutor;

    .line 85
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->timerThread:Ljava/util/concurrent/ScheduledExecutorService;

    if-eqz v0, :cond_2

    .line 86
    invoke-interface {v0}, Ljava/util/concurrent/ScheduledExecutorService;->shutdownNow()Ljava/util/List;

    .line 87
    iput-object v1, p0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->timerThread:Ljava/util/concurrent/ScheduledExecutorService;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 89
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method
