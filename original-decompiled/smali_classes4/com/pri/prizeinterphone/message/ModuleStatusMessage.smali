.class public Lcom/pri/prizeinterphone/message/ModuleStatusMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "ModuleStatusMessage.java"


# instance fields
.field public status:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 18
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, 0x36

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 21
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 1

    .line 26
    invoke-static {p1}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object p1

    sget-object v0, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object p1

    .line 27
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result p1

    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;->status:B

    return-void
.end method

.method protected encodeBody()[B
    .locals 0

    const/4 p0, 0x0

    new-array p0, p0, [B

    return-object p0
.end method

.method public getStatus()B
    .locals 0

    .line 31
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;->status:B

    return p0
.end method

.method public setStatus(B)V
    .locals 0

    .line 35
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;->status:B

    return-void
.end method
