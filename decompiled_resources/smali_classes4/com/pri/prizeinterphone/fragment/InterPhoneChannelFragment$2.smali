.class Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;
.super Ljava/lang/Object;
.source "InterPhoneChannelFragment.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->saveData()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;


# direct methods
.method public static synthetic $r8$lambda$yj7YCaWZPFm2Xo8-ucP_uBTk2ug(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->lambda$dealEvent$0()V

    return-void
.end method

.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)V
    .locals 0

    .line 360
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private synthetic lambda$dealEvent$0()V
    .locals 0

    .line 390
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->updateAdapter()V

    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 3

    .line 374
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v0, 0x23

    const/16 v1, 0x22

    if-eq p1, v1, :cond_0

    if-ne p1, v0, :cond_1

    .line 376
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmCurrentSelected(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)I

    move-result p1

    invoke-interface {v2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    const/4 v2, 0x0

    .line 377
    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setActive(I)V

    .line 378
    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetdbChannelHelper(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v2

    invoke-virtual {v2, p1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 380
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)I

    move-result v2

    invoke-static {p1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fputmCurrentSelected(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;I)V

    .line 381
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)I

    move-result p1

    invoke-interface {v2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    const/4 v2, 0x1

    .line 382
    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setActive(I)V

    .line 383
    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetdbChannelHelper(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v2

    invoke-virtual {v2, p1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 385
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    .line 386
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v2

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getChannelList()Ljava/util/List;

    move-result-object v2

    iput-object v2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    .line 387
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 388
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v0}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v1

    invoke-virtual {p1, v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 389
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v0, p1, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    iget-object p1, p1, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mDismissRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 390
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object p1, p1, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;)V

    invoke-virtual {p1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :cond_1
    return-void
.end method

.method public errorEvent(Ljava/lang/Byte;)V
    .locals 4

    .line 363
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result v0

    const/16 v1, 0x23

    const/16 v2, 0x22

    if-eq v0, v2, :cond_0

    .line 364
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    if-ne p1, v1, :cond_1

    .line 365
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v0, p1, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    iget-object p1, p1, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mDismissRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 366
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmLocalView(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Landroid/view/View;

    move-result-object p1

    const v0, 0x7f11017c

    const/4 v3, 0x0

    invoke-static {p1, v0, v3}, Lcom/google/android/material/snackbar/Snackbar;->make(Landroid/view/View;II)Lcom/google/android/material/snackbar/Snackbar;

    move-result-object p1

    invoke-virtual {p1}, Lcom/google/android/material/snackbar/Snackbar;->show()V

    .line 367
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v0, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 368
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object p0

    invoke-virtual {p1, v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    :cond_1
    return-void
.end method
