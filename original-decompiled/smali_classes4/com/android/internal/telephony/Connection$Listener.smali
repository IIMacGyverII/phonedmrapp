.class public interface abstract Lcom/android/internal/telephony/Connection$Listener;
.super Ljava/lang/Object;
.source "Connection.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/Connection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "Listener"
.end annotation


# virtual methods
.method public abstract onAudioQualityChanged(I)V
.end method

.method public abstract onCallPullFailed(Lcom/android/internal/telephony/Connection;)V
.end method

.method public abstract onCallRadioTechChanged(I)V
.end method

.method public abstract onCallSubstateChanged(I)V
.end method

.method public abstract onConferenceMergedFailed()V
.end method

.method public abstract onConferenceParticipantsChanged(Ljava/util/List;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/ims/internal/ConferenceParticipant;",
            ">;)V"
        }
    .end annotation
.end method

.method public abstract onConnectionCapabilitiesChanged(I)V
.end method

.method public abstract onConnectionEvent(Ljava/lang/String;Landroid/os/Bundle;)V
.end method

.method public abstract onDisconnect(I)V
.end method

.method public abstract onExitedEcmMode()V
.end method

.method public abstract onExtrasChanged(Landroid/os/Bundle;)V
.end method

.method public abstract onHandoverToWifiFailed()V
.end method

.method public abstract onIsNetworkEmergencyCallChanged(Z)V
.end method

.method public abstract onMediaAttributesChanged()V
.end method

.method public abstract onMultipartyStateChanged(Z)V
.end method

.method public abstract onOriginalConnectionReplaced(Lcom/android/internal/telephony/Connection;)V
.end method

.method public abstract onReceivedDtmfDigit(C)V
.end method

.method public abstract onReceivedRtpHeaderExtensions(Ljava/util/Set;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/RtpHeaderExtension;",
            ">;)V"
        }
    .end annotation
.end method

.method public abstract onRttInitiated()V
.end method

.method public abstract onRttModifyRequestReceived()V
.end method

.method public abstract onRttModifyResponseReceived(I)V
.end method

.method public abstract onRttTerminated()V
.end method

.method public abstract onVideoProviderChanged(Landroid/telecom/Connection$VideoProvider;)V
.end method

.method public abstract onVideoStateChanged(I)V
.end method
