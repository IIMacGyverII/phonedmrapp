.class public Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;
.super Landroid/widget/FrameLayout;
.source "NestedScrollingLayout.java"

# interfaces
.implements Landroidx/core/view/NestedScrollingParent3;
.implements Landroidx/core/view/NestedScrollingChild3;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "NestedScrollingLayout"


# instance fields
.field private isFirstsetScrollingRange:Z

.field private isHeaderOpen:Z

.field private mHeaderOpenTime:J

.field private mHeaderViewVisible:Z

.field private mNestedFlingInConsumedProgress:Z

.field private mNestedFlingStartInConsumedTime:J

.field private mNestedScrollAcceptedFling:Z

.field private mNestedScrollInConsumedProgress:Z

.field private final mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

.field private final mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

.field private final mNestedScrollingV2ConsumedCompat:[I

.field private mOnNestedChangedListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;",
            ">;"
        }
    .end annotation
.end field

.field private final mParentOffsetInWindow:[I

.field private final mParentScrollConsumed:[I

.field protected mScrollableView:Landroid/view/View;

.field private mScrollableViewId:I

.field private mScrollingFrom:I

.field private mScrollingProgress:I

.field private mScrollingTo:I

.field private mTriggerViewVisible:Z


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 62
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    const/4 v0, 0x0

    .line 66
    invoke-direct {p0, p1, p2, v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 2

    .line 70
    invoke-direct {p0, p1, p2, p3}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    const/4 p3, 0x2

    new-array v0, p3, [I

    .line 71
    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingV2ConsumedCompat:[I

    new-array v0, p3, [I

    .line 72
    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mParentOffsetInWindow:[I

    new-array p3, p3, [I

    .line 73
    iput-object p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mParentScrollConsumed:[I

    const/4 p3, 0x1

    .line 74
    iput-boolean p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isFirstsetScrollingRange:Z

    const-wide/16 v0, 0x0

    .line 75
    iput-wide v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderOpenTime:J

    .line 76
    iput-wide v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingStartInConsumedTime:J

    const/4 v0, 0x0

    .line 77
    iput-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isHeaderOpen:Z

    .line 78
    iput-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderViewVisible:Z

    .line 79
    iput-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mTriggerViewVisible:Z

    .line 80
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mOnNestedChangedListeners:Ljava/util/List;

    .line 81
    new-instance v0, Landroidx/core/view/NestedScrollingParentHelper;

    invoke-direct {v0, p0}, Landroidx/core/view/NestedScrollingParentHelper;-><init>(Landroid/view/ViewGroup;)V

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

    .line 82
    invoke-static {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->obtain(Landroid/view/View;)Landroidx/core/view/NestedScrollingChildHelper;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    .line 83
    sget-object v0, Lcom/pri/R$styleable;->NestedScrollingLayout:[I

    invoke-virtual {p1, p2, v0}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object p1

    .line 84
    sget p2, Lcom/pri/R$styleable;->NestedScrollingLayout_scrollableView:I

    const v0, 0x102000a

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollableViewId:I

    .line 85
    invoke-virtual {p1}, Landroid/content/res/TypedArray;->recycle()V

    .line 86
    invoke-virtual {p0, p3}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->setNestedScrollingEnabled(Z)V

    return-void
.end method

.method private dispatchScrollingProgressUpdated()V
    .locals 1

    .line 149
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    invoke-virtual {p0, v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onScrollingProgressUpdated(I)V

    return-void
.end method

.method private sendStartNestedScroll(I)V
    .locals 1

    .line 310
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mOnNestedChangedListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;

    .line 311
    invoke-interface {v0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;->onStartNestedScroll(I)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private sendStopNestedScroll(I)V
    .locals 1

    .line 322
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mOnNestedChangedListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;

    .line 323
    invoke-interface {v0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;->onStopNestedScroll(I)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private sendStopNestedScrollAccepted(I)V
    .locals 1

    .line 316
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mOnNestedChangedListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;

    .line 317
    invoke-interface {v0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;->onStopNestedScrollAccepted(I)V

    goto :goto_0

    :cond_0
    return-void
.end method


# virtual methods
.method public addOnScrollListener(Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;)V
    .locals 0

    .line 302
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mOnNestedChangedListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public dispatchNestedPreScroll(II[I[II)Z
    .locals 6
    .param p3    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param
    .param p4    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 169
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    move v1, p1

    move v2, p2

    move-object v3, p3

    move-object v4, p4

    move v5, p5

    invoke-virtual/range {v0 .. v5}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedPreScroll(II[I[II)Z

    move-result p0

    return p0
.end method

.method public dispatchNestedScroll(IIII[II[I)V
    .locals 10
    .param p5    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param
    .param p7    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 177
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "dispatchNestedScroll start ... type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v1, p6

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "NestedScrollingLayout"

    invoke-static {v2, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, p0

    .line 178
    iget-object v2, v0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    move v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    move-object v7, p5

    move/from16 v8, p6

    move-object/from16 v9, p7

    invoke-virtual/range {v2 .. v9}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedScroll(IIII[II[I)V

    return-void
.end method

.method public dispatchNestedScroll(IIII[II)Z
    .locals 7

    .line 173
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move-object v5, p5

    move v6, p6

    invoke-virtual/range {v0 .. v6}, Landroidx/core/view/NestedScrollingChildHelper;->dispatchNestedScroll(IIII[II)Z

    move-result p0

    return p0
.end method

.method public getScrollingProgress()I
    .locals 0

    .line 145
    iget p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    return p0
.end method

.method public hasNestedScrollingParent(I)Z
    .locals 0

    .line 186
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->hasNestedScrollingParent(I)Z

    move-result p0

    return p0
.end method

.method public isNestedScrollingEnabled()Z
    .locals 0

    .line 157
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0}, Landroidx/core/view/NestedScrollingChildHelper;->isNestedScrollingEnabled()Z

    move-result p0

    return p0
.end method

.method public onFinishInflate()V
    .locals 1
    .annotation build Landroidx/annotation/RequiresApi;
        api = 0x15
    .end annotation

    .line 92
    invoke-super {p0}, Landroid/widget/FrameLayout;->onFinishInflate()V

    .line 93
    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollableViewId:I

    invoke-virtual {p0, v0}, Landroid/widget/FrameLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollableView:Landroid/view/View;

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    .line 96
    invoke-virtual {v0, p0}, Landroid/view/View;->setNestedScrollingEnabled(Z)V

    return-void

    .line 99
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "The scrollableView attribute is required and must refer to a valid child."

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public onLayout(ZIIII)V
    .locals 0

    .line 104
    invoke-super/range {p0 .. p5}, Landroid/widget/FrameLayout;->onLayout(ZIIII)V

    .line 105
    invoke-direct {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->dispatchScrollingProgressUpdated()V

    return-void
.end method

.method public onNestedPreScroll(Landroid/view/View;II[I)V
    .locals 8

    const-string v0, "NestedScrollingLayout"

    const-string v1, "onNestedPreScroll start0 ... TYPE_TOUCH "

    .line 254
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v7, 0x0

    move-object v2, p0

    move-object v3, p1

    move v4, p2

    move v5, p3

    move-object v6, p4

    .line 255
    invoke-virtual/range {v2 .. v7}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onNestedPreScroll(Landroid/view/View;II[II)V

    return-void
.end method

.method public onNestedPreScroll(Landroid/view/View;II[II)V
    .locals 8
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p4    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 229
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onNestedPreScroll start1 ... type: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "NestedScrollingLayout"

    invoke-static {v0, p1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p1, 0x1

    if-eqz p5, :cond_1

    .line 231
    iget-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingInConsumedProgress:Z

    if-nez v0, :cond_0

    .line 232
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingStartInConsumedTime:J

    .line 234
    :cond_0
    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingInConsumedProgress:Z

    goto :goto_0

    .line 236
    :cond_1
    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollInConsumedProgress:Z

    .line 238
    :goto_0
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mParentScrollConsumed:[I

    const/4 v1, 0x0

    if-lez p3, :cond_2

    .line 240
    iget v2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingFrom:I

    iget v3, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingTo:I

    iget v4, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    sub-int/2addr v4, p3

    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 241
    iget v3, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    sub-int/2addr v3, v2

    .line 242
    iput v2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    .line 243
    invoke-direct {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->dispatchScrollingProgressUpdated()V

    .line 244
    aget v2, p4, v1

    add-int/2addr v2, v1

    aput v2, p4, v1

    .line 245
    aget v2, p4, p1

    add-int/2addr v2, v3

    aput v2, p4, p1

    .line 247
    :cond_2
    aget v2, p4, v1

    sub-int v3, p2, v2

    aget p2, p4, p1

    sub-int v4, p3, p2

    const/4 v6, 0x0

    move-object v2, p0

    move-object v5, v0

    move v7, p5

    invoke-virtual/range {v2 .. v7}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->dispatchNestedPreScroll(II[I[II)Z

    move-result p0

    if-eqz p0, :cond_3

    .line 248
    aget p0, p4, v1

    aget p2, v0, v1

    add-int/2addr p0, p2

    aput p0, p4, v1

    .line 249
    aget p0, p4, p1

    aget p2, v0, p1

    add-int/2addr p0, p2

    aput p0, p4, p1

    :cond_3
    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIII)V
    .locals 9

    const-string v0, "NestedScrollingLayout"

    const-string v1, "onNestedScroll start0 ... TYPE_TOUCH "

    .line 259
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v8, 0x0

    move-object v2, p0

    move-object v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    move v7, p5

    .line 260
    invoke-virtual/range {v2 .. v8}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onNestedScroll(Landroid/view/View;IIIII)V

    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIIII)V
    .locals 9
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 264
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onNestedScroll start1 ... type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p6

    const-string v0, "NestedScrollingLayout"

    invoke-static {v0, p6}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 265
    iget-object v8, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingV2ConsumedCompat:[I

    const/4 v7, 0x0

    move-object v1, p0

    move-object v2, p1

    move v3, p2

    move v4, p3

    move v5, p4

    move v6, p5

    invoke-virtual/range {v1 .. v8}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onNestedScroll(Landroid/view/View;IIIII[I)V

    return-void
.end method

.method public onNestedScroll(Landroid/view/View;IIIII[I)V
    .locals 14
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p7    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    move-object v8, p0

    move/from16 v9, p6

    .line 269
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onNestedScroll start2 ... type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "NestedScrollingLayout"

    invoke-static {v1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 270
    iget-object v5, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mParentOffsetInWindow:[I

    move-object v0, p0

    move/from16 v1, p2

    move/from16 v2, p3

    move/from16 v3, p4

    move/from16 v4, p5

    move/from16 v6, p6

    move-object/from16 v7, p7

    invoke-virtual/range {v0 .. v7}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->dispatchNestedScroll(IIII[II[I)V

    const/4 v0, 0x1

    .line 271
    aget v1, p7, v0

    sub-int v1, p5, v1

    if-gez p5, :cond_9

    if-eqz v1, :cond_9

    .line 273
    iget v2, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    sub-int v1, v2, v1

    const/4 v3, 0x0

    if-nez v9, :cond_0

    move v4, v0

    goto :goto_0

    :cond_0
    move v4, v3

    .line 275
    :goto_0
    iget v5, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingFrom:I

    if-le v1, v5, :cond_1

    move v6, v0

    goto :goto_1

    :cond_1
    move v6, v3

    :goto_1
    if-nez v4, :cond_8

    .line 276
    iget-boolean v4, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mTriggerViewVisible:Z

    if-eqz v4, :cond_8

    if-eqz v4, :cond_2

    iget-boolean v7, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderViewVisible:Z

    if-nez v7, :cond_2

    if-ne v9, v0, :cond_2

    if-eqz v6, :cond_8

    :cond_2
    if-eqz v4, :cond_6

    if-ne v9, v0, :cond_6

    iget-boolean v7, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderViewVisible:Z

    if-eqz v7, :cond_6

    iget-boolean v7, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isHeaderOpen:Z

    if-nez v7, :cond_3

    if-ltz v1, :cond_8

    :cond_3
    if-eqz v7, :cond_6

    iget-wide v10, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderOpenTime:J

    iget-wide v12, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingStartInConsumedTime:J

    cmp-long v7, v10, v12

    if-lez v7, :cond_4

    move v7, v0

    goto :goto_2

    :cond_4
    cmp-long v7, v10, v12

    if-nez v7, :cond_5

    move v7, v3

    goto :goto_2

    :cond_5
    const/4 v7, -0x1

    :goto_2
    if-gtz v7, :cond_6

    goto :goto_3

    :cond_6
    if-eqz v4, :cond_7

    iget-boolean v4, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderViewVisible:Z

    if-nez v4, :cond_7

    if-ne v9, v0, :cond_7

    if-eqz v6, :cond_7

    if-ne v2, v5, :cond_7

    move v2, v5

    goto :goto_4

    :cond_7
    move v2, v3

    goto :goto_4

    :cond_8
    :goto_3
    iget v2, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingTo:I

    :goto_4
    invoke-static {v2, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    invoke-static {v5, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 277
    iget v2, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    sub-int/2addr v2, v1

    .line 278
    iput v1, v8, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    .line 279
    invoke-direct {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->dispatchScrollingProgressUpdated()V

    .line 280
    aget v1, p7, v3

    add-int/2addr v1, v3

    aput v1, p7, v3

    .line 281
    aget v1, p7, v0

    add-int/2addr v1, v2

    aput v1, p7, v0

    :cond_9
    return-void
.end method

.method public onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;I)V
    .locals 2

    const-string v0, "NestedScrollingLayout"

    const-string v1, "onNestedScrollAccepted start1 ... "

    .line 223
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 224
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

    invoke-virtual {v0, p1, p2, p3}, Landroidx/core/view/NestedScrollingParentHelper;->onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;I)V

    and-int/lit8 p1, p3, 0x2

    .line 225
    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->startNestedScroll(I)Z

    return-void
.end method

.method public onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;II)V
    .locals 2
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p2    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 213
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onNestedScrollAccepted start0 ... type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "NestedScrollingLayout"

    invoke-static {v1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 214
    invoke-virtual {p0, p1, p2, p3}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onNestedScrollAccepted(Landroid/view/View;Landroid/view/View;I)V

    if-eqz p4, :cond_0

    const/4 p1, 0x1

    .line 216
    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollAcceptedFling:Z

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 218
    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollAcceptedFling:Z

    :goto_0
    return-void
.end method

.method public onScrollingProgressUpdated(I)V
    .locals 0

    return-void
.end method

.method public onStartNestedScroll(Landroid/view/View;Landroid/view/View;I)Z
    .locals 2

    const-string p1, "NestedScrollingLayout"

    const-string p2, "onStartNestedScroll start1 ... "

    .line 201
    invoke-static {p1, p2}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    and-int/lit8 p1, p3, 0x2

    const/4 p2, 0x0

    const/4 v0, 0x1

    if-eqz p1, :cond_0

    move p1, v0

    goto :goto_0

    :cond_0
    move p1, p2

    .line 203
    :goto_0
    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {v1, p3}, Landroidx/core/view/NestedScrollingChildHelper;->startNestedScroll(I)Z

    move-result p3

    if-eqz p3, :cond_1

    return v0

    .line 206
    :cond_1
    invoke-virtual {p0}, Landroid/widget/FrameLayout;->isEnabled()Z

    move-result p0

    if-eqz p0, :cond_3

    if-nez p1, :cond_2

    goto :goto_1

    :cond_2
    return v0

    :cond_3
    :goto_1
    return p2
.end method

.method public onStartNestedScroll(Landroid/view/View;Landroid/view/View;II)Z
    .locals 1

    const-string p2, "NestedScrollingLayout"

    const-string v0, "onStartNestedScroll start0 ... "

    .line 195
    invoke-static {p2, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 196
    invoke-direct {p0, p4}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->sendStartNestedScroll(I)V

    .line 197
    iget-object p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p2, p3, p4}, Landroidx/core/view/NestedScrollingChildHelper;->startNestedScroll(II)Z

    move-result p2

    if-nez p2, :cond_1

    invoke-virtual {p0, p1, p1, p3}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->onStartNestedScroll(Landroid/view/View;Landroid/view/View;I)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public onStopNestedScroll(Landroid/view/View;I)V
    .locals 2
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 286
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onStopNestedScroll start ... type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "NestedScrollingLayout"

    invoke-static {v1, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 287
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingParentHelper:Landroidx/core/view/NestedScrollingParentHelper;

    invoke-virtual {v0, p1, p2}, Landroidx/core/view/NestedScrollingParentHelper;->onStopNestedScroll(Landroid/view/View;I)V

    .line 288
    invoke-direct {p0, p2}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->sendStopNestedScroll(I)V

    .line 289
    invoke-virtual {p0, p2}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->stopNestedScroll(I)V

    .line 290
    iget-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollInConsumedProgress:Z

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    .line 291
    iput-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollInConsumedProgress:Z

    .line 292
    iget-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingInConsumedProgress:Z

    if-nez p1, :cond_1

    iget-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollAcceptedFling:Z

    if-nez p1, :cond_1

    .line 293
    invoke-direct {p0, p2}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->sendStopNestedScrollAccepted(I)V

    goto :goto_0

    .line 295
    :cond_0
    iget-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingInConsumedProgress:Z

    if-eqz p1, :cond_1

    .line 296
    iput-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedFlingInConsumedProgress:Z

    .line 297
    invoke-direct {p0, p2}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->sendStopNestedScrollAccepted(I)V

    :cond_1
    :goto_0
    return-void
.end method

.method public removeOnScrollListener(Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;)V
    .locals 0

    .line 306
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mOnNestedChangedListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public setNestedScrollingEnabled(Z)V
    .locals 0

    .line 153
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->setNestedScrollingEnabled(Z)V

    return-void
.end method

.method public setScrollingRange(IIZZZZZ)V
    .locals 1

    if-le p1, p2, :cond_0

    const-string p1, "NestedScrollingLayout"

    const-string/jumbo v0, "wrong scrolling range: [%d, %d], making from=to"

    .line 110
    invoke-static {p1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    move p1, p2

    .line 113
    :cond_0
    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingFrom:I

    .line 114
    iput p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingTo:I

    .line 115
    iput-boolean p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderViewVisible:Z

    .line 116
    iput-boolean p4, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mTriggerViewVisible:Z

    .line 117
    iget p4, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    if-ge p4, p1, :cond_1

    .line 118
    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    .line 120
    :cond_1
    iget p4, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    if-le p4, p2, :cond_2

    .line 121
    iput p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    :cond_2
    const/4 p2, 0x0

    if-eqz p5, :cond_3

    .line 123
    iget-boolean p4, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isFirstsetScrollingRange:Z

    if-nez p4, :cond_4

    :cond_3
    if-nez p6, :cond_4

    if-eqz p7, :cond_5

    :cond_4
    if-eqz p3, :cond_5

    .line 124
    iput p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    .line 125
    iput-boolean p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isFirstsetScrollingRange:Z

    goto :goto_0

    :cond_5
    if-eqz p5, :cond_6

    .line 126
    iget-boolean p3, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isFirstsetScrollingRange:Z

    if-nez p3, :cond_7

    :cond_6
    if-eqz p6, :cond_8

    .line 127
    :cond_7
    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    .line 128
    iput-boolean p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isFirstsetScrollingRange:Z

    .line 130
    :cond_8
    :goto_0
    invoke-direct {p0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->dispatchScrollingProgressUpdated()V

    return-void
.end method

.method public startNestedScroll(I)Z
    .locals 0

    .line 161
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->startNestedScroll(I)Z

    move-result p0

    return p0
.end method

.method public startNestedScroll(II)Z
    .locals 0

    .line 165
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1, p2}, Landroidx/core/view/NestedScrollingChildHelper;->startNestedScroll(II)Z

    move-result p0

    return p0
.end method

.method public stopNestedScroll()V
    .locals 2

    const-string v0, "NestedScrollingLayout"

    const-string/jumbo v1, "stopNestedScroll start0 ... "

    .line 190
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 191
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0}, Landroidx/core/view/NestedScrollingChildHelper;->stopNestedScroll()V

    return-void
.end method

.method public stopNestedScroll(I)V
    .locals 0

    .line 182
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mNestedScrollingChildHelper:Landroidx/core/view/NestedScrollingChildHelper;

    invoke-virtual {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;->stopNestedScroll(I)V

    return-void
.end method

.method public updateHeaderOpen(Z)V
    .locals 2

    .line 138
    iget-boolean v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isHeaderOpen:Z

    if-nez v0, :cond_0

    if-eqz p1, :cond_0

    .line 139
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mHeaderOpenTime:J

    .line 141
    :cond_0
    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->isHeaderOpen:Z

    return-void
.end method

.method public updateScrollingProgress(I)V
    .locals 0

    .line 134
    iput p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->mScrollingProgress:I

    return-void
.end method
