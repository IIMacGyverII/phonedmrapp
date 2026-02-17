.class public interface abstract Lcom/android/internal/telephony/CommandsInterface;
.super Ljava/lang/Object;
.source "CommandsInterface.java"


# static fields
.field public static final CB_FACILITY_BAIC:Ljava/lang/String; = "AI"

.field public static final CB_FACILITY_BAICr:Ljava/lang/String; = "IR"

.field public static final CB_FACILITY_BAOC:Ljava/lang/String; = "AO"

.field public static final CB_FACILITY_BAOIC:Ljava/lang/String; = "OI"

.field public static final CB_FACILITY_BAOICxH:Ljava/lang/String; = "OX"

.field public static final CB_FACILITY_BA_ALL:Ljava/lang/String; = "AB"

.field public static final CB_FACILITY_BA_FD:Ljava/lang/String; = "FD"

.field public static final CB_FACILITY_BA_MO:Ljava/lang/String; = "AG"

.field public static final CB_FACILITY_BA_MT:Ljava/lang/String; = "AC"

.field public static final CB_FACILITY_BA_SIM:Ljava/lang/String; = "SC"

.field public static final CB_FACILITY_BIC_ACR:Ljava/lang/String; = "AR"

.field public static final CDMA_SMS_FAIL_CAUSE_ENCODING_PROBLEM:I = 0x60

.field public static final CDMA_SMS_FAIL_CAUSE_INVALID_TELESERVICE_ID:I = 0x4

.field public static final CDMA_SMS_FAIL_CAUSE_OTHER_TERMINAL_PROBLEM:I = 0x27

.field public static final CDMA_SMS_FAIL_CAUSE_RESOURCE_SHORTAGE:I = 0x23

.field public static final CF_ACTION_DISABLE:I = 0x0

.field public static final CF_ACTION_ENABLE:I = 0x1

.field public static final CF_ACTION_ERASURE:I = 0x4

.field public static final CF_ACTION_REGISTRATION:I = 0x3

.field public static final CF_REASON_ALL:I = 0x4

.field public static final CF_REASON_ALL_CONDITIONAL:I = 0x5

.field public static final CF_REASON_BUSY:I = 0x1

.field public static final CF_REASON_NOT_REACHABLE:I = 0x3

.field public static final CF_REASON_NO_REPLY:I = 0x2

.field public static final CF_REASON_UNCONDITIONAL:I = 0x0

.field public static final CLIR_DEFAULT:I = 0x0

.field public static final CLIR_INVOCATION:I = 0x1

.field public static final CLIR_SUPPRESSION:I = 0x2

.field public static final GSM_SMS_FAIL_CAUSE_MEMORY_CAPACITY_EXCEEDED:I = 0xd3

.field public static final GSM_SMS_FAIL_CAUSE_UNSPECIFIED_ERROR:I = 0xff

.field public static final GSM_SMS_FAIL_CAUSE_USIM_APP_TOOLKIT_BUSY:I = 0xd4

.field public static final GSM_SMS_FAIL_CAUSE_USIM_DATA_DOWNLOAD_ERROR:I = 0xd5

.field public static final SERVICE_CLASS_DATA:I = 0x2

.field public static final SERVICE_CLASS_DATA_ASYNC:I = 0x20

.field public static final SERVICE_CLASS_DATA_SYNC:I = 0x10

.field public static final SERVICE_CLASS_FAX:I = 0x4

.field public static final SERVICE_CLASS_MAX:I = 0x80

.field public static final SERVICE_CLASS_NONE:I = 0x0

.field public static final SERVICE_CLASS_PACKET:I = 0x40

.field public static final SERVICE_CLASS_PAD:I = 0x80

.field public static final SERVICE_CLASS_SMS:I = 0x8

.field public static final SERVICE_CLASS_VOICE:I = 0x1

.field public static final SS_STATUS_UNKNOWN:I = 0xff

.field public static final USSD_MODE_LOCAL_CLIENT:I = 0x3

.field public static final USSD_MODE_NOTIFY:I = 0x0

.field public static final USSD_MODE_NOT_SUPPORTED:I = 0x4

.field public static final USSD_MODE_NW_RELEASE:I = 0x2

.field public static final USSD_MODE_NW_TIMEOUT:I = 0x5

.field public static final USSD_MODE_REQUEST:I = 0x1


