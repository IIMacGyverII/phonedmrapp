.class Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;
.super Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;
.source "ApduSender.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->sendCommand(Ljava/util/List;ILcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;)V
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
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

.field final synthetic val$command:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

.field final synthetic val$commands:Ljava/util/List;

.field final synthetic val$handler:Landroid/os/Handler;

.field final synthetic val$index:I

.field final synthetic val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;Landroid/os/Handler;ILjava/util/List;)V
    .locals 0

    .line 176
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    iput-object p2, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$command:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

    iput-object p3, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$resultCallback:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;

    iput-object p4, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$handler:Landroid/os/Handler;

    iput p5, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$index:I

    iput-object p6, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$commands:Ljava/util/List;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onResult(Lcom/android/internal/telephony/uicc/IccIoResult;)V
    .locals 6

    .line 181
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->this$0:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$command:Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

    iget v1, v1, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;->channel:I

    new-instance v4, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;

    invoke-direct {v4, p0}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2$1;-><init>(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;)V

    iget-object v5, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->val$handler:Landroid/os/Handler;

    const/4 v3, 0x0

    move-object v2, p1

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;->-$$Nest$mgetCompleteResponse(Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender;ILcom/android/internal/telephony/uicc/IccIoResult;Ljava/io/ByteArrayOutputStream;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void
.end method

.method public bridge synthetic onResult(Ljava/lang/Object;)V
    .locals 0

    .line 176
    check-cast p1, Lcom/android/internal/telephony/uicc/IccIoResult;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSender$2;->onResult(Lcom/android/internal/telephony/uicc/IccIoResult;)V

    return-void
.end method
