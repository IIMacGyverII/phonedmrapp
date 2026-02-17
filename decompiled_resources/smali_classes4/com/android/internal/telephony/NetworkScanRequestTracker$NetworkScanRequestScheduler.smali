.class Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;
.super Ljava/lang/Object;
.source "NetworkScanRequestTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NetworkScanRequestTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "NetworkScanRequestScheduler"
.end annotation


# instance fields
.field private mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

.field private mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

.field final synthetic this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;


# direct methods
.method static bridge synthetic -$$Nest$fgetmLiveRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPendingRequestInfo(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mdeleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mdoInterruptScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->doInterruptScan(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mdoStartScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->doStartScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mdoStopScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->doStopScan(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$minterruptScanDone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->interruptScanDone(Landroid/os/AsyncResult;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreceiveResult(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->receiveResult(Landroid/os/AsyncResult;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstartScanDone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->startScanDone(Landroid/os/AsyncResult;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstopScanDone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->stopScanDone(Landroid/os/AsyncResult;)V

    return-void
.end method

.method private constructor <init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;)V
    .locals 0

    .line 318
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;-><init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;)V

    return-void
.end method

.method private cacheScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method private commandExceptionErrorToScanError(Lcom/android/internal/telephony/CommandException$Error;)I
    .locals 2

    .line 358
    sget-object p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$2;->$SwitchMap$com$android$internal$telephony$CommandException$Error:[I

    invoke-virtual {p1}, Ljava/lang/Enum;->ordinal()I

    move-result v0

    aget p0, p0, v0

    const/4 v0, 0x1

    const-string v1, "ScanRequestTracker"

    packed-switch p0, :pswitch_data_0

    .line 384
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "commandExceptionErrorToScanError: Unexpected CommandExceptionError "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/16 p0, 0x2710

    return p0

    :pswitch_0
    const-string p0, "commandExceptionErrorToScanError: DEVICE_IN_USE"

    .line 381
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x3

    return p0

    :pswitch_1
    const-string p0, "commandExceptionErrorToScanError: INVALID_ARGUMENTS"

    .line 378
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x2

    return p0

    :pswitch_2
    const-string p0, "commandExceptionErrorToScanError: OPERATION_NOT_ALLOWED"

    .line 375
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :pswitch_3
    const-string p0, "commandExceptionErrorToScanError: MODEM_ERR"

    .line 372
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :pswitch_4
    const-string p0, "commandExceptionErrorToScanError: INTERNAL_ERR"

    .line 369
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :pswitch_5
    const-string p0, "commandExceptionErrorToScanError: NO_MEMORY"

    .line 366
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :pswitch_6
    const-string p0, "commandExceptionErrorToScanError: REQUEST_NOT_SUPPORTED"

    .line 363
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x4

    return p0

    :pswitch_7
    const-string p0, "commandExceptionErrorToScanError: RADIO_NOT_AVAILABLE"

    .line 360
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private declared-synchronized deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V
    .locals 2

    monitor-enter p0

    .line 593
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-eqz v0, :cond_2

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v1

    if-ne v0, v1, :cond_2

    const/4 v0, 0x0

    if-eqz p3, :cond_1

    if-nez p2, :cond_0

    .line 596
    iget-object p3, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    const/4 v1, 0x3

    invoke-static {p3, p1, v1, p2, v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    goto :goto_0

    .line 599
    :cond_0
    iget-object p3, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    const/4 v1, 0x2

    invoke-static {p3, p1, v1, p2, v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    .line 603
    :cond_1
    :goto_0
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p2}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object p2

    invoke-interface {p1, p2}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForModemReset(Landroid/os/Handler;)V

    .line 604
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p2}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object p2

    invoke-interface {p1, p2}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForNotAvailable(Landroid/os/Handler;)V

    .line 605
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    .line 606
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-eqz p1, :cond_2

    .line 607
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->startNewScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z

    .line 608
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 611
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized doInterruptScan(I)V
    .locals 3

    monitor-enter p0

    .line 534
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-eqz v0, :cond_0

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v0

    if-ne p1, v0, :cond_0

    .line 535
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object v0

    const/4 v1, 0x7

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-virtual {v0, v1, v2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-interface {p1, v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->stopNetworkScan(Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string v0, "ScanRequestTracker"

    .line 538
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "doInterruptScan: scan "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " does not exist!"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 540
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private doStartScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)V
    .locals 4

    const-string v0, "ScanRequestTracker"

    if-nez p1, :cond_0

    const-string p0, "CMD_START_NETWORK_SCAN: nsri is null"

    .line 392
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 395
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v1, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$misValidScan(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x2

    if-nez v1, :cond_1

    .line 396
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0, p1, v3, v3, v2}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    return-void

    .line 400
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->getIsBinderDead()Z

    move-result v1

    if-eqz v1, :cond_2

    const-string p0, "CMD_START_NETWORK_SCAN: Binder has died"

    .line 401
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 404
    :cond_2
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->startNewScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z

    move-result v0

    if-nez v0, :cond_3

    .line 405
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->interruptLiveScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z

    move-result v0

    if-nez v0, :cond_3

    .line 406
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->cacheScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z

    move-result v0

    if-nez v0, :cond_3

    .line 407
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    const/4 v0, 0x3

    invoke-static {p0, p1, v3, v0, v2}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    :cond_3
    return-void
.end method

.method private declared-synchronized doStopScan(I)V
    .locals 4

    monitor-enter p0

    .line 499
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-eqz v0, :cond_0

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v0

    if-ne p1, v0, :cond_0

    .line 500
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object v0

    const/4 v1, 0x5

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    .line 501
    invoke-virtual {v0, v1, v2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    .line 500
    invoke-interface {p1, v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->stopNetworkScan(Landroid/os/Message;)V

    goto :goto_0

    .line 502
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-eqz v0, :cond_1

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v0

    if-ne p1, v0, :cond_1

    .line 503
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    const/4 v1, 0x3

    const/4 v2, 0x0

    const/4 v3, 0x0

    invoke-static {p1, v0, v1, v2, v3}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    .line 505
    iput-object v3, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    goto :goto_0

    :cond_1
    const-string v0, "ScanRequestTracker"

    .line 507
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "stopScan: scan "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " does not exist!"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 509
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized interruptLiveScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z
    .locals 4

    monitor-enter p0

    .line 559
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-nez v0, :cond_0

    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmUid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v0

    const/16 v1, 0x3e8

    if-ne v0, v1, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmUid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v0

    if-eq v0, v1, :cond_0

    .line 562
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->doInterruptScan(I)V

    .line 563
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mPendingRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    .line 564
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    const/4 v1, 0x2

    const/16 v2, 0x2712

    const/4 v3, 0x0

    invoke-static {p1, v0, v1, v2, v3}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 p1, 0x1

    .line 566
    monitor-exit p0

    return p1

    :cond_0
    const/4 p1, 0x0

    .line 568
    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private interruptScanDone(Landroid/os/AsyncResult;)V
    .locals 2

    .line 543
    iget-object p1, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-nez p1, :cond_0

    const-string p0, "ScanRequestTracker"

    const-string p1, "EVENT_INTERRUPT_NETWORK_SCAN_DONE: nsri is null"

    .line 545
    invoke-static {p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 548
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForNetworkScanResult(Landroid/os/Handler;)V

    const/4 v0, 0x0

    .line 549
    invoke-direct {p0, p1, v0, v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    return-void
.end method

.method private receiveResult(Landroid/os/AsyncResult;)V
    .locals 7

    .line 441
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-nez v0, :cond_0

    const-string p0, "ScanRequestTracker"

    const-string p1, "EVENT_RECEIVE_NETWORK_SCAN_RESULT: nsri is null"

    .line 443
    invoke-static {p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 446
    :cond_0
    new-instance v1, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    invoke-direct {v1}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;-><init>()V

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmCallingPackage(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Ljava/lang/String;

    move-result-object v2

    .line 448
    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setCallingPackage(Ljava/lang/String;)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v2

    .line 449
    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setCallingPid(I)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmUid(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v2

    .line 450
    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setCallingUid(I)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object v2

    .line 451
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setCallingFeatureId(Ljava/lang/String;)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    const/16 v2, 0x1d

    .line 452
    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setMinSdkVersionForFine(I)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    .line 453
    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setMinSdkVersionForCoarse(I)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    .line 454
    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setMinSdkVersionForEnforcement(I)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    const-string v2, "NetworkScanTracker#onResult"

    .line 455
    invoke-virtual {v1, v2}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->setMethod(Ljava/lang/String;)Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;

    move-result-object v1

    .line 456
    invoke-virtual {v1}, Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery$Builder;->build()Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery;

    move-result-object v1

    .line 457
    iget-object v2, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    const/4 v3, 0x1

    if-nez v2, :cond_6

    iget-object v2, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz v2, :cond_6

    .line 458
    check-cast v2, Lcom/android/internal/telephony/NetworkScanResult;

    .line 459
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmRenounceFineLocationAccess(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z

    move-result p1

    const/4 v4, 0x0

    if-nez p1, :cond_1

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    .line 461
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    .line 460
    invoke-static {p1, v1}, Landroid/telephony/LocationAccessPolicy;->checkLocationPermission(Landroid/content/Context;Landroid/telephony/LocationAccessPolicy$LocationPermissionQuery;)Landroid/telephony/LocationAccessPolicy$LocationPermissionResult;

    move-result-object p1

    sget-object v1, Landroid/telephony/LocationAccessPolicy$LocationPermissionResult;->ALLOWED:Landroid/telephony/LocationAccessPolicy$LocationPermissionResult;

    if-ne p1, v1, :cond_1

    move p1, v3

    goto :goto_0

    :cond_1
    move p1, v4

    :goto_0
    if-eqz p1, :cond_2

    move p1, v3

    goto :goto_1

    :cond_2
    const/4 p1, 0x4

    .line 466
    :goto_1
    iget v1, v2, Lcom/android/internal/telephony/NetworkScanResult;->scanError:I

    if-nez v1, :cond_4

    .line 467
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v1

    if-eqz v1, :cond_3

    .line 468
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v1

    iget-object v5, v2, Lcom/android/internal/telephony/NetworkScanResult;->networkInfos:Ljava/util/List;

    invoke-virtual {v1, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNameForCellInfo(Ljava/util/List;)V

    .line 472
    :cond_3
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    iget v5, v2, Lcom/android/internal/telephony/NetworkScanResult;->scanError:I

    .line 473
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->rilErrorToScanError(I)I

    move-result v5

    iget-object v6, v2, Lcom/android/internal/telephony/NetworkScanResult;->networkInfos:Ljava/util/List;

    .line 472
    invoke-static {v1, v0, p1, v5, v6}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    .line 474
    iget p1, v2, Lcom/android/internal/telephony/NetworkScanResult;->scanStatus:I

    const/4 v1, 0x2

    if-ne p1, v1, :cond_7

    .line 475
    invoke-direct {p0, v0, v4, v3}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    .line 476
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForNetworkScanResult(Landroid/os/Handler;)V

    goto :goto_2

    .line 479
    :cond_4
    iget-object v4, v2, Lcom/android/internal/telephony/NetworkScanResult;->networkInfos:Ljava/util/List;

    if-eqz v4, :cond_5

    .line 480
    iget-object v4, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    .line 481
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->rilErrorToScanError(I)I

    move-result v1

    iget-object v5, v2, Lcom/android/internal/telephony/NetworkScanResult;->networkInfos:Ljava/util/List;

    .line 480
    invoke-static {v4, v0, p1, v1, v5}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mnotifyMessenger(Lcom/android/internal/telephony/NetworkScanRequestTracker;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IILjava/util/List;)V

    .line 483
    :cond_5
    iget p1, v2, Lcom/android/internal/telephony/NetworkScanResult;->scanError:I

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->rilErrorToScanError(I)I

    move-result p1

    invoke-direct {p0, v0, p1, v3}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    .line 484
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForNetworkScanResult(Landroid/os/Handler;)V

    goto :goto_2

    .line 487
    :cond_6
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v1, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mlogEmptyResultOrException(Lcom/android/internal/telephony/NetworkScanRequestTracker;Landroid/os/AsyncResult;)V

    const/16 p1, 0x2710

    .line 488
    invoke-direct {p0, v0, p1, v3}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    .line 489
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForNetworkScanResult(Landroid/os/Handler;)V

    :cond_7
    :goto_2
    return-void
.end method

.method private rilErrorToScanError(I)I
    .locals 2

    if-eqz p1, :cond_8

    const/4 p0, 0x1

    const-string v0, "ScanRequestTracker"

    if-eq p1, p0, :cond_7

    const/4 v1, 0x6

    if-eq p1, v1, :cond_6

    const/16 v1, 0x28

    if-eq p1, v1, :cond_5

    const/16 v1, 0x2c

    if-eq p1, v1, :cond_4

    const/16 v1, 0x36

    if-eq p1, v1, :cond_3

    const/16 v1, 0x40

    if-eq p1, v1, :cond_2

    const/16 v1, 0x25

    if-eq p1, v1, :cond_1

    const/16 v1, 0x26

    if-eq p1, v1, :cond_0

    .line 352
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "rilErrorToScanError: Unexpected RadioError "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/16 p0, 0x2710

    return p0

    :cond_0
    const-string p1, "rilErrorToScanError: INTERNAL_ERR"

    .line 337
    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return p0

    :cond_1
    const-string p1, "rilErrorToScanError: NO_MEMORY"

    .line 334
    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return p0

    :cond_2
    const-string p0, "rilErrorToScanError: DEVICE_IN_USE"

    .line 349
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x3

    return p0

    :cond_3
    const-string p1, "rilErrorToScanError: OPERATION_NOT_ALLOWED"

    .line 343
    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return p0

    :cond_4
    const-string p0, "rilErrorToScanError: INVALID_ARGUMENTS"

    .line 346
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x2

    return p0

    :cond_5
    const-string p1, "rilErrorToScanError: MODEM_ERR"

    .line 340
    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return p0

    :cond_6
    const-string p0, "rilErrorToScanError: REQUEST_NOT_SUPPORTED"

    .line 331
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x4

    return p0

    :cond_7
    const-string p1, "rilErrorToScanError: RADIO_NOT_AVAILABLE"

    .line 328
    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return p0

    :cond_8
    const/4 p0, 0x0

    return p0
.end method

.method private declared-synchronized startNewScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Z
    .locals 4

    monitor-enter p0

    .line 578
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-nez v0, :cond_0

    .line 579
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    .line 580
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->getRequest()Landroid/telephony/NetworkScanRequest;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v2}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object v2

    const/4 v3, 0x2

    .line 581
    invoke-virtual {v2, v3, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v2

    .line 580
    invoke-interface {v0, v1, v2}, Lcom/android/internal/telephony/PhoneInternalInterface;->startNetworkScan(Landroid/telephony/NetworkScanRequest;Landroid/os/Message;)V

    .line 582
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object v1

    const/16 v2, 0x8

    invoke-interface {v0, v1, v2, p1}, Lcom/android/internal/telephony/CommandsInterface;->registerForModemReset(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 583
    invoke-static {p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object v1

    const/16 v2, 0x9

    invoke-interface {v0, v1, v2, p1}, Lcom/android/internal/telephony/CommandsInterface;->registerForNotAvailable(Landroid/os/Handler;ILjava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 p1, 0x1

    .line 584
    monitor-exit p0

    return p1

    :cond_0
    const/4 p1, 0x0

    .line 586
    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized startScanDone(Landroid/os/AsyncResult;)V
    .locals 3

    monitor-enter p0

    .line 415
    :try_start_0
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-nez v0, :cond_0

    const-string p1, "ScanRequestTracker"

    const-string v0, "EVENT_START_NETWORK_SCAN_DONE: nsri is null"

    .line 417
    invoke-static {p1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 418
    monitor-exit p0

    return-void

    .line 420
    :cond_0
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    if-eqz v1, :cond_4

    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v1

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->mLiveRequestInfo:Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {v2}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmScanId(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)I

    move-result v2

    if-eq v1, v2, :cond_1

    goto :goto_1

    .line 424
    :cond_1
    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v1, :cond_2

    iget-object v1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz v1, :cond_2

    .line 426
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object v1

    const/4 v2, 0x3

    invoke-interface {p1, v1, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForNetworkScanResult(Landroid/os/Handler;ILjava/lang/Object;)V

    goto :goto_0

    .line 429
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v1, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mlogEmptyResultOrException(Lcom/android/internal/telephony/NetworkScanRequestTracker;Landroid/os/AsyncResult;)V

    .line 430
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz p1, :cond_3

    .line 431
    check-cast p1, Lcom/android/internal/telephony/CommandException;

    .line 432
    invoke-virtual {p1}, Lcom/android/internal/telephony/CommandException;->getCommandError()Lcom/android/internal/telephony/CommandException$Error;

    move-result-object p1

    .line 433
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->commandExceptionErrorToScanError(Lcom/android/internal/telephony/CommandException$Error;)I

    move-result p1

    const/4 v1, 0x1

    invoke-direct {p0, v0, p1, v1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    goto :goto_0

    :cond_3
    const-string p1, "ScanRequestTracker"

    const-string v0, "EVENT_START_NETWORK_SCAN_DONE: ar.exception can not be null!"

    .line 435
    invoke-static {p1, v0}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 438
    :goto_0
    monitor-exit p0

    return-void

    :cond_4
    :goto_1
    :try_start_2
    const-string p1, "ScanRequestTracker"

    const-string v0, "EVENT_START_NETWORK_SCAN_DONE: nsri does not match mLiveRequestInfo"

    .line 421
    invoke-static {p1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 422
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private stopScanDone(Landroid/os/AsyncResult;)V
    .locals 4

    .line 512
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    const-string v1, "ScanRequestTracker"

    if-nez v0, :cond_0

    const-string p0, "EVENT_STOP_NETWORK_SCAN_DONE: nsri is null"

    .line 514
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 517
    :cond_0
    iget-object v2, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    const/4 v3, 0x1

    if-nez v2, :cond_1

    iget-object v2, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz v2, :cond_1

    const/4 p1, 0x0

    .line 518
    invoke-direct {p0, v0, p1, v3}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    goto :goto_0

    .line 520
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {v2, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$mlogEmptyResultOrException(Lcom/android/internal/telephony/NetworkScanRequestTracker;Landroid/os/AsyncResult;)V

    .line 521
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz p1, :cond_2

    .line 522
    check-cast p1, Lcom/android/internal/telephony/CommandException;

    .line 523
    invoke-virtual {p1}, Lcom/android/internal/telephony/CommandException;->getCommandError()Lcom/android/internal/telephony/CommandException$Error;

    move-result-object p1

    .line 524
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->commandExceptionErrorToScanError(Lcom/android/internal/telephony/CommandException$Error;)I

    move-result p1

    invoke-direct {p0, v0, p1, v3}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->deleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    goto :goto_0

    :cond_2
    const-string p1, "EVENT_STOP_NETWORK_SCAN_DONE: ar.exception can not be null!"

    .line 526
    invoke-static {v1, p1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 529
    :goto_0
    invoke-static {v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Landroid/os/Handler;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForNetworkScanResult(Landroid/os/Handler;)V

    return-void
.end method
