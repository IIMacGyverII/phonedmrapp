.class Lcom/pri/anim/spring/ChoreographerSpringLooper$1;
.super Ljava/lang/Object;
.source "ChoreographerSpringLooper.java"

# interfaces
.implements Landroid/view/Choreographer$FrameCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/anim/spring/ChoreographerSpringLooper;-><init>(Landroid/view/Choreographer;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;


# direct methods
.method constructor <init>(Lcom/pri/anim/spring/ChoreographerSpringLooper;)V
    .locals 0

    .line 21
    iput-object p1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;->this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public doFrame(J)V
    .locals 4

    .line 24
    iget-object p1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;->this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;

    invoke-static {p1}, Lcom/pri/anim/spring/ChoreographerSpringLooper;->access$000(Lcom/pri/anim/spring/ChoreographerSpringLooper;)Z

    move-result p1

    if-eqz p1, :cond_1

    iget-object p1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;->this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;

    iget-object p1, p1, Lcom/pri/anim/spring/SpringLooper;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    if-nez p1, :cond_0

    goto :goto_0

    .line 27
    :cond_0
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide p1

    .line 28
    iget-object v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;->this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;

    iget-object v1, v0, Lcom/pri/anim/spring/SpringLooper;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    invoke-static {v0}, Lcom/pri/anim/spring/ChoreographerSpringLooper;->access$100(Lcom/pri/anim/spring/ChoreographerSpringLooper;)J

    move-result-wide v2

    sub-long v2, p1, v2

    long-to-double v2, v2

    invoke-virtual {v1, v2, v3}, Lcom/pri/anim/spring/BaseSpringSystem;->loop(D)V

    .line 29
    iget-object v0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;->this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;

    invoke-static {v0, p1, p2}, Lcom/pri/anim/spring/ChoreographerSpringLooper;->access$102(Lcom/pri/anim/spring/ChoreographerSpringLooper;J)J

    .line 30
    iget-object p1, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;->this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;

    invoke-static {p1}, Lcom/pri/anim/spring/ChoreographerSpringLooper;->access$300(Lcom/pri/anim/spring/ChoreographerSpringLooper;)Landroid/view/Choreographer;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/anim/spring/ChoreographerSpringLooper$1;->this$0:Lcom/pri/anim/spring/ChoreographerSpringLooper;

    invoke-static {p0}, Lcom/pri/anim/spring/ChoreographerSpringLooper;->access$200(Lcom/pri/anim/spring/ChoreographerSpringLooper;)Landroid/view/Choreographer$FrameCallback;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/view/Choreographer;->postFrameCallback(Landroid/view/Choreographer$FrameCallback;)V

    :cond_1
    :goto_0
    return-void
.end method
