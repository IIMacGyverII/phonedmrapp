.class public Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;,
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;
    }
.end annotation


# static fields
.field private static final OFFSET_RESET_STATE:F = 0.25f

.field private static final TAG:Ljava/lang/String; = "DefaultTrigger"

.field public static mIndeterminateDistance:I

.field public static mIndeterminateTop:I

.field public static mSimpleEnter:I

.field public static mSimpleTrigger:I

.field public static mUpIndeterminateDistance:I


# instance fields
.field public final mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

.field public mActionIndex:I

.field public final mActionStart:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

.field public final mActionTriggered:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;

.field public mActions:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;",
            ">;"
        }
    .end annotation
.end field

.field private mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

.field public mContainer:Landroid/widget/RelativeLayout;

.field private mContext:Landroid/content/Context;

.field public mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

.field public mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

.field public final mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

.field public mIndicatorContainer:Landroid/view/ViewGroup;

.field public mLastScrollDistance:I

.field public mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

.field private mLayoutChangeListener:Landroid/view/View$OnLayoutChangeListener;

.field public mLayoutInflater:Landroid/view/LayoutInflater;

.field public mLoadingIndicator:Landroid/widget/ProgressBar;

.field private mOnScrollListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;

.field private mOnSpringListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;

.field public mScrollDistance:I

.field public mScrollState:I

.field public mScrollerFinished:Z

.field public mSimpleActionView:Landroid/view/View;

.field public final mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

.field public mTrackingIndicator:Landroid/view/View;

.field public mTrackingIndicatorBottom:I

.field public mTrackingIndicatorLabel:Landroid/widget/TextView;

.field public mTrackingIndicatorLabelBottom:I

.field public mTrackingIndicatorLabelTop:I

.field public mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

.field public mUpActionBegin:Z

.field private mUpActionDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

.field public mUpContainer:Landroid/widget/RelativeLayout;

.field public mUpLoadingIndicator:Landroid/widget/ProgressBar;

.field public mUpTrackingContainer:Landroid/widget/RelativeLayout;

.field public mUpTrackingIndicator:Landroid/view/View;

.field public mUpTrackingIndicatorLabel:Landroid/widget/TextView;

