.class Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;
.super Ljava/lang/Object;
.source "UpdateFirmwareActivity.java"

# interfaces
.implements Landroid/content/ServiceConnection;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)V
    .locals 0

    .line 84
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onServiceConnected(Landroid/content/ComponentName;Landroid/os/IBinder;)V
    .locals 2

    .line 87
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    new-instance v0, Landroid/os/Messenger;

    invoke-direct {v0, p2}, Landroid/os/Messenger;-><init>(Landroid/os/IBinder;)V

    invoke-static {p1, v0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fputmMessenger(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Landroid/os/Messenger;)V

    .line 88
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    const/4 p2, 0x1

    invoke-static {p1, p2}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fputmIsSvcBind(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Z)V

    .line 89
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmHandler(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/os/Handler;

    move-result-object p1

    const/16 p2, 0x51

    invoke-virtual {p1, p2}, Landroid/os/Handler;->removeMessages(I)V

    .line 90
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fgetmHandler(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/os/Handler;

    move-result-object p0

    const/16 p1, 0x50

    const-wide/16 v0, 0x0

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    const-string p0, "UpdateFirmwareAct"

    const-string p1, "onServiceConnected,connect to bind service "

    .line 91
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onServiceDisconnected(Landroid/content/ComponentName;)V
    .locals 2

    .line 96
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fputmMessenger(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Landroid/os/Messenger;)V

    .line 97
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->-$$Nest$fputmIsSvcBind(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Z)V

    .line 98
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onServiceDisconnected, name = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "UpdateFirmwareAct"

    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
