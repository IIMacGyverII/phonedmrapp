.class public Lcom/pri/prizeinterphone/state/CmdStateMachine;
.super Lcom/pri/prizeinterphone/state/StateMachine;
.source "CmdStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;,
        Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;,
        Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;,
        Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;
    }
.end annotation


# static fields
.field public static final MSG_INITIALIZED_FEEDBACK_FROM_MODEL:I = 0x3

.field public static final MSG_INITIALIZED_FEEDBACK_FROM_MODEL_ACTIVE:I = 0x2

.field public static final MSG_NOTHING_DO:I = 0x0

.field public static final MSG_QUERY_WHETHER_INITIALIZED:I = 0x1

.field public static final MSG_SET_ANALOG_STATUS_FEEDBACK_FROM_MODEL:I = 0x6

.field public static final MSG_SET_CHANNEL:I = 0xa

.field public static final MSG_SET_CHANNEL_AGAIN_FOR_FAIL:I = 0xb

.field public static final MSG_SET_CHANNEL_AGAIN_FOR_NO_REPLY:I = 0xc

.field public static final MSG_SET_CHANNEL_ERROR:I = 0xd

.field public static final MSG_SET_DIGITAL_STATUS_FEEDBACK_FROM_MODEL:I = 0x5

.field public static final MSG_SET_MIC_GAIN_STATUS_FEEDBACK_FROM_MODEL:I = 0x8

.field public static final MSG_SET_TOT_STATUS_FEEDBACK_FROM_MODEL:I = 0x9

.field public static final MSG_TRANSMISSION_INTERRUPT_STATUS_FEEDBACK_FROM_MODEL:I = 0x7

.field public static final MSG_VERSION_FEEDBACK_FROM_MODEL:I = 0x4

.field private static final TAG:Ljava/lang/String; = "CmdStateMachine"

.field private static volatile instance:Lcom/pri/prizeinterphone/state/CmdStateMachine;


# instance fields
.field private mAppFirstEnterState:Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;

.field private mDealStateList:Landroid/util/ArraySet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArraySet<",
            "Lcom/pri/prizeinterphone/state/IState;",
            ">;"
        }
    .end annotation
.end field

.field private mInitializedFeedBack:Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;

.field private mNoDealState:Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

.field private mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

.field private setChannelAgainAlreadyForFail:Z


