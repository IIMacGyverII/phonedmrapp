.class public Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
.super Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
.source "SimpleViewBehavior.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder<",
        "Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;",
        ">;"
    }
.end annotation


# instance fields
.field private targetAlpha:F

.field private targetBackgroundColor:I

.field private targetHeight:I

.field private targetRotateX:F

.field private targetRotateY:F

.field private targetWidth:I

.field private targetX:I

.field private targetY:I


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 156
    invoke-direct {p0}, Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;-><init>()V

    const v0, 0x7fffffff

    .line 158
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetX:I

    .line 159
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetY:I

    .line 160
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetWidth:I

    .line 161
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetHeight:I

    .line 162
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetBackgroundColor:I

    const v0, 0x7f7fffff    # Float.MAX_VALUE

    .line 163
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetAlpha:F

    .line 164
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetRotateX:F

    .line 165
    iput v0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetRotateY:F

    return-void
.end method

.method static synthetic access$000(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetX:I

    return p0
.end method

.method static synthetic access$100(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetY:I

    return p0
.end method

.method static synthetic access$200(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetWidth:I

    return p0
.end method

.method static synthetic access$300(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetHeight:I

    return p0
.end method

.method static synthetic access$400(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)I
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetBackgroundColor:I

    return p0
.end method

.method static synthetic access$500(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)F
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetAlpha:F

    return p0
.end method

.method static synthetic access$600(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)F
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetRotateX:F

    return p0
.end method

.method static synthetic access$700(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;)F
    .locals 0

    .line 156
    iget p0, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetRotateY:F

    return p0
.end method


# virtual methods
.method public build()Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;
    .locals 2

    .line 213
    new-instance v0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior;-><init>(Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$1;)V

    return-object v0
.end method

.method bridge synthetic getThis()Lcom/pri/didouix/viewbehavior/PercentageViewBehavior$Builder;
    .locals 0

    .line 156
    invoke-virtual {p0}, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->getThis()Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;

    move-result-object p0

    return-object p0
.end method

.method getThis()Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    return-object p0
.end method

.method public targetAlpha(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    int-to-float p1, p1

    .line 198
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetAlpha:F

    return-object p0
.end method

.method public targetBackgroundColor(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    .line 193
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetBackgroundColor:I

    return-object p0
.end method

.method public targetHeight(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    .line 188
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetHeight:I

    return-object p0
.end method

.method public targetRotateX(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    int-to-float p1, p1

    .line 203
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetRotateX:F

    return-object p0
.end method

.method public targetRotateY(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    int-to-float p1, p1

    .line 208
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetRotateY:F

    return-object p0
.end method

.method public targetWidth(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    .line 183
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetWidth:I

    return-object p0
.end method

.method public targetX(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    .line 173
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetX:I

    return-object p0
.end method

.method public targetY(I)Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;
    .locals 0

    .line 178
    iput p1, p0, Lcom/pri/didouix/viewbehavior/SimpleViewBehavior$Builder;->targetY:I

    return-object p0
.end method
