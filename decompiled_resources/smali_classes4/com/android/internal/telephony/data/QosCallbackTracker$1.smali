.class Lcom/android/internal/telephony/data/QosCallbackTracker$1;
.super Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;
.source "QosCallbackTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/QosCallbackTracker;-><init>(Lcom/android/internal/telephony/data/NotifyQosSessionInterface;Lcom/android/internal/telephony/Phone;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/QosCallbackTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/QosCallbackTracker;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 110
    iput-object p1, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$1;->this$0:Lcom/android/internal/telephony/data/QosCallbackTracker;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onQosCallbackRegistered(ILandroid/net/QosFilter;)V
    .locals 2

    .line 114
    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$1;->this$0:Lcom/android/internal/telephony/data/QosCallbackTracker;

    new-instance v1, Lcom/android/internal/telephony/data/QosCallbackTracker$1$1;

    invoke-direct {v1, p0, p2}, Lcom/android/internal/telephony/data/QosCallbackTracker$1$1;-><init>(Lcom/android/internal/telephony/data/QosCallbackTracker$1;Landroid/net/QosFilter;)V

    invoke-virtual {v0, p1, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->addFilter(ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    return-void
.end method

.method public onQosCallbackUnregistered(I)V
    .locals 0

    return-void
.end method
