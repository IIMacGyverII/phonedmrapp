.class final Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;
.super Landroid/telephony/data/IDataServiceCallback$Stub;
.source "DataServiceManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataServiceManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "CellularDataServiceCallback"
.end annotation


# instance fields
.field private final mTag:Ljava/lang/String;

.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V
    .locals 0

    .line 255
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-direct {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;-><init>()V

    .line 256
    iput-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->mTag:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public getTag()Ljava/lang/String;
    .locals 0

    .line 260
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->mTag:Ljava/lang/String;

    return-object p0
.end method

.method public onApnUnthrottled(Ljava/lang/String;)V
    .locals 2

    if-eqz p1, :cond_0

    .line 335
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmApnUnthrottledRegistrants(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

    move-result-object p0

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 338
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    const-string p1, "onApnUnthrottled: apn is null"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

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

    .line 312
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmDataCallListChangedRegistrants(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

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

    .line 345
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmApnUnthrottledRegistrants(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

    move-result-object p0

    new-instance v0, Landroid/os/AsyncResult;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, v1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 348
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    const-string p1, "onDataProfileUnthrottled: dataProfile is null"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public onDeactivateDataCallComplete(I)V
    .locals 3

    .line 282
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onDeactivateDataCallComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    .line 283
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 284
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 285
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onHandoverCancelled(I)V
    .locals 3

    .line 326
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onHandoverCancelled. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    .line 327
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 328
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 329
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onHandoverStarted(I)V
    .locals 3

    .line 318
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onHandoverStarted. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    .line 319
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 320
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 321
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onRequestDataCallListComplete(ILjava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataCallResponse;",
            ">;)V"
        }
    .end annotation

    .line 305
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onRequestDataCallListComplete. resultCode = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p2, v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    .line 306
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p2}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Ljava/util/Map;

    move-result-object p2

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/os/Message;

    .line 307
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0, p2, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onSetDataProfileComplete(I)V
    .locals 3

    .line 297
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onSetDataProfileComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    .line 298
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 299
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onSetInitialAttachApnComplete(I)V
    .locals 3

    .line 290
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onSetInitialAttachApnComplete. resultCode = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    .line 291
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 292
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Landroid/os/Message;I)V

    return-void
.end method

.method public onSetupDataCallComplete(ILandroid/telephony/data/DataCallResponse;)V
    .locals 3

    .line 267
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

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

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    .line 270
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/os/Handler;->removeMessages(ILjava/lang/Object;)V

    .line 271
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$fgetmMessageMap(Lcom/android/internal/telephony/dataconnection/DataServiceManager;)Ljava/util/Map;

    move-result-object v0

    invoke-virtual {p0}, Landroid/telephony/data/IDataServiceCallback$Stub;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    if-eqz v0, :cond_0

    .line 273
    invoke-virtual {v0}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object v1

    const-string v2, "data_call_response"

    invoke-virtual {v1, v2, p2}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 274
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$msendCompleteMessage(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Landroid/os/Message;I)V

    goto :goto_0

    .line 276
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$CellularDataServiceCallback;->this$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    const-string p1, "Unable to find the message for setup call response."

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/lang/String;)V

    :goto_0
    return-void
.end method
