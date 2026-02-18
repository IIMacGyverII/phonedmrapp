.class Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;
.super Landroid/os/Handler;
.source "AsyncChannel.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "SyncHandler"
.end annotation


# instance fields
.field private mLockObject:Ljava/lang/Object;

.field private mResultMsg:Landroid/os/Message;

.field final synthetic this$0:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;


# direct methods
.method static bridge synthetic -$$Nest$fgetmLockObject(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->mLockObject:Ljava/lang/Object;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmResultMsg(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;)Landroid/os/Message;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->mResultMsg:Landroid/os/Message;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmResultMsg(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;Landroid/os/Message;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->mResultMsg:Landroid/os/Message;

    return-void
.end method

.method private constructor <init>(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;Landroid/os/Looper;)V
    .locals 0

    .line 786
    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->this$0:Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;

    .line 787
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 781
    new-instance p1, Ljava/lang/Object;

    invoke-direct {p1}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->mLockObject:Ljava/lang/Object;

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;Landroid/os/Looper;Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler-IA;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;-><init>(Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 1

    .line 793
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 794
    invoke-virtual {v0, p1}, Landroid/os/Message;->copyFrom(Landroid/os/Message;)V

    .line 795
    iget-object p1, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->mLockObject:Ljava/lang/Object;

    monitor-enter p1

    .line 796
    :try_start_0
    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->mResultMsg:Landroid/os/Message;

    .line 797
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger$SyncHandler;->mLockObject:Ljava/lang/Object;

    invoke-virtual {p0}, Ljava/lang/Object;->notify()V

    .line 798
    monitor-exit p1

    return-void

    :catchall_0
    move-exception p0

    monitor-exit p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
