.class public Lcom/pri/prizeinterphone/handler/MonitorMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "MonitorMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/MonitorMessage;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 5
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 5
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/MonitorMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/MonitorMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/MonitorMessage;
    .locals 0

    .line 9
    new-instance p0, Lcom/pri/prizeinterphone/message/MonitorMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/MonitorMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 5
    check-cast p1, Lcom/pri/prizeinterphone/message/MonitorMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/MonitorMessageHandler;->handle(Lcom/pri/prizeinterphone/message/MonitorMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/MonitorMessage;)V
    .locals 0

    return-void
.end method
