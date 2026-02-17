.class public Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator$AnimationAttributesVertical;
.super Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;
.source "VerticalOverScrollBounceEffectDecorator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xc
    name = "AnimationAttributesVertical"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 70
    invoke-direct {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;-><init>()V

    .line 71
    sget-object v0, Landroid/view/View;->TRANSLATION_Y:Landroid/util/Property;

    iput-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mProperty:Landroid/util/Property;

    return-void
.end method


# virtual methods
.method public init(Landroid/view/View;)V
    .locals 1

    .line 75
    invoke-virtual {p1}, Landroid/view/View;->getTranslationY()F

    move-result v0

    iput v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mAbsOffset:F

    .line 76
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    iput p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mMaxOffset:F

    return-void
.end method
