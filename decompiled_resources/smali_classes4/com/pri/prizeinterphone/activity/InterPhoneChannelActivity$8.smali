.class Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;
.super Ljava/lang/Object;
.source "InterPhoneChannelActivity.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->saveChannelData()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V
    .locals 0

    .line 839
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 3

    .line 853
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v0, 0x23

    const/16 v1, 0x22

    if-eq p1, v1, :cond_0

    if-ne p1, v0, :cond_1

    .line 856
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fgetchannelData(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v2

    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 857
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    .line 858
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 859
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v0}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v1

    invoke-virtual {p1, v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 860
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDismissRunnableAndroidFinish:Ljava/lang/Runnable;

    const-wide/16 v0, 0x7d0

    invoke-virtual {p1, p0, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :cond_1
    return-void
.end method

.method public errorEvent(Ljava/lang/Byte;)V
    .locals 3

    .line 842
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result v0

    const/16 v1, 0x23

    const/16 v2, 0x22

    if-eq v0, v2, :cond_0

    .line 843
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    if-ne p1, v1, :cond_1

    .line 844
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    iget-object v0, p1, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mHandler:Landroid/os/Handler;

    iget-object p1, p1, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDismissRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 845
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v0, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 846
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v1

    invoke-virtual {p1, v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 847
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fgetrootView(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/view/View;

    move-result-object p0

    const p1, 0x7f11017c

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lcom/google/android/material/snackbar/Snackbar;->make(Landroid/view/View;II)Lcom/google/android/material/snackbar/Snackbar;

    move-result-object p0

    invoke-virtual {p0}, Lcom/google/android/material/snackbar/Snackbar;->show()V

    :cond_1
    return-void
.end method
