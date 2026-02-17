.class public Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;
.super Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
.source "AnimationViewBehavior.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder<",
        "Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;",
        ">;"
    }
.end annotation


# instance fields
.field private animation:Landroid/view/animation/Animation;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 98
    invoke-direct {p0}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;)Landroid/view/animation/Animation;
    .locals 0

    .line 98
    iget-object p0, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;->animation:Landroid/view/animation/Animation;

    return-object p0
.end method


# virtual methods
.method public animation(Landroid/view/animation/Animation;)Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;
    .locals 0

    .line 108
    iput-object p1, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;->animation:Landroid/view/animation/Animation;

    return-object p0
.end method

.method public animationId(Landroid/content/Context;I)Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;
    .locals 0
    .param p2    # I
        .annotation build Landroidx/annotation/AnimRes;
        .end annotation
    .end param

    if-eqz p2, :cond_0

    .line 114
    invoke-static {p1, p2}, Landroid/view/animation/AnimationUtils;->loadAnimation(Landroid/content/Context;I)Landroid/view/animation/Animation;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;->animation:Landroid/view/animation/Animation;

    :cond_0
    return-object p0
.end method

.method public build()Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;
    .locals 2

    .line 120
    new-instance v0, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior;-><init>(Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$1;)V

    return-object v0
.end method

.method getThis()Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;
    .locals 0

    return-object p0
.end method

.method bridge synthetic getThis()Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
    .locals 0

    .line 98
    invoke-virtual {p0}, Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;->getThis()Lcom/pri/didouix/viewbehavior/AnimationViewBehavior$Builder;

    move-result-object p0

    return-object p0
.end method
