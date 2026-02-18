.class public Lcom/pri/prizeinterphone/handler/TotMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "TotMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/TotMessage;",
        ">;"
    }
.end annotation


# static fields
.field public static final TAG:Ljava/lang/String; = "TAG_TotMessageHandler"


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
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/TotMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/TotMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/TotMessage;
    .locals 0

    .line 16
    new-instance p0, Lcom/pri/prizeinterphone/message/TotMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/TotMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 10
    check-cast p1, Lcom/pri/prizeinterphone/message/TotMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/TotMessageHandler;->handle(Lcom/pri/prizeinterphone/message/TotMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/TotMessage;)V
    .locals 1

    const-string p0, "TAG_TotMessageHandler"

    const-string v0, "handle: "

    .line 21
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 22
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getCmdResultFromModule(Lcom/pri/prizeinterphone/message/BaseMessage;)V

    return-void
.end method
