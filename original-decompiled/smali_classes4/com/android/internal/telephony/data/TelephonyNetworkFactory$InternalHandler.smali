.class Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;
.super Landroid/os/Handler;
.source "TelephonyNetworkFactory.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/TelephonyNetworkFactory;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "InternalHandler"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/os/Looper;)V
    .locals 0

    .line 185
    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    .line 186
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 8

    .line 191
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 216
    :pswitch_0
    invoke-virtual {p1}, Landroid/os/Message;->getData()Landroid/os/Bundle;

    move-result-object v0

    const-string v1, "extra_network_request"

    .line 217
    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getParcelable(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v1

    move-object v3, v1

    check-cast v3, Landroid/net/NetworkRequest;

    const-string v1, "extra_success"

    .line 219
    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v4

    const-string v1, "extra_transport_type"

    .line 221
    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v5

    const-string v1, "extra_handover_failure_fallback"

    .line 223
    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v6

    .line 225
    iget-object v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-static {v0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->-$$Nest$fgetmPendingHandovers(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    move-object v7, p1

    check-cast v7, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;

    if-eqz v7, :cond_0

    .line 227
    iget-object v2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-static/range {v2 .. v7}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->-$$Nest$monDataHandoverSetupCompleted(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/net/NetworkRequest;ZIZLcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V

    goto :goto_0

    .line 230
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    const-string p1, "Handover completed but cannot find handover entry!"

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->logl(Ljava/lang/String;)V

    goto :goto_0

    .line 209
    :pswitch_1
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 210
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;

    .line 211
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    iget v0, p1, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;->apnType:I

    iget v1, p1, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;->targetTransport:I

    invoke-static {p0, v0, v1, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->-$$Nest$monDataHandoverNeeded(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;IILcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;)V

    goto :goto_0

    .line 205
    :pswitch_2
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->-$$Nest$monReleaseNetworkFor(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/os/Message;)V

    goto :goto_0

    .line 201
    :pswitch_3
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->-$$Nest$monNeedNetworkFor(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;Landroid/os/Message;)V

    goto :goto_0

    .line 197
    :pswitch_4
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-static {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->-$$Nest$monSubIdChange(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)V

    goto :goto_0

    .line 193
    :pswitch_5
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$InternalHandler;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-static {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->-$$Nest$monActivePhoneSwitch(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
