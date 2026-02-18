.class public Lcom/pri/prizeinterphone/handler/ModuleStatusMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "ModuleStatusMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/ModuleStatusMessage;",
        ">;"
    }
.end annotation


# static fields
.field public static final TAG:Ljava/lang/String; = "TAG_ModuleStatusMessageHandler"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 16
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method

.method private sendAck()V
    .locals 3

    .line 36
    new-instance p0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v0, 0x36

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    const/4 v0, 0x1

    .line 37
    iput-byte v0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    .line 38
    iput-byte v0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    new-array v1, v0, [B

    const/4 v2, 0x0

    aput-byte v0, v1, v2

    .line 39
    iput-object v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    .line 40
    invoke-static {}, Lcom/pri/prizeinterphone/serial/SerialManager;->getInstance()Lcom/pri/prizeinterphone/serial/SerialManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/serial/SerialManager;->send(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method


# virtual methods
.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 16
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/ModuleStatusMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/ModuleStatusMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/ModuleStatusMessage;
    .locals 0

    .line 22
    new-instance p0, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 16
    check-cast p1, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/ModuleStatusMessageHandler;->handle(Lcom/pri/prizeinterphone/message/ModuleStatusMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/ModuleStatusMessage;)V
    .locals 2

    .line 27
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handle: sendAck(),message="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p1, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;->status:B

    invoke-static {v1}, Lcom/pri/prizeinterphone/protocol/Const;->moduleStatus2Str(B)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_ModuleStatusMessageHandler"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 28
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/ModuleStatusMessageHandler;->sendAck()V

    .line 29
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    iget-byte p1, p1, Lcom/pri/prizeinterphone/message/ModuleStatusMessage;->status:B

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->onModuleStatusReceived(B)V

    return-void
.end method
