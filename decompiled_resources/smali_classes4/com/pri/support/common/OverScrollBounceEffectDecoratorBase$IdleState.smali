.class Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;
.super Ljava/lang/Object;
.source "OverScrollBounceEffectDecoratorBase.java"

# interfaces
.implements Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "IdleState"
.end annotation


# instance fields
.field final mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

.field private originalOffset:F

.field final synthetic this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;


# direct methods
.method constructor <init>(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)V
    .locals 1

    .line 212
    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const v0, 0x7f7fffff    # Float.MAX_VALUE

    .line 210
    iput v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->originalOffset:F

    .line 213
    invoke-virtual {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->createMotionAttributes()Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    return-void
.end method

.method static synthetic access$700(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;)F
    .locals 0

    .line 208
    iget p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->originalOffset:F

    return p0
.end method


# virtual methods
.method public getStateId()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public handleEntryTransition(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V
    .locals 2

    .line 254
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$300(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollStateListener;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    .line 255
    invoke-interface {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;->getStateId()I

    move-result p1

    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->getStateId()I

    move-result p0

    .line 254
    invoke-interface {v0, v1, p1, p0}, Lcom/pri/support/common/IOverScrollStateListener;->onOverScrollStateChange(Lcom/pri/support/common/IOverScrollDecor;II)V

    return-void
.end method

.method public handleMoveTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 233
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-virtual {v1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object v1

    invoke-virtual {v0, v1, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->init(Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 237
    :cond_0
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$000(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;

    move-result-object v0

    invoke-interface {v0}, Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;->isInAbsoluteStart()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget-boolean v0, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mDir:Z

    if-nez v0, :cond_2

    :cond_1
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    .line 238
    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$000(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;

    move-result-object v0

    invoke-interface {v0}, Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;->isInAbsoluteEnd()Z

    move-result v0

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget-boolean v0, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mDir:Z

    if-eqz v0, :cond_2

    goto :goto_0

    .line 242
    :cond_2
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v0

    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v1

    iput v1, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mPointerId:I

    .line 243
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget v1, v1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mAbsOffset:F

    iput v1, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mAbsOffset:F

    .line 245
    iget v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->originalOffset:F

    const v2, 0x7f7fffff    # Float.MAX_VALUE

    cmpl-float v0, v0, v2

    if-nez v0, :cond_3

    .line 246
    iput v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->originalOffset:F

    .line 248
    :cond_3
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget-boolean v1, v1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mDir:Z

    iput-boolean v1, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mDir:Z

    .line 249
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$200(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    .line 250
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$200(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->handleMoveTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0

    :cond_4
    :goto_0
    return v1
.end method

.method public handleUpOrCancelTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public hasValidOriginalOffset()Z
    .locals 1

    .line 221
    iget p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->originalOffset:F

    const v0, 0x7f7fffff    # Float.MAX_VALUE

    cmpl-float p0, p0, v0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isNonOriginalOffset(F)Z
    .locals 1

    .line 225
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->hasValidOriginalOffset()Z

    move-result v0

    if-eqz v0, :cond_0

    iget p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->originalOffset:F

    cmpl-float p0, p0, p1

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
