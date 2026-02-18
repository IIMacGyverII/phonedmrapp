.class Lcom/android/internal/telephony/CarrierSignalAgent$2;
.super Landroid/content/BroadcastReceiver;
.source "CarrierSignalAgent.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierSignalAgent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/CarrierSignalAgent;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/CarrierSignalAgent;)V
    .locals 0

    .line 131
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierSignalAgent$2;->this$0:Lcom/android/internal/telephony/CarrierSignalAgent;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 133
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    .line 134
    iget-object p2, p0, Lcom/android/internal/telephony/CarrierSignalAgent$2;->this$0:Lcom/android/internal/telephony/CarrierSignalAgent;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "CarrierSignalAgent receiver action: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p2, v0}, Lcom/android/internal/telephony/CarrierSignalAgent;->-$$Nest$mlog(Lcom/android/internal/telephony/CarrierSignalAgent;Ljava/lang/String;)V

    const-string p2, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 135
    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 136
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierSignalAgent$2;->this$0:Lcom/android/internal/telephony/CarrierSignalAgent;

    invoke-static {p0}, Lcom/android/internal/telephony/CarrierSignalAgent;->-$$Nest$mloadCarrierConfig(Lcom/android/internal/telephony/CarrierSignalAgent;)V

    :cond_0
    return-void
.end method
