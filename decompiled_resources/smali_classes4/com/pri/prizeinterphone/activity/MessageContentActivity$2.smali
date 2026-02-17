.class Lcom/pri/prizeinterphone/activity/MessageContentActivity$2;
.super Ljava/lang/Object;
.source "MessageContentActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


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

    .line 255
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 258
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    const/4 v0, 0x1

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$mfreshSendButton(Lcom/pri/prizeinterphone/activity/MessageContentActivity;Z)V

    return-void
.end method
