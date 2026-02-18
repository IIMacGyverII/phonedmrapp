.class public Lcom/pri/prizeinterphone/handler/SendTalkbakHandler;
.super Lcom/pri/prizeinterphone/handler/BaseTalkbakHandler;
.source "SendTalkbakHandler.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/prizeinterphone/handler/BaseTalkbakHandler<",
        "Lcom/pri/prizeinterphone/talkbak/SendTalkbak;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Lcom/pri/prizeinterphone/handler/BaseTalkbakHandler;-><init>()V

    return-void
.end method


# virtual methods
.method public decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/talkbak/SendTalkbak;
    .locals 0

    .line 11
    new-instance p0, Lcom/pri/prizeinterphone/talkbak/SendTalkbak;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/talkbak/SendTalkbak;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-object p0
.end method

.method public bridge synthetic decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/talkbak/Talkbak;
    .locals 0

    .line 7
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/SendTalkbakHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/talkbak/SendTalkbak;

    move-result-object p0

    return-object p0
.end method

.method public handle(Lcom/pri/prizeinterphone/talkbak/SendTalkbak;)V
    .locals 0

    return-void
.end method

.method public bridge synthetic handle(Lcom/pri/prizeinterphone/talkbak/Talkbak;)V
    .locals 0

    .line 7
    check-cast p1, Lcom/pri/prizeinterphone/talkbak/SendTalkbak;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/SendTalkbakHandler;->handle(Lcom/pri/prizeinterphone/talkbak/SendTalkbak;)V

    return-void
.end method
