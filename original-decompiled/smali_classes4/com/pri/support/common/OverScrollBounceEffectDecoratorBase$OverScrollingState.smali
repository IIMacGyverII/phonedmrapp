.class Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;
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
    name = "OverScrollingState"
.end annotation


# instance fields
.field mCurrDragState:I

.field final mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

.field final mTouchDragRatioBck:F

.field final mTouchDragRatioFwd:F

.field final synthetic this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;


# direct methods
.method constructor <init>(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;FF)V
    .locals 1

    .line 265
    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 263
    iput v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mCurrDragState:I

    .line 266
    invoke-virtual {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->createMotionAttributes()Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    .line 267
    iput p2, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mTouchDragRatioFwd:F

    .line 268
    iput p3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mTouchDragRatioBck:F

    return-void
.end method


# virtual methods
.method public getStateId()I
    .locals 0

    .line 272
    iget p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mCurrDragState:I

    return p0
.end method

.method public handleEntryTransition(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V
    .locals 2

    .line 331
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v0

    iget-boolean v0, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mDir:Z

    if-eqz v0, :cond_0

    const/4 v0, 0x2

    goto :goto_0

    :cond_0
    const/4 v0, 0x3

    :goto_0
    iput v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mCurrDragState:I

    .line 332
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$300(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollStateListener;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    .line 333
    invoke-interface {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;->getStateId()I

    move-result p1

    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->getStateId()I

    move-result p0

    .line 332
    invoke-interface {v0, v1, p1, p0}, Lcom/pri/support/common/IOverScrollStateListener;->onOverScrollStateChange(Lcom/pri/support/common/IOverScrollDecor;II)V

    return-void
.end method

.method public handleMoveTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 6

    .line 276
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v0

    iget v0, v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mPointerId:I

    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v1

    const/4 v2, 0x1

    if-eq v0, v1, :cond_0

    .line 278
    iget-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$400(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    .line 279
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$400(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

    move-result-object p0

    iput-boolean v2, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;->mDisableCancelAnimOnMoveEvent:Z

    return v2

    .line 283
    :cond_0
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-virtual {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object v0

    .line 284
    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    invoke-virtual {v1, v0, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->init(Landroid/view/View;Landroid/view/MotionEvent;)Z

    move-result v1

    if-nez v1, :cond_1

    return v2

    :cond_1
    const/high16 v1, 0x3f000000    # 0.5f

    .line 288
    iget-object v3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-virtual {v3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v3, v1

    .line 289
    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget-boolean v1, v1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mDir:Z

    iget-object v4, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v4}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v4

    iget-boolean v4, v4, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mDir:Z

    if-ne v1, v4, :cond_2

    iget v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mTouchDragRatioFwd:F

    goto :goto_0

    :cond_2
    iget v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mTouchDragRatioBck:F

    .line 290
    :goto_0
    iget-object v4, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget v5, v4, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mDeltaOffset:F

    div-float/2addr v5, v1

    .line 291
    iget v1, v4, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mAbsOffset:F

    add-float/2addr v1, v5

    .line 292
    iget-boolean v4, v4, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mDir:Z

    if-eqz v4, :cond_3

    .line 293
    invoke-static {v1, v3}, Ljava/lang/Math;->min(FF)F

    move-result v1

    goto :goto_1

    :cond_3
    neg-float v3, v3

    .line 295
    invoke-static {v1, v3}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 298
    :goto_1
    iget-object v3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v3

    iget v3, v3, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mAbsOffset:F

    cmpl-float v3, v1, v3

    if-eqz v3, :cond_7

    .line 299
    iget-object v3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v3

    iget-boolean v3, v3, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mDir:Z

    iget-object v4, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mMoveAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;

    iget-boolean v4, v4, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;->mDir:Z

    if-eq v3, v4, :cond_5

    iget-object v3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    .line 300
    invoke-static {v3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v3

    iget-boolean v3, v3, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mDir:Z

    if-eqz v3, :cond_4

    iget-object v3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v3

    iget v3, v3, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mAbsOffset:F

    cmpl-float v3, v1, v3

    if-gtz v3, :cond_5

    :cond_4
    iget-object v3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    .line 301
    invoke-static {v3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v3

    iget-boolean v3, v3, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mDir:Z

    if-nez v3, :cond_7

    iget-object v3, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v3

    iget v3, v3, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mAbsOffset:F

    cmpg-float v3, v1, v3

    if-gez v3, :cond_7

    .line 302
    :cond_5
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p1

    if-eqz p1, :cond_6

    .line 303
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p1

    invoke-interface {p1, v2}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 310
    :cond_6
    iget-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-virtual {p1, v0, v1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->translateView(Landroid/view/View;F)V

    .line 311
    iget-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$500(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollUpdateListener;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    iget p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mCurrDragState:I

    invoke-interface {p1, v0, p0, v1}, Lcom/pri/support/common/IOverScrollUpdateListener;->onOverScrollUpdate(Lcom/pri/support/common/IOverScrollDecor;IF)V

    return v2

    .line 318
    :cond_7
    iget-object v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {v1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    move-result-object v3

    iget v3, v3, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;->mAbsOffset:F

    invoke-virtual {v1, v0, v3, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->translateViewAndEvent(Landroid/view/View;FLandroid/view/MotionEvent;)V

    .line 319
    iget-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$500(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollUpdateListener;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    iget v1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->mCurrDragState:I

    const/4 v3, 0x0

    invoke-interface {p1, v0, v1, v3}, Lcom/pri/support/common/IOverScrollUpdateListener;->onOverScrollUpdate(Lcom/pri/support/common/IOverScrollDecor;IF)V

    .line 321
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$600(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    return v2
.end method

.method public handleUpOrCancelTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 326
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;->this$0:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;

    invoke-static {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->access$400(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    const/4 p0, 0x0

    return p0
.end method
