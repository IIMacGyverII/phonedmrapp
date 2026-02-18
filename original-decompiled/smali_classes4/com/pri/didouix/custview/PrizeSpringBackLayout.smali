.class public Lcom/pri/didouix/custview/PrizeSpringBackLayout;
.super Lcom/pri/didouix/springback/view/SpringBackLayout;
.source "PrizeSpringBackLayout.java"


# instance fields
.field private mCurrentTabSelected:Z

.field private mDownX:I

.field private mDownY:I

.field private mRecyclerView:Landroidx/recyclerview/widget/RecyclerView;
    .annotation build Landroidx/annotation/Nullable;
    .end annotation
.end field

.field private mScaledTouchSlop:I

.field private mStateListener:Lcom/pri/didouix/custview/ParentStateListener;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 32
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/custview/PrizeSpringBackLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 0

    .line 36
    invoke-direct {p0, p1, p2}, Lcom/pri/didouix/springback/view/SpringBackLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 37
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mScaledTouchSlop:I

    return-void
.end method


# virtual methods
.method public onInterceptTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 4

    .line 59
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    .line 60
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    float-to-int v1, v1

    .line 61
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v2

    float-to-int v2, v2

    .line 62
    invoke-super {p0, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->onInterceptTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p1

    if-nez v0, :cond_0

    .line 64
    iput v1, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mDownX:I

    .line 65
    iput v2, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mDownY:I

    return p1

    :cond_0
    const/4 v3, 0x2

    if-eq v0, v3, :cond_1

    return p1

    .line 73
    :cond_1
    iget-object v0, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mRecyclerView:Landroidx/recyclerview/widget/RecyclerView;

    if-eqz v0, :cond_3

    .line 74
    iget-boolean p0, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mCurrentTabSelected:Z

    if-eqz p0, :cond_3

    int-to-float p0, v1

    int-to-float v1, v2

    invoke-virtual {v0, p0, v1}, Landroidx/recyclerview/widget/RecyclerView;->findChildViewUnder(FF)Landroid/view/View;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroidx/recyclerview/widget/RecyclerView;->getChildAdapterPosition(Landroid/view/View;)I

    move-result p0

    if-gez p0, :cond_2

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    return p0

    :cond_3
    :goto_0
    return p1
.end method

.method public setCurrentTab(Z)V
    .locals 0

    .line 41
    iput-boolean p1, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mCurrentTabSelected:Z

    return-void
.end method

.method public setRecyclerView(Landroidx/recyclerview/widget/RecyclerView;)V
    .locals 0

    .line 45
    iput-object p1, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mRecyclerView:Landroidx/recyclerview/widget/RecyclerView;

    return-void
.end method

.method public setStateListener(Lcom/pri/didouix/custview/ParentStateListener;)V
    .locals 0

    .line 49
    iput-object p1, p0, Lcom/pri/didouix/custview/PrizeSpringBackLayout;->mStateListener:Lcom/pri/didouix/custview/ParentStateListener;

    return-void
.end method
