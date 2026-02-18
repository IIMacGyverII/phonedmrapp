.class Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;
.super Ljava/lang/Object;
.source "NetworkScanRequestTracker.java"

# interfaces
.implements Landroid/os/IBinder$DeathRecipient;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NetworkScanRequestTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "NetworkScanRequestInfo"
.end annotation


# instance fields
.field private final mBinder:Landroid/os/IBinder;

.field private final mCallingPackage:Ljava/lang/String;

.field private mIsBinderDead:Z

.field private final mMessenger:Landroid/os/Messenger;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mPid:I

.field private mRenounceFineLocationAccess:Z

.field private final mRequest:Landroid/telephony/NetworkScanRequest;

.field private final mScanId:I

.field private final mUid:I

.field final synthetic this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;


# direct methods
.method static bridge synthetic -$$Nest$fgetmCallingPackage(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mCallingPackage:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/os/Messenger;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mMessenger:Landroid/os/Messenger;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mPid:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRenounceFineLocationAccess(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mRenounceFineLocationAccess:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRequest(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Landroid/telephony/NetworkScanRequest;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mRequest:Landroid/telephony/NetworkScanRequest;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mScanId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmUid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mUid:I

    return p0
.end method

.method constructor <init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;Landroid/telephony/NetworkScanRequest;Landroid/os/Messenger;Landroid/os/IBinder;ILcom/android/internal/telephony/Phone;IILjava/lang/String;Z)V
    .locals 0

    .line 268
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    .line 269
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 270
    iput-object p2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mRequest:Landroid/telephony/NetworkScanRequest;

    .line 271
    iput-object p3, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mMessenger:Landroid/os/Messenger;

    .line 272
    iput-object p4, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mBinder:Landroid/os/IBinder;

    .line 273
    iput p5, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mScanId:I

    .line 274
    iput-object p6, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 275
    iput p7, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mUid:I

    .line 276
    iput p8, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mPid:I

    .line 277
    iput-object p9, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mCallingPackage:Ljava/lang/String;

    const/4 p1, 0x0

    .line 278
    iput-boolean p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mIsBinderDead:Z

    .line 279
    iput-boolean p10, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mRenounceFineLocationAccess:Z

    .line 282
    :try_start_0
    invoke-interface {p4, p0, p1}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 284
    :catch_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->binderDied()V

    :goto_0
    return-void
.end method


# virtual methods
.method public binderDied()V
    .locals 2

    .line 308
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "PhoneInterfaceManager NetworkScanRequestInfo binderDied("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mRequest:Landroid/telephony/NetworkScanRequest;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mBinder:Landroid/os/IBinder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ScanRequestTracker"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x1

    .line 310
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->setIsBinderDead(Z)V

    .line 311
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    iget p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mScanId:I

    invoke-static {v0, p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$minterruptNetworkScan(Lcom/android/internal/telephony/NetworkScanRequestTracker;I)V

    return-void
.end method

.method declared-synchronized getIsBinderDead()Z
    .locals 1

    monitor-enter p0

    .line 293
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mIsBinderDead:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method getRequest()Landroid/telephony/NetworkScanRequest;
    .locals 0

    .line 297
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mRequest:Landroid/telephony/NetworkScanRequest;

    return-object p0
.end method

.method declared-synchronized setIsBinderDead(Z)V
    .locals 0

    monitor-enter p0

    .line 289
    :try_start_0
    iput-boolean p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mIsBinderDead:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 290
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method unlinkDeathRecipient()V
    .locals 2

    .line 301
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->mBinder:Landroid/os/IBinder;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 302
    invoke-interface {v0, p0, v1}, Landroid/os/IBinder;->unlinkToDeath(Landroid/os/IBinder$DeathRecipient;I)Z

    :cond_0
    return-void
.end method
