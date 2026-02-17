.class Lcom/pri/didouix/springback/trigger/DefaultTrigger$4;
.super Ljava/lang/Object;
.source "DefaultTrigger.java"

# interfaces
.implements Lcom/pri/didouix/springback/view/SpringBackLayout$OnSpringListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;


# direct methods
.method constructor <init>(Lcom/pri/didouix/springback/trigger/DefaultTrigger;)V
    .locals 0

    .line 258
    iput-object p1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$4;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onSpringBack()Z
    .locals 0

    .line 260
    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$4;->this$0:Lcom/pri/didouix/springback/trigger/DefaultTrigger;

    iget-object p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mCurrentState:Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;

    invoke-virtual {p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$TriggerState;->handleSpringBack()Z

    move-result p0

    return p0
.end method
