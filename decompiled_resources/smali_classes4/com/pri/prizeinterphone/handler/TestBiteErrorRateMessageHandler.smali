.class public Lcom/pri/prizeinterphone/handler/TestBiteErrorRateMessageHandler;
.super Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.source "TestBiteErrorRateMessageHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseMessageHandler<",
        "Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;",
        ">;"
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "TestBiteErrorRateMessageHandler"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .locals 0

    .line 10
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/TestBiteErrorRateMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;

    move-result-object p0

    return-object p0
.end method

.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;
    .locals 0

    .line 15
    new-instance p0, Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/message/Message;)V
    .locals 0

    .line 10
    check-cast p1, Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/TestBiteErrorRateMessageHandler;->handle(Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;)V

    return-void
.end method

.method public handle(Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;)V
    .locals 1

    const-string p0, "TestBiteErrorRateMessageHandler"

    const-string v0, "handle"

    .line 20
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 21
    iget-object p0, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    if-eqz p0, :cond_0

    .line 22
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    const/16 v0, 0x3f

    invoke-virtual {p0, v0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->dealEvent(BLcom/pri/prizeinterphone/message/BaseMessage;)V

    :cond_0
    return-void
.end method
