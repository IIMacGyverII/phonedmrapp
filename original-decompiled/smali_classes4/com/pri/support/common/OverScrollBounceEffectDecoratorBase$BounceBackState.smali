.class Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;
.super Lcom/pri/anim/spring/SimpleSpringListener;
.source "OverScrollBounceEffectDecoratorBase.java"

# interfaces
.implements Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "BounceBackState"
.end annotation


# instance fields
.field final mAnimAttributes:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;

.field mDisableCancelAnimOnMoveEvent:Z

.field private final mSpring:Lcom/pri/anim/spring/Spring;

.field private final mSpringSystem:Lcom/pri/anim/spring/SpringSystem;

.field final synthetic this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;


# direct methods
.method constructor <init>(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)V
    .locals 0

    .line 343
    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-direct {p0}, Lcom/pri/anim/spring/SimpleSpringListener;-><init>()V

    .line 344
    invoke-virtual {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->createAnimationAttributes()Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mAnimAttributes:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;

    .line 345
    invoke-static {}, Lcom/pri/anim/spring/SpringSystem;->create()Lcom/pri/anim/spring/SpringSystem;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mSpringSystem:Lcom/pri/anim/spring/SpringSystem;

    .line 346
    invoke-virtual {p1}, Lcom/pri/anim/spring/BaseSpringSystem;->createSpring()Lcom/pri/anim/spring/Spring;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/anim/spring/Spring;->addListener(Lcom/pri/anim/spring/SpringListener;)Lcom/pri/anim/spring/Spring;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mSpring:Lcom/pri/anim/spring/Spring;

    return-void
.end method


# virtual methods
.method public getStateId()I
    .locals 0

    const/4 p0, 0x4

    return p0
.end method

.method public handleEntryTransition(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V
    .locals 3

    .line 376
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$300(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollStateListener;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    .line 377
    invoke-interface {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;->getStateId()I

    move-result p1

    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->getStateId()I

    move-result v2

    .line 376
    invoke-interface {v0, v1, p1, v2}, Lcom/pri/support/common/IOverScrollStateListener;->onOverScrollStateChange(Lcom/pri/support/common/IOverScrollDecor;II)V

    const/4 p1, 0x1

    .line 378
    invoke-virtual {p0, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->startSpringBack(Z)Z

    move-result p1

    if-nez p1, :cond_0

    .line 379
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$600(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    :cond_0
    return-void
.end method

.method public handleMoveTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 385
    iget-boolean p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mDisableCancelAnimOnMoveEvent:Z

    if-nez p1, :cond_0

    iget-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mSpring:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p1}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result p1

    if-nez p1, :cond_0

    .line 386
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mSpring:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->setAtRest()Lcom/pri/anim/spring/Spring;

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method public handleUpOrCancelTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    const/4 p1, 0x0

    .line 393
    iput-boolean p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mDisableCancelAnimOnMoveEvent:Z

    const/4 p0, 0x1

    return p0
.end method

.method public onSpringAtRest(Lcom/pri/anim/spring/Spring;)V
    .locals 0

    .line 409
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$600(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    return-void
.end method

.method public onSpringUpdate(Lcom/pri/anim/spring/Spring;)V
    .locals 2

    .line 399
    invoke-virtual {p1}, Lcom/pri/anim/spring/Spring;->getCurrentValue()D

    move-result-wide v0

    double-to-float p1, v0

    .line 400
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-virtual {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object v1

    invoke-virtual {v0, v1, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->translateView(Landroid/view/View;F)V

    .line 402
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$500(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollUpdateListener;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    .line 403
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->getStateId()I

    move-result p0

    .line 402
    invoke-interface {v0, v1, p0, p1}, Lcom/pri/support/common/IOverScrollUpdateListener;->onOverScrollUpdate(Lcom/pri/support/common/IOverScrollDecor;IF)V

    return-void
.end method

.method startSpringBack(Z)Z
    .locals 3

    .line 356
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-virtual {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object v0

    .line 357
    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mAnimAttributes:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;

    invoke-virtual {v1, v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->init(Landroid/view/View;)V

    .line 359
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mAnimAttributes:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;

    iget v0, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mAbsOffset:F

    float-to-int v0, v0

    .line 360
    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$600(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    move-result-object v1

    invoke-static {v1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->access$700(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;)F

    move-result v1

    float-to-int v1, v1

    if-eq v0, v1, :cond_0

    .line 363
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mSpring:Lcom/pri/anim/spring/Spring;

    sget-object v1, Lcom/pri/anim/spring/SpringOverScroller;->RUBBERBANDING_CONFIG:Lcom/pri/anim/spring/SpringConfig;

    invoke-virtual {v0, v1}, Lcom/pri/anim/spring/Spring;->setSpringConfig(Lcom/pri/anim/spring/SpringConfig;)Lcom/pri/anim/spring/Spring;

    .line 364
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mSpring:Lcom/pri/anim/spring/Spring;

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mAnimAttributes:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;

    iget v1, v1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mAbsOffset:F

    float-to-double v1, v1

    invoke-virtual {v0, v1, v2, p1}, Lcom/pri/anim/spring/Spring;->setCurrentValue(DZ)Lcom/pri/anim/spring/Spring;

    .line 365
    iget-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mSpring:Lcom/pri/anim/spring/Spring;

    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$600(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    move-result-object p0

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->access$700(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;)F

    move-result p0

    float-to-double v0, p0

    invoke-virtual {p1, v0, v1}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
