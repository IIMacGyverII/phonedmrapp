.class Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;
.super Landroid/os/Handler;
.source "TouchPolicy.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "WorkerHandler"
.end annotation


# static fields
.field public static final MSG_ENABLE_SBB:I = 0x1

.field public static final MSG_RESET_SBB:I = 0x2


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;Landroid/os/Looper;)V
    .locals 0

    .line 136
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    .line 137
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 142
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_2

    const/4 v2, 0x2

    if-eq v0, v2, :cond_0

    goto :goto_1

    .line 147
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    if-eqz p1, :cond_1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    :goto_0
    invoke-static {p0, v1}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->-$$Nest$mresetSBBInternal(Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;Z)V

    goto :goto_1

    .line 144
    :cond_2
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;

    const/4 p1, -0x1

    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;->-$$Nest$menableSBBInternal(Lcom/mediatek/boostfwk/policy/touch/TouchPolicy;I)V

    :goto_1
    return-void
.end method
