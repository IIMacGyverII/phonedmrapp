.class Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;
.super Lcom/pri/prizeinterphone/state/State;
.source "CmdStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/CmdStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "AppFirstEnterState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/CmdStateMachine;)V
    .locals 0

    .line 245
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "CmdStateMachine"

    const-string v0, "############ enter AppEnterState ############"

    .line 248
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "CmdStateMachine"

    const-string v0, "############ exit AppEnterState ############"

    .line 253
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 2

    .line 258
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "AppFirstEnterState  processMessage.....,msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->msg2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "CmdStateMachine"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 259
    iget p1, p1, Landroid/os/Message;->what:I

    packed-switch p1, :pswitch_data_0

    goto :goto_0

    .line 286
    :pswitch_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->onModuleInited()V

    .line 287
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fgetmNoDealState(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    goto :goto_0

    .line 283
    :pswitch_1
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetTotCmdToMdl()V

    goto :goto_0

    .line 279
    :pswitch_2
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetMicGainCmdToMdl()V

    goto :goto_0

    .line 276
    :pswitch_3
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendTransmissionInterruptCmdToMdl()V

    goto :goto_0

    .line 273
    :pswitch_4
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetChannelCmdToMdl()V

    goto :goto_0

    .line 270
    :pswitch_5
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendQueryVersionCmdToMdl()V

    goto :goto_0

    .line 264
    :pswitch_6
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-static {p1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fgetmInitializedFeedBack(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 265
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->-$$Nest$fgetmInitializedFeedBack(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;

    move-result-object p0

    invoke-interface {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;->initializedNotify()V

    .line 267
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendQueryVersionCmdToMdl()V

    goto :goto_0

    .line 261
    :pswitch_7
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendQueryInitializedCmdToMdl()V

    :goto_0
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
