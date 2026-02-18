.class public Lcom/pri/prizeinterphone/handler/VolumeMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "VolumeMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/VolumeMessage;",
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
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/VolumeMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/VolumeMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/VolumeMessage;
    .locals 0

    .line 11
    new-instance p0, Lcom/pri/prizeinterphone/message/VolumeMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/VolumeMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 7
    check-cast p1, Lcom/pri/prizeinterphone/message/VolumeMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/VolumeMessageHandler;->handle(Lcom/pri/prizeinterphone/message/VolumeMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/VolumeMessage;)V
    .locals 0

    return-void
.end method
