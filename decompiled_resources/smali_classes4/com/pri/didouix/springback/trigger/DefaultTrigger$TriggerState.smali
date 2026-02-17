.class abstract Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x402
    name = "TriggerState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method private constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 0

    .line 730
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;Lcom/pri/didouix/springback/trigger/DefaultTrigger$1;)V
    .locals 0

    .line 716
    invoke-direct {p0, p1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;-><init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V

    return-void
.end method


# virtual methods
.method public handleScrollStateChange(II)V
    .locals 0

    return-void
.end method

.method public handleScrolled(II)V
    .locals 0

    return-void
.end method

.method public handleSpringBack()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method
