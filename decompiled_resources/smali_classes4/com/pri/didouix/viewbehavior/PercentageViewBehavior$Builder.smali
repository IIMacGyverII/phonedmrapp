.class abstract Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
.super Ljava/lang/Object;
.source "PercentageViewBehavior.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/viewbehavior/PercentageViewBehavior;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x408
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T:",
        "Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;",
        ">",
        "Ljava/lang/Object;"
    }
.end annotation


# instance fields
.field private dependsOn:I

.field private dependsType:I

.field private targetValue:I


# direct methods
.method constructor <init>()V
    .locals 1

    .line 180
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const v0, 0x7fffffff

    .line 183
    iput v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->dependsType:I

    .line 184
    iput v0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->targetValue:I

    return-void
.end method

.method static synthetic access$000(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)I
    .locals 0

    .line 180
    iget p0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->dependsOn:I

    return p0
.end method

.method static synthetic access$100(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)I
    .locals 0

    .line 180
    iget p0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->dependsType:I

    return p0
.end method

.method static synthetic access$200(Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;)I
    .locals 0

    .line 180
    iget p0, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->targetValue:I

    return p0
.end method


# virtual methods
.method dependsOn(II)Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
    .locals 0
    .param p1    # I
        .annotation build Landroidx/annotation/IdRes;
        .end annotation
    .end param
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(II)TT;"
        }
    .end annotation

    .line 189
    iput p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->dependsOn:I

    .line 190
    iput p2, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->dependsType:I

    .line 191
    invoke-virtual {p0}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->getThis()Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;

    move-result-object p0

    return-object p0
.end method

.method abstract getThis()Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()TT;"
        }
    .end annotation
.end method

.method targetValue(I)Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)TT;"
        }
    .end annotation

    .line 195
    iput p1, p0, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->targetValue:I

    .line 196
    invoke-virtual {p0}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;->getThis()Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;

    move-result-object p0

    return-object p0
.end method
