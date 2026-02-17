.class public Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;
.super Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;
.source "SimpleViewBehavior.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
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
.field private mStartAlpha:F

.field private mStartBackgroundColor:I

.field private mStartHeight:I

.field private mStartRotateX:F

.field private mStartRotateY:F

.field private mStartWidth:I

.field private mStartX:I

.field private mStartY:I

.field private targetAlpha:F

.field private targetBackgroundColor:I

.field private targetHeight:I

.field private targetRotateX:F

.field private targetRotateY:F

.field private targetWidth:I

.field private targetX:I

.field private targetY:I


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    .line 50
    invoke-direct {p0, p1, p2}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 53
    sget-object v0, Lcom/pri/R$styleable;->ViewBehavior:[I

    invoke-virtual {p1, p2, v0}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object p1

    .line 54
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetX:I

    const v0, 0x7fffffff

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetX:I

    .line 55
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetY:I

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetY:I

    .line 56
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetWidth:I

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetWidth:I

    .line 57
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetHeight:I

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetHeight:I

    .line 58
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetBackgroundColor:I

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetBackgroundColor:I

    .line 59
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetAlpha:I

    const v0, 0x7f7fffff    # Float.MAX_VALUE

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetAlpha:F

    .line 60
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetRotateX:I

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetRotateX:F

    .line 61
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_targetRotateY:I

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetRotateY:F

    .line 62
    invoke-virtual {p1}, Landroid/content/res/TypedArray;->recycle()V

    return-void
.end method

.method private constructor <init>(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)V
    .locals 1
    .param p1    # Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 66
    invoke-direct {p0, p1}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;-><init>(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)V

    .line 67
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$000(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetX:I

    .line 68
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$100(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetY:I

    .line 69
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$200(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetWidth:I

    .line 70
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$300(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetHeight:I

    .line 71
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$400(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetBackgroundColor:I

    .line 72
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$500(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)F

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetAlpha:F

    .line 73
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$600(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)F

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetRotateX:F

    .line 74
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->access$700(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)F

    move-result p1

    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetRotateY:F

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$1;)V
    .locals 0

    .line 22
    invoke-direct {p0, p1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;-><init>(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)V

    return-void
.end method


# virtual methods
.method prepare(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 79
    invoke-super {p0, p1, p2, p3}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->prepare(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)V

    .line 81
    invoke-virtual {p2}, Landroid/view/View;->getX()F

    move-result p3

    float-to-int p3, p3

    iput p3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartX:I

    .line 82
    invoke-virtual {p2}, Landroid/view/View;->getY()F

    move-result p3

    float-to-int p3, p3

    iput p3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartY:I

    .line 83
    invoke-virtual {p2}, Landroid/view/View;->getWidth()I

    move-result p3

    iput p3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartWidth:I

    .line 84
    invoke-virtual {p2}, Landroid/view/View;->getHeight()I

    move-result p3

    iput p3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartHeight:I

    .line 85
    invoke-virtual {p2}, Landroid/view/View;->getAlpha()F

    move-result p3

    iput p3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartAlpha:F

    .line 86
    invoke-virtual {p2}, Landroid/view/View;->getRotationX()F

    move-result p3

    iput p3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartRotateX:F

    .line 87
    invoke-virtual {p2}, Landroid/view/View;->getRotationY()F

    move-result p3

    iput p3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartRotateY:F

    .line 90
    invoke-virtual {p2}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object p2

    .line 91
    instance-of p3, p2, Landroid/graphics/drawable/ColorDrawable;

    if-eqz p3, :cond_0

    .line 92
    check-cast p2, Landroid/graphics/drawable/ColorDrawable;

    invoke-virtual {p2}, Landroid/graphics/drawable/ColorDrawable;->getColor()I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartBackgroundColor:I

    .line 96
    :cond_0
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getFitsSystemWindows()Z

    move-result p2

    if-eqz p2, :cond_2

    iget p2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetY:I

    const p3, 0x7fffffff

    if-eq p2, p3, :cond_2

    const/4 p2, 0x0

    .line 98
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    const-string/jumbo p3, "status_bar_height"

    const-string v0, "dimen"

    const-string v1, "android"

    .line 99
    invoke-virtual {p1, p3, v0, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p3

    if-lez p3, :cond_1

    .line 101
    invoke-virtual {p1, p3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p2

    .line 103
    :cond_1
    iget p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetY:I

    add-int/2addr p1, p2

    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetY:I

    :cond_2
    return-void
.end method

.method updateViewWithPercent(Landroid/view/View;F)V
    .locals 8

    .line 109
    invoke-super {p0, p1, p2}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->updateViewWithPercent(Landroid/view/View;F)V

    .line 111
    iget v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetX:I

    const/4 v1, 0x0

    const v2, 0x7fffffff

    if-ne v0, v2, :cond_0

    move v0, v1

    goto :goto_0

    :cond_0
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartX:I

    sub-int/2addr v0, v3

    int-to-float v0, v0

    mul-float/2addr v0, p2

    .line 112
    :goto_0
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetY:I

    if-ne v3, v2, :cond_1

    goto :goto_1

    :cond_1
    iget v1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartY:I

    sub-int/2addr v3, v1

    int-to-float v1, v3

    mul-float/2addr v1, p2

    .line 115
    :goto_1
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetWidth:I

    if-ne v3, v2, :cond_2

    iget v4, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetHeight:I

    if-eq v4, v2, :cond_3

    .line 116
    :cond_2
    iget v4, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartWidth:I

    int-to-float v5, v4

    sub-int/2addr v3, v4

    int-to-float v3, v3

    mul-float/2addr v3, p2

    add-float/2addr v5, v3

    .line 117
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartHeight:I

    int-to-float v6, v3

    iget v7, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetHeight:I

    sub-int/2addr v7, v3

    int-to-float v3, v7

    mul-float/2addr v3, p2

    add-float/2addr v6, v3

    int-to-float v3, v4

    div-float v3, v5, v3

    .line 119
    invoke-virtual {p1, v3}, Landroid/view/View;->setScaleX(F)V

    .line 120
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartHeight:I

    int-to-float v3, v3

    div-float v3, v6, v3

    invoke-virtual {p1, v3}, Landroid/view/View;->setScaleY(F)V

    .line 122
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartWidth:I

    int-to-float v3, v3

    sub-float/2addr v3, v5

    const/high16 v4, 0x40000000    # 2.0f

    div-float/2addr v3, v4

    sub-float/2addr v0, v3

    .line 123
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartHeight:I

    int-to-float v3, v3

    sub-float/2addr v3, v6

    div-float/2addr v3, v4

    sub-float/2addr v1, v3

    .line 127
    :cond_3
    invoke-virtual {p1, v0}, Landroid/view/View;->setTranslationX(F)V

    .line 128
    invoke-virtual {p1, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 131
    iget v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetAlpha:F

    const v1, 0x7f7fffff    # Float.MAX_VALUE

    cmpl-float v3, v0, v1

    if-eqz v3, :cond_4

    .line 132
    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartAlpha:F

    sub-float/2addr v0, v3

    mul-float/2addr v0, p2

    add-float/2addr v3, v0

    invoke-virtual {p1, v3}, Landroid/view/View;->setAlpha(F)V

    .line 136
    :cond_4
    iget v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetBackgroundColor:I

    if-eq v0, v2, :cond_5

    iget v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartBackgroundColor:I

    if-eqz v0, :cond_5

    .line 137
    new-instance v0, Landroid/animation/ArgbEvaluator;

    invoke-direct {v0}, Landroid/animation/ArgbEvaluator;-><init>()V

    .line 138
    iget v2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartBackgroundColor:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    iget v3, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetBackgroundColor:I

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v0, p2, v2, v3}, Landroid/animation/ArgbEvaluator;->evaluate(FLjava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 139
    invoke-virtual {p1, v0}, Landroid/view/View;->setBackgroundColor(I)V

    .line 143
    :cond_5
    iget v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetRotateX:F

    cmpl-float v2, v0, v1

    if-eqz v2, :cond_6

    .line 144
    iget v2, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartRotateX:F

    sub-float/2addr v0, v2

    mul-float/2addr v0, p2

    add-float/2addr v2, v0

    invoke-virtual {p1, v2}, Landroid/view/View;->setRotationX(F)V

    .line 146
    :cond_6
    iget v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->targetRotateY:F

    cmpl-float v1, v0, v1

    if-eqz v1, :cond_7

    .line 147
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;->mStartRotateY:F

    sub-float/2addr v0, p0

    mul-float/2addr v0, p2

    add-float/2addr p0, v0

    invoke-virtual {p1, p0}, Landroid/view/View;->setRotationY(F)V

    .line 150
    :cond_7
    invoke-virtual {p1}, Landroid/view/View;->requestLayout()V

    return-void
.end method
