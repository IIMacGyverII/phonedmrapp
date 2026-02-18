.class public Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator;
.super Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;
.source "VerticalOverScrollBounceEffectDecorator.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator$AnimationAttributesVertical;,
        Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator$MotionAttributesVertical;
    }
.end annotation


# static fields
.field private static final DRAG_BACK_RATIO:F = 1.0f

.field private static final DRAG_FWD_RATIO:F = 1.5f


# direct methods
.method public constructor <init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;)V
    .locals 3

    const/high16 v0, 0x3fc00000    # 1.5f

    const/high16 v1, 0x3f800000    # 1.0f

    const/4 v2, 0x0

    .line 12
    invoke-direct {p0, p1, v0, v1, v2}, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator;-><init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;FFF)V

    return-void
.end method

.method public constructor <init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;FFF)V
    .locals 0

    .line 17
    invoke-direct {p0, p1, p2, p3, p4}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;-><init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;FFF)V

    return-void
.end method


# virtual methods
.method public createAnimationAttributes()Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;
    .locals 0

    .line 30
    new-instance p0, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator$AnimationAttributesVertical;

    invoke-direct {p0}, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator$AnimationAttributesVertical;-><init>()V

    return-object p0
.end method

.method public createMotionAttributes()Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;
    .locals 0

    .line 21
    new-instance p0, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator$MotionAttributesVertical;

    invoke-direct {p0}, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator$MotionAttributesVertical;-><init>()V

    return-object p0
.end method

.method protected getTranslateValue(Landroid/view/View;)F
    .locals 0

    .line 26
    invoke-virtual {p1}, Landroid/view/View;->getTranslationY()F

    move-result p0

    return p0
.end method

.method public translateView(Landroid/view/View;F)V
    .locals 0

    .line 34
    invoke-virtual {p1, p2}, Landroid/view/View;->setTranslationY(F)V

    return-void
.end method

.method public translateViewAndEvent(Landroid/view/View;FLandroid/view/MotionEvent;)V
    .locals 0

    .line 38
    invoke-virtual {p1, p2}, Landroid/view/View;->setTranslationY(F)V

    const/4 p0, 0x0

    .line 39
    invoke-virtual {p3, p0}, Landroid/view/MotionEvent;->getY(I)F

    move-result p0

    sub-float/2addr p2, p0

    const/4 p0, 0x0

    .line 40
    invoke-virtual {p3, p0, p2}, Landroid/view/MotionEvent;->offsetLocation(FF)V

    return-void
.end method
