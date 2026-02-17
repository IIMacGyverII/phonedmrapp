.class final Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;
.super Ljava/lang/Object;
.source "RIL.java"

# interfaces
.implements Landroid/os/IBinder$DeathRecipient;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/RIL;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "BinderServiceDeathRecipient"
.end annotation


# instance fields
.field private mBinder:Landroid/os/IBinder;

.field private final mService:I

.field final synthetic this$0:Lcom/android/internal/telephony/RIL;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/RIL;I)V
    .locals 0

    .line 428
    iput-object p1, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->this$0:Lcom/android/internal/telephony/RIL;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 429
    iput p2, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->mService:I

    return-void
.end method


# virtual methods
.method public binderDied()V
    .locals 5

    .line 448
    iget-object v0, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->this$0:Lcom/android/internal/telephony/RIL;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Service "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->mService:I

    invoke-static {v2}, Lcom/android/internal/telephony/RIL;->-$$Nest$smserviceToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " has died."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    .line 449
    iget-object v0, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object v1, v0, Lcom/android/internal/telephony/RIL;->mRilHandler:Lcom/android/internal/telephony/RIL$RilHandler;

    iget v2, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->mService:I

    iget-object v0, v0, Lcom/android/internal/telephony/RIL;->mServiceCookies:Landroid/util/SparseArray;

    .line 450
    invoke-virtual {v0, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/concurrent/atomic/AtomicLong;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicLong;->get()J

    move-result-wide v3

    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    const/4 v3, 0x7

    const/4 v4, 0x0

    .line 449
    invoke-virtual {v1, v3, v2, v4, v0}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 451
    invoke-virtual {p0}, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->unlinkToDeath()V

    return-void
.end method

.method public linkToDeath(Landroid/os/IBinder;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    if-eqz p1, :cond_0

    .line 434
    iput-object p1, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->mBinder:Landroid/os/IBinder;

    .line 435
    iget-object v0, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object v0, v0, Lcom/android/internal/telephony/RIL;->mServiceCookies:Landroid/util/SparseArray;

    iget v1, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->mService:I

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/concurrent/atomic/AtomicLong;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J

    move-result-wide v0

    long-to-int v0, v0

    invoke-interface {p1, p0, v0}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V

    :cond_0
    return-void
.end method

.method public declared-synchronized unlinkToDeath()V
    .locals 2

    monitor-enter p0

    .line 440
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->mBinder:Landroid/os/IBinder;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 441
    invoke-interface {v0, p0, v1}, Landroid/os/IBinder;->unlinkToDeath(Landroid/os/IBinder$DeathRecipient;I)Z

    const/4 v0, 0x0

    .line 442
    iput-object v0, p0, Lcom/android/internal/telephony/RIL$BinderServiceDeathRecipient;->mBinder:Landroid/os/IBinder;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 444
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method
