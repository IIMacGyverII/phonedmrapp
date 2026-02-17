.class public Lcom/pri/prizeinterphone/message/SendSmsMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "SendSmsMessage.java"


# static fields
.field public static final MSGTYPE_ALL:B = 0x2t

.field public static final MSGTYPE_GROUP:B = 0x3t

.field public static final MSGTYPE_SINGLE:B = 0x1t

.field public static final TAG:Ljava/lang/String; = "SendSmsMessage"


# instance fields
.field public callGroupNumber:I

.field public callNumber:I

.field public content:[B

.field public msgContent:Ljava/lang/String;

.field public msgType:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 27
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, 0x2c

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 v0, 0x1

    .line 20
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgType:B

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 31
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 p1, 0x1

    .line 20
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgType:B

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 0

    return-void
.end method

.method protected encodeBody()[B
    .locals 3

    const/16 v0, 0x400

    .line 79
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 80
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgType:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 81
    iget v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callNumber:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 82
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "encodeBody: callNumber "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callNumber:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "SendSmsMessage"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 83
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgType:B

    const/4 v2, 0x3

    if-ne v1, v2, :cond_0

    .line 84
    iget v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callGroupNumber:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 86
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgContent:Ljava/lang/String;

    sget-object v1, Ljava/nio/charset/StandardCharsets;->UTF_16LE:Ljava/nio/charset/Charset;

    invoke-virtual {p0, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 87
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method

.method public getCallGroupNumber()I
    .locals 0

    .line 64
    iget p0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callGroupNumber:I

    return p0
.end method

.method public getCallNumber()I
    .locals 0

    .line 48
    iget p0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callNumber:I

    return p0
.end method

.method public getContent()[B
    .locals 0

    .line 70
    iget-object p0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->content:[B

    return-object p0
.end method

.method public getMsgContent()Ljava/lang/String;
    .locals 0

    .line 56
    iget-object p0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgContent:Ljava/lang/String;

    return-object p0
.end method

.method public getMsgType()B
    .locals 0

    .line 40
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgType:B

    return p0
.end method

.method public setCallGroupNumber(I)V
    .locals 0

    .line 67
    iput p1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callGroupNumber:I

    return-void
.end method

.method public setCallNumber(I)V
    .locals 0

    .line 52
    iput p1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callNumber:I

    return-void
.end method

.method public setContent([B)V
    .locals 0

    .line 74
    iput-object p1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->content:[B

    return-void
.end method

.method public setMsgContent(Ljava/lang/String;)V
    .locals 0

    .line 60
    iput-object p1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgContent:Ljava/lang/String;

    return-void
.end method

.method public setMsgType(B)V
    .locals 0

    .line 44
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgType:B

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 91
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SendSmsMessage{msgType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgType:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", callNumber="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callNumber:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", callGroupNumber="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->callGroupNumber:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", msgContent=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->msgContent:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, ", content="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/message/SendSmsMessage;->content:[B

    .line 96
    invoke-static {p0}, Ljava/util/Arrays;->toString([B)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
