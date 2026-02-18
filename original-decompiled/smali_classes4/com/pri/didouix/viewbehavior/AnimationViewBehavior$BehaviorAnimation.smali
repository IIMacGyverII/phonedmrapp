.class Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;
.super Landroid/view/animation/Animation;
.source "AnimationViewBehavior.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "BehaviorAnimation"
.end annotation


# instance fields
.field private mTransformation:Landroid/view/animation/Transformation;


# direct methods
.method constructor <init>()V
    .locals 2

    .line 76
    invoke-direct {p0}, Landroid/view/animation/Animation;-><init>()V

    const-wide/16 v0, 0x0

    .line 78
    invoke-virtual {p0, v0, v1}, Landroid/view/animation/Animation;->setDuration(J)V

    const/4 v0, 0x1

    .line 79
    invoke-virtual {p0, v0}, Landroid/view/animation/Animation;->setFillAfter(Z)V

    return-void
.end method


# virtual methods
.method protected applyTransformation(FLandroid/view/animation/Transformation;)V
    .locals 1

    .line 84
    iget-object v0, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;->mTransformation:Landroid/view/animation/Transformation;

    if-eqz v0, :cond_0

    .line 85
    invoke-virtual {p2, v0}, Landroid/view/animation/Transformation;->compose(Landroid/view/animation/Transformation;)V

    .line 87
    :cond_0
    invoke-super {p0, p1, p2}, Landroid/view/animation/Animation;->applyTransformation(FLandroid/view/animation/Transformation;)V

    return-void
.end method

.method setTransformation(Landroid/view/animation/Transformation;)V
    .locals 0

    .line 91
    iput-object p1, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$BehaviorAnimation;->mTransformation:Landroid/view/animation/Transformation;

    return-void
.end method
