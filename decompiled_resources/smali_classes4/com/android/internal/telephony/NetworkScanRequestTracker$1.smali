.class Lcom/android/internal/telephony/NetworkScanRequestTracker$1;
.super Landroid/os/Handler;
.source "NetworkScanRequestTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NetworkScanRequestTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/NetworkScanRequestTracker;)V
    .locals 0

    .line 73
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 76
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Received Event :"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ScanRequestTracker"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 77
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_0

    .line 109
    :pswitch_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 110
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget-object p1, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    const/4 v0, 0x1

    invoke-static {p0, p1, v0, v0}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$mdeleteScanAndMayNotify(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;IZ)V

    goto :goto_0

    .line 103
    :pswitch_1
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$minterruptScanDone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 99
    :pswitch_2
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$mdoInterruptScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;I)V

    goto :goto_0

    .line 95
    :pswitch_3
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$mstopScanDone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 91
    :pswitch_4
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$mdoStopScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;I)V

    goto :goto_0

    .line 87
    :pswitch_5
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$mreceiveResult(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 83
    :pswitch_6
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$mstartScanDone(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 79
    :pswitch_7
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkScanRequestTracker$1;->this$0:Lcom/android/internal/telephony/NetworkScanRequestTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/NetworkScanRequestTracker;->-$$Nest$fgetmScheduler(Lcom/android/internal/telephony/NetworkScanRequestTracker;)Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;

    move-result-object p0

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;->-$$Nest$mdoStartScan(Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestScheduler;Lcom/android/internal/telephony/NetworkScanRequestTracker$NetworkScanRequestInfo;)V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method
