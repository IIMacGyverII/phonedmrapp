.class public Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "DeviceKilledActivity.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "DeviceKilledActivity"


# instance fields
.field mMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 20
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 86
    new-instance v0, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;->mMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    return-void
.end method

.method private setWindowLayoutParams()V
    .locals 3

    .line 75
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 76
    iget v0, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 77
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p0

    .line 78
    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    const/16 v2, 0x50

    .line 79
    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v2, 0x3c

    .line 80
    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float v0, v0

    const v2, 0x3f666666    # 0.9f

    mul-float/2addr v0, v2

    float-to-int v0, v0

    .line 81
    iput v0, v1, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 82
    invoke-virtual {p0, v1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const v0, 0x106000d

    .line 83
    invoke-virtual {p0, v0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method


# virtual methods
.method public onBackPressed()V
    .locals 3

    .line 54
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "pref_person_is_already_kill"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const-string v1, "DeviceKilledActivity"

    if-eqz v0, :cond_0

    const-string p0, "onBackPressed is not already revive, return "

    .line 56
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_0
    const-string v0, "onBackPressed is already revive, so finish()"

    .line 59
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 60
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3
    .param p1    # Landroid/os/Bundle;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 25
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const/4 p1, 0x1

    .line 26
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->supportRequestWindowFeature(I)Z

    const p1, 0x7f0c0033

    .line 27
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 28
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->isAppFg()Z

    move-result p1

    const-string v0, "DeviceKilledActivity"

    if-nez p1, :cond_0

    const-string p1, "onCreate is not foreground, so finish()"

    .line 29
    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 30
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 32
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p1

    const-string v1, "pref_person_is_already_kill"

    const/4 v2, 0x0

    invoke-static {p1, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p1

    if-nez p1, :cond_1

    const-string p1, "onCreate is already revive, so finish()"

    .line 34
    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 35
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 37
    :cond_1
    invoke-virtual {p0, v2}, Landroid/app/Activity;->setFinishOnTouchOutside(Z)V

    .line 38
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;->setWindowLayoutParams()V

    return-void
.end method

.method protected onPause()V
    .locals 2

    .line 66
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onPause()V

    .line 67
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x28

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;->mMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    return-void
.end method

.method protected onResume()V
    .locals 3

    .line 43
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    .line 44
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/DeviceKilledActivity;->mMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    const/16 v2, 0x28

    invoke-virtual {v0, v2, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 45
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "pref_person_is_already_kill"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "DeviceKilledActivity"

    const-string v1, "onResume is already revive, so finish()"

    .line 47
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 48
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    :cond_0
    return-void
.end method
