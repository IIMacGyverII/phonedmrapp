.class public Lcom/pri/prizeinterphone/AppObserver;
.super Ljava/lang/Object;
.source "AppObserver.java"

# interfaces
.implements Landroidx/lifecycle/LifecycleObserver;
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# static fields
.field private static final TAG:Ljava/lang/String; = "InterPhoneAppObs"


# instance fields
.field private isAppFg:Z

.field private mContext:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 22
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/AppObserver;->isAppFg:Z

    .line 25
    iput-object p1, p0, Lcom/pri/prizeinterphone/AppObserver;->mContext:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 2

    .line 93
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-byte p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    const/16 v0, 0x28

    if-ne p1, v0, :cond_0

    .line 94
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p1

    const/4 v0, 0x0

    const-string v1, "pref_person_is_already_kill"

    invoke-static {p1, v1, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p1

    if-eqz p1, :cond_0

    .line 96
    iget-object p1, p0, Lcom/pri/prizeinterphone/AppObserver;->mContext:Landroid/content/Context;

    new-instance v0, Landroid/content/Intent;

    iget-object p0, p0, Lcom/pri/prizeinterphone/AppObserver;->mContext:Landroid/content/Context;

    const-class v1, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/high16 p0, 0x10000000

    invoke-virtual {v0, p0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    :cond_0
    return-void
.end method

.method public isAppFg()Z
    .locals 0

    .line 88
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/AppObserver;->isAppFg:Z

    return p0
.end method

.method public onCreate()V
    .locals 1
    .annotation runtime Landroidx/lifecycle/OnLifecycleEvent;
        value = .enum Landroidx/lifecycle/Lifecycle$Event;->ON_CREATE:Landroidx/lifecycle/Lifecycle$Event;
    .end annotation

    const-string p0, "InterPhoneAppObs"

    const-string v0, ">>>>>>>>>>>>>>>>> onCreate"

    .line 33
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onDestroy()V
    .locals 1
    .annotation runtime Landroidx/lifecycle/OnLifecycleEvent;
        value = .enum Landroidx/lifecycle/Lifecycle$Event;->ON_DESTROY:Landroidx/lifecycle/Lifecycle$Event;
    .end annotation

    const-string p0, "InterPhoneAppObs"

    const-string v0, ">>>>>>>>>>>>>>>>> onStop"

    .line 84
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onPause()V
    .locals 2
    .annotation runtime Landroidx/lifecycle/OnLifecycleEvent;
        value = .enum Landroidx/lifecycle/Lifecycle$Event;->ON_PAUSE:Landroidx/lifecycle/Lifecycle$Event;
    .end annotation

    const-string v0, "InterPhoneAppObs"

    const-string v1, ">>>>>>>>>>>>>>>>> onPause"

    .line 66
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    .line 67
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/AppObserver;->isAppFg:Z

    return-void
.end method

.method public onResume()V
    .locals 3
    .annotation runtime Landroidx/lifecycle/OnLifecycleEvent;
        value = .enum Landroidx/lifecycle/Lifecycle$Event;->ON_RESUME:Landroidx/lifecycle/Lifecycle$Event;
    .end annotation

    const-string v0, "InterPhoneAppObs"

    const-string v1, ">>>>>>>>>>>>>>>>> onResume"

    .line 50
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x1

    .line 51
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/AppObserver;->isAppFg:Z

    .line 52
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x28

    invoke-virtual {v0, v1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 53
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_is_already_kill"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p0

    if-eqz p0, :cond_0

    .line 55
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    new-instance v0, Landroid/content/Intent;

    .line 56
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/high16 v1, 0x10000000

    .line 57
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object v0

    .line 55
    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    :cond_0
    return-void
.end method

.method public onStart()V
    .locals 1
    .annotation runtime Landroidx/lifecycle/OnLifecycleEvent;
        value = .enum Landroidx/lifecycle/Lifecycle$Event;->ON_START:Landroidx/lifecycle/Lifecycle$Event;
    .end annotation

    const-string p0, "InterPhoneAppObs"

    const-string v0, ">>>>>>>>>>>>>>>>> onStart"

    .line 41
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onStop()V
    .locals 2
    .annotation runtime Landroidx/lifecycle/OnLifecycleEvent;
        value = .enum Landroidx/lifecycle/Lifecycle$Event;->ON_STOP:Landroidx/lifecycle/Lifecycle$Event;
    .end annotation

    .line 75
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x28

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    invoke-virtual {v0, v1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    const-string p0, "InterPhoneAppObs"

    const-string v0, ">>>>>>>>>>>>>>>>> onStop"

    .line 76
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
