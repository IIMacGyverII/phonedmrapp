.class Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;
.super Ljava/lang/Object;
.source "AsyncChannel.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/AsyncChannel;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "SyncMessenger"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;
    }
.end annotation


# static fields
.field private static sCount:I

.field private static sStack:Ljava/util/Stack;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Stack<",
            "Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

.field private mHandlerThread:Landroid/os/HandlerThread;

.field private mMessenger:Landroid/os/Messenger;


# direct methods
.method static bridge synthetic -$$Nest$smsendMessageSynchronously(Landroid/os/Messenger;Landroid/os/Message;)Landroid/os/Message;
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sendMessageSynchronously(Landroid/os/Messenger;Landroid/os/Message;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 764
    new-instance v0, Ljava/util/Stack;

    invoke-direct {v0}, Ljava/util/Stack;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sStack:Ljava/util/Stack;

    const/4 v0, 0x0

    .line 766
    sput v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sCount:I

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 775
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static obtain()Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;
    .locals 6

    .line 807
    sget-object v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sStack:Ljava/util/Stack;

    monitor-enter v0

    .line 808
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sStack:Ljava/util/Stack;

    invoke-virtual {v1}, Ljava/util/Stack;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 809
    new-instance v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;

    invoke-direct {v1}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;-><init>()V

    .line 810
    new-instance v2, Landroid/os/HandlerThread;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "SyncHandler-"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v4, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sCount:I

    add-int/lit8 v5, v4, 0x1

    sput v5, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sCount:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v2, v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandlerThread:Landroid/os/HandlerThread;

    .line 811
    invoke-virtual {v2}, Landroid/os/HandlerThread;->start()V

    .line 812
    new-instance v2, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    iget-object v3, v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandlerThread:Landroid/os/HandlerThread;

    invoke-virtual {v3}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v3

    const/4 v4, 0x0

    invoke-direct {v2, v1, v3, v4}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;-><init>(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;Landroid/os/Looper;Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler-IA;)V

    iput-object v2, v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    .line 813
    new-instance v2, Landroid/os/Messenger;

    iget-object v3, v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    invoke-direct {v2, v3}, Landroid/os/Messenger;-><init>(Landroid/os/Handler;)V

    iput-object v2, v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mMessenger:Landroid/os/Messenger;

    goto :goto_0

    .line 815
    :cond_0
    sget-object v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sStack:Ljava/util/Stack;

    invoke-virtual {v1}, Ljava/util/Stack;->pop()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;

    .line 817
    :goto_0
    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method private recycle()V
    .locals 2

    .line 825
    sget-object v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sStack:Ljava/util/Stack;

    monitor-enter v0

    .line 826
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->sStack:Ljava/util/Stack;

    invoke-virtual {v1, p0}, Ljava/util/Stack;->push(Ljava/lang/Object;)Ljava/lang/Object;

    .line 827
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private static sendMessageSynchronously(Landroid/os/Messenger;Landroid/os/Message;)Landroid/os/Message;
    .locals 5

    .line 837
    invoke-static {}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->obtain()Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz p0, :cond_1

    if-eqz p1, :cond_1

    .line 841
    :try_start_0
    iget-object v2, v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mMessenger:Landroid/os/Messenger;

    iput-object v2, p1, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    .line 842
    iget-object v2, v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    invoke-static {v2}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->-$$Nest$fgetmLockObject(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;)Ljava/lang/Object;

    move-result-object v2

    monitor-enter v2
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 843
    :try_start_1
    iget-object v3, v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    invoke-static {v3}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->-$$Nest$fgetmResultMsg(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;)Landroid/os/Message;

    move-result-object v3

    if-eqz v3, :cond_0

    const-string v3, "AsyncChannel"

    const-string v4, "mResultMsg should be null here"

    .line 844
    invoke-static {v3, v4}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 845
    iget-object v3, v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    invoke-static {v3, v1}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->-$$Nest$fputmResultMsg(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;Landroid/os/Message;)V

    .line 847
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Messenger;->send(Landroid/os/Message;)V

    .line 848
    iget-object p0, v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->-$$Nest$fgetmLockObject(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->wait()V

    .line 849
    iget-object p0, v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->-$$Nest$fgetmResultMsg(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;)Landroid/os/Message;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 850
    :try_start_2
    iget-object p1, v0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->mHandler:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;

    invoke-static {p1, v1}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->-$$Nest$fputmResultMsg(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;Landroid/os/Message;)V

    .line 851
    monitor-exit v2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    move-object v1, p0

    goto :goto_1

    :catchall_0
    move-exception p1

    move-object v1, p0

    move-object p0, p1

    goto :goto_0

    :catchall_1
    move-exception p0

    :goto_0
    :try_start_3
    monitor-exit v2
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    :try_start_4
    throw p0
    :try_end_4
    .catch Ljava/lang/InterruptedException; {:try_start_4 .. :try_end_4} :catch_1
    .catch Landroid/os/RemoteException; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    move-exception p0

    const-string p1, "AsyncChannel"

    const-string v2, "error in sendMessageSynchronously"

    .line 856
    invoke-static {p1, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_1

    :catch_1
    move-exception p0

    const-string p1, "AsyncChannel"

    const-string v2, "error in sendMessageSynchronously"

    .line 854
    invoke-static {p1, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 858
    :cond_1
    :goto_1
    invoke-direct {v0}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->recycle()V

    return-object v1
.end method
