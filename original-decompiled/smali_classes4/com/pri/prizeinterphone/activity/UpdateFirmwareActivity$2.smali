.class Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;
.super Landroid/os/Handler;
.source "UpdateFirmwareActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)V
    .locals 0

    .line 204
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

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

    .line 207
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0x50

    if-eq v0, v1, :cond_2

    const/16 v1, 0x51

    if-eq v0, v1, :cond_1

    const/16 v1, 0x82

    if-eq v0, v1, :cond_0

    goto/16 :goto_0

    .line 209
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$mhandleMsgFromSvc(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;)V

    goto/16 :goto_0

    .line 224
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmIsSvcBind(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Z

    move-result p1

    if-nez p1, :cond_5

    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmMessenger(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/os/Messenger;

    move-result-object p1

    if-nez p1, :cond_5

    const-string p1, "UpdateFirmwareAct"

    const-string v0, "can not bind interphone service,finish()"

    .line 225
    invoke-static {p1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 226
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    goto :goto_0

    .line 212
    :cond_2
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isRunning()Z

    move-result p1

    const/4 v0, 0x1

    if-nez p1, :cond_3

    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isDmrUpdateIdle()Z

    move-result p1

    if-eqz p1, :cond_3

    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isExternalSdcardHaveFirmware()Z

    move-result p1

    if-eqz p1, :cond_4

    .line 213
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmTvContent(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/widget/TextView;

    move-result-object p1

    const v1, 0x7f110121

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setText(I)V

    .line 214
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmLeftBt(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/widget/Button;

    move-result-object p1

    const/16 v1, 0x8

    invoke-virtual {p1, v1}, Landroid/widget/Button;->setVisibility(I)V

    .line 215
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmRightBt(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/widget/Button;

    move-result-object p1

    const v1, 0x7f110129

    invoke-virtual {p1, v1}, Landroid/widget/Button;->setText(I)V

    .line 216
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmNumberProgressBar(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    move-result-object p1

    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Landroid/view/View;->setVisibility(I)V

    .line 217
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmNumberProgressBar(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    move-result-object p1

    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    .line 218
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$mstartUpdateFirmware(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)V

    .line 219
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1, v0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fputisRunning(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Z)V

    .line 221
    :cond_4
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmRightBt(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/widget/Button;

    move-result-object p0

    invoke-virtual {p0, v0}, Landroid/widget/Button;->setEnabled(Z)V

    :cond_5
    :goto_0
    return-void
.end method
