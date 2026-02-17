.class public Lcom/pri/prizeinterphone/handler/RelayMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "RelayMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/RelayMessage;",
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
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/RelayMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/RelayMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/RelayMessage;
    .locals 0

    .line 11
    new-instance p0, Lcom/pri/prizeinterphone/message/RelayMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/RelayMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 7
    check-cast p1, Lcom/pri/prizeinterphone/message/RelayMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/RelayMessageHandler;->handle(Lcom/pri/prizeinterphone/message/RelayMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/RelayMessage;)V
    .locals 0

    return-void
.end method
