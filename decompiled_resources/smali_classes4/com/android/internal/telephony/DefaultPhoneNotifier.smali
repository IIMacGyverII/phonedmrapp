.class public Lcom/android/internal/telephony/DefaultPhoneNotifier;
.super Ljava/lang/Object;
.source "DefaultPhoneNotifier.java"

# interfaces
.implements Lcom/android/internal/telephony/PhoneNotifier;


# static fields
.field private static final DBG:Z = false

.field private static final LOG_TAG:Ljava/lang/String; = "DefaultPhoneNotifier"


# instance fields
.field protected mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 55
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string/jumbo v0, "telephony_registry"

    .line 56
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/TelephonyRegistryManager;

    iput-object p1, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    return-void
.end method

.method public static convertPreciseCallState(Lcom/android/internal/telephony/Call$State;)I
    .locals 1

    .line 271
    sget-object v0, Lcom/android/internal/telephony/DefaultPhoneNotifier$1;->$SwitchMap$com$android$internal$telephony$Call$State:[I

    invoke-virtual {p0}, Ljava/lang/Enum;->ordinal()I

    move-result p0

    aget p0, v0, p0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/16 p0, 0x8

    return p0

    :pswitch_1
    const/4 p0, 0x7

    return p0

    :pswitch_2
    const/4 p0, 0x6

    return p0

    :pswitch_3
    const/4 p0, 0x5

    return p0

    :pswitch_4
    const/4 p0, 0x4

    return p0

    :pswitch_5
    const/4 p0, 0x3

    return p0

    :pswitch_6
    const/4 p0, 0x2

    return p0

    :pswitch_7
    const/4 p0, 0x1

    return p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    const-string p0, "DefaultPhoneNotifier"

    .line 294
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public notifyAllowedNetworkTypesChanged(Lcom/android/internal/telephony/Phone;IJ)V
    .locals 6

    .line 255
    iget-object v0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    .line 256
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    move v3, p2

    move-wide v4, p3

    .line 255
    invoke-virtual/range {v0 .. v5}, Landroid/telephony/TelephonyRegistryManager;->notifyAllowedNetworkTypesChanged(IIIJ)V

    return-void
.end method

.method public notifyBarringInfoChanged(Lcom/android/internal/telephony/Phone;Landroid/telephony/BarringInfo;)V
    .locals 1

    .line 235
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyBarringInfoChanged(IILandroid/telephony/BarringInfo;)V

    return-void
.end method

.method public notifyCallForwardingChanged(Lcom/android/internal/telephony/Phone;)V
    .locals 3

    .line 114
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 115
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "notifyCallForwardingChanged: subId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", isCFActive="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 116
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getCallForwardingIndicator()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "DefaultPhoneNotifier"

    .line 115
    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 118
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    .line 119
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getCallForwardingIndicator()Z

    move-result p1

    .line 118
    invoke-virtual {p0, v0, p1}, Landroid/telephony/TelephonyRegistryManager;->notifyCallForwardingChanged(IZ)V

    return-void
.end method

.method public notifyCallQualityChanged(Lcom/android/internal/telephony/Phone;Landroid/telephony/CallQuality;I)V
    .locals 1

    .line 222
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, v0, p1, p2, p3}, Landroid/telephony/TelephonyRegistryManager;->notifyCallQualityChanged(IILandroid/telephony/CallQuality;I)V

    return-void
.end method

.method public notifyCellInfo(Lcom/android/internal/telephony/Phone;Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;)V"
        }
    .end annotation

    .line 142
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 143
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyCellInfoChanged(ILjava/util/List;)V

    return-void
.end method

.method public notifyCellLocation(Lcom/android/internal/telephony/Phone;Landroid/telephony/CellIdentity;)V
    .locals 0

    .line 136
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 137
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyCellLocation(ILandroid/telephony/CellIdentity;)V

    return-void
.end method

.method public notifyDataActivationStateChanged(Lcom/android/internal/telephony/Phone;I)V
    .locals 1

    .line 175
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 176
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 175
    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyDataActivationStateChanged(III)V

    return-void
.end method

.method public notifyDataActivity(Lcom/android/internal/telephony/Phone;)V
    .locals 1

    .line 124
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 125
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getDataActivityState()I

    move-result p1

    invoke-virtual {p0, v0, p1}, Landroid/telephony/TelephonyRegistryManager;->notifyDataActivityChanged(II)V

    return-void
