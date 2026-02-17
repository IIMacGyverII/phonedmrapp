.class public Lcom/pri/prizeinterphone/state/StateMachine;
.super Ljava/lang/Object;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;,
        Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;,
        Lcom/pri/prizeinterphone/state/StateMachine$LogRec;
    }
.end annotation


# static fields
.field public static final HANDLED:Z = true

.field public static final NOT_HANDLED:Z = false

.field private static final SM_INIT_CMD:I = -0x2

.field private static final SM_QUIT_CMD:I = -0x1


# instance fields
.field private mName:Ljava/lang/String;

.field private mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

.field private mSmThread:Landroid/os/HandlerThread;


# direct methods
.method static bridge synthetic -$$Nest$fgetmName(Lcom/pri/prizeinterphone/state/StateMachine;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSmThread(Lcom/pri/prizeinterphone/state/StateMachine;)Landroid/os/HandlerThread;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmSmHandler(Lcom/pri/prizeinterphone/state/StateMachine;Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmSmThread(Lcom/pri/prizeinterphone/state/StateMachine;Landroid/os/HandlerThread;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;)V
    .locals 1

    .line 1310
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1311
    new-instance v0, Landroid/os/HandlerThread;

    invoke-direct {v0, p1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    .line 1312
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 1313
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    .line 1315
    invoke-direct {p0, p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;Landroid/os/Handler;)V
    .locals 0

    .line 1332
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1333
    invoke-virtual {p2}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object p2

    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;Landroid/os/Looper;)V
    .locals 0

    .line 1323
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1324
    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V

    return-void
.end method

.method private initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V
    .locals 1

    .line 1301
    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    .line 1302
    new-instance p1, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    const/4 v0, 0x0

    invoke-direct {p1, p2, p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;-><init>(Landroid/os/Looper;Lcom/pri/prizeinterphone/state/StateMachine;Lcom/pri/prizeinterphone/state/StateMachine$SmHandler-IA;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    return-void
.end method


# virtual methods
.method public addLogRec(Ljava/lang/String;)V
    .locals 8

    .line 1567
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1569
    :cond_0
    invoke-static {v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object v1

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mgetCurrentMessage(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Landroid/os/Message;

    move-result-object v3

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mgetCurrentState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/IState;

    move-result-object v5

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmStateStack(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)[Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

    move-result-object v2

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmStateStackTopIndex(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)I

    move-result v4

    aget-object v2, v2, v4

    iget-object v6, v2, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;->state:Lcom/pri/prizeinterphone/state/State;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmDestState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/State;

    move-result-object v7

    move-object v2, p0

    move-object v4, p1

    invoke-virtual/range {v1 .. v7}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->add(Lcom/pri/prizeinterphone/state/StateMachine;Landroid/os/Message;Ljava/lang/String;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;Lcom/pri/prizeinterphone/state/IState;)V

    return-void
.end method

.method public final addState(Lcom/pri/prizeinterphone/state/State;)V
    .locals 1

    .line 1365
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$maddState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

    return-void
.end method

.method public final addState(Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)V
    .locals 0

    .line 1357
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$maddState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/State;Lcom/pri/prizeinterphone/state/State;)Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$StateInfo;

    return-void
.end method

.method public final copyLogRecs()Ljava/util/Collection;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Collection<",
            "Lcom/pri/prizeinterphone/state/StateMachine$LogRec;",
            ">;"
        }
    .end annotation

    .line 1550
    new-instance v0, Ljava/util/Vector;

    invoke-direct {v0}, Ljava/util/Vector;-><init>()V

    .line 1551
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-eqz p0, :cond_0

    .line 1553
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object p0

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->-$$Nest$fgetmLogRecVector(Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;)Ljava/util/Vector;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/Vector;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/state/StateMachine$LogRec;

    .line 1554
    invoke-virtual {v0, v1}, Ljava/util/Vector;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public final deferMessage(Landroid/os/Message;)V
    .locals 0

    .line 1445
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mdeferMessage(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Landroid/os/Message;)V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 1

    .line 2090
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->getName()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p3, ":"

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 2091
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " total records="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->getLogRecCount()I

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 2092
    :goto_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->getLogRecSize()I

    move-result p3

    if-ge p1, p3, :cond_0

    .line 2093
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " rec["

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "]: "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->getLogRec(I)Lcom/pri/prizeinterphone/state/StateMachine$LogRec;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 2094
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 2096
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine;->getCurrentState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object p0

    .line 2097
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "curState="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez p0, :cond_1

    const-string p0, "<QUIT>"

    goto :goto_1

    :cond_1
    invoke-interface {p0}, Lcom/pri/prizeinterphone/state/IState;->getName()Ljava/lang/String;

    move-result-object p0

    :goto_1
    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    return-void
.end method

.method public final getCurrentMessage()Landroid/os/Message;
    .locals 0

    .line 1391
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1393
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mgetCurrentMessage(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final getCurrentState()Lcom/pri/prizeinterphone/state/IState;
    .locals 0

    .line 1401
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1403
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mgetCurrentState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/IState;

    move-result-object p0

    return-object p0
.end method

.method public final getHandler()Landroid/os/Handler;
    .locals 0

    .line 1602
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    return-object p0
.end method

.method public final getLogRec(I)Lcom/pri/prizeinterphone/state/StateMachine$LogRec;
    .locals 0

    .line 1541
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1543
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->get(I)Lcom/pri/prizeinterphone/state/StateMachine$LogRec;

    move-result-object p0

    return-object p0
.end method

.method public final getLogRecCount()I
    .locals 0

    .line 1531
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1533
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->count()I

    move-result p0

    return p0
.end method

.method public final getLogRecMaxSize()I
    .locals 0

    .line 1521
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1523
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object p0

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->-$$Nest$fgetmMaxSize(Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;)I

    move-result p0

    return p0
.end method

.method public final getLogRecSize()I
    .locals 0

    .line 1511
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1513
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->size()I

    move-result p0

    return p0
.end method

.method protected getLogRecString(Landroid/os/Message;)Ljava/lang/String;
    .locals 0

    const-string p0, ""

    return-object p0
.end method

.method public final getName()Ljava/lang/String;
    .locals 0

    .line 1485
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    return-object p0
.end method

.method protected getWhatToString(I)Ljava/lang/String;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method protected haltedProcessMessage(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public final hasDeferredMessages(I)Z
    .locals 2

    .line 1978
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 1981
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmDeferredMessages(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    .line 1982
    :cond_1
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 1983
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/Message;

    .line 1984
    iget v1, v1, Landroid/os/Message;->what:I

    if-ne v1, p1, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_2
    return v0
.end method

.method public final hasMessages(I)Z
    .locals 0

    .line 1995
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1998
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p0

    return p0
.end method

.method public isDbg()Z
    .locals 0

    .line 2040
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 2043
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$misDbg(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Z

    move-result p0

    return p0
.end method

.method protected final isQuit(Landroid/os/Message;)Z
    .locals 0

    .line 2007
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_1

    .line 2008
    iget p0, p1, Landroid/os/Message;->what:I

    const/4 p1, -0x1

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0

    .line 2010
    :cond_1
    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$misQuit(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Landroid/os/Message;)Z

    move-result p0

    return p0
.end method

.method public isStart()Z
    .locals 0

    .line 2076
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-eqz p0, :cond_0

    .line 2077
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$misStart(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Z

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method protected log(Ljava/lang/String;)V
    .locals 0

    .line 2129
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logAndAddLogRec(Ljava/lang/String;)V
    .locals 0

    .line 2119
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->addLogRec(Ljava/lang/String;)V

    .line 2120
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logd(Ljava/lang/String;)V
    .locals 0

    .line 2138
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 0

    .line 2174
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 0

    .line 2184
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1, p2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method protected logi(Ljava/lang/String;)V
    .locals 0

    .line 2156
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logv(Ljava/lang/String;)V
    .locals 0

    .line 2147
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logw(Ljava/lang/String;)V
    .locals 0

    .line 2165
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public final obtainMessage()Landroid/os/Message;
    .locals 0

    .line 1616
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0}, Landroid/os/Message;->obtain(Landroid/os/Handler;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(I)Landroid/os/Message;
    .locals 0

    .line 1631
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1}, Landroid/os/Message;->obtain(Landroid/os/Handler;I)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(II)Landroid/os/Message;
    .locals 1

    .line 1666
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    const/4 v0, 0x0

    invoke-static {p0, p1, p2, v0}, Landroid/os/Message;->obtain(Landroid/os/Handler;III)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(III)Landroid/os/Message;
    .locals 0

    .line 1684
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1, p2, p3}, Landroid/os/Message;->obtain(Landroid/os/Handler;III)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;
    .locals 0

    .line 1703
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1, p2, p3, p4}, Landroid/os/Message;->obtain(Landroid/os/Handler;IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(ILjava/lang/Object;)Landroid/os/Message;
    .locals 0

    .line 1648
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1, p2}, Landroid/os/Message;->obtain(Landroid/os/Handler;ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method protected onHalting()V
    .locals 0

    return-void
.end method

.method protected onPostHandleMessage(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method protected onPreHandleMessage(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method protected onQuitting()V
    .locals 0

    return-void
.end method

.method public final quit()V
    .locals 0

    .line 2018
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2021
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mquit(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V

    return-void
.end method

.method public final quitNow()V
    .locals 0

    .line 2029
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2032
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mquitNow(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V

    return-void
.end method

.method protected recordLogRec(Landroid/os/Message;)Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public final removeDeferredMessages(I)V
    .locals 1

    .line 1964
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1967
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmDeferredMessages(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    .line 1968
    :cond_1
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1969
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 1970
    iget v0, v0, Landroid/os/Message;->what:I

    if-ne v0, p1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    :cond_2
    return-void
.end method

.method public final removeMessages(I)V
    .locals 0

    .line 1954
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1957
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeMessages(I)V

    return-void
.end method

.method public final removeState(Lcom/pri/prizeinterphone/state/State;)V
    .locals 0

    .line 1373
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mremoveState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/State;)V

    return-void
.end method

.method public sendMessage(I)V
    .locals 1

    .line 1713
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1716
    :cond_0
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(II)V
    .locals 1

    .line 1739
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1742
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(III)V
    .locals 1

    .line 1752
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1755
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(IIILjava/lang/Object;)V
    .locals 1

    .line 1765
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1768
    :cond_0
    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(ILjava/lang/Object;)V
    .locals 1

    .line 1726
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1729
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(Landroid/os/Message;)V
    .locals 0

    .line 1778
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1781
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public final sendMessageAtFrontOfQueue(I)V
    .locals 1

    .line 1871
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1874
    :cond_0
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(II)V
    .locals 1

    .line 1899
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1902
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(III)V
    .locals 1

    .line 1914
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1917
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(IIILjava/lang/Object;)V
    .locals 1

    .line 1928
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1931
    :cond_0
    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(ILjava/lang/Object;)V
    .locals 1

    .line 1885
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1888
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(Landroid/os/Message;)V
    .locals 0

    .line 1942
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1945
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessageDelayed(IIIJ)V
    .locals 1

    .line 1830
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1833
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p4, p5}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(IIILjava/lang/Object;J)V
    .locals 1

    .line 1844
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1847
    :cond_0
    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p5, p6}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(IIJ)V
    .locals 1

    .line 1817
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1820
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p3, p4}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(IJ)V
    .locals 1

    .line 1791
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1794
    :cond_0
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p2, p3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(ILjava/lang/Object;J)V
    .locals 1

    .line 1804
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1807
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p3, p4}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(Landroid/os/Message;J)V
    .locals 0

    .line 1857
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1860
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public setDbg(Z)V
    .locals 0

    .line 2053
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2056
    :cond_0
    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$msetDbg(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Z)V

    return-void
.end method

.method public final setInitialState(Lcom/pri/prizeinterphone/state/State;)V
    .locals 0

    .line 1383
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$msetInitialState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/State;)V

    return-void
.end method

.method public final setLogOnlyTransitions(Z)V
    .locals 0

    .line 1503
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->setLogOnlyTransitions(Z)V

    return-void
.end method

.method public final setLogRecSize(I)V
    .locals 0

    .line 1494
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$LogRecords;->setSize(I)V

    return-void
.end method

.method public start()V
    .locals 0

    .line 2064
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2068
    :cond_0
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mcompleteConstruction(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)V

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    const-string v0, "(null)"

    .line 2105
    :try_start_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mName:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->toString()Ljava/lang/String;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0

    .line 2106
    :try_start_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mgetCurrentState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/IState;

    move-result-object p0

    invoke-interface {p0}, Lcom/pri/prizeinterphone/state/IState;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/NullPointerException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_0
    move-object v1, v0

    .line 2110
    :catch_1
    :goto_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "name="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " state="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public final transitionTo(Lcom/pri/prizeinterphone/state/IState;)V
    .locals 0

    .line 1421
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mtransitionTo(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/IState;)V

    return-void
.end method

.method public final transitionToHaltingState()V
    .locals 1

    .line 1432
    iget-object p0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmHaltingState(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Lcom/pri/prizeinterphone/state/StateMachine$SmHandler$HaltingState;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$mtransitionTo(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;Lcom/pri/prizeinterphone/state/IState;)V

    return-void
.end method

.method protected unhandledMessage(Landroid/os/Message;)V
    .locals 2

    .line 1454
    iget-object v0, p0, Lcom/pri/prizeinterphone/state/StateMachine;->mSmHandler:Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;

    invoke-static {v0}, Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;->-$$Nest$fgetmDbg(Lcom/pri/prizeinterphone/state/StateMachine$SmHandler;)Z

    move-result v0

    if-eqz v0, :cond_0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " - unhandledMessage: msg.what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->loge(Ljava/lang/String;)V

    :cond_0
    return-void
.end method
