.class Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;
.super Ljava/lang/Object;
.source "MessageContentActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/MessageContentActivity;->onMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

.field final synthetic val$msg:Lcom/pri/prizeinterphone/serial/data/MessageData;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 0

    .line 323
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    iput-object p2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;->val$msg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 326
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;->val$msg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getStatus()I

    move-result v0

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;->val$msg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    .line 327
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getStatus()I

    move-result v0

    const/4 v1, 0x3

    if-ne v0, v1, :cond_1

    .line 328
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$mfreshSendButton(Lcom/pri/prizeinterphone/activity/MessageContentActivity;Z)V

    .line 329
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    iget-object v1, v0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mHandler:Landroid/os/Handler;

    iget-object v0, v0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->freshSendBtnRunn:Ljava/lang/Runnable;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 331
    :cond_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$mreFreshUI(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V

    return-void
.end method
