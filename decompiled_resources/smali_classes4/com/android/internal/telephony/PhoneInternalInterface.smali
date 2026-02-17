.class public interface abstract Lcom/android/internal/telephony/PhoneInternalInterface;
.super Ljava/lang/Object;
.source "PhoneInternalInterface.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/PhoneInternalInterface$RadioPowerReason;,
        Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;,
        Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;,
        Lcom/android/internal/telephony/PhoneInternalInterface$DataActivityState;
    }
.end annotation


# static fields
.field public static final BM_10_800M_2:I = 0xf

.field public static final BM_4_450M:I = 0xa

.field public static final BM_7_700M2:I = 0xc

.field public static final BM_8_1800M:I = 0xd

.field public static final BM_9_900M:I = 0xe

.field public static final BM_AUS2_BAND:I = 0x5

.field public static final BM_AUS_BAND:I = 0x4

.field public static final BM_AWS:I = 0x11

.field public static final BM_CELL_800:I = 0x6

.field public static final BM_EURO_BAND:I = 0x1

.field public static final BM_EURO_PAMR:I = 0x10

.field public static final BM_IMT2000:I = 0xb

.field public static final BM_JPN_BAND:I = 0x3

.field public static final BM_JTACS:I = 0x8

.field public static final BM_KOREA_PCS:I = 0x9

.field public static final BM_NUM_BAND_MODES:I = 0x13

.field public static final BM_PCS:I = 0x7

.field public static final BM_UNSPECIFIED:I = 0x0

.field public static final BM_US_2500M:I = 0x12

.field public static final BM_US_BAND:I = 0x2

.field public static final CDMA_OTA_PROVISION_STATUS_A_KEY_EXCHANGED:I = 0x2

.field public static final CDMA_OTA_PROVISION_STATUS_COMMITTED:I = 0x8

.field public static final CDMA_OTA_PROVISION_STATUS_IMSI_DOWNLOADED:I = 0x6

.field public static final CDMA_OTA_PROVISION_STATUS_MDN_DOWNLOADED:I = 0x5

.field public static final CDMA_OTA_PROVISION_STATUS_NAM_DOWNLOADED:I = 0x4

.field public static final CDMA_OTA_PROVISION_STATUS_OTAPA_ABORTED:I = 0xb

.field public static final CDMA_OTA_PROVISION_STATUS_OTAPA_STARTED:I = 0x9

.field public static final CDMA_OTA_PROVISION_STATUS_OTAPA_STOPPED:I = 0xa

.field public static final CDMA_OTA_PROVISION_STATUS_PRL_DOWNLOADED:I = 0x7

.field public static final CDMA_OTA_PROVISION_STATUS_SPC_RETRIES_EXCEEDED:I = 0x1

.field public static final CDMA_OTA_PROVISION_STATUS_SPL_UNLOCKED:I = 0x0

.field public static final CDMA_OTA_PROVISION_STATUS_SSD_UPDATED:I = 0x3

.field public static final CDMA_RM_AFFILIATED:I = 0x1

.field public static final CDMA_RM_ANY:I = 0x2

.field public static final CDMA_RM_HOME:I = 0x0

.field public static final CDMA_SUBSCRIPTION_NV:I = 0x1

.field public static final CDMA_SUBSCRIPTION_RUIM_SIM:I = 0x0

.field public static final CDMA_SUBSCRIPTION_UNKNOWN:I = -0x1

.field public static final DEBUG_PHONE:Z = true

.field public static final FEATURE_ENABLE_CBS:Ljava/lang/String; = "enableCBS"

.field public static final FEATURE_ENABLE_DUN:Ljava/lang/String; = "enableDUN"

.field public static final FEATURE_ENABLE_DUN_ALWAYS:Ljava/lang/String; = "enableDUNAlways"

.field public static final FEATURE_ENABLE_EMERGENCY:Ljava/lang/String; = "enableEmergency"

.field public static final FEATURE_ENABLE_FOTA:Ljava/lang/String; = "enableFOTA"

.field public static final FEATURE_ENABLE_HIPRI:Ljava/lang/String; = "enableHIPRI"

.field public static final FEATURE_ENABLE_IMS:Ljava/lang/String; = "enableIMS"

