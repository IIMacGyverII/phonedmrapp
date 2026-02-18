.class public Lcom/pri/prizeinterphone/message/MixCheckMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "MixCheckMessage.java"


# instance fields
.field public cc:B

.field public channelMode:B

.field public contactType:B

.field public encryptKey:[B

.field public encryptSw:B

.field public groupList:[I

.field public inboundSlot:B

.field public localID:I

.field public mic:B

.field public outboundSlot:B

.field public power:B

.field public pwrSave:B

.field public relay:B

.field public rxDly:B

.field public rxFreq:I

.field public rxSubCode:B

.field public rxType:B

.field public sq:B

.field public txContact:I

.field public txFreq:I

.field public txSubCode:B

.field public txType:B

.field public volume:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 59
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, 0x38

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const v0, 0x17e727e8

    .line 34
    iput v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->rxFreq:I

    .line 35
    iput v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->txFreq:I

    const/4 v0, 0x1

    .line 36
    iput v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->localID:I

    const/16 v0, 0x20

    new-array v0, v0, [I

    .line 37
    iput-object v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->groupList:[I

    const/4 v0, 0x2

    .line 45
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->encryptSw:B

    const/16 v1, 0x8

    new-array v1, v1, [B

    .line 46
    iput-object v1, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->encryptKey:[B

    .line 47
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->pwrSave:B

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 1

    .line 63
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const p1, 0x17e727e8

    .line 34
    iput p1, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->rxFreq:I

    .line 35
    iput p1, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->txFreq:I

    const/4 p1, 0x1

    .line 36
    iput p1, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->localID:I

    const/16 p1, 0x20

    new-array p1, p1, [I

    .line 37
    iput-object p1, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->groupList:[I

    const/4 p1, 0x2

    .line 45
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->encryptSw:B

    const/16 v0, 0x8

    new-array v0, v0, [B

    .line 46
    iput-object v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->encryptKey:[B

    .line 47
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->pwrSave:B

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 0

    return-void
.end method

.method protected encodeBody()[B
    .locals 6

    const/16 v0, 0x400

    .line 73
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v1

    .line 74
    iget v2, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->rxFreq:I

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 75
    iget v2, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->txFreq:I

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 76
    iget v2, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->localID:I

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 77
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 78
    iget-object v2, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->groupList:[I

    array-length v3, v2

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v3, :cond_0

    aget v5, v2, v4

    .line 79
    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 81
    :cond_0
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 82
    iget v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->txContact:I

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 83
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->contactType:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 84
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->power:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 85
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->cc:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 86
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->inboundSlot:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 87
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->outboundSlot:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 88
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->channelMode:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 89
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->encryptSw:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 90
    iget-object v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->encryptKey:[B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 91
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->pwrSave:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 92
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->volume:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 93
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->mic:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 94
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->relay:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 95
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->sq:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 96
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->rxType:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 97
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->rxSubCode:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 98
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->txType:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 99
    iget-byte v0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->txSubCode:B

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 100
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/MixCheckMessage;->rxDly:B

    invoke-virtual {v1, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 101
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method
