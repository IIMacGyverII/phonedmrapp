.class Lcom/pri/prizeinterphone/ymodem/YModem$1;
.super Ljava/lang/Object;
.source "YModem.java"

# interfaces
.implements Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/ymodem/YModem;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/ymodem/YModem;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/ymodem/YModem;)V
    .locals 0

    .line 349
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModem;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTimeOut()V
    .locals 1

    const-string v0, "------ time out ------"

    .line 352
    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 353
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModem;

    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/YModem;->-$$Nest$fgetcurrSending(Lcom/pri/prizeinterphone/ymodem/YModem;)[B

    move-result-object v0

    if-eqz v0, :cond_0

    .line 354
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModem;

    const-string v0, "package timeout..."

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/ymodem/YModem;->-$$Nest$mhandlePackageFail(Lcom/pri/prizeinterphone/ymodem/YModem;Ljava/lang/String;)V

    :cond_0
    return-void
.end method
