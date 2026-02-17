.class Lcom/android/internal/telephony/data/DataNetwork$3;
.super Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataNetwork;->registerForBandwidthUpdate()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 1691
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$3;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onBandwidthChanged(II)V
    .locals 1

    .line 1695
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$3;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1696
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$3;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->-$$Nest$monBandwidthUpdated(Lcom/android/internal/telephony/data/DataNetwork;II)V

    :cond_0
    return-void
.end method
