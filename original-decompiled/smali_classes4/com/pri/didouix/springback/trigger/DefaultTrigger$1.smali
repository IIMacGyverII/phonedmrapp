.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"

# interfaces
.implements Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;


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

    .line 44
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onActionComplete(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;)V
    .locals 3

    .line 46
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionStart:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

    if-ne v1, v2, :cond_2

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-ne v1, p1, :cond_2

    .line 47
    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getScrollY()I

    move-result v0

    if-eqz v0, :cond_0

    .line 48
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 49
    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    invoke-virtual {v0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 50
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-nez v1, :cond_1

    .line 51
    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    const/4 v1, 0x0

    invoke-virtual {v0, v1, v1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    goto :goto_0

    .line 54
    :cond_0
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 55
    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-virtual {v0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 57
    :cond_1
    :goto_0
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 58
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    const/4 v0, 0x3

    aget-object p1, p1, v0

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_2
    return-void
.end method

.method public onActionStart(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;)V
    .locals 5

    .line 64
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_0

    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-ne v0, p1, :cond_0

    iget-object v2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v3, v2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-nez v3, :cond_0

    iget-object v3, v2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v4, v2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    if-ne v3, v4, :cond_0

    .line 66
    iget-object v3, v2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-virtual {v2, v3}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 67
    iget-object v2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iput-object v0, v2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    .line 68
    iget-object v0, v2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {v0, v1}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 69
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    .line 70
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 71
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    const/4 v2, 0x2

    aget-object p1, p1, v2

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 72
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    neg-int p1, p1

    invoke-virtual {v0, v1, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    .line 73
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    neg-int p1, p1

    invoke-virtual {v0}, Landroid/widget/RelativeLayout;->getWidth()I

    move-result v2

    invoke-virtual {v0, v1, p1, v2, v1}, Landroid/widget/RelativeLayout;->layout(IIII)V

    .line 74
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 75
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_0
    return-void
.end method

.method public onUpdateTriggerTextIndex(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;ILjava/lang/String;)V
    .locals 0

    .line 80
    iget-object p0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    aput-object p3, p0, p2

    return-void
.end method
