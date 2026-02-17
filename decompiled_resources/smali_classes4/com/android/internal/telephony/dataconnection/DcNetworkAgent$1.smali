.class Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;
.super Landroid/os/Handler;
.source "DcNetworkAgent.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/Phone;ILandroid/net/NetworkAgentConfig;Landroid/net/NetworkProvider;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Landroid/os/Looper;)V
    .locals 0

    .line 121
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 124
    iget p1, p1, Landroid/os/Message;->what:I

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    .line 125
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    const-string v0, "onNetworkUnwanted timed out. Perform silent de-register."

    invoke-static {p1, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    .line 126
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unregister from connectivity service. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$sfgetsInterfaceNames()Ljava/util/Map;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    invoke-static {v2}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$fgetmId(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " removed."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mlogd(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    .line 128
    invoke-static {}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$sfgetsInterfaceNames()Ljava/util/Map;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$fgetmId(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 129
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$1;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    invoke-virtual {p0}, Landroid/net/NetworkAgent;->unregister()V

    :cond_0
    return-void
.end method
