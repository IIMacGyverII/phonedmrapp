.class public Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
.super Lcom/pri/prizeinterphone/state/StateMachine;
.source "TalkBackStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RelayConnectionFailedState;,
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;,
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$SendExceptionState;,
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;,
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$PhoneCallingState;,
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;,
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;,
        Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;
    }
.end annotation


# static fields
.field public static final MSG_CHANNEL_CHANGE:I = 0x7e5

.field public static final MSG_INTERRUPT_GET_NO_RESULT:I = 0x7df

.field public static final MSG_INTERRUPT_GET_RESULT:I = 0x7de

.field public static final MSG_INTERRUPT_START:I = 0x7dd

.field public static final MSG_PHONE_CALLING:I = 0x7e2

.field public static final MSG_PHONE_END:I = 0x7e3

.field public static final MSG_RECEIVE_SOUND_END:I = 0x7e1

.field public static final MSG_RECEIVE_SOUND_START:I = 0x7e0

.field public static final MSG_RECORD_SOUND_END:I = 0x7dc

.field public static final MSG_RECORD_SOUND_END_FEEDBACK_FROM_MODULE:I = 0x7e7

.field public static final MSG_RECORD_SOUND_START:I = 0x7db

.field public static final MSG_RECORD_SOUND_START_FEEDBACK_FROM_MODULE:I = 0x7e6

.field public static final MSG_RECORD_SOUND_START_NEED_DELAY:I = 0x4e8f

.field public static final MSG_RECORD_SOUND_START_REFRESH_UI:I = 0x4e90

.field public static final MSG_RELAY_CONNECTION_FAILED:I = 0x7e4

.field public static final STATE_IDLE:I = 0x0

.field public static final STATE_RECEIVE:I = 0x2

.field public static final STATE_RECORD:I = 0x1

.field private static final TAG:Ljava/lang/String; = "TalkBackStateMachine"


# instance fields
.field private fragment:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

.field private mBusyNoSendState:Lcom/pri/prizeinterphone/state/State;

.field private mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

.field private mPhoneCallingState:Lcom/pri/prizeinterphone/state/State;

.field private mReceiveSoundState:Lcom/pri/prizeinterphone/state/State;

.field private mRecordSoundState:Lcom/pri/prizeinterphone/state/State;

.field private mRelayConnectionFailedState:Lcom/pri/prizeinterphone/state/State;

.field private mSendExceptionState:Lcom/pri/prizeinterphone/state/State;

.field private mWaitIngInterruptResultState:Lcom/pri/prizeinterphone/state/State;


# direct methods
.method static bridge synthetic -$$Nest$fgetfragment(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->fragment:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmBusyNoSendState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mBusyNoSendState:Lcom/pri/prizeinterphone/state/State;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmIdleState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhoneCallingState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mPhoneCallingState:Lcom/pri/prizeinterphone/state/State;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmReceiveSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mReceiveSoundState:Lcom/pri/prizeinterphone/state/State;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRecordSoundState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mRecordSoundState:Lcom/pri/prizeinterphone/state/State;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRelayConnectionFailedState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mRelayConnectionFailedState:Lcom/pri/prizeinterphone/state/State;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSendExceptionState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mSendExceptionState:Lcom/pri/prizeinterphone/state/State;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmWaitIngInterruptResultState(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)Lcom/pri/prizeinterphone/state/State;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mWaitIngInterruptResultState:Lcom/pri/prizeinterphone/state/State;

    return-object p0
.end method

.method protected constructor <init>(Ljava/lang/String;Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    .line 93
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;-><init>(Ljava/lang/String;)V

    .line 76
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    .line 77
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RecordSoundState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mRecordSoundState:Lcom/pri/prizeinterphone/state/State;

    .line 78
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$ReceiveSoundState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mReceiveSoundState:Lcom/pri/prizeinterphone/state/State;

    .line 79
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$PhoneCallingState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$PhoneCallingState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mPhoneCallingState:Lcom/pri/prizeinterphone/state/State;

    .line 80
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$SendExceptionState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$SendExceptionState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mSendExceptionState:Lcom/pri/prizeinterphone/state/State;

    .line 81
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$BusyNoSendState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mBusyNoSendState:Lcom/pri/prizeinterphone/state/State;

    .line 82
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$WaitIngInterruptResultState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mWaitIngInterruptResultState:Lcom/pri/prizeinterphone/state/State;

    .line 83
    new-instance p1, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RelayConnectionFailedState;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine$RelayConnectionFailedState;-><init>(Lcom/pri/prizeinterphone/state/TalkBackStateMachine;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mRelayConnectionFailedState:Lcom/pri/prizeinterphone/state/State;

    .line 94
    iput-object p2, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->fragment:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    .line 95
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;)V

    .line 97
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mSendExceptionState:Lcom/pri/prizeinterphone/state/State;

    iget-object p2, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)V

    .line 98
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mRecordSoundState:Lcom/pri/prizeinterphone/state/State;

    iget-object p2, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mSendExceptionState:Lcom/pri/prizeinterphone/state/State;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)V

    .line 100
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mBusyNoSendState:Lcom/pri/prizeinterphone/state/State;

    iget-object p2, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)V

    .line 101
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mReceiveSoundState:Lcom/pri/prizeinterphone/state/State;

    iget-object p2, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mBusyNoSendState:Lcom/pri/prizeinterphone/state/State;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)V

    .line 103
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mWaitIngInterruptResultState:Lcom/pri/prizeinterphone/state/State;

    iget-object p2, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)V

    .line 105
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mRelayConnectionFailedState:Lcom/pri/prizeinterphone/state/State;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;)V

    .line 107
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mPhoneCallingState:Lcom/pri/prizeinterphone/state/State;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->addState(Lcom/pri/prizeinterphone/state/State;)V

    .line 110
    iget-object p1, p0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->mIdleState:Lcom/pri/prizeinterphone/state/TalkBackStateMachine$IdleState;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->setInitialState(Lcom/pri/prizeinterphone/state/State;)V

    return-void
