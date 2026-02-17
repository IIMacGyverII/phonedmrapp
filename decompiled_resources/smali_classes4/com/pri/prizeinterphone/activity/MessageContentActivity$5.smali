.class Lcom/pri/prizeinterphone/activity/MessageContentActivity$5;
.super Landroid/os/Handler;
.source "MessageContentActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/MessageContentActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V
    .locals 0

    .line 345
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$5;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 1

    .line 348
    invoke-super {p0, p1}, Landroid/os/Handler;->handleMessage(Landroid/os/Message;)V

    .line 349
    iget p1, p1, Landroid/os/Message;->what:I

    const/16 v0, 0x2b67

    if-ne p1, v0, :cond_0

    .line 350
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$5;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$mreFreshUI(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V

    :cond_0
    return-void
.end method
