.class public Lcom/android/internal/telephony/ModemIndication;
.super Landroid/hardware/radio/modem/IRadioModemIndication$Stub;
.source "ModemIndication.java"


# instance fields
.field private final mRil:Lcom/android/internal/telephony/RIL;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RIL;)V
    .locals 0

    .line 36
    invoke-direct {p0}, Landroid/hardware/radio/modem/IRadioModemIndication$Stub;-><init>()V

    .line 37
    iput-object p1, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    return-void
.end method


# virtual methods
.method public getInterfaceHash()Ljava/lang/String;
    .locals 0

    const-string p0, "9dee2319b599d654955c05268c1eed6ca4373b58"

    return-object p0
.end method

.method public getInterfaceVersion()I
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public hardwareConfigChanged(I[Landroid/hardware/radio/modem/HardwareConfig;)V
    .locals 2

    .line 47
    iget-object v0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 49
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalHardwareConfigList([Landroid/hardware/radio/modem/HardwareConfig;)Ljava/util/ArrayList;

    move-result-object p1

    .line 51
    iget-object p2, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x410

    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 53
    iget-object p0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mHardwareConfigChangeRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public modemReset(ILjava/lang/String;)V
    .locals 2

    .line 65
    iget-object v0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 67
    iget-object p1, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x417

    invoke-virtual {p1, v0, p2}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 69
    iget-object p1, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/RIL;->writeMetricsModemRestartEvent(Ljava/lang/String;)V

    .line 70
    iget-object p0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mModemResetRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p1, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p1, v0, p2, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public radioCapabilityIndication(ILandroid/hardware/radio/modem/RadioCapability;)V
    .locals 2

    .line 81
    iget-object v0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 83
    iget-object p1, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2, p1}, Lcom/android/internal/telephony/RILUtils;->convertHalRadioCapability(Landroid/hardware/radio/modem/RadioCapability;Lcom/android/internal/telephony/RIL;)Lcom/android/internal/telephony/RadioCapability;

    move-result-object p1

    .line 85
    iget-object p2, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x412

    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 87
    iget-object p0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mPhoneRadioCapabilityChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public radioStateChanged(II)V
    .locals 2

    .line 97
    iget-object v0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 99
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalRadioState(I)I

    move-result p1

    .line 101
    iget-object p2, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "radioStateChanged: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/16 v1, 0x3e8

    invoke-virtual {p2, v1, v0}, Lcom/android/internal/telephony/RIL;->unsljLogMore(ILjava/lang/String;)V

    .line 105
    iget-object p0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 p2, 0x0

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/BaseCommands;->setRadioState(IZ)V

    return-void
.end method

.method public rilConnected(I)V
    .locals 2

    .line 113
    iget-object v0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 115
    iget-object p1, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x40a

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RIL;->unsljLog(I)V

    .line 118
    iget-object p1, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x0

    const/4 v1, 0x0

    invoke-interface {p1, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setRadioPower(ZLandroid/os/Message;)V

    .line 119
    iget-object p1, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget v0, p1, Lcom/android/internal/telephony/BaseCommands;->mCdmaSubscription:I

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/RIL;->setCdmaSubscriptionSource(ILandroid/os/Message;)V

    .line 121
    iget-object p0, p0, Lcom/android/internal/telephony/ModemIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 p1, 0xf

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RIL;->notifyRegistrantsRilConnectionChanged(I)V

    return-void
.end method
