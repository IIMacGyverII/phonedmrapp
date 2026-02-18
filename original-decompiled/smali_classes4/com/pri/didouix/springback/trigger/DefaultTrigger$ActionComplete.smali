.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ActionComplete"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method private constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 1

    .line 1026
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    const/4 v0, 0x0

    .line 1027
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V
    .locals 0

    .line 1025
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    return-void
.end method


# virtual methods
.method public handleScrollStateChange(II)V
    .locals 0

    .line 1032
    invoke-super {p0, p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->handleScrollStateChange(II)V

    if-nez p2, :cond_0

    .line 1034
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionComplete;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 1035
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_0
    return-void
.end method
