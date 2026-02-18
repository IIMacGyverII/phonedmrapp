.class Lcom/android/internal/telephony/data/LinkBandwidthEstimator$3;
.super Landroid/net/ConnectivityManager$NetworkCallback;
.source "LinkBandwidthEstimator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/LinkBandwidthEstimator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)V
    .locals 0

    .line 285
    iput-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$3;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-direct {p0}, Landroid/net/ConnectivityManager$NetworkCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onCapabilitiesChanged(Landroid/net/Network;Landroid/net/NetworkCapabilities;)V
    .locals 0

    .line 289
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$3;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    const/4 p1, 0x4

    invoke-virtual {p0, p1, p2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public onLost(Landroid/net/Network;)V
    .locals 1

    .line 293
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$3;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    const/4 p1, 0x4

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method
