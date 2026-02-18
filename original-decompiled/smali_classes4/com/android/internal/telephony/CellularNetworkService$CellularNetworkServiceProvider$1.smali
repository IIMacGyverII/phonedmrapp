.class Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider$1;
.super Landroid/os/Handler;
.source "CellularNetworkService.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;-><init>(Lcom/android/internal/telephony/CellularNetworkService;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;

.field final synthetic val$this$0:Lcom/android/internal/telephony/CellularNetworkService;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;Landroid/os/Looper;Lcom/android/internal/telephony/CellularNetworkService;)V
    .locals 0

    .line 125
    iput-object p1, p0, Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider$1;->this$1:Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;

    iput-object p3, p0, Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider$1;->val$this$0:Lcom/android/internal/telephony/CellularNetworkService;

    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 4

    .line 128
    iget-object v0, p0, Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider$1;->this$1:Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;

    invoke-static {v0}, Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;->-$$Nest$fgetmCallbackMap(Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;)Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/NetworkServiceCallback;

    .line 131
    iget v1, p1, Landroid/os/Message;->what:I

    const/4 v2, 0x2

    const/4 v3, 0x1

    if-eq v1, v3, :cond_1

    if-eq v1, v2, :cond_1

    const/4 p1, 0x3

    if-eq v1, p1, :cond_0

    return-void

    .line 163
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider$1;->this$1:Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;

    invoke-virtual {p0}, Landroid/telephony/NetworkService$NetworkServiceProvider;->notifyNetworkRegistrationInfoChanged()V

    goto :goto_2

    :cond_1
    if-nez v0, :cond_2

    return-void

    .line 135
    :cond_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    if-ne v1, v3, :cond_3

    move v2, v3

    .line 140
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider$1;->this$1:Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;

    iget-object v1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    .line 141
    invoke-static {p0, v1, v2}, Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;->-$$Nest$mgetRegistrationStateFromResult(Lcom/android/internal/telephony/CellularNetworkService$CellularNetworkServiceProvider;Ljava/lang/Object;I)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    .line 144
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez p1, :cond_5

    if-nez p0, :cond_4

    goto :goto_0

    :cond_4
    const/4 p1, 0x0

    goto :goto_1

    :cond_5
    :goto_0
    const/4 p1, 0x5

    .line 156
    :goto_1
    :try_start_0
    invoke-virtual {v0, p1, p0}, Landroid/telephony/NetworkServiceCallback;->onRequestNetworkRegistrationInfoComplete(ILandroid/telephony/NetworkRegistrationInfo;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :catch_0
    move-exception p0

    .line 159
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Exception: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/CellularNetworkService;->-$$Nest$smloge(Ljava/lang/String;)V

    :goto_2
    return-void
.end method
