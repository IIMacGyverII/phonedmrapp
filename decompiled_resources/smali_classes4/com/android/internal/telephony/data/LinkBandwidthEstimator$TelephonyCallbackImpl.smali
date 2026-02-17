.class Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;
.super Landroid/telephony/TelephonyCallback;
.source "LinkBandwidthEstimator.java"

# interfaces
.implements Landroid/telephony/TelephonyCallback$SignalStrengthsListener;
.implements Landroid/telephony/TelephonyCallback$ActiveDataSubscriptionIdListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/LinkBandwidthEstimator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "TelephonyCallbackImpl"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)V
    .locals 0

    .line 1124
    iput-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-direct {p0}, Landroid/telephony/TelephonyCallback;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;-><init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)V

    return-void
.end method


# virtual methods
.method public onActiveDataSubscriptionIdChanged(I)V
    .locals 1

    .line 1133
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const/16 v0, 0x8

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public onSignalStrengthsChanged(Landroid/telephony/SignalStrength;)V
    .locals 1

    .line 1129
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$TelephonyCallbackImpl;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    const/4 v0, 0x5

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method
