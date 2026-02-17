.class Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$3;
.super Ljava/lang/Object;
.source "InterPhoneMessageFragment.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->onMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;)V
    .locals 0

    .line 255
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 258
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->-$$Nest$mreFreshUI(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;)V

    return-void
.end method
