.class Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;
.super Ljava/lang/Object;
.source "InterPhoneTalkBackFragment.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->lambda$updateChannelId$0(Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    .line 293
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 4

    .line 306
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v0, 0x23

    const/16 v1, 0x22

    if-eq p1, v1, :cond_0

    if-ne p1, v0, :cond_1

    .line 308
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmCurrentChannelData(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p1

    const/4 v2, 0x0

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setActive(I)V

    .line 309
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmCurrentChannelData(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v2

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 310
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgettmpCurrentChannelIndex(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)I

    move-result v2

    invoke-static {p1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fputmCurrentChannelIndex(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;I)V

    .line 311
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    iget-object v2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->channels:Ljava/util/List;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmCurrentChannelIndex(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)I

    move-result v3

    invoke-interface {v2, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-static {p1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fputmCurrentChannelData(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 312
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmCurrentChannelData(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p1

    const/4 v2, 0x1

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setActive(I)V

    .line 313
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmCurrentChannelData(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v2

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 315
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    .line 316
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 317
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v0}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object p0

    invoke-virtual {p1, v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    :cond_1
    return-void
.end method

.method public errorEvent(Ljava/lang/Byte;)V
    .locals 4

    .line 296
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result v0

    const/16 v1, 0x23

    const/16 v2, 0x22

    if-eq v0, v2, :cond_0

    .line 297
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    if-ne p1, v1, :cond_1

    .line 298
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmLocalView(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Landroid/view/View;

    move-result-object p1

    const v0, 0x7f11017c

    const/4 v3, 0x0

    invoke-static {p1, v0, v3}, Lcom/google/android/material/snackbar/Snackbar;->make(Landroid/view/View;II)Lcom/google/android/material/snackbar/Snackbar;

    move-result-object p1

    invoke-virtual {p1}, Lcom/google/android/material/snackbar/Snackbar;->show()V

    .line 299
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v0, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 300
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object p0

    invoke-virtual {p1, v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    :cond_1
    return-void
.end method
