.class Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;
.super Ljava/lang/Object;
.source "RadioConfigProxy.java"

# interfaces
.implements Landroid/os/IBinder$DeathRecipient;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/RadioConfigProxy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "RadioConfigAidlServiceDeathRecipient"
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "RadioConfigAidlSDR"


# instance fields
.field private final mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

.field private mService:Landroid/os/IBinder;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/RadioConfig;)V
    .locals 0

    .line 305
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 306
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    return-void
.end method


# virtual methods
.method public binderDied()V
    .locals 2

    const-string v0, "RadioConfigAidlSDR"

    const-string v1, "service died."

    .line 333
    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 334
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->unlinkToDeath()V

    .line 335
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    const/4 v0, 0x2

    .line 336
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 335
    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public clear()V
    .locals 1

    const/4 v0, 0x0

    .line 318
    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->mService:Landroid/os/IBinder;

    return-void
.end method

.method public linkToDeath(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 314
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->mService:Landroid/os/IBinder;

    invoke-interface {v0, p0, p1}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V

    return-void
.end method

.method public setService(Landroid/os/IBinder;)V
    .locals 0

    .line 310
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->mService:Landroid/os/IBinder;

    return-void
.end method

.method public declared-synchronized unlinkToDeath()V
    .locals 2

    monitor-enter p0

    .line 325
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->mService:Landroid/os/IBinder;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 326
    invoke-interface {v0, p0, v1}, Landroid/os/IBinder;->unlinkToDeath(Landroid/os/IBinder$DeathRecipient;I)Z

    const/4 v0, 0x0

    .line 327
    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->mService:Landroid/os/IBinder;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 329
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method
