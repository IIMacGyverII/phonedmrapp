.class public Lcom/android/internal/telephony/RIL$RilHandler;
.super Landroid/os/Handler;
.source "RIL.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/RIL;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "RilHandler"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/RIL;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RIL;)V
    .locals 0

    .line 287
    iput-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 7

    .line 294
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x2

    const/4 v2, 0x0

    if-eq v0, v1, :cond_6

    const/4 v1, 0x4

    if-eq v0, v1, :cond_5

    const/4 v1, 0x5

    if-eq v0, v1, :cond_2

    const/4 v1, 0x6

    if-eq v0, v1, :cond_1

    const/4 v1, 0x7

    if-eq v0, v1, :cond_0

    goto/16 :goto_1

    .line 366
    :cond_0
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 367
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v3

    .line 368
    iget-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "handleMessage: EVENT_AIDL_PROXY_DEAD cookie = "

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v5, ", service = "

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 369
    invoke-static {v0}, Lcom/android/internal/telephony/RIL;->-$$Nest$smserviceToString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ", cookie = "

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object v5, v5, Lcom/android/internal/telephony/RIL;->mServiceCookies:Landroid/util/SparseArray;

    .line 370
    invoke-virtual {v5, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 368
    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    .line 371
    iget-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object p1, p1, Lcom/android/internal/telephony/RIL;->mServiceCookies:Landroid/util/SparseArray;

    invoke-virtual {p1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/concurrent/atomic/AtomicLong;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicLong;->get()J

    move-result-wide v5

    cmp-long p1, v3, v5

    if-nez p1, :cond_9

    .line 372
    iget-object p0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iput-boolean v2, p0, Lcom/android/internal/telephony/RIL;->mIsRadioProxyInitialized:Z

    .line 373
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RIL;->resetProxyAndRequestList(I)V

    goto/16 :goto_1

    .line 355
    :cond_1
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 356
    iget-object v1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "handleMessage: EVENT_RADIO_PROXY_DEAD cookie = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", service = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 357
    invoke-static {v0}, Lcom/android/internal/telephony/RIL;->-$$Nest$smserviceToString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", service cookie = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object v4, v4, Lcom/android/internal/telephony/RIL;->mServiceCookies:Landroid/util/SparseArray;

    .line 358
    invoke-virtual {v4, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 356
    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    .line 359
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v3

    iget-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object p1, p1, Lcom/android/internal/telephony/RIL;->mServiceCookies:Landroid/util/SparseArray;

    invoke-virtual {p1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/concurrent/atomic/AtomicLong;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicLong;->get()J

    move-result-wide v5

    cmp-long p1, v3, v5

    if-nez p1, :cond_9

    .line 360
    iget-object p0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iput-boolean v2, p0, Lcom/android/internal/telephony/RIL;->mIsRadioProxyInitialized:Z

    .line 361
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RIL;->resetProxyAndRequestList(I)V

    goto/16 :goto_1

    .line 335
    :cond_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    .line 336
    iget-object v0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/RIL;->-$$Nest$mfindAndRemoveRequestFromList(Lcom/android/internal/telephony/RIL;I)Lcom/android/internal/telephony/RILRequest;

    move-result-object p1

    if-nez p1, :cond_3

    goto/16 :goto_1

    .line 343
    :cond_3
    iget-object v0, p1, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    if-eqz v0, :cond_4

    .line 344
    invoke-static {p1}, Lcom/android/internal/telephony/RIL;->-$$Nest$smgetResponseForTimedOutRILRequest(Lcom/android/internal/telephony/RILRequest;)Ljava/lang/Object;

    move-result-object v0

    .line 345
    iget-object v1, p1, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    const/4 v2, 0x0

    invoke-static {v1, v0, v2}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 346
    iget-object v0, p1, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-virtual {v0}, Landroid/os/Message;->sendToTarget()V

    .line 347
    iget-object v0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object v1, v0, Lcom/android/internal/telephony/RIL;->mMetrics:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    iget-object v0, v0, Lcom/android/internal/telephony/RIL;->mPhoneId:Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    iget v2, p1, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    iget v3, p1, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-virtual {v1, v0, v2, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeOnRilTimeoutResponse(III)V

    .line 350
    :cond_4
    iget-object p0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/RIL;->-$$Nest$mdecrementWakeLock(Lcom/android/internal/telephony/RIL;Lcom/android/internal/telephony/RILRequest;)V

    .line 351
    invoke-virtual {p1}, Lcom/android/internal/telephony/RILRequest;->release()V

    goto/16 :goto_1

    .line 327
    :cond_5
    iget p1, p1, Landroid/os/Message;->arg1:I

    iget-object v0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget v0, v0, Lcom/android/internal/telephony/RIL;->mAckWlSequenceNum:I

    if-ne p1, v0, :cond_9

    iget-object p0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    const/4 p1, 0x1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/RIL;->-$$Nest$mclearWakeLock(Lcom/android/internal/telephony/RIL;I)Z

    goto/16 :goto_1

    .line 307
    :cond_6
    iget-object v0, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object v0, v0, Lcom/android/internal/telephony/RIL;->mRequestList:Landroid/util/SparseArray;

    monitor-enter v0

    .line 308
    :try_start_0
    iget p1, p1, Landroid/os/Message;->arg1:I

    iget-object v1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget v1, v1, Lcom/android/internal/telephony/RIL;->mWlSequenceNum:I

    if-ne p1, v1, :cond_8

    iget-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    invoke-static {p1, v2}, Lcom/android/internal/telephony/RIL;->-$$Nest$mclearWakeLock(Lcom/android/internal/telephony/RIL;I)Z

    move-result p1

    if-eqz p1, :cond_8

    .line 309
    iget-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    invoke-static {p1}, Lcom/android/internal/telephony/RIL;->-$$Nest$fgetmRadioBugDetector(Lcom/android/internal/telephony/RIL;)Lcom/android/internal/telephony/RadioBugDetector;

    move-result-object p1

    if-eqz p1, :cond_7

    .line 310
    iget-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    invoke-static {p1}, Lcom/android/internal/telephony/RIL;->-$$Nest$fgetmRadioBugDetector(Lcom/android/internal/telephony/RIL;)Lcom/android/internal/telephony/RadioBugDetector;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/RadioBugDetector;->processWakelockTimeout()V

    .line 313
    :cond_7
    iget-object p1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object p1, p1, Lcom/android/internal/telephony/RIL;->mRequestList:Landroid/util/SparseArray;

    invoke-virtual {p1}, Landroid/util/SparseArray;->size()I

    move-result p1

    const-string v1, "RILJ"

    .line 314
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "WAKE_LOCK_TIMEOUT  mRequestList="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    if-ge v2, p1, :cond_8

    .line 317
    iget-object v1, p0, Lcom/android/internal/telephony/RIL$RilHandler;->this$0:Lcom/android/internal/telephony/RIL;

    iget-object v1, v1, Lcom/android/internal/telephony/RIL;->mRequestList:Landroid/util/SparseArray;

    invoke-virtual {v1, v2}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/RILRequest;

    const-string v3, "RILJ"

    .line 318
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, ": ["

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v1, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "] "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, v1, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    .line 319
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 318
    invoke-static {v3, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 323
    :cond_8
    monitor-exit v0

    :cond_9
    :goto_1
    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
