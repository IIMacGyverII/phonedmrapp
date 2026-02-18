.class public Lcom/pri/prizeinterphone/codec/PacketEncoder;
.super Ljava/lang/Object;
.source "PacketEncoder.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static checkSum(Lcom/pri/prizeinterphone/protocol/Packet;)I
    .locals 3

    const/16 v0, 0x400

    .line 38
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 39
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->head:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 40
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 41
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 42
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    const/4 v1, 0x0

    .line 43
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putShort(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 45
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/protocol/Packet;->getBodyLength()I

    move-result v1

    int-to-short v1, v1

    shr-int/lit8 v2, v1, 0x8

    int-to-byte v2, v2

    int-to-byte v1, v1

    .line 49
    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 50
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 51
    iget-object p0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    const/16 p0, 0x10

    .line 52
    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 53
    invoke-static {v0}, Lcom/pri/prizeinterphone/codec/PacketEncoder;->pcCheckSum(Lcom/pri/prizeinterphone/Util/ByteBuf;)I

    move-result p0

    return p0
.end method

.method public static encode(Lcom/pri/prizeinterphone/protocol/Packet;Lcom/pri/prizeinterphone/Util/ByteBuf;)V
    .locals 2

    .line 12
    invoke-static {p0}, Lcom/pri/prizeinterphone/codec/PacketEncoder;->checkSum(Lcom/pri/prizeinterphone/protocol/Packet;)I

    move-result v0

    int-to-short v0, v0

    .line 13
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->head:B

    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 14
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 15
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 16
    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    shr-int/lit8 v1, v0, 0x8

    int-to-byte v1, v1

    int-to-byte v0, v0

    .line 21
    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 22
    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 26
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/protocol/Packet;->getBodyLength()I

    move-result v0

    int-to-short v0, v0

    shr-int/lit8 v1, v0, 0x8

    int-to-byte v1, v1

    int-to-byte v0, v0

    .line 29
    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 30
    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 33
    iget-object p0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    const/16 p0, 0x10

    .line 34
    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    return-void
.end method

.method private static pcCheckSum(Lcom/pri/prizeinterphone/Util/ByteBuf;)I
    .locals 9

    .line 57
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->nioBuffer()Ljava/nio/ByteBuffer;

    move-result-object p0

    .line 58
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    const-wide/16 v0, 0x0

    move-wide v2, v0

    .line 60
    :goto_0
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v4

    const/4 v5, 0x1

    const v6, 0xffff

    if-le v4, v5, :cond_0

    .line 61
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    move-result v4

    and-int/lit16 v4, v4, 0xff

    shl-int/lit8 v4, v4, 0x8

    .line 62
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    move-result v5

    and-int/lit16 v5, v5, 0xff

    or-int/2addr v4, v5

    and-int/2addr v4, v6

    int-to-long v4, v4

    add-long/2addr v2, v4

    goto :goto_0

    .line 65
    :cond_0
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->hasRemaining()Z

    move-result v4

    if-eqz v4, :cond_1

    .line 66
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    move-result p0

    and-int/lit16 p0, p0, 0xff

    shl-int/lit8 p0, p0, 0x8

    int-to-long v4, p0

    :goto_1
    add-long/2addr v2, v4

    :cond_1
    const/16 p0, 0x10

    shr-long v4, v2, p0

    cmp-long p0, v4, v0

    if-lez p0, :cond_2

    const-wide/32 v7, 0xffff

    and-long/2addr v2, v7

    goto :goto_1

    :cond_2
    long-to-int p0, v2

    xor-int/2addr p0, v6

    return p0
.end method
