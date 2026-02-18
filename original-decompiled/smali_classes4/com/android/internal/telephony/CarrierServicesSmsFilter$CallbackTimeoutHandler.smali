.class public final Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;
.super Landroid/os/Handler;
.source "CarrierServicesSmsFilter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierServicesSmsFilter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x14
    name = "CallbackTimeoutHandler"
.end annotation


# static fields
.field private static final DBG:Z = true


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/CarrierServicesSmsFilter;


# direct methods
.method public static synthetic $r8$lambda$T-oAK7r9a6q8d-nHpovn5Gwv1wQ(Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->lambda$handleMessage$0(Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method protected constructor <init>(Lcom/android/internal/telephony/CarrierServicesSmsFilter;)V
    .locals 0

    .line 389
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->this$0:Lcom/android/internal/telephony/CarrierServicesSmsFilter;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method

.method private handleFilterCallbacksTimeout()V
    .locals 4

    .line 415
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->this$0:Lcom/android/internal/telephony/CarrierServicesSmsFilter;

    invoke-static {v0}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;->-$$Nest$fgetmFilterAggregator(Lcom/android/internal/telephony/CarrierServicesSmsFilter;)Lcom/android/internal/telephony/CarrierServicesSmsFilter$FilterAggregator;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$FilterAggregator;->-$$Nest$fgetmCallbacks(Lcom/android/internal/telephony/CarrierServicesSmsFilter$FilterAggregator;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;

    .line 416
    iget-object v2, p0, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->this$0:Lcom/android/internal/telephony/CarrierServicesSmsFilter;

    const-string v3, "handleFilterCallbacksTimeout: calling onFilterComplete"

    invoke-static {v2, v3}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;->-$$Nest$mlog(Lcom/android/internal/telephony/CarrierServicesSmsFilter;Ljava/lang/String;)V

    const/4 v2, 0x0

    .line 417
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;->onReceiveSmsComplete(I)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private static synthetic lambda$handleMessage$0(Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;)Ljava/lang/String;
    .locals 0

    .line 405
    invoke-static {p0}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;->-$$Nest$fgetmPackageName(Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 396
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->this$0:Lcom/android/internal/telephony/CarrierServicesSmsFilter;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "CallbackTimeoutHandler: handleMessage("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Landroid/os/Message;->what:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;->-$$Nest$mlog(Lcom/android/internal/telephony/CarrierServicesSmsFilter;Ljava/lang/String;)V

    .line 399
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 401
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->this$0:Lcom/android/internal/telephony/CarrierServicesSmsFilter;

    invoke-static {v0}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;->-$$Nest$fgetmLocalLog(Lcom/android/internal/telephony/CarrierServicesSmsFilter;)Lcom/android/internal/telephony/LocalLog;

    move-result-object v0

    const-string v1, "CarrierServicesSmsFilter: onFilterComplete timeout: not called before 600000 milliseconds."

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 403
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/CarrierServicesSmsFilter$FilterAggregator;

    .line 404
    invoke-static {p1}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$FilterAggregator;->-$$Nest$fgetmCallbacks(Lcom/android/internal/telephony/CarrierServicesSmsFilter$FilterAggregator;)Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler$$ExternalSyntheticLambda0;-><init>()V

    .line 405
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p1

    const-string v0, ", "

    .line 406
    invoke-static {v0}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    .line 407
    invoke-static {}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;->-$$Nest$sfgetsAnomalyNoResponseFromCarrierMessagingService()Ljava/util/UUID;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "No response from "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->this$0:Lcom/android/internal/telephony/CarrierServicesSmsFilter;

    invoke-static {v1}, Lcom/android/internal/telephony/CarrierServicesSmsFilter;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/CarrierServicesSmsFilter;)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    .line 408
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v1

    .line 407
    invoke-static {v0, p1, v1}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    .line 409
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->handleFilterCallbacksTimeout()V

    :goto_0
    return-void
.end method
