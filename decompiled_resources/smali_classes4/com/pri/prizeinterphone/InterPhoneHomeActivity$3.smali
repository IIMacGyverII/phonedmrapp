.class Lcom/pri/prizeinterphone/InterPhoneHomeActivity$3;
.super Ljava/lang/Object;
.source "InterPhoneHomeActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/InterPhoneHomeActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V
    .locals 0

    .line 166
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$3;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    const-string v0, "InterPhoneHomeAct"

    const-string v1, "mToastInitFail,fail !!!!!!!!!!!!!"

    .line 169
    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 170
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->stopPcmRead()V

    .line 171
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$3;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmHandler(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/os/Handler;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$3;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mDismissRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
