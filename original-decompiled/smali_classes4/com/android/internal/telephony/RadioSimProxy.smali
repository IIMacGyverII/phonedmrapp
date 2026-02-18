.class public Lcom/android/internal/telephony/RadioSimProxy;
.super Lcom/android/internal/telephony/RadioServiceProxy;
.source "RadioSimProxy.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RadioSimProxy"


# instance fields
.field private volatile mSimProxy:Landroid/hardware/radio/sim/IRadioSim;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 36
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioServiceProxy;-><init>()V

    const/4 v0, 0x0

    .line 38
    iput-object v0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    return-void
.end method


# virtual methods
.method public areUiccApplicationsEnabled(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 84
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 85
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 86
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->areUiccApplicationsEnabled(I)V

    goto :goto_0

    .line 88
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_5/IRadio;->areUiccApplicationsEnabled(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public changeIccPin2ForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 102
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 103
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 104
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/sim/IRadioSim;->changeIccPin2ForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 106
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_0/IRadio;->changeIccPin2ForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public changeIccPinForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 120
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 121
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 122
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/sim/IRadioSim;->changeIccPinForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 124
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_0/IRadio;->changeIccPinForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public clear()V
    .locals 1

    .line 65
    invoke-super {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->clear()V

    const/4 v0, 0x0

    .line 66
    iput-object v0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    return-void
.end method

.method public enableUiccApplications(IZ)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 135
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 136
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 137
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->enableUiccApplications(IZ)V

    goto :goto_0

    .line 139
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_5/IRadio;->enableUiccApplications(IZ)V

    :cond_2
    :goto_0
    return-void
.end method

.method public getAidl()Landroid/hardware/radio/sim/IRadioSim;
    .locals 0

    .line 57
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    return-object p0
.end method

.method public getAllowedCarriers(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 150
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 151
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 152
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->getAllowedCarriers(I)V

    goto :goto_0

    .line 153
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 154
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_4/IRadio;->getAllowedCarriers_1_4(I)V

    goto :goto_0

    .line 156
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getAllowedCarriers(I)V

    :goto_0
    return-void
.end method

.method public getCdmaSubscription(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 166
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 167
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 168
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->getCdmaSubscription(I)V

    goto :goto_0

    .line 170
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getCDMASubscription(I)V

    :goto_0
    return-void
.end method

.method public getCdmaSubscriptionSource(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 180
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 181
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 182
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->getCdmaSubscriptionSource(I)V

    goto :goto_0

    .line 184
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getCdmaSubscriptionSource(I)V

    :goto_0
    return-void
.end method

.method public getFacilityLockForApp(ILjava/lang/String;Ljava/lang/String;ILjava/lang/String;)V
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 199
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 200
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 201
    iget-object v1, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    move v2, p1

    move-object v3, p2

    move-object v4, p3

    move v5, p4

    move-object v6, p5

    invoke-interface/range {v1 .. v6}, Landroid/hardware/radio/sim/IRadioSim;->getFacilityLockForApp(ILjava/lang/String;Ljava/lang/String;ILjava/lang/String;)V

    goto :goto_0

    .line 203
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move v3, p1

    move-object v4, p2

    move-object v5, p3

    move v6, p4

    move-object v7, p5

    invoke-interface/range {v2 .. v7}, Landroid/hardware/radio/V1_0/IRadio;->getFacilityLockForApp(ILjava/lang/String;Ljava/lang/String;ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public getIccCardStatus(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 213
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 214
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 215
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->getIccCardStatus(I)V

    goto :goto_0

    .line 217
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getIccCardStatus(I)V

    :goto_0
    return-void
.end method

.method public getImsiForApp(ILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 228
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 229
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 230
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->getImsiForApp(ILjava/lang/String;)V

    goto :goto_0

    .line 232
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->getImsiForApp(ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public getSimPhonebookCapacity(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 242
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 243
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 244
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->getSimPhonebookCapacity(I)V

    goto :goto_0

    .line 246
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getSimPhonebookCapacity(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public getSimPhonebookRecords(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 256
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 257
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 258
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->getSimPhonebookRecords(I)V

    goto :goto_0

    .line 260
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getSimPhonebookRecords(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public iccCloseLogicalChannel(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 271
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 272
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 273
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->iccCloseLogicalChannel(II)V

    goto :goto_0

    .line 275
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->iccCloseLogicalChannel(II)V

    :goto_0
    return-void
.end method

.method public iccIoForApp(IIILjava/lang/String;IIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 295
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 296
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 297
    new-instance v0, Landroid/hardware/radio/sim/IccIo;

    invoke-direct {v0}, Landroid/hardware/radio/sim/IccIo;-><init>()V

    .line 298
    iput p2, v0, Landroid/hardware/radio/sim/IccIo;->command:I

    .line 299
    iput p3, v0, Landroid/hardware/radio/sim/IccIo;->fileId:I

    .line 300
    iput-object p4, v0, Landroid/hardware/radio/sim/IccIo;->path:Ljava/lang/String;

    .line 301
    iput p5, v0, Landroid/hardware/radio/sim/IccIo;->p1:I

    .line 302
    iput p6, v0, Landroid/hardware/radio/sim/IccIo;->p2:I

    .line 303
    iput p7, v0, Landroid/hardware/radio/sim/IccIo;->p3:I

    .line 304
    iput-object p8, v0, Landroid/hardware/radio/sim/IccIo;->data:Ljava/lang/String;

    .line 305
    iput-object p9, v0, Landroid/hardware/radio/sim/IccIo;->pin2:Ljava/lang/String;

    .line 306
    iput-object p10, v0, Landroid/hardware/radio/sim/IccIo;->aid:Ljava/lang/String;

    .line 307
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/sim/IRadioSim;->iccIoForApp(ILandroid/hardware/radio/sim/IccIo;)V

    goto :goto_0

    .line 309
    :cond_1
    new-instance v0, Landroid/hardware/radio/V1_0/IccIo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/IccIo;-><init>()V

    .line 310
    iput p2, v0, Landroid/hardware/radio/V1_0/IccIo;->command:I

    .line 311
    iput p3, v0, Landroid/hardware/radio/V1_0/IccIo;->fileId:I

    .line 312
    iput-object p4, v0, Landroid/hardware/radio/V1_0/IccIo;->path:Ljava/lang/String;

    .line 313
    iput p5, v0, Landroid/hardware/radio/V1_0/IccIo;->p1:I

    .line 314
    iput p6, v0, Landroid/hardware/radio/V1_0/IccIo;->p2:I

    .line 315
    iput p7, v0, Landroid/hardware/radio/V1_0/IccIo;->p3:I

    .line 316
    iput-object p8, v0, Landroid/hardware/radio/V1_0/IccIo;->data:Ljava/lang/String;

    .line 317
    iput-object p9, v0, Landroid/hardware/radio/V1_0/IccIo;->pin2:Ljava/lang/String;

    .line 318
    iput-object p10, v0, Landroid/hardware/radio/V1_0/IccIo;->aid:Ljava/lang/String;

    .line 319
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->iccIOForApp(ILandroid/hardware/radio/V1_0/IccIo;)V

    :goto_0
    return-void
.end method

.method public iccOpenLogicalChannel(ILjava/lang/String;I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 331
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 332
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 333
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/sim/IRadioSim;->iccOpenLogicalChannel(ILjava/lang/String;I)V

    goto :goto_0

    .line 335
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->iccOpenLogicalChannel(ILjava/lang/String;I)V

    :goto_0
    return-void
.end method

.method public iccTransmitApduBasicChannel(IIIIIILjava/lang/String;)V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 352
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 353
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 354
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    const/4 v0, 0x0

    move v1, p2

    move v2, p3

    move v3, p4

    move v4, p5

    move v5, p6

    move-object v6, p7

    .line 355
    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/RILUtils;->convertToHalSimApduAidl(IIIIIILjava/lang/String;)Landroid/hardware/radio/sim/SimApdu;

    move-result-object p2

    .line 354
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->iccTransmitApduBasicChannel(ILandroid/hardware/radio/sim/SimApdu;)V

    goto :goto_0

    .line 357
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    const/4 v0, 0x0

    move v1, p2

    move v2, p3

    move v3, p4

    move v4, p5

    move v5, p6

    move-object v6, p7

    .line 358
    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/RILUtils;->convertToHalSimApdu(IIIIIILjava/lang/String;)Landroid/hardware/radio/V1_0/SimApdu;

    move-result-object p2

    .line 357
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->iccTransmitApduBasicChannel(ILandroid/hardware/radio/V1_0/SimApdu;)V

    :goto_0
    return-void
.end method

.method public iccTransmitApduLogicalChannel(IIIIIIILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 376
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 377
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 378
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    .line 379
    invoke-static/range {p2 .. p8}, Lcom/android/internal/telephony/RILUtils;->convertToHalSimApduAidl(IIIIIILjava/lang/String;)Landroid/hardware/radio/sim/SimApdu;

    move-result-object p2

    .line 378
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->iccTransmitApduLogicalChannel(ILandroid/hardware/radio/sim/SimApdu;)V

    goto :goto_0

    .line 381
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    .line 382
    invoke-static/range {p2 .. p8}, Lcom/android/internal/telephony/RILUtils;->convertToHalSimApdu(IIIIIILjava/lang/String;)Landroid/hardware/radio/V1_0/SimApdu;

    move-result-object p2

    .line 381
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->iccTransmitApduLogicalChannel(ILandroid/hardware/radio/V1_0/SimApdu;)V

    :goto_0
    return-void
.end method

.method public isEmpty()Z
    .locals 1

    .line 75
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public reportStkServiceIsRunning(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 392
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 393
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 394
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1}, Landroid/hardware/radio/sim/IRadioSim;->reportStkServiceIsRunning(I)V

    goto :goto_0

    .line 396
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->reportStkServiceIsRunning(I)V

    :goto_0
    return-void
.end method

.method public requestIccSimAuthentication(IILjava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 410
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 411
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 412
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/sim/IRadioSim;->requestIccSimAuthentication(IILjava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 414
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_0/IRadio;->requestIccSimAuthentication(IILjava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public responseAcknowledgement()V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 424
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 425
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 426
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0}, Landroid/hardware/radio/sim/IRadioSim;->responseAcknowledgement()V

    goto :goto_0

    .line 428
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0}, Landroid/hardware/radio/V1_0/IRadio;->responseAcknowledgement()V

    :goto_0
    return-void
.end method

.method public sendEnvelope(ILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 440
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 441
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 442
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->sendEnvelope(ILjava/lang/String;)V

    goto :goto_0

    .line 444
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->sendEnvelope(ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public sendEnvelopeWithStatus(ILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 456
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 457
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 458
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->sendEnvelopeWithStatus(ILjava/lang/String;)V

    goto :goto_0

    .line 460
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->sendEnvelopeWithStatus(ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public sendTerminalResponseToSim(ILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 472
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 473
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 474
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->sendTerminalResponseToSim(ILjava/lang/String;)V

    goto :goto_0

    .line 476
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->sendTerminalResponseToSim(ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public setAidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/sim/IRadioSim;)V
    .locals 0

    .line 46
    iput-object p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 47
    iput-object p2, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    const/4 p1, 0x1

    .line 48
    iput-boolean p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mIsAidl:Z

    const-string p0, "RadioSimProxy"

    const-string p1, "AIDL initialized"

    .line 49
    invoke-static {p0, p1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public setAllowedCarriers(ILandroid/telephony/CarrierRestrictionRules;Landroid/os/Message;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 489
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 490
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_2

    .line 492
    new-instance p3, Landroid/hardware/radio/sim/CarrierRestrictions;

    invoke-direct {p3}, Landroid/hardware/radio/sim/CarrierRestrictions;-><init>()V

    .line 495
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getAllowedCarriers()Ljava/util/List;

    move-result-object v0

    .line 494
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalCarrierRestrictionListAidl(Ljava/util/List;)[Landroid/hardware/radio/sim/Carrier;

    move-result-object v0

    iput-object v0, p3, Landroid/hardware/radio/sim/CarrierRestrictions;->allowedCarriers:[Landroid/hardware/radio/sim/Carrier;

    .line 497
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getExcludedCarriers()Ljava/util/List;

    move-result-object v0

    .line 496
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalCarrierRestrictionListAidl(Ljava/util/List;)[Landroid/hardware/radio/sim/Carrier;

    move-result-object v0

    iput-object v0, p3, Landroid/hardware/radio/sim/CarrierRestrictions;->excludedCarriers:[Landroid/hardware/radio/sim/Carrier;

    .line 499
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getDefaultCarrierRestriction()I

    move-result v0

    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    move v1, v2

    :goto_0
    iput-boolean v1, p3, Landroid/hardware/radio/sim/CarrierRestrictions;->allowedCarriersPrioritized:Z

    .line 501
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    .line 503
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getMultiSimPolicy()I

    move-result p2

    .line 502
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalSimLockMultiSimPolicyAidl(I)I

    move-result p2

    .line 501
    invoke-interface {p0, p1, p3, p2}, Landroid/hardware/radio/sim/IRadioSim;->setAllowedCarriers(ILandroid/hardware/radio/sim/CarrierRestrictions;I)V

    goto/16 :goto_3

    .line 504
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v3, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 506
    new-instance p3, Landroid/hardware/radio/V1_4/CarrierRestrictionsWithPriority;

    invoke-direct {p3}, Landroid/hardware/radio/V1_4/CarrierRestrictionsWithPriority;-><init>()V

    .line 509
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getAllowedCarriers()Ljava/util/List;

    move-result-object v0

    .line 508
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalCarrierRestrictionList(Ljava/util/List;)Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p3, Landroid/hardware/radio/V1_4/CarrierRestrictionsWithPriority;->allowedCarriers:Ljava/util/ArrayList;

    .line 511
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getExcludedCarriers()Ljava/util/List;

    move-result-object v0

    .line 510
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalCarrierRestrictionList(Ljava/util/List;)Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p3, Landroid/hardware/radio/V1_4/CarrierRestrictionsWithPriority;->excludedCarriers:Ljava/util/ArrayList;

    .line 513
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getDefaultCarrierRestriction()I

    move-result v0

    if-nez v0, :cond_3

    goto :goto_1

    :cond_3
    move v1, v2

    :goto_1
    iput-boolean v1, p3, Landroid/hardware/radio/V1_4/CarrierRestrictionsWithPriority;->allowedCarriersPrioritized:Z

    .line 515
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    .line 517
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getMultiSimPolicy()I

    move-result p2

    .line 516
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalSimLockMultiSimPolicy(I)I

    move-result p2

    .line 515
    invoke-interface {p0, p1, p3, p2}, Landroid/hardware/radio/V1_4/IRadio;->setAllowedCarriers_1_4(ILandroid/hardware/radio/V1_4/CarrierRestrictionsWithPriority;I)V

    goto :goto_3

    .line 519
    :cond_4
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->isAllCarriersAllowed()Z

    move-result v0

    if-nez v0, :cond_5

    .line 521
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getExcludedCarriers()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_6

    .line 522
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getDefaultCarrierRestriction()I

    move-result v3

    if-nez v3, :cond_6

    .line 525
    :cond_5
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getMultiSimPolicy()I

    move-result v3

    .line 524
    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertToHalSimLockMultiSimPolicy(I)I

    move-result v3

    if-nez v3, :cond_6

    goto :goto_2

    :cond_6
    move v1, v2

    :goto_2
    if-nez v1, :cond_8

    if-eqz p3, :cond_7

    const/4 p0, 0x0

    const/4 p1, 0x6

    .line 532
    invoke-static {p1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p1

    .line 531
    invoke-static {p3, p0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 533
    invoke-virtual {p3}, Landroid/os/Message;->sendToTarget()V

    :cond_7
    return-void

    .line 539
    :cond_8
    new-instance p3, Landroid/hardware/radio/V1_0/CarrierRestrictions;

    invoke-direct {p3}, Landroid/hardware/radio/V1_0/CarrierRestrictions;-><init>()V

    .line 542
    invoke-virtual {p2}, Landroid/telephony/CarrierRestrictionRules;->getAllowedCarriers()Ljava/util/List;

    move-result-object p2

    .line 541
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCarrierRestrictionList(Ljava/util/List;)Ljava/util/ArrayList;

    move-result-object p2

    iput-object p2, p3, Landroid/hardware/radio/V1_0/CarrierRestrictions;->allowedCarriers:Ljava/util/ArrayList;

    .line 543
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0, p3}, Landroid/hardware/radio/V1_0/IRadio;->setAllowedCarriers(IZLandroid/hardware/radio/V1_0/CarrierRestrictions;)V

    :goto_3
    return-void
.end method

.method public setCarrierInfoForImsiEncryption(ILandroid/telephony/ImsiEncryptionInfo;)V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 555
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_8

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_2

    .line 556
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 557
    new-instance v0, Landroid/hardware/radio/sim/ImsiEncryptionInfo;

    invoke-direct {v0}, Landroid/hardware/radio/sim/ImsiEncryptionInfo;-><init>()V

    .line 559
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getMnc()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/sim/ImsiEncryptionInfo;->mnc:Ljava/lang/String;

    .line 560
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getMcc()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/sim/ImsiEncryptionInfo;->mcc:Ljava/lang/String;

    .line 561
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getKeyIdentifier()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/sim/ImsiEncryptionInfo;->keyIdentifier:Ljava/lang/String;

    .line 562
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 563
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/Date;->getTime()J

    move-result-wide v1

    iput-wide v1, v0, Landroid/hardware/radio/sim/ImsiEncryptionInfo;->expirationTime:J

    .line 565
    :cond_1
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getPublicKey()Ljava/security/PublicKey;

    move-result-object v1

    invoke-interface {v1}, Ljava/security/PublicKey;->getEncoded()[B

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/sim/ImsiEncryptionInfo;->carrierKey:[B

    .line 566
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getKeyType()I

    move-result p2

    int-to-byte p2, p2

    iput-byte p2, v0, Landroid/hardware/radio/sim/ImsiEncryptionInfo;->keyType:B

    .line 568
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/sim/IRadioSim;->setCarrierInfoForImsiEncryption(ILandroid/hardware/radio/sim/ImsiEncryptionInfo;)V

    goto/16 :goto_2

    .line 569
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_5

    .line 570
    new-instance v0, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;-><init>()V

    .line 572
    iget-object v2, v0, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;->base:Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;

    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getMnc()Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->mnc:Ljava/lang/String;

    .line 573
    iget-object v2, v0, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;->base:Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;

    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getMcc()Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->mcc:Ljava/lang/String;

    .line 574
    iget-object v2, v0, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;->base:Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;

    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getKeyIdentifier()Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->keyIdentifier:Ljava/lang/String;

    .line 575
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v2

    if-eqz v2, :cond_3

    .line 576
    iget-object v2, v0, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;->base:Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;

    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v3

    invoke-virtual {v3}, Ljava/util/Date;->getTime()J

    move-result-wide v3

    iput-wide v3, v2, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->expirationTime:J

    .line 578
    :cond_3
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getPublicKey()Ljava/security/PublicKey;

    move-result-object v2

    invoke-interface {v2}, Ljava/security/PublicKey;->getEncoded()[B

    move-result-object v2

    array-length v3, v2

    :goto_0
    if-ge v1, v3, :cond_4

    aget-byte v4, v2, v1

    .line 579
    iget-object v5, v0, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;->base:Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;

    iget-object v5, v5, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->carrierKey:Ljava/util/ArrayList;

    new-instance v6, Ljava/lang/Byte;

    invoke-direct {v6, v4}, Ljava/lang/Byte;-><init>(B)V

    invoke-virtual {v5, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 581
    :cond_4
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getKeyType()I

    move-result p2

    int-to-byte p2, p2

    iput-byte p2, v0, Landroid/hardware/radio/V1_6/ImsiEncryptionInfo;->keyType:B

    .line 583
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_6/IRadio;->setCarrierInfoForImsiEncryption_1_6(ILandroid/hardware/radio/V1_6/ImsiEncryptionInfo;)V

    goto :goto_2

    .line 586
    :cond_5
    new-instance v0, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;-><init>()V

    .line 588
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getMnc()Ljava/lang/String;

    move-result-object v2

    iput-object v2, v0, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->mnc:Ljava/lang/String;

    .line 589
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getMcc()Ljava/lang/String;

    move-result-object v2

    iput-object v2, v0, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->mcc:Ljava/lang/String;

    .line 590
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getKeyIdentifier()Ljava/lang/String;

    move-result-object v2

    iput-object v2, v0, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->keyIdentifier:Ljava/lang/String;

    .line 591
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v2

    if-eqz v2, :cond_6

    .line 592
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v2

    invoke-virtual {v2}, Ljava/util/Date;->getTime()J

    move-result-wide v2

    iput-wide v2, v0, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->expirationTime:J

    .line 594
    :cond_6
    invoke-virtual {p2}, Landroid/telephony/ImsiEncryptionInfo;->getPublicKey()Ljava/security/PublicKey;

    move-result-object p2

    invoke-interface {p2}, Ljava/security/PublicKey;->getEncoded()[B

    move-result-object p2

    array-length v2, p2

    :goto_1
    if-ge v1, v2, :cond_7

    aget-byte v3, p2, v1

    .line 595
    iget-object v4, v0, Landroid/hardware/radio/V1_1/ImsiEncryptionInfo;->carrierKey:Ljava/util/ArrayList;

    new-instance v5, Ljava/lang/Byte;

    invoke-direct {v5, v3}, Ljava/lang/Byte;-><init>(B)V

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 598
    :cond_7
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_1/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_1/IRadio;->setCarrierInfoForImsiEncryption(ILandroid/hardware/radio/V1_1/ImsiEncryptionInfo;)V

    :cond_8
    :goto_2
    return-void
.end method

.method public setCdmaSubscriptionSource(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 610
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 611
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 612
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->setCdmaSubscriptionSource(II)V

    goto :goto_0

    .line 614
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setCdmaSubscriptionSource(II)V

    :goto_0
    return-void
.end method

.method public setFacilityLockForApp(ILjava/lang/String;ZLjava/lang/String;ILjava/lang/String;)V
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 630
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 631
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 632
    iget-object v1, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    move v2, p1

    move-object v3, p2

    move v4, p3

    move-object v5, p4

    move v6, p5

    move-object v7, p6

    invoke-interface/range {v1 .. v7}, Landroid/hardware/radio/sim/IRadioSim;->setFacilityLockForApp(ILjava/lang/String;ZLjava/lang/String;ILjava/lang/String;)V

    goto :goto_0

    .line 635
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move v3, p1

    move-object v4, p2

    move v5, p3

    move-object v6, p4

    move v7, p5

    move-object v8, p6

    invoke-interface/range {v2 .. v8}, Landroid/hardware/radio/V1_0/IRadio;->setFacilityLockForApp(ILjava/lang/String;ZLjava/lang/String;ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public setSimCardPower(IILandroid/os/Message;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 648
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 649
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 650
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->setSimCardPower(II)V

    goto :goto_0

    .line 651
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 652
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->setSimCardPower_1_6(II)V

    goto :goto_0

    .line 653
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 654
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_1/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_1/IRadio;->setSimCardPower_1_1(II)V

    goto :goto_0

    :cond_3
    if-eqz p2, :cond_5

    const/4 v0, 0x1

    if-eq p2, v0, :cond_4

    if-eqz p3, :cond_6

    const/4 p0, 0x0

    const/4 p1, 0x6

    .line 668
    invoke-static {p1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p1

    .line 667
    invoke-static {p3, p0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 669
    invoke-virtual {p3}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    .line 662
    :cond_4
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->setSimCardPower(IZ)V

    goto :goto_0

    .line 658
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    const/4 p2, 0x0

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setSimCardPower(IZ)V

    :cond_6
    :goto_0
    return-void
.end method

.method public setUiccSubscription(IIIII)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 687
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 688
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 689
    new-instance v0, Landroid/hardware/radio/sim/SelectUiccSub;

    invoke-direct {v0}, Landroid/hardware/radio/sim/SelectUiccSub;-><init>()V

    .line 691
    iput p2, v0, Landroid/hardware/radio/sim/SelectUiccSub;->slot:I

    .line 692
    iput p3, v0, Landroid/hardware/radio/sim/SelectUiccSub;->appIndex:I

    .line 693
    iput p4, v0, Landroid/hardware/radio/sim/SelectUiccSub;->subType:I

    .line 694
    iput p5, v0, Landroid/hardware/radio/sim/SelectUiccSub;->actStatus:I

    .line 695
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/sim/IRadioSim;->setUiccSubscription(ILandroid/hardware/radio/sim/SelectUiccSub;)V

    goto :goto_0

    .line 697
    :cond_1
    new-instance v0, Landroid/hardware/radio/V1_0/SelectUiccSub;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/SelectUiccSub;-><init>()V

    .line 699
    iput p2, v0, Landroid/hardware/radio/V1_0/SelectUiccSub;->slot:I

    .line 700
    iput p3, v0, Landroid/hardware/radio/V1_0/SelectUiccSub;->appIndex:I

    .line 701
    iput p4, v0, Landroid/hardware/radio/V1_0/SelectUiccSub;->subType:I

    .line 702
    iput p5, v0, Landroid/hardware/radio/V1_0/SelectUiccSub;->actStatus:I

    .line 703
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->setUiccSubscription(ILandroid/hardware/radio/V1_0/SelectUiccSub;)V

    :goto_0
    return-void
.end method

.method public supplyIccPin2ForApp(ILjava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 715
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 716
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 717
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/sim/IRadioSim;->supplyIccPin2ForApp(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 719
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->supplyIccPin2ForApp(ILjava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public supplyIccPinForApp(ILjava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 731
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 732
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 733
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/sim/IRadioSim;->supplyIccPinForApp(ILjava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 735
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->supplyIccPinForApp(ILjava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public supplyIccPuk2ForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 749
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 750
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 751
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/sim/IRadioSim;->supplyIccPuk2ForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 753
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_0/IRadio;->supplyIccPuk2ForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public supplyIccPukForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 767
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 768
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 769
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/sim/IRadioSim;->supplyIccPukForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 771
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_0/IRadio;->supplyIccPukForApp(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public supplySimDepersonalization(ILcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 784
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 785
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 786
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    .line 787
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalPersoTypeAidl(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;)I

    move-result p2

    .line 786
    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/sim/IRadioSim;->supplySimDepersonalization(IILjava/lang/String;)V

    goto :goto_0

    .line 789
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    .line 790
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalPersoType(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;)I

    move-result p2

    .line 789
    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_5/IRadio;->supplySimDepersonalization(IILjava/lang/String;)V

    :cond_2
    :goto_0
    return-void
.end method

.method public updateSimPhonebookRecords(ILcom/android/internal/telephony/uicc/SimPhonebookRecord;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 802
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioSimProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 803
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 804
    iget-object p0, p0, Lcom/android/internal/telephony/RadioSimProxy;->mSimProxy:Landroid/hardware/radio/sim/IRadioSim;

    .line 805
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalPhonebookRecordInfoAidl(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Landroid/hardware/radio/sim/PhonebookRecordInfo;

    move-result-object p2

    .line 804
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/sim/IRadioSim;->updateSimPhonebookRecords(ILandroid/hardware/radio/sim/PhonebookRecordInfo;)V

    goto :goto_0

    .line 807
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    .line 808
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalPhonebookRecordInfo(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Landroid/hardware/radio/V1_6/PhonebookRecordInfo;

    move-result-object p2

    .line 807
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->updateSimPhonebookRecords(ILandroid/hardware/radio/V1_6/PhonebookRecordInfo;)V

    :cond_2
    :goto_0
    return-void
.end method