.field public static final FEATURE_ENABLE_MMS:Ljava/lang/String; = "enableMMS"

.field public static final FEATURE_ENABLE_SUPL:Ljava/lang/String; = "enableSUPL"

.field public static final PREFERRED_CDMA_SUBSCRIPTION:I = 0x0

.field public static final PREFERRED_NT_MODE:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field public static final RADIO_POWER_REASON_THERMAL:I = 0x1

.field public static final RADIO_POWER_REASON_USER:I = 0x0

.field public static final REASON_APN_CHANGED:Ljava/lang/String; = "apnChanged"

.field public static final REASON_APN_FAILED:Ljava/lang/String; = "apnFailed"

.field public static final REASON_APN_SWITCHED:Ljava/lang/String; = "apnSwitched"

.field public static final REASON_CARRIER_ACTION_DISABLE_METERED_APN:Ljava/lang/String; = "carrierActionDisableMeteredApn"

.field public static final REASON_CARRIER_CHANGE:Ljava/lang/String; = "carrierChange"

.field public static final REASON_CDMA_DATA_ATTACHED:Ljava/lang/String; = "cdmaDataAttached"

.field public static final REASON_CDMA_DATA_DETACHED:Ljava/lang/String; = "cdmaDataDetached"

.field public static final REASON_CONNECTED:Ljava/lang/String; = "connected"

.field public static final REASON_CSS_INDICATOR_CHANGED:Ljava/lang/String; = "cssIndicatorChanged"

.field public static final REASON_DATA_ATTACHED:Ljava/lang/String; = "dataAttached"

.field public static final REASON_DATA_DEPENDENCY_MET:Ljava/lang/String; = "dependencyMet"

.field public static final REASON_DATA_DEPENDENCY_UNMET:Ljava/lang/String; = "dependencyUnmet"

.field public static final REASON_DATA_DETACHED:Ljava/lang/String; = "dataDetached"

.field public static final REASON_DATA_DISABLED_INTERNAL:Ljava/lang/String; = "dataDisabledInternal"

.field public static final REASON_DATA_ENABLED:Ljava/lang/String; = "dataEnabled"

.field public static final REASON_DATA_ENABLED_OVERRIDE:Ljava/lang/String; = "dataEnabledOverride"

.field public static final REASON_DATA_SPECIFIC_DISABLED:Ljava/lang/String; = "specificDisabled"

.field public static final REASON_DATA_UNTHROTTLED:Ljava/lang/String; = "dataUnthrottled"

.field public static final REASON_IWLAN_AVAILABLE:Ljava/lang/String; = "iwlanAvailable"

.field public static final REASON_IWLAN_DATA_SERVICE_DIED:Ljava/lang/String; = "iwlanDataServiceDied"

.field public static final REASON_LOST_DATA_CONNECTION:Ljava/lang/String; = "lostDataConnection"

.field public static final REASON_NW_TYPE_CHANGED:Ljava/lang/String; = "nwTypeChanged"

.field public static final REASON_PDP_RESET:Ljava/lang/String; = "pdpReset"

.field public static final REASON_PS_RESTRICT_DISABLED:Ljava/lang/String; = "psRestrictDisabled"

.field public static final REASON_PS_RESTRICT_ENABLED:Ljava/lang/String; = "psRestrictEnabled"

.field public static final REASON_RADIO_TURNED_OFF:Ljava/lang/String; = "radioTurnedOff"

.field public static final REASON_RELEASED_BY_CONNECTIVITY_SERVICE:Ljava/lang/String; = "releasedByConnectivityService"

.field public static final REASON_RESTORE_DEFAULT_APN:Ljava/lang/String; = "restoreDefaultApn"

.field public static final REASON_ROAMING_OFF:Ljava/lang/String; = "roamingOff"

.field public static final REASON_ROAMING_ON:Ljava/lang/String; = "roamingOn"

.field public static final REASON_SIM_LOADED:Ljava/lang/String; = "simLoaded"

.field public static final REASON_SIM_NOT_READY:Ljava/lang/String; = "simNotReady"

.field public static final REASON_SINGLE_PDN_ARBITRATION:Ljava/lang/String; = "SinglePdnArbitration"

