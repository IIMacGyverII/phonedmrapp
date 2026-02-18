.class public abstract Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;
.super Lcom/android/internal/telephony/data/DataCallback;
.source "TelephonyNetworkAgent.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/TelephonyNetworkAgent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "TelephonyNetworkAgentCallback"
.end annotation


# direct methods
.method public constructor <init>(Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 86
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onQosCallbackRegistered(ILandroid/net/QosFilter;)V
    .locals 0

    return-void
.end method

.method public onQosCallbackUnregistered(I)V
    .locals 0

    return-void
.end method

.method public onStartSocketKeepalive(ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V
    .locals 0

    return-void
.end method

.method public onStopSocketKeepalive(I)V
    .locals 0

    return-void
.end method

.method public onValidationStatus(ILandroid/net/Uri;)V
    .locals 0

    return-void
.end method
