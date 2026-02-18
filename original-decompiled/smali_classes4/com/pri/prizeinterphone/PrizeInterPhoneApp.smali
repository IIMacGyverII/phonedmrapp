.class public Lcom/pri/prizeinterphone/PrizeInterPhoneApp;
.super Landroid/app/Application;
.source "PrizeInterPhoneApp.java"


# static fields
.field private static mAppObserver:Lcom/pri/prizeinterphone/AppObserver;

.field private static mContext:Landroid/content/Context;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Landroid/app/Application;-><init>()V

    return-void
.end method

.method public static getContext()Landroid/content/Context;
    .locals 1

    .line 29
    sget-object v0, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->mContext:Landroid/content/Context;

    return-object v0
.end method

.method public static isAppFg()Z
    .locals 1

    .line 41
    sget-object v0, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->mAppObserver:Lcom/pri/prizeinterphone/AppObserver;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/AppObserver;->isAppFg()Z

    move-result v0

    return v0
.end method

.method private startInterPhoneService()V
    .locals 3

    .line 33
    new-instance v0, Landroid/content/Intent;

    sget-object v1, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->mContext:Landroid/content/Context;

    const-class v2, Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroid/app/Application;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    return-void
.end method


# virtual methods
.method public onCreate()V
    .locals 2

    .line 18
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    .line 19
    invoke-virtual {p0}, Landroid/app/Application;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->mContext:Landroid/content/Context;

    .line 20
    new-instance v1, Lcom/pri/prizeinterphone/AppObserver;

    invoke-direct {v1, v0}, Lcom/pri/prizeinterphone/AppObserver;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->mAppObserver:Lcom/pri/prizeinterphone/AppObserver;

    .line 21
    invoke-static {}, Landroidx/lifecycle/ProcessLifecycleOwner;->get()Landroidx/lifecycle/LifecycleOwner;

    move-result-object v0

    invoke-interface {v0}, Landroidx/lifecycle/LifecycleOwner;->getLifecycle()Landroidx/lifecycle/Lifecycle;

    move-result-object v0

    sget-object v1, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->mAppObserver:Lcom/pri/prizeinterphone/AppObserver;

    invoke-virtual {v0, v1}, Landroidx/lifecycle/Lifecycle;->addObserver(Landroidx/lifecycle/LifecycleObserver;)V

    .line 22
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->init()Z

    .line 23
    invoke-static {}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->getInstance()Lcom/pri/prizeinterphone/notification/MyNotificationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->init()V

    .line 24
    invoke-direct {p0}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->startInterPhoneService()V

    return-void
.end method
