.class final Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;
.super Landroid/telephony/data/IDataServiceCallback$Stub;
.source "DataServiceManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataServiceManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "DataServiceCallbackWrapper"
.end annotation


# instance fields
.field private final mTag:Ljava/lang/String;

.field final synthetic this$0:Lcom/android/internal/telephony/data/DataServiceManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V
    .locals 0

    .line 262
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-direct {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;-><init>()V

    .line 263
    iput-object p2, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->mTag:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public getTag()Ljava/lang/String;
    .locals 0

    .line 267
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->mTag:Ljava/lang/String;

    return-object p0
.end method

.method public onApnUnthrottled(Ljava/lang/String;)V
    .locals 2

    if-eqz p1, :cond_0

    .line 370
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmApnUnthrottledRegistrants(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

    move-result-object p0

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 373
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const-string p1, "onApnUnthrottled: apn is null"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public onDataCallListChanged(Ljava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataCallResponse;",
            ">;)V"
        }
    .end annotation

    .line 345
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    if-eqz p1, :cond_0

    move-object v1, p1

    goto :goto_0

    .line 346
    :cond_0
    sget-object v1, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    :goto_0
    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmLastDataCallResponseList(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/util/List;)V

    .line 347
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmDataCallListChangedRegistrants(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

    move-result-object p0

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public onDataProfileUnthrottled(Landroid/telephony/data/DataProfile;)V
    .locals 2

    if-eqz p1, :cond_0

    .line 380
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmApnUnthrottledRegistrants(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

    move-result-object p0

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 383
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const-string p1, "onDataProfileUnthrottled: dataProfile is null"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public onDeactivateDataCallComplete(I)V
    .locals 3

    .line 289
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onDeactivateDataCallComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 290
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 291
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 292
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onHandoverCancelled(I)V
    .locals 3

    .line 361
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onHandoverCancelled. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 362
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 363
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 364
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onHandoverStarted(I)V
    .locals 3

    .line 353
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onHandoverStarted. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 354
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 355
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 356
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onRequestDataCallListComplete(ILjava/util/List;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataCallResponse;",
            ">;)V"
        }
    .end annotation

    .line 313
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onRequestDataCallListComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 314
    invoke-static {p1}, Landroid/telephony/data/DataServiceCallback;->resultCodeToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 313
    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 316
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    if-eqz v0, :cond_0

    .line 318
    invoke-virtual {v0}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object v1

    const-string v2, "data_call_response"

    invoke-virtual {v1, v2, p2}, Landroid/os/Bundle;->putParcelableList(Ljava/lang/String;Ljava/util/List;)V

    .line 320
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v1, v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Message;I)V

    .line 323
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmTransportType(Lcom/android/internal/telephony/data/DataServiceManager;)I

    move-result p1

    const/4 v0, 0x1

    if-ne p1, v0, :cond_3

    .line 324
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmLastDataCallResponseList(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    if-ne p1, v0, :cond_1

    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmLastDataCallResponseList(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/List;

    move-result-object p1

    .line 325
    invoke-interface {p1, p2}, Ljava/util/List;->containsAll(Ljava/util/Collection;)Z

    move-result p1

    if-nez p1, :cond_2

    .line 326
    :cond_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "RIL reported mismatched data call response list for WWAN: mLastDataCallResponseList="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmLastDataCallResponseList(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/List;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ", dataCallList="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 329
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 330
    invoke-interface {p2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper$$ExternalSyntheticLambda0;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 331
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Set;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmLastDataCallResponseList(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper$$ExternalSyntheticLambda0;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper$$ExternalSyntheticLambda0;-><init>()V

    .line 332
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v1

    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    .line 331
    invoke-interface {v0, v1}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    const-string v0, "150323b2-360a-446b-a158-3ce6425821f6"

    .line 334
    invoke-static {v0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    .line 336
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v1

    .line 333
    invoke-static {v0, p1, v1}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    .line 339
    :cond_2
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->onDataCallListChanged(Ljava/util/List;)V

    :cond_3
    return-void
.end method

.method public onSetDataProfileComplete(I)V
    .locals 3

    .line 304
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onSetDataProfileComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 305
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 306
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onSetInitialAttachApnComplete(I)V
    .locals 3

    .line 297
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onSetInitialAttachApnComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 298
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 299
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onSetupDataCallComplete(ILandroid/telephony/data/DataCallResponse;)V
    .locals 3

    .line 274
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onSetupDataCallComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", response = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 277
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 278
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/data/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    if-eqz v0, :cond_0

    .line 280
    invoke-virtual {v0}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object v1

    const-string v2, "data_call_response"

    invoke-virtual {v1, v2, p2}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 281
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Message;I)V

    goto :goto_0

    .line 283
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const-string p1, "Unable to find the message for setup call response."

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    :goto_0
    return-void
.end method
