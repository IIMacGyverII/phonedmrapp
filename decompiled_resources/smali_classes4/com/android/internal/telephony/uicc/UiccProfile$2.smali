.class Lcom/android/internal/telephony/uicc/UiccProfile$2;
.super Landroid/content/BroadcastReceiver;
.source "UiccProfile.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/UiccProfile;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/UiccProfile;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/uicc/UiccProfile;)V
    .locals 0

    .line 182
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccProfile$2;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1

    .line 185
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/UiccProfile$2;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    iget-object p1, p1, Lcom/android/internal/telephony/uicc/UiccProfile;->mLock:Ljava/lang/Object;

    monitor-enter p1

    .line 186
    :try_start_0
    iget-object p2, p0, Lcom/android/internal/telephony/uicc/UiccProfile$2;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    iget-object p2, p2, Lcom/android/internal/telephony/uicc/UiccProfile;->mContext:Landroid/content/Context;

    invoke-virtual {p2, p0}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 187
    iget-object p2, p0, Lcom/android/internal/telephony/uicc/UiccProfile$2;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    const/4 v0, 0x0

    invoke-static {p2, v0}, Lcom/android/internal/telephony/uicc/UiccProfile;->-$$Nest$fputmUserUnlockReceiverRegistered(Lcom/android/internal/telephony/uicc/UiccProfile;Z)V

    .line 188
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccProfile$2;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->-$$Nest$mshowCarrierAppNotificationsIfPossible(Lcom/android/internal/telephony/uicc/UiccProfile;)V

    .line 189
    monitor-exit p1

    return-void

    :catchall_0
    move-exception p0

    monitor-exit p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
