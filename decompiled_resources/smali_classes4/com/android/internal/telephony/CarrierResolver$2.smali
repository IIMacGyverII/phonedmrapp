.class Lcom/android/internal/telephony/CarrierResolver$2;
.super Landroid/content/BroadcastReceiver;
.source "CarrierResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/CarrierResolver;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/CarrierResolver;)V
    .locals 0

    .line 139
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierResolver$2;->this$0:Lcom/android/internal/telephony/CarrierResolver;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 9

    .line 142
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierResolver$2;->this$0:Lcom/android/internal/telephony/CarrierResolver;

    invoke-static {p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/CarrierResolver;)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    const-string v0, "override_carrier_id"

    const/4 v1, -0x1

    .line 143
    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v3

    const-string v0, "override_specific_carrier_id"

    .line 145
    invoke-virtual {p2, v0, v3}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v5

    const-string v0, "override_mno_carrier_id"

    .line 146
    invoke-virtual {p2, v0, v3}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v7

    const-string v0, "override_carrier_name"

    .line 147
    invoke-virtual {p2, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "override_specific_carrier_name"

    .line 148
    invoke-virtual {p2, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 150
    invoke-static {}, Landroid/telephony/SubscriptionManager;->getDefaultSubscriptionId()I

    move-result v2

    const-string/jumbo v4, "sub_id"

    .line 149
    invoke-virtual {p2, v4, v2}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p2

    if-gtz v3, :cond_0

    const-string p0, "Override carrier id must be greater than 0."

    .line 153
    invoke-static {p0, p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smlogd(Ljava/lang/String;I)V

    return-void

    .line 155
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/CarrierResolver$2;->this$0:Lcom/android/internal/telephony/CarrierResolver;

    invoke-static {v2}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/CarrierResolver;)Lcom/android/internal/telephony/Phone;

    move-result-object v2

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    if-eq p2, v2, :cond_1

    const-string p0, "Override carrier id failed. The sub id doesn\'t same as phone\'s sub id."

    .line 156
    invoke-static {p0, p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smlogd(Ljava/lang/String;I)V

    return-void

    .line 160
    :cond_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Override carrier id to: "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smlogd(Ljava/lang/String;I)V

    .line 161
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Override specific carrier id to: "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smlogd(Ljava/lang/String;I)V

    .line 162
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Override mno carrier id to: "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smlogd(Ljava/lang/String;I)V

    .line 163
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Override carrier name to: "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smlogd(Ljava/lang/String;I)V

    .line 164
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Override specific carrier name to: "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, p1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smlogd(Ljava/lang/String;I)V

    .line 165
    iget-object v2, p0, Lcom/android/internal/telephony/CarrierResolver$2;->this$0:Lcom/android/internal/telephony/CarrierResolver;

    const-string p0, ""

    if-eqz v0, :cond_2

    move-object v4, v0

    goto :goto_0

    :cond_2
    move-object v4, p0

    :goto_0
    if-eqz v1, :cond_3

    move-object v6, v0

    goto :goto_1

    :cond_3
    move-object v6, p0

    :goto_1
    const/4 v8, 0x0

    invoke-static/range {v2 .. v8}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$mupdateCarrierIdAndName(Lcom/android/internal/telephony/CarrierResolver;ILjava/lang/String;ILjava/lang/String;IZ)V

    return-void
.end method
