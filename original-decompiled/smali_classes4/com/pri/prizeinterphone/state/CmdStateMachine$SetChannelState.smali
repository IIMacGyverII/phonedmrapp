.class Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;
.super Lcom/pri/prizeinterphone/state/State;
.source "CmdStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/CmdStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "SetChannelState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

.field private tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/CmdStateMachine;)V
    .locals 0

    .line 300
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    const/4 p1, 0x0

    .line 301
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "CmdStateMachine"

    const-string v0, "############ enter SetChannelState ############"

    .line 308
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "CmdStateMachine"

    const-string v0, "############ exit SetChannelState ############"

    .line 313
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 8

    .line 318
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SetChannelState  processMessage.....,msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->msg2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "CmdStateMachine"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 319
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v2, 0xc

    const/16 v3, 0x22

    const/16 v4, 0x23

    const/16 v5, 0xd

    const-wide/16 v6, 0x3e8

    packed-switch v0, :pswitch_data_0

    :pswitch_0
    goto/16 :goto_4

    .line 327
    :pswitch_1
    iget p1, p1, Landroid/os/Message;->arg1:I

    int-to-byte p1, p1

    .line 328
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "MSG_SET_CHANNEL_ERROR,cmd"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 329
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->errorEvent(B)V

    .line 330
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fgetmNoDealState(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    goto/16 :goto_4

    .line 337
    :pswitch_2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "set channel no reply,send again,tmpChannelData="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 338
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetChannelCmdToMdl(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 339
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    if-nez p1, :cond_2

    .line 340
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 342
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    .line 343
    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez p1, :cond_0

    goto :goto_0

    :cond_0
    move v3, v4

    .line 342
    :goto_0
    invoke-virtual {p0, v5, v3, v6, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(IIJ)V

    goto/16 :goto_4

    :cond_1
    const-string p1, "set currentChannel is null"

    .line 347
    invoke-static {v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 348
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fgetmNoDealState(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    goto/16 :goto_4

    .line 351
    :cond_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    .line 352
    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez p1, :cond_3

    goto :goto_1

    :cond_3
    move v3, v4

    .line 351
    :goto_1
    invoke-virtual {p0, v5, v3, v6, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(IIJ)V

    goto/16 :goto_4

    .line 333
    :pswitch_3
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetChannelCmdToMdl(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 334
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-virtual {p0, v2, v6, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(IJ)V

    goto/16 :goto_4

    .line 321
    :pswitch_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    const/4 v0, 0x0

    invoke-static {p1, v0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fputsetChannelAgainAlreadyForFail(Lcom/pri/prizeinterphone/state/CmdStateMachine;Z)V

    .line 322
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "MSG_SET_CHANNEL,channelData="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 323
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetChannelCmdToMdl(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 324
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-virtual {p0, v2, v6, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(IJ)V

    goto/16 :goto_4

    .line 391
    :pswitch_5
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fgetmNoDealState(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    goto :goto_4

    .line 378
    :pswitch_6
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    if-nez p1, :cond_4

    .line 379
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p1

    .line 383
    :cond_4
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    .line 384
    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez p1, :cond_5

    goto :goto_2

    :cond_5
    move v3, v4

    .line 383
    :goto_2
    invoke-virtual {p0, v5, v3, v6, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(IIJ)V

    .line 387
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetMicGainCmdToMdl()V

    goto :goto_4

    .line 360
    :pswitch_7
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "MSG_SET_DIGITAL_STATUS_FEEDBACK_FROM_MODEL,tmpChannelData="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 361
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    if-nez p1, :cond_6

    .line 362
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p1

    .line 366
    :cond_6
    iget v0, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    const/4 v1, 0x3

    if-ne v0, v1, :cond_7

    .line 367
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fgetmNoDealState(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    goto :goto_4

    .line 369
    :cond_7
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    .line 370
    iget v0, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez v0, :cond_8

    goto :goto_3

    :cond_8
    move v3, v4

    .line 369
    :goto_3
    invoke-virtual {p0, v5, v3, v6, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(IIJ)V

    .line 373
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendTransmissionInterruptCmdToMdl(I)V

    :goto_4
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x5
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_5
        :pswitch_0
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method public setChannelData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 0

    .line 303
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->tmpChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    return-void
.end method
