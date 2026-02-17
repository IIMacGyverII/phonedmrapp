.class Lcom/android/internal/telephony/emergency/EmergencyNumberTracker$1;
.super Landroid/content/BroadcastReceiver;
.source "EmergencyNumberTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;)V
    .locals 0

    .line 140
    iput-object p1, p0, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker$1;->this$0:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 143
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 145
    iget-object p0, p0, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker$1;->this$0:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;->-$$Nest$monCarrierConfigChanged(Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;)V

    return-void

    .line 147
    :cond_0
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.NETWORK_COUNTRY_CHANGED"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    const/4 p1, -0x1

    const-string v0, "phone"

    .line 149
    invoke-virtual {p2, v0, p1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    .line 150
    iget-object v0, p0, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker$1;->this$0:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    if-ne p1, v0, :cond_2

    const-string v0, "android.telephony.extra.NETWORK_COUNTRY"

    .line 151
    invoke-virtual {p2, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 153
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ACTION_NETWORK_COUNTRY_CHANGED: PhoneId: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " CountryIso: "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;->-$$Nest$smlogd(Ljava/lang/String;)V

    .line 157
    iget-object p0, p0, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker$1;->this$0:Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    if-nez p2, :cond_1

    const-string p2, ""

    :cond_1
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;->updateEmergencyCountryIsoAllPhones(Ljava/lang/String;)V

    :cond_2
    return-void
.end method
