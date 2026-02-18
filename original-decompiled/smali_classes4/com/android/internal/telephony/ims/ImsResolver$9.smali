.class Lcom/android/internal/telephony/ims/ImsResolver$9;
.super Landroid/content/BroadcastReceiver;
.source "ImsResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/ims/ImsResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/ims/ImsResolver;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/ims/ImsResolver;)V
    .locals 0

    .line 1853
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$9;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 4

    const-string p1, "android.telephony.extra.SLOT_INDEX"

    const/4 v0, -0x1

    .line 1857
    invoke-virtual {p2, p1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    const-string p2, "ImsResolver"

    if-ne p1, v0, :cond_0

    const-string p0, "mSimStateChangedReceiver, invalid slot id."

    .line 1860
    invoke-static {p2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1863
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver$9;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v1, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mgetSubIdUsingPhoneId(Lcom/android/internal/telephony/ims/ImsResolver;I)I

    move-result v1

    .line 1864
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver$9;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v2}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmTelephonyManagerProxy(Lcom/android/internal/telephony/ims/ImsResolver;)Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver$9;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v3}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmContext(Lcom/android/internal/telephony/ims/ImsResolver;)Landroid/content/Context;

    move-result-object v3

    invoke-interface {v2, v3, p1}, Lcom/android/internal/telephony/ims/ImsResolver$TelephonyManagerProxy;->getSimState(Landroid/content/Context;I)I

    move-result v2

    .line 1865
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver$9;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v3, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mgetSubId(Lcom/android/internal/telephony/ims/ImsResolver;I)I

    move-result v3

    if-eq v1, v0, :cond_2

    if-eq v3, v1, :cond_2

    const/4 v0, 0x5

    if-eq v2, v0, :cond_1

    goto :goto_0

    .line 1875
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "mSimStateChangedReceiver SlotId: "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ", SubId: "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ", sim state: "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1877
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$9;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmHandler(Lcom/android/internal/telephony/ims/ImsResolver;)Landroid/os/Handler;

    move-result-object p0

    const/4 p2, 0x2

    invoke-virtual {p0, p2, p1, v1}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void

    .line 1870
    :cond_2
    :goto_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "mSimStateChangedReceiver for slot:"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", curSubId:"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " and simstate:"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", ignoring."

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
