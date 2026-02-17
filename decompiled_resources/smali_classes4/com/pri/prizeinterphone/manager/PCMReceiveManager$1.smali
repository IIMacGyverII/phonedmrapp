.class Lcom/pri/prizeinterphone/manager/PCMReceiveManager$1;
.super Landroid/os/ITinyRecvCallback$Stub;
.source "PCMReceiveManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/manager/PCMReceiveManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/manager/PCMReceiveManager;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;)V
    .locals 0

    .line 139
    iput-object p1, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    invoke-direct {p0}, Landroid/os/ITinyRecvCallback$Stub;-><init>()V

    return-void
.end method


# virtual methods
.method public onRecv([BI)V
    .locals 3

    .line 142
    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, p1}, Ljava/lang/String;-><init>([B)V

    .line 143
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onRecv "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "PCMReceiveManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 145
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->-$$Nest$fgetmReadThreadHandler(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;)Landroid/os/Handler;

    move-result-object v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    invoke-virtual {v0, v1, p2, v2, p1}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 146
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    invoke-static {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->-$$Nest$fgetmReadThreadHandler(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;)Landroid/os/Handler;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method
