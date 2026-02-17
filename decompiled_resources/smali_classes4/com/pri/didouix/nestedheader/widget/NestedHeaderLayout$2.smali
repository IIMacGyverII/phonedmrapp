.class Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;
.super Ljava/lang/Object;
.source "NestedHeaderLayout.java"

# interfaces
.implements Landroid/animation/ValueAnimator$AnimatorUpdateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->autoAdsorption(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

.field final synthetic val$scrollingProgress:I


# direct methods
.method constructor <init>(Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;I)V
    .locals 0

    .line 306
    iput-object p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iput p2, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;->val$scrollingProgress:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onAnimationUpdate(Landroid/animation/ValueAnimator;)V
    .locals 2

    .line 309
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    iget-boolean v0, v0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isTouch:Z

    if-nez v0, :cond_0

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    if-eqz v0, :cond_0

    .line 310
    iget-object v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->syncScrollingProgress(I)V

    .line 314
    :cond_0
    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget v0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;->val$scrollingProgress:I

    if-ne p1, v0, :cond_1

    .line 315
    iget-object p0, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout$2;->this$0:Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;

    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/pri/didouix/nestedheader/widget/NestedHeaderLayout;->isAniming:Z

    :cond_1
    return-void
.end method
