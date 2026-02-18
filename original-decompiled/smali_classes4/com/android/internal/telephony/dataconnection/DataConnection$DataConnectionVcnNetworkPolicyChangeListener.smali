.class Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;
.super Ljava/lang/Object;
.source "DataConnection.java"

# interfaces
.implements Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataConnection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "DataConnectionVcnNetworkPolicyChangeListener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    .line 4066
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    return-void
.end method


# virtual methods
.method public onPolicyChanged()V
    .locals 5

    .line 4071
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v0

    .line 4072
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmVcnManager(Lcom/android/internal/telephony/dataconnection/DataConnection;)Landroid/net/vcn/VcnManager;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 4074
    invoke-virtual {v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object v2

    .line 4073
    invoke-virtual {v1, v0, v2}, Landroid/net/vcn/VcnManager;->applyVcnNetworkPolicy(Landroid/net/NetworkCapabilities;Landroid/net/LinkProperties;)Landroid/net/vcn/VcnNetworkPolicyResult;

    move-result-object v1

    .line 4075
    invoke-virtual {v1}, Landroid/net/vcn/VcnNetworkPolicyResult;->isTeardownRequested()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 4076
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v2, 0x2

    const/4 v3, 0x0

    const-string/jumbo v4, "vcnRequestedTeardown"

    invoke-virtual {v1, v4, v2, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->tearDownAll(Ljava/lang/String;ILandroid/os/Message;)V

    .line 4082
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 4083
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v1

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1, v0, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sendNetworkCapabilities(Landroid/net/NetworkCapabilities;Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    :cond_1
    return-void
.end method
