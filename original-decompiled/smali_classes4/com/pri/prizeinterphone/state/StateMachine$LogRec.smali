.class public Lcom/pri/prizeinterphone/state/StateMachine$LogRec;
.super Ljava/lang/Object;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/state/StateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "LogRec"
.end annotation


# instance fields
.field private mDstState:Lcom/pri/prizeinterphone/state/IState;

.field private mInfo:Ljava/lang/String;

.field private mOrgState:Lcom/pri/prizeinterphone/state/IState;

.field private mSm:Lcom/pri/prizeinterphone/state/StateMachine;

.field private mState:Lcom/pri/prizeinterphone/state/IState;

.field private mTime:J

.field private mWhat:I


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/state/StateMachine;Landroid/os/Message;Ljava/lang/String;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;)V
    .locals 0

    .line 470
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 471
    invoke-virtual/range {p0 .. p6}, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->update(Lcom/pri/prizeinterphone/state/StateMachine;Landroid/os/Message;Ljava/lang/String;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;)V

    return-void
.end method


# virtual methods
.method public getDestState()Lcom/pri/prizeinterphone/state/IState;
    .locals 0

    .line 523
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mDstState:Lcom/pri/prizeinterphone/state/IState;

    return-object p0
.end method

.method public getInfo()Ljava/lang/String;
    .locals 0

    .line 509
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mInfo:Ljava/lang/String;

    return-object p0
.end method

.method public getOriginalState()Lcom/pri/prizeinterphone/state/IState;
    .locals 0

    .line 530
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mOrgState:Lcom/pri/prizeinterphone/state/IState;

    return-object p0
.end method

.method public getState()Lcom/pri/prizeinterphone/state/IState;
    .locals 0

    .line 516
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mState:Lcom/pri/prizeinterphone/state/IState;

    return-object p0
.end method

.method public getTime()J
    .locals 2

    .line 495
    iget-wide v0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mTime:J

    return-wide v0
.end method

.method public getWhat()J
    .locals 2

    .line 502
    iget p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mWhat:I

    int-to-long v0, p0

    return-wide v0
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    .line 535
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "time="

    .line 536
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 537
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v1

    .line 538
    iget-wide v2, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mTime:J

    invoke-virtual {v1, v2, v3}, Ljava/util/Calendar;->setTimeInMillis(J)V

    const/4 v2, 0x6

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object v1, v2, v3

    const/4 v3, 0x1

    aput-object v1, v2, v3

    const/4 v3, 0x2

    aput-object v1, v2, v3

    const/4 v3, 0x3

    aput-object v1, v2, v3

    const/4 v3, 0x4

    aput-object v1, v2, v3

    const/4 v3, 0x5

    aput-object v1, v2, v3

    const-string v1, "%tm-%td %tH:%tM:%tS.%tL"

    .line 539
    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " processed="

    .line 540
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 541
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mState:Lcom/pri/prizeinterphone/state/IState;

    const-string v2, "<null>"

    if-nez v1, :cond_0

    move-object v1, v2

    goto :goto_0

    :cond_0
    invoke-interface {v1}, Lcom/pri/prizeinterphone/state/IState;->getName()Ljava/lang/String;

    move-result-object v1

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " org="

    .line 542
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 543
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mOrgState:Lcom/pri/prizeinterphone/state/IState;

    if-nez v1, :cond_1

    move-object v1, v2

    goto :goto_1

    :cond_1
    invoke-interface {v1}, Lcom/pri/prizeinterphone/state/IState;->getName()Ljava/lang/String;

    move-result-object v1

    :goto_1
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " dest="

    .line 544
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 545
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mDstState:Lcom/pri/prizeinterphone/state/IState;

    if-nez v1, :cond_2

    goto :goto_2

    :cond_2
    invoke-interface {v1}, Lcom/pri/prizeinterphone/state/IState;->getName()Ljava/lang/String;

    move-result-object v2

    :goto_2
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " what="

    .line 546
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 547
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mSm:Lcom/pri/prizeinterphone/state/StateMachine;

    if-eqz v1, :cond_3

    iget v2, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mWhat:I

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/state/StateMachine;->getWhatToString(I)Ljava/lang/String;

    move-result-object v1

    goto :goto_3

    :cond_3
    const-string v1, ""

    .line 548
    :goto_3
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_4

    .line 549
    iget v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mWhat:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "(0x"

    .line 550
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 551
    iget v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mWhat:I

    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ")"

    .line 552
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_4

    .line 554
    :cond_4
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 556
    :goto_4
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mInfo:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_5

    const-string v1, " "

    .line 557
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 558
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mInfo:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 560
    :cond_5
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public update(Lcom/pri/prizeinterphone/state/StateMachine;Landroid/os/Message;Ljava/lang/String;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;)V
    .locals 2

    .line 482
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mSm:Lcom/pri/prizeinterphone/state/StateMachine;

    .line 483
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mTime:J

    if-eqz p2, :cond_0

    .line 484
    iget p1, p2, Landroid/os/Message;->what:I

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    iput p1, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mWhat:I

    .line 485
    iput-object p3, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mInfo:Ljava/lang/String;

    .line 486
    iput-object p4, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mState:Lcom/pri/prizeinterphone/state/IState;

    .line 487
    iput-object p5, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mOrgState:Lcom/pri/prizeinterphone/state/IState;

    .line 488
    iput-object p6, p0, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;->mDstState:Lcom/pri/prizeinterphone/state/IState;

    return-void
.end method
