.class public Lcom/pri/prizeinterphone/handler/MixCheckMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "MixCheckMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/MixCheckMessage;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 6
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/MixCheckMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/MixCheckMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/MixCheckMessage;
    .locals 0

    .line 10
    new-instance p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/MixCheckMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 6
    check-cast p1, Lcom/pri/prizeinterphone/message/MixCheckMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/MixCheckMessageHandler;->handle(Lcom/pri/prizeinterphone/message/MixCheckMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/MixCheckMessage;)V
    .locals 0

    return-void
.end method
