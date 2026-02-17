.class Lcom/android/internal/telephony/data/DataNetworkController$1;
.super Landroid/content/BroadcastReceiver;
.source "DataNetworkController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetworkController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetworkController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataNetworkController;)V
    .locals 0

    .line 374
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$1;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 377
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    const-string v0, "android.telephony.action.SIM_APPLICATION_STATE_CHANGED"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "android.telephony.action.SIM_CARD_STATE_CHANGED"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    .line 380
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$1;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iget-object p1, p1, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    const/4 v0, -0x1

    const-string v1, "android.telephony.extra.SLOT_INDEX"

    invoke-virtual {p2, v1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    if-ne p1, v0, :cond_1

    const-string p1, "android.telephony.extra.SIM_STATE"

    const/4 v0, 0x0

    .line 383
    invoke-virtual {p2, p1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    .line 385
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$1;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    const/16 p2, 0x9

    invoke-virtual {p0, p2, p1, v0}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_1
    :goto_0
    return-void
.end method
