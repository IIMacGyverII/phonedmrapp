.class public Lcom/pri/prizeinterphone/message/InitMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "InitMessage.java"


# instance fields
.field public final data:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 13
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, -0x56

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 v0, 0x1

    .line 10
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/InitMessage;->data:B

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 17
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 p1, 0x1

    .line 10
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/InitMessage;->data:B

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 0

    return-void
.end method

.method protected encodeBody()[B
    .locals 1

    const/16 p0, 0x400

    .line 27
    invoke-static {p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object p0

    const/4 v0, 0x1

    .line 28
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 29
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method

.method public toString()Ljava/lang/String;
    .locals 0

    const-string p0, "InitMessage{init=1}"

    return-object p0
.end method
