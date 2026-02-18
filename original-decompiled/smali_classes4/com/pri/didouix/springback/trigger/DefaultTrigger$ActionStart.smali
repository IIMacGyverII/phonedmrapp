.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ActionStart"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method private constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 1

    .line 1005
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    const/4 v0, 0x0

    .line 1006
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V
    .locals 0

    .line 1004
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$ActionStart;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    return-void
.end method


# virtual methods
.method public handleScrollStateChange(II)V
    .locals 0

    .line 1011
    invoke-super {p0, p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->handleScrollStateChange(II)V

    return-void
.end method

.method public handleScrolled(II)V
    .locals 0

    .line 1016
    invoke-super {p0, p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->handleScrolled(II)V

    return-void
.end method

.method public handleSpringBack()Z
    .locals 0

    .line 1021
    invoke-super {p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->handleSpringBack()Z

    move-result p0

    return p0
.end method
