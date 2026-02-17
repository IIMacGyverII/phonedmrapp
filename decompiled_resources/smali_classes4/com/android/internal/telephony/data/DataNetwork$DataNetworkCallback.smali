.class public abstract Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;
.super Lcom/android/internal/telephony/data/DataCallback;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataNetwork;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "DataNetworkCallback"
.end annotation


# direct methods
.method public constructor <init>(Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 696
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public abstract onAttachFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
.end method

.method public abstract onConnected(Lcom/android/internal/telephony/data/DataNetwork;)V
.end method

.method public abstract onDisconnected(Lcom/android/internal/telephony/data/DataNetwork;I)V
.end method

.method public abstract onHandoverFailed(Lcom/android/internal/telephony/data/DataNetwork;IJI)V
.end method

.method public abstract onHandoverSucceeded(Lcom/android/internal/telephony/data/DataNetwork;)V
.end method

.method public abstract onLinkStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;I)V
.end method

.method public abstract onNetworkCapabilitiesChanged(Lcom/android/internal/telephony/data/DataNetwork;)V
.end method

.method public abstract onPcoDataChanged(Lcom/android/internal/telephony/data/DataNetwork;)V
.end method

.method public abstract onSetupDataFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
.end method

.method public abstract onSuspendedStateChanged(Lcom/android/internal/telephony/data/DataNetwork;Z)V
.end method

.method public abstract onTrackNetworkUnwanted(Lcom/android/internal/telephony/data/DataNetwork;)V
.end method

.method public abstract onValidationStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;ILandroid/net/Uri;)V
.end method
