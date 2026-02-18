.class public abstract Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "SimpleAction"
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 662
    sget v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleEnter:I

    sget v1, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mSimpleTrigger:I

    invoke-direct {p0, v0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;-><init>(II)V

    return-void
.end method


# virtual methods
.method public onCreateIndicator(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method
