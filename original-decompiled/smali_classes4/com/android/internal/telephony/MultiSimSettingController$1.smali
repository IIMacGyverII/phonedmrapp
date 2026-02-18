.class Lcom/android/internal/telephony/MultiSimSettingController$1;
.super Landroid/content/BroadcastReceiver;
.source "MultiSimSettingController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/MultiSimSettingController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/MultiSimSettingController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/MultiSimSettingController;)V
    .locals 0

    .line 161
    iput-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController$1;->this$0:Lcom/android/internal/telephony/MultiSimSettingController;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 164
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "android.telephony.extra.SLOT_INDEX"

    const/4 v0, -0x1

    .line 165
    invoke-virtual {p2, p1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    const-string v1, "android.telephony.extra.SUBSCRIPTION_INDEX"

    .line 167
    invoke-virtual {p2, v1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p2

    .line 169
    iget-object p0, p0, Lcom/android/internal/telephony/MultiSimSettingController$1;->this$0:Lcom/android/internal/telephony/MultiSimSettingController;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/MultiSimSettingController;->notifyCarrierConfigChanged(II)V

    :cond_0
    return-void
.end method
