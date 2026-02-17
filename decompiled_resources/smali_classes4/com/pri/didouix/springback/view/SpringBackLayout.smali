.class public Lcom/pri/didouix/springback/view/SpringBackLayout;
.super Landroid/view/ViewGroup;
.source "SpringBackLayout.java"

# interfaces
.implements Landroidx/core/view/NestedScrollingParent3;
.implements Landroidx/core/view/NestedScrollingChild3;
.implements Lcom/pri/didouix/core/view/NestedCurrentFling;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;,
        Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;
    }
.end annotation


# static fields
.field public static final ANGLE:I = 0x4

.field public static final HORIZONTAL:I = 0x1

.field private static final INVALID_ID:I = -0x1

.field private static final INVALID_POINTER:I = -0x1

.field private static final MAX_FLING_CONSUME_COUNTER:I = 0x4

.field public static final SPRING_BACK_BOTTOM:I = 0x2

.field public static final SPRING_BACK_TOP:I = 0x1

.field public static final STATE_DRAGGING:I = 0x1

.field public static final STATE_IDLE:I = 0x0

.field public static final STATE_SETTLING:I = 0x2

.field private static final TAG:Ljava/lang/String; = "SpringBackLayout"

.field public static final UNCHECK_ORIENTATION:I = 0x0

.field private static final VELOCITY_THRADHOLD:I = 0x7d0

.field public static final VERTICAL:I = 0x2


# instance fields
.field private consumeNestFlingCounter:I

.field private mActivePointerId:I

.field private mHelper:Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

.field private mInitialDownX:F

.field private mInitialDownY:F

.field private mInitialMotionX:F

.field private mInitialMotionY:F

.field private mIsBeingDragged:Z

.field private mNestedFlingInProgress:Z

.field private mNestedScrollAxes:I

.field private mNestedScrollInProgress:Z

.field private final mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

.field private final mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

.field private final mNestedScrollingV2ConsumedCompat:[I

.field private mOnScrollListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;",
            ">;"
        }
    .end annotation
.end field

.field private mOnSpringListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;

.field private mOriginScrollOrientation:I

