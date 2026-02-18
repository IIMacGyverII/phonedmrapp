.class public abstract Lcom/pri/prizeinterphone/handler/BaseTalkbakHandler;
.super Ljava/lang/Object;
.source "BaseTalkbakHandler.java"

# interfaces
.implements Lcom/pri/prizeinterphone/handler/TalkbakHandler;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T::",
        "Lcom/pri/prizeinterphone/talkbak/Talkbak;",
        ">",
        "Ljava/lang/Object;",
        "Lcom/pri/prizeinterphone/handler/TalkbakHandler;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public abstract decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/talkbak/Talkbak;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/pri/prizeinterphone/protocol/Packet;",
            ")TT;"
        }
    .end annotation
.end method

.method public handle(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 2

    .line 16
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handle packet == "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "caoshaowei"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 17
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/BaseTalkbakHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/talkbak/Talkbak;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 19
    invoke-interface {p1}, Lcom/pri/prizeinterphone/talkbak/Talkbak;->decode()V

    .line 20
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/BaseTalkbakHandler;->handle(Lcom/pri/prizeinterphone/talkbak/Talkbak;)V

    :cond_0
    return-void
.end method

.method public abstract handle(Lcom/pri/prizeinterphone/talkbak/Talkbak;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TT;)V"
        }
    .end annotation
.end method
