.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "WaitForIndeterminate"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method private constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 1

    .line 941
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    const/4 v0, 0x0

    .line 942
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V
    .locals 0

    .line 940
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    return-void
.end method


# virtual methods
.method public handleScrollStateChange(II)V
    .locals 3

    if-nez p2, :cond_3

    .line 948
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 949
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionStart:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

    invoke-virtual {p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 950
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    instance-of v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    const/4 v1, 0x2

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    .line 951
    invoke-virtual {p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->notifyTriggered()V

    .line 952
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1, v2}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 953
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 954
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p1, v2}, Landroid/widget/TextView;->setVisibility(I)V

    .line 955
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p1, p1, v1

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 956
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1}, Landroid/widget/ProgressBar;->getVisibility()I

    move-result p1

    if-nez p1, :cond_3

    .line 957
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    const/high16 p2, 0x3f800000    # 1.0f

    invoke-virtual {p1, p2}, Landroid/widget/ProgressBar;->setAlpha(F)V

    .line 958
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1, p2}, Landroid/widget/ProgressBar;->setScaleX(F)V

    .line 959
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p0, p2}, Landroid/widget/ProgressBar;->setScaleY(F)V

    goto :goto_0

    .line 961
    :cond_0
    instance-of p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    if-eqz p2, :cond_3

    .line 962
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->notifyTriggered()V

    .line 963
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->isNoData()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 964
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicator:Landroid/view/View;

    const/16 p2, 0x8

    invoke-virtual {p1, p2}, Landroid/view/View;->setVisibility(I)V

    .line 965
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1, p2}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 966
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->getCountNoData()I

    move-result p1

    const/4 p2, 0x3

    if-ge p1, p2, :cond_1

    .line 967
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p0, p0, v1

    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 969
    :cond_1
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p0, p0, p2

    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 972
    :cond_2
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 973
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1, v2}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 974
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p0, p0, v2

    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_3
    :goto_0
    return-void
.end method
