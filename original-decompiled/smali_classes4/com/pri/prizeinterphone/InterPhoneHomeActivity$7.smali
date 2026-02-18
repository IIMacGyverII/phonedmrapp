.class Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;
.super Ljava/lang/Object;
.source "InterPhoneHomeActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateUnreadDot()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V
    .locals 0

    .line 479
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 482
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmTvUnread(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/widget/TextView;

    move-result-object v0

    if-nez v0, :cond_0

    const-string p0, "InterPhoneHomeAct"

    const-string/jumbo v0, "updateUnreadDot is failed because of mTvUnread is null"

    .line 483
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 487
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllConversations()Ljava/util/ArrayList;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    move v3, v2

    .line 488
    :goto_0
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v2, v4, :cond_1

    .line 489
    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getUnReadCount()I

    move-result v4

    add-int/2addr v3, v4

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    if-lez v3, :cond_2

    .line 492
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmTvUnread(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 493
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmTvUnread(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/widget/TextView;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    .line 495
    :cond_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmTvUnread(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/widget/TextView;

    move-result-object p0

    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setVisibility(I)V

    :goto_1
    return-void
.end method
