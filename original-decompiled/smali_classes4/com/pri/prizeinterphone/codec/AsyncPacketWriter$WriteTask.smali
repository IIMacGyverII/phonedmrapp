.class Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;
.super Ljava/lang/Object;
.source "AsyncPacketWriter.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "WriteTask"
.end annotation


# instance fields
.field private final buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

.field private final packet:Lcom/pri/prizeinterphone/protocol/Packet;

.field final synthetic this$0:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 33
    iput-object p1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->this$0:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 34
    iput-object p2, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    .line 35
    invoke-virtual {p2}, Lcom/pri/prizeinterphone/protocol/Packet;->getBodyLength()I

    move-result p1

    add-int/lit8 p1, p1, 0x8

    invoke-static {p1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 40
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->clear()Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 41
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-object v1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/codec/PacketEncoder;->encode(Lcom/pri/prizeinterphone/protocol/Packet;Lcom/pri/prizeinterphone/Util/ByteBuf;)V

    .line 42
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->this$0:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    invoke-static {v0}, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;->-$$Nest$fgetserial(Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;)Lcom/pri/prizeinterphone/serial/port/SerialPort;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->isConnected()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 44
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->buffer:Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object v0

    const-string v1, "TAG_AsyncPacketReader"

    .line 45
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "write buffer == "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/Util;->bytesToHex([B)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 46
    iget-object p0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;->this$0:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    invoke-static {p0}, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;->-$$Nest$fgetserial(Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;)Lcom/pri/prizeinterphone/serial/port/SerialPort;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->getOutputStream()Ljava/io/FileOutputStream;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 48
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :cond_0
    :goto_0
    return-void
.end method
