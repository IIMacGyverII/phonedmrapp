.class public Lcom/pri/prizeinterphone/handler/FetchSmsMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "FetchSmsMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/FetchSmsMessage;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/FetchSmsMessage;
    .locals 0

    .line 11
    new-instance p0, Lcom/pri/prizeinterphone/message/FetchSmsMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/FetchSmsMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 8
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/FetchSmsMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/FetchSmsMessage;

    move-result-object p0

    return-object p0
.end method

.method public handle(Lcom/pri/prizeinterphone/message/FetchSmsMessage;)V
    .locals 0

    .line 16
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->onSmsReceived(Lcom/pri/prizeinterphone/message/FetchSmsMessage;)V

    return-void
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 8
    check-cast p1, Lcom/pri/prizeinterphone/message/FetchSmsMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/FetchSmsMessageHandler;->handle(Lcom/pri/prizeinterphone/message/FetchSmsMessage;)V

    return-void
.end method
