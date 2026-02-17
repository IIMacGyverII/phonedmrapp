.class public Lcom/pri/prizeinterphone/message/InterruptMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "InterruptMessage.java"


# instance fields
.field public interrupt:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 15
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, 0x35

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 19
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 1

    .line 24
    invoke-static {p1}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object p1

    sget-object v0, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object p1

    .line 25
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result p1

    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/InterruptMessage;->interrupt:B

    return-void
.end method

.method protected encodeBody()[B
    .locals 1

    const/16 v0, 0x400

    .line 30
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 31
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/InterruptMessage;->interrupt:B

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 32
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method
