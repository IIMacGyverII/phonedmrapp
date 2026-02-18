.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"

# interfaces
.implements Landroid/view/View$OnLayoutChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 0

    .line 98
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLayoutChange(Landroid/view/View;IIIIIIII)V
    .locals 0

    .line 100
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p2

    const/high16 p3, 0x40000000    # 2.0f

    invoke-static {p2, p3}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result p2

    .line 101
    invoke-virtual {p1}, Landroid/view/View;->getScrollY()I

    move-result p4

    neg-int p4, p4

    invoke-static {p4, p3}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result p3

    .line 102
    iget-object p4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p4, p4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p4, p2, p3}, Landroid/widget/RelativeLayout;->measure(II)V

    .line 103
    iget-object p4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p4, p4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p4, p2, p3}, Landroid/widget/RelativeLayout;->measure(II)V

    .line 104
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1}, Landroid/view/View;->getScrollY()I

    move-result p3

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p4

    const/4 p5, 0x0

    invoke-virtual {p2, p5, p3, p4, p5}, Landroid/widget/RelativeLayout;->layout(IIII)V

    .line 105
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p3, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p2}, Landroid/view/ViewGroup;->getBottom()I

    move-result p2

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p4

    iget-object p6, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p6, p6, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p6}, Landroid/view/ViewGroup;->getBottom()I

    move-result p6

    invoke-virtual {p1}, Landroid/view/View;->getScrollY()I

    move-result p1

    add-int/2addr p6, p1

    invoke-virtual {p3, p5, p2, p4, p6}, Landroid/widget/RelativeLayout;->layout(IIII)V

    move p1, p5

    .line 106
    :goto_0
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    if-ge p1, p2, :cond_1

    .line 107
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {p2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    .line 108
    instance-of p3, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    if-eqz p3, :cond_0

    .line 109
    check-cast p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    .line 110
    sget p3, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndeterminateTop:I

    iget-object p4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p4, p4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p4}, Landroid/view/View;->getTop()I

    move-result p4

    if-lt p3, p4, :cond_0

    .line 111
    iget-object p3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p3, p3, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    iget p4, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    sub-int/2addr p4, p5

    invoke-virtual {p3, p4}, Landroid/widget/ProgressBar;->offsetTopAndBottom(I)V

    .line 112
    iget-object p3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p3, p3, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    iget p4, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    sub-int/2addr p4, p5

    invoke-virtual {p3, p4}, Landroid/view/View;->offsetTopAndBottom(I)V

    .line 113
    iget-object p3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p3, p3, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    sub-int/2addr p2, p5

    invoke-virtual {p3, p2}, Landroid/widget/TextView;->offsetTopAndBottom(I)V

    :cond_0
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 117
    :cond_1
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getVisibility()I

    move-result p1

    if-nez p1, :cond_6

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p2, :cond_6

    instance-of p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    if-eqz p2, :cond_6

    .line 118
    iget p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorBottom:I

    if-gtz p2, :cond_2

    .line 120
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p2}, Landroid/view/View;->getBottom()I

    move-result p2

    iput p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorBottom:I

    .line 122
    :cond_2
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelTop:I

    if-lez p2, :cond_3

    iget p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelBottom:I

    if-gtz p2, :cond_4

    .line 124
    :cond_3
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p2}, Landroid/widget/TextView;->getTop()I

    move-result p2

    iput p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelTop:I

    .line 125
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 126
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p2}, Landroid/widget/TextView;->getBottom()I

    move-result p2

    iput p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelBottom:I

    .line 128
    :cond_4
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1}, Landroid/widget/ProgressBar;->getVisibility()I

    move-result p1

    const/16 p2, 0x8

    if-eq p1, p2, :cond_5

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1}, Landroid/widget/ProgressBar;->getVisibility()I

    move-result p1

    const/4 p2, 0x4

    if-ne p1, p2, :cond_6

    :cond_5
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object p3, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    if-eq p2, p3, :cond_6

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p1

    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p3, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget p3, p3, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    if-le p1, p3, :cond_6

    .line 129
    iget-object p1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    iget p3, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorBottom:I

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p2}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p2

    iget-object p4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p4, p4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget p4, p4, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    sub-int/2addr p2, p4

    add-int/2addr p3, p2

    invoke-virtual {p1, p3}, Landroid/view/View;->setBottom(I)V

    .line 132
    :cond_6
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getVisibility()I

    move-result p1

    if-nez p1, :cond_7

    .line 133
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    iget p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getMeasuredHeight()I

    move-result p2

    sub-int/2addr p0, p2

    invoke-virtual {p1, p0}, Landroid/view/ViewGroup;->offsetTopAndBottom(I)V

    :cond_7
    return-void
.end method
