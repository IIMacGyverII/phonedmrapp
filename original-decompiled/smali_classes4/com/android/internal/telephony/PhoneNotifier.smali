.class public interface abstract Lcom/android/internal/telephony/PhoneNotifier;
.super Ljava/lang/Object;
.source "PhoneNotifier.java"


# virtual methods
.method public abstract notifyAllowedNetworkTypesChanged(Lcom/android/internal/telephony/Phone;IJ)V
.end method

.method public abstract notifyBarringInfoChanged(Lcom/android/internal/telephony/Phone;Landroid/telephony/BarringInfo;)V
.end method

.method public abstract notifyCallForwardingChanged(Lcom/android/internal/telephony/Phone;)V
.end method

.method public abstract notifyCallQualityChanged(Lcom/android/internal/telephony/Phone;Landroid/telephony/CallQuality;I)V
.end method

.method public abstract notifyCellInfo(Lcom/android/internal/telephony/Phone;Ljava/util/List;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;)V"
        }
    .end annotation
.end method

.method public abstract notifyCellLocation(Lcom/android/internal/telephony/Phone;Landroid/telephony/CellIdentity;)V
.end method

.method public abstract notifyDataActivationStateChanged(Lcom/android/internal/telephony/Phone;I)V
.end method

.method public abstract notifyDataActivity(Lcom/android/internal/telephony/Phone;)V
.end method

.method public abstract notifyDataConnection(Lcom/android/internal/telephony/Phone;Landroid/telephony/PreciseDataConnectionState;)V
.end method

.method public abstract notifyDataEnabled(Lcom/android/internal/telephony/Phone;ZI)V
.end method

.method public abstract notifyDisconnectCause(Lcom/android/internal/telephony/Phone;II)V
.end method

.method public abstract notifyDisplayInfoChanged(Lcom/android/internal/telephony/Phone;Landroid/telephony/TelephonyDisplayInfo;)V
.end method

.method public abstract notifyEmergencyNumberList(Lcom/android/internal/telephony/Phone;)V
.end method

.method public abstract notifyImsDisconnectCause(Lcom/android/internal/telephony/Phone;Landroid/telephony/ims/ImsReasonInfo;)V
.end method

.method public abstract notifyLinkCapacityEstimateChanged(Lcom/android/internal/telephony/Phone;Ljava/util/List;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;)V"
        }
    .end annotation
.end method

.method public abstract notifyMessageWaitingChanged(Lcom/android/internal/telephony/Phone;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract notifyOutgoingEmergencySms(Lcom/android/internal/telephony/Phone;Landroid/telephony/emergency/EmergencyNumber;)V
.end method

.method public abstract notifyPhoneCapabilityChanged(Landroid/telephony/PhoneCapability;)V
.end method

.method public abstract notifyPhoneState(Lcom/android/internal/telephony/Phone;)V
.end method

.method public abstract notifyPhysicalChannelConfig(Lcom/android/internal/telephony/Phone;Ljava/util/List;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;)V"
        }
    .end annotation
.end method

.method public abstract notifyPreciseCallState(Lcom/android/internal/telephony/Phone;)V
.end method

.method public abstract notifyRadioPowerStateChanged(Lcom/android/internal/telephony/Phone;I)V
.end method

.method public abstract notifyRegistrationFailed(Lcom/android/internal/telephony/Phone;Landroid/telephony/CellIdentity;Ljava/lang/String;III)V
.end method

.method public abstract notifyServiceState(Lcom/android/internal/telephony/Phone;)V
.end method

.method public abstract notifyServiceStateForSubId(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;I)V
.end method

.method public abstract notifySignalStrength(Lcom/android/internal/telephony/Phone;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract notifySrvccStateChanged(Lcom/android/internal/telephony/Phone;I)V
.end method

.method public abstract notifyUserMobileDataStateChanged(Lcom/android/internal/telephony/Phone;Z)V
.end method

.method public abstract notifyVoiceActivationStateChanged(Lcom/android/internal/telephony/Phone;I)V
.end method
