.class public Lcom/pri/prizeinterphone/handler/SignalMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "SignalMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/SignalMessage;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 7
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/SignalMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/SignalMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/SignalMessage;
    .locals 0

    .line 11
    new-instance p0, Lcom/pri/prizeinterphone/message/SignalMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/SignalMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 7
    check-cast p1, Lcom/pri/prizeinterphone/message/SignalMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/SignalMessageHandler;->handle(Lcom/pri/prizeinterphone/message/SignalMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/SignalMessage;)V
    .locals 0

    return-void
.end method
