.class Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;
.super Lcom/pri/prizeinterphone/state/State;
.source "CmdStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/CmdStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "NoDealState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/CmdStateMachine;)V
    .locals 0

    .line 219
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/CmdStateMachine$NoDealState;->this$0:Lcom/pri/prizeinterphone/state/CmdStateMachine;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    return-void
.end method


# virtual methods
.method public enter()V
    .locals 1

    const-string p0, "CmdStateMachine"

    const-string v0, "############ enter NoDealState ############"

    .line 222
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public exit()V
    .locals 1

    const-string p0, "CmdStateMachine"

    const-string v0, "############ exit NoDealState ############"

    .line 227
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public processMessage(Landroid/os/Message;)Z
    .locals 0

    .line 232
    iget p0, p1, Landroid/os/Message;->what:I

    const/4 p0, 0x1

    return p0
.end method
