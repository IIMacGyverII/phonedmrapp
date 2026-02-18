.class public interface abstract Lcom/pri/anim/spring/IOverScroller;
.super Ljava/lang/Object;
.source "IOverScroller.java"


# virtual methods
.method public abstract abortAnimation()V
.end method

.method public abstract computeScrollOffset()Z
.end method

.method public abstract fling(IIIIIIII)V
.end method

.method public abstract fling(IIIIIIIIII)V
.end method

.method public abstract getCurrVelocity()F
.end method

.method public abstract getCurrX()I
.end method

.method public abstract getCurrY()I
.end method

.method public abstract isFinished()Z
.end method

.method public isScrollingInDirection(FF)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public notifyHorizontalEdgeReached(III)V
    .locals 0

    return-void
.end method

.method public notifyVerticalEdgeReached(III)V
    .locals 0

    return-void
.end method

.method public setFlingConfig(Lcom/pri/anim/spring/SpringConfig;)V
    .locals 0

    return-void
.end method

.method public setFriction(F)V
    .locals 0

    return-void
.end method

.method public setInterpolator(Landroid/view/animation/Interpolator;)V
    .locals 0

    return-void
.end method

.method public setSpringBackConfig(Lcom/pri/anim/spring/SpringConfig;)V
    .locals 0

    return-void
.end method

.method public abstract springBack(IIIIII)Z
.end method

.method public abstract startScroll(IIII)V
.end method

.method public abstract startScroll(IIIII)V
.end method
