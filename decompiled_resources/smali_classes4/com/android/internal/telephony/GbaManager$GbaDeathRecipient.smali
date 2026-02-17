.class final Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;
.super Ljava/lang/Object;
.source "GbaManager.java"

# interfaces
.implements Landroid/os/IBinder$DeathRecipient;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/GbaManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "GbaDeathRecipient"
.end annotation


# instance fields
.field private mBinder:Landroid/os/IBinder;

.field private final mComponentName:Landroid/content/ComponentName;

.field final synthetic this$0:Lcom/android/internal/telephony/GbaManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/GbaManager;Landroid/content/ComponentName;)V
    .locals 0

    .line 145
    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->this$0:Lcom/android/internal/telephony/GbaManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 146
    iput-object p2, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->mComponentName:Landroid/content/ComponentName;

    return-void
.end method


# virtual methods
.method public binderDied()V
    .locals 3

    .line 165
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->this$0:Lcom/android/internal/telephony/GbaManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "GbaService("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->mComponentName:Landroid/content/ComponentName;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ") has died."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/GbaManager;->-$$Nest$mlogd(Lcom/android/internal/telephony/GbaManager;Ljava/lang/String;)V

    .line 166
    invoke-virtual {p0}, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->unlinkToDeath()V

    .line 168
    iget-object p0, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->this$0:Lcom/android/internal/telephony/GbaManager;

    invoke-static {p0}, Lcom/android/internal/telephony/GbaManager;->-$$Nest$mretryBind(Lcom/android/internal/telephony/GbaManager;)V

    return-void
.end method

.method public linkToDeath(Landroid/os/IBinder;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    if-eqz p1, :cond_0

    .line 151
    iput-object p1, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->mBinder:Landroid/os/IBinder;

    const/4 v0, 0x0

    .line 152
    invoke-interface {p1, p0, v0}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V

    :cond_0
    return-void
.end method

.method public declared-synchronized unlinkToDeath()V
    .locals 2

    monitor-enter p0

    .line 157
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->mBinder:Landroid/os/IBinder;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 158
    invoke-interface {v0, p0, v1}, Landroid/os/IBinder;->unlinkToDeath(Landroid/os/IBinder$DeathRecipient;I)Z

    const/4 v0, 0x0

    .line 159
    iput-object v0, p0, Lcom/android/internal/telephony/GbaManager$GbaDeathRecipient;->mBinder:Landroid/os/IBinder;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 161
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method
