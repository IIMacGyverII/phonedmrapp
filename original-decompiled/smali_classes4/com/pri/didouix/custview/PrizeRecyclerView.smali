.class public Lcom/pri/didouix/custview/PrizeRecyclerView;
.super Landroidx/recyclerview/widget/RecyclerView;
.source "PrizeRecyclerView.java"


# instance fields
.field private mDownX:I

.field private mDownY:I

.field protected mScaleTouchSlop:I

.field private touchPoint:Landroid/graphics/Point;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 30
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/custview/PrizeRecyclerView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    const/4 v0, 0x0

    .line 34
    invoke-direct {p0, p1, p2, v0}, Lcom/pri/didouix/custview/PrizeRecyclerView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 0

    .line 38
    invoke-direct {p0, p1, p2, p3}, Landroidx/recyclerview/widget/RecyclerView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 39
    new-instance p2, Landroid/graphics/Point;

    invoke-direct {p2}, Landroid/graphics/Point;-><init>()V

    iput-object p2, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->touchPoint:Landroid/graphics/Point;

    .line 40
    invoke-static {p1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->mScaleTouchSlop:I

    return-void
.end method


# virtual methods
.method public getTouchPoint()Landroid/graphics/Point;
    .locals 0

    .line 84
    iget-object p0, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->touchPoint:Landroid/graphics/Point;

    return-object p0
.end method

.method public onInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 4

    .line 54
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    float-to-int v0, v0

    .line 55
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v1

    float-to-int v1, v1

    .line 56
    invoke-super {p0, p1}, Landroidx/recyclerview/widget/RecyclerView;->onInterceptTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v2

    .line 57
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result p1

    if-nez p1, :cond_0

    .line 59
    iput v0, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->mDownX:I

    .line 60
    iput v1, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->mDownY:I

    goto :goto_0

    :cond_0
    const/4 v3, 0x2

    if-ne p1, v3, :cond_2

    .line 62
    iget p1, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->mDownX:I

    sub-int/2addr p1, v0

    .line 63
    iget v0, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->mDownY:I

    sub-int/2addr v0, v1

    .line 64
    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v1

    iget v3, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->mScaleTouchSlop:I

    if-gt v1, v3, :cond_1

    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result v1

    iget v3, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->mScaleTouchSlop:I

    if-le v1, v3, :cond_2

    :cond_1
    invoke-static {p1}, Ljava/lang/Math;->abs(I)I

    move-result p1

    invoke-static {v0}, Ljava/lang/Math;->abs(I)I

    move-result v0

    if-ge p1, v0, :cond_2

    const/4 p1, 0x1

    .line 65
    invoke-virtual {p0, p1}, Lcom/pri/didouix/custview/PrizeRecyclerView;->requestDisallowParentInterceptTouchEvent(Z)V

    return p1

    :cond_2
    :goto_0
    return v2
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 44
    iget-object v0, p0, Lcom/pri/didouix/custview/PrizeRecyclerView;->touchPoint:Landroid/graphics/Point;

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    float-to-int v1, v1

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v2

    float-to-int v2, v2

    invoke-virtual {v0, v1, v2}, Landroid/graphics/Point;->set(II)V

    .line 45
    invoke-super {p0, p1}, Landroidx/recyclerview/widget/RecyclerView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method public requestDisallowParentInterceptTouchEvent(Z)V
    .locals 1

    .line 73
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    .line 74
    invoke-interface {p0, p1}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    :goto_0
    if-eqz p0, :cond_1

    .line 76
    instance-of v0, p0, Lcom/pri/didouix/springback/view/SpringBackLayout;

    if-eqz v0, :cond_0

    .line 77
    move-object v0, p0

    check-cast v0, Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {v0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->internalRequestDisallowInterceptTouchEvent(Z)V

    .line 79
    :cond_0
    invoke-interface {p0}, Landroid/view/ViewParent;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    goto :goto_0

    :cond_1
    return-void
.end method
