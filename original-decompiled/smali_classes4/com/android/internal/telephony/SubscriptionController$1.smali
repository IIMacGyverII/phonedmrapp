.class Lcom/android/internal/telephony/SubscriptionController$1;
.super Lcom/android/internal/telephony/SubscriptionController$WatchedInt;
.source "SubscriptionController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/SubscriptionController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>(I)V
    .locals 0

    .line 300
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;-><init>(I)V

    return-void
.end method


# virtual methods
.method public set(I)V
    .locals 0

    .line 303
    invoke-super {p0, p1}, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->set(I)V

    .line 304
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->-$$Nest$sminvalidateDefaultSubIdCaches()V

    .line 305
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateSlotIndexCaches()V

    return-void
.end method
