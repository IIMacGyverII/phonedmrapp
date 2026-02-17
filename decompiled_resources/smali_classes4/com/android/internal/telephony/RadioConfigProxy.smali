.class public Lcom/android/internal/telephony/RadioConfigProxy;
.super Ljava/lang/Object;
.source "RadioConfigProxy.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;,
        Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;
    }
.end annotation


# instance fields
.field private volatile mAidlRadioConfigProxy:Landroid/hardware/radio/config/IRadioConfig;

.field private volatile mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

.field private mIsAidl:Z

.field private final mRadioConfigAidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;

.field private mRadioConfigHalVersion:Lcom/android/internal/telephony/HalVersion;

.field private final mRadioConfigHidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;

.field private final mRadioHalVersion:Lcom/android/internal/telephony/HalVersion;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RadioConfig;Lcom/android/internal/telephony/HalVersion;)V
    .locals 1

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 38
    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    .line 39
    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mAidlRadioConfigProxy:Landroid/hardware/radio/config/IRadioConfig;

    .line 41
    sget-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_UNKNOWN:Lcom/android/internal/telephony/HalVersion;

    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 45
    iput-object p2, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 46
    new-instance p2, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;-><init>(Lcom/android/internal/telephony/RadioConfig;)V

    iput-object p2, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigAidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;

    .line 48
    new-instance p2, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;-><init>(Lcom/android/internal/telephony/RadioConfig;)V

    iput-object p2, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;

    return-void
.end method


# virtual methods
.method public clear()V
    .locals 1

    .line 117
    sget-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_UNKNOWN:Lcom/android/internal/telephony/HalVersion;

    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHalVersion:Lcom/android/internal/telephony/HalVersion;

    const/4 v0, 0x0

    .line 118
    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    .line 119
    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mAidlRadioConfigProxy:Landroid/hardware/radio/config/IRadioConfig;

    .line 120
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->clear()V

    .line 121
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigAidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->clear()V

    return-void
.end method

.method public getAidl()Landroid/hardware/radio/config/IRadioConfig;
    .locals 0

    .line 112
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mAidlRadioConfigProxy:Landroid/hardware/radio/config/IRadioConfig;

    return-object p0
.end method

.method public getFullCapabilitySet()Ljava/util/Set;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 185
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioHalVersion:Lcom/android/internal/telephony/HalVersion;

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/android/internal/telephony/RILUtils;->getCaps(Lcom/android/internal/telephony/HalVersion;Z)Ljava/util/Set;

    move-result-object p0

    return-object p0
.end method

