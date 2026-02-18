.class Lcom/android/internal/telephony/StateMachine$SmHandler;
.super Landroid/os/Handler;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/StateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "SmHandler"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;,
        Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;,
        Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;
    }
.end annotation


# static fields
.field private static final mSmHandlerObj:Ljava/lang/Object;


# instance fields
.field private mDbg:Z

.field private mDeferredMessages:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/os/Message;",
            ">;"
        }
    .end annotation
.end field

.field private mDestState:Lcom/android/internal/telephony/State;

.field private mHaltingState:Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;

.field private mHasQuit:Z

.field private mInitialState:Lcom/android/internal/telephony/State;

.field private mIsConstructionCompleted:Z

.field private mLogRecords:Lcom/android/internal/telephony/StateMachine$LogRecords;

.field private mMsg:Landroid/os/Message;

.field private mQuittingState:Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;

.field private mSm:Lcom/android/internal/telephony/StateMachine;

.field private mStateInfo:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Lcom/android/internal/telephony/State;",
            "Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;",
            ">;"
        }
    .end annotation
.end field

.field private mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

.field private mStateStackTopIndex:I

.field private mTempStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

.field private mTempStateStackCount:I

.field private mTransitionInProgress:Z


# direct methods
.method public static synthetic $r8$lambda$yh5IKFfZWovp87RJp52yNyt9hdA(Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->lambda$removeState$0(Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmDbg(Lcom/android/internal/telephony/StateMachine$SmHandler;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmDeferredMessages(Lcom/android/internal/telephony/StateMachine$SmHandler;)Ljava/util/ArrayList;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDeferredMessages:Ljava/util/ArrayList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDestState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/State;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmHaltingState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mHaltingState:Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLogRecords(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine$LogRecords;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mLogRecords:Lcom/android/internal/telephony/StateMachine$LogRecords;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSm(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmStateStack(Lcom/android/internal/telephony/StateMachine$SmHandler;)[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmStateStackTopIndex(Lcom/android/internal/telephony/StateMachine$SmHandler;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    return p0
.end method

.method static bridge synthetic -$$Nest$maddState(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine$SmHandler;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mcompleteConstruction(Lcom/android/internal/telephony/StateMachine$SmHandler;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->completeConstruction()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mdeferMessage(Lcom/android/internal/telephony/StateMachine$SmHandler;Landroid/os/Message;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->deferMessage(Landroid/os/Message;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mgetCurrentMessage(Lcom/android/internal/telephony/StateMachine$SmHandler;)Landroid/os/Message;
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->getCurrentMessage()Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mgetCurrentState(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/IState;
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$misDbg(Lcom/android/internal/telephony/StateMachine$SmHandler;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->isDbg()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misQuit(Lcom/android/internal/telephony/StateMachine$SmHandler;Landroid/os/Message;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->isQuit(Landroid/os/Message;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mquit(Lcom/android/internal/telephony/StateMachine$SmHandler;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->quit()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mquitNow(Lcom/android/internal/telephony/StateMachine$SmHandler;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->quitNow()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mremoveState(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/State;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->removeState(Lcom/android/internal/telephony/State;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$msetDbg(Lcom/android/internal/telephony/StateMachine$SmHandler;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->setDbg(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$msetInitialState(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/State;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->setInitialState(Lcom/android/internal/telephony/State;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtransitionTo(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/IState;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 691
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSmHandlerObj:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>(Landroid/os/Looper;Lcom/android/internal/telephony/StateMachine;)V
    .locals 2

    .line 1222
    invoke-direct {p0, p1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/4 p1, 0x0

    .line 685
    iput-boolean p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mHasQuit:Z

    .line 688
    iput-boolean p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    .line 697
    new-instance v0, Lcom/android/internal/telephony/StateMachine$LogRecords;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/StateMachine$LogRecords;-><init>(Lcom/android/internal/telephony/StateMachine$LogRecords-IA;)V

    iput-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mLogRecords:Lcom/android/internal/telephony/StateMachine$LogRecords;

    const/4 v0, -0x1

    .line 706
    iput v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    .line 715
    new-instance v0, Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;-><init>(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState-IA;)V

    iput-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mHaltingState:Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;

    .line 718
    new-instance v0, Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;-><init>(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState-IA;)V

    iput-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mQuittingState:Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;

    .line 748
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    .line 762
    iput-boolean p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTransitionInProgress:Z

    .line 765
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDeferredMessages:Ljava/util/ArrayList;

    .line 1223
    iput-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    .line 1225
    iget-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mHaltingState:Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    .line 1226
    iget-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mQuittingState:Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    return-void
.end method

.method synthetic constructor <init>(Landroid/os/Looper;Lcom/android/internal/telephony/StateMachine;Lcom/android/internal/telephony/StateMachine$SmHandler-IA;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine$SmHandler;-><init>(Landroid/os/Looper;Lcom/android/internal/telephony/StateMachine;)V

    return-void
.end method

.method private final addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;
    .locals 3

    .line 1165
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_1

    .line 1166
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "addStateInternal: E state="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ",parent="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez p2, :cond_0

    const-string v2, ""

    goto :goto_0

    .line 1167
    :cond_0
    invoke-virtual {p2}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v2

    :goto_0
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1166
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_1
    const/4 v0, 0x0

    if-eqz p2, :cond_2

    .line 1171
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {v1, p2}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-nez v1, :cond_3

    .line 1174
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    move-result-object v1

    goto :goto_1

    :cond_2
    move-object v1, v0

    .line 1177
    :cond_3
    :goto_1
    iget-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {p2, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-nez p2, :cond_4

    .line 1179
    new-instance p2, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    invoke-direct {p2, p0, v0}, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;-><init>(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo-IA;)V

    .line 1180
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {v0, p1, p2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 1184
    :cond_4
    iget-object v0, p2, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-eqz v0, :cond_6

    if-ne v0, v1, :cond_5

    goto :goto_2

    .line 1186
    :cond_5
    new-instance p0, Ljava/lang/RuntimeException;

    const-string/jumbo p1, "state already added"

    invoke-direct {p0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 1188
    :cond_6
    :goto_2
    iput-object p1, p2, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    .line 1189
    iput-object v1, p2, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    const/4 p1, 0x0

    .line 1190
    iput-boolean p1, p2, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->active:Z

    .line 1191
    iget-boolean p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz p1, :cond_7

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "addStateInternal: X stateInfo: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_7
    return-object p2
.end method

.method private final cleanupAfterQuitting()V
    .locals 2

    .line 927
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine;->-$$Nest$fgetmSmThread(Lcom/android/internal/telephony/StateMachine;)Landroid/os/HandlerThread;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 929
    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/Looper;->quit()V

    .line 930
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/StateMachine;->-$$Nest$fputmSmThread(Lcom/android/internal/telephony/StateMachine;Landroid/os/HandlerThread;)V

    .line 933
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/StateMachine;->-$$Nest$fputmSmHandler(Lcom/android/internal/telephony/StateMachine;Lcom/android/internal/telephony/StateMachine$SmHandler;)V

    .line 934
    iput-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    .line 935
    iput-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mMsg:Landroid/os/Message;

    .line 936
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mLogRecords:Lcom/android/internal/telephony/StateMachine$LogRecords;

    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine$LogRecords;->cleanup()V

    .line 937
    iput-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    .line 938
    iput-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    .line 939
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    .line 940
    iput-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mInitialState:Lcom/android/internal/telephony/State;

    .line 941
    iput-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    .line 942
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDeferredMessages:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    const/4 v0, 0x1

    .line 943
    iput-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mHasQuit:Z

    return-void
.end method

.method private final completeConstruction()V
    .locals 5

    .line 950
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    const-string v1, "completeConstruction: E"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 957
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    :cond_1
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    move v4, v1

    :goto_1
    if-eqz v3, :cond_2

    .line 960
    iget-object v3, v3, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    :cond_2
    if-ge v2, v4, :cond_1

    move v2, v4

    goto :goto_0

    .line 966
    :cond_3
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "completeConstruction: maxDepth="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 968
    :cond_4
    new-array v0, v2, [Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iput-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    .line 969
    new-array v0, v2, [Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iput-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    .line 970
    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->setupInitialStateStack()V

    const/4 v0, -0x2

    .line 973
    sget-object v1, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSmHandlerObj:Ljava/lang/Object;

    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    .line 975
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_5

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    const-string v0, "completeConstruction: X"

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_5
    return-void
.end method

.method private final deferMessage(Landroid/os/Message;)V
    .locals 3

    .line 1247
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "deferMessage: msg="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Landroid/os/Message;->what:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 1250
    :cond_0
    invoke-virtual {p0}, Landroid/os/Handler;->obtainMessage()Landroid/os/Message;

    move-result-object v0

    .line 1251
    invoke-virtual {v0, p1}, Landroid/os/Message;->copyFrom(Landroid/os/Message;)V

    .line 1253
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDeferredMessages:Ljava/util/ArrayList;

    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private final getCurrentMessage()Landroid/os/Message;
    .locals 0

    .line 1145
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mMsg:Landroid/os/Message;

    return-object p0
.end method

.method private final getCurrentState()Lcom/android/internal/telephony/IState;
    .locals 1

    .line 1152
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    aget-object p0, v0, p0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    return-object p0
.end method

.method private final invokeEnterMethods(I)V
    .locals 4

    move v0, p1

    .line 1032
    :goto_0
    iget v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    const/4 v2, 0x0

    if-gt v0, v1, :cond_2

    if-ne p1, v1, :cond_0

    .line 1035
    iput-boolean v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTransitionInProgress:Z

    .line 1037
    :cond_0
    iget-boolean v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "invokeEnterMethods: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    aget-object v3, v3, v0

    iget-object v3, v3, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-virtual {v3}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 1038
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    aget-object v1, v1, v0

    iget-object v1, v1, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-virtual {v1}, Lcom/android/internal/telephony/State;->enter()V

    .line 1039
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    aget-object v1, v1, v0

    const/4 v2, 0x1

    iput-boolean v2, v1, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->active:Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 1041
    :cond_2
    iput-boolean v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTransitionInProgress:Z

    return-void
.end method

.method private final invokeExitMethods(Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;)V
    .locals 4

    .line 1018
    :goto_0
    iget v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    if-ltz v0, :cond_1

    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    aget-object v0, v1, v0

    if-eq v0, p1, :cond_1

    .line 1020
    iget-object v0, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    .line 1021
    iget-boolean v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "invokeExitMethods: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 1022
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/State;->exit()V

    .line 1023
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    aget-object v0, v0, v1

    const/4 v2, 0x0

    iput-boolean v2, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->active:Z

    add-int/lit8 v1, v1, -0x1

    .line 1024
    iput v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    goto :goto_0

    :cond_1
    return-void
.end method

.method private final isDbg()Z
    .locals 0

    .line 1275
    iget-boolean p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    return p0
.end method

.method private final isQuit(Landroid/os/Message;)Z
    .locals 1

    .line 1270
    iget p0, p1, Landroid/os/Message;->what:I

    const/4 v0, -0x1

    if-ne p0, v0, :cond_0

    iget-object p0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    sget-object p1, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSmHandlerObj:Ljava/lang/Object;

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$removeState$0(Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;)Z
    .locals 0

    .line 1206
    iget-object p1, p1, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private final moveDeferredMessageAtFrontOfQueue()V
    .locals 5

    .line 1054
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDeferredMessages:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    :goto_0
    if-ltz v0, :cond_1

    .line 1055
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDeferredMessages:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/Message;

    .line 1056
    iget-boolean v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v2, :cond_0

    iget-object v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "moveDeferredMessageAtFrontOfQueue; what="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v1, Landroid/os/Message;->what:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 1057
    :cond_0
    invoke-virtual {p0, v1}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 1059
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDeferredMessages:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->clear()V

    return-void
.end method

.method private final moveTempStateStackToStateStack()I
    .locals 6

    .line 1070
    iget v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    add-int/lit8 v0, v0, 0x1

    .line 1071
    iget v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    add-int/lit8 v1, v1, -0x1

    move v2, v0

    :goto_0
    if-ltz v1, :cond_1

    .line 1074
    iget-boolean v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v3, :cond_0

    iget-object v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "moveTempStackToStateStack: i="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, ",j="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 1075
    :cond_0
    iget-object v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget-object v4, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    aget-object v4, v4, v1

    aput-object v4, v3, v2

    add-int/lit8 v2, v2, 0x1

    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    :cond_1
    add-int/lit8 v2, v2, -0x1

    .line 1080
    iput v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    .line 1081
    iget-boolean v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v1, :cond_2

    .line 1082
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "moveTempStackToStateStack: X mStateStackTop="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ",startingIndex="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ",Top="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    aget-object p0, v3, p0

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    .line 1084
    invoke-virtual {p0}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 1082
    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_2
    return v0
.end method

.method private performTransitions(Lcom/android/internal/telephony/State;Landroid/os/Message;)V
    .locals 9

    .line 841
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    aget-object v0, v0, v1

    iget-object v6, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    .line 848
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mMsg:Landroid/os/Message;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->recordLogRec(Landroid/os/Message;)Z

    move-result v0

    const/4 v8, 0x1

    if-eqz v0, :cond_0

    iget-object p2, p2, Landroid/os/Message;->obj:Ljava/lang/Object;

    sget-object v0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSmHandlerObj:Ljava/lang/Object;

    if-eq p2, v0, :cond_0

    move p2, v8

    goto :goto_0

    :cond_0
    const/4 p2, 0x0

    .line 850
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mLogRecords:Lcom/android/internal/telephony/StateMachine$LogRecords;

    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine$LogRecords;->logOnlyTransitions()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 852
    iget-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    if-eqz p2, :cond_2

    .line 853
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mLogRecords:Lcom/android/internal/telephony/StateMachine$LogRecords;

    iget-object v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    iget-object v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mMsg:Landroid/os/Message;

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/StateMachine;->getLogRecString(Landroid/os/Message;)Ljava/lang/String;

    move-result-object v4

    iget-object v7, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    move-object v5, p1

    invoke-virtual/range {v1 .. v7}, Lcom/android/internal/telephony/StateMachine$LogRecords;->add(Lcom/android/internal/telephony/StateMachine;Landroid/os/Message;Ljava/lang/String;Lcom/android/internal/telephony/IState;Lcom/android/internal/telephony/IState;Lcom/android/internal/telephony/IState;)V

    goto :goto_1

    :cond_1
    if-eqz p2, :cond_2

    .line 858
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mLogRecords:Lcom/android/internal/telephony/StateMachine$LogRecords;

    iget-object v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    iget-object v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mMsg:Landroid/os/Message;

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/StateMachine;->getLogRecString(Landroid/os/Message;)Ljava/lang/String;

    move-result-object v4

    iget-object v7, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    move-object v5, p1

    invoke-virtual/range {v1 .. v7}, Lcom/android/internal/telephony/StateMachine$LogRecords;->add(Lcom/android/internal/telephony/StateMachine;Landroid/os/Message;Ljava/lang/String;Lcom/android/internal/telephony/IState;Lcom/android/internal/telephony/IState;Lcom/android/internal/telephony/IState;)V

    .line 862
    :cond_2
    :goto_1
    iget-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    if-eqz p1, :cond_5

    .line 868
    :goto_2
    iget-boolean p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz p2, :cond_3

    iget-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    const-string v0, "handleMessage: new destination call exit/enter"

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 875
    :cond_3
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->setupTempStateStackWithStatesToEnter(Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    move-result-object p2

    .line 877
    iput-boolean v8, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTransitionInProgress:Z

    .line 878
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/StateMachine$SmHandler;->invokeExitMethods(Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;)V

    .line 879
    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->moveTempStateStackToStateStack()I

    move-result p2

    .line 880
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/StateMachine$SmHandler;->invokeEnterMethods(I)V

    .line 888
    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->moveDeferredMessageAtFrontOfQueue()V

    .line 890
    iget-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    if-eq p1, p2, :cond_4

    move-object p1, p2

    goto :goto_2

    :cond_4
    const/4 p2, 0x0

    .line 898
    iput-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    :cond_5
    if-eqz p1, :cond_7

    .line 906
    iget-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mQuittingState:Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;

    if-ne p1, p2, :cond_6

    .line 910
    iget-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->onQuitting()V

    .line 911
    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->cleanupAfterQuitting()V

    goto :goto_3

    .line 912
    :cond_6
    iget-object p2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mHaltingState:Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;

    if-ne p1, p2, :cond_7

    .line 918
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->onHalting()V

    :cond_7
    :goto_3
    return-void
.end method

.method private final processMsg(Landroid/os/Message;)Lcom/android/internal/telephony/State;
    .locals 5

    .line 985
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    aget-object v0, v0, v1

    .line 986
    iget-boolean v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    const-string v2, "processMsg: "

    if-eqz v1, :cond_0

    .line 987
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-virtual {v4}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 990
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->isQuit(Landroid/os/Message;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 991
    iget-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mQuittingState:Lcom/android/internal/telephony/StateMachine$SmHandler$QuittingState;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_1

    .line 993
    :cond_1
    :goto_0
    iget-object v1, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/State;->processMessage(Landroid/os/Message;)Z

    move-result v1

    if-nez v1, :cond_3

    .line 997
    iget-object v0, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-nez v0, :cond_2

    .line 1002
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->unhandledMessage(Landroid/os/Message;)V

    goto :goto_1

    .line 1005
    :cond_2
    iget-boolean v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v1, :cond_1

    .line 1006
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-virtual {v4}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    goto :goto_0

    :cond_3
    :goto_1
    if-eqz v0, :cond_4

    .line 1010
    iget-object p0, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    goto :goto_2

    :cond_4
    const/4 p0, 0x0

    :goto_2
    return-object p0
.end method

.method private final quit()V
    .locals 2

    .line 1258
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    const-string v1, "quit:"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_0
    const/4 v0, -0x1

    .line 1259
    sget-object v1, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSmHandlerObj:Ljava/lang/Object;

    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method private final quitNow()V
    .locals 2

    .line 1264
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    const-string v1, "quitNow:"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_0
    const/4 v0, -0x1

    .line 1265
    sget-object v1, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSmHandlerObj:Ljava/lang/Object;

    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessageAtFrontOfQueue(Landroid/os/Message;)Z

    return-void
.end method

.method private removeState(Lcom/android/internal/telephony/State;)V
    .locals 3

    .line 1201
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-eqz v0, :cond_2

    .line 1202
    iget-boolean v1, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->active:Z

    if-eqz v1, :cond_0

    goto :goto_0

    .line 1205
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {v1}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/StateMachine$SmHandler$$ExternalSyntheticLambda0;

    invoke-direct {v2, v0}, Lcom/android/internal/telephony/StateMachine$SmHandler$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;)V

    .line 1206
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 1207
    invoke-interface {v0}, Ljava/util/stream/Stream;->findAny()Ljava/util/Optional;

    move-result-object v0

    .line 1208
    invoke-virtual {v0}, Ljava/util/Optional;->isPresent()Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 1212
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {p0, p1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_2
    :goto_0
    return-void
.end method

.method private final setDbg(Z)V
    .locals 0

    .line 1280
    iput-boolean p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    return-void
.end method

.method private final setInitialState(Lcom/android/internal/telephony/State;)V
    .locals 3

    .line 1231
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setInitialState: initialState="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 1232
    :cond_0
    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mInitialState:Lcom/android/internal/telephony/State;

    return-void
.end method

.method private final setupInitialStateStack()V
    .locals 3

    .line 1125
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_0

    .line 1126
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "setupInitialStateStack: E mInitialState="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mInitialState:Lcom/android/internal/telephony/State;

    invoke-virtual {v2}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 1129
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mInitialState:Lcom/android/internal/telephony/State;

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    const/4 v1, 0x0

    .line 1130
    iput v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    :goto_0
    if-eqz v0, :cond_1

    .line 1131
    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    aput-object v0, v1, v2

    .line 1132
    iget-object v0, v0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    add-int/lit8 v2, v2, 0x1

    .line 1130
    iput v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    goto :goto_0

    :cond_1
    const/4 v0, -0x1

    .line 1136
    iput v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateStackTopIndex:I

    .line 1138
    invoke-direct {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->moveTempStateStackToStateStack()I

    return-void
.end method

.method private final setupTempStateStackWithStatesToEnter(Lcom/android/internal/telephony/State;)Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;
    .locals 3

    const/4 v0, 0x0

    .line 1107
    iput v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    .line 1108
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mStateInfo:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    .line 1110
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStack:[Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    iget v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    add-int/lit8 v2, v1, 0x1

    iput v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    aput-object p1, v0, v1

    .line 1111
    iget-object p1, p1, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-eqz p1, :cond_1

    .line 1112
    iget-boolean v0, p1, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->active:Z

    if-eqz v0, :cond_0

    .line 1114
    :cond_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_2

    .line 1115
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "setupTempStateStackWithStatesToEnter: X mTempStateStackCount="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTempStateStackCount:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ",curStateInfo: "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_2
    return-object p1
.end method

.method private final transitionTo(Lcom/android/internal/telephony/IState;)V
    .locals 3

    .line 1237
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mTransitionInProgress:Z

    if-eqz v0, :cond_0

    .line 1238
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    invoke-static {v0}, Lcom/android/internal/telephony/StateMachine;->-$$Nest$fgetmName(Lcom/android/internal/telephony/StateMachine;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "transitionTo called while transition already in progress to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ", new target state="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 1241
    :cond_0
    check-cast p1, Lcom/android/internal/telephony/State;

    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    .line 1242
    iget-boolean p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz p1, :cond_1

    iget-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "transitionTo: destState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDestState:Lcom/android/internal/telephony/State;

    invoke-virtual {p0}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    :cond_1
    return-void
.end method


# virtual methods
.method public final handleMessage(Landroid/os/Message;)V
    .locals 5

    .line 796
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mHasQuit:Z

    if-nez v0, :cond_6

    .line 797
    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    const/4 v1, -0x1

    const/4 v2, -0x2

    if-eqz v0, :cond_0

    iget v3, p1, Landroid/os/Message;->what:I

    if-eq v3, v2, :cond_0

    if-eq v3, v1, :cond_0

    .line 798
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/StateMachine;->onPreHandleMessage(Landroid/os/Message;)V

    .line 801
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "handleMessage: E msg.what="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, p1, Landroid/os/Message;->what:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 804
    :cond_1
    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mMsg:Landroid/os/Message;

    const/4 v0, 0x0

    .line 808
    iget-boolean v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mIsConstructionCompleted:Z

    if-nez v3, :cond_4

    iget v4, p1, Landroid/os/Message;->what:I

    if-ne v4, v1, :cond_2

    goto :goto_0

    :cond_2
    if-nez v3, :cond_3

    if-ne v4, v2, :cond_3

    .line 811
    iget-object v3, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    sget-object v4, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSmHandlerObj:Ljava/lang/Object;

    if-ne v3, v4, :cond_3

    const/4 v3, 0x1

    .line 814
    iput-boolean v3, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mIsConstructionCompleted:Z

    const/4 v3, 0x0

    .line 815
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/StateMachine$SmHandler;->invokeEnterMethods(I)V

    goto :goto_1

    .line 817
    :cond_3
    new-instance p0, Ljava/lang/RuntimeException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "StateMachine.handleMessage: The start method not called, received msg: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 810
    :cond_4
    :goto_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->processMsg(Landroid/os/Message;)Lcom/android/internal/telephony/State;

    move-result-object v0

    .line 820
    :goto_1
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler;->performTransitions(Lcom/android/internal/telephony/State;Landroid/os/Message;)V

    .line 823
    iget-boolean v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mDbg:Z

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    if-eqz v0, :cond_5

    const-string v3, "handleMessage: X"

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/StateMachine;->log(Ljava/lang/String;)V

    .line 825
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler;->mSm:Lcom/android/internal/telephony/StateMachine;

    if-eqz p0, :cond_6

    iget v0, p1, Landroid/os/Message;->what:I

    if-eq v0, v2, :cond_6

    if-eq v0, v1, :cond_6

    .line 826
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->onPostHandleMessage(Landroid/os/Message;)V

    :cond_6
    return-void
.end method
