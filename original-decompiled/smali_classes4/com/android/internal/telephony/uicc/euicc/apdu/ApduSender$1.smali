.class Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;
.super Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;
.source "ApduSender.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->send(Lcom/android/internal/telephony/uicc/euicc/apdu/RequestProvider;Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback<",
        "Landroid/telephony/IccOpenLogicalChannelResponse;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

.field final synthetic val$handler:Landroid/os/Handler;

.field final synthetic val$requestProvider:Lcom/android/internal/telephony/uicc/euicc/apdu/RequestProvider;

.field final synthetic val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Lcom/android/internal/telephony/uicc/euicc/apdu/RequestProvider;Landroid/os/Handler;)V
    .locals 0

    .line 127
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    iput-object p2, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    iput-object p3, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$requestProvider:Lcom/android/internal/telephony/uicc/euicc/apdu/RequestProvider;

    iput-object p4, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$handler:Landroid/os/Handler;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onResult(Landroid/telephony/IccOpenLogicalChannelResponse;)V
    .locals 6

    .line 130
    invoke-virtual {p1}, Landroid/telephony/IccOpenLogicalChannelResponse;->getChannel()I

    move-result v1

    .line 131
    invoke-virtual {p1}, Landroid/telephony/IccOpenLogicalChannelResponse;->getStatus()I

    move-result v0

    const/4 v2, 0x0

    const/4 v3, -0x1

    if-eq v1, v3, :cond_3

    const/4 v3, 0x1

    if-eq v0, v3, :cond_0

    goto :goto_2

    .line 144
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;

    iget-object v3, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    invoke-static {v3}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$fgetmSupportExtendedApdu(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;)Z

    move-result v3

    invoke-direct {v0, v1, v3}, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;-><init>(IZ)V

    const/4 v3, 0x0

    .line 147
    :try_start_0
    iget-object v4, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$requestProvider:Lcom/android/internal/telephony/uicc/euicc/apdu/RequestProvider;

    invoke-virtual {p1}, Landroid/telephony/IccOpenLogicalChannelResponse;->getSelectResponse()[B

    move-result-object p1

    invoke-interface {v4, p1, v0}, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestProvider;->buildRequest([BLcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p1

    move-object v3, p1

    .line 151
    :goto_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->getCommands()Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_2

    if-eqz v3, :cond_1

    goto :goto_1

    .line 158
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->getCommands()Ljava/util/List;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$handler:Landroid/os/Handler;

    invoke-static {p1, v0, v2, v1, p0}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$msendCommand(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;Ljava/util/List;ILcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;)V

    return-void

    .line 154
    :cond_2
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    const/4 v2, 0x0

    iget-object v4, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    iget-object v5, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$handler:Landroid/os/Handler;

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$mcloseAndReturn(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;I[BLjava/lang/Throwable;Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;)V

    return-void

    .line 134
    :cond_3
    :goto_2
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    invoke-static {p1}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$fgetmChannelLock(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;)Ljava/lang/Object;

    move-result-object p1

    monitor-enter p1

    .line 135
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    invoke-static {v1, v2}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$fputmChannelOpened(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;Z)V

    .line 136
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    invoke-static {v1}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$fgetmChannelLock(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;)Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->notify()V

    .line 137
    monitor-exit p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 138
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    new-instance v1, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Failed to open logical channel opened for AID: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$fgetmAid(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ", with status: "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduException;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;->onException(Ljava/lang/Throwable;)V

    return-void

    :catchall_1
    move-exception p0

    .line 137
    :try_start_2
    monitor-exit p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    throw p0
.end method

.method public bridge synthetic onResult(Ljava/lang/Object;)V
    .locals 0

    .line 127
    check-cast p1, Landroid/telephony/IccOpenLogicalChannelResponse;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$1;->onResult(Landroid/telephony/IccOpenLogicalChannelResponse;)V

    return-void
.end method
