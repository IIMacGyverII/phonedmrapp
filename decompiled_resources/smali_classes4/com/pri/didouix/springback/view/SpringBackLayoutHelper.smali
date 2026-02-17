.class public Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;
.super Ljava/lang/Object;
.source "SpringBackLayoutHelper.java"


# static fields
.field private static final INVALID_POINTER:I = -0x1


# instance fields
.field mActivePointerId:I

.field mInitialDownX:F

.field mInitialDownY:F

.field mScrollOrientation:I

.field private mTarget:Landroid/view/ViewGroup;

.field mTargetScrollOrientation:I

.field private mTouchSlop:I


# direct methods
.method public constructor <init>(Landroid/view/ViewGroup;I)V
    .locals 1

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, -0x1

    .line 15
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mActivePointerId:I

    .line 24
    iput-object p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTarget:Landroid/view/ViewGroup;

    .line 25
    iput p2, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTargetScrollOrientation:I

    .line 26
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTouchSlop:I

    return-void
.end method


# virtual methods
.method public checkOrientation(Landroid/view/MotionEvent;)V
    .locals 5

    .line 57
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_6

    const/4 v2, 0x1

    if-eq v0, v2, :cond_5

    const/4 v3, 0x2

    if-ne v0, v3, :cond_4

    .line 62
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mActivePointerId:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_3

    .line 63
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    if-ltz v0, :cond_3

    .line 64
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getY(I)F

    move-result v1

    .line 65
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    .line 66
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mInitialDownY:F

    sub-float/2addr v1, v0

    .line 67
    iget v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mInitialDownX:F

    sub-float/2addr p1, v0

    .line 68
    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result v0

    iget v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTouchSlop:I

    int-to-float v4, v4

    cmpl-float v0, v0, v4

    if-gtz v0, :cond_1

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v0

    iget v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTouchSlop:I

    int-to-float v4, v4

    cmpl-float v0, v0, v4

    if-lez v0, :cond_0

    goto :goto_0

    :cond_0
    return-void

    .line 69
    :cond_1
    :goto_0
    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result p1

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v0

    cmpg-float p1, p1, v0

    if-gtz p1, :cond_2

    move v2, v3

    .line 72
    :cond_2
    iput v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mScrollOrientation:I

    :cond_3
    return-void

    :cond_4
    const/4 p1, 0x3

    if-eq v0, p1, :cond_5

    return-void

    .line 82
    :cond_5
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mScrollOrientation:I

    .line 83
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTarget:Landroid/view/ViewGroup;

    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V

    return-void

    .line 86
    :cond_6
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mActivePointerId:I

    .line 87
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    if-ltz v0, :cond_7

    .line 89
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getY(I)F

    move-result v2

    iput v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mInitialDownY:F

    .line 90
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mInitialDownX:F

    .line 91
    iput v1, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mScrollOrientation:I

    :cond_7
    return-void
.end method

.method public isTouchInTarget(Landroid/view/MotionEvent;)Z
    .locals 5

    const/4 v0, 0x0

    .line 41
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v1

    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v1

    if-gez v1, :cond_0

    return v0

    .line 45
    :cond_0
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getY(I)F

    move-result v2

    .line 46
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getX(I)F

    move-result p1

    const/4 v1, 0x2

    new-array v1, v1, [I

    .line 47
    fill-array-data v1, :array_0

    .line 48
    iget-object v3, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTarget:Landroid/view/ViewGroup;

    invoke-virtual {v3, v1}, Landroid/view/ViewGroup;->getLocationInWindow([I)V

    aget v0, v1, v0

    const/4 v3, 0x1

    aget v1, v1, v3

    .line 51
    new-instance v3, Landroid/graphics/Rect;

    iget-object v4, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTarget:Landroid/view/ViewGroup;

    invoke-virtual {v4}, Landroid/view/ViewGroup;->getWidth()I

    move-result v4

    add-int/2addr v4, v0

    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTarget:Landroid/view/ViewGroup;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getHeight()I

    move-result p0

    add-int/2addr p0, v1

    invoke-direct {v3, v0, v1, v4, p0}, Landroid/graphics/Rect;-><init>(IIII)V

    float-to-int p0, p1

    float-to-int p1, v2

    invoke-virtual {v3, p0, p1}, Landroid/graphics/Rect;->contains(II)Z

    move-result p0

    return p0

    :array_0
    .array-data 4
        0x0
        0x0
    .end array-data
.end method

.method public onInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 30
    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->checkOrientation(Landroid/view/MotionEvent;)V

    .line 31
    iget p1, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mScrollOrientation:I

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eqz p1, :cond_1

    .line 32
    iget v2, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTargetScrollOrientation:I

    if-ne p1, v2, :cond_0

    goto :goto_0

    .line 36
    :cond_0
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTarget:Landroid/view/ViewGroup;

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V

    return v1

    .line 33
    :cond_1
    :goto_0
    iget-object p0, p0, Lcom/pri/didouix/springback/view/SpringBackLayoutHelper;->mTarget:Landroid/view/ViewGroup;

    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->requestDisallowInterceptTouchEvent(Z)V

    return v0
.end method