.field private final mParentOffsetInWindow:[I

.field private final mParentScrollConsumed:[I

.field private final mScreenHeight:I

.field private final mScreenWith:I

.field private mScrollByFling:Z

.field private mScrollOrientation:I

.field private mScrollState:I

.field private mSpringBackEnable:Z

.field private mSpringBackMode:I

.field private mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

.field private mTarget:Landroid/view/View;

.field private mTargetId:I

.field private mTotalFlingUnconsumed:F

.field private mTotalScrollBottomUnconsumed:F

.field private mTotalScrollTopUnconsumed:F

.field private mTouchSlop:I

.field private mVelocityX:F

.field private mVelocityY:F


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 103
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 5

    .line 107
    invoke-direct {p0, p1, p2}, Landroid/view/ViewGroup;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    const/4 v0, -0x1

    .line 108
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    const/4 v1, 0x0

    .line 109
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    const/4 v2, 0x2

    new-array v3, v2, [I

    .line 110
    iput-object v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mParentScrollConsumed:[I

    new-array v3, v2, [I

    .line 111
    iput-object v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mParentOffsetInWindow:[I

    new-array v3, v2, [I

    .line 112
    iput-object v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingV2ConsumedCompat:[I

    const/4 v3, 0x1

    .line 113
    iput-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    .line 114
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    iput-object v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnScrollListeners:Ljava/util/List;

    .line 115
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollState:I

    .line 116
    new-instance v1, Landroidx/core/view/NestedScrollingParentHelper;

    invoke-direct {v1, p0}, Landroidx/core/view/NestedScrollingParentHelper;-><init>(Landroid/view/ViewGroup;)V

    iput-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

    .line 117
    invoke-static {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->obtain(Landroid/view/View;)Landroidx/core/view/NestedScrollingChildHelper;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    .line 118
    invoke-static {p1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result v1

    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTouchSlop:I

    .line 119
    sget-object v1, Lcom/pri/R$styleable;->SpringBackLayout:[I

    invoke-virtual {p1, p2, v1}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object p2

    .line 120
    sget v1, Lcom/pri/R$styleable;->SpringBackLayout_scrollableView:I

    invoke-virtual {p2, v1, v0}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTargetId:I

    .line 121
    sget v0, Lcom/pri/R$styleable;->SpringBackLayout_scrollOrientation:I

    invoke-virtual {p2, v0, v2}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    .line 122
    sget v0, Lcom/pri/R$styleable;->SpringBackLayout_springBackMode:I

    const/4 v1, 0x3

    invoke-virtual {p2, v0, v1}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackMode:I

    .line 123
    invoke-virtual {p2}, Landroid/content/res/TypedArray;->recycle()V

    .line 124
    new-instance p2, Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-direct {p2}, Lcom/pri/didouix/springback/view/SpringScroller;-><init>()V

    iput-object p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    .line 125
    new-instance p2, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    invoke-direct {p2, p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;-><init>(Landroid/view/ViewGroup;I)V

    iput-object p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mHelper:Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

    .line 126
    invoke-virtual {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->setNestedScrollingEnabled(Z)V

    .line 127
    new-instance p2, Landroid/util/DisplayMetrics;

    invoke-direct {p2}, Landroid/util/DisplayMetrics;-><init>()V

    const-string/jumbo v0, "window"

    .line 128
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/WindowManager;

    invoke-interface {p1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object p1

    invoke-virtual {p1, p2}, Landroid/view/Display;->getMetrics(Landroid/util/DisplayMetrics;)V

    .line 129
    iget p1, p2, Landroid/util/DisplayMetrics;->widthPixels:I

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenWith:I

    .line 130
    iget p1, p2, Landroid/util/DisplayMetrics;->heightPixels:I

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenHeight:I

    return-void
.end method

.method private checkHorizontalScrollStart()V
    .locals 2

    .line 697
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    .line 698
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 699
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    int-to-float v0, v0

    const/4 v1, 0x2

    invoke-direct {p0, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result v0

    .line 700
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v1

    if-gez v1, :cond_0

    .line 701
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    sub-float/2addr v1, v0

    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    goto :goto_0

    .line 703
    :cond_0
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    add-float/2addr v1, v0

    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    .line 705
    :goto_0
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    return-void

    :cond_1
    const/4 v0, 0x0

    .line 708
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    return-void
.end method

.method private checkOrientation(Landroid/view/MotionEvent;)V
    .locals 5

    .line 355
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mHelper:Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

    invoke-virtual {v0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->checkOrientation(Landroid/view/MotionEvent;)V

    .line 356
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x2

    const/4 v3, 0x1

    if-eqz v0, :cond_5

    if-eq v0, v3, :cond_3

    if-eq v0, v2, :cond_1

    const/4 v4, 0x3

    if-eq v0, v4, :cond_3

    const/4 v1, 0x6

    if-ne v0, v1, :cond_0

    .line 362
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    :cond_0
    return-void

    .line 367
    :cond_1
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollOrientation:I

    if-nez p1, :cond_2

    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mHelper:Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

    iget p1, p1, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mScrollOrientation:I

    if-eqz p1, :cond_2

    .line 368
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollOrientation:I

    :cond_2
    return-void

    .line 374
    :cond_3
    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->disallowParentInterceptTouchEvent(Z)V

    .line 375
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    and-int/2addr p1, v2

    if-eqz p1, :cond_4

    .line 376
    invoke-direct {p0, v2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    goto :goto_1

    .line 378
    :cond_4
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    goto :goto_1

    .line 381
    :cond_5
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mHelper:Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

    iget v0, p1, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mInitialDownY:F

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    .line 382
    iget v0, p1, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mInitialDownX:F

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    .line 383
    iget p1, p1, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mActivePointerId:I

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    .line 384
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    if-eqz p1, :cond_6

    .line 385
    iput v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollOrientation:I

    .line 386
    invoke-virtual {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->requestDisallowParentInterceptTouchEvent(Z)V

    goto :goto_0

    .line 387
    :cond_6
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result p1

    if-eqz p1, :cond_7

    .line 388
    iput v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollOrientation:I

    .line 389
    invoke-virtual {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->requestDisallowParentInterceptTouchEvent(Z)V

    goto :goto_0

    .line 391
    :cond_7
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollOrientation:I

    .line 393
    :goto_0
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    and-int/2addr p1, v2

    if-eqz p1, :cond_8

    .line 394
    invoke-direct {p0, v2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkScrollStart(I)V

    goto :goto_1

    .line 396
    :cond_8
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkScrollStart(I)V

    :goto_1
    return-void
.end method

.method private checkScrollStart(I)V
    .locals 1

    const/4 v0, 0x2

    if-ne p1, v0, :cond_0

    .line 690
    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkVerticalScrollStart()V

    goto :goto_0

    .line 692
    :cond_0
    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkHorizontalScrollStart()V

    :goto_0
    return-void
.end method

.method private checkVerticalScrollStart()V
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string v1, "checkVerticalScrollStart() start ... "

    .line 673
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 674
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    .line 675
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 676
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    int-to-float v0, v0

    const/4 v1, 0x2

    invoke-direct {p0, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result v0

    .line 677
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v1

    if-gez v1, :cond_0

    .line 678
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    sub-float/2addr v1, v0

    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    goto :goto_0

    .line 680
    :cond_0
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    add-float/2addr v1, v0

    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    .line 682
    :goto_0
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    return-void

    :cond_1
    const/4 v0, 0x0

    .line 685
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    return-void
.end method

.method private consumeDelta(I[II)V
    .locals 0
    .param p2    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    const/4 p0, 0x2

    if-ne p3, p0, :cond_0

    const/4 p0, 0x1

    .line 1271
    aput p1, p2, p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 1273
    aput p1, p2, p0

    :goto_0
    return-void
.end method

.method private disallowParentInterceptTouchEvent(Z)V
    .locals 0

    .line 348
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 350
    invoke-interface {p0, p1}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    :cond_0
    return-void
.end method

.method private dispatchScrollState(I)V
    .locals 4

    .line 1402
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollState:I

    if-eq v0, p1, :cond_0

    .line 1404
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollState:I

    .line 1405
    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnScrollListeners:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;

    .line 1406
    iget-object v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v3}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result v3

    invoke-interface {v2, v0, p1, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;->onStateChanged(IIZ)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private ensureTarget()V
    .locals 2

    .line 182
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    if-nez v0, :cond_1

    .line 183
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTargetId:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 185
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    goto :goto_0

    .line 187
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "invalid target Id"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 190
    :cond_1
    :goto_0
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    if-eqz v0, :cond_4

    .line 191
    invoke-virtual {p0}, Landroid/view/ViewGroup;->isEnabled()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 192
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    .line 193
    instance-of v1, v0, Landroidx/core/view/NestedScrollingChild3;

    if-eqz v1, :cond_2

    invoke-virtual {v0}, Landroid/view/View;->isNestedScrollingEnabled()Z

    move-result v0

    if-nez v0, :cond_2

    .line 194
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/View;->setNestedScrollingEnabled(Z)V

    .line 197
    :cond_2
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getOverScrollMode()I

    move-result v0

    const/4 v1, 0x2

    if-eq v0, v1, :cond_3

    .line 198
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p0, v1}, Landroid/view/View;->setOverScrollMode(I)V

    :cond_3
    return-void

    .line 203
    :cond_4
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "fail to get target"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private isHorizontalTargetScrollToTop()Z
    .locals 1

    .line 266
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/view/View;->canScrollHorizontally(I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private isTargetScrollOrientation(I)Z
    .locals 0

    .line 270
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollOrientation:I

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isTargetScrollToBottom(I)Z
    .locals 2

    const/4 v0, 0x1

    const/4 v1, 0x2

    if-eq p1, v1, :cond_0

    .line 289
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p0, v0}, Landroid/view/View;->canScrollHorizontally(I)Z

    move-result p0

    xor-int/2addr p0, v0

    return p0

    .line 291
    :cond_0
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    .line 292
    instance-of p1, p0, Landroid/widget/ListView;

    if-eqz p1, :cond_1

    .line 293
    check-cast p0, Landroid/widget/ListView;

    invoke-static {p0, v0}, Landroidx/core/widget/ListViewCompat;->canScrollList(Landroid/widget/ListView;I)Z

    move-result p0

    xor-int/2addr p0, v0

    return p0

    .line 296
    :cond_1
    invoke-virtual {p0, v0}, Landroid/view/View;->canScrollVertically(I)Z

    move-result p0

    xor-int/2addr p0, v0

    .line 297
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "isTargetScrollToBottom() "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "SpringBackLayout"

    invoke-static {v0, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return p0
.end method

.method private isTargetScrollToTop(I)Z
    .locals 2

    const/4 v0, -0x1

    const/4 v1, 0x2

    if-eq p1, v1, :cond_0

    .line 275
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p0, v0}, Landroid/view/View;->canScrollHorizontally(I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    .line 277
    :cond_0
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    .line 278
    instance-of p1, p0, Landroid/widget/ListView;

    if-eqz p1, :cond_1

    .line 279
    check-cast p0, Landroid/widget/ListView;

    invoke-static {p0, v0}, Landroidx/core/widget/ListViewCompat;->canScrollList(Landroid/widget/ListView;I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    .line 282
    :cond_1
    invoke-virtual {p0, v0}, Landroid/view/View;->canScrollVertically(I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    .line 283
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "isTargetScrollToTop() "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "SpringBackLayout"

    invoke-static {v0, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return p0
.end method

.method private isVerticalTargetScrollToTop()Z
    .locals 2

    .line 258
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    .line 259
    instance-of v0, p0, Landroid/widget/ListView;

    const/4 v1, -0x1

    if-eqz v0, :cond_0

    .line 260
    check-cast p0, Landroid/widget/ListView;

    invoke-static {p0, v1}, Landroidx/core/widget/ListViewCompat;->canScrollList(Landroid/widget/ListView;I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    .line 262
    :cond_0
    invoke-virtual {p0, v1}, Landroid/view/View;->canScrollVertically(I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private moveTarget(FI)V
    .locals 2

    .line 793
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "moveTarget() start ... distance: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SpringBackLayout"

    invoke-static {v1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    const/4 v1, 0x2

    if-ne p2, v1, :cond_0

    neg-float p1, p1

    float-to-int p1, p1

    .line 795
    invoke-virtual {p0, v0, p1}, Landroid/view/ViewGroup;->scrollTo(II)V

    goto :goto_0

    :cond_0
    neg-float p1, p1

    float-to-int p1, p1

    .line 797
    invoke-virtual {p0, p1, v0}, Landroid/view/ViewGroup;->scrollTo(II)V

    :goto_0
    return-void
.end method

.method private obtainDampingDistance(FI)F
    .locals 4

    const/4 v0, 0x2

    if-ne p2, v0, :cond_0

    .line 914
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenHeight:I

    goto :goto_0

    :cond_0
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenWith:I

    :goto_0
    const/high16 p2, 0x3f800000    # 1.0f

    .line 915
    invoke-static {p1, p2}, Ljava/lang/Math;->min(FF)F

    move-result p1

    float-to-double p1, p1

    const-wide/high16 v0, 0x4008000000000000L    # 3.0

    .line 916
    invoke-static {p1, p2, v0, v1}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v2

    div-double/2addr v2, v0

    const-wide/high16 v0, 0x4000000000000000L    # 2.0

    invoke-static {p1, p2, v0, v1}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v0

    sub-double/2addr v2, v0

    add-double/2addr v2, p1

    double-to-float p1, v2

    int-to-float p0, p0

    mul-float/2addr p1, p0

    return p1
.end method

.method private obtainMaxSpringBackDistance(I)F
    .locals 1

    const/high16 v0, 0x3f800000    # 1.0f

    .line 910
    invoke-direct {p0, v0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainDampingDistance(FI)F

    move-result p0

    return p0
.end method

.method private obtainSpringBackDistance(FI)F
    .locals 1

    .line 906
    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result p1

    const/4 v0, 0x2

    if-ne p2, v0, :cond_0

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenHeight:I

    goto :goto_0

    :cond_0
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenWith:I

    :goto_0
    int-to-float v0, v0

    div-float/2addr p1, v0

    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {p1, v0}, Ljava/lang/Math;->min(FF)F

    move-result p1

    invoke-direct {p0, p1, p2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainDampingDistance(FI)F

    move-result p0

    return p0
.end method

.method private obtainTouchDistance(FI)F
    .locals 6

    const/4 v0, 0x2

    if-ne p2, v0, :cond_0

    .line 920
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenHeight:I

    goto :goto_0

    :cond_0
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScreenWith:I

    :goto_0
    int-to-double v0, p0

    const-wide v2, 0x3fe5555555555555L    # 0.6666666666666666

    .line 922
    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v2

    int-to-float p0, p0

    const/high16 p2, 0x40400000    # 3.0f

    mul-float/2addr p1, p2

    sub-float/2addr p0, p1

    float-to-double p0, p0

    const-wide v4, 0x3fd5555555555555L    # 0.3333333333333333

    invoke-static {p0, p1, v4, v5}, Ljava/lang/Math;->pow(DD)D

    move-result-wide p0

    mul-double/2addr v2, p0

    sub-double/2addr v0, v2

    double-to-float p0, v0

    return p0
.end method

.method private onHorizontalInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 5

    const/4 v0, 0x1

    .line 468
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v1

    if-nez v1, :cond_0

    return v2

    .line 471
    :cond_0
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportTopSpringBackMode()Z

    move-result v1

    if-nez v1, :cond_1

    return v2

    .line 474
    :cond_1
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportBottomSpringBackMode()Z

    move-result v1

    if-nez v1, :cond_2

    return v2

    .line 477
    :cond_2
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    if-eqz v1, :cond_b

    const/4 v3, -0x1

    if-eq v1, v0, :cond_a

    const/4 v4, 0x2

    if-ne v1, v4, :cond_9

    .line 481
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    const-string v4, "SpringBackLayout"

    if-ne v1, v3, :cond_3

    const-string p0, "Got ACTION_MOVE event but don\'t have an active pointer id."

    .line 483
    invoke-static {v4, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 486
    :cond_3
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v1

    if-gez v1, :cond_4

    const-string p0, "Got ACTION_MOVE event but have an invalid active pointer id."

    .line 488
    invoke-static {v4, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 491
    :cond_4
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    .line 492
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v1

    if-eqz v1, :cond_5

    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v1

    if-eqz v1, :cond_5

    move v1, v0

    goto :goto_0

    :cond_5
    move v1, v2

    :goto_0
    if-nez v1, :cond_6

    .line 495
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v4

    if-nez v4, :cond_7

    :cond_6
    if-eqz v1, :cond_8

    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    cmpg-float v1, p1, v1

    if-gtz v1, :cond_7

    goto :goto_1

    .line 501
    :cond_7
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    sub-float v1, p1, v1

    iget v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTouchSlop:I

    int-to-float v4, v4

    cmpl-float v1, v1, v4

    if-lez v1, :cond_a

    iget-boolean v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-nez v1, :cond_a

    .line 502
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 503
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 504
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    goto :goto_2

    .line 496
    :cond_8
    :goto_1
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    sub-float/2addr v1, p1

    iget v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTouchSlop:I

    int-to-float v4, v4

    cmpl-float v1, v1, v4

    if-lez v1, :cond_a

    iget-boolean v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-nez v1, :cond_a

    .line 497
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 498
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 499
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    goto :goto_2

    :cond_9
    const/4 v0, 0x3

    if-eq v1, v0, :cond_a

    const/4 v0, 0x6

    if-ne v1, v0, :cond_a

    .line 508
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    .line 512
    :cond_a
    :goto_2
    iput-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 513
    iput v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    goto :goto_3

    .line 515
    :cond_b
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v1

    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    .line 516
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v1

    if-gez v1, :cond_c

    return v2

    .line 520
    :cond_c
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    .line 521
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result p1

    if-eqz p1, :cond_d

    .line 522
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 523
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    goto :goto_3

    .line 525
    :cond_d
    iput-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 528
    :goto_3
    iget-boolean p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    return p0
.end method

.method private onHorizontalTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 570
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x1

    .line 571
    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v2

    if-nez v2, :cond_0

    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v2

    if-nez v2, :cond_0

    const/4 p0, 0x0

    return p0

    .line 574
    :cond_0
    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 575
    invoke-direct {p0, p1, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onScrollEvent(Landroid/view/MotionEvent;II)Z

    move-result p0

    return p0

    .line 577
    :cond_1
    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 578
    invoke-direct {p0, p1, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onScrollUpEvent(Landroid/view/MotionEvent;II)Z

    move-result p0

    return p0

    .line 580
    :cond_2
    invoke-direct {p0, p1, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onScrollDownEvent(Landroid/view/MotionEvent;II)Z

    move-result p0

    return p0
.end method

.method private onNestedPreScroll(I[II)V
    .locals 8
    .param p2    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 1142
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollAxes:I

    const/4 v1, 0x0

    const/4 v2, 0x2

    const/4 v3, 0x1

    if-ne v0, v2, :cond_0

    move v0, v3

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    if-eqz v0, :cond_1

    move v4, v2

    goto :goto_1

    :cond_1
    move v4, v3

    :goto_1
    if-eqz v0, :cond_2

    .line 1144
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    goto :goto_2

    :cond_2
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    :goto_2
    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    .line 1146
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "onNestedPreScroll() start2 ...type "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " getScrollY: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " dy: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " mTotalScrollTopUnconsumed: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v6, " mTotalScrollBottomUnconsumed: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    const-string v6, "SpringBackLayout"

    invoke-static {v6, v5}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v5, 0x0

    if-nez p3, :cond_7

    if-lez p1, :cond_4

    .line 1152
    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    cmpl-float v0, p3, v5

    if-lez v0, :cond_4

    int-to-float v0, p1

    cmpl-float v1, v0, p3

    if-lez v1, :cond_3

    float-to-int p1, p3

    .line 1156
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    .line 1157
    iput v5, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    goto :goto_3

    :cond_3
    sub-float/2addr p3, v0

    .line 1159
    iput p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    .line 1160
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    .line 1162
    :goto_3
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 1163
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    invoke-direct {p0, p1, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    invoke-direct {p0, p1, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    return-void

    :cond_4
    if-gez p1, :cond_6

    .line 1169
    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    neg-float v0, p3

    cmpg-float v1, v0, v5

    if-gez v1, :cond_6

    int-to-float v1, p1

    cmpg-float v0, v1, v0

    if-gez v0, :cond_5

    float-to-int p1, p3

    .line 1173
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    .line 1174
    iput v5, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    goto :goto_4

    :cond_5
    add-float/2addr p3, v1

    .line 1176
    iput p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    .line 1177
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    .line 1179
    :goto_4
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 1180
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    invoke-direct {p0, p1, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    neg-float p1, p1

    invoke-direct {p0, p1, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    :cond_6
    return-void

    :cond_7
    if-ne v4, v2, :cond_8

    .line 1187
    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    goto :goto_5

    :cond_8
    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityX:F

    .line 1188
    :goto_5
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "onNestedPreScroll() f6 mVelocityY: "

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v7, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v7, " this.mScrollByFling: "

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v6, v2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    if-lez p1, :cond_d

    .line 1191
    iget v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    cmpl-float v7, v2, v5

    if-lez v7, :cond_d

    const/high16 v7, 0x44fa0000    # 2000.0f

    cmpl-float v7, p3, v7

    if-lez v7, :cond_a

    .line 1194
    invoke-direct {p0, v2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p3

    int-to-float v0, p1

    cmpl-float v1, v0, p3

    if-lez v1, :cond_9

    float-to-int p1, p3

    .line 1197
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    .line 1198
    iput v5, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    goto :goto_6

    .line 1200
    :cond_9
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    sub-float v5, p3, v0

    .line 1202
    invoke-direct {p0, v5, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    .line 1204
    :goto_6
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "onNestedPreScroll() obtainSpringBackDistance: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v6, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1205
    invoke-direct {p0, v5, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    .line 1206
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    return-void

    .line 1209
    :cond_a
    iget-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    if-nez v2, :cond_b

    .line 1210
    iput-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    const-string v2, "onNestedPreScroll springBack Slide up ..."

    .line 1211
    invoke-static {v6, v2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1212
    invoke-direct {p0, p3, v4, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(FIZ)V

    .line 1214
    :cond_b
    iget-object p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p3}, Lcom/pri/didouix/springback/view/SpringScroller;->computeScrollOffset()Z

    move-result p3

    if-eqz p3, :cond_c

    .line 1215
    iget-object p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p3}, Lcom/pri/didouix/springback/view/SpringScroller;->getCurrX()I

    move-result p3

    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v1}, Lcom/pri/didouix/springback/view/SpringScroller;->getCurrY()I

    move-result v1

    invoke-virtual {p0, p3, v1}, Landroid/view/ViewGroup;->scrollTo(II)V

    int-to-float p3, v0

    .line 1216
    invoke-direct {p0, p3, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result p3

    iput p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    goto :goto_7

    .line 1218
    :cond_c
    iput v5, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    .line 1220
    :goto_7
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onNestedPreScroll() mTotalScrollTopUnconsumed: "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {v6, p3}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1221
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    return-void

    :cond_d
    if-gez p1, :cond_12

    .line 1227
    iget v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    neg-float v7, v2

    cmpg-float v7, v7, v5

    if-gez v7, :cond_12

    const/high16 v7, -0x3b060000    # -2000.0f

    cmpg-float v7, p3, v7

    if-gez v7, :cond_f

    .line 1230
    invoke-direct {p0, v2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p3

    int-to-float v0, p1

    neg-float v1, p3

    cmpg-float v1, v0, v1

    if-gez v1, :cond_e

    float-to-int p1, p3

    .line 1233
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    .line 1234
    iput v5, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    goto :goto_8

    .line 1236
    :cond_e
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    add-float v5, p3, v0

    .line 1238
    invoke-direct {p0, v5, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    .line 1240
    :goto_8
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "onNestedPreScroll() obtainSpringBackDistance2: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v6, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1241
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    neg-float p1, v5

    .line 1242
    invoke-direct {p0, p1, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    return-void

    .line 1245
    :cond_f
    iget-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    if-nez v2, :cond_10

    .line 1246
    iput-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    const-string v2, "onNestedPreScroll springBack Slide down ..."

    .line 1247
    invoke-static {v6, v2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1248
    invoke-direct {p0, p3, v4, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(FIZ)V

    .line 1250
    :cond_10
    iget-object p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p3}, Lcom/pri/didouix/springback/view/SpringScroller;->computeScrollOffset()Z

    move-result p3

    if-eqz p3, :cond_11

    .line 1251
    iget-object p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p3}, Lcom/pri/didouix/springback/view/SpringScroller;->getCurrX()I

    move-result p3

    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v1}, Lcom/pri/didouix/springback/view/SpringScroller;->getCurrY()I

    move-result v1

    invoke-virtual {p0, p3, v1}, Landroid/view/ViewGroup;->scrollTo(II)V

    int-to-float p3, v0

    .line 1252
    invoke-direct {p0, p3, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result p3

    iput p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    goto :goto_9

    .line 1254
    :cond_11
    iput v5, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    .line 1256
    :goto_9
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onNestedPreScroll() mTotalScrollTopUnconsumed2: "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {v6, p3}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1257
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    return-void

    :cond_12
    if-nez p1, :cond_13

    return-void

    .line 1264
    :cond_13
    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    cmpl-float p3, p3, v5

    if-eqz p3, :cond_14

    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    cmpl-float p3, p3, v5

    if-nez p3, :cond_15

    :cond_14
    iget-boolean p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    if-eqz p3, :cond_15

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p3

    if-nez p3, :cond_15

    .line 1265
    invoke-direct {p0, p1, p2, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeDelta(I[II)V

    :cond_15
    return-void
.end method

.method private onScrollDownEvent(Landroid/view/MotionEvent;II)Z
    .locals 5

    const-string v0, "SpringBackLayout"

    const-string v1, "onScrollDownEvent() start ... "

    .line 715
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-nez p2, :cond_0

    .line 717
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    .line 718
    invoke-direct {p0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkScrollStart(I)V

    goto/16 :goto_2

    :cond_0
    if-eq p2, v1, :cond_c

    const/4 v3, 0x2

    if-ne p2, v3, :cond_4

    .line 721
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p2

    if-gez p2, :cond_1

    const-string p0, "Got ACTION_MOVE event but have an invalid active pointer id."

    .line 723
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 725
    :cond_1
    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-eqz v0, :cond_b

    if-ne p3, v3, :cond_2

    .line 727
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p1

    .line 728
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    sub-float p2, p1, p2

    invoke-static {p2}, Ljava/lang/Math;->signum(F)F

    move-result p2

    .line 729
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    sub-float/2addr p1, v0

    invoke-direct {p0, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    goto :goto_0

    .line 731
    :cond_2
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    .line 732
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    sub-float p2, p1, p2

    invoke-static {p2}, Ljava/lang/Math;->signum(F)F

    move-result p2

    .line 733
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    sub-float/2addr p1, v0

    invoke-direct {p0, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    :goto_0
    mul-float/2addr p2, p1

    const/4 p1, 0x0

    cmpl-float v0, p2, p1

    if-lez v0, :cond_3

    .line 737
    invoke-virtual {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->requestDisallowParentInterceptTouchEvent(Z)V

    .line 738
    invoke-direct {p0, p2, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    goto :goto_2

    .line 740
    :cond_3
    invoke-direct {p0, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    return v2

    :cond_4
    const/4 v4, 0x3

    if-ne p2, v4, :cond_5

    return v2

    :cond_5
    const/4 v4, 0x5

    if-ne p2, v4, :cond_a

    .line 748
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p2

    if-gez p2, :cond_6

    const-string p0, "Got ACTION_POINTER_DOWN event but have an invalid active pointer id."

    .line 750
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    :cond_6
    const-string v4, "Got ACTION_POINTER_DOWN event but have an invalid action index."

    if-ne p3, v3, :cond_8

    .line 754
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p2

    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    sub-float/2addr p2, p3

    .line 755
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result p3

    if-gez p3, :cond_7

    .line 757
    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 760
    :cond_7
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getY(I)F

    move-result v0

    sub-float/2addr v0, p2

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    .line 761
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    goto :goto_1

    .line 763
    :cond_8
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getX(I)F

    move-result p2

    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    sub-float/2addr p2, p3

    .line 764
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result p3

    if-gez p3, :cond_9

    .line 766
    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 769
    :cond_9
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getX(I)F

    move-result v0

    sub-float/2addr v0, p2

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    .line 770
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    .line 772
    :goto_1
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    goto :goto_2

    :cond_a
    const/4 p3, 0x6

    if-ne p2, p3, :cond_b

    .line 774
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    :cond_b
    :goto_2
    return v1

    .line 777
    :cond_c
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p1

    if-gez p1, :cond_d

    const-string p0, "Got ACTION_UP event but don\'t have an active pointer id."

    .line 778
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 781
    :cond_d
    iget-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-eqz p1, :cond_e

    .line 782
    iput-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    const-string p1, "onScrollDownEvent springBack ..."

    .line 783
    invoke-static {v0, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 784
    invoke-direct {p0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    :cond_e
    const/4 p1, -0x1

    .line 786
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    return v2
.end method

.method private onScrollEvent(Landroid/view/MotionEvent;II)Z
    .locals 5

    const-string v0, "SpringBackLayout"

    const-string v1, "onScrollEvent() start ... "

    .line 601
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-nez p2, :cond_0

    .line 603
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    .line 604
    invoke-direct {p0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkScrollStart(I)V

    goto/16 :goto_2

    :cond_0
    if-eq p2, v1, :cond_b

    const/4 v3, 0x2

    if-ne p2, v3, :cond_3

    .line 607
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p2

    if-gez p2, :cond_1

    const-string p0, "Got ACTION_MOVE event but have an invalid active pointer id."

    .line 609
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 611
    :cond_1
    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-eqz v0, :cond_a

    if-ne p3, v3, :cond_2

    .line 613
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p1

    .line 614
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    sub-float p2, p1, p2

    invoke-static {p2}, Ljava/lang/Math;->signum(F)F

    move-result p2

    .line 615
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    sub-float/2addr p1, v0

    invoke-direct {p0, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    goto :goto_0

    .line 617
    :cond_2
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    .line 618
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    sub-float p2, p1, p2

    invoke-static {p2}, Ljava/lang/Math;->signum(F)F

    move-result p2

    .line 619
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    sub-float/2addr p1, v0

    invoke-direct {p0, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    .line 621
    :goto_0
    invoke-virtual {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->requestDisallowParentInterceptTouchEvent(Z)V

    mul-float/2addr p2, p1

    .line 622
    invoke-direct {p0, p2, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    goto :goto_2

    :cond_3
    const/4 v4, 0x3

    if-ne p2, v4, :cond_4

    return v2

    :cond_4
    const/4 v4, 0x5

    if-ne p2, v4, :cond_9

    .line 628
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p2

    if-gez p2, :cond_5

    const-string p0, "Got ACTION_POINTER_DOWN event but have an invalid active pointer id."

    .line 630
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    :cond_5
    const-string v4, "Got ACTION_POINTER_DOWN event but have an invalid action index."

    if-ne p3, v3, :cond_7

    .line 634
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p2

    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    sub-float/2addr p2, p3

    .line 635
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result p3

    if-gez p3, :cond_6

    .line 637
    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 640
    :cond_6
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getY(I)F

    move-result v0

    sub-float/2addr v0, p2

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    .line 641
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    goto :goto_1

    .line 643
    :cond_7
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getX(I)F

    move-result p2

    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    sub-float/2addr p2, p3

    .line 644
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result p3

    if-gez p3, :cond_8

    .line 646
    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 649
    :cond_8
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getX(I)F

    move-result v0

    sub-float/2addr v0, p2

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    .line 650
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    .line 652
    :goto_1
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    goto :goto_2

    :cond_9
    const/4 p3, 0x6

    if-ne p2, p3, :cond_a

    .line 654
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    :cond_a
    :goto_2
    return v1

    .line 657
    :cond_b
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p1

    if-gez p1, :cond_c

    const-string p0, "Got ACTION_UP event but don\'t have an active pointer id."

    .line 658
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 661
    :cond_c
    iget-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-eqz p1, :cond_d

    .line 662
    iput-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    const-string p1, "onScrollEvent springBack ..."

    .line 663
    invoke-static {v0, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 664
    invoke-direct {p0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    :cond_d
    const/4 p1, -0x1

    .line 666
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    return v2
.end method

.method private onScrollUpEvent(Landroid/view/MotionEvent;II)Z
    .locals 5

    const-string v0, "SpringBackLayout"

    const-string v1, "onScrollUpEvent() start ... "

    .line 821
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-nez p2, :cond_0

    .line 823
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    .line 824
    invoke-direct {p0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkScrollStart(I)V

    goto/16 :goto_2

    :cond_0
    if-eq p2, v1, :cond_c

    const/4 v3, 0x2

    if-ne p2, v3, :cond_4

    .line 827
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p2

    if-gez p2, :cond_1

    const-string p0, "Got ACTION_MOVE event but have an invalid active pointer id."

    .line 829
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 831
    :cond_1
    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-eqz v0, :cond_b

    if-ne p3, v3, :cond_2

    .line 833
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p1

    .line 834
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    sub-float/2addr p2, p1

    invoke-static {p2}, Ljava/lang/Math;->signum(F)F

    move-result p2

    .line 835
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    sub-float/2addr v0, p1

    invoke-direct {p0, v0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    goto :goto_0

    .line 837
    :cond_2
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    .line 838
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    sub-float/2addr p2, p1

    invoke-static {p2}, Ljava/lang/Math;->signum(F)F

    move-result p2

    .line 839
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    sub-float/2addr v0, p1

    invoke-direct {p0, v0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result p1

    :goto_0
    mul-float/2addr p2, p1

    const/4 p1, 0x0

    cmpl-float v0, p2, p1

    if-lez v0, :cond_3

    .line 843
    invoke-virtual {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->requestDisallowParentInterceptTouchEvent(Z)V

    neg-float p1, p2

    .line 844
    invoke-direct {p0, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    goto :goto_2

    .line 846
    :cond_3
    invoke-direct {p0, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    return v2

    :cond_4
    const/4 v4, 0x3

    if-ne p2, v4, :cond_5

    return v2

    :cond_5
    const/4 v4, 0x5

    if-ne p2, v4, :cond_a

    .line 854
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p2

    if-gez p2, :cond_6

    const-string p0, "Got ACTION_POINTER_DOWN event but have an invalid active pointer id."

    .line 856
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    :cond_6
    const-string v4, "Got ACTION_POINTER_DOWN event but have an invalid action index."

    if-ne p3, v3, :cond_8

    .line 860
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p2

    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    sub-float/2addr p2, p3

    .line 861
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result p3

    if-gez p3, :cond_7

    .line 863
    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 866
    :cond_7
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getY(I)F

    move-result v0

    sub-float/2addr v0, p2

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    .line 867
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    goto :goto_1

    .line 869
    :cond_8
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getX(I)F

    move-result p2

    iget p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    sub-float/2addr p2, p3

    .line 870
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result p3

    if-gez p3, :cond_9

    .line 872
    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 875
    :cond_9
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getX(I)F

    move-result v0

    sub-float/2addr v0, p2

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownX:F

    .line 876
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionX:F

    .line 878
    :goto_1
    invoke-virtual {p1, p3}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    goto :goto_2

    :cond_a
    const/4 p3, 0x6

    if-ne p2, p3, :cond_b

    .line 880
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    :cond_b
    :goto_2
    return v1

    .line 883
    :cond_c
    iget p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result p1

    if-gez p1, :cond_d

    const-string p0, "Got ACTION_UP event but don\'t have an active pointer id."

    .line 884
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 887
    :cond_d
    iget-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-eqz p1, :cond_e

    .line 888
    iput-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    const-string p1, "onScrollUpEvent springBack ..."

    .line 889
    invoke-static {v0, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 890
    invoke-direct {p0, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    :cond_e
    const/4 p1, -0x1

    .line 892
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    return v2
.end method

.method private onSecondaryPointerUp(Landroid/view/MotionEvent;)V
    .locals 3

    .line 899
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v0

    .line 900
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v1

    iget v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    if-ne v1, v2, :cond_1

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 901
    :goto_0
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    :cond_1
    return-void
.end method

.method private onVerticalInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 6

    const/4 v0, 0x2

    .line 403
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v1

    if-nez v1, :cond_0

    return v2

    .line 406
    :cond_0
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportTopSpringBackMode()Z

    move-result v1

    if-nez v1, :cond_1

    return v2

    .line 409
    :cond_1
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportBottomSpringBackMode()Z

    move-result v1

    if-nez v1, :cond_2

    return v2

    .line 412
    :cond_2
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    const/4 v3, 0x1

    if-eqz v1, :cond_b

    const/4 v4, -0x1

    if-eq v1, v3, :cond_a

    if-ne v1, v0, :cond_9

    .line 416
    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    const-string v5, "SpringBackLayout"

    if-ne v1, v4, :cond_3

    const-string p0, "Got ACTION_MOVE event but don\'t have an active pointer id."

    .line 418
    invoke-static {v5, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 421
    :cond_3
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v1

    if-gez v1, :cond_4

    const-string p0, "Got ACTION_MOVE event but have an invalid active pointer id."

    .line 423
    invoke-static {v5, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 426
    :cond_4
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getY(I)F

    move-result p1

    .line 427
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v1

    if-eqz v1, :cond_5

    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v1

    if-eqz v1, :cond_5

    move v1, v3

    goto :goto_0

    :cond_5
    move v1, v2

    :goto_0
    if-nez v1, :cond_6

    .line 430
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v0

    if-nez v0, :cond_7

    :cond_6
    if-eqz v1, :cond_8

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    cmpg-float v0, p1, v0

    if-gtz v0, :cond_7

    goto :goto_1

    .line 436
    :cond_7
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    sub-float v0, p1, v0

    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTouchSlop:I

    int-to-float v1, v1

    cmpl-float v0, v0, v1

    if-lez v0, :cond_a

    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-nez v0, :cond_a

    .line 437
    iput-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 438
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 439
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    goto :goto_2

    .line 431
    :cond_8
    :goto_1
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    sub-float/2addr v0, p1

    iget v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTouchSlop:I

    int-to-float v1, v1

    cmpl-float v0, v0, v1

    if-lez v0, :cond_a

    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    if-nez v0, :cond_a

    .line 432
    iput-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 433
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 434
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    goto :goto_2

    :cond_9
    const/4 v0, 0x3

    if-eq v1, v0, :cond_a

    const/4 v0, 0x6

    if-ne v1, v0, :cond_a

    .line 443
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onSecondaryPointerUp(Landroid/view/MotionEvent;)V

    .line 447
    :cond_a
    :goto_2
    iput-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 448
    iput v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    goto :goto_3

    .line 450
    :cond_b
    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mActivePointerId:I

    .line 451
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    if-gez v0, :cond_c

    return v2

    .line 455
    :cond_c
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getY(I)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    .line 456
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    if-eqz p1, :cond_d

    .line 457
    iput-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 458
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialDownY:F

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mInitialMotionY:F

    goto :goto_3

    .line 460
    :cond_d
    iput-boolean v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    .line 463
    :goto_3
    iget-boolean p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mIsBeingDragged:Z

    return p0
.end method

.method private onVerticalTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 584
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x2

    .line 585
    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v2

    if-nez v2, :cond_0

    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v2

    if-nez v2, :cond_0

    const/4 p0, 0x0

    return p0

    .line 588
    :cond_0
    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 589
    invoke-direct {p0, p1, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onScrollEvent(Landroid/view/MotionEvent;II)Z

    move-result p0

    return p0

    .line 591
    :cond_1
    invoke-direct {p0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 592
    invoke-direct {p0, p1, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onScrollUpEvent(Landroid/view/MotionEvent;II)Z

    move-result p0

    return p0

    .line 594
    :cond_2
    invoke-direct {p0, p1, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onScrollDownEvent(Landroid/view/MotionEvent;II)Z

    move-result p0

    return p0
.end method

.method private springBack(FIZ)V
    .locals 9

    .line 806
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnSpringListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;

    if-eqz v0, :cond_0

    .line 807
    invoke-interface {v0}, Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;->onSpringBack()Z

    move-result v0

    if-nez v0, :cond_1

    .line 808
    :cond_0
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/view/SpringScroller;->forceStop()V

    .line 809
    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    int-to-float v2, v0

    const/4 v3, 0x0

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    int-to-float v4, v0

    const/4 v5, 0x0

    const/4 v8, 0x0

    move v6, p1

    move v7, p2

    invoke-virtual/range {v1 .. v8}, Lcom/pri/didouix/springback/view/SpringScroller;->scrollByFling(FFFFFIZ)V

    const/4 p1, 0x2

    .line 810
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    if-eqz p3, :cond_1

    .line 812
    invoke-virtual {p0}, Landroid/view/ViewGroup;->postInvalidateOnAnimation()V

    :cond_1
    return-void
.end method

.method private springBack(I)V
    .locals 2

    const/4 v0, 0x0

    const/4 v1, 0x1

    .line 802
    invoke-direct {p0, v0, p1, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(FIZ)V

    return-void
.end method

.method private supportBottomSpringBackMode()Z
    .locals 0

    .line 168
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackMode:I

    and-int/lit8 p0, p0, 0x2

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private supportTopSpringBackMode()Z
    .locals 1

    .line 164
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackMode:I

    const/4 v0, 0x1

    and-int/2addr p0, v0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method


# virtual methods
.method public addOnScrollListener(Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;)V
    .locals 0

    .line 1412
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnScrollListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public computeScroll()V
    .locals 2

    .line 238
    invoke-super {p0}, Landroid/view/ViewGroup;->computeScroll()V

    .line 239
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/view/SpringScroller;->computeScrollOffset()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 240
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/view/SpringScroller;->getCurrX()I

    move-result v0

    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v1}, Lcom/pri/didouix/springback/view/SpringScroller;->getCurrY()I

    move-result v1

    invoke-virtual {p0, v0, v1}, Landroid/view/ViewGroup;->scrollTo(II)V

    .line 241
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result v0

    if-nez v0, :cond_0

    .line 242
    invoke-virtual {p0}, Landroid/view/ViewGroup;->postInvalidateOnAnimation()V

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 244
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    :cond_1
    :goto_0
    return-void
.end method

.method public dispatchNestedFling(FFZ)Z
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string v1, "dispatchNestedFling start ...."

    .line 1382
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1384
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1, p2, p3}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedFling(FFZ)Z

    move-result p0

    return p0
.end method

.method public dispatchNestedPreFling(FF)Z
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string v1, "dispatchNestedPreFling start ...."

    .line 1376
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1378
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1, p2}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedPreFling(FF)Z

    move-result p0

    return p0
.end method

.method public dispatchNestedPreScroll(II[I[I)Z
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string v1, "dispatchNestedPreScroll start ...."

    .line 1388
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1389
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1, p2, p3, p4}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedPreScroll(II[I[I)Z

    move-result p0

    return p0
.end method

.method public dispatchNestedPreScroll(II[I[II)Z
    .locals 8

    const-string v0, "SpringBackLayout"

    const-string v1, "dispatchNestedPreScroll start ...."

    .line 1371
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1372
    iget-object v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    move v3, p1

    move v4, p2

    move-object v5, p3

    move-object v6, p4

    move v7, p5

    invoke-virtual/range {v2 .. v7}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedPreScroll(II[I[II)Z

    move-result p0

    return p0
.end method

.method public dispatchNestedScroll(IIII[II[I)V
    .locals 8
    .param p5    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param
    .param p7    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    const-string v0, "SpringBackLayout"

    const-string v1, "dispatchNestedScroll start2 ...."

    .line 1341
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1342
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move-object v5, p5

    move v6, p6

    move-object v7, p7

    invoke-virtual/range {v0 .. v7}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedScroll(IIII[II[I)V

    return-void
.end method

.method public dispatchNestedScroll(IIII[II)Z
    .locals 9

    const-string v0, "SpringBackLayout"

    const-string v1, "dispatchNestedScroll start ...."

    .line 1366
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1367
    iget-object v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    move v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    move-object v7, p5

    move v8, p6

    invoke-virtual/range {v2 .. v8}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedScroll(IIII[II)Z

    move-result p0

    return p0
.end method

.method public dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 302
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x2

    const/4 v2, 0x1

    if-nez v0, :cond_0

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollState:I

    if-ne v0, v1, :cond_0

    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mHelper:Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

    invoke-virtual {v0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->isTouchInTarget(Landroid/view/MotionEvent;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 303
    invoke-direct {p0, v2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 305
    :cond_0
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    .line 306
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p1

    if-ne p1, v2, :cond_1

    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollState:I

    if-eq p1, v1, :cond_1

    const/4 p1, 0x0

    .line 307
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    :cond_1
    return v0
.end method

.method public getSpringBackMode()I
    .locals 0

    .line 151
    iget p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackMode:I

    return p0
.end method

.method public hasNestedScrollingParent(I)Z
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string v1, "hasNestedScrollingParent start ...."

    .line 1361
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1362
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->hasNestedScrollingParent(I)Z

    move-result p0

    return p0
.end method

.method public hasSpringListener()Z
    .locals 0

    .line 1424
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnSpringListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public internalRequestDisallowInterceptTouchEvent(Z)V
    .locals 0

    .line 538
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V

    return-void
.end method

.method public isNestedScrollingEnabled()Z
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string v1, "isNestedScrollingEnabled() start ... "

    .line 1282
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1283
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0}, Landroidx/core/view/NestedScrollingChildHelper;->isNestedScrollingEnabled()Z

    move-result p0

    return p0
.end method

.method public onInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 5

    .line 313
    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_9

    invoke-virtual {p0}, Landroid/view/ViewGroup;->isEnabled()Z

    move-result v0

    if-eqz v0, :cond_9

    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedFlingInProgress:Z

    if-nez v0, :cond_9

    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollInProgress:Z

    if-nez v0, :cond_9

    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->isNestedScrollingEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_1

    .line 316
    :cond_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    .line 317
    iget-object v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v2}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result v2

    if-nez v2, :cond_1

    if-nez v0, :cond_1

    .line 318
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/view/SpringScroller;->forceStop()V

    .line 320
    :cond_1
    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportTopSpringBackMode()Z

    move-result v0

    if-nez v0, :cond_2

    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportBottomSpringBackMode()Z

    move-result v0

    if-nez v0, :cond_2

    return v1

    .line 323
    :cond_2
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    and-int/lit8 v2, v0, 0x4

    const/4 v3, 0x2

    const/4 v4, 0x1

    if-eqz v2, :cond_6

    .line 325
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->checkOrientation(Landroid/view/MotionEvent;)V

    .line 326
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    const/4 v2, 0x0

    if-eqz v0, :cond_3

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    and-int/2addr v0, v4

    if-eqz v0, :cond_3

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    int-to-float v0, v0

    cmpl-float v0, v0, v2

    if-nez v0, :cond_3

    return v1

    .line 329
    :cond_3
    invoke-direct {p0, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    if-eqz v0, :cond_4

    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    and-int/2addr v0, v3

    if-eqz v0, :cond_4

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    int-to-float v0, v0

    cmpl-float v0, v0, v2

    if-nez v0, :cond_4

    return v1

    .line 332
    :cond_4
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    if-nez v0, :cond_5

    invoke-direct {p0, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 333
    :cond_5
    invoke-direct {p0, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->disallowParentInterceptTouchEvent(Z)V

    goto :goto_0

    .line 336
    :cond_6
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollOrientation:I

    .line 338
    :cond_7
    :goto_0
    invoke-direct {p0, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    if-eqz v0, :cond_8

    .line 339
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onVerticalInterceptTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0

    .line 341
    :cond_8
    invoke-direct {p0, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    if-eqz v0, :cond_9

    .line 342
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onHorizontalInterceptTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0

    :cond_9
    :goto_1
    return v1
.end method

.method public onLayout(ZIIII)V
    .locals 1

    .line 208
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getMeasuredWidth()I

    move-result p1

    .line 209
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getMeasuredHeight()I

    move-result p2

    .line 210
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getPaddingLeft()I

    move-result p3

    .line 211
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getPaddingTop()I

    move-result p4

    .line 212
    iget-object p5, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getPaddingLeft()I

    move-result v0

    sub-int/2addr p1, v0

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getPaddingRight()I

    move-result v0

    sub-int/2addr p1, v0

    add-int/2addr p1, p3

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getPaddingTop()I

    move-result v0

    sub-int/2addr p2, v0

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getPaddingBottom()I

    move-result p0

    sub-int/2addr p2, p0

    add-int/2addr p2, p4

    invoke-virtual {p5, p3, p4, p1, p2}, Landroid/view/View;->layout(IIII)V

    return-void
.end method

.method public onMeasure(II)V
    .locals 5

    .line 216
    invoke-direct {p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->ensureTarget()V

    .line 217
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v0

    .line 218
    invoke-static {p2}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v1

    .line 219
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v2

    .line 220
    invoke-static {p2}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v3

    .line 221
    iget-object v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p0, v4, p1, p2}, Landroid/view/ViewGroup;->measureChild(Landroid/view/View;II)V

    .line 222
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result p1

    if-le v2, p1, :cond_0

    .line 223
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v2

    .line 225
    :cond_0
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result p1

    if-le v3, p1, :cond_1

    .line 226
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v3

    :cond_1
    const/high16 p1, -0x80000000

    if-eq v0, p1, :cond_2

    .line 229
    iget-object p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p2}, Landroid/view/View;->getMeasuredWidth()I

    move-result v2

    :cond_2
    if-eq v1, p1, :cond_3

    .line 232
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v3

    .line 234
    :cond_3
    invoke-virtual {p0, v2, v3}, Landroid/view/ViewGroup;->setMeasuredDimension(II)V

    return-void
.end method

.method public onNestedCurrentFling(FF)Z
    .locals 0

    .line 1428
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityX:F

    .line 1429
    iput p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    const/4 p0, 0x1

    return p0
.end method

.method public onNestedFling(Landroid/view/View;FFZ)Z
    .locals 1
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    const-string p1, "SpringBackLayout"

    const-string v0, "onNestedFling start ...."

    .line 1331
    invoke-static {p1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1332
    invoke-virtual {p0, p2, p3, p4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchNestedFling(FFZ)Z

    move-result p0

    return p0
.end method

.method public onNestedPreFling(Landroid/view/View;FF)Z
    .locals 1
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    const-string p1, "SpringBackLayout"

    const-string v0, "onNestedPreFling start ...."

    .line 1336
    invoke-static {p1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1337
    invoke-virtual {p0, p2, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchNestedPreFling(FF)Z

    move-result p0

    return p0
.end method

.method public onNestedPreScroll(Landroid/view/View;II[II)V
    .locals 7
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p4    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 1126
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onNestedPreScroll() start ...type "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "SpringBackLayout"

    invoke-static {v0, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1127
    iget-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    if-eqz p1, :cond_1

    .line 1128
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollAxes:I

    const/4 v0, 0x2

    if-ne p1, v0, :cond_0

    .line 1129
    invoke-direct {p0, p3, p4, p5}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onNestedPreScroll(I[II)V

    goto :goto_0

    .line 1131
    :cond_0
    invoke-direct {p0, p2, p4, p5}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onNestedPreScroll(I[II)V

    .line 1134
    :cond_1
    :goto_0
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mParentScrollConsumed:[I

    const/4 v0, 0x0

    .line 1135
    aget v1, p4, v0

    sub-int v2, p2, v1

    const/4 p2, 0x1

    aget v1, p4, p2

    sub-int v3, p3, v1

    const/4 v5, 0x0

    move-object v1, p0

    move-object v4, p1

    move v6, p5

    invoke-virtual/range {v1 .. v6}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchNestedPreScroll(II[I[II)Z

    move-result p0

    if-eqz p0, :cond_2

    .line 1136
    aget p0, p4, v0

    aget p3, p1, v0

    add-int/2addr p0, p3

    aput p0, p4, v0

    .line 1137
    aget p0, p4, p2

    aget p1, p1, p2

    add-int/2addr p0, p1

    aput p0, p4, p2

    :cond_2
    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIII)V
    .locals 10

    const-string v0, "SpringBackLayout"

    const-string v1, "onNestedScroll() TYPE_TOUCH start ... "

    .line 1047
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1048
    iget-object v9, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingV2ConsumedCompat:[I

    const/4 v8, 0x0

    move-object v2, p0

    move-object v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    move v7, p5

    invoke-virtual/range {v2 .. v9}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onNestedScroll(Landroid/view/View;IIIII[I)V

    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIIII)V
    .locals 10
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    const-string v0, "SpringBackLayout"

    const-string v1, "onNestedScroll() start2 ... "

    .line 1042
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, p0

    .line 1043
    iget-object v9, v0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingV2ConsumedCompat:[I

    move-object v2, p0

    move-object v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    move v7, p5

    move/from16 v8, p6

    invoke-virtual/range {v2 .. v9}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onNestedScroll(Landroid/view/View;IIIII[I)V

    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIIII[I)V
    .locals 17
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p7    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    move-object/from16 v8, p0

    move/from16 v9, p6

    .line 926
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onNestedScroll() start type ... "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v10, "onNesteddtUnConsumed"

    invoke-static {v10, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 928
    iget v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollAxes:I

    const/4 v11, 0x0

    const/4 v12, 0x2

    const/4 v13, 0x1

    if-ne v0, v12, :cond_0

    move v14, v13

    goto :goto_0

    :cond_0
    move v14, v11

    :goto_0
    if-eqz v14, :cond_1

    move/from16 v15, p3

    goto :goto_1

    :cond_1
    move/from16 v15, p2

    :goto_1
    if-eqz v14, :cond_2

    .line 930
    aget v0, p7, v13

    goto :goto_2

    :cond_2
    aget v0, p7, v11

    :goto_2
    move/from16 v16, v0

    .line 932
    iget-object v5, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mParentOffsetInWindow:[I

    move-object/from16 v0, p0

    move/from16 v1, p2

    move/from16 v2, p3

    move/from16 v3, p4

    move/from16 v4, p5

    move/from16 v6, p6

    move-object/from16 v7, p7

    invoke-virtual/range {v0 .. v7}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchNestedScroll(IIII[II[I)V

    .line 933
    iget-boolean v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    if-eqz v0, :cond_17

    if-eqz v14, :cond_3

    .line 934
    aget v0, p7, v13

    goto :goto_3

    :cond_3
    aget v0, p7, v11

    :goto_3
    sub-int v0, v0, v16

    if-eqz v14, :cond_4

    sub-int v0, p5, v0

    goto :goto_4

    :cond_4
    sub-int v0, p4, v0

    :goto_4
    if-eqz v0, :cond_5

    move v11, v0

    :cond_5
    if-eqz v14, :cond_6

    move v1, v12

    goto :goto_5

    :cond_6
    move v1, v13

    .line 940
    :goto_5
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "onNestedScroll() dtUnConsumed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " this.mTotalFlingUnconsumed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v3, " this.mSpringScroller.isFinished(): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    .line 942
    invoke-virtual {v3}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " this.mVelocityY: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v3, " this.mScrollByFling: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " isTargetScrollToTop(axis): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 945
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, " isTargetScrollToBottom(axis): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 946
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 940
    invoke-static {v10, v2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v2, 0x4

    const/4 v3, 0x0

    if-gez v11, :cond_f

    .line 947
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToTop(I)Z

    move-result v4

    if-eqz v4, :cond_f

    invoke-direct/range {p0 .. p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportTopSpringBackMode()Z

    move-result v4

    if-nez v4, :cond_7

    goto/16 :goto_8

    :cond_7
    if-eqz v9, :cond_d

    .line 995
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainMaxSpringBackDistance(I)F

    move-result v4

    .line 996
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "onNestedScroll() TYPE_NOT_TOUCH obtainMaxSpringBackDistance2: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v6, " this.mTotalScrollTopUnconsumed: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v6, " mTotalFlingUnconsumed: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v6, " this.consumeNestFlingCounter: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v10, v5}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1000
    iget v5, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    cmpl-float v5, v5, v3

    if-nez v5, :cond_b

    iget v5, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityX:F

    cmpl-float v5, v5, v3

    if-eqz v5, :cond_8

    goto :goto_7

    .line 1007
    :cond_8
    iget v5, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    cmpl-float v3, v5, v3

    if-nez v3, :cond_17

    .line 1008
    iget v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    sub-float/2addr v4, v3

    const-string v3, "onNestedScroll() TYPE_NOT_TOUCH 2 "

    .line 1009
    invoke-static {v10, v3}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1010
    iget v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    if-ge v3, v2, :cond_a

    .line 1011
    invoke-static {v11}, Ljava/lang/Math;->abs(I)I

    move-result v2

    int-to-float v2, v2

    cmpg-float v2, v4, v2

    if-gtz v2, :cond_9

    .line 1012
    iget v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    add-float/2addr v0, v4

    iput v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    .line 1013
    aget v0, p7, v13

    int-to-float v0, v0

    add-float/2addr v0, v4

    float-to-int v0, v0

    aput v0, p7, v13

    goto :goto_6

    .line 1015
    :cond_9
    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-static {v11}, Ljava/lang/Math;->abs(I)I

    move-result v3

    int-to-float v3, v3

    add-float/2addr v2, v3

    iput v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    .line 1016
    aget v2, p7, v13

    add-int/2addr v2, v0

    aput v2, p7, v13

    .line 1018
    :goto_6
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onNestedScroll() TYPE_NOT_TOUCH 3 mTotalFlingUnconsumed: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v10, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1019
    invoke-direct {v8, v12}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 1020
    iget v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-direct {v8, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result v0

    invoke-direct {v8, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    .line 1021
    iget v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    add-int/2addr v0, v13

    iput v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    goto/16 :goto_c

    .line 1025
    :cond_a
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    goto/16 :goto_c

    .line 1001
    :cond_b
    :goto_7
    iput-boolean v13, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    if-eqz v15, :cond_c

    neg-int v0, v11

    int-to-float v0, v0

    cmpg-float v0, v0, v4

    if-gtz v0, :cond_c

    .line 1003
    iget-object v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0, v11}, Lcom/pri/didouix/springback/view/SpringScroller;->setFirstStep(I)V

    :cond_c
    const-string v0, "onNestedScroll() TYPE_NOT_TOUCH 1 "

    .line 1005
    invoke-static {v10, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1006
    invoke-direct {v8, v12}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    goto/16 :goto_c

    .line 1029
    :cond_d
    iget-object v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v2}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result v2

    if-eqz v2, :cond_e

    const-string v2, "onNestedScroll() this.mSpringScroller.isFinished()  "

    .line 1030
    invoke-static {v10, v2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1031
    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    invoke-static {v11}, Ljava/lang/Math;->abs(I)I

    move-result v3

    int-to-float v3, v3

    add-float/2addr v2, v3

    iput v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    .line 1032
    invoke-direct {v8, v13}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 1033
    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    invoke-direct {v8, v2, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result v2

    invoke-direct {v8, v2, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    .line 1034
    aget v1, p7, v13

    add-int/2addr v1, v0

    aput v1, p7, v13

    goto/16 :goto_c

    :cond_e
    const-string v0, "onNestedScroll() else .... "

    .line 1036
    invoke-static {v10, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_c

    :cond_f
    :goto_8
    const-string v4, "onNestedScroll() 1 "

    .line 948
    invoke-static {v10, v4}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    if-lez v11, :cond_17

    .line 949
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollToBottom(I)Z

    move-result v4

    if-eqz v4, :cond_17

    invoke-direct/range {p0 .. p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->supportBottomSpringBackMode()Z

    move-result v4

    if-eqz v4, :cond_17

    const-string v4, "onNestedScroll() 2 "

    .line 950
    invoke-static {v10, v4}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz v9, :cond_15

    .line 952
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainMaxSpringBackDistance(I)F

    move-result v4

    .line 953
    iget v5, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    cmpl-float v5, v5, v3

    if-nez v5, :cond_13

    iget v5, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityX:F

    cmpl-float v5, v5, v3

    if-eqz v5, :cond_10

    goto :goto_a

    .line 959
    :cond_10
    iget v5, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    cmpl-float v3, v5, v3

    if-nez v3, :cond_17

    .line 960
    iget v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    sub-float/2addr v4, v3

    .line 961
    iget v3, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    if-ge v3, v2, :cond_12

    .line 962
    invoke-static {v11}, Ljava/lang/Math;->abs(I)I

    move-result v2

    int-to-float v2, v2

    cmpg-float v2, v4, v2

    if-gtz v2, :cond_11

    .line 963
    iget v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    add-float/2addr v0, v4

    iput v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    .line 964
    aget v0, p7, v13

    int-to-float v0, v0

    add-float/2addr v0, v4

    float-to-int v0, v0

    aput v0, p7, v13

    goto :goto_9

    .line 966
    :cond_11
    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-static {v11}, Ljava/lang/Math;->abs(I)I

    move-result v3

    int-to-float v3, v3

    add-float/2addr v2, v3

    iput v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    .line 967
    aget v2, p7, v13

    add-int/2addr v2, v0

    aput v2, p7, v13

    .line 969
    :goto_9
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onNestedScroll() 3 mTotalFlingUnconsumed: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v10, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 970
    invoke-direct {v8, v12}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 971
    iget v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    invoke-direct {v8, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result v0

    neg-float v0, v0

    invoke-direct {v8, v0, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    .line 972
    iget v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    add-int/2addr v0, v13

    iput v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    goto :goto_c

    .line 976
    :cond_12
    invoke-direct {v8, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    goto :goto_c

    .line 954
    :cond_13
    :goto_a
    iput-boolean v13, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    if-eqz v15, :cond_14

    int-to-float v0, v11

    cmpg-float v0, v0, v4

    if-gtz v0, :cond_14

    .line 956
    iget-object v0, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0, v11}, Lcom/pri/didouix/springback/view/SpringScroller;->setFirstStep(I)V

    .line 958
    :cond_14
    invoke-direct {v8, v12}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    goto :goto_c

    .line 981
    :cond_15
    iget-object v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v2}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result v2

    if-eqz v2, :cond_17

    if-eqz v14, :cond_16

    .line 983
    invoke-virtual/range {p0 .. p0}, Landroid/view/ViewGroup;->computeVerticalScrollOffset()I

    move-result v2

    goto :goto_b

    :cond_16
    invoke-virtual/range {p0 .. p0}, Landroid/view/ViewGroup;->computeHorizontalScrollOffset()I

    move-result v2

    .line 984
    :goto_b
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "onNestedScroll() 4 isFinished() this.mTotalScrollBottomUnconsumed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v4, " currentNestedScrollY: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v10, v2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 988
    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    invoke-static {v11}, Ljava/lang/Math;->abs(I)I

    move-result v3

    int-to-float v3, v3

    add-float/2addr v2, v3

    iput v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    .line 989
    invoke-direct {v8, v13}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 990
    iget v2, v8, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    invoke-direct {v8, v2, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainSpringBackDistance(FI)F

    move-result v2

    neg-float v2, v2

    invoke-direct {v8, v2, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->moveTarget(FI)V

    .line 991
    aget v1, p7, v13

    add-int/2addr v1, v0

    aput v1, p7, v13

    :cond_17
    :goto_c
    return-void
.end method

.method public onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;I)V
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string v1, "onNestedScrollAccepted() start ... "

    .line 1119
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1120
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

    invoke-virtual {v0, p1, p2, p3}, Landroidx/core/view/NestedScrollingParentHelper;->onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;I)V

    and-int/lit8 p1, p3, 0x2

    .line 1121
    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->startNestedScroll(I)Z

    return-void
.end method

.method public onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;II)V
    .locals 7
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p2    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 1080
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onNestedScrollAccepted() start ... type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SpringBackLayout"

    invoke-static {v1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1081
    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    if-eqz v0, :cond_7

    .line 1083
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollAxes:I

    const/4 v2, 0x2

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-ne v0, v2, :cond_0

    move v0, v4

    goto :goto_0

    :cond_0
    move v0, v3

    :goto_0
    if-nez v0, :cond_1

    move v2, v4

    :cond_1
    if-eqz v0, :cond_2

    .line 1087
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    goto :goto_1

    :cond_2
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    :goto_1
    int-to-float v0, v0

    .line 1088
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "onNestedScrollAccepted() scrollY: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v1, v5}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v1, 0x0

    if-eqz p4, :cond_4

    cmpl-float p4, v0, v1

    if-nez p4, :cond_3

    .line 1091
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    goto :goto_2

    .line 1093
    :cond_3
    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result p4

    invoke-direct {p0, p4, v2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result p4

    iput p4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalFlingUnconsumed:F

    .line 1095
    :goto_2
    iput-boolean v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedFlingInProgress:Z

    .line 1096
    iput v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->consumeNestFlingCounter:I

    goto :goto_4

    :cond_4
    cmpl-float p4, v0, v1

    if-nez p4, :cond_5

    .line 1099
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    .line 1100
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    goto :goto_3

    :cond_5
    cmpg-float p4, v0, v1

    if-gez p4, :cond_6

    .line 1102
    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result p4

    invoke-direct {p0, p4, v2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result p4

    iput p4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    .line 1103
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    goto :goto_3

    .line 1105
    :cond_6
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollTopUnconsumed:F

    .line 1106
    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result p4

    invoke-direct {p0, p4, v2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->obtainTouchDistance(FI)F

    move-result p4

    iput p4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTotalScrollBottomUnconsumed:F

    .line 1108
    :goto_3
    iput-boolean v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollInProgress:Z

    .line 1110
    :goto_4
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    .line 1111
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityX:F

    .line 1112
    iput-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    .line 1113
    iget-object p4, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p4}, Lcom/pri/didouix/springback/view/SpringScroller;->forceStop()V

    .line 1115
    :cond_7
    invoke-virtual {p0, p1, p2, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;I)V

    return-void
.end method

.method public onScrollChanged(IIII)V
    .locals 4

    .line 251
    invoke-super {p0, p1, p2, p3, p4}, Landroid/view/ViewGroup;->onScrollChanged(IIII)V

    .line 252
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnScrollListeners:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;

    sub-int v2, p1, p3

    sub-int v3, p2, p4

    .line 253
    invoke-interface {v1, p0, v2, v3}, Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;->onScrolled(Lcom/pri/didouix/springback/view/SpringBackLayout;II)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public onStartNestedScroll(Landroid/view/View;Landroid/view/View;I)Z
    .locals 0

    const-string p1, "SpringBackLayout"

    const-string p2, "onStartNestedScroll() start ...  "

    .line 1075
    invoke-static {p1, p2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1076
    invoke-virtual {p0}, Landroid/view/ViewGroup;->isEnabled()Z

    move-result p0

    return p0
.end method

.method public onStartNestedScroll(Landroid/view/View;Landroid/view/View;II)Z
    .locals 4
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p2    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 1052
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onStartNestedScroll() start ... type:  "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "SpringBackLayout"

    invoke-static {v0, p2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1053
    iget-boolean p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    const/4 v0, 0x1

    if-eqz p2, :cond_5

    .line 1054
    iput p3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollAxes:I

    const/4 p2, 0x2

    const/4 v1, 0x0

    if-ne p3, p2, :cond_0

    move v2, v0

    goto :goto_0

    :cond_0
    move v2, v1

    :goto_0
    if-nez v2, :cond_1

    move p2, v0

    .line 1060
    :cond_1
    iget v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    and-int/2addr p2, v3

    if-eqz p2, :cond_4

    invoke-virtual {p0, p1, p1, p3}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onStartNestedScroll(Landroid/view/View;Landroid/view/View;I)Z

    move-result p1

    if-nez p1, :cond_2

    goto :goto_2

    :cond_2
    if-eqz v2, :cond_3

    .line 1063
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    goto :goto_1

    :cond_3
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result p1

    :goto_1
    int-to-float p1, p1

    if-eqz p4, :cond_5

    const/4 p2, 0x0

    cmpl-float p1, p1, p2

    if-eqz p1, :cond_5

    .line 1064
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    instance-of p1, p1, Landroidx/core/widget/NestedScrollView;

    if-eqz p1, :cond_5

    :cond_4
    :goto_2
    return v1

    .line 1069
    :cond_5
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p3, p4}, Landroidx/core/view/NestedScrollingChildHelper;->startNestedScroll(II)Z

    return v0
.end method

.method public onStopNestedScroll(Landroid/view/View;I)V
    .locals 4
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 1287
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onStopNestedScroll springBack start .... "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SpringBackLayout"

    invoke-static {v1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1288
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

    invoke-virtual {v0, p1, p2}, Landroidx/core/view/NestedScrollingParentHelper;->onStopNestedScroll(Landroid/view/View;I)V

    .line 1289
    invoke-virtual {p0, p2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->stopNestedScroll(I)V

    .line 1290
    iget-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    if-eqz p1, :cond_a

    .line 1292
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollAxes:I

    const/4 p2, 0x1

    const/4 v0, 0x0

    const/4 v2, 0x2

    if-ne p1, v2, :cond_0

    move p1, p2

    goto :goto_0

    :cond_0
    move p1, v0

    :goto_0
    if-eqz p1, :cond_1

    move p2, v2

    .line 1296
    :cond_1
    iget-boolean v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollInProgress:Z

    if-eqz v3, :cond_5

    .line 1297
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollInProgress:Z

    if-eqz p1, :cond_2

    .line 1298
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    goto :goto_1

    :cond_2
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result p1

    :goto_1
    int-to-float p1, p1

    .line 1299
    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedFlingInProgress:Z

    const/4 v3, 0x0

    if-nez v0, :cond_3

    cmpl-float v0, p1, v3

    if-eqz v0, :cond_3

    .line 1300
    invoke-direct {p0, p2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    goto :goto_2

    :cond_3
    cmpl-float p1, p1, v3

    if-eqz p1, :cond_4

    .line 1302
    invoke-direct {p0, v2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    :cond_4
    :goto_2
    const-string p0, "onStopNestedScroll springBack 1."

    .line 1304
    invoke-static {v1, p0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_4

    .line 1305
    :cond_5
    iget-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedFlingInProgress:Z

    if-eqz p1, :cond_9

    .line 1306
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedFlingInProgress:Z

    .line 1307
    iget-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mScrollByFling:Z

    if-eqz p1, :cond_8

    .line 1308
    iget-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result p1

    if-eqz p1, :cond_7

    const-string p1, "onStopNestedScroll springBack 2."

    .line 1309
    invoke-static {v1, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    if-ne p2, v2, :cond_6

    .line 1310
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityY:F

    goto :goto_3

    :cond_6
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mVelocityX:F

    :goto_3
    invoke-direct {p0, p1, p2, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(FIZ)V

    .line 1312
    :cond_7
    invoke-virtual {p0}, Landroid/view/ViewGroup;->postInvalidateOnAnimation()V

    return-void

    :cond_8
    const-string p1, "onStopNestedScroll springBack 3."

    .line 1315
    invoke-static {v1, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1316
    invoke-direct {p0, p2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    goto :goto_4

    .line 1318
    :cond_9
    invoke-direct {p0, p2}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBack(I)V

    const-string p0, "onStopNestedScroll springBack 4."

    .line 1319
    invoke-static {v1, p0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    :goto_4
    const-string p0, "onStopNestedScroll springBack end ...."

    .line 1321
    invoke-static {v1, p0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    :cond_a
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 553
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    .line 554
    invoke-virtual {p0}, Landroid/view/ViewGroup;->isEnabled()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_3

    iget-boolean v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedFlingInProgress:Z

    if-nez v1, :cond_3

    iget-boolean v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollInProgress:Z

    if-nez v1, :cond_3

    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->isNestedScrollingEnabled()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    .line 557
    :cond_0
    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v1}, Lcom/pri/didouix/springback/view/SpringScroller;->isFinished()Z

    move-result v1

    if-nez v1, :cond_1

    if-nez v0, :cond_1

    .line 558
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/view/SpringScroller;->forceStop()V

    :cond_1
    const/4 v0, 0x2

    .line 560
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 561
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onVerticalTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0

    :cond_2
    const/4 v0, 0x1

    .line 563
    invoke-direct {p0, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->isTargetScrollOrientation(I)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 564
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onHorizontalTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0

    :cond_3
    :goto_0
    return v2
.end method

.method public removeOnScrollListener(Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;)V
    .locals 0

    .line 1416
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnScrollListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public requestDisallowInterceptTouchEvent(Z)V
    .locals 1

    .line 532
    invoke-virtual {p0}, Landroid/view/ViewGroup;->isEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    if-nez v0, :cond_1

    .line 533
    :cond_0
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V

    :cond_1
    return-void
.end method

.method public requestDisallowParentInterceptTouchEvent(Z)V
    .locals 1

    .line 542
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    .line 543
    invoke-interface {p0, p1}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    :goto_0
    if-eqz p0, :cond_1

    .line 545
    instance-of v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;

    if-eqz v0, :cond_0

    .line 546
    move-object v0, p0

    check-cast v0, Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {v0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->internalRequestDisallowInterceptTouchEvent(Z)V

    .line 548
    :cond_0
    invoke-interface {p0}, Landroid/view/ViewParent;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    goto :goto_0

    :cond_1
    return-void
.end method

.method public setEnabled(Z)V
    .locals 2

    .line 155
    invoke-super {p0, p1}, Landroid/view/ViewGroup;->setEnabled(Z)V

    .line 156
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    if-eqz v0, :cond_0

    .line 157
    instance-of v1, v0, Landroidx/core/view/NestedScrollingChild3;

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Landroid/view/View;->isNestedScrollingEnabled()Z

    move-result v0

    if-eq p1, v0, :cond_0

    .line 158
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    invoke-virtual {p0, p1}, Landroid/view/View;->setNestedScrollingEnabled(Z)V

    :cond_0
    return-void
.end method

.method public setNestedScrollingEnabled(Z)V
    .locals 0

    .line 1278
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->setNestedScrollingEnabled(Z)V

    return-void
.end method

.method public setOnSpringListener(Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;)V
    .locals 0

    .line 1420
    iput-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOnSpringListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;

    return-void
.end method

.method public setScrollOrientation(I)V
    .locals 0

    .line 142
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mOriginScrollOrientation:I

    .line 143
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mHelper:Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTargetScrollOrientation:I

    return-void
.end method

.method public setSpringBackEnable(Z)V
    .locals 0

    .line 134
    iput-boolean p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    return-void
.end method

.method public setSpringBackMode(I)V
    .locals 0

    .line 147
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackMode:I

    return-void
.end method

.method public setTarget(Landroid/view/View;)V
    .locals 1
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 172
    iput-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    .line 175
    instance-of v0, p1, Landroidx/core/view/NestedScrollingChild3;

    if-eqz v0, :cond_0

    invoke-virtual {p1}, Landroid/view/View;->isNestedScrollingEnabled()Z

    move-result p1

    if-nez p1, :cond_0

    .line 176
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mTarget:Landroid/view/View;

    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Landroid/view/View;->setNestedScrollingEnabled(Z)V

    :cond_0
    return-void
.end method

.method public smoothScrollTo(II)V
    .locals 9

    .line 1393
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    sub-int v0, p1, v0

    if-nez v0, :cond_0

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    sub-int v0, p2, v0

    if-eqz v0, :cond_1

    .line 1394
    :cond_0
    iget-object v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/view/SpringScroller;->forceStop()V

    .line 1395
    iget-object v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringScroller:Lcom/pri/didouix/springback/view/SpringScroller;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollX()I

    move-result v0

    int-to-float v2, v0

    int-to-float v3, p1

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    int-to-float v4, p1

    int-to-float v5, p2

    const/4 v6, 0x0

    const/4 v7, 0x2

    const/4 v8, 0x1

    invoke-virtual/range {v1 .. v8}, Lcom/pri/didouix/springback/view/SpringScroller;->scrollByFling(FFFFFIZ)V

    const/4 p1, 0x2

    .line 1396
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->dispatchScrollState(I)V

    .line 1397
    invoke-virtual {p0}, Landroid/view/ViewGroup;->postInvalidateOnAnimation()V

    :cond_1
    return-void
.end method

.method public springBackEnable()Z
    .locals 0

    .line 138
    iget-boolean p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mSpringBackEnable:Z

    return p0
.end method

.method public startNestedScroll(I)Z
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string/jumbo v1, "startNestedScroll start2 ...."

    .line 1351
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1352
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->startNestedScroll(I)Z

    move-result p0

    return p0
.end method

.method public startNestedScroll(II)Z
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string/jumbo v1, "startNestedScroll start ...."

    .line 1346
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1347
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1, p2}, Landroidx/core/view/NestedScrollingChildHelper;->startNestedScroll(II)Z

    move-result p0

    return p0
.end method

.method public stopNestedScroll()V
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string/jumbo v1, "stopNestedScroll start ...."

    .line 1326
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1327
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0}, Landroidx/core/view/NestedScrollingChildHelper;->stopNestedScroll()V

    return-void
.end method

.method public stopNestedScroll(I)V
    .locals 2

    const-string v0, "SpringBackLayout"

    const-string/jumbo v1, "stopNestedScroll start ...."

    .line 1356
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 1357
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->stopNestedScroll(I)V

    return-void
.end method
