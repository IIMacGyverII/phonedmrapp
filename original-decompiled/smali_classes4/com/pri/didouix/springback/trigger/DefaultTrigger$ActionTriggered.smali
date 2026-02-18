.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ActionTriggered"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method private constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 1

    .line 982
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    const/4 v0, 0x0

    .line 983
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V
    .locals 0

    .line 981
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    return-void
.end method


# virtual methods
.method public handleScrollStateChange(II)V
    .locals 0

    if-nez p2, :cond_0

    .line 989
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    .line 990
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIdle:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Idle;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_0
    return-void
.end method

.method public handleScrolled(II)V
    .locals 0

    .line 996
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionTriggered;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentAction:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;

    if-eqz p1, :cond_0

    instance-of p2, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$SimpleAction;

    if-eqz p2, :cond_0

    iget p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollDistance:I

    iget p1, p1, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;->mEnterPoint:I

    if-ge p2, p1, :cond_0

    iget p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mScrollState:I

    const/4 p2, 0x1

    if-ne p1, p2, :cond_0

    const/4 p1, -0x1

    .line 997
    iput p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mActionIndex:I

    .line 999
    iget-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mTracking:Lcom/pri/didouix/springback/trigger/DefaultTrigger$Tracking;

    invoke-virtual {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->transition(Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;)V

    :cond_0
    return-void
.end method
