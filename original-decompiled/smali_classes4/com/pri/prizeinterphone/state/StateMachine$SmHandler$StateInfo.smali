.class Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;
.super Ljava/lang/Object;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "StateInfo"
.end annotation


# instance fields
.field active:Z

.field parentStateInfo:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

.field state:Lcom/pri/prizeinterphone/state/State;

.field final synthetic this$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;


# direct methods
.method private constructor <init>(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V
    .locals 0

    .line 725
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;->this$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;-><init>(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V

    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 2

    .line 740
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;->state:Lcom/pri/prizeinterphone/state/State;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/state/State;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ",active="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;->active:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",parent="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 741
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

    if-nez p0, :cond_0

    const-string p0, "null"

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;->state:Lcom/pri/prizeinterphone/state/State;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/State;->getName()Ljava/lang/String;

    move-result-object p0

    :goto_0
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
