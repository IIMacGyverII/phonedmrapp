.class public Lcom/pri/prizeinterphone/message/SmsProtocolMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "SmsProtocolMessage.java"


# instance fields
.field public type:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 11
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, 0x3a

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 v0, 0x0

    .line 9
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/SmsProtocolMessage;->type:B

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 15
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 p1, 0x0

    .line 9
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/SmsProtocolMessage;->type:B

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 0

    return-void
.end method

.method protected encodeBody()[B
    .locals 1

    const/16 v0, 0x400

    .line 25
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 26
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/SmsProtocolMessage;->type:B

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 27
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method
