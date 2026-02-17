.class public Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;
.super Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;
.source "AnimationViewBehavior.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;,
        Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/didouix/viewbehavior/PercentageViewBehavior<",
        "Landroid/view/View;",
        ">;"
    }
.end annotation


# instance fields
.field private mAnimation:Landroid/view/animation/Animation;

.field private mTransformAnimation:Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 2

    .line 26
    invoke-direct {p0, p1, p2}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 27
    sget-object v0, Lcom/pri/R$styleable;->ViewBehavior:[I

    invoke-virtual {p1, p2, v0}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object p2

    .line 28
    sget v0, Lcom/pri/R$styleable;->ViewBehavior_behavior_animation:I

    const/4 v1, 0x0

    invoke-virtual {p2, v0, v1}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v0

    .line 29
    invoke-virtual {p2}, Landroid/content/res/TypedArray;->recycle()V

    if-eqz v0, :cond_0

    .line 32
    invoke-static {p1, v0}, Landroid/view/animation/AnimationUtils;->loadAnimation(Landroid/content/Context;I)Landroid/view/animation/Animation;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mAnimation:Landroid/view/animation/Animation;

    :cond_0
    return-void
.end method

.method private constructor <init>(Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;)V
    .locals 0

    .line 37
    invoke-direct {p0, p1}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;-><init>(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)V

    .line 38
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;->access$000(Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;)Landroid/view/animation/Animation;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mAnimation:Landroid/view/animation/Animation;

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$1;)V
    .locals 0

    .line 20
    invoke-direct {p0, p1}, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;-><init>(Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;)V

    return-void
.end method


# virtual methods
.method prepare(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 43
    invoke-super {p0, p1, p2, p3}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->prepare(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)V

    .line 45
    iget-object p3, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mAnimation:Landroid/view/animation/Animation;

    if-eqz p3, :cond_0

    .line 46
    invoke-virtual {p2}, Landroid/view/View;->getWidth()I

    move-result v0

    invoke-virtual {p2}, Landroid/view/View;->getHeight()I

    move-result p2

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getWidth()I

    move-result v1

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getHeight()I

    move-result p1

    invoke-virtual {p3, v0, p2, v1, p1}, Landroid/view/animation/Animation;->initialize(IIII)V

    .line 47
    iget-object p1, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mAnimation:Landroid/view/animation/Animation;

    const-wide/16 p2, 0x0

    invoke-virtual {p1, p2, p3}, Landroid/view/animation/Animation;->setStartTime(J)V

    .line 48
    iget-object p0, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mAnimation:Landroid/view/animation/Animation;

    const-wide/16 p1, 0x3e8

    invoke-virtual {p0, p1, p2}, Landroid/view/animation/Animation;->setDuration(J)V

    :cond_0
    return-void
.end method

.method updateViewWithPercent(Landroid/view/View;F)V
    .locals 4

    .line 54
    invoke-super {p0, p1, p2}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->updateViewWithPercent(Landroid/view/View;F)V

    .line 55
    iget-object v0, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mAnimation:Landroid/view/animation/Animation;

    if-eqz v0, :cond_1

    .line 57
    new-instance v0, Landroid/view/animation/Transformation;

    invoke-direct {v0}, Landroid/view/animation/Transformation;-><init>()V

    .line 58
    iget-object v1, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mAnimation:Landroid/view/animation/Animation;

    invoke-virtual {v1}, Landroid/view/animation/Animation;->getDuration()J

    move-result-wide v2

    long-to-float v2, v2

    mul-float/2addr p2, v2

    float-to-long v2, p2

    invoke-virtual {v1, v2, v3, v0}, Landroid/view/animation/Animation;->getTransformation(JLandroid/view/animation/Transformation;)Z

    .line 61
    iget-object p2, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mTransformAnimation:Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;

    if-nez p2, :cond_0

    .line 62
    new-instance p2, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;

    invoke-direct {p2}, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;-><init>()V

    iput-object p2, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mTransformAnimation:Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;

    .line 64
    :cond_0
    iget-object p2, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mTransformAnimation:Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;

    invoke-virtual {p2, v0}, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;->setTransformation(Landroid/view/animation/Transformation;)V

    .line 65
    iget-object p0, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;->mTransformAnimation:Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;

    invoke-virtual {p1, p0}, Landroid/view/View;->setAnimation(Landroid/view/animation/Animation;)V

    :cond_1
    return-void
.end method
