.class Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;
.super Ljava/lang/Object;
.source "InterPhoneHomeActivity.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/InterPhoneHomeActivity;
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

    .line 119
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 3

    .line 131
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v0, 0x23

    const/16 v1, 0x22

    if-eq p1, v1, :cond_0

    if-ne p1, v0, :cond_1

    .line 133
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmGlobalSetChannelMessageListener(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 134
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v0}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmGlobalSetChannelMessageListener(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object p0

    invoke-virtual {p1, v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    const-string p0, "InterPhoneHomeAct"

    const-string p1, "remove the mGlobalSetChannelMessageListener"

    .line 135
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-void
.end method

.method public errorEvent(Ljava/lang/Byte;)V
    .locals 4

    .line 122
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result v0

    const/16 v1, 0x23

    const/16 v2, 0x22

    if-eq v0, v2, :cond_0

    .line 123
    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    if-ne p1, v1, :cond_1

    .line 124
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmLlInterPhoneTapView(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/widget/LinearLayout;

    move-result-object p1

    const v0, 0x7f11017d

    const/4 v3, -0x2

    invoke-static {p1, v0, v3}, Lcom/google/android/material/snackbar/Snackbar;->make(Landroid/view/View;II)Lcom/google/android/material/snackbar/Snackbar;

    move-result-object p1

    invoke-virtual {p1}, Lcom/google/android/material/snackbar/Snackbar;->show()V

    .line 125
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmGlobalSetChannelMessageListener(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object v2

    invoke-virtual {p1, v0, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 126
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmGlobalSetChannelMessageListener(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    move-result-object p0

    invoke-virtual {p1, v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    :cond_1
    return-void
.end method
