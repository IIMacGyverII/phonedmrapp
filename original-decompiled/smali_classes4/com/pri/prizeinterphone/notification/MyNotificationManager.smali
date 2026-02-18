.class public Lcom/pri/prizeinterphone/notification/MyNotificationManager;
.super Ljava/lang/Object;
.source "MyNotificationManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/notification/MyNotificationManager$MyNotificationManagerHolder;
    }
.end annotation


# static fields
.field public static final NOTIFICATION_CHANNEL_DMR_FG_ID:I = 0x1

.field private static final NOTIFICATION_CHANNEL_DMR_ID:Ljava/lang/String; = "notification_channel_dmr_id"

.field private static final NOTIFICATION_CHANNEL_DMR_NAME:Ljava/lang/String; = "notification_channel_dmr_name"


# instance fields
.field private mChannel:Landroid/app/NotificationChannel;

.field private mContext:Landroid/content/Context;

.field private mNotificationManager:Landroid/app/NotificationManager;

.field private mStartHomeIntent:Landroid/app/PendingIntent;

.field private mStartUpdateFirmwareIntent:Landroid/app/PendingIntent;


# direct methods
.method private constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 22
    iput-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartUpdateFirmwareIntent:Landroid/app/PendingIntent;

    .line 23
    iput-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartHomeIntent:Landroid/app/PendingIntent;

    .line 32
    iput-object p1, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    return-void
.end method

