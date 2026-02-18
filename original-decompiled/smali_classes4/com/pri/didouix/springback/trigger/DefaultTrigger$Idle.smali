.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "Idle"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method private constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 1

    .line 735
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    const/4 v0, 0x0

    .line 736
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V
    .locals 0

    .line 734
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    return-void
.end method


# virtual methods
.method public handleScrollStateChange(II)V
    .locals 0

    if-eqz p1, :cond_0

    return-void

    :cond_0
    const/4 p1, 0x1

    if-eq p2, p1, :cond_1

    const/4 p1, 0x2

    if-ne p2, p1, :cond_2

    .line 744
    :cond_1
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 745
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_2
    return-void
.end method
