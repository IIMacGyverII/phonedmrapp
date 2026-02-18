.class public Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;
.super Ljava/lang/Object;
.source "ImsRegistrationCallbackHelper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "ImsRegCallbackHelper"


# instance fields
.field private final mImsRegistrationCallback:Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

.field private mImsRegistrationUpdate:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;

.field private final mLock:Ljava/lang/Object;

.field private mRegistrationState:I


# direct methods
.method static bridge synthetic -$$Nest$fgetmImsRegistrationUpdate(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;)Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mImsRegistrationUpdate:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;

    return-object p0
.end method

.method public constructor <init>(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;Ljava/util/concurrent/Executor;)V
    .locals 1

    .line 93
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 63
    iput v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mRegistrationState:I

    .line 64
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mLock:Ljava/lang/Object;

    .line 66
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;-><init>(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;)V

    iput-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mImsRegistrationCallback:Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

    .line 94
    invoke-virtual {v0, p2}, Landroid/telephony/ims/RegistrationManager$RegistrationCallback;->setExecutor(Ljava/util/concurrent/Executor;)V

    .line 95
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mImsRegistrationUpdate:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;

    return-void
.end method


# virtual methods
.method public getCallback()Landroid/telephony/ims/RegistrationManager$RegistrationCallback;
    .locals 0

    .line 130
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mImsRegistrationCallback:Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

    return-object p0
.end method

.method public getCallbackBinder()Landroid/telephony/ims/aidl/IImsRegistrationCallback;
    .locals 0

    .line 134
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mImsRegistrationCallback:Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

    invoke-virtual {p0}, Landroid/telephony/ims/RegistrationManager$RegistrationCallback;->getBinder()Landroid/telephony/ims/aidl/IImsRegistrationCallback;

    move-result-object p0

    return-object p0
.end method

.method public getImsRegistrationState()I
    .locals 1

    .line 120
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 121
    :try_start_0
    iget p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mRegistrationState:I

    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 122
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public isImsRegistered()Z
    .locals 1

    .line 126
    invoke-virtual {p0}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->getImsRegistrationState()I

    move-result p0

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public reset()V
    .locals 2

    const-string v0, "ImsRegCallbackHelper"

    const-string v1, "reset"

    .line 102
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    .line 103
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->updateRegistrationState(I)V

    return-void
.end method

.method public declared-synchronized updateRegistrationState(I)V
    .locals 4

    monitor-enter p0

    .line 111
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mLock:Ljava/lang/Object;

    monitor-enter v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    :try_start_1
    const-string v1, "ImsRegCallbackHelper"

    .line 112
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "updateRegistrationState: registration state from "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mRegistrationState:I

    .line 113
    invoke-static {v3}, Landroid/telephony/ims/RegistrationManager;->registrationStateToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 114
    invoke-static {p1}, Landroid/telephony/ims/RegistrationManager;->registrationStateToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 112
    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 115
    iput p1, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->mRegistrationState:I

    .line 116
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 117
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    .line 116
    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    throw p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    :catchall_1
    move-exception p1

    monitor-exit p0

    throw p1
.end method
