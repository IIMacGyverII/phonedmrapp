.class Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;
.super Ljava/lang/Object;
.source "NestedHeaderLayout.java"

# interfaces
.implements Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout$OnNestedChangedListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;


# direct methods
.method constructor <init>(Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;)V
    .locals 0

    .line 93
    iput-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onStartNestedScroll(I)V
    .locals 0

    if-nez p1, :cond_0

    .line 96
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isTouch:Z

    :cond_0
    return-void
.end method

.method public onStopNestedScroll(I)V
    .locals 0

    if-nez p1, :cond_0

    .line 115
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isTouch:Z

    :cond_0
    return-void
.end method

.method public onStopNestedScrollAccepted(I)V
    .locals 4

    .line 101
    iget-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget-boolean v0, p1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mAutoAnim:Z

    if-eqz v0, :cond_4

    iget-boolean v0, p1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isAniming:Z

    if-nez v0, :cond_4

    invoke-virtual {p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result p1

    if-eqz p1, :cond_4

    iget-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    .line 102
    invoke-virtual {p1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result p1

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v1, v0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    if-ge p1, v1, :cond_4

    invoke-virtual {v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result p1

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v1, v0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    if-le p1, v1, :cond_4

    const/4 p1, 0x0

    .line 104
    invoke-virtual {v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v2, v1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    const/high16 v3, 0x3f000000    # 0.5f

    if-le v0, v2, :cond_0

    invoke-virtual {v1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    int-to-float v0, v0

    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v1, v1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    int-to-float v2, v1

    mul-float/2addr v2, v3

    cmpg-float v0, v0, v2

    if-gez v0, :cond_0

    :goto_0
    move p1, v1

    goto :goto_1

    .line 106
    :cond_0
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    invoke-virtual {v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    int-to-float v0, v0

    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v2, v1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingFrom:I

    int-to-float v2, v2

    mul-float/2addr v2, v3

    cmpg-float v0, v0, v2

    if-ltz v0, :cond_1

    invoke-virtual {v1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    if-ltz v0, :cond_3

    :cond_1
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    invoke-virtual {v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    if-lez v0, :cond_2

    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    invoke-virtual {v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    int-to-float v0, v0

    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v1, v1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    int-to-float v1, v1

    mul-float/2addr v1, v3

    cmpl-float v0, v0, v1

    if-ltz v0, :cond_3

    :cond_2
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    invoke-virtual {v0}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    int-to-float v0, v0

    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v2, v1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    int-to-float v2, v2

    mul-float/2addr v2, v3

    cmpl-float v0, v0, v2

    if-ltz v0, :cond_3

    invoke-virtual {v1}, Lcom/pri/didouix/nestedheader/widget/NestedScrollingLayout;->getScrollingProgress()I

    move-result v0

    iget-object v1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget v1, v1, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->mScrollingTo:I

    if-ge v0, v1, :cond_3

    goto :goto_0

    .line 109
    :cond_3
    :goto_1
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$1;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V

    :cond_4
    return-void
.end method
