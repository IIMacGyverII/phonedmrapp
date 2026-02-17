.class Lcom/android/internal/telephony/data/KeepaliveTracker$1;
.super Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;
.source "KeepaliveTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/KeepaliveTracker;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkAgent;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/KeepaliveTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/KeepaliveTracker;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 111
    iput-object p1, p0, Lcom/android/internal/telephony/data/KeepaliveTracker$1;->this$0:Lcom/android/internal/telephony/data/KeepaliveTracker;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onStartSocketKeepalive(ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V
    .locals 0

    .line 115
    iget-object p0, p0, Lcom/android/internal/telephony/data/KeepaliveTracker$1;->this$0:Lcom/android/internal/telephony/data/KeepaliveTracker;

    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/KeepaliveTracker;->-$$Nest$monStartSocketKeepaliveRequested(Lcom/android/internal/telephony/data/KeepaliveTracker;ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V

    return-void
.end method

.method public onStopSocketKeepalive(I)V
    .locals 0

    .line 120
    iget-object p0, p0, Lcom/android/internal/telephony/data/KeepaliveTracker$1;->this$0:Lcom/android/internal/telephony/data/KeepaliveTracker;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/KeepaliveTracker;->-$$Nest$monStopSocketKeepaliveRequested(Lcom/android/internal/telephony/data/KeepaliveTracker;I)V

    return-void
.end method
