.class public abstract Lcom/android/internal/telephony/Connection$ListenerBase;
.super Ljava/lang/Object;
.source "Connection.java"

# interfaces
.implements Lcom/android/internal/telephony/Connection$Listener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/Connection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "ListenerBase"
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 147
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onAudioQualityChanged(I)V
    .locals 0

    return-void
.end method

.method public onCallPullFailed(Lcom/android/internal/telephony/Connection;)V
    .locals 0

    return-void
.end method

.method public onCallRadioTechChanged(I)V
    .locals 0

    return-void
.end method

.method public onCallSubstateChanged(I)V
    .locals 0

    return-void
.end method

.method public onConferenceMergedFailed()V
    .locals 0

    return-void
.end method

.method public onConferenceParticipantsChanged(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/ims/internal/ConferenceParticipant;",
            ">;)V"
        }
    .end annotation

    return-void
.end method

.method public onConnectionCapabilitiesChanged(I)V
    .locals 0

    return-void
.end method

.method public onConnectionEvent(Ljava/lang/String;Landroid/os/Bundle;)V
    .locals 0

    return-void
.end method

.method public onDisconnect(I)V
    .locals 0

    return-void
.end method

.method public onExitedEcmMode()V
    .locals 0

    return-void
.end method

.method public onExtrasChanged(Landroid/os/Bundle;)V
    .locals 0

    return-void
.end method

.method public onHandoverToWifiFailed()V
    .locals 0

    return-void
.end method

.method public onIsNetworkEmergencyCallChanged(Z)V
    .locals 0

    return-void
.end method

.method public onMediaAttributesChanged()V
    .locals 0

    return-void
.end method

.method public onMultipartyStateChanged(Z)V
    .locals 0

    return-void
.end method

.method public onOriginalConnectionReplaced(Lcom/android/internal/telephony/Connection;)V
    .locals 0

    return-void
.end method

.method public onReceivedDtmfDigit(C)V
    .locals 0

    return-void
.end method

.method public onReceivedRtpHeaderExtensions(Ljava/util/Set;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/RtpHeaderExtension;",
            ">;)V"
        }
    .end annotation

    return-void
.end method

.method public onRttInitiated()V
    .locals 0

    return-void
.end method

.method public onRttModifyRequestReceived()V
    .locals 0

    return-void
.end method

.method public onRttModifyResponseReceived(I)V
    .locals 0

    return-void
.end method

.method public onRttTerminated()V
    .locals 0

    return-void
.end method

.method public onVideoProviderChanged(Landroid/telecom/Connection$VideoProvider;)V
    .locals 0

    return-void
.end method

.method public onVideoStateChanged(I)V
    .locals 0

    return-void
.end method
