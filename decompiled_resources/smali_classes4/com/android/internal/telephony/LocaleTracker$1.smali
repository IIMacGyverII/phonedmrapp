.class Lcom/android/internal/telephony/LocaleTracker$1;
.super Landroid/content/BroadcastReceiver;
.source "LocaleTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/LocaleTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/LocaleTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/LocaleTracker;)V
    .locals 0

    .line 168
    iput-object p1, p0, Lcom/android/internal/telephony/LocaleTracker$1;->this$0:Lcom/android/internal/telephony/LocaleTracker;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 171
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "android.telephony.action.SIM_CARD_STATE_CHANGED"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    const-string p1, "phone"

    .line 172
    invoke-virtual {p2, p1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    .line 173
    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker$1;->this$0:Lcom/android/internal/telephony/LocaleTracker;

    invoke-static {v1}, Lcom/android/internal/telephony/LocaleTracker;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/LocaleTracker;)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    if-ne p1, v1, :cond_2

    .line 174
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker$1;->this$0:Lcom/android/internal/telephony/LocaleTracker;

    const/4 p1, 0x3

    const-string v1, "android.telephony.extra.SIM_STATE"

    .line 175
    invoke-virtual {p2, v1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p2

    .line 174
    invoke-virtual {p0, p1, p2, v0}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    .line 176
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    .line 178
    :cond_0
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v1, "com.android.internal.telephony.action.COUNTRY_OVERRIDE"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p1, "country"

    .line 180
    invoke-virtual {p2, p1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v1, "reset"

    .line 181
    invoke-virtual {p2, v1, v0}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result p2

    if-eqz p2, :cond_1

    const/4 p1, 0x0

    .line 183
    :cond_1
    iget-object p2, p0, Lcom/android/internal/telephony/LocaleTracker$1;->this$0:Lcom/android/internal/telephony/LocaleTracker;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Received country override: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p2, v0}, Lcom/android/internal/telephony/LocaleTracker;->-$$Nest$mlog(Lcom/android/internal/telephony/LocaleTracker;Ljava/lang/String;)V

    .line 185
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker$1;->this$0:Lcom/android/internal/telephony/LocaleTracker;

    const/4 p2, 0x7

    invoke-virtual {p0, p2, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    :cond_2
    :goto_0
    return-void
.end method