# direct methods
.method static bridge synthetic -$$Nest$fgetmInitializedFeedBack(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mInitializedFeedBack:Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmNoDealState(Lcom/pri/prizeinterphone/state/CmdStateMachine;)Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mNoDealState:Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputsetChannelAgainAlreadyForFail(Lcom/pri/prizeinterphone/state/CmdStateMachine;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;)V
    .locals 1

    .line 87
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;-><init>(Ljava/lang/String;)V

    .line 80
    new-instance p1, Landroid/util/ArraySet;

    invoke-direct {p1}, Landroid/util/ArraySet;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mDealStateList:Landroid/util/ArraySet;

    .line 82
    new-instance p1, Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;-><init>(Lcom/pri/prizeinterphone/state/CmdStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mNoDealState:Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    .line 83
    new-instance p1, Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;-><init>(Lcom/pri/prizeinterphone/state/CmdStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mAppFirstEnterState:Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;

    .line 84
    new-instance p1, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;-><init>(Lcom/pri/prizeinterphone/state/CmdStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    const/4 p1, 0x0

    .line 125
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    .line 89
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mNoDealState:Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;)V

    .line 90
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mAppFirstEnterState:Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;)V

    .line 91
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;)V

    .line 92
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mAppFirstEnterState:Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->setInitialState(Lcom/pri/prizeinterphone/state/State;)V

    .line 94
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mDealStateList:Landroid/util/ArraySet;

    invoke-virtual {p1}, Landroid/util/ArraySet;->clear()V

    .line 95
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mDealStateList:Landroid/util/ArraySet;

    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mAppFirstEnterState:Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;

    invoke-virtual {p1, v0}, Landroid/util/ArraySet;->add(Ljava/lang/Object;)Z

    .line 96
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mDealStateList:Landroid/util/ArraySet;

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    invoke-virtual {p1, p0}, Landroid/util/ArraySet;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;
    .locals 3

    .line 101
    sget-object v0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->instance:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    if-nez v0, :cond_1

    .line 102
    const-class v0, Lcom/pri/prizeinterphone/state/CmdStateMachine;

    monitor-enter v0

    .line 103
    :try_start_0
    sget-object v1, Lcom/pri/prizeinterphone/state/CmdStateMachine;->instance:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    if-nez v1, :cond_0

    .line 104
    new-instance v1, Lcom/pri/prizeinterphone/state/CmdStateMachine;

    const-string v2, "CmdState"

    invoke-direct {v1, v2}, Lcom/pri/prizeinterphone/state/CmdStateMachine;-><init>(Ljava/lang/String;)V

    sput-object v1, Lcom/pri/prizeinterphone/state/CmdStateMachine;->instance:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    .line 106
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 108
    :cond_1
    :goto_0
    sget-object v0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->instance:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    return-object v0
.end method

.method public static msg2Str(I)Ljava/lang/String;
    .locals 0

    packed-switch p0, :pswitch_data_0

    const-string p0, "MSG_UNKNOWN"

    return-object p0

    :pswitch_0
    const-string p0, "MSG_SET_CHANNEL_ERROR(13)"

    return-object p0

    :pswitch_1
    const-string p0, "MSG_SET_CHANNEL_AGAIN_FOR_NO_REPLY(12)"

    return-object p0

    :pswitch_2
    const-string p0, "MSG_SET_CHANNEL_AGAIN_FOR_FAIL(11)"

    return-object p0

    :pswitch_3
    const-string p0, "MSG_SET_CHANNEL(10)"

    return-object p0

    :pswitch_4
    const-string p0, "MSG_SET_TOT_STATUS_FEEDBACK_FROM_MODEL(9)"

    return-object p0

    :pswitch_5
    const-string p0, "MSG_SET_MIC_GAIN_STATUS_FEEDBACK_FROM_MODEL(8)"

    return-object p0

    :pswitch_6
    const-string p0, "MSG_TRANSMISSION_INTERRUPT_STATUS_FEEDBACK_FROM_MODEL(7)"

    return-object p0

    :pswitch_7
    const-string p0, "MSG_SET_ANALOG_STATUS_FEEDBACK_FROM_MODEL(6)"

    return-object p0

    :pswitch_8
    const-string p0, "MSG_SET_DIGITAL_STATUS_FEEDBACK_FROM_MODEL(5)"

    return-object p0

    :pswitch_9
    const-string p0, "MSG_VERSION_FEEDBACK_FROM_MODEL(4)"

    return-object p0

    :pswitch_a
    const-string p0, "MSG_INITIALIZED_FEEDBACK_FROM_MODEL(3)"

    return-object p0

    :pswitch_b
    const-string p0, "MSG_INITIALIZED_FEEDBACK_FROM_MODEL_ACTIVE(2)"

    return-object p0

    :pswitch_c
    const-string p0, "MSG_QUERY_WHETHER_INITIALIZED(1)"

    return-object p0

    :pswitch_d
    const-string p0, "MSG_NOTHING_DO(0)"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
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


# virtual methods
.method public getCmdResultFromModule(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 9

    const-string v0, "CmdStateMachine"

    if-nez p1, :cond_0

    const-string p0, "message is null"

    .line 129
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 132
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->isStart()Z

    move-result v1

    if-nez v1, :cond_1

    const-string p0, "no call start()"

    .line 133
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 136
    :cond_1
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mDealStateList:Landroid/util/ArraySet;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->getCurrentState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/util/ArraySet;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string p0, "no On DealStateList, not deal"

    .line 137
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 140
    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getCmdResultFromModule,cmd="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v2, 0x1

    new-array v3, v2, [Ljava/lang/Object;

    iget-object v4, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v4, v4, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    invoke-static {v4}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v4

    const/4 v5, 0x0

    aput-object v4, v3, v5

    const-string v4, "%02x"

    invoke-static {v4, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 142
    iget-object v1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v3, v1, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v4, -0x56

    if-ne v3, v4, :cond_3

    const/4 p1, 0x2

    .line 143
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    :cond_3
    const/16 v4, 0x27

    if-ne v3, v4, :cond_4

    .line 147
    iget-byte p1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez p1, :cond_f

    const/4 p1, 0x3

    .line 148
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    :cond_4
    const/16 v4, 0x34

    if-ne v3, v4, :cond_5

    .line 153
    iget-byte p1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez p1, :cond_f

    const/4 p1, 0x4

    .line 154
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    :cond_5
    const/16 v4, 0xb

    const/16 v6, 0xc

    const/16 v7, 0x22

    const/16 v8, 0xd

    if-ne v3, v7, :cond_8

    .line 159
    invoke-virtual {p0, v6}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 160
    invoke-virtual {p0, v8}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 161
    iget-object v1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez v1, :cond_6

    .line 162
    iput-boolean v5, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    const/4 v0, 0x5

    .line 163
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    .line 164
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0, v7, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->dealEvent(BLcom/pri/prizeinterphone/message/BaseMessage;)V

    goto/16 :goto_0

    .line 165
    :cond_6
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    if-nez p1, :cond_7

    const-string p1, "set digital channel fail,send again"

    .line 166
    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 167
    invoke-virtual {p0, v4}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    .line 168
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    goto/16 :goto_0

    :cond_7
    const-string p1, "set digital channel fail"

    .line 170
    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 171
    invoke-virtual {p0, v8, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto/16 :goto_0

    :cond_8
    const/16 v7, 0x23

    if-ne v3, v7, :cond_b

    .line 176
    invoke-virtual {p0, v6}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 177
    invoke-virtual {p0, v8}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 178
    iget-object v1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez v1, :cond_9

    .line 179
    iput-boolean v5, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    const/4 v0, 0x6

    .line 180
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    .line 181
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0, v7, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->dealEvent(BLcom/pri/prizeinterphone/message/BaseMessage;)V

    goto :goto_0

    .line 182
    :cond_9
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    if-nez p1, :cond_a

    const-string p1, "set analog channel fail,send again"

    .line 183
    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 184
    invoke-virtual {p0, v4}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    .line 185
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelAgainAlreadyForFail:Z

    goto :goto_0

    :cond_a
    const-string p1, "set analog channel fail"

    .line 187
    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 188
    invoke-virtual {p0, v8, v7}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    :cond_b
    const/16 p1, 0x35

    if-ne v3, p1, :cond_c

    .line 193
    iget-byte p1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez p1, :cond_f

    .line 194
    invoke-virtual {p0, v8}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    const/4 p1, 0x7

    .line 195
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    :cond_c
    const/16 p1, 0x2a

    if-ne v3, p1, :cond_d

    .line 200
    iget-byte p1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez p1, :cond_f

    .line 201
    invoke-virtual {p0, v8}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    const/16 p1, 0x8

    .line 202
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    :cond_d
    const/16 p1, 0x3b

    if-ne v3, p1, :cond_e

    .line 207
    iget-byte p1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez p1, :cond_f

    const/16 p1, 0x9

    .line 208
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 211
    :cond_e
    invoke-virtual {p0, v5}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    :cond_f
    :goto_0
    return-void
.end method

.method public getSetChannelState()Lcom/pri/prizeinterphone/state/IState;
    .locals 0

    .line 407
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    return-object p0
.end method

.method public quitCmdMachine()V
    .locals 0

    .line 118
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->quit()V

    const/4 p0, 0x0

    .line 119
    sput-object p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->instance:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    return-void
.end method

.method public setChannelData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 3

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    .line 413
    :try_start_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->clone()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p1

    invoke-virtual {v1, p1}, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->setChannelData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    :try_end_0
    .catch Ljava/lang/CloneNotSupportedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v1, "CmdStateMachine"

    const-string v2, "setChannelData error"

    .line 415
    invoke-static {v1, v2, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 416
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->setChannelData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    goto :goto_0

    .line 419
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;->setChannelData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    :goto_0
    return-void
.end method

.method public setInitializedFeedBack(Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;)V
    .locals 0

    .line 426
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mInitializedFeedBack:Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;

    return-void
.end method

.method public startCmdMachine()V
    .locals 0

    .line 112
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->isStart()Z

    move-result p0

    if-nez p0, :cond_0

    .line 113
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->start()V

    :cond_0
    return-void
.end method

.method public transitionToAppFirstEnterState()V
    .locals 1

    .line 399
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mAppFirstEnterState:Lcom/pri/prizeinterphone/state/CmdStateMachine$AppFirstEnterState;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    return-void
.end method

.method public transitionToSetChannelStateState()V
    .locals 1

    .line 403
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine;->mSetChannelState:Lcom/pri/prizeinterphone/state/CmdStateMachine$SetChannelState;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->transitionTo(Lcom/pri/prizeinterphone/state/IState;)V

    return-void
.end method
