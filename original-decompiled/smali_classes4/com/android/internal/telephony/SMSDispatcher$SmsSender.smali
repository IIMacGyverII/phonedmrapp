.class public abstract Lcom/android/internal/telephony/SMSDispatcher$SmsSender;
.super Landroid/os/Handler;
.source "SMSDispatcher.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/SMSDispatcher;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x404
    name = "SmsSender"
.end annotation


# static fields
.field private static final EVENT_TIMEOUT:I = 0x1


# instance fields
.field protected final mCarrierMessagingServiceWrapper:Landroid/service/carrier/CarrierMessagingServiceWrapper;

.field private mCarrierPackageName:Ljava/lang/String;

.field protected volatile mSenderCallback:Landroid/service/carrier/CarrierMessagingServiceWrapper$CarrierMessagingCallback;

.field final synthetic this$0:Lcom/android/internal/telephony/SMSDispatcher;


# direct methods
.method public static synthetic $r8$lambda$khCqrQ6wa4_BVpJeSgt1BAdiZRU(Lcom/android/internal/telephony/SMSDispatcher$SmsSender;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->lambda$sendSmsByCarrierApp$1()V

    return-void
.end method

.method public static synthetic $r8$lambda$qsCz0PfjOnvG9jNRWEI5eLTxZCo(Ljava/lang/Runnable;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->lambda$sendSmsByCarrierApp$0(Ljava/lang/Runnable;)V

    return-void
.end method

.method protected constructor <init>(Lcom/android/internal/telephony/SMSDispatcher;)V
    .locals 0

    .line 388
    iput-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->this$0:Lcom/android/internal/telephony/SMSDispatcher;

    .line 389
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object p1

    invoke-direct {p0, p1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 384
    new-instance p1, Landroid/service/carrier/CarrierMessagingServiceWrapper;

    invoke-direct {p1}, Landroid/service/carrier/CarrierMessagingServiceWrapper;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->mCarrierMessagingServiceWrapper:Landroid/service/carrier/CarrierMessagingServiceWrapper;

    return-void
.end method

.method private static synthetic lambda$sendSmsByCarrierApp$0(Ljava/lang/Runnable;)V
    .locals 0

    .line 400
    invoke-interface {p0}, Ljava/lang/Runnable;->run()V

    return-void
.end method

.method private synthetic lambda$sendSmsByCarrierApp$1()V
    .locals 0

    .line 401
    invoke-virtual {p0}, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->onServiceReady()V

    return-void
.end method


# virtual methods
.method public abstract getSmsTracker()Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;
.end method

.method public abstract getSmsTrackers()[Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 435
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 436
    iget-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->this$0:Lcom/android/internal/telephony/SMSDispatcher;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "handleMessage: No response from "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->mCarrierPackageName:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " for "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->this$0:Lcom/android/internal/telephony/SMSDispatcher;

    iget v2, v2, Lcom/android/internal/telephony/SMSDispatcher;->mCarrierMessagingTimeout:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " ms"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/SMSDispatcher;->-$$Nest$mlogWithLocalLog(Lcom/android/internal/telephony/SMSDispatcher;Ljava/lang/String;)V

    .line 438
    invoke-static {}, Lcom/android/internal/telephony/SMSDispatcher;->-$$Nest$sfgetsAnomalyNoResponseFromCarrierMessagingService()Ljava/util/UUID;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "No response from "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->mCarrierPackageName:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->this$0:Lcom/android/internal/telephony/SMSDispatcher;

    iget-object v2, v2, Lcom/android/internal/telephony/SMSDispatcher;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 439
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v2

    .line 438
    invoke-static {p1, v0, v2}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    .line 440
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->onSendComplete(I)V

    goto :goto_0

    .line 442
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->this$0:Lcom/android/internal/telephony/SMSDispatcher;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleMessage: received unexpected message "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/SMSDispatcher;->-$$Nest$mlogWithLocalLog(Lcom/android/internal/telephony/SMSDispatcher;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public abstract onSendComplete(I)V
.end method

.method public abstract onServiceReady()V
.end method

.method public removeTimeout()V
    .locals 1

    const/4 v0, 0x1

    .line 447
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    return-void
.end method

.method public declared-synchronized sendSmsByCarrierApp(Ljava/lang/String;Landroid/service/carrier/CarrierMessagingServiceWrapper$CarrierMessagingCallback;)V
    .locals 3

    monitor-enter p0

    .line 397
    :try_start_0
    iput-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->mCarrierPackageName:Ljava/lang/String;

    .line 398
    iput-object p2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->mSenderCallback:Landroid/service/carrier/CarrierMessagingServiceWrapper$CarrierMessagingCallback;

    .line 399
    iget-object p2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->mCarrierMessagingServiceWrapper:Landroid/service/carrier/CarrierMessagingServiceWrapper;

    iget-object v0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->this$0:Lcom/android/internal/telephony/SMSDispatcher;

    iget-object v0, v0, Lcom/android/internal/telephony/SMSDispatcher;->mContext:Landroid/content/Context;

    new-instance v1, Lcom/android/internal/telephony/SMSDispatcher$SmsSender$$ExternalSyntheticLambda0;

    invoke-direct {v1}, Lcom/android/internal/telephony/SMSDispatcher$SmsSender$$ExternalSyntheticLambda0;-><init>()V

    new-instance v2, Lcom/android/internal/telephony/SMSDispatcher$SmsSender$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/SMSDispatcher$SmsSender$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/SMSDispatcher$SmsSender;)V

    invoke-virtual {p2, v0, p1, v1, v2}, Landroid/service/carrier/CarrierMessagingServiceWrapper;->bindToCarrierMessagingService(Landroid/content/Context;Ljava/lang/String;Ljava/util/concurrent/Executor;Ljava/lang/Runnable;)Z

    move-result p1

    const/4 p2, 0x1

    if-nez p1, :cond_0

    const-string p1, "SMSDispatcher"

    const-string v0, "bindService() for carrier messaging service failed"

    .line 402
    invoke-static {p1, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 403
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->onSendComplete(I)V

    goto :goto_0

    :cond_0
    const-string p1, "SMSDispatcher"

    const-string v0, "bindService() for carrier messaging service succeeded"

    .line 405
    invoke-static {p1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 406
    invoke-virtual {p0, p2}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    iget-object p2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsSender;->this$0:Lcom/android/internal/telephony/SMSDispatcher;

    iget p2, p2, Lcom/android/internal/telephony/SMSDispatcher;->mCarrierMessagingTimeout:I

    int-to-long v0, p2

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 408
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