# virtual methods
.method public abstract acceptCall(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract acknowledgeIncomingGsmSmsWithPdu(ZLjava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract acknowledgeLastIncomingCdmaSms(ZILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract acknowledgeLastIncomingGsmSms(ZILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public allocatePduSessionId(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public areUiccApplicationsEnabled(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public canToggleUiccApplicationsEnablement()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public cancelHandover(Landroid/os/Message;I)V
    .locals 0

    return-void
.end method

.method public abstract cancelPendingUssd(Landroid/os/Message;)V
.end method

.method public abstract changeBarringPassword(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract changeIccPin(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract changeIccPin2(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract changeIccPin2ForApp(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract changeIccPinForApp(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract conference(Landroid/os/Message;)V
.end method

.method public abstract deactivateDataCall(IILandroid/os/Message;)V
.end method

.method public abstract deleteSmsOnRuim(ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract deleteSmsOnSim(ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract dial(Ljava/lang/String;ZLandroid/telephony/emergency/EmergencyNumber;ZILandroid/os/Message;)V
.end method

.method public abstract dial(Ljava/lang/String;ZLandroid/telephony/emergency/EmergencyNumber;ZILcom/android/internal/telephony/UUSInfo;Landroid/os/Message;)V
.end method

.method public enableModem(ZLandroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public enableUiccApplications(ZLandroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public abstract exitEmergencyCallbackMode(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract explicitCallTransfer(Landroid/os/Message;)V
.end method

.method public getAllowedCarriers(Landroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract getAllowedNetworkTypesBitmap(Landroid/os/Message;)V
.end method

.method public abstract getAvailableNetworks(Landroid/os/Message;)V
.end method

.method public getBarringInfo(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public abstract getBasebandVersion(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getCDMASubscription(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getCLIR(Landroid/os/Message;)V
.end method

.method public abstract getCdmaBroadcastConfig(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getCdmaSubscriptionSource(Landroid/os/Message;)V
.end method

.method public getCellInfoList(Landroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public getClientRequestStats()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/telephony/ClientRequestStats;",
            ">;"
        }
    .end annotation

    const/4 p0, 0x0

    return-object p0
.end method

.method public abstract getCurrentCalls(Landroid/os/Message;)V
.end method

.method public abstract getDataCallList(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getDataRegistrationState(Landroid/os/Message;)V
.end method

.method public abstract getDeviceIdentity(Landroid/os/Message;)V
.end method

.method public abstract getGsmBroadcastConfig(Landroid/os/Message;)V
.end method

.method public getHalVersion()Lcom/android/internal/telephony/HalVersion;
    .locals 0

    .line 2191
    sget-object p0, Lcom/android/internal/telephony/HalVersion;->UNKNOWN:Lcom/android/internal/telephony/HalVersion;

    return-object p0
.end method

.method public abstract getHardwareConfig(Landroid/os/Message;)V
.end method

.method public abstract getIMEI(Landroid/os/Message;)V
.end method

.method public abstract getIMEISV(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getIMSI(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getIMSIForApp(Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract getIccCardStatus(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getIccSlotsStatus(Landroid/os/Message;)V
.end method

.method public abstract getImsRegistrationState(Landroid/os/Message;)V
.end method

.method public abstract getLastCallFailCause(Landroid/os/Message;)V
.end method

.method public abstract getLastDataCallFailCause(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getLastPdpFailCause(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end method

.method public getModemActivityInfo(Landroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public getModemService()Ljava/lang/String;
    .locals 0

    const-string p0, "default"

    return-object p0
.end method

.method public getModemStatus(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public abstract getMute(Landroid/os/Message;)V
.end method

.method public abstract getNetworkSelectionMode(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getOperator(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getPDPContextList(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end method

.method public abstract getPreferredNetworkType(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getPreferredVoicePrivacy(Landroid/os/Message;)V
.end method

.method public abstract getRadioCapability(Landroid/os/Message;)V
.end method

.method public abstract getRadioState()I
.end method

.method public abstract getRilVersion()I
.end method

.method public abstract getSignalStrength(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getSimPhonebookCapacity(Landroid/os/Message;)V
.end method

.method public abstract getSimPhonebookRecords(Landroid/os/Message;)V
.end method

.method public getSlicingConfig(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public abstract getSmscAddress(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public getSystemSelectionChannels(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public getUsageSetting(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public abstract getVoiceRadioTechnology(Landroid/os/Message;)V
.end method

.method public abstract getVoiceRegistrationState(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract handleCallSetupRequestFromSim(ZLandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract hangupConnection(ILandroid/os/Message;)V
.end method

.method public abstract hangupForegroundResumeBackground(Landroid/os/Message;)V
.end method

.method public abstract hangupWaitingOrBackground(Landroid/os/Message;)V
.end method

.method public abstract iccCloseLogicalChannel(ILandroid/os/Message;)V
.end method

.method public abstract iccIO(IILjava/lang/String;IIILjava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract iccIOForApp(IILjava/lang/String;IIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract iccOpenLogicalChannel(Ljava/lang/String;ILandroid/os/Message;)V
.end method

.method public abstract iccTransmitApduBasicChannel(IIIIILjava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract iccTransmitApduLogicalChannel(IIIIIILjava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract invokeOemRilRequestRaw([BLandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract invokeOemRilRequestStrings([Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public isNrDualConnectivityEnabled(Landroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public isVoNrEnabled(Landroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public nvReadItem(ILandroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract nvResetConfig(ILandroid/os/Message;)V
.end method

.method public abstract nvWriteCdmaPrl([BLandroid/os/Message;)V
.end method

.method public nvWriteItem(ILjava/lang/String;Landroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public onSlotActiveStatusChange(Z)V
    .locals 0

    return-void
.end method

.method public abstract pullLceData(Landroid/os/Message;)V
.end method

.method public abstract queryAvailableBandMode(Landroid/os/Message;)V
.end method

.method public abstract queryCLIP(Landroid/os/Message;)V
.end method

.method public abstract queryCallForwardStatus(IILjava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract queryCallWaiting(ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract queryCdmaRoamingPreference(Landroid/os/Message;)V
.end method

.method public abstract queryFacilityLock(Ljava/lang/String;Ljava/lang/String;ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract queryFacilityLockForApp(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract queryTTYMode(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract registerFoT53ClirlInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForApnUnthrottled(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForAvailable(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public registerForBarringInfoChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    return-void
.end method

.method public abstract registerForCallStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForCallWaitingInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForCarrierInfoForImsiEncryption(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForCdmaOtaProvision(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract registerForCdmaPrlChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForCdmaSubscriptionChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForCellInfoList(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract registerForDataCallListChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForDisplayInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForEmergencyNumberList(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForExitEmergencyCallbackMode(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForHardwareConfigChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForIccRefresh(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract registerForIccSlotStatusChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForIccStatusChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForImsNetworkStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract registerForInCallVoicePrivacyOff(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForInCallVoicePrivacyOn(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForLceInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForLineControlInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForModemReset(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForNattKeepaliveStatus(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForNetworkScanResult(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForNetworkStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForNotAvailable(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract registerForNumberInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForOffOrNotAvailable(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract registerForOn(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract registerForPcoData(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForPhysicalChannelConfiguration(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForRadioCapabilityChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForRadioStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract registerForRedirectedNumberInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForResendIncallMute(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForRilConnected(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract registerForRingbackTone(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForSignalInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForSimPhonebookChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForSimPhonebookRecordsReceived(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForSlicingConfigChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForSrvccStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForSubscriptionStatusChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForT53AudioControlInfo(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract registerForVoiceRadioTechChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public registerUiccApplicationEnablementChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    return-void
.end method

.method public abstract rejectCall(Landroid/os/Message;)V
.end method

.method public releasePduSessionId(Landroid/os/Message;I)V
    .locals 0

    return-void
.end method

.method public abstract reportSmsMemoryStatus(ZLandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract reportStkServiceIsRunning(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract requestIccSimAuthentication(ILjava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract requestShutdown(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract resetRadio(Landroid/os/Message;)V
.end method

.method public abstract sendBurstDtmf(Ljava/lang/String;IILandroid/os/Message;)V
.end method

.method public abstract sendCDMAFeatureCode(Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract sendCdmaSMSExpectMore([BLandroid/os/Message;)V
.end method

.method public abstract sendCdmaSms([BLandroid/os/Message;)V
.end method

.method public abstract sendDeviceState(IZLandroid/os/Message;)V
.end method

.method public abstract sendDtmf(CLandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract sendEnvelope(Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract sendEnvelopeWithStatus(Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract sendImsCdmaSms([BIILandroid/os/Message;)V
.end method

.method public abstract sendImsGsmSms(Ljava/lang/String;Ljava/lang/String;IILandroid/os/Message;)V
.end method

.method public abstract sendSMS(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract sendSMSExpectMore(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract sendTerminalResponse(Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract sendUSSD(Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract separateConnection(ILandroid/os/Message;)V
.end method

.method public setAllowedCarriers(Landroid/telephony/CarrierRestrictionRules;Landroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract setAllowedNetworkTypesBitmap(ILandroid/os/Message;)V
.end method

.method public abstract setBandMode(ILandroid/os/Message;)V
.end method

.method public abstract setCLIR(ILandroid/os/Message;)V
.end method

.method public abstract setCallForward(IIILjava/lang/String;ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setCallWaiting(ZILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setCarrierInfoForImsiEncryption(Landroid/telephony/ImsiEncryptionInfo;Landroid/os/Message;)V
.end method

.method public abstract setCdmaBroadcastActivation(ZLandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setCdmaBroadcastConfig([Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;Landroid/os/Message;)V
.end method

.method public abstract setCdmaRoamingPreference(ILandroid/os/Message;)V
.end method

.method public abstract setCdmaSubscriptionSource(ILandroid/os/Message;)V
.end method

.method public setCellInfoListRate(ILandroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract setDataAllowed(ZLandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract setDataProfile([Landroid/telephony/data/DataProfile;ZLandroid/os/Message;)V
.end method

.method public setDataThrottling(Landroid/os/Message;Landroid/os/WorkSource;IJ)V
    .locals 0

    return-void
.end method

.method public abstract setEmergencyCallbackMode(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setFacilityLock(Ljava/lang/String;ZLjava/lang/String;ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setFacilityLockForApp(Ljava/lang/String;ZLjava/lang/String;ILjava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract setGsmBroadcastActivation(ZLandroid/os/Message;)V
.end method

.method public abstract setGsmBroadcastConfig([Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;Landroid/os/Message;)V
.end method

.method public abstract setInitialAttachApn(Landroid/telephony/data/DataProfile;ZLandroid/os/Message;)V
.end method

.method public abstract setLinkCapacityReportingCriteria(III[I[IILandroid/os/Message;)V
.end method

.method public setLocationUpdates(ZLandroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public setLocationUpdates(ZLandroid/os/WorkSource;Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public abstract setLogicalToPhysicalSlotMapping([ILandroid/os/Message;)V
.end method

.method public setModemService(Ljava/lang/String;)Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public abstract setMute(ZLandroid/os/Message;)V
.end method

.method public abstract setNetworkSelectionModeAutomatic(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setNetworkSelectionModeManual(Ljava/lang/String;ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public setNrDualConnectivityState(ILandroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract setOnCallRing(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnCatCallSetUp(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnCatCcAlphaNotify(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnCatEvent(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnCatProactiveCmd(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnCatSessionEnd(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnIccRefresh(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnIccSmsFull(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnNITZTime(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnNewCdmaSms(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract setOnNewGsmBroadcastSms(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnNewGsmSms(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public setOnRegistrationFailed(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    return-void
.end method

.method public abstract setOnRestrictedStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract setOnSignalStrengthUpdate(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnSmsOnSim(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnSmsStatus(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnSs(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract setOnSuppServiceNotification(Landroid/os/Handler;ILjava/lang/Object;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setOnUSSD(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract setOnUnsolOemHookRaw(Landroid/os/Handler;ILjava/lang/Object;)V
.end method

.method public abstract setPhoneType(I)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setPreferredNetworkType(ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setPreferredVoicePrivacy(ZLandroid/os/Message;)V
.end method

.method public abstract setRadioCapability(Lcom/android/internal/telephony/RadioCapability;Landroid/os/Message;)V
.end method

.method public setRadioPower(ZLandroid/os/Message;)V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    const/4 v0, 0x0

    .line 1292
    invoke-interface {p0, p1, v0, v0, p2}, Lcom/android/internal/telephony/CommandsInterface;->setRadioPower(ZZZLandroid/os/Message;)V

    return-void
.end method

.method public setRadioPower(ZZZLandroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public abstract setSignalStrengthReportingCriteria(Ljava/util/List;Landroid/os/Message;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/SignalThresholdInfo;",
            ">;",
            "Landroid/os/Message;",
            ")V"
        }
    .end annotation
.end method

.method public setSimCardPower(ILandroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract setSmscAddress(Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setSuppServiceNotifications(ZLandroid/os/Message;)V
.end method

.method public setSystemSelectionChannels(Ljava/util/List;Landroid/os/Message;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/RadioAccessSpecifier;",
            ">;",
            "Landroid/os/Message;",
            ")V"
        }
    .end annotation

    return-void
.end method

.method public abstract setTTYMode(ILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setUiccSubscription(IIIILandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract setUnsolResponseFilter(ILandroid/os/Message;)V
.end method

.method public setUsageSetting(Landroid/os/Message;I)V
    .locals 0

    return-void
.end method

.method public setVoNrEnabled(ZLandroid/os/Message;Landroid/os/WorkSource;)V
    .locals 0

    return-void
.end method

.method public abstract setupDataCall(ILandroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;ILandroid/telephony/data/NetworkSliceInfo;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;)V
.end method

.method public abstract startDtmf(CLandroid/os/Message;)V
.end method

.method public startHandover(Landroid/os/Message;I)V
    .locals 0

    return-void
.end method

.method public abstract startLceService(IZLandroid/os/Message;)V
.end method

.method public abstract startNattKeepalive(ILandroid/net/KeepalivePacketData;ILandroid/os/Message;)V
.end method

.method public abstract startNetworkScan(Landroid/telephony/NetworkScanRequest;Landroid/os/Message;)V
.end method

.method public abstract stopDtmf(Landroid/os/Message;)V
.end method

.method public abstract stopLceService(Landroid/os/Message;)V
.end method

.method public abstract stopNattKeepalive(ILandroid/os/Message;)V
.end method

.method public abstract stopNetworkScan(Landroid/os/Message;)V
.end method

.method public abstract supplyIccPin(Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract supplyIccPin2(Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplyIccPin2ForApp(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplyIccPinForApp(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplyIccPuk(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplyIccPuk2(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplyIccPuk2ForApp(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplyIccPukForApp(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplyNetworkDepersonalization(Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public abstract supplySimDepersonalization(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;Ljava/lang/String;Landroid/os/Message;)V
.end method

.method public supportsEid()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public abstract switchWaitingOrHoldingAndActive(Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract testingEmergencyCall()V
.end method

.method public abstract unSetOnCallRing(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnCatCallSetUp(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnCatCcAlphaNotify(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnCatEvent(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnCatProactiveCmd(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnCatSessionEnd(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnIccSmsFull(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnNITZTime(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnNewCdmaSms(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnNewGsmBroadcastSms(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnNewGsmSms(Landroid/os/Handler;)V
.end method

.method public unSetOnRegistrationFailed(Landroid/os/Handler;)V
    .locals 0

    return-void
.end method

.method public abstract unSetOnRestrictedStateChanged(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnSignalStrengthUpdate(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnSmsOnSim(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnSmsStatus(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnSs(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnSuppServiceNotification(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnUSSD(Landroid/os/Handler;)V
.end method

.method public abstract unSetOnUnsolOemHookRaw(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForApnUnthrottled(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForAvailable(Landroid/os/Handler;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public unregisterForBarringInfoChanged(Landroid/os/Handler;)V
    .locals 0

    return-void
.end method

.method public abstract unregisterForCallStateChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForCallWaitingInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForCarrierInfoForImsiEncryption(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForCdmaOtaProvision(Landroid/os/Handler;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract unregisterForCdmaPrlChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForCdmaSubscriptionChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForCellInfoList(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForDataCallListChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForDisplayInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForEmergencyNumberList(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForExitEmergencyCallbackMode(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForHardwareConfigChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForIccRefresh(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForIccSlotStatusChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForIccStatusChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForImsNetworkStateChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForInCallVoicePrivacyOff(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForInCallVoicePrivacyOn(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForLceInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForLineControlInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForModemReset(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForNattKeepaliveStatus(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForNetworkScanResult(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForNetworkStateChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForNotAvailable(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForNumberInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForOffOrNotAvailable(Landroid/os/Handler;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract unregisterForOn(Landroid/os/Handler;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract unregisterForPcoData(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForPhysicalChannelConfiguration(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForRadioCapabilityChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForRadioStateChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForRedirectedNumberInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForResendIncallMute(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForRilConnected(Landroid/os/Handler;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public abstract unregisterForRingbackTone(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForSignalInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForSimPhonebookChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForSimPhonebookRecordsReceived(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForSlicingConfigChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForSrvccStateChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForSubscriptionStatusChanged(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForT53AudioControlInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForT53ClirInfo(Landroid/os/Handler;)V
.end method

.method public abstract unregisterForVoiceRadioTechChanged(Landroid/os/Handler;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end method

.method public unregisterUiccApplicationEnablementChanged(Landroid/os/Handler;)V
    .locals 0

    return-void
.end method

.method public abstract unsetOnIccRefresh(Landroid/os/Handler;)V
.end method

.method public abstract updateSimPhonebookRecord(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;Landroid/os/Message;)V
.end method

.method public abstract writeSmsToRuim(I[BLandroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract writeSmsToSim(ILjava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method
