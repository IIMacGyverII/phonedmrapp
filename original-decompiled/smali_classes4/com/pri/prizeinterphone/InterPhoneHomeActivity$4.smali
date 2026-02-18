.class Lcom/pri/prizeinterphone/InterPhoneHomeActivity$4;
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

    .line 177
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$4;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 180
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    const/4 v0, 0x1

    .line 181
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method