.method synthetic constructor <init>(Landroid/content/Context;Lcom/pri/prizeinterphone/notification/MyNotificationManager-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;-><init>(Landroid/content/Context;)V

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/notification/MyNotificationManager;
    .locals 1

    .line 36
    invoke-static {}, Lcom/pri/prizeinterphone/notification/MyNotificationManager$MyNotificationManagerHolder;->-$$Nest$sfgetINSTANCE()Lcom/pri/prizeinterphone/notification/MyNotificationManager;

    move-result-object v0

    return-object v0
.end method

.method private initChannel()V
    .locals 4

    .line 70
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mChannel:Landroid/app/NotificationChannel;

    if-nez v0, :cond_0

    .line 71
    new-instance v0, Landroid/app/NotificationChannel;

    const/4 v1, 0x2

    const-string v2, "notification_channel_dmr_id"

    const-string v3, "notification_channel_dmr_name"

    invoke-direct {v0, v2, v3, v1}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mChannel:Landroid/app/NotificationChannel;

    .line 73
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mChannel:Landroid/app/NotificationChannel;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/NotificationChannel;->enableLights(Z)V

    .line 74
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mChannel:Landroid/app/NotificationChannel;

    invoke-virtual {v0, v1}, Landroid/app/NotificationChannel;->setShowBadge(Z)V

    .line 75
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mChannel:Landroid/app/NotificationChannel;

    invoke-virtual {v0, v1}, Landroid/app/NotificationChannel;->setLockscreenVisibility(I)V

    .line 76
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mNotificationManager:Landroid/app/NotificationManager;

    iget-object p0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mChannel:Landroid/app/NotificationChannel;

    invoke-virtual {v0, p0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    return-void
.end method

.method private initNotificationManager()V
    .locals 2

    .line 50
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mNotificationManager:Landroid/app/NotificationManager;

    if-nez v0, :cond_0

    .line 51
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    const-string v1, "notification"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    iput-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mNotificationManager:Landroid/app/NotificationManager;

    :cond_0
    return-void
.end method

.method private initPendingIntent()V
    .locals 5

    .line 56
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartUpdateFirmwareIntent:Landroid/app/PendingIntent;

    const/high16 v1, 0x4000000

    const/4 v2, 0x0

    if-nez v0, :cond_0

    .line 57
    new-instance v0, Landroid/content/Intent;

    const-string v3, "prize.intent.action.update.dmr.firmware"

    invoke-direct {v0, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 58
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3, v2, v0, v1}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartUpdateFirmwareIntent:Landroid/app/PendingIntent;

    .line 60
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartHomeIntent:Landroid/app/PendingIntent;

    if-nez v0, :cond_1

    .line 61
    new-instance v0, Landroid/content/Intent;

    const-string v3, "android.intent.action.MAIN"

    invoke-direct {v0, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v3, "android.intent.category.LAUNCHER"

    .line 62
    invoke-virtual {v0, v3}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    const/high16 v3, 0x10000000

    .line 63
    invoke-virtual {v0, v3}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 64
    iget-object v3, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    const-class v4, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 65
    iget-object v3, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    invoke-static {v3, v2, v0, v1}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartHomeIntent:Landroid/app/PendingIntent;

    :cond_1
    return-void
.end method


# virtual methods
.method public getCommonNotificationBuilder(Ljava/lang/String;)Landroidx/core/app/NotificationCompat$Builder;
    .locals 2

    .line 82
    new-instance v0, Landroidx/core/app/NotificationCompat$Builder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    invoke-direct {v0, p0}, Landroidx/core/app/NotificationCompat$Builder;-><init>(Landroid/content/Context;)V

    const-string p0, "notification_channel_dmr_id"

    invoke-virtual {v0, p0}, Landroidx/core/app/NotificationCompat$Builder;->setChannelId(Ljava/lang/String;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p0

    .line 86
    invoke-virtual {p0, p1}, Landroidx/core/app/NotificationCompat$Builder;->setContentText(Ljava/lang/CharSequence;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    .line 87
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-virtual {p1, v0, v1}, Landroidx/core/app/NotificationCompat$Builder;->setWhen(J)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    const v0, 0x7f0800a9

    .line 88
    invoke-virtual {p1, v0}, Landroidx/core/app/NotificationCompat$Builder;->setSmallIcon(I)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    .line 89
    invoke-virtual {p1}, Landroidx/core/app/NotificationCompat$Builder;->build()Landroid/app/Notification;

    return-object p0
.end method

.method public getStartHomeLauncherNotification(Ljava/lang/String;)Landroid/app/Notification;
    .locals 0

    .line 94
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->getCommonNotificationBuilder(Ljava/lang/String;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartHomeIntent:Landroid/app/PendingIntent;

    .line 95
    invoke-virtual {p1, p0}, Landroidx/core/app/NotificationCompat$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p0

    .line 96
    invoke-virtual {p0}, Landroidx/core/app/NotificationCompat$Builder;->build()Landroid/app/Notification;

    move-result-object p0

    return-object p0
.end method

.method public init()V
    .locals 0

    .line 44
    invoke-direct {p0}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->initNotificationManager()V

    .line 45
    invoke-direct {p0}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->initPendingIntent()V

    .line 46
    invoke-direct {p0}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->initChannel()V

    return-void
.end method

.method public notifyUpdate2Notification(II)V
    .locals 5
    .annotation build Landroid/annotation/SuppressLint;
        value = {
            "StringFormatInvalid"
        }
    .end annotation

    const/4 v0, 0x1

    const/4 v1, 0x0

    const/16 v2, 0x20

    if-ne p1, v2, :cond_0

    .line 103
    iget-object p1, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    const p2, 0x7f110122

    invoke-virtual {p1, p2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->getCommonNotificationBuilder(Ljava/lang/String;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartHomeIntent:Landroid/app/PendingIntent;

    .line 104
    invoke-virtual {p1, p2}, Landroidx/core/app/NotificationCompat$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    .line 105
    invoke-virtual {p1, v1}, Landroidx/core/app/NotificationCompat$Builder;->setOngoing(Z)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    goto :goto_0

    :cond_0
    const/16 v2, 0x40

    if-ne p1, v2, :cond_1

    .line 107
    iget-object p1, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    const p2, 0x7f110123

    invoke-virtual {p1, p2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->getCommonNotificationBuilder(Ljava/lang/String;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartUpdateFirmwareIntent:Landroid/app/PendingIntent;

    .line 108
    invoke-virtual {p1, p2}, Landroidx/core/app/NotificationCompat$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    .line 109
    invoke-virtual {p1, v1}, Landroidx/core/app/NotificationCompat$Builder;->setOngoing(Z)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    goto :goto_0

    .line 111
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mContext:Landroid/content/Context;

    const v2, 0x7f110124

    new-array v3, v0, [Ljava/lang/Object;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v3, v1

    invoke-virtual {p1, v2, v3}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->getCommonNotificationBuilder(Ljava/lang/String;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    iget-object v2, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mStartUpdateFirmwareIntent:Landroid/app/PendingIntent;

    .line 112
    invoke-virtual {p1, v2}, Landroidx/core/app/NotificationCompat$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    const/16 v2, 0x64

    .line 113
    invoke-virtual {p1, v2, p2, v1}, Landroidx/core/app/NotificationCompat$Builder;->setProgress(IIZ)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroidx/core/app/NotificationCompat$Builder;->setOngoing(Z)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object p1

    .line 115
    :goto_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->mNotificationManager:Landroid/app/NotificationManager;

    invoke-virtual {p1}, Landroidx/core/app/NotificationCompat$Builder;->build()Landroid/app/Notification;

    move-result-object p1

    invoke-virtual {p0, v0, p1}, Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V

    return-void
.end method