.end method

.method public notifyDataConnection(Lcom/android/internal/telephony/Phone;Landroid/telephony/PreciseDataConnectionState;)V
    .locals 1

    .line 130
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 131
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 130
    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyDataConnectionForSubscriber(IILandroid/telephony/PreciseDataConnectionState;)V

    return-void
.end method

.method public notifyDataEnabled(Lcom/android/internal/telephony/Phone;ZI)V
    .locals 1

    .line 248
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, v0, p1, p2, p3}, Landroid/telephony/TelephonyRegistryManager;->notifyDataEnabled(IIZI)V

    return-void
.end method

.method public notifyDisconnectCause(Lcom/android/internal/telephony/Phone;II)V
    .locals 1

    .line 159
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, v0, p1, p2, p3}, Landroid/telephony/TelephonyRegistryManager;->notifyDisconnectCause(IIII)V

    return-void
.end method

.method public notifyDisplayInfoChanged(Lcom/android/internal/telephony/Phone;Landroid/telephony/TelephonyDisplayInfo;)V
    .locals 1

    .line 193
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyDisplayInfoChanged(IILandroid/telephony/TelephonyDisplayInfo;)V

    return-void
.end method

.method public notifyEmergencyNumberList(Lcom/android/internal/telephony/Phone;)V
    .locals 1

    .line 210
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, v0, p1}, Landroid/telephony/TelephonyRegistryManager;->notifyEmergencyNumberList(II)V

    return-void
.end method

.method public notifyImsDisconnectCause(Lcom/android/internal/telephony/Phone;Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 0

    .line 165
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyImsDisconnectCause(ILandroid/telephony/ims/ImsReasonInfo;)V

    return-void
.end method

.method public notifyLinkCapacityEstimateChanged(Lcom/android/internal/telephony/Phone;Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;)V"
        }
    .end annotation

    .line 262
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 263
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 262
    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyLinkCapacityEstimateChanged(IILjava/util/List;)V

    return-void
.end method

.method public notifyMessageWaitingChanged(Lcom/android/internal/telephony/Phone;)V
    .locals 2

    .line 106
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 107
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    .line 108
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    .line 109
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getMessageWaitingIndicator()Z

    move-result p1

    .line 108
    invoke-virtual {p0, v0, v1, p1}, Landroid/telephony/TelephonyRegistryManager;->notifyMessageWaitingChanged(IIZ)V

    return-void
.end method

.method public notifyOutgoingEmergencySms(Lcom/android/internal/telephony/Phone;Landroid/telephony/emergency/EmergencyNumber;)V
    .locals 1

    .line 215
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    .line 216
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 215
    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyOutgoingEmergencySms(IILandroid/telephony/emergency/EmergencyNumber;)V

    return-void
.end method

.method public notifyPhoneCapabilityChanged(Landroid/telephony/PhoneCapability;)V
    .locals 0

    .line 199
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p0, p1}, Landroid/telephony/TelephonyRegistryManager;->notifyPhoneCapabilityChanged(Landroid/telephony/PhoneCapability;)V

    return-void
.end method

.method public notifyPhoneState(Lcom/android/internal/telephony/Phone;)V
    .locals 4

    .line 62
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object v0

    .line 63
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    .line 64
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    if-eqz v0, :cond_0

    .line 66
    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->getEarliestConnection()Lcom/android/internal/telephony/Connection;

    move-result-object v3

    if-eqz v3, :cond_0

    .line 67
    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->getEarliestConnection()Lcom/android/internal/telephony/Connection;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getAddress()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_0
    const-string v0, ""

    .line 69
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    .line 70
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/PhoneConstantConversions;->convertCallState(Lcom/android/internal/telephony/PhoneConstants$State;)I

    move-result p1

    .line 69
    invoke-virtual {p0, v2, v1, p1, v0}, Landroid/telephony/TelephonyRegistryManager;->notifyCallStateChanged(IIILjava/lang/String;)V

    return-void
.end method

.method public notifyPhysicalChannelConfig(Lcom/android/internal/telephony/Phone;Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;)V"
        }
    .end annotation

    .line 242
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    .line 243
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 242
    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyPhysicalChannelConfigForSubscriber(IILjava/util/List;)V

    return-void
.end method

