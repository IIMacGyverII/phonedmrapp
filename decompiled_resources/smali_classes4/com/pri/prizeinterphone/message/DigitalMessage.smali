.class public Lcom/pri/prizeinterphone/message/DigitalMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "DigitalMessage.java"


# instance fields
.field public cc:B

.field public channelMode:B

.field public contactType:B

.field public encryptKey:[B

.field public encryptSw:B

.field public groupList:[I

.field public inboundSlot:B

.field public localId:I

.field public mic:B

.field public outboundSlot:B

.field public power:B

.field public pwrSave:B

.field public relay:B

.field public rxFreq:I

.field public txContact:I

.field public txFreq:I

.field public volume:B


# direct methods
.method public constructor <init>()V
    .locals 1

    const/16 v0, 0x22

    .line 55
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/DigitalMessage;-><init>(B)V

    return-void
.end method

.method public constructor <init>(B)V
    .locals 5
    .param p1    # B
        .annotation build Lcom/pri/prizeinterphone/protocol/Const$DigitalCmdType;
        .end annotation
    .end param

    .line 59
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    invoke-direct {v0, p1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const p1, 0x17e727e8

    .line 34
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->rxFreq:I

    .line 35
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txFreq:I

    const/4 p1, 0x1

    .line 36
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->localId:I

    const/16 v0, 0x20

    new-array v0, v0, [I

    .line 37
    iput-object v0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    .line 38
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txContact:I

    .line 39
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->contactType:B

    .line 40
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->power:B

    .line 41
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->cc:B

    const/4 v1, 0x0

    .line 42
    iput-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->inboundSlot:B

    .line 43
    iput-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->outboundSlot:B

    .line 44
    iput-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->channelMode:B

    const/4 v2, 0x2

    .line 45
    iput-byte v2, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptSw:B

    const/16 v3, 0x8

    new-array v4, v3, [B

    .line 46
    iput-object v4, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptKey:[B

    .line 47
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->pwrSave:B

    .line 48
    iput-byte v3, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->volume:B

    .line 50
    iput-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->mic:B

    .line 51
    iput-byte v2, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->relay:B

    .line 60
    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 61
    iget-object p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    aput p1, p0, v1

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 4

    .line 113
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const p1, 0x17e727e8

    .line 34
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->rxFreq:I

    .line 35
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txFreq:I

    const/4 p1, 0x1

    .line 36
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->localId:I

    const/16 v0, 0x20

    new-array v0, v0, [I

    .line 37
    iput-object v0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    .line 38
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txContact:I

    .line 39
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->contactType:B

    .line 40
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->power:B

    .line 41
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->cc:B

    const/4 v0, 0x0

    .line 42
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->inboundSlot:B

    .line 43
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->outboundSlot:B

    .line 44
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->channelMode:B

    const/4 v1, 0x2

    .line 45
    iput-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptSw:B

    const/16 v2, 0x8

    new-array v3, v2, [B

    .line 46
    iput-object v3, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptKey:[B

    .line 47
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->pwrSave:B

    .line 48
    iput-byte v2, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->volume:B

    .line 50
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->mic:B

    .line 51
    iput-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->relay:B

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 0

    return-void
.end method

.method protected encodeBody()[B
    .locals 6

    const/16 v0, 0xa3

    .line 124
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 125
    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->rxFreq:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 126
    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txFreq:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 127
    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->localId:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    const/16 v1, 0x80

    .line 128
    invoke-static {v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v1

    .line 129
    iget-object v2, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    array-length v3, v2

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v3, :cond_0

    aget v5, v2, v4

    .line 130
    invoke-virtual {v1, v5}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 132
    :cond_0
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 133
    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txContact:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 134
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->contactType:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 135
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->power:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 136
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->cc:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 137
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->inboundSlot:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 138
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->outboundSlot:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 139
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->channelMode:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 140
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptSw:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 141
    iget-object v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptKey:[B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 142
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->pwrSave:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 143
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->volume:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 144
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->mic:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 145
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->relay:B

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 146
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method

.method public getContactType()B
    .locals 0

    .line 105
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->contactType:B

    return p0
.end method

.method public getGroupList()[I
    .locals 0

    .line 89
    iget-object p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    return-object p0
.end method

.method public getLocalId()I
    .locals 0

    .line 81
    iget p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->localId:I

    return p0
.end method

.method public getRxFreq()I
    .locals 0

    .line 65
    iget p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->rxFreq:I

    return p0
.end method

.method public getTxContact()I
    .locals 0

    .line 97
    iget p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txContact:I

    return p0
.end method

.method public getTxFreq()I
    .locals 0

    .line 73
    iget p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txFreq:I

    return p0
.end method

.method public setContactType(B)V
    .locals 0

    .line 109
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->contactType:B

    return-void
.end method

.method public setGroupList([I)V
    .locals 0

    .line 93
    iput-object p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    return-void
.end method

.method public setLocalId(I)V
    .locals 0

    .line 85
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->localId:I

    return-void
.end method

.method public setRxFreq(I)V
    .locals 0

    .line 69
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->rxFreq:I

    return-void
.end method

.method public setTxContact(I)V
    .locals 0

    .line 101
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txContact:I

    return-void
.end method

.method public setTxFreq(I)V
    .locals 0

    .line 77
    iput p1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txFreq:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 151
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DigitalMessage{rxFreq="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->rxFreq:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", txFreq="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txFreq:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", localId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->localId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", groupList=["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    .line 155
    invoke-static {v1}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "], txContact="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txContact:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", contactType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->contactType:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", power="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->power:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", cc="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->cc:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", inboundSlot="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->inboundSlot:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", outboundSlot="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->outboundSlot:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", channelMode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->channelMode:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", encryptSw="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptSw:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", encryptKey="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptKey:[B

    .line 164
    invoke-static {v1}, Ljava/util/Arrays;->toString([B)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", pwrSave="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->pwrSave:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", volume="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->volume:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", mic="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->mic:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", relay="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/DigitalMessage;->relay:B

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
