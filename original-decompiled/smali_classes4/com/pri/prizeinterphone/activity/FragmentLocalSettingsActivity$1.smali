.class Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;
.super Ljava/lang/Object;
.source "FragmentLocalSettingsActivity.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;


# direct methods
.method public static synthetic $r8$lambda$yutuVQvwqJNIxohPgISwJZNbil0(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;->lambda$dealEvent$0(Lcom/pri/prizeinterphone/message/BaseMessage;)V

    return-void
.end method

.method constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)V
    .locals 0

    .line 309
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private synthetic lambda$dealEvent$0(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 2

    .line 314
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "baseMessage.packet.rw="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ",baseMessage.packet.sr="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FragmentLocalSettingsActivity"

    invoke-static {v1, v0}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 315
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v0, p1, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    if-nez v0, :cond_1

    .line 316
    iget-byte p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    if-nez p1, :cond_0

    .line 317
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    const p1, 0x7f11011b

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;I)V

    goto :goto_0

    .line 319
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    const p1, 0x7f11011a

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;I)V

    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 2

    .line 312
    iget-object v0, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte v0, v0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v1, 0x28

    if-ne v0, v1, :cond_0

    .line 313
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;Lcom/pri/prizeinterphone/message/BaseMessage;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_0
    return-void
.end method
