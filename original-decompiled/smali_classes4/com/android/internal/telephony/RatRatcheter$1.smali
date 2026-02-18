.class Lcom/android/internal/telephony/RatRatcheter$1;
.super Landroid/content/BroadcastReceiver;
.source "RatRatcheter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/RatRatcheter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/RatRatcheter;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/RatRatcheter;)V
    .locals 0

    .line 186
    iput-object p1, p0, Lcom/android/internal/telephony/RatRatcheter$1;->this$0:Lcom/android/internal/telephony/RatRatcheter;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 0

    .line 189
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string p2, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 190
    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 191
    iget-object p0, p0, Lcom/android/internal/telephony/RatRatcheter$1;->this$0:Lcom/android/internal/telephony/RatRatcheter;

    invoke-static {p0}, Lcom/android/internal/telephony/RatRatcheter;->-$$Nest$mresetRatFamilyMap(Lcom/android/internal/telephony/RatRatcheter;)V

    :cond_0
    return-void
.end method
