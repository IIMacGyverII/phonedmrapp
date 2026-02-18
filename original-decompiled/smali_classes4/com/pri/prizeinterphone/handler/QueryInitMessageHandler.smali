.class public Lcom/pri/prizeinterphone/handler/QueryInitMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "QueryInitMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/QueryInitMessage;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 10
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/QueryInitMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/QueryInitMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/QueryInitMessage;
    .locals 0

    .line 14
    new-instance p0, Lcom/pri/prizeinterphone/message/QueryInitMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/QueryInitMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 10
    check-cast p1, Lcom/pri/prizeinterphone/message/QueryInitMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/QueryInitMessageHandler;->handle(Lcom/pri/prizeinterphone/message/QueryInitMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/QueryInitMessage;)V
    .locals 0

    .line 19
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getCmdResultFromModule(Lcom/pri/prizeinterphone/message/BaseMessage;)V

    return-void
.end method
