.class Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;
.super Lcom/android/internal/telephony/State;
.source "DataConnection.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataConnection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "DcDefaultState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    .line 2225
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 5

    .line 2228
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v1, "DcDefaultState: enter"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2231
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmTransportType(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v1

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 2232
    invoke-virtual {v2}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v2

    const v3, 0x4000b

    const/4 v4, 0x0

    .line 2231
    invoke-virtual {v0, v1, v2, v3, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForDataRegStateOrRatChanged(ILandroid/os/Handler;ILjava/lang/Object;)V

    .line 2235
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const v2, 0x4000c

    invoke-virtual {v0, v1, v2, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForDataRoamingOn(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 2237
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const v2, 0x4000d

    const/4 v3, 0x1

    invoke-virtual {v0, v1, v2, v4, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForDataRoamingOff(Landroid/os/Handler;ILjava/lang/Object;Z)V

    .line 2239
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const v2, 0x4001b

    invoke-virtual {v0, v1, v2, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNrStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 2241
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const v2, 0x4001d

    invoke-virtual {v0, v1, v2, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNrFrequencyChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 2243
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const v2, 0x40020

    invoke-virtual {v0, v1, v2, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForCssIndicatorChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 2245
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v1, "bandwidth_estimator"

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$misBandwidthSourceKey(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2246
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLinkBandwidthEstimator()Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const v2, 0x40027

    invoke-virtual {v0, v1, v2, v4}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->registerForBandwidthChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 2251
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcController(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcController;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/dataconnection/DcController;->addDc(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    return-void
.end method

.method public exit()V
    .locals 3

    .line 2255
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v1, "DcDefaultState: exit"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2258
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmTransportType(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v1

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    .line 2259
    invoke-virtual {v2}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v2

    .line 2258
    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForDataRegStateOrRatChanged(ILandroid/os/Handler;)V

    .line 2261
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForDataRoamingOn(Landroid/os/Handler;)V

    .line 2262
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForDataRoamingOff(Landroid/os/Handler;)V

    .line 2263
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForNrStateChanged(Landroid/os/Handler;)V

    .line 2264
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForNrFrequencyChanged(Landroid/os/Handler;)V

    .line 2265
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForCssIndicatorChanged(Landroid/os/Handler;)V

    .line 2266
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v1, "bandwidth_estimator"

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$misBandwidthSourceKey(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2267
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLinkBandwidthEstimator()Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->unregisterForBandwidthChanged(Landroid/os/Handler;)V

    .line 2271
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDcController(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcController;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DcController;->removeDc(Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    .line 2273
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmAc(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/AsyncChannel;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 2274
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmAc(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/AsyncChannel;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/AsyncChannel;->disconnected()V

    .line 2275
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmAc(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/AsyncChannel;)V

    .line 2277
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmApnContexts(Lcom/android/internal/telephony/dataconnection/DataConnection;)Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 2278
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iput-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mReconnectIntent:Landroid/app/PendingIntent;

    .line 2279
    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDct(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcTracker;)V

    .line 2280
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmApnSetting(Lcom/android/internal/telephony/dataconnection/DataConnection;Landroid/telephony/data/ApnSetting;)V

    .line 2281
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/Phone;)V

    .line 2282
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDataServiceManager(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataServiceManager;)V

    .line 2283
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmLinkProperties(Lcom/android/internal/telephony/dataconnection/DataConnection;Landroid/net/LinkProperties;)V

    .line 2284
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/4 v2, 0x0

    invoke-static {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmLastFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2285
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmUserData(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Object;)V

    .line 2286
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDcController(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcController;)V

    .line 2287
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDcTesterFailBringUpAll(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;)V

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 6

    .line 2295
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "DcDefault msg="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget v3, p1, Landroid/os/Message;->what:I

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getWhatToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " RefCount="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmApnContexts(Lcom/android/internal/telephony/dataconnection/DataConnection;)Ljava/util/Map;

    move-result-object v3

    .line 2296
    invoke-interface {v3}, Ljava/util/Map;->size()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 2295
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2298
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    const/4 v3, 0x0

    .line 2400
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    sparse-switch v0, :sswitch_data_0

    .line 2415
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "DcDefaultState: ignore msg.what="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getWhatToString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 2375
    :sswitch_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    move-object v0, p1

    check-cast v0, Landroid/os/AsyncResult;

    if-nez v0, :cond_0

    .line 2377
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string p1, "EVENT_RELEASE_PDU_SESSION_ID: asyncResult is null!"

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    goto/16 :goto_0

    :cond_0
    if-eqz p1, :cond_1

    .line 2380
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string p1, "EVENT_RELEASE_PDU_SESSION_ID: id released"

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 2381
    iget-object p0, v0, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p0, Ljava/lang/Runnable;

    .line 2382
    invoke-interface {p0}, Ljava/lang/Runnable;->run()V

    goto/16 :goto_0

    .line 2384
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string p1, "EVENT_RELEASE_PDU_SESSION_ID: no runnable set"

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 2392
    :sswitch_1
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    if-nez p1, :cond_2

    .line 2394
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string p1, "EVENT_ALLOCATE_PDU_SESSION_ID: asyncResult is null!"

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 2396
    :cond_2
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Ljava/util/function/Consumer;

    .line 2397
    iget-object v2, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v2, :cond_3

    .line 2398
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string p1, "EVENT_ALLOCATE_PDU_SESSION_ID: exception"

    invoke-virtual {p0, p1, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 2400
    invoke-interface {v0, v4}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    goto/16 :goto_0

    .line 2401
    :cond_3
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-nez p1, :cond_4

    .line 2402
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string p1, "EVENT_ALLOCATE_PDU_SESSION_ID: result null, no id"

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    .line 2403
    invoke-interface {v0, v4}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    goto/16 :goto_0

    .line 2405
    :cond_4
    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    .line 2406
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "EVENT_ALLOCATE_PDU_SESSION_ID: psi="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 2407
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, p0}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    goto/16 :goto_0

    .line 2360
    :sswitch_2
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "DcDefaultState: EVENT_START_HANDOVER not expected, but will clean up, result code: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Landroid/os/Message;->arg1:I

    .line 2362
    invoke-static {v2}, Landroid/telephony/data/DataServiceCallback;->resultCodeToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2360
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2364
    iget-object p0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p0, Ljava/util/function/Consumer;

    sget-object p1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-interface {p0, p1}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    goto/16 :goto_0

    .line 2369
    :sswitch_3
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "DcDefaultState: EVENT_CANCEL_HANDOVER resultCode="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 2370
    invoke-static {p1}, Landroid/telephony/data/DataServiceCallback;->resultCodeToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2369
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 2353
    :sswitch_4
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v0, "DcDefaultState: EVENT_START_HANDOVER not expected."

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2355
    iget-object p0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p0, Ljava/util/function/Consumer;

    const/4 p1, 0x4

    .line 2356
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    goto/16 :goto_0

    .line 2300
    :sswitch_5
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v0, "DcDefaultState: msg.what=REQ_RESET"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2301
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmInactiveState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto/16 :goto_0

    .line 2334
    :sswitch_6
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 2335
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/util/Pair;

    .line 2336
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object v2, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-static {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmDataRegState(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2337
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object v2, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-static {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mupdateTcpBufferSizes(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2338
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v2, "carrier_config"

    invoke-static {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$misBandwidthSourceKey(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 2339
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object v2, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-static {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mupdateLinkBandwidthsFromCarrierConfig(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2341
    :cond_5
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object p1, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-static {v0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fputmRilRat(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V

    .line 2343
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "DcDefaultState: EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED regState="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDataRegState(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v2

    .line 2344
    invoke-static {v2}, Landroid/telephony/ServiceState;->rilServiceStateToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " RAT="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmRilRat(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result v2

    .line 2345
    invoke-static {v2}, Landroid/telephony/ServiceState;->rilRadioTechnologyToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2343
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2347
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDataCallSessionStats(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    move-result-object p1

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmRilRat(Lcom/android/internal/telephony/dataconnection/DataConnection;)I

    move-result p0

    .line 2348
    invoke-static {p0}, Landroid/telephony/ServiceState;->rilRadioTechnologyToNetworkType(I)I

    move-result p0

    .line 2347
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->onDrsOrRatChanged(I)V

    goto/16 :goto_0

    .line 2328
    :sswitch_7
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "DcDefaultState ignore EVENT_LOST_CONNECTION tag="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ":mTag="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget p1, p1, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2330
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->access$000(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)V

    goto :goto_0

    .line 2320
    :sswitch_8
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v0, "DcDefaultState EVENT_TEAR_DOWN_NOW"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2321
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDataServiceManager(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget v0, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    const/4 v2, 0x0

    invoke-virtual {p1, v0, v1, v2}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->deactivateDataCall(IILandroid/os/Message;)V

    .line 2323
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmDataCallSessionStats(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    move-result-object p0

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->setDeactivateDataCallReason(I)V

    goto :goto_0

    .line 2314
    :sswitch_9
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "DcDefaultState deferring msg.what="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget v5, p1, Landroid/os/Message;->what:I

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getWhatToString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-static {v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$fgetmApnContexts(Lcom/android/internal/telephony/dataconnection/DataConnection;)Ljava/util/Map;

    move-result-object v2

    .line 2315
    invoke-interface {v2}, Ljava/util/Map;->size()I

    move-result v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 2314
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2317
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->deferMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 2304
    :sswitch_a
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const-string v2, "DcDefaultState: msg.what=EVENT_CONNECT, fail not expected"

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2305
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    .line 2306
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;->this$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    const/high16 v0, 0x10000

    const/4 v2, -0x1

    invoke-static {p0, p1, v0, v2, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->-$$Nest$mnotifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V

    :goto_0
    return v1

    nop

    :sswitch_data_0
    .sparse-switch
        0x40000 -> :sswitch_a
        0x40004 -> :sswitch_9
        0x40006 -> :sswitch_9
        0x40008 -> :sswitch_8
        0x40009 -> :sswitch_7
        0x4000b -> :sswitch_6
        0x40018 -> :sswitch_5
        0x40019 -> :sswitch_9
        0x40022 -> :sswitch_4
        0x40023 -> :sswitch_3
        0x40024 -> :sswitch_2
        0x40025 -> :sswitch_1
        0x40026 -> :sswitch_0
    .end sparse-switch
.end method
