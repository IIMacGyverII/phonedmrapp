.class Lcom/android/internal/telephony/data/DataConfigManager$1;
.super Landroid/content/BroadcastReceiver;
.source "DataConfigManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataConfigManager;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataConfigManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataConfigManager;)V
    .locals 0

    .line 299
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataConfigManager$1;->this$0:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 302
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 303
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataConfigManager$1;->this$0:Lcom/android/internal/telephony/data/DataConfigManager;

    iget-object p1, p1, Lcom/android/internal/telephony/data/DataConfigManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    const/4 v0, -0x1

    const-string v1, "android.telephony.extra.SLOT_INDEX"

    invoke-virtual {p2, v1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p2

    if-ne p1, p2, :cond_0

    .line 306
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager$1;->this$0:Lcom/android/internal/telephony/data/DataConfigManager;

    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_0
    return-void
.end method
