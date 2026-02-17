.class public abstract Lcom/pri/prizeinterphone/handler/BaseMessageHandler;
.super Ljava/lang/Object;
.source "BaseMessageHandler.java"

# interfaces
.implements Lcom/pri/prizeinterphone/handler/MessageHandler;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T::",
        "Lcom/pri/prizeinterphone/message/Message;",
        ">",
        "Ljava/lang/Object;",
        "Lcom/pri/prizeinterphone/handler/MessageHandler;"
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
.method public abstract decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/pri/prizeinterphone/protocol/Packet;",
            ")TT;"
        }
    .end annotation
.end method

.method public abstract handle(Lcom/pri/prizeinterphone/message/Message;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TT;)V"
        }
    .end annotation
.end method

.method public handle(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 17
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;->decode(Lcom/pri/prizeinterphone/protocol/Packet;)Lcom/pri/prizeinterphone/message/Message;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 19
    invoke-interface {p1}, Lcom/pri/prizeinterphone/message/Message;->decode()V

    .line 20
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/handler/BaseMessageHandler;->handle(Lcom/pri/prizeinterphone/message/Message;)V

    :cond_0
    return-void
.end method
