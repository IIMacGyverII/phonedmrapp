.class public Lcom/pri/prizeinterphone/codec/AsyncPacketReader;
.super Ljava/lang/Object;
.source "AsyncPacketReader.java"

# interfaces
.implements Ljava/lang/Runnable;


# static fields
.field public static final TAG:Ljava/lang/String; = "TAG_AsyncPacketReader"


# instance fields
.field private final buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

.field private isStop:Z

.field private final receiver:Lcom/pri/prizeinterphone/serial/PacketReceiver;

.field private serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

.field private thread:Ljava/lang/Thread;

.field private final threadFactory:Lcom/pri/prizeinterphone/Util/NamedThreadFactory;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/serial/port/SerialPort;Lcom/pri/prizeinterphone/serial/PacketReceiver;)V
    .locals 2

    .line 32
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 24
    new-instance v0, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    const-string v1, "serial-port-read-t"

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->threadFactory:Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    const/4 v0, 0x0

    .line 30
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->isStop:Z

    .line 33
    iput-object p1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    const/16 p1, 0x7fff

    .line 34
    invoke-static {p1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocateDirect(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 35
    iput-object p2, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->receiver:Lcom/pri/prizeinterphone/serial/PacketReceiver;

    const/4 p1, 0x1

    .line 36
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->isStop:Z

    return-void
.end method

.method private decodePacket(Ljava/nio/ByteBuffer;)V
    .locals 3

    .line 89
    :goto_0
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->decode(Ljava/nio/ByteBuffer;)Lcom/pri/prizeinterphone/protocol/Packet;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 90
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "read packet =="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "TAG_AsyncPacketReader"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 91
    iget-object v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->receiver:Lcom/pri/prizeinterphone/serial/PacketReceiver;

    iget-object v2, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-interface {v1, v0, v2}, Lcom/pri/prizeinterphone/serial/PacketReceiver;->onReceive(Lcom/pri/prizeinterphone/protocol/Packet;Lcom/pri/prizeinterphone/serial/port/SerialPort;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private read(Ljava/io/FileInputStream;Ljava/nio/ByteBuffer;)Z
    .locals 5

    const-string p0, "TAG_AsyncPacketReader"

    const/16 v0, 0x400

    const/4 v1, 0x0

    const/4 v2, 0x2

    :try_start_0
    new-array v0, v0, [B

    .line 109
    invoke-virtual {p1, v0}, Ljava/io/FileInputStream;->read([B)I

    move-result p1

    .line 110
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "readCount == "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {p0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 111
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "read bytes == "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/Util;->bytesToHex([B)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {p0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-le p1, v2, :cond_0

    .line 114
    invoke-virtual {p2, v0, v1, p1}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 117
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    const/4 p1, -0x1

    :cond_0
    :goto_0
    if-le p1, v2, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method private read(Ljava/nio/channels/FileChannel;Ljava/nio/ByteBuffer;)Z
    .locals 0

    .line 98
    :try_start_0
    invoke-virtual {p1, p2}, Ljava/nio/channels/FileChannel;->read(Ljava/nio/ByteBuffer;)I

    move-result p0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 p0, -0x1

    :goto_0
    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_1

    :cond_0
    const/4 p0, 0x0

    :goto_1
    return p0
.end method


# virtual methods
.method public decode(Ljava/nio/ByteBuffer;)Lcom/pri/prizeinterphone/protocol/Packet;
    .locals 11

    .line 125
    sget-object p0, Ljava/nio/ByteOrder;->BIG_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p1, p0}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    .line 126
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result p0

    const/4 v0, 0x0

    const/16 v1, 0x8

    if-lt p0, v1, :cond_7

    .line 127
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isTestBitErrorRate()Z

    move-result p0

    const-string v1, "TAG_AsyncPacketReader"

    if-eqz p0, :cond_0

    .line 128
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "decode is on Test Bit Error Rate,in.remaining()="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 129
    new-instance p0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v0, 0x3f

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    .line 130
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    new-array v0, v0, [B

    .line 131
    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 132
    iput-object v0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    return-object p0

    .line 135
    :cond_0
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->mark()Ljava/nio/Buffer;

    .line 136
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result p0

    .line 137
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result v2

    .line 138
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "decode:before head="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v4, 0x1

    new-array v5, v4, [Ljava/lang/Object;

    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v6

    const/4 v7, 0x0

    aput-object v6, v5, v7

    const-string v6, "%02x"

    invoke-static {v6, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-nez v2, :cond_1

    const-string v2, "decode head is not 0x00, head is Data header changes manually!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    .line 142
    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 143
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result v2

    :cond_1
    const/16 v3, 0xf0

    if-ne v2, v3, :cond_2

    const-string v2, "decode head is not 0xf0, head is Data header changes manually!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    .line 148
    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 149
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result v2

    .line 155
    :cond_2
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result v3

    .line 156
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "decode: bufferSize="

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, ",head="

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-array v9, v4, [Ljava/lang/Object;

    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v10

    aput-object v10, v9, v7

    invoke-static {v6, v9}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, ",cmd="

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-array v4, v4, [Ljava/lang/Object;

    invoke-static {v3}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v9

    aput-object v9, v4, v7

    invoke-static {v6, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/16 v4, -0x41

    const-string v5, "Packet decode == "

    if-ne v2, v4, :cond_4

    const/16 v4, -0x56

    if-ne v3, v4, :cond_4

    :goto_0
    const/16 p0, 0xf

    if-ge v7, p0, :cond_3

    .line 159
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    add-int/lit8 v7, v7, 0x1

    goto :goto_0

    .line 161
    :cond_3
    new-instance p0, Lcom/pri/prizeinterphone/protocol/Packet;

    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    .line 162
    invoke-virtual {p0, v2}, Lcom/pri/prizeinterphone/protocol/Packet;->setHead(B)V

    .line 163
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0

    .line 166
    :cond_4
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result v4

    .line 167
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result v6

    .line 168
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->getShort()S

    move-result v7

    const v9, 0xffff

    and-int/2addr v7, v9

    .line 169
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->getShort()S

    move-result v10

    and-int/2addr v9, v10

    .line 170
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "--bodyLen="

    invoke-virtual {v10, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "--head"

    invoke-virtual {v10, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    and-int/lit16 p0, v2, 0xff

    invoke-static {p0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v10, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "--cmd"

    invoke-virtual {v10, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    and-int/lit16 p0, v3, 0xff

    invoke-static {p0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v10, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/16 p0, 0x68

    if-ne v2, p0, :cond_6

    if-lez v9, :cond_5

    .line 174
    new-array v0, v9, [B

    .line 175
    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 177
    :cond_5
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    .line 178
    new-instance p0, Lcom/pri/prizeinterphone/protocol/Packet;

    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    .line 179
    iput-byte v3, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    .line 180
    iput-byte v4, p0, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    .line 181
    iput-byte v6, p0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    int-to-short p1, v7

    .line 182
    iput-short p1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->ckSum:S

    .line 183
    iput-object v0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    int-to-short p1, v9

    .line 184
    iput-short p1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->len:S

    .line 185
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0

    .line 188
    :cond_6
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->reset()Ljava/nio/Buffer;

    :cond_7
    return-object v0
.end method

.method public isStop()Z
    .locals 0

    .line 46
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->isStop:Z

    return p0
.end method

.method public run()V
    .locals 3

    const-string v0, "TAG_AsyncPacketReader"

    .line 61
    :try_start_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->clear()Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 62
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "start read  serial.isConnected() = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->isConnected()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 63
    :goto_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->isConnected()Z

    move-result v1

    if-eqz v1, :cond_1

    iget-boolean v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->isStop:Z

    if-nez v1, :cond_1

    const-string/jumbo v1, "start read"

    .line 66
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 67
    iget-object v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    const/16 v2, 0x400

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/Util/ByteBuf;->checkCapacity(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->nioBuffer()Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 68
    iget-object v2, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->getInputStream()Ljava/io/FileInputStream;

    move-result-object v2

    invoke-direct {p0, v2, v1}, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->read(Ljava/io/FileInputStream;Ljava/nio/ByteBuffer;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 69
    iget-object v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->clear()Lcom/pri/prizeinterphone/Util/ByteBuf;

    goto :goto_0

    .line 72
    :cond_0
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    .line 73
    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->decodePacket(Ljava/nio/ByteBuffer;)V

    .line 74
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->compact()Ljava/nio/ByteBuffer;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p0

    goto :goto_1

    :catch_0
    move-exception p0

    :try_start_1
    const-string v1, "run error----------------------------------"

    .line 80
    invoke-static {v0, v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :cond_1
    return-void

    .line 84
    :goto_1
    throw p0
.end method

.method public startRead()V
    .locals 2

    .line 40
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->threadFactory:Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;->newThread(Ljava/lang/Runnable;)Ljava/lang/Thread;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->thread:Ljava/lang/Thread;

    const/4 v1, 0x0

    .line 41
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->isStop:Z

    .line 42
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public stopRead()V
    .locals 2

    .line 50
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->thread:Ljava/lang/Thread;

    if-eqz v0, :cond_0

    const-string v0, "TAG_AsyncPacketReader"

    const-string/jumbo v1, "stop read"

    .line 51
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x1

    .line 52
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->isStop:Z

    .line 53
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->thread:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    const/4 v0, 0x0

    .line 54
    iput-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->thread:Ljava/lang/Thread;

    :cond_0
    return-void
.end method
