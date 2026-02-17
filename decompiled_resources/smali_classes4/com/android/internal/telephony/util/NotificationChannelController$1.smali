.class Lcom/android/internal/telephony/util/NotificationChannelController$1;
.super Landroid/content/BroadcastReceiver;
.source "NotificationChannelController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/util/NotificationChannelController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/util/NotificationChannelController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/util/NotificationChannelController;)V
    .locals 0

    .line 178
    iput-object p1, p0, Lcom/android/internal/telephony/util/NotificationChannelController$1;->this$0:Lcom/android/internal/telephony/util/NotificationChannelController;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1

    .line 181
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p0

    const-string v0, "android.intent.action.LOCALE_CHANGED"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 183
    invoke-static {p1}, Lcom/android/internal/telephony/util/NotificationChannelController;->-$$Nest$smcreateAll(Landroid/content/Context;)V

    goto :goto_0

    .line 184
    :cond_0
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p0

    const-string p2, "android.intent.action.SIM_STATE_CHANGED"

    invoke-virtual {p2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    const/4 p0, -0x1

    .line 187
    invoke-static {}, Landroid/telephony/SubscriptionManager;->getDefaultSubscriptionId()I

    move-result p2

    if-eq p0, p2, :cond_1

    .line 188
    invoke-static {p1}, Lcom/android/internal/telephony/util/NotificationChannelController;->-$$Nest$smmigrateVoicemailNotificationSettings(Landroid/content/Context;)V

    :cond_1
    :goto_0
    return-void
.end method
