.class Lcom/pri/prizeinterphone/activity/DeviceKilledActivity$1;
.super Ljava/lang/Object;
.source "DeviceKilledActivity.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;)V
    .locals 0

    .line 86
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 2

    .line 89
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v0, 0x28

    if-ne p1, v0, :cond_0

    .line 90
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p1

    const/4 v0, 0x0

    const-string v1, "pref_person_is_already_kill"

    invoke-static {p1, v1, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p1

    if-nez p1, :cond_0

    const-string p1, "DeviceKilledActivity"

    const-string v0, "dealEvent is already revive, so finish()"

    .line 92
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 93
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;

    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    :cond_0
    return-void
.end method
