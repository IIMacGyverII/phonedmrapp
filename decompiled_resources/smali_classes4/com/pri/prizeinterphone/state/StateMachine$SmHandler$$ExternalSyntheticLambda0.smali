.class public final synthetic Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;


# direct methods
.method public synthetic constructor <init>(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$$ExternalSyntheticLambda0;->f$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$$ExternalSyntheticLambda0;->f$0:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

    check-cast p1, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->$r8$lambda$5uQ_x1MYEtKM-sxzeJor173Kwqk(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;)Z

    move-result p0

    return p0
.end method
