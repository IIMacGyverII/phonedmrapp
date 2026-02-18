.class Lcom/android/internal/telephony/NetworkTypeController$1;
.super Landroid/content/BroadcastReceiver;
.source "NetworkTypeController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NetworkTypeController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/NetworkTypeController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/NetworkTypeController;)V
    .locals 0

    .line 136
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController$1;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1

    .line 139
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string p2, "android.os.action.DEVICE_IDLE_MODE_CHANGED"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    .line 149
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController$1;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    const/16 p1, 0x11

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    goto :goto_0

    :cond_1
    const/4 p1, -0x1

    const-string v0, "android.telephony.extra.SLOT_INDEX"

    .line 141
    invoke-virtual {p2, v0, p1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController$1;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    iget-object v0, v0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 142
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    if-ne p1, v0, :cond_2

    const/4 p1, 0x0

    const-string v0, "android.telephony.extra.REBROADCAST_ON_UNLOCK"

    .line 143
    invoke-virtual {p2, v0, p1}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result p1

    if-nez p1, :cond_2

    .line 145
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController$1;->this$0:Lcom/android/internal/telephony/NetworkTypeController;

    const/4 p1, 0x7

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    :cond_2
    :goto_0
    return-void
.end method