.field public final mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 2

    .line 382
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 35
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionComplete:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;

    const/4 v0, -0x1

    .line 37
    iput v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionIndex:I

    .line 39
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionStart:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;

    .line 41
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionTriggered:Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;

    .line 43
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    .line 44
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;

    invoke-direct {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

    .line 89
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    .line 91
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    .line 98
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;

    invoke-direct {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$2;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayoutChangeListener:Landroid/view/View$OnLayoutChangeListener;

    .line 141
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;

    invoke-direct {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$3;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mOnScrollListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;

    .line 258
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$4;

    invoke-direct {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$4;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mOnSpringListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;

    const/4 v0, 0x1

    .line 268
    iput-boolean v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollerFinished:Z

    .line 272
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    const/4 v0, 0x0

    .line 276
    iput v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorBottom:I

    .line 280
    iput v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelBottom:I

    .line 282
    iput v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabelTop:I

    .line 286
    iput-boolean v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpActionBegin:Z

    .line 287
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;

    invoke-direct {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$5;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpActionDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    .line 380
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mWaitForIndeterminate:Lcom/pri/didouix/springback/trigger/DefaultTrigger$WaitForIndeterminate;

    .line 383
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->init(Landroid/content/Context;)V

    return-void
.end method

.method private init(Landroid/content/Context;)V
    .locals 3

    .line 387
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContext:Landroid/content/Context;

    .line 388
    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayoutInflater:Landroid/view/LayoutInflater;

    .line 389
    sget v1, Lcom/pri/R$layout;->didouix_sbl_trigger_layout:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/RelativeLayout;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    .line 390
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayoutInflater:Landroid/view/LayoutInflater;

    sget v1, Lcom/pri/R$layout;->didouix_sbl_trigger_up_layout:I

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/RelativeLayout;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    .line 391
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->indicator_container:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndicatorContainer:Landroid/view/ViewGroup;

    .line 392
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->tracking_progress:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicator:Landroid/view/View;

    .line 393
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->tracking_progress_label:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTrackingIndicatorLabel:Landroid/widget/TextView;

    .line 394
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->loading_progress:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ProgressBar;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLoadingIndicator:Landroid/widget/ProgressBar;

    .line 395
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->tracking_progress_up_container:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/RelativeLayout;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingContainer:Landroid/widget/RelativeLayout;

    .line 396
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->tracking_progress_up:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicator:Landroid/view/View;

    .line 397
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->tracking_progress_up_label:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    .line 398
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    sget v1, Lcom/pri/R$id;->loading_progress_up:I

    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ProgressBar;

    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpLoadingIndicator:Landroid/widget/ProgressBar;

    .line 399
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    sget v0, Lcom/pri/R$dimen;->didouix_sbl_action_indeterminate_distance:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p0

    sput p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndeterminateDistance:I

    .line 400
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    sget v0, Lcom/pri/R$dimen;->didouix_sbl_action_upindeterminate_distance:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p0

    sput p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpIndeterminateDistance:I

    .line 401
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    sget v0, Lcom/pri/R$dimen;->didouix_sbl_action_simple_enter:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p0

    sput p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleEnter:I

    .line 402
    sput p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleTrigger:I

    .line 403
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    sget p1, Lcom/pri/R$dimen;->didouix_sbl_tracking_progress_bg_margintop:I

    invoke-virtual {p0, p1}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p0

    sput p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndeterminateTop:I

    return-void
.end method

.method private updateTextIdToString(Landroid/content/Context;[I[Ljava/lang/String;)V
    .locals 2

    if-eqz p2, :cond_0

    const/4 p0, 0x0

    .line 649
    :goto_0
    array-length v0, p2

    if-ge p0, v0, :cond_0

    .line 650
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    aget v1, p2, p0

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    aput-object v0, p3, p0

    add-int/lit8 p0, p0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method


# virtual methods
.method public addAction(Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;)V
    .locals 3

    .line 419
    instance-of v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    if-eqz v0, :cond_0

    .line 420
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    .line 421
    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    .line 422
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpActionDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    iput-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    .line 423
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContext:Landroid/content/Context;

    iget-object v1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTextIDs:[I

    iget-object v2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    invoke-direct {p0, v0, v1, v2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->updateTextIdToString(Landroid/content/Context;[I[Ljava/lang/String;)V

    .line 424
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpTrackingIndicatorLabel:Landroid/widget/TextView;

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    const/4 v0, 0x0

    aget-object p1, p1, v0

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    .line 427
    :cond_0
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    sget-object v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->DISTANCE_COMPARATOR:Ljava/util/Comparator;

    invoke-static {v0, p1, v1}, Ljava/util/Collections;->binarySearch(Ljava/util/List;Ljava/lang/Object;Ljava/util/Comparator;)I

    move-result v0

    if-gez v0, :cond_2

    .line 429
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    neg-int v0, v0

    add-int/lit8 v0, v0, -0x1

    invoke-interface {v1, v0, p1}, Ljava/util/List;->add(ILjava/lang/Object;)V

    .line 430
    instance-of v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    if-eqz v0, :cond_1

    .line 431
    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    .line 432
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

    iput-object v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

    .line 433
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContext:Landroid/content/Context;

    iget-object v1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTextIDs:[I

    iget-object p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    invoke-direct {p0, v0, v1, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->updateTextIdToString(Landroid/content/Context;[I[Ljava/lang/String;)V

    :cond_1
    return-void

    .line 438
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "action conflict."

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public attach(Lcom/pri/didouix/springback/view/SpringBackLayout;)V
    .locals 1

    .line 407
    invoke-virtual {p1}, Lcom/pri/didouix/springback/view/SpringBackLayout;->springBackEnable()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    .line 408
    invoke-virtual {p1, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->setSpringBackEnable(Z)V

    .line 410
    :cond_0
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayout:Lcom/pri/didouix/springback/view/SpringBackLayout;

    .line 411
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 412
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpContainer:Landroid/widget/RelativeLayout;

    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 413
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mLayoutChangeListener:Landroid/view/View$OnLayoutChangeListener;

    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->addOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    .line 414
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mOnSpringListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;

    invoke-virtual {p1, v0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->setOnSpringListener(Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;)V

    .line 415
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mOnScrollListener:Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;

    invoke-virtual {p1, p0}, Lcom/pri/didouix/springback/view/SpringBackLayout;->addOnScrollListener(Lcom/pri/didouix/springback/view/SpringBackLayout$OnScrollListener;)V

    return-void
.end method

.method public containAction(Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;)Z
    .locals 3

    .line 460
    instance-of v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-nez v0, :cond_1

    if-eqz p1, :cond_0

    .line 461
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    move v1, v2

    :goto_0
    return v1

    .line 463
    :cond_1
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p0, :cond_2

    return v1

    :cond_2
    return v2
.end method

.method public isActionRunning()Z
    .locals 1

    .line 470
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    if-eqz v0, :cond_1

    .line 471
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    if-ne v0, p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method public isActionRunning(Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;)Z
    .locals 2

    .line 475
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    if-eqz v0, :cond_1

    .line 476
    iget-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    if-eq v0, v1, :cond_1

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eq p0, p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method public removeAction(Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;)Z
    .locals 3

    .line 442
    invoke-virtual {p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->isActionRunning()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 445
    :cond_0
    instance-of v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_1

    .line 446
    check-cast p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;

    iput-object v2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    .line 447
    iput-object v2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    return v1

    :cond_1
    if-eqz p1, :cond_3

    .line 450
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 451
    instance-of v0, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    if-eqz v0, :cond_2

    .line 452
    move-object v0, p1

    check-cast v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;

    iput-object v2, v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

    .line 454
    :cond_2
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActions:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    :cond_3
    return v1
.end method

.method public transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V
    .locals 1

    .line 1057
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    .line 1058
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    if-ne p1, v0, :cond_1

    .line 1059
    iget-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollerFinished:Z

    if-eqz p1, :cond_0

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p1, :cond_0

    .line 1060
    invoke-virtual {p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onFinished()V

    :cond_0
    const/4 p1, 0x0

    .line 1062
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    const/4 p1, -0x1

    .line 1063
    iput p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionIndex:I

    const/4 p1, 0x0

    .line 1064
    iput-boolean p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpActionBegin:Z

    :cond_1
    return-void
.end method

.method public viewShow(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 0

    if-eqz p2, :cond_1

    .line 1043
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result p0

    if-nez p0, :cond_0

    .line 1044
    invoke-virtual {p1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    :cond_0
    const/4 p0, 0x0

    .line 1046
    invoke-virtual {p1, p0}, Landroid/view/ViewGroup;->setVisibility(I)V

    :cond_1
    return-void
.end method
