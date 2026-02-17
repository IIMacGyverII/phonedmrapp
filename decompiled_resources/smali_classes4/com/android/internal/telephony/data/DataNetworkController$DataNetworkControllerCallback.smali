.class public Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;
.super Lcom/android/internal/telephony/data/DataCallback;
.source "DataNetworkController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetworkController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DataNetworkControllerCallback"
.end annotation


# direct methods
.method public constructor <init>(Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 540
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onAnyDataNetworkExistingChanged(Z)V
    .locals 0

    return-void
.end method

.method public onDataServiceBound(I)V
    .locals 0

    return-void
.end method

.method public onInternetDataNetworkConnected(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataProfile;",
            ">;)V"
        }
    .end annotation

    return-void
.end method

.method public onInternetDataNetworkDisconnected()V
    .locals 0

    return-void
.end method

.method public onInternetDataNetworkValidationStatusChanged(I)V
    .locals 0

    return-void
.end method

.method public onNrAdvancedCapableByPcoChanged(Z)V
    .locals 0

    return-void
.end method

.method public onPhysicalLinkStatusChanged(I)V
    .locals 0

    return-void
.end method

.method public onSubscriptionPlanOverride()V
    .locals 0

    return-void
.end method
