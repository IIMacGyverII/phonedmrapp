.class Lcom/android/internal/telephony/uicc/UiccProfile$1;
.super Landroid/database/ContentObserver;
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
.method constructor <init>(Lcom/android/internal/telephony/uicc/UiccProfile;Landroid/os/Handler;)V
    .locals 0

    .line 170
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccProfile$1;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    invoke-direct {p0, p2}, Landroid/database/ContentObserver;-><init>(Landroid/os/Handler;)V

    return-void
.end method


# virtual methods
.method public onChange(Z)V
    .locals 2

    .line 173
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/UiccProfile$1;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    iget-object p1, p1, Lcom/android/internal/telephony/uicc/UiccProfile;->mLock:Ljava/lang/Object;

    monitor-enter p1

    .line 174
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccProfile$1;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    iget-object v0, v0, Lcom/android/internal/telephony/uicc/UiccProfile;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/content/ContentResolver;->unregisterContentObserver(Landroid/database/ContentObserver;)V

    .line 175
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccProfile$1;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/android/internal/telephony/uicc/UiccProfile;->-$$Nest$fputmProvisionCompleteContentObserverRegistered(Lcom/android/internal/telephony/uicc/UiccProfile;Z)V

    .line 176
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccProfile$1;->this$0:Lcom/android/internal/telephony/uicc/UiccProfile;

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->-$$Nest$mshowCarrierAppNotificationsIfPossible(Lcom/android/internal/telephony/uicc/UiccProfile;)V

    .line 177
    monitor-exit p1

    return-void

    :catchall_0
    move-exception p0

    monitor-exit p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
