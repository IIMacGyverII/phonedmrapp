.class public Lcom/pri/prizeinterphone/message/AnalogMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "AnalogMessage.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "AnalogMessage"


# instance fields
.field public band:B

.field public monitor:B

.field public power:B

.field public pwrSave:B

.field public relay:B

.field public rxFreq:I

.field public rxSubCode:B

.field public rxType:B

.field public sq:B

.field public txFreq:I

.field public txSubCode:B

.field public txType:B

.field public volume:B


# direct methods
.method public constructor <init>()V
    .locals 1

    const/16 v0, 0x23

    .line 47
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;-><init>(B)V

    return-void
.end method

.method public constructor <init>(B)V
    .locals 1
    .param p1    # B
        .annotation build Lcom/pri/prizeinterphone/protocol/Const$AnalogCmdType;
        .end annotation
    .end param

    .line 50
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    invoke-direct {v0, p1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const p1, 0x3d310a

    .line 32
    iput p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxFreq:I

    .line 33
    iput p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txFreq:I

    const/4 p1, 0x1

    .line 34
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->band:B

    const/4 p1, 0x2

    .line 36
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->sq:B

    .line 41
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->pwrSave:B

    const/16 v0, 0x8

    .line 42
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->volume:B

    .line 43
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->monitor:B

    .line 44
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->relay:B

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 1

    .line 54
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const p1, 0x3d310a

    .line 32
    iput p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxFreq:I

    .line 33
    iput p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txFreq:I

    const/4 p1, 0x1

    .line 34
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->band:B

    const/4 p1, 0x2

    .line 36
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->sq:B

    .line 41
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->pwrSave:B

    const/16 v0, 0x8

    .line 42
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->volume:B

    .line 43
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->monitor:B

    .line 44
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->relay:B

    return-void
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 0

    return-void
.end method

.method protected encodeBody()[B
    .locals 2

    const/16 v0, 0x13

    .line 65
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 66
    iget v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxFreq:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 67
    iget v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txFreq:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 68
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->band:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 69
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->power:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 70
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->sq:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 71
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxType:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 72
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxSubCode:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 73
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txType:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 74
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txSubCode:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 75
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->pwrSave:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 76
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->volume:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 77
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->monitor:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 78
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->relay:B

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 79
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method

.method public getBand()B
    .locals 0

    .line 118
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->band:B

    return p0
.end method

.method public getMonitor()B
    .locals 0

    .line 190
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->monitor:B

    return p0
.end method

.method public getPower()B
    .locals 0

    .line 126
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->power:B

    return p0
.end method

.method public getPwrSave()B
    .locals 0

    .line 174
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->pwrSave:B

    return p0
.end method

.method public getRelay()B
    .locals 0

    .line 198
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->relay:B

    return p0
.end method

.method public getRxFreq()I
    .locals 0

    .line 102
    iget p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxFreq:I

    return p0
.end method

.method public getRxSubCode()B
    .locals 0

    .line 150
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxSubCode:B

    return p0
.end method

.method public getRxType()B
    .locals 0

    .line 142
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxType:B

    return p0
.end method

.method public getSq()B
    .locals 0

    .line 134
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->sq:B

    return p0
.end method

.method public getTxFreq()I
    .locals 0

    .line 110
    iget p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txFreq:I

    return p0
.end method

.method public getTxSubCode()B
    .locals 0

    .line 166
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txSubCode:B

    return p0
.end method

.method public getTxType()B
    .locals 0

    .line 158
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txType:B

    return p0
.end method

.method public getVolume()B
    .locals 0

    .line 182
    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->volume:B

    return p0
.end method

.method public setBand(B)V
    .locals 0

    .line 122
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->band:B

    return-void
.end method

.method public setMonitor(B)V
    .locals 0

    .line 194
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->monitor:B

    return-void
.end method

.method public setPower(B)V
    .locals 0

    .line 130
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->power:B

    return-void
.end method

.method public setPwrSave(B)V
    .locals 0

    .line 178
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->pwrSave:B

    return-void
.end method

.method public setRelay(B)V
    .locals 0

    .line 202
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->relay:B

    return-void
.end method

.method public setRxFreq(I)V
    .locals 0

    .line 106
    iput p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxFreq:I

    return-void
.end method

.method public setRxSubCode(B)V
    .locals 0

    .line 154
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxSubCode:B

    return-void
.end method

.method public setRxType(B)V
    .locals 0

    .line 146
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxType:B

    return-void
.end method

.method public setSq(B)V
    .locals 0

    .line 138
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->sq:B

    return-void
.end method

.method public setTxFreq(I)V
    .locals 0

    .line 114
    iput p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txFreq:I

    return-void
.end method

.method public setTxSubCode(B)V
    .locals 0

    .line 170
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txSubCode:B

    return-void
.end method

.method public setTxType(B)V
    .locals 0

    .line 162
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txType:B

    return-void
.end method

.method public setVolume(B)V
    .locals 0

    .line 186
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->volume:B

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 84
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "AnalogMessage{rxFreq="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxFreq:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", txFreq="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txFreq:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", band="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->band:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", power="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->power:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", sq="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->sq:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rxType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxType:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rxSubCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->rxSubCode:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", txType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txType:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", txSubCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->txSubCode:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", pwrSave="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->pwrSave:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", volume="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->volume:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", monitor="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->monitor:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", relay="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte p0, p0, Lcom/pri/prizeinterphone/message/AnalogMessage;->relay:B

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
