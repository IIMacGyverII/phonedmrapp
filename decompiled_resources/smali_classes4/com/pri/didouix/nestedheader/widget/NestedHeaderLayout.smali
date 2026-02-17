.class public Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;
.super Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;
.source "NestedHeaderLayout.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "NestedHeaderLayout"


# instance fields
.field public isAniming:Z

.field public isTouch:Z

.field public mAutoAnim:Z

.field private mHeaderBottomMargin:I

.field private mHeaderContentId:I

.field private mHeaderContentMinHeight:F

.field private mHeaderContentView:Landroid/view/View;

.field private mHeaderInitTop:I

.field private mHeaderMeasuredHeight:I

.field private mHeaderTopmMargin:I

.field private mHeaderView:Landroid/view/View;

.field private mHeaderViewId:I

.field private mLastScrollingProgress:I

.field private mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

.field private mOnNestedChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;

.field private mRangeOffset:F

.field public mScrollingFrom:I

.field public mScrollingTo:I

.field private mTriggerBottomMargin:I

.field private mTriggerContentId:I

.field private mTriggerContentMinHeight:F

.field private mTriggerContentView:Landroid/view/View;

.field private mTriggerMeasuredHeight:I

.field private mTriggerTopmMargin:I

.field private mTriggerView:Landroid/view/View;

