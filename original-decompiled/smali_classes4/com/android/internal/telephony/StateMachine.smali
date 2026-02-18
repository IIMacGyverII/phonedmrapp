.class public Lcom/android/internal/telephony/StateMachine;
.super Ljava/lang/Object;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/StateMachine$SmHandler;,
        Lcom/android/internal/telephony/StateMachine$LogRecords;,
        Lcom/android/internal/telephony/StateMachine$LogRec;
    }
.end annotation


# static fields
.field public static final HANDLED:Z = true

.field public static final NOT_HANDLED:Z = false

.field private static final SM_INIT_CMD:I = -0x2

.field private static final SM_QUIT_CMD:I = -0x1


# instance fields
.field private mName:Ljava/lang/String;

.field private mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

.field private mSmThread:Landroid/os/HandlerThread;


# direct methods
.method static bridge synthetic -$$Nest$fgetmName(Lcom/android/internal/telephony/StateMachine;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSmThread(Lcom/android/internal/telephony/StateMachine;)Landroid/os/HandlerThread;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmSmHandler(Lcom/android/internal/telephony/StateMachine;Lcom/android/internal/telephony/StateMachine$SmHandler;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmSmThread(Lcom/android/internal/telephony/StateMachine;Landroid/os/HandlerThread;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;)V
    .locals 1

    .line 1305
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1306
    new-instance v0, Landroid/os/HandlerThread;

    invoke-direct {v0, p1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    .line 1307
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 1308
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmThread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    .line 1310
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/StateMachine;->initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;Landroid/os/Handler;)V
    .locals 0

    .line 1329
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1330
    invoke-virtual {p2}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object p2

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V

    return-void
.end method

.method protected constructor <init>(Ljava/lang/String;Landroid/os/Looper;)V
    .locals 0

    .line 1319
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1320
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V

    return-void
.end method

.method private initStateMachine(Ljava/lang/String;Landroid/os/Looper;)V
    .locals 1

    .line 1295
    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    .line 1296
    new-instance p1, Lcom/android/internal/telephony/StateMachine$SmHandler;

    const/4 v0, 0x0

    invoke-direct {p1, p2, p0, v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;-><init>(Landroid/os/Looper;Lcom/android/internal/telephony/StateMachine;Lcom/android/internal/telephony/StateMachine$SmHandler-IA;)V

    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    return-void
.end method


# virtual methods
.method public addLogRec(Ljava/lang/String;)V
    .locals 8

    .line 1568
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1570
    :cond_0
    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object v1

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mgetCurrentMessage(Lcom/android/internal/telephony/StateMachine$SmHandler;)Landroid/os/Message;

    move-result-object v3

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mgetCurrentState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/IState;

    move-result-object v5

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmStateStack(Lcom/android/internal/telephony/StateMachine$SmHandler;)[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    move-result-object v2

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmStateStackTopIndex(Lcom/android/internal/telephony/StateMachine$SmHandler;)I

    move-result v4

    aget-object v2, v2, v4

    iget-object v6, v2, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmDestState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/State;

    move-result-object v7

    move-object v2, p0

    move-object v4, p1

    invoke-virtual/range {v1 .. v7}, Lcom/android/internal/telephony/StateMachine$LogRecords;->add(Lcom/android/internal/telephony/StateMachine;Landroid/os/Message;Ljava/lang/String;Lcom/android/internal/telephony/IState;Lcom/android/internal/telephony/IState;Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method public final addState(Lcom/android/internal/telephony/State;)V
    .locals 1

    .line 1363
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$maddState(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    return-void
.end method

.method public final addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V
    .locals 0

    .line 1354
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$maddState(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    return-void
.end method

.method public final copyLogRecs()Ljava/util/Collection;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Collection<",
            "Lcom/android/internal/telephony/StateMachine$LogRec;",
            ">;"
        }
    .end annotation

    .line 1551
    new-instance v0, Ljava/util/Vector;

    invoke-direct {v0}, Ljava/util/Vector;-><init>()V

    .line 1552
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-eqz p0, :cond_0

    .line 1554
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$LogRecords;->-$$Nest$fgetmLogRecVector(Lcom/android/internal/telephony/StateMachine$LogRecords;)Ljava/util/Vector;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/Vector;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/StateMachine$LogRec;

    .line 1555
    invoke-virtual {v0, v1}, Ljava/util/Vector;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public final deferMessage(Landroid/os/Message;)V
    .locals 0

    .line 1445
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mdeferMessage(Lcom/android/internal/telephony/StateMachine$SmHandler;Landroid/os/Message;)V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 1

    .line 2089
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p3, ":"

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 2090
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " total records="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getLogRecCount()I

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 2091
    :goto_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getLogRecSize()I

    move-result p3

    if-ge p1, p3, :cond_0

    .line 2092
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " rec["

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "]: "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->getLogRec(I)Lcom/android/internal/telephony/StateMachine$LogRec;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 2093
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 2095
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p0

    .line 2096
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "curState="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez p0, :cond_1

    const-string p0, "<QUIT>"

    goto :goto_1

    :cond_1
    invoke-interface {p0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

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

    .line 1390
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1392
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mgetCurrentMessage(Lcom/android/internal/telephony/StateMachine$SmHandler;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final getCurrentState()Lcom/android/internal/telephony/IState;
    .locals 0

    .line 1400
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1402
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mgetCurrentState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/IState;

    move-result-object p0

    return-object p0
.end method

.method public final getHandler()Landroid/os/Handler;
    .locals 0

    .line 1603
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    return-object p0
.end method

.method public final getLogRec(I)Lcom/android/internal/telephony/StateMachine$LogRec;
    .locals 0

    .line 1542
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1544
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine$LogRecords;->get(I)Lcom/android/internal/telephony/StateMachine$LogRec;

    move-result-object p0

    return-object p0
.end method

.method public final getLogRecCount()I
    .locals 0

    .line 1532
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1534
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine$LogRecords;->count()I

    move-result p0

    return p0
.end method

.method public final getLogRecMaxSize()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 1522
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1524
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$LogRecords;->-$$Nest$fgetmMaxSize(Lcom/android/internal/telephony/StateMachine$LogRecords;)I

    move-result p0

    return p0
.end method

.method public final getLogRecSize()I
    .locals 0

    .line 1511
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1513
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine$LogRecords;->size()I

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
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

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

.method protected final hasDeferredMessages(I)Z
    .locals 2

    .line 1986
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 1989
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmDeferredMessages(Lcom/android/internal/telephony/StateMachine$SmHandler;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    .line 1990
    :cond_1
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 1991
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/Message;

    .line 1992
    iget v1, v1, Landroid/os/Message;->what:I

    if-ne v1, p1, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_2
    return v0
.end method

.method protected final hasMessages(I)Z
    .locals 0

    .line 2003
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 2006
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p0

    return p0
.end method

.method public isDbg()Z
    .locals 0

    .line 2048
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 2051
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$misDbg(Lcom/android/internal/telephony/StateMachine$SmHandler;)Z

    move-result p0

    return p0
.end method

.method protected final isQuit(Landroid/os/Message;)Z
    .locals 0

    .line 2015
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_1

    .line 2016
    iget p0, p1, Landroid/os/Message;->what:I

    const/4 p1, -0x1

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0

    .line 2018
    :cond_1
    invoke-static {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$misQuit(Lcom/android/internal/telephony/StateMachine$SmHandler;Landroid/os/Message;)Z

    move-result p0

    return p0
.end method

.method protected log(Ljava/lang/String;)V
    .locals 0

    .line 2128
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logAndAddLogRec(Ljava/lang/String;)V
    .locals 0

    .line 2118
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->addLogRec(Ljava/lang/String;)V

    .line 2119
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logd(Ljava/lang/String;)V
    .locals 0

    .line 2137
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 0

    .line 2173
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 0

    .line 2183
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1, p2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method protected logi(Ljava/lang/String;)V
    .locals 0

    .line 2155
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logv(Ljava/lang/String;)V
    .locals 0

    .line 2146
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logw(Ljava/lang/String;)V
    .locals 0

    .line 2164
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public final obtainMessage()Landroid/os/Message;
    .locals 0

    .line 1617
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0}, Landroid/os/Message;->obtain(Landroid/os/Handler;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(I)Landroid/os/Message;
    .locals 0

    .line 1632
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1}, Landroid/os/Message;->obtain(Landroid/os/Handler;I)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(II)Landroid/os/Message;
    .locals 1

    .line 1667
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    const/4 v0, 0x0

    invoke-static {p0, p1, p2, v0}, Landroid/os/Message;->obtain(Landroid/os/Handler;III)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(III)Landroid/os/Message;
    .locals 0

    .line 1686
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1, p2, p3}, Landroid/os/Message;->obtain(Landroid/os/Handler;III)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;
    .locals 0

    .line 1706
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1, p2, p3, p4}, Landroid/os/Message;->obtain(Landroid/os/Handler;IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public final obtainMessage(ILjava/lang/Object;)Landroid/os/Message;
    .locals 0

    .line 1649
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

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

    .line 2026
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2029
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mquit(Lcom/android/internal/telephony/StateMachine$SmHandler;)V

    return-void
.end method

.method public final quitNow()V
    .locals 0

    .line 2037
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2040
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mquitNow(Lcom/android/internal/telephony/StateMachine$SmHandler;)V

    return-void
.end method

.method protected recordLogRec(Landroid/os/Message;)Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method protected final removeDeferredMessages(I)V
    .locals 1

    .line 1972
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1975
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmDeferredMessages(Lcom/android/internal/telephony/StateMachine$SmHandler;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    .line 1976
    :cond_1
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1977
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    .line 1978
    iget v0, v0, Landroid/os/Message;->what:I

    if-ne v0, p1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    :cond_2
    return-void
.end method

.method protected final removeMessages(I)V
    .locals 0

    .line 1962
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1965
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeMessages(I)V

    return-void
.end method

.method public final removeState(Lcom/android/internal/telephony/State;)V
    .locals 0

    .line 1371
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mremoveState(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/State;)V

    return-void
.end method

.method public sendMessage(I)V
    .locals 1

    .line 1717
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1720
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(II)V
    .locals 1

    .line 1745
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1748
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(III)V
    .locals 1

    .line 1758
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1761
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(IIILjava/lang/Object;)V
    .locals 1

    .line 1772
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1775
    :cond_0
    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(ILjava/lang/Object;)V
    .locals 1

    .line 1731
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1734
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessage(Landroid/os/Message;)V
    .locals 0

    .line 1786
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1789
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(I)V
    .locals 1

    .line 1879
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1882
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(II)V
    .locals 1

    .line 1907
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1910
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(III)V
    .locals 1

    .line 1922
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1925
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(IIILjava/lang/Object;)V
    .locals 1

    .line 1936
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1939
    :cond_0
    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(ILjava/lang/Object;)V
    .locals 1

    .line 1893
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1896
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method protected final sendMessageAtFrontOfQueue(Landroid/os/Message;)V
    .locals 0

    .line 1950
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1953
    :cond_0
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method public sendMessageDelayed(IIIJ)V
    .locals 1

    .line 1838
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1841
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(III)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p4, p5}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(IIILjava/lang/Object;J)V
    .locals 1

    .line 1852
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1855
    :cond_0
    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p5, p6}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(IIJ)V
    .locals 1

    .line 1825
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1828
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p3, p4}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(IJ)V
    .locals 1

    .line 1799
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1802
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p2, p3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(ILjava/lang/Object;J)V
    .locals 1

    .line 1812
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez v0, :cond_0

    return-void

    .line 1815
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0, p3, p4}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public sendMessageDelayed(Landroid/os/Message;J)V
    .locals 0

    .line 1865
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 1868
    :cond_0
    invoke-virtual {p0, p1, p2, p3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method public setDbg(Z)V
    .locals 0

    .line 2061
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2064
    :cond_0
    invoke-static {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$msetDbg(Lcom/android/internal/telephony/StateMachine$SmHandler;Z)V

    return-void
.end method

.method public final setInitialState(Lcom/android/internal/telephony/State;)V
    .locals 0

    .line 1382
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$msetInitialState(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/State;)V

    return-void
.end method

.method public final setLogOnlyTransitions(Z)V
    .locals 0

    .line 1503
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine$LogRecords;->setLogOnlyTransitions(Z)V

    return-void
.end method

.method public final setLogRecSize(I)V
    .locals 0

    .line 1494
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine$LogRecords;->setSize(I)V

    return-void
.end method

.method public start()V
    .locals 0

    .line 2073
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    if-nez p0, :cond_0

    return-void

    .line 2077
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mcompleteConstruction(Lcom/android/internal/telephony/StateMachine$SmHandler;)V

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    const-string v0, "(null)"

    .line 2104
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine;->mName:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->toString()Ljava/lang/String;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0

    .line 2105
    :try_start_1
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mgetCurrentState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/IState;

    move-result-object p0

    invoke-interface {p0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/NullPointerException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_0
    move-object v1, v0

    .line 2109
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

.method public final transitionTo(Lcom/android/internal/telephony/IState;)V
    .locals 0

    .line 1421
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mtransitionTo(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method public final transitionToHaltingState()V
    .locals 1

    .line 1432
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmHaltingState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$mtransitionTo(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method protected unhandledMessage(Landroid/os/Message;)V
    .locals 2

    .line 1454
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine;->mSmHandler:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmDbg(Lcom/android/internal/telephony/StateMachine$SmHandler;)Z

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

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->loge(Ljava/lang/String;)V

    :cond_0
    return-void
.end method
