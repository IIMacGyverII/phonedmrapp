.class public Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;
.super Landroidx/coordinatorlayout/widget/CoordinatorLayout$Behavior;
.source "PercentageViewBehavior.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<V:",
        "Landroid/view/View;",
        ">",
        "Landroidx/coordinatorlayout/widget/CoordinatorLayout$Behavior<",
        "TV;>;"
    }
.end annotation


# static fields
.field public static final DEPEND_TYPE_HEIGHT:I = 0x0

.field public static final DEPEND_TYPE_WIDTH:I = 0x1

.field public static final DEPEND_TYPE_X:I = 0x2

.field public static final DEPEND_TYPE_Y:I = 0x3

.field private static final TAG:Ljava/lang/String; = "PercentageViewBehavior"

.field static final UNSPECIFIED_FLOAT:F = 3.4028235E38f

.field static final UNSPECIFIED_INT:I = 0x7fffffff


# instance fields
.field private isPrepared:Z

.field private mDependStartHeight:I

.field private mDependStartWidth:I

.field private mDependStartX:I

.field private mDependStartY:I

.field private mDependTarget:I

.field private mDependType:I

.field private mDependViewId:I


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    .line 67
    invoke-direct {p0, p1, p2}, Landroidx/coordinatorlayout/widget/CoordinatorLayout$Behavior;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 70
    sget-object v0, Lcom/pri/R$styleable;->ViewBehavior:[I

    invoke-virtual {p1, p2, v0}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object p1

    .line 71
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_dependsOn:I

    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependViewId:I

    .line 72
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_dependType:I

    const/4 v0, 0x1

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependType:I

    .line 73
    sget p2, Lcom/pri/R$styleable;->ViewBehavior_behavior_dependTarget:I

    const v0, 0x7fffffff

    invoke-virtual {p1, p2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelOffset(II)I

    move-result p2

    iput p2, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependTarget:I

    .line 74
    invoke-virtual {p1}, Landroid/content/res/TypedArray;->recycle()V

    return-void
.end method

.method constructor <init>(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)V
    .locals 1
    .param p1    # Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 77
    invoke-direct {p0}, Landroidx/coordinatorlayout/widget/CoordinatorLayout$Behavior;-><init>()V

    .line 78
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->access$000(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependViewId:I

    .line 79
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->access$100(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)I

    move-result v0

    iput v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependType:I

    .line 80
    invoke-static {p1}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->access$200(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependTarget:I

    return-void
.end method


# virtual methods
.method public layoutDependsOn(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)Z
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroidx/coordinatorlayout/widget/CoordinatorLayout;",
            "TV;",
            "Landroid/view/View;",
            ")Z"
        }
    .end annotation

    .line 102
    invoke-virtual {p3}, Landroid/view/View;->getId()I

    move-result p1

    iget p0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependViewId:I

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public onDependentViewChanged(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)Z
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroidx/coordinatorlayout/widget/CoordinatorLayout;",
            "TV;",
            "Landroid/view/View;",
            ")Z"
        }
    .end annotation

    .line 108
    iget-boolean v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->isPrepared:Z

    if-nez v0, :cond_0

    .line 109
    invoke-virtual {p0, p1, p2, p3}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->prepare(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)V

    .line 111
    :cond_0
    invoke-virtual {p0, p2, p3}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->updateView(Landroid/view/View;Landroid/view/View;)V

    const/4 p0, 0x0

    return p0
.end method

.method public onLayoutChild(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;I)Z
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroidx/coordinatorlayout/widget/CoordinatorLayout;",
            "TV;I)Z"
        }
    .end annotation

    .line 117
    invoke-super {p0, p1, p2, p3}, Landroidx/coordinatorlayout/widget/CoordinatorLayout$Behavior;->onLayoutChild(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;I)Z

    move-result p3

    .line 118
    iget-boolean v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->isPrepared:Z

    if-eqz v0, :cond_0

    .line 119
    invoke-virtual {p1, p2}, Landroidx/coordinatorlayout/widget/CoordinatorLayout;->getDependencies(Landroid/view/View;)Ljava/util/List;

    move-result-object p1

    const/4 v0, 0x0

    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/View;

    invoke-virtual {p0, p2, p1}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->updateView(Landroid/view/View;Landroid/view/View;)V

    :cond_0
    return p3
.end method

.method prepare(Landroidx/coordinatorlayout/widget/CoordinatorLayout;Landroid/view/View;Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroidx/coordinatorlayout/widget/CoordinatorLayout;",
            "TV;",
            "Landroid/view/View;",
            ")V"
        }
    .end annotation

    .line 91
    invoke-virtual {p3}, Landroid/view/View;->getX()F

    move-result p1

    float-to-int p1, p1

    iput p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartX:I

    .line 92
    invoke-virtual {p3}, Landroid/view/View;->getY()F

    move-result p1

    float-to-int p1, p1

    iput p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartY:I

    .line 93
    invoke-virtual {p3}, Landroid/view/View;->getWidth()I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartWidth:I

    .line 94
    invoke-virtual {p3}, Landroid/view/View;->getHeight()I

    move-result p1

    iput p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartHeight:I

    const/4 p1, 0x1

    .line 96
    iput-boolean p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->isPrepared:Z

    return-void
.end method

.method updateView(Landroid/view/View;Landroid/view/View;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TV;",
            "Landroid/view/View;",
            ")V"
        }
    .end annotation

    .line 135
    iget v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependType:I

    const/high16 v1, 0x4f000000

    const/4 v2, 0x0

    if-eqz v0, :cond_3

    const/4 v3, 0x1

    if-eq v0, v3, :cond_2

    const/4 v3, 0x2

    if-eq v0, v3, :cond_1

    const/4 v3, 0x3

    if-eq v0, v3, :cond_0

    move v3, v1

    move p2, v2

    move v0, p2

    goto :goto_1

    .line 152
    :cond_0
    iget v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartY:I

    int-to-float v0, v0

    .line 153
    invoke-virtual {p2}, Landroid/view/View;->getY()F

    move-result p2

    .line 154
    iget v3, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependTarget:I

    goto :goto_0

    .line 147
    :cond_1
    iget v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartX:I

    int-to-float v0, v0

    .line 148
    invoke-virtual {p2}, Landroid/view/View;->getX()F

    move-result p2

    .line 149
    iget v3, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependTarget:I

    goto :goto_0

    .line 137
    :cond_2
    iget v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartWidth:I

    int-to-float v0, v0

    .line 138
    invoke-virtual {p2}, Landroid/view/View;->getWidth()I

    move-result p2

    int-to-float p2, p2

    .line 139
    iget v3, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependTarget:I

    goto :goto_0

    .line 142
    :cond_3
    iget v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependStartHeight:I

    int-to-float v0, v0

    .line 143
    invoke-virtual {p2}, Landroid/view/View;->getHeight()I

    move-result p2

    int-to-float p2, p2

    .line 144
    iget v3, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->mDependTarget:I

    :goto_0
    int-to-float v3, v3

    :goto_1
    cmpl-float v1, v3, v1

    if-eqz v1, :cond_4

    sub-float/2addr p2, v0

    .line 160
    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p2

    sub-float/2addr v3, v0

    invoke-static {v3}, Ljava/lang/Math;->abs(F)F

    move-result v0

    div-float v2, p2, v0

    :cond_4
    const/high16 p2, 0x3f800000    # 1.0f

    cmpl-float v0, v2, p2

    if-lez v0, :cond_5

    move v2, p2

    .line 162
    :cond_5
    invoke-virtual {p0, p1, v2}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;->updateViewWithPercent(Landroid/view/View;F)V

    return-void
.end method

.method updateViewWithPercent(Landroid/view/View;F)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TV;F)V"
        }
    .end annotation

    .line 172
    instance-of v0, p1, Lcom/pri/didouix/viewbehavior/PercentageChildView;

    if-eqz v0, :cond_0

    .line 173
    check-cast p1, Lcom/pri/didouix/viewbehavior/PercentageChildView;

    invoke-interface {p1, p0, p2}, Lcom/pri/didouix/viewbehavior/PercentageChildView;->onPercentageBehaviorChange(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;F)V

    :cond_0
    return-void
.end method
