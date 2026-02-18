.class public Lcom/pri/prizeinterphone/handler/EnhanceMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "EnhanceMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/EnhanceMessage;",
        ">;"
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "EnhanceMessageHandler"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/EnhanceMessage;
    .locals 0

    .line 17
    new-instance p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/EnhanceMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 12
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/EnhanceMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/EnhanceMessage;

    move-result-object p0

    return-object p0
.end method

.method public handle(Lcom/pri/prizeinterphone/message/EnhanceMessage;)V
    .locals 2

    .line 22
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handle,message.fun="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v0, p1, Lcom/pri/prizeinterphone/message/EnhanceMessage;->fun:B

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ",message.packet.sr="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v0, v0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "EnhanceMessageHandler"

    invoke-static {v0, p0}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 23
    iget-byte p0, p1, Lcom/pri/prizeinterphone/message/EnhanceMessage;->fun:B

    const/4 v0, 0x4

    const-string v1, "pref_person_is_already_kill"

    if-eq p0, v0, :cond_1

    const/4 v0, 0x5

    if-eq p0, v0, :cond_0

    goto :goto_0

    .line 28
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const/4 v0, 0x0

    invoke-static {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    goto :goto_0

    .line 25
    :cond_1
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const/4 v0, 0x1

    invoke-static {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    .line 34
    :goto_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    const/16 v0, 0x28

    invoke-virtual {p0, v0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->dealEvent(BLcom/pri/prizeinterphone/message/BaseMessage;)V

    return-void
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 12
    check-cast p1, Lcom/pri/prizeinterphone/message/EnhanceMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/EnhanceMessageHandler;->handle(Lcom/pri/prizeinterphone/message/EnhanceMessage;)V

    return-void
.end method
