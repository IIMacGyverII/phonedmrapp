.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"

# interfaces
.implements Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;


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

    .line 287
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onActionComplete(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;)V
    .locals 3

    .line 330
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionStart:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

    if-ne v1, v2, :cond_3

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eq v1, p1, :cond_0

    goto :goto_0

    .line 333
    :cond_0
    iget-object p1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    if-eqz p1, :cond_2

    .line 334
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 335
    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    invoke-virtual {p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 336
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-nez p1, :cond_1

    .line 337
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    const/4 p1, 0x0

    invoke-virtual {p0, p1, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    :cond_1
    return-void

    .line 342
    :cond_2
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 343
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_3
    :goto_0
    return-void
.end method

.method public onActionLoadFail(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;)V
    .locals 3

    .line 347
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionStart:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

    if-ne v1, v2, :cond_2

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-ne v1, p1, :cond_2

    .line 348
    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 349
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicator:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    .line 350
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    const/4 v1, 0x1

    aget-object p1, p1, v1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 351
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    if-eqz p1, :cond_1

    .line 352
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 353
    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    invoke-virtual {p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 354
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-nez p1, :cond_0

    .line 355
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    const/4 p1, 0x0

    invoke-virtual {p0, p1, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    :cond_0
    return-void

    .line 360
    :cond_1
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 361
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_2
    return-void
.end method

.method public onActionNoData(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;I)V
    .locals 3

    .line 289
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    iget-object v2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionStart:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

    if-ne v1, v2, :cond_3

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-ne v1, p1, :cond_3

    const/4 v1, 0x3

    if-ge p2, v1, :cond_0

    .line 291
    iget-object p2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    const/4 v0, 0x2

    aget-object p1, p1, v0

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 293
    :cond_0
    iget-object p2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p1, p1, v1

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 295
    :goto_0
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    const/16 p2, 0x8

    invoke-virtual {p1, p2}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 296
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicator:Landroid/view/View;

    invoke-virtual {p1, p2}, Landroid/view/View;->setVisibility(I)V

    .line 297
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getScrollY()I

    move-result p1

    if-eqz p1, :cond_2

    .line 298
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 299
    iget-object p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    invoke-virtual {p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 300
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    if-nez p1, :cond_1

    .line 301
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    const/4 p1, 0x0

    invoke-virtual {p0, p1, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    :cond_1
    return-void

    .line 306
    :cond_2
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 307
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_3
    return-void
.end method

.method public onActionStart(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;)V
    .locals 5

    .line 312
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz v1, :cond_0

    if-ne v1, p1, :cond_0

    .line 314
    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-virtual {v0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    .line 315
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 316
    iget-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iput-object v1, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    .line 317
    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 318
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 319
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    invoke-virtual {v0, v1}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 320
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 321
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aget-object p1, p1, v1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 322
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    invoke-virtual {v0, v1, p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->smoothScrollTo(II)V

    .line 323
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getBottom()I

    move-result p1

    iget-object v2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v2, v2, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {v2}, Landroid/view/ViewGroup;->getWidth()I

    move-result v2

    iget-object v3, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v3, v3, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    invoke-virtual {v3}, Landroid/view/ViewGroup;->getBottom()I

    move-result v3

    iget-object v4, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object v4, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    iget v4, v4, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    sub-int/2addr v3, v4

    invoke-virtual {v0, v1, p1, v2, v3}, Landroid/widget/RelativeLayout;->layout(IIII)V

    .line 324
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 325
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_0
    return-void
.end method

.method public onUpdateTriggerTextIndex(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;ILjava/lang/String;)V
    .locals 0

    .line 366
    iget-object p0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    aput-object p3, p0, p2

    return-void
.end method
