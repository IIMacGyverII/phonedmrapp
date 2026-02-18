.class public Lcom/pri/support/common/HorizontalOverScrollBounceEffectDecorator$AnimationAttributesHorizontal;
.super Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;
.source "HorizontalOverScrollBounceEffectDecorator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/support/common/HorizontalOverScrollBounceEffectDecorator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xc
    name = "AnimationAttributesHorizontal"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 69
    invoke-direct {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;-><init>()V

    .line 70
    sget-object v0, Landroid/view/View;->TRANSLATION_X:Landroid/util/Property;

    iput-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mProperty:Landroid/util/Property;

    return-void
.end method


# virtual methods
.method public init(Landroid/view/View;)V
    .locals 1

    .line 74
    invoke-virtual {p1}, Landroid/view/View;->getTranslationX()F

    move-result v0

    iput v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mAbsOffset:F

    .line 75
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p1

    int-to-float p1, p1

    iput p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;->mMaxOffset:F

    return-void
.end method
