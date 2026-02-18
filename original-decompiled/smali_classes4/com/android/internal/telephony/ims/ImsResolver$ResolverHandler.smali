.class Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;
.super Landroid/os/Handler;
.source "ImsResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/ims/ImsResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ResolverHandler"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/ims/ImsResolver;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/os/Looper;)V
    .locals 0

    .line 460
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    .line 461
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 5

    .line 466
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0x3e8

    const-string v2, "ImsResolver"

    if-eq v0, v1, :cond_3

    const/4 v1, 0x1

    packed-switch v0, :pswitch_data_0

    goto/16 :goto_1

    .line 538
    :pswitch_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mclearCarrierServiceOverrides(Lcom/android/internal/telephony/ims/ImsResolver;I)V

    goto/16 :goto_1

    .line 533
    :pswitch_1
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 534
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mhandleMsimConfigChange(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/Integer;)V

    goto/16 :goto_1

    .line 478
    :pswitch_2
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmBootCompletedHandlerRan(Lcom/android/internal/telephony/ims/ImsResolver;)Z

    move-result p1

    if-nez p1, :cond_6

    .line 479
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p1, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fputmBootCompletedHandlerRan(Lcom/android/internal/telephony/ims/ImsResolver;Z)V

    .line 480
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmEventLog(Lcom/android/internal/telephony/ims/ImsResolver;)Lcom/android/internal/telephony/LocalLog;

    move-result-object p1

    const-string v0, "handling BOOT_COMPLETE"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 481
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmCarrierConfigReceived(Lcom/android/internal/telephony/ims/ImsResolver;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 482
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmEventLog(Lcom/android/internal/telephony/ims/ImsResolver;)Lcom/android/internal/telephony/LocalLog;

    move-result-object p1

    const-string v0, "boot complete - reeval"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 485
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    const/4 p1, 0x0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mmaybeAddedImsService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/String;)V

    goto/16 :goto_1

    .line 487
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmEventLog(Lcom/android/internal/telephony/ims/ImsResolver;)Lcom/android/internal/telephony/LocalLog;

    move-result-object p1

    const-string v0, "boot complete - update cache"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 490
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mupdateInstalledServicesCache(Lcom/android/internal/telephony/ims/ImsResolver;)V

    goto/16 :goto_1

    .line 523
    :pswitch_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;

    .line 524
    iget-boolean v0, p1, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;->isCarrierService:Z

    if-eqz v0, :cond_1

    .line 525
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iget v0, p1, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;->slotId:I

    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;->featureTypeToPackageMap:Ljava/util/Map;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$moverrideCarrierService(Lcom/android/internal/telephony/ims/ImsResolver;ILjava/util/Map;)V

    goto/16 :goto_1

    .line 528
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iget-object p1, p1, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;->featureTypeToPackageMap:Ljava/util/Map;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$moverrideDeviceService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/Map;)V

    goto/16 :goto_1

    .line 514
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/SomeArgs;

    .line 515
    iget-object v0, p1, Lcom/android/internal/telephony/SomeArgs;->arg1:Ljava/lang/Object;

    check-cast v0, Landroid/content/ComponentName;

    .line 516
    iget-object v1, p1, Lcom/android/internal/telephony/SomeArgs;->arg2:Ljava/lang/Object;

    check-cast v1, Ljava/util/Set;

    .line 518
    invoke-virtual {p1}, Lcom/android/internal/telephony/SomeArgs;->recycle()V

    .line 519
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0, v0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mdynamicQueryComplete(Lcom/android/internal/telephony/ims/ImsResolver;Landroid/content/ComponentName;Ljava/util/Set;)V

    goto/16 :goto_1

    .line 509
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;

    .line 510
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mstartDynamicQuery(Lcom/android/internal/telephony/ims/ImsResolver;Lcom/android/internal/telephony/ims/ImsResolver$ImsServiceInfo;)V

    goto/16 :goto_1

    .line 496
    :pswitch_6
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 497
    iget p1, p1, Landroid/os/Message;->arg2:I

    .line 500
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v3}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmNumSlots(Lcom/android/internal/telephony/ims/ImsResolver;)I

    move-result v3

    if-lt v0, v3, :cond_2

    .line 501
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "HANDLER_CONFIG_CHANGED for invalid slotid="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 504
    :cond_2
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v2, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fputmCarrierConfigReceived(Lcom/android/internal/telephony/ims/ImsResolver;Z)V

    .line 505
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0, v0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mcarrierConfigChanged(Lcom/android/internal/telephony/ims/ImsResolver;II)V

    goto :goto_1

    .line 473
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    .line 474
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mmaybeRemovedImsService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/String;)Z

    goto :goto_1

    .line 468
    :pswitch_8
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    .line 469
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mmaybeAddedImsService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/String;)V

    goto :goto_1

    .line 543
    :cond_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    const/4 v0, 0x0

    .line 544
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$fgetmNumSlots(Lcom/android/internal/telephony/ims/ImsResolver;)I

    move-result v1

    if-ge v0, v1, :cond_5

    .line 545
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v1, v0}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mgetSubIdUsingPhoneId(Lcom/android/internal/telephony/ims/ImsResolver;I)I

    move-result v1

    .line 546
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "HANDLER_INIT_IMS_SERVICE for SlotId: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ", newSubId: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v3, -0x1

    if-eq v1, v3, :cond_4

    .line 549
    iget-object v3, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {v3, v0, v1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$msetSubId(Lcom/android/internal/telephony/ims/ImsResolver;II)V

    :cond_4
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 552
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$ResolverHandler;->this$0:Lcom/android/internal/telephony/ims/ImsResolver;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsResolver;->-$$Nest$mmaybeAddedImsService(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/lang/String;)V

    :cond_6
    :goto_1
    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