.field private mTriggerViewId:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 73
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    const/4 v0, 0x0

    .line 77
    invoke-direct {p0, p1, p2, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 2

    .line 81
    invoke-direct {p0, p1, p2, p3}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    const/4 p3, 0x0

    .line 82
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderBottomMargin:I

    .line 83
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderTopmMargin:I

    .line 84
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerBottomMargin:I

    .line 85
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerTopmMargin:I

    .line 86
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderInitTop:I

    .line 87
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderMeasuredHeight:I

    .line 88
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerMeasuredHeight:I

    .line 89
    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mLastScrollingProgress:I

    .line 90
    iput-boolean p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isAniming:Z

    .line 91
    iput-boolean p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isTouch:Z

    const/4 v0, 0x1

    .line 92
    iput-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mAutoAnim:Z

    .line 93
    new-instance v0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;

    invoke-direct {v0, p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;-><init>(Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;)V

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mOnNestedChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;

    .line 119
    sget-object v0, Lcom/pri/R$styleable;->NestedHeaderLayout:[I

    invoke-virtual {p1, p2, v0}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object p2

    .line 120
    sget v0, Lcom/pri/R$styleable;->NestedHeaderLayout_headerView:I

    invoke-virtual {p2, v0, p3}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderViewId:I

    .line 121
    sget v0, Lcom/pri/R$styleable;->NestedHeaderLayout_triggerView:I

    invoke-virtual {p2, v0, p3}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerViewId:I

    .line 122
    sget v0, Lcom/pri/R$styleable;->NestedHeaderLayout_headerContentId:I

    invoke-virtual {p2, v0, p3}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentId:I

    .line 123
    sget v0, Lcom/pri/R$styleable;->NestedHeaderLayout_triggerContentId:I

    invoke-virtual {p2, v0, p3}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result p3

    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerContentId:I

    .line 124
    sget p3, Lcom/pri/R$styleable;->NestedHeaderLayout_headerContentMinHeight:I

    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    sget v1, Lcom/pri/R$dimen;->nested_header_layout_content_min_height:I

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getDimension(I)F

    move-result v0

    invoke-virtual {p2, p3, v0}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result p3

    iput p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentMinHeight:F

    .line 125
    sget p3, Lcom/pri/R$styleable;->NestedHeaderLayout_triggerContentMinHeight:I

    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1, v1}, Landroid/content/res/Resources;->getDimension(I)F

    move-result p1

    invoke-virtual {p2, p3, p1}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerContentMinHeight:F

    .line 126
    sget p1, Lcom/pri/R$styleable;->NestedHeaderLayout_rangeOffset:I

    const/4 p3, 0x0

    invoke-virtual {p2, p1, p3}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mRangeOffset:F

    .line 127
    invoke-virtual {p2}, Landroid/content/res/TypedArray;->recycle()V

    .line 128
    iget-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mOnNestedChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->addOnScrollListener(Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;)V

    return-void
.end method

.method private applyContentAlpha(Ljava/util/List;F)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;F)V"
        }
    .end annotation

    if-eqz p1, :cond_0

    const/4 p0, 0x0

    const/high16 v0, 0x3f800000    # 1.0f

    .line 358
    invoke-static {v0, p2}, Ljava/lang/Math;->min(FF)F

    move-result p2

    invoke-static {p0, p2}, Ljava/lang/Math;->max(FF)F

    move-result p0

    .line 359
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/view/View;

    .line 360
    invoke-virtual {p2, p0}, Landroid/view/View;->setAlpha(F)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private checkSendHeaderChangeListener(IIZ)V
    .locals 1

    .line 225
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    if-eqz v0, :cond_8

    if-eqz p3, :cond_3

    if-nez p2, :cond_0

    .line 227
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result p3

    if-eqz p3, :cond_0

    .line 228
    iget-object p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    invoke-interface {p3, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;->onHeaderOpened(Landroid/view/View;)V

    goto :goto_0

    .line 229
    :cond_0
    iget p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    if-ne p2, p3, :cond_1

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getTriggerViewVisible()Z

    move-result p3

    if-eqz p3, :cond_1

    .line 230
    iget-object p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    invoke-interface {p3, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;->onTriggerOpened(Landroid/view/View;)V

    :cond_1
    :goto_0
    if-gez p1, :cond_2

    if-lez p2, :cond_2

    .line 232
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 233
    iget-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    invoke-interface {p1, p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;->onHeaderOpened(Landroid/view/View;)V

    :cond_2
    return-void

    :cond_3
    if-nez p2, :cond_4

    .line 238
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getTriggerViewVisible()Z

    move-result p3

    if-eqz p3, :cond_4

    .line 239
    iget-object p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    invoke-interface {p3, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;->onTriggerClosed(Landroid/view/View;)V

    goto :goto_1

    .line 240
    :cond_4
    iget p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    if-ne p2, p3, :cond_5

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result p3

    if-eqz p3, :cond_5

    .line 241
    iget-object p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    invoke-interface {p3, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;->onHeaderClosed(Landroid/view/View;)V

    goto :goto_1

    .line 242
    :cond_5
    iget p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    if-ne p2, p3, :cond_6

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result p3

    if-nez p3, :cond_6

    .line 243
    iget-object p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    invoke-interface {p3, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;->onTriggerClosed(Landroid/view/View;)V

    .line 245
    :cond_6
    :goto_1
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result p3

    if-eqz p3, :cond_7

    const/4 p3, 0x0

    goto :goto_2

    .line 248
    :cond_7
    iget p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    :goto_2
    if-le p1, p3, :cond_8

    if-ge p2, p3, :cond_8

    .line 250
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getTriggerViewVisible()Z

    move-result p1

    if-eqz p1, :cond_8

    .line 251
    iget-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    invoke-interface {p1, p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;->onTriggerClosed(Landroid/view/View;)V

    :cond_8
    return-void
.end method

.method private makeContentViewList(Landroid/view/View;Z)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            "Z)",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    if-nez p1, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 340
    :cond_0
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    if-eqz p2, :cond_3

    .line 342
    instance-of p2, p1, Landroid/view/ViewGroup;

    if-eqz p2, :cond_1

    .line 343
    check-cast p1, Landroid/view/ViewGroup;

    const/4 p2, 0x0

    .line 344
    :goto_0
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-ge p2, v0, :cond_2

    .line 345
    invoke-virtual {p1, p2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 p2, p2, 0x1

    goto :goto_0

    .line 348
    :cond_1
    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_2
    return-object p0

    .line 352
    :cond_3
    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-object p0
.end method

.method private makeHeaderContentViewList(Landroid/view/View;)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            ")",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 333
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentId:I

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->makeContentViewList(Landroid/view/View;Z)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method private makeTriggerContentViewList(Landroid/view/View;)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/view/View;",
            ")",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 329
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerContentId:I

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->makeContentViewList(Landroid/view/View;Z)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method private relayoutContent(Landroid/view/View;Landroid/view/View;II)V
    .locals 3

    .line 366
    invoke-virtual {p1}, Landroid/view/View;->getLeft()I

    move-result p0

    invoke-virtual {p1}, Landroid/view/View;->getRight()I

    move-result v0

    invoke-virtual {p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v1

    add-int/2addr v1, p3

    add-int/2addr v1, p4

    invoke-static {p3, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    invoke-virtual {p1, p0, p3, v0, v1}, Landroid/view/View;->layout(IIII)V

    if-eq p1, p2, :cond_0

    .line 368
    invoke-virtual {p2}, Landroid/view/View;->getLeft()I

    move-result p0

    invoke-virtual {p2}, Landroid/view/View;->getTop()I

    move-result p1

    invoke-virtual {p2}, Landroid/view/View;->getRight()I

    move-result p3

    invoke-virtual {p2}, Landroid/view/View;->getTop()I

    move-result v0

    invoke-virtual {p2}, Landroid/view/View;->getTop()I

    move-result v1

    invoke-virtual {p2}, Landroid/view/View;->getMeasuredHeight()I

    move-result v2

    add-int/2addr v1, v2

    add-int/2addr v1, p4

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result p4

    invoke-virtual {p2, p0, p1, p3, p4}, Landroid/view/View;->layout(IIII)V

    :cond_0
    return-void
.end method

.method private updateScrollingRange(ZZZ)V
    .locals 12

    .line 262
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    const/16 v1, 0x8

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v0, :cond_1

    .line 263
    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-ne v0, v1, :cond_0

    goto :goto_0

    .line 267
    :cond_0
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 268
    iget v4, v0, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    iput v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderBottomMargin:I

    .line 269
    iget v0, v0, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    iput v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderTopmMargin:I

    .line 270
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getMeasuredHeight()I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderMeasuredHeight:I

    neg-int v0, v0

    int-to-float v0, v0

    .line 271
    iget v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mRangeOffset:F

    add-float/2addr v0, v4

    iget v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderTopmMargin:I

    int-to-float v4, v4

    sub-float/2addr v0, v4

    iget v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderBottomMargin:I

    int-to-float v4, v4

    sub-float/2addr v0, v4

    float-to-int v0, v0

    add-int/2addr v0, v3

    move v7, v2

    goto :goto_1

    :cond_1
    :goto_0
    move v0, v3

    move v7, v0

    .line 274
    :goto_1
    iget-object v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    if-eqz v4, :cond_4

    .line 275
    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v4

    if-ne v4, v1, :cond_2

    goto :goto_2

    .line 280
    :cond_2
    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 281
    iget v4, v1, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    iput v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerBottomMargin:I

    .line 282
    iget v1, v1, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    iput v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerTopmMargin:I

    .line 283
    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getMeasuredHeight()I

    move-result v1

    iput v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerMeasuredHeight:I

    .line 284
    iget v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerTopmMargin:I

    add-int/2addr v1, v4

    iget v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerBottomMargin:I

    add-int/2addr v1, v4

    add-int/2addr v1, v3

    if-nez v7, :cond_3

    neg-int v0, v1

    move v5, v0

    move v8, v2

    move v6, v3

    goto :goto_3

    :cond_3
    move v5, v0

    move v6, v1

    move v8, v2

    goto :goto_3

    :cond_4
    :goto_2
    move v5, v0

    move v6, v3

    move v8, v6

    .line 295
    :goto_3
    iput v5, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    .line 296
    iput v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    move-object v4, p0

    move v9, p1

    move v10, p2

    move v11, p3

    .line 297
    invoke-virtual/range {v4 .. v11}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->setScrollingRange(IIZZZZZ)V

    return-void
.end method


# virtual methods
.method public autoAdsorption(I)V
    .locals 3

    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 302
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    const/4 v2, 0x0

    aput v1, v0, v2

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    const/4 v2, 0x1

    aput v1, v0, v2

    invoke-static {v0}, Landroid/animation/ValueAnimator;->ofInt([I)Landroid/animation/ValueAnimator;

    move-result-object v0

    .line 303
    invoke-virtual {v0, p0}, Landroid/animation/ValueAnimator;->setTarget(Ljava/lang/Object;)V

    const-wide/16 v1, 0x12c

    .line 304
    invoke-virtual {v0, v1, v2}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;

    move-result-object v1

    invoke-virtual {v1}, Landroid/animation/ValueAnimator;->start()V

    .line 305
    new-instance v1, Landroid/view/animation/LinearInterpolator;

    invoke-direct {v1}, Landroid/view/animation/LinearInterpolator;-><init>()V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 306
    new-instance v1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;

    invoke-direct {v1, p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;-><init>(Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;I)V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    return-void
.end method

.method public getHeaderViewVisible()Z
    .locals 0

    .line 405
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    if-eqz p0, :cond_1

    .line 406
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method public getTriggerViewVisible()Z
    .locals 0

    .line 389
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    if-eqz p0, :cond_1

    .line 390
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method public isAutoAnim()Z
    .locals 0

    .line 377
    iget-boolean p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mAutoAnim:Z

    return p0
.end method

.method public isHeaderOpen()Z
    .locals 1

    .line 483
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result p0

    if-ltz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isTriggerOpen()Z
    .locals 2

    .line 487
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getTriggerViewVisible()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    iget v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    if-ge v0, v1, :cond_1

    :cond_0
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result v0

    if-nez v0, :cond_2

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result p0

    if-ltz p0, :cond_2

    :cond_1
    const/4 p0, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public onFinishInflate()V
    .locals 2
    .annotation build Landroidx/annotation/RequiresApi;
        api = 0x15
    .end annotation

    .line 134
    invoke-super {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onFinishInflate()V

    .line 135
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderViewId:I

    invoke-virtual {p0, v0}, Landroid/widget/FrameLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    .line 136
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerViewId:I

    invoke-virtual {p0, v0}, Landroid/widget/FrameLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    .line 137
    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    if-nez v1, :cond_1

    if-eqz v0, :cond_0

    goto :goto_0

    .line 138
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "The headerView or triggerView attribute is required and must refer to a valid child."

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    :goto_0
    if-eqz v1, :cond_2

    .line 142
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentId:I

    invoke-virtual {v1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentView:Landroid/view/View;

    if-nez v0, :cond_2

    .line 144
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentView:Landroid/view/View;

    .line 147
    :cond_2
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    if-eqz v0, :cond_3

    .line 149
    iget v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerContentId:I

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerContentView:Landroid/view/View;

    :cond_3
    return-void
.end method

.method public onLayout(ZIIII)V
    .locals 0

    .line 164
    invoke-super/range {p0 .. p5}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onLayout(ZIIII)V

    const/4 p1, 0x1

    const/4 p2, 0x0

    .line 165
    invoke-direct {p0, p1, p2, p2}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->updateScrollingRange(ZZZ)V

    return-void
.end method

.method public onScrollingProgressUpdated(I)V
    .locals 12

    .line 172
    invoke-super {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onScrollingProgressUpdated(I)V

    .line 173
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    const/4 v1, 0x0

    const/16 v2, 0x8

    const/high16 v3, 0x3f800000    # 1.0f

    const/4 v4, 0x0

    if-eqz v0, :cond_4

    .line 174
    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-ne v0, v2, :cond_0

    goto :goto_2

    .line 178
    :cond_0
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    invoke-static {v0, p1}, Ljava/lang/Math;->min(II)I

    move-result v0

    invoke-static {v4, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    sub-int v0, p1, v0

    .line 179
    iget v5, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    iget v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    invoke-static {v6, p1}, Ljava/lang/Math;->min(II)I

    move-result v6

    invoke-static {v5, v6}, Ljava/lang/Math;->max(II)I

    move-result v5

    .line 180
    iget v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerTopmMargin:I

    .line 181
    iget-object v7, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    if-eqz v7, :cond_2

    .line 182
    invoke-virtual {v7}, Landroid/view/View;->getVisibility()I

    move-result v7

    if-ne v7, v2, :cond_1

    goto :goto_0

    .line 186
    :cond_1
    iget v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderTopmMargin:I

    iget v7, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderMeasuredHeight:I

    add-int/2addr v6, v7

    iget v7, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderBottomMargin:I

    add-int/2addr v6, v7

    iget v7, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerTopmMargin:I

    add-int/2addr v6, v7

    move v7, v4

    goto :goto_1

    .line 183
    :cond_2
    :goto_0
    iget v7, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerTopmMargin:I

    iget v8, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerBottomMargin:I

    add-int/2addr v7, v8

    iget v8, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerMeasuredHeight:I

    add-int/2addr v7, v8

    add-int/2addr v5, v7

    .line 189
    :goto_1
    iget-object v8, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerContentView:Landroid/view/View;

    if-nez v8, :cond_3

    .line 191
    iget-object v8, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    .line 193
    :cond_3
    iget-object v9, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    iget v10, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerBottomMargin:I

    sub-int v10, v5, v10

    iget v11, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerTopmMargin:I

    sub-int/2addr v10, v11

    iget v11, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerMeasuredHeight:I

    sub-int/2addr v10, v11

    invoke-direct {p0, v9, v8, v6, v10}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->relayoutContent(Landroid/view/View;Landroid/view/View;II)V

    .line 194
    iget v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerBottomMargin:I

    sub-int/2addr v5, v6

    int-to-float v5, v5

    iget v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerContentMinHeight:F

    div-float/2addr v5, v6

    .line 195
    iget-object v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    invoke-static {v3, v5}, Ljava/lang/Math;->min(FF)F

    move-result v9

    invoke-static {v1, v9}, Ljava/lang/Math;->max(FF)F

    move-result v9

    invoke-virtual {v6, v9}, Landroid/view/View;->setAlpha(F)V

    .line 196
    invoke-direct {p0, v8}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->makeTriggerContentViewList(Landroid/view/View;)Ljava/util/List;

    move-result-object v6

    sub-float/2addr v5, v3

    invoke-direct {p0, v6, v5}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->applyContentAlpha(Ljava/util/List;F)V

    goto :goto_3

    :cond_4
    :goto_2
    move v0, p1

    move v7, v4

    .line 198
    :goto_3
    iget-object v5, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    if-eqz v5, :cond_6

    .line 199
    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I

    move-result v5

    if-eq v5, v2, :cond_6

    .line 200
    iget v2, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderInitTop:I

    iget v5, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderTopmMargin:I

    add-int/2addr v2, v5

    .line 201
    iget-object v5, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentView:Landroid/view/View;

    if-nez v5, :cond_5

    .line 203
    iget-object v5, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    .line 205
    :cond_5
    iget-object v6, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    invoke-direct {p0, v6, v5, v2, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->relayoutContent(Landroid/view/View;Landroid/view/View;II)V

    .line 206
    iget v2, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderContentMinHeight:F

    int-to-float v0, v0

    add-float/2addr v0, v2

    div-float/2addr v0, v2

    .line 208
    iget-object v2, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    add-float v6, v0, v3

    invoke-static {v3, v6}, Ljava/lang/Math;->min(FF)F

    move-result v3

    invoke-static {v1, v3}, Ljava/lang/Math;->max(FF)F

    move-result v1

    invoke-virtual {v2, v1}, Landroid/view/View;->setAlpha(F)V

    .line 209
    invoke-direct {p0, v5}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->makeHeaderContentViewList(Landroid/view/View;)Ljava/util/List;

    move-result-object v1

    invoke-direct {p0, v1, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->applyContentAlpha(Ljava/util/List;F)V

    .line 210
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderMeasuredHeight:I

    iget v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderTopmMargin:I

    add-int/2addr v0, v1

    iget v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderBottomMargin:I

    add-int v7, v0, v1

    .line 212
    :cond_6
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollableView:Landroid/view/View;

    add-int/2addr v7, p1

    invoke-virtual {v0}, Landroid/view/View;->getTop()I

    move-result v1

    sub-int/2addr v7, v1

    invoke-virtual {v0, v7}, Landroid/view/View;->offsetTopAndBottom(I)V

    .line 213
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mLastScrollingProgress:I

    sub-int v1, p1, v0

    if-lez v1, :cond_7

    const/4 v1, 0x1

    .line 215
    invoke-direct {p0, v0, p1, v1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->checkSendHeaderChangeListener(IIZ)V

    goto :goto_4

    :cond_7
    if-gez v1, :cond_8

    .line 217
    invoke-direct {p0, v0, p1, v4}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->checkSendHeaderChangeListener(IIZ)V

    .line 219
    :cond_8
    :goto_4
    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mLastScrollingProgress:I

    .line 220
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isHeaderOpen()Z

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->updateHeaderOpen(Z)V

    return-void
.end method

.method public onSizeChanged(IIII)V
    .locals 0

    .line 155
    invoke-super {p0, p1, p2, p3, p4}, Landroid/widget/FrameLayout;->onSizeChanged(IIII)V

    .line 156
    iget-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    if-eqz p1, :cond_0

    .line 158
    invoke-virtual {p1}, Landroid/view/View;->getTop()I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderInitTop:I

    :cond_0
    return-void
.end method

.method public removeNestedHeaderChangedListener()V
    .locals 1

    const/4 v0, 0x0

    .line 69
    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    return-void
.end method

.method public setAutoAllClose(Z)V
    .locals 1

    if-eqz p1, :cond_1

    .line 445
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result p1

    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    if-gt p1, v0, :cond_0

    goto :goto_0

    .line 448
    :cond_0
    invoke-virtual {p0, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V

    goto :goto_1

    .line 446
    :cond_1
    :goto_0
    iget p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->syncScrollingProgress(I)V

    :goto_1
    return-void
.end method

.method public setAutoAllOpen(Z)V
    .locals 1

    if-eqz p1, :cond_1

    .line 475
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result p1

    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    if-lt p1, v0, :cond_0

    goto :goto_0

    .line 478
    :cond_0
    invoke-virtual {p0, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V

    goto :goto_1

    .line 476
    :cond_1
    :goto_0
    iget p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->syncScrollingProgress(I)V

    :goto_1
    return-void
.end method

.method public setAutoAnim(Z)V
    .locals 0

    .line 373
    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mAutoAnim:Z

    return-void
.end method

.method public setAutoHeaderClose(Z)V
    .locals 2

    .line 434
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    iget v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    if-le v0, v1, :cond_1

    if-eqz p1, :cond_0

    .line 436
    invoke-virtual {p0, v1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V

    goto :goto_0

    .line 437
    :cond_0
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 438
    iget p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->syncScrollingProgress(I)V

    :cond_1
    :goto_0
    return-void
.end method

.method public setAutoHeaderOpen(Z)V
    .locals 1

    .line 464
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    if-gez v0, :cond_1

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    .line 466
    invoke-virtual {p0, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V

    goto :goto_0

    .line 468
    :cond_0
    invoke-virtual {p0, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->syncScrollingProgress(I)V

    :cond_1
    :goto_0
    return-void
.end method

.method public setAutoTriggerClose(Z)V
    .locals 2

    .line 420
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getTriggerViewVisible()Z

    move-result v0

    const/4 v1, -0x1

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    .line 421
    :cond_1
    :goto_0
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getTriggerViewVisible()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getHeaderViewVisible()Z

    move-result v0

    :cond_2
    move v0, v1

    :goto_1
    if-eq v0, v1, :cond_3

    if-eqz p1, :cond_3

    .line 426
    invoke-virtual {p0, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V

    goto :goto_2

    :cond_3
    if-eq v0, v1, :cond_4

    .line 428
    invoke-virtual {p0, v0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->syncScrollingProgress(I)V

    :cond_4
    :goto_2
    return-void
.end method

.method public setAutoTriggerOpen(Z)V
    .locals 2

    .line 454
    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->getTriggerViewVisible()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    iget v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    if-ge v0, v1, :cond_1

    if-eqz p1, :cond_0

    .line 456
    invoke-virtual {p0, v1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V

    goto :goto_0

    .line 458
    :cond_0
    invoke-virtual {p0, v1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->syncScrollingProgress(I)V

    :cond_1
    :goto_0
    return-void
.end method

.method public setHeaderViewVisible(Z)V
    .locals 3

    .line 397
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mHeaderView:Landroid/view/View;

    if-eqz v0, :cond_1

    const/4 v1, 0x0

    if-eqz p1, :cond_0

    move v2, v1

    goto :goto_0

    :cond_0
    const/16 v2, 0x8

    .line 399
    :goto_0
    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 400
    invoke-direct {p0, v1, v1, p1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->updateScrollingRange(ZZZ)V

    :cond_1
    return-void
.end method

.method public setNestedHeaderChangedListener(Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;)V
    .locals 0

    .line 65
    iput-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mNestedHeaderChangedListener:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$NestedHeaderChangedListener;

    return-void
.end method

.method public setTriggerViewVisible(Z)V
    .locals 3

    .line 381
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mTriggerView:Landroid/view/View;

    if-eqz v0, :cond_1

    const/4 v1, 0x0

    if-eqz p1, :cond_0

    move v2, v1

    goto :goto_0

    :cond_0
    const/16 v2, 0x8

    .line 383
    :goto_0
    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 384
    invoke-direct {p0, v1, p1, v1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->updateScrollingRange(ZZZ)V

    :cond_1
    return-void
.end method

.method public syncScrollingProgress(I)V
    .locals 0

    .line 324
    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->updateScrollingProgress(I)V

    .line 325
    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->onScrollingProgressUpdated(I)V

    return-void
.end method
