.class public final synthetic Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:I

.field public final synthetic f$1:Ljava/time/Duration;

.field public final synthetic f$2:Landroid/net/KeepalivePacketData;


# direct methods
.method public synthetic constructor <init>(ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;->f$0:I

    iput-object p2, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;->f$1:Ljava/time/Duration;

    iput-object p3, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;->f$2:Landroid/net/KeepalivePacketData;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 2

    iget v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;->f$0:I

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;->f$1:Ljava/time/Duration;

    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;->f$2:Landroid/net/KeepalivePacketData;

    check-cast p1, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;

    invoke-static {v0, v1, p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->$r8$lambda$pwncpDVIggbmXQ2CaqgMvv-ddP4(ILjava/time/Duration;Landroid/net/KeepalivePacketData;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    return-void
.end method
