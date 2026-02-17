.class Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;
.super Ljava/lang/Object;
.source "TimeOutHelper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;
    }
.end annotation


# instance fields
.field private listener:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

.field private final timeoutHandler:Landroid/os/Handler;

.field private final timer:Ljava/lang/Runnable;


# direct methods
.method static bridge synthetic -$$Nest$fgetlistener(Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;)Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->listener:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

    return-object p0
.end method

.method constructor <init>()V
    .locals 1

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 13
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->timeoutHandler:Landroid/os/Handler;

    .line 15
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$1;-><init>(Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->timer:Ljava/lang/Runnable;

    return-void
.end method


# virtual methods
.method startTimer(Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;J)V
    .locals 0

    .line 26
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->listener:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

    .line 27
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->timeoutHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->timer:Ljava/lang/Runnable;

    invoke-virtual {p1, p0, p2, p3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method stopTimer()V
    .locals 1

    .line 31
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->timeoutHandler:Landroid/os/Handler;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    return-void
.end method

.method unRegisterListener()V
    .locals 1

    const/4 v0, 0x0

    .line 35
    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->listener:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

    return-void
.end method