.field public static final REASON_TRAFFIC_DESCRIPTORS_UPDATED:Ljava/lang/String; = "trafficDescriptorsUpdated"

.field public static final REASON_VCN_REQUESTED_TEARDOWN:Ljava/lang/String; = "vcnRequestedTeardown"

.field public static final REASON_VOICE_CALL_ENDED:Ljava/lang/String; = "2GVoiceCallEnded"

.field public static final REASON_VOICE_CALL_STARTED:Ljava/lang/String; = "2GVoiceCallStarted"

.field public static final TTY_MODE_FULL:I = 0x1

.field public static final TTY_MODE_HCO:I = 0x2

.field public static final TTY_MODE_OFF:I = 0x0

.field public static final TTY_MODE_VCO:I = 0x3


# direct methods
.method public static synthetic $r8$lambda$4sbZNDYHgI49tL4Z-OF7ymhc9kM(Lcom/android/internal/telephony/Phone;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->lambda$dial$0(Lcom/android/internal/telephony/Phone;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 247
    sget v0, Lcom/android/internal/telephony/RILConstants;->PREFERRED_NETWORK_MODE:I

    sput v0, Lcom/android/internal/telephony/PhoneInternalInterface;->PREFERRED_NT_MODE:I

    return-void
.end method

.method private static synthetic lambda$dial$0(Lcom/android/internal/telephony/Phone;)V
    .locals 0

    return-void
.end method


# virtual methods
.method public abstract acceptCall(I)V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract activateCellBroadcastSms(ILandroid/os/Message;)V
.end method

.method public abstract canConference()Z
.end method

.method public abstract canTransfer()Z
.end method

.method public abstract clearDisconnected()V
.end method

.method public abstract conference()V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public dial(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 519
    new-instance v0, Lcom/android/internal/telephony/PhoneInternalInterface$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneInternalInterface$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {p0, p1, p2, v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->dial(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;Ljava/util/function/Consumer;)Lcom/android/internal/telephony/Connection;

    move-result-object p0

    return-object p0
.end method

.method public abstract dial(Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;Ljava/util/function/Consumer;)Lcom/android/internal/telephony/Connection;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;",
            "Ljava/util/function/Consumer<",
            "Lcom/android/internal/telephony/Phone;",
            ">;)",
            "Lcom/android/internal/telephony/Connection;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract disableLocationUpdates()V
.end method

.method public abstract enableLocationUpdates()V
.end method

.method public abstract explicitCallTransfer()V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract getAvailableNetworks(Landroid/os/Message;)V
.end method

.method public abstract getBackgroundCall()Lcom/android/internal/telephony/Call;
.end method

.method public abstract getCallBarring(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;I)V
.end method

.method public abstract getCallForwardingOption(IILandroid/os/Message;)V
.end method

.method public abstract getCallForwardingOption(ILandroid/os/Message;)V
.end method

.method public abstract getCallWaiting(Landroid/os/Message;)V
.end method

.method public abstract getCarrierInfoForImsiEncryption(IZ)Landroid/telephony/ImsiEncryptionInfo;
.end method

.method public abstract getCellBroadcastSmsConfig(Landroid/os/Message;)V
.end method

.method public abstract getDataActivityState()I
.end method

.method public abstract getDataConnectionState(Ljava/lang/String;)Lcom/android/internal/telephony/PhoneConstants$DataState;
.end method

.method public abstract getDataRoamingEnabled()Z
.end method

.method public abstract getDeviceId()Ljava/lang/String;
.end method

.method public abstract getDeviceSvn()Ljava/lang/String;
.end method

.method public abstract getEsn()Ljava/lang/String;
.end method

.method public abstract getForegroundCall()Lcom/android/internal/telephony/Call;
.end method

.method public abstract getGroupIdLevel1()Ljava/lang/String;
.end method

.method public abstract getGroupIdLevel2()Ljava/lang/String;
.end method

.method public abstract getIccPhoneBookInterfaceManager()Lcom/android/internal/telephony/IccPhoneBookInterfaceManager;
.end method

.method public abstract getImei()Ljava/lang/String;
.end method

.method public abstract getLine1AlphaTag()Ljava/lang/String;
.end method

.method public abstract getLine1Number()Ljava/lang/String;
.end method

.method public abstract getMeid()Ljava/lang/String;
.end method

.method public abstract getMobileProvisioningUrl()Ljava/lang/String;
.end method

.method public abstract getMute()Z
.end method

.method public abstract getOutgoingCallerIdDisplay(Landroid/os/Message;)V
.end method

.method public abstract getPendingMmiCodes()Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "+",
            "Lcom/android/internal/telephony/MmiCode;",
            ">;"
        }
    .end annotation
.end method

.method public abstract getPreciseDataConnectionState(Ljava/lang/String;)Landroid/telephony/PreciseDataConnectionState;
.end method

.method public abstract getRingingCall()Lcom/android/internal/telephony/Call;
.end method

.method public abstract getServiceState()Landroid/telephony/ServiceState;
.end method

.method public abstract getSubscriberId()Ljava/lang/String;
.end method

.method public abstract getVoiceMailAlphaTag()Ljava/lang/String;
.end method

.method public abstract getVoiceMailNumber()Ljava/lang/String;
.end method

.method public abstract handleInCallMmiCommands(Ljava/lang/String;)Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract handlePinMmi(Ljava/lang/String;)Z
.end method

.method public abstract handleUssdRequest(Ljava/lang/String;Landroid/os/ResultReceiver;)Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract isUserDataEnabled()Z
.end method

.method public abstract registerForSuppServiceNotification(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract rejectCall()V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract resetCarrierKeysForImsiEncryption()V
.end method

.method public abstract sendDtmf(C)V
.end method

.method public abstract sendUssdResponse(Ljava/lang/String;)V
.end method

.method public abstract setCallBarring(Ljava/lang/String;ZLjava/lang/String;Landroid/os/Message;I)V
.end method

.method public abstract setCallForwardingOption(IILjava/lang/String;IILandroid/os/Message;)V
.end method

.method public abstract setCallForwardingOption(IILjava/lang/String;ILandroid/os/Message;)V
.end method

.method public abstract setCallWaiting(ZLandroid/os/Message;)V
.end method

.method public abstract setCarrierInfoForImsiEncryption(Landroid/telephony/ImsiEncryptionInfo;)V
.end method

.method public abstract setCellBroadcastSmsConfig([ILandroid/os/Message;)V
.end method

.method public abstract setDataRoamingEnabled(Z)V
.end method

.method public abstract setLine1Number(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)Z
.end method

.method public abstract setMute(Z)V
.end method

.method public abstract setOutgoingCallerIdDisplay(ILandroid/os/Message;)V
.end method

.method public setRadioPower(Z)V
    .locals 1

    const/4 v0, 0x0

    .line 603
    invoke-interface {p0, p1, v0, v0, v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->setRadioPower(ZZZZ)V

    return-void
.end method

.method public setRadioPower(ZZZZ)V
    .locals 6

    const/4 v5, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    .line 640
    invoke-interface/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneInternalInterface;->setRadioPowerForReason(ZZZZI)V

    return-void
.end method

.method public setRadioPowerForReason(ZI)V
    .locals 6

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x0

    move-object v0, p0

    move v1, p1

    move v5, p2

    .line 660
    invoke-interface/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneInternalInterface;->setRadioPowerForReason(ZZZZI)V

    return-void
.end method

.method public setRadioPowerForReason(ZZZZI)V
    .locals 0

    return-void
.end method

.method public setRadioPowerOnForTestEmergencyCall(Z)V
    .locals 0

    return-void
.end method

.method public abstract setVoiceMailNumber(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract startConference([Ljava/lang/String;Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/Connection;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract startDtmf(C)V
.end method

.method public abstract startNetworkScan(Landroid/telephony/NetworkScanRequest;Landroid/os/Message;)V
.end method

.method public abstract stopDtmf()V
.end method

.method public abstract stopNetworkScan(Landroid/os/Message;)V
.end method

.method public abstract switchHoldingAndActive()V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method

.method public abstract unregisterForSuppServiceNotification(Landroid/os/Handler;)V
.end method

.method public updateServiceLocation()V
    .locals 0

    return-void
.end method

.method public updateServiceLocation(Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract updateUsageSetting()Z
.end method
