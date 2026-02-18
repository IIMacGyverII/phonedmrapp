.class Lcom/pri/prizeinterphone/notification/MyNotificationManager$MyNotificationManagerHolder;
.super Ljava/lang/Object;
.source "MyNotificationManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/notification/MyNotificationManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "MyNotificationManagerHolder"
.end annotation


# static fields
.field private static final INSTANCE:Lcom/pri/prizeinterphone/notification/MyNotificationManager;


# direct methods
.method static bridge synthetic -$$Nest$sfgetINSTANCE()Lcom/pri/prizeinterphone/notification/MyNotificationManager;
    .locals 1

    sget-object v0, Lcom/pri/prizeinterphone/notification/MyNotificationManager$MyNotificationManagerHolder;->INSTANCE:Lcom/pri/prizeinterphone/notification/MyNotificationManager;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 40
    new-instance v0, Lcom/pri/prizeinterphone/notification/MyNotificationManager;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;-><init>(Landroid/content/Context;Lcom/pri/prizeinterphone/notification/MyNotificationManager-IA;)V

    sput-object v0, Lcom/pri/prizeinterphone/notification/MyNotificationManager$MyNotificationManagerHolder;->INSTANCE:Lcom/pri/prizeinterphone/notification/MyNotificationManager;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
