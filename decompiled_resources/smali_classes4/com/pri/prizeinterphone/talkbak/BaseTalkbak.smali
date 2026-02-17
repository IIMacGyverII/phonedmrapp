.class public abstract Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;
.super Ljava/lang/Object;
.source "BaseTalkbak.java"

# interfaces
.implements Lcom/pri/prizeinterphone/talkbak/Talkbak;


# instance fields
.field public final packet:Lcom/pri/prizeinterphone/protocol/Packet;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 12
    iput-object p1, p0, Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    return-void
.end method


# virtual methods
.method public decode()V
    .locals 2

    .line 24
    iget-object v0, p0, Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-object v0, v0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    if-eqz v0, :cond_0

    array-length v1, v0

    if-lez v1, :cond_0

    .line 25
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;->decodeBody([B)V

    :cond_0
    return-void
.end method

.method protected abstract decodeBody([B)V
.end method

.method public encode()V
    .locals 2

    .line 17
    iget-object v0, p0, Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    const/4 v1, 0x1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    .line 18
    iput-byte v1, v0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    .line 19
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;->encodeBody()[B

    move-result-object p0

    iput-object p0, v0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    return-void
.end method

.method protected abstract encodeBody()[B
.end method

.method public send()V
    .locals 1

    .line 31
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;->encode()V

    .line 32
    invoke-static {}, Lcom/pri/prizeinterphone/serial/SerialManager;->getInstance()Lcom/pri/prizeinterphone/serial/SerialManager;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/talkbak/BaseTalkbak;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/serial/SerialManager;->send(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method