.method public notifyPreciseCallState(Lcom/android/internal/telephony/Phone;)V
    .locals 9

    .line 147
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getRingingCall()Lcom/android/internal/telephony/Call;

    move-result-object v0

    .line 148
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getForegroundCall()Lcom/android/internal/telephony/Call;

    move-result-object v1

    .line 149
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getBackgroundCall()Lcom/android/internal/telephony/Call;

    move-result-object v2

    if-eqz v0, :cond_0

    if-eqz v1, :cond_0

    if-eqz v2, :cond_0

    .line 151
    iget-object v3, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v4

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v5

    .line 152
    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/DefaultPhoneNotifier;->convertPreciseCallState(Lcom/android/internal/telephony/Call$State;)I

    move-result v6

    .line 153
    invoke-virtual {v1}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/DefaultPhoneNotifier;->convertPreciseCallState(Lcom/android/internal/telephony/Call$State;)I

    move-result v7

    .line 154
    invoke-virtual {v2}, Lcom/android/internal/telephony/Call;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/DefaultPhoneNotifier;->convertPreciseCallState(Lcom/android/internal/telephony/Call$State;)I

    move-result v8

    .line 151
    invoke-virtual/range {v3 .. v8}, Landroid/telephony/TelephonyRegistryManager;->notifyPreciseCallState(IIIII)V

    :cond_0
    return-void
.end method

.method public notifyRadioPowerStateChanged(Lcom/android/internal/telephony/Phone;I)V
    .locals 1

    .line 204
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyRadioPowerStateChanged(III)V

    return-void
.end method

.method public notifyRegistrationFailed(Lcom/android/internal/telephony/Phone;Landroid/telephony/CellIdentity;Ljava/lang/String;III)V
    .locals 8

    .line 229
    iget-object v0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    move-object v3, p2

    move-object v4, p3

    move v5, p4

    move v6, p5

    move v7, p6

    invoke-virtual/range {v0 .. v7}, Landroid/telephony/TelephonyRegistryManager;->notifyRegistrationFailed(IILandroid/telephony/CellIdentity;Ljava/lang/String;III)V

    return-void
.end method

.method public notifyServiceState(Lcom/android/internal/telephony/Phone;)V
    .locals 2

    .line 75
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {p0, p1, v0, v1}, Lcom/android/internal/telephony/DefaultPhoneNotifier;->notifyServiceStateForSubId(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;I)V

    return-void
.end method

.method public notifyServiceStateForSubId(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;I)V
    .locals 3

    .line 80
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 82
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "notifyServiceStateForSubId: mRegistryMgr="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " ss="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " sender="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " phondId="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " subId="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v1, "DefaultPhoneNotifier"

    invoke-static {v1, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-nez p2, :cond_0

    .line 85
    new-instance p2, Landroid/telephony/ServiceState;

    invoke-direct {p2}, Landroid/telephony/ServiceState;-><init>()V

    .line 86
    invoke-virtual {p2}, Landroid/telephony/ServiceState;->setStateOutOfService()V

    .line 88
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p0, v0, p3, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyServiceStateChanged(IILandroid/telephony/ServiceState;)V

    return-void
.end method

.method public notifySignalStrength(Lcom/android/internal/telephony/Phone;)V
    .locals 2

    .line 93
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 94
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    .line 100
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    .line 101
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object p1

    .line 100
    invoke-virtual {p0, v0, v1, p1}, Landroid/telephony/TelephonyRegistryManager;->notifySignalStrengthChanged(IILandroid/telephony/SignalStrength;)V

    return-void
.end method

.method public notifySrvccStateChanged(Lcom/android/internal/telephony/Phone;I)V
    .locals 0

    .line 170
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifySrvccStateChanged(II)V

    return-void
.end method

.method public notifyUserMobileDataStateChanged(Lcom/android/internal/telephony/Phone;Z)V
    .locals 1

    .line 187
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 188
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 187
    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyUserMobileDataStateChanged(IIZ)V

    return-void
.end method

.method public notifyVoiceActivationStateChanged(Lcom/android/internal/telephony/Phone;I)V
    .locals 1

    .line 181
    iget-object p0, p0, Lcom/android/internal/telephony/DefaultPhoneNotifier;->mTelephonyRegistryMgr:Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 182
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    .line 181
    invoke-virtual {p0, v0, p1, p2}, Landroid/telephony/TelephonyRegistryManager;->notifyVoiceActivationStateChanged(III)V

    return-void
.end method
