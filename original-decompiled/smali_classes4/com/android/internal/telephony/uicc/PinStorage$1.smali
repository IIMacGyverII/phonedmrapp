.class Lcom/android/internal/telephony/uicc/PinStorage$1;
.super Landroid/content/BroadcastReceiver;
.source "PinStorage.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/PinStorage;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/PinStorage;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/uicc/PinStorage;)V
    .locals 0

    .line 160
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/PinStorage$1;->this$0:Lcom/android/internal/telephony/uicc/PinStorage;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 3

    .line 163
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 164
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    const/4 v2, -0x1

    if-eqz v0, :cond_0

    const-string p1, "android.telephony.extra.SLOT_INDEX"

    .line 165
    invoke-virtual {p2, p1, v2}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    .line 166
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage$1;->this$0:Lcom/android/internal/telephony/uicc/PinStorage;

    const/4 p2, 0x2

    invoke-virtual {p0, p2, p1, v1}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_1

    :cond_0
    const-string v0, "android.telephony.action.SIM_CARD_STATE_CHANGED"

    .line 167
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    const-string v0, "android.telephony.action.SIM_APPLICATION_STATE_CHANGED"

    .line 168
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    :cond_1
    const-string p2, "android.intent.action.USER_UNLOCKED"

    .line 175
    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 176
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage$1;->this$0:Lcom/android/internal/telephony/uicc/PinStorage;

    const/4 p1, 0x4

    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_1

    :cond_2
    :goto_0
    const-string p1, "phone"

    .line 169
    invoke-virtual {p2, p1, v2}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    const-string v0, "android.telephony.extra.SIM_STATE"

    .line 170
    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p2

    .line 172
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage$1;->this$0:Lcom/android/internal/telephony/uicc/PinStorage;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->-$$Nest$mvalidateSlotId(Lcom/android/internal/telephony/uicc/PinStorage;I)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 173
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage$1;->this$0:Lcom/android/internal/telephony/uicc/PinStorage;

    const/4 v0, 0x1

    invoke-virtual {p0, v0, p1, p2}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_3
    :goto_1
    return-void
.end method
