.class Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;
.super Landroid/os/CountDownTimer;
.source "InterPhoneTalkBackFragment.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->lambda$showLimitRecordTime$2()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

.field final synthetic val$millisecond:I


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;JJI)V
    .locals 0

    .line 774
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    iput p6, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;->val$millisecond:I

    invoke-direct {p0, p2, p3, p4, p5}, Landroid/os/CountDownTimer;-><init>(JJ)V

    return-void
.end method


# virtual methods
.method public onFinish()V
    .locals 2

    .line 783
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p0

    const/16 v1, 0x7dc

    invoke-virtual {p0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public onTick(J)V
    .locals 0

    long-to-int p1, p1

    mul-int/lit8 p1, p1, 0x64

    .line 777
    iget p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;->val$millisecond:I

    div-int/2addr p1, p2

    rsub-int/lit8 p1, p1, 0x64

    .line 778
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetmImgTalkbackProgress(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;->setProgress(I)V

    return-void
.end method
