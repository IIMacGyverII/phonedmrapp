.class Lcom/pri/anim/spring/ChoreographerSpringLooper;
.super Lcom/pri/anim/spring/SpringLooper;
.source "ChoreographerSpringLooper.java"


# instance fields
.field private final mChoreographer:Landroid/view/Choreographer;

.field private final mFrameCallback:Landroid/view/Choreographer$FrameCallback;

.field private mLastTime:J

.field private mStarted:Z


# direct methods
.method public constructor <init>(Landroid/view/Choreographer;)V
    .locals 0

    .line 19
    invoke-direct {p0}, Lcom/pri/anim/spring/SpringLooper;-><init>()V

    .line 20
    iput-object p1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mChoreographer:Landroid/view/Choreographer;

    .line 21
    new-instance p1, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;

    invoke-direct {p1, p0}, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;-><init>(Lcom/pri/anim/spring/ChoreographerSpringLooper;)V

    iput-object p1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mFrameCallback:Landroid/view/Choreographer$FrameCallback;

    return-void
.end method

.method static synthetic access$000(Lcom/pri/anim/spring/ChoreographerSpringLooper;)Z
    .locals 0

    .line 6
    iget-boolean p0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mStarted:Z

    return p0
.end method

.method static synthetic access$100(Lcom/pri/anim/spring/ChoreographerSpringLooper;)J
    .locals 2

    .line 6
    iget-wide v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mLastTime:J

    return-wide v0
.end method

.method static synthetic access$102(Lcom/pri/anim/spring/ChoreographerSpringLooper;J)J
    .locals 0

    .line 6
    iput-wide p1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mLastTime:J

    return-wide p1
.end method

.method static synthetic access$200(Lcom/pri/anim/spring/ChoreographerSpringLooper;)Landroid/view/Choreographer$FrameCallback;
    .locals 0

    .line 6
    iget-object p0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mFrameCallback:Landroid/view/Choreographer$FrameCallback;

    return-object p0
.end method

.method static synthetic access$300(Lcom/pri/anim/spring/ChoreographerSpringLooper;)Landroid/view/Choreographer;
    .locals 0

    .line 6
    iget-object p0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mChoreographer:Landroid/view/Choreographer;

    return-object p0
.end method

.method public static create()Lcom/pri/anim/spring/ChoreographerSpringLooper;
    .locals 2

    .line 16
    new-instance v0, Lcom/pri/anim/spring/ChoreographerSpringLooper;

    invoke-static {}, Landroid/view/Choreographer;->getInstance()Landroid/view/Choreographer;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/pri/anim/spring/ChoreographerSpringLooper;-><init>(Landroid/view/Choreographer;)V

    return-object v0
.end method


# virtual methods
.method public start()V
    .locals 2

    .line 37
    iget-boolean v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mStarted:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 40
    iput-boolean v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mStarted:Z

    .line 41
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mLastTime:J

    .line 42
    iget-object v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mChoreographer:Landroid/view/Choreographer;

    iget-object v1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mFrameCallback:Landroid/view/Choreographer$FrameCallback;

    invoke-virtual {v0, v1}, Landroid/view/Choreographer;->removeFrameCallback(Landroid/view/Choreographer$FrameCallback;)V

    .line 43
    iget-object v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mChoreographer:Landroid/view/Choreographer;

    iget-object p0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mFrameCallback:Landroid/view/Choreographer$FrameCallback;

    invoke-virtual {v0, p0}, Landroid/view/Choreographer;->postFrameCallback(Landroid/view/Choreographer$FrameCallback;)V

    return-void
.end method

.method public stop()V
    .locals 1

    const/4 v0, 0x0

    .line 48
    iput-boolean v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mStarted:Z

    .line 49
    iget-object v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mChoreographer:Landroid/view/Choreographer;

    iget-object p0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper;->mFrameCallback:Landroid/view/Choreographer$FrameCallback;

    invoke-virtual {v0, p0}, Landroid/view/Choreographer;->removeFrameCallback(Landroid/view/Choreographer$FrameCallback;)V

    return-void
.end method
