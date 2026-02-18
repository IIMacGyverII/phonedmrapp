.class Lcom/pri/prizeinterphone/InterPhoneService$1;
.super Landroid/os/Handler;
.source "InterPhoneService.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/InterPhoneService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/InterPhoneService;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/InterPhoneService;)V
    .locals 0

    .line 42
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneService$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2
    .param p1    # Landroid/os/Message;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 45
    invoke-super {p0, p1}, Landroid/os/Handler;->handleMessage(Landroid/os/Message;)V

    .line 46
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0x80

    if-eq v0, v1, :cond_2

    const/16 v1, 0x81

    if-eq v0, v1, :cond_1

    const/16 p0, 0x83

    if-eq v0, p0, :cond_0

    goto :goto_0

    .line 56
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object p0

    iget-object p1, p1, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->unregisterCallbackMessenger(Landroid/os/Messenger;)V

    goto :goto_0

    .line 52
    :cond_1
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object v0

    iget-object p1, p1, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->registerCallbackMessenger(Landroid/os/Messenger;)V

    .line 53
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneService$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-static {p0}, Lcom/pri/prizeinterphone/InterPhoneService;->-$$Nest$mstartUpdateFirmware(Lcom/pri/prizeinterphone/InterPhoneService;)V

    goto :goto_0

    .line 48
    :cond_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 49
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneService$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneService;->-$$Nest$mgetChannelDataStr(Lcom/pri/prizeinterphone/InterPhoneService;Lcom/pri/prizeinterphone/serial/data/ChannelData;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneService;->-$$Nest$mstartForegroundNotification(Lcom/pri/prizeinterphone/InterPhoneService;Ljava/lang/String;)V

    :goto_0
    return-void
.end method
