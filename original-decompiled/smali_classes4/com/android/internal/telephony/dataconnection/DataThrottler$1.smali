.class Lcom/android/internal/telephony/dataconnection/DataThrottler$1;
.super Landroid/content/BroadcastReceiver;
.source "DataThrottler.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataThrottler;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DataThrottler;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DataThrottler;)V
    .locals 0

    .line 75
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataThrottler$1;->this$0:Lcom/android/internal/telephony/dataconnection/DataThrottler;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 78
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 79
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataThrottler$1;->this$0:Lcom/android/internal/telephony/dataconnection/DataThrottler;

    invoke-static {p1}, Lcom/android/internal/telephony/dataconnection/DataThrottler;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataThrottler;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    const-string v0, "android.telephony.extra.SLOT_INDEX"

    const/4 v1, -0x1

    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    if-ne p1, v0, :cond_1

    const/4 p1, 0x0

    const-string v0, "android.telephony.extra.REBROADCAST_ON_UNLOCK"

    .line 81
    invoke-virtual {p2, v0, p1}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    :cond_0
    const-string p1, "android.telephony.extra.SUBSCRIPTION_INDEX"

    .line 87
    invoke-virtual {p2, p1, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    .line 89
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 90
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataThrottler$1;->this$0:Lcom/android/internal/telephony/dataconnection/DataThrottler;

    const/4 p1, 0x2

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_1
    return-void
.end method
