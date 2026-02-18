.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "Tracking"
.end annotation


# instance fields
.field private mLockActivated:Z

.field private mTriggerable:Z

.field private mUpTriggerable:Z

.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method private constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 1

    .line 755
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    const/4 v0, 0x0

    .line 756
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    const/4 p1, 0x0

    .line 757
    iput-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    .line 758
    iput-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mUpTriggerable:Z

    .line 759
    iput-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mLockActivated:Z

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V
    .locals 0

    .line 750
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    return-void
.end method


# virtual methods
.method public handleScrollStateChange(II)V
    .locals 0

    if-nez p2, :cond_1

    .line 765
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 766
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-virtual {p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 767
    iget-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    if-nez p1, :cond_0

    .line 768
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->removeAllViews()V

    .line 769
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    const/4 p2, 0x0

    iput-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    .line 770
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    const/16 p2, 0x8

    invoke-virtual {p1, p2}, Landroid/view/ViewGroup;->setVisibility(I)V

    .line 771
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, p2}, Landroid/view/View;->setVisibility(I)V

    .line 772
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_0
    const/4 p1, 0x0

    .line 774
    iput-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mUpTriggerable:Z

    .line 775
    iput-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mLockActivated:Z

    :cond_1
    return-void
.end method

.method public handleScrolled(II)V
    .locals 8

    .line 823
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    const/4 v0, 0x2

    const/4 v1, 0x1

    if-eq p2, v1, :cond_0

    if-eq p2, v0, :cond_0

    return-void

    .line 826
    :cond_0
    iget p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    const/16 v2, 0x8

    const/4 v3, 0x0

    if-gez p2, :cond_6

    .line 827
    iget-boolean v4, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpActionBegin:Z

    if-nez v4, :cond_1

    .line 828
    iput-boolean v3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mUpTriggerable:Z

    .line 830
    :cond_1
    iget-boolean v4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mUpTriggerable:Z

    .line 831
    iget-object v5, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz v5, :cond_5

    .line 833
    iput-object v5, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    .line 834
    invoke-static {p2}, Ljava/lang/Math;->abs(I)I

    move-result p1

    iget-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v5, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v5, v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    if-le p1, v5, :cond_4

    iget-boolean p1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpActionBegin:Z

    if-nez p1, :cond_4

    .line 835
    iput-boolean v1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpActionBegin:Z

    .line 836
    iput-boolean v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mUpTriggerable:Z

    .line 837
    iget-object p1, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1, v3}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 838
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1, v3}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 839
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->isNoData()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 840
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 841
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1, v2}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 842
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->getCountNoData()I

    move-result p1

    const/4 p2, 0x3

    if-ge p1, p2, :cond_2

    .line 843
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p1, p1, v0

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 845
    :cond_2
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p1, p1, p2

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 848
    :cond_3
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, v3}, Landroid/view/View;->setVisibility(I)V

    .line 849
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {p1, v3}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 850
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 851
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p1, p1, v3

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 853
    :goto_0
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onEntered()V

    .line 855
    :cond_4
    iget-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mUpTriggerable:Z

    if-eq v4, p1, :cond_5

    if-eqz p1, :cond_5

    .line 857
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->notifyActivated()V

    .line 858
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-ne p2, v0, :cond_5

    .line 859
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    invoke-virtual {p2, v3, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    .line 860
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 861
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_5
    return-void

    .line 870
    :cond_6
    iput-boolean v3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mUpTriggerable:Z

    .line 871
    iget p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionIndex:I

    .line 872
    iget-boolean v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    .line 873
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    move v4, v3

    .line 875
    :goto_1
    iget-object v5, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v5, v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    if-ge v4, v5, :cond_7

    iget-object v5, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget v6, v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    iget-object v5, v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {v5, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v5, v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    if-le v6, v5, :cond_7

    .line 876
    iget-object v5, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iput v4, v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionIndex:I

    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 879
    :cond_7
    iget-object v4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget v5, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionIndex:I

    const/4 v6, 0x0

    if-ltz v5, :cond_9

    .line 881
    iget-object v7, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {v7, v5}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iput-object v5, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    .line 882
    iget-object v4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget v5, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    iget-object v4, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v4, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    if-lt v5, v4, :cond_8

    move v4, v1

    goto :goto_2

    :cond_8
    move v4, v3

    :goto_2
    iput-boolean v4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    goto :goto_3

    .line 884
    :cond_9
    iput-object v6, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    .line 885
    iput-boolean v3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    .line 887
    :goto_3
    iget-object v4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget v5, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionIndex:I

    if-eq p2, v5, :cond_10

    if-eqz p1, :cond_a

    .line 889
    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onExit()V

    .line 890
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->removeAllViews()V

    .line 891
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iput-object v6, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    .line 893
    :cond_a
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p2, :cond_f

    .line 894
    instance-of v0, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    if-eqz v0, :cond_c

    .line 895
    check-cast p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    .line 896
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result p1

    if-nez p1, :cond_b

    .line 897
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 898
    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayoutInflater:Landroid/view/LayoutInflater;

    iget-object v4, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p2, v0, v4}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;->onCreateIndicator(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    iput-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    .line 900
    :cond_b
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 901
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    invoke-virtual {p1, p2, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->viewShow(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 902
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 903
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p1, v2}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_4

    .line 905
    :cond_c
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, v3}, Landroid/view/View;->setVisibility(I)V

    .line 906
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {p1, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 907
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->removeAllViews()V

    .line 908
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iput-object v6, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    .line 909
    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p1, v2}, Landroid/view/ViewGroup;->setVisibility(I)V

    .line 911
    :goto_4
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onEntered()V

    .line 912
    iput-boolean v3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mLockActivated:Z

    .line 913
    iget-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    if-eqz p1, :cond_e

    .line 914
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    instance-of p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    if-eqz p2, :cond_d

    .line 915
    iput-boolean v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mLockActivated:Z

    .line 917
    :cond_d
    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onActivated()V

    :cond_e
    return-void

    .line 922
    :cond_f
    iget-object p0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->setVisibility(I)V

    goto :goto_5

    :cond_10
    if-eqz p1, :cond_13

    .line 923
    iget-boolean p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    if-eq v0, p2, :cond_13

    if-eqz v0, :cond_11

    .line 925
    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onEntered()V

    .line 926
    iput-boolean v3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mLockActivated:Z

    return-void

    .line 929
    :cond_11
    iget-object p2, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    instance-of p2, p2, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    if-eqz p2, :cond_12

    .line 930
    iput-boolean v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mLockActivated:Z

    .line 932
    :cond_12
    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onActivated()V

    .line 933
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    instance-of p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    if-eqz p1, :cond_13

    .line 934
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    const/4 p1, 0x4

    invoke-virtual {p0, p1}, Landroid/widget/ProgressBar;->setVisibility(I)V

    :cond_13
    :goto_5
    return-void
.end method

.method public handleSpringBack()Z
    .locals 6

    .line 781
    iget-boolean v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    const/4 v1, 0x0

    const/16 v2, 0x8

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-nez v0, :cond_1

    :cond_0
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v3, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz v3, :cond_1

    instance-of v3, v3, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    if-eqz v3, :cond_1

    .line 782
    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->removeAllViews()V

    .line 783
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iput-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    .line 784
    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->setVisibility(I)V

    .line 786
    :cond_1
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v3, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    const/4 v4, 0x0

    if-nez v3, :cond_2

    return v4

    .line 789
    :cond_2
    instance-of v3, v3, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    const/4 v5, 0x1

    if-eqz v3, :cond_5

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-eq v0, v2, :cond_5

    .line 790
    iget-boolean v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mTriggerable:Z

    if-eqz v0, :cond_3

    .line 791
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    neg-int v0, v0

    invoke-virtual {v1, v4, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    .line 792
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 793
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    invoke-virtual {p0, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    goto :goto_0

    .line 795
    :cond_3
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->getScaleY()F

    move-result v0

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v1, v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    invoke-static {v1}, Ljava/lang/Math;->abs(I)I

    move-result v1

    int-to-float v1, v1

    cmpg-float v0, v0, v1

    if-gez v0, :cond_4

    .line 796
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onExit()V

    .line 798
    :cond_4
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p0, v4, v4}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    :goto_0
    return v5

    .line 801
    :cond_5
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v3, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    instance-of v3, v3, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    if-eqz v3, :cond_7

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {v0}, Landroid/widget/RelativeLayout;->getVisibility()I

    move-result v0

    if-ne v0, v2, :cond_6

    goto :goto_1

    .line 814
    :cond_6
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    invoke-virtual {v1, v4, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    .line 815
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 816
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    invoke-virtual {p0, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    return v5

    .line 802
    :cond_7
    :goto_1
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 803
    iget-object v3, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionTriggered:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;

    invoke-virtual {v0, v3}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 804
    iget-boolean v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->mLockActivated:Z

    if-eqz v0, :cond_8

    .line 805
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->notifyTriggered()V

    goto :goto_2

    .line 807
    :cond_8
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    invoke-virtual {v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onExit()V

    .line 809
    :goto_2
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {v0}, Landroid/view/ViewGroup;->removeAllViews()V

    .line 810
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iput-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleActionView:Landroid/view/View;

    .line 811
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->setVisibility(I)V

    return v4
.end method
