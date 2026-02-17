.class Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$HaltingState;
.super Lcom/pri/prizeinterphone/state/State;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "HaltingState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;


# direct methods
.method private constructor <init>(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V
    .locals 0

    .line 768
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$HaltingState;->this$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/state/State;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$HaltingState-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$HaltingState;-><init>(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V

    return-void
.end method


# virtual methods
.method public processMessage(Landroid/os/Message;)Z
    .locals 0

    .line 771
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$HaltingState;->this$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmSm(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->haltedProcessMessage(Landroid/os/Message;)V

    const/4 p0, 0x1

    return p0
.end method
