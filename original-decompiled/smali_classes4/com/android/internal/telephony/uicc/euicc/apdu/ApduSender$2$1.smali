.class Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;
.super Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;
.source "ApduSender.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->onResult(Lcom/android/internal/telephony/uicc/IccIoResult;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback<",
        "Lcom/android/internal/telephony/uicc/IccIoResult;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;)V
    .locals 0

    .line 182
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onResult(Lcom/android/internal/telephony/uicc/IccIoResult;)V
    .locals 8

    .line 185
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Full APDU response: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$smlogv(Ljava/lang/String;)V

    .line 186
    iget v0, p1, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    shl-int/lit8 v1, v0, 0x8

    iget v2, p1, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    or-int/2addr v1, v2

    const v2, 0x9000

    if-eq v1, v2, :cond_0

    const/16 v2, 0x91

    if-eq v0, v2, :cond_0

    .line 188
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;

    iget-object v2, p1, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    iget-object p1, p1, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$command:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

    iget v3, p1, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;->channel:I

    const/4 v4, 0x0

    new-instance v5, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduException;

    invoke-direct {v5, v1}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduException;-><init>(I)V

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;

    iget-object v6, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    iget-object v7, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$handler:Landroid/os/Handler;

    invoke-static/range {v2 .. v7}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$mcloseAndReturn(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;I[BLjava/lang/Throwable;Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;)V

    return-void

    .line 193
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;

    iget v1, v0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$index:I

    iget-object v0, v0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$commands:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v2, 0x1

    sub-int/2addr v0, v2

    if-ge v1, v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;

    iget-object v0, v0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    .line 195
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;->shouldContinueOnIntermediateResult(Lcom/android/internal/telephony/uicc/IccIoResult;)Z

    move-result v0

    if-eqz v0, :cond_1

    move v0, v2

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    if-eqz v0, :cond_2

    .line 199
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;

    iget-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$commands:Ljava/util/List;

    iget v1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$index:I

    add-int/2addr v1, v2

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$handler:Landroid/os/Handler;

    invoke-static {p1, v0, v1, v2, p0}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$msendCommand(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;Ljava/util/List;ILcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;)V

    goto :goto_1

    .line 202
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->this$1:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;

    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$command:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

    iget v1, v1, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;->channel:I

    iget-object v2, p1, Lcom/android/internal/telephony/uicc/IccIoResult;->payload:[B

    const/4 v3, 0x0

    iget-object v4, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    iget-object v5, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$handler:Landroid/os/Handler;

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$mcloseAndReturn(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;I[BLjava/lang/Throwable;Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;)V

    :goto_1
    return-void
.end method

.method public bridge synthetic onResult(Ljava/lang/Object;)V
    .locals 0

    .line 182
    check-cast p1, Lcom/android/internal/telephony/uicc/IccIoResult;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;->onResult(Lcom/android/internal/telephony/uicc/IccIoResult;)V

    return-void
.end method
