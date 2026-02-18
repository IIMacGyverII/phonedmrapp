.class Lcom/pri/prizeinterphone/widget/CircleProgressDrawable$1;
.super Ljava/lang/Object;
.source "CircleProgressDrawable.java"

# interfaces
.implements Landroid/animation/ValueAnimator$AnimatorUpdateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;->setProgress(IJ)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;)V
    .locals 0

    .line 146
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/CircleProgressDrawable$1;->this$0:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onAnimationUpdate(Landroid/animation/ValueAnimator;)V
    .locals 1

    .line 149
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/CircleProgressDrawable$1;->this$0:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-static {v0, p1}, Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;->-$$Nest$fputmProgress(Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;I)V

    .line 150
    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/CircleProgressDrawable$1;->this$0:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method
