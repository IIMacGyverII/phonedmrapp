.class public final synthetic Lcom/pri/prizeinterphone/serial/MessageDispatcher$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/pri/prizeinterphone/handler/MessageHandler;

.field public final synthetic f$1:Lcom/pri/prizeinterphone/protocol/Packet;


# direct methods
.method public synthetic constructor <init>(Lcom/pri/prizeinterphone/handler/MessageHandler;Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher$$ExternalSyntheticLambda0;->f$0:Lcom/pri/prizeinterphone/handler/MessageHandler;

    iput-object p2, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher$$ExternalSyntheticLambda0;->f$1:Lcom/pri/prizeinterphone/protocol/Packet;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher$$ExternalSyntheticLambda0;->f$0:Lcom/pri/prizeinterphone/handler/MessageHandler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher$$ExternalSyntheticLambda0;->f$1:Lcom/pri/prizeinterphone/protocol/Packet;

    invoke-static {v0, p0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->$r8$lambda$wSLWPLuOQNvoOsmQmJJqwCRxj9U(Lcom/pri/prizeinterphone/handler/MessageHandler;Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method