.end method

.method public static makePerson(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
    .locals 2

    .line 114
    new-instance v0, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const-string v1, "TalkBack"

    invoke-direct {v0, v1, p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;-><init>(Ljava/lang/String;Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    .line 115
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/state/StateMachine;->start()V

    return-object v0
.end method

.method public static msg2Str(I)Ljava/lang/String;
    .locals 1

    const/16 v0, 0x4e8f

    if-eq p0, v0, :cond_1

    const/16 v0, 0x4e90

    if-eq p0, v0, :cond_0

    packed-switch p0, :pswitch_data_0

    const-string p0, "MSG_UNKNOWN"

    return-object p0

    :pswitch_0
    const-string p0, "MSG_RECORD_SOUND_END_FEEDBACK_FROM_MODULE(2023)"

    return-object p0

    :pswitch_1
    const-string p0, "MSG_RECORD_SOUND_START_FEEDBACK_FROM_MODULE(2022)"

    return-object p0

    :pswitch_2
    const-string p0, "MSG_CHANNEL_CHANGE(2021)"

    return-object p0

    :pswitch_3
    const-string p0, "MSG_RELAY_CONNECTION_FAILED(2020)"

    return-object p0

    :pswitch_4
    const-string p0, "MSG_PHONE_END(2019)"

    return-object p0

    :pswitch_5
    const-string p0, "MSG_PHONE_CALLING(2018)"

    return-object p0

    :pswitch_6
    const-string p0, "MSG_RECEIVE_SOUND_END(2017)"

    return-object p0

    :pswitch_7
    const-string p0, "MSG_RECEIVE_SOUND_START(2016)"

    return-object p0

    :pswitch_8
    const-string p0, "MSG_INTERRUPT_GET_NO_RESULT(2015)"

    return-object p0

    :pswitch_9
    const-string p0, "MSG_INTERRUPT_GET_RESULT(2014)"

    return-object p0

    :pswitch_a
    const-string p0, "MSG_INTERRUPT_START(2013)"

    return-object p0

    :pswitch_b
    const-string p0, "MSG_RECORD_SOUND_END(2012)"

    return-object p0

    :pswitch_c
    const-string p0, "MSG_RECORD_SOUND_START(2011)"

    return-object p0

    :cond_0
    const-string p0, "MSG_RECORD_SOUND_START_REFRESH_UI(20112)"

    return-object p0

    :cond_1
    const-string p0, "MSG_RECORD_SOUND_START_NEED_DELAY(20111)"

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x7db
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
.method protected onHalting()V
    .locals 1

    .line 158
    monitor-enter p0

    .line 159
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->notifyAll()V

    .line 160
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method
