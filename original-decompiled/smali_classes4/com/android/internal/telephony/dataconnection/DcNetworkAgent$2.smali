.class Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$2;
.super Ljava/lang/Object;
.source "DcNetworkAgent.java"

# interfaces
.implements Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->lambda$onQosCallbackRegistered$0(ILandroid/net/QosFilter;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

.field final synthetic val$filter:Landroid/net/QosFilter;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Landroid/net/QosFilter;)V
    .locals 0

    .line 415
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$2;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iput-object p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$2;->val$filter:Landroid/net/QosFilter;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public matchesLocalAddress(Ljava/net/InetAddress;II)Z
    .locals 0

    .line 419
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$2;->val$filter:Landroid/net/QosFilter;

    invoke-virtual {p0, p1, p2, p3}, Landroid/net/QosFilter;->matchesLocalAddress(Ljava/net/InetAddress;II)Z

    move-result p0

    return p0
.end method

.method public matchesRemoteAddress(Ljava/net/InetAddress;II)Z
    .locals 0

    .line 425
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$2;->val$filter:Landroid/net/QosFilter;

    invoke-virtual {p0, p1, p2, p3}, Landroid/net/QosFilter;->matchesRemoteAddress(Ljava/net/InetAddress;II)Z

    move-result p0

    return p0
.end method
