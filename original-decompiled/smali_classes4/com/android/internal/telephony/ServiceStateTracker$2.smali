.class Lcom/android/internal/telephony/ServiceStateTracker$2;
.super Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;
.source "ServiceStateTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/ServiceStateTracker;->handleMessage(Landroid/os/Message;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/ServiceStateTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/ServiceStateTracker;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 1537
    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker$2;->this$0:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onAnyDataNetworkExistingChanged(Z)V
    .locals 3

    .line 1540
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker$2;->this$0:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->-$$Nest$fgetmAnyDataExisting(Lcom/android/internal/telephony/ServiceStateTracker;)Z

    move-result v0

    if-eq v0, p1, :cond_0

    .line 1541
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker$2;->this$0:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->-$$Nest$fputmAnyDataExisting(Lcom/android/internal/telephony/ServiceStateTracker;Z)V

    .line 1542
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker$2;->this$0:Lcom/android/internal/telephony/ServiceStateTracker;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onAnyDataNetworkExistingChanged: anyDataExisting="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1544
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker$2;->this$0:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-static {p1}, Lcom/android/internal/telephony/ServiceStateTracker;->-$$Nest$fgetmAnyDataExisting(Lcom/android/internal/telephony/ServiceStateTracker;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 1545
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker$2;->this$0:Lcom/android/internal/telephony/ServiceStateTracker;

    const/16 p1, 0x31

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_0
    return-void
.end method
