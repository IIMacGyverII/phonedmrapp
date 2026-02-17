.class public Lcom/pri/prizeinterphone/handler/MicMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "MicMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/MicMessage;",
        ">;"
    }
.end annotation


# static fields
.field public static final TAG:Ljava/lang/String; = "MicMessageHandler"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 11
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/MicMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/MicMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/MicMessage;
    .locals 0

    .line 16
    new-instance p0, Lcom/pri/prizeinterphone/message/MicMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/MicMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 11
    check-cast p1, Lcom/pri/prizeinterphone/message/MicMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/MicMessageHandler;->handle(Lcom/pri/prizeinterphone/message/MicMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/MicMessage;)V
    .locals 1

    .line 21
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handle: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ",sr="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v0, v0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    invoke-static {v0}, Lcom/pri/prizeinterphone/protocol/Const;->sRFlag2Str(B)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "MicMessageHandler"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 22
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getCmdResultFromModule(Lcom/pri/prizeinterphone/message/BaseMessage;)V

    return-void
.end method
