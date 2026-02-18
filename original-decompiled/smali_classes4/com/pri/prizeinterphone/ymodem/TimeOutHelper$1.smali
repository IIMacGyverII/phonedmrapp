.class Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$1;
.super Ljava/lang/Object;
.source "TimeOutHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;)V
    .locals 0

    .line 15
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$1;->this$0:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 18
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$1;->this$0:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->stopTimer()V

    .line 19
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$1;->this$0:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->-$$Nest$fgetlistener(Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;)Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 20
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$1;->this$0:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-static {p0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->-$$Nest$fgetlistener(Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;)Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

    move-result-object p0

    invoke-interface {p0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;->onTimeOut()V

    :cond_0
    return-void
.end method