.method public getHalDeviceCapabilities(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 254
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 255
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getAidl()Landroid/hardware/radio/config/IRadioConfig;

    move-result-object p0

    invoke-interface {p0, p1}, Landroid/hardware/radio/config/IRadioConfig;->getHalDeviceCapabilities(I)V

    goto :goto_0

    .line 257
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getHidl13()Landroid/hardware/radio/config/V1_3/IRadioConfig;

    move-result-object p0

    invoke-interface {p0, p1}, Landroid/hardware/radio/config/V1_3/IRadioConfig;->getHalDeviceCapabilities(I)V

    :goto_0
    return-void
.end method

.method public getHidl10()Landroid/hardware/radio/config/V1_0/IRadioConfig;
    .locals 0

    .line 72
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    return-object p0
.end method

.method public getHidl11()Landroid/hardware/radio/config/V1_1/IRadioConfig;
    .locals 0

    .line 80
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    check-cast p0, Landroid/hardware/radio/config/V1_1/IRadioConfig;

    return-object p0
.end method

.method public getHidl13()Landroid/hardware/radio/config/V1_3/IRadioConfig;
    .locals 0

    .line 88
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    check-cast p0, Landroid/hardware/radio/config/V1_3/IRadioConfig;

    return-object p0
.end method

.method public getPhoneCapability(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 214
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 215
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getAidl()Landroid/hardware/radio/config/IRadioConfig;

    move-result-object p0

    invoke-interface {p0, p1}, Landroid/hardware/radio/config/IRadioConfig;->getPhoneCapability(I)V

    goto :goto_0

    .line 217
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getHidl11()Landroid/hardware/radio/config/V1_1/IRadioConfig;

    move-result-object p0

    invoke-interface {p0, p1}, Landroid/hardware/radio/config/V1_1/IRadioConfig;->getPhoneCapability(I)V

    :goto_0
    return-void
.end method

.method public getSimSlotStatus(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 192
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 193
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getAidl()Landroid/hardware/radio/config/IRadioConfig;

    move-result-object p0

    invoke-interface {p0, p1}, Landroid/hardware/radio/config/IRadioConfig;->getSimSlotsStatus(I)V

    goto :goto_0

    .line 195
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getHidl10()Landroid/hardware/radio/config/V1_0/IRadioConfig;

    move-result-object p0

    invoke-interface {p0, p1}, Landroid/hardware/radio/config/V1_0/IRadioConfig;->getSimSlotsStatus(I)V

    :goto_0
    return-void
.end method

.method public getVersion()Lcom/android/internal/telephony/HalVersion;
    .locals 0

    .line 158
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHalVersion:Lcom/android/internal/telephony/HalVersion;

    return-object p0
.end method

.method public isAidl()Z
    .locals 0

    .line 150
    iget-boolean p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mIsAidl:Z

    return p0
.end method

.method public isEmpty()Z
    .locals 1

    .line 141
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mAidlRadioConfigProxy:Landroid/hardware/radio/config/IRadioConfig;

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public linkToDeath(J)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 128
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 129
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigAidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;

    long-to-int p1, p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->linkToDeath(I)V

    goto :goto_0

    .line 131
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->linkToDeath(J)V

    :goto_0
    return-void
.end method

.method public setAidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/config/IRadioConfig;)V
    .locals 0

    .line 100
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 101
    iput-object p2, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mAidlRadioConfigProxy:Landroid/hardware/radio/config/IRadioConfig;

    const/4 p1, 0x1

    .line 102
    iput-boolean p1, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mIsAidl:Z

    .line 103
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigAidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;

    invoke-interface {p2}, Landroid/hardware/radio/config/IRadioConfig;->asBinder()Landroid/os/IBinder;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigAidlServiceDeathRecipient;->setService(Landroid/os/IBinder;)V

    return-void
.end method

.method public setHidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/config/V1_0/IRadioConfig;)V
    .locals 0

    .line 61
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 62
    iput-object p2, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    const/4 p1, 0x0

    .line 63
    iput-boolean p1, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mIsAidl:Z

    .line 64
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioConfigHidlServiceDeathRecipient:Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->setService(Landroid/hardware/radio/config/V1_0/IRadioConfig;)V

    return-void
.end method

.method public setNumOfLiveModems(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 240
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 241
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getAidl()Landroid/hardware/radio/config/IRadioConfig;

    move-result-object p0

    int-to-byte p2, p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/IRadioConfig;->setNumOfLiveModems(IB)V

    goto :goto_0

    .line 243
    :cond_0
    new-instance v0, Landroid/hardware/radio/config/V1_1/ModemsConfig;

    invoke-direct {v0}, Landroid/hardware/radio/config/V1_1/ModemsConfig;-><init>()V

    int-to-byte p2, p2

    .line 245
    iput-byte p2, v0, Landroid/hardware/radio/config/V1_1/ModemsConfig;->numOfLiveModems:B

    .line 246
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getHidl11()Landroid/hardware/radio/config/V1_1/IRadioConfig;

    move-result-object p0

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/config/V1_1/IRadioConfig;->setModemsConfig(ILandroid/hardware/radio/config/V1_1/ModemsConfig;)V

    :goto_0
    return-void
.end method

.method public setPreferredDataModem(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 203
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 204
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getAidl()Landroid/hardware/radio/config/IRadioConfig;

    move-result-object p0

    int-to-byte p2, p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/IRadioConfig;->setPreferredDataModem(IB)V

    goto :goto_0

    .line 206
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getHidl11()Landroid/hardware/radio/config/V1_1/IRadioConfig;

    move-result-object p0

    int-to-byte p2, p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/V1_1/IRadioConfig;->setPreferredDataModem(IB)V

    :goto_0
    return-void
.end method

.method public setResponseFunctions(Lcom/android/internal/telephony/RadioConfig;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 167
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 169
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 170
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mAidlRadioConfigProxy:Landroid/hardware/radio/config/IRadioConfig;

    new-instance v1, Lcom/android/internal/telephony/RadioConfigResponseAidl;

    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioHalVersion:Lcom/android/internal/telephony/HalVersion;

    invoke-direct {v1, p1, p0}, Lcom/android/internal/telephony/RadioConfigResponseAidl;-><init>(Lcom/android/internal/telephony/RadioConfig;Lcom/android/internal/telephony/HalVersion;)V

    new-instance p0, Lcom/android/internal/telephony/RadioConfigIndicationAidl;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/RadioConfigIndicationAidl;-><init>(Lcom/android/internal/telephony/RadioConfig;)V

    invoke-interface {v0, v1, p0}, Landroid/hardware/radio/config/IRadioConfig;->setResponseFunctions(Landroid/hardware/radio/config/IRadioConfigResponse;Landroid/hardware/radio/config/IRadioConfigIndication;)V

    goto :goto_0

    .line 174
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mHidlRadioConfigProxy:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    new-instance v1, Lcom/android/internal/telephony/RadioConfigResponseHidl;

    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy;->mRadioHalVersion:Lcom/android/internal/telephony/HalVersion;

    invoke-direct {v1, p1, p0}, Lcom/android/internal/telephony/RadioConfigResponseHidl;-><init>(Lcom/android/internal/telephony/RadioConfig;Lcom/android/internal/telephony/HalVersion;)V

    new-instance p0, Lcom/android/internal/telephony/RadioConfigIndicationHidl;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/RadioConfigIndicationHidl;-><init>(Lcom/android/internal/telephony/RadioConfig;)V

    invoke-interface {v0, v1, p0}, Landroid/hardware/radio/config/V1_0/IRadioConfig;->setResponseFunctions(Landroid/hardware/radio/config/V1_0/IRadioConfigResponse;Landroid/hardware/radio/config/V1_0/IRadioConfigIndication;)V

    :goto_0
    return-void
.end method

.method public setSimSlotsMapping(ILjava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/List<",
            "Landroid/telephony/UiccSlotMapping;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 227
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 228
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getAidl()Landroid/hardware/radio/config/IRadioConfig;

    move-result-object p0

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertSimSlotsMapping(Ljava/util/List;)[Landroid/hardware/radio/config/SlotPortMapping;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/IRadioConfig;->setSimSlotsMapping(I[Landroid/hardware/radio/config/SlotPortMapping;)V

    goto :goto_0

    .line 230
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getHidl10()Landroid/hardware/radio/config/V1_0/IRadioConfig;

    move-result-object p0

    .line 231
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertSlotMappingToList(Ljava/util/List;)Ljava/util/ArrayList;

    move-result-object p2

    .line 230
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/V1_0/IRadioConfig;->setSimSlotsMapping(ILjava/util/ArrayList;)V

    :goto_0
    return-void
.end method
