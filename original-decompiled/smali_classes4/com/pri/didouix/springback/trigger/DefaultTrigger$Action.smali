.class public abstract Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "Action"
.end annotation


# static fields
.field static final DISTANCE_COMPARATOR:Ljava/util/Comparator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Comparator<",
            "Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field mEnterPoint:I

.field mTriggerPoint:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 667
    new-instance v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action$1;

    invoke-direct {v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action$1;-><init>()V

    sput-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->DISTANCE_COMPARATOR:Ljava/util/Comparator;

    return-void
.end method

.method constructor <init>(II)V
    .locals 0

    .line 690
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 691
    iput p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    .line 692
    iput p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mTriggerPoint:I

    return-void
.end method


# virtual methods
.method public notifyActivated()V
    .locals 0

    .line 712
    invoke-virtual {p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onActivated()V

    return-void
.end method

.method public notifyEntered()V
    .locals 0

    .line 702
    invoke-virtual {p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onEntered()V

    return-void
.end method

.method public notifyExit()V
    .locals 0

    .line 707
    invoke-virtual {p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onExit()V

    return-void
.end method

.method public notifyTriggered()V
    .locals 0

    .line 697
    invoke-virtual {p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->onTriggered()V

    return-void
.end method

.method public abstract onActivated()V
.end method

.method public abstract onEntered()V
.end method

.method public abstract onExit()V
.end method

.method public abstract onFinished()V
.end method

.method public abstract onTriggered()V
.end method
