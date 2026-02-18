.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"

# interfaces
.implements Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;


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

    .line 141
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onScrolled(Lcom/pri/didouix/springback/view/SpringBackLayout;II)V
    .locals 9

    .line 162
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 163
    iget v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    iput v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLastScrollDistance:I

    .line 164
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    neg-int v0, v0

    iput v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    .line 165
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    invoke-virtual {p2, v0}, Landroid/widget/RelativeLayout;->setTop(I)V

    .line 166
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p2}, Landroid/view/ViewGroup;->getBottom()I

    move-result p2

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v1

    add-int/2addr p2, v1

    invoke-virtual {v0, p2}, Landroid/widget/RelativeLayout;->setBottom(I)V

    .line 167
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    const/high16 v1, 0x3e800000    # 0.25f

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-gez v0, :cond_2

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget-object v4, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-ne v0, v4, :cond_2

    if-eqz v4, :cond_2

    .line 168
    iget v5, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    iget v4, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    sub-int/2addr v5, v4

    int-to-float v4, v5

    mul-float/2addr v4, v1

    iget v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    int-to-float v0, v0

    add-float/2addr v4, v0

    .line 169
    iget v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-ne v0, v2, :cond_1

    iget p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLastScrollDistance:I

    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p2

    int-to-float p2, p2

    cmpg-float p2, p2, v4

    if-ltz p2, :cond_0

    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p2

    int-to-float p2, p2

    cmpg-float p2, p2, v4

    if-gez p2, :cond_1

    :cond_0
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v4, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    if-ne v0, v4, :cond_1

    .line 171
    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-virtual {p2, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 173
    :cond_1
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingContainer:Landroid/widget/RelativeLayout;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p2}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p2

    iget-object v4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v4, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v4, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    sub-int/2addr p2, v4

    invoke-static {p2, v3}, Ljava/lang/Math;->max(II)I

    move-result p2

    int-to-float p2, p2

    invoke-virtual {v0, p2}, Landroid/widget/RelativeLayout;->setTranslationY(F)V

    .line 175
    :cond_2
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    const/16 v4, 0x8

    if-eqz v0, :cond_e

    instance-of v5, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    if-eqz v5, :cond_e

    .line 176
    iget v5, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    iget v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    sub-int/2addr v5, v0

    int-to-float v5, v5

    mul-float/2addr v5, v1

    int-to-float v0, v0

    add-float/2addr v5, v0

    .line 177
    iget v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-ne v0, v2, :cond_4

    iget p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLastScrollDistance:I

    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p2

    int-to-float p2, p2

    cmpg-float p2, p2, v5

    if-ltz p2, :cond_3

    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p2

    int-to-float p2, p2

    cmpg-float p2, p2, v5

    if-gez p2, :cond_4

    :cond_3
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    if-ne v0, v1, :cond_4

    .line 179
    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-virtual {p2, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 180
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p2, v3}, Landroid/view/ViewGroup;->setVisibility(I)V

    .line 181
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p2, v4}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 182
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p2, v3}, Landroid/view/View;->setVisibility(I)V

    .line 183
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p2, p2, v3

    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 185
    :cond_4
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-ne v0, v2, :cond_5

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    if-ne v0, v1, :cond_5

    iget p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLastScrollDistance:I

    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p2

    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    if-le p2, v1, :cond_5

    .line 187
    iget-object p2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-virtual {v0, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 189
    :cond_5
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p2}, Landroid/view/View;->getVisibility()I

    move-result p2

    if-nez p2, :cond_e

    .line 190
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 191
    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getTop()I

    move-result v0

    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v1

    add-int/2addr v0, v1

    iput v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorBottom:I

    .line 192
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 193
    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getTop()I

    move-result v0

    iput v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelTop:I

    .line 194
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 195
    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getBottom()I

    move-result v0

    iput v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelBottom:I

    .line 196
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    int-to-float v0, v0

    .line 197
    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p2}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p2

    int-to-float p2, p2

    div-float/2addr p2, v0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-static {p2, v1}, Ljava/lang/Math;->min(FF)F

    move-result p2

    const/4 v5, 0x0

    invoke-static {v5, p2}, Ljava/lang/Math;->max(FF)F

    move-result p2

    const/high16 v6, 0x3f000000    # 0.5f

    mul-float/2addr v6, v0

    .line 199
    iget-object v7, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v7, v7, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {v7}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result v7

    int-to-float v7, v7

    cmpg-float v7, v7, v6

    if-gez v7, :cond_6

    move v7, v5

    goto :goto_0

    .line 202
    :cond_6
    iget-object v7, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v7, v7, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {v7}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result v7

    int-to-float v7, v7

    sub-float/2addr v7, v6

    div-float/2addr v7, v6

    invoke-static {v7, v1}, Ljava/lang/Math;->min(FF)F

    move-result v7

    .line 204
    :goto_0
    invoke-static {v5, v7}, Ljava/lang/Math;->max(FF)F

    move-result v7

    .line 205
    iget-object v8, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v8, v8, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {v8}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result v8

    int-to-float v8, v8

    cmpg-float v6, v8, v6

    if-gez v6, :cond_7

    move v0, v5

    goto :goto_1

    .line 208
    :cond_7
    iget-object v6, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v6, v6, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {v6}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result v6

    int-to-float v6, v6

    const v8, 0x3f333333    # 0.7f

    mul-float/2addr v8, v0

    sub-float/2addr v6, v8

    const v8, 0x3e99999a    # 0.3f

    mul-float/2addr v0, v8

    div-float/2addr v6, v0

    invoke-static {v6, v1}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 210
    :goto_1
    invoke-static {v5, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    .line 211
    iget-object v6, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v6, v6, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v6}, Landroid/view/View;->getWidth()I

    move-result v6

    neg-int v6, v6

    int-to-float v6, v6

    sub-float/2addr v1, p2

    mul-float/2addr v6, v1

    .line 212
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v1, v7}, Landroid/view/View;->setAlpha(F)V

    .line 213
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v1, p2}, Landroid/view/View;->setScaleX(F)V

    .line 214
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v1, p2}, Landroid/view/View;->setScaleY(F)V

    .line 215
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setAlpha(F)V

    .line 216
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v8, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelTop:I

    invoke-virtual {v8, v1}, Landroid/widget/TextView;->setTop(I)V

    .line 217
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v8, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelBottom:I

    invoke-virtual {v8, v1}, Landroid/widget/TextView;->setBottom(I)V

    .line 218
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {v1}, Landroid/widget/ProgressBar;->getVisibility()I

    move-result v1

    if-nez v1, :cond_8

    .line 219
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {v1, v7}, Landroid/widget/ProgressBar;->setAlpha(F)V

    .line 220
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {v1, p2}, Landroid/widget/ProgressBar;->setScaleX(F)V

    .line 221
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {v1, p2}, Landroid/widget/ProgressBar;->setScaleY(F)V

    .line 223
    :cond_8
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p2}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p2

    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v7, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v7, v7, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    if-ge p2, v7, :cond_b

    cmpl-float p2, v0, v5

    if-lez p2, :cond_9

    .line 225
    iget-object p2, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p2, v6}, Landroid/widget/TextView;->setTranslationY(F)V

    .line 227
    :cond_9
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    if-ne v0, v1, :cond_a

    .line 228
    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p2, p2, v3

    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 230
    :cond_a
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    iget p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorBottom:I

    invoke-virtual {v0, p2}, Landroid/view/View;->setBottom(I)V

    goto :goto_4

    .line 231
    :cond_b
    iget-object p2, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p2}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p2

    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    if-lt p2, v1, :cond_e

    .line 232
    iget p2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorBottom:I

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {v0}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result v0

    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v6, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v6, v6, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    sub-int/2addr v0, v6

    add-int/2addr p2, v0

    .line 233
    iget-object v0, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {v0}, Landroid/widget/ProgressBar;->getVisibility()I

    move-result v0

    if-eqz v0, :cond_d

    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v6, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    if-ne v1, v6, :cond_c

    goto :goto_2

    .line 236
    :cond_c
    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v0, p2}, Landroid/view/View;->setBottom(I)V

    .line 237
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p2}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p2

    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    sub-int/2addr p2, v1

    int-to-float p2, p2

    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setTranslationY(F)V

    goto :goto_3

    .line 234
    :cond_d
    :goto_2
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p2, v5}, Landroid/widget/TextView;->setTranslationY(F)V

    .line 239
    :goto_3
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    if-ne v0, v1, :cond_e

    .line 240
    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p2, p2, v2

    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 245
    :cond_e
    :goto_4
    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    invoke-virtual {p2, p3, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->handleScrolled(II)V

    .line 246
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p2, :cond_f

    instance-of p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    if-eqz p2, :cond_f

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p1

    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    if-ge p1, v0, :cond_f

    .line 247
    iget-object p1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1, v4}, Landroid/view/ViewGroup;->setVisibility(I)V

    goto :goto_5

    .line 248
    :cond_f
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p2, :cond_10

    instance-of p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    if-eqz p2, :cond_10

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1}, Landroid/widget/RelativeLayout;->getHeight()I

    move-result p1

    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    if-lt p1, v0, :cond_10

    iget-object p1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getVisibility()I

    move-result p1

    if-ne p1, v4, :cond_10

    .line 249
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1, v3}, Landroid/view/ViewGroup;->setVisibility(I)V

    .line 250
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 251
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    invoke-virtual {p1, p2, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->viewShow(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 253
    :cond_10
    :goto_5
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getVisibility()I

    move-result p1

    if-nez p1, :cond_11

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p1, :cond_11

    .line 254
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    neg-int p1, p3

    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->offsetTopAndBottom(I)V

    :cond_11
    return-void
.end method

.method public onStateChanged(IIZ)V
    .locals 1

    .line 143
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iput p2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    .line 144
    iput-boolean p3, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollerFinished:Z

    .line 145
    iget-object p3, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    invoke-virtual {p3, p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->handleScrollStateChange(II)V

    .line 146
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object p3, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    if-eq p2, p3, :cond_0

    .line 147
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    const/4 p2, 0x0

    invoke-virtual {p1, p2}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 148
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p1, :cond_1

    .line 149
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p0, p2}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    goto :goto_0

    .line 151
    :cond_0
    iget-object p3, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    if-eq p2, p3, :cond_1

    .line 152
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    const/16 p2, 0x8

    invoke-virtual {p1, p2}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 153
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p1, :cond_1

    .line 154
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p0, p2}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    :cond_1
    :goto_0
    return-void
.end method
