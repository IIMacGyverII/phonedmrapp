.class Lcom/android/internal/telephony/SignalStrengthController$1;
.super Landroid/content/BroadcastReceiver;
.source "SignalStrengthController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/SignalStrengthController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/SignalStrengthController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/SignalStrengthController;)V
    .locals 0

    .line 149
    iput-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController$1;->this$0:Lcom/android/internal/telephony/SignalStrengthController;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1

    .line 152
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 153
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 154
    invoke-virtual {p2}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object p1

    const-string p2, "android.telephony.extra.SLOT_INDEX"

    invoke-virtual {p1, p2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result p1

    .line 156
    iget-object p2, p0, Lcom/android/internal/telephony/SignalStrengthController$1;->this$0:Lcom/android/internal/telephony/SignalStrengthController;

    iget-object p2, p2, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p2

    if-ne p1, p2, :cond_0

    .line 157
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController$1;->this$0:Lcom/android/internal/telephony/SignalStrengthController;

    const/16 p1, 0xa

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_0
    return-void
.end method
