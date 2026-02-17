.class Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;
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

    .line 192
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 195
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmHandler(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    iget-object v1, v1, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mDismissRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 196
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    new-instance v1, Landroid/content/Intent;

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    const-class v2, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-direct {v1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method
